Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFF0C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 08:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCC9721872
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 08:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="B0bxcJ3I";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Bb18lXWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfKLIGm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 03:06:42 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:34942 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfKLIGl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 03:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573546001; x=1605082001;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VSo5afmPU34S4aAXz087+bp+hcvHCzMQRvKCjlDBou0=;
  b=B0bxcJ3I5Q2pcw1ZpaXBHCtqHUx35itNsJfrhUHRLo7zdrAsU+6ySGzD
   RDGyf9BoUy0rgTYnS7dPO7xOow1B5i9Y46fVt2zXh/q/Yg9tAaqmLKNHK
   kdM6sdmj4Cn5Vtb8Ya1Ek2AKsmaTAOXzW9AAeBG9ogdetL5GC00JUg5JG
   nH3CpRIQxxVPuMaqLu4A+7UmTGJamu5Y+sguXb6KrLdpLcVZrC98HeyHP
   b9wyfhpvxRX5iF+cj9wiWkJWOdP+kth/GFbFY/ENCWponTVtHnXKrpkMS
   N8zC0K659vEdz60tHg9pTG13Ihw8uURQ2+5ihelctsXlU4166FB2o/zlx
   w==;
IronPort-SDR: 9H7gNA0D1YKCXY3DXKz+i6lpTF3Zn0RdGivm/S5p06qPCPOfolIKOtKQKJLfvaLzfZv0OGCf5h
 E7kofWFfy8DyNVt73KvAeNQrjLdeguWb7Qxv3M2mFyoboMT2fzH2OnmiCwiwvcbMnQGDU/DfFH
 SieYH7sYragQcdYh044Suu7VwRVVTyh7avk91pQImK8rWfB86iCkL43WA0cSfqxYmFjJ8T4GZI
 jVrOh7A3+uOJXALSUhiCDiqS1ABOmIT5Mdr0GiCuFDz8cyCBZwvtXMIGtilxPOio8pW66OiE4+
 zsQ=
X-IronPort-AV: E=Sophos;i="5.68,295,1569254400"; 
   d="scan'208";a="122728846"
Received: from mail-dm3nam03lp2057.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.57])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2019 16:06:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8wlUdyA8F2s47r+wS91R0E1vkfco//Lpg/NgPEKECKlzw4cdwRuPbLljJ57Gl6So/OEC9lx/ySkOQh0LCJFdbGrFs6Yi71Yq+F7aMvGqI63G+3cxQp9En9A23pgM4pIbEXs365u0lcxoQWM1I4JxK/LCQX4q43cu1115Kv/3HtoZJ6cK/WFQhUQUCahDIraFesuzct9nq3jTNp1YsG4OiqTq8xDlD5CuF1aa5E6EjpXORa+JCgtN6I5X1nuCrf3OLIDEDm8tydHnxF67JbNUG4dBAJDCQ2OWLjCxRYNdOye8+DDleV/DWYLtTSRX7uufpJUQnxc7P4vofPtWdjweQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSo5afmPU34S4aAXz087+bp+hcvHCzMQRvKCjlDBou0=;
 b=OHLcc7yaHgpYReWKyCRW/9s46rM09hPtOxiJ1NPN0xpr5nnkTJSqHXcZk2W8Mx+0hQfYHKr8f9cekKVKmxW1kAoWw9v8yOvvBReTGkmPHi/pj6rvRVYTGp5krC7fKRBwjposfliMXia8ubtkqo0+vEQ66ReYVuUVe2nvECTDqXO8lCUINnc2GgjjQwSo1msRQBTRGas13mK/hE9PRDtBwPyTwv10aMl0oYb0WQBtIGMoxx3Rx1GHqBTdbv/61nQzEjI/APv3itpWMN7DlUdMqduJrIUev939scGpVdiw2XEqVdsuZUy25xObHOg0lRn686ywd51Tu8+kdzgulBYcFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSo5afmPU34S4aAXz087+bp+hcvHCzMQRvKCjlDBou0=;
 b=Bb18lXWpfQo9LIIMiYV8rQ4uG/r2YNrXU5g+4T1LLjJ3ND32fHj2z6lchy0955bTnp4g9Kwr580aPXuBRlWVWnzlgrsEbkDCOLfJfobSuhKzm9HBQyB+4Uallzjmni6G1NyEniX2bkJ4IWAjmdHwwUWz56TEadlcZKwU7W2iMwI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6173.namprd04.prod.outlook.com (20.178.246.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Tue, 12 Nov 2019 08:06:37 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 08:06:36 +0000
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
Subject: RE: [PATCH v1 4/5] scsi: ufs: Avoid messing up the compl_time_stamp
 of lrbs
Thread-Topic: [PATCH v1 4/5] scsi: ufs: Avoid messing up the compl_time_stamp
 of lrbs
Thread-Index: AQHVlgzLUq0OZdC0P06R8OSIPy8I1aeHM+Lg
Date:   Tue, 12 Nov 2019 08:06:36 +0000
Message-ID: <MN2PR04MB699191339BA3DB8C560A9E9EFC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-5-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-5-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b06e7feb-1fe7-4f81-759c-08d767473d91
x-ms-traffictypediagnostic: MN2PR04MB6173:
x-microsoft-antispam-prvs: <MN2PR04MB617376A255C2523CE9DD4315FC770@MN2PR04MB6173.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(558084003)(76116006)(110136005)(66476007)(66556008)(99286004)(66446008)(66946007)(4326008)(55016002)(6506007)(54906003)(9686003)(64756008)(316002)(26005)(256004)(186003)(102836004)(5660300002)(52536014)(66066001)(6436002)(71200400001)(71190400001)(478600001)(2501003)(6116002)(6246003)(3846002)(2906002)(25786009)(74316002)(305945005)(7736002)(76176011)(7416002)(14454004)(7696005)(229853002)(33656002)(8936002)(476003)(446003)(11346002)(486006)(8676002)(2201001)(81156014)(81166006)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6173;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZlD5RVfA/pXllHkhg9kdPMpjfz1H5bgWANwmIKe2DkW2deCHhIeqxBNXu+KsSn21ap7L3t7jYu2SnHy8Vz66KzqqCR+gG2qonIkOlIVu0c/0miXFmflmkHPwTHqnKI33U1uQby8gpeNX/sdFpuxi90x3GrqvSN7o9+b+osvOMsjtTa0I5r7PVZW76shFw6BtRMIs/ycTRKbUgQSFekNe8JpL3sE38gbrRia2QQcFogYHtqikOFfZuoQvF1NyaME3a65ZXDhllJtXkeAJKoK523+mOkxtemj3/w4FtbXJ0lu2riCe18lQeKLlRCcH/5XaneKWZFsAVNGvEpmdq0ug/KBPYPk77vPJh0qsDeDztZR4d1drAEbpLihqxTAC9fDY+8OxwpqNfA9AqKSrMCdjfuAMfRdN+0W3FaujweZiX4SGUy6Xv2CN0qazFqhPxF9z
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b06e7feb-1fe7-4f81-759c-08d767473d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 08:06:36.8650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: riC9fAr/8MdDIdxKz8JfRtcr/TXK5DrmjP+QDD4sYpjWNfEjZLHsfd5tkVSC65vP9scM7pRW+UiSigeYOWPyeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> To be on the safe side, do not touch one lrb after clear its slot in the =
lrb_in_use
> bitmap to avoid messing up the next task which would possibly occupy this=
 lrb.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Yeah I guess. But practically this can't really happen.
Acked-by Avri Altman <avri.altman@wdc.com>
