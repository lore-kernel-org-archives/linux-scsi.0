Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5D8C17440
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A65B222BD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="A4F+egwX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OuSmPl0H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfKLHKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 02:10:41 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52561 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfKLHKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 02:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573542641; x=1605078641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1YwnslQlx5lccCrqn3pBaRl5u3lohDZiCHDp02xXj/Q=;
  b=A4F+egwXatZpO37Dv+iLDyyd3fN/9j9Z52XGVkuHwxV3H5pLnL+r+YDB
   hkiA5nJcwMEH2Ezy+MHPOrDNI0oiZEVRdf0+txxQm7kZrLKC8GBqr2k0x
   PJ69qacFiHBmK+DifXV4NlmtPLKdRzMK+xp2RGXfzKByY6oxNcicgHQsV
   WYtCcLaiL9y1ShlAifxWUyA6GcyF6hI+30XK9caJMld7VzhMQiGvBKMf6
   kySXg+JBs9rAPJkSeoetI+1UJfka/j1TTJ5aq0i3ENfDBzoMU9Gh2ggJ9
   M6kevxBxIymZa2RXgP8YtP3rpoU/dJG6LL50+TO+ZAmGTuVxIZ/xBRPtq
   Q==;
IronPort-SDR: IjS4uvLjoWFbzxkko5edfKV2wct/F4zLgbd8MqstgZpn5zAXal291dtxa75g561Z0Hyhutw5JP
 GxW9VQr3dRrztjTshOwbdCmefOC5sz80bjZk6oifoesbiZ4hP+UcQI1zlB3Bvp/cw9/Cp43znA
 rtCrTFi7af+O1pUya9hNuzdvw7KbYOGNJjOxic8qhVmuyJMHXpySZp725GmaPVRWCYj3gtSg1j
 fkcb/n0TOOhfOSSySC5H6TGk2rmXJpkpu0ohhUOi72Ngsf2BQv/c2ldwpluh2XWB5eD/9CJGVa
 yW8=
X-IronPort-AV: E=Sophos;i="5.68,295,1569254400"; 
   d="scan'208";a="127162020"
Received: from mail-dm3nam05lp2052.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.52])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2019 15:10:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOSRRY+kBG7W2KYHA1BDlzXbQJrgwmk+aufmCOT5fqJhe8C/ttgyStNzbNVg83bNf/wwA91Z5sE4m4KuyLbXIetZNf9KE1wRsSYiB6VmsxEEO+udQhFxwJQsSuN6n2DA8BGxEz2ZtPsjLx+yw0t8wZhRtN6CwBfg+QwOkUQSu3hPHO8v95WZgvyjOoIXLvVuOUWxXUcqLFcakOxgRXvYX0dZtQPGS8rxwVJTUUquALeM4rgS6e+ZwCk/F/THiA6Pz1JZV2ju9msATCzE2yr+mABgKT9TtCLQ2t5MxTV3AN+j6BcC56n7+As/nAhpyylKXu5etGz2Hkm5niz4wiRHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YwnslQlx5lccCrqn3pBaRl5u3lohDZiCHDp02xXj/Q=;
 b=oOIyXOziYueQ9fIY6bNTYiBvXC5usY3p3fCSHHsxI/i7nu6pYNCULku4BZrDOY0h3A7PZLgATopgWOZfmteOglI1uM2n9n1JtC6h9wAlBQgEOCd5+G67rMQPGcdsFQrKbOceDaabfQvmf7RAF2Zj+u6wB5oMRMbhAzdT4pyE2O1ALoZAguhYd2UxjWJ34QDzz9a4jujeRhinReG/Uxz3O4+mW6WRLpVycECbmPmkPAVIgCxZG4LP3FnVNH3zmXsgQtiBsEN2adQfKNMVM1gxJhVO+YZw00k7P/OqbVXOy6w8kI/daEeJFiEoNpk5n996UzirMc6XDAQ7nun+DS4Jvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YwnslQlx5lccCrqn3pBaRl5u3lohDZiCHDp02xXj/Q=;
 b=OuSmPl0H73McCDmkftpS/jHrkKLIrUnxVwty/2b8aKKZOvZt/00Q1PpVzz72f2cBuPu7uhRgC+g2X3+SKuwg2L49RqiO6bIF/EZSmn2lek8IAIuzM7C25pe3MGJLoZYhpqNCl38Yyakb4PBz2EESu7OTK62RRDXhFoOuti4FyLU=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5664.namprd04.prod.outlook.com (20.179.23.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 07:10:38 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 07:10:38 +0000
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/5] scsi: ufs: Recheck bkops level if bkops is
 disabled
