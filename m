Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCA9C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 17:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520DB2417D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 17:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgLPRkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:40:31 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:49925 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbgLPRkb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Dec 2020 12:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608140363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qou0+NumUYA35d0JPpL20SSboYK/qRXzgf8IpZoMXa4=;
        b=kUmYaX2Oi5O+Yu9/hAn8mDxKXI+w0IlOmSOBublQKFza0HEwXp7OE/qwmOjj02bCocyXSn
        w5sDO/Zv9cwxYpmHGxb6+OyRR9O1PCnClz10Vs48GOv2Yn31qjbqOiivUNnyf+P5cRrbIx
        olOKL3gSHoaF8evmTkhLZPYogqjmV5I=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-c5irgaZHMGm0ws7yGcgRKQ-1; Wed, 16 Dec 2020 18:39:21 +0100
X-MC-Unique: c5irgaZHMGm0ws7yGcgRKQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goBrx0HNwcL7+a0NfupSVC3nbqjFq0nS+9pPcF0ARMvMHkbN2HpgtZJMExQBIBXwq3V5CnGTQJD1Y3c8GvX3dw3vJ8aMpY4ugsaue/gqtC36qwgf1Y+cKWeeIzq+pcVau5fVBYColoy0br8hoxJD88IAYStg1Thvp2zpPNAdnyWrKL3RFGfvXmkR58EbvrLfzWK2l5u3s4p7xNLWFuOAaP4kIedVq9izn7I6zG/WIsYSnafbpmvDmJ3hUjDbE5aUompUVhWFUF9RJppHjnILYD+ORbbFzq7eRkJFa3v2VJeb+YmRpp9Y3cm2bX3TUIs+4PHqvIs/Wuj0iVwo/uZd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qou0+NumUYA35d0JPpL20SSboYK/qRXzgf8IpZoMXa4=;
 b=SqwZtARb0KnFdpmmp4Dp0f13lJoprjsHr1aYPKqjsBTCSIMtzDlNIw74fKL45Pe6hnLOm1ZvWaWNhn+V3n9wpzE4T7zBB8r+GbeHRUObZsOson0ki1eoS4WXJwjCmCOD0kdk2NExo4UFSWCUMnRgQc1mFXjmkiMyyKep3CxY8A4f4jC5LYNnQnP/crqkoETN6eYd/UuOgiFX+tUOPGlqSxKEil9L779TCGRiQEozh1nhlbKSZy3hgkoGPRcdK4bh9PBaeCHFKY0m5jPy8gFPgJJ0W5AvQ0YPx/7tDQYrb0gOlIJTVJG/KhOsoEdwRn4mjS0L/+CS5QyGc1u4MxR8xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3267.eurprd04.prod.outlook.com (2603:10a6:206:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Wed, 16 Dec
 2020 17:39:19 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3654.024; Wed, 16 Dec 2020
 17:39:19 +0000
Subject: Re: [PATCH 1/3] libiscsi: fix iscsi_prep_scsi_cmd_pdu error handling
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608069210-5755-1-git-send-email-michael.christie@oracle.com>
 <1608069210-5755-2-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <302ef288-d35b-d8b4-353b-814fce368fca@suse.com>
Date:   Wed, 16 Dec 2020 09:39:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <1608069210-5755-2-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:39:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4caf27d8-2390-48bc-ffc3-08d8a1e9849a
X-MS-TrafficTypeDiagnostic: AM5PR04MB3267:
X-Microsoft-Antispam-PRVS: <AM5PR04MB326719EFC2CD885F13E94A89DAC50@AM5PR04MB3267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nd6rlru6HRR4tGqg+j8mAPyUAcH6jvF/T4IdMpC0nnSTT3BgkpFp0wq8idWMWvPrJwDXAv0RYhGvlHc8pMSL3jufI0AGi+UqhUoDt5wUR61oPO94Yx6ZBuBpJBJVS+/fk6FroKe/Y7UtbocQs31d124faA/FSm1N9uKXRWsg/myrz3tacwqQd4yaTI7jm59dFs0xzJCBe8M0mRqGab6KXTrbWhCdrK/qvNuTOH+58cW77Y36DA+Yy6VkM1tugbs2EZ6ylMhh6sAk1DbC/EIQxQcDHHGdkSUteueEemyL17P+3quqPoyzRkltuN+YV7tztsQO+CteNBlAMt+vpaCq7pv0BB2hZ/pRpjs9cs2SVuSwmNkdFgH72MyOTN8n06sp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(31686004)(186003)(2906002)(53546011)(316002)(956004)(16576012)(52116002)(26005)(6666004)(36756003)(2616005)(478600001)(5660300002)(4326008)(66556008)(31696002)(83380400001)(8676002)(16526019)(86362001)(66946007)(6486002)(66476007)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzJuYldhajJ3YU5OMkdObEUvS1A5VndQb3JSS2tuUkdRRG9UVWg5TmlVR3Jl?=
 =?utf-8?B?WC8wSjd2b3BYdVZWWEhndkJUY1E0bWYwYVVkTXdZd0lCTVRLSXhRZVFzTkhm?=
 =?utf-8?B?eVVqTG1ZUnZORzhCU3RGWEF2TUg1cjZibDVFdmVlVkR2Tm9tTU43dEg3VW15?=
 =?utf-8?B?SW5XRWNxeHVpMXZOWkdtaHc5VVdoSHpWN3hQM0Frd28yNjN0aWt3c0V6aDNS?=
 =?utf-8?B?K093YXhlUDdBWjNiUUs4eCtlS3YxNDdsdGh6Tlo1T1JVMTFpNDRjR3NMaHg0?=
 =?utf-8?B?WXJ4azFzUFI0MzdmcmFtcUNSUDBZWlpBS0tWa2x2WkxXRk0yWUNvUkdOK2pU?=
 =?utf-8?B?ZU10WE1ielk5dFBDVmozNkx6QmNFT1BiSHBtRWJaTkcwejZIWGp4aGpVaTkr?=
 =?utf-8?B?czJ0NXBGTlZsZ2JKMGVjdmZFZ0wvbThkUjQxVkk4bjdiM2lhcWdhNU5sMVhT?=
 =?utf-8?B?YjNveE5jeVlwUnhTQWo5d1BRSU14M2Y5ai9iOEFwMEI5ajZkZ3ZPVG9ScVJH?=
 =?utf-8?B?VUxtT2RTNUJVRm15eWJlcDErb216dmhrS3VQSnJmN1J6Ykc0QjlUYk81dHAv?=
 =?utf-8?B?cmFWWmZmcTc2cU94YUVGcUI0NE1OS1RQTDlaby8rVXBKUDRDam41ZG9nTCtv?=
 =?utf-8?B?eTQ4Z2M0VkVPZTJlaFVEYUhic0RBMytyMVFWWWgzNGxESUtROGNTQU1xajVW?=
 =?utf-8?B?OVB1Vk16SnV2UENKb2JlbjFVQ1dkRWM2WG9XVXIwK2k0MEpoRnhkQnVNNHNL?=
 =?utf-8?B?Y015U0JLNy9RNUZSSFEvQmpTVUlkLzM3aVlGeXQ4S0NEd3dXNlpSaDd2SEt0?=
 =?utf-8?B?ZXltSjFXeURPczYxcmpQcGNqRGUwRDZjVlhQaTZabnhDaHBPdmFCSkhLazJN?=
 =?utf-8?B?TU80RjVjNEVVcGV4akw3VDB5VWhQRmppZEtZRGJUbzFCYU9ENU9jWDZ0bjQv?=
 =?utf-8?B?Q1BYcWpMZnBSK24vNDBtaVJ4OG56TmpiQWk2OFZXd0s2TlZhbUhDUWF1Z0ND?=
 =?utf-8?B?WkUrMks4VUw1aWlFem5zVE5uRnN0bVBLZVd5RGZ2L1hIUTE1S1FKQXRFMHl2?=
 =?utf-8?B?MmlRdFV1QXhpM1hyNXI1Ty9JWlloVmFCbUUzRG1tbzBRSUNuRG9EdW50aHRk?=
 =?utf-8?B?Qm5hdW84RDc2bTlhZGUwNGhqd09FRkpaaUNuM2xDdEIvejZYM1QyUWUyVVVD?=
 =?utf-8?B?cnRFV3lUSUNpZ1JuTElaSzdrajc2NnNqQmdUbUF1bDJZWllKQ2VpTWFDeGpL?=
 =?utf-8?B?Rk5MTEh3V29pb3dDbGxaTlJmYVJEQldhb3Btc0gxNTVxT0hkZ0lSR1hOWWha?=
 =?utf-8?Q?ux+lupVR4ors8=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 17:39:19.6148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 4caf27d8-2390-48bc-ffc3-08d8a1e9849a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rYeoOyGyX4Uorw+CcEV78FENqon6YpNh+YUQXa2SHZeRO4Mte/lalpJDy3zPbPnCaAmoDVnEEkvWSaBPgkbBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/15/20 1:53 PM, Mike Christie wrote:
> If iscsi_prep_scsi_cmd_pdu fails we try to add it back to the
> cmdqueue, but we leave it partially setup. We don't have functions
> that can undo the pdu and init task setup. We only have cleanup_task
> which can cleanup both parts. So this has us just fail the cmd and
> go through the standard cleanup routine and then have scsi-ml retry
> it like is done when it fails in the queuecommand path.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/libiscsi.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f9314f1..ee0786b 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1532,14 +1532,9 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		}
>  		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
>  		if (rc) {
> -			if (rc == -ENOMEM || rc == -EACCES) {
> -				spin_lock_bh(&conn->taskqueuelock);
> -				list_add_tail(&conn->task->running,
> -					      &conn->cmdqueue);
> -				conn->task = NULL;
> -				spin_unlock_bh(&conn->taskqueuelock);
> -				goto done;
> -			} else
> +			if (rc == -ENOMEM || rc == -EACCES)
> +				fail_scsi_task(conn->task, DID_IMM_RETRY);
> +			else
>  				fail_scsi_task(conn->task, DID_ABORT);
>  			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

