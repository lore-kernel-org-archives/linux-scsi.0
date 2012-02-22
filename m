From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH][SCSI] enclosure & ses: modernize and add target power management (take 2)
Date: Wed, 22 Feb 2012 15:40:50 -0500
Message-ID: <2EEF87BF-BE2A-41C0-8009-F618C876B33C@xyratex.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com> <4EBD948E.9000104@interlog.com> <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com> <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com> <48CA4310-FA29-4F54-9841-F25F12569FC6@xyratex.com> <4F454C2A.7050806@interlog.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:34239 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753543Ab2BVUk4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2012 15:40:56 -0500
In-Reply-To: <4F454C2A.7050806@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Nah :-( I did not fix any of that. My tests were performed on a compliant enclosure, and a smattering of others (all from the same vendor, so hardly a large group). The aim was to be more compliant with the specification in the ses module, and the fixes were for the 'write' portion, the 'read' portion worked before on the enclosures I tested.

>From the standpoint of the additional of power management, the lack of the unique entry likely means it does not have individual power control either.

Yes it is worth worrying about, ident and slot mapping is a useful feature, but this is an issue for the vendor (End Of Life notwithstanding) to update their enclosure firmware to be compliant. Fixing the ses module for non-compliant enclosures that are EOL and unlikely to be repaired, if possible, should be in the hands of those that have the enclosures to test and a vested interest ... it has been my experience that one only should do so carefully, ever seen the hacks in an x86 BIOS to deal with decades of legacy? :-)

Sincerely -- Mark Salyzyn

On Feb 22, 2012, at 3:12 PM, Douglas Gilbert wrote:

> On 12-02-22 02:09 PM, Mark Salyzyn wrote:
>> Coincident repair of enclosure and ses device support. Fix problems with setting enclosure values careful to preserve other settings. Corrected fault setting as well. Modernize code. Add support for Device Power Management via a new r/w device_power node in sysfs and some internal interfaces to permit them to be called in the future by error recovery escalation. Enclosures that do not support individual power management will always return a status that the device has power.
> 
> Mark,
> One problem I found with the existing kernel SES/enclosure
> support is that it assumes there is a well-formed
> Element Descriptor diagnostic page. By well-formed I mean that
> the page exists and there is a unique, sensible entry for each
> element. By sensible I mean _not_ like this:
>  "TP=9C;SN=PMW82562000C39A;F1=0311;VR=03;VC=6B58AD13;PN=0082562-11;"
> 
> I have a SAS-2 expander with an associated SES device that breaks
> all those tidy assumptions (i.e. I did not make up that string).
> I assume that your patches do not change the reliance on a
> well-formed Element Descriptor diagnostic page. Is the peculiar
> SES device I have (and most SES-1 devices which don't have
> Element Descriptor diagnostic pages) worth worrying about?
> 
> Doug Gilbert
