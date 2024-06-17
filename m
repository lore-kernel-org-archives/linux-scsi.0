Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FA418FDC5
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 09:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718615024; cv=none; b=E8Z2eguHeA1kA+cVsVPAmeCS7+0JVSP8QT3e7H0ufwfyUKJs+gfsSsckJRNrIobcDTey6p6orsVGclcLip8pirXCuxe/n5T4RSYTjljCKBkt9qTInvneNzKnqAR0XgIOS1Ok+RyZYaYwrdypuODPSsBnlaQ2naqFASBXkkbZvXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718615024; c=relaxed/simple;
	bh=nB8QMBkw+Gs0pg1mPKXuIZhWT23WrRcc+RsQ7FIMqTA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CkWo06AKhYgUMoRoO3OoImpbSp3B58e2dZkDlYipozCuaNmS4UxYX7MRBP3Y5XFJW7CKKIRZeq2TdjFWZST6BZNGWOxP3Co07Ui9Ts3kINocfmu2khRLq/PQ2dRwL0j+4A52V9I+ORFTLJ3q3kA2j0G63kuKBus2Z3WC17Cnlw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=1yhs8A8+; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="1yhs8A8+"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7042cb2abc8so2942312b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 02:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1718615021; x=1719219821; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDNdx/ptahIqYIH0Pj0xId5ttxu/lCJrKg2rnZynRFw=;
        b=1yhs8A8+yZZvqagFw3Vrduykdf38OHNEBpppN6JGgTKAQO5jpN+GX3wkcwAI/5dhlp
         J7tQL1I6a3rYY0ndIpVY6IzBE05BF0cV19rB8kr2JnAIY/ywIJg9Pp+kzFYl/NkZ/XDO
         xYtrnTeF/GHwK0b4k+uZMK1XUH6ImU+wePJLDftoME9ZKHfQL2AdoLUDCKSIp/k1wpI2
         PwTDWqjufr5TwZUfaL1s+W/SNfTzf043y6d84Fv1h2nZZiEKdrCG9cfTnFa+s1W7BXC5
         vsnKhJ6Gm1gC2pv5oQhDAgM0i/D/+5bQ7qSM3pj5+cyTh5/nOQAGoNBxshgvCKiEvQFI
         tdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718615021; x=1719219821;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CDNdx/ptahIqYIH0Pj0xId5ttxu/lCJrKg2rnZynRFw=;
        b=c+YEDQry+4UQCo6kDmnapntB58cEgdT7JYMWaj32ydPD38FWqaHFGTzWJa0ReshmjM
         1hqcCB5ZzEjBEX810qiL3s/KFsdqtRhIcDQb0Gd3cA87m0GjM8O2TBx/lQ6/Vv/WMpJk
         zNFhEoPQze44oLKcvCRt2jbX/uoqB8jHh1KZNJJ3E5FlD5JmazM8EHFgDW8pgYNpN7AL
         EuvXtjFrP7Lh8KAeMR/s7G7/VXvounZSZ6kRB+afxrj4pdFA8dqHxvRqKwVA8zx5uMSR
         Uwp0EXHbuz5qJHjtRkhE9K1pOY5kjrM8GTvUqs0tB/9nzK6PMqAkN0SY7tobWJEnX1iV
         SRTA==
X-Forwarded-Encrypted: i=1; AJvYcCU7ri2zB1jxpDG3EQHOcOROda2vsSHLlpEZtbd7hRvG9Ir6hfJnBNbN+nv1uNvArzAohfZsnZWemhLVujuGPw0F3V6lXMyMWmqX7Q==
X-Gm-Message-State: AOJu0Yzs02cvOK/MsY/fABpu65Ndb1+ael39j15ruZcCfjYw9jUil1/9
	IKxfIk3x8rVhW2lL7wa/Nj016r5/+Yk/jUD3cJM+vi3C6RMUlUmAFxVXQGnVRpE=
X-Google-Smtp-Source: AGHT+IGl4ZLPZeK1F68wu9bXpVDKybvPNImmW3ohNbywjyE4zel7t83lUzZALw6c8pEDGKdWBPKXzg==
X-Received: by 2002:a05:6a00:8d5:b0:704:32dc:c4e4 with SMTP id d2e1a72fcca58-705d7123929mr11639890b3a.1.1718615020941;
        Mon, 17 Jun 2024 02:03:40 -0700 (PDT)
Received: from smtpclient.apple (vps-bd302c4a.vps.ovh.ca. [15.235.142.94])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fedcf36aa1sm6270503a12.17.2024.06.17.02.03.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2024 02:03:40 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
From: Li Feng <fengli@smartx.com>
In-Reply-To: <Zm_U_ZA96u2K6a6S@infradead.org>
Date: Mon, 17 Jun 2024 17:03:03 +0800
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <44BCFE4F-AB66-4E6A-A181-E7D93847EF98@smartx.com>
References: <20240614160350.180490-1-fengli@smartx.com>
 <Zm_U_ZA96u2K6a6S@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3731.300.101.1.3)



> 2024=E5=B9=B46=E6=9C=8817=E6=97=A5 14:17=EF=BC=8CChristoph Hellwig =
<hch@infradead.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, Jun 15, 2024 at 12:03:47AM +0800, Li Feng wrote:
>> + /*
>> + * When the discard mode has been set to UNMAP, it should not be set =
to
>=20
> Overly long line here.
OK.

>=20
>> + * WRITE SAME with UNMAP.
>> + */
>> + if (!sdkp->max_unmap_blocks)
>> + sd_config_discard(sdkp, SD_LBP_WS16);
>=20
> But more importantly this doesn't really scale to all the variations
> of reported / guessed at probe time vs overriden.  I think you just
> need an explicit override flag that skips the discard settings.
>=20
I think we only need to prevent the temporary change of discard mode=20
from UNMAP to WS16, and this patch should be enough.

Maybe it is a good idea to remove the call to sd_config_discard=20
from read_capacity_16 . Because the unmap_alignment/ unmap_granularity
used by sd_config_discard are assigned in sd_read_block_limits.=20

sd_read_block_limits is enough to negotiate the discard parameter.=20
It is redundant for read_capacity to modify the discard parameter.  In =
this way,=20
when the SCSI probe sends read_capacity first and then read block =
limits,=20
it avoids the change of discard from DISABLE to WS16 to UNMAP.

Thanks,
Li=
