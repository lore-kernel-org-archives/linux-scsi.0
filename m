Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB1DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2008A60C40
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhA1Fl5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:41:57 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:4605 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhA1Flz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611813477; x=1643349477;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=buP/1dwKqMk5Q294T05qkAHDmCSLig9pbc6zRzn9/Bk=;
  b=cZC5kqmZLNLr8ZN5hEo5OOeRiZVXZoMPKWf3HmmeGffAztqW6tm2mUp4
   D+n7tC60h523HOCvxlSyic3lUNytwiEj/6hmD18zg26l+DQ0PcGC6xcaq
   FzPxqYW918FK/qKwUeaMnSPN2b/q+rkjOdjrm6MKLmImq0eaZZYYS+JjJ
   plysokc8ag3WVNZj7+08hOtO3s2RqoGTv9/grOCIQkAYi4EUaZ/4v21BH
   9L1nRNV4RH4TDdDM1uM+dE8JJFR0g5BLq/rn7+/bNLIcEQ+s1T7gGMdWs
   EP9QmgfqrQRX5uCP37xqJ7MUTfIFLEKpLPAUJ/JlGiK+Ak78/UYPi0i5I
   g==;
IronPort-SDR: yHOvDDghacjiJCpSOYg8Wx5bUsYa5nxhPMRmgYOpNVe+jxCjSCsvmGoUlwK4+N4sL3DyS3oAPT
 YaUK7dfTHHaSFz5/+zgPvzDRswsX+2Y8ikLQjs9aTKC+Rftq40hR2r4kkZWtDe8LxAF4oqPMWp
 7vNSKiWQFpSobw/p99SG/2kx6Q74GRJTam0Wsm5BD1agJr9+gEF5ayDKzfjUdauvpd79qdLJOx
 nNlj7uM9mWTRT39oGE5lCKGBixDi4th5b0Wh57XGIZuSXg9tqrMsb6UAbNHwC0QKZvhRz3RQsh
 lUc=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="262543279"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:56:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLCizb9e7ndue8k7McSejsuNXtccsjMHFh5RD/H/BlTa6SUukmhlai5sjceQs3lMpML4N6vv5JEcJUPwkQ4mCw/uJQegRxDh//7+2mWGwN2FbTnRhQoOII1vTUWDvJjvNYyfl3k4A4QfCz3+xfouhsFL0B6DwdP4IzGQJQDZBW0CTlhLPOKslx7g/upZ3ufg/0/hOrHh+zX8svT/KMb7RZ5DVfR9+rooWQFnXpo4PL6x34RLdJWGHWwCbfufDYixI0XQ/tiJQIRlVg0d8ZjwInT/hZsQpwWSqdPlSWhBPw1Da30HeOtAT4tJpKiItI/y9dg0D1qKW2pkfuJy7gPuOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rawqcw0FVNMn8Of7jdk/5fXbSgOguQFkb6aPY1yZVs=;
 b=KjMzxlH1YUO8rDVStv9sHyre80Cy0pkk+fjCzx/+6ZC9sZZPI/FxPG2iuw/9TpDY5awcYG/yG/27ozc2zOP1o0XKUC5EG92jzknwfETY5VSFS9GYNzrKtDkO4QnnJffKGJsPGQ+q+wdzoMzweST0/1hbUk5PGfHhEDOphcK6eXdR3h188oNWQ6hmTy+QjQg5PZteujE9MMsT997rlwCpW0j9AOSY1vQ3h1j7IwMT+aRxJXv+Vkxi+w7+NPF1mOyBD7/MUU2woS/hMoXi7tUBV/G7azl53Y6Ft4Co/paZlTSkvQuFBD22YGhLq0xsyWWU1Mo3v8zSe0ugXUOuk/BB2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rawqcw0FVNMn8Of7jdk/5fXbSgOguQFkb6aPY1yZVs=;
 b=mCZdz9SOGhB5qWdpvsLtjIT45yDPK/bLc258EtAmJKnqrItDeKvapsxg54b2n/J+nDJc6EW46WbbRVjTTInIFTI7OWcK5HVs88JZHfAfp7Tpdm4U4CSoHP/gb+U+CgijF/mZwpogxI8jukFMnjyHrswQT8Q6q8vQG+ouOIBIeHk=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB7039.namprd04.prod.outlook.com (2603:10b6:208:1ec::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Thu, 28 Jan
 2021 05:40:47 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 05:40:47 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Thread-Topic: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Thread-Index: AQHW9TFKJGYilwYisE6/4O0JGnL8cQ==
Date:   Thu, 28 Jan 2021 05:40:47 +0000
Message-ID: <BL0PR04MB651412874770CEDA5314EEC2E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-9-damien.lemoal@wdc.com>
 <BYAPR04MB49655B5B6075B83CEFE57C6D86BA9@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: efce0e8f-89cc-49bf-adcf-08d8c34f437c
x-ms-traffictypediagnostic: MN2PR04MB7039:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7039A230F626E9995AE15291E7BA9@MN2PR04MB7039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GBtXwm4Bgc6ByeYOwfyKgD7Vp36YIKHAX/gDx/C9WWVuJTiNiEDx49stW3ZZPStLwADEbkqhw9aIgxXhgNTInZmjXV15LkUE1awebU1B3+mk8cBCjLAJzNii2wVW6ngjo2Fh596kwEoGwhny49Z07k6l3VXYsjq77iqipPx8Mw1mx7JyMpqNokyklhpN5C7doDGJ1e/6nCMcajH+Ht/zhOn1m9gL2gbjq7x0ceSvlg0UO7sYHph+ZEfhG8SB3/xdSYoFcX1shasgbDhNr9Aw5ckKS5+3xlZRMF2AW+YB+uWGJ2ahkL0b6t5FMB4JKhfTqQ7dbwla6urgmdt39thDldz52vgDfkPsXAnfB+2E8J2QcV5gOzA79YsKCIS4qccfM0y93o9X9ez4G28OsSUdehCImfIPCr9Y1D32pXv/pgzPCan2IPc5uvR1q04W8TkpGpMixwd/uCeTUz+lqbcx5KGAtOQDiYttHSuz10EaAUrbDMrGBQgNpBcs+k3Im0ULHvY4hiWE1RGcJP6MPBTrEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(52536014)(66446008)(4326008)(86362001)(64756008)(66556008)(66476007)(186003)(8936002)(5660300002)(33656002)(83380400001)(9686003)(7696005)(54906003)(110136005)(71200400001)(55016002)(6506007)(53546011)(2906002)(91956017)(66946007)(76116006)(478600001)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BRx6zZUsOMIlH5kJxOi+0Ohbf+wqZNdREyVjKrcCPvaIsSnPUY770I4rmhA8?=
 =?us-ascii?Q?nKKhHUfgrQlNnSo+/8azW38laPJBAIDUYzsXfzueMl9fbmDCs6zEycr8xlQd?=
 =?us-ascii?Q?hCnKz47zEYCiOUWVoz4fDdE/+S8B/SJ5ymV8il9NJ6T2acWuff2xVvAF146c?=
 =?us-ascii?Q?qONZ2symldR1BotbCyVBm+svYU2k0h1tHo9WmvwlvDBQ8IiCDLEqAYNPooQi?=
 =?us-ascii?Q?7qotwHnFF0l8PrZ4rw9eaciZNHpLe0Ae6xy2IvxTidhitopYCKKACmLKsD8l?=
 =?us-ascii?Q?ESgE2i7thRtSEVzlxo9He8si4QB6EtBwjyqmqdb3sVw0xeAsJSLlRXGmQovR?=
 =?us-ascii?Q?IdkRBQblwIMwgsZxtoa3g4Q2N1c0WkNi/dNIYlQCJA3p/KkOVgcAVELu5ldB?=
 =?us-ascii?Q?iTNvOd20Mi9UZMkSPGoTHRyp/Kjfkl2kp5iaOeCnHLegxPSNd9Zd2w+bKdTR?=
 =?us-ascii?Q?bUqF4XKj9QXXUGafVKtTtvprwsUmegl5dJK7Y7yyLqvsKD4egVJ8QozEDPrF?=
 =?us-ascii?Q?f4OSz/w4nyvpK5D3rjj8NNziK29dKYYjmaSpOkGAvcJErtH0Wo5l3bk9MHTg?=
 =?us-ascii?Q?r5SJI/0KLSgj8rlcxUk3QgfUIqWxlloZwQHslG41JEzuugl71h1Bj0vI64z+?=
 =?us-ascii?Q?OhLLVLCxMakFSPmF34tgjsUX9wzg+7R7yrAuOGsl0dE3ItHVL7xX5Bgb7BT+?=
 =?us-ascii?Q?zi0Io/T5WmjMXW8I6iJK9q1yp2WH+7VYOdUbxGDQ3y+D6ZDcI85bPuO/JHzi?=
 =?us-ascii?Q?kvh3PBeVnBffF/RS7UAIQ8bd5E6Iypegg4AGBgZTw3ozQu7w9ZSF9xoxUAhS?=
 =?us-ascii?Q?rosvaFTnbAlQOARs3Rc+2mRJDyckpGiiTmnTp6wAB1iEL885IL6VeBF+qG5J?=
 =?us-ascii?Q?7jO0DUiQZfFRMxh7NJnhUadHcWdHLgrBGRluX2K/+hd6ENp5qpQiN+q+7ZI9?=
 =?us-ascii?Q?lyrWYD9ZIDtyeFiT5bG2rmIkwTnlSV076gca6rPhwk6o6Y3EhCLq+RkzNW1c?=
 =?us-ascii?Q?ALvvLvhwi5B/bdU6bo1h193Y6PsairEgvZildFAArQJp742POvd/9lmiRhhS?=
 =?us-ascii?Q?ehEGVF5lk3E6Pd7N+Z9cLO8e1FsBBpLEHo1Wtz+fkwYZkgqd73XBsnkWDP3T?=
 =?us-ascii?Q?rFt1qafB6aIGaMzK7IMXcFoufBM2uTqmFA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efce0e8f-89cc-49bf-adcf-08d8c34f437c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 05:40:47.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2fCmpOraLPC0S6XOlqdxPzb+vOiuplvvlbzECN0GSG1t7jego61BJL8QXsX2AAxlwuku4sFpp2IDX1levQZj7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/28 14:38, Chaitanya Kulkarni wrote:=0A=
> On 1/27/21 20:47, Damien Le Moal wrote:=0A=
>> -void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
>> +static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)=0A=
>>  {=0A=
>> +	/* Serialize against revalidate zones */=0A=
>> +	mutex_lock(&sdkp->rev_mutex);=0A=
>> +=0A=
>>  	kvfree(sdkp->zones_wp_offset);=0A=
>>  	sdkp->zones_wp_offset =3D NULL;=0A=
>>  	kfree(sdkp->zone_wp_update_buf);=0A=
>>  	sdkp->zone_wp_update_buf =3D NULL;=0A=
>> +=0A=
>> +	sdkp->nr_zones =3D 0;=0A=
>> +	sdkp->rev_nr_zones =3D 0;=0A=
>> +	sdkp->zone_blocks =3D 0;=0A=
>> +	sdkp->rev_zone_blocks =3D 0;=0A=
>> +=0A=
>> +	mutex_unlock(&sdkp->rev_mutex);=0A=
>> +}=0A=
>> +=0A=
>> +void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
>> +{=0A=
>> +	if (sd_is_zoned(sdkp))=0A=
>> +		sd_zbc_clear_zone_info(sdkp);=0A=
>>  }=0A=
>>  =0A=
> If I'm not wrong there is only one caller for sd_zbc_clear_zone_info().=
=0A=
> Is there any reason why sd_zbc_clear_zone_info() is notopen coded with=0A=
> a meaningful comment in sd_zbc_release_disk() ? e.g. :-=0A=
=0A=
There are 2 call sites: sd_zbc_read_zones() and sd_zbc_release_disk().=0A=
=0A=
> =0A=
> void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
> {=0A=
> 	if (!sd_is_zoned(sdkp))=0A=
> 		return; =0A=
> 	/* Serialize against revalidate zones */=0A=
> 	mutex_lock(&sdkp->rev_mutex);=0A=
> =0A=
>  	kvfree(sdkp->zones_wp_offset);=0A=
>  	sdkp->zones_wp_offset =3D NULL;=0A=
>  	kfree(sdkp->zone_wp_update_buf);=0A=
>  	sdkp->zone_wp_update_buf =3D NULL;=0A=
> =0A=
> 	/* clear zone info */=0A=
> 	sdkp->nr_zones =3D 0;=0A=
> 	sdkp->rev_nr_zones =3D 0;=0A=
> 	sdkp->zone_blocks =3D 0;=0A=
> 	sdkp->rev_zone_blocks =3D 0;=0A=
> =0A=
> 	mutex_unlock(&sdkp->rev_mutex);=0A=
>  }=0A=
> =0A=
> =0A=
> unless I miss something, in either case LGTM.=0A=
> =0A=
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
