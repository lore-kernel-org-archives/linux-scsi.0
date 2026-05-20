Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68121367B89
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 06:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779257396; cv=none; b=sGKYi+TVHfxpeambuDqiSYAjciDH7vihotWabDbvmW/ux2uXC298iWXoFqCT3MJA2STeZXnkP7LzaCgOG3KYm6U/mFtXggdMRt/IHZ62NOfM2dcwFtCcfre2WVV4zdeBsXNdWM9a9NFuVz5T50nBVtRqG9ML6pckEPDp/XEbD0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779257396; c=relaxed/simple;
	bh=u4glTfwvM4dGbYgQKUctExrwFgihW+Oc6Hx0oa9U1Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvACv+x2vnZg/oOYYo1vzIARinUIK1LtzZAmqGMyEygSnEDinieEtH0/GoXcVwfYArpxqgenK+4zUSVu7Yp5dZP5jRm88lPRFGAPtj9DuHI4apnBF8g7276Q3TGunld4IJ+Qbz4MY2l+WYv39FgCyhGuwJTaPPwWs2W+KbE8xrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=tl4rADEy; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="tl4rADEy"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c8173b2af32so3441225a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 23:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1779257392; x=1779862192; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WvINbRjPBtxpZCn+GO56O7dJIfiZjHEq3Bb0sZJ+Zrc=;
        b=tl4rADEy9wIfwp4zrC8ZTAKp/G2O7p4fBsNKVna5GvpYr2IddbUDd9z33cyc5j9202
         Le0wjxuTNzk4fKVqwaDweNzCmd+j8AFuAGKbd5NGCRaDjvMMx+Ds59i143FGCss/dZAZ
         JdIt+0yQGf9j5Z33tQuTUTuhNUd1nxvp+21zV6JeKTXzR/J+o7X2vpAmoPZOShiOi4Rl
         xkhA9ExFOMHuhSqrd7wTsTtxTukaT6CNqdmi5+nl4yePOiUnSivjn3kzYmG0z8w0ot0R
         SXJFUtRaw9wFYhKvxHCOyox0f0Y6NBxzFlOLGXwDvbaiSPZe0t5T6SQZsU321FXcNbmV
         AeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779257392; x=1779862192;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WvINbRjPBtxpZCn+GO56O7dJIfiZjHEq3Bb0sZJ+Zrc=;
        b=Tp2JTAcmKRtro0DKMg2unpmI9YV+wzFUvzRHrUUJbc6bjFNqSTGW91UaFhk0fjcF4R
         ERp8EfLu1TeoE4eKY81c9ih32dxxqTxKDSW6mDElBcYQRAKLz3proArfYp3/eoknTz04
         tZ7XP4Ln5p/CikO53kLwkd5zm7m9BgAoXhrrbreIL3CitH86kFcgralW1juieqQGBi45
         1AKMXaZ+U6KfTgAmq7VNpWsKbq8kpUuGFFnu73OmxqZrBPizg5mUFIVXhvhmBN1MHlBl
         8RaaflJVhQJJvPW2rp6ZYKUUN7a3XM9DBZl13I/ORxatfVqfxu+uJDU/cSFcJuNL27sM
         AxiQ==
X-Forwarded-Encrypted: i=1; AFNElJ8bsybM/pmk384zTDMtUxJfmSashNAn2TVSZw9QN9WXRl+YTH3/ogcSpAYuEmwe9yj0k8x+0z80MwwR@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4i3bpZTEaKYfUsM8VdR0kw1Kys6USFfcBBA3iZ2iqv8PHByAR
	nhxrziawJyAMQMiYqGMlc/kA7ClxhyVkU0SYsRo10fKAI9zZDQqp2F1fkIk2bs7fVOQ=
X-Gm-Gg: Acq92OGBmhH00l1t7UZvwWQ9tfRW6mjV8NEy7uROubbOxACbeHbme8v79eimO3IKu8P
	esk84pCyq0pD4xS1ZHpIAyHwl1ItP65mAzy3wLdrCF8BT2bB/lp3GLrEJWIBKB8dUylhg3CaEH5
	+CE8pZWNmjN8Sxb1S5s/3y+h4DpGrw0rNpaoz+tin6664Meu10/P8ZK0qbvBfC097v4RtaYwSZ2
	XnKLCXaP+CeLyFLOrS0Fk3fEORlb6CJndMaK3eh+e7vv+vOTVV/penbeXLQhPyDnAcFQBxGtTvR
	MeOq86QhHDtoUwoZce5eW4gQU0aydC59iwVeb6oarm75PoegV8r0RJaaalV7wUjnqXEyQKAQtLI
	BiXi/nhO0we5V/NBCLKvdC6aT2ucP7L/zPm27E6Yts1DNYyKWbILW1jxB+gUe3/robxssTJ8TFn
	r2ipaTnDLyp2OOEUBuA1smW+N+7xc40TDXbrxNvsSV6BL8mIv0oftZRw7hNQ6vEaIxX3SkYKZeE
	PZHvweOSf1EVpIf5wQdb2BP7mUZFGzp2Ns=
X-Received: by 2002:a05:6a20:158a:b0:39b:dc44:eceb with SMTP id adf61e73a8af0-3b22ed28431mr25802680637.42.1779257392565;
        Tue, 19 May 2026 23:09:52 -0700 (PDT)
Received: from essd ([103.158.43.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb1006fbsm17751895a12.21.2026.05.19.23.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 23:09:52 -0700 (PDT)
Date: Wed, 20 May 2026 11:39:45 +0530
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: Justin Tee <justintee8345@gmail.com>
Cc: justin.tee@broadcom.com, paul.ely@broadcom.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jsmart2021@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: fix potential memory leak in
 lpfc_read_object()
Message-ID: <uetljgpjg3dinarrtv2fkjieohsh7te6agy37a5z3wskfqnr53@ota7uhwzrdiq>
References: <20260519074230.110624-1-nihaal@cse.iitm.ac.in>
 <67ad1039-b6e7-4507-a9be-12600a5fe385@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67ad1039-b6e7-4507-a9be-12600a5fe385@gmail.com>

Hello Justin,

On Tue, May 19, 2026 at 12:52:36PM -0700, Justin Tee wrote:
> > The memory allocated for sge_array inside lpfc_sli4_config() which is
> > attached to mbox, is not freed in one of the error path in
> > lpfc_read_object(). Fix that by calling lpfc_sli4_mbox_cmd_free()
> > instead of directly freeing the mbox.
> 
> I don’t believe this is true because in lpfc_read_object(),
> lpfc_sli4_config() is called with LPFC_SLI4_MBX_EMBED.  So, sge_array is not
> kzalloc’ed.  The code as it is today seems already correct without this
> patch.

Thanks for your review. You are right. I had overlooked the conditional
and the early branch in lpfc_sli4_config(). There is no memory leak
here. Please ignore this patch.

Regards,
Nihaal
