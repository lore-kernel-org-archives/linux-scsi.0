From: Andries.Brouwer@cwi.nl
Subject: Re: [PATCH] scsi_status() macro
Date: Fri, 16 May 2003 14:12:38 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200305161212.h4GCCcI13287.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:52651 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264420AbTEPL7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 07:59:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

    > If you're doing this:
    > 
    >>+#define scsi_status(result) ((result) & 0x7e)
    > 
    > because bit0 is reserved in SCSI-2, then it should be 0x3e because bits
    > 6 and 7 are also reserved.  Of course, this would clash with the SCSI-3
    > definition of TASK ABORTED, sigh.
    > 
    > Perhaps it's better just not to bother with the mask?

    James,
    The macro still gets rid of the upper bytes in
    scsi_cmnd::result so in needs to be at least
    a mask of 0xff.

    With a mask of 0x7e it is correct for SCSI-3,
    bit 6 is reserved in SCSI-2  and "vendor unique"
    in SCSI-1 and SCSI_1_CCS. I dug up a SCSI 1 draft and
    the Status byte table is attached. So as far as I
    can see our only exposure is to SCSI 1 and CCS
    devices.

Yes, SCSI-1 has RVVSSSSV with R=reserved, V=vendor unique, S=status.
Originally this was a bitmap, and it is still the case that codes
are not randomly assigned. (We have several places in the
kernel source that test (status & CHECK_CONDITION).)

I think it can be said that universally 0 means good status,
and good status is represented by 0.

The old bits 0,5,6 had a vendor-unique meaning,
and bit 5 now has a new meaning.

So, my version would have

#define scsi_status_byte(result)	((result) & 0xff)

Change all occurrences of status_byte() into scsi_status_byte()
and adapt the values tested against.

(Not that I think we should do this right now.
The patch would be very large, while the gain is very low.
This is the sort of minor cleanup better done at the start
of 2.7. For now I only plan to come with minimal fixes for
the places I noticed where X and X<<1 are confused.)

Andries
