Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD67390CB7;
	Thu, 30 Jul 2026 06:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785394361; cv=none; b=GfCnbwS70G7mZeMuRhCXtl1LGWJ+SFjTXXW5HZE+QxUAC0mps/txyxeJazG5i6PcQIt3g7b0wBdxpHnBvIyAp43Lk6vJ7DODUEDpu1w+4a0ZSKkpcyA3rLw4EpTwt8CmbtuObTrsSkBgr23Kq/a0kG3CxMs9+goGP54pH5DQ5J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785394361; c=relaxed/simple;
	bh=2HhDqwfEhZDSDzmAYTOlNeEnn3IcONQew6Jh2d0NhLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZgl2Cp+uTkQIEBoA7lc0bq2+135Ce0D0XDF1CiXpMJdYo6QB9WswU8hmcpqwz/C3kcK8aRAXWiOtmYo4nX59Pw6zhlAUeoIvTWAYeuKhU+xA+aeVTyxP1y/7vdIxf43fRJ0k7ecFFor9Rsp6OYUZhe83LUg7o8jXtmDvCN86nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja8NO9XJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja8NO9XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0396E1F000E9;
	Thu, 30 Jul 2026 06:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785394354;
	bh=DIzlyLGIgLntyw3CrG+39XGZ5HDv4kdQBAGZpZAJ76c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ja8NO9XJFJPoyIJBvhr8EuKaZta2ji9kUPRFZjANJsKe5hVkeKadLwHyrAmmi6SSX
	 ArgCj9fiDhB58+mMWtmazPg7JEW9KM5FOMfiLus4uFvIMdUfSXZX8KD7Fc4au8mXmR
	 vIp9F9TrRSjXAd8H53RBjdDivrZeYPdsA01HGcduCqTcFrSO1BAAy3nFStsCsJ9uXp
	 F17HqkSmImG11ft8qKo0CBTCAbbMN504JD/oYZA1Ws3GDhFG/ZSPiHb73897f1Rr6b
	 nBEtgtpb0g7xJantazPb567u3QI6uCOFB4dvaZOZlpH3p4VCLpIZ3QIuMva/ZEzFVd
	 hyNq0VNlNUw/w==
Date: Wed, 29 Jul 2026 23:52:26 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, brking@linux.ibm.com,
	davemarq@linux.ibm.com
Subject: Re: [PATCH v2 25/33] ibmvfc: process NVMe/FC rports in work thread
Message-ID: <20260730065226.GA1879117@ax162>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-26-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723000149.969416-26-tyreld@linux.ibm.com>

Hi Tyrel,

On Wed, Jul 22, 2026 at 05:01:41PM -0700, Tyrel Datwyler wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> index 81d9229bf388..ffb579816e84 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6073,6 +6119,30 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
>  			}
>  		}
>  
> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
> +			if (tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
> +				tgt_dbg(tgt, "Deleteing NVMe rport\n");
> +				nvme_rport = tgt->nvme_remote_port;
> +				list_del(&tgt->queue);
> +				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
> +				spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +				if (nvme_rport)
> +					ibmvfc_nvme_unregister_remoteport(tgt);
> +				timer_delete_sync(&tgt->timer);
> +				kref_put(&tgt->kref, ibmvfc_release_tgt);
> +				return;
> +			} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
> +				tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
> +				nvme_rport = tgt->nvme_remote_port;
> +				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
> +				tgt->init_retries = 0;
> +				spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +				if (nvme_rport)
> +					ibmvfc_nvme_unregister_remoteport(tgt);
> +				return;
> +			}
> +		}
> +
>  		if (vhost->state == IBMVFC_INITIALIZING) {
>  			if (vhost->action == IBMVFC_HOST_ACTION_TGT_DEL_FAILED) {
>  				if (vhost->reinit) {

There is a warning from clang after this change landed in -next as
commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work
thread"), breaking the build when -Werror is enabled:

  drivers/scsi/ibmvscsi/ibmvfc-core.c:6154:15: error: variable 'rport' is uninitialized when used here [-Werror,-Wuninitialized]
   6154 |                         } else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
        |                                    ^~~~~

Sashiko appears to point this out as well:

  https://lore.kernel.org/20260723005006.C7EE21F00A3A@smtp.kernel.org/

But I am not sure that its suggestion to use nvme_rport is correct given
the context of this code, hence just the report from my end.

-- 
Cheers,
Nathan
