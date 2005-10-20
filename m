From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Improve code for detecting errors near the end of a CD
Date: Thu, 20 Oct 2005 12:56:46 +1000
Message-ID: <4357076E.2000006@torque.net>
References: <Pine.LNX.4.44L0.0510191627270.4439-100000@iolanthe.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:60324 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751710AbVJTCzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 22:55:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.0510191627270.4439-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Sat, 15 Oct 2005, Douglas Gilbert wrote:
> 
> 
>>Alan,
>>In include/scsi/scsi_eh.h there are several helper functions
>>to aid processing SCSI errors. This includes SCSI sense data
>>descriptor format (which won't be needed for DVD/HD/BD for
>>some time with a (2**32 * 2048) byte maximum using existing
>>fixed sense data format). However there is
>>scsi_get_sense_info_fld() to fetch the info field.
>>
>>sd, st and sg have been converted to use these helpers,
>>where appropriate.
>>
>>MMC-4 does not mention that the valid bit needs to
>>be set on a MEDIUM/HARDWARE error and I have seen
>>real life examples of this. [So it's poorly defined
>>if one gets a medium error on lba 0.] You may also like to
>>consider deferred errors which can occur according to
>>MMC-4.
> 
> 
> I just read the scsi_get_sense_info_fld routine.  For fixed format data, 
> it won't return anything if the Valid bit isn't set!
> 
> This makes it hard to adopt both your first two suggestions... :-)

Alan,
Ouch.
Here is the linux kernel version (scsi_error.c):

    case 0x70:
    case 0x71:
        if (sense_buffer[0] & 0x80) {
            *info_out = (sense_buffer[3] << 24) +
                        (sense_buffer[4] << 16) +
                        (sense_buffer[5] << 8) +
                        sense_buffer[6];
            return 1;
        } else
            return 0;

and here is the sg3_utils version (sg_lib.c):

    case 0x70:
    case 0x71:
        if (info_outp)
            *info_outp = (sensep[3] << 24) + (sensep[4] << 16) +
                         (sensep[5] << 8) + sensep[6];
        return (sensep[0] & 0x80) ? 1 : 0;

The latter implementation takes account of MMC devices.
So I probably need to send a patch.

Doug Gilbert


