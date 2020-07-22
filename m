Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E051BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 06:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B242A20771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 06:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gndpur7i";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="l/OLusLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgGVGSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 02:18:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24625 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVGSa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 02:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595398709; x=1626934709;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2dsFN6rE3tnZuCcuYxrjtpok8dH9telNTAhkDSWt4YI=;
  b=Gndpur7ioBrblLjl5ktf9lh9gwmOBXUeyu9+zS6YtBsz76/g1RABpkIw
   FRuAKzGb4U7mZQNOHlvbN1m3//W30/ebsT5MCyeNuKYzcPNOzB9A2a9Aq
   EteYZ04HBwAgfzNEVKGnYLAYzMq5QAOAQk4Uui1rUXB1DxTNuo2178Cm9
   O0r7ChJV8egcy0W6Nz+frFzYO7Uxgrsly8QxTSWs3eVu769EedxkK9Nop
   OeV9fw/diidfBXdLbnQHCvxKy+d3WJH4BhqhbxFBSguCm638NbEbZb4mT
   moBHYJMrk7i7ahfabgBSUMq0HY/h4FrMkkH/uQgxLZP5p97I6xLhJTuFV
   w==;
IronPort-SDR: SN4Ic9BX/T63KRXBdwLcJna4GNCP8DxHgdcubD4g9fS0pqEJnX9BZEBPLBMx3/E1ogzT15sFOS
 afxdIvscw8j0LOSTTi+J1p9O3kZD0k6r7t6PCVGN3c4ooI++uJeKCpEzOJKBykI6sa8weH7159
 1mom3c8FNUVWP0ADCHD9K/BgnVHEl3F6tRSWOJLsRc2ZamWrEEG7o1x1nsjBvo8MD4Lf/UtNoF
 WkZylAQGFs6xuUb6o1V9NRhHQhaYFZlkFJ2PvwahHMv024ILAnLQuFrsko3KtpFx3sPloIsvg5
 64g=
