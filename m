Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B43C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 05:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379235AbiAYFVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:21:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11064 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237217AbiAYFA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 00:00:29 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P2Bg3p001281;
        Tue, 25 Jan 2022 05:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zjSIx4e1CuuzjJBSVb6vMQWtjTLS/gn3NPKKt4HUpEY=;
 b=S2EmWIzXpYyd/tqy/PMteRCX9VWGMHbSY8SmvGBHIlWSy7XJC0tPdhQvwPmzKdlnT8JA
 hrvFQWNlIgjMf4ES7rlKiK0IDiKzhJrZ84uYCPQI3TptaISchaIu6IcUs7bulUAdcDm2
 f1vtjtjKGNRmoiI9zogvY0utZE2YPcWGe1TIHdZqFOqjne5CWxCls09AWZPPU2a9ezyz
 U2wjhFCVoJNaRQph6y210uxMM1HUGwatiIn6XoAzkx5w21xpaNAobo8yANsFWwb4SSA6
 gIQaLyuCvjqXLkE/nsZQB7wCDTz0S5jmxk47p3/JYmnHaKiElzxKdCnEvcvkla8cxyIK VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsy9s1s9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:00:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P4ujeE160340;
        Tue, 25 Jan 2022 05:00:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 3dr9r5at3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:00:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OttK9al7iXixI7SeAuDj/BS2MymdyutL8hSiuuXNGRcehtvCGv900PexnbpfEpMzEPgPaB/g+bMVLaRF1sLIP/uNjb+27FREI+oArGaLBvRNv1t79TLQiMzPVyO//vf6Ja2UUVw1jqJGGmA9GxELxai4s4Xhho3ZZeGDmLoXd4UwuRC98p1zHM5trKMeSQI0puE90jq7uGybE27doN9O2jHvbj3mqs4dfPBOCTzGPkzmjDNiCq/4Ofc1vYU/vzUVuPZT+BViXQQM0fwnRHNIF3M4AvHtG6aF/p00x/L3BZwlJWRMFNBGix7WgH4qT3JQjrh/yfqMaPiWrLKlE3khOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjSIx4e1CuuzjJBSVb6vMQWtjTLS/gn3NPKKt4HUpEY=;
 b=JsYCbm63wAUpQAZNXcIL4KmIpXD30X452/tNv4yRd5NYz//qAe8JMo+YOK3ltom19/oJLrP+TGr7ZiqBP2xy8I6IRsvb9Y/u26JKl+hyVxy7dB241W2KFfXWijmx+K1pPQS4E2ZIDD0KKIVtT+XC+sciEsHTZRSBtVqWNT0KU4DjiuH1aTmem8UOxSPAp88Ze4+MIQwQw7Hs1KyrHje2a/zoXR7HCyyaqCb/PbkEGJ9X8r1NEg0NklRIpn4nTwk7/i+mUikPIBMXmrNF3aiMrEn6hGJ60gvWMCogLfcpaNbu4frLy3ZnZaCQdpeZp9z6YglXEbCzqhBgdJchG4sojA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjSIx4e1CuuzjJBSVb6vMQWtjTLS/gn3NPKKt4HUpEY=;
 b=M1+OF7MmNBQ32GGDy1Daw+NqdxkdqsAdgjXJr0/2jGEh43nQqwp2QUUC3WyppJog8xrbimxxKiJ92jHM4tSX3GCNwPplMIzOOKRy2Doq8V0z+XJM4gKZF/6rnKvhZzFYTLmBoPAhfUkcnsPAE/HpHgkTckPxKQuksknVhVWtvTo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR10MB1767.namprd10.prod.outlook.com (2603:10b6:910:a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Tue, 25 Jan
 2022 05:00:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 05:00:09 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 00/17] qla2xxx misc bug fixes and features
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6fkh0kz.fsf@ca-mkp.ca.oracle.com>
References: <20220110050218.3958-1-njavali@marvell.com>
Date:   Tue, 25 Jan 2022 00:00:07 -0500
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com> (Nilesh Javali's
        message of "Sun, 9 Jan 2022 21:02:01 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0101.namprd11.prod.outlook.com
 (2603:10b6:806:d1::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dac5a7f-69d0-4d90-21ff-08d9dfbf8f7e
X-MS-TrafficTypeDiagnostic: CY4PR10MB1767:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1767F7195AB0397D9A125C0B8E5F9@CY4PR10MB1767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YTNtJJTmtTIpGu7ceKZiGHpNSHPW8rFDEfClDIf+DjpX9kgRRWkjsxp6K/pP3KubOPZpJpTpc52rKUkwW4mXW8xbtIL/5X+OWEbDBLh4kRiUQOhI0Rq/SvVdZjEoRj9mEZTPxgD/upyvDXhnK4/5uVxcBrJePybZeKAopSy5SxJK/uBMH6UfjEbIBxg7e13LXwyY1lQY06Su2OF38p5HzXtg2Z+e/OGtTy55MzJ8vzwXLOnlIeCb+2K/nXCmQs0ahzhJUdPyRPmWixnnbMeyihKy/9zi0mxs2NbZhPODxcb5wA6aDdWitCUz6qqrN7Bf4/3YHEqtNhsiPbnUmJZU9KpEsa9QP0VhXLSXcE/Rt2snnseGBiGx7K+PotwsfT/ogW+Dk5pvpGnTzfwzB5zhjxDIa6Lo809G6N5zxR1T/qnIqa//uw03AqK63wy4CBA6NKfI5Hapqq0oazF4YYasOSwVpCJvNv2bx1GP37TJgxlM27BNAnKBZt2z/jsnrofTL88J99CmCbR19GRKhyz+JUByCtnmln7DxguamuD9gkx/Y9Ec81Dzk0w4cxok35HCO0grtk+sPUK7+RLkyoBU8/hG/f9IRi2vmAdp7YywIDyKyT0NyDsUM70So/0M9REjBAcAGDe17S4r2a1SkrTb04OHA7L02Y98uiRol7uahkHqy0KyXotSzZ9SiiBwYYzrBn0SKjZGG/YPMNyjWTwDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8676002)(186003)(316002)(5660300002)(26005)(66556008)(6512007)(6486002)(66476007)(2906002)(6916009)(54906003)(8936002)(52116002)(36916002)(508600001)(38350700002)(86362001)(558084003)(4326008)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEAILP0+ByMfnPH3jfo06U4fJmSoAbao7iDL4XgihF+Md6UzLXW/EjfUN5KY?=
 =?us-ascii?Q?lbN6UxCL6/zwioikVKrvdhAhO1KjzboqknTcG2zdYJV+cEsycdzj9rpKaHNN?=
 =?us-ascii?Q?viJGT7LKHBB1LKUVsJOb/UXOlsJmoOAWALl5/GwvoZPpa1upAzaSO90RmRyB?=
 =?us-ascii?Q?M5T5r2L6LmiiMg2FGLhw66nEnZz5KVsqoc7C7ws5ExYM2jRSbTCxO9ANYgxn?=
 =?us-ascii?Q?a5rF99QbrxZoSXkG/XqyrcNrJ5ZtU9kHPEwMHZfDwZOInnwP06cNOzSNURtt?=
 =?us-ascii?Q?KgrZrMb17m0NBm+73ZSb0osqk3DG7KuLPKyqoVfgpCKiAopg3/vEgBryTz3J?=
 =?us-ascii?Q?wYPg8t8p8/3BmmTeLm2im6YCAU26dOJCNlwmotFlPT45uwaeakO3ILFtryEZ?=
 =?us-ascii?Q?ByTrO9BgDN0lK1ZjX19S6pxTYxM6UaY3yvl+/yi6ERZR5jDUMonrTa2dXUxW?=
 =?us-ascii?Q?vZEs4PE2N+flIYkmu2NV2IeqAcyzNQBQXbQGjspQzogXHFqpvepH3q0NNbiQ?=
 =?us-ascii?Q?rNImrzJetep8Q3TuyI/RSMyWPkiwTuY0vnl58qIoesKRpGHuKW84fvN1d+Im?=
 =?us-ascii?Q?Doqc5q0GcRGkb6KfefQU9pwY5MZZzO+4TH/WgVN84IQfPqx8EGAYBK9LqaV3?=
 =?us-ascii?Q?/u/UiGy67cQ5dNwNVWmf6EeKB75gcGs0WFcsWtxW2zlxXc4nTx+wkeTLRkiz?=
 =?us-ascii?Q?P28I1NIfbGJfU9kEQ7YfixeECTiP3SrgWc98EblEBH4hsfrKVchNnjE3rZ0q?=
 =?us-ascii?Q?rGP+y7aeM0ESqtq45EtyVw9wK6e8lLv3a12mBm2OFaptFatdgsno0TCvZ30X?=
 =?us-ascii?Q?1J7dWMafTrQFsPgr/sw+1J5wZDVHXm6vJaNz5GePlK8sQGRRZoICFTKcZitV?=
 =?us-ascii?Q?kT0OIm1buv1OBgVyY+ajIaq156oLMQAKO2qRAwQhdFtEGqpQ6FcHzOxCsamu?=
 =?us-ascii?Q?4j38nEEHOzr/BWzn3LV9Opm06XJdhlUrf7LfpPBfCkHUwlhmUkhgglsWyzc3?=
 =?us-ascii?Q?sGUFJ6MavWZq5ZfgLCsWO/7MMGUaM5tGsDGrunpv/Ongz+Vb9dcOBYM0rXt1?=
 =?us-ascii?Q?NPNVxMZvcJSZom1idW2qLRd3qn5ssZBdNlJSEQ5k6SR8nHPXlXVaBBGvBmVq?=
 =?us-ascii?Q?oeiJTz9cpM8CZIHzIClrnKDoySnz/zCVkd2mkoHGaEx7OcBQfVOZkEces/x8?=
 =?us-ascii?Q?Z5iHqDJRjTupchVANi82GqScna8NiufmKNvCtEdJ8I4uOYqI00rmRUZKe3Q+?=
 =?us-ascii?Q?1vT5VI7KYko79uo+U2tduz7EuQj0zjSzkr6Cj8I7jIlUTr0O21LKqc6OjZvh?=
 =?us-ascii?Q?15uGstUAam2n7irNackYOQhPvnjqzl/6a3XMkz2SEuIBc6Mj4HwoSLO3+AP7?=
 =?us-ascii?Q?1sFChTWsquQKIyWRzquAKNgEliSnj+GxWrBplsiiWTCSiaEbUFAeyvUuUfDo?=
 =?us-ascii?Q?4U4MEo6i0Ji4YhPKg5aIt7wVDoaFteesF8SddJWTZ+MzBMnpfeLAxhinB4Oh?=
 =?us-ascii?Q?TOHXgHUEVgTt2GTyCdrf7qUTzxYpx53e9ha1SWN6h+yiVotFnVDs34Iv4iKq?=
 =?us-ascii?Q?hc5NOjeJqyPGzEFb6ymIl3NeQt3cra1q4FSUDV/xYzhRx1o88uS5aX2BQJPx?=
 =?us-ascii?Q?XBc8xDNjyE+DnZJx1WROOTykhUMFMzoTWUJeo5w0j2m4wh1L2Apim80hy/Tg?=
 =?us-ascii?Q?xYSuLA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dac5a7f-69d0-4d90-21ff-08d9dfbf8f7e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 05:00:09.0367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2UmJ9M99OMZxySXgUckCAuZJghbwHXQ/jrA4QzrmhY0YaCqk5m9kh2EZ76YAKuY9livh6zJJLY2s40017eE6d/DaCE9ngOP9X+LhEW2z+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1767
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10237 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=926
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250029
X-Proofpoint-GUID: xP0sckX5lj6NU7PY5LEAbLXAod9CL9we
X-Proofpoint-ORIG-GUID: xP0sckX5lj6NU7PY5LEAbLXAod9CL9we
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver misc bug fixes and features to the
> scsi tree at your earliest convenience.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
