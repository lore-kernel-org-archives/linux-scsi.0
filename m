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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1250FC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 21:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38B7613DE
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 21:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbhDXVM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 17:12:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:43969 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232708AbhDXVM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Apr 2021 17:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619298739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74HJboMOdpxekfCTx29VmcMh0UV4ieUVftRsuyElgRc=;
        b=MpEJ68N8GOdmhc+eGlcLONLlCLj6AZdxX/YnNGIUs4UymuBVGkziTXNqODaz1vGAhACiic
        NUbLaDpaT7N2dNLXdjdhsmGEshj320rXBUE9eV2TVZCYcBa6jGjfE8AcqiKUIRS34uTSzq
        pTwJiPT0A04/TXB7xasPql4yTNpHN34=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-1-8l33tRPhNQqjVT_OoOD1QQ-1; Sat, 24 Apr 2021 23:12:17 +0200
X-MC-Unique: 8l33tRPhNQqjVT_OoOD1QQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC4ehc9wLjR+OBaG9+qgqKTD5ugv5JHTySb3BNGPkzaUBNvt9TpX2/ogGAAjDRqaEYSKoow6XFSASnlgU7ps24MPOtrS8qqP+Ic3HvmUfHb4X+UucRx5h0ifpqmdhYtsYz9vIy3LbjFCDYpihQqzt60hJqE6Ot5HSQNNgmiIc5dKwRY4nUwfqR456gUQ0M4YlUUgqO+8Xqf/D0gJGFj/3pogSJRdyEE3WDeGskLSlyt55gXpeZQBMcpqIasdLssVo70gtb+OAzogfF9sX6xv3Tw5rXBnEraHJs0h9KJhJ6QaZ+pgX1hpsk9/L4WgocxZIVG+KxfUyVjKZKzJrOq/AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74HJboMOdpxekfCTx29VmcMh0UV4ieUVftRsuyElgRc=;
 b=KhvgmFi5m2Do0239nKQn3VmMyarpsZ3bxpqkSHY6DZDGRiZoTstec8euZMVROjh3VlPj+qoTlC904Sf45b6bKu4f3XPVOsDd5UZkLilPGSA1p1R9hRMmHezEdV2sl2Wr2OvwiGLiTYqKFKfiZFdN+EIdCZEf0BT0JrLb1kUMTG2+y1n1YPucpD2H/BVUHFoAEiIx2v9xA64wWSjbdco9N3iaccPXPQZJsIyv/jMtQGgvvPVHEzfHytmIML/tJQIwgqF7frscxvSewcoXpeqOtveDRg22L7BCbfp7+8AlMs0jmFxZlNbzxP1fjGMEZtZ4Ph6UkiMLLDGLa6A+0ZXPVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5925.eurprd04.prod.outlook.com (2603:10a6:20b:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sat, 24 Apr
 2021 21:12:16 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Sat, 24 Apr 2021
 21:12:16 +0000
Subject: Re: [PATCH v3 07/17] scsi: iscsi: move pool freeing
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-8-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <ff2bbaee-1e46-3656-2f11-7311c75f6000@suse.com>
Date:   Sat, 24 Apr 2021 14:12:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.19 via Frontend Transport; Sat, 24 Apr 2021 21:12:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e882ba-c6e3-432a-a03d-08d90765a390
X-MS-TrafficTypeDiagnostic: AM6PR04MB5925:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5925C3EA054BCAA46559BF3EDA449@AM6PR04MB5925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovXKKN/wnwQFvqs5VT6xjdY/ZCb1LhXoSyRuyytTkFekrwwTi6myvj+RboAb6ZJbbumZXmdB14KoMhqpf8RXF/326TXAGnjvnJ2QzZwzXRV2yVKjrIajXhaT43Td8t0hZIivK78v+K9Lr8fJZlE8UnUqDFwDXKGaxoDs+5E4xZ8PlDJLqnPN2OZnONRgSCRCtv63lQiJ/2YfCgAOiWTtdNExLiHrr/OBOI1qfGs481gVgEz78b5sgRPxTsKHWalBKi29hqb+1/ObKJ/CZx9znHYWDEwjbU9KJ2ITXanGxQgwHz3YI+yq5rEU3PxOQEVkaZ1ktF+vIMIBpodbUX53cgUrsAXi0Wfq0TN9sYZnOzoynuU/cjDqp+hlR11Z75L3JiMiTs+Z5SQriufWZcFMaDaKc6az8NIwXfYSYwS9rscliXHVEwjNazz1yXm/bkM30IqIa8J9gdHOtmn3NTrzzw/4ZmxXkdDCghSgliRTzEqaLnxdrWbBowOzQC+WbshrEd71rN1QZnuP2EazfjQH0IhgDDYXhVxBIhbhEXmTKSMf2y0LCki8k0i2iqVzE7DBKWCA6AKdfZblIVz1OLlyjPkLQwTIijve/EgIR+674sLs1v+0jkQADK89O9hN3fRsI5MERJdSFstUrxpn025Z4UFb4i5sCJJktxh6K539fQz9vEzrzOFIwTLVOfbi+hiRamyUd+kGil38k1R6zD+iww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39850400004)(346002)(136003)(186003)(26005)(5660300002)(16526019)(2906002)(83380400001)(8936002)(52116002)(316002)(6486002)(86362001)(956004)(31686004)(31696002)(2616005)(478600001)(6666004)(16576012)(66946007)(38350700002)(38100700002)(36756003)(8676002)(66476007)(66556008)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T1c4YlNUUFZ2aDlvbkd2ZW1HTVRaMkYwSWZVTGNTMWRXejRDVUtsUnZXR1hL?=
 =?utf-8?B?NFBReG0rRno4TlhQSDlDdjdhUXdwN05vR1VkQnZQZlBYa0VxRlRva1Q1ejQ5?=
 =?utf-8?B?VmdydGZzOTFEU3pzb21xTE5rcDVXeC9wMkV2Wkg5czgwUXNiVFJMNjlDNGIx?=
 =?utf-8?B?aDlyenhxbjByVUpGMWkxQnlXdy9iaGNkUTBFSkRVbmVRdVVDSzl4ck5aNzB5?=
 =?utf-8?B?SlV3NUtxUGV3cDhwc28wMmYrenNQZktuVkxMTzVGWDlScTBCRGlEaENBNlBQ?=
 =?utf-8?B?bkhpZi9DZmxVZ2VvK2Rid2NFTHE4cTkzeUp3Ulg3SEdCVERuTHBWNUpXQy9C?=
 =?utf-8?B?RUhBM1NpOXRSdzZnNUFWMGdiVUw3WUVQWUEzSExQbS84c1dSc01JWFlCQ2sz?=
 =?utf-8?B?VHl1WVh4Z0NwWW5OTXQvQi8zY0lsOW1LbG1jNDRqTkR5S3Vxb3lSYkZ5Umps?=
 =?utf-8?B?VWdjZ2toUGRPSjBtUldVS3dneU9hVFN5RVpRam4yL0h5NmVtdHBSbE42ZW5m?=
 =?utf-8?B?YkEvbG9lQ1lJSmt6K1ZLNVlIOWpuSVowNVBubHlvTURYa2Y1anI4T2hxdlBk?=
 =?utf-8?B?VDZSZ0xiZjQ3N2c4ZGtNT2dPL2owazkvOTJRYWh3SWJqOUZrQ09CSnN2dnpL?=
 =?utf-8?B?QkpaVjlwUkR6YXJTT0hlZWVRM3kxMmY1bzI4RlFuTmp0eVEzTzBsaStaaGdW?=
 =?utf-8?B?aENPZ2JPS21Dc2hjTkt0Qm1XWFFGWm9YQ3p4UUV3RmxPWm1vVUVicHpWbGpv?=
 =?utf-8?B?Mi9ySTl2b2t3QUhXMitXM0Y1Y0ZJczZGOEs2Z0F1dUtjRWJvYlFDNmd1SzRv?=
 =?utf-8?B?dWM3ZVNmdWl3NmJnM2NzaG9LOGZkUzJVakdMcWI0bEZxK2ZkSlhOU0JBbC9P?=
 =?utf-8?B?Rk82SEMzT3V3SGIwRGp0YlhQWEdxUUg4SUZEdVZBbWMwaFk1UWFGRWxPMFVG?=
 =?utf-8?B?K0Y3ejV0Z3FJZ2o0eElDU05PUVNyelU5a2ZnMXcvMXRGN3U3Q0xnZHFqRjhi?=
 =?utf-8?B?N3E4RitEb1pRSGgycXp2MFp6UVRiZGd1WlVnUXZhSnRycS8veXlBRW9Qa1J6?=
 =?utf-8?B?WmVWZG5ocXkvekxqUDYvNlhIMy9MLzhVTlZLelI2YWFaQjZHa0o3amdUVHlo?=
 =?utf-8?B?OUhRTGF1R0lKRXpYRXU3YkpVZE84MTdWYkZQTCtKUU1LOGg5VEVnL0Y4cTEv?=
 =?utf-8?B?RHkrOG9hK0FGZVBJM3R3N0lVV2V0VGY4YklRRXJNY0NHbjFrTzdacHJiaXc1?=
 =?utf-8?B?K05MVnRRZXU2N0ZoU0wxTE81RWpaSG5XVm1IREdxYW8rd3JER0NkMCttaStE?=
 =?utf-8?B?RHJpUU12SzVWTVZRTUdxQ20wa0x6MllTVVZkRytVWldmNXNzMjZUbWxlZDRT?=
 =?utf-8?B?d2N3QlZNOFF1OHZFSTJFbzIrbFNnSTdFcWt6MExmbHNjYW9ieVB6L0dITEFI?=
 =?utf-8?B?OENRZWVWcVAyTFZvV3ZMMFpNWkNvRmc2QkdEQmJ5eWg0S0xnRndzL3ZIQWE5?=
 =?utf-8?B?UmtJZXVnRFRwcHkwdVdYelhlTXJvOHZiVlF3WHpXcFRZZlh5WVBzSEtPandS?=
 =?utf-8?B?bHVYRUZ3ZG1Ea09tVHUyVkFqdVpFN1pheWdhay80eDcvUFV0aW9EOUtZd3gw?=
 =?utf-8?B?OGorYmxGQnVlbFF5WUVCQW1Cd0picEw0OFp3STNQVHVTK1lxdHpiQjZ4QjRr?=
 =?utf-8?B?UG9ndXBXZEgwWEl2eVVpcEJaVC9xWExpeTZjWTlMSXkrclJNMEhHVVBzZ0d6?=
 =?utf-8?Q?CgOyVI/eaTYYlXsuhe+Qyj7QbCH1aLjRF3BopbG?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e882ba-c6e3-432a-a03d-08d90765a390
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 21:12:16.9130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFDrTatIoHI/jLsxK6n9/qLFEtX4nRFTUOwWAilfKQn2vyZRQkPat2Edb3J3G3OjpIqXam37bJxAwk5aPzMSog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5925
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
> This doesn't fix any bugs, but it makes more sense to free the pool after
> we have removed the session. At that time we know nothing is touching any
> of the session fields, because all devices have been removed and scans are
> stopped.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 56b41d8fff02..b2970054558a 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3025,10 +3025,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
>  	struct module *owner = cls_session->transport->owner;
>  	struct Scsi_Host *shost = session->host;
>  
> -	iscsi_pool_free(&session->cmdpool);
> -
>  	iscsi_remove_session(cls_session);
>  
> +	iscsi_pool_free(&session->cmdpool);
>  	kfree(session->password);
>  	kfree(session->password_in);
>  	kfree(session->username);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

