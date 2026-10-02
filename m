Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47624AE8A8
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790948530; cv=none; b=RW9L1Pk9qewE8sopZ/XhhXeP/g63JBrKDaHUGRakvTElL+r4yC5PjN0jvthFTQGDxivluoB7IqICpgYE/UhOwp8SYD5gAexC6u5ScF5e8+BDjOVMbSS14zXPcaEDdW6J34l5To6rdQDnYIgJJtOTXXV3lfJptWmVtrQdqJ/z6Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790948530; c=relaxed/simple;
	bh=nCj7k+RlGhMynfTUTNniwAkJyVgH4rVRVdW0dtjySgk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sWcpvmz7qPbk3m/W/XjXYDxbpGx0+EpPbZvjKSTADCwtlZXDaK5oRUjPV+fc4q1n44CUDBfhjb84l1kK2MMmZWyja07I2fkXcW8FWdAosT0DnM/gLB2/pEbHAU5sn5MUx+6frENTPBomGphgfKUKMbLsJLPwp7PGBDIQOweTkZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i9uICV/0; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9uICV/0"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-887e45c81bdso1494840b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 02 Oct 2026 06:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790948522; x=1791553322; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nCj7k+RlGhMynfTUTNniwAkJyVgH4rVRVdW0dtjySgk=;
        b=i9uICV/0FpTBIDWTMy4JJkADRMRamblmUK5c7wh2GQb9wFglmx1RI+49ZdVTcKLwqj
         SrTihhw/dRdJ1AzyHjMBZXHMW97VeKufFMNEydHwV9uVO09WvZqmKokHgpLvlgllk6DO
         lFMqhGOGWQM1pOCXA+ZbEfaLjCuxXjtqOU3Fk2SuzjNDuvLNLO1q7waA/doCDiuns38J
         putoOYrF3+drABQvEgP/rkkDnZxJqtAyeEV2d7DTz19I+sByPfbqy/oNFyWh/fS2uh71
         pWUkxqzp9xuA3o4tv5iXfO4ik0vbGXJJbz1LJsSrvsRBF8W08AnqUqeGo4t58VqKGxhr
         OCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790948522; x=1791553322;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nCj7k+RlGhMynfTUTNniwAkJyVgH4rVRVdW0dtjySgk=;
        b=kZG1PG/eoXjD0c4wX1aDxufeiK2JP6NMuSX0fAdRJvrvpIyKP3ctpT5i/Wu8iGxYC3
         4hgtWNIkT6ygOnvL+O6fXFCJcEhKrvCNJho+f2LwAb2flRb+a2911ImloTIT4/AKwbjn
         +MlWtWSQBvmDlgjL+Vf6jjKrcm7Q78TGz0jr7J2+yx0wTlPl1BPcRi77T8Nl9AeUKKXL
         r+K6IRnSsnf21He3vnj7mCKVmD2oMznehE6Pftfxnjo8Mnp5/CAranKU2LgdTKl+rnHp
         edkntiUcg2mSCVRCU8I3T4Ybk1/bcDEMRXnq1qZRbi7HlsiAEw4MbHkOMaiL6oN275MO
         SKYQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1g0NS1QPmtbfOukLdXBifqTqzYIOPReMNX9YRC5zo8FRHVIG8Be5z1/mWkdkk73MDnReAT/Ituasv@vger.kernel.org
X-Gm-Message-State: AFuF++kdEtLuzmPy/UKjyTUddZOlxtFNcVhjriFiUd6MqdYWYFrC7hTi
	ytLIxJrPKlc9+2kSWFQXmvithBXUNed7+7pyeL0htKuH+OTAWgQx8gyM1YwEhey92UOSC5MH0gR
	d7P1gWMdWinzT0BZeQaYLAA==
X-Received: from pflr16.prod.google.com ([2002:aa7:9890:0:b0:87c:d84f:5ff5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:148a:b0:886:53aa:f5e6 with SMTP id d2e1a72fcca58-88af476b162mr3069585b3a.12.1790948521260;
 Fri, 02 Oct 2026 06:42:01 -0700 (PDT)
Date: Fri,  2 Oct 2026 21:41:58 +0800
In-Reply-To: <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260930135947.2339918-1-stanleyjhu@google.com> <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261002134158.2844652-1-stanleyjhu@google.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@sandisk.com>
Cc: Stanley Jhu <stanleyjhu@google.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Bean Huo <beanhuo@iokpp.de>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 10/2/26 6:31 AM, Bart Van Assche wrote:
> On 9/30/26 6:59 AM, Stanley Jhu wrote:
>> At Avri's request, remove him as a reviewer of the UFS host
>> controller driver. The listed wdc.com address also bounces.
> Did Avri request this? I haven't seen his request. Did I perhaps
> miss something?

It was off-list. I asked Avri on Sep 29 about updating the bouncing
wdc.com address, and he asked to be removed as a reviewer instead.

Avri, could you reply with your Acked-by?

Thanks,
Stanley
