From: John Utz <John.Utz@wdc.com>
Subject: RE: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Mon, 21 Jul 2014 16:18:33 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
References: <1405931241-92015-1-git-send-email-hare@suse.de>
 <1405931241-92015-5-git-send-email-hare@suse.de>
 <20140721112904.GB15455@infradead.org>,<53CCFEBE.8080400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdmail01.wdc.com ([129.253.55.43]:59110 "EHLO wdmail01.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaGUQ2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2014 12:28:11 -0400
In-Reply-To: <53CCFEBE.8080400@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomely <jbottomley@parallels.com>

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
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
