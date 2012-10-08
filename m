From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [Open-FCoE] [RFC PATCH v3 2/4] libfcoe, fcoe, bnx2fc: Add new
 fcoe control interface
Date: Mon, 8 Oct 2012 09:49:58 -0400
Message-ID: <20121008134958.GB22939@hmsreliant.think-freely.org>
References: <20121005165422.22466.33025.stgit@fritz>
 <20121005165432.22466.91096.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33660 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JHNuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2012 09:50:17 -0400
Content-Disposition: inline
In-Reply-To: <20121005165432.22466.91096.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: cleech@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org, bprakash@broadcom.com, gregkh@linuxfoundation.org, devel@open-fcoe.org

On Fri, Oct 05, 2012 at 09:54:32AM -0700, Robert Love wrote:
> This patch does a few things.
> 
> 1) Makes /sys/bus/fcoe/ctlr_{create,destroy} interfaces.
>    These interfaces take an <ifname> and will either
>    create an FCoE Controller or destroy an FCoE
>    Controller depending on which file is written to.
> 
>    The new FCoE Controller will start in a DISABLED
>    state and will not do discovery or login until it
>    is ENABLED. This pause will allow us to configure
>    the FCoE Controller before enabling it.
> 
> 2) Makes the 'mode' attribute of a fcoe_ctlr_device
>    writale. This allows the user to configure the mode
>    in which the FCoE Controller will start in when it
>    is ENABLED.
> 
>    Possible modes are 'Fabric', or 'VN2VN'.
> 
>    The default mode for a fcoe_ctlr{,_device} is 'Fabric'.
>    Drivers must implement the set_fcoe_ctlr_mode routine
>    to support this feature.
> 
>    libfcoe offers an exported routine to set a FCoE
>    Controller's mode. The mode can only be changed
>    when the FCoE Controller is DISABLED.
> 
>    This patch also removes the get_fcoe_ctlr_mode pointer
>    in the fcoe_sysfs function template, the code in
>    fcoe_ctlr.c to get the mode and the assignment of
>    the fcoe_sysfs function pointer to the fcoe_ctlr.c
>    implementation (in fcoe and bnx2fc). fcoe_sysfs can
>    return that value for the mode without consulting the
>    LLD.
> 
> 3) Make a 'enabled' attribute of a fcoe_ctlr_device. On a
>    read, fcoe_sysfs will return the attribute's value. On
>    a write, fcoe_sysfs will call the LLD (if there is a
>    callback) to notifiy that the enalbed state has changed.
> 
> This patch maintains the old FCoE control interfaces as
> module parameters, but it adds comments pointing out that
> the old interfaces are deprecated.
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-fcoe |   42 +++++++
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |    1 
>  drivers/scsi/fcoe/fcoe.c                 |    1 
>  drivers/scsi/fcoe/fcoe_sysfs.c           |  186 +++++++++++++++++++++++++++---
>  drivers/scsi/fcoe/fcoe_transport.c       |  104 +++++++++++++++++
>  include/scsi/fcoe_sysfs.h                |   11 ++
>  include/scsi/libfcoe.h                   |   16 ++-
>  7 files changed, 338 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-fcoe b/Documentation/ABI/testing/sysfs-bus-fcoe
> index 469d09c..a57bf37 100644
> --- a/Documentation/ABI/testing/sysfs-bus-fcoe
> +++ b/Documentation/ABI/testing/sysfs-bus-fcoe
> @@ -1,14 +1,54 @@
> +What:		/sys/bus/fcoe/
> +Date:		August 2012
> +KernelVersion:	TBD
> +Contact:	Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org
> +Description:	The FCoE bus. Attributes in this directory are control interfaces.
> +Attributes:
> +
> +	ctlr_create: 'FCoE Controller' instance creation interface. Writing an
> +		     <ifname> to this file will allocate and populate sysfs with a
> +		     fcoe_ctlr_device (ctlr_X). The user can then configure any
> +		     per-port settings and finally write to the fcoe_ctlr_device's
> +		     'start' attribute to begin the kernel's discovery and login
> +		     process.
> +
> +	ctlr_destroy: 'FCoE Controller' instance removal interface. Writing a
> +		       fcoe_ctlr_device's sysfs name to this file will log the
> +		       fcoe_ctlr_device out of the fabric or otherwise connected
> +		       FCoE devices. It will also free all kernel memory allocated
> +		       for this fcoe_ctlr_device and any structures associated
> +		       with it, this includes the scsi_host.
> +
>  What:		/sys/bus/fcoe/ctlr_X
>  Date:		March 2012
>  KernelVersion:	TBD
>  Contact:	Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org
> -Description:	'FCoE Controller' instances on the fcoe bus
> +Description:	'FCoE Controller' instances on the fcoe bus.
> +
> +		The FCoE Controller now has a three stage creation process.
> +		1) Write interface name to ctlr_create 2) Configure the FCoE
> +		Controller (ctlr_X) 3) Enable the FCoE Controller to begin
> +		discovery and login. The FCoE Controller is destroyed by
> +		writing it's name, i.e. ctlr_X to the ctlr_delete file.
> +
>  Attributes:
>  
>  	fcf_dev_loss_tmo: Device loss timeout peroid (see below). Changing
>  			  this value will change the dev_loss_tmo for all
>  			  FCFs discovered by this controller.
>  
> +	mode:		  Display or change the FCoE Controller's mode. Possible
> +			  modes are 'Fabric' and 'VN2VN'. If a FCoE Controller
> +			  is started in 'Fabric' mode then FIP FCF discovery is
> +			  initiated and ultimately a fabric login is attempted.
> +			  If a FCoE Controller is started in 'VN2VN' mode then
> +			  FIP VN2VN discovery and login is performed. A FCoE
> +			  Controller only supports one mode at a time.
> +
> +	enabled:	  Whether an FCoE controller is enabled or disabled.
> +			  0 if disabled, 1 if enabled. Writing either 0 or 1
> +			  to this file will enable or disable the FCoE controller.
> +
>  	lesb_link_fail:   Link Error Status Block (LESB) link failure count.
>  
>  	lesb_vlink_fail:  Link Error Status Block (LESB) virtual link
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index ae1cb76..97d9a58 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2555,7 +2555,6 @@ module_init(bnx2fc_mod_init);
>  module_exit(bnx2fc_mod_exit);
>  
>  static struct fcoe_sysfs_function_template bnx2fc_fcoe_sysfs_templ = {
> -	.get_fcoe_ctlr_mode = fcoe_ctlr_get_fip_mode,
>  	.get_fcoe_ctlr_link_fail = bnx2fc_ctlr_get_lesb,
>  	.get_fcoe_ctlr_vlink_fail = bnx2fc_ctlr_get_lesb,
>  	.get_fcoe_ctlr_miss_fka = bnx2fc_ctlr_get_lesb,
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 078d262..99e9d02 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -155,7 +155,6 @@ static void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *);
>  static void fcoe_fcf_get_vlan_id(struct fcoe_fcf_device *);
>  
>  static struct fcoe_sysfs_function_template fcoe_sysfs_templ = {
> -	.get_fcoe_ctlr_mode = fcoe_ctlr_get_fip_mode,
>  	.get_fcoe_ctlr_link_fail = fcoe_ctlr_get_lesb,
>  	.get_fcoe_ctlr_vlink_fail = fcoe_ctlr_get_lesb,
>  	.get_fcoe_ctlr_miss_fka = fcoe_ctlr_get_lesb,
> diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
> index 8b7b9d7..de3aba4 100644
> --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> @@ -21,8 +21,10 @@
>  #include <linux/types.h>
>  #include <linux/kernel.h>
>  #include <linux/etherdevice.h>
> +#include <linux/ctype.h>
>  
>  #include <scsi/fcoe_sysfs.h>
> +#include <scsi/libfcoe.h>
>  
>  /*
>   * OK to include local libfcoe.h for debug_logging, but cannot include
> @@ -47,6 +49,47 @@ MODULE_PARM_DESC(fcf_dev_loss_tmo,
>  		 " insulate the loss of a fcf. Once this value is"
>  		 " exceeded, the fcf is removed.");
>  
> +#define FCOE_MAX_MODENAME_LEN 20
> +struct fcoe_ctlr_mode_table {
> +	char *modename;
> +	enum fip_conn_type mode;
> +};
> +
> +const struct fcoe_ctlr_mode_table ctlr_mode_tbl[] = {
> +	{       "Fabric",           FIP_CONN_TYPE_FABRIC},
> +	{       "VN2VN",            FIP_CONN_TYPE_VN2VN},
> +	{       NULL,               -1},
> +};
> +
> +static enum fip_conn_type fcoe_parse_mode(const char *buf,
> +				  const struct fcoe_ctlr_mode_table *tbl)
> +{
> +	int modeint = -1, i, rv;
> +	char modestr[FCOE_MAX_MODENAME_LEN + 1] = { 0, };
> +	const char *p;
> +
> +	for (p = buf; *p; p++)
> +		if (!(isdigit(*p) || isspace(*p)))
> +			break;
> +
> +	if (*p)
> +		rv = sscanf(buf, "%20s", modestr);
> +	else
> +		rv = sscanf(buf, "%d", &modeint);
> +
> +	if (!rv)
> +		return FIP_CONN_TYPE_UNKNOWN;
> +
> +	for (i = 0; tbl[i].modename; i++) {
> +		if (modeint == tbl[i].mode)
> +			return tbl[i].mode;
> +		if (strcasecmp(modestr, tbl[i].modename) == 0)
> +			return tbl[i].mode;
> +	}
> +
Is it really worth providing the option to parse mode based on integer value
here?  Ostensibly the fip_conn_type ennumeration will track the above
ctlr_mode_tbl in a 1:1 fashion anyway, and from what I can see theres no user
exported mapping of modenamte to fip_conn_type enum value, so allowing a
numerical parse here is just opening you up to a subtle ABI dependency.

Neil

