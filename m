From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: Scsi midlayer question
Date: Mon, 9 Aug 2004 19:39:56 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809223956.GB8782@logos.cnet>
References: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com> <1090001284.2805.10.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11183 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267344AbUHIXmy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 19:42:54 -0400
Content-Disposition: inline
In-Reply-To: <1090001284.2805.10.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Frank Borich <Frank_Borich@us.xyratex.com>, linux-scsi@vger.kernel.org

On Fri, Jul 16, 2004 at 08:08:04PM +0200, Arjan van de Ven wrote:
> On Fri, 2004-07-16 at 19:55, Frank Borich wrote:
> > I can see from a fibre channel trace that my 1 MB I/O transfers are
> > getting cut up into little chunks.
> > Is there any options that can be set when loading the scsi mid layer as
> > a module that will improve
> > io performance or prevent this breakdown for the sg,sd, or even raw
> > drivers.  I am not a driver developer 
> > so please excuse my ignorance here.   Any info or points in the right
> > direction would be greatly apprecited.
> > I am using the 2.4.20 kernel.  
> 
> try the patch I attached.
> 

> --- linux/mm/page_alloc.c.org	2004-06-24 17:36:22.042460920 +0200
> +++ linux/mm/page_alloc.c	2004-06-24 17:38:12.361689848 +0200
> @@ -282,15 +282,13 @@
>  	unsigned long size = 1 << high;
>  
>  	while (high > low) {
> -		if (BAD_RANGE(zone,page))
> -			BUG();
>  		area--;
>  		high--;
>  		size >>= 1;
> -		list_add(&(page)->list, &(area)->free_list);
> -		MARK_USED(index, high, area);
> -		index += size;
> -		page += size;
> +		if (BAD_RANGE(zone,&page[size]))
> +			BUG();
> +		list_add(&page[size].list, &(area)->free_list);
> +		MARK_USED(index + size, high, area);
>  	}
>  	if (BAD_RANGE(zone,page))
>  		BUG();

Arjan, is this a v2.6 based patch? 

v2.4 current doesnt contain such code you are patching...



