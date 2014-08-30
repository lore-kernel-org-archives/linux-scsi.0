From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Sat, 30 Aug 2014 17:40:34 -0400
Message-ID: <540244D2.4030807@interlog.com>
References: <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52557 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaH3Vkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2014 17:40:40 -0400
In-Reply-To: <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On 14-08-30 05:15 PM, Alan Stern wrote:
> On Fri, 29 Aug 2014, Matthew Dharm wrote:
>
>> Is there an 'easy' way to override the detected size of a storage
>> device from userspace?  If we had that, someone could write a helper
>> application which looked for this particular fubar and try to Do The
>> Right Thing(tm), or at least offer the user some options.
>
> You mean, force a Media Change event and override the capacity reported
> by the hardware?  I'm not aware of any API for doing that, although it
> probably wouldn't be too hard to add one.
>
> How would the user know what value to put in for the capacity?  Unless
> the drive had been hooked up to a different computer and the user
> manually noted the correct capacity and typed it in, it would have to
> be guesswork.

Might another possibility be using the SAT layer to issue
the appropriate ATA command via the SCSI ATA PASS-THROUGH
(12 or 16) command to find out the disk's size. This might
be a possible strategy if READ CAPACITY(10) yields 0xffffffff
for the last sector's LBA and the follow-up READ CAPACITY(16)
fails or yields a truncated value.

Doug Gilbert


BTW Been looking at a USB-to-SATA adapter that uses the
UAS(P) transport. I thought nothing could have worse
SCSI compliance than USB mass storage devices. I was
wrong ...

