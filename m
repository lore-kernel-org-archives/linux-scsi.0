Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA19C433EA
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE30619C5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhC3Dzu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhC3DzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iQN8084661;
        Tue, 30 Mar 2021 03:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=C3CzF5L/78A72azLBwbOpjXBjciVJpzY8dnvuL89h7Q=;
 b=rpv+j+90z80mNFkR9Fn6V9cFd42t2ykADh4SwKZCpe9raoUP5L/NWD6bjutQmcMBx3yD
 rpDIKu6YSZLOD7HD1GsNbZwBUa/zBVIxI5b82qdvWMe3zLpCaB24xhpXyCBk0b3HrwDV
 hAy2EeJggCQMTwFCYcuOfkAXFaKYr5KGWh5QydbgQ9RsSHKngRUyQr+QaRTfefsKzcZ8
 eSwEQG0W27sXXJZ3Ql0Jtqxgss95di6vRGANJpdM7SY3VeAndnUNI8P44QkrnPweQZxG
 hweCQaprW6jnHNFtUyYEbgWWnUVJ0rtJyjvEl9NNMw9ubq4mLshZdf45Uc/rrtDMSXNj 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37hwbndj68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3ikro193044;
        Tue, 30 Mar 2021 03:55:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3020.oracle.com with ESMTP id 37jekxyv8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhdxtDjZ8HYxKeNIRSxYtpyjjuAenu3TDb3abs3QnREq0X7QzkQw8J56gkvfld5lJ+3PbLzM0hLDCza7/cYyOS1dt0HeQyaW/IN9ep/TIug1CObLsU6TGhcVTOVG8jzsfkLkUHDJ7thKz9DczOLI7xsUnLo/zbtN3bKhphRMES/rUOEkDONJgx3HtVwfNmvnSKrOn7SsgtWW7/AYrrNH61boVlGOzdztocUrY+2ONsjE2xXq7XpuF2h7VtHC4rYYwyCtwK3uglOURWnS+u/za0B1hn8+tplrbnsz0KadpqXQPq9Qsn+hxdb4dpyHeZlkf2d/ec5S1zBZDXBZgY9KXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3CzF5L/78A72azLBwbOpjXBjciVJpzY8dnvuL89h7Q=;
 b=en0uUXPdQlDAHrUxhZKOR7FibH5Ok4ScHw3Pq7Ofi+CFe1CwteagDe+hpmU6iuMU0P3TVjn68tyYJhHdnjt7rr7ZjNqIrv04Z7kKSw9jREsLJx47igB0NqP3alct3M+t9Ul4mb7OKh1QpK4xZbQev9Z1fBSqsZRSpLPyP+9F/AhpphBFhiijVRwVkH+NcJMHTySnKmyS9lyfsnYDPuSg/uNwcn/cDdfkhVHjo0zW/zZe8wstoCXimnwbi66Qra8X3DhucoAgO8LN5jlez+RgOR+LEisARIgyEZktIM4KT9Wi47m0hriI/OhP8jvbqbX3L8/W7p6woFd99JYYsjr5ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3CzF5L/78A72azLBwbOpjXBjciVJpzY8dnvuL89h7Q=;
 b=rkSHLOf4GP6oyn+Hx9UkayGjKVeJKSre2LaOw4nWeeYGbGIY9p/2EWLtfCowlItBEq7GMDg+pTUwtr0Aj2cIRcIwYra5gLwF9HoHrGQVurNDahjwvrnPxIMCrBGJ0TsGDf4MoIU2JMDOoSGWXfL1bt/3Ik3X+fYkNrlHLlPUPx8=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: esp_scsi: Trivial typo fixes
