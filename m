From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Date: Tue, 04 Mar 2008 09:10:06 +0100
Message-ID: <47CD03DE.3010703@suse.de>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>	<47CC2652.1080601@suse.de> <20080303.140427.39152329.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:52192 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYCDIKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 03:10:09 -0500
In-Reply-To: <20080303.140427.39152329.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, michaelc@cs.wisc.edu

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> Hi Hannes,
>=20
> On Mon, 03 Mar 2008 17:24:50 +0100, Hannes Reinecke wrote:
>> Hi Kiyoshi,
>>
>> Kiyoshi Ueda wrote:
>>> This patch adds ->complete_io() hook for request stacking.
>>> Request stacking drivers (such as request-based dm) can set
>>> a callback for completion.
>>> (The hook is not called in blk_end_io(), since request-based dm use=
s
>>>  it for clone completion in the following appendix patches.)
>>>
>> [ .. ]
>> I would rather have rq->complete_io() to be pointing to blk_end_io i=
n the
>> default case, this way rq->complete_io() would always be valid and w=
e
>> would be saving us the if() clause.
>=20
> Thank you for the comment.
>=20
> I'm thinking about an idea come from Mike and Jens after the session
> at LSF'08:
>   o stacking driver clones both bio and request and uses
>     bio->bi_end_io and rq->end_io
>   o stacking driver uses blk_complete_request() in rq->end_io
>     so that stacking driver can work without queue lock
> With this idea, we don't need to add the new hook to request,
> and we can use request stacking on drivers using __blk_end_request().
>=20
Huh? I can't really imagine how this should work. If you start using
bio->bi_end_io() for stacking usage you'll end up with doing weird thin=
g
with the bios ... Can you elaborate a bit more here?

> Currently, I'm trying to convert request-based dm to use the idea abo=
ve.
> I'll post the new version as a RFC in the near future.
>=20
Oh, cool. Looking forward to it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
