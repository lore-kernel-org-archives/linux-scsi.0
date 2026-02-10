Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBECF318BAF
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 11:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770723536; cv=none; b=MlyJA5vo0vMTJlzyepZVwPoqzghFLip6CC+EuMzPg9aWLniBhd+g6abOgl+wd5TU5FAO6y9jd2lOitt4iz5fSEAJ75LLa1TjJ2SsF5jb/LJ3YEy5/LigssSNEap0TC6SiJFRmUH3YvHhKU+UHx2vo+wwi0Yip+zDLusBa8S+TIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770723536; c=relaxed/simple;
	bh=6KTsZPd0UOlLAV4vZYdChN6X5Byzl04qZhkmv8GTN5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qoQ8HQSgsK0imMGx/s/X81JxfVpQzc6UQTlPV0CudrX6upKBJwCQp2Is1Ftkmg5fP3MbUH4qjZwFtd2TIeo3NkDFF9EOK2vr+9VNFBO5hRcRf+/PPbBLuAaktiG+yjYT/b7xIW2jKnQIT1/VFnY+0UvcIpLfJBrCfMWhBTZNLko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qXL7yV0o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kxklfidX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qXL7yV0o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kxklfidX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qXL7yV0o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kxklfidX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qXL7yV0o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kxklfidX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F0F625BD48;
	Tue, 10 Feb 2026 11:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770723532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ba+Z+auOjbBL7vmzwIEumPcfcId69LobWzXMzvh08h8=;
	b=qXL7yV0oSg0j1InEuHozjeXWmAUtTJJJRKyQJrkBi+wKWzIVNkLvDWOQR0Q8svOXzixDFg
	8vGYDs1QAOqDSHIa24EABd1bJ0UMqDYcG+gK6+hV99qbxBPfLDI3ileO0GR5ebdbJxc01o
	FGOC/Y9gLRPwTHyXLzC0Msqbc7uv49U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770723532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ba+Z+auOjbBL7vmzwIEumPcfcId69LobWzXMzvh08h8=;
	b=kxklfidXj8pjxGHCiIWgYrBwh5t4mXwr08JxvQcRgEyVKA9oy13BlPzSjriSh2rpEWmZxg
	1x4xbmRgBP/aVjBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qXL7yV0o;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kxklfidX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770723532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ba+Z+auOjbBL7vmzwIEumPcfcId69LobWzXMzvh08h8=;
	b=qXL7yV0oSg0j1InEuHozjeXWmAUtTJJJRKyQJrkBi+wKWzIVNkLvDWOQR0Q8svOXzixDFg
	8vGYDs1QAOqDSHIa24EABd1bJ0UMqDYcG+gK6+hV99qbxBPfLDI3ileO0GR5ebdbJxc01o
	FGOC/Y9gLRPwTHyXLzC0Msqbc7uv49U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770723532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ba+Z+auOjbBL7vmzwIEumPcfcId69LobWzXMzvh08h8=;
	b=kxklfidXj8pjxGHCiIWgYrBwh5t4mXwr08JxvQcRgEyVKA9oy13BlPzSjriSh2rpEWmZxg
	1x4xbmRgBP/aVjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDFA23EA62;
	Tue, 10 Feb 2026 11:38:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oSePLcsYi2n7VAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 10 Feb 2026 11:38:51 +0000
