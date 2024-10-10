Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E461A0706
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728545099; cv=none; b=f+RDTvypuP+cA0YkvHFGsULgsaOtVx1658z60mgGq3kzpJu+dmfihHcZD+Z8/K/om779JaePeQpw1p0yxWsuFDcRCO1m8C6kK+1FiXbEz4D05qUQj32GiF/g9S0ks67oB25mQj3fvTVRbM2Np5U/VpktS3aZcAbd6WiS0aS/Vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728545099; c=relaxed/simple;
	bh=H8BjYbUcGSqMitQRIuUyCgonqsubZsp//w1expmtnwo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rZb6yh/DsE+TD463PXXyVTvvHKS96YATHF9jAMLKo5UGQnOQTLczFwP+imGTs1Mt6TV+zc+8/vCiSqU5QCix/GTj+pfpyTKdLHwrxOYCdUysubtnS+Xv50VocBJ6q5eD70hUGN5NNWQKEuJ3VDeqyqp8dZV4x+b5l31b/GVUtEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LmGw7jfB; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LmGw7jfB"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4305413aec9so5205895e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 00:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728545096; x=1729149896; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipwVOxDlhLHkxmYoXZADXlwko+o+gpPjzl2xu0aXIug=;
        b=LmGw7jfBXT6dpsCgyUWuQr2n+tjqo8xm8155czHeYKHTls+EB6MUGhCo87qMRPDlkg
         AuU8xqfSNRddylSpICW7ls4Wv6bSKV9p5C6qqJNUbcivFB4J717Umsdqd5nD8rBNvsWX
         KESYillvloHGcafguu5DZrS/OjBoULjv7XvaP9BKbTlKr1KCPb799fz7lK8p+3RCbUef
         4fEjogGJfa3lB0gE+0TSA6Z4aE4EVrqXwj99sjEokrHyUf+uuSD2VHNLRGejYkgUQwJC
         lguRL5rZqj0m9DLzvnyWA+XTvC/DWCbo6Sx0XUlGrbs1rNNp0FgCFV4R25ZJslvIYLFZ
         00nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728545096; x=1729149896;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipwVOxDlhLHkxmYoXZADXlwko+o+gpPjzl2xu0aXIug=;
        b=PY/ALJ52uV0jZai1du8lMl1fR5q3ewuBZrUW6598afgcVGLfCKxP/LZ2y9qva8Ah8A
         E4gfmGRpDj//dkySdnr22uNjWhIIyquS6LQHmlZlzh/qLtA+TvNA6xZW5sJvft4y2M7B
         TNv4t8lb/904oHXLzFLNFGRwobd1rqb0HdfzAiW3y1BJ9EEaVBDkGMWmDlrji6x6Gmo2
         mM8FKIVutbU4yc2vbSeVyFZPYACbqtmfmlMkvu7Ytt8U1aVz2BhKtCrVFDdEoo6oICLI
         mtod6irwZ1M8cWyz1qtc5rH783QREVsCntq2haRao7NXRwyFO5gmpMk9nldktsEMJcAy
         uocQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4qaG7oEkb1AZl813wjox+Lx/6ltKI8WokMA3BQJhYPkIn/NfHrqhGgrMe8+UPPv3Tvwtlu08VUogT@vger.kernel.org
X-Gm-Message-State: AOJu0YxbDyQMPH689TcVIB1+aF7uh0Ebwem+TdT05oadrCmWP0AIrX10
	PM8Rp8Z93n1EZxSMGDkglYvtg2wJySYqlnls9OCNhAnGBLbr6mXMC9AxilLGxJA=
X-Google-Smtp-Source: AGHT+IFx7D8Sc8p5dTqspLDjguevw5xRt5BAWPOybNVGsdSlyLHFQUL2Qd/Je9cAijM6ayqAwvLr0w==
X-Received: by 2002:a05:600c:4505:b0:42c:b905:2bf9 with SMTP id 5b1f17b1804b1-430ccf31bc4mr49283025e9.16.1728545096057;
        Thu, 10 Oct 2024 00:24:56 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf51942sm39507655e9.27.2024.10.10.00.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 00:24:55 -0700 (PDT)
Date: Thu, 10 Oct 2024 10:24:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpt3sas: Reload SBR without rebooting HBA
Message-ID: <962ca8db-5a9b-4051-bdb9-386f29bdda50@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Ranjan Kumar,

Commit c0767560b012 ("scsi: mpt3sas: Reload SBR without rebooting
HBA") from Dec 28, 2023 (linux-next), leads to the following Smatch
static checker warning:

	drivers/scsi/mpt3sas/mpt3sas_base.c:8083 _base_diag_reset()
	warn: double unlock '&ioc->hostdiag_unlock_mutex' (orig line 8065)

drivers/scsi/mpt3sas/mpt3sas_base.c
  8061          writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
  8062              &ioc->chip->HostDiagnostic);
  8063  
  8064          mpt3sas_base_lock_host_diagnostic(ioc);
  8065          mutex_unlock(&ioc->hostdiag_unlock_mutex);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  8066  
  8067          drsprintk(ioc, ioc_info(ioc, "Wait for FW to go to the READY state\n"));
  8068          ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
  8069          if (ioc_state) {
  8070                  ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
  8071                          __func__, ioc_state);
  8072                  _base_dump_reg_set(ioc);
  8073                  goto out;
                        ^^^^^^^^

  8074          }
  8075  
  8076          pci_cfg_access_unlock(ioc->pdev);
  8077          ioc_info(ioc, "diag reset: SUCCESS\n");
  8078          return 0;
  8079  
  8080   out:
  8081          pci_cfg_access_unlock(ioc->pdev);
  8082          ioc_err(ioc, "diag reset: FAILED\n");
  8083          mutex_unlock(&ioc->hostdiag_unlock_mutex);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Double unlock.

  8084          return -EFAULT;
  8085  }


regards,
dan carpenter
