Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE70C49361
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C84D6613B6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhFPDvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1166 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhFPDvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kaX0017184;
        Wed, 16 Jun 2021 03:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1F1ER1EUJHhxbGRrAvfRu16xCQBj3c96Uefo79lt3hk=;
 b=LBSidNhcyvpYUvQeNYvgLBHHF/28KczhfnMlCIE1f9U/fELIqfHspaU94TpjGQFNNuU4
 jILc9hxcTjk6oZjZQLU7GIjp+HeqXPF7jDF8TF94dT1n+ogcs3ydsaJQDWyyPP1+okwn
 S6kMwKaMCK7cPBXZaIGhoAVwkvJA4YGJgg8mBxm6VGIooDwsOs23iOioilr1tlrAdsQQ
 ZEAMXdmqC1nXd0O8jJoMLDAPHIbO657Z7Ufv8OBZDoPRYOtdxVSOtePUy01ygiWX1PVo
 aeNF549xvG5h0AdLi96R9RovsfzPnEGr93HSCKhDDn6FF7V7CKKT8L0aARXaCK0LPQcc XA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1ksubw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:23 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15G3nMZ3157594;
        Wed, 16 Jun 2021 03:49:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3030.oracle.com with ESMTP id 396watxnry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V32f2kfiWZCdAgPn21Mz9JMDgLjKCEnKADA/GVjDkvT+4gZfXlBlp7nO+IgDzSX5LCtUZw7iCObvplqZ/7PMHxhX3n7YYh5fJBlwpfTvtM3ei7U/DLazGGFWWsl69ssAnlXAImqudjpE4DdkfEAQU5MSQm39ZEUDZ/gzjk7CCCJ1mulv2VHUohm6p69yRD9T96HydC+7P+hHXPIYpYl9Le68NwrIsm98m6K9P9nHx7SmGUwrQrTUWYRHXO5BokABWLhZ7MiYzCG/eMoQTq2jABlVHDCXTJ4AmDz62ns4BN7uxoztZORMUEDQVxfNxzUEmEtJJeHQlGRnZ/LkmvzxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F1ER1EUJHhxbGRrAvfRu16xCQBj3c96Uefo79lt3hk=;
 b=aONCdVi8fGf1cv3ABqsCjRofjXfWwjZ7glmiGsfCFk/FoTAEktzvFhvT5hzoQmY3/nxbv8SaSNhoH1B+j93nvG1rN6P+d0iDmdt9twQ7Zva1I+m4/r1n/8TwYrxP+CY5PGpGpLFS+TpcJmqieY46p3eteCzksP1jUw7+utLwFpZlUBJUTvpO5t6c+Mh+9qa6bRXXwsT3rS1xptDvyMGkEXhJKwICxmmfJxE9ddD6O+R1KrYYV1woyIzApcznsoNz6ck11X46xR7d6qKwc3k2U3GIw86UZOeKgBSDhfbXFzoeqDGC24VC5pHs67gvlp880jffLj2sM1IdrnBZHELXaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F1ER1EUJHhxbGRrAvfRu16xCQBj3c96Uefo79lt3hk=;
 b=BGa5N9YTHx5YNyRLGdmqlw/E5xPiFLDpdXEVBSrGcUDF9RLXwORqzp7Vlp171hnqymuqqF1GKdqZRoY4BugRrcSd01IZKUPpsyUGZSXEOCfsMBpe8mA1l04EhyMqjG5yJXnXkosoGMsevChqMmkds6fhbr2bjeAs+Pb7qI2dOIg=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, jejb@linux.ibm.com, beanhuo@micron.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, Bean Huo <huobean@gmail.com>,
        tomas.winkler@intel.com, bvanassche@acm.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Several minor changes for UFS
