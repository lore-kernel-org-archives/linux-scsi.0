Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2E552F71
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185822; cv=none; b=gh+OErtfU1TmDryxuOXh36Hrr+VTvSAXRmu1PecZlNN17rozlu9mUV2IVHvSPDw6MxnTMgedNpmqdpJHaKoPtnrmEnqCh0s/Fx7gjhYiEdIuNcvneYY1v7duWOtumpXW8U6Y3m4XbDVj2jaflaPBBZG9mJsDmZ+FF691p5WdwL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185822; c=relaxed/simple;
	bh=Exus06tqr0/Kq8YEqgDuuIugLyOcKaxMKoL2Ct6QxgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S0dCr6RHde4lv+K+FAbHpXLBcoF+5mIxy/s9OsYRhhJj/uFVeuqFTSwDTf3YhAcwqKh1f5gLUT0EK6aezkwFg6GBQ40tyNkV7+Nc8kK/derblkDF6nP3JEt+Z3WJEVdaTXnG3Fql39liuiIBZQvoulzCCL3qE67P/pwJGLBiPjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DFbfjGGi; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFbfjGGi"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2506bd2e0ecso977405fac.3
        for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 13:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717185820; x=1717790620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSNcqX4IVvMIFvAxJ9VFtgkrXNlZP1MdCzc75UTTvr4=;
        b=DFbfjGGiV5RzTMdjN9lUqSG/i+h/GL9byUAHjIMWOt03YeWKsc66FiWEPq0GwA8NQt
         ANPHG/ryxGdG3eV/cA8CQtI47tLLMDEobMSrn7lMwrHTMWWDZK5HHFWPR8hYq7EiCC8G
         pZ+eXVZNmCtzWkBBpBDHNfQrUJ3SokTfNxOS0mGRif88sA6Ew0lqAzgex62xoh4HblnR
         gR0KZLwkWEndLLGE/s3oW1icJjL5zf7R9UInkoDCUIrV+oLhjKBQgWzH9nLpFGO1IjLs
         N4m/J295lsjB6F1mST5MAlpFHyx5IXM8uU4uHC+ew1aaX8X4K9O+RYhZixsf0LAuqKIw
         w3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717185820; x=1717790620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSNcqX4IVvMIFvAxJ9VFtgkrXNlZP1MdCzc75UTTvr4=;
        b=I8b00jPH+8+AZs8rWeg3RgziBeuOSnRivQ8KJqqh4WhI9TqbMH6v2ec0NDcY+gWixp
         GJtrYQtifuI6QZjc+I4vO/so/m1rPS8DUuasYCKdjHfmIhfFNDgYrxrsu4nT8VBlaA+j
         dEDm1ZZrRMBnOaG7UPZJiloKa3K7QEAsVpyB6zeqnLtjY98yDqGCQMvveohmQ9TYjXDi
         2a+JOkNCvQwHEcP20B4gTgoBIrPHQvZS2n9UeM6rYUhYWdISoVcg7uO6SKVSq3H1B1li
         WqsAT0UQwiPpaP0rOkheqWbEKRH+bchUp6VdAkBxOMZcgHeUDdtLh5GWRNL/ePl7qRI8
         4waA==
X-Forwarded-Encrypted: i=1; AJvYcCXjrhYmeq2FM9pHT/5dTJgTxbTKzlsGwIaSTkJSPVnN1GB4bZop7TvNkljzKDpaKWMtelhixDzdtc++7OtmsMVNklFO3wIKyKKyLw==
X-Gm-Message-State: AOJu0YxCLPLjv9ME1wCur7h3kryR9lzPCKxOaD1eyKgqGHpgzxbfd3ju
	fK3wSwuKg11somscLVIqyHRl1OOXsN3jYezYHGJNod9cXlyy630yq4Ort9qFHCFWZsgf3u6g0uA
	qPZ9gedxR35inhnTfugdZegq6Z9w=
X-Google-Smtp-Source: AGHT+IF+jb3kCuJMgporFnQo8vsVJEdyY8bSLcDZ8hFCE0qfR8UmsbtBNiJyGrQVoa0NlxiNwAyy6Y3Z1FRRY0UZCRQ=
X-Received: by 2002:a05:6870:d6a9:b0:250:191e:aeb2 with SMTP id
 586e51a60fabf-2508c04a931mr2873792fac.56.1717185820157; Fri, 31 May 2024
 13:03:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com>
 <493e6372-cb4d-4f1f-9803-17d37a0fcbc4@acm.org> <CACLx9VdOeY6ZXEwGp-FOQY5VKJzgN6jJZQMhOdY9WnQjm07KSA@mail.gmail.com>
 <effa6f38-50a0-4760-bcf6-71bdfac24ea6@acm.org>
