Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E5AC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 08:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C258623A5B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 08:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgLHIFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 03:05:16 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13472 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbgLHIFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 03:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607414715; x=1638950715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LofJRW5443+qP4NpWWk2uQ2iJ3IUrjqZoSHe/PAxKN4=;
  b=IUaWezZFBvfXruDldWHj50jXOMLnLU6Do04DLDGPb4sZUs+INCqNzcYq
   /YJSwMnOGXaZIEqz3p8e+rC0qcSZOcaEjsUyvpyqJlWzhGsON1/Zz+Tja
   e9DslNk8KUWlfhVp0t4p8yvtoG0iwiA9uNb0SL9bVyVIKUvWE3Zpvsu09
   ELVK+VZuVdpHpDMOdY6Ybqfqi2R9RUzV2uPEKE5Fztx/Uo20fkZM1x0QB
   UNdiaOp8Xm/GpJGj0dRZfcvQNry29IBB1vvwp9+2hWWA2NVoH/BGHHqi8
   yq+cc6JHTINjXq7U7n4SJH3iwF0MfWgsgvjQj2/fb+7uz+zknCrpDKSoN
   A==;
IronPort-SDR: awKGXHnh13QyC5cfCE+8TPKXgwiJkKUKtdJIDYDWy4lSL9c6XVKtxJXhUabfRfwrw4Bosa6AOF
 v7dJRkqSuQOe8bfiQinDgAjRM3T+KhaVBfWN030YE+rX5lk3RFC5kVTjxQP8d7Noe2UI8JdxTM
 6Yw/xPQ46Sxd/5tlZUhVS1DApM9nkQkwMk0AAXDmlyFoQr2CQO4EEoJGcJMAzR4QdUHWi6lIcO
 JlMQBkf+tVzBpY5bXlvruhveIAVYz/OLhz9tMurL+iEbfL/LfgMdV/17rOSuaBS4JnCOOR2zVk
 ee8=
X-IronPort-AV: E=Sophos;i="5.78,401,1599494400"; 
   d="scan'208";a="154717600"
