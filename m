From: Joe Carnuccio <joe.carnuccio@qlogic.com>
Subject: RE: [PATCH] [RFC] qla2xxx: Change parameter permissions in sysfs
Date: Thu, 18 Nov 2010 11:33:12 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872242EF99D@AVEXMB1.qlogic.org>
References: <1290078346-3521-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290078346-3521-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sonny,

The qla2xxx parameters that already had write permission do not require rebinding.

The qla2xxx parameters that require rebinding have read only permission and do not require write persmission since these are the ones whose value can be set on driver load.

The fact that some of the qla2xxx parameters had permission set to S_IRUGO|S_IRUSR was a "typo", it should have been S_IRUGO only, I have been in the process of addressing this in our drivers (here at QLogic).

Thanks.

-Joe

> -----Original Message-----
> From: Sonny Rao [mailto:sonnyrao@linux.vnet.ibm.com]
> Sent: Thursday, November 18, 2010 3:06 AM
> To: linux-scsi@vger.kernel.org
> Cc: Sonny Rao; Milton Miller; Andrew Vasquez; Linux Driver; James E.J.
> Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] [RFC] qla2xxx: Change parameter permissions in sysfs
> 
> Many of the module parameter definitions in qla2xxx
> look like S_IRUGO|S_IRUSR which is effectively doing 0400 | 0444
> which is pointless. It seems like the intention is to allow a user
> to change these parameters in sysfs.  So this patch changes it to
> S_IRUGO|S_IWUSR to enable that.  Most of these copied into
> a device-specific structure at init time, so the user would have to
> re-probe or re-bind the adapters for these to take effect.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c
> b/drivers/scsi/qla2xxx/qla_os.c
> index 1644eab..f949959 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -37,12 +37,12 @@ static struct kmem_cache *srb_cachep;
>  static struct kmem_cache *ctx_cachep;
> 
>  int ql2xlogintimeout = 20;
> -module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xlogintimeout, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xlogintimeout,
>  		"Login timeout value in seconds.");
> 
>  int qlport_down_retry;
> -module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
> +module_param(qlport_down_retry, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(qlport_down_retry,
>  		"Maximum number of command retries to a port that returns "
>  		"a PORT-DOWN status.");
> @@ -55,12 +55,12 @@ MODULE_PARM_DESC(ql2xplogiabsentdevice,
>  		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
> 
>  int ql2xloginretrycount = 0;
> -module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xloginretrycount, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xloginretrycount,
>  		"Specify an alternate value for the NVRAM login retry
> count.");
> 
>  int ql2xallocfwdump = 1;
> -module_param(ql2xallocfwdump, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xallocfwdump, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xallocfwdump,
>  		"Option to enable allocation of memory for a firmware dump "
>  		"during HBA initialization.  Memory allocation requirements "
> @@ -73,7 +73,7 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
>  		"Default is 0 - no logging. 1 - log errors.");
> 
>  int ql2xshiftctondsd = 6;
> -module_param(ql2xshiftctondsd, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xshiftctondsd, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xshiftctondsd,
>  		"Set to control shifting of command type processing "
>  		"based on total number of SG elements.");
> @@ -81,7 +81,7 @@ MODULE_PARM_DESC(ql2xshiftctondsd,
>  static void qla2x00_free_device(scsi_qla_host_t *);
> 
>  int ql2xfdmienable=1;
> -module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xfdmienable, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xfdmienable,
>  		"Enables FDMI registrations. "
>  		"0 - no FDMI. Default is 1 - perform FDMI.");
> @@ -106,27 +106,27 @@ MODULE_PARM_DESC(ql2xenablehba_err_chk,
>  		" Default is 0 - Error isolation disabled, 1 - Enable it");
> 
>  int ql2xiidmaenable=1;
> -module_param(ql2xiidmaenable, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xiidmaenable, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xiidmaenable,
>  		"Enables iIDMA settings "
>  		"Default is 1 - perform iIDMA. 0 - no iIDMA.");
> 
>  int ql2xmaxqueues = 1;
> -module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xmaxqueues, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xmaxqueues,
>  		"Enables MQ settings "
>  		"Default is 1 for single queue. Set it to number "
>  		"of queues in MQ mode.");
> 
>  int ql2xmultique_tag;
> -module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xmultique_tag, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xmultique_tag,
>  		"Enables CPU affinity settings for the driver "
>  		"Default is 0 for no affinity of request and response IO. "
>  		"Set it to 1 to turn on the cpu affinity.");
> 
>  int ql2xfwloadbin;
> -module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xfwloadbin, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xfwloadbin,
>  		"Option to specify location from which to load ISP
> firmware:\n"
>  		" 2 -- load firmware via the request_firmware() (hotplug)\n"
> @@ -135,39 +135,39 @@ MODULE_PARM_DESC(ql2xfwloadbin,
>  		" 0 -- use default semantics.\n");
> 
>  int ql2xetsenable;
> -module_param(ql2xetsenable, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xetsenable, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xetsenable,
>  		"Enables firmware ETS burst."
>  		"Default is 0 - skip ETS enablement.");
> 
>  int ql2xdbwr = 1;
> -module_param(ql2xdbwr, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xdbwr, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xdbwr,
>  	"Option to specify scheme for request queue posting\n"
>  	" 0 -- Regular doorbell.\n"
>  	" 1 -- CAMRAM doorbell (faster).\n");
> 
>  int ql2xdontresethba;
> -module_param(ql2xdontresethba, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xdontresethba, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xdontresethba,
>  	"Option to specify reset behaviour\n"
>  	" 0 (Default) -- Reset on failure.\n"
>  	" 1 -- Do not reset on failure.\n");
> 
>  int ql2xtargetreset = 1;
> -module_param(ql2xtargetreset, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xtargetreset, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xtargetreset,
>  		 "Enable target reset."
>  		 "Default is 1 - use hw defaults.");
> 
>  int ql2xgffidenable;
> -module_param(ql2xgffidenable, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xgffidenable, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xgffidenable,
>  		"Enables GFF_ID checks of port type. "
>  		"Default is 0 - Do not use GFF_ID information.");
> 
>  int ql2xasynctmfenable;
> -module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);
> +module_param(ql2xasynctmfenable, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(ql2xasynctmfenable,
>  		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
>  		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
> --
> 1.5.6.5
> 
