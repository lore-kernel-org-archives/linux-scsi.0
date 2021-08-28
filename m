Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FB0C4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB82F6023E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhH1Cd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2902 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233168AbhH1CdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:25 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLCcIK028952;
        Sat, 28 Aug 2021 02:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=h2j49sHJKfgHBbA9bh5n1D2cjEBWa3/HR5ykDr+lYM0=;
 b=MgAaGotANARnQK5+89In8UZM010NOTyJu1rx4gdVhyJ1SMJdBRYsTsoYuEM8PDQDO4dD
 Ka2Dwi2IXf2dZtCUpIxYX28Je80+DWIY0lNzrI5iUGpg1lPYjL2iUBgvHV1Y8WMsltmD
 7Yr0t8tSvv77uF/OmrRdctSJzOXgoYdAFuNH1KTFYugjB52U7gyiCBS5pQjKGNEhxgL8
 +fVqFpkh6jCXwghodLJHvHMWAgGzu044ruTzXDfCPTN7SL9fCI8E+z3sQq3l+LzhOdmi
 JPDFmBfAS8f4SWorvNPhWjg3H8vIVcG8fZJyChkKc+KdI4mg4Ctv1PvpzJmRDYkEXuDm og== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=h2j49sHJKfgHBbA9bh5n1D2cjEBWa3/HR5ykDr+lYM0=;
 b=KmekEj+bkq+Zkk8U7wYJZEehkP5zO1F0q7z+6yvS+YuV3I8fDJNgBvHRhND/bDB/vV0Y
 gZBEM1swZJdPB/TIHLBxtJO6QUSHKMoMFMgSPFHe7x6jzzDqkzwOsTOcvRxOWvWGjVxm
 +o2yhjhqR3CJGInNH3p2CfjPkEBStHH9MVVdFQ3cpAVQmQzVi0WCtzvCxYJR/OcXNiXV
 J8lEWeetfNP9iPiBjeBTE26fP2t5AvEMywWAQi7hgMUWfzw04hDKiyeYePninQYXuSPk
 rmsMj8HMFox/oDCPWD+R37WlM3nnyC/UEP3XfKtPnHsEfNNnSv2M8YOQhL9jU87i5dZ6 CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq7s0r8mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2I0V3170058;
        Sat, 28 Aug 2021 02:32:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3aqa8tnj9m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNF44Bg+8U1PWcwcdCG31a6rytfY17r5gTGALwG3C0K+psZItJRfy8vw6yTrSiEKvjrWUpkQ1aSvAKEpVegtVlH2s8zUVattBVmew+t1SwU6/tXbktxXC7TasOHh5RU60NvCl/uczorEsXad6cboKFB6JTa3WIsMLLd9KDbwesi4gfwL5lAxEMebcn32UCz/Cgeu69QSKv6HQdVfw263oGc1nu2oTGGA0IN/mfeqmnv8ecZgU4E29ggzDyBnmgBX/hmwW1TqAWm8uBHG4gRe/E/nmWJOkIRvwWsDhhDxE3klxCeP8tk8Lfi5SDvDQ0NcYT1OqRhAbOTzKqqSpJzFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2j49sHJKfgHBbA9bh5n1D2cjEBWa3/HR5ykDr+lYM0=;
 b=PjQSraZsBXQQOhsgsSADq3RBmAt5iCyLLtvv07ov8RtgVR+KGnoVmBMdKXRDVM1ldQYLzpgiEqT+J61hadD+/qCCljMY9u1+p5aogpv9aTR5a1p6d49hobfKoShmTgz0EbKy5jwm3nvjqy+TGm8weNwh1ByszfPW8GPJLB+4epVumVQn4daPqNBO5SkbAzjO+D3EZETWArTEVxYO6WMRmleQN3QoML4vyY1mzw5QRw0YOjDy7NgHTVczSbPxonpUKdFKfIEaN0U1q3hc0UV9UYp+K57OAiacJRF4zvTnJ0bmRLzkp1j+/uKpuTPPAkxjzWSzolvOrsdbHNK94rbTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2j49sHJKfgHBbA9bh5n1D2cjEBWa3/HR5ykDr+lYM0=;
 b=NvW4aAnvnVhHCIV+tfuxxbehYQQ15/hGbr/qdDv43kP4sjozuveEtAlY2ppT1JSSUtCVCHH3hX06hBtAWbbS4y5tKjreKwHhovsHL8Qy7uHyQM8ZyltkEW7DEwQBSYDkrVFYITtk+fAXh2bdtKj0lQ2/V3bPiF6XxY7NQng8lKE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/12] qla2xxx driver bug fixes
