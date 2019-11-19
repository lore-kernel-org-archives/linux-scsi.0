Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889D9C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 12:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47059222AB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 12:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VA689Twe";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LeNzY6E3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfKSMlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 07:41:15 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30469 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSMlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 07:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574167274; x=1605703274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ltkFZ7IB4gyEXSXQTuzdrP3h3zwHJ1DI5B1eDOjvzQ=;
  b=VA689TweWX5Q52Rv0gHvRrftB8k1/bkblAlCh1R2XhOlOG1CgXXQAZLt
   uSmgSzgqOqQvHQjLZ0fUWC9Sia6QzJmAfoeMhZmYBYpujgiJPgMpfRPqg
   fDhv9Hap5jV6v2StSZEkhDkEdvr4miTek0Vg/4wG+LpuMw5I64S+jTKRv
   s9uwptI9Wgs5t6bhAkFWfkS0waUihz1Lug0gsxolARjzDD1N0/KFjY732
   EDwvX5YM2aSAGRadlpm4z4Lute+EZGZN/zCSfp4QPnygsnZdCRq0pZhBR
   f0MOv+h6y7YO0A+MFyCkEWIujy4T8mDsfseyOPSCJuPSURSzHnvi3DYUJ
   w==;
IronPort-SDR: Y2LwGMgFzpzVntXAvUo9T5F0KssE//R/Nw+F0yZ8/gJzB7whpdfC9zUDlxxgFa9jJpxJA71dSM
 59WAsMagDU2vB/qycx03HH4zSd7gMSl1bA93lZBpQNqymI998wL3EmT5a1mujviri1FDfWBCuU
 ie3WTAx5gifKqSmjfTBGTuPp5xVXYpLgzM7FCsSBDv7LE/UqYJ5c2yOyYaZw9Op+8bxwGjcIOd
 oZ3pZdKsMr98MEptitDz5JoZJuIUS+zM/y7KxfuCHPePnOr7F9j8wwxy5n1B/BSW/nYWz36fFG
 AcI=
X-IronPort-AV: E=Sophos;i="5.68,322,1569254400"; 
   d="scan'208";a="123432284"
