Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1114EC18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 00:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C90482253D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 00:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ULp3BoI/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rgKalw/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgCKAeg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:34:36 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:30461 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgCKAef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 20:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583886875; x=1615422875;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SUq7i5d/5oy2PRzEsHMf4yOpZ4u+zz/R29qsapV5arI=;
  b=ULp3BoI/QUW7xFH0q6unWIPo095qpIWBoX9LP31034xrw8NZtN7pmC0K
   p5g8DY03axp6dWaKMkX13uZFxKkleMsWOITKniYetz3yasZyPZvbmKw/b
   8M5hpFuC5zIbrdUHxCTGd743ZKYlbjEMOUjNQ+olVKDtJ68NPQTQzxvjl
   +csO2gVJPOx9/UNbDcyQ5cqS7WIsirBeDjoaXN6aBgg18rmhotQLiKTSv
   bAN9uL9uvTqrLqZlkcPXY0YgOa8CvBdUtlmvwm/Obr4/gpQ3tX10OfmmU
   5M8La2lclCV6DZqqfJvP6aVKzyIlnJBrBw/VTJXUYza1AwnBU8YemsHSK
   A==;
IronPort-SDR: RSdz/VrsWVMVEH49Smbh5ZwzgE8gYbxF9mBpts1Z7vHOisR9Cee+2ZgbeonBTxY5+vzHP09XhM
 ptpA9M4niYMRw0qwL4jmg0hQkikm3/cjiEN4SeaqR5O+7iKpvW3GTCis6B53G7LvCgdEFCk+Sk
 952d9PAsevWHDhF08DSE/01mzKSaEdwwY8c7lAIN9dZGBK/R68fB/RNHwkdXYje2x94cMzW0x4
 lEXfuOimw4Sj7zSxFwYFrOcpggkK34vQs897kpwTHiDVOrr0+PFs3d5fYY+ye9lrR7GCpct3yA
 dnw=
X-IronPort-AV: E=Sophos;i="5.70,538,1574092800"; 
   d="scan'208";a="136480542"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 08:34:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcZqIPuXIimqtwuNvD32P6hP39SyStigq1FgXXTIy0L9VAy9rhjZtyQb1xLA9uKRFeEiFSFiUyIRqAciX3olPsbquZQb9kuIU4Fa/GLo2zK33eDPUNqRiER28JACtv7M7A/DTAVpGiK54BXNwQWHDJaxUxSaztxffkwVTeFVEyxUtos5U1m8FpioZWWs2BguqOLVWFZfDweN5xnkMWn+wCjWMNjJKw3IHVdWPLhkBP6Zp5ihNMDbWhFQHhj46D5NFByMSXUj5PQtP8Bt495pEyk/oR3quS8k2Gzf7QJgaWBeHV1VBIzuppvIjfWunGiWE0W4XffwnjNFXFJOGWs2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUq7i5d/5oy2PRzEsHMf4yOpZ4u+zz/R29qsapV5arI=;
 b=GDqcOExELZ/U4X/02vP9YV00z6jpnO67N+5g8TX7235LLaQVsONmExd2Q6aVREwGyzAlvZ+S+zCMjcYi1vae+SflupCmh0jHK1CLaOmuvzXSSN2dq/JWvWU4VzdGqoACW7pDt2ShyFP/IGbQbSFmrWV3VRVOsrXT6kyhjXnqyaDaEU/cP2b4YVZU6+v+xOCt3nS1Hw+rDyQwKsi2gW79qL96oBw2Fw+FJMppP/bxRUE4tXGNIWtAstwYiU9C8LxyxcpQnUTJoCzIzXqIws3plGIySFe4jIPt/Rd/GDzqSayG01hvd6D4bB0f4b/Va+Vd9oXLFBy+PHVVapEoN/nrOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUq7i5d/5oy2PRzEsHMf4yOpZ4u+zz/R29qsapV5arI=;
 b=rgKalw/sT9WM0OOmRW5S/2Sh9ZeSP5qwexoYAug8MXFsHmqNtfisEkZFtA2z6/cG3QEs8Nl5nx4YKEA6FnP6g4MXw1C67NZqDlziBKHMd9QzGO7B1WxzeV+Fy6nvUpNyTKQNvqUbGHa5DBR2W/JEvoMF1Q1JJ5wNRkXjpgvSnZ4=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (2603:10b6:a03:10e::16)
 by BYAPR04MB4648.namprd04.prod.outlook.com (2603:10b6:a03:59::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 11 Mar
 2020 00:34:33 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 00:34:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/11] block: Introduce zone write pointer offset caching
