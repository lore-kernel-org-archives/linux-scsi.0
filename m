Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A024729C;
	Thu, 11 Sep 2025 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609411; cv=none; b=NmD6U9QYJHR+MpUPgw1joS55fC5/dl/Ex2xe9pRaZ2LGGcfKwnsl9nhJjQdv6hEqPYH/o9hdXiAsuCE9ULw+xqIh0F1rU8WZvx2AjPqykmGFAY9woPbjsltnY8k12MLKwtSBI5if4JuGUiFWvX5R2xx29dvLDC9pRCmhuvY1Rus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609411; c=relaxed/simple;
	bh=YeqbVBP4vNzPF1wRiebEVSkDqiEM36amBu3qj4kt2kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=klLisHCV3A66wBIoeJtc8/xe2XQUcu1woDQIlqZeqrT4qV21dATKN0rx2SqFG1EjIkhCzrJTkQ9Lt4w3BxnKGRd99B2z988RoJWP04EsoJ5H5ghq3l6PPUQXQ2wA6bQxl4eTM9qPKvXKfiXZtxRzaft0EH5ARUbzJXWpe+H4lHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JrCjRENm; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JrCjRENm"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cN3Sx1bzXzm174P;
	Thu, 11 Sep 2025 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757609407; x=1760201408; bh=riXv5NSDCB7k8Wv9I+++n0TI
	UpLSQajesA/AUgNadJM=; b=JrCjRENmh9/8DTR4kWH3swh/5ElmztJJcE7uMR5i
	KmfKq4G9Qgg8jIBguAHD41yNvQvtTzLd9N6Brcxd6Dx/tP281Fs6WRF4EFpbpwTH
	rFq1Sn0sgNg8brNiAngnKQXSIVQniE7HETMWbKu4QNDhNrmGi5eFmQKlVuy8i0fC
	YTJ1LXh+t6vFwDtZF1MI5OiKbkj0sq76ZM5YeWQTAG4hAbESju96biSQ1j+h7P4a
	xRz+A9VQouGTqXww9/+Mc8ZAFGBg/GVrwjaPf31/q9sN3sv3Yoa5O9STgp9Rnn8S
	peDvbdtBhk3fyatK6zrErihQF16QYxUy1QFOnce4c7g74Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G9kReXk2_kdl; Thu, 11 Sep 2025 16:50:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cN3Sl5gf1zm0yTF;
	Thu, 11 Sep 2025 16:49:57 +0000 (UTC)
Message-ID: <b890b767-fe4d-4096-81b9-ab94598a33d6@acm.org>
Date: Thu, 11 Sep 2025 09:49:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] block: Export blk_mq_all_tag_iter()
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 John Garry <john.g.garry@oracle.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
 <20250910213254.1215318-2-bvanassche@acm.org>
 <CAFj5m9+8qyEjmRXJHHhZbD1cAKQReTxqahGr69PMKuy=9JMHLg@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAFj5m9+8qyEjmRXJHHhZbD1cAKQReTxqahGr69PMKuy=9JMHLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/11/25 1:32 AM, Ming Lei wrote:
> On Thu, Sep 11, 2025 at 5:33=E2=80=AFAM Bart Van Assche <bvanassche@acm=
.org> wrote:
>>
>> Prepare for using blk_mq_all_tag_iter() in the SCSI core.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   block/blk-mq-tag.c     | 1 +
>>   block/blk-mq.h         | 2 --
>>   include/linux/blk-mq.h | 2 ++
>>   3 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index d880c50629d6..1d56ee8722c5 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -419,6 +419,7 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags,=
 busy_tag_iter_fn *fn,
>>   {
>>          __blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS)=
;
>>   }
>> +EXPORT_SYMBOL(blk_mq_all_tag_iter);
>=20
> IMO, it isn't correct to export an API for iterating over static
> requests for drivers.

Hi Ming,

A possible alternative is to add a new function that is similar to
blk_mq_tagset_busy_iter() except that it passes 0 as fourth argument to
__blk_mq_all_tag_iter() instead of BT_TAG_ITER_STARTED. Something like
this:

void blk_mq_tagset_iter(struct blk_mq_tag_set *tagset,
		blk_mq_tag_iter_fn *fn, void *priv)
{
	unsigned int flags =3D tagset->flags;
	int i, nr_tags, srcu_idx;

	srcu_idx =3D srcu_read_lock(&tagset->tags_srcu);

	nr_tags =3D blk_mq_is_shared_tags(flags) ? 1 : tagset->nr_hw_queues;

	for (i =3D 0; i < nr_tags; i++) {
		if (tagset->tags && tagset->tags[i])
			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv, 0);
	}
	srcu_read_unlock(&tagset->tags_srcu, srcu_idx);
}
EXPORT_SYMBOL(blk_mq_tagset_busy_iter);

Thanks,

Bart.
