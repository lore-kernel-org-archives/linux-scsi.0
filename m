Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C6DC54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 20:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbjAIUHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 15:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbjAIUHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 15:07:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE5118E1C
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 12:07:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309K1vUi028676;
        Mon, 9 Jan 2023 20:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PE4eUuITQPGDfbeOVm7phYlTvJTxNV7sIpHU3Y+OO3E=;
 b=Uo/iabM1MOID1pUmzwXTPtOGHWzkWzkcM7XaK7yfAqt4B8RSZAtdoZnyclvRYt8yjuoX
 cj5L08NbsX7i6INQjt2Uv9mQOFfMDS+rjfjkbnr87Xx5C4ZpalBGxCTmnjsxV0Ak9OpD
 Y+sF0J1PqNASrilpjKy3fygdA7pXZ0zR9j45fiU0S49d5k610ldhudW21yvvGdHz0dLA
 N9VaPNxFBpKcxHRwFV/M/Nho/aA4nH94DsnQj0p6od7ufrYN4R8UV4GKQ9ucUdTIGdcC
 YM3LcY/LpanDuLabIULwMUOMwFZYcWsainl0sXUKxN+h84vlfQJ1NCp22HZ5FGlkVQ6t Sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mycxbb2wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:07:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309JGhlZ004497;
        Mon, 9 Jan 2023 20:07:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy6ag9p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:07:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llYHz6aLyk8nac7o9tc4mWjomUQ6tArattLx7eXatdFHJKolpIt+GtWRVuExiqgmeshnLmdvFbZEe+81MurqFKtJo8Vi4hM/wg17241ANFKEQDpeNkXd+I4VvXkCH72kZy3lhPLIHnQ3zEf6kAMIUnLcecRPxgWjywyVO8UtCqkvSeqj9Nom/RnBl57fJkm+JrUWlenNXIJie4Jd3yLm00IZCJz7e+YImCeGR1ziFGuW6TRzVwS1jnL/v8DNmjF2wWQs7E4kYCZ3OnzKWyDB5PaMc2f3E4fWtya3xkewzrZMiGnc2jglXe5eiKTwiObBmtQwfGZ3ae6Ubb/0k/XBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PE4eUuITQPGDfbeOVm7phYlTvJTxNV7sIpHU3Y+OO3E=;
 b=TqrE0sReQUzaET6LoOXcn7xRS4JxTb/xTIB/ezhNxWtGnDKCeOvUuX0sr9xRyFgw+bE3jkDIWbFuOMoiZv5s7Vc8oN9TkWlM66XmjyTqcZHhrdhx+KUJFx095/yJOeKo9iv4wP7wIlZaP3Nq8Sf38cZ1YOlMjQevBL9I1DSu3nDyQAAMa6+aeReG3uu8eX5oSwM9tkrTSqzEAoB2XtGdAYkpd6RqnC15bM1ij6SkL2PLPecjtp06nWDEjL7vKi9bIKoQNvaDKZT2Gcpo4pSDoMlTpbkO96s9omWjJKtd4PtH2/fxJAKbN7NF0SeW3FMwTygVLCmD91nn6t6XmnVmnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE4eUuITQPGDfbeOVm7phYlTvJTxNV7sIpHU3Y+OO3E=;
 b=Goz9cWZkdd3CBqVpIECvR2FocbyHZpTWpgdRVKSw3SHcH+i1tIjMHwR8JKraMw5lPFuZFzLheqH0IyupPtC2Kzo5IHNUTpCL+LVYLtIaOQ7iB15yzqALfL26qAIm3jl7qM5JJQ/K5F5AvltCIWWiIO72jbwvyvLZXI6yXXhpU4E=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 20:07:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:07:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 03/10] qla2xxx: Remove dead code (GNN ID)
