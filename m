From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: A question on Linux SCSI low-level driver
Date: Wed, 19 May 2004 11:14:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFFA@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:6218 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264358AbUESQOI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 12:14:08 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> - Has anyone ever created a patch for scsi_debug to support 
> ioctl calls in lk 2.4?

>>Yes, me and it is in the last 8 (at least) versions of the
>>lk 2.4 series. See scsi_debug_ioctl().

>>It doesn't do anything other than report it has been called
>>but a "template" it is.

Thanks for creating/maintaining the nice-and-helpful scsi_debug code.  Yes, I found scsi_debug_ioctl() from the latest patch of scsi_debug for lk 2.4.  As long as the answer to the next question is "Yes", then I probably don't need to define ioctl function in the low-level driver we are working on.

>>The SCSI subsystem does not convey SCSI commands between the
>>mid level and LLDs via ioctl calls. ioctl()s defined in LLDs
>>are for very special, typically hardware specific, reasons.
>>For example the LLD of a RAID controller might use ioctls
>>to do RAID specific management functions.

Is queuecommand() defined in low-level driver/scsi_debug the only function processing the incoming common SCSI tasks?  Is it also true no matter we send SCSI passthrough ioctl calls (with all common SCSI commands such as INQUIRY, READ, WRITE, MODE SELECT/SENSE, PERSISTENT RESERVATION IN/OUT, RESERVE, RELEASE, etc.) to sd devices (by using SCSI_IOCTL_SEND_COMMAND) or sg devices (by using either SCSI_IOCTL_SEND_COMMAND or SG_IO), or send non-passthrough commands (such as system calls read, write, etc.) to sd devices?

Thanks,


Lee
