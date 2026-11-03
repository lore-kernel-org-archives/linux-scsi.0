Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735022;
	b=Giiq0wxKrilgsFC/6R+as6ZhBDL1C9qy7AAuzV18j9W3vQjpkseQx1902t3UfNlwEoLl
	 j+55++W1IlTpbPxoKxU5DxvcSEczEpyjpxHEEd1fqsjCDhAn3P3s6Q8z5FwQ6zA3hjWtz
	 81gP0rQvN6EJPzh6E7ad2bDvGrGd/KN6B+kpIwbOpYdNzNNUZK3PkS4hhb4C6bowuYakT
	 FcSO1rjvyKyVWZiC4DRMhx9cdwTdEsFx2SDAdI9xCQ/3dByN+VL3NwSNNHDzfiRu5TSP9
	 wLuxkGIPUXC5kzeYYbWUBeJWWGtLW/xZbwUQ8k1i8J2EASSPsUWRTAIBusrROmGt7pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735022;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=pM+ObFq+7UvTBHo/IKaCGchHuKGnrduWJa929a2AGj4=;
	b=Jm0sU9sLXaub3C4y1Nj9HdCQ7Ll8R6c1QmngoDW5YeTN3/kNQ+7b8qcoWh/Fr+u0CWiQ
	 dkcU62XROG5C62MbjocVJukrRJVPfND56aIv6F06RZA23leFgR4LyC8w6UyodrsIrG4YJ
	 oyTwnBu24GSlhZchoIyQCMBSWcRQNk6JK77p4tjs/MfZt1J+IVTV4Zwpu8DIXbNKUuUr9
	 A9w+yKpLYnpanei143E7DrJpWygU7bInYjJBi8vJ4PCDIoyxiU1J++Km8CAMA/2CimwqT
	 wS0OujOmLsH3JDZMvtpg+eFT+V7sW94AanQM2iq7RZRi3/HiylLAlFE9045Br5M1PKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=lbPap6xL;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A12606A331
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 19:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8A12606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=lbPap6xL
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b1ce85287aso5663c88.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2026 11:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793735021; x=1794339821; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pM+ObFq+7UvTBHo/IKaCGchHuKGnrduWJa929a2AGj4=;
        b=lbPap6xLlqMk+JYnuSIyFjcRQFqANvPP5Qqin+Bz3DY7GsGTRk8PniDPJ15f+G5ilO
         r9FUH9gktdgCzOrQpBTRygzrW0nj0WmLAxNtcOyIHnDJx0oZzTd14VRe3a1Nni0MjvN0
         78W91quHXoMTrB33+q740l4pO9Al9IeFiNf8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735021; x=1794339821;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pM+ObFq+7UvTBHo/IKaCGchHuKGnrduWJa929a2AGj4=;
        b=cm0CbtTxBxuHVTxj6H9VRS1g4ETSWg4HIbYIbKbFLhjYEcbW/q5K+6f76meN9vR/08
         S/1Qskde1XhGWhT4hnpXkmomQ3NXIPLPnY/B+dtWjCyxzFbyvWZlF8ZNBYEstUjaoquc
         HJJTj2am2smROU+yz3cpW5ded03P1cuxJS0zLq+77xrm9rrwsKqqgq4DbFO3pJwbF6dI
         vmxemSu3MhnEqIrhK0oWERL9XgcJPKQfRTKDlIXLwezjAzKTPH7L0cAZizPUN+RIdv8c
         N0DpdTBQKoNkN9IAuIFA7p0GLrS8nQ+V47YJJUkFEb3h9kjBYU6Cv0YW3qEk2QcV1744
         JNgw==
X-Forwarded-Encrypted: i=1; AKwUvByzT5eVaXblxabTR5x7Ff1F8x2YIyqyszMkPi+9CFRhWdyQzWu0R6B7+mVdIEQysn/Kug5HZn/hOmkB@vger.kernel.org
X-Gm-Message-State: APuU4Z+g+Nadswm59VR43lMZjneYxlCV01XYFr/JcMTjBO8uvo5zGs6x
	oWqaj8zPXyQNcQbm5t8oWWniL6AJGUuJZc1G2MMW8vfH9Bp89A92ji4Aju0klY7Esg==
