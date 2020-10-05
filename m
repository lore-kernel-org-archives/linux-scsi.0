Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E4CC47095
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC932075A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gSsfEQ+F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CXMjnyeP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgJEICT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:02:19 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:29121 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEICT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601884938; x=1633420938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pyywNvKOl/x10C36lzECI2nLI+lplecjIFMK8CjJNso=;
  b=gSsfEQ+FAbs/RQfgIzQbquTi/1UXqpbhu9TrJ8voi1ZOzVRvtbapcsRn
   CsTI/dUfvgb/eMRVPFi5Ie/lpJZd9LjoIylHKXHUmh0COduGswBbddRUH
   ebSVnUh3PgPelARI0A776nlDHjSQ+BlZ94pMr/eJQvhllK/NPyD7rLlQ/
   wXTlbpY5pLr7RR7H2CgDybWRGX5j8pYzGZ4tNN3u2ephnVW4LFupYrx7e
   74iaTCua+Pud5784CuXMKLs9RlvGch9+DqMTtrPAlgH9TGV00+Mhd4KTB
   KxWDbzcq02LWAKBso1swKPRSSansTv8nNj5GX5LMFR5Tg/dcsdNEDyFOD
   Q==;
IronPort-SDR: NSb/6KHDyI+yj2Tafaq9naGu+7ocR+oK96VEZWDePRzM/eEtp6V7RhzyExAp30hzkX085cF/6O
 jWdttcpr4dl5iH5/tADqr1V/iJSOo4ZjvxU3/BPECg4IIGkSH/IDhmPPR/xFS+OyMsDBAD6oW+
 6QuUEu6ueZuL3CAqTNwDFbtkPFSe2TDTlMgIM3XU15RyY62QE8qruU0AV7Ix894HpHqqNF9K/t
 Ru44L+9UadkeEvC9dM1J4mz1odMalvi8gm3xyf5AG2SWV/P321Ndr8BFMQlCv7vzlT4MEeQdBX
 H/Y=
X-IronPort-AV: E=Sophos;i="5.77,338,1596470400"; 
   d="scan'208";a="258847172"
Received: from mail-dm6nam08lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2020 16:02:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzjgtOhfUBDPuo8WK1VIdjIEKWfJRk0N7arJnMIalgWm72jATuJjXdfGRj7wuswEu0TXVIv6LxqyLxIDg3b9n9A7QoijOcrtSldYdXTjXCSUQmuihLRiRbrseqrIF7DVJu/UB8ZqaOP+kIsCWr21DeQ0MX8eMFpxRH6sL3PT7jv9FGijxWoaqDovHykO4iPtNtriLKw8mEjn0QbxV+yN8gR5YiUNj8B2rdB8GdJGxeNULbVe/TuSn7sigERsCbUyR8ivlRdOooy086COTCIb8n6PINFZpNaa3UCHKqTQQieezwIjSJOZIIYt0ukLSxfQ1k1rDYC/RfoaGvZvuLrJ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw5VwNAEsRWt/HI4NzGOTxQi2D/LRoQrFE1KpbZhKCU=;
 b=AaO7wtpO8XtKzHc5njrYUB2iDWbp6+Z07ipeRi28bs8teEmrWi5xkzPil+QUUXIjgz8MMYjxq7fvkxeODcheeLzA1NF8qmHb2BcV9hx8jXgvilJtAIkcXNIiM519ytQ0E2N6XyYF1+eWrTxWSqp9IzzVr9kGg0HsNbYxxqQspfmK0iq2q12vMZprdxwEUMMLVBA++9OKdB2WUhot4BIERZrkLZSWjZ57TDai/tglYmq0ZVeGNhdGs0V4vv5hGWF5khNydYwLGeaF80omMZhpk+jluCRBcc0Dp1J5kAw6Jn9mwXR/MFYuOzKF8O5afsTUg6CJwEB6MrbE4LPJScZNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw5VwNAEsRWt/HI4NzGOTxQi2D/LRoQrFE1KpbZhKCU=;
 b=CXMjnyePbUujqL/oAv/qeAnQnLh4mU4YTwxICzWiuWPkmsYEJsQGzF4qBL8KOYssmE2/Xj6SB7YJUx/wM0RwvOnoNSPbaMQX1ym7tbCV8Re6q1teNPgzi61cBugnqobZc3Xs8sTM7VJhIqTPqZ29kdTV7HM9F2GS7WbI8hS1kP0=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB4438.namprd04.prod.outlook.com (2603:10b6:a02:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Mon, 5 Oct
 2020 08:02:13 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1%8]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 08:02:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Topic: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Index: AQHWmLlX/36ef3l9WEy26/6zpaIUz6mIpxKw
