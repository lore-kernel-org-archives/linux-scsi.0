Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B162C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AA7964E6B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhCRQDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:03:38 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:41034 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230338AbhCRQDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 12:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616083393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=guTcoJAc+wZwgUtGs11HqaPU4PocbGkwri+umSp3VT4=;
        b=D+qHGvCVmAru96LgWNQ5SfaKpMLL9sIoF5kI+Hl4YOXTiCM/gGQ97C8TT9jjOFgaW/Mn6u
        Abo3IW8OaevgLJ4GVPFBA+JGjTQGpxZIHoSsOs3JKaAx+M78Ts10UGpcACRhhbZx28sJCt
        YImM+uflY33C+IC6zwlFxELH6cMHmBs=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-Q9Unh3oXOHiqrDcvR7qlUA-1; Thu, 18 Mar 2021 17:03:12 +0100
X-MC-Unique: Q9Unh3oXOHiqrDcvR7qlUA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFRHwhVYCemarieqx4yD2z0xygO+KSrFMDLltb+PuLJcgbSld4ME2TQTuUG88A9EwOAy7i4/+7CSC/UWN9qukgLfgI52h4TMYzE8VVZ8F7a1AT5I1Z4UUGPf8rF7qMa65SDw9TKT9iGwLSDCQC1cYfxLXiL0axgX2gZNITwSozGndVHTjEIBYyQ4Sb/uCVyAhwV4dHfJyjzuJER4GcK/WNnoXwezE/POO0JoTKlGWmSDKCL2xlL77BUTZ3Cbxhy2WGkWx2Y0CdN5ejkVeuU4ZxkbHGimXQbo8yI1T/8zOL9hVR2eDjzfgvQobv8nkaEw2voUMw7mhFsVkXcFCTLtGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guTcoJAc+wZwgUtGs11HqaPU4PocbGkwri+umSp3VT4=;
 b=gUsXNb4GNnIjQenrfjpTvXucXrMZpKsUf45HfqyScWgDOPLjd9svZThP/tTJpEzBfvpwCuLXvaGZOcBikV9yLHIO8q/mjnZ7t+/6ftEnlvyxw8BaH/qpfc5JQHI4XfOT3yOtMC2y6pqHHgLixCDYbRYK5Ekyerr/dyGwR+p//a5+6K9EdsivYWgCFnwkzuRtv6ARFAB89/t2nyCBSVPnDQA6QscSkOmPkEWzeMfG6OdAI73n9vunZPMwOPj0X4TO4LMoxt5BnpgYrVV7XuUHFaYNQhHND8RYnB1oq1tXn3PuDwnSNlHIWcXzivqqTCxV2WI+up/tacU0NS3IQ6qtAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4072.eurprd04.prod.outlook.com (2603:10a6:209:4d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 16:03:10 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 16:03:10 +0000
Subject: Re: [PATCH v2 5/6] qla2xxx: Simplify
 qla8044_minidump_process_control()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-6-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <7db3f9d2-e18d-cb0e-0366-79e2645a12af@suse.com>