Date:   Mon, 29 Mar 2021 23:54:42 -0400
Message-Id: <161707636883.29267.3779400672515804033.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324061318.5744-1-unixbhaskar@gmail.com>
References: <20210324061318.5744-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5da93382-89dd-407e-a92d-08d8f32f9cf4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758572458D6EAB58E1A51BA8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUcTgyXajqso7NoCJLHBZkRzOVFneTS9rNGaQ06CKaSG5CSpQdySgCKaLWlgPkNoD2P8OvuSwipUVIGGv8uEstnT2UzxxZrH1FVCULhwO4zommPTg24V1TaZjYNT+GYuQZn7/7OLtgjVIUSZk0SZF6CJfWU9FSCTUxBib72+1e9Z7s037p4oa0GW5i23szFAdwVXFOgJUXkZQ2aPAleXT5DJI3d6VZ6UWFRq4LxQb0empZA8sGXMeQ4fSa7Uh1T8Ir66LuRGiD6BLFfXYGa0iOT63Oq71Nrs5S6M/cRsI2i+fTw9Dw0WoHSycJumERN3ZqN1YqCpQprWHxyO2ME+eGzoEVWU48lmfK0mPMrkBW7D1TWTOtUzQJxdToRhKNDA5WSnzxfS9w2WKLRlmr531JXYhrJPUxzKdDuIDyATc5Lv1ruz/cBGigksO+W3dbv0ACa2lGxwk36M3xXbEUo6ZvbJN+Sm/kmPlfTL8ZMr/ldGD1v7VfmAlVDgEwee6khzEhpTob+kMfGHqiwGcrf27ykhdBm9M8ucn1PdkrT/vE9famK95Jcgdc4MY4C5hrkXY8Qb6K+j1rAoKBr3Enug+ScdWCoKY9mrLdNT1X8yytI5VD7VDSJlUIEFLKaciiI0TBFI40eU0EXEjyvZIfH+0t0A+hNXJ9qp9isEGJNS7y4eJw6+cikVX9CiIIlnzGlJ9NZVaYHCKNN6jvfJT/4fKBNMr2JJjajJhdIy1K/By1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(6916009)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NG0yQjdNRlpaR09xQjYyUGN3cWVaTE01SjlIRkF3bDJDQ3doNGFwMHdpSmgr?=
 =?utf-8?B?SzUwQjZRN3h3aUdwYXptZll5NVI4eFAzMWM5dkdiZXA1T2NZTGRHSmJ4R1lV?=
 =?utf-8?B?T0FIY3RoQWtzOXZEWHVPUG9qdmpseXNDSVgzTy9JeXI4czlkMmpVYnRjOFR6?=
 =?utf-8?B?eml1d3RCYzBiUUozVXQvYjRYWXhJU2tobWp4eWtRZFN3TTJQbGM4WExyanBu?=
 =?utf-8?B?MnZpWWNQYm9ITDdId3RJK1pnSGw3Q2Y1cWw0SkZ0RmF1ZzlTYUtBVTFwTEtk?=
 =?utf-8?B?NUtwRVowSDBZUUpPcGE3NU00czdXakpKMklpR3I0SnZUK0k0UmJxWXUyUFcz?=
 =?utf-8?B?WTVwQ2V1aEVmeWcybk1HR1kyaG1PajhnR09UbTFIUnhEM0xSTU51REdKc0Rp?=
 =?utf-8?B?dGt5dG9DOG1BMFJYc2QvNmxiN1NGd0xYd3lDZmRSY1ZGK29QZ01QSjM2cnBt?=
 =?utf-8?B?NW8zdEVFa3cyc3NUR0ZJc0FDQW5YMmlMc1FncnpOeGhQc0ljZ21OT2pucWdh?=
 =?utf-8?B?d0FQWVhpR0VxMTVpMUZEcmI1VkFidXlGdlNQV2w1NUd4MXRNaCtGbjU5QnR5?=
 =?utf-8?B?WS9EZUVPclBoR0hiU2tUUTRUY3JpTS9JZ2x1ZlZxMjYwRnFhTUhRT1lKbW1O?=
 =?utf-8?B?ZVh3TXNjNHRmUEpDOGxadThjbnRIa0NuUWNjTURlWjJBTHc5Q2p1YnFVYURX?=
 =?utf-8?B?MGVxS3JtZ2VDcTAvRFBzek4zdjVxVDNJaTJFcjV5V1pHcC9wZFVUTll5eUd1?=
 =?utf-8?B?VG9TL2R3RWp2ZUF6N0xvL0d2WERVRmsxa3gvcSt4S1MrUVE4bUhtWlRtQkJk?=
 =?utf-8?B?bFhrY0huTVlNOWxsWTJSU0JlVC9NdjlzS2JCOWxuQlc0QWtXQmNjTzR1WldW?=
 =?utf-8?B?T1pBMXVFeUw5VUNLenJnWExNcGM4bUQ2M3ZXTUF5emwwY1JiZzluVm9FQmVL?=
 =?utf-8?B?UVdrSjY4Q3lka2hCN1JjbVM0RkhkNzBCaVZOSnc4UVZsbUhLRjNMSVlvc2pu?=
 =?utf-8?B?dy9yaGVJNjhTVjN5aVVBWnUzbVdHUW82MkdHMWs3KzlTYVdzdnVJZVhlUlhY?=
 =?utf-8?B?ZEhEWWZ0b1ZxN2R4N2Q4OTNYWDloKy9xcWtBbjVKNFBoV3BzQm93eXRSL3J0?=
 =?utf-8?B?UUJOQjQzeDJqeDRWcTVzY2hrbG50Wmt3WitVcWhCTjJSNThNeTVUaWpNY3BH?=
 =?utf-8?B?czhYYUpmVm9xZ0h4N1lpT1hqMEdRaW03UVBxbHR1aUsxK2Z6MmZ4Vk9YZ1FO?=
 =?utf-8?B?WjM4OXdPL2NacjdidkFJcmUvZTJ1dngwY1BONW9IdnpvMUdCcFpFY2cxWU5E?=
 =?utf-8?B?Rk1qMGg0ZHhlSVkwWnVJekpUejN6emIxU1Qrb1UrTHdSd21YUkNIalA5Zkov?=
 =?utf-8?B?SzBFdDgzVUtYWFl1Yncvck5iL09YaWNUclhGSm91c0psRUhiU2VDKyt1NFA1?=
 =?utf-8?B?eURJdEFkQTNwNXdaSWVrMHcyTHdDTjVRNmxDMFNUSnI1Z205Ui9vcWl2TjVl?=
 =?utf-8?B?NGY5OE92QU5ydjhJUlBJOENGWkw4NHBrNXJoRzkrTHEwQ3J3UWZHR3Y0L0ls?=
 =?utf-8?B?cFhnV0tMV0N2VStnWjZvbFV6cHRIS3paak8yWTlTRlJ0MmExMWF3WVMyUFJ3?=
 =?utf-8?B?QUpKVkdCVFpSVElyQVh5cTl6U1BzYTIzMVg4dkcrT0k0aEQycmlHZlhRZ2Zi?=
 =?utf-8?B?VUpLTU84bmZpRlovRnFONVYzakk4YUFjZjlRamN2SW9HbDgrQ2gyYmRHdms3?=
 =?utf-8?Q?to0v6l389tDQhQP7amnwb+MIVtuW+oqySGTH1AA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da93382-89dd-407e-a92d-08d8f32f9cf4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:09.7427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vo7fhDUBIWfyaRx4c/spSn3BXDWndH1ei3kzAYaO9wxyu9b8yYNFV6HnA5LqfZ387xNLR+2XNrAzOTV7LM/tiE8tB0JlxTuxOrXguN9AjVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-GUID: MRIXCwiZrm3qvFPJiJXG1NkrNIZ2wNWL
X-Proofpoint-ORIG-GUID: MRIXCwiZrm3qvFPJiJXG1NkrNIZ2wNWL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Mar 2021 11:43:18 +0530, Bhaskar Chowdhury wrote:

> s/conditon/condition/
> s/pecularity/peculiarity/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: esp_scsi: Trivial typo fixes
      https://git.kernel.org/mkp/scsi/c/835b8c16a0e3

-- 
Martin K. Petersen	Oracle Linux Engineering
