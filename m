From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
Date: Sun, 10 Mar 2013 08:22:47 +0000
Message-ID: <1362903765.3003.2.camel@dabdike.int.hansenpartnership.com>
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
Content-Language: en-US
Content-ID: <19E55EEC942AF247B1B31F6E961DDC95@sw.swsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

[missing SCSI cc added]
On Sun, 2013-03-10 at 17:09 +0900, Akinobu Mita wrote:
> This fixes the wrong position of the comment introduced by
> scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 04bf7b8..e44d47e 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>  	}
>  
>  	/* No pending activities shall be there on the vha now */
> -	if (ql2xextended_error_logging & ql_dbg_user)
> -		msleep(prandom_u32() % 10);
> +	if (ql2xextended_error_logging & ql_dbg_user) {
>  		/*
>  		 * Just to see if something falls on the net we have placed
>  		 * below
>  		 */
> -
> +		msleep(prandom_u32() % 10);
> +	}

I don't git a toss if it's random or prandom: Andrew: get rid of it; we
do not sleep in kernel for random intervals whatever the provocation ...
if this is supposed to be a warning or error condition then print
something.

James
