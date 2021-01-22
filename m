Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9617C4321A
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 18:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F59A23A9A
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 18:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbhAVR0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:26:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51263 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbhAVQr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 11:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611334049; x=1642870049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jMnzQZI5mKluOe107ZO46XU3k9/4SFdrQ65cH6hQ7xk=;
  b=bE0MFqy7zV6DRxqdmYF9V4TuyRUmkGM74LzvykVAotrVrySWMROmydmQ
   4p3mAz6lS1yMnuDkWKVwENPNzlrQGqHsMkxEc8SUkv7wlNmZM8bH+FR3s
   IGMk8vdpKfnY9RmbsmnNuLjRtULhBUYHQEBRuGMJX8qHKvMuPWqCFRgmI
   aKIzq374menxaKgJmou6P1toxFKzSzZnudy4V5/asfQ1iXidOSycjOXVn
   T3XqUn84LN4UZFWlf5ObKicNno6HJF0vTvcBk1ZRgzTrzpRcI9ln87hxZ
   YaExhW5epCiRIRRlBzuwmwSioOZQSjNhPGvWK9mNzk3UAaOrDezDwUGvw
   g==;
IronPort-SDR: d2qrMZwMsZ5cAf/nAW3wMQ9yhdl6Uap4UWmER5G4Tp2GQg3fGISlD39gaqCGwSD7QlKkay++Y6
 iYtYik1EwQtiGsa7so5lPO5DzY8QQLqzghtQxPcvGg48vArOm5NBo8Rr+BBC8hgDMWl7HAfQwE
 oYG2xpRs6usGfzspA9RGdYhsxd5BIv2UpwamYNucCI2LNaWwpQcvLoMJHnaZbhsnT8M1mZaJk+
 7gYF4ZOZleA6tNRk6wMXL1vC42sGRUIm8x24vt2hlkZXN4BwedAWaCvZShUBiHeNyV04Yl2JiA
 HYk=
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="41388625"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jan 2021 09:45:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 09:45:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 22 Jan 2021 09:45:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVDPOcZ4Cw0pePXUt7gtsdQ2/5HfRFT1nuCC/tOkem2ET7XzdqebBMmnQmnLFz0HnSnjOHfjgaDgGXs37IaU8AivJt5prhyf0pnqRxzUOuS+0phNmY3oJgHilzdNwa6EtsyIejADN6islR2OaOqONRHTHPXgABivZT8N3Q6/uNXaD7XYwRV1HbdKJZ7Kr/VbgsbllVXAZ/RanidfmEDX6cI3XB8FB8ovEQaTQ1uNicip5+BxpSynwSQvwzHlPDHcdTf6W2brFIy3vA5nRU+5zirEE2qa+vGARO+QF7VuzYuDECt+FzKAkFxhY+VrsNFhswEzHxqVWu3x+cZrohU93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7zMFc57EFUI7cs2oMATDah2hGmhUQArpZ8ydvGc5sc=;
 b=V46+j0B/LCpdLVy8Mhs86Ijo+/iBEMTpwJBS0RFd4LolFslrBnnOoM6yXueNE3NeyG1zVXuzBM+YTqCXhUHS1sc6vioTm/OXf1UVkq79fkuptCXUG7IiKgbvawrUyAk1W7tEmWpWc03i8jdba0CQnOUxhoePCtuwGDDNkCHKsBJYq4ag/55skK9kg6CWH4PHcs+iWQxFLgJL3XkLENFPUN3SIoG+d0gLccG6415UyZAHuMnx4lopSeeBs9p6EL/vHsrhNuQZSKjteQxrFkj/oRSgGu5Mex37edv0kdhsFpRXtKtFGT1sCgukSF986M1cg2K3AgQcYFwJPMmTcK2Knw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7zMFc57EFUI7cs2oMATDah2hGmhUQArpZ8ydvGc5sc=;
 b=e1Rfei0m+bp6YydsIbwQDtQKfgKLGF3u/GfJcViUFiWZTYv6pRbHvvuZ/ERQrAxuq/qLWG3fPJKf+7AF42uaC4wXkhh6ZwsQ6rVz6sT64gCHBBK0LYDqqvmAtuZxiO89tVQeGdrWtnh11GQHLDx5fqmEL0y+fFF8n8JP7uLPg6o=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB5068.namprd11.prod.outlook.com (2603:10b6:806:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 22 Jan
 2021 16:45:47 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3784.011; Fri, 22 Jan 2021
 16:45:47 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 06/25] smartpqi: add support for BMIC sense feature cmd
 and feature bits
Thread-Topic: [PATCH V3 06/25] smartpqi: add support for BMIC sense feature
 cmd and feature bits
Thread-Index: AQHWzzRIt89qrNM5ok2u1y/ER965vaocimaAgBeRfDA=
Date:   Fri, 22 Jan 2021 16:45:46 +0000
Message-ID: <SN6PR11MB284867A86A867CDBC39548FDE1A09@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763249519.26927.10907963332068924699.stgit@brunhilda>
 <688b16a6318e11967d6032b94248db5f66b6503b.camel@suse.com>
