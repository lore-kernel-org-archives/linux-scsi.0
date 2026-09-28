Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC01B4CB8A3
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603109; cv=none; b=pNBAQQWnAMrJ7yAMduSh0CL/PXvNOpP3k+Pdn1MJV4QU2Xs9FprBL4o5aLKSxZTLYg1aAltYNAywTow++xKcmtcHNueLL3vHOwR6q8UPpt2eFRxorKMxv6uy0fcxWPIuZyLVlF96KjjplGwJR2A6sRj0N/JZtpJqcTIy5bEiKZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603109; c=relaxed/simple;
	bh=qYUMU2yU5Ab5aNsjdWZjLUABg4FDEpiN/FkMxkjySQA=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=FUFltRJWmS3IGTS2xn0JqAunOo1yxgwq67EwduMPy+7AK15Sx1SwjPxgfAOi3Lbfl6EL/lT/El15b/QDFpgLyxB0Hw3al6lktVAlWsEV9d9pfkGsqEFBQ129XQAdb2uQ3goHOfCkHu+ufWEVGv1LotGK+9iJ+KEIDXIsAS7CrGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z6mzkiuN; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z6mzkiuN"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so3101871a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 06:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790603107; x=1791207907; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S1KYRH67PD9FrW4ZeFo9IsLLz3F03dvo59mUhKVkld4=;
        b=Z6mzkiuNCBjnmfWHkXVj+ox+mqnhCmPBbk5ip6RJvdf7/yqvrvbJgH7tUxCOTXENRv
         oiBc8aRDpu4NXT0jKXkPVECLfJbZ5chtJL9vhgKsrwnMGHRtgwKBFIDmEjnDSl3sHmIh
         jxamFdfd+aLj05Ytt2hwED1QnGt9VW+bRnsQL8bt1qo9UqWjzHjcLcXKCts2dBJq0VRk
         UJcFK94iOrRofctXGxB9rV795Hx8Jbpy8uIjfwdxg6zkWt9wqYOEvj+/D/oipKktppSq
         fXfHeSrevt2adkWUoF4NgnL1J87kNoOkm1AGWLuQr2upWWBQBRuyen5DSXG4sIdcvVMT
         qWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790603107; x=1791207907;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S1KYRH67PD9FrW4ZeFo9IsLLz3F03dvo59mUhKVkld4=;
        b=ssVdkGhwAuZ4bf5J9jSyVpGtHqK9UqJusJEWshQQ0hWcbkGN2jdXNg0O39K3wmAJbm
         gbZor9Hig2BARp997J/Gff8Mie8A+DwtTvPoKCw/aVS64Yom61yq0Y1YQAhNuESbFPcG
         TQSensYkOhQGqi02lEuqjerIvpGlKgPWW4bBCVR8QFwwHqRtfqqgM1BEr22ej448Q3T4
         kw9Q92wsBa+8tHDq7ZbQR1MK2syvGQjlvOOIFdgNICkokcBhkkGEmius3AZ0Y1rhC6bb
         uob5brFrJW3mVxLphhWVzZvsEpsc+e6aX4P1R0GDfoDcxg4s/78f1Be6zHt455Np5STQ
         0p1w==
X-Forwarded-Encrypted: i=1; AKwUvByV71U9K0pj8ZYrWKF4JfxBhwEwugwhe+bcJaE49pwnTUUa7l6bQVmY1BfB2ps5nHoMuqzveiwiUbso@vger.kernel.org
X-Gm-Message-State: AFq9FYISkrSHsd8dg54SO21LwRnRevtjoWZODQDh1mJT0fHRbOABx05h
	hHu6uyZYXDM52b+eZhZ6NcXIZLnvJBpuV3hae5r2BI23DlgRtJwDAuITWgyglL43KZ+ub8LCQrf
	ZZyq3/aBc7baozRdNPvG3lA==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pgww21.prod.google.com ([2002:a05:6a02:2c95:b0:cc7:b5cc:f08c])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1f90:b0:39e:6c69:f47b with SMTP id 98e67ed59e1d1-3a098d4085dmr11127590a91.58.1790603106971;
 Mon, 28 Sep 2026 06:45:06 -0700 (PDT)
In-Reply-To: <yq14ifovdyw.fsf@mail.kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org> <yq14ifovdyw.fsf@mail.kernel.org>
Message-ID: <18d98009e8d5679e.3137322e31362e3131332e313435.256270.0000sendgmr@google.com>
Date: Mon, 28 Sep 2026 13:45:07 +0000
Subject: Re: [PATCH v6 00/40] Use defined 16-bits ASC/ASCQ combinations
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, Bean Huo <beanhuo@micron.com>, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Martin,

The merge resolution in 670f07403f7c [1] converted the UFS RPMB entry
added by a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on UNIT ATTENTION
on the RPMB WLUN") to:

	.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED,

The original entry used .ascq = SCMD_FAILURE_ASCQ_ANY. With the
combined code the ASCQ is now 00h, so scsi_check_passthrough() retries
29h/00h only and no longer the other 29h ASCQs, e.g. 29h/01h POWER ON
OCCURRED. Following the convention used in sd.c, the equivalent would
be:

	.sense_code = POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED |
		      SCMD_FAILURE_ASCQ_ANY,

Could you fold that into the merge, or would you prefer a separate
patch?

[1] https://git.kernel.org/mkp/scsi/c/670f07403f7c

Thanks,
Stanley
