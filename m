Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDAFC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 09:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8709D6193C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 09:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhC2J7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 05:59:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:47883 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231686AbhC2J6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 05:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617011933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fwdnHkM4gYDbRpUnByPTXE0+vpp2WLDEtvpoWH3ZDLA=;
        b=IPT1NDsbTwL0Fu6QGdecTFCgqdji5porOMTLnqUnB2No+gjPLb6fB1CfmGpUgAD6r85KjV
        ZdOtjQNQT049MPb8/+91QwW4r5FOmdt7igNIDKn4Z5Vvqr0rsYH95YYf3pWqtyB1M6iboG
        yga+HQ+HKV+SS1XXvRnzq1s3m5ycmbc=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-fADNTX6MOKCaZ8Vl5fZV2g-2; Mon, 29 Mar 2021 11:58:52 +0200
X-MC-Unique: fADNTX6MOKCaZ8Vl5fZV2g-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3USa4pBWSQh9uV7RgtDWIjl1Dct0q6YQmShzkOJgCmYq4q0dVY74GgaHLRmEiJrnArvQ1YuCkDKYS7jc8OZZiU+X0Y9JEFhXTmUdZ8t2NmCDkV4nJGVEXD790Z+5OlIZV20/1RhLDHnVt/pMxUborzKhAq0wYjrXShRan+mvg6AovK/ZseCVWTvtCsmtQOyDGfGoUrKeM4CA58u/7WpRXxRLJy9f/8FcjZWBMyaJ39nqZJ3B9eGtUzhalR3Rn+EthcSFs0D7TJC6dLorU4QagSTPptxTEWCqQVHl1uZvolu8Mv73sa0P9xHpxIhlkv5rWHkL5mLVl4ZLtpnzJB1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwdnHkM4gYDbRpUnByPTXE0+vpp2WLDEtvpoWH3ZDLA=;
 b=mR6INMbLsa+N1Mf537qBTqOCKhh/wvgPtFu8wP8SzMRW/RjYEq66HuW379gwjo2TXbt+QgLv6QGcKEMebcQysL727FjVp8aU0jCyRL+at1lExgKJhdvhwdJGdXh8PCqltDpb25luTqYG6sIaiQruCaV72p9g7+qaeJcdtoNJN7+SmdQwQim8VVjPAXjtWLuNJ3AF598cZreWhpVyTNEo3jOUE4eaW/P3OXnCCvGECjybr/3obeu8qf14q52MZYNgr8c4zSSRnztCapk1X1OZsNNJWT9Alp6nkCJiYoUkNT4+3M3B8BzNU2H/WINv4I3uEu8AEY8f43Y/zHGqf6WXdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB9PR04MB8347.eurprd04.prod.outlook.com (2603:10a6:10:245::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 09:58:50 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::69bd:c9ff:f910:faeb]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 09:58:50 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "hch@lst.de" <hch@lst.de>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "bmarzins@redhat.com" <bmarzins@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RFC: one more time: SCSI device identification
