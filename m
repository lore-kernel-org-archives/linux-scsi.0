Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0BCC432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 01:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB7961357
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 01:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhHWB1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Aug 2021 21:27:47 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23443 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhHWB1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Aug 2021 21:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629682023; x=1661218023;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=dTSoFTEsdBJDieF25HY8oYiHf/2rUrPVx5wauE+PmP8=;
  b=CLifnBHmvuj5SUf0jolV9Hg1x3lIjpRDq0FfH34/jVLVU82dagmWbvAP
   ddU7jbfRMVm2KTzRYUqaNoWhgV1/S2IgKtoHdcykJZsIIRQ6sNmkCZwU3
   CGSnixdLWxVXxeUJ+qIF0atB6L3dXZojSepie1F/rgyRa4HD6ne/62ncX
   I67ndthgSugP4eqtGrEBykh/4P4KHXNw4Xj+I1BFE4TPr1tiiCvBNsmDS
   j3tNbmUseBsVWxw8htgjGLPNTsDaUMSjfY/1tIIpXgna5qT0rhPT2Lmxz
   6oIc3klokQbmnrME8tZwKcFQ4GYmzVlUQnlbd8AG5HnYxn4YHf9bLKOJ2
   A==;
X-IronPort-AV: E=Sophos;i="5.84,343,1620662400"; 
   d="scan'208";a="289657317"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 23 Aug 2021 09:27:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+pf8XZbqLHeXhLrSuCO8tkUOI7ydvkgNibJyEX87dPH7KjcBTifks1Pt9oIbGIP7z9kwcJNPvR03d+K/mmDPc3lOYIbQ18s0bCGXRkIT15r2YP5xOA6xIIJQcaoA8WhAjwvGnNqGs/6A7+ihPyz2jPk9VRPaIUO4j2ezJjrymtDyfSv8NipakEsAzJlBDwfQZ6Nl6l7f+XGsRJohO/ARvkVltQwYZ15AHVTp4nrrc8kR8vcX3o/WAe4Lg2CyiSyBNy1S7BqBsPiqLUgQzQTibe21NyIqO2KWPFFBrEJfi3ctxoQ8eMKASsa6esAq3mf4M35fsHiHADgn9l7sNBNOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTSoFTEsdBJDieF25HY8oYiHf/2rUrPVx5wauE+PmP8=;
 b=SCjh+UCF6pvd8GjcbdoBfsWtgN6/IlzZFN8bHs5zVtDDJBPoNz+Jql3NOR+qXxIaRA4ecMuC4HXvqA+iTMeFOTsIS+rwIG0Qdbs1NH0fDb97dg9sOw5vDbyZH0DHp6HsoGnLjyUGANwPXcsEoItQHPAk8ykg0jety9vmk7jfUpfi8thnD2xu3p4QvF2LdMG03h54nYMZ/5kpvt1VT4NpNVcch1Q5yCOt03z0YXtVf5cdQCiWRTFT0w9k5zgrFoLQo9SSNzhTWjlPcGwnUYeUsPoOv/86iDTaIohi0eH2j7TrIbLP4myRXnvnEM+ZNBwKH4giX/dSwAEt+jCp87KSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTSoFTEsdBJDieF25HY8oYiHf/2rUrPVx5wauE+PmP8=;
 b=iDnHp029hUiiC/uLXeycmPAvPlc+WdjcbPOA3yMYIBQYqNhK8G2Y9OEDzBZN3j8SrD/hsink4f/f6oXIxqqhn6ZdksYc8DQYgBfb+gI/ZVlJOz2Y3opaNdXWTLUmGK2uES/5EV0KdWrXA5Va0nb4Vsvxqs6ZMFLsB8ACp0Z9fds=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB1005.namprd04.prod.outlook.com (2603:10b6:4:3f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 01:27:02 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 01:27:02 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Mon, 23 Aug 2021 01:27:02 +0000
Message-ID: <DM6PR04MB708132DBB6DDF48CCD262537E7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b37f17b-9a0e-4fa7-98fc-08d965d51c18
x-ms-traffictypediagnostic: DM5PR04MB1005:
x-microsoft-antispam-prvs: <DM5PR04MB100510C4DBAF2E32AD578390E7C49@DM5PR04MB1005.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TlJ9t+aYfpF9jvRghrPB9YhcdkA4OFHOr5Vk4vZW2lRwF16z4Tb1u/7dTwCLx0fftdtni+4GWtBpKWZNgN0ANC4iuLb2IZUlfSuOKakrkwXRjxciGHYWc0WjKtDQolThnhbmxrqKf87RgoSfjHwMiWZGNO+hCFLcbJgtz6Ox9ujpZS87tHqIXcBUqmq4BtD8EiljZsShJwoWCovW+Ub8ipKsO2DxYCEA/MPgEbt6mlC6D/8n0kHwcmhWm7byRgNMuC/4NsPV/7jX/zJOfILzrRhnf9qlJjt3UXGX7ejINzVliENDeqgwF5ul3OZNOjHMtQO1/haSTQoQu3moPczdGNDT1NPzBCejlCVFauHnnYelqa9Tr4jxsLMCoLlw9r/UyzZPZ36UwgwxrlgjuTfjYtiQNK5zz6sPbFatbMqVVyU8iXLbjREy0ZJE2MJTrCYk020HChgfCSQkFpGihVzvp1dVCoZO2h9h5tgK7/T65tV8y9IFBAXEUN4WleMDE4CkjxLO9rp8tAS4OYTthXHjikg4IGtImOrrVE2XSTQWsgFI8jVCfI7Bj4rtqhmtgO3tEw4bVJy4bV03z1lDXyCwPxqB4IrW17iBcXYVJWcv/+wrt7+D0EifEeRsDdLSb3aMbBvp7rJPWdSGozVM/UzhFZ/wfBE0YZNAOPAMp4Wko9npwJKvwwoG+gXB2B4ny5fXn+K0oW4iEEHXrcxQ/UFSEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(508600001)(33656002)(5660300002)(83380400001)(55016002)(8676002)(316002)(8936002)(9686003)(6506007)(53546011)(110136005)(52536014)(122000001)(66446008)(64756008)(66556008)(71200400001)(66476007)(66946007)(7696005)(186003)(38070700005)(91956017)(76116006)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PQpWTuJB1uu2tAdWFZEx7njaGs+Y50UAlo9ZLiwDEWrRy3jV+xMC8mHYCyvQ?=
 =?us-ascii?Q?wuTjvaDsKWFRY9cWBCntB9Qoa8AOPvbEPICGXqEi7/G536UstYueK8CytQTm?=
 =?us-ascii?Q?uwve8J5y50clzOHy8uSVJ+4w1xSO65vc012Lxvr4wp0d7J9BdvejLxuKEnYm?=
 =?us-ascii?Q?2YIVrD/H91C8Ae+//X0QLA+mcatrsM3/YbGhR8MDrX44X9pikHnkoGHOiAFg?=
 =?us-ascii?Q?cIOMCZnGIIb9LiyZdLp5QeD7+UmBRT0qPJKFtTPx7QVomVRch7PmbRCKW5SZ?=
 =?us-ascii?Q?oMOkD5KW5GXPTqs1g4rjtizv6Zi+fowLTiOAwwDFxUEk6wInSgd19KWtQEqJ?=
 =?us-ascii?Q?67W9ewkXOE6ePJ8N0FxJWnjtdfz6ynPepShE2hLtAoxncMUc4VKlFPqM3/+8?=
 =?us-ascii?Q?W6tjX+UX3h8pyVirTBgTEp0BieRtKevQbRdNiJ26D7EaaRD5gp5+PaAa40/M?=
 =?us-ascii?Q?0YzEZghm8dGkDmm/HjAvhfOnC4C8o7paZQ6FeDu8U3qljvLrxprmzyimq+B/?=
 =?us-ascii?Q?ACULaXe4Yu8HuTx0bwqR1hQ62QoAGHH2CYULloQF9123sscm4RyoiQtbvSjH?=
 =?us-ascii?Q?Zt1c2aqEz1jNidFrpBehFN8Px5EMYlr5uS1pBLSWcp1o7HTVvcASNccJTvRs?=
 =?us-ascii?Q?v/KG7dM6CJuYoEQ8ZF+3Oi7vw2lGWznBin+jurn5BgdFCRoFK0YcEPOpWf0T?=
 =?us-ascii?Q?TbKNzjaRVgiRwmm4ob3fFwQCRvd5lOVxHyhyz0+kmarHUdhSPXLzg795tu/w?=
 =?us-ascii?Q?exr7h8bE148mTNFqPUvEIXTEAAvRJheW3EIH/g2OLlfxgsYv1/YIodfBlsJ/?=
 =?us-ascii?Q?8J5lU7QX6O4J6K0a/dUA3tOLsyDWXd7gKuHx+J/8olLdslX4LS426EialfDU?=
 =?us-ascii?Q?AIbRdqsDQ2TrTKWT1aEX6nB4HTTbJH9bo71lC5OBYC9RXobdpdERxFwJiNoz?=
 =?us-ascii?Q?zYNHB8CIyLkuDCEINz5V3/MoTY1ozSWs+Fv77S+keIt0czQBsuEaShY3QHJa?=
 =?us-ascii?Q?ZH7HVYnSXYb78cE4xIX9wHQcEnlryPyQKruuKFlrrToTEnvMjtlQBt1vyTvo?=
 =?us-ascii?Q?iShs2VTvgQseupu7JPTtiKykEBwgvB9jxqGmW9RAqhPrkpsFw1iwep7R0glm?=
 =?us-ascii?Q?TsVW6O2qnENzPETBSmhNeWJOw5HZtzRb9xWCyHFoM7SGFUpzCkMJtOdOEkWP?=
 =?us-ascii?Q?7PshaV6aCvGzaeaJvqaw3kbHMCN/ip/OOT1aFIBDEq2CUd03mFCgMDZFV6c3?=
 =?us-ascii?Q?sg5/AR3xGEbB7v3NnKsKJCLcgoCyxfZmutWGF1xtChzGnrIXaJNEwN/d+S9g?=
 =?us-ascii?Q?YfDPcUA5ak9J6H7XxLcJM+mAnMppqZyCiOvTOURdG9jMa20Qs/rMRPaC2Cjn?=
 =?us-ascii?Q?C3tDPs44F/K/V7KAxQKfFhPl35sGBHT5SJp9i7KJe1JjP5MdBQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b37f17b-9a0e-4fa7-98fc-08d965d51c18
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 01:27:02.2294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PP2+okn1msCwr609ME6/cut2KSGjLyl78If3CCO/NbGl76OLf092en8//AXZ27QpE98FHx0TiDFPg/OwnfHNag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/12 16:50, Damien Le Moal wrote:=0A=
> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
> multiple commands in parallel. This capability is exposed to the host=0A=
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=0A=
> Each positioning range describes the contiguous set of LBAs that an=0A=
> actuator serves.=0A=
> =0A=
> This series adds support the scsi disk driver to retreive this=0A=
> information and advertize it to user space through sysfs. libata is also=
=0A=
> modified to handle ATA drives.=0A=
> =0A=
> The first patch adds the block layer plumbing to expose concurrent=0A=
> sector ranges of the device through sysfs as a sub-directory of the=0A=
> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
> related to this series).=0A=
> =0A=
> This series does not attempt in any way to optimize accesses to=0A=
> multi-actuator devices (e.g. block IO scheduler or filesystems). This=0A=
> initial support only exposes the actuators information to user space=0A=
> through sysfs.=0A=
=0A=
Hi Jens,=0A=
=0A=
I do not see this queued in for-5.15/block. Anything holding this series up=
 ?=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
