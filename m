Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0172EC43470
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D265A61419
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbhD2DUP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:20:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48372 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbhD2DUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 23:20:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3FrIC131223;
        Thu, 29 Apr 2021 03:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hQcOPzJvnIbQy0XsAW0gUM2Ub3x5XjnrMdywBKtqvds=;
 b=U51ntu/XLS8tE9sWsGTGFX4Nf2iIiy0Hvo7Fjnxqhu0NjThSk6hPeACq33yNaMREiwCT
 xw87GlYjULgvs31DGA/nMlmKBbGWtG9Hc9KFllVZGSPYwKofi3suqZUQ3QIK86THYVlt
 juI1BRL1Oz4xWxGFOOZi0XkSJ/jY7JVEN8GFdCMO4fAxWOHhcZ3SCaZZrHaapTp9Kusk
 CyCAkpiNKu/qPM4O4jgC7kiKvaCuFpW7AtRDxJLi5jkyyNjmJ64LAmoeQvZ0S20jxN0H
 RLNAS7j5C4xcrOe8xEU/cWYdcKZQY6op+EGhr6lBiImoG51hR4S5tX8kMfG3SutOIU7P Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 385afq2xdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Eq2s154231;
        Thu, 29 Apr 2021 03:18:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3848f0es47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5ySLrcAUX9159Fnt+sumUXlPKVRNrtBBtl4LsNsJ/hk1idHArOogV5FrZ+wljDYA3ppNgGAfpn8UAdTYevXq24+kVU/cNb5hnetO6GdjxYp1CFpEfI13ZsLgsJeOquwp3iuKM4qedm5Gvygxouk8uRMCWX93IeoixbUeBy2QmvK5YeECkWS89uPmTAYlWrQZjnUBB780N0EyOs6wY59Rto9gaqs0h115l9j1Wnb0ysaKbNOSorN3pcK2CjDPEyCo40yz/I2+W35NQdp6xrnYgYl/EYN8xkKuQA4Om+UBg0Vubnq411qilR1dER0z73k8PJNU2Bsgjb4VTO+sd+slw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQcOPzJvnIbQy0XsAW0gUM2Ub3x5XjnrMdywBKtqvds=;
 b=KqSpTHskC/softeMXjvMqnElYRCBHc0T3yTXyyTCc4vPAohKFWQ2t1KZVTvXYdo41xCQbrx/DIAfGHKV3CvwrrLapIOze3iKBvluJAmy/uLj0v/OgO0YDDtjMXkL1Fk8gqpxi4M864zpoJ+mYGkNeRkEzDy+kfNkmSFL8VnAru3rWFndreEgubDRDVCKrGTnfP6KzziIaF1hTeVOb/LYpP/E0rRvmjIbz2OQPG+e1D7kOHOlSleNG/QtmBSfqWCNS5WcNi+dW/EAcjrp5h2ACQUK9UQy8Va7uUhgYPoHsY5mofWq1z0GaQj0NHwkfZRBxezCJf8GpSvfyGatUJI/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQcOPzJvnIbQy0XsAW0gUM2Ub3x5XjnrMdywBKtqvds=;
 b=YAfCy5wDXa/BVzP1R1UmE8AKZR1Eqld0oBEKRMrllWfSgRBTHjudxLIM4vofrEaRONd4UBBoacUegMiqr1Oa2iN29fgSSdHxAkpLHhNF48rJVy4JF9dLJ+e9cpKUUO3u3PmfXTMScMUkP6TLWFJvL0iSjUoqObHy6WuDkY5dVKI=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Thu, 29 Apr
 2021 03:18:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 03:18:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Prevent PRLI in target mode
