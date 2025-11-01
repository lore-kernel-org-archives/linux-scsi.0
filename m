Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064D534D3B6;
	Sat,  1 Nov 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.143.206.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762005413; cv=none; b=AHkgrgIFdkdI+F0lh9PweMB7biP5THo6D4LMtMeekuy6CWYcnIpzsyxlYyU/UvuKcTci2p3aTC7MfdUqN1ua2MyW9k7635S/dOsxoFusWcg84hyk6p6nNiPHdfaZdsm40vRHItmCIQJx8htVMVL013uPWFBDOTZcp5ypY/RdXkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762005413; c=relaxed/simple;
	bh=54YFvUQyKiUBXLsSAVClXBwjoW43bRWANDi9bisFiVU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeUVeHZ6uNyA0GBdi0tORr9GBjhMRUNt+kxysppBJrdG+qhGimNeCixWZsqtPsCrOyC5TmVY+pnbfLyq8RkpAwKwN+h5wKVzXgEawbKxM/1NDW8UNaJp5UTK9X+5abZRl4k4Hh7eCGkX32+pmvHur5VCSRJugJOcnCTXRyrMO2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=118.143.206.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: wpOrwVv0TfGh+FJzZcbPPQ==
X-CSE-MsgGUID: SFIU6wynT+iEPt/G+F7yQw==
X-IronPort-AV: E=Sophos;i="6.19,272,1754928000"; 
   d="scan'208";a="131247206"
Date: Sat, 1 Nov 2025 21:55:22 +0800
From: Owen Gu <guhuinan@xiaomi.com>
To: Oliver Neukum <oneukum@suse.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
	<linux-kernel@vger.kernel.org>, Yu Chen <chenyu45@xiaomi.com>, Michal Pecio
	<michal.pecio@gmail.com>
Subject: Re: [PATCH v2] usb: uas: fix urb unmapping issue when the uas device
 is remove during ongoing data transfer
Message-ID: <aQYRIgg2lyFhd7Lf@oa-guhuinan-2.localdomain>
References: <20251015153157.11870-1-guhuinan@xiaomi.com>
 <aP8Llz04UH8Sbq5Q@oa-guhuinan-2.localdomain>
 <8de18ee2-ccdd-4cdd-ae49-48600ad30ed4@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8de18ee2-ccdd-4cdd-ae49-48600ad30ed4@suse.com>
X-ClientProxiedBy: BJ-MBX07.mioffice.cn (10.237.8.127) To BJ-MBX05.mioffice.cn
 (10.237.8.125)

On Mon, Oct 27, 2025 at 02:35:37PM +0100, Oliver Neukum wrote:
> Hi,
> 
> I think I was unclear the first time.
> Sorry for that.
> 
> On 27.10.25 07:05, Owen Gu wrote:
> > Hi Oliver,
> > 
> 
> > > This patch modifies the error condition check in the uas_submit_urbs()
> > > function. When a UAS device is removed but one or more URBs have already
> > > been successfully submitted to USB, it avoids immediately invoking
> > > scsi_done() and save the cmnd to devinfo->cmnd array. If the successfully
> > > submitted URBs is completed before devinfo->resetting being set, then
> > > the scsi_done() function will be called within uas_try_complete() after
> 
> This requires that uas_try_complete() is called.
> 
> And I am afraid uas_stat_cmplt() cannot guarantee that in the error case.
> I think the following sequence of events is possible:
> 
> CPU A						CPU B
> 
> uas_queuecommand_lck() calls uas_submit_urbs()
> COMMAND_INFLIGHT is set and URB submitted
> 						URB gets an error
> 						status = -EBABBLE (just an example)
> 						uas_stat_cmplt is called
> 						resetting is not set
> 						if (status)
> 							goto out;
> 
> 						uas_try_complete _not_ called
> 
> The scsi command runs for indeterminate amount of time.
> It seems to me that if you want to use your approach you also
> need to change error handling in uas_stat_cmplt()
> 
> 	Regards
> 		Oliver
> 
>
Hi Oliver,
I think the error handling only takes effect when uas_queuecommand_lck() calls
uas_submit_urbs() and returns the error value -ENODEV . In this case, the device is
disconnected, and the flow proceeds to uas_disconnect(), where uas_zap_pending() is
invoked to call uas_try_complete().

Regards
Owen

