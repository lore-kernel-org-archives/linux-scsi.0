Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A73B95F0
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2026 09:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770198855; cv=pass; b=h7itFdpJKBYAYOxkZeo/Tomgxf9NgDapgbA5UWvcSS0nAiKmR7PtIt++Mkbqz9wGzeKZs0sP1jjsVDUzOqxxVCp59Pe8q2V3d86U88gQWGUTHsKVXQQzX4QusPDH3AVkDad7ezNov4l/QFulSnPj7vrJogg8FYhJObbdpi/smwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770198855; c=relaxed/simple;
	bh=Ti6r6MfFNoO4CLbHAhWyQsPag4/tmwbk1hWSxepVtvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e5l/8FoIPAo1jM0oTzgLOn0Vxb86iyi5xZSPphC6SrF4AcpTcQWNU1YMNN/zpvLden1RVZW8xDxOMQFsij6TIgg+I9BQDmGakDodewa/vVaOZMu5dovUWNYxV1VfBN6U+2WVdoybBalH19ZT4/doQBIUajbz+jsIMcWhmPr83HU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I2sDAMli; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I2sDAMli"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59b9fee282dso6350721e87.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Feb 2026 01:54:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770198853; cv=none;
        d=google.com; s=arc-20240605;
        b=FmIQ/EySjV26nzHlVKSgxte95/6sKpHYRXTMmTYcf62viOGlZBjLAYD2ULBsfEOIfS
         db7LbZa71QRz05HIT0Nne/4RgZ7lf95dO5IKRvxKUjBAhsdzywVo/38LXscpS6/8AF8p
         mmGtDj2l4v2CFAODu413cmbQDh9+zjh/WLXwQbrjstcAFB3VKxi1x7fUBSatZuvUIeqz
         +71DZYuadtFvEZg/tHcx1wa/zhteU5Ss+Fidi1WhEvmfRhs76AiZewnZnTpzlRI6KqcP
         I8lvPk5+DINdwPiEuFuvCO5sYdMjLiBcTplyAiQL4S+0/0SKUFNogCfkpHPL+DgHDTT2
         plbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2wx9k/NQf8yRGoX5x5aJ6n1Nwc6ICZwQd9rxjM0KFJk=;
        fh=qgCcwddsOMCPu3Z0LnAo+M9cXAZL5PCXuigbU3P17ic=;
        b=kqLE72b4daQ81xaKCCx6khO/CY89ttJETU06AlwNuS1Nn5rMI/nsg5jTH3ofhKOVlU
         w3K0kNhGBnhEDsnvATFmqMnXlB7GUR0ljk1HILHgXG+bk4s0x++1LawTgBLPNRKC1lyD
         yFjWkMg9+5xB08Qgr7hCOzH8VvxHSK9uNvfR1deUa4vXPYbRPSpIQLQ9/1cUTMF5Pa2i
         9UWyKfN52EBOYDSPVxQCck7q9yiBw/zUUvORk0Vjiv1niQJhedGbJhrbfU5XE6dqCQJy
         WJTtmZcDb5FL6Wl5cn58yNx37jJBBBirv0wmodR7wiwhD9LUE/uuQ3ZqJeuEvYMRrcYu
         RJ2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770198853; x=1770803653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wx9k/NQf8yRGoX5x5aJ6n1Nwc6ICZwQd9rxjM0KFJk=;
        b=I2sDAMli/NBb7ohFbcgWhor8MQ6RebluRJEhfaSI8AKMdGpIlCkmrSNT6CIpagh6AV
         H5Vhx0dbS7fm25Elt1J0X+/T+ToPeAWXvWgO30saECVLX1vHJ3+1IsqbvqRZ2z7lZT7E
         J9xQYWVglVMUNxhR45h7gMoXe5VC7l0ZRb2Uqq497Q4nY7L2QNWK/xCSlRM1lqDU0xlg
         qTWVHQngMhmNXoFGO+WpHuVtLDCIJNzUExerGSaGRhVdCbk98X0xbKv0dBNGzXs0mGd1
         j+XyvHVQMujpKBRb4w/wY6hBz0N0F401QUaWzToNwhnn/oNhoPkU4pABPm7SQK/gc1To
         ZY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770198853; x=1770803653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2wx9k/NQf8yRGoX5x5aJ6n1Nwc6ICZwQd9rxjM0KFJk=;
        b=V+GAXEdsHlB/53fFeS5QJoy7yv6ZPRgPZ2SGXw/ZINWiG0V10/w2XKX5iYXP0DFNlE
         VRb3SqgpsKP3MA5wxPHtmnaszV5t9Ca1fLbSPI1VQez+TGJ0GP33zI0M0RhzQhCZipNt
         uJGfPlC6bDy7tUaojdJlecAtP67XxmjMWueKft/osjuvsGJsmoG/je43F0znfWu7d4Vt
         stuH/jhOcdq06gfdfosTi6e3dr1Sy4u1AeL72FugyYFFqaWYMOyxzMauqI7cvPJr/rmp
         e9LfxYCAyOdcrb+QBrANh7/J1I+Z/NesFfD/gNnfKlx6zSaPYU/0TXq8+Kc1pZBUBJNb
         tTyg==
