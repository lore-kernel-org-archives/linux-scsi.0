Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4ECC47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 20:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5922613E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 20:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFCUpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:45:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39940 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCUpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 16:45:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153Kbb7l181816;
        Thu, 3 Jun 2021 20:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9qQC+/W90lwXmfK9DbVoyu876cOxSC8z7gERnAOt5ss=;
 b=DhW548t5xNAzDfwABBJdpknkvH4UvleddWgneBv+W1vSBlerqQzkX1LOKxZgwcecIQso
 RYbK2URckZ57xxlnJ+Dcp89ICII/UXvocjdDbrUN2pbMDu8S7TbCi7nkmr3TCEp3SoE7
 cHfQfxEwFsKwcKvkQvB2LJjEjkJDJRpJGJpcTHfRdR8vPU2nodbe4Msspnptuk5o/Mim
 GRiEAN/srr/P90jxjlqE9c+2UPDaFutEW0spzvC7QrYGgcjGFJQQ/ba9vM+YFZ02f17/
 p8rDdg2uHusxqt481ircrRx7M7bWtDyPTC9OdMuhUnc3nKIWwtFn2fUPd/Lm+3wloX8V bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38ub4cvf47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 20:43:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153KVX3c097054;
        Thu, 3 Jun 2021 20:43:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 38xyn1hw0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 20:43:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT9nfjT2rL9k9xr7b3K5DxRUhnJQnomkNHv9iLZOcG+q8PAYyAMeyF4gH9WWromJKp4sYevM+PIV8ixrvj+Ig/8ZUjp8ZEVCn1iRbe3QTYuPFdXm0A2LuTNI3RzeNmMfu5Z0WoBTdccPdJusYUUc2gVEH8wpjQexCnLkdulM/POTEC/7C9gkUPCi4RYMUWaaehBL49umb2WDPY0fZRbhmm4wwyE+4pcuvCQ7ZKXC4DjIzyyeZBCkpKZmMkKUtH9XKUY4a7U92cKsxFxcKcE6SgVbNfdrQkBfsiRXv+9HiYn2froh40VCu8PZPQ+YoA7+eoben0eVvd7On8EzoJLTyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qQC+/W90lwXmfK9DbVoyu876cOxSC8z7gERnAOt5ss=;
 b=WDSiry+zRN9b/THcvc2eV97ieknhtK5zjkwYE3GQIVLF/WBZCOy68FV1zwYgxlLNaGENblTd4pQqoElVnwt642cxx6qwwiBxPZrJP+Wk4X9YEOXdA89BfbFpeRBy4SzdVtXGaxKyx+IpdZmTIzfyzvWSSobEwP09Q9T5n1X8ULbpRy50g8Gvpx2IQH6CtDnnBKR3gyKL5RzxXAdpVaSSOuWq8uo8Ig8/L4z4TbE4nwODe233Cf5N7QraxvyXqEhmilcN6Kc4ksmYXq011ODIc/HDHqEE6QQAvY4hY822E032X09im5TTUPLCqekOCXEuS8QMpY0AUe2xu7mPROfhEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qQC+/W90lwXmfK9DbVoyu876cOxSC8z7gERnAOt5ss=;
 b=jEyA/DDLuMRf6xhQ2VksBOkl0Oz+oJoHR3dc7P4dUgJtwYwIXqZNuSpfJPfmhC4qvjDENeKK7nXXRHw3iPCXP4iWBqbgUc5pPBHGFeerieIilbNcWbWFc1x+w3df2JVOQdYWNW/8D+IZhHxcFTSN26iULDX2X1cHWDr/RpMb7sE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 20:43:14 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 20:43:14 +0000
