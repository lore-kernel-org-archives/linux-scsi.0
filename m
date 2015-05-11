From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/17] scsi_dh_alua: Disable ALUA handling for non-disk
 devices
Date: Mon, 11 May 2015 12:25:51 +0200
Message-ID: <555083AF.1000605@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-3-git-send-email-hare@suse.de> <20150511064643.GB30516@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbEKKZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 06:25:52 -0400
In-Reply-To: <20150511064643.GB30516@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/11/2015 08:46 AM, Christoph Hellwig wrote:
> On Mon, May 04, 2015 at 02:42:08PM +0200, Hannes Reinecke wrote:
>> Non-disk devices should be ignored when detecting
>> ALUA capabilities.
>=20
> Hmm.  I don't think we should even attach the alua handler in this ca=
se,
> e.g. refine the check in scsi_dh_find_driver.  But then again I don't
> remember how the spec wording actually disallows this, and a quick gr=
ep
> of SPC-4 can't find anything either.  Can you put a reference to the =
spec
> section that disallows attachment to non-disk devices into the code?
>=20
The spec wording doesn't explicitly disallowing you from doing so
(unless you're using referrals).
But in realiter we're using the ALUA device handler only when
multipathing is used, which in turn runs on disk devices only.
So we can limit ourselves to disk devices, too.

Everything else (like tapes or tape changers) will have to
implement their own logic anyway; tape support in multipathing
with or without ALUA is too horrible to contemplate ...


>> +	if (sdev->type !=3D TYPE_DISK &&
>> +	    sdev->type !=3D TYPE_RBC &&
>> +	    sdev->type !=3D TYPE_OSD) {
>=20
> And does it really allow RBC (but not ZBC)?
>=20
Thought so, but I'll have to cross-check.
Maybe it's time to implement a 'scsi_is_disk_type()' macro...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
