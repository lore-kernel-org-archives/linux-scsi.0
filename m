From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Mon, 21 Jul 2014 19:49:17 +0200
Message-ID: <53CD529D.4050504@suse.de>
References: <1405931241-92015-1-git-send-email-hare@suse.de> <1405931241-92015-5-git-send-email-hare@suse.de> <20140721112904.GB15455@infradead.org>,<53CCFEBE.8080400@suse.de> <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
Sender: linux-ide-owner@vger.kernel.org
To: John Utz <John.Utz@wdc.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomely <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 07/21/2014 06:18 PM, John Utz wrote:
> If I read Hanne's patch correctly, he is checking for the ZBC signatu=
re
 > when the drives are probed.
>
Yep.

> Thus, the only circumstance where adding zbc handling would lead to
 > unexpected bad behavior in sd would be if a ZBC drive reported itsel=
f
 > as a standard ATA drive or an ATA drive reported itself as a ZBC dri=
ve.

It's actually worse than that:
Currently libata will happily attach to a ZAC device, and passing them=20
on to the SCSI stack as a normal disk device.
Which most definitely will lead to unexpected results :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
