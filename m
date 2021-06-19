Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C205C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F94C611CC
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhFSCrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:47:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53404 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:47:05 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2h6pE016884;
        Sat, 19 Jun 2021 02:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aAujcdAye7MmffEc9U/+gSQP6ufh0izPZpYco1sZ9qo=;
 b=Ou96DS/WN7kuUH2qixIhAMKGma7hQ72ZSKENOTDa9hyao8cSK18MeVyswdjEZzmn2N/q
 U/EhWjCmg/kbKfSyJfV2X/PAxw3+QEDi3osKV20KVFxJFg3Ch8pBFjYmKwuP+ekQMP9z
 YfzENdOyHvThKMjV78C0Xgm5c0rYzn/QYGuH8kEEBfrj50ov+07YjqhjyK7oV06WJudu
 oN2bsD2g6Qk+vn1VFieJbTZ0WUY6bc4jmsHI0v8GPtZpRAdW0aWDMWQWAU2eMa9rfH/s
 LM0OGdlZW9AZySpM2pBxEQlUKxQYW/n/GcrXOrJX1uvS6h9pwXvy8/D1wdIaxpZBfwkL nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997600114-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:44:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2fY1l022068;
        Sat, 19 Jun 2021 02:44:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3996ma1t06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=To2VM332sw7Gdcvc7c+ZFdptG+YoPLDxlNjUzZX4Ak51TGoW+z+EXD0eugsohqkP6P94D1TYUFA++VGwOFgPWdn62W5Cw5IpQM/dJ8r1r3xYAsqwR6oNoRiMHlyleSUgJBmDqehgoJtnICWyUNauD9CF34RHIm5jwV+LXE3gEV98Tsw28+uOH58Dm6sByNm3b3kScCbWxISqM3JR9gudkq68h34kjmr9jyZdsUE8T29fftQyLx3ruhB5svLohz/7qldO20gKJpkmDB+p44rJelszG7CGA7bGSaweGoj2AbxPb+/HQr8+vIMuFilmeeXSgYPIegQtHpdYhcWDRW15NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAujcdAye7MmffEc9U/+gSQP6ufh0izPZpYco1sZ9qo=;
 b=Y+fJRZKJOwPGPOZE3meY5lsE8nqeYNoWzd3fkH8n5cwwxs+xBMHS9odCPE4yvbrjtK3/Cyi1b9IcMGPovStvz5f8EbXKpta2BiRcidbZV2prMHoHjdls1Mk27uD6GVagkH4jg01x6y+/LHgWgqRxoPPoyHVIqX8dDpM/9SCrGMx0IWHUr5XeOg+uozmGAPmrWTVcqXM4byZPTjTBnqEuM647TsfpkhL9SpKxFeBhfwCEqnPm3DfkJfZQfI+qtWjZPrp8rLnBhU2K3Coel2UhfuzIOwUSjKIbm3ub4Eka5zlE229omBW1XAw6pFQbpa3WdKuT4b/IASMWKzONV9Rm7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAujcdAye7MmffEc9U/+gSQP6ufh0izPZpYco1sZ9qo=;
 b=eD+5tOQvcgWxfAZryeUWMusETd2TqhS2EEd70vS962AvUk5bRDpRF6IPjrQUQOsUM+DEn+nTeJbEKXZyOVh4R3CJuLbsrnfkP73ZCO/vAFKhzccJRFsDU9h2OtTeMHTCcjMkuGAqjXIqZxiTfo4YnkVzTdHSPICE7da82i8A26U=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 02:44:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:44:48 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: fix IRQ restore in
 efc_domain_dispatch_frame()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg1ewp2g.fsf@ca-mkp.ca.oracle.com>
