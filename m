Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C7AC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 09:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1BE5223C6
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 09:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Jzi/HRF1";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="qZtpZUYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405828AbgJTJhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 05:37:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39586 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405812AbgJTJh2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 05:37:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09K9PkRf005425
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 02:37:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=lER3qWPT9DduSJ87AqsBVIMWq8c0Ps/Enl/M91S+tYE=;
 b=Jzi/HRF1um0ZHxuBAU1lOezS35JEfCFeADAW+Szs7+deOz4PNVDsvE3kYp5e9OOO4uZH
 xIGrkfoA8DNYHp1OrjFJCVoTPHEnwoGBmTVaWjWST3ga1eS5DIqT+vWWCR4fMg6/xo6o
 jtF10hXLcJYmJYuJASUk1cz8Dn+u1Yi7Iu0m7eiobC+4kNm8KFPK+91kIE0CZ8A4C3+N
 /ZpI/O2PjSelHVJYLK28owyzcFzU9fNvDrUmPRuAiJeNKdEahwmd9YQ6k6L6eoMCM+mN
 qK5nYTQGTbZryEZBZ2JkAeKwZVAc11Vh4sLuXxaCoPPacjm159hYp/2n6JCLWSZh585h Og== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34804nr724-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 02:37:26 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Oct
 2020 02:37:25 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Oct
 2020 02:37:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 20 Oct 2020 02:37:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fs5aDgSeXBothQoHOcL52U7AdVVIQu7rddJ86WcgcXRhtAB9lnpkRLmnRZ1MLFWRrmT0abJekEs6M4bHAm5/9jb+JexkLxPKCqP3TGfFIR2NAUIJrlcDyex8ayd+JpmZH+o54muyLhyCjflQaOTp6ofLO4zpThl9ODMTpD5kOLBqQT+jd2i3fAJRO0HlEI7Io+Ogz73qS3AOXJqbrAGTjwNTGYrRLNWtzfZTqVsztuQLWSgJe/nhnkfBsjsc5wX26U0JkfaID66hGNTJVk62yTo31QNNcTKw3q+Ua0xy5YLRgs0OBWP/MMKVC9GjkWhG7XfFItlAzb9tPWigoFS30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lER3qWPT9DduSJ87AqsBVIMWq8c0Ps/Enl/M91S+tYE=;
 b=S8wIa/EztDlcDzRalAY42ygFEUdog+ytOlzOdc6S99wxmoEvL5apiHRIYlHrM1LAxJWsgC5gUfJQQN8Px6EOG+wOki8PJwDWcgqxRYPktHWSmGnGTR+kJg1mMTm828vQKq6RTPA9iNIN9joKs4/nvzRNlXPxLyY5YJz979X11K1Z8x+7V1UwumQRKF2kCzkI7V3fBfzrbiwVNrJIZKNUiaMRHhvhFnx5Zpyzbqwmf16vydvdcAHXKcmiJKLQ3aMtqa5TQTOERqnxI/rYtp0CoX4tH37xoQO+sKT3oaLyN8GzivQElAGfzFBWxqtCXyZ8I6/NuJYRbutZZNnP3COcHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lER3qWPT9DduSJ87AqsBVIMWq8c0Ps/Enl/M91S+tYE=;
 b=qZtpZUYOEgxasmb7f9eTBmaGARlxm8EiVQ+fWIdjuIdpl2Iy+DW5W0hQQObIRWkP1v0p/oCRKqXwawsBpX9UHS9vEOZZl7iUx0rTTSjoHNX/NLTwhuIoigoc2kO1XobanaHG3T7JNSgmlT578DQpqBtEB6esQ6eu6etVIm7hkmw=
Received: from SN1PR18MB2301.namprd18.prod.outlook.com (2603:10b6:802:28::28)
 by SN7PR18MB3853.namprd18.prod.outlook.com (2603:10b6:806:10a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 20 Oct
 2020 09:37:23 +0000
Received: from SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::80c1:ad02:2a2:afba]) by SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::80c1:ad02:2a2:afba%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 09:37:23 +0000
From:   Javed Hasan <jhasan@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 4/4] scsi:qedf: Added attributes for RHBA and
 RPA
Thread-Topic: [EXT] Re: [PATCH 4/4] scsi:qedf: Added attributes for RHBA and
 RPA
Thread-Index: AQHWnh/1II8GZsoYQk6WV0ZOAkqcAamfJuAAgAElNgA=
Date:   Tue, 20 Oct 2020 09:37:23 +0000
Message-ID: <SN1PR18MB2301602DC7A81322571505CCC71F0@SN1PR18MB2301.namprd18.prod.outlook.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-5-jhasan@marvell.com>
 <40A84614-A410-487C-8726-7AF2B7D01FAB@oracle.com>
