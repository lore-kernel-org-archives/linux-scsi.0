Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FF1C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCCD864ED0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhCANCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:02:23 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25837 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbhCANCU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:02:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603739; x=1646139739;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=c1fgsAvk0jqQrzpfO7mfoXKeJcnogGU1aBTDWMlUgxiKyPv3wSd9rVWa
   TGgQCnkOJWydIVwSl17Em7+mm9FF9yrOr5Fi1eq1PNsCRRizgOtAHbEnn
   1euwUC1hAMUGP/A03xL3F0fjBacShz7/pqQQOxCkGiIbk1RpnXNiR0kRM
   BLjx2f5AYMrCJFMbodrRYxuNWwCIOUiOXTZZ6sI2hzUZsu3u783IzLFsh
   kmRqhRSNgh297InGv2TERzTxAAc0zDKwy6TSFWyTUIVTbjE1TAALypllq
   cQCe0PDwWGYE/sA1fKU4SbMgR8L/lDIpB+zup9aKgd8rWBtHajSc7j27e
   Q==;
IronPort-SDR: JLvRXRfn0uEDKXfwanr5KqbM33/h9T/YGlIgPH/fu4D6quB/TGZ7v0JjoLCWxccfc3XfbC3NgH
 nV2h0MANNg0QOfDtob/YUATUgXikaXEPOHGxrDK7cHIUJVRs7mNCtxbyOSDpPgI1hqE5SFswei
 YZnhsubaroEfaDT2yobVkj6hXqC88Rw1pQdl+RK0jW58EJIpDsn+bKTtOqptx+7QP7b3ur6tGd
 YjHZPrkdZv4ZjaSPMbnDD6md7ATyqB2OmrGm2SE8+QgZ/rSRM9wc9Me9i4gTTW80CcT/DIlBr1
 3qk=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271660735"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:01:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0W3seduGHKfAhuKUOFJT31pXyWIEvxQQ8MdSB4bUxEDPvL197G/h4wZkh4pCPoQ5Aa50/QlqV9hw3ByFcetQMkNSt02JOGu8V3VfOZrDOedp4290gecrIY/nxT61SPpl1L3y4l7A7RjjUeHPKbGIa8Q+VAjzcjRoHWYI40HK95zD8x+Cwyxo91M9g52hlUxOXLcrjTz76ssLSkWKSaHZ35MbTKeV5Wpwbt9Rv9S0QUS+ywJXV/Cq5xs31pFGZtdor5Cys3VVMopLlW3VM9NF9D0qNxWB9hl2OUeOfcluB3gyiMpzJmdIb78+3HkgqnbTrLjz2ZGjlozYgKaw9WeBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=KUMJCdK5xMZIqTQMaAybhkHD6E4OhUXC2CHzy0DuTEcVz+yGdTjmsXUQBoPw8oQwOMwE0dmunNxjA2usGX3sPQaHhTL7ZZLiOlEPWz7HXuM9ZwbdKicbHbzbTKYOqQ2fKGgI3BbsH/Der2ZCHPXjhhKIfaqv4pwYg8VyoHc7jxQvduOxuO2KJK471v+SENd+aOtu5h26TH67bIzL5Y6C0cRh0ldLNjz7NvU0+lN4DSGddWWPSj1Edb6/zOO0S86zT5FEGvaXL9WnfrQxoe4Covv26Ff5OA4tWhMsb0NcRXwFOhFzHVD098C8Ljf33CCAdbem8+1Vnu/7jzTHGK13DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=x79D0PBD8P8hVbuFnrqjef/w8rPHnrjn0v6+zqjtnnY5auSr/ejTf3/1RS6LyqL8n5uSQfgv8nLfIS/SnwP62f/1xfuSLo/jDZ1AsGWE7ILMeaVMee2stR7BzJ+Cv4bzgIjm66xQFcOrUAGxWxi6DujwcY2UZHZbqZH9ut8GmJw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:01:20 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:01:20 +0000
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
Subject: Re: [PATCH 18/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 18/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZdUY5ZTl/KwTEGWEoHnzum2DA==
Date:   Mon, 1 Mar 2021 13:01:20 +0000
Message-ID: <PH0PR04MB7416599678DE221F320340E19B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-19-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a2134d3-6ae9-4cf4-9c35-08d8dcb21c42
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB73183FC62CEA0A12D4886CB29B9A9@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /08WXQVc3GfDj5U1XpVM58wt3nj3mYiKjQWm0JZjH33NM9ZSGHV+/RD/SRFMtExPrZxJYUGOGdZWRK17poeX3KdmVuEIrQv9ZUHyefP+Zm+gIq0LDCWR345P0mJw3CUBValJdJ83AHYEnngXaCDQws/B623D3MC6yeVrEpmeiYkzpOlaHaiN7o5u/wq1H+BXXa2qfQg6LE5Jr2v/tTLQp2OYuRf5Hp4HpZbKLDXnD6bt8C3Cncc7djB7Z+cyB1dekrRvL9vXOYFFUncHDS3FvNlWyy5KrmJmtkwlUCj/jgjE5n0eLJ8ZUagGNSS3IGUkUwQuyA8CpMcG3vyhDdvuJxBA6ckR6OuHxlts2HkHlthsUZRZd4E1v41JlMvDQfm0ROEwOZYbOCciuQYt7Zez47omKaK4aUO53SSruMjeCU1323xyFn3JaJiIKgP3jm+43/uM31gX0smtPTdbwyBoZ5mcXTZShNnWqh+H3D8SoqwkI2mZvTODeJ1Z9k/ftqJBmH1rFVU1AkLEi21TnQvUZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(316002)(5660300002)(558084003)(52536014)(86362001)(54906003)(478600001)(71200400001)(4326008)(110136005)(66476007)(66446008)(26005)(66946007)(6506007)(55016002)(64756008)(8936002)(8676002)(19618925003)(7696005)(33656002)(4270600006)(2906002)(66556008)(76116006)(9686003)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GMaaXbw8laOnuPvPNaD0GWQftoBjnHLh4/3LNAUrYnYgbUG3AtQi8Hqj06MT?=
 =?us-ascii?Q?Lz+Ekc9sVeJ0GjOQ7YnYLdaP4PSFGLacRLv3uGU1H81lsH+vWAweyKJ6d8ag?=
 =?us-ascii?Q?oWJpiCQNkKqLXZzPBhFTdnuqZDBFOpIBD+xqk1dRAUWbSe8MyEQ0B3ztP/Fb?=
 =?us-ascii?Q?e2gx7XZa6eUS11VmTCMDwXT26MEXIPPh6HzwcC7XhesLr9MZY0aNLlwaEmZN?=
 =?us-ascii?Q?gcpRdQimPdO7bOW6FWAxyEkMuFmJMRSWaf+dVuIyh+CjKsFypjyGjA8L2ro1?=
 =?us-ascii?Q?VI4XYPTVBHsLDAag1/qNxyLFDEusF1kFiQ0VPfcR1ZyhG9z/7H507E0bwFYY?=
 =?us-ascii?Q?jSMeUU6tdBWjkniyceMBFgQUfNiiOFQnHUHACGqETDsC04JH2TJC8QU6tjvo?=
 =?us-ascii?Q?LaZwfjdzSjV2NgEUBYnwvtIYkyiYiSqb+Lozhjl+tbfDcs7KYvJik2Fuhe2Y?=
 =?us-ascii?Q?jxBUSGNB54BPyUiJ+nuCZiezgbQTOnRuYckZ8Q+mrU7KXFBTIWuym+jKrYFH?=
 =?us-ascii?Q?YS/vAfSnmVPbQv19KwNNn6OqmMBmN6z/CJcfoXCUaggX+Q+xibtpMjmCFhZa?=
 =?us-ascii?Q?EhSvIGNiqnewoCCX990qRfk0+cSK+o1ALaM7ota5sn5xFK7Ux6wXbCE5cbF6?=
 =?us-ascii?Q?pNM7Dljudu+qZbrtoEPk9C3fePHCreNQYOFQh9Jb40jVET+4er/XfWX/zuoa?=
 =?us-ascii?Q?bFf34Wl4FLpJUfvNDp52vZgAdiHknSt/HAzkLVVog9CqaAzQbL9p7IWWO08O?=
 =?us-ascii?Q?oT8KVxXOtABWrwAsFEMrSG7yrR7m8zgQB0EUSDPTl6vD9hSERoU3WqRN8ykM?=
 =?us-ascii?Q?NdMVSYloj7n5BweL3ENSsA2Fnzid/TEgXM+7O7g+YqC+AD15BQK/UWskyv7A?=
 =?us-ascii?Q?O5x4Zg6NO1K6ZvMvn7yytc6reo8zefwQDNZRwa5RsoANKwm3F3yasvsWioR0?=
 =?us-ascii?Q?c5vjktysLR7zrDhYnWCDWI2karwQzUKpMrkg3msX8aVaJ5iroQS9mfH9wduk?=
 =?us-ascii?Q?RuHzVMFS5tvisAgXVD3XZaT2U3vjjCUdBj/y1kQpfyF3vYpU2Wfr3rRj1hKf?=
 =?us-ascii?Q?Gs6uUM5zSqvHkkhhqpVWJGm/8nzw7nqMciophY5FNyr6Gd/rz/EaLt5uWMrY?=
 =?us-ascii?Q?CJphW2M8xQJuP8ExwO+Eb367twAqe0GTlXtdQ3en02X1TFLMdTCzjymA5b7d?=
 =?us-ascii?Q?tY4Ya3ef7V+yCiWX31Wl2sYSo8+umHBAYayTf+HmTLvUMm+SxjXzOVG5B4qf?=
 =?us-ascii?Q?/+4fKQTLGkTuAKAVRKIG6+6mLYwsxXsclQ/hhQAYqefC6KSxium3UhEZN4X/?=
 =?us-ascii?Q?kJcOJ+V0a5k2bOKW3LPwxjPcq1qKFUCQAe56Li4J5bLbww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2134d3-6ae9-4cf4-9c35-08d8dcb21c42
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:01:20.8426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NHrQcits2cjhZPr8EWrbtn5IEpmqbbm5eWh3o9LIy2YlhtyXuZQIw7sUfMTrC7PD9Qf0Cl0hwgCGILpQenzGRDE/paIVKPM3HCJdwWaCA8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