Thread-Topic: [PATCH v1 1/5] scsi: ufs: Recheck bkops level if bkops is
 disabled
Thread-Index: AQHVlgy9aXqCRANwik+MtMzDwZUC2qeHJDLA
Date:   Tue, 12 Nov 2019 07:10:38 +0000
Message-ID: <MN2PR04MB69913E6B58B9B474896BDA76FC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b03dc81a-0430-4623-24f1-08d7673f6bb8
x-ms-traffictypediagnostic: MN2PR04MB5664:
x-microsoft-antispam-prvs: <MN2PR04MB5664F1DA4D19DE878ECC63C8FC770@MN2PR04MB5664.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(189003)(199004)(7416002)(7696005)(476003)(66946007)(81156014)(446003)(66476007)(11346002)(81166006)(2906002)(25786009)(64756008)(66556008)(8676002)(2501003)(76116006)(256004)(33656002)(478600001)(66446008)(14444005)(52536014)(14454004)(8936002)(6506007)(76176011)(102836004)(5660300002)(486006)(55016002)(186003)(74316002)(71200400001)(99286004)(316002)(9686003)(54906003)(110136005)(305945005)(26005)(229853002)(6436002)(71190400001)(4744005)(4326008)(7736002)(6246003)(2201001)(3846002)(66066001)(86362001)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5664;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xRdfJgWsocnfWliQrPpxQDTxnZo7bl7tIwkpqV8g+uFNA9wP0akMl7C4/Y+HRdBKxRwzz02K4FCu3sx0jdfQK5o0ERuXcvbWykruuO/iZBkRcPOBk+khMCsyrmnetMI/n/Z62ueX1mZ2ldZ669t/EJFGf1KTBMK0npe+lSYaxj1AqwfLGed8hmgZkRIbmiU1k0YT4BSn8UXnQ9xJeHpIPpe7DJW0QA1amDT4NGEK5b6I4/eB+2n8Gsb+vhdPsomYJvmpzKflxxlI0SRFdryZ6/SqIAjyddoIaQ0zjhOAfmJI+ZLF5J7yymxfKr+7bVf8QFi97JmEZAHRqb+rigFDw+IxrVhhNHIxYFNMcPk+ymOb/qoKZB2/58SFEvCHjMTeWyYt2jCfFKYhEROGvD5jpOztYIxmK3BQ/xtrnV0NXksltL5Lggwvouyq15504x1f
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03dc81a-0430-4623-24f1-08d7673f6bb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 07:10:38.3019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8dsCbI4wM3o/A3vDMsdy09CGDv0ojo7M8qXZkpy4PvCRIK+zzCk3xvFadF4Cz0p31tzIIkkbLS6PhujOeKrjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5664
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Asutosh Das <asutoshd@codeaurora.org>
>=20
> Bkops level should be rechecked upon receiving an exception.
> Currently the bkops level is being cached and never updated.
>=20
> Update the same each time the level is checked.
> Also do not use the cached bkops level value if it is disabled and then e=
nabled.
>=20
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
Acked-by Avri Altman <avri.altman@wdc.com>

This is essentially a bug fix:
Fixes: afdfff59a0e0 (scsi: ufs: handle non spec compliant bkops behaviour b=
y device)
