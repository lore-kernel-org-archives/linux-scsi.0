Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A12D2561AB
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 10:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759748093; cv=none; b=aMFJ9EVk+pD/NYIwHsAxmQVN+aWXsTPZqPAkfQ08irvFYLRZetizJfYPOm+qAeG2rxdMx+54IM5NxBKoOXTjywGKLJU0NKolzPgNB/0O+Ogjld2Y20gI/TkOVhpAiLwoIAtUp/xkYsSTTLTHmmHCOOVDv43x2YhA6mt8vrL3ok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759748093; c=relaxed/simple;
	bh=qXNXLA2jr121IED5txM/3X9BlnZFSO/JqrdDDHaU+08=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uvgwIiiA95WJCqT8FZJB54f5L1zp6p8ZCb+MhRQfvNNWMdtj2fo1pJ3qrbRBP/bpjMS5jDmutBbfxWJtmQI2G/2wqk0DMhifxENpEtOGZeIEjqtIzkLIvhlLa3OgkjtptPA66GJ7gcKo1vT/GrDd9rC+RbGoWXe1FCjqimR0nqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcD9iO5S; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcD9iO5S"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so842139166b.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 03:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759748090; x=1760352890; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qXNXLA2jr121IED5txM/3X9BlnZFSO/JqrdDDHaU+08=;
        b=mcD9iO5SD00hbHWBr0Dhlc8KF+ra94YzesMKP3XXBwhNP8xToWwzubBEpzahu8QqUy
         zI/WgdSEYkwezj0ymaSLJF3ewQVBsMUYg2oQicusBkCsLJH2HDUxs3HCQlfPuT46gZPX
         FhYGtkldR1Pqq/d6t/vTl9yOPLBw9ldUUdRJXZ5F9wIJSXqdFaG+t8Gc99cJvBjgl7Tb
         9TuVHFU+lWg1TH8U0pjU23c+I68ScA5DI3YfijN8X8Pq1RoALif0DICnL+iB8MBpiZmf
         5fC4Ij8jbQH/lXFy11ZMr8IT6K1bysipUr8eWSdvZkpIni2AMIvq5KNtqaKPqxrd+guu
         90Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759748090; x=1760352890;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qXNXLA2jr121IED5txM/3X9BlnZFSO/JqrdDDHaU+08=;
        b=iyT8RfEZPf4xZZUHK8DnNOtdhXXTS1/meh7oqGsKGtJVn0xN7GKbO3WTAtKiOuR5LN
         nZ5QZpehBjXL+yvzz9qccdtZq0M0+EIEz8zr3/Lfxda1IXTe8SxoyA1CiQ6aLzfMG2U7
         +uFxUZx+rZ1rH0V9cQEJizipmmv99VzLv5bgnWuN0ZCWfqck7bVxCYE1JUc5s9+cMBnN
         wj2/NSw8ifFlEKPrtV+I7nV1lHyNc1TqUG5lLyG1+CftekyFXsJchfG/JJGeMWiVLFFG
         4tQIEJS2z60nuXXlRHUuEyP9/nUg9A7R27hlcvq0Et6Qw8I/n5vuMc35OFuJcFHz+D+c
         Jbnw==
X-Forwarded-Encrypted: i=1; AJvYcCWq3Guab3QCXHQ2vpRkeSgs44qTJmQFp0ouVzPo0sbynYLMiDwbO1WesjNC8kWDBj15an66EPAX3CvT@vger.kernel.org
X-Gm-Message-State: AOJu0YwFbTBM+OKYwgkhYJFo3PGe0zzdQVzz1xtCqzgmrFy6MpPvrBoM
	+dRx7FPpZz0EM/h9mUknaKCl22y6pwVFILWLj4LuZgxjT+2ClqWuWdUl
X-Gm-Gg: ASbGncs5ERFcqGneXZ3zpGo+PUB23TPd7sLtMZtMCMfjhUdEP66yvmjHw+/bw0vwKO6
	SBvr7BTJXlWJgw4GOuF//JUpd+UbGrRS4j3eYDi+DHGB0c4MR6eZdtJpWUFVbdFO2lf/AKnO2yf
	Md+v5vSwVLIqTKimI+WtT4AEU2HCjQcEMvtsKN65PPyNY9Jr6sdGQg92ipOYDUl0gXF/qmemSsH
	5j9tn5ekBYbu3Jl/Uy7YPl91Ewl20Xdqwl72CDid40Y7PnHI682kg/TrzveI2DX9pQcrSook4tt
	3MegoYj2J/qZrKCb+2KHj7Q3Nomrlmsk9tg+dhHT8z56DaXy7ZnAhXB9GbMkoz3kpNH+zJG4S1p
	WP/WZQKp7OPspknHc6K4Twi6GJvcSjQSnTHZJJOrbbAf1JjATRw==
X-Google-Smtp-Source: AGHT+IFsbJIMX046ZdbgwCO0LHE40l3aSoIKhdw9r12MAKMtV4NAk+2OeC5sVS+LTODNz1eBr36Z6A==
X-Received: by 2002:a17:907:2d26:b0:b04:3302:d7a8 with SMTP id a640c23a62f3a-b49c4394dfbmr1406539366b.58.1759748089518;
        Mon, 06 Oct 2025 03:54:49 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652ad839sm1117104566b.1.2025.10.06.03.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 03:54:49 -0700 (PDT)
Message-ID: <41093b6af67db2073a141527e44e575d0811d55b.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to
 common header
From: Bean Huo <huobean@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	beanhuo@micron.com, jens.wiklander@linaro.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2025 12:54:47 +0200
In-Reply-To: <CAPDyKFpyh7Qag+ckCcPkr1RWh8YiST-4V2_Y7xvBU4LRLNC28A@mail.gmail.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-2-beanhuo@iokpp.de>
	 <CAPDyKFpyh7Qag+ckCcPkr1RWh8YiST-4V2_Y7xvBU4LRLNC28A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-06 at 12:21 +0200, Ulf Hansson wrote:
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
>=20
> I have queued this up via my mmc tree and plan to send a late
> pull-request to Linus to get this included for 6.18-rc1.
>=20
> That should help to land the remaining pieces for ufs in the second
> step without having to care about the mmc parts.
>=20
> Kind regards
> Uffe


thanks Uffe,

Kind regards,
Bean
