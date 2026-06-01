Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA5E3612ED
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 19:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343943; cv=none; b=Wp7L/p+0r/Vw7YG+GP3hftf6Je7oy94d94tiDJ/ffX+w5kBFh1kKQ9byg7W4KgiwvJvB5q/ybZx0EvxCMIFHg2F5gQ4yQinqKbo6cWBUpvJBDHPY06wZVmYlVgs03SUOF+0bB6dn5SxJ1M0pkpUtfgRjgT6xOakgIG0SO2LlzV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343943; c=relaxed/simple;
	bh=yvt9sp/5rw1QyNxbDG+ApxfyltK9VLSOPVcZat10j7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euHlOZI7Sc1j1qzXNP5O7gQEy+cAKv/zeRrJJvEfIJL2si81pi+Y+cHpioqqsHSOy+U+/jjmeo/vsNiiNAeQROQCmSZV0R729GnKQBG1o8OOcb1h3LY4zeRLdPlC8M8zVKesf58iXOEgYqp1Vrk8qHHcAf0CnjJA3lZ/k0d38Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fL09BPZr; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fL09BPZr"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef7720385so297571f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jun 2026 12:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780343940; x=1780948740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nF0mPffLzyNKxaX+qwdDIt1M45JYJkJ7Btt6JiKxXQk=;
        b=fL09BPZrjZSjczeXG3edIMXez0To7jkTCJkW/Z1Y4T2t0pZdsI6eTXahcz+ozvEaVB
         0ZZxBVWiVLigWgHI4KIG5mBVLSwAUG17N1DUHvs9kqYAficIcpa/zVTJY3o6HiE1uAiu
         VDEtqEKVvFNE55MArl20AYKGYbCn/EdJts6e/64tfzbNy3y4OslHGQ9mC19P2h3q0SIo
         6wRT+0mPa7NIl8n/t8Qf6n57EOh1GpvnBM83GF1oiepnm5PGwgYQqWHr07UY8O/qJLmQ
         MuEI/H3HoooPdUSWbYsiweu8EpUNlBhouc9t3MedLOgrugHrNdl2nqRRun+L8/h/1QrC
         mK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780343940; x=1780948740;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nF0mPffLzyNKxaX+qwdDIt1M45JYJkJ7Btt6JiKxXQk=;
        b=nUqKPgx3OCT+Vi4Kk8RrQRjqkyK/1qqq1uRJwGxnSvz5WfQ5GGeRX6vYohAz3uSHCm
         fCsxqYYoLFBItrFlA7YbkvEdcg19R5NDsUpP7mJn0ydaJrWL+D/o5D5Kafv1brXjkqJV
         u+brmn27bN1VZtA7vc4Kg76xiRQ9DQyGJc3h7hANAJgU4M+8LNRUBuW7wWjHp6L0sTuu
         T8GBEergHFALAPoun7Nip2hrjbQbS0PuUsQDh8VNXbqe8QXlqDFK7vfuJs6zTO1NIsei
         pCxHqU801LCNzOJ0OWamEzmwJY4RM1RyriF6qYDrBl5heVmil9nFY7gcO6mBKbeRI5rG
         Qj2w==
X-Gm-Message-State: AOJu0Yw4nJepZv7kgCzkSfAX88dtyyoCxirvc2Xqc/Qaq7FU0i4edUfY
	ZX3Ypo6uf9LBcvTgacIYjO3Whelv5YQONxXP4Ac/3tA0Ke5EwVensPU=
