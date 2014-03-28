From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Fri, 28 Mar 2014 01:22:15 -0700
Message-ID: <53353137.2050603@suse.de>
References: <1386673515-87133-1-git-send-email-hare@suse.de> <1386673515-87133-3-git-send-email-hare@suse.de> <20140327144926.GB16958@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaC1IWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 04:22:17 -0400
In-Reply-To: <20140327144926.GB16958@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 03/27/2014 07:49 AM, Christoph Hellwig wrote:
> On Tue, Dec 10, 2013 at 12:05:12PM +0100, Hannes Reinecke wrote:
>> Sequential scan for more than 256 LUNs is very fragile as
>> LUNs might not be numbered sequentially after that point.
>>
>> SAM revisions later than SCSI-3 impose a structure on
>> LUNs larger than 256, making LUN numbers between 256
>> and 16384 illegal.
>> SCSI-3, however allows for plain 64-bit numbers with
>> no internal structure.
>>
>> So restrict sequential LUN scan to 256 LUNs and add a
>> new blacklist flag 'BLIST_SCSI3LUN' to scan up to
>> max_lun devices.
>
> What do you need the blacklist flag for?  There's no user of it, and
> supporting that many LUNs without REPORT LUNS support doesn't sound v=
ery
> practical anyway.
>
Because there is no guarantee that pre-SCSI-3 devices (or devices=20
announcing to be pre-SCSI-3) will not allow to scan more than 256 devic=
es.
Thinking of older Symmetrix here with their weird 'SPC-3 masking as=20
SCSI-2' habit.

Also currently we're allowing to scan beyond 256 without any=20
restrictions there might be installations out there which rely on this=20
behaviour.

Hence this flag.

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
