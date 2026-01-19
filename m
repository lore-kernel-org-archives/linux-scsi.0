Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9AD38E11A;
	Mon, 19 Jan 2026 15:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768838062; cv=none; b=r4a745bJUWB4+c7bxPaGXiNJecATD88QwbPKfJOX22TOuuxgRDqQuf8mckcpIZ1/Ujjcm1nkZjGpOX/9Py9QBlMbO8zTMpq2jyob++bW4FevO/OwWbExFDPYhIbxF9KVvFdA7cCA98q7HqcwkprvYoZo9WLzmpT7OyFmFJqco2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768838062; c=relaxed/simple;
	bh=Y64uVPHXYo9hBfWhLMo0iF9t8roMCgMh4erxL6rlyGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ResLznYp1DL1T9/K9MqXNKD66mElNLbOJTAgLuVS6Bg9L/ikmxKEQoogSwlIui+meJPBqxoo8mlR7A+XN607j84uvvpOe7c57qiPiQWNTI5NLvU/P6pGhu9HL6LV4er3wIsF8FwG2W85wdQcKRUvpduy+bVv3GJfBMhritEkO6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJtYF8+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJtYF8+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A109C19423;
	Mon, 19 Jan 2026 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768838061;
	bh=Y64uVPHXYo9hBfWhLMo0iF9t8roMCgMh4erxL6rlyGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wJtYF8+9FRlIrIjLEkrd3wOuVZ3zymZDwROo9N8hQa2kPPJbsJkJ9aGfMpCyR7Y65
	 Jt/oMiLAb8N1nptM3WJpqz1oJS3ZYUkemdbhU+Ak2JiEb0p9uIvsDOHTUfgYG59IwY
	 LVRumrVilH/w5DEdnp/DQXTBttHFzsMvIM3DjAR8=
Date: Mon, 19 Jan 2026 16:54:18 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Don't free dev_name() and hold refcount
 for parent manually
Message-ID: <2026011928-sliceable-shame-841d@gregkh>
References: <20260119142306.33676-1-tzungbi@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119142306.33676-1-tzungbi@kernel.org>

On Mon, Jan 19, 2026 at 10:23:06PM +0800, Tzung-Bi Shih wrote:
>  static void scsi_host_cls_release(struct device *dev)
>  {
> -	put_device(&class_to_shost(dev)->shost_gendev);
> +	/*
> +	 * Keep an empty release() to prevent device_release() from emitting a
> +	 * warning.
> +	 */
>  }

Nope, sorry, something is VERY wrong if this is ever the case.  The
driver core is warning you for a very good reason, don't attempt to work
around that at all, the message was placed there to help you, not for
you to ignore.

thanks,

greg k-h
