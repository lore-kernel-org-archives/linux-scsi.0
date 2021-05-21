Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3E4C4707E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD232613F2
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhEUVQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:16:11 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40924 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhEUVQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 May 2021 17:16:10 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LLBt98020675;
        Fri, 21 May 2021 21:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+Sx77N4x9Rb1Lux4PeBm8s14sc8vy1IoUEz14peFBt4=;
 b=IQ8N8mgsdsEtxwCRo2YEUQJ42XcDUyxYphlEGUTc9SpyLOz6ncdbLhpHumulAV3yQKtz
 eeMDurnAtIIPzuZl0/IirhgX08DCammo/SkZJiH8BIBUTW318NibTPNwOax7ecNwq2gZ
 CpDR+DYEXmkKoTN6Md6RncySgyXCMm6LaKv64lPtlkdGqvd/T1O1QfSjHeRvfVeJdGw5
 mrIInpX6u80hlrwiS/JNi/zkDTUOZmiw5CRjHu1QvgyKrBzQNH9IVLZ8hIEkPNcJ/FEU
 cr1IKyQsPXAo2yhiCsm2ESMN3AIl8KRfh8upPD3WRuuIbOUrhGI5C9350O5/ApqLKQ3u 1Q== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n3dg13w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:14:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LLANa3166864;
        Fri, 21 May 2021 21:14:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 38meej2sa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:14:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpTZbJujYmKAnWvmgJk+WmczhztBPHQOXLY3Njhh9reEHO7YJhLuRua/EYS7c8xgKbyPqY1YDbvjSLxdfgtucBMrCRTgrxZ52McQjAq/N6KizGrvC4vkq+38Z6I73s9R+zvEYXSDscZ1PXctmiHnQHCsidXhZsEvOYKiEL+STZTLsZ2Iu8Tt8OEulbRHqH0eZ9022GaLx3Sr3PnAuPJ8fWrt1zstbRcXwWxxVqZQhb7/59o/YaM0XSeu7FzVbximHV4JBUWw2YWjCw6P9cyCgnzX7WdstRy6EQusYnPBGbaUfiCLXTq5DLjqfXeK2Jl/WmQLRPN/Jmeq4WdqsOJYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Sx77N4x9Rb1Lux4PeBm8s14sc8vy1IoUEz14peFBt4=;
 b=Altt2ML8Q1LvkUs8YAWnMsz14taSLj8fWEUZA8GLwWO4GsKcZdQgvh5YHzdiVzSBsMPS9RywKW/7eOr6HKlIKWr2YjveOgz8+ev4xuqE+FFoSpQPg3lf9TCT5rfGuYNpFuDYEeyq+0NyVQr13Lw2oq2eUd0l1Tp+PgnBUapt5A8OK6SUyL4PWm5wwa95vu6ah8em9a1n7vMOTnlfAejOCSpEztdSJevUQTexNV6/NyW+Xt5gFf6UssAdc4XTe1Losq04N2H18cqjTw35HpxQ8bCotlN7uiF54GLiefVuz9nY73Nyomn0ezRgicVLCZsiwRY0jlGjIQ49apfQoK0kxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Sx77N4x9Rb1Lux4PeBm8s14sc8vy1IoUEz14peFBt4=;
 b=vaEXnMMCxF5Joi7jByxQY2y7U0o9O/O8H9HAlgj3VMxRr1Z0oEGAJDT/cIQcDbPRRFx7mbWzgu7o+xNehfPU/a1bw6qy2rfSCrKyOLZP/6Ht77quAtcHEHm/4sQQh/0kI6FQpAn959mjaO9sYEV3ExcPanh4sHZbmn6k94Qm81M=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 21 May
 2021 21:14:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 21:14:40 +0000
To:     kernel test robot <lkp@intel.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: fix boolreturn.cocci warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmxj23io.fsf@ca-mkp.ca.oracle.com>
References: <202105160749.IImZN2gL-lkp@intel.com>
        <20210515230358.GA97544@60d1edce16e0>
