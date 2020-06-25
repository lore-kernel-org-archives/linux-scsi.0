Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B22C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D10820885
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C6zqKPWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgFYXio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgFYXin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 19:38:43 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DDBC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:38:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a1so7589561ejg.12
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DeT1UxOv1mKu/fonWyYF4ZAgS4dfYrBs8QrpwzUp9Fs=;
        b=C6zqKPWo0lvKKQ1o2lOm8MPfFBu8rJIz+uZpBZci6E3ICcm4oN35+LQUR9UFC5NSqR
         6RpJ0dbNr7zVCoFw03JwRbKk3P2lzMZPpNCWXp44QB87fpUQecU3ltdFthgxV8ev91/a
         3ScC9henTxbQONKuOHDsplxPL7o+0nE65/GFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DeT1UxOv1mKu/fonWyYF4ZAgS4dfYrBs8QrpwzUp9Fs=;
        b=elqyHNwavwdQ02JLV9RCTEVsdAq8W8gESwJYwAdCE7QmwfZ8X0KZ9H7+7+dq2lbBV4
         Qp/s25WsK49/WmtjZdjs6G0+D6UXr7rxoT6pyRTmp6j0tudW7/+lElS134o9wht7so26
         jF4PjPB9oNdpFvc8AllSWJk8wJqzhIHaIBgX8NMcQuRHpOQqrPnY/+afqJiQuGiyQQPh
         Oa4gBcW9NR89FSWpvOzLhv3dmRR6jKQPCw1zqzKd3FGfFfB7owuzwMbcGLVIW3Wf1b/l
         QyETckBJ9BDW3BwQs4LCd9pMI3Wan9G1TCBzbT/LLYSeB0kl+tQpRwUyuZO9pH6k1w/M
         Lwcw==
X-Gm-Message-State: AOAM532oBKsaMwhP9XKuAX4C7eb8AgmcLOo5QR2sYrlnvPDAiMUVyes/
        +rfMZ22kpD3PzRBX1UKAgg9SSg==
X-Google-Smtp-Source: ABdhPJyyi1GtMvjuyTAnzybbI25r6C8e/9upzpwKXJH2QFCv95jTvW+IYKWvI+MFcHp5sAcfAPYO7w==
X-Received: by 2002:a17:906:3da1:: with SMTP id y1mr182556ejh.109.1593128321607;
        Thu, 25 Jun 2020 16:38:41 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c18sm5462899eja.59.2020.06.25.16.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 16:38:40 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] qla2xxx: Change in PUREX to handle FPIN ELS
 requests.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200610141509.10616-1-njavali@marvell.com>
 <20200610141509.10616-2-njavali@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <5910af97-d0a2-a77a-627b-c80c73371fd6@broadcom.com>
