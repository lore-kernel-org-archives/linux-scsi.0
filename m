From: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Subject: Re: [bug report][scsi blk_mq] data corruption due to a bug in SCSI
 LLD error handling
Date: Wed, 3 Apr 2019 17:06:21 -0400
Message-ID: <b3b72ebf-3402-1dfc-5dd6-fbaca65171ed@interlog.com>
References: <CAJX3CtjkBYRa21OetDfCZ0W5UZyjzCwBw8C9ZnBKnDOcrKJP3A@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Return-path: <open-iscsi+bncBDGIZD433YCRBVOASTSQKGQECWFDMEQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CAJX3CtjkBYRa21OetDfCZ0W5UZyjzCwBw8C9ZnBKnDOcrKJP3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-CA
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Jaesoo Lee <jalee-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 2019-04-03 4:18 p.m., Jaesoo Lee wrote:
> Hello All,
> 
> I encountered this bug while trying to enable dm_blk_mq for our
> iSCSI/FCP targets.
> 
> The bug is that the sg_io issued to scsi_blk_mq would succeed even if
> LLD wants to error out those requests.
> 
> Let me explain the scenario in more details.
> 
> Setup:
> 0. Host kernel configuration
> - 4.19.9, 4.20.16
> - boot parameter: dm_mod.use_blk_mq=Y scsi_mod.use_blk_mq=Y
> scsi_transport_iscsi.debug_session=1 scsi_transport_iscsi.debug_conn=1
> 
> Scenario:
> 1. Connect the host to iSCSI target via four paths
> : A dm device is created for those target devices
> 2. Start an application in the host which generates sg_io ioctl for
> XCOPY and WSAME to the dm device with the ratio of around 50%
> (pread/pwrite for the rest).
> 3. Perform system crash (sysrq-trigger) in the iSCSI target
> 
> Expected result:
> - Any outstanding IOs should get failed with errors
> 
> Actual results:
> - Normal read/write IOs get failed as expected
> - SG_IO ioctls SUCCEEDED!!

Not all ioctl(SG_IO)s are created equal!

If you are using the sg v3 interface (i.e. struct sg_io_hdr) then I would
expect DRIVER_TIMEOUT in sg_io_obj.driver_status or DID_TIME_OUT in
sg_io_obj.host_status to be set on completion. [BTW You will _not_ see
a ETIMEDOUT errno; only errors prior to submission yield errno style
errors.]

If you don't see that with ioctl(SG_IO) on a block device then try again on
a sg device. If neither report that then the mid-level error processing
is broken.

Doug Gilbert


> - log message:
> [Tue Apr  2 11:26:34 2019]  session3: session recovery timed out after 11 secs
> [Tue Apr  2 11:26:34 2019]  session3: session_recovery_timedout:
> Unblocking SCSI target
> ..
> [Tue Apr  2 11:26:34 2019] sd 8:0:0:8: scsi_prep_state_check:
> rejecting I/O to offline device
> [Tue Apr  2 11:26:34 2019] sd 8:0:0:8: scsi_prep_state_check:
> rejecting I/O to offline device
> [Tue Apr  2 11:26:34 2019] sd 8:0:0:8: scsi_prep_state_check:
> rejecting I/O to offline device
> [Tue Apr  2 11:26:34 2019] print_req_error: I/O error, dev sdi, sector 30677580
> [Tue Apr  2 11:26:34 2019] device-mapper: multipath: Failing path 8:128.
> [Tue Apr  2 11:26:34 2019] SG_IO disk=sdi, result=0x0
> 
> - This causes the DATA corruption for the application
> 
> Relavant call stacks: (SG_IO issue path)
> [Tue Apr  2 11:26:33 2019] sd 8:0:0:8: [sdi] sd_ioctl: disk=sdi, cmd=0x2285
> [Tue Apr  2 11:26:33 2019] SG_IO disk=sdi, retried 1 cmd 93
> [Tue Apr  2 11:26:33 2019] CPU: 30 PID: 16080 Comm: iostress Not
> tainted 4.19.9-purekernel_dbg.x86_64+ #30
> [Tue Apr  2 11:26:33 2019] Hardware name:  /0JP31P, BIOS 2.0.19 08/29/2013
> [Tue Apr  2 11:26:33 2019] Call Trace:
> [Tue Apr  2 11:26:33 2019]  dump_stack+0x63/0x85
> [Tue Apr  2 11:26:33 2019]  sg_io+0x41e/0x480
> [Tue Apr  2 11:26:33 2019]  scsi_cmd_ioctl+0x297/0x420
> [Tue Apr  2 11:26:33 2019]  ? sdev_prefix_printk+0xe9/0x120
> [Tue Apr  2 11:26:33 2019]  ? _cond_resched+0x1a/0x50
> [Tue Apr  2 11:26:33 2019]  scsi_cmd_blk_ioctl+0x51/0x70
> [Tue Apr  2 11:26:33 2019]  sd_ioctl+0x95/0x1a0 [sd_mod]
> [Tue Apr  2 11:26:33 2019]  __blkdev_driver_ioctl+0x25/0x30
> [Tue Apr  2 11:26:33 2019]  dm_blk_ioctl+0x79/0x100 [dm_mod]
> [Tue Apr  2 11:26:33 2019]  blkdev_ioctl+0x89a/0x940
> [Tue Apr  2 11:26:33 2019]  ? do_nanosleep+0xae/0x180
> [Tue Apr  2 11:26:33 2019]  block_ioctl+0x3d/0x50
> [Tue Apr  2 11:26:33 2019]  do_vfs_ioctl+0xa6/0x600
> [Tue Apr  2 11:26:33 2019]  ? __audit_syscall_entry+0xe9/0x130
> [Tue Apr  2 11:26:33 2019]  ksys_ioctl+0x6d/0x80
> ).[Tue Apr  2 11:26:33 2019]  __x64_sys_ioctl+0x1a/0x20
> [Tue Apr  2 11:26:33 2019]  do_syscall_64+0x60/0x180
> [Tue Apr  2 11:26:33 2019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> According to the analysis, it seems that there is a bug in propagating
> errors for iSCSI session timeout (i.e., session_recovery_timedout).
> Compared to this, legacy SCSI queue handles the errors in
> scsi_request_fn by killing the request as can be seen below.
> 
> 1872 static void scsi_request_fn(struct request_queue *q)
> 1873         __releases(q->queue_lock)
> 1874         __acquires(q->queue_lock)
> 1875 {
> ..
> 1886         for (;;) {
> ..
> 1893                 req = blk_peek_request(q);
> 1894                 if (!req)
> 1895                         break;
> 1896
> 1897                 if (unlikely(!scsi_device_online(sdev))) {
> 1898                         sdev_printk(KERN_ERR, sdev,
> 1899                                     "scsi_request_fn: rejecting
> I/O to offline device\n");
> 1900                         scsi_kill_request(req, q);
> 1901                         continue;
> 1902                 }
> 1903
> 
> I am not sure in which layer we have to fix this, LLD or scsi_queue_rq().
> 
> Could someone please take a look? Or, could someone guide me on how to
> fix this bug?
> 
> Thanks,
> 
> Jaesoo Lee.
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
