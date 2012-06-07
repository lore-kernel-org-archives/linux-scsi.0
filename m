From: Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] usb: storage: add support write cache quirk on usb
 hdd
Date: Thu, 07 Jun 2012 16:23:17 +0400
Message-ID: <4FD09D35.9020505@mvista.com>
References: <1338985247-9720-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338985247-9720-1-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello.

On 06-06-2012 16:20, Namjae Jeon wrote:

> Add support

    You missed "for" here and in the subject.

> write cache quirk on usb hdd. scsi driver will be set to wce by detecting write cache quirk in quirk list when plugging usb hdd.

> Signed-off-by: Namjae Jeon<namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Pankaj Kumar<pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Amit Sahrawat<a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>   drivers/usb/storage/scsiglue.c |    6 ++++++
>   drivers/usb/storage/usb.c      |    5 ++++-
>   include/linux/usb/quirks.h     |    3 +++
>   include/linux/usb_usual.h      |    4 +++-
>   4 files changed, 16 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a324a5d..f7d0ea5 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
[...]
> @@ -230,6 +231,11 @@ static int slave_configure(struct scsi_device *sdev)
>   					US_FL_SCM_MULT_TARG))&&
>   				us->protocol == USB_PR_BULK)
>   			us->use_last_sector_hacks = 1;
> +
> +		/* Check for the cache quirk present or not */
> +		if (us->pusb_dev->quirks & USB_QUIRK_WRITE_CACHE ||
> +				us->fflags & US_FL_WRITE_CACHE)
> +				sdev->wce_quirk = 1;

    You overindented the last statement, so that it looks a bit like a 
continuation of previous *if*.

WBR, Sergei
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
