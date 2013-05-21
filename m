From: Ilan Steinberg <ilan.steinberg@kaminario.com>
Subject: [PATCH 1/3] sd_try_extended_inquiry for SPC-3 targets
Date: Tue, 21 May 2013 06:40:24 -0700 (PDT)
Message-ID: <35421213.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sam.nabble.com ([216.139.236.26]:35352 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab3EUNkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 09:40:24 -0400
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>)
	id 1Uemng-0007Ij-4X
	for linux-scsi@vger.kernel.org; Tue, 21 May 2013 06:40:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello,

I am new to this forum, I tried to look up this question, but could not find
any reference.

I have some trouble in with the 0xb1 VPD inquiry.
I set my device as a non-rotational device by returning 0x0001 in bytes 4-5
(MEDIUM ROTATION RATE) just as the SBC-3 demands:

"0001h Non-rotating medium (e.g., solid state)"

However, in the sysfs I see that the device is set as rotational device. I
went into the kernel code to see why this happens. I found that the 0xb1
inquiry is only called if sd_try_extended_inquiry(sdp) returns a scsi
version higher then SCSI_SPC_2. There is even a comment: 
"
static int sd_try_extended_inquiry(struct scsi_device *sdp)
{
        /*
         * Although VPD inquiries can go to SCSI-2 type devices,
         * some USB ones crash on receiving them, and the pages
         * we currently ask for are for SPC-3 and beyond
         */
        if (sdp->scsi_level > SCSI_SPC_2)
                return 1;
        return 0;
}
"

my device supports SPC-3. 
The scsi_level of my device (as I expose it in the page0 inquiry) is 0x5
according to SPC4 this means SPC-3.

This is from SPC4-revision 24 (3-6 are the same in revision 36e which is the
latest I have):
"
00h The device does not claim conformance to any standard.
02h Obsolete
03h The device complies to ANSI INCITS 301-1997 (a withdrawn standard).
04h The device complies to ANSI INCITS 351-2001 (SPC-2).
05h The device complies to ANSI INCITS 408-2005 (SPC-3).
06h The device complies to this standard.
"

So it should pass the sd_try_extended_inquiry(spd).
The problem is that SCSI_SPC_2 is defined as 5 in include/scsi/scsi.h:484
(below). This causes SPC-3 devices not to be queried. and thus, they are set
as rotational devices in the sysfs. 

/*
 *  struct scsi_device::scsi_level values. For SCSI devices other than those
 *  prior to SCSI-2 (i.e. over 12 years old) this value is (resp[2] + 1)
 *  where "resp" is a byte array of the response to an INQUIRY. The
scsi_level
 *  variable is visible to the user via sysfs.
 */

#define SCSI_UNKNOWN    0
#define SCSI_1          1
#define SCSI_1_CCS      2
#define SCSI_2          3
#define SCSI_3          4        /* SPC */
#define SCSI_SPC_2      5
#define SCSI_SPC_3      6

If you read the comment it seams to me that the test (sdp->scsi_level >
SCSI_SPC_2) is incorrect. 
I looked at the native linux target, and it uses the scsi.h definitions, so
it passes the test properly. For non native targets, this is a problem. Is
this done by design (I can see that this code has been in the SCSI layer
since the initial git)?

Thank you,
Ilan Steinberg
-- 
View this message in context: http://old.nabble.com/sd_try_extended_inquiry-for-SPC-3-targets-tp35421213p35421213.html
Sent from the linux-scsi mailing list archive at Nabble.com.

