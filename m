From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] snic: correctly check for array overrun on overly long
 version number
Date: Tue, 01 Mar 2016 12:29:38 -0500
Message-ID: <1456853378.16707.46.camel@localhost.localdomain>
References: <1456441105-19042-1-git-send-email-colin.king@canonical.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456441105-19042-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-02-25 at 22:58 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The snic version number is expected to be 4 decimals in the form like
> a netmask string with each number stored in an element in array v.
> However, there is an off-by-one check on the number of elements in v
> allowing one to pass a 5 decimal version number causing v[4] to be
> referenced, causing a buffer overrun.  Fix the off-by-one error by
> comparing to i > 3 rather than 4.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/snic/snic_ctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/snic/snic_ctl.c b/drivers/scsi/snic/snic_ctl.c
> index aebe753..ab0e06b 100644
> --- a/drivers/scsi/snic/snic_ctl.c
> +++ b/drivers/scsi/snic/snic_ctl.c
> @@ -75,7 +75,7 @@ snic_ver_enc(const char *s)
>  			continue;
>  		}
>  
> -		if (i > 4 || !isdigit(c))
> +		if (i > 3 || !isdigit(c))
>  			goto end;
>  
>  		v[i] = v[i] * 10 + (c - '0');

        int v[4] = {0};

So clearly the i > 4 test is wrong and should be i > 3.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
