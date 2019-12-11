Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1184C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 10:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D0F721D7D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 10:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QNh1ExNM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eR5/bgof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfLKKhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 05:37:52 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2057 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfLKKhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 05:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576060671; x=1607596671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Fo+HkxGQj70XRc41XzazxMHK4+Y24D69f3Rqf6madM=;
  b=QNh1ExNMqD9TC7xe8nYeLHprT1CVXr55hJ5rHIPP7CXbcbSp/KpgXEs2
   Ekn7mWttsTAnz1ELRy0j0386Jwm+XYr0OljMIkJPXC+BgqUTt/yk+g+sL
   RLcCze6CkRCmmkT4l8zoMRcsJOxKwcjVzVvzc8aE/StPdIB/Z5T/oz63h
   uMdOpedgiXJ3hVDVZnSg6lGQJrT4RieG/lhQJKCvcIwLP5hhIqwm0Ptbv
   QfOf8/zF09EYXbr2Fi31C3uwwyxWB/Cs/aT20OaJyGJoZ+xIl+RsB/rnC
   WlzncUDgWJ1SdSrmiKjalddthavxcB9ZfXtWys1DJehL/qAkWViAxuMRP
   w==;
IronPort-SDR: 6VBEF61YkorfJeleLe6cKXIZV5QFlil+d2DrfX6cWG5MCcYvhSYIlG+74gHPC7zc40gNCcyy8f
 2FpLe6w684xiuCy1osAQ2hIxNZVj2Izd3RKdcgNi+eXG82znm3q3p6VAamCVQuTiSrLZEOdl0r
 nJ6w8g4dtnsOE8sqy0gQ4NmD1ElV6817PfyXN58IXxlikKGZLFmQqaosZxBhJhSd7kzJuOSrBM
 0j9oBkwhI1mxp9nla0Bm+C7gBkbegRoy+INFoDeprtgDv8A+5byP0wMqKQC+XwUPG9qg5Bq9lB
 MzI=
X-IronPort-AV: E=Sophos;i="5.69,301,1571673600"; 
   d="scan'208";a="129531089"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 11 Dec 2019 18:37:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+kvq4bQC49d/Ot+nDnblkVCTNQecVQ5RH8/jrkgwfgW9dntQsn3Vrp4bhHaLHt8fSh+FVd7NSvoKFayrJ2vdmkRA6oxa7sesTWZEEEzDsJ6kS6kgC7mw2pem4YzbTBntcTXbNQfWwGliia24yvQ0lmWMv1XuZSLo+QxQ8gopCS0h7Indw5jdWKr0sSKg2xx4/IbTv5I/OZCRtsKCqpCZn+Cub61+lwkogS0qC4FYRG5zxWFG70QAuLOi3nnTD+X7MbskQP90yx8deADS3pvMDYPHRJel12VQMVPz68j3NMS8LgLursbbQ9MjVyOIoG4g96jlBR7ox98mszlxHAvfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH9vPjwvhUYBYJ/82Vt9mYQPJSn/dpKQH7Q2XjexgoA=;
 b=AtInRs+71b7Qc3s06SnnbCylGTSYsDWvoPpLUTv07g+yltgfQWFclqf/I7bCkHq3zGGrBaoa4TN6MDnq30RIPnC7MQ/4Cl3liYV+FJi7Q2h0OfswyZ8iZDbasFp7qktY3S0/AypH2NNvFK2TFMi3q//l4B8hJr5/Wb8zT8b9+8Tle4W8CstfFQHTCXi1/ljdVyRI80MYGiV4Bd//8fJzSzRKYfKKzXwEoOoMCumq0rs2KiLeVj4hYxM/hi1A4NHgYCIWiDSpprRG31RNU/PxfFrfD1lZxfrBA57bQi2x8TLHB7t9uVZbtudSAvpBin1fInCYrXiaRXk82P5Z3yn2xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH9vPjwvhUYBYJ/82Vt9mYQPJSn/dpKQH7Q2XjexgoA=;
 b=eR5/bgofIGiaLOsrLWR4uw/OT8tmj3k7NXE3ZP5jqvUlLF/O6CANkY8qWHHtGZglEeH0NCmD7SLeZpTXgB1DmbiI/edSw2xpT6pbI5csP/1aCM4PEmmBPu8Buca9dDT++IqNJS1qkBsiLi29unZGPK1ZxQaBfHkPTOI4ZYYh9qs=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6383.namprd04.prod.outlook.com (52.132.169.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 11 Dec 2019 10:37:46 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.012; Wed, 11 Dec 2019
 10:37:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
Thread-Topic: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
Thread-Index: AQHVr//RJYxYdS3dXUmhxTnGX2MLCqe0vdGQ
Date:   Wed, 11 Dec 2019 10:37:46 +0000
Message-ID: <MN2PR04MB699184D76E7F9BABA923043AFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef4259a7c-76bdf010-88b1-4309-ba24-8c874734184e-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ef4259a7c-76bdf010-88b1-4309-ba24-8c874734184e-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3a1a4450-3862-42cb-8892-08d77e262999
x-ms-traffictypediagnostic: MN2PR04MB6383:
x-microsoft-antispam-prvs: <MN2PR04MB63833FD551F387E5C4E78A7CFC5A0@MN2PR04MB6383.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(7416002)(7696005)(6506007)(76116006)(66446008)(66946007)(64756008)(66556008)(26005)(2906002)(81166006)(8676002)(4326008)(81156014)(71200400001)(66476007)(186003)(8936002)(54906003)(316002)(33656002)(52536014)(110136005)(5660300002)(9686003)(478600001)(4744005)(86362001)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6383;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pOqEmXZ1wXCWunu71aInm3zxipuc8T6H7sYJWIvwm2ArMRKbgB6rfRYg/ZlNcuuhi5XUDHMDzWFAYpNRphiWiUv89qz5w1Uc9uNlE8xl9C3GQXvbjTkICzUr89fcGnQILIOx9kNjYJWyp63RtGUAWj5rGBf7BF9zB+x68PLeJtg0sQUBfqeRevnZ0pDVF+FmtWuh4J24KHslJkqZWj1Qr1P3KwTX2UsJEnYOdM98hz/bpo22sbAIxfJmZ7W6k6cX1rpV1dOE+7QCrcHvPjfvofALZAnXGiRiRcfNdSOaXpaZ6HjqbS7hq9zBrE+uQgOt55ccCzbPPBxMt3A2jChdm3Hs+blP9kEA81cJNyIW6HXnC5sCbR6FA9Uhn9g7Iustclj5bn9XbKQb02qR+r/oHgfSWCzbUX4asgJy2/ELJALSKneYd+b0XdMufS6ND5vw
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1a4450-3862-42cb-8892-08d77e262999
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 10:37:46.5908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OHDxee4lRiPMYT/OqHhpicmSUCHXUpKMkt3vuquckPlJc2NmP6MLg0US2i3e/xniAJlmCf1LqA2Wpn4jlSGnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6383
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> In ufshcd_remove(), after SCSI host is removed, put it once so that its r=
esources
> can be released.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>

This is not really part of this patchset, is it?=20

> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> b5966fa..a86b0fd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>         ufs_bsg_remove(hba);
>         ufs_sysfs_remove_nodes(hba->dev);
>         scsi_remove_host(hba->host);
> +       scsi_host_put(hba->host);
>         /* disable interrupts */
>         ufshcd_disable_intr(hba, hba->intr_mask);
>         ufshcd_hba_stop(hba, true);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