X-Gm-Gg: Acq92OFIue3myrJJj3tV4TiHbEcAwoj7qFmBOB5WSEALXtb7A4MFjQwkNNrNFqIuggO
	fUQQbo01I9hxmp8cYi/YW9o+eAAz3xhilRn7pdckwvW2Nr6Whse6zkseougWlPyRjwXGFThg941
	lYECLIADNXwnoZlmgL3pu/hCF014/mXpSeyqhC+b0PgBvp2cwDPNfrePtGegmcfNVVQizka1Fab
	lAeliyoQP9sEi2KWOO6nWYQHyizz3kS6kX4ROmzAbXrJoAT5xGB6dgOfm4Tk+pq3qES8WJ9oleF
	flMKGB2zedvJoNlcgM81f0fP9YfCUcNkrt0zkjdwL2fn7QRT985yTEkWsJkun8q06cXbHLU/Dua
	8osyJMJ0tyAWzCN5AeSWaoQlmwdicmcCRT+QvP7dYQzggj567rDibBHdSOXgq5bkj1zK806dcyW
	a3VTVU2VBkn+/3nYGpzga3AaAN32ivcIEXmmu0u/LWBFRUyJvPzHM6jlNdy0foikX8LmQwmcU=
X-Received: by 2002:a05:600c:4753:b0:48a:797f:24f8 with SMTP id 5b1f17b1804b1-490a28ae8camr93776815e9.0.1780343940250;
        Mon, 01 Jun 2026 12:59:00 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0e2e8cesm11343245e9.11.2026.06.01.12.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 12:58:59 -0700 (PDT)
Message-ID: <191cd7dc-f6e7-46c1-8a0c-9e63482f34a0@gmail.com>
Date: Mon, 1 Jun 2026 21:58:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 06/44] scsi: qla2xxx: Add FC operational firmware load for
 29xx
To: Nilesh Javali <njavali@marvell.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>,
 GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
 emilne@redhat.com, jmeneghi@redhat.com, hare@suse.com
References: <20260601102853.328426-1-njavali@marvell.com>
 <20260601102853.328426-7-njavali@marvell.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260601102853.328426-7-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/26 12:28 PM, Nilesh Javali wrote:

> From: Manish Rangankar <mrangankar@marvell.com>
> 
> Add support to load the 29xx FC operational firmware from the
> filesystem and to set up the corresponding firmware dump
> template.  This follows the same request_firmware / segment-load
> pattern used by earlier adapters.

> Cc: stable@vger.kernel.org

New features and hardware support should not be targeted for stable
trees. Only bug fixes or essential regressions belong here.

> @@ -7680,6 +7720,7 @@ qla2x00_timer(struct timer_list *t)
>   #define FW_FILE_ISP8031	"ql8300_fw.bin"
>   #define FW_FILE_ISP27XX	"ql2700_fw.bin"
>   #define FW_FILE_ISP28XX	"ql2800_fw.bin"
> +#define FW_FILE_ISP29XX	"ql2900_fw.bin"
>   
>   
>   static DEFINE_MUTEX(qla_fw_lock);
> @@ -7697,6 +7738,7 @@ static struct fw_blob qla_fw_blobs[] = {
>   	{ .name = FW_FILE_ISP8031, },
>   	{ .name = FW_FILE_ISP27XX, },
>   	{ .name = FW_FILE_ISP28XX, },
> +	{ .name = FW_FILE_ISP29XX, },
>   	{ .name = NULL, },
>   };
>   
> @@ -7730,6 +7772,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>   		blob = &qla_fw_blobs[FW_ISP27XX];
>   	} else if (IS_QLA28XX(ha)) {
>   		blob = &qla_fw_blobs[FW_ISP28XX];
> +	} else if (IS_QLA29XX(ha)) {
> +		blob = &qla_fw_blobs[FW_ISP29XX];
>   	} else {
>   		return NULL;
>   	}
The last available firmware file intended for user-space updates via
request_firmware() was "ql2500_fw.bin" back in 2019 (for the ISP25xx QLogic
2500 Series 8Gb FC HBAs). Since then, no official firmware binaries have
been released or published for newer 16Gb or 32Gb HBAs (such as ISP83xx,
ISP27xx, or ISP28xx), let alone being merged into the upstream
linux-firmware.git repository.

While this code might be useful for your internal development and testing
purposes, adding dead code to the upstream kernel for firmware files that
do not publicly exist provides zero value.
