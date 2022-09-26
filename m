Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FF1C6FA82
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 20:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiIZUxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiIZUxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 16:53:20 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B25AC3B4;
        Mon, 26 Sep 2022 13:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664225599; x=1695761599;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=FDLvNxHKQQfryIQugrNtnzZLIkk8Iq5Qo44e8Cc46DU=;
  b=mi1HSRWFwJvDcfBcRe2WTgIovuEJOmqrnP9/x/cmK+4JK+NJdpXYioQC
   LaI6HTEbrq55LQF5snXRbha9/t385G+OdsozEKrUyl89VB+hdxhxJCYQw
   5YVjk/HfIaQ7neAM63EQ2QdOTzQYtSGdWnUPKMVPUli7MCXcuRmzwo8Vs
   4yNcPnJEvVievwg6V7AVX/4uRrXbPbIAnlpdoVq8eXPskAL3BMDSb1Z4k
   4Ej/kWv75YgPeVLfcGx+sRmpTetpS6FbZf4Y+yMvRdadVQM91GD95eGUJ
   gceaq0wyyPAnIqeOs4v+4OZzP+0GzZlQ9oEqamcobSHBIbuLXApB3nGi5
   A==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="316601442"
Received: from mail-bn8nam04lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 04:53:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mggNwgR6j2etP0bijd9Ts4z33UnuFzZUhTMnKgiE0WgCP9yeo32/jR5b40j+uaAVOC+8nKApW/jkr/CJ8d2kpOtVNp0gNvoN9Km63poKkTu2Tg9hUlZUOeSGfIDdHtDONgAWU+IwyyMXWbnyYwv7sSkFYCynK18pMod4y+4fe8Y9+EBEddSgVDE+9J83UzMZ0k6MDXFRMnTTshD2CFt547I1u6O0lIoQLZzPEJX6QC33fDYSN5F6yF2mNGrP6Sk8EcE/+sVaOoLYfdRXyOX/fZ8MLMvEQm+HjxDRwUToffXXQ/7yYpO2qs57RJKkqi+IkV0FEq3IkC1ZDDSvXBlznA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgvixQu+OlVsMXEbCE0Llw3pcHLSLYN+vuIqTN8VcSE=;
 b=FyxGlqKxQUMvfzUreG49PtL3aehZI9C+9zwLWah1r6QwavCKxHtgJxPi9hwYVuwbS5nke8Gcby7yWII8inOcHg/WUG6kpDdbQvS0OuB4fauM04FrA/bOJ/m5Nb3pZ3mpULY0UAqIcuNMnWDfpy/RwsPnZ3c/GgMR6aUbT4GjThilvsklcKl/n7F3VtTJbMmeNPIF+B4+UWV0Myhg+d7UnHMcK+idQ/MUvHiwrQMEktOSnXI/iUv64AwngX1fVa/OFLIocMr6nCgnsYlvPJxG2xp5pke4sPUmLO0/gLNsgsPikCz3rxEgPBDjkElHMXvzx6HL1ESgvuhYAnmD3jJeUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgvixQu+OlVsMXEbCE0Llw3pcHLSLYN+vuIqTN8VcSE=;
 b=hvtDUXKKrYpUuhxCesbYG2lAHeiuPZe5jRt/vKXqr7mzW2h1AGoqRDkKlI/LOnF9cEI0pRdqPKC0H2ZJNx5ixP1Fhq2UoKa1XwHxtRgy+GhOyi4wkXbGZ2Ak5wv6+C7wOGqR7mfPVQVeSjGPgRohN4hrnBNuKVCvqzdtM+175As=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6469.namprd04.prod.outlook.com (2603:10b6:a03:1e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 20:53:04 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::c8bd:645f:364:f7aa]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::c8bd:645f:364:f7aa%5]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 20:53:04 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>
CC:     Hannes Reinecke <hare@suse.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/5] fetch sense data for ATA devices supporting sense
 reporting
Thread-Topic: [PATCH 0/5] fetch sense data for ATA devices supporting sense
 reporting
