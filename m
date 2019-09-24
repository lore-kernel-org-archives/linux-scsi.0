Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF73EC432C2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 06:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6622064A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 06:08:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gRg/Lzep";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ahTpAMt9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438618AbfIXGIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 02:08:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17924 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388254AbfIXGIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Sep 2019 02:08:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8O65HEx025107;
        Mon, 23 Sep 2019 23:08:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=geBufwZFWmPW+xIOlsy8V9dpdBlD+ZUlOBTGLgHoEEo=;
 b=gRg/LzepkpAE0vuaHqJ8VrE8jJqYlgDouIbKbNHpvuulmS04aadP00coMZeP5cT5evIA
 Zz5GQOBiv3CPJ356hegSc3POPf3IXnC021A342xrDY+PrJBbrdkl26zDYCvoqcgDTCIX
 9Nm40pbvctBd95AOiZR7MeK6VkdI+pD8eyDZpy1KE527Vg9klk8hSCPJi7NUOdkgeZQV
 ejH63ba//lkslibRHlGVO5WxCw0+KIr5uVcWYsuErCOah22lOgSNHL9eEqtrjFc+1uyj
 QDcw0oYssx57qrJMn+Z6GaS6tiUpKSl4Jchu+V/gOqtAI9eK6xOBCNMOUetyXPA7YaB4 ag== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v5kckrjnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Sep 2019 23:08:12 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 23 Sep
 2019 23:08:11 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.52) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 23 Sep 2019 23:08:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVa+3V9NTpZr+Pvn5BfVj2j2AXdnttcsiC4zlDCbaR4JIjgeB/BrLoQiz5JyC1strZUhSlca0Ve/wloVZqm5bTDfG/EMfD/U+hRm87xOmFGky5hyR8Bm55c08ofKCLwdvq9Eq9CqeBiuT9aom6213m/2e3coLdLjf/FKxqP+J+IS7Cb6W05A24tpQ1JGHqOSZbjaRuluPEuAH9JsrS739DAxWN4Yvrl4dOpIk0XH2sHdSYKPQ+P3es9LeC2tMUefvAc3ZDEqlXNI5gEYlh5aGFgCjxfEI17aC36avwIo3Viu901JHdUYJeqrne9iJDSDhGUIQpQ3huli9z5IPRTerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geBufwZFWmPW+xIOlsy8V9dpdBlD+ZUlOBTGLgHoEEo=;
 b=GgAYRYQ0wycQxOhcQebxAI5CMth+HyeG0F+e6iyMv0j9xkiARSEtnwOr+6tG4TBEXnSVx9p2VifS5haU58A9C0eQZ2Ia0vUAc8QBHB8idefcjSttXqZqDzGmso963SvvZQ8/f7av/3PTQD+77drd7EoarOZmuXAEWJIf1zuh297L+h7tfY8hetv+5ePE5iDzqMnS14OYA9Qhr16HxRDD3I6gFuciVZ6VFvDiP5FKnLxd4QIEvNA8TXBturPCiCdvtslPTfML7OXUbNk1Yai1T6bnNgIubpMFa87K1HTsiO/ssryCgEP3HVFcdsG8Pm18UUrRP5rzzqWf2qxObJibRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geBufwZFWmPW+xIOlsy8V9dpdBlD+ZUlOBTGLgHoEEo=;
 b=ahTpAMt9l1muTdoXYRXoVpLDc/XdEeeB7y0IzA3YqHedtrz++0Q6nvx3AFOCqcMRewdmrq7hzVK6eIX+/NGNemUbLKp8hx7Pew2l+Tbawgs+aENVWI+93LHTJrh9yq6Ic84kxVE28sR8trT5n8CqsmldsrWdTVaAa2oc3Vb8G4E=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB2973.namprd18.prod.outlook.com (20.179.23.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Tue, 24 Sep 2019 06:08:09 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789%7]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 06:08:09 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>,
        "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: qedf: Add port_id getter
