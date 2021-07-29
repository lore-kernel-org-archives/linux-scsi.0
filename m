Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD951C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A840F6103A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhG2DjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:39:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9218 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233795AbhG2Dil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:38:41 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3apsx005970;
        Thu, 29 Jul 2021 03:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aIgvSoe1AIrsOULbF03b/j6Fuz+G36tQxx9yZyrWeqk=;
 b=OKuHk+RVLKpX7r0XcIiXFn0t/tyo12tkk0hfxUegXeEufqO0hmhGVezFcIrwqMwdDus6
 jk0BHuoeH9lsEGbvRzZLTAY7x5x0FtL1WaljNX6DXfmXrKfUVwObu1MwhrHUREBHAqcH
 R9dE7DZHO4kJrQg05F3M0l+6pBO/CuiVgSonQYYSyBEbM3i5SV1eUZdu5Stl3PuL+Vdp
 WJpkpJfWRf1/1Vo9QjWhKQfFj53s4idd3CWeZOJ8EkR1DV1hm3DzvfvaDljuPeM0ELCf
 TgvQhZOaM9JCoUDKp/Sjw6l5HpOLrz1v0FPZgdTxQfGVhWFQQOlTpclw9ChRgEY3qEJR ag== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aIgvSoe1AIrsOULbF03b/j6Fuz+G36tQxx9yZyrWeqk=;
 b=e8nOUmV6eOZ84xI5haqsMJjZa275+jSOh6bSbTLe5RnI28/EIQZcA4f36IN8EcRbzKGe
 oclFTdIB1nuP8LSnvhpVARMMR3+fjbsKIxlD3BJQ9SG+TGs43UYwnDLJGmrQ+IB727uH
 QKp7zGzRqMhI6HQETFlsV+89LhxjEpKN+bec9rmVz1VEKNsGZwu+oWl85sFzy28uEl42
 lfuYUicX8XBNnQ4V36cWpfW7ud4B1U73rvr73mLyJ/uVtngeYwzCLp/CX5LrnJtaFG5k
 Jfga7QSwnTsgc57r4hW8oTB+zBwn2L8gyT49S+2gfGNOtyN/RoyiP9WgX7LMOkZoNUeR yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2353e20h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Ur3N071206;
        Thu, 29 Jul 2021 03:38:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by userp3020.oracle.com with ESMTP id 3a23501y0c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1xhkL6xn0A19SDcCosi/Pz7szwuheDLssL+vIw3apGe89CFwWBjIn2NOdI5mnqxaE5VZpDdyQlZ24xgLvV3pYbZpBYWMZVTn1L5L30cB9+iMkyFNQatXwkaMHfqhiitLfngVwJTasLNuFzJZFme/qtniy/38O0Yb3lT2jxD9AUErG846+Ynv27lxFv4U5VJ1qZ/iwo5vK2R6/UqAIRpHeMOevUzzOHgPd0mJC0l5XsVzCR/wit23UrUmxXQZPiCbpjI8BZyF73m+24O5s74YsCWolO84WWUuzuZe+nEOoVznTSknktaJ8VrXW/B3Y+pMo+eZlniWEqboN0NnGkSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIgvSoe1AIrsOULbF03b/j6Fuz+G36tQxx9yZyrWeqk=;
 b=XT2PPvZwqh8qZNjtF7QoYw4i4ub/26+UaYVketK2Zrcfyx1YulEOYhMrCtXQicWPJFp6F1o83UFxYRfA0SfImGgsbZa2wpCkSRE2vQY9ic9bn24+KMHH2ZmtiJdyhksJvbuvNe+jj93hiN8WDJaju+4zmhRcFphlitWandejY+fC8k3yokeP0OmCqhh8BOdys7ge+ACmuzqpjzQetpbJw29fQfPhIQb6wrZGjyLaKy2wuZPMGNd/MofIAcOSOQKS2zLha0Iv23r5ZwXhr2ZDz7bgvj/WMgxOXedszl3vkx8FLetWQGRYXDRlcZO+yM9c69CH9bjuL/a3Boo6a0aQrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIgvSoe1AIrsOULbF03b/j6Fuz+G36tQxx9yZyrWeqk=;
 b=ngiBcabYUsCzQ/29GU1v3nCRcWom4UnLJuH+Pscpljo9BZrcqBGyNsDZkGMMYgLrq+S+M3437wOnEs+wAY+R/+/fniZdb1g1GFzmWPiXbBmW3lyEDcoPzHl0PESLNJgmfTfo2O6eiyrgdxt2sR0N/xiDy5++fq5m1DBkgA9pyPo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:38:34 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:38:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.0.0.0
