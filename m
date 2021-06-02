Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D075FC47092
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE016139A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFBFrP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:47:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhFBFrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 01:47:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525fSMi176997;
        Wed, 2 Jun 2021 05:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YEgLoVZiDMyWUDzWR9k+IpuTpeD+bq9ZMF980iZiKw8=;
 b=IfhD1wkJ2Ot35mf9KFO1M5BoE8MJzW56Wl+1RxZizZiT3vAkr0WuFt/HjzraHJ7PDSD7
 x1RCUBqoj+JsVGQDNBkOWyahkCph6JUDjksbXOtZU50WbQVfR38vWHZ51G19bLkpZ7dz
 bJZsPtbepaiyGhskBcd929yS/5xAJm4hYRv4Y5nAbUqfKRktdrotaPHvCrp27wjOeoGp
 8QI0RXT1QeYz6iH6iNJyeSp04d2GhNpUPLPvv3jXDiQ1Cplm93ltZLbpWxObag/8diF5
 E6I2d3m2Nz8SQ9b3HjlBFllqaP1hbFYzX0e0Bb2Qs8zwJ6GJvMvmObUdL/cROMy9vB+q aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38ub4cqf67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525duMN017974;
        Wed, 2 Jun 2021 05:45:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3030.oracle.com with ESMTP id 38uaqwxt38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGxECWOsBWXSS7vHjrRmMaqsxU/hjCW3uJrV/IqmpP2IxFBQvt+q+vpykh1g5ZSMfKgmGeH0nyUl5OL0GtB1Kf89H8FpEP1KayHxJL68vFWPKPSm3iP/tc2HF0r7TgSdppTKqHWMFS2k0OdKreDgCpFzxliC29NYpmBsvy7eWV3ix32yEJh89kvG9SY9oZwfQhqJYDDAHq/jmKIJaTpt/EavmSeWJLRzqp1S9NlwmqyODdx1MOtrXXWduWhuDxm4lQZv1eXpO0CNWxKzkGWDPUlxq1lz6RHp9ggX6T+CRuUUAYYUuzjVvGjtxaz91Cbidc/PlDXSRXJZhbVOTn2XYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEgLoVZiDMyWUDzWR9k+IpuTpeD+bq9ZMF980iZiKw8=;
 b=kblE9l4XxeIKp3gm0keLjkq1fd83hxCcJIof/Itvv002zJVRogNrGaUf6VafB1HhUSKmak8F8Pbd0qimdHI89VT0uHO38VXXyZEUFu8uH+pIdzA4tBQdrcz4qkxakMuPrC9jHQajDnDXEpUSp3VqPtKCc/gEcBA+DkFev9LfVqOhYTH+JVXdSzpcJAwcceZF5mGMMrqbCXDpRvuHxt8QVYOXhkiWpAtA7Ny1w9VKz8j5orAldOPbDrR/wWiK/+Cgve8bleJRwQtWPpIwY6BQ52lfjpZ5maNlMhkkmrVt60376si3+oaTdkK+thuWG2sf8g7ROrd9qF7XHfShZ8cKTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEgLoVZiDMyWUDzWR9k+IpuTpeD+bq9ZMF980iZiKw8=;
 b=ZBACAoiQMKzGGhoH0VY+jbNF1+gCnIVzkcDmX4aQhOo7NJl4rO8hwBeFRhD46UjjJYLiTTfvAGfeA4Pv8xK5UZx+Rciw3eLPXIrJ7pijVNWlpsGBVuvPx64zTg8RLFLI+m06cTIkyl9/EkOocfybmebOnLUtfrNOc2hOURwvPKw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 05:45:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:45:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        linux-kernel@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] scsi: qedf: Do not put host in qedf_vport_create unconditionally
