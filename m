From: Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk
 on usb hdd
Date: Sat, 09 Jun 2012 22:42:12 +0400
Message-ID: <4FD39904.2010808@mvista.com>
References: <1339263660-4039-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339263660-4039-1-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello.

On 06/09/2012 09:41 PM, Namjae Jeon wrote:

> Add support for write cache quirk on usb hdd. scsi driver will be set to wce
> by detecting write cache quirk in quirk list when plugging usb hdd.

> Signed-off-by: Namjae Jeon<namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Pankaj Kumar<pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Amit Sahrawat<a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>   drivers/usb/storage/scsiglue.c |    5 +++++
>   drivers/usb/storage/usb.c      |    5 ++++-
>   include/linux/usb_usual.h      |    4 +++-
>   3 files changed, 12 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a324a5d..fe42547 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
[...]
> @@ -529,6 +529,9 @@ static void adjust_quirks(struct us_data *us)
>   		case 'o':
>   			f |= US_FL_CAPACITY_OK;
>   			break;
> +		case 'p':
> +			f |= US_FL_WRITE_CACHE;
> +			break;
>   		case 'r':
>   			f |= US_FL_IGNORE_RESIDUE;
>   			break;

    You probably should unite this chunk with the documentation update patch.

> diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
> index 17df360..96fc152 100644
> --- a/include/linux/usb_usual.h
> +++ b/include/linux/usb_usual.h
> @@ -64,7 +64,9 @@
>   	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>   		/* cannot handle READ_CAPACITY_16 */		\
>   	US_FLAG(INITIAL_READ10,	0x00100000)			\
> -		/* Initial READ(10) (and others) must be retried */
> +		/* Initial READ(10) (and others) must be retried */	\
> +	US_FLAG(WRITE_CACHE, 0x00200000)		\

    You've been already told to keep '\' at the same level with the above '\' 
and you're continuing to ignore this.

> +		/* Write Cache status is not available */
>
>   #define US_FLAG(name, value)	US_FL_##name = value ,
>   enum { US_DO_ALL_FLAGS };

WBR, Sergei
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
