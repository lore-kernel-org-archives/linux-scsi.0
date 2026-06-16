Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C33413D62;
	Tue, 16 Jun 2026 09:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781603117; cv=none; b=jf6zKoPnTdQcAf0A5zRBE2U58mjY97wuKjxu7r8OSFZQRtkq1E2sZGMyedeXwnWzXRxmEBRD2HAsdYOXwgDyK+liLyTjMoAUKt1NQoHfvdZwVZJI8cIqOtkwxjN82o5HA/GWsc4VygOufvzPCLP6KoOGeiTB0NntfQu39EjMw3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781603117; c=relaxed/simple;
	bh=BeHVUh6LTvIzaky9I6xSEA2hjsvsm2mHMnCkdGtuEZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=be9IgoO2vnrkpDFPcEg25THhDKK5lmomIcg3eD/nqIZoxWaGDmmy1t3OUYeaFbCS9FP4R5Ziw0CJQSvG8+VJI7Qzz2n53bXNXrhqSq29A+9aH4AYB92IhVIlQGDQEVbu5w7JkjkGILloxuUhw8zRq3/KZFtR+QvJi8De9von3bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=RidYTjEF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CmdUMoYE; arc=none smtp.client-ip=103.168.172.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="RidYTjEF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CmdUMoYE"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 302F613807D3;
	Tue, 16 Jun 2026 05:45:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 16 Jun 2026 05:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1781603115; x=1781610315; bh=GBkUng9QJy
	AwZXWTt0cs+Y700V10kPY1PNWJPxVcCRQ=; b=RidYTjEFn13JfUeTvpplDnVsd0
	2X69iTqb/ovcQqnbdASI8mQhi7Kz3HEUF0hyA48FAzXW3jZwbf81bdxrPaIvsuCG
	wwofsKwzfwgAsNt9IWEdV/9U9Mc7GdcGpaTvpTSmywqmH04Jsd3Pr1W8SlAoMgxo
	rDECLn6z/3CuDd2lGR26HTdUEBxDOIewEeQhaCVLfIzdA+KGbke2Z0ySQqTw2iZh
	59i85hRkNpXGjA350QpM1yAgkbrYIkwM/+5ggnmN4llF+SI2K/8UqXyQyyC+gqOV
	/X7mC79wcemlxk2nyyiSPHl7p1m0bKQejjkc5BbO7dov5zh/oEmiX6q+gomg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781603115; x=1781610315; bh=GBkUng9QJyAwZXWTt0cs+Y700V10kPY1PNW
	JPxVcCRQ=; b=CmdUMoYEkVlj4XKt1/SBic8DZ/2S1FtEA1jDroai1ttua7HXsM7
	sxpNyQdOiVd46Quy97M9JsYa7pwaGHNexPL7svHlpgbfC1nPO/bKFTmt9vG20bF2
	tsBVxcfvwGrmiO7Xe5nLp8m1Kjvys+Mx2l1ujKJhmZRI6e/Y3kjB6CnfaHqmnizb
	OP5dLc6K6U+QxX1arqoylJteH2un0dV5gEizrczNZph639TXD/P5xUwI+7465UA2
	HVRhSorpqR0e4sMaK8y+MaA8j7Pq0Wm4k27Tpg7x0yvpqYRu5SnmggK3CGCSij5+
	/CgJ8q0nkjdOo71AyAOn9fblCmd7TFLBLeA==
X-ME-Sender: <xms:KhsxagwaEHbvwXLdX-G9iHcjDBqc5pt17lRfPJ1BFphfjtuI0iQPsQ>
    <xme:KhsxanzEE44f1k51Rp8W2eKCFdblUPnRHV5jsPEmT6LYKc-9usdYX9qvssBbSo91q
    6bUFjnL-DAi98tD7Et_Hzo69sgdJefjFb_agF-7nAjhZnGoGg>