Thread-Topic: RFC: one more time: SCSI device identification
Thread-Index: AQHXJIIevKqEvjcbJUy9Ai14uQzKmQ==
Date:   Mon, 29 Mar 2021 09:58:49 +0000
Message-ID: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=suse.com;
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8549d9c-b607-40fd-c3fe-08d8f2994091
x-ms-traffictypediagnostic: DB9PR04MB8347:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB834743787C009DCCEEA1B60AFC7E9@DB9PR04MB8347.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /anSMDmjRI9sCB8BxY0XzEc3UQUuxD7WIo1UJf5fCqPr6Pd24km4NLfvEjRv5P8SbbDcJ2GfEa4I3uVhLbnG2I/WcI0hrpgCwaH4y3swBR/u2bEqQVocgYt/Uwg5K5IWsWCy7Lhyy+1jbvNBQCEI6BGlWBmz8oXsIRw4ytOy9+dq4Fvd3UG1yKd09OqY1vxiozWkjKqpkEye5qg88Vh4aT0xUGd8pxJ51NVVPBJUt+H45qLjqaVM7BsYv1J6IBf8AJdh5bHlGHJb3ptytZjb605yWK49VDeihewLtJUdDl3tD7k8PcnKsqEI7CVNU0DZ/LuIQAGf68ntSQoc4X3dMkBVxDUTFj9hu2Ji4Qsh7c0iha+89QLQjCc8QR9dRh1bUzwx2TpD0CYMKD64wkLjVS6n0iM5ISNrtuMswcDMm57Vd4PUBE2Q/bHmTetuCAcd9EvV1AIlqSlerkiY3vvumXb32JYnHYkpqYyRaDwB79dB2ZxMzDUZl6rL16gAf6iYBcf9MyPhuS99xC7S6EIC8TlgCEMJjiBDTv6gzwkVZJP4+y2EtCraO8ZJdy9k8r3aZ0lZdrkI6i2XZDsWV3Q4N2AnLXEgTleayf0O9sAF3jzfaL5VpuOEcwghG9sAYajXjbymlULDC61U6UvyIkejRVrYNyJsAx0FLkvlxdlKuDVM8xhTBzqL1k0D7UaKWjSVOMBN5MgXedpdVUjV3T1VAVdNGcabKG5Aat+b4UJMLU2qmqnhCzgUmz7ASKdpXp/T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(86362001)(8676002)(6512007)(44832011)(76116006)(66946007)(6486002)(6506007)(2906002)(54906003)(110136005)(8936002)(71200400001)(316002)(83380400001)(66574015)(64756008)(2616005)(26005)(186003)(66556008)(478600001)(966005)(5660300002)(91956017)(4326008)(36756003)(66476007)(38100700001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?CdEUoOEY8TM7H5wOCDDzFmSD0kNkmEtpTvZ+WEuJ+5JCMo9i+HFPJh3lR?=
 =?iso-8859-15?Q?+OGC/ixeHaEWh4zv5aRiWa31FDGa+5wicJTq6U0gsoU+nUT2Xv8RfYL/F?=
 =?iso-8859-15?Q?X2h6hgMomAyJZKcoAQZOSNRvbVDci3T5rkZXY6V7hWlX6CO/Vj5yl9Okw?=
 =?iso-8859-15?Q?p7MYrvT5UyidBVVKOhD41MMjnomJEFDTVeWb8YbEB9CzR7o0MhSX+y4d/?=
 =?iso-8859-15?Q?eUKd2vTCDzGc2ZVW8yX/4t0c186qEZ8o1ZUXKl6LIHShP6k3LPZCAPle0?=
 =?iso-8859-15?Q?ZMLnMiB3eeCmTZJAnU3uG5X/ZiRwjYftXLc47FtAEGNTzuHcob+TlnXVV?=
 =?iso-8859-15?Q?b5mtni9Z0D+ShsptTi7Ss0N/9v5RdkKyW9TA5i+y45C1kucgXK5lmxI3H?=
 =?iso-8859-15?Q?SPUj5S6v4cHVzmKOZcZkv9iLr0rDX8zHJzbwRg/Xk//lskUTBfkCLPxF0?=
 =?iso-8859-15?Q?aw6vV9nJtYE43FPFusUmAutEIl+9g4oD+n3h4jHYuLpWL3/S8wz03Tt2F?=
 =?iso-8859-15?Q?T5XwGHLY4CkvNMI5Y4ctWEsxOcRwNypj2wszXPsWtpcBbvoJq1eF10Dv7?=
 =?iso-8859-15?Q?3jRarUAAE74qhlPnQN4+jpuZLVrQUeuEDqPYkuuhfpwupVnICSzFxxalb?=
 =?iso-8859-15?Q?OMFXNHrO0mPlhoSjH/4ghA9lv7oVFlVPrpDZtERUaLi71idPDJP9NPGfK?=
 =?iso-8859-15?Q?hGWh+o9zigpWXx0hW8xflZMMP/DdmBp8t2jW/0/6lE/r2ONP4TnE53rPR?=
 =?iso-8859-15?Q?C1UrcCt9uc4RLGua5FfIn2tlhpqPVmN/O5gBGvFnYkgw0UJWmWFG/8vs0?=
 =?iso-8859-15?Q?FkGEQsZKzcpXQxwUmmKtNkIJxC7CZ9Iq9M5xcBSSb0vaQTVrB6xjXir12?=
 =?iso-8859-15?Q?7zBYrKTHbGpHcO6C3PWSJ1pESNnEo3ned+PDUyd0GYiGgkScJ164e+Y9e?=
 =?iso-8859-15?Q?JVFZml7qQl8l73i10k/vCR6+CaiJwR1EmtXH5nt774hdUuo51yVeIMuEm?=
 =?iso-8859-15?Q?o+bce2bqwTgo7R4R0fELCesDNGnT58TCrwfInuXzlMcHNFOyWKFBtXfjm?=
 =?iso-8859-15?Q?3a5IxgwrrHobCXXZI4ECotJ6Vz/xbBSGOoR+HnzOFNdqhH90oy5X1FIP9?=
 =?iso-8859-15?Q?3+IM5bkDHSCNkvd+t2U0D+9+lf4f0Ji4uEG94WkQ4y8HBrLhpJpcEEjz3?=
 =?iso-8859-15?Q?pVJCZF9maxkiyoqfI2ba45i60aIq0DrfEWVXAlopFZYK1BDHlWlXfzEBb?=
 =?iso-8859-15?Q?gvSFJr0cyoVXpYAu9w5v5TQ+8R7v6uCd1EMgUAuhRmD4+kc6mm222zk4v?=
 =?iso-8859-15?Q?TUreJieKji5DqpcJeuPQNVhwo8GYMy9xXMun1DAKstaPucEUqbMTMA61l?=
 =?iso-8859-15?Q?+NWubLfju5CYRniWoB6QI+fZXqtz1TkLc?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <B74465EEC83557459A05A1E61BDE7C0B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8549d9c-b607-40fd-c3fe-08d8f2994091
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 09:58:49.9678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjmZR8C+vOv34CiLQqOOqyGbtcbsZWam4DE8yZZOqYaVu//yo0AkdBnsBJeYZ6v2a7fdpKHMzSSMpGzlhyMFrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8347
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

[sorry for cross-posting, I think this is relevant to multiple
communities.]

I'm referring to the recent discussion about SCSI device identification
for multipath-tools=A0
(https://listman.redhat.com/archives/dm-devel/2021-March/msg00332.html)

As you all know, there are different designators to identify SCSI LUNs,
and the specs don't mandate priorities for devices that support
multiple designator types. There are various implementations for device
identification, which use different priorities (summarized below).

It's highly desirable to clean up this confusion and settle on a single
instance and a unique priority order. I believe this instance should be
the kernel.

OTOH, changing device WWIDs is highly dangerous for productive systems.
The WWID is prominently used in multipath-tools, but also in lots of
other important places such as fstab, grub.cfg, dracut, etc. No doubt
that we'll be stuck with the different algorithms for years, especially
for LTS distributions. But perhaps we can figure out a long-term exit
strategy?

The kernel's preference for type 8 designators (see below) is in
contrast with the established user space algorithms, which determine
SCSI WWIDs on productive systems in practice. User space can try to
adapt to the kernel logic, but it will necessarily be a slow and
painful path if we want to avoid breaking user setups.

In principle, I believe the kernel is "right" to prefer type 8. But
because the "wwid" attribute isn't actually used for device
identification today, changing the kernel logic would be less prone to
regressions than changing user space, even if it violates the principle
that the kernel's user space API must remain stable.

Would it be an option to modify the kernel logic?

If we can't, I think we should start with making the "wwid" attribute
part of the udev rule logic, and letting distros configure whether the
kernel logic or the traditional udev logic would be used.

Please tell me your thoughts on this matter.

Regards,
Martin

PS: Incomplete list of algorithms for SCSI designator priorities:

The kernel ("wwid" sysfs attribute) prefers "SCSI name string" (type 8)
designators over other types
(https://elixir.bootlin.com/linux/latest/A/ident/designator_prio).

The current set of udev rules in sg3_utils
(https://github.com/hreinecke/sg3_utils/blob/master/scripts/55-scsi-sg3_id.=
rules)
don't use the kernel's wwid attribute; they parse VPD 83 and 80
instead and prioritize types 36, 35, 32, and 2 over type 8.

udev's "scsi_id" tool, historically the first attempt to implement a
priority for this, doesn't look at the SCSI name attribute at all:
https://github.com/systemd/systemd/blob/main/src/udev/scsi_id/scsi_serial.c

There's a "fallback" logic in multipath-tools in case udev doesn't
provide a WWID:
https://github.com/opensvc/multipath-tools/blob/a41a61e8482def33e3ca8c9e363=
9ad2c37611551/libmultipath/discovery.c#L1040

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer


