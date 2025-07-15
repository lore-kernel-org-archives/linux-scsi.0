Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1562018DB1A;
	Tue, 15 Jul 2025 03:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752548717; cv=none; b=DMBb4qDh0AmqYqmK2b5sUBmAfV0+jIxKCArjpfX6dp3QCkZzcqkSQZqUrETnD1qpdRHjuGSwmi0U62frjWt3+b7ylUN/7BhcnFSVjDWVDpQP6A6S9OvWZOXUNretqEuZhoiUZ4C5G2bXb0NBqei1Pr9h87kK+zNXIq3P9eF82p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752548717; c=relaxed/simple;
	bh=Pfe8WObDT1a61jiVOqq1FN+hlv1UJ6niselMJ1QVSYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nRJM9xVOKazotXYhsUANf6J8B2goSALDE3iLTaDi7uutCEqo7xdMhmzkySh1Irhro1pfHrtFC+Wwre1h/g+R3l8JbeZtjs8tsqet1AuO98WYyxmcCjGZO1l9gcKX+6DwvlVX/tCiu0bgQVaq6ZQhrIU7lkquRiErZsZQ9Oyc6TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bh3q20LpxzHrRx;
	Tue, 15 Jul 2025 11:01:02 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id AA5C41401F3;
	Tue, 15 Jul 2025 11:05:08 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 11:05:07 +0800
Message-ID: <88334658-072b-4b90-a949-9c74ef93cfd1@huawei.com>
Date: Tue, 15 Jul 2025 11:05:07 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH 1/6] scsi: iscsi: Fix HW conn removal use after free
To: Hou Tao <houtao@huaweicloud.com>, Mike Christie
	<michael.christie@oracle.com>
CC: <lduncan@suse.com>, <cleech@redhat.com>, <njavali@marvell.com>,
	<mrangankar@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<jejb@linux.ibm.com>, yangerkun <yangerkun@huawei.com>, "yukuai (C)"
	<yukuai3@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <open-iscsi@googlegroups.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Li Lingfeng
	<lilingfeng@huaweicloud.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
 <20220616222738.5722-2-michael.christie@oracle.com>
 <93484c2e-528e-46a1-83d6-c420e0d2a1ef@huawei.com>
 <bb21e728-ae5d-4328-8076-78c2f984ee05@huawei.com>
 <0b0a0bcf-b805-5041-9923-37ad391169c0@huaweicloud.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <0b0a0bcf-b805-5041-9923-37ad391169c0@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemg500017.china.huawei.com (7.202.181.81)

Hi all,

在 2025/7/3 17:40, Hou Tao 写道:
> Hi Mike & Lingfeng:
>
> On 7/3/2025 9:35 AM, Li Lingfeng wrote:
>> Friendly ping...
>>
>> Thanks
>>
>> 在 2025/6/19 20:57, Li Lingfeng 写道:
>>> Hi Mike,
>>>
>>> Thanks for this patch addressing the UAF issue. I have some questions
>>> when
>>> analyzing this patch.
>>>
>>> You mention that iscsi_remove_conn() frees the connection, making the
>>> extra
>>> iscsi_put_conn() cause UAF. However, looking at iscsi_remove_conn():
>>>
>>> iscsi_remove_conn
>>>   device_del(&conn->dev)
>>>    put_device(parent) // Only parent gets put_device
>>>
>>> This doesn't appear to free conn directly - only device_del() + parent
>>> reference drop. Typically, conn is freed via put_device() on
>>> &conn->dev when
>>> its refcount reaches zero.
>>>
>>> Could you briefly clarify how iscsi_remove_conn() ultimately triggers
>>> the
>>> freeing, and in what scenario the subsequent iscsi_put_conn() leads
>>> to UAF?
>>>
>>> Thanks again for the fix.
>>>
>>> Lingfeng
>>>
>>> 在 2022/6/17 6:27, Mike Christie 写道:
>>>> If qla4xxx doesn't remove the connection before the session, the iSCSI
>>>> class tries to remove the connection for it. We were doing a
>>>> iscsi_put_conn() in the iter function which is not needed and will
>>>> result
>>>> in a use after free because iscsi_remove_conn() will free the
>>>> connection.
>>>>
>>>> Reviewed-by: Lee Duncan <lduncan@suse.com>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>    drivers/scsi/scsi_transport_iscsi.c | 2 --
>>>>    1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c
>>>> b/drivers/scsi/scsi_transport_iscsi.c
>>>> index 2c0dd64159b0..e6084e158cc0 100644
>>>> --- a/drivers/scsi/scsi_transport_iscsi.c
>>>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>>>> @@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct
>>>> device *dev, void *data)
>>>>            return 0;
>>>>          iscsi_remove_conn(iscsi_dev_to_conn(dev));
>>>> -    iscsi_put_conn(iscsi_dev_to_conn(dev));
>>>> -
>>>>        return 0;
>>>>    }
>> .
> I didn't follow the patch either. If I understand correctly, the
> invocation of  iscsi_put_conn() in iscsi_iter_destory_conn_fn() is used
> to free the initial reference counter of iscsi_cls_conn. For non-qla4xxx
> cases, the ->destroy_conn() callback (e.g., iscsi_conn_teardown) will
> call iscsi_remove_conn() and iscsi_put_conn() to remove the connection
> from the children list of session and free the connection at last.
> However for qla4xxx, it is not the case. The ->destroy_conn() callback
> of qla4xxx will keep the connection in the session conn_list and doesn't
> use iscsi_put_conn() to free the initial reference counter. Therefore,
> it seems necessary to keep the iscsi_put_conn() in the
> iscsi_iter_destroy_conn_fn(), otherwise, there will be memory leak problem.
This patch indeed caused a memory leak. I reproduced the leak issue and
confirmed that reintroducing the removed iscsi_put_conn() prevents the
leak in the same scenario.