Date:   Fri, 27 Aug 2021 22:32:09 -0400
Message-Id: <163011776500.12104.3228253310913829072.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86380067-2642-4c6d-29b0-08d969cc154e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515C104DB4B9EFD09A0BDC78EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hTBY/D6j5NyXfNAkIwuuj8J+/7CEk4kcz0O5c4FHeZZV0mZNqB4qL2xMq/nvdG0+XVcMZzkJnUA1jMIu/8W3fch8/xTnFZsYsOH2u0Bg4lOOg/N6J3AZI+yx2a/Av1BMFO2UUYRbfrrj2EYdcoH5KhMtSp8sH+NLiZMli6OBz4CdF7EP3/KKVWR5Bd1MCJC6yMqXP9WwAUL/yyjJQiMrjwHCIanjW8VL5EOok+qMp6cHmHVxTEpymmjqg7pQ8ow7asBs5DJbcHKvcRvpXo76LD1XV0OL0dF/Y5QJ02Pt/7oA3pxxg/sb/4RtZaOk6UJqgGCTvEk8NAtgRnek0ntOIclTDNmO+ssxdmQ+yVW8igTzgQUOFmx2TgGkmYzz34y7ZZND2K/fKBNwd7gl4TEJBvQSom801XVLm/XEI6OPGBsTlJwm8YcChZiRCO/vHwN3gfU8uGuvbDW86WFwNmjNzAI1Bc7WTjOpnAVbfYQTp2P3DUu1ubZ8NaMO8HYUUNqU44xCie8SYKthNCeg7D1LAU2WBoUc4u8yePXUklEXZAL58tVY645j080H3LlwJWcW485jEGYE38kK61XgKLeuEcDq65kb3qEEbP4fhRXmU9nxoLULS4YPs7UTWgMvuZNeiryLcvsEaO+nHQ06w/GxvQF0+LRj8nbgn551Ngx+Y7geUVBuiIOGRbq4PaEaD3GcxR+RepJfSFokBtL+hAq/ns9S5ooStqDckK+opedyK1ywrS8zWR/eAdxli2+1fEWhG18rtl5TpEoOp+rZ9ThboxAlJ93sZlUDc80VSa61uuFyjNlaVnBIl/fF3M0I0lNN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(6916009)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0lVejI3VXhHdEo3dlZtWSs3NGpQaGd4VW00N0drbU83ZHBDY3dFUU5qeGdO?=
 =?utf-8?B?dUFjWDExdGZ4YjhJRHk3OHVBRGpkVEo3cFlKYU1RdzVUc3dMM1hYMXI2blVR?=
 =?utf-8?B?emUyNTIxbi9JMmg4bmp6LzZpdlVVUE9HdFk2cVFHTGp6OEVTRlhVWUg1cDd6?=
 =?utf-8?B?TmpIQ0Y5RGlOZ1Y1ajI4OEsyTVNRaWtTQzBmZEc5TFJSMm9QYi9JVnY2cGt6?=
 =?utf-8?B?QzQ5T0Z0ZCsvYmVNblFBSWF2bk9ETmdZaHpueEc5cTV6KzVnbGhLT3RoN01t?=
 =?utf-8?B?clo1YUZXUTlIaUNuYXlzWFJZNi9weGxrRDBoSXVGcDhxakNscGQ0bWJreDVZ?=
 =?utf-8?B?VTJpYUFuTFAzdGxiOGtwaDY2cUluRCtYV3d1MFUwbFRXandYelBkRXpMcE1E?=
 =?utf-8?B?MVhZR3U3djh2SjRSKzJ3MFRWdWJJUWpqY1lUV2lQRmhUdVBJSVFpU3p0SU1H?=
 =?utf-8?B?MVBzd3BFQzdGQVlXQ3pTbmVSU1p0Y3ljSk9POFJndU96Skg1VEpIQ0JWclJB?=
 =?utf-8?B?QUZWMllJQUphRTQ1MmQ4ZFFBQWQ3WER6V0gwVU41Z3NGSGR5Ymwxc1E0c3N4?=
 =?utf-8?B?MC9zRm5SUFlNb2VaQjRsOWNxayt4SG83WjVCMEVIM2pXbndIRHp1YXIzS2V4?=
 =?utf-8?B?L2Q3NnN4UlVielhVMHUranJlN0lEVHUwKzBDcGd4aFFUNGJvQytxL3NvR2Z6?=
 =?utf-8?B?dk13eXlHVzNHallCaWpNLytYYWt0UmczUHhwdE16czVEY3lRampRMTRvamJD?=
 =?utf-8?B?STBnamdSRnZIdm93L3Z4dERzZTEvVG1YTHZtZjd5dEJlOC9XNDAxc0RvMmxN?=
 =?utf-8?B?MzJZNkt3MEFGM0dlL0dZMU93Y0FuS3lkazJPdjdOQkg2aHJURU5FWDg3aFVq?=
 =?utf-8?B?OHZXY0RBWGZENkowMVgydXArcGRuU3VPdFRaN2NraVlDcGFlekdOeXRiMTNr?=
 =?utf-8?B?UFVkMjlQd3FLemIyMkJGa1EyL0dyb3d2NEE0d1RsclZMWlZudEFTd3RiNys0?=
 =?utf-8?B?U1k0WjdobnhsSlkveWJNY0xLMmZVcCtXSDZMeWg2RXVONE5TbXdmTHFVMDJ1?=
 =?utf-8?B?MFVWUTdrSTZ4dldUeTcybk9xTWxnejNrTkRzM1U4WUllVEQxWGFEb2dWcjFi?=
 =?utf-8?B?bDBoSEdnQWljR0Y4VEs1VnEzOVo0dVFxNTcxTWxVTlAvUmpYYm45VVNSKzh1?=
 =?utf-8?B?MGVoNzlRdnF1bFVqdTRZMWI1eDFUeWhoR2xrc1lvL0IzQWI1MGsrQ09qR2J4?=
 =?utf-8?B?VnFyemQrczdSZWdlWCtTVXMrQm1TK05XNWVsNHBwV2puQ1ZhQ3VxQTd3dU42?=
 =?utf-8?B?ZlRzc0dNQ3ZqbDMyZVczUDJlR29JbFZEWFBVWVQ1dklLT1lVeXhJeHlsaWpj?=
 =?utf-8?B?VDJEZ29aemwvc1hSSk5DRXpSOG5Jd2Nua0RXeERmVzQ5MUlpY3BmL042NjlY?=
 =?utf-8?B?dG43M1FORWNaT3ZzdnhxYlgxSnZaa3ZwZEdseTVoMDhTNWtieUpHUU1uc0lJ?=
 =?utf-8?B?TVhKWjBaZGU4TERmUmE0V0NDenhSSmxtMk5HN3UwUVVtUjBaUk5FRnBRcWwy?=
 =?utf-8?B?R2F5MVFxbmNuK1BwZXlCKzBPRVIzYVUvRmxhNk9NbFhRZVM4SEtIa25rVWtC?=
 =?utf-8?B?RzNYTk81ZjF6NDQ5WERjOUtQc09KcjE0ZlMvaVlCeDJVUGlJU25IeGMwTlBI?=
 =?utf-8?B?M3YyRi9oSm5raDhOSEZKamJmM2VIay9wZGRPKzZQRUVDV1lWMDJhUHFYSmlR?=
 =?utf-8?Q?t5Qr6T+Q9VGTtcRA/rny0kcRB1KsKMoRngTnhhl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86380067-2642-4c6d-29b0-08d969cc154e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:30.3594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3cOkfAaWzzl9KciK46J5FKneb4tyqRl2Py0F2J6uzIaRCjtC1J4ZVFnpv0heka9Ig+/CyNnzgpLUkFtUO1mRolUyy/hN9TpvIXdzhC3/9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: G9C-GBWLs-A2YZZpk96ANu6yzb-s36T9