Thread-Index: AQHY0en4bdJsqn0DGU+3Tvk1+lB0Bg==
Date:   Mon, 26 Sep 2022 20:53:04 +0000
Message-ID: <20220926205257.601750-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.37.3
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6469:EE_
x-ms-office365-filtering-correlation-id: dc1b16e1-9902-4c33-24d1-08daa0011b5c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oVckXrOKg27Cfu78yTUAoeGW+IsWTQhwP6yoSG83MWtGKd52qitxZwtxBtJwTnQ31ZL8exDePlMLnV4JPF+VQSyAgelcDb+yMD7ydZecoK80pn4QlFbwKBKpynvo+fzdx4cep3Vrm+wDESjFPItZI7qOVOzksrs4C/qf14WgDkQpAvRlC+KVY1DiKBekr3A2f/i6bJ6sol+H9lldea0EtfsBDEZVKkIC6dFJ27WvG2UFCDApR7IeZjkZ+6REFnk/l7XcrbvQcyNTTpfs5ajV0cyb3LMfY86GFQba9d8YcF6S7a16PYghlJwXg76Yt/uKWdGHsS/rlFiX+TvnFkgrkWsLAAIyo5UEErpIrXYTRtlvT+DbwNDdHIg6s36Nt5e4a4JZk1IHLntv2e7Z6CkHOW86LQ89+Vu1a8JNesaKegHD4GoUJnv+5MvkwrszOFazG92xNF+cdDMuFlEUYXckTEcv8wIEZtjP6c7y+j9jRYQ1KRoTb7QhcwHmwvng/1bhEH5eok+izAshYnY1EBnRTRKRCbW3PIDQysZaGpV7eBr+piP7brPRqkEqg+bfQ98NyQhW+q09Zwq/nwVWZuCVLmZ/vK/+a0KCQjFKy3KApmKO3v0YOlakmvBzmfoDVD6JZmtuPPCU4m+7jp7g82cuLbI6lXdAkeQEXwar8D8OKfNosTaerP/ueHl+uNwTErGlN1FywZ8f2pyb7hvt0eDC71W9vgSR4CSey0BkH8lj6rdU4O4sfkj7y0MW+l1KP2/TTUPrEEkkADleVX0rwWIAWT711zfPeaEiToBfixQMoMI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(26005)(6506007)(5660300002)(8936002)(41300700001)(82960400001)(83380400001)(6512007)(122000001)(186003)(2616005)(1076003)(36756003)(38070700005)(2906002)(38100700002)(110136005)(316002)(6486002)(54906003)(966005)(71200400001)(4326008)(8676002)(76116006)(66446008)(66476007)(66556008)(91956017)(64756008)(66946007)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gEwsvvt+dhV4KR65PAFSZ9XIpEA1BUQxlugGh1qssmXdfDF9nBj/c1LM+g?=
 =?iso-8859-1?Q?HBME+lm0c9BPegnrQWjSRzUwv1tNzB1qC3CeHE5T/YH7aLlGE28fPPqrzz?=
 =?iso-8859-1?Q?kP8897K+NvvT4N8nQEP5HQGjaPMSXokgB/ICs9NQiRfN4DiaieG02eByZ9?=
 =?iso-8859-1?Q?jrnx270NCqYFWa2r0B8oPdyUok2GojxXkLkZoBdaENGPJ0u2R6N4DMErEa?=
 =?iso-8859-1?Q?C9K3xJxiwDUBkz67xymsM7pyY7fabKvH5V7KgHGR4Wm/KWRwio/iaPf8sM?=
 =?iso-8859-1?Q?uwLieHIcPS+QRuKHsKTtHVcdn7rAqr/K8hNvvOUeDJiBH52uWdMTXdcvgZ?=
 =?iso-8859-1?Q?BWqfh253qAsDQKWWrWAF/DYq/PrAOjTSTpFlnZFVT3EnDAUzycb4QZNHB7?=
 =?iso-8859-1?Q?2zuGMvsq4H7OjrnAuM7u4dLVQNOlLuWDyMLTXMGmJwpEM8oRYSbCP48F3T?=
 =?iso-8859-1?Q?go0R8XpdSFe/E39KM9xg9VlBsPPX+yZpCMaf7aqcT79SYxe/8aJocqyWV0?=
 =?iso-8859-1?Q?ZmXN5dpc/uQaWhYTOR4LamnOWMjGXepDnGFCNN+GpkEINJX/0uKKMXVmlA?=
 =?iso-8859-1?Q?ZYUIr4IaEfswFyl+11Odyc2plxfL4IOTOQT7EalUF7vqcFh6UxVAO95eNn?=
 =?iso-8859-1?Q?+nY6wQcD/XWk/i2Uy6e7gXiFd8xzj4PUnBrv30vVtPVhgyWSvuKsiFqfW+?=
 =?iso-8859-1?Q?me4vXquen50xhKYtZYLoYrYvMT+TEeOq33WpQvfYQlIy0vZ4XiZ0wL6eah?=
 =?iso-8859-1?Q?ry6rL1+RuQUmjUJGMkSpPepTQMNcpqC7WHnlNcz45GpNoZJw9tOl5goRtO?=
 =?iso-8859-1?Q?K+qTjqHGgx3iLFfoOpP2arNFzEUNZl4M2z8sHAl1YItBiAUOqwRs3v7q/i?=
 =?iso-8859-1?Q?5Ruh7LFiAG+lGI3suxT+GLovqyx5X3gxXAUS2e/C6amZd0exyVn4fu7G8Q?=
 =?iso-8859-1?Q?VLyJ7FC6W3wsnuxs7/YzhUYE9l6WmOzPbKCx5doLPyvPaRY4F3s/X5aeTy?=
 =?iso-8859-1?Q?uSThAHGB1lHx883ypdJ/2ahv2hIbqSzFv5Ho+mwc9G/1NkqVYgF057hQ7S?=
 =?iso-8859-1?Q?aEz6uB8b8hqVI8vZjAfQpRXnfa6NMgvyoyq725y2l7RG1uNNxEtRrrxcsz?=
 =?iso-8859-1?Q?AqQIpqdUpH8XehkXpKz0oF+ZuCxAr1ZZnfyU2+AdK97k5oRI4PJslRvRS5?=
 =?iso-8859-1?Q?L5ru4HXgxMsPAaS2Ru8DUWNWH9nG7g7vTTCeV+qjkKWmo6MlH0+3gxgh1e?=
 =?iso-8859-1?Q?FmC6YoQpt0yzKyWAqg/etOpfTMT+euKim6v4VyHxpf9+zaf58ueX6hOoe9?=
 =?iso-8859-1?Q?rFVrEmGzQAwutc53+2aaWd7gq9ZHq0QDKLJkT24WxsH6x4wH9oMqUrMVHW?=
 =?iso-8859-1?Q?X1c/kDw8X/HskSPW/54efupZ0SwIyW+sy20Vd4U/ZsLQQDnXpbBh82zMj+?=
 =?iso-8859-1?Q?lKvXDUWDbCqZUXCUOkRRRXoyD7SaZXzYkU17ZLttTpFuK40f52SQITj9mj?=
 =?iso-8859-1?Q?Ekj/Q29TtgHqkxFbYTqha3TJD6UVHHMgIS2kFgu3Ke99pBrnyhUWoDM2lo?=
 =?iso-8859-1?Q?lGmqjlx6JrqVpL0yaN+WTNsSFO2SumDvpY3UBkkqIcLfJZ2fb3x/IR6rx8?=
 =?iso-8859-1?Q?Q3qM0LsTKl9q8/BC210wIRDLRxWeMFyQlQFOtSQ65++ebTco3KjJmjxg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1b16e1-9902-4c33-24d1-08daa0011b5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 20:53:04.0469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yC2l93RXh9eaEZEnfRwX8Wut+BqXs/7nbBmYSrMBbZdlx3NAcNSWieEssw3rXvyrYxkSf0C25oXrLxxu6B0q8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6469
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

