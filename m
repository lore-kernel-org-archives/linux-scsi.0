Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A19F243367
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 22:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099147; cv=none; b=tJL/6SvSraWTtkOpOPnCPT2xSvXkMMPqslfCzqAEyDq6RSlxvqXjWDTCoSPEVPXwX3U7Bl1W1+0TAuE1h/4rYEwHB5GQPDlUkM/bZXBcvNQiTYE77pelgVVBm4gbx4ICBlqMO6IJb3PPLI7+aDFfWJliXQipbbul2gU63rgrdRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099147; c=relaxed/simple;
	bh=ekQqIbapukARd6gBzz7yly3iOSMb8FIqVO9iq42DlP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPozYf7LcT049/jzXDrhFwngfIA9fDEKeg132uSMdzLp/bSxRHsWg7WQ+1HHzhEGEd/MyFuuUro7kDuO9N+kVKXo3bbztYVlG8gx3Y24iihsNrVJsxEidoszNcBf7baGRtoJ8cEmz+ZCqM2qZ/gJztlW1RWSn+zgn3zRZu550Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2tAKGY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2tAKGY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D674C4CEEF;
	Wed,  9 Jul 2025 22:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752099147;
	bh=ekQqIbapukARd6gBzz7yly3iOSMb8FIqVO9iq42DlP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F2tAKGY6+QYmIv65ILc2CTZPHoOtM+FaxmjiryXozPOV3E9UP1b3CFN3O5Wsl+4Uv
	 +4eyf7w0p3tNA2K2s/yszWCxhcnLeTMf/YYk3S+GkotJKFe8IqxuhT4v2qoMd6xbta
	 ERP5gs7s16SStlct+Oa/sdebbKJMHjRPYUj5yCX1FmA+K3rHgmd98QC+8jaBcb/o/d
	 XCSkmBuh9bqZ5VC/r3a2e+UvOhl4FYyiBiQqtvlCZSOHEF0AAO+xxKKZd5dlf5dhEo
	 8xQvrVozM3WmuQhYFusZMwhV/3hJUZSIvQR8wjBJgG1/NrAWkBN3k5SfA5PTZTcxOT
	 bV+4vvAynJQag==
Date: Wed, 9 Jul 2025 16:12:24 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bryan Gurney <bgurney@redhat.com>
Cc: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me,
	axboe@kernel.dk, james.smart@broadcom.com,
	dick.kennedy@broadcom.com, njavali@marvell.com,
	linux-scsi@vger.kernel.org, hare@suse.de, jmeneghi@redhat.com
Subject: Re: [PATCH v8 7/8] nvme: sysfs: emit the marginal path state in
 show_state()
Message-ID: <aG7pSA6TOAANYrru@kbusch-mbp>
References: <20250709211919.49100-1-bgurney@redhat.com>
 <20250709211919.49100-8-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709211919.49100-8-bgurney@redhat.com>

On Wed, Jul 09, 2025 at 05:19:18PM -0400, Bryan Gurney wrote:
> If a controller has received a link integrity or congestion event, and
> has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
> instead of "live", to identify the marginal paths.

IMO, this attribute looks more aligned to report in the ana_state
instead of overriding the controller's state.
