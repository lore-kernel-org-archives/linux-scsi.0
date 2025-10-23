Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47083279DC9
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 11:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761219151; cv=none; b=NiNSV1dTHPwOE3c0pM/pJweFMRxxyJxWY2X+GvkAeS8Rq6P8He2G8Xr8ixyGXcX9pzpqxeizkhExUiwUmiahugcXJUjHab4HbKK+sw79vAhQuvEfVpnNoIRCp8hJhSOu2NDNJmUAE2YEIYA2pWQ4x8oPVYvaW+/3ZoBaod2YeKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761219151; c=relaxed/simple;
	bh=hkSHrx3VxUsH7c2KJUXb8xO91/wpQksc9YO3odU5Mcs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MI4upwJEKLnoJvcHS47kZpGKMVlHpG3XijLiaQHi+Pjy6xgSXIYA1sTjFAENBjqeoFa+J276YAgT5c6F8xTYxBtNHcQHZWiCBHvzaCAi2mqVnLGG6mNXP+BZtlAM3P3HmB5YPZfp/uXuvwv825cZaSLoFytMowojF1mIQ5kmtzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEHQSHVc; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEHQSHVc"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62fc0b7bf62so1033545a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 04:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761219148; x=1761823948; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hkSHrx3VxUsH7c2KJUXb8xO91/wpQksc9YO3odU5Mcs=;
        b=GEHQSHVcHz94eQNLThw6g1mnuyM0gO/hONwUA3WNNAsQhPyuUAnIKqLfWsfKoZc7SW
         rbT+bHLmgizD9HYJuU0KG6vzlWje5hSd1HZHpIER7Vh9NsVbimpcq96Wvij8CXffPSGa
         jEUtv31t3oGSVXMH2+oUw86haonl8D6m2ZsIUD3K0Bgb54RDTcaCJ0oJqyRBd03dOxIe
         LXB+YtQjaF58RgigQB1OOaaWHTPbe6CyI/zA65DuABxSP26b53HoSpxSoaJu3KC1lBZL
         zEou4DmP8jUtFVRJq256+pMh3bvq4ufZ1SCkFT320rR8jo9onHd8nnKuwUI5LyqeCZXD
         rTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761219148; x=1761823948;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hkSHrx3VxUsH7c2KJUXb8xO91/wpQksc9YO3odU5Mcs=;
        b=gvHNbUrbmC+t7pT6Bb8iGM8/kowRwh4qbmzJXYl7XeL4J37GYnOKqGkiZjrgp0CEX3
         taoK3cB7n+OkxAzrblb6n0H393+zmg6pIYK5GAGeiRoCexT/3/sF95DXpaS2m5ZOFGhL
         G2nZi6Ev6HneyjA3shMDb3ogu/M/zYtFWg7EC7142+YGj7BR9ouWJEN5+WXlSwnC0rsq
         r+I7hzKaiepRALOXA4mc6j0iyEGi2DpO9ZWcxhsTiaasROMY+Mif175MAUdS/SseKjVi
         x0sVY9JzIZ9FHUwVz3aQGn5UYAg40cxM2KYvz9z13qIu/qEFmT4x2+mmRDanoIS/QndC
         ibaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjqfXyZZKZbQP3ymhMnCG6oOwoqinUbFaxj//a25rE2aNeyBHe48YaWy2+Y/Y7CnfcL+Te+labATjC@vger.kernel.org
X-Gm-Message-State: AOJu0YyM0jletzE1+i1j7orV0O5PBax3T63UTUrNRxqQA0Kzm7H1blNm
	Xj2hLxpLEb+gXTLrTjmuYe5o1AqiDlcXOjXdGPARQgo1mCafiXdyx5/d
X-Gm-Gg: ASbGncv4hIwrRTiShlSU8Jp/Lky5SPe8aPZtj5twUmVrgQtu6tBcl+PI9qK3UXII2RY
	R+zO3VgSojlZyxeGuawTD/381rkfl0zwmsiMfBj4qiH8dw3B2+xbIH+4hVpcBdlo8mn+3eW/bJT
	TEbyYgYMpH8dxhLT4dk1Pc11nd43HWib0xWcNWfLrFLVuH0VGOao6P/7161exr+Yf5Wk5YBIsXg
	VcvrIaugjsHU970WNoLZPo5Sl9bC+PUoa/h3ASn1wiJydgTG6J0MZoUypd30Ox93rE+qmWT5Xhb
	CODZy9ohYTPG8SkJhe9wd0GwZjfVJXVxGc85JJVzPP8p9aivXk1d3plXakv6yZ474ZzGKMxC2y6
	GjWucBu6iSb/nGSWprEYcYVv4qn4h6a1bX0hvSl8X1SThTbzpMuJJz3mvinXBAQHhPqejVL6tLg
	zCMtWnQd0RfbeqUw==
X-Google-Smtp-Source: AGHT+IHOljlpTe1E08pYu8/z+lSKv01GnF4x5HcsbOYapqVoGC0NDovHk7PceT9YuTHAm2rbC/6Jkw==
X-Received: by 2002:a05:6402:358e:b0:63c:82:619a with SMTP id 4fb4d7f45d1cf-63c1f641c39mr21555954a12.11.1761219148411;
        Thu, 23 Oct 2025 04:32:28 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e3eddc3c2sm1469200a12.17.2025.10.23.04.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 04:32:27 -0700 (PDT)
Message-ID: <43fc4d5ea1ba740517c21d056c7853631a537e6c.camel@gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <huobean@gmail.com>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 23 Oct 2025 13:32:26 +0200
In-Reply-To: <CAHUa44FGUvEAe-3nQyNejjuUPnG7JjnaYBgvHzwrs6kUnJYWVw@mail.gmail.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
	 <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
	 <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com>
	 <a040353e95a67dc3bde09b5f3866aa628150c9db.camel@gmail.com>
	 <CAHUa44HYNgiRU5yOrVq8gBwHEEAxGz6TyT0PrBpVOiFfKxYhOQ@mail.gmail.com>
	 <97c39c0cdb6b96d791fe05f8e5496a502a7e6ac6.camel@iokpp.de>
	 <CAHUa44FGUvEAe-3nQyNejjuUPnG7JjnaYBgvHzwrs6kUnJYWVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-13 at 17:53 +0200, Jens Wiklander wrote:
> > Hi Jens,
> >=20
> > how about combining wManufacturerID, wManufactureDate, wDeviceVersion,=
=C2=A0
> > Serial
> > Number (in unicode), plus the region number?
>=20
> Sounds good.
>=20
> Cheers,
> Jens

Jens,=20

please check the new version patch v5 I have sent, in which, I addressed yo=
ur
concern.

Kind regards,
Bean