Subject: Re: [PATCH v2 03/10] qla2xxx: Add send, receive and accept for
 auth_els
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-4-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <511d7bcb-fd6c-69da-5f37-1732eb150008@oracle.com>
Date:   Thu, 3 Jun 2021 15:43:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0501CA0057.namprd05.prod.outlook.com
 (2603:10b6:803:41::34) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0057.namprd05.prod.outlook.com (2603:10b6:803:41::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Thu, 3 Jun 2021 20:43:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b94fc71-9c49-4498-e0ac-08d926d0355a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB44599AC2809D3BB5F5D09B6EE63C9@SA2PR10MB4459.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:47;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pAAAszAQAxxBWzRdI5iLj9eCmtXY7KZt+j2mx20y3rYwgc7M4xfLkmcGjYtVx7cFRacTKdaGB2CIQGB15M7lJDeLCUEAIuU+DEhrc08isupySL4C1i7p1Z4V2UuR9l9DOqoLWg9+bnBw94+Zk1Qnkmg6cl2aLUeMjbV3cXYG/9TYgsTIalc7bDa9vtUYAFb4S9HBlQgM7shua25WUsBv9+SzxdoViMwPZ1jHY8yc6ts5He8bfOdYn46QB7t2kihvbcRgDOtFWSgRdap6h9ozD0YLfpfUXR91IovG43HVE1uSJCKPWfVNTQNi4UIXrvW5VCUILRN0SrdUnt+3ltqaPFzePzmu8J+VJyVEG072EEReI0ujgiM+eqrgi6LcJimXtbJ0+GBZyOtytHb/MLB8Ke/vTiAAtLIR/ttRY7ryxC+hu+C0npVWf3kGgZvDNkwJwRzvQ7fj308Zmp89uP5Nlg68vEdCpzaiNkFaJO5CRC7A7LU4iw6gagJiXHIwRMG92l//uPwWBAB41Peu2F5isiGk2tpKV5HliEJCcACrG7aqcxLM7NIMs2pvHQlV5I+ZLvYBkOsy7Cmt5vLdxGLtxhwUMUh1fQEfLes4k3T9I6nXSDNeGEoUlQC1P0+cp171RWxr4LkqYDe0WpCsTPYArUTuvH4rQQSy+EOr1iRYOmtM+0D2nW3C3w+UUUxhX2HN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(396003)(346002)(366004)(66946007)(6636002)(66556008)(66476007)(6486002)(2616005)(31696002)(53546011)(8676002)(86362001)(36916002)(31686004)(5660300002)(956004)(36756003)(16576012)(30864003)(4326008)(38100700002)(186003)(44832011)(478600001)(16526019)(2906002)(316002)(8936002)(26005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?KzQyRmM1SVpZMmNlOUZXSzBSWDBBOHI5Nm82SUxnNnNOMnZpcWgzbFU0ai94?=
 =?utf-8?B?ZVFLNlhhSUhUc3JreFBQK283bzMxcmRjdEZ6RUdnalZLVTNGdHZmS203bEk0?=
 =?utf-8?B?Tjd3Q3F6cHVJMjA0M3FYQTU0elIxc2ZKQVlMdjBpTTJzaHk4Yyt1dXRjT3Mw?=
 =?utf-8?B?bysrZ1ZYQ08zQjdyS2pxU3h1L3Z1bUxvZjVIOVIya3VjZ3RKQ2I0RHNqV2li?=
 =?utf-8?B?U3hQN0cxVlpHaWJWWE54YmU1V0ZvUlZEMm44TCt1OE1YYkVRMDQvOUFjKy85?=
 =?utf-8?B?Vkx2NUlsaDM2SkY1VEZwSkZqYjUydTByRDRoK0NrQ2FESGxHWTZtbnlGZGpx?=
 =?utf-8?B?dVBTdTBaTGNYNG5hZUZvZFN1NE5ubEo0S3hvMW1OT1ljQW5yc0NuK3Rwdk1x?=
 =?utf-8?B?N01GZE54NGlkMXdpMmJGRFF5V0tvNFBCTFFzejk2dW5kU2lhMjBEdUFtZEpG?=
 =?utf-8?B?NzVZU25SeWtrMXZ3YlhVL2hVRDY1bW9PSnJmaUZIclY4YTNNS1NlRy8xUjE5?=
 =?utf-8?B?VW1LSHdoSUZMV084dHFGMi9EVXh6dkw0Y1dnWXAxNC9ONWVLUTVlYVZRZkVj?=
 =?utf-8?B?ZkJ1YXVXMHFyL2YwcEN2TGVxY2M0YUtNaGpiWExNSGVTVkdlZFJYS29WMTR4?=
 =?utf-8?B?WE9mMFEwY0w3Uzk3Y2FYVTR4Y0pjVmRWc053dmtBNDVrREdlaFRrUlpuNURx?=
 =?utf-8?B?aHR3TDJLQ3pxQ25admNhYnJ5WGNqcStiRXVXUFlKSVY5dEpzcnZKSTk1eThq?=
 =?utf-8?B?Z1JaZVF2aDVqM09icWNkVCtCTFNYVlhpd2RWQjVFSEh5UWVFenFJa0dzcktE?=
 =?utf-8?B?VEM3RHRhNHRXZlhyMDE0aUIxaWMyMWJtaytwTkcxR2R5Ym5qTVVpVUlGTysy?=
 =?utf-8?B?R1VDMlNFUVM2Q3FHN2R4ak44Wks2a09BelNWUFNNSTl3YmZTRVRqeFJoajNi?=
 =?utf-8?B?U0NhaWZJRnRpVVFycm1WN3A5bGtQUGZtVVpOWjJhclpXdUpuOXJocEJBRlRN?=
 =?utf-8?B?UEhxM2YrVG01Uk0xak9idXdjcE9ta1BGZWQ1U0RjQzRReWl4bXI1Q1gyOGtE?=
 =?utf-8?B?Q2NUVXA2TnV0WmdGVDBlOEFiZVlVY09NK2xKcWp0MnVPRXd5R2FvMlA4MVBl?=
 =?utf-8?B?bG4vMUswdFEwcVUzWkljYlR0eHVkbCsxUDgzRVNlQzAxNWhzYm9tdERVaXpO?=
 =?utf-8?B?VHdzWmlROHVLdHJFRVFxVkxCTVU1VTdEZVI2dmtacUJVWWlFbEV3bUd6eGlP?=
 =?utf-8?B?b3puMTIvZnZkYnVPWnZUandpS3V0ODAyMEs5VHRDSk8yQmFNeTVsRk1LbEdr?=
 =?utf-8?B?VWxGS2VRdlh4Z2kwSDFJMFR1K3NVMDAxQVZNc3pDOXl3RzhNY1VnUDBkQmpl?=
 =?utf-8?B?UnN0K1lUdkZDWlhYRFY3anY1aGxwU3BwTjk3RG5Wem84OHRFVlh3WjRSOXpt?=
 =?utf-8?B?Z2xJUU43T3Z2TWdaQ0lESmh6T3hMUXFsYzg5QkdRZnl2emV2WTJwbTFqQnhH?=
 =?utf-8?B?UXBMQjlBZlUxZGJhSVA3ZENVUTVHRnNiOGpHUktzWVpnN2M3ZDdkSmU3MVFi?=
 =?utf-8?B?aTNSSnhwbENHTzV0WmVjRzlNenk4WXgrYUZQZWpjZktkUzRXU1c1KzMzYmxH?=
 =?utf-8?B?UzlnWWVWdVVOSWcxRHcxWjVGaVQ3TE0vNXkxWFREb0krZnJnckZxNEFtUlA5?=
 =?utf-8?B?OHNEbmE4eXFuTVg5cVVXZ3V4VzJUeE5zOXBNQk5iQ2N4djRPVG9LcnkwOXNW?=
 =?utf-8?Q?2Ff9LJBAKBulVF5CE7o2ilErLw6eG8L4JG2+Qh/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b94fc71-9c49-4498-e0ac-08d926d0355a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 20:43:14.1566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXHVKpgL3mBZhFkNmKJ7Ypqv0/Mgq/3t4UMeloDxU5Q58QRZPPNVbvuI7rMYvPI1zRNuTgsnFG6s/rOCcGHL6+R+SzA3hoHVz2GZnAuK8PE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030139
X-Proofpoint-GUID: npj0RrLId5gJ2FqD1KNu3v7193lq5rJZ
X-Proofpoint-ORIG-GUID: npj0RrLId5gJ2FqD1KNu3v7193lq5rJZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030139
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
> This patch add ability for authentication application to
> send and retrieve message(s) as part of the authentication
> process via existing FC_BSG_HST_ELS_NOLOGIN BSG interface
> 
> To send a message, application is expected to format the
> data in the AUTH ELS format. Refer to FC-SP2 for details.
> 
> If a message was received, application is required to reply with
> either a LS_ACC or LS_RJT complete the exchange using the same
> interface. Otherwise, remote device will treat it as a
> timeout.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c   |   1 +
>   drivers/scsi/qla2xxx/qla_bsg.c    |  63 +++--
>   drivers/scsi/qla2xxx/qla_def.h    |  48 ++++
>   drivers/scsi/qla2xxx/qla_edif.c   | 430 ++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_edif.h   |  38 +++
>   drivers/scsi/qla2xxx/qla_gbl.h    |   6 +-
>   drivers/scsi/qla2xxx/qla_iocb.c   |  42 +++
>   drivers/scsi/qla2xxx/qla_isr.c    |  95 ++++++-
>   drivers/scsi/qla2xxx/qla_os.c     |  41 +++
>   drivers/scsi/qla2xxx/qla_target.c |   7 +-
>   10 files changed, 731 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 3aa9869f6fae..d78db2949ef6 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3107,6 +3107,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>   	qla2x00_wait_for_sess_deletion(vha);
>   
>   	qla_nvme_delete(vha);
> +	qla_enode_stop(vha);
>   	vha->flags.delete_progress = 1;
>   
>   	qlt_remove_target(ha, vha);
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index e6cccbcc7a1b..2d43603e31ec 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -27,6 +27,10 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
>   
>   	sp->free(sp);
>   
> +	ql_dbg(ql_dbg_user, sp->vha, 0x7009,
> +	    "%s: sp hdl %x, result=%x bsg ptr %p\n",
> +	    __func__, sp->handle, res, bsg_job);
> +
>   	bsg_reply->result = res;
>   	bsg_job_done(bsg_job, bsg_reply->result,
>   		       bsg_reply->reply_payload_rcv_len);
> @@ -53,11 +57,19 @@ void qla2x00_bsg_sp_free(srb_t *sp)
>   			    bsg_job->reply_payload.sg_list,
>   			    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
>   	} else {
> -		dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
> -		    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
>   
> -		dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
> -		    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
> +		if (sp->remap.remapped) {
> +			dma_pool_free(ha->purex_dma_pool, sp->remap.rsp.buf,
> +			    sp->remap.rsp.dma);
> +			dma_pool_free(ha->purex_dma_pool, sp->remap.req.buf,
> +			    sp->remap.req.dma);
> +		} else {
> +			dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
> +				bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
> +
> +			dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
> +				bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
> +		}
>   	}
>   
>   	if (sp->type == SRB_CT_CMD ||
> @@ -266,6 +278,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
>   	int req_sg_cnt, rsp_sg_cnt;
>   	int rval =  (DID_ERROR << 16);
>   	uint16_t nextlid = 0;
> +	uint32_t els_cmd = 0;
>   
>   	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
>   		rport = fc_bsg_to_rport(bsg_job);
> @@ -279,6 +292,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
>   		vha = shost_priv(host);
>   		ha = vha->hw;
>   		type = "FC_BSG_HST_ELS_NOLOGIN";
> +		els_cmd = bsg_request->rqst_data.h_els.command_code;
> +		if (els_cmd == ELS_AUTH_ELS)
> +			return qla_edif_process_els(vha, bsg_job);
>   	}
>   
>   	if (!vha->flags.online) {
> @@ -2948,27 +2964,26 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
>   
>   		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
>   			sp = req->outstanding_cmds[cnt];
> -			if (sp) {
> -				if (((sp->type == SRB_CT_CMD) ||
> -					(sp->type == SRB_ELS_CMD_HST) ||
> -					(sp->type == SRB_FXIOCB_BCMD))
> -					&& (sp->u.bsg_job == bsg_job)) {
> -					req->outstanding_cmds[cnt] = NULL;
> -					spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -					if (ha->isp_ops->abort_command(sp)) {
> -						ql_log(ql_log_warn, vha, 0x7089,
> -						    "mbx abort_command "
> -						    "failed.\n");
> -						bsg_reply->result = -EIO;
> -					} else {
> -						ql_dbg(ql_dbg_user, vha, 0x708a,
> -						    "mbx abort_command "
> -						    "success.\n");
> -						bsg_reply->result = 0;
> -					}
> -					spin_lock_irqsave(&ha->hardware_lock, flags);
> -					goto done;
> +			if (sp &&
> +			    (sp->type == SRB_CT_CMD ||
> +			     sp->type == SRB_ELS_CMD_HST ||
> +			     sp->type == SRB_ELS_CMD_HST_NOLOGIN ||
> +			     sp->type == SRB_FXIOCB_BCMD) &&
> +			    sp->u.bsg_job == bsg_job) {
> +				req->outstanding_cmds[cnt] = NULL;
> +				spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +				if (ha->isp_ops->abort_command(sp)) {
> +					ql_log(ql_log_warn, vha, 0x7089,
> +					    "mbx abort_command failed.\n");
> +					bsg_reply->result = -EIO;
> +				} else {
> +					ql_dbg(ql_dbg_user, vha, 0x708a,
> +					    "mbx abort_command success.\n");
> +					bsg_reply->result = 0;
>   				}
> +				spin_lock_irqsave(&ha->hardware_lock, flags);
> +				goto done;
> +
>   			}
>   		}
>   	}
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 9c921381d020..517a4a4c178e 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -341,6 +341,13 @@ struct name_list_extended {
>   	u32			size;
>   	u8			sent;
>   };
> +
> +struct els_reject {
> +	struct fc_els_ls_rjt *c;
> +	dma_addr_t  cdma;
> +	u16 size;
> +};
> +
>   /*
>    * Timeout timer counts in seconds
>    */
> @@ -618,6 +625,21 @@ struct srb_iocb {
>   #define SRB_PRLI_CMD	21
>   #define SRB_CTRL_VP	22
>   #define SRB_PRLO_CMD	23
> +#define SRB_SA_UPDATE	25
> +#define SRB_ELS_CMD_HST_NOLOGIN 26
> +#define SRB_SA_REPLACE	27
> +
> +struct qla_els_pt_arg {
> +	u8 els_opcode;
> +	u8 vp_idx;
> +	__le16 nport_handle;
> +	u16 control_flags;
> +	__le32 rx_xchg_address;
> +	port_id_t did;
> +	u32 tx_len, tx_byte_count, rx_len, rx_byte_count;
> +	dma_addr_t tx_addr, rx_addr;
> +
> +};
>   
>   enum {
>   	TYPE_SRB,
> @@ -631,6 +653,13 @@ struct iocb_resource {
>   	u16 iocb_cnt;
>   };
>   
> +struct bsg_cmd {
> +	struct bsg_job *bsg_job;
> +	union {
> +		struct qla_els_pt_arg els_arg;
> +	} u;
> +};
> +
>   typedef struct srb {
>   	/*
>   	 * Do not move cmd_type field, it needs to
> @@ -663,7 +692,21 @@ typedef struct srb {
>   		struct srb_iocb iocb_cmd;
>   		struct bsg_job *bsg_job;
>   		struct srb_cmd scmd;
> +		struct bsg_cmd bsg_cmd;
>   	} u;
> +	struct {
> +		bool remapped;
> +		struct {
> +			dma_addr_t dma;
> +			void *buf;
> +			uint len;
> +		} req;
> +		struct {
> +			dma_addr_t dma;
> +			void *buf;
> +			uint len;
> +		} rsp;
> +	} remap;
>   	/*
>   	 * Report completion status @res and call sp_put(@sp). @res is
>   	 * an NVMe status code, a SCSI result (e.g. DID_OK << 16) or a
> @@ -4638,8 +4681,12 @@ struct qla_hw_data {
>   
>   	struct qla_hw_data_stat stat;
>   	pci_error_state_t pci_error_state;
> +	struct dma_pool *purex_dma_pool;
> +	struct els_reject elsrej;
>   };
>   
> +#define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
> +
>   struct active_regions {
>   	uint8_t global;
>   	struct {
> @@ -5110,6 +5157,7 @@ enum nexus_wait_type {
>   	WAIT_LUN,
>   };
>   
> +#define QLA_SKIP_HANDLE QLA_TGT_SKIP_HANDLE
>   /* Refer to SNIA SFF 8247 */
>   struct sff_8247_a0 {
>   	u8 txid;	/* transceiver id */
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index fd39232fa68d..4c788f4588ca 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -11,6 +11,30 @@
>   #include <linux/delay.h>
>   #include <scsi/scsi_tcq.h>
>   
> +static int qla_pur_get_pending(scsi_qla_host_t *, fc_port_t *, struct bsg_job *);
> +
> +static struct els_sub_cmd {
> +	uint16_t cmd;
> +	const char *str;
> +} sc_str[] = {
> +	{SEND_ELS, "send ELS"},
> +	{SEND_ELS_REPLY, "send ELS Reply"},
> +	{PULL_ELS, "retrieve ELS"},
> +};
> +
> +const char *sc_to_str(uint16_t cmd)
> +{
> +	int i;
> +	struct els_sub_cmd *e;
> +
> +	for (i = 0; i < ARRAY_SIZE(sc_str); i++) {
> +		e = sc_str + i;
> +		if (cmd == e->cmd)
> +			return e->str;
> +	}
> +	return "unknown";
> +}
> +
>   static void
>   qla_edif_sa_ctl_init(scsi_qla_host_t *vha, struct fc_port  *fcport)
>   {
> @@ -27,6 +51,73 @@ qla_edif_sa_ctl_init(scsi_qla_host_t *vha, struct fc_port  *fcport)
>   	fcport->edif.rx_bytes = 0;
>   }
>   
> +static int qla_bsg_check(scsi_qla_host_t *vha, struct bsg_job *bsg_job,
> +fc_port_t *fcport)
> +{
> +	struct extra_auth_els *p;
> +	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +	struct qla_bsg_auth_els_request *req =
> +	    (struct qla_bsg_auth_els_request *)bsg_job->request;
> +
> +	if (!vha->hw->flags.edif_enabled) {
> +		/* edif support not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x9105,
> +		    "%s edif not enabled\n", __func__);
> +		goto done;
> +	}
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s doorbell not enabled\n", __func__);
> +		goto done;
> +	}
> +
> +	p = &req->e;
> +
> +	/* Get response */
> +	if (p->sub_cmd == PULL_ELS) {
> +		struct qla_bsg_auth_els_reply *rpl =
> +			(struct qla_bsg_auth_els_reply *)bsg_job->reply;
> +
> +		qla_pur_get_pending(vha, fcport, bsg_job);
> +
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +			"%s %s %8phN sid=%x. xchg %x, nb=%xh bsg ptr %p\n",
> +			__func__, sc_to_str(p->sub_cmd), fcport->port_name,
> +			fcport->d_id.b24, rpl->rx_xchg_address,
> +			rpl->r.reply_payload_rcv_len, bsg_job);
> +
> +		goto done;
> +	}
> +	return 0;
> +
> +done:
> +
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +			bsg_reply->reply_payload_rcv_len);
> +	return -EIO;
> +}
> +
> +fc_port_t *
> +qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id)
> +{
> +	fc_port_t *f, *tf;
> +
> +	f = NULL;
> +	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
> +		if ((f->flags & FCF_FCSP_DEVICE)) {
> +			ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x2058,
> +	"Found secure fcport - nn %8phN pn %8phN portid=%02x%02x%02x, 0x%x, 0x%x.\n",

fix indentation

> +			    f->node_name, f->port_name,
> +			    f->d_id.b.domain, f->d_id.b.area,
> +			    f->d_id.b.al_pa, f->d_id.b24, id->b24);
> +			if (f->d_id.b24 == id->b24)
> +				return f;
> +		}
> +	}
> +	return NULL;
> +}
> +
>   static int
>   qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
>   {
> @@ -506,17 +597,192 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
>   
>   	return rval;
>   }
> +
> +static void
> +qla_enode_free(scsi_qla_host_t *vha, struct enode *node)
> +{
> +	/*
> +	 * releases the space held by this enode entry
> +	 * this function does _not_ free the enode itself
> +	 * NB: the pur node entry passed should not be on any list
> +	 */
> +
> +	if (!node) {
> +		ql_dbg(ql_dbg_edif, vha, 0x09122,
> +		    "%s error - no valid node passed\n", __func__);
> +		return;
> +	}
> +
> +	node->dinfo.lstate = LSTATE_DEST;
> +	node->ntype = N_UNDEF;
> +	kfree(node);
> +}
> +
> +/*
> + * function to initialize enode structs & lock
> + * NB: should only be called when driver attaching
> + */

use kernel-doc style for description

> +void
> +qla_enode_init(scsi_qla_host_t *vha)
> +{
> +	struct	qla_hw_data *ha = vha->hw;
> +	char	name[32];
> +
> +	if (vha->pur_cinfo.enode_flags == ENODE_ACTIVE) {
> +		/* list still active - error */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102, "%s enode still active\n",
> +		    __func__);
> +		return;
> +	}
> +
> +	/* initialize lock which protects pur_core & init list */
> +	spin_lock_init(&vha->pur_cinfo.pur_lock);
> +	INIT_LIST_HEAD(&vha->pur_cinfo.head);
> +
> +	snprintf(name, sizeof(name), "%s_%d_purex", QLA2XXX_DRIVER_NAME,
> +	    ha->pdev->device);
> +}
> +
> +/*
> + * function to stop and clear and enode data
> + * called when app notified it is stopping
> + */
> +

