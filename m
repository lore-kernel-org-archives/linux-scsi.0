Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB171CF7D8;
	Mon, 21 Oct 2024 06:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492430; cv=none; b=SMzdTJ7ecBg4754yILHb07CkOyjZkwqGEzJrT4UFvqvH76nf1/g6jlD/Hb05vhbMBr+jOD9gVNHD0hWVj7JNKUH99IKgI074iV3qgz9huc9O8YCh9Rz/iMlqRN5sOkPJg2VQO9irJUVcGOLqqSInacGFLnHmOlrwVHNB5ZqeqlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492430; c=relaxed/simple;
	bh=vGM6VFN3RZwC8xVOJVdXJgMYiB+VOXHNuwnYO/UHDJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOp9Gg/St22xN7F3cscq00qL/C/EN+68Q4OqePYxWoh7tKWFGIDQ/cMhJaBBGbw0xZYkM4QimmDBqNkJhzcaavRcERLUUHMB2mMAUegpMYdW9AGAAwA8HDLcgNWdDJbvSx/Q10AyifnPVKPEgnWaQ0Udv6sSOy/A2BhTgzv0sGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P0Kvq7gl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XjivllKK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P0Kvq7gl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XjivllKK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P0Kvq7gl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XjivllKK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P0Kvq7gl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XjivllKK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BDE301FE8E;
	Mon, 21 Oct 2024 06:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729492425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8p22BvEnP08CpDwnec1TGaASH8ScGOYJUNhlQ1lAJ0=;
	b=P0Kvq7glk81FL1QoEBABmheTcwkylKtV1QRYr+4e7wNwOIHj6lvpvvpJ2t0KWuNgww9PPk
	z9uFkmz/fCxQGthfqCL7gDXTj9JHlG+WhhJ5XC1MsS4E8ykqBS5OmEhHuzk3vhbVVTDjTi
	lp7qZBnSl1axESW5t1fEW2ajItgDu5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729492425;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8p22BvEnP08CpDwnec1TGaASH8ScGOYJUNhlQ1lAJ0=;
	b=XjivllKKpxqQk4nbcQ/NHS9FEcHTFqpnkACwbsCM/EV+zoLgmfXxEYTSNvg2xSXzb+GcZg
	UbVlWBMFmvmhxzAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P0Kvq7gl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XjivllKK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729492425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8p22BvEnP08CpDwnec1TGaASH8ScGOYJUNhlQ1lAJ0=;
	b=P0Kvq7glk81FL1QoEBABmheTcwkylKtV1QRYr+4e7wNwOIHj6lvpvvpJ2t0KWuNgww9PPk
	z9uFkmz/fCxQGthfqCL7gDXTj9JHlG+WhhJ5XC1MsS4E8ykqBS5OmEhHuzk3vhbVVTDjTi
	lp7qZBnSl1axESW5t1fEW2ajItgDu5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729492425;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L8p22BvEnP08CpDwnec1TGaASH8ScGOYJUNhlQ1lAJ0=;
	b=XjivllKKpxqQk4nbcQ/NHS9FEcHTFqpnkACwbsCM/EV+zoLgmfXxEYTSNvg2xSXzb+GcZg
	UbVlWBMFmvmhxzAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27C13139E0;
	Mon, 21 Oct 2024 06:33:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VjUeCMn1FWczQAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Oct 2024 06:33:45 +0000