In-Reply-To: <40A84614-A410-487C-8726-7AF2B7D01FAB@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [43.248.153.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3affe621-4e09-4ec5-fd69-08d874dbbfab
x-ms-traffictypediagnostic: SN7PR18MB3853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN7PR18MB38538E56355E0644BC8192A9C71F0@SN7PR18MB3853.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:309;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HspSJf2aX9CwHLPSM77Rfy+27PQ3fuqPRhLJ+8Ypw44l+iFW0rk325Gmtu/w1l5j/RU8X3N4b8XM7m/kB6L2fBdag2wPnHrlAGAnizZcNreX3v9dlS5VG9WY5d9mdYbSqDMQrPiXfFvMyQmo28hqdk56i5yuRkSLNsBmyCQpssAakDlVY0VE4TASa4JaKg5cq60O0F2bVC5HrwTpLnbe154PFuQkUeynia81qT9IftB+Z36K8MZHmdw1yXQMWAtMhxiofW7B0S6uiP8H2bHniuMNl6hx7GhLQOAWXNyfGc5zUwVlSVu5/aw7OPwC5G4rN/wHul0N2WJ5OFehb05dhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR18MB2301.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(54906003)(316002)(478600001)(55016002)(6916009)(7696005)(186003)(86362001)(26005)(6506007)(53546011)(8676002)(8936002)(33656002)(2906002)(107886003)(4326008)(9686003)(83380400001)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(52536014)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MqjEmr7fdsOJzgyiQjFJrYrZh+AkR2TVefT5Pi9t76xa1y+I/AwNEttn9zq6ZtKIZnkb0Y6tMsrsuMbAmi5POZhhJ8XC0MwE95NGZubsAaL/rWM/DL+ThQYtd0PNo0M2bkFH5EIv3Wq2Afc78G9vd8C99uTrZ0L2vf/w/u9gKH/NeDNH8c1yyL7Dfrp3aLONVuF7xfPkAfnzoWaqtyXfJ2m42L8xfFgmNBgV59vZ7cIbxfxO4GJf/3wUGmeViaJ9Y36stMD9TU18zFSCp08pZedUuMqalTzGKrmjccSwuWACNmAotgcf2WUv6IbVGUyVsbrEtV3Bvux/66ZoqQPoIViCXm6vTUTVBzaDDDCvnhJm6SVmKBi8XS4VY30ssExMLI1LGPVuNmiVR20xXZcG+ibtYLF12MtzwMOH926E5mNESEcbk/AqHRZjQIoZ6UCRP57tCIRQzT3bXKnylxyYFqL7PzVddoUdzsxvyDM4MVL4zUPBqkAunnBuZXHlcVCff7ifoPcObCidKCsDoAbBpa7CgGp2EKAj224P8xQzHDO1k4S/GTG+UtxJ+gUQHCT6gAaMqTsr4bKfumpFJPFl44WWiDu3Kxmexlema3zUXfiepcbrj0kOMqsfQXlGYo1EhwUoHJsQ3+4d7ORv1MgsnA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR18MB2301.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3affe621-4e09-4ec5-fd69-08d874dbbfab
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 09:37:23.3845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B8Vq1HcLLC9kAVDW6172CXVzDLyw2C7g5Lx4h/Rnof4/58c94tsR3lKKz8g2laVDmjRWfODxLAhGtoGMc6dkBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3853
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-20_04:2020-10-20,2020-10-20 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Himanshu,

Please find my response inline.

-----Original Message-----
From: Himanshu Madhani <himanshu.madhani@oracle.com>=20
Sent: Monday, October 19, 2020 9:35 PM
To: Javed Hasan <jhasan@marvell.com>
Cc: Martin K . Petersen <martin.petersen@oracle.com>; linux-scsi@vger.kerne=
l.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [EXT] Re: [PATCH 4/4] scsi:qedf: Added attributes for RHBA and RPA

External Email

----------------------------------------------------------------------


> On Oct 9, 2020, at 4:36 AM, Javed Hasan <jhasan@marvell.com> wrote:
>=20
> Add attributes for RHBA and RPA.
>=20
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c=20
> b/drivers/scsi/qedf/qedf_main.c index 46d185cb9ea8..e4d800cf9db7=20
> 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1715,6 +1715,17 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
> 	    FW_MAJOR_VERSION, FW_MINOR_VERSION, FW_REVISION_VERSION,
> 	    FW_ENGINEERING_VERSION);
>=20
> +	snprintf(fc_host_vendor_identifier(lport->host),
> +	    FC_VENDOR_IDENTIFIER, "%s", "Marvell");
> +
> +	fc_host_num_discovered_ports(lport->host) =3D DISCOVERED_PORTS;
> +	fc_host_port_state(lport->host) =3D FC_PORTSTATE_ONLINE;
> +	fc_host_max_ct_payload(lport->host) =3D MAX_CT_PAYLOAD;
> +	fc_host_num_ports(lport->host) =3D NUMBER_OF_PORTS;
> +	fc_host_bootbios_state(lport->host) =3D 0X00000000;
> +	snprintf(fc_host_bootbios_version(lport->host),
> +	     FC_SYMBOLIC_NAME_SIZE, "%s", "Unknown");
> +
> }

Above changes seems like adding port attribute to transport.=20
Did not quite get the RHBA/RPA addition here? Am I missing something?=20
<JH> Yes,  you are right. Will move the attributes (not specific to manufac=
turer) to libfc.=20

>=20
> static int qedf_lport_setup(struct qedf_ctx *qedf)
> --
> 2.18.2
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

