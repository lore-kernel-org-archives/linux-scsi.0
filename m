From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Mon, 28 Oct 2002 01:50:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028005053.GA28587@win.tue.nl>
References: <20021027221007.GA28417@win.tue.nl> <200210280005.g9S057Q14567@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210280005.g9S057Q14567@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sun, Oct 27, 2002 at 06:05:07PM -0600, James Bottomley wrote:

> If the return type will be ignored by most applications, I don't see
> what the problem is.

There is no problem. My longish reaction was mostly because you used
"future proofing", that gave the impression that you did not know
what this is about.

> (like an obviously wrong truncation)

No, the code I wrote was optimal.
If you have 16 bits and the value is 70000, I prefer returning
65535 over 4464.

Remember: this code has one and only one function: to compute
the 16-bit value that HDIO_GETGEO is going to return.

For modern software this does not matter in the least.
For ancient stuff, in the case of overflow, my patch gives the disk
a size of 539 GB. The patch I objected to gives a random size.

Andries

By the way: quite apart from the fact that sector_div is
superfluous, it is also a very obscure and nonintuitive function.
We can see that from the fact that several incorrect versions
were proposed already. And the latest one I saw:

> --- 1.11/drivers/scsi/scsicam.c       Fri Oct 25 13:31:53 2002
> +++ edited/drivers/scsi/scsicam.c     Sun Oct 27 16:36:31 2002
> @@ -80,11 +80,13 @@
>       if (ret || ip[0] > 255 || ip[1] > 63) {
>               ip[0] = 64;
>               ip[1] = 32;
> -             if (sector_div(capacity, ip[0] * ip[1]) > 65534) {
> +             sector_div(capacity, ip[0] * ip[1]);
> +             if (capacity > 65534) {
>                       ip[0] = 255;
>                       ip[1] = 63;
> +                     sector_div(capacity, ip[0] * ip[1]);
>               }
> -             ip[2] = sector_div(capacity, ip[0] * ip[1]);
> +             ip[2] = capacity;
>       }
>  
>       return 0;

is also incorrect: it divides capacity twice.


