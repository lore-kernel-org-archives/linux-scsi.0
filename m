From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/17] scsi_dh_alua: Disable ALUA handling for non-disk
 devices
Date: Mon, 11 May 2015 13:55:15 +0200
Message-ID: <555098A3.6030106@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-3-git-send-email-hare@suse.de> <20150511064643.GB30516@lst.de> <555083AF.1000605@suse.de> <20150511113451.GA4803@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbbEKLzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 07:55:17 -0400
In-Reply-To: <20150511113451.GA4803@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/11/2015 01:34 PM, Christoph Hellwig wrote:
> On Mon, May 11, 2015 at 12:25:51PM +0200, Hannes Reinecke wrote:
>> The spec wording doesn't explicitly disallowing you from doing so
>> (unless you're using referrals).
>> But in realiter we're using the ALUA device handler only when
>> multipathing is used, which in turn runs on disk devices only.
>> So we can limit ourselves to disk devices, too.
>>
>> Everything else (like tapes or tape changers) will have to
>> implement their own logic anyway; tape support in multipathing
>> with or without ALUA is too horrible to contemplate ...
>=20
> So what is the problem you're trying to solve here?  We were attachin=
g
> to other nodes and so far I haven't heard about that being a problem.
>=20
> Basically we'll disallow I/O for offlines paths to non-disk devices
> once the ALUA handler is attached, which actually seems useful
> even without a multipath handler on top.
>=20
I've had far too many issues with ALUA attaching to eg enclosure
devices; some enclosures have the habit of returning 'NOT READY,
CAUSE NOT REPORTABLE' when sending an RTPG to it.

Other (broken) devices set the 'TPGS' bit in the inquiry data,
but fail to implement support for everything else.

Currently we're just doing a retry for these cases, and would
have to wait for the timeout to kick in.

We _could_ implement a dedicated error handling here, but
then we're pretty much guaranteed to miss the odd case.
So I've decided to just skip them altogether.

If you insist we could remove this patch, and straighten out
error handling here.

>>>> +	if (sdev->type !=3D TYPE_DISK &&
>>>> +	    sdev->type !=3D TYPE_RBC &&
>>>> +	    sdev->type !=3D TYPE_OSD) {
>>>
>>> And does it really allow RBC (but not ZBC)?
>>>
>> Thought so, but I'll have to cross-check.
>> Maybe it's time to implement a 'scsi_is_disk_type()' macro...
>=20
> If the reason to disallow anything that we can't use dm-mpath on
> both OSD and ZBC in it's current form are excluded.  RBC would
> be included, although I doubt there is a multi ported RBC
> device available.
>=20
As said above; we _could_ drop this patch and update error
handling, but then we'll risk of having more bug reports
due to invalid ALUA implementations.
Might be worth it, though, as then we could get in touch
with the respective vendors. But then, maybe not, as not
every vendor is willing to listen to us...

I don't really have a fixed opinion here; either way is
fine with me.

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
