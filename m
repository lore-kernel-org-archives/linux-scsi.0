Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F64C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 03:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiCIDx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiCIDxz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 22:53:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CCEDCE16
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 19:52:56 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M9B3E010436;
        Wed, 9 Mar 2022 03:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nX3YdotVJW+N5iX1qPkPChOnepcLxPikF/mwl4YN/w8=;
 b=xaRN1/c6+vS4SNAc8UMUQbaX+HUR0RLaP3s68otu05hQ/yRDz+iKwg6AutXOZzoj2tuK
 Q+DZ5ZN0qGp/GIfvUTw9pmZ6McNNYnUzOgIoxyDLRmwNBM4Nz19ULtIPSiL3retEqP6b
 zP4aTyrr0KJZywJpaCEe7PbAcUYRFpB2vV/qkSdx2teu5Md+GNlXi8QUy1eayFZKYann
 aJAmV35Cg6ZgTMrIU+weRRLDzjnME5B9VUVzsnR+Bz53n0P45wmqcFBP5FGivwDujzJa
 h+b6jEkeg7H2PkDVOhDxXlAha2rYiEVWzOXV8+Kh8N+zALVI1bpANqSZR9T6+SyYA5QI rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrargft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:52:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2293paEA145603;
        Wed, 9 Mar 2022 03:52:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 3ekyp2q733-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcWcE4MgYNFt7suygvn8QHR56LUPYK7YpHSThkLj4RsYUe996HzgxnvyO7ytrjS5KshluVPJdpuljiPrCLGCN9p9jCDtkBgwmB7bpP6VQBaalc5ngcjifJJFH+SFZ8/vp6bL3/X068GSSdP0Ri3xnrFRUA3hUYI7Zt3MxYXW5X9c6fWGrLPL1Kr5Pt08QVMBdHBnS37WAbYeVOyqmsf/0X/+9jt7M9GWimXb4X7fgkiQSo0BHcABe/dubuutay7SCYJFsZCa6NWb1JpOgEbU2rJ0NMJIMwa/ikKZw1q1iobqhquc88pzCPhG1f4C8GaCQtdlS8a+JfcqF4C2cUsmDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nX3YdotVJW+N5iX1qPkPChOnepcLxPikF/mwl4YN/w8=;
 b=Z9328coctQufTzCTV3fadveCVeX2gChIsgKWTKrKKxjWmBqoaBh0wc7WruuVR7pYyfHFN6m+0hdJI0UrgPbGAqPvmWkpV/7bK6hDZSbHidOGxgl7Fr9qFKw0EV9fo+wTZFtZbilrPSzcxs9L/isL3dG6FnJfRFyg5904QXDLlX4q6RwCpxPItXRoEYpUGDPubpkGOTcWReCWD3O6Q1FF8tp32aIcf3sIKMsCjl8M0BLHlFfAqlaU7mueOu8B+RRZFZb2W9DJAEU7NQ9vM1kzUZkHWXZ4R7bYSaKR6pGiRJL41jqo4SDgLHY1h4iIokDCgjyeap9mi48oHk2e84vp4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nX3YdotVJW+N5iX1qPkPChOnepcLxPikF/mwl4YN/w8=;
 b=PTylVXNMkhoXofjFEwr3XNX6yyD5PTQCyzM3ifK4I1SFRFxJlZfF8z7xbmJQuEg1HLVMoGVkT3T9hHLEbtrEkkUmW9wiPL2ZYFQMWG6jOoDRe7URXQ4Lh89DCcBe5bxuLRmczb2EOYp+uOdfulkaIKWl831LBEktzn1/gSSzV9c=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by DM5PR1001MB2332.namprd10.prod.outlook.com (2603:10b6:4:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.26; Wed, 9 Mar
 2022 03:52:46 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:52:46 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <mikebi@micron.com>, <beanhuo@micron.com>
Subject: Re: [PATCH v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsnrkcjj.fsf@ca-mkp.ca.oracle.com>
References: <20220307111752.10465-1-peter.wang@mediatek.com>
Date:   Tue, 08 Mar 2022 22:52:44 -0500
In-Reply-To: <20220307111752.10465-1-peter.wang@mediatek.com> (peter wang's
        message of "Mon, 7 Mar 2022 19:17:52 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0068.namprd05.prod.outlook.com
 (2603:10b6:803:41::45) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f5c4876-f3d6-4824-fc11-08da018045c4
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2332:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2332606508742F9B437656C38E0A9@DM5PR1001MB2332.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZB652y1Ay1aFB3kxL+IiSBgH9wyosMjc4TnF3cy4SHMc+DZmCBle1+p8fCqgS4VfkIR4uXV6JuIG8mPxFcyyPRb8VOtSasGQS1YxEGiAHAnGbUmPSGY6DFiRXbBPXt390PCQkK3aTmdIVavkmxj6WyjrdAOA6+IJUg3DBK+m3tL4hYMs9dZx0GCTByOeMKJ9mOwp84tg3jd3zErzDpceXggTIpylXYJjs7+io1x0MzuZC1V2MvxhkfOIUmxe93WbHA8ZRRUqQH2yrUxPptRLrv8z+07dnHRexo4z0AzbXS3IcsVT2XJoK1VY2+L0TcujDBkeiqnd4UJDCypyUQpxmeytK5vnslIpfnLlAVILNkogjR9+xMPcQ6o8yJGCDZHYLsZ7DCrRTUJ6hAZwcQBtGSYVlJvS8Py+WJNjTHnG6BwkN9G29XoSs7fcalXaQdiVs/u5YvTIYjNkWvyVSF9wdLwOsF5+543Baq43TGWTAhYYGrTpnpzTe3JjbPkyAHc15GFQTX2sZSfN4NsfE3Wi0LruMDWnUqamyKfD+TYzOpBSl5Eb1VWTOK++4hjR/H8HVNz2gKXvEBHGY4JFTQ4c4APvlnSf45k9GR/Qwilv0vAuKgb1qNnpddkcr2t+lYXBDeCQPhQ9dz7oEeVP3/wbV4mNVmMuV2j00dNRvrjuUhgP5Mo+vRA10wm1MNUNu41m80bwWrg8wmKTsywZDuEcRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(38350700002)(38100700002)(7416002)(2906002)(8936002)(5660300002)(4744005)(6512007)(6916009)(8676002)(4326008)(66476007)(6506007)(86362001)(52116002)(66946007)(36916002)(54906003)(316002)(508600001)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cIuRZQWIfQtCLmEQ0vtVRLN/T7zxZchX+tXxX4drLxnWlDRZ/Nosmlgsv0PG?=
 =?us-ascii?Q?cDlmZ9HDTUEzmr9NSLyG8MGdayXOdfxTnJLFs4Hr1niBZ5gpLXKdb60ee0FG?=
 =?us-ascii?Q?iI/N2nkartny9MVBhFrG2FupKoXQ0zNs6tlUC1UuTsFla/LVBaWxwXszyy8z?=
 =?us-ascii?Q?6ft7ww53BwJyOWuj1tt4GsBsiBfbq/rfUBPvexDqO6AGyE+dA8iVoTIMHvbZ?=
 =?us-ascii?Q?Nr809GMh8+d8VQ3+hTJmbXoHSP4tMTdEXfxWFV4BKlxfgYnk2XXPYpuJXzB9?=
 =?us-ascii?Q?uumkDtJ9p8rtgNpdNZaPD5eGiU6LMAEZs85WivwkQycujgNS9IICut6GIEvq?=
 =?us-ascii?Q?1QP3jQwMq0jMwnjwVSjaBi5Ign40kytpMgkSujtx64SevppPjMsSa2VYxc0Q?=
 =?us-ascii?Q?8oqREKKVaik4+m4roSHFH1SopSL8tnRLjF7w5/dCG9Mj2FAnLSuTwbeuOAM7?=
 =?us-ascii?Q?q5Z744DJPlB88yOOmiOUVn5BAqckQrXtfUi1WH80LmTz0rA5c2l+zAT+XeEf?=
 =?us-ascii?Q?iv3Gr6SSr5QJDNgmX6/ceBEskd/JnRBjoX9vCs6HSCZF17RMCpTkQE9sM6VN?=
 =?us-ascii?Q?qEUQFHD0fT9sXMEyMTyNaWJ4I56UimP6IwNNT0P17JWWJSYrBMBllWSHOPnA?=
 =?us-ascii?Q?ZEVaZMEw0ykHv4x2J/UmwGvxwdkOXvqofy9rbgasZAw4GvSDIpSnZpmUQAVV?=
 =?us-ascii?Q?jFwARn74w41YeNqBnZOki0OYOqyoPApvDEOhTwKswhu86Vj9BiaXLo0RzS6R?=
 =?us-ascii?Q?4Jn7MxSKK41liwF5nOzM6mjrTIIl5i6yze/aaelLY58tL0c5BjVK4k/j9zcQ?=
 =?us-ascii?Q?XCP/utp66VVuxJ0UPZ+Y+7etzTje644lg8FYG4YnN29G1801een0g/Gplgkr?=
 =?us-ascii?Q?cKX31xT6KuEvRKlGLrYYRvS+0oN90raNh011U8hH+z4RV4q72ZHym50ByQpg?=
 =?us-ascii?Q?kzWRvEiFPUxGGuadiXpJ/uNQgib5B+LLVOOJuumJa3vQlos1RgUzuWSFDhWi?=
 =?us-ascii?Q?xHNrqs4IPmntGX9fRMxV9QeLMxa80PKLXxIqHRRVltkxXNc7x4s5C+A1npiM?=
 =?us-ascii?Q?32/WWdwLrkSl0Dv3cSPQDs9on/MgC3lvP7EyrUAhiWHHPTZGQrpKgzK/I7GG?=
 =?us-ascii?Q?m16tRVBNbDFyCek8DTjWpYBbrbHKz09gVLkNlkZnFGKg2K6ok+bi3Px9Hd34?=
 =?us-ascii?Q?lrXHgPBM54uPJcddgxU6zkPBIuEZomc2X5C8FJnuX7DmnlVIOLSPpVcMSAdY?=
 =?us-ascii?Q?tJ56jNyulqoAEyHend+0oysGMK5BdVuKz9FKvpas23PyC73D+Y6BVqObfHfZ?=
 =?us-ascii?Q?gD7H/WnoPPeb+n3SR4CraNYR+qNUbROwhqmU4G9JaFmelJHJlwmyHTyzN3TY?=
 =?us-ascii?Q?I1uU/IQpjicT0/V0epf7zwYAj8CwDkpeYnN0dSkKWxAP9l90jqRW/4jMojj4?=
 =?us-ascii?Q?Sv/9bM5xBBXO1O1VH04LjFCYjTFENtRbTif/eQ6X8q7k89GgiP6BRY+eS3yK?=
 =?us-ascii?Q?s2QzQYYgw9ytndobk7k8dt7HDHcjTN5YVafhXLZ/DnT0hCjxxh5AP7duNQ0M?=
 =?us-ascii?Q?CrEZCIJtVPF/eP2o8O/oT8but6AKbXa2QOAo9nDGJGfrQ1ET72oYTyihy9Dr?=
 =?us-ascii?Q?0326k6NGOJjBcGnmfnJtQpaCRBG7cByeUpcQzMU5b/ogdQ1DCcjB95NK1Kla?=
 =?us-ascii?Q?Lr5uL6oRdyxHyVLMzRI+jJEAEVw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5c4876-f3d6-4824-fc11-08da018045c4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:52:46.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSrvIsrcmW6xzMeYO0UPL2i/8GuFP+OuL97QeuKPn1eujzYQZ3zzC9HMgvC+AZJZkjDSiiiRD5UXfUDceMBRti1XKAEnyRZRC6ercYEHL8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2332
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=728 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090021
X-Proofpoint-GUID: qkBGOVD8kQ3lKJv7rX4zRHl5ON7ZVJP0
X-Proofpoint-ORIG-GUID: qkBGOVD8kQ3lKJv7rX4zRHl5ON7ZVJP0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> When ufs init without scmd->device->sector_size set, scsi_get_lba will
> get a wrong shift number and ubsan error.  shift exponent 4294967286
> is too large for 64-bit type 'sector_t' (aka 'unsigned long long')
> Call scsi_get_lba only when opcode is READ_10/WRITE_10/UNMAP.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