X-Proofpoint-ORIG-GUID: G9C-GBWLs-A2YZZpk96ANu6yzb-s36T9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2021 22:13:03 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[01/12] qla2xxx: edif: Fix stale session
        https://git.kernel.org/mkp/scsi/c/b15ce2f34cf4
[02/12] qla2xxx: edif: reject AUTH ELS on session down
        https://git.kernel.org/mkp/scsi/c/225479296c4f
[03/12] qla2xxx: edif: fix edif enable flag
        https://git.kernel.org/mkp/scsi/c/d07b75ba9649
[04/12] qla2xxx: Fix hang during NVME session tear down
        https://git.kernel.org/mkp/scsi/c/310e69edfbd5
[05/12] qla2xxx: edif: add N2N support for EDIF
        https://git.kernel.org/mkp/scsi/c/4de067e5df12
[06/12] qla2xxx: edif: do secure plogi when auth app is present
        https://git.kernel.org/mkp/scsi/c/1dc64a360bda
[07/12] qla2xxx: fix NVME | FCP personality change
        https://git.kernel.org/mkp/scsi/c/f6e327fc09e4
[08/12] qla2xxx: Fix hang on NVME command timeouts
        https://git.kernel.org/mkp/scsi/c/2cabf10dbbe3
[09/12] qla2xxx: fix NVME retry
        https://git.kernel.org/mkp/scsi/c/f88444570072
[10/12] qla2xxx: fix NVME session down detection
        https://git.kernel.org/mkp/scsi/c/7a8ff7d9854a
[11/12] qla2xxx: edif: fix returnvar.cocci warnings
        https://git.kernel.org/mkp/scsi/c/17f3df8fd718
[12/12] qla2xxx: Update version to 10.02.06.200-k
        https://git.kernel.org/mkp/scsi/c/34f69ec70355

-- 
Martin K. Petersen	Oracle Linux Engineering
