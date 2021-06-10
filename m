Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0B9C48BCD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A880760FEF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhFJEqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:46:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhFJEqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 00:46:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A4expk006766
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 21:44:07 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3934fv1jds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 21:44:07 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15A4fJUL007278
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 21:44:07 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 3934fv1jdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 21:44:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyMPyaM0YhF77zZkFIcg1VPtmNTbA6p0NcN6QBYJ7xH93sZxDQ4aBp2tkSLP5++brWG8IHQ+2cQ63ohLrbEHT0k9I+rk4iNgXLN5tbN1QhWdB4onCGgks8oYIjmLvDzwZei3BuGMit3fbYiOYWtcnl1HfRfgyYFd6rTdvnJUhRuphsA1ToyqBRRElajjCZBrD2mnQw1NDmTJI/1iZQA/M2wsE5w3eLtkdL2obJSb3t7wkjc4FWvcPDL1Cn+sSwBom3l8FAeODGu+cabdvZef8vURTf3wg+43wfQknGM3mbEsphoAlWW98NF28GO0Ah9361PKe86p7MJch6r1OHkU6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hn3C8WvWDSj/14NNKhkWWKWJdl6qTOFn918w7DDdxgo=;
 b=i4R6Nk/UIqE/9mrsbkm5ftiRZn0dfeUK3OGmPoAjZBKSaf4OgEQ7lw1BdAMqjzOZ4a6ozyvGdN9h/4UfjCRvLRfQGyCeA3+TtBDTj6WYaz+/HiLmBySEqF2Aht/I5nPonGApDSFDcqaJaeswVssFrR82MAl3SMmQF0dgtiPYpTgX7q5DqnkbCLNXU0Qqi8KmBYlRKklDnhiHw5IAkrcG/2Av2PuD10S9HllIoc/qGXIJTfPJzl6p89Ffe+ELQLBBO9z//eAasPO0Pfp5U9XYJ3OTktcQqpmJCj28q9qxhjwbCA1A5JlHEVVwzBe/s0Ik9CoP6wppUMVkLUInYIxQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hn3C8WvWDSj/14NNKhkWWKWJdl6qTOFn918w7DDdxgo=;
 b=nr4C1YGKdrg9KXTKMmYLmTtmbezcpeqq+UT0Lf+MhLOlTM5w9YMaros8Eh1B8KRRG/L46soI+ye27Vt1A6/sVIe4UUTwX0b4SftRwDao4/pbeIksjqh9J4pWO57zbH7vH8YdKikKl69nKHOLCYdMulDxQHnAcAaM+13R70Frkfk=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 04:44:04 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478%5]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 04:44:04 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/1] scsi: qedi: Fix host removal with running
 sessions
Thread-Topic: [EXT] [PATCH 1/1] scsi: qedi: Fix host removal with running
 sessions
