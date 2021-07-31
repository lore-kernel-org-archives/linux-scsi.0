Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA16C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 03:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ACBC60F94
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 03:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhGaDtL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 23:49:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39950 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231487AbhGaDtI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 23:49:08 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16V3jspk012805;
        Sat, 31 Jul 2021 03:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zs5vtwPTeX3Du3hljMZ7ydBxL9eeEAWzmsBfE2fUhQU=;
 b=OpG87VExqIHzTA6GO2/UKkLnTAxlp4CxmOp03RRz+1TQnG4V9a0no/UVhFPUFJ6u+st8
 V31AYotdPFpjskwmrLP/Tgynt5IezH71U5xeGaCPfLoIE79kDb9nEmpyHKiikA7Wi3+Q
 1Ru6FGNy/WGBoDGGC2iA8oNDSMe7xsKKbkeqm5dqDDM1kaik/dEriDQk9JIL80aUV0fc
 pDVuq8kaSiHgvMqilsw6zU92i/lrwohe2dKgB6oPLEovnK+ppbVq94o618g866aqKgY/
 q6WdAngfaV+2Z0SFYuJ1QiqdeMEbhfNwA0dUUeHQ0O1d62HaEH/uV+N483c5LqIl1Wdv +g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zs5vtwPTeX3Du3hljMZ7ydBxL9eeEAWzmsBfE2fUhQU=;
 b=kmkL80cl4agbi78FdMcsMxmQIPV3eugGZjKvneTVLb9x9Oai9ytQR8VCIIJv05MuKtkn
 Lq7ledQ705k55HY1i1OZ7mICzdNFGgYS7AS1UagWwVeEVxjDTuI7R0TnWLTwX2TdR/ZS
 2x4WTiT9rUuCiw+9hm7CEwVmI/c8S8Ae7oFEPPuyrgSkqsPXN8iLb9LH7p1ck2PdvHXm
 jXIqHF5H9VgXfxmk3gtw4yzVm8cSzZ0Lz45sVHOeSHkTOwW1XczjExMx5O3bXV5AW/zu
 GFYEIhBK0fNh1If7IyD7UOT+qNQqquGWpf0Hpp+aWTabb9V26bAJ2LSwqJZ1F1Zw1ylg 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3uujc6wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 03:48:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16V3Z2JW132788;
        Sat, 31 Jul 2021 03:48:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3020.oracle.com with ESMTP id 3a4wujtb3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 03:48:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXnYtAitAul+1ZNDFut0MdfODCLtJMltNz8JMAv2oPCotqcZ04M4Ky3tIqT5s2W/BJeYVS8LReUUdLfKT8dm2nhDtTLy25ivGNNKSlj7h5l42wGUgVGda3mJru9Yt/xnSIbgeoM0lgqkrZju+SdlbYFOyJYtkXuJmSd7ZkAt476cJ2qXHGR4jHgUmntFBKJp3hR3504LLOzwMEaZxClGULuBeGacomxRSa/TPCd4uWOfiawhjreA/Mh75tMbN7cEvkLbeacwvifDGBLlS53/9mOX3kDEJh3GycW5rfkUMGwc90jMu1Qc6KUMzR2es1oKEkQwwKKq3CQKFJodUfknVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zs5vtwPTeX3Du3hljMZ7ydBxL9eeEAWzmsBfE2fUhQU=;
 b=cvW7h2MtU2hFilvYN90FA8mVoruieQq6JPKu23Jr8BlwcLhibSwh2SprskLGBFQEBNlDYAnN+8lDx+uNQ6XeOvox50bwp+lFR6cXJhec1sxiYnd8zAzyOMmWmHlXSbn8I/QmkihpooON9hbabeGEXExtBZwI34tEL7zQq/tdbjMS0ptla01qu/3OOLerCSw3/dUKXIXrD/wUwH4RMrrINK2gGXVMQnUlVvkp58EUSPi4QJ0ZwPm6NpAHaKNombZTtPGmPbweK6bJVQQrmLdj8695UdyQ3s7au5PPsCv+ceeZAglJgY3H0SvEMEX5KR0cZWPhdiUf0f+HQIPVhl6y1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zs5vtwPTeX3Du3hljMZ7ydBxL9eeEAWzmsBfE2fUhQU=;
 b=e/MWBeNSmwKYodmWqSTWKcXuUpVq1fYMMkLraKztWYy8bTlvdF2knVnbKGIhnqxVmgRHtSp9xZ4/UXHGOgcG0buAMpa6zFGVh7XQGx58kTJDNiwZjcXovEj6SFJIExFkwCXDsxZWcJAkpuyBn5pDVzN0lQAAFfnFnk7UeFAACa8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5643.namprd10.prod.outlook.com (2603:10b6:510:fa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Sat, 31 Jul
 2021 03:48:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Sat, 31 Jul 2021
 03:48:50 +0000
To:     Vincent Palomares <paillon@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dh7m9d4.fsf@ca-mkp.ca.oracle.com>
References: <20210728012743.1063928-1-paillon@google.com>
Date:   Fri, 30 Jul 2021 23:48:47 -0400
In-Reply-To: <20210728012743.1063928-1-paillon@google.com> (Vincent
        Palomares's message of "Tue, 27 Jul 2021 18:27:43 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0046.namprd02.prod.outlook.com (2603:10b6:a03:54::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Sat, 31 Jul 2021 03:48:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a281a763-0b12-4728-d023-08d953d61ba0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5643EAB9B83E2B46008604F38EED9@PH0PR10MB5643.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EvRNVxDu+pWcyCWjQjUuUn2wVvnV0KPtF873/xkzNom8i0iTaDvpBXHpyoOQulmPxLDCSRJDrzCoxTIRnYh6vECayXE52Xsv4wPYfYFLOhbSGQZMOio2W94xyYIN4nPD6sr1eLrmRoXX+eIcu64wXLCiixDD4hD+j1WfwO81i3HJ66pYQliCLVy+1Q84noRSmW/aRATri1BCDNfq1grxGQLliUCtvRf2y8/w2qoeaqm6m1irExpllNDihL2/vrpdLEdRflYehKFsFGLOsXK8dq/Ee05wo5JabRGRhio7SzDq3tnWoE5XPwN2ixZDeZShuh3jnUErh9M7fm/yYqwx9qDhoyhUs0oWnH6p0vK5JnTLr55TeZ7bZ7HoNAdgRotkIKM+CiGem8Dce48u3CrGwIreCZ4RP5qSyL4jxXzFEOPmZVSGVnhRWQ+7WaJ9G/hNt5slwExyExLti6kxNZ3bvfEPhiWLN6VegNd97qPKCrXS6PWpO6c25mixoZ+S4uf+iLKG7l2M5yLoeEkd6Nuw1EtcfOEQw78GLGWkD8/IZsHF+CexICoPUSjvcVakeyaQnbWCBQzulsCmGDNS2q7iOgBDMFbP74T0Z/BorMGbmyL8Oh4FYiCVDXDHMppfNMVarAb1BWzZNT3DWY4PoSo+v7JNd7hNYCxj/6FOEcw+VUx4V7PHE2HG+02kD5gHeaqcJ10lgKP0+JTgw/rt0qQqrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(186003)(7416002)(55016002)(26005)(36916002)(956004)(316002)(38350700002)(38100700002)(86362001)(15650500001)(2906002)(52116002)(7696005)(83380400001)(478600001)(66946007)(6916009)(4326008)(8676002)(66556008)(5660300002)(107886003)(66476007)(54906003)(558084003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wuTv+358zqv8S3A0FLxR8Ay0MMhTqdEyLX9gUGWUiPeZlQWA+gyjyUJ7bvMO?=
 =?us-ascii?Q?hyyi2OoUxJzSsTfWGftL1ldSPGrWxuEzkeYIyyOHMlMF8sb+IEsMbZkwlvjn?=
 =?us-ascii?Q?T5sr7MhXhoFsFTxJbbYMC2Ld+H1qI334qWBC/P0DSmg5A6AWIvfZ8gNnz8th?=
 =?us-ascii?Q?+6FXtSsbhNsXjXIQbGy2jGKwUSdYBxeH4z7m/PvyIVQkklvYggI+uqpATu0H?=
 =?us-ascii?Q?Phx8ZMrBb8l5JYZqaDyjCHXTFm60Je34ixJ+jFSN3TRve+yU4rL9Yv/eQEep?=
 =?us-ascii?Q?qe35/or0xp3ktJWZ2mJzrDVoGL+0FvKZ/fPejiNQ3msEehEitz1a3dkhMllg?=
 =?us-ascii?Q?7iY68Gf8Hum5eZuHn9XOwUaDoT6atMaRlUYjcwi8CHqKLTipQwzBkTFrGhr+?=
 =?us-ascii?Q?0sTD3tGcO8mLg90CBzzA4RNTnhQdL2w+iBEI41GSGRkCAsqEHZi4e+PcOpKY?=
 =?us-ascii?Q?tSozhkILymksEqQEP/AG+j7vdFjmxF5mS+h5+AXxCmXaRESAfkNmMbe4bHpp?=
 =?us-ascii?Q?pzeNU/JSmnEuubP0W2oP6MB6awN3CPbNU5UVSTXtF6e2HrkaMgCZeqRfiLut?=
 =?us-ascii?Q?nBPsmwYGC3ISu8Q6r8PFCrsebjR5WhIkw6Qy8pTcaJHH2EcayUaJGQk8iHYm?=
 =?us-ascii?Q?kEsv58W6eZpJrUUn3nD411J8t7jJaXh83nsMVkLHeVDiTBUjP8ASAlGEY/+Y?=
 =?us-ascii?Q?M6bbwenxP1Bs6JihQjYLSPTYu5X3VIQfMPAHN4sg3HZhB0m0AzRm2tMJifSk?=
 =?us-ascii?Q?Q2NtZa4SihrFqVds9hBHpth9NrYK9L8vgphJsFdjAZoQd2JzOWE8wIqY+peD?=
 =?us-ascii?Q?aDXzhCHB7GGu1JyHjeLi19aPSb/b0k+rYu9i7nussl+HsJUTPGIvtlv7WakM?=
 =?us-ascii?Q?aYAAXPBTdEjflQ7K5wbv4u1GPXMiBpczxzIqaKIvqbZs6gyfCQSsJ9SFACdl?=
 =?us-ascii?Q?8iE+Uhk6P81BtVvuXSApfgss6BWnCXZPKrjZgMGvuAX/UYHbl5lHCygGz3sf?=
 =?us-ascii?Q?Z9A2h41rHrXafhO/oCHW0yYSsyvkyfk7Y5nO2zmxi4DfPLh6ywGLMWFReWcB?=
 =?us-ascii?Q?B0vI64uMF+ar5mK9UO8mSl2fq4phZhu2RqLPvPBfvGy7Tg0sd7cutkiZ4DNh?=
 =?us-ascii?Q?6+XC1j0KnhqAI91IicpmC9AlPJ4alnvpWxwUAn7YHOLttioREhRxuScg0XFe?=
 =?us-ascii?Q?Xu7I/EhPua83oFJMHbm39QDBa7uNt8kGDhk5XJGs2fhKTcnRUe0MXn02CaFL?=
 =?us-ascii?Q?mDcNgfwEvkfcS1mkzHCyY/RAwILk98ynTSqPd4mzf0touMZT95KClfevtM7G?=
 =?us-ascii?Q?gW1dzZjk24AdLlnSbHJrqWK2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a281a763-0b12-4728-d023-08d953d61ba0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 03:48:50.2102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfQeWgEjIWnRO7PEVXiiNKFfkpSvaMyp2D0fi793y3hd5ZTQMh1sGCDcB3CRFllnHSof3hbb4BDgrRHjpr8dXi/yTTJCu+8UjU8bLR/Cuw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5643
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=992 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107310017
X-Proofpoint-ORIG-GUID: JabGjvSP67gLVvdUZ_Yd3y9QaaNp2wcn
X-Proofpoint-GUID: JabGjvSP67gLVvdUZ_Yd3y9QaaNp2wcn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Vincent,

> Allow UFS suspend/resume callbacks to run in parallel with other
> suspend/resume callbacks. This can recoup dozens of milliseconds on the
> resume path if UFS hardware needs to be powered back on.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
