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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A456CC07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 13:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DF1613DE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 13:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhFDNUO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 09:20:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45292 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhFDNUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 09:20:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154DDxa5128693;
        Fri, 4 Jun 2021 13:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jjweWe5m/u+Sz5Oz5CR9aqebjravRw+En4a52JUxvxc=;
 b=FjJ6VMcwIjGeTLkz9MQ6Wz/ZSjJj2qkW2Ms8yCET2IEA1aSu0B/mkF+QU7PAfxpSapha
 +J72Q5vHTFaZsH0IHA1JMyw1o/jUXAL1Tw+KM1Ekvc1G/R7OxceC9Abj7ol0aScmlEOw
 wFCuegrPNK7bRS/oD4yQVf4gDO1xso7JFbUAacoablaPWgBD87xsMxklFb+S/i0Ud7i7
 1eEd+yRGn/F21izs7yFXfl2NwadtXRCFffiHw2cG/ySlqZ7OhoAH8pYLCDNe7GcgXchj
 evBmfuy0qXl6ZrftWmzV4/7oByVufslRCU3ZIjMBy9SX9l3TQCYZ+2+Rzk0SC0gnod/w Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ue8pnx46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 13:18:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154DFacw038378;
        Fri, 4 Jun 2021 13:18:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 38xyn3jpcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 13:18:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dp4H4Mn9jSgV+KLScOOnTdxA++mqZ0+Onbak1f1WfnEU+DCTZNY3QLsCAdzy5cjIzt2Wm/geWJrBq+vNsQ9yEPrstQ9daKU+5CKmhoYt6Xdi58lZs9BzA9eWfRhxKlfYrF7h3XjG3pNrfp6zxNjH2v0t1vdUykB73Oym4pkShxH/1NWMDpStJ+J0Xf95e3Oh2xmPWrr3Dn1jBDJlwFKtzh0v6isu6e+IMSVKQulvPrW8pGlBpENW9ZI8q1XVMLAfoZ9XSw/nOA+SXr5wNvDRw8DXWZPnYslTv+HMUqxynZi6TQ3EZKmcsdADnA/fw40N0HHy42gSqnpIzWNtx5AUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjweWe5m/u+Sz5Oz5CR9aqebjravRw+En4a52JUxvxc=;
 b=XstIcsmmBQ1JraoTL1didm55GDGBRztcIGR30diiDgxaAVVESpdUX9u2To5yDMUNExxfI8SbZzoXBt+hBpooPc6YIRlyJ/3VzewoJRhHKvqDME77+2Dp11NUQ+zoRtmY3z+mjtnc2R1l1tsYjMCP9i0XptUcGVychNediAHDWcaZXKNzEJbb9BCM8y4ouRh5VtpX9I+sKZa+L7jdDcMcGRzEW79DilltzD/m8X3wJT1PLKOeheCUb4NB4x+7gftSmgIheWtG3i5YvyVmY4DqN66qwjf7YC7S1bLUxKxnBzffFVH7zsO4SfNa6zLNtxFJSH+XEy81Nn3WmQph2YCZ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjweWe5m/u+Sz5Oz5CR9aqebjravRw+En4a52JUxvxc=;
 b=D1PMaMTH7iOX1dc9g3mD4ngO9aQJWrkoDvK3hOu1MAvTpc4vD8ZmxrWUP8joMGaLGRlEjJc0YEnHtBYI0Wpza4KzYcsC2KEp0fywmc+sslxY3IjmhXyyPI4T47xUUX8x7BLOn3skGLhxi7EUlLBJ+xHF+O/3V1uqQFlwC660Tdg=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2991.namprd10.prod.outlook.com (2603:10b6:805:d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 4 Jun
 2021 13:18:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 13:18:12 +0000
Subject: Re: [PATCH v2 07/10] qla2xxx: Add detection of secure device
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-8-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <4e2a7373-178c-0e47-ffe6-c832a9b69c9e@oracle.com>
Date:   Fri, 4 Jun 2021 08:18:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN6PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:805:f2::29) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN6PR04CA0088.namprd04.prod.outlook.com (2603:10b6:805:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 13:18:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d2b1dd-9c63-45f0-7d9b-08d9275b3423
X-MS-TrafficTypeDiagnostic: SN6PR10MB2991:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2991B3B8F0DDE5CD6C599AFDE63B9@SN6PR10MB2991.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eryJLjFf1lFcSXdquqrEJ3H7fb3I6eh3n3LmcngzJgJvVLe2UKrJ+dCILNrIBNIUADFX9lhJUnCQQWJnlUTqbIq2t5eW+/8nPNH0/tKcjODC1U3Ghuw8NK7iL6vrFmVbFnEESCxTU6TOP3DFEEMN9dc8wmgKNcq8d7Vlc3xrN2OPr+d/SYtlBQcUwoGYiszJ7j6rn2V+1xr8q4o7j44szZqSJ3rUB+Clh6v2TZgkNZxqPFB7Mb+dYokXDteenxRrjORdWFkQVM8EXwyfz/Tv+/RQblRt8npgndjI55FXWbg5PdvWxGI57Ogf1Fp9ii2Ol9etB5tmOfu+VROQ8kZ4scthno13Zd/Fzzb/OT4mFeitUVY7GDngmJlK9O41XylLRDQCF5qsO/hdVvAoMqxRiFoCWROBC62u8ygW54aqRRJNikOKaaRTmV0ij6qezZa/jRxOU9AMjq/hbo9o15FAiQrEphka9eNP0ifreeFW4U4P5s3lHIl4R0aRBkeUYRVHTHZgyndjiS67C16o+bVI+Fe0vyZl5imM+b/cUBsBiDJX/NVEoEUn/ljoUu5o/Ddy6ywjsn8W+KC5xMZgkNa+XwEl4K8yEPB60vRD9lkALWN+/j9U//fKL/bGQ1uHzcRxMmo5MmvoE/IoyiCh9Ayt8U1UUQMoZov3TDv5YbQ9loOA1nC0D7ncwL77fm53q7LO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(6486002)(6636002)(4326008)(316002)(53546011)(26005)(30864003)(66476007)(16576012)(66556008)(66946007)(5660300002)(31686004)(36756003)(956004)(36916002)(31696002)(44832011)(2906002)(83380400001)(86362001)(2616005)(8676002)(16526019)(186003)(478600001)(8936002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q1hJNTE4RXNHRTd3YWl1Q3BNcko5d0J6UzNVd0NKVVFBYW9jejl1czNLTkFW?=
 =?utf-8?B?SUsyRTNyZktoZER6SkhPNm01TmNkSkdBSmhDWEFUUnFoUmxHTk1tdHVrbjhk?=
 =?utf-8?B?ZDVORXRvZVBuMDBRVGlBeVZxc29uRm9TZUxPU1dIWmYzQkxqWFZyWnNwSUxL?=
 =?utf-8?B?RjFKOUg4bGpGaTFYdWRhVmNXaEpPLzZhS0V3eWRsb2E5UmJta3hIbCtZbnl1?=
 =?utf-8?B?VDFidm5NSE1pUWtsRkJTc0NnZm9vd1ROcUo2OWRyRXY5NFcwQ0dXYUNnSzli?=
 =?utf-8?B?cktOaUpRdkpRK010QU0vT3FMUWIxamtyaTVhZURVQnRxdmd0U05PNGkxVjZw?=
 =?utf-8?B?Sm9jdk9xTHJDYldNZ1RiRTJsM25oa0ZLUUMvU3dxc1hJUVlSQ2dqaVlaOEMz?=
 =?utf-8?B?cTRQMFlvaG1VMVZxaFp6Q0g5MDRSbTFyZWxZOGxuQ2JXcS9UOVErL3NCSjBx?=
 =?utf-8?B?Z01kYXVSd2tVbHc1VFJhWEtJWDluTWlQQ1pPTnkwN09hSGIvMXFWaU1YRHdv?=
 =?utf-8?B?L1FIVHNaejFtZG85Sy9YblhoY2FJb3JEdGZpVXEremVyVUhjRk9XcDdFczZN?=
 =?utf-8?B?T05maDM2L2hLaVByOGY3RnZZSm1uWDVEQitoaTRvR0ZBbWlpNWNEYWxlcVIv?=
 =?utf-8?B?WWNlcHk2QnZsZFBjaks5VTNmZ3JtUXVUL0ZlWFlMYy9adlo3QTVxaFc1NGxu?=
 =?utf-8?B?Ti84SGcreUYxVFJBV2NOYXY0UWVuRXpxQXlKdnhzTm1YN3dFUTNhOFM2bzVB?=
 =?utf-8?B?aGQvQk1pbXNXeHFkK0tGYzZiMTlUZ3dsY2VkVitXbW1tQWJjd0F0cGNvbXIv?=
 =?utf-8?B?OFJXcnpETWNMTDBCUXBhcStUT0plUng1anlqSlBGbmt6RWtXaWhRQk16S1do?=
 =?utf-8?B?TWEyNjd0Q2tCeWJlb1F4R3JaakJtQk02bzBNQW9iOEpNU2J5M3VoS0RkZ3du?=
 =?utf-8?B?Z0lSUDg0UnRFSGZtbTZ4MEIyVUR0MERHUmlqSW02WHQ0bzVIMWJvZmRIRTA3?=
 =?utf-8?B?ZkIrOFJBR0ZhWHplQktZV1pZWUp1Zys4eUhQeG1nako4c2hkMU9idkdsSWh4?=
 =?utf-8?B?RSt5VjNhVFFwUi84cVF6TUxwWjJRS2pqL29iSGhabXN1STNlSEFVb3NrMnRB?=
 =?utf-8?B?VGZXckdFWU5uMW9yVDFSQjVNbVl5NzN5SERRRnVsWnhRUmp5eklBMkZ6T3Zv?=
 =?utf-8?B?a0dtOThxUjd6bHRBTG1ZaE5leFB2VHoyM2tGNVltL0FsWjZ2VDd4cjc3Qkd2?=
 =?utf-8?B?eWR1aGFwVUZnQnl0Ny9vdWxpZXg1ZXlBYkhabWNXaHQxd1hENDB2cmFvaXZL?=
 =?utf-8?B?L1k4RHBmQTRpclBKVmw0RVI1a2QzbndWMWtTeGpnSEhyRCtFbnFtTTMwM3F0?=
 =?utf-8?B?U05rek5uYjFxNjJ1OTBZRDBsNVhJaDlRbzM1VllSTnByZk02K1JoMW1qTWdM?=
 =?utf-8?B?Q1ZmYzZ2YVZ4SklkNFgrVnRHL0FndkRHREcxVmdWQlR2VGt3ZjZJdFJEeno1?=
 =?utf-8?B?YXordHdWMVhQOXpFZHIrbHdYM2ZSMkk1cHFHZDNCNTJkaXlwOE9sUjBDaE9z?=
 =?utf-8?B?L2U3MHFRVlN5Y1o2dmMxSVB0SUJLWW1xdWhHejhoNGhrSk5HdnRHU21mTDVB?=
 =?utf-8?B?bDRhdU5qaUFIeTRLdGVjcmlLL1NiZzArN3ZMRGk4U2hRUGlRdjFEUmJHSkh6?=
 =?utf-8?B?ZmZVQStubEw4U1l1YldHRkw4QVhGZGFXc290dFJncmxYZjJPQytqajd2LzFR?=
 =?utf-8?Q?C8SL5ljdp2NiUiKWO+523v8juH2hB+BTITOc/0E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d2b1dd-9c63-45f0-7d9b-08d9275b3423
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 13:18:12.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VaAv/aYhVRNbzNyKsWmzRcKptmWXZiXERC0FUEDJg/u1Yg2Mv1CZp7pG1+21FWX9/plMs2sD7Pls6Tv7hds8CQTnPN+A1Lva8ZuNsRklFwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2991
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040104
X-Proofpoint-GUID: 5_Esd37IMWvSPrUTJvIZJ34nh3jgH987
X-Proofpoint-ORIG-GUID: 5_Esd37IMWvSPrUTJvIZJ34nh3jgH987
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040104
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
> At this time, there is no FC switch scan service that
> indicate a device is secure or non-secure.
> 
> In order to detect whether the remote port support secured
> or not, driver must first do a PLOGI with the remote device.
> On completion of the PLOGI, driver will query FW to see if
> the device supports secure login. To do that, driver + FW
> must advertise the security bit via PLOGI's service
> parameter. The remote device shall respond with the same
> service parameter bit on whether it supports it or not.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h    |   5 +-
>   drivers/scsi/qla2xxx/qla_edif.c   |  31 +++++++
>   drivers/scsi/qla2xxx/qla_fw.h     |   8 +-
>   drivers/scsi/qla2xxx/qla_gbl.h    |   3 +
>   drivers/scsi/qla2xxx/qla_gs.c     |   4 +
>   drivers/scsi/qla2xxx/qla_init.c   | 142 +++++++++++++++++++++++++-----
>   drivers/scsi/qla2xxx/qla_iocb.c   |  17 +++-
>   drivers/scsi/qla2xxx/qla_isr.c    |   4 +
>   drivers/scsi/qla2xxx/qla_mbx.c    |   6 ++
>   drivers/scsi/qla2xxx/qla_mid.c    |   7 +-
>   drivers/scsi/qla2xxx/qla_os.c     |  20 ++++-
>   drivers/scsi/qla2xxx/qla_target.c |  61 ++++++++++++-
>   drivers/scsi/qla2xxx/qla_target.h |   1 +
>   13 files changed, 280 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 164b87fd66ba..669a2399e67f 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -492,6 +492,7 @@ struct srb_iocb {
>   #define SRB_LOGIN_SKIP_PRLI	BIT_2
>   #define SRB_LOGIN_NVME_PRLI	BIT_3
>   #define SRB_LOGIN_PRLI_ONLY	BIT_4
> +#define SRB_LOGIN_FCSP		BIT_5
>   			uint16_t data[2];
>   			u32 iop[2];
>   		} logio;
> @@ -2343,6 +2344,7 @@ struct imm_ntfy_from_isp {
>   			__le16	nport_handle;
>   			uint16_t reserved_2;
>   			__le16	flags;
> +#define NOTIFY24XX_FLAGS_FCSP		BIT_5
>   #define NOTIFY24XX_FLAGS_GLOBAL_TPRLO   BIT_1
>   #define NOTIFY24XX_FLAGS_PUREX_IOCB     BIT_0
>   			__le16	srr_rx_id;
> @@ -2683,7 +2685,8 @@ static const char * const port_dstate_str[] = {
>   	"UPD_FCPORT",
>   	"LOGIN_COMPLETE",
>   	"ADISC",
> -	"DELETE_PEND"
> +	"DELETE_PEND",
> +	"LOGIN_AUTH_PEND",
>   };
>   
>   /*
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index c86d64512702..0fa6a1420c30 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2405,6 +2405,26 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
>   	sp->done(sp, 0);
>   }
>   
> +/**********************************************
> + * edif update/delete sa_index list functions *
> + **********************************************/
> +
> +/* clear the edif_indx_list for this port */
> +void qla_edif_list_del(fc_port_t *fcport)
> +{
> +	struct edif_list_entry *indx_lst;
> +	struct edif_list_entry *tindx_lst;
> +	struct list_head *indx_list = &fcport->edif.edif_indx_list;
> +	unsigned long flags = 0;
> +
> +	list_for_each_entry_safe(indx_lst, tindx_lst, indx_list, next) {
> +		spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
> +		list_del(&indx_lst->next);
> +		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
> +		kfree(indx_lst);
> +	}
> +}
> +
>   /******************
>    * SADB functions *
>    ******************/
> @@ -2844,3 +2864,14 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>   done:
>   	return rval;
>   }
> +
> +void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
> +{
> +	if (sess->edif.app_sess_online && vha->e_dbell.db_flags & EDB_ACTIVE) {
> +		ql_dbg(ql_dbg_disc, vha, 0xf09c,
> +			"%s: sess %8phN send port_offline event\n",
> +			__func__, sess->port_name);
> +		sess->edif.app_sess_online = 0;
> +		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
> +	}
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index c067cd202dc4..4934b08a8990 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -82,10 +82,11 @@ struct port_database_24xx {
>   	uint8_t port_name[WWN_SIZE];
>   	uint8_t node_name[WWN_SIZE];
>   
> -	uint8_t reserved_3[4];
> +	uint8_t reserved_3[2];
> +	uint16_t nvme_first_burst_size;
>   	uint16_t prli_nvme_svc_param_word_0;	/* Bits 15-0 of word 0 */
>   	uint16_t prli_nvme_svc_param_word_3;	/* Bits 15-0 of word 3 */
> -	uint16_t nvme_first_burst_size;
> +	uint8_t secure_login;
>   	uint8_t reserved_4[14];
>   };
>   
> @@ -897,6 +898,7 @@ struct logio_entry_24xx {
>   #define LCF_FCP2_OVERRIDE	BIT_9	/* Set/Reset word 3 of PRLI. */
>   #define LCF_CLASS_2		BIT_8	/* Enable class 2 during PLOGI. */
>   #define LCF_FREE_NPORT		BIT_7	/* Release NPORT handle after LOGO. */
> +#define LCF_COMMON_FEAT		BIT_7	/* PLOGI - Set Common Features Field */
>   #define LCF_EXPL_LOGO		BIT_6	/* Perform an explicit LOGO. */
>   #define LCF_NVME_PRLI		BIT_6   /* Perform NVME FC4 PRLI */
>   #define LCF_SKIP_PRLI		BIT_5	/* Skip PRLI after PLOGI. */
> @@ -921,6 +923,8 @@ struct logio_entry_24xx {
>   	uint8_t rsp_size;		/* Response size in 32bit words. */
>   
>   	__le32	io_parameter[11];	/* General I/O parameters. */
> +#define LIO_COMM_FEAT_FCSP	BIT_21
> +#define LIO_COMM_FEAT_CIO	BIT_31
>   #define LSC_SCODE_NOLINK	0x01
>   #define LSC_SCODE_NOIOCB	0x02
>   #define LSC_SCODE_NOXCB		0x03
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 236eb610b5be..c695f5a58d4d 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -131,6 +131,7 @@ void qla24xx_free_purex_item(struct purex_item *item);
>   extern bool qla24xx_risc_firmware_invalid(uint32_t *);
>   void qla_init_iocb_limit(scsi_qla_host_t *);
>   
> +void qla_edif_list_del(fc_port_t *fcport);
>   void qla_edif_sadb_release(struct qla_hw_data *ha);
>   int qla_edif_sadb_build_free_pool(struct qla_hw_data *ha);
>   void qla_edif_sadb_release_free_pool(struct qla_hw_data *ha);
> @@ -138,7 +139,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
>   		srb_t *sp, struct sts_entry_24xx *sts24);
>   void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
>   		struct ctio7_from_24xx *ctio);
> +void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport);
>   int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsgjob);
> +void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess);
>   const char *sc_to_str(uint16_t cmd);
>   
>   /*
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 5b6e04a91a18..99fb330053ae 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -2826,6 +2826,10 @@ void qla24xx_handle_gpsc_event(scsi_qla_host_t *vha, struct event_arg *ea)
>   	if (fcport->disc_state == DSC_DELETE_PEND)
>   		return;
>   
> +	/* We will figure-out what happen after AUTH completes */
> +	if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
> +		return;
> +
>   	if (ea->sp->gen2 != fcport->login_gen) {
>   		/* target side must have changed it. */
>   		ql_dbg(ql_dbg_disc, vha, 0x20d3,
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index bd528c249aa7..7a20b1ddc63f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -342,10 +342,23 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
>   	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
>   
>   	sp->done = qla2x00_async_login_sp_done;
> -	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport))
> +	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport)) {
>   		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
> -	else
> -		lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
> +	} else {
> +		if (vha->hw->flags.edif_enabled) {
> +			if (fcport->edif.non_secured_login == 0) {
> +				lio->u.logio.flags |=
> +					(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
> +				ql_dbg(ql_dbg_disc, vha, 0x2072,
> +	"Async-login: w/ FCSP %8phC hdl=%x, loopid=%x portid=%06x\n",

fix indentation,
> +				    fcport->port_name, sp->handle,
> +				    fcport->loop_id,
> +				    fcport->d_id.b24);
> +			}
> +		} else {
> +			lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
> +		}
> +	}
>   
>   	if (NVME_TARGET(vha->hw, fcport))
>   		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
> @@ -377,7 +390,7 @@ static void qla2x00_async_logout_sp_done(srb_t *sp, int res)
>   {
>   	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
>   	sp->fcport->login_gen++;
> -	qlt_logo_completion_handler(sp->fcport, res);
> +	qlt_logo_completion_handler(sp->fcport, sp->u.iocb_cmd.u.logio.data[0]);
>   	sp->free(sp);
>   }
>   
> @@ -403,10 +416,10 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
>   	sp->done = qla2x00_async_logout_sp_done;
>   
>   	ql_dbg(ql_dbg_disc, vha, 0x2070,
> -	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
> +	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC explicit %d.\n",
>   	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
>   		fcport->d_id.b.area, fcport->d_id.b.al_pa,
> -		fcport->port_name);
> +		fcport->port_name, fcport->explicit_logout);
>   
>   	rval = qla2x00_start_sp(sp);
>   	if (rval != QLA_SUCCESS)
> @@ -691,11 +704,11 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
>   
>   	fcport = ea->fcport;
>   	ql_dbg(ql_dbg_disc, vha, 0xffff,
> -	    "%s %8phC DS %d LS rc %d %d login %d|%d rscn %d|%d lid %d\n",
> +	    "%s %8phC DS %d LS rc %d %d login %d|%d rscn %d|%d lid %d edif %d\n",
>   	    __func__, fcport->port_name, fcport->disc_state,
>   	    fcport->fw_login_state, ea->rc,
>   	    fcport->login_gen, fcport->last_login_gen,
> -	    fcport->rscn_gen, fcport->last_rscn_gen, vha->loop_id);
> +	    fcport->rscn_gen, fcport->last_rscn_gen, vha->loop_id, fcport->edif.enable);
>   
>   	if (fcport->disc_state == DSC_DELETE_PEND)
>   		return;
> @@ -821,6 +834,13 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
>   				qla2x00_post_async_adisc_work(vha, fcport,
>   				    data);
>   				break;
> +			case DSC_LS_PLOGI_COMP:
> +				if (vha->hw->flags.edif_enabled) {
> +					/* check to see if he support Secure */
> +					qla24xx_post_gpdb_work(vha, fcport, 0);
> +					break;
> +				}
> +				fallthrough;
>   			case DSC_LS_PORT_UNAVAIL:
>   			default:
>   				if (fcport->loop_id == FC_NO_LOOP_ID) {
> @@ -1417,6 +1437,57 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
>   	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>   }
>   
> +static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
> +	struct port_database_24xx *pd)
> +{
> +	int rc = 0;
> +
> +	if (pd->secure_login) {
> +		ql_dbg(ql_dbg_disc, vha, 0x104d,
> +		    "Secure Login established on %8phC\n",
> +		    fcport->port_name);
> +		fcport->edif.secured_login = 1;
> +		fcport->edif.non_secured_login = 0;
> +		fcport->flags |= FCF_FCSP_DEVICE;
> +	} else {
> +		ql_dbg(ql_dbg_disc, vha, 0x104d,
> +		    "non-Secure Login %8phC",
> +		    fcport->port_name);
> +		fcport->edif.secured_login = 0;
> +		fcport->edif.non_secured_login = 1;
> +	}
> +	if (vha->hw->flags.edif_enabled) {
> +		if (fcport->flags & FCF_FCSP_DEVICE) {
> +			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_AUTH_PEND);
> +			/* Start edif prli timer & ring doorbell for app */
> +			fcport->edif.rx_sa_set = 0;
> +			fcport->edif.tx_sa_set = 0;
> +			fcport->edif.rx_sa_pending = 0;
> +			fcport->edif.tx_sa_pending = 0;
> +
> +			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
> +			    fcport->d_id.b24);
> +
> +			if (vha->e_dbell.db_flags ==  EDB_ACTIVE) {
> +				ql_dbg(ql_dbg_disc, vha, 0x20ef,
> +				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
> +				    __func__, __LINE__, fcport->port_name);
> +				fcport->edif.app_started = 1;
> +				fcport->edif.app_sess_online = 1;
> +			}
> +
> +			rc = 1;
> +		} else {
> +			ql_dbg(ql_dbg_disc, vha, 0x2117,
> +			    "%s %d %8phC post prli\n",
> +			    __func__, __LINE__, fcport->port_name);
> +			qla24xx_post_prli_work(vha, fcport);
> +			rc = 1;
> +		}
> +	}
> +	return rc;
> +}
> +
>   static
>   void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
>   {
> @@ -1459,8 +1530,11 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
>   	case PDS_PRLI_COMPLETE:
>   		__qla24xx_parse_gpdb(vha, fcport, pd);
>   		break;
> -	case PDS_PLOGI_PENDING:
>   	case PDS_PLOGI_COMPLETE:
> +		if (qla_chk_secure_login(vha, fcport, pd))
> +			return;
> +		fallthrough;
> +	case PDS_PLOGI_PENDING:
>   	case PDS_PRLI_PENDING:
>   	case PDS_PRLI2_PENDING:
>   		/* Set discovery state back to GNL to Relogin attempt */
> @@ -2052,26 +2126,38 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
>   		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
>   		 * requests.
>   		 */
> -		if (NVME_TARGET(vha->hw, ea->fcport)) {
> -			ql_dbg(ql_dbg_disc, vha, 0x2117,
> -				"%s %d %8phC post prli\n",
> -				__func__, __LINE__, ea->fcport->port_name);
> -			qla24xx_post_prli_work(vha, ea->fcport);
> -		} else {
> -			ql_dbg(ql_dbg_disc, vha, 0x20ea,
> -			    "%s %d %8phC LoopID 0x%x in use with %06x. post gpdb\n",
> -			    __func__, __LINE__, ea->fcport->port_name,
> -			    ea->fcport->loop_id, ea->fcport->d_id.b24);
> -
> +		if (vha->hw->flags.edif_enabled) {
>   			set_bit(ea->fcport->loop_id, vha->hw->loop_id_map);
>   			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
>   			ea->fcport->chip_reset = vha->hw->base_qpair->chip_reset;
>   			ea->fcport->logout_on_delete = 1;
>   			ea->fcport->send_els_logo = 0;
> -			ea->fcport->fw_login_state = DSC_LS_PRLI_COMP;
> +			ea->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
>   			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>   
>   			qla24xx_post_gpdb_work(vha, ea->fcport, 0);
> +		} else {
> +			if (NVME_TARGET(vha->hw, fcport)) {
> +				ql_dbg(ql_dbg_disc, vha, 0x2117,
> +				    "%s %d %8phC post prli\n",
> +				    __func__, __LINE__, fcport->port_name);
> +				qla24xx_post_prli_work(vha, fcport);
> +			} else {
> +				ql_dbg(ql_dbg_disc, vha, 0x20ea,
> +				    "%s %d %8phC LoopID 0x%x in use with %06x. post gpdb\n",
> +				    __func__, __LINE__, fcport->port_name,
> +				    fcport->loop_id, fcport->d_id.b24);
> +
> +				set_bit(fcport->loop_id, vha->hw->loop_id_map);
> +				spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> +				fcport->chip_reset = vha->hw->base_qpair->chip_reset;
> +				fcport->logout_on_delete = 1;
> +				fcport->send_els_logo = 0;
> +				fcport->fw_login_state = DSC_LS_PRLI_COMP;
> +				spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> +
> +				qla24xx_post_gpdb_work(vha, fcport, 0);
> +			}
>   		}
>   		break;
>   	case MBS_COMMAND_ERROR:
> @@ -5096,8 +5182,13 @@ qla2x00_free_fcport(fc_port_t *fcport)
>   
>   		fcport->ct_desc.ct_sns = NULL;
>   	}
> +
> +	qla_edif_flush_sa_ctl_lists(fcport);
>   	list_del(&fcport->list);
>   	qla2x00_clear_loop_id(fcport);
> +
> +	qla_edif_list_del(fcport);
> +
>   	kfree(fcport);
>   }
>   
> @@ -5216,6 +5307,12 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
>   			    "LOOP READY.\n");
>   			ha->flags.fw_init_done = 1;
>   
> +			if (vha->hw->flags.edif_enabled &&
> +			    vha->e_dbell.db_flags != EDB_ACTIVE) {
> +				/* wake up authentication app to get ready */
> +				qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE, 0);
> +			}
> +
>   			/*
>   			 * Process any ATIO queue entries that came in
>   			 * while we weren't online.
> @@ -5235,7 +5332,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
>   		    "%s *** FAILED ***.\n", __func__);
>   	} else {
>   		ql_dbg(ql_dbg_disc, vha, 0x206b,
> -		    "%s: exiting normally.\n", __func__);
> +		    "%s: exiting normally. local port wwpn %8phN id %06x)\n",
> +		    __func__, vha->port_name, vha->d_id.b24);
>   	}
>   
>   	/* Restore state if a resync event occurred during processing */
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 168e7832bdfd..ba36084d17a9 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2462,6 +2462,12 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
>   			logio->control_flags |= cpu_to_le16(LCF_COND_PLOGI);
>   		if (lio->u.logio.flags & SRB_LOGIN_SKIP_PRLI)
>   			logio->control_flags |= cpu_to_le16(LCF_SKIP_PRLI);
> +		if (lio->u.logio.flags & SRB_LOGIN_FCSP) {
> +			logio->control_flags |=
> +			    cpu_to_le16(LCF_COMMON_FEAT | LCF_SKIP_PRLI);
> +			logio->io_parameter[0] =
> +			    cpu_to_le32(LIO_COMM_FEAT_FCSP | LIO_COMM_FEAT_CIO);
> +		}
>   	}
>   	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
>   	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
> @@ -2802,7 +2808,6 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>   		    (uint8_t *)els_iocb,
>   		    sizeof(*els_iocb));
>   	} else {
> -		els_iocb->control_flags = cpu_to_le16(1 << 13);
>   		els_iocb->tx_byte_count =
>   			cpu_to_le32(sizeof(struct els_logo_payload));
>   		put_unaligned_le64(elsio->u.els_logo.els_logo_pyld_dma,
> @@ -3734,6 +3739,16 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
>   	nack->u.isp24.srr_reject_code = 0;
>   	nack->u.isp24.srr_reject_code_expl = 0;
>   	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
> +
> +	if (ntfy->u.isp24.status_subcode == ELS_PLOGI &&
> +	    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP) &&
> +	    sp->vha->hw->flags.edif_enabled) {
> +		ql_dbg(ql_dbg_disc, sp->vha, 0x3074,
> +		    "%s PLOGI NACK sent with FC SECURITY bit, hdl=%x, loopid=%x, to pid %06x\n",
> +		    sp->name, sp->handle, sp->fcport->loop_id,
> +		    sp->fcport->d_id.b24);
> +		nack->u.isp24.flags |= cpu_to_le16(NOTIFY_ACK_FLAGS_FCSP);
> +	}
>   }
>   
>   /*
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index dcbee5cf4306..121adeee88cc 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2350,6 +2350,10 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
>   		if (sp->type != SRB_LOGIN_CMD)
>   			goto logio_done;
>   
> +		lio->u.logio.iop[1] = le32_to_cpu(logio->io_parameter[5]); // common features

remove debug comment

> +		if (le32_to_cpu(logio->io_parameter[5]) & LIO_COMM_FEAT_FCSP)
> +			fcport->flags |= FCF_FCSP_DEVICE;
> +
>   		iop[0] = le32_to_cpu(logio->io_parameter[0]);
>   		if (iop[0] & BIT_4) {
>   			fcport->port_type = FCT_TARGET;
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 0bcd8afdc0ff..f4b9fa9d8078 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6588,6 +6588,12 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
>   	fcport->d_id.b.al_pa = pd->port_id[2];
>   	fcport->d_id.b.rsvd_1 = 0;
>   
> +	ql_dbg(ql_dbg_disc, vha, 0x2062,
> +	     "%8phC SVC Param w3 %02x%02x",
> +	     fcport->port_name,
> +	     pd->prli_svc_param_word_3[1],
> +	     pd->prli_svc_param_word_3[0]);
> +
>   	if (NVME_TARGET(vha->hw, fcport)) {
>   		fcport->port_type = FCT_NVME;
>   		if ((pd->prli_svc_param_word_3[0] & BIT_5) == 0)
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index c7caf322f445..432fbba47922 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -158,6 +158,10 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
>   	int ret = QLA_SUCCESS;
>   	fc_port_t *fcport;
>   
> +	if (vha->hw->flags.edif_enabled)
> +		// delete sessions and flush sa_indexes

fix comment style

> +		qla2x00_wait_for_sess_deletion(vha);
> +
>   	if (vha->hw->flags.fw_started)
>   		ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
>   
> @@ -166,7 +170,8 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
>   	list_for_each_entry(fcport, &vha->vp_fcports, list)
>   		fcport->logout_on_delete = 0;
>   
> -	qla2x00_mark_all_devices_lost(vha);
> +	if (!vha->hw->flags.edif_enabled)
> +		qla2x00_wait_for_sess_deletion(vha);
>   
>   	/* Remove port id from vp target map */
>   	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 51be079fadd7..0b379ac179fa 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1119,13 +1119,28 @@ static inline int test_fcport_count(scsi_qla_host_t *vha)
>   {
>   	struct qla_hw_data *ha = vha->hw;
>   	unsigned long flags;
> -	int res;
> +	int res; // 0 = sleep, x=wake

remove debug code

>   
>   	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
>   	ql_dbg(ql_dbg_init, vha, 0x00ec,
>   	    "tgt %p, fcport_count=%d\n",
>   	    vha, vha->fcport_count);
>   	res = (vha->fcport_count == 0);
> +	if  (res) {
> +		struct fc_port *fcport;
> +
> +		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +			if (fcport->deleted != QLA_SESS_DELETED) {
> +				/* session(s) may not be fully logged in
> +				 * (ie fcport_count=0), but session
> +				 * deletion thread(s) may be inflight.
> +				 */
> +
> +				res = 0;
> +				break;
> +			}
> +		}
> +	}
>   	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
>   
>   	return res;
> @@ -3937,6 +3952,8 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
>   		qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
>   		qla2x00_schedule_rport_del(vha, fcport);
>   	}
> +
> +	qla_edif_sess_down(vha, fcport);
>   	/*
>   	 * We may need to retry the login, so don't change the state of the
>   	 * port but do the retries.
> @@ -5444,6 +5461,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
>   		if (atomic_read(&fcport->state) != FCS_ONLINE &&
>   		    fcport->login_retry) {
>   			if (fcport->scan_state != QLA_FCPORT_FOUND ||
> +			    fcport->disc_state == DSC_LOGIN_AUTH_PEND ||
>   			    fcport->disc_state == DSC_LOGIN_COMPLETE)
>   				continue;
>   
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 365e64ebef8b..faf446f0fe8c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -576,6 +576,16 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
>   		sp->fcport->logout_on_delete = 1;
>   		sp->fcport->plogi_nack_done_deadline = jiffies + HZ;
>   		sp->fcport->send_els_logo = 0;
> +
> +		if (sp->fcport->flags & FCF_FCSP_DEVICE) {
> +			ql_dbg(ql_dbg_edif, vha, 0x20ef,
> +			    "%s %8phC edif: PLOGI- AUTH WAIT\n", __func__,
> +			    sp->fcport->port_name);
> +			qla2x00_set_fcport_disc_state(sp->fcport,
> +			    DSC_LOGIN_AUTH_PEND);
> +			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
> +			    sp->fcport->d_id.b24);
> +		}
>   		break;
>   
>   	case SRB_NACK_PRLI:
> @@ -623,6 +633,10 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
>   	case SRB_NACK_PLOGI:
>   		fcport->fw_login_state = DSC_LS_PLOGI_PEND;
>   		c = "PLOGI";
> +		if (vha->hw->flags.edif_enabled &&
> +		    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP)) {
> +			fcport->flags |= FCF_FCSP_DEVICE;
> +		}
>   		break;
>   	case SRB_NACK_PRLI:
>   		fcport->fw_login_state = DSC_LS_PRLI_PEND;
> @@ -692,7 +706,12 @@ void qla24xx_do_nack_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
>   void qla24xx_delete_sess_fn(struct work_struct *work)
>   {
>   	fc_port_t *fcport = container_of(work, struct fc_port, del_work);
> -	struct qla_hw_data *ha = fcport->vha->hw;
> +	struct qla_hw_data *ha = NULL;
> +
> +	if (!fcport || !fcport->vha || !fcport->vha->hw)
> +		return;
> +
> +	ha = fcport->vha->hw;
>   
>   	if (fcport->se_sess) {
>   		ha->tgt.tgt_ops->shutdown_sess(fcport);
> @@ -964,6 +983,19 @@ void qlt_free_session_done(struct work_struct *work)
>   		sess->send_els_logo);
>   
>   	if (!IS_SW_RESV_ADDR(sess->d_id)) {
> +		if (ha->flags.edif_enabled &&
> +		    (!own || own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
> +			if (!ha->flags.host_shutting_down) {
> +				ql_dbg(ql_dbg_edif, vha, 0x911e,
> +					"%s wwpn %8phC calling qla2x00_release_all_sadb\n",
> +					__func__, sess->port_name);
> +				qla2x00_release_all_sadb(vha, sess);
> +			} else {
> +				ql_dbg(ql_dbg_edif, vha, 0x911e,
> +					"%s bypassing release_all_sadb\n",
> +					__func__);
> +			}
> +		}
>   		qla2x00_mark_device_lost(vha, sess, 0);
>   
>   		if (sess->send_els_logo) {
> @@ -971,6 +1003,7 @@ void qlt_free_session_done(struct work_struct *work)
>   
>   			logo.id = sess->d_id;
>   			logo.cmd_count = 0;
> +			INIT_LIST_HEAD(&logo.list);
>   			if (!own)
>   				qlt_send_first_logo(vha, &logo);
>   			sess->send_els_logo = 0;
> @@ -981,6 +1014,7 @@ void qlt_free_session_done(struct work_struct *work)
>   
>   			if (!own ||
>   			     (own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
> +				sess->logout_completed = 0;
>   				rc = qla2x00_post_async_logout_work(vha, sess,
>   				    NULL);
>   				if (rc != QLA_SUCCESS)
> @@ -1717,6 +1751,12 @@ static void qlt_send_notify_ack(struct qla_qpair *qpair,
>   	nack->u.isp24.srr_reject_code_expl = srr_explan;
>   	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
>   
> +	// TODO qualify this with EDIF enable

fix comment style

> +	if (ntfy->u.isp24.status_subcode == ELS_PLOGI &&
> +	    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP)) {
> +		nack->u.isp24.flags |= cpu_to_le16(NOTIFY_ACK_FLAGS_FCSP);
> +	}
> +
>   	ql_dbg(ql_dbg_tgt, vha, 0xe005,
>   	    "qla_target(%d): Sending 24xx Notify Ack %d\n",
>   	    vha->vp_idx, nack->u.isp24.status);
> @@ -4724,6 +4764,15 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
>   		goto out;
>   	}
>   
> +	if (vha->hw->flags.edif_enabled &&
> +	    vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		ql_dbg(ql_dbg_disc, vha, 0xffff,
> +			"%s %d Term INOT due to app not available lid=%d, NportID %06X ",
> +			__func__, __LINE__, loop_id, port_id.b24);
> +		qlt_send_term_imm_notif(vha, iocb, 1);
> +		goto out;
> +	}
> +
>   	pla = qlt_plogi_ack_find_add(vha, &port_id, iocb);
>   	if (!pla) {
>   		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> @@ -4789,6 +4838,16 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
>   	qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
>   	sess->d_id = port_id;
>   	sess->login_gen++;
> +	sess->loop_id = loop_id;
> +
> +	if (iocb->u.isp24.status_subcode == ELS_PLOGI) {
> +		ql_dbg(ql_dbg_disc, vha, 0xffff,
> +		    "%s %8phC - send port online\n",
> +		    __func__, sess->port_name);
> +
> +		qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
> +		    sess->d_id.b24);
> +	}
>   
>   	if (iocb->u.isp24.status_subcode == ELS_PRLI) {
>   		sess->fw_login_state = DSC_LS_PRLI_PEND;
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index 8a319b78cdf6..b910f8f09353 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -176,6 +176,7 @@ struct nack_to_isp {
>   	uint8_t  reserved[2];
>   	__le16	ox_id;
>   } __packed;
> +#define NOTIFY_ACK_FLAGS_FCSP		BIT_5
>   #define NOTIFY_ACK_FLAGS_TERMINATE	BIT_3
>   #define NOTIFY_ACK_SRR_FLAGS_ACCEPT	0
>   #define NOTIFY_ACK_SRR_FLAGS_REJECT	1
> 

after fixing small nits, you can add

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
