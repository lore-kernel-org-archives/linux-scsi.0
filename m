Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF016C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C29CD6023F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFWB47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:56:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54654 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhFWB47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:56:59 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1osUJ008638;
        Wed, 23 Jun 2021 01:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6LTjxFljjoH79ax0EFUAObCZKku1j4XXRzQlc4I9+7M=;
 b=e5wa8jictnLEZ+zgjJXDavWY35NQSvqwu+XLqh9q6WS+P6+crjZxxB7WL8kduN/zAnPB
 NUaTdxBTyXj/qcx3NglrO5OIpC5S2ukcdtlKCDOPR6djzkpEiesD8vSO+usu48JbHLTe
 N3t/Xhw49wKsnXdUCfumqAtHPLzhNAH/HyrVDGA4CaRImpFL2iPqWHVLooZITWUy0dfO
 TUEltpPf8srKurSStCxAOAn6u9yehVfEClTMmaEr2xVtKKBoDlZ3rp9h9WzagDMgmYlY
 zhX/7BSYVKAGhpmPd2Q7dq+aNUPaADAMPeSpjVcaPmrSLhxWH6L9lRC5btg8erxOGyah iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39anpuvu3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:54:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N1pEHN158760;
        Wed, 23 Jun 2021 01:54:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3030.oracle.com with ESMTP id 3995pxarde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggbnt0PPqTAGkHwv68zts+kjyhe+EK5JuA6okEavDM31m6vbC0me2pz2gp6sJel4Zzo5d2DuwNqdsIRGvotQ0G1Dl8PwrKjOtXBLqtE2s7MqjUgywKIY0/fifZdJL2+MHKfQ8n008/KVpiRO3/+YC/Op3MlavpS38BpjAS8sFvtD66reLiPMQpZ8ltVp4tFWAod6FcroovnZSSd+1MhVLPbVNDTYpz+IN8vl055xzixQne/z29ce7s1ebpIbwQQEwumpJuSGo2AcBukRbHFtptPjSKHDsoZiDEkBy69TRsBOP1QwPKQBMegGRF57Lv9RsdlhJGRXAUf8ujAjFSiRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LTjxFljjoH79ax0EFUAObCZKku1j4XXRzQlc4I9+7M=;
 b=FykZATnIbnWkfzK7MZur9hpZTyKbNzoW7kdBGw53N9QQI2YNOinv0iwark7bQOGz6122jPelFE7QQZ2YdsVOclEr5VylDUk42IcC/0cDpyPdkrRpU4u8/FeRzG05V8EvrHdLKxUhCenIMIQUkivn4Phf9HA/jDQ9HBG3MtXnjUWB1JNEPQZ93GK0gDuzF9zdai+5oN3w5iI9xA2CGEIyL5ggf+toLN8VsvbHDgV9VNDFgd6geDdWWQ03liqM3gArK1+SgnEnmuskj8fKWhEOw1tB4QBmwMIHKbtGSNe/91X2gQUWHrcXkXi+3qqBPSmn4sbJ2R0iCe3RDGD3kgKx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LTjxFljjoH79ax0EFUAObCZKku1j4XXRzQlc4I9+7M=;
 b=eFmLanRKkYjTSINWdq1lTUP8BzB0boFepCIYj5fZCFAwi3eTcfaknLHwvrHkAVlYJqKNZ8XSzIwQlJFWqj0GItMLOqib9coyldwgVBObWOObSCDLWb0VlwRSQkqOwfiKobQ7eX6EBgJCQiRdmItp5GFYJ+a80j4VVfYjZXjRYJg=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1295.namprd10.prod.outlook.com (2603:10b6:300:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 01:54:38 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:54:38 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2] qla2xxx: add heartbeat check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s31s5v1.fsf@ca-mkp.ca.oracle.com>
