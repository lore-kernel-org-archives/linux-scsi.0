Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547D1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 22:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2406F22EBE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 22:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbhAEW7J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 17:59:09 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:34958 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhAEW7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 17:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609887481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FY1bdJUnaIK9EB7Vo/qhqiCstCtPcsAYFRuahBsuXno=;
        b=WtNfiiz7lVfGU9tqFfD/e+OONNQX+L3g0+bWPKkzaMl4/rLLtPyRcn/PmygaMSYrNUM/e4
        XnpKax3MChTrEvL8Ws0Soq1JtlMXYC1kvzajzz5K3IX7ECwou5sGvAEWuVLEngDaKpy7x5
        dTdJPLLoJWeJntavFA9LhFuJ8CzYzH4=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-txnx6ft_Pz2Wi2qTCjfMUQ-1; Tue, 05 Jan 2021 23:57:59 +0100
X-MC-Unique: txnx6ft_Pz2Wi2qTCjfMUQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQaAR5P5pzzLl5vprau/rP5XKRmC+daQNUw7XGdHlKABU74/gbjEFwhnM1FUEEC85Nw5f1IkGJK/9KL9DApWpRRCmW/7d+1Txg/mNfA9ai5oTgumm9o+MBtogvFjtiWYj4btoEqRt/rF3M6RAICTGWJMOZZgUW6sjMOczEsgYYbCvQDuAo9bMhTJj6Ffrb5klX5UYbRGvHxoO9tTuaGLeP+fHP7eJi6SQcJA8CcmkL/PUfLcwRuVeeJzwkkHPSaGUflJDeAd5MTjKNBwob6+MX7oZNasfvJWpBHS5tzHeiYUhmjE5jjRzVQ0FIrTQDF3Rzybv271S4jNksi3hmMNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FY1bdJUnaIK9EB7Vo/qhqiCstCtPcsAYFRuahBsuXno=;
 b=acguz1IVoI7AxuuD9qknl49J7dvg08ggBD/oL57Bqt5aqZcepcG191GDnSM34yCtdMIPlTC1A948bNtxyv7JSid5KhBHHP8g6gMo6dNhmxKAtmluutg7+N8yJlfS698mqaw/5xpP7fg3BRzxHH5/PYwDxKi3XjA3scrca1Fyz9VbRfox3inKWh0zMtJfsbguHsMi2hof1fKBaov2KFAUvJLzG8138STAkzL0GZnGdGzb5DqpH5TnbOqGIA0WZTU2AzPSVr9rbAQtvV/ZLIIPHwZags1yLMxlrXTmUAzxrMXsIz3nZ2ovLytCq2lbAl9IYiuLcOs4ZNs7a15P0SoxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4072.eurprd04.prod.outlook.com (2603:10a6:209:4d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 22:57:59 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac%6]) with mapi id 15.20.3742.006; Tue, 5 Jan 2021
 22:57:59 +0000
Subject: Re: [PATCH 6/6 V3] libiscsi: reset max/exp cmdsn during recovery
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
 <1608518226-30376-7-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <a36c596f-9e19-da02-3a82-89a050181cfc@suse.com>