*kernel base:*
master 8c2e52ebbe885c7eeaabd3b7ddcdc1246fc400d2


*kernel diff:*
1) Since I don't have the device that supports qla4xxx, I forcibly
bypassed the connection check during session destruction;
2) I expanded the memory required by conn by 1024 times to more clearly
observe the memory changes.

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7b4fe0e6afb2..bb354deeb668 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -940,8 +940,12 @@ static void iscsi_sw_tcp_session_destroy(struct 
iscsi_cls_session *cls_session)
         struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
         struct iscsi_session *session = cls_session->dd_data;

-       if (WARN_ON_ONCE(session->leadconn))
-               return;
+       if (WARN_ON_ONCE(session->leadconn)) {
+               printk("%s skip checking leadconn", __func__);
+       //      return;
+       }
+
+       printk("%s %d\n", __func__, __LINE__);

         iscsi_session_remove(cls_session);
         /*
diff --git a/drivers/scsi/scsi_transport_iscsi.c 
b/drivers/scsi/scsi_transport_iscsi.c
index c75a806496d6..eac353ad536f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2408,7 +2408,7 @@ iscsi_alloc_conn(struct iscsi_cls_session 
*session, int dd_size, uint32_t cid)
         struct iscsi_transport *transport = session->transport;
         struct iscsi_cls_conn *conn;

-       conn = kzalloc(sizeof(*conn) + dd_size, GFP_KERNEL);
+       conn = kzalloc((sizeof(*conn) + dd_size) * 1024, GFP_KERNEL);
         if (!conn)
                 return NULL;
         if (dd_size)
@@ -2984,6 +2984,7 @@ iscsi_if_destroy_conn(struct iscsi_transport 
*transport, struct iscsi_uevent *ev

         if (transport->destroy_conn)
                 transport->destroy_conn(conn);
+
         return 0;
  }

@@ -3937,13 +3938,20 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct 
nlmsghdr *nlh, uint32_t *group)
                 iscsi_put_endpoint(ep);
                 break;
         case ISCSI_UEVENT_DESTROY_SESSION:
+               printk("%s %d skip checking conns\n", __func__, __LINE__);
                 session = iscsi_session_lookup(ev->u.d_session.sid);
-               if (!session)
+               if (!session) {
+                       printk("%s %d\n", __func__, __LINE__);
                         err = -EINVAL;
-               else if (iscsi_session_has_conns(ev->u.d_session.sid))
+/*
+               } else if (iscsi_session_has_conns(ev->u.d_session.sid)) {
+                       printk("%s %d\n", __func__, __LINE__);
                         err = -EBUSY;
-               else
+*/
+               } else {
+                       printk("%s %d\n", __func__, __LINE__);
                         transport->destroy_session(session);
+               }
                 break;
         case ISCSI_UEVENT_DESTROY_SESSION_ASYNC:
                 session = iscsi_session_lookup(ev->u.d_session.sid);


*open-iscsi base:*
master 5b49cf2a86b1bfce13082f8ddc90b2282feb563d


*open-iscsi diff:*
I forcibly bypassed the standard connection destruction procedure, so
that during the session destruction process, the connection would be
destroyed to trigger iscsi_iter_destroy_conn_fn().

