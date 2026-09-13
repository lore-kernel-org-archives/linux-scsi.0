Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D186360EE9
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789276047; cv=pass; b=n4x5M2VIIX/PSJgGiedNUzJ+H9QorRSvePkI79uZnwekDYqXADqYaQQaDU58CKl5GYmBhvewZ3CL3GGUsMmzOYOzuzqkG74sq9AueV3BxtvytGba3+AaLwuWhYGM/JMD4tNghYutoxNNBChpVJACV9Ng/aOh5alZie5Ims2Qwyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789276047; c=relaxed/simple;
	bh=ogfphTBQUQlV6omKxtkQ5kNPEgWY1UjFjmz628qVnRY=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bl/C8RaHhf1lbbNlxZdtpcl23Mm2bDSTFLOwq15RttlErvFfswfy83OvfVaOTm06QIYiPFmGOr+Q1MaPFIJ/VYWTgn5yEJF7Cu6YitMLHhcXS7oT/LSK0WMWEtNrpUQ5+EqC19utBgw0pj5Q10DqtSQ49pbEUzPWuTzpaAXSCMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XFvghlvI; arc=pass smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XFvghlvI"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-5306706e89dso127791cf.1
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 22:07:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789276045; cv=none;
        d=google.com; s=arc-20260327;
        b=BgHbx0ZLetZiaXsX5B+blxC/g/aJrUa+sanmEggH6O6sUETIQxb6FXAF3XVOzebENd
         gYqnd6cuvNmR08DpKowixNX8Igh9fo/Vjt3YQgWtiaJvEe+/2uKlKCQW3MLirAeXSJnW
         0KVz7kLCvsYlUkIJNMmPDZfFXdPUoMJyx+ejogeBshSzgEDXb4yocSgXcRhG2plsaxfD
         QM3yDX3XhwVVfOtw226nZThlLpdypycjMJ0yptgtJfRUDjaDK7rMEABOgEDPrduaLZfg
         mIkDggTkjeAewOLb41JfdRanb8KSF8EZx0aruG8/f5guHrkrwVvxH/GIWRR2qJ352Q+x
         vlyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=Pt7qi17wjMgs8QGCYVHxKxYn4O2l8zR0f/jJN8Gyipk=;
        fh=niJBmumA/apjr480Cjwes+taNiHdO6+GzhwPU1CY2Hk=;
        b=mNKGA160cwnuDAJm8wYLtHxqbYy5Iv23qHqoM4kFA5Sy/xmpiXA/HEPlE+QbHRU9Xa
         l6JuFO0lyssetGq8ulbSNrWLhshfH2MM+wTGjHm/TD5M0Z5vqDyxTfjIgk3COZ5LLgf1
         2j0PA4uVnA9D0415PDUr9Td9MDrJbmfITrSvQRvKRCcvKxp+HUyr1u4J3rohkqSzvcAD
         OYXxI9Qy7oj1jOMAn/rL7kdjBdmcZbf7SfEDhNC8iSqI6ObtB7ymCmOMJ34i5/kqlWBI
         pfPog2FJui8pjIzKn5/cMTQkzSq9B1K4GfMg/9s6zZyJg6HY8pRuz5v8CjpmwCmZfAkw
         bSNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789276045; x=1789880845; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pt7qi17wjMgs8QGCYVHxKxYn4O2l8zR0f/jJN8Gyipk=;
        b=XFvghlvIrLJBc266ZwTjP6QyViyesp7iSuH6KzitV8KaAQzOfJuPNcFCYY5KJrK31O
         K/MaM/B7jQntPGA3a7ngiuu2mKF+YNX9eaH54iDwppJiWdLsPYEE1nBgmM3ydLlay9eK
         UTgwrZDEzbYb0GbRF2z1eLnNYDv0k8yp11PNCFtGlu5nvKTNnw0+ALqa2G+SSrqh+Fdv
         aEGW/+3Z8oeEQAMUh2VTVWcjBPRY+KjftSt4qgMzZgakggHwUic2nVIM8KmeAgLCAu81
         h6vuW2WKHqcgFTYLJR6GS/7/4au6ub1++5YxiKOt06OBj8fTtg+LslY8emu6NEQl81Wj
         zZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789276045; x=1789880845;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Pt7qi17wjMgs8QGCYVHxKxYn4O2l8zR0f/jJN8Gyipk=;
        b=YJ+6udTPo9ao88z9tGLwo9zrVSwLBlhcBMDn2EDS6fpNzAij8xJe59xbgjnCaITpc+
         BLOEos4t/It9PM0LBf/tLGbyz5UfYqblSzNnU0l71ZuI6Dn9jLRORou+EgxNKTSbgLzl
         7UUuzraTuKsbYDi49v/3NA7mhVctzX4iQ8tj6VsCFOD66MJVCP4z8qEdutJFeBh2pcC0
         jetEw/IcpK25jz1lPNLD5YaLD0MNP2BH0aDWznfh1W8pBbRwjqioON1DiFedwV9U3eyb
         PSGg2VC4iIilTVlud+MPQsyyuJ8l4QtbAC0zMZd+R43GgAF8gekJYEubg3cUmlLq3Jyp
         kL+A==
