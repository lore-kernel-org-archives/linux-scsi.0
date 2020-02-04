Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706A4C3524A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B63D2084E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:17:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VC0Vgy93";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OFCHAaYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBDGRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:17:08 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:5427 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgBDGRI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 01:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580797028; x=1612333028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pgDAyNSlmDvj9H6cg+4mZZuTLwFXAhzzYidXmvHtmC0=;
  b=VC0Vgy93DW3oA56bwiJTG3Vb7AwU3uNp9dgCLOZUTR2UJH7EHnipMTeP
   3WUQQntR2OUJ8MsekNFY4/zwG6Kugj/m2tAQzwzNsxM1FQLJ1pzPS0ayh
   SAoAw5waXp3HqJvz79M0aznpKAkzRnr9J4li5JiI0d7oaqKCgx6Pov+6O
   EpXc1DyQKVRH/0TRff/2kiszSAB2VHFqzLJE5fPUzVN2Yfllmrj97Crgk
   vTSst1v8Gt1RqmBRhlJan/ftr43NWLD4FDj03PM7+fx3MLoYslVd7Xmnw
   MeHgxkpe/l4XCsFFOTX3lsZhBwrNdii0BJxaBki1pmhsWVEF1iik19zUg
   w==;
IronPort-SDR: DaqnXe3F7S8HQYoKSRx+grgpxx/nfHLpRupsURDO9eSGv64CfIJJ8H8LlYOOvmN2h21d6Rko8A
 TtWgRq7oGtfmTymbzp2yzaMTVdzepMccZhFoNujD//IsCrCHNsr47x6pN91FMcB6T8Miw9mbfH
 zSQyTNslUMUrBvZIJVteVxUJwg5mEHcfFptKCdKiyq3PSJYu2Jd10X6Xk9MxmF6V3x0mEGS7Uu
 3IGn4pkoVV0PobTSscKxdBljAiO++0Pzwv1VWH4hfbiJ/e9SyCg/2SyWdltVKcpbKvf0D4V4c2
 9nQ=
X-IronPort-AV: E=Sophos;i="5.70,398,1574092800"; 
   d="scan'208";a="130501188"
Received: from mail-sn1nam02lp2052.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.52])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2020 14:17:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQEF+Iy71Poqwkjxq+fsFmeiBmWXNGoZDLUJhb4dolctjKkKyGdRDaGnYFQD1Dcuwqh8FA0VLsmPWyp4Cc/FIw+BtG96YSVLdXluWWrZRqix8zlBsRQvryYpcYBbCXOE1AocP2/zYPXfu3sCtDW9LO3LZak3Mru1eEVtE3egDeHlr52+FS2YkLHS2XtVpWzL/AQBkuoSwJlQ27d4PLQ0B78w2V/DbcS/I7di9sMSnBG1EDiNpiFd++Mgg4DBozTC3r9oRLcYPKbsb+vUs/E85lMr6pjropEGFC2xtbTc7BJSfCTJg+LNNGlNPexhZxkRjNOHulcrAxLRKpU9tTk64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgDAyNSlmDvj9H6cg+4mZZuTLwFXAhzzYidXmvHtmC0=;
 b=SBISKk3FmIO09hgPUgoI0wqu+7v6auWmITcLf9igr7NwML65wY5x7KGFi4n1r/OI904POiweijZRuJ38oejGZnt9ZeF+PtbpQEofOB395DmXeUmJvdSmxldRcvJJLb4VFD+7afdEA/KQ8ZG1mTTwgf8+hk5BkuWcjExzJ7z3RhhjhojVW4iqDBF9yQ5DitaPDMFkI98pbariNW2bgLeQNepY6QLRcEIYs1RJgG3W1wHo5hVsec2dPYs2gxXR4jTTmVGaPWJbXrB30QTByfASJjsksaU30zb1TItX81/JOqhVQAjmQGuv0fD0JbfRnrocW+SMereZR6fcQE+CDfic4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgDAyNSlmDvj9H6cg+4mZZuTLwFXAhzzYidXmvHtmC0=;
 b=OFCHAaYFXIm4P/drwjwos5wBNbTRwgQTvfDsjH30KQjNwX29l1AWNhL99JLwC2PU8xxE6qdI6TNM9G6tiCgMzouiJKOngLrCIOU/w1ExxiiPV4fB6Ino+nZ6taS90ueQmGribbkS/N6gSBncJogmol1obcfa7DfrUxNQalr+Z+Q=
