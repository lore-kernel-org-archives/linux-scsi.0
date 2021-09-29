Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5340CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 06:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D946613CD
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 06:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbhI2GEW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 02:04:22 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:35307 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243377AbhI2GEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 02:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632895360; x=1664431360;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Vm8ztroK1VhRVbcFGUshvF7ZJmbN87ujr9VOWWhW3Fs=;
  b=XkGUhTBo3Q8WwvV3rf1rEavMulieBFRimDKRcUS1rCqkabQ0fKNOpODF
   M5BaLC82HKR9kReo1h1UNZp77J5pt7+38e1Mg6JclCokC3H68GGYIZ912
   s0XHbOArflShPwsW3sYkJcSNby0mbel8v1/D8TrH/zfvHh8F7Xdbpbdc9
   DMEXvIQ1/ygQVpebYWkLf0+5bxI7DqRqjAv++N3ErCtrvwCLd+plQ4KF0
   5+sgcAE9WaOOhwn5iFzUnNfeyK6O3WanTwEw58p8gIpmRyHd88o0GVSD3
   rRwSbe3y5bqEFuTA/RyehlijdUyXdE1kF6GUAmE8+2gBEUN+BOn7z5H+s
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,331,1624291200"; 
   d="scan'208";a="181274162"
Received: from mail-mw2nam08lp2174.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.174])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2021 14:02:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCEvCQgDgaEgScPTkKx1gO7ZgEkkj7zZHXftlyaz/12JXuopAhcdYP//eRImJG0ra0Tt9j82aRxmMolc3y3HBnd8qDaX2ZTIt2zFaKC4YpzfHqH0Umrolw3tKHpVnU2En/mzaolCU3kd3Fb2zVbpadyOGR4tiDVbEo/5REI+sT10DZgFXwIZtR9QMo52uFwcyWZTcT6peauOWz9TtyxOG0TLLZ80815hkvyg0uLGWH6ku5wk40Q+CPDn1JhnyUQevRwCvjfndDHeSNmq48/DHeB4iSiukuxGEbaNp8V8ORLdg1zrKpp2m6VRi55gJb3vEUhIuHOv6FXy5qJAqALfsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Vm8ztroK1VhRVbcFGUshvF7ZJmbN87ujr9VOWWhW3Fs=;
 b=VCuoBfhcSHAMqmKpn0OjJG3UOT+9sGV5ZPXZm6sIjifh36xUTPjfbWSRAAqJ5YvC0k6Efjq0nqRbHrm1F2AoCcK7cLFS5MM8vbNv4soQ4o4f1/1/JTeudJIU6azfHd/bmlbjO7+KWuFZUP0HrnYkzK6KJ6wWY7hgZo8LJUwJwW6MoOVtPWImtajsx858C+XU+92Mv2qkEIjOQSpmBRWQCKpBK3rGPWgzHbWh3dUf2ZsR7wn0GpA1E+tdYBM0iSOWji0rzOWJUYO24dzUUx6CfqcPHxa9W2B3nS1WEw6qEIB7wtmSXMie+qMI+G+8FzPNmRu0WHMk3x2Z2Ekjpq7s2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vm8ztroK1VhRVbcFGUshvF7ZJmbN87ujr9VOWWhW3Fs=;
 b=pIkl0vHAvrsb2JL+RPzQ6hzWWQ7NzA35hY3/HXyW49kpWzdSpZ5+Lzr2/Eq8h6nixfyvGeelUBd0GEhfHtRZVtulsOnYfLzxbLF78cL8BQ7SFx+T6RBXcdrlrXfDgF9AnQWFDqg4VtjUhp4HhI9YYpRGFml57LfYNs+cW79ZqOM=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6825.namprd04.prod.outlook.com (2603:10b6:5:1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Wed, 29 Sep 2021 06:02:40 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 06:02:40 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] Fixes for scsi_mode_sense/select()
Thread-Topic: [PATCH v3 0/3] Fixes for scsi_mode_sense/select()
Thread-Index: AQHXlZGy9qkh0/wydUOWDf4qHdWJIg==
Date:   Wed, 29 Sep 2021 06:02:39 +0000
Message-ID: <DM6PR04MB70810890403A87FE0653C300E7A99@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210820070255.682775-1-damien.lemoal@wdc.com>
 <yq1lf3gdns5.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 169f9676-8dac-4643-866a-08d9830ebeac
