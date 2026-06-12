Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34993390219
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262861; cv=none; b=c8hKTcfLtwjYI9fws2TaLWVcgbOBw9nOW3+W1pmpMV+tOrl3AXLXApe8KwKNpm3iyBWddK7vEr0BrMeFbMVpu/1A1M20iNpjikZaL+Hz82BkeF/39Y4cvZkCD9IS0JPRB5GXpF6igKUGH2MqwNWA63tAA7hczzm13uC+1FTgtIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262861; c=relaxed/simple;
	bh=tRGFXAskbLB2oy1KJ9ZPJ1yR++64x1cgiVB/Odyq3Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yyo381dE0KNRqxAEBx9YtMW3A8F+7NPqhgm6BiZHsxJo5U+PmvyCga6HjBRdoTxcfIQShScwUJL2V6US2+5tZEDEZj8yzcfb4fD9kFr1qKv1xt6Cagf3GyQRH0vxQSzUcxSWvrasqe6a/dI1oAKrz/piSqoTMFCsepcdDRxd9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IQjGDI4y; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IQjGDI4y"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b9318997so6325265e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262859; x=1781867659; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1QJYcrOG6bLkOdK9i6ZrbsU63hR7hjl1VmYftGp+FJo=;
        b=IQjGDI4yvhOkUL5kWqm/MGLM2SFa9um2rJSDCi6BPwGtH+PI8UPlWk85W7Pu/F8f7H
         Boc7kwSCH1YTGpCxMly5+k+pKJNsNONVHDJeZX6bm4NLhCudpIiNTkav+QjoAW854We9
         KBxRbQaRgVtqMLOrq2Ip6tXLVsV37uuUOxCyo7I7WfGfT9Gr5OmPVPYtxynYJUh7bz7z
         Lb9KfI0wAU5twHMH5UHHrFWIyWNh5qpkiSO334Vb+531Hl6DQw9gXXXf+aQj6doO0VPs
         5gi2ViPz9674ToqctmRoXsS878I3M+2Ks7fYplZBZ5fLlgpI8AwV0CK7aF4WSzJairWL
         POHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262859; x=1781867659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1QJYcrOG6bLkOdK9i6ZrbsU63hR7hjl1VmYftGp+FJo=;
        b=p64UzCv0HNUGJzyhxBTx9V9B/N/Qo7xZE3UjBosNbh/e+z79kDr5yuMsMs6SlwJrxC
         ehhO88bqnomyUJaw3wvukRyItUpn0222jWLNi9Z4A7cP3EjmqfxJbKG6ZmOmUYeD9ahU
         Jh1ZCZirdBCf/aJXmYgdyrpuwTbhSnkdRFss8VwrEH7HxLNFgUwOIQPyYUU8jRdF//4E
         KpRfoxevqpSsv42ICbXbyFrcwATNQ5sFoXXJOHWbJyuDKpL+GKpyfMfLShjTWnn2+ABB
         NoxRKF1qOqe88r25mdKLDxiaC0OdT4KvRmt0bP3AOLH0XnFliFVvVhep3wLpPbBx94rf
         uZ+w==
X-Gm-Message-State: AOJu0YyTRa4hZ2XlJTImdIgWWcKOz1In1BWNhDWokQr8H47UY/u4w+1+
	yvq0iSBYXdqnLwImhLF1pgdNtV6ylYxjtbEeGaZTYAVxWSSbzbGcKtCZ3Be0enZq67Y=
X-Gm-Gg: Acq92OHJw+fH/v/7Z4CUEYlKnlas8/2/xoh+47lIPTJGhCkI4GmzI4zzQk8JG9Con3F
	YiVv0zvhrbg5pnPUnOYjSXwZXgLsYnCjLfHH5QkdXMOCbCsxWfu4ulrzMWjvIb16rx0xGlbuNFW
	8jRwxBYGgynogO7dxsVakOSLCE8GrmyirAYjilas2CR+3TLrwZRUQRNSO5RnDnQC30Bnhfxs7oN
	Q2MtgGIrw/MU1K2LMx8gul4MQSqdAfT5SJEn70M/TtaO5FJ1jBuYe74U9yhcd62aUTK5Um4X7tH
	m3ZbUzyu7ZYU+TIr8TdMfE+YlAvEsqIoco3lNs0E/qBkKoxrRI6OeCFHCseMU93xsTbY8SZAuR8
	bGXKgip4yWo25ImGYfIPOg8EGeCWSTHAmMdY4KSjcqUXScyL52q7vgykeoRQWUZSpDXjvepS2CQ
	sxZ1HrLvK/g8i/lwKG6QW0yXL0+676fWYNnbUwds8blfRdYkNVAPJ5Q7Fg
X-Received: by 2002:a05:600c:c1d7:20b0:490:6237:521d with SMTP id 5b1f17b1804b1-490ec4b186cmr21893895e9.13.1781262858594;
        Fri, 12 Jun 2026 04:14:18 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c90668sm128558765e9.4.2026.06.12.04.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:14:18 -0700 (PDT)
Message-ID: <7eb6011d-1789-4ca0-822f-13375d133e14@suse.com>
Date: Fri, 12 Jun 2026 13:14:17 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/60] scsi: qla2xxx: Replace IS_QLA29XX() size checks
 with entry-size helpers
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-14-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-14-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> Replace scattered IS_QLA29XX() ternary expressions for request and
> response ring IOCB sizes with calls to qla_req_entry_size() and
> qla_rsp_entry_size() inline helpers and pre-computed local variables.
> 
> This consolidates the size selection in eight functions across
> qla_init.c (qla2x00_alloc_fw_dump), qla_mid.c (qla25xx_free_req_que,
> qla25xx_free_rsp_que, qla25xx_create_req_que, qla25xx_create_rsp_que),
> and qla_os.c (qla2x00_free_req_que, qla2x00_free_rsp_que,
> qla2x00_mem_alloc), improving readability and avoiding repeated
> conditionals in every allocation, free, and dump-size calculation.
> 
> Also extend the IS_QLA29XX() guard to the ring-index write path in
> qla2x00_start_iocbs() and the IOCB allocation read path in
> __qla2x00_alloc_iocbs().
> 
> No functional change.
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 18 ++++++-----------
>   drivers/scsi/qla2xxx/qla_iocb.c |  5 +++--
>   drivers/scsi/qla2xxx/qla_mid.c  | 34 ++++++++++++---------------------
>   drivers/scsi/qla2xxx/qla_os.c   | 32 +++++++++++++++----------------
>   4 files changed, 36 insertions(+), 53 deletions(-)
> 
Why?
You just introduced 'IS_QLA29XX()' in one of the previous patches.

Please merge these patches.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
