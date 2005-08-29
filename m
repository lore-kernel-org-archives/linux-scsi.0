From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: scsi_prep_fn/scsi_request_fn may fail to put scsi_cmnds
Date: Mon, 29 Aug 2005 08:13:20 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF4370243347B@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:14235 "EHLO
	mailhub5.stratus.com") by vger.kernel.org with ESMTP
	id S1750708AbVH2MN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2005 08:13:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

I ran into a problem where scsi_device_cancel encounters scsi_cmnds that
have request pointers that point to freed memory. In one case, the
command was in SCSI_STATE_FINISHED/SCSI_OWNER_HIGHLEVEL; in another it
was SCSI_STATE_UNUSED/SCSI_OWNER_NOBODY. This is where it happens:

1155         list_for_each_entry(scmd, &sdev->cmd_list, list) {
1156                 if (scmd->request && scmd->request->rq_status !=
RQ_INACTIVE) {

This was on a kernel built with the following options:

[*] Kernel debugging
[*]   Magic SysRq key
[*]   Debug memory allocations
[*]   Spinlock debugging
[*]   Sleep-inside-spinlock checking
[*]   Highmem debugging
[*]   Compile the kernel with debug info
[*] Compile the kernel with frame pointers
[*] Check for stack overflows
[ ] Kprobes
[*] Stack utilization instrumentation
[*] Page alloc debugging
[ ] Collect scheduler statistics (NEW)

Doing hba hot remove with disk stress.

This happened on a 2.6.9 kernel (RHEL4), but the involved code looks the
same to me in later kernels.

As best I can tell, there are two problems:

1. In some cases where scsi_prep_fn returns BLKPREP_KILL, it doesn't
take into account the fact that the request may already be associated
with a scsi_command... as would be the case if the request had been
requeued (so it had already been thru scsi_prep_fn before). In this
case, scsi_put_command needs to get called on those commands to remove
them from the device's cmd_list. Otherwise, the BLKPREP_KILL return will
cause the request to get freed, and the command is left hanging out on
the cmd_list where scsi_device_cancel finds it. This is the
SCSI_STATE_FINISHED/SCSI_OWNER_HIGHLEVEL case.

2. scsi_request_fn also has a problem... after calling elv_next_request,
it does a check on !scsi_device_online(sdev). Under this case, if the
device isn't online the request gets freed... but scsi_put_command
doesn't get called on the command that scsi_prep_fn had attached to the
request. Again, the scsi_cmnd is left on the device's cmd_list. This is
the SCSI_STATE_UNUSED/SCSI_OWNER_NOBODY case.

I put together a patch (at the bottom of this email) which seems to fix
the problem. I'm not suggesting that this is the best possible way to
fix it... my patch calls a routine from scsi_prep_fn when BLKPREP_KILL
is about to be returned, and this routine duplicates the logic already
contained in scsi_prep_fn to detect if the request is associated with a
command. I'd rather have the fix worked into the prep_fn somehow. But I
felt a bit nervous re-arranging too much of this code (didn't want to
cause more problems than I'm fixing), and I didn't see a straightforward
way to do it. So I'm wondering if anyone on this list might have any
suggestions for a better way to fix this?

Thanks!

Nate Dailey
Stratus Technologies


here's the patch...

Signed-off-by: Nate Dailey <nate.dailey@stratus.com>

--- scsi_lib.c.orig     2005-08-26 15:35:08.000000000 -0400
+++ scsi_lib.c  2005-08-26 15:31:10.000000000 -0400
@@ -969,6 +969,31 @@ static int scsi_issue_flush_fn(request_q
        return -EOPNOTSUPP;
 }

+/* If a scsi_cmnd has already been attached to this request, call
+   scsi_put_command on it. This attempts to duplicate the logic below
+   for deciding if a command has been attached (I'd like a less
+   repetitious way to do this). */
+static void scsi_prep_fn_kill (struct request *req)
+{
+       struct scsi_cmnd *cmd = NULL;
+
+       if (req->flags & REQ_SPECIAL)
+       {
+               struct scsi_request *sreq = req->special;
+
+               if (sreq->sr_magic != SCSI_REQ_MAGIC)
+                       cmd = req->special;
+       }
+       else if (req->flags & (REQ_CMD | REQ_BLOCK_PC))
+       {
+               if (req->special)
+                       cmd = req->special;
+       }
+
+       if (cmd)
+               scsi_put_command(cmd);
+}
+
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
        struct scsi_device *sdev = q->queuedata;
@@ -983,6 +1008,7 @@ static int scsi_prep_fn(struct request_q
        if (unlikely(!scsi_device_online(sdev))) {
                printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to
offline device\n",
                       sdev->host->host_no, sdev->id, sdev->lun);
+               scsi_prep_fn_kill (req);
                return BLKPREP_KILL;
        }
        if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
@@ -993,6 +1019,7 @@ static int scsi_prep_fn(struct request_q
                         * at all allowed down */
                        printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O
to dead device\n",
                               sdev->host->host_no, sdev->id,
sdev->lun);
+                       scsi_prep_fn_kill (req);
                        return BLKPREP_KILL;
                }
                /* OK, we only allow special commands (i.e. not
@@ -1029,6 +1056,7 @@ static int scsi_prep_fn(struct request_q

                        printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O
to device being removed\n",
                               sdev->host->host_no, sdev->id,
sdev->lun);
+                       scsi_prep_fn_kill (req);
                        return BLKPREP_KILL;
                }

@@ -1225,6 +1253,7 @@ static void scsi_request_fn(struct reque
                if (unlikely(!scsi_device_online(sdev))) {
                        printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O
to offline device\n",
                               sdev->host->host_no, sdev->id,
sdev->lun);
+                       if (req->special)
scsi_put_command(req->special);
                        blkdev_dequeue_request(req);
                        req->flags |= REQ_QUIET;
                        while (end_that_request_first(req, 0,
req->nr_sectors))
