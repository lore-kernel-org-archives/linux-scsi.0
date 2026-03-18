Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAB0376BCE
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 08:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821298; cv=none; b=j9eHIabVwjHQM02HEanr74PcsApCLAPfIAzutiUi43qxfz/zsGhRLl+WRRM/toqEzMwZm/7wdXE/tHZTOVKYQnUElA1P7dhDhk1Lv1/UqLri8sEIGZOd0e/xmHNPEiBeMM1+DnZ9zU4pG+o2axrUSNy2EF0a2p/IdIDMTLLmgh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821298; c=relaxed/simple;
	bh=vnpW6rAUxPTR3NA2k+IH6kDJWMdnmo7o2NXLeDHGk4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qhqul2gN+GR1Qd4mp9uc/W6qI16Lptq8Pbpd8vehSRd5ydASps0V7FKllQFXv1kLAU/ZT3SVPwjARGZQrdL1xgER0WjPWeV5iKKQDD9w2nDZMlVBMQKxQf1GdmIhUnD6rcSBnRoQGTYgJ9uf/bwOh3x3A4BVSYBPRNYqNsPPwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hHBeVFu/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/BFhWeHH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GZ1Au4GB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=44qPSNRo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hHBeVFu/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/BFhWeHH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GZ1Au4GB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="44qPSNRo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3A2BD4D3DA;
	Wed, 18 Mar 2026 08:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773821295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOmaWv/8llyYOr2dSht0IEj/9kzdXlQIE8ocNamXjOI=;
	b=hHBeVFu/u38vMFfJArmbkdHBLvykbudd5UzTco4a/qL0lr5pjfPQCIJD3EThs95ZgMcS/d
	dPSn28iTFm1sgRX6GFJUqnUZ2XdG3FxB8/3mZsVC0XFe4x5tKQ5jlBFZOwWBY/dYlOHNGf
	6zmHGUuN72J/+/MRHkYj9fkuxmBXv6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773821295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOmaWv/8llyYOr2dSht0IEj/9kzdXlQIE8ocNamXjOI=;
	b=/BFhWeHHqElrdSpllgQ2IzJZYAKQ5x8b4GVEA+TCJiTRsJZMO9+sazNT4+nd9oL+vTkqVK
	FgzQzVUptpCKnZDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GZ1Au4GB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=44qPSNRo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773821294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOmaWv/8llyYOr2dSht0IEj/9kzdXlQIE8ocNamXjOI=;
	b=GZ1Au4GBEzr3W13BvwA1Uw33OkUOVGLf7UvMmEpCD2ZBQLBMkFZ7kj4T14U5f4iAT8XMth
	Vyu/6lrJBaynH29KmkXVYuM5Ohq9jRL+QFUZdTwIiEPWYx2a8QBdzJ5KXHv2mnJblohlHB
	GKKRDNWeFIVs+K9bomxnG2vjzTa/epU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773821294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOmaWv/8llyYOr2dSht0IEj/9kzdXlQIE8ocNamXjOI=;
	b=44qPSNRoM2koDdgwjLSxVqCymt42bc0b1NGUUvE54pfzmSU0mtios7SR86Nw35F0SozDAn
	FDH3STM4FgzgMABw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C94624273B;
	Wed, 18 Mar 2026 08:08:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3uMJL21dumm1WQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Mar 2026 08:08:13 +0000
