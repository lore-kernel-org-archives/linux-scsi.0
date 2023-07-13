Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E21C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 18:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjGMS5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 14:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbjGMS5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 14:57:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B5D106
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 11:57:11 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DHiRIY016603;
        Thu, 13 Jul 2023 18:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ZoWIG9dqkKpkkxMxTc+M1zlT6hP1LhGV/bZZwHmHCr8=;
 b=AYFHm8XtxJeDJsh9rBmn3Z9LcGOjJWG5w6hwDJvLG43Q3OK4Z+WHK9yvIOjGXKzL3ulu
 QPqAyIPFwug4nVdD2FgmkAaQFmwskWeOlaGPtcDTJLMS93brEIdB/x/Ie3vzhhSvz3IB
 X5UskudQgNEsiE1tpYVkw54X1cpMI459HsdYsSB80UFKqXMBZi7GKkdePRiw+FHnoTli
 w5y0jbN1rI2zQzYJvWH2CO2ZZHvjcLLKQB7TTDGD/+tsoWZz+HGyUini+rxbclsjhkvk
 T11u6v+ZGnn7Xh3csBf23x3KwRsme2vXfWDylf8ZjgnhnxpwMQKEk4tqV95S1sb0MmEc Gg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu28tx-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:57:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DHsphv033178;
        Thu, 13 Jul 2023 18:45:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx899s8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:45:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUdr0vEetogCPK1z8/wwp6aeJKb6mfBplvvJBIpaMzCA0dpXwp46DEVFpa/VcUJS0fmpMXRS0MN9AW2sb4iOlZacibCNhAAr7wcx/GcvBudi1XsWYSr49rfong0YbAy13n6ZJ7gV/YHVHmBbhFfxmTT1kWkwDBaX15F1YFXG4CFNW9G5cHmMp9R9OmIQAWLNS0Hx0WB4PUvZeBPhJhKrpZcktQoZYjmm0kUiXDBzI9aqoLXbckIIG36tlyODOtwshgzGfITIr1G3h/EWQ3BElK35NgjvpIfzDJ+xXiijGNIvRRfoDFAIpHLoIcSbRjv5/ee32eKAqWGrxHIWj8XhzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoWIG9dqkKpkkxMxTc+M1zlT6hP1LhGV/bZZwHmHCr8=;
 b=aajEaVPKJJLRqd0BXf1Z/pbvqCUSNXDdyVjIUmoV9ZpLjv2v4puhVScCdKqQ6jDJekJAcKLaQu7Q/ZPwYdXYqw8ttm8g6kxh7KkWXZsHQavLT1gfzVKzWITQ8bDoZKvnVPb7pZv2726+0Obv8pAVcf7MtrZ91RuPC2lWbr3VmSI+sptpmKMLCLap+jR3wiLZavhK7JVMJQMQZLrxBol33CQBmbGz4kXjni35prfqvzoVHInnnS6k6loaUwOciJN/92DMwZarM0KUl7Wj+q2gmxC74JCW38TTjUIo41MncKfRrkIVTT3RFhd/4zlv3ACLV5af9caRnASdaEGESFAnQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoWIG9dqkKpkkxMxTc+M1zlT6hP1LhGV/bZZwHmHCr8=;
 b=Dmc15kDHNvQxbmvUgVF9KX7x05BcbRcOQv6mW7Mj0LiOXydkUKHoSHLfp1l7ET17IlXuRa2ptPARF9CnBAauiALEzN4s0FQQddehxrWdTeQtMYRWConLUTCsS4n7gqLnC4WoFcxPePYj3zqt+gr8N3J42yPdeUhfWqyGjdJCvdY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB5705.namprd10.prod.outlook.com (2603:10b6:510:146::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 18:45:11 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 18:45:11 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 02/10] qla2xxx: Adjust iocb resource on qpair create
