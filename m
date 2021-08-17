Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC306C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAD9360F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhHQDSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40904 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237118AbhHQDSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:34 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3BdTj027666;
        Tue, 17 Aug 2021 03:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Mbo7L9rA+la+tI/TvsJNGLelGZoMQijvzI9DaLT3RLQ=;
 b=mSYk3WmDaN3r8a7/zGJU5EoVBoYeEUjmaoYaNv1LYkAAjDB71cNaudTJny+LEz1nZk9y
 Qeuu4rv4r4H7wjih9t6dPFYgorDuWjWrVdDPy1895FXN9CGZUljoRfcj2j2k8H6V92N0
 ZWlBc7cYelj4eATHExByObIcy9kuDPoPY0QLfFtfXCHD2nnM1cRKTUAREN0gpAaGkX6/
 G3g6awsIPMxgvyLBOZuSThVNb413P4ZpavyJbwc943DhTXgvKxwuQnfVY/6X9QtjFbUk
 TcMSxKT0OMMkQMx+uMfrZhNmyR3umj5RlRQqo6J4Sn3U5p8lJ10UsK3kgb9rByCKDe0R ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Mbo7L9rA+la+tI/TvsJNGLelGZoMQijvzI9DaLT3RLQ=;
 b=ua3ZTCOUs083dFH3cSZuZg+7qP3aVvvdwtx3EG4nXNQMXWZwpMOVI6XLgBudbmyunccl
 k0L59OgLU9rHOcyWLtCA57xZDe+/4p7yqXSfGSLqqfP8/uSZdLsCkcSu3b8mFYowSMt4
 829Q8hrfrvX2zy2yf5aTEzUcLU8oCgGbT0qYomkcRhyAS3frGp6ycYib78LzvplU6tpe
 WSE5qNuAX5y3snG3dpCJCYJpK9s5SX2Ng0kPakYyTP09dr2ziKUImwJ7Gg5TBc/M2uD2
 IRUjX5BQrxFiC7pC3g/GzM3p5YHi/+QXA5eZgGbo6OMd2tq+gDd4GX+a+KD7Hl8y28oW ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af3kxugec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AxK5038815;
        Tue, 17 Aug 2021 03:17:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3aeqktadt2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuPN7j2s7DVDP62U4skNilrLKJuHAimtGsegal2s2WN4bQQVT7VbWa7xJxAwGLq3qGm3q7ezm5/BZ4rSdwoJuczaOCLWKla0eg+TnpR2kPqB462eIjGjeof3PwGiKi7PCGCNBy9RzAuByE21UVr7a/GoAMaGPPmzy54tP+k3/Plx7tLBkcGJvGCsDbHBh4BMHQORIlXAQd525pyUfycHi4eWgL1FDz0xm0y1K5cDGgUjDoZhxllkhiA/Yu8edTjf8UbxJWO54UtdOsKDK7kXJpsphJqTpsRf+DDOkhZvueoNgjNbVQ2DnWeJIhWOYZeUj40Q6bLeSa3U5MM+nKyMPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mbo7L9rA+la+tI/TvsJNGLelGZoMQijvzI9DaLT3RLQ=;
 b=Nkr6t9PzX2LC8NUa5DyJWsdVjELFeO3/Cr102aCn50OD47wNmkJctOX2z11MkvZ7xXEDXvEKnV3oY5DXgw6JYMKFgRo29mVqfNdHUzNNJ/6YDvSuY3jJoOGtGvNYOXdGBcTwWbuvng7sI5+CQfkLwkoHmuvj62hsByGl56hNAW2ewM32l7Vc7f+XaUz8WYvWaLpVZw8d15WwprBQft4rXszcoM3fbszct285ohsgmqqT6XCZY31uv8P/retm5iT718P6SvjPVtBiN3EatJiaUpzFwXjUduVQIFE98s00PNQsrgsp2uwMdPEOQ93GmB3chqqb32IIoQedlJrsA52q2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mbo7L9rA+la+tI/TvsJNGLelGZoMQijvzI9DaLT3RLQ=;
 b=QCCocboHHeO4mUXQ5z4pQ/37OL2sKJKAKPbqsu04T89ESDhU8ftKSLJyssF5eQ3CUxIm1hxG5xfCC9iqbYtBCAvepf11t1sNOG04OfKxMx/Rnyl7hbCpEA+iZ1ykNglhqZlc561x72PeJR3RshQMFIIn7T0uXJpzAVA1wrwyIdo=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:17:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Shai Malin <smalin@marvell.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>, malin1024@gmail.com,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2] scsi: qedi: Add support for fastpath doorvell recovery
