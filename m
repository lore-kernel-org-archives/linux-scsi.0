Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932E2C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 10:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGVKTM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 06:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiGVKTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 06:19:07 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3EB7B1CF
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 03:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658485145; x=1690021145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pYD2vOE0Cr4tUylL9KjFQXZhWPNSK8/YzWcf/5zi2Xk=;
  b=bDNPsDMF3qT7dIgMfOyjP1+kO+uE6fTWQL4AzmCQI2g5MxPlARygfCcj
   IMIR4rWZA0Q8wGXP0NCgVYYfTUKd3fCdLhiHICg0OE8YJaDvazAQ6M9Ev
   iDuOTs87Q8Eu0EX7UW6hIuRRSF+XYBBrkQo8b3AzhDeXsW5u7t4/UyW5C
   ZKMdH2wnp22ooIY56BPwOPXaJFHGutfZyhTQeDGqWfxCU70wjJ0qElt7a
   jmsUxS7N0S4Mu/v9O8bvdRBCXT1aK11CsjdfIEJDUqKYiLryaE4OsqDZQ
   9Ejha8oa8mEuO5u8ss7lokiANiOa0zAnzO7hkii1XXX96n/Yyume9rc6T
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654531200"; 
   d="scan'208";a="206637544"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jul 2022 18:19:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USS1ReCWWdQDGmdLqI9iUvZoForVTwYtczDTaLd4tFfTIjXNCCg31EgYiI8vyBSysssZ2kJbhxCaWLltId3exbAONlGrf3Q+P7UQrEXx3EqUzF5OmHxLsYPV/WUBuYh+srYpIUiNHBkVlqguqDM+fIBoDkW09fT9bJvAAEi/gxHRqqMpwNlNJsKDC5Rp6y2h/5PB6gH1NPPV74rv+TejVuOz6pwQH8joT6ecfJlK2spw4MmFlzsaTfaTLvj059I22pO8OWL4ciRoQHIXd56UXFvP0GxFhZVC141qvUe8zsnlpsRsqYF3DnAL2VO+AFV4UwPfigo9Ym7yALR1Sbc7QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYD2vOE0Cr4tUylL9KjFQXZhWPNSK8/YzWcf/5zi2Xk=;
 b=Ao2/PftvrMvKATieJ/RapgnOO/dmMsbJ1yVcGCcaDvc6gDGWPhueHKWTrRlSu85A8uPOUWfnzEI1j6PL4D4J1MEQ78MiMKlQNcVnAHt/z4kP/D8WktU9A6/Yw3fuhFgU1aUmhRAy+lpQa9UCDNgwJZb3gX/pN1YHgZttArTjgyV0sjvg1PhykYgHfaOyDQeIxFwWb2Gkzp9LZKhxr3Xg4KEoIGDtPDRM+IpPBgkAsWrtdZsjguLXWZHjUQH3pj5JyHEHMG4vqSod8uKDfhA3Sn9iN0XngbAPVNORHEWHK5xo/6XoOS+J/ShajKkfaXO2oI3dlgPFMfvX9kvzPTP1xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYD2vOE0Cr4tUylL9KjFQXZhWPNSK8/YzWcf/5zi2Xk=;
 b=m+MFs1jEiBQ5Ei6JJxrPMHg0cmPC2v/IPHiJJKyuUcSUaArx9qZ7Gyh0w7HZmNuFp4oFGsxIGJEOWjbo9jG6AqY8GHOAHDmV2ur/lpssHaS2l+SwKyE8AKQ4ex+rCX3Py1SGLnb0Cy/NxwDvNCb4MEbjfHiRQuMue5QKQgHr3FY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7600.namprd04.prod.outlook.com (2603:10b6:a03:32a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 10:19:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%8]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 10:19:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Increase the maximum data buffer size
Thread-Topic: [PATCH] scsi: ufs: Increase the maximum data buffer size
Thread-Index: AQHYnFqlEXib/0bkm0WwZ/l/9PK7Za2KD59wgAAedrA=
Date:   Fri, 22 Jul 2022 10:19:03 +0000
Message-ID: <DM6PR04MB6575D4AE8FC800F0A7429AA8FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220720170323.1599006-1-bvanassche@acm.org>
 <DM6PR04MB6575FA4433A6743D5940DAB7FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB6575FA4433A6743D5940DAB7FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d97a126c-b25f-41b6-418f-08da6bcb9a47
