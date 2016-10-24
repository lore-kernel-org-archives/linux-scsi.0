From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v3 2/6] fusion: print lan address via %pMR
Date: Mon, 24 Oct 2016 08:32:39 -0400
Message-ID: <1477312359.17595.1.camel@localhost.localdomain>
References: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
         <20161022173231.170417-3-andriy.shevchenko@linux.intel.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932934AbcJXMcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 08:32:42 -0400
In-Reply-To: <20161022173231.170417-3-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

On Sat, 2016-10-22 at 20:32 +0300, Andy Shevchenko wrote:
> LAN MAC addresses can be printed directly using %pMR specifier.
> 
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/message/fusion/mptbase.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 89c7ed1..f82745c 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -2585,10 +2585,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
>  				(void) GetLanConfigPages(ioc);
>  				a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
>  				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> -					"LanAddr = %02X:%02X:%02X"
> -					":%02X:%02X:%02X\n",
> -					ioc->name, a[5], a[4],
> -					a[3], a[2], a[1], a[0]));
> +					"LanAddr = %pMR\n", ioc->name, a));
>  			}
>  			break;
>  
> @@ -6783,8 +6780,7 @@ static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
>  		if (ioc->bus_type == FC) {
>  			if (ioc->pfacts[p].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {
>  				u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
> -				seq_printf(m, "    LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
> -						a[5], a[4], a[3], a[2], a[1], a[0]);
> +				seq_printf(m, "    LanAddr = %pMR\n", a);
>  			}
>  			seq_printf(m, "    WWN = %08X%08X:%08X%08X\n",
>  					ioc->fc_port_page0[p].WWNN.High,
> @@ -6861,8 +6857,7 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
>  
>  	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
>  		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
> -		y += sprintf(buffer+len+y, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
> -			a[5], a[4], a[3], a[2], a[1], a[0]);
> +		y += sprintf(buffer+len+y, ", LanAddr=%pMR", a);
>  	}
>  
>  	y += sprintf(buffer+len+y, ", IRQ=%d", ioc->pci_irq);
> @@ -6896,8 +6891,7 @@ static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int
>  
>  	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
>  		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
> -		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
> -			a[5], a[4], a[3], a[2], a[1], a[0]);
> +		seq_printf(m, ", LanAddr=%pMR", a);
>  	}
>  
>  	seq_printf(m, ", IRQ=%d", ioc->pci_irq);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


