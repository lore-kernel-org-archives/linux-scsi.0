From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] fusion: print lan address via %pMR
Date: Tue, 28 May 2013 11:46:38 +0300
Message-ID: <1369730798.29283.221.camel@smile>
References: <1342079727-22040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576Ab3E1Iqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 04:46:42 -0400
In-Reply-To: <1342079727-22040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>


On Thu, 2012-07-12 at 10:55 +0300, Andy Shevchenko wrote: 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/message/fusion/mptbase.c |   14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index d99db56..d202f25 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -2562,10 +2562,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
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
> @@ -6785,8 +6782,7 @@ static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
>  		if (ioc->bus_type == FC) {
>  			if (ioc->pfacts[p].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {
>  				u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
> -				seq_printf(m, "    LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
> -						a[5], a[4], a[3], a[2], a[1], a[0]);
> +				seq_printf(m, "    LanAddr = %pMR\n", a);
>  			}
>  			seq_printf(m, "    WWN = %08X%08X:%08X%08X\n",
>  					ioc->fc_port_page0[p].WWNN.High,
> @@ -6863,8 +6859,7 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
>  
>  	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
>  		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
> -		y += sprintf(buffer+len+y, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
> -			a[5], a[4], a[3], a[2], a[1], a[0]);
> +		y += sprintf(buffer+len+y, ", LanAddr=%pMR", a);
>  	}
>  
>  	y += sprintf(buffer+len+y, ", IRQ=%d", ioc->pci_irq);
> @@ -6897,8 +6892,7 @@ static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int
>  
>  	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
>  		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
> -		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
> -			a[5], a[4], a[3], a[2], a[1], a[0]);
> +		seq_printf(m, ", LanAddr=%pMR", a);
>  	}
>  
>  	seq_printf(m, ", IRQ=%d", ioc->pci_irq);

James, do you have any comments on this one?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
