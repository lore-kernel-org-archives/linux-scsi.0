Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4D8CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 17:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjJMR7l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 13:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJMR7j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 13:59:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661A5C0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 10:59:37 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DHiTrF027370;
        Fri, 13 Oct 2023 17:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=M3uyyy85u6HLx4zNDAlxiJww1bysjE8MNiec4SRRW20=;
 b=fSY4gNZRkoYGAMMWRm/DCnkLagVkx7MZlxh4N5MNWEMoz+rOKJQtex/FEz0tUCItDgrj
 yMSyRIrIz4QgbkIGX8MIX/njTJ+bElUwqAEt37GxNYti5ctEcRTJK0e67Sfm44Az9YcU
 4M0pPb6pbdf69cV51NUpqupadGBcWFpxWNZlgUbw3sIuJOLJ2idXFi3SVzvdwdRqZ3fi
 7YJ5vIpFcPCB91PFQQn3i+vFi7bCo/Vm7/Jp/cZzc7NkExLG/ACjFIN7y4k1EMMbACod
 gG8mQzXmiycv/AFwAF5vetAg/lJoiFDT5+fUzROYuyPrI763Uidg/wbskuH4AZS1dovG 2w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjx8cnn5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:59:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGsRse020186;
        Fri, 13 Oct 2023 17:59:14 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcjx7e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:59:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGGExVvfnwI8YOqF8Jlar6BSecKsYKqO1+2EYuq/AN9qUm2HMv1plpQ8eINUngrtodzfhmW8BcgibMVw1auPbORvLrK/tGlJymqwehZZ798b1LqJYjvxunRBaZO8ddWBgLYJYpuesQXq9lMo6ctja4158jWN16jm2gSPTukzGYjImqn+fExSDJXZE+0TsScded/XdClW3MpxbmIhNZjCsHidhkv5jLZl5INffKquSgWtD1yri9z0fRrtoR6mRHBwBdeYbpjKv9RjdEx6NTRTfV2JKTssExdwR2O/Riq/D/u5dcdaf3aPoSiKL06vRSPgOw4am1GfvJ8tnP/g1TyGqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3uyyy85u6HLx4zNDAlxiJww1bysjE8MNiec4SRRW20=;
 b=EzMD3NFS3/jxrNs6Himhzxd9KI5Ne0/U0sFeTm5vDpIfFwpxe8egx6u8xKHJE0tn8HCP40Vofuw7VJQNCnnZsKJ+YfKGfrFHXKq3hMKYR6USkS5E3+73NYVoGZ1f54BnidkthP7X5s0Q4iGMSI1HfM70rgphynZcvfMgOlpAOntg/c1PkRXVEgmwDVjn+C/8e7SkAbD+0Uh+utIh4PLND7eiWW1s6RBDsY/BymdfCBFXp8lzqWryCJrrt8SJhjxEOUzfDbZKCMuSGOT7rQK+YrePQrKZD73lvW5tRyUVqTaenGj6/yGFeIZfq3oSRwQvanjZsFkEDoj+0BZZaHNUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3uyyy85u6HLx4zNDAlxiJww1bysjE8MNiec4SRRW20=;
 b=qNd48PxDfcufP09udo/cjgxIgW+nVkWnYB3iPsTSDxfGkBo+qmfNXyZUTxHVaJGxmex+tlFAYI8HDVnmdSlxNmb5JpXeSETVn04USFB/jjx1uvZXFryMsRpjQ3UwSxXOq0UM8NxMERoUGOAPgJpy3KNsfgS54pWYS4kT0gdhIl4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6852.namprd10.prod.outlook.com (2603:10b6:930:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 17:59:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 17:59:12 +0000
To:     peter.wang@mediatek.com, Bart Van Assche <bvanassche@acm.org>
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Subject: Re: [PATCH v2 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edhymmk1.fsf@ca-mkp.ca.oracle.com>
References: <20230831130826.5592-1-peter.wang@mediatek.com>
        <20230831130826.5592-3-peter.wang@mediatek.com>
        <dd6f13e7-ae2f-4821-849d-8ca43ad48144@acm.org>
Date:   Fri, 13 Oct 2023 13:59:10 -0400
In-Reply-To: <dd6f13e7-ae2f-4821-849d-8ca43ad48144@acm.org> (Bart Van Assche's
        message of "Fri, 13 Oct 2023 09:33:37 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0348.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ad3a443-a650-4dd9-5c7a-08dbcc161b36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqNXvU2duYPUBMfA/fX1XvDfwS/XryTRAKS2Ia/dejjFsijg8ELIrPQXA8rCQRZaHpPADexfZZtBcSFda6deLWhNFlkTx0ErtsR6MEcykyxY3WoVIHXpFdyR9uZLwouFiI/g/E/FRqxJ38VhoionoNOqowg8jMGvjZUweYxR8AurjsIyTUIhr/4Vo0jCAhNaxtfpDRcLcNicPK4LbAV5OCcDhBc/4or015EjwBq5OoADaaFlJdGUFvjmZhFwo3VgyMGaKnrznxgr773EUgALYzsbrj0DUNzVM6kvX2e0fHKB2S1UsYuah5zN6R8vnL1ZDfUCMsYiy65NUTcNqr3TRiIK2wxz4+o43+TCiONNBM1LvCe2BsDRAkww/5tF4Im9ubRbYdMVk9vzvKzt+C+T06dwjie0dmZlDyORD/AwJhXvvuYqRqaX7aqv8vGRTokerE70OmVfriKLAtMTOsqpk26LzDzaf/S6EgCczt38JTpUaaslxcn1W/dowJhMT0OxQv5wLPlYxsltDUxDboYpCNVhltS/pwIF6oqkrbh8MNj6vZ05KwQ9aqdz9kUx45/X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(36916002)(6512007)(53546011)(6486002)(86362001)(6506007)(38100700002)(7416002)(4744005)(6916009)(83380400001)(478600001)(41300700001)(26005)(8936002)(8676002)(4326008)(316002)(2906002)(66476007)(66946007)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?22o5raSamPMMHDA8di0754N5adxeUy/AQbUZD0BO/YyvGMgVNiV5EQ4/5dNm?=
 =?us-ascii?Q?MqSneGBIIBn50Lo+zcooukfjyWe5ZeKP1SOUbFiFGKnxAZOVa3+E+24vx4kx?=
 =?us-ascii?Q?s1mM80NKtGnbA3Zg40Ql5CaSFh4u6tvQha2CoUGz/HsYjVNIOOwJyU9XZeDN?=
 =?us-ascii?Q?k/5qMXV4zlCygEKsVGkijYP3MN7aVKUBzTcaExWoxT+qTFC3G6AWShQzjNgK?=
 =?us-ascii?Q?0JSWhjI6VNjDkXuzdlhT76FgZ4VmbkutVTz84a7XURYlqANYfeAakSp8lI41?=
 =?us-ascii?Q?IT+5kRbAbowig+l70Lx73rKpK1N+TCpW061SFtN2h+fuc8oGkasE0u8hqng0?=
 =?us-ascii?Q?xuACDELxHOdUVd4FXIoHgRhU9bQF0VQj8Z8A1c3ZjJF3eXReUPR1ENnRKn8A?=
 =?us-ascii?Q?fPXJPNMhQ+BdMvUS5yRK0ABQwtr8L85TR9G6F3PpJgsjTA6eyqsQugsK7Mbq?=
 =?us-ascii?Q?T5NY2MFLyvhzuzak+PPiUHD5a9j5tgb/cFzp/OH3llw2hWihP6ubApGLuIdq?=
 =?us-ascii?Q?sOV9Nilc1oHWGuaMb9AqcS+jVmDTVGSqrQJMbvN86SFkkEBiD5zs/CdJPiIi?=
 =?us-ascii?Q?9aPXTtJl04RTWIJrwzDNYTaO3xpHrjFDu9neA7l3plidjhxgDtz1LDuoFR13?=
 =?us-ascii?Q?vLrZKf1kfXAF/+mnumgad/GPqidydWy/oOnKMaU5iJzftzRlaZ3OcTs4MNXR?=
 =?us-ascii?Q?R2gC9n3BBozsdvQC78QftS7vFjnoxA+Jg/CJ8KtMH473pKaL5USkfODf02ac?=
 =?us-ascii?Q?r9wNmQC/XkKBnjIm6F+uJxpz5gmK4AhjgjpTx6SU4p7z6kfGm1n/kSs+gqb5?=
 =?us-ascii?Q?SDi/ynKLo1UWWvpDYl/tFSpH1QdyuLc2DcZBq809cET1Vd2583lsTrjmfrCh?=
 =?us-ascii?Q?Cs+LqBQZmtfpZOwuzPSRSdfG8JlOfdAWVYmMpNJ8/2NWErJZzMdSUGQ9jmKL?=
 =?us-ascii?Q?IjCEFXcJwiudTizmB6gRvFCtOAg0R5nYrZb3wayRDHXfO+5YdH+7P7Nndjmm?=
 =?us-ascii?Q?MBNpBNyzYKEjCEmwSmwIGqjRUPY4rbd5nXiQTVPVarydEArdzTnCqL+IeZ/1?=
 =?us-ascii?Q?hlqHnT00Pu6niKjBOaLViTOmmiosbFrprLa3+aefR49pOfqX+CM5CiIjuxgu?=
 =?us-ascii?Q?6Udeg4lBZkmpNkWFdB3Qlvk+m1M+unAeXZgB7yzaTaC5GZe4tThpvyBLxFE9?=
 =?us-ascii?Q?1fMRhEG9JN/jaq5JUwjieHcnkOpgnGSfIoObhTfUnjwoGEFjP1/1XonuixkT?=
 =?us-ascii?Q?3mWH1Y65e/6dkmRQgEaxqLGLBeoTaNYjwDCNxkm+p/Wv7vvdSO9y41h0LmBo?=
 =?us-ascii?Q?0ZklQqGgQogtmXXkBLnZSruWGSBLk3Lw1zNjJ657mVDVesiH3ebh9l8AxKBu?=
 =?us-ascii?Q?F7R3sfTYo8257Zr/LnYAVCzSzS4Apk6+XKS6h4unJWv2C7vUs+qOp6Sbgweq?=
 =?us-ascii?Q?2bK4AQDtnaG85TRDWzdnDswZGpGMmHrrRAeqWdn2FNcrVLnoViudonhCy6be?=
 =?us-ascii?Q?Lev22kLyc8j7s1qXqCn6kEibFYNJcFXA5K9wRj2lsN+Q75/ipP2k1+GpAn7R?=
 =?us-ascii?Q?elsAxVRxMK1L5UCnbZn0Yh2uGKzqREqje8+yFgYjQk6k8aulSegQ849f95Xj?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Ow6DkZwZzOFXFL/a7oxORW8s7gxU9vY4Mk9rHJX8ephu0HKmGA5UdsXzYnJm?=
 =?us-ascii?Q?/woN3HGO8tYM38cGHlFotQ+pJeOFDZ9dFaEb8tvnKAREi5Rocya2+Ay77HhQ?=
 =?us-ascii?Q?hkQMCPTGI58m/dKN9lWvepjVXpRcmkYssbl3fzEDuhADq5ffdKVyqOvgg/vn?=
 =?us-ascii?Q?NVf6ooYKrTLfR03REhjehkFlHDpYBmZsaNwPfoIeghxjhXefgFUyITGagB32?=
 =?us-ascii?Q?biPv2oOoVyKng1Ml0KJ6vhLcB/zySjOtSUTfs2TmPmT7tjqkB13Ccgv68HVU?=
 =?us-ascii?Q?wL6R85CzoJAp//IUnU4CJeYJc7WItjdYZ87y+Vqlr/5T1Dk8KDr7gbOt/xF8?=
 =?us-ascii?Q?lT+axNwVmPAVc6m4Om6uv2BzTJ/DwXk7Mr5DOr29DFA3a3SjtUe94RFAVZve?=
 =?us-ascii?Q?QYMhpzAlKVM8Aoz2KKJ+5E9asExnMPlpIn+JcDWa9JNcQ3kM/dAASTUHg+Dg?=
 =?us-ascii?Q?1We6fv04RrrQfLFtBDpxNQRNgTEu0eXO/5B7QhXc5OGo9ByM+AP2DsI0sZaD?=
 =?us-ascii?Q?gwG4Y3sQGHG2cQ2Equz59SKsRXZz3KcR5m0+owlI6ocvQpgFMm+CZquhNm3E?=
 =?us-ascii?Q?4t0sSx7hKBeU0oAlu44QxHUT2C0h4JK1eKIKXcL0tTc+AI06FCTnuEjemTFV?=
 =?us-ascii?Q?r/rqrpJeDNUuL5nkj3suPaD+4IQ+84AnqUP7tc+Nf0JfbR5E9g9yh1U7a0Xj?=
 =?us-ascii?Q?YYJYBkzFYXbs0l1ayqbo8pd0k2ju5h4GYJTAIGJBFlhSG6pUfeRqnOHviIUP?=
 =?us-ascii?Q?CE5XMHEuGtEL7eE70yikBOw4neMefNktO8+syKCBWb/DQZmWsZZQmzlxFZeX?=
 =?us-ascii?Q?fHw6PnKaKqBbplvCa3Eu3zI7DQcEEd603kiT0+bNEnm14wFgbLhCG9svZva2?=
 =?us-ascii?Q?b3y1RF0QKblrslBTTnmKsaeztqnty6n3Wfnk9/BXaSbRuNGyDdCuH7Qv6JxG?=
 =?us-ascii?Q?eeP2e14SgTfY9522QkHCCQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad3a443-a650-4dd9-5c7a-08dbcc161b36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:59:12.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BiZ4cz/+5jViea3W5yd89QES6ehDJ9gBAHthyZfhArYheqwCDt8wyut3Lc7PMGy0Cu5oI+pIC4w+BQ/MzA1pBLz1xdjlhodWMZUHKtMChQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130154
X-Proofpoint-ORIG-GUID: Nd3vUYUNd-rSDnLDIbVPKqKcwRAZS_CC
X-Proofpoint-GUID: Nd3vUYUNd-rSDnLDIbVPKqKcwRAZS_CC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On 8/31/23 06:08, peter.wang@mediatek.com wrote:
>> When ufshcd_clk_scaling_suspend_work(Thread A) running and new command
>> coming, ufshcd_clk_scaling_start_busy(Thread B) may get host_lock
>> after Thread A first time release host_lock. Then Thread A second time
>> get host_lock will set clk_scaling.window_start_t = 0 which scale up
>> clock abnormal next polling_ms time.
>> Also inlines another __ufshcd_suspend_clkscaling calls.
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Applied 1-3 to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
