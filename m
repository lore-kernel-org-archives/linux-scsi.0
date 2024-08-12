Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0D5193063
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 20:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723494170; cv=none; b=dBGEVKo6u4v7KbY9RaYw4NBhetr8/jcyZX16+RPchOW5pQAFC1vo51cJ4S7k0CkKyDEhBUWKJEwL0Se0P/6oaIm1yPkvf0zUSX2dGoaU+bgCtjT9ci9ZPWYJen6RwCRJJWB6KK3WGIYKnwp2mGb5HuaDHXxK7epJwmTGGOrFV4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723494170; c=relaxed/simple;
	bh=fP8NH7ivEuUGPRcg7NBfMmNywDi5Vn6hcO6X4yBaTWM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N5D4EamUth4x64GF/KqtWMcZ0XjfByZBVMheRgBtfuuLOVLXiv6Zeh2nPAVt5Mz4j8LA1FBj2ADWfLMhvjtPo33mNb3bvqxbvD6S+1CDfDYLbAWIil0DMQiJx2Hx0Du2oVi2zIi5k80RXTwIrPe0NKHDq5k3/X/s/X61zwTuDyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CJy4JU+i; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CJy4JU+i; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CJy4JU+i";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CJy4JU+i"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50B4622606;
	Mon, 12 Aug 2024 20:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723494166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ophy/5q9P3Ro5fYL+EsQnzcBS6f8tGW8+ImUYYbUjoI=;
	b=CJy4JU+ibZNnZWavQTd8ant7cJyjW8+UBf6dV9UrzgVOSEmRFE8WqISG90vrJg+V7tLt0d
	UOAPot+ptb7oILqFSl5m/XisTH8Oi2AtlP0TKyq+JGJOqP76duDWKDzLO+egLBqrzaiDjQ
	6w0jOsYXcaJPIVqqI+1F18UX193wMAw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723494166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ophy/5q9P3Ro5fYL+EsQnzcBS6f8tGW8+ImUYYbUjoI=;
	b=CJy4JU+ibZNnZWavQTd8ant7cJyjW8+UBf6dV9UrzgVOSEmRFE8WqISG90vrJg+V7tLt0d
	UOAPot+ptb7oILqFSl5m/XisTH8Oi2AtlP0TKyq+JGJOqP76duDWKDzLO+egLBqrzaiDjQ
	6w0jOsYXcaJPIVqqI+1F18UX193wMAw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14E2113983;
	Mon, 12 Aug 2024 20:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g+R5AxZvumbQdwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 12 Aug 2024 20:22:46 +0000
Message-ID: <646b3701a9a3d8131eb7f0bf16c0fa6b1a0d49b4.camel@suse.com>
Subject: Re: [PATCH] ibmvfc: Add max_sectors module parameter
From: Martin Wilck <mwilck@suse.com>
To: Brian King <brking@linux.ibm.com>, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, 
	tyreld@linux.ibm.com, brking@pobox.com
