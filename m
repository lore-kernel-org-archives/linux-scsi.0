Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B14FC5517A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 05:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EDDB2087C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 05:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jw2H2txM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="u4kdvcrq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768295AbgJZFWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 01:22:55 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3524 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768243AbgJZFWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 01:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603689773; x=1635225773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nb6LF5bRK6CKsc1ZpUuS6Tjb3KmxBXBhtGywhbJd/HU=;
  b=jw2H2txMl4q8et0HM9XizZsnQIMQV6FysNeTNxCT3EZrcyBMhnbeeDBn
   vpKQW21Fw0X3fH82VIJR+DZaEUuSFdk0Nso+WkT1s/lNBsldpTDcGSYy+
   dV/r6lStl4fGGRquq3bHuu1J+ttyWt2l/5e/EJ/WnSOxtvBFItTm/jtlL
   kzauGbyxFUk8+1nUwJMvtr1vYqF8rAqG0vATJ7MNOLqDQixLoCD1jdINz
   fQSeHbJSXzsIbszO+9PCSV/1MP8coDN68TSHaLTvxBlpI5sw7hXYsEiKh
   vCTkjoe8RZo7e4BVeGeYsBS28L7m0RHTMxk189z6A+jIDe0RNPvbw9XEF
   Q==;
IronPort-SDR: irs/A6VTzQ1otfWw+OYX1rPeXUsbACh5xG2/x/7IKAUOnPMSojcEOx5EXe2RTUAwrsPBZ24LAI
 hxTDtTUsbYXUFV/wu4fDExux5gE0iUbH8T5FjUNSsVqDotaRbF7GVWrRdrX7y4c6nQoxZv1h32
 wekjhy22VXEeNhBHo/BlS+6YZRe+jj3PUMX55rJXS456vlc5fy3TJRXF2aOiSeKKz9K0db9MFL
 wvcg1RvtJkrkNlcRHcGngGqhyxuTfy/qeGA0uFfGdD7C1LbTDkeZQUB+njwSp08kXq+kuRKElX
 ArA=
X-IronPort-AV: E=Sophos;i="5.77,417,1596470400"; 
   d="scan'208";a="260780034"
Received: from mail-bn3nam04lp2057.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.57])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2020 13:22:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/TMXiUVFzTPBik7EK2tl3vE1a47pqLInnl7M+xRquVyE5o3ys3E16xZ2yz89EK94PIt9MKZUnLRRvU35vtUxpXIVgHPgzUGB/+s6dwSDM4rxL1DZ6TO6yU/axXZoUz4cvZbuvfrOvEMPqMOqvSgz2uN7GIbngczQ5Ht/lhpse9kyYs/8keNY6vn/zsoHpP3fNQTckni9LIMvPWPRpMK/SshcDt2nPoV4BlhLAk05yIJaS85O3T1jviI39f5V5pbzoiqMl9lZYGPaPw4yj2BgNd+WNxTCnJHdIJwL0gtvzF3OZZR8qnTGoDVHDCSsFpc601qgzg4o7OtDBy8W7k/tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb6LF5bRK6CKsc1ZpUuS6Tjb3KmxBXBhtGywhbJd/HU=;
 b=kGWJz56VlE9tKQnk3EdlF4nTrliTlVlMYs+ytQBbjoqZH97Oz+Usw1dAZHmSXf0NYwWDrmUUJtqcAO7sRttdlj7Aa/P4uZYs9vZFYxqDejaAOAXljVRsvMog/3ZQM5/RTRq+6w+1YQYgloIBruZ2nijxeyjJrOEjwUzF/jVWta4biAnt0vqE/DIMioGLPbFKbR5MjdX9NL/a5ZBR1+lHR5FDJJhbx3NjrIuoSKPfHxZEmpShMC2QL9X3gQXfiyynrUTCtJwncZ9TjZ974nuwHIRIaLaY2Qn6seMOqN14dmJvYVuU1tdQG4NYBVzyaMVb+dsq6nEWbenPLgR/YJma2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb6LF5bRK6CKsc1ZpUuS6Tjb3KmxBXBhtGywhbJd/HU=;
 b=u4kdvcrqe4dze9YbAM6MH2iTacZcCHRE5Z9elQkK0Hc0H79ssDb59MR6RHXdpQUTqWnkFjG/OI7Y7RM1vbHun5AkCg7zVXa7dVqbvgv9A0qokDPA5yT+KR1kJy/xVuDlcWEw15FV+B8L3eiy0EiWlw+/kXBwwi5lNfVhK2RrzK0=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6454.namprd04.prod.outlook.com (2603:10b6:a03:1e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 26 Oct
 2020 05:22:49 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::709c:ec54:b10b:2d90]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::709c:ec54:b10b:2d90%9]) with mapi id 15.20.3477.029; Mon, 26 Oct 2020
 05:22:49 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Thread-Topic: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Thread-Index: AQHWqDiMF/4I9jj2BU+KaBIJftcln6mjKqFAgAYSn4CAACGX0A==