X-Gm-Message-State: AFuF++k1E7C5yWApxInIc9thd820LmDvH5OgEVod/zP03QxgC7iyVj92
	eXxCvU3d9vREsYzGRaOeBTZ30KbKDnIVaWAE7ZarUW7XzKD9uyTx1+ggcHO/crM/qe4Q1pbNnr8
	rRo88g1EzzAF4DE1mZaLmlZFjqpohhgbKxr1Hsx0OG1YX4he8EEvTIFZI
X-Gm-Gg: AYBFou1qP/HGSMJd6xq5YW4xX7TyDwHqw2h4VMxuRqZiI8GJMNaYN8tWGS17Tqz2osy
	OKN6d8yTEwvQkiASj5uIVoPsa7FLa1B/EZS+5oXTpa8/DErxrgH26a2itot87MHDhHuyac5kJhE
	wge/PvikmHsM3CM8KPufLddKwu4H16perIWlwXMude79w10yfZ+kflaujGlWkHsUD+vidkXnQNp
	RJA0+VnKWVqsQpUqHk9gdVCJ2AWkUcmM7kcGI32LGZlD8N+rL+HPgIK5jVnIW3b+35XllhcsP6B
	HGSo4C4sB0fwQaBASy1e7a0HZwjqInYpC5V6baf/oUq73J9+btzwiHsFx+xj+glkmXj0HgJqt8D
	CzfxVyOo=
X-Received: by 2002:a05:622a:480a:b0:52f:9ed4:8d75 with SMTP id
 d75a77b69052e-530fa2c7360mr2854921cf.15.1789276044642; Sat, 12 Sep 2026
 22:07:24 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 13 Sep 2026 00:07:24 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 13 Sep 2026 00:06:15 -0500
In-Reply-To: <20260913034726.28F751F000FF@smtp.kernel.org>
References: <20260913033633.3159296-1-stanleyjhu@google.com>
 <20260913033633.3159296-3-stanleyjhu@google.com> <20260913034726.28F751F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Sun, 13 Sep 2026 00:07:24 -0500
X-Gm-Features: AcwNN1WSVmOma9ruo-U5RCIYyzfUt5DRjt-E9at2LyBlBTaUFdC0yHbx4OhMuZo
Message-ID: <CAE14pdfTsqT0j1+GT7fEReJagZYC4Aa4gwBSmvw7xYJNSDEmcQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] scsi: ufs: rpmb: Decouple device lifecycle from
 devres to avoid UAF
To: sashiko-bot@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mkp@kernel.org, 
	jenswi@kernel.org, bvanassche@acm.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 13 Sep 2026 03:47:25 +0000, sashiko-bot@kernel.org wrote:
> When ufs_rpmb_probe() calls scsi_device_get(), the following call chain occurs:
> ufs_rpmb_probe() -> scsi_device_get(sdev) -> try_module_get(sdev->host->hostt->module).
> Since this is called during the driver's probe sequence, and the SCSI host
> template module is likely this exact same module (ufshcd-core), it ends up
> taking a reference on itself. Because the reference won't be dropped until the
> device is released, and the device won't be released while the module is held
> active, doesn't this create a lifecycle deadlock where rmmod will permanently
> fail with -EBUSY?

The release point is not tied to module_exit, but to the glue driver's unbind
phase. Because ufshcd-core cannot be removed while a host glue driver (such as
ufshcd-pci) is active due to symbol dependencies, teardown inherently begins
with the glue driver. Unloading the glue driver initiates a hardware unbind
cascade that destroys the RPMB devices, synchronously dropping all dynamic
references on ufshcd-core. Once the glue driver finishes unloading and
relinquishes its static symbol dependency, ufshcd-core is left with zero
references and unloads cleanly.

This lifecycle was empirically verified under QEMU ARM64 with modular builds
(CONFIG_SCSI_UFSHCD=m, CONFIG_SCSI_UFSHCD_PCI=m), where the usecount comprises
both the static symbol dependency held by the glue driver (+1) and the dynamic
references acquired by the instantiated RPMB devices (+4):

  Phase                                      ufshcd_core usecount
  -----------------------------------------  --------------------
  1. insmod ufshcd-core                      0
  2. insmod ufshcd-pci (probes 4 RPMB devs)  5 (1 static symbol + 4
dynamic device)
  3. sysfs unbind 0000:00:02.0               1 (4 dynamic device refs dropped)
  4. sysfs rebind 0000:00:02.0               5 (4 dynamic device refs acquired)
  5. rmmod ufshcd_pci                        0 (RC=0; synchronous unbind)
  6. rmmod ufshcd_core                       0 (RC=0; unloaded cleanly)
  Kernel splats (KASAN, lockdep, WARN, BUG)  none

Therefore, the cyclic dependency concern raised by the analyzer is a false
positive, and the teardown sequence safely completes without deadlocks.

Thanks,
Stanley Jhu