Date: Mon, 12 Aug 2024 22:22:45 +0200
In-Reply-To: <20240730175118.27105-1-brking@linux.ibm.com>
References: <20240730175118.27105-1-brking@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2024-07-30 at 12:51 -0500, Brian King wrote:
> There are some scenarios that can occur, such as performing an
> upgrade of the virtual I/O server, where the supported max transfer
> of the backing device for an ibmvfc HBA can change. If the max
> transfer of the backing device decreases, this can cause issues with
> previously discovered LUNs. This patch accomplishes two things.
> First, it changes the default ibmvfc max transfer value to 1MB.
> This is generally supported by all backing devices, which should
> mitigate this issue out of the box. Secondly, it adds a module
> parameter, enabling a user to increase the max transfer value to
> values that are larger than 1MB, as long as they have configured
> these larger values on the virtual I/O server as well.
>=20
> Signed-off-by: Brian King <brking@linux.ibm.com>
> ---
> =C2=A0drivers/scsi/ibmvscsi/ibmvfc.c | 10 +++++++---
> =C2=A0drivers/scsi/ibmvscsi/ibmvfc.h |=C2=A0 2 +-
> =C2=A02 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c
> b/drivers/scsi/ibmvscsi/ibmvfc.c
> index a3d1013c8307..611901562e06 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -37,6 +37,7 @@ static unsigned int default_timeout =3D
> IBMVFC_DEFAULT_TIMEOUT;
> =C2=A0static u64 max_lun =3D IBMVFC_MAX_LUN;
> =C2=A0static unsigned int max_targets =3D IBMVFC_MAX_TARGETS;
> =C2=A0static unsigned int max_requests =3D IBMVFC_MAX_REQUESTS_DEFAULT;
> +static unsigned int max_sectors =3D IBMVFC_MAX_SECTORS;
> =C2=A0static u16 scsi_qdepth =3D IBMVFC_SCSI_QDEPTH;
> =C2=A0static unsigned int disc_threads =3D IBMVFC_MAX_DISC_THREADS;
> =C2=A0static unsigned int ibmvfc_debug =3D IBMVFC_DEBUG;
> @@ -83,6 +84,9 @@ MODULE_PARM_DESC(default_timeout,
> =C2=A0module_param_named(max_requests, max_requests, uint, S_IRUGO);
> =C2=A0MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. =
"
> =C2=A0		 "[Default=3D"
> __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
> +module_param_named(max_sectors, max_sectors, uint, S_IRUGO);
> +MODULE_PARM_DESC(max_sectors, "Maximum sectors for this adapter. "
> +		 "[Default=3D" __stringify(IBMVFC_MAX_SECTORS) "]");
> =C2=A0module_param_named(scsi_qdepth, scsi_qdepth, ushort, S_IRUGO);
> =C2=A0MODULE_PARM_DESC(scsi_qdepth, "Maximum scsi command depth per
> adapter queue. "
> =C2=A0		 "[Default=3D" __stringify(IBMVFC_SCSI_QDEPTH) "]");
> @@ -1494,7 +1498,7 @@ static void ibmvfc_set_login_info(struct
> ibmvfc_host *vhost)
> =C2=A0	memset(login_info, 0, sizeof(*login_info));
> =C2=A0
> =C2=A0	login_info->ostype =3D cpu_to_be32(IBMVFC_OS_LINUX);
> -	login_info->max_dma_len =3D cpu_to_be64(IBMVFC_MAX_SECTORS <<
> 9);
> +	login_info->max_dma_len =3D cpu_to_be64(max_sectors << 9);
> =C2=A0	login_info->max_payload =3D cpu_to_be32(sizeof(struct
> ibmvfc_fcp_cmd_iu));
> =C2=A0	login_info->max_response =3D cpu_to_be32(sizeof(struct
> ibmvfc_fcp_rsp));
> =C2=A0	login_info->partition_num =3D cpu_to_be32(vhost-
> >partition_number);
> @@ -5230,7 +5234,7 @@ static void ibmvfc_npiv_login_done(struct
> ibmvfc_event *evt)
> =C2=A0	}
> =C2=A0
> =C2=A0	vhost->logged_in =3D 1;
> -	npiv_max_sectors =3D min((uint)(be64_to_cpu(rsp->max_dma_len)
> >> 9), IBMVFC_MAX_SECTORS);
> +	npiv_max_sectors =3D min((uint)(be64_to_cpu(rsp->max_dma_len)
> >> 9), max_sectors);
> =C2=A0	dev_info(vhost->dev, "Host partition: %s, device: %s %s %s
> max sectors %u\n",
> =C2=A0		 rsp->partition_name, rsp->device_name, rsp-
> >port_loc_code,
> =C2=A0		 rsp->drc_name, npiv_max_sectors);
> @@ -6329,7 +6333,7 @@ static int ibmvfc_probe(struct vio_dev *vdev,
> const struct vio_device_id *id)
> =C2=A0	shost->can_queue =3D scsi_qdepth;
> =C2=A0	shost->max_lun =3D max_lun;
> =C2=A0	shost->max_id =3D max_targets;
> -	shost->max_sectors =3D IBMVFC_MAX_SECTORS;
> +	shost->max_sectors =3D max_sectors;

Would it make sense to check whether the user-provided max_sectors
value is within some reasonable limits?

Thanks
Martin