Message-ID: <bfc4f322-1dba-44ad-8839-382645cad372@suse.de>
Date: Mon, 21 Oct 2024 08:33:44 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/14] scsi: fnic: Add headers and definitions for FDLS
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241018161409.4442-1-kartilak@cisco.com>
 <20241018161409.4442-3-kartilak@cisco.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241018161409.4442-3-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDE301FE8E
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/18/24 18:13, Karan Tilak Kumar wrote:
> Add headers and definitions for FDLS (Fabric Discovery and Login
> Services).
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Co-developed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Co-developed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Co-developed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Arun Easi <aeasi@cisco.com>
> Co-developed-by: Karan Tilak Kumar <kartilak@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
> Changes between v4 and v5:
>      Incorporate review comments from Martin:
> 	Remove newline at the end of fnic_fdls.h.
> 	Modify attribution appropriately.
> 
> Changes between v2 and v3:
>      Incorporate review comments from Hannes:
> 	Replace redundant structure definitions with standard
> 	definitions.
> 	Remove multiple endian macro copies.
> 	Remove static OXIDs macro definitions.
> 
> Changes between v1 and v2:
>      Incorporate review comments from Hannes:
> 	Remove redundant patch description.
> 	Replace htonll() with get_unaligned_be64().
> 	Replace raw values with macro names.
> 	Remove fnic_del_fabric_timer_sync macro.
> 	Remove fnic_del_tport_timer_sync macro.
> 	Add fnic_del_fabric_timer_sync function declaration.
> 	Add fnic_del_tport_timer_sync function declaration.
> 	Replace definitions with standard definitions from fc_els.h.
> 	Move FDMI function declaration to this patch.
>      Incorporate review comments from John:
> 	Replace int return value with void.
> ---
>   drivers/scsi/fnic/fdls_fc.h   | 381 ++++++++++++++++++++++++++++++
>   drivers/scsi/fnic/fnic_fdls.h | 430 ++++++++++++++++++++++++++++++++++
>   2 files changed, 811 insertions(+)
>   create mode 100644 drivers/scsi/fnic/fdls_fc.h
>   create mode 100644 drivers/scsi/fnic/fnic_fdls.h
> 
> diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
> new file mode 100644
> index 000000000000..25dc89a4fc2f
> --- /dev/null
> +++ b/drivers/scsi/fnic/fdls_fc.h
> @@ -0,0 +1,381 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
> + * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
> + */
> +
> +#ifndef _FDLS_FC_H_
> +#define _FDLS_FC_H_
> +
> +/* This file contains the declarations for FC fabric services
> + * and target discovery
> + *
> + * Request and Response for
> + * 1. FLOGI
> + * 2. PLOGI to Fabric Controller
> + * 3. GPN_ID, GPN_FT
> + * 4. RSCN
> + * 5. PLOGI to Target
> + * 6. PRLI to Target
> + */
> +
> +#include <scsi/scsi.h>
> +#include <scsi/fc/fc_els.h>
> +#include <uapi/scsi/fc/fc_fs.h>
> +#include <uapi/scsi/fc/fc_ns.h>
> +#include <uapi/scsi/fc/fc_gs.h>
> +#include <scsi/fc/fc_ms.h>
> +
> +#ifndef MIN
> +#define MIN(x, y) (x < y ? x : y)
> +#endif				/* MIN */
> +

#include <linux/minmax.h>

> +#define FNIC_FCP_SP_RD_XRDY_DIS 0x00000002
> +#define FNIC_FCP_SP_TARGET      0x00000010
> +#define FNIC_FCP_SP_INITIATOR   0x00000020
> +#define FNIC_FCP_SP_CONF_CMPL   0x00000080
> +#define FNIC_FCP_SP_RETRY       0x00000100
> +
> +#define FNIC_E_D_TOV           (0x7d0)

Please keep E_D_TOV in decimal for better readability.
And anyway you can use FC_DEF_E_T_TOV (which is already
defined and has the same value)
> +#define FNIC_FC_CONCUR_SEQS    (0xFF)
> +#define FNIC_FC_RO_INFO        (0x1F)
> +
> +/* Little Endian */
> +#define FNIC_UNSUPPORTED_RESP_OXID   (0xffff)
> +#define FNIC_UNASSIGNED_RXID	(0xffff)
> +#define FNIC_ELS_REQ_FCTL      (0x000029)
> +#define FNIC_ELS_REP_FCTL      (0x000099)
> +
> +#define FNIC_FCP_RSP_FCTL      (0x000099)
> +#define FNIC_REQ_ABTS_FCTL     (0x000009)
> +
> +#define FNIC_FC_PH_VER_HI      (0x20)
> +#define FNIC_FC_PH_VER_LO      (0x20)
> +#define FNIC_FC_PH_VER         (0x2020)
> +#define FNIC_FC_B2B_CREDIT     (0x0A)
> +#define FNIC_FC_B2B_RDF_SZ     (0x0800)
> +
> +#define FNIC_FC_FEATURES       (0x0080)
> +
> +#define ETH_TYPE_FCOE			0x8906
> +#define ETH_TYPE_FIP			0x8914
> +

#include <linux/if_ether.h>
ETH_P_FIP
ETH_P_FCOE