Thread-Topic: [PATCH 02/10] qla2xxx: Adjust iocb resource on qpair create
Thread-Index: AQHZtKBLUrNK/MZZD0e6kp1UTl0gfa+4CwGA
Date:   Thu, 13 Jul 2023 18:45:11 +0000
Message-ID: <CBFB2352-1DEC-406E-90C5-B9857D39AF08@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-3-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH0PR10MB5705:EE_
x-ms-office365-filtering-correlation-id: 2d972002-d0f7-497d-e670-08db83d14a27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mi0BW/bD2a/v4ug1ZZM2RrWzeGPTuPFkQYQOnzNwfyZ2mt+vuFUqjVVJQcpwzvcMtUMgT9kqjsnK678hEN+vQ6DsQgagdlpkn88KyG0Ms2YNjwNt2kfukoHFb08mnpAFr84X6b2hVx18JTu7+CMQwuDCvqKlL6lRTVztJnWtJOc1zo7uT9Lr45/6HOqpWRbMWRTa/TKA+tpV4wRFNy/DCldtpqBy5Sclfu8nl149i4bKAjE1NSPb39X8NvTlD74OX0Y66gV+fgiMhfOvoS53l6Yh94G+26IjMIt36kXoJNY8/Q2ucH0JWjglDipWKmH4FkLNe9BbCB55WJ4mqGTXcY7pYMcjBiFTUPxMBbhV3OTfd0MDjRhJZaN6+FTkaDNyYDYDgqlU/bZDQelDo8Oo/1F5BvUJO7LygRg2kuETrIUUg831SeacOzlsbwB1evlHl2awDLZ9R5nc5k3BACjrunf0NdwOp0VVm31E9qeAE6+Id/OXs34Y5sfEk8sqyqyEOS48E5F7kTP87SS6ZroSONGaE9L+xOUozXYjkawMKNneWRvbXDwzgnHXpwcngi0Sq6a1ToskrjjGdYwc7GF79KkFojZbkpnFPIQcVmIGZ7YJv9WrIcRg3E1s7GHcXJrLjS/3qowphj+Us3VcCKgbRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(33656002)(2906002)(54906003)(41300700001)(71200400001)(478600001)(36756003)(8936002)(8676002)(44832011)(66476007)(64756008)(76116006)(66446008)(66946007)(66556008)(6916009)(91956017)(6486002)(4326008)(316002)(83380400001)(122000001)(6512007)(38100700002)(5660300002)(86362001)(6506007)(38070700005)(26005)(2616005)(186003)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9jdKsyIdj8cv42iEJn/4F8DLvkODANjgZjQyi0vMu96El96/o658m9qu4E1k?=
 =?us-ascii?Q?FAEDiBSNJllcA+IDy3IwBmIO9TFJXjagqis6KyJwdW/L4AOOUpVQYzKhNHNq?=
 =?us-ascii?Q?k+EpeMpgg5i1u3jFQ4JNohU2lqaMnS0zy6ywJBhMNYLfAOhg0N6/nmlI5SoX?=
 =?us-ascii?Q?gWUPc+LjfWenCNKwRIyDj7Fe2bDSsoS8oRnvD7aAAQKpa9gZ/7khI2VZJxk1?=
 =?us-ascii?Q?PdJf0RdEiPfG3lHoyElVbPTJi03ewNDvgddzqzieFpWrJ9EVz71UAFeETZDB?=
 =?us-ascii?Q?Mbz0o31cGso3f3730J97gU5NBDhg+9dAo0n1Empjr+u8UiY0varU/bJNf6N2?=
 =?us-ascii?Q?HWGqCjE5uxscqnxmutyhrRVc6ha1+qm10dLxOTWLFgCeoc4gIT5y2kfd1GnX?=
 =?us-ascii?Q?xLgs0Gisz9Euy9/bMNTYok9LNLXXXqs/38/KJBksfVyTsWyZm7AJpptFDooL?=
 =?us-ascii?Q?ppjvIFkcS5LtaX197LpEYOvsE/7NDYXxfGUjRLPmsi3kQYmjat98mUMVCbAW?=
 =?us-ascii?Q?jwKwL690BQVOXVkKXc5VQNGDbsa4GEQ5tbQnmgvThqbQApleQ9+RZ8NrxMu2?=
 =?us-ascii?Q?C63ENuhpi4N1iN/7Wju01bJwJ+AsMU43GqW0WCybOqZI7nyypzU4/XnAc58p?=
 =?us-ascii?Q?TnfJNtGeW+biEU+XG/knnigkDRBzZygO+ggcq76DTsU0SEOgdcbXMq5e8Uiq?=
 =?us-ascii?Q?+jlm8AoIBEhFctsIPfRrS2+EGbStPU9ZaM/mvEeyqx0D3nbFCyOXDUZsHpZJ?=
 =?us-ascii?Q?ppMWlYfiwKgoGsLpPSNMHyw7vSmnnUiTjf83CGjVJroZEaF28d0rSCUD4dxI?=
 =?us-ascii?Q?qkA80lJK6DY2rB7YH81DjuFavZ2Z3DMj2W1TnDPEOr807zOtygAsQw0H4zyq?=
 =?us-ascii?Q?R9Zw4/FnMA8QCfUjLXjXpg8popXSZPqZJm2jZyS2ID+K7BhC+GQBMP39VHZQ?=
 =?us-ascii?Q?2END6Y1jXV1JYkyS/dMEqD+E156tT47kgK7YNS2bTkf/vc0ZbIgCfYdy8hNJ?=
 =?us-ascii?Q?6qTvOoDgPd2xW2nDaHv0EPxpkf2VxBQmekThwMAt7AJQJ/xmGKlf/gjJiTs8?=
 =?us-ascii?Q?eipObN4hSGwzqNCTyPmxqZ5/dQgO/cz0kw+PIeJ0McKoRFBFR8bbn0O4rf35?=
 =?us-ascii?Q?zAHRZjNsTbi1nr9dQVD3fwGVnvIQMh2HdlY6STY+DOmlg1ku+3UFQmDkGTx8?=
 =?us-ascii?Q?z4UG1v0qmomSSANr3bXQyN/EAhDI5WLTwx69yLe4irreArt0fhunF49dz1oI?=
 =?us-ascii?Q?9KP1PDEn1/wrM9lV5iMXlCBwVEdmmPm3vDxWmBa00XE+U/22I4ulDge2kG6e?=
 =?us-ascii?Q?TjbZSUoyLuc4nBwiXVWRW6iNfpzEK1LWyzwdmHp1Y49o98wh8g0mQ0sRVNsc?=
 =?us-ascii?Q?JNGUgtWGKAZqz6wsoZH7gQDAWRkYbDUH1vb4DaeQSC3yVH+ukY9ZJRJYYOah?=
 =?us-ascii?Q?AqC5F+xf9R+gBjScKsmI142Gktft7pMV9SXaER1tYsnEwnGbVZZ1fAHBwb7l?=
 =?us-ascii?Q?BsrGzyyC9rPp2gyFzryI3c4xFXQDHvulcFW1cYf2uxNfhjeZt7Um1MAERSrU?=
 =?us-ascii?Q?lLVLL6jZZgVIVEnTvRpSTXcvsXXjCeiOFwE2yeCRR5dwRw9QiO19CW40ZW/0?=
 =?us-ascii?Q?cZxq1qYr55QJ4VOg+LMo4w0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEBE4FF77BD98648B11ED65A1860FAA1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: St2FhkfI0HwiNwBUFK0Ha3dxKKX7eaT4AYmduvrD8lZRLRnRF+ornN12fmUYie9grqMqpqozU1YdSuTksCiy/uoFw6M82PlLL/8TgyEOstuf8vWJmiIA5tG/Ugf14E9J7l44xyYOGrzsZRSfxq929vagM526f/QMj4Fu4XSwzkZoPPBK324DHgcWdqYTeh8WzV5mqy6UzeWZMON8SMS7FKEQHvmh0G+dWtjC9qvDjtL3JC6q24nswQZVCdjf8X7YMDuCtgAMzxmpNbOlYp23lj9yUM9tKgdQMCogtqV1BnnUwyELAmvZceS7JyxJGWR34cqVFmdk1XqI3qh2pNKmQYOSaA8bZv1A9Z2lTJaUsGAUp3QxazgCzhVshu/KXnULRlSmq0TY/Yqa8emK9mDbn6UiTpCNm8ZtxdILKzM9oNp3mc1pmBnKJ/WTu5q4UH5oT8d6H0Q9+XqzNbwpaPhTfz5Fj2BU6UgPewCkKDexkNMW0cd8QxjyvulGBESau4r6i3B4luASqde9E5Sh5Ke2APJ8pxOZUGfNGVnuy2673r9bpu5itoqKaMXfgvmtNiKIUHaufs0/k+UzA8zVnqSD1SzwNu4pyP08osrO6F7LwVqxK/SV/WbB237hEDLVVNKvo+DA4NFL7tgk7wXLABLOQjYo0og/u/LgEL1eGqsOmx3ocwifbZhP1wuyKEwMkyIcDshy3dHGkLqLtVnTvrxUgW3t94i5cJvMSB53MYbaa1KzpGGnrdlioJg7bUddGL+KbSv4F629A3uWWHJthgtxV3fSUfklxaGFSvJlqvLgU9U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d972002-d0f7-497d-e670-08db83d14a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 18:45:11.8459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aGuEy9WO1GXukwoyrg7LdQv0e/r+Dn6AeDh6DKF5ckfR7dJrA+AV+dgKASVrPGdo4s3JH2JwJEjw9wdGmn3lImm0L9iP2/IlWX/TKNTj+GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5705
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_07,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130167
X-Proofpoint-GUID: dcqwQ9Zt8W-z3Ntrvytioz77PkqI-961
X-Proofpoint-ORIG-GUID: dcqwQ9Zt8W-z3Ntrvytioz77PkqI-961
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> During NVME queue creation, a new qpair is created, FW resource limit
> need to be re-adjusted to take into account of the new qpair. Otherwise,
> NVME command can not go through.
> This issue was discovered while testing/forcing FW execution to fail at
> load time.
>=20
> Add call to readjust iocb and exchange limit.
>=20
> In addition, get fw state command require FW to be running. Otherwise,
> error is generated.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gbl.h  |  2 ++
> drivers/scsi/qla2xxx/qla_init.c | 52 +++++++++++++++++++++------------
> drivers/scsi/qla2xxx/qla_mbx.c  |  3 ++
> drivers/scsi/qla2xxx/qla_nvme.c |  1 +
> 4 files changed, 39 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index ba7831f24734..ec69b0e8f4c5 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -143,6 +143,8 @@ void qla_edif_sess_down(struct scsi_qla_host *vha, st=
ruct fc_port *sess);
> void qla_edif_clear_appdata(struct scsi_qla_host *vha,
>    struct fc_port *fcport);
> const char *sc_to_str(uint16_t cmd);
> +void qla_adjust_iocb_limit(scsi_qla_host_t *vha);
> +
>=20
No need for extra line here

