From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 20:22:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027192228.GA28395@win.tue.nl>
References: <hch@lst.de> <200210271634.g9RGYAY11441@localhost.localdomain> <20021027173756.A16077@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021027173756.A16077@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, Oct 27, 2002 at 05:37:56PM +0100, Christoph Hellwig wrote:
> On Sun, Oct 27, 2002 at 10:34:09AM -0600, James Bottomley wrote:

Hi Christoph & James,

I see you trying to get this scsicam code do something
that it should not. No 64-bit handling required or even desirable.
Any use of sector_div here is wrong.

I answered this yesterday or the day before or so, but maybe
you did not see the reply.

> --- 1.11/drivers/scsi/scsicam.c	Fri Oct 25 13:31:53 2002
> +++ edited/drivers/scsi/scsicam.c	Sun Oct 27 16:36:31 2002
> @@ -80,11 +80,13 @@
>  	if (ret || ip[0] > 255 || ip[1] > 63) {
>  		ip[0] = 64;
>  		ip[1] = 32;
> -		if (sector_div(capacity, ip[0] * ip[1]) > 65534) {
> +		sector_div(capacity, ip[0] * ip[1]);
> +		if (capacity > 65534) {
>  			ip[0] = 255;
>  			ip[1] = 63;
> +			sector_div(capacity, ip[0] * ip[1]);
>  		}
> -		ip[2] = sector_div(capacity, ip[0] * ip[1]);
> +		ip[2] = capacity;
>  	}
>  
>  	return 0;

Write, e.g.,

	if (ret || ip[0] > 255 || ip[1] > 63) {
		ip[0] = 64;
		ip[1] = 32;
		if ((capacity >> 11) > 65534) {
			ip[0] = 255;
			ip[1] = 63;
		}
		if (capacity > 65535*63*255)
			ip[2] = 65535;
		else
			ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
	}

Andries
