Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4ED51C5A
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753976718; cv=none; b=bTPbO3M5WaI86v2BuTElNwebefP3qcsvv2lTmr7s9hE6UTeFDtfe2DOQnQthpVVPRdp6jkjBtw3D46tJC4jKB7MvjneVTn+EVi2rNARL+o30/lHTO+4EC+Y1I05PIP9z4ILR4MPUkihGN9cIU1/LlCNQal6JYqEi4ZH2ho4yn4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753976718; c=relaxed/simple;
	bh=jZlOt1YZkVCFwV07TI+TAfO2Qv0hXeA8f+UU9YjpSgg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=sAsBXQdvyQE4Qjp2aq+i7k3ve7nAk8JkTc7UbiuS4zzh7mFGlpcwujkVg7xDspQRHlo40Fs5IsFKPpFqoiAxJaTGJo0I6l06PypM1LymQgwb4qLQKKMw0PfxpLYLoCh4NREyHTqVtqEqWvWfTjsK7Y3ebMJ9VMwaogCdHoqxeFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ndPXYK4N; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ndPXYK4N"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b780bdda21so909006f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 08:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753976715; x=1754581515; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ja/Or7TtQWbgvEBjUvVLczjO5A/ZgQzAqJjlnzQL2m4=;
        b=ndPXYK4Nim6pZVKTkxJOBdhISbo7+ye9j7qTHpv8PRfpbSgpH/MeF83RwzYVruQI1B
         Yvj/eQTRq54ZdiWAD74GU47YYQba6MZsplC5QvdpJgNZ5ZmT6dev9PBbl7aOubS3Q+C1
         /o0wtKraV0vm8UNLgl/CjG5WgWwegJyqfVNvMYmp9hnhoYkOMDKxiQk8RtwBfkcrvIjS
         2knvHOyVVwYsUFElTlGpzb1Sn8zAhuyijZz/GYjXdm5VfNrgGXVMH5zT3yotkYcPXnhE
         0+5Klo1AwyI/md+/bMhuKHTPjCq7g6aCMDSawwq8Fww+xthrRmVJiwZETajwLMLsX9Q/
         CkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753976715; x=1754581515;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ja/Or7TtQWbgvEBjUvVLczjO5A/ZgQzAqJjlnzQL2m4=;
        b=OohAmHxq7KmvK+iGZsHtIJwveRT1fs58pKbjLgr6E0+ObbAA5fsJ+/cBhHU1W86hU5
         wtVQTem3EBlXJ7G8801Jh/3xHz6yiQoEEx1DdjETEjOT2rcLooJYNIpQcOnnSlG2Neiw
         i1MKLBlCweeVKmUgUldFzd6VHwvBGkmOxSpKgLI5Or0clx4aNHXQu4VFkdcSnHa5KON3
         +XeRPwwJg/5Cz+VctTGqs5JgK9j5gFq7fnXnS9+Oi13mTtF5RDG9CuMtVvg8G+pGPRps
         kF1sJ+AR80St+YkqX3EzqqMwiVB+vQFpMZp1uyU88lO5PMxzDS+cykTCkd+y6mBTS0Hg
         KdpA==
X-Forwarded-Encrypted: i=1; AJvYcCVf+5VhbwBFbJu2eqnmHIun8u6ZqrDW9Fgng2dTx7olBfeQTAt9D3L66WBNu4fPIz9KK48yEHO2zE9r@vger.kernel.org
X-Gm-Message-State: AOJu0YzL9dTGfc7vI3GQy1hJMMhWlkeZF6kL2EOoE/Usf0P1YjdRQ2ii
	wbFNa1bo+OVMe0UvyaAU4RzwzHCnAQDW0x3LaThDQSVShWW8687JtBPwc8YYK2d3NJw=
X-Gm-Gg: ASbGncvacaMAswr+6MwqM6kkCZSj14fboL2Xjs72SVfE30PzV6FoN3ICR1zFpYcJocB
	6Q3sDsc5LVX5r/PXY2ODCyp/+CFsSxIU2NB8Ag2dN/rJGDDaWiphxrnvnAAFjX1J0CV7NILXMKw
	mL5828S5dwgAPsqXsC0Zyv6Vu9fbR/NOUbMPjNmK/s9hoFvjKXg8ChemFRTzo0YJvzkcbGgg7A+
	I9Pqufo+up3rjMDEMZEmwFgK6MsdD+nTfU6nrf17T+D+RcvOkyMiU3NoEvOkW1IU3ECalQa/aiO
	6oRCGyz6avl1h2u6Kct9N6RzSfPRn2byfcHQa9pbn91+C420rd1Z7CfF1xSreZTQg/Omjkh/csK
	Zg60GOQ0QtBU3yJ0fQYQXLSiwS/8=
X-Google-Smtp-Source: AGHT+IHhJG3LfxP6KYv87rmvm8BnH4eV9UZ3r9hVeSwsBncQIEv9CMsfvZuSXXuKKKjdvWf4dmJKKg==
X-Received: by 2002:a05:6000:188c:b0:3b7:9dde:2a8 with SMTP id ffacd0b85a97d-3b79dde085cmr2503864f8f.35.1753976714859;
        Thu, 31 Jul 2025 08:45:14 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453d6esm2803852f8f.37.2025.07.31.08.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 08:45:14 -0700 (PDT)
Date: Thu, 31 Jul 2025 18:45:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev,
	Salomon Dushimirimana <salomondush@google.com>, bvanassche@acm.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	James.Bottomley@hansenpartnership.com, kashyap.desai@broadcom.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	salomondush@google.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH v2] scsi: mpi3mr: Emit uevent on controller diagnostic
 fault
Message-ID: <ba460132-50b0-4b77-b12a-4b9097b93fd9@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717194025.3218107-1-salomondush@google.com>

Hi Salomon,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Salomon-Dushimirimana/scsi-mpi3mr-Emit-uevent-on-controller-diagnostic-fault/20250718-034234
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250717194025.3218107-1-salomondush%40google.com
patch subject: [PATCH v2] scsi: mpi3mr: Emit uevent on controller diagnostic fault
config: x86_64-randconfig-161-20250720 (https://download.01.org/0day-ci/archive/20250721/202507211423.eXWSnhP5-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202507211423.eXWSnhP5-lkp@intel.com/

New smatch warnings:
drivers/scsi/mpi3mr/mpi3mr_fw.c:1639 mpi3mr_fault_uevent_emit() error: uninitialized symbol 'env'.

vim +/env +1639 drivers/scsi/mpi3mr/mpi3mr_fw.c

8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1636  static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc, u16 reset_type,
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1637  	u16 reset_reason)
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1638  {
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17 @1639  	struct kobj_uevent_env *env __free(kfree);

This has to be initialized before we return

8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1640  
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1641  	if (reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT)
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1642  		return;

otherwise this is an uninitialized variable at this return.

8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1643  
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1644  	env = kzalloc(sizeof(*env), GFP_KERNEL);
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1645  	if (!env)
8fe63dbd42cc3b Salomon Dushimirimana 2025-07-17  1646  		return;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

