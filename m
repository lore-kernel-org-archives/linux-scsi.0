Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4670AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BE8064F26
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhCANCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:02:52 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48903 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbhCANCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603760; x=1646139760;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=gyn2/hri2zb6lTnD5i2a5wpM/dvyasrUgqEaS0b9J8xJy/r2VJyhRdO/
   QJPJD3sLFYY2rPI3TX7RilJCZ9ctIwXFwYAYTg6fDgDYR4Us/aOCh79UE
   gaNwEnKnS/XD3g1wEj+ef/btN+GeRy7x55DTbY3zPTtmRf6dhQeL0nXdH
   P9Z7s0ajchvdiPbVmlTpIQJOrR6+JJi+jSajkb0b0r4cLkJcLsAFrb2LZ
   +pkCz1muRBxINTz2D2addhxFEHnuY2e3KEAltJ1cHdhW5+0HoCRkByx7c
   Q67IPgpUeojX6PXPO5+C9nptkPdfypRAtc/DMpO7s8ehp3ekL4oGI9aLR
   A==;
IronPort-SDR: T9wxwtpFz6AFcs1ekyZmA0q4rXMT1oZqJmT+g7c+C+g5K8VnXpTkZHYvanJKo6BgKi++iNZTMq
 tglQwR2U+P2safcmLznaHzJlsBQ58JnoZ/5M3cD4Q7I/E7UA7RgJ5aEeAMyGN55vDhkRwuK5wn
 Gqlg6VXi7VEbUKM4Kqzxg1+DHnAkr+VI+KTr38ju9Q091bpquWLvBjM/lzTFSj8V5UxpMraa2P
 x3buw1KGxOFPunrzxT0TyjzS9j6PmhaCPWc2zGGbZawxizc1Ihs32QeB3huqlaFUX0abFXMNcZ
 fDw=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161052869"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:01:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJgFZBxWGF2pH3Zec1wY5l1B6wQuPPwR/WhXz4WNP1EEVjeqJTGGzxGuevp1p7vbXMzMQiAnalpeO8AE0Crp+ijA85ZQdKjgXcJNSJq3LxEtKEjRG+Tq3d7Apk9MD+wWaboSs+fDRSk4fghskNd2s0B4JPk6fNsT/07pTrBbsHQl+q8U3MgObVarVAbrSUjXJzWbDWv9PdGugxdhkfnlIXULvWvy4vfHz47pdtfTxwmfMCPN6+lidStavPOA8IFLq4KkkH1EgPFfkzQPyFeFKbRoFSz6FYym12BNRdWC6hQLStWGow7oDY+iSh0KWXxMt2TqgxU87AqvuQpvfFplGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Z3OJlawudDcPOxeDdUjDdJ1GLSRwJFkJEgJw93Hj4T9wORu3KHdWgXjPuoJrQMsZ1h8DdWclqb3K94DOffpS2FIFFIGo1CWhAG4OYsNObwpSjD+3uzOLS6MqITQx6LdClknP4NbOUQS/IjLtBD3mNvy83zetT45GcrlAKhAylI3poYtDnuaACB6SP3jNP+OndiNt4dmZvYEzupKzJ5jCkJmuGsE1H1iSR/wxzPRSnASOjy8Mdy+ryfTfedmVpmTWPIshxQfl32Mme1qm9Z6lUae53BFo23xLSNG6I7TX0ifH9Au+nzPxAweNEVl0iZlYC0ljfTNdTq6jWEmnq0/trQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=udOCP29M4nIntDKMOGxy77e8jITXXAmLOpdVH80vQ2h3Lzb8I1fjDuiJN8lHiw2KYTrRsNLX4EWBF4dZTilRzwJDIjbx6mNBXbVQaSY18CWKsgLBc8tGQi07EFsY4ZX53L9BjmzcypdRq68zpUzd2PUs45YV4gwfSg0bn7q8rPs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:01:32 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:01:32 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 19/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 19/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZdgqAkC+DvTlUau/couRh2RBw==
