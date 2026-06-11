Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0625333F
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781195892; cv=none; b=c89bEqzjmbjwujQG49gFs+J2g0BVMCMIAnQQT5oFO9Fpnw/dyhAe6G9k4SQlFwDYQIpwxCnn4hNJqlyq4N+SZg939/Gy5SuMwISkeZHQU6PpZrAsyK93SAy1Ge3HG+acAkYS6K+BQ3nW8L848Ekovipby3+DTu0RceM7pOpZOjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781195892; c=relaxed/simple;
	bh=eijCJIWCzE7dOaaMhC6ytwZ56c0ngQs/vO7TF7uckw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ue3uaEHhk73mEH1Xd+hpLTOs7FvZKmxpC1RqrLnioRniKgBrFRkP8kTkJm6ZhihHg3BLXUZA1znamzH40gdP0p2adR8CAeSdn8tAtojMhYiHM3/oiIRXO2AaSWyw+7E5xMQWxiEJC6M32Iz2jdMic3XpxRyhDaU2E3o4m7v+Ow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4WJaeE6; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4WJaeE6"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490afc47455so43913665e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 09:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781195889; x=1781800689; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/slxkBaga7WdFYUIk+bpf71i1yduik1uqRPXNyL7qIk=;
        b=b4WJaeE6pdENyvdjptJtoSyd6Lmr08PZTlPH8VYoRNetEVFqxAUuviMFCJHXdNjUJF
         4JbtiVnkdAumsYLd5RjqE0ekopAvlYvzaJARHjuJB1TNk9NMFO0AzJP0e4syIvYE35Pv
         yCarcKe9bqDLhJQ7wnbCYBg2anRxJcxg0UxCfBEFrgKIKMVnYiESguzniNEykK1MprOB
         VVtHoqqD+A5KRlt71ynUCQFPqUWWXKHKvHJ04F+NAqa/BOJhLyKuRuLjFdIu7gtzWOjH
         DSqGcoV+VyPUKyoR/1asmxBW68Fm69chXCNDdovENvF27//1R0BqW4+l4x/a0xIIIUDd
         Td6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781195889; x=1781800689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/slxkBaga7WdFYUIk+bpf71i1yduik1uqRPXNyL7qIk=;
        b=V7ip0VAFu+UmAaHmqbY+j6U2KxfsLU8Da3ZqzBlUyf/gSvHwQcLk2syaL8gbUD+4rH
         KHV0bH3SNHhpax1uTsZFes3uVeIzVMRfzVHCZ7z27/PJEH12uTRw2wwbhoIcFi69klDx
         tBGKateAE/J4qjnEMsrXwuDq8vEGrPEksXLLVfMi+Jw0iqLDq8H9SsflcYcTHJKnfpEe
         FoGsuEGCOiuOpjI57H925ZOn2VikA7R3TK1Kk3USZ5xaQBld3Duvr1YfJwINTbZSAPYf
         Ugza4/+fdixcEtkIpiIeagdnuUIBBuwx7pKicz+Z6ue2ggroAQWHKx33KEgfeeUyeluY
         3/pQ==
X-Forwarded-Encrypted: i=1; AFNElJ/OpO81wRb9U9T1oKncPM31sph9juQUawWjvkjRlfIOForYkZgqzCCw10DU/umgCOMNJ81j8t3JwSRp@vger.kernel.org
X-Gm-Message-State: AOJu0YyFMtPAsMi4Z9AezqqzZKAHYW35lIgDHUKJbPBRzASVmclMs68B
	9w0kqR4rp3Lteh+DSUA0T3UCmsSRPPtpqotruiGdTdp60lumIz6BzLVD
X-Gm-Gg: Acq92OF3h1ZZ11mEilE+nK0xQv1vY01uqbGpE6bzQdJzvlYJtvsU4dEvsA/l2TTctmV
	AldqzVPK5xtxhuBPfPX+a4DMV16XjK29hv0awvHMOIYfs0yFk9qcKSldEH9A3HldATCjDsSwAPS
	VVuc0qXjHlzfz3jXjKdNpe0kqC8BRLcF66mpUnzhdCrY273e75LA4I92l0Y+gy+F5XrFB4HWQ/Y
	/4YPDEbPkN6x0AhQWlmaA27g851i+KzsFEONbTAE4iQaehTiXGNPxnKfF10jEfJr9St28Ezhag2
	+HwXHB+6gb9Jj9EFi4/7xGEuVnUoLH9fkqiIVU+zhXc3m5suXnM9AQXBuXCev8RSNMzNTNGcsLx
	vLrwkI0XmpirHlskiBP6Ss7N0UeJ+Hk3n3cO8XkV8ZoAM+K2C+E7Bz/s8j2hV8tX0SRodCvwqyU
	OO1h2j3g==
X-Received: by 2002:a05:600c:8b51:b0:490:e5c1:b8b9 with SMTP id 5b1f17b1804b1-490e5d0ff6dmr48188685e9.0.1781195889065;
        Thu, 11 Jun 2026 09:38:09 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea4a4db2sm266015e9.1.2026.06.11.09.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 09:38:08 -0700 (PDT)
Date: Thu, 11 Jun 2026 18:38:06 +0200
From: Louis Sautier <sautier.louis@gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND 1/2] scsi: mpt3sas: add IO Unit Page 7 config
 accessor
Message-ID: <airkbg8-kDC0Gyv9@localhost>
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-2-sautier.louis@gmail.com>
 <5effba66-0d42-4d42-9833-f2c0be6874ad@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5effba66-0d42-4d42-9833-f2c0be6874ad@kernel.org>

On Wed, 10 Jun 2026 08:12:05 +0800, Damien Le Moal wrote:
> > +int
> > +mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
> 
> Please do not break the line after "int"

Hi and thanks for the review.

Sure, I can change this. Can you confirm we want to diverge from the
convention used by neighbouring functions such as
mpt3sas_config_get_iounit_pg8?

> > +	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage7_t *config_page)
> > +{
> > +	Mpi2ConfigRequest_t mpi_request;
> > +	int r;
> > +
> > +	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
> > +	mpi_request.Function = MPI2_FUNCTION_CONFIG;
> > +	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
> > +	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_IO_UNIT;
> > +	mpi_request.Header.PageNumber = 7;
> > +	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE7_PAGEVERSION;
> > +	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
> > +	r = _config_request(ioc, &mpi_request, mpi_reply,
> > +	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
> 
> 	r = _config_request(ioc, &mpi_request, mpi_reply,
> 			    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
> 
> is a lot nicer to read.

Do I also align the signature like so in both the source file and the
header?

int mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
				  Mpi2ConfigReply_t *mpi_reply,
				  Mpi2IOUnitPage7_t *config_page)
