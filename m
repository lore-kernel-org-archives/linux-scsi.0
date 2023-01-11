Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65796C5479D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 14:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbjAKOlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 09:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbjAKOlI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 09:41:08 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82915599;
        Wed, 11 Jan 2023 06:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673447941; x=1704983941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YIrfLu2jFkZQf9qp2PFLagwS3+JxFEOeWs90kSYFFno=;
  b=LU/wpLTNN5KF/raEpQlW8vRJSUeGFDoBEULFoZYe/FgKl4UwL3fzyYy8
   TH31UbF+nHKS7sjIYIXyKUSwyaTtCGIbaiuCB2YblvGen4p5MODJt96Wv
   OyaH3YFYeFu2HFR6GZ2/AhAhSmmawYyn/gkXaIreWC+sB1pR1urwySQ79
   +n2TxTgdTIIWJJYv1YWq6BlqyPoGLL+rapiQu8tacchgzL9ubsI0tUM0L
   Ax12nQwhkdJym1ZrLSh2bvUhxOy7jgoRfesdn/njC0mByZDLbaD8j6F1B
   i3AZmKpoif4ss+eXvU708zqdcXJfEzKLqdd7Us1iSO3uaF3NlC2h8kiez
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,317,1665417600"; 
   d="scan'208";a="324837319"
