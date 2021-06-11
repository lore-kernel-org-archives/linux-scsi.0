Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5889C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 02:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F21F6124C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 02:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhFKCMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 22:12:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28490 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230168AbhFKCMw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 22:12:52 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B29QlT001021;
        Fri, 11 Jun 2021 02:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bgsZJkrS7dJ/vDKcDujBYemIyxA8MjQQa8DzPUGrmT4=;
 b=wLM3FkzdnBVR8IgrAI8w2Pt7IUK+QGeWLR6Qe/ocFOcAGdBYNwow/Eo0PUr4XO+eoiDk
 kfKMv62NtvvWcpNiMrZYLEMhh8RTKrB9cF+fhXB6K4n3E1cEZTslZ6CT9qLm4SjoPDTk
 kTF9jCI+Hl5A4wPkb3fBljwD22zdJnWW+j/OzF+bplbKFWOTA6Y4Es4iYil3ruoBqqK5
 w9f0TkVriCy2x0uBn9Rk1LH7WI29jPGNWhvw0CJooSEX460y+qsv6B7Uq6huBJRMCHfw
 o77Y/7sMQGACjrzKFQVwUH8WnfXUC5EQB+7mMIARqYgksPbN0pZyFnI2kx54iQfvqrXy iQ== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 392yvb8m45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 02:10:53 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15B2AqDG110449;
        Fri, 11 Jun 2021 02:10:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 38yxcx4edu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 02:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YF1ZAt2oUpol5j3qexL/ZQ+iWhK6AtR/cEU/MT1kYc53N/bIPUFaNt9vV+uT+ijmIjO7jUFgaipQXmAJH2tgarZdJ0lA14S6R1ELFMml1FleTjgFbcFHLJimv0g1cBQj0t84SY3pWIGxcKJyV6FFS9QjwJTzlNOJuD/Ed5duohoJsdY7h+6di/gsVCCDJjpZPtM2kk8bOY+gzadVIuxBcsiLA+rqybNfcKO2tLY0GrCtrJyB++XUXdRHWK6QMlfZ+3i9GG42QKcm5djm+uidjK6/te1gu65h0Xs2upraSrnhIehHHpsVkyKI3t0nGMVX1dSPHsxOGfXkTj0gdrd/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgsZJkrS7dJ/vDKcDujBYemIyxA8MjQQa8DzPUGrmT4=;
 b=IY/AiTOzU2y7KFMu58CLsWv5kg8cJO4236Ng5YerWg+qaE/y7PniL4iBlBrBsM4dgAMkh3SJfCVVaXZLfOLm3GvcSM71CNdz/PoQ9cpZf/VG2L4iATlSQ2TuYVmxTliUjnkU8z4s4r+/U0UrRYGpbiOzEejCJOCNxSFNnTRFndEswW0fyq6nzlv7X14B3ByTK+4ur9Mip7DUEMgKjlKfMAmGV+G76q1zDt4mc9Oisuuu4BpQBdLTHmDC3+gdCHtN4D0etQ30sIxZK1Z9kkW3yeLuB07Z7WWznCdQgj2SxS3JsQ/HC888ylGM2lkpbDjEhpydoBqsS4q45u6nVYnB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgsZJkrS7dJ/vDKcDujBYemIyxA8MjQQa8DzPUGrmT4=;
 b=KBoDYmmHt75peZ7M86inXXibo14DmraGosxW1SlBiZosUL4WK7GwvGOxejULEPgcERcZyWqsic/t9CbsQzhudNBC3l3R1ZMAc1Pm4tqErtJAglDC+roaQMryuhtxmbHMstEnzEhc9ZmfBqY77O5xfaqQfmChD5VlH+fsodl8HBc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4535.namprd10.prod.outlook.com (2603:10b6:510:31::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 02:10:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Fri, 11 Jun 2021
 02:10:49 +0000
To:     David Sebek <dasebek@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external
 HDD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135tpcfv1.fsf@ca-mkp.ca.oracle.com>
References: <YLVThaYJ0cXzy57D@david-pc> <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com>
        <yq17djdq8ly.fsf@ca-mkp.ca.oracle.com> <YLejIoBJ8YJuonVZ@david-pc>
Date:   Thu, 10 Jun 2021 22:10:45 -0400
In-Reply-To: <YLejIoBJ8YJuonVZ@david-pc> (David Sebek's message of "Wed, 2 Jun
        2021 11:26:26 -0400")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:805:f2::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR04CA0083.namprd04.prod.outlook.com (2603:10b6:805:f2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 02:10:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6709cf56-0a4b-43ec-b802-08d92c7e217e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4535:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45359B11BC719F5D32A8EBA68E349@PH0PR10MB4535.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41JZ+S6twN1p7eYAaV5zkkGovXGhIYTMf8EKImoNn0JDEqfL6dqMuPJOu7hTJLkLNZcfHRk6z5GpTTnwV6OhEeVRG5UDg8klE5/Nqzk/4O7KNuoobjen02RsRjMur2W0/eZL27yJSD05CZWGR+Ia2bgyo68sA9YDwwFk6P3sNl2smYuJ6QHDn71Kc9238tMggwdgI8eI2XWJYmiJs57drEondVXkC3CJBlLKujPosKctR8BFFcH2yow8dPf6y0FAArC+fnzV4gZFSRZ4VPTJJKvq0nxuw52S/H3oBdBgiAZIBNhXFr9XLjAT8BDIzfcAMgKMKcv+tNtrkX9+rfRlB/rxvjBxdvJvy4H+NAmNJ/ty5gpO5sk0sWkR8e5o8/3oLXyp7XCopuw4k5St3MPRr0p5LtRi1O6zeG5J5P4xVSj/JgiSfm/MIxRdhquhyXcUh5nvYZlxAigrBfN9pKWHZipRutNEp4QPu6dVzpGGwHFKgK+yBs/e02wGqfPx90pqdlLnjrCe/bZB/hGhRgSL3Wv7x8vKgmD0SvO9dUW6WJAIQQ8O8pqEE05p0knmsfUeM66xSdkrKdM5Gmfg7t++PPnMDsoJN+ZVsPwPrYZwrMkOoiZ6uMa0/7gs7YAj1deKgK3eLZglkGDvPqrbXNV601+KiJLfd0lZctgFo38SzLU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(396003)(39860400002)(136003)(66476007)(66946007)(316002)(55016002)(5660300002)(956004)(66556008)(8936002)(52116002)(8676002)(16526019)(478600001)(86362001)(186003)(38100700002)(38350700002)(7696005)(6666004)(36916002)(4326008)(6916009)(4744005)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JlCrM27zMePphwRHb978kO3JUw1lbbdiiXJIru+Xqt/dI9f97TRjgFwtxygO?=
 =?us-ascii?Q?lcGFaZ7LXZxjo+ZcMgtPVfuwA37Grc58aeQmBWVMWvnqe6x3faJhePejfQk2?=
 =?us-ascii?Q?n8xtaMwqQG+OAtXhnX+FNaw8hhW80IGrE6dPibx/Znq72DZ56mvYnSy3nPVH?=
 =?us-ascii?Q?7YqokK+2ONQAopQe19jcm5MOp4U0FjrXW9S58NAZlDjvs10EwgmpRVj6yGtB?=
 =?us-ascii?Q?H2AqOzofAEtx+bPVAMaAz0atl9Ixl/Kq1/C5XySOjV23YpMnEcv1e3i0rJyr?=
 =?us-ascii?Q?v94koat7A/EAB1H+7lCKbHL5heYceOZToqgzt6DQy/2ZQ3nR3BlqbfatKRFU?=
 =?us-ascii?Q?mKhmKLpeIKdxa+aYkPOWhqBJ9/U6YBLZMZz4AW5yOOCz+VKS1y6Dt4QetAx8?=
 =?us-ascii?Q?jstk+hQgHKH5ztCAUzrgsLGEWKYYY/KNMcKX6X+oMrd4qOyrWa1B6K0qieuE?=
 =?us-ascii?Q?0ogaOp2xT+bulBm1dQgoTdH0JwHt+dEWLXgnTMR9UiwMtNrEbWd0RleI0L/8?=
 =?us-ascii?Q?ERZjVOA4AzxNwRYGP4lB4Y6MXJy1hx2fdgStMRyr+aWgg03wz5c62BzR76Qg?=
 =?us-ascii?Q?L9i1ZOkAQJ0ajJC8lgiTDLsr0H4x+/Io5W5Idth7ztOTvCEzIkVUunnuwySt?=
 =?us-ascii?Q?G6R58cMLUb6xoY8WrGIv6rGTySiEWtz3UrVBtHkjt0nCduhvUPOgIcFj7VDR?=
 =?us-ascii?Q?XBAzC2GYYGfu4k5ZwXj494aX4nmHPxcWN1mk72XxkAbee8cy3SB1H+Vqlji5?=
 =?us-ascii?Q?UQwlfJjuBa6b3ahixNSY5D+5Iy7iuPRuvXUYWzb/F5l1nGd5lgIt2ri6wGXs?=
 =?us-ascii?Q?2mBmJMtfrvgZfXx/BBvJVbFY45UaNRz6/BMdpK+XaDsI++X3QBGoFAX/f1X/?=
 =?us-ascii?Q?JGlJC3eBlMAYB0cqByhOfD/pzml8Cm5qUCXRrSfT5GkyfEY2mBOAF8uL2vF0?=
 =?us-ascii?Q?J16xH1yeByO2iBQoDBXNUP5NXAbYJL94TZ7ExgZzK7m/rZZ2iM1IN59O9pje?=
 =?us-ascii?Q?nkgg66CTT83pkL6jsL3IUVQO1HQ9kZF5ERZ6an2HEe9fTzrUqm9PzCGgTmVn?=
 =?us-ascii?Q?4IJ57BbXO/MsG8vKbnPUF61OFKaaFMTdzJkK/DPStV2CXPvdc9+CwWvv3Kw0?=
 =?us-ascii?Q?CcGl//MqeUJl0HNRolgfbUDDQfv8yuuEeYZEexnsyFlcUOQZAG/uheiV8Hfb?=
 =?us-ascii?Q?tQdHyadCSDSQiS70em1aF+DBtUYbQQfO2sRVpFdQUKd6fNkH/gXqMt/zhN3G?=
 =?us-ascii?Q?2T6KqAyDZZi5QvlxqJt8ghX69pOy8RRRTZHnxyiUtjZD6g4Eh1nKtxaP6QVp?=
 =?us-ascii?Q?FblYclPlL1iyjPpPrs/FOXht?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6709cf56-0a4b-43ec-b802-08d92c7e217e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 02:10:49.1798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mC7erhiThyQUlRTVe8Xz+f+dk2jfni0faHy9LJH6+oBgGw+NND8VCeu2FzBMjF03EtbRm1PUwTGNWdb9nl7/OoWdXMY8uaHrv2DjO2747+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4535
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110012
X-Proofpoint-ORIG-GUID: 9WSi0MG0YSKj0szqUzMsto3Qm4Vle9QP
X-Proofpoint-GUID: 9WSi0MG0YSKj0szqUzMsto3Qm4Vle9QP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

> No, BLIST_INQUIRY_36 is not needed. I included it only because the
> nearby comment "Note that all USB devices should have the
> BLIST_INQUIRY_36 flag."  said so.

I would appreciate it if you could send me the output of:

# sg_inq /dev/sdN
# sg_readcap -l /dev/sdN
# sg_vpd -p bl /dev/sdN
# sg_vpd -p lbpv /dev/sdN

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
