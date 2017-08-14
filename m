From: "Tangchen (UVP)" <tang.chen@huawei.com>
Subject: [iscsi] Deadlock occurred when network is in error
Date: Mon, 14 Aug 2017 11:23:59 +0000
Message-ID: <22E823DBB7698E489DC113638F7470729C17B6@DGGEMM506-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>, "cleech@redhat.com" <cleech@redhat.com>, "lduncan@suse.com" <lduncan@suse.com>
Cc: zhengchuan <zhengchuan@huawei.com>, "Tangchen (UVP)" <tang.chen@huawei.com>, guijianfeng <guijianfeng@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I found two hangup problems between iscsid service and iscsi module. And I can reproduce one
of them in the latest kernel always. So I think the problems really exist. 

It really took me a long time to find out why due to my lack of knowledge of iscsi. But I cannot
find a good way to solve them both.

Please do help to take a look at them. Thx.

=========
Problem 1:

***************
[What it looks like]
***************
First, we connect to 10 remote LUNs with iscsid service with at least two dirrerent sessions. 
When network error occurs, the session could be in error. If we do login and logout, iscsid
service could run into D state.

My colleague has posted an email to report this problem before. And he posted a long call trace.
But barely gain any feedback.
(https://lkml.org/lkml/2017/6/19/330)


**************
[Why it happens]
**************
In the latest kernel, asynchronous part of sd_probe() was executed
in scsi_sd_probe_domain, and sd_remove() would wait until all the
works in scsi_sd_probe_domain finished. When we use iscsi based
remote storage, and the network is broken, the following deadlock
could happen.

1. An iscsi session login is in progress, and calls sd_probe() to
   probe a remote lun. The synchronous part has finished, and the
   asynchronous part is scheduled in scsi_sd_probe_domain, and will
   submit io to execute scsi cmd to obtain device info. When the
   network is broken, the session will go into ISCSI_SESSION_FAILED
   state, and the io will retry until the session becomes
   ISCSI_SESSION_FREE. As a result, the work in scsi_sd_probe_domain
   hangs.

2. On the other hand, iscsi kernel module detects network ping
   timeout, and triggers ISCSI_KEVENT_CONN_ERROR event. iscsid in
   user space will handle this event by triggering
   ISCSI_UEVENT_DESTROY_SESSION event. Destroy session process is
   synchronous, and when it calls sd_remove() to remove the lun,
   it waits until all the works in scsi_sd_probe_domain finish. As
   a result, it hangs, and iscsid in user space goes into D state
   which is not killable, and not able to handle all the other
   events.


****************
[How to reproduce]
****************
With the script below, I can reproduce it in the latest kernel always.

# create network errors
tc qdisc add dev eth1 root netem loss 60%

while [1]
do
        iscsiadm -m node -T xxxxxx -login
        sleep 5
        iscsiadm -m node -T xxxxxx -logout &
        iscsiadm -m node -T yyyyyy -login &
done

xxxxxx and yyyyyy are two different target names.

Connect to about 10 remote LUNs, and run the script for about half an hour will reproduce the problem.


*******************
[How I avoid it for now]
*******************
To avoid this problem, I simply remove scsi_sd_probe_domain, and call sd_probe_async() synchronously in sd_probe().
So sd_remove() doesn't need to wait for the domain again.

@@ -2986,7 +2986,40 @@ static int sd_probe(struct device *dev)
        get_device(&sdkp->dev); /* prevent release before async_schedule */
-       async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
+       sd_probe_async((void *)sdkp, 0);

I know this is not a good way, so would you please give some advice about it ?



=========
Problem 2:

***************
[What it looks like]
***************
When remove a scsi device, and the network error happens, __blk_drain_queue() could hang forever.

# cat /proc/19160/stack 
[<ffffffff8005886d>] msleep+0x1d/0x30
[<ffffffff80201a84>] __blk_drain_queue+0xe4/0x160
[<ffffffff80202766>] blk_cleanup_queue+0x106/0x2e0
[<ffffffffa000fb02>] __scsi_remove_device+0x52/0xc0 [scsi_mod]
[<ffffffffa000fb9b>] scsi_remove_device+0x2b/0x40 [scsi_mod]
[<ffffffffa000fbc0>] sdev_store_delete_callback+0x10/0x20 [scsi_mod]
[<ffffffff801a4e75>] sysfs_schedule_callback_work+0x15/0x80
[<ffffffff80062d69>] process_one_work+0x169/0x340
[<ffffffff800667e3>] worker_thread+0x183/0x490
[<ffffffff8006a526>] kthread+0x96/0xa0
[<ffffffff8041ebb4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

The request queue of this device was stopped. So the following check will be true forever:
__blk_run_queue()
{
        if (unlikely(blk_queue_stopped(q)))
                return;

        __blk_run_queue_uncond(q);
}

So __blk_run_queue_uncond() will never be called, and the process hang.


**************
[Why it happens]
**************
When the network error happens, iscsi kernel module detected the ping timeout and 
tried to recover the session. Here, the queue was stopped, or you can also say 
session was blocked.

iscsi_start_session_recovery(session, conn, flag);
|-> iscsi_block_session(session->cls_session);
       |-> blk_stop_queue(q)

The session should be unblocked if the session is recovered or the recovery times out.
But it was not unblocked properly because scsi_remove_device() deleted the the device 
first, and then called __blk_drain_queue(). 

__scsi_remove_device()
|-> device_del(dev)
|-> blk_cleanup_queue()
      |-> scsi_request_fn()
            |-> __blk_drain_queue()

At this time, the device was not on the children list of the parent device. So when 
__iscsi_unblock_session() tried to unblock the parent device and its children, the removed
device could not be unblocked. And its queue was stopped forever.

__iscsi_unblock_session()
|-> scsi_target_unblock()
      |-> device_for_each_child()


****************
[How to reproduce]
****************
Unfortunately I cannot reproduce it in the latest kernel. 
The script below will help to reproduce, but not very often.

# create network error
tc qdisc add dev eth1 root netem loss 60%

# restart iscsid and rescan scsi bus again and again
while [ 1 ]
do
systemctl restart iscsid
rescan-scsi-bus        (http://manpages.ubuntu.com/manpages/trusty/man8/rescan-scsi-bus.8.html)
done


**************
[How I resolve it]
**************
For now, I resolve this problem by checking QUEUE_FLAG_DYING flag in __blk_run_queue().
blk_cleanup_queue() will set QUEUE_FLAG_DYING, and then call __blk_drain_queue().
At this time, __scsi_remove_device() should have already set scsi_device status to SDEV_DEL.
So if the quese is dying, no matter if the quese is stopped, we goto __blk_run_queue_uncond(),
and then scsi_request_fn() will kill the rest requests.

---
void __blk_run_queue(struct request_queue *q)
{
-       if (unlikely(blk_queue_stopped(q)))
+       if (unlikely(blk_queue_stopped(q)) && unlikely(!blk_queue_dying(q)))
                return;

        __blk_run_queue_uncond(q);
--

Thanks
