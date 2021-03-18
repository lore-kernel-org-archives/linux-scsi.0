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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E84C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EC364E37
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhCRQBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:01:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:29302 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230465AbhCRQBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 12:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616083282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pbpJwkMEC49gX6BLRabOgREJfVjm9yWc4m7pAJVCUro=;
        b=QY3ksqWXIm4qXuoxiEBqNnmUnQacKImFxusdmqOx8fWuAQTeOJFSte3uFeSrurq9YBALWR
        lWqrUaNQNN3Y21YlXpxth03RoOt/JXskUPpIGBpkaEmai/g8JCPzNdy0aOOrQEIu9nMvbS
        1xvboFJmOIYLr9OcOpqP/BaCp51RGGs=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2054.outbound.protection.outlook.com [104.47.1.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-7GB_KOE4NvOQ-LbHjv_Pfw-1; Thu, 18 Mar 2021 17:01:21 +0100
X-MC-Unique: 7GB_KOE4NvOQ-LbHjv_Pfw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7xLkqb1EmTWhtWpC2XDdZ4LfbqjRi4E8V5SZ7r/m+oTPdAf+vP7UQNXhK4lf7Zgcxc7SqslYCt3ZQz0hrsD4kFgjLGrR5bqOpanWvLXh4hWuufXuJ4hAdH13StR7WMkS9qMWdBXZuXoO2sPEPx7LWTGY2c3ocCD1WVNVA31a19/cBveSpB0lNHGQLZRZM0hQEIUpHyxdfuKkDXTSWD+0rW2P43Enfn6vCDDsjBi1WDfSSBOry9A/qs+5QWPcFQySscEgPdeO8W9HMfUyVqrZnUPo6dxthp9ua9wzJ5j2Q6eigoiwaozdA7puyUdvQLH6VpBo8kwjr2Y/Zkm+HlOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbpJwkMEC49gX6BLRabOgREJfVjm9yWc4m7pAJVCUro=;
 b=A26uCTNvv/fIsUngqsHVWL0tTpbbJbiLKuVUg6l6KTpZYPnEAhCx578Y88s/ldnXH0r5Z5CyhjLSxR5C7j8+KyapfUgdgD85mzo7z7BxGkazV1KuZuLnL4eiWRG8BI9u/uvBYt6Ll5Tp2L9sKJBhhckYT3SRAWipicOJaw0YDQwpoLMEZd90YRGJbfEWvtz+c7iOvheJUFrKoeC40fqy4LZvUzVhZCR71D7SDamb7xXITy/kpYII5xnnH+BBtI4skWEghe19sTlR2EDtQ3MZkCF+gLiw9mgSDzcZ/e/IxmgXgqG1ZUD52yhr3rQlKR7gNUSX6LXAVEebkH4QgxDTCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 16:01:19 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 16:01:18 +0000
Subject: Re: [PATCH v2 2/6] qla2xxx: Constify struct qla_tgt_func_tmpl
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-3-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <1521d778-1612-30fb-713e-9b9d71d0f878@suse.com>
Date:   Thu, 18 Mar 2021 09:01:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210318032840.7611-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR05CA0036.eurprd05.prod.outlook.com (2603:10a6:205::49)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR05CA0036.eurprd05.prod.outlook.com (2603:10a6:205::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 16:01:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cf807bb-214f-45e9-632c-08d8ea271109
X-MS-TrafficTypeDiagnostic: AS8PR04MB7815:
X-Microsoft-Antispam-PRVS: <AS8PR04MB78156A5411BFFD51564023B7DA699@AS8PR04MB7815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwhKBn8VYNyvnoYBrj/4kwOfjmh34pFbnaIBDFXrnY4ACN00XvRPg7CEsSIR3hjK/YGnTMe1HleRNco5AgZhrX7sg34EBNrvS9A083WN9i6rYfMQ5Csow50GRnx2Q26KtgfVmV9wBneAjvo7KgAPq2lmI4rO70732a9M1TISWsV7zGHTbnx/hLthldJcq3b8mGacBDx+og4WrC518UyoPY6vTR/qHal4lXkNVpUZrXNEf1WScGXW+4ZRzbKVHluEi4UuZawdUZGg3J17P4s+2NEshQZW5zB5pWt17ObgALLulPDiX6mdUbvl7Rx4yq/qTSrbKqKdaKXErc9zbckW7YDw7KuIofm9+nlHL3bNd0CMZhvOy9sSBpfwINEWrKdIVj4B5s/n5JcR51QtVd5Th4c0mYE53WluCezp58i5GsCp5Sdkro3ufChpCzs0cWJjXcBZ7vrlEmz+qiZbxrKAcBITZ/UXk0VYhv4fKTDGPcfSudptura6gPmSRtmAVf1XUE/rtbs4vbXhKI4NB2Qx4saaJoYw54q4bt3xLCzjX585uWM9le5FRwmq3TsiFJYSAXHxoZrvmqQh4cYt9pTDTyv1MQn3XaXzqnul9b5anzfCwEsJ6E35F4We8LKcwwDctxlAUHellRm+uaqOQu9RcemWah4YmGlesrVmt+bHqdusPGWPk7ejZIzr5Sve7YUr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39850400004)(346002)(376002)(38100700001)(4326008)(31696002)(186003)(2906002)(31686004)(16526019)(83380400001)(478600001)(6486002)(86362001)(956004)(8676002)(2616005)(66556008)(66946007)(110136005)(316002)(16576012)(54906003)(6666004)(5660300002)(53546011)(36756003)(66476007)(26005)(52116002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bm9ubHMvNzM4emZTN0JsdHdDY2FEekFPVEtMOVNkUUhJclVXbVo1RGlEYm9X?=
 =?utf-8?B?OU53aWZZbmdKd2huODJidDdGNWZaaUZGM0MwRjR1WFhqaGxvOURQK2lpNG4w?=
 =?utf-8?B?Y0dYRlJ1dnJyTHlxRG1HWmV3emcxbEpJWGMxdFlNdVdOdUoycTZySkRwS3hh?=
 =?utf-8?B?dU80WUxhTkNkN2dkWFJ1cU52NHVPVkNJYitIRmFEK0hPWWVrSVlyVUE5MHZO?=
 =?utf-8?B?TnRIT256NWp1LzFSRjhFMlNIWU8vMFlzdW5JcWhWUjVsbkkwUmlXVzZ2bjlZ?=
 =?utf-8?B?L2hwYUdjbkFoWFB5THBoZUE2cjFhRjRUMFNlMWM1OXVLRkJYaTJLRVd2TVFM?=
 =?utf-8?B?ODlzVkpGenk0V1d2a2tLb1JoVEVUMWxMSXFaZXcyYzNsVkdrSUppRjlURFIy?=
 =?utf-8?B?R1AwU2paM0thU3RCNzRVQm1sUUQyd0FsQXF2WFNiRGlQSXd3MSsyNDdScXMy?=
 =?utf-8?B?Y2ZZR0lSYXZxQjBvdGdXcDYyNlhDSGduTjVyV2owdUNBYUVWSWtURHNRMng5?=
 =?utf-8?B?eUdMUHNkWGdyRUtwMGRFTDJnS0IvUDM2SXV2Sit0N2ZXVTZqVnc1YzlQa1pq?=
 =?utf-8?B?MkYyVnE5emZOLzRWMm9qLzJZSUFjcldZV29UOHpheFM2Q00xUC9oektDQ1lm?=
 =?utf-8?B?bFRvRHpzV2hBQXRhRVE3ekl4Mk5KZXMwVEZBYUNLOWZTaGwyWExCN2ZlUkkz?=
 =?utf-8?B?b1Z6cSsvSit3Y2dFVFJOdGU5blljTWZzWGJFNDBxK0xLN1ZuaDgvUlU3RnNn?=
 =?utf-8?B?NDkyekd1RjlxOWx5Z1JKR1g5ZXhlZE10dEpuMVp6STlaMndJT3lsR1VGSHUr?=
 =?utf-8?B?S2J0RFlKK1IvWDVrMDUrcG1tRlN3cE8xdEREUFZIcXQ4cjdmRGh4dTZSaGw2?=
 =?utf-8?B?L0hERDN4M1haNjlWR3ErQjBzaWtjS3BzSzJZTUNTNkxPeHJXMHpySUVIcDRi?=
 =?utf-8?B?M3BSYkVrYzJmNEg4WEtzKy85dW16eldrY2xnWlcyUW8vOUI1L2tzUGp2a0xT?=
 =?utf-8?B?bENzUWpLdnRnQnRBNnZYdXpzTENpU1QwTFhZY3pXaElUaUlKS1JKVGgxZTZ3?=
 =?utf-8?B?dlp0TElRYjcyZm9acEFpV3lUSFRReWlaZFhweGs4Vk5oanNBeUhTd3ZxRjVY?=
 =?utf-8?B?MGw1NXRoUm5oL0dWc1Fkd1RPYmp1bDFlVVAvNnhZWDRRSWlZMGJKM0hYMHVO?=
 =?utf-8?B?S0M5d0xnWDRTekw3eVN0dGZGbk5JSmpTRzltTnBDMVU4T3pxZmJJSUh3YVR6?=
 =?utf-8?B?SUZTRDZYa0ZwNFJRK1FJaHF1ZXoxNnR5Mm1jbkFNRWZXa2tsTWdrYWlnL3RJ?=
 =?utf-8?B?R2tBeUQwLzJjTFd6dEFiRkRVTTVGRGQ1SXg2eTVwZjhRdE5aM0tkTGZHSm01?=
 =?utf-8?B?NXRHTkZiaURxUVBLWmN4a0RlVWwzQ1B0UGxIM0U4d3BYT2VDdVRhUnFvN2du?=
 =?utf-8?B?WHhzN3ZLV3FzWnJrTWRieDVDeVAyVkZ4UUhORVRXeUZOZytWYWplM21KUlRq?=
 =?utf-8?B?UnpGSlY2N1JiSVRMdU16SVQyeUNqK0pwTk1JT3lCZndENkwrNmdzcGR5aGlt?=
 =?utf-8?B?RFEyMTFjbW5SNmpHMEVMODh2aFVYSktQenE2Z3M4a2RzUlV6UVIwRjYzL1hk?=
 =?utf-8?B?TWxuVGhGU1lrWWxJeWJKcnVQVjJaRTliZmN3Y1N4TXJhUFl4WUNhUUNjdXJk?=
 =?utf-8?B?ejlGdUZ4d1MxY0V6RUhiTS9KZU4rLzJQM0NlN21JcTlSMk5RdXFqV1V5Zy93?=
 =?utf-8?Q?HR7n6KTkzoy7NflsX3Up9v0+RNq7O7mqyZaEXx9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf807bb-214f-45e9-632c-08d8ea271109
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 16:01:18.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KIFjIAL9q7G820oNM+3fD93wEG07sr12BSPb8VJ1pmROPBJSZDdHzARe3XKvKNjTd+Q36f6QiOhqGFBNaWRXBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 8:28 PM, Bart Van Assche wrote:
> Since the target function pointers are not modified at runtime, declare
> the data structure with the target function pointers const.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h     | 2 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 49b42b430df4..3bdf55bb0833 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3815,7 +3815,7 @@ struct qlt_hw_data {
>  	__le32 __iomem *atio_q_in;
>  	__le32 __iomem *atio_q_out;
>  
> -	struct qla_tgt_func_tmpl *tgt_ops;
> +	const struct qla_tgt_func_tmpl *tgt_ops;
>  	struct qla_tgt_vp_map *tgt_vp_map;
>  
>  	int saved_set;
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 15650a0bde09..46111f031be9 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1578,7 +1578,7 @@ static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
>  /*
>   * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
>   */
> -static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
> +static const struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
>  	.find_cmd_by_tag	= tcm_qla2xxx_find_cmd_by_tag,
>  	.handle_cmd		= tcm_qla2xxx_handle_cmd,
>  	.handle_data		= tcm_qla2xxx_handle_data,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

