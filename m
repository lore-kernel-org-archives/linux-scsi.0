From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 10/26] compat_ioctl: use correct compat_ptr()
 translation in drivers
Date: Wed, 17 Apr 2019 22:21:11 +0100
Message-ID: <20190417212111.GX2217@ZenIV.linux.org.uk>
References: <20190416202013.4034148-1-arnd@arndb.de>
 <20190416202013.4034148-11-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190416202013.4034148-11-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Felipe Balbi <felipe.balbi@linux.intel.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Frank Haverkamp <haver@linux.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Felipe Balbi <balbi@kernel.org>, Jerry Zhang <zhangjerry@google.com>, Vincent Pelletier <plr.vincent@gmail.com>, Andrzej Pietrasiewicz <andrzej.p@collabora.com>, Shen Jing <jingx.shen@intel.com>, linuxppc-dev@list
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 16, 2019 at 10:19:48PM +0200, Arnd Bergmann wrote:
> A handful of drivers all have a trivial wrapper around their ioctl
> handler, but don't call the compat_ptr() conversion function at the
> moment. In practice this does not matter, since none of them are used
> on the s390 architecture and for all other architectures, compat_ptr()
> does not do anything, but using the new compat_ptr_ioctl()
> helper makes it more correct in theory, and simplifies the code.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/misc/cxl/flash.c            |  8 +-------
>  drivers/misc/genwqe/card_dev.c      | 23 +----------------------
>  drivers/scsi/megaraid/megaraid_mm.c | 28 +---------------------------
>  drivers/usb/gadget/function/f_fs.c  | 12 +-----------

ACK, provided that all their ioctls are taking pointers (which is
worth mentioning in commit message, assuming it's true)
