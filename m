Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F134C43457
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 11:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4FE22244
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 11:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YCJm/w9T";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Yn7SXo7i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393907AbgJTLyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 07:54:45 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5732 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393905AbgJTLyo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 07:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603194883; x=1634730883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QMHyMLHU21F7/h+3EPb49hFqEKKmkXc9oQRFbVEBnbQ=;
  b=YCJm/w9TmHgGDiDUuKZ3p4TmT4idhWvDCBrJ10myeEVn2YLdIp1DX/jv
   D0U049fPcOZWVh9mVYyP7hQHjWcAhOKH3i1HU+woXdvklemnNcmoyWkAv
   tl8fAACCIKh6fZrY7yu+kBj/vN4p7i//y11u4FcJPqooWplqpu5kxbfAH
   xX/g6kNSST2p51xOALGDwmM6dJctVjimKhTkczVWoCJjJJH2rGM7sCJsb
   cbkhaBnLK9Z4BpaWesWcgWQCOxrC+5VwcmcL53bSSIR5Hcorv3Xh//l3v
   gSc9Y7ZdfSz7vFjH1DOF8BqiMOsNAWhLDEp8HDDVkZcqIwBo+UQpZtafy
   A==;
IronPort-SDR: 1CO7lnbW0RY0wPDdf3WSJjErPV2GjjBBoOXUdAfFXeJz+sZ1vYU7D8bMmRwgSDpVGt2Gy2auDL
 HIQebT23U8vBIShB1qivy29NXUNynJ/yNIbKIxzahOQoJDUuQsw9l2turXcHd6/pyIrd4jj2FY
 VxzGSxVZQ7++qyBJvfQxjCCSmsUAcW5CDEo4J1qRbx2ix5+PCsRc0zzj2kilBCCGYa2sBqY9bR
 rfK2iDqBquitGN858xD82/4sHviMVQ/IeOlr1hAVseCfd7saGdRw2Mq9+b72+QZm5CvsO8G1g6
 Fh4=
X-IronPort-AV: E=Sophos;i="5.77,396,1596470400"; 
   d="scan'208";a="150491658"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2020 19:54:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjQhDYFlPVrW+CH2ICDI8nS1JizBI6hi5SirBvmnBtvRvPoZ0mw7zVDp6vApta0VAs/8H8bXy2SXGT+Moc4eMmKaUH/nwrYxugQetFXQr6kgnsoHNy/LzAQ6xlLL1jaSaYV042OqRowSv9LlDE/CkS2YgJa+MOS823jXvfO0AK/mphyobbGcvDOYmWfg7RSxEKVqc8NbWKTah+4NF393GxuuRBqBQxCAMEYTMitrM/Wy/3kD2DgOjuadZQ+37CWu8lzknuzbcCJjkchvHTaMXmn0WYXZNw2b1NsLCc+GPtnFhZvBs87aaxeSppa387xVk0rts8iiQVOALEQybL6IcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMHyMLHU21F7/h+3EPb49hFqEKKmkXc9oQRFbVEBnbQ=;
 b=THYSp+4Wr9pmspm/57Fg7sTnT3stWIileF2/lM22+f1BMZ8Cp+I4GhMZuPz8aFGX5bEwx+jp7tjOKCZgTzAQTM6BqlRlnAvXSddedPmMcwoq3Yf72ekhjEEnm2pFje7EHDFfT7/5S9/1nLwOyNwl69C6hTfozCWqMo+Tv44cbTJ78f/6ZQ3vyUIRCy5rFv7RZt1vehqc44NEKb0cLORFiiVUq/lpcUdIec78SiOZxc5mIv9SdrdtotFr5sxbMNUZZ1XZZKbMWr/OK6MeRhn1hksve2qP4iq+VXB0qY6HbiOdHcuCKXUTQaAm2e4AYOaeTBCZBQMnLA4tbAfSj5To1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMHyMLHU21F7/h+3EPb49hFqEKKmkXc9oQRFbVEBnbQ=;
 b=Yn7SXo7isxIPBc72eYvViicfUC2NBA12JQWvjiXHDgISGIUntmqSPNLRFiyPHPcnsVEsgRzR+n2ae3vvsISZDrxXHtvBL0k741tTNkGDn3/KxbLCW7hijBz+2FFqIY1rIoJebWQoIKVz/lljtsaOih1a8PbVmozn7BekPQdUiKI=
Received: from CH2PR04MB6710.namprd04.prod.outlook.com (2603:10b6:610:93::10)
 by CH2PR04MB6571.namprd04.prod.outlook.com (2603:10b6:610:34::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 11:54:41 +0000
Received: from CH2PR04MB6710.namprd04.prod.outlook.com
 ([fe80::89c9:1384:f052:530b]) by CH2PR04MB6710.namprd04.prod.outlook.com
 ([fe80::89c9:1384:f052:530b%6]) with mapi id 15.20.3455.037; Tue, 20 Oct 2020
 11:54:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 4/4] scsi: add more contexts in the ufs tracepoints
