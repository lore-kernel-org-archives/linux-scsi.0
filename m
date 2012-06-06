From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3] usb: storage: add support write cache quirk on usb
 hdd
Date: Wed, 6 Jun 2012 11:57:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206061154100.1788-100000@iolanthe.rowland.org>
References: <1338985247-9720-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338985247-9720-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 6 Jun 2012, Namjae Jeon wrote:

> Add support write cache quirk on usb hdd. scsi driver will be set to wce by detecting write cache quirk in quirk list when plugging usb hdd.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  drivers/usb/storage/scsiglue.c |    6 ++++++
>  drivers/usb/storage/usb.c      |    5 ++++-
>  include/linux/usb/quirks.h     |    3 +++
>  include/linux/usb_usual.h      |    4 +++-
>  4 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a324a5d..f7d0ea5 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -51,6 +51,7 @@
>  #include <scsi/scsi_devinfo.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_eh.h>
> +#include <linux/usb/quirks.h>
>  
>  #include "usb.h"
>  #include "scsiglue.h"
> @@ -230,6 +231,11 @@ static int slave_configure(struct scsi_device *sdev)
>  					US_FL_SCM_MULT_TARG)) &&
>  				us->protocol == USB_PR_BULK)
>  			us->use_last_sector_hacks = 1;
> +
> +		/* Check for the cache quirk present or not */
> +		if (us->pusb_dev->quirks & USB_QUIRK_WRITE_CACHE ||
> +				us->fflags & US_FL_WRITE_CACHE)
> +				sdev->wce_quirk = 1;

This is very wrong.  Your new quirk should be added only to us->fflags, 
not to us->pusb_dev->quirks.

> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -473,7 +473,7 @@ static void adjust_quirks(struct us_data *us)
>  			US_FL_CAPACITY_OK | US_FL_IGNORE_RESIDUE |
>  			US_FL_SINGLE_LUN | US_FL_NO_WP_DETECT |
>  			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
> -			US_FL_INITIAL_READ10);
> +			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE);
>  
>  	p = quirks;
>  	while (*p) {
> @@ -538,6 +538,9 @@ static void adjust_quirks(struct us_data *us)
>  		case 'w':
>  			f |= US_FL_NO_WP_DETECT;
>  			break;
> +		case 'p':
> +			f |= US_FL_WRITE_CACHE;
> +			break;

These cases are in alphabetical order.  Please keep them that way.

Also, if you're going to change a module parameter like this then you 
_must_ update the description in Documentation/kernel-parameters.txt.

> --- a/include/linux/usb/quirks.h
> +++ b/include/linux/usb/quirks.h
> @@ -30,4 +30,7 @@
>     descriptor */
>  #define USB_QUIRK_DELAY_INIT		0x00000040
>  
> +/* Device can't handle cache status request */
> +#define USB_QUIRK_WRITE_CACHE		0x00000080

As mentioned above, this is wrong.

> --- a/include/linux/usb_usual.h
> +++ b/include/linux/usb_usual.h
> @@ -64,7 +64,9 @@
>  	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>  		/* cannot handle READ_CAPACITY_16 */		\
>  	US_FLAG(INITIAL_READ10,	0x00100000)			\
> -		/* Initial READ(10) (and others) must be retried */
> +		/* Initial READ(10) (and others) must be retried */	\
> +	US_FLAG(WRITE_CACHE, 0x00200000)		\

And this is right.  But please try to make your '\' characters line up 
with the existing ones.

> +	/* Cache read status is not correct */

This comment, however is wrong.  The flag applies when the cache status 
is not _available_ rather than when it is not _correct_.

Alan Stern
