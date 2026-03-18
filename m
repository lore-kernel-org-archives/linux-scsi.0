Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DC626290
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820209; cv=none; b=lm75zl3q6z5Slm1C9OH8M7wvMVSYJ2atMo/toVHLiSWIyUeIQyLJnQQf6sbJ5QSogVe6vhzsDJhCFxHzRmP0Pd9G4wCBReVbMiNYn/qgJK41Jdy8VUPe+PazQVQtd0ObJZfifG+a6SGcY60gGMWcfQtqjtaLsWnvQezOGmH7jEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820209; c=relaxed/simple;
	bh=/Fg0Y939C33vfMVmPX7bAMPw1e0U1IsD/BzyABomYiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnIksIpcTUj1Iau6/B+n/ybBv7+ezQLomXIKZhHVfHF6HORMtpDe4LgQ+OqO2ANrlL8PLBdUbcI8joMKm/UZXLD//om8Aka0yXmWP5dVdKaZwVSWBuhgNY3qH8QsdmkJf4drVAaieWSGYx+EQzZxJ3D6Dkp2XMf/BkZ/JEbQnMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fYuSdtP+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AmpHrd6e; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fYuSdtP+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AmpHrd6e; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fYuSdtP+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AmpHrd6e";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fYuSdtP+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AmpHrd6e"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A34054D3D6;
	Wed, 18 Mar 2026 07:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLz8UQMNJzYE+bSKI1/tWFq7Q/hFysCsVvQURTFYpnQ=;
	b=fYuSdtP+T8bnrT+RPkp3JeQ+Nj/2oSunQ9jcgI3mDwiWm3iRwcuTNy5LJ0Qs/e+XFAvfjA
	In1bSkjpPLiAg9jOtIehHAik7ELMSb2JjMrbdJv0zkRs9Cn0urjtegs/2jwBvYL67wsxDb
	VUN2DP+LQetYsonkFjR5j5nxNt0fTE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLz8UQMNJzYE+bSKI1/tWFq7Q/hFysCsVvQURTFYpnQ=;
	b=AmpHrd6e0xmJbTgdzEz1XUUDlGSrwmUI9kz9Wkdk+RxbIJQFma7J2r0Y/Ozn0OaAvxuviF
	+IxHXs8ULGzu5gAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYuSdtP+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AmpHrd6e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLz8UQMNJzYE+bSKI1/tWFq7Q/hFysCsVvQURTFYpnQ=;
	b=fYuSdtP+T8bnrT+RPkp3JeQ+Nj/2oSunQ9jcgI3mDwiWm3iRwcuTNy5LJ0Qs/e+XFAvfjA
	In1bSkjpPLiAg9jOtIehHAik7ELMSb2JjMrbdJv0zkRs9Cn0urjtegs/2jwBvYL67wsxDb
	VUN2DP+LQetYsonkFjR5j5nxNt0fTE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLz8UQMNJzYE+bSKI1/tWFq7Q/hFysCsVvQURTFYpnQ=;
	b=AmpHrd6e0xmJbTgdzEz1XUUDlGSrwmUI9kz9Wkdk+RxbIJQFma7J2r0Y/Ozn0OaAvxuviF
	+IxHXs8ULGzu5gAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45C214273C;
	Wed, 18 Mar 2026 07:50:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NWRqDy1ZummARgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 07:50:05 +0000
Message-ID: <fc8e8f45-6b82-4400-a5d7-f155287942f8@suse.de>
Date: Wed, 18 Mar 2026 08:50:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] scsi: alua: Add scsi_alua_rtpg()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A34054D3D6

