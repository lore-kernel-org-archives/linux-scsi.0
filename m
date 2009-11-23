From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
	blocks are zeroed
Date: Mon, 23 Nov 2009 11:54:14 -0500
Message-ID: <87f94c370911230854v46c1dc35g417a54b8a415ba16@mail.gmail.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
	 <1258771524-26673-2-git-send-email-martin.petersen@oracle.com>
	 <20091121101356.GA21716@infradead.org>
	 <20091121195802.GC8502@parisc-linux.org> <4B08A543.909@rtr.ca>
	 <4B0ABA2F.2090407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:47576 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZKWRmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2009 12:42:40 -0500
In-Reply-To: <4B0ABA2F.2090407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 23, 2009 at 11:37 AM, Ric Wheeler <rwheeler@redhat.com> wro=
te:
> On 11/21/2009 09:43 PM, Mark Lord wrote:
>>
>> Matthew Wilcox wrote:
>>>
>>> On Sat, Nov 21, 2009 at 05:13:56AM -0500, Christoph Hellwig wrote:
>>>>
>>>> On Fri, Nov 20, 2009 at 09:45:21PM -0500, Martin K. Petersen wrote=
:
>>>>>
>>>>> The discard ioctl is used by mkfs utilities to clear a block devi=
ce
>>>>> prior to putting metadata down. =A0However, not all devices retur=
n zeroed
>>>>> blocks after a discard. =A0Some drives return stale data, potenti=
ally
>>>>> containing old superblocks. =A0It is therefore important to know =
whether
>>>>> discarded blocks are properly zeroed.
>>>>
>>>> At least for mkfs.xfs we make sure to still zero the important are=
as
>>>> after the TRIM ioctl anyway.
>>>
>>> Could you change that to zero _before_ the TRIM?
>>
>> ..
>>
>>
>> Hopefully not for the drives that *don't* guarantee zeros after TRIM=
=2E
>> Eg. most existing ones, including all of the Indilinx chipset drives=
=2E
>>
>> Cheers
>>
>
> Note that writing to a block after a discard (write or trim) changes =
the
> state of that block back to allocated (mapped) in the target. Basical=
ly,
> that would seem to make the trim redundant and irrelevant.
>
> You can zero before the discard but that can still fail is the device
> returns garbage for a trim'ed block I think,
>
> Ric

I understood the mkfs process to be:

- discard / trim 100% of the block device
- write zeros to the relatively small group of blocks that the
filesystem assumes will be zero'd.

Seems like the only reasonable way to handle it.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
