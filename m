Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887BEC001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 19:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjGaTTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 15:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjGaTTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 15:19:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79154139
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 12:19:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTLQG011009;
        Mon, 31 Jul 2023 19:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=u/+Lb2WucwRtb08JqCxUOJdsGaN5GpUxaSL1xFRlKhA=;
 b=kC2zQvPXTYhuEYqDtngLkMIj7IYZLb6hmfiOaEMEy8Rzo2vTbef6fzUqk/vul6ei3d/7
 k8pNQ847CHztqyChC5W/pyx/jYMQy2PNqxokOu9kAikKNe7Oj5pHPdftzrac6T41lS/D
 sM6w9ykXYYh3rDPhp+oOAVuhR7pX8i1YzhcKio8enfDlZaRk8EkQ7XmWyHPk3hPgk3+D
 /QCd1V/EqJkS9gMT5fOFVJLeLfk4NJrJ4zvZIxUyMqv7n8qiZP91/e1TZKJpHKe0K/b0
 Y8rHcJKiHWbJp80yVFJwEN+saQ/cgb5q6bcorJ0q4e3FnJ6PJk/QsjGTZknM+vDrf+ta sA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sj3ud6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 19:19:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VI9usK000720;
        Mon, 31 Jul 2023 19:19:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7b3s8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 19:19:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/+RvxFBK4RNd4kyvTsDGPMXGoNammwDFO6A6H55yvzGrrkZQqI2Fg1xtGwbohC1AuCitwGd25kqxcBwE2lDWf6GQkp2ryvG7bIkzmd4e8VGOAgsqCstL4k7Z1u6P2OgdSr8YCcNBTyKbUy/JHAhYrbutk7xaaxZeD5b4GlJhDTfupDK9CxF8SYwtPXp4olUlOHwtnqh6rnkvQXl3IiUue2UR+b1LA6pEJzpq6DrCt5OAkgobFsWd4cGRDh4uzMIT2my71P/2gjnyMPSiN2mfZUvUb0AUuUJs3DAnaL23CV/YftHOp4bG61dTPibyxFbZLkzeEQYV2BH33nBpKkVug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/+Lb2WucwRtb08JqCxUOJdsGaN5GpUxaSL1xFRlKhA=;
 b=UiH0Ol1c1yQhyszeujCjQBUODqdrDfmqNqGIz+MqkwrZe/FeEWC15xMmh41QN40y7kUmlhddieHBxwSb6FLdjDmWYcGvu/YyoYuecMxlXSgx6AI0D0TFeajYLWH2irLShQgyiZOU3bb1oBHr9RTFJdMvDU4eqq5X+pHFYwrKLRS/0YjwZ0Fu6707QY2apzUr72FZhjQ50yddrYgZ7NDRp5BGcz1CPrcy7F1l/ne1RBGAkwoouEoPuuKfzsvguaNih8G0DLg4ixuYb2g2RpuXtpzy+qUTdisJNzV5fSpze8beZtelMWHZWrY0ATigUR0LQsKcXEyP4QWqGvOZPZ5lsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/+Lb2WucwRtb08JqCxUOJdsGaN5GpUxaSL1xFRlKhA=;
 b=x95/KqR9vksAMJ+vcDZna1lxQOvQxZqnCug3+AMV4BAtn45bOy8p+Hks1AKdx8MF+Z2L62/4BLirXfWumnT0RZFdv5ydaGSTTGRvE9RuTfYskGUnGkYqB8xhaVjcNMxwqk/4cx6NDJ6v+hPWUNyBJDhuvW+qR8dCmV6TJ+CRPag=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5207.namprd10.prod.outlook.com (2603:10b6:408:12c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 19:19:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012%4]) with mapi id 15.20.6631.041; Mon, 31 Jul 2023
 19:19:35 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2 00/12] Multiple cleanup patches for the UFS driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8dzq47b.fsf@ca-mkp.ca.oracle.com>