> +#define FC_DIR_SERVER          0xFFFFFC
> +#define FC_FABRIC_CONTROLLER   0xFFFFFD
> +#define FC_DOMAIN_CONTR        0xFFFFFE
> +

Please use values from 'enum fc_well_known_fid'

> +#define FNIC_FC_GPN_LAST_ENTRY (0x80)
> +
> +#define FNIC_BA_ACC_RCTL        0x84
> +#define FNIC_BA_RJT_RCTL        0x85
> +#define FC_ABTS_RCTL            0x81
> +

#include <scsi/fc/fc_fs.h>

> +/* FNIC FDMI Register HBA Macros */
> +#define FNIC_FDMI_NUM_PORTS 0x1000000
> +#define FNIC_FDMI_NUM_HBA_ATTRS 0x9000000
> +#define FNIC_FDMI_TYPE_NODE_NAME	0X100
> +#define FNIC_FDMI_TYPE_MANUFACTURER	0X200
> +#define FNIC_FDMI_MANUFACTURER		"Cisco Systems"
> +#define FNIC_FDMI_TYPE_SERIAL_NUMBER	0X300
> +#define FNIC_FDMI_TYPE_MODEL		0X400
> +#define FNIC_FDMI_TYPE_MODEL_DES	0X500
> +#define FNIC_FDMI_MODEL_DESCRIPTION	"Cisco Virtual Interface Card"
> +#define FNIC_FDMI_TYPE_HARDWARE_VERSION	0X600
> +#define FNIC_FDMI_TYPE_DRIVER_VERSION	0X700
> +#define FNIC_FDMI_TYPE_ROM_VERSION	0X800
> +#define FNIC_FDMI_TYPE_FIRMWARE_VERSION	0X900
> +#define FNIC_FDMI_NN_LEN 0xc00
> +#define FNIC_FDMI_MANU_LEN 0x1800
> +#define FNIC_FDMI_SERIAL_LEN 0x1400
> +#define FNIC_FDMI_MODEL_LEN 0x1000
> +#define FNIC_FDMI_MODEL_DES_LEN 0x3c00
> +#define FNIC_FDMI_HW_VER_LEN 0x1400
> +#define FNIC_FDMI_DR_VER_LEN 0x2000
> +#define FNIC_FDMI_ROM_VER_LEN 0xc00
> +#define FNIC_FDMI_FW_VER_LEN 0x1400
> +
> +/* FNIC FDMI Register PA Macros */
> +#define FNIC_FDMI_TYPE_FC4_TYPES	0X100
> +#define FNIC_FDMI_TYPE_SUPPORTED_SPEEDS 0X200
> +#define FNIC_FDMI_TYPE_CURRENT_SPEED	0X300
> +#define FNIC_FDMI_TYPE_MAX_FRAME_SIZE	0X400
> +#define FNIC_FDMI_TYPE_OS_NAME		0X500
> +#define FNIC_FDMI_TYPE_HOST_NAME	0X600
> +#define FNIC_FDMI_NUM_PORT_ATTRS 0x6000000
> +#define FNIC_FDMI_FC4_LEN 0x2400
> +#define FNIC_FDMI_SUPP_SPEED_LEN 0x800
> +#define FNIC_FDMI_CUR_SPEED_LEN 0x800
> +#define FNIC_FDMI_MFS_LEN 0x800
> +#define FNIC_FDMI_MFS 0x0080000
> +#define FNIC_FDMI_OS_NAME_LEN 0x1400
> +#define FNIC_FDMI_HN_LEN 0x1C00
> +
Do these need to be defined here?
Wouldn't it be better to move them into the source file handling FDMI?
I doubt that they need to be available for every file ...