Date:   Mon, 5 Oct 2020 08:02:13 +0000
Message-ID: <BY5PR04MB67054C67CCA53AB5FC5CBCFAFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-2-adrian.hunter@intel.com>
In-Reply-To: <20201002124043.25394-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec2c6479-62d6-496f-2dde-08d86904f83b
x-ms-traffictypediagnostic: BYAPR04MB4438:
x-microsoft-antispam-prvs: <BYAPR04MB4438A150BD5149DEADC50606FC0C0@BYAPR04MB4438.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6p/N6vIfFVnYzFDUeJLSRcYorsDeTWf8Jropnjs5XwTR4GyHvltVntnxHfvRsX2yshXO08OqXsNLpJLVdtS/QvC4CFUiwHDQSZo1NJk/fv9p0AoMjFYVt/3+F1K78Emckr2N1NgcsiP4jofbj93a15+Pwlia+Fee8NfP29pbp4qp5kog50nPEk4SYdwGD4I/toLY2pK0K3b2zjP5SfxeVBcvk0GbHzdJ4D6TR2U2u08byOOYQs3KdcerTb6gjanL2x/slJvoSbqfYU/ishZileWksGnd/BAwd2XxSMEWV2B+Kro7Ah/JV2T0bbeP/g9KpQgZx/1LLm/agga5yBmz1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(9686003)(76116006)(4326008)(2906002)(71200400001)(33656002)(8936002)(8676002)(186003)(110136005)(54906003)(6506007)(5660300002)(26005)(7696005)(52536014)(478600001)(55016002)(66946007)(66446008)(64756008)(66556008)(66476007)(316002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8HOH0+vKtGe7HLz9s87MNUea1PP4CAGR7AMbbyzUSgasVfaKQUgN9HrTEmi1WRSwySqQCegwmJfzSElqn7Py3oHBJQ1npzDx6NtWdefNsPa/IygEUzgaPFQTUBKHN9oXHAFr1mnP1YGjmleVwMcFc0jPOa65KdSFdgKg4AQcFsQY4gh/vxTS8LnPynSup9k5XP51hxEDdftGdAnTeUJXW6EtEsDQ2FZTMVkFytsbQJkfZL/gdheVNNgFtEksHRzpAfa/JOGIbhwMldHPJywe7c2mY6yCH/XZ4Sok6CEjykIM0ky5TDQSImCnxaXUJ9AV+nqIWSoyaqPzZ2vR8DO1N2RFkdlTxFAYc8GK6SkemBjCvlaVqRls6litRJFwcyGfZurQ8UR63Bjlk31Bgil1D2fapdb3+0Wc1djpkqXk38vEqWYdPe4Q8QBSKceZqW891WCZYe8QtD4yX4rpHuJhhXm7vJ90Q9E959t2PKO3RL/uYPFPn1pY359Xp1ohPuXF+UD0ueUThxaTmHTZQiOexvuqWReKXSmR84Kt6uJbq/rrHLesw9YgPt90NsQv7f/S7JPzaOGgYlZ5SvGXTLI/zYz0N3nDHiesGeMYXuzaOqa4S+jB+TyynjeBxDlxIGTa0CSWil1yaae4qL+qjM9Pug==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2c6479-62d6-496f-2dde-08d86904f83b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2020 08:02:13.7422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T4RN9SSMYyqMGLNRkyu/B8C8qJ3EygFT4twKXWpaFcMMOYybHxOET0u0rGzmgFQ+Zk+syFsKVU5386XIk9XFDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4438
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

HI,

> Drivers that wish to support DeepSleep need to set a new capability flag
> UFSHCD_CAP_DEEPSLEEP and provide a hardware reset via the existing
>  ->device_reset() callback.
I would expect that this capability controls sending SSU 4, but it only con=
trols the sysfs entry?

>=20
> It is assumed that UFS devices with wspecversion >=3D 0x310 support
> DeepSleep.
>=20
> The UFS specification says to set the IMMED (immediate) flag for the
> Start/Stop Unit command when entering DeepSleep. However some UFS
> devices object to that, which is addressed in a subsequent patch.
After failing to understand what the proper behavior should be with respect=
 of the IMMED bit,
Although I read the applicable section few time, I gave up and consult our =
system guy,
Which is our jedec representative.  This is his answer:
"...
In order to avoid uncertainty - the host need to set IMMED bit to '0' (this=
 is explicitly specified by the standard).
The device responds only after it switches to Pre-DeepSleep state. The host=
 then switch to H8 and this would trigger the device to transition to DeepS=
leep state.
..."

So maybe the 2nd patch isn't really needed.=20
Thanks,
Avri
