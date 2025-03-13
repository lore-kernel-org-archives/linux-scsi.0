Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44852627E8;
	Thu, 13 Mar 2025 10:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741860204; cv=none; b=b6C/JmWYOiedAeEWyeJ7QupazaB8RmmHvZr3s6hyl3E9Lneb1ej+e5UduFrbZx6ewL3Kb7vGxtN6F/FZmbmapXZ1HfIzRPG6tMJeGytgAkZP7T4ppvY8KdOl2ZcX67VrKmeOosUk/ugf1KLeoVUnLKQ+DpIOHbw1Lz7vwncU5yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741860204; c=relaxed/simple;
	bh=GYaVp06ZaRaULqloLZjXtEUGLEokBtVzt5VpPie8xqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPQMNsq2I+jGwhjTmFcydyFb9ve/deNVfv72sDh3xXgL5tao4QZZ2tzMvcJ3NjD0sGIUWFBsuXPM5cnWeerZxcmCZ7QCvuoSCxPeowJu+Jiu7OrmXX3nX3SkER/ybDUZosqj4LU+9gA+CrQs7cPuJngafaxg3De3CGMhesPyTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXNFyN4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXNFyN4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D2EC4CEDD;
	Thu, 13 Mar 2025 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741860204;
	bh=GYaVp06ZaRaULqloLZjXtEUGLEokBtVzt5VpPie8xqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qXNFyN4z841SA2NwvCcOMqgxsGxVkuK8mJqBTeuMGjStDz2HnanExDWyg5j250SeO
	 DBkDLpMMNce0JdMTAXW+i1bft0klKIeF4P6DusvmcJhxBSSyD4FeOiM7wZfwk2jxD8
	 yYJPYovhC+NjcwPo/pQ75i0XvAqO63VBmZ//4DWk=
Date: Thu, 13 Mar 2025 11:03:21 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ma Ke <make24@iscas.ac.cn>
Cc: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	James.Bottomley@steeleye.com, open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] [SCSI] iscsi: fix error handling in iscsi_add_session()
Message-ID: <2025031316-frail-twitch-7313@gregkh>
References: <20250313081507.306792-1-make24@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313081507.306792-1-make24@iscas.ac.cn>

On Thu, Mar 13, 2025 at 04:15:07PM +0800, Ma Ke wrote:
> Once device_add() failed, we should call put_device() to decrement
> reference count for cleanup. Or it could cause memory leak.
> 
> As comment of device_add() says, 'if device_add() succeeds, you should
> call device_del() when you want to get rid of it. If device_add() has
> not succeeded, use only put_device() to drop the reference count'.
> 
> Found by code review.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8434aa8b6fe5 ("[SCSI] iscsi: break up session creation into two stages")
> Signed-off-by: Ma Ke <make24@iscas.ac.cn>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 9c347c64c315..74333e182612 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2114,6 +2114,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  release_dev:
>  	device_del(&session->dev);
>  release_ida:
> +	put_device(&session->dev);
>  	if (session->ida_used)
>  		ida_free(&iscsi_sess_ida, session->target_id);
>  destroy_wq:

How was this tested?

I do not think this change is correct at all, please prove it by showing
how it was tested.

thanks,


greg k-h