Date:   Thu, 18 Mar 2021 09:03:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210318032840.7611-6-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: GV0P278CA0088.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2b::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by GV0P278CA0088.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2b::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 16:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e136f331-5df4-4e0d-9141-08d8ea2753de
X-MS-TrafficTypeDiagnostic: AM6PR04MB4072:
X-Microsoft-Antispam-PRVS: <AM6PR04MB40721189F5C4800EC0F2C6D2DA699@AM6PR04MB4072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIy7dPHLOxqmTrgJU9JaTWdaM9yGnOZF7uhHAJHITPV+eFopAwUkckKxWgL6t4VmshpkBoH9KDUUHVEom50+j6Ap00PmDUrBfbHOsIRE5s1d6tbN7X1/Ir9/lh0BjPbdsDiaEPlDIxVdl8ad1uqR6MfD+L2rvdxSmvHTJjrwQbOsyV+Uoq79AzD4pTNUxa+001QeeughrDQ8/IV3XK8vhtanAXYOmp5/JSPaey17xcHcbSpser3Rya6gvgrR2XtafchWXDZVHOxwniFNmppSamBrbPvI5XgqbVErWyibSXVOguiZFqiJToTqnUkAoPIt4C2Xf/zh6Hr3C7V//gYugUKO/UwPNJnt2otEVc9whrvkNH6oEpJnpyqXKTm/h+gdUnwbyTbNXZC1uqJsH/pDQUz7naKeLeFvx6MT4qmEprMa8c9uHQvcaeu7fwNgiOZtGbNOVNomj+/c2oLUlWt/fcDfgOzU9QHKnPQGvEBNRCmE0WzxQ8lEJUe1Cgf3C0sqoDdB+RzTjzppXeVzg/GIB2OssHdmcef0AbBTkkV+IaGkCuDHtV2A+5GQI0aEWt1mrsvWYoAqlrvxtDjY4cI63oaPvHxms2UUhXWWUfpNZPSC1TY3rFUIrMl/LYEfxvjV7zev7B8pNm4ywVe19XUJVKxYAM4GaFf2sblaVblmnf5fPqvd/x9nslTwlDTCHOn0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(366004)(376002)(346002)(136003)(31696002)(66476007)(31686004)(316002)(5660300002)(52116002)(36756003)(16576012)(110136005)(6486002)(478600001)(66556008)(66946007)(54906003)(38100700001)(956004)(8676002)(8936002)(186003)(16526019)(26005)(86362001)(4326008)(6666004)(83380400001)(2906002)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aS9KSFhKRDE5YkZTeHk2RFFZQ3kzc25mMnY4a1gvMFlhYWsvRVlZZkxLOW1G?=
 =?utf-8?B?Q2RWM3QrNnFNSFlWQnAwbm4yQ1R4V09MNkF3ZEt4dmFBNEloaW81SHVhLzJU?=
 =?utf-8?B?R1FPS051OFpYWGVkeGxqSUFod3RFbFFSeGhFR2RVaExiNyt3eHUra295SnZp?=
 =?utf-8?B?bUVxa09TSWFuYlZFOGZQZ1dXOTdUNUt2UHJmanRBTXNtZ3hEZWp5WGNFNXJt?=
 =?utf-8?B?UFE3SXVlNm5wZWJpMGtWMUliSHM1QzZMQ1dWc05pL2JDM1pOWjAwQVlic09v?=
 =?utf-8?B?ODhQVFpsSmgwaVVhYkJHc25qSjJXK1JRblRKeVdVM3ZsR20wV0tQTkE4Ujdz?=
 =?utf-8?B?MUVpZkR6eUdqQWxwdkdzeGxIRzlBTklGUUFYMlZpYWd6TDRLdkJGWmt0ekdm?=
 =?utf-8?B?OCtTNGg2MWFET3RPMStuZkJ6MHVPcDRpUm9wZ3l6VVFsOUVpeWlaZHNTaG1J?=
 =?utf-8?B?TVFKM3JRb2VVSnN6U2tBcFIvUERDdHYyankrSG9vYlo0cjVCb2tna205bjdk?=
 =?utf-8?B?ME1BeFUzbVQrdkszQVNwR3RmdGxsbkI1Z29HK0x0MkgxOUh2ZEFCdnBENHVI?=
 =?utf-8?B?aklwYm5QWUhySkdIWVZuWkcxTFYyQTRUTk1sajk5NWF3Z0EyREZKdDVhbTlp?=
 =?utf-8?B?c0NVNWJpUE05UHpFL3UvcEhrU25tTjZVclJUbkpDSy9pWEw4emdELzhoUXc5?=
 =?utf-8?B?NFlxT2IwdnY1em0ySFhrSlllQ1FrVFFvVkFjWEQ2dmxEZkJjTWFNMjhZOWtD?=
 =?utf-8?B?TkJxWmVwTWhUVjllOE9DK3lWdHhIbWQwd1FsK1dIRXZFaTlVU3RtcVI5TEtI?=
 =?utf-8?B?aS8wL04vd091ZDNwdGtZcXhLb25aMXB0K1pOK3h0QTNEeGRzenB2MXc3Y1hJ?=
 =?utf-8?B?NGRjK3dha0RLOGdraUpFWjJGZ2ZHbU1LNXNyc2VKUWlLcENyM2pmQUxTalBp?=
 =?utf-8?B?ZlpwSmtCeWZnWk1MSFZucVh4T00vcml1UEZSZkFFYk1xQlN4S05uUkhvMGJz?=
 =?utf-8?B?Z1RtR2hzcVNPRlpCTm9KVVoybXZ5em40bUNMeEd3dVR5R2RQdmc1cjlLVDR1?=
 =?utf-8?B?aGhZMDlRRzZ2ZEZJOHp6aVVpQ2c0QUViZG9QeWVUaHhFQjdYZHpjekhFajRM?=
 =?utf-8?B?aU9manFzVkozN1dUdG5CZ0lyVGRVbFVYWmJUcUgwSENtQllDVmcrYmxXUVA2?=
 =?utf-8?B?SWZRellJZS9wMGpuekxOMzB2OVFReS9PQkFKUXpVRytEeGdDNzVjUTR4cXBW?=
 =?utf-8?B?ajNhdUJZbWllTG5zc29LK2JCRGlFWEUyL0dqem1NeFpBNG5GWC8vL1Z0aG9P?=
 =?utf-8?B?SjdvMUpSV0RrQXJURW95K1ptY0QxeEU2U3hLMzA2cTh5cDgwWmxxRWlMV1Nu?=
 =?utf-8?B?OUhXNm4ybTBRTG1rMmRhUXh2QmRWTk0xcUp2eEJoMHJ2NHB2NnBZQm9JNUdx?=
 =?utf-8?B?d1RwcWkwWjREb2JuUmlpa2tGYUxrMWdVbFhYeEVzSlM4Yk9EOHdHdk5uVmdL?=
 =?utf-8?B?V2M2SGhJbUREcWh0OU5BcWhOWXMycGJCSHcvNVdnVGhUcm5XWVQyaWhIcUhG?=
 =?utf-8?B?N1BobGFQdFE0NHNiMk9vMzMvRVNRb1VjZXNrUEtmU0IxSS8zRk5tREQrN2lw?=
 =?utf-8?B?c05OWWVraEMwRUtOT29hQXRlYXFOZUFQQXBuYTd6RnBRbStKYTV2U1dwSnFo?=
 =?utf-8?B?QTQ3aGQzK3FXTWYyUzdoZmZWeDBVMk5xRENGbFF2RWN1TVFLWXhaalpQb2o5?=
 =?utf-8?Q?inmlSlwN9c4Cxo+NMNcMvXKuQsgl7ISpASxGCoO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e136f331-5df4-4e0d-9141-08d8ea2753de
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 16:03:10.6083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3ntzQGpxyrrfRvfpEuOeJdg6rQ16gRVOTcs8KADJc9qWUAwjz+ruOjKLxTut175DEZ/5Y1Gs15RA0AcRhr8Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 8:28 PM, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint:
> 
>     CID 177490 (#1 of 1): Unused value (UNUSED_VALUE)
>     assigned_value: Assigning value from opcode & 0xffffff7fU to opcode
>     here, but that stored value is overwritten before it can be used.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_nx2.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
> index 68a16c95dcb7..792c55fcec8c 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -2226,19 +2226,16 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
>  		if (opcode & QLA82XX_DBG_OPCODE_WR) {
>  			qla8044_wr_reg_indirect(vha, crb_addr,
>  			    crb_entry->value_1);
> -			opcode &= ~QLA82XX_DBG_OPCODE_WR;
>  		}
>  
>  		if (opcode & QLA82XX_DBG_OPCODE_RW) {
>  			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
>  			qla8044_wr_reg_indirect(vha, crb_addr, read_value);
> -			opcode &= ~QLA82XX_DBG_OPCODE_RW;
>  		}
>  
>  		if (opcode & QLA82XX_DBG_OPCODE_AND) {
>  			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
>  			read_value &= crb_entry->value_2;
> -			opcode &= ~QLA82XX_DBG_OPCODE_AND;
>  			if (opcode & QLA82XX_DBG_OPCODE_OR) {
>  				read_value |= crb_entry->value_3;
>  				opcode &= ~QLA82XX_DBG_OPCODE_OR;
> @@ -2249,7 +2246,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
>  			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
>  			read_value |= crb_entry->value_3;
>  			qla8044_wr_reg_indirect(vha, crb_addr, read_value);
> -			opcode &= ~QLA82XX_DBG_OPCODE_OR;
>  		}
>  		if (opcode & QLA82XX_DBG_OPCODE_POLL) {
>  			poll_time = crb_entry->crb_strd.poll_timeout;
> @@ -2269,7 +2265,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
>  					    crb_addr, &read_value);
>  				}
>  			} while (1);
> -			opcode &= ~QLA82XX_DBG_OPCODE_POLL;
>  		}
>  
>  		if (opcode & QLA82XX_DBG_OPCODE_RDSTATE) {
> @@ -2283,7 +2278,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
>  			qla8044_rd_reg_indirect(vha, addr, &read_value);
>  			index = crb_entry->crb_ctrl.state_index_v;
>  			tmplt_hdr->saved_state_array[index] = read_value;
> -			opcode &= ~QLA82XX_DBG_OPCODE_RDSTATE;
>  		}
>  
>  		if (opcode & QLA82XX_DBG_OPCODE_WRSTATE) {
> @@ -2303,7 +2297,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
>  			}
>  
>  			qla8044_wr_reg_indirect(vha, addr, read_value);
> -			opcode &= ~QLA82XX_DBG_OPCODE_WRSTATE;
>  		}
>  
>  		if (opcode & QLA82XX_DBG_OPCODE_MDSTATE) {
> @@ -2316,7 +2309,6 @@ qla8044_minidump_process_control(struct scsi_qla_host *vha,
>  			read_value |= crb_entry->value_3;
>  			read_value += crb_entry->value_1;
>  			tmplt_hdr->saved_state_array[index] = read_value;
> -			opcode &= ~QLA82XX_DBG_OPCODE_MDSTATE;
>  		}
>  		crb_addr += crb_entry->crb_strd.addr_stride;
>  	}
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