Date:   Wed, 28 Apr 2021 23:18:45 -0400
Message-Id: <161966630052.16262.12254299621550677914.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422153414.4022-1-a.kovaleva@yadro.com>
References: <20210422153414.4022-1-a.kovaleva@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 03:18:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 255e1bef-055e-426b-e0ce-08d90abd8477
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805F7940963F0F6444C15AD8E5F9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WqYkMVIrNyF8EnGdSIS9EbX5HkcjP81Azru2/rEvQmvg/dyUNDiHicnvrH1fUZ4Qm9pEGH8WHYEHt3CTUmpsP5Yqvw9qbB8uX8QCZxEQF6CXMWv/U7Lk557vWB1vdYxj/CHgM/H4uGTLDIVLc624jZ1cxnNAlpSqH43L8EDU5zsPB7FMyHLbvkO32olNnSYnF3XXzRx9mADrvjf6pG/sq8WWBvG5siKULHaHRKYwnxmIxKM2zlPJedGh3aKwBuUWf3zQr3MK/vyIfAeJ0VF6VW1YFjybLAtnqTZ8zAW+E4Nj6mP6K1cVZJawwAVcVyn12ACKt7MwVciMCspolWV8bk5q4QESrtJlBrg1zBvQCmmJTXYposwr2u1ibC0EZaRRzG1CeRGCKo9RFr1sZFy0gTan7CxWv8fYDbM0gPT2Ijy2S/XEbAoL/56VU2sMebwHmKJ4wU6fqn4lk01RiTSVHjkEvc4pXR8bgVVbXn2tMv6U0Tvx2KaHQnPPPbfc6IaLqnxhrH5lWrIpAs1fkAyKOw3Bg/9yfSLx/FMl/1Am32B3DE+uIkztdKqaZ28uvhaGAcd13cbEPMpi5SRlCyAWs/rj+Sq5z/AJ6zN31H0fMKk7uzqMTlyhIfw6g453IPg2HE28w6Zz2r1pL93oqSol/gkQ6qVJlsqsN6yFxOfrRxvotqQeY+HYAa9VBBEF+w1XZvSKwTgMVY3Trx/5sxlt7pKMnSWImeZQ4IO2MimcPsc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(366004)(376002)(26005)(36756003)(103116003)(5660300002)(4744005)(54906003)(52116002)(16526019)(186003)(7696005)(4326008)(316002)(8936002)(66476007)(66556008)(38350700002)(6666004)(38100700002)(6486002)(8676002)(2616005)(66946007)(478600001)(86362001)(966005)(2906002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZFRrTlVwSVlyQ2tZTFNHWnI1NzB5bjBWVTR5NUNGTFNzRVdCbmJ0M1RrckVQ?=
 =?utf-8?B?bTI5R3N1ZzJabkJaUHpUakRIc2c4OHZXMEo2dXorVC82RGVoMi8xR2VxaEZJ?=
 =?utf-8?B?aitYODk3MllZZGowMTNxdFRDTExXMng3Yjh0ejRva2Vma0h4VzFCcjZQanFs?=
 =?utf-8?B?Sy93U0RTU1VLK2xIZ0p2alVjSTN1aStWWlBWendicDY0Wmo1V0dXdlRjQjlx?=
 =?utf-8?B?U0xudzY0dlJjSmZrRE5pNmNKdnN3TElVWmpjUWxMbnczMUt3NUFJRWw3MXY2?=
 =?utf-8?B?OW9KaklkTlRITko3WkN2T012VFJXNENraVpDb0hPUG1RS0RseERjWGZKZk8x?=
 =?utf-8?B?cXN5RnhNREsxN2Ezd0NRclhJWjNVblo5dkI5VmlDNG9LZURRYmZPN3VZbkxi?=
 =?utf-8?B?a2pYdmg4U2c1ZzdPV2s0RmFPZk50TDZTU0RlWjZvc1JqbW1aS1RXdVlDU2V5?=
 =?utf-8?B?VlU2WDlXS3B5aXpEcDZuL29lemYxemhjUmVhWUJaQVNLMnRyMXZzVFp1SHUx?=
 =?utf-8?B?QWdXZ2NyQ2JkbGR4c1U1YXhlRWVIUytlUy9aS2puUCt6UGs5a01odTRrRkJ1?=
 =?utf-8?B?byt5L0IwVUcxOEdBZExMK09tRGw1bTFrR2VyNzVibjQzU01tTXo0SktBcjdk?=
 =?utf-8?B?Y1d4ZUhIOWxmRHpJRUlBU3F0eWQwL2hPL0dKNzZqL0xZUTB1aHVkUjFZcktX?=
 =?utf-8?B?ckE1Y1NWaG9sSDF1djEzTElCNlVrcGRDdmhvckduOFJNUlpBMjZjdklPREdj?=
 =?utf-8?B?NTIvblRUOEl6cWxGQ1NsdWFhcWErT1gyOXdZUjI3dmVmNldUWTQ3SzM5dmNF?=
 =?utf-8?B?M016N3BiSmlickpEWmJaTldKaldzdTlhL2J5TWF0SXNYdGVPdXBHOVo2ZEhz?=
 =?utf-8?B?SUJGT0trWFFSTmhSQzVHYXVSRmJSOEVENGgwaTkrUDN0MDFjc0pCeitMbUxy?=
 =?utf-8?B?SVRxcCsxeGkvRGNUdUVjbWJiUHIzdEMrNldjTGF5ZDRxUVloWFA5b1pydFBF?=
 =?utf-8?B?UFZlVnp3TS9qVWNhckVrbG5ycEMyNTFYQmxGMlZ3cDVOMHp1V3pjUVRWa1V5?=
 =?utf-8?B?MFFEOWdLWmNFL1o2Y3lKdURNOFl5YkNOZXdsUk1UUWJoWjV1OVUvb0ljTkky?=
 =?utf-8?B?U1d0Tlg5eU9DQ1YzKzhWRnFKZVBxbU9jUHJWeXJEaUxaaFdIano5MXdlaVpI?=
 =?utf-8?B?QkRkV3dnK1dwN3JmR0lWNEhjaVZaTko1YUt4T2gzd3JJTFR0OFNXd1JYallU?=
 =?utf-8?B?d21HcU9XR09NL3NWZHZBNE1MZmdJQU1zcjBSUysvTU5saG5zd2h2VFF5QmVt?=
 =?utf-8?B?VXJBNGVCdmtKOXNhR2pUd0JmK1YzejVkRzRyamo2dHpmaXlLa2JoMkxUbWw4?=
 =?utf-8?B?Lys3MDNKSko0MXVVYmJxdmxwVG52RnorVDRnNzkyRTNSeWtYc3BDQlhIRDg3?=
 =?utf-8?B?UWpzOGh6eTJ0d0pXYnd0TWYybDc4TlNISFl3dGZNdE5Cc2lMdDZEY2M3Ulh0?=
 =?utf-8?B?eVZINFdPcnB5R0hVM0dHanNjd3JJVHN3OUw4V3NnVXMvRzdDK1NHSmFVOWk4?=
 =?utf-8?B?TjNxelFJRlB0MXdneHE4SVBqVGhGNXkwNGZFLzJsdzgzcDI3a2ozNDB4S1ZS?=
 =?utf-8?B?YmswN1J6Uy9LbHRoNVZwMWU0V0ZSaVFVSm1OYVFISzhkbEMybDVEZ2lQMUNX?=
 =?utf-8?B?T0xvcFN6T1owYzdNRy96M3ZBQ2U0N1o0aXZ5bDQzWHZ4TGNKSnpkZXFPa0hP?=
 =?utf-8?Q?o7Sn3Wt3zD/Atx8YqDu00jH5EaeSP1BYSe3eQ3e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255e1bef-055e-426b-e0ce-08d90abd8477
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 03:18:53.9112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Nb1LB5/9tWnMUq9JhD6kk15Xd9a8MGrIW0eG1J6+HAE99Cqfhx5A1crrbspyVf62QJzg5jaQgTLsEThR+BQ6cqvNeohDLzObzEeCDU6Vh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
X-Proofpoint-ORIG-GUID: 1-CeyPMYn8Jbl-fh1--hEHnwn4RxVzcz
X-Proofpoint-GUID: 1-CeyPMYn8Jbl-fh1--hEHnwn4RxVzcz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1011 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 22 Apr 2021 18:34:14 +0300, Anastasia Kovaleva wrote:

> In a case when the initiator in P2P mode by some circumstances do not
> send PRLI, the target, in a case when the target port’s WWPN is less
> than initiator’s one, changes the discovery state in DSC_GNL, and when
> gnl completes, it sends PRLI to the initiator.
> 
> Usually the initiator in P2P mode always sends PRLI. We catch this issue
> on Linux stable v5.4.6 https://www.spinics.net/lists/stable/msg458515.html
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Prevent PRLI in target mode
      https://git.kernel.org/mkp/scsi/c/fcb16d9a8ecf

-- 
Martin K. Petersen	Oracle Linux Engineering
