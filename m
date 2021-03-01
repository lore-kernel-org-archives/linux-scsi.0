Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2819FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 06:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D098E64E31
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 06:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhCAGse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 01:48:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:46482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhCAGse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 01:48:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 77B1AAA4F;
        Mon,  1 Mar 2021 06:47:50 +0000 (UTC)
Subject: Re: [PATCH 06/24] mpi3mr: add support of event handling part-1
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-7-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6a41c586-b8cb-989b-f3b3-ceea9fbea968@suse.de>
Date:   Mon, 1 Mar 2021 07:47:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-7-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_DEVICE_ADDED
> MPI3_EVENT_DEVICE_INFO_CHANGED
> MPI3_EVENT_DEVICE_STATUS_CHANGE
> MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE
> MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_SAS_DISCOVERY
> MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR
> 
> Key support in this patch is device add/removal.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi/mpi30_api.h  |    2 +
>   drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 2721 ++++++++++++++++++++++++++
>   drivers/scsi/mpi3mr/mpi/mpi30_sas.h  |   46 +
>   drivers/scsi/mpi3mr/mpi3mr.h         |  195 ++
>   drivers/scsi/mpi3mr/mpi3mr_fw.c      |  177 +-
>   drivers/scsi/mpi3mr/mpi3mr_os.c      | 1452 ++++++++++++++
>   6 files changed, 4592 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
>   create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
> 
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_api.h b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
> index ca07387536d3..7bdd5aeb23be 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_api.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_api.h
> @@ -14,8 +14,10 @@
>   
>   #include "mpi30_type.h"
>   #include "mpi30_transport.h"
> +#include "mpi30_cnfg.h"
>   #include "mpi30_image.h"
>   #include "mpi30_init.h"
>   #include "mpi30_ioc.h"
> +#include "mpi30_sas.h"
>   
>   #endif  /* MPI30_API_H */
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
> new file mode 100644
> index 000000000000..3badb1bb85b1
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
> @@ -0,0 +1,2721 @@
> +/*
> + *  Copyright 2017-2020 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_cnfg.h
> + *    Description: Contains definitions for Configuration messages and pages
> + *  Creation Date: 03/15/2017
> + *        Version: 03.00.00
> + */
> +#ifndef MPI30_CNFG_H
> +#define MPI30_CNFG_H     1
> +
> +/*****************************************************************************
> + *              Configuration Page Types                                     *
> + ****************************************************************************/
> +#define MPI3_CONFIG_PAGETYPE_IO_UNIT                    (0x00)
> +#define MPI3_CONFIG_PAGETYPE_MANUFACTURING              (0x01)
> +#define MPI3_CONFIG_PAGETYPE_IOC                        (0x02)
> +#define MPI3_CONFIG_PAGETYPE_UEFI_BSD                   (0x03)
> +#define MPI3_CONFIG_PAGETYPE_SECURITY                   (0x04)
> +#define MPI3_CONFIG_PAGETYPE_ENCLOSURE                  (0x11)
> +#define MPI3_CONFIG_PAGETYPE_DEVICE                     (0x12)
> +#define MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT                (0x20)
> +#define MPI3_CONFIG_PAGETYPE_SAS_EXPANDER               (0x21)
> +#define MPI3_CONFIG_PAGETYPE_SAS_PHY                    (0x23)
> +#define MPI3_CONFIG_PAGETYPE_SAS_PORT                   (0x24)
> +#define MPI3_CONFIG_PAGETYPE_PCIE_IO_UNIT               (0x30)
> +#define MPI3_CONFIG_PAGETYPE_PCIE_SWITCH                (0x31)
> +#define MPI3_CONFIG_PAGETYPE_PCIE_LINK                  (0x33)
> +
> +/*****************************************************************************
> + *              Configuration Page Attributes                                *
> + ****************************************************************************/
> +#define MPI3_CONFIG_PAGEATTR_MASK                       (0xF0)
> +#define MPI3_CONFIG_PAGEATTR_READ_ONLY                  (0x00)
> +#define MPI3_CONFIG_PAGEATTR_CHANGEABLE                 (0x10)
> +#define MPI3_CONFIG_PAGEATTR_PERSISTENT                 (0x20)
> +
> +/*****************************************************************************
> + *              Configuration Page Actions                                   *
> + ****************************************************************************/
> +#define MPI3_CONFIG_ACTION_PAGE_HEADER                  (0x00)
> +#define MPI3_CONFIG_ACTION_READ_DEFAULT                 (0x01)
> +#define MPI3_CONFIG_ACTION_READ_CURRENT                 (0x02)
> +#define MPI3_CONFIG_ACTION_WRITE_CURRENT                (0x03)
> +#define MPI3_CONFIG_ACTION_READ_PERSISTENT              (0x04)
> +#define MPI3_CONFIG_ACTION_WRITE_PERSISTENT             (0x05)
> +
> +/*****************************************************************************
> + *              Configuration Page Addressing                                *
> + ****************************************************************************/
> +
> +/**** Device PageAddress Format ****/
> +#define MPI3_DEVICE_PGAD_FORM_MASK                      (0xF0000000)
> +#define MPI3_DEVICE_PGAD_FORM_GET_NEXT_HANDLE           (0x00000000)
> +#define MPI3_DEVICE_PGAD_FORM_HANDLE                    (0x20000000)
> +#define MPI3_DEVICE_PGAD_HANDLE_MASK                    (0x0000FFFF)
> +
> +/**** SAS Expander PageAddress Format ****/
> +#define MPI3_SAS_EXPAND_PGAD_FORM_MASK                  (0xF0000000)
> +#define MPI3_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE       (0x00000000)
> +#define MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM        (0x10000000)
> +#define MPI3_SAS_EXPAND_PGAD_FORM_HANDLE                (0x20000000)
> +#define MPI3_SAS_EXPAND_PGAD_PHYNUM_MASK                (0x00FF0000)
> +#define MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT               (16)
> +#define MPI3_SAS_EXPAND_PGAD_HANDLE_MASK                (0x0000FFFF)
> +
> +/**** SAS Phy PageAddress Format ****/
> +#define MPI3_SAS_PHY_PGAD_FORM_MASK                     (0xF0000000)
> +#define MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER               (0x00000000)
> +#define MPI3_SAS_PHY_PGAD_PHY_NUMBER_MASK               (0x000000FF)
> +
> +/**** SAS Port PageAddress Format ****/
> +#define MPI3_SASPORT_PGAD_FORM_MASK                     (0xF0000000)
> +#define MPI3_SASPORT_PGAD_FORM_GET_NEXT_PORT            (0x00000000)
> +#define MPI3_SASPORT_PGAD_FORM_PORT_NUM                 (0x10000000)
> +#define MPI3_SASPORT_PGAD_PORT_NUMBER_MASK              (0x000000FF)
> +
> +/**** Enclosure PageAddress Format ****/
> +#define MPI3_ENCLOS_PGAD_FORM_MASK                      (0xF0000000)
> +#define MPI3_ENCLOS_PGAD_FORM_GET_NEXT_HANDLE           (0x00000000)
> +#define MPI3_ENCLOS_PGAD_FORM_HANDLE                    (0x10000000)
> +#define MPI3_ENCLOS_PGAD_HANDLE_MASK                    (0x0000FFFF)
> +
> +/**** PCIe Switch PageAddress Format ****/
> +#define MPI3_PCIE_SWITCH_PGAD_FORM_MASK                 (0xF0000000)
> +#define MPI3_PCIE_SWITCH_PGAD_FORM_GET_NEXT_HANDLE      (0x00000000)
> +#define MPI3_PCIE_SWITCH_PGAD_FORM_HANDLE_PORT_NUM      (0x10000000)
> +#define MPI3_PCIE_SWITCH_PGAD_FORM_HANDLE               (0x20000000)
> +#define MPI3_PCIE_SWITCH_PGAD_PORTNUM_MASK              (0x00FF0000)
> +#define MPI3_PCIE_SWITCH_PGAD_PORTNUM_SHIFT             (16)
> +#define MPI3_PCIE_SWITCH_PGAD_HANDLE_MASK               (0x0000FFFF)
> +
> +/**** PCIe Link PageAddress Format ****/
> +#define MPI3_PCIE_LINK_PGAD_FORM_MASK                   (0xF0000000)
> +#define MPI3_PCIE_LINK_PGAD_FORM_GET_NEXT_LINK          (0x00000000)
> +#define MPI3_PCIE_LINK_PGAD_FORM_LINK_NUM               (0x10000000)
> +#define MPI3_PCIE_LINK_PGAD_LINKNUM_MASK                (0x000000FF)
> +
> +/**** Security PageAddress Format ****/
> +#define MPI3_SECURITY_PGAD_FORM_MASK                    (0xF0000000)
> +#define MPI3_SECURITY_PGAD_FORM_GET_NEXT_SLOT           (0x00000000)
> +#define MPI3_SECURITY_PGAD_FORM_SOT_NUM                 (0x10000000)
> +#define MPI3_SECURITY_PGAD_SLOT_GROUP_MASK              (0x0000FF00)
> +#define MPI3_SECURITY_PGAD_SLOT_MASK                    (0x000000FF)
> +
> +/*****************************************************************************
> + *              Configuration Request Message                                *
> + ****************************************************************************/
> +typedef struct _MPI3_CONFIG_REQUEST {
> +    U16             HostTag;                            /* 0x00 */
> +    U8              IOCUseOnly02;                       /* 0x02 */
> +    U8              Function;                           /* 0x03 */
> +    U16             IOCUseOnly04;                       /* 0x04 */
> +    U8              IOCUseOnly06;                       /* 0x06 */
> +    U8              MsgFlags;                           /* 0x07 */
> +    U16             ChangeCount;                        /* 0x08 */
> +    U16             Reserved0A;                         /* 0x0A */
> +    U8              PageVersion;                        /* 0x0C */
> +    U8              PageNumber;                         /* 0x0D */
> +    U8              PageType;                           /* 0x0E */
> +    U8              Action;                             /* 0x0F */
> +    U32             PageAddress;                        /* 0x10 */
> +    U16             PageLength;                         /* 0x14 */
> +    U16             Reserved16;                         /* 0x16 */
> +    U32             Reserved18[2];                      /* 0x18 */
> +    MPI3_SGE_UNION  SGL;                                /* 0x20 */
> +} MPI3_CONFIG_REQUEST, MPI3_POINTER PTR_MPI3_CONFIG_REQUEST,
> +  Mpi3ConfigRequest_t, MPI3_POINTER pMpi3ConfigRequest_t;
> +
Can you please restrict yourself to _one_ set of codingstyle?
IE please keep your typedefs to all caps, or mixed caps.
But having both is just silly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
