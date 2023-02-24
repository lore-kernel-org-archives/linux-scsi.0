Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE67C7EE23
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjBXRsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjBXRsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:48:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D3A10FC;
        Fri, 24 Feb 2023 09:48:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHibd3003680;
        Fri, 24 Feb 2023 17:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jqyMXML+H40wHoEoi1XBTZ7vCB2WLL5i5Oy0Tx0j6vk=;
 b=1aO6JGgPSQAgNRPd0QPaaHyYMtOFCDNfIuzARvwrhtCO3R18/SZhkv2cWui5P6jq/kXO
 inJ39WxwNVGxO22cY81hY5cLGIOTK8TBzO+Z2GykUzNDQJZYoNccdyRcVvpYxISqAcuh
 S/x9PW4SOvwmBB2XAvZ2R/XWfl4uCHZNFKh8095EVQKZhKbvYtR9SfKb/+jz8YuOXco6
 I8lSdApuIjGu8du7hV5TxFjY0iKQMZDgwJ5piX6u16OVXk8P5qvMqzWilVoUEGCl6inI
 era4wyMZufGprbwRRDfipbFuKjpI03PXYCplvnACV/kA7jXgiKiBrGHusuLZidINIDS2 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90wq35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OGXw1d001935;
        Fri, 24 Feb 2023 17:45:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nxsb4kufb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbM4FpfyqT3ZeDO1+XAp+SZiXOogCDBMRVB8QhSaMIJeXpm3EZi9lxiJLcleLG7LmzqJ+T86kuKehcJUzll4wObGGqv7mFRmkFDzLzAwSusl0dHQ8kMjSB6zXktUTi/19Qu49OffsFsjbn1oOkzOHXaq89rYqHi7TjmeFEE1cWNQGOdFVCxy7BVNyKTMtetbPMB0PhOu3+VyLxyUswU5r55TGZBTfabAHFOo3r6i+VtMtxeEk+dPj8OhB4zBHxdezQK25tDisCvuA7+2A+3RwBaQTyKc7sOdwp9uuC5XKpGUkpA1I9ztTtZtScAHVHZJKWjxjxJQ+YXEz+GoLNbyEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqyMXML+H40wHoEoi1XBTZ7vCB2WLL5i5Oy0Tx0j6vk=;
 b=U24agicXQC4K/Es+pG/wr/dne6jI0RnVm0HZppAYNvVoLS8HuGYz0VPruApNOhOvstMverlYuSaa/hhRSCq4mf3NuxwXOHDC9TGKbZPv/VzPO8+c0Z3uKRzMMOQu/2Qf+EaQPWsC2CPJeflrcuQscFaTSUd0J+6pv49RaFV6v0z4lyl2vr7lDHspQhA6od2nUjJTzl+WBitdXFTPoZE9lw+q0OV1lR1/O+Cl48gMruWyTanSvffy7vWKvdgCnvlTadFIq06+bed+PuldsV7N3MhglVed8wmZs/TQG3Ib/TJSB6c6Xi9+M2h9R2eeogWi0pCQzeEvkD0C/HRcgOj8kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqyMXML+H40wHoEoi1XBTZ7vCB2WLL5i5Oy0Tx0j6vk=;
 b=ZR25m+hGVLjp6w+U8y16zuKJ7oCyrYjDOWfsOeD7kmAoL7ubse7fFWhhr+9f8z1inG6WEJhzoXbpcEtdJT2fxQAnT0c30sn2GubQITrryJhPCZjTCyh2y6iTSdvLLnxBeKToteMyt2W9aBmhS48V/VLCMT+KGuUBwY+Xq5RIDfM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6245.namprd10.prod.outlook.com (2603:10b6:8:d3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.16; Fri, 24 Feb 2023 17:45:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 17/18] scsi: target: Report and detect unsupported PR commands
