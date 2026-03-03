Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4383533FE26;
	Tue,  3 Mar 2026 12:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772540037; cv=none; b=gpfoNZlmRLzVafvYL2UDa/k4X581mu96t67S4cAPMkqzWhNKm7GGMPOk2/ZTd9t95e64HK33FtoTm6fVuZfzjcUFytjnztIcK0xPgiibdpxv7DW1wCZQkjdW8D4UByTpm/2yynkgaw3U9w9yGUnJsFDZ0AgvT1wIYBq2ZpiYHzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772540037; c=relaxed/simple;
	bh=TWj0Uz55Wuh0z68fyA36RmjG//2hytmhazu3ZxHQV4A=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=CGysNgjg4mbpV9ae3FiOXQsdRNyDX+y26o5QGg2JMB0ET08axhnMuxiRzSKegefQMmn9TpFSYJ5O1/d+2DnDwGN9ht4QQLz9obPlefObcH8CZkrhJ2OB59Oyz6IHarySicGrlSfWLS+QNA1xwBUVXmSAkSALWjKEeAs24YZYkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=VL4xd4hz; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="VL4xd4hz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1772540005; x=1773144805; i=markus.elfring@web.de;
	bh=gIp54MN4jChuEYUh7TNa6eqBLe7+iFuIFJTp65fofko=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VL4xd4hzTmxeRHnNfny/2YerGM5ZFuLtzbSrtOQmtHR0nvZlKNaRRud1MdQawEto
	 49B7QDrjPUxSdxjsLExlQ2JXWsLOhJy/6T5w4nhCfHy1qxZrM2pWVGAgqgKzxnOd1
	 O0rxyW4vq3aDchyISnb1hfkWCGlCPALjzBZD2Cbn2MIWKbLOZkdf825FjIDFMEaZy
	 cWguu+UYHb9BiTc/6wMToFTIHlCqJgpXcZ6KFq9LBJGPdWOh2bhbF7jbHphJIgUjj
	 TPDbJpw8FQDoNSdUBKxG1ngOAlKOjnS8YV3SfNIhjCvIuEVbDZF9SZ+5EZyJiruMa
	 GmkiSDgpX8wBtc5a1w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MFJnX-1vvUwm0ZNR-00BCZp; Tue, 03
 Mar 2026 13:13:25 +0100
Message-ID: <317a7883-9470-453d-a3cf-8d819383aca2@web.de>
Date: Tue, 3 Mar 2026 13:13:21 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: John Garry <john.g.garry@oracle.com>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Jens Axboe <axboe@fb.com>, Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>
References: <20260225153225.1031169-3-john.g.garry@oracle.com>
Subject: Re: [PATCH 02/13] libmultipath: Add basic gendisk support
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260225153225.1031169-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Y9Tc070tjaLWTl1kQxMYkGBPvc0yZW6gcj0I/lU6blB2sw2I6X5
 FNV025sdMT51il+Fyo390oz8ADSxrqQEQTVB35shpjZiBYP7pochPJ7Q1oPGW1/Ml0c52qn
 eZi9PcdDyYSAH5lNDPryZJcYkGPLzFZfDCbX9c4qG8YJHI76+yqjO8bRvfAk7UkjFPDObbv
 lfopfHBl9sSQr8KGN4aWg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GvzOakMwmiM=;WR8ltfsCe2n2cQ9lB5rEju6RTFT
 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
 dv4rfAGauumZ3Sr1I4lBt3IXtXCUT

=E2=80=A6
> +++ b/lib/multipath.c
=E2=80=A6
> +static void multipath_partition_scan_work(struct work_struct *work)
> +{
=E2=80=A6
> +	mutex_lock(&mpath_disk->disk->open_mutex);
> +	bdev_disk_changed(mpath_disk->disk, false);
> +	mutex_unlock(&mpath_disk->disk->open_mutex);
> +}
=E2=80=A6

Under which circumstances would you become interested to apply a statement
like =E2=80=9Cguard(mutex)(&mpath_disk->disk->open_mutex);=E2=80=9D?
https://elixir.bootlin.com/linux/v6.19.3/source/include/linux/mutex.h#L253

Regards,
Markus
