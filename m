Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1FBC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjGMT3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjGMT3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:29:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669222D6A
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:29:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIjQYX004045;
        Thu, 13 Jul 2023 19:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8slwr3xpkw0UHwsJ9cQYPUf59hfxS7ENdwU63FR/4Ew=;
 b=2cf1LioKANKVP3fCYFLhoCdq1ZBBhj7vKLzxvZrUrOSX5GKl9rbEIDlX8E9Apio8P3ct
 RR71B+ZNycaIFFx4Hpx+7TOYTKVn9Ii5LnQDzNIv0jS30NIrGIl+Hp1WgS0iy8iSFvSG
 y69rcnVzXBHxHBN0sB6fZBkepjZM1gid2HB0r1YHHA/hL7DqNOUJY//E85Zh2z9RDUZ7
 MlwaedvOWC39Z3qjjaPkTAg70L8oXel7qJKad4p9xSGPKkfvlELPuwgsYP2/0e/os4sk
 jGVRKTKzZ9Rlz/Y+a6jr7H8VMXPanx+i6NJzMms9APN03M6RQn9DQKOWKjpiMECCCpZV Vg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpttg2rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:29:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIn52L027726;
        Thu, 13 Jul 2023 19:29:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvq1fy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMDXpMen8lybEV9xHJX0A09LzvxlydkDDfMzWh6gLSOC/MFADDESLYaJAsccRAX4xqV6XpQUE+RSS3zmKsSYrx4VNFnKJJlh4T27KTgsN01+dDY8Bgo273Aidcae7TkrbWvSADVV7TY3BQvOMylZEkx4cW7CmnYElH/NDN7QGbdoidkxccpyqRN1gZeCkduFeVqqU+lu0qVawiRHkFBNjvgOabCpI3m83TmdGqMFOYiqV2edJNSl5/tysNfZ/9LBAQ6K4/VAWHU8XSq+rc6miAX3U1e77odeSvvBOVSqc9we2kG6aXNe0/W8adOj7lbHeAYb4Na3g1XQwP7fRt9EGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8slwr3xpkw0UHwsJ9cQYPUf59hfxS7ENdwU63FR/4Ew=;
 b=Hw6ZHM9kAxHCuKD7k6y1gty57NkfDH8q+DOBXGuVpmYMyc54Pw58HrzNsDHMGE0+WakfKSdfG6rhoBGqfKtRONRP9xG7BBeAHgXgc38ATLRdQR3dgmv26XyuLqgPXc5g1xvFLNx9SJek0cJObQANZtAmE8g3CC2aR4Bm3gmBP0qbz23ecYJ/YIp28Jn9/qcHEk3p2Bj63KjPtgbzMhNdUEwQ9WIugoWregjQDWsQAXFZOoRicJNwx5BSNdYYiL4un1B9ZkqnqsJVa35QYkYrzvyXVZYBQ8sPyE0dXMLEbV4Q1NxvufU7l/Q9+MJT5dpizxblUVcRy8TkJgnLjV4wLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8slwr3xpkw0UHwsJ9cQYPUf59hfxS7ENdwU63FR/4Ew=;
 b=b9aEKZ1bIpyn93ujklb2VY1EbpaYSCOeKEhcbQef/efSQYgpyqumLwIdl59ydEDkKG9+kpu9VN0JhSEGISdQVncN1cWqSe5D9VsDPifKJ9u0yrnQQMXGFosvuBzSsYf2IKIHCKODQRPBdDnNk4a8aGPhcQr5WfIlz/kXaE6vDVQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB4936.namprd10.prod.outlook.com (2603:10b6:408:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 19:29:01 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:29:01 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 07/10] qla2xxx: Turn off noisy message log
