Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BE6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 19:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385911AbiBHTQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377071AbiBHTQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:16:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD19EC0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:16:33 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218I3TtQ013064;
        Tue, 8 Feb 2022 19:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oeOWCoC13/wPubjXutjAz3PCCClCGXZQTeIngRryzJs=;
 b=LK+AhqbqmTMlzv7beSVsER6M/gtYZK5UCnHYk8qcJQlSZeLI/rboDLAe2m5sJ8TzaD6x
 GuXvTWbQuZfaLDxdz3PuhOihzuIETS2poTYmR119OwBi6nKYr8d7AX0tF+mLimqafCfO
 lKRWUwJLdMuIhkephDjcOUSqS2Fscci9SqzLXaPh9ez003ycJ7X6jQAHor9/AX+rWi1Z
 RvF/cAI/xhdG37TWGxAYS8oQtiJe2UsAmWJCBWt2FXl4n7UaUdEajtJfN64PhPbTnme2
 NaKuhDSZv3S2d5zCT8GSoPlcq+c1UrMAXd7JGuJHksJVvqs6AIDvGnBz1mSMqFiRe7/s Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgjh3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:14:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JBm03159316;
        Tue, 8 Feb 2022 19:14:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3e1ec0xf5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:14:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLx/PkAaJBxSaXpu24u6DmO9QK1mKJ0scznr6a4OAa1Cru54w+t6vGJJzQYDkFGPq5PbCGkDGuBnf33UsCUku4tOgqlEbMXmbgxjNC+5vF3hnCYAmtBNn4K8rrGuxDVC42YL2sjtFITJJtAIMJ6/2xlxnXulmdiKQ2e5GZ9wUxGgRynxDSnwL1y1gL+IEimLbd10AutMg5NpPlL0SjDJ+4UVLTmDoGHo2nKSJWFBPDE9Wgdqf91ez/p6Z2T3/uEmKyvC2k0KtJID4GftAse/JlGrFxU4UXrFGpbW3zuUk0/RLkVAtUT83LIBbDYskc6vkWjJDw5lvM0BzYFNpK9rzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeOWCoC13/wPubjXutjAz3PCCClCGXZQTeIngRryzJs=;
 b=CilRQfTvpZRRAYBGcSBU4XtFvQ/bMhmHJ2wVHhB+iW1CRW6yxLVysS9eQMHmXLfjj5ylVb4gtxlD6ZBZJES2wRVNdFB3BIMrLKo8JasdUSx+/xKG0TSOjEBgJYmdgdKDS6Xh7xX+CYQx4raEveGatFs8wy1xyGTxPXiIsitbgidRMnZwpemoqdiIWToNpBEKWW6MTzHtPwYGMm+NrgpWK0aidwRYns9B8CbLDs4RbVxj0IYldDInk7pjBM4nW7v7R+uZJHZdJB2t78NSjIhFYOaccwRZEfDeed0YWnpacYwsBtSAxS5XTopkMblpfzxvdCfnKVZeha4sXozljvXI0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeOWCoC13/wPubjXutjAz3PCCClCGXZQTeIngRryzJs=;
 b=Efu52xgMiKVVi2vuXwpvDynHGlwoKH3Sgf3DbhmE8FEciEAObOQZ0vVbDT+oMHG/tUpbbuU8/IMxNJ/3yVK3FKDzQkIn22rFUZKHshf+xToGMxvaHZ5QqIoDz3lUOVfF798PaXwfQ08EyGCQow+xw9qYHOFuDjqoNQLtfrAnvfc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR1001MB2062.namprd10.prod.outlook.com (2603:10b6:301:2f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 19:14:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:14:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from
 scsi_qla_host_t
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from
 scsi_qla_host_t
Thread-Index: AQHYHP6uTkVvKKm8B0+U8wwXn2ISBKyKBhIA
Date:   Tue, 8 Feb 2022 19:14:03 +0000
Message-ID: <B1B7BD1C-4E48-429A-8AF6-F049F71FD74A@oracle.com>
References: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c457e97-017f-4638-d69f-08d9eb372b86
x-ms-traffictypediagnostic: MWHPR1001MB2062:EE_
x-microsoft-antispam-prvs: <MWHPR1001MB206222F9CD1043DDEED4558AE62D9@MWHPR1001MB2062.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RgkxxvEzNHMNy8D+VOo1hWQgafxG6XsS+8ea/xoo3S+zm/gO/pqpt/2/Qj9VadJbLbS+0/0eBMBdq25TLFWqqfQzj1yEqAe9O4c0CnKB3oGcEb8uWfHBourLs1PLlxsHwofmeGnhW6vWsgO9lJFVvYHfjdZ6ThgEPn0MnPQfqshrWOMyK1Cn8uoPeROHEdmCQdv5zWAyHxVNX7dqnN1CxB35HOh4Lt0uF/RC7a7b+iybRnMSzcLBnP6sqEDCfpMAobeXW+wqIsJw8fX0KPWk/Rl49QWqM1dONUBTc53fT9TVJ9HRVclvOACxJoaTaAShZDC2VvdfPCkVdAPIRWYlKwygj24nsfV3czL9OZCSAStyox2zpjTCwrXJqYYfW5A1muMntjKaFBT2ntQeZ8BaHRsRKiKQAs0C8n+as6VlOFmqcihRRx+cOc0ACUR876hy3O4pbCjtAxZflTzxMa2R7aNwGLqp+a4dhj7JxS0ixfDM1KCZsSDQtmzW5XczjwkvGx6F7XJ5MaD7tTSC29serRCEqvrI3dX2m6cJ6teiX7kKOvMy69DeCkzh2BuGMBU6UXAv/M0fys1bAMzy3vFhp3I17TwBf9R6imwhLaD2lop5qBzKO+HlQB4ldiHrj9S9qKcnIHUuLPZMb9/nTXuWnJwyvg7klcDFtSZWQ8vMujGl5JP7SoPHH3oBFjgFpkh9ipRQgnzjMf46LrxO2vzX8X02MkSLz4sf1ChfDGEoPaez61TJmHtxXyUVDR7lfLaG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(2906002)(38100700002)(38070700005)(66556008)(122000001)(8676002)(316002)(6512007)(6506007)(33656002)(53546011)(508600001)(6486002)(5660300002)(83380400001)(66476007)(2616005)(26005)(6916009)(4326008)(8936002)(76116006)(66946007)(66446008)(44832011)(86362001)(71200400001)(91956017)(64756008)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NiHcgdllDOwrJ4BnZxixJ15jyZZnj2enLyQYfnA1cbDRM4gljm5xSWiBJ3o7?=
 =?us-ascii?Q?QBPH5BXhRu6MABBP5Mg1/i1uC5BTFhZnv6YcpxUotlWGcRxBhzBcGuLBUO2q?=
 =?us-ascii?Q?4W1GyuAf0kXa81voK5soF8Blbvaln5U9CGjEjKTSHbQPzCqdrgFgpGy1Cb1X?=
 =?us-ascii?Q?MVl62zHozy9KbapUMbgSs6bT0Tm9HAWGSH1/1kShli9lipkSlYyDsLw9aSTJ?=
 =?us-ascii?Q?i0JbsA4kg+LS0gndyFJWdRok2oaW2anjQU+hFWcEKfdNYGqFaSmNz3psrxaj?=
 =?us-ascii?Q?zz61VR6Hxl/lsLGqlyY3fTCAaJrW9vNeuJeuUOo4dRE7ZxQk0ug8p/88pLwy?=
 =?us-ascii?Q?p+3o1vcx11noPcoR1hYY4GzivKgGgzibX1mFDnQdhqPtdM78faf3+OId0BH1?=
 =?us-ascii?Q?SIEGNWoUvdEkoIzwUzkN9rl3k3Qty7pthwNf/ty4WwOoV4aubXy224H636yZ?=
 =?us-ascii?Q?aeAtaQF9j1VvTuXG4RQyCjIrzZ5Eg+H2XJbcCrD15tPTkGTHjcSeHcB+Qhd0?=
 =?us-ascii?Q?ET2jEGVJzUTVKgd5bCBoWHZEa7no9k1UQ95iFTErgt5F+KTsJnTFPt+zRiGm?=
 =?us-ascii?Q?1vZYoDClMKqqIOIQhaGxLUBgqOG5DwicbuS8BAAj+g1Z//2cED8Oj/Tybo6z?=
 =?us-ascii?Q?4xdQv1Ou+nPBZXQ2hQvIA2UjYmzDYIHmJMaXWmYF//+7oDJ4LI0SfvxZiRER?=
 =?us-ascii?Q?3H9O19U5P8TmWuHNlVdqMVYCvZV1jRxczxZBbpF01HSIUI2hzXbEO/Vj9gMp?=
 =?us-ascii?Q?W/2SnB6VZldPnDpGnovLNJfRzr0v9ys2pJhVyc+aIFMOA8sU++y2Xhx3bS0Q?=
 =?us-ascii?Q?RGLVgDpXyGE/Fn3wzPWPf58Ojhnib5ub1FnWYBZiXYFopp+8feAtdHQP5Zjw?=
 =?us-ascii?Q?tiHoVzrXOb4uECRPhfwOlpURjVGTaWv8iCaAVB9ZtYbrOZi4SDbXe+fOf6eG?=
 =?us-ascii?Q?EQHcXJ83fEwHsxReXSCjoNKrqo7SE+q6OZkGUcdMD9a3yxaizKkYUCQm1Z2x?=
 =?us-ascii?Q?9NJQAu0RFIGxb6AuvdlaOhyF/hbh4KgIheWt/qQyPx8FsP3syZoWCliSHByr?=
 =?us-ascii?Q?CWtTahGTBxlvX2yaNTX44kD2NH1btNZDOaBKlN89Q2rzb1+gmvadbY1PuuNH?=
 =?us-ascii?Q?oYBvWiiScQOYeQIeSrxchKgfs8DEY3kwRU3DQjqQ628GPXmKybfitSzCROhB?=
 =?us-ascii?Q?Nsqe8QzKmxaPSXcwFD4i2nFWALyCQyxvMdF2mXsB9fgX81JblnSCx9ha+y/N?=
 =?us-ascii?Q?OUqYD9cPc7dLUp34h/Q67S8J+LhLH4GaHilxReIbBiqubACO5gBO4znQyKV8?=
 =?us-ascii?Q?nvR4pFKYOmrnyKIViF83ROcwhV1eaqG1I4EIr9uRDWvk8XikKIhVF/zMZXYk?=
 =?us-ascii?Q?IKCS/agU/e7CzkjTcGYztWluxY0JsSI4cQm/x6MeMiWLa6aNNJPRRehqW9NL?=
 =?us-ascii?Q?CgwdLhh823W6xIx4zAGAQtGBsiZrmc1YqJ85JcaPBP6mQC8Y1HtgBBzSVXoU?=
 =?us-ascii?Q?pd26y3KkPQPPqSkLnFGlIglFfjXji8UL9wVzvrbTlymYQC0dodUR/fkVN2Eg?=
 =?us-ascii?Q?s6C9J9OzuSIrAKeCm9mYxSRxK2Ij8owZnUzxCltIH6Ms5xL+Kentj/aU/2PX?=
 =?us-ascii?Q?bEe/GtBeCHlOGnyBULsaRsWUfcSFeTdfaH2pXRte8Rv9zkYap1yC+8DfI7QE?=
 =?us-ascii?Q?986F5HT8YW84LHDHUd59PnYnPLw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7849ACC215507D40BC600A95E11DA55B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c457e97-017f-4638-d69f-08d9eb372b86
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:14:03.4527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tIx3fLZd6bND+IWm54+NuWr6WEF0f/XO6O6j29i0aLpl7zxlfOI2IWNrrJIiTpFULt4/gd8JjyGflRX2MQx/lL1VWEdqmB4b3MFnOgLMKSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2062
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080113
X-Proofpoint-GUID: pnEaoqLiRtQ2V_rLpgnaTbFnAvhp2V-L
X-Proofpoint-ORIG-GUID: pnEaoqLiRtQ2V_rLpgnaTbFnAvhp2V-L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 7:18 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrote=
:
>=20
> The qla_sess_op_cmd_list was introduced in 8b2f5ff3d05c
> ("qla2xxx: cleanup cmd in qla workqueue before processing TMR").
>=20
> Then the usage of this list was dropped in fb35265b12bb
> ("scsi: qla2xxx: Remove session creation redundant code").
>=20
> Thus, remove this list since it is no longer used.
>=20
> Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h    |  1 -
> drivers/scsi/qla2xxx/qla_os.c     |  1 -
> drivers/scsi/qla2xxx/qla_target.c | 20 --------------------
> 3 files changed, 22 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 9ebf4a234d9a..7d8ebabb7b40 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4906,7 +4906,6 @@ typedef struct scsi_qla_host {
>=20
> 	/* list of commands waiting on workqueue */
> 	struct list_head	qla_cmd_list;
> -	struct list_head	qla_sess_op_cmd_list;
> 	struct list_head	unknown_atio_list;
> 	spinlock_t		cmd_list_lock;
> 	struct delayed_work	unknown_atio_work;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index abcd30917263..579379a3c554 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4949,7 +4949,6 @@ struct scsi_qla_host *qla2x00_create_host(struct sc=
si_host_template *sht,
> 	INIT_LIST_HEAD(&vha->work_list);
> 	INIT_LIST_HEAD(&vha->list);
> 	INIT_LIST_HEAD(&vha->qla_cmd_list);
> -	INIT_LIST_HEAD(&vha->qla_sess_op_cmd_list);
> 	INIT_LIST_HEAD(&vha->logo_list);
> 	INIT_LIST_HEAD(&vha->plogi_ack_list);
> 	INIT_LIST_HEAD(&vha->qp_list);
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 8993d438e0b7..d5dad6e6d4cc 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2026,17 +2026,6 @@ static void abort_cmds_for_lun(struct scsi_qla_hos=
t *vha, u64 lun, be_id_t s_id)
>=20
> 	key =3D sid_to_key(s_id);
> 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
> -	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
> -		uint32_t op_key;
> -		u64 op_lun;
> -
> -		op_key =3D sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
> -		op_lun =3D scsilun_to_int(
> -			(struct scsi_lun *)&op->atio.u.isp24.fcp_cmnd.lun);
> -		if (op_key =3D=3D key && op_lun =3D=3D lun)
> -			op->aborted =3D true;
> -	}
> -
> 	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {
> 		uint32_t op_key;
> 		u64 op_lun;
> @@ -4727,15 +4716,6 @@ static int abort_cmds_for_s_id(struct scsi_qla_hos=
t *vha, port_id_t *s_id)
> 	       ((u32)s_id->b.al_pa));
>=20
> 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
> -	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
> -		uint32_t op_key =3D sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
> -
> -		if (op_key =3D=3D key) {
> -			op->aborted =3D true;
> -			count++;
> -		}
> -	}
> -
> 	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {
> 		uint32_t op_key =3D sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
>=20
> --=20
> 2.35.1

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

