From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] sg: relax 16 byte cdb restriction
Date: Sat, 30 Nov 2013 17:35:39 -0500
Message-ID: <1385850939.8152.2.camel@dabdike>
References: <52718763.9030308@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44435 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196Ab3K3Wfm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Nov 2013 17:35:42 -0500
In-Reply-To: <52718763.9030308@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2013-10-30 at 18:25 -0400, Douglas Gilbert wrote:
> This is essentially the same patch sent 6 weeks ago:
>    http://marc.info/?l=linux-scsi&m=137943733409512&w=2
> re-based on '[PATCH v2] sg: O_EXCL and other lock handling'.
> 
> ChangeLog:
>      - remove the 16 byte CDB (SCSI command) length limit
>        from the sg driver by handling longer CDBs the same
>        way as the bsg driver. Remove comment from sg.h
>        public interface about the cmd_len field being
>        limited to 16 bytes.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 99c643f..4d434b9 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -62,7 +62,7 @@ static int sg_version_num = 30535;    /* 2 digits
> for each component */
>  
>  #ifdef CONFIG_SCSI_PROC_FS
>  #include <linux/proc_fs.h>
> -static char *sg_version_date = "20131029";
> +static char *sg_version_date = "20131030";
>  
>  static int sg_proc_init(void);
>  static void sg_proc_cleanup(void);
> @@ -72,6 +72,9 @@ static void sg_proc_cleanup(void);
>  
>  #define SG_MAX_DEVS 32768
>  
> +#define SG_MAX_CDB_SIZE 255    /* should be 260: spc4r36i 3.1.30 */

This comment doesn't really make sense to the reader: if you mean the
value should be 260 but it can't be set that high because command length
is stored in a u8 in the code, say so.

>  /*
>   * Suppose you want to calculate the formula muldiv(x,m,d)=int(x *
> m / d)
>   * Then when using 32 bit integers x * m may overflow during the
> calculation.
> @@ -574,7 +577,7 @@ sg_write(struct file *filp, const char __user
> *buf, size_t count, loff_t * ppos)
>         Sg_request *srp;
>         struct sg_header old_hdr;
>         sg_io_hdr_t *hp;
> -       unsigned char cmnd[MAX_COMMAND_SIZE];
> +       unsigned char cmnd[SG_MAX_CDB_SIZE];
>  
>         if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp =
> sfp->parentdp)))
>                 return -ENXIO;
> @@ -606,7 +609,7 @@ sg_write(struct file *filp, const char __user
> *buf, size_t count, loff_t * ppos)
>         buf += SZ_SG_HEADER;
>         __get_user(opcode, buf);
>         if (sfp->next_cmd_len > 0) {
> -               if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
> +               if (sfp->next_cmd_len > SG_MAX_CDB_SIZE) {

This comparison is now impossible (and versions of gcc will warn about
it), just remove it.

James