use kernel-doc style here for description

>   void
>   qla_enode_stop(scsi_qla_host_t *vha)
>   {
> +	unsigned long flags;
> +	struct enode *node, *q;
> +
>   	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
>   		/* doorbell list not enabled */
>   		ql_dbg(ql_dbg_edif, vha, 0x09102,
>   		    "%s enode not active\n", __func__);
>   		return;
>   	}
> +
> +	/* grab lock so list doesn't move */
> +	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
> +
> +	vha->pur_cinfo.enode_flags &= ~ENODE_ACTIVE; /* mark it not active */
> +
> +	/* hopefully this is a null list at this point */
> +	list_for_each_entry_safe(node, q, &vha->pur_cinfo.head, list) {
> +		ql_dbg(ql_dbg_edif, vha, 0x910f,
> +		    "%s freeing enode type=%x, cnt=%x\n", __func__, node->ntype,
> +		    node->dinfo.nodecnt);
> +		list_del_init(&node->list);
> +		spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
> +		qla_enode_free(vha, node);
> +		spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
> +	}
> +	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
> +}

Ah I see that the actual action is added here for enode_stop. maybe 
Patch 1 should have comment to that effect. (hard to follow patch series 
without context)

> +
> +/*
> + *  allocate enode struct and populate buffer
> + *  returns: enode pointer with buffers
> + *           NULL on error
> + */

