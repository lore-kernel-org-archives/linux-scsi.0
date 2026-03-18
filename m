Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1BF36C0CC
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 07:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820402; cv=none; b=omE9JlJlYHmUPszcYBF6SfUQEtBhyXT8bBWI+yYVYi9NpwP+gor8yi/ldjPq8f6QyAcFr3pJ94B6HpBcetB8MQRp65is4Bv0Keydq9++ceAcJHJ22Ufde5v/B0vLw3KBZ7WXaJAm2eMXub9VlFS2Ret5Np0ITch2TuokDbe7m1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820402; c=relaxed/simple;
	bh=S3/hufd/7nIuNoMwgaeHKmXDO4xJ3yFn2Dn6+q0hFzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nERt5l0nSp0525VU6JLktJDb4MQe4fJTMB5ytbyL54QEQTzNUaWOjrC8duUOslla7TMCelkwRSxXc1qfron+qnKzi9JZiesYEB+rpRwgsMUefskQgycxLAA9EerK/gk4vUY+2C2mifey9M/kSJUbQtbsL63C9jJfJDAp9Qfvmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VHHsl2Gk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nAj/YBMl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tQzPVHsb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AKato7cG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VHHsl2Gk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nAj/YBMl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tQzPVHsb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AKato7cG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DDAF95BDBC;
	Wed, 18 Mar 2026 07:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTZymDhJaaIhntNHRTs46I9z3Lo9rL8bI27j67E8UFU=;
	b=VHHsl2Gk2GvAYi7b4jEFzG8qZsLd3s2kkPFpdwIz7s5I7ohX5TjhKKx98CPsHemrM2P78x
	fc3fbjq7nz8D7LwDj9AI9DBVBwGG1q89Ys7xnx+1/0V5pbBwua4IsRVNuWwKjl3yguxfen
	0j/gHEEVyFUJnhpD6BB236eMm+cS0sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820399;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTZymDhJaaIhntNHRTs46I9z3Lo9rL8bI27j67E8UFU=;
	b=nAj/YBMlXhBuNUiMXFvOgvu/LVR7uLVf25xewDL3TfQWHGICNPscnbA2372jdIeluiIK5W
	aASrawKG8/Q4hiAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tQzPVHsb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AKato7cG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773820398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTZymDhJaaIhntNHRTs46I9z3Lo9rL8bI27j67E8UFU=;
	b=tQzPVHsbAWv8tZBwsjw2DBMGPdV/GuGVRaLE6S5xnJ3D/+VUSv9OU+QDwFPT2juXa3YIR4
	qNBI00bDpWTpBtl2d5EHQl1MOY2TjehPdmrZCVEfy29FhZllW7BWsf6B3LtUdHaK8Qms1p
	xHqW3sCvMSDuQbdBhwfqlrxnUbn0n6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773820398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTZymDhJaaIhntNHRTs46I9z3Lo9rL8bI27j67E8UFU=;
	b=AKato7cGqHKwTMBYd+8cB5yN2i1GAfdjLY9v7IKmOMOJ6YyCpgEACYZwfme1pTVzbTbq6i
	OcneNydzvBKkSnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 872414273C;
	Wed, 18 Mar 2026 07:53:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uQsiH+5Zumm3SQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 07:53:18 +0000
