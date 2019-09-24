Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBD7C432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 09:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAF642168B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 09:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="G4mVnwpb";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="SYwVevKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbfIXJGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 05:06:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16444 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728169AbfIXJGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Sep 2019 05:06:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8O96IC6024188;
        Tue, 24 Sep 2019 02:06:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=KjWvq4ERCRO/QZ3seiB8WbEuE5DpqB34knrG1Fgwmow=;
 b=G4mVnwpb9OlqlXNnF09pczm8VaVJrddPI+GX6ZS0A/cnaGRaiDyjh+VUEqokotHxF0fi
 QoB+O8jdGLjWpZJjZTcAH00k3GgSHXRIoPCK8KMmEIMM7rjpxPaIaIZxjjtkhW4czH5Z
 18IhUA6WYWHetxOM0pqgBwgyLNxqR6e+cBqeFuksFOltPyOl+Dx2SC82pLuC8GoDLP6w
 uFmBL9sUR7Qgu5zLcbwmAtfiw0rdtwRCPNyuocx+NMK4QYYX+ATREJBzLkCYNBH4/vze
 eLmItd8KvL4eET2YjoUH9EjRVnOADVbAnKdH0fahXutt3+Dpsy/xT37/HLuEFZjdmQjv eA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v5kcks3j3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 02:06:19 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 24 Sep
 2019 02:06:08 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.52) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 24 Sep 2019 02:06:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnb63mJ0hwUs0SxUaKA0rmynMgOTi1XcxNbznICEA+/H9NS4a/pQeG4uhT3saXQb/QU6/VFP8prdUV73KC/Hoav9sLYU1tam6fi86aC11I2iSgRMY6+VmYOrny2ebHBlCpB83qUyPcWxFKg8efABdmnSqX70bq7lySlqoPP3MdkHi/6p2QZ1NkwWezC4SLvTRQ1eLnNI2rdHUEbYCoJA6XZ8bCz2mD/niBRVaXdsg/3JSytlm+RdiR3usGUtLwWUfXKhtbKND7/eRDz9R2nUrNPKqvwOi526eevEdP5+IOoUCHZznZLHR+Wfa+fiN67bRJJXC8ikX0MpM+cZlgdZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjWvq4ERCRO/QZ3seiB8WbEuE5DpqB34knrG1Fgwmow=;
 b=U1hXu7FBc5yJeAg7HOVJK9YXELUMRCz8t/CPJxVa47bmIWRbKWJDRrhY8F8iYgJxLevdWHYXxga3BlNx2eKVyI2nhpz7114H0nca68rQc2bV4I4es6WYoG3jVAILp2PX+G3TQ6mBZjrgDmKkEv1Ut5WYta6fdAipUqdtYgmyXrBdB+blOZLz5le1rNw/QCVnzagE1NcS6yITekXJ5kvHuPP87sb6gXRRCOGDF1tyPqoUF7qcmdOLFu4ZTk9lv4N6Gd0Y0aGLN3HfvnqCN01YUkFmI2Nb1yWWsq/NF3fOI+1oTvddQ9r3PslT7OmBCevQNnhYnGVr+DRiDDMCmyQBlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjWvq4ERCRO/QZ3seiB8WbEuE5DpqB34knrG1Fgwmow=;
 b=SYwVevKbQ9mMSNVKRJBymQX0C3qHFlPw4FKr1ptoDA82GSuStAdOyd/X1dKPJQ8cPYi7iJ3SILKCX6pqMKOCDcHyNNYr6Hmdt2QIiP8wr6bu5tLmjQRZYdwM5W4qYAWQ1gLq94cqa7F40V7hMLA8XUbmIHGbcx1OaVoP68pl26k=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB2893.namprd18.prod.outlook.com (20.179.22.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Tue, 24 Sep 2019 09:06:07 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789%7]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:06:07 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>,
        "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: qedf: Add port_id getter
Thread-Topic: [PATCH v2] scsi: qedf: Add port_id getter
Thread-Index: AQHVcqnEd2ix4WWugUyGkwvxB2xStqc6iQsg
Date:   Tue, 24 Sep 2019 09:06:07 +0000
Message-ID: <MN2PR18MB252798ABF3032377867D73ECD2840@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
 <20190924072906.23737-1-dwagner@suse.de>