Use kernel-doc style for description.

> +
> +static struct enode *
> +qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_t p2)
> +{
> +	struct enode			*node_rtn = NULL;
> +	struct enode			*list_node = NULL;
> +	unsigned long		flags;
> +	struct list_head	*pos, *q;
> +

extra line not necessary

> +	uint32_t		sid;
> +	uint32_t		rw_flag;
> +

extra line not necessary

> +	struct purexevent		*purex;
> +
> +	/* secure the list from moving under us */
> +	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
> +
> +	list_for_each_safe(pos, q, &vha->pur_cinfo.head) {
> +		list_node = list_entry(pos, struct enode, list);
> +
> +		/* node type determines what p1 and p2 are */
> +		purex = &list_node->u.purexinfo;
> +		sid = p1;
> +		rw_flag = p2;
> +
> +		if (purex->pur_info.pur_sid.b24 == sid) {
> +			if (purex->pur_info.pur_pend == 1 &&
> +			    rw_flag == PUR_GET) {
> +				/*
> +				 * if the receive is in progress
> +				 * and its a read/get then can't
> +				 * transfer yet
> +				 */
> +				ql_dbg(ql_dbg_edif, vha, 0x9106,
> +				    "%s purex xfer in progress for sid=%x\n",
> +				    __func__, sid);
> +			} else {
> +				/* found it and its complete */
> +				node_rtn = list_node;
> +			}
> +		}
> +
> +		if (node_rtn) {
> +			/*
> +			 * found node that we're looking for so take it
> +			 * off the list and return it to the caller
> +			 */
> +			list_del(pos);
> +			list_node->dinfo.lstate = LSTATE_OFF;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
> +
> +	return node_rtn;
>   }
>   
> +/*
> + * Return number of bytes of purex payload pending for consumption
> + */
> +static int
> +qla_pur_get_pending(scsi_qla_host_t *vha, fc_port_t *fcport, struct bsg_job *bsg_job)
> +{
> +	struct enode		*ptr;
> +	struct purexevent	*purex;
> +	struct qla_bsg_auth_els_reply *rpl =
> +	    (struct qla_bsg_auth_els_reply *)bsg_job->reply;
> +
> +	bsg_job->reply_len = sizeof(*rpl);
> +
> +	ptr = qla_enode_find(vha, N_PUREX, fcport->d_id.b24, PUR_GET);
> +	if (!ptr) {
> +		ql_dbg(ql_dbg_edif, vha, 0x9111,
> +		    "%s no enode data found for %8phN sid=%06x\n",
> +		    __func__, fcport->port_name, fcport->d_id.b24);
> +		SET_DID_STATUS(rpl->r.result, DID_IMM_RETRY);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * enode is now off the linked list and is ours to deal with
> +	 */
> +	purex = &ptr->u.purexinfo;
> +
> +	/* Copy info back to caller */
> +	rpl->rx_xchg_address = purex->pur_info.pur_rx_xchg_address;
> +
> +	SET_DID_STATUS(rpl->r.result, DID_OK);
> +	rpl->r.reply_payload_rcv_len =
> +	    sg_pcopy_from_buffer(bsg_job->reply_payload.sg_list,
> +		bsg_job->reply_payload.sg_cnt, purex->msgp,
> +		purex->pur_info.pur_bytes_rcvd, 0);
> +
> +	/* data copy / passback completed - destroy enode */
> +	qla_enode_free(vha, ptr);
> +
> +	return 0;
> +}
>   /* function called when app is stopping */
>   
>   void
> @@ -529,3 +795,167 @@ qla_edb_stop(scsi_qla_host_t *vha)
>   		return;
>   	}
>   }
> +
> +static void qla_parse_auth_els_ctl(struct srb *sp)
> +{
> +	struct qla_els_pt_arg *a = &sp->u.bsg_cmd.u.els_arg;
> +	struct bsg_job *bsg_job = sp->u.bsg_cmd.bsg_job;
> +	struct fc_bsg_request *request = bsg_job->request;
> +	struct qla_bsg_auth_els_request *p =
> +	    (struct qla_bsg_auth_els_request *)bsg_job->request;
> +
> +	a->tx_len = a->tx_byte_count = sp->remap.req.len;
> +	a->tx_addr = sp->remap.req.dma;
> +	a->rx_len = a->rx_byte_count = sp->remap.rsp.len;
> +	a->rx_addr = sp->remap.rsp.dma;
> +
> +	if (p->e.sub_cmd == SEND_ELS_REPLY) {
> +		a->control_flags = p->e.extra_control_flags << 13;
> +		a->rx_xchg_address = cpu_to_le32(p->e.extra_rx_xchg_address);
> +		if (p->e.extra_control_flags == BSG_CTL_FLAG_LS_ACC)
> +			a->els_opcode = ELS_LS_ACC;
> +		else if (p->e.extra_control_flags == BSG_CTL_FLAG_LS_RJT)
> +			a->els_opcode = ELS_LS_RJT;
> +	}
> +	a->did = sp->fcport->d_id;
> +	a->els_opcode =  request->rqst_data.h_els.command_code;
> +	a->nport_handle = cpu_to_le16(sp->fcport->loop_id);
> +	a->vp_idx = sp->vha->vp_idx;
> +}
> +
> +int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request *bsg_request = bsg_job->request;
> +	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +	fc_port_t *fcport = NULL;
> +	struct qla_hw_data *ha = vha->hw;
> +	srb_t *sp;
> +	int rval =  (DID_ERROR << 16);
> +	port_id_t d_id;
> +	struct qla_bsg_auth_els_request *p =
> +	    (struct qla_bsg_auth_els_request *)bsg_job->request;
> +
> +	d_id.b.al_pa = bsg_request->rqst_data.h_els.port_id[2];
> +	d_id.b.area = bsg_request->rqst_data.h_els.port_id[1];
> +	d_id.b.domain = bsg_request->rqst_data.h_els.port_id[0];
> +
> +	/* find matching d_id in fcport list */
> +	fcport = qla2x00_find_fcport_by_pid(vha, &d_id);
> +	if (!fcport) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911a,
> +		    "%s fcport not find online portid=%06x.\n",
> +		    __func__, d_id.b24);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		return -EIO;
> +	}
> +
> +	if (qla_bsg_check(vha, bsg_job, fcport))
> +		return 0;
> +
> +	if (fcport->loop_id == FC_NO_LOOP_ID) {
> +		ql_dbg(ql_dbg_edif, vha, 0x910d,
> +		    "%s ELS code %x, no loop id.\n", __func__,
> +		    bsg_request->rqst_data.r_els.els_code);
> +		SET_DID_STATUS(bsg_reply->result, DID_BAD_TARGET);
> +		return -ENXIO;
> +	}
> +
> +	if (!vha->flags.online) {
> +		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
> +		SET_DID_STATUS(bsg_reply->result, DID_BAD_TARGET);
> +		rval = -EIO;
> +		goto done;
> +	}
> +
> +	/* pass through is supported only for ISP 4Gb or higher */
> +	if (!IS_FWI2_CAPABLE(ha)) {
> +		ql_dbg(ql_dbg_user, vha, 0x7001,
> +		    "ELS passthru not supported for ISP23xx based adapters.\n");
> +		SET_DID_STATUS(bsg_reply->result, DID_BAD_TARGET);
> +		rval = -EPERM;
> +		goto done;
> +	}
> +
> +	/* Alloc SRB structure */
> +	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> +	if (!sp) {
> +		ql_dbg(ql_dbg_user, vha, 0x7004,
> +		    "Failed get sp pid=%06x\n", fcport->d_id.b24);
> +		rval = -ENOMEM;
> +		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
> +		goto done;
> +	}
> +
> +	sp->remap.req.len = bsg_job->request_payload.payload_len;
> +	sp->remap.req.buf = dma_pool_alloc(ha->purex_dma_pool,
> +	    GFP_KERNEL, &sp->remap.req.dma);
> +	if (!sp->remap.req.buf) {
> +		ql_dbg(ql_dbg_user, vha, 0x7005,
> +		    "Failed allocate request dma len=%x\n",
> +		    bsg_job->request_payload.payload_len);
> +		rval = -ENOMEM;
> +		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
> +		goto done_free_sp;
> +	}
> +
> +	sp->remap.rsp.len = bsg_job->reply_payload.payload_len;
> +	sp->remap.rsp.buf = dma_pool_alloc(ha->purex_dma_pool,
> +	    GFP_KERNEL, &sp->remap.rsp.dma);
> +	if (!sp->remap.rsp.buf) {
> +		ql_dbg(ql_dbg_user, vha, 0x7006,
> +		    "Failed allocate response dma len=%x\n",
> +		    bsg_job->reply_payload.payload_len);
> +		rval = -ENOMEM;
> +		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
> +		goto done_free_remap_req;
> +	}
> +	/*
> +	 * ql_print_bsg_sglist(ql_dbg_user, vha, 0x7008,
> +	 *     "SG bsg->request", &bsg_job->request_payload);
> +	 */

