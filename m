Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AF1332906
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269057; cv=none; b=VgcKet6lv881nXJTN9zXNJb+XH7sYJ3Y2DEmH/AVRXacvKkfWA0zzZ2iCrKMft1P/zHNaBmhP+xcCFSjOrWvaYpDL5MbVWHVRvfmOX1fTswfgFut3ccG5O3T3geTRvI/Ncx0AGJctwAhfXoF454vioCymonIZnZaI+55ABgux34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269057; c=relaxed/simple;
	bh=D3IIq2LPUnQGZvbppqIQT/+oYiFXLXb3OfVqIPblN4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYDtuhtN4mHovlmO3wWav6sT0oH5h2njU/S+Emw4Ckciet2F78L9U9AVu6IvpJ2C8tq+v/OoGo2aTyzLuYiny3rVRwzz4mMvPQlXBsuJyyupnly6O5eVijOuVhO83gYFAdojvdhzm8MWvxg8d93/300wIahg/OydCoG2MEcem3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NozJ1yC8; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NozJ1yC8"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-46019edc13dso494462f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269054; x=1781873854; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mDmKommyygFdcIKP/wPxI3KDoXUUOQdBwbNiW1Mz1xo=;
        b=NozJ1yC8YAfXx9VxcEkInyM/ROm+30majrBCeZmRFtTpqXLQQSwNuC8PLj2A2RSLnk
         jodlU4c/Uf+HWGUhn+FfCwIO2Ezr8d9SMADnrs8mHVejN26zLkotekSzajq3iktgJKL9
         VfxTMGeD7ybq3Za06IvPvYsNcbx8qmUb7UbLUUOHhur4bImXdw/DoeLYa06lq7zQvZOP
         Ct3BMcXju0uJ5Za4j2xLbTJ30W7V1erlYothN/EgXxu87f/+FgOAEo9DyIlNyqM8hYCm
         U66vqJlmMtLptOfZyLg2rFa8D+cP1r1J7vHk6A7U4e1QhGLyGP7jO7EmOKAPWCyNriEp
         7i4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269054; x=1781873854;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mDmKommyygFdcIKP/wPxI3KDoXUUOQdBwbNiW1Mz1xo=;
        b=TUSjQRCOHmxaw3MbQiviBqmpPFp7MT9Y776Fq+dZJR5VDYwck21dhrpoeO1ySvuKDt
         chfrILyVyrD0WQ92OsEFmiWVioS3eHPUzf8p92ReGfm8HVRFPCdIAyuOIxVxGdKp5vlN
         jgKAI0CRlomwWFThBtOXa2r4GDZDI7ZzRkJZAjqf0sRZ78Y5rto8e36tkTOyHQn/DfNm
         E3zU3HGqkpbPs58CKZ3Jz6ndmJCWNRl14XvZOVBotvurrjAg8jlLmbFGqb9LqkUc6jNa
         Wz2xqRgwGqqbuTXwLKeqpnxYflBh0G3Yr6XD7ZHmCIulsqx32XEagc/HdUbeZqDDE5S5
         yOCA==
X-Gm-Message-State: AOJu0YyVJyEOSo6gZXJm/eI2fQdD0UGKE18e2L0I1yh9hSpD9Ys4lA5z
	DJyctG2yxzxTS9klCpQJT1x4l28JrLxyA3YRlCmHl8BvtdvApYLFaEoQQ5Mcvowa1Q4=
X-Gm-Gg: Acq92OEAz+LbwEsZbIRxg8wL+01feGfgUDsrZxdvMAIeJhOj9euLBV21XKMlayXgrJV
	ulVit5LuLVs/2nOEXi4hkw8FOUfy2lzWN/Yi4RuJuDcVQdVg8f0h+grJ3CCg+nEwfK8fs73yLx8
	dnm61W3ZCG+d56FGmsc+Sc7veUrHhYXOtacHRJWVP3lT4bniHuPafHwsBYyegoPdKa+ytje9lbu
	aOczREi7lIJUCwdHGFCbwUUDL17DTCDEO0mU5p2VC/VIWsiAQdI5bbbWgG6M0zDrsDuBitO9psF
	FNr68oUJa6ShfLwfgW8tYkKgqnLmfOY6AqxfVpSbkbfbPDwU2Rz7oWar0DGXuF/dw3iH//bjdaK
	Ld9HsN85yPFmGflbTLHkNBCJt/BcObZ/Epy+TqieuuqoXthBBJ7WD7Yw5iPN7o/YS8J8TpA4oJw
	Ep94XtsipDzXBhVR2Js0FgUdn/IcEZe7KT2cbZqBKmOSVp5gMV9bJebcMy
X-Received: by 2002:a5d:64c2:0:b0:45e:655d:6f7 with SMTP id ffacd0b85a97d-4606dbdf7b1mr4141038f8f.24.1781269054299;
        Fri, 12 Jun 2026 05:57:34 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0d70sm5710938f8f.19.2026.06.12.05.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:57:34 -0700 (PDT)
Message-ID: <9a1aa64d-7c81-40c0-b00a-282d7949c381@suse.com>
Date: Fri, 12 Jun 2026 14:57:33 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 46/60] scsi: qla2xxx: Replace __le16 bitfields with
 scalar and accessors
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-47-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-47-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> C bitfield packing order is implementation-defined: GCC packs LSB-first
> on little-endian targets and MSB-first on big-endian targets.  The
> __le16 bitfield declarations for vp_index/sof_type in the 29xx extended
> IOCB structures produce incorrect bit positions on big-endian hosts,
> and Sparse cannot enforce endianness checks on bitfield members.
> 
> Replace the three sets of __le16 bitfields (in els_entry_24xx_ext,
> els_sts_entry_24xx_ext, and abts_entry_24xx_ext) with a single __le16
> scalar field and provide inline accessor functions that use proper
> le16_to_cpu()/cpu_to_le16() with shift-and-mask operations.
> 
> Fixes: 1b923fdfaeb5 ("scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx")
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_fw29.h   | 39 ++++++++++++++++++++++++-------
>   drivers/scsi/qla2xxx/qla_inline.h |  8 +++----
>   drivers/scsi/qla2xxx/qla_isr.c    | 15 ++++++------
>   3 files changed, 42 insertions(+), 20 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
