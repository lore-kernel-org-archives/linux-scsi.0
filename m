From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] libfcoe: Save some memory and optimize name lookups
Date: Mon, 17 Dec 2012 09:26:28 -0500
Message-ID: <20121217142628.GC25322@hmsreliant.think-freely.org>
References: <20121212232219.13084.99143.stgit@fritz>
 <20121214220218.9650.18664.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36509 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LQO0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2012 09:26:40 -0500
Content-Disposition: inline
In-Reply-To: <20121214220218.9650.18664.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: bvanassche@acm.org, linux-scsi@vger.kernel.org

On Fri, Dec 14, 2012 at 02:02:18PM -0800, Robert Love wrote:
> Instead of creating a structure with an enum and a pointer
> to a string, simply allocate an array of strings and use
> the enum values for the indicies.
> 
> This means that we do not need to iterate through the list
> of entries when looking up a string name by its enum key.
> 
> This will also help with a latter patch that will add
> more fcoe_sysfs attributes that will also use the
> fcoe_enum_name_search macro. One attribute will also do
> a reverse lookup which requires less code when the
> enum-to-string mappings are organized as this patch makes
> them to be.
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  drivers/scsi/fcoe/fcoe_sysfs.c |   44 +++++++++++++++-------------------------
>  1 file changed, 16 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
> index 5e75168..e6fce28 100644
> --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> @@ -210,25 +210,23 @@ static ssize_t show_fcoe_fcf_device_##field(struct device *dev,	\
>  #define fcoe_enum_name_search(title, table_type, table)			\
>  static const char *get_fcoe_##title##_name(enum table_type table_key)	\
>  {									\
> -	int i;								\
> -	char *name = NULL;						\
> -									\
> -	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
> -		if (table[i].value == table_key) {			\
> -			name = table[i].name;				\
> -			break;						\
> -		}							\
> -	}								\
> -	return name;							\
> +	if (table_key < 0 || table_key >= ARRAY_SIZE(table))		\
> +		return NULL;						\
> +	return table[table_key];					\
>  }
>  
> -static struct {
> -	enum fcf_state value;
> -	char           *name;
> -} fcf_state_names[] = {
> -	{ FCOE_FCF_STATE_UNKNOWN,      "Unknown" },
> -	{ FCOE_FCF_STATE_DISCONNECTED, "Disconnected" },
> -	{ FCOE_FCF_STATE_CONNECTED,    "Connected" },
> +static char *fip_conn_type_names[] = {
> +	[ FIP_CONN_TYPE_UNKNOWN ] = "Unknown",
> +	[ FIP_CONN_TYPE_FABRIC ]  = "Fabric",
> +	[ FIP_CONN_TYPE_VN2VN ]   = "VN2VN",
> +};
> +fcoe_enum_name_search(ctlr_mode, fip_conn_type, fip_conn_type_names)
> +#define FCOE_CTLR_MODE_MAX_NAMELEN 50
> +
> +static char *fcf_state_names[] = {
> +	[ FCOE_FCF_STATE_UNKNOWN ]      = "Unknown",
> +	[ FCOE_FCF_STATE_DISCONNECTED ] = "Disconnected",
> +	[ FCOE_FCF_STATE_CONNECTED ]    = "Connected",
>  };
>  fcoe_enum_name_search(fcf_state, fcf_state, fcf_state_names)
>  #define FCOE_FCF_STATE_MAX_NAMELEN 50
> @@ -246,17 +244,7 @@ static ssize_t show_fcf_state(struct device *dev,
>  }
>  static FCOE_DEVICE_ATTR(fcf, state, S_IRUGO, show_fcf_state, NULL);
>  
> -static struct {
> -	enum fip_conn_type value;
> -	char               *name;
> -} fip_conn_type_names[] = {
> -	{ FIP_CONN_TYPE_UNKNOWN, "Unknown" },
> -	{ FIP_CONN_TYPE_FABRIC, "Fabric" },
> -	{ FIP_CONN_TYPE_VN2VN, "VN2VN" },
> -};
> -fcoe_enum_name_search(ctlr_mode, fip_conn_type, fip_conn_type_names)
> -#define FCOE_CTLR_MODE_MAX_NAMELEN 50
> -
> +#define FCOE_MAX_MODENAME_LEN 20
>  static ssize_t show_ctlr_mode(struct device *dev,
>  			      struct device_attribute *attr,
>  			      char *buf)
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

