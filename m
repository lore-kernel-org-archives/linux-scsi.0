Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44E1C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 19:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B905861982
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 19:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGETFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 15:05:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:32575 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhGETFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 15:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625511792; x=1657047792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L5LZqlDSbchh1aOabiGhYqyXnV1rJbr+n4gBZDZ12TQ=;
  b=eoLlwekpShxCHpbU4xLMln2y/8AYfYUzXA7yUsSrSWus572i+d20Rz39
   CeTFmtnagnrkdkIq++DLmwWyRzJFOF5TeuSmVqxpTUYo5ageCqQd+2RDt
   iAruIJJHRVbTvkjPmSxpIf2lsPM0ffnFFrZ664yuVN3t3Hl3by/B/u9Px
   HCTJPDhUq3/OjLmgMH9VJhbqQW5J3Nl2ma2l/WlXnnl4MCMQX1Yhd25ri
   sZZjykNcfd3x9IDPmL4utUiKGflhXY+0/mKenNVHDrOHczDq+2GdChtE+
   1Ap3h7rLs4gJ0i40dObGyDexJ7qtr7UTKMU5PENFb+q7zs0TLiUZwOtO3
   Q==;
IronPort-SDR: AehfJRflOQP62yg2S6VD8vX9ZJ0RX8FG6dQ3dWZlO3mAbz6xOCFMX/xeu4WG3O7cPfrq7XzYS2
 GLP58XsygT1PsPnyyzvQHaixI2ryj6OQyXN2ycDC3ho4VwnZyakNlJLFCKWVSfyuz857KcJi95
 nht9BomhSEBKONBZ3fB3i05fckYNy+a4TCJnDPzaZOcAel16U7Vte7zvI3a+KlHW+vk1J105go
 bleJp7fTpvrysCOZl0QRQYm54SXOyJNupWNaDWQcCaoSwGui3jpGsi/sQyRHtL/J5Xsuvhw5q0
 hlg=
