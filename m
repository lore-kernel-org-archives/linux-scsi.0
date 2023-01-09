Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0E4C5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 20:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbjAIUOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 15:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbjAIUO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 15:14:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203E032182
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 12:14:25 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309K9UvK001999;
        Mon, 9 Jan 2023 20:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1XP3cjpi6Ghtre3XjPzNuOuIIbmL/m+G0C6H71Mb3So=;
 b=y8ZLf6YF6jiMtkDnrv8UfuZv0//ALkMnJUSLQD2Z+W3FYYRTjKT5pmGHXp9Webyls574
 DeGkEI6MF+A9WgCveNqEZ9bSfT7yJPgejGmQeT7YiY/bMemO8sOVWj7e2Us/eh4uwdI1
 /QR07CfPxhk4AyYWqRyVVCiq4tcdtzYnmK37Mnn5YZ0NIBOioekYMd7GVLJccp56mbmz
 Ce6ZNITAbVsssbOsGLoJSrFUg2WjZUV05q2o38MVQ1IMzt6BOJCG4PKsE3vkvQyJBgyy
 DhSkq1FV1DQ2qRgCDiTx1rdoLe05PKJzTsYKWZY5sqk9AcKZr7qrqe0Zx1k8m4mUSrLj XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mydxmb0db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:14:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309IO4ag035380;
        Mon, 9 Jan 2023 20:09:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n0h8un063-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:09:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGuD0GE8lQT71Ozt3XgGzAr60t19rhlQvE3r5MEZ0AxA0liN1g8Qv3gT+Nh4FVHmcwUwVIXt/VSH3fXnooArWb9uTRUKYyWd1K3KBEpkIDhGDfC/dh+rmcjf2AHPYangRvHXgtuVTEShRl21Infr/apC2EpX12FPR0gA+mCxeMiV3kCK4CBcx6HMV4w6CjbNMwF2t07sWDLkBz1+NA8f5Z5ujokVz7YUurK2tdiNmtRhGMN54pfh1dwUvsSxU0BjKzwE7S/WJJisUXiCSa1wXK7cEZH5ajP6MEDVy/GTq9u+S50t9Wjv/QXF2ZiO1Gf3DBCPBHv41K+b7R+Z9tK2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XP3cjpi6Ghtre3XjPzNuOuIIbmL/m+G0C6H71Mb3So=;
 b=YFMs8lo8ss4n1Tcgba4iKMDt+Cc19O+03zKDAh6IdbDf8eLtGVEaNah0mafVmvR51sPiE7GmwrK8UCD+foGUk12D416WffO48IEkYkOFxUrNLHKOoAxGuDHYNO4G/1SnS0CeOFFrx1pTE8pJjXnl31jCgxDeJTCuMUUrSmz1aOwkgeo40ndbpdrvBerun6gnNIwxODPpIfklrrH26ynyd6adeb6ZYNCLNGm7N52h81wl2tuirC6UFbPnDw6FSdyAsIZcuVj/1BPw880mDIHLeGBtxSwKsVjeVyBl0yrvpEwY/Pk4OBPGYZ5rllzlCsOulRQE0uV0iywDeWBPa1NWPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XP3cjpi6Ghtre3XjPzNuOuIIbmL/m+G0C6H71Mb3So=;
 b=RbqfhVcAySg8A5ODbC5JNbBBZL8IRtEWj3K19dxkDp2AZTTrNuJSCIPBXTHGT0WKLJxcjWFw6xL2tLO6sqk3rv9lyZKRjs5drOkOymTdO8hZ2+zw2Q8UtYwalPhc13l1+lerxIgm8RT1VMxM7MGe+9EZR89JhP3/vGHcrwZ42Y0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 20:09:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:09:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 04/10] qla2xxx: relocate/rename vp map
