Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704CFC636CD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 04:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjBGEHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 23:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjBGEHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 23:07:44 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204CE55B9;
        Mon,  6 Feb 2023 20:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675742863; x=1707278863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7VNkufka+O6IpPqL6NhMsMn8e/zQbBwNE+VjWZ5Gnig=;
  b=Jb5UFI4keKuVl89LLm9GxW1SUUSG5+8hE70Pdu6/o+dbWxzBxGqLxlYR
   MuRtaSEo2u4F9CBO97KC2g5IlaHK9rZn05lRt8TXbIYWQVZeUtkWJ1rMr
   M+6QicQ0nj91nzTiXLpddJZgkKPyKMz2X69VDVIXOQCDZJL7GNMmua4GQ
   lPvlor1Is9G19al9vC1hyY4vgiYEoa9bfG/Mk7A4YbHzyd1N6jocuDOeK
   5DFkVr0fGXqJudaBYDiZZcM5ukyathg2gsNUKZ+TarWF1ysOYHHe9n1IC
   4P2Zl/mzM6k7rVr4eznepuqOqiY98F9zrxDxL9yXyXDXM8n4tBp1hqiZy
   w==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="222715000"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 12:07:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmG9/VJhsCkbauWR+giumh8CHeWyJEQwzsg8yF/bk9nu3ksaflxiD29DQFcRBYxzGTRYIADZ/jJd5+Grz0pH9ZRMCctvjDQlu6JrDDcSyaxp8ygZ3+5Bl3cnvAMAFj2EoTQk6ARL0qOOHp2H7Ahzs8qq7c+QNggFnrpZVGiPy8B5hP5N/7eSh6/M+rNw503zplLYJwy4fWEnxSoZv93IugZahE5HdNWkJVIYvRACPuvaol1yYcHhMbUbKWF4UjsigdVJcVMq2bvP613JW4X0qKOmbrPJyvoj4RZ9xz/AEySnje6ob8bfojx47JkMjJQL1UiurtRgpyrWSQklYjrXYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VNkufka+O6IpPqL6NhMsMn8e/zQbBwNE+VjWZ5Gnig=;
 b=ch7VWO4iTw+MhMm3D6GQpV5+0yV3rK/FhQNbCw40Jzp69TPtxjcK3SgZe0zE3s+bznJTOyIrCNVDkL4ctia3xYHEXHV2loqFM8SYPkL7yXYpKykk1roKMbAY6wzrP2AUQxX6yo1jJmLCg8URNXMjFPpX5M59aDIKizvBccNSkI4JGSkdvOwwmtnOtr2gm2Hzy6NrS+HrAa7V6WMOyImdkxZHGjwh59g7AacGl5XyIu58B4vTS1tKbrguhgHsIswfbtB6ZVD6xIZIU+ZE9lBbWSEdyyXkxlTNKQ17tunzKIGYYdfQtoTLGSO7IU8Pf2P5iOkrlf524rZu5K3RrEvKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VNkufka+O6IpPqL6NhMsMn8e/zQbBwNE+VjWZ5Gnig=;
 b=EVipzvt4D2T0O+o5o7PgDdZEfexsLSSgO3+JFdLuTGNmV/5i81+AysR0OwriZ3eOh/wNP3NW9sl+Ix8rVULW52QfJPlcA0n8gzK+lBLpQMfnTVfFV69HWfAJFsSGC7ZAljhvHf/zdR6oDUxdpANbRBOzGZZy0z2TxOdRTQAeg1s=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SN6PR04MB4238.namprd04.prod.outlook.com (2603:10b6:805:2c::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.31; Tue, 7 Feb 2023 04:07:38 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa%5]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 04:07:38 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Hannes Reinecke <hare@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v6.1