Date:   Wed, 28 Jul 2021 23:38:24 -0400
Message-Id: <162752985698.3150.14418780890432082292.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:332::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:332::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11 via Frontend Transport; Thu, 29 Jul 2021 03:38:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 190b0c14-3a31-4737-639e-08d9524257a7
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15492AE7E86E6B5274344C168EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbzcfua0Uw+POPaII1Gwa5ivDAG4liYrUL1stFstbhhvSXyna9wDxk81B4B7+RGDPjT29aC5JQnAiUSqnjOjXUqJn7hNHayd/zXeHE5qycGdB/fyM4Z3TFKR9srd6StCkFgUleDtp7zNqLiW25Kf3ifMowp+jLNZKT3vbsSD2IiWHT+2h0vFudPl8uvcHltPlgJ+jChiQoJ1384sSCa9I2GjatBpFvyUQAqMQSgTy1+6nO+MNYJDLTFtFLW8nwUEheVv47j+gP/10NgQWfNTwW56YK0rRnfw5McZdqfftrFn7qRbV+YeFm7Tqufj2pWrW6KXWNktY6R+7f5SzEukkXKsmI4HLHlqpPdG3LQvZAGChGx5+Pvrap/tQ1WWPL7lkCFRpr/X9zjtfZLQgdn+Pgl/DfocbQQ/MC5G8nV1y/Mm+xycjqKfny5yLvr+vF63rSf+Ak2dbhG7lfSnLhN8r74/nEvS1RNejRCHt9aAXpPrJJWqMkKVQz3k0ZpewOXeE2M0s5w2zr2H2SkNpAhhGQ18iONeKhZw6UvuxKUrbmti8RMHZNekgwgGsJKMcp2dX2xuKuP8WkpTsfiXQaRPb5xRZjVBbEuumox/Nwce5gs+pewH6t1h4RZe9tbM/jyl96KmmXgsCve0MV0KTsiZC57zwfVLI7P4E1PAmaii8u2tH+NLUmU46A2PMmAj4yAs0Q9LVLP5b6Y1b5Sb6C/L3xC5i7zW76PSxmhkVTG6eWDf1voA0U/G/qJPFnOzWlkuzrTF3xoEduIctsWh30qlVWmBrrTar3yq3qh8XhYNJ2LGhHWqrzN6MY0bl9CMub6v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(7696005)(6916009)(107886003)(966005)(8676002)(508600001)(86362001)(15650500001)(8936002)(83380400001)(2616005)(956004)(26005)(2906002)(66556008)(66476007)(6486002)(66946007)(38350700002)(38100700002)(4326008)(36756003)(5660300002)(316002)(103116003)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVlmNGVVM0RIL0I1Ym90MU5qa3piZ0EyRnJaa0NUZnJTeFJqRXM4SW92c2cv?=
 =?utf-8?B?OWV6eUVJUkpuOWZkQnVtdHJwU0RJNzBvYjMvdXhGMUJnZy9LR3JkN3IxaGZl?=
 =?utf-8?B?VElnaGJvN21zQ0s4Q2V0UHF6L09NRThsdDI2NG9FemZQKzF3WUlkc2czOFE3?=
 =?utf-8?B?UVkvNk9pUWRpRTZoUnhMRkpFalJsMC9DMDUwRU9YalA0K05hclpKZFFrcWVl?=
 =?utf-8?B?ZkxRK2FmZG1SNHdxUVhqa0hnVUxTTDZlVUgzcTRYY2o0ZWQyK2E1QUtWUVlS?=
 =?utf-8?B?M2UzQ040ZGJnc1REeWM4SEJ4Zk84Z1JLU0hGS3doSHdYQklIeGFNcHE2ODRw?=
 =?utf-8?B?eXJYK2RRaWNEcVJUdVV4azJhbE9Za200MHNoaXlHeEJBWURUbEs4U25ObFY0?=
 =?utf-8?B?RmlFTjEwV3pjWElwUTRzSE1iR2drWU9aRUdMZTYycGJGWm5IdG5EU3hCb1ZH?=
 =?utf-8?B?di9sUFJ0YS8zZzlXcVVVaWdYam5FVktjZnJzT091Tzh4OU4xN0hVbXlTM3Ay?=
 =?utf-8?B?M08wc2FGb0VQSDdrL3FwalNuVlpqQ2N4OGg4emxHZ2xacnIvelR0L2lRUDNE?=
 =?utf-8?B?QTFpaWlPdmpwVEdYbjJ2NDF0TGJ5QW82TW5XTEV6U1IyTmdSL3UvcWY5Q3Zi?=
 =?utf-8?B?bytWTGdsb2VHT1c4WEVWdVJTSEUwTXB1WG5LWUpodm1NdmkwbThYMkR4ZDJa?=
 =?utf-8?B?QjY4U0xiakE4UGVCQ0NGS1l6YUR0TTc4ZHJPZzNhVXB3djFIbjNDMXJKU0dj?=
 =?utf-8?B?QjdWZ0xoTURYWXpDa0JOSlhQdENDYTVVWVhBUUlKWENQQ2hBSmtMREJIT3B6?=
 =?utf-8?B?Yld5WmlvV3UvQTVpQ1FQWU1DNTI4RXdqR2FHUEtYNytCNVVrRk14RDB4dm9J?=
 =?utf-8?B?MXNZUitzMkpnY1IyMHA1NkRzaVk2VmRFY0V0VVd6ayt1WkkxUHZrWDZXSnlK?=
 =?utf-8?B?amc3YVBUMXZKZU1TblptQ2gxQTh1NVBRbEwvZjRsQVdLQ0Zoa2JlZmhPZFVl?=
 =?utf-8?B?U2xGR0NEdVEwc2FPOUV2U0hRamxOcy9Vb3BINERVTUV6S29aTlhEOWpnS3Y1?=
 =?utf-8?B?OHV5Y05FcVpMMFpRbnR5dkVqQTNySzkwVVpxTHFFOUdLSUJ0REZQc2NLNW9V?=
 =?utf-8?B?Y3Jsa1l1RjBYVlhGeXRacGc0ejh5d21BaFBVd0JrWnZJdDlSTlZ5ckdLK3NG?=
 =?utf-8?B?NFpNeVZtRk1WVXdaZ05DVmVGVGYrT05QTTlQaXJDNmd2Ukh2c3Q3UmpGSFJw?=
 =?utf-8?B?L2IvczZXeWpnNVBlTjBKRVNKYmtVaitnSGpwcjlOR0g4eWZ6dE9rbkRPalpw?=
 =?utf-8?B?bW95cXhpZTQ3WUUwV3N6d3hEMW5KU0pOaXRlSGhFMHBsRnQ5VW5SZit5eGU5?=
 =?utf-8?B?NURNTDdwTDUxbDBCcW9QYlhFTTZERFNwRjh4OUYrRHBqLyt0UUhWSkRWVzR0?=
 =?utf-8?B?ZUVueTkzUEJZRGNTdEFyTDVvUmRyOGNvazNFS1Rrd1pFSjJJMVdwVDlWL2NI?=
 =?utf-8?B?dWJnKzQ0eklUditoSUZGaXp0eGo5RlhwNm1IWXlZOUtHTFNUV2JvSGlKRnpG?=
 =?utf-8?B?QnpScWdxOXUyN1hhTXNjVEFWWWhqNHplVzVYdHNqRTE3RUV6RHRDOFFaNkMw?=
 =?utf-8?B?VXREd3BWbGdhSkVxTnY2SFpsZUViWUVwNlhvQXhIK0NDekUxUkFZYUYrV3Y0?=
 =?utf-8?B?MjVJY2FYSVdqWjhyOUZnYmtIZm5DKzlQMXY4N1VsWEFIU2dYSjZyck1kZ1Vo?=
 =?utf-8?Q?8OmkRF/iRTlBdr77XEKU5YfE+xeb9PZURR5mhRH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 190b0c14-3a31-4737-639e-08d9524257a7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:38:34.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrnmH73/AhWtK490uLatofX/4SXeWsrhuB4VRw6/4SEw72L9dt4JiiEdxJNdhGahegwbJU0aqz5DjOhpRoDP8JtfTwHvyWn24bOfBXaNsJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: paYV2TWxP8VEpI1cR1Wq79HRXa61hCld
