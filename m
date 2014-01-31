From: Marc C <marc.ceeeee@gmail.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] Plumbing I/O Cache / Tiered Storage Hints
Date: Fri, 31 Jan 2014 10:32:47 -0800
Message-ID: <52EBEC4F.3010709@gmail.com>
References: <CAA9_cmcCAOwFE7j8-80zMmgvgP02XVmLjepFJPpEn_ZANHn1zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53193 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaScu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2014 13:32:50 -0500
In-Reply-To: <CAA9_cmcCAOwFE7j8-80zMmgvgP02XVmLjepFJPpEn_ZANHn1zA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, lsf-pc@lists.linux-foundation.org
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jason B Akers <jason.b.akers@intel.com>

Hi,

>> [2] T13 Hybrid Information Feature
>
> Correction, the hinting scheme is defined by SATA-IO in SATA 3.2

I, too, would also like to know of the direction for supporting hybrid
hinting, since we already have support for SEND/RECV FPDMA queued in the
kernel. The new commands were used initially for queued TRIMs, but would
also be very useful on SSHD devices, especially since the commands
allows initiators to provide "hints" on whether data is considered "hot"
or "cold", without requiring I/O.

-Marc

On 01/31/2014 10:18 AM, Dan Williams wrote:
> On Tue, Jan 28, 2014 at 2:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> In addition to disk drives with internally tiered-storage (solid-state
>> + magnetic media) the kernel has also grown native I/O-caching /
>> tiered-storage implementations in bcache and dm-cache.
>>
>> Currently, all these solutions depend on heuristics to determine what
>> tier the data referenced in an I/O belongs.  However, the presence of
>> hinting proposals from SCSI [1], ATA [2], and bcache [3] indicate that
>> these devices (hardware or virtual) want to consume explicit hints
>> indicating the value of caching data in a higher performing tier.
>>
>> At LSF I want to discuss options and opportunities for plumbing cache
>> hints from userspace, through the I/O stack to devices.  My colleague,
>> Jason Akers, is also interested in this discussion as he is
>> investigating how to exploit these hints from userspace.  I
>> participated in the LSF 2012 discussion of this topic, see that it was
>> raised again at LSF 2013, and note that we have not settled on an
>> enabling path.  What's new for this year is an effort to set aside,
>> for now, the deeper complexities of the device specification proposals
>> and focus on a minimal set of hints that can be specified per-process
>> (ionice) and maybe per-file (fadvise).
>>
>> My suspicion is that AIO attributes is useful for applications that
>> want access to the full range of access hints exposed by a device.
>> However, for the general buffered-I/O / tiered-storage case, a small
>> set of hints achieves the bulk of the value.
>>
>> I am also interested in:
>> Volatile ranges
>> SMR Enabling
>> Integrity passthrough
>>
>> --
>> Dan
>>
>> [1] T10 LBA Access Hints
>> [2] T13 Hybrid Information Feature
> 
> Correction, the hinting scheme is defined by SATA-IO in SATA 3.2
> 
>> [3] AIO Attributes: http://marc.info/?l=linux-aio&m=136580574523674&w=2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

