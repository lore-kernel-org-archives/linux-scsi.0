Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2B1C07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 14:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72A76140C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 14:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFDOsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 10:48:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFDOsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 10:48:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Ei0ev104228;
        Fri, 4 Jun 2021 14:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=F/yfpeM/0L8UFCJ72/laBeCo0L9j6t5a2oPttkw3N2Y=;
 b=vrmwxE9G2Tj3Eguzi6EktwtazV5gks//8lMS0bbsR713P8hzvKmOs1SUJm6kp4IJV//1
 IMM3IAp6/saTDFP3BsG7gT4UCn7IHulfOOXwQE6UDhPgqR3ccd5FEdU9cJ9khAW7OTgV
 K4g4z7OhtXsKyD6XUPS5NTTMg7kk0QdfDhNMLbioVh4GYO5o0SVGHZ4xMDRlOiam6zTr
 6C+K5Dyjz2DSGiNw5Lj8rNSofvsqoyQCr8Fx3+8f4lKUMk0aFKwmhGmlMG0d0wWer3su
 zSVZkFGts815UpUfUsYtOJ0DPTS96vhnwTiWNbJfnIeNaTn25ze8ECOttreA2KXG3Zax 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ue8pp56x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 14:46:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Ek8QT087509;
        Fri, 4 Jun 2021 14:46:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3030.oracle.com with ESMTP id 38uar0a5g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 14:46:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9ATmEbTJEyv1ZqBuGGIjQbcGuytEjE/xShLHTIJq5JjroKbtsNQi37YOBQbO14PJ7SXG7nGXui+OKpbPDr27L+udqTu9WSvnARtSPrGAQWVIMQmhqLYy5wA8CQGArLriHTHKb2nMbQbNCWK6myowL0BmGdkkTPWrw96lEpQyRgpAjaFylRUCVVPxxraKox9Cj0JJLbo2EEy6WGpACRrDwp2BhJHP2gxXOIvVN2Y6zI3oU5DkaLYRg5KSIQFHP8gjdxlFPNRZhp1rdhAfJXI6ZiFaQFs6bafFpJVs7XEXWvmPKDvWkhf+r6tgeNWm4X/ZPM05FLVE0mv0YBk725T5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/yfpeM/0L8UFCJ72/laBeCo0L9j6t5a2oPttkw3N2Y=;
 b=mVD1Y477sn/easJ7ZpD9cJPYLfFsnS+LqkqV2qTCpId9JpBsR7v+mJ4DLbwva7YvfMqV9VfwRNCkbvdeOGzwNDXU7Le20Vcr9fr4AAplhZUKINg0LIilSdmf8bx1Arj2ptVAXcwsmg1YRkCNTDL2Cp4nzhem1UN7pZH63649JV9vVRV5naADFbghlFlaGGT1E+FMRUu6Kw15G4VC2nBFxEgTfErLoOT/jnYQ6hxfpVeMMI3QyHBbco4dNgGRnYPEqOgRvwzhQepw7w71B5WS20FIjp8y6PO9gKfSOkl7241FH3UoIMP5cZl/BPsctjR1+PEJw0A9a6fr0je3Hs84fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/yfpeM/0L8UFCJ72/laBeCo0L9j6t5a2oPttkw3N2Y=;
 b=AfK/mhhFpQcEFWmUcIih3iIVnc6LZVRuKZce89Fgg3F+nYZ8NywxA81Pc82zovBbM0in4OLmrRYL88M3Wp2+xHFHHFKj34wBYdOeK5gtAa2OxvDLh95MkhG7dLViM8ITxa/snjnmDkvRjgJ+01kZsTJ2uoriGoOM2DFf+UQYgUg=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4553.namprd10.prod.outlook.com (2603:10b6:806:11a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 14:46:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 14:46:13 +0000
Subject: Re: [PATCH v2 08/10] qla2xxx: Add doorbell notification for app
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-9-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <083a7bd3-2d18-bc76-debe-44964be1f21b@oracle.com>
Date:   Fri, 4 Jun 2021 09:46:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-9-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0701CA0006.namprd07.prod.outlook.com
 (2603:10b6:803:28::16) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0701CA0006.namprd07.prod.outlook.com (2603:10b6:803:28::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 14:46:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01d9dc44-0cc6-4a8a-84aa-08d927677fb0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4553C735CF7E0B735E04C0C3E63B9@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NiqoUczzDYlzc0aYd16Dsb+EbcVrhNSvsQKEN0j5CBxiUCvDD9LbO1QdLaDOE8e3bUU8Lflqjexx7SB2C5StHiO1ZRCOJgMblLi0iWCKzKrweYQ412+JeZSZADWFPqaH8zllWMfcTswZxHt/QcdJqvD3B+gm6Ec+pbVddootv1GL4fxFOJWVS4WPbxVDvSbu+7vJAzaq+oXixYRvToNoeuX8XDVPiAkdw60sYyGgYgFXNSSLqb82FBOTAwORKLHRVmy+xU3fPtC2oL8MHSGC2ucVbBjz5YL06OVADSpY70PAVDdart7d2jOF6PCtJIAgH7J+ExM3AdADE2KXS0J14ticuBw8Ix/+zPVJtnMnTlklQXPG2N/xIOe+rngVkN3DtZsoqmkuU+jkQ6cvh+Ruoo0+SW0pehNuWPpOIAHMLfRtefn+ek/LKj7ea+9LZ3l/bpK67jYb+i/fpWziciUGItuJyNH7K3V+D9cwQL6RsPkZ0xiF1e5xNSFZZMn1Nn+jTBV3XJ6c2rJrI2YP+EeQLdhfN2qC66He8Lh9CPIQhhFQCNYG/8/j+2vZ/W6+XEUXTcI8WBFUVGKXaJugHq2S4CTaiBUG9x4MwF6EeuasNne4I+5+A7jivlJ2SxUAXOw+rRr0SZVrYyajfn5qhC0LtJol0kleavgIWtImoEiOY/akSNmu76KkEtQ8l2VT2Muu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(396003)(346002)(83380400001)(86362001)(6636002)(186003)(44832011)(66476007)(66946007)(16526019)(956004)(2616005)(66556008)(31686004)(36916002)(31696002)(8676002)(38100700002)(36756003)(478600001)(26005)(15650500001)(2906002)(6486002)(5660300002)(8936002)(53546011)(4326008)(316002)(16576012)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VDlUUjVUdS9qdTI4bitLSVlsNE5iaW5mTS9XL1NXT2Qxd05Talo3ZEJCdWNG?=
 =?utf-8?B?REV4ZW16TW9YZ01YZW90amdkWjhhSW0rYWltQUx6UGRaWmhVZVZ3QzNJeEVa?=
 =?utf-8?B?WTNUWTl3cUhSNmJSTmF3aGc1R2VUSlA0RjVxTFIvWldVSVRQTnl4cEk0MWVk?=
 =?utf-8?B?OU9pTDNJTFgrTnBPc1BCVzdrYkZlaDZzVU9XSG83WUhyYmw1WmdjY20wWWhS?=
 =?utf-8?B?Y0FtWUNTdmhQeEg0SGpBMHhZczRKdURlN1hrS09pODU0eHhCcStBUzdnWDlU?=
 =?utf-8?B?elBqajRuWE5GVngxVkRFckd6UDZBakpyQU1UTmVWbVhGK3hQNkpud2lFbEhq?=
 =?utf-8?B?SUNydkNqK0xFWW5vVEdDaC82dzhzMk1mb0lzM216WElMMk90N01QVTlwTmdZ?=
 =?utf-8?B?QWMxY0FBdHhNZi9rUGhpNDZKMSt6QTdwK1JlanpVeE5QdGRabVZpamRQK0VU?=
 =?utf-8?B?VXZ5d1JNWExqUjRoUk1KT2VMeHBVNWZGWVJTaUJKZG40ZzJicFhmWjBwem95?=
 =?utf-8?B?Vlc0ZE9LMlY2VkpucTZHMzN6amJiSFlTcnI0aVlUeGFLWW0vRTVkNEV1NkVu?=
 =?utf-8?B?OTNBSGtSQzNtU3ZKZUNRaWhvVWhUYlN3ODY0WmUvNEt3WStWc0w2Uk1UTHFC?=
 =?utf-8?B?RWgwcG9GWldLQ1dQamZGNTU3ZVd2QmhkSHJxME1nU3lHajlwU0lOM1piVjlt?=
 =?utf-8?B?bmJoNWN6eENjbkhOZWhROUVPUWRhbHhWZkFRUVVrMUFsUTlvNHhjcHFxVXJx?=
 =?utf-8?B?YmJlZjB0Y1B4dVYrWVdhS25pclFPeEZtNElKTDhHSGNTTHA0eWJQejk4OUZv?=
 =?utf-8?B?bTJNOXI0U0tRb3R5V2lTZVh6dlVSejJodlhsN2R4OGt1aGpKTW0vbFhWS3FO?=
 =?utf-8?B?cXFSN3lTVlQrNTY5eEtTckNEZlhoTjQ3ajk4MFo0dWYwNEN6bWM4KzBqVTQ3?=
 =?utf-8?B?REhjTjl3TjB0Q3FQY1puZk9HT1R1WkVkMmRaaG52SkV6M2I2MWxvQkIrNUxn?=
 =?utf-8?B?MDAwbWwyRnRidWU2Y1lwdlNYdG81eWtkcllFS1pYS092a0xvSVdiZ0VZYzdq?=
 =?utf-8?B?Q3JUdUJISU9uNmRqa3RyeFhSVjNyUmNhVWRwL0NoM1ZwU1ZjMmQyL1d3djYz?=
 =?utf-8?B?UTlPZzN0SjlVVG4wWFRna3JsVTJ6a1VaZktyZUpPeW9OaTdUdmxuY245d1Jv?=
 =?utf-8?B?S3RTdVI3ZXA1Z1lwakZJV1dvRjdBN1h4VDk5YkVsMEVjaXg2RG5Qa0xwL2VZ?=
 =?utf-8?B?M3ZrSkxFWUQwOVNMQm10YyswYzUxdjBaMTNxdDlDdTc2djhQV29hVHI3cU11?=
 =?utf-8?B?eDMyKzFQaWFUa2c2Vkx6Nk55Rnc2TUZncmR3ZzliOExLNUp2Sncvem1TaFdP?=
 =?utf-8?B?RkdoeHZ2SFordnVoZ1VVZ3NqRWdMM2pKN0Jqbm5YVitnaTFDcWVyVDBjb3hr?=
 =?utf-8?B?S2NwN3ZudnZZVGFQQjI0WWVKSVBpTUV5SXZSWjBOekJJWkFZWkx6dWk1SFVz?=
 =?utf-8?B?WlZnM0tmeU9JKzYyZjJEYWZST05uVEZXbXA5K0g0SStydERXZ0c0MUxnWWk0?=
 =?utf-8?B?TU9WaDExelpadUR6RkhjMisvM3VUcWREUzMvMDNXbXJYN2VuS1N3ZkxXcGh3?=
 =?utf-8?B?Szg1a2diZW9veTdRRGZhK3RtZ1JPUHZoUE8yOXZiRFhQWHNCdnlMajBaVVlI?=
 =?utf-8?B?UStQcGNLbDFnZ3pRbk4wT1VOb3ptVkcrcjNyTFFPTWVDQXBaVG4xdHM5Y1M4?=
 =?utf-8?Q?2cEJ6uIB6agXoR/L+2mKeLbydvIWUJbdynAt/Yu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d9dc44-0cc6-4a8a-84aa-08d927677fb0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 14:46:12.9266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFrwi7LhKhTRRmsumfD+lCx3HsMLlc1bw86YFFErg+JJX+lfhH84F1a/ogs2vjJcpBJe9HMtHzWRzc63K3LUsVWkTecBDVMBysb5g26k6hA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040111
X-Proofpoint-GUID: 9WTBUtHWh9EydTLFjzeH6rkpdh2D06cm
X-Proofpoint-ORIG-GUID: 9WTBUtHWh9EydTLFjzeH6rkpdh2D06cm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/31/21 2:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> During runtime, driver and authentication application needs
> to stay in sync in terms of: session being down|up, arrival of
> new authentication message(AUTH ELS) and SADB update completion.
> 
> These events are queued up as doorbell to the authentication
> application. Application would read this doorbell on regular
> basis to stay up to date. Each SCSI host would have a separate
> doorbell queue.
> 
> The doorbell interface can daisy chain a list of events for
> each read. Each event contains an event code + hint to help
> application steer the next course of action.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c   |   4 +
>   drivers/scsi/qla2xxx/qla_bsg.c    |  24 ++-
>   drivers/scsi/qla2xxx/qla_edif.c   | 342 ++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_gbl.h    |   4 +
>   drivers/scsi/qla2xxx/qla_init.c   |   3 +
>   drivers/scsi/qla2xxx/qla_os.c     |   4 +
>   drivers/scsi/qla2xxx/qla_target.c |   2 +
>   7 files changed, 379 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index d78db2949ef6..22191e9a04a0 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2435,6 +2435,7 @@ static DEVICE_ATTR(port_speed, 0644, qla2x00_port_speed_show,
>       qla2x00_port_speed_store);
>   static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
>   static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
> +static DEVICE_ATTR_RO(edif_doorbell);
>   
>   
>   struct device_attribute *qla2x00_host_attrs[] = {
> @@ -2480,6 +2481,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
>   	&dev_attr_port_no,
>   	&dev_attr_fw_attr,
>   	&dev_attr_dport_diagnostics,
> +	&dev_attr_edif_doorbell,
>   	NULL, /* reserve for qlini_mode */
>   	NULL, /* reserve for ql2xiniexchg */
>   	NULL, /* reserve for ql2xexchoffld */
> @@ -3108,6 +3110,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>   
>   	qla_nvme_delete(vha);
>   	qla_enode_stop(vha);
> +	qla_edb_stop(vha);
> +
>   	vha->flags.delete_progress = 1;
>   
>   	qlt_remove_target(ha, vha);
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 2d43603e31ec..0739f8ad525a 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2784,10 +2784,13 @@ qla2x00_manage_host_port(struct bsg_job *bsg_job)
>   }
>   
>   static int
> -qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
> +qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_job)
>   {
>   	struct fc_bsg_request *bsg_request = bsg_job->request;
>   
> +	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=0x%x\n",
> +	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
> +
>   	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
>   	case QL_VND_LOOPBACK:
>   		return qla2x00_process_loopback(bsg_job);
> @@ -2916,12 +2919,19 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>   		ql_dbg(ql_dbg_user, vha, 0x709f,
>   		    "BSG: ISP abort active/needed -- cmd=%d.\n",
>   		    bsg_request->msgcode);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
>   		return -EBUSY;
>   	}
>   
> +	if (test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags)) {
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		return -EIO;
> +	}
> +
>   skip_chip_chk:
> -	ql_dbg(ql_dbg_user, vha, 0x7000,
> -	    "Entered %s msgcode=0x%x.\n", __func__, bsg_request->msgcode);
> +	ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x7000,
> +	    "Entered %s msgcode=0x%x. bsg ptr %px\n",
> +	    __func__, bsg_request->msgcode, bsg_job);
>   
>   	switch (bsg_request->msgcode) {
>   	case FC_BSG_RPT_ELS:
> @@ -2932,7 +2942,7 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>   		ret = qla2x00_process_ct(bsg_job);
>   		break;
>   	case FC_BSG_HST_VENDOR:
> -		ret = qla2x00_process_vendor_specific(bsg_job);
> +		ret = qla2x00_process_vendor_specific(vha, bsg_job);
>   		break;
>   	case FC_BSG_HST_ADD_RPORT:
>   	case FC_BSG_HST_DEL_RPORT:
> @@ -2941,6 +2951,10 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>   		ql_log(ql_log_warn, vha, 0x705a, "Unsupported BSG request.\n");
>   		break;
>   	}
> +
> +	ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x7000,
> +	    "%s done with return %x\n", __func__, ret);
> +
>   	return ret;
>   }
>   
> @@ -2955,6 +2969,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
>   	unsigned long flags;
>   	struct req_que *req;
>   
> +	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
> +	    __func__, bsg_job);
>   	/* find the bsg job from the active list of commands */
>   	spin_lock_irqsave(&ha->hardware_lock, flags);
>   	for (que = 0; que < ha->max_req_queues; que++) {
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 0fa6a1420c30..721898afb064 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -19,6 +19,18 @@ static int qla_edif_sadb_delete_sa_index(fc_port_t *fcport, uint16_t nport_handl
>   		uint16_t sa_index);
>   static int qla_pur_get_pending(scsi_qla_host_t *, fc_port_t *, struct bsg_job *);
>   
> +struct edb_node {
> +	struct  list_head	list;
> +	uint32_t		ntype;
> +	uint32_t		lstate;
> +	union {
> +		port_id_t	plogi_did;
> +		uint32_t	async;
> +		port_id_t	els_sid;
> +		struct edif_sa_update_aen	sa_aen;
> +	} u;
> +};
> +
>   static struct els_sub_cmd {
>   	uint16_t cmd;
>   	const char *str;
> @@ -455,6 +467,10 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
>   					/* build and send the aen */
>   					fcport->edif.rx_sa_set = 1;
>   					fcport->edif.rx_sa_pending = 0;
> +					qla_edb_eventcreate(vha,
> +							VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
> +							QL_VND_SA_STAT_SUCCESS,
> +							QL_VND_RX_SA_KEY, fcport);
>   				}
>   				ql_dbg(ql_dbg_edif, vha, 0x5033,
>   	"%s: releasing edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
> @@ -547,6 +563,12 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>   			    fcport->loop_id, fcport->d_id.b24,
>   			    fcport->logout_on_delete);
>   
> +			ql_dbg(ql_dbg_edif, vha, 0xf084,
> +			    "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
> +			    fcport->keep_nport_handle,
> +			    fcport->send_els_logo, fcport->disc_state,
> +			    fcport->edif.auth_state, fcport->edif.app_stop);
> +
>   			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
>   				break;
>   
> @@ -1232,6 +1254,10 @@ qla24xx_check_sadb_avail_slot(struct bsg_job *bsg_job, fc_port_t *fcport,
>   		/* build and send the aen */
>   		fcport->edif.rx_sa_set = 1;
>   		fcport->edif.rx_sa_pending = 0;
> +		qla_edb_eventcreate(fcport->vha,
> +		    VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
> +		    QL_VND_SA_STAT_SUCCESS,
> +		    QL_VND_RX_SA_KEY, fcport);
>   
>   		/* force a return of good bsg status; */
>   		return RX_DELETE_NO_EDIF_SA_INDEX;
> @@ -1806,17 +1832,314 @@ qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
>   	qla2x00_start_iocbs(vha, qp->req);
>   	return 0;
>   }
> +
> +void
> +qla_edb_init(scsi_qla_host_t *vha)
> +{
> +	if (vha->e_dbell.db_flags == EDB_ACTIVE) {
> +		/* list already init'd - error */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "edif db already initialized, cannot reinit\n");
> +		return;
> +	}
> +
> +	/* initialize lock which protects doorbell & init list */
> +	spin_lock_init(&vha->e_dbell.db_lock);
> +	INIT_LIST_HEAD(&vha->e_dbell.head);
> +
> +	/* create and initialize doorbell */
> +	init_completion(&vha->e_dbell.dbell);
> +}
> +
> +static void
> +qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
> +{
> +	/*
> +	 * releases the space held by this edb node entry
> +	 * this function does _not_ free the edb node itself
> +	 * NB: the edb node entry passed should not be on any list
> +	 *
> +	 * currently for doorbell there's no additional cleanup
> +	 * needed, but here as a placeholder for furture use.
> +	 */
> +
> +	if (!node) {
> +		ql_dbg(ql_dbg_edif, vha, 0x09122,
> +		    "%s error - no valid node passed\n", __func__);
> +		return;
> +	}
> +
> +	node->lstate = LSTATE_DEST;
> +	node->ntype = N_UNDEF;
> +}
> +
>   /* function called when app is stopping */
>   
>   void
>   qla_edb_stop(scsi_qla_host_t *vha)
>   {
> +	unsigned long flags;
> +	struct edb_node *node, *q;
> +
>   	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
>   		/* doorbell list not enabled */
>   		ql_dbg(ql_dbg_edif, vha, 0x09102,
>   		    "%s doorbell not enabled\n", __func__);
>   		return;
>   	}
> +
> +	/* grab lock so list doesn't move */
> +	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
> +
> +	vha->e_dbell.db_flags &= ~EDB_ACTIVE; /* mark it not active */
> +	/* hopefully this is a null list at this point */
> +	list_for_each_entry_safe(node, q, &vha->e_dbell.head, list) {
> +		ql_dbg(ql_dbg_edif, vha, 0x910f,
> +		    "%s freeing edb_node type=%x\n",
> +		    __func__, node->ntype);
> +		qla_edb_node_free(vha, node);
> +		list_del(&node->list);
> +
> +		spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
> +		kfree(node);
> +		spin_lock_irqsave(&vha->e_dbell.db_lock, flags);

any particular reason for unlock before kfree?

> +	}
> +	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
> +
> +	/* wake up doorbell waiters - they'll be dismissed with error code */
> +	complete_all(&vha->e_dbell.dbell);
> +}
> +
> +static struct edb_node *
> +qla_edb_node_alloc(scsi_qla_host_t *vha, uint32_t ntype)
> +{
> +	struct edb_node	*node;
> +
> +	node = kzalloc(sizeof(*node), GFP_ATOMIC);
> +	if (!node) {
> +		/* couldn't get space */
> +		ql_dbg(ql_dbg_edif, vha, 0x9100,
> +		    "edb node unable to be allocated\n");
> +		return NULL;
> +	}
> +
> +	node->lstate = LSTATE_OFF;
> +	node->ntype = ntype;
> +	INIT_LIST_HEAD(&node->list);
> +	return node;
> +}
> +
> +/* adds a already alllocated enode to the linked list */
> +static bool
> +qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
> +{
> +	unsigned long		flags;
> +
> +	if (ptr->lstate != LSTATE_OFF) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911a,
> +		    "%s error edb node(%p) state=%x\n",
> +		    __func__, ptr, ptr->lstate);
> +		return false;
> +	}
> +
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s doorbell not enabled\n", __func__);
> +		return false;
> +	}
> +
> +	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
> +	ptr->lstate = LSTATE_ON;
> +	list_add_tail(&ptr->list, &vha->e_dbell.head);
> +	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
> +
> +	/* ring doorbell for waiters */
> +	complete(&vha->e_dbell.dbell);
> +
> +	return true;
> +}
> +
> +/* adds event to doorbell list */
> +void
> +qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
> +	uint32_t data, uint32_t data2, fc_port_t	*sfcport)
> +{
> +	struct edb_node	*edbnode;
> +	fc_port_t *fcport = sfcport;
> +	port_id_t id;
> +
> +	if (!vha->hw->flags.edif_enabled) {
> +		/* edif not enabled */
> +		return;
> +	}
> +
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		if (fcport)
> +			fcport->edif.auth_state = dbtype;
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s doorbell not enabled (type=%d\n", __func__, dbtype);
> +		return;
> +	}
> +
> +	edbnode = qla_edb_node_alloc(vha, dbtype);
> +	if (!edbnode) {
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s unable to alloc db node\n", __func__);
> +		return;
> +	}
> +
> +	if (!fcport) {
> +		id.b.domain = (data >> 16) & 0xff;
> +		id.b.area = (data >> 8) & 0xff;
> +		id.b.al_pa = data & 0xff;
> +		ql_dbg(ql_dbg_edif, vha, 0x09222,
> +		    "%s: Arrived s_id: %06x\n", __func__,
> +		    id.b24);
> +		fcport = qla2x00_find_fcport_by_pid(vha, &id);
> +		if (!fcport) {
> +			ql_dbg(ql_dbg_edif, vha, 0x09102,
> +			    "%s can't find fcport for sid= 0x%x - ignoring\n",
> +			__func__, id.b24);
> +			kfree(edbnode);
> +			return;
> +		}
> +	}
> +
> +	/* populate the edb node */
> +	switch (dbtype) {
> +	case VND_CMD_AUTH_STATE_NEEDED:
> +	case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
> +		edbnode->u.plogi_did.b24 = fcport->d_id.b24;
> +		break;
> +	case VND_CMD_AUTH_STATE_ELS_RCVD:
> +		edbnode->u.els_sid.b24 = fcport->d_id.b24;
> +		break;
> +	case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
> +		edbnode->u.sa_aen.port_id = fcport->d_id;
> +		edbnode->u.sa_aen.status =  data;
> +		edbnode->u.sa_aen.key_type =  data2;
> +		break;
> +	default:
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +			"%s unknown type: %x\n", __func__, dbtype);
> +		qla_edb_node_free(vha, edbnode);
> +		kfree(edbnode);
> +		edbnode = NULL;
> +		break;
> +	}
> +
> +	if (edbnode && (!qla_edb_node_add(vha, edbnode))) {
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s unable to add dbnode\n", __func__);
> +		qla_edb_node_free(vha, edbnode);
> +		kfree(edbnode);
> +		return;
> +	}
> +	if (edbnode && fcport)
> +		fcport->edif.auth_state = dbtype;
> +	ql_dbg(ql_dbg_edif, vha, 0x09102,
> +	    "%s Doorbell produced : type=%d %p\n", __func__, dbtype, edbnode);
> +}
> +
> +static struct edb_node *
> +qla_edb_getnext(scsi_qla_host_t *vha)
> +{
> +	unsigned long	flags;
> +	struct edb_node	*edbnode = NULL;
> +
> +	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
> +
> +	/* db nodes are fifo - no qualifications done */
> +	if (!list_empty(&vha->e_dbell.head)) {
> +		edbnode = list_first_entry(&vha->e_dbell.head,
> +		    struct edb_node, list);
> +		list_del(&edbnode->list);
> +		edbnode->lstate = LSTATE_OFF;
> +	}
> +
> +	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
> +
> +	return edbnode;
> +}
> +
> +/*
> + * app uses separate thread to read this. It'll wait until the doorbell
> + * is rung by the driver or the max wait time has expired
> + */
> +ssize_t
> +edif_doorbell_show(struct device *dev, struct device_attribute *attr,
> +		char *buf)
> +{
> +	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
> +	struct edb_node	*dbnode = NULL;
> +	struct edif_app_dbell *ap = (struct edif_app_dbell *)buf;
> +	uint32_t dat_siz, buf_size, sz;
> +
> +	sz = 256; /* app currently hardcode to 256. */
> +

why hardcode this value? can app not send the value needed to driver so 
that dirver does not have to worry about changing if App decides to 
change its limitation.

> +	/* stop new threads from waiting if we're not init'd */
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
> +		    "%s error - edif db not enabled\n", __func__);
> +		return 0;
> +	}
> +
> +	if (!vha->hw->flags.edif_enabled) {
> +		/* edif not enabled */
> +		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
> +		    "%s error - edif not enabled\n", __func__);
> +		return -1;
> +	}
> +
> +	buf_size = 0;
> +	while ((sz - buf_size) >= sizeof(struct edb_node)) {
> +		/* remove the next item from the doorbell list */
> +		dat_siz = 0;
> +		dbnode = qla_edb_getnext(vha);
> +		if (dbnode) {
> +			ap->event_code = dbnode->ntype;
> +			switch (dbnode->ntype) {
> +			case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
> +			case VND_CMD_AUTH_STATE_NEEDED:
> +				ap->port_id = dbnode->u.plogi_did;
> +				dat_siz += sizeof(ap->port_id);
> +				break;
> +			case VND_CMD_AUTH_STATE_ELS_RCVD:
> +				ap->port_id = dbnode->u.els_sid;
> +				dat_siz += sizeof(ap->port_id);
> +				break;
> +			case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
> +				ap->port_id = dbnode->u.sa_aen.port_id;
> +				memcpy(ap->event_data, &dbnode->u,
> +						sizeof(struct edif_sa_update_aen));
> +				dat_siz += sizeof(struct edif_sa_update_aen);
> +				break;
> +			default:
> +				/* unknown node type, rtn unknown ntype */
> +				ap->event_code = VND_CMD_AUTH_STATE_UNDEF;
> +				memcpy(ap->event_data, &dbnode->ntype, 4);
> +				dat_siz += 4;
> +				break;
> +			}
> +
> +			ql_dbg(ql_dbg_edif, vha, 0x09102,
> +				"%s Doorbell consumed : type=%d %p\n",
> +				__func__, dbnode->ntype, dbnode);
> +			/* we're done with the db node, so free it up */
> +			qla_edb_node_free(vha, dbnode);
> +			kfree(dbnode);
> +		} else {
> +			break;
> +		}
> +
> +		ap->event_data_size = dat_siz;
> +		/* 8bytes = ap->event_code + ap->event_data_size */
> +		buf_size += dat_siz + 8;
> +		ap = (struct edif_app_dbell *)(buf + buf_size);
> +	}
> +	return buf_size;
>   }
>   
>   static void qla_noop_sp_done(srb_t *sp, int res)
> @@ -2138,6 +2461,8 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
>   	    __func__, purex->pur_info.pur_bytes_rcvd,
>   	    purex->pur_info.pur_sid.b24,
>   	    purex->pur_info.pur_did.b24, p->rx_xchg_addr);
> +
> +	qla_edb_eventcreate(host, VND_CMD_AUTH_STATE_ELS_RCVD, sid, 0, NULL);
>   }
>   
>   static uint16_t  qla_edif_get_sa_index_from_freepool(fc_port_t *fcport, int dir)
> @@ -2356,9 +2681,15 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
>   		if (pkt->flags & SA_FLAG_TX) {
>   			sp->fcport->edif.tx_sa_set = 1;
>   			sp->fcport->edif.tx_sa_pending = 0;
> +			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
> +				QL_VND_SA_STAT_SUCCESS,
> +				QL_VND_TX_SA_KEY, sp->fcport);
>   		} else {
>   			sp->fcport->edif.rx_sa_set = 1;
>   			sp->fcport->edif.rx_sa_pending = 0;
> +			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
> +				QL_VND_SA_STAT_SUCCESS,
> +				QL_VND_RX_SA_KEY, sp->fcport);
>   		}
>   	} else {
>   		ql_dbg(ql_dbg_edif, vha, 0x3063,
> @@ -2366,6 +2697,15 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
>   		    __func__, sp->fcport->port_name,
>   		    pkt->sa_index, pkt->new_sa_info, pkt->port_id[2],
>   		    pkt->port_id[1], pkt->port_id[0]);
> +
> +		if (pkt->flags & SA_FLAG_TX)
> +			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
> +				(le16_to_cpu(pkt->u.comp_sts) << 16) | QL_VND_SA_STAT_FAILED,
> +				QL_VND_TX_SA_KEY, sp->fcport);
> +		else
> +			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
> +				(le16_to_cpu(pkt->u.comp_sts) << 16) | QL_VND_SA_STAT_FAILED,
> +				QL_VND_RX_SA_KEY, sp->fcport);
>   	}
>   
>   	/* for delete, release sa_ctl, sa_index */
> @@ -2872,6 +3212,8 @@ void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
>   			"%s: sess %8phN send port_offline event\n",
>   			__func__, sess->port_name);
>   		sess->edif.app_sess_online = 0;
> +		qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SESSION_SHUTDOWN,
> +		    sess->d_id.b24, 0, sess);
>   		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
>   	}
>   }
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index c695f5a58d4d..cc78339b47ac 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -981,11 +981,15 @@ void qla_nvme_unregister_remote_port(struct fc_port *fcport);
>   
>   /* qla_edif.c */
>   fc_port_t *qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id);
> +void qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype, uint32_t data, uint32_t data2,
> +		fc_port_t *fcport);
>   void qla_edb_stop(scsi_qla_host_t *vha);
> +ssize_t edif_doorbell_show(struct device *dev, struct device_attribute *attr, char *buf);
>   int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
>   void qla_enode_init(scsi_qla_host_t *vha);
>   void qla_enode_stop(scsi_qla_host_t *vha);
>   void qla_edif_flush_sa_ctl_lists(fc_port_t *fcport);
> +void qla_edb_init(scsi_qla_host_t *vha);
>   void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
>   void qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
>   void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 7a20b1ddc63f..bef9bf59bc50 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1474,6 +1474,9 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
>   				    __func__, __LINE__, fcport->port_name);
>   				fcport->edif.app_started = 1;
>   				fcport->edif.app_sess_online = 1;
> +
> +				qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED,
> +				    fcport->d_id.b24, 0, fcport);
>   			}
>   
>   			rc = 1;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 0b379ac179fa..efc21ef80142 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3490,6 +3490,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   probe_failed:
>   	qla_enode_stop(base_vha);
> +	qla_edb_stop(base_vha);
>   	if (base_vha->gnl.l) {
>   		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
>   				base_vha->gnl.l, base_vha->gnl.ldma);
> @@ -3793,6 +3794,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   
>   	base_vha->gnl.l = NULL;
>   	qla_enode_stop(base_vha);
> +	qla_edb_stop(base_vha);
>   
>   	vfree(base_vha->scan.l);
>   
> @@ -4919,6 +4921,8 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
>   	init_waitqueue_head(&vha->fcport_waitQ);
>   	init_waitqueue_head(&vha->vref_waitq);
>   	qla_enode_init(vha);
> +	qla_edb_init(vha);
> +
>   
>   	vha->gnl.size = sizeof(struct get_name_list_extended) *
>   			(ha->max_loop_id + 1);
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index faf446f0fe8c..5d9fafa0c5d9 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -585,6 +585,8 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
>   			    DSC_LOGIN_AUTH_PEND);
>   			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
>   			    sp->fcport->d_id.b24);
> +			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED, sp->fcport->d_id.b24,
> +			    0, sp->fcport);
>   		}
>   		break;
>   
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
