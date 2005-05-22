From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sun, 22 May 2005 09:06:15 -0500
Message-ID: <1116770775.5002.21.camel@mulgrave>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
	 <4290273E.6050306@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59306 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261808AbVEVOG4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 10:06:56 -0400
In-Reply-To: <4290273E.6050306@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Jeff Garzik <jgarzik@pobox.com>

On Sun, 2005-05-22 at 16:31 +1000, Douglas Gilbert wrote:
> In my experience setting the DBD flag only increases the
> chance of failure (from devices that don't understand the
> DBD (i.e. disable block descriptors) bit. Also dbd should
> be set (to 1) or cleared; not set to 8. Best to leave it clear
> (the default) as the offset calculation below takes into
> account any returned block descriptors.

DBD is a listed *requirement* of RBC devices ... so I think we have to
have it.  Also, it's a pass through to __scsi_mode_sense() not a bit
flag (i.e. to set dbd in the command header, you have to set it to its
correct bit position, i.e. 8).

> James,
> scsi_lib.c::__scsi_mode_sense() has a bug in it.
> If dbd is set then both the DBD and LLBA bits in the
> MODE SENSE cdb are set. However LLBA is not defined for
> MODE SENSE 6 (in SPC or RBC). That may be why Al's
> hardware doesn't like MODE SENSE 6 cdbs issued by the
> SCSI mid level :-)

no, look again; the statement is:

	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */

So if you set dbd  0x08, you get dbd and 0x10 you get LLBA etc.

However, I agree, we shouldn't allow the setting of LLBA on MODE SENSE
6, fixed below.

> > +		if ((buffer[offset] & 0x3f) != modepage) {
> > +			printk(KERN_ERR "%s: got wrong page\n", diskname);
> > +			goto defaults;
> > +		}
> 
> So here is the sanity check that I have been talking
> about. On my hardware since a MODE SENSE 10 was issued,
> the response is corrupt (actually the response for the
> corresponding MODE SENSE 6 is returned) so the exercise
> becomes futile. Note that my hardware complies with
> the RBC standard in properly supporting MODE SENSE 6.
> [The RBC standard doesn't say anything about what should
> happen when MODE SENSE 10 is issued :-)]
> 
> To work on my hardware the next move would be to
> "sdev->use_10_for_ms = 0;" and try again (and if
> that fails give up).

Well ... what I was wondering is whether to predicate the setting of
use_10_for_ms in the firewire slave_configure on if (sdev->type !=
TYPE_RBC).

However, checking for corrupt mode pages in the routine seems like a
good idea as well, does the attached work?

James

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1593,6 +1593,7 @@ __scsi_mode_sense(struct scsi_request *s
 			len = 4;
 
 		cmd[0] = MODE_SENSE;
+		cmd[1] &= 0x08; /* only DBD is legal */
 		cmd[4] = len;
 		header_length = 4;
 	}
@@ -1629,12 +1630,25 @@ __scsi_mode_sense(struct scsi_request *s
 	if(scsi_status_is_good(sreq->sr_result)) {
 		data->header_length = header_length;
 		if(use_10_for_ms) {
+			int actual_page;
+
 			data->length = buffer[0]*256 + buffer[1] + 2;
 			data->medium_type = buffer[2];
 			data->device_specific = buffer[3];
 			data->longlba = buffer[4] & 0x01;
 			data->block_descriptor_length = buffer[6]*256
 				+ buffer[7];
+
+			/* Sanity check the return: some devices give
+			 * rubbish back in response to ms(10) commands
+			 * but work with ms(6) */
+			actual_page = 
+				buffer[header_length +
+				       data->block_descriptor_length] & 0x3f;
+			if (actual_page != modepage) {
+				sreq->sr_device->use_10_for_ms = 0;
+				goto retry;
+			}
 		} else {
 			data->length = buffer[0] + 1;
 			data->medium_type = buffer[1];


