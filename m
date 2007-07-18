From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Wed, 18 Jul 2007 12:29:24 +0300
Message-ID: <469DDD74.2060208@panasas.com>
References: <4695F76F.5000305@panasas.com>	<20070712135750.2a4a4a54.rdunlap@xenotime.net>	<469B38CC.50501@panasas.com> <20070717171607.ffc278eb.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13133 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbXGRJaG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 05:30:06 -0400
In-Reply-To: <20070717171607.ffc278eb.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Randy Dunlap wrote:
> On Mon, 16 Jul 2007 12:22:20 +0300 Boaz Harrosh wrote:
> 
>> If you could do some testing it is grate. The first 3 patches do not
>> need scsi-misc specifically. Any post 2.6.20 tree will do. The last patch
>> could be done together with attached patch on any 2.6.22 tree.
>> (Apply attached patch anywhere before the last patch (4/4) of the patchset)
>> Though I do recommend scsi-misc tree.
> 
> I took 2.6.22, backed out Christoph's aha152x.c patch (using
> completion for timeouts), added your 5 patches, and then tested.
> Does that sound OK?
> 
Yes what you did is perfect
I was not aware of "Christoph's aha152x.c patch" is that in scsi-misc?
I'm almost positive I did a git-pull before I sent the patches.
Sorry about that.

>> Testing:
> 
> I booted/tested 4 times.  2 Oopsen and 2 of
> could-never-mount-the-device-due-to-reset-problems.
> Log is attached.
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Thank you for testing and helping me with this.

I found one thing that should definitely trash the Reset
and do funny things. But I'm not sure it is it at all.
If below does not work, could you pleas do a small bisect
of my patches.

first patch first, than 2nd, 3rd ,accessors thing, and 4th 

git-diff
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f2f0619..6762cc8 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1151,6 +1151,7 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
+	unsigned short old_cmd_len = SCpnt->cmd_len;
 	unsigned long flags;
 	unsigned long timeleft;
 
@@ -1171,6 +1172,8 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
 	DO_UNLOCK(flags);
 
+	SCpnt->cmd_len         = 0;
+
 	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
 
 	timeleft = wait_for_completion_timeout(&done, 100*HZ);
@@ -1181,6 +1184,8 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 		DO_UNLOCK(flags);
 	}
 
+	SCpnt->cmd_len         = old_cmd_len;
+
 	DO_LOCK(flags);
 
 	if(SCpnt->SCp.phase & resetted) {