Date:   Tue, 5 Jan 2021 14:57:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1608518226-30376-7-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR03CA0015.eurprd03.prod.outlook.com
 (2603:10a6:208:14::28) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR03CA0015.eurprd03.prod.outlook.com (2603:10a6:208:14::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 22:57:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0548f6b-752a-4a19-eff3-08d8b1cd58e3
X-MS-TrafficTypeDiagnostic: AM6PR04MB4072:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4072850B0839F6301DACEDFBDAD10@AM6PR04MB4072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M/kfQ6+qkeHj5j5XBL+4grd9+pg9UPcnykku/1TceKopYbqCai43naHZOO/lmy1qLeRvAFUuY2tqCCWLjqgyI5s/Gc0Dwa5xSNy5zYozteJ8CfBpaU1jBtVAwYR2nEnKorStQVc2G7e7Fpvcu1jYN0A5bXaZQnU84Ea0laR6J3CL5P2L/fMKccMik7pvZ/pIyPlOHKJ+nR/KPUss8s3Wcx1NBg/U5pdeDWYDMguGBQPI4NhEXSUxGYkFLijgV2VRM/7sgxQreQq3gPxQLjS+jZGXKPlF/CJisV8E1hkegONIvYRT6TlccooCIR118bggzeIpIFY2ZLmvR6hHwvBQYwt6u/8o41QckB1ZDPgiv8VpBntJfZBBlhPjjRvY19FL38wqOAvkNAoqgeZvcOExnR+ST7X5oPrYZb0Zvx/jyciOii/zsT2FjKnoBJ3PhoQPcK48pLexVehPcPNo5Ln0Xcay1ntUbErACkeC+0GM2jM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(6666004)(52116002)(6486002)(36756003)(16576012)(53546011)(956004)(2616005)(26005)(31686004)(31696002)(66556008)(66476007)(83380400001)(5660300002)(498600001)(2906002)(186003)(86362001)(8676002)(16526019)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZU1FUmdFSjNNRm9abzVKdlh0SFF1QnVJSkxpTXdraFBmNWgyNDdqaUlaU2xO?=
 =?utf-8?B?Qk1mbndhWEdqdzVKNlprTXRvMDFDbVBQZmZlS215OGhrdlFRd3BVRllpbUhT?=
 =?utf-8?B?Y2ltM0tibkZZU2tXTVBNUTJFYUorTVdQMVpJd1AzYzdueFRBZGt4L3haQVJY?=
 =?utf-8?B?V1dDaDIwNHJMSVBWT0hEQlBsWlV6UC8wMGFLcFN2RnEvMnFYMUF6blJ0VEli?=
 =?utf-8?B?anNxVDM4bzJ3cmxDQlhOdGlFeVJwL2VvQmtoMjVaWjBJa0llUS9XTUYwWnk2?=
 =?utf-8?B?WWpKM1F4Y0lGalgrZExmd0lkUzZGc01ma3JkRVdOb3Y3UGtIS0pHR1NOUDJR?=
 =?utf-8?B?ZWVIdzcxS2o0dUFRWi9zQmlLVEVEUWVtcUdtZGllanZMR1hrd0dYclluVUN6?=
 =?utf-8?B?SkdCdjU3RS9OYnBMMVBqb0lSRWVXNXprSWdaT3FWWllWVFljTUNHUHlrWEJU?=
 =?utf-8?B?OE4vaHFMZTFnOGZzeTJXKzFpZ2NhTkZ0U2QrMTBLZDJzdHo5c05nOXlXSUR0?=
 =?utf-8?B?TzQ2cjlxVU1jdHNrVVJvbVRFYk5CTmRwM1NIdEwyWXN5M1ovcmRlQ05qQUky?=
 =?utf-8?B?aDgrSXNycTRzMGIvUVFjYzlkYSsvMlhlVWhVYmh1UE5BVlpzeWxpTVBRTlZG?=
 =?utf-8?B?bkZsUTVQNkxpUUs4b2NPWWJSam5kLzU0Mit0Sk92RWFwMUYzMGVBd1dkTTVF?=
 =?utf-8?B?cFd1aGt0ZzFxRUdZWU9uQ216eHNvSnJFbk9hbEkwTEJhOGtLTDNWb1E0NVQw?=
 =?utf-8?B?UTIxSlpxYk4valhSWDR2R1k1RExWWlFXRWg3Z0NqOVJQNHh1dzlSNUMyQThi?=
 =?utf-8?B?RDJmakxXQ1JvVW9vSEdCaTVUTVdMWDFibUI1T2ZvSG43TTgrTXVFaVdpaXk1?=
 =?utf-8?B?MzJ1UXVXMTVoRzFXNHR3MjVTSGt5SzBPMlNLYWlQTVMwMHBPNVg3bXFQOWR0?=
 =?utf-8?B?cEJzOEt1UjJVc2VEZ3lLcDZqOWVIVDk0SVFjZGFwQ3B6U3J5L2ZTUVZIaHJl?=
 =?utf-8?B?N25DWWppWkJJTTlobzk2YllGU2dVWFlIWWpScm5BbldwK0pzNFdmNFU0cUty?=
 =?utf-8?B?QndnM0dvai94dkxFWElZS3pIcE5lUVdmajhiS2V3amVFb0pUSXhYVzJJa3J2?=
 =?utf-8?B?RkNTSTEzRUNLQ2hhRHB3dnZCWHdBRlpPanZKZ29jV3czTFRickRVZ3lsdXNl?=
 =?utf-8?B?U0ZkWTV0VzYrV3pWVm84VVd2OUt0WExWZ1Z6VUx2S3hDRUF6ditkYUJ6bHhO?=
 =?utf-8?B?SWFvdUxpbjJxRTNJVDNjV2dsQWJRSWZlYWV0ZzhaTDNmSmMvU0pNK25xejR2?=
 =?utf-8?Q?4L8teCdiP1TgY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 22:57:59.0260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: f0548f6b-752a-4a19-eff3-08d8b1cd58e3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIDdNqDyEVbg0atkdJDqQYb5tstjX1XALPil5AYQUmHd9SbP7EioONLUz3Ih/ZU76s2J36GfeZFEfTYwoCGD4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/20 6:37 PM, Mike Christie wrote:
> If we lose the session then relogin, but the new cmdsn window has
> shrunk (due to something like an admin changing a setting) we will
> have the old exp/max_cmdsn values and will never be able to update
> them. For example, max_cmdsn would be 64, but if on the target the
> user set the window to be smaller then the target could try to return
> the max_cmdsn as 32. We will see that new max_cmdsn in the rsp but
> because it's lower than the old max_cmdsn when the window was larger
> we will not update it.
> 
> So this patch has us reset the windown values during session
> cleanup so they can be updated after a new login.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f1ade91..ff6ba78 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3268,6 +3268,13 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  	spin_unlock_bh(&session->frwd_lock);
>  
>  	/*
> +	 * The target could have reduced it's window size between logins, so
> +	 * we have to reset max/exp cmdsn so we can see the new values.
> +	 */
> +	spin_lock_bh(&session->back_lock);
> +	session->max_cmdsn = session->exp_cmdsn = session->cmdsn + 1;
> +	spin_unlock_bh(&session->back_lock);
> +	/*
>  	 * Unblock xmitworker(), Login Phase will pass through.
>  	 */
>  	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

