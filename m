Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A461C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0624E61222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhFSCto (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:49:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61284 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234923AbhFSCtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:49:43 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2i4Xt027478;
        Sat, 19 Jun 2021 02:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aw2ti/5Wysz7HZ8z1YgQfMrNY6pf8vEDNs+UqQlZHbY=;
 b=u5uPNOK59VLO3ig4/RtfGCfFw+8BqQk78UxbAzDorYGnQL0/e9qyZ9wN2MFBUsXD3a0S
 5eQ9522R101KBzemYaHhuikC8lPvIt5HUX2UpakxKBdRb5zAlEGSDX/XCWPJ2XfAXBg4
 bd9hWwjD0PYAj/7P0WH+Go9ctR/EuclvU6TuYbW7WYjbrVSC3lFPLko4fXtu+5Pem9lx
 tJp+2kt0Ui8fF3h7UY3VePADdLWuwsv6Zg0V0du9PCWQw4wtxhnVdFgjYDTS3TDoZeqR
 mS5/fYOJzAYyQBeDyf6bDJencOWgEkgLaEcQeUk41PJYxl+PgnFb9mkXdosyR/p0/Pk3 sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg1a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:47:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2fE8i009862;
        Sat, 19 Jun 2021 02:47:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 396wb0390f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:47:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgj2Rgi19+aTKDmEA7p2xtSaWyLnELpvalAOEdQLnayVzvfqlHWINT1sYXFQMOhyAAkBt8ZR7v6UlgfxdZXesc15UlR/9UCI9lE8FgyHmXW9CCH5UvJ22Iky+bZK8x7L7qCfot5QuqrXVgkNRNRTOOUrWdJfgN0z+skCPUjDkurz7pMpjiyzKYKhhIRZheEgWtlzLoQTFdNLI24cuBaZPI+BNZ3GbHG8EejQgTjnchfjxaxYKTBu14VUcsNhKUeHX4ATVfxJhsGRB4yy3kSuFt7Vs+/icpplB4/pOdPlec5SVZlEhfggQeNgYXj100P3Ykqgincat2oxiNSPOlhiEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw2ti/5Wysz7HZ8z1YgQfMrNY6pf8vEDNs+UqQlZHbY=;
 b=O01eW19+gPQd2QEXN3/7whBx/l7m+upYkx5gLzCFRP+zqxMlYsErKv7Pwonan0tthvq0lPFvE+mJM5CXEnTvg091PJ/+KSZ8aRwgcCMAU/elG7JdgDOxmUi2DK3p8ZmNAjX7i0Ara23hLqtlaP2xr/Y2bN0zPKg7GlrJC1AM9cyzYe4OTiYL8CqgZ9ILJRxJICUUNdOVRn3Lgc2bz2/spfPSom8r1+iyGHzn2PnukJUE+dSSK9It4slplHwXJxHQxA8fPR80CxYBIRXldlMBDHW6Ywf9l+NSXVqLtzg6tG8FGMjGpyktUERTMpIB4hasayx/QNlFy16RnCb/XjlhHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw2ti/5Wysz7HZ8z1YgQfMrNY6pf8vEDNs+UqQlZHbY=;
 b=Ks9NvoLJM/fRxoM7/xYoqdGwcqyS4BzGmRT8kN//M7TURG8D3OoaHT16shaMihUxq7N1VJolKFh3FrF1LGV35OvvbJTUEJrFZEiQkmlVmB9odxpvgvUfa7XEixt36JzQn2ZeV0ElVUpIAqK1WPNZILq1I/okRG9xxe7QUvBp+1I=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (20.182.127.76) by
 PH0PR10MB4663.namprd10.prod.outlook.com (20.182.125.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.19; Sat, 19 Jun 2021 02:47:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:47:28 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] mpt3sas: Fix Coverity reported issue.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtrmwoy1.fsf@ca-mkp.ca.oracle.com>
References: <20210618155506.2609112-1-suganath-prabu.subramani@broadcom.com>
Date:   Fri, 18 Jun 2021 22:47:24 -0400
In-Reply-To: <20210618155506.2609112-1-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Fri, 18 Jun 2021 21:25:06 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:802:21::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0079.namprd12.prod.outlook.com (2603:10b6:802:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Sat, 19 Jun 2021 02:47:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b48757e-abf3-4116-2de9-08d932cc9393
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663E6458FA9893942FE5C938E0C9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YecB9LTSLrIeh/EKBzKZ8SR1g/CslZxsHq97i0USkyYxcYCTCuHvQiaCERoZVYip7/vdpmwHrtn8OOAfNXhhCL314ionbnlzLbMSFhLZY+dRWD9DNPWdMtQKz619HZZ0rH5kdlK5uWyZ9b2cdIuRLdGLTvMBC/1OJqZsbCT8K1cxqnLWROZmhjPoUbSkPHGzewypxgPxS6nWt7+MvcT/HZjUrCMoTVRYXGYQ7Sq/Q0+PE3jPb0nkqqua1TBBhDLuq3RlsfLuzPRhTQuVjomSFBStuijwmfmP2sGjHJzrbUTFVVfssOZZ8ZU/NH/OH3NfxKvPkVY7L76f29R+i0y2Ts2DhAE2QCGUWbLF33H/ZQ7r3NqtOl9X7VllEx9r8M+jABDmsmYD4HYbs10+rzj0Cl+pRZmsKJPg8V1Ar2wD3Q4NM6Tu9JvunKJQwhqrhxH1Y+BQkPcCE65Kq4hYZMg07X6SLvtPQ+JSxb1quiZ0hGaGFdVF03RDIBkLRCBOpWtPBhpDUj4pMqH0vKEl34//b/vYgCemYVLfM0USwV9coe93PgIrLtZBABqBIzHLrU09GfHmW5Rw+u9pw9/fRZx/g2d0MOfY5HfIVh0f9HQQmiaM6AOj2/jbE1zbwXs0dRbJbl2INHzPJFVNqNzQ8t31l8JCByNgNZ4JbmJ1U0JUJjOkWxoMwALvK9akoaHUncC8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(36916002)(26005)(66946007)(38350700002)(8676002)(558084003)(4326008)(38100700002)(478600001)(7696005)(6916009)(6666004)(55016002)(5660300002)(86362001)(2906002)(8936002)(52116002)(186003)(316002)(66476007)(16526019)(66556008)(956004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A2SEJjjITBVyE5ckvyMGxMCKUyqYjWqjQKUT52K6lLxyhXTfubUTBL8q0FVI?=
 =?us-ascii?Q?lHygUnPXdKp75nbioeAnh1PHRxbiUc1S/1CgMn/mMx2ozr3J3gMGCyzOqXKz?=
 =?us-ascii?Q?shAi9VJSVBG2dnPGNNDs95ou2jSlSjjqIPHOuOWMjiEaIplGlGI3XzkQRAuB?=
 =?us-ascii?Q?El2RucrEPer5YwkjIEzi8CPjE+0zBlDZwfiTXeDw67gbSsXJADF9f0Mb7Y+y?=
 =?us-ascii?Q?zuNUhSQ9JY5PSqqcQMCJ5z6qZa8AEiMLTBeoYASpl4JP2OKryZSxJXVnO9BI?=
 =?us-ascii?Q?hGFHazpMYBnjT1RrRa1pOb1aJjfEQO8WQ5dyulvI+EvILH+Ee+5CI6lpNaBU?=
 =?us-ascii?Q?kO/2ZDpDGDUt3rmEn5nExK7XfhRR27kn1nau7p3mQUegXPtr+Py5yWg+/Ib2?=
 =?us-ascii?Q?qkm/YnMDH6CMS3Yui0MTyXS1Ev6CbKvkrkgfctPOUKQD6p1XWShj5CfFIkkm?=
 =?us-ascii?Q?IEhPkWQP3EQp6ngeZbmoXXhMDQ+stfSmWjS2ktSwKCTIxMyk7c1DqGT3F+zT?=
 =?us-ascii?Q?hGHVtKfLOKAIfGISoZfIaoB1BMhCFt6z1TTmM9ub6RFRZOT1jFVQ+tbusfXN?=
 =?us-ascii?Q?EEd2pNil/35DOzIuCp8oeEByMZ6xtXnqnhyg1CoxC0hXQYWrNjyfoG3f9Glv?=
 =?us-ascii?Q?ZVNIqgdJNina2gD1zWLxN3+zpopxDr901ls5URD8hRWO2p3FO73NIMOBsOXm?=
 =?us-ascii?Q?w2nqMCCsYE3C1g82lNzafKiAPtWNEyrDiPJlTtqb2IjAs6+HXXk/QZUzumd/?=
 =?us-ascii?Q?VY3SgYCP3YiwtuwykgXv1tmVmmdn8I7n4Fv4dJhNqKeg2IV6mOzZNW1B8LMJ?=
 =?us-ascii?Q?AGJbuSTNAr0nTgv3pKV54q5Vr0Xy39fbhFNNjqOtAgl7JhtH/43P0nUOlkOc?=
 =?us-ascii?Q?COsHi8eZjW47FLU/d1D3FgAL8Snx5jVsxPfCPRWuVi38RkXBHfqobZhO/nS5?=
 =?us-ascii?Q?lvOt9XNXJLvD+PNGKwQM0TkhctXY1/paKSuru+FmBneeAgb/1xXAJ8vdZK+t?=
 =?us-ascii?Q?DiWayaYVTFqSZM9y0hm/v4NlwiAk3r28m349klrYKnBeMIXHBc+eZJNdbBM7?=
 =?us-ascii?Q?Xap2MXORwYgT2B87TodYh7j07YgmGAgrOyxp7r5p3i8bQdRcBNvWWy71cr6L?=
 =?us-ascii?Q?8DVVV1xzXlecA0oe89w0LVZsOrA6yNv8XNEp/3Mqfb+XfN06onOm2rm9fj0f?=
 =?us-ascii?Q?DM9mVPkypmEGXkaRmTHzqXV/tvm5rS0hrWxoX3oW6v3wkNSNYB4Nc3IZn+py?=
 =?us-ascii?Q?ll2rjWvANTReh2Bogtbwf9RkvDhJF9psI4eQgcynrkQMwl9S86E5y/xtAx78?=
 =?us-ascii?Q?P0QYXDjrcZLU9GDvNBBeEA0X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b48757e-abf3-4116-2de9-08d932cc9393
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:47:28.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpgMpk6DEVwOpTJrbdtXs/GB2J4gZhInpuff5MH1cBavnCr4KCzXPJjH1dEObLfZOBB5bvuFoWvQiRdiXeCioAjiep6F7jJg2htYQj+vwao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190012
X-Proofpoint-GUID: lDOYJ39Pyc1Q8dw3Tv86h0SM0hZ44GIl
X-Proofpoint-ORIG-GUID: lDOYJ39Pyc1Q8dw3Tv86h0SM0hZ44GIl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> Fix the Structurally dead code (UNREACHABLE) type of error reported by
> coverity.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
