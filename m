Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22FAC18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 00:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96717222C3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 00:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fmmI9nZF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sXTIVhvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgCKAhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:37:37 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63091 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCKAhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 20:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583887057; x=1615423057;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=gcE66yq6hsSDIHw+USgs3k1MPvKQ2SSVbeQWqC4Ztj0=;
  b=fmmI9nZF017OTeIkjq+lBUNsS3IAmjn7CDgju2EfL/EALFV8JJyZnAgw
   TXnWHKIiQLp9uTuxsUsvENAmJjseXvsQ4goPfkUaJP1qTRarlohalX4Sc
   Mj5abAMKVRC1eSvJUHMsMfXVAmQ8NSR53nef2fMsQsDJMGVQPideTdTwv
   Di2edbA74rnw6AQXr5qmeJYVUIgKsKNMXO0PGk2cJVq5M3C+u3wUj2s62
   V1LzOvAAzzy6Oo4TYj9klJ5feJzzpozSBp2Qm/adgzaLD5E6UCj/pa/jG
   U3ctA4OOiXgDk0fUiAzwnK/C1YP1BBJ5XpzMawPoPiDiFXdCAq54sXaWx
   A==;
IronPort-SDR: sPYGwfg+b7mAplSUrLjLsMfQUQH59LGM4spJk2X643GmZgqtt3n3Zks9/GP7uOxu4qqEbRk7Z2
 5cfxp/UxKk1lSwWuLKmhBwCyqtWrHoVE4VKozsCoUVqjsw4eIwTW5hgydFu80MA2i2IvpfOkVC
 ZOL5xpcx6P/UdJghOR9TKdjwxveKopalIPodjAsJZvuBu/joDhHsMqfbDde05Z4njSI/tsPwFo
 ASvrcUVWA8UmmpzLYwfbNM3Dl4/gQwVLhoCfhQAyRmNZ2LY6bzLC9RI0DP2sVBAM0606qOomHL
 2XQ=
