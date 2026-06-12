Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D9C3C1096
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263257; cv=none; b=TFvHy0D3AcXECkeaZs+w3SD57cYnl3/XkBPdkKAUpDX3nLqPalh5mIugtQF3k8+BQbwHzTHWCOxe0UYZMnTp1k6janwKkHlLZn9h/wzhzKLCJqGiJISpajgsI2qtvYDmbGphYk5pGmfZT3gltlDeFK6m9UNga/pd7JiMV92F3aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263257; c=relaxed/simple;
	bh=fzAjsfcO6Uj35dLGbQrOMAXl0RV01JWAbcsbIfHSWv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZd7Djtzd4UbMR3Att8LShtBJZES1OM0043DHK50+p3chLKoL9IpL+It9+zTtmEgwES52BLOqI5A01Rhoogw2/gzPNagHdWpAUbeQzAu64NYS5TNt+1+SVlU2QnXeVBago9byUcQPDTY7cLk//YneqHNT2YochQGxKp61TB/Fxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vr25Zzjh; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vr25Zzjh"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490d1e54b3bso10431935e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263251; x=1781868051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+sOaUaWGad6uUNi/7z21KDmn/IjXFQvcikRAycl03Ys=;
        b=Vr25ZzjhhkH8XPg+0CT7AWHcbHgwndud4pN6ZLq7K0Qhtz5FfP7Pi52wM+NcDtGZqY
         jfx3spr9Ooq1+Y3EngdB8XR3qhwjrpj6Xk3PrYNR3XiuSqJ8bQZX360KQ7SkRgETyei9
         tOhh44KN95eHHTveZGzOlTyh9M/EDNirFqAsHKQ+phXj13bEayR0BP3J2NYNgHTdjF/Z
         cQjuHsu2omWxKLBnvdA4LjANpzpY4IoT3DQUDBXw31+8jNv0UOOjaO7QnZbWphDo7KXm
         Nim5q85djQuvSjZgDMuukEAWSzBEpZg1TcoI2NQMyNtv3kpQcW77c9gF9JOVizKxLwpU
         9kVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263251; x=1781868051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sOaUaWGad6uUNi/7z21KDmn/IjXFQvcikRAycl03Ys=;
        b=Zw9RsbiTQKZqxadOjgGYvKlPQ4uzWqgNJyZV4SweAY1vYRPAc8u6Vyh+giFMktGWGt
         G17EGUp7FzWdccaFla0h6CnXNRHrcTEQg08BtdZbE67wJxbgRxF7jHvzn/GvSb+gL2ya
         lTekgORVkiWlal7jAOFBPVk424237IOL8NNaSvFUNLRW7gV8NoJQ4j1k1tnB3TnoZ5R7
         9Ip2LvRzD+pOcogM1qBNNFoMVkl12TQnCTI8gJ25F7WIl7qKYZdnxzhPXtdj11F7ZGZz
         xh1RiQd3z5ZqvNqzbiWc5SIDcP5aToVPzuNdgFZNgdP6kwDn7IzU7MO+vYI7VpgTYpQ2
         /GBA==
X-Gm-Message-State: AOJu0YzRXD/78+esrpUj1qtJ9ekRIpBqVwhXJcs8HC1WGvWoaTygQ1qr
	ORC/1f9UWpRoZ+SxNEXKthNKF/6lS1tb9qX05bQOWot8xvtitk//VvmQ6tVymDFvOTA=
X-Gm-Gg: Acq92OH/Ye2oj/UlZ3UMnG+Do9XnM6lTOFaL+8JuPtlY2jBsXIyuXlCgpSjJgN/EBXX
	ppftGOSZV2Z42wR8un0aeMXHB+JVoXuhZwmXh/g4g7dl8UKk7MxWLbAMXgo7U8u82JMOY7wqGAz
	XmERLYgbp54xLmorJhqPEtsaLxVUQZIv6xTdO1Kg1SYwQuj+gZq3f1Giz4VI+H0XSHKatO7qVdo
	b5SNnOMXqWPKo9XJR1+cAgpLIJ9P7FP3r+x5W4nilFlok2o9Z+HKKRl+/6BQbC3ekKHXZXSeiwg
	9aSkxYMiJSjg+T/0u/3bqJxF1CBCdLLyMtX9gVhyPKdfLQPoiBg5wq7USysDbTXl9EiHJpGT8hy
	pxOmGN18byxp2dVYUFKVsRiLHf8ninY5Q5wAl/IAzVdVzoXu1j5KjYocBsMgjFqS3J7eZTIVqcc
	+Zw3CDCKE5GfO+DHwC3+/zYRZnUHUlOpre6gLA5aKD9SftOvfOob4poxh0
X-Received: by 2002:a05:600d:8497:10b0:490:be41:87c6 with SMTP id 5b1f17b1804b1-490ec4a8309mr21694805e9.10.1781263250663;
        Fri, 12 Jun 2026 04:20:50 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c10sm5075620f8f.21.2026.06.12.04.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:20:50 -0700 (PDT)
Message-ID: <72a55bf8-3aac-43e9-a444-37d296000625@suse.com>
Date: Fri, 12 Jun 2026 13:20:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/60] scsi: qla2xxx: Add support for QLA29XX in data
 rate functions
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-24-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-24-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
> functions to include checks for the QLA29XX series adapters.
> This modification ensures that the mailbox commands are correctly
> configured for the 29xx series, improving functionality and
> compatibility.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 2 +-
>   drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