remove debug prints or move message to debug bits that gets printed only 
during debug options.

> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, sp->remap.req.buf,
> +	    sp->remap.req.len);
> +	sp->remap.remapped = true;
> +	/*
> +	 * ql_dump_buffer(ql_dbg_edif, vha, 0x70e0,
> +	 * sp->remap.req.buf, bsg_job->request_payload.payload_len);
> +	 */
> +

ditto here ... remove debug prints or move it debug bits which can be 
useful while debugging.

> +	sp->type = SRB_ELS_CMD_HST_NOLOGIN;
> +	sp->name = "SPCN_BSG_HST_NOLOGIN";
> +	sp->u.bsg_cmd.bsg_job = bsg_job;
> +	qla_parse_auth_els_ctl(sp);
> +
> +	sp->free = qla2x00_bsg_sp_free;
> +	sp->done = qla2x00_bsg_job_done;
> +
> +	rval = qla2x00_start_sp(sp);
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x700a,
> +	    "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
> +	    __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
> +	    p->e.extra_rx_xchg_address, p->e.extra_control_flags,
> +	    sp->handle, sp->remap.req.len, bsg_job);
> +
> +	if (rval != QLA_SUCCESS) {
> +		ql_log(ql_log_warn, vha, 0x700e,
> +		    "qla2x00_start_sp failed = %d\n", rval);
> +		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
> +		rval = -EIO;
> +		goto done_free_remap_rsp;
> +	}
> +	return rval;
> +
> +done_free_remap_rsp:
> +	dma_pool_free(ha->purex_dma_pool, sp->remap.rsp.buf,
> +	    sp->remap.rsp.dma);
> +done_free_remap_req:
> +	dma_pool_free(ha->purex_dma_pool, sp->remap.req.buf,
> +	    sp->remap.req.dma);
> +done_free_sp:
> +	qla2x00_rel_sp(sp);
> +
> +done:
> +	return rval;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
> index dc0a08570a0b..12607218df17 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.h
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -29,4 +29,42 @@ struct edif_dbell {
>   	struct	completion	dbell;		/* doorbell ring */
>   };
>   
> +#define        MAX_PAYLOAD     1024
> +#define        PUR_GET         1
> +
> +#define	LSTATE_OFF	1	// node not on list
> +#define	LSTATE_ON	2	// node on list
> +#define	LSTATE_DEST	3	// node destoyed
> +

