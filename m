From: Greg KH <greg@kroah.com>
Subject: Re: [RFC] support for sysfs string based properties for SCSI (1/3)
Date: Mon, 5 May 2003 10:02:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030505170202.GA1296@kroah.com>
References: <1051989099.2036.7.camel@mulgrave> <1051989565.2036.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051989565.2036.14.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>, Mike Anderson <andmike@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 03, 2003 at 02:19:23PM -0500, James Bottomley wrote:
> diff -Nru a/drivers/base/core.c b/drivers/base/core.c
> --- a/drivers/base/core.c	Sat May  3 14:18:21 2003
> +++ b/drivers/base/core.c	Sat May  3 14:18:21 2003
> @@ -42,6 +42,8 @@
>  
>  	if (dev_attr->show)
>  		ret = dev_attr->show(dev,buf);
> +	else if (dev->bus->show)
> +		ret = dev->bus->show(dev, buf, attr);
>  	return ret;

Can't you do this by using the class interface instead?

This also forces you to do a lot of string compares within the bus show
function (as your example did) which is almost as unwieldy as just
having individual show functions, right?  :)

thanks,

greg k-h