x-ms-traffictypediagnostic: DM6PR04MB6825:
x-microsoft-antispam-prvs: <DM6PR04MB68256C97CA1E1F9B2C1734D5E7A99@DM6PR04MB6825.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pb16KIrCO/tZibzRLBKG+DMamUfchjQdZwrSMP+7BlgeL/Ge4n+P4GlM+voum/hha1UZef50rg/E1FT9JAkqa4UBpJAOWmCrZE5Ujd6oK9I6h5rvn58yVbr8Ys2iO7vWoAJUkyM19FG8zCem5cDUB0ixyA+U9SapgkMAAzhSoOHaJoQF4oI56X6ozeC/pEbcpwdgrSfxFKRNETuWN9DFJkMC19xq+jy84Cr8FqNAnTh3+JREsTqqHpzY24/hpvOD8175YMiBPOaVY3YmVZkOiIrUi8M6lWgT9JXsEr4v+uITPafqOcvorXiVY4bMAP+ARLkAazahcwNoRQebWNAdjU5kXFNPXETXNuDPgEh2l6q0zbIxnD5O7p46YbnsNUSD8O3A4iu+G8uXQ/MHJaWbwi/ARp8HZa9Dvl3e8TrPDwdo2HzXqUbenS2cgcA6G/cO0e3kD5QWf3aGexsvZVNmAwPeEDCD5GNZq2qah0n3w0diBOQf+9kOTW8p/Cyn7QVR6Q/pQuuKl/E4H/ouShFtx1LO3Fqm+cytykWQLps+SWBpCeDXwlC4aIwkYqi+4XCIZdqf88FdidxF2fukIn5NM7p3b226aszup+RLGCbg0aRo8Fzbwba31Tf88VinUJEExW68FQ4vMh7RlfXNYonj/APWAfR4CpwkXjCgMBJGZXQYuzLnqvTN8b75/yTMwul+Iy0OadkBfyS4Vi26I0VyNzScMkQ5UB9dWI+y3Hb68vuZ8O4FKNcVnNlU2tfSOVrSJnVm+CnMEfhppy/9N3hF8GedV/PcgAQ1mH66Gtvg7bo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(66556008)(8936002)(66476007)(33656002)(2906002)(53546011)(6916009)(966005)(316002)(6506007)(91956017)(76116006)(64756008)(55016002)(9686003)(38070700005)(8676002)(38100700002)(86362001)(66446008)(66946007)(52536014)(508600001)(4326008)(122000001)(83380400001)(186003)(5660300002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jgjo0Zlcwythucvr2iZE3IVQhHyNVd8sjHTWkcxNXpAx21UjymlKUdbiSxQP?=
 =?us-ascii?Q?F770F2tkc8t8IfPLh85ApeSyBPkIK5OikeyKaKr7QlGqiV43FVfwxLCAEgpV?=
 =?us-ascii?Q?WL7r4vFK7bNbGu4JJEKO2kO/S91Awlca1vVJaZgpPnNDRy6DY46xX5ofy0yC?=
 =?us-ascii?Q?G3kD8sGfLVTj3xe6zpU5XfzuxATd1r5zrtYgCzG5wqbhJKlOqOh7HgrrwfmM?=
 =?us-ascii?Q?D3GNCWjmRbFvWnq+BJx4NM/DZ5sKECyCbninYso+FEQpxQrzIP1Uzx7r8kJl?=
 =?us-ascii?Q?cCGtqyw+jJ7Nroo0RJx1j3D2D1Poaz2AC5CODKU5nSD1xD7dGehauvnKRcdd?=
 =?us-ascii?Q?dIS2zOYmJ/Yv/aoyMAZFbhXelkDqgd72kvmeDpuSnzBgXSquZnSld4RjvPGe?=
 =?us-ascii?Q?vp0encS3VcXPggtDiDujEJKanebRQhCK72ivjk8lJ6x5XL31b4fRWz7dLByH?=
 =?us-ascii?Q?a8E3a5YS+8jCWMDmebcbU0s0x4U8vjLPNFxMK0Qt6n9+x+Su+Ndj8zUIR1g7?=
 =?us-ascii?Q?rFWb8DwxieA8cN4YM2FYncaL55WdkZty0vc1S4iSErFGoODS18/YONpxnn2z?=
 =?us-ascii?Q?43z6wsI6rLI/AQlqqHUdLuER8xNCDUIC9I4n6B42OVTFXMihXTdDx1YGAHx0?=
 =?us-ascii?Q?j3uxzEg4fv3yHK2tRuaP5QgWAZS/181gfJIyRBuBNWuftnZKvGQ/2AYWHRdc?=
 =?us-ascii?Q?Q4t3nxwp/dWlsnsbmuxt9Ohf9Aakhed1OBXBUF4FD4dKrycHyCeqW5QPV30m?=
 =?us-ascii?Q?gB7bTX1dd4HZkOGnvL5d4PBO99//q9M56KSIZBtKMwwJz/eOaYIS6uzg8dbX?=
 =?us-ascii?Q?IT+ZTLUSi5GeE74LVY6TX+sehl+KogowzIFabf/OOv5s5qogfENbppkJT/hW?=
 =?us-ascii?Q?Z45Qwrd59oaHS2JnAauFbKIxVt/l+8amFRYj1F6HAcY65yKbdkrlUzO6qv7D?=
 =?us-ascii?Q?eZJG5bFMySXHD8YQzz21ycrlS6IP5BMKLQ01a7S8IccITh87/naqVg+gLddC?=
 =?us-ascii?Q?2kq2rXc5YNaGNeQLetGTHys2TdZe+Bn/dKZ3qIVwlkgDraSyNGybBlEkbepg?=
 =?us-ascii?Q?6+8tlnHX6Uuh9zlAyxTz+SlybtIYAMTHXl2ItoJ24emNQPyIylLIoTBPBT0+?=
 =?us-ascii?Q?yj8SOVue9/iaiLUPJg95bVTDp+96nWqqSIt9vVHOm8MzpwAhz1FtwePYh8+w?=
 =?us-ascii?Q?eh3jrGv5TzSB6v6JRzJ74GkXr6Tw1pPK4y65Znb5VQn1WqGi6vCOI+g8iezQ?=
 =?us-ascii?Q?SijuYAclKT1b/gZ3fo81u5Kn7mjv5H+Ii9IKRPsi9ISm5N9ruWCc5OxNjZj5?=
 =?us-ascii?Q?59fsiuatXRBEx4+f987pOtZGdd4l+pCyuYumiHH02KuMtDcEsftVzd+YTP1Q?=
 =?us-ascii?Q?6peNFN1gbZsrE1qJb1sbPsEJRIht?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169f9676-8dac-4643-866a-08d9830ebeac
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 06:02:39.9671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VFSyo8sGHF7CWwr3q84bNySqeMgYqiksIl3Qqu4593wUMiZsMJUreFp4B0FUkavwMjcnkfpTmXauhbVqBlgUlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6825
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/09/29 13:15, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> The first patch in this series is the formet standalone patch titled=0A=
>> "scsi: fix scsi_mode_sense()". Patch 2 fixes similar buffer length=0A=
>> handling problems found in scsi_mode_select().=0A=
>> Patch 3 fixes the use of scsi_mode_sense() in sd.c to ensure that calls=
=0A=
>> are issued with a sensible buffer size for devices that explicitly=0A=
>> requested the use of MODE SENSE 10 (e.g. SATA drives on AHCI).=0A=
> =0A=
> Applied to 5.16/scsi-staging with some changes. There was some confusion=
=0A=
> between SENSE vs. SELECT in patch #2 in particular.=0A=
> =0A=
> I tried to clean up the dbd situation a while back but it fell by the=0A=
> wayside:=0A=
> =0A=
> https://lore.kernel.org/all/20200325222416.5094-1-martin.petersen@oracle.=
com/=0A=
=0A=
This one looks good to me. Repost it may be ?=0A=
I have more patches coming around mode sense to be able to handle sub-pages=
=0A=
(command duration limits and the new ata feature set subpages of the contro=
l page).=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
