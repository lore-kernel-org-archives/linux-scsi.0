Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B702DA76C
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 06:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769669533; cv=pass; b=i8sWENP+oAKsznR7vXFaOQ0xVlTy0TTsroIyp6Ito1kJ0cnMnvV64EyaNbAxXOjs2ZhhjvJ73NPjQHElmesiYw78XexpNtPSMzCF11hrdmHUTsCiR4RncPlKjAaV3tTkHwap8iAS3upF5mGq3+B4WgRMrFbJlIp9YeAgaSPVzjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769669533; c=relaxed/simple;
	bh=FjGtDgWO1SlY41VVnAbB43mPjgZbe16VgruOiURSZAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+FQPeBE0nOaiFEym9alPej9pmtEoClbtIIoYKWhbnxZNsqyebqh88XXf7Cg8phTzxZjXgfocm/qjRuvGKQeJFX8cI0EmihFNsuRSB/VEqBtVyvaKQbR45LP8mkynWym6KWI4f+wJLE6qBdtGnNjyk7k779xTcseAXQVhIMxZvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/eaifpH; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/eaifpH"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59ddb20b720so2663e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 22:52:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769669530; cv=none;
        d=google.com; s=arc-20240605;
        b=Iv4vYYQ+slrcPdh9xqPblR5CNQVz33AjXtYiCbPrDqLfk2YSyDy6gVxZm3VXiKj0db
         InySQNjBRn9NGpnRq94NBH1TEqetGOsBGLMzWnJ+XLpgPhDw3N7J9DrvbKG4Sk5NaLFO
         83DwebomewPeULmlEX1fpo1Yvlo0Dn4t3L4xJj/0hp3j4V8AdeNT6P3VS5ar2RZR7Z4p
         /HrBgW7l1PsHB+P+Qc4sG5YkmVVm6z+if7nZjLv7DgaJuEBEnKIAnf7++UJfGGoEdlWE
         4hlT37TtYj3DhRIwkuIntaHF4Fpq40495NPAzDYFwnhtbMfArZluRD8H0g7l3Mhc5lMI
         4SZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FjGtDgWO1SlY41VVnAbB43mPjgZbe16VgruOiURSZAg=;
        fh=9RmrV7R40+YEZ1nahtdeynGIowiiPDCsmz0SBEUjGX0=;
        b=QnxzYHhPLZ77NtdEpUjscQ24uCzjQEcHUEtDtJ6SgzptWrb3PqOeLDvNpRXrQ1dTB7
         qAWD2M2OzlXL0G7uR6kSCR1syuEZztCJWAzFjwLixe31FWuzZAsAYy3MSmYLrx0+lor8
         XS+JCZjgtIlMXqDEIHxPH+QlmCWhherlN8oqfRvw17vrejr7X0X3iiEhGIL3MdzNpoFL
         KSkstFxuOKAuL+PiPkuKnPuHrFnAuUaO/bdHm0s+aPICYwGIEOc6SSwifRPgBSDvLVAD
         2i2cX/STsR2KtRDzUQnYROOE/FmURx8L6C/KDe1lMaXHC0E6i76QW7bgD3wLTp8xyKRd
         G9xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769669530; x=1770274330; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FjGtDgWO1SlY41VVnAbB43mPjgZbe16VgruOiURSZAg=;
        b=n/eaifpH1hrsPylm3Tska4BggpFBzzwsiGhKIAgQ8YcuYShz2EnXJUNjJrFkaFmvif
         PjyGqyCd589OnwZLyu8DXabizuQGB1dwiBQz0riwFhOSrXH8WK32e8jVVrqRT4lR09vG
         N58qqfh2oPZ/VdaNUFpoQnkgZJs2qRAj1FhXr66hWgAihjH2UXzPKVwKrZHznEnKoh0T
         Bwi2zPOWR4ZPm6FGzXP3RDTFghemNkkfQ8lNOKt1LHYhKmXXbFRImang6DsoVh7tnl6R
         jfuMA78RgqudQhVKATvWZC9CTD7EOBuVYO/tQhYjBYL3BaKdGajG3F+28Nn2XMYcXOrt
         5xUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769669530; x=1770274330;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjGtDgWO1SlY41VVnAbB43mPjgZbe16VgruOiURSZAg=;
        b=MMQXYI7SM48vHLtiONNsroFCIn2Crdz6z69a+y3Vx1Cno+3TcVKQ6V8Q9Edqw2ILUn
         QuDBdo9T+DMdblGP7F3iXvz1+vk++PfiFnok7nnPyJIkkSfCAu+YhJIjI48MjBBHrDLw
         +yHqtmmmOuBS9FVucMYYtWCldnDryFXNWAu9BI/nbUJGUTG7SwYJilMdtF9u5cO4bLJl
         bJ5QhWCYc+a9xeZlgQcomI0tG+NyYmjSxB/3WinVnmqPQ9FrpTQ95Z7dMeeOS0e7Z3Cm
         QV0Dt0XwLnaNFRR/w2vrbF5doTzSKnP9QLta9jN42YbPXKIbgvTLU9dIQ86jww2jE1FN
         nmDg==
