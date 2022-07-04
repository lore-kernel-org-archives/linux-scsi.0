Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6122BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiGDNYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiGDNX6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:23:58 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD311447;
        Mon,  4 Jul 2022 06:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940996; x=1688476996;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Pq2LodBhRDvdMjLN42e6bw1GlCAI31oFdBEiho3bThOtwYU1BJ+c4p+O
   E3T8a20YBf49IcdZyRNQiM4rY+0V/mDJskeDYFxpzTbRFwaInz7OseGtc
   tdCaAuG1oqPkD+gaJkRuuaK+NWz6pgZJJGCp2sQta9TQjQAB0JXmH/pq6
   73PcZA8MEo1pS97NzACbwe4j7rIWcqUexEpQLD0dGLynTPU6xljZRhfQN
   422ld0ToYjzgN48hzeRcGwSga2XOa0dX+HgU/A6bg/HtQ20rc4uDtI4y/
   3Mj7PThQwFC6rIBhg2LJVDLmYausukdrCR/luw3Mv7eTq3PZkxuZ5ekHn
   g==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="316886321"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:23:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEt4s9pBYxmtH90auh82iCyuTEPumY+OAnIs/D9PYYHPBLB3w+uA0+qJXXM6K+TrhhyN179ag6nmUseyHER8wocO0+Zu7Ua4dklMG3Pp0nuJvu740BnU2ea7lyn1P9nrE9mnmMLZdb+NU8TCOYZeJFImjT7AT3mmveRArKp4YuzoiaewPBDqifqi+z71BI+5ABqD0La2QjKiY4phXeamkhE0KEHhs18P9OaGbAvNGcebudFe8150HAXhlTn+8eOz6wXkp0AmISNsxjp/WtqfpiS/Va/lSC5i1ruUE7IktrdOn1GGAwV0/3GGPpp0r9WPpQ0jhZQyPuS2FIHjB8jZxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=LQXSXf7atNJX/g3SaQX4wHMSk6SNw5uhv+f6Ar31dBmG/WsAvaZl+FbGUMlti76vUZs9kqlS+R5ffpgGr/Ys3wQnvokPzCyTNlqiSwN+wL/mfcX9U3mk86RuXhOo7rAD+8ceqCdI6CwTFi0gdFG3bQjHzi/bPyMPn8gMmT7MBYuwbXUk63qde/ZvdHXQ3lIjpVaW8BTt4gMk08XnirGprMIhGe7N9QggBYHghR8//aJZsMcKOzga+gnsostaCnpotBoCInxQ+2eZVHhG5myFp/TDqrVQj/Qw45TCXEUJunyt7WetIQLTxJjMNCYYSyeX7BV8e7nPLekwKq56hYOFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ajMZRKkFEw1BC1AesswFPqcUgD31D4jLvOem6fYFIE2VxMqEUPnBBLweDzBnB3wZYqpaOR/5cDnCZqGUyq8y3e/GqRCtVy5pViw9u6KyVN3UIZ5IEFUp1VQA/u0WKwS2fG/k4Xr63JEYbLggLAlJ1dWXJLr6CEKIHuwxT4EU1qU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:23:07 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:23:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Thread-Topic: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Thread-Index: AQHYj6P8W2g8ljstqUC2nb6WLoCFqQ==
