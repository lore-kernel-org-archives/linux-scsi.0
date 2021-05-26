Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E208C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1C261437
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhEZEJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52968 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231947AbhEZEJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 May 2021 00:09:23 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q47HYo031389;
        Wed, 26 May 2021 04:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+6dsg+8OFULD2rwZjSPfIqn50Hr8fMFLB6qEwKuFPm4=;
 b=yaZYX6uyTSgr3b3Ulli9o0IYFitsMRg6GLJBbQWmBNHlWHl0dTMyrqaiUgi3UwwQpXv0
 ce2m4PJalx+lbi7HIU/w8jHk3/l9ux/2hBLlWqs2OaZpnK1A1/XTC+0BgkhlYCzWGnn6
 z9qRk3gSlFjG1Nr3xklpF33aCm3vuekteKckbIbPx6njC6eQdxTigCc5rTARS0vkaB+2
 kySpccUGMk4sWa3WVREzdiES8PtstqGjhcWM5UEsV3zohY5Ut3M8SWYe2Vh//66MiIV+
 GBUvRvdGW2dLnq7zEL+EQd9Yaf2yuWmjB3NhuqiJIqc4DEyfAK+7r83PhILBDe4501tw hQ== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38qysc0xe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:51 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14Q47oG4145227;
        Wed, 26 May 2021 04:07:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 38pq2uvw7d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIR2Q5cVYOEAOmfz3Y3E5+Hl00c/lKg/wigc6OXUIEQy2ZlHzvF9KzWNVUl8W1kgS84QwhIa+cVUp9LS7QQSYt5lhBNJHQyecZWIDAZHYcLjnPY8rO2KhSFZDswkQR7PAlTNS7r5anpDAQRPm6lV+HjJJo2Tw06hmu+LVd3v+9bmRTW4uflbqTYw8lCixBSaT2/WATiKWf0ARYwy5Z4RBBsllG4BswMEwdcbS/Y4FjnO2gYAlHbCRN1JqzivJVUVUFVxkhQBByQRfqIJT9iMNPbSUUhR0F8oAKo0WUxN9S6UFCtKQ08SwHjUnK4HV+U9cm1QMrsc+4bXS5qltYVNCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6dsg+8OFULD2rwZjSPfIqn50Hr8fMFLB6qEwKuFPm4=;
 b=JfBjwgb04m9AGr6utWuXsCO/uuwYguPwT1X+/et4WjLWspLFZec5i4NYRfEWcythdjrECUV3UHISIZ15E+INtiGiCsYrVFCR2O8+EEV1wEpnNQQJQEuP5ORHvn9LrQ3+jzEzLBssme4brsqUIstk1Dv3mV4eE+cpfi1pZdhFkluvFF2nYTJstHS9DoahOiXZIeJZ30lFr1HuchYPoQ6NEJMrUDVAqNYuDYjfsR+aV4tgPbdxD+c0PRRMOw2oNZlFWhDGGNk7u5vKs+WWEMLUAkVlvB6YcHdhodgSpBswxlUX6CjhlaFvQ3QggbY6NOJaHEuhXh7hYbHh906TNGUtJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6dsg+8OFULD2rwZjSPfIqn50Hr8fMFLB6qEwKuFPm4=;
 b=CgxHL2Vq8q8fABz8NkAE0LGry291PV0l+FB0JsvrFhwno6Q07UrF6Xcm0tPK3ajE9vA0xd5gr9p4qcSEK6mr1YkXEtnxjFPchUNVDkKTCDxY3diaBn3j20TSbneTSjkcXnpQEdbCfpD3qnNV5X/ak1MNYJ//x0RJ56yVs7PcYME=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] lpfc: Update lpfc to revision 12.8.0.10