Thread-Topic: [PATCH 03/10] qla2xxx: Remove dead code (GNN ID)
Thread-Index: AQHZFb9xHkLZoLDMUkGjM/S2APo69K6WoH8A
Date:   Mon, 9 Jan 2023 20:07:28 +0000
Message-ID: <DDDB0B86-CC89-4626-BA7F-6C81EA247348@oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-4-njavali@marvell.com>
In-Reply-To: <20221222043933.2825-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SA2PR10MB4665:EE_
x-ms-office365-filtering-correlation-id: 72f95689-bd34-4cb1-8722-08daf27d2272
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/cys9Nh5ZPXugqTu/Q6BNN0ZZcSRXCq5y/Rnql4dbEh9exs0FF4h72JdL6jJ2ODOV4xBZKdfQUgxYtPlQ/8LyMB2PqGpK/d7SuMcknF9ULCHjoVapZR1h1M/WbH5qI1ZRxUtMJ+ue+WybZwJxBZoCXLNS0/flt1LzEPcatZWX8vqzs0LJGg2CCm5pTV68HUDaU5wCx5eFDJOft6elJmdoTQUPQY5gsWiZiDfTqkA6uTo6MvNmQkSrkK8eqBeSKqJOZu/TMH9sFPM2ZvZRs4bnNXC4Jmf9BDRRQDN21GB26wH6wOcH9SxF31L5o35sXqOoYEyNbrpcyKL8X498++JeDy/6az6mJoZ06F5MI2kMiCVUZa0KU8pgelDlhOjH3WYS1cL1B2L6SwegWYaN/eOEafaDKsMnwFFzgK9GlehLi0KQcXlgTsDAfHqQhKRqLom9EOkuivOjghU9jaXYB+deNC4fA8kL/U+Q3MHuHO0d6PvuDmOKlAEUFt7rxhFSljPibyA27fQO1vkTNi7ktPe71xLbxhxv72Hu/0JC3PZP+7ZWbdxjyfgUnGmR5KwG9y6Jum5txa8bkNyldrTGiCeSnJAlPExYB2v6g3qLVEWBrCg1VZm1e1l8M7vpqgCzZefKgJpVnHQ+rkG/pNChpJKnMJYTPsWJEJVXZw/EOWidOkBCYxvU/2PQqGwTzWRSuVQz4270yW8wxkm0sX3J0M6lFgXMEKWqy2gGRkCHRjLPI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(36756003)(38070700005)(86362001)(66446008)(8676002)(76116006)(64756008)(66946007)(66556008)(8936002)(4326008)(2906002)(66476007)(44832011)(6916009)(5660300002)(33656002)(122000001)(83380400001)(38100700002)(478600001)(316002)(71200400001)(91956017)(54906003)(6486002)(41300700001)(53546011)(2616005)(6512007)(186003)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4+AFihH7wSWD+TMkj3YaedOxCyL9Y+zPwYJq7TBcxWZPFWnpeqrc1PGSUsQM?=
 =?us-ascii?Q?mLmEA4gmTQ1NfOLwMDjb2cFxvyWZb+KxBkVyDm0rNSlooioJb/VnuYhliWqT?=
 =?us-ascii?Q?O7sCQKhFBhiIGZEU/5knGngjP0CMOIq3vFnEOiWTcV9aw78XpipjNeMrtk4r?=
 =?us-ascii?Q?ILcZuC3UawwCIvE3LkIK8ashpffBrgDshShfJJ8qIG+7eJ5H9SDYJCB5ZjfW?=
 =?us-ascii?Q?YR/i18gmoX7zpRBanYbz4xEVUCsNffipf1Dz3K/pIv6GxX0gbtmJFMPGYq0i?=
 =?us-ascii?Q?MfgxWXnXKgLDcn8t3Kbk29DeKt2KXeZj2eHpZCLJ+rWwV6AuRauHCTlH/WeH?=
 =?us-ascii?Q?y+eOClooeOT6mLaSY1URVs8UJl/3aUJGSS3/zsb7kJIYzKMK7hk0bMrhEKOd?=
 =?us-ascii?Q?7xEKPx0t0MGWBLIxuC+Xb+sZ3KZijTIpw7pQg2sxkpRRs47whdrv9DnCMwlS?=
 =?us-ascii?Q?S8XmdX4cmQn2VsUjrpcUwnkjUw+FlRumDEMWoAeOdLHuDdrNvyF8ElTY4bdg?=
 =?us-ascii?Q?HCCZnMM/l4m5zVk7yYdjUQMn3kitD0kvaRvJbM/Ta7h+T2nIlrBnlDn9Tie7?=
 =?us-ascii?Q?dqvR20vAkS7+RxX0rH/3qKql4g3PKxZA5hETYstc/akCGydk8gkg9sh73v1l?=
 =?us-ascii?Q?ucvCPcOfuj5KoQPnzW06UAW6bq+lI7kdyuSJl+Bt9G7MlZ6GEhfD/TvNTk66?=
 =?us-ascii?Q?bFbttfPNwjJDh4ykXGXhTLlZXYxORWc2zuDYL+li3/o9Fj2FfmD27aA8ITAR?=
 =?us-ascii?Q?R5+GP62drDxGe2X8s1qbdxsYG+uIYzHl8gyq3Vo9EsYvneVc5lV1znzHb1LP?=
 =?us-ascii?Q?FxPjqFqi5k4WmjrbD1aREVdIDsFWEzwJJjRb++X/nY5izwZFV7vNJCyHSWVC?=
 =?us-ascii?Q?mXuPwJqYFknAUDLqlUFF/irxWbe7Bbd/NVDXLn3P+Kx03ziAGbHDuzv+8PcR?=
 =?us-ascii?Q?EeiSYJcJl5V5PNHQp3HvdvhktyApqRhM6UIfI/qm1yyJvbvx65bZxFDJOiAC?=
 =?us-ascii?Q?AP/ueV809eH7cN7cRETwu55ANIOzwzGEBLCZoYQyYbPfwpdU1xVQ1zWcSq1G?=
 =?us-ascii?Q?zNOvCZuQrKBiQj3vaQCSKdOVT/vJjRV+OrFQsv37ZE0sQV8PUguuxSvkDYgN?=
 =?us-ascii?Q?z6wyFER9wHkv0JKqTL4+9l8BwRgNLBnEUtxfpAe9mcJPxf7HqQUnZfjJPgDv?=
 =?us-ascii?Q?67vPRiql9Ic/wCUBSSqyzx7GXsRzPACV0JHq7V8iHxAg9PDDXkL1MhcmulDT?=
 =?us-ascii?Q?e7aGHCupx0DemXQmnX/4wWi2cEX4zNJt91mFfJLOvX4ERl36x8fIgbcy5pLn?=
 =?us-ascii?Q?aNG9aqmi/j3SzcB3Pm0GyrvgiG8qz56i9mo17Zc9pkt0h/8fDP9qe2uYN6aV?=
 =?us-ascii?Q?XiBDyAkyWVGQ5yDW+gcWf5410qx09QmgA9TF0bJFbOT3Zuta0BykMmU42BG4?=
 =?us-ascii?Q?pAYEHyLEvsVKMnwi0TAxZIdqpgftQrHFE8RDH9w6Vo9LRgHfOns13Wj3mOzz?=
 =?us-ascii?Q?sUDq//OzGs07UBonEWZc718/INqLAzykWjFRJuJ9c91euU9IkldqJtci+Uz7?=
 =?us-ascii?Q?jd3QPjxsylVLaF55BGYzhI+es2PLK/sUVEqmaSBxPY/rM5bmzDMoYkGqSMFj?=
 =?us-ascii?Q?Ubp1n9IOA6XJscgleHcBLbPQBUG4oWSjD0kHXfFfOoZFDiUpgIIw2FCRdyC0?=
 =?us-ascii?Q?fJ2UcEhXda0rEtyYr75Iy5e7PcE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14139419AB3EA94DAD7F338C17842BFB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: h0c1aK1IQAvDrzKAS52JhvK4fexhY3AiyTWTi3HWo18pXcV1zpd22gpAYJ/cHAJgI+8LyuWWzJp3Xz4GsBRT/zZzJAqcTP3QpGaYxG8DC4vYRVCcoomO2U4NjGLUlSukfo1GC6GQUhSTXuHLkH/vAZkn86Di3gh6kl/oMo3OrM6qUxjbRh/t57Swlr2/XI/s1iVTKYChNd97HGetFksZjk2n7MvGNRRIlPu4WFG6bMWXSUYMMGofjZIp2JSZBncg9B49bXib1rKQ+m1n3/9hByqQHd+662l58aOBdh7IAen2wSWVj3EWYGDvL8ybuXFbDadR0+IOsX79LRANXg7diQ833Pzz2/dNUQTW2YLuA2AwYrI09WriDog+u09dz0X9bYHRK2b25HPGa29LmjnnkxIuh49czRmSKJ/m4tdFyhb4fBXmrj/52wJPOzlUWzhlaT2jtCRD8NRGwL2OeVvUlInZNGEFt/fD4KbSLg9K3/9h+mPsYY409DBhUMoMXhokla/0qw78NyRFotK8pji6Lr8mwhbNSV99dFZJRfT2Cz5AdwZ2oYe/ESwEvci4hH36ovgATEbJamuBB4vGJmP+00pWm7D78qXBiz+JG/LBAyrvuz/s5zqOOjr76T+PA0NjflpqAFdmud9v+kSn6FnDSWqz6ZuRpSH+dkdDpCevoiQlL2kMrl7k8Go6qv4lc7X9BGQAXNh/hRszpD6H5n490Q4mT0OKc9TsTeuaNP7YEdT5HzBL05dtO/aH161ZH83wl0ipZZ/oNiexKGXbvmG46q29sG5FHAtwmrwU3JsMacM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f95689-bd34-4cb1-8722-08daf27d2272
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:07:28.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XVnF5lEAtHYU+0J87i5XPN8b95L71ZDFQwDdhnxNUjO+r2Y87uoYP/ecFWjxo0MGFAN2aSmrV5IOADT1lUS+nNwfXqsf/w7vJyxxchkUVks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090141
X-Proofpoint-GUID: tpzMCHDJMtQQu-vQMFAtpETZEPfA0ooL
X-Proofpoint-ORIG-GUID: tpzMCHDJMtQQu-vQMFAtpETZEPfA0ooL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 21, 2022, at 8:39 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Remove stale/unused code (GNN ID).
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |   3 -
> drivers/scsi/qla2xxx/qla_gbl.h  |   3 -
> drivers/scsi/qla2xxx/qla_gs.c   | 110 --------------------------------
> drivers/scsi/qla2xxx/qla_init.c |   7 +-
> drivers/scsi/qla2xxx/qla_os.c   |   3 -
> 5 files changed, 1 insertion(+), 125 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 9ee9ce613c75..2ed04f71cfc5 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2485,7 +2485,6 @@ struct ct_sns_desc {
>=20
> enum discovery_state {
> 	DSC_DELETED,
> -	DSC_GNN_ID,
> 	DSC_GNL,
> 	DSC_LOGIN_PEND,
> 	DSC_LOGIN_FAILED,
> @@ -2699,7 +2698,6 @@ extern const char *const port_state_str[5];
>=20
> static const char *const port_dstate_str[] =3D {
> 	[DSC_DELETED]		=3D "DELETED",
> -	[DSC_GNN_ID]		=3D "GNN_ID",
> 	[DSC_GNL]		=3D "GNL",
> 	[DSC_LOGIN_PEND]	=3D "LOGIN_PEND",
> 	[DSC_LOGIN_FAILED]	=3D "LOGIN_FAILED",
> @@ -3492,7 +3490,6 @@ enum qla_work_type {
> 	QLA_EVT_GPNFT,
> 	QLA_EVT_GPNFT_DONE,
> 	QLA_EVT_GNNFT_DONE,
> -	QLA_EVT_GNNID,
> 	QLA_EVT_GFPNID,
> 	QLA_EVT_SP_RETRY,
> 	QLA_EVT_IIDMA,
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 2acddc8dc943..08ea8dc6c6bb 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -730,9 +730,6 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port=
_t *fcport, bool);
> int qla24xx_async_gpnft(scsi_qla_host_t *, u8, srb_t *);
> void qla24xx_async_gpnft_done(scsi_qla_host_t *, srb_t *);
> void qla24xx_async_gnnft_done(scsi_qla_host_t *, srb_t *);
> -int qla24xx_async_gnnid(scsi_qla_host_t *, fc_port_t *);
> -void qla24xx_handle_gnnid_event(scsi_qla_host_t *, struct event_arg *);
> -int qla24xx_post_gnnid_work(struct scsi_qla_host *, fc_port_t *);
> int qla24xx_post_gfpnid_work(struct scsi_qla_host *, fc_port_t *);
> int qla24xx_async_gfpnid(scsi_qla_host_t *, fc_port_t *);
> void qla24xx_handle_gfpnid_event(scsi_qla_host_t *, struct event_arg *);
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index fe1eb06db654..4738f8935f7f 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3893,116 +3893,6 @@ void qla_scan_work_fn(struct work_struct *work)
> 	spin_unlock_irqrestore(&vha->work_lock, flags);
> }
>=20
> -/* GNN_ID */
> -void qla24xx_handle_gnnid_event(scsi_qla_host_t *vha, struct event_arg *=
ea)
> -{
> -	qla24xx_post_gnl_work(vha, ea->fcport);
> -}
> -
> -static void qla2x00_async_gnnid_sp_done(srb_t *sp, int res)
> -{
> -	struct scsi_qla_host *vha =3D sp->vha;
> -	fc_port_t *fcport =3D sp->fcport;
> -	u8 *node_name =3D fcport->ct_desc.ct_sns->p.rsp.rsp.gnn_id.node_name;
> -	struct event_arg ea;
> -	u64 wwnn;
> -
> -	fcport->flags &=3D ~FCF_ASYNC_SENT;
> -	wwnn =3D wwn_to_u64(node_name);
> -	if (wwnn)
> -		memcpy(fcport->node_name, node_name, WWN_SIZE);
> -
> -	memset(&ea, 0, sizeof(ea));
> -	ea.fcport =3D fcport;
> -	ea.sp =3D sp;
> -	ea.rc =3D res;
> -
> -	ql_dbg(ql_dbg_disc, vha, 0x204f,
> -	    "Async done-%s res %x, WWPN %8phC %8phC\n",
> -	    sp->name, res, fcport->port_name, fcport->node_name);
> -
> -	qla24xx_handle_gnnid_event(vha, &ea);
> -
> -	/* ref: INIT */
> -	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -}
> -
> -int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
> -{
> -	int rval =3D QLA_FUNCTION_FAILED;
> -	struct ct_sns_req       *ct_req;
> -	srb_t *sp;
> -
> -	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
> -		return rval;
> -
> -	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
> -	/* ref: INIT */
> -	sp =3D qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
> -	if (!sp)
> -		goto done;
> -
> -	fcport->flags |=3D FCF_ASYNC_SENT;
> -	sp->type =3D SRB_CT_PTHRU_CMD;
> -	sp->name =3D "gnnid";
> -	sp->gen1 =3D fcport->rscn_gen;
> -	sp->gen2 =3D fcport->login_gen;
> -	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> -			      qla2x00_async_gnnid_sp_done);
> -
> -	/* CT_IU preamble  */
> -	ct_req =3D qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GNN_ID_CMD,
> -	    GNN_ID_RSP_SIZE);
> -
> -	/* GNN_ID req */
> -	ct_req->req.port_id.port_id =3D port_id_to_be_id(fcport->d_id);
> -
> -
> -	/* req & rsp use the same buffer */
> -	sp->u.iocb_cmd.u.ctarg.req =3D fcport->ct_desc.ct_sns;
> -	sp->u.iocb_cmd.u.ctarg.req_dma =3D fcport->ct_desc.ct_sns_dma;
> -	sp->u.iocb_cmd.u.ctarg.rsp =3D fcport->ct_desc.ct_sns;
> -	sp->u.iocb_cmd.u.ctarg.rsp_dma =3D fcport->ct_desc.ct_sns_dma;
> -	sp->u.iocb_cmd.u.ctarg.req_size =3D GNN_ID_REQ_SIZE;
> -	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GNN_ID_RSP_SIZE;
> -	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
> -
> -	ql_dbg(ql_dbg_disc, vha, 0xffff,
> -	    "Async-%s - %8phC hdl=3D%x loopid=3D%x portid %06x.\n",
> -	    sp->name, fcport->port_name,
> -	    sp->handle, fcport->loop_id, fcport->d_id.b24);
> -
> -	rval =3D qla2x00_start_sp(sp);
> -	if (rval !=3D QLA_SUCCESS)
> -		goto done_free_sp;
> -	return rval;
> -
> -done_free_sp:
> -	/* ref: INIT */
> -	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -	fcport->flags &=3D ~FCF_ASYNC_SENT;
> -done:
> -	return rval;
> -}
> -
> -int qla24xx_post_gnnid_work(struct scsi_qla_host *vha, fc_port_t *fcport=
)
> -{
> -	struct qla_work_evt *e;
> -	int ls;
> -
> -	ls =3D atomic_read(&vha->loop_state);
> -	if (((ls !=3D LOOP_READY) && (ls !=3D LOOP_UP)) ||
> -		test_bit(UNLOADING, &vha->dpc_flags))
> -		return 0;
> -
> -	e =3D qla2x00_alloc_work(vha, QLA_EVT_GNNID);
> -	if (!e)
> -		return QLA_FUNCTION_FAILED;
> -
> -	e->u.fcport.fcport =3D fcport;
> -	return qla2x00_post_work(vha, e);
> -}
> -
> /* GPFN_ID */
> void qla24xx_handle_gfpnid_event(scsi_qla_host_t *vha, struct event_arg *=
ea)
> {
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index c66a0106a7fc..a23cb2e5ab58 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1718,12 +1718,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_ho=
st *vha, fc_port_t *fcport)
> 			}
> 			break;
> 		default:
> -			if (wwn =3D=3D 0)    {
> -				ql_dbg(ql_dbg_disc, vha, 0xffff,
> -				    "%s %d %8phC post GNNID\n",
> -				    __func__, __LINE__, fcport->port_name);
> -				qla24xx_post_gnnid_work(vha, fcport);
> -			} else if (fcport->loop_id =3D=3D FC_NO_LOOP_ID) {
> +			if (fcport->loop_id =3D=3D FC_NO_LOOP_ID) {
> 				ql_dbg(ql_dbg_disc, vha, 0x20bd,
> 				    "%s %d %8phC post gnl\n",
> 				    __func__, __LINE__, fcport->port_name);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index bbbdf2ffb682..c0ac6bfeeafe 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5502,9 +5502,6 @@ qla2x00_do_work(struct scsi_qla_host *vha)
> 		case QLA_EVT_GNNFT_DONE:
> 			qla24xx_async_gnnft_done(vha, e->u.iosb.sp);
> 			break;
> -		case QLA_EVT_GNNID:
> -			qla24xx_async_gnnid(vha, e->u.fcport.fcport);
> -			break;
> 		case QLA_EVT_GFPNID:
> 			qla24xx_async_gfpnid(vha, e->u.fcport.fcport);
> 			break;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

