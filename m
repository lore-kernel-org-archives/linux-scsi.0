Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9452EC25B08
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 03:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239867AbiHWDl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 23:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239812AbiHWDlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 23:41:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AA65B074
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 20:41:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MNxA1d002950;
        Tue, 23 Aug 2022 03:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=jIM4ktIg7Z+YpLShOZa612H6XP+NLkFP/ji4wCALLjk=;
 b=DLSZDd1JVoQKAFXVtFIewPPUsoEOkkVDRXGeHuY3+QFqLXcoXGQLbjgYafPP5oZ0F90T
 sP9l3NhzAf2oBnOFoi8eWPPdC7/exK79x28P33730C23CqxN+WgBhxtabibCahjsv01M
 a1+LSoQjYf3Q+tmm2yZebpLmEPrvOvvUGoMDzbNQQJgUaQ2TH2cT6q1d2319C9cVVcHz
 5tSKmxywDYRGV063kq/vAxVftkKpp4jbAhCQoM0C4ENWkNfiVV/r3VRjxy1R0biG57b4
 QD7lAMuFxetbJorp4wFqj+tN2XEsbNnPxh7v5FvR5UqzPRNT+oEPlN/Yw8pezhRM4wGn Kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4ea70yqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:41:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27N0OGrJ031892;
        Tue, 23 Aug 2022 03:41:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mjdnr1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:41:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdJVZrrGjE+fyAE/Sj5Q/ER/3kWU1YchFhq4CsuldFeFX3ciidCv4cJLT8fvX6z2SVsVtG8Tpv93y787Nl9jNZh0SHD45eZmE5VVCrIxqPWpNGIdmMD4i4Vsqyw4jfIBhP2SPxjUsWUquv7p3O50tE3k+xDWjji+UbYsFiLFrWyu7W6JvbAcxdgYmi2gfDQp5xlfk/cS/ocaOSKlG65JLC4TpJcLf75dbf9jig1DUJY98EPNpyQ4zLO1v9nNVOQ4OhN3JBdGZd7Xrqg4CTOktlkDWPvEykC6yQB8ip5xnypXZETzujT4Are7gOc9yWH4sMW7OBSGmWJ1Q4+uPnD4Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIM4ktIg7Z+YpLShOZa612H6XP+NLkFP/ji4wCALLjk=;
 b=jlcQmH2L7iryWV86jC8CTNpaQKrlrJPfN1yTWeQbM2zq4WWQ4GiEUQV/8f70beiL3IDjqnSX+1t79Nk1X2xCz7FELr78gl3EmqLrbXTuwocPA8Nn+IW57fya6NqqAMtDZ5U3pHOO3+Civ0EbAtTG/kwtmZUP0VFNEsah3AaNl+P3DDbJi1Yg6i7DTeE2e8KoOdIXxNPoXewvuolCw9oFPhxhcKCMrG/gAHzmn+ql1R8R7PSS8ZTDyDQf9X3t+pfUeHc9NO6urQdDr8tfuq6hg5sTb4EFFRlYCgZqF/VeV+XM6ET2SjPh4woGg2it6yud53xfp/ui0KfgtXpRh2ihTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIM4ktIg7Z+YpLShOZa612H6XP+NLkFP/ji4wCALLjk=;
 b=pr5qAB/J1HolYMu8cCJN2SmsvxGpm/9TfzgUaIan27ye8rQSOuyBd+hXuYjFJvhZ98sNDa16jZW/gsAgjlFY0NWD9ASEXIwNAIcsp73c2NpjkFuYFUx9SPyRijwmgb0FgkCrpwl1nFgyADEmJONYxrcokEwQCllXDt45czZ8oI4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 03:41:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 03:41:07 +0000
To:     Bradley Grove <bradley.grove@gmail.com>
Cc:     linux-scsi@vger.kernel.org, bgrove@attotech.com,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        Rob Crispo <rcrispo@attotech.com>
Subject: Re: [PATCH v2 1/2] scsi: mpt3sas: Add support for ATTO ExpressSAS
 H12xx GT devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7wbaapj.fsf@ca-mkp.ca.oracle.com>
