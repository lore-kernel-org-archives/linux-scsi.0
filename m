Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C9CC5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 20:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbjAIUFy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 15:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbjAIUFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 15:05:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C6F1741D
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 12:05:24 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309JvNqM027770;
        Mon, 9 Jan 2023 20:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=aaNWGoiHENU2RXFsBPHi6EW4QWWsWB0e73UPhDcJBGw=;
 b=KBtFw60zmEdKWxRBnl1UABzCwHQfAKPxoCrnqLLzB7DWukSRuIh0yNEi/sK2ET1RK+np
 YBNDOeZIxbdbDrMcwga/jkXU4CuLoDwlfvs5ChFd2TU9luIFLo2Mc7VV4JVibQbSC2Uq
 tY6bt5r3d5LsyoARDG17ggmryN8LufoRRiZLB+zCDxa2ylb2xq0lvjt9eJT2ok+7TNbI
 8frSUKSn1SpkkQc/KOtrOR/Plh7VW26bxngCqlmixWxipTdYgIiXXCUdcOfPgtvqHMQX
 O6YjmHeTu68te9FmOQ7c+zzAkaSQBoW6wuM69xcZBLucfEUkn/XW2UzjyUgIwsecUVkU Ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0scbppm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:05:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309JZjFA017612;
        Mon, 9 Jan 2023 20:05:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy6aqffu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:05:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eb/49MedSs1LwsMq+Olez2BM4PCTA7fTbTdRJ1Nmv4X4Y2Sqj1pznwy2TbapFFLaG4Kf/Qq44sDhbMZvqplqyw/qLalJXH4oYpyWSdchO7ridT5IrPFOEec56d7OpyK83/f+4JS3r5yNai5777CU2cAMXSgx38uaHEw/dHMYiXyz/zpjm3r+rMNLWvf3XzN3gZP1Cl6K/KMQoLxpe98w0HHCfFGuLKcuVlBjmq8Y/w349tEuvFSdM2EP/En1YuKzo68B+4q07dlh6DtMMu2kpE/WirJM0O+XclgW98yB7kyFs+UrwZhGSrt+G9QhcAFTrPhV/VZWV2pg2cGmNgLnCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaNWGoiHENU2RXFsBPHi6EW4QWWsWB0e73UPhDcJBGw=;
 b=eG4AXjZryVAyQWKyMD7whKQdu4qiqeG9NenUm3O0f5yhmicx+9QqRJKfiJGy8ho/HewOWMMyO+idXm/Q2zzMRgSbL5gyhYm5Jjrm2V4BNP+0rtjTwOo5so8n0RzBjBu3nGcWh87uiUhEaAtmOB7bzcRbtjEShCQWjeKdtvCLxIAoKvylDvel0ivGyfPIwEJQu9bLWtmd4g5FUcuh7RoW9pOPXPYcbLXFyuHsuq/WuBuS08q3hSDqQ3mbm4bZh0pbzb7Uzn4del43Ehjl8v1x6NhQYRlqW0wZaT/ZZiiVL9pNMqOrazGkVXRC/uomK0jOz53uIOujkodonCyw4LDV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aaNWGoiHENU2RXFsBPHi6EW4QWWsWB0e73UPhDcJBGw=;
 b=v5qFoRI56I31+latBQkLymhevkGngtcQ1vje+Chgd2kKG7/IDtQ0wpJspMxAvo/7WG6mDUsts2dHr8lTUqLyCYLhcn2srjdMEc3c6sI6VnqrKU8Bvs21f87qEkTyCCzGlW9eY6DYIiDiuu/MnglzJKIyj7qzheTlUPg51S4eIto=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5191.namprd10.prod.outlook.com (2603:10b6:408:116::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 9 Jan
 2023 20:05:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:05:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 01/10] qla2xxx: Remove dead code