Date:   Thu, 25 Jun 2020 16:38:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610141509.10616-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/10/2020 7:15 AM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
>
> SAN Congestion Management generates ELS pkts whose size
> can vary, and be > 64 bytes. Change the purex
> handling code to support non standard ELS pkt size.
>
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h |  20 +++++-
>   drivers/scsi/qla2xxx/qla_gbl.h |   3 +-
>   drivers/scsi/qla2xxx/qla_isr.c | 116 ++++++++++++++++++++++++---------
>   drivers/scsi/qla2xxx/qla_mbx.c |  22 +++++--
>   drivers/scsi/qla2xxx/qla_os.c  |  19 ++++--
>   include/uapi/scsi/fc/fc_els.h  |   1 +
>   6 files changed, 139 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 172ea4e5887d..2e058ac4fec7 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -34,6 +34,8 @@
>   #include <scsi/scsi_transport_fc.h>
>   #include <scsi/scsi_bsg_fc.h>
>   
> +#include <uapi/scsi/fc/fc_els.h>
> +
>   /* Big endian Fibre Channel S_ID (source ID) or D_ID (destination ID). */
>   typedef struct {
>   	uint8_t domain;
> @@ -1269,7 +1271,11 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
>   #define RNID_TYPE_ASIC_TEMP	0xC
>   
>   #define ELS_CMD_MAP_SIZE	32
> -#define ELS_COMMAND_RDP		0x18
> +#define ELS_COMMAND_RDP		ELS_RDP
> +/* Fabric Perf Impact Notification */
> +#define ELS_COMMAND_FPIN	ELS_FPIN
> +/* Read Diagnostic Functions */
> +#define ELS_COMMAND_RDF		ELS_RDF

there shouldn't be a need for a new define for these. The native ELS_xxx 
define should be used.

>   
>   /*
>    * Firmware state codes from get firmware state mailbox command
> @@ -4487,10 +4493,19 @@ struct active_regions {
>   #define QLA_SET_DATA_RATE_NOLR	1
>   #define QLA_SET_DATA_RATE_LR	2 /* Set speed and initiate LR */
>   
> +#define QLA_DEFAULT_PAYLOAD_SIZE	64
> +/*
> + * This item might be allocated with a size > sizeof(struct purex_item).
> + * The "size" variable gives the size of the payload (which
> + * is variable) starting at "iocb".
> + */
>   struct purex_item {
>   	struct list_head list;
>   	struct scsi_qla_host *vha;
> -	void (*process_item)(struct scsi_qla_host *vha, void *pkt);
> +	void (*process_item)(struct scsi_qla_host *vha,
> +			     struct purex_item *pkt);
> +	atomic_t in_use;
> +	uint16_t size;
>   	struct {
>   		uint8_t iocb[64];
>   	} iocb;
> @@ -4690,6 +4705,7 @@ typedef struct scsi_qla_host {
>   		struct list_head head;
>   		spinlock_t lock;
>   	} purex_list;
> +	struct purex_item default_item;
>   
>   	struct name_list_extended gnl;
>   	/* Count of active session/fcport */
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index f62b71e47581..54d82f7d478f 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -229,7 +229,8 @@ void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
>   int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
>   int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
>   void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
> -void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt);
> +void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
> +			       struct purex_item *pkt);
>   
>   /*
>    * Global Functions in qla_mid.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index a9e8513e1cf1..401ce0023cd5 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -31,35 +31,11 @@ const char *const port_state_str[] = {
>   	"ONLINE"
>   };
>   
> -static void qla24xx_purex_iocb(scsi_qla_host_t *vha, void *pkt,
> -	void (*process_item)(struct scsi_qla_host *vha, void *pkt))
> -{
> -	struct purex_list *list = &vha->purex_list;
> -	struct purex_item *item;
> -	ulong flags;
> -
> -	item = kzalloc(sizeof(*item), GFP_KERNEL);
> -	if (!item) {
> -		ql_log(ql_log_warn, vha, 0x5092,
> -		    ">> Failed allocate purex list item.\n");
> -		return;
> -	}
> -
> -	item->vha = vha;
> -	item->process_item = process_item;
> -	memcpy(&item->iocb, pkt, sizeof(item->iocb));
> -
> -	spin_lock_irqsave(&list->lock, flags);
> -	list_add_tail(&item->list, &list->head);
> -	spin_unlock_irqrestore(&list->lock, flags);
> -
> -	set_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags);
> -}
> -
>   static void
> -qla24xx_process_abts(struct scsi_qla_host *vha, void *pkt)
> +qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
>   {
> -	struct abts_entry_24xx *abts = pkt;
> +	struct abts_entry_24xx *abts =
> +	    (struct abts_entry_24xx *)&pkt->iocb;
>   	struct qla_hw_data *ha = vha->hw;
>   	struct els_entry_24xx *rsp_els;
>   	struct abts_entry_24xx *abts_rsp;
> @@ -790,6 +766,76 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
>   	}
>   }
>   
> +struct purex_item *
> +qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
> +{
> +	struct purex_item *item = NULL;
> +	uint8_t item_hdr_size = sizeof(*item);
> +	uint8_t default_usable = 0;
> +
> +	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> +		item = kzalloc(item_hdr_size +
> +		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> +	} else {
> +		item = kzalloc(item_hdr_size, GFP_ATOMIC);
I thought GFP_ATOMICs are looked down upon as a last resort. This is 
replacing code that used GFP_KERNEL.

> +		default_usable = 1;
> +	}
> +	if (!item) {
> +		if (default_usable &&
> +		    (atomic_inc_return(&vha->default_item.in_use) == 1)) {
> +			item = &vha->default_item;
> +			goto initialize_purex_header;
> +		}
> +		ql_log(ql_log_warn, vha, 0x5092,
> +		       ">> Failed allocate purex list item.\n");
> +
> +		return NULL;
> +	}
> +
> +initialize_purex_header:
> +	item->vha = vha;
> +	item->size = size;
> +	return item;
> +}
> +
> +static void
> +qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
> +			 void (*process_item)(struct scsi_qla_host *vha,
> +					      struct purex_item *pkt))
> +{
> +	struct purex_list *list = &vha->purex_list;
> +	ulong flags;
> +
> +	pkt->process_item = process_item;
> +
> +	spin_lock_irqsave(&list->lock, flags);
> +	list_add_tail(&pkt->list, &list->head);
> +	spin_unlock_irqrestore(&list->lock, flags);
> +
> +	set_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags);
> +}
> +
> +/**
> + * qla24xx_copy_std_pkt() - Copy over purex ELS which is
> + * contained in a single IOCB.
> + * purex packet.
> + * @vha: SCSI driver HA context
> + * @pkt: ELS packet
> + */
> +struct purex_item
> +*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
> +{
> +	struct purex_item *item;
> +
> +	item = qla24xx_alloc_purex_item(vha,
> +					QLA_DEFAULT_PAYLOAD_SIZE);
> +	if (!item)
> +		return item;
> +
> +	memcpy(&item->iocb, pkt, sizeof(item->iocb));
> +	return item;
> +}
> +
>   /**
>    * qla2x00_async_event() - Process aynchronous events.
>    * @vha: SCSI driver HA context
> @@ -3233,6 +3279,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   {
>   	struct sts_entry_24xx *pkt;
>   	struct qla_hw_data *ha = vha->hw;
> +	struct purex_item *pure_item;
>   
>   	if (!ha->flags.fw_started)
>   		return;
> @@ -3284,8 +3331,12 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   			break;
>   		case ABTS_RECV_24XX:
>   			if (qla_ini_mode_enabled(vha)) {
> -				qla24xx_purex_iocb(vha, pkt,
> -				    qla24xx_process_abts);
> +				pure_item = qla24xx_copy_std_pkt(vha, pkt);
> +				if (!pure_item)
> +					break;
> +
> +				qla24xx_queue_purex_item(vha, pure_item,
> +							 qla24xx_process_abts);
>   				break;
>   			}
>   			if (IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
> @@ -3342,7 +3393,12 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   				    purex->els_frame_payload[3]);
>   				break;
>   			}
> -			qla24xx_purex_iocb(vha, pkt, qla24xx_process_purex_rdp);
> +			pure_item = qla24xx_copy_std_pkt(vha, pkt);
> +			if (!pure_item)
> +				break;
> +
> +			qla24xx_queue_purex_item(vha, pure_item,
> +						 qla24xx_process_purex_rdp);
>   			break;
>   		}
>   		default:
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 9fd83d1bffe0..a1f899bb8c94 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -59,6 +59,7 @@ static struct rom_cmd {
>   	{ MBC_IOCB_COMMAND_A64 },
>   	{ MBC_GET_ADAPTER_LOOP_ID },
>   	{ MBC_READ_SFP },
> +	{ MBC_SET_RNID_PARAMS },
>   	{ MBC_GET_RNID_PARAMS },
>   	{ MBC_GET_SET_ZIO_THRESHOLD },
>   };
> @@ -4867,6 +4868,7 @@ qla24xx_get_port_login_templ(scsi_qla_host_t *vha, dma_addr_t buf_dma,
>   	return rval;
>   }
>   
> +#define PUREX_CMD_COUNT	2
>   int
>   qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>   {
> @@ -4875,12 +4877,12 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>   	mbx_cmd_t *mcp = &mc;
>   	uint8_t *els_cmd_map;
>   	dma_addr_t els_cmd_map_dma;
> -	uint cmd_opcode = ELS_COMMAND_RDP;
> -	uint index = cmd_opcode / 8;
> -	uint bit = cmd_opcode % 8;
> +	uint cmd_opcode[PUREX_CMD_COUNT];
> +	uint i, index, purex_bit;
>   	struct qla_hw_data *ha = vha->hw;
>   
> -	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) && !IS_QLA27XX(ha))
> +	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) &&
> +	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
>   		return QLA_SUCCESS;
>   
>   	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
> @@ -4896,7 +4898,17 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>   
>   	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
>   
> -	els_cmd_map[index] |= 1 << bit;
> +	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
> +
> +	/* List of Purex ELS */
> +	cmd_opcode[0] = ELS_COMMAND_FPIN;
> +	cmd_opcode[1] = ELS_COMMAND_RDP;
need to deal with endianness on this assigment ?   8bit values going 
into a uint ?

