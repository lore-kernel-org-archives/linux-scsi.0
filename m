From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 14:36:17 +0100
Message-ID: <20160315133617.GA18668@lst.de>
References: <1458026382-43338-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46200 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbcCONgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 09:36:19 -0400
Content-Disposition: inline
In-Reply-To: <1458026382-43338-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Tue, Mar 15, 2016 at 08:19:42AM +0100, Hannes Reinecke wrote:
> On larger installations it is useful to disable automatic LUN
> scanning, and only add the required LUNs via udev rules.
> This can speed up bootup dramatically.
> 
> This patch introduces a new scan module parameter value 'manual',
> which works like 'none', but can be overriden by setting the 'rescan'
> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
> And it updates all relevant callers to set the 'rescan' value
> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_scan.c            | 25 ++++++++++++++++++-------
>  drivers/scsi/scsi_sysfs.c           |  3 ++-
>  drivers/scsi/scsi_transport_fc.c    |  3 ++-
>  drivers/scsi/scsi_transport_iscsi.c |  2 +-
>  drivers/scsi/scsi_transport_sas.c   |  4 ++--
>  include/scsi/scsi_device.h          |  6 ++++++
>  6 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 97074c9..54dc517 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -96,10 +96,13 @@ MODULE_PARM_DESC(max_luns,
>  #define SCSI_SCAN_TYPE_DEFAULT "sync"
>  #endif
>  
> -char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
> +char scsi_scan_type[7] = SCSI_SCAN_TYPE_DEFAULT;
>  
> -module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
> -MODULE_PARM_DESC(scan, "sync, async or none");
> +module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type),
> +		    S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(scan, "sync, async, manual, or none. "
> +		 "Setting to 'manual' disables automatic scanning, but allows "
> +		 "for manual device scan via the 'scan' sysfs attribute.");
>  
>  static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
>  
> @@ -1040,7 +1043,8 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
>   * @lun:	LUN of target device
>   * @bflagsp:	store bflags here if not NULL
>   * @sdevp:	probe the LUN corresponding to this scsi_device
> - * @rescan:     if nonzero skip some code only needed on first scan
> + * @rescan:     if greater than SCSI_SCAN_NONE skip some code only
> + *              needed on first scan

please pass the actual enum to all the functions taking this
recan argument so that we can do proper type checking on it.

> +		if (rescan > SCSI_SCAN_NONE || !scsi_device_created(sdev)) {

And always check just check for equality instead of doing BT / LT on
enum values.

>  
> +enum scsi_scan_mode {
> +	SCSI_SCAN_NONE = 0,

and this could use a better name.  SCSI_SCAN_INITAL maybe?