References: <20210619052427.6440-1-njavali@marvell.com>
Date:   Tue, 22 Jun 2021 21:54:34 -0400
In-Reply-To: <20210619052427.6440-1-njavali@marvell.com> (Nilesh Javali's
        message of "Fri, 18 Jun 2021 22:24:27 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0701CA0033.namprd07.prod.outlook.com
 (2603:10b6:803:2d::27) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0033.namprd07.prod.outlook.com (2603:10b6:803:2d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 01:54:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8c3cc52-e79b-46b5-2ac8-08d935e9dba2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB129516BF71FBFF1BB6F5B2E38E089@MWHPR10MB1295.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FfcGUGMDHt/lpHRGK67y73h7xo3qh6r5MbASaPybWm7zxQZBX7rcP1C8fmgdRb96MlCq4NnOwSi0Sl/UbUTGMDvJvUM/rdL81ZGEBfXGadQocX6YWg2+7x/5t8puyctxXFCTlAbx8sz4Uzz2Qve6crP0/cPdv4iz2EB/d0xq0n/jNrSyHtPEF9PsyY5kaSA1FJk9oFcuxpYeUZgKprCJnxd9Xz2Bo0qhzU3YTBR7wDMj2ngSGabxP5Z9q+vHYM8lPJPWpO1E+ReKTy7OGVykEVtvRMhQKoEaEMXB8BrKaNmsdGk7/fn4eADK45tbA70a39s4+w9fKlNPwjEh2bqvIcrVOuTQJA7dqcDF/oyJXBtFVZZjxOysuBmZ6D9KOnq4Gdn8J0xU8EOu/ammIuRQ+teyV+PEKAZexkyKjAE7LW5uClRIovoe8GjTJMX/+hZ2FbNg8OXVZlsFNqfs9lPNHhQ/IzOVsgTEOPh9K7VKxkc2iyNeyuxDURTJOcRfuFuugdV/qitm/SNnH7tqVwMhJare6hhYjLoOORAKMLWuk2donU07H7QnEQ2n21OH1G1jjl8sRR94YnO2VC3uUkq/pYSWr9ub8FciXq5qfXUzxqx4mSpezXWDKx53d41l1PIG/Dhp4iZpd+y5FKx/6OdMa1k0YW95EWhOFe1330BO01mO0O3hmheWy30faAxZD46gOSKw4DuS3F9sCpwJ8J3BDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(38350700002)(86362001)(8676002)(6916009)(26005)(38100700002)(4326008)(83380400001)(54906003)(558084003)(55016002)(186003)(6666004)(316002)(478600001)(7696005)(52116002)(2906002)(66556008)(8936002)(36916002)(956004)(66476007)(5660300002)(16526019)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NO+bdaPsB8QoalOGNA76wy8/cC/L0Ghs/JPfzfQRaPSe1sPko/SpLGgFlJEw?=
 =?us-ascii?Q?YzdW9IKLhRzrG+iaYvCERl7dOw3amO1yxrS1WClofxfFoWfaaHs88nfhm3Qr?=
 =?us-ascii?Q?ULxWltB0cYZDj0Gh5aFxEYBLbNOkyaoaeMBM7TFMe0GzT5eo8pDGYiBr3Gl/?=
 =?us-ascii?Q?y9DljCfvO725picEyUtmeoO9xcAD/2YBx2zd1FSGPDlz7XVoJIou2NtQWP13?=
 =?us-ascii?Q?Kq9tIFYeM/xsu5zVoSvAuWqjgaeJ45O/dLWZ+v8NSqtwkuqoSDIfuqK3rCeE?=
 =?us-ascii?Q?EjI6Idzymj6JciBFGmcynRgd+VGA0iHb1eJ1dxfKX0dEqJCnwe6Oes9nGSax?=
 =?us-ascii?Q?E381hZwdcq0UEE6RkyBaG3Mluy9ArtaGRdFbiK4ZxlRLpStBXVT4fOfWiMa4?=
 =?us-ascii?Q?nTbLnwL+lLstAMjyo5t0/fN1fHNk+Mt7tLjmrgjFU3KWDBfjNm+i1+4jyo+C?=
 =?us-ascii?Q?4A9SmSa4vbFoXGMxXoqLHZGOCo+hc5pHm4gsMCzQ9CMtwq/yYCUo3w5aFIqQ?=
 =?us-ascii?Q?0vRqPnrpk2ACCWRwRmm8dpbB0FrXeloCqn6iOGAovFHcYEsbVv5loL67s2fU?=
 =?us-ascii?Q?h7yYRbebYy8LMa72DQLHkKZAdp2tyjcR9Xjz5WaFBWqosUe0PPawjMHUCfcS?=
 =?us-ascii?Q?K/gIus9oZdX2WtNLHzpGvSGytT6800CZdkAAlOjBMnDGkKpRbE0yRp2wt9R2?=
 =?us-ascii?Q?0oQUngSAJ/ah1Ppljd7dwC9zwCQ7BFR0q99Yt0chKoLBNDAwMwvlO9zZzWJ5?=
 =?us-ascii?Q?PHrhprLuF+A8r3WPP/faidJOMLUIVMNaNxcgwS+eXXK4OBbU6MrMhEqUlUr9?=
 =?us-ascii?Q?q/Mb1R9K0kFFsQdqa6m3k8SdYID9detdS+bo/SDXLGs3fQnzCMWb8F83qWlm?=
 =?us-ascii?Q?JFB6oeIAmLWLoiyvI1Ss7sX5cnfqEeMaIlqSaSKtZGk6kOPoCQeyGEHHWVfJ?=
 =?us-ascii?Q?On+cvZvEDyxsOP1bu2x/t+JLtG9Reuq/hJIs0HgB6SRjrkhLtXzeY4/KS/zH?=
 =?us-ascii?Q?Pru00RaT+PD7YslurTJw3ZYJ0qE6kmy27jqx5z+QoO9EyfYDh0lBFoVyL4aV?=
 =?us-ascii?Q?vrjuZ/YyaOTI4bO9Dpu0H7/OtSO3O9iw/dkNODAejh78/uTrX1hxFNtuIMa/?=
 =?us-ascii?Q?km+FIyGzobZh2844ve6wqE66QTPMwvRw+FTfaaPaCxbMMXErGwvwQyklCCw2?=
 =?us-ascii?Q?QcQb2b96w7BFDUrh8IvfI6z+Gr22BLcZjbE/Yjd56OS/vQ1CBeWiA/PZvlX2?=
 =?us-ascii?Q?bBVYscmKWxQnkEsGRKycKTiNdsmM0YyCUZS07n+0eVq3+7O2TYUTnBg57WmE?=
 =?us-ascii?Q?XRw7TpoVGeVc4uYN29QzOS8v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c3cc52-e79b-46b5-2ac8-08d935e9dba2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:54:37.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2naNbJp0i8Cq29AWLEEhizuzI7rDlQSpVUKOXPBhdrIxVdCGbrwkybBv+Hya701JKA10Y9FIXvX4peveOWNtDz364dCpIh+x4BmJYVRq3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1295
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230007
X-Proofpoint-GUID: cJAVMB8lTBhSwfQ_jmm00LkICqIYCDpz
X-Proofpoint-ORIG-GUID: cJAVMB8lTBhSwfQ_jmm00LkICqIYCDpz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Use 'no-op' mailbox command to check and see if FW is still
> responsive.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
