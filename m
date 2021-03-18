Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510A7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E7864F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhCRQCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:02:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:44254 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhCRQBl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 12:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616083300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ak1Dnze0OD2HIbJOAlkDG1LpMyZ/MtTgWniysNjZd5I=;
        b=SSdHf6NNTmiO6D+90zyFceQxe/Fq9PcX29uo/6ggMvbkxq21Vz++uVx60XLbX3sEsX1bes
        OYHs0ftQxeOUY+/oqSm2kn+P8c3rV9bUYUdsLUXD57L/Jo+xNpUn/tMjA3spal3xTcX1Fk
        B1L2gZ46gJH7m4xQPol3IZ1ik459mJI=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-vNGFLnhTMU6HcvWtixexow-1; Thu, 18 Mar 2021 17:01:38 +0100
X-MC-Unique: vNGFLnhTMU6HcvWtixexow-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsHVK/h8sZBuEWM0XevoVdA19c9wnbC6yVcgIj8cAQWJO2cBfLSNYZPWZyDrwxsnJzK+LXceBqm/DNOmqkqopDtNt89ERf3Tyq869uaAn6RwcUz0NW7voKsq3PyQaU2msasBM2LTdh1pPTXGnshSQ38RbEzpmKnCmGBjYJ1egwzZ0xhszl1UVg+HWFM7i7qRGeBVc4kbomsGdzsuyVuPyRaI6jyNqPKmosrfwwivQgm+ag5Mv8Fku+OXtMyXRoxwRAcRSpefNCnp5qyM6QEyxFb/TLX3yQ0fz8o2RKj9Lc6nlTF5xnmbuKmuPJ9bx18J9+fdGIoSCy4XEI5hGBT3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ak1Dnze0OD2HIbJOAlkDG1LpMyZ/MtTgWniysNjZd5I=;
 b=e1ci0ssGh/4LJ+P2/ik+bhtbNmRaURigjFFRjy85WOf6CogS1npAgFnWXub4UambUBVda7tNf7qc48l1OaOofH1Yuh9i9Aeh0LTS9LGBMxrt5Sg89M0xIe0gzzXDe4w3n4xZkpXojAMDPsxhravPlRmP8tYH9gv3iuCvJdDlqOUFo6HrFQJzNDLqdREfPskN6Jm7RcZWXhb83hJEBaXrYV/ZBfqk6rycwbdw4k27IQL31E3rFDnvxk9i0Tc5qpZweq1qz2v0lescnWnFeUn39n8CtyVO3V2V9h70mfvLRZ5q+X6sdIFg8wXmP1UnX/85Bs77g7EIvTTN+5LGkGCMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7926.eurprd04.prod.outlook.com (2603:10a6:20b:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 16:01:37 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 16:01:37 +0000
Subject: Re: [PATCH v2 3/6] qla2xxx: Fix endianness annotations
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-4-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <2d895f9d-e567-3148-27ad-a1e13fff942b@suse.com>
Date:   Thu, 18 Mar 2021 09:01:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210318032840.7611-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR05CA0015.eurprd05.prod.outlook.com (2603:10a6:205::28)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR05CA0015.eurprd05.prod.outlook.com (2603:10a6:205::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 16:01:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f1a72df-eaa3-45f6-8c74-08d8ea271c02
X-MS-TrafficTypeDiagnostic: AS8PR04MB7926:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7926FDC9A8102528353ECA4CDA699@AS8PR04MB7926.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:240;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ve/5L8a5xRCjuNOyi0HaYhgTW92joH1wr5irZyHVgfxd4PG2eiNuOK1gn0Lbk/LiN/MSu+ZbAWFM57o1RANnHcsqR0lf9+XKY+PjrruwGK2r75H96h7+Z5NTdW2eOQHZFPcw/oo5Cm3teT72doFNnQIfOs/89H1DbinNk3zCUc3FpwbKAe/Hha0bcoPkUSVyDg7pwWZjcOm7bGU1GXNf+9p+Q2dHoOu907Zg48vSAC81wivKKVd9joMlSK4EGyOTBOklgedsM1fPtbEQsL/R9VVqCpxTMRJAkaYDdg5O7QWCb/D3KIvUjoXDHpOuKkwR1VtEgojYTUlyEYYZ+8kPngNr0UPKGZIMrFhFr7di+ExC5sM0UGwosF8D2glsPvYZG36n+QJVu7VR/yULfUUjLkREo1UcxDk37miRZs4yV2gf5BLMnuwlsKFQ2GczknCJ3eXk9vyaj7uYgl3nuOHNbsF4WtnT6onAEOYrgqYOOIq0t4ieW4plGHQ4+c3bA3u+SmZHDBK4RexfWoBtBe5qh6zSSdYgwKAhNZkscyU9bvJ1VQP3BQIMII3LtpJVfHjy/sIfn6Wlqfrx85mZhp6SHF0oqkl6yL19OeRfwVJ5wozCdXcWVNd/TufvKaiucoACYQG4bNCDFeCkPmh40bkGvXi6Q5YZ1nF6YIfNm49vNF0OTaoqIVshthvNjearOip
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(376002)(366004)(346002)(956004)(66946007)(478600001)(6666004)(52116002)(8936002)(66556008)(66476007)(8676002)(2906002)(2616005)(31686004)(83380400001)(54906003)(110136005)(5660300002)(38100700001)(4326008)(16526019)(16576012)(316002)(31696002)(26005)(36756003)(6486002)(86362001)(53546011)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WnFqRHlPa2NsQVlBRmJ4RDhvTmluU0s4L09FQUg2YzYvN09vU0hyUkpaRkdX?=
 =?utf-8?B?VEZRblhwMm9KcWhPeC9CZTZjb2hwRTFTakdWcUVnbFczZEhBdUNEeWRsREtN?=
 =?utf-8?B?NGd3M25zRDROdmZMTFR4TjI5Y2xrMTJ2UThEVEkyT1BpMS9CN1BaUTdSU0Qr?=
 =?utf-8?B?K2JsZ2pPWFJUMHFDWlE3NDhqSk5rM2YydDFqSm5STDRlZW0wUEp5K0lKSWxx?=
 =?utf-8?B?ZkZGSmk2OEQyLy85cUdnMlA1b210cHcyWTc0V2lsTjFpNVMyUzdOQ0g3dW5H?=
 =?utf-8?B?VEZPZFBEeGg2UG1MU2R6WWZjRUtnVzJOdW8wc0MwOGdEbTYvTHlnb0o5YlRT?=
 =?utf-8?B?QVYyTDFCQldacm9hVUYrQ3NHUDNETE51NWxwemhPQ3N1eUZBbmJPd1lpL3FL?=
 =?utf-8?B?QmtlajN0YW9iQ3YvQzc2enhjY0VBaFFyWU00TkdTaHpuaTNZNGZHSCthWkhT?=
 =?utf-8?B?VGEwYXhCcXZNalBBOVBPYmRxdFU5NkdJRVdQOUNlOTQrMUFWTW1YMURhdW1v?=
 =?utf-8?B?NlVDT2FsN0phMUI3YkZlMWVZN0xqa1lWUEhSd254Um1CNTU5Tm9IZHR0b25B?=
 =?utf-8?B?ZVFnVHJ0OFoxeWF3c0E5NXF0eFYzZFdjMFNjWTgyYmUwYnBTSDNzVkc4ckg0?=
 =?utf-8?B?blFJdGFqMmRBNDU3dExNa09Zd0FwMmwzcWR6WFlYcTVnemZYanZGN0k5R0ZG?=
 =?utf-8?B?K1pqa3h5emRzaUJYZGkvVnZEZHB6VUtHTERxSWIvRytqWmovWlRxOWpjcGFG?=
 =?utf-8?B?RE9kc2hRSDZySU82SU9CRFlpcmV2dkc4clNNdW9qbE5IUEJRbU5YdVZsNFUw?=
 =?utf-8?B?aU83emtvbWtWOC9YTXlPTXhBTTFzbjFVOHNlcXdmNkhSVVdaNkJ0M0t3clhF?=
 =?utf-8?B?cEpJSEpMWHQ1Z2FSWGprOXl4aExtckhOaE52Tzlka3oyK09BVm5PdkwyRVpt?=
 =?utf-8?B?V1VYeklJNG8xWlRqbEdGaGFENCs0d2VIU2ZyN1dUdVE5YUtqdEgxeHFQdE5v?=
 =?utf-8?B?amlpWENnOTFIanRvT1Q3Y2IvRjVyTE1LZUZ1QXI1eUJqZnFjeG5IS0tZNllj?=
 =?utf-8?B?TXpnNFNoaTBzTVJTSXptVXNXbnBCOER0TVJkWUhLOFY1Nkd4TTFHQ3UxOFFQ?=
 =?utf-8?B?T29rRUxtUEE0dG1PMHNPV0d6ckRFcGNwR0VkY3k2SlZsbitnZmJLa2pqTnlS?=
 =?utf-8?B?RzNNeEI5ZldzQUMzMnNEYTd2eHVxWmdUamhVUGE4RjZQazd6b0VrcmEvYjRR?=
 =?utf-8?B?TU1BZnJySXg1K2cwREdEOEQrTnhaMnJJU0pUdkMwN2dFOXhKZ3BKTzl0SU1t?=
 =?utf-8?B?VlN4NmhvTVlwemZMVTY2Tm02ak9CYjMzVkJyc0hKZVJWblBESXVSeGc5K2NF?=
 =?utf-8?B?WC9EZjVZenNTcEQwZkZ1dHVqM2pHNWNQa0pPa05ycnNmN0tTVFNOOVNpYUNo?=
 =?utf-8?B?OXhqTjB6V08yaEpKT3FQMlFQTEY5dlVsMStzQ1JSRkNMNkdRejcwWG5Sb3ZQ?=
 =?utf-8?B?enJRRWdFMDNYMXEvM2l2aDU5WXdhb2I0YzdReDUxWWw4UlpWUkxFY0R6aFMw?=
 =?utf-8?B?eFR3b3A2ejhUenN2STlpUGpXeUszYlg0cDRuaGJ4bnpEUTE3NzdHeHRoMFFq?=
 =?utf-8?B?cStudFBvbTVqMHNJRFRVVmtRUGR6YkF1bnYvWURhWlhDdG80Wk85SHU0eHJh?=
 =?utf-8?B?TGJ4cEZJcTZ6NHdsakJ4UTdtU3pMM2ptM2s3U0daSGVZZVRRRXpkbEJNZkhM?=
 =?utf-8?Q?W80Q77hm/q3gcW1gOUK9+/qMd2oB77KontOBdD/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1a72df-eaa3-45f6-8c74-08d8ea271c02
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 16:01:36.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WE5UwcMTYr4F10Deo6QJWZ33NAW6gXviLnTrX1WD9ZrTwHP8epG8oaL44pMMxEm74RqpO/F6hkGpOx4Hy1KaIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7926
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 8:28 PM, Bart Van Assche wrote:
> Fix all recently introduced endianness annotation issues.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  | 2 +-
>  drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
>  drivers/scsi/qla2xxx/qla_isr.c  | 2 +-
>  drivers/scsi/qla2xxx/qla_sup.c  | 9 +++++----
>  4 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 3bdf55bb0833..52ba75591f9a 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -1527,7 +1527,7 @@ struct init_sf_cb {
>  	 * BIT_12 = Remote Write Optimization (1 - Enabled, 0 - Disabled)
>  	 * BIT 11-0 = Reserved
>  	 */
> -	uint16_t flags;
> +	__le16	flags;
>  	uint8_t	reserved1[32];
>  	uint16_t discard_OHRB_timeout_value;
>  	uint16_t remote_write_opt_queue_num;
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 8b41cbaf8535..eb2376b138c1 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2379,7 +2379,8 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24xx *logio)
>  				cpu_to_le32(NVME_PRLI_SP_FIRST_BURST);
>  		if (sp->vha->flags.nvme2_enabled) {
>  			/* Set service parameter BIT_7 for NVME CONF support */
> -			logio->io_parameter[0] |= NVME_PRLI_SP_CONF;
> +			logio->io_parameter[0] |=
> +				cpu_to_le32(NVME_PRLI_SP_CONF);
>  			/* Set service parameter BIT_8 for SLER support */
>  			logio->io_parameter[0] |=
>  				cpu_to_le32(NVME_PRLI_SP_SLER);
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 27165abda96d..0fa7082f3cc8 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3440,7 +3440,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>  		return;
>  
>  	abt = &sp->u.iocb_cmd;
> -	abt->u.abt.comp_status = le16_to_cpu(pkt->comp_status);
> +	abt->u.abt.comp_status = pkt->comp_status;
>  	orig_sp = sp->cmd_sp;
>  	/* Need to pass original sp */
>  	if (orig_sp)
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
> index f771fabcba59..060c89237777 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -2621,10 +2621,11 @@ qla24xx_read_optrom_data(struct scsi_qla_host *vha, void *buf,
>  }
>  
>  static int
> -qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, uint32_t *buf,
> +qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, __le32 *buf,
>      uint32_t len, uint32_t buf_size_without_sfub, uint8_t *sfub_buf)
>  {
> -	uint32_t *p, check_sum = 0;
> +	uint32_t check_sum = 0;
> +	__le32 *p;
>  	int i;
>  
>  	p = buf + buf_size_without_sfub;
> @@ -2790,8 +2791,8 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
>  			goto done;
>  		}
>  
> -		rval = qla28xx_extract_sfub_and_verify(vha, dwptr, dwords,
> -			buf_size_without_sfub, (uint8_t *)sfub);
> +		rval = qla28xx_extract_sfub_and_verify(vha, (__le32 *)dwptr,
> +			dwords, buf_size_without_sfub, (uint8_t *)sfub);
>  
>  		if (rval != QLA_SUCCESS)
>  			goto done;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