X-Forwarded-Encrypted: i=1; AJvYcCX6tKgt+fsACTo9ad62Qu4klCv21BRXMk9f2619jflPymy8ZAJusflJhwzOpho8zyLwFTgT/m8kLSGA@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8WNBBL4vZntzrA9icH3jVkrAOELgsmBPS+H/iDcTvzNbb94iN
	R9RVsqFJzDT3SA7TUzaUSGDtSjz3k5FgHzNSQ74CJEVVpQF/kY07lyxtJ7D2ir26dtqG2TTLz4v
	3NvX3NN6Zo5VI9EI5/uVNlOc5tKi5Ww7H2YL0btaa
X-Gm-Gg: AZuq6aIm4UYKccfXAj1+ClU8s5Sk+tQ1ax/m+J1B64T7Hw7ivLEtH19XcrghFBDiYPA
	rSPd/Qo0cnbIa9SGP0BzdgQeXF1hI+2QrLkJuYFC8jQgeyd9AHMuukD73E98HOqp0LKI0W6yp7g
	8Squ/OcQmaPE02FL3FGaZmIeWbsWj/tOD+6EJo1xyRiPdeIZva40BMdMSKwKeT/7OCVnWiT2zPR
	v/ig/U1pA+9nW3enBprZNs25xdlb6JCIauoTd56lbumhmMta/Q40Z0qD2gf/koVCWkw6UJaUJaB
	sgDCtUfVNiDNcf2jKrLdqT8=
X-Received: by 2002:ac2:4d0b:0:b0:59d:d71a:f138 with SMTP id
 2adb3069b0e04-59e0f53bca6mr56863e87.11.1769669529966; Wed, 28 Jan 2026
 22:52:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127012700.3311649-1-thomasyen@google.com> <4cb7b0c51d81f8e9959b0c50f12f1ca1416885a7.camel@mediatek.com>
In-Reply-To: <4cb7b0c51d81f8e9959b0c50f12f1ca1416885a7.camel@mediatek.com>
From: Thomas Yen <thomasyen@google.com>
Date: Thu, 29 Jan 2026 14:51:58 +0800
X-Gm-Features: AZwV_QhJVO37Zxsd9cxucU9IimOvnyqZH3k8tz47ECycTqX4QGae1MsU2bbRpK0
Message-ID: <CALw5pqHMhCKHWgqJMhGaXyMHoDbz5oxFkJvCRyC0rxvNsrmuBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, 
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"

Hi Peter,

Thanks for the review.
Agreed, we should disable auto bkops before flushing the eeh worker.
I will include this change in v3.

Thomas
