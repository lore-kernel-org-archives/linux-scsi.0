Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33325C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E18E613D0
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhEUUhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 16:37:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50310 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhEUUhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 16:37:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKZHji146014;
        Fri, 21 May 2021 20:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=d/htDXzjjctXxrpi+m6hpmVieirpJWNmB8HN/PRZD2U=;
 b=tCAbKyYVTCh95Ib3dTWxFH+aRetCrhqHdgEJpeX78SRX9Gkx2jx5OBFYvAXOt+P14riZ
 Yg37PVzetKx9OP5C8z+U2ZJJKZoGgRDlYBKAm9AWZAQvLi1u58tyWFV+ZYDY3AoJUZIv
 TTpbQOcSDck4GBx9ixypomXu498ug3WE05x2PO89XrDft8zHi98Rj/FY3Z0i/Xpvm/Q5
 ia/hobNNdZnSoN5HMABjQJ7H4iI0ZyU5BrmXj2lW8yPBNvv9eHeht1Vn83mu6JyXHSQ0
 s638eQNvnB82N6nxfGueSlbabZMcjHzgcyWzGr/e+LcIxbfxUWAyiXdNn1gqB7sG5NAi lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38j6xnrmuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:36:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKYZhj033332;
        Fri, 21 May 2021 20:36:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 38megnw355-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:36:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZL6YUaCE7kh8/HvwjtT+zQZ4nZuAL32WBaoeaHHRz5uoCJSBYx7zpg+TL2WoTFZLHN+64uD8wYfOrFjehfLTxmZxvtY84Qa8on2/OYEbfQ/HJaxyyK8aJaKy1kIVcZB6Z9VmpIuQt7gGfT26y1Fb0G8QZGirIh0lzkAsxssLdKIw+gGxXENdVseWRjsVG14/qDauPJ+ZlS4KDwmn/ASvDbEuz+RTp38/BoMdIZC0i973wfqepUE6IPfDMsn96xZVke+b9jEXSVTEvRoY5nMa/f2DIt/1gqjAOPt8cxdSbk/l1oyUESPPTeHYxsm8V0oFqyoQFhT63wWrz/EeUqSCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/htDXzjjctXxrpi+m6hpmVieirpJWNmB8HN/PRZD2U=;
 b=VOW46vZ/tk/f8yg+g7gVGk2mrsct4dLgAA+v7lj26LCAX6p5TXy5JzzUDzzB93zjPjinvVNIaLf61EZK+YpkSsVjbfZo6jcDQj6ZiSWvQiCI4BqouwwhbMZTB5l0nGJw+fZkk4uJJtBFeU+tXpYNfKXiXfKankR/i41OUmDCdw6lLT8P16ITgo0kKfbDTDLJozh0NtD6QD3f6CWz7l+Ah7NQHeF2ZjF26G4qkd0pWi0jFeO3y/IcGfCiSJXZHOoMsIumg20lH0FdAFqfka+kBV/likfHCOru8V+ESajaobgWnTHdr5tAJ07gxOB9FPVH9fa7rIsqSoWVK0Y+9AxtMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/htDXzjjctXxrpi+m6hpmVieirpJWNmB8HN/PRZD2U=;
 b=LxEgDu4kXUJpDZlAtWK4MYVgWbY7nAipGoOwUSMPeBOfHqWZHwg7tpDbouwxlkIV7YPpvF9FEnxucow48enjQZlNsZSBhHwnBuVUNIsRBwOraVPp85YujLNX9Bgu7eoMZGYvANAeVDp+6XcVBRNIc+hVoW0Pl5mXLjmuiWO+Mkg=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4405.namprd10.prod.outlook.com (2603:10b6:510:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 20:36:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:36:22 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: debugfs: remove local storage of debugfs files
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s474yia.fsf@ca-mkp.ca.oracle.com>
References: <20210518161625.3696996-1-gregkh@linuxfoundation.org>
        <YKPrW1rdDE7GgjOm@kroah.com>
Date:   Fri, 21 May 2021 16:36:19 -0400
In-Reply-To: <YKPrW1rdDE7GgjOm@kroah.com> (Greg Kroah-Hartman's message of
        "Tue, 18 May 2021 18:29:15 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:806:6f::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR12CA0005.namprd12.prod.outlook.com (2603:10b6:806:6f::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:36:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 668dc64d-1832-4b83-fbce-08d91c9818a6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4405F5B49E5472BA994A47248E299@PH0PR10MB4405.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLaKhyGrhbVhpxeEqPj9PnE5+c/oD8E4HG8Oa3U+2FM+J63HQiHBvPgqKkYU7uStPlJ12mP3iXrZKf2s2vH/ahctHyQFbwCeGfCsp/pgh1TekykIgKji186ywDEKpw+Mn/w1oVj4tDS6iKrM9I/2zuzjgyUZRZlFA7Lvxaz7BMnUeMLMFBymbWLrAyvJekRnnHBZwC/HbRFfWUOmCPu+60LKK0OCUDUucUBTnK+d6hv6vLLg5Ko1V5mkCxgqoT8xsp+BAiiIeNA9RS7BfWY14gQDH275KTqPdPPXU4CN7zNFj3tH9icZLdUhcDTYiaLJ1PbRXCyDUCeqfWMQrZPHokVmQ9LH5KcVL6aZVaLlUmsSAvuVw8YpoBWQNUaqAUTqKv79v+wxSdO2Hpgju+QagXerJ78FX/JBaqBsogv94vsxCr/TrudTwbKCOLlE/OdgjahOHQqK0SEiJCpmdMWi2aC7jyDY6Y4x+L2izDdEGy06ck1agYcOLaFCPO6jCjxB2HZDvaDXIhvAbPtmfYe9F3/4gIpt8mXLCkohtEZiIsUi8afTjkzrM0YR4YKjqWg1FOE/R6+vSMjPvA3VMBFFlp7qSsI0dT/2O+CiDUxPcYS2UtcwBhmygy1+bq1yWETC04P3CD16JskutpUu+zGZ9/qPQNONSnwMIcrsHV3xO2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(7696005)(956004)(83380400001)(2906002)(86362001)(52116002)(36916002)(6916009)(55016002)(4744005)(478600001)(38100700002)(26005)(38350700002)(5660300002)(186003)(66556008)(8936002)(316002)(16526019)(54906003)(4326008)(66476007)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cZ2+UvJGPLq3QudmI0TXF0QI75fit77fGdwT2qrqhchFn3oE7ZWMA4Uc1X+j?=
 =?us-ascii?Q?oei6KfUIvb+8P3mm8L78bbQ9TZEhvtN/Hiepld5HXBoFqLNz6u5CaCmw8Hce?=
 =?us-ascii?Q?gtwCZmMARISnqcTiI7ImitlJ8Oj+q3Iyj8tD8qyi2rwBF5iq+Ff62uGyUz50?=
 =?us-ascii?Q?LOBLVjnxQki5NMp4FNFpOgWNlYsNccxYN1pRDj9CGPEgSnie5ZoJ0HefHZHG?=
 =?us-ascii?Q?d2OBUPfNexwJACSAZR91Cit+uAyyk+quQuaOMV0hu/Tc2ySD+ixdsnNWihlx?=
 =?us-ascii?Q?NqjRR98sUKamuAM/kMeAZpcKpLMbfbzo4TVrtdPbWkakWETnkR7AQ8ZFq0Bu?=
 =?us-ascii?Q?YUgdMgeE7d22ji3q+CxHpnnfZXv8ZodBErmxMuLX6XYyH1HLqryPcAA4Ajjy?=
 =?us-ascii?Q?O1dKfcJd4XrrE2Ywpe1JHKSXu+pbJGKygsvO2wZy2nuYP28L0+Y3A29CWCxj?=
 =?us-ascii?Q?fEko8DTVOwPb97LUpswBMMVW4rno0YC3P0RYBbgqQx06a7El2AWkkLxGg1uM?=
 =?us-ascii?Q?exp4H77rtZ7dcoIsHbaqq8sMRI25j4w6MdOVqgOMuG1MPWjLeWvnSb7q8ftM?=
 =?us-ascii?Q?FE02r6wwvuAY46kLPBg3lBYXD08G8eGz00J70omUBT9mqhnOLJkdNiubP1c2?=
 =?us-ascii?Q?fx3jGL3u/VMm0z/4nLN+D8NRnTEG4J+xbMmJEr3XDTcOTH/kVvqtMHuhttAh?=
 =?us-ascii?Q?eRaJDgAz5wVuUP2GsG4eoJNJC0sQ4AyV2owJ5bj6EA3AIXb1DnvjlCKVOjfo?=
 =?us-ascii?Q?ST6yJc1Yu0XVU9xGAtAvZt0LfYkd4Z4wHqx4DrWWMmXZ3C1dbwJLtFlmoATa?=
 =?us-ascii?Q?40o26prdch2EIoCXUmmP4wsxNFNMtBLAUlOOAAOZCVb/svbj2QzU1wWoXxoU?=
 =?us-ascii?Q?g8Jf82J7IsdZs6Y5en9cGI5ZNmbHtZ7OFRJPlJmNKpzr31ToYk01WhKiOQrb?=
 =?us-ascii?Q?FWx49MqzzTug5V30W384gdui4JSixvf2XbyQGQzOuTze0n2cje7DAJLB+qZZ?=
 =?us-ascii?Q?8WTseq4Hzj+/i+/6ENC3fZCwsCPY5TaP/I39m4uN/QU0ZGSpr6cmpzs2ymB2?=
 =?us-ascii?Q?09U0ZkWBdzYynkJKlmoRM5VVCtoUZbNkeQDidwoFN8DdfjfpuWOF7r/YPZb9?=
 =?us-ascii?Q?LqNqIyFbs5l8hQnsrvQoDVeFmB3k5LD25iCREpJzbwcUwJLLv+YuhkkoQmOs?=
 =?us-ascii?Q?jei8ZOfYGMq7PXPRpP6i6LUx39iHr2nS0pbaKzWeshNest8KN85zNSJdJJQ+?=
 =?us-ascii?Q?MRc1uk6QXiGMPHcbcCOrPYICcDgx2Oo9V8PBibzlTBEOMfkQYjwwnN3MUgDS?=
 =?us-ascii?Q?59XMJKJmU6xwITKa311jazSL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668dc64d-1832-4b83-fbce-08d91c9818a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:36:22.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlNi7Ls5bUBFgCAmJVzzZkYrJ6+dBZd00egpwFWmK0a6vmq3ldKttZ8M+TIgdLbPmgwMa7XTDfToq22DBvSO0jfmojy7c2+OxVsolpFngcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4405
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=989 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210112
X-Proofpoint-GUID: A47xJsa1c6QtFFt6Q1nzH9CuawjwpcI0
X-Proofpoint-ORIG-GUID: A47xJsa1c6QtFFt6Q1nzH9CuawjwpcI0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Greg,

>>  drivers/scsi/snic/snic_debugfs.c | 23 +++++++++--------------
>>  drivers/scsi/snic/snic_trc.h     |  3 ---
>>  2 files changed, 9 insertions(+), 17 deletions(-)
>
> I can take this through my debugfs tree so I can clean up the
> debugfs_create_bool() api if no one objects.

Sure, not a problem.

-- 
Martin K. Petersen	Oracle Linux Engineering
