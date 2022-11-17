Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C872C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbiKQSHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiKQSHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:07:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812317A346
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:07:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHG8uZJ014161;
        Thu, 17 Nov 2022 18:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=F4PUe5sZjiUoPy0IdqiD03iZbtU2ELMAtd7IyqcfJNo=;
 b=tWs1a9Z8Un0n7C+XmvOiCLLCHl/YpsqUhL3HYyqaVyPnQ4/iOTX5fmfPFSN78v+PORmE
 z/rYty+nGoIRviwdI9d6fHt35sBDWH2qd+lWePUN1jXTVW+7ncZiJzWat+x/aWBriyEd
 Vk7OPaIM7ypf1zALr1GhGoBMXWKPFUYzU52OJrsnPvTkZ4It3hfFp2Uk5Nedi9RYEuAa
 DDVvFWCyakFVB2eSS/y1F6IK2neQyNIlBHfhcEZS8WWUlyXen5TXqcx7NJcX04/IDKa2
 SunJlKA1De9PZcFcL8EZfPW0i4nCpw2pUG2a8sW8PkBfYo62UmMhO1m1Ls0Umdr+Fhs8 Qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3jssxhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:07:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHNCch028873;
        Thu, 17 Nov 2022 18:07:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kuk209g96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7XNWPJeS8v3SX66B8SqWaBbVgVEQ90DxbgGGXCFxeeVsf7h+T+me7zRgP0oDpO2HzRI2Ty/W4tBlYYS8lkZf+Y/8XD+iFEGkwZIEY4ipk6RQO1wVT630A0TpHMrffAroZ/Vn6gKINCTqTnpOCPiKoXQ6HgAYaCiTteqxAHfNjSOoLjz3nJQ6YuvIHraOPs/H31xZcM/X5G5ZYWmWzf6i4KMM7ewsIRkIIew53OBk7QeWGtIxKi8lz9P/wkctKaU0kdQCInk0xA6F1Ejp8l/S+35ZYtC3jMEjxiSjXSu+SyNNoe0nYzLDBLjU23UwiHLb8I6IAuEFX1gCpk3tod90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4PUe5sZjiUoPy0IdqiD03iZbtU2ELMAtd7IyqcfJNo=;
 b=gzZ+E0Y1Co9ar3pBO6qa7h95YpXjg31/A6DjSGm8P7hFO39SjjIGpSThzsNFjinPil+uvJb3mI5vaOGaV4ZFMWEnU3GMEoZWT4Hc4R+3dNnRK7PlyRpcBVjfs+0rTbdXmgTV7wMbacI6QToHaXXV+6Y9XMCxsJ6HFrtvi/FT6poVtQHUx2BbMR4aFHxKV7GX5s18diEOxRrthTrQv5ZmnMjB+p8S4NIYNv2jie35xP1g+dASC8jIniKU1EmD37r9hUEa5yHTlYLtGDxVlVlqqksLK7wp68xXHtEocDFd06mcprKua8a5w3WODguzuVuig0sPpFbrsgz1QgR69JXKuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4PUe5sZjiUoPy0IdqiD03iZbtU2ELMAtd7IyqcfJNo=;
 b=OgH8i5y07AI4B/4VqJQPzj2+ejlhqj044NxHYgOxMcJc6dqrdl6+rdY7wB7meeKbYLdF6XcbcldKZCveFVeh4OCQeNyFliMMxFDH3RVGOv4g5+FWjw+G/wozKHqMAmo0Ch9N+mu1suWwk78z2Vg4Pk5DDNFrHweqF80buGxdAWo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5578.namprd10.prod.outlook.com (2603:10b6:510:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 18:07:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 18:07:06 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v2] scsi: lpfc: remove redundant pointer lp
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsehxxoh.fsf@ca-mkp.ca.oracle.com>
References: <20221108183620.93978-1-jsmart2021@gmail.com>
Date:   Thu, 17 Nov 2022 13:07:04 -0500
In-Reply-To: <20221108183620.93978-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 8 Nov 2022 10:36:20 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0030.prod.exchangelabs.com (2603:10b6:5:296::35)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5578:EE_
X-MS-Office365-Filtering-Correlation-Id: c6bb5021-3dfe-4a55-85ca-08dac8c6898b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IYkZKfREdvuIIA0H8dqFt7zjxykTayfsxG2hwCmuItCcb76wsbHkNG830dv7cgq+LMylOUtnJkWLvdZwQ9QBCtM0fy3nQkXkqUyg5z5MoEDiiO56A16v2V2WvjX26yoznZGGXYxHHeeOGnD45aBKqSpawzJxmQn2fHrbN0bXfmOqbDi8DYJstUuPRz4yu0jCmD+7BSgWEgXZlmRxlirGgFkfjLh0OGf9+FGJkH4iLTGCa705qQvcLunT+Uu7u9hKrE86VayipD52gblKhhhCCfF3XttVeZRWBBNkDB87S5Xpi9tGOdq4vs9s8AWCJx3bX/mVyVn2MRrGzjpI+HmlikGkLqDzNhPAGtki2rkbnKt5LDZy5lrv0RKxh09tyT9PFLQ0vUt+mogobF5PEs8zlJoTTDGtZVqYZXrHB82WvDIfvur2hshyS4U0OEkOCOOXVT+vYhkFJhCPwqlBCdi8Djz7QnPK+bXrm3Szii35c7enrssRUtkQFSfN0Ofah0mr0hgFoTE0UVogzKkgdSdfU+lM0KnDzv6SkTpVNvsjbILgipLLPmylYaCtaDRGquV5rFchg6IcxBX1WsMGtABiCX+wvUeba1h7dVk433MxFew0ZXI40VdN99IKy052Rrv6yJ0jc0Uk+ElSmAGK8rMdBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(451199015)(2906002)(38100700002)(8936002)(5660300002)(558084003)(6486002)(86362001)(36916002)(186003)(66556008)(8676002)(66946007)(66476007)(4326008)(6916009)(508600001)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JInlM5un2cibD6O/f8ZareYISDKh+Au2w4pFa19qBv0/Yk3819NzV3mjrJwx?=
 =?us-ascii?Q?UQ/2oaSdQrSUBMyNL+Yq0twXHXYIorj1Zsj0JAqpjJY17N0scQKyLSz8pOtV?=
 =?us-ascii?Q?pE0i/Sdrh6v6E+QaVG5ceoTO6B6lsCjCDwuAingOqXy8WPJ1WD6COtczneDy?=
 =?us-ascii?Q?a6617WsI0rVtoYM5UFXmkf89An7A0wXbDosoJ2gxLcwAoWjMND35d93SalYK?=
 =?us-ascii?Q?EnDt5y4OXIblLjbkRzJqOp9s51J8MC9uI1CJNc58/jbtqB9+KjaOyzY5GGO6?=
 =?us-ascii?Q?C6LbzTQ+JcafPYxNYNADigCXJluQoMPr9TdSZBmUmXehAuDSt4ByCjxYne2K?=
 =?us-ascii?Q?v+qL+EaV/Bv1dRAPmNbnDNX7xSgsW+zWqw0s06Mc/KLZGPvAOtDOcQUExvH9?=
 =?us-ascii?Q?GeUsqJQxNV9Dbd9RMVQGfEIXIPiF6JxXXk3aWY3hYhJ3fBaQDu8yq42Ege+X?=
 =?us-ascii?Q?yIUIBAIUS8lJ3QLPBQGgIWx1IE3udVr0KsG05dh2BuxOfSJG2l3gCvW8h3ja?=
 =?us-ascii?Q?f4e4AM3uuko+YAC6ZjuywcSmZqTarExvTxhyx2dI4uQds0bpdmYLnJXk0zev?=
 =?us-ascii?Q?zFtsPIlMU1PhIWsprsehEqdyHtkd61TRoACmOLDRHhj1JXwJxjik0EYrBWhW?=
 =?us-ascii?Q?vCEySxlbpNuZakI5M9mUIUuXnZel0MM7r0d7vTCU4H2UYYqeJJJ+8QxTEnZw?=
 =?us-ascii?Q?d4ClFpy/qTDDKXCmmTI1YiHmEx0hqUEOCMMCjDd2y9QQKPZqAUSvGR0kWBfT?=
 =?us-ascii?Q?2l4kDogvdsaXf3Dyg74wFQT8EYnu4SYsmT5cGM1XNkp7+MPSem3QKkNgIFcA?=
 =?us-ascii?Q?a/jx41ap+qZ1PjDQ7kQw0RyLF3JNQ59WVWAfbSwYledtVU/fAf/NzH93z9Ef?=
 =?us-ascii?Q?MZpwWhMjdtnj+ohkG/JTRu8NTe5Up4ftx8Bw4n8/hCWAU1hqGn/x0ptn9zZb?=
 =?us-ascii?Q?JbmfeZRf53bknZpwMRgKfyEy6/ScQ3JPL5+FoH6w/ltO8A0mY6vkC7s1HLkY?=
 =?us-ascii?Q?+6Vd5ICMoE0Liw/irJRv+YUo5faSea80uKAn3A9smZONozR9x/N+jZ8d2AkC?=
 =?us-ascii?Q?WmIcuSyuHDBF1vZBzsSCwzqk9BJQ5VhE96f+w0FK6lNQj73dTYnHnGXEg6WM?=
 =?us-ascii?Q?pasR1gfexnzgcZK+KH9g7GMPbTNZP14n3LAbfG22hLc4mlMLPAsTErUWJcAW?=
 =?us-ascii?Q?hWki9jgHTbUqB+rnajTMZ0lJboaTVRc4HsetdnH8d99goJSG649/KI+JEKgX?=
 =?us-ascii?Q?GNLBDERYoJ7SeEopG1SPu1tQ2+eVmQ43bgWyKBodAuXcBCZVVq3fXyEOhcGv?=
 =?us-ascii?Q?/B4ejmlzADAXY1wG10mnLvmSNmHCh+3POlxROEjOEmcuXMqutlbTOZ1CTLPS?=
 =?us-ascii?Q?hbaT5nkEY7IHrc2qwT5vT2cYFAlrDu0PbfoJ/lXhl4dPutqqaSJ2immwFiXA?=
 =?us-ascii?Q?j4Rv0zDQwkAtarLwkhKNZFk/kd0F13BDchewk2gs/bShHz1EHrC1NoX7VOgm?=
 =?us-ascii?Q?JpaZVn1U7ZR+8ZD0FUYHEGgsveqo6X8I77Rgr/vx5LqJ/SQPFzzxkLZ4YtPY?=
 =?us-ascii?Q?7PN4f2nJJ9rIrSnZ1OaoxT3CEjZlwnfxZSWFurF+V4wplJuHYSBGVdQ9K3Hb?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: q9tzM6Vgmc4blighJy18Wm1oGsaxZXtqCoZrx9x4HJ87E5LnC6Z0ns4Bo+YPsVR+ZhxTeR12IP8YGjByfTLjssoVe8+xZRRFAUWGrM+UhcMUPN1raZfA6fBxuHRJ2m2Ue5+caZR0AfD+zyUXWQ53fE+aMdhXhcELv410JH8EilVJoLc2ubXMVcq/YEjLtM4zk9OP9/zeF0Y9vpLVs+e3Qe5HcCqwUFBXdiVuhCG1t9bwhr93/g1SmLb6sxK5me1AOQWecE0tMUylChEUCEs4K7hQVwbAQC7U2WdNWkdUWahoUo9cVSr/xNA1rr+rXPysu33bBeh7YsJSefHXlM1zflOv+xT2gzH+68kBcNifzdv/nRCOQP6njoPwOn3EbneKgj/cK07KVT9JGbfTciAAM/riyHtgbtuoEyfls7qFjMD/MxcsJ6XcatTZnfR3didWJrEXAxAF+igItGniRAtxuan4uVUE5yebsjtJIXdol7eOcd6JgV+Ekvc+aj8kHQfvmWcTYLBnhgSTe9egSUsZOvQJozhLhFDrAWQvxMcFAulWZ2Ik8usuRXHU7H1gUfh3jGF5nPVANLXE6BZmDmK2bOZiGYBvigvKkJvY+/mxgmLAk4Cxzzw1ETbIHeV1G9EChVfCvZpPs+DXWewxFSxZ63WXU5R6l5YftB54iIKmG6yBS/J1eHKfsgx5kWzOGtGOcxnQherbaW+hJYCWNfhBu/bkmUHYwAAeAL0yHa8TVsPmt5qMBDJy620swP/xGkEtDTmLQgc80OPZ0IacaxJ/To0bqbkeDsKqs73FcXPSBxQe2mZx7QnOtHfifyqoLt3v
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6bb5021-3dfe-4a55-85ca-08dac8c6898b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 18:07:06.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yT3VyaqMWhrHmXhC1RIjGi9VfAdByKCZuTs3pw7BvFYbd4nU/8X7h/WFTgKM7ib7+9iWKsUHCef3mEhbqNOaBx8z9Cnlwcb+P9vVKVrf+4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=806 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170131
X-Proofpoint-ORIG-GUID: G5qoJ0BdD2-mrtE-bOtoyQboFHh9rZob
X-Proofpoint-GUID: G5qoJ0BdD2-mrtE-bOtoyQboFHh9rZob
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Pointer lp is being initialized and incremented but the result is
> never read. The pointer is redundant and can be removed.
>
> Once lp is removed, pcmd is not longer used. So removed pcmd as well

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