Thread-Topic: blktests failures with v6.1
Thread-Index: AQHZFoocnkF/69AeD02U/IcKNzVbOK57EfiAgEa2VICAAGIyAIAA+9kA
Date:   Tue, 7 Feb 2023 04:07:38 +0000
Message-ID: <20230207040736.xm7myrpsmrrcx4dm@shindev>
References: <20221223045041.dl6ivxgo25eiwy33@shindev>
 <Y6VXjztUUz7GFmAW@infradead.org>
 <aaf09ea1-9cf0-0620-2c52-7298bb3409fe@nvidia.com>
 <855bd863-270f-b69d-0aca-319773af35a8@suse.de>
In-Reply-To: <855bd863-270f-b69d-0aca-319773af35a8@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SN6PR04MB4238:EE_
x-ms-office365-filtering-correlation-id: 043970ec-6fbf-4164-aae0-08db08c0d9ac
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: itWnkyuw2EZKHztjEfSdtsSVQM8eRTk+oAWkBIRk4/Y6g48FNtFLNQ3ofCcW3Zw2N9RVYVkJyQeRaoeuISpZxpjx0udWNBC8Wc0jlD66m6GaAfA+PEjahHQ+8Cm89rUaZpvZD6Qmzrv/UqmHHRIXSf/UWAYZ/DxocTUTFtC/TEBYHlgg/P6VYml7RUYicRcZdW/pp9mTFu2p2GnoihYpuzjs3ZaBnuDDKjrFrf5ctiaazGKjvUYCvN95siNSgkv+iZR/6SS/6hXjyR1p/+u+LNm34PZlSb46fYPGuaDGI7S3u+JmB/clRAtPzALSut1Ziad2z2uswnQwOHxarwJGgNiXa+k9s+Z+9cu3u4+th399vh+YLqqR6uWnh7+t5Gd+JBTI+yDIElAJZL+PuD/aDncu4tHso/wH4KtJRiiIvwp+wHH8x0nAejn/sfqXA/+QGRwZG+uwgcNnW29Jjt0/B0TKD4UR0tU8XJgq/A3ccHj5jPmewbDn8tloFhRrJI3xBMWEWDkgAaBErhLPk36gHbS71uVuNo27hISFc7iOdI9cNHvqusNrMCFtgqoURTznqt8oEGa3AxQDp0gvNIYb32ZXUzVDldDCAFfOESz3asYwDb2DRlg5Vke55eeu1VFiS8+eWFrdPjHcS2CEZutpEDaGlOvoNBmDfLfYiM8UgkzpNFrOv63OFHrKYbT440oola/4DbfMDLPM9jtUlB+5mn8l9S8Byv+7WJ3/DaBDUu0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199018)(966005)(6486002)(478600001)(33716001)(44832011)(2906002)(5660300002)(86362001)(38070700005)(316002)(41300700001)(66946007)(4326008)(64756008)(66556008)(6916009)(66446008)(8676002)(66476007)(91956017)(76116006)(8936002)(558084003)(54906003)(71200400001)(38100700002)(6506007)(26005)(186003)(6512007)(9686003)(82960400001)(122000001)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?24fPtMqoY7R3kmhP11ZvFJ9gQiPKuJokfN7sJhycaclUt8/twX0QqXdb748g?=
 =?us-ascii?Q?z3Kh1TZvVILjzdIAhPGUCC7uD34CkW3oXVXhRYzJdIRS8DL0pC7b3lPsgpkP?=
 =?us-ascii?Q?KWZsKuO+yVq8M0g94OsCitOoXjZmD8krTrgwa3eoWNtx2yKtMIauIh/Ol96Y?=
 =?us-ascii?Q?1K5pNugMhL9ixzZQDI3q7TgjRD6p+sMz2X9547VjHdzuTZ+2WTU5WfXQAqHr?=
 =?us-ascii?Q?Yyl3vUaeXCYEBN6h+ST9AW22MHKeoT6cpRuQtbTC9mM2w2yB6gg8m4hjtaIO?=
 =?us-ascii?Q?HK6d7061q4CAtTQMyj9o0I6B4y7H79v7xk9YCPZsLBV5logFF32bbKyaz6I2?=
 =?us-ascii?Q?dJRZ3o2PtX9A6oJfpMrjWX+enND5JURcQDxNFZMBjCoYaqofWyqnnXfUnga1?=
 =?us-ascii?Q?dlRHBf4OC3xgbefs/HjOMfmZIoTXfb0l6CkA2K4MOpuCDkfsrr2W7Fy1mvC7?=
 =?us-ascii?Q?2n7jrH7RovlwTbScCSUvsaVQNpDQyL7xp76mkwdL62E0wI4qCF2GhrESS4BP?=
 =?us-ascii?Q?RCX5Qm8bqEmszStlVXnUK+OkX4alzVWu0kAT2OwjWfDMG6KlnyRnn2QqVCQa?=
 =?us-ascii?Q?EYY+DQxnz8TqpaHFuJuRuoGBJsW4hUkhkcgJJRZ+lu31HLhHLlTT2g+Vtwps?=
 =?us-ascii?Q?Z/7GkKjVUzPM44ex2b+VTY/3AWU6FXkIcl5MBhQoySyUTQhbvxL70FPg4LiW?=
 =?us-ascii?Q?CDO2r3Ti5UKWwtTC2hyG2skA1/SCgVq7iS6CKx1z3x+Edtb/W3oT6ybEpndF?=
 =?us-ascii?Q?5PBuN3FDEWc4DNEy8a6nRw8YuRKX3kCplFXFfn3SnZD0to3C8XMi3SZ25jHh?=
 =?us-ascii?Q?lkAlWhtO2seyWTRal/RLawtsBBFJeDZseUhS8pTEgx+cfn1SbbSwd4Noq6Ol?=
 =?us-ascii?Q?y84ocepJ1EOj0MBYNooW3twaem0NmJvFvbPIdhkuJNyt6INxVS8UAoG5S4KE?=
 =?us-ascii?Q?kOQXj5/5kpxn4IkxqRQdAM2fzXGk+WQQrvt4dkdFc2t1W0ejjjxhREMs//JU?=
 =?us-ascii?Q?HyV+N9dexz1AlT71TlzcjXOGlXClRGk4p4JRR4B0S9A/M7dr/VAvIjBYMi2+?=
 =?us-ascii?Q?e1UxleaNAWefrZCEbrmP2SOfUs28agjecQctyuspP6bedMFntc00d3bt2SlD?=
 =?us-ascii?Q?yr6GgO64vHZKV+avQJGQYFljUd5xOs5XzkCJkln9PPUOzqBVlv+bEVpz5aOP?=
 =?us-ascii?Q?7cKEGACutnj7CDeHFCMTcQk3L6cKwPRrCE9Zw0K5Y3ah55Rab0ACao8WL31K?=
 =?us-ascii?Q?euKtQU6FR1i7MkfRMvmE0mRmJPrVfMOTTflO2TtNdRhiyA82PgZwOKramRs0?=
 =?us-ascii?Q?YUKQ/GzzYnRziTD5oTQkvRYj4DGSJ5ST3s3Hes+d9oxWUZ0zmg+5fS9+s1EF?=
 =?us-ascii?Q?En7NdCIZLJuj832dIJO+s0D4GNJ/IsSrCD9SMfAePo2BDfLJ5DdOj9eS4HK8?=
 =?us-ascii?Q?JiWm4t86yJl5hV9tySUerPbiMJpwXIPG94Mzi1R0bw1pgWCEi9GzZCErWyul?=
 =?us-ascii?Q?UKPd2sEWTPahIlH+baBpHxgmp85fkoVNE8XLzrboYBZ+Zbovr3kwA0IzU3YC?=
 =?us-ascii?Q?PTETxjySzNiZv0JgujZsyq0S1tG6ijk1cDBBBHTq6vl9gfHMEFN9n40gvG1x?=
 =?us-ascii?Q?jQFS7jgMBE6WIRMOt9zHgjU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28B52EAC02021E4FB1B8865471381A2E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?DLmYKbZRq9ZCV9MKaD34VVtSx9P/PwMNkk+Z1xG/tv8lS2tEBa29BAaRSEeh?=
 =?us-ascii?Q?ZtLCXqIoIqBRSq7tYihPpgHh5fraywUYmcikABjqDgIQPpSQygzAP/fl0/BR?=
 =?us-ascii?Q?3+bjYs+LTjCXeJvWm9C7jLCob5RR6UMFK+2yLthwq2NptzLzyZkyMfegQPes?=
 =?us-ascii?Q?AdZnGiyxvku3VFVTG9kfQEBiWdcSMUkLfSvF4IPayjt/3RsZLyqQrpiYQOPO?=
 =?us-ascii?Q?hW7fO+QC+2J5d6XVBNrCUKZfizsJ9pJbf9UT6YRmmiTXLm8TI9Q2jcBkYPCN?=
 =?us-ascii?Q?DcT56wjmkxMhktct2Fnu3JpYLEQL1CrpkrfbbSypBWZAL5E5wNo4IY3gVVcE?=
 =?us-ascii?Q?eRAhtvhLZKTxT6Ly4v2JyXtH2AOlx9aMyMVqf9vuEI1xgSIjr02tXXp+RDeJ?=
 =?us-ascii?Q?CWptmvX8JFCskCJnc6FzXozCK8zpbD9KMA0HDA9NiLh8vcHuMebz5gnEC4lM?=
 =?us-ascii?Q?23l9rVfiFvoSG+1yuiALCAjyiyL4hkLjs1Mbnl7qnNFEnUuDvnV32z/HiGpg?=
 =?us-ascii?Q?ZakPWJ5hwc+jpkJQg75tnTnqAj6c8vFon6GPeuWvj1EXmTh5c6kcWiepDpr7?=
 =?us-ascii?Q?jyeO4nhvrvge4w1KOBGgPo1szbZHjA77UezfCTh/hHPBXHWGjoY9Cj+Cn+M/?=
 =?us-ascii?Q?pj1hRjra+JAgli9bDAyi5+3J0+vogtLKiB/Qs0VbZaEenLv59vd0V1C/exib?=
 =?us-ascii?Q?FTd4HROhyOECRZ/BlZcw3dcXTOiuZ/aLEnFIS+eHykg93fAByV5O6OoQA7s5?=
 =?us-ascii?Q?KPufNT18pDA22HNAUSkeKqOOK1vP8O6D836cZA/TTpScgPUP/OsXn5m4WMss?=
 =?us-ascii?Q?cTUD/zxJnajt8rwQ163N9iN9Jts/CKwCs4rtHKks62KhH2eb4ID8/nIxucKA?=
 =?us-ascii?Q?vA/8fC8V1cSuhSIcc79yh1rn5R20P9qJ4FD7cn9cxLLJwh7NHo9xjo2ofkd+?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 043970ec-6fbf-4164-aae0-08db08c0d9ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 04:07:38.1303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cy2PZ9I7e7NzI0ojSTrYkv9Ji+Um5kUeRUgeJk5V0mxHgnC1ndUT1xcUaY77o5Nv1D2T0gmnb/CYPhwLb52FNyUZSgJiKOKpSoYbAvVU7C4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4238
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Feb 06, 2023 / 14:06, Hannes Reinecke wrote:
[...]
> I'll be sending a patch for blktests.

The patch has got merged [1]. I'm happy to see them fixed :)
Thank you Hannes, Christoph and Chaitanya.

[1] https://github.com/osandov/blktests/pull/111

--=20
Shin'ichiro Kawasaki=