> +#define FNIC_LOGI_RDF_SIZE(_logi) ((_logi)->fl_csp.sp_bb_data)
> +#define FNIC_LOGI_R_A_TOV(_logi) ((_logi)->fl_csp.sp_r_a_tov)
> +#define FNIC_LOGI_E_D_TOV(_logi) ((_logi)->fl_csp.sp_e_d_tov)
> +#define FNIC_LOGI_FEATURES(_logi) ((_logi)->fl_csp.sp_features)
> +#define FNIC_LOGI_PORT_NAME(_logi) ((_logi)->fl_wwpn)
> +#define FNIC_LOGI_NODE_NAME(_logi) ((_logi)->fl_wwnn)
> +
> +#define FNIC_LOGI_SET_NPORT_NAME(_logi, _pName) \
> +	(FNIC_LOGI_PORT_NAME(_logi) = get_unaligned_be64(&_pName))
> +#define FNIC_LOGI_SET_NODE_NAME(_logi, _pName) \
> +	(FNIC_LOGI_NODE_NAME(_logi) = get_unaligned_be64(&_pName))
> +#define FNIC_LOGI_SET_RDF_SIZE(_logi, _rdf_size) \
> +	(FNIC_LOGI_RDF_SIZE(_logi) = cpu_to_be16(_rdf_size))
> +#define FNIC_LOGI_SET_E_D_TOV(_logi, _e_d_tov) \
> +	(FNIC_LOGI_E_D_TOV(_logi) = htonl(_e_d_tov))
> +#define FNIC_LOGI_SET_R_A_TOV(_logi, _r_a_tov) \
> +	(FNIC_LOGI_R_A_TOV(_logi) = htonl(_r_a_tov))
> +
> +#define FNIC_STD_SET_S_ID(_fchdr, _sid)        memcpy((_fchdr)->fh_s_id, _sid, 3)
> +#define FNIC_STD_SET_D_ID(_fchdr, _did)        memcpy((_fchdr)->fh_d_id, _did, 3)
> +#define FNIC_STD_SET_OX_ID(_fchdr, _oxid)      ((_fchdr)->fh_ox_id = _oxid)
> +#define FNIC_STD_SET_RX_ID(_fchdr, _rxid)      ((_fchdr)->fh_rx_id = _rxid)
> +
> +#define FNIC_STD_SET_R_CTL(_fchdr, _rctl)	((_fchdr)->fh_r_ctl = _rctl)
> +#define FNIC_STD_SET_TYPE(_fchdr, _type)	((_fchdr)->fh_type = _type)
> +#define FNIC_STD_SET_F_CTL(_fchdr, _fctl) \
> +	put_unaligned_be24(_fctl, (_fchdr)->fh_f_ctl)
> +
> +#define FNIC_STD_SET_NPORT_NAME(_ptr, _wwpn)	put_unaligned_be64(_wwpn, _ptr)
> +#define FNIC_STD_SET_NODE_NAME(_ptr, _wwnn)	put_unaligned_be64(_wwnn, _ptr)
> +#define FNIC_STD_SET_PORT_ID(__req, __portid) \
> +	memcpy(__req->fr_fid.fp_fid, __portid, 3)
> +#define FNIC_STD_SET_PORT_NAME(_req, _pName) \
> +	(put_unaligned_be64(_pName, &_req->fr_wwn))
> +
> +#define FNIC_STD_GET_OX_ID(_fchdr)		((_fchdr)->fh_ox_id)
> +#define FNIC_STD_GET_RX_ID(_fchdr)		((_fchdr)->fh_rx_id)
> +#define FNIC_STD_GET_S_ID(_fchdr)		((_fchdr)->fh_s_id)
> +#define FNIC_STD_GET_D_ID(_fchdr)		((_fchdr)->fh_d_id)
> +#define FNIC_STD_GET_TYPE(_fchdr)		((_fchdr)->fh_type)
> +#define FNIC_STD_GET_F_CTL(_fchdr)		((_fchdr)->fh_f_ctl)
> +#define FNIC_STD_GET_R_CTL(_fchdr)		((_fchdr)->fh_r_ctl)
> +
> +#define FNIC_STD_GET_FC_CT_CMD(__fcct_hdr)  (be16_to_cpu(__fcct_hdr->ct_cmd))
> +
> +#define FNIC_FCOE_SOF         (0x2E)
> +#define FNIC_FCOE_EOF         (0x42)
> +
> +#define FNIC_FCOE_MAX_FRAME_SZ  (2048)
> +#define FNIC_FCOE_MIN_FRAME_SZ  (280)
> +#define FNIC_FC_MAX_PAYLOAD_LEN (2048)
> +#define FNIC_MIN_DATA_FIELD_SIZE  (256)
> +#define FNIC_R_A_TOV_DEF        (10 * 1000) /* msec */
> +#define FNIC_E_D_TOV_DEF        (2 * 1000)  /* msec */
> +