fix comments

> +struct dinfo {
> +	int		nodecnt;	// create seq count
> +	int		lstate;		// node's list state
> +};
> +

fix comments


> +struct pur_ninfo {
> +	unsigned int	pur_pend:1;
> +	port_id_t       pur_sid;
> +	port_id_t	pur_did;
> +	uint8_t		vp_idx;
> +	short           pur_bytes_rcvd;
> +	unsigned short  pur_nphdl;
> +	unsigned int    pur_rx_xchg_address;
> +};
> +
> +struct purexevent {
> +	struct  pur_ninfo	pur_info;
> +	unsigned char		*msgp;
> +	u32			msgp_len;
> +};
> +
> +#define	N_UNDEF		0	// node not used/defined
> +#define	N_PUREX		1	// purex info

fix comments

> +struct enode {
> +	struct list_head	list;
> +	struct dinfo		dinfo;
> +	uint32_t		ntype;
> +	union {
> +		struct purexevent	purexinfo;
> +	} u;
> +};
>   #endif	/* __QLA_EDIF_H */
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 02c10caed18b..7ff05aa10b2d 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -130,6 +130,8 @@ void qla24xx_free_purex_item(struct purex_item *item);
>   extern bool qla24xx_risc_firmware_invalid(uint32_t *);
>   void qla_init_iocb_limit(scsi_qla_host_t *);
>   
> +int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsgjob);
> +const char *sc_to_str(uint16_t cmd);
>   
>   /*
>    * Global Data in qla_os.c source file.
> @@ -282,7 +284,8 @@ extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
>   /*
>    * Global Function Prototypes in qla_iocb.c source file.
>    */
> -
> +void qla_els_pt_iocb(struct scsi_qla_host *vha,
> +	struct els_entry_24xx *pkt, struct qla_els_pt_arg *a);
>   extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
>   extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
>   extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
> @@ -953,6 +956,7 @@ extern void qla_nvme_abort_process_comp_status
>   
>   /* nvme.c */
>   void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> +fc_port_t *qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id);
>   void qla_edb_stop(scsi_qla_host_t *vha);
>   int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
>   void qla_enode_init(scsi_qla_host_t *vha);
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 38b5bdde2405..6f996fb5e8f9 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -3102,6 +3102,44 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
>   	return rval;
>   }
>   
> +/* it is assume qpair lock is held */
> +void qla_els_pt_iocb(struct scsi_qla_host *vha,
> +	struct els_entry_24xx *els_iocb,
> +	struct qla_els_pt_arg *a)
> +{
> +	els_iocb->entry_type = ELS_IOCB_TYPE;
> +	els_iocb->entry_count = 1;
> +	els_iocb->sys_define = 0;
> +	els_iocb->entry_status = 0;
> +	els_iocb->handle = QLA_SKIP_HANDLE;
> +	els_iocb->nport_handle = a->nport_handle;
> +	// no need for endiance conversion.

fix or remove extra comment

> +	els_iocb->rx_xchg_address = a->rx_xchg_address;
> +	els_iocb->tx_dsd_count = cpu_to_le16(1);
> +	els_iocb->vp_index = a->vp_idx;
> +	els_iocb->sof_type = EST_SOFI3;
> +	els_iocb->rx_dsd_count = cpu_to_le16(0);
> +	els_iocb->opcode = a->els_opcode;
> +
> +	els_iocb->d_id[0] = a->did.b.al_pa;
> +	els_iocb->d_id[1] = a->did.b.area;
> +	els_iocb->d_id[2] = a->did.b.domain;
> +	/* For SID the byte order is different than DID */
> +	els_iocb->s_id[1] = vha->d_id.b.al_pa;
> +	els_iocb->s_id[2] = vha->d_id.b.area;
> +	els_iocb->s_id[0] = vha->d_id.b.domain;
> +
> +	els_iocb->control_flags = cpu_to_le16(a->control_flags);
> +
> +	els_iocb->tx_byte_count = cpu_to_le32(a->tx_byte_count);
> +	els_iocb->tx_len = cpu_to_le32(a->tx_len);
> +	put_unaligned_le64(a->tx_addr, &els_iocb->tx_address);
> +
> +	els_iocb->rx_byte_count = cpu_to_le32(a->rx_byte_count);
> +	els_iocb->rx_len = cpu_to_le32(a->rx_len);
> +	put_unaligned_le64(a->rx_addr, &els_iocb->rx_address);
> +}
> +
>   static void
>   qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>   {
> @@ -3800,6 +3838,10 @@ qla2x00_start_sp(srb_t *sp)
>   	case SRB_ELS_CMD_HST:
>   		qla24xx_els_iocb(sp, pkt);
>   		break;
> +	case SRB_ELS_CMD_HST_NOLOGIN:
> +		qla_els_pt_iocb(sp->vha, pkt,  &sp->u.bsg_cmd.u.els_arg);
> +		((struct els_entry_24xx *)pkt)->handle = sp->handle;
> +		break;
>   	case SRB_CT_CMD:
>   		IS_FWI2_CAPABLE(ha) ?
>   		    qla24xx_ct_iocb(sp, pkt) :
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 6e8f737a4af3..a130a2db2cba 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1971,7 +1971,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
>   }
>   
>   static void
> -qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
> +qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
>       struct sts_entry_24xx *pkt, int iocb_type)
>   {
>   	struct els_sts_entry_24xx *ese = (struct els_sts_entry_24xx *)pkt;
> @@ -1982,18 +1982,58 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
>   	struct fc_bsg_reply *bsg_reply;
>   	uint16_t comp_status;
>   	uint32_t fw_status[3];
> -	int res;
> +	int res, logit = 1;
>   	struct srb_iocb *els;
> +	uint n;
> +	scsi_qla_host_t *vha;
> +	struct els_sts_entry_24xx *e = (struct els_sts_entry_24xx *)pkt;
>   
> -	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
> +	sp = qla2x00_get_sp_from_handle(v, func, req, pkt);
>   	if (!sp)
>   		return;
> +	bsg_job = sp->u.bsg_job;
> +	vha = sp->vha;
>   
>   	type = NULL;
> +
> +	comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
> +	fw_status[1] = le32_to_cpu(((struct els_sts_entry_24xx *)pkt)->error_subcode_1);
> +	fw_status[2] = le32_to_cpu(((struct els_sts_entry_24xx *)pkt)->error_subcode_2);
> +
>   	switch (sp->type) {
>   	case SRB_ELS_CMD_RPT:
>   	case SRB_ELS_CMD_HST:
> +		type = "rpt hst";
> +		break;
> +	case SRB_ELS_CMD_HST_NOLOGIN:
>   		type = "els";
> +		{
> +			struct els_entry_24xx *els = (void *)pkt;
> +			struct qla_bsg_auth_els_request *p =
> +				(struct qla_bsg_auth_els_request *)bsg_job->request;
> +
> +			ql_dbg(ql_dbg_user, vha, 0x700f,
> +			     "%s %s. portid=%02x%02x%02x status %x xchg %x bsg ptr %p\n",
> +			     __func__, sc_to_str(p->e.sub_cmd),
> +			     e->d_id[2], e->d_id[1], e->d_id[0],
> +			     comp_status, p->e.extra_rx_xchg_address, bsg_job);
> +
> +			if (!(le16_to_cpu(els->control_flags) & ECF_PAYLOAD_DESCR_MASK)) {
> +				if (sp->remap.remapped) {
> +					n = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +						bsg_job->reply_payload.sg_cnt,
> +						sp->remap.rsp.buf,
> +						sp->remap.rsp.len);
> +					ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x700e,
> +					   "%s: SG copied %x of %x\n",
> +					   __func__, n, sp->remap.rsp.len);
> +				} else {
> +					ql_dbg(ql_dbg_user, vha, 0x700f,
> +					   "%s: NOT REMAPPED (error)...!!!\n",
> +					   __func__);
> +				}
> +			}
> +		}
>   		break;
>   	case SRB_CT_CMD:
>   		type = "ct pass-through";
> @@ -2023,10 +2063,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
>   		return;
>   	}
>   
> -	comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
> -	fw_status[1] = le32_to_cpu(ese->error_subcode_1);
> -	fw_status[2] = le32_to_cpu(ese->error_subcode_2);
> -
>   	if (iocb_type == ELS_IOCB_TYPE) {
>   		els = &sp->u.iocb_cmd;
>   		els->u.els_plogi.fw_status[0] = cpu_to_le32(fw_status[0]);
> @@ -2040,15 +2076,52 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
>   				res =  DID_OK << 16;
>   				els->u.els_plogi.len = cpu_to_le16(le32_to_cpu(
>   					ese->total_byte_count));
> +
> +				if (sp->remap.remapped &&
> +				    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_ACC) {
> +					ql_dbg(ql_dbg_user, vha, 0x503f,
> +					    "%s IOCB Done LS_ACC %02x%02x%02x -> %02x%02x%02x",
> +					    __func__, e->s_id[0], e->s_id[2], e->s_id[1],
> +					    e->d_id[2], e->d_id[1], e->d_id[0]);
> +					logit = 0;
> +				}
> +
> +			} else if (comp_status == CS_PORT_LOGGED_OUT) {
> +				els->u.els_plogi.len = 0;
> +				res = DID_IMM_RETRY << 16;
>   			} else {
>   				els->u.els_plogi.len = 0;
>   				res = DID_ERROR << 16;
>   			}
> +
> +			if (logit) {
> +				if (sp->remap.remapped &&
> +				    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_RJT) {
> +					ql_dbg(ql_dbg_user, vha, 0x503f,
> +					    "%s IOCB Done LS_RJT hdl=%x comp_status=0x%x\n",
> +					    type, sp->handle, comp_status);
> +
> +					ql_dbg(ql_dbg_user, vha, 0x503f,
> +					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
> +					    fw_status[1], fw_status[2],
> +					    le32_to_cpu(((struct els_sts_entry_24xx *)
> +						pkt)->total_byte_count),
> +					    e->s_id[0], e->s_id[2], e->s_id[1],
> +					    e->d_id[2], e->d_id[1], e->d_id[0]);

above message can be optimized.

> +				} else {
> +					ql_log(ql_log_info, vha, 0x503f,
> +					    "%s IOCB Done hdl=%x comp_status=0x%x\n",
> +					    type, sp->handle, comp_status);
> +					ql_log(ql_log_info, vha, 0x503f,
> +					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
> +					    fw_status[1], fw_status[2],
> +					    le32_to_cpu(((struct els_sts_entry_24xx *)
> +						pkt)->total_byte_count),
> +					    e->s_id[0], e->s_id[2], e->s_id[1],
> +					    e->d_id[2], e->d_id[1], e->d_id[0]);

same here.. message should be optimized to use same print type as portid

> +				}
> +			} //logit

