Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4075490C19;
	Mon, 12 Oct 2026 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816569; cv=none; b=uaSVVi1VtIPZTLobqKavd4pBMKP6x7SGMv4TnE1Q0jvVFcnuxMoCVlPDPth02MKsu0u14N19EKC1snO45DoQaBP/mrsS3X3WHhTCDvW1J/T1R74v8iwCXf3WcqXbDuM6uLuFBbiRSZfyV4boIZJSWbsIM6pLBe5qhRP6oPEkj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816569; c=relaxed/simple;
	bh=9VyBAZG+gyNrenEICnPOgpzEo09UcyYXz0l0jaopxN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcdO6kdC0lqF57OdAw6A+vBtAZTZDCdSN2RJDQ2pm2ra1RBAJm5qr9jIFu5haxK6OUZGPjZchOR6xBRn1uue5kzV2j5aTDI+GIODr3hbfwKcP60vdJETcahQT14WMgCzRLcQdgrJYFrVadm08TS50EYIyub3a1hEzeghUML/1i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD8B7227A88; Mon, 12 Oct 2026 16:49:23 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:49:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: =?utf-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] scsi: sd: mark disk dead on surprise host
 removal to avoid I/O hang
Message-ID: <20261012144923.GA10852@lst.de>
References: <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 09, 2026 at 11:29:36AM +0000, 胡连勤 wrote:
>  	unsigned short_inquiry:1;
>  
> +	/* Device is physically gone; skip sync in sd_remove() */
> +	unsigned surprise_removal:1;

Placing this right in the middle of static fields is a bit weird.

Maybe we should get started with an unsigned long and atomic bitops
for something like that actually is known to set it at any point in
runtime and thus most suspect to corruption non-atomic bitfields?