References: <20230727194457.3152309-1-bvanassche@acm.org>
Date:   Mon, 31 Jul 2023 15:19:29 -0400
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 27 Jul 2023 12:41:12 -0700")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0160.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5207:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a7d53c-9ee5-4c39-ec33-08db91fb1359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIDtrcWZMT5ljIEW6ij187XfexXJ9+mok5G5fdIFhd4eZaqJ3RcYd5PW+egXmDN+jSZursYHI+/nehQoMb2Q/cMDYOSyPNhdTEdXTcP9bua7TKPPDqPKq/Gxxirz47SI9BlBXNCsWb/YlGOdbz4ZCssxgPbkKLPVNAkZ0wOzkFQz+fCIz7g6bKFg/KHCOVlj0jbzzM7L8+7pQi5XbANX94Q7oJRZRixs+obugM5X3kJf0thFNE6WTqJ/hNQV8BIBTXhiQ87nULy0IgFVjFCW/8cEDITJXHgfognWmECMK6MelrAqsd/9+ciqFMFIMO0IYbOnre8XkhhmqmDSZ8grKHnIoJelLMDnmd6K79MpViyO7X8Xyoc20PpYhx2BmDs5NEGPiLLOqlCDvBPo4awla6XmlNA4sZqnPBZXHdFDpqE6XlNw+4xxggt8XhMywr8mH6wsSXxm/5F/p0adGSrLmAwCDCd6DI6E3hDcJIn/c7ZqxQDaU+QQJQOUs5fTPo4GXlE5ZQ88ZHtl5xGRVGHDjX+sreCIxZmwqUf2ukAg/tN0rhOqujGs1YTDfJnfVoan
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(6512007)(6666004)(36916002)(6486002)(186003)(83380400001)(86362001)(38100700002)(26005)(6506007)(5660300002)(41300700001)(8936002)(8676002)(6916009)(66946007)(66556008)(66476007)(2906002)(4744005)(316002)(478600001)(54906003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y8aC9OCXw+/YCuBvqv8HL7LMjgyH+rdEAxLfU5e8yk2zfyR366fNZd+35TJP?=
 =?us-ascii?Q?6YXPcDn7RF57TaGsiEuijcQzPF5C+Nmoa1Pu7V9MQl3Xvw6yNAQJasCWGqxZ?=
 =?us-ascii?Q?vkvGzbIyDgq6N/6QrTPL8XHJpki6ndHKxtltQJ4dnA+TjjPHgKVAJsctSLIU?=
 =?us-ascii?Q?uzVAB/5cONUYv6Va9RPEXQDIqTHoIzYcKr6Gfs8oZRHwH63xtMW3wMITllEI?=
 =?us-ascii?Q?t2Goj/lOWclIvvHj3PpNmO08qU6MGMzXPK7m4JcS6ZpJcz1Ek+wnOuvGFWCp?=
 =?us-ascii?Q?fqycv798u9jwRmo+aSKQUjm5I3xmp9ZF+iSovHCfe/jsU+TuYMYQVMPGmIbS?=
 =?us-ascii?Q?9of/+v9ioBNlzSNsor9CmOLa1+4+CJMsOWZW08V2Y/G91Ev4iRjSKnKSL+1U?=
 =?us-ascii?Q?7NztzdjpCNjyvboVDoZ9mNilL4DaHCpW2mOODCjgR8ScsqFjIFYBdDHUp864?=
 =?us-ascii?Q?/upNAafFs2rPUtgKRe9I+LBrQMhY1mku+Jbq1njBJwKLi3ZfPNq08b9cikXN?=
 =?us-ascii?Q?OdRJNGs0C8Dl43EYW1zTa6W0GDvTdZJ+d3c6WWhWLWPna6sn3xRhjTqO04lO?=
 =?us-ascii?Q?Sr7V2LwXBueSQSAcCo5HHnTSk70uLj5rqVff2q8USHZ3amo8SwBLKeu0Va1e?=
 =?us-ascii?Q?CN35ID/RGD1mpVoMQOtcCrEIC9pH/yqWqifuqoUIMUlCcrIWS15J/CoyzC+g?=
 =?us-ascii?Q?GyN7yslHe10HVUCLnVv1FNHECq/R1Rf1QMlQnAnw0LjFDoYPISftZOdwPL6m?=
 =?us-ascii?Q?6C5miWuKB2Yak26xMzz0TX4J+4sfnue/3FCz3oakNTddms5U9gYNNZbx+eBi?=
 =?us-ascii?Q?J2nG1jUa6NZIdPyv9+8AW8i9yRSRfCaQXxJcsvOID9IBp6LoidZMOsc2Izsv?=
 =?us-ascii?Q?cIyyl21DTAGrtTRNP7nJhF+SWigCz2wMHPpohThxHFerKis0XjlawFOmeKxg?=
 =?us-ascii?Q?Qh2VZnVduLE4fdEce3Df6aMYpEtaQn+Y0tRfzrEPQxYDaMxgK7oc07NE51l/?=
 =?us-ascii?Q?xRbdBpLGZyzFgE0x2zSLryyBeuNKYHwn0V280tssQjlDj7g+p7C+KfkxPkfz?=
 =?us-ascii?Q?ZaQUsKwe6zq+EbhhyAWhZ8LtZb4essg3NK4a3rxrpcnyHoi+E9MYNnztchLe?=
 =?us-ascii?Q?JUgo9jwUzmj0WmtNw1y0wtCKKm3dPMLT82OVslergAehdb9NdHjeqZdiac8x?=
 =?us-ascii?Q?28fnVZE/oUM/pPacWUIojbmRcnj/ir5IYOHb7OE38MUMQi9L92gakFkkF6EV?=
 =?us-ascii?Q?gPU+LdcI+kSpwOv5RjW/co1TnMZWalubzVSV1mYRTQlYhfCWO+FCUgEqoz7a?=
 =?us-ascii?Q?YIK0FWtezMpCzzHOnxEkoCb6EsZ9q94LBcMeJ1dlivaVAznG42OlkE+4OZ2d?=
 =?us-ascii?Q?ksGARZf5nbiXT4KIrReN59Ltv+B9zINSWbBVNMuTfd8mjDwQYxxU22j4whlM?=
 =?us-ascii?Q?sy1QCMxLFqC+2r7Na7kZRy3UhAk0lsquTUHRdVO/YlbB0ykfLoYi7+33ots6?=
 =?us-ascii?Q?Vq4sO1yf4qlP5YZL9nuE1IQcTZ+SUT5Q9ggKACyYgjX1UGqFM3IIptV2Z7Gc?=
 =?us-ascii?Q?hXTKAedtnOZwy2LHQJEyImRTxQQqcURjnUNHzuUrpM2+u42h7Qr+GV8tkBBg?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tYqHICBkNYauGn/p+MpENZNt3Q3MNrqDe93O6glUF5xctkQakOTNl00Pnk4V/aV05JqLyI69WbwqXl9ATuXLZN5fdSfyk0chbSfZahI6V69Fm2CTxwf/zc2YqjFPzu5S3CU7pPhvcA9zD/rx7m8RZ52WnUPYjArPcJSHwWw1ZRv8mBGiHxtDsEpFt9rnW7pXbO6zMOZH9C7gBGBYRRv2wycM1v2Aa25jwprn7pacTADGj88p/W/0rdg7QVz3K6A5f4jlt+UDDgNOI4HPGCIrMdwjwKtCo++xJ5g3nejMu5M614G9zfIeaQbrY0CZ6W1ZmaCGZgOjQn9u/TntScw/eRaGTvC1DIFuuO9dT2IdnBCWE+bWNUTdgCWr5+61exOEVr6PaxXf2b+3LxOl49SqfJ2mt8ym9x5pNq4HUzRydJWKPU+P9X576IbuNmqG6D9v1KRT7cjh+uslPnV+qURbzw8ysBJTIC+gTuRy+mxVX9fKLEwmdARHX0hUvBbnJpKv0J+kloHcd74b6M8i28e/PXyiuPdo/cS0bjaFHuYcATlRCakY/koT3F0f7Ekt9BI7FguvDBSGVxFwFHcCsQyAMZcNduKkR1jOJErmJXpN8+vXUIjN+0w1bsSpjKyLRJ24PlehmqeN7T7QmVfKrVscUhhbhZywZuRd0iMWnaZlVDgNG8Zdy5ZTT24b5X10/ztGZgm4AZvc8aWWZEROx5z6yAyP/dxqEof/mU+79eZRY8dXZHSQCwWx4Xw8C8y1JC5QoEUAfA6l51xpe2bBKQ0rc32LBR6l/33zG76uz6DZ4JoZs+WxrLHoTVXa578MDX3+rD4j2ix5a8bYHFak6lIl5g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a7d53c-9ee5-4c39-ec33-08db91fb1359
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 19:19:35.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKrZDKy7ESgVQmFgXQCMg4krfPnE3EjG+aSbfmqDDz4nPdETBmjj4tiR7ahTN0e/F/8AtO+2/0ZyphT2s2k+jfKvP+sJUOoIc1N9Q0C+5iM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_12,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=768 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310174
X-Proofpoint-GUID: YwHJIBnUgV6VmoUy-NMlUz7BoXbI5ZMt
X-Proofpoint-ORIG-GUID: YwHJIBnUgV6VmoUy-NMlUz7BoXbI5ZMt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch includes the following changes, none of which should change the
> functionality of the UFS host controller driver:
> - Improve the kernel-doc headers further.
> - Fix multiple W=2 compiler warnings.
> - Simplify ufshcd_abort_all().
> - Simplify the code for creating and parsing UFS Transport Protocol (UTP)
>   headers.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
