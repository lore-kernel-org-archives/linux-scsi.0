Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BA5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 01:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiEQBz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 21:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiEQBzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 21:55:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9698D6593
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 18:55:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GLGvfu024484;
        Tue, 17 May 2022 01:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kAew52kTYisjHMJslAwVKRVrEvO1qA/s7GqxTHONqG4=;
 b=OlPcoQ2AxkrfKs66fhw0JB9lXUsWbP8EGW7Ur3JaxQoGqYmMIJjvjmwoJWvz42oeOJTY
 Si0Z8DlmjJCSL8VyI46V95XmXTvxUmEYm74wzTd1hXbAV/c5Ytim7EHR7cHvB0Boz4vu
 GlnBC/g3kRkksRudNx5a5tiRhRZ/zfhyWh15jARoQlHAswJaqnh4xWClh4umJ9EOwDFJ
 Xokd9lwLuRHX4XwBdkE2rp/7vifba9+vN1tK8CH+psm5urlITBdCQWjrldPtUYwQoYZO
 lVs3Ud0cK3+HrzKscO9V/ATqm2kU3WObOwaJHcutOn6A5RI5YLj6F7bjDPryt8EgVh3G 6Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc4su3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:55:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H1tn8X015896;
        Tue, 17 May 2022 01:55:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v2hwpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:55:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaCT2I5FBXH2kjW2it2J+A1vJT1Lf5OMaPvJNgjuvkC/is2Rf9h338tICRuD0rEbF0qMR6Fhk6r/mfjyAEJOqfvdb0ROz8DJHNYS9SOgQV84XBHVG2zkyRx1qzrJrD572Y9gzyuII76Wj+adQddGES+a+gB7NZy70IaBWZwqg/qv/7XmMo43GedCMa8/KdukSP+IrY9zeqnwVi3Ktu9GWhT1PqkhcmipSBA7j/QcDUXs/upcgtIngi0oU/2RUIyfJD8nQGS26Ax4BQ0iIcU9w4e9uEWUPw92d5ilIaXsgz8JEVFWS/KgnIBEdExDP3LPgWFSOMQWb8s5cdTgxIoyUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAew52kTYisjHMJslAwVKRVrEvO1qA/s7GqxTHONqG4=;
 b=Vci+yb2ca7Rr4mqU87ptZ13PBDYChCmJ6KXIh+NfnFp+Cvj9+0KgrAYBclQ/+t3P6zKgrWHeavu/7H7RGxD++ZGKT+gkH+SWLg/r9SuJ5BkQ00GvHzLWxKt4vPTRjfWSV2LUFJgT3Yc0T8YpMqzqekiVYiz89+EAGicGKG+p8sQO5xtC3YJH7B5nmiXPGh0+qi4PIPygPGwdemffjX6VsLCuAia6WDRx58LjHgZy/u2zaNHPNDFKpwj9Eg8ihFI+bCXe3caYTzlf+lG+pA7O5nwq70RWvm+mkSwWsBOxjD3FmMNEWr+R34pkvjB+vEfRnUAAlYsMgv0MOJ84F2orSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAew52kTYisjHMJslAwVKRVrEvO1qA/s7GqxTHONqG4=;
 b=DqkK2vnn+Et/eOADiZ6kUa2KN7R0z2w6tdjFLjBERzCpjBV07/DXYawhBedYg6HNoU4j1tUhRAKNrdBKwkFSB0ywoggDCnrFqAOY0NTDhZIeuG9WPAVDjCCU6e7O8ALD2hkQm4tiUVU6/dL6fM2ZmCzzzHsiPhZKJqP4zLgyqvc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2837.namprd10.prod.outlook.com (2603:10b6:a03:81::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 01:55:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:55:45 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 1/2] mpi3mr: Add shost related sysfs attributes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0akrkj2.fsf@ca-mkp.ca.oracle.com>
References: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
        <20220512140046.19046-2-sreekanth.reddy@broadcom.com>
