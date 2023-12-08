Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33C22308
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sEmmsggf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86110C433C8;
	Fri,  8 Dec 2023 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702055184;
	bh=mxdO+AgZgxQrWokleW50XZOg/gCxBMjkuHhRTUdEc5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sEmmsggfNl/uihEtJRxzo6AOd3cu/tKmCNiECPZP8J3nTetJtO4rgrUJ/gabq4bgh
	 6EiL1i+W6/pFlCfpM2ktnrMaC4iBA6rBKJfKk7R9g3lsAorl1x2yzyrzZrWJXZfStM
	 rXanj2EgFeEqyKBb/VzQ7n5Md6Yby6VVBs/PajvHPRdxHOFNFnejMS4mY7W25Rx2JZ
	 6EWUshyUL5eV9KnyjyzGrtW21Gl+jOHoABb32yunQbM4SJ7H6Kw2Kpp+9CKpqfoJ6P
	 16PDdg/GGRmnijiS0z8ez/sc4fUt4IHyQI6WRn2ZvS8qHYl7jNXvuHaXn+d3655XBg
	 G5ftfY37XvCOw==
Date: Fri, 8 Dec 2023 22:36:09 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
	beanhuo@micron.com, thomas@t-8ch.de, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, mikebi@micron.com, lporzio@micron.com
Subject: Re: [PATCH v4 2/3] scsi: ufs: core: Add UFS RTC support
Message-ID: <20231208170609.GD15552@thinkpad>
References: <20231208103940.153734-1-beanhuo@iokpp.de>
 <20231208103940.153734-3-beanhuo@iokpp.de>
 <20231208145021.GC15552@thinkpad>
 <89c02f8b999a90329f2125380ad2d984767d25ae.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89c02f8b999a90329f2125380ad2d984767d25ae.camel@iokpp.de>

On Fri, Dec 08, 2023 at 04:12:44PM +0100, Bean Huo wrote:
> On Fri, 2023-12-08 at 20:20 +0530, Manivannan Sadhasivam wrote:
> > > +        */
> > > +       val = ts64.tv_sec - hba->dev_info.rtc_time_baseline;
> > > +
> > 
> > This logic will work if the host has RTC. But if there is no RTC,
> > then tv_sec
> > will return time elapsed since boot. The spec clearly states that
> > host should
> > use absolute mode if it has RTC and relative otherwise.
> > 
> > Maybe you should add a logic to detect whether RTC is present or not
> > and
> > override the mode in device?
> 
> Thank you for your reviews. I will incorporate the suggested changes
> into the patch, addressing all comments except for the RTC mode switch.
> The proposal is to perform the RTC mode switch during UFS provisioning,
> not at runtime in the UFS online phase. This approach ensures that the
> UFS configuration is populated based on the RTC configuration
> established during provisioning. It is advisable not to change the RTC
> mode after provisioning is complete. Additionally, the usage of tv_sec,
> which returns time elapsed since boot, suggests that there is no issue
> with utilizing the RTC in this context.

Except that the warning will be issued to users after each 10s for 40 years.
Atleast get rid of that.

- Mani

> 
> Kind regards,
> Bean

-- 
மணிவண்ணன் சதாசிவம்