Date:   Tue, 15 Jun 2021 23:48:56 -0400
Message-Id: <162381524896.11966.7879394764670560166.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531104308.391842-1-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a109e084-32f2-4ce9-f60e-08d93079b969
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663B84DEF6BC6D6FD1F27A58E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B0uLnKrjfPFixwiWu3zMEmUu4IgBrnifHoJPCckO8G45Jvx1kscR7naHymOSYMaWlUHwtXzU59OHFLcAk446bNNNASvsjZ4sKiis2z973ibQu586lVO0ZeRIqZ1NbXWgC1PXxIh3e+l89OpIpgFXSxod+yB+AdE4OyPtq1I68sG8snlN8MHioAOVUuMWfVojHlux+vD2MeXKEcecuVJD1h4B7lN34i6ZP6dDeoCO/kodVs1FyhGnbkuBDI/kwTzFkrk9mzMl3CCfXczXQDhY0UmVyhmUraBpxUbuUUZg94iHefn1BcNoLTI5bMqpBLCQ6ER9FiFWeHBzS/c9ACijuMIJRGbLEUpYkJNn7jojZs81rIiQotOBsM1+oUHF4jakrXaN8E1ryZcLS5CngjRGyD9NdaJkEpJgue9cTZylT7yAR6lzgJm06y5vsIUm3ORuGKD6l1IjwEK24TseWh7GgqYseL4YPlw0QfwrDYzrP0FLo7Zuv9c5TDy7ZCZDQD1hRphbsfoyFSB4gpDJ99/g5nqQdq+bqGopTCt6AmLjZEBNde9gyMUdnPNnL/JPuP8KHJV82j8qSQtlOWrvbBX6N5UXhZ2sSF/InEx7onotx6rPKqDsGxPlhjK5af8WrRtxOHrExxOPx7LP3FeJzRDHrW36ECLfiPnKWVDmnjd3f7Iz5XLetwyVjsJoCsm97HKJyAlxRKOybPeyRHqaHvSP/95d1aMEKZAsvjoQ+r+O7CeN9Dw7KOwd9M/97o94pLJ0ym5k3OxHAo+o3ZmhRe3bFv47SuhZufuAOar8ZfusJi5rA50k4Wy4Yhfs9ixkaSEkiaDvK/Tf+NklzGFQ1LQsSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(7416002)(6666004)(5660300002)(8936002)(966005)(316002)(956004)(921005)(2616005)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXR3Mjg5akJrS01pZ1JrcFRSck5yZlhyZTkyTWFFUDd4NURielJhaTU3aDk2?=
 =?utf-8?B?ajgzYnYvMXdHalJpT250dW5ZYk9IMUgwSDFYT1VTY1hudGp3WE5zbVJZb0s2?=
 =?utf-8?B?YmpGWWdxWFc0d0N1ZkpjSXp0NUE0Y21zdFUxcmhTcDZ4cDRmY1kyWVBpWlBQ?=
 =?utf-8?B?T2VYUktreVNBUTFWc1pjOTJyNjFMS2lXVHh5RkZob25Yc3pJTWVteFI1Z0l5?=
 =?utf-8?B?S3FJSGM1d21DNVlPcGVUUFEzOGhDc1VrTzdWOU5ENFpvM1RBc2FTb0IrK0hi?=
 =?utf-8?B?ZktzT1NpYWtEVXlZVFRjUWxTSlVBdi83d1JpM2tadEhFWGtIdnZTdzlvZ3Iw?=
 =?utf-8?B?b1NTT24wSnd5RWtpQU14d2R5WDMyS1M3Q1FMbGtjSFE4RmdlcGZNRC9Idm92?=
 =?utf-8?B?dytCNHBOcGhpbnZCdTVKR1JxRUVzYUZEZzNPZmZidXRwZUN4c0VuKzEwRHhy?=
 =?utf-8?B?Y0oxMXU5UXRudjdScXpQNU9acTdEOG90OFVwakdPbzIwUVBEcFV4dHYwTHlZ?=
 =?utf-8?B?eHgvL1dIZzJRVTJMNUx1UVF2eUUzdmxhTUV0aEtiaEg4d3ozUDE2d3hxcDA4?=
 =?utf-8?B?Y05VaFhENmNQUHRDd2pzS216d0hUcUNzc1dMZHdGb3NHOFNoeTV6VUlrM1FF?=
 =?utf-8?B?WXlnZ3dVMldJOHVORnhSb0dxN3p1cUdic1FJeGpWY0N3ZFdJUW45RFFTMDdP?=
 =?utf-8?B?djY0M1pyazNNbmJZWHQraTVkMCtvdWRpbENTa3pHU2N0cGIwT3hPY3BORGRW?=
 =?utf-8?B?Q29KS05UZ0I3K0c3RTIxYU1uUnVPNXdCcmJXVHo5S1NvNlB3bGJDNDVaSnVO?=
 =?utf-8?B?eVl5YnJ5YXVkbHU2dGhPb0VvSWVUQjJLaCtzM0pKVVBZZzBDbktLSFViNXE5?=
 =?utf-8?B?dlVPSGFqeHoyTFIzT2plcnR3cUVqa1hXdFcyYU9XTXd6QVJTWVhvQTk3Q1Mz?=
 =?utf-8?B?SFEweUZXUUZrc1pxekJ4WWd3SVNDNUNueVFxY0Y0b29uSnlIckVjbG9ZOTc4?=
 =?utf-8?B?SnJJdVVLMlYrRWxpdDdqTGg1TVpWNDgxTEJ4MzhnYUY1R3Z6cHZhdEVrQ0E4?=
 =?utf-8?B?MksxWnRDVkhtVU1yNVozejNmeW1EVTlYM2dxdy8wMERtMmhzTGRpaldNRktO?=
 =?utf-8?B?QStsM2pjTGEycUhXTnhQdEdxOUdMUDZmZjdTNXR3cG9DVUExQkRzK2lGSExS?=
 =?utf-8?B?aWRlRktUQ3VHRE5mTnBLTEFwUEdqR1BCb3d0bGpWOVNnYndzaE91SEdMSkJX?=
 =?utf-8?B?NmJwOWlBQXlGR1BZcnBwUFpRZ2MyTXk0ZTNTL2NuaTZ3cG03eWN2QzhjcWla?=
 =?utf-8?B?ek9vNFJEVDlldUFyRjd3ZGZNYm81VTVjQkFzRHN1Uy96K1liMjJUWHhFTEQw?=
 =?utf-8?B?QUpRVi92bTE5ak15dXUrejV3aDE1RE1QMjFtdGg0N2xKdTd5aW1WN0ZjWUpJ?=
 =?utf-8?B?bXYwSEZYVDZyQzUvTCtscWxZdE9XSThXdHRzSnBWUWpkQk8zenFxcmJRNGxy?=
 =?utf-8?B?amw0U29NcGVZZDlVNFM0TENMa1k5M0tINE9jUHYvVWZlekovbC9yRTVyUVdo?=
 =?utf-8?B?elNUK3ZYMzh4blVvb3FjdHNqK3RyTUxrYll4d1Z5SE1CZ3J1MTllanc0eld1?=
 =?utf-8?B?aFZBNDJaYkRwVkVGYUFVWitubTRaaVJsQU4rRzEwcmxMdmJNYmJEQ01QWVFD?=
 =?utf-8?B?aWx0SWx4ejQzaWp1MndKRVUxeHNaaTgwRkJ3RFN6RnhrNW41QlllVTZSdVdE?=
 =?utf-8?Q?bL4MMRCI6tCHsH7VJT+iRqG6tT0kSRdKXIovHpS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a109e084-32f2-4ce9-f60e-08d93079b969
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:21.1612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zx6DexJ+vgMgL/ypmqUL8wADnmXHW4YPVEQqOocQ3C4gGFmSzvbMLVrudKAm7h03ONIilYNlJc9Gym5XVLwuzntGx0DMFWS8xfHp8NAp5nI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: N_gOkNE_gNGxgYZFg07QG7E8wQT-KDet
X-Proofpoint-GUID: N_gOkNE_gNGxgYZFg07QG7E8wQT-KDet
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 May 2021 12:43:04 +0200, Bean Huo wrote:

> Changelog:
>  v1--v2:
>     1. Add a new cleanup patch 1/4
>     2. Make the patch 3/4 much readable by initializing a variable
>     'header'.
> 
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/4] scsi: ufs: Cleanup ufshcd_add_command_trace()
      https://git.kernel.org/mkp/scsi/c/04c073feb1d7
[2/4] scsi: ufs: Let UPIU completion trace print RSP UPIU header
      https://git.kernel.org/mkp/scsi/c/89ac2c3b2835
[3/4] scsi: ufs: Let command trace only for the cmd != null case
      https://git.kernel.org/mkp/scsi/c/44b5de363524
[4/4] scsi: ufs: Use UPIU query trace in devman_upiu_cmd
      https://git.kernel.org/mkp/scsi/c/105424895c02

-- 
Martin K. Petersen	Oracle Linux Engineering