In-Reply-To: <effa6f38-50a0-4760-bcf6-71bdfac24ea6@acm.org>
From: Joao Machado <jocrismachado@gmail.com>
Date: Fri, 31 May 2024 21:03:28 +0100
Message-ID: <CACLx9Vcv8o28n3_jmuJmP0gRb6zU+L_Ut0cP3KEy9b+p-t9bkQ@mail.gmail.com>
Subject: Re: [REGRESSION] USB flash drive unusable with constant resets, since
 commit 4f53138fff
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Patch works when applied over commit 4f53138fff ! (bflags change and
it avoids the issue)

----working on patched 4f53138fff----
May 31 17:15:58 oldell kernel: usb 1-1.3: new high-speed USB device
number 5 using ehci-pci
May 31 17:15:58 oldell kernel: usb 1-1.3: New USB device found,
idVendor=3D0951, idProduct=3D1624, bcdDevice=3D 1.00
May 31 17:15:58 oldell kernel: usb 1-1.3: New USB device strings:
Mfr=3D1, Product=3D2, SerialNumber=3D3
May 31 17:15:58 oldell kernel: usb 1-1.3: Product: DataTraveler G2
May 31 17:15:58 oldell kernel: usb 1-1.3: Manufacturer: Kingston
May 31 17:15:58 oldell kernel: usb 1-1.3: SerialNumber: 0014780F9955F971A5E=
C08D7
May 31 17:15:58 oldell kernel: usb-storage 1-1.3:1.0: USB Mass Storage
device detected
May 31 17:15:58 oldell kernel: scsi host6: usb-storage 1-1.3:1.0
May 31 17:15:58 oldell kernel: usbcore: registered new interface
driver usb-storage
May 31 17:15:58 oldell kernel: usbcore: registered new interface driver uas
May 31 17:15:59 oldell kernel: scsi 6:0:0:0: bflags =3D 0x400000000
May 31 17:15:59 oldell kernel: scsi 6:0:0:0: Direct-Access
Kingston DataTraveler G2  1.00 PQ: 0 ANSI: 2
May 31 17:15:59 oldell kernel: sd 6:0:0:0: [sdb] 15654848 512-byte
logical blocks: (8.02 GB/7.46 GiB)
May 31 17:15:59 oldell kernel: sd 6:0:0:0: [sdb] Write Protect is off
May 31 17:15:59 oldell kernel: sd 6:0:0:0: [sdb] Mode Sense: 16 24 09 51
May 31 17:15:59 oldell kernel: sd 6:0:0:0: [sdb] Incomplete mode parameter =
data
May 31 17:15:59 oldell kernel: sd 6:0:0:0: [sdb] Assuming drive cache:
write through
May 31 17:15:59 oldell kernel:  sdb: sdb1 sdb2
May 31 17:15:59 oldell kernel: sd 6:0:0:0: [sdb] Attached SCSI removable di=
sk
May 31 17:17:34 oldell kernel: wlp2s0: deauthenticating from
f0:f2:49:98:2c:b8 by local choice (Reason: 3=3DDEAUTH_LEAVING)
------

Maybe code changes on recent commits are interfering with the patch.
Same behavioral differences are replicated on QEMU using USB pass
through for this device: tested both 4f53138fff patched (OK) &
1613e604df0 patched (Not OK).

Thanks Bart.


On Thu, May 30, 2024 at 5:38=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 5/30/24 02:46, Joao Machado wrote:
> > Tried the patch over commit 1613e604df0. Issue persists.
> > Attached git and journal logs - notice here usb is using xhci_hcd
> > instead of ehci-pci, but this is because it's a different
> > computer/environment than the one originally reported.
>
> Thank you for having shared the systemd journal. In that journal I found
> the following:
>
> May 30 10:23:56 archlinux kernel: scsi 6:0:0:0: bflags =3D 0x0
> May 30 10:23:56 archlinux kernel: scsi 6:0:0:0: Direct-Access
> Kingston DataTraveler G2  1.00 PQ: 0 ANSI: 2
>
> This is unexpected. It seems like the new entry in
> scsi_static_device_list is being ignored?
>
> +       {"Kingston", "DataTraveler G2", NULL, BLIST_SKIP_IO_HINTS},
>
> Thanks,
>
> Bart.