Date:   Wed, 26 May 2021 00:07:25 -0400
Message-Id: <162200196244.11962.12872180596736917640.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aba655bc-d59f-426b-e95c-08d91ffbd21e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44695684318CDE461A2492C38E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDRh4nfxnu3BeJ0rfOdLgm+C249+T0vo3XZwOgH1AfmcG1ocooDR7zoaglJd4DzFSRNjrQwSIHvHOXx/nfgAw5U/gZ71QjFc4kMQ3dkbaS35J3Fysd0U2EKV5VEOLFfRRXYFWMhTjwkpzt7VHF6W3SUn6G+ToruzNyA7sA7sjF/dj4zry8hBMpi4Gn/KW/cLrgnqqYzK0w5mFYhe9Qyg8fuUs1QjHTPCq4J6uB7U8PGKExgLhQQ1ZZyVB6HGvZPWciucv5dTKnG5wpbJ6TV6eRx/HYspj1IOHMtRj7eiZJkQii6yHabF0uF5tClO/kIJHhYWf5F0YMfGfmTjslCaAllxRG68OViWdMUK+r2/aGLP2sW/dnZLne6nM+qZeREPZwYrqIAZBUzkDEv9dk6lO+172NTgJSlycQhOtDnToctY0qRHI7cUjDDNoe/gf5MCUesOwanr7VVajY2lUOFBnvF2Lc/0TLZ6NWymryrxXtMjybmmmylInjQt9+wYugNL/dATf/m3Lh6g8DgB2zDFLfQC3XsRvHao+hVMGLkHHygTap7vMzwy1RANx2T/+qywwvtpskGm36EdIbLcDoazOMfdfr+6dcMbC/CXRlOuGr6gXCwTczGaDLuDmxPNDUyTaAg9Irt6Gt4fG5oKAZB1IsFpT2BnIvksiCcVaVAQxdeq3lC+iM0bxOzFYWSn9j7ykt8qtzW8byRdINJc3p9KUhCL09hfiDdxE+dUsNiObVHatenMYea39zdQMPGn7XwB6CrFq+xDlw29TPeB8JzQcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(15650500001)(103116003)(26005)(2616005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(966005)(36756003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RGhBU3pCRFI4dHFJaElYZGRWZW9yeFkzSyt5bnV5MTBLektyT3d6a2NIRGhw?=
 =?utf-8?B?cVBrOC84YVNrRXUvcWFudmF4UW9YSVNHbC9RY0NMTVRaVUVHZW9jZTNraDZ2?=
 =?utf-8?B?cmsvSWx4R2NJcFRKMmRSMVdXWDFMY2tIWnlldkoyYXVMa0dJR0JBSnBsaVZY?=
 =?utf-8?B?ZldzU0c0eDVROVppZ3hTTXF6dTNjemIvRE5Fd3Q3SFZHM0QwdXNaZVM0QzRn?=
 =?utf-8?B?R3p6c0RBZUtGVjlvb2krK3lVeU1zZ2gwaTMvUW9BWG4zZ3RuRFY3V0xndTBW?=
 =?utf-8?B?T2dNUkNRNXM2OVIxNnNITmRndDNOamF6Y1ZSaUcrWDRCZkcyMlUyQ0lWRnlK?=
 =?utf-8?B?ZVVkY2Z1RExXV2V1QU1qaTVpa2o4cWJWeDNJdlRMK3lvcTdwVGV5eFZXVmh0?=
 =?utf-8?B?cXI1Z0xBVXFPYXJ1MHdtVWJJUWUvME15aG95b2dxTlBFYmZkZVYzKzF2UWhX?=
 =?utf-8?B?TkI2dHBlQ2NJT3ljbEIzWlZTVGVEdWJQRUZaUFE3ZVpjOTNkV1E4TWh0N0dK?=
 =?utf-8?B?MG9ta2RxQ1VrQThlaENoWFJwZ2lnRTcyZXk4VEF0T3RzMHJoajUwQlpJbTVO?=
 =?utf-8?B?N3ppcnZwYVc5ZmtGdVlnS1lLb3U5bFlZTlhMbW9SdjNEZW9lNlJ0Y1FTd2V5?=
 =?utf-8?B?KzJOajdDUzhVRlZXTVZ0TFYyTjBHMUhDaVZwL2xJSWNudzFIU09EMWMxMm1W?=
 =?utf-8?B?ZjBDcnFkZmY2WHA2VTU1dWVySmwwQXRiTmZ4VllURVJSSUhUVG00cDZicEV2?=
 =?utf-8?B?aEYvbWcwN0ZCOVVvYlVNYlVFUmdDSGNoa3RoSjI0OVRSbXYrT3BDSzdGL21S?=
 =?utf-8?B?ZWROK1F4N2k4UEN0NllLejJURE5UbDlMT1dBaGFlb2I3Qm90ak9adUoveUEy?=
 =?utf-8?B?R1dOc0YxWExRTWQ2ZkxlZldJdEpmVThuMjlqdHZkWFRCdmV3eEZ6Y0J3UVR4?=
 =?utf-8?B?T0ZaY3hDekhSeTJ1UHJDOTZnUmhIMXpnYXM5S1NqTmxUUyszWFdTU0N4c0Ju?=
 =?utf-8?B?czFYeloyVEthN1FDUHpEanlodTRSS1JVVkFBQUs0T1U4cjhRcE1XTkx0L3JH?=
 =?utf-8?B?NWcxUWZaLzdPTmNZTEg0Vk9ZYy9jRmZkRXNqc0I2OHZUZnZIZ1l1NGx3dStY?=
 =?utf-8?B?VElKRjR5TkIvTE5ZTGFtcUdad2M1UWpESXpsc0xLb3FBc2pMeGl6aGo1SHla?=
 =?utf-8?B?OFpkNXpKMS8ybmQ5Z1VJclpxTlptSlV3VDFvaHlmWHpmWFFXR2VFUkZXaXZM?=
 =?utf-8?B?SEc2R3FzM0hrVkVabFl3K1hmcUVlME16aVM2Z2V3UDdFN3pNWDRnSm4wOW5w?=
 =?utf-8?B?YjJXY0dreXhKZy9ObVBMaGg5ZnUxeWVJOFRKRC80QmUvbjFmc3p2U1NoWGZl?=
 =?utf-8?B?azNWUFZaQWxjR1B2eDF6c3EvZytzbEtOT05LSXkxTTROT1JsUUw3SFFFUG51?=
 =?utf-8?B?RW5mYkZ2UjhScWtZTERjTXIrWENjbTRpUzVyeFZ0TXFwUFhkcXBHVFYwRTlo?=
 =?utf-8?B?dlNRZjV6MlpJdGcvU2QrOUoyUWF3ODlXKzhGSitIUWJMVnZ2YXdrVnpCN0JZ?=
 =?utf-8?B?bEt3bTN3L2hjV05WNVZ2WitjTGJkMnBGRHpFbXlmNUE2QVN2a2VwQXRUV0pk?=
 =?utf-8?B?K0tNd2pHRUcrS252WTh5Q1VGSWQyQi96Z3IvenJlUDMvemdoRUtZNVJQd21T?=
 =?utf-8?B?NklDa3ZVdzFObTd1T3o3M3laaXFLYWZnYjE3MHBHL2pOem5kL1p0eDJXSEtq?=
 =?utf-8?Q?ea5v++vgCpv7Ww8sl1rkH7sus+Gu2IsjiAmDKN1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba655bc-d59f-426b-e95c-08d91ffbd21e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:47.3861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 80/SR7m7w1YB8uYRihWt9JvzJ/J4V3aiGDuQARu9UBv1W5pRu9rYbroMJCrgsd4K92qItqr9MBTSsebnNzn2QjWrcQg+rAG5ymuMaavVPaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=924 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: Ar4LQPaIN02HvEagXqhaXibOUzK8E6NU
X-Proofpoint-ORIG-GUID: Ar4LQPaIN02HvEagXqhaXibOUzK8E6NU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 May 2021 12:55:48 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.10
> 
> This patch set contains fixes, a new abort behavior, and an RDF
> enhancment.
> 
> The patches were cut against Martin's 5.14/scsi-queue tree
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[01/11] lpfc: Fix unreleased RPIs when NPIV ports are created
        https://git.kernel.org/mkp/scsi/c/01131e7aae5d
[02/11] lpfc: Fix non-optimized ERSP handling
        https://git.kernel.org/mkp/scsi/c/fa21189db9ab
[03/11] lpfc: Fix "Unexpected timeout" error in direct attach topology
        https://git.kernel.org/mkp/scsi/c/e30d55137ede
[04/11] lpfc: Add ndlp kref accounting for resume rpi path
        https://git.kernel.org/mkp/scsi/c/1037e4b4f81d
[05/11] lpfc: Fix Node recovery when driver is handling simultaneous PLOGIs
        https://git.kernel.org/mkp/scsi/c/4012baeab6ca
[06/11] lpfc: Fix node handling for Fabric Controller and Domain Controller
        https://git.kernel.org/mkp/scsi/c/fe83e3b9b422
[07/11] lpfc: Ignore GID-FT response that may be received after a link flip
        https://git.kernel.org/mkp/scsi/c/04c1d9c50ae3
[08/11] lpfc: Fix crash when lpfc_sli4_hba_setup fails to initialize the SGLs
        https://git.kernel.org/mkp/scsi/c/5aa615d195f1
[09/11] lpfc: Add a option to enable interlocked ABTS before job completion
        https://git.kernel.org/mkp/scsi/c/3e49af9393c6
[10/11] lpfc: Reregister FPIN types if receive ELS_RDF from fabric controller
        https://git.kernel.org/mkp/scsi/c/8eced807077d
[11/11] lpfc: Update lpfc version to 12.8.0.10
        https://git.kernel.org/mkp/scsi/c/e5e0280db792

-- 
Martin K. Petersen	Oracle Linux Engineering