References: <YMyjH16k4M1yEmmU@mwanda>
Date:   Fri, 18 Jun 2021 22:44:45 -0400
In-Reply-To: <YMyjH16k4M1yEmmU@mwanda> (Dan Carpenter's message of "Fri, 18
        Jun 2021 16:43:59 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0401CA0018.namprd04.prod.outlook.com
 (2603:10b6:803:21::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0401CA0018.namprd04.prod.outlook.com (2603:10b6:803:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 02:44:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e78f7b94-8dc3-4529-6ddd-08d932cc347a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB453686EAA011DB802048ECEF8E0C9@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AtBQybBy/8SLYsWukxCOUXQu/dqN/2eU73vSJyQZUr8EVPwNh0j6y/Z0FZJbliKQCIPKVM03TyLtp3wZnLOVLHJzjY2FDosYEv2qkbDAnWDAcg+FTbI1IBKPHAsxx2K/BNcdYt+oMX3cvUNu9csYVKWr5kS8aHJhRE8V3C000KTVrwUDWkAS0Yan6pmIDfndQyGSY5a88d+oPsCpXgcygc1Gj6m1BaSv3KzRo9sgtDpSqPIJ7Kn/TY4inVmOFALPztCTLR6RyejE4KKNB40tzzSlomEiLNL0Va0yle/9iaS8WSmjoBB9C7zkXajM/eDcwmq2Lwuzuuu6+qrQYYQFTYP7riHEq3pr9vX8cH2m0IR76ADuv0qCGonSBY2FAn9+APbbogeWHchYh+uK24KuZznHaHhwhrzO2xNEH26Kq51qdSy9EnpwL3fR85Nf4ZNx9dlYe/B6sdWHW3n8o8d4gowKxkszF1fM7CFe1GHbcmgQ1iuNGIcNIp858gjd1gphCrz5tx4LOMBwbwOstRpGLlbj6eQhzymi5NgDAyihq7AbfAe6r2lGGSV/KODb2TN6HpeOKPfrpi6lQGjGdTb/StQ+XA5W9eL/Y2sfmwlWqE/m1M8YOmGoyjBbc4kMdKSe4cfSTlijGMTrJv+CVIMeMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(6862004)(478600001)(36916002)(8676002)(26005)(38350700002)(956004)(83380400001)(4326008)(558084003)(38100700002)(7696005)(54906003)(316002)(52116002)(55016002)(5660300002)(2906002)(86362001)(8936002)(16526019)(186003)(66476007)(6636002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HNTrEtJe2T7tGrmvvJ4tdh3NzLbwhcaw54cD35jo2sV7bX5QfE7Qq/HSUYyX?=
 =?us-ascii?Q?DT7l4LPhLow1FnP1AgMggxdtbTS6Tx5Ft4+PGbRGkiRgJaBwwP289/EFOffR?=
 =?us-ascii?Q?64L+By+0gV7E2Bxc0V2blgvwWn+NzQ3AHfENxmhc0pz/D9LpDTuw0rAx2+Mk?=
 =?us-ascii?Q?3F+0hnZILdSNzs3CoHMtg9kWYoErajLKrGpamPs12f3qO88ixlZgZCwLqHL6?=
 =?us-ascii?Q?lE9IENMPdva4Jgt/s7LNGBaFVBpyV+QGOPVV3cMgx9HahhPhjvDeeyLVbd7T?=
 =?us-ascii?Q?3iYuaAViWRKmtd/waGsuRUTGga/TnIPBYIUDE5CE677veGhQKj7cxTHFlwPU?=
 =?us-ascii?Q?O2PPwZAu1RV/wPmqRcHuMgjObnbUr5v/CaWy3cef3M5jBx+ECwFkGz+D33tE?=
 =?us-ascii?Q?SLRqGlsv5jqsKUfwjhuYG5wNeCNVGJMCztTLHqSFxYFlR3XE0cBHF87TO9Vp?=
 =?us-ascii?Q?gYAkza01acx38HvtTWqqXw4bMBTpFvYvqBAs2bdygP4dG69+qKJod0LrXfEa?=
 =?us-ascii?Q?lj8/h09qMrcf1BszUvZdiD1QNLI/DgynC01s5OoUFn8SeEcuPLCGlYfyuLge?=
 =?us-ascii?Q?KLyX8TQrL4hDdj6mlzMIxGloZovNJ3VG7CuK1HCX7ltjOE+bVoz9pTLQWGXf?=
 =?us-ascii?Q?vf8+442iGopT054rldmTUguXLxhMKrXyCL8d4K5j9vr6XLst8yjharhkrRxJ?=
 =?us-ascii?Q?Uclxz1W0Lqp/mQOUqHf9MckOFV2BGsNIzFI4u3dOFui+hfP2Z3mQcFEfSvFk?=
 =?us-ascii?Q?Wq6Fz8fdhmp4l9RpRR9Hoj51WyK/1qDhh/bY4MGMH6V16ZYmxuYEh+oXxP1g?=
 =?us-ascii?Q?gDM4kujowCIh+uGzCnpRPfmzI6FPQLY6aqWm3aojfpF4qGkDW6NSSig8NZdw?=
 =?us-ascii?Q?pkVqp1JdZ9S2ZIL34eVz28wCuSL4+hxzPnvTJ24WVSVBDUhJspRcR2nqUVlH?=
 =?us-ascii?Q?sEYh3y77fY9l23ajvJHZcxCvWeYHT5Y7+jg/TBfqkZkkv9YLXAxgt9Tl8wg2?=
 =?us-ascii?Q?I9gJVWA1iGC66l9w95Kumaz/FKPBEZMQhFSOQFzNEjYx7ntRYs9jW0iYmrqe?=
 =?us-ascii?Q?wUD6aUTLzYRtfDYi1xh1FsGBcwfy6ImwqWyQ0RoMDtfDDq90qxpWbIkkIU1D?=
 =?us-ascii?Q?fmZXg4XMNNUk6YbEQlXIzwbpj1XCY3fX2GXhvJt4DY+D5xq3OtDpY2b5babM?=
 =?us-ascii?Q?AMzT4O8vcmA9bNFxY/2T3uwIxzPHvy5NW3AM01TFeAAgTWk3A4yY6xkwcZKv?=
 =?us-ascii?Q?+EKrLF8R9nOpesgTE9AsuDaT/6vglvkSsh3gQ3yY4v+S1LeFc0WCPNPSU3b+?=
 =?us-ascii?Q?lgqVigjmzKxpXI+bT6DyRv+0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e78f7b94-8dc3-4529-6ddd-08d932cc347a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:44:48.5717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKjwXC/LjvJ6335eW4ztdcOyKGC04zQQn6QtNCu3NEE51Exhs7mXVEg5bay/0ZeWicbSc8nCVOqq2l3QJDLsci+NmjCw18JJmktcNYnd7UA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190012
X-Proofpoint-ORIG-GUID: K0wdq80hxx-c6yIalfO2-htnO-i8uSxn
X-Proofpoint-GUID: K0wdq80hxx-c6yIalfO2-htnO-i8uSxn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> Calling a nested spin_lock_irqsave() will overwrite the original
> "flags" so that they can not be enabled again at the end.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
