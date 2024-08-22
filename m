Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02256139D09
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308622; cv=none; b=pMxG3vux7C8a2ckgB1jB8DvKX1bIt7iH4UDSNg/MPBGpnQojuBS+RsAHJJobjaCI+Any7l8hhVxK0wV3UPDJ9HzKFCRndi5VxG5sEtyTJJjnGirIqey2r5RXTo5MpNvgwPr8QrO8eWrL8juAWnw1lypXzkq1A3h5QU38LUspDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308622; c=relaxed/simple;
	bh=oGOHTDY51Gg+mJcTm2seW0ElhhYl+OMH4epVMewAGj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVtQ+VZeyvQ5vzsMxzwSE/uzUvehHh+8aXK+rCkHtQ2/SGknnHmKvoaV0+9FJdBsFvTL9A+OOF3GxG6WzQGCaU4OxAmtXoCFvl5ie47yUn7w4/GN2jDUDGl8J823HvccEZPHpBzv3O6mJ+TNxHgndeQ/cPT/mfnxzUod2gcVonM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FWXxEpq6; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWXxEpq6"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-712603f7ba5so413140b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 23:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724308620; x=1724913420; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TJG2Lofxymap9hQg3cIGyOFlmJAgxmYranBHj8oOVvw=;
        b=FWXxEpq63693YWQg53N5qvzqM73/RMIFFsVq8ia/t7/11t0GE9Wy441SpU2TmUD0gH
         2tL7MbLmkVxlFfgGyLVEgSCvemaoz3xZO0nTdgsIEWFLyBuYd+mCecoJagR15PnoYg/o
         6eTTElx32t4CA3/wThyzlXHhwcGHCF8tkyiuK7Oq49E5AN3UI819H2W2KEJO0XHkncxg
         D2G2EQaBpd6xPT0kh2nUJSlAlFppqSA2PDAZbOdP3cdHK4nyW2ozFG52WtLWWIt+oDmD
         a138B5M8pM03AJenf/cN+rxeKq6O5+eYbPkc187HcDFAY6LSaxA5YbNYLRVjXSfa5hUB
         9uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724308620; x=1724913420;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TJG2Lofxymap9hQg3cIGyOFlmJAgxmYranBHj8oOVvw=;
        b=csoNeB1eZ5pEvz0ZS4lnYDTm/4jd5koSFs58aRxTkLoIdVmq+y3vfDEg5B+/BZumE+
         YRuuQG6h8gfQROOAPAii0sg/uw4v+aFt8DK+X0Mu3fuH6RpOgeACvCA0U8uejsJoZEuK
         FTIygds3vSkzi/d+d91tgiMhydehIaMiOUtFNknsbm5ldooHoZfXGbCqWoUpUy1gS9EZ
         TrHrbq++2Oy7UqDfThwtel0ChtcT+4EE6PgCcJTbGXr1XnaJWiupsWb6sM2fy7CTmtvH
         tghRWpsvRg3cOHLcO4pym8TD7GxeVFZv88BRFz7WCuBbziyqqVD343QFHjBXTJkIzLAY
         SlnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlGgqSAxNeH6daVWtriQiFVWzCLzvDssVIFYqAdfn0R7pWHKqLtrLTZjJEKrNyM7kHcov5WNZI2FTf@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9VXx2eW5ZWbzpzADLGd+lfdEQIj6EyI5zNBmEvqItSUQ4kdH/
	cENADyWw/08ZSobLoDeSf3CDJfW7HP7byKq150DJAPSeQt0Gb9se
X-Google-Smtp-Source: AGHT+IFmAMEGZb1Ey2xb06+L/fRqbmgqXkL4cswU065jMuisGH2bz3GdkOJuOd4kb2D//6ZgE99ZCw==
X-Received: by 2002:a05:6a00:91c1:b0:706:34f3:7b60 with SMTP id d2e1a72fcca58-71423557c38mr4636071b3a.23.1724308620184;
        Wed, 21 Aug 2024 23:37:00 -0700 (PDT)
Received: from thinkpad ([117.213.99.42])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434336fb3sm675489b3a.201.2024.08.21.23.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 23:36:59 -0700 (PDT)
Date: Thu, 22 Aug 2024 12:06:52 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Message-ID: <20240822063652.luevaztzhvzb2ztz@thinkpad>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>

On Wed, Aug 21, 2024 at 05:14:52PM -0700, Bart Van Assche wrote:
> On 8/21/24 4:26 PM, Bao D. Nguyen wrote:
> > On 8/21/2024 11:29 AM, Bart Van Assche wrote:
> > > Accessing a host controller register after the host controller has
> > > entered the hibernation state may cause the host controller to exit the
> > > hibernation state. Hence rework the hibernation entry code such that it
> > > does not modify the interrupt enabled status. Bart,
> >
> > I am not clear on the offending condition, particularly the term
> > "hibernation" used in this context. In the function
> > ufshcd_uic_pwr_ctrl() where you are making the change, the host
> > controller is fully active at this point, right?
> > Please help me clarify the issue.
> 
> Hi Bao,
> 
> Isn't "hibernation" terminology that comes from the M-PHY standard?

Yeah, it creates confusion between OS hibernation and M-PHY hibernation. Maybe
saying 'link hibernation' would avoid this.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
