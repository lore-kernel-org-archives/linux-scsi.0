Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42A6C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791556142D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhEZEJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51660 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhEZEJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q410Re185484;
        Wed, 26 May 2021 04:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hEc06spP0a95DdJ9DkJJn/d8KBPlDxRTMBgq19gEqH0=;
 b=mWbOoS2EXvnDSKuCV8tY4BhM5tmHcfgJn8gNVwPjUWu1ATsgW5jeV8y1oH3gMeKT7ZbR
 RoKCs/tAw1clugLyrEVzew4I7LUEj0M4McMzl3VwvIjsE3Y4kYMZFBMYuClRHXfZYuun
 JhlAgHpfghlQuOHhDDMDRnbY7C0ksQlh3VOEruSyOcTb91JFuWej/JQhlQxPA9nqAJaB
 MSQuxfnBg6OcOjI97NHRYB1ShpkWdHHc+rn39SOb806QnvQGMw/huTgufZQh56Qqv9AX
 bHK6EDuoiDyylKrB6RGHZnYENzqgruEob/JQSU6ErwTaYh2dF1EvQw/X0Zh2OMu4w+qC 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcftep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q4645R164092;
        Wed, 26 May 2021 04:07:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 38pr0ccmej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9LkFIi+E6hL6+6fclkYScfUKpozUw5hpO7POVNzvkMeX0cA7mpZwHDWUHVNO7CiSL5iAmzMkFw9/UXxG2lWpOFyQ8CcfhaO300LH8GvmUIvkLr3eTzphg1jwicp3wG5EiSvL2NSl9ZGBKBjZbsPl6Dattq4nolONqFmUUlpaOxlQaE8DGHe4zJSzragZ3Hk2ztVzwZgDXad5gk3j/F1EyXtySOAoYoK7tRh27ASKarDARC5hn2u31V2S6qTef4lV/mKAgPjOrvZaQsFhjYhkcotvcDuWupXh/7rTwFWlFOeC96dy4yeQWhZVW5nYo+uKgci1XaklMagSAWzLu6bvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEc06spP0a95DdJ9DkJJn/d8KBPlDxRTMBgq19gEqH0=;
 b=I/ewryUbHaaKi4QQGgvySRJvLExEfB62VlF5DeUJkezMxRvKqZ0WKGXaWCejK+2vmnSyrAQNgDmfnIctt68y9Uf9g34gJdwi9O2Jfsvnnhvik5mDrC9rznUgjjBoo5o9vnv6ARYkfcKjjctVhaZ6FWdA33NzbQRxTE8ZCNzfvWhVBr57l2ufDGyibI2MEmcJmEycK9e4Qc8aXaM8bVlGJ+RDK6HSzq6bVwTw9RKHKKQYJob4CUsia7ScbJCABGBdT3Fxxp5thO2cB9RpgOkyvdzrhehufe0n4fSenK+CQfma+LIfIuOF31OW4YoL2T/STLB2x4KjhaCTYaN4v1biDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEc06spP0a95DdJ9DkJJn/d8KBPlDxRTMBgq19gEqH0=;
 b=CN5jXNjfiw/GHqAk9u0EZkugxuFqZCB+fPOZNuv9Vyw/SMqS1+syCY1Xg9tOAFq1vD2LLRadqKAJ27hpvI44zvpyDZ8Ax61iDsa+MdsMJyqtGmsoNWTF8eXXf1G3M0o6ROyUItehS5VVDMhcJdqk6OX/+yz0/woh9XCXgroHWR4=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_fc: Remove double FC_FPORT_DELETED in mask creation