Thread-Topic: [PATCH 04/10] qla2xxx: relocate/rename vp map
Thread-Index: AQHZFb959j3yvY4T4UqFo//KeC/HrK6WoQSA
Date:   Mon, 9 Jan 2023 20:09:19 +0000
Message-ID: <329E664B-6613-4F6A-A244-17208F49E499@oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-5-njavali@marvell.com>
In-Reply-To: <20221222043933.2825-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SA2PR10MB4665:EE_
x-ms-office365-filtering-correlation-id: d104e0e0-8cdd-4192-7546-08daf27d64b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QnD1mpagVd987aIJjo0VfLVyO1UZe/psQcBokHBUp1uX27Tsm1Zi6pstmxZ6onWstz0AXllYxhVTz5yase0NoxX3XVP04qLKQg5ZbEZSLPhrFyAKINdb7Srs1xl8xJ/+znRqIoSHZMQt3p0ye0wKqsold9xeGSc3onR1Jxsm+3OuH9sfmN+ASSzi6rPjh3EBO2+BOU/gRrBGo1XvCvCGfMOM9jdMjWRCIwBN9Hbg4ImWPbYK5CDPqXyOZy6xkBbcjr2yjzOQfsedJMl4/QjIg4vk67EjO4Y4rnpGNLTG6hX3uH+Pv4xfJnlclsJ3guw39ksHbg4Ut9dpSCqeY7C8X5ZHQLPQV+coDi2OorgfMjxzZbtnAN/h/8brZNYStoztC46dnbK2ym25uzb0/WRPr7k42/puaRpL65yH4mdhUY0pqG62V86KQKA5Ryt1EMu3K+fDJd5uOQdUojcFgWtXfZW1IZ6jYPVCbJex6QBHJ9eacggPrJOhH2S40u04hIyV9XRbDGYIJhFlvors8Z75AJUwig/RByJEFMg7DBbcbj9m9Jk1zFINfAy9K/oFEcmhLFcj4XSL5qx1AYJHEDSnD4SyWkJEuo8Diw2nXVpbU1mo+0vE54MQQGIZG/51xAxxVNX3StVLHPukdDca8YC59wghi3Wnwyp+bVMr+eGUX9vrUKELV16HiAboXuwsVOi0hTOpP2BC8vmOMQKQGrvLuePd0rJjwRC/UVrGUqXMbgs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(66899015)(36756003)(38070700005)(86362001)(66446008)(8676002)(76116006)(64756008)(66946007)(66556008)(8936002)(30864003)(4326008)(2906002)(66476007)(44832011)(6916009)(5660300002)(33656002)(122000001)(83380400001)(38100700002)(478600001)(316002)(71200400001)(91956017)(54906003)(6486002)(41300700001)(53546011)(2616005)(6512007)(186003)(6506007)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qo0hghiX/gh9jjr+zHiNwiMj/xrrLlnnSsotYbJHACKpGjBqh4WKgsF1gRQE?=
 =?us-ascii?Q?Fyoa0hocvzEsLw51xlMgMoAh2yEoIi6+wAXUIMHxQo2ahS6pFiPQldv+/uXR?=
 =?us-ascii?Q?hG3uo5db1dyUGXh6ynZbU/9oQeKS7OACHg8rzS4DYBHooNF/pnRY2bTbcAoP?=
 =?us-ascii?Q?BNx/rctEt9F/mQI/lVmSkxM5kKXNez0XSR5sJAxXbV89Ek6ZwfmC5UprsSHG?=
 =?us-ascii?Q?43xohJwWgcG5Gjk2qUPC8WmeLW3KEpslrFgNNCgt6QzigBjM8wP5fsQDNQ+i?=
 =?us-ascii?Q?J4eeT8LYuHsweAhG9cxURz1ksdrKj+iJ/mP1gzVP8y6PAScRFt6PXtYUqYrZ?=
 =?us-ascii?Q?wV5asy4p+AAX0rr+rQFkGf1Fta1RAzkFlN4uwtIsCn/cLxSJZHn/4kn9dMko?=
 =?us-ascii?Q?cQ9tYa6P8Bq9zgqA9WYCZ//ELmIN+Y9sOhcEsSKGnw9+/yYJeG0AaXJzWh22?=
 =?us-ascii?Q?SGuIzOuPctkHdGk5NVWzdUpB+9T8AiuKoiUcNq+R01e0nZulmfwqxoioZ+W+?=
 =?us-ascii?Q?szRETVOGctRs3BcEDrP+7l7tBsmiB8RwoAWLqxzG9pyoB1aTct4fd8JZU4/D?=
 =?us-ascii?Q?Q5ykTZI4ojVaLG+lz9ldtZ5xTJSCXhd+R6W9HpT0AgtWPgqXmwxABKQmakLS?=
 =?us-ascii?Q?hAMPUGBEX6LfCY5Di4OPV1kIH1A2iJPkYx3XkVJ0Mb+ravY1LAQMki8YaZu9?=
 =?us-ascii?Q?ehUPyu0f8r0wpBLTjpcS89re9oy4V6iVTovqB/jhRTQVavpltR46Oh4o1WMD?=
 =?us-ascii?Q?TA1JNv+bDGcEt7NbI0dJaS3AMq/ShoF/0U4M4zV1OryiM0IatIUETfoz8uOX?=
 =?us-ascii?Q?zIm78VCG+jBm0kxMskKHe+4a7JdzF2p2vRRvYI9R8Ybn2lxyHyY7GIn8xdhQ?=
 =?us-ascii?Q?jTJ4R4OxBdqmF8nIBR/zm/N8xnnzrA4cvgZpcZ8sXnW1hqv9GgH0koHg21Zj?=
 =?us-ascii?Q?g2RRT7K/KUFaaMDzp8A05IQ/dlgIytWOM6atbzQ5AZ8Ylhg6DVm0Zl+n6dBI?=
 =?us-ascii?Q?+/W8Tm5jYyw4GQgyUXbPchyqALRIlC2bExVj0j2Vf5pJ4v9t+VgZlFatMhyW?=
 =?us-ascii?Q?3uv/bMmlMKlWRL3ZKoAvyNeyD30XXIzf0919VTFojFwp1WQd+5WK/ZnFz3SB?=
 =?us-ascii?Q?ZWM1lIPP52qkFJSoT4cN8FRXa2cJwv3OgU3xtuQ20duReOmxuwkfLWJCA0sX?=
 =?us-ascii?Q?XS7vzyg/lz3QDkiqoEbI6E7q+bkzniT1DUVXguLv1lYfOP7qGT42Korbsoo+?=
 =?us-ascii?Q?JlXavQfzYujaLr8p054xbbx5DgqoWMUrJCuK+uk3SKcQv1OH8ixa3j22kvU/?=
 =?us-ascii?Q?5UPvYkiQr0D3nBuqvTBlhSyio3zJhSx0ryO2GXrZTueNVTUuG2Np2xZ5rb+p?=
 =?us-ascii?Q?NRGiU6Li6+SodyyYZo6stMPdD71GUb2RhqifmH8WyHi34Z51zqWtVbmjdFSc?=
 =?us-ascii?Q?SWD3TA2mmy5nsRwKu0xPla2NMfO+eTXcnESAf/TRNsTWq4FKZ1yoQtq9yhvF?=
 =?us-ascii?Q?cPzQs3oFtiCTTf3oS+SPmlU5lx1QhMwuW3C/OdSK9wSJTfswLTOzGCb7liNY?=
 =?us-ascii?Q?mQQAHFHmVoZYYcny8VlWeE5jq90mkEiAX0K1JDYQw6qhhTmMMOcOh7C0bKo+?=
 =?us-ascii?Q?MmVlxGIfnkr9Rl6yN1k2PixtiHbqPQyVO8uHwiHLqjLz/heE+W81z1sn7ncc?=
 =?us-ascii?Q?lJP01PUPZUlP5QgVD0uMFQR7Oxk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67CD4F1F8A232644B15C931D1073D5E6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tmoUbieOngDukjdTqtJfvFF5RsGLx7V0d8K//4dtJFVRSXokcVFpurMdSUHz0P3QODd4/h9t/ufSn/Rf1Lw8TXtb4ei4XpXl6dhv6hjue4ao2zq4uU39kovXED1LO0jT5QqB2T1+SfDKmTPYVtQdwAvhSVOTtzChAnPiAJrl84b6Rgx1p41AcvKmIKwAYxW27W52k8vYiFh+NCxnGTkrlAqszbYWGvRuOqFT+Dq1ZHR0uxoBNiAJNk3bAkJGSmsrY7/qPCTaUDuepDzj8cv4YHwpoqda4F28rvpCNusssYm3jXHtrpDz0x+/J9Bh50fv7i7UIwN3Uqm5GP/Wehp1nXvIT/9wuGYTiO1vxMxofGO2EOZ4HhJ1rDsrYYzhrB22Xx3s3nkEq8EFDkBRuncgmP9/Q84gWBB5DMcEBpj/zXwSUA9exBRQXGWxBb3oapj9fxjVS8NRMqsmpIhiCvZMujEuc5L2PtI8sVfXOCzhieU8xAGknzpDwuiKsIIvLNrBktvtq76pq1UixD0DjlgjrSpZ4EohBeVy5B3yhjkMv6sbXcZZuXnIvP0bHf5ZVSn2DGoUu1XUW+ssihOYnm6Lf/nNrNpqouQIheNur9NnN69TOkJTX6nhmwSbdUvY2CIwQYDApxsmXnJ5xe5d0WqnNV6Ai597cKXTtJ2s1+6TGv8IEw6FYXJWZ9ZPhFvMSfcIUshiHl9zXNI876Bn/YXxntw57NufgzhQ7Aky/2jysPE3Xs3Mf3+mOXTLDLOv+OLga3jcVnZOjGtVZUA8weXyGFooh5iDEtzY1R/yl406esU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d104e0e0-8cdd-4192-7546-08daf27d64b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:09:20.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XxD8lXC4qELChKkMroHn9akMrR88TtT+LIYPz+SApw1AIgbzPVGqcBW9QrR6pK6gp/GQX5HOlG1qyCaeuXxkNODflkTCli6ARM/9J8iC1zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090142
