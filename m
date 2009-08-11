From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/14] scsi: use printk_once
Date: Tue, 11 Aug 2009 11:40:13 -0500
Message-ID: <1250008813.4301.55.camel@mulgrave.site>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	 <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52833 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbZHKQkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 12:40:15 -0400
In-Reply-To: <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, 2009-08-09 at 21:54 +0200, Marcin Slusarz wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/53c700.c             |    6 +-----
>  drivers/scsi/cxgb3i/cxgb3i_init.c |    7 +------
>  2 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index f5a9add..c5f4fa7 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -291,7 +291,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
>  	__u8 *memory;
>  	__u32 *script;
>  	struct Scsi_Host *host;
> -	static int banner = 0;
>  	int j;
>  
>  	if(tpnt->sdev_attrs == NULL)
> @@ -385,10 +384,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
>  	else
>  		hostdata->rev = (NCR_700_readb(host, CTEST7_REG)>>4) & 0x0f;
>  	hostdata->fast = (NCR_700_readb(host, CTEST9_REG) == 0);
> -	if (banner == 0) {
> -		printk(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
> -		banner = 1;
> -	}
> +	printk_once(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
>  	printk(KERN_NOTICE "scsi%d: %s rev %d %s\n", host->host_no,
>  	       hostdata->chip710 ? "53c710" :
>  	       (hostdata->fast ? "53c700-66" : "53c700"),
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
> index 042d9bc..8c9285f 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_init.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
> @@ -43,12 +43,7 @@ static struct cxgb3_client t3c_client = {
>   */
>  static void open_s3_dev(struct t3cdev *t3dev)
>  {
> -	static int vers_printed;
> -
> -	if (!vers_printed) {
> -		printk(KERN_INFO "%s", version);
> -		vers_printed = 1;
> -	}
> +	printk_once(KERN_INFO "%s", version);

There's really no point to this beyond code churn.  Both patterns are
correct uses so conversion buys us nothing.

James


