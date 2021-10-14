Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF70C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 06:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385E761152
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 06:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhJNGRl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 02:17:41 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23801 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNGRl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 02:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634192135; x=1665728135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NO7ecYX5CP/ygRUam1Rvs7yaJ8NwzsbJtWXl2iDvocA=;
  b=bK+RK3rNVBG9Qy8Zsj22Rxlo4l2RgQc/+CUtKchBhLZxRt0Fhzy7WU7s
   RvNcVvhedvsJeTjxJhAWKHRZkNyRfikrW1l8F1Gm+MCErlLwsXSAPwd5g
   DoQ+ygUi10/qdVvtjXP/yL51yXu5yfVCLChnkW+l+BZuA9/i0RO3n8NGu
   RVbV+JGsLt4cQXh531TcQWnnMSGEwvMI5iAio3oYJY+37TED2o+FmPOtS
   Y36hehDLPnLlHG1AI5L0+wkoVDkaDyNBRUvTZ4dPcQ/y5YBlMWrEofRqA
   YJJakUl4SCF9b4vX0TbBkVoOuPyvExednO9fo8glAKzo2g9hV3RYDgJHj
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,371,1624291200"; 
   d="scan'208";a="182814164"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2021 14:15:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCcNOKTTF1B7pmfNfA2Bbic/eELAho9tcGcLFB/ZiCi4zRrqzZvfFayuPxKTaKhqEGHGTITAnaMcJR2/yZd0LkRzu8fhNjfhq3nyWuR7LseKoSxPPmLZrGyKAUAC/ldrj2x1H9ZQDKvDBjLltfIW+/Ggz1VlIgh3CjJ75RoSXCwwqKyqGVILlghOYO+j4F2+RPjjQgw7Lzy4iuFNxDR8BWYdEMGke19Y5NewhpXhUnNeh+CvmDcQrH0+xALlZJusvNdKFMsnL1uuJcUq3y1Ipt8pa4QO9pPs500A6caOUPPBaWOB39bPv75uNlT9LMbD5bB5cNYE4M7mw2j9w8SH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7Imw11LhAXo9xVkWFduQxGjB9uAZwXjwrsxbrywS20=;
 b=dBJkp044aGTGItaK7arsp0jrtGaAnHcH7vFpGAoSg0Nbj5tkGZvC/Lb/B7K5FTdoFEW//ROnEFOEai8MvnWzaQ3WwTEg1a/xTVkMJvm1C9ACRgzX+C9I0z6asQxTjnh/VLqVTLHHuAjKcdngwN2itHSRqP8+u7mFD+ZwuRWtGwKH7MA0tbwVZmWlGfuRzqU7wGER/L46Oj7Fm9tpn0cKFBbq+NgnID1gu2WrBA6wMPpAmpKv6mKY9oUIaMFZBOT5eKGwfijDACCWyUFgvc/WwIo1T4QzeZ6oUyWomF1fQuJsWA7y4eB+JsoZEsxpUsKCON6cV928Za87MC4MdOYg2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7Imw11LhAXo9xVkWFduQxGjB9uAZwXjwrsxbrywS20=;
 b=DMMvmeQqgZqSEGqiaBXo1Tpzbad6Yn+Dxe5iJY4a+Lwwkad4CyHWVeo88mt0YKL6lYN6+VdaXU5ur0xf+qxW7nlKJAGQofQraDD/vVRS4bnOPWO4B196EOElgxKn/QWiSuxft/BcC7w6ABooc2pkf75IOAPUFRWOnjH/zOtsb0Y=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5018.namprd04.prod.outlook.com (2603:10b6:5:1a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Thu, 14 Oct 2021 06:15:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 06:15:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Topic: [PATCH 1/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Index: AQHXv2ku2NZWv96wbUuf2yAo3I5eeavSBXCQ
Date:   Thu, 14 Oct 2021 06:15:34 +0000
Message-ID: <DM6PR04MB65755AE8057F920F2CB4F40EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
 <20211012125914.21977-2-adrian.hunter@intel.com>
In-Reply-To: <20211012125914.21977-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 711f7fcd-bbcc-4568-36fd-08d98eda08ae
x-ms-traffictypediagnostic: DM6PR04MB5018:
x-microsoft-antispam-prvs: <DM6PR04MB5018E4AEE75155B5702E5A39FCB89@DM6PR04MB5018.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PZtnRZustc4YzRbGWt/6gTn0bZS6xzrEs2j1Cnwq0d6JUGM084N+SSKbChPL3CoskhPYKjBPtuKhYEpzJRlF2o6MMyow2SIt+fty9KW3JsMhYtdX3swGYb8ZB+s6S8mFfxFThR6XNZhRaI9QVl+dHsTDAIjDgpJXtsiEjmlyOtwXcLCp28LfA5gp2wXRtn2QeG7NBEg7eA+RQX5k9JmPonFAWz+Mge/wSwOsrIjQXWSxqIgIxiV30WrzMHBVQAQKcliZr7gk+8ZQruiNyEkZaOsqraSB5FeaQBuHqPUYnA4+4Mq0cAl9aW719JAHcJdb7mmv05RhLkQFNNJ+HjJb2EtL3eSGeq8pbkyc0brVzlg0JsXC+3BXUZSISeM4VnhDz/7wHrWL5ZDPbYIQh6bACC1973NenImvccD1xGvFR8dwmQiRra+6tbKXLn7N15TznGwa2l9B8t2CxgMK7FwoRYhvKXEbCyO13TP6xYdL6lNtn6ZqBP/e+ESI4qGSjkgLC4UFFF0DeOL3Ca5XpMSTdoaO+YSQ2YnYk4Wt2qFplU14V5NDEMKQR7lBgOQ54MoI8B7rWGUJCKE+5CgO/EET3FYO+kjL5JQNigbnHpOSYh1FqC0sR9t04ddho0WnnRjhPFQvzTILmUoQZgnu6jStfJnl4P896+OsAupmt+v9/0nWzfQ3VTCTeTBJzaEGmparEy7nEJ0dhKELCA6NrCrHAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(86362001)(6506007)(38100700002)(54906003)(508600001)(71200400001)(15650500001)(38070700005)(9686003)(33656002)(5660300002)(7696005)(52536014)(66556008)(8676002)(122000001)(83380400001)(2906002)(186003)(66446008)(82960400001)(64756008)(4326008)(316002)(66476007)(26005)(8936002)(55016002)(4744005)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fc+9V2XDdTeDypOayqqdXU+xZfmHX7rYB/0OHF1RMsyGPqiiujV4LCp9oGqp?=
 =?us-ascii?Q?f+wzakVzpM19wXkwcyvP3S1tg3lQzzCirukCi2ty+sUydu83koqEf3axqscz?=
 =?us-ascii?Q?i7bScvuAiWkNyvsOTokc3LMGX6GGtDxW9qsK9nU3fkuEY4/kDXicDAR9Qc1N?=
 =?us-ascii?Q?3oVs+q0WsPqNu0INkoUO7pYDTtXaZzEf6tVjRafaeUEAL3NaA70u5nm9wyeh?=
 =?us-ascii?Q?/7ZtPhemTipP4jB9zyDNVywkQE8yh8EcX45FFBAZIJ5/3yZDOmF2cqDzZwrP?=
 =?us-ascii?Q?EuuSuSYHqlZWkmX9rRjI58WPRoYBSlIHzcwXJTqqUWGXYVwaeGooEw53Qw0r?=
 =?us-ascii?Q?SHJtEbF3cgqn8UiAFVPAjOm7o8PbJrNY5iffDhbAKe+JVNrKvgXMR6XbTdsh?=
 =?us-ascii?Q?erq6vBYxCZ5XQMfXnzinV5hufjhK7T0EQEUWLY3RSLBfcBWxkVYxkJt/6gEV?=
 =?us-ascii?Q?vAFvRQ3rwmOjy3h8fII9b1adBjxGcVpqoWcl+eTzw4GpP1luRaKAeFUtm0Xu?=
 =?us-ascii?Q?medvz2QA4FlfXgfSTPPOWZ8Zs7I7KDDNkD3D/jOY/Kqv8q6ZV6Q7OaGZWzht?=
 =?us-ascii?Q?C9TH5d/jGJstyZ7FSaSpfX0SR5lkFtJye/bg81pbx5HGv3rU43Km19+t1SHX?=
 =?us-ascii?Q?2a6AZUV7owL7EzPaZ0/64kux8HZP8w2nWWMJqrphjt5wyvuFqNKS0BSpAuNv?=
 =?us-ascii?Q?X71x/Sg48G2JYkXcNIUXtzC+3MqBJQtbz4BEuDNL/EyksRCXymFokMp2nZ3o?=
 =?us-ascii?Q?ahkLwMh+T/cSt1bpDaLPeQBgw/0Va0RajNubGSSyEJJlSaCDMDnqlQmlGo4t?=
 =?us-ascii?Q?pf+a6NbTYOT9puot6fw+7wonyN6vzaQbK5U5hc5WqW70mm8AXQcrE4p+gnMc?=
 =?us-ascii?Q?R6bOx/oPvOWBd/JpBCQoZiDXOC6NAuzjVp4DKWEAOHQgLtz20fMDMWpxxX3i?=
 =?us-ascii?Q?1iy6rIh0dzM8kxO/zezL9OOmkSO3f/5BfYT+pyNV9FwgzTzexuBJF6yWBMR+?=
 =?us-ascii?Q?qlarTPKMJ3BiAB9xfejP8ea43oe7ByI4t/tyzSTlHbugPGlYQ1Z5hCrN8scy?=
 =?us-ascii?Q?D7DdHLcrTn59cvayLW0U/QqypKjKO3wiUnHOJzQ9ns4iOiZxTCGUPZL3Y+7Y?=
 =?us-ascii?Q?rFInTL6+qBa9Kj4hDcpSrrcFjYCVgOF/qYZ1G7rJwm5TJmdRxD9OzZGVH46k?=
 =?us-ascii?Q?rCC84LgWCD30AKkI4BgMPMi382eKdl5lPtnZzX2sE28REtOGzZBYNbm2oa1f?=
 =?us-ascii?Q?IK3u8ETt3swKL0I1R0xnr7cgxbhkM4tt34FRo9iFwfuSr3wmZCW7FZhMSPod?=
 =?us-ascii?Q?GU9tYGt3drXVyzZz85dd1E1h?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 711f7fcd-bbcc-4568-36fd-08d98eda08ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 06:15:34.8135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JfuO0AXiCVA1Zu+G88loCIGkdIXI0KVE2cfK1ZOE0QgugWxrS3Nz7x2huyS9APy0nnGyMOHQZYTmXULYX/dkPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Implement the ->restore() PM operation and set the link to off, which
> will force a full reset and restore.  This ensures that Host Performance
> Booster is reset after suspend-to-disk.
>=20
> The Host Performance Booster feature caches logical-to-physical mapping
> information in the host memory.  After suspend-to-disk, such information
> is not valid, so a full reset and restore is needed.
>=20
> A full reset and restore is done if the SPM level is 5 or 6, but not for
> other SPM levels, so this change fixes those cases.
It is perfectly fine for you to do that on your platform, if you choose so =
-=20
Hence my reviewed-by.
But the reasoning is a bit odd, because you already set SSU4 for your spm-l=
vl,
And on SSU3 the device does not dump its internal tables.

Thanks,
Avri

> A full reset and restore also restores base address registers, so that
> code is removed.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