X-IronPort-AV: E=Sophos;i="5.75,381,1589212800"; 
   d="scan'208";a="252371238"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jul 2020 14:18:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UN+g3wzxvsQ0TXTV5Ef10gjnLMvDh128nvwSeDRpHrABDYH1pCPaY66azueMWFg94d0yI6pXjqSBasTfeOUX754vlOxq6FuS+cr0I2c4VlWWZbV7mGdKTFy76+5R7fHsmZFDBaeB2t8g3xJt/0JXAveUtOIcOecwV+ebjNS9lhSB5IjRSKsEx8+YWoWNIWiaxuMUUEmqs8DITKyAiIJgsBuWujPPKsGoC1EBUyEPbUKxxdF0uyMS4saEjOKNfNlZ9ixozA3F5yd7YUYy2cmaDV7bjC5qt2T8T5pUz9HoPAlt2Y9kC+W3UevJvnGTrhcbb6CnyU/7zD/PDROSDCRSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMP/SMzTQvVTrtjvmJu9THr+z34jJFPaS7iLe9nwMCY=;
 b=jIVNkKnGVqnEaZzt7tmq0tlppeXkPAvcjkoVZluZXeBPqXlNjYSYCuNE4s66CPdCbiylI6LqYQOR4iAI5PDZY16gajJn7q5DpkjltPkyruW10mBNVSGH6zjq9tg/Wop9NTiDQa/OQlI4Fgs4EXgfD3ehKw4vuKiPlnzmXiySOUmPtTRY8Pd8bf/7e0Cw8G0ESCCZvTowUIRQAvj9FMdWFLIk96t5e5HBFw5HGM9L0fqWViXucLROo5gvRoG47rx94yVEOgGHUJdHadKbxC+uq10m2HjynT/XxM9YBX16LWU5uIcYaZGM0D25YykrezlgRfPK/hF2DlgQEsxHFJ22KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMP/SMzTQvVTrtjvmJu9THr+z34jJFPaS7iLe9nwMCY=;
 b=l/OLusLpBGebZxeZ193rBqbpRJYz7KWN7sPF9t+iUAZcyNljI9C1MBixeEiQsfEkD/WjleC+/CXDxZ0Y6blgxWKQXxF7k6V+3QvRR8rgdNvEF2UxxFCfjFmzF2de5Vla2vGlHG3tWk+Qv8yUJdJI/2Z4azxHQfPAVcQnWYPfFsU=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5360.namprd04.prod.outlook.com (2603:10b6:805:100::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Wed, 22 Jul
 2020 06:18:22 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 06:18:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        'Sang-yoon Oh' <sangyoon.oh@samsung.com>,
        'Sung-Jun Park' <sungjun07.park@samsung.com>,
        'yongmyung lee' <ymhungry.lee@samsung.com>,
        'Jinyoung CHOI' <j-young.choi@samsung.com>,
        'Adel Choi' <adel.choi@samsung.com>,
        'BoRam Shin' <boram.shin@samsung.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWWQGynHMGu/0fRkiVvG9Dpk1z6KkJaD4AgAHaWnCAAzipQIAEkbxrgAAf1kA=
Date:   Wed, 22 Jul 2020 06:18:21 +0000
Message-ID: <SN6PR04MB4640A603AE3973E5738ED3DEFC790@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <077301d65b0d$24d79920$6e86cb60$@samsung.com>
        <SN6PR04MB4640A5A8C71A51DB45968DAFFC7C0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB4640A85E665E20D709885E16FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <yq1tuy0fag7.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1tuy0fag7.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9581f586-0000-4fc9-306a-08d82e0708c4
x-ms-traffictypediagnostic: SN6PR04MB5360:
x-microsoft-antispam-prvs: <SN6PR04MB536048AE2964DB2EEC44610FFC790@SN6PR04MB5360.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:370;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AtVOlreoNk3cI5OLA0H3xtdEbm6m7ZnDUnMWR+rT99sCxo8+/myWorL4tx4KErYyM9g+HrwAfh88wwaOoZnXYLxj4hSIWXSg50z26CJXE6eNoguAUxv1+EqiYI2SVrW3wSYnE1lHZBSW4TfgWmFAB3yUMa004gYw9Q/l9BoJ3MuVehR1yOcbY5xIl4Re4Bt6ET72fCg6KcsOrZ/8NMXQaoclwbjBSqa5s0Xn0ZbRa9wSrm8KN8eh47WYsyBl0sDNJK+vOyGKlLc/N+3EIAUw9w2ee3nGwayLc7dPLbEKsP9nMPxrIbAi68d300bVPbMDnr+3IdVZl/8lhQHDqhr9/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(316002)(8936002)(8676002)(6506007)(4326008)(7696005)(2906002)(186003)(7416002)(478600001)(26005)(54906003)(6916009)(86362001)(52536014)(5660300002)(55016002)(83380400001)(33656002)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(9686003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wZi1e9U7ACfUn+/+9De/YDWZ9hx3/mNwqGylPlAvRxm4FFWze6gyEUiIKtGrjIIiXzq5A5BI38+3JwWLu9Q0h5cAcGBJrMlJk/ofLvN8xq3Kv37l/oqskXDaEnVlO1SurTGcPOi7WOYjXkalwxUz8hYr8tAGpSZRp0J6F7zrJasKDZ3i+nzwzCol/bNywfC3gy+AK1Nm2IF/kxjnR2k+UU5NWPTHPYWjY38bkaZGd0Eh0vnMhlVT1ZGLZa4CTamRWDzu7oPEtVmF6450oy6IL/aFPutdXF8SYvJLsZvqtwthMwr0uJ2ynIT/edLyOFOb1fYLzL8IQeKxqE9a6mnqOP6rZQlt49gIkczwMIEB5qvSjwgRrKapKjtySq7Uq9VMTI5cCJZWNIa9n/hzGx2woJoaWvo3+FsNl0HTUkyJZ0SjfxZzoPtWFUEYeCviQ1MY5bSTQlfWNvuLSdiCtzwFV/66yFmaD1AMImOMfxo+72s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9581f586-0000-4fc9-306a-08d82e0708c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 06:18:21.8000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MeMUVYvh0Y8wPLIKWG3Li8HVMtHV2o16TVVzOl3uOWzuroMu4wcDc8hFMlVY4WM2TGacn0zT9EYcXCS+PYE9YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5360
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Avri,
>=20
> > Martin - Can we move forward with this one?
>=20
>   CHECK   drivers/scsi/ufs/ufshcd-pltfrm.c
> drivers/scsi/ufs/ufsfeature.c:90:20: warning: symbol 'ufshpb_dev_type' wa=
s
> not declared. Should it be static?
> drivers/scsi/ufs/ufsfeature.c:104:17: warning: symbol 'ufsf_bus_type' was=
 not
> declared. Should it be static?
>   CC [M]  drivers/scsi/ufs/ufsfeature.o
>   CC [M]  drivers/scsi/ufs/ufs_bsg.o
>   CC [M]  drivers/scsi/ufs/ufs-sysfs.o
> drivers/scsi/ufs/ufshpb.c:18:14: warning: symbol 'ufshpb_host_map_kbytes'
> was not declared. Should it be static?
> drivers/scsi/ufs/ufshpb.c:793:28: warning: mixing different enum types:
> drivers/scsi/ufs/ufshpb.c:793:28:    unsigned int enum HPB_RGN_STATE
> drivers/scsi/ufs/ufshpb.c:793:28:    unsigned int enum HPB_SRGN_STATE
>   CC [M]  drivers/scsi/ufs/ufshcd.o
> drivers/scsi/ufs/ufshpb.c:1026:31: warning: context imbalance in
> 'ufshpb_run_active_subregion_list' - different lock contexts for basic bl=
ock

Martin - Thanks.

Daejun - please run Sparse as well, not just checkpatch to eliminate those =
warnings.

Thanks,
Avri
