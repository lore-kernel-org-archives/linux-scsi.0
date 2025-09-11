Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DAB28E3F;
	Thu, 11 Sep 2025 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605572; cv=none; b=YfLCDeBt/Awy9dCDLZ4ml3kzqgquzA7rOyIuRjwJh2+5U8t4fH4d2DdKeP8HHHbt2wegg0jQGkBBYMA9NsuJrLmEyMlMg+V+rgRKzq5NYqBsFHR7WXHt+Uy+X4OgpKq1DuRkRjaOzRNccUC81XXJ1hjNMlsm9PcXIgcvK4kW1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605572; c=relaxed/simple;
	bh=lyhydJVWxxwj1pJnwVmPW6ns77T50xHURBxFRabj+NY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YcRd/Fdf+Clsda3VzDaBVfK6ejsw1+vpYCQnaaGk1Wva+lyz58xzps66c96Qcy+9HKVL7wq+PFex7wKPtdJsjN7LSoNqvoiJiQu2nkfp0RkO8GNzSQclPLj1rpu7iWjMRxZ1LVnGedieBvrx2LCQc+oyomoaokiHW28dwgVfn38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VEF1Q47d; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VEF1Q47d"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cN2331xkgzlgqVZ;
	Thu, 11 Sep 2025 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757605565; x=1760197566; bh=lyhydJVWxxwj1pJnwVmPW6ns
	77T50xHURBxFRabj+NY=; b=VEF1Q47dDk1p8nLofYoxkSffYvAUs6/I//rn4WPv
	wNF7cQBm8gwmn8ATnZBXqzkFlVQGWpqSdABfMYIKCC8xN3np6hqHBtktjh4f3/Ik
	Pi44R8s5SCuw+93QF6GB9n5UxkIWvVVY0g6z7ofrm/aHFAufoiLZVGgcJMXdk7NH
	bAjKVgFIuGX6xbG8OFAJ/1K0210TB2327iOIeuTcann+LnVCMpFWPBHbvtnGDg/U
	01uu/coYS2QqkOfUNW209QC63sKPhGcoctJnhh2fNXZCb93C9sJVtKQ92W7znTNT
	yndQ5hAtvPkUc13r00LtZMop1i6HIJor5gpB/zR9GbUAng==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 13Dhq_ajdW6D; Thu, 11 Sep 2025 15:46:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cN22v1CJhzlgqV0;
	Thu, 11 Sep 2025 15:45:58 +0000 (UTC)
Message-ID: <3bc2dae1-c297-45ca-9534-f0405c3bb922@acm.org>
Date: Thu, 11 Sep 2025 08:45:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Improve IOPS in case of host-wide tags
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
 <20250910213254.1215318-4-bvanassche@acm.org>
 <efb81481-5af3-4bb6-b378-878dc24b9767@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <efb81481-5af3-4bb6-b378-878dc24b9767@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/10/25 11:40 PM, Hannes Reinecke wrote:
> That is actually a valid point.
> There are devices which set 'cmd_per_lun' to the same value
> as 'can_queue', rendering the budget map a bit pointless.
> But calling blk_mq_all_tag_iter() is more expensive than a simple
> sbitmap_weight(), so the improvement isn't _that_ big
> (as demonstrated by just 1% performance increase).

Hi Hannes,

In the test I ran blk_mq_all_tag_iter() was not called at all from the
hot path. More in general, I think that blk_mq_all_tag_iter() should
never be called from the command processing path.

The performance improvement in my test was only 1% because the UFS
device in my test setup only supports about 100 K IOPS. The number of
IOPS supported by UFS devices is expected to increase significantly in
the near future. The faster a SCSI device is, the more IOPS will improve
by optimizing SCSI budget allocation.

>> + * that have already been allocated but that have not yet been starte=
d.
>> + */
>> +int scsi_device_busy(const struct scsi_device *sdev)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct sdev_in_flight_data sifd =3D { .sdev =3D sd=
ev };
>> +=C2=A0=C2=A0=C2=A0 struct blk_mq_tag_set *set =3D &sdev->host->tag_se=
t;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (sdev->budget_map.map)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return sbitmap_weight(&sde=
v->budget_map);
>> +=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(!set->shared_tags))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>=20
> One wonders: what would happen if you would return '0' here if
> there is only one LUN?

I don't think that the one LUN case should be handled separately.
The single hardware queue case however could be treated in the same way=20
as the host-wide tag set case.

Thanks,

Bart.
