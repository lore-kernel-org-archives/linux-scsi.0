Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC508C433B4
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 16:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B8A613B7
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 16:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241858AbhDEQAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:00:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:52211 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238034AbhDEQAu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2021 12:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617638443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ugopBBjfFhoeAdMH5lfdZM28qRuut0h0oFk8HjyftXg=;
        b=gRJMMmWmrUQiOz5hlz60ZWgvJW1Yo4RLWNJi91ts5jSm5BrmwsfLji3IQ9szrqKy3grS+A
        ebHseQbAI0JLpdSmPm5qmKWQNZhoHHpcAKd//5feXVeHRyYihIjKVy/8Ro4RNTBAZh9e4m
        1T88jLiai9Py8cRmaDDUpVZNrqKyIkg=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2058.outbound.protection.outlook.com [104.47.5.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-3-ME_lVj1HPXiXypMfvRequA-1;
 Mon, 05 Apr 2021 18:00:32 +0200
X-MC-Unique: ME_lVj1HPXiXypMfvRequA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QttWqD9xB3Ki7XZhrotMD5kSiSYRaeiMc83zglyikj4N9P2an47KtIGV5Z+Qz+7GZzvfa7Ye7yMJCD9HdiIiBBgx/8Bkkpa1ea4lO+XDhRLwAFJ3f5Oo4+64qQbbRBKbXIbt4YR8OY6ifxD/x2fsr2i+YiRTDIStx+zu9VYI9Xks9Qi9YUFNBX5Xdsn3cESlMywTnFJ+tmOJhkA5PdaUrGTJO81I7TBTlUVjHxN2Z8mDjbym/57ajNmODimtkAA1oP9FV2IsNSeRV9Cu/aSqDJZ58740Jg2swOVA4YG8ptEhj8e6TzR9GSpIxz2U2aiYP5FqKZVtDohyMaL0yAhxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugopBBjfFhoeAdMH5lfdZM28qRuut0h0oFk8HjyftXg=;
 b=dhAWEHdPpsx2jcDqhktDyc08/EavjERbScEPwj7WlD/IWfK/wq3NErhQYOCC7RyvJfj8fIFehmvpqX/4PHNNYA85drNS81E+un4jFRKnxzZMbj2ePHnZi+UnTGN06/ODzXy4QbfBb84uLzHC/5BGf/bRG90bj7vm7f7PrRIduPuYBUJTPv6ZeMjiuOy82sT2CE1JvIz3hhY96bmnZw4S0WFHRamB294vOOvzqMfUJHl6stwA/oB+AhQe6os+FKTMQSuU98qcPkjbiHIF0OiHJWiBW+NnQicdr3kId0hy2Q3UK5PsiAYCW2mWUYZ9t73uDhILCtaZRsli0E/L8nXe5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB7061.eurprd04.prod.outlook.com (2603:10a6:20b:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 16:00:30 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:00:30 +0000
Subject: Re: [PATCH 01/40] scsi: iscsi: fix shost->max_id use
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210403232333.212927-1-michael.christie@oracle.com>
 <20210403232333.212927-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <6e6bf918-1dfc-055a-b81c-e50fade1c144@suse.com>
Date:   Mon, 5 Apr 2021 09:00:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210403232333.212927-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::26) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 16:00:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1485089-c160-4f01-4696-08d8f84bef68
X-MS-TrafficTypeDiagnostic: AM7PR04MB7061:
X-Microsoft-Antispam-PRVS: <AM7PR04MB7061DCA607928BF7F0F20137DA779@AM7PR04MB7061.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFtSSuCnTOJlrWYNujGCFVa4UPnI1WtXiSQCg50LMQCdC6INTOkRZIsGJhGk9L4Tx59n31Gqncr/LuNk4/jKWwQgTmpIgxq2tC5Q2BLCboKN3Ck04kC5HQwULDtlaZSri8ttjvM81tZv01//kJ0rEZfzzS/MiZXEjNfabPJ7+G2AY+PkU3C04TiMF1DEZ/3AHO7r93Cr4+koi8eVpZDzSPkVJiKKvnf3ADLdX8dDpzT5LIs/vG8EZBk88IzjGWGMmpZ20C49GFG+XRwOJzSD1pgRBos3wTQZBBLR2V1gzdTmDtJEZlr55kZE6TF7Wux0QMykACQlcMwRKx97sR6mrkU0ErgnV38DaNoOwJfHOngUXng0kclgOAOAV5LaBgGqTNGYBNCYo1jGbubv6NIHXUN/BjFTjOU56VPD3021le9TRvyiYrjAeOv/WKrqxhyaAE01OGoRX7WCMukUqARksfGU3nbvXkAEbUJ/p6zYFw38yGiD13Eg8Dprypv9RH46gB63IlV4hrUHoVsXmiA2MCbjXldZ98hle5fWfbircMXiLAHRieJMoO4stuhSuHzNdFxamJj823e5yLwQbQ0iEkOJ1OsawLaQut9zdDp10wqIca9/ZNwjinp8DQzwPKbzROVGC5PfkcgZh9DeCZm3g1aFQq/Xlcf9T440WJRCiLzydSq+LDiuwSKiwfy9KGXNJM3RbWAz4mdjb7wf/rI0lHPlxlAZWiks/DwCF/VLqTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(366004)(396003)(83380400001)(38100700001)(53546011)(86362001)(26005)(6486002)(6666004)(7416002)(66946007)(921005)(31686004)(66476007)(316002)(66556008)(16576012)(52116002)(186003)(8936002)(956004)(478600001)(2906002)(31696002)(5660300002)(36756003)(2616005)(8676002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UGtSdTFBTnBNK3lHQ1EzR0VGU1JrMnQrQVdjMFQyNUpQSWU5QVNIUFFRNngw?=
 =?utf-8?B?OW9GK1NLTzB1Wm1QclNnejcxblo4SXJCK3hOQWRLQllyb2cxdmpIMGZiNGVp?=
 =?utf-8?B?T29BUTZtTlNKN2FoZ2l1K1d5YkNrS1J6c3RoYzB1VzhZL2lCZjdJUlZkazlM?=
 =?utf-8?B?Y3lTUGV0TjVqUWg0RGVCVDg4akNzYTdzN256aTJTYUtFSHJWcHF2cTd2YzBJ?=
 =?utf-8?B?MUN4K1dzbjNVSUY1VzhhaSs2aXkyOE85ZHlRMXlMc1VSSHJRR2JTTnYzWWow?=
 =?utf-8?B?NERNekx6NW1xV2VKQjZEbm9iVTZTdmRvWlV6UGU5Vk5MajdqbWg3dmVXMmV3?=
 =?utf-8?B?bU9qSDNoc2s0SFcyY1VnVlFHRlBJY3pjblhqSlhPV0JHN3hGV08zOEMzczlB?=
 =?utf-8?B?aXBkV3pZeXI1VTFIMG5neVByWkdzU3BOQWpRNHUxb3QvQmZqb1ExR1lHR3Jn?=
 =?utf-8?B?VWxidm1LUHhHaTJpYkl3T0ErZVZGR3llWEdkM2I4VWxqeFI3eDhHMlIvZHhY?=
 =?utf-8?B?aGJzaUd0dVFSSktmRTUyZmtmS1E0STB1eUxleFZFbjZqU3NDMEdtRUpPNkl3?=
 =?utf-8?B?NkhUQVFtUnJFN3h4VUhvRjVCM0ZveWYzazAya2ZZTW1YQzZYTXJiSXFhZVdL?=
 =?utf-8?B?WGFFbXhRd0JvZ3dQYUhqcHdwYjhCM0tQVFFESDVycWtKMVhIVlBFQnJOcm53?=
 =?utf-8?B?R2VSNnEwblliUFZQOURSTFR4SlE3RzRzZkhzKzNSVEx1QXVRRkZBczFZYnJw?=
 =?utf-8?B?MFlaR2FHTDNBdnpJYXBSb25DTU5lbUljT1V1WDVBdkl4RnZhREd4aVRZaGdF?=
 =?utf-8?B?RHRoekgwK2Y5bjc1Zmw4Tm40Q0JvazlrM3RrZ1gvUlJuYVp0Z1kvWTVibGt5?=
 =?utf-8?B?aGVlMkoydFlpRytkNy9LRWhHNlJSUmFTdVRyMDFRa0UvSmU0R1VRWlg2dk1x?=
 =?utf-8?B?TzBiSDVadThSRUdyZlBZZGFqT0FRaHBTMjBnU01GaTc5N25XbjFNOE1ETW56?=
 =?utf-8?B?MkNJS0xTZ2RFM1FwVXJVeTExaXU2ZkxJLzZJeE5jVjdkTy83bG9CbWkwVzJm?=
 =?utf-8?B?U3U0Sm5nVFJFTGxhQ1pVZC92dkx5eTlFaVNpK3VaRlNYVnBYcmJvcWhRQjdX?=
 =?utf-8?B?cnA2K2xXUHRUUGUyMnVNMm1sSkxWQXhFVG03QWFOa1FxNE54R0REMmFyZ2tp?=
 =?utf-8?B?cGk0eXRCNWVERURYT3ZZTExCTXhuU0x3NXBvQ2g3Rk5xK05zTmpabGMrRFpH?=
 =?utf-8?B?VnBJMWpDVmhBOWNTUjFoekRqZWN3bjFxblhONW1YckZLWFE0czBDUXljMksr?=
 =?utf-8?B?dS9yVXZxSGQ4ZDM2VFlyeVpJUzdxbVo4bDZyVURHU0k0S2JvN0JUcjQxNXRy?=
 =?utf-8?B?ZWQrZldUM1lpa1lHR1dqbmM2S1pGcUFoWDdhSzAyVXRKMmtPVWlRV0JXazB3?=
 =?utf-8?B?UklxRHh3ZUVMZ2RXK2cvQ2ZCVENDTzNhOENyMXZkRU1wd3kzNDJWd0U1emYy?=
 =?utf-8?B?RlJ2cVQ2MVZWSVJPUEV2dnNxSWJ5NDUrcmRPNGhRUDRoaVBJb1IvbXdLQ2dE?=
 =?utf-8?B?S25ybDNrbUZSWEJCNkEwdUsvcTBxQkw1V3R3WjRiSWpxamJqRmNvMzgrcktz?=
 =?utf-8?B?WW12N05FbVc1RVBoR0tEMnJsVWlQRXlTUGI5bG5sL0VBUGp1VjkvNDRlOFNJ?=
 =?utf-8?B?MjlhRDd2QlNzMWxtL1RwSGpKcyt1TG1IT29UZUQ5ZnNlMmRPT0FZbHJIcTlr?=
 =?utf-8?Q?OIW7nKeUDWciys+h6nNr5rQ8dfHnqAwF8ojGSeJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1485089-c160-4f01-4696-08d8f84bef68
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 16:00:29.8497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/hvb0ve2iCClzIkjng8Hm2/otCuvj3SzLmLoMbxfWm1CZoJpYzsiFzc6GPMKHCuNh75hJ6CwRW7AgzEJGY7Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7061
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/21 4:22 PM, Mike Christie wrote:
> The iscsi offload drivers are setting the shost->max_id to the max number
> of sessions they support. The problem is that max_id is not the max number
> of targets but the highest identifier the targets can have. To use it to
> limit the number of targets we need to set it to max sessions - 1, or we
> can end up with a session we might not have preallocated resources for.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c  | 4 ++--
>  drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
>  drivers/scsi/cxgbi/libcxgbi.c    | 4 ++--
>  drivers/scsi/qedi/qedi_main.c    | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 90fcddb76f46..56bd4441a789 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -416,7 +416,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
>  			"beiscsi_hba_alloc - iscsi_host_alloc failed\n");
>  		return NULL;
>  	}
> -	shost->max_id = BE2_MAX_SESSIONS;
> +	shost->max_id = BE2_MAX_SESSIONS - 1;
>  	shost->max_channel = 0;
>  	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
>  	shost->max_lun = BEISCSI_NUM_MAX_LUN;
> @@ -5318,7 +5318,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
>  	/* Re-enable UER. If different TPE occurs then it is recoverable. */
>  	beiscsi_set_uer_feature(phba);
>  
> -	phba->shost->max_id = phba->params.cxns_per_ctrl;
> +	phba->shost->max_id = phba->params.cxns_per_ctrl - 1;
>  	phba->shost->can_queue = phba->params.ios_per_ctrl;
>  	ret = beiscsi_init_port(phba);
>  	if (ret < 0) {
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 1e6d8f62ea3c..37f5b719050e 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -791,7 +791,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
>  		return NULL;
>  	shost->dma_boundary = cnic->pcidev->dma_mask;
>  	shost->transportt = bnx2i_scsi_xport_template;
> -	shost->max_id = ISCSI_MAX_CONNS_PER_HBA;
> +	shost->max_id = ISCSI_MAX_CONNS_PER_HBA - 1;
>  	shost->max_channel = 0;
>  	shost->max_lun = 512;
>  	shost->max_cmd_len = 16;
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index f078b3c4e083..ecb134b4699f 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -337,7 +337,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
>  EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
>  
>  int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
> -		unsigned int max_id, struct scsi_host_template *sht,
> +		unsigned int max_conns, struct scsi_host_template *sht,
>  		struct scsi_transport_template *stt)
>  {
>  	struct cxgbi_hba *chba;
> @@ -357,7 +357,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
>  
>  		shost->transportt = stt;
>  		shost->max_lun = max_lun;
> -		shost->max_id = max_id;
> +		shost->max_id = max_conns - 1;
>  		shost->max_channel = 0;
>  		shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>  
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 47ad64b06623..0aa0061dad40 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -642,7 +642,7 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
>  		goto exit_setup_shost;
>  	}
>  
> -	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA;
> +	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA - 1;
>  	shost->max_channel = 0;
>  	shost->max_lun = ~0;
>  	shost->max_cmd_len = 16;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

