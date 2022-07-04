Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EF2C43334
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbiGDNSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiGDNSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:18:06 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FD3B7C6;
        Mon,  4 Jul 2022 06:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940685; x=1688476685;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Af9sWzx1/4qlu/tO1HUkfDvszOC/n73FFOJEXcl3cIKTXHkH3buSFTOP
   LCVYX1rY5rrubl6pvr3teIkLZmSMl5SfAW2tvNx7k3TWAzZyLHugAaBpU
   m9rd194/4XTW0ICZWFUG+beeXx6cje2qOAZeWIiGjp+0fPUj41V1Rj0fI
   bOc1j0UbREHMyHRt9Mmi8Fsu1HQOvFhWFdmZ/QZOvQQWlpJDpz4NKvfW7
   5PB2e6r95OG4Zul0Jq0xV3AtgwqNtHLk3E6QpQQAYYsukpzi6WK+1l8Md
   Rh1C2qTdeCt66gF4r4hWkmHLeENb1y5hpc7hwvcUaeO2POie2wNXEg1t2
   A==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="205481557"
Received: from mail-bn8nam04lp2048.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.48])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:18:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krCexz9wZXb1T30IG2CzCBhjDkheezNFzQpyxJ6uuZ6SLlpFFDlUYS/n7JrXlpsL64VmEgfEZ04WNBrIQ3PqLYhl4sV6eIme2AOxqbTfZY362X0aPzbTNlNFMEbvLASZiSFk+X5NTmnuTB837sWhxi5ssEwsdEsIuSA1oYHqin4hKCD6uYFAemjGI5ubpN9fiPaOtAeriq5bUKnLYKgYML+HhiAJZkqinyhhmsKM1pCD2ie/W1ckoePt6iusos5FD/QbPEOWVKQnJWYYyPWSXeUbVZYLh6nLSP6nVWfJ9EfNhwbAEx+O+CSH1QW93TuJ3HbVGqJqqL8B0eMATe8R3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=SeRbdr9YJ0kXY0ZE5nTYA3BUvuXNbc7ZM02YfrTDVR+lqXBjtZiH8C0CgXS8aK4psjo8dfTlRSoYoD74voyMpuRt2BneaBlWilykHRqOr0oUELqUocqcsL+6DBge7slMXWBalZ3YP3Nk5T8tTcYx+z/TJJaf37+TVq+dIYiDmh0GHtiguRzbxBhVqPqilW0v2ZFOSHNs/3KAJ3dNCSvmtIFafmW4DnFnH41k7WJFdI8ZfAeaQJmI83S3Isc6C+a8r/oNPBo4BTaLLKsbQb0b5aqSOMCg8HrKRNJanGUV0UiAJadtTw0CjkLcb7wfu5WvF4meQMkpS6ujFfeQy1ff0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=HO1AOwDoR+QfnJfzJ6KSk6h51HLMosfjQm+cUD6dlAQLLCOd/wTdpu0O/31K+z57FXfFI+hLZSau2A6I8OJmTKRCb/qi72/WArOeOzteXeraLv9kvkAxlbLGeS8XD8SOVzKMbj8uPOBdAA52+3g7n/rmX/RmBbVcxHsMzWr8Erk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:18:02 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:18:02 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 06/17] nvmet: use blkdev_zone_mgmt_all
Thread-Topic: [PATCH 06/17] nvmet: use blkdev_zone_mgmt_all
Thread-Index: AQHYj6QA8GLMDjcpPkii60hZ043CyA==
Date:   Mon, 4 Jul 2022 13:18:02 +0000
Message-ID: <PH0PR04MB74163E993F0753B20AE554279BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1effcd6b-cbac-4607-39a4-08da5dbf9fd7
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5L+tqJL7X02V1tbb50pBRx4sqj5cOWWFf96ftum9jMmeGC62qaq2Hq5z1iWVHB/TOw+xXwcxPxqNkWCeW9xaM+tbaAU9VMbhTYtBgqsj1Ec3WEQdRuDKDtqQHh9/0pfj39XZ2UoVLLUsMdjXHaU8f2gp+e0ZJ9lsGx28sKaRyBVrS8D0DoKH7bZEb0vWDwCr4Wn5vHZt56d8P/ESpjVNEMiOGST0P92OyWYL8GnisZsLoreGkepMRq+sn8osKRYSF9Dk+b2wZ99HUxzS/hfQYV85An3flPewwlqH0m6arIjOxOfOmWay7XRC65tDYp2BBmwLNdABbsfCx/0k8UES7H3phZiOainSFMEAImEvFLM6LPzWGImE101wB8aywq0wg9zTzD0qmKlxq3ZbdnF7RJep+aCMklskVug5bWLzehgOVtUZiO87C9+RiYQIocnIHqWwBzwKr0YGr/+z9ywhJI0pRoTmM8MykCn2yFZEjKuQJgKJYtXas8PUpj55KcoDD08fueq2alQWWCIpIsVQdhereFYXXr/QkGa/vFXoN7UecX8USHuoGnOQv4N9FPCkN+YX1gemBjJcF4Sa+/o5KYzYhB+L74tDN2oCaToEir+fMnTCJVr1STINH6xoOU1KbLcI76DBPlbpi6qfaSLZoIHaSa6PbNeB5WeWlKJ8aRyCrGSEMjd4qOV/VyrVVBmp8A7c40P/ejePE/2cnIfnnfewzQgQAC0KSV6HY2q+EpU+pTFS3eCKL6Oyw+qY/nsLv/HKqfSrGe5oTUcZ1Z18XESZYH6GjwSftqm7pDT4u9bWW8aaiJrlBt6ibKxe24uJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(71200400001)(478600001)(91956017)(86362001)(76116006)(558084003)(186003)(33656002)(4270600006)(4326008)(110136005)(38100700002)(7696005)(38070700005)(66946007)(9686003)(41300700001)(316002)(54906003)(66556008)(8676002)(66476007)(64756008)(66446008)(6506007)(52536014)(82960400001)(55016003)(19618925003)(2906002)(8936002)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ByzlmdOu0V2jz1yL2h9zScaeEIRIXCdgCDtWUBKSxY+dvBkzOydww0DKvnAn?=
 =?us-ascii?Q?5NWNiBashwwdOOYT65hSjK5rK4qihKU6aoZu1y8Wj77zxLHzM7rFzX0dDp/j?=
 =?us-ascii?Q?8Rc39FbnbRirHSzuJPQ75dUfLDzeyZwqKdrUiUaKg4rAV6xreOXVmUImXlpm?=
 =?us-ascii?Q?W3bA+flo1AeMPE1yO5+xaetaHImCKToe1vOf3NyC87EpfvPQo0jXI+FA4orV?=
 =?us-ascii?Q?XhUHDgYwR2oPQ5SGPQMFDzxXvp9xhQ+DoyiDPMZElmXuMn2je+LRA8JDPepi?=
 =?us-ascii?Q?KAKfER4ykeVaYXjOYnwb4fSpOInFvql9GDBJ7J5uSi7/6BK+sKEeYcc4pbTE?=
 =?us-ascii?Q?TECtcAuRS/WWNB6qzmVzyQ97UMwod8i8NLMfbIRaImdnEiZLrl3U5k+hadkh?=
 =?us-ascii?Q?PGVjeTC/iKKAA6Pwq11zVZ3YnrsAgUIl8ndkMFG9befGGQlfDh3N0mM2h5Au?=
 =?us-ascii?Q?3YHUk+gKa8pG7F8A/lUSEZfLdqCS3laB2pOlMZtPxSka886YWVZtPst/b21w?=
 =?us-ascii?Q?oHOamrzztpkc/T/zzRAoGmcQwJecuYX/kP2tBgZbGOacqvTzG/wTqY3KHGA6?=
 =?us-ascii?Q?I+EXU/qpMV24ugeMuEKeZbtHG4FEH1eMj2wtUHU9oji7kYwaRK3bYx0GoPNN?=
 =?us-ascii?Q?QUZZvuczH66cuitdZ5lmM/EQhi6SNZG/jjhWFxglyFrB7+0bkh6WfFyXLkfi?=
 =?us-ascii?Q?JrJINRHtNFvFWnaFiugA2M/TkwYwZ/9nrsghhJNeDFO39xOAwDaLgZAOYcPx?=
 =?us-ascii?Q?O4vNMmjKyBqm2YUa+2aqzNA9akFYdigwtMDTxKkPdY4ds62UtV9cLTEtxgpx?=
 =?us-ascii?Q?x65ceGJb1ghLIvd9rTlbhmmL1ybnzVbNpv8eZHBdzMd6VWxbSFPLNLXxsaD6?=
 =?us-ascii?Q?Havb5DFoq0sibPG3g4XUfoCBYZyJEBK7/tAnKXckWZtVI1yrydoVNRCjC45t?=
 =?us-ascii?Q?ihWlP3eeLjywx9SPgdp12JbQEPocGFMf1ZjHc+kbXL4bciIdWta0lwY9EIwN?=
 =?us-ascii?Q?g6yL1KtEfXIm/EZpyZw+q0r2WqCrvOkmdvoSrj1rUkf4g0jBGAk1V1iWQ7oO?=
 =?us-ascii?Q?qO++ZxlCJ08nXHHhHA2lGMLknmqbJxYYJQo7nZFJh/br672Itv6Oqv1OzNkg?=
 =?us-ascii?Q?3atlhDknxoCHO0xQ1IzgnoE815n2c/MIJBge73zYpe3xdbSBNyQkNmPbCy6S?=
 =?us-ascii?Q?FyAq176Z5d/8wLYw1o+7x8SSnOJteYHcq3e8k0GGXthzAz7vYGJGyx4tN3zG?=
 =?us-ascii?Q?qZl4K0XBDTEPFxhl32RjPFmwqSkPaiiZuhowstcCP+6vjyZvrK9/wSbwYj14?=
 =?us-ascii?Q?yymsPIMRl1Wa0cUGuxiW/MtpwKF4+uan+u0LM6sgCbtg71bpY/Xmlb9+JFS+?=
 =?us-ascii?Q?7reLouVmfppN71zzn/zF1CzCLYJwosBcMB0VrLIZFlDzKpCTSQp4aDBBlst2?=
 =?us-ascii?Q?MHxRS/BmRwv13dyyYqFtTgizrP6qBwjwSiFoLFOwjvsoI112lM8miGyLMYvd?=
 =?us-ascii?Q?b+R9PRREgdbJrBpJe25qPGNM83Ugs2u0zEDpPH+ulkCv/hriNVcTz8Zf5gAl?=
 =?us-ascii?Q?sFx/tv6BTEB8z4DHKSgozH2Sss1+l0jf0l+V7SZGxHimb8ADzJHAFBB5ZCnM?=
 =?us-ascii?Q?xu88YOC6t5qN/2K6cOyQcsOIqTVuxHlVwz8h3avKpO4En9z7B7AKNOk5ItaC?=
 =?us-ascii?Q?pBAIT019L04D8xalZmzpSVkDFRM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1effcd6b-cbac-4607-39a4-08da5dbf9fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:18:02.7696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bIvNKMIvMdStWI7HV12Ue3omv0A4GOuvBDOku9OJE2Rnfp2WcPUuwrp7wA6NJD3O6NePqVAM2KYt2anxHRIfQvVUbEAMjuw1C7f9b3SEcns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
