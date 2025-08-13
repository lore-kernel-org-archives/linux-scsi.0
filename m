Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBB2F999C
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755114231; cv=none; b=Oc1GTl6Y6wUdwLtDH9oWxDCPP0ygUDvwqOgGl0Dsd2j2czrMIW5lzsAe8MXEYqWdNssTeXbsGeF9tQQO0GT4juVR15JlzOpW3oA0akdXFfZA0N+YVEykkYsetxW00exogbmaws+GS1EjyUYHsZM/5QZWB4YAK2Uy6ol4VZGrga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755114231; c=relaxed/simple;
	bh=kv6pvFsoxvATpLPiM/0WRf2tP2zrhAFOPGkQkxNh4Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbnZ/ZdC3aZ6UP4wJ3JxXe/569O1UZqj8PgFAn+uGx6eneBtatQU5ZnMM7zNxM7Iozp3I+rV6PiFcV3egRR92TXZIWX6Q5YxGx54XCJu36YJp2+8hsA+Pg25L/HwQpgrcaFaMmwFA3uvkwul3JezfilMC3qPxdfomzH7JAZgkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t1Tkm8k/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t1Tkm8k/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-242d1e947feso44495ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 12:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755114229; x=1755719029; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGtB4xkc26vxiq0bnC/o5b6x7zEi/ITG5buU9/+EP7M=;
        b=t1Tkm8k/gh6oAECdeQyyQpQUvsIDqMRXmYpy5nMth1CwCLarE/5/6MpvbPLxWkvdNp
         S7kkDpcyKeQd500yvCaPG+eUUoCniCsbDleW2fsdrRoP7m/VaskWpd6+YvIPQa1qf/9B
         BhnAHgfUW/QRdvs0OUv5mazj95Pdets0q17wEWvLUI/DyNAaVdjE8RcgIumLp2ZlBKLG
         r7xSTtKnt3OEbFoI6Z6r+S8PEbC+2+seSnHrHA+2tSClAMrN665YKq0deSIRmmcuE0u0
         aGGk8qq4abZbzPJmzeeorKbKZ/POoL4E1wxxRvK96E1Nfz6F/4/gfooiR8oWr4iwHWKR
         IDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755114229; x=1755719029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGtB4xkc26vxiq0bnC/o5b6x7zEi/ITG5buU9/+EP7M=;
        b=KHfX3KHmWHLTsTeOes0D4cpZRvRuwq3qRlRo/IlAyMgTOEv6PyCll0cspivXWMKyiO
         b9Mu0XW0z4PsgZZKBx5D+xGa/Pq/xW/pNar1xPq9ZO7GY55G6VYtQ0Axk4QxGmU1FugM
         c4XRXg3/n0kSyw/0hmFPHtMzKDzbG9kAoE+GUQL/gbMqxsZ+ny635k7+Sa59bJ/nRiyZ
         yJKRbH/JaDUIUV0jibn0KQPeY/RfCM8WmAMUVxEoUfUGT2LF0tF8nSFNsMUOdEjKVWhq
         Kv8EeTJDLNf7hOy75f/gh1E0i+i4rLIKVyrqKa3vO5QSywvQS0Qlb/LNlIgLidNW9UBg
         gzEw==
X-Forwarded-Encrypted: i=1; AJvYcCWQqWjEJcx5vXH8kaxFAb5SL4a2StoEwZMVBOV2hHfkSRDDTAQg9rXZc3tQ2vfMSxCET7sc5w1RmFCR@vger.kernel.org
X-Gm-Message-State: AOJu0Yz65BURoN+NFzSTKlfd5Ms8YSwzdRUCXmacdNd+MD1b0Qlq/70K
	Z6aCdbhGWPZdklE31p6Q8mlE17P8Hhkt296lSca4mXlJh2bKOgwEQI2cqVS/hWG36w==
X-Gm-Gg: ASbGncu0rW2+2HR8ZHGlqYPWz9Wlt7k2ZrqWZDxFw4sphaqz4W7gnaErdq0U0QM8csl
	ndxBllZzK9YOMb2JkAmuCWproiqWita6TiAccDyJQtnF9ziisC37G3WgPH/HkZJ94PDHNqHnqur
	AycOESqp2LYL6JsIm4mIkdSUjxa1w5lgQTyaQ5lvD3roh72uO8kSGIsSv0WoGUFWcj/Witp+ujO
	TsTCgWcnZGLsysNLzgoaB/NaFgTYSauKcVsne9BMm/s0pAyLcg97wO4S7VCE/370FapydT0V0nQ
	WWBH5fXrklx6MxBnkdD80u09U2uGFTZBB2nX0lcH8ln/237ctFL36fJTgEC6cohcDbZ6u0kHHg/
	VRm/rjJ7PesiLWADFgQyjrV8xshSHDkAtLUgn3FGm3jna7gGZw0w6T50AsVXWoo4ZifYp
X-Google-Smtp-Source: AGHT+IHaJaGXVc2lpUliu2har9V9FpGePlPwyEmlzmasPom0eK5IqZCjE/RgZAxZ2n9Dv6XGTQ2u6g==
X-Received: by 2002:a17:902:ce12:b0:231:ddc9:7b82 with SMTP id d9443c01a7336-24458e22c60mr206085ad.13.1755114228644;
        Wed, 13 Aug 2025 12:43:48 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-243086849b3sm41140275ad.175.2025.08.13.12.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 12:43:47 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:43:42 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/5] scsi: pm80xx: Fix array-index-out-of-of-bounds on
 rmmod
Message-ID: <aJzq7t3nFoFVAQQT@google.com>
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-9-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813114107.916919-9-cassel@kernel.org>

On Wed, Aug 13, 2025 at 01:41:09PM +0200, Niklas Cassel wrote:
> Since commit f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when
> device is gone") UBSAN reports:
>   UBSAN: array-index-out-of-bounds in drivers/scsi/pm8001/pm8001_sas.c:786:17
>   index 28 is out of range for type 'pm8001_phy [16]'
> on rmmod when using an expander.
> 
> For a direct attached device, attached_phy contains the local phy id.
> For a device behind an expander, attached_phy contains the remote phy id,
> not the local phy id.
> 
> I.e. while pm8001_ha will have pm8001_ha->chip->n_phy local phys, for a
> device behind an expander, attached_phy can be much larger than
> pm8001_ha->chip->n_phy (depending on the amount of phys of the expander).
> 
> E.g. on my system pm8001_ha has 8 phys with phy ids 0-7.
> One of the ports has an expander connected.
> The expander has 31 phys with phy ids 0-30.
> 
> The pm8001_ha->phy array only contains the phys of the HBA.
> It does not contain the phys of the expander.
> Thus, it is wrong to use attached_phy to index the pm8001_ha->phy array
> for a device behind an expander.
> 
> Thus, we can only clear phy_attached for devices that are directly
> attached.
> 
> Fixes: f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when device is gone")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
