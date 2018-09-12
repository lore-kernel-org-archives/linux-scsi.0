From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 03/17] compat_ioctl: use correct compat_ptr()
 translation in drivers
Date: Wed, 12 Sep 2018 20:13:09 +0200
Message-ID: <20180912181309.GA15031@kroah.com>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912150142.157913-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180912150142.157913-3-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frank Haverkamp <haver@linux.vnet.ibm.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Felipe Balbi <balbi@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 12, 2018 at 05:01:04PM +0200, Arnd Bergmann wrote:
> A handful of drivers all have a trivial wrapper around their ioctl
> handler, but don't call the compat_ptr() conversion function at the
> moment. In practice this does not matter, since none of them are used
> on the s390 architecture and for all other architectures, compat_ptr()
> does not do anything, but using the new generic_compat_ioctl_ptrarg
> helper makes it more correct in theory, and simplifies the code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/misc/cxl/flash.c            |  8 +-------
>  drivers/misc/genwqe/card_dev.c      | 23 +----------------------
>  drivers/scsi/megaraid/megaraid_mm.c | 28 +---------------------------
>  drivers/usb/gadget/function/f_fs.c  | 12 +-----------
>  4 files changed, 4 insertions(+), 67 deletions(-)

Nice cleanup on this series!

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