Thread-Topic: [PATCH 01/10] qla2xxx: Remove dead code
Thread-Index: AQHZFb91nEtfetTMLESptu+fuwXJAq6Wn+QA
Date:   Mon, 9 Jan 2023 20:05:19 +0000
Message-ID: <71DBCE78-AAFD-4BE6-B75D-2194324106DC@oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-2-njavali@marvell.com>
In-Reply-To: <20221222043933.2825-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB5191:EE_
x-ms-office365-filtering-correlation-id: e501963c-3ef6-49a1-4ace-08daf27cd54d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ziZcQgQjBvQJ+5KvvmdbqA6s8pOR0dl7z3fENr+lQbRC1AWQQUQDHb6P+HSU/7vekmMxYQh7KcNVhBZDm3+KFtSGVbMtDKn6R6RbiBNh/4RPBh+2B5cGOEC+ku7cDn5fwqO2vmbsmv9RFFEX6m1ZOCJ6GKMVXmQZOhvP4g0fgGoTzc25zw4yTWx+Md6T6omX6OJOTL18hDx0ffkMjEPGCn12AhlNGGoQv8WyGn7ZQJcSPNkJNrwuqIAv0LaYlGPJeHzWfHxxlsrQxsQBiMN4CyRtdV21oD88gpr0KwWEjCMvYIzfoMkOlP3Qqnbc0Sp+tnNFlKJPbIpce4amxm9OrgkpShb8fOpn+nw0Bqerk20f8gBXUpWym3hAHoSEBwVEkThyGrDuy1mNgdELKd39mMQRgXE1cLVe+hVU9TMctGK5pqw2gwJvTOONmHGbfemaAjh1e6Xw9xg9csfOEOKzm49cnxe25UEueGW8yWNexpRch80c2FGlmVFq9AQTXez/bK2Kc252MdLeqmrMXlK/UjoKRVneQ+na6/kKyK03+Rx8CsEEgRRRD8LcMeWej/1nmECmXPp34EV//84x8BUWNJGYb4QX5hqYeOyll0ZFRnCUNtEdrH/xSP9of4O+mlDUiYzUgKp7xcNdGRiy9J/Kb/n8xaRvQ403ANxSa0L7iNj/ur9e/EPgZ0n5Y4ApcF3yZyvf4yn5X58gLyxJhvfF7MmrjbrlGp8VEOxFjEMWddg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(122000001)(2906002)(41300700001)(44832011)(8936002)(5660300002)(38100700002)(186003)(53546011)(6506007)(478600001)(2616005)(6512007)(66446008)(4326008)(6486002)(66476007)(8676002)(64756008)(316002)(6916009)(54906003)(91956017)(71200400001)(66946007)(86362001)(66556008)(76116006)(38070700005)(36756003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ih/8AvCOvLx+CRzTj8vAEMKY/OVLGJqz92FZMT1u/n0bRYZELaExFM5/dsN/?=
 =?us-ascii?Q?o4ynPM/zChSI3Omo6/OIaj+KkID/znEZEaxxTdPu7BQip0Oo2IWQhah3uubm?=
 =?us-ascii?Q?vuxQMvjCm8QGNOhyx5v87lbXd92x2tU667XaxDEzn93iBxbyNFUqHK93xORh?=
 =?us-ascii?Q?BjzphiTO27Vj6qGNJTfqe4z+I/4X6IjU02hPgiiV5wRl/a/GemdIX6OAQ8pE?=
 =?us-ascii?Q?u0aZ53vcxKQ/bXwgI/BYqPjq4NDg2u8WyiVHqLkd6L1RcqYaZxUrWZpCTvqr?=
 =?us-ascii?Q?T0HhAYLYzoBuo5+8Mo5/If9IF1idvAxijBSghfak2Ao3I4xR0CWVpJUX7HwI?=
 =?us-ascii?Q?NBETE8k6Hkx77UWwdLWGRusYzNbCgU54lviAyaFlWJP4BKKVSgoK+E9/S1I8?=
 =?us-ascii?Q?OztUncBbth8TTgIHdbfhVcfu0W8nSNuJSxsaArAom8ThuUjpgX9sAWKbMIDs?=
 =?us-ascii?Q?pHvc5J+PYMPqlYysCy0DJnkIC+tlCOMImBCrFLlZe/u+bmWH6hdT7c8D+5xH?=
 =?us-ascii?Q?Nw2zWcKw/DGt+nwgAkYGDzlgUl4SVYcve37LxQTi+LxYwAw4cE5IM3r+5qfd?=
 =?us-ascii?Q?MDzHzzMlMRxIw2SlxnTQjHteprXdNMZBIcUTuoUxgTQx0KhINFZidYrRmXXK?=
 =?us-ascii?Q?Xyi9lZet89IjR9smkFVm895FsUbqKgS4uH0ihaap6tc7q3uHhHItpAb3hbfJ?=
 =?us-ascii?Q?UTIhEO5t00dRRmyXIsjfN5UgJUipMwFZfpMBABIr64TUT5zluFzkZ5E7Ln+g?=
 =?us-ascii?Q?HDawUr0k0hREBT7OrR7aQLLyru5nCnk12V7EgYqu7sK5ePk1462EQvt8alnH?=
 =?us-ascii?Q?Y1qkMAq3b7AE0P+F7FXfviC+hye9nQvJgpMh2XJjIqUwTZS1HWqM2ymhtMb4?=
 =?us-ascii?Q?ugHumyQHrZ/9uF/Jz0fXMNd2PR6x9Qgz3dw18rXnQMJE9xF8jBldJa8uGkg1?=
 =?us-ascii?Q?GNDuSwsIcKvveT8/bMsDtl3t9h/bE17aRaNVDXu+vxWO3pAzHFtBZQ7qunxv?=
 =?us-ascii?Q?et+mxdq/7IERGEM80uNzJGlT5Dvi6RD3V8uwBIqd2dEWxiSZlR8yckZXgGIc?=
 =?us-ascii?Q?5Ozw6MciOM7Qfhb8/5aS4JBHlWYStQhYSK2dk3OncUIEnIitSDyKKUvpJffc?=
 =?us-ascii?Q?SM2GhJtfkccDByPUpgW6xcrGqPLsu+oMAtj5Zeo8KcY4LPhfSrg4Byig7Z5K?=
 =?us-ascii?Q?ytXRp8lCH5Ml3PmRnGo1+TMFBUYfLXkbn8I8fZm0zTB5sucMg1MMpmAI4/RQ?=
 =?us-ascii?Q?kr7ouVcNDyCarGT0+nYfrN8Ba7WjE4gjHTyhuMEwx6TVU5bzO8gH1IhKLIRV?=
 =?us-ascii?Q?AOEYVlPwMRw6awh48/CoSwxdYY9eIW3HPHWvgQxQmh5xKKZvpQrLcXW7HB4f?=
 =?us-ascii?Q?RX580UbhXsRNwE3YNURdsSWea+AUCYmbsRFVJWNhAv+3vobHR1KExZqHJeXA?=
 =?us-ascii?Q?G0Rwrw+ISaepZQmr5mica2txpbbATjWyZROFC6e80PT5R4Ol3Se+zM0LU4AG?=
 =?us-ascii?Q?Hl2Ad65ItsKmXMs+RP6gXCVVCFkDgUZROaemfgH8idt2i60XUhWceE2vxajN?=
 =?us-ascii?Q?pydXw7LS/SVIoxQrcx5uwLm0XfQDRmvA00fOELIe9Z63E9831ouGosWC8sy2?=
 =?us-ascii?Q?y0QrqMFufXn1WKzRjamyoDprFjmKgVawyew9DNuKlTHKYtqGCR6bDa65akVY?=
 =?us-ascii?Q?wGCzCPVbbOussi14H9m1gVl2jZg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3BEA596C4D06B47AB85F48D61428C1B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xgMBtyJojrVoFPW/4ugSzbTrt6t3Yicm117oYzvRhmTBZsGEcqfHReUQmUaLCFt28ji+rK4uGuLc1A1BBrhOpkDNsqvtPHzT9xwqV8HNoLi4VLoOAh3gsyG8KVZpsGYP2Haz6c+1xPS4VQDUVbyeJM5BvGO8E8KKtj397I7TXjpdQSv28WxTDOvCLmfF7qUi7CzZ+8BjfP+1K+w5YcNh+0fBNpB/LhcEx848nMNoJLfVcn8IV0dyYKDiWbjA/K/exMDUJaXdXZB0E7oXP2+HC3dQ2BgYCumYPv8etOgKjx/i7sTjS5hzapxukF+4QvX5SZs2K/pLvqZSTDULGlLuHtof4NCzOOtUoGg8vPw+cbuxA4usoxKGYcArkTR/UrV9f7HEs8m9+ewqA/kq9+NjAIRtltyDGubAna565yfR/KwOGLzuerDS26PYz+jfI69IfWVDT0Rj5L2lscmWQjRYmwPj6Dsle/obxTD8Vp15PpemeI/3mcLjukSA9FOePfUyJZnqBhxrYt2ObVqT2xmT3P+xIK8pwOSa9PFCfmkPLTrt2lV2EDuZ0CkpbOKJ03z0CUjYDP/BRQ/VpPDHzLia32jjw48yGE1g+C3vSAr0blxinDAEqT0o+ZJ/Omay+hZrxjd12dRFVy4cGs1p9FEFyNMYrYQKVQ2NeftJVkgcP0YY9DY1DYDtteW2e1i3MT/Jlj6KRPIl+IcvA+m6U83M3ETCbAhwF6eQIwXduNV5WwFCfPjll2DrT1p3FBNO9rUAbyKF/3OhW3KQrEDpWsU4xb0ton58CLR5gdyBJtjTZGQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e501963c-3ef6-49a1-4ace-08daf27cd54d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:05:19.4200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aOHMq7e7FyESnqyPCgXHd/QeYUJpSVZ9yijlmwYOXzVDbuLXoE5h/QU2qyi/Ubim+ynGcnYQCfj9fO6YKpffku76oKIKRU1In5KIVyak5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5191
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301090141
X-Proofpoint-GUID: dYqgW1JJ-xznWRV8Wqy5qt93xJsB91xz
X-Proofpoint-ORIG-GUID: dYqgW1JJ-xznWRV8Wqy5qt93xJsB91xz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 21, 2022, at 8:39 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Removing drport field and FCPORT_UPDATE_NEEDED signals.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c |  5 ++--
> drivers/scsi/qla2xxx/qla_def.h  |  3 +--
> drivers/scsi/qla2xxx/qla_init.c | 48 ---------------------------------
> drivers/scsi/qla2xxx/qla_mid.c  |  9 -------
> drivers/scsi/qla2xxx/qla_os.c   | 13 ++-------
> 5 files changed, 5 insertions(+), 73 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index fa1fcbfb946f..6a4bc59d6525 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2732,7 +2732,7 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
> 	spin_lock_irqsave(host->host_lock, flags);
> 	/* Confirm port has not reappeared before clearing pointers. */
> 	if (rport->port_state !=3D FC_PORTSTATE_ONLINE) {
> -		fcport->rport =3D fcport->drport =3D NULL;
> +		fcport->rport =3D NULL;
> 		*((fc_port_t **)rport->dd_data) =3D NULL;
> 	}
> 	spin_unlock_irqrestore(host->host_lock, flags);
> @@ -3171,8 +3171,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>=20
> 	set_bit(VPORT_DELETE, &vha->dpc_flags);
>=20
> -	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags) ||
> -	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
> +	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))
> 		msleep(1000);
>=20
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index cd4eb11b0707..0dde3fa9e258 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2596,7 +2596,7 @@ typedef struct fc_port {
>=20
> 	int login_retry;
>=20
> -	struct fc_rport *rport, *drport;
> +	struct fc_rport *rport;
> 	u32 supported_classes;
>=20
> 	uint8_t fc4_type;
> @@ -4876,7 +4876,6 @@ typedef struct scsi_qla_host {
> #define ISP_ABORT_RETRY		10	/* ISP aborted. */
> #define BEACON_BLINK_NEEDED	11
> #define REGISTER_FDMI_NEEDED	12
> -#define FCPORT_UPDATE_NEEDED	13
> #define VP_DPC_NEEDED		14	/* wake up for VP dpc handling */
> #define UNLOADING		15
> #define NPIV_CONFIG_NEEDED	16
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 6968e8d08968..ca216b820b1c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5224,27 +5224,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
> 	return (rval);
> }
>=20
> -static void
> -qla2x00_rport_del(void *data)
> -{
> -	fc_port_t *fcport =3D data;
> -	struct fc_rport *rport;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
> -	rport =3D fcport->drport ? fcport->drport : fcport->rport;
> -	fcport->drport =3D NULL;
> -	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
> -	if (rport) {
> -		ql_dbg(ql_dbg_disc, fcport->vha, 0x210b,
> -		    "%s %8phN. rport %p roles %x\n",
> -		    __func__, fcport->port_name, rport,
> -		    rport->roles);
> -
> -		fc_remote_port_delete(rport);
> -	}
> -}
> -
> void qla2x00_set_fcport_state(fc_port_t *fcport, int state)
> {
> 	int old_state;
> @@ -6761,33 +6740,6 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *h=
a)
> 	return rval;
> }
>=20
> -void
> -qla2x00_update_fcports(scsi_qla_host_t *base_vha)
> -{
> -	fc_port_t *fcport;
> -	struct scsi_qla_host *vha, *tvp;
> -	struct qla_hw_data *ha =3D base_vha->hw;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&ha->vport_slock, flags);
> -	/* Go with deferred removal of rport references. */
> -	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list) {
> -		atomic_inc(&vha->vref_count);
> -		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> -			if (fcport->drport &&
> -			    atomic_read(&fcport->state) !=3D FCS_UNCONFIGURED) {
> -				spin_unlock_irqrestore(&ha->vport_slock, flags);
> -				qla2x00_rport_del(fcport);
> -
> -				spin_lock_irqsave(&ha->vport_slock, flags);
> -			}
> -		}
> -		atomic_dec(&vha->vref_count);
> -		wake_up(&vha->vref_waitq);
> -	}
> -	spin_unlock_irqrestore(&ha->vport_slock, flags);
> -}
> -
> /* Assumes idc_lock always held on entry */
> void
> qla83xx_reset_ownership(scsi_qla_host_t *vha)
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 16a9f22bb860..5fff17da0202 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -384,15 +384,6 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
> 		}
> 	}
>=20
> -	if (test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags)) {
> -		ql_dbg(ql_dbg_dpc, vha, 0x4016,
> -		    "FCPort update scheduled.\n");
> -		qla2x00_update_fcports(vha);
> -		clear_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
> -		ql_dbg(ql_dbg_dpc, vha, 0x4017,
> -		    "FCPort update end.\n");
> -	}
> -
> 	if (test_bit(RELOGIN_NEEDED, &vha->dpc_flags) &&
> 	    !test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) &&
> 	    atomic_read(&vha->loop_state) !=3D LOOP_DOWN) {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 2d86f804872b..078b63b89189 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7025,11 +7025,6 @@ qla2x00_do_dpc(void *data)
> 			}
> 		}
>=20
> -		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
> -		    &base_vha->dpc_flags)) {
> -			qla2x00_update_fcports(base_vha);
> -		}
> -
> 		if (IS_QLAFX00(ha))
> 			goto loop_resync_check;
>=20
> @@ -7525,7 +7520,6 @@ qla2x00_timer(struct timer_list *t)
> 	/* Schedule the DPC routine if needed */
> 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
> -	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags) ||
> 	    start_dpc ||
> 	    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) ||
> 	    test_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags) ||
> @@ -7536,13 +7530,10 @@ qla2x00_timer(struct timer_list *t)
> 	    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags))) {
> 		ql_dbg(ql_dbg_timer, vha, 0x600b,
> 		    "isp_abort_needed=3D%d loop_resync_needed=3D%d "
> -		    "fcport_update_needed=3D%d start_dpc=3D%d "
> -		    "reset_marker_needed=3D%d",
> +		    "start_dpc=3D%d reset_marker_needed=3D%d",
> 		    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags),
> 		    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags),
> -		    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags),
> -		    start_dpc,
> -		    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags));
> +		    start_dpc, test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags));
> 		ql_dbg(ql_dbg_timer, vha, 0x600c,
> 		    "beacon_blink_needed=3D%d isp_unrecoverable=3D%d "
> 		    "fcoe_ctx_reset_needed=3D%d vp_dpc_needed=3D%d "
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