Date:   Mon, 26 Oct 2020 05:22:49 +0000
Message-ID: <BY5PR04MB67056EDDDA22DEDAFD1972C1FC190@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
 <BY5PR04MB6705D719530D5E188ECB724EFC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
 <5271e570f2e38770da3b23f13e739e41@codeaurora.org>
In-Reply-To: <5271e570f2e38770da3b23f13e739e41@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1359f5bd-4735-4da5-c2ed-08d8796f2e07
x-ms-traffictypediagnostic: BY5PR04MB6454:
x-microsoft-antispam-prvs: <BY5PR04MB64547CF118BD3AB6DB6AD0FFFC190@BY5PR04MB6454.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qWqxfoDtrZ9exjoinDvryXpwf3KFdQeWYC5dEWve+lktC2BwFgkR+TnNVgFkzJV3x4+OzQxlWKyiPST+/mEyH+Fq5GKmRwoFjI6Zr0kiZlOWBT8xppQCL/J6QEXI2LA5vKej6X3EgZDpk33PYEDq+y639CvH8I/1/yUSrpQBE2TGsKHNLZfB5M+EFVrT3dMtbTYPVHD4dE39C0SOB7JIcJxySxozlTEleM4MbPjMvHL9K1Dql56kBWc8Kse+E2saRt8uKM9n28NppAxqt0Sq222IxEwomaFS6Cp7CzwJCf3If/7Boy45mMejFQ7bcLLvl0Vtvz/qwP6qTatXrCD0XA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(9686003)(316002)(55016002)(6916009)(7696005)(53546011)(71200400001)(478600001)(8936002)(86362001)(5660300002)(6506007)(54906003)(33656002)(66476007)(4744005)(66946007)(83380400001)(66556008)(66446008)(4326008)(76116006)(4001150100001)(64756008)(2906002)(186003)(52536014)(8676002)(26005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: QZBc5WzqkTvnMqRC77MI5lXIfIVazz/ne4qxkHeSQfCgC0mlfhjGBu2EJwzi0fkUB7bFLVssMUJc2Gck6NzJSwV1N9BvVNGzwpsKv+ZXcBqOo90ykRp11TIq1TNI0XyxYoPXSGCgmc0H74zPUH7GeHE6pnvyCsYy8z16sy/8131/tbMb1LdSbLjKlq/U5kTUEBOkh98WhzeEBK7/Z1UozSPfo04KrsC7LxSUhqzd4D13KOVMH522uOPETMdSaDlcnP631W2ypsNOhlj30SJaMSTaxdkycBjbW1r6eos/XGm5CP+Neuh0J17iScuu2Vy6BZOczzU59P4rGrzcB+mGcfmOOlRwGDClvFp4Cbv/wtygK9ARkzlTzIiRDLHIxycu0vbLfz3GeKjytxYehr5R7ZBISG7iJhqHqsNMC6xU/7jmC9NdtErsJe6qv4I7BfTuzf/URfcs5RwlBOyoFL0Gh29n3JMtJLUO0AGcXTTxLPIDGWFGhP9CzZIxethnpLDRFASBJuqpNOcGnC1dnog4KD434vwPSHN3pCbWu8MfX+o4Le55et6cUS1ZWXx1pYiOFiQTD3eyDBG5GHa/1qYLlBgcY9Shd2jLmGawmXDBgjAFKDDBUW6AQ87SCv4h5kRzav5n4k2qoZORwjDOXBNJEA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1359f5bd-4735-4da5-c2ed-08d8796f2e07
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 05:22:49.2690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wb4I1FnugmlSGJUacoraYboC5vidFrdRK0LtxrtWTKwji295rNrNmFn8o1Yprnhhfcifadoyi/QF/Xfp/ULnsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6454
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> On 2020-10-22 14:37, Avri Altman wrote:
> >> Since WB feature has been added, WB related sysfs entries can be
> >> accessed
> >> even when an UFS device does not support WB feature. In that case, the
> >> descriptors which are not supported by the UFS device may be wrongly
> >> reported when they are accessed from their corrsponding sysfs entries.
> >> Fix it by adding a sanity check of parameter offset against the actual
> >> decriptor length.s
> > This should be a bug fix IMO, and be dealt with similarly like
> > ufshcd_is_wb_attrs or ufshcd_is_wb_flag.
> > Thanks,
> > Avri
>=20
> Could you please elaborate on ufshcd_is_wb_attrs or ufshcd_is_wb_flag?
> Sorry that I don't quite get it.
Since this change is only protecting illegal access from sysfs entries,
I am suggesting to handle it there, just like ufshcd_is_wb_attrs or ufshcd_=
is_wb_flag
Are doing it for flags and attributes.

Thanks,
Avri
