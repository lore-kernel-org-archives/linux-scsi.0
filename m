Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E659384E07
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755114478; cv=none; b=dJON0PdRQn6iordpH5d4Rf6FVc2oH05zR4DX2YZ0d71FCAKdMjRXqaJ71fHfGjbUqUZEm10JmsZ7g56+Znrsss6T+uTOCbmBmdt9WTA69n9750WSioEpzEj/PHEgB40grGkC9zSj02QHrZL3X6brMGjpEyxKU/nOH9RRxMsSdtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755114478; c=relaxed/simple;
	bh=biCGeTNU05g2cRP07gU43PnP4jxoViPjKhIM6BtXvtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LY0Ski4UUokuvv3q9BTzIq6ej9AiYFs8IKedF+pEq7HHAgcnMBCforkPgLJRopL3eiFHfJHkkEZp2RXIAlbKNZTFolqCR5s4fZc9dxbJ/lGkBX8whTy+DeZEKvg8pnNhJmLXIC2XGGqhxKqq3OUOiWnEAXsls+gI2xQxewMIGi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5lBGrtL; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5lBGrtL"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-242d1e9c6b4so48625ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 12:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755114476; x=1755719276; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xBg4UmmL97S2eLUF9C9FLmoCQfiCeqgmw2ydp8gYJl4=;
        b=e5lBGrtLGcQD4a3+SuTA+XzIacVlkt/hIgvYmxjVsCjfBj6jLAOCsPHRGXmnzq9Xx3
         CtNNu/iqEGuAFbEfvSGLOQ8N403hEM9RdyI55jYf2G+U3m+muaUDHJQeV+2NFH/BYGpp
         eRRw1E7WHLhv8tDSIA7l+qziQ95omNzBMKX2ixKAqiNFFO3lgmP85n8pIwXFKRwVnBNM
         lBUEShKUwnHFNX4uUiJqPyWDmThi42T4CW/90+vwP5IK5uOd7EvWF7OdBwg+c0/lsspM
         2Nn4cTnWghoYbA39IR/EJXHL6mPYCgJSjgnH1vd9eqLDjnp3a5CSVjuI9Z+gn3eAaiuW
         Rg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755114476; x=1755719276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBg4UmmL97S2eLUF9C9FLmoCQfiCeqgmw2ydp8gYJl4=;
        b=cP6PJxn+sIef4cK8PqToVMdPN0hqA4pFM46RJuZrt65lxirpbCY8Db9PcMBNBZOztJ
         40UtvMa6ns4XmeLmoy/kOwh9DPoRyr0OVc2abo4Ez+Ze++GIyk39h9dElb0kSlj/1Brz
         vGydAQshsZooc6BuTCUhs5RMVqsOdSyGESiqGMlwzAcjJJ9mqYfBL2I/KoG5Zqm9XRoX
         KyfKKr53Ix6BjO/YB42vHAAV6B1SyZIzTHkZSf3KeZjwtNiujbgjCcoxjgqsk7iujQ+2
         5QyYfpK8T9kOo4MUJjdUD8fQHRamNPLm5X/6ZGT2ldhStv6+PetLY2UtWV6if6qfG0Ta
         aQ4g==
X-Forwarded-Encrypted: i=1; AJvYcCXSASr00nZ3wKVpdWs7X4JjuCjFdtdWjUwJ5NPjGh4IKkVvEU++jGbFvsnH1rnv7LPI4hYtyMjOil4I@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk3FDFdhor0lF/1HrkCMa5rttyPaJUZXa2w6EhkgzFqF6DrM7V
	FSfsK2Ve4910qcUH3gGX1AW81DWzTRCZEFSDeSGWyEjrUfaX7N26mchSYYEPHIPp3g==
X-Gm-Gg: ASbGncsDJgdefFx06Ny+qCMkuuw6JIxJPDh0jHTl6fLcAUBuvyyFpTVWk1RnbMRcziP
	YRRs3qjJ2TfuhOcpKLANfmFGMdRpWvy0RuEC28QXFwnh8MkF/AN8laMuZYv6rWPMZsq/nw8uNz0
	yWwYZxHgYoaWkVNV00v5ahdUp8HIdMF5HnfPJ2Fs2dmGjNdi6V7bo69z4jixB9DiyHD/H42sUoq
	/7i+4LssvtWMku3s3gvOHxxWFAQUHqejPGQnTPVyl1Mk3TcEdNNvJG362cmeHsmifImfr7EtrUI
	kD/8BzKJWfXcqNzdVF5P4VH2DItABOyF59ua1QfPbi4Y1ZU4/FhmxLRBDBjQXvGo1WNw5LN0QNS
	EbuwIZG/ePtTI0t9/qe1gNk6HGfzhFrjA55VEY8iorrminX7SHvMkJVDKeQ==
X-Google-Smtp-Source: AGHT+IHuy1/MNe/FjV/SdZ3KvW2f6XrxOQxy/bS4HFXEvibPRY8FMAvoATb0joOfN2sVkeCC9cOIaA==
X-Received: by 2002:a17:903:bd4:b0:244:503e:62d with SMTP id d9443c01a7336-244597fa4b1mr14665ad.19.1755114475936;
        Wed, 13 Aug 2025 12:47:55 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aafb34sm331560945ad.173.2025.08.13.12.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 12:47:55 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:47:51 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Viswas G <Viswas.G@microsemi.com>,
	Deepak Ukey <deepak.ukey@microsemi.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jack Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5] scsi: pm80xx: Fix pm8001_abort_task() for chip_8006
 when using an expander
Message-ID: <aJzr5yotHWw1jPq2@google.com>
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813114107.916919-11-cassel@kernel.org>

On Wed, Aug 13, 2025 at 01:41:11PM +0200, Niklas Cassel wrote:
> For a direct attached device, attached_phy contains the local phy id.
> For a device behind an expander, attached_phy contains the remote phy id,
> not the local phy id.
> 
> The pm8001_ha->phy array only contains the phys of the HBA.
> It does not contain the phys of the expander.
> 
> Thus, you cannot use attached_phy to index the pm8001_ha->phy array,
> without first verifying that the device is directly attached.
> 
> Use the pm80xx_get_local_phy_id() helper to make sure that we use the
> local phy id to index the array, regardless if the device is directly
> attached or not.
> 
> Fixes: 869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