?? You already had defined FNIC_E_D_TOV above ...

> +#define FNIC_FC_EDTOV_NSEC    (0x400)
> +#define FNIC_NSEC_TO_MSEC     (0x1000000)
> +#define FCP_PRLI_FUNC_TARGET	(0x0010)
> +
> +#define FNIC_FC_R_CTL_SOLICITED_DATA			(0x21)
> +#define FNIC_FC_F_CTL_LAST_END_SEQ				(0x98)
> +#define FNIC_FC_F_CTL_LAST_END_SEQ_INT			(0x99)
> +#define FNIC_FC_F_CTL_FIRST_LAST_SEQINIT		(0x29)
> +#define FNIC_FC_R_CTL_FC4_SCTL					(0x03)
> +#define FNIC_FC_CS_CTL							(0x00)
> +
> +#define FNIC_FC_FRAME_UNSOLICITED(_fchdr)				\
> +		(_fchdr->fh_r_ctl == FC_RCTL_ELS_REQ)
> +#define FNIC_FC_FRAME_SOLICITED_DATA(_fchdr)			\
> +		(_fchdr->fh_r_ctl == FNIC_FC_R_CTL_SOLICITED_DATA)
> +#define FNIC_FC_FRAME_SOLICITED_CTRL_REPLY(_fchdr)		\
> +		(_fchdr->fh_r_ctl == FC_RCTL_ELS_REP)
> +#define FNIC_FC_FRAME_FCTL_LAST_END_SEQ(_fchdr)			\
> +		(_fchdr->fh_f_ctl[0] == FNIC_FC_F_CTL_LAST_END_SEQ)
> +#define FNIC_FC_FRAME_FCTL_LAST_END_SEQ_INT(_fchdr)		\
> +		(_fchdr->fh_f_ctl[0] == FNIC_FC_F_CTL_LAST_END_SEQ_INT)
> +#define FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(_fchdr)	\
> +		(_fchdr->fh_f_ctl[0] == FNIC_FC_F_CTL_FIRST_LAST_SEQINIT)
> +#define FNIC_FC_FRAME_FC4_SCTL(_fchdr)					\
> +		(_fchdr->fh_r_ctl == FNIC_FC_R_CTL_FC4_SCTL)
> +#define FNIC_FC_FRAME_TYPE_BLS(_fchdr) (_fchdr->fh_type == FC_TYPE_BLS)
> +#define FNIC_FC_FRAME_TYPE_ELS(_fchdr) (_fchdr->fh_type == FC_TYPE_ELS)
> +#define FNIC_FC_FRAME_TYPE_FC_GS(_fchdr) (_fchdr->fh_type == FC_TYPE_CT)
> +#define FNIC_FC_FRAME_CS_CTL(_fchdr) (_fchdr->fh_cs_ctl == FNIC_FC_CS_CTL)
> +
> +#define FNIC_FC_C3_RDF         (0xfff)
> +#define FNIC_FC_PLOGI_RSP_RDF(_plogi_rsp) \
> +	(MIN(_plogi_rsp->u.csp_plogi.b2b_rdf_size, \
> +	(_plogi_rsp->spc3[4] & FNIC_FC_C3_RDF)))
> +#define FNIC_FC_PLOGI_RSP_CONCUR_SEQ(_plogi_rsp) \
> +	(MIN(_plogi_rsp->els.fl_csp.sp_tot_seq, \
> +	 (be16_to_cpu(_plogi_rsp->els.fl_cssp[2].cp_con_seq) & 0xff)))
> +
> +/* Frame header */
> +struct fnic_eth_hdr_s {
> +	uint8_t		dst_mac[6];
> +	uint8_t		src_mac[6];
> +	uint16_t	ether_type;
> +}  __packed;
> +
> +struct	fnic_fcoe_hdr_s	{
> +	uint8_t		ver;
> +	uint8_t		rsvd[12];
> +	uint8_t		sof;
> +} __packed;
> +
> +/* FLOGI/PLOGI struct */
> +struct fc_std_flogi {
> +	struct fc_frame_header fchdr;
> +	struct fc_els_flogi els;
> +} __packed;
> +
> +#define FC_ELS_RSP_ACC_SIZE (sizeof(struct fc_frame_header) + \
> +		sizeof(struct fc_els_ls_acc))
> +#define FC_ELS_RSP_REJ_SIZE (sizeof(struct fc_frame_header) + \
> +		sizeof(struct fc_els_ls_rjt))
> +
> +struct fc_std_els_rsp {
> +	struct fc_frame_header fchdr;
> +	union	{
> +	u8 rsp_cmd;
> +	struct fc_els_ls_acc acc;
> +	struct fc_els_ls_rjt rej;
> +	}	u;
> +} __packed;
> +
> +struct fc_std_els_adisc {
> +	struct fc_frame_header fchdr;
> +	struct fc_els_adisc els;
> +} __packed;
> +
> +struct fc_std_rls_acc {
> +	struct fc_frame_header fchdr;
> +	struct fc_els_rls_resp els;
> +} __packed;
> +
> +struct fc_std_abts_ba_acc {
> +	struct fc_frame_header fchdr;
> +	struct fc_ba_acc acc;
> +} __packed;
> +
> +struct fc_std_abts_ba_rjt {
> +	struct fc_frame_header fchdr;
> +	struct fc_ba_rjt rjt;
> +} __packed;
> +
> +struct fc_std_els_prli {
> +	struct fc_frame_header fchdr;
> +	struct fc_els_prli els_prli;
> +	struct fc_els_spp sp;
> +}	 __packed;
> +
> +struct fc_std_rpn_id {
> +	struct fc_frame_header fchdr;
> +	struct fc_ct_hdr fc_std_ct_hdr;
> +	struct fc_ns_rn_id rpn_id;
> +} __packed;
> +
> +struct fc_std_fdmi_rhba {
> +	struct fc_frame_header fchdr;
> +	struct fc_ct_hdr fc_std_ct_hdr;
> +	uint64_t	hba_identifier;
> +	uint32_t	num_ports;
> +	uint64_t	port_name;
> +	uint32_t	num_hba_attributes;
> +	uint16_t	type_nn;
> +	uint16_t	length_nn;
> +	uint64_t	node_name;
> +	uint16_t	type_manu;
> +	uint16_t	length_manu;
> +	uint8_t		manufacturer[20];
> +	uint16_t	type_serial;
> +	uint16_t	length_serial;
> +	uint8_t		serial_num[16];
> +	uint16_t	type_model;
> +	uint16_t	length_model;
> +	uint8_t		model[12];
> +	uint16_t	type_model_des;
> +	uint16_t	length_model_des;
> +	uint8_t		model_description[56];
> +	uint16_t	type_hw_ver;
> +	uint16_t	length_hw_ver;
> +	uint8_t		hardware_ver[16];
> +	uint16_t	type_dr_ver;
> +	uint16_t	length_dr_ver;
> +	uint8_t		driver_ver[28];
> +	uint16_t	type_rom_ver;
> +	uint16_t	length_rom_ver;
> +	uint8_t		rom_ver[8];
> +	uint16_t	type_fw_ver;
> +	uint16_t	length_fw_ver;
> +	uint8_t		firmware_ver[16];
> +} __packed;
> +
> +struct fc_std_fdmi_rpa {
> +	struct fc_frame_header fchdr;
> +	struct fc_ct_hdr fc_std_ct_hdr;
> +	uint64_t	port_name;
> +	uint32_t	num_port_attributes;
> +	uint16_t	type_fc4;
> +	uint16_t	length_fc4;
> +	uint8_t		fc4_type[32];
> +	uint16_t	type_supp_speed;
> +	uint16_t	length_supp_speed;
> +	uint32_t	supported_speed;
> +	uint16_t	type_cur_speed;
> +	uint16_t	length_cur_speed;
> +	uint32_t	current_speed;
> +	uint16_t	type_max_frame_size;
> +	uint16_t	length_max_frame_size;
> +	uint32_t	max_frame_size;
> +	uint16_t	type_os_name;
> +	uint16_t	length_os_name;
> +	uint8_t		os_name[16];
> +	uint16_t	type_host_name;
> +	uint16_t	length_host_name;
> +	uint8_t host_name[24];
> +}	 __packed;
> +

Weelll ....
There _is_ an FDMI structure definition in
include/scsi/fc/fc_ms.h.

Remainder looks ok.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
