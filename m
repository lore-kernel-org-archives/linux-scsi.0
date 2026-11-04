Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793791689;
	b=HUO6g+mpl9XZlBQkwDw33biP3LOn9k6sEQSOCwVrWfUtKthbGNFlQtwgYIpDybf6DQ1h
	 GSDzMYsKfIbUIK2nYEkV7eXs3qTiuyY1WBgYdCRNYiOuRx4glf8vXgd5cLfIpmq+rhZWo
	 zrL207e3t3R2prQ505eCRsVAoKiO8wfwCoG4WZxSeFyAG7FyhVhuUlqCeBByXtpBoCqhe
	 utUopwyQhd8iYrLpNA5cl1XqMwABPJo8Q1wwkX+hdlE04HwQucLV+U5TH1sb414T2BYmC
	 fPSLnXKv8pxdTR62o1enUi9s0yFIiIo1WhSiSQIboZ6D6O0DdtS8sPWicSrGR52PHbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793791689;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=SF7pZMo5UMRqgADcWk2DKfyPMybDDB6N5ged2rxXhPs=;
	b=NJVAUKtU/HglZgCQ2+gICvtnDgFUuKflQEhjabbp5rExUMNTEisbQ01c+3ryhZCUJyES
	 IlsDBCnNihJbRvwIn2CVxjh84ndJtAI8KkmNnPAmQUbOzmU7f7IZeBiDekbwv0yDNtbSG
	 7SqXLCluDCBw6F3VPS75HGhCZzUbaMKo11JkEDkW0pMr6txXxVi7rRx9xLr4dDWKy2g8Q
	 e3R4NHP8jcMyjpmMzTg9WYaWOqRQJ/0hiVGacPw/rhRYy8NN4xZCAxpdrZHcUV2z5ZnlV
	 D6k0kBREVgquofdIPguW6P2T3WODOkenJSc4VL38kHkdtFJH3KZfHsSXzN26fWW18Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lhQ4jzXL;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EDB606A329
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 11:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6EDB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lhQ4jzXL
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89f84753b43so645395b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 03:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793791688; x=1794396488; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SF7pZMo5UMRqgADcWk2DKfyPMybDDB6N5ged2rxXhPs=;
        b=lhQ4jzXLF2fzjGuCJrAbkiK1nLdnyfY52DFnzVeC/2DsqTN28ZHrP5r4hi4qyQMS0d
         yv1Do4Ba6BR3zB0Vw5csch1E6ohsqxcMWgX/vFN4KbceavWSxJEvRvHs2qD7jxojvauX
         0xr9w/mAastp1XtPgrKhcJ/HU8q/P9mEWicah0qAnR190jRbYK9bLM4g4EPuuSMGYYKM
         SIovzdsG9Axzki2fv8SWX8uowK3De+3LdmfOPHoOZhuzGCBEIM5FgJVbSG1dhGDFr45r
         ho2mNK0I2mMFevwFST1fj1pggWYDuY4W1eXBOqt7lkicYCFdR8CAFwpkVShoZiH8S6we
         lvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793791688; x=1794396488;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SF7pZMo5UMRqgADcWk2DKfyPMybDDB6N5ged2rxXhPs=;
        b=EXOppPHFPCmbzsEy15SpRhJt9C3W/mJgYnv5sTPhD38dO+b0vURG4vcBjvwdfiLeve
         oQ3CFrQXQ+gECwLaJjpSjCRa7bk8lsRtj3PlEaxAkzObH6kkjn09vg9ZeD28H5qwc7BG
         oAlNot4NufX7E9vPGg0dF9sSxyYV23Mo3u7DazXgKHgBdASiFnHOrc7/J5ci79LE5fQg
         /KaBb7Cm3T+69aWlBLmjd+klQ5GPfZD/9gKrPP3mbLTN4fDgWCo8RFbdzfnHS03Ezj9S
         tOFr8TZxtR/Gp8Y3X1wu0LNSU3meds4E9PZ9ut7HkIrhmdPXhUBssNaXsyIcsYQ0CXAA
         tkog==
X-Forwarded-Encrypted: i=1; AKwUvBwJRQl95XyaJOXcWF/IwfEtFiAoHyQggTip/+Ha/Kf+fgjK0SwQBf43dhS8Qixo1GUrMLXunwyOdb1e@vger.kernel.org
X-Gm-Message-State: APuU4Z8IfK/OklZkjsgJNNWpLVpCrO73ZvR6QFUOmdAaHTlZW2FB2Ktu
	TyMSc3XOqOCf7yrv9LLnvZ9yZICaqoE/chM2Q7LvOB7o9Qhxz3GP5Z5k4XSmbeIni2adWKMyg78
	Rd2nvuIRMvHgMurdHddne9w==
X-Received: from pfbfb28.prod.google.com ([2002:a05:6a00:2d9c:b0:88e:f55:207e])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bd12:b0:873:e3b4:5d4 with SMTP id d2e1a72fcca58-8a9b9a4ecd9mr12223851b3a.2.1793791687832;
 Wed, 04 Nov 2026 03:28:07 -0800 (PST)
Date: Wed,  4 Nov 2026 19:28:06 +0800
In-Reply-To: <6e42537e-c7da-4b44-90bf-dc4cf30be6cf@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029040001.2100001-1-stanleyjhu@google.com> <6e42537e-c7da-4b44-90bf-dc4cf30be6cf@acm.org>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261104112806.1633283-1-stanleyjhu@google.com>
Subject: Re: [PATCH] block: Keep RPM_ACTIVE in blk_pre_runtime_resume() when
 already active
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-block@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 03, 2026 at 12:54:35PM -0800, Bart Van Assche wrote:
> Stanley, the analysis looks right to me. Could you make the invariant
> explicit? Only move SUSPENDED -> RESUMING in blk_pre_runtime_resume(),
> and only call blk_clear_pm_only() in blk_post_runtime_resume() if
> old_status == RPM_RESUMING. Please also describe in the commit message
> how this was tested. With those changes:
>
> Reviewed-by: Bart Van Assche bvanassche@acm.org

I have sent v2 with the explicit RPM_SUSPENDED -> RPM_RESUMING invariant
in both functions, the testing description in the commit message, and
your Reviewed-by tag.

> Separately: since commit eef1d74bf88f, ufshcd_recover_pm_error() no
> longer sees power.runtime_error after a resume failure. Its handling of
> that case is probably dead code now.

After commit eef1d74bf88f, a failed W-LUN runtime resume leaves
ufs_device_wlun in RPM_SUSPENDED with power.runtime_error == 0, so
ufshcd_recover_pm_error() skips waking consumer device queues after a
host reset. I am preparing a separate UFS series for that path.
