Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAE5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 06:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9259B64DDA
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 06:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhBQGnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 01:43:50 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:27159 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBQGns (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 01:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613545111; x=1645081111;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MTYIuqGSVucihJOibrx15xDM35RTqAdbV7C+k/NpmJc=;
  b=EWZSBr/RlJRQYk49yaVufePP0R3mK3orObU6OlMsJdJVv+gAGvos5Rb3
   n00yY0iMDjYJAdzAH6rQAoz9M2SVep6nWNkIr3u4+YIp1zy4kNOebawKL
   +1OoIFGtzXC4xODEzO+ddz3ytDtQ2A4SboupCxonh4o80sRuUk0G0bMIj
   kS50yc7yXpm0DF203rL26zEJuRFAJp4JbgAsg0o7+8IMm5Q9FcRhrkXUN
   iRmKTecIZ33PQEUHxXHkM2n4r0tZzsZHyop20q1Z2Ouq2jjO+O3T7oEqb
   yil8nZ5QI0Md1UB1bwLRCxCYXPVUsItPidGN929vlhh+iNuOb3cZkrIgY
   A==;
IronPort-SDR: UHd/Qt87nHo7w2J5CNQpMOj7Zt2ZCIY3+IgvlPMxuEZ7esLe9L7iYJu1gyyOPG3u22ET65MUxq
 admjEMkYa6RMYKD20rimTCVrDcZHXSFLoMnH5bP4ZwgT2E1W6OhvYXo42t3lO8fx75jHs2ebMJ
 dWauka2AEc0rSr6gjmmigK2Sg7mBVIy6fJwCKliCHBbLqNXfcIvGcbH/2mUQTbfVs7QT5p14mz
 F+JVMO4lBDtd8qwlJam/N+9Rg1u9hxH/cVCddR23JFqnJcMiKrwZ8oj3FAgjaLuPBjUM2l7/Hc
 X70=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="264299010"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 14:56:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4wJiOY7qWmsmc4CDRAo3LbqeJ8yPIqIE5gQZBAy6IDj+ZUNCHiL3+C0KwaiuvCV8mMp5DSD/mOoj/Sm1uw2UhJIRV4KmeLtG+PjieLh83JgFudDSlogZTcReyXsAJZFhgVdU32t6mI5gfx/eK//LDUvCtYgdF/h11Y8tCQI83hladO76FLIvXvAGRQTfcilRkm/tg+FRJRsBSXvcH2xcKamx2DQ9QaL/ZVV1/Tu36rHTCoPRoMMSDSJr58ut47u769KVdzyfadaprH/bJYnBR3O5OixwslyPnDIm6dkdsFF4wZhXl374j+67dtnvKHdylspJe8zTb7ZrU6kn51ajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOhF0wW0yIUuYX2VgEw6HZZpKAAR8aFz9Y4oepzvnZI=;
 b=hLWSPd+DYMYr214wnRePosuHdQ304Rf3tGWSwca9YN9t2Euw4BTSax6nAMDYjzJIZs/EiUx764BXTRjKht8nmQzzAz6p9D/5CgKCmB7scjeL4KNrHbxeEzx6FGyREWGJJp35gKFsMIaaPAv3WugVOdQSxJGBGAs635smWgJV7KhyhYP5FbvZSJFTknLDTRj21ImLXmIfMizQL6Nb93GirnsL+TbRpT+mFoWoK9luBVwUm0S6Bs7h7m/+sTt4LDXEU3y4h489sRljljwuHxErCuajkt5gvD4+8GlhJvzItAGdlVsWHr8WkhZZGvE+qb5LYcibZjJRmeVnXzPFck7e/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOhF0wW0yIUuYX2VgEw6HZZpKAAR8aFz9Y4oepzvnZI=;
 b=BpyuyrJ976vAQ9K9FxF93kFCEt5QAuonoyinP48sLOau+bpgVLfbx9w2PdwtasecJQy7hAzhLt2o1XMu8/iPOPSvM6LJ2JlsYDHquLWIcfbh31cExxxNX8x/53qEMLST/mSW/am/c8WtfY/aD/GOrT/215qj6URKXkGj5HVMZCo=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4045.namprd04.prod.outlook.com
 (2603:10b6:805:47::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.34; Wed, 17 Feb
 2021 06:42:37 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 06:42:37 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJuZNMPC4HbBMEOENoattX2qog==
Date:   Wed, 17 Feb 2021 06:42:37 +0000
Message-ID: <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:e815:a55:41ef:1d6d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ea75caf-bcb0-4a4d-e30d-08d8d30f3759
x-ms-traffictypediagnostic: SN6PR04MB4045:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB404540F3997188B9F606C6F29B869@SN6PR04MB4045.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kzdpPOKG2TSDDL0dcEcHMCUuJvmdeJfPsRBhH0gU3OaYnM2vzw2JUQm5G5dZG0xykbvLnYMSfpTAWBaoDLOC2pPmjWtlPANKnjgiI6ussZuKKE+cuaH16AZa/aBtxz0Jfg2JqlPmdT9uhv0RySNFHaHCa7fgfiC1BPbSXl4n6v82OO3TDZFASdOs6PcUBRaOO/3nT3DK9IdYF8FyB6+JJZLHJcNsnht6s0R8uDduTl1eEwqcLKRNE2o1Z+OEFsrfnySPnxr4VyVVsC3YVv3mF6sI8eiwaHezHoTecMloea6bf+jFWghfOf4QTzM1dDqLKl/kMukpIehgjSE5nfS1iYk0vC2mAFUViXCOytjHhEzL/XVO9Z3FZk3izN986dAdvK63XghNi6wh3ew9/7Nr8FtGRqH5hZ1Wa/jju/DQFu8ptVmH953vMQNXDIo9EZQl8vm4LGzgOQubzuFnDNJC96lxCwbwqbQv1cdymdAaVuxuGGP0qtiPrM4kgkjt0Uf5qrKxg746gqg7ZuLjra7R5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(86362001)(53546011)(6506007)(9686003)(83380400001)(55016002)(66946007)(4326008)(478600001)(316002)(186003)(8676002)(66446008)(52536014)(5660300002)(8936002)(33656002)(76116006)(110136005)(91956017)(2906002)(66476007)(64756008)(71200400001)(66556008)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vUwdqVVYqweL+2tw6nH+k8lJ1Nlm1qQdXnsQ0VUu2iWlnkRevyYHP1Z2+GcO?=
 =?us-ascii?Q?Js4jQibjU26EdcXWpsUHZT/KK83vKGP+ySIIm5wowFSnaXqI+UuO7fZBidt2?=
 =?us-ascii?Q?tnwFGnWSsPkb1kNEcGN++/iGCqEETdP6ueoFA7jMJxLtKohErH8Z1bhUSRaV?=
 =?us-ascii?Q?P0wdjEtZNuiI4mNLZsSdDKguQCmJDJ4eUpad38nxBo+7/tMWg2pZ15HqtNTl?=
 =?us-ascii?Q?c+JLr07neziibPWIVr592FAYHA4jfqtNOR2CtCmAQZIMEO4wGnvjQ1R/Vlta?=
 =?us-ascii?Q?bCgmlUrpTwy6pZs/IHZD4sWV2FDvQysSc+OdTy5HuId7fI1+YfHXpOyWaPcF?=
 =?us-ascii?Q?iR760Z5GhJW9pCRDS3DF6OhG4fmPmbhtOAR6rAYxQMkINyGXXqNOjGLgRFQo?=
 =?us-ascii?Q?XFKdoVr2oZZRo7zc550hUxHiCQa+Jss0623B6+vQaXjlNbxM1Wb/M7PIn3fL?=
 =?us-ascii?Q?GEfJA8FXNEgetwvCUewlh10JW5lpmFGGPGDQwQFuHv+JzZy/oj/i3yYdkGKM?=
 =?us-ascii?Q?1W0KxTX8reNRO3QxIvQ8+KmsteOLPfdwMS9ZRp2Y9cx6BQr/H0lGoVsvOq0w?=
 =?us-ascii?Q?RC3fI4PeisZfPNXnoEYYWxLLxfMwKJ9jMfAU/3yDb66y3pLshiWRO1shvZhi?=
 =?us-ascii?Q?wCEmhsAdeEIFPplWZV0aSH2TewI6zczKnkkWTHQz/ZWPCWJbkgOektTxuBaN?=
 =?us-ascii?Q?0R/edZrBhXyH/c67qFcKdsjH+P3N2TTHmx6y8KXKHhzruL+P60tbqsQSEI3j?=
 =?us-ascii?Q?M3o3JKhP83iIVHvBERkr/yr9BXCnaMO2EhyqfKl+UEteQ+EzDWwHzQq/PTdP?=
 =?us-ascii?Q?2CJHfJiVoyfdGXxazip/uIHTygsciR66JkkpFEFiowNQV5oFMPoa+r0Qhzj2?=
 =?us-ascii?Q?/KXzC0QA2l1Kb/AtT5pnN/4cEvbQvbm0qsl/YpNQBi8+Y86ctMAXjqjGQDLF?=
 =?us-ascii?Q?AmhX31ykcDQy2FmujoubCGnatTGllQn4VF/i23SWfbaytdTbYr2MBBc6XKP0?=
 =?us-ascii?Q?blFXzQ3erDcY1pdL4kZ7kJRxy5k40KoVIt2lSDyBbsd6HQXO7KYuDx1KexjM?=
 =?us-ascii?Q?ax6SohgOi6ZHrQB1PQuKYxkUPdPNOcg1xgCm5n+IdVQ8gya3xJZ8QqF2E9eR?=
 =?us-ascii?Q?6qva966CRXGhSZ9TtxwPKfvjA6pxJiCoOe5HZFyupAhidZWUGzfhUAJHkNjX?=
 =?us-ascii?Q?AyXe62xPhq9BPaEOB72kopQU4VgudJ4KJLSFsB+Glp0Mfc2H+y8qEBtO+kvP?=
 =?us-ascii?Q?xEfQAxQqGo9jtN0EdI0LX+KafEkJLDUPWfxlxQ1sfTHPhIXm7aASFo9tv4B+?=
 =?us-ascii?Q?uH1IBJcaF/fyQEx6GuyaneITMjw0HkKB/S/POhp8U6Egs0blwoIQmfcEckIt?=
 =?us-ascii?Q?65BxR6RF2Gg1ZaD3L/zC3RfBM4Ra?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea75caf-bcb0-4a4d-e30d-08d8d30f3759
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 06:42:37.8733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OaxHEqox1mxJFKdU7D3cNpEwQ+EVUOyIJ0Sk5I1UpvISv28B5CjMWISDH2qnw82VJOIUGXI83YWu/edaM3LsNa/lpU8BP7jSiQuo9Et+iF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2021 00:33, Damien Le Moal wrote:=0A=
> On 2021/02/17 4:42, Dan Carpenter wrote:=0A=
>> Hello Johannes Thumshirn,=0A=
>>=0A=
>> The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"=0A=
>> from May 12, 2020, leads to the following static checker warning:=0A=
>>=0A=
>> 	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()=0A=
>> 	error: kvmalloc() only makes sense with GFP_KERNEL=0A=
>>=0A=
>> drivers/scsi/sd_zbc.c=0A=
>>    721          /*=0A=
>>    722           * There is nothing to do for regular disks, including h=
ost-aware disks=0A=
>>    723           * that have partitions.=0A=
>>    724           */=0A=
>>    725          if (!blk_queue_is_zoned(q))=0A=
>>    726                  return 0;=0A=
>>    727  =0A=
>>    728          /*=0A=
>>    729           * Make sure revalidate zones are serialized to ensure e=
xclusive=0A=
>>    730           * updates of the scsi disk data.=0A=
>>    731           */=0A=
>>    732          mutex_lock(&sdkp->rev_mutex);=0A=
>>    733  =0A=
>>    734          if (sdkp->zone_blocks =3D=3D zone_blocks &&=0A=
>>    735              sdkp->nr_zones =3D=3D nr_zones &&=0A=
>>    736              disk->queue->nr_zones =3D=3D nr_zones)=0A=
>>    737                  goto unlock;=0A=
>>    738  =0A=
>>    739          sdkp->zone_blocks =3D zone_blocks;=0A=
>>    740          sdkp->nr_zones =3D nr_zones;=0A=
>>    741          sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32), =
GFP_NOIO);=0A=
>>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^=0A=
>> We're passing GFP_NOIO here so it just defaults to kcalloc() and will=0A=
>> not vmalloc() the memory.=0A=
> =0A=
> Indeed... And the allocation can get a little too big for kmalloc().=0A=
> =0A=
> Johannes, I think we need to move that allocation before the rev_mutex lo=
cking,=0A=
> using a local var for the allocated address, and then using GFP_KERNEL sh=
ould be=0A=
> safe... But not entirely sure. Using kmalloc would be simpler but on larg=
e SMR=0A=
> drives, that allocation will soon need to be 400K or so (i.e. 100,000 zon=
es or=0A=
> even more), too large for kmalloc to succeed reliably.=0A=
> =0A=
=0A=
=0A=
No I don't think so. A mutex isn't a spinlock so we can sleep on the alloca=
tion.=0A=
We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_zones=
() called=0A=
a few line below also does the memalloc_noio_{save,restore}() dance.=0A=
=0A=
Would a kmem_cache for these revalidations help us in any way?=0A=