X-Forwarded-Encrypted: i=1; AJvYcCXXkEUnRz01iVnkrzQV6N6Lh/Hc3WbmHlCxQXrO1vCMtDfvF+3y9S659eL5HeNeKgc9C2AvchXH3Ksu@vger.kernel.org
X-Gm-Message-State: AOJu0YxVl3VC0pWlt3R89lqvrcKtgvCI0IzqAAVy8FnHyGr5s0RL2xS6
	e79Xf6XZLCDKXkhznkT3/u+P9ZEhSOq4RpDDIpdhtf0gDmaYLD3g3BHOK6ermdxnv+Sq//u3Zdr
	FoDXlNaHpAw1poCn1mA2SsrQaezPuxlZDWvrRqQJdag==
X-Gm-Gg: AZuq6aKMRXGSs3xPmqCdVW9Pe3KRTUHFQyEYAjIuclWtQ6tvfizmMp+DotIgtzRj+P0
	29ohCjjbloBYhmEzE5EowBmx5y2KdrhXG/LY0P4HUvdqzhGYQuA+BL8F4e1WCOvfUSuKuh3UOd/
	genZCquGARERUfWapsS9E2/dTUfp/gu2V7ewsANM1w+JF79kRb8yyLCviXIeY/rFadvZn/wihOW
	7PD/2h1D6xgA9Cwx/4S70mHz5zQVD684TZawDnu3MoqwXOdirAqdT4gFaVgdqCYs7bgd76TiSy1
	3gl1ZFWTFUDWh1LdDAv8qBK1NFoa
X-Received: by 2002:a05:6512:2524:b0:59e:8e4:4772 with SMTP id
 2adb3069b0e04-59e38c63eebmr998473e87.51.1770198853613; Wed, 04 Feb 2026
 01:54:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113145711.242316-1-marco.crivellari@suse.com> <177000116198.3467927.13394907147902446660.b4-ty@oracle.com>
In-Reply-To: <177000116198.3467927.13394907147902446660.b4-ty@oracle.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Wed, 4 Feb 2026 10:54:02 +0100
X-Gm-Features: AZwV_QgLZDl3-kPs7CvR9sGVnm2BsCPGGSgHCNawdhVGgaB_q2-PeMv8j179OUM
Message-ID: <CAAofZF43pVAckCQM3RqhQeL2pVTzPc4ayC=KT0T0X0pTSH+mNg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add WQ_PERCPU to alloc_workqueue() users
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 4:53=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> [...]
> Applied to 6.20/scsi-queue, thanks!
>
> [1/3] scsi: qla4xxx: add WQ_PERCPU to alloc_workqueue users
>       https://git.kernel.org/mkp/scsi/c/267345b6d1dc
> [2/3] scsi: qla2xxx: add WQ_PERCPU to alloc_workqueue users
>       https://git.kernel.org/mkp/scsi/c/e4c7c844fae0
> [3/3] scsi: qla2xxx: target: add WQ_PERCPU to alloc_workqueue users
>       https://git.kernel.org/mkp/scsi/c/e6b42979ea61
>
> --
> Martin K. Petersen

Many thanks Martin!

--=20

Marco Crivellari

L3 Support Engineer
