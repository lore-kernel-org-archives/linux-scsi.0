Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DC5376EA
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 05:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706593360; cv=none; b=pF2ys2WvWl0hLfmxFhAqvpWhasjlJZIw1Jblg3Qi7pB7sXuaftoqjFz0RQJBQIjVbSBvHXI8AoIGaI8/2rwdd4y10yKO6d1yUyC8R4zlkWHVN3fLQFdnzViAjBCC7SHsE8W1t3ILFtK+kWjC+QlHiYrtmuREf4iv8oGvs+tjYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706593360; c=relaxed/simple;
	bh=gNj8qIHubEkiZhyq4ZoFmK//jaqpllZV/Xcsy1eISt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LngBxl9HmuYC4XlSoOYWieyQw4cXMPsoNB7N6g69MPikZMoaZ5TpF9VqrcTfJInqAXu8YV+OkN6aOb1vo7ytZ/U1BWiQ2gZZBXjAqTb9PvKFisWMFXoE9iL/i50GRCwT7IMVCnR8rUdPPL2Nc2eCTXuWQo/fLDbC9P0sCG6Ggps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tMNwa+Sn; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tMNwa+Sn"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29065efa06fso2815255a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2024 21:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706593358; x=1707198158; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EaGh7h3BGqQZB3IHcQXh7OenR9j1kWQcR4glI4guQgk=;
        b=tMNwa+Sn0GnCCk9/4Qc+FRXFvXfOjGGiMsVrdSUpzulxPo6Y/FC25uRc/IQl3pKvlM
         22U0wPVqp4MdOemII7lw9sLOuUltcMl36oBHHRbUDzq3R0CQthXqXfmVKWCgw5mvNE8e
         RxCB+pkyC2m7Rrqzh4yo8sqOo6+4JoGrUwCwDksidqmRpL5rXPCvS8tAaZI/WMojKDws
         DQ+yftN72VMXcu98Q9m037YDyuAYY2Zg8QoIW5J5x+eoI+JTTGgNcjezddUqn0Zk8gd1
         b0ndqTMRL/olxAiUaNmYnGzPktVvH9GR4+f09fmqupm0pscWOqvzJj+3r4+TuRUoeDzf
         MAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706593358; x=1707198158;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EaGh7h3BGqQZB3IHcQXh7OenR9j1kWQcR4glI4guQgk=;
        b=mZHJ9W6wN5L59QWO0hIEoxMChxVy8/uBlMf/zuGyLWpmVEfSZlj2F6Q5GhedQd6e7D
         pzUiqLApDNXoBDbrlSoA/SCrx95frljm0MN/3yHeKZWLHM+BchHsfZDJbsnHmLa2mr6a
         y2Y1bA+6RVATvkn262n+mYmMvch4xUgTcibk2G3R6cGIhojSq8UWXD1kZLyYzhmcJC72
         GW7noV8Y85rPU/0IkyVHMLiFCjCxdpLZOrTv4ezgwlO/3LRHtcRAurXUwbjaE74Yt5XR
         jqq+RFjEWOUxYP0vlEg4LTZ0N/5qYWMn8bv3MhboK5X1lWxj8CSOWaq/xha0BdgGC3Ce
         PlNg==
X-Gm-Message-State: AOJu0Yx/69pc2VhwRdModTSWPzQ8d6Lio1fAvk6STdfAnqgCTSwqFoby
	PMOCBo3D2yXtFIxzsAOT3CpWP+VH1LBU2Ini2st3nujE/RlyPRTrJDlmeb++ac62YWaOyLr9/R0
	=
X-Google-Smtp-Source: AGHT+IGDWCuMGRFNMFSJzTY56VhwusGGUfj3M38AIIT43nX842A00uaHih5hNYmfU65ZCPxhfo0GQA==
X-Received: by 2002:a17:90a:eb07:b0:295:b6b5:302f with SMTP id j7-20020a17090aeb0700b00295b6b5302fmr271969pjz.45.1706593358200;
        Mon, 29 Jan 2024 21:42:38 -0800 (PST)
Received: from thinkpad ([117.202.188.6])
        by smtp.gmail.com with ESMTPSA id pq6-20020a17090b3d8600b00294eeb58e59sm6455101pjb.15.2024.01.29.21.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 21:42:37 -0800 (PST)
Date: Tue, 30 Jan 2024 11:12:24 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Andrew Halaney <ahalaney@redhat.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, Andy Gross <agross@kernel.org>,
	Andy Gross <andy.gross@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: qcom: Clarify the comment of core_reset
 property
Message-ID: <20240130054224.GA32821@thinkpad>
References: <20240129-ufs-core-reset-fix-v1-0-7ac628aa735f@linaro.org>
 <20240129-ufs-core-reset-fix-v1-2-7ac628aa735f@linaro.org>
 <hm2h3uniy75vkjlnk62k3y4bz44khrdwxlk47t3lndc6c3yd2x@sbwcuvrjar5n>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hm2h3uniy75vkjlnk62k3y4bz44khrdwxlk47t3lndc6c3yd2x@sbwcuvrjar5n>

On Mon, Jan 29, 2024 at 02:57:20PM -0600, Andrew Halaney wrote:
> On Mon, Jan 29, 2024 at 01:22:05PM +0530, Manivannan Sadhasivam wrote:
> > core_reset is not an optional property for the platforms supported in
> > upstream. Only for the non-upstreamed legacy platforms it is optional.
> > But somehow a few of the upstreamed platforms do not pass this property
> > by mistake.
> > 
> > So clarify the comment to make it clear that even though core_reset is
> > required, it is kept as optional to support the DTs that do not pass this
> > property.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  drivers/ufs/host/ufs-qcom.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index 39eef470f8fa..32760506dfeb 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -1027,7 +1027,11 @@ static int ufs_qcom_init(struct ufs_hba *hba)
> >  	host->hba = hba;
> >  	ufshcd_set_variant(hba, host);
> >  
> > -	/* Setup the optional reset control of HCI */
> > +	/*
> > +	 * Even though core_reset is required on all platforms, some DTs never
> > +	 * passed this property. So we have to keep it optional for supporting
> > +	 * them.
> > +	 */
> 
> Any desire to print a warning if !host->core_reset? I'll defer to
> Qualcomm to review since they can confirm the accuracy past Can's
> comment, but this looks good to me for what its worth.
> 

My only worry is that the existing users of the legacy DTs will get annoyed by
the warning. And I'm not sure if we can do that.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
