Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5792A31280C
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 11:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450272; cv=none; b=FldmWD2rUTa3iF/poagde1wKPStkl4/qkhOxPN9uTPsshT2+N2mdrZhHNtqZ5xs/4/Bw9lgEITjwVs4TxsZ2eQqePr43uYydJHeDA6PqMRZb/MN2mldkvusFaUa329E2Ty7lwOArtw93I+PMEbf3pn7zTnszerAmLQko1M9dR2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450272; c=relaxed/simple;
	bh=beHtVNadORTTQnW2D6Hsv0RHmfMffj1CMVY9xl4mQI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoNibzUflkqznAFlAWmyrAjN479vAfh3sogL1U1NYq5lOTP9C5x/NNR60ElIL2HqAD1p/SyuRQGquoiMm1yMiXQjE7hENrRD2chlnBb11Ndu7xA2jYhAXwiRanOH8xBdwp4xgV6MjWVsnjml45zru7mZDGaM/oLNn+pB2zkkPD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1RIqCBK; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1RIqCBK"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2be1d9c356cso16812eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 03:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772450270; x=1773055070; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4zozHfyLZdL8Rdos9EihR1W/wEBAj/hsnL6F4jkrfn0=;
        b=Y1RIqCBKnekc0K4+EVvcvQvknIKh73KPR6Dh8bD3ZTeZXeBpzE0Yhvw7mru/Gaw1Dp
         BW46oBD9+nzM9NBhNaPQigBngo26myUZz++RLtOBkToi36Ge2KIQu7goYI9jr5BXpRCj
         tPRQYSdYlfKC1HKNB6Qa+OK3BOpp2WMse8eMMJZVIwcFWvrNajki5vn2t7ANups1s/Dv
         yXSqrIfUwzmGxjUff4VQTRpOoyUOyISn3MrPVpdETViV3WiXrhnCR/ujMY2q6gYh6PJa
         Bhh+q5EztrfRj7q9UB8vvhlyDfc2vSn+iqoGkl2oZ5ORQg01lGMVWc+cTxQPD6jYtqXi
         c99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450270; x=1773055070;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4zozHfyLZdL8Rdos9EihR1W/wEBAj/hsnL6F4jkrfn0=;
        b=pSL53EDxBHkBnxx9HsOAOnil2E5XTMiwsETip51fu9CTZGFcaXxrNs+kFhTG+98CdQ
         0QqtmEWG8t9CmrVNYDdeDc5O1u9zvewvIkPs9HcNv59fK163+tJuo7nJwn6TrV/ohNHd
         ujaOsbw9Viig8FjDHyRBsCq29a3EPNb5IEAJN17byf7pMO9L1GNUpnDdHWAOrv5/1SY+
         o4182drPjvGo+8GF3sIAG/5Yak0Wa1n+JQqzHRyBJCkhLsKGqxtewuIkIjYxZRd3Yc5f
         celaXCacrr3rsemru/k83CSQ4YV0oGtcvNOZ+WtLP0l0Mpj7rTZtGBXlF2vg+pEkFQAm
         zvog==
X-Forwarded-Encrypted: i=1; AJvYcCWTNOWqsMu8q8oiUnIgTXovWHiMsTcx1k5rqn2MiKaIXTKgnNyu6ODmIMlPVduFh5/ajwRS1+6jGYTH@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+6w7yT3jbnA4rZDGNOaJoI3pUcVUbNP+y0dLBhJSwnlJN4Boy
	iIcVRvZ2QottDZ2R22zbRVVzlcGKmRiYdelhEXOXxdL+aG+bWbcBkzCm
