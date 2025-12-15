Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743628725A;
	Mon, 15 Dec 2025 05:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765778321; cv=none; b=bXs3pq1HtcsYYHC8v6kBdEMmg9LkL3KCadP+3pKShqOdCTmOVjUdEwjCgSuwzSKebbpQVurhbjzVzjjFh9+01A2Tlcn4HUwwQXwcAHgn6ggZKZltNHzbAW2VlY7/9ZIM4S4zLsmZwKhLnrsVL7y6PDRNf8xoBsot093/zWpJqVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765778321; c=relaxed/simple;
	bh=ywKaNV+7WlKGVpWhk2d5ldV52iL/4tqLLq7ChoXg5bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ty2eS2GlBuTw2hExeu24J/Fjkdrkj8l/iQPjoFkIAC60euKQO65Db5KnVB05wtOJlGmPKCnkCLnHMAQtDbwf89DjyhbVkVchk39g5iOCBnCpdPE/kTUGab3i9JBTFP7czbcpVHxE1rkv8K3XMUWvHEO/I9bnc0Nucm/f3fqb6OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ARHYCdgG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ARHYCdgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I+KJ+SWWQXwGIV8tfCQpoCwTyPKUMJdXxjAzFWtLeGQ=; b=ARHYCdgG6adq4+qQiRXFyZ8cyz
	HtdKKD9BlvpteYANx6nQeRY+XFH++P2xLYhwYZn4HYTkulzE7q7KgU1ow7bnhwe1GdA/8/g2BudWE
	kYG10v7gNrCb3QKZQxZGHB8WNSu1mdTUkhGygPqywHyydUX9QR4zQTmFO3LdrTH2Et60WMSp5lhmT
	kneilwzRfF+4dtbI8eQKth4YqmHzfGtHU3uhdiRiVnZuO0j7L9vBw3p2/9hOU19VS5HTSAe8nfkLL
	Syr0gqRaeDVDcHUyOKUnSx1rKCF/Gc/ZLy6gG18N26sE2FW8Qb49dj4/Kl5DgcjA9cv5m8X333ohs
	E6hOuV5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV1bR-000000038Cd-2CB2;
	Mon, 15 Dec 2025 05:58:37 +0000
Date: Sun, 14 Dec 2025 21:58:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
Message-ID: <aT-jjQpp1UfaiZIU@infradead.org>
References: <20251208025232.4068621-1-powenkao@google.com>
 <aTkXqslvwMOz2TUG@infradead.org>
 <955ba65e-424b-4968-9541-ab235a7bafd3@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955ba65e-424b-4968-9541-ab235a7bafd3@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 10, 2025 at 09:44:52AM -0800, Bart Van Assche wrote:
> On 12/9/25 10:48 PM, Christoph Hellwig wrote:
> > As mentioned last round, why are you even calling into the crypto
> > code here?  Calling that for a request without a crypt context,
> > which includes all of them that do not transfer any data makes no
> > sense to start with.
> 
> ufshcd_prepare_lrbp_crypto() only has one caller. Moving the new test
> from inside ufshcd_prepare_lrbp_crypto() into its caller should be easy.

I don't think callers vs calle is the important part here.  It is to
check if any actual data is tranferred instead of special casing EH
commands.

