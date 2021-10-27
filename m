Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E05C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB9A960E05
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhJ0Aw1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:52:27 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8063 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbhJ0AwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 20:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635295790; x=1666831790;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=g+okCE4afenmTnB6NOPRPRFV9X6LCZqHvmirg5LMrrQ=;
  b=ihLOIiDuaxnZzNV2hRx9defy7ZTB+s9xUa3bmW4qux9qcQRQ4IPvln+N
   oVE+lZ0Q3tXdUGm38fKFlfW5UGa3SlHEAHNgHUzJRk51nwerZXa2syc7p
   0Moh22XeJZx9hijVE9SFWm3a78e5O/bctWRdQEgkpHEd8AINyg8QqC393
   L4U2DsFnuDjUsNPnSeo8cIiY874tFXsxpA5sJBC3SB8iQPOcDv6Sxsa+G
   pXFAq4RUfwqJPwqmCArPeOw21kbijmpQFO6P8jEzBaxaKUEUy76OQ16Mw
   8QHnEgrEfIvYCkOeMFR+tJqit3KalGt/unYk/5fjWmPyEMURA+B3/sTEb
   A==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="184855652"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 08:49:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCr1eSnrK1e0Gcm2tjYYtIbBx7Y58l9PmPkVmMGZRyrUB36xLAKr/MCl83ahjBTO5wG9NyJ4Z9l4SVDH/hLkJbrHH6v+Awd5GGSdoLW1Oynyr3fqu9nOVg1iIUF0QW4PfKuHtVD7pxFdbfRQfeqqXamHh95GXNDT6hS2IjMQhYXLpReWyrG9pr2afrjTykkjmzEUfvBY+mI2SQflXlN1HGevO1VZsHakMi6aE0HPMWCl051bjl4a875szToBQm45yt7wqabOdh6wK5xuUGaIXMXrpLFK/rxelPsED75PxlYkxXhGAxNVaoF3mYkE+Kz3oG4UwCCzPwi5LJsxQR3jsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+okCE4afenmTnB6NOPRPRFV9X6LCZqHvmirg5LMrrQ=;
 b=hCpH9hDhH7l/2PBcSyAqoYONcvs18Q+k8qhiO+bDPqdBgE8cr+06fUWWNtlP3qOYn8Mg8bR2X9DQCmU0rgJPBecMQyZT0d8HNH4MjsJuWFTEzk2ogbz8dBywOy35bKXfnoDa8XMVSs5n0Z3MRbjcyxc6ZqnsI1HHOh/Uw5y1I11e5mBUd9XUbIAHLvcUuCiPphf9DrhrBoBkqVU7/a7LUcoFgar/HubWiFnwIpTvEKrF9uHP11kiVcecX5OTdsqyAS4Yq/op/RZi3+WM3oTINz7IfhNAVKFNgQR4sIJWT4f4L/nIkP7SeCwEHom+YkTOtFaqhqTemdNwSfMr8jcUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+okCE4afenmTnB6NOPRPRFV9X6LCZqHvmirg5LMrrQ=;
 b=zxBPjzzdUIEA/KkAdvp/AqBbAThcjcvt8p4PwLvtluEK9ox78KfdrkONZZftyP+OJ2wyQRPsHSWa+LpMow+ONCcLjjVD2ogc4OGHpyOld21+FmbSlz+rC5wMW3b547ouRxMyKdtuwJcc6X3UQy/H4SEMAmPsmL8zpGn40W5Vvo4=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5882.namprd04.prod.outlook.com (2603:10b6:5:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Wed, 27 Oct
 2021 00:49:20 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:49:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXpSNp1F/8/yl7ZUm+rTQKOyPDvw==
Date:   Wed, 27 Oct 2021 00:49:20 +0000
Message-ID: <DM6PR04MB70810D80EB800CF1CD8F191EE7859@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
 <173fe7e1-7e46-1827-5521-3e2648b85fcd@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a67ffd2a-acd3-4630-184a-08d998e39cd0
x-ms-traffictypediagnostic: DM6PR04MB5882:
x-microsoft-antispam-prvs: <DM6PR04MB58825251BA987DE1F153842DE7859@DM6PR04MB5882.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXbnS9KU74ZHfwz2/Rqhi6n1skC+8nuxclec92K2j6gSW+WW4o8SruwsH3nqIhCI8J0WTDwsotG3HolLsZb3JTC5a8zUGK52/Ow9jMbIKl86FunsA8pgF+yywNhyInoEofX5E6X+LIHcdd4nWoRPi7HD6JEsP1fakjNGSgEs6O4D/SRlcOREKQqrX5fqBcBPM25XsGYQ/9+/4UECyzhUEoOXwziRDwyHnsQcDhFP+ohRbqtON4BJS+9nL8rl/2UuHe368r86/mWE6vMsvBLoThhoCVbEEKxNOK4uf5CvXtWu0fTHtw/PEv5GqMDqdbKEN/V69GuiEnkniui5byDg/zPdjtHUtSTj7Igewclfxdf7VidO+Q91T/9IaMW/XvqRRQgw4AALewzL0eiFsmub/QlecJniBZjA6VX9TBqmnJl5uM53XLeZuukv9uSOKDzlW9YdSkdXpL5UBIV4GH4KexP+BR5ZGFxCRxQy84qCYmbYmAoBDJNR8NTOpvYM9MvxFcSPSCmgAVQ3pQ478oFtepvfiIl184XcJvcEk/IW0LlLeJymyHXiO5CaxBIvKVo0HebkTKkhveqF3u6vTLy/ZPy6+qIRiCYvZQ7wtqFvcZ3K5zWs3VtlM0xly5qf0Oqp74nomeSislFPVuoyBxWvjysSzoLi4Axi/+Qn/rJnx5zLJye8nJ9gFfCGJZC4M9XsjhvQqPOA4PMjp/PZIsTuSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52536014)(53546011)(66946007)(26005)(71200400001)(66446008)(316002)(55016002)(82960400001)(9686003)(2906002)(7696005)(8936002)(91956017)(5660300002)(186003)(64756008)(66556008)(508600001)(38100700002)(8676002)(86362001)(122000001)(83380400001)(33656002)(38070700005)(110136005)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jF0CBUAaad7+ao0RwC4stG6y5qTgUdBwy34D1URDH29WoSmmFzHb23FejWzM?=
 =?us-ascii?Q?wByZ/Sg2FQR9Wb45ciIodzrTCqlZTiaJ/bB67LI+vuran7HpXIoe/a2uoPRJ?=
 =?us-ascii?Q?BAlZsx0LE4n79XeVMN9Dci3Gm659cL5sVym6vjc5fIsrwH3k/i3ZKGoflOYi?=
 =?us-ascii?Q?paJXdWXgR69SS6NtZIN+zoCTjy/brER91/kTJQ1HLcsS3GKa4b3arHM+TK5R?=
 =?us-ascii?Q?tOWGB2WSxOMEIHltQNlje4BWPmxZY4AcgO64FE8mnX9MTsL60HZ7XEy5EBVJ?=
 =?us-ascii?Q?1Scwa3DgfvZSgU+fLQUxxtWCxHT7XiQBcjZGVxp3AcOdQMXMGKaPYdij35B+?=
 =?us-ascii?Q?PcPrXJ1boNc5gUR4PPmlj9utIIc3QZxDJWPPaQdxlhFWQzmbTmChU8krxeU8?=
 =?us-ascii?Q?RUP7dfdpbeDBmgRCttcrlS2l//ymQyv/+eVZgs9kW9cDQoOSWRfmLGv11XCH?=
 =?us-ascii?Q?cLzKwYJ4fTSp/GKqB2vAKGcCm7UnkuIJ1kQDZgSLmaMO/hSSHGa1+8YPH9OL?=
 =?us-ascii?Q?RDFcKpL7lI60e3hGLD8YJ3PpCdOz4Jx8h08ZRFMN9MvbZ7e7cucMjUlPCDS0?=
 =?us-ascii?Q?XB9Xa2lNJd81MXg9/C8/XOSLDSGw35kcbsPGjBRqcoQoVmLjY3YEZF1Gy/sH?=
 =?us-ascii?Q?d4bi5vQW8jdaRTe34czp1/J+t+BUb72tWldjwooaDoZ8bVjNy6AsVCfHKH4s?=
 =?us-ascii?Q?DhsJ6ArCBD0iKXRWiRlElJcyCElszdUzua7SidfAcel20k8Cc+ApN5E5diGH?=
 =?us-ascii?Q?972DGCFjnJNaf5+wYULT21REuUviNkcXLKtRXaEX8X/uVBvhlPTiQlZwz91X?=
 =?us-ascii?Q?bPJqfU0/2NLYsUzCwRxRJowAT+WUTGX5RMGMT4ifwEZhnF9RTOOcHzzzZrai?=
 =?us-ascii?Q?FUBXi8G8s+C0caFcphoZhu9Ekho7zHpTPvcNoRtt91iJV2BZ+Pbt5+vTI8lS?=
 =?us-ascii?Q?hs7X2Tn7TLs/sxNJOF1QtKslFd5PE/O4/oET3zvZqaFveUBw8cYEJMMYYa8K?=
 =?us-ascii?Q?HdIZQ5aKcF+9PUv3XbuaRF7yKehwRU6YZNhyYoX2vWjpaabkeUFk+IzvWy5G?=
 =?us-ascii?Q?7CTA7pcHHXoNSteo3FqDlLHsEhHNOfaA92oWV72uCEh+WAEv0IGFc6AVAlLt?=
 =?us-ascii?Q?ADTQf+1wFTTv9QwdW8qyq4aD/pSxhy4BWrqvaLdrSeofn1hMP6SCXfn+TM5X?=
 =?us-ascii?Q?sveIqZvH3BLx8vfzO84ECCpf0LCvNfWK6wzIL7UEysdZchJDIi3LZnkQr7q3?=
 =?us-ascii?Q?St6KX/FJoo7jFJ8Br78FY6ux1TsFx91te681u+Scm4JneXLyLDfR/V8yO6Mg?=
 =?us-ascii?Q?2QUdV6Hd+C25TK0hbK5JTL+hD0p40MtHDIjfFtwq1GEtkXoswic37YJ1KOc3?=
 =?us-ascii?Q?uKkjgKeA53G2t5ZXsAjwoFq15N9SfsXoJvN9mmpECFKgctqdfrM5SH6ZkF0i?=
 =?us-ascii?Q?eSZ/m2iSwYkD9PtZvE8JWRGWj7PQ1jeKIq/a1ez+uM9vbi9InS0Y+27tdukA?=
 =?us-ascii?Q?8I8gkK8+i0z6eoU7dfYfRyVx9oH9sS3H/6hq3/k1KxRrLYV2rWRiJCgFvT0E?=
 =?us-ascii?Q?2FZN8+d9poXpt26oPKranX4UTC2otCowMvSUsogSdjLZRvtp2jifhVGbOyTB?=
 =?us-ascii?Q?CB+XQhXhr30G18mL7niM54Qs+sZgCxsrLXH9pcrBk3L0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67ffd2a-acd3-4630-184a-08d998e39cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:49:20.3814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 11lKt1u3M+weGRJe/SetucTVqBdaRQFcJ7Wv7ofUANhQJLqZH65I4iNJjI/2gB6sXH1kOwh2VGybFI7EQlk1WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5882
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/27 9:45, Jens Axboe wrote:=0A=
> On 9/8/21 8:35 PM, Damien Le Moal wrote:=0A=
>> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
>> multiple commands in parallel. This capability is exposed to the host=0A=
>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>> Each positioning range describes the contiguous set of LBAs that an=0A=
>> actuator serves.=0A=
>>=0A=
>> This series adds support to the scsi disk driver to retreive this=0A=
>> information and advertize it to user space through sysfs. libata is=0A=
>> also modified to handle ATA drives.=0A=
>>=0A=
>> The first patch adds the block layer plumbing to expose concurrent=0A=
>> sector ranges of the device through sysfs as a sub-directory of the=0A=
>> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
>> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
>> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
>> related to this series).=0A=
>>=0A=
>> This series does not attempt in any way to optimize accesses to=0A=
>> multi-actuator devices (e.g. block IO schedulers or filesystems). This=
=0A=
>> initial support only exposes the independent access ranges information=
=0A=
>> to user space through sysfs.=0A=
> =0A=
> Let's get this queued up for 5.16. I forgot what we agreed upon, can go=
=0A=
> either block or SCSI. We likely have a bunch more block changes this=0A=
> round than usual, and hence a higher risk of conflict, so from that=0A=
> perspective alone I think the block layer would be easier.=0A=
> =0A=
> In any case, Damien, it needs a respin as it doesn't apply against=0A=
> my for-5.16/block at this point.=0A=
=0A=
OK. Thanks. Sending a rebased version very soon (today most likely).=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
