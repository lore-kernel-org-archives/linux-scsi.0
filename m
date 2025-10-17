Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A36E2D6630
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 09:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692869; cv=none; b=bmnG/enzxix1+ZTS6g3cfalzWmqN2mAEcvxFVaUtPF6CMkWWFFR9y+3vNKuqJEWESjMjO+F+WTGljjvCBrdCm0WgUPCY/TlCCkVzngRpDCDIlCaICtSu1Uq1V8A+k3oQsczXxjfHcfQ/hnS5gglwfyD7otL65brTDEMDmfBm1nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692869; c=relaxed/simple;
	bh=XwbL7/L7C9/nDL2/xmbaFiG9RcBj6a+Cj3r3ADzcpU0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u4iEJl2IT90MaSH6wl0tfH3oEuEMX1SxE5CLNmHYm6uO68TnzXBiMDVaBYwJIKGl7V6zn4FCdqeYP4w9P0hUVYxo+7WhdAkBaR0OFPzxZiZxfksKA5TOmk28VQ4H3PwZGxgE0gL83Rq6dgifOxtWtLvE7rnLeqQr3cCbFBiqxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2SuZ1Oj; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2SuZ1Oj"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-639e1e8c8c8so3181956a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 02:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760692865; x=1761297665; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XwbL7/L7C9/nDL2/xmbaFiG9RcBj6a+Cj3r3ADzcpU0=;
        b=P2SuZ1Oj6xGm2iA5KKOEpUHCvhMWF5HwqfjfdTnTR5SWrqJB4Ghcf9bbtMzOj889wd
         dyca7uVM2HGaET4428Tlan3dG66XXvcC1QGWpvjtPmLOBUzChA9cH8nQskd9LUpR91AP
         kufkblqFG2uajTg1kjWYz58OPgzeZe2x0EPW/zHSpfvpcp2FU1BpuzIWAWFVvbbZSteN
         HsCflN59L4QbqBtGPIibj1ZwgqmcaBBdHA3QG5Yg9lZ2VDeiXRmkSb5WyiyBWbMAZx2w
         ysodKKjW2vcc5oJCah/fMFfITVLQ3K+UAgCM77BbjBoy2E24JQ8M1LkCoHEcUM4gUasN
         6+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760692865; x=1761297665;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XwbL7/L7C9/nDL2/xmbaFiG9RcBj6a+Cj3r3ADzcpU0=;
        b=uRQdEDnMaxZJg6XNVWcnBSoEmmi1NUPnlhXhXWlG0q4QZ9QYeCeNAAo1m3VGvpgG6c
         3H85WjzwRWUhNqrUeSdf015UeqaCqUqo8Q0OfXvy2ePLbnPUXbamBCUvcg2DRT2sOI/5
         HxH2T+xEIXEW6eHZh+nrrUvWqp4OMw0AJ/igFtaZOjWSjj/VadCS7bJPZ5QKRZYVEXqs
         67xxfI2Gz330rImXGUGCKUNax6hLGRyOVtZURGAFB0WbsSCmbyo2uJjidAZphnztWjW/
         +HSGS9iO88jx45KWbN3EQsm3jWtZhr6LTz0j5YCUvBmem3BmEkP/1tczcolTRmcDHBbo
         YzSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD/WlvmIluujf2/45+jpCpQfcAE7PiYVUH51xXaxnj2e4F6zvlcjk7xEcStobRhzDrxDeFzAzFNMR6@vger.kernel.org
X-Gm-Message-State: AOJu0Yx43j8NjpvSqQPOnlXtEZ6lsVrd1Z/5LvL94NRAjD637rkr/DBU
	WnYKcVaoUw/tEmnYEMqnWUh4LHnqrfuJfpqmFGNmiKErglLJkCSRkvmtaLYlCisC
X-Gm-Gg: ASbGncueWKlZqwyBqP9ysBeoPjFZ6P3muHKDqjUzSgrfU8qkbZxZJeP/Wga4pRuecNo
	9fye3dwq0PqO+sz8XEd+X7rIN17NMltW3jQclslH8mHwu8A03WkrZ9f6ngQcUFSwhgH3SeLIcqK
	U9GRVtH0J6ck2a3FZl12HIdL2fbwLs3PZ43tEEkxy2JUuOOISniT9yjBjahmUzUYuUi9PZcBU0t
	homsymk8GpirXGe0pT7E7sY2zuZIDXllDzAu70RtldCl4R8DQjMj0GGftnjbcbBdXOb7kHZna3Z
	gtlZM8P/NrE5Lv75NsY1DRqBLl1qy8x1YId81Z8uS9C99JBsvkqDd1DOo4OACCLTJKCcVRmjD97
	B0Jd9W3OgpoMNYzqsZAigGwLHzstfaGUNQQRloETHnIaMyc+WPA+dTA4x87uFr7iVgqmTR3uosE
	stqUR3Wylvs3wKayTVpH6ztLsJPON8alrvSY7s3IVKHPuDE3MpPVRmzZXZRhYlwi94/PAC6Iyt1
	HCFUmFCojBnUBs/o6nGTxK8oE5o2u6076o+GWH18A==
X-Google-Smtp-Source: AGHT+IE7BCFzUNiw2i4QfZjW5SFw2tnLjupBLrUZan9DS+NtJPOwUeqzaVj412XY3mXWNnoOXTZFIg==
X-Received: by 2002:a05:6402:2681:b0:634:ba7e:f6c8 with SMTP id 4fb4d7f45d1cf-63c1f6d5e1bmr2398533a12.34.1760692864549;
        Fri, 17 Oct 2025 02:21:04 -0700 (PDT)
Received: from p200300c5871d09695ffbc7296f39d3ed.dip0.t-ipconnect.de (p200300c5871d09695ffbc7296f39d3ed.dip0.t-ipconnect.de. [2003:c5:871d:969:5ffb:c729:6f39:d3ed])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c0eb3a235sm3458175a12.30.2025.10.17.02.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 02:21:04 -0700 (PDT)
Message-ID: <8dd21b9be370998277cdc014d7e5d4d333adf575.camel@gmail.com>
Subject: Re: [PATCH v4 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <huobean@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: kernel test robot <lkp@intel.com>, avri.altman@wdc.com, 
 avri.altman@sandisk.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
 jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
 beanhuo@micron.com, jens.wiklander@linaro.org,
 oe-kbuild-all@lists.linux.dev,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 17 Oct 2025 11:21:02 +0200
In-Reply-To: <CAPDyKFrsMxyD5ASGmsQ8658eBR0vHOSUqJ4axuSpAXuue6d5Uw@mail.gmail.com>
References: <20251008201920.89575-4-beanhuo@iokpp.de>
	 <202510100521.pnAPqTFK-lkp@intel.com>
	 <eccb18abe33299edde64f96e0c3de88c4183cb78.camel@gmail.com>
	 <CAPDyKFrsMxyD5ASGmsQ8658eBR0vHOSUqJ4axuSpAXuue6d5Uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-10-17 at 11:11 +0200, Ulf Hansson wrote:
> > https://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git/commit/?h=
=3Dnext
> >=20
> >=20
> > do I need to add this queued patch for scsi tree as well?
>=20
> I have just sent the patch to Linus to get included in rc2. Sorry, I
> failed to send it for rc1.
>=20
> That said, if you re-spin a version of the series that is based on rc2
> on Monday that should work, I think.
>=20

Thanks, I=E2=80=99ll send the updated version to address the unique device =
ID concern.


Kind regards,
Bean

