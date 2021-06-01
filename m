Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D53FC47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 12:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6899613B9
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 12:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhFAMfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 08:35:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39538 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhFAMfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 08:35:32 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7D7D821926;
        Tue,  1 Jun 2021 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622550830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wkxv8ddWbn1ZJkQLzhMoJauWFbmny5cbY3G+Or05kw=;
        b=c9kxjb2dHsU6irKTdDchMYJn/UFMFwka9ZLtrjPbZYWwDREjOd+emy5E6As60gqKn6reS1
        h2g4TjAJ5w35/mvwH/tVolXiLHfMzHkh9kq17DCqeJmNnix63aj4dJiELzwZgVNu65NY7y
        pMh8Gcvu6s3k2d7TRX4kLHK+dpRHIjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622550830;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wkxv8ddWbn1ZJkQLzhMoJauWFbmny5cbY3G+Or05kw=;
        b=wQ0uZun1wgLgU87ucHlrO5zCsFseSlP/hyVAEb2ie98nMJnyQk5a/UGNKk3KAID5LDLqdO
        WT/pTW+HvtECotAg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 56287118DD;
        Tue,  1 Jun 2021 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622550830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wkxv8ddWbn1ZJkQLzhMoJauWFbmny5cbY3G+Or05kw=;
        b=c9kxjb2dHsU6irKTdDchMYJn/UFMFwka9ZLtrjPbZYWwDREjOd+emy5E6As60gqKn6reS1
        h2g4TjAJ5w35/mvwH/tVolXiLHfMzHkh9kq17DCqeJmNnix63aj4dJiELzwZgVNu65NY7y
        pMh8Gcvu6s3k2d7TRX4kLHK+dpRHIjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622550830;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wkxv8ddWbn1ZJkQLzhMoJauWFbmny5cbY3G+Or05kw=;
        b=wQ0uZun1wgLgU87ucHlrO5zCsFseSlP/hyVAEb2ie98nMJnyQk5a/UGNKk3KAID5LDLqdO
        WT/pTW+HvtECotAg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id smyFEy4ptmA5XQAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 01 Jun 2021 12:33:50 +0000
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-2-njavali@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH v2 01/10] qla2xxx: Add start + stop bsg's
Message-ID: <035e4f12-bf2b-99fa-a4e8-4d8b981056ca@suse.de>
Date:   Tue, 1 Jun 2021 14:33:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531070545.32072-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 9:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> This patch add 2 new BSG calls:
> QL_VND_SC_APP_START: application will announce its present
> to driver with this call. Driver will restart all
> connections to see if remote device support security or not.
> 
> QL_VND_SC_APP_STOP: application announce it's in the process
> of exiting. Driver will restart all connections to revert
> back to non-secure. Provided the remote device is willing
> to allow a non-secure connection.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/Makefile       |   3 +-
>  drivers/scsi/qla2xxx/qla_bsg.c      |   3 +
>  drivers/scsi/qla2xxx/qla_bsg.h      |   3 +
>  drivers/scsi/qla2xxx/qla_dbg.h      |   1 +
>  drivers/scsi/qla2xxx/qla_def.h      |  70 ++++--
>  drivers/scsi/qla2xxx/qla_edif.c     | 349 ++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_edif.h     |  32 +++
>  drivers/scsi/qla2xxx/qla_edif_bsg.h | 225 ++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_gbl.h      |   4 +
>  9 files changed, 666 insertions(+), 24 deletions(-)
>  create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
>  create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h
> 
> diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
> index 17d5bc1cc56b..cbc1303e761e 100644
> --- a/drivers/scsi/qla2xxx/Makefile
> +++ b/drivers/scsi/qla2xxx/Makefile
> @@ -1,7 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
>  		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
> -		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o
> +		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o \
> +		qla_edif.o
>  
>  obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
>  obj-$(CONFIG_TCM_QLA2XXX) += tcm_qla2xxx.o
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index d42b2ad84049..e6cccbcc7a1b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2840,6 +2840,9 @@ qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
>  	case QL_VND_DPORT_DIAGNOSTICS:
>  		return qla2x00_do_dport_diagnostics(bsg_job);
>  
> +	case QL_VND_EDIF_MGMT:
> +		return qla_edif_app_mgmt(bsg_job);
> +
>  	case QL_VND_SS_GET_FLASH_IMAGE_STATUS:
>  		return qla2x00_get_flash_image_status(bsg_job);
>  
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
> index 0274e99e4a12..dd793cf8bc1e 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -31,6 +31,7 @@
>  #define QL_VND_DPORT_DIAGNOSTICS	0x19
>  #define QL_VND_GET_PRIV_STATS_EX	0x1A
>  #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
> +#define QL_VND_EDIF_MGMT                0X1F
>  #define QL_VND_MANAGE_HOST_STATS	0x23
>  #define QL_VND_GET_HOST_STATS		0x24
>  #define QL_VND_GET_TGT_STATS		0x25
> @@ -294,4 +295,6 @@ struct qla_active_regions {
>  	uint8_t reserved[32];
>  } __packed;
>  
> +#include "qla_edif_bsg.h"
> +
>  #endif
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index 9eb708e5e22e..f1f6c740bdcd 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -367,6 +367,7 @@ ql_log_qp(uint32_t, struct qla_qpair *, int32_t, const char *fmt, ...);
>  #define ql_dbg_tgt_mgt	0x00002000 /* Target mode management */
>  #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
>  #define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
> +#define ql_dbg_edif	0x00000400 /* edif and purex debug */
>  
>  extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
>  	uint32_t, void **);
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index def4d99f80e9..ac3b9b39d741 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -49,6 +49,28 @@ typedef struct {
>  	uint8_t domain;
>  } le_id_t;
>  
> +/*
> + * 24 bit port ID type definition.
> + */
> +typedef union {
> +	uint32_t b24 : 24;
> +	struct {
> +#ifdef __BIG_ENDIAN
> +		uint8_t domain;
> +		uint8_t area;
> +		uint8_t al_pa;
> +#elif defined(__LITTLE_ENDIAN)
> +		uint8_t al_pa;
> +		uint8_t area;
> +		uint8_t domain;
> +#else
> +#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
> +#endif
> +		uint8_t rsvd_1;
> +	} b;
> +} port_id_t;
> +#define INVALID_PORT_ID	0xFFFFFF
> +
>  #include "qla_bsg.h"
>  #include "qla_dsd.h"
>  #include "qla_nx.h"
> @@ -345,6 +367,8 @@ struct name_list_extended {
>  #define FW_MAX_EXCHANGES_CNT (32 * 1024)
>  #define REDUCE_EXCHANGES_CNT  (8 * 1024)
>  
> +#define SET_DID_STATUS(stat_var, status) (stat_var = status << 16)
> +
>  struct req_que;
>  struct qla_tgt_sess;
>  
> @@ -373,29 +397,6 @@ struct srb_cmd {
>  
>  /* To identify if a srb is of T10-CRC type. @sp => srb_t pointer */
>  #define IS_PROT_IO(sp)	(sp->flags & SRB_CRC_CTX_DSD_VALID)
> -
> -/*
> - * 24 bit port ID type definition.
> - */
> -typedef union {
> -	uint32_t b24 : 24;
> -
> -	struct {
> -#ifdef __BIG_ENDIAN
> -		uint8_t domain;
> -		uint8_t area;
> -		uint8_t al_pa;
> -#elif defined(__LITTLE_ENDIAN)
> -		uint8_t al_pa;
> -		uint8_t area;
> -		uint8_t domain;
> -#else
> -#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
> -#endif
> -		uint8_t rsvd_1;
> -	} b;
> -} port_id_t;
> -#define INVALID_PORT_ID	0xFFFFFF
>  #define ISP_REG16_DISCONNECT 0xFFFF
>  
>  static inline le_id_t be_id_to_le(be_id_t id)
> @@ -2424,6 +2425,7 @@ enum discovery_state {
>  	DSC_LOGIN_COMPLETE,
>  	DSC_ADISC,
>  	DSC_DELETE_PEND,
> +	DSC_LOGIN_AUTH_PEND,
>  };
>  
>  enum login_state {	/* FW control Target side */
> @@ -2563,6 +2565,22 @@ typedef struct fc_port {
>  	u64 tgt_short_link_down_cnt;
>  	u64 tgt_link_down_time;
>  	u64 dev_loss_tmo;
> +	/*
> +	 * EDIF parameters for encryption.
> +	 */
> +	struct {
> +		uint16_t	enable:1;	// device is edif enabled/req'd
> +		uint16_t	app_stop:2;
> +		uint16_t	app_started:1;
> +		uint16_t	secured_login:1;
> +		uint16_t	app_sess_online:1;

How very uncommon; defining a uint16_t bitfield.
Why not make it uint32_t?
But adding it to the start of the structure you also induced a possible
padding here; the compiler will most likely pad it to 64 bit here.

> +		uint32_t	tx_rekey_cnt;
> +		uint32_t	rx_rekey_cnt;
> +		// delayed rx delete data structure list
> +		uint64_t	tx_bytes;
> +		uint64_t	rx_bytes;
> +		uint8_t		non_secured_login;

Isn't this just a bit? Can't it be merged with the flags above?

> +	} edif;
>  } fc_port_t;
>  
>  enum {
> @@ -2616,6 +2634,7 @@ static const char * const port_dstate_str[] = {
>  #define FCF_ASYNC_SENT		BIT_3
>  #define FCF_CONF_COMP_SUPPORTED BIT_4
>  #define FCF_ASYNC_ACTIVE	BIT_5
> +#define FCF_FCSP_DEVICE		BIT_6
>  
>  /* No loop ID flag. */
>  #define FC_NO_LOOP_ID		0x1000
> @@ -3933,6 +3952,7 @@ struct qla_hw_data {
>  		uint32_t	scm_supported_f:1;
>  				/* Enabled in Driver */
>  		uint32_t	scm_enabled:1;
> +		uint32_t	edif_enabled:1;
>  		uint32_t	max_req_queue_warned:1;
>  		uint32_t	plogi_template_valid:1;
>  		uint32_t	port_isolated:1;
> @@ -4656,6 +4676,8 @@ struct purex_item {
>  	} iocb;
>  };
>  
> +#include "qla_edif.h"
> +
>  #define SCM_FLAG_RDF_REJECT		0x00
>  #define SCM_FLAG_RDF_COMPLETED		0x01
>  
> @@ -4884,6 +4906,8 @@ typedef struct scsi_qla_host {
>  	u64 reset_cmd_err_cnt;
>  	u64 link_down_time;
>  	u64 short_link_down_cnt;
> +	struct edif_dbell e_dbell;
> +	struct pur_core pur_cinfo;
>  } scsi_qla_host_t;
>  
>  struct qla27xx_image_status {
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> new file mode 100644
> index 000000000000..38d79ef2e700
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -0,0 +1,349 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Marvell Fibre Channel HBA Driver
> + * Copyright (c)  2021     Marvell
> + */
> +#include "qla_def.h"
> +//#include "qla_edif.h"
> +

Add a commented out header in a new file?
Why?

> +#include <linux/kthread.h>
> +#include <linux/vmalloc.h>
> +#include <linux/delay.h>
> +#include <scsi/scsi_tcq.h>
> +
> +static void
> +qla_edif_sa_ctl_init(scsi_qla_host_t *vha, struct fc_port  *fcport)
> +{
> +	ql_dbg(ql_dbg_edif, vha, 0x2058,
> +		"Init SA_CTL List for fcport - nn %8phN pn %8phN portid=%02x%02x%02x.\n",
> +		fcport->node_name, fcport->port_name,
> +		fcport->d_id.b.domain, fcport->d_id.b.area,
> +		fcport->d_id.b.al_pa);
> +
> +	fcport->edif.tx_rekey_cnt = 0;
> +	fcport->edif.rx_rekey_cnt = 0;
> +
> +	fcport->edif.tx_bytes = 0;
> +	fcport->edif.rx_bytes = 0;
> +}
> +
> +static int
> +qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
> +{
> +	int rval = 0;	/* assume failure */
> +
> +	/* check that the app is allow/known to the driver */
> +
> +	/* TODO: edif: implement key/cert check for permitted apps... */
> +
> +	if (appid.app_vid == 0x73730001) {

Huh? A hard-coded value?
Please don't. Use a #define here to make it clear what this value is
supposed to mean.

> +		rval = 1;
> +		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d, "%s app id ok\n", __func__);
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app id not ok (%x)",
> +		    __func__, appid.app_vid);
> +	}
> +
> +	return rval;
> +}

And you can kill 'rval' by just call 'return' in the if branches.
Plus this function should probably be a 'bool' function ...

> +
> +/*
> + * reset the session to auth wait.
> + */
> +static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
> +		int waitonly)
> +{
> +	int cnt, max_cnt = 200;
> +	bool traced = false;
> +
> +	fcport->keep_nport_handle = 1;
> +
> +	if (!waitonly) {
> +		qla2x00_set_fcport_disc_state(fcport, state);
> +		qlt_schedule_sess_for_deletion(fcport);
> +	} else {
> +		qla2x00_set_fcport_disc_state(fcport, state);
> +	}
> +
> +	ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +		"%s: waiting for session, max_cnt=%u\n",
> +		__func__, max_cnt);
> +
> +	cnt = 0;
> +
> +	if (waitonly) {
> +		/* Marker wait min 10 msecs. */
> +		msleep(50);
> +		cnt += 50;
> +	}
> +	while (1) {
> +		if (!traced) {
> +			ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +			"%s: session sleep.\n",
> +			__func__);
> +			traced = true;
> +		}
> +		msleep(20);
> +		cnt++;
> +		if (waitonly && (fcport->disc_state == state ||
> +			fcport->disc_state == DSC_LOGIN_COMPLETE))
> +			break;
> +		if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
> +			break;
> +		if (cnt > max_cnt)
> +			break;
> +	}
> +
> +	if (!waitonly) {
> +		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +	"%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
> +		    __func__, fcport->port_name, fcport->loop_id,
> +		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
> +	} else {
> +		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +	"%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
> +		    __func__, fcport->port_name, fcport->loop_id,
> +		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);

Indentation.

> +	}
> +}
> +
> +/*
> + * event that the app has started. Clear and start doorbell
> + */
> +static int
> +qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	struct app_start	appstart;
> +	struct app_start_reply	appreply;
> +	struct fc_port  *fcport, *tf;
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app start\n", __func__);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appstart,
> +	    sizeof(struct app_start));
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app_vid=%x app_start_flags %x\n",
> +	     __func__, appstart.app_info.app_vid, appstart.app_start_flags);
> +
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		/* mark doorbell as active since an app is now present */
> +		vha->e_dbell.db_flags = EDB_ACTIVE;
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
> +		     __func__);
> +	}
> +
> +	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +		if ((fcport->flags & FCF_FCSP_DEVICE)) {
> +			ql_dbg(ql_dbg_edif, vha, 0xf084,
> +			    "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
> +			    __func__, fcport, fcport->port_name,
> +			    fcport->loop_id, fcport->d_id.b24,
> +			    fcport->logout_on_delete);
> +
> +			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
> +				break;
> +
> +			if (!fcport->edif.secured_login)
> +				continue;
> +
> +			fcport->edif.app_started = 1;
> +			if (fcport->edif.app_stop ||
> +			    (fcport->disc_state != DSC_LOGIN_COMPLETE &&
> +			     fcport->disc_state != DSC_LOGIN_PEND &&
> +			     fcport->disc_state != DSC_DELETED)) {
> +				/* no activity */
> +				fcport->edif.app_stop = 0;
> +
> +				ql_dbg(ql_dbg_edif, vha, 0x911e,
> +				    "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> +				    __func__, fcport->port_name);
> +				fcport->edif.app_sess_online = 1;
> +				qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> +			}
> +			qla_edif_sa_ctl_init(vha, fcport);
> +		}
> +	}
> +
> +	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
> +		/* mark as active since an app is now present */
> +		vha->pur_cinfo.enode_flags = ENODE_ACTIVE;
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911f, "%s enode already active\n",
> +		     __func__);
> +	}
> +
> +	appreply.host_support_edif = vha->hw->flags.edif_enabled;
> +	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
> +	appreply.edif_edb_active = vha->e_dbell.db_flags;
> +
> +	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
> +	    sizeof(struct app_start_reply);
> +
> +	SET_DID_STATUS(bsg_reply->result, DID_OK);
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	    bsg_job->reply_payload.sg_cnt, &appreply,
> +	    sizeof(struct app_start_reply));
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d,
> +	    "%s app start completed with 0x%x\n",
> +	    __func__, rval);
> +
> +	return rval;
> +}
> +
> +/*
> + * notification from the app that the app is stopping.
> + * actions:	stop and doorbell
> + *		stop and clear enode
> + */
> +static int
> +qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t                 rval = 0;
> +	struct app_stop         appstop;
> +	struct fc_bsg_reply     *bsg_reply = bsg_job->reply;
> +	struct fc_port  *fcport, *tf;
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appstop,
> +	    sizeof(struct app_stop));
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s Stopping APP: app_vid=%x\n",
> +	    __func__, appstop.app_info.app_vid);
> +
> +	/* Call db stop and enode stop functions */
> +
> +	/* if we leave this running short waits are operational < 16 secs */
> +	qla_enode_stop(vha);        /* stop enode */
> +	qla_edb_stop(vha);          /* stop db */
> +
> +	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +		if (fcport->edif.non_secured_login)
> +			continue;
> +
> +		if (fcport->flags & FCF_FCSP_DEVICE) {
> +			ql_dbg(ql_dbg_edif, vha, 0xf084,
> +	"%s: sess %p from port %8phC lid %#04x s_id %06x logout %d keep %d els_logo %d\n",

Indentation

> +			    __func__, fcport,
> +			    fcport->port_name, fcport->loop_id,
> +			    fcport->d_id.b24, fcport->logout_on_delete,
> +			    fcport->keep_nport_handle, fcport->send_els_logo);
> +
> +			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
> +				break;
> +
> +			fcport->edif.app_stop = 1;
> +			ql_dbg(ql_dbg_edif, vha, 0x911e,
> +				"%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> +				__func__, fcport->port_name);
> +
> +			fcport->send_els_logo = 1;
> +			qlt_schedule_sess_for_deletion(fcport);
> +
> +			/* qla_edif_flush_sa_ctl_lists(fcport); */
> +			fcport->edif.app_started = 0;
> +		}
> +	}
> +
> +	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +	SET_DID_STATUS(bsg_reply->result, DID_OK);
> +
> +	/* no return interface to app - it assumes we cleaned up ok */
> +
> +	return rval;
> +}
> +
> +int32_t
> +qla_edif_app_mgmt(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request	*bsg_request = bsg_job->request;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t		*vha = shost_priv(host);
> +	struct app_id		appcheck;
> +	bool done = true;
> +	int32_t         rval = 0;
> +	uint32_t	vnd_sc = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s vnd subcmd=%x\n",
> +	    __func__, vnd_sc);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appcheck,
> +	    sizeof(struct app_id));
> +
> +	if (!vha->hw->flags.edif_enabled ||
> +		test_bit(VPORT_DELETE, &vha->dpc_flags)) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +		    "%s edif not enabled or vp delete. bsg ptr done %p\n",
> +		    __func__, bsg_job);
> +
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		goto done;
> +	}
> +
> +	if (qla_edif_app_check(vha, appcheck) == 0) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +		    "%s app checked failed.\n",
> +		    __func__);
> +
> +		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		goto done;
> +	}
> +
> +	switch (vnd_sc) {
> +	case QL_VND_SC_APP_START:
> +		rval = qla_edif_app_start(vha, bsg_job);
> +		break;
> +	case QL_VND_SC_APP_STOP:
> +		rval = qla_edif_app_stop(vha, bsg_job);
> +		break;
> +	default:
> +		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
> +		    __func__,
> +		    bsg_request->rqst_data.h_vendor.vendor_cmd[1]);
> +		rval = EXT_STATUS_INVALID_PARAM;
> +		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		break;
> +	}
> +
> +done:
> +	if (done) {
> +		ql_dbg(ql_dbg_user, vha, 0x7009,
> +		    "%s: %d  bsg ptr done %p\n", __func__, __LINE__, bsg_job);
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +		    bsg_reply->reply_payload_rcv_len);
> +	}
> +
> +	return rval;
> +}
> +void
> +qla_enode_stop(scsi_qla_host_t *vha)
> +{
> +	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s enode not active\n", __func__);
> +		return;
> +	}
> +}
> +
> +/* function called when app is stopping */
> +
> +void
> +qla_edb_stop(scsi_qla_host_t *vha)
> +{
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s doorbell not enabled\n", __func__);
> +		return;
> +	}
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
> new file mode 100644
> index 000000000000..dc0a08570a0b
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Marvell Fibre Channel HBA Driver
> + * Copyright (c)  2021    Marvell
> + */
> +#ifndef __QLA_EDIF_H
> +#define __QLA_EDIF_H
> +
> +struct qla_scsi_host;
> +
> +enum enode_flags_t {
> +	ENODE_ACTIVE = 0x1,	// means that app has started
> +};
> +
> +struct pur_core {
> +	enum enode_flags_t	enode_flags;
> +	spinlock_t		pur_lock;       /* protects list */
> +	struct  list_head	head;
> +};
> +
> +enum db_flags_t {
> +	EDB_ACTIVE = 0x1,
> +};
> +
> +struct edif_dbell {
> +	enum db_flags_t		db_flags;
> +	spinlock_t		db_lock;	/* protects list */
> +	struct  list_head	head;
> +	struct	completion	dbell;		/* doorbell ring */
> +};
> +
> +#endif	/* __QLA_EDIF_H */
> diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> new file mode 100644
> index 000000000000..9c05b78253e7
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> @@ -0,0 +1,225 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Marvell Fibre Channel HBA Driver
> + * Copyright (C)  2018-	    Marvell
> + *
> + */
> +#ifndef __QLA_EDIF_BSG_H
> +#define __QLA_EDIF_BSG_H
> +
> +/* BSG Vendor specific commands */
> +#define	ELS_MAX_PAYLOAD		1024
> +#ifndef	WWN_SIZE
> +#define WWN_SIZE		8       /* Size of WWPN, WWN & WWNN */
> +#endif
> +#define	VND_CMD_APP_RESERVED_SIZE	32
> +
> +enum auth_els_sub_cmd {
> +	SEND_ELS = 0,
> +	SEND_ELS_REPLY,
> +	PULL_ELS,
> +};
> +
> +struct extra_auth_els {
> +	enum auth_els_sub_cmd sub_cmd;
> +	uint32_t        extra_rx_xchg_address; // FC_ELS_ACC | FC_ELS_RJT
> +	uint8_t         extra_control_flags;
> +#define BSG_CTL_FLAG_INIT       0
> +#define BSG_CTL_FLAG_LS_ACC     1
> +#define BSG_CTL_FLAG_LS_RJT     2
> +#define BSG_CTL_FLAG_TRM        3
> +	uint8_t         extra_rsvd[3];
> +} __packed;
> +
> +struct qla_bsg_auth_els_request {
> +	struct fc_bsg_request r;
> +	struct extra_auth_els e;
> +};
> +
> +struct qla_bsg_auth_els_reply {
> +	struct fc_bsg_reply r;
> +	uint32_t rx_xchg_address;
> +};
> +
> +struct app_id {
> +	int		app_vid;
> +	uint8_t		app_key[32];
> +} __packed;
> +
> +struct app_start_reply {
> +	uint32_t	host_support_edif;	// 0=disable, 1=enable
> +	uint32_t	edif_enode_active;	// 0=disable, 1=enable
> +	uint32_t	edif_edb_active;	// 0=disable, 1=enable
> +	uint32_t	reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +struct app_start {
> +	struct app_id	app_info;
> +	uint32_t	prli_to;	// timer plogi/prli to complete
> +	uint32_t	key_shred;	// timer before shredding old keys
> +	uint8_t         app_start_flags;
> +	uint8_t         reserved[VND_CMD_APP_RESERVED_SIZE - 1];
> +} __packed;
> +
> +struct app_stop {
> +	struct app_id	app_info;
> +	char		buf[16];
> +} __packed;
> +
> +struct app_plogi_reply {
> +	uint32_t	prli_status;  // 0=failed, 1=succeeded
> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +#define	RECFG_TIME	1
> +#define	RECFG_BYTES	2
> +
> +struct app_rekey_cfg {
> +	struct app_id app_info;
> +	uint8_t	 rekey_mode;	// 1=time based (in sec), 2: bytes based
> +	port_id_t d_id;		// 000 = all entries; anything else
> +				//    specifies a specific d_id
> +	uint8_t	 force;		// 0=no force to change config if
> +				//    existing rekey mode changed,
> +				// 1=force to re auth and change
> +				//    existing rekey mode if different
> +	union {
> +		int64_t bytes;	// # of bytes before rekey, 0=no limit
> +		int64_t time;	// # of seconds before rekey, 0=no time limit
> +	} rky_units;
> +
> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +struct app_pinfo_req {
> +	struct app_id app_info;
> +	uint8_t	 num_ports;	// space allocated for app_pinfo_reply_t.ports[]
> +	port_id_t remote_pid;
> +	uint8_t	 reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +struct app_pinfo {
> +	port_id_t remote_pid;   // contains device d_id
> +	uint8_t	remote_wwpn[WWN_SIZE];
> +	uint8_t	remote_type;	// contains TGT or INIT
> +#define	VND_CMD_RTYPE_UNKNOWN		0
> +#define	VND_CMD_RTYPE_TARGET		1
> +#define	VND_CMD_RTYPE_INITIATOR		2
> +	uint8_t	remote_state;	// 0=bad, 1=good
> +	uint8_t	auth_state;	// 0=auth N/A (unsecured fcport),
> +				// 1=auth req'd
> +				// 2=auth done
> +	uint8_t	rekey_mode;	// 1=time based, 2=bytes based
> +	int64_t	rekey_count;	// # of times device rekeyed
> +	int64_t	rekey_config_value;     // orig rekey value (MB or sec)
> +					// (0 for no limit)
> +	int64_t	rekey_consumed_value;   // remaining MB/time,0=no limit
> +
> +	uint8_t	reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +/* AUTH States */
> +#define	VND_CMD_AUTH_STATE_UNDEF	0
> +#define	VND_CMD_AUTH_STATE_SESSION_SHUTDOWN	1
> +#define	VND_CMD_AUTH_STATE_NEEDED	2
> +#define	VND_CMD_AUTH_STATE_ELS_RCVD	3
> +#define	VND_CMD_AUTH_STATE_SAUPDATE_COMPL 4
> +
> +struct app_pinfo_reply {
> +	uint8_t		port_count;	// possible value => 0 to 255
> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +	struct app_pinfo ports[0];	// variable - specified by app_pinfo_req num_ports
> +} __packed;
> +
> +struct app_sinfo_req {
> +	struct app_id	app_info;
> +	uint8_t		num_ports;	// app space alloc for elem[]
> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +// temp data - actual data TBD
> +struct app_sinfo {
> +	uint8_t	remote_wwpn[WWN_SIZE];
> +	int64_t	rekey_count;	// # of times device rekeyed
> +	uint8_t	rekey_mode;	// 1=time based (in sec), 2: bytes based
> +	int64_t	tx_bytes;	// orig rekey value
> +	int64_t	rx_bytes;	// amount left
> +} __packed;
> +
> +struct app_stats_reply {
> +	uint8_t		elem_count;	// possible value => 0 to 255
> +	struct app_sinfo elem[0];	// specified by app_sinfo_t elem_count
> +} __packed;
> +
> +struct qla_sa_update_frame {
> +	struct app_id	app_info;
> +	uint16_t	flags;
> +#define SAU_FLG_INV		0x01	// delete key
> +#define SAU_FLG_TX		0x02	// 1=tx, 0 = rx
> +#define SAU_FLG_FORCE_DELETE	0x08	// force RX sa_index delete
> +#define SAU_FLG_GMAC_MODE	0x20	// GMAC mode is cleartext for the IO (i.e. NULL encryption)
> +#define SAU_FLG_KEY128          0x40
> +#define SAU_FLG_KEY256          0x80
> +	uint16_t        fast_sa_index:10,
> +			reserved:6;
> +	uint32_t	salt;
> +	uint32_t	spi;
> +	uint8_t		sa_key[32];
> +	uint8_t		node_name[WWN_SIZE];
> +	uint8_t		port_name[WWN_SIZE];
> +	port_id_t	port_id;
> +} __packed;
> +
> +// used for edif mgmt bsg interface
> +#define	QL_VND_SC_UNDEF		0
> +#define	QL_VND_SC_SA_UPDATE	1	// sa key info
> +#define	QL_VND_SC_APP_START	2	// app started event
> +#define	QL_VND_SC_APP_STOP	3	// app stopped event
> +#define	QL_VND_SC_AUTH_OK	4	// plogi auth'd ok
> +#define	QL_VND_SC_AUTH_FAIL	5	// plogi auth bad
> +#define	QL_VND_SC_REKEY_CONFIG	6	// auth rekey set parms (time/data)
> +#define	QL_VND_SC_GET_FCINFO	7	// get port info
> +#define	QL_VND_SC_GET_STATS	8	// get edif stats
> +
> +/* Application interface data structure for rtn data */
> +#define	EXT_DEF_EVENT_DATA_SIZE	64
> +struct edif_app_dbell {
> +	uint32_t	event_code;
> +	uint32_t	event_data_size;
> +	union  {
> +		port_id_t	port_id;
> +		uint8_t		event_data[EXT_DEF_EVENT_DATA_SIZE];
> +	};
> +} __packed;
> +
> +struct edif_sa_update_aen {
> +	port_id_t port_id;
> +	uint32_t key_type;	/* Tx (1) or RX (2) */
> +	uint32_t status;	/* 0 succes,  1 failed, 2 timeout , 3 error */
> +	uint8_t		reserved[16];
> +} __packed;
> +
> +#define	QL_VND_SA_STAT_SUCCESS	0
> +#define	QL_VND_SA_STAT_FAILED	1
> +#define	QL_VND_SA_STAT_TIMEOUT	2
> +#define	QL_VND_SA_STAT_ERROR	3
> +
> +#define	QL_VND_RX_SA_KEY	1
> +#define	QL_VND_TX_SA_KEY	2
> +
> +/* App defines for plogi auth'd ok and plogi auth bad requests */
> +struct auth_complete_cmd {
> +	struct app_id app_info;
> +#define PL_TYPE_WWPN    1
> +#define PL_TYPE_DID     2
> +	uint32_t    type;
> +	union {
> +		uint8_t  wwpn[WWN_SIZE];
> +		port_id_t d_id;
> +	} u;
> +	uint32_t reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +#define RX_DELAY_DELETE_TIMEOUT 20			// 30 second timeout
> +
> +#endif	/* QLA_EDIF_BSG_H */
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..02c10caed18b 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -953,6 +953,10 @@ extern void qla_nvme_abort_process_comp_status
>  
>  /* nvme.c */
>  void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> +void qla_edb_stop(scsi_qla_host_t *vha);
> +int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
> +void qla_enode_init(scsi_qla_host_t *vha);
> +void qla_enode_stop(scsi_qla_host_t *vha);
>  void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
>  
>  #define QLA2XX_HW_ERROR			BIT_0
> 
Isn't this an optional feature?
Maybe make it a compile-time option to enable EDIF?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