On 3/17/26 13:06, John Garry wrote:
> Add scsi_alua_rtpg(), which does the same as alua_rtpg() from
> scsi_dh_alua.c
> 
> Members of the per-sdev alua_data structure are updated from same in
> alua_dh_data.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_alua.c | 311 +++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_alua.h |   8 +
>   2 files changed, 319 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index a5a67c6deff17..50c1d17b52dc7 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -6,6 +6,8 @@
>    * All rights reserved.
>    */
>   
> +#include <linux/unaligned.h>
> +
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_proto.h>
>   #include <scsi/scsi_dbg.h>
> @@ -16,6 +18,314 @@
>   
>   static struct workqueue_struct *kalua_wq;
>   
> +#define TPGS_SUPPORT_NONE		0x00
> +#define TPGS_SUPPORT_OPTIMIZED		0x01
> +#define TPGS_SUPPORT_NONOPTIMIZED	0x02
> +#define TPGS_SUPPORT_STANDBY		0x04
> +#define TPGS_SUPPORT_UNAVAILABLE	0x08
> +#define TPGS_SUPPORT_LBA_DEPENDENT	0x10
> +#define TPGS_SUPPORT_OFFLINE		0x40
> +#define TPGS_SUPPORT_TRANSITION		0x80
> +#define TPGS_SUPPORT_ALL		0xdf
> +
> +#define RTPG_FMT_MASK			0x70
> +#define RTPG_FMT_EXT_HDR		0x10
> +
> +#define ALUA_RTPG_SIZE			128
> +#define ALUA_FAILOVER_TIMEOUT		60
> +#define ALUA_FAILOVER_RETRIES		5
> +#define ALUA_RTPG_DELAY_MSECS		5
> +#define ALUA_RTPG_RETRY_DELAY		2
> +
> +/*
> + * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
> + * @sdev: sdev the command should be sent to
> + */
> +static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
> +		       int bufflen, struct scsi_sense_hdr *sshdr)
> +{
> +	u8 cdb[MAX_COMMAND_SIZE];
> +	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
> +				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
> +	const struct scsi_exec_args exec_args = {
> +		.sshdr = sshdr,
> +	};
> +
> +	/* Prepare the command. */
> +	memset(cdb, 0x0, MAX_COMMAND_SIZE);
> +	cdb[0] = MAINTENANCE_IN;
> +	if (!sdev->alua->rtpg_ext_hdr_unsupp)
> +		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
> +	else
> +		cdb[1] = MI_REPORT_TARGET_PGS;
> +	put_unaligned_be32(bufflen, &cdb[6]);
> +
> +	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
> +				ALUA_FAILOVER_TIMEOUT * HZ,
> +				ALUA_FAILOVER_RETRIES, &exec_args);
> +}
> +
> +static char print_alua_state(unsigned char state)
> +{
> +	switch (state) {
> +	case SCSI_ACCESS_STATE_OPTIMAL:
> +		return 'A';
> +	case SCSI_ACCESS_STATE_ACTIVE:
> +		return 'N';
> +	case SCSI_ACCESS_STATE_STANDBY:
> +		return 'S';
> +	case SCSI_ACCESS_STATE_UNAVAILABLE:
> +		return 'U';
> +	case SCSI_ACCESS_STATE_LBA:
> +		return 'L';
> +	case SCSI_ACCESS_STATE_OFFLINE:
> +		return 'O';
> +	case SCSI_ACCESS_STATE_TRANSITIONING:
> +		return 'T';
> +	default:
> +		return 'X';
> +	}
> +}
> +
> +/*
> + * scsi_alua_rtpg - Evaluate REPORT TARGET GROUP STATES
> + * @sdev: the device to be evaluated.
> + *
> + * Evaluate the Target Port Group State.
> + * Returns -ENODEV if the path is
> + * found to be unusable.
> + */
> +__maybe_unused
> +static int scsi_alua_rtpg(struct scsi_device *sdev)
> +{
> +	struct alua_data *alua = sdev->alua;
> +	struct scsi_sense_hdr sense_hdr;
> +	int len, k, off, bufflen = ALUA_RTPG_SIZE;
> +	int group_id_old, state_old, pref_old, valid_states_old;
> +	unsigned char *desc, *buff;
> +	unsigned err;
> +	int retval;
> +	unsigned int tpg_desc_tbl_off;
> +	unsigned char orig_transition_tmo;
> +	unsigned long flags;
> +	bool transitioning_sense = false;
> +	int rel_port, group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> +
> +	if (group_id < 0) {
> +		/*
> +		 * Internal error; TPGS supported but required
> +		 * VPD identification descriptors not present.
> +		 * Disable ALUA support
> +		 */
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: No target port descriptors found\n",
> +			    DRV_NAME);
> +		return -EOPNOTSUPP; //SCSI_DH_DEV_UNSUPP;
> +	}
> +
> +	group_id_old = alua->group_id;
> +	state_old = alua->state;
> +	pref_old = alua->pref;
> +	valid_states_old = alua->valid_states;
> +
> +	if (!alua->expiry) {
> +		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
> +
> +		if (alua->transition_tmo)
> +			transition_tmo = alua->transition_tmo * HZ;
> +
> +		alua->expiry = round_jiffies_up(jiffies + transition_tmo);
> +	}
> +
> +	buff = kzalloc(bufflen, GFP_KERNEL);
> +	if (!buff)
> +		return -ENOMEM;
> +
> + retry:
> +	err = 0;
> +	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr);
> +
> +	if (retval) {
> +		/*
> +		 * Some (broken) implementations have a habit of returning
> +		 * an error during things like firmware update etc.
> +		 * But if the target only supports active/optimized there's
> +		 * not much we can do; it's not that we can switch paths
> +		 * or anything.
> +		 * So ignore any errors to avoid spurious failures during
> +		 * path failover.
> +		 */
> +		if ((alua->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
> +			sdev_printk(KERN_INFO, sdev,
> +				    "%s: ignoring rtpg result %d\n",
> +				    DRV_NAME, retval);
> +			kfree(buff);
> +			return 0;//SCSI_DH_OK
> +		}
> +		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
> +			sdev_printk(KERN_INFO, sdev,
> +				    "%s: rtpg failed, result %d\n",
> +				    DRV_NAME, retval);
> +			kfree(buff);
> +			if (retval < 0)
> +				return -EBUSY;//SCSI_DH_DEV_TEMP_BUSY;
> +			if (host_byte(retval) == DID_NO_CONNECT)
> +				return -ENOENT;//SCSI_DH_RES_TEMP_UNAVAIL;
> +			return -EIO;//SCSI_DH_IO
> +		}
> +
> +		/*
> +		 * submit_rtpg() has failed on existing arrays
> +		 * when requesting extended header info, and
> +		 * the array doesn't support extended headers,
> +		 * even though it shouldn't according to T10.
> +		 * The retry without rtpg_ext_hdr_req set
> +		 * handles this.
> +		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
> +		 * with ASC 00h if they don't support the extended header.
> +		 */
> +		if (!alua->rtpg_ext_hdr_unsupp &&
> +		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
> +			alua->rtpg_ext_hdr_unsupp = true;
> +			goto retry;
> +		}
> +		/*
> +		 * If the array returns with 'ALUA state transition'
> +		 * sense code here it cannot return RTPG data during
> +		 * transition. So set the state to 'transitioning' directly.
> +		 */
> +		if (sense_hdr.sense_key == NOT_READY &&
> +		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
> +			transitioning_sense = true;
> +			goto skip_rtpg;
> +		}
> +		/*
> +		 * Retry on any other UNIT ATTENTION occurred.
> +		 */
> +		if (sense_hdr.sense_key == UNIT_ATTENTION)
> +			err = -EAGAIN;//SCSI_DH_RETRY
> +		if (err == -EAGAIN &&
> +		    alua->expiry != 0 && time_before(jiffies, alua->expiry)) {
> +			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
> +				    DRV_NAME);
> +			scsi_print_sense_hdr(sdev, DRV_NAME, &sense_hdr);
> +			kfree(buff);
> +			return err;
> +		}
> +		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
> +			    DRV_NAME);
> +		scsi_print_sense_hdr(sdev, DRV_NAME, &sense_hdr);
> +		kfree(buff);
> +		alua->expiry = 0;
> +		return -EIO;//SCSI_DH_IO
> +	}
> +
> +	len = get_unaligned_be32(&buff[0]) + 4;
> +
> +	if (len > bufflen) {
> +		/* Resubmit with the correct length */
> +		kfree(buff);
> +		bufflen = len;
> +		buff = kmalloc(bufflen, GFP_KERNEL);
> +		if (!buff) {
> +			sdev_printk(KERN_WARNING, sdev,
> +				    "%s: kmalloc buffer failed\n",__func__);
> +			/* Temporary failure, bypass */
> +			alua->expiry = 0;
> +			return -EBUSY;//SCSI_DH_DEV_TEMP_BUSY;
> +		}
> +		goto retry;
> +	}
> +
> +	orig_transition_tmo = alua->transition_tmo;
> +	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
> +		alua->transition_tmo = buff[5];
> +	else
> +		alua->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> +
> +	if (orig_transition_tmo != alua->transition_tmo) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: transition timeout set to %d seconds\n",
> +			    DRV_NAME, alua->transition_tmo);
> +		alua->expiry = jiffies + alua->transition_tmo * HZ;
> +	}
> +
> +	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> +		tpg_desc_tbl_off = 8;
> +	else
> +		tpg_desc_tbl_off = 4;
> +
> +	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
> +	     k < len;
> +	     k += off, desc += off) {
> +		u16 group_id_desc = get_unaligned_be16(&desc[2]);
> +
> +		spin_lock_irqsave(&alua->lock, flags);
> +		if (group_id_desc == group_id) {
> +			alua->group_id = group_id;
> +			WRITE_ONCE(alua->state, desc[0] & 0x0f);
> +			alua->pref = desc[0] >> 7;
> +			WRITE_ONCE(sdev->access_state, desc[0]);
> +			alua->valid_states = desc[1];
> +		}
> +		spin_unlock_irqrestore(&alua->lock, flags);
> +		off = 8 + (desc[7] * 4);
> +	}
> +
> + skip_rtpg:
> +	spin_lock_irqsave(&alua->lock, flags);
> +	if (transitioning_sense)
> +		alua->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +
> +	if (group_id_old != alua->group_id || state_old != alua->state ||
> +		pref_old != alua->pref || valid_states_old != alua->valid_states)
> +		sdev_printk(KERN_INFO, sdev,
> +			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
> +			DRV_NAME, alua->group_id, print_alua_state(alua->state),
> +			alua->pref ? "preferred" : "non-preferred",
> +			alua->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
> +			alua->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
> +			alua->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
> +			alua->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
> +			alua->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
> +			alua->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
> +			alua->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> +
> +	switch (alua->state) {
> +	case SCSI_ACCESS_STATE_TRANSITIONING:
> +		if (time_before(jiffies, alua->expiry)) {
> +			/* State transition, retry */
> +			alua->interval = ALUA_RTPG_RETRY_DELAY;
> +			err = -EAGAIN;//SCSI_DH_RETRY
> +		} else {
> +			unsigned char access_state;
> +
> +			/* Transitioning time exceeded, set port to standby */
> +			err = -EIO;//SCSI_DH_IO;
> +			alua->state = SCSI_ACCESS_STATE_STANDBY;
> +			alua->expiry = 0;
> +			access_state = alua->state & SCSI_ACCESS_STATE_MASK;
> +			if (alua->pref)
> +				access_state |= SCSI_ACCESS_STATE_PREFERRED;
> +			WRITE_ONCE(sdev->access_state, access_state);
> +		}
> +		break;
> +	case SCSI_ACCESS_STATE_OFFLINE:
> +		/* Path unusable */
> +		err = -ENODEV;//SCSI_DH_DEV_OFFLINED;
> +		alua->expiry = 0;
> +		break;
> +	default:
> +		/* Useable path if active */
> +		err = 0;//SCSI_DH_OK
> +		alua->expiry = 0;
> +		break;
> +	}
> +	spin_unlock_irqrestore(&alua->lock, flags);
> +	kfree(buff);
> +	return err;
> +}
> +
>   int scsi_alua_sdev_init(struct scsi_device *sdev)
>   {
>   	int rel_port, ret, tpgs;
> @@ -47,6 +357,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
>   
>   	sdev->alua->sdev = sdev;
>   	sdev->alua->tpgs = tpgs;
> +	spin_lock_init(&sdev->alua->lock);
>   
>   	return 0;
>   out_free_data:
> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
> index 07cdcb4f5b518..068277261ed9d 100644
> --- a/include/scsi/scsi_alua.h
> +++ b/include/scsi/scsi_alua.h
> @@ -16,7 +16,15 @@
>   struct alua_data {
>   	int			group_id;
>   	int			tpgs;
> +	int			state;
> +	int			pref;
> +	int			valid_states;
> +	bool			rtpg_ext_hdr_unsupp;
> +	unsigned char		transition_tmo;
> +	unsigned long		expiry;
> +	unsigned long		interval;
>   	struct scsi_device	*sdev;
> +	spinlock_t		lock;
>   };
>   
>   int scsi_alua_sdev_init(struct scsi_device *sdev);

Ah, right. Now I see where you want to go with the separate
structure. Still wonder why you need the 'sdev' back link in
there, though.

Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
