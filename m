Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F92D7DCE;
	Fri,  7 Nov 2025 08:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762505512; cv=none; b=cCDZIPgpFd7CSN/FfUDayuRIWEX753erKc6qUdmAohSly9QwVboe+ufrPmU+u27eVkyVXkqavhVWfUrmpSYR54RR00Vb/ehMcpWTJn0XliSYdPVEdhfgEegeeE7ckTNFKns4JqfJRkBxsNm63jLl/Map4eshd/cqYdAKHQs33z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762505512; c=relaxed/simple;
	bh=5AC8dzlhmfUZuF46jIwYZkKa1N++564Mk/n4okO/bg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYajFN08GV37Leox5b1GW8D5lSsB2jV0aV8AWKw7gA6Jm6BeZaN7E53E8E3zmBNrsZ/Kw11uvDI6bgTFl8BH1qQFcHr60I0nAPuM/SEMpBdqmelGe0i+7z7HFdsoEvZ2UN9wADKkeFkfS03LgsKQezrk37LFxOKS5O0NPptu5Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ad++WmhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ad++WmhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF894C4CEF8;
	Fri,  7 Nov 2025 08:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762505511;
	bh=5AC8dzlhmfUZuF46jIwYZkKa1N++564Mk/n4okO/bg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ad++WmhJ6xBRZbgbbv5tMmEeHezdcYmlkNYjrsL97fqPX6y99UIwO2dT6UP9UnvxL
	 L8u0AGxx3suRw8jejsqBjskLmo8bkrQgJjQoVwqgUXa9aR08MMrvjlOe0D7WmG9O/A
	 1gNTWwb3xSWyU33ULtmfSCg/SC+O9OOqAOOuhoxZN4muxtzdNE32hfVcHQckrPn+MS
	 iK/3Xv0feuRMe33kDB3rFVNgI9RRmV07+upuzGe6V2ShfX8799hJy7m8UWlWZKuFs7
	 sk8agaIq1+Kh5NaI+g63f4SA+H7+UQWBiiziaPsFPKxhaTpDW1Yg+RIgtf6vnfhIdz
	 VYTDV/1xGhIRQ==
Date: Fri, 7 Nov 2025 09:51:47 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] Support power resources defined in acpi on ata
Message-ID: <aQ2zI9tIb5asD16k@ryzen>
References: <20251104142413.322347-1-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104142413.322347-1-markus.probst@posteo.de>

On Tue, Nov 04, 2025 at 02:24:31PM +0000, Markus Probst wrote:
> This series adds support for power resources defined in acpi on ata
> ports/devices. A device can define a power resource in an ata port/device,
> which then gets powered on right before the port is probed. This can be
> useful for devices, which have sata power connectors that are:
>   a: powered down by default
>   b: can be individually powered on
> like in some synology nas devices. If thats the case it will be assumed,
> that the power resource won't survive reboots and therefore the disk will
> be stopped.

(snip)

> Markus Probst (3):
>   scsi: sd: Add manage_restart device attribute to scsi_disk
>   ata: Use ACPI methods to power on disks
>   ata: stop disk on restart if ACPI power resources are found
> 
>  drivers/ata/libata-acpi.c  | 67 ++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-core.c  |  2 ++
>  drivers/ata/libata-scsi.c  |  1 +
>  drivers/ata/libata.h       |  4 +++
>  drivers/scsi/sd.c          | 34 ++++++++++++++++++-
>  include/scsi/scsi_device.h |  6 ++++
>  6 files changed, 113 insertions(+), 1 deletion(-)

Martin, James,

Please have a look.

If you have no comments, is it okay to take this via the libata tree,
or do you prefer to merge the series via the scsi tree?


Kind regards,
Niklas