Date:   Fri, 24 Feb 2023 11:45:01 -0600
Message-Id: <20230224174502.321490-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0050.namprd05.prod.outlook.com (2603:10b6:8:2f::9)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ce0a786-e26b-4106-0292-08db168eeb9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8G5jEqPkMnRJsZoHasDDv9oYJ6pGInCaomqBsIMbGXVvdpHyPjEYtWM1h0woZL+MdrJtGw2wKd8hCMs4ZfafTQiLe67gE/1ypVjgB8QrNYftRbSyh2e6x3QP/b+n5B3ZwhN+Tm1teKWrhydOTLfuO6wcNuuEPnDLLHFJIY8xY/DwueHV/ooAVgvUJ7kNcM9oRJTBKePaaqWoAp8Dp7ZW+wI5MNKGYP7/rrDCNnNq5O7KWzvNMJf4qI6iX4WWVD/1cb1CCp8uEMuj2yM4MeQlTmvu815yKZ+qJVRS0D9qXaM/Lsy+Xpd49wCELmz7CAf7SV+EFkzqVvyUYJPP8VgnKbPU1i+nK+eK8QD+DoOHHabwD12eRY/4ZcOgL1A0uUyfIjL4jWsk8x/yy9dDhtKZZssSC3jGEkwjJrokuF18MCGiQkHL43V6rykqNSGSqywveUymv9lzyTzKhgYe3GEbkQdV4fvaz1+HvTTiMJISdCNsk1bgbh9t0WmMxv9MhfAlRuSrgovytG7bSk9hxqJOwWrgz6i9svGf6yUJTalxyrLStll5OHsANXhjj9j+rnQNc4ujcD1xMRMroNA82x/5kdndQU7N0y22ajORz+a81wd7ngP5IkmMM1hvXf+waSuI1TFM9js9DLjzP6dpeR1xSm76qhauvTmYbRCzBzR2JCkFRfacvWsGwegAR5AMjEr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199018)(6512007)(36756003)(26005)(2906002)(186003)(921005)(107886003)(6666004)(6506007)(1076003)(6486002)(38100700002)(478600001)(66946007)(8936002)(66476007)(4326008)(8676002)(41300700001)(7416002)(86362001)(5660300002)(66556008)(83380400001)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjUO20SJ+fKDT3mHpZgqjG+VbTntN2zlBaujU+IBdcLlI9ttxULvVOTEZCuP?=
 =?us-ascii?Q?4QoGq3fRnfTM6sVGUPXhCbIR3wd7Q+zVdHDvQPr/BR4kmCsIVAY7XynOr9PJ?=
 =?us-ascii?Q?z5/4MDOuIXlY+Af2X6R9BAQDW9GrECC9FrLZsv6Lj1vDmV+TgXnQ+8VFGcOi?=
 =?us-ascii?Q?pb4vFOJ8ZCFhqvRLE0OK0G6+UTiXlOIwWNyPsHrFAasOBD2VjyxOG6gmqhfh?=
 =?us-ascii?Q?M4o3BtQ60bu6mEF46OO7HxTFE7Rmiu/b8X2BnxVqFPupgY6mb0WzCjqtWMV3?=
 =?us-ascii?Q?d70vzKxkAQXJrNuGbDhQglyu/rDbeo3S8vl3+jRgNCv8g0Yk2d1I5qYOQFg6?=
 =?us-ascii?Q?ATKzZG3fdJZbwQ41/cXOLDzAbpGopmvtzzu+xY+nbDg8PgveM8wcRWInzac+?=
 =?us-ascii?Q?c9qpiJXvTPnsEgWL8xtTfH0l6UiH7YYuSk7888clN9O57ctU3KVXboqf/Q39?=
 =?us-ascii?Q?I9q6bXlQLs6g/BJeQApWXeR/ZzvDWVaRSaxEiKS6I3vfV0lemUxWman7s3w2?=
 =?us-ascii?Q?MByip5q++WFbwdaGo7OunMzg+xlrgPx80AN2xU9kS7i2SWAHFBhWrrJW2F8P?=
 =?us-ascii?Q?9YlsuqauvtShQnO21hKDE36eM8Bf4PQHzMv3bJUPzcvKtbBPE6wCVE3O1208?=
 =?us-ascii?Q?1Wcu5VcIALOe8k6Z5vlcLQbErFGIi/Q5yLnZRd050r6NRCYK5RWe/5Q2F/tC?=
 =?us-ascii?Q?2Oj+VmuWjFV684W8tqZJ0GSDs4JapnK6fVXPK9XOy/sXOjzHSDom3E9jHb6k?=
 =?us-ascii?Q?itabepN1DjEmZJPJOHaBX+sXVTwAg3oJyI5wF7W5NRCQeaCmM+DDxgkmwf5J?=
 =?us-ascii?Q?1eLkTkqcmavrcrZKxDsZOM3VxrvVonzkiVLQiwU4LFpxszR14Id8VkhWytxc?=
 =?us-ascii?Q?i3E6a+EWM54IlCyXwme4+Lg6mDrg3QcMPGJgl6bU28+5dtgaHTvQIqmJY7fQ?=
 =?us-ascii?Q?FcnxCc9+2yOrpid8F8J0Jfam8dJ5n9Xa0m5NbKq56vf6WIO8ISJrIPgCsnei?=
 =?us-ascii?Q?mbIHbHYUX72N0uSfy9x9V91KY9w2BYr5DclCQ9NRXIzcs6ier1v+nWx+Mqf3?=
 =?us-ascii?Q?/wCeNVvPrF6b4bD8vTPwWcHAztSABVoEsYCXS4C6hODM5XlX6oZO+U0RjpCw?=
 =?us-ascii?Q?d6HGnj4d3DUar9nXO3+urt4VMdnuxWyt63qOLSqQF2zehb3MNhdAkokqTAv+?=
 =?us-ascii?Q?G+a7B0zNnc4xzKxt8MiJT11LQaOTX6pTAh5w/Cn89QOn8Ier9VJnu5pArHGJ?=
 =?us-ascii?Q?KLPR94FTHrRDOodCa7hhBfgXMDigFTiomSmVV89qkFkZXaWNEEUqfd2zIBi9?=
 =?us-ascii?Q?SNAiujJDwUOwo7D7a2AorkZQXaTVRZ5e2qxnJrDAB4CRMPNrhpfMNt7jFmJz?=
 =?us-ascii?Q?Fa3RJ/EJpxKej4Mgb2SssViFUU66Hi1DZsdI/cL0UVc+2ZqjqQckuU8Clmag?=
 =?us-ascii?Q?kNWCvfpYdkT3Q/Qio2BO9XRVYQerxzOf1dijBcweqrdatlogZiuEWu7Ui5sp?=
 =?us-ascii?Q?zUJqcoG85UN7OxtdWRhRFwFzQUITEZAWcjyjHpNQ4FhYNDMwdmdYYC6AlE1w?=
 =?us-ascii?Q?PuYxNqK+6GNZUZgID+402IjJi1LSyu1pQse2xB9pJ1r5yWR6LXLrTZr/SzKC?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ef9xnQPYFB/NNfhJTQBhZL/SnW4ZAGDJ2YbawrS6HCiR2zJFhkwMQakEH5bH?=
 =?us-ascii?Q?V24O+gmdRbPujfGOAiciYBfGen01O3711G35e9BcFEQuZIDTOvb7AZLg9q8K?=
 =?us-ascii?Q?IpuJB1Il8Ez/a/dVvKouDlflRHiN7vRQdqbggpk23e6Uo1f3EcgkifpDUAYO?=
 =?us-ascii?Q?VIFpuQFPRcXCj427HS05OqFsRkOik63GW79KFPYf4nHAIu+Ro1Q7IZxFCTFT?=
 =?us-ascii?Q?Bn+/1J6ouk09mV7PQrrJ5zNicB0zrwblUiy90sZaXQB6HNZSbs62L0WGzSO8?=
 =?us-ascii?Q?zQALUCgqktHzNeDqI0tFfhmOBQGKEjrqnL4TyrD1Y1tc1hXmNBiD4d2Z8nBg?=
 =?us-ascii?Q?cAargQ2P9+0e5A8vw+tO6gkiHccMFFTMaRRuqgwUfGyFk3ykuumHHVtrvjds?=
 =?us-ascii?Q?iSjfOlO662yW6+ZwV70KzmbKZomj8THz+TChJuA0rtzvfzzOdAZWONUvLy7a?=
 =?us-ascii?Q?Ttqh08X8cei2OPdQTGHVT5s1xEAUmjOm5H/sjwt/f7r9afTLWOvDNmTh7/C9?=
 =?us-ascii?Q?h3ttkpw47rtITk9+lB33tALSFnodJV+LmH+HEON8r4grnmU2GsjE9S1PvR3x?=
 =?us-ascii?Q?cZP6y9EM52HRMP5z/XDv+DmKYvK52W0YuiNm47FOOterMx/hBVnaKcAhE0BU?=
 =?us-ascii?Q?prub9Fafqzm4/XYDBHOVou/gqCKTUb2bx/wztrirdyBwSTWhYZ0ZyQFrceMD?=
 =?us-ascii?Q?qrHkyUmkkS5hm66cN0ROUd9C5pzW7wT3l86oHfLLETSSG3aYf4cS3a7Yi3ZA?=
 =?us-ascii?Q?dOMrEuZ3l6OFJnssJVofsZ7AJA6cLFgcpZVQOB4+gnrsA6/fJLBk7CdcDOHJ?=
 =?us-ascii?Q?qFhfUkcp/b0hM2AAhinYqnHwJfRQjh04kTCqxTMe3E0J27CiqnAvcOS+p2D/?=
 =?us-ascii?Q?VDIu+Nvmvz5DDqKuRfndJl5YHc6I5fIdyfnKVw+1OnTtRKvyg6+ezl7lgPvZ?=
 =?us-ascii?Q?jIDahrBU9BbJ3EihAepiFrFqsxk9OYYLiLlRWobaprEB4kXKLF8gegxzhmQU?=
 =?us-ascii?Q?aoEkM5wigp6xgJucelprKgJLJg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce0a786-e26b-4106-0292-08db168eeb9b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:29.8747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXP7FyXZLSz/jxUNtisb5b1Bn4/X0vdPT91vIYfyCUJt90suznEeA8h8VPtiJMUqbYXG6klvP28qIaCtxVaMRuLBEdKDLLy+t8bHGbDouac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6245
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: aqVyD0EP9Y7usLEW4nRT_heT55as6_L7
X-Proofpoint-GUID: aqVyD0EP9Y7usLEW4nRT_heT55as6_L7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The backend modules don't know about ports and I_T nexuses and the pr_ops
callouts the modules will use don't support the old RESERVE/RELEASE
commands. This patch has us report we don't support those types of
commands and fail them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pr.c  | 17 ++++++++
 drivers/target/target_core_spc.c | 75 +++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index e16ef7d676af..7a3f07979a02 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3554,6 +3554,18 @@ target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