X-Proofpoint-ORIG-GUID: 0dFNAzkffKRmMwuI2OR4lzsWMVWTT2RA
X-Proofpoint-GUID: 0dFNAzkffKRmMwuI2OR4lzsWMVWTT2RA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 21, 2022, at 8:39 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> There is no functional change in this patch.
> VP map resource is renamed and relocated so
> it is not viewed as just a target mode resource.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h    |   4 +-
> drivers/scsi/qla2xxx/qla_edif.h   |   2 +
> drivers/scsi/qla2xxx/qla_gbl.h    |   5 +-
> drivers/scsi/qla2xxx/qla_init.c   |   4 +-
> drivers/scsi/qla2xxx/qla_mbx.c    |   8 +--
> drivers/scsi/qla2xxx/qla_mid.c    |  83 ++++++++++++++++++++++--
> drivers/scsi/qla2xxx/qla_os.c     |  13 +++-
> drivers/scsi/qla2xxx/qla_target.c | 103 +++---------------------------
> drivers/scsi/qla2xxx/qla_target.h |   1 -
> 9 files changed, 113 insertions(+), 110 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 2ed04f71cfc5..4bf167c00569 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3935,7 +3935,6 @@ struct qlt_hw_data {
> 	__le32 __iomem *atio_q_out;
>=20
> 	const struct qla_tgt_func_tmpl *tgt_ops;
> -	struct qla_tgt_vp_map *tgt_vp_map;
>=20
> 	int saved_set;
> 	__le16	saved_exchange_count;
> @@ -4759,6 +4758,7 @@ struct qla_hw_data {
> 	spinlock_t sadb_lock;	/* protects list */
> 	struct els_reject elsrej;
> 	u8 edif_post_stop_cnt_down;
> +	struct qla_vp_map *vp_map;
> };
>=20
> #define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_=
CACHE_BYTES))
> @@ -5059,7 +5059,7 @@ struct qla27xx_image_status {
> #define SET_AL_PA	2
> #define RESET_VP_IDX	3
> #define RESET_AL_PA	4
> -struct qla_tgt_vp_map {
> +struct qla_vp_map {
> 	uint8_t	idx;
> 	scsi_qla_host_t *vha;
> };
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_e=
dif.h
> index 7cdb89ccdc6e..aa566cdb77e5 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.h
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -145,4 +145,6 @@ struct enode {
> 	(qla_ini_mode_enabled(_s->vha) && (_s->disc_state =3D=3D DSC_DELETE_PEND=
 || \
> 	 _s->disc_state =3D=3D DSC_DELETED))
>=20
> +#define EDIF_CAP(_ha) (ql2xsecenable && IS_QLA28XX(_ha))
> +
> #endif	/* __QLA_EDIF_H */
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 08ea8dc6c6bb..958892766321 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -257,6 +257,7 @@ struct edif_sa_ctl *qla_edif_find_sa_ctl_by_index(fc_=
port_t *fcport,
> /*
>  * Global Functions in qla_mid.c source file.
>  */
> +extern void qla_update_vp_map(struct scsi_qla_host *, int);
> extern struct scsi_host_template qla2xxx_driver_template;
> extern struct scsi_transport_template *qla2xxx_transport_vport_template;
> extern void qla2x00_timer(struct timer_list *);
> @@ -955,7 +956,7 @@ extern struct fc_port *qlt_find_sess_invalidate_other=
(scsi_qla_host_t *,
> 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
> void qla24xx_delete_sess_fn(struct work_struct *);
> void qlt_unknown_atio_work_fn(struct work_struct *);
> -void qlt_update_host_map(struct scsi_qla_host *, port_id_t);
> +void qla_update_host_map(struct scsi_qla_host *, port_id_t);
> void qla_remove_hostmap(struct qla_hw_data *ha);
> void qlt_clr_qp_table(struct scsi_qla_host *vha);
> void qlt_set_mode(struct scsi_qla_host *);
> @@ -968,6 +969,8 @@ extern void qla_nvme_abort_set_option
> 		(struct abort_entry_24xx *abt, srb_t *sp);
> extern void qla_nvme_abort_process_comp_status
> 		(struct abort_entry_24xx *abt, srb_t *sp);
> +struct scsi_qla_host *qla_find_host_by_vp_idx(struct scsi_qla_host *vha,
> +	uint16_t vp_idx);
>=20
> /* nvme.c */
> void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index a23cb2e5ab58..fc540bd13a90 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4822,9 +4822,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
> 	spin_lock_irqsave(&ha->hardware_lock, flags);
> 	if (vha->hw->flags.edif_enabled) {
> 		if (topo !=3D 2)
> -			qlt_update_host_map(vha, id);
> +			qla_update_host_map(vha, id);
> 	} else if (!(topo =3D=3D 2 && ha->flags.n2n_bigger))
> -		qlt_update_host_map(vha, id);
> +		qla_update_host_map(vha, id);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> 	if (!vha->flags.init_done)
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 359595a64664..254fd4c64262 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4010,7 +4010,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
> 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
> 		    rptid_entry->port_id[0]);
> 		ha->current_topology =3D ISP_CFG_NL;
> -		qlt_update_host_map(vha, id);
> +		qla_update_host_map(vha, id);
>=20
> 	} else if (rptid_entry->format =3D=3D 1) {
> 		/* fabric */
> @@ -4126,7 +4126,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
> 					    WWN_SIZE);
> 				}
>=20
> -				qlt_update_host_map(vha, id);
> +				qla_update_host_map(vha, id);
> 			}
>=20
> 			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
> @@ -4153,7 +4153,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
> 			if (!found)
> 				return;
>=20
> -			qlt_update_host_map(vp, id);
> +			qla_update_host_map(vp, id);
>=20
> 			/*
> 			 * Cannot configure here as we are still sitting on the
> @@ -4184,7 +4184,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>=20
> 		ha->flags.n2n_ae =3D 1;
> 		spin_lock_irqsave(&ha->vport_slock, flags);
> -		qlt_update_vp_map(vha, SET_AL_PA);
> +		qla_update_vp_map(vha, SET_AL_PA);
> 		spin_unlock_irqrestore(&ha->vport_slock, flags);
>=20
> 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 5fff17da0202..274d2ba70b81 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -52,7 +52,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
> 	spin_unlock_irqrestore(&ha->vport_slock, flags);
>=20
> 	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	qlt_update_vp_map(vha, SET_VP_IDX);
> +	qla_update_vp_map(vha, SET_VP_IDX);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> 	mutex_unlock(&ha->vport_lock);
> @@ -80,7 +80,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
> 		spin_lock_irqsave(&ha->vport_slock, flags);
> 		if (atomic_read(&vha->vref_count) =3D=3D 0) {
> 			list_del(&vha->list);
> -			qlt_update_vp_map(vha, RESET_VP_IDX);
> +			qla_update_vp_map(vha, RESET_VP_IDX);
> 			bailout =3D 1;
> 		}
> 		spin_unlock_irqrestore(&ha->vport_slock, flags);
> @@ -95,7 +95,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
> 			"vha->vref_count=3D%u timeout\n", vha->vref_count.counter);
> 		spin_lock_irqsave(&ha->vport_slock, flags);
> 		list_del(&vha->list);
> -		qlt_update_vp_map(vha, RESET_VP_IDX);
> +		qla_update_vp_map(vha, RESET_VP_IDX);
> 		spin_unlock_irqrestore(&ha->vport_slock, flags);
> 	}
>=20
> @@ -187,7 +187,7 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
>=20
> 	/* Remove port id from vp target map */
> 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
> -	qlt_update_vp_map(vha, RESET_AL_PA);
> +	qla_update_vp_map(vha, RESET_AL_PA);
> 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
>=20
> 	qla2x00_mark_vp_devices_dead(vha);
> @@ -1005,3 +1005,78 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int c=
md)
> 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> 	return rval;
> }
> +
> +struct scsi_qla_host *qla_find_host_by_vp_idx(struct scsi_qla_host *vha,=
 uint16_t vp_idx)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +
