Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEF317583;
	Wed, 19 Jun 2024 07:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718780566; cv=none; b=ldWrKKLcPEathILF/aMaAoVKoaaGZj21cx068f4vIyokXBAwHtsGdOUJAvN32UAbww6KnE9EATKGMmPYPjdsU2EChf32622TT7tz3lMJvV3OCNsD0qYI5FwcfFHSCKcU1RlQgAHNQ6gqeDfRzRZjVoJToWKXxpPV1zQMe23sq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718780566; c=relaxed/simple;
	bh=dUNP9Ol2VyAVm1aRcQaJGpbIe3MfLQCb3nWMRCVFtnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhWJvEbNznUdqWctNL2gUReiQ9Z2FsAI+dh1Evi78T2SsvDa7zQ/8DixsLBwiHaCslqlfoNRbLmNor2/oFtj0FYpxn/Hxv1breqlQkSmz6lUdhLs7oHrRT/kC61c4UeqJXTscsLC74fiX0QPc5jkWl+xm9aChfAbwPHxU06ohdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BZHQhyRG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BZHQhyRG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=plYxsWD5L8tm0Ptr4xv4Jqx8qmNNccPpaLnHJW+sbTE=; b=BZHQhyRGN3A38qmtdXgzHabPu9
	+2KL/nHwn7tTqGGO3x2ZVslvJIaHLgSVBHsKkopridiQSlAIzUJjIPcKncHNpf+zuk9zGyCFhUhXl
	n/2cgRV6jE/q/MkfSUlqVgGqBmWw1L5k85UM5xsu4pb7bJ8DuH0jMXIREb4qy0c2u3VL2aczEawmE
	DPk8TChWLsH9EJSl4W8TeeCmt62vOiFUD1iAeBEPFY75Ih5cT2J8baxGUoDSrPGdlyAFCPiJSx0FK
	gjY+MQfqKtGojNw/feZliFaqtyGavzyO2e7IdP2TA6TPC+Lb0w4Np3OuaL75XmgkCd8pfPkEWHuwf
	H/NGbcTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJpLA-0000000083R-2MmO;
	Wed, 19 Jun 2024 07:02:44 +0000
Date: Wed, 19 Jun 2024 00:02:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Li Feng <fengli@smartx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
Message-ID: <ZnKClE0RimoZFQSB@infradead.org>
References: <20240614160350.180490-1-fengli@smartx.com>
 <Zm_U_ZA96u2K6a6S@infradead.org>
 <44BCFE4F-AB66-4E6A-A181-E7D93847EF98@smartx.com>
 <ZnEsDHOAjODOS6HJ@infradead.org>
 <D8A1CB7B-7DE5-4078-9640-8674278E34C8@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D8A1CB7B-7DE5-4078-9640-8674278E34C8@smartx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 19, 2024 at 02:56:18PM +0800, Li Feng wrote:
> +               sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));
> 
>               sd_print_capacity(sdkp, old_capacity);
> 
> 
> If it's OK, I'll submit v2.

Except for the whitespace damage in the moved call this looks good
to me.