+	switch (sa) {
+	case PRO_REGISTER_AND_MOVE:
+	case PRO_REPLACE_LOST_RESERVATION:
+		pr_err("SPC-3 PR: PRO_REGISTER_AND_MOVE and PRO_REPLACE_LOST_RESERVATION are not supported by PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (spec_i_pt || all_tg_pt) {
+		pr_err("SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type, aptpl);
 }
 
@@ -4082,6 +4094,11 @@ static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
+	if (sa == PRI_READ_FULL_STATUS) {
+		pr_err("SPC-3 PR: PRI_READ_FULL_STATUS is not supported by PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	buf = transport_kmap_data_sg(cmd);
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index caf8d1325007..053bd2eea0e6 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1672,7 +1672,41 @@ static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
 {
 	struct se_device *dev = cmd->se_dev;
 
-	return dev->dev_attrib.emulate_pr;
+	if (!dev->dev_attrib.emulate_pr)
+		return false;
+
+	if (!(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+		return true;
+
+	switch (descr->opcode) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		/*
+		 * The pr_ops which are used by the backend modules don't
+		 * support these commands.
+		 */
+		return false;
+	case PERSISTENT_RESERVE_OUT:
+		switch (descr->service_action) {
+		case PRO_REGISTER_AND_MOVE:
+		case PRO_REPLACE_LOST_RESERVATION:
+			/*
+			 * The backend modules don't have access to ports and
+			 * I_T nexuses so they can't handle these type of
+			 * requests.
+			 */
+			return false;
+		}
+		break;
+	case PERSISTENT_RESERVE_IN:
+		if (descr->service_action == PRI_READ_FULL_STATUS)
+			return false;
+		break;
+	}
+
+	return true;
 }
 
 static struct target_opcode_descriptor tcm_opcode_pri_read_caps = {
@@ -1797,22 +1831,13 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static bool
-tcm_is_scsi2_reservations_enabled(struct target_opcode_descriptor *descr,
-				  struct se_cmd *cmd)
-{
-	struct se_device *dev = cmd->se_dev;
-
-	return dev->dev_attrib.emulate_pr;
-}
-
 static struct target_opcode_descriptor tcm_opcode_release = {
 	.support = SCSI_SUPPORT_FULL,
 	.opcode = RELEASE,
 	.cdb_size = 6,
 	.usage_bits = {RELEASE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_release10 = {
@@ -1822,7 +1847,7 @@ static struct target_opcode_descriptor tcm_opcode_release10 = {
 	.usage_bits = {RELEASE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve = {
@@ -1831,7 +1856,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve = {
 	.cdb_size = 6,
 	.usage_bits = {RESERVE, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_reserve10 = {
@@ -1841,7 +1866,7 @@ static struct target_opcode_descriptor tcm_opcode_reserve10 = {
 	.usage_bits = {RESERVE_10, 0x00, 0x00, 0x00,
 		       0x00, 0x00, 0x00, 0xff,
 		       0xff, SCSI_CONTROL_MASK},
-	.enabled = tcm_is_scsi2_reservations_enabled,
+	.enabled = tcm_is_pr_enabled,
 };
 
 static struct target_opcode_descriptor tcm_opcode_request_sense = {
@@ -2246,12 +2271,22 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 
-	if (!dev->dev_attrib.emulate_pr &&
-	    ((cdb[0] == PERSISTENT_RESERVE_IN) ||
-	     (cdb[0] == PERSISTENT_RESERVE_OUT) ||
-	     (cdb[0] == RELEASE || cdb[0] == RELEASE_10) ||
-	     (cdb[0] == RESERVE || cdb[0] == RESERVE_10))) {
-		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	switch (cdb[0]) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
+		if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
 	}
 
 	switch (cdb[0]) {
-- 
2.25.1

