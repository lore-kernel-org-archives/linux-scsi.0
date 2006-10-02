From: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: [RFC PATCH] move aic7xxx to pci_request_irq
Date: Mon, 2 Oct 2006 21:02:46 +0000
Message-ID: <20061002210246.GG3003@slug>
References: <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org> <20061001142807.GD16272@parisc-linux.org> <1159729523.2891.408.camel@laptopd505.fenrus.org> <20061001193616.GF16272@parisc-linux.org> <1159755141.2891.434.camel@laptopd505.fenrus.org> <20061002200048.GC3003@slug> <20061002200703.GD3003@slug> <20061002182744.GM16272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:48155 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S965320AbWJBTEN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 15:04:13 -0400
Received: by ug-out-1314.google.com with SMTP id o38so543373ugd
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 12:04:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20061002182744.GM16272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, "Linux-Kernel," <linux-kernel@vger.kernel.org>, "J.A. Magall??n" <jamagallon@ono.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>

On Mon, Oct 02, 2006 at 12:27:44PM -0600, Matthew Wilcox wrote:
> On Mon, Oct 02, 2006 at 08:07:03PM +0000, Frederik Deweerdt wrote:
> > +++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> > @@ -341,12 +341,12 @@ ahd_pci_map_int(struct ahd_softc *ahd)
> >  {
> >  	int error;
> >  
> > -	error = request_irq(ahd->dev_softc->irq, ahd_linux_isr,
> > -			    IRQF_SHARED, "aic79xx", ahd);
> > +	error = pci_request_irq(ahd->dev_softc, ahd_linux_isr,
> > +			    IRQF_SHARED, "aic79xx");
> >  	if (!error)
> >  		ahd->platform_data->irq = ahd->dev_softc->irq;
> >  	
> > -	return (-error);
> > +	return error;
> 
> Seems unsafe to me.
It is, it slipped through the patches, I didn't mean to send it to the
list :(. Please ignore that.
> 
> > -	
> > -	return (-error);
> > -}
> >  
> > +	return error;
> > +}
> 
> Ditto.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