Message-ID: <d61a1830-d9d0-4697-b547-80106ce57023@suse.de>
Date: Tue, 10 Feb 2026 12:38:51 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
To: Igor Pylypiv <ipylypiv@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260209212151.342151-1-ipylypiv@google.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260209212151.342151-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F0F625BD48
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 2/9/26 22:21, Igor Pylypiv wrote:
> Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
> exposes the Unit Serial Number, which is derived from the Device
> Identification Vital Product Data (VPD) page 0x80.
> 
> Whitespace is stripped from the retrieved serial number to handle
> the different alignment (right-aligned for SCSI, potentially
> left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
> the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
> its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
> of the PRODUCT SERIAL NUMBER field for the translation is not assured."
> 
> This attribute is used by tools such as lsblk to display the serial
> number of block devices.
> 
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
> 
> v2->v3 changes:
> - Replaced sysfs_emit(buf, "%s\n", buf) with a manual newline placement
>    to avoid undefined behavior of passing the output buffer as an input.
> 
> v1->v2 changes:
> - Reordered declarations in scsi_vpd_lun_serial() from longest to shortest.
> - Replaced rcu_read_lock()/rcu_read_unlock() with guard(rcu)().
> 
> 
>   drivers/scsi/scsi_lib.c    | 47 ++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_sysfs.c  | 16 +++++++++++++
>   include/scsi/scsi_device.h |  1 +
>   3 files changed, 64 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4a902c9dfd8b..c17fbe4dd845 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -13,6 +13,7 @@
>   #include <linux/bitops.h>
>   #include <linux/blkdev.h>
>   #include <linux/completion.h>
> +#include <linux/ctype.h>
>   #include <linux/kernel.h>
>   #include <linux/export.h>
>   #include <linux/init.h>
> @@ -3459,6 +3460,52 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
>   }
>   EXPORT_SYMBOL(scsi_vpd_lun_id);
>   
> +/**
> + * scsi_vpd_lun_serial - return a unique device serial number
> + * @sdev: SCSI device
> + * @sn:   buffer for the serial number
> + * @sn_size: size of the buffer
> + *
> + * Copies the device serial number into @sn based on the information in
> + * the VPD page 0x80 of the device. The string will be null terminated
> + * and have leading and trailing whitespace stripped.
> + *
> + * Returns the length of the serial number or error on failure.
> + */
> +int scsi_vpd_lun_serial(struct scsi_device *sdev, char *sn, size_t sn_size)
> +{
> +	const struct scsi_vpd *vpd_pg80;
> +	const unsigned char *d;
> +	int len;
> +
> +	guard(rcu)();
> +	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
> +	if (!vpd_pg80)
> +		return -ENXIO;
> +
> +	len = vpd_pg80->len - 4;
> +	d = vpd_pg80->data + 4;
> +
> +	/* Skip leading spaces */
> +	while (len > 0 && isspace(*d)) {
> +		len--;
> +		d++;
> +	}
> +
> +	/* Skip trailing spaces */
> +	while (len > 0 && isspace(d[len - 1]))
> +		len--;
> +

Please use 'strim()' instead.

> +	if (sn_size < len + 1)
> +		return -EINVAL;
> +
> +	memcpy(sn, d, len);

'len' might well be '0' after 'strim()', please check
before calling 'memcpy'.

> +	sn[len] = '\0';
> +
> +	return len;
> +}
> +EXPORT_SYMBOL(scsi_vpd_lun_serial);
> +
>   /**
>    * scsi_vpd_tpg_id - return a target port group identifier
>    * @sdev: SCSI device
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 99eb0a30df61..9c4f47e7a298 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1013,6 +1013,21 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
>   }
>   static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
>   
> +static ssize_t
> +sdev_show_serial(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	ssize_t ret;
> +
> +	ret = scsi_vpd_lun_serial(sdev, buf, PAGE_SIZE);
> +	if (ret < 0)
> +		return ret;
> +
> +	buf[ret] = '\n';
> +	return ret + 1;
> +}
> +static DEVICE_ATTR(serial, S_IRUGO, sdev_show_serial, NULL);
> +
>   #define BLIST_FLAG_NAME(name)					\
>   	[const_ilog2((__force __u64)BLIST_##name)] = #name
>   static const char *const sdev_bflags_name[] = {
> @@ -1257,6 +1272,7 @@ static struct attribute *scsi_sdev_attrs[] = {
>   	&dev_attr_device_busy.attr,
>   	&dev_attr_vendor.attr,
>   	&dev_attr_model.attr,
> +	&dev_attr_serial.attr,
>   	&dev_attr_rev.attr,
>   	&dev_attr_rescan.attr,
>   	&dev_attr_delete.attr,
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index d32f5841f4f8..9c2a7bbe5891 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -571,6 +571,7 @@ void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
>   extern void sdev_disable_disk_events(struct scsi_device *sdev);
>   extern void sdev_enable_disk_events(struct scsi_device *sdev);
>   extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
> +extern int scsi_vpd_lun_serial(struct scsi_device *, char *, size_t);
>   extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
>   
>   #ifdef CONFIG_PM

Otherwise looks okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
