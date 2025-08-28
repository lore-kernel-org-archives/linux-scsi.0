Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF8F322778;
	Thu, 28 Aug 2025 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399471; cv=none; b=DsQBPvUcpISkJZ4mkVM323IGs7r69B9TjMcIo7ArRgBvFg3NZlaiSt5PwoNweXpqZyMCaxQY6y1jOYVhYkG2K8DqcTjJJcyJoHt/8xY72wwxYdfnP3STHr1y6mNfUMJiQaDuX2WFqoHq+5nh8gDs7OLw2KV5NbegtEBxm91sSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399471; c=relaxed/simple;
	bh=IzMsAG1GZ4aAkOguc3o9/Q9LDoF5c5V+y4FmJ36iQtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ftVbVvphkn0ZiXZ9DD4CS1GjBgh1Zz4uio7vvYrTzb+8YXVde3tt1Bk1Oq7WBvRIeWqeib6GgSPpEG9XqCni4TCo+y8bD3ClC3QIG/p3X6u6XHohbgcn3gDy4TLEot8gDc627SAKdCfUuuE7qhBDx2C4XDGGNgWu5g4xXi52WQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jm/XY8nS; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jm/XY8nS"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24879ed7c17so9042495ad.1;
        Thu, 28 Aug 2025 09:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756399469; x=1757004269; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zshhWi5YHiW5uPIrkm590EqnrvqYM5zhKkyNgQFwd6Q=;
        b=Jm/XY8nSW/kVfuHYujZpVULuVYijBIOnoLDGz0+cTITyUL0eeGQkPPh660pXNyGxj+
         iPdueXONayN3a/S0enK+/uIntbUVg8ElzJ1/pkK05WKwmm9S5SthY++4oUHr1Kdlw3Kt
         FpmcLsTP1ROIARObWVmStV/aDkdA3WvPUTAw53IYXaDDxS3c+VQwXLSR37MDD/Oq/Unz
         v2FoklYru6NQeTb6Xzc4EGu8MVah1HQUSxi9ibKbK70qsro9pNXy0XFX5EOUaFQLx1/u
         5BuS9nAeanZocTSaSYdPdD0DyDKMXZjl0NXJozB7E6EdsHA3QF9wyQBiVtMJ6PXPYXuE
         cGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756399469; x=1757004269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zshhWi5YHiW5uPIrkm590EqnrvqYM5zhKkyNgQFwd6Q=;
        b=nUioQtj9mE95vzx8jnWlGQckq3kkwGugrHnS3du0zEyqRkLaKUL0jmbX5hDCRj1n9h
         0DbdgwL6jaso5Dh1Wk34BCgD4OpvVIoC1l1u7K/4S6mvQIczRMlgoQlLOs6sDDXSxLoV
         yOa+qIEg1u0Hs3dQkItvPmd/6jpgvRbSQkI+c/8hkAn7IrxEGbfSR65mGGe6QZqrDLiC
         psReVzEEO0F6S8Naquo7aBB6EC1o7bH0iBzGhnamNIEWudAks1MR3H0601MP0zf7Q4m+
         KTRs8paHu9o8FZDUxEyh3vd1JgKje9ay+GM9bDHAAi6gxNiJXw3DaoumCAEmHES8GAg0
         PO2g==
X-Forwarded-Encrypted: i=1; AJvYcCWavzPOJSlxp7qmI44FF5308ThZHETScc3NFH7dIVQG73RT9F6C97jlpiifjk6+5vvqkP+e+Hpmo/ViGqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsu/SjVP0M+p2S9w3JXD/k8tvRuYAHn9rlcxSiSJI3usvrgHF5
	a8q7irzmXKxjx0c3rpkdf4li0+D46RD6DCMrNhcV3HnfyQynru5XT4+uLz4YKaKubDU=
