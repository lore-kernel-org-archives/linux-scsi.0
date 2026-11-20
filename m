Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175347;
	b=U0AzBi7QcxWEqgrpbaCYnrBHIF154dd8lGjerYraT6TMhDLOJlPPmojrV5Y31Hija7nr
	 M7X/04P1kQF3dkChyjc+qIGte4g1HHUBYNgpiUrG52Mt3mxA999Hhert27fbM8iCu229s
	 lmUZQDmLs6ngCI16ZaNEquBaicwxUYALp3vRHtg9tLgomVtgY/W083DvRqcSIpygsDMFf
	 aJeeWpBSqh8V5vPuuq80UWxfFzkhdfpkl29KNHCiYgyJ27aMobgB1Fbb94PpmmiavOVN0
	 /NH+PhpIobs63Du85JakqHSLa4onMNIX1BEoS63UnZRhhKUW639D/Jcgeoz9IPtdhWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175347;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=wMuU7gD0u43sL1seq9JqEdQgJtWWqSdEN+rP/TTuoKc=;
	b=5kZsThrl90sGERr9Cenc3k9IUOadvCduwBhoubGrLGBI9PPnrepHkX+ZTTIqkHXGiMKs
	 J1qeUGsdn0PHhpyn3UIw4Jol15TH1i3sD1ql6EA2gAm6ZwqtfHhFiVlO6dVA6AnZlvTYF
	 zjNmTssGvXkx4FUxRLHw5wq4kiyfHgVFjEOy1ncRPPi5/d67Ag4DygpfZRONcyoeYBVpK
	 3oEF3mVFR3sc/iTe0vANXmHurQuGQ/F+E0Y0ri7eWOSfpnP3ZazfsJ7cU6Unuk8SBPPQA
	 60EO2yXs1Ub3z99JjJWdwLkbo2hsMb9DD0TvnR9Xvz5eix2cEsjXnvp7gfM0XhHVN0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jN0Aht82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E25606A334;
	Fri, 20 Nov 2026 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jN0Aht82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE9C1F000C4;
	Fri, 20 Nov 2026 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795175346;
	bh=wMuU7gD0u43sL1seq9JqEdQgJtWWqSdEN+rP/TTuoKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jN0Aht82yiGY3+Nq1kA4Mw1jDHXParSY8hS6y5K8m/NoOR2FoesyOOsghw+Uj/J3P
	 27w6uuPmp9Lcg32ToWf5iFnIKfKVfinSztXrOj5WKlEpG0aK2cmm2+9ZpEddQlOcLI
	 yAF1knKk2zLqh12azLZQLFgRqPbcDNQpJcgfAJ8c=
Date: Fri, 20 Nov 2026 12:49:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
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
Subject: Re: [PATCH v5 2/2] usb: storage: set surprise_removal flag on
 physical removal
Message-ID: <2026112048-preamble-fifteen-46a3@gregkh>
References: <TYUPR06MB621711053AB2B701FECC73FED2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <TYUPR06MB621711053AB2B701FECC73FED2922@TYUPR06MB6217.apcprd06.prod.outlook.com>

On Fri, Oct 09, 2026 at 11:31:42AM +0000, 胡连勤 wrote:
> Set the surprise_removal flag in struct Scsi_Host when the USB device
> state is USB_STATE_NOTATTACHED, indicating the device has been
> physically removed and cannot handle I/O.
> 
> This flag is checked by sd_remove() (added in the previous patch) to
> skip sync_filesystem() during surprise removal, avoiding a hang waiting
> for I/O that can never complete.

There is no previous patch.

> For orderly removal (e.g. rmmod, sysfs unbind) the USB device state is
> not NOTATTACHED, so the flag is not set and sync proceeds normally,
> preserving dirty data writeback.
> 
> Signed-off-by: Lianqin Hu <hulianqin@vivo.com>

Does not match the From: line :(
