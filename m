Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7FC37F01A;
	Thu, 17 Sep 2026 01:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789610153; cv=none; b=o3/frggJ9u/J1QHj/cbzeUwUdsdChMW3qyQrEMf2IBCjWPW3arO3WJW/UaathL+O1NGxP2BW5WGRPHgFef1R37wHHrIh96jEj5Sbfdx+/dTkKqBOCrBWOK2QZzqiUS8gPFZUhTaAUIjDXkNvMhn8+r1999B/f9uz+15qAR6NDeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789610153; c=relaxed/simple;
	bh=leY8wMGkTfutZn5wiWzZQCJuYU1YPT6drrc823ch9VI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=TIRH4LVvHuFP9LHgHR0TnTAEusqcUUzEMRW7l2r+cknyuVIOFZLsdIAQ1gv6AL5Kq9A99akAjJDbluhniPZLwg7gsKceYCe58fpRqoJEZdjuqoYQ8ef9Uwnyq8AxwRQiU5IOvClgebDjkkVobFG1gCyODu6R9DThYPrBfbDzcR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGSeA4hB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGSeA4hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30EB1F000FF;
	Thu, 17 Sep 2026 01:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789610152;
	bh=GEzggXJFz3MfgaB6UJ3OZqGbLL+FDfTZb4lg+3S2JQs=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=HGSeA4hBoHcTLyjeeZF8hNj0aUtpiu8QavqzySY4L8zYaWbwscqlnHnH/nnyh5E37
	 6PoLhkU+NUpmyAMeR351E787HggYt8Z6D/TnN49erg8CHyDVAao+qVqnj6a6VhBMgt
	 dxwquxGuGr/gRHMpnuWnB5tAPZyV76x4PvqoQpkf1IV151QtGEb//vL3f9aJ1uKmRV
	 z3VfpDQl+8HzzWeTmCtArOdNHWbyFflYre4NniENEPRLiE2si2hnHMUvOEz61XoHzI
	 /cnkcYqcjbIQKRF35Ex7G3NfmF+7rE+7JH9sT6Bdu6EM4IdUQ6/9Y9xZ5qpUG40JRx
	 +rosBaM0zKtlA==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  linux-scsi@vger.kernel.org,  linux-ide@vger.kernel.org,  Niklas Cassel
 <cassel@kernel.org>,  linux-usb@vger.kernel.org,  Alan Stern
 <stern@rowland.harvard.edu>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  linux-s390@vger.kernel.org,  Heiko Carstens
 <hca@linux.ibm.com>
Subject: Re: [PATCH v6 00/40] Use defined 16-bits ASC/ASCQ combinations
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
Message-ID: <yq14ifovdyw.fsf@mail.kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Date: Wed, 16 Sep 2026 21:55:50 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Damien,

> This patch series defines as macros all ASC/ASCQ combinations present
> in https://www.t10.org/lists/asc-num.txt and converts the SCSI core
> code and SCSI low level drivers to use these macros instead of
> hard-coded ASC/ASCQs. To do this, struct scsi_sense_hdr and struct
> scsi_failure are modified to replace the asc and ascq 8-bits fields
> with a 16-bits sense_code field.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