Thread-Topic: [PATCH] scsi: qedf: Add port_id getter
Thread-Index: AQHVcfrzLGK4JScA4kqhj7Bwh5oaVac6WHaA
Date:   Tue, 24 Sep 2019 06:08:09 +0000
Message-ID: <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20190923103738.67749-1-dwagner@suse.de>
In-Reply-To: <20190923103738.67749-1-dwagner@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bb2853c-e4ff-4d5e-9d2f-08d740b5930c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2973;
x-ms-traffictypediagnostic: MN2PR18MB2973:
x-microsoft-antispam-prvs: <MN2PR18MB297333432AD7977715FD5513D2840@MN2PR18MB2973.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(13464003)(199004)(189003)(66946007)(5660300002)(256004)(71200400001)(8676002)(4326008)(14444005)(305945005)(3846002)(9686003)(6116002)(478600001)(7736002)(2906002)(71190400001)(6506007)(6436002)(316002)(11346002)(76116006)(33656002)(110136005)(54906003)(186003)(26005)(25786009)(14454004)(486006)(2501003)(86362001)(229853002)(66066001)(99286004)(55016002)(74316002)(66556008)(476003)(76176011)(446003)(6246003)(102836004)(66476007)(66446008)(81166006)(7696005)(8936002)(52536014)(81156014)(64756008)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2973;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GsduqOQySVxqcZ5KO07kKElqZB4ujAbtXVEqf9LjrExL/w9R8I/SuVzZm/7ISV5RTnAj5SZgdx9n5z8eYdpq6k1xy8/uP2LkxKyFHEjsmFcJmKQd4QRGBpspH8vzKuc4VuUsvlcjf6zOGJ7XLuFh2XM59WZ0LkSE/JSShBSb5O4RMJTCJMHbGmXZ+2dO53Z6jhXwo/JHuNL1VlwegxX6JOyvxb1j+mtMRIG0wlRQn2FqsH0awqUTvDF0anydrWuBRcY/OOtgT+FAaXHk10C7Yaec1Rtf+sqI2+aPPH/1BdTtmmHw+19iheO2YoQD2bdNbobUD0zRbZo2MKOwRtQf7SiChXffAIiIMpvEmpcl1crdDob//4SVT0SWKHeiAHE+lfZL5JcrAlvAz2j01T677ZSc2zIY+ZZzz+7TYL8sRSQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb2853c-e4ff-4d5e-9d2f-08d740b5930c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 06:08:09.5550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiZfuAJv/KkxjFByLlDiXBFlxMFZy8z/oXNiRB7ieucxuSFNv5adUnm/e32BdLXsseLg75bfxJsGVv9hV/dmUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2973
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_03:2019-09-23,2019-09-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>=
 On
> Behalf Of Daniel Wagner
> Sent: Monday, September 23, 2019 4:08 PM
> To: QLogic-Storage-Upstream@cavium.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Daniel Wagn=
er
> <dwagner@suse.de>
> Subject: [PATCH] scsi: qedf: Add port_id getter
>=20
> Add qedf_get_host_port_id() to the transport template.
>=20
> The fc_transport_template initializes the port_id member to the default v=
alue of
> -1. The new getter ensures that the sysfs entry shows the current value a=
nd not
> the default one, e.g by using 'lsscsi -H -t'
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qedf/qedf_main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c index
> 9c24f3834d70..8fe8c3fdde1b 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1926,6 +1926,13 @@ static int qedf_fcoe_reset(struct Scsi_Host *shost=
)
>  	return 0;
>  }
>=20
> +static void qedf_get_host_port_id(struct Scsi_Host *shost) {
> +	struct fc_lport *lport =3D shost_priv(shost);
> +
> +	fc_host_port_id(shost) =3D lport->port_id; }

Minor stuff, the closing brace should be in next line. Please submit v2.

Thanks,
~Saurav
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