Date:   Fri, 21 May 2021 17:14:36 -0400
In-Reply-To: <20210515230358.GA97544@60d1edce16e0> (kernel test robot's
        message of "Sun, 16 May 2021 07:03:58 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR01CA0020.prod.exchangelabs.com (2603:10b6:805:b6::33)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR01CA0020.prod.exchangelabs.com (2603:10b6:805:b6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Fri, 21 May 2021 21:14:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ae22ddd-feb8-4c12-36ea-08d91c9d7204
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4789B556A869BC53A6FABA658E299@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l75bKm6cD9cAbpqPgfrM+6GFS7BqzO9tyBSOx8CG9hPac2quvfDhu4NyB/xqhDrSbnC7a/ths9P+hMTdQzE6j8iu8O30KQqHUUN2oy0sUEt4i+20BkE2gNH6H1A1ZeEgXUC27vnabyttHXsnU9yNabCg3uLVpVwcOMt6ACRWK3hV9QQgBH1QtWQRIARQyTHjNENJVXTgkbwg9Ioz4knPfACK13qulCKt/jWY7nywnQJ/1Xt0fiHDvF5uiZehRLdcd1Zm7tEPc62QI9SfeiLiNzp4tyGbd/2bRX7fcQm1lgjXhlz+N1mDL6f0wyhvsC2RarwaK03+Fs2BWRruyhHnbNd6GTh0p/zOBRU5cx9LX6NTpxkOzmAkStXCkQW3ixK+FzhhVwh47LrOwI9BJYCcE26EWUxjE9ZLSVYzICkKcmEJ78hVn1sc2awsQKvbFDUExrCPe+wOuf30wLV3e5po1RcKPL9AxZNA3sd8qcU1uFHv2KUTUK3JjhoCiq3ob7T/vf/j4+nYmvAvx1l/YQsuryAe0zl8ddYrHwLtkx5l4PdO7VUXCpYH6FPVBib1dV8rbOlnPXFLi0iGVlpeLbjQ+ymkzOBm6CDOFfGqL0l/N8XlpqdLa2qrye9urMkJTpRpUUsurYSMtrYIQ6LU0Fh+pac+3abqJK+SgUCSlIidPQI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(83380400001)(26005)(36916002)(2906002)(186003)(52116002)(5660300002)(16526019)(956004)(7696005)(55016002)(4744005)(478600001)(66946007)(6666004)(86362001)(38350700002)(38100700002)(54906003)(316002)(8936002)(66476007)(66556008)(8676002)(4326008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RCxXbgI6F8riZKeoU1g+Pzunis1YMo8mx7ARXR5aaIRsvEKKsHz2eHzJhbjO?=
 =?us-ascii?Q?XXiME6mp1SrETcD4PuZkW31HaKnaMgOtHTuJNRhFn1TuE3YOOvAm1XY1AR2i?=
 =?us-ascii?Q?SOjAQXNKC0BfraTIXr32JZR/mBxoqpVVDDveJHcpTuxgeBQhBlE+COVE3xUp?=
 =?us-ascii?Q?OPQ87efghMsEIrYhbn+dESA3RMQIwVH6m7nfVU9A2xT0JTvBd6wIsx/VrObc?=
 =?us-ascii?Q?jGWlzI/ZTl9u1NHqcOI37w5puce4uQEY4l80PNuRU1khXX2IYe1Hu/K7cU7d?=
 =?us-ascii?Q?yXuROpejmJjSJ8xYx/vlLz977RtRvUcCxRTR50lxRhLQjFugLBANQken7gcI?=
 =?us-ascii?Q?J+gWM9g4p++vgh1ly8e7Su16XJeDxLheNk0hGt6TzDgTsxI+cRtG9iU+C06q?=
 =?us-ascii?Q?5Rn4XXpQSSM9NO/AwS4ELJXcH2tBGyFDnLrfbuqsDLYndTp5CZfJS73Rl2Om?=
 =?us-ascii?Q?ny6vUtp3cbp2MUtiSpUT31nss6qM9t+5gl/TJ5Cqrw3JFEKyf85OMYbJxRhM?=
 =?us-ascii?Q?lnuX+xJlUansIJLkZE0dioJjYnlNIGI/TreLhCC+RTw/SPCOWXP4h7hkzhlN?=
 =?us-ascii?Q?bVTRZ/zyaJUSc3IFVbGNM9vFdVEBoSDeNtUXXOU4KPPhn1tCZl/WFhyDVSnC?=
 =?us-ascii?Q?hq9OOwbBP1RMwCA+bME07BT0Ld892Hv2yofNWkQQoBBtCwkiQjwaZtO5KhCS?=
 =?us-ascii?Q?xdXgMhKn/X87uSih+RFwR3dWZro/DhpcHZjTUkIlpnha4NfMs2qTfcyTs74H?=
 =?us-ascii?Q?mF+zYQBpVPVtKT3/vRkWnYiqkST+43vC38OJ5VtPzTS1DwA50SSEU05iAUWY?=
 =?us-ascii?Q?ThjlR4Y7zCf76oFaIRHdGjm18qqT1CthaSibV8hJtcPqW1Rc/v5zPyFOvpwo?=
 =?us-ascii?Q?G70+6ZywunF56ln9tJlm6yOUvrdJryijn2mYqy9olvE7DnAWv2cTyHA0yHbE?=
 =?us-ascii?Q?tGL5gxzXXNqVK8KnzDu3yzCTAkzBQ4LO+jsvJPVnCpjWPcTyPiGaKHpf/bVX?=
 =?us-ascii?Q?orBc6tdJoO8ZPxKm3AYRtewQ6Lw72oGdnImHO6UxDDE02qkWI7GsDMZt8W1T?=
 =?us-ascii?Q?1BOGp05UN2idfXVVpPwAOHaskmazeCCOQfa/RoekPUmXZ5TW2d8y9oj0XnBt?=
 =?us-ascii?Q?Q7m6iY+dWqyg9sGDUdRUofkyf2WoeYkibZQwZEz5XZ6kNE4dEXkG+j6uexqE?=
 =?us-ascii?Q?tdG7JfCo40268giA1y2n75+XRJ39VcXlkxnCJYkDNx6jvUc9kLcpQYHM/914?=
 =?us-ascii?Q?sNJYpHGoQpqqYi4Ae7/ept5OqRFqCKB5mciscg75+zoBdvpUuxZMf/XbdtzE?=
 =?us-ascii?Q?ZAU/8otLN9z1wNLG+Io7ftBS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae22ddd-feb8-4c12-36ea-08d91c9d7204
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:14:39.9102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5e7LLDmz4FDNWvl+kPAf14bJpqO2hGM603W4t0dC8d63++Pq16Nd5uyzb8ctyukZAngZMXmBInWiI3pbEWziPtjOOmIsFjB0z7qA0WwnGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210115
X-Proofpoint-ORIG-GUID: ajGc4cpaunf8wmDjYSnmpNvgXBzza81L
X-Proofpoint-GUID: ajGc4cpaunf8wmDjYSnmpNvgXBzza81L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> From: kernel test robot <lkp@intel.com>
>
> drivers/target/target_core_user.c:1424:9-10: WARNING: return of 0/1 in function 'tcmu_handle_completions' with return type bool
>
>  Return statements in functions returning bool should use
>  true/false instead of 1/0.
> Generated by: scripts/coccinelle/misc/boolreturn.cocci

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
