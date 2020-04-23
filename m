Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703F4C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6AD208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QfQPJXq+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f8Phpv2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgDWI0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 04:26:31 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3288 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWI0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 04:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587630391; x=1619166391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KdizRRS5Yy4bskMISsz9TfKxGaN+YUYsh3d0ofe4yt0=;
  b=QfQPJXq+ypRWd3HAw6DB8Rb2I+K+EtWND1YFWq8GfBMX2cASXkPeTTGG
   uq86jWfgETgCRasHRLnHesxVevQA7d9w1VOgkJULYUNIizEOA39+SoOcW
   hluHcwK5nA0xMes7m15yocNHfe/6B8LLSltHl1jmUpathfmXOe2c5QNnh
   JPIHgmcpU6GLqkRfUjo9tKcQcAypnz6sOQaWYJz17afeg0Xg3hLv7A+tE
   XtjLEuouYOuDe8sM/mAWC5eoPhCwGksjE5S44FbFNaGDi7lWAzr7l/frS
   9XSp/c5rH3lBuNHAd/fj/7Pmr9nrOIqCmxl9Wc8dIUZNRxAcIE+X2pfeI
   Q==;
IronPort-SDR: uUiWK1bsnTf1zOGlR5/ebK9vqx/Yx2IgydlDf2eFiU3JCMPBRMMCMI4ZheO/QcGcYhOz+kTAjL
 4A1896Q/8DzqgWyaNhLJZYxhQ0ytv5gnoO6WVhvGHMHxJSk1aBD+tvaYpAraV6dA5VyVFkiVSE
 bCe9l4aPSkh4cx34+5f8Dj9CbjCLUeo37+oekUNAZjV8896Bh1sakxN42DSK3rfVmnY2JTBRYr
 n8j6bw9UZ4wafMDm0fX0LCNpejD2Rcg2OhrRposFBuFrNJcowFFIR+QyNDGAWi/SbFykOBGAtO
 ZA0=
X-IronPort-AV: E=Sophos;i="5.73,306,1583164800"; 
   d="scan'208";a="140311514"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 23 Apr 2020 16:26:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9Om6i3T5b3ZYHD9uwNIrafBt1URpCbolNTMIXv8YT6lBJGdwEeElh6t5nMOgTPruGtLOVqaT1CVmy63vLtZT8S5r2AEATQZDsg3DhDz9U/Sy3ovz62IHUDRR6uDMiTqDd4Cht83XQlEdUGe5Tb9eWoEhXqAYVtkKdsQzi8YGfeHrdGZOv1U17/1z8JoqhKaDZpBLyCyjje5hjsOtsRE+awV2spDp5oOltNJb3TuHWdbBcf2BqNdQNHOWmjT4IkIFt1/1hMD5l0N6l+S1NM+KAXCc3w+zmM6DRaUBfRY8piEJFFG3sL78OML9L02sfZUNgrbahoCH0GiTOIEG5xTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w966thxD5Z8ZnPzq+zIV91TMNdFbTxnQPaFrlYVRv/8=;
 b=j4ZbkU+ZKKzS1XVwdba4kAEeNFW381Ihx7uxZTVX2/YttyUkFS3Bst438pO5u09An9+iC1rmYeXsGMe14MuS1LqkmFnEa8fQNtOOI3qWbVQPMHM+R/jIPaOqgGzgoeV0VH+ejn7kBH0pmchiCDllibx5yigTtlBQRyi0JkEnJ1lWeFX+GGygKtLOhsGZYZiKSoVZyVHB13imzRG/JtI56Puws1MKeSuBDho5n+iyUlYqVGaKJheWSXbnHwW5xXG7Yz4X+Qy0IeiLTW8dMgkmJID6fhjH8cQ/TtJwDt73BeK3PQMEk2vnfvOF7UKCmTAlULpoko2xx3H+oDZGPaCKuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w966thxD5Z8ZnPzq+zIV91TMNdFbTxnQPaFrlYVRv/8=;
 b=f8Phpv2QuoxpTiGq+Nhc6oGOiOU9mIgV0vylCGZ14X2YMNJKvQ4IniwA7iXQ43efm7dYfvrRTJM26F+SwYJKwa1gVS+HHnf/Ymxba189685Kt8kTr0zIOn+hMSO8GDiubcYBxqnp2u4WV0vIXcZITZx+pB71MgKleyH7otlemjs=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4975.namprd04.prod.outlook.com (2603:10b6:805:95::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 08:26:28 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2937.012; Thu, 23 Apr 2020
 08:26:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "hch@infradead.org" <hch@infradead.org>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/5] UFS Host Performance Booster (HPB v1.0)
 driver