Date:   Mon, 1 Mar 2021 13:01:32 +0000
Message-ID: <PH0PR04MB741678E5D3B3EF120E1455009B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-20-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 087ecc3a-83c3-4e80-b452-08d8dcb22358
x-ms-traffictypediagnostic: PH0PR04MB7605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7605A35E33C59CCF75015C379B9A9@PH0PR04MB7605.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Is4Lh2nLvmO9J1kBLPF7KnxpKMwKNt8dXvKB9D86XMaVxjV1K6IFyuVU1aS5ZznWdqTl6dZKoD/+JwEzHj+Jh7/JP9F/2V9ym5JY17M5lWLsbBya6r5TzGqzI1gp69KCzg2kGC3ns3iQfECADesc6bf6nvTjciC+KWJf7bVO6OFS9N2VtE3wOdv5uPFBbqJGUKzKHcWal/Hzjq9uhv/DCFmY2sW5hEfhmYzdW5GMxU8IItBW2FTq4WLneegHD8VzEp7t2PEdi1dlKgTlsqokSpbpxnyEt2gWqK8FHJHNtfZDspdHNJ1QLB7mNBRbDnd8IS2s1zzadDm3/BQ8jbp+W+dos3BNBDyYajjIH6A+/M4qqjbIYBfFGy5o9gcOohWhDLelAImOY9VW/1Sj2G/Ycj5fOy8DXFehM2gsdrMdDP7hb2uGoX20Hnzndw8oia8Y5BW1mvmvgFeqh31iit/c8DGLE8NIxQFXXbm9bNHlzX8BfpKY8J5SV5hVk2NqaMWR9p19Odidh6cw+dMWre/EA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(54906003)(8676002)(110136005)(66476007)(66556008)(66446008)(64756008)(66946007)(8936002)(2906002)(7696005)(71200400001)(4326008)(316002)(478600001)(5660300002)(52536014)(19618925003)(6506007)(86362001)(558084003)(91956017)(186003)(9686003)(55016002)(76116006)(33656002)(26005)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ns39h4ehuH/zvAi5/l2xcqXHzXoytv6FPOgFXxYm2xOLjBf3Bnn9F/jKSNXT?=
 =?us-ascii?Q?I1lwwpz1BstUVj8TOHjY2aCPCRrJnQINWoGp9Faa3yMHJB0mes2xaVyS9f9F?=
 =?us-ascii?Q?9OIMbcNk6JCVFzvuWZoLTWCO2Sj9AOyVaFTaHcVhezvdcdJ9exHB4fSw8zqr?=
 =?us-ascii?Q?frHOaiHbDWx60STKuo99yj1PEcQKmtS0Tl2CyyrOTwikM2Hi/zJxcp7U2EiW?=
 =?us-ascii?Q?vAdEmkTanNOuFrcZnxf+CzHWF6P0YaRgLokQwLPuoG9O9lFI2BZCtWtn5C2C?=
 =?us-ascii?Q?CAVzPjyzWuwITY+XPKCXK4xDB86MacPaQO0TYFy7QYEJzvO0Yng6esMKxanS?=
 =?us-ascii?Q?VdjXZvtHlyUZKnYp/aT5C8YAHvwTZxFjD6Vhmoe89uXGbFIZpqE9FTYzljso?=
 =?us-ascii?Q?vO4ekx6TzO9QD7qU9gR8bBu2L5VJVwUlj06JcHwcA39SMaj0FcTfQ2HTVzaY?=
 =?us-ascii?Q?XMbsibMbkeqX1kQMwLnWEnClZDFyGd9zbMyPw3X4+qZO+IU/uTrSRJrHMv50?=
 =?us-ascii?Q?4yv3LMDXc6NBKfYTPxEHiiEL5iyliHE96WVmtgi7bjY5obLgnTuR783Zk6lN?=
 =?us-ascii?Q?U76NKPw0aUkBQBiMwYMInroqPR0MrkEBTPtFVspAOL3d0b/84ekRTwoL+/qB?=
 =?us-ascii?Q?Ou0OPpSyOMq2wM4vkPajzmUlKNGFkRjiT50fSrfjGPCXA+LOfnC3HaWeyMmf?=
 =?us-ascii?Q?HdZq3joyW8CzFrsSjBNnoosI2zn3y45lMWP/KCfEs+iAVdUZofYNe0y1C5UQ?=
 =?us-ascii?Q?3GgvYraiHunItiESE6oG+4a7o5Txada3/2VrEYBfR3sTqwcaQZXE8axMK8aS?=
 =?us-ascii?Q?J2cXfzgNfBAZ6st1ydWsXCYohPLhq7t5lktCgZtwhLIlkoXvJe+2ZLHnuoAZ?=
 =?us-ascii?Q?YIexaG/gH+QyyabX/J2Jn9wmcF6EI9J77jhl1buCeP21I8qeWAWbKICWHAYh?=
 =?us-ascii?Q?mg7ykpYcS5Az0LG7Tg4CXVcN8kqE1awePztAD3AZVcmd4NwEb/AdCGiJfxXH?=
 =?us-ascii?Q?XMCeAhVuuvYDV4cB529o8UZ9xgjOeAToS4cVWRXDH2joNC6q5dQwilo8lYP3?=
 =?us-ascii?Q?+Ajh+6rVHljYtTmTAPVaJIqsYQ4WLFlZugyUYyfs370DOWfHqmAWKZmUahIw?=
 =?us-ascii?Q?E/mKNySJIujYphBGZl1sgnO+TW/UB80KIGXxWp53JlyhYoGK34g/YoA/m6hX?=
 =?us-ascii?Q?aIMeMC0tdvwR2p5ZNPQW/BnGwDk9K6eiRbcsd99EoGaxExljCcTzl8sCyPAV?=
 =?us-ascii?Q?F6wl+AwtFJmEi6AG+doNvIgiaxeTAIDlxG0F7wKRrL/ns0elsFZreoFR8Dyy?=
 =?us-ascii?Q?z3wGMVI4Qua+qK4+rELV3bACRwKOshL3qYXZYmsRQo1AKg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087ecc3a-83c3-4e80-b452-08d8dcb22358
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:01:32.7005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywgPzPTVa6r+3B13vWLPAqe6TWQTHV43qHnQE92EoeZXqyAVLjD/E4ySbmCy4oNSkpaabRbs49h6FTaTxm+ztZ/nwohYwSBl80Yc7II6AqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
