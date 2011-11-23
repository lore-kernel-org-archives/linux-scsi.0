From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH] bnx2fc: Reduce object size by consolidating formats
Date: Tue, 22 Nov 2011 17:47:03 -0800
Message-ID: <4ECC5097.2050908@broadcom.com>
References: <fe83ffc5f085b65765262b3c5c74740eb82c9442.1321738492.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fe83ffc5f085b65765262b3c5c74740eb82c9442.1321738492.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/19/2011 1:35 PM, Joe Perches wrote:
> Deduplication of formats and consolidating tests
> makes the object much smaller.
>
> Add bnx2fc_debug.c, add functions for a few logging
> functions (BNX2FC_IO_DBG, BNX2FC_TGT_DBG, BNX2FC_HBA_DBG).
> Use printf extension %pV.
> Add and use pr_fmt and pr_<level>.
> Move the debug #include below structure definitions.
>
> $ size drivers/scsi/bnx2fc/built-in.o*
>     text	   data	    bss	    dec	    hex	filename
>   101563	   1165	  24976	 127704	  1f2d8	drivers/scsi/bnx2fc/built-in.o.new
>   138473	   1109	  33400	 172982	  2a3b6	drivers/scsi/bnx2fc/built-in.o.old
>
> Signed-off-by: Joe Perches<joe@perches.com>
Thanks Joe.

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

