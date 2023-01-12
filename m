Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891CFC61DB3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 04:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbjALEwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 23:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236674AbjALEv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 23:51:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB36514D01
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 20:51:56 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C3tGWF006854;
        Thu, 12 Jan 2023 04:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=g3eNT18cElO7DpBLjS9JxjFIZoBNmxIawWQWGa+AGbY=;
 b=LCUKhG5zHaPvh42dfP+UiNfUOAuOtHqJhH6xEoECFFc3Owi45Q/wbwAZUY8syFYvOnvQ
 20NRCmz4I0VGsVJ4S/csX+79VHcgPT88osyvdXYZA+HJDubCLvOhA33ZSA+JtefPxByC
 5Kss+8fSHvF5TofiaDpjqjo9gkXTB2IaBzxV06l4iq+9iFhMRBvx+zXkSgnAjZbz/Ebc
 5OVU46lfORC/zjP0GQmkJXHomloQHyw+zBV2Co1YzML0vH9YxHpeCHgt7JwHchzcD2Ug
 NfWv8WOvcP617mrYoherpZwwxpfU+Wf21rR1XN9fbGRhDQXKur2BAp4/Z7H3VlMP41lZ WQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btsfuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 04:51:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C4I1Ua022722;
        Thu, 12 Jan 2023 04:51:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4eppsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 04:51:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9c/toCbZMOrkzTs5977uDVqjdNKlT1g4DkH9g9+OmotHXqc7YmsAOhUCpaBiElB/b6K32apoHbFH5Y3BnALa8s8AYSI4hfP9I/Rz8PVHjYkMj4/l6dDUa1iANifktZc9iN/se1jypAyLNmB+6/GOuT252wwQ4F+jrcq2bd6l+JiD1QDzwBqM10U99Z8YoyTJoV7mvqi2OFaglSgBb3zaVHXCJ1YEGncale+y+619RYM3HbPXanbIbku6f8msy6978Ir48OWmEjcLsf1JA/+wZooc1fZubVcQz5RN9JPntAKmq64jFJxMqYGkr/6nUmbVmlB8jNhcdSG97thHvBPYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3eNT18cElO7DpBLjS9JxjFIZoBNmxIawWQWGa+AGbY=;
 b=Y/Po09XQviME249pNrNG/B4kmgt/FdZiNuRIqdzoHba5DkpJ7Qmy6nTD829mNo0FLjfIAP7abWRIXKuUs48p6pkx2EXjp8AwhZmRk/zItPndrvuEcXrgnJB3j++LNHMcZ71j/WInsVochZCihRgz3GojN6uB5Hl5MfctcYu0tlcY4YBmoRSi3jTQzKC+4sOpuRRLAIPRxWQKB3MUTxdpvb4LmhVqKjrckxab0RK+FIMqwjxvViHH/7Q4QUTq6vVWLEfMz7MVsBQyDfuFsr0eTLvT2Vin/g4Fkt4QIZLhlHdyzbAqmkODTj6hsnJua/1av9yXrfM6sZRHm8wV6UeH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3eNT18cElO7DpBLjS9JxjFIZoBNmxIawWQWGa+AGbY=;
 b=g7xx4O24quYkKGT5rXgwC7729z49hUmn1wGC/pwOpcqhrWe/DRbAB0CeKmYbt4EY6qvBd7iDuakH9MkjeZUhGi60FVTp9dMTbpmjguTjk2dOlvP34gMC7HCHNbuu85vlQRbHJEbp87q2D8WqJ8eHPUBus9PV9kBHC6Lbx14Nnus=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB5725.namprd10.prod.outlook.com (2603:10b6:303:18b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 04:51:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 04:51:51 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH 00/10] qla2xxx driver enhancements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0w0uzhn.fsf@ca-mkp.ca.oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