NOTE TO MAINTAINERS:
Perhaps the SCSI patch could go into both the scsi tree and the libata
tree to avoid any merge conflicts during the merge window.


Hello,

Currently, the sense data reporting feature set is enabled for all ATA
devices which supports the feature set (ata_id_has_sense_reporting()),
see ata_dev_config_sense_reporting().

However, even if sense data reporting is enabled, and the device
indicates that sense data is available, the sense data is only fetched
for ATA ZAC devices. For regular ATA devices, the available sense data
is never fetched, it is simply ignored. Instead, libata will use the
ERROR + STATUS fields and map them to a very generic and reduced set
of sense data, see ata_gen_ata_sense() and ata_to_sense_error().

When sense data reporting was first implemented, regular ATA devices
did fetch the sense data from the device. However, this was restricted
to only ATA ZAC devices in commit ca156e006add ("libata: don't request
sense data on !ZAC ATA devices").

With the recent fixes surrounding sense data and NCQ autosense:
https://lore.kernel.org/linux-ide/20220916122838.1190628-1-niklas.cassel@wd=
c.com/T/#u
together with the patches in this series, we want to, once again,
fetch the sense data for all ATA devices supporting sense reporting.
ata_gen_ata_sense() should only be used for devices that don't support
the sense data reporting feature set.

If we encounter a device that is misbehaving because the sense data is
actually fetched, then that device should be quirked such that it
never enables the sense data reporting feature set in the first place,
since such a device is obviously not compliant with the specification.


Kind regards,
Niklas

Damien Le Moal (1):
  scsi: Define the COMPLETED sense key

Niklas Cassel (4):
  ata: libata: fix NCQ autosense logic
  ata: libata: clarify when ata_eh_request_sense() will be called
  ata: libata: only set sense valid flag if sense data is valid
  ata: libata: fetch sense data for ATA devices supporting sense
    reporting

 drivers/ata/libata-eh.c   | 18 +++++++++++++-----
 drivers/ata/libata-sata.c | 21 ++++++++++++++-------
 drivers/ata/libata-scsi.c | 16 ++++++++++++++++
 drivers/ata/libata.h      |  1 +
 include/scsi/scsi_proto.h |  4 ++--
 5 files changed, 46 insertions(+), 14 deletions(-)

--=20
2.37.3
