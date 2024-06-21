Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC356179949;
	Fri, 21 Jun 2024 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718998139; cv=none; b=cmURt5n+xLOyVWTHHzzXN1BnTtIyj33lTvj6v3NqfonAaOg2PxJmssWM90GD6HM1xif7j3EHsS5ubxPfnT4nm6SlVbuJ2bijqZP6ByiNqdHnRqDtxmpkFXmwx8HhtatePkkjBouXOnhSZ/cg33eyu1HP6/4m8gzDVFdiBpedSf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718998139; c=relaxed/simple;
	bh=JpXS7RbQCKHZWQaiDn90aM1GMUg1r6Jz0pUAg0d0Ih4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W/vR0W/QjVYXC1t9XziZMWh/BXWS0LbbJfr4bYUZgphR1DUE0zq0LeMq3j3gJP7qzCoBo6CHSZqgS0tq20c8XyRHqW4Di4x8aXlRTgHnfXviBF8gPLvLCrAc8suq4GAOurvlohklheLJSW9vFKM21/nFHt8uy4xvRTChNiMns4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cojswDK3; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cojswDK3"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-63c05aeba23so831527b3.3;
        Fri, 21 Jun 2024 12:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718998137; x=1719602937; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JpXS7RbQCKHZWQaiDn90aM1GMUg1r6Jz0pUAg0d0Ih4=;
        b=cojswDK33EQosl2vq1Bwj1wsZ1d9ZTlB+JSnDTA721JTkHoplmOHqyInn1ob5yvJzG
         XA8cyQK2vPXDcF/i5j8HjpZF8ZBkrs9srwv/2lkE3k8Cwmuo451j+hedH2xgk4+eB84g
         iLqvIB93qK8pbjpunwjP9HYCsU2fpKDkUvDtWXzMv3BNXVxEOUvr7TVbvVfoi4aESf7o
         6SsLa11yI3u60tivfVzvHakYUJPsWMISVSxafpF22WhQHx3p9ppyglDzAWLnclzVKiJ8
         GHOo+y6WOOwfMgqaqVj4tYzy1rhO3RM3+fzB95eefKxpFeetBCRLhS+/2IDPwwAu9TJV
         1faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718998137; x=1719602937;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JpXS7RbQCKHZWQaiDn90aM1GMUg1r6Jz0pUAg0d0Ih4=;
        b=QiEy+HUSHm60rNyIwl3ExIj/WVtfWzDI/yLCatlN7qdq0/l2L5IU+hPopSUsgV/mNO
         Y1O/vGcyk09zwJ4BA/AZFICPVzEL0nHCKjfrrUFxxCIK+JQ0Fb+NBM87LetLMNLtKdNa
         p+XGh1fMxxbzmE0CSAgmfrAqg20MqnJbo+wawqUVClBUunlIWoXJ8JD5C1Nw/mHIMJQe
         NxjPCryDgAIJcX9SQCi/jfLmPheuSdbWSUZ0N+gbdd/+aMvcPwfMi8g7SBRmmUX9VQMB
         6zIZrLN6YQZFxW152tY/XoG2aLYQBlHKqaeCkmmRdeonupgVMeIOSAFK3LdFXAZzlWHW
         R2VA==
X-Forwarded-Encrypted: i=1; AJvYcCUv18LESsEMyapyBQZTZ/z3TzUm4y7StjL33MsgwL6cFwW6tDp7vCuhNgEE+zi5rvg9j4X21mBpjVROcb1CQYjcs7/NIVeRX/NvzLMmFHmeKjWs1IGnhAAZX3JkQH3d13VXYJJpLHlx8A==
X-Gm-Message-State: AOJu0Yyx2oQa0UTdQHPHFHoq0woB3rLX5xCBHD4wpOFz5UjOb9qxwHd5
	v7Kzqw+XsOXdnfaAPSe0jv8AE6QIlBI0n7CtrknbHX03gUhbZ93BhW1FXmerHnxgyR1tKlr3+8N
	/QqX5mSL66vx9uUEVR219GD2ePmo=
X-Google-Smtp-Source: AGHT+IHajUcgVIB+I3L45ShRu8IWGCxKEHAZRLW6A6ul5XxG5WRVkbzWPXIACeaBoh5k3K3vBIk8A/EOiFR0ffv76og=
X-Received: by 2002:a25:d654:0:b0:dff:164d:6f2 with SMTP id
 3f1490d57ef6-e02be13dd38mr8564287276.2.1718998136865; Fri, 21 Jun 2024
 12:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240621082545.449170-1-qq810974084@gmail.com>
In-Reply-To: <20240621082545.449170-1-qq810974084@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 21 Jun 2024 12:28:45 -0700
Message-ID: <CABPRKS_-td7-ag2O+A4o==trHVb0w2=YhQh=e7rBpsXttk-kag@mail.gmail.com>
Subject: Re: [PATCH V4] scsi: lpfc: Fix a possible null pointer dereference
To: Huai-Yuan Liu <qq810974084@gmail.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Hi Huai-Yuan,

Looks good, thanks.

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
