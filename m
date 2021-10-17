Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFE2C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 01:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0438F60EE3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 01:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244778AbhJQBuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 21:50:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42426 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhJQBuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 21:50:22 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNwAFI011812;
        Sun, 17 Oct 2021 01:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=eOE95P65ZSu6/WpVmsDTtrE3q3jQ/gm52I9XlGWNT0w=;
 b=aZjA1zBZQ+Ju6TyB513K/rpW9kXuvck1O0UhrBa8hktLzX1j9Nl+IrSxy6JREULuLJTA
 r4Pi4zuYuhq/stzW9cAA9vyzsr+guhmOdRo186EczCjuRwcRDQNMvmTkOwO7SshgQKjF
 mhYELHCbaqynArNjU9PIrhBnk9VKJMr2xb4UW3RMZJcF4PJNsgJbVBGpME0zDRDs6hqu
 15K6oraUsMeFi2g3KHqmxzzvGxUJ2b6wM6LZ3hqzatVjR+EhtLdAPMG2n1+sxk6F07OQ
 zQR2amq75rr5Xwp0YMGHIW2LFFDFJ0XPJSH5IAzbrQnHcTHKI0WaadUpsRQrrnuY5CWm 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm49p2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 01:48:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H1kwks046563;
        Sun, 17 Oct 2021 01:48:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3bqpj27uby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 01:48:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndMFUJcrxrgE1bRcSo7QLqJ+/3MVQa49k3jbo61pIKy5Kfu+3M/jIn42pUYikDhbo9EIeqB18dEWAxk5qozMahYFghDj2u6XJ4co44unfNHwxLwQecDHWQowRzvo1X2ca4Qt49n5YQeJ7/ANqBIlGE52vCOy3et+QPkZAkowKFM2uoorBcGW4Zt0TDHQIILJ6424oRe6kZ3ra8Yf0MqOP0vy39EokLj1MZ5/s7JwwBMh+n28Paj02PnLXpz2dvgw1ENOeFPTYd7NTLaGHr4jmF/SUe9y6zEOx0/gdkB2p54qPLVcTsxXsBykxC9SRhsCZmDJQhf39dDVv4HNI1ESFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOE95P65ZSu6/WpVmsDTtrE3q3jQ/gm52I9XlGWNT0w=;
 b=cI6F7eYH42T8142tMx8rWDl8EGcJDeISzKzBiKWbKm2NlQ01kySLFeCWbouQTSaTwQu9awbznvx7PfX+DVcFm/Wkgizg7kRQZoawd9MZXAGpuSHZgpuB7OIMKQu+lpKFBfvJXSfUl/hziJ087Rpysb/qGSzgTf3kgXO//PTwPV2ISKU0HoAVgDdq3rPG9K65yJyu0e2bKfutgCUtHHYwPemfL20d2SU9ao57FTljLVgM4iICEZ+2ek4z8mcWmdcLP09Wu1sdm5ZSwXJCAqEm9ftduZKISqrIAvl4KVL3L4oEF8ixsixR6hW8U5TMywVmWpvLXJiUaCca6S5nMMzDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOE95P65ZSu6/WpVmsDTtrE3q3jQ/gm52I9XlGWNT0w=;
 b=AeVxdoKmShojCkC6d2/G+s6HR7kdIIkV7nm2g+Ym77qfByCnxKLaf/Alrp59McGlv47AT7a2a26RmBRUp5QbmX/J1HduHeijFOkEE5xx5D8Q+HK1uvdCHgpyZtViwEQ8s20wS2k28iVJchJlU7grTkH1IlmDkOSPcqUU0ihsuAQ=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5746.namprd10.prod.outlook.com (2603:10b6:510:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sun, 17 Oct
 2021 01:48:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 01:48:09 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/88] Call scsi_done() directly
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6j8ifqq.fsf@ca-mkp.ca.oracle.com>
References: <20211007202923.2174984-1-bvanassche@acm.org>
Date:   Sat, 16 Oct 2021 21:48:07 -0400
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 7 Oct 2021 13:27:55 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0340.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SJ0PR03CA0340.namprd03.prod.outlook.com (2603:10b6:a03:39c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sun, 17 Oct 2021 01:48:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb72039f-21e5-4d6f-7b35-08d991102c1b
X-MS-TrafficTypeDiagnostic: PH7PR10MB5746:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB574672D8509D52BB7C88D2D98EBB9@PH7PR10MB5746.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0gFk8nLJFS5PkfVQCCwxhInmxzsqMvm8wxg92zrYGAkg8ImOKTKqYNSYeeyaEwsKddiLImH8ZdLT9115FTW2WOn240i5ehcT2ECq+G7pNo7ZTbNiclJ6wU6tnliT1P34/D1jgg0tKY0qjaCi5ZIbN5DnAyk7TgYZ0cY6gpiflxu4/EihdBFxljZEM8dHqUkApvbVBpjdnlxFE9ymQcVP2wxBz434t+NU8CwDiEMnpks2Eo5oBNkTr2uOR/nq6yjxDKmgIIDF0MvfORQBgARz2i1X1U7K7oD1GE++Nrd9TP+6ULRHzSVQktz9AYwY137JXUNyu3865GYX5lxQ3mW0nLlhvEHOQOBsoU0inxq17KOiblXS9OOgtosnH1txOF20DSwsouD4YL7DPu0JD+myF35l5gtI9HIETCoFEOfXsN1aiWYRhEmQWkO0zU8T7oE2f+bZJa1EjslSec1swytxc1ojc48fCSXEOVBidmbckcXe5w7bcLY5mIlLxAVOcn+dIgbm22O8rabMDEzSahaUD8oAz8eAPz+mHcevKMJnYu2ldYWhoggc/Mm53bJ9egwA6DwjHiJvJM488AUWyiWJRJdb1yLKuR5Q6cOTfN4++v4qLskMCywZpGAmwmRbJhbCyQByg6Nn0G1S13dFHQNp7lbSSheJMcJswZUE6Cpz0W7Cw/730O17srPGFPicK+xNidiSDnGdE1S1o6ILBpOmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(7696005)(38350700002)(38100700002)(52116002)(316002)(508600001)(86362001)(8936002)(36916002)(2906002)(956004)(5660300002)(8676002)(558084003)(55016002)(66556008)(66946007)(66476007)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/TC+dfUGx5VamI+F4MUBuCRTG2fcyViBD95Nb7vuYB/LZpgPLAXTbMP/+67B?=
 =?us-ascii?Q?Q7E1bnhjZZKhDytjzYcXjTLlt8pcMd/le/xUiw/trZja6150HrqIBLE5ph60?=
 =?us-ascii?Q?yf1kd8yqT5EPxUbSLp0NOW0CtTaDkLXS+jTwrVURRSeqSQAem3P33F3Vg4al?=
 =?us-ascii?Q?E3c4MuW+a8FAVSe4uQR6YRDT28KSpkvLkt54bcXW1ThmkI0BUVrffLlmnTJ5?=
 =?us-ascii?Q?3HvTrg2EKgKlxSBslfwwqPyFkINIIWQjkL/Equ1aVqgmqAIoWmJjqSIJSGiJ?=
 =?us-ascii?Q?duoF5i/0DPtqK3NC7qDgIxIuWUQiL9vApfoC2uTbrj4EaYmhIk4S2/UeKH/G?=
 =?us-ascii?Q?qMeN0ZRvTdgK3rVnQNGQQJKF0ZeDPMXH2FBoRV9XcobzQMn2PM6Cjyp1wiBs?=
 =?us-ascii?Q?Olj+UVJoacocZ//ijKUT/P/8BFrn3f3m2/Y7hH+lz1c4uny2xT9Q5m5us7Wv?=
 =?us-ascii?Q?Yg2Sp15uLL8VpMHxwUoNd5CqiRMI7xzn2vveoDxgYlqA+5hCg4AM31CFsc3B?=
 =?us-ascii?Q?Knn3/5K9gvGN52hRV1qTBewWosOTzgu5men903kTTV3EOXhxLR7Lz8weY8aO?=
 =?us-ascii?Q?hfpB4RA/lO8gDhdy/CnHufpWj9fNynf+8XnQXGv7gbKzmI0R0rEganMO4W2V?=
 =?us-ascii?Q?2EH68EiVETVVNUhUZ9N/qNw4p/NN2TwwcucOHNptOn+31SEt0q88ZX3gXNAL?=
 =?us-ascii?Q?L97kzgzqztp2PNyhBWpIVq8Guphv0uCsY/hOqJaeOUTJGPxefB7rl8fgIX7o?=
 =?us-ascii?Q?fVh1mbhZi7/uKR5pNbZad8G2NVDOItVxqWoR9474exqJ0jT0wYp2i8pyzVRj?=
 =?us-ascii?Q?jmRlvoyOtlHXWloCYOv3Uw5QBdA2m10oerjRAsdGkFnBIP0COQ/MJl82QhrO?=
 =?us-ascii?Q?JskS7MgUtY8A6RzZJ0b4X1b3J7dtMiKt8kYGgZcqAbVYCjI4CuDaqAak2qQa?=
 =?us-ascii?Q?CjCpSxqS1YoijV7Pn+b/zz6k6zc/EBDQ6JyFmPJYlYp132jK9R2UmHLS9prQ?=
 =?us-ascii?Q?n2UcYy/+XvZkwJ78DuRSuGvXAo1ZRwjLqqd51qfSHwsrMN8kfTqyg+4gSYSz?=
 =?us-ascii?Q?FSKneVelS5H8Lx885squhPir+j7I9m0I0SlLYALsTr8J7snmtuAa/vhD986G?=
 =?us-ascii?Q?VWSga1M4uPwEpjyh5ltvxHBrLxTMm+zCXANa3zIPFcEtGr2PSDzvF94iDI0E?=
 =?us-ascii?Q?xTWn3u9e71s7PQouFZDQ2lsWQkliZuCPWY+wE/2q3F53YO0wohBnTUU+/Bhh?=
 =?us-ascii?Q?Zvu/Zp3+z9KKFTxbUZnW7jtX6nijriBda2/bxqztiq0vHA3rQENB/gHy0Oxd?=
 =?us-ascii?Q?iuLFDGiIC42Gk/+i06/OGbIv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb72039f-21e5-4d6f-7b35-08d991102c1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 01:48:09.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnLb5awIVk0M5CrezgAEeZUx5I40maFPAeqdRvmIzQh973XYIJRUFxxK+ZqxfRCGdqcPwNyjp8wZDOTbnw/LynQ+kRk6CjHdzd0EUuYP/nY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5746
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=933 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170010
X-Proofpoint-GUID: zp6XDohqVRJWFBSxtKI_PpdnGSjHKlqi
X-Proofpoint-ORIG-GUID: zp6XDohqVRJWFBSxtKI_PpdnGSjHKlqi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series increases IOPS by 5% on my test setup in a
> single-threaded test with queue depth 1 on top of the scsi_debug
> driver. Please consider this patch series for kernel v5.16.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