> /*
>  * Global Data in qla_os.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index f8f64ed4de07..60dd0e415351 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4153,41 +4153,55 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
> return ha->flags.lr_detected;
> }
>=20
> -void qla_init_iocb_limit(scsi_qla_host_t *vha)
> +static void __qla_adjust_iocb_limit(struct qla_qpair *qpair)
> {
> - u16 i, num_qps;
> - u32 limit;
> - struct qla_hw_data *ha =3D vha->hw;
> + u8 num_qps;
> + u16 limit;
> + struct qla_hw_data *ha =3D qpair->vha->hw;
>=20
> num_qps =3D ha->num_qpairs + 1;
> limit =3D (ha->orig_fw_iocb_count * QLA_IOCB_PCT_LIMIT) / 100;
>=20
> - ha->base_qpair->fwres.iocbs_total =3D ha->orig_fw_iocb_count;
> - ha->base_qpair->fwres.iocbs_limit =3D limit;
> - ha->base_qpair->fwres.iocbs_qp_limit =3D limit / num_qps;
> - ha->base_qpair->fwres.iocbs_used =3D 0;
> + qpair->fwres.iocbs_total =3D ha->orig_fw_iocb_count;
> + qpair->fwres.iocbs_limit =3D limit;
> + qpair->fwres.iocbs_qp_limit =3D limit / num_qps;
> +
> + qpair->fwres.exch_total =3D ha->orig_fw_xcb_count;
> + qpair->fwres.exch_limit =3D (ha->orig_fw_xcb_count *
> +   QLA_IOCB_PCT_LIMIT) / 100;
> +}
> +
> +void qla_init_iocb_limit(scsi_qla_host_t *vha)
> +{
> + u8 i;
> + struct qla_hw_data *ha =3D vha->hw;
>=20
> - ha->base_qpair->fwres.exch_total =3D ha->orig_fw_xcb_count;
> - ha->base_qpair->fwres.exch_limit =3D (ha->orig_fw_xcb_count *
> -    QLA_IOCB_PCT_LIMIT) / 100;
> + __qla_adjust_iocb_limit(ha->base_qpair);
> + ha->base_qpair->fwres.iocbs_used =3D 0;
> ha->base_qpair->fwres.exch_used  =3D 0;
>=20
> for (i =3D 0; i < ha->max_qpairs; i++) {
> if (ha->queue_pair_map[i])  {
> - ha->queue_pair_map[i]->fwres.iocbs_total =3D
> - ha->orig_fw_iocb_count;
> - ha->queue_pair_map[i]->fwres.iocbs_limit =3D limit;
> - ha->queue_pair_map[i]->fwres.iocbs_qp_limit =3D
> - limit / num_qps;
> + __qla_adjust_iocb_limit(ha->queue_pair_map[i]);
> ha->queue_pair_map[i]->fwres.iocbs_used =3D 0;
> - ha->queue_pair_map[i]->fwres.exch_total =3D ha->orig_fw_xcb_count;
> - ha->queue_pair_map[i]->fwres.exch_limit =3D
> - (ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
> ha->queue_pair_map[i]->fwres.exch_used =3D 0;
> }
> }
> }
>=20
> +void qla_adjust_iocb_limit(scsi_qla_host_t *vha)
> +{
> + u8 i;
> + struct qla_hw_data *ha =3D vha->hw;
> +
> + __qla_adjust_iocb_limit(ha->base_qpair);
> +
> + for (i =3D 0; i < ha->max_qpairs; i++) {
> + if (ha->queue_pair_map[i])
> + __qla_adjust_iocb_limit(ha->queue_pair_map[i]);
> + }
> +}
> +
> /**
>  * qla2x00_setup_chip() - Load and start RISC firmware.
>  * @vha: HA context
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 254fd4c64262..b05f93037875 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -2213,6 +2213,9 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, ui=
nt16_t *states)
> ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1054,
>    "Entered %s.\n", __func__);
>=20
> + if (!ha->flags.fw_started)
> + return QLA_FUNCTION_FAILED;
> +
> mcp->mb[0] =3D MBC_GET_FIRMWARE_STATE;
> mcp->out_mb =3D MBX_0;
> if (IS_FWI2_CAPABLE(vha->hw))
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 86e85f2f4782..6769c40287b9 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -132,6 +132,7 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_=
port *lport,
>       "Failed to allocate qpair\n");
> return -EINVAL;
> }
> + qla_adjust_iocb_limit(vha);
> }
> *handle =3D qpair;
>=20
> --=20
> 2.23.1
>=20
With the small nit fixed above you can add=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

