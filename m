Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53014A09C
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 05:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759902616; cv=none; b=VXtUyM6rO2OMcu1KN+RG7AXJ5avHh7lrODoRWjEuDd/PlaoTahxrsJd6V4b8O4IoPRIX81vVuhlqABNvTxjan56ASAruRxFyIQoSGcv86kj+lUqqGCkwRMay4CnVs3I4Lt/yNRNAlEryfQ3+DStC/UQ9WLp1YobuyZhumxySuMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759902616; c=relaxed/simple;
	bh=RX5iKjaTQHLfeFp+d41tjL58dw2SVsb7XFzBOAhBfT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzyNXKR80ck4W1BuOI6a0fSXw4toJ39AgA+4YppK219yhzjz/FJggBAZYIH7iOYTgugbidJP50rwtRlaS0yUcu7L8IZ0LFeFQ+tDuB16qO/FJxlAVrjDi4M/DzsLsiG3GjxuvKbGmEC5tkfNB5S+t+3u5GNaxVkhu04M0w8vL/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kNT9J9Xm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kNT9J9Xm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=inDgj/ui8Rx9l4Y5Nr+lSLBnTKAHl6D6UB4f8+WvtLk=; b=kNT9J9Xmol70Kcr53cV4C8c5Qg
	Vn+lXjtr0RHbuhNXdNfri00mc/9wO4fn/4A5LiySj2Kdu3TgAlJmQv84jYJUbjtRIJD2whSyzWSYC
	wNU42PYkiRH7t66hMnOq9RvGn39hLy1kLdrO+w45+WhWe2ugxqQ/zhsKI3/Dbr3p0iD+ZsT+xPphD
	YB9Oq2UlFj5bDX5aDNCGtI7eK2hcJKrhB99E5UqLfKnHMc9sxldrOjg3sTAD/h2VRa5ZH/nHVx22d
	FJ4Rco4VUMdiLvNotsQUiesAXwUGRCtiuJAuJatsouzyCjhcThMeObkd8zIPhC4tTjaOi/SRV7Ehk
	474pI4xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6N3y-00000003Eiz-2q2l;
	Wed, 08 Oct 2025 05:50:10 +0000
Date: Tue, 7 Oct 2025 22:50:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Jens Axboe <axboe@kernel.dk>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
Message-ID: <aOX7krhcR7DB7T6a@infradead.org>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <CAFj5m9K1L7n3C9mL0zgNXmzhttD-B-64LBNbcp=HCPYPNvgjMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFj5m9K1L7n3C9mL0zgNXmzhttD-B-64LBNbcp=HCPYPNvgjMg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 08, 2025 at 11:17:18AM +0800, Ming Lei wrote:
> Long term, the UFS driver need to be fixed, this or most of scsi core
> APIs should
> have been called after the scsi host is initialized.

Please fix ufs now.  Otherwise we'll be stuck with these hacks forever
as they never get cleaned up.