X-IronPort-AV: E=Sophos;i="5.70,538,1574092800"; 
   d="scan'208";a="132573707"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 08:37:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBcvzY6kRo1qVy75L/LlAdvHfvrUlIUnqHBBwWz0NH0lx8uSwbUYopQycui+BnBCDlPrJ+kJMoBdHjH+YIPX1gCOXd6kz+sqttswTHisnHfJjD2a5Rf+UTepGNG8BO3w3SYhIVqJNNOsBR9WoRK8U0rCw3G5yiuNCVFUqmSjbPPmDpB0HpxXOPLrTJ1qBBgX2pBL9RN500pDpGz4frcobEO6JoO4HAurwBmLVtwuy/WBasgvqb2gUMi2V69VLS0squSdU9CpVVb8esgkataafwVfwPW+CQyyCABEFSwbjhGCfnCScv+dc8yZKjgUdn+x/DXBvGCMUwXmoKZxjhaq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQE+Izwy6V9i1q09/xRA7thOrz4oAEbcN0rgttsXJU0=;
 b=YZtSc5dXQkfyHPdTLkFtQfkkrTJwMML1rdQAV9xDh5CDEJNoxXkfmomPfV0hXhalzV0TBMi49uLOpQtKiHxKanqWEnrIlzdm4rhVmgwLLhqC02kdoSUc7ZmPZo3ssfDpfI3HjKlvdu/b7/bH+7UikpXzrOZ/yF25QDMnASzsGGccn1uwm0mFnv7m+j0KgpBuqqVGwRv1A3VsyDBmYoJqHYUNhiLHSHvCf8ZHifjBtN3sx9OsOst8QVim9OoeL88SnY5sSBRlmvc6OWYtVrI/R4HBXL8gwXU/G9d8cugzwbADkEZsHivF7M+omW40zucoXc5iD6uiNaFUg1v8tGSVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQE+Izwy6V9i1q09/xRA7thOrz4oAEbcN0rgttsXJU0=;
 b=sXTIVhvEKuFaCT20miUNPNjXferGyqST2V3GWdBJaJLvG2RuKnuMqWTmrk8ZH4aVXKGLP9DNbt6/BOI/FRjs38+HSUyvnreyE+8D4MhEdVbnEFdTRXJ9Qt6u27LePwZdtFervIwMYl8QRLyaE7FwHZxCx88UADnhVRSTX/t40nE=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (2603:10b6:a03:10e::16)
 by BYAPR04MB3864.namprd04.prod.outlook.com (2603:10b6:a02:b1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 11 Mar
 2020 00:37:33 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 00:37:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Thread-Topic: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Thread-Index: AQHV9sDiSduaJQxZBEy62Q8TA85MvQ==
Date:   Wed, 11 Mar 2020 00:37:33 +0000
Message-ID: <BYAPR04MB5816A4B727B954E1C409E451E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310164229.GA15878@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5373fda0-060c-4ce2-690a-08d7c55463bf
x-ms-traffictypediagnostic: BYAPR04MB3864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB3864C90B0B0D7F5E7ADDACE3E7FC0@BYAPR04MB3864.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(199004)(189003)(110136005)(81166006)(52536014)(54906003)(64756008)(8676002)(5660300002)(316002)(66446008)(7696005)(81156014)(71200400001)(6506007)(2906002)(91956017)(4326008)(76116006)(26005)(8936002)(86362001)(66556008)(478600001)(53546011)(66946007)(55016002)(9686003)(33656002)(186003)(66476007)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3864;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLQL7MJN89phuhGDtucecQm/IsAjDaA04EHL8FNb3JjU/hcJhXHe0VzneykIRZzq01IK4Oxm62po8y7lWmCLDPBaSFZKJjYMhHdWsROvW+BjYjZGOUMXqGvRCNdakX0O2Sv5bnFHMt3BR7V6UAOPkTk0fEDQtzHA2AD9u1vs/WpRUZNDjkh3vZbKsRcruL8b6k3PWp/FtzeQ64w2cfElkTbX8r6ZO1dZVUjPS+X7UUuLIdXsd3sl+HkbMlAjxfC5UkpuBFMf95R6atebgIMWq2FA0UdMLH2M/OgyO/xibFgEEDkZp1Jb5ic1EO3MLm0hmggW8zQ61T97IFTN+55vyRYur6RIdefrHEdgoAVGFzMs5s6LOXcOgOofCE3WtanVkxFfoI6FQuUp4whBkzvOXL0+Bt7lsLsAlOKJf2FX7wNGiAdbuaVuH/lDvrs4ZRD0
x-ms-exchange-antispam-messagedata: wh2JVRUhCizhxNqxoyvrCevIrRoQsmb9Kv0F2oeSVOknAv4pICl+qOP82VBAY9oBFl2MfxdwnKjCM5SLsg/JkY7/aYAKJp03h+VvcZ5/KuEC3aOoxZiZU6ViM8IzVm75AKPEIVUz6u0wynnLpNta8Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5373fda0-060c-4ce2-690a-08d7c55463bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 00:37:33.5958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dJMnkraT8la1KPymdhcrN3HojVXVGAEv0gCteB6paT8+RZQgh5GwH0RD2IcSjA5vJXbOKuHN3q3IidjpKOnwaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3864
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/11 1:42, Christoph Hellwig wrote:=0A=
> On Tue, Mar 10, 2020 at 06:46:42PM +0900, Johannes Thumshirn wrote:=0A=
>> For null_blk the emulation is way simpler, as null_blk's zoned block=0A=
>> device emulation support already caches the write pointer position, so w=
e=0A=
>> only need to report the position back to the upper layers. Additional=0A=
>> caching is not needed here.=0A=
>>=0A=
>> Testing has been conducted by translating RWF_APPEND DIOs into=0A=
>> REQ_OP_ZONE_APPEND commands in the block device's direct I/O function an=
d=0A=
>> injecting errors by bypassing the block layer interface and directly=0A=
>> writing to the disc via the SCSI generic interface.=0A=
> =0A=
> We really need a user of this to be useful upstream.  Didn't you plan=0A=
> to look into converting zonefs/iomap to use it?  Without that it is=0A=
> at best a RFC.  Even better would be converting zonefs and the f2fs=0A=
> zoned code so that can get rid of the old per-zone serialization in=0A=
> the I/O scheduler entirely.=0A=
=0A=
I do not think we can get rid of it entirely as it is needed for applicatio=
ns=0A=
using regular writes on raw zoned block devices. But the zone write locking=
 will=0A=
be completely bypassed for zone append writes issued by file systems.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