Date:   Wed, 11 Jan 2023 23:51:49 -0500
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 21 Dec 2022 20:39:23 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d3b35aa-b1c5-4ff2-73d5-08daf458b852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xiz56Zy2KfOVrdSGEd2x1JXFJj5omoqGYk4KJ7JCfEpzkcCgIlTwPCJq3ZLEanrhQAf/v7z/BDVP2m01NvTB+QC7Ve86URSw93WVvuOwWhk8ZzH+BZi6TJ2ifoMB5uRlnqvCLbBk8siLeCc4OHHnI/lIC6XkXRXy8UyMl89h/7i7vn3l6qSJbkRBIJ3BOodPGdzweyxyt/xlhcZvW6JCBq364ZGBcg8XYMVpL/9qqCmdSXz+zqDKQFgNRHDdfSVZDbPC0ddZCWdug9g8SxO6JA4L5oasHWGzYQNF5KmalpUpatiatjG4pUO7vM6LDKV+vVtqRFND4WkraPFxhc/1mQStZAhq+G+upYZCMsgW8Q0pu1QnWsQ9jfO95h2GFzCA3mb6HQif4QqwrAlqBRdO5Re/WXti4A253z2z5cFVnq6+3DfIIA21awZNDcwnwT55oN+na6YdH/LwdcvKRsTdVmA9FmfPnxPIozCn35H0dGsnkwIuVI4dxgijmU/oAsbE5TE4099lXvs+DUadHN7ewEAVtjCDuvu4KFIJhrIqPFOB2H1Scd+zFWaINdADxfGPzqTp6S47C5pR137B7Rire2rkFRMOUFn81qNgPoOTfczNOKCk5aen7u8fYCF0qGzfMnKmZZA1orTeiguLtSBSNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(6486002)(478600001)(36916002)(2906002)(38100700002)(558084003)(86362001)(6512007)(6506007)(186003)(26005)(6916009)(66476007)(8676002)(5660300002)(66946007)(4326008)(66556008)(41300700001)(316002)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bXXTJC6rNAwuS0R/79BnAgh69nIc3ccosZJhcLYz7WnN9SjAh8ecbnjO9Wd0?=
 =?us-ascii?Q?pzstOPAWP97PpfbK23UEHJgmUjfxhCazITj1dkGbjPg/HFl/bReQn+GLd/kF?=
 =?us-ascii?Q?NFayoqn0eFIJyfuJznpAkQoLlR+obtlzU+rUS04Baplu/E3C+D7fboc74Npi?=
 =?us-ascii?Q?arVgD3UZgRRirqzFoMmjnCd5zwOrgwmE6o76TLqwau3gUXRMwTlrOa4G4QG0?=
 =?us-ascii?Q?jMYP/jeajhQP9nrZi1smv3ErX0D7HgVxrq3CAH/rEVEY6OCfunG6rRm6B967?=
 =?us-ascii?Q?I7gCfYObT6PxJVoztS3Y42NOalNnaOLgQEdyUsRq+m06GVwk4+JUNC2Ks/tS?=
 =?us-ascii?Q?zbKaEQNKNkMX/ZzWibZ4d1yw/rbNoqSpuIoIPK8X0k2ZOqipkd7EzYl/yPv0?=
 =?us-ascii?Q?2PI0Rre6MrMd+llkQGBHTzmMAnjkXzvfY5UV5HoBc/6h8jN2UTjXnaxsSBjQ?=
 =?us-ascii?Q?aHEbpzOIDpkHPY1l5QTwnVDU6hBXa21nzGRed5Y68bAoELItSsPc755Di18K?=
 =?us-ascii?Q?wCh61INgXcDNKYcIzhduiuWhXxdehAfwRf7afN1npCjIkdZTRnzqv2v0XFtF?=
 =?us-ascii?Q?5BmVlj2YlKfeEBlEZmh/sHY2h+1Nw82qnT1zjo5esacgH251Nu59Q9S3O1xV?=
 =?us-ascii?Q?XmYY0vS7iSMpnsLEONoV5I2v/xZxTfShVREUXOwQUyVOxJ3kEVvz0BJRXM6n?=
 =?us-ascii?Q?1AU8cKGrwkJBCEa/1F17Vtbeluj4hr4viCZ0yUHQtFXPNlyHeSEw+2D8/OdS?=
 =?us-ascii?Q?raZ1eVbdQ0gcznLOomFCp2MzN5a9J1JlBCOvxDeAb8PGw8TnKkXgMIOj5Ktg?=
 =?us-ascii?Q?eg72GmqzxL/qZFRsC822uhkaas5wToKQGVOiaVIcMCEc8UbVJp6AgpHdSmnV?=
 =?us-ascii?Q?FUv6/Hm6TY+Ffy75/EhUL1KI8SM+MGYiuceTg2JGt30yoU9wqjid9UhEeDg8?=
 =?us-ascii?Q?Nt7HsiZP/dE8mn7Llk3D0GHmtRAlilYRrFvyodLOMYOX2yq9ReQmdGj1Q6gA?=
 =?us-ascii?Q?Y9FbplH66YuRGKXMHuRqWp8FAOW9FuOoJ+nLDXz8nfUXwOc1hsjL/sCKLYi1?=
 =?us-ascii?Q?Y/rTY49LawATOSBhGGYO9md6/EAf5sXiv+vEHO56YNiqSfoixvWa0csHTMUH?=
 =?us-ascii?Q?ThT78Ec06mpWLIz0U4affKqFylk38T4u7qdzBBlJxpHY0TUzZ5mYCO5/knVY?=
 =?us-ascii?Q?B9OEzk9UDVRxlplsOIwnPK/5IPDfv4OVFsDNhL8bRREbB/UT1zBNpsTGa4mz?=
 =?us-ascii?Q?ZorLRtCrYE1ol099MW6xd/uQYaUtbszU9A0/CwbMnNvUiuQSpShRrovflgD7?=
 =?us-ascii?Q?wAS4CEeQL5xkkatpOPIviNHmFp4m4hbRdU7oJWVQQVmYiANlKjwH+j0hTrkO?=
 =?us-ascii?Q?x0/hTLimU629BYdkL5TPI6LSo6w8E80dWqAfLT724s+kRisZpMPLsMrSb79D?=
 =?us-ascii?Q?J4+G+WsjeqCkbo6u+3/3z6yiEyqyCFW9v8d8K8WTPJX44pE1UTYHS30A7Sxn?=
 =?us-ascii?Q?+c+sP36Njn6b7CCPNta7377RZFJxv9ZDdrW0jMSQaeEoEKz9blbno0Z4zKgV?=
 =?us-ascii?Q?EggyXen54nu/rmIfJwYhOmyjamfsK82P5x8kGeUeCTuHeA8AAKj3b0xFfHo1?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZoBP6yMrMZSrmmVi+3FHAliCr7or/ziIFkAq092JxvPu5/KX8LSzpif3f9hlefSbJRGR2FMQXLB1JMVVocKFoo9FGTkaqBP8Cx1gb/3r74RJm5kLQQ3Vgwc84ge3u++OKBvfcUB/L/FL4LMC9r5gmnk3jWH/X34Vjozan4DN4SBDEZyD9dX3eNnOve1qjElRlA6PdpBqFV0ru6+o+WVffxn/me/kx79yECOMwKj4mCfteagCOdUlv7J1IeH5sPYSLLKvCohYWYQtBWgCLNbOAf0+13bgKO2eo3SsRMDsGfZOGJaCWMp7LbqD0mWn7qAkffo723xtOPUqkRurKC2o5Cj7Aouw1xsjStI1eqntvNdLyNbULJR/opbCWXhAEaX2Gka2UVkSYyQanad83d1UNv9RiWzPbVagUJCMESRqL+hX2Y7xDHs7D1rqKKrmZk5o37rEXoKUKU6TgEV5v6Unk/nayIS0yxu/lgAxc0qfO1vDubxgyenglxOvPCcsfT+AsFMIhOKXyM23H/2wgQ/CN++67kvNcElOEYY143Pmrw1EPy7cbuC1XDeliZtr52S7xbJyw5/QYUYs/tN3atyQZ1ZacAi2F9w4Na50T2YhOJbJKQqWo0xTtmPMoPjqvoHzMiD6FyIooeGoXh+7r4aL9DSJcAwyPm0cEDuKgeeIFHoEIb2RwlEUqdMd0Xf+/EvEoPZ5S5jNoGOcd51/bzY/IV8WHZnkEOWeHTaPHhkwC1V1vS5geKXfdmwNgQvkVgKUpKwLQRWgeuR2bWaBSitogdidVZ+LlsuPZcqYfAgQRew=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3b35aa-b1c5-4ff2-73d5-08daf458b852
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 04:51:51.4787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/6fqCjWj8Ys6iGriEf9VSCwt+apipsbVyEHL5xiq9jM6+xM76Sl2dh/JWyjsLt3hQdEuG3uZxnT7Pw6eHEAbZjO76wSoEMePlSBnLWFDXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_02,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=755
 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120031
X-Proofpoint-GUID: SYJ7tvsY-nKAzltQI8hYvIM_W75w19a_
X-Proofpoint-ORIG-GUID: SYJ7tvsY-nKAzltQI8hYvIM_W75w19a_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver enhancements to the scsi tree at your
> earliest convenience.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
