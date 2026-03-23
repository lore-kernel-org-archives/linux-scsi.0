Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BB42BD11
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 01:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774230463; cv=none; b=Ia8tOmZ/p8xy2IcaH/2o+IDsJ71z6/5+VITegXBtHWSQQdQaxu5hxRJTsG+cR5KscUo8k4HhUpYY2vBmnOoMPIy31jRTDOhJd84YLXpQ8gEbQMxKegr1sAILOxgu5fQUzxhvrtE4gxZEiqcsU1s27w4YkyCFCyOon5ap511PBtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774230463; c=relaxed/simple;
	bh=jafAGRLzr8NKC1emxPbeq1UQICMHzhw+RRtpak0W+o0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZWGgZWBPwGNCORlmO5DCow5QwnsoK7Oi7eKPcbzZKzRNEnbAcRIb1bSw1tn2G4Uu6McRg7EB+qIHmEnfk2EBrGIkrGmpMAGBofiCNi+lR3ChxoMtPgUPsqiEp5uMBhUm5GnTgpC1k12a6kcSNNu38JBeTX42cnJRNAS2e2oUq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUIlIb48; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUIlIb48"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774230460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qam+6bNONqgFujoaq27YvMpwllMtKmiSmvbFS1O5HHk=;
	b=DUIlIb48p2LgJy6HF7Yfpx94ehbr3pOzEuvDgQSb2iXUHLo3CF+0MwieN2lc8eILAQVX3f
	fhso16hgEmiJ8v7sO7u4rDVDJy6INneCMSh0tFPoNRRcff20ijz4i93YAiyvRfrgi7XnXB
	6Gozdf/3uSSCRuA5EPIVmQJkVe1d0uA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-292-zhXXiLlCPqyuFYODJM7Lig-1; Sun,
 22 Mar 2026 21:47:38 -0400
X-MC-Unique: zhXXiLlCPqyuFYODJM7Lig-1
X-Mimecast-MFC-AGG-ID: zhXXiLlCPqyuFYODJM7Lig_1774230457
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64B2E1977035;
	Mon, 23 Mar 2026 01:47:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87E9019560B7;
	Mon, 23 Mar 2026 01:47:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62N1lS251003198
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 22 Mar 2026 21:47:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62N1lSa01003197;
	Sun, 22 Mar 2026 21:47:28 -0400
