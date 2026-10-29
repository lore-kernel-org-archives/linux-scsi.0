Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270468;
	b=PgvoG5ucJM0ZoLm5oTwMesOmtOnSzLoLzBAs8BW2lrJsrSeE9MD+CTRKk9IpJ/xtJYnD
	 BW0D2T7IscNwlyM88Jk0BeM6d7oNgK1/8635Ar0hiGMVaFK8nks9AybKuQb7Atgk8pBtZ
	 +SjZbBHnMlIudviTr/8kFGbBCNc89+LuqT1pAUsaVQdMeT2E9GMOhAKQVhelnNYdcVtiv
	 S/pIAd0QTuJVyTkD08Zpspgg+sFgHHOUBBr1cyzB+xg/fyaWS65OgvEWsH8sVTHNoYRVv
	 gDKLHhKa1DzO90tRROrQ8XLUWGxyBOxommyPxnEmIY8HabSFG8yXwQBA2adoX4A6T7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270468;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7YTm9ioo95Vo9gklY6fm7lji+ML3t3fOVUT2mwFWX0Q=;
	b=wsUgFuvZ8M+KT12dOjuidBl44A7X8cI5StsrpKwdxJ+EJnyn7XwhyGZC625NI+pNz95G
	 Q2nzH5KWCe7TRaHzy17IN9JbqPdXrxJ6qigTtZJxS7h9YnZHiyZyra08KlA8xIbEpliPR
	 qOQRt76P5bfLOjZdJb8lyqf/xB8/NyLxzCsNwpeUHlprmvLGe6wK0/Ri09MzmWltV0GA0
	 tewR/BxklhtlT3wj+Ips4K4IqgFdZ2R/5Nt+jusV2HCv8YwjVtvU+4qPMbLExvf3dvDT9
	 nefnBm/tcVbd0//ks+TuyJ7Vqmg9+/PiyFZLv06qdr0PKoTGrkiKxFdtGZHCpsAzC4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UJn5KNjy;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD8D606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 10:41:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BD8D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UJn5KNjy
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso1444929f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 03:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793270465; x=1793875265; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7YTm9ioo95Vo9gklY6fm7lji+ML3t3fOVUT2mwFWX0Q=;
        b=UJn5KNjyiRih8vsvpdukZE44AMO7w6G87LNnlo9RcXudohke/6lP6Vx6FsEuF8CfdX
         ntvOaytd9xjKaBH8BcQtqznorK/8Dj4gofogWRdFY0Y6kqN5wb4sReVwXVRcUtaRaeM4
         v13tb23nuRx7cZMhkkcdnb32kl5+ysAYB3yDC9adOuz/XvvuECl2j2823ZjEaXco4Pqi
         9AwDaNY9MGwgFU3FDmjsnFFyYC2T66OYuhEUJTAUhJNZNwWjD43eFD4iCpKmwS8XSnVk
         uPk4NfOg1eTOY4jERyUEGbBy3dGrpo79fkqIL/LpEQ7wgbp29NoqfoteKdE5I5fLRYkv
         zMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793270465; x=1793875265;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7YTm9ioo95Vo9gklY6fm7lji+ML3t3fOVUT2mwFWX0Q=;
        b=OyKY1suS9xnk2Yn9lUnDFI+gz6CnkmQgG8eHvPu2FBtOOtOGSJPbYRaY9e7UX26DGM
         3qhZ4yTUwU31e1mNItBXiTkcDLCc3UeOp1On8XdLNpesPYpxJzW3mAFUY+axwVUqsJVv
         4jc+C+9ODGpbGMlMGCoeMOZDio6mZ6+ASyej6zJMmu7R2nMm+6Qs6Db7kTyMOTqWqsMC
         CTAgEOui3pmPaMitQ+8kmz9mKTN0h3YJnAlLDZXtZDmrdxiR8k5820ZNWDcRb98dvjJz
         wgFSp2xOUv9UlKQK6zqr15U4WfoOCLBc0tdE+3OfwpZsKzCFbT6GLuKlErWPFBeCKzCs
         pfgw==
X-Forwarded-Encrypted: i=1; AKwUvBxKUNdT1Yf4xEGDHRF6goW1Z3zyipvmI8rHT8VEr6Sm6iKVSkKHkQWvEmD5lDL92c6tS33hZiYUYFX3@vger.kernel.org
X-Gm-Message-State: AFq9FYKaQDif8cJrS/iIJujQRtEKiqvCfGUxRqEXmNa8dtgssQq119cE
	vGGZGtU0eD/c1SkzqO9cTOSG2LoEFzJvoGwLO/3Mr/Rdmbef8JXkLImY
X-Gm-Gg: AYBFou1ee018s+2UjRVY5vb0KoUjcL5P/hMGRoNxALE4JKtsOncnKW/fOCna2IirZUd
	yGSeCEnsLHs4w35ZVLPKJMh65+cv+OMsPr/NhVj3ImCq9v6LjPmQE3mitWxdhFNPb4XV29HXNuz
	Noh3pp+BMYSBbBTBzD7InZtvdlQUzOsBY4Tn8IRMtT94nET7UrKE8L4cj+s/1zn3HcpVl0jXwJM
	/Xon/wQajMvUGAL1D21SxTEIIjNt+reutp8qF1/g2Y1BwaL2a9ui8pCn2QmVsS8QhTJA244rRQD
	JaPWUd08qFrZ1l8RX/JqeZEW0OKbLfQTNE3aWC7Bj1o2y+iPhNJhcVrQn2soMgakdM6a5FZ+egY
	imNRbkmEBhjX1wx9XwWkvH9p3G21qzSe2ENn7YLs7e2ufoe2hDmLcT3DSavlJg2/LS721j3h40c
	R9IImRuHeM+/Y+5GY1w42/nubisW33XlYVp0VFbNac41xF1T94Su2yecXEByyVAryiGCcIzotXv
	ERKmSUEfhHof/CO06rQGNfsdx67KANjr8etyDR/C2oAndWz7IjEl6ad9PHimo4tBHd8K+YFukI2
	GrBvnCKxvnvTnd8cGcNxIW5BFaPtf2ghyDQedDjnNTbBRyIeRdRyOPl0AOAZnipaPq/1dP8jmsI
	rStKNRUfQWIfgsKzHBRNzjyEmFW9B/ezvryz48G7GjTr0TlqLijiVuI1t7mqmIOTM41EgMmiTmS
	p+/w==
X-Received: by 2002:a05:6000:29d6:b0:48c:5304:5e50 with SMTP id ffacd0b85a97d-48e5d331691mr7785077f8f.0.1793270465337;
        Thu, 29 Oct 2026 03:41:05 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd48fasm33467703f8f.31.2026.10.29.03.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 03:41:04 -0700 (PDT)
Message-ID: <a0a9ca65-a28d-4361-9813-99b584b9148f@gmail.com>
Date: Thu, 29 Oct 2026 10:41:06 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] io_uring/rsrc: pass import flags to
 io_import_reg_buf()
To: Anuj Gupta <anuj1072538@gmail.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
References: <20261022144501.2478417-1-anuj1072538@gmail.com>
 <20261022144501.2478417-2-anuj1072538@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261022144501.2478417-2-anuj1072538@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 15:44, Anuj Gupta wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Give io_import_reg_buf() the import flags argument and drop the
> __io_import_reg_buf() variant, which only existed to pass them.
> 
> No functional change.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

