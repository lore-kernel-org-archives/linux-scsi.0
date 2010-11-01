From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch] scsi: netlink: avoid including netlink interface in scsi
 module
Date: Sun, 31 Oct 2010 20:19:48 -0700
Message-ID: <4CCE31D4.3050008@oracle.com>
References: <alpine.LNX.2.01.1010311949300.17994@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29648 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0KADVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2010 23:21:47 -0400
In-Reply-To: <alpine.LNX.2.01.1010311949300.17994@obet.zrqbmnf.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On 10/31/10 11:50, Jan Engelhardt wrote:
> parent 3985c7ce85039adacdf882904ca096f091d39346 (v2.6.36-9871-g3985c7c)
> commit 150bc5749967d77b4d1177744d26bf7065f8ee07
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sat Oct 30 19:51:53 2010 +0200
> 
> scsi: netlink: avoid including netlink interface in scsi module
> 
> Only scsi_transport_fc needs it, so don't include it in scsi_mod
> if fc=m.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Mostly looks good to me, just one warning:

drivers/scsi/scsi_netlink.c:678: warning: initialization from incompatible pointer type

The init() function should return an int (status/error code).

> ---
>  drivers/scsi/Kconfig        |    3 ++-
>  drivers/scsi/Makefile       |    2 +-
>  drivers/scsi/scsi.c         |    3 ---
>  drivers/scsi/scsi_netlink.c |   11 ++++++-----
>  drivers/scsi/scsi_priv.h    |    7 +------
>  5 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 8616496..b4e1e2d 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -48,8 +48,9 @@ config SCSI_TGT
>  	  If you choose M, the module will be called scsi_tgt.
>  
>  config SCSI_NETLINK
> -	bool
> +	tristate "SCSI Netlink interface"
>  	default	n
> +	depends on SCSI
>  	select NET
>  
>  config SCSI_PROC_FS
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 2e9a87e..0870038 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -161,7 +161,7 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
>  				   scsicam.o scsi_error.o scsi_lib.o
>  scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
>  scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
> -scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
> +obj-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
>  scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
>  scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
>  scsi_mod-y			+= scsi_trace.o
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 348fba0..31a07b1 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1335,8 +1335,6 @@ static int __init init_scsi(void)
>  	if (error)
>  		goto cleanup_sysctl;
>  
> -	scsi_netlink_init();
> -
>  	printk(KERN_NOTICE "SCSI subsystem initialized\n");
>  	return 0;
>  
> @@ -1357,7 +1355,6 @@ cleanup_queue:
>  
>  static void __exit exit_scsi(void)
>  {
> -	scsi_netlink_exit();
>  	scsi_sysfs_unregister();
>  	scsi_exit_sysctl();
>  	scsi_exit_hosts();
> diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
> index d53e650..348fced 100644
> --- a/drivers/scsi/scsi_netlink.c
> +++ b/drivers/scsi/scsi_netlink.c
> @@ -18,6 +18,7 @@
>   *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   *
>   */
> +#include <linux/module.h>
>  #include <linux/time.h>
>  #include <linux/jiffies.h>
>  #include <linux/security.h>
> @@ -481,8 +482,7 @@ EXPORT_SYMBOL_GPL(scsi_nl_remove_driver);
>   * 	the SCSI transport netlink interface
>   *
>   **/
> -void
> -scsi_netlink_init(void)
> +static void __init scsi_netlink_init(void)
>  {
>  	int error;
>  
> @@ -519,8 +519,7 @@ scsi_netlink_init(void)
>   * scsi_netlink_exit - Called by SCSI subsystem to disable the SCSI transport netlink interface
>   *
>   **/
> -void
> -scsi_netlink_exit(void)
> +static void __exit scsi_netlink_exit(void)
>  {
>  	scsi_nl_remove_transport(SCSI_NL_TRANSPORT);
>  
> @@ -676,4 +675,6 @@ send_vendor_fail:
>  }
>  EXPORT_SYMBOL(scsi_nl_send_vendor_msg);
>  
> -
> +module_init(scsi_netlink_init);
> +module_exit(scsi_netlink_exit);
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index b4056d1..55fba9e 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -136,13 +136,8 @@ extern struct bus_type scsi_bus_type;
>  extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
>  
>  /* scsi_netlink.c */
> -#ifdef CONFIG_SCSI_NETLINK
> -extern void scsi_netlink_init(void);
> -extern void scsi_netlink_exit(void);
> +#if defined(CONFIG_SCSI_NETLINK) || defined(CONFIG_SCSI_NETLINK_MODULE)
>  extern struct sock *scsi_nl_sock;
> -#else
> -static inline void scsi_netlink_init(void) {}
> -static inline void scsi_netlink_exit(void) {}
>  #endif
>  
>  /* scsi_pm.c */


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