Date: Sun, 22 Mar 2026 21:47:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] scsi: scsi_dh_alua: Switch to use core support
Message-ID: <acCbsAISEJC2VfwO@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-13-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317120703.3702387-13-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Mar 17, 2026 at 12:07:02PM +0000, John Garry wrote:
> Switch to use core scsi ALUA support.
> 
> We still need to drive the state machine for explicit ALUA.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 580 +--------------------
>  1 file changed, 21 insertions(+), 559 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 067021fffc16f..4d53fab85a7ed 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -10,6 +10,7 @@
>  #include <linux/module.h>
>  #include <linux/unaligned.h>
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_alua.h>
>  #include <scsi/scsi_proto.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_eh.h>
> @@ -44,7 +45,6 @@
>  
>  /* device handler flags */
>  #define ALUA_OPTIMIZE_STPG		0x01
> -#define ALUA_RTPG_EXT_HDR_UNSUPP	0x02
>  /* State machine flags */
>  #define ALUA_PG_RUN_RTPG		0x10
>  #define ALUA_PG_RUN_STPG		0x20
> @@ -65,14 +65,6 @@ struct alua_dh_data {
>  	unsigned		flags; /* used for optimizing STPG */
>  	spinlock_t		lock;
>  
> -	/* alua stuff */
> -	int			state;
> -	int			pref;
> -	int			valid_states;
> -	int			tpgs;
> -	unsigned char		transition_tmo;
> -	unsigned long		expiry;
> -	unsigned long		interval;
>  	struct delayed_work	rtpg_work;
>  	struct list_head	rtpg_list;
>  };
> @@ -91,121 +83,6 @@ static bool alua_rtpg_queue(struct scsi_device *sdev,
>  			    struct alua_queue_data *qdata, bool force);
>  static void alua_check(struct scsi_device *sdev, bool force);
>  
> -/*
> - * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
> - * @sdev: sdev the command should be sent to
> - */
> -static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
> -		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
> -{
> -	u8 cdb[MAX_COMMAND_SIZE];
> -	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
> -				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
> -	const struct scsi_exec_args exec_args = {
> -		.sshdr = sshdr,
> -	};
> -
> -	/* Prepare the command. */
> -	memset(cdb, 0x0, MAX_COMMAND_SIZE);
> -	cdb[0] = MAINTENANCE_IN;
> -	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
> -		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
> -	else
> -		cdb[1] = MI_REPORT_TARGET_PGS;
> -	put_unaligned_be32(bufflen, &cdb[6]);
> -
> -	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
> -				ALUA_FAILOVER_TIMEOUT * HZ,
> -				ALUA_FAILOVER_RETRIES, &exec_args);
> -}
> -
> -/*
> - * submit_stpg - Issue a SET TARGET PORT GROUP command
> - *
> - * Currently we're only setting the current target port group state
> - * to 'active/optimized' and let the array firmware figure out
> - * the states of the remaining groups.
> - */
> -static int submit_stpg(struct scsi_device *sdev, int group_id,
> -		       struct scsi_sense_hdr *sshdr)
> -{
> -	u8 cdb[MAX_COMMAND_SIZE];
> -	unsigned char stpg_data[8];
> -	int stpg_len = 8;
> -	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
> -				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
> -	const struct scsi_exec_args exec_args = {
> -		.sshdr = sshdr,
> -	};
> -
> -	/* Prepare the data buffer */
> -	memset(stpg_data, 0, stpg_len);
> -	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL;
> -	put_unaligned_be16(group_id, &stpg_data[6]);
> -
> -	/* Prepare the command. */
> -	memset(cdb, 0x0, MAX_COMMAND_SIZE);
> -	cdb[0] = MAINTENANCE_OUT;
> -	cdb[1] = MO_SET_TARGET_PGS;
> -	put_unaligned_be32(stpg_len, &cdb[6]);
> -
> -	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
> -				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
> -				ALUA_FAILOVER_RETRIES, &exec_args);
> -}
> -
> -/*
> - * alua_check_tpgs - Evaluate TPGS setting
> - * @sdev: device to be checked
> - *
> - * Examine the TPGS setting of the sdev to find out if ALUA
> - * is supported.
> - */
> -static int alua_check_tpgs(struct scsi_device *sdev)
> -{
> -	int tpgs = TPGS_MODE_NONE;
> -
> -	/*
> -	 * ALUA support for non-disk devices is fraught with
> -	 * difficulties, so disable it for now.
> -	 */
> -	if (sdev->type != TYPE_DISK) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: disable for non-disk devices\n",
> -			    ALUA_DH_NAME);
> -		return tpgs;
> -	}
> -
> -	tpgs = scsi_device_tpgs(sdev);
> -	switch (tpgs) {
> -	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: supports implicit and explicit TPGS\n",
> -			    ALUA_DH_NAME);
> -		break;
> -	case TPGS_MODE_EXPLICIT:
> -		sdev_printk(KERN_INFO, sdev, "%s: supports explicit TPGS\n",
> -			    ALUA_DH_NAME);
> -		break;
> -	case TPGS_MODE_IMPLICIT:
> -		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
> -			    ALUA_DH_NAME);
> -		break;
> -	case TPGS_MODE_NONE:
> -		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
> -			    ALUA_DH_NAME);
> -		break;
> -	default:
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: unsupported TPGS setting %d\n",
> -			    ALUA_DH_NAME, tpgs);
> -		tpgs = TPGS_MODE_NONE;
> -		break;
> -	}
> -
> -	return tpgs;
> -}
> -
>  /*
>   * alua_check_vpd - Evaluate INQUIRY vpd page 0x83
>   * @sdev: device to be checked
> @@ -216,56 +93,11 @@ static int alua_check_tpgs(struct scsi_device *sdev)
>  static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>  			  int tpgs)
>  {
> -	int rel_port = -1;
> -
> -	h->group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> -	if (h->group_id < 0) {
> -		/*
> -		 * Internal error; TPGS supported but required
> -		 * VPD identification descriptors not present.
> -		 * Disable ALUA support
> -		 */
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: No target port descriptors found\n",
> -			    ALUA_DH_NAME);
> -		return SCSI_DH_DEV_UNSUPP;
> -	}
> -	h->tpgs = tpgs;
> -
>  	alua_rtpg_queue(sdev, NULL, true);
>  
>  	return SCSI_DH_OK;
>  }
>  
> -static char print_alua_state(unsigned char state)
> -{
> -	switch (state) {
> -	case SCSI_ACCESS_STATE_OPTIMAL:
> -		return 'A';
> -	case SCSI_ACCESS_STATE_ACTIVE:
> -		return 'N';
> -	case SCSI_ACCESS_STATE_STANDBY:
> -		return 'S';
> -	case SCSI_ACCESS_STATE_UNAVAILABLE:
> -		return 'U';
> -	case SCSI_ACCESS_STATE_LBA:
> -		return 'L';
> -	case SCSI_ACCESS_STATE_OFFLINE:
> -		return 'O';
> -	case SCSI_ACCESS_STATE_TRANSITIONING:
> -		return 'T';
> -	default:
> -		return 'X';
> -	}
> -}
> -
> -static void alua_handle_state_transition(struct scsi_device *sdev)
> -{
> -	struct alua_dh_data *h = sdev->handler_data;
> -
> -	h->state = SCSI_ACCESS_STATE_TRANSITIONING;
> -}
> -
>  static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
>  					      struct scsi_sense_hdr *sense_hdr)
>  {
> @@ -275,7 +107,7 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
>  			/*
>  			 * LUN Not Accessible - ALUA state transition
>  			 */
> -			alua_handle_state_transition(sdev);
> +			scsi_alua_handle_state_transition(sdev);
>  			return NEEDS_RETRY;
>  		}
>  		break;
> @@ -284,7 +116,7 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
>  			/*
>  			 * LUN Not Accessible - ALUA state transition
>  			 */
> -			alua_handle_state_transition(sdev);
> +			scsi_alua_handle_state_transition(sdev);
>  			return NEEDS_RETRY;
>  		}
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
> @@ -338,329 +170,6 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
>  	return SCSI_RETURN_NOT_HANDLED;
>  }
>  
> -/*
> - * alua_tur - Send a TEST UNIT READY
> - * @sdev: device to which the TEST UNIT READY command should be send
> - *
> - * Send a TEST UNIT READY to @sdev to figure out the device state
> - * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
> - * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
> - */
> -static int alua_tur(struct scsi_device *sdev)
> -{
> -	struct scsi_sense_hdr sense_hdr;
> -	int retval;
> -
> -	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
> -				      ALUA_FAILOVER_RETRIES, &sense_hdr);
> -	if ((sense_hdr.sense_key == NOT_READY ||
> -	     sense_hdr.sense_key == UNIT_ATTENTION) &&
> -	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
> -		return SCSI_DH_RETRY;
> -	else if (retval)
> -		return SCSI_DH_IO;
> -	else
> -		return SCSI_DH_OK;
> -}
> -
> -/*
> - * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
> - * @sdev: the device to be evaluated.
> - *
> - * Evaluate the Target Port Group State.
> - * Returns SCSI_DH_DEV_OFFLINED if the path is
> - * found to be unusable.
> - */
> -static int alua_rtpg(struct scsi_device *sdev)
> -{
> -	struct scsi_sense_hdr sense_hdr;
> -	struct alua_dh_data *h = sdev->handler_data;
> -	int len, k, off, bufflen = ALUA_RTPG_SIZE;
> -	int group_id_old, state_old, pref_old, valid_states_old;
> -	unsigned char *desc, *buff;
> -	unsigned err;
> -	int retval;
> -	unsigned int tpg_desc_tbl_off;
> -	unsigned char orig_transition_tmo;
> -	unsigned long flags;
> -	bool transitioning_sense = false;
> -	int rel_port, group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> -
> -	if (group_id < 0) {
> -		/*
> -		 * Internal error; TPGS supported but required
> -		 * VPD identification descriptors not present.
> -		 * Disable ALUA support
> -		 */
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: No target port descriptors found\n",
> -			    ALUA_DH_NAME);
> -		return SCSI_DH_DEV_UNSUPP;
> -	}
> -
> -	group_id_old = h->group_id;
> -	state_old = h->state;
> -	pref_old = h->pref;
> -	valid_states_old = h->valid_states;
> -
> -	if (!h->expiry) {
> -		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
> -
> -		if (h->transition_tmo)
> -			transition_tmo = h->transition_tmo * HZ;
> -
> -		h->expiry = round_jiffies_up(jiffies + transition_tmo);
> -	}
> -
> -	buff = kzalloc(bufflen, GFP_KERNEL);
> -	if (!buff)
> -		return SCSI_DH_DEV_TEMP_BUSY;
> -
> - retry:
> -	err = 0;
> -	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, h->flags);
> -
> -	if (retval) {
> -		/*
> -		 * Some (broken) implementations have a habit of returning
> -		 * an error during things like firmware update etc.
> -		 * But if the target only supports active/optimized there's
> -		 * not much we can do; it's not that we can switch paths
> -		 * or anything.
> -		 * So ignore any errors to avoid spurious failures during
> -		 * path failover.
> -		 */
> -		if ((h->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
> -			sdev_printk(KERN_INFO, sdev,
> -				    "%s: ignoring rtpg result %d\n",
> -				    ALUA_DH_NAME, retval);
> -			kfree(buff);
> -			return SCSI_DH_OK;
> -		}
> -		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
> -			sdev_printk(KERN_INFO, sdev,
> -				    "%s: rtpg failed, result %d\n",
> -				    ALUA_DH_NAME, retval);
> -			kfree(buff);
> -			if (retval < 0)
> -				return SCSI_DH_DEV_TEMP_BUSY;
> -			if (host_byte(retval) == DID_NO_CONNECT)
> -				return SCSI_DH_RES_TEMP_UNAVAIL;
> -			return SCSI_DH_IO;
> -		}
> -
> -		/*
> -		 * submit_rtpg() has failed on existing arrays
> -		 * when requesting extended header info, and
> -		 * the array doesn't support extended headers,
> -		 * even though it shouldn't according to T10.
> -		 * The retry without rtpg_ext_hdr_req set
> -		 * handles this.
> -		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
> -		 * with ASC 00h if they don't support the extended header.
> -		 */
> -		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> -		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
> -			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
> -			goto retry;
> -		}
> -		/*
> -		 * If the array returns with 'ALUA state transition'
> -		 * sense code here it cannot return RTPG data during
> -		 * transition. So set the state to 'transitioning' directly.
> -		 */
> -		if (sense_hdr.sense_key == NOT_READY &&
> -		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
> -			transitioning_sense = true;
> -			goto skip_rtpg;
> -		}
> -		/*
> -		 * Retry on any other UNIT ATTENTION occurred.
> -		 */
> -		if (sense_hdr.sense_key == UNIT_ATTENTION)
> -			err = SCSI_DH_RETRY;
> -		if (err == SCSI_DH_RETRY &&
> -		    h->expiry != 0 && time_before(jiffies, h->expiry)) {
> -			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
> -				    ALUA_DH_NAME);
> -			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> -			kfree(buff);
> -			return err;
> -		}
> -		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
> -			    ALUA_DH_NAME);
> -		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> -		kfree(buff);
> -		h->expiry = 0;
> -		return SCSI_DH_IO;
> -	}
> -
> -	len = get_unaligned_be32(&buff[0]) + 4;
> -
> -	if (len > bufflen) {
> -		/* Resubmit with the correct length */
> -		kfree(buff);
> -		bufflen = len;
> -		buff = kmalloc(bufflen, GFP_KERNEL);
> -		if (!buff) {
> -			sdev_printk(KERN_WARNING, sdev,
> -				    "%s: kmalloc buffer failed\n",__func__);
> -			/* Temporary failure, bypass */
> -			h->expiry = 0;
> -			return SCSI_DH_DEV_TEMP_BUSY;
> -		}
> -		goto retry;
> -	}
> -
> -	orig_transition_tmo = h->transition_tmo;
> -	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
> -		h->transition_tmo = buff[5];
> -	else
> -		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> -
> -	if (orig_transition_tmo != h->transition_tmo) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: transition timeout set to %d seconds\n",
> -			    ALUA_DH_NAME, h->transition_tmo);
> -		h->expiry = jiffies + h->transition_tmo * HZ;
> -	}
> -
> -	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> -		tpg_desc_tbl_off = 8;
> -	else
> -		tpg_desc_tbl_off = 4;
> -
> -	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
> -	     k < len;
> -	     k += off, desc += off) {
> -		u16 group_id_desc = get_unaligned_be16(&desc[2]);
> -
> -		spin_lock_irqsave(&h->lock, flags);
> -		if (group_id_desc == group_id) {
> -			h->group_id = group_id;
> -			WRITE_ONCE(h->state, desc[0] & 0x0f);
> -			h->pref = desc[0] >> 7;
> -			WRITE_ONCE(sdev->access_state, desc[0]);
> -			h->valid_states = desc[1];
> -		}
> -		spin_unlock_irqrestore(&h->lock, flags);
> -		off = 8 + (desc[7] * 4);
> -	}
> -
> - skip_rtpg:
> -	spin_lock_irqsave(&h->lock, flags);
> -	if (transitioning_sense)
> -		h->state = SCSI_ACCESS_STATE_TRANSITIONING;
> -
> -	if (group_id_old != h->group_id || state_old != h->state ||
> -		pref_old != h->pref || valid_states_old != h->valid_states)
> -		sdev_printk(KERN_INFO, sdev,
> -			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
> -			ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
> -			h->pref ? "preferred" : "non-preferred",
> -			h->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> -			h->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> -			h->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> -			h->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> -			h->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> -			h->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> -			h->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> -
> -	switch (h->state) {
> -	case SCSI_ACCESS_STATE_TRANSITIONING:
> -		if (time_before(jiffies, h->expiry)) {
> -			/* State transition, retry */
> -			h->interval = ALUA_RTPG_RETRY_DELAY;
> -			err = SCSI_DH_RETRY;
> -		} else {
> -			struct alua_dh_data *h;
> -			unsigned char access_state;
> -
> -			/* Transitioning time exceeded, set port to standby */
> -			err = SCSI_DH_IO;
> -			h->state = SCSI_ACCESS_STATE_STANDBY;
> -			h->expiry = 0;
> -			access_state = h->state & SCSI_ACCESS_STATE_MASK;
> -			if (h->pref)
> -				access_state |= SCSI_ACCESS_STATE_PREFERRED;
> -			WRITE_ONCE(sdev->access_state, access_state);
> -		}
> -		break;
> -	case SCSI_ACCESS_STATE_OFFLINE:
> -		/* Path unusable */
> -		err = SCSI_DH_DEV_OFFLINED;
> -		h->expiry = 0;
> -		break;
> -	default:
> -		/* Useable path if active */
> -		err = SCSI_DH_OK;
> -		h->expiry = 0;
> -		break;
> -	}
> -	spin_unlock_irqrestore(&h->lock, flags);
> -	kfree(buff);
> -	return err;
> -}
> -
> -/*
> - * alua_stpg - Issue a SET TARGET PORT GROUP command
> - *
> - * Issue a SET TARGET PORT GROUP command and evaluate the
> - * response. Returns SCSI_DH_RETRY per default to trigger
> - * a re-evaluation of the target group state or SCSI_DH_OK
> - * if no further action needs to be taken.
> - */
> -static unsigned alua_stpg(struct scsi_device *sdev)
> -{
> -	int retval;
> -	struct scsi_sense_hdr sense_hdr;
> -	struct alua_dh_data *h = sdev->handler_data;
> -
> -	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
> -		/* Only implicit ALUA supported, retry */
> -		return SCSI_DH_RETRY;
> -	}
> -	switch (h->state) {
> -	case SCSI_ACCESS_STATE_OPTIMAL:
> -		return SCSI_DH_OK;
> -	case SCSI_ACCESS_STATE_ACTIVE:
> -		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
> -		    !h->pref &&
> -		    (h->tpgs & TPGS_MODE_IMPLICIT))
> -			return SCSI_DH_OK;
> -		break;
> -	case SCSI_ACCESS_STATE_STANDBY:
> -	case SCSI_ACCESS_STATE_UNAVAILABLE:
> -		break;
> -	case SCSI_ACCESS_STATE_OFFLINE:
> -		return SCSI_DH_IO;
> -	case SCSI_ACCESS_STATE_TRANSITIONING:
> -		break;
> -	default:
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: stpg failed, unhandled TPGS state %d",
> -			    ALUA_DH_NAME, h->state);
> -		return SCSI_DH_NOSYS;
> -	}
> -	retval = submit_stpg(sdev, h->group_id, &sense_hdr);
> -
> -	if (retval) {
> -		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
> -			sdev_printk(KERN_INFO, sdev,
> -				    "%s: stpg failed, result %d",
> -				    ALUA_DH_NAME, retval);
> -			if (retval < 0)
> -				return SCSI_DH_DEV_TEMP_BUSY;
> -		} else {
> -			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
> -				    ALUA_DH_NAME);
> -			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> -		}
> -	}
> -	/* Retry RTPG */
> -	return SCSI_DH_RETRY;
> -}
> -
>  static void alua_rtpg_work(struct work_struct *work)
>  {
>  	struct alua_dh_data *h =
> @@ -670,56 +179,41 @@ static void alua_rtpg_work(struct work_struct *work)
>  	int err = SCSI_DH_OK;
>  	struct alua_queue_data *qdata, *tmp;
>  	unsigned long flags;
> +	int ret;
>  
>  	spin_lock_irqsave(&h->lock, flags);
>  	h->flags |= ALUA_PG_RUNNING;
>  	if (h->flags & ALUA_PG_RUN_RTPG) {
> -		int state = h->state;
>  
>  		h->flags &= ~ALUA_PG_RUN_RTPG;
>  		spin_unlock_irqrestore(&h->lock, flags);
> -		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
> -			if (alua_tur(sdev) == SCSI_DH_RETRY) {
> -				spin_lock_irqsave(&h->lock, flags);
> -				h->flags &= ~ALUA_PG_RUNNING;
> -				h->flags |= ALUA_PG_RUN_RTPG;
> -				if (!h->interval)
> -					h->interval = ALUA_RTPG_RETRY_DELAY;
> -				spin_unlock_irqrestore(&h->lock, flags);
> -				queue_delayed_work(kaluad_wq, &h->rtpg_work,
> -						   h->interval * HZ);
> -				return;
> -			}
> -			/* Send RTPG on failure or if TUR indicates SUCCESS */
> -		}
> -		err = alua_rtpg(sdev);
> -		spin_lock_irqsave(&h->lock, flags);
> -
> -		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
> +		ret = scsi_alua_rtpg_run(sdev);
> +		if (ret == -EAGAIN) {

This no longer handles the case where you want to trigger a new rtpg as
soon as the running one finishes. I think it should be checking
(ret == -EAGAIN || h->flags & ALUA_PG_RUN_RTPG)
with a spinlock held.

> +			spin_lock_irqsave(&h->lock, flags);
>  			h->flags &= ~ALUA_PG_RUNNING;
> -			if (err == SCSI_DH_IMM_RETRY)
> -				h->interval = 0;
> -			else if (!h->interval && !(h->flags & ALUA_PG_RUN_RTPG))
> -				h->interval = ALUA_RTPG_RETRY_DELAY;
>  			h->flags |= ALUA_PG_RUN_RTPG;
>  			spin_unlock_irqrestore(&h->lock, flags);
> -			goto queue_rtpg;
> +			queue_delayed_work(kaluad_wq, &h->rtpg_work,
> +							   sdev->alua->interval * HZ);
> +			return;
>  		}
> -		if (err != SCSI_DH_OK)
> -			h->flags &= ~ALUA_PG_RUN_STPG;
> +		if (err != 0)
> +				h->flags &= ~ALUA_PG_RUN_STPG;
>  	}
> +	spin_lock_irqsave(&h->lock, flags);