X-Proofpoint-ORIG-GUID: paYV2TWxP8VEpI1cR1Wq79HRXa61hCld
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 22 Jul 2021 15:17:15 -0700, James Smart wrote:

> Update lpfc to revision 14.0.0.0
> 
> This patch set adds support for the new G7+ ASIC found on the LPe37xxx
> and LPe38xxx adapter models.
> 
> The set:
> - Adds support for the new PCI ID's
> - Corrects a bug found due to higher resource counts
> - Rather than patching in new PCI ID's to capability checks, refactor
>   to pick up the ASIC Family values which automatically picks up the
>   new chip.
> - Add in 256 Link support, which can now be seen on trunk links
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/6] lpfc: Add pci id support for LPe37000/LPe38000 series adapters
      https://git.kernel.org/mkp/scsi/c/f449a3d7a153
[2/6] lpfc: Fix cq_id truncation in rq create
      https://git.kernel.org/mkp/scsi/c/df3d78c3eb4e
[3/6] lpfc: Revise Topology and RAS support checks for new adapters
      https://git.kernel.org/mkp/scsi/c/f6c5e6c4561d
[4/6] lpfc: Add 256Gb link speed support
      https://git.kernel.org/mkp/scsi/c/bfc477854a42
[5/6] lpfc: Update lpfc version to 14.0.0.0
      https://git.kernel.org/mkp/scsi/c/95518cabe119
[6/6] lpfc: Copyright updates for 14.0.0.0 patches
      https://git.kernel.org/mkp/scsi/c/45e524d61ec4

-- 
Martin K. Petersen	Oracle Linux Engineering