Message-ID: <f1fd6cfa-98aa-469a-9c70-06d8e64d5468@suse.de>
Date: Wed, 18 Mar 2026 08:53:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] scsi: alua: Add scsi_alua_stpg()
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,oracle.com:email,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: DDAF95BDBC
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/17/26 13:06, John Garry wrote:
> Add a core equivalent of alua_stpg() from scsi_dh_alua.c
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_alua.c | 99 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 99 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index 50c1d17b52dc7..1045885f74169 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -30,6 +30,9 @@ static struct workqueue_struct *kalua_wq;
>   
>   #define RTPG_FMT_MASK			0x70
>   #define RTPG_FMT_EXT_HDR		0x10
> +#define TPGS_MODE_NONE			0x0
> +#define TPGS_MODE_IMPLICIT		0x1
> +#define TPGS_MODE_EXPLICIT		0x2
>   
>   #define ALUA_RTPG_SIZE			128
>   #define ALUA_FAILOVER_TIMEOUT		60
> @@ -65,6 +68,41 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
>   				ALUA_FAILOVER_RETRIES, &exec_args);
>   }
>   
> +/*
> + * submit_stpg - Issue a SET TARGET PORT GROUP command
> + *
> + * Currently we're only setting the current target port group state
> + * to 'active/optimized' and let the array firmware figure out
> + * the states of the remaining groups.
> + */
> +static int submit_stpg(struct scsi_device *sdev,
> +				struct scsi_sense_hdr *sshdr)
> +{
> +	u8 cdb[MAX_COMMAND_SIZE];
> +	unsigned char stpg_data[8];
> +	int stpg_len = 8;
> +	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
> +				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
> +	const struct scsi_exec_args exec_args = {
> +		.sshdr = sshdr,
> +	};
> +
> +	/* Prepare the data buffer */
> +	memset(stpg_data, 0, stpg_len);
> +	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL;
> +	put_unaligned_be16(sdev->alua->group_id, &stpg_data[6]);
> +
> +	/* Prepare the command. */
> +	memset(cdb, 0x0, MAX_COMMAND_SIZE);
> +	cdb[0] = MAINTENANCE_OUT;
> +	cdb[1] = MO_SET_TARGET_PGS;
> +	put_unaligned_be32(stpg_len, &cdb[6]);
> +
> +	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
> +				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
> +				ALUA_FAILOVER_RETRIES, &exec_args);
> +}
> +
>   static char print_alua_state(unsigned char state)
>   {
>   	switch (state) {
> @@ -326,6 +364,67 @@ static int scsi_alua_rtpg(struct scsi_device *sdev)
>   	return err;
>   }
>   
> +
> +/*
> + * scsi_alua_stpg - Issue a SET TARGET PORT GROUP command
> + *
> + * Issue a SET TARGET PORT GROUP command and evaluate the
> + * response. Returns SCSI_DH_RETRY per default to trigger
> + * a re-evaluation of the target group state or SCSI_DH_OK
> + * if no further action needs to be taken.
> + */
> +__maybe_unused
> +static int scsi_alua_stpg(struct scsi_device *sdev, bool optimize)
> +{
> +	struct alua_data *alua = sdev->alua;
> +	int retval;
> +	struct scsi_sense_hdr sense_hdr;
> +
> +	if (!(alua->tpgs & TPGS_MODE_EXPLICIT)) {
> +		/* Only implicit ALUA supported, retry */
> +		return -EAGAIN;//SCSI_DH_RETRY;
> +	}
> +	switch (alua->state) {
> +	case SCSI_ACCESS_STATE_OPTIMAL:
> +		return 0;//SCSI_DH_OK;
> +	case SCSI_ACCESS_STATE_ACTIVE:
> +		if (optimize &&
> +		    !alua->pref &&
> +		    (alua->tpgs & TPGS_MODE_IMPLICIT))
> +			return 0;//SCSI_DH_OK;
> +		break;
> +	case SCSI_ACCESS_STATE_STANDBY:
> +	case SCSI_ACCESS_STATE_UNAVAILABLE:
> +		break;
> +	case SCSI_ACCESS_STATE_OFFLINE:
> +		return -EIO;//SCSI_DH_IO;
> +	case SCSI_ACCESS_STATE_TRANSITIONING:
> +		break;
> +	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: stpg failed, unhandled TPGS state %d",
> +			    DRV_NAME, alua->state);
> +		return -ENOSYS ;//SCSI_DH_NOSYS;
> +	}
> +	retval = submit_stpg(sdev, &sense_hdr);
> +
> +	if (retval) {
> +		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
> +			sdev_printk(KERN_INFO, sdev,
> +				    "%s: stpg failed, result %d",
> +				    DRV_NAME, retval);
> +			if (retval < 0)
> +				return -EBUSY;//SCSI_DH_DEV_TEMP_BUSY;
> +		} else {
> +			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
> +				    DRV_NAME);
> +			scsi_print_sense_hdr(sdev, DRV_NAME, &sense_hdr);
> +		}
> +	}
> +	/* Retry RTPG */
> +	return -EAGAIN;//SCSI_DH_RETRY;
> +}
> +
>   int scsi_alua_sdev_init(struct scsi_device *sdev)
>   {
>   	int rel_port, ret, tpgs;

Hmm. The return code from alus_stpg() was really an internal thing in 
scsi_dh_alua to drive the state machine.
I'd rather have _this_ function to use normal syntax (ie return '0' on 
success), and modify the state machine in scsi_dh_alua accordingly.

Note: stpg handling should be done _only_ in scsi_dh_alua. The scsi
core should not attempt anything clever here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
