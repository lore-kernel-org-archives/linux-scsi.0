Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E69C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiCDJdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiCDJdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:33:51 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA2349F8A
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 01:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646386385; x=1677922385;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=I83IsM8Dv7eO3VeJLCpajENSUy6Ib2DHAYol6uNFYWcDCaI8E1OK1WEO
   uSTsMWgqPX/Z8cA+iw2VA70QGIeWtFYmpG/+1syYBBUXZjQ8JKCZpP+kN
   CqU5inzTidPeg6d3mlMl+liJlZU/h0VIsCjqIWdlkrmRDzQDbN9lVf0nh
   e2ykwXQFHyMx4D6VIfToBZNpnDHWUPWhFmyH7QIhOlkBk0AeTY72+2C6X
   5KsCsoWQ85Uun72XPrfToB73qIx4fZqbtf9LzoGNW5lMb7zV93iEnWgMJ
   Xx5GxxgRWQyeD4ehEyqx3Firg/L09kmoCi3I65fdCRjNvj3tOGm5epGku
   w==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643644800"; 
   d="scan'208";a="195444638"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2022 17:33:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdSMA9zNpMGBp180bMLlkrXg4IT/3OVjqSn/8P6uxh9ge+YqvnRyTgciT83/CldwtgYrf4kP8x5ULIHy4qE6T7ba1HwAKAERnLhzzUHc/ATAklWwJXHYHsjTGxuYmarkfKLDzLooQpfekt2SlonAhxyOP862gJPro7L9PMUHVspr6SNnn3fqeJZlJR7nu+ke22CO8Ze2LgrRDCOJNAOf4FXSrIPBAwZ+noL8g563lTo8LKQuewpwuns/VMpt+Emx3Zv2MZTdRVMYEZb0qohmWd0NBw1skEhaWR9xmA1Q7MY0EwVT16ZDQSNtZ6OJks3CdBDyZis3sGdpAV9rZtZEtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=MkBlnNIVQy2Iq14ELboISJkFh+l3peGKy+Tum3Bnd30RVthOOqcAL0PYMY+7wKC6dLSgbsQyCPQt/xLKQs6a5Jfx4uUajk8SZrMj/SAwh2BwCQTT5SLKSIsoCg4e0CBrSo+/tC8KoHIZmIaibzQygTn8RK7kbzOOH13UWBnDrFb1jLR2K7szVF5urKVOACuygG7by3xCRg2006jigMkygmj0fI7JhHmrCih3UYuer1dkxW72+TNxU+JgoVyv2IvGp6s99/QFvTqgnuaJ5ELRePrXVwjygumAViuX2U5Gpwh5QebaNQfyFAmkK8KXr931/Orbvpf6L22eBP6VLI8mpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kGge0GRdOtNaEtq3n/qiCOK7EDrn5NJcyiOut/HEZkbpaOqP7TQci3OazUmYt0qsNkAuQMou0H4eJvmbaQI4KHTNLlS2wvH6Px5vI78tfq0vcZ4uLDw4eNK3i4HD9V/RzeSslR5uwO5S9o6e2PEFfEBboUW4nj00urbasdjU0yk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN8PR04MB6305.namprd04.prod.outlook.com (2603:10b6:408:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 09:33:01 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 09:33:01 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Thread-Topic: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Thread-Index: AQHYLfeE6JEzhTCdEUmsZUQAyxMgpA==
Date:   Fri, 4 Mar 2022 09:33:01 +0000
Message-ID: <PH0PR04MB7416200144C44EE3FDE865479B059@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-13-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3300864-34a1-4ed9-97c5-08d9fdc1fa1d
x-ms-traffictypediagnostic: BN8PR04MB6305:EE_
x-microsoft-antispam-prvs: <BN8PR04MB63055902A3F5BC72E0FC012C9B059@BN8PR04MB6305.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/zrlsfYvCAnr95W2LISMmR74ccuOb4PS1exfG16cPFHTrVdVocJ00klrL38Yng6oyPZHH0lil/tixZfL5GBeWmyL9v7Ucbiq8+H5P22n7HmC6tTjuFyWCDk6/K9FXpCZv0dF6Aeoyz5gP3e0ACsB2BcwrmewfLSHCXvq8m4sreZDwQakxmz1k3eTkwBnY5A9UzLKXUAb02YrL5HUJMeU3lNJXrUtg8VLUHYZKb4ZIhF1D0VxVWeiZ0AKAqe6GGPii3WlFnj2Px9w1P6cLA2kCcvDAG5abxIYmdlUPVcSD6Mbyazwga4EmWenKiSK0wTT7Yw/oRvCUmQyO+KaMFbgnCt6Gy9mgrdS1ZzgI5+ozPQWHR9tYbpiys+HfdxGB0W9pJxLz0XSPal6DEZDqbgefSKr/nD2yiVnZJxVtI4DefVb65Derq6G9ryX5aMblaMcH65chQe8Q36ywgGnNgG2kqSWcVJeW673H3SMe8dG5td5XURUNQ86P6I0iDRliAl1yV2J654zQ9BExKuRm8HVoj4avLi80q44dxKaqj2vsJWTT3IJCqYpYjgSwsDde0yVQ+rOBGeo3d/ifvZfsXQbOJ5Es5c6Lg7c42y8+/v4nrABFSki2A/Tz5nn8OWZ5SM+8gtKmzSqa44wWzsN8wiFV4Tgor0wNZ6UePzCvkghoJ4RPULWuaEPBePWekX9NzUZ+Y2B6JrJ/YootaVHaG9Ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(5660300002)(4270600006)(66476007)(6506007)(4326008)(8676002)(64756008)(52536014)(122000001)(7696005)(33656002)(66446008)(8936002)(110136005)(38100700002)(82960400001)(508600001)(186003)(558084003)(71200400001)(76116006)(316002)(91956017)(86362001)(66556008)(66946007)(19618925003)(38070700005)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?leLpwSb3/VsJhHTNn9Se8ssKMThB/1PoVafcO1ei7GE3R8ZHBafTM5aajkDy?=
 =?us-ascii?Q?IaSLwhohUgqng2lRSwLv8cW+QfPhbZPoHssZNL6WS8+2UxOJpcyEGOCDmWHL?=
 =?us-ascii?Q?7OWQbehJcC4m+RQOMr3ihxY4jGWgdNncZF3JWCr4TeMJH8meOarGCNln6nnk?=
 =?us-ascii?Q?w+p8wpT1VAtOtTvkFJAXJrExMDrB/rv7a51SJJYg3gV3+JMxXDQdgZjvbowI?=
 =?us-ascii?Q?powMMCapowaRw4Hf3TbiL5wGFB0iT+OcYN2tQPOmsDeqVSdtDd5aEi8OszuW?=
 =?us-ascii?Q?5eXvPnwDnT7jSSc4VUScQLyRVZOUjsSzdVTOyRhDyHEwi8pxGQAmCj6mGTJJ?=
 =?us-ascii?Q?ttXT6BSS3azsBIgRk6wW0CnN6Os7KiWGc35oQESWluNAYpTY7+YApolcFxfZ?=
 =?us-ascii?Q?X+de+MugwacfQJlYDa3M03JGWbB2JX69yZVIGtiWGKpLsv42jXnQqI4jGTKa?=
 =?us-ascii?Q?R9XIB4IMMrTvIEL+AY1x1Yy8b5lw/HDP8/fhVdZp5M8fS5uzSWy8OZrAOgRh?=
 =?us-ascii?Q?ywBgQhFXtKive54IwyPXdOGquhpBdEInImBVDL9BIQ99Gsnbr0tR9+NVeYa0?=
 =?us-ascii?Q?JqAJl5jJpT7Zof0/p3EANe0E4FMqbzldj71ylLbw/fh7Rutzvls1zDBIQA3q?=
 =?us-ascii?Q?/ZQNIchXQY/3Xq/WYcsJlMjJwo5w+q1q1sD4fDHo4ffDlF3xGVk5du6+DNe7?=
 =?us-ascii?Q?ZnekXBlP68Tt2VBwUdeHAP324OuXr2tF+oK6cqEbS/PBYCLaUnXes52ndib4?=
 =?us-ascii?Q?liUtLfOj9dsAbbHZTO/9vAcQ8SNqqeXQ9ZbvU6LMzoi9FqXiYzLFda9QlYGP?=
 =?us-ascii?Q?QEHP9vsrrKhhdqieUD3PLpLKXoooPVli9NnScYo/0F97sbmKifGT1QHEPoua?=
 =?us-ascii?Q?J66lOwlrh0ncCVVExfvpAWscIZQWmiqLl/WRt0iWjAomV4DCCX3g6J3fVSgi?=
 =?us-ascii?Q?kascmk62l+xhcSjBGhP90YUc/+T6ZI0sAikH1uCCo2kPUp3/NF+1jay8/ojg?=
 =?us-ascii?Q?qD8gIoNEvG6CvgaSTEP/69afPkJgNsP1bg6KaMj9rK8VhX+JJhsOuCgooW1o?=
 =?us-ascii?Q?wirVFdpmo5/5Tk/tf6gCY/UbpW8N89IFGN/IWJwBAacMOC91ekVVCjWiNH5T?=
 =?us-ascii?Q?7GS0ys27gFMRC/dGgxBXU2dKfi8C/SO9Kx6ndEHmRL//wrYl2Ly7PaiCLSgW?=
 =?us-ascii?Q?+2feKenxOND95ooTnl7B5mXUciGIObGdfU7Vxdc9pOlB0ggYNTyMR67xMKvd?=
 =?us-ascii?Q?U1LAseu+slAji4M5p/cqM+f+fALeabp3Q+XMPygLwX3UXAvHU3pUH0fc0vK5?=
 =?us-ascii?Q?p1EXd2vn+La679sv56RgdjkjfK4uTGOXZ1mmLY3+469q6oQeFJCqJACkeFzn?=
 =?us-ascii?Q?UaM1mKwYbAQHbGrGv3q7+1SQZG9Xk90Kzzr9YiJSEtnFd/jKPIOH8Bp1O4MU?=
 =?us-ascii?Q?r+a/+zgAHhD+Ncw+dy7mFpPeLss4mbcN8/cgxsvA5p3f2hJK+zw7x32mhtLM?=
 =?us-ascii?Q?EMuYzrtosQRtKNo28wpKLG7H+0maI0J4pyUtHiomeAmO7wpmhjF1w9mYf4Fs?=
 =?us-ascii?Q?uqQBP94TCgCHPwa8v5BHDOwqrQ0tIUndA2+mcHdJFkziTkdxGnLw8D18dijS?=
 =?us-ascii?Q?cgIPxc1wW3/PtLB7OAmUMtOm/9hSSFYTXbmPZQNzrSx+QYzXGhCApWQumpWi?=
 =?us-ascii?Q?Q6kQ7OKx0SQHXpXOVixy+zEPOzC1ml9rV8DAr1l5hLJLHAqIcelAfZfjNWIh?=
 =?us-ascii?Q?zWM7FeMNVJKQ7611GcEWD2WSgyZ9NJs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3300864-34a1-4ed9-97c5-08d9fdc1fa1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:33:01.4988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +nC/OukkjcA6V80YQsPMY7RMLk/D8TNTl1yXIlfwuBRE8msdBBgj7PJCUafTtNaR/e+grGMyoTk/W5TUp76ICMEz+DPWvBMHpRRs1NyX+0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6305
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
