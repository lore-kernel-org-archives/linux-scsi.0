From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: [patch 14/17] aic7xxx: ahc_pci_write_config() fix
Date: Fri, 21 Apr 2006 03:59:00 +0900
Message-ID: <4447D9F4.6000800@yk.rim.or.jp>
References: <200604190410.k3J4A3R4008248@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 61.70.150.220.ap.yournet.ne.jp ([220.150.70.61]:65159 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S1750744AbWDTTGL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 15:06:11 -0400
Received: from [127.0.0.1] (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1FWeNa-002GJKC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2006 03:59:50 +0900 (JST)
In-Reply-To: <200604190410.k3J4A3R4008248@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, vda@ilport.com.ua

Can anyone explain with these incorrect(?) calls
how the current aic7xxx has been working for me for a few months?
Sorry, I am not using the latest and greatest kernel version, still...

Linux duron 2.6.15.6-test-tmscsim #6 Wed Mar 29 02:02:01 JST 2006 i686 GNU/Linux

And the version of aci7xxx driver : from the
output of demsg:
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0


Are these parameters one of those not so important
parameters? Yet, it might explain the problem of Mutt Hamlet and
a few others.




akpm@osdl.org wrote:
> From: Denis Vlasenko <vda@ilport.com.ua>
> 
> Fix ahc_pci_write_config's (wrong order of arguments).
> 
> Signed-off-by: Denis Vlasenko <vda@ilport.com.ua>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/aic7xxx/aic7xxx_pci.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~aic7xxx-ahc_pci_write_config-fix drivers/scsi/aic7xxx/aic7xxx_pci.c
> --- devel/drivers/scsi/aic7xxx/aic7xxx_pci.c~aic7xxx-ahc_pci_write_config-fix	2006-04-10 00:19:55.000000000 -0700
> +++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_pci.c	2006-04-10 00:19:55.000000000 -0700
> @@ -2036,12 +2036,12 @@ ahc_pci_resume(struct ahc_softc *ahc)
>  	 * that the OS doesn't know about and rely on our chip
>  	 * reset handler to handle the rest.
>  	 */
> -	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG, /*bytes*/4,
> -			     ahc->bus_softc.pci_softc.devconfig);
> -	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND, /*bytes*/1,
> -			     ahc->bus_softc.pci_softc.command);
> -	ahc_pci_write_config(ahc->dev_softc, CSIZE_LATTIME, /*bytes*/1,
> -			     ahc->bus_softc.pci_softc.csize_lattime);
> +	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG,
> +			     ahc->bus_softc.pci_softc.devconfig, /*bytes*/4);
> +	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND,
> +			     ahc->bus_softc.pci_softc.command, /*bytes*/1);
> +	ahc_pci_write_config(ahc->dev_softc, CSIZE_LATTIME,
> +			     ahc->bus_softc.pci_softc.csize_lattime, /*bytes*/1);
>  	if ((ahc->flags & AHC_HAS_TERM_LOGIC) != 0) {
>  		struct	seeprom_descriptor sd;
>  		u_int	sxfrctl1;
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
int main(void){int j=2006;/*(c)2006 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="d>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=(int)strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
