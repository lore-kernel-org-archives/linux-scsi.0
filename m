From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] xen-scsiback: use DRV_PFX in the pr macros and
 DPRINTK
Date: Wed, 04 Mar 2015 08:32:19 -0800
Message-ID: <1425486739.2712.12.camel@perches.com>
References: <1425493951-41801-1-git-send-email-boby.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425493951-41801-1-git-send-email-boby.chen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tao Chen <boby.chen@huawei.com>
Cc: jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wu.wubin@huawei.com, rudy.zhangmin@huawei.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-03-04 at 18:32 +0000, Tao Chen wrote:
> Defined the string of {xen-pvscsi: } as DRV_PFX, then use it in the pr sentences and DPRINTK.
> Also fixed up some comments just as eliminate redundant white spaces and format the code.
> These will make the code easier to read.

It'd probaby be better just to use pr_fmt
before any include and remove all the DRV_PRV uses

#define pr_fmt(fmt) "xen-pvscsi: " fmt

> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
[]
> @@ -69,8 +69,10 @@
>  #include <xen/interface/grant_table.h>
>  #include <xen/interface/io/vscsiif.h>
>  
> +#define DRV_PFX "xen-pvscsi: "
>  #define DPRINTK(_f, _a...)			\
> -	pr_debug("(file=%s, line=%d) " _f, __FILE__ , __LINE__ , ## _a)
> +	pr_debug(DRV_PFX "(file=%s, line=%d) " _f,	\
> +			__FILE__ , __LINE__ , ## _a)

I'd also remove DPRINTK and just use pr_debug directly
as dynamic_debug can emit file and line as desired.

> @@ -84,7 +86,7 @@ struct ids_tuple {
>  
>  struct v2p_entry {
>  	struct ids_tuple v;		/* translate from */
> -	struct scsiback_tpg *tpg;	/* translate to   */
> +	struct scsiback_tpg *tpg;	/* translate to */

superfluous change.