Received: from mail-bn3nam04lp2053.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.53])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2019 20:41:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2RDbXOE7+DbUU38UyJ5Mb2o+YLJXHOU1oHQ/ErUvrBPODfrl4DNisXv12d/xOW2SSGlKyMYXQKccKjHNgv8FeJYmVHTY8/yGEmZh3EOpKb68qDbA27ywsYYx2GBjnxb9KjdcZRE2O1aMDn2ecUTI2y/GHQOoBKgl5kB/t+qXDvNHLjlsi5HJoaAvgiiNnhagqLeeQiQyyrkGL+77bveX9gL69t8NNJEROvDkcuFsV4/NwzEyGrkpidGWNulYYRQNysfPMKehGkjBNaDw5dzBLQ69rtV03dfXndkRV+eVdl9rb23aaabVcLl58BoAxYsu+s3IMKlZoMfb3TrF/7U6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwQsif7FjnJH1LgaTMkh+q/s4i3w3dLHNILEIrctaLQ=;
 b=Ju48DyY7GZ6jM/+XkPwhB/uNiZ6dNyu729ePnkaaWzJo0XNWPzq8GJj2kVv3maTvnnJr+0xBixqxduP9JJiiOaHbMxMelq91C+Gx94AETd7CW4sL9M/6MwX5ovhSKk4+NqihNZqQlzq76prgmMjFOIg1XzgJebDrVV+hR6euSRo1l23wexi0BwoRgvZRXYeghfPMEqfIrfJQDQUyc08MoEjO9gDBeLEWhvV9IMNyYIg/qEa6MIKAbZcwHIq31nRlNIhoIAW3jzbiQZaPXB4SVcwgohd/DoxhkLapznmX9RNH44WHVZ+QjIFbj/T251sQpjrBEoV87I+neA4PT4FjLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwQsif7FjnJH1LgaTMkh+q/s4i3w3dLHNILEIrctaLQ=;
 b=LeNzY6E3YjLnTwTrjRP2JT8AhGECnoVvrnDUKwRAD/vTjDybt91H4J1NlvHOJQpwoB50OOiOdQRNhMGbEqfpExohRpfOEAl3TiutttDZGg9nb+xIYP5uKT2gCEg3E4QmJ46t/MCPCUo6RNGlpAguY9GErT0leDVUyANXJXFjVnM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5999.namprd04.prod.outlook.com (20.178.246.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Tue, 19 Nov 2019 12:41:10 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 12:41:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     Can Guo <cang@qti.qualcomm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Topic: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Index: AQHVncN0I4QlPQom7kOhpEw7WzhJI6eQgyQggAE7goCAALGY4A==
Date:   Tue, 19 Nov 2019 12:41:10 +0000
Message-ID: <MN2PR04MB699170FFA7B2DD59014374D5FC4C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-3-git-send-email-cang@qti.qualcomm.com>
 <MN2PR04MB6991121D72EA8E6DF7F6258AFC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016e8163937a-d539c90e-6df8-454a-969a-9e33e9ef35b6-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016e8163937a-d539c90e-6df8-454a-969a-9e33e9ef35b6-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d1796c4-a4f9-451b-4bfe-08d76cedc190
x-ms-traffictypediagnostic: MN2PR04MB5999:
x-microsoft-antispam-prvs: <MN2PR04MB59996E2F8DE880676E8B96FAFC4C0@MN2PR04MB5999.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(189003)(199004)(5640700003)(55016002)(3846002)(6116002)(66556008)(66446008)(53546011)(66946007)(14454004)(6246003)(186003)(8936002)(54906003)(14444005)(6436002)(52536014)(25786009)(99286004)(26005)(2351001)(71200400001)(4001150100001)(71190400001)(2906002)(9686003)(7416002)(6916009)(6506007)(2501003)(76116006)(7736002)(74316002)(33656002)(66066001)(446003)(305945005)(66476007)(102836004)(64756008)(15650500001)(476003)(11346002)(486006)(316002)(4326008)(8676002)(86362001)(256004)(229853002)(478600001)(1730700003)(81156014)(76176011)(81166006)(5660300002)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5999;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VbpDYs7nKuk1KJQNeWyKSygjK5XHXBBUYDlDjCWIBC1BSPRTTocsctowcIs3O3f8UgJ6t4nFCBOb/9FyDg9Nwde9XKo/a2mrB7cQSzterF3lZiRZItmfTDjXDCMqg/0GsRKJdy7N0C+0ipAHwKbwbpjoTgL0oNo7SDAcjn13bAYLr/dn86TOQSXeY9nUjQo89yL+P3Vlt2oOLM3PP2cG2OZ7fn3zQ5URxtHoGuPgb0aPRuH4SrXxjzLTWYRBOrws4WD9a0xWoS819KEJ+CITt9rU4eQWSwMdP2ekkym8YKYDIFuoc1jtoVdF1Mt7ZiLxKBTNUSlkhJDT0VRhHDa25yaFcmnAOizC6gQ4zHnog42sdxqvenN/pOkyfDBApmWHj2s+D5B03mPhGFaH7uBD9YZEfQ9L6sO6RLNoi5S2MGh7YILo0cYNFWYNamYFZHWi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1796c4-a4f9-451b-4bfe-08d76cedc190
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 12:41:10.4900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXKThFjCwlFs2WvCbtNKZexeGM2Ayk1z82MYPe3PQlEsxA3wF5dL8vIERar55i8uqAED1OxrEmJvjOJJjDTh8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5999
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2019-11-18 15:15, Avri Altman wrote:
> >>
> >> From: Can Guo <cang@codeaurora.org>
> >>
> >> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the
> >> VCCQ voltage range is 1.14v ~ 1.26v. Update their hard codes
> >> accordingly to make sure they work in a safe range compliant for ver
> >> 1.0/2.0/2.1/3.0 UFS devices.
> > So to keep it safe, we need to use largest range:
> > min_uV =3D min over all spec ranges, and max_uV =3D max over all spec
> > ranges.
> > Meaning leave it as it is if we want to be backward compatible with
> > UFS1.0.
> >
> > Thanks,
> > Avri
> >
>=20
> Hi Avri,
>=20
> Sorry I don't quite follow you here.
> Leaving it as it is means for UFS2.1 devices, when boot up, if we call
> regulator_set_voltage(1.65, 1.95) to setup its VCCQ2,
> regulator_set_voltage() will
> give you 1.65v on VCCQ2 if the voltage level of this regulator is wider, =
say (1.60,
> 1.95).
> Meaning you will finally set 1.65v to VCCQ2. But 1.65v is out of spec for=
 UFS
> v2.1 as it requires min voltage to be 1.7v on VCCQ2. So, the smallest ran=
ge is
> safe.
> Of course, in real board design, the regulator's voltage level is limited=
/designed
> by power team to be in a safe range, say (1.8, 1.92), so that calling
> regulator_set_voltage(1.65, 1.95) still gives you 1.8v. But it does not m=
ean the
> current hard codes are compliant for all UFS devices.
You are correct - the narrowest the range the better - as long as you don't=
 cross the limits of previous spec.
So changing 1.1 -> 1.14  and 1.65 -> 1.7 is fine.
While at it, Vccq max in UFS3.0 is 1.26, why not change 1.3 -> 1.26, like y=
ou indicated in your commit log?

Thanks,
Avri

>=20
> Best Regards,
> Can Guo.
>=20
> >>
> >> Signed-off-by: Can Guo <cang@codeaurora.org>
> >> ---
> >>  drivers/scsi/ufs/ufs.h | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> >> 385bac8..9df4f4d
> >> 100644
> >> --- a/drivers/scsi/ufs/ufs.h
> >> +++ b/drivers/scsi/ufs/ufs.h
> >> @@ -500,9 +500,9 @@ struct ufs_query_res {
> >>  #define UFS_VREG_VCC_MAX_UV       3600000 /* uV */
> >>  #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
> >>  #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
> >> -#define UFS_VREG_VCCQ_MIN_UV      1100000 /* uV */
> >> +#define UFS_VREG_VCCQ_MIN_UV      1140000 /* uV */
> >>  #define UFS_VREG_VCCQ_MAX_UV      1300000 /* uV */
> >> -#define UFS_VREG_VCCQ2_MIN_UV     1650000 /* uV */
> >> +#define UFS_VREG_VCCQ2_MIN_UV     1700000 /* uV */
> >>  #define UFS_VREG_VCCQ2_MAX_UV     1950000 /* uV */
> >>
> >>  /*
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> >> Forum, a Linux Foundation Collaborative Project
