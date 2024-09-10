Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C798116DED5;
	Tue, 10 Sep 2024 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725991193; cv=none; b=lzCLyjQIG9qbC7j+sT8B0eqN0yB/UDyx+T5WWUFJdDG3Uv5/E1M+9FPs9O2ihhGlx/5kq/yq2uR8aL31Ol5aC1yhevlN+j43pUe65DbPDfxhNwzoJ0qbAYzEEki9QF1ILsi/ORmpE/tT0oALcneU/NjYKJKchfZcFZWczyzYpqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725991193; c=relaxed/simple;
	bh=OwP3+I3acA6YRD1AxGoP9eoRcytom+/4gfnsPh7Ru/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNCJ0stHfOqT+dJ/fvEC0pe94QWP9oCMCCWxOMX8R24l3RRgREeva9CHxF9jWGkq0a18XJqZZXY3gQ3+ArXDRpicZ0FZ9SE9W/JLCJNVCsUXh6VTz7eCyP/ShmXPrcbGGZ0TkswyL5oZ35TH4Rgoj4LG9pC+kS+A+UxvRBtUPfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UD4IcbBk; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UD4IcbBk"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X3BL967XNzlgVnf;
	Tue, 10 Sep 2024 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725991174; x=1728583175; bh=oRpBILn97hQlAgqu+BPpd8j0
	wIORp8/sYsHHAPwOHwk=; b=UD4IcbBkrLSUorg1mwaLj3gCH9px3fa3/cCIWLau
	Yi0TC9URYhFajnf5t4Xx6rkFrNoZk+jsnhvrC0du5Kr6oElQ/ecp8xvGr2gHc2RX
	/h5Kc7V62EB2570/EGWCWP1muZwaPCVoczra9dhbTh11nOSNGTaqnE53/JK5bOUq
	ErWn9eS9qqM/7YbqqjkQcsK43u4BJfvAMtsIv428kC4A3+wTUPlISJD5b+f14JYu
	IZskNUv4U8YkBONQ7QN5aVWi719R+QpO6tMPcCItbqk6H8ncbs6xPLelstjujOdG
	OJVevr8exVNRhq6KTBu5rwT8HR6I88x6sTQg1f26RFXwzw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IFyM8jt2rizU; Tue, 10 Sep 2024 17:59:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X3BKw4H3dzlgTWQ;
	Tue, 10 Sep 2024 17:59:32 +0000 (UTC)
Message-ID: <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
Date: Tue, 10 Sep 2024 10:59:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20240910073035.25974-1-peter.wang@mediatek.com>
 <20240910073035.25974-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240910073035.25974-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 12:30 AM, peter.wang@mediatek.com wrote:
> ufshcd_abort_all froce abort all on-going command and the host
                    ^^^^^ ^^^^^              ^^^^^^^         ^^^^
                forcibly? aborts?            commands?   host controller?
> will automatically fill in the OCS field of the corresponding
> response with OCS_ABORTED based on different working modes.
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The host controller only sets the OCS field to OCS_ABORTED in MCQ mode
if the host controller successfully aborted the command. If the
abort TMF is submitted to the UFS device, the OCS field won't be changed
into OCS_ABORTED. In SDB mode, the host controller does not modify the 
OCS field either.

> SDB mode: aborts a command using UTRLCLR. Task Management response
> which means a Transfer Request was aborted.

Hmm ... my understanding is that clearing a bit from UTRLCLR is only
allowed *after* a command has been aborted and also that clearing a bit
from this register does not abort a command but only frees the resources
in the host controller associated with the command.

> For these two cases, set a flag to notify SCSI to requeue the
> command after receiving response with OCS_ABORTED.

I think there is only one case when the SCSI core needs to be requested
to requeue a command, namely when the UFS driver decided to initiate the
abort (ufshcd_abort_all()).

> @@ -7561,6 +7551,20 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>   		goto out;
>   	}
>   
> +	/*
> +	 * When the host software receives a "FUNCTION COMPLETE", set flag
> +	 * to requeue command after receive response with OCS_ABORTED
> +	 * SDB mode: UTRLCLR Task Management response which means a Transfer
> +	 *           Request was aborted.
> +	 * MCQ mode: Host will post to CQ with OCS_ABORTED after SQ cleanup
> +	 * This flag is set because ufshcd_abort_all forcibly aborts all
> +	 * commands, and the host will automatically fill in the OCS field
> +	 * of the corresponding response with OCS_ABORTED.
> +	 * Therefore, upon receiving this response, it needs to be requeued.
> +	 */
> +	if (!err)
> +		lrbp->abort_initiated_by_err = true;
> +
>   	err = ufshcd_clear_cmd(hba, tag);
>   	if (err)
>   		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",

The above change is misplaced. ufshcd_try_to_abort_task() can be called
when the SCSI core decides to abort a command while
abort_initiated_by_err must not be set in that case. Please move the
above code block into ufshcd_abort_one().

Regarding the word "host" in the above comment block: the host is the 
Android device. I think that in the above comment "host" should be
changed into "host controller".

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 0fd2aebac728..15b357672ca5 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -173,6 +173,8 @@ struct ufs_pm_lvl_states {
>    * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
>    * @data_unit_num: the data unit number for the first block for inline crypto
>    * @req_abort_skip: skip request abort task flag
> + * @abort_initiated_by_err: The flag is specifically used to handle aborts
> + *                          caused by errors due to host/device communication

The "abort_initiated_by_err" name still seems confusing to me. Please
make it more clear that this flag is only set if the UFS error handler
decides to abort a command. How about "abort_initiated_by_eh"?

Please also make the description of this member variable more clear.

Thanks,

Bart.