x-ms-traffictypediagnostic: SJ0PR04MB7600:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rrXiueWywljMhbyab5HDewCvDI3soYbQFP0Zj+kjIE8yXuIYaemnwrIGsoHjIdYgFbrQrD25uz/Foj8en8NrLCXMPX2Ya0l7E1o7ebzVb9j9RPBma6eu7GS437t1/6irgwWgzNA79VpPK+s+Uhj7d+yQXGRvS19hNE33Ccvz6TbSYuR1lCi/WwdzZPrB6rQrBM60EP2vEYjnf8dle9xirwQe167IRaobIwL108Yb1uV0bEf1K84/qYj9nmugD/icX4I6kp4V0et5N2/AnTdWOtKvHcPzWpOlKfXlZhn8yiGKFAQGQCjw115906fQ5UqJ8loIVNIt/Dq2vorB8FSskJk4CQgUKPyETO4odu5D/1Ndg3D2ISHcKHaFujriGGJFxfkJcnQKc+DseGM2uMrpQpoIc/1IgoHDGP8cdGsPenkYAdF+5H40iPHxIcyMxbtEFfc/H4IqXykGd1yjBOB0hzyfG4QaWGhd73aSRBb124rdlRdsl2oG1YK2/Sud16Bisi9DiDi0gEdov0wyQZe2zg2Ywaa5f4Cocu0sRNEIgcNYrkWLERS0xfEl3GzU8vuCO7wQ8uILhZAYib4H9kClp3avTjPOJ+uArtgfH9bEkIB3J4HecUCKsrqDh++ETC9uvdJjS57T30oP3l8xAiRXQ/zclNsZEloHULo7i4kLIkfkqAPIgIY0lU+AOlWOJxUs0djxvAIWxp/gVHReYUlwPPztCmXtcFQaZoKFspXXSTC4H2rEFosjZJeC2Brq/MmmePPmX46dcxmXe22+9mtBNcAdhThy+z37vcSUghCZL6xUKRqKlZJt7d4Wna3/1JWU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(84040400005)(6506007)(83380400001)(4326008)(66476007)(8676002)(64756008)(7696005)(66556008)(76116006)(66946007)(2940100002)(71200400001)(2906002)(54906003)(110136005)(41300700001)(9686003)(26005)(86362001)(33656002)(55016003)(316002)(186003)(4744005)(122000001)(5660300002)(66446008)(8936002)(478600001)(82960400001)(38070700005)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uqTu1L8Q2YrlvlP3syymJGeW03BbO7ise4euNXFZtzzCKfaBWl9VE4XAna0m?=
 =?us-ascii?Q?qUjymm9uowQjooc6StujTJEbQKv34ZTDYDS5wdi7VVJVQFvX7rIxnnsPW20B?=
 =?us-ascii?Q?D1oFl7OsIBB2no8lnJOywe4zx8ykGxBXNZZ6P41FmBXhzTQ3Mc+3HMGNyPcy?=
 =?us-ascii?Q?a7ZH1R2oWOOmm677ka2hLA+V4S0Abn582H/DTDaYtS4xdFEFCZomdDtk6wnL?=
 =?us-ascii?Q?IJ66eyzeLZ9506w6N5GbXd+aXOZRbAvr5inCrwTkfrIa6V/e82NY4wHNIdyp?=
 =?us-ascii?Q?aS01nABkwa+Y55mzcLHvQvJod3KtG3WJF1VZwunm+Md+vINRwL09sqFTH4Op?=
 =?us-ascii?Q?dLcOR57JijH/y9hyx9kmqNxxeuiM2bZiSd/psjLnTPjnJwI+sbijU78lelIN?=
 =?us-ascii?Q?6c9PszBcVxhF7Z4mr7hT5j6aAbWc/FojkzHjalJlMYDgFiEdBECJwROejFva?=
 =?us-ascii?Q?/nfu7ysi6bwIXvbWmAwpsDubScmeyg4ZGNQayXQPC1VdEfL6m/qi6chtGxiX?=
 =?us-ascii?Q?47rLI695c/FlvGWf0gpCLKmkJqArHoh3VlxIqhaRB0BNvqbXdRccwo4Obex+?=
 =?us-ascii?Q?4BxItiseZE1rsjm+PQ465/9Q0Q9gLnOrURPwVmopxGbky0RE3jtPvQ96mVcK?=
 =?us-ascii?Q?hXhdmwCCbiAhMPVXmV5mmP3J1hTpYEob8G2u8dZJVt0iXPRrNp+ATOsVa91R?=
 =?us-ascii?Q?uVUMlRto8Tx/skwnTs+WB7sdnym2I3ALEFFEFCmOYwdw9QPiKlFVPkAoCC5c?=
 =?us-ascii?Q?0bLtUPbQA2ICdQ4kM1ra/FLsmWXhK8p38lRPE760GLwRlMhlQsKPej9bV7uV?=
 =?us-ascii?Q?VeH4+u9oc/EgmuT+S6+uNxJuTLqpZdb64sygxB9xLP/G2GdCeaoW0mCTo9qp?=
 =?us-ascii?Q?AmMutROlNhScZACQtZ+2yvyhy9drlgC67XOQQSfcHGQogcVBa2KOZkB4sNwl?=
 =?us-ascii?Q?gRbzzaNP35dIWqP066t+7AGuWvpPO4ZjOJasTTIcahaxbqoGnXBpe3HUQ5pe?=
 =?us-ascii?Q?Oo5WYXlprNIgd6H6/pYFx2iHSOQPmGk/H5C4+pNhE5CAxXPBaJ5eDNU5TcO1?=
 =?us-ascii?Q?v+aYiuzFdokg2aTqUHJUwJC1azHW3GZOd5zvQoeyRCj9H4O8bEePRLEFJgjk?=
 =?us-ascii?Q?aTWym8kNGX1wZ3Ce4ZgjpQHtIQK0SUxqIIrU9FJZom8MSU4fP6W3SOwWBzzx?=
 =?us-ascii?Q?zHhONT473JYyHC4JxeKHpE9xBQqMLw/6oiBl5mSguG4oY/LP3YzH82gCb6uY?=
 =?us-ascii?Q?FdgePj04ZjDGydt3PdpiMo/XvB75qR33LC3xD58A/NK2DK9mjL9zyOD1z4jz?=
 =?us-ascii?Q?9iyLEuHvhSlQ3oJWOIuLSoZEjzzjU3LWJf8DtP4QbR5LY2TmmP1mi2NLAuT2?=
 =?us-ascii?Q?uutopWgncxGyZ3LhfHhuTz0XagLpIrDtdDjtpJqM1j+MT1M/6+sL0xniplIq?=
 =?us-ascii?Q?c4KfP3I5jEZCYzSmKw0t2qjTaOk73aLlIDuN2ZG7t5SzTpGpZ6n8+WHr8tyu?=
 =?us-ascii?Q?T1Op/OFAYot5ELP5XP6aaix50G4dibZhmV3ft1AiR5vxcDJoepNkUK8wJzkb?=
 =?us-ascii?Q?O2C3Yjs/PMHi1s48jN0H1/MIq9qeJXe7+fVx76MD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d97a126c-b25f-41b6-418f-08da6bcb9a47
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 10:19:03.6303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MGTj1SgjCV7/rvOloJTe5fhNfeKfMQ/qqqLmphAY6oXuERffXMp171wUqhxLp8fAtYcA00ZkZ3niX2pCHf5UjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7600
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> > Measurements have shown that for some UFS devices the maximum
> > sequential
> > I/O throughput is achieved with a transfer size above 512 KiB. Hence
> > increase the maximum size of the data buffer associated with a single
> > request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes =3D 512 KiB
> > into
> > 1 GiB.
> Did you choose 1GB to align with BLK_DEF_MAX_SECTORS?
> If so why not just use it?
> Can you share those performance measurements?
> For some reason, I always thought that SR performance is saturated
> somewhere around 1MB.
1GB seems excessive, so I tried to look it up in the UFS spec.
There can be at most 255 RTTs per command upiu (bDeviceRTTCap is a single b=
yte - in UFS4.0 as well),
Each RTT correspond to a data-out/data-in UPIU which can hold up to 64KB.
So at most 255x64KB, Or did I get it wrong?

> > Note: the maximum data buffer size supported by the UFSHCI specificatio=
n
> > is 65535 * 256 MiB or about 16 TiB.
Can you help me find this limit in UFSHCI?


Thanks,
Avri