X-Gm-Gg: ATEYQzwBahroHKrgrxgmp9rgukL9Y6FkFT3a8j4WGBgLoW1kY6bm9mDAFMWAPUrmlE6
	B5cg8vL1LNNBWXm9RZHWwl/QWj5tmG437fpPxSFQh0anKNi8G4BXq3GigLZvxm7PF1cRgHPAM8s
	bASzfTTrPPm9jxSjvwf+OGkksl2mO7CYUJmwupv84VH2SUy+ZTKdhAV7MxINuk4jRNwIDw4mea3
	zUOv6yf6+bJgv7A0G3ok/kOuL3GwulOz1+QZYwqsPs+WqiUg6w+d3DYDm6q4jWJ0g2Umvq2D/4a
	ixlEVefpjoTLSLoKIT5/BtiIfBMeyZi2bOaOinbsltwqDRq4KpkSUJfNc/wp8M/zpcZH0FoQyjz
	fJPukC2hq76WnVoLIIVYCzIIYkruI9wkUFY0aroN6jB3bmkR9s17Y0msU247JaByG/0/4+y4sR0
	CRKLoy9LolldSE99aUBkNbFaTP6fb4ri5aaHQc
X-Received: by 2002:a05:7301:1e96:b0:2bd:d157:6786 with SMTP id 5a478bee46e88-2bde1c99c66mr5451690eec.25.1772450270322;
        Mon, 02 Mar 2026 03:17:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f4658esm10358245eec.25.2026.03.02.03.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:17:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 2 Mar 2026 03:17:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Nilesh Javali <njavali@marvell.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
	sdeodhar@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
Subject: Re: [PATCH v3 11/12] qla2xxx: fix bsg_done causing double free
Message-ID: <2a2859ea-4815-48bf-bb91-07fd06b73f4a@roeck-us.net>
References: <20251210101604.431868-1-njavali@marvell.com>
 <20251210101604.431868-12-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210101604.431868-12-njavali@marvell.com>

Hi,

