Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E5116F831
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723808827; cv=none; b=VBbeQCXwPcYx0zniwsSzkMx7QWorvTgImftkqYlksig4H18YtorCybx10GjwFkcvx/FZ2J37JADueJ9VvZppwrWOij3gXbfA0ovZVxh3osp3WMc3HxKfN/2uwsyaTzByCHWwdOR6mNJqcULNL+kHzMNs+m1CUwDXI8SsACVGSuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723808827; c=relaxed/simple;
	bh=BYNOuo7VdELGAZCeJracaEuuvIf7F0bO1297z3Jgw60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBHuH4mOfRkjyWIWGckoDVVZt0Zb9iqp6EbGkCGqvWkS9g2TEt3KmqyPn2b0j2xF/Jp7C1wsaszLMK5FUjesUXed2Jt3JnVG4A6qYkTWImSFSXxyInYDe9ZwmmOS34x7ORtAxBF3iNnDvUZraoeGC48hX73AZvMkElqBJZo556o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cbBjmOEz; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cbBjmOEz"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f189a2a7f8so18987211fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 04:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723808824; x=1724413624; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wV3f3tgXbZ6RS8PMVxuGaxCBTXr8Z51l89FQdcyx9OA=;
        b=cbBjmOEzsdagCdA7RgQgdfMCNfGkm1QlompTPTii/5qlUNEQD2VwZtitGDD5ml6UdD
         Dv0wndhGQUZ3IKb7KhsV/5j63j3hq4wdvDVxf/ltBoj0g/uRhTpOwLH3Lza27QvEVnRJ
         Be7dccccavnXAnMw1z0lykWuMsrmWY87Jp3O3wAwUjFoxfsHBHx2t5pZ3o3Sboo6ztDN
         ItOfTlORXy8qZ0LArXlliaNrlHGeZiUFTL5FE1lx0L14VouJW2t6lQCIpBALnAdmnm20
         gyaUYCX7AdUn+ZiblsonXeP/u9l3npO+55Xdhwt7uZUciKgYgDERnbbU5jM97jGZqkej
         0bUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723808824; x=1724413624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wV3f3tgXbZ6RS8PMVxuGaxCBTXr8Z51l89FQdcyx9OA=;
        b=LVINo+oyTi1wRf0N7EAuy7lc7ORfBJ2u7kRcdvXKQ8WtK7/n1sbpFVEN+mkvl2aL54
         57vKDhuqzVeNbRdXROmQACYqnUbmn2KnaeOs/sTOHJJwM5CMeUpwci4TFekYybKYFLsC
         4gYhsMJSQbq5uD518KjMPw075cOkxM7Qp0yn7c3MaFFcBl3BqJdENm4RqdLszl8xDqND
         GAeaHZje6edmzb+aGVgVQCAGLbDXIz49YQmTeaQg2rPswLHKE74Gw6iUdEbgCDtsxTP1
         qN7v6g2h3i5cvKZBPmXq8nT1xTJ14vqxWfqFMpDoy+1moOAXxattKHu17r1ATxc+JJpU
         pHZQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/NixgeXyRJxx8H+BQUmVhzbVnoWH6FI1NMmnEx0TzT2cYg5MWTLKBUO7baAlMT8KVL/+xWAuzBLmSAJmkV7gOZUcY/WeI26fveg==
X-Gm-Message-State: AOJu0YzUrpL0s588rq5l5xRvss3UuIrvLcjcS0hptHdOyVlTsHjHAv6F
	zSCsLFlaCdMX3vD36+Zvga0bcT545Fl0g26XzN6sNLTL0EYMNDkQPISYligtdBo=
X-Google-Smtp-Source: AGHT+IFsJvShCAzHPXv9NfhSPB7MlpUN8gvqY9PXC7ZNR3VQQoCvobHbpuluFO6/2tEVHSxFNSgARA==
X-Received: by 2002:a05:651c:2224:b0:2f1:6cb1:44c0 with SMTP id 38308e7fff4ca-2f3be577d8emr20100601fa.6.1723808823479;
        Fri, 16 Aug 2024 04:47:03 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371898aada4sm3446023f8f.94.2024.08.16.04.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 04:47:02 -0700 (PDT)
Date: Fri, 16 Aug 2024 14:46:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Brian Masney <bmasney@redhat.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: Signedness bug in
 ufshcd_parse_clock_info()
Message-ID: <cd5c2315-1d40-44db-a2d9-c4fd7ab3e7f4@stanley.mountain>
References: <404a4727-89c6-410b-9ece-301fa399d4db@stanley.mountain>
 <b613d16f-1167-456d-a5cd-807db875adb9@acm.org>
 <6beba3f4-dfa1-4871-829c-ed1e44b5bd39@stanley.mountain>
 <20240816063404.GH2331@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816063404.GH2331@thinkpad>

On Fri, Aug 16, 2024 at 12:04:04PM +0530, Manivannan Sadhasivam wrote:
> On Fri, Aug 16, 2024 at 12:35:22AM +0300, Dan Carpenter wrote:
> > On Thu, Aug 15, 2024 at 10:47:30AM -0700, Bart Van Assche wrote:
> > > On 8/15/24 4:24 AM, Dan Carpenter wrote:
> > > > The "sz" variable needs to be a signed type for the error handling to
> > > > work as intended.
> > > 
> > > What error handling are you referring to? I haven't found any code that
> > > assigns a negative value to 'sz' in ufshcd_parse_clock_info(). Did I
> > > perhaps overlook something?
> > > 
> > 
> > Rob's patch in linux-next.
> > 
> 
> It would've been helpful if you added 'next' in the patch subject prefix.
> 

I guess that would helped in this case.  But most of the time when I see this
question it's because there are two different upstream maintainers modifying the
same code...  Anyway, sure, I can change my script to add "next" to the subject
when the FIXES_COMMIT isn't in Linus's tree.

if [ "$FIXES_COMMIT" != "" ] ; then
    if ! git merge-base --is-ancestor $FIXES_COMMIT origin/master ; then
        TREE=" next"
    fi
fi

regards,
dan carpenter

