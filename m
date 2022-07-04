Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818EDCCA482
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiGDNW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiGDNWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:22:54 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A897BEB;
        Mon,  4 Jul 2022 06:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940969; x=1688476969;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=htZ5D0+wiGoWkbbp2/Q8abWIJR7RKN3ArpPBHoJFmSNsNOaA7Tut1rU6
   ocWPRdQNG3o54FiPAaVTHrrWdEUgVmde4afsDT/U/O3S5ths4W0ppz3Y1
   ARzEPKycVqVpRQfT43uaAowy7WXWMRf5ZtMg9fcVqGh84Ni2dSFgbHftE
   L1OC++u78XvC8n9GdHsCjCofHqlAr5h8uWYXxic4kzruFav7W1CcJQske
   kgKUwCEWOP0XBniocw5bjAXUAmaNoL/s1hZ299Rak3ztcx5MhEubtDqDR
   NARjs0k3xgmEWjYo3//WoSa1x8kG+D1t1eB8+GteOdZa/3G3792Ti7Ic5
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="203428298"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:22:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y06P1OrcETXEGgeYbtpvXUrgT3xEkeCaIG6FlhHWNpZ2qNjINOwjWxF1RD95lNUNWl3/y9GJ8arl9g1BkiRFZgX97Vzw+YDFNr//zpaOBDAu+KMSYITOV+BhGneHvFsvy4DQxqvm18JD6RtxlRNv2sisnXFY1R1Ap+gIAQ1KsXfNQt1+WEKKJjykRhhVAbzG/9wtMhSlb8QCxF6/O2hRTCwaRHX+/2hA83JrsyM+ArsAWxU2NzShA36100JUK38kw8Y09tfEhpPwsi4LkXBG9QU+eGacFEQIaw0WNm58PzPf7ekn7K4bKu6Dr5rrFqyl4wcyVDe0RifjkY4PXSq9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Kyjc+BEGsXnBFTmk0rWGjq9470aI8CLeuiaxc4nqKzd3bvJuSR3Bge0BTBSzPhTCay/3L3sL87JnBVQaLLuBGLMueGzQ+xZ6reo5vbH9CcLfF6ANvyBdW2t9bpRR4YNzWhWn5E6l/6pCiNXvW37k92RsQYENMraf1bH4ibtqy+okACpQ/KcYzNWGOyeVEXUdjOlKwutgF5v8pUPW9KzxvTzqNj3uBV98OHyC/cu2CoP2XE/cZyyT8NuBcX67FFJpuSX4MmFTwAbVH672CpxJPQOQaHvspDVAwO3rrp5Nn7aLVKXBNiqwiyojR45rnBY9bPKdPuTzOOVp6b/nvflEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=bJ14gAc6ajZaMpALZKUsX+DKSNAR4apUMYi4h/C8YN1+loFH0KbKp5YwOBJYTWcDXOO0a8REYp/tduMKSDbSYHSkHvdS9iCRBjNsaYyJ1Wz65GV6Kb4B1d4NoViHNpWSqV4yqeIpAdJEXZRuiYRSlKC/QcLgB62dH5NGeX2EiL0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:22:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:22:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Thread-Topic: [PATCH 08/17] block: pass a gendisk to blk_queue_set_zoned
Thread-Index: AQHYj6P6BE4xOWjgtkKBHWnYAiVA8g==
Date:   Mon, 4 Jul 2022 13:22:47 +0000
Message-ID: <PH0PR04MB7416DDEC6AF378EAED7674FF9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e4b5580-0332-4997-623f-08da5dc04965
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bQAPOW0nX14l10RrZlMlmDfMmITnlB6RACUBh1aAAMuLrEX6KqbYkIRObulhgMPZkLheWkV2GaF4dwPDShfhAgFzKpEd6goScsYkMwhRRsEGYu9uivOvNxE3ZbqIJ8IPi8iAVnupzHKoPHOUPpfzd7GaYqpCn4XFSEO2nIAx7MAJgv23eA0tBHMvbOLxS/UmGSafuouyAymOIAUIfAAq6rPwQuGHCNiy1Y8hwIi+I0sdm9X4D6L5L+qjmhZCL7VdGUXvXKONoT9Wx5Iwhc2gLBXBK75ZNQkWCu2W4zgUlnulpr/eFAadJTjCIOz2m6flF8aFejao5eGLsU+eApkMf35/laqKnOElUce/kCehp4ClHePEhuA7w+dCIxXMlCE0v7BOyzgM9Smk1wgs8bcH+b0i8CBP3ACOB3OLiuKOFPAlZN5DALPLyOZVCbgiMZ4PJg6K0sv5G8VXtTZOj8fprVmr8yOCCvbuprCwvE2931VORioHD1YXkXNVwjT8f+tO0UcBnNAXqcGS+VFW1wi20iVvsuWghE5mifaA5tB+/pH3VA3wxWnEDW86WoxQ+3DIv03DRKSd7CB19Lb9Djpvug2XLGMKOkqh3Tr58Ls4qm8hCyTfFICUjPPNq2IkDvP51drVEhYYkYjaN6bY0epcPglp5yMKG97SEP65AU6olj6NHGLS1NcisTEnrKz/Bm0AetlOXFWQ3UHIxDa/f5xdf2H0SbEZ2L9RkhnkwAqYuvMuR01DobSm0+Xc4PK/Ld2D3Imk7Gp0soCd7OdqKDqU+QTDo7p2ROKH37nniBEiMRDTKNwUUkpCS+ZQDwpbB5p8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/OHZca6v6kIOAlS1Yrpp0Emtu2jqJKc5E6ubwiDhubQvHzBpt/JLhuAmhzzf?=
 =?us-ascii?Q?7iyttmF0bnCRjGa4fkbv3w5r9RhLTYMuzbcyS2g1aqTbYmoDCoDMWUS0X9tD?=
 =?us-ascii?Q?XDkRB3FZgphPMocGgMCtBWtz0qjePpglPZjmiOoF2O6tRqS4m5uzN2qd2O8J?=
 =?us-ascii?Q?7EBBgDZbZHiUKfXxxrdDFm/4AiFD15Ln4tlpbv83Qk0mfZcfEgvOKmbu2pKP?=
 =?us-ascii?Q?ObYzqAr67cKvBShNDykK9KGnR2p/kQaTxsX6Epbkz6vPmxIegqdgXiGgYFvM?=
 =?us-ascii?Q?Tpp9PLei7Z2PrKK3b7v1AKOtTMdHtPMCyUjThFdLAyK4WBakpGy8YkD+XhI0?=
 =?us-ascii?Q?8wdhzFHYw431fWbwEkwLvOuMoCZLWo6FjitL0J8cYmDrxsOu/5Dtr+BLBW0b?=
 =?us-ascii?Q?bkLQVB87RGD4xa2vrS+VgZ8p2mqQbo0ix4dJBtaXdR94AHLIv3cyqOJoBmnv?=
 =?us-ascii?Q?diWcA1BKYIJtpMi5j8UOaTmocTzl0xnDMsFTk+n5uRQHpSsDorKSzwRqf/zr?=
 =?us-ascii?Q?xP1ScpLX7/1RTSu/MRtYdB0AcO5AS4rSmOM4wVVAsVgucVLh1Gq9t+cYOhlw?=
 =?us-ascii?Q?sKWTsieZCp0NcEFGte4tRGlgnJ1C3epykPKgU0l9LW9IB3uAvYKt5qU6VSo7?=
 =?us-ascii?Q?exM1HJdsMJWcP6+Wdoa9m1Ljx6Q/hZkP3vzD4TDHzk7xId1AgaT3ZlliI2XX?=
 =?us-ascii?Q?PrKtBc/QcoB0odmaGnivXOi/wKKx+5gQJu6nKu5rYLHWV7YnOhLg2ik/naoZ?=
 =?us-ascii?Q?GYJwRqNnG3ZHr3nqk7z/S95w8PT+fJVZw4H7eWK9OgEF2EZLSa8Lb2pLm+kb?=
 =?us-ascii?Q?UhfYZiO72VfPOb+Sf8HrSZKyfwiPKfmE6rp0erabWPKt010EdCYvRc8UPTbS?=
 =?us-ascii?Q?fyk6QVeUeq2sxkr9FjPu3QKOW2XJvs7eOjlGPwSDu7tdbyL4t/SdeR/O3ool?=
 =?us-ascii?Q?jRAEm/+cBGkhaZc6UxGlYuwJXtX4B8bZXSI5prwrHdHk1gL8A1R0Piur15O/?=
 =?us-ascii?Q?M1+9Cid6KYk9pqjffmJkh9L0eGZmM60Q6wXlTyYO9z7bancEKpDbdBQC6Uz9?=
 =?us-ascii?Q?zhKVWzJNu1Cg/9cXYu1XvzLZ47/8IZHhY0UwEIb+gdv4wL/ewFB7nuqt7Fsg?=
 =?us-ascii?Q?XgF3MbXQ/M4bXysVTEhTajUqNStUXa1lB0CcI2oOm/3u2v12QhfIEo9UZY74?=
 =?us-ascii?Q?gqUf3KEs3JkMpCshMltyHacc0QKyd9FBxQ0N0tpuzVWo5mpGdSGqUBSeimiu?=
 =?us-ascii?Q?DLI7Kj/NgJPusR4hfQqp1qIsoXJG/pMWFopzltACERpP/Jy9YYoUTOcj2n03?=
 =?us-ascii?Q?7jAF6ydq1TrbWoT9A2g3iaCo1Ji35CBpnt5lj/KtKsVyqXsqSmOJq+1/+0xV?=
 =?us-ascii?Q?TJgvnUZmzHARJ/yeFKRFS1yFDfR/uWjFBDRVzAi+vcSx93DO0T1s9hXlnp80?=
 =?us-ascii?Q?7APGhZmbWUMpuYzSbhvLY1rqF6dzsWcsvYyXFYF83bAi12EEY2o6Dx27/+hW?=
 =?us-ascii?Q?LiMr9V1AtdJ0WDjoKpdYesLaOX8dRRi9TrdBmA+Gbbfi9LDsA0rUX424qRoe?=
 =?us-ascii?Q?4NVlvGBqxk3G1WDAt3QB6eI4w23gdLJ/rdScWYnvo66emfWOVc8zUDJet77f?=
 =?us-ascii?Q?jObFV5rDn0xqiHQSB9CW9jkQU+Lx/uu7O8ZJl7OOq5FTPisD6Hd3ML8vliD8?=
 =?us-ascii?Q?86i/O1ELmMvR4FaaAPJBhRF+pCI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4b5580-0332-4997-623f-08da5dc04965
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:22:47.2206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MgLqrssDm37nJwNtLOqtvcvuY7TJ1MJGx0CEZFmm4AS8i/jL137Xo/AFj56C7qWDlEH1yGPnFUSPfEioEHIRXyDjhJ0z8l6yM1NZTw7jeNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