X-ME-Received: <xmr:Khsxaq23U7HRAQtL8PIeVFwzcQnNY6mLZ5l9O88tBfQFxj-JOMdEHyNf>
X-ME-Proxy-Cause: dmFkZTECq43OruQE3SEk0cJVJDk8XjfyxAQTpojuMifWPXGqrQmy3RAKcv6mRqmNZ6qgtd
    fLw91l/vXogkok8YM2UWsVnBeUmg4u4tHx71Qedx/9X1M9sL9UscvxfEA12BbaXio9RFpz
    lFPS6m32P1f8FOe2fRBEMErTcps/lR9cyJQ+d4jEMVf3Mx74pt4v8IW0zOWbpn16gOlJro
    jOSUaz8zX9V6N/PiJAELByfcn0ybjbqpdHWYjvzUAPII7fURiDRmDY0KPB3tcFC8lsTpfw
    YtQ50cDmKiD9cUI4DMusuN3Y2NhjgMq3BZx94ir5Y54y92HC3emnVWGi3+hfcG+LWTcEL2
    whq1Zoyl6/pPzIai2BhqgUS21B4OVHsJTGSeDpReYBoODzQ+wm/tli8K9mSkIMuQCVLrgT
    FOx8jwuZmBBwgmkxORgSXvswvO+0T/g25718OWy0YcF1LBjmQSKgWxLw3XCnSPkpfeiqzV
    uq54NjBe1wFSQH9SZruYoMA9gg3SeJ01pyLHQLRduBJuqf/LxP6UDQCYrAwz22Fn60ynkH
    IWlOLWc7bFGZu3N3JLQo2YM4IYKDYuzyeQOFjh0v8R7mXHSQQ5NLx97G1ol4j8k3rr4vkt
    SG2rL/67Uo0Tzx3utbtd92gKKTmmvV+6k5zzqzK1dihEz/LsjnN5nTtYAyxw
X-ME-Proxy: <xmx:KhsxahU_Id9nMfF9UF0o4hZgq2cv6cBoF031xMkj2t70H7KRzY0j-g>
    <xmx:KhsxametgT9r_CPmedHVOZkj5k2iiAhwoGxtdNksuKjACE4O2u0hUQ>
    <xmx:Khsxaq9vIRHQz_tA-JuWZe-KrdSG_P2vUa-xnyBtKEh2Is-rtorAQw>
    <xmx:KhsxamaXihkXPn1Xyh23IeB5xOpeYjWoIST65vxj-Y77SekmlLzfGg>
    <xmx:Kxsxagc3uwNgGnZMCr8pHTZb4RhyL4gPQzFN2kQ4Q0PAOYwCb_8ALjuz>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Jun 2026 05:45:13 -0400 (EDT)
Date: Tue, 16 Jun 2026 15:14:09 +0530
From: Greg KH <greg@kroah.com>
To: himanshubatra <himanshubatra@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org, vamshigajjela@google.com,
	manugautam@google.com
Subject: Re: [PATCH v2] scsi: ufs: sysfs: Add HS_GEAR6 string in
 power_info/gear sysfs output
Message-ID: <2026061659-enjoyer-boogeyman-25c0@gregkh>
References: <CAEif7DR3KUdhPww-q_Fn6gR6L=V5nrD3EyLn3vi+hWLmS3eU6g@mail.gmail.com>
 <20260616083124.267262-1-himanshubatra@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616083124.267262-1-himanshubatra@google.com>

On Tue, Jun 16, 2026 at 02:01:24PM +0530, himanshubatra wrote:
> In power_info/gear sysfs, currently it supports output only till gear 5.
> If operating mode is gear 6, it outputs "UNKNOWN".
> Add support for HS_GEAR6 string in sysfs output when operating mode
> is gear 6.
> 
> Signed-off-by: himanshubatra <himanshubatra@google.com>
> ---
> 
> Changes in v2:
> - A slightly better comment.
> 
>  drivers/ufs/core/ufs-sysfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 99af3c73f1af..d1f5041fc3c8 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -54,6 +54,7 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_gear_tag gear)
>  	case UFS_HS_G3:	return "HS_GEAR3";
>  	case UFS_HS_G4:	return "HS_GEAR4";
>  	case UFS_HS_G5:	return "HS_GEAR5";
> +	case UFS_HS_G6:	return "HS_GEAR6";
>  	default:	return "UNKNOWN";
>  	}
>  }
> -- 
> 2.54.0.1189.g8c84645362-goog
> 
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- It looks like you did not use your "real" name for the patch on either
  the Signed-off-by: line, or the From: line (both of which have to
  match).  Please read the kernel file,
  Documentation/process/submitting-patches.rst for how to do this
  correctly.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