X-Gm-Gg: ASbGnct0F4WvaN2Yu8pKW3zt3Y/5g97AcrndyyL22vfOqlcdnGnxR6y7GRjoaRpT+Q/
	RWdE2CpkhPB/Zwe5Y0rF47D3w/SMD6EoRvqoeZvOBgiChm6frHEzh154CluNCbNhdZpm0zRpMCc
	/wPTZGF2CmKaAXk1SvJ83mBNgP6OJjGaw/3psm81uuC0aFW4IN5qUjkbwjH6HgX3CtniNoI++mo
	dlPTBJyXsgZngVjh9TyT81ua/SHg5Hpg/tbuN1SUGrWtsGKrWLUeeZ90JYK8IzYU4AJ8Q8d7kO4
	/xdgbZ/rnaxgZv6nPrwV5avO227n4G3Fz+HPHlKUt2RNXf/wD/jgyGAT4x3Mmzc9lJAETfRlqvt
	d4P09M3c1hmQE/gLyiPqz95MjfAQm/X+NLOqtD00kGIfyQacnYU6aa300Z68v6nngjfOhyg0MaI
	Yh5ZRvrnY=
X-Google-Smtp-Source: AGHT+IG4WfkEPA3lOee3Ow8olkw2rjrtL+9dQ/qGp9hlNjdHLoNKXq5t7w7MtSfbA/XPD3EHiKiuFw==
X-Received: by 2002:a17:903:2ecb:b0:245:f1bb:9bf9 with SMTP id d9443c01a7336-2462ee2bc3cmr349265055ad.12.1756399469365;
        Thu, 28 Aug 2025 09:44:29 -0700 (PDT)
Received: from [192.168.1.43] (c-24-5-244-16.hsd1.ca.comcast.net. [24.5.244.16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249065ad59fsm96085ad.123.2025.08.28.09.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 09:44:28 -0700 (PDT)
Message-ID: <50f040d2-ebf8-46d5-90a9-d102e38791a8@gmail.com>
Date: Thu, 28 Aug 2025 09:44:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] scsi: qla2xxx: Use secs_to_jiffies() instead of
 msecs_to_jiffies()
Content-Language: en-US
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250828161153.3676-2-thorsten.blum@linux.dev>
From: Himanshu Madhani <hmadhani2024@gmail.com>
In-Reply-To: <20250828161153.3676-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/25 9:11 AM, Thorsten Blum wrote:
> Use secs_to_jiffies() instead of msecs_to_jiffies() and avoid scaling
> 'ratov_j' to milliseconds.
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
>   drivers/scsi/qla2xxx/qla_os.c  | 8 ++++----
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 10431a67d202..ccfc2d26dd37 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3106,8 +3106,8 @@ static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
>   	switch (rval) {
>   	case QLA_SUCCESS:
>   		/* Wait for the command completion. */
> -		ratov_j = ha->r_a_tov / 10 * 4 * 1000;
> -		ratov_j = msecs_to_jiffies(ratov_j);
> +		ratov_j = ha->r_a_tov / 10 * 4;
> +		ratov_j = secs_to_jiffies(ratov_j);
>   
>   		if (!wait_for_completion_timeout(&comp, ratov_j)) {
>   			ql_log(ql_log_info, vha, 0x7089,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d4b484c0fd9d..9a2f328200ab 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1291,8 +1291,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>   	       "Abort command mbx cmd=%p, rval=%x.\n", cmd, rval);
>   
>   	/* Wait for the command completion. */
> -	ratov_j = ha->r_a_tov/10 * 4 * 1000;
> -	ratov_j = msecs_to_jiffies(ratov_j);
> +	ratov_j = ha->r_a_tov / 10 * 4;
> +	ratov_j = secs_to_jiffies(ratov_j);
>   	switch (rval) {
>   	case QLA_SUCCESS:
>   		if (!wait_for_completion_timeout(&comp, ratov_j)) {
> @@ -1806,8 +1806,8 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
>   		rval = ha->isp_ops->abort_command(sp);
>   		/* Wait for command completion. */
>   		ret_cmd = false;
> -		ratov_j = ha->r_a_tov/10 * 4 * 1000;
> -		ratov_j = msecs_to_jiffies(ratov_j);
> +		ratov_j = ha->r_a_tov / 10 * 4;
> +		ratov_j = secs_to_jiffies(ratov_j);
>   		switch (rval) {
>   		case QLA_SUCCESS:
>   			if (wait_for_completion_timeout(&comp, ratov_j)) {

Looks okay.

Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>

---
Himanshu Madhani
