From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi_devinfo: devices and pattern matching
Date: Mon, 18 Dec 2017 09:36:47 +0100
Message-ID: <5cdd66a5-f4f4-e010-5e6e-91eacaf790f0@suse.de>
References: <bebefebe-e1b8-5f15-a59d-ed5099ebcf4e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52361 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756832AbdLRIgu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Dec 2017 03:36:50 -0500
In-Reply-To: <bebefebe-e1b8-5f15-a59d-ed5099ebcf4e@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>, Martin Petersen <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 12/16/2017 02:31 PM, Xose Vazquez Perez wrote:
> Hi,
> 
> After last pattern matching changes, maybe some entries should be revised:
> 
> 
> Empty strings(current meaning?):
> 	{"", "Scanner", "1.80", BLIST_NOLUN},	/* responds to all lun */
> 	{"Promise", "", NULL, BLIST_SPARSELUN},
> 	{"HP", "C1790A", "", BLIST_NOLUN},		/* scanjet iip */
> 	{"HP", "C2500A", "", BLIST_NOLUN},		/* scanjet iicx */
> 
We would need to check what the hardware actually returns, whether it
_really_ is an empty string or whether it's meant to be a catch-all entry.

> 
> Overlapping(?) strings(remove one???):
> 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
> 	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},>
> 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> 	
> 	{"Promise", "", NULL, BLIST_SPARSELUN},
> 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
> 
That is by design, and nothing to worry about, as the specific entries
are subsets of the more generic entries.

> 
> Odd "revision level" string(is it right? EOT?):
>         {"SEAGATE", "ST157N", "\004|j", BLIST_NOLUN},
> 
> 
We might need to check what the ST157N actually returns; if we can't I
fear the entry need to stay as it is.

> Duplicate strings(They should be merged):
> 	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
> 	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN},
> 
Ah. Good point. Yes, it should be merged.

> 
> Keep in mind, for future patches, that there are regex metacharacters(!!):
>         {"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
>         {"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
>         {"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},     /* Dell PV 530F */
> 
Hmm. Yes, but again we need to validate this with real hardware before
making any changes here.

> 
> For homogeneity reasons, should "*" revision level be replaced by NULL?
> 
> 
> And the current pattern matching algorithm should be described clearer, right
> now it's a bit confused.
> 
I'll be sending out a blktest entry for the devinfo string matching;
that will give us a proper regression test suite.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
