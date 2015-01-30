From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 4/6] scsi: misc:  Replace seq_printf with seq_puts
Date: Fri, 30 Jan 2015 12:41:08 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1501301047160.28204@nippy.intranet>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk> <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk> <1417561854-17188-5-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417561854-17188-5-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Reviewed-by: Finn Thain <fthain@telegraphics.com.au>

For the NCR5380 bits:

Acked-by: Finn Thain <fthain@telegraphics.com.au>


On Wed, 3 Dec 2014, Rasmus Villemoes wrote:

> Using seq_printf to print a simple string is a lot more expensive than
> it needs to be, since seq_puts exists. Replace seq_printf with
> seq_puts when possible.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/scsi/BusLogic.c             | 10 +++++-----
>  drivers/scsi/NCR5380.c              |  4 ++--
>  drivers/scsi/aic7xxx/aic79xx_proc.c | 38 ++++++++++++++++++-------------------
>  drivers/scsi/aic7xxx/aic7xxx_proc.c | 24 +++++++++++------------
>  drivers/scsi/arm/fas216.c           |  6 +++---
>  drivers/scsi/atari_NCR5380.c        |  4 ++--
>  drivers/scsi/atp870u.c              |  6 +++---
>  drivers/scsi/dc395x.c               | 17 +++++++++--------
>  drivers/scsi/dpt_i2o.c              |  2 +-
>  drivers/scsi/eata_pio.c             |  2 +-
>  drivers/scsi/gdth_proc.c            | 24 +++++++++++------------
>  drivers/scsi/in2000.c               | 18 +++++++++---------
>  drivers/scsi/ips.c                  |  7 +++----
>  drivers/scsi/megaraid.c             |  2 +-
>  drivers/scsi/nsp32.c                | 14 +++++++-------
>  drivers/scsi/pcmcia/nsp_cs.c        | 30 ++++++++++++++---------------
>  drivers/scsi/qla2xxx/qla_dfs.c      |  8 ++++----
>  drivers/scsi/scsi_proc.c            | 22 ++++++++++-----------
>  drivers/scsi/scsi_trace.c           |  6 +++---
>  drivers/scsi/wd33c93.c              | 18 +++++++++---------
>  drivers/scsi/wd7000.c               | 12 ++++++------
>  21 files changed, 136 insertions(+), 138 deletions(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 8d66a64..c7be7bb 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -3485,7 +3485,7 @@ static int blogic_show_info(struct seq_file *m, struct Scsi_Host *shost)
>  	seq_printf(m, "\n\
>  Current Driver Queue Depth:	%d\n\
>  Currently Allocated CCBs:	%d\n", adapter->drvr_qdepth, adapter->alloc_ccbs);
> -	seq_printf(m, "\n\n\
> +	seq_puts(m, "\n\n\
>  			   DATA TRANSFER STATISTICS\n\
>  \n\
>  Target	Tagged Queuing	Queue Depth  Active  Attempted	Completed\n\
> @@ -3500,7 +3500,7 @@ Target	Tagged Queuing	Queue Depth  Active  Attempted	Completed\n\
>  		seq_printf(m,
>  				  "	    %3d       %3u    %9u	%9u\n", adapter->qdepth[tgt], adapter->active_cmds[tgt], tgt_stats[tgt].cmds_tried, tgt_stats[tgt].cmds_complete);
>  	}
> -	seq_printf(m, "\n\
> +	seq_puts(m, "\n\
>  Target  Read Commands  Write Commands   Total Bytes Read    Total Bytes Written\n\
>  ======  =============  ==============  ===================  ===================\n");
>  	for (tgt = 0; tgt < adapter->maxdev; tgt++) {
> @@ -3517,7 +3517,7 @@ Target  Read Commands  Write Commands   Total Bytes Read    Total Bytes Written\
>  		else
>  			seq_printf(m, "	     %9u\n", tgt_stats[tgt].byteswritten.units);
>  	}
> -	seq_printf(m, "\n\
> +	seq_puts(m, "\n\
>  Target  Command    0-1KB      1-2KB      2-4KB      4-8KB     8-16KB\n\
>  ======  =======  =========  =========  =========  =========  =========\n");
>  	for (tgt = 0; tgt < adapter->maxdev; tgt++) {
> @@ -3533,7 +3533,7 @@ Target  Command    0-1KB      1-2KB      2-4KB      4-8KB     8-16KB\n\
>  			    tgt_stats[tgt].write_sz_buckets[0],
>  			    tgt_stats[tgt].write_sz_buckets[1], tgt_stats[tgt].write_sz_buckets[2], tgt_stats[tgt].write_sz_buckets[3], tgt_stats[tgt].write_sz_buckets[4]);
>  	}
> -	seq_printf(m, "\n\
> +	seq_puts(m, "\n\
>  Target  Command   16-32KB    32-64KB   64-128KB   128-256KB   256KB+\n\
>  ======  =======  =========  =========  =========  =========  =========\n");
>  	for (tgt = 0; tgt < adapter->maxdev; tgt++) {
> @@ -3549,7 +3549,7 @@ Target  Command   16-32KB    32-64KB   64-128KB   128-256KB   256KB+\n\
>  			    tgt_stats[tgt].write_sz_buckets[5],
>  			    tgt_stats[tgt].write_sz_buckets[6], tgt_stats[tgt].write_sz_buckets[7], tgt_stats[tgt].write_sz_buckets[8], tgt_stats[tgt].write_sz_buckets[9]);
>  	}
> -	seq_printf(m, "\n\n\
> +	seq_puts(m, "\n\n\
>  			   ERROR RECOVERY STATISTICS\n\
>  \n\
>  	  Command Aborts      Bus Device Resets	  Host Adapter Resets\n\
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index aca181e..a30af00 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -754,7 +754,7 @@ static int __maybe_unused NCR5380_show_info(struct seq_file *m,
>  static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
>  {
>  	seq_printf(m, "scsi%d : destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
> -	seq_printf(m, "        command = ");
> +	seq_puts(m, "        command = ");
>  	lprint_command(cmd->cmnd, m);
>  }
>  
> @@ -764,7 +764,7 @@ static void lprint_command(unsigned char *command, struct seq_file *m)
>  	lprint_opcode(command[0], m);
>  	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
>  		seq_printf(m, "%02x ", command[i]);
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  }
>  
>  static void lprint_opcode(int opcode, struct seq_file *m)
> diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
> index 27dbfcc..e095598 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_proc.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
> @@ -97,7 +97,7 @@ ahd_format_transinfo(struct seq_file *m, struct ahd_transinfo *tinfo)
>  	u_int mb;
>  
>  	if (tinfo->period == AHD_PERIOD_UNKNOWN) {
> -		seq_printf(m, "Renegotiation Pending\n");
> +		seq_puts(m, "Renegotiation Pending\n");
>  		return;
>  	}
>          speed = 3300;
> @@ -119,40 +119,38 @@ ahd_format_transinfo(struct seq_file *m, struct ahd_transinfo *tinfo)
>  		printed_options = 0;
>  		seq_printf(m, " (%d.%03dMHz", freq / 1000, freq % 1000);
>  		if ((tinfo->ppr_options & MSG_EXT_PPR_RD_STRM) != 0) {
> -			seq_printf(m, " RDSTRM");
> +			seq_puts(m, " RDSTRM");
>  			printed_options++;
>  		}
>  		if ((tinfo->ppr_options & MSG_EXT_PPR_DT_REQ) != 0) {
> -			seq_printf(m, "%s", printed_options ? "|DT" : " DT");
> +			seq_puts(m, printed_options ? "|DT" : " DT");
>  			printed_options++;
>  		}
>  		if ((tinfo->ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
> -			seq_printf(m, "%s", printed_options ? "|IU" : " IU");
> +			seq_puts(m, printed_options ? "|IU" : " IU");
>  			printed_options++;
>  		}
>  		if ((tinfo->ppr_options & MSG_EXT_PPR_RTI) != 0) {
> -			seq_printf(m, "%s",
> -				  printed_options ? "|RTI" : " RTI");
> +			seq_puts(m, printed_options ? "|RTI" : " RTI");
>  			printed_options++;
>  		}
>  		if ((tinfo->ppr_options & MSG_EXT_PPR_QAS_REQ) != 0) {
> -			seq_printf(m, "%s",
> -				  printed_options ? "|QAS" : " QAS");
> +			seq_puts(m, printed_options ? "|QAS" : " QAS");
>  			printed_options++;
>  		}
>  	}
>  
>  	if (tinfo->width > 0) {
>  		if (freq != 0) {
> -			seq_printf(m, ", ");
> +			seq_puts(m, ", ");
>  		} else {
> -			seq_printf(m, " (");
> +			seq_puts(m, " (");
>  		}
>  		seq_printf(m, "%dbit)", 8 * (0x01 << tinfo->width));
>  	} else if (freq != 0) {
> -		seq_printf(m, ")");
> +		seq_puts(m, ")");
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  }
>  
>  static void
> @@ -167,15 +165,15 @@ ahd_dump_target_state(struct ahd_softc *ahd, struct seq_file *m,
>  	tinfo = ahd_fetch_transinfo(ahd, channel, our_id,
>  				    target_id, &tstate);
>  	seq_printf(m, "Target %d Negotiation Settings\n", target_id);
> -	seq_printf(m, "\tUser: ");
> +	seq_puts(m, "\tUser: ");
>  	ahd_format_transinfo(m, &tinfo->user);
>  	starget = ahd->platform_data->starget[target_id];
>  	if (starget == NULL)
>  		return;
>  
> -	seq_printf(m, "\tGoal: ");
> +	seq_puts(m, "\tGoal: ");
>  	ahd_format_transinfo(m, &tinfo->goal);
> -	seq_printf(m, "\tCurr: ");
> +	seq_puts(m, "\tCurr: ");
>  	ahd_format_transinfo(m, &tinfo->curr);
>  
>  	for (lun = 0; lun < AHD_NUM_LUNS; lun++) {
> @@ -291,19 +289,19 @@ ahd_linux_show_info(struct seq_file *m, struct Scsi_Host *shost)
>  	max_targ = 16;
>  
>  	if (ahd->seep_config == NULL)
> -		seq_printf(m, "No Serial EEPROM\n");
> +		seq_puts(m, "No Serial EEPROM\n");
>  	else {
> -		seq_printf(m, "Serial EEPROM:\n");
> +		seq_puts(m, "Serial EEPROM:\n");
>  		for (i = 0; i < sizeof(*ahd->seep_config)/2; i++) {
>  			if (((i % 8) == 0) && (i != 0)) {
> -				seq_printf(m, "\n");
> +				seq_puts(m, "\n");
>  			}
>  			seq_printf(m, "0x%.4x ",
>  				  ((uint16_t*)ahd->seep_config)[i]);
>  		}
> -		seq_printf(m, "\n");
> +		seq_puts(m, "\n");
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  
>  	if ((ahd->features & AHD_WIDE) == 0)
>  		max_targ = 8;
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx/aic7xxx_proc.c
> index 64eec6c..25511ca 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
> @@ -119,15 +119,15 @@ ahc_format_transinfo(struct seq_file *m, struct ahc_transinfo *tinfo)
>  
>  	if (tinfo->width > 0) {
>  		if (freq != 0) {
> -			seq_printf(m, ", ");
> +			seq_puts(m, ", ");
>  		} else {
> -			seq_printf(m, " (");
> +			seq_puts(m, " (");
>  		}
>  		seq_printf(m, "%dbit)", 8 * (0x01 << tinfo->width));
>  	} else if (freq != 0) {
> -		seq_printf(m, ")");
> +		seq_puts(m, ")");
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  }
>  
>  static void
> @@ -145,15 +145,15 @@ ahc_dump_target_state(struct ahc_softc *ahc, struct seq_file *m,
>  	if ((ahc->features & AHC_TWIN) != 0)
>  		seq_printf(m, "Channel %c ", channel);
>  	seq_printf(m, "Target %d Negotiation Settings\n", target_id);
> -	seq_printf(m, "\tUser: ");
> +	seq_puts(m, "\tUser: ");
>  	ahc_format_transinfo(m, &tinfo->user);
>  	starget = ahc->platform_data->starget[target_offset];
>  	if (!starget)
>  		return;
>  
> -	seq_printf(m, "\tGoal: ");
> +	seq_puts(m, "\tGoal: ");
>  	ahc_format_transinfo(m, &tinfo->goal);
> -	seq_printf(m, "\tCurr: ");
> +	seq_puts(m, "\tCurr: ");
>  	ahc_format_transinfo(m, &tinfo->curr);
>  
>  	for (lun = 0; lun < AHC_NUM_LUNS; lun++) {
> @@ -303,19 +303,19 @@ ahc_linux_show_info(struct seq_file *m, struct Scsi_Host *shost)
>  
>  
>  	if (ahc->seep_config == NULL)
> -		seq_printf(m, "No Serial EEPROM\n");
> +		seq_puts(m, "No Serial EEPROM\n");
>  	else {
> -		seq_printf(m, "Serial EEPROM:\n");
> +		seq_puts(m, "Serial EEPROM:\n");
>  		for (i = 0; i < sizeof(*ahc->seep_config)/2; i++) {
>  			if (((i % 8) == 0) && (i != 0)) {
> -				seq_printf(m, "\n");
> +				seq_puts(m, "\n");
>  			}
>  			seq_printf(m, "0x%.4x ",
>  				  ((uint16_t*)ahc->seep_config)[i]);
>  		}
> -		seq_printf(m, "\n");
> +		seq_puts(m, "\n");
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  
>  	max_targ = 16;
>  	if ((ahc->features & (AHC_WIDE|AHC_TWIN)) == 0)
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index e64c3af..decdc71 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2990,7 +2990,7 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
>  	struct fas216_device *dev;
>  	struct scsi_device *scd;
>  
> -	seq_printf(m, "Device/Lun TaggedQ       Parity   Sync\n");
> +	seq_puts(m, "Device/Lun TaggedQ       Parity   Sync\n");
>  
>  	shost_for_each_device(scd, info->host) {
>  		dev = &info->device[scd->id];
> @@ -3000,7 +3000,7 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
>  				     scd->simple_tags ? "en" : "dis",
>  				     scd->current_tag);
>  		else
> -			seq_printf(m, "unsupported   ");
> +			seq_puts(m, "unsupported   ");
>  
>  		seq_printf(m, "%3sabled ", dev->parity_enabled ? "en" : "dis");
>  
> @@ -3008,7 +3008,7 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
>  			seq_printf(m, "offset %d, %d ns\n",
>  				     dev->sof, dev->period * 4);
>  		else
> -			seq_printf(m, "async\n");
> +			seq_puts(m, "async\n");
>  	}
>  }
>  
> diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
> index 6daed6b..04d0c6e 100644
> --- a/drivers/scsi/atari_NCR5380.c
> +++ b/drivers/scsi/atari_NCR5380.c
> @@ -711,12 +711,12 @@ static void show_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
>  	unsigned char *command;
>  	seq_printf(m, "scsi%d: destination target %d, lun %llu\n",
>  		H_NO(cmd), cmd->device->id, cmd->device->lun);
> -	seq_printf(m, "        command = ");
> +	seq_puts(m, "        command = ");
>  	command = cmd->cmnd;
>  	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
>  	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
>  		seq_printf(m, " %02x", command[i]);
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  }
>  
>  static int __maybe_unused NCR5380_show_info(struct seq_file *m,
> diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
> index a795d81..0b02467 100644
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -3101,9 +3101,9 @@ static const char *atp870u_info(struct Scsi_Host *notused)
>  
>  static int atp870u_show_info(struct seq_file *m, struct Scsi_Host *HBAptr)
>  {
> -	seq_printf(m, "ACARD AEC-671X Driver Version: 2.6+ac\n");
> -	seq_printf(m, "\n");
> -	seq_printf(m, "Adapter Configuration:\n");
> +	seq_puts(m, "ACARD AEC-671X Driver Version: 2.6+ac\n");
> +	seq_puts(m, "\n");
> +	seq_puts(m, "Adapter Configuration:\n");
>  	seq_printf(m, "               Base IO: %#.4lx\n", HBAptr->io_port);
>  	seq_printf(m, "                   IRQ: %d\n", HBAptr->irq);
>  	return 0;
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 0a1ed50..3a55ea2 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -4623,8 +4623,8 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	unsigned long flags;
>  	int dev;
>  
> -	seq_printf(m, DC395X_BANNER " PCI SCSI Host Adapter\n");
> -	seq_printf(m, " Driver Version " DC395X_VERSION "\n");
> +	seq_puts(m, DC395X_BANNER " PCI SCSI Host Adapter\n");
> +	seq_puts(m, " Driver Version " DC395X_VERSION "\n");
>  
>  	DC395x_LOCK_IO(acb->scsi_host, flags);
>  
> @@ -4655,7 +4655,8 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	     acb->dcb_map[11], acb->dcb_map[12], acb->dcb_map[13],
>  	     acb->dcb_map[14], acb->dcb_map[15]);
>  
> -	seq_printf(m, "Un ID LUN Prty Sync Wide DsCn SndS TagQ nego_period SyncFreq SyncOffs MaxCmd\n");
> +	seq_puts(m,
> +		 "Un ID LUN Prty Sync Wide DsCn SndS TagQ nego_period SyncFreq SyncOffs MaxCmd\n");
>  
>  	dev = 0;
>  	list_for_each_entry(dcb, &acb->dcb_list, list) {
> @@ -4681,7 +4682,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
>  			seq_printf(m, "   %2i.%1i M     %02i ", spd, spd1,
>  				(dcb->sync_offset & 0x0f));
>  		} else
> -			seq_printf(m, "                 ");
> +			seq_puts(m, "                 ");
>  
>  		/* Add more info ... */
>  		seq_printf(m, "     %02i\n", dcb->max_command);
> @@ -4689,9 +4690,9 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	}
>  
>  	if (timer_pending(&acb->waiting_timer))
> -		seq_printf(m, "Waiting queue timer running\n");
> +		seq_puts(m, "Waiting queue timer running\n");
>  	else
> -		seq_printf(m, "\n");
> +		seq_puts(m, "\n");
>  
>  	list_for_each_entry(dcb, &acb->dcb_list, list) {
>  		struct ScsiReqBlk *srb;
> @@ -4708,7 +4709,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
>  		list_for_each_entry(srb, &dcb->srb_going_list, list)
>  			seq_printf(m, " %p", srb->cmd);
>  		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_going_list))
> -			seq_printf(m, "\n");
> +			seq_puts(m, "\n");
>  	}
>  
>  	if (debug_enabled(DBG_1)) {
> @@ -4716,7 +4717,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
>  		list_for_each_entry(dcb, &acb->dcb_list, list) {
>  			seq_printf(m, "%p -> ", dcb);
>  		}
> -		seq_printf(m, "END\n");
> +		seq_puts(m, "END\n");
>  	}
>  
>  	DC395x_UNLOCK_IO(acb->scsi_host, flags);
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 0bf9769..2806cfb 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -568,7 +568,7 @@ static int adpt_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	seq_printf(m, "\tpost fifo size  = %d\n\treply fifo size = %d\n\tsg table size   = %d\n\n",
>  			host->can_queue, (int) pHba->reply_fifo_size , host->sg_tablesize);
>  
> -	seq_printf(m, "Devices:\n");
> +	seq_puts(m, "Devices:\n");
>  	for(chan = 0; chan < MAX_CHANNEL; chan++) {
>  		for(id = 0; id < MAX_ID; id++) {
>  			d = pHba->channel[chan].device[id];
> diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
> index 8319d2b..ca8003f 100644
> --- a/drivers/scsi/eata_pio.c
> +++ b/drivers/scsi/eata_pio.c
> @@ -102,7 +102,7 @@ static int eata_pio_show_info(struct seq_file *m, struct Scsi_Host *shost)
>  		   shost->host_no, SD(shost)->name);
>  	seq_printf(m, "Firmware revision: v%s\n",
>  		   SD(shost)->revision);
> -	seq_printf(m, "IO: PIO\n");
> +	seq_puts(m, "IO: PIO\n");
>  	seq_printf(m, "Base IO : %#.4x\n", (u32) shost->base);
>  	seq_printf(m, "Host Bus: %s\n",
>  		   (SD(shost)->bustype == 'P')?"PCI ":
> diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
> index 9fb6326..e66e997 100644
> --- a/drivers/scsi/gdth_proc.c
> +++ b/drivers/scsi/gdth_proc.c
> @@ -173,7 +173,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>      /* request is i.e. "cat /proc/scsi/gdth/0" */ 
>      /* format: %-15s\t%-10s\t%-15s\t%s */
>      /* driver parameters */
> -    seq_printf(m, "Driver Parameters:\n");
> +    seq_puts(m, "Driver Parameters:\n");
>      if (reserve_list[0] == 0xff)
>          strcpy(hrec, "--");
>      else {
> @@ -192,7 +192,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>                     max_ids, hdr_channel);
>  
>      /* controller information */
> -    seq_printf(m,"\nDisk Array Controller Information:\n");
> +    seq_puts(m, "\nDisk Array Controller Information:\n");
>      seq_printf(m,
>                     " Number:       \t%d         \tName:          \t%s\n",
>                     ha->hanum, ha->binfo.type_string);
> @@ -219,7 +219,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>  
>  #ifdef GDTH_DMA_STATISTICS
>      /* controller statistics */
> -    seq_printf(m,"\nController Statistics:\n");
> +    seq_puts(m, "\nController Statistics:\n");
>      seq_printf(m,
>                     " 32-bit DMA buffer:\t%lu\t64-bit DMA buffer:\t%lu\n",
>                     ha->dma32_cnt, ha->dma64_cnt);
> @@ -227,7 +227,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>  
>      if (ha->more_proc) {
>          /* more information: 2. about physical devices */
> -        seq_printf(m, "\nPhysical Devices:");
> +        seq_puts(m, "\nPhysical Devices:");
>          flag = FALSE;
>              
>          buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
> @@ -326,10 +326,10 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>          gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
>  
>          if (!flag)
> -            seq_printf(m, "\n --\n");
> +            seq_puts(m, "\n --\n");
>  
>          /* 3. about logical drives */
> -        seq_printf(m,"\nLogical Drives:");
> +        seq_puts(m, "\nLogical Drives:");
>          flag = FALSE;
>  
>          buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
> @@ -411,10 +411,10 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>          gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
>          
>          if (!flag)
> -            seq_printf(m, "\n --\n");
> +            seq_puts(m, "\n --\n");
>  
>          /* 4. about array drives */
> -        seq_printf(m,"\nArray Drives:");
> +        seq_puts(m, "\nArray Drives:");
>          flag = FALSE;
>  
>          buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
> @@ -471,10 +471,10 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>          gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
>          
>          if (!flag)
> -            seq_printf(m, "\n --\n");
> +            seq_puts(m, "\n --\n");
>  
>          /* 5. about host drives */
> -        seq_printf(m,"\nHost Drives:");
> +        seq_puts(m, "\nHost Drives:");
>          flag = FALSE;
>  
>          buf = gdth_ioctl_alloc(ha, sizeof(gdth_hget_str), FALSE, &paddr);
> @@ -527,11 +527,11 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
>          }
>          
>          if (!flag)
> -            seq_printf(m, "\n --\n");
> +            seq_puts(m, "\n --\n");
>      }
>  
>      /* controller events */
> -    seq_printf(m,"\nController Events:\n");
> +    seq_puts(m, "\nController Events:\n");
>  
>      for (id = -1;;) {
>          id = gdth_read_event(ha, id, estr);
> diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
> index ddf0694..a73395e 100644
> --- a/drivers/scsi/in2000.c
> +++ b/drivers/scsi/in2000.c
> @@ -2226,36 +2226,36 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  
>  	if (hd->proc & PR_INFO) {
>  		seq_printf(m, "\ndip_switch=%02x: irq=%d io=%02x floppy=%s sync/DOS5=%s", (hd->dip_switch & 0x7f), instance->irq, hd->io_base, (hd->dip_switch & 0x40) ? "Yes" : "No", (hd->dip_switch & 0x20) ? "Yes" : "No");
> -		seq_printf(m, "\nsync_xfer[] =       ");
> +		seq_puts(m, "\nsync_xfer[] =       ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%02x", hd->sync_xfer[x]);
> -		seq_printf(m, "\nsync_stat[] =       ");
> +		seq_puts(m, "\nsync_stat[] =       ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%02x", hd->sync_stat[x]);
>  	}
>  #ifdef PROC_STATISTICS
>  	if (hd->proc & PR_STATISTICS) {
> -		seq_printf(m, "\ncommands issued:    ");
> +		seq_puts(m, "\ncommands issued:    ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%ld", hd->cmd_cnt[x]);
> -		seq_printf(m, "\ndisconnects allowed:");
> +		seq_puts(m, "\ndisconnects allowed:");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%ld", hd->disc_allowed_cnt[x]);
> -		seq_printf(m, "\ndisconnects done:   ");
> +		seq_puts(m, "\ndisconnects done:   ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%ld", hd->disc_done_cnt[x]);
>  		seq_printf(m, "\ninterrupts:      \t%ld", hd->int_cnt);
>  	}
>  #endif
>  	if (hd->proc & PR_CONNECTED) {
> -		seq_printf(m, "\nconnected:     ");
> +		seq_puts(m, "\nconnected:     ");
>  		if (hd->connected) {
>  			cmd = (Scsi_Cmnd *) hd->connected;
>  			seq_printf(m, " %d:%llu(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
>  		}
>  	}
>  	if (hd->proc & PR_INPUTQ) {
> -		seq_printf(m, "\ninput_Q:       ");
> +		seq_puts(m, "\ninput_Q:       ");
>  		cmd = (Scsi_Cmnd *) hd->input_Q;
>  		while (cmd) {
>  			seq_printf(m, " %d:%llu(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
> @@ -2263,7 +2263,7 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  		}
>  	}
>  	if (hd->proc & PR_DISCQ) {
> -		seq_printf(m, "\ndisconnected_Q:");
> +		seq_puts(m, "\ndisconnected_Q:");
>  		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
>  		while (cmd) {
>  			seq_printf(m, " %d:%llu(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
> @@ -2273,7 +2273,7 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  	if (hd->proc & PR_TEST) {
>  		;		/* insert your own custom function here */
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  	spin_unlock_irqrestore(instance->host_lock, flags);
>  #endif				/* PROC_INTERFACE */
>  	return 0;
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index e5c2843..615a9a3 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -2038,15 +2038,14 @@ ips_host_info(ips_ha_t *ha, struct seq_file *m)
>  {
>  	METHOD_TRACE("ips_host_info", 1);
>  
> -	seq_printf(m, "\nIBM ServeRAID General Information:\n\n");
> +	seq_puts(m, "\nIBM ServeRAID General Information:\n\n");
>  
>  	if ((le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) &&
>  	    (le16_to_cpu(ha->nvram->adapter_type) != 0))
>  		seq_printf(m, "\tController Type                   : %s\n",
>  			  ips_adapter_name[ha->ad_type - 1]);
>  	else
> -		seq_printf(m,
> -			  "\tController Type                   : Unknown\n");
> +		seq_puts(m, "\tController Type                   : Unknown\n");
>  
>  	if (ha->io_addr)
>  		seq_printf(m,
> @@ -2138,7 +2137,7 @@ ips_host_info(ips_ha_t *ha, struct seq_file *m)
>  	seq_printf(m, "\tCurrent Active PT Commands        : %d\n",
>  		  ha->num_ioctl);
>  
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  
>  	return 0;
>  }
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 2485255..bc7b34c 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -2240,7 +2240,7 @@ proc_show_battery(struct seq_file *m, void *v)
>  		goto free_pdev;
>  
>  	if( mega_adapinq(adapter, dma_handle) != 0 ) {
> -		seq_printf(m, "Adapter inquiry failed.\n");
> +		seq_puts(m, "Adapter inquiry failed.\n");
>  		printk(KERN_WARNING "megaraid: inquiry failed.\n");
>  		goto free_inquiry;
>  	}
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 3e77551..8f6b1b4 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -1456,7 +1456,7 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	data = (nsp32_hw_data *)host->hostdata;
>  	base = host->io_port;
>  
> -	seq_printf(m, "NinjaSCSI-32 status\n\n");
> +	seq_puts(m, "NinjaSCSI-32 status\n\n");
>  	seq_printf(m, "Driver version:        %s, $Revision: 1.33 $\n", nsp32_release_version);
>  	seq_printf(m, "SCSI host No.:         %d\n",		hostno);
>  	seq_printf(m, "IRQ:                   %d\n",		host->irq);
> @@ -1478,25 +1478,25 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	spin_unlock_irqrestore(&(data->Lock), flags);
>  
>  
> -	seq_printf(m, "SDTR status\n");
> +	seq_puts(m, "SDTR status\n");
>  	for (id = 0; id < ARRAY_SIZE(data->target); id++) {
>  
>  		seq_printf(m, "id %d: ", id);
>  
>  		if (id == host->this_id) {
> -			seq_printf(m, "----- NinjaSCSI-32 host adapter\n");
> +			seq_puts(m, "----- NinjaSCSI-32 host adapter\n");
>  			continue;
>  		}
>  
>  		if (data->target[id].sync_flag == SDTR_DONE) {
>  			if (data->target[id].period == 0            &&
>  			    data->target[id].offset == ASYNC_OFFSET ) {
> -				seq_printf(m, "async");
> +				seq_puts(m, "async");
>  			} else {
> -				seq_printf(m, " sync");
> +				seq_puts(m, " sync");
>  			}
>  		} else {
> -			seq_printf(m, " none");
> +			seq_puts(m, " none");
>  		}
>  
>  		if (data->target[id].period != 0) {
> @@ -1509,7 +1509,7 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
>  				data->target[id].offset
>  				);
>  		}
> -		seq_printf(m, "\n");
> +		seq_puts(m, "\n");
>  	}
>  	return 0;
>  }
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 83db942..bf883a6 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -1375,58 +1375,58 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	hostno = host->host_no;
>  	data = (nsp_hw_data *)host->hostdata;
>  
> -	seq_printf(m, "NinjaSCSI status\n\n");
> -	seq_printf(m, "Driver version:        $Revision: 1.23 $\n");
> +	seq_puts(m, "NinjaSCSI status\n\n");
> +	seq_puts(m, "Driver version:        $Revision: 1.23 $\n");
>  	seq_printf(m, "SCSI host No.:         %d\n",          hostno);
>  	seq_printf(m, "IRQ:                   %d\n",          host->irq);
>  	seq_printf(m, "IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
>  	seq_printf(m, "MMIO(virtual address): 0x%lx-0x%lx\n", host->base, host->base + data->MmioLength - 1);
>  	seq_printf(m, "sg_tablesize:          %d\n",          host->sg_tablesize);
>  
> -	seq_printf(m, "burst transfer mode:   ");
> +	seq_puts(m, "burst transfer mode:   ");
>  	switch (nsp_burst_mode) {
>  	case BURST_IO8:
> -		seq_printf(m, "io8");
> +		seq_puts(m, "io8");
>  		break;
>  	case BURST_IO32:
> -		seq_printf(m, "io32");
> +		seq_puts(m, "io32");
>  		break;
>  	case BURST_MEM32:
> -		seq_printf(m, "mem32");
> +		seq_puts(m, "mem32");
>  		break;
>  	default:
> -		seq_printf(m, "???");
> +		seq_puts(m, "???");
>  		break;
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  
>  
>  	spin_lock_irqsave(&(data->Lock), flags);
>  	seq_printf(m, "CurrentSC:             0x%p\n\n",      data->CurrentSC);
>  	spin_unlock_irqrestore(&(data->Lock), flags);
>  
> -	seq_printf(m, "SDTR status\n");
> +	seq_puts(m, "SDTR status\n");
>  	for(id = 0; id < ARRAY_SIZE(data->Sync); id++) {
>  
>  		seq_printf(m, "id %d: ", id);
>  
>  		if (id == host->this_id) {
> -			seq_printf(m, "----- NinjaSCSI-3 host adapter\n");
> +			seq_puts(m, "----- NinjaSCSI-3 host adapter\n");
>  			continue;
>  		}
>  
>  		switch(data->Sync[id].SyncNegotiation) {
>  		case SYNC_OK:
> -			seq_printf(m, " sync");
> +			seq_puts(m, " sync");
>  			break;
>  		case SYNC_NG:
> -			seq_printf(m, "async");
> +			seq_puts(m, "async");
>  			break;
>  		case SYNC_NOT_YET:
> -			seq_printf(m, " none");
> +			seq_puts(m, " none");
>  			break;
>  		default:
> -			seq_printf(m, "?????");
> +			seq_puts(m, "?????");
>  			break;
>  		}
>  
> @@ -1439,7 +1439,7 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
>  				data->Sync[id].SyncOffset
>  				);
>  		}
> -		seq_printf(m, "\n");
> +		seq_puts(m, "\n");
>  	}
>  	return 0;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
> index 2ca39b8..c837ba3 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -23,10 +23,10 @@ qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
>  
>  	mutex_lock(&ha->fce_mutex);
>  
> -	seq_printf(s, "FCE Trace Buffer\n");
> +	seq_puts(s, "FCE Trace Buffer\n");
>  	seq_printf(s, "In Pointer = %llx\n\n", (unsigned long long)ha->fce_wr);
>  	seq_printf(s, "Base = %llx\n\n", (unsigned long long) ha->fce_dma);
> -	seq_printf(s, "FCE Enable Registers\n");
> +	seq_puts(s, "FCE Enable Registers\n");
>  	seq_printf(s, "%08x %08x %08x %08x %08x %08x\n",
>  	    ha->fce_mb[0], ha->fce_mb[2], ha->fce_mb[3], ha->fce_mb[4],
>  	    ha->fce_mb[5], ha->fce_mb[6]);
> @@ -38,11 +38,11 @@ qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
>  			seq_printf(s, "\n%llx: ",
>  			    (unsigned long long)((cnt * 4) + fce_start));
>  		else
> -			seq_printf(s, " ");
> +			seq_puts(s, " ");
>  		seq_printf(s, "%08x", *fce++);
>  	}
>  
> -	seq_printf(s, "\nEnd\n");
> +	seq_puts(s, "\nEnd\n");
>  
>  	mutex_unlock(&ha->fce_mutex);
>  
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 6fcefa2..581de8f 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -189,36 +189,36 @@ static int proc_print_scsidevice(struct device *dev, void *data)
>  		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
>  	for (i = 0; i < 8; i++) {
>  		if (sdev->vendor[i] >= 0x20)
> -			seq_printf(s, "%c", sdev->vendor[i]);
> +			seq_putc(s, sdev->vendor[i]);
>  		else
> -			seq_printf(s, " ");
> +			seq_puts(s, " ");
>  	}
>  
> -	seq_printf(s, " Model: ");
> +	seq_puts(s, " Model: ");
>  	for (i = 0; i < 16; i++) {
>  		if (sdev->model[i] >= 0x20)
> -			seq_printf(s, "%c", sdev->model[i]);
> +			seq_putc(s, sdev->model[i]);
>  		else
> -			seq_printf(s, " ");
> +			seq_puts(s, " ");
>  	}
>  
> -	seq_printf(s, " Rev: ");
> +	seq_puts(s, " Rev: ");
>  	for (i = 0; i < 4; i++) {
>  		if (sdev->rev[i] >= 0x20)
> -			seq_printf(s, "%c", sdev->rev[i]);
> +			seq_putc(s, sdev->rev[i]);
>  		else
> -			seq_printf(s, " ");
> +			seq_puts(s, " ");
>  	}
>  
> -	seq_printf(s, "\n");
> +	seq_puts(s, "\n");
>  
>  	seq_printf(s, "  Type:   %s ", scsi_device_type(sdev->type));
>  	seq_printf(s, "               ANSI  SCSI revision: %02x",
>  			sdev->scsi_level - (sdev->scsi_level > 1));
>  	if (sdev->scsi_level == 2)
> -		seq_printf(s, " CCS\n");
> +		seq_puts(s, " CCS\n");
>  	else
> -		seq_printf(s, "\n");
> +		seq_puts(s, "\n");
>  
>  out:
>  	return 0;
> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
> index 503594e..e4e122b 100644
> --- a/drivers/scsi/scsi_trace.c
> +++ b/drivers/scsi/scsi_trace.c
> @@ -143,7 +143,7 @@ scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
>  		cmd = "WRITE_SAME";
>  		break;
>  	default:
> -		trace_seq_printf(p, "UNKNOWN");
> +		trace_seq_puts(p, "UNKNOWN");
>  		goto out;
>  	}
>  
> @@ -204,7 +204,7 @@ scsi_trace_service_action_in(struct trace_seq *p, unsigned char *cdb, int len)
>  		cmd = "GET_LBA_STATUS";
>  		break;
>  	default:
> -		trace_seq_printf(p, "UNKNOWN");
> +		trace_seq_puts(p, "UNKNOWN");
>  		goto out;
>  	}
>  
> @@ -249,7 +249,7 @@ scsi_trace_misc(struct trace_seq *p, unsigned char *cdb, int len)
>  {
>  	const char *ret = trace_seq_buffer_ptr(p);
>  
> -	trace_seq_printf(p, "-");
> +	trace_seq_puts(p, "-");
>  	trace_seq_putc(p, 0);
>  
>  	return ret;
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index c0506de..6e041a7 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -2143,22 +2143,22 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  		seq_printf(m, "\nclock_freq=%02x no_sync=%02x no_dma=%d"
>  			" dma_mode=%02x fast=%d",
>  			hd->clock_freq, hd->no_sync, hd->no_dma, hd->dma_mode, hd->fast);
> -		seq_printf(m, "\nsync_xfer[] =       ");
> +		seq_puts(m, "\nsync_xfer[] =       ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%02x", hd->sync_xfer[x]);
> -		seq_printf(m, "\nsync_stat[] =       ");
> +		seq_puts(m, "\nsync_stat[] =       ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%02x", hd->sync_stat[x]);
>  	}
>  #ifdef PROC_STATISTICS
>  	if (hd->proc & PR_STATISTICS) {
> -		seq_printf(m, "\ncommands issued:    ");
> +		seq_puts(m, "\ncommands issued:    ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%ld", hd->cmd_cnt[x]);
> -		seq_printf(m, "\ndisconnects allowed:");
> +		seq_puts(m, "\ndisconnects allowed:");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%ld", hd->disc_allowed_cnt[x]);
> -		seq_printf(m, "\ndisconnects done:   ");
> +		seq_puts(m, "\ndisconnects done:   ");
>  		for (x = 0; x < 7; x++)
>  			seq_printf(m, "\t%ld", hd->disc_done_cnt[x]);
>  		seq_printf(m,
> @@ -2167,7 +2167,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  	}
>  #endif
>  	if (hd->proc & PR_CONNECTED) {
> -		seq_printf(m, "\nconnected:     ");
> +		seq_puts(m, "\nconnected:     ");
>  		if (hd->connected) {
>  			cmd = (struct scsi_cmnd *) hd->connected;
>  			seq_printf(m, " %d:%llu(%02x)",
> @@ -2175,7 +2175,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  		}
>  	}
>  	if (hd->proc & PR_INPUTQ) {
> -		seq_printf(m, "\ninput_Q:       ");
> +		seq_puts(m, "\ninput_Q:       ");
>  		cmd = (struct scsi_cmnd *) hd->input_Q;
>  		while (cmd) {
>  			seq_printf(m, " %d:%llu(%02x)",
> @@ -2184,7 +2184,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  		}
>  	}
>  	if (hd->proc & PR_DISCQ) {
> -		seq_printf(m, "\ndisconnected_Q:");
> +		seq_puts(m, "\ndisconnected_Q:");
>  		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
>  		while (cmd) {
>  			seq_printf(m, " %d:%llu(%02x)",
> @@ -2192,7 +2192,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
>  			cmd = (struct scsi_cmnd *) cmd->host_scribble;
>  		}
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  	spin_unlock_irq(&hd->lock);
>  #endif				/* PROC_INTERFACE */
>  	return 0;
> diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
> index 2d7c62f..0c0f17b 100644
> --- a/drivers/scsi/wd7000.c
> +++ b/drivers/scsi/wd7000.c
> @@ -1330,9 +1330,9 @@ static int wd7000_show_info(struct seq_file *m, struct Scsi_Host *host)
>  	icmbs = adapter->mb.icmb;
>  
>  	seq_printf(m, "\nControl port value: 0x%x\n", adapter->control);
> -	seq_printf(m, "Incoming mailbox:\n");
> +	seq_puts(m, "Incoming mailbox:\n");
>  	seq_printf(m, "  size: %d\n", ICMB_CNT);
> -	seq_printf(m, "  queued messages: ");
> +	seq_puts(m, "  queued messages: ");
>  
>  	for (i = count = 0; i < ICMB_CNT; i++)
>  		if (icmbs[i].status) {
> @@ -1340,12 +1340,12 @@ static int wd7000_show_info(struct seq_file *m, struct Scsi_Host *host)
>  			seq_printf(m, "0x%x ", i);
>  		}
>  
> -	seq_printf(m, count ? "\n" : "none\n");
> +	seq_puts(m, count ? "\n" : "none\n");
>  
> -	seq_printf(m, "Outgoing mailbox:\n");
> +	seq_puts(m, "Outgoing mailbox:\n");
>  	seq_printf(m, "  size: %d\n", OGMB_CNT);
>  	seq_printf(m, "  next message: 0x%x\n", adapter->next_ogmb);
> -	seq_printf(m, "  queued messages: ");
> +	seq_puts(m, "  queued messages: ");
>  
>  	for (i = count = 0; i < OGMB_CNT; i++)
>  		if (ogmbs[i].status) {
> @@ -1353,7 +1353,7 @@ static int wd7000_show_info(struct seq_file *m, struct Scsi_Host *host)
>  			seq_printf(m, "0x%x ", i);
>  		}
>  
> -	seq_printf(m, count ? "\n" : "none\n");
> +	seq_puts(m, count ? "\n" : "none\n");
>  #endif
>  
>  	spin_unlock_irqrestore(host->host_lock, flags);
> 