> ---
>   drivers/scsi/bnx2fc/Makefile       |    3 +-
>   drivers/scsi/bnx2fc/bnx2fc.h       |    6 ++-
>   drivers/scsi/bnx2fc/bnx2fc_debug.c |   70 ++++++++++++++++++++++++++++++++++
>   drivers/scsi/bnx2fc/bnx2fc_debug.h |   73 +++++++++---------------------------
>   4 files changed, 95 insertions(+), 57 deletions(-)
>   create mode 100644 drivers/scsi/bnx2fc/bnx2fc_debug.c
>
> diff --git a/drivers/scsi/bnx2fc/Makefile b/drivers/scsi/bnx2fc/Makefile
> index a92695a..141149e 100644
> --- a/drivers/scsi/bnx2fc/Makefile
> +++ b/drivers/scsi/bnx2fc/Makefile
> @@ -1,3 +1,4 @@
>   obj-$(CONFIG_SCSI_BNX2X_FCOE) += bnx2fc.o
>
> -bnx2fc-y := bnx2fc_els.o bnx2fc_fcoe.o bnx2fc_hwi.o bnx2fc_io.o bnx2fc_tgt.o
> +bnx2fc-y := bnx2fc_els.o bnx2fc_fcoe.o bnx2fc_hwi.o bnx2fc_io.o bnx2fc_tgt.o \
> +	    bnx2fc_debug.o
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> index 049ea90..8fbf44f 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -11,6 +11,8 @@
>    * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
>    */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>   #include<linux/module.h>
>   #include<linux/moduleparam.h>
>   #include<linux/kernel.h>
> @@ -57,7 +59,6 @@
>   #include<scsi/fc/fc_fcp.h>
>
>   #include "57xx_hsi_bnx2fc.h"
> -#include "bnx2fc_debug.h"
>   #include "../../net/ethernet/broadcom/cnic_if.h"
>   #include "bnx2fc_constants.h"
>
> @@ -547,4 +548,7 @@ void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnup_req,
>   int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offset,
>   				enum fc_rctl r_ctl);
>
> +
> +#include "bnx2fc_debug.h"
> +
>   #endif
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.c b/drivers/scsi/bnx2fc/bnx2fc_debug.c
> new file mode 100644
> index 0000000..0cbee1b
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/bnx2fc_debug.c
> @@ -0,0 +1,70 @@
> +#include "bnx2fc.h"
> +
> +void BNX2FC_IO_DBG(const struct bnx2fc_cmd *io_req, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (likely(!(bnx2fc_debug_level&  LOG_IO)))
> +		return;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va =&args;
> +
> +	if (io_req&&  io_req->port&&  io_req->port->lport&&
> +	    io_req->port->lport->host)
> +		shost_printk(KERN_INFO, io_req->port->lport->host,
> +			     PFX "xid:0x%x %pV",
> +			     io_req->xid,&vaf);
> +	else
> +		pr_info("NULL %pV",&vaf);
> +
> +	va_end(args);
> +}
> +
> +void BNX2FC_TGT_DBG(const struct bnx2fc_rport *tgt, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (likely(!(bnx2fc_debug_level&  LOG_TGT)))
> +		return;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va =&args;
> +
> +	if (tgt&&  tgt->port&&  tgt->port->lport&&  tgt->port->lport->host&&
> +	    tgt->rport)
> +		shost_printk(KERN_INFO, tgt->port->lport->host,
> +			     PFX "port:%x %pV",
> +			     tgt->rport->port_id,&vaf);
> +	else
> +		pr_info("NULL %pV",&vaf);
> +
> +	va_end(args);
> +}
> +
> +void BNX2FC_HBA_DBG(const struct fc_lport *lport, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	if (likely(!(bnx2fc_debug_level&  LOG_HBA)))
> +		return;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va =&args;
> +
> +	if (lport&&  lport->host)
> +		shost_printk(KERN_INFO, lport->host, PFX "%pV",&vaf);
> +	else
> +		pr_info("NULL %pV",&vaf);
> +
> +	va_end(args);
> +}
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.h b/drivers/scsi/bnx2fc/bnx2fc_debug.h
> index 3416d9a..4808ff9 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_debug.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc_debug.h
> @@ -11,60 +11,23 @@
>
>   extern unsigned int bnx2fc_debug_level;
>
> -#define BNX2FC_CHK_LOGGING(LEVEL, CMD)					\
> -	do {								\
> -		if (unlikely(bnx2fc_debug_level&  LEVEL))		\
> -			do {						\
> -				CMD;					\
> -			} while (0);					\
> -	} while (0)
> -
> -#define BNX2FC_ELS_DBG(fmt, arg...)					\
> -	BNX2FC_CHK_LOGGING(LOG_ELS,					\
> -			   printk(KERN_INFO PFX fmt, ##arg))
> -
> -#define BNX2FC_MISC_DBG(fmt, arg...)					\
> -	BNX2FC_CHK_LOGGING(LOG_MISC,					\
> -			   printk(KERN_INFO PFX fmt, ##arg))
> -
> -#define BNX2FC_IO_DBG(io_req, fmt, arg...)				\
> -	do {								\
> -		if (!io_req || !io_req->port || !io_req->port->lport ||	\
> -		    !io_req->port->lport->host)				\
> -			BNX2FC_CHK_LOGGING(LOG_IO,			\
> -			   printk(KERN_INFO PFX "NULL " fmt, ##arg));	\
> -		else							\
> -			BNX2FC_CHK_LOGGING(LOG_IO,			\
> -			   shost_printk(KERN_INFO,			\
> -				   (io_req)->port->lport->host,		\
> -				   PFX "xid:0x%x " fmt,			\
> -				   (io_req)->xid, ##arg));		\
> -	} while (0)
> -
> -#define BNX2FC_TGT_DBG(tgt, fmt, arg...)				\
> -	do {								\
> -		if (!tgt || !tgt->port || !tgt->port->lport ||		\
> -		    !tgt->port->lport->host || !tgt->rport)		\
> -			BNX2FC_CHK_LOGGING(LOG_TGT,			\
> -			   printk(KERN_INFO PFX "NULL " fmt, ##arg));	\
> -		else							\
> -			BNX2FC_CHK_LOGGING(LOG_TGT,			\
> -			   shost_printk(KERN_INFO,			\
> -				   (tgt)->port->lport->host,		\
> -				   PFX "port:%x " fmt,			\
> -				   (tgt)->rport->port_id, ##arg));	\
> -	} while (0)
> -
> -
> -#define BNX2FC_HBA_DBG(lport, fmt, arg...)				\
> -	do {								\
> -		if (!lport || !lport->host)				\
> -			BNX2FC_CHK_LOGGING(LOG_HBA,			\
> -			   printk(KERN_INFO PFX "NULL " fmt, ##arg));	\
> -		else							\
> -			BNX2FC_CHK_LOGGING(LOG_HBA,			\
> -			   shost_printk(KERN_INFO, lport->host,	\
> -				   PFX fmt, ##arg));			\
> -	} while (0)
> +#define BNX2FC_ELS_DBG(fmt, ...)				\
> +do {								\
> +	if (unlikely(bnx2fc_debug_level&  LOG_ELS))		\
> +		pr_info(fmt, ##__VA_ARGS__);			\
> +} while (0)
> +
> +#define BNX2FC_MISC_DBG(fmt, ...)				\
> +do {								\
> +	if (unlikely(bnx2fc_debug_level&  LOG_MISC))		\
> +		pr_info(fmt, ##__VA_ARGS__);			\
> +} while (0)
> +
> +__printf(2, 3)
> +void BNX2FC_IO_DBG(const struct bnx2fc_cmd *io_req, const char *fmt, ...);
> +__printf(2, 3)
> +void BNX2FC_TGT_DBG(const struct bnx2fc_rport *tgt, const char *fmt, ...);
> +__printf(2, 3)
> +void BNX2FC_HBA_DBG(const struct fc_lport *lport, const char *fmt, ...);
>
>   #endif
