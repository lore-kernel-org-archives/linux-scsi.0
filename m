From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 04 Jul 2014 16:41:24 +0200
Message-ID: <53B6BD14.5050606@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-3-git-send-email-hare@suse.de> <53B69E97.4050901@acm.org> <53B6A5B4.2040807@suse.de> <20140704134835.GB12345@infradead.org> <53B6B669.10704@suse.de> <53B6BC72.6040204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaGDOl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 10:41:26 -0400
In-Reply-To: <53B6BC72.6040204@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/04/2014 04:38 PM, Bart Van Assche wrote:
> On 07/04/14 16:12, Hannes Reinecke wrote:
>> On 07/04/2014 03:48 PM, Christoph Hellwig wrote:
>>> I think storing the struct scsi_lun in the scsi_device is the right=
 way
>>> to go ahead.  Any "accessors" for 8 or 32-bit LUNs should be simply
>>> enough by just ignoring bits in the array, so there's very little
>>> performance overhead.
>>>
>>> If we can get rid of the old scalar LUN field that would be great,
>>> and given that we know the printk format fallout already it doesn't=
 look
>>> like too much work.  Do you want to look into this?
>>
>> Already working on it.
>
> That sounds great. Regarding the SRP initiator driver: if the "__be64
> lun" declarations in <scsi/srp.h> are changed into "struct scsi_lun l=
un"
> then that allows to encode / decode LUNs inside the SRP initiator
> without having to cast the address of these "lun" members into struct
> scsi_lun *. In case you would prefer me to have a look into this, ple=
ase
> let me know.
>
That would be perfect.
Most of the HBAs supporting 64bit LUNs internally are already doing=20
this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
