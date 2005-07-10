From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 00:36:45 -0400
Message-ID: <20050710043645.GF2972@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org> <20050710033431.GB13883@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:49378 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261851AbVGJEgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 00:36:49 -0400
Content-Disposition: inline
In-Reply-To: <20050710033431.GB13883@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

> > My question is, why were the conversions all removed? The conversions, as
> > far as I know, are related to SBP protocol, and not SCSI, so why would the
> > SCSI maintainers feel the need to rip out an important part of the SBP2
> > driver?
> 
> It's a standard conversion that we've been ripping out of all drivers,
> because it is unnecessary.
> 
> I understand you're a bit hacked off by all these changes occurring, but
> how about debugging the failure you're seeing, before ripping out stuff?
> "doesn't work at all" is untrue.  So who are the failure cases, and what
> makes them different from the working case(s)?

I'm not a SCSI expert, so at first glance, the changes seemed to be a
little far streching. I can see that isn't the case though.

However, since SBP2 may not be fully compliant, it would seem we may not
be able to use this standard conversion policy.

I would have to say that it isn't working for a lot of people. Why does
our code work for everything, but the scsi code only work for some ppl?
Atleast I can say that where things are broken, our code fixes it, and
where things are working, our code also works. It would seem our code has
a workaround for the cases where the scsi code doesn't.

One thing that stands out is that we have a bit of code that changed the
device type from TYPE_RBC to TYPE_DISK in the command structure. Since I
didn't write this code, I can't really say why that is.  Any ideas what
that was trying to accomplish? I've attached the changes here, so you can
see what our code did and maybe make some sense of it.

I honestly thing that our code was removed in an attempt to replace it
with some common code, perhaps without fully understanding what it may
have done special. I have to say, after looking at the scsi code that
replaces the sbp2 code, I can't see a hole lot of similarity.


diff -urN -x .svn drivers/ieee1394-git/sbp2.c drivers/ieee1394/sbp2.c
--- drivers/ieee1394-git/sbp2.c	2005-07-05 23:46:33.000000000 -0400
+++ drivers/ieee1394/sbp2.c	2005-07-09 19:22:45.870920869 -0400
@@ -2112,6 +2112,102 @@
  */
 static void sbp2_check_sbp2_command(struct scsi_id_instance_data *scsi_id, unchar *cmd)
 {
+	unchar new_cmd[16];
+	u8 device_type = SBP2_DEVICE_TYPE (scsi_id->sbp2_device_type_and_lun);
+
+	SBP2_DEBUG("sbp2_check_sbp2_command");
+
+	switch (*cmd) {
+
+		case READ_6:
+
+			if (sbp2_command_conversion_device_type(device_type)) {
+
+				SBP2_DEBUG("Convert READ_6 to READ_10");
+
+				/*
+				 * Need to turn read_6 into read_10
+				 */
+				new_cmd[0] = 0x28;
+				new_cmd[1] = (cmd[1] & 0xe0);
+				new_cmd[2] = 0x0;
+				new_cmd[3] = (cmd[1] & 0x1f);
+				new_cmd[4] = cmd[2];
+				new_cmd[5] = cmd[3];
+				new_cmd[6] = 0x0;
+				new_cmd[7] = 0x0;
+				new_cmd[8] = cmd[4];
+				new_cmd[9] = cmd[5];
+
+				memcpy(cmd, new_cmd, 10);
+
+			}
+
+			break;
+
+		case WRITE_6:
+
+			if (sbp2_command_conversion_device_type(device_type)) {
+
+				SBP2_DEBUG("Convert WRITE_6 to WRITE_10");
+
+				/*
+				 * Need to turn write_6 into write_10
+				 */
+				new_cmd[0] = 0x2a;
+				new_cmd[1] = (cmd[1] & 0xe0);
+				new_cmd[2] = 0x0;
+				new_cmd[3] = (cmd[1] & 0x1f);
+				new_cmd[4] = cmd[2];
+				new_cmd[5] = cmd[3];
+				new_cmd[6] = 0x0;
+				new_cmd[7] = 0x0;
+				new_cmd[8] = cmd[4];
+				new_cmd[9] = cmd[5];
+
+				memcpy(cmd, new_cmd, 10);
+
+			}
+
+			break;
+
+		case MODE_SENSE:
+
+			if (sbp2_command_conversion_device_type(device_type)) {
+
+				SBP2_DEBUG("Convert MODE_SENSE_6 to MODE_SENSE_10");
+
+				/*
+				 * Need to turn mode_sense_6 into mode_sense_10
+				 */
+				new_cmd[0] = 0x5a;
+				new_cmd[1] = cmd[1];
+				new_cmd[2] = cmd[2];
+				new_cmd[3] = 0x0;
+				new_cmd[4] = 0x0;
+				new_cmd[5] = 0x0;
+				new_cmd[6] = 0x0;
+				new_cmd[7] = 0x0;
+				new_cmd[8] = cmd[4];
+				new_cmd[9] = cmd[5];
+
+				memcpy(cmd, new_cmd, 10);
+
+			}
+
+			break;
+
+		case MODE_SELECT:
+
+			/*
+			 * TODO. Probably need to change mode select to 10 byte version
+			 */
+
+		default:
+			break;
+	}
+
+	return;
 }
 
 /*
@@ -2152,6 +2248,7 @@
 				     struct scsi_cmnd *SCpnt)
 {
 	u8 *scsi_buf = SCpnt->request_buffer;
+	u8 device_type = SBP2_DEVICE_TYPE (scsi_id->sbp2_device_type_and_lun);
 
 	SBP2_DEBUG("sbp2_check_sbp2_response");
 
@@ -2176,6 +2273,14 @@
 			}
 
 			/*
+			 * Check for Simple Direct Access Device and change it to TYPE_DISK
+			 */
+			if ((scsi_buf[0] & 0x1f) == TYPE_RBC) {
+				SBP2_DEBUG("Changing TYPE_RBC to TYPE_DISK");
+				scsi_buf[0] &= 0xe0;
+			}
+
+			/*
 			 * Fix ansi revision and response data format
 			 */
 			scsi_buf[2] |= 2;
@@ -2183,6 +2288,27 @@
 
 			break;
 
+		case MODE_SENSE:
+
+			if (sbp2_command_conversion_device_type(device_type)) {
+
+				SBP2_DEBUG("Modify mode sense response (10 byte version)");
+
+				scsi_buf[0] = scsi_buf[1];	/* Mode data length */
+				scsi_buf[1] = scsi_buf[2];	/* Medium type */
+				scsi_buf[2] = scsi_buf[3];	/* Device specific parameter */
+				scsi_buf[3] = scsi_buf[7];	/* Block descriptor length */
+				memcpy(scsi_buf + 4, scsi_buf + 8, scsi_buf[0]);
+			}
+
+			break;
+
+		case MODE_SELECT:
+
+			/*
+			 * TODO. Probably need to change mode select to 10 byte version
+			 */
+
 		default:
 			break;
 	}
@@ -2559,8 +2685,7 @@
 static int sbp2scsi_slave_configure (struct scsi_device *sdev)
 {
 	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
-	sdev->use_10_for_rw = 1;
-	sdev->use_10_for_ms = 1;
+
 	return 0;
 }
 

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
