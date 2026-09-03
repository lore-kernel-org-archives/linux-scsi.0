Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B180046C4C5;
	Thu,  3 Sep 2026 09:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426622; cv=none; b=SWjsNSh0PytuhZIraK0hPDMNdy5doU9tNbdZlvOHXK+FpBmtVehXo08UlCSsLCRqGINQtc2XyywglcYp5rZApjxnTeYqc1a6I5Qqzf23EXpzKIPhbDnJ1l/O8JW5mZoQBFdvmnuKZt0XJU07yqCJTV/Uqxdr8jCLvClIecXbUmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426622; c=relaxed/simple;
	bh=9XoT+H1ehv8kAWOcNBLLeUQGjzj14LJuK6py3NF1kJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJISxsFY94dKaQYsEf8TseEgD74TYM1zFv4SsUYNLei3qG1bxpyI7a/4izNq++c5dhXjyp+3ER4HFrLSXYYIiy/g3gZgUbgPlCHz+ngEbXls3fttFzLK96J1CPgBz2BWoTAPHtR1Bbe2LHVKTI3sjBDugp73ZO7hX1IPax+KrRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tb/gCs+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tb/gCs+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CED1F000E9;
	Thu,  3 Sep 2026 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788426620;
	bh=xEBCmL7iZF2+rXLjhRctVJzNVxezOd3WR7caHQvbGE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tb/gCs+OwZGAGKZoGS/ZLN+IFDG3XSZZjfKR2Yg8AyfY2aC0kKWkP75BxcCI0CXsi
	 oR1/eDjzvpkFKD1EfDNKeTVwqc+8lfj/CHPFdkmaMpR5qzxh1J7f8PKpW7LtXDp9Sq
	 +5CcLRQ1uNkSh0Uh1WcHx+KaG15O7odz7a8Vte/9g6LpuFh/pEDzHTkn0UYdY9Ncym
	 D89ONMOgeWFxqA3QlcpVJpwVicCU8xggzxyRiG8IPlwXzCiMUWC2x8EvXwfkw2qEZg
	 KdyxYDuNfXmEhh44D/AMeC/ZCoF2DJvoyonQNqsUns94U/1ol/Jw9gVXn9i5oEndmF
	 2FPzwk3F/tVgA==
Date: Thu, 3 Sep 2026 11:10:15 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v2 37/40] ata: libata: use 16-bits defined sense codes
Message-ID: <apk5d2uHcD59FU1D@ryzen>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-38-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903034201.112211-38-dlemoal@kernel.org>

On Thu, Sep 03, 2026 at 12:41:58PM +0900, Damien Le Moal wrote:
> Refactor libata core code to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Acked-by: Niklas Cassel <cassel@kernel.org>