Received: from BY5PR04MB6980.namprd04.prod.outlook.com (10.186.134.11) by
 BY5PR04MB6487.namprd04.prod.outlook.com (52.135.43.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Tue, 4 Feb 2020 06:17:06 +0000
Received: from BY5PR04MB6980.namprd04.prod.outlook.com
 ([fe80::d068:7819:b5cf:353]) by BY5PR04MB6980.namprd04.prod.outlook.com
 ([fe80::d068:7819:b5cf:353%5]) with mapi id 15.20.2686.028; Tue, 4 Feb 2020
 06:17:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYgyCYLCd8TvkGCDJX1L0irp6gISGeAgAEWVwCAAC+qAIAAZ98AgAANYYCAAIzHgA==
Date:   Tue, 4 Feb 2020 06:17:06 +0000
Message-ID: <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
 <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
In-Reply-To: <20200203214733.GA30898@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.86.228]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8608f67f-5eb2-4795-68de-08d7a939dbce
x-ms-traffictypediagnostic: BY5PR04MB6487:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB6487171BA402F9E27569433EFC030@BY5PR04MB6487.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(6506007)(7696005)(2906002)(66446008)(71200400001)(66476007)(66556008)(64756008)(76116006)(33656002)(8936002)(66946007)(86362001)(186003)(26005)(5660300002)(81166006)(81156014)(52536014)(8676002)(4326008)(9686003)(6916009)(478600001)(54906003)(316002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR04MB6487;H:BY5PR04MB6980.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mZPOMl/R8bQPI9UmFUEFOSvNGvnbL4EkXCPvTEVo7TwJ2kQwURT4SJzmRpvxQgtL0YWrILaBzSOu/wLqK7CNrzjpQsAVmJ+sYxGBzDmJJesL8M1UMOADL/c8BBC5g0oHcWIKdhBmjqwTJupCMizhuC9pYwaziq/WIPLK+Zpn4Lh9Fl8FTQNBjhJkvN78JN7xaFCyvZzvXBsK0rm6R3CfRPnkqbcQwP+f+C4igWhMwgQr76/eigtZ8YJ4AxQ0msqs76Vmuw5y9VohGwYNPShWYtbv2dK/5pYJF+HRQn9eoo02P09VnSwfQXTVnlVPdGlZBPOHne4lKAV+JUjDQYwB4cDybcRVwD+Su2TqieQmxhIIaBaGO3YEfOrKD9lhBvZ2OnighmcVRBPPNNSINgzCjmZ+YDm0VEZHOUCcPdKzVBLXiiMci5FEJ8Ieq0zs2Wha
x-ms-exchange-antispam-messagedata: hh9k2K8VJE3aCHkp6xGLvYXXTkiZ473LmQvpYLmaxQ56QAHVblxxrQn3YhL2QQHwlvlGyWrfrfICWV8l1jcisLDWg8QR+YPUkE9D+24c48RL1fozYo10Q6xsBzSwdda812JOKkJxUj2XkbMnR+cnCw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8608f67f-5eb2-4795-68de-08d7a939dbce
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 06:17:06.0549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WrcAEJeOWcK+8qwyeAv+blbdxZu+VtEEeNmaO+JxjymibTPDcl9i/jXmZZXjrI5pAoCkmTawAztytV0EBnPNPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6487
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> On Mon, Feb 03, 2020 at 09:29:57PM +0000, Avri Altman wrote:
> > > >> Can you add an explanation why this can't be added to the just-
> > > introduced
> > > >> 'drivetemp' driver in the hwmon subsystem, and why it make sense t=
o
> > > have
> > > >> proprietary attributes for temperature and temperature limits ?
> >
> >
> > Guenter hi,
> > Yeah - I see your point. But here is the thing -
> > UFS devices support only a subset of scsi commands.
> > It does not support ATA_16 nor SMART attributes.
> > Moreover, you can't read UFS attributes using any other scsi/ATA/SATA
> > Commands, nor it obey the ATA temperature sensing conventions.
> > So unless you want to totally break the newly born drivetemp -
> > Better to leave ufs devices out of it.
> >
>=20
> drivetemp is written with extensibility in mind. For example, Martin has =
a
> prototype enhancement which supports SCSI drive temperature sensors.
> As long as a device can be identified as ufs device, and as long as there
The ufs device does not identifies as such, e.g. by INQUIRY or other.

> is a means to pass-through commands, adding a new type would be easy.
I am unaware of any such option.
Device management commands are privet to the ufs driver.

Thanks,
Avri

