Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7D5C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 22:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED1F206D4
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 22:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HBaeOoaH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEOWso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 18:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgEOWso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 18:48:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D674C061A0C
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 15:48:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e1so5243644wrt.5
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 15:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5qyosFY75+DOqbHJ6H79ALhgXXofxRn1k3NRs2xIrY4=;
        b=HBaeOoaHJz52uwREteg55I46N0V/O3xWZfLp23YJJIpTtCuQ0qYOSmkhDjMn2G3IdN
         RxngrivO5DqXqUnzwoC0zQuNo8D9Up4w3GOAB3nKCfl1he1y+VaKgyy3z/gKQgrjM6xv
         LsswFcE9vze6rqzVvoS8RXrFhuEyxAJsNDkoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5qyosFY75+DOqbHJ6H79ALhgXXofxRn1k3NRs2xIrY4=;
        b=BHdJOi5LLdp1bSBlhlFaFQBC0Ani1bglhHZsW87gtj7P4Wa8+u6cWFgsGwJwfT6fDC
         TP3OKSePlT3ILcB1uoh5bc3LNoe0bEaehjsnnR1KDmaVKOxzdXeAY3cKpQ6WMUotXbim
         HAGeqx+MlO48Sou2pVjHeIbfVANumgOHwkgb0KXKxr7rhI6gBftoHCUJcXLaU8WIyHIm
         UzgIUAYxv5qYT14AGcWfjOmugglFmbl2SVrrgPKW8APJluSyDIn7UACEJzyvGmDS0P96
         5fJn/qK2lC7grsJWUkgNPVaau/ZRMJ9DBi0bgH7edFzXiIC+7oAv9K7/cnH/i3SZ0W/5
         uUQg==
X-Gm-Message-State: AOAM530mcHIDVfbfsCF25vkx3byHBIy2zAke5s8JB6XN/wZTO8lLf+3Q
        IlNUW3TqbVb5iIbG4RuA8Ge9uQ==
X-Google-Smtp-Source: ABdhPJykpM6gBwvKCD2+M6bhT/aeHhGr1T0N7oGfzZwfi5cosu+ya7JajmAA3mx1J5MU1wMVszOxGA==
X-Received: by 2002:a5d:4043:: with SMTP id w3mr6618561wrp.368.1589582922593;
        Fri, 15 May 2020 15:48:42 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y4sm5668076wro.91.2020.05.15.15.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 15:48:41 -0700 (PDT)
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-3-njavali@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <927c2cbd-682f-a80e-bd2e-2e5bd012ab2d@broadcom.com>
Date:   Fri, 15 May 2020 15:48:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514101026.10040-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/2020 3:10 AM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
>
> * Firmware Initialization with SCM enabled based on NVRAM setting and
>    firmware support (About Firmware).
> * Enable PUREX and add support for fabric performance impact
>    notification(FPIN) handling.
> * Support for the following FPIN descriptors:
>    	1. Link Integrity Notification.
> 	2. Delivery Notification.
> 	3. Peer Congestion Notification.
> 	4. Congestion Notification.
> * Mark a device as slow when a Peer Congestion Notification is received.
> * Allocate a default purex item for each vha, to handle memory
>    allocation failures in ISR.

In general, there's a lot of generic things here that are done in 
driver-specific manners.

All the FPIN statistics should be added to the scsi fc transport objects 
and transport routines created to parse the fpin payloads and set 
statistics.  Also, statistics can be reported via sysfs on the transport 
object rather than creating vendor-specific bsg requests to obtain them.

In line with this - FPIN definitions should use the existing the 
existing common headers in include/uapi/fc/fc_els.h.  The file doesn't 
have the congestion fpin definitions, so rather than putting in a driver 
header - put the structure definitions in the common header.


