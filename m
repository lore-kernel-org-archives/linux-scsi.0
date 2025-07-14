Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708501DF749;
	Mon, 14 Jul 2025 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752485936; cv=none; b=l0dNhGY0+HwzwIEPjQp8KynAOLQCnyIEyk2HR+qaVybMBtiBmLNYErGkuAOlhnxGrbcKKg0LPbjTw+F373wGAZo+Z0hmzEtitf1myGNWovygyCL2PBPdP2PWI+A8kfcCiINBIViejo6MM5saSedWxtldxoB87ndzJP/ZzUDjIgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752485936; c=relaxed/simple;
	bh=fMtL5H8zJJ9zr8cIoa0AGjrx47LxHKN3MojnDBeUlyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AtJygyVXWuXDNe468UX1A0IknTv+ufBcg/UaOGLwAcKLG1gUyALO4Lp9S9KJuDX0HgKdFvbnJSH9Bm86U0Lt3GNvHJmoKhVhVL14Q2zHqenES0Y1anNdkjAhEsKBCayyJVO7OA+QDD8VNk0ZZy8nvAse219UonGJgoPVI33pBG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzsXWZoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzsXWZoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503B9C4CEED;
	Mon, 14 Jul 2025 09:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752485935;
	bh=fMtL5H8zJJ9zr8cIoa0AGjrx47LxHKN3MojnDBeUlyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WzsXWZoKuJmmI9v3HWKv+1ihiM2ZbaTeySkbKh0pSjmgtsS/OPblbFwDZ0Lbk+yl6
	 Ssdlycn4V0go8FNqDv4+kPG8fIchRiSVaZbvxJpv8QY+3KKShQFrL4300kvn3emH3r
	 zGgDdAxwVRecbYfFAJez13Zkc25+qansZ4QYQANJoWhq0Gm1g/4q83CQSEIYJqO9Tt
	 xCWOo7fcxLboFRiGMRql5MLaZNDd4OBTAwYQxlydBZ5kXi+DE+XXTg5k8m7F6OcUDe
	 7yu8QdC14cQoytc3WMQEinULuvDHsihtGOorfOBB7AuAc6CnMFWogRvDK/zRHlM2Tf
	 GhSPclYA685EA==
Date: Mon, 14 Jul 2025 11:38:51 +0200
From: Niklas Cassel <cassel@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v4 2/3] ata: libata-eh: Simplify reset operation
 management
Message-ID: <aHTQK4VgAAopjkBW@ryzen>
References: <20250714005454.35802-1-dlemoal@kernel.org>
 <20250714005454.35802-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714005454.35802-3-dlemoal@kernel.org>

On Mon, Jul 14, 2025 at 09:54:53AM +0900, Damien Le Moal wrote:
> Introduce struct ata_reset_operations to aggregate in a single structure
> the definitions of the 4 reset methods (prereset, softreset, hardreset
> and postreset) for a port. This new structure is used in struct ata_port
> to define the reset methods for a regular port (reset field) and for a
> port-multiplier port (pmp_reset field). A pointer to either of these
> fields replaces the 4 reset method arguments passed to ata_eh_recover()
> and ata_eh_reset().
> 
> The definition of the reset methods for all drivers is changed to use
> the reset and pmp_reset fields in struct ata_port_operations.
> 
> A large number of files is modifed, but no functional changes are
> introduced.


Martin,

is it okay if we take this patch via the libata tree?

If so, would it be possible to get an Acked-by?


Kind regards,
Niklas