Thread-Topic: [PATCH 4/4] scsi: add more contexts in the ufs tracepoints
Thread-Index: AQHWm2f/I0ejIh2QaUeberVOQ/pxIqmf19WAgACO0tCAAAOpAIAADh/w
Date:   Tue, 20 Oct 2020 11:54:41 +0000
Message-ID: <CH2PR04MB67102BE739313DAFFCEBB680FC1F0@CH2PR04MB6710.namprd04.prod.outlook.com>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
 <20201005223635.2922805-4-jaegeuk@kernel.org>
 <f55c7b379283bfb90e884e9b1bdf170e@codeaurora.org>
 <CH2PR04MB6710F6367C3862F3107A78F5FC1F0@CH2PR04MB6710.namprd04.prod.outlook.com>
 <14935822cbfa6d54df34946bcb2ccef8@codeaurora.org>
In-Reply-To: <14935822cbfa6d54df34946bcb2ccef8@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e4f2a4fa-e301-4c20-cb1f-08d874eeee0b
x-ms-traffictypediagnostic: CH2PR04MB6571:
x-microsoft-antispam-prvs: <CH2PR04MB657134543DE9E42E30769BD6FC1F0@CH2PR04MB6571.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzi4ioOEg8h6Bp4WMP7Rx6230rF/yV322/haKu9cnknVtSoYr8AffJUZBe2HSJDqC5ovtwd8Lay4PBy12rKieRn1QrqOJbaBm5IYR/G3D9nKcPUD1/KBr1aXr/BUI/r9b4yNkuRUMU+Sb7MPjizQXR5JqmTozcXVSmysA2nV2SFI4wJp1uxZse6X2tUxQ1OPxAnhaE9kQcbtwK/JZfZwjXLtPKMib5a2Cal6QQsG8y4tV280AyEVqxpYHS8mT0xEDEF9XiaZnb+/+SKBQri3UwPuk76dkaXe2pMyrPboBKWpJG3mMFMnlvvltgtHj8jDRoi7xn0LkldHK8Hbd4oD8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6710.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(52536014)(186003)(64756008)(66556008)(66476007)(66446008)(76116006)(33656002)(5660300002)(6916009)(55016002)(26005)(8936002)(66946007)(53546011)(6506007)(4744005)(4326008)(8676002)(498600001)(71200400001)(54906003)(7696005)(4001150100001)(9686003)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: w5942pb4oY3i3YWm5HupMNmUg+nzxsWtp1Tx9pfQ9Ui2+LJheWzyMMZyfUlLFSsEDVEEcpKfp4BGxoV/RQHUYfdIO/gPtuYKEnqCC7A6W89Rj38Uwpl5kpKxqrSEzw5ayTE8HlZoRY2jnFm1T911nKNdCXIGUpKEmghom4Z06xEfDEaew6sB3xzyWHCbNwV8Z80j9SjXi8lGfL90oTkkwEqYPeF5fM54/FwcUqDCMGawkaW65eq6a4Te4bz9Z01S26pwHhAfPtGFZ5/dFBzwoeYNh6YzTaqaOTy33mJY23SfpzqLCWb1GYjkvdu5XlwIpJb6SL+99pGNK/2bYMmdwhrDIHHXAPLhCWaBDlBZEdxj+ptIPFaWcENf6tBAUF4E3dx+qjCaaNNbDI/Yrpczjb0ux9WlWMgtwRATLBi6QZCVDZrzHv5ePLOjvkcZJPBT+SffeiwQmxxoMWi4zWuq1cxOciPyanoSNBwySOfJJZ7XQIPJLbDPD4d1YUkD2Dl/Zf65kY4NIrjfOyg5dGKvhShWEm1A3lmERLJf7F+B/GnCnshbDPVSrhUBRnVI9j/kGYjL0MceWxvUJcQPrg+fyguWNffOPwG/ocoVcJV/nrUWfVZkVvYVGuSGgZ7l/dmo6DHb7DpRsVtieyEupDQzVw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6710.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f2a4fa-e301-4c20-cb1f-08d874eeee0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 11:54:41.7325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbXmof4WH3YSa+B8EsxlEQdCqlxErKl73WkGeB4h53k8HlfpDcj35H1ruk0DywmpDr6UMzfTSL2CXQUMAlHt9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6571
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2020-10-20 18:51, Avri Altman wrote:
> >>
> >> On 2020-10-06 06:36, Jaegeuk Kim wrote:
> >> > From: Jaegeuk Kim <jaegeuk@google.com>
> >> >
> >> > This adds user-friendly tracepoints with group id.
> > You have the entire cdb as part of the upiu trace,
> > Can't you parse what you need from there?
> >
> > Thanks,
> > Avri
>=20
> Yes, but assume we have a large trace log file, having a
> groud id allows us to filter the data by it easily, right?
>=20
Ahha, ok.

Thanks,
Avri