unnecessary comment, remove it or fix it

>   		}
> -		ql_dbg(ql_dbg_disc, vha, 0x503f,
> -		    "ELS IOCB Done -%s hdl=%x comp_status=0x%x error subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
> -		    type, sp->handle, comp_status, fw_status[1], fw_status[2],
> -		    le32_to_cpu(ese->total_byte_count));
>   		goto els_ct_done;
>   	}
>   
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 4eab564ea6a0..5e39977af9ba 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3460,6 +3460,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	return 0;
>   
>   probe_failed:
> +	qla_enode_stop(base_vha);
>   	if (base_vha->gnl.l) {
>   		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
>   				base_vha->gnl.l, base_vha->gnl.ldma);
> @@ -3762,6 +3763,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
>   
>   	base_vha->gnl.l = NULL;
> +	qla_enode_stop(base_vha);
>   
>   	vfree(base_vha->scan.l);
>   
> @@ -4264,8 +4266,36 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
>   		goto fail_flt_buffer;
>   	}
>   
> +	/* allocate the purex dma pool */
> +	ha->purex_dma_pool = dma_pool_create(name, &ha->pdev->dev,
> +	    MAX_PAYLOAD, 8, 0);
> +
> +	if (!ha->purex_dma_pool) {
> +		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
> +		    "Unable to allocate purex_dma_pool.\n");
> +		goto fail_flt;
> +	}
> +
> +	ha->elsrej.size = sizeof(struct fc_els_ls_rjt) + 16;
> +	ha->elsrej.c = dma_alloc_coherent(&ha->pdev->dev,
> +	    ha->elsrej.size, &ha->elsrej.cdma, GFP_KERNEL);
> +
> +	if (!ha->elsrej.c) {
> +		ql_dbg_pci(ql_dbg_init, ha->pdev, 0xffff,
> +		    "Alloc failed for els reject cmd.\n");
> +		goto fail_elsrej;
> +	}
> +	ha->elsrej.c->er_cmd = ELS_LS_RJT;
> +	ha->elsrej.c->er_reason = ELS_RJT_BUSY;
> +	ha->elsrej.c->er_explan = ELS_EXPL_UNAB_DATA;
>   	return 0;
>   
> +fail_elsrej:
> +	dma_pool_destroy(ha->purex_dma_pool);
> +fail_flt:
> +	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
> +	    ha->flt, ha->flt_dma);
> +
>   fail_flt_buffer:
>   	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
>   	    ha->sfp_data, ha->sfp_data_dma);
> @@ -4776,6 +4806,16 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>   	if (ha->init_cb)
>   		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
>   			ha->init_cb, ha->init_cb_dma);
> +
> +	dma_pool_destroy(ha->purex_dma_pool);
> +	ha->purex_dma_pool = NULL;
> +
> +	if (ha->elsrej.c) {
> +		dma_free_coherent(&ha->pdev->dev, ha->elsrej.size,
> +		    ha->elsrej.c, ha->elsrej.cdma);
> +		ha->elsrej.c = NULL;
> +	}
> +
>   	ha->init_cb = NULL;
>   	ha->init_cb_dma = 0;
>   
> @@ -4837,6 +4877,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
>   	spin_lock_init(&vha->cmd_list_lock);
>   	init_waitqueue_head(&vha->fcport_waitQ);
>   	init_waitqueue_head(&vha->vref_waitq);
> +	qla_enode_init(vha);
>   
>   	vha->gnl.size = sizeof(struct get_name_list_extended) *
>   			(ha->max_loop_id + 1);
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index b2008fb1dd38..abf18b88579c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -184,8 +184,7 @@ static inline int qlt_issue_marker(struct scsi_qla_host *vha, int vha_locked)
>   	return QLA_SUCCESS;
>   }
>   
> -static inline
> -struct scsi_qla_host *qlt_find_host_by_d_id(struct scsi_qla_host *vha,
> +struct scsi_qla_host *qla_find_host_by_d_id(struct scsi_qla_host *vha,
>   					    be_id_t d_id)
>   {
>   	struct scsi_qla_host *host;
> @@ -299,7 +298,7 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
>   			goto abort;
>   		}
>   
> -		host = qlt_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
> +		host = qla_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
>   		if (host != NULL) {
>   			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x502f,
>   			    "Requeuing unknown ATIO_TYPE7 %p\n", u);
> @@ -348,7 +347,7 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
>   	switch (atio->u.raw.entry_type) {
>   	case ATIO_TYPE7:
>   	{
> -		struct scsi_qla_host *host = qlt_find_host_by_d_id(vha,
> +		struct scsi_qla_host *host = qla_find_host_by_d_id(vha,
>   		    atio->u.isp24.fcp_hdr.d_id);
>   		if (unlikely(NULL == host)) {
>   			ql_dbg(ql_dbg_tgt, vha, 0xe03e,
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
