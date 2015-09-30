From: Hannes Reinecke <hare@suse.de>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
 device
Date: Wed, 30 Sep 2015 16:49:27 +0200
Message-ID: <560BF677.20405@suse.de>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp> <560BAB2B.9050404@suse.de> <560BBB0A.3000300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbI3Ot3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 10:49:29 -0400
In-Reply-To: <560BBB0A.3000300@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 09/30/2015 12:35 PM, Boaz Harrosh wrote:
> On 09/30/2015 12:28 PM, Hannes Reinecke wrote:
> <>
>> Pushing things into the background is typically not the best of
>> ideas; actually I've been running into issues with udev not being
>> complete by the time the next round is started. So more often than
>> not I would be greeted with messages:
>>
>> 'write: no such file or directory'
>>
>> when executing this line. Removing the '&' at the end made this
>> warning go away.
>>
>> And actually I'm not sure if the above script is a valid testcase;
>=20
> So are you saying it is allowed to crash the Kernel with a crappy
> script?
>=20
I'm just saying there might be race conditions lurking in the sysfs
code which just now came to light, without the patch being the
actual culprit.

>> from what I've seen there is no locking / reference counting when
>> accessing sysfs attributes. So as soon as you _can_ access the sysfs
>> attribute it is implicitly assumed to be valid.
>> In your case you will be _removing_ the sysfs attribute even though
>> it is still accessed, which of course will crash.
>>
>=20
> Is that allowed? for usermode script to race and crash the Kernel?
>=20
> From the original email it sounds like this used to be fine and it
> now crashes (with the &)
>=20
Yeah, it is not meant to be as an excuse. Just an observation.
I still would like to see the results with my ALUA handler update;
there's a fair chance the issue is solved with that.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
