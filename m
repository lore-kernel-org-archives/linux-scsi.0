From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Fix device not ready printk
Date: Thu, 19 Jul 2007 12:51:46 -0600
Message-ID: <20070719185145.GU14791@parisc-linux.org>
References: <20070629132126.GA18722@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36837 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbXGSSvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 14:51:47 -0400
Content-Disposition: inline
In-Reply-To: <20070629132126.GA18722@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, Jun 29, 2007 at 07:21:26AM -0600, Matthew Wilcox wrote:
> I'm in two minds about printing the 'Device not ready' twice.  On the
> one hand, it's redundant information.  On the other hand, it helps the
> harried sysadmin with multiple simultaneous disc failures tie the two
> messages together.
> 
> So I'm not signing off on this because I think it warrants further discussion.

After three weeks with no discussion, I guess it may as well be applied.

----

scsi: Better error messages when device not ready

Because scsi_print_sense_hdr prefixes with KERN_INFO, the output from
scsi_io_completion looks like:

sd 0:0:0:0: [sdb] Device not ready: <6>: Sense Key : 0x2 [current] 
: ASC=0x4 ASCQ=0x3

By using scsi_show_sense_hdr, we can get the much more appealing output:

sd 0:0:0:0: [sdb] Device not ready: Sense Key : 0x2 [current] 
sd 0:0:0:0: [sdb] Device not ready: ASC=0x4 ASCQ=0x3

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..d0b8608 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -940,7 +940,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (!(req->cmd_flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
 					    "Device not ready: ");
-				scsi_print_sense_hdr("", &sshdr);
+				scsi_show_sense_hdr(&sshdr);
+				scmd_printk(KERN_INFO, cmd,
+					    "Device not ready: ");
+				scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
 			}
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;


-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