>
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.h  | 115 +++++++
>   drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
>   drivers/scsi/qla2xxx/qla_def.h  |  89 ++++++
>   drivers/scsi/qla2xxx/qla_fw.h   |   7 +-
>   drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
>   drivers/scsi/qla2xxx/qla_init.c |   9 +-
>   drivers/scsi/qla2xxx/qla_isr.c  | 532 ++++++++++++++++++++++++++++++--
>   drivers/scsi/qla2xxx/qla_mbx.c  |  45 ++-
>   drivers/scsi/qla2xxx/qla_os.c   |  18 ++
>   9 files changed, 795 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
> index 7594fad7b5b5..0b308859047c 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -290,4 +290,119 @@ struct qla_active_regions {
>   	uint8_t reserved[32];
>   } __packed;
>   
> +#define SCM_LINK_EVENT_UNKNOWN			0x0
> +#define SCM_LINK_EVENT_LINK_FAILURE			0x1
> +#define SCM_LINK_EVENT_LOSS_OF_SYNC			0x2
> +#define SCM_LINK_EVENT_LOSS_OF_SIGNAL		0x3
> +#define SCM_LINK_EVENT_PRIMITIVE_SEQ_PROTOCOL_ERROR	0x4
> +#define SCM_LINK_EVENT_INVALID_TX_WORD		0x5
> +#define SCM_LINK_EVENT_INVALID_CRC			0x6
> +#define SCM_LINK_EVENT_DEVICE_SPECIFIC		0xF
> +#define SCM_LINK_EVENT_V1_SIZE			20

These should be the existing defines in the common fc_els.h header. Also 
make sure SCM_LINK_EVENT_V1_SIZE is actually used.

> +struct qla_scm_link_event {
> +	uint64_t	timestamp;
> +	uint16_t	event_type;
> +	uint16_t	event_modifier;
> +	uint32_t	event_threshold;
> +	uint32_t	event_count;
> +	uint8_t		reserved[12];
> +} __packed;
> +
> +#define SCM_DELIVERY_REASON_UNKNOWN		0x0
> +#define SCM_DELIVERY_REASON_TIMEOUT		0x1
> +#define SCM_DELIVERY_REASON_UNABLE_TO_ROUTE	0x2
> +#define SCM_DELIVERY_REASON_DEVICE_SPECIFIC	0xF
> +struct qla_scm_delivery_event {
> +	uint64_t	timestamp;
> +	uint32_t	delivery_reason;
> +	uint8_t		deliver_frame_hdr[24];
> +	uint8_t		reserved[28];
> +
> +} __packed;
> +
> +#define SCM_CONGESTION_EVENT_CLEAR		0x0
> +#define SCM_CONGESTION_EVENT_LOST_CREDIT	0x1
> +#define SCM_CONGESTION_EVENT_CREDIT_STALL	0x2
> +#define SCM_CONGESTION_EVENT_OVERSUBSCRIPTION	0x3
> +#define SCM_CONGESTION_EVENT_DEVICE_SPECIFIC	0xF
> +struct qla_scm_peer_congestion_event {
> +	uint64_t	timestamp;
> +	uint16_t	event_type;
> +	uint16_t	event_modifier;
> +	uint32_t	event_period;
> +	uint8_t		reserved[16];
> +} __packed;
> +
> +#define SCM_CONGESTION_SEVERITY_WARNING	0xF1
> +#define SCM_CONGESTION_SEVERITY_ERROR	0xF7
> +struct qla_scm_congestion_event {
> +	uint64_t	timestamp;
> +	uint16_t	event_type;
> +	uint16_t	event_modifier;
> +	uint32_t	event_period;
> +	uint8_t		severity;
> +	uint8_t		reserved[15];
> +} __packed;

I expect many of these defines also should map to std-defined defines, 
thus should be added to fc_els.h


