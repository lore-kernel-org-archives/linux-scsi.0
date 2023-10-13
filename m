Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F31CDB482
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 20:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjJMUym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 16:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjJMUyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 16:54:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9E9BE
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 13:54:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DIESbF017506;
        Fri, 13 Oct 2023 20:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=T5AUXYGsU/7aZvOJASOKHxm+ASuAfoblkzXzYcficUU=;
 b=m3s1HudT9auMhenvQq/OfE2Djp72gwnzyOVu17zT2Ov85KIW9aszIG3W/0A+gVTudpYM
 9QOxbDvjFV75b+lTTRfdGFcrEukeWRe/cgLu76sPsLzdjDquVsHZMb6S2rAKnEgkpFWe
 bIaMGsF85MD3VtrJ8/Fz3vmN9DnszMows1NeDJsyfxJ52opUUZsNEzQZDvutIAWrVLDQ
 GJqJzAyhPciOAKHo/al7bt2dS+5VEXjHu7q16mbFcnZJrZYiuqpw1mas81DPDqeFhUDe
 qrSfZSKWF2h1dR6yhtFpL+GgRnwwzxnTOwg9ti3rHNnqpwcCBN0Th8qLZJWSw7UzBha5 zw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjxxudvsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 20:54:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DJ48bF021315;
        Fri, 13 Oct 2023 20:54:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tptaswwth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 20:54:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3f07uqumf6cDCZY95pYnO6VLwCCdOPmJ+CsR0kXwR2g96buE6EGaPEAae/H1pH5ykHBp8NLh5mEB4oDIoEiSCmdM0WI6H09oHdak1DYcRNk526MmpfQAS5+IYabCww/bQjP7viHmqtg4U6aaPafCsxwV3cl1FVm3ssvaYBnrEv7JYWUuEEDVAnpVOeLSjhJe2nvk5oHsTvU8jlGAcZrf52tKrK9sLaCVAdQ3h8pX2AHXmWGJbNn3/iWIePLnIqnkLOh6H8RfQWZNaZ4UF4/T2x1BvvmdnJSSZCvCYUviePKFbedMQQveZrdo3O6ohPM+zcUiUDmAYbjVlzgGMHI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5AUXYGsU/7aZvOJASOKHxm+ASuAfoblkzXzYcficUU=;
 b=odYtUmcDDciBqdm7z4w4R/Hz6ykVCi7Qi2EUeZVjiSOEbrUKFYKZ7qA3SGaIYVCiZiqZCOhSXT7Qne7p0D5Z3ne6aq9UFSF4+XLh0AH64EtukbQzHRxfQXfTE2xOLm48wfZ+XXpG1JcTmoTJV8HtvHblJ2KeHfQQA5s3ylhvdyUCXv77CPYctSCMbi7OCyWn95ptPPRDWBprqJ60wrzYrZk3OT4Stgx8AX0OtcbYxJabROLcsvgP3WDohxIRsj3cXBSx1fMyB9SRW2WBqHoBSUcTMjtQmfyjRL2pjm597/e/Abg5yoiN3rOjoKlfh4MaecVsDgFFNQRsix1BXDC4cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5AUXYGsU/7aZvOJASOKHxm+ASuAfoblkzXzYcficUU=;
 b=CHl100yyWZ8lXpQTbPTeii4nIi1kJyZ7fpPyNR7ICHK4jp3J7/APJ7Ny5nq/g24mYKjVMfKcrspMa9w2oMPKkTDMEGOt2TXlc5oyyxqxoUGw8n2eOTwU9R47QjMzxgvzDgL44Q4RQZ9KhcGutBtuhdMAbqgcNC/yxgmR0zoRSFg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4888.namprd10.prod.outlook.com (2603:10b6:408:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 20:54:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 20:54:29 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v2 00/12] scsi: sshdr and retry fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttqujlbl.fsf@ca-mkp.ca.oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Date:   Fri, 13 Oct 2023 16:54:27 -0400
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com> (Mike
        Christie's message of "Wed, 4 Oct 2023 16:00:01 -0500")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:208:23c::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: d0baf473-f0c2-4672-ccb6-08dbcc2e97dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YC++fhpGnKV9gnOfT8EEqu/l11eaaJDMM5wZz7nIYvz+7ORaBAA0VXK/oJqLCQXvRHbjK6s/Rt0itXt4A11p1tl0tmC1xeQ3qOD6w4DS65/HN5WXHaHVQHw2iA3RCtPAPu7HoDp/Nw8yBczamFdmyr3/NjjyclLyGRfMK2voIgoDUyZVM1cZQstNkIC2XoZN1P7Rp0mTjuK0FSqkAbi9OSo+fYGqCejR6JrdnxWxm/Bd6JrDMGwN8JtH7JdLY+0XJH+op1H/dZgUyzeI+R+42qA71EQhkoj1PY1sJ+OSXK0ibc4RckG7imtuYHF6jHdfTxbgalNKPlq0GWurVjpRFAtEtCf6tJzQ3SwpWeh59DTDs93HU6w4S6svbIWE4vc2Wjcnr6WAdw2SmGSMOur3jZl+HAHXxqYG8HnkNKEhZG/Mzsk+Ddfh0qgf0IdcW/9ZGcuDXWWVMEzBspU3hihoYe12u+UvOaLSEiQirQgBEew7cW+TN4UXbeYE9bQe5GbCv0bgBPrEbn2r5woIZ8I3Ush4zwEFl80R5N3QOsVeyLDQKdu1LSmcyZ90T5MJAjrP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(346002)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6636002)(316002)(8936002)(8676002)(6862004)(38100700002)(86362001)(4326008)(66476007)(66556008)(66946007)(36916002)(2906002)(6506007)(41300700001)(4744005)(6512007)(6486002)(478600001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o0QO8Rw8DM03OIXK+jni3byVkqxSku4DyDPo3q5drIK22ZoC5eCe0MMCkkqB?=
 =?us-ascii?Q?vl+ms4SUQkm4LNXlyFW52svJKI0tlFSDkBN6dciJK6Z+vXKeZt3zkhc9VOlA?=
 =?us-ascii?Q?0T1H3q9kekA67l2E3fWCjt1FH5SR4VibZr8UzYfBrjzkjncRXLGHqr8iMxCG?=
 =?us-ascii?Q?fr9Vaz7Z8718ErTIv1b3LCSmzLQH525IBb+utF9oZ2qTrolYjg76MEM4lvrF?=
 =?us-ascii?Q?m5ZOl7COs1agy1EbX6RmJkZqvwFpiIc4r+MMOO6qrMgu2QLrkPViL1DFSmWh?=
 =?us-ascii?Q?nrdLwGfUU1EBcmMF1K5nh4eHZuvA185LIf3CG4H/TGRs8r6ebu1uMf4ZdUj4?=
 =?us-ascii?Q?PwNowAXU4pN8eZ4/JFiRzm28e7QZ8PAXOzByRsy6nmowsyd10BPkIG2Tl61U?=
 =?us-ascii?Q?hIZyuWxKG8iRhCuibvrE4a90RVazuZi53Od+LxVXpYF96LPX6/rj+Ef7buRh?=
 =?us-ascii?Q?+M8NZBuHQ2rgxqIoOwlvSOrvIvDs+bX0TGms12S7PCvNYjvWuSs0ivAOjICG?=
 =?us-ascii?Q?UUVV0YJZi/7bvDkanUufj09Z3/tqL0KYdDv61Y3I3QKRoBVt6i0/TzQ7OcNo?=
 =?us-ascii?Q?9wrXJuDJQhBDZCdtjWF+YqlLG1Gs5xi8HKbPjJBsCFOmhI5p33yhj7vbvEuU?=
 =?us-ascii?Q?Mf+9iPMxIzv+1abDGMMYhUE+m7jMMr/4fqwxeZ/0O+o49koKIRjpIfpnnIJz?=
 =?us-ascii?Q?oSlV8QN9BZ8kVjlw1KcxdYwdIl6IbHR+8bLtOiDgEdes8OCY8MTa9GotGkXb?=
 =?us-ascii?Q?/QKK8fkdhvE/2MNzAjrZxcfmIKT0OM/Cml/WiOL7biR6US4no8fgE1vU8yGp?=
 =?us-ascii?Q?AGxyhdPpnJrH4pmC7wL8dPxRB3q7P5Na972+Jkf9ImwVvD4xIEaUjSnqBHU1?=
 =?us-ascii?Q?HRXcdVtyspHpWr0U3gpJ2NuF6S26Vhia1WdX4MXwEJpKgbvQbrHY6qsPe6Nr?=
 =?us-ascii?Q?ZO1uZ1zI45uul8lrEACDkkGscVVIbcK82xP3wxqE8OmUVeqD+rijw6/9uGZD?=
 =?us-ascii?Q?9YY0hchtEJTqecFK/OiTILFZKkiEhX7d2uUjcG2fr0i3Ugzupg5kMsc7ff0q?=
 =?us-ascii?Q?cu3sF3Gv7j/IREO4y2WnBMzcLOwmnUOFujYeZxck6TqDhTFfaDndrzUHd85s?=
 =?us-ascii?Q?/lMNPEbhAQsDVz5V3osNyrZ8aScTPOumrVzdfKHh39XrjiFpIyxtkjK97IPz?=
 =?us-ascii?Q?WjB4en8DD8/AF98yYhnKCrMK4sjoRNzRUGHvwV5PQQyljjOf38UfBkooJzmU?=
 =?us-ascii?Q?jhGRmDg/fsVo0wt7FbTbu5dAYDSfWFqp52kNTbC4MGeHjborip+AXm/lAtGq?=
 =?us-ascii?Q?pvOcJMei6/4zhpWkzJ33cWLIJGgEqDFr2pxHquWC418SWbckHGI7FYuvzYOh?=
 =?us-ascii?Q?fB0oYWDfSVkmyqX+LhtiLD4avYM5QJFAA9J8EW63Gcyaz6id9Z9KfFTO1gWO?=
 =?us-ascii?Q?PXivcC46Hf5vznR1zx0nv8aPWRTN6uswZS74XMHEIKLEATue8XbYJ/+daM+9?=
 =?us-ascii?Q?V+BrF3lVh4x9SGbvClehpsS/6g/dq99yrLTDc1uuikBnvQCetqeM1YDQVBKE?=
 =?us-ascii?Q?Ik/79+isRvnRzik0JRRbWQ3I8HTjpWMsuE7CSLybll2toMeQwso6M89b5aTC?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JjCmbLn7DogW1UsWnjZDxb+E2GgfZRPAE4J5Sca9SZyhVkE83CQqHEffL9FxA+QcqT1dblmWNaTVzu6+R39K/+Jd741LYbwYEu69ZdxMJ32LMfuo4bspf/3lLqcCe46W2XhTYwF7R0P0164VufRxe61FY82P+Aqujq8B9xE6Ubtag/5fwHxgjJaNhgHYy2hrFhFsPSSFDzReIPRhtqwFRWy5nsU3y+TOaVhHZvpSXC8K6e/9x0blV03fSkIg/V1CgSWT/6icjxewD3aWTDuHsoOaXYZpcZOVvSF/IE6rX393pqPo2ewHy/9JLMRIMCr8RwVOtCn3A/PDtfXzQKyy5lH1rITcbzC30AuGXILGixzfNRBGxYBalREaSnInnVyzR/2PB1CQ011Zc+U/4t55gFJLn0hayMYXSp/aOo5hnuKP28Go8iqu09JJm4i/qKxS6P7KbyzJWpaWf6wk/xiSzfED5hLWDLLuu8oa2EsTUgF8DOw7bmubXeKwSA6PydiAltT9F2eQ5gZxJRqqRr6/jMXmFKoQOaTJ5xPYJwM28lRdNK9ppq5R4caWa+VpRW0JmfumGUC5ZHyiCSuCvCERieSG6c4NP6NUAtjky/PA0thuvPM3y1Eps2gGaK+Hh/+onfD78JlbWv6ApQpcYt/S1EHeUHCS6VDFyeJwmIYLUl9GsmoReuCbrgJlhzjgHCCVTWOGCxqK74bDWAd1ggegTVRvZewIbLByBAmBQvdsjpS7ZO+Jn0tkzMQ3PUBih6dAaqZaFM5PEbJnLTQ4xGnRn+Id9ndSEQcWYJ2us7TL2KHM3pLHuG8/lMl5bLpO1aWE7AUQOdMq3Wur/00lErCRAXkWfEb+Z68j4y4lf486cw1SfqgY8CJqxQ/gtjEb5d2j
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0baf473-f0c2-4672-ccb6-08dbcc2e97dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 20:54:29.2516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JJubAbI7RbTIc2s1broTkjDMXnAWqIA7hcSM/YQMZOQ0khFng4IvaXMZQZR9R9ms9nC1sO6OVVzzVLKOSMps3DoBAagRD4qapu1ioV/5Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_12,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=945 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130181
X-Proofpoint-GUID: 7slCxImzLH8v2WtXyGzNfyAd4AppxhRl
X-Proofpoint-ORIG-GUID: 7slCxImzLH8v2WtXyGzNfyAd4AppxhRl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches were made over Linus tree (Martin's 6.7
> branch was missing some changes to sd.c). They only contain the
> sshdr and rdac retry fixes from the "Allow scsi_execute users to
> control retries" patchset.
>
> The patches in this set are reviewed and tested but the changes to
> how we do retries will take a little longer and require more testing,
> so I broke up the series to make them easier to review.

Applied to 6.7/scsi-staging, thanks! Patch #7 will have to wait until
-rc1.

-- 
Martin K. Petersen	Oracle Linux Engineering
