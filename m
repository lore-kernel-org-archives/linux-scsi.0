From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 13/29] compat_ioctl: move more drivers to compat_ptr_ioctl
Date: Tue, 30 Jul 2019 13:14:52 -0700
Message-ID: <CAPcyv4i_nHzV155RcgnAQ189aq2Lfd2g8pA1D5NbZqo9E_u+Dw@mail.gmail.com>
References: <20190730192552.4014288-1-arnd@arndb.de> <20190730195819.901457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190730195819.901457-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qat-linux-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:DMA BUFFER SHARING FRAMEWORK" <linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Maling
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 30, 2019 at 12:59 PM Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>
> The .ioctl and .compat_ioctl file operations have the same prototype so
> they can both point to the same function, which works great almost all
> the time when all the commands are compatible.
>
> One exception is the s390 architecture, where a compat pointer is only
> 31 bit wide, and converting it into a 64-bit pointer requires calling
> compat_ptr(). Most drivers here will never run in s390, but since we now
> have a generic helper for it, it's easy enough to use it consistently.
>
> I double-checked all these drivers to ensure that all ioctl arguments
> are used as pointers or are ignored, but are not interpreted as integer
> values.
>
> Acked-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
> Acked-by: Darren Hart (VMware) <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Acked-by: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Acked-by: Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  drivers/nvdimm/bus.c                        | 4 ++--
[..]
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 798c5c4aea9c..6ca142d833ab 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -1229,7 +1229,7 @@ static const struct file_operations nvdimm_bus_fops = {
>         .owner = THIS_MODULE,
>         .open = nd_open,
>         .unlocked_ioctl = bus_ioctl,
> -       .compat_ioctl = bus_ioctl,
> +       .compat_ioctl = compat_ptr_ioctl,
>         .llseek = noop_llseek,
>  };
>
> @@ -1237,7 +1237,7 @@ static const struct file_operations nvdimm_fops = {
>         .owner = THIS_MODULE,
>         .open = nd_open,
>         .unlocked_ioctl = dimm_ioctl,
> -       .compat_ioctl = dimm_ioctl,
> +       .compat_ioctl = compat_ptr_ioctl,
>         .llseek = noop_llseek,
>  };

Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