In-Reply-To: <688b16a6318e11967d6032b94248db5f66b6503b.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c657d1e-a1db-41e3-e191-08d8bef52b03
x-ms-traffictypediagnostic: SA2PR11MB5068:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5068398E9B40F6F87EBC676AE1A09@SA2PR11MB5068.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UNkN6f6XyrMDMMvH5Ud86iFKCWt4HBsCjwbJaw09hW54SHOzwVt7u/3OCJS3EYg5wODuExyqdFLmto1GK/UChfxzd9r0+ldpH9uf8YlI2/NLSRQS3L+vNLLcHGGc3+k+gkjeq/H5zR/IabXj9AMSpMKzeXpm/U3zpfX55wPOuSYBjyiTsGkYrBvJBlaARH+p5CMmQSCCMr8NbuEQc5x02S9tU2ICu5X3HR6qn3UPJ2hKBGIJB43z+6WaYH7yedFUNqv2ERj9f/yD/SPY3rqhzH337d9baJYkFq+bn++2ucA8R5UXTpLnETiKR/gLoO69qn0YBzMS2ORkTPwta0wYnMXy8YBPPGmGUB5HmLNqtnPkPOhkvdK3aKz+uecyPG/DaTgftvE4YSWk6klXDBDixtw6Pn9+w1CgOKa5XzOSZmC3WNds+9vauxMhTrpm1Qzg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(5660300002)(8676002)(921005)(83380400001)(186003)(26005)(7696005)(55016002)(8936002)(52536014)(4326008)(6506007)(9686003)(66446008)(316002)(86362001)(478600001)(64756008)(76116006)(2906002)(110136005)(66556008)(66476007)(66946007)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4hGzAnbdTr1y+JYXWwljwLy2o7mMM5qfOOhq8STSXi+fpSKz0r1pB3HJKEn5?=
 =?us-ascii?Q?hhNd0v6THiYIwDYR3IJYcBWoPTH+s7Fsr0wZfl0xUoQvqAyvVGjikEMkK8k3?=
 =?us-ascii?Q?LuHMqUQQY/4D4n3YB/y8vzuIJWaC/5nXhmYklJGSmv/gByPiLnfbWpjU2XXS?=
 =?us-ascii?Q?ZdgA0vALNDRAWNWvnhfymPNmSTCgvUSws4Q3KhKD2HtZ9F8zgj7Mpt0nKQR9?=
 =?us-ascii?Q?Y21DTkB9+Yutj28ztk/tKuwjvZkG+HkVQZFYT4bOYDO+87zEHJpmnjnk5j8W?=
 =?us-ascii?Q?RuZJwEgKTWUE2lR94VKE/hWZXLIkiTXJ11O09LBrnC8PmpLWsv0a8VqSegOh?=
 =?us-ascii?Q?hP/hceSUnGRrow/QcrnUjtIbV6rgIoUUY5cnwRkKSxhgNWt2oJ6lFlPaI40q?=
 =?us-ascii?Q?fGJmJaExoXC3XhMbhDVEMi0Kqn9zpAJJ4O/gBZ6kInU31UpTZpMRTE7X5eA/?=
 =?us-ascii?Q?oWwojOPf2ukkEKj82JRhhaGW5/sqsGMhGzg6Wk7bfgOb6HFh4ArY86MQ9uFS?=
 =?us-ascii?Q?pcTlqBU4ZzAUm0QtRxGE8TAdRSDEBJNYpMWanFDVBL4ADJzPMFeKpR8yNaim?=
 =?us-ascii?Q?Kmdr3U8ZEUKrY5D3pl66hDWdvlUTCvHWxq8YlEofTpAPUtVzmA3c6PmHHXEw?=
 =?us-ascii?Q?RVUFsthjJW7/SBY375FCHUXX0NC8aMApD34vmsG0+5IDRmH2nDwxwymUWoFt?=
 =?us-ascii?Q?C7Busc4oOJ2C7hpRELvMlHaS2lPwU5kXS7jtJ1J4lzTOS2RjJMPOGTqE6Ar2?=
 =?us-ascii?Q?oRBSmmPHNVPBookiO8qH+PyUW9ZYTq8FssRasxd8MT8iu6AebbuLuXkdNI3l?=
 =?us-ascii?Q?GvSrA5cDGtvgSbFTz+wZq8KmM6c6WPfA71WCiuyKe6gOkVHpTZc1XuW2Zea1?=
 =?us-ascii?Q?3EVccCVTlzuiFsq9BFGkXvEYd+0+ZbtGT0um39qhVKbEG96mp5wOSfokkZQf?=
 =?us-ascii?Q?wY4IguIpPHAfByxwyPPdA4s2cwLqM94s07hxTwfl1owHF3bpoPw9A31NTkHN?=
 =?us-ascii?Q?9CfVnx+OV5fHE5FBb0OWD60cgqiB/pEs13spN5URW8JJSyDmQZuhMWxcU4Ch?=
 =?us-ascii?Q?JcB0s4R/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c657d1e-a1db-41e3-e191-08d8bef52b03
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 16:45:46.9075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VkNBfHACVPr2YEVMdYGTcVyZVZsV9RS6KHmzcSQ8+/u56S7Zf2qR8e+QIYBZsVtAh2mB19Up8k6fB5pEf1o3pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5068
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 06/25] smartpqi: add support for BMIC sense feature =
cmd and feature bits


In general: This patch contains a lot of whitespace, indentation, and minor=
 comment formatting changes which should rather go into a separate patch IM=
HO. This one is big enough without them.

Don: Moved formatting HUNKs to smartpqi-align-code-with-oob-driver.

Further remarks below.

> @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
>
>         pqi_start_heartbeat_timer(ctrl_info);
>
> +       if (ctrl_info->enable_r5_writes || ctrl_info-
> >enable_r6_writes) {
> +               rc =3D pqi_get_advanced_raid_bypass_config(ctrl_info);
> +               if (rc) {
> +                       dev_err(&ctrl_info->pci_dev->dev,
> +                               "error obtaining advanced RAID bypass
> configuration\n");
> +                       return rc;

Do you need to error out here ? Can't you simply unset the enable_rX_writes=
 feature?

Don: If the call to pqi_get_advanced_raid_bypass_config fails, then there m=
ost likely be some serious issues. So we abandon the initialization process=
.


Regards
Martin