Thread-Topic: [PATCH 09/11] block: Introduce zone write pointer offset caching
Thread-Index: AQHV9sDra0scjax4s0mPI2b35IGa0A==
Date:   Wed, 11 Mar 2020 00:34:33 +0000
Message-ID: <BYAPR04MB5816F62B4BB0482359F85AD8E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-10-johannes.thumshirn@wdc.com>
 <20200310164615.GG15878@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a7c5f99-6683-4d8b-e611-08d7c553f85d
x-ms-traffictypediagnostic: BYAPR04MB4648:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB464836714AAACD09B44B8984E7FC0@BYAPR04MB4648.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(71200400001)(26005)(52536014)(2906002)(86362001)(9686003)(8936002)(33656002)(66556008)(6636002)(53546011)(66476007)(5660300002)(54906003)(4326008)(66446008)(64756008)(81166006)(81156014)(6506007)(66946007)(478600001)(7696005)(316002)(110136005)(186003)(8676002)(91956017)(76116006)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4648;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kgmYZM9ZD118c/HbK2szQQyMtGHVi5nygq4miB3//o8tDaqupfsrnssdBEGSaX7xooKF0pt57vbUNvKaEnOGVUAhfiQWCResq6+EyCK0RbSvyL05Vs5UrRVSRoKkSuexoXbUuxmvLvU8LUAvGTN5K4jXY1j8fuN6Zqc4djIBKyisD1tr1/inyUuhtj9PVFZsL3/6Sa8nm3pdeb7E9gtLnSPmI6jOHhEHJCvd5eYx76HKW9JpLvwuYktbJ+y0s4vgaN5LKN3pyA/yxwlz5/D7j4bol7stJpWUYLqOBAi0LSEUvXbQEBgSgqubAYWxPpvUWfQZsRnP38EmgzC5iLod2aLt8HZ+CcRRirGMGh5uCwTK94RZJDiq43aO/sBtUSrPZ3OIDd+lxEu/0v6chYeZ8+rEDH+t8rv0Pw0LhUg2i1nCl8tv7k2X2YevT7S2GsOX
x-ms-exchange-antispam-messagedata: saNZFMYvrjuzvrubDqHlD/hxIDS7YiIl8SAy2FRhJ0dILUODK5UHJ1V6cxx3DLVOUchnEyc1ElX9hEZHaT635qfVBRGn/qlXtGO1But+SBV0eT9RgnHDveUjA1QX8QUj23/TSGLp4a8OHih8wVOx+Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7c5f99-6683-4d8b-e611-08d7c553f85d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 00:34:33.4905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hkIGxlTGna/oxu7T5y8YUs6tmNdVdObcQq0BfcQC/iHz3ksAQFEfm359FZjmJ8SwbJGY5chdPOyWmuc2kvj3Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4648
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/11 1:46, Christoph Hellwig wrote:=0A=
> On Tue, Mar 10, 2020 at 06:46:51PM +0900, Johannes Thumshirn wrote:=0A=
>> From: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>=0A=
>> Not all zoned block devices natively support the zone append command.=0A=
>> E.g. SCSI and ATA disks do not define this command. However, it is=0A=
>> fairly straightforward to emulate this command at the LLD level using=0A=
>> regular write commands if a zone write pointer position is known.=0A=
>> Introducing such emulation enables the use of zone append write for all=
=0A=
>> device types, therefore simplifying for instance the implementation of=
=0A=
>> file systems zoned block device support by avoiding the need for=0A=
>> different write pathes depending on the device capabilities.=0A=
> =0A=
> I'd much rather have this in the driver itself than in the block layer.=
=0A=
> Especially as sd will hopefully remain the only users.=0A=
=0A=
Yes, I agree with you here. That would be nicer, but early attempt to do so=
=0A=
failed as we always ended up with potential races on number of zones/wp arr=
ay=0A=
size in the case of a device change/revalidation. Moving the wp array alloc=
ation=0A=
and initialization to blk_revalidate_disk_zones() greatly simplifies the co=
de=0A=
and removes the races as all updates to zone bitmaps, wp array and nr zones=
 are=0A=
done under a queue freeze all together. Moving the wp array only to sd_zbc,=
 even=0A=
using a queue freeze, leads to potential out-of-bounds accesses for the wp =
array.=0A=
=0A=
Another undesirable side effect of moving the wp array initialization to sd=
_zbc=0A=
is that we would need another full drive zone report after=0A=
blk_revalidate_disk_zones() own full report. That is costly. On 20TB SMR di=
sks=0A=
with more than 75000 zones, the added delay is significant. Doing all=0A=
initialization within blk_revalidate_disk_zones() full zone report loop avo=
ids=0A=
that added overhead.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