Received: from mail-bn3nam04lp2056.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.56])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 16:03:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxyJ2gsSAZ+pA6PYz6Zp6nOVYknTHe49JVoRUk9+bErU/5e525BAIZFim3y1Jkh4F1c36CQk3qRDOXdJg9+Yeh7dzVq0TBRBfWpuV32LclMOBWlnBJfMNkIvV0L9Tik8g7PawRCppenOBjDOkg5qWgkB35k3Z4jY+Hr/Qsg2uAOQpF+g3Kf8DEXp4ZSzlYnp+azA+osnLEwGGdMhJaKhPjZF4vnAgdOqXw2n3AeKID46RquPje6ofKibbaYRMtD814ctOOQ1YdWcgo+/y16F3syURhPyIiK7m89SLXbsjRnFtk51j50C0SUM0Wkvpbdd3GknXqxiSN0fpBLhgq4tNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yKxplJ6uGplB7v1orki8hNXehZBOi1/xVmKA2pERcQ=;
 b=R+GAGwbYtJcOd5+GZXdCvKKEUcYdaGF9KMRJiJhk/fPeofQ5g/prmvZgKyievSr0HH9qfUcz2XXXH5j45wX/XZhRzV/mQGUAFGp7uIpLh+7sh1Fikg1dUtpexhg7AVtjnFNnZSsp503VWB/CtrUYA3ER/5oIaj0gXBJiDCp8ctfKMakAATk70YuSGZmuBXQBkWvd66TeF3M/suFN3fIYdPkCohhM67z6UcR9Nb9aMCGSukiA/qHw3OKTsI05FmmQ0WDdZw4bbe89WJ+14MP7+oTX/tok+I7eRBeTZ8mlBvbTxQMol9bRMtmLg41wjFk7gHraG522tp+GeI/qb7NG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yKxplJ6uGplB7v1orki8hNXehZBOi1/xVmKA2pERcQ=;
 b=pJOzEMCoJP1ux0KJhVUidX79cZvkFY4d5QDafAAiatqS709eFpaClKfYKS2EC+rCXqdmW4J9f0EkIaLqtYA2o1DZdAxftI6jmhW1ljaAPFB7L9ZigpRvcU5LVhATl6x+5dKDNPaEqktiwq36h8o99cUxP+IS0GpgP4g+8iZQPks=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4555.namprd04.prod.outlook.com (2603:10b6:5:2c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Tue, 8 Dec 2020 08:03:48 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 08:03:48 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Topic: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Index: AQHWy+7VP58/cpTtqkiyF4OIctzYqqnrRKJQgACBJQCAAA6aAIAAEBuAgAD0GPA=
Date:   Tue, 8 Dec 2020 08:03:48 +0000
Message-ID: <DM6PR04MB6575864DCED7720950302244FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
        <20201206164226.6595-4-huobean@gmail.com>
        <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20201207103708.66897ef3@gandalf.local.home>
        <DM6PR04MB6575CD229D3F6E1C1B30B11EFCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20201207122703.0190adf9@gandalf.local.home>
In-Reply-To: <20201207122703.0190adf9@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 733f6de5-82ef-4cc3-c7d2-08d89b4fcb5c
x-ms-traffictypediagnostic: DM6PR04MB4555:
x-microsoft-antispam-prvs: <DM6PR04MB45558D8254E9892FD3AB8D01FCCD0@DM6PR04MB4555.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qXd6iYTqbBnOc7UgS8+328ts/XRJrRjCYwIE4bVYW1ZvGzFolPzVm5Xh+XuLg8XzGYLCGmU6GXbu9Bd0YSaFqAsGfk/H0pUAPgLFKlx8hSS4EX/Rs3s3acViaZv3GOcg0QPQsh1VpiRrz+VripMCzjvkDk8VmWhbcUV0n+iElcH8ch7JlGA59A3ZuNJQNUPS6xCubTczWZ9xgzoFPdCuy1XmNDV4jL4ZdNg+Bc6/ebFBwT/CYp7ZJmu7+ihLdIn46YXbyzSNYFxAPc2uLXuuIFomHkD4I8uFmOV47Uvz2hzoiwf/cUhUeRaH3aufGzNu1l22XZdChwLjBlDuk1bjgPR3O8+XqJnCPQsuH/nbkIzjUCjw4HhQP+XikM84pDw1n1uGVbNOuRbS4kfys1fmwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(8936002)(66556008)(4326008)(83380400001)(8676002)(26005)(6506007)(76116006)(478600001)(66946007)(966005)(2906002)(5660300002)(55016002)(66476007)(9686003)(186003)(33656002)(86362001)(54906003)(52536014)(7696005)(64756008)(66446008)(316002)(6916009)(71200400001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FpBi74/rcHkH8KNKvdvSEMFdnUJP8LdnCyv8B7Jkiz5dD0DaEq8lUQT3HsKi?=
 =?us-ascii?Q?pRfJ0r9Co8zdeytY+LmP2otn549EwDpTMtsK7sy8AV0Rl33leQP/bezO3xq3?=
 =?us-ascii?Q?AVwk9EMIIrafU7ZcxfsPKqRoZcsg55+5PCjYRFrW4u1RAYpcZL/q+2fK+nqh?=
 =?us-ascii?Q?aVGtEqpV5MoM4D6P/zh4rJBUGII3HTn+Z++PPn8jU+Hk2+Wn1HjKaIWL1+et?=
 =?us-ascii?Q?uMts8wILQCdr9HYebBLCYOoWV6vopUcN+rfwV+96QTDw86sy9kc++Jbn3mKu?=
 =?us-ascii?Q?gwFF96GjpUWF6zS7zVn9PSVFEVfyVn1fT9pjTjs87dTThMBhK/IEcYoIMmxn?=
 =?us-ascii?Q?n5XY9n+2Rk1o50MMgWMp/TtvVfqWnwo6W5QZSetRzhs8HJeUMAshARDXk1Sl?=
 =?us-ascii?Q?Ord8D6ag0jAMWGumfNfpAOvZsASNhXNqXA6LpgjGytSVSYA+/Qs+Hx/Q1jyj?=
 =?us-ascii?Q?dz4JxKeeXGF0jMsbJmeiMGQFjVa20abXrW6l+5JJrvs+hZnknZuOMdNvRQnK?=
 =?us-ascii?Q?exqNIc2F5jSLHwkQ/u2fo7sp+vWQ9FmD/K/0HTW5sc+OzAQx75cenGBKVExG?=
 =?us-ascii?Q?9uITdVzRXzMVWTIxVpIft+L/kbi2Pw/Gg2aUusKOLdph2JgSMMgprXwiz4Ik?=
 =?us-ascii?Q?jJpKUG8Lsj3Rax6SaHPebdnMg2u+RX6Ju4BA4XEiR2PbuY+rbx+EVNlctrey?=
 =?us-ascii?Q?8+/OEfUys7e7I4CBDWK+rg4uCJg8wyBPOZgCfMEgtemuc9mJqWw7m7U7z4HO?=
 =?us-ascii?Q?tXlcBV9yUychZgFswnxmlB27PJmko9wr6Jd4Dqc0HLkhaergpMevdqt28xcW?=
 =?us-ascii?Q?iRBf5CubcSRa9WNRNn2VN3088G76Mqw0SobFldXRrd0CQVz+uqPt8MnACGyn?=
 =?us-ascii?Q?wR42wlonA43PqwfbV0VAEbi6DBCge4wkMEj7JOEoOBHxF0hsi20YwPEgeuNW?=
 =?us-ascii?Q?WRmBXq9Mp7ae3o7CHh6J2PH+JrPmBtMwtA+3N8ldACY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 733f6de5-82ef-4cc3-c7d2-08d89b4fcb5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 08:03:48.8237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nsg16azBKznjAtcJHBSj5r3EncaAtyt5/xScMVlwPkogDJOrgDmDLfBABKzvPHbTFbA2rP3hetTgCw3GNgmdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4555
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Mon, 7 Dec 2020 16:40:51 +0000
> Avri Altman <Avri.Altman@wdc.com> wrote:
>=20
> > >
> > > On Mon, 7 Dec 2020 07:57:27 +0000
> > > Avri Altman <Avri.Altman@wdc.com> wrote:
> > >
> > > > >
> > > > >         TP_printk(
> > > > > -               "%s: %s: HDR:%s, CDB:%s",
> > > > > +               "%s: %s: HDR:%s, %s:%s",
> > > > >                 __get_str(str), __get_str(dev_name),
> > > > >                 __print_hex(__entry->hdr, sizeof(__entry->hdr)),
> > > > > +               __get_str(tsf_type),
> > > > This breaks what current parsers expects.
> > > > Why str is not enough to distinguish between the command?
> > >
> > > Hopefully it shouldn't. Reading from user space should use the
> > > libtraceevent library, that reads the format files and extracts the r=
aw
> > > data to find the fields. As long as the field exists, it should not b=
reak
> > > user space parsers. If it does, please let me know, and I'll gladly h=
elp
> > > change the user space code to use libtraceevent :-)
> > Hi Steve,
> > Thanks. I wasn't aware of libtraceevent - is this a new thing?
>=20
> Actually, it's been around almost as long as ftrace. But unfortunately,
> it's just now becoming a separate library. It was originally developed fo=
r
> trace-cmd, but has been copied into perf, power-top and rasdaemon. But
> this
> copying is inefficient and a maintenance nightmare, and we finally have t=
he
> library as a stand alone, and hopefully will be delivered by distribution=
s
> (I believe they are packaging it).
>=20
>    https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
>=20
> Looks like distros are starting to catch on.
>=20
>   https://packages.debian.org/unstable/libtraceevent-dev
>=20
>=20
> We are currently working on libtracefs
>=20
>   https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>=20
> Which will make it a lot easier for applications to interact with the
> tracefs file system. I'm hoping to have this ready for distros by the end
> of the year. We have applications coming that depend on these.
>=20
> >
> > We have a relatively sophisticated analysis platform that utilizes raw =
traces,
> > Among which the upiu trace is the most important and informative.
> >
> > This tool has evolved over the years, adding more and more parsers per
> need,
> > and the users are picking the appropriate parser per the trace they use=
d.
> >
> > We will surely be glad to adopt new tracing capabilities,
>=20
> I think libtraceevent and libtracefs would be a much welcome addition for
> upiu trace as it would be reading raw data (very fast), and have an API
> that makes doing so much simpler. For example, I just wrote a quick progr=
am
> that checks what files an application opens (this is not in anyway
> production ready):
>=20
>   http://rostedt.org/code/show-open-files.c
>=20
> > But we would prefer not to break anything.
>=20
> Of course!
>=20
> And again, I would be happy to help out in converting to this libraries. =
It
> will make your applications more robust, as they make it so that you do n=
ot
> need to rely on the order of fields.
>=20
> Note, there's plans on making these libraries python modules as well (to
> have python scripts enable and read ftrace data).
Thanks a lot for your insightful comments.
We will surely look into libtraceevent and libtracefs

Thanks,
Avri
>=20
> -- Steve