Date:   Mon, 16 May 2022 21:55:43 -0400
In-Reply-To: <20220512140046.19046-2-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 12 May 2022 19:30:45 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:8:2a::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c58306c-b5c1-4f99-43c3-08da37a85b21
X-MS-TrafficTypeDiagnostic: BYAPR10MB2837:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2837A9B79A7C7575C6E3A0028ECE9@BYAPR10MB2837.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nt8fc4le3/XslBMFj2EP4QVBGV5bCfqHGdNP5GIc/Y7gpmwf6/4pO/TyERhyLq1GrKhTuduBhb+mr9e18vue0bTPPiOzOUSaC4jx1V0fSh5gQMsT4Dy6JVJMLmTOEMw0DS69toliPeOrbUVWFEW3h+aAST1Qpl1rRcY71upf/nuIHGIr9qkGs2SnnDk52gqV4QaLDAqI1p63l3lMGRcv8XsMIHpclhXtn2nYSlwxotdDUGBXdiEzn6LPxPLOfuAmUO0AABl4n/QzGFbfxYW4yTIrMkYdKvmXFrYVuTbEhBB1aOJZWYmAZlIO0oO2XoIP2vKR8zBRBkXVpevY/yISOIVAPMq5yIXw9fKBCISYQA179frLDnmjU3Li0rjb0wmWpvM7tzoJh+7ixbv+ONLWI6VAXXvOEDvpm7RS++joMG05xwg3EMEgXdp+CY06ayzHCr8Q9DpoU2mPdIkv46tkGiFRve3z6C+KAyWp/qukOgk/0acIg/W/IXvZfD9Z8nlfQaVbe7CXHKNvQ/mPIvMBftKB17YeJoJlUv4fB5QqgSQtIV/HaXESvsCfqzp8kIMGkVYiQmNQbnzbJK4vbJ2u87pG4CpAYPfKm/26I0LIzw8yedZUgjwyCPTGkvUwvXiTbLJ7XUJccZW/mKydH1FmDbPehARtwrf/ESmbANSrXVJhZlcT46R8MAR2xLLlpHXsYEbsMmxUVthbLStdrrRDzq2vmhnl0AnqU3045A8lZI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(107886003)(316002)(6506007)(36916002)(2906002)(6486002)(508600001)(8936002)(66556008)(8676002)(66476007)(66946007)(86362001)(26005)(4326008)(186003)(6916009)(4744005)(38100700002)(38350700002)(5660300002)(52116002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPHzxwF0c6ZrR7UiTARPH4sMvEmQsdfOqI8g8zljYhKm1L2nPNdRkAiy5oXI?=
 =?us-ascii?Q?Yj2xB5wA/Mq0fwf+FCif+bt9jtum6uZrSrn6/aCw39M1zU9xxf5HVousOXHy?=
 =?us-ascii?Q?et59emB6tCKyt/+w1kaerq/3gnTah5S3ZtzdfLSh8VeBmLEDlMXRA/24iVw2?=
 =?us-ascii?Q?IT/4aBAWTntKdCSk04KpqXj2xa/ARbDs8W6u1Yf5fKQyo8cjik7URvcpsRoR?=
 =?us-ascii?Q?D8q4SdBG4DvUveKtgvgBmVOArErvR1952wOO0AGB8B7BG8QYchbI+0V8KpwH?=
 =?us-ascii?Q?9064LA+XeA+wj/nE/P/rTzBMR3/dRZthrV1+oD5BbUpQ9AbSJt9YH5g2hEgw?=
 =?us-ascii?Q?zczlb7q1BGbWLBfFbjhF1P3+D9beELv1YGNx8REPd5TRS/mHGqQenXvmUCbb?=
 =?us-ascii?Q?uhp0er3Mk5bv2EVqLQgFKNXXM901UDVImS10RNi2MXYLD9XNDU+h4MsZ0Smp?=
 =?us-ascii?Q?d6DrE8m+ysUtf0oj5uq5C6WOabTXMmW0uHKfTwUOE5yg4fB4JyCbz96x4RRU?=
 =?us-ascii?Q?jRj6oRrqjuYhXYo3IMhRH7u75ziZdp/3GAExl2/Apr1bdaQv+LvbqXhSPua6?=
 =?us-ascii?Q?8f72eFxajdtr3m5MLsEwJX2jQ36rzP4qT5E5ZGGimeALmSGmXerKEk8lspOZ?=
 =?us-ascii?Q?JjK03pHj5wPOmdzuRZAJKJfC+lR/DSvv0GKGHXg8BhaJEp5LK5+EJWHtAaHh?=
 =?us-ascii?Q?wg5WjyJ/AVzNWcgv/Ui7LelMU7m1vzN2RJRMdqmaSXnhFaOBi/HTNZ7mqDD5?=
 =?us-ascii?Q?srG58iWT6fy9jvLBQc3ggAz8KS9xuM4ngp4TwJSZ7RcEDVWOVOSkn6mxGQhB?=
 =?us-ascii?Q?ND8BA1Dh7D/OkMRNuM5MS4s5Q3Up9P74uqq27CMaw8Lq7YMmLjZ7nx7gQQxk?=
 =?us-ascii?Q?ItEhF0kluPfTp35fBrvBbKxYboRcvqwKultFZb12ye+X7aVLWHUJPVHuSiNZ?=
 =?us-ascii?Q?+K5VZMY2EHl0avy7KuVVGxeGlFHwv+eCbMhr0rexLwIXYXkldW736GIdxpve?=
 =?us-ascii?Q?4i3cL0h9j2gvxLiZoFHl2hVwmoOnib/6XofGgY8W1mZfNyiAz+0z3PlQEzXK?=
 =?us-ascii?Q?gPca75JzDzoYmU4kjV+10L0Lf5eHkMM5UDw0Ix+bUm47UijajjoehnnXOCaw?=
 =?us-ascii?Q?HpLFbG1XFslr5MWsUrEeCJvshj4lqrYTTFFsZlajHfrqZv86TwDEQWGISJHG?=
 =?us-ascii?Q?22ZVGJwwmZsH2GdX1xmJN5zl2hGCx+7i2WbjlO3MaVGrAOta44ORjVc0UdiD?=
 =?us-ascii?Q?+oGeqq7aHgxblJ/PHXDybHXXZzgU/gdnDVxuZXTmqQfDtMv5TWuDZ+6cQTw/?=
 =?us-ascii?Q?LoNOOmeTwvS29qsAg1PxynJg3poVQPhqPjEQdJi9x7+FicQRHEQ9TM3qKwS1?=
 =?us-ascii?Q?42A5lezDjC6U+JsBoMOJhwfVNlbhnFZMBm1MVBSQde+i6HJ3Kn6NT4aB9zB+?=
 =?us-ascii?Q?95akO6rwx/t6QzXA2dCwTPiWn8GJVW9EeXw6N/EwDIMc1B4ViC+I/cWEX5Bu?=
 =?us-ascii?Q?scY+cItbVB52kFD7wCdn98adOYDmc67rc4VGSv+FEkqgZaSxCX0lTeqFo/+9?=
 =?us-ascii?Q?IRDVfdW/O4komhGdcRL8bFsId0sBxIjZzZ6A+JzG5q3dgGFH18t1eKSUP+z5?=
 =?us-ascii?Q?odqOL7cOnrnxLO+nKH4Ln0bkvpO+NKHJS7p+rETXE0Nc7CmHhrykfjWPxMtN?=
 =?us-ascii?Q?NfsXEYnvTkrKEuk0csajwF/pNPDPEIIK3JpY26VcpJ2VNo0WgbDQ1d5D1J8t?=
 =?us-ascii?Q?iMz/vXmr8xAk8JCcO9vPG/eX5L1xV6c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c58306c-b5c1-4f99-43c3-08da37a85b21
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:55:45.1629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sguzE67mXBvhcQCxZpDvybtG7taXiVrBpsejIzemzuhlp7KRqfPQvpNfOxF81vTU8Eue3OZ3wG6qndjMyNP9V6ytA+X95ak6wIegBGTmiNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2837
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170008
X-Proofpoint-GUID: Vh10rOw9hyISmcN9_vkZFwQFdvSAvyUz
X-Proofpoint-ORIG-GUID: Vh10rOw9hyISmcN9_vkZFwQFdvSAvyUz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> +static ssize_t
> +version_fw_show(struct device *dev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
> +	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
> +
> +	return snprintf(buf, PAGE_SIZE, "%d.%d.%d.%d.%05d-%05d\n",
> +	    fwver->gen_major, fwver->gen_minor, fwver->ph_major,
> +	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
> +}

Please use sysfs_emit() for new code.

-- 
Martin K. Petersen	Oracle Linux Engineering