References: <20220805174609.14830-1-bgrove@attotech.com>
Date:   Mon, 22 Aug 2022 23:41:05 -0400
In-Reply-To: <20220805174609.14830-1-bgrove@attotech.com> (Bradley Grove's
        message of "Fri, 5 Aug 2022 13:46:08 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e289cefc-b7e0-4475-48ad-08da84b95031
X-MS-TrafficTypeDiagnostic: PH7PR10MB6130:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vaIV9EBE/79FEdCc+FatOc7nRwERY0oEslfdESLHi7C5MQhCMkn6x9BOulBhGZtyozhm3UKsyYQTmKfC6iydr2DEegSdwwDgo+ECY54+8AYUk8LM1Vu2Ekl72nAa0/JLr+l0LkfDiBUa+Jab5SdOqJ2Lil2KTqJsirfBm0KsJoPwG6HPrTN8ar6hmrAjC98hd6fUdxazwk2vwj0+6KQaEJfDZuzFD9m23JTle8RAyQmry971beBrhtJC1p1eLv4U+EjtIfY30CE1LzaNAFk/pqJ88BajV4FnCO0wE5Y2Me2wySsKKwY94CXqvSXy7/fvORCiUV6GdJBfRhZriRD39qvjupzDMRgIpEdGwX2vF0qt93BQ1aNIdgUWNP9rd8yRTdwLb3wKIRsy8Bj5g7XIsUkwrAblry9mdq0yhCbayIz6MFFRShZyI4J7x5QJTawz1FhbtEThuLh4ajYJzWz+lA/iy2QaTppYWXgKkeNNaQEvwbSNEBtKinvzCG6mQg+r79gugWV0DW9cM6I1JCvhsC2tKj5b9bzwjDsJQCFPB0KR+KQZsgr42t2HziMDmeseZhkIFlm6mVQ+ZG0aWMc8QPFtRZezY14dSRmRvzRybdKH8P1XNANdsekDHnM7jRaUiS7tsUqrEuwYXrTztKusO6dKMVIQ8GOzY0RDS1t+iBAAeZK0SV06oAd/zxKyHNEc6YgRaihBI2PcavTS5V0tHykeoUA7bgNyHJfzrN/P2RdUELySDaz1VdM3SHk7I5mA7DB4PpxlvQwFb4fwXVGpXeZUC8SVgiqbKdVj/2umnH+P0YkBcidVB5TVWPlBn8K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(39860400002)(136003)(366004)(2906002)(478600001)(316002)(558084003)(6486002)(41300700001)(6916009)(52116002)(26005)(38100700002)(86362001)(66946007)(6512007)(186003)(36916002)(6506007)(5660300002)(4326008)(38350700002)(66556008)(66476007)(8676002)(8936002)(49343001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?czOH4OR81IKceoX82AgHuQWZWTx7l+IfqGi5awSlKvqG9Kls3wrjH9DHEpab?=
 =?us-ascii?Q?AbfU50MseVcAnlF6SFhRWePRiDFx32YnI5Ruv4b2RBUUixxBjOSAFjK54dBp?=
 =?us-ascii?Q?sflJvoWMIUXxmh/Qa2VXER423VkTNQBUaRB+MxLCDR1VD2jPSG9Kc5F10cTE?=
 =?us-ascii?Q?roCzcOpsRs+YszJR9YDuwy30/JTLLvQfhrAx/cIh9XKQ1d+bNeuR203iJzCe?=
 =?us-ascii?Q?ICO75cPo1aseD/NybNGDaHQa/eES9pRAxw/sgvZuqJQzcXZsj5wO2MNP4WDy?=
 =?us-ascii?Q?rHg2fh2iai/Hh8yU5XYAf/VOTMrKdU9kHTKKuezW0LSyKeTy4fHeQyCWiumT?=
 =?us-ascii?Q?VWBIaARTq6ReERBbt9UB7dz3EvSzzh1EQbuOV9WmfLpuWhuv6TWdw4XwyPt0?=
 =?us-ascii?Q?FWzy+adXel8CylKF85XF8a7+TWXax28+Afvd+vkh0qJgE6n46mVvxRVKINMz?=
 =?us-ascii?Q?foF99zygca+enJzuDqaH+Evx9RJqJtMf+nl8pmwVhaYJYheTefZqX3Zfsb3b?=
 =?us-ascii?Q?thtAhkbpjg7U9aQuiS/YrK5dZnepSCGNG0MkFz22lyT88BVW7ZoaWkD4UUx/?=
 =?us-ascii?Q?XPqXkCdo/0e3ybzubBXX/VL+IYWou3Z4P7gLtFfr/H2zgrjWZa4EYtTB7F59?=
 =?us-ascii?Q?ukEjIfxwXV8DRY2eOeMaKZ3SopSHiP4tjhrN+9DyfQR4RhgXsTFoNt1F9WYX?=
 =?us-ascii?Q?sqh+SM/WPb9MX5aEP/7dLdiubsBLo2omtdKzTs1isqTRzlGBh8bpfbLVJCBh?=
 =?us-ascii?Q?LkXLjVpMEU3cbvAQTth6UmYygpuw85wuu/preG6zU8VnCVP4TWq0Q8fyXyXE?=
 =?us-ascii?Q?rpPhBGN7RpsxdjytWULCk0eYDNGA8bZW4KCY9634aSkCii7MoGNgzaX0KIOj?=
 =?us-ascii?Q?fG5BjNGWY4IV+CdulzMBRooV3ebVj4lk1mpy0sigl6voaNhLAwQ0fDHK8KU1?=
 =?us-ascii?Q?tnZhFBif9IoumwYIXhGTLjB9DC48hp9Q+k/4Xlni6jM9jT1ig32eBM5eA54C?=
 =?us-ascii?Q?IfiRi1z0Y6Zazq2AGy8U0J4JnyecE7gYbF/QytqeaceUsuLxSFNynjdUesCs?=
 =?us-ascii?Q?C/eI/KyVOuz1z3nN1ZtJqR6tWCXiNEmEiEXKXO1q82S4mqIjNTM7Wy36oeNV?=
 =?us-ascii?Q?HIWDDFj9kDwWLOoUK9bxL4B+OsHerLL3vsPzkVqG6+NRIOtnK/mNcG4vafiS?=
 =?us-ascii?Q?ozbvLk5cG4gTb5Gy4w46/8glNRjc8ljSOpnjjx/L4MWofqwK+rU23MpqhuGa?=
 =?us-ascii?Q?yhjKNN6p5N22zhTtTkj8ZhPz8uNW0N5+C1KinTwVm8r8oWDNg3OD1F2nRIXz?=
 =?us-ascii?Q?QqDIgIjfWdRjPvGtZBQPIIu58vi/JsH/ehYr9VHs2JGuSb7vvq8E8XY5czST?=
 =?us-ascii?Q?0TGdIqpVwzn39HYDHMUrpWvE65rUK7IyYpC+n7w6bxF7YRixjuJBUIPem0Jr?=
 =?us-ascii?Q?lFgQXw/cf3TuSmNgbPTJcP3O6RiHtIEOipUw1kpdwLbGxOqXkR3Z65x22zsX?=
 =?us-ascii?Q?Ho/F+/F9SuhbMn5iAeELKVcMhi5YfE4GOp1nxy1yTZXzlJ9+CR7aujqKphjw?=
 =?us-ascii?Q?gVrHSBhvuZNAO/CD3Xmnh0WWtdIdLy6wa7D+CgQp0aiO6iqS4Nag4p12USfz?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e289cefc-b7e0-4475-48ad-08da84b95031
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 03:41:07.7600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okf9AErgYlJADf2U2akNXAIb4dHptvt57DjDzBwcBWaq4QRR907AWjwMeuIyBtsUISTKtxjptrLT6znBsPYzy0P20hhGVeXyRJARCzxJBDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_16,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=969 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230012
X-Proofpoint-GUID: Nl8fLU7vGu63OKt3QvN9CM7Nbjso3npW
X-Proofpoint-ORIG-GUID: Nl8fLU7vGu63OKt3QvN9CM7Nbjso3npW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bradley,

> Adds ATTO's PCI IDs and modifies the driver to handle the unique NVRAM
> structure used by ATTO's devices.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
