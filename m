From: John Utz <John.Utz@wdc.com>
Subject: RE: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Mon, 21 Jul 2014 16:30:27 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C472F6@wdscexmb02>
References: <1405931241-92015-1-git-send-email-hare@suse.de>
 <1405931241-92015-5-git-send-email-hare@suse.de>
 <20140721112904.GB15455@infradead.org>,<53CCFEBE.8080400@suse.de>,<8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomely <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

BAH! I get this ZBC/ZAC thing wrong still. mentally replace ATA with SC=
SI in my comments below....
________________________________________
=46rom: linux-ide-owner@vger.kernel.org [linux-ide-owner@vger.kernel.or=
g] on behalf of John Utz [John.Utz@wdc.com]
Sent: Monday, July 21, 2014 9:18 AM
To: Hannes Reinecke; Christoph Hellwig
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org; James Bottom=
ely
Subject: RE: [PATCH 4/4] sd: Handle ZBC drives correctly

If I read Hanne's patch correctly, he is checking for the ZBC signature=
 when the drives are probed.

Thus, the only circumstance where adding zbc handling would lead to une=
xpected bad behavior in sd would be if a ZBC drive reported itself as a=
 standard ATA drive or an ATA drive reported itself as a ZBC drive.
________________________________________
=46rom: linux-ide-owner@vger.kernel.org [linux-ide-owner@vger.kernel.or=
g] on behalf of Hannes Reinecke [hare@suse.de]
Sent: Monday, July 21, 2014 4:51 AM
To: Christoph Hellwig
Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org; James Bottom=
ely
Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly

On 07/21/2014 01:29 PM, Christoph Hellwig wrote:
> On Mon, Jul 21, 2014 at 10:27:21AM +0200, Hannes Reinecke wrote:
>> ZBC drives are close to disk devices, so update sd.c to handle
>> ZBC drives correctly.
>
> While the other patches all look fine with me I strongly disagree wit=
h
> this one.  Devices reporting the ZBC device type must have sequential
> required zones, so they are _not_ anywhere close to disk devices,
> and writes to them will cause errors that we aren't evenable able to
> handle yet.
>
> If it makes some sort of experiment easier for you we can add a way t=
o
> force ZBC devices to use sd.c conditionally.  Do you have a test devi=
ce
> that this works with?
>
Yes, I have.

I was actually considering implementing a module option for sd
(eg attach_zbc) to allow zac/zbc devices to be attached to the sd
driver.
Which will be off per default, so your concern should be addressed.

However, zbc devices _are_ similar to normal 'sd' devices; it's only
that some commands might fail unexpectedly.
But all the usual commands from sbc are supported, so I found it a
bit odd having to implement my own device driver (which would be a
clone of 'sd' anyway).

Cheers,

Hannes
--
Dr. Hannes Reinecke                   zSeries & Storage
hare@suse.de                          +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
