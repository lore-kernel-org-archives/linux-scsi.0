Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EEB186E58
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725270767; cv=none; b=Lc7NYx5iX1o/XrMolXD5laVOfzTyjPvUNyJiBgQjlYJcHupf0aw53wr/4k8pBcaSrErMWrZwx5mE1PsWvady7Hs6gBViSaPVylPsi5AXdaB1Pkw7J28B2fHR1v61osflSFZmR9HhwKJgTOGE2Ik0ut1qtcwWKWlLpPLnD/hWYg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725270767; c=relaxed/simple;
	bh=DGe3DNZ2PvKbpzqRHvrEkwp8p3Wz56eNFAxVTjZGLb0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AzudpAgrzrZYMnmyceCIUQcZ5EewjR/apBXPxCt+O9dz+QVtlpWrRZob1UtwuOBXGpZvOKpJp2tAJ1nwVup7PIOlRxh6EbZwN9QoihOyLfmVHcEdKKzmtIF9tIlhESPUOIlnUve9FvYij4wnhN9P4d/bRdSCJWR0VLgqokxYNWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Majm3Gv/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Majm3Gv/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Majm3Gv/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Majm3Gv/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C864E218FD;
	Mon,  2 Sep 2024 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1725270763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G9wqRwQjsuor/nOpNwZW2tZK6WUwiuSntU7Aa5WBmBo=;
	b=Majm3Gv/rpnlkn2TVSrTecg3M6R/ddJnukF5nvmyjCCbL3CWR37bY37e4sgMwh8h3o0TTg
	pyZ7m+ha+C6sRPgj7g59XLW7frM8WKcN8VbKAhLNfHh0Ol+AqIfXCS7PyNXUbwmnRGi30h
	cI8KN1BCfisbOmqRkYkO7TsASTL4Nk8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1725270763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G9wqRwQjsuor/nOpNwZW2tZK6WUwiuSntU7Aa5WBmBo=;
	b=Majm3Gv/rpnlkn2TVSrTecg3M6R/ddJnukF5nvmyjCCbL3CWR37bY37e4sgMwh8h3o0TTg
	pyZ7m+ha+C6sRPgj7g59XLW7frM8WKcN8VbKAhLNfHh0Ol+AqIfXCS7PyNXUbwmnRGi30h
	cI8KN1BCfisbOmqRkYkO7TsASTL4Nk8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90BDB13A7C;
	Mon,  2 Sep 2024 09:52:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6mbMIeuK1WamWwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 02 Sep 2024 09:52:43 +0000
Message-ID: <6594529f81c043f25b74198958718c84be27be4a.camel@suse.com>
Subject: Re: [PATCH v2] ibmvfc: Add max_sectors module parameter
From: Martin Wilck <mwilck@suse.com>
To: Brian King <brking@linux.ibm.com>, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, 
	tyreld@linux.ibm.com, brking@pobox.com
Date: Mon, 02 Sep 2024 11:52:43 +0200
In-Reply-To: <20240830204233.119305-2-brking@linux.ibm.com>
References: <cd5c3b50-e928-4e2c-b4c4-d5fb03ae514d@linux.vnet.ibm.com>
	 <20240830204233.119305-2-brking@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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

On Fri, 2024-08-30 at 15:42 -0500, Brian King wrote:
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
> =C2=A0drivers/scsi/ibmvscsi/ibmvfc.c | 17 ++++++++++++++---
> =C2=A0drivers/scsi/ibmvscsi/ibmvfc.h |=C2=A0 2 +-
> =C2=A02 files changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c
> b/drivers/scsi/ibmvscsi/ibmvfc.c
> index a3d1013c8307..3349d321aa07 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -37,6 +37,7 @@ static unsigned int default_timeout =3D
> IBMVFC_DEFAULT_TIMEOUT;
> =C2=A0static u64 max_lun =3D IBMVFC_MAX_LUN;
> =C2=A0static unsigned int max_targets =3D IBMVFC_MAX_TARGETS;
> =C2=A0static unsigned int max_requests =3D IBMVFC_MAX_REQUESTS_DEFAULT;
> +static u16 max_sectors =3D IBMVFC_MAX_SECTORS;

Am I understanding correctly that the maximum supported value for
max_sectors is USHRT_MAX, and you're ensuring that indirectly by using
an u16 type?

If yes, I think this would justify a comment in the code.

Regards,
Martin

> =C2=A0static u16 scsi_qdepth =3D IBMVFC_SCSI_QDEPTH;
> =C2=A0static unsigned int disc_threads =3D IBMVFC_MAX_DISC_THREADS;
> =C2=A0static unsigned int ibmvfc_debug =3D IBMVFC_DEBUG;
> @@ -83,6 +84,9 @@ MODULE_PARM_DESC(default_timeout,
> =C2=A0module_param_named(max_requests, max_requests, uint, S_IRUGO);
> =C2=A0MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter. =
"
> =C2=A0		 "[Default=3D"
> __stringify(IBMVFC_MAX_REQUESTS_DEFAULT) "]");
> +module_param_named(max_sectors, max_sectors, ushort, S_IRUGO);
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
> =C2=A0	shost->max_cmd_len =3D IBMVFC_MAX_CDB_LEN;
> =C2=A0	shost->unique_id =3D shost->host_no;
> =C2=A0	shost->nr_hw_queues =3D mq_enabled ? min(max_scsi_queues,
> nr_scsi_hw_queues) : 1;
> @@ -6556,6 +6560,7 @@ static struct fc_function_template
> ibmvfc_transport_functions =3D {
> =C2=A0 **/
> =C2=A0static int __init ibmvfc_module_init(void)
> =C2=A0{
> +	int min_max_sectors =3D PAGE_SIZE >> 9;
> =C2=A0	int rc;
> =C2=A0
> =C2=A0	if (!firmware_has_feature(FW_FEATURE_VIO))
> @@ -6564,6 +6569,12 @@ static int __init ibmvfc_module_init(void)
> =C2=A0	printk(KERN_INFO IBMVFC_NAME": IBM Virtual Fibre Channel
> Driver version: %s %s\n",
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IBMVFC_DRIVER_VERSION, IBMVFC=
_DRIVER_DATE);
> =C2=A0
> +	if (max_sectors < min_max_sectors) {
> +		printk(KERN_ERR IBMVFC_NAME": max_sectors must be at
> least %d.\n",
> +			min_max_sectors);
> +		max_sectors =3D min_max_sectors;
> +	}
> +
> =C2=A0	ibmvfc_transport_template =3D
> fc_attach_transport(&ibmvfc_transport_functions);
> =C2=A0	if (!ibmvfc_transport_template)
> =C2=A0		return -ENOMEM;
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h
> b/drivers/scsi/ibmvscsi/ibmvfc.h
> index 745ad5ac7251..c73ed2314ad0 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -32,7 +32,7 @@
> =C2=A0#define IBMVFC_DEBUG			0
> =C2=A0#define IBMVFC_MAX_TARGETS		1024
> =C2=A0#define IBMVFC_MAX_LUN			0xffffffff
> -#define IBMVFC_MAX_SECTORS		0xffffu
> +#define IBMVFC_MAX_SECTORS		2048
> =C2=A0#define IBMVFC_MAX_DISC_THREADS	4
> =C2=A0#define IBMVFC_TGT_MEMPOOL_SZ		64
> =C2=A0#define IBMVFC_MAX_CMDS_PER_LUN	64

