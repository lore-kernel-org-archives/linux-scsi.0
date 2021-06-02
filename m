Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CB8C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB25610C9
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhFBDZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:25:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhFBDZn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:25:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1523Nvs2013624;
        Wed, 2 Jun 2021 03:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=F+elmLDCe0TDX4xCsm0zIHxBBEENjGU7+3UEKPnO3os=;
 b=VGa41xGpyz/RfmEFTd//hxX2dhoPD3BuYKUq/7pCQM8c6QduK6fqFml9IalPEbKXcdXu
 ogTCeblVCTdJvJNo2fT8DDd3WOJ2AA2Wf8e993n23cn2mGtHDCOwQWKL0eTRId2512u8
 4zDVIWlF9zDMWHVkfLCcxYruyxOeS6Pw9LH/0XO9N08i8gMzWWbngWyN1OsrgZ6U5iWr
 iXNgBG5govaSebq9d21OZAGriGlqdNl7u/EUg1q0YER4n+3S9DRJh7l6AXVzC55SAdNB
 0kGQ3lNjUfETXAa6VF91YIF5zhGRAp84pAq/0NS6ZwKEvGK99Pt0jdb85mJs3uaQYNOk jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38ud1sf83a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:23:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1523AThf141348;
        Wed, 2 Jun 2021 03:23:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 38ubndp4d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:23:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmVSwrbFAMoL6rQBuwwdC0MaF+BxDkCr+cdF9HkWFkzIuCQzw3SZbgGpv4MBZv3WglSjnuREf3kPUaJRJ2Iy4vqfyHiCxQPo98ZTXd6eqpST5Z6B17zLMfkWA8sS9Z0txLsz5F/sB9Yij8SApPEGRbxEu9+uloIaGajZaI9oP7IDctxrByk24iCY6LFIKchqM63QcctNdG+rkw6jlune/9vn0YlP1y2JeDMUEs1DwiczSwYSQ0eC3Ls6XxA0FDP+xcEs+vMSzh9jkf4HTS3rw27774HBDJlXuqiODmnRH2iJF0LqiIz06j1GjyfPpnQ0CElP9HV0dyzJq+Eg+9nSuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+elmLDCe0TDX4xCsm0zIHxBBEENjGU7+3UEKPnO3os=;
 b=bHj8VPB+xD0WjjZXzjQIlXWAOsst10FSjYPfIKjKnScVRSQboecLskOz0Kp9LI6kfQgp44Qz37YovGL3HdY4ZBSZrSqBKaSU4EMaf5P/Ss6mWckaOQsLakx7Fw4ks+fY85WQmN0yHN2ysGfVBZDd3ByjmV+JBxucA77n5Aq9u9gTJiGukPTC2XKWuYcvQwm3QAnpm9YcL9V7IsR0WsTrXaN0UDaATLi4dul/JUotzkYzoKLNGU7tDhKNeodf/WuUrJxhDS0IBQ+9p7C5r3iR70DD+wRUCm+PYqk9vQ/Sp8mFjDDAsLjhT7J5OM0yaGCzm521fRAXWECsvY0VHZoB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+elmLDCe0TDX4xCsm0zIHxBBEENjGU7+3UEKPnO3os=;
 b=ooi8eI1wDTrReLyQHkXclJ9d9mkK+ulxNGFez4oODHH+bqUKiAP9R0PVo9/BaOqbe0614P+ijiPTClM0+KdZ7ub8DcqQnbtl1jkn1YsAMaeeRukgHMNM0pyLBfY4An+XF/skCdGiVoAPe5jE8db/MN4IfcK8ah8tW8o+FevvdwE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5468.namprd10.prod.outlook.com (2603:10b6:510:e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 03:23:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 03:23:54 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Fix fall-through warnings for Clang
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v96xosp0.fsf@ca-mkp.ca.oracle.com>
References: <20210528200828.GA39349@embeddedor>
Date:   Tue, 01 Jun 2021 23:23:51 -0400
In-Reply-To: <20210528200828.GA39349@embeddedor> (Gustavo A. R. Silva's
        message of "Fri, 28 May 2021 15:08:28 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR06CA0025.namprd06.prod.outlook.com (2603:10b6:a03:d4::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 03:23:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b20a8a08-efad-42b8-3a33-08d92575d97e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5468BFF7891471CC10C9927E8E3D9@PH0PR10MB5468.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9QQnc/5YrqqqSNRs8u4cajN0LyAoCJPnKpX5lljKHmG4sd5S9/x3Y4aLSIFedHSzSuzeSH/HV6IZaBUOBe1/3HUDU1XxcvmbOxdRK0qbKPEtUB6g/XMzyjG88NrNlh9BKkgFStXgNoIQFTF67SOifJvsms9fKQUYY9dEudomLugd20fciWxLBzzVc/y55v7cue1NpYl+DdFw5WQX6dZdKAiAdKipnzOqQs3J4FJO16BjVsxHTlcaFBj29TVcqDV4aeOxtsxmWeiUblQOfovHmlbpybxlm0htSO2kF4wwYA0eRMC9xx5o/IsL+QD7PUfY8nR7V/efrOac7ploWGIf1wYyK2+PHFAV8xJHJoWOG/ykqQGbtCmWXYJFZ1rLqDIozQXI1SwmefMZ6Sbv34FPQXWpeblWVPCxNSuLzfLQuSIwXKJtYyXZT0gTsspI30zq8EtBkVvdVjidoygBzNJE5HSquJA+mMIrPQvaa8ZYMmT6pQfZ6/NtRYqIJa4jblZWDZr7nNJhoxoYkEVBnARtQV4f+q37SyltmkmtuKKqu0282gM6EUxNFLa3zLGAQT+HWUgSGsOE9LEzyRcuZw+SbL2Lcx1J+SI8+LqnHtO9So99txDhZY/xxGNlWOiBLd7KKVkY7YGhTyt6sq9dwKUVFx4Ga5NpFASRGPBG21aJX4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(558084003)(6916009)(16526019)(66946007)(66476007)(86362001)(66556008)(26005)(186003)(478600001)(316002)(4326008)(55016002)(52116002)(36916002)(7696005)(5660300002)(54906003)(956004)(2906002)(83380400001)(38100700002)(38350700002)(8936002)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2QeDiJDZalrTlGOVLDyNKe03/1hPJuxMjXCUfKYSn5H2FWK+qQ/4rp/1XRYD?=
 =?us-ascii?Q?7GN5pNiPuAAUW1w+f9+st/uuqDvf/Q393pL5j9Rkkrbc5rWtWvv3TnNK+x7J?=
 =?us-ascii?Q?+CvkzDYBPv2lkssdIFnNZwy4DttDabga0AH13gJLeu9X20KZeS1HKFCIxaI0?=
 =?us-ascii?Q?dzEvnfzStz5dotVl5dsYdvcWFeo99UoKyllopyoZvbDlDIXXYXHFXzNbK/R8?=
 =?us-ascii?Q?a6o3mq6JYrzmDxTe6xjuO+wSyavOr9F3bXFb+dokUZ9wFgTlloCbS51EAGha?=
 =?us-ascii?Q?3Gx7gm3kXGWO8ov28Av7mCnBQbqVIOVJ+aNvxUhUqJgY7Pq+Cw6SroLQuuNU?=
 =?us-ascii?Q?bTzMoIRv/oGxS4ECC+qM/NVcHHPSmituWuNQGcqsLzewhaVUUVCJE0/tBYqV?=
 =?us-ascii?Q?U4sEJYgR/Tn9y25gp0nTOKvdsF57ZJepFQU7pcSA5z3fBOtyPKDL2Pu2rQL6?=
 =?us-ascii?Q?orrEMFQUDKbljRMR3TdefQEsjN0r15PslBji5lQIfIvnv9TV1pJhD62vMIMX?=
 =?us-ascii?Q?tRXCcSwhilQGnu79CcZC9UE+Z76RKD4ZFWlIAg8b+PZBmbjkoUA4Lduw1giW?=
 =?us-ascii?Q?2Lkju/bUWV8FwhYpMQ1AB3Xl0Irb3OB20lbYl45fKSb9iexIIasf1LqlKzCS?=
 =?us-ascii?Q?GnOPG3AIdpyBvwM9DGqd6mZwi7aYKHItwBiLXon6k1JjaR7nbg7GinuOQZXV?=
 =?us-ascii?Q?WZpqKsUKYFZUqsXpQ+Wv8yf/jFir7jTq0WBthDECo8c07F0k8a2rsTvA5uUl?=
 =?us-ascii?Q?Jikmy42HqsJCQH5Up3ULED9EsqVg9upaBTW0u8IjqQtSK9VCz82FEzHJn2PD?=
 =?us-ascii?Q?My0YjASH90SnSyEpQNh/X64rNXZ2t6R+xxsSfxj3hKG98Bhs2Y8C/4t5K8qi?=
 =?us-ascii?Q?KZ3gg2E61t8iev1Sja9gdUSdlD2MkYftcXTO+mQH/3HH4em5zNcdz4+yfBEc?=
 =?us-ascii?Q?X8znnrXN24gyNbwMVE9zCQUYpnoeJbJFithvHGWwcngjxoHMJjps6HLlPXr3?=
 =?us-ascii?Q?jSowxTvHjDuPPCPYKpwiwKAxtF4r3YbbzljOfATq99Cjh8MVMFZTJV+GhIma?=
 =?us-ascii?Q?MS9kfm9vM3asrKrj9OnjIYtHrcSwnxYccD2gNt99M0t8oULjH4Yh/+RhCAZT?=
 =?us-ascii?Q?ENerR+D3rRxR1s1xPhIZSnXDmu3Rk0f6/3M3DnAAqgHosI7yRFwVTEyUNCqs?=
 =?us-ascii?Q?QUcMXKRoihV7sKVt0QFI3pS1UgVyh2/GKOSHiWJoOSaXq/CJtQhbnTTeXyD/?=
 =?us-ascii?Q?nH7QB3EI6XPdui9aIdaMOvYqdfATrOMYBNMsY+TeWxPKn73O9k9t7HcCKI/7?=
 =?us-ascii?Q?W+dzmm6OueDn5FAh+F1Fo61f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20a8a08-efad-42b8-3a33-08d92575d97e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 03:23:54.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BY2EOhurkESVsvyHz8/wg7ufmuhQEkcSzcU3mJAUuJxRuYFHYMn3hHrsIJHVQztBRkyqEtdZBIQaxQ5kbEn4CGtaI6/WR4xA/zZ4k2JrIzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5468
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020018
X-Proofpoint-ORIG-GUID: pz8liv4p80Y9Ya1ERI_NX2fWjp2kOE__
X-Proofpoint-GUID: pz8liv4p80Y9Ya1ERI_NX2fWjp2kOE__
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enable -Wimplicit-fallthrough for Clang, fix a
> couple of warnings by explicitly adding break statements instead of
> just letting the code fall through to the next case.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