Received: from mail-bn8nam04lp2049.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.49])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2023 22:38:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P32g1SqNWXgprpRGA62rxk0M4DYrylZEoPKEC3yMYf5ot8izcJ+VLYHwv6SEtiJhMVV3MfthHbzlstHNboW4zG4JPWC1Diw1bVxIiIXKMvfWSwLwZmoZw6cVwPEo2kXtUL784UbLLySFXXqnRcmIKgs1TTa3AoBY4m/AVmvvx6yGq9kf89ixxy/oxyaQCFKT0b1OHG+627VCwAUzisOKWcRQu3wqHhh0Oa6D5EjMpW6HPLuXA/ISIMC8gPcy114FnTsNlurVw014quSKCH2pDw52BXWm/7bWwrv8NAaKYeeLPLl97stjvlYz35ezzuNoZMPBQcB58MhMdUVObUCE5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfA/bO/uFO5QisOf7JuL16e6nhpq2Uv7ZUpng/5DK90=;
 b=m3ToDgICOyROrrsoCYlRuUHmLQLRW1cCgHbkoZ+/G1/5CvdUMP+iR+EzQyDyEAHQNRWVXLDflQV2tFR1JSy3mlRNwWOa1+qOchhnSo8KsYXtoFZGKcFVpKvLBSxLnBselvlaWPedRLTxYMe+GsxGVFKHTp5bVguO1qPXEMB+CEqfPiRG/AXTizEATwyJ2ngt9WJcpq89ODA1ocat2k4bTZFKHhkizFqZ4jdGsUhwiV1gkifwbJTsRM8/2PNhBaA424oFKRCX9JsfR78WxpOCvqvuCAUgJ9FOop9dpiP3rRPMTEWHO6Nji9mQjAZww9pDJ0aRAI/2ejOmcIPT/vH3nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfA/bO/uFO5QisOf7JuL16e6nhpq2Uv7ZUpng/5DK90=;
 b=XLZEmZEXvWI7knETqBlcYxxzs0QEXqK4CkrwO9yRR8rW6tkv0ofYqrhNsqtyTaTP6Gtm9hktO6XdGRwFpZRzzVllPtfh2tlAbldzKlrL4QxPKelWkERu3d28qIBYC/KIp/KelOELq3kIcFigzlVLaBLCVwrp4cq/EDyZZt/sfos=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH0PR04MB8401.namprd04.prod.outlook.com (2603:10b6:510:f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 14:38:56 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 14:38:56 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: SG_IO ioctl regression
Thread-Topic: SG_IO ioctl regression
Thread-Index: AQHZJcpv4zcdEFqMEkWWhhQqiPkdrA==
Date:   Wed, 11 Jan 2023 14:38:56 +0000
Message-ID: <Y77J/w0gf2nIDMd/@x1-carbon>
References: <20230105190741.2405013-6-kbuschmeta!com>
In-Reply-To: <20230105190741.2405013-6-kbuschmeta!com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH0PR04MB8401:EE_
x-ms-office365-filtering-correlation-id: 48c47792-1011-4050-f133-08daf3e191d4
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A5T2IF+iAQ6p7YwvYN3nwO/YRrsdEk2KLtjXoAJPvL5cR6xIPb/gQoAJqRFXh4kD2ocMEIyKmMTnFdg0w+OTHWmZMVY9IdoZeDeotbIXojQfSkZvyZm7bIqILScmntEDFBtHkveSwT4GX+US9+heBBzh2WSFBFbe26TsohqzNimnIWyXLwmfZ5VtncgsnAGMh2y6apoTYXBNfqKbrQtEE3Tq3M32vmjrMTmbBqxTrTcRo2UqCxLI3ld0Ms22vkYBpI4SVHJsFlMSHJsa0YquGpp3k1rfVaqTRKEuOK20LrE8iPlKS5Cez6C2QsfJtgPY+0/wJ1AuaRm5dfmN0Lf828PnGKP8BZjH0CJ+Lh7kcbYviu51SYmzZjQts2yveTXKyPxA/qOLbE8iB8PvI3hhhAhwnn1alnjEWZHsSB+7cmcBGlLqIf0t8mP8ceLfjP6JfqlZuo331ETePLnKCpngaX6aWXrRUgKKW4GDJXubhc5ZE2/pNkIV+X7qCBhSpwoPwmj09QrJVOQE0Tg8o0LI69+onn/TOxat5njaFW5aQjqczcIFS7hsCCsaeoKu2+xBzcZS2aYrG9KAm/f1RSmFf7KEiSWY3wDjOVUV44Qe/AwcvT1NSAGrCglyro8BE5n4N3B7EHVe2lASXLj0lvAxLzGMEJ9N2QGreryJa8qtUXFC/WeSTGNDFhnTOx9sMeJnENhdaYWDeDp79t0aEfRu4SgglSq7k7s91ZEK4uNayjc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(6506007)(478600001)(82960400001)(122000001)(38100700002)(2906002)(6486002)(9686003)(26005)(33716001)(71200400001)(186003)(5660300002)(316002)(8936002)(86362001)(83380400001)(38070700005)(6512007)(66476007)(64756008)(8676002)(7116003)(41300700001)(6916009)(76116006)(66446008)(4326008)(66946007)(54906003)(91956017)(66556008)(299355004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TZfrDYkW1RUGQOoXYSiLJLQOpXpa72syWki0owJb4/uej4zUfnh7wxkBdIqp?=
 =?us-ascii?Q?+j4XH5NVmY/w9xQXEx2binLhDGIOnA08lW8N3eL3xm5S3IG329oM2NLu5b5N?=
 =?us-ascii?Q?8O/Oky86MtCZ9oebfUX3JdW6e9O7ppKoFV4cZ09rRy/PI+QUgKwrmGg014x8?=
 =?us-ascii?Q?1w+wWE2kqLLB8ZbChJ81mQywFqBLkMgJP7Hv8G1sZ9+bv2NhDR2TzJ1VPaLk?=
 =?us-ascii?Q?Lhr2YuMhSEx9vuGxo6ZthCNgB1snqjmeICFO1ao8asxOW1MHvzE5Q3Ird4OS?=
 =?us-ascii?Q?Bp8OdFJ4pyBcTm/j9o4M80kNhmSevoFDM6P/n7/FLADYWejRzSqFyTO6Sx6r?=
 =?us-ascii?Q?zyaxjx+ejo3JWEMsIa8g+yZFNLnQ8s+DS3Myk8DuBhKDNn21wBRc8zyUzvvg?=
 =?us-ascii?Q?NWqBkbudLWGK3w5opC0QWjjizjKWfzBTqDDFLkiL1Gu1QRf7sA5GNdjOWB2L?=
 =?us-ascii?Q?AduhaTg7Gc/MkO21e9GkT57tJn5US9q9dG2QU7eoY91Oaf0rSJh/wZNsRiy/?=
 =?us-ascii?Q?cjwIBFxfqMGPkHImP4EF1l46MX9zhxEVqn+h/bu6HxwvueGiKw7w3dsr9jpx?=
 =?us-ascii?Q?GtJojdmVfgjUAQoCtTjY5inUb2qWjc/n7/izZYhT7VyheDZDM5qCghgGYA/R?=
 =?us-ascii?Q?CMetJ8sNQqzdUlyLt8UtvyNf+eSmjj9vlGmHVR28DT64YkE3JPQsTjiG+cKs?=
 =?us-ascii?Q?CQzAuAmabtNrM/GW1ghv/9z2cnj6dwwEnUAdgkI78ra70UZ4Z9shsjsX86r6?=
 =?us-ascii?Q?S8yS/Twj49ClbhmJwii9Gbm1/egq2/58v34KToGCfJ0Gaf1tn6wToK/WD+GH?=
 =?us-ascii?Q?wzclHz2xsGmJ/33GvaDKmQuzT6qg5EQqQKtIXU+99pwSjR4OvLCmpbW0yFRc?=
 =?us-ascii?Q?iFdUqdZRHEQRZuONllVVOwh2/asCie5F5H1auPfAhkPUBN+DUxsKaFKt604q?=
 =?us-ascii?Q?yehxTo7Oidj4d1+6PWfPcaYFJr3YZiexQ5m5UDL0ryhrpAX8jIRUI73FHF9+?=
 =?us-ascii?Q?zD77VsnSmBQIZuEHpjIaN4YK2bqhqpvf8el/BUeKc7OHyMkWZ/jvEA5/IQ7W?=
 =?us-ascii?Q?VpjPS7C3stR5yuX71Xhw5PtR7WC1K2/QT0RzDQJLjI4I1bm7utAUaRHPpscw?=
 =?us-ascii?Q?YZ3r6btikChbcc7e0RiNLbxYNCgWWRGByF6mph7084NzR7GH+Oa8SPeiQB3v?=
 =?us-ascii?Q?Ez7vWReM82vgINbrKs/7+xFQJ0T7dw/UWeEluuJEGZ0kQLGKL8V2rfgWkSvH?=
 =?us-ascii?Q?X4nLGcjMXqSjSv5DxfIPTS3OoEKY/qWY1x9zEJ8UeWjlDD1y/1etDmeLFPIl?=
 =?us-ascii?Q?CYGuU5hh/K/UkeKbhMV6hCOj98S4A049K9eBfdhOWzRdYYVnvY2twIhcWOU+?=
 =?us-ascii?Q?zYGjYQUhciaIRWlkxMqSpU7riN9otgoyfu53e+kn6keO+f1VvV/EhiNrssrz?=
 =?us-ascii?Q?W82ok3a6+WDBmyC2wfn5jbLS8yO3nN/F7vM63XXMUKmHQ2OnLkfIrLKWE1h3?=
 =?us-ascii?Q?JebczGbSsHzVb6t35UkGy/IgATP14+cf0760U2tKEhz81hEdxPywnrXsp3kU?=
 =?us-ascii?Q?PzrcC2aRFrnkMokWdJEtE0bgETLHIhEncNTfB3ruWRrQvEqV3tr7tW4pdARL?=
 =?us-ascii?Q?yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4CF87234C7AFF4A803F034892C703D7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZAO4sL/mIzQo4GVkRK0nTTT884NkxKuKNxeQn9Dp0oU8li//NgrP+ngTu6dY3xEaeoU1aBVrzRoP8bI3HqILgSO4LdtZe2/ATDV96JrqnGaRp4KHFH62nU5pwjgFHXJOZ14xe+ffvY6H75T74mC+M7BStMPln1mIhoqF6ECDUuvGRxcr+60WZMLGQisBgV5dnfAi0d4njkNYles0qHzYFlNjTivAX3o595ED6qTCfGqRo0Rpf8pqKgCweXeQH+Ktoi/zNJGEr7rT/2eyWydMLRMyvVJltFuQi8h3fZ9qN+gITGyHzLoCKzBz5lgE4KS9tsJOQ3wdEYw5QtiFA6egvvZPRCvg27D5ZWObAt1CvJz99XaN0uwHI41J7cqjKRC9PRzEdN4sl0mKcHxTTRQRSBuJWas+qdCIr4Yn7Mo3g+Q5+b+yMXxfUXv4geC1inPnU8SBLizO2r47q31FNNm2JMFahsBH3+nlQ3Yu3blHlwY3k4HAzj0RqBgLHT9ei8d+Sv0NDcewYIrBHez4X+gwaMaEtHb8Yb5fo+SRL3uxUBy+6H36YUkQo7D+BNG35xH3axZTtOuEjLoItnd9QmXa8VrQwiEJUh8pq4USqnEgYJpci5KMfkhKJpz3/+pQ/y5jZdPHyb6oiOEu13HAkLtGoG/qZFi5pdqE+pYaLfkU+kUd49xM+G5pZnDztjcGg1E7xXIDrCx0JWkb0XvNKdKCGPPiwPDL/d6KUk/mNtk3FsWaQoi88d4t4oFlmwkdKd4vQF+Bec69NhqDxGYY9PeuCtYLBp5RPphIJ+hfYtxoTMFgln8rWouEXH8dyz49ctr5jIZ6+DCMT8WXKKkb2cSkFkkoVu8A/dIJ8qmNDbpeoSQk5qiTLLGWaa3UGezLzIjl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c47792-1011-4050-f133-08daf3e191d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 14:38:56.5876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cdISaPjoPIA5S/SK8TpVSC9nuHMIvH0Ee17Zuznvb+Ch5+1cSWZvXhJ5qqYIWspTz81rDs6AFY/3EcKO+Z4QAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8401
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 05, 2023 at 07:07:34PM +0000, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
>
> This is more efficient that iter_iov.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  block/blk-map.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 19940c978c73b..4cf83eae9f2e8 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -641,7 +641,7 @@ int blk_rq_map_user_iov(struct request_queue *q, stru=
=3D
> ct request *rq,
>		copy =3D3D true;
>	else if (iov_iter_is_bvec(iter))
>		map_bvec =3D3D true;
> -	else if (!iter_is_iovec(iter))
> +	else if (!user_backed_iter(iter))
>		copy =3D3D true;
>	else if (queue_virt_boundary(q))
>		copy =3D3D queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
> @@ -682,9 +682,8 @@ int blk_rq_map_user(struct request_queue *q, struct r=
=3D
> equest *rq,
>		    struct rq_map_data *map_data, void __user *ubuf,
>		    unsigned long len, gfp_t gfp_mask)
>  {
> -	struct iovec iov;
>	struct iov_iter i;
> -	int ret =3D3D import_single_range(rq_data_dir(rq), ubuf, len, &iov, &i)=
;
> +	int ret =3D3D import_ubuf(rq_data_dir(rq), ubuf, len, &i);
> =3D20
>	if (unlikely(ret < 0))
>		return ret;
> --=3D20
> 2.30.2
>
>
> --

Hello Keith,


It appears that this commit breaks SG_IO ioctl.

A git bisect returned the following commit:

commit a696647a3b58c7a2dddd6eabfc824be826613211
Author: Keith Busch <kbusch@kernel.org>
Date:   Thu Jan 5 11:07:34 2023 -0800

    block: use iter_ubuf for single range

    This is more efficient than iter_iov.

    Signed-off-by: Keith Busch <kbusch@kernel.org>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

 block/blk-map.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)



When using linux-next tag next-20230111 :

$ sudo sg_inq /dev/sg0
sg_inq failed: Bad address


If I simply revert your commit
a696647a3b58 ("block: use iter_ubuf for single range"),
things start working again:

$ sudo sg_inq /dev/sg0
standard INQUIRY:
  PQual=3D0  PDT=3D0  RMB=3D0  LU_CONG=3D0  hot_pluggable=3D0  version=3D0x=
05  [SPC-3]
  [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
  SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  [BQue=3D0]
  EncServ=3D0  MultiP=3D0  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D0
  [RelAdr=3D0]  WBus16=3D0  Sync=3D0  [Linked=3D0]  [TranDis=3D0]  CmdQue=
=3D1
  [SPI: Clocking=3D0x0  QAS=3D0  IUS=3D0]
    length=3D96 (0x60)   Peripheral device type: disk
 Vendor identification: ATA
 Product identification: QEMU HARDDISK
 Product revision level: 2.5+
 Unit serial number: QM00005


I'm quite surprised that we don't have any automated tests that
have caught/reported this already, as SG is quite heavily used.


Kind regards,
Niklas=
