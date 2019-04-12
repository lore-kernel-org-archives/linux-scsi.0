From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] scsi: qedf: replace memset/memcpy with safer strscpy
Date: Fri, 12 Apr 2019 11:36:27 +0200
Message-ID: <1f51ff1c-bd1a-2b77-fd5f-77fb873111e9@rasmusvillemoes.dk>
References: <20190412090552.26925-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412090552.26925-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/04/2019 11.05, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the qedf_dbg_* family of functions can overrun the end
> of the source string if it is less than the destination buffer
> length because of the use of a fixed sized memcpy. Replace the
> memset/memcpy calls with the safer strscpy as this won't overrun
> the end of the source string and it ensures the destination
> string is always terminated with NUL.
> 
> Addresses-Coverity: ("Out-of-bounds access")
> Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qedf/qedf_dbg.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
> index f2397ee9ba69..b491bebeaca9 100644
> --- a/drivers/scsi/qedf/qedf_dbg.c
> +++ b/drivers/scsi/qedf/qedf_dbg.c
> @@ -17,8 +17,7 @@ qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
>  	struct va_format vaf;
>  	char nfunc[32];
>  
> -	memset(nfunc, 0, sizeof(nfunc));
> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
> +	strscpy(nfunc, func, sizeof(nfunc));

Why not drop the pointless nfunc and stack copying and just pass func as
the %s parameter; these are only called via macros that pass __func__ as
the func argument, and that is always a proper nul-terminated string.

Rasmus
