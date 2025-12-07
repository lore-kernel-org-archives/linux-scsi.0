Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D04224D6
	for <linux-scsi@vger.kernel.org>; Sun,  7 Dec 2025 23:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765149357; cv=none; b=CbZuzHQc4Czk2L36KmwFmWBSfoFulAZSzk+HszSWVqAhy2bCPlxNT0Cn1/h62wAPKXALcQx+wFdBsp36dMVG2QW2h14psN5TjBSlv9lsLzkwA3y6EBFTyWletzpk9PTi/1jPPlYrzFjFzU/BynYozRzeeFpgakc4ZdJWjYPA0r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765149357; c=relaxed/simple;
	bh=JrawoIvD5t0mSOtoyYriDOG37dzck5mS9GT3TPZS81w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=ByalMl3mKATOsb/mDBRDVwXA7wFh4RyNKMxDug1kXrp7ayusMGVknwoEx8NGLD1MxZs1vSRS2QjnTnmQwfhER2P6pzKP2EoHJhMyESw2k7RtW6sfayvv8z0rMAsHE76kVjAKohpisVjdCM24Ze5H/M4a1oR227cjy2UVW0hQtjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pdP1IOPS; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pdP1IOPS"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42e2e52cc04so1326896f8f.0
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2025 15:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765149354; x=1765754154; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrawoIvD5t0mSOtoyYriDOG37dzck5mS9GT3TPZS81w=;
        b=pdP1IOPSL8KY3IxDXkN4DeLPaWDErmLm++ZI+K2V3F+iMdk+9svTMBxzeqVufMDb4c
         VqS0L7/Isr8sWDqpKcmaZJ7jqmS1XHlXUnKWDTVHd2TyLKYqz2PCy83D4GPHMZV/52Df
         HjF3Hv1rTIWM3HSXELgBZWu/XQgNv95rW/QizddCHo9oxvDXmrX+KDc4I4CeH9tdnwSC
         SMZErt8fRPdW5UsPGNwjLL5Npe+jLhhhnz45DcBDgS8StOECkK4HH9n8EliAj7JApJwq
         N/ukRV+Lm/XWSRpWGFBGggtyd7zPcECJ7eQHAhruKBpMZD0NvHoT+wk/yLkWZkMj9e4r
         y5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765149354; x=1765754154;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JrawoIvD5t0mSOtoyYriDOG37dzck5mS9GT3TPZS81w=;
        b=xL8tDaifzH4SsgWFgZf+V1ilzAb5AW4jy33LSlkQZ0zYDoy3RmVS7pCxCnHvH2Hyhx
         ZUYpspvHWfab8vHZX3fVjptFOd6D5JBMaOKwAj/PVlgpHqN9mKAaWnrg2gtEJb/Q1JW1
         lAFPKHGwBPH5XGUe7RA13v5ZgqwwV3OPgpEPL++ENT2C/PJ+kOjPvHfiOexSb9ererzW
         jprFbXEix3JIK7lGSUiEYfBj5OOs8SlqYevCgCLFt2n4p5TJcEq7xYNARK2Sy5KP6HoB
         gurTkdPUCBvCXMVIBC9puvuUCnX00Ou7sYObDwkoMSoXVH4LNVMYSiFNOk2SG9k65K5d
         ssVg==
X-Forwarded-Encrypted: i=1; AJvYcCWAhhX5bYlsC+9W/1w3QyeUwBYsdMHKFl9btTNMn34l2USh42DObmjhOgx+VGIuXEyDt5CZgA/YGvwy@vger.kernel.org
X-Gm-Message-State: AOJu0YyHj/27z68fmzTCQySlhYJm3IwENW3qV7EVem3vXBn9HLHCzf6n
	uFRfNr0FfdSisLZzHPHFkIfv4kVoq/4VJokzxGBMqAl9UpT7n7XNNE7Q5QBBj9SOhHA=
X-Gm-Gg: ASbGncvzE/GtKinu36k1nltH9IMpZl+r0tiC/lEPGurEFRioebqddSlONr+fR47bvg2
	yxO0Dy0BZd1Md+OjcFeoAnRQPAa6q7t4PQjMiYlkkscRu3m0nUvVM3CxZg+0Pc1BNP4mKlJFu1N
	cIjTK6i+yxPsk0D0YnchldrF1yargXVygtxSY7Hszzb8ThlkIDn/kRUnuZvF1PFxxuRIyV5yrL0
	MifB7/vUpAGRmVlU2W19q/iSBGFGMAt3YXRMchmbKBeq0bmzn8utqgIC6E146wtK7oNAJAYp8ss
	O+XzH1vLNchGM0kzVGBPC0B1z/ib9LqjT5IGzxRogOs8qLBN+jcQyDyoBbdRrDQMGihJNthSNb6
	DaaGDeYRED1BoSck41kGLPDZToc8YeoUx4IlP/sagi0H+IcVJcL73Ft0AgBAnoPdfjyqnoLlkgL
	2nLBY3vtreXyOJmI5i
X-Google-Smtp-Source: AGHT+IG265bGsuH8yFF78i9r8fah0BbcyblFqGg1lC2v8CBn3ElR0sMxydVKkkvoEWSpFSE0ekKljA==
X-Received: by 2002:a05:6000:1a85:b0:42b:40b5:e64c with SMTP id ffacd0b85a97d-42f89f6340dmr5988631f8f.30.1765149353630;
        Sun, 07 Dec 2025 15:15:53 -0800 (PST)
Received: from localhost ([2a02:c7c:5e34:8000:da07:24c6:f91a:9817])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222478sm21783666f8f.20.2025.12.07.15.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 15:15:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 07 Dec 2025 23:15:51 +0000
Message-Id: <DESD81PA9NI9.NKA6IOV0ROX9@linaro.org>
Subject: Re: [linux-next] potential deadlock in ufshcd?
From: "Alexey Klimov" <alexey.klimov@linaro.org>
To: "Bart Van Assche" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
 <mani@kernel.org>, <linux-arm-msm@vger.kernel.org>
Cc: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
 <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.20.0
References: <DERQ2FF2WO70.3I04I9XAG5V6D@linaro.org>
 <46cf2cb9-76f4-4d73-be3d-88fcbe7055f4@acm.org>
In-Reply-To: <46cf2cb9-76f4-4d73-be3d-88fcbe7055f4@acm.org>

On Sun Dec 7, 2025 at 3:18 PM GMT, Bart Van Assche wrote:
> On 12/6/25 7:07 PM, Alexey Klimov wrote:
>> Is it a known problem? I can test potential changes to resolve this
>> or try to collect more debug data if needed.
>
> Please help with testing these two kernel patches:
> * "[PATCH] ufs: core: Fix a deadlock in the frequency scaling code"
> (https://lore.kernel.org/linux-scsi/20251204181548.1006696-1-bvanassche@a=
cm.org/).

Thanks! This looks like that one about fixing deadlock does
the job. I provided tested-by tag there.

> * "[PATCH] ufs: core: Fix an error handler crash"
> (https://lore.kernel.org/linux-scsi/20251204170457.994851-1-bvanassche@ac=
m.org/).

I didn't test this one yet though.

Best regards,
Alexey