Message-ID: <30806c0b-f416-4b8c-9771-f2e80198c9d5@suse.de>
Date: Wed, 18 Mar 2026 09:08:13 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/13] scsi: core: Add implicit ALUA support
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-14-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260317120703.3702387-14-john.g.garry@oracle.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 3A2BD4D3DA
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/17/26 13:07, John Garry wrote:
> For when no device handler is used, add ALUA support.
> 
> This will be equivalent to when native SCSI multipathing is used.
> 
> Essentially all the same handling is available as DH alua driver for
> rescan, request prep, sense handling.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_alua.c  | 93 +++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_error.c |  7 +++
>   drivers/scsi/scsi_lib.c   |  7 +++
>   drivers/scsi/scsi_scan.c  |  2 +
>   drivers/scsi/scsi_sysfs.c |  4 +-
>   include/scsi/scsi_alua.h  | 14 ++++++
>   6 files changed, 126 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
> index d3fcd887e5018..ee0229b1a9d12 100644
> --- a/drivers/scsi/scsi_alua.c
> +++ b/drivers/scsi/scsi_alua.c
> @@ -562,6 +562,90 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
>   }
>   EXPORT_SYMBOL_GPL(scsi_alua_stpg_run);
>   
> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> +					      struct scsi_sense_hdr *sense_hdr)
> +{
> +	switch (sense_hdr->sense_key) {
> +	case NOT_READY:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> +			/*
> +			 * LUN Not Accessible - ALUA state transition
> +			 */
> +			scsi_alua_handle_state_transition(sdev);
> +			return NEEDS_RETRY;
> +		}
> +		break;
> +	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> +			/*
> +			 * LUN Not Accessible - ALUA state transition
> +			 */
> +			scsi_alua_handle_state_transition(sdev);
> +			return NEEDS_RETRY;
> +		}
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
> +			/*
> +			 * Power On, Reset, or Bus Device Reset.
> +			 * Might have obscured a state transition,
> +			 * so schedule a recheck.
> +			 */
> +			scsi_device_alua_rescan(sdev);
> +			return ADD_TO_MLQUEUE;
> +		}
> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
> +			/*
> +			 * Device internal reset
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
> +			/*
> +			 * Mode Parameters Changed
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
> +			/*
> +			 * ALUA state changed
> +			 */
> +			scsi_device_alua_rescan(sdev);
> +			return ADD_TO_MLQUEUE;
> +		}
> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
> +			/*
> +			 * Implicit ALUA state transition failed
> +			 */
> +			scsi_device_alua_rescan(sdev);
> +			return ADD_TO_MLQUEUE;
> +		}
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
> +			/*
> +			 * Inquiry data has changed
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
> +			/*
> +			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
> +			 * when switching controllers on targets like
> +			 * Intel Multi-Flex. We can just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		break;
> +	}
> +
> +	return SCSI_RETURN_NOT_HANDLED;
> +}
> +
> +static void alua_rtpg_work(struct work_struct *work)
> +{
> +	struct alua_data *alua =
> +		container_of(work, struct alua_data, work.work);
> +	int ret;
> +
> +	ret = scsi_alua_rtpg_run(alua->sdev);
> +
> +	if (ret == -EAGAIN)
> +		queue_delayed_work(kalua_wq, &alua->work, alua->interval * HZ);
> +}
> +
>   int scsi_alua_sdev_init(struct scsi_device *sdev)
>   {
>   	int rel_port, ret, tpgs;
> @@ -591,6 +675,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
>   		goto out_free_data;
>   	}
>   
> +	INIT_DELAYED_WORK(&sdev->alua->work, alua_rtpg_work);
>   	sdev->alua->sdev = sdev;
>   	sdev->alua->tpgs = tpgs;
>   	spin_lock_init(&sdev->alua->lock);
> @@ -638,6 +723,14 @@ bool scsi_device_alua_implicit(struct scsi_device *sdev)
>   	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
>   }
>   
> +void scsi_device_alua_rescan(struct scsi_device *sdev)
> +{
> +	struct alua_data *alua = sdev->alua;
> +
> +	queue_delayed_work(kalua_wq, &alua->work,
> +				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
> +}
> +
>   int scsi_alua_init(void)
>   {
>   	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9c..a542e7a85a24d 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -29,6 +29,7 @@
>   #include <linux/jiffies.h>
>   
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_alua.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
>   #include <scsi/scsi_device.h>
> @@ -578,6 +579,12 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>   		if (rc != SCSI_RETURN_NOT_HANDLED)
>   			return rc;
>   		/* handler does not care. Drop down to default handling */
> +	} else if (scsi_device_alua_implicit(sdev)) {
> +		enum scsi_disposition rc;
> +
> +		rc = scsi_alua_check_sense(sdev, &sshdr);
> +		if (rc != SCSI_RETURN_NOT_HANDLED)
> +			return rc;
>   	}
>   
>   	if (scmd->cmnd[0] == TEST_UNIT_READY &&
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d3a8cd4166f92..e5bcee555ea10 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -26,6 +26,7 @@
>   #include <linux/unaligned.h>
>   
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_alua.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
>   #include <scsi/scsi_device.h>
> @@ -1719,6 +1720,12 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	if (sdev->handler && sdev->handler->prep_fn) {
>   		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
>   
> +		if (ret != BLK_STS_OK)
> +			return ret;
> +	} else if (scsi_device_alua_implicit(sdev)) {
> +		/* We should be able to make this common for ALUA DH as well */
> +		blk_status_t ret = scsi_alua_prep_fn(sdev, req);
> +
>   		if (ret != BLK_STS_OK)
>   			return ret;
>   	}
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3af64d1231445..73caf83bd1097 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1744,6 +1744,8 @@ int scsi_rescan_device(struct scsi_device *sdev)
>   
>   	if (sdev->handler && sdev->handler->rescan)
>   		sdev->handler->rescan(sdev);
> +	else if (scsi_device_alua_implicit(sdev))
> +		scsi_device_alua_rescan(sdev);
>   
>   	if (dev->driver && try_module_get(dev->driver->owner)) {
>   		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 6c4c3c22f6acf..71a9613898cfc 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1152,7 +1152,7 @@ sdev_show_access_state(struct device *dev,
>   	unsigned char access_state;
>   	const char *access_state_name;
>   
> -	if (!sdev->handler)
> +	if (!sdev->handler && !scsi_device_alua_implicit(sdev))
>   		return -EINVAL;
>   
>   	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
> @@ -1409,6 +1409,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   	scsi_autopm_get_device(sdev);
>   
>   	scsi_dh_add_device(sdev);
> +	if (!sdev->handler && scsi_device_alua_implicit(sdev))
> +		scsi_device_alua_rescan(sdev);
>   
>   	error = device_add(&sdev->sdev_gendev);
>   	if (error) {
> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
> index 2d5db944f75b7..8e506d1d66cce 100644
> --- a/include/scsi/scsi_alua.h
> +++ b/include/scsi/scsi_alua.h
> @@ -24,6 +24,7 @@ struct alua_data {
>   	unsigned char		transition_tmo;
>   	unsigned long		expiry;
>   	unsigned long		interval;
> +	struct delayed_work	work;
>   	struct scsi_device	*sdev;
>   	spinlock_t		lock;
>   };
> @@ -35,11 +36,15 @@ void scsi_alua_handle_state_transition(struct scsi_device *sdev);
>   
>   int scsi_alua_check_tpgs(struct scsi_device *sdev);
>   
> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> +				struct scsi_sense_hdr *sense_hdr);
> +
>   int scsi_alua_rtpg_run(struct scsi_device *sdev);
>   int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
>   
>   blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
>   
> +void scsi_device_alua_rescan(struct scsi_device *sdev);
>   bool scsi_device_alua_implicit(struct scsi_device *sdev);
>   
>   int scsi_alua_init(void);
> @@ -53,6 +58,12 @@ static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
>   {
>   	return 0;
>   }
> +static inline
> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
> +				struct scsi_sense_hdr *sense_hdr)
> +{
> +	return SCSI_RETURN_NOT_HANDLED;
> +}
>   static inline int scsi_alua_rtpg_run(struct scsi_device *sdev)
>   {
>   	return 0;
> @@ -66,6 +77,9 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
>   {
>   	return BLK_STS_OK;
>   }
> +static inline void scsi_device_alua_rescan(struct scsi_device *sdev)
> +{
> +}
>   static inline bool scsi_device_alua_implicit(struct scsi_device *sdev)
>   {
>   	return false;

... and this justifies what I mentioned with the previous two patches. 
Please fold the patch for scsi_device_alua_implicit() into this, and 
open-code the prep_fn such that we know what's going on.

The ALUA state machine might be challenging, though.
The scsi_dh_alua driver had this as a workqueue, as it was the only way
how we could execute several calls consecutively.
I'm not utterly convinced that we need have the very same functionality
in the scsi core, but for simplicity let's keep it.
But: we only should keep the 'retry RTPG' logic in the scsi core;
sending STPG should be delegated to scsi_dh_alua.
So you need to adjust scsi_dh_alua for that, too, and cannot just
lift the existing functions into the scsi core.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
