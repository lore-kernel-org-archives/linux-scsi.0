Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE9FC43334
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiGDN2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGDN1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:27:42 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0232513CD1;
        Mon,  4 Jul 2022 06:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656941046; x=1688477046;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=KoqJVWYdH0FG/LZiY5w9gerZjZWrm1j7eaJAleSxO10Ubh/EioZpPN8g
   pLrDJSgZpTk+ksQt7RQHFEUQkCcQmKxB6edbTzflYDUP9YKfR16UPUGI3
   s4+mRCARSafhoSKFZOXqjrQv9Zfo8IdiuESQqaBUQumneg7PtafgMjojx
   0Bzr5S52vdOC/rFHudwnP11Fjt9ueMbtq9KSpFOBIhRhsunn/S7RPgyh2
   1Zh+LcZEj6CJ1wM6H9Wa8OLODklA4CZiV4iSFgG6vi7wYPHwjyn8psOlp
   O3l7BwbOgnOmWfDAK3CCyOEA3/Nra7GAKFFA0G0KmU/OfB4M61iiHYRZm
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="204767372"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:24:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPU28PpWCdT5HesyV9Rv+Da9/QWE9BGCovnrWL9VSgzVJYMwPzwPJ+v3+6xaSTA7JDfNcDlaJ6Z0G4faogrm9DrHLPMOXw/GOZ98uvqNS0eHyePRuz23vuKKHivyfApcqnqgGfepC2d8ixwX4Ws4ZhiSabKdznaKHeL04YsuBY1gfA2+r2cgYjOrorU8eocB5PTdDv5YQBK+WAov8YnOD7O6JtFfFrFbQ+tEeqITKUp2oLrmGS6rNftEq9e8AlTbjpZnEf589YSBVP0FovUVKtguqIL8bE1PqNpPadkxP0eiOpdun/VyNquo4LSzXU0Hr1HFuKsNzbfdzeXjMFZbQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=SMmtzWynTU4+H25+zbLlEGdSIVsqAE2GHGRnApY3HjuZ4vbDaYEwglJ0PKmcfR25PEnkeR4xA6Dhg0stzNOJm+q7GJkwAUtDiIi5uiRApshpZGfP4Zhn787+P+zifCUqhF07Wa4TcJwrXG4IIzpf4/teRWjvx8XYsZWBHyS6k9+aq4AFLRRlw+WGmRJwwaVvx+jum+A/nHfq/BDkz8oyXrfH8i1j4xGFU+AAnEiWuAOaehmmwBRsBuXGEB7u5JB1tKNGOfgS0Wa6peVN1nxyC6CmyLsVYvFZbtInHK97MHgEBaZCsyEAYscQwqbsRfi54ote3Cv/S5fS381N6vqJJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=DLuvudjy7rL8Ff8kZXI1u37rWGiMHJEf1MRcH1FUM7ew56Ty5SM5gHo+ZrqQnLEcQ6AfjjocfEcTG1ye5jXlsRNsRw9SHMNoHN86MsynxbZlgitjMj20FQd/ehwzZr1Lbwl5zBzopv+yA0YlGjoongEvPHhGnBrl0RHHZbbbjvA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:23:58 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:23:58 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
Thread-Topic: [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
Thread-Index: AQHYj6QEmgIxmDiTeEOZXJPM+9ovBQ==
Date:   Mon, 4 Jul 2022 13:23:58 +0000
Message-ID: <PH0PR04MB7416CAFBC111056F2E3198509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-12-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcfd5a33-6d4e-4488-9d71-08da5dc073cf
x-ms-traffictypediagnostic: SN6PR04MB4640:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SK+951zZldt1w8qI29434ohu3d8mGrmmt1lzIJtMcgdef4F/R3R4NeUih7G6T89QVORw79FHFsA1gSo94D+dV9/5OeOG1veJrh9nkK+yt7O3KW20hwRUpaYGIlM0PS1AByMHlZtQXTBILa35MFZ3LdZyUk8TaJ9bkk2SedRoEEvOqEStKt7SX8X3sD8NEgW5C8M98sSjAqoUpylQB+t24rW5b3+CRXCHhFD7xQQtttFA/RHlGmeW03dj9bgsaqzl1+Kvm45isLjrjlnBTebgfjiTaQ2GM3dJhLSmZIzTb3KoyQxpqGLkbp80wjfTGXFU/6z09r65vvcgii8JRk2d/707kGHmtZ2owzeXsHXLPOHOmyVkEbIwR4lsgGiVTxrSpSsOIxUGgkyaklV5Z7/j66mYA5KAWu0wwcSdpb3VWTNX0HxX9wREXSvPo2AEbvsY3RgS5jz32zjATSTtj6eyNkUF93ynh/bHk/59a3kgvCWbZ2FHbCn32A9gZoEnCvuMNZ4ygKEBhOPxUVN5cW+YCYTW93/8ZAfU3HzBDm5U5fOJOF3/g+4vCWSLivSMQ1r3A8HwScBzVD7qFHrxf+Vcp4XmYYRVS1DSi5s/079iURt7xqUqm8gPp19MESW1Sgcksrf+c/ObpHdp2Wr5HPwovcardf/qv1lG+pUnMbzqPGng9loTFjf6YC2kqHqJJnMLhHxXX3Az/H1Va2hXHazizUym/aorK43RIpc+v717oIhK0jYa/yFLsjlOm84fdVErhwII7t+O1Thh1Tj9S9lHYVHQVjMkjBNwn0G22glK5YQNh3aSmOR6/fcNLGWdmkKN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(33656002)(38070700005)(4270600006)(122000001)(2906002)(5660300002)(558084003)(186003)(82960400001)(478600001)(55016003)(19618925003)(316002)(8676002)(66556008)(66946007)(41300700001)(66446008)(110136005)(8936002)(64756008)(52536014)(76116006)(54906003)(4326008)(66476007)(71200400001)(9686003)(7696005)(38100700002)(91956017)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wQBq2qElQeVltf4bcQRWUS2qIZXfg37BoJ5oWkXx5G+jYUG55fiSV1+NIHYE?=
 =?us-ascii?Q?9wf+gp/wKPZ1X0F0aw1UIEPnvXmVPmILp0bjPmDFYaShnUEn61EBTPgbzU5p?=
 =?us-ascii?Q?1zKWoEHZApglFI9eMcJPe+wI1JCQGZkVEXKM5LBBCkpbDQZKyW1nNpaIz2PK?=
 =?us-ascii?Q?rIzPd6R63nmY5gOTZ/TeEyufqVcb0KbWfKx7j9JsaFpcKWMA/26KQ6HGE7f0?=
 =?us-ascii?Q?NNsSi1a1GI9bhIikzWyBFJjBJ0xRmqn3p1DoPOvEw7DRd9EHd8tj9RR2qEcg?=
 =?us-ascii?Q?w1W+oY/o3A+SUMu3ZBis40Y5CBfZ2xovQE3nfc6NDISZnKYMn57bBiPAhEoI?=
 =?us-ascii?Q?vjMs5khu2hs7HAoLHwXUTsS43FihTPqifPTSKK1nWcZS7NN6tSYHF7+CZw5I?=
 =?us-ascii?Q?IwZ1A4qHCsau+pCE0v97bzAJEZCvs77NxG/QDQ1hXyVzD/KE1PDX3OFptvj3?=
 =?us-ascii?Q?1TzmVgL/QJyyqyrOw/v0h6q4Jm7QPPSM/Q1QrAODDX7SZuYtoRzYheUxJGx3?=
 =?us-ascii?Q?b0pgF/wrjdlvy8T32oJHltXpIzzdQY1J3B7n7DBpou05yHdjwkvNkDxGGtvh?=
 =?us-ascii?Q?y3O8jg5nnHLzGrMYuL+2IIoDA53M194veBZIYD9Qf8r+NoaE0MObxfM8Q0XM?=
 =?us-ascii?Q?h6jHecB2d2+mhd3GcrJUgQpf1cggn8SU/MNIvQzDsHwXlG7oVwiq07rR7uTG?=
 =?us-ascii?Q?DBqeRtYQqOJwHnkxvNu4O3iPwJ5AUlc2a7R4Vu11dqsB64NAvJ/9XNoKBIDQ?=
 =?us-ascii?Q?Y1+rNCGMNuxF2v3E0Q4yD0NoBwi4LG0/RwxMZt/biNdKSgeaOgYqizraI5HW?=
 =?us-ascii?Q?TQl16V5rPd7mRQ1K4FmTaJZMorZb/U4opQvkVjtId8jmdmDxyP3Ot0H58f6m?=
 =?us-ascii?Q?nj8PE/45g0AOXGm1KElLqEY8ocg0M0vdF3di7ebNGladn13a+jH+fNIKH67h?=
 =?us-ascii?Q?S77Psmk5yGA+pBjhWzpCwYamXkRwaEgAIW999tT957GLUpB/7kzTonBWTu+o?=
 =?us-ascii?Q?DN6z2r2+bsxRr5vUzZmuoC9cWXaNH2s5CGdTavXSylI+ejo+A9dq7NlNbk5i?=
 =?us-ascii?Q?VURys9jKtlYlqnJGXLBwG80xOv10laOOZH7e2Wl+jfcBmnzKWkxi8OsykPgk?=
 =?us-ascii?Q?F6AB8dzF8L9gmJxsBARsaHQ65SJxpXKcT+weTj2a69nwR11D9bafY1n5CX9k?=
 =?us-ascii?Q?W1DKWxGYxcfELdBMsRaKpDzKbCLbqGxZf9qq0elLstKqo3ZPmVXcZmd0dtUS?=
 =?us-ascii?Q?Sse/5KxHgscqFVeuIXSGiSi/jU1Xkiq/qzf5iQ57Ihbvcn0APcRdyLU0ooXv?=
 =?us-ascii?Q?MAWAoMjwP23PZVzFTtTdSH2nnfWopyV5R8BUDFAIFrNcCBIKnL+Lpf1jjbF3?=
 =?us-ascii?Q?kEGf82pPb8RZtzYK/Lme78KVrDcsG+DjQ8XVWN+I6imt+eEcgOUNpESpC8zK?=
 =?us-ascii?Q?VhNtkh15McVSG2jGVR/EOoI//So0UyY0EmUsm+mhozs5Yjay3tARMhPHTOEV?=
 =?us-ascii?Q?dikyIMsE/TzUlzRRJlk7jTm0q30u46xPRZieDDsgoII82HmP/WiUaPLwWetc?=
 =?us-ascii?Q?z18Dx/Q3qYlmX5lLGcZYKxwS8Y859u4pFg1KwlOhjz+a7y/W1YIPd+TUk3sJ?=
 =?us-ascii?Q?WGVxIFTUVMUjqou8nLf71IIMLvHzMLL8SCU2ftB+ruOdejvY91pYg4apUE0V?=
 =?us-ascii?Q?8CZJVZQCjI1JmtPKXPfvnVMUvHM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfd5a33-6d4e-4488-9d71-08da5dc073cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:23:58.3811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImQYNk01FyPJ5DPgwAWNT94Or1WDHzmRAm6WOE07/15NBt6VwzvpEsHtx8ceTBS6qKPrhrwvMjeU59KiWZTUqU28CCuoJjHfFvluADoYEOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4640
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