> +
> +	for (i = 0; i < PUREX_CMD_COUNT; i++) {
> +		index = cmd_opcode[i] / 8;
> +		purex_bit = cmd_opcode[i] % 8;
> +		els_cmd_map[index] |= 1 << purex_bit;
> +	}
>   
>   	mcp->mb[0] = MBC_SET_RNID_PARAMS;
>   	mcp->mb[1] = RNID_TYPE_ELS_CMD << 8;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 382e1f977d01..007f39128dbf 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5891,10 +5891,12 @@ qla25xx_rdp_port_speed_currently(struct qla_hw_data *ha)
>    * vha:	SCSI qla host
>    * purex: RDP request received by HBA
>    */
> -void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
> +void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
> +			       struct purex_item *item)
>   {
>   	struct qla_hw_data *ha = vha->hw;
> -	struct purex_entry_24xx *purex = pkt;
> +	struct purex_entry_24xx *purex =
> +	    (struct purex_entry_24xx *)&item->iocb;
>   	dma_addr_t rsp_els_dma;
>   	dma_addr_t rsp_payload_dma;
>   	dma_addr_t stat_dma;
> @@ -6304,6 +6306,15 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
>   		    rsp_els, rsp_els_dma);
>   }
>   
> +void
> +qla24xx_free_purex_item(struct purex_item *item)
> +{
> +	if (item == &item->vha->default_item)
> +		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
> +	else
> +		kfree(item);
> +}
> +
>   void qla24xx_process_purex_list(struct purex_list *list)
>   {
>   	struct list_head head = LIST_HEAD_INIT(head);
> @@ -6316,8 +6327,8 @@ void qla24xx_process_purex_list(struct purex_list *list)
>   
>   	list_for_each_entry_safe(item, next, &head, list) {
>   		list_del(&item->list);
> -		item->process_item(item->vha, &item->iocb);
> -		kfree(item);
> +		item->process_item(item->vha, item);
> +		qla24xx_free_purex_item(item);
>   	}
>   }
>   
> diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
> index 66318c44acd7..cb7ffc37c4f9 100644
> --- a/include/uapi/scsi/fc/fc_els.h
> +++ b/include/uapi/scsi/fc/fc_els.h
> @@ -41,6 +41,7 @@ enum fc_els_cmd {
>   	ELS_REC =	0x13,	/* read exchange concise */
>   	ELS_SRR =	0x14,	/* sequence retransmission request */
>   	ELS_FPIN =	0x16,	/* Fabric Performance Impact Notification */
> +	ELS_RDP =	0x18,	/* Read Diagnostic Parameters */
>   	ELS_RDF =	0x19,	/* Register Diagnostic Functions */
>   	ELS_PRLI =	0x20,	/* process login */
>   	ELS_PRLO =	0x21,	/* process logout */
you're missing the :
   [ELS_RDP] =    "RDP",                 \

line in the respective location of FC_ELS_CMDS_INIT

-- james

