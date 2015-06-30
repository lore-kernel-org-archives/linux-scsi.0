From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH] SCSI-eata_pio: Deletion of an unnecessary check before
 the function call "pci_dev_put"
Date: Tue, 30 Jun 2015 14:52:35 +0200
Message-ID: <55929113.8070206@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <546E441B.7040004@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:64552 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbbF3Mwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2015 08:52:49 -0400
In-Reply-To: <546E441B.7040004@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 20 Nov 2014 20:37:30 +0100
> 
> The pci_dev_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/scsi/eata_pio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
> index 8319d2b..707f64d 100644
> --- a/drivers/scsi/eata_pio.c
> +++ b/drivers/scsi/eata_pio.c
> @@ -122,8 +122,7 @@ static int eata_pio_release(struct Scsi_Host *sh)
>  			release_region(sh->io_port, sh->n_io_port);
>  	}
>  	/* At this point the PCI reference can go */
> -	if (hd->pdev)
> -		pci_dev_put(hd->pdev);
> +	pci_dev_put(hd->pdev);
>  	return 1;
>  }
>  
> 

Would you like to integrate this update suggestion
into another source code repository?

Regards,
Markus