> +	if (vha->vp_idx =3D=3D vp_idx)
> +		return vha;
> +
> +	BUG_ON(ha->vp_map =3D=3D NULL);
> +	if (likely(test_bit(vp_idx, ha->vp_idx_map)))
> +		return ha->vp_map[vp_idx].vha;
> +
> +	return NULL;
> +}
> +
> +/* vport_slock to be held by the caller */
> +void
> +qla_update_vp_map(struct scsi_qla_host *vha, int cmd)
> +{
> +	void *slot;
> +	u32 key;
> +	int rc;
> +
> +	if (!vha->hw->vp_map)
> +		return;
> +
> +	key =3D vha->d_id.b24;
> +
> +	switch (cmd) {
> +	case SET_VP_IDX:
> +		vha->hw->vp_map[vha->vp_idx].vha =3D vha;
> +		break;
> +	case SET_AL_PA:
> +		slot =3D btree_lookup32(&vha->hw->host_map, key);
> +		if (!slot) {
> +			ql_dbg(ql_dbg_disc, vha, 0xf018,
> +			    "Save vha in host_map %p %06x\n", vha, key);
> +			rc =3D btree_insert32(&vha->hw->host_map,
> +			    key, vha, GFP_ATOMIC);
> +			if (rc)
> +				ql_log(ql_log_info, vha, 0xd03e,
> +				    "Unable to insert s_id into host_map: %06x\n",
> +				    key);
> +			return;
> +		}
> +		ql_dbg(ql_dbg_disc, vha, 0xf019,
> +		    "replace existing vha in host_map %p %06x\n", vha, key);
> +		btree_update32(&vha->hw->host_map, key, vha);
> +		break;
> +	case RESET_VP_IDX:
> +		vha->hw->vp_map[vha->vp_idx].vha =3D NULL;
> +		break;
> +	case RESET_AL_PA:
> +		ql_dbg(ql_dbg_disc, vha, 0xf01a,
> +		    "clear vha in host_map %p %06x\n", vha, key);
> +		slot =3D btree_lookup32(&vha->hw->host_map, key);
> +		if (slot)
> +			btree_remove32(&vha->hw->host_map, key);
> +		vha->d_id.b24 =3D 0;
> +		break;
> +	}
> +}
> +
> +void qla_update_host_map(struct scsi_qla_host *vha, port_id_t id)
> +{
> +
> +	if (!vha->d_id.b24) {
> +		vha->d_id =3D id;
> +		qla_update_vp_map(vha, SET_AL_PA);
> +	} else if (vha->d_id.b24 !=3D id.b24) {
> +		qla_update_vp_map(vha, RESET_AL_PA);
> +		vha->d_id =3D id;
> +		qla_update_vp_map(vha, SET_AL_PA);
> +	}
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index c0ac6bfeeafe..ac3d0bc1b230 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4118,10 +4118,16 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_=
t req_len, uint16_t rsp_len,
> 	char	name[16];
> 	int rc;
>=20
> +	if (QLA_TGT_MODE_ENABLED() || EDIF_CAP(ha)) {
> +		ha->vp_map =3D kcalloc(MAX_MULTI_ID_FABRIC, sizeof(struct qla_vp_map),=
 GFP_KERNEL);
> +		if (!ha->vp_map)
> +			goto fail;
> +	}
> +
> 	ha->init_cb =3D dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
> 		&ha->init_cb_dma, GFP_KERNEL);
> 	if (!ha->init_cb)
> -		goto fail;
> +		goto fail_free_vp_map;
>=20
> 	rc =3D btree_init32(&ha->host_map);
> 	if (rc)
> @@ -4540,6 +4546,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t =
req_len, uint16_t rsp_len,
> 	ha->init_cb_dma);
> 	ha->init_cb =3D NULL;
> 	ha->init_cb_dma =3D 0;
> +fail_free_vp_map:
> +	kfree(ha->vp_map);
> fail:
> 	ql_log(ql_log_fatal, NULL, 0x0030,
> 	    "Memory allocation failure.\n");
> @@ -4981,6 +4989,9 @@ qla2x00_mem_free(struct qla_hw_data *ha)
> 	ha->sf_init_cb =3D NULL;
> 	ha->sf_init_cb_dma =3D 0;
> 	ha->loop_id_map =3D NULL;
> +
> +	kfree(ha->vp_map);
> +	ha->vp_map =3D NULL;
> }
>=20
> struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 548f22705ddc..dbd6660c0bf8 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -198,22 +198,6 @@ struct scsi_qla_host *qla_find_host_by_d_id(struct s=
csi_qla_host *vha,
> 	return host;
> }
>=20
> -static inline
> -struct scsi_qla_host *qlt_find_host_by_vp_idx(struct scsi_qla_host *vha,
> -	uint16_t vp_idx)
> -{
> -	struct qla_hw_data *ha =3D vha->hw;
> -
> -	if (vha->vp_idx =3D=3D vp_idx)
> -		return vha;
> -
> -	BUG_ON(ha->tgt.tgt_vp_map =3D=3D NULL);
> -	if (likely(test_bit(vp_idx, ha->vp_idx_map)))
> -		return ha->tgt.tgt_vp_map[vp_idx].vha;
> -
> -	return NULL;
> -}
> -
> static inline void qlt_incr_num_pend_cmds(struct scsi_qla_host *vha)
> {
> 	unsigned long flags;
> @@ -371,7 +355,7 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla=
_host *vha,
>=20
> 		if ((entry->u.isp24.vp_index !=3D 0xFF) &&
> 		    (entry->u.isp24.nport_handle !=3D cpu_to_le16(0xFFFF))) {
> -			host =3D qlt_find_host_by_vp_idx(vha,
> +			host =3D qla_find_host_by_vp_idx(vha,
> 			    entry->u.isp24.vp_index);
> 			if (unlikely(!host)) {
> 				ql_dbg(ql_dbg_tgt, vha, 0xe03f,
> @@ -395,7 +379,7 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla=
_host *vha,
> 	{
> 		struct abts_recv_from_24xx *entry =3D
> 			(struct abts_recv_from_24xx *)atio;
> -		struct scsi_qla_host *host =3D qlt_find_host_by_vp_idx(vha,
> +		struct scsi_qla_host *host =3D qla_find_host_by_vp_idx(vha,
> 			entry->vp_index);
> 		unsigned long flags;
>=20
> @@ -438,7 +422,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *v=
ha,
> 	case CTIO_TYPE7:
> 	{
> 		struct ctio7_from_24xx *entry =3D (struct ctio7_from_24xx *)pkt;
> -		struct scsi_qla_host *host =3D qlt_find_host_by_vp_idx(vha,
> +		struct scsi_qla_host *host =3D qla_find_host_by_vp_idx(vha,
> 		    entry->vp_index);
> 		if (unlikely(!host)) {
> 			ql_dbg(ql_dbg_tgt, vha, 0xe041,
> @@ -457,7 +441,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *v=
ha,
> 		struct imm_ntfy_from_isp *entry =3D
> 		    (struct imm_ntfy_from_isp *)pkt;
>=20
> -		host =3D qlt_find_host_by_vp_idx(vha, entry->u.isp24.vp_index);
> +		host =3D qla_find_host_by_vp_idx(vha, entry->u.isp24.vp_index);
> 		if (unlikely(!host)) {
> 			ql_dbg(ql_dbg_tgt, vha, 0xe042,
> 			    "qla_target(%d): Response pkt (IMMED_NOTIFY_TYPE) "
> @@ -475,7 +459,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *v=
ha,
> 		struct nack_to_isp *entry =3D (struct nack_to_isp *)pkt;
>=20
> 		if (0xFF !=3D entry->u.isp24.vp_index) {
> -			host =3D qlt_find_host_by_vp_idx(vha,
> +			host =3D qla_find_host_by_vp_idx(vha,
> 			    entry->u.isp24.vp_index);
> 			if (unlikely(!host)) {
> 				ql_dbg(ql_dbg_tgt, vha, 0xe043,
> @@ -495,7 +479,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *v=
ha,
> 	{
> 		struct abts_recv_from_24xx *entry =3D
> 		    (struct abts_recv_from_24xx *)pkt;
> -		struct scsi_qla_host *host =3D qlt_find_host_by_vp_idx(vha,
> +		struct scsi_qla_host *host =3D qla_find_host_by_vp_idx(vha,
> 		    entry->vp_index);
> 		if (unlikely(!host)) {
> 			ql_dbg(ql_dbg_tgt, vha, 0xe044,
> @@ -512,7 +496,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *v=
ha,
> 	{
> 		struct abts_resp_to_24xx *entry =3D
> 		    (struct abts_resp_to_24xx *)pkt;
> -		struct scsi_qla_host *host =3D qlt_find_host_by_vp_idx(vha,
> +		struct scsi_qla_host *host =3D qla_find_host_by_vp_idx(vha,
> 		    entry->vp_index);
> 		if (unlikely(!host)) {
> 			ql_dbg(ql_dbg_tgt, vha, 0xe045,
> @@ -7145,7 +7129,7 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha=
, struct qla_hw_data *ha)
>=20
> 	qlt_clear_mode(base_vha);
>=20
> -	qlt_update_vp_map(base_vha, SET_VP_IDX);
> +	qla_update_vp_map(base_vha, SET_VP_IDX);
> }
>=20
> irqreturn_t
> @@ -7224,17 +7208,10 @@ qlt_mem_alloc(struct qla_hw_data *ha)
> 	if (!QLA_TGT_MODE_ENABLED())
> 		return 0;
>=20
> -	ha->tgt.tgt_vp_map =3D kcalloc(MAX_MULTI_ID_FABRIC,
> -				     sizeof(struct qla_tgt_vp_map),
> -				     GFP_KERNEL);
> -	if (!ha->tgt.tgt_vp_map)
> -		return -ENOMEM;
> -
> 	ha->tgt.atio_ring =3D dma_alloc_coherent(&ha->pdev->dev,
> 	    (ha->tgt.atio_q_length + 1) * sizeof(struct atio_from_isp),
> 	    &ha->tgt.atio_dma, GFP_KERNEL);
> 	if (!ha->tgt.atio_ring) {
> -		kfree(ha->tgt.tgt_vp_map);
> 		return -ENOMEM;
> 	}
> 	return 0;
> @@ -7253,70 +7230,6 @@ qlt_mem_free(struct qla_hw_data *ha)
> 	}
> 	ha->tgt.atio_ring =3D NULL;
> 	ha->tgt.atio_dma =3D 0;
> -	kfree(ha->tgt.tgt_vp_map);
> -	ha->tgt.tgt_vp_map =3D NULL;
> -}
> -
> -/* vport_slock to be held by the caller */
> -void
> -qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
> -{
> -	void *slot;
> -	u32 key;
> -	int rc;
> -
> -	key =3D vha->d_id.b24;
> -
> -	switch (cmd) {
> -	case SET_VP_IDX:
> -		if (!QLA_TGT_MODE_ENABLED())
> -			return;
> -		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha =3D vha;
> -		break;
> -	case SET_AL_PA:
> -		slot =3D btree_lookup32(&vha->hw->host_map, key);
> -		if (!slot) {
> -			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf018,
> -			    "Save vha in host_map %p %06x\n", vha, key);
> -			rc =3D btree_insert32(&vha->hw->host_map,
> -				key, vha, GFP_ATOMIC);
> -			if (rc)
> -				ql_log(ql_log_info, vha, 0xd03e,
> -				    "Unable to insert s_id into host_map: %06x\n",
> -				    key);
> -			return;
> -		}
> -		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
> -		    "replace existing vha in host_map %p %06x\n", vha, key);
> -		btree_update32(&vha->hw->host_map, key, vha);
> -		break;
> -	case RESET_VP_IDX:
> -		if (!QLA_TGT_MODE_ENABLED())
> -			return;
> -		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha =3D NULL;
> -		break;
> -	case RESET_AL_PA:
> -		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01a,
> -		   "clear vha in host_map %p %06x\n", vha, key);
> -		slot =3D btree_lookup32(&vha->hw->host_map, key);
> -		if (slot)
> -			btree_remove32(&vha->hw->host_map, key);
> -		vha->d_id.b24 =3D 0;
> -		break;
> -	}
> -}
> -
> -void qlt_update_host_map(struct scsi_qla_host *vha, port_id_t id)
> -{
> -
> -	if (!vha->d_id.b24) {
> -		vha->d_id =3D id;
> -		qlt_update_vp_map(vha, SET_AL_PA);
> -	} else if (vha->d_id.b24 !=3D id.b24) {
> -		qlt_update_vp_map(vha, RESET_AL_PA);
> -		vha->d_id =3D id;
> -		qlt_update_vp_map(vha, SET_AL_PA);
> -	}
> }
>=20
> static int __init qlt_parse_ini_mode(void)
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla=
_target.h
> index 7df86578214f..354fca2e7feb 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -1017,7 +1017,6 @@ extern void qlt_fc_port_added(struct scsi_qla_host =
*, fc_port_t *);
> extern void qlt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *, int)=
;
> extern int __init qlt_init(void);
> extern void qlt_exit(void);
> -extern void qlt_update_vp_map(struct scsi_qla_host *, int);
> extern void qlt_free_session_done(struct work_struct *);
> /*
>  * This macro is used during early initializations when host->active_mode
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