> +
> +#define SCM_FLAG_RDF_REJECT		0x00
> +#define SCM_FLAG_RDF_COMPLETED		0x01
> +#define SCM_FLAG_BROCADE_CONNECTED	0x02
> +#define SCM_FLAG_CISCO_CONNECTED	0x04
> +
> +#define SCM_STATE_CONGESTION	0x1
> +#define SCM_STATE_DELIVERY		0x2
> +#define SCM_STATE_LINK_INTEGRITY	0x4
> +#define SCM_STATE_PEER_CONGESTION	0x8
> +
> +#define QLA_CON_PRIMITIVE_RECEIVED	0x1
> +#define QLA_CONGESTION_ARB_WARNING	0x1
> +#define QLA_CONGESTION_ARB_ALARM	0X2
> +struct qla_scm_port {
> +	uint32_t			current_events;
> +
> +	struct qla_scm_link_event	link_integrity;
> +	struct qla_scm_delivery_event	delivery;
> +	struct qla_scm_congestion_event	congestion;
> +	uint64_t			scm_congestion_alarm;
> +	uint64_t			scm_congestion_warning;
> +	uint8_t				scm_fabric_connection_flags;
> +	uint8_t				reserved[43];
> +} __packed;
> +
> +struct qla_scm_target {
> +	uint8_t		wwpn[8];
> +	uint32_t	current_events;
> +
> +	struct qla_scm_link_event		link_integrity;
> +	struct qla_scm_delivery_event		delivery;
> +	struct qla_scm_peer_congestion_event	peer_congestion;
> +
> +	uint32_t	link_failure_count;
> +	uint32_t	loss_of_sync_count;
> +	uint32_t        loss_of_signals_count;
> +	uint32_t        primitive_seq_protocol_err_count;
> +	uint32_t        invalid_transmission_word_count;
> +	uint32_t        invalid_crc_count;
> +
> +	uint32_t        delivery_failure_unknown;
> +	uint32_t        delivery_timeout;
> +	uint32_t        delivery_unable_to_route;
> +	uint32_t        delivery_failure_device_specific;
> +
> +	uint32_t        peer_congestion_clear;
> +	uint32_t        peer_congestion_lost_credit;
> +	uint32_t        peer_congestion_credit_stall;
> +	uint32_t        peer_congestion_oversubscription;
> +	uint32_t        peer_congestion_device_specific;
> +	uint32_t	link_unknown_event;
> +	uint32_t	link_device_specific_event;
> +	uint8_t		reserved[48];
> +} __packed;
> +

Q: what purpose are these shorter "meta" event structures serving ? Why 
hold onto (what I assume is) the last event.  Wouldn't something 
monitoring netlink and use of the existing fc_host_fpin_rcv() interface 
be enough ? it should see all events.


>   
> +#define SCM_EDC_ACC_RECEIVED		BIT_6
> +#define SCM_RDF_ACC_RECEIVED		BIT_7
> +#define SCM_NOTIFICATION_TYPE_LINK_INTEGRITY	0x00020001
> +#define SCM_NOTIFICATION_TYPE_DELIVERY		0x00020002
> +#define SCM_NOTIFICATION_TYPE_PEER_CONGESTION	0x00020003
> +#define SCM_NOTIFICATION_TYPE_CONGESTION	0x00020004
> +#define FPIN_DESCRIPTOR_HEADER_SIZE	4
> +#define FPIN_ELS_DESCRIPTOR_LIST_OFFSET	8
> +struct fpin_descriptor {
> +	__be32 descriptor_tag;
> +	__be32 descriptor_length;
> +	union {
> +		uint8_t common_detecting_port_name[WWN_SIZE];
> +		struct {
> +			uint8_t detecting_port_name[WWN_SIZE];
> +			uint8_t attached_port_name[WWN_SIZE];
> +			__be16 event_type;
> +			__be16 event_modifier;
> +			__be32 event_threshold;
> +			__be32 event_count;
> +			__be32 port_name_count;
> +			uint8_t port_name_list[1][WWN_SIZE];
> +		} link_integrity;
> +		struct {
> +			uint8_t detecting_port_name[WWN_SIZE];
> +			uint8_t attached_port_name[WWN_SIZE];
> +			__be32 delivery_reason_code;
> +		} delivery;
> +		struct {
> +			uint8_t detecting_port_name[WWN_SIZE];
> +			uint8_t attached_port_name[WWN_SIZE];
> +			__be16 event_type;
> +			__be16 event_modifier;
> +			__be32 event_period;
> +			__be32 port_name_count;
> +			uint8_t port_name_list[1][WWN_SIZE];
> +		} peer_congestion;
> +		struct {
> +			__be16 event_type;
> +			__be16 event_modifier;
> +			__be32 event_period;
> +			uint8_t severity;
> +			uint8_t reserved[3];
> +		} congestion;
> +	};
> +};

