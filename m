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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DB4C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 18:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D9561090
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 18:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFCSLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 14:11:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhFCSLb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 14:11:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153I9ZYq188232;
        Thu, 3 Jun 2021 18:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oOwO0kLlA4qJ736dL9yJsCZurqm0imOHn67ZMEMbLes=;
 b=KbB/ZAHnZ9B59dC2hDl73cD2Or8UfYZURpN0qyjcOI1Wp0I4Iz4Et2dh2oOnlo4fsDvL
 NtJrH6xQanprYlh0oxZvmzbR9zMChzKi5VTqJC7rbQDKI6/tbPu2QWIN/nOUKFJuzlmJ
 lPefy3rZOdgcphxRg5k9PK1rlonfYR8dJ3rZ5cPaoWuV6S7EDsYSDoFc7+uHW1IBvZNF
 aedHXfKZ1SjAIj51k+DDFqSEu2HIpiV8naLmcfaDtYHjzkJRghVs/ao6AcM6BVFTEO82
 eiWDehU+xwS54rvR1r8RZVAlRRsKu1RHT6FsE0tY9uVxYsHM6H4t0SZwr99VBdLuSNXt Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38udjmv3hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 18:09:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153I0j9M078003;
        Thu, 3 Jun 2021 18:09:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 38x1be4fjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 18:09:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjnyS+RIXTJ/l4UgVEDkoN5bs9TXKbKBKoq7x0sc3ansYls5GVVrAh5qd0DK5jX21vxadQG3BsIEJu6W1VS40pfJGKcqvjQHWtQy0rIyoBdrP7q3p4UzvG5FT0tsjgu0XhMt/snnNw8+o38hu9FJ4ArIG1fMwIkNC3QV7Ey/kY/lnpzLMfdLMAjVKiVakDCRkN2IC6l/fkjuF6TJZ1u6aeB6sR07gOZA1XbbYEWQJJHWacED0m0HTpPfoJHJL3YhngfEuD7UCLWOIitvbepjCStmE9T8RWLmHbZqJE+GDFmDukFyTegFJ0TJEZg/YWXkn19j9JvpE+JfEyXEdK11Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOwO0kLlA4qJ736dL9yJsCZurqm0imOHn67ZMEMbLes=;
 b=k9Ppm73DmK36XS+V2J0dP6Beq0W5yerEMx9kGlxXUgxStZJh2uk9C9J+yoCfjZvstAO1RyZyTgdsHoaVgoYnREyEEp8Ngf+iYsvZUKHuE7zvI1SZZOI2xmPcqbBSm+gdYLb9H1pxekC/emg9OI3exChK3aQYFzLJA1gwzfzgHO/Vzr+1Cv9ROH3TSHqOfAcwqoN0Hs/uF7JNMXw1BYUf9Z/eULkh4WJFkcj0okS/avYNlisibkTjLcF4YC1YMkqP3F6X+AiG10J1Bs8gGyyo6Hpik79A/Td+DbtnOp4g9QIfVYurR46vhpzDzNLGfeien/gDLC5lj6NAFoTyIXzdzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOwO0kLlA4qJ736dL9yJsCZurqm0imOHn67ZMEMbLes=;
 b=facGPxIIgRy4d8Qbm1owTNIMEhXFW18aY2wgpFRtBj9I3DGhSLn3JEmxtFezhE1BaJe5HYRFfteFRcVwtH3wZ8BArgTDbWIpt6d5//8A2c0BPa5bxohpP3EZfMXdMetLAYd/ApTLrJXVDmR9UYxAVwZFL0l/1lVJW+qvKiXsN94=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2863.namprd10.prod.outlook.com (2603:10b6:805:d0::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 18:09:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 18:09:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v2 01/10] qla2xxx: Add start + stop bsg's
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-2-njavali@marvell.com>
Organization: Oracle
Message-ID: <62032fee-e643-9421-1cd2-95a342e2666b@oracle.com>
Date:   Thu, 3 Jun 2021 13:09:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0801CA0018.namprd08.prod.outlook.com
 (2603:10b6:803:29::28) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0801CA0018.namprd08.prod.outlook.com (2603:10b6:803:29::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 18:09:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22ac3450-5506-4297-f9df-08d926bac005
X-MS-TrafficTypeDiagnostic: SN6PR10MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2863DD3460BBA2E063C74184E63C9@SN6PR10MB2863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:256;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZtcuaUUN3oTHCsmfLPq3gQVXFbq5D3dtiLOXBSUI8y04Lozb04cgee+ZiyKxZYc6fLKGcMcGHh2fR/j8cHwSgtieNtW6O2jl8xrfG5O7Ryjz1soxEo2Y0xDAEqOYmuaiZNTaBjad+LmQlEgq5W8v6CrhV7ks06jDdIkrj5PcktQmvREgiy4rV+kIgnSZ+QS0na/XQIuGUVB/xgEcGsTJwZy9B8kwSJ0qcsQpdIk1b5xheO9BWZxiyPIHiSeWxgVWv1SlG3ew9J8nOM0lCJwEqa/I7k6e9ciHu+ssPg+0ksje82wmQt91oJq2/tJ4hpYA1KeKpz6MoiOgZtCpgFgKEA444xbazsm4oGiyFjqQq3tPlZB5jAMZJ/RBl6GIdxP4Jung1rtzb4Dx26xRXVvnWHhBAKOdjQK3hvItxKSuY4PZBcVwv94he+SIOdE3C8mHh9YlUmRCd7+mJku8QsQ7uaCCZx0UWbfquKJMfWn6or1oFY9FMhs7kGegcG98CYFHNnVrE5D7wnreWWHOzhg8qi02F+y7TE6hBEFpnJSB4FwXoFthHoED0Kb15TQxTxTgoDxqXq/usiKigogPSJhDHlfkeoiBKjk7/EFjOcmLk6iBgUR/iGDNqhSicBhfnlMox5yFqh15gLynhlQTjBl1WU585reoQqgzF6EfPzDknnGKsrB0iRys/KnFdhF8lsV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(366004)(376002)(31696002)(30864003)(8936002)(2616005)(8676002)(36756003)(478600001)(16576012)(83380400001)(2906002)(956004)(44832011)(38100700002)(5660300002)(66946007)(66476007)(66556008)(4326008)(31686004)(86362001)(186003)(36916002)(16526019)(6636002)(316002)(6486002)(26005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bVh3NktMUlZSOUVtSHBVcTdxbk5BRW95Y3RmUzRmdVpDL3NjWGJoRUFxL1JW?=
 =?utf-8?B?VUtzV2dOT1RadjNGVzluSTlxYmtlWnY2a292QXdjU1VBdlovUk1jcjVTUWJT?=
 =?utf-8?B?aUlMWTJ0Qk9lMWhTczRyeFBYZitjR0E4TE1rVy9IZWl0L29iU0tiZENCdndq?=
 =?utf-8?B?dFlhMGdKNHVmcjUvaG9hTytBQ0s2ZTBHd3JjaHJkYnQ5aGxxY0NBM1JUQ3ZT?=
 =?utf-8?B?dDJnajNrZ0JzalJHVjB2aWhWREdCYWZaYlpHczJiUWIzQy90OTNqRUpFWmNP?=
 =?utf-8?B?RDNVRjErNW5HWnpwK1JscXdpamdCOFhYY043MkI2endzZ2hWTlRXSGFodHdp?=
 =?utf-8?B?b0pIaFBzMklPRXBBWHdycmZsV2hISG82Y2FiWU9MNlB0UTZxUG5ydnRLeXhH?=
 =?utf-8?B?SHZxWjdNSUFhR3UvYTJOWTlXbGpRMFFuYUdJMTVNUTdPblkxdElqV1NZcGoz?=
 =?utf-8?B?Y0NiZFEza1BUdmdIcDJDT3RTSkJUR3duWGpidEYvcVRFaGc3MUpUMHZoOEwr?=
 =?utf-8?B?Skt5S0lpN3lZRlIvRzJXUnpwanlZZXU3dG9CbjVMa3QzcmxCMDdMRUVrUjE3?=
 =?utf-8?B?NHpzb09zUDJRdDY5WmxmTm1mOEFBVFVCbGEzelpMRkZkZEtwQnZzUDBYUDhq?=
 =?utf-8?B?UVlLQlg3QjFvMWNycWRyNVRGOVBEOW9XQ1hNWG5aMGFXb2QzbTR6MGh4TGpr?=
 =?utf-8?B?K3Bab24xV2Q3Y2t5S09GSE9zbEMwVFNyN3llQ1NaNUg5SWZMMld3cC9nL3Rs?=
 =?utf-8?B?L09wK1JZU1VaaC9jcmxCZ2Q1dVlaQ0c2WHVUamVacTJRMXF0V2J0U1MvV0VJ?=
 =?utf-8?B?L0NpZkJqRnVtSkRqaHV6VXAyL2VJc01WRUdYTFZUeG9rUHRSTzc4b2pkTGxD?=
 =?utf-8?B?d2YvQzNLNEZibktaN1JtT2xwT0RuWlFFREF5WDNoVitmeVl4ZmxPdnd1UXd0?=
 =?utf-8?B?OGE4V3puOGYwcWlzWDBXWURJM3pWN2ZvSlVEN3VqYWpscXo0UEh1aUV6dmNT?=
 =?utf-8?B?bllOTzd4Lzk0V2lLOGMzU1h5ekE3STF2djdtczhYUzc3ZjNBLzZDZU5SYkpu?=
 =?utf-8?B?QUJWdEozN0lROEFoNzU4UlBjSms5eXM3cHF6WlhMY0pYRStpRklURDhEeGhY?=
 =?utf-8?B?dDdlMTdydWtsa1FwNk41UE5RRjlQOHRRVjVZRTVxL0JjRDF6NFJQSGYzZ2Nq?=
 =?utf-8?B?eGhnYWwwdHVBRzIyZ1B3THhQVjBndjl1cEpVNmNJRzNJRWkva2tqZFk3OWlq?=
 =?utf-8?B?TGJyM1RIZTRRWmJHUkVZTUdDV28vbjR5bEYyUkJKLzdqU0VWb1krKzNuMkpW?=
 =?utf-8?B?aTlhc0YrRFJXRVFHeHZQRkFMQU9GY0xJeWw1Mm01VTd6WHF3b1BVd0E3c3pT?=
 =?utf-8?B?d1NCMmdndTBlcHVpSWRDeGxCMzYrVGdCZXBOTU9XRStqdUNxYTlObWtLbE5v?=
 =?utf-8?B?V3FXVGJKTlloMUNLRnZZMDFFVHZUU1FVNWhwaUdUSkhDNVBQZUxnYWJWYm92?=
 =?utf-8?B?OXcwUTNKbkRCZ0xwanBMVHhpdzNuaEtoVmE0L0R4Si9WWmNuN1N5ekZxTE1G?=
 =?utf-8?B?SHpLUGY5YnlCc3M4WWQ5Yi9kTW9tWDBYcGRFM3I3QldMaStNNmN5VUZVNkJY?=
 =?utf-8?B?dkJwUDFSR3N1RXJMeFNDOUNaOWUvK0pXN0VpWVRDeWdxTXBSNUxlUWdhVmI5?=
 =?utf-8?B?bFFaUVVYSXMyWDQvWFMzWmx2QUZBWDVWL2I1UHh0NUNaVm84MVVwdm9jTmRR?=
 =?utf-8?Q?Ap8wkA9ECmtN8dyCzhSuvIlS/gquAByrDhswkmm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ac3450-5506-4297-f9df-08d926bac005
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 18:09:37.8774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xaZ6IDJB9FizBw+0fxlE11wHYtjWtbr/0Y5Q06l8jn2qV4lq8J5V04m5TFTjUdTy81ROHXIe0rhPTwsw1FUnmqvwyezXQnGEzTl11u+MGY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2863
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030122
X-Proofpoint-GUID: AAwk9Xex3VKpWTT7ahStA9gko9rORayk
X-Proofpoint-ORIG-GUID: AAwk9Xex3VKpWTT7ahStA9gko9rORayk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,


On 5/31/21 2:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> This patch add 2 new BSG calls:
> QL_VND_SC_APP_START: application will announce its present
> to driver with this call. Driver will restart all
> connections to see if remote device support security or not.
> 
> QL_VND_SC_APP_STOP: application announce it's in the process
> of exiting. Driver will restart all connections to revert
> back to non-secure. Provided the remote device is willing
> to allow a non-secure connection.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/Makefile       |   3 +-
>   drivers/scsi/qla2xxx/qla_bsg.c      |   3 +
>   drivers/scsi/qla2xxx/qla_bsg.h      |   3 +
>   drivers/scsi/qla2xxx/qla_dbg.h      |   1 +
>   drivers/scsi/qla2xxx/qla_def.h      |  70 ++++--
>   drivers/scsi/qla2xxx/qla_edif.c     | 349 ++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_edif.h     |  32 +++
>   drivers/scsi/qla2xxx/qla_edif_bsg.h | 225 ++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_gbl.h      |   4 +
>   9 files changed, 666 insertions(+), 24 deletions(-)
>   create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
>   create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
>   create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h
> 
> diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
> index 17d5bc1cc56b..cbc1303e761e 100644
> --- a/drivers/scsi/qla2xxx/Makefile
> +++ b/drivers/scsi/qla2xxx/Makefile
> @@ -1,7 +1,8 @@
>   # SPDX-License-Identifier: GPL-2.0
>   qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
>   		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
> -		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o
> +		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o \
> +		qla_edif.o
>   
>   obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
>   obj-$(CONFIG_TCM_QLA2XXX) += tcm_qla2xxx.o
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index d42b2ad84049..e6cccbcc7a1b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2840,6 +2840,9 @@ qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
>   	case QL_VND_DPORT_DIAGNOSTICS:
>   		return qla2x00_do_dport_diagnostics(bsg_job);
>   
> +	case QL_VND_EDIF_MGMT:
> +		return qla_edif_app_mgmt(bsg_job);
> +
>   	case QL_VND_SS_GET_FLASH_IMAGE_STATUS:
>   		return qla2x00_get_flash_image_status(bsg_job);
>   
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
> index 0274e99e4a12..dd793cf8bc1e 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -31,6 +31,7 @@
>   #define QL_VND_DPORT_DIAGNOSTICS	0x19
>   #define QL_VND_GET_PRIV_STATS_EX	0x1A
>   #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
> +#define QL_VND_EDIF_MGMT                0X1F
>   #define QL_VND_MANAGE_HOST_STATS	0x23
>   #define QL_VND_GET_HOST_STATS		0x24
>   #define QL_VND_GET_TGT_STATS		0x25
> @@ -294,4 +295,6 @@ struct qla_active_regions {
>   	uint8_t reserved[32];
>   } __packed;
>   
> +#include "qla_edif_bsg.h"
> +
>   #endif
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index 9eb708e5e22e..f1f6c740bdcd 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -367,6 +367,7 @@ ql_log_qp(uint32_t, struct qla_qpair *, int32_t, const char *fmt, ...);
>   #define ql_dbg_tgt_mgt	0x00002000 /* Target mode management */
>   #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
>   #define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
> +#define ql_dbg_edif	0x00000400 /* edif and purex debug */
>   
>   extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
>   	uint32_t, void **);
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index def4d99f80e9..ac3b9b39d741 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -49,6 +49,28 @@ typedef struct {
>   	uint8_t domain;
>   } le_id_t;
>   
> +/*
> + * 24 bit port ID type definition.
> + */
> +typedef union {
> +	uint32_t b24 : 24;
> +	struct {
> +#ifdef __BIG_ENDIAN
> +		uint8_t domain;
> +		uint8_t area;
> +		uint8_t al_pa;
> +#elif defined(__LITTLE_ENDIAN)
> +		uint8_t al_pa;
> +		uint8_t area;
> +		uint8_t domain;
> +#else
> +#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
> +#endif
> +		uint8_t rsvd_1;
> +	} b;
> +} port_id_t;
> +#define INVALID_PORT_ID	0xFFFFFF
> +
>   #include "qla_bsg.h"
>   #include "qla_dsd.h"
>   #include "qla_nx.h"
> @@ -345,6 +367,8 @@ struct name_list_extended {
>   #define FW_MAX_EXCHANGES_CNT (32 * 1024)
>   #define REDUCE_EXCHANGES_CNT  (8 * 1024)
>   
> +#define SET_DID_STATUS(stat_var, status) (stat_var = status << 16)
> +
>   struct req_que;
>   struct qla_tgt_sess;
>   
> @@ -373,29 +397,6 @@ struct srb_cmd {
>   
>   /* To identify if a srb is of T10-CRC type. @sp => srb_t pointer */
>   #define IS_PROT_IO(sp)	(sp->flags & SRB_CRC_CTX_DSD_VALID)
> -
> -/*
> - * 24 bit port ID type definition.
> - */
> -typedef union {
> -	uint32_t b24 : 24;
> -
> -	struct {
> -#ifdef __BIG_ENDIAN
> -		uint8_t domain;
> -		uint8_t area;
> -		uint8_t al_pa;
> -#elif defined(__LITTLE_ENDIAN)
> -		uint8_t al_pa;
> -		uint8_t area;
> -		uint8_t domain;
> -#else
> -#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
> -#endif
> -		uint8_t rsvd_1;
> -	} b;
> -} port_id_t;
> -#define INVALID_PORT_ID	0xFFFFFF
>   #define ISP_REG16_DISCONNECT 0xFFFF
>   
>   static inline le_id_t be_id_to_le(be_id_t id)
> @@ -2424,6 +2425,7 @@ enum discovery_state {
>   	DSC_LOGIN_COMPLETE,
>   	DSC_ADISC,
>   	DSC_DELETE_PEND,
> +	DSC_LOGIN_AUTH_PEND,
>   };
>   
>   enum login_state {	/* FW control Target side */
> @@ -2563,6 +2565,22 @@ typedef struct fc_port {
>   	u64 tgt_short_link_down_cnt;
>   	u64 tgt_link_down_time;
>   	u64 dev_loss_tmo;
> +	/*
> +	 * EDIF parameters for encryption.
> +	 */
> +	struct {
> +		uint16_t	enable:1;	// device is edif enabled/req'd
> +		uint16_t	app_stop:2;
> +		uint16_t	app_started:1;
> +		uint16_t	secured_login:1;
> +		uint16_t	app_sess_online:1;
> +		uint32_t	tx_rekey_cnt;
> +		uint32_t	rx_rekey_cnt;
> +		// delayed rx delete data structure list
> +		uint64_t	tx_bytes;
> +		uint64_t	rx_bytes;
> +		uint8_t		non_secured_login;
> +	} edif;
>   } fc_port_t;
>   

Same nit as Hannes about using uint16_t, while correcting that please 
use Linux styles for comment throuout this patch. I would suggest scan 
through all patches and fix it in v2.


>   enum {
> @@ -2616,6 +2634,7 @@ static const char * const port_dstate_str[] = {
>   #define FCF_ASYNC_SENT		BIT_3
>   #define FCF_CONF_COMP_SUPPORTED BIT_4
>   #define FCF_ASYNC_ACTIVE	BIT_5
> +#define FCF_FCSP_DEVICE		BIT_6
>   
>   /* No loop ID flag. */
>   #define FC_NO_LOOP_ID		0x1000
> @@ -3933,6 +3952,7 @@ struct qla_hw_data {
>   		uint32_t	scm_supported_f:1;
>   				/* Enabled in Driver */
>   		uint32_t	scm_enabled:1;
> +		uint32_t	edif_enabled:1;
>   		uint32_t	max_req_queue_warned:1;
>   		uint32_t	plogi_template_valid:1;
>   		uint32_t	port_isolated:1;
> @@ -4656,6 +4676,8 @@ struct purex_item {
>   	} iocb;
>   };
>   
> +#include "qla_edif.h"
> +
>   #define SCM_FLAG_RDF_REJECT		0x00
>   #define SCM_FLAG_RDF_COMPLETED		0x01
>   
> @@ -4884,6 +4906,8 @@ typedef struct scsi_qla_host {
>   	u64 reset_cmd_err_cnt;
>   	u64 link_down_time;
>   	u64 short_link_down_cnt;
> +	struct edif_dbell e_dbell;
> +	struct pur_core pur_cinfo;
>   } scsi_qla_host_t;
>   
>   struct qla27xx_image_status {
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> new file mode 100644
> index 000000000000..38d79ef2e700
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -0,0 +1,349 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Marvell Fibre Channel HBA Driver
> + * Copyright (c)  2021     Marvell
> + */
> +#include "qla_def.h"
> +//#include "qla_edif.h"
> +

why comment out?  if not needed remove rather than comment it out.

> +#include <linux/kthread.h>
> +#include <linux/vmalloc.h>
> +#include <linux/delay.h>
> +#include <scsi/scsi_tcq.h>
> +
> +static void
> +qla_edif_sa_ctl_init(scsi_qla_host_t *vha, struct fc_port  *fcport)
> +{
> +	ql_dbg(ql_dbg_edif, vha, 0x2058,
> +		"Init SA_CTL List for fcport - nn %8phN pn %8phN portid=%02x%02x%02x.\n",
> +		fcport->node_name, fcport->port_name,
> +		fcport->d_id.b.domain, fcport->d_id.b.area,
> +		fcport->d_id.b.al_pa);
> +
> +	fcport->edif.tx_rekey_cnt = 0;
> +	fcport->edif.rx_rekey_cnt = 0;
> +
> +	fcport->edif.tx_bytes = 0;
> +	fcport->edif.rx_bytes = 0;
> +}
> +
> +static int
> +qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
> +{
> +	int rval = 0;	/* assume failure */

Comment above does not make sense if you are assiging rval = 0.

> +
> +	/* check that the app is allow/known to the driver */
> +
> +	/* TODO: edif: implement key/cert check for permitted apps... */
> +
> +	if (appid.app_vid == 0x73730001) {
> +		rval = 1;
> +		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d, "%s app id ok\n", __func__);
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app id not ok (%x)",
> +		    __func__, appid.app_vid);
> +	}
> +
> +	return rval;
> +}
> +

please use kernel-doc format for the funtion description

> +/*
> + * reset the session to auth wait.
> + */
> +static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
> +		int waitonly)
> +{
> +	int cnt, max_cnt = 200;
> +	bool traced = false;
> +
> +	fcport->keep_nport_handle = 1;
> +
> +	if (!waitonly) {
> +		qla2x00_set_fcport_disc_state(fcport, state);
> +		qlt_schedule_sess_for_deletion(fcport);
> +	} else {
> +		qla2x00_set_fcport_disc_state(fcport, state);
> +	}
> +
> +	ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +		"%s: waiting for session, max_cnt=%u\n",
> +		__func__, max_cnt);
> +
> +	cnt = 0;
> +
> +	if (waitonly) {
> +		/* Marker wait min 10 msecs. */
> +		msleep(50);
> +		cnt += 50;
> +	}
> +	while (1) {
> +		if (!traced) {
> +			ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +			"%s: session sleep.\n",
> +			__func__);

fix indentation for the print statement and no need for multiple lines 
for the parameters.

> +			traced = true;
> +		}
> +		msleep(20);
> +		cnt++;
> +		if (waitonly && (fcport->disc_state == state ||
> +			fcport->disc_state == DSC_LOGIN_COMPLETE))
> +			break;
> +		if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
> +			break;
> +		if (cnt > max_cnt)
> +			break;
> +	}
> +
> +	if (!waitonly) {
> +		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +	"%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",

fix indentation

> +		    __func__, fcport->port_name, fcport->loop_id,
> +		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
> +	} else {
> +		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> +	"%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",

ditto. fix indentation

> +		    __func__, fcport->port_name, fcport->loop_id,
> +		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
> +	}
> +}
> +
> +/*
> + * event that the app has started. Clear and start doorbell
> + */

use kernel-doc style

> +static int
> +qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	struct app_start	appstart;
> +	struct app_start_reply	appreply;
> +	struct fc_port  *fcport, *tf;
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app start\n", __func__);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appstart,
> +	    sizeof(struct app_start));
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app_vid=%x app_start_flags %x\n",
> +	     __func__, appstart.app_info.app_vid, appstart.app_start_flags);
> +
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		/* mark doorbell as active since an app is now present */
> +		vha->e_dbell.db_flags = EDB_ACTIVE;
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
> +		     __func__);
> +	}
> +
> +	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +		if ((fcport->flags & FCF_FCSP_DEVICE)) {
> +			ql_dbg(ql_dbg_edif, vha, 0xf084,
> +			    "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
> +			    __func__, fcport, fcport->port_name,
> +			    fcport->loop_id, fcport->d_id.b24,
> +			    fcport->logout_on_delete);
> +
> +			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
> +				break;
> +
> +			if (!fcport->edif.secured_login)
> +				continue;
> +
> +			fcport->edif.app_started = 1;
> +			if (fcport->edif.app_stop ||
> +			    (fcport->disc_state != DSC_LOGIN_COMPLETE &&
> +			     fcport->disc_state != DSC_LOGIN_PEND &&
> +			     fcport->disc_state != DSC_DELETED)) {
> +				/* no activity */
> +				fcport->edif.app_stop = 0;
> +
> +				ql_dbg(ql_dbg_edif, vha, 0x911e,
> +				    "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> +				    __func__, fcport->port_name);
> +				fcport->edif.app_sess_online = 1;
> +				qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> +			}
> +			qla_edif_sa_ctl_init(vha, fcport);
> +		}
> +	}
> +
> +	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
> +		/* mark as active since an app is now present */
> +		vha->pur_cinfo.enode_flags = ENODE_ACTIVE;
> +	} else {
> +		ql_dbg(ql_dbg_edif, vha, 0x911f, "%s enode already active\n",
> +		     __func__);
> +	}
> +
> +	appreply.host_support_edif = vha->hw->flags.edif_enabled;
> +	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
> +	appreply.edif_edb_active = vha->e_dbell.db_flags;
> +
> +	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
> +	    sizeof(struct app_start_reply);
> +
> +	SET_DID_STATUS(bsg_reply->result, DID_OK);
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	    bsg_job->reply_payload.sg_cnt, &appreply,
> +	    sizeof(struct app_start_reply));
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d,
> +	    "%s app start completed with 0x%x\n",
> +	    __func__, rval);
> +
> +	return rval;
> +}
> +
> +/*
> + * notification from the app that the app is stopping.
> + * actions:	stop and doorbell
> + *		stop and clear enode
> + */

