From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Fri, 18 Mar 2016 15:39:57 -0400
Message-ID: <1458329997.17965.29.camel@localhost.localdomain>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbcCRTj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 15:39:58 -0400
In-Reply-To: <1458200385-32088-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Thu, 2016-03-17 at 08:39 +0100, Hannes Reinecke wrote:
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
>  drivers/infiniband/ulp/srp/ib_srp.c |  2 +-
>  drivers/message/fusion/mptspi.c     |  2 +-
>  drivers/s390/scsi/zfcp_unit.c       |  3 ++-
>  drivers/scsi/scsi_priv.h            |  2 +-
>  drivers/scsi/scsi_proc.c            |  3 ++-
>  drivers/scsi/scsi_scan.c            | 44 +++++++++++++++++++++++++------------
>  drivers/scsi/scsi_sysfs.c           |  3 ++-
>  drivers/scsi/scsi_transport_fc.c    |  6 +++--
>  drivers/scsi/scsi_transport_iscsi.c |  5 ++++-
>  drivers/scsi/scsi_transport_sas.c   |  7 +++---
>  drivers/scsi/snic/snic_disc.c       |  2 +-
>  include/scsi/scsi_device.h          |  9 +++++++-
>  12 files changed, 60 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 03022f6..1f97381 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2851,7 +2851,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
>  	spin_unlock(&host->target_lock);
>  
>  	scsi_scan_target(&target->scsi_host->shost_gendev,
> -			 0, target->scsi_id, SCAN_WILD_CARD, 0);
> +			 0, target->scsi_id, SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
>  
>  	if (srp_connected_ch(target) < target->ch_count ||
>  	    target->qp_in_error) {
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 613231c..031e088 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -1150,7 +1150,7 @@ static void mpt_work_wrapper(struct work_struct *work)
>  	}
>  	shost_printk(KERN_INFO, shost, MYIOC_s_FMT
>  	    "Integrated RAID detects new device %d\n", ioc->name, disk);
> -	scsi_scan_target(&ioc->sh->shost_gendev, 1, disk, 0, 1);
> +	scsi_scan_target(&ioc->sh->shost_gendev, 1, disk, 0, SCSI_SCAN_RESCAN);
>  }
>  
> 
> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
> index 157d3d2..08bba7c 100644
> --- a/drivers/s390/scsi/zfcp_unit.c
> +++ b/drivers/s390/scsi/zfcp_unit.c
> @@ -26,7 +26,8 @@ void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
>  	lun = scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>  
>  	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
> -		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun, 1);
> +		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun,
> +				 SCSI_SCAN_RESCAN);
>  }
>  
>  static void zfcp_unit_scsi_scan_work(struct work_struct *work)
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 27b4d0a..57a4b99 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -116,7 +116,7 @@ extern void scsi_exit_procfs(void);
>  extern char scsi_scan_type[];
>  extern int scsi_complete_async_scans(void);
>  extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
> -				   unsigned int, u64, int);
> +				   unsigned int, u64, enum scsi_scan_mode);
>  extern void scsi_forget_host(struct Scsi_Host *);
>  extern void scsi_rescan_device(struct device *);
>  
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 251598e..7a74b82 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -251,7 +251,8 @@ static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
>  	if (shost->transportt->user_scan)
>  		error = shost->transportt->user_scan(shost, channel, id, lun);
>  	else
> -		error = scsi_scan_host_selected(shost, channel, id, lun, 1);
> +		error = scsi_scan_host_selected(shost, channel, id, lun,
> +						SCSI_SCAN_MANUAL);
>  	scsi_host_put(shost);
>  	return error;
>  }
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 97074c9..6c8ad36 100644
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
> + * @rescan:     if not equal to SCSI_SCAN_INITIAL skip some code only
> + *              needed on first scan
>   * @hostdata:	passed to scsi_alloc_sdev()
>   *
>   * Description:
> @@ -1055,7 +1059,8 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
>   **/
>  static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  				  u64 lun, int *bflagsp,
> -				  struct scsi_device **sdevp, int rescan,
> +				  struct scsi_device **sdevp,
> +				  enum scsi_scan_mode rescan,
>  				  void *hostdata)
>  {
>  	struct scsi_device *sdev;
> @@ -1069,7 +1074,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  	 */
>  	sdev = scsi_device_lookup_by_target(starget, lun);
>  	if (sdev) {
> -		if (rescan || !scsi_device_created(sdev)) {
> +		if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
>  			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>  				"scsi scan: device exists on %s\n",
>  				dev_name(&sdev->sdev_gendev)));
> @@ -1205,7 +1210,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   *     Modifies sdevscan->lun.
>   **/
>  static void scsi_sequential_lun_scan(struct scsi_target *starget,
> -				     int bflags, int scsi_level, int rescan)
> +				     int bflags, int scsi_level,
> +				     enum scsi_scan_mode rescan)
>  {
>  	uint max_dev_lun;
>  	u64 sparse_lun, lun;
> @@ -1300,7 +1306,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
>   *     1: could not scan with REPORT LUN
>   **/
>  static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
> -				int rescan)
> +				enum scsi_scan_mode rescan)
>  {
>  	char devname[64];
>  	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
> @@ -1546,7 +1552,7 @@ void scsi_rescan_device(struct device *dev)
>  EXPORT_SYMBOL(scsi_rescan_device);
>  
>  static void __scsi_scan_target(struct device *parent, unsigned int channel,
> -		unsigned int id, u64 lun, int rescan)
> +		unsigned int id, u64 lun, enum scsi_scan_mode rescan)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(parent);
>  	int bflags = 0;
> @@ -1604,7 +1610,10 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
>   * @channel:	channel to scan
>   * @id:		target id to scan
>   * @lun:	Specific LUN to scan or SCAN_WILD_CARD
> - * @rescan:	passed to LUN scanning routines
> + * @rescan:	passed to LUN scanning routines; SCSI_SCAN_INITIAL for
> + *              no rescan, SCSI_SCAN_RESCAN to rescan existing LUNs,
> + *              and SCSI_SCAN_MANUAL to force scanning even if
> + *              'scan=manual' is set.
>   *
>   * Description:
>   *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
> @@ -1614,13 +1623,17 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
>   *     sequential scan of LUNs on the target id.
>   **/
>  void scsi_scan_target(struct device *parent, unsigned int channel,
> -		      unsigned int id, u64 lun, int rescan)
> +		      unsigned int id, u64 lun, enum scsi_scan_mode rescan)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(parent);
>  
>  	if (strncmp(scsi_scan_type, "none", 4) == 0)
>  		return;
>  
> +	if (rescan != SCSI_SCAN_MANUAL &&
> +	    strncmp(scsi_scan_type, "manual", 6) == 0)
> +		return;
> +
>  	mutex_lock(&shost->scan_mutex);
>  	if (!shost->async_scan)
>  		scsi_complete_async_scans();
> @@ -1634,7 +1647,8 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
>  EXPORT_SYMBOL(scsi_scan_target);
>  
>  static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
> -			      unsigned int id, u64 lun, int rescan)
> +			      unsigned int id, u64 lun,
> +			      enum scsi_scan_mode rescan)
>  {
>  	uint order_id;
>  
> @@ -1665,7 +1679,8 @@ static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
>  }
>  
>  int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
> -			    unsigned int id, u64 lun, int rescan)
> +			    unsigned int id, u64 lun,
> +			    enum scsi_scan_mode rescan)
>  {
>  	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
>  		"%s: <%u:%u:%llu>\n",
> @@ -1844,7 +1859,8 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  {
>  	struct async_scan_data *data;
>  
> -	if (strncmp(scsi_scan_type, "none", 4) == 0)
> +	if (strncmp(scsi_scan_type, "none", 4) == 0 ||
> +	    strncmp(scsi_scan_type, "manual", 6) == 0)
>  		return;
>  	if (scsi_autopm_get_host(shost) < 0)
>  		return;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 92ffd24..3b2045f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -143,7 +143,8 @@ static int scsi_scan(struct Scsi_Host *shost, const char *str)
>  	if (shost->transportt->user_scan)
>  		res = shost->transportt->user_scan(shost, channel, id, lun);
>  	else
> -		res = scsi_scan_host_selected(shost, channel, id, lun, 1);
> +		res = scsi_scan_host_selected(shost, channel, id, lun,
> +					      SCSI_SCAN_MANUAL);
>  	return res;
>  }
>  
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 8a88226..bf28c68 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2110,7 +2110,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
>  		if ((channel == rport->channel) &&
>  		    (id == rport->scsi_target_id)) {
>  			spin_unlock_irqrestore(shost->host_lock, flags);
> -			scsi_scan_target(&rport->dev, channel, id, lun, 1);
> +			scsi_scan_target(&rport->dev, channel, id, lun,
> +					 SCSI_SCAN_MANUAL);
>  			return;
>  		}
>  	}
> @@ -3277,7 +3278,8 @@ fc_scsi_scan_rport(struct work_struct *work)
>  	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>  	    !(i->f->disable_target_scan)) {
>  		scsi_scan_target(&rport->dev, rport->channel,
> -			rport->scsi_target_id, SCAN_WILD_CARD, 1);
> +				 rport->scsi_target_id, SCAN_WILD_CARD,
> +				 SCSI_SCAN_RESCAN);
>  	}
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4414816..7a759a9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1783,6 +1783,7 @@ struct iscsi_scan_data {
>  	unsigned int channel;
>  	unsigned int id;
>  	u64 lun;
> +	enum scsi_scan_mode rescan;
>  };
>  
>  static int iscsi_user_scan_session(struct device *dev, void *data)
> @@ -1819,7 +1820,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
>  		    (scan_data->id == SCAN_WILD_CARD ||
>  		     scan_data->id == id))
>  			scsi_scan_target(&session->dev, 0, id,
> -					 scan_data->lun, 1);
> +					 scan_data->lun, scan_data->rescan);
>  	}
>  
>  user_scan_exit:
> @@ -1836,6 +1837,7 @@ static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
>  	scan_data.channel = channel;
>  	scan_data.id = id;
>  	scan_data.lun = lun;
> +	scan_data.rescan = SCSI_SCAN_MANUAL;
>  
>  	return device_for_each_child(&shost->shost_gendev, &scan_data,
>  				     iscsi_user_scan_session);
> @@ -1852,6 +1854,7 @@ static void iscsi_scan_session(struct work_struct *work)
>  	scan_data.channel = 0;
>  	scan_data.id = SCAN_WILD_CARD;
>  	scan_data.lun = SCAN_WILD_CARD;
> +	scan_data.rescan = SCSI_SCAN_RESCAN;
>  
>  	iscsi_user_scan_session(&session->dev, &scan_data);
>  	atomic_dec(&ihost->nr_scans);
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index b6f958193..3f0ff07 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1614,7 +1614,8 @@ int sas_rphy_add(struct sas_rphy *rphy)
>  		else
>  			lun = 0;
>  
> -		scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);
> +		scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun,
> +				 SCSI_SCAN_INITIAL);
>  	}
>  
>  	return 0;
> @@ -1739,8 +1740,8 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
>  
>  		if ((channel == SCAN_WILD_CARD || channel == 0) &&
>  		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
> -			scsi_scan_target(&rphy->dev, 0,
> -					 rphy->scsi_target_id, lun, 1);
> +			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
> +					 lun, SCSI_SCAN_MANUAL);
>  		}
>  	}
>  	mutex_unlock(&sas_host->lock);
> diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
> index 5f63217..5f48795 100644
> --- a/drivers/scsi/snic/snic_disc.c
> +++ b/drivers/scsi/snic/snic_disc.c
> @@ -171,7 +171,7 @@ snic_scsi_scan_tgt(struct work_struct *work)
>  			 tgt->channel,
>  			 tgt->scsi_tgt_id,
>  			 SCAN_WILD_CARD,
> -			 1);
> +			 SCSI_SCAN_RESCAN);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	tgt->flags &= ~SNIC_TGT_SCAN_PENDING;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index c067019..61341d3 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -50,6 +50,12 @@ enum scsi_device_state {
>  	SDEV_CREATED_BLOCK,	/* same as above but for created devices */
>  };
>  
> +enum scsi_scan_mode {
> +	SCSI_SCAN_INITIAL = 0,
> +	SCSI_SCAN_RESCAN,
> +	SCSI_SCAN_MANUAL,
> +};
> +
>  enum scsi_device_event {
>  	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
>  	SDEV_EVT_INQUIRY_CHANGE_REPORTED,		/* 3F 03  UA reported */
> @@ -391,7 +397,8 @@ extern void scsi_device_resume(struct scsi_device *sdev);
>  extern void scsi_target_quiesce(struct scsi_target *);
>  extern void scsi_target_resume(struct scsi_target *);
>  extern void scsi_scan_target(struct device *parent, unsigned int channel,
> -			     unsigned int id, u64 lun, int rescan);
> +			     unsigned int id, u64 lun,
> +			     enum scsi_scan_mode rescan);
>  extern void scsi_target_reap(struct scsi_target *);
>  extern void scsi_target_block(struct device *);
>  extern void scsi_target_unblock(struct device *, enum scsi_device_state);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