Date:   Mon, 16 Aug 2021 23:17:42 -0400
Message-Id: <162916990043.4875.652959850039918777.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804221412.5048-1-smalin@marvell.com>
References: <20210804221412.5048-1-smalin@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 077e2e6e-78e9-47fa-6d1b-08d9612d9bd7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45970082DC6AF17CAB198D958EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vckiYPW1Rco4fTtnzHmxNot2+KdFHWAAC9glt6VlKnEDjO28LiOq69yhnUueowQqD64B7F8lBJluvvGiL1d0im5nZXDaQ5j1hY2Ar3dsuFCOzKInu51b7ilXaHaep9ylSp5ApgAS6+otVKZHWKotO0vAqXhL9osRaqlgqTyCN4EqxLgdOpaNkPSVW+DOeMMSf3E2eaGenPKj/PuTFsV+eqQhVGOZZLJX9SYgwSChesCBKmIu+BZK+ru7CXCfYkUo8JJUUDemf8+PfjV0/X4VXQ9A1GNBwi3ayDbmFdqWivC6at7dUakHL/QytihMix5RMx1IZvyuZBbGbRv98+nIyU/4RI4tOdA3ewKcKKE/oHerkOjlSj9rLW1qKkhQWOHOjsBdm+Kn56M15MK9JNvYvFNffBcW4hWsVv59yNRTnwgfqZwysviyg8nYvNqqvYUnOSYUbyzr71m6ZWbXeqGN7pqCvC71RwqKIr0NiLUash+cJDEXhCdYKj99m1oncYY5ZGHf0N7H7Jn+bxxK/8ZPqPZr4cKvfklvJGFpbP/P9Mmvq+Iqd6GqcncaV9yw6U+q1cLyQotwOHis3MeGo4+3smy6JNC1hv91q0nyBzFzjrJ6rtZQHHdZzC1MYWvqmt23JBLgvbJw0+R9Z7gtMtgmnIR6El5RKssfgEsAVE8Ucj2fy46wwTR05NSUgZNcbe7SdQxH1uq3isx/HYLrOS1dVJMNNhXU+yiaZ8u1GV8s3hiVjTM8vnzWdDI1SOrlSpznyJiP6RsyB2muvRiBjbTphzUwdWYWzQ/xiRZfU7faLWQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(36756003)(38350700002)(38100700002)(4744005)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(83380400001)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0wzM0JRRXVjdHl1YU1oQWZ3eG9vWDU4WTFVZUI4MlhGdSs3bmowQkVYaVdj?=
 =?utf-8?B?ZkZ2QWIwZjVmUFBhWTIvdnlHc2Q2b0ZVSXM3LzlSc2tqQ0EwU0ZHTEZ5Q0pz?=
 =?utf-8?B?azJqUTN3R1p1RlpBa3hIeGRQQm1jTWFTamRwTDF6WnptSzRtSlE0L3d1MFk3?=
 =?utf-8?B?WE5ZMkxtSWJRRFF3OWdQNEFzNTVjSWRYK0lIYmNLRVRLcFdsWjEwYkFQRzhE?=
 =?utf-8?B?bzhKc2kydXhDRlNNeTZUeGQwbTFqaFlVOWphaWNiU1hzdzJLdHZsalRiTUtj?=
 =?utf-8?B?eUlJZTNzaVdNVitjUWgvRXByUDhERC9WTHBKK240TkgyUXlKSFBlUDBZcjF2?=
 =?utf-8?B?NWFYVkgwaWRFOXk3ays1KzNSMElhOE9TN0VNTFpQMzhEVTk1WE9veGMrQjgr?=
 =?utf-8?B?VE9ZeGV1VEVubVFCeDUzc1JUclhYUFdGN0R3Uk5RVW9tYmMyODFPS1R0Q2E4?=
 =?utf-8?B?bnFhYXoxci9HakVCZTZPYnhzRnFKc3hPdGJ1WkdtN2Z3dTBWUjdjTnk2QnRi?=
 =?utf-8?B?Um9BZFUwc1RkM1o1d2p3dXA0VFpua2xJbHQzQm9rdWdGU0cxUExNdXdKd3Fy?=
 =?utf-8?B?U1djSzVjaTBlYW5ISnkwMXpRTW5MQXE4M1d6a2EyeGhLaDlDUWN4U09RK3py?=
 =?utf-8?B?eElhNlBjbkdBYk84VHhySk94cVNMK0UyWllJeHZHa2lYVGZPN1ZrTkNCNW41?=
 =?utf-8?B?V3RaMS9FRDRJaFdnc3NHK3dJUmN5cUZwNXV1VWZuQUpYbCtSRStVQzJVekRr?=
 =?utf-8?B?ekU0RXZHcnlWT0RVSXlpN3ZPdzlYcERBc3N1Y25hS1hSY0hkOU1oTG5hWHdp?=
 =?utf-8?B?VGxMdTdWOFlyVmt4ekVTS2ZRQTlDaVBkb2hiM3ZuditPalpjOTc1cFUzRGtY?=
 =?utf-8?B?aGpDMDJ1UTNGakJOZHE4UCtVVkZrbjFoeXRyb1p2R3pMaWI4TkdLbURDNmc3?=
 =?utf-8?B?cmY5YkNFS1hSZSs0UDBDZU93YkRHd3Jsc1JlRXhvQXZmZUx2bm1FKzlOUWlQ?=
 =?utf-8?B?UllRcktrR3JxWmVXaTdrWkh6Wk1qc2xSQkw5ckpWU1pBT2h1WnRwUCtLSnM3?=
 =?utf-8?B?Y21DTENWZHNCd01oR2FhM2l0a1lRWlZjVkxwNk51YlJQQlNid3RRZjdWZm1N?=
 =?utf-8?B?VUlJZ3h5RkNuYldMTk5sRERSN3BPeUg4cnoxRC95eVl5SzhzRVhxQlFudjBy?=
 =?utf-8?B?aDVCY3JaZmlpZE5nUks1TEFxd3RET1VKdEZZUGRzc3ExYnR3SDlxQmtOUE0r?=
 =?utf-8?B?QVUrQ255MHZWZm9nR2U1eEI2SU9uVWpSTkJ0VXlzQi9yUDRramFoZGZrcmRs?=
 =?utf-8?B?UVdtL3dpN2I1YUxlZzYrbEczTFZza3pKR2RUMXlBMlVTTG9ZeTVHN0xHei9k?=
 =?utf-8?B?OG5TYjA2aER2WDVXekl4bzlBV2t4aEpEVlVVZEFRdENGT0VZTzAvRzAxK29M?=
 =?utf-8?B?NWRDR2RwNU41eUpGUGFyd0FuWGVvTVFlcUhLcHViNkh1MkhiVWdlOGVkRzBD?=
 =?utf-8?B?LzNpWlBuUmliRytSeGtTYkIrMk5JVHVFbFZjcjlCNnIwbngrUUZydlI0bWE1?=
 =?utf-8?B?cS84QkFGUWhoeWpyOXRZTjFqbFREZWg4Z0NiN1dXbCtXcjF6ZjlhdStzcDN1?=
 =?utf-8?B?UjlzdzRzYVpqcmNuR0l3OTNHd3hwN3BGMSszQ2llUFVHckZuVHprUHprdmNK?=
 =?utf-8?B?bXdhYkxNYW1DUlFiQWM2WkNOWnI4NnBmRG9taldMK1JFanZDR2pZOHUrdWtq?=
 =?utf-8?Q?0NHrimqHzMVIWIH15/AqSIWEKKuuQL5Thqk5vKt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077e2e6e-78e9-47fa-6d1b-08d9612d9bd7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:56.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lkQe0Odsr1Y0kmuPM7nNXQZvujF9KGOQx4iLmkJBdorpb1kTHgAsl7BxOiqyF8Bbaaij3rq3JnNx+ooyjMtbz2PkTusk7PseLhxsU68y1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: dcuU-PHIJ0N_OVleb9yDFrgOqkarXrx9
X-Proofpoint-ORIG-GUID: dcuU-PHIJ0N_OVleb9yDFrgOqkarXrx9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 5 Aug 2021 01:14:12 +0300, Shai Malin wrote:

> Driver fastpath employs doorbells to indicate to the device that work
> is available. Each doorbell translates to a message sent to the device
> over the pci. These messages are queued by the doorbell queue HW block,
> and handled by the HW.
> If a sufficient amount of CPU cores are sending messages at a sufficient
> rate, the queue can overflow, and messages can be dropped. There are
> many entities in the driver which can send doorbell messages.
> When overflow happens, a fatal HW attention is indicated, and the
> Doorbell HW block stops accepting new doorbell messages until recovery
> procedure is done.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: qedi: Add support for fastpath doorvell recovery
      https://git.kernel.org/mkp/scsi/c/9757f8af0442

-- 
Martin K. Petersen	Oracle Linux Engineering