The fpin descriptor is already in the common fc_els.h header. Use it.  
And feel free to extend the common header definitions for the 
congestion/delivery events.


>   
> +void
> +qla_link_integrity_tgt_stats_update(struct fpin_descriptor *fpin_desc,
> +				    fc_port_t *fcport)
> +{
> +	ql_log(ql_log_info, fcport->vha, 0x502d,
> +	       "Link Integrity Event Type %d for Port %8phN\n",
> +	       be16_to_cpu(fpin_desc->link_integrity.event_type),
> +	       fcport->port_name);
> +
> +	fcport->scm_stats.link_integrity.event_type =
> +	    be16_to_cpu(fpin_desc->link_integrity.event_type);
> +	fcport->scm_stats.link_integrity.event_modifier =
> +	    be16_to_cpu(fpin_desc->link_integrity.event_modifier);
> +	fcport->scm_stats.link_integrity.event_threshold =
> +	    be32_to_cpu(fpin_desc->link_integrity.event_threshold);
> +	fcport->scm_stats.link_integrity.event_count =
> +	    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +	fcport->scm_stats.link_integrity.timestamp = ktime_get_real_seconds();
> +
> +	fcport->scm_stats.current_events |= SCM_STATE_LINK_INTEGRITY;
> +	switch (be16_to_cpu(fpin_desc->link_integrity.event_type)) {
> +	case SCM_LINK_EVENT_UNKNOWN:
> +		fcport->scm_stats.link_unknown_event +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_LINK_FAILURE:
> +		fcport->scm_stats.link_failure_count +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_LOSS_OF_SYNC:
> +		fcport->scm_stats.loss_of_sync_count +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_LOSS_OF_SIGNAL:
> +		fcport->scm_stats.loss_of_signals_count +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_PRIMITIVE_SEQ_PROTOCOL_ERROR:
> +		fcport->scm_stats.primitive_seq_protocol_err_count +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_INVALID_TX_WORD:
> +		fcport->scm_stats.invalid_transmission_word_count +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_INVALID_CRC:
> +		fcport->scm_stats.invalid_crc_count +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	case SCM_LINK_EVENT_DEVICE_SPECIFIC:
> +		fcport->scm_stats.link_device_specific_event +=
> +		    be32_to_cpu(fpin_desc->link_integrity.event_count);
> +		break;
> +	}
> +}
> +

A prime example of a routine that should be put into the fc transport 
and a list of statistics that should be visible via sysfs on the 
transport host (aka port) object.


> +void
> +qla_scm_process_link_integrity_d(struct scsi_qla_host *vha,
> +				 struct fpin_descriptor *fpin_desc)
> +{
> ...
> +}
> +
> +void
> +qla_delivery_tgt_stats_update(struct fpin_descriptor *fpin_desc,
> +			      fc_port_t *fcport)
> +{
> ...
> +}
> +
> +/*
> + * Process Delivery Notification Descriptor
> + */
> +void
> +qla_scm_process_delivery_notification_d(struct scsi_qla_host *vha,
> +					struct fpin_descriptor *fpin_desc)
> +{
> ...
> +}
> +
> ...
> +
> +void
> +qla_peer_congestion_tgt_stats_update(struct fpin_descriptor *fpin_desc,
> +				     fc_port_t *fcport)
> +{
> ...
> +}
> +
> +/*
> + * Process Peer-Congestion Notification Descriptor
> + */
> +void
> +qla_scm_process_peer_congestion_notification_d(struct scsi_qla_host *vha,
> +					struct fpin_descriptor *fpin_desc)
> +{
> ...
> +}
> +
> +/*
> + * qla_scm_process_congestion_notification_d() - Process
> + * Process Congestion Notification Descriptor
> + * @rsp: response queue
> + * @pkt: Entry pointer
> + */
> +void
> +qla_scm_process_congestion_notification_d(struct scsi_qla_host *vha,
> +					  struct fpin_descriptor *fpin_desc)
> ...
> +}

Same comment as prior - should be in scsi fc transport routines and 
stats set on appropriate transport object

-- james

