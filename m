Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FFA22A817
	for <linux-scsi@vger.kernel.org>; Sat,  9 May 2026 13:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778333445; cv=pass; b=moSAyVwjDo9iUTbvtL2mB3LBRqiVEUoavp/V0QdomHQJ/ymH3Fo729X3El+4+BRSX3yuvsGaMAZHaTXvCvKloc2inod74U0k7nWLH+darNWSxi1YpvY9XQ+mhLDYQIaDM0IfZH5XjfMPEvQAeRYUdQDJZJ+Nun6JQnzcdG/fhn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778333445; c=relaxed/simple;
	bh=QcOIaSk5dDmm5s+y39FGgiZ4u+KsJqus26X2tMXJtCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5Sz1NlHmTDClIPIxjpukrN3a8UpkU6at9i2hRLbvQu1aFRDoA/CtHwj1BL8fIpciP/OrCuUOwlKS7hw7wJRD7O/koJ0xvxPqBVaIdSGdWRJqa2JRSXFinJGAfPkE92SMkd9J89OItbEnajVmw0a+ZwjFztgSNlvZJmH5MkOoI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aM2H4Ot4; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aM2H4Ot4"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38be5e86918so36641771fa.3
        for <linux-scsi@vger.kernel.org>; Sat, 09 May 2026 06:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778333442; cv=none;
        d=google.com; s=arc-20240605;
        b=ixSPTcHvqc4gxZpojFfV0NbOX+6b6v4CvUOCZ3xWn+D06iM5YROfytJMSS2kGbjgwU
         0NBuz+F6hogZvQeOko1N0pLm5XyYR9kFMZX9nptSka7Kk4mHWY6bbuPhp9t0ecJ5lmHz
         inoPRGqzszvV/EB8VcvAUuRb8niWFH0r5RxRIFHf0SMHTxopHxMIv9o2FMRzUnli/rPK
         RqjbH2kjhYf1H/d8/EpiP0VSpja3sDBG3JwGx9SS+j4GLWBD/kVeueweY2lCYnb/+SSo
         ynrbFIoDALJBX6Lsum9go4an5bIiMLBNAjbXaLIoIqUel/+XdX9Dl7kLSDtg0WoNmApR
         gUaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QcOIaSk5dDmm5s+y39FGgiZ4u+KsJqus26X2tMXJtCU=;
        fh=IjqEioE8Bx+ytouE98ayWP5aio23s38mZERIsVANpCM=;
        b=f0eWiKvG5b07CKb5EJl7k+iTTO8pdkrQ+l7RYzDEhAYnhZfVul/OPQwUur7eemUwkU
         72t9VOzLanm/66NcSnF7fLyey5WatPmsjxNXcZRjq44ENVd2y5PyhT+9+mLOahN56Poi
         dWZ5CEgS3bKC+02ZE2Bua6wJmbwDjgH1VxQb8X+r9A8EweEJhF7SYIuggmCumDLgtqS5
         YXpIO0pODml9XnljtRS+u4kEwSBEbmODR6GQTnhdpyvkXEspjMmAG9CWKJbM0Wwp3Mpo
         jCqaMPgvBkPYNmI95xU6lSpIguSJYqUe9KBpIG+LK/Mul63HCuSwHqmlgiBIsGZZhlmP
         6+kQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778333442; x=1778938242; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcOIaSk5dDmm5s+y39FGgiZ4u+KsJqus26X2tMXJtCU=;
        b=aM2H4Ot4RepMKYGxtpW9rPk7MpHp6OcNWyK7uoe31CuzcJm/HWIzekeZo7Y/S3yTFD
         IIR6XSnbACLUWfOvQNIFxIYZp+Kxd2rr8ukDhCr3L4p8fmGKRP5D2eyhUOO8uCNKeyiv
         qPjOXb72fAM8JY85g6+3/coI3LiYkZw32WlUsgay4LQ+zJikeN3OOsYcRnw4p/sWB73R
         KrUULlWMTwgrW5m4WQwvS+3IplNEbnewhGLFLVGOKprNUc2seZ1HeRoCNYN3G7tg61JH
         K7a46JzUuWSttWVtiqwJgLE38OsLzrzQZoxJ7vF2NKFgpDLlEX+ZSrv4BF6Cg/uvYeRc
         qqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778333442; x=1778938242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QcOIaSk5dDmm5s+y39FGgiZ4u+KsJqus26X2tMXJtCU=;
        b=e5B8mOV9j2+ctziHHqahmXoIkwDrjJm62N/iJRg0e5MFS7Hx2bKs60LAeW5lX2PrW0
         vc8HKcgLzwOGEU5WxhaLyR26bmHe7oyPIVAOeo6lMBvzSszG7CwEfIbsIyJAkv0Z/Iwz
         UurXUpAEdtXsaErCLqQsvytvW/PC0eGPVVx4LqX5IzUAGSyM92bY3SIZAaW22yOkabAC
         FZdiK2WJmyO7HDiRS/G138qkDz6fRFMRkkvf6xIV7BmQ2hAayIQz+rFj1R30n37073qU
         JJg/xjhvvReallHKcLYD21ezAw1Z2Ro5taeTvL7jKwWzSC+OMkVEBH75RFd6ct1ykpaz
         WqYw==
