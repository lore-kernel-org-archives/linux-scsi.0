Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCEAC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 16:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiLMQNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiLMQNJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 11:13:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918BE0C0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 08:13:07 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDtcYZ013639;
        Tue, 13 Dec 2022 16:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=huHzi4coRaDMIyL4e5S+G3TRM4vdlEChhf9HAprb1Uw=;
 b=ja+k0+XEcW/dKrR2xbBMKOJyv3E2PPQRNiNCGq/Q0XIxtV+rnCR7K3WM9yp9DgKnmCja
 DYUz2K/qBTLCvfLXx+LaQfiPNh/m8eEYz2TeOYHpIAvauhOd4oVzyQqxIK21mh0rJfAw
 iUWYXI0miS5LrKxx5UnsAmolNmqyhkuR/kX7xCGMwdB9v/oV3yHkoR8p/0KPCpuU927T
 HBVkYTiTklEXNn0BubfoIHUn5PIzsHaM0gbM6/DfnuNvI4ThucSBP3zmfv1yoZzzhkc7
 ObGvcqYtPo8iiubIMQfb2b1H+wqCgz6kk0Zs1H32QHWWxjFu7VmyE40NAvr0KcoARAeX Lg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mch1a5u5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:12:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCTVW040000;
        Tue, 13 Dec 2022 16:12:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjchvmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:12:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+zBolPo9ZanqjU8L2CM/b6LoJZF1T7gmCE7qiwIG3xM++kv3/xfcYQIvK9bpPlj5F8/oTJ5B6GczZJM+qCVV5iQLkgwuQHCbI66Zs55A9jMPdGusXXm8fL6CJ5kQVXf4KqDdxkip10JotozwdKr7nDda1wHS91KPQ8j9fYAGAJnjX8KqlyZlCNRyvljCUmugnGnKGRON2JyYXLtSNirNTS1snJaTYbAwsAX466u8NX7yvNNtd9URduBSPwYwZNKLA5MrtIMHY+JWLHFo9yov50nHBGhO+azqOtGN7EofqzjK2iYHTf7Zzxfoi4sROndQxV0dkWWmoAAxv25+PRRNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huHzi4coRaDMIyL4e5S+G3TRM4vdlEChhf9HAprb1Uw=;
 b=nvX2l9Z/Fk4phENip4He07dMUC5Cq6mnZJUgMh/eMqds2aK+ydTDRfOyR+aiFumNYpvuM+LCk6OfuLFrdtKNyxOiyp1sosJ3HK8BUzhMqkXJK5xrtl0lL6W6R5gn1XZENaTToVD1kSHlEywnkUZf/BJ5pSSiXWTqFRMoe0I/O2svgUp+G9TeMvoWRNIZPrm/MUs88IJ77n3VB1f46EoBT3hh32Vit5oLqG8sfJL3Ji0GKGlQYP9cpveTxHEl0pTURXZ2mRILoHyZ+EbdH4WR1eg1kxUn/nzlvtdoZgqM/e2DELKxpB515qep7XVf89kzp5o//3rbgUEFZiUFKULCAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huHzi4coRaDMIyL4e5S+G3TRM4vdlEChhf9HAprb1Uw=;
 b=dD8asL13ekELkE1b1MU3hhJEvtBj1jqsS1Au/RUZh9eNM5xXMweQwhnrHIzVNDpmw4GppxCyWCDRHPDwSyU10vR4ZwJsC1+nSvMviYDtECZPiocFQ8OX5vSWdN9haXmb2da0d/PKBKDYbv50KgBAGg8vrxA8aaCO1la02OCa1rQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4876.namprd10.prod.outlook.com (2603:10b6:610:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:12:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:12:41 +0000
Message-ID: <ad43f2a5-286f-b079-3b6a-f773fd7c4c30@oracle.com>
Date:   Tue, 13 Dec 2022 16:12:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 0/5] scsi: libsas: Some coding style fixes and cleanups
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221213150942.988371-1-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213150942.988371-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4876:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e51ad1-3c78-484e-d9c1-08dadd24dc82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvwHcdLti4W73IL4uPtlxALiKMNJ4j5N7EeEAsS2OKEMzPWD2Ed/Q+yS48uLMYCppxPz8HrlsCU6hsUL1zRYFISJBKc5gsAywUPWQiIyTrvO0EsjZtNYj4CntOj4RQ3Yic0RvcooIbosZY98OweJOCh2Yo2fAQMhCKkHQTJyfDIZvElDbdWiUsgxqxLlBHps/Ag/z20+fIjF/U4ZUb9zFOuzSJ8QFFCUycb+zEVRdtUiwy4ffe+vIQMz9Oin29BfXe2hKrvE84R+Wxn7Kb6b0JjViC5XlLbQUJvwvLqSte4P87U2oRiCGCBjlAqwm4gIKQscs+bqzBoWEY67va+YD6tg28VFKqe2z5nhOiQp4O0AaEzOiFziEG4NKejQbx1LWqILh297bu8nUepf6gZEqgvIFnlLTKmdOuIgxddCeWuCx+KzXnRz5rfMKCtNsu5F5IyAY1TnlWn0XB6tvoIOA+1haD5G6RtyEnwq5Yt9QBGnGHwSNtqNfo9DkNAvJUlo4XRsYG56EidkV5gLeAaKbOVQ0uayoJWPqhcwPu91Vp7xMTZg/nn+FTxHtnqyhi/CHSn5N5gP3hniBBmM0FNh6eQfN5mBWpxLgd27GpJX/raSaXYyvEuL8UuTaImc221lYnuPhjtH9f++ZsBmgu7zNonSpLoVfaQ+h1Mlji82wve1lyJKLwm1GdQPnTjTyLdD3Mkuw16IXJoTghWAXB54WZu1VZwBwPwnGM+dVQcR0yg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199015)(31686004)(2616005)(83380400001)(186003)(53546011)(31696002)(6666004)(36756003)(41300700001)(2906002)(478600001)(26005)(66476007)(6512007)(8936002)(36916002)(5660300002)(66946007)(6506007)(6486002)(38100700002)(66556008)(86362001)(8676002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZERaUXpOQ2FDR2NxZXZLODc4bk1xYXBkTWlEaTc5UC80T0NNZEJMVHBaa2gy?=
 =?utf-8?B?dG1ZUFpBeXRoMldQVTVjR0planRJYVgwTCt4aUhhMG42eTZBeWE5UzkwU2ZX?=
 =?utf-8?B?Nyt1OVQ2NVZycTNQU0hXUElrcFNVZHhyY3F1SDF4c3M2c25RVk42cEdHUTFQ?=
 =?utf-8?B?UzhoZWxEdFJlK1FHTUdHZG5ZQVp4Um00MWtRbFhKNWpEWDNPNE90enluK2dD?=
 =?utf-8?B?SmwrbFFCQTdaSS9IaHVadjM4UjdONlZ6azhLdWtON0lGdzBwYVQvY0ZiUzFP?=
 =?utf-8?B?YS9nRWJlNWN1R2FGWlY3Z1lFR3lmT2xXSjBCN29objlVTVczbTVJL3FQelZB?=
 =?utf-8?B?cXVRc3UxQ3VUb1YwMFN3MkJNZUozeTNMKzdiayt0SEtqUkIzd0EweDc3dmVr?=
 =?utf-8?B?UTh1cTJFK25JUUV2T3NZT2VWM0Qvbk82WFNTTFBwbDZSd0lJaHJmdXI2Y3dY?=
 =?utf-8?B?REtHc3JVRkRwSVpKR0ZQZDhpcklMWjE5RzFvUURtVWlDZjFCdFFNTkEyNEo3?=
 =?utf-8?B?SXgyUGNPOG9jeVBrSzRCZVM5aFlCSFRqS0NCaEZUNXBUVkl0N01OdWtpL3JP?=
 =?utf-8?B?QXh1NWxHNXl5WUxDSjBFN05hWVY1emllRnlzNk1SM3ZjbVZOUU94ekMyZ3Zv?=
 =?utf-8?B?Qk1SZC9CZjY1aXdHZXoyakFFWGZhRmVzYUhCV1lCYi84dEpnS0ZaOVZxRkw0?=
 =?utf-8?B?dlZvbklyUjhhckZ2YzRZUUY5TWFxUjhkMU0zUWJWQzBBSDVIN1B6NXRSTTFT?=
 =?utf-8?B?Q09IUi9TMXVTMzQ4WGdRSFNHY3Z4STUwOFVqbVBDVzB5YlZldVMzMjFySHFl?=
 =?utf-8?B?TWJpT0o0R0NkMVpVVzlYM04rNThVNVRMWk1hMlhnOFgybjhwS1EvRmNDUUxl?=
 =?utf-8?B?UG9UUVRHblJ5MXpvM0MyS0s0aGFySk5yaUE5NW5Ncm1GcXFVM2M2VnArMkt6?=
 =?utf-8?B?YXVwL2pMZlZTWTc5VFcraEx2V3l4YWFSWG9HNWdCV2Zhd0ZBTXNxM1ZTcjhT?=
 =?utf-8?B?NW1xTnVmTnZkOHJ5aFFOYjJRWk0vSHFjSUo3NEQ1TkhjMjZITmpESlVqNmZW?=
 =?utf-8?B?eWlzWjFoYlVwclR6YjVXT0RNYlZ2RXh5V3haQVVRV2p2WGFGd1lzL0ViNXFD?=
 =?utf-8?B?ZmFOYjZ4ejN0MmJWb0Z3dFlWMklJMmN4S2dFNllmd0RkUjlVR1pxbTgxbkhM?=
 =?utf-8?B?ZnVuYjk4UUxnRlY5aHp4eTBCUWVvdTliMlBnNFVBYklycERVdzRoYWlWRXJp?=
 =?utf-8?B?QW50VHJrOWNvQm5oUHNqbzhmNTFMOXZSUmhTZU9DT053OVdHRytITGI1OVQy?=
 =?utf-8?B?SWxVbGRJRTVubkNTVXpXTGZTQzFKY1FpZk45SnJUVk9VdDBNM2JUUnlUeEsx?=
 =?utf-8?B?cUNOMmdCaDJ0ZGYwU1JobGgyWGIzS29HYjR5eWEvby9LanNUT3RQTThKK3Y4?=
 =?utf-8?B?dTVXZHV0eER0b0xMNjRxc2xOdExGOU8rcEFvSjBZQXF6MkwwUEJTdTJpZnNW?=
 =?utf-8?B?YWZRWm92alFWZTNFeGxLZnFTMld5RGtsUVJqTElINTMwL1JaaDZqcHJKK0dw?=
 =?utf-8?B?dmF3b21PVGFtM2hlL1h4QnpOSVJBQVlObWtNWHV5UzJ0YlhULzl1TEw4TUFN?=
 =?utf-8?B?Skpac3g5TEhoZUJGNXhJOE1HK2lvdGozeUxqSGhaSVlFOU1tV2JrVGZROCtr?=
 =?utf-8?B?RjhwaklWQjVNU3VPZjRHU3FoektWckJSZE9UZS9BT0hSUU1tY0t5YWJ0d2tK?=
 =?utf-8?B?R3lnMlU3TWpPUmtjMFpMOWhMRnl3WGw5NW56RUtNY3NDNGlvWmFJU09uem5U?=
 =?utf-8?B?K0QrZTVKN1Y5dXpEUmZIWkdoeVFJbnh6ekNESlhPcDRvZmtheHQ4cFIrRUJT?=
 =?utf-8?B?MGI3ZU5MVExWOGtrQUFDR1F1NTVBNVZ3WkdSMmZVc3B0ZHFNNXEwL2Y1ZFlq?=
 =?utf-8?B?Y3hpVkozelJwSW5jTitoamNWcjREZFJtMng1ZmVTUngva3NDanlDZFo1cnVv?=
 =?utf-8?B?Z2pFU1VXQlp0amJxaXlBeS9aQzUyNFpNSUFFWkp2TWdzejgrSUZ2SGdVWmVQ?=
 =?utf-8?B?aU9NbUxqK08vdTNSVEZnOEZMNElxS01CK3pWbUtKaS9XU0ZrNGo1UTE3cnlG?=
 =?utf-8?B?WDdmaGNFOTRrc2J5RXBTN0xTeHRhQjRMcDIxNjFmV2Q4ZmhMUTBjRzl1cFNR?=
 =?utf-8?B?L0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e51ad1-3c78-484e-d9c1-08dadd24dc82
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:12:41.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hk33r4eqsit2MtheaRo8/agbNp0ige9Ehk0ZVzhP+AdoaM760nGIV2zMk+5nRJ5XF6Naugo93ct6T1QWQOYawg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130143
X-Proofpoint-GUID: zYsvSSCuLPo8cAZC3-OY2FNj4SyPvMmu
X-Proofpoint-ORIG-GUID: zYsvSSCuLPo8cAZC3-OY2FNj4SyPvMmu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/12/2022 15:09, Jason Yan wrote:
> A few coding style fixes and cleanups. There should be no functional
> changes in this series besides the debug log prints.
> 
> v1->v2:
>    1. Drop patch #2 in v1.
>    2. Other misc changes suggested by John.

Note: it would be better to concisely mention the actual changes, so 
that we know what to look for in the new version. Just writing something 
like "incorporate changes suggested by <insert name>" is unfortunately 
not much use.

Thanks,
John

> 
> Jason Yan (5):
>    scsi: libsas: move sas_get_ata_command_set() up to save the
>      declaration
>    scsi: libsas: change the coding style of sas_discover_sata()
>    scsi: libsas: remove useless dev_list delete in
>      sas_ex_discover_end_dev()
>    scsi: libsas: factor out sas_ata_add_dev()
>    scsi: libsas: factor out sas_ex_add_dev()
> 
>   drivers/scsi/libsas/sas_ata.c      |  88 ++++++++++++++++----
>   drivers/scsi/libsas/sas_discover.c |   6 --
>   drivers/scsi/libsas/sas_expander.c | 125 ++++++++++-------------------
>   include/scsi/libsas.h              |   1 -
>   include/scsi/sas_ata.h             |  15 ++++
>   5 files changed, 129 insertions(+), 106 deletions(-)
> 