X-IronPort-AV: E=Sophos;i="5.83,326,1616428800"; 
   d="scan'208";a="277551335"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2021 03:03:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ra2Lg9N8Nz7n7xmZC3s0EmGGIPLgvKi0WK3zZkbVm5IhIs2C3aJiysKMINjNYK2T3EcT/y5R0ow/Iwk0VEgv0hX0fjg3TlRh62eiam7BmA6koKiV14H4eNiGKFKvgJMBHj5hLjDGUdiNS0/2adF5+spsJpExtj99qg6DdcxGJg79x8VMe5j7CMeaJXkfG1mRSW5zP0g6SO9JM9fqbtAi8Q9W6mQX4yj8sJGPCP+cAFr1ZMSxM8zTg6K5Iu+/0rX4fwGaTQnn9xBfKZy263WmE8b4GNTegoWGQ7EWgMKIvAp9s8UX06umLJj6iZDqtjJrFPn4FyuyNUi8g59j2KZTVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5LZqlDSbchh1aOabiGhYqyXnV1rJbr+n4gBZDZ12TQ=;
 b=JKiil65RBf4oJs8vJKf79PN9lJSWGk6g79JiAll6ZKCkk3WchK0C5/lS0jl1bwQrrE2HruJIctT1AggrptL3HHl+JyHisNNp1EkAHFWUsFFGO6/njTBOPejuxEn1TrZKkG0/e6UU3tagx3u+xYYx8RATpbWWXov55/S34z1mujzi9ChY7hA6yaEL/e7d72op/JHLZgCIi7gLzco++T+X45DaKNs840DXNi5sc8aKrYiRfa9h919kDVqCyfwTKIuCPkstJ1d6p1jfaT4R49MYl6GtstKZ/QCRGpL1b2otH6gsYDVENqGQeffjY4bLfr247tEVkQAN0QZdXhwKmGnWVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5LZqlDSbchh1aOabiGhYqyXnV1rJbr+n4gBZDZ12TQ=;
 b=CDqdQIHHPo5aFclgofDjMaAgO0dpa/kKvoWbC459CcDQdRmqC6IwY7enh+N0EZcJjJQ3gYHL27KfynQ0QbSQ8emh7xb61KVnphzhqeMfaSPdrOaWVm9x9nTihDceCo4YuEHrnYGzHnHTgr/qvkQQ/IAriwkKt1unQyPVva0bvJ0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5626.namprd04.prod.outlook.com (2603:10b6:5:167::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Mon, 5 Jul 2021 19:02:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 19:02:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Thread-Topic: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Thread-Index: AQHXbr3pDv5CHVQeGUGFucgjqmDRHas0wvng
Date:   Mon, 5 Jul 2021 19:02:54 +0000
Message-ID: <DM6PR04MB65753D7D2A60C7EA49D5CEDEFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-11-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-11-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [5.29.60.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ca978a1-5d33-4fcb-4cac-08d93fe77ea1
x-ms-traffictypediagnostic: DM6PR04MB5626:
x-microsoft-antispam-prvs: <DM6PR04MB5626F943340BC1A4A85BEA22FC1C9@DM6PR04MB5626.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zaKeZumCtiRecs5JU8eG1y51eTp5a8l60dghaWjGpInmTI9teoI1WmT1GTJUjk8RHuaKoNa8s7TtASfLVkG3SgS8laJQ9h7nlEfdN7Insm2ZpfknvVTPHFi18w1XpXvuVNqLuRyrRQX4F4bveQH3/xntpXXlaXR9lIzTubQC2+lcFi+LBH/HkQgbfp59sr9HCLAxiWj75Fn5q4zmNsHGPtXNAK70PrRTxTVm/5mUI8bFcYDz9Tm4tVnrRNkuyqBqS84tfQyD5nyONr8L6zUa8iBWPdP9QG7BfAyzzu+gv/k4dB5su4s82FcnvxzQMfMH54FyobAUtmD/uJz8u083lTDsE/7keT80wUNiQtjqUBOhlONZqzmmTLdIFGOx9IIecF3cVmXDvW4ioOxwTOWLcIC1hO6MNDrx1oSi12TaAFjm75Gq3TUfHOx9lEuaF4DhTMzt6W6fe/luiigh329G/M3Y/mfFHkIko8WZ2foPea02F9TUJ24j4/U+CnPvNW4oxTLhM6EK3UY3EFvIC46/hfur8ztQa9MJvV8Qs6jvg1WW5T9bg71D8p6R74yh/X9yHIU3NgFPMDr9tsF3d1cb9h48Ayo+bSm8Ke82Y/4B+SpiKSAhryv+czpSvIcH0Um5sL/WHqUUtWFUppBmrGgww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(54906003)(6506007)(55016002)(110136005)(5660300002)(9686003)(8936002)(7416002)(33656002)(4744005)(86362001)(4326008)(26005)(316002)(8676002)(83380400001)(478600001)(7696005)(122000001)(66556008)(66476007)(66946007)(38100700002)(52536014)(71200400001)(76116006)(2906002)(64756008)(66446008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SecgeOjTvE5heNId2xbtxb4IZlhNnw3YbqSYcEsCUEj03rR6P0tb1DPcLtUs?=
 =?us-ascii?Q?6bIofPqfZP9XlY3+ADJX0j1z3GNGx5aLU7QPHcTo4rdiCo97rc0oRXnOIs74?=
 =?us-ascii?Q?WvncnR36tkSlHqJnIp/QZzhr5AuU7lvSEnoL6haA+lDTGQUh9KxpB3hUtYka?=
 =?us-ascii?Q?huiZoLIyhAU7IWqhcwQJwBUAVMqjCzhfEfHh6y81zLfnQ1t+M5kmJsquHiG8?=
 =?us-ascii?Q?obuz/aZaeCdL1YoCfqHZP/Ous+SQZG/j+uFQ2aurIxQwKi+/UB8dbDn5nLQJ?=
 =?us-ascii?Q?ByNdYIcC4jpEmqHsDKAeSG0K76OuFFBLResyRPosiw0tzY9u5viBJv5cTyVh?=
 =?us-ascii?Q?fZ9zb3i/0i54m78oUtxuE6TFNJguLzoV9XcZFI2+qVa9umAHIX+AYjdvw8cj?=
 =?us-ascii?Q?EH9Dmt4Q/VehsHBH26fao+9HNkGr0P6YTnOirFX1TbYpCqMMdy1CWtz39r6s?=
 =?us-ascii?Q?LlCxwHo26nSC5f5wlfyWWB2cQAeJHRNQ8XzWVmeqEjXAwfhP6n0Ha+Cz0kKp?=
 =?us-ascii?Q?tZEGP6szBCHMpi6KsKdnt7vfUXaun3WJ+WEL5HHD1dfbt8mQnLkiG7xktcRu?=
 =?us-ascii?Q?BWZPDwF67o7wurZCt8Rxw/hEzuCRDZYXqFKWhYf3Q3RDnJYkM8/muFzcnlFE?=
 =?us-ascii?Q?Eqvc+RRgV7FcIGlHSGkXsv+zOZYScUt9NWA1EYJs2aucwErf5hzlXGFe6eEn?=
 =?us-ascii?Q?3g33yxweaxKTLRLTMKaekyM13RbD428AeYHahWUDTGrbQNKUb29LlMIBvLVx?=
 =?us-ascii?Q?mc7zx5CaDtF1PdVjYGHHHbH8N/iSGgVM8Uh8zPrqlPrC2QXIvL8peF6UkZl/?=
 =?us-ascii?Q?4rxokHaaLBbWrlvPe5mVz2QoERRdggNOl0HBhEc2Ub070Hp5MrSul9+foZBJ?=
 =?us-ascii?Q?IMQrPp/0KOvsTct8ugqdk0QCIc7fWGECdH/e/6wjXcmC3n2JgUu2Cf/0F2dz?=
 =?us-ascii?Q?uuv71RSUwiwkZJJoa95GckGNnVTFTKB8DAoEMGseHdaF4snAO9aDpqXGymXF?=
 =?us-ascii?Q?tgbFwnYPNSAsiPdjM3KavsIqkjypw9Pp0ED5MlP14TUFmK6rl7CrOfHM9ga7?=
 =?us-ascii?Q?ni+qX0uNtwHWYOTge9wAmRBPn/roOVle6E/BAb3AbTTF65kGGJNVPkr/CYfr?=
 =?us-ascii?Q?JiE8GhEZbS6hp51yJnV018ic/YWCw/WKvtpzZ+ywc16jpZ4pbFhgkB45nUKK?=
 =?us-ascii?Q?jzGmxaanBZx5+0j1MRC61kdUDe2T1gDBYQSxlWvx/5k+9h21QGskqSEVmAlp?=
 =?us-ascii?Q?5mbib5AhzguOqHS8gbu5REA5QMDVIAR+4F5rcZjcaBmDhi3M/6WCNWEfHoYx?=
 =?us-ascii?Q?+0U=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca978a1-5d33-4fcb-4cac-08d93fe77ea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 19:02:54.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oG1IS2cHbJI6meRN6b5gUjA61akZXU7odKCztlTEHxOqh2W8HPKqcbBd9UphkYWT+Ra1m2SmutSrhpEMQdNSnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5626
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
> shost->can_queue to hba->nutrs. In other words, we know that tag values
> will be in the range [0, hba->nutrs). Hence remove the checks that
> verify that blk_get_request() returns a tag in this range. This check
> was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
> validity").
>=20
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
