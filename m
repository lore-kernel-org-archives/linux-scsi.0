Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349E0C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED181222C4
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgKPHtk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:49:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:51860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbgKPHtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:49:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 86E0BAC55;
        Mon, 16 Nov 2020 07:49:38 +0000 (UTC)
Subject: Re: [PATCH v4 06/19] lpfc: vmid: Supplementary data structures for
 vmid
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-7-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <76f3ed8a-64d9-7847-4510-33b43d1ab2d5@suse.de>
Date:   Mon, 16 Nov 2020 08:49:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-7-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch adds additional data structures for supporting the two
> versions of vmid implementation. First type uses app header while the
> other types uses priority tagging mechanism. These data structures
> are used mostly for ELS and CT commands for the two vmid implementation.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v4:
> No change
> 
> v3:
> No change
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> ---
>   drivers/scsi/lpfc/lpfc_disc.h |   1 +
>   drivers/scsi/lpfc/lpfc_hw.h   | 124 ++++++++++++++++++++++++++++++++--
>   drivers/scsi/lpfc/lpfc_sli.h  |   8 +++
>   3 files changed, 129 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
> index 482e4a888dae..c38313ee17dd 100644
> --- a/drivers/scsi/lpfc/lpfc_disc.h
> +++ b/drivers/scsi/lpfc/lpfc_disc.h
> @@ -113,6 +113,7 @@ struct lpfc_nodelist {
>   	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
>   #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
>   	u8		nlp_nvme_info;	        /* NVME NSLER Support */
> +	u8		vmid_support;		/* destination VMID support */
>   #define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
>   
>   	uint16_t        nlp_usg_map;	/* ndlp management usage bitmap */
> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
> index c20034b3101c..c6b252fbea40 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h
> @@ -275,6 +275,7 @@ struct lpfc_sli_ct_request {
>   #define  SLI_CT_ACCESS_DENIED             0x10
>   #define  SLI_CT_INVALID_PORT_ID           0x11
>   #define  SLI_CT_DATABASE_EMPTY            0x12
> +#define  SLI_CT_APP_ID_NOT_AVAILABLE      0x40
>   
>   /*
>    * Name Server Command Codes
> @@ -400,16 +401,16 @@ struct csp {
>   	uint16_t altBbCredit:1;	/* FC Word 1, bit 27 */
>   	uint16_t edtovResolution:1;	/* FC Word 1, bit 26 */
>   	uint16_t multicast:1;	/* FC Word 1, bit 25 */
> -	uint16_t broadcast:1;	/* FC Word 1, bit 24 */
> +	u16 app_hdr_support:1;	/* FC Word 1, bit 24 */
>   

Please stick with the current naming scheme, ie make this 'uint16_t'.

> -	uint16_t huntgroup:1;	/* FC Word 1, bit 23 */
> +	uint16_t priority_tagging:1;	/* FC Word 1, bit 23 */
>   	uint16_t simplex:1;	/* FC Word 1, bit 22 */
>   	uint16_t word1Reserved1:3;	/* FC Word 1, bit 21:19 */
>   	uint16_t dhd:1;		/* FC Word 1, bit 18 */
>   	uint16_t contIncSeqCnt:1;	/* FC Word 1, bit 17 */
>   	uint16_t payloadlength:1;	/* FC Word 1, bit 16 */
>   #else	/*  __LITTLE_ENDIAN_BITFIELD */
> -	uint16_t broadcast:1;	/* FC Word 1, bit 24 */
> +	u16 app_hdr_support:1;	/* FC Word 1, bit 24 */

See above, please use uint16_t.

>   	uint16_t multicast:1;	/* FC Word 1, bit 25 */
>   	uint16_t edtovResolution:1;	/* FC Word 1, bit 26 */
>   	uint16_t altBbCredit:1;	/* FC Word 1, bit 27 */
> @@ -423,7 +424,7 @@ struct csp {
>   	uint16_t dhd:1;		/* FC Word 1, bit 18 */
>   	uint16_t word1Reserved1:3;	/* FC Word 1, bit 21:19 */
>   	uint16_t simplex:1;	/* FC Word 1, bit 22 */
> -	uint16_t huntgroup:1;	/* FC Word 1, bit 23 */
> +	uint16_t priority_tagging:1;	/* FC Word 1, bit 23 */
>   #endif
>   
>   	uint8_t bbRcvSizeMsb;	/* Upper nibble is reserved */
> @@ -607,6 +608,8 @@ struct fc_vft_header {
>   #define ELS_CMD_LIRR      0x7A000000
>   #define ELS_CMD_LCB	  0x81000000
>   #define ELS_CMD_FPIN	  0x16000000
> +#define ELS_CMD_QFPA      0xB0000000
> +#define ELS_CMD_UVEM      0xB1000000
>   #else	/*  __LITTLE_ENDIAN_BITFIELD */
>   #define ELS_CMD_MASK      0xffff
>   #define ELS_RSP_MASK      0xff
> @@ -649,6 +652,8 @@ struct fc_vft_header {
>   #define ELS_CMD_LIRR      0x7A
>   #define ELS_CMD_LCB	  0x81
>   #define ELS_CMD_FPIN	  ELS_FPIN
> +#define ELS_CMD_QFPA      0xB0
> +#define ELS_CMD_UVEM      0xB1
>   #endif
>   
>   /*
> @@ -1317,6 +1322,117 @@ struct fc_rdp_res_frame {
>   };
>   
>   
> +/* UVEM */
> +
> +#define LPFC_UVEM_SIZE 60
> +#define LPFC_UVEM_VEM_ID_DESC_SIZE 16
> +#define LPFC_UVEM_VE_MAP_DESC_SIZE 20
> +
> +#define VEM_ID_DESC_TAG  0x0001000A
> +struct lpfc_vem_id_desc {
> +	u32 tag;
> +	u32 length;
> +	u8 vem_id[16];
> +};
> +
> +#define LPFC_QFPA_SIZE	4
> +
> +#define INSTANTIATED_VE_DESC_TAG  0x0001000B
> +struct instantiated_ve_desc {
> +	u32 tag;
> +	u32 length;
> +	u8 global_vem_id[16];
> +	u32 word6;
> +#define lpfc_instantiated_local_id_SHIFT   0
> +#define lpfc_instantiated_local_id_MASK    0x000000ff
> +#define lpfc_instantiated_local_id_WORD    word6
> +#define lpfc_instantiated_nport_id_SHIFT   8
> +#define lpfc_instantiated_nport_id_MASK    0x00ffffff
> +#define lpfc_instantiated_nport_id_WORD    word6
> +};
> +
> +#define DEINSTANTIATED_VE_DESC_TAG  0x0001000C
> +struct deinstantiated_ve_desc {
> +	u32 tag;
> +	u32 length;
> +	u8 global_vem_id[16];
> +	u32 word6;
> +#define lpfc_deinstantiated_nport_id_SHIFT   0
> +#define lpfc_deinstantiated_nport_id_MASK    0x000000ff
> +#define lpfc_deinstantiated_nport_id_WORD    word6
> +#define lpfc_deinstantiated_local_id_SHIFT   24
> +#define lpfc_deinstantiated_local_id_MASK    0x00ffffff
> +#define lpfc_deinstantiated_local_id_WORD    word6
> +};
> +
> +/* Query Fabric Priority Allocation Response */
> +#define LPFC_PRIORITY_RANGE_DESC_SIZE 12
> +
> +struct priority_range_desc {
> +	u32 tag;
> +	u32 length;
> +	u8 lo_range;
> +	u8 hi_range;
> +	u8 qos_priority;
> +	u8 local_ve_id;
> +};
> +
> +struct fc_qfpa_res {
> +	u32 reply_sequence;	/* LS_ACC or LS_RJT */
> +	u32 length;	/* FC Word 1    */
> +	struct priority_range_desc desc[1];
> +};
> +
> +/* Application Server command code */
> +/* VMID               */
> +
> +#define SLI_CT_APP_SEV_Subtypes     0x20	/* Application Server subtype */
> +
> +#define SLI_CTAS_GAPPIA_ENT    0x0100	/* Get Application Identifier */
> +#define SLI_CTAS_GALLAPPIA     0x0101	/* Get All Application Identifier */
> +#define SLI_CTAS_GALLAPPIA_ID  0x0102	/* Get All Application Identifier */
> +					/* for Nport */
> +#define SLI_CTAS_GAPPIA_IDAPP  0x0103	/* Get Application Identifier */
> +					/* for Nport */
> +#define SLI_CTAS_RAPP_IDENT    0x0200	/* Register Application Identifier */
> +#define SLI_CTAS_DAPP_IDENT    0x0300	/* Deregister Application */
> +					/* Identifier */
> +#define SLI_CTAS_DALLAPP_ID    0x0301	/* Deregister All Application */
> +					/* Identifier */
> +
> +struct entity_id_object {
> +	u8 entity_id_len;
> +	u8 entity_id[255];	/* VM UUID */
> +};
> +
> +struct app_id_object {
> +	u32 port_id;
> +	u32 app_id;
> +	struct entity_id_object obj;
> +};
> +
> +struct lpfc_vmid_rapp_ident_list {
> +	u32 no_of_objects;
> +	struct entity_id_object obj[1];
> +};
> +
> +struct lpfc_vmid_dapp_ident_list {
> +	u32 no_of_objects;
> +	struct entity_id_object obj[1];
> +};
> +
> +#define GALLAPPIA_ID_LAST  0x80
> +struct lpfc_vmid_gallapp_ident_list {
> +	u8 control;
> +	u8 reserved[3];
> +	struct app_id_object app_id;
> +};
> +

Please use 'uint8_t' etc instead of 'u8' to be consistent with the other 
definitions in this file.

> +#define RAPP_IDENT_OFFSET  (offsetof(struct lpfc_sli_ct_request, un) + 4)
> +#define DAPP_IDENT_OFFSET  (offsetof(struct lpfc_sli_ct_request, un) + 4)
> +#define GALLAPPIA_ID_SIZE  (offsetof(struct lpfc_sli_ct_request, un) + 4)
> +#define DALLAPP_ID_SIZE    (offsetof(struct lpfc_sli_ct_request, un) + 4)
> +
>   /******** FDMI ********/
>   
>   /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
> diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
> index 93d976ea8c5d..6dd45885df4f 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.h
> +++ b/drivers/scsi/lpfc/lpfc_sli.h
> @@ -35,6 +35,12 @@ typedef enum _lpfc_ctx_cmd {
>   	LPFC_CTX_HOST
>   } lpfc_ctx_cmd;
>   
> +union lpfc_vmid_iocb_tag {
> +	u32 app_id;
> +	u8 cs_ctl_vmid;
> +	struct lpfc_vmid_context *vmid_context;	/* UVEM context information */
> +};
> +

Here, too; please use uint32_t and uint8_t to be consistent.

>   struct lpfc_cq_event {
>   	struct list_head list;
>   	uint16_t hdwq;
> @@ -100,6 +106,7 @@ struct lpfc_iocbq {
>   #define LPFC_IO_NVME	        0x200000 /* NVME FCP command */
>   #define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
>   #define LPFC_IO_NVMET		0x800000 /* NVMET command */
> +#define LPFC_IO_VMID            0x1000000 /* VMID tagged IO */
>   
>   	uint32_t drvrTimeout;	/* driver timeout in seconds */
>   	struct lpfc_vport *vport;/* virtual port pointer */
> @@ -114,6 +121,7 @@ struct lpfc_iocbq {
>   		struct lpfc_node_rrq *rrq;
>   	} context_un;
>   
> +	union lpfc_vmid_iocb_tag vmid_tag;
>   	void (*fabric_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
>   			   struct lpfc_iocbq *);
>   	void (*wait_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