use kernel-doc style

> +static int
> +qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t                 rval = 0;
> +	struct app_stop         appstop;
> +	struct fc_bsg_reply     *bsg_reply = bsg_job->reply;
> +	struct fc_port  *fcport, *tf;
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appstop,
> +	    sizeof(struct app_stop));
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s Stopping APP: app_vid=%x\n",
> +	    __func__, appstop.app_info.app_vid);
> +
> +	/* Call db stop and enode stop functions */
> +
> +	/* if we leave this running short waits are operational < 16 secs */
> +	qla_enode_stop(vha);        /* stop enode */


I don't really understand useage of the above stop fucntion, it prints 
message and returns back after checking vha->pur_cinfo.enode_flags, but 
does not take any action *if* the enode *is* active?


> +	qla_edb_stop(vha);          /* stop db */
> +

Same here for this function, it just prints message that doorbell is not 
enabled, but does not take any action if it *is* enabled.

Am I missing something?


> +	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +		if (fcport->edif.non_secured_login)
> +			continue;
> +
> +		if (fcport->flags & FCF_FCSP_DEVICE) {
> +			ql_dbg(ql_dbg_edif, vha, 0xf084,
> +	"%s: sess %p from port %8phC lid %#04x s_id %06x logout %d keep %d els_logo %d\n",

fix indentation

> +			    __func__, fcport,
> +			    fcport->port_name, fcport->loop_id,
> +			    fcport->d_id.b24, fcport->logout_on_delete,
> +			    fcport->keep_nport_handle, fcport->send_els_logo);
> +
> +			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
> +				break;
> +
> +			fcport->edif.app_stop = 1;
> +			ql_dbg(ql_dbg_edif, vha, 0x911e,
> +				"%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> +				__func__, fcport->port_name);
> +
> +			fcport->send_els_logo = 1;
> +			qlt_schedule_sess_for_deletion(fcport);
> +
> +			/* qla_edif_flush_sa_ctl_lists(fcport); */
> +			fcport->edif.app_started = 0;
> +		}
> +	}
> +
> +	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +	SET_DID_STATUS(bsg_reply->result, DID_OK);
> +
> +	/* no return interface to app - it assumes we cleaned up ok */
> +
> +	return rval;
> +}
> +
> +int32_t
> +qla_edif_app_mgmt(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request	*bsg_request = bsg_job->request;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t		*vha = shost_priv(host);
> +	struct app_id		appcheck;
> +	bool done = true;
> +	int32_t         rval = 0;
> +	uint32_t	vnd_sc = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s vnd subcmd=%x\n",
> +	    __func__, vnd_sc);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &appcheck,
> +	    sizeof(struct app_id));
> +
> +	if (!vha->hw->flags.edif_enabled ||
> +		test_bit(VPORT_DELETE, &vha->dpc_flags)) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +		    "%s edif not enabled or vp delete. bsg ptr done %p\n",
> +		    __func__, bsg_job);
> +
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		goto done;
> +	}
> +
> +	if (qla_edif_app_check(vha, appcheck) == 0) {
> +		ql_dbg(ql_dbg_edif, vha, 0x911d,
> +		    "%s app checked failed.\n",
> +		    __func__);
> +
> +		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		goto done;
> +	}
> +
> +	switch (vnd_sc) {
> +	case QL_VND_SC_APP_START:
> +		rval = qla_edif_app_start(vha, bsg_job);
> +		break;
> +	case QL_VND_SC_APP_STOP:
> +		rval = qla_edif_app_stop(vha, bsg_job);
> +		break;
> +	default:
> +		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
> +		    __func__,
> +		    bsg_request->rqst_data.h_vendor.vendor_cmd[1]);
> +		rval = EXT_STATUS_INVALID_PARAM;
> +		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		break;
> +	}
> +
> +done:
> +	if (done) {
> +		ql_dbg(ql_dbg_user, vha, 0x7009,
> +		    "%s: %d  bsg ptr done %p\n", __func__, __LINE__, bsg_job);
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +		    bsg_reply->reply_payload_rcv_len);
> +	}
> +
> +	return rval;
> +}
> +void
> +qla_enode_stop(scsi_qla_host_t *vha)
> +{
> +	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s enode not active\n", __func__);
> +		return;
> +	}
> +}
> +
> +/* function called when app is stopping */
> +
> +void
> +qla_edb_stop(scsi_qla_host_t *vha)
> +{
> +	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
> +		/* doorbell list not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x09102,
> +		    "%s doorbell not enabled\n", __func__);
> +		return;
> +	}
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
> new file mode 100644
> index 000000000000..dc0a08570a0b
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Marvell Fibre Channel HBA Driver
> + * Copyright (c)  2021    Marvell
> + */
> +#ifndef __QLA_EDIF_H
> +#define __QLA_EDIF_H
> +
> +struct qla_scsi_host;
> +
> +enum enode_flags_t {
> +	ENODE_ACTIVE = 0x1,	// means that app has started
> +};
> +

fix comment style

> +struct pur_core {
> +	enum enode_flags_t	enode_flags;
> +	spinlock_t		pur_lock;       /* protects list */

do we really need this comment?

> +	struct  list_head	head;
> +};
> +
> +enum db_flags_t {
> +	EDB_ACTIVE = 0x1,
> +};
> +
> +struct edif_dbell {
> +	enum db_flags_t		db_flags;
> +	spinlock_t		db_lock;	/* protects list */

same here this comment is not addign any value

> +	struct  list_head	head;
> +	struct	completion	dbell;		/* doorbell ring */
> +};
> +
> +#endif	/* __QLA_EDIF_H */
> diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> new file mode 100644
> index 000000000000..9c05b78253e7
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> @@ -0,0 +1,225 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Marvell Fibre Channel HBA Driver
> + * Copyright (C)  2018-	    Marvell
> + *
> + */
> +#ifndef __QLA_EDIF_BSG_H
> +#define __QLA_EDIF_BSG_H
> +
> +/* BSG Vendor specific commands */
> +#define	ELS_MAX_PAYLOAD		1024
> +#ifndef	WWN_SIZE
> +#define WWN_SIZE		8       /* Size of WWPN, WWN & WWNN */
> +#endif
> +#define	VND_CMD_APP_RESERVED_SIZE	32
> +
> +enum auth_els_sub_cmd {
> +	SEND_ELS = 0,
> +	SEND_ELS_REPLY,
> +	PULL_ELS,
> +};
> +
> +struct extra_auth_els {
> +	enum auth_els_sub_cmd sub_cmd;
> +	uint32_t        extra_rx_xchg_address; // FC_ELS_ACC | FC_ELS_RJT

fix comment

> +	uint8_t         extra_control_flags;
> +#define BSG_CTL_FLAG_INIT       0
> +#define BSG_CTL_FLAG_LS_ACC     1
> +#define BSG_CTL_FLAG_LS_RJT     2
> +#define BSG_CTL_FLAG_TRM        3
> +	uint8_t         extra_rsvd[3];
> +} __packed;
> +
> +struct qla_bsg_auth_els_request {
> +	struct fc_bsg_request r;
> +	struct extra_auth_els e;
> +};
> +
> +struct qla_bsg_auth_els_reply {
> +	struct fc_bsg_reply r;
> +	uint32_t rx_xchg_address;
> +};
> +
> +struct app_id {
> +	int		app_vid;
> +	uint8_t		app_key[32];
> +} __packed;
> +
> +struct app_start_reply {
> +	uint32_t	host_support_edif;	// 0=disable, 1=enable
> +	uint32_t	edif_enode_active;	// 0=disable, 1=enable
> +	uint32_t	edif_edb_active;	// 0=disable, 1=enable
> +	uint32_t	reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;

fix comments

> +
> +struct app_start {
> +	struct app_id	app_info;
> +	uint32_t	prli_to;	// timer plogi/prli to complete
> +	uint32_t	key_shred;	// timer before shredding old keys
> +	uint8_t         app_start_flags;
> +	uint8_t         reserved[VND_CMD_APP_RESERVED_SIZE - 1];
> +} __packed;

fix comments
> +
> +struct app_stop {
> +	struct app_id	app_info;
> +	char		buf[16];
> +} __packed;
> +
> +struct app_plogi_reply {
> +	uint32_t	prli_status;  // 0=failed, 1=succeeded

fix comment

> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +#define	RECFG_TIME	1
> +#define	RECFG_BYTES	2
> +
> +struct app_rekey_cfg {
> +	struct app_id app_info;
> +	uint8_t	 rekey_mode;	// 1=time based (in sec), 2: bytes based
> +	port_id_t d_id;		// 000 = all entries; anything else
> +				//    specifies a specific d_id
> +	uint8_t	 force;		// 0=no force to change config if
> +				//    existing rekey mode changed,
> +				// 1=force to re auth and change
> +				//    existing rekey mode if different
> +	union {
> +		int64_t bytes;	// # of bytes before rekey, 0=no limit
> +		int64_t time;	// # of seconds before rekey, 0=no time limit
> +	} rky_units;
> +
> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +

fix comments

> +struct app_pinfo_req {
> +	struct app_id app_info;
> +	uint8_t	 num_ports;	// space allocated for app_pinfo_reply_t.ports[]

fix comment

> +	port_id_t remote_pid;
> +	uint8_t	 reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +struct app_pinfo {
> +	port_id_t remote_pid;   // contains device d_id
> +	uint8_t	remote_wwpn[WWN_SIZE];
> +	uint8_t	remote_type;	// contains TGT or INIT
> +#define	VND_CMD_RTYPE_UNKNOWN		0
> +#define	VND_CMD_RTYPE_TARGET		1
> +#define	VND_CMD_RTYPE_INITIATOR		2
> +	uint8_t	remote_state;	// 0=bad, 1=good
> +	uint8_t	auth_state;	// 0=auth N/A (unsecured fcport),
> +				// 1=auth req'd
> +				// 2=auth done
> +	uint8_t	rekey_mode;	// 1=time based, 2=bytes based
> +	int64_t	rekey_count;	// # of times device rekeyed
> +	int64_t	rekey_config_value;     // orig rekey value (MB or sec)
> +					// (0 for no limit)
> +	int64_t	rekey_consumed_value;   // remaining MB/time,0=no limit
> +

fix comments

> +	uint8_t	reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +/* AUTH States */
> +#define	VND_CMD_AUTH_STATE_UNDEF	0
> +#define	VND_CMD_AUTH_STATE_SESSION_SHUTDOWN	1
> +#define	VND_CMD_AUTH_STATE_NEEDED	2
> +#define	VND_CMD_AUTH_STATE_ELS_RCVD	3
> +#define	VND_CMD_AUTH_STATE_SAUPDATE_COMPL 4
> +
> +struct app_pinfo_reply {
> +	uint8_t		port_count;	// possible value => 0 to 255
> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +	struct app_pinfo ports[0];	// variable - specified by app_pinfo_req num_ports
> +} __packed;
fix comments

> +
> +struct app_sinfo_req {
> +	struct app_id	app_info;
> +	uint8_t		num_ports;	// app space alloc for elem[]

fix comment

> +	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +// temp data - actual data TBD

what does this mean? elaborate or remove this

> +struct app_sinfo {
> +	uint8_t	remote_wwpn[WWN_SIZE];
> +	int64_t	rekey_count;	// # of times device rekeyed
> +	uint8_t	rekey_mode;	// 1=time based (in sec), 2: bytes based
> +	int64_t	tx_bytes;	// orig rekey value
> +	int64_t	rx_bytes;	// amount left
> +} __packed;

fix comments

> +
> +struct app_stats_reply {
> +	uint8_t		elem_count;	// possible value => 0 to 255
> +	struct app_sinfo elem[0];	// specified by app_sinfo_t elem_count
> +} __packed;
> +
fix comments

> +struct qla_sa_update_frame {
> +	struct app_id	app_info;
> +	uint16_t	flags;
> +#define SAU_FLG_INV		0x01	// delete key
> +#define SAU_FLG_TX		0x02	// 1=tx, 0 = rx
> +#define SAU_FLG_FORCE_DELETE	0x08	// force RX sa_index delete
> +#define SAU_FLG_GMAC_MODE	0x20	// GMAC mode is cleartext for the IO (i.e. NULL encryption)

fix comments

> +#define SAU_FLG_KEY128          0x40
> +#define SAU_FLG_KEY256          0x80
> +	uint16_t        fast_sa_index:10,
> +			reserved:6;
> +	uint32_t	salt;
> +	uint32_t	spi;
> +	uint8_t		sa_key[32];
> +	uint8_t		node_name[WWN_SIZE];
> +	uint8_t		port_name[WWN_SIZE];
> +	port_id_t	port_id;
> +} __packed;
> +
> +// used for edif mgmt bsg interface
> +#define	QL_VND_SC_UNDEF		0
> +#define	QL_VND_SC_SA_UPDATE	1	// sa key info
> +#define	QL_VND_SC_APP_START	2	// app started event
> +#define	QL_VND_SC_APP_STOP	3	// app stopped event
> +#define	QL_VND_SC_AUTH_OK	4	// plogi auth'd ok
> +#define	QL_VND_SC_AUTH_FAIL	5	// plogi auth bad
> +#define	QL_VND_SC_REKEY_CONFIG	6	// auth rekey set parms (time/data)
> +#define	QL_VND_SC_GET_FCINFO	7	// get port info
> +#define	QL_VND_SC_GET_STATS	8	// get edif stats

fix comments

> +
> +/* Application interface data structure for rtn data */
> +#define	EXT_DEF_EVENT_DATA_SIZE	64
> +struct edif_app_dbell {
> +	uint32_t	event_code;
> +	uint32_t	event_data_size;
> +	union  {
> +		port_id_t	port_id;
> +		uint8_t		event_data[EXT_DEF_EVENT_DATA_SIZE];
> +	};
> +} __packed;
> +
> +struct edif_sa_update_aen {
> +	port_id_t port_id;
> +	uint32_t key_type;	/* Tx (1) or RX (2) */
> +	uint32_t status;	/* 0 succes,  1 failed, 2 timeout , 3 error */
> +	uint8_t		reserved[16];
> +} __packed;
> +
> +#define	QL_VND_SA_STAT_SUCCESS	0
> +#define	QL_VND_SA_STAT_FAILED	1
> +#define	QL_VND_SA_STAT_TIMEOUT	2
> +#define	QL_VND_SA_STAT_ERROR	3
> +
> +#define	QL_VND_RX_SA_KEY	1
> +#define	QL_VND_TX_SA_KEY	2
> +
> +/* App defines for plogi auth'd ok and plogi auth bad requests */
> +struct auth_complete_cmd {
> +	struct app_id app_info;
> +#define PL_TYPE_WWPN    1
> +#define PL_TYPE_DID     2
> +	uint32_t    type;
> +	union {
> +		uint8_t  wwpn[WWN_SIZE];
> +		port_id_t d_id;
> +	} u;
> +	uint32_t reserved[VND_CMD_APP_RESERVED_SIZE];
> +} __packed;
> +
> +#define RX_DELAY_DELETE_TIMEOUT 20			// 30 second timeout

fix comment

> +
> +#endif	/* QLA_EDIF_BSG_H */
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..02c10caed18b 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -953,6 +953,10 @@ extern void qla_nvme_abort_process_comp_status
>   
>   /* nvme.c */
>   void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> +void qla_edb_stop(scsi_qla_host_t *vha);
> +int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
> +void qla_enode_init(scsi_qla_host_t *vha);
> +void qla_enode_stop(scsi_qla_host_t *vha);
>   void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
>   
>   #define QLA2XX_HW_ERROR			BIT_0
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