In-Reply-To: <20190924072906.23737-1-dwagner@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c0c113c-adfb-4ec3-b9f2-08d740ce6f63
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2893;
x-ms-traffictypediagnostic: MN2PR18MB2893:
x-microsoft-antispam-prvs: <MN2PR18MB2893B3EA0A082547B95D6125D2840@MN2PR18MB2893.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(13464003)(199004)(189003)(51914003)(6506007)(102836004)(8676002)(55016002)(9686003)(66946007)(316002)(99286004)(305945005)(66446008)(54906003)(446003)(8936002)(476003)(110136005)(7696005)(66476007)(2501003)(76176011)(53546011)(478600001)(5660300002)(86362001)(11346002)(74316002)(66556008)(64756008)(25786009)(7736002)(76116006)(229853002)(71190400001)(52536014)(6246003)(4326008)(33656002)(2906002)(71200400001)(6436002)(186003)(14454004)(26005)(81166006)(14444005)(66066001)(256004)(486006)(81156014)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2893;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4TBOhohdHipLZJEK3G1YxJ1fDuCCUrI4J27mXzg4Zgq3aAeDZmuEsoDaJET+OQT/YWQRL9l1TyOHGIILH7LWRzxOF+vuwaOhz4BY+0vTL0Yn0sZhwV9QN5V+79UvG0jd3eCipNlDB6KcHKtR8wb4lbvGDHPWmmj9vD6sXOljS/xs0qeAVjA8MavLdw6/lvKtOXvB6+WoCNNAkv4XXcpLXM3IAOZuJmrRn/O9OGz5SugQc1dhM2AtJgCQuvyikGg6SWzZhUWhpJ1FF9QS6bvPdSAi1ZVbnlE19DUA67lYlgWDDn1Cqa2g946MrkFOp9zJga3dlip9f1D0dLSeEXiofxr3JBEkpQEvd11hG9CUlh3otZwhSv4B31aq2fdX1bpIcNKEGayUhGT8UF9CGAugfehhunWRcKxOhAkm+tLZkrY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0c113c-adfb-4ec3-b9f2-08d740ce6f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:06:07.1872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQAd1BX/PLi05FW2p2wxmxYBRrVEqEOtSKOJw6AoFlj96k/kb1Ezqa8TvyrVtS6Ym401AGhl7hP2gfaHsN3lVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2893
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_04:2019-09-23,2019-09-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>=
 On
> Behalf Of Daniel Wagner
> Sent: Tuesday, September 24, 2019 12:59 PM
> To: QLogic-Storage-Upstream@cavium.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Daniel Wagn=
er
> <dwagner@suse.de>
> Subject: [PATCH v2] scsi: qedf: Add port_id getter
>=20
> Add qedf_get_host_port_id() to the transport template.
>=20
> The fc_transport_template initializes the port_id member to the
> default value of -1. The new getter ensures that the sysfs entry shows
> the current value and not the default one, e.g by using 'lsscsi -H -t'
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>=20
> changes v2:
>   - place closing brace on new line, fix whitespace damage
>=20
>  drivers/scsi/qedf/qedf_main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index 9c24f3834d70..8fe8c3fdde1b 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1926,6 +1926,13 @@ static int qedf_fcoe_reset(struct Scsi_Host *shost=
)
>  	return 0;
>  }
>=20
> +static void qedf_get_host_port_id(struct Scsi_Host *shost)
> +{
> +	struct fc_lport *lport =3D shost_priv(shost);
> +
> +	fc_host_port_id(shost) =3D lport->port_id;
> +}
> +
>  static struct fc_host_statistics *qedf_fc_get_host_stats(struct Scsi_Hos=
t
>  	*shost)
>  {
> @@ -1996,6 +2003,7 @@ static struct fc_function_template
> qedf_fc_transport_fn =3D {
>  	.show_host_active_fc4s =3D 1,
>  	.show_host_maxframe_size =3D 1,
>=20
> +	.get_host_port_id =3D qedf_get_host_port_id,
>  	.show_host_port_id =3D 1,
>  	.show_host_supported_speeds =3D 1,
>  	.get_host_speed =3D fc_get_host_speed,
> --
> 2.16.4

Thanks for the patch.

Acked-by: Saurav Kashyap <skashyap@marvell.com>