X-Gm-Gg: AYBFou3Qc2mqRsbH4kwyRxXH/lKD7dtmjMHoD2WCfUnjt42ibBhpoN8gfyRRDhhdAl9
	Pp0HrltEauDNhbRjmtjBR/U1pBP1xcJEQ/54NlMFpAtqCuSydIlP7cAgyMvrzWHZo2EHXFTnYsg
	N2bJ/3JKwZ41LT7bsWAGLe2yWm1V8wcmD2mc3wSflenoSjuM0bnHOPDuqVSauwr0pPkFMeH8gBr
	g57RfEzJFqOjEaB9PxnPj7X6kQTKTigca5d/gOKqJVmugtJFK1B7SyV8DdF1HxCN8v7IStkeeGB
	4/YVjWbl/M4QJpzCktN6lXVTMIuQN2dE6bXpLkpI8UT0yAPJ+fySpBRJUMccidBLApK89O1q+uE
	YVrgR/E4myEqsjJYj9OSL7yBI19UpcYXSgEJY0Q3NdBz1RM7Q8s4rt50WUcUKYIEoP7XwdE8qEC
	yuY2Kr04p+yVWe5RZJ/kMxVNsHdHK3H2h/aAkWFpUVvs/f0DNbjQotURsArfZqFRxtpFCrCJckR
	TnqqMZfsdbu6FOvvPHty4aWpKF3s5VwezW1XLJKQxKD/a4Oz4cQO8Pry9+P4av1UZZ6TZqPxyTJ
	+iHHQIXZ9wpC2tZ7E/fiWnRAw46/COaEf7TalIQLP/Ft8OEOGQ8iGn9Qqkvf62jlPfE=
X-Received: by 2002:a05:701b:418f:10b0:14a:8df8:56c5 with SMTP id a92af1059eb24-1ac5dd5a055mr21441051c88.26.1793735020817;
        Tue, 03 Nov 2026 11:43:40 -0800 (PST)
Received: from localhost ([2a00:79e0:2e7c:8:ab71:b3df:693a:fbf2])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-1b245c2c2ddsm985448c88.10.2026.11.03.11.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 11:43:40 -0800 (PST)
Date: Tue, 3 Nov 2026 11:43:38 -0800
From: Brian Norris <briannorris@chromium.org>
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Keep clock-gating hold on failed W-LUN
 runtime resume
Message-ID: <auo5ar8427cuH_nX@google.com>
References: <20261029040002.2100002-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029040002.2100002-1-stanleyjhu@google.com>

Hi Stanley,

I'm not extremely familiar with the UFS or block layers here, so I'm
just coming from a general driver + runtime PM perspective. That said, I
have some thoughts:

On Thu, Oct 29, 2026 at 03:08:30PM +0800, Stanley Jhu wrote:
> 1. __ufshcd_wl_suspend() takes one ufshcd_hold() reference and sets
>    hba->clk_gating.is_suspended while the UFS device W-LUN enters
>    RPM_SUSPENDED.
> 2. Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
>    suspend callback failures"), a failed runtime resume (for example
>    START STOP UNIT completing with an error) leaves the W-LUN in
>    RPM_SUSPENDED with power.runtime_error == 0, while
>    __ufshcd_wl_resume() already clears hba->clk_gating.is_suspended and
>    calls ufshcd_release().
> 3. The next W-LUN runtime resume runs __ufshcd_wl_resume() again without
>    an intervening suspend and calls ufshcd_release() a second time,
>    dropping a reference it does not own and underflowing
>    hba->clk_gating.active_reqs on UFSHCD_CAP_CLK_GATING hosts.

I _think_ this reasoning and patch all looks good, with one possible
exception: ufshcd has explicit recovery in ufshcd_recover_pm_error(),
which relies on checking power.runtime_error, and then explicitly
overrides the status to active to clear the error.

It seems to me like commit eef1d74bf88f might have subverted some of
that logic too, because resume failures will no longer latch a
runtime_error value, so that recovery function may not be doing
much/anything. Is that a problem too?

> Keep hba->clk_gating.is_suspended and the suspend hold across a failed
> W-LUN runtime resume, so the hold stays paired with the W-LUN
> RPM_SUSPENDED state and the next successful resume releases it.
> 
> Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend callback failures")
> Cc: stable@vger.kernel.org # v7.3+
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
>  drivers/ufs/core/ufshcd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c6502..9be370cea52a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10626,8 +10626,14 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  out:
>  	if (ret)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
> -	hba->clk_gating.is_suspended = false;
> -	ufshcd_release(hba);
> +	/*
> +	 * A failed runtime resume leaves the W-LUN RPM_SUSPENDED, so keep
> +	 * is_suspended and the suspend hold for the next resume.
> +	 */
> +	if (!ret || pm_op != UFS_RUNTIME_PM) {
> +		hba->clk_gating.is_suspended = false;
> +		ufshcd_release(hba);
> +	}

This looks right to me, as a non-expert in this code, and it may even
have been wrong before commit eef1d74bf88f.

Reviewed-by: Brian Norris <briannorris@chromium.org>

>  	hba->pm_op_in_progress = false;
>  	return ret;
>  }
> -- 
> 2.56.0.313.g2479322e68-goog
> 