Thread-Index: AQHXXWV6dmhbFBwsRUSNjHR1LVzYCKsMq1ZA
Date:   Thu, 10 Jun 2021 04:44:04 +0000
Message-ID: <CO6PR18MB441958AAFC6772ABABDBC55FD8359@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20210609192709.5094-1-michael.christie@oracle.com>
In-Reply-To: <20210609192709.5094-1-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.75.141.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31763750-83ed-4577-62c8-08d92bca6025
x-ms-traffictypediagnostic: CO6PR18MB4419:
x-microsoft-antispam-prvs: <CO6PR18MB44197B63B36EDF0A2A0B1CBCD8359@CO6PR18MB4419.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mo8uD4vLTgQ1IEfkEnroigCBmMxA3Vq/pcZpu/hOxsEkgy70ac21CIhntOEYVZ7+CwS5gcevEMaXVIN7PS1rj/G0/+tjPomcVJKnYcsRnwtc2Ugx+f5493TeqUaqBcLYhV2ofuMJgriwplQiTAMNLNRLrLt8Zu9E0awsLCYFzGY1N6FlxcYJE8iASxE6w9Hc+Tdeddp/RuBV9pPgw2edvOnaTzmdmWeZ2drqy3PYgraTJiPmUCFjr0pa2NzSz5feVsv6UGbvYfsJdHouQeKwCYzPujsGVyfC64+IgV76J1gvpI1wX+2UO5XPsLEfuoIqf5CwhTfR+THEW/lR9lQItU+5xQv97TkTdJY5LbwTijKELUTvMUPor7h+3YlOYTkDgH7GamduBVghIP8IkUHJ5RAT4hb85sVFmaL4qjhxDAC6xIjxdqnJJZEp5SW2uQUzS5ohNjCQTesI8Tn7NYl5eNbcaLrmdGX+RSBDX4kL0Xsov+ICmBlpZUOrmM5bnqKpqLK/sObzjP0h4QHo2l9j4E412nuqD9TgFZLl9hc/L+/IQDZoBRkvrciXgEQbidKAr82IWf0Ce44quMRMhg3OmFnLwO+abeEguzmbPfWrywQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39850400004)(346002)(376002)(9686003)(8936002)(33656002)(38100700002)(55016002)(26005)(478600001)(66446008)(2906002)(7696005)(53546011)(55236004)(6506007)(76116006)(5660300002)(66556008)(66946007)(186003)(64756008)(122000001)(66476007)(71200400001)(52536014)(86362001)(110136005)(83380400001)(8676002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XsFzL9wf1m65/uWQrVphLCyItCcqUj432orTysL9GUUKY85EAKva8KIDs7vt?=
 =?us-ascii?Q?ZSIInEGxnePji24VWUpYeFO9W50Mkf45XyqkgPwNcq7jj3g57nLVw8VQzikr?=
 =?us-ascii?Q?66nz+A064Jr6PM03KTcl0LM9mA5T+UwbuvC9vKhx2eGTfq1o12pd6mvCkxop?=
 =?us-ascii?Q?V8RS2IPgfPCy+UbR/wc9b4/9MxlxD0l5InXG33v/XaGYqF9KfjftHTwxADBA?=
 =?us-ascii?Q?g+h1pfJpF7ZjXboLg/YPgkWI55Rm79JNmjE4pGOsJPyadhG3HTuJFKyt752J?=
 =?us-ascii?Q?zj2IWQ2SaELNi7SWarZgnwk6HUEVJ1b+W9GO26f1ILX1eODa9HGay5hGU/Av?=
 =?us-ascii?Q?Ag38hAm1cwgi5PBuvYq2PZmNSclBBVLTtAv2FFwXJH1RRhh2NF2CNSSalU34?=
 =?us-ascii?Q?pOL2Z+7eVffS27nEXt7vk73V7Pb7d39+k/ytBBakCOapUtGbwwPnuWovOi1l?=
 =?us-ascii?Q?pTL7j14LUPhpawor1c6oGQxd5K7Kqx8UBaztBIMmSzfD8W8nQifg6pCK/LFP?=
 =?us-ascii?Q?SOX3KbGlfFpbvI9U5wbnV/WUQxf2XrmNZ63n5y87A+z3BmGKQ8et9MugQLZw?=
 =?us-ascii?Q?b7ZBdU8hG4rx7W0RE4sQYnqZvHMaF8huOHDAqK3rKVvtDdQphUyxPq7s0Duf?=
 =?us-ascii?Q?KD+ceBMTbPpNJ2iqbFUfoFrcT0aYuV2wMLs8QKsSUz0Y0zVgT5M7sAhCckfX?=
 =?us-ascii?Q?SJvng1wafcKERqS4jqRWmXgs5HsENvUEHe3j8M+lvCJ1Vmj7Fk/d21KnIY+N?=
 =?us-ascii?Q?0fuzuYZqfFe7murF9X3OaBXki+bzI2Aoju/gRpPQQOa7Ft9zpygG1HxPb9+T?=
 =?us-ascii?Q?R+pWZ+Fn3hEtvRvkTJTVCR6tzI9l1xcl7xV9RjlM0sAU56DDVLCbxbCb82rN?=
 =?us-ascii?Q?ts6J3nhfgreJq/FSCdkHI64GIMkzoVBPOWgSAxn2+ahIBn2n8oo5ogWrHMaD?=
 =?us-ascii?Q?JFmTZPizepRi3jue2oWlAvKB8ks2GUWJzQE9qUQLgMCLIPBKshCM8ifqxMOL?=
 =?us-ascii?Q?i5NqPVOBBtY9Q7b8HlMytPxJhV8wpP2I38nSmuYysJnXcuc2gMX3kHAnRGcZ?=
 =?us-ascii?Q?LizNObwmp2lVYFK9Mzg9LZCKPm1eWQrt2H3R2Uy7uGRdejPhYSVg+80rLcTx?=
 =?us-ascii?Q?4qqtuoqPVbiSCpS+0pxvIPTc6WPINmX367r4zhvqRlreNRb7bxDYomokA5t0?=
 =?us-ascii?Q?MZNeOaPAismc2wf3cGL7fHuAINqXkAbYxEigTyvan+grNJ0MaUaLevPFAjxw?=
 =?us-ascii?Q?dxXti1rOqYk9PkmMDiDNBqGPSrNgiO7gky9dIPZqrLZUgqOXfWTJvHDRrIKG?=
 =?us-ascii?Q?EDOMqOdTODt3QTRzUfJW50fv?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31763750-83ed-4577-62c8-08d92bca6025
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 04:44:04.4663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dXf1JImA3iMYtx+3tZS9siLY5K91UPDBvyv9S3ljiy8RomY/6pQ9n6b8ZSZBl+L2PQieVtZdoqp+IZKEeD7SfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4419
X-Proofpoint-ORIG-GUID: C1NWp1vLA-2J45wfJzazBpwh_JBVRT6C
X-Proofpoint-GUID: 6P0BydyKlPUkGuPh5X0E527MY4vhnFRu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_03:2021-06-10,2021-06-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Thursday, June 10, 2021 12:57 AM
> To: Manish Rangankar <mrangankar@marvell.com>;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 1/1] scsi: qedi: Fix host removal with running sess=
ions
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> qedi_clear_session_ctx could race with the in-kernel or userspace driven
> recovery/removal and we could access a NULL conn or do a double free.
>=20
> We should be using iscsi_host_remove to start the removal process from th=
e
> driver. It will start the in-kernel recovery and notify userspace that th=
e driver's
> scsi_hosts are being removed. iscsid will then drive the session removal =
like is
> done when the logout command is run. When the sessions are removed,
> iscsi_host_remove will return so qedi can finish knowing there are no run=
ning
> sessions and no new sessions will be allowed.
>=20
> This also fixes an issue where we check for a NULL conn after already acc=
essing
> it introduced in commit 27e986289e73 ("scsi: iscsi: Drop suspend calls fr=
om
> ep_disconnect") by just removing the function completely.
>=20
> Fixes: 27e986289e73 ("scsi: iscsi: Drop suspend calls from ep_disconnect"=
)
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_gbl.h   |  1 -
>  drivers/scsi/qedi/qedi_iscsi.c | 17 -----------------  drivers/scsi/qedi=
/qedi_main.c
> |  7 ++-----
>  3 files changed, 2 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h =
index
> fb44a282613e..9f8e8ef405a1 100644
> --- a/drivers/scsi/qedi/qedi_gbl.h
> +++ b/drivers/scsi/qedi/qedi_gbl.h
> @@ -72,6 +72,5 @@ void qedi_remove_sysfs_ctx_attr(struct qedi_ctx *qedi);
> void qedi_clearsq(struct qedi_ctx *qedi,
>  		  struct qedi_conn *qedi_conn,
>  		  struct iscsi_task *task);
> -void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess);
>=20
>  #endif
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c index
> bf581ecea897..97f83760da88 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -1659,23 +1659,6 @@ void qedi_process_iscsi_error(struct qedi_endpoint
> *ep,
>  		qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);  }
>=20
> -void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess) -{
> -	struct iscsi_session *session =3D cls_sess->dd_data;
> -	struct iscsi_conn *conn =3D session->leadconn;
> -	struct qedi_conn *qedi_conn =3D conn->dd_data;
> -
> -	if (iscsi_is_session_online(cls_sess)) {
> -		if (conn)
> -			iscsi_suspend_queue(conn);
> -		qedi_ep_disconnect(qedi_conn->iscsi_ep);
> -	}
> -
> -	qedi_conn_destroy(qedi_conn->cls_conn);
> -
> -	qedi_session_destroy(cls_sess);
> -}
> -
>  void qedi_process_tcp_error(struct qedi_endpoint *ep,
>  			    struct iscsi_eqe_data *data)
>  {
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c index
> edf915432704..0b0acb827071 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2417,11 +2417,9 @@ static void __qedi_remove(struct pci_dev *pdev, in=
t
> mode)
>  	int rval;
>  	u16 retry =3D 10;
>=20
> -	if (mode =3D=3D QEDI_MODE_SHUTDOWN)
> -		iscsi_host_for_each_session(qedi->shost,
> -					    qedi_clear_session_ctx);
> -
>  	if (mode =3D=3D QEDI_MODE_NORMAL || mode =3D=3D
> QEDI_MODE_SHUTDOWN) {
> +		iscsi_host_remove(qedi->shost);
> +
>  		if (qedi->tmf_thread) {
>  			flush_workqueue(qedi->tmf_thread);
>  			destroy_workqueue(qedi->tmf_thread);
> @@ -2482,7 +2480,6 @@ static void __qedi_remove(struct pci_dev *pdev, int
> mode)
>  		if (qedi->boot_kset)
>  			iscsi_boot_destroy_kset(qedi->boot_kset);
>=20
> -		iscsi_host_remove(qedi->shost);
>  		iscsi_host_free(qedi->shost);
>  	}
>  }
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