Date:   Wed, 26 May 2021 00:07:20 -0400
Message-Id: <162200196241.11962.17339032004139341025.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520073127.132456-1-dwagner@suse.de>
References: <20210520073127.132456-1-dwagner@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bde8444-5aa6-4342-0d7c-08d91ffbcf36
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469324CBA1F97392F172D898E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LX3KtWNX98NYN6JRd4TKGLhYXfwc7vKCgVLiQEHvNaK7Q67TDpFV6i2fN4wqrUpVPWgqbDziK1m0Rd0btqY2xqkhQ5N/K7g7jd4TAudYkelBd9jouzujYQMaWEn9rzPPIU1MJ1iMtU2Efv9QGArsmrmr7JwLsOa1igrkRIY22ML/pN85pHqcnIYVSptIPM+P8JNkVLhLqyb2+Dlhhc1MH5Rip8f3EI1Ih2rHplV52cjN9B6kBJo/azmKm5f8/zNr8zPdzDj2qEHkd1ySZfaTYvMq5kPzsz9vVF7Sl78e2K7t/57zhJiwBcFGxJI/6N0AO4FiIsqzRlxADbKcLx0PohmT3HTMyVrlzAaaAvqlCYygyjgIDuY6vdFXnGROUsiDHbEHFsvtd9+DRl8Fl5NxqPHQXmginmGr4uSvdpV6SaVv/TFxvig87l6wlgYSFB+J2Kt0krvsrOUPaLWc8aW6gWgHu/AJOqYqXp7Za9e2xauxtY6420Q9NQKFJkBBhm88zcZs1n8KH8l/LnwIfevWnvcATbTHj9l80NXd6CLKsAbbLMXTD9WOIKjo24scejeGXw76BqCjNsKE7Q9jA1ZhzuqRj6ZxV2u42S8FH4zKPNJ9D72HhzaVpWKTDE9ufSf0/XL7z1+gVA8N5nqtAPawD18nWw2sJPCS81lHeSEwshrR2eCJlHm1tx1fJQRzk5Q71YEEzDpa6h5hnHGF+rwdwh1Maj4nbP+9jguGf5mX32Z5Hx02SzZYBNhfpVzU9garz9Qt1P8tgAuUgXU3okihsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(54906003)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Zlp5UDIwYjB2bUxMUjhaMzErM0s4UlBkcVBSRkwyQ3dOQWEzcU13Rnozemcx?=
 =?utf-8?B?Zlh6THJXRUxOYXlCUzFnQ2tXRUlKTk80TWFzVTZXV2pIeVdzRnFTMHlIV21G?=
 =?utf-8?B?dVlxZExFZjY3WFVCTzNRNGo0T0UyVkFmS3FsT0RuSXFES1pzTzU5NnpSZW1F?=
 =?utf-8?B?MDd0am93RTNESk5wQ2FtcTl4czlJcStWeFdSWksxb1JWYk9RdElVY0dPSnFo?=
 =?utf-8?B?d3c5MWN6MGt5RGZ4NERyQlVvWDZNUzQvM3d0VytYOHlSMW04QmJ0M08rcjhx?=
 =?utf-8?B?aDBhWDB5NzhRejBicVUrSjhZbHIzNG1FR3hNTGRnTS9PL1dSMHVHNGVLMXdP?=
 =?utf-8?B?NHVlaDAvd1lKZUdIZzlkVHhCQTNNZWplZ3V4WXpxSXdEMGg2V29NWEErVFJv?=
 =?utf-8?B?T3JqUGlWQUZWZ2lWTk9EOTdFdStUUTR5UW9kZUYvS2pINlF5OWl4d0FETXNo?=
 =?utf-8?B?SHYwK2NZK0kyMlFBbHdUTTZWUU16b3pSKy94Q2dsdE5GaDFXUVlBNTZ0bXpx?=
 =?utf-8?B?MENZNjVFNGtJeVE2QTcxZDg5T2hrbjVpYVNvOFo5Z1JGRVphS1Vqb2duNk05?=
 =?utf-8?B?RjIzV1U0c1lLMkZseDUrdThtTFpzaXE1alhISmJZWW9NdnJTVVJIOVNkbm9Y?=
 =?utf-8?B?a1N5U3RlZlIwcHI0UyszUTlsdHpjUjVRLy80K205VWhtbmVnay8vTWFaM3Iz?=
 =?utf-8?B?SytWa3E3VDlOOU03RDZLTUtHQ2xVZTE1Q1g5RnVnMk1SU0xLUGY5d2t5UmdW?=
 =?utf-8?B?NmNxam92WHZreUtlVlMzOVcvb1NtKzZMVDV6MWhhTnlvNE1pVkc5d2hhNFBE?=
 =?utf-8?B?UkNrZmJzK2tOajJLRlROQXFTZDlyN21YNytHeVp1bG9lRWViSXlvRWlCMlFC?=
 =?utf-8?B?NlpxL3JMWk93OHFqdjZHZDRsNGRvRGtEaUJLRWxiZHltdEZ0cW1WMElYdWxI?=
 =?utf-8?B?WnFHQlJSZ3QvSDFIaGRRQzhwdzU2eXREelozTTIvbkpvd0MrZUM5M2h2WGwv?=
 =?utf-8?B?ejVEYXhyMFM0Yi9ldFVUQjBOZExoR29STDBrMGVRYzNLTkgxYkF2Sk8vZmw3?=
 =?utf-8?B?NVVySS9acmc2RlpUQVVuWHBSeXdhWU9wdFYrQmpObVNZQXBjVVFQbHBxWDdH?=
 =?utf-8?B?SnRxQzQxWEliVVpCSjB1TmFTN1RLRUtaUjBMYW4zakpCc1ovYUZtaWx4OVhM?=
 =?utf-8?B?MDV3ZmVXN2FsUUpHdkZNRzQxQXk1MjJ1V2JoRVpZVXlQU3JodW55eXJsTXJo?=
 =?utf-8?B?NTVUeDhDQ0NwMU9VM2EyTkJZUHd2SWFsNlg2MEpwR1AzYTlTSmtkMkY1K3FT?=
 =?utf-8?B?aExNTGZmV0kxU1ErYzBNejVYOThud2V1T2N5WmEzTCtZZlAwVWk4NTVYZkg3?=
 =?utf-8?B?QU01KzNoaVlJWXBHb1NEdTEzOWxGWXBsNk1mYkdNZzVpMzVnZ2NGZ0QrUEpT?=
 =?utf-8?B?a1QwZW0yeGg2c3YyTnhFQ01OV0RLUUhGditGNEpJUkNiMVZ2UjVob2hQZUVm?=
 =?utf-8?B?cjVvS0hZcGp0ckV5eFp6dzloWXRCVzRpTGE4TzZiUUFiUHRzeXpReUVzN2FH?=
 =?utf-8?B?OWZZTlBMZyt3anRWcmNCYTU5dVVPcThHS0ZrTmlKQzNNQ0RnT3B1UnpnMlM3?=
 =?utf-8?B?ODdDZTdqbjFUQ2RlOE1qcE0zT0VKeTdHQ01XZUNmT1FpemRBRlM5eUxOVzRN?=
 =?utf-8?B?ZHN0aHZkRmtHa3puZU9iQ0dPUkJOU0kvcVdROVdXdDdHRDVEQ3hNMHlSTUpC?=
 =?utf-8?Q?oXy8CPL+a6if1YuKKAuRphxIOtAn6sNbMoUejJy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bde8444-5aa6-4342-0d7c-08d91ffbcf36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:42.6350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3b57CoKJJgTIbex3/8JieqVfNWRpQKbDMdnfMP1PooveHBqKUKbQFZF0Mg1qdCGaOuA/QdtuHXBFFBpGu26tanRHbwHPLPvP/eSj2xBTHV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: d-wccWmzyioyvsV-fd6nkMM8mTnTVqhB
X-Proofpoint-GUID: d-wccWmzyioyvsV-fd6nkMM8mTnTVqhB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 20 May 2021 09:31:27 +0200, Daniel Wagner wrote:

> Remove the double listed FC_FPORT_DELETING from the mask creation.
> 
> Commit 260f4aeddb48 ("scsi: scsi_transport_fc: return -EBUSY for
> deleted vport") added VC_VPORT_DELETING to the flag masks. This is not
> necessary as FC_FPORT_DEL is defined as VC_FPORT_DELETED |
> FC_FPORT_DELETING.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: scsi_transport_fc: Remove double FC_FPORT_DELETED in mask creation
      https://git.kernel.org/mkp/scsi/c/faa6c1d92cb0

-- 
Martin K. Petersen	Oracle Linux Engineering
