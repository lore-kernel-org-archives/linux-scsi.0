From: Christoph Hellwig <hch@infradead.org>
Subject: Re: zalon/ncr53c720 crashes K460  (parisc port) on bootup.
Date: Sat, 27 Sep 2003 19:43:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030927194319.A30759@infradead.org>
References: <1064634188.641.27.camel@laptop.bradetich.net> <1064677551.2002.20.camel@mulgrave> <20030927183756.GT24824@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:38924 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262129AbTI0Sn2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 14:43:28 -0400
Content-Disposition: inline
In-Reply-To: <20030927183756.GT24824@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Sat, Sep 27, 2003 at 07:37:56PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Ryan Bradetich <rbradetich@uswest.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, PARISC list <parisc-linux@lists.parisc-linux.org>

On Sat, Sep 27, 2003 at 07:37:56PM +0100, Matthew Wilcox wrote:
> -       struct host_data *host_data = (struct host_data *)host->hostdata;
> +       struct host_data *host_data;
>  #ifdef DEBUG_NCR53C8XX
>         printk("ncr53c8xx: release\n");
>  #endif
> -       if (host_data->ncb)
> +       if (!host)
> +               return 1;
> +       host_data = (struct host_data *)host->hostdata;
> +       if (host_data && host_data->ncb)
>                 ncr_detach(host_data->ncb);
>         return 1;
>  }
> 
> and it does fix the problem.  Maybe it's too much checking, but I'm not
> interested in tracking down bugs like this again ;-)

Or better just stop calling ncr53c8xx_release if ncr_attach failed..