If h->flags & ALUA_PG_RUN_RTPG is false above, h->lock will already be
locked.

>  	if (h->flags & ALUA_PG_RUN_STPG) {
>  		h->flags &= ~ALUA_PG_RUN_STPG;
>  		spin_unlock_irqrestore(&h->lock, flags);
> -		err = alua_stpg(sdev);
> -		spin_lock_irqsave(&h->lock, flags);
> -		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
> +		ret = scsi_alua_stpg_run(sdev, h->flags & ALUA_OPTIMIZE_STPG);
> +		if (err == -EAGAIN || h->flags & ALUA_PG_RUN_RTPG) {

To avoid a race with resetting ALUA_PG_RUN_RTPG, this check needs to be
done with the spinlock held.

-Ben

> +			spin_lock_irqsave(&h->lock, flags);
>  			h->flags |= ALUA_PG_RUN_RTPG;
> -			h->interval = 0;
>  			h->flags &= ~ALUA_PG_RUNNING;
>  			spin_unlock_irqrestore(&h->lock, flags);
>  			goto queue_rtpg;
>  		}
> +	} else {
> +		spin_unlock_irqrestore(&h->lock, flags);
>  	}
>  
>  	list_splice_init(&h->rtpg_list, &qdata_list);
> @@ -728,8 +222,6 @@ static void alua_rtpg_work(struct work_struct *work)
>  	 * Re-enable the device for the next attempt.
>  	 */
>  	h->disabled = false;
> -	spin_unlock_irqrestore(&h->lock, flags);
> -
>  
>  	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
>  		list_del(&qdata->entry);
> @@ -745,7 +237,7 @@ static void alua_rtpg_work(struct work_struct *work)
>  	return;
>  
>  queue_rtpg:
> -	queue_delayed_work(kaluad_wq, &h->rtpg_work, h->interval * HZ);
> +	queue_delayed_work(kaluad_wq, &h->rtpg_work, sdev->alua->interval * HZ);
>  }
>  
>  /**
> @@ -809,7 +301,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
>  
>  	mutex_lock(&h->init_mutex);
>  	h->disabled = false;
> -	tpgs = alua_check_tpgs(sdev);
> +	tpgs = scsi_alua_check_tpgs(sdev);
>  	if (tpgs != TPGS_MODE_NONE)
>  		err = alua_check_vpd(sdev, h, tpgs);
>  	h->init_error = err;
> @@ -898,34 +390,6 @@ static void alua_check(struct scsi_device *sdev, bool force)
>  	alua_rtpg_queue(sdev, NULL, force);
>  }
>  
> -/*
> - * alua_prep_fn - request callback
> - *
> - * Fail I/O to all paths not in state
> - * active/optimized or active/non-optimized.
> - */
> -static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
> -{
> -	struct alua_dh_data *h = sdev->handler_data;
> -	unsigned long flags;
> -	unsigned char state;
> -
> -	spin_lock_irqsave(&h->lock, flags);
> -	state = h->state;
> -	spin_unlock_irqrestore(&h->lock, flags);
> -
> -	switch (state) {
> -	case SCSI_ACCESS_STATE_OPTIMAL:
> -	case SCSI_ACCESS_STATE_ACTIVE:
> -	case SCSI_ACCESS_STATE_LBA:
> -	case SCSI_ACCESS_STATE_TRANSITIONING:
> -		return BLK_STS_OK;
> -	default:
> -		req->rq_flags |= RQF_QUIET;
> -		return BLK_STS_IOERR;
> -	}
> -}
> -
>  static void alua_rescan(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
> @@ -953,8 +417,6 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  
>  	mutex_init(&h->init_mutex);
>  
> -	h->state = SCSI_ACCESS_STATE_OPTIMAL;
> -	h->valid_states = TPGS_SUPPORT_ALL;
>  	if (optimize_stpg)
>  		h->flags |= ALUA_OPTIMIZE_STPG;
>  
> @@ -986,7 +448,7 @@ static struct scsi_device_handler alua_dh = {
>  	.module = THIS_MODULE,
>  	.attach = alua_bus_attach,
>  	.detach = alua_bus_detach,
> -	.prep_fn = alua_prep_fn,
> +	.prep_fn = scsi_alua_prep_fn,
>  	.check_sense = alua_check_sense,
>  	.activate = alua_activate,
>  	.rescan = alua_rescan,
> -- 
> 2.43.5