diff --git a/usr/netlink.c b/usr/netlink.c
index 4bcaf8b..970d782 100644
--- a/usr/netlink.c
+++ b/usr/netlink.c
@@ -516,12 +516,15 @@ kcreate_conn(uint64_t transport_handle, uint32_t sid,
  static int
  kdestroy_conn(uint64_t transport_handle, uint32_t sid, uint32_t cid)
  {
-       int rc;
-       struct iscsi_uevent ev;
-       struct iovec iov[2];
-
+//     int rc;
+//     struct iscsi_uevent ev;
+//     struct iovec iov[2];
+       (void)transport_handle;
+       (void)sid;
+       (void)cid;
         log_debug(7, "in %s", __FUNCTION__);
-
+       printf("skip destroy conn\n");
+/*
         memset(&ev, 0, sizeof(struct iscsi_uevent));

         ev.type = ISCSI_UEVENT_DESTROY_CONN;
@@ -534,7 +537,7 @@ kdestroy_conn(uint64_t transport_handle, uint32_t 
sid, uint32_t cid)
         rc = __kipc_call(iov, 2);
         if (rc < 0)
                 return rc;
-
+*/
         return 0;
  }


*test script:*
#!/bin/bash
LOOP_TIMES=10000
LOG_FILE="iscsi_opt.log"
DEVICE_TYPE="VIRTUAL-DISK"

for ((count=1; count<=LOOP_TIMES; count++)); do
     iscsiadm -m node -l &>/dev/null &
     login_pid=$!
     login_start=$(date +%s)
     device_found=0

     while kill -0 $login_pid 2>/dev/null; do
         sleep 0.5
         elapsed=$(( $(date +%s) - login_start ))

         if [ $elapsed -ge 30 ]; then
             if lsscsi | grep -q "$DEVICE_TYPE"; then
                 kill $login_pid 2>/dev/null
                 status="DEVICE_READY (KILLED_TIMEOUT)"
                 device_found=1
                 break
             fi
         fi
     done

     if [ $device_found -eq 0 ]; then
         wait $login_pid
         status="ATTACHED"
     fi

     mem_login=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
     printf "%-6d %-12d %-8s %s\n" $count $mem_login "LOGIN" "$status" | 
tee -a $LOG_FILE

     iscsiadm -m node -u &>/dev/null
     while iscsiadm -m session &>/dev/null; do sleep 0.1; done
     mem_logout=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
     printf "%-6d %-12d %-8s %s\n" $count $mem_logout "LOGOUT" "SUCCESS" 
| tee -a $LOG_FILE
done


*result without iscsi_put_conn():*
1) After a certain number of cycles, the available memory significantly
decreases.
1      53738028     LOGIN    ATTACHED
1      53735616     LOGOUT   SUCCESS
...
100    52453148     LOGIN    ATTACHED
100    52453376     LOGOUT   SUCCESS
...
200    51122008     LOGIN    ATTACHED
200    51122644     LOGOUT   SUCCESS
...
2108   25984180     LOGIN    ATTACHED
2108   25995580     LOGOUT   SUCCESS

2) After removing iSCSI devices, stopping related services, and unloading
kernel modules, the available memory has not returned to the expected
level.
[root@fedora test_ko]# lsscsi
[0:0:0:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sda
[0:0:1:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sdb
[0:0:2:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sdc
[0:0:3:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sdd
[0:0:4:0]    disk    QEMU     QEMU HARDDISK    2.5+  /dev/sde
[root@fedora test_ko]# service iscsid stop
Redirecting to /bin/systemctl stop iscsid.service
Warning: Stopping iscsid.service, but it can still be activated by:
   iscsid.socket
[root@fedora test_ko]# service tgtd stop
Redirecting to /bin/systemctl stop tgtd.service
[root@fedora test_ko]# rmmod iscsi_tcp
[root@fedora test_ko]# rmmod iscsi_boot_sysfs
[root@fedora test_ko]# rmmod libiscsi_tcp
[root@fedora test_ko]# rmmod libiscsi
[root@fedora test_ko]# rmmod scsi_transport_iscsi
[root@fedora test_ko]# cat /proc/meminfo | grep MemAvailable
MemAvailable:   26063488 kB
[root@fedora test_ko]# cat /proc/meminfo | grep MemAvailable
MemAvailable:   26065000 kB
[root@fedora test_ko]#


*result with iscsi_put_conn():*
After a certain number of cycles, the available memory does not show
significant changes.
1      53823120     LOGIN    ATTACHED
1      53828420     LOGOUT   SUCCESS
...
100    53738576     LOGIN    ATTACHED
100    53747436     LOGOUT   SUCCESS
...
200    53723400     LOGIN    ATTACHED
200    53728696     LOGOUT   SUCCESS
...

I haven't found more details about the UAF issue described in this patch,
but I think the patch's description of the root cause 'iscsi_remove_conn()
will free the connection' is incorrect. Moreover, this fix approach is
inappropriate.
Until the original issue is fully understood, I recommend reverting this
patch.

Thanks,

Lingfeng


> For the use-after-free problem, I think it may be due to the concurrent
> invocation of iscsi_add_conn() and iscsi_session_teardown().
> iscsi_add_conn() has already invoked device_add(), but fails on
> transport_register_device() and is trying to invoke device_del(). At the
> same time iscsi_session_teardown() invokes iscsi_remove_session() and is
> invoking iscsi_iter_destroy_conn_fn for the failed-to-add connection.
> The connection will be put twice: one in iscsi_iter_destroy_conn_fn()
> and another one in iscsi_conn_setup() and leads to use-after-free problem.
>