Thread-Topic: [EXT] Re: [PATCH v2 0/5] UFS Host Performance Booster (HPB v1.0)
 driver
Thread-Index: AQHWFC4WQV26aLTX/k6UQWtG3xUzYaiEukcAgAEC0ICAAKsbAA==
Date:   Thu, 23 Apr 2020 08:26:27 +0000
Message-ID: <SN6PR04MB4640BDF845EE64733E5F626BFCD30@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200422064324.GF20318@infradead.org>
 <BN7PR08MB5684489A31196E4490A38DA9DBD20@BN7PR08MB5684.namprd08.prod.outlook.com>
In-Reply-To: <BN7PR08MB5684489A31196E4490A38DA9DBD20@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 80fb3743-b339-4b57-2566-08d7e76004cf
x-ms-traffictypediagnostic: SN6PR04MB4975:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <SN6PR04MB49750568092F384D58A837DBFCD30@SN6PR04MB4975.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(86362001)(71200400001)(316002)(7416002)(7696005)(76116006)(478600001)(6506007)(52536014)(4326008)(55016002)(26005)(8936002)(186003)(66946007)(33656002)(9686003)(5660300002)(66476007)(81156014)(110136005)(2906002)(64756008)(66556008)(8676002)(66446008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zkO4LoStoeE0t6asdp0KlYxy1L+X3mnPpdq5EQANtKbq6EtpEuH0S/kXDfhCHOakwlbeN/q0YzWwXw9Du8akp+FD/U5ght9XoWvoGyCqpOFWDyuTU6wtP4pryivEOocgGYMmzclEOWu2QjXjdIN9cIgfQFJ6OEtkXKxzFSj4PRCimGi+zzMcG2cEY3PqTkSnwGxiijWImnObnG2ypsBzgqRtsqEa/KSEUIbkL10+8oPGfD3Qrmfme/+6ZrMbhszXCQJui+jgkF3mBR5Pvy4OAxDNIExKx5UNKpc7IydK4Y5PWRjAEbVF4Q4arkGi2P0FTmWJsXoGGQwUKX0LclKCxJpWmwIvlTuK/pKL12SOLc0Ymt3guf2+84LBAFKNxrkaAfNCXfpWbmHxH6J1y89BHSqDrlGUl9BJmJ5Ij36Komja/jTsml+t4fm5fo4SVQ/q
x-ms-exchange-antispam-messagedata: qKw3qtyFc3AypCom1kgPbMdSk92x/ew4Q1ai7smWF3ENbVxrz75kXxnvJBcYsteKwKKB8PRR0P6IrqzDeojEWbdXbf9cWp9/CsEi9OUdLzlSnqNuJPU/agcZEsg2kCOPH2kBc0wj2DdHNSxERKzs8A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80fb3743-b339-4b57-2566-08d7e76004cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 08:26:27.8236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rwDnxYjhe3yJRxPcn+WOlFsAB3fUFh3EqoCASN9o98ipNljvaxbSeMyX6FjEbP9os3NCb/8eCWRZvhHOoKyl4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4975
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Hi, Christoph
> Thanks for your feedback.
>=20
> > > To avoid touching the traditional SCSI core, the HPB driver in this
> > > series HPB patch chooses to develop under SCSI sub-system layer, and
> > > sits the same layer with UFSHCD. At the same time, to minimize change=
s
> > > to UFSHCD driver, the HPB driver submits its HPB READ BUFFER and HPB
> > > WRITE BUFFER requests to the scsi
> > > device->request_queueu to execute, rather than that directly go
> > > device->through
> > > raw UPIU request path.
> >
> > This feature is completley broken, and rather dangerous due to feeding
> > "physical" addresses looked up by the host in.  I do not think we shoul=
d
> support
> > something that broken in Linux.
> >
>=20
> It Is not plain physical address,  has been encrypted before loading from=
 UFS
> to
> HPB memory, I think we don't worry about its safety.
>=20
> > Independent of that using two requests in the I/O path is not going to =
fly
> either.
> > The whole thing seems like an exercise in benchmarketing.
>=20
> I agree with you. This is my major concern. I have been thinking about HP=
B
> implementation in SCSI layer.
> That will let SCSI layer manage HPB by calling UFS helper interface.
> If you don't consider UFS HPB is an idiot design,  I want to  change in a=
nother
> version.  Firstly, we really
> want to hear your suggestion.
> Thanks,
>=20
> //Bean

If indeed this will move forward, please publish your patches as a RFC,
To allow competing approaches to be published as well.

Thanks,
Avri
