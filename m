From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [LSF/MM TOPIC] Copy offload
Date: Tue, 24 Jan 2012 12:16:48 +0200
Message-ID: <4F1E8510.80003@panasas.com>
References: <4F0AC112.2000709@suse.de> <CAL1RGDWJjzBnN6Aj_ngvkFco_toe8Dey5QApgmYafpEqECuTSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:36630 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2AXKRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 05:17:00 -0500
In-Reply-To: <CAL1RGDWJjzBnN6Aj_ngvkFco_toe8Dey5QApgmYafpEqECuTSw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>

On 01/13/2012 09:35 PM, Roland Dreier wrote:
> In general, with my target vendor hat on, I'd be very interested in
> what special SCSI commands the Linux initiator stack might want
> to use.  Extended copy is one (very complex) case -- and BTW
> Microsoft seems to plan on using XCOPY LITE with NTFS.
> 
> Another possibly interesting example would be COMPARE AND
> WRITE for clustered filesystems.
> 
> Any other storage operations that FS developers might want
> from the block device?  (Either standard SCSI commands or
> more speculative stuff that T10 hasn't thought of yet)
> 

copy-and-modify

the command looks like a a write with destination [write_start, num_sectors]
The command also receives a read destination [read_start, num_sectors]

where  read_start <= write_start && write_start+num_sectors <= read_start+num_sectors

That's for the like of pNFS blocks layout where the FS maintains a copy-on-write
with FS blocks larger than a sector. Today it needs to do the copy then the
modification. (2 + 1) operations instead of 1

Na, too marginal. Is it worth it? It might depend on the FS block size.

Just some crazy idea
Boaz

>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

