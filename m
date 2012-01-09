From: Hannes Reinecke <hare@suse.de>
Subject: Re: Write protected devices, unexpected dm-multipath queueing
Date: Mon, 09 Jan 2012 09:01:18 +0100
Message-ID: <4F0A9ECE.60808@suse.de>
References: <1325878251.19595.13.camel@lapoo.opensvc.com> <20120106223212.GB2393@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab2AIIBT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2012 03:01:19 -0500
In-Reply-To: <20120106223212.GB2393@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>, "cyril.galibern" <cyril.galibern@opensvc.com>, linux-scsi@vger.kernel.org

On 01/06/2012 11:32 PM, Mike Snitzer wrote:
> On Fri, Jan 06 2012 at  2:30pm -0500,
> Christophe Varoqui <christophe.varoqui@gmail.com> wrote:
>=20
>> Hannes, list,
>>
>> reading your kernel path there
>> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=
=3Dcommitdiff;h=3D63583cca745f440167bf27877182dc13e19d4bcf
>> I wonder if this is expected that a write io on a write protected de=
vice
>> is returned to the queue ? I would have guessed it qualified as
>> TARGET_ERROR, hence not retryable (and not causing path invalidation=
).
>>
>> In the following log the sense code is clearly seen as=20
>> Sense Key : Data Protect [current]
>> Add. Sense: Write protected
>>
>> The log is grabbed from a el6 kernel rev. 131 which include the
>> mentioned patch (since rev. 110 iirc).
>>
>> Care to confirm something is fishy there ?
>=20
> scsi_check_sense() needs to be trained to return TARGET_ERROR for thi=
s
> case.
>=20
> The commit you referenced wasn't meant to have covered _every_ possib=
le
> TARGET_ERROR case.  For example, I posted a patch for other TARGET_ER=
ROR
> cases here:
> http://www.spinics.net/lists/linux-scsi/msg55792.html
>=20
Yes, that's correct. We'll need to check for this case, too.

I'll be sending a patch.

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