On Wed, Dec 10, 2025 at 03:46:03PM +0530, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> Kernel panic observed on system,
> 
> [5353358.825191] BUG: unable to handle page fault for address: ff5f5e897b024000
> [5353358.825194] #PF: supervisor write access in kernel mode
> [5353358.825195] #PF: error_code(0x0002) - not-present page
> [5353358.825196] PGD 100006067 P4D 0
> [5353358.825198] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [5353358.825200] CPU: 5 PID: 2132085 Comm: qlafwupdate.sub Kdump: loaded Tainted: G        W    L    -------  ---  5.14.0-503.34.1.el9_5.x86_64 #1
> [5353358.825203] Hardware name: HPE ProLiant DL360 Gen11/ProLiant DL360 Gen11, BIOS 2.44 01/17/2025
> [5353358.825204] RIP: 0010:memcpy_erms+0x6/0x10
> [5353358.825211] RSP: 0018:ff591da8f4f6b710 EFLAGS: 00010246
> [5353358.825212] RAX: ff5f5e897b024000 RBX: 0000000000007090 RCX: 0000000000001000
> [5353358.825213] RDX: 0000000000001000 RSI: ff591da8f4fed090 RDI: ff5f5e897b024000
> [5353358.825214] RBP: 0000000000010000 R08: ff5f5e897b024000 R09: 0000000000000000
> [5353358.825215] R10: ff46cf8c40517000 R11: 0000000000000001 R12: 0000000000008090
> [5353358.825216] R13: ff591da8f4f6b720 R14: 0000000000001000 R15: 0000000000000000
> [5353358.825218] FS:  00007f1e88d47740(0000) GS:ff46cf935f940000(0000) knlGS:0000000000000000
> [5353358.825219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [5353358.825220] CR2: ff5f5e897b024000 CR3: 0000000231532004 CR4: 0000000000771ef0
> [5353358.825221] PKRU: 55555554
> [5353358.825222] Call Trace:
> [5353358.825223]  <TASK>
> [5353358.825224]  ? show_trace_log_lvl+0x1c4/0x2df
> [5353358.825229]  ? show_trace_log_lvl+0x1c4/0x2df
> [5353358.825232]  ? sg_copy_buffer+0xc8/0x110
> [5353358.825236]  ? __die_body.cold+0x8/0xd
> [5353358.825238]  ? page_fault_oops+0x134/0x170
> [5353358.825242]  ? kernelmode_fixup_or_oops+0x84/0x110
> [5353358.825244]  ? exc_page_fault+0xa8/0x150
> [5353358.825247]  ? asm_exc_page_fault+0x22/0x30
> [5353358.825252]  ? memcpy_erms+0x6/0x10
> [5353358.825253]  sg_copy_buffer+0xc8/0x110
> [5353358.825259]  qla2x00_process_vendor_specific+0x652/0x1320 [qla2xxx]
> [5353358.825317]  qla24xx_bsg_request+0x1b2/0x2d0 [qla2xxx]
> 
> Most routines in qla_bsg.c call bsg_done only for
> success cases.
> However a few invoke it for failure case as well
> leading to a double free. Validate before calling bsg_done.

qla24xx_bsg_request() is called from fc_bsg_host_dispatch(), which
indeed calls bsg_job_done() on errors. However, it does a bit more:
It sets reply_payload_rcv_len to 0 and reply_len to sizeof(uint32_t).
This means that the result from the functions below is now dropped.
Yet, several of those functions explicitly set values in the reply
if ret != 0 (which may explain why bsg_done() was called even with
ret != 0). Is this ok/acceptable ?

Thanks,
Guenter

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 8afa8a4b8ccb..2c44a379cb23 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1548,8 +1548,9 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
>  	ha->optrom_buffer = NULL;
>  	ha->optrom_state = QLA_SWAITING;
>  	mutex_unlock(&ha->optrom_mutex);
> -	bsg_job_done(bsg_job, bsg_reply->result,
> -		       bsg_reply->reply_payload_rcv_len);
> +	if (!rval)
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
>  	return rval;
>  }
>  
> @@ -2638,8 +2639,9 @@ qla2x00_manage_host_stats(struct bsg_job *bsg_job)
>  				    sizeof(struct ql_vnd_mng_host_stats_resp));
>  
>  	bsg_reply->result = DID_OK;
> -	bsg_job_done(bsg_job, bsg_reply->result,
> -		     bsg_reply->reply_payload_rcv_len);
> +	if (!ret)
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
>  
>  	return ret;
>  }
> @@ -2728,8 +2730,9 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
>  							       bsg_job->reply_payload.sg_cnt,
>  							       data, response_len);
>  	bsg_reply->result = DID_OK;
> -	bsg_job_done(bsg_job, bsg_reply->result,
> -		     bsg_reply->reply_payload_rcv_len);
> +	if (!ret)
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
>  
>  	kfree(data);
>  host_stat_out:
> @@ -2828,8 +2831,9 @@ qla2x00_get_tgt_stats(struct bsg_job *bsg_job)
>  				    bsg_job->reply_payload.sg_cnt, data,
>  				    response_len);
>  	bsg_reply->result = DID_OK;
> -	bsg_job_done(bsg_job, bsg_reply->result,
> -		     bsg_reply->reply_payload_rcv_len);
> +	if (!ret)
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
>  
>  tgt_stat_out:
>  	kfree(data);
> @@ -2890,8 +2894,9 @@ qla2x00_manage_host_port(struct bsg_job *bsg_job)
>  				    bsg_job->reply_payload.sg_cnt, &rsp_data,
>  				    sizeof(struct ql_vnd_mng_host_port_resp));
>  	bsg_reply->result = DID_OK;
> -	bsg_job_done(bsg_job, bsg_reply->result,
> -		     bsg_reply->reply_payload_rcv_len);
> +	if (!ret)
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
>  
>  	return ret;
>  }
> @@ -3272,7 +3277,8 @@ int qla2x00_mailbox_passthru(struct bsg_job *bsg_job)
>  
>  	bsg_job->reply_len = sizeof(*bsg_job->reply);
>  	bsg_reply->result = DID_OK << 16;
> -	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
> +	if (!ret)
> +		bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
>  
>  	kfree(req_data);
>  
> @@ -3359,8 +3365,9 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
>  	bsg_reply->result = DID_OK << 16;
>  	bsg_reply->reply_payload_rcv_len = 0;
>  	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> -	bsg_job_done(bsg_job, bsg_reply->result,
> -			bsg_reply->reply_payload_rcv_len);
> +	if (!rval)
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
>  
>  	return QLA_SUCCESS;
>  }
> -- 
> 2.23.1
> 
