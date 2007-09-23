From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] Fix device not ready printk
Date: Sun, 23 Sep 2007 09:08:46 -0500
Message-ID: <1190556526.3378.3.camel@localhost.localdomain>
References: <20070629132126.GA18722@parisc-linux.org>
	 <20070719185145.GU14791@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33467 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752909AbXIWOIs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2007 10:08:48 -0400
In-Reply-To: <20070719185145.GU14791@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-07-19 at 12:51 -0600, Matthew Wilcox wrote:
> On Fri, Jun 29, 2007 at 07:21:26AM -0600, Matthew Wilcox wrote:
> > I'm in two minds about printing the 'Device not ready' twice.  On the
> > one hand, it's redundant information.  On the other hand, it helps the
> > harried sysadmin with multiple simultaneous disc failures tie the two
> > messages together.
> > 
> > So I'm not signing off on this because I think it warrants further discussion.
> 
> After three weeks with no discussion, I guess it may as well be applied.

Sorry ... busy with other things.

The main thing I don't like is that we've spent a lot of time moving
sense prints into a library so that if someone gullible^Wsensible enough
to want to do a reporting infrastructure comes along, we have all the
entry points nicely laid out, this is a retrograde step on that because
it reintroduces the open coding.

How about something like the attached.  It does exactly what you want
but retains the tap into the constants file for logging?

James

Index: BUILD-2.6/drivers/scsi/constants.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/constants.c	2007-09-14 11:21:50.000000000 -0500
+++ BUILD-2.6/drivers/scsi/constants.c	2007-09-23 09:04:59.000000000 -0500
@@ -1235,6 +1235,20 @@ scsi_print_sense_hdr(const char *name, s
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
+/*
+ * Print normalized SCSI sense header with device information and a prefix.
+ */
+void
+scsi_cmd_print_sense_hdr(struct scsi_cmnd *scmd, const char *name,
+			  struct scsi_sense_hdr *sshdr)
+{
+	scmd_printk(KERN_INFO, scmd, "%s: ", name);
+	scsi_show_sense_hdr(sshdr);
+	scmd_printk(KERN_INFO, scmd, "%s: ", name);
+	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+}
+EXPORT_SYMBOL(scsi_cmd_print_sense_hdr);
+
 static void
 scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
 		       struct scsi_sense_hdr *sshdr)
Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2007-09-22 11:46:15.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2007-09-23 09:05:47.000000000 -0500
@@ -944,11 +944,11 @@ void scsi_io_completion(struct scsi_cmnd
 					break;
 				}
 			}
-			if (!(req->cmd_flags & REQ_QUIET)) {
-				scmd_printk(KERN_INFO, cmd,
-					    "Device not ready: ");
-				scsi_print_sense_hdr("", &sshdr);
-			}
+			if (!(req->cmd_flags & REQ_QUIET))
+				scsi_cmd_print_sense_hdr(cmd,
+							 "Device not ready",
+							 &sshdr);
+
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
Index: BUILD-2.6/include/scsi/scsi_dbg.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_dbg.h	2007-09-14 09:06:13.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_dbg.h	2007-09-23 09:06:50.000000000 -0500
@@ -9,6 +9,8 @@ extern void __scsi_print_command(unsigne
 extern void scsi_show_extd_sense(unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(struct scsi_sense_hdr *);
 extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
+extern void scsi_cmd_print_sense_hdr(struct scsi_cmnd *, const char *,
+				     struct scsi_sense_hdr *);
 extern void scsi_print_sense(char *, struct scsi_cmnd *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,


