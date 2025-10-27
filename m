Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD092D94BB;
	Mon, 27 Oct 2025 06:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761545203; cv=none; b=SMHRGGcslm82q0QmuVzqNgmoiO9fcE7IXZh7xiJ7nmWjwI2m0+HlkWcC0ddVDjjECo/namF6EItr7Or1Vb90sBX6MjMGqMk7WW+qmpNzcDjXWUvOMqZvZLBLGoFnguw6NoQYDKyAJbhu4tF/N8xZDZh0kYDYZm1+mqmMamqzrD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761545203; c=relaxed/simple;
	bh=WFeWxL492eGqeiwCEE1bfgQYZvd0PytE5SQ93uJv20E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxF1fa9fz88flzBPMFa5MK6lFhyvehLl4RxYV9StIZTRdj1yQOp/nehczr5naBJmrn284VnzarXMIcOKGxLDneUSQtlpkOG/QPhqLTgZIiCHF6Z2fvj1FAFbgeAcZLSyDGrHlWIgex6Fm0sf+qdK7PURAjZIo0XJfFZrj/1ddf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: M6xXRqE0SZytrjgFWeQ8Cg==
X-CSE-MsgGUID: T31zFUQdQRWrkdf8CWmpgQ==
X-IronPort-AV: E=Sophos;i="6.19,258,1754928000"; 
   d="scan'208";a="156458751"
Date: Mon, 27 Oct 2025 14:05:11 +0800
From: Owen Gu <guhuinan@xiaomi.com>
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>, "Yu
 Chen" <chenyu45@xiaomi.com>, Michal Pecio <michal.pecio@gmail.com>
Subject: Re: [PATCH v2] usb: uas: fix urb unmapping issue when the uas device
 is remove during ongoing data transfer
Message-ID: <aP8Llz04UH8Sbq5Q@oa-guhuinan-2.localdomain>
References: <20251015153157.11870-1-guhuinan@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251015153157.11870-1-guhuinan@xiaomi.com>
X-ClientProxiedBy: BJ-MBX04.mioffice.cn (10.237.8.124) To BJ-MBX05.mioffice.cn
 (10.237.8.125)

Hi Oliver,

I'm following up on my previous patch v2. Could you please provide feedback on it?
If there's anything I can improve, let me know.

Thanks,
Owen Gu

On Wed, Oct 15, 2025 at 11:31:57PM +0800, guhuinan wrote:
> From: Owen Gu <guhuinan@xiaomi.com>
> 
> When a UAS device is unplugged during data transfer, there is
> a probability of a system panic occurring. The root cause is
> an access to an invalid memory address during URB callback handling.
> Specifically, this happens when the dma_direct_unmap_sg() function
> is called within the usb_hcd_unmap_urb_for_dma() interface, but the
> sg->dma_address field is 0 and the sg data structure has already been
> freed.
> 
> The SCSI driver sends transfer commands by invoking uas_queuecommand_lck()
> in uas.c, using the uas_submit_urbs() function to submit requests to USB.
> Within the uas_submit_urbs() implementation, three URBs (sense_urb,
> data_urb, and cmd_urb) are sequentially submitted. Device removal may
> occur at any point during uas_submit_urbs execution, which may result
> in URB submission failure. However, some URBs might have been successfully
> submitted before the failure, and uas_submit_urbs will return the -ENODEV
> error code in this case. The current error handling directly calls
> scsi_done(). In the SCSI driver, this eventually triggers scsi_complete()
> to invoke scsi_end_request() for releasing the sgtable. The successfully
> submitted URBs, when being unlinked to giveback, call
> usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
> unmapping operations since the sg data structure has already been freed.
> 
> This patch modifies the error condition check in the uas_submit_urbs()
> function. When a UAS device is removed but one or more URBs have already
> been successfully submitted to USB, it avoids immediately invoking
> scsi_done() and save the cmnd to devinfo->cmnd array. If the successfully
> submitted URBs is completed before devinfo->resetting being set, then
> the scsi_done() function will be called within uas_try_complete() after
> all pending URB operations are finalized. Otherwise, the scsi_done()
> function will be called within uas_zap_pending(), which is executed after
> usb_kill_anchored_urbs(). The uas_zap_pending() iterates over
> devinfo->cmnd array, invoking uas_try_complete() for each command to
> finalize their handling.
> 
> Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
> Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
> ---
> v2: Upon uas_submit_urbs() returning -ENODEV despite successful URB
> submission, the cmnd is added to the devinfo->cmnd array before
> exiting uas_queuecommand_lck().
> v1: https://lore.kernel.org/linux-usb/20250930045309.21588-1-guhuinan@xiaomi.com/
> ---
> ---
>  drivers/usb/storage/uas.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 4ed0dc19afe0..45b01df364f7 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -698,6 +698,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
>  	 * of queueing, no matter how fatal the error
>  	 */
>  	if (err == -ENODEV) {
> +		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
> +				DATA_OUT_URB_INFLIGHT))
> +			goto out;
> +
>  		set_host_byte(cmnd, DID_NO_CONNECT);
>  		scsi_done(cmnd);
>  		goto zombie;
> @@ -711,6 +715,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
>  		uas_add_work(cmnd);
>  	}
>  
> +out:
>  	devinfo->cmnd[idx] = cmnd;
>  zombie:
>  	spin_unlock_irqrestore(&devinfo->lock, flags);
> -- 
> 2.43.0
> 