X-Forwarded-Encrypted: i=1; AFNElJ8n+1OXk++VYYVSN8deoKfvSMSnoAEUtjDLqk5rvE/YaC10152nPI9sScOwF+hXQz293Fco3ZwpRcWp@vger.kernel.org
X-Gm-Message-State: AOJu0YxULAe32yzn8RnuROFVud/Wum5yqyAcd3jlenKieSn4nvsYPlyv
	CjgS4thznfQ5pJWSK1SuuFMeDWXP4EuUVi5FeSwx9iPAdSkOAC1s0+ajmcLPhffokSZK2Mst/RH
	LORPBbZtP88dR9HoxaeaKnOA5UwLwenXkARSn0MXSHQ==
X-Gm-Gg: Acq92OFn8hK6jHiZSetnLiWsauWh+Q6epNfd44oNN/vvJsCqtxvMhmt1fZa3tAtz+mM
	XhRuHMc3lT5FJV00x3FrIpgCauMgwUoRn9WXw4HqE5pYlooG9607tkgV4BZErMkJO4ESXqhxvIf
	6VFlNERFGB55LMSWj+Ca6Z/+5DBGJbjQx6yOBV/L0A11FBzJeDSzSOitR9drwUCnH9V0i687uGu
	UM6yd4Xw4AeyuSObauUmDfY3Q99JWeVe2FgoHTuLVrtDw+FmLU9iZj3gvjJkjScGHlDAkkCqn5h
	6h4nVSN9n3v/L5qa63uZOoychWDXcSmSp8qjvN+f
X-Received: by 2002:a05:6512:6c9:b0:5a8:64c4:38c4 with SMTP id
 2adb3069b0e04-5a887add250mr6811058e87.8.1778333442267; Sat, 09 May 2026
 06:30:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507143410.337267-1-marco.crivellari@suse.com> <b0c7c212-c9d9-48bf-9531-9b99b090d4f0@acm.org>
In-Reply-To: <b0c7c212-c9d9-48bf-9531-9b99b090d4f0@acm.org>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Sat, 9 May 2026 15:30:31 +0200
X-Gm-Features: AVHnY4KW5Nm0A2oRi4tWPEOG1h90ZKKyskJSTqFbKprQgNY_v1eF__0nY1h4rCQ
Message-ID: <CAAofZF4ZcoQF=OTyAu0Z45AgcT+jqG=Hh8m1Xa2kk0n5dHv7Pw@mail.gmail.com>
Subject: Re: [RFC PATCH] scsi: scsi_transport_srp: Move long delayed work on system_dfl_long_wq
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 8, 2026 at 6:11=E2=80=AFPM Bart Van Assche <bvanassche@acm.org>=
 wrote:
> [...]
> This looks like unnecessary churn to me. The motivation for the
> introduction of system_dfl_long_wq seems very weak to me. Wouldn't we
> all be better off if commit c116737e972e would be reverted and if the
> behavior of system_long_wq would be modified from per-CPU into unbound?

Hello Bart,

There are not many users of `queue_delayed_work(system_long_wq,...)`, anyho=
w
there are API guarantees, so we cannot just change the workqueue used there=
,
in my opinion.

Also, consider that system_long_wq is used by more than just
queue_delayed_work().
Approximately, 60 queue_work() users specify system_long_wq, some of them
may really need to be per-cpu.

Thanks.

--=20

Marco Crivellari

SUSE Labs
