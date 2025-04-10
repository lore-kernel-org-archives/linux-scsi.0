Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551DF1C3F36
	for <linux-scsi@vger.kernel.org>; Thu, 10 Apr 2025 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744304599; cv=none; b=oetUvO6gQ3YCJWzZf70R83mi2FKNj3RTrfr7cWPmSEpsDe2DALo8U2Gl+ETbjWC6nVl9+D5+Dm/RYlHOyMbNlT6byvt50ffyf+oq27fi1s/TNGvL1xBQodIeZEfSxqEUhMW+dX6IGJcMeVsBrzhbHKdacVBsdeFo4yZPIH+gOWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744304599; c=relaxed/simple;
	bh=fjxm2YWjP7H15cQU0Et+aSCOnoGFNlxdFcVh7csG3rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGWqUXQD2Jg6C+U46Wc+KRkn2u7pSKKwCUunRo9K+NGkQ/Ge+/CLbYuPa6LkWwQ5tW+H6lYXf6u175LUquEsSIh/2kBGvYhb5foFlPEU5xsLb9ZscjwgxoJ4Ow1aIVLNTx2PQE6NaYm7IGE1vLJ1ODVjjz/L+AU9NTU7pOyAgm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT86naRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT86naRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E16AC4CEDD;
	Thu, 10 Apr 2025 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744304596;
	bh=fjxm2YWjP7H15cQU0Et+aSCOnoGFNlxdFcVh7csG3rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aT86naRLdK1ZdMK+t42jkUy+dpggs7RFZGgNtZ/JC29+Pk1traGh8DJiVlokQ25tY
	 OWa1FJ22qML3NkyzQpRq0YOqTwadGfvbzgFrwbBIRPZIrkxPe3qESghPtRg3ngrdzL
	 4ghY3jmwCuU3fLCIiINNz/G1vIGtMY+t5TG+PXF4=
Date: Thu, 10 Apr 2025 19:01:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: bootc@bootc.net, martin.petersen@oracle.com, Thinh.Nguyen@synopsys.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers: Two potential integer overflow in
 sbp_make_tpg() and usbg_make_tpg()
Message-ID: <2025041025-cozy-pug-fa22@gregkh>
References: <20250410140550.1647-1-chenyufeng@iie.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410140550.1647-1-chenyufeng@iie.ac.cn>

On Thu, Apr 10, 2025 at 10:05:49PM +0800, Chen Yufeng wrote:
> The variable tpgt in sbp_make_tpg() and usbg_make_tpg() is defined as
> unsigned long and is assigned to tpgt->tport_tpgt, which is defined as u16.
> This may cause an integer overflow when tpgt is greater than USHRT_MAX
> (65535). 

Can that actually ever happen?

If so, why not just fix up "tpgt" to be u16?

> My fix is based on the implementation of tcm_qla2xxx_make_tpg() in 
> drivers/scsi/qla2xxx/tcm_qla2xxx.c which limits tpgt to USHRT_MAX.

Again, why not restrict the size of the variable to start with?


> 
> This patch is similar to
> commit 59c816c1f24d ("vhost/scsi: potential memory corruption").
> 
> Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
> ---
>  drivers/target/sbp/sbp_target.c     | 2 +-
>  drivers/usb/gadget/function/f_tcm.c | 2 +-

You have to split this into two different patches as it goes through two
different trees before we could take it.

thanks,

greg k-h