Date:   Wed,  2 Jun 2021 01:45:17 -0400
Message-Id: <162261189570.29465.14318319080580101955.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521143440.84816-1-dwagner@suse.de>
References: <20210521143440.84816-1-dwagner@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0033.namprd13.prod.outlook.com (2603:10b6:806:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend Transport; Wed, 2 Jun 2021 05:45:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77eb136b-1c97-428d-2d41-08d925899eae
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4694EA15A34343B402EC34EA8E3D9@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/GzYi3/9q6jtZpzXxNmzwOq9fUr/Er2q5tyvCH08EO2Odw+z4LqMIEqhKs9h1I1O+ZdAa6db5JPZZ0fZxEsRrriYHiKH2F9WLsdDhwgVNQMA8pasaWeRan26PKn1QB7xejgOYSXDNMaVVDC0EBJuphjabil7+x6j10wEXglsnvk9e0XyfQjM1AoeVmZkUVrL0/yuEFSzfdW0SNXbrC+1qcnrNavw6Nuy7buOfscBrBNAl1vzNoyQj05atbzqndIoCLyA+xmt3goOM6w/xY7XlFQt3x9TjbQ4BXAwWZzPjl+9PErP7C+BKp8/EetoEjt3g7ZIvFKLWMa54uLelyNBDp2GXCDNX7bqCMyHBxJIaj00E/qCHMqQzDYtCAzWGM+vuLS343YMdVAhWDlq1CC8vsZ1n8jUtEzF928CMKccUHxUodLK8zoxlWFj4DmMf3h/iad9qcSUO+/PMssD14ViCAIZPZ4K6jjO2XO7yq/0dXQr5fpmblBQ8/8j1V+eBSNJwx1BqOuCpc8aXWUzjQtaO79kpR6LLVsWQpwbSJlq25xPq6I5YoZrV1baWnEEhlPuAd20KqvStZBaWbmmLtv5/1SHFvNO/ybds7tkFJ0ra4pNwYsUQf3+llPC0RSZ6EaaxDZ8Fw/qlhBz4LrLoMf4/KHHX/bJKhYumosBO+sFOUoQzysxpFmcayaqY3BQX4rpsL4UeQicso2LoHQq70tObMWyC2Cqu9+5r4ieSR33BrTpu/WSI6EfxoSRVMPc/1aMcfRhtop3FbmUJTxnXal0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(346002)(136003)(103116003)(66476007)(2906002)(6916009)(6666004)(86362001)(7696005)(52116002)(4744005)(66946007)(66556008)(5660300002)(36756003)(26005)(16526019)(6486002)(186003)(38350700002)(38100700002)(54906003)(316002)(2616005)(956004)(478600001)(966005)(4326008)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b1FGU0RVUHZza1dwOHhRVGNEc2ZSTExtMk1GWjdSTnJCSDE2bjMrUXJ6NXdI?=
 =?utf-8?B?d1ZDUkFCZ3lqa1NJQXF3aFJKWnpycDloMGlLR3IrazMycktFV1R0YllpcDIx?=
 =?utf-8?B?a3NLZEkxM3pzZDZaWVR0VzRlTDJndW5jbEtKeW1FMFVQZmoyMmRVVUV0Qk1B?=
 =?utf-8?B?QmJodFRaeGtHUG01cStmeG1tZ2JsajcyeklmMW9jbmlJMFdIdzhoSmNoM2t5?=
 =?utf-8?B?YUc5OTFLTDlFeVpvL0hONm9WaVhBQnBQNlJpRUpZalRnMGx6SmxHNkZVeE85?=
 =?utf-8?B?KzFrZTF5cExpMXV4NTlDcERsTUNqOVVFc3RrQy9hQ00wdWpsNXJVYlYyZnpQ?=
 =?utf-8?B?WUU5elpUcWJVLzRXYWcwMDdBZ2pTWFFiSlpQWlNLcEdteDhDNnZuUjRraDRF?=
 =?utf-8?B?UFRLeG5UMVgyMUZqUVJQRXZKYVE0T2dRZlRBSEd3RTlEdGxlZEdtV2NwTll4?=
 =?utf-8?B?TWowQUFXUDBpOFFNTEpzZ1F2MkhLVTJCbGU4UkxkTC9YQTd2WjNEQlgyOUI5?=
 =?utf-8?B?dVp6TUUvM2ZocWJHTThrTjZSU2Nndlo1aWw3eWFqMjc1OExjTEp4dWpVRVY2?=
 =?utf-8?B?K2VoVXh0YlR3SitCdVV2WUU5Y0tobkJXZWV6dHdPNFlBQTFOU2pMMWNaVGVr?=
 =?utf-8?B?djl5NXkvbjFLdU5FN0swQmlVcjF6eWtVbmxlcGQ4RCtoQWg0aEkrekpJaXJK?=
 =?utf-8?B?cXhhM2VsK1VJRjhHQmJvR3Mrem5pN3ZRTm5SSk5ZZ2c0R1pUbTlabVlibTdz?=
 =?utf-8?B?U0JBeVBJdXFweGw0WGlhTkdqZmhUcGVGTEJ4ZWpIdFB1dEh2YW9KdzJEV0tV?=
 =?utf-8?B?K09KWFVpZW9pOGZZVzZHdkNrc2NHYUlPOTRqbDZJVkdrZzQxVStsb1krQXF5?=
 =?utf-8?B?b2pFUW0xTndKMVlsM2kwcWdRWTF1MFZwbERYRklCbkZSTFcxZTdyUWpQVmxa?=
 =?utf-8?B?UFZhQWY1UE5YZ2xwMlRqTlowMitqN0xwSEgzZVV5alJkUzNJZjYrL0ZoRWFt?=
 =?utf-8?B?ckw2aEJWSDRjSUtHZCs2aWtkVGM4Y1BnN0t5RXlBUVR4bktqWGltYmZyUnlj?=
 =?utf-8?B?SEhlbHdvdG1vMUxzUFRtRW1DTzdxL3cwSU1YUWtqbFpyNFlIVlBLNDFPekM5?=
 =?utf-8?B?eFRZcm9EZnkzN2cwaDI4TlptbWpBanRQU0dHRHF6RjVYVVBHWHo3Zm9PS21u?=
 =?utf-8?B?RjRCMHQ1VXBic3M0L2p5ZFRqZDhpTFhNZkVUYnF4Ylk0aTUraCtXRlJSYzBH?=
 =?utf-8?B?YnAvTW5xRVc2ZHRpNnkybGVjUnptNnZlMDJWUWh1ZkVxeHo2bDhvZWwrVjlF?=
 =?utf-8?B?bmxYbXMveWprbzZvTHhsQzl1Tzd1Yk9ZcEo5Y2lPb09IVTJuU0NrS1REZ0dU?=
 =?utf-8?B?VXZUL1ZramxlRFB2Qld6R0FoY2ZoU3JhSnhDK0lDUlY0amV1R05MVFNlNFVi?=
 =?utf-8?B?ZnZ5QWhjdW02R3crTXo1ZVZMNFZwa1ZnR29URWRqUzZvYXFTYWNpeFJtZzJr?=
 =?utf-8?B?VGI5Tlp3WUxYZWpFOEV6TElEa0RCS1ZrQ2lBRW9ndUV0ZHJoL1BNazJ2aElT?=
 =?utf-8?B?RFQ5TDJtb2lreTlFQ04rRG1rN1piT0d4Nk5zelZnTmtRODJwMVYxVWtxYUZl?=
 =?utf-8?B?NEM0UVZ6ZGtaN3hNV3NjbEswS1o0WGhjNzMvZXMzcFRsQjN2RXczdExqbU1J?=
 =?utf-8?B?LzRGaS9GUW5XcFBGT3krNFhuZjhIeDd6UVJsamZFTmhEU0tyNkx2V1FMZmgr?=
 =?utf-8?Q?q1FPY+i9ez6cTrcsK3gdNg++F2bzG4OvZobSCVT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77eb136b-1c97-428d-2d41-08d925899eae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:45:25.4609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XeHhPE79v+7phbyo2puNqrSqZ228rocmtaefEnxZnYNJ/4Z0CDKD/I/ZBSkAPIIWGKwUThDX+sg6Qg1qSlWtjHRGYlqybBdruHEZayWSf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=840 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020036
X-Proofpoint-GUID: WvzYdPQc7FbDkPqZ5vc5yNETLjLhi87i
X-Proofpoint-ORIG-GUID: WvzYdPQc7FbDkPqZ5vc5yNETLjLhi87i
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020036
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 May 2021 16:34:40 +0200, Daniel Wagner wrote:

> Do not drop reference count on vn_port->host in qedf_vport_create()
> unconditionally. Instead drop the reference count in
> qedf_vport_destroy().

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: qedf: Do not put host in qedf_vport_create unconditionally
      https://git.kernel.org/mkp/scsi/c/79c932cd6af9

-- 
Martin K. Petersen	Oracle Linux Engineering
