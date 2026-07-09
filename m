Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96312E7631;
	Thu,  9 Jul 2026 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783620146; cv=none; b=f8MBZQaaslBjF1O5YQ8WvaCRQU/vv0fxS731Ee/9hMtFWWADLZbcxSwSCGkSjkLNRkXgjVx2mZHoSsjbvQYaafHybgyKgiglcsUW7/ZJOc3xPLGX2BQPhAvXtspjmRp6XHXEtzuR5d5QzDSEibhAozEQoCnEoDUO0D8USkq2IYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783620146; c=relaxed/simple;
	bh=3JKMImIJOW7Hv8YZzxXH5eOwauiI5rKVkw77jtIHJVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVDy4F20CAKX6RDq2vHLM+XRmU1hkCKX+nA56ng/UCB0eBR2XOt4fNwB1mAL0dOMM0t2eaFzIALKQRGCBg/BWfxF/snEwCp6wOjDAl/M7Gagde4j++B7WcEypcuCuPydGKTjCbONBW/88wnbAvrF7gT6JZTvTrCUEDupCNlVou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckiAO0CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckiAO0CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F75B1F000E9;
	Thu,  9 Jul 2026 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783620145;
	bh=3JKMImIJOW7Hv8YZzxXH5eOwauiI5rKVkw77jtIHJVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ckiAO0CMP2g2EJ8Og6NKviCbMatMGSyOlaete6+WyWklHu3SUujoF0HzW+A9v5AJe
	 W2qRSFEbngCKuKNTXG2pT26cqJBzu3XVl/Sn9K9QcsCbm9HV58zfHXSU+vA7QaTzlG
	 DSNYnajzJwiEktSLZ1ZCylHXsfAoS1ncco2GAV2889Coo0YwePN5sdT9TVlyq0N0ni
	 HUsbhC5MS0kkD5cfRWfOYVQ1BY+96lbBzuwNvXKxrKE9lXif12eNppfa4XbzA5t7Xe
	 r9chtn6Vr8w+fiRpzxYJSAIjSXxk+VbIr+sffJ0KMRnkANBtTiu268BsNl93EY4fL4
	 BhznfKQdi330Q==
Date: Thu, 9 Jul 2026 20:02:21 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <ak_iLVzMFBgqI7Av@fedora>
References: <20260709083934.1116862-1-dlemoal@kernel.org>
 <20260709083934.1116862-2-dlemoal@kernel.org>
 <20260709090006.F317F1F00A3A@smtp.kernel.org>
 <dcc4f558-7b6e-4193-a943-036255fc202f@kernel.org>
 <ak_gsY5YvMBC-0M_@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_gsY5YvMBC-0M_@fedora>

On Thu, Jul 09, 2026 at 07:56:06PM +0200, Niklas Cassel wrote:
> If scmd != the deferred QC, continue to set DID_REQUEUE and return
> SCSI_EH_NOT_HANDLED.

Just to clarify:

If scmd != the deferred QC, continue to set DID_REQUEUE on the deferred QC,
and return SCSI_EH_NOT_HANDLED, since we did not touch scmd.


Kind regards,
Niklas
