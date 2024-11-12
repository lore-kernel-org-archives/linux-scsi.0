Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9E11EBFFD
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2024 06:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731393845; cv=none; b=WwG0Hmc37apWYgG6B82AN3GNIA1PChfZGV+OCY/4Z4PltmM2wiwyPxvZZDBa/uD1KfeF6zY/wwT3WPvqZ5Hkq3OOJ/X2cWLNylZ8EEE7jDZvaoTv1X2UFilOgpUG9pebtCXQDyaWIF3cvqGOR7y08TCjdOp92cqMy/4O9SasAAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731393845; c=relaxed/simple;
	bh=FY6WFOJXqCfbzedEEbqnXaBCPjvQ/+RzjiOySYoM/Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1rZm7nWOEueC/hNfiKHM8jFTSJeCSkr9IAmme5AaDHPwfo58DaZVYErY47xyGVljWYhgjLSloqL1YzsEnZoJLiiSkLSgCZJid3zkG2C1seFAlTHLD9q1fAdGlibkCAdfYJ29s0eFnO6bp1hANr8wzPAvoSq4wbdw7XapiT5sFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NSlZdqE7; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NSlZdqE7"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7ee6edc47abso3520965a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2024 22:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731393843; x=1731998643; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JPlc0iWn23rPv1Yelqqb+UADsrKyk5eLdXjS43qvnhE=;
        b=NSlZdqE7owQlczD41Q00zD6PwMCU+CZ5tWA8IoplXkNgDsmgv3AW7bgXJDhHzPM5iL
         PgcmtnDRzO+ZrC9uR2jV2BdXJ8KfKkFwAbe+LJkQ5XSPOIG+yX4ACoDproJ/wFr9HDr5
         ez0EQDg0Tjr9g4TBL0yonNTBUjTygatx0/aeEWtSVsS8VGXrzJy/53XSwUJ2LQespSy4
         gDyaffp15tE5lgjwbpJIPnUAY/aBRRwI9VduLsCOQMt1vM+/giSWUCn3V2BQzp5b/wRv
         /+0MPIr3yfsvXSEGAFONLMKEPgBS9woB76ZK35rbfvth1z8qYFN65FTH0QmavhYs3Qm2
         Uevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731393843; x=1731998643;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPlc0iWn23rPv1Yelqqb+UADsrKyk5eLdXjS43qvnhE=;
        b=q9DNEKtS/20gJPbJwWTv0Lp5SQBLi1EJzU/qP4I3R9U4VLbiXba5JAPRTiHxasaAPO
         LbkZSnFGbDS7m1cYZ2hJNxd2/CM01Af6ZD+nAjybb+019m3xnR5bdRyHorqohxq/H/dB
         PLB6fV/r9piXD1CNKax1GLyumcIT8oa5u/tT4VuP5y5nJDgb+5ngGXJZKwv7MmwuefkS
         kz9ibmJ5fEB5hgVeWp+Ow2h/KJHyBM99eE5p/wAkh9mAKkRfLq2CNP77xbSX6zoaC0iz
         pkUxHE58l50hVPx6e1lw0gp8i0KAfs4FZ2zfqKrw1Y7/p5vNjGri91BBo/pY1tikwt1d
         HOvA==
X-Forwarded-Encrypted: i=1; AJvYcCUKwj3pG0EaOi2zPcGbSQHTe/1qcF90hv3CgPwZzTOlZn0yiNIpbcw0ArbcGBMp/nPLlYfPExmxhP1F@vger.kernel.org
X-Gm-Message-State: AOJu0YxNjtc4CRI0LKu3wVBl2cvyVqccR9mZVYs9yjyEgBhb/ALnCbGY
	f4AoUyqmdzzW8WMmO6ThUArLYpmlPz9idfP15/0xRlWfYEN26tTwZCBHPq6IAg==
X-Google-Smtp-Source: AGHT+IFK7EbTW8j6RbaesACTxS+4wyWWBFBogZmLwWGxzhBM+sg2NEDsPKsDx80UIoPC1dThJW6KHg==
X-Received: by 2002:a05:6a20:2d1f:b0:1db:e90a:6b24 with SMTP id adf61e73a8af0-1dc22985104mr21818819637.25.1731393843104;
        Mon, 11 Nov 2024 22:44:03 -0800 (PST)
Received: from thinkpad ([117.213.103.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7240799bb78sm10282483b3a.95.2024.11.11.22.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 22:44:02 -0800 (PST)
Date: Tue, 12 Nov 2024 12:13:54 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 7/7] scsi: ufs: rockchip: initial support for UFS
Message-ID: <20241112064354.g634ca5w2gagfyko@thinkpad>
References: <1730705521-23081-1-git-send-email-shawn.lin@rock-chips.com>
 <1730705521-23081-8-git-send-email-shawn.lin@rock-chips.com>
 <20241109121249.vncqbacvpnpf6d34@thinkpad>
 <13ad21bb-9f5a-4a4b-8b65-55243f6fe817@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13ad21bb-9f5a-4a4b-8b65-55243f6fe817@rock-chips.com>

On Mon, Nov 11, 2024 at 09:10:39AM +0800, Shawn Lin wrote:

[...]

> > > +static void ufs_rockchip_remove(struct platform_device *pdev)
> > > +{
> > > +	struct ufs_hba *hba = platform_get_drvdata(pdev);
> > > +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> > > +
> > > +	pm_runtime_forbid(&pdev->dev);
> > > +	pm_runtime_get_noresume(&pdev->dev);
> > 
> > Why do you need these? You are not incrementing the refcount in probe() and
> > there is no auto PM involved.
> 
> Oh, it was a leftover from former version I haven't noticed. Will
> remove.
> 

I've sent a series [1] that addresses the runtime PM issues. Could you please
give it a try and give your tested-by maybe?

- Mani

[1] https://lore.kernel.org/linux-scsi/20241111-ufs_bug_fix-v1-0-45ad8b62f02e@linaro.org/

-- 
மணிவண்ணன் சதாசிவம்