Thread-Topic: [PATCH 07/10] qla2xxx: Turn off noisy message log
Thread-Index: AQHZtKBO/7BSFY3/TU+Xgs/WW4081a+4Fz8A
Date:   Thu, 13 Jul 2023 19:29:01 +0000
Message-ID: <EE11C8AC-68C0-47EF-AECA-51408CC08D85@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-8-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB4936:EE_
x-ms-office365-filtering-correlation-id: e83c44de-8f36-408f-5413-08db83d7695a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JKFGqOKeZJ5H6+YSx/sCvCX66AuAfAxbP6uvJmzixY7zo/PhTmfeub4FxfsDwwDWfiUIeBTkIOW/I2IexvNMY9o12RrEjGd86zg7UGt/ruWWH4i5CvtbafWoH402QtT3Z4mH3+yoz0hcbvwp9VXkGl4V7QD85yZEMkwzk24Yl7sREcQ7Kj33llpmYQjQBNZLkNsbABi1K8wHfZ90rLk6KnJ2SbfoINkcAyHSPX3rYyhPEbXX36W6xOIdJxw62uBqofelwftzdB96JeiRgJQVl21HxPfumMcNhqXzRhHM1CMnijysUIsoSnvW3jxaTohMjn5nzUWcw+QnaNVtnfWGVHdA3604eR1tPGR3IBRflhf0/le/AKs+IVxxRHkx5zqaTwI/akabFjhKPTdDF5GuX92fuaatnJiYk1yw72+RcM6J6hDyTsg93ZvPedX56nknXgBL7cpn3Y/2FpdBbfM63NWzg0rPpsgXSkafOvmyrYUL8AQLIMQkjAELQRSW8CJQnzZTjK5vShGKtp+VcuPf/nEcUnL5GYjjH0KiSm5eI7wdaQQPC1I1VIm5z0Hkqipn3MjI3hEm4kGVbhUoOs+jIGC9E32vZv+RbwlRqPybRYsmidE5ndFf/Sl5ugX1lxmb7LrXxwZqPs/PnMbjRLz2GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199021)(316002)(54906003)(91956017)(71200400001)(186003)(6916009)(66946007)(4326008)(6486002)(76116006)(66446008)(66556008)(66476007)(64756008)(478600001)(41300700001)(6512007)(8676002)(8936002)(53546011)(6506007)(86362001)(26005)(44832011)(5660300002)(33656002)(83380400001)(122000001)(38070700005)(2616005)(36756003)(2906002)(38100700002)(15650500001)(4744005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jGjiFHsE2HNsJ0drWLwPEPDrO6cADwxJ0gt3P/JPdMMmUCu8j4FtrgrB04Sh?=
 =?us-ascii?Q?jNJUPplf/Oa/wPEO6goBAN+e+IEl0QXWIvqjIqIwvszN13xVl7/9n0Wyi3hC?=
 =?us-ascii?Q?Euz0tSOiWosQFqIuGE7UPW1SeIeWpZHzxtSdYsFRV3ttGDuDPu9SlisNmEmM?=
 =?us-ascii?Q?PTj+5AI8/i/oCL56Ht5heAhJF6HwTVPTRYacrA+8qwUjWNu5RSlJJjyqalpj?=
 =?us-ascii?Q?4tPOhoKv6uhBGfeEQiatde6BdlQTNJcJ1943T+PkKwgorvkyAxZRTxlG3hpe?=
 =?us-ascii?Q?9LOZV70uiELMX/CA7w1chl6NdW6X0uOO4vuGn1yE9y5ljR3Vbs85Bg81lU3L?=
 =?us-ascii?Q?TahZcdXY4jdLnUj3XpYBW0Yr61STcujeHa79Chzckx1CLvIK75dVw0/AE2PF?=
 =?us-ascii?Q?TNqe0noB1y2Jbo45Tytb8aGQFYR+pJNk+Cb3JqL0HwJv/XLxmsmVHz1TXQor?=
 =?us-ascii?Q?k71d/9cMp+vvQjvkMis6mlhWM7HEmPgjqRVfLQ9Q38ypop4/sJp/Y2dNjoec?=
 =?us-ascii?Q?79CLU8uevyneNgp3602q8JQHgGUCqf/zr2EOFZFpSy1HM7poamsMxCowebUx?=
 =?us-ascii?Q?qVlMnbRc6aIlLe7wRjD28MumJbZgFlcKf1ngDYIYhlbvOkgnGNJXdDN+Pd2H?=
 =?us-ascii?Q?Bi/HvFzxj9KTqmB46zMfyFjwpdbdxApgZL6kqJflGu+0IN1AW8/7RztaSOkK?=
 =?us-ascii?Q?dm82LG4ZWhmkxO1aNgDzB9Or9WLBCwqUzLGcFJvIKwqqIUL1vQZjDfsT5V3W?=
 =?us-ascii?Q?weiY5WagBbvV3P1p/YzoSZYH5xMbe1m/OdATRs6dhv5LRD6gr8y0YkNg+dLg?=
 =?us-ascii?Q?PPcuxFrJNJx6X98Ah00kbcX17MLkvLzZmy3Gt1eLnMl9glA3YFzTQU5JdjpW?=
 =?us-ascii?Q?cOCn/QgCeob6KH5qNrD2e0iDO09lArSQ4imTdLkygfbKISICj9p4LjJ/XLbg?=
 =?us-ascii?Q?gennALZIMzVnRJDSUtHBCQ6VQ+9+/SFuB3cY04mVXFbSJo91eq0PaKiLMOXK?=
 =?us-ascii?Q?X56iC+ksREv+nqUaCP+q+ANIvTdQSvglgHY2dblcE7bC58Ucnk3UEd8k3jjT?=
 =?us-ascii?Q?ZOT+QfHSB7971AY8V8fRh8P+DQOXla5QQ+yYxFXHVb1nA6icLfvSZ7+WAM4O?=
 =?us-ascii?Q?j3qSZWX6QIMCVxhPD5H4iEkSwClfRE0wO4Cz2bSG+jobgMplnoVTtXcWW2Or?=
 =?us-ascii?Q?AkOST1PcJcTte0yedGRfwbp3xqIWWwP8pzchUwnR3L7P5VX9D024AZrguxQE?=
 =?us-ascii?Q?wLKwdbZ9wzSs/1FVX1o4tMzhA+RynHHA7IE9cXVAUZYdhhTEvrphXFwEwRdJ?=
 =?us-ascii?Q?3Uv+gsiqaaa7khl/X1EoadGhjvU5WtCiJkBKbcxEMpaEfo0ersG7hrt/A4N6?=
 =?us-ascii?Q?7crUTdhXH4sWK0JoW7oht9wZYA5nTWM/5W7SHG4DfNZrB/TwkY/9Btd9HsMQ?=
 =?us-ascii?Q?LjLEgCTNVQMChrblYDL5AXkW2WxkiiPbNRZR+EoUV33DpIHYYGdREFOSMIDQ?=
 =?us-ascii?Q?QhVkXKqF0fPHut6o1NGtIfrhQRoWsW4ov83LN9wSOaHKhPW0TBosLxuAvrM5?=
 =?us-ascii?Q?JYNN/5jOyNmFFiTaKtRNbDD9ed+xzY7fBfeMy2muHY1/8JKUnA1lsMc31Wwq?=
 =?us-ascii?Q?OKj625UJSYtXfGAA6bCwXdQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AC34209663D7A43A538D330349C1A6E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VqyuauOlKbHQYWZIgJA3g8FrFAdHWdhoTRQsgYxukdXVnuqwdxMysqLatH+4fcf/pxrP2iU2a/taKC1rJcHuSzByiWyUYmTof20w+oVMGhwb34Ex1ruj3tCSEoAlC4XFgSYrGF1+sJokQirHec5yFkf072LLhEK1NMIb8MU651M+eBidher2SjvAGfspHFoSmrVipBrXOdjaWX6TH9PcJ6CyHebZVKGVckcwmFpYlbOTAnpSPN7Q4sXGF+bjZs1WzPHu8HWe14/642Ro4gBNO6UN5XGJTDWIGj0Ul9aEOvHywkmUGS61hrYsxLDLRWPwsyl0Wt0iecCWyrH6eTl3NmgJh7zJrrOzmeYHt1DJUOM+4fVGMOmm6xb6Z2DSv5q5+lzqfBZkp4+G6nVc6jnKYocGn3Q5AsDEYh3GH8JDKSoziOR1PpJCJgS3jXhVcoEpZ4yfLob75xTEVBHlCVkWmd7QViDUfugkqHBMbeM9SjJDkdyZZiULL/3laDyDvvhczTJkAHgGcFQD/ogJNZl2txwR3kOJt2nAX8kpssQpXC/UBHa+Vyx6KhIn/VERrEnTv+5nFgxe3MJadOUP3lJA3pDejSXZdQNBY+d3UeSEbqe0nVL005nlZkVf21yQrtxS6h+bLn8+6fagUZzMtfhM2qAL5Br1ueWUhiZPlFYuTyJRKX2BCubhJ6G+Vjg69Vtl7VEuKE31udje0ypmsk4MmZu3xTChpt5flRLTh+DxrqatKauYo2ml3z9eQRRb5MoHdj4pkHBZMpFiyPGgOrzCN7FepYmAMILGLNFHmtO8LZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83c44de-8f36-408f-5413-08db83d7695a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:29:01.1182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JASAYraRa1ZZuigvz6Y3nG6mtvC8Fwu2JWmhvyXz58bKcNETaGn5Omh7dgOUm1jdExtTyVVCUDNoVYyLPfW1Uo+Z2kbFm0Ct613RxKilAU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307130172
X-Proofpoint-ORIG-GUID: AS2QTK3hJxuRTj0mvhgS5BmGv-mEVK6v
X-Proofpoint-GUID: AS2QTK3hJxuRTj0mvhgS5BmGv-mEVK6v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Some consider noisy log as test failure.
> Turn off noisy message log.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 6769c40287b9..9941b38eac93 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -668,7 +668,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_por=
t *lport,
>=20
> rval =3D qla2x00_start_nvme_mq(sp);
> if (rval !=3D QLA_SUCCESS) {
> - ql_log(ql_log_warn, vha, 0x212d,
> + ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x212d,
>    "qla2x00_start_nvme_mq failed =3D %d\n", rval);
> sp->priv =3D NULL;
> priv->sp =3D NULL;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

