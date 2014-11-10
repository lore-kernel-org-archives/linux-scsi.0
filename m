From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Mon, 10 Nov 2014 11:37:06 -0600
Message-ID: <5460F7C2.6040205@cs.wisc.edu>
References: <84b5cd32-3bb6-4541-bbc1-4cbe92c074c6@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49988 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbaKJRhR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 12:37:17 -0500
In-Reply-To: <84b5cd32-3bb6-4541-bbc1-4cbe92c074c6@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Adding Vikas to verify if qla4xxx has the same issue.

On 11/10/2014 12:52 AM, Minh Duc Tran wrote:
> From: Minh Tran minhduc.tran@emulex.com <mailto:minhduc.tran@emulex.com>
> 
>  
> 
>                We are starting to see problems with certain open-iscsi
> versions out there checking block valid bit.  Iscsi boot target login
> will not happen without this bit being set.
> 

What versions of open-iscsi? Is it just the SUSE based versions?

>  
> 
> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> 
> ---
> 
> scsi/be2iscsi/be_main.c |    4 ++--
> 
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
>  
> 
> diff --git a/scsi/be2iscsi/be_main.c b/scsi/be2iscsi/be_main.c
> 
> index 30d74a0..aacf223 100644
> 
> --- a/scsi/be2iscsi/be_main.c
> 
> +++ b/scsi/be2iscsi/be_main.c
> 
> @@ -429,7 +429,7 @@ static ssize_t beiscsi_show_boot_tgt_info(void
> *data, int type, char *buf)
> 
>                              auth_data.chap.intr_secret);
> 
>                 break;
> 
>         case ISCSI_BOOT_TGT_FLAGS:
> 
> -               rc = sprintf(str, "2\n");
> 
> +               rc = sprintf(str, "3\n");
> 
>                 break;
> 
>         case ISCSI_BOOT_TGT_NIC_ASSOC:
> 
>                 rc = sprintf(str, "0\n");
> 
> @@ -466,7 +466,7 @@ static ssize_t beiscsi_show_boot_eth_info(void
> *data, int type, char *buf)
> 
>  
> 
>         switch (type) {
> 
>         case ISCSI_BOOT_ETH_FLAGS:
> 
> -               rc = sprintf(str, "2\n");
> 
> +               rc = sprintf(str, "3\n");
> 
>                 break;
> 
>         case ISCSI_BOOT_ETH_INDEX:
> 
>                 rc = sprintf(str, "0\n");
> 

I think we want to move SYSFS_FLAG_FW_SEL_BOOT from ql4_def.h to
include/linux/iscsi_boot_sysfs.h (also add a ISCSI_BOOT_ prefix), and
then have both drivers use it.

