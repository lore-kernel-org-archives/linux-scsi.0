From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH as468] Retry supposedly "unrecoverable" hardware errors
Date: Thu, 17 Feb 2005 15:06:12 +1000
Message-ID: <42142644.6080005@torque.net>
References: <Pine.LNX.4.44L0.0502161144170.6418-100000@ida.rowland.org> <42141D3D.9080800@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070202080404050507040008"
Received: from borg.st.net.au ([65.23.158.22]:8643 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262193AbVBQFFe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 00:05:34 -0500
In-Reply-To: <42141D3D.9080800@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Martin Peschke <mpeschke@de.ibm.com>, Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070202080404050507040008
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> Alan Stern wrote:
> 
>> James:
>>
>> This is an updated and unmangled version of the patch sent in by 
>> Martin Peschke.  Apparently some drives report Hardware Error sense 
>> for problems which do improve after retrying, so the patch retries 
>> these supposedly "unrecoverable" errors for such devices.
> 
> 
> Recent SPC-3 and SBC-2 drafts treat the sense keys of
> MEDIUM ERROR and HARDWARE ERROR in a similar way.
> Both can return an "info" field which has the same
> meaning (lba of first failure). The distinction is that
> MEDIUM ERROR is a little more precise (at least for
> magnetic rotating media) **. For flash ram the distinction
> is moot.
> 
> I believe MEDIUM ERROR and HARDWARE ERROR should be
> treated the same way in scsi_check_sense() (i.e.
> both return NEEDS_RETRY). That way an extra black list
> category is avoided.
> 
> 
> ** HARDWARE ERROR is returned in cases of self diagnostic
> failure and lack of available blocks for reassignment.
> It seems valid for a device to return a HARDWARE ERROR
> sense key both for these cases and unrecoverable data
> errors (and ignore MEDIUM ERROR).

... after a bit further thought, a retry (arguably) is only
needed when an unrecoverable (data) error is detected. If we
assume the "info" field indicates an unrecoverable error
then the following patch combines the processing of
MEDIUM and HARDWARE ERROR sense keys without the need for
a black list category.

Doug Gilbert


--------------070202080404050507040008
Content-Type: text/x-patch;
 name="scsi_error2611rc4he.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error2611rc4he.diff"

--- linux/drivers/scsi/scsi_error.c	2005-02-13 20:46:31.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2611rc4he	2005-02-17 14:55:44.000000000 +1000
@@ -279,6 +279,7 @@
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_sense_hdr sshdr;
+	u64 info;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
@@ -348,12 +349,15 @@
 		return SUCCESS;
 
 	case MEDIUM_ERROR:
-		return NEEDS_RETRY;
-
+	case HARDWARE_ERROR:
+		if (scsi_get_sense_info_fld(scmd->sense_buffer,
+					    sizeof(scmd->sense_buffer), &info))
+			return NEEDS_RETRY;
+		else
+			return SUCCESS;
 	case ILLEGAL_REQUEST:
 	case BLANK_CHECK:
 	case DATA_PROTECT:
-	case HARDWARE_ERROR:
 	default:
 		return SUCCESS;
 	}

--------------070202080404050507040008--
