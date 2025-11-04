Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF47346785
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762293049; cv=none; b=fTl137I2U+SoEki0vVaHux/Ownfdx7VCT1pIKDg2Clw8gfNZcnwNEQgLaKQB7D3/9vtoCdGjhpsX5yc3LaOHkXFZy+VZvcTfUHsnbUktAsFhakuiD8jdHwSRwYALZZpM9ni+w8A03ckDyv2uLYA2TmiGnHfIQB25LwGp5jTtmRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762293049; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W2O0v+tskzRQ69i6P7k6PvrDJo0WUN4yVw7p6+3mDlgs+gsOL8VCcyPu7JdflVVfy5fjln9uHEqGUNGGB+AkmBsW0AEc5Ds7+NlcE9RgaZuivKzpp1g1J0HinD0nZmAAoVESc86zoD0XPzUi8RU3tqKPcblM4uaTxJlup3kyUyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aqku7Np4; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aqku7Np4"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63f94733d6cso3649815d50.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Nov 2025 13:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762293046; x=1762897846; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=Aqku7Np4M3GiYMEVC6/y1m3DaYqoC9sjBswx/R9tyJyhGCCR4PJrwXe7ZNdEnQmsmJ
         RPyjyus2Sn+U0wza4DUmm0gbvclkOTXjTHOdrdJ93l2brwXzCiGqjFGsl80/0KKbaSBB
         K3UErB7SC/UcOeUphqdQtj4oTn74fD8gBlJvKNWSZx1vj5RjCel+1TgNIrqesb+6rjKL
         HbQ/fZHHoW/2dV3B7V3a42dN0wDxQMk5cDMr2ySyv23HUw0JGy1RRACZRGBgjU0OxnDn
         rG1WFHP+spZ/XmHICfuZwYh1z4cEmKOHUglYUQu3bNzRXe0J3gRb6gWg42GiMul246BK
         nB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762293046; x=1762897846;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=F8jmUS5f8HWxENPtEgtC8HlywhB7PPWJ2MTeIXLsRY6+j59qst2/8ZwrEnLUWfpG92
         crgr55MDGn5K1GH0I25mtDstQ2JnjqHjMJJBSKeInWScbBKtoWoE0AZP+H+Aqzi39qM5
         bjN3lMWLOi7jqrxeW4i7JeNU4Qw5kunRFMY+cMCt5aEt3N3JyoFNNa0IuIFuVapvArEY
         TIgxkuZknX6MjOyNHsp+nDy1TEvLjulQRQv3JwfAZT5lK9aGHeyxd0QJ2ZqR25bsz1j8
         zc8a9A3XvAb6TF7dcXnH6wqjnpbV4MR6tTijpXyPywKPk1mW8qCfTC3CbXTdiViu4Z9/
         H5AA==
X-Forwarded-Encrypted: i=1; AJvYcCVwxYFStlXQ4cWkjO+Y3Muqr8/7/NQTr8GERHx8YHV+xIUsND9qDPXwpsk15fuYDFO+QARxrS8AMhmE@vger.kernel.org
X-Gm-Message-State: AOJu0YwkjXR540rWb3Z+by2QWhq0T/1/XPGqTBuA6DSWRGR02g+w900g
	LDnaKGVKkguV5m/vbt+Dhhj/NJKnJPLmsZwFuYgdms9ZR+hhn8WqysEm+WhfDlXk5M8BH4roGXu
	QB6jmRH+LD08ClqZY1v7wsWLzxA6e6nYPtT0AUQo=
X-Gm-Gg: ASbGncvMgtaPh9A6weQ61f3ryZbE+Ws2BbBdrj43qT7oG8H9Mif/VF27lYavnW+YOkZ
	+MxVta5WmDk3FgjbppYVWrifbvuAi8uNMCcGTh2I0zTl13zO/7RQL9XPiXjSpHm2kn3DICxzJcJ
	q9CjLDlp7/mBMlz6efi7ZSCEU2XGgRIlSfHte8UqfuQeY3qFS9LE4NZ8GLlU2vO7sZMy54EZqc1
	6ddyx+MDzj/wD65RAIG1gPkTTgPV9seB1OL2gWTT6LXKl4K8eIzBEXWbo123hpVc4lSkAiv
X-Google-Smtp-Source: AGHT+IGwrCR42QpeR2puNr1W5Tg6xpSaXX9MpLLT1hLA5gGCvV8cPaCSd6GzVdih3PKpCjPk3q4qGVBL+HJPezITVLw=
X-Received: by 2002:a05:690c:450c:b0:786:5712:46c7 with SMTP id
 00721157ae682-786a41be642mr17351537b3.41.1762293046371; Tue, 04 Nov 2025
 13:50:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104110808.123424-1-marco.crivellari@suse.com>
In-Reply-To: <20251104110808.123424-1-marco.crivellari@suse.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 4 Nov 2025 13:50:12 -0800
X-Gm-Features: AWmQ_bm4LGXLMupMb2JCG7NJtJn3WxRnqaeQ-uUMsKRu2aQf8-o0ROQVFl7R8uU
Message-ID: <CABPRKS9Sy6MQrzZoKFaw9P08pgyYnc_=obX-4C_hrARXoe7j-w@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: WQ_PERCPU added to alloc_workqueue users
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Justin Tee <justin.tee@broadcom.com>, 
	Paul Ely <paul.ely@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