Date:   Mon, 4 Jul 2022 13:23:07 +0000
Message-ID: <PH0PR04MB7416E28A6B375325491431579BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25bd764a-7f3b-4756-941b-08da5dc05586
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FEFN5Wg6RZiW3bgUtTGSzpAUX0rmRJ5wJmQBwYZUYqiWyvT8IC46/5OnrC03K6aY2q0Nva+I+uozOLQXvjV31B6uR2ZqeRl9RME7TPpXcCK0zdHKxXWiGd8HL1X1LfupvEmeQ28DucuS8+Z8Tgj1UGbOI7x+IJwa7sWWMLcKp3M4CfyugxYgryoHgulDNtgtaq3E6JY70vTdq4WrBJAh2TudIvW5fmqHCNNEMzu2pnVNRq37EwVanSNX+EH6IvQYj/X9YCWdCnO5YBDMn6OW2Yk7Dt6nAmSp6jxnLfUDuBFJEwYI1jDBnWC/WBvoA769Bj5VeN3NT5CkCWGBAKnBkIDONJJv3tvDSisMQLGu1B+plhCCHHzpAz/VQN5AHn6XEWm5c1L+MgAS6P2B8/KhkMXAw2ONKETceRTHE49kqZtfe67FIa9SbPJwJg9mTjJ1miw3duOjXj8blCKPVA4WgXNCsQTQeX/gCG581iGG74cNgLEbtfBawnB/4EbbV691y2bzo1Y63b72t7UIrOuBld0uUiXh+Vd5mG8VPhOvsYb2PAtqyNLJl8W5PnPMAg2ex/UJFISWpKdLFT7ZmR6YsxMY4xqCekkv1qKappbcMBe7J90DGozPPKIAyQV/+OvWJoUgvLll4Pt7xEHBKGZ6Qm2WxMBH2gVUzG4g1RMXsJk3mA0Rn49ghbkzMq7DyLNkZ8HL0z7dhYgQ6kvZbcKvs4Mooa5ZDCiCZVSKS4SrYzqXIf44b/C3W22pSadnjgzgNqBuYWSZ4FQOvD3VV8dZnhdB0/bDM1HT0YivCOYIRsfUyFxpT9cYSo05rgrI60F7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9GabfyP1HRk7E+S3nsleCNZiH2ty6YFfckhL2DpBxixdMKt1eE/aAzSQO4l3?=
 =?us-ascii?Q?mqbJmwIbGUuaB9di+p+Do9u0YrYJDNJ8utTjvzwZmtY4bIGZKlpJpPli2z39?=
 =?us-ascii?Q?W+UFPvytsyTpvOuWdc/Ma4pPAAAeDUHQ81zbojuAErOmyP9TZvmcrDSumazE?=
 =?us-ascii?Q?Onbat4f1cax0w3KZffC7pvrEOgUMchZB4WPQ2c4l23XHrJLhmU9ADSdwSl0m?=
 =?us-ascii?Q?T1DdmM/Tzb2/IWGSCtCcTgzljsW0WegPrxHq0mre301R56qLxQKbpjLrO36J?=
 =?us-ascii?Q?hV5aTuUqWHdjTyN/2NJjfjJfd9CIfFfDl13087X48LlyL++hfFCVOFCcc1cB?=
 =?us-ascii?Q?orPNZh1BtiLkElH3KxSVaK5Hirxv0RT2LHIn16UvM5jK+oxiW5xblreuWkIh?=
 =?us-ascii?Q?c5gbUtWsB//QlJ5vWZqcPRuqusqezaJJyCMfHFqf3iI2qxDhRblNlsH1oPps?=
 =?us-ascii?Q?WMbqVwWiaxar6V8TVj4MUE8dGyBmQLO+Fw3Rmv9oYvccWmxlOPlnnEdAevMy?=
 =?us-ascii?Q?GjmbobQOqz66+uB1V9UitzgFaH0unD0072tpZMxSruiDJx5yyz8L1yOJFJGX?=
 =?us-ascii?Q?mc4qbMYvM7Cn5ZwTCoe2oGipuD0sqleX5I93zZQJ1csFQyYlszLHj6mhztSy?=
 =?us-ascii?Q?3/cg1FdfNgVGCfgxwDGJi4ywnSQA+xPtSAqin4DNX9qYlMf9pQs1sqEKrUUU?=
 =?us-ascii?Q?AopoTbFTVc584Xl3aa8ozzvYET0nfI+/d/GZdkxlJhMYY5TIop3ZtxkhLJq0?=
 =?us-ascii?Q?t44DFz0zlTVyn9VpijHV7ki0jG6gchRN+9FAgYi68/9JMOfz+V5EOcmBr3lp?=
 =?us-ascii?Q?xkjJZ2W25QRXzqU6lXWrA/xZinKUk48fUbzikJ3oNpNofQjx5M7pdBq4s8MC?=
 =?us-ascii?Q?Ar66UFTZKVo5RxsFyvs7DZJ7JZTNuDJXyg3Wug/95SWSHo7GRHlo0/3fy2iB?=
 =?us-ascii?Q?/VCVyfmGVGikQZfb9t0L36BPGVOBDUlPpDZ00CySutEuAHeORO4IYppoLC9t?=
 =?us-ascii?Q?m+zM9s5eSxEy/soZalNx8t6f7o0FPlFP6pG12TP1NVM2YD1AYDy+ZemOzhtm?=
 =?us-ascii?Q?2iMHafVzxBwR+fDL//m3I+HJISdNK53Co3Wm/uToyRGO5HQhCZGuRxJ70D5w?=
 =?us-ascii?Q?QRYyvh7mVsNB4clZWfLkCTZcWG6Jro5NvWihxSBU9q7tfq2F80YYC1pyXNre?=
 =?us-ascii?Q?TVnjI1GOsYppQABO7r81BsNSkX2t+K3R7YiLhkIG0vL7I+qVCQcVAQxrZ1O0?=
 =?us-ascii?Q?EixmfbKZS3Wylz0JUfBARUBamD6DJIoieUtFFIragjmx1cnN/36/XIN2Xr4p?=
 =?us-ascii?Q?dPhRCCk15ACmkdc7/1w/0Y2xFUPa2VUL33Lxp53WXsnQiB11zZB21sYuJGHQ?=
 =?us-ascii?Q?3e7RUjnpC4nZiOBKk/X1GkiVmBWslOi9cEkgZLafmmJp7JBqjiDCNl3D4mSk?=
 =?us-ascii?Q?rs6XoMyMZwQB4NHPu36yqShj+guL30xOD5R5MNHQL+eOHwQtVkzb8ptOF7dA?=
 =?us-ascii?Q?pICHfc1jz+u+OGwS9zZASpAgxPKC7N/0iL8ZrEbaxeZ/xhpHc+q5EMI6TnW7?=
 =?us-ascii?Q?92j9Va5eV/Qclj+F9tAv+3M0A8HFa9l9jqHg/DgTSI+woKybOfTPqbxjf9sD?=
 =?us-ascii?Q?cTId6EVIfET6CpvLSn8wxdK1hxGqBvHNMVxXvIzRN9AX2UvrnFYyQhOLZb24?=
 =?us-ascii?Q?piVMZey+mmbWqPjv35Cj+6ONF/c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25bd764a-7f3b-4756-941b-08da5dc05586
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:23:07.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6uo+UJL7b0Vm8/wawJL3q0rq0ir2gEocL4VvXMPnY5mLfvxS3OFO1cNOcuKOWvsOIEh5e93Nj3qxotVjZ/jANBns1Mid1BPEZCyLo25kGyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
