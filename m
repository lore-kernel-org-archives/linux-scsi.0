Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD9E360EE1;
	Mon, 13 Jul 2026 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783921431; cv=none; b=gIcpjwiOv7vJ8HHMgoyk/9q/4wpBkpvhGfilINDZ+FEJZcoLwgsrZTc+Z5BowVqhckQMcN82cAGMHf1mNAhQo1zTkHf3Gqmpwc3dUw1K/w14RzQ8Mm+ijio4l1DIOx+P33WlNAwi7ULJgidm1o0xFoUlOhL7lA0TQajp6QE2eRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783921431; c=relaxed/simple;
	bh=fQQauDvquFNVkljquuUCTZ/0N14ZPibLdvgA2db5jr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ktJ59r4TbMNix2fTxXOkgtye6eRgqc2iPou4aXFUyzaQ353sPNcawa9SVPa8QIPUlquQt+Kbf1R/dUibr2NR0D+/Ttnt6maHoZd6VqGar7BEns+qoZLmbxgrbG560d3bH/4tWprU2HAfd/3sZkORzEOs9ey7mC6CdQ6sbemP770=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcedfHK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcedfHK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E51F1F000E9;
	Mon, 13 Jul 2026 05:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783921429;
	bh=TzhiU6V/SRkdXn64SP6A00c/m/jt5XsqeIpJAiXO25w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OcedfHK4YYkqygLuGSwdXJLwD3T8hM+ps/HClwp81UQ1vD4ym3pyJuM0rkF3ABtRy
	 tXPjc/4eAR7h9rEn5e4yRgUfS6XvF85jlXI234HKuiB1FG2VE6xbg6ljvIkY1wP8BR
	 rzcOEpJJjPBQDkcqZ6UL2BY/+9x4RIAh3X7pJ96G9rE7Doiwdv9UN4V2FuJx8vRXIm
	 FLkTOXzEzET45OMretFagfopv2HRQVEuodzsGAxTWp/Tza50IF0A2rK1ndMM1xGTKl
	 r7u6IwA8e01rtuyTKd4G/t5uMQZ6lJevG8U7vOZXc38P0AaLpZxwds3akxOwdhZDcd
	 7773YFJiq+TLA==
Message-ID: <c276a318-34b6-403a-8dd0-0271764d5860@kernel.org>
Date: Mon, 13 Jul 2026 14:43:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow
 OOB write
To: Ibrahim Hashimov <security@auditcode.ai>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: bvanassche@acm.org, shinichiro.kawasaki@wdc.com,
 damien.lemoal@opensource.wdc.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260710055755.53830-1-security@auditcode.ai>
 <20260712183739.83915-1-security@auditcode.ai>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260712183739.83915-1-security@auditcode.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/26 03:37, Ibrahim Hashimov wrote:
> resp_report_zones() sizes the reply buffer from the CDB allocation
> length. The v3 fix rounds alloc_len up with ALIGN() before deriving the
> descriptor count:
> 
> 	rep_max_zones = (ALIGN((u64)alloc_len, RZONES_DESC_HD) -
> 			 RZONES_DESC_HD) >> ilog2(RZONES_DESC_HD);
> 	arr_len = (u64)RZONES_DESC_HD * (rep_max_zones + 1);
> 
> For alloc_len in 0xFFFFFFC1..0xFFFFFFFF, ALIGN() rounds up to
> 0x100000000, so arr_len is 4 GB. On 32-bit, kzalloc()'s size_t is
> 32-bit and truncates 0x100000000 to 0; kzalloc(0) returns
> ZERO_SIZE_PTR, which passes the !arr check, and desc = arr + 64 is then
> dereferenced in the loop -> out-of-bounds write / panic.
> 
> Clamp rep_max_zones to devip->nr_zones. The loop already stops at
> sdebug_capacity (after nr_zones zones), so a report can never hold more
> than nr_zones descriptors; the clamp does not change the report, it
> only bounds arr_len to (nr_zones + 1) * RZONES_DESC_HD, a real device
> property that can never reach 0x100000000.
> 
> Fixes: 7db0e0c8190a ("scsi: scsi_debug: Fix buffer size of REPORT ZONES command")
> Suggested-by: Damien Le Moal <dlemoal@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> Assisted-by: AuditCode-AI:2026.07

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
