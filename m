Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64717C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2389264E6B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhCANH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:07:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26261 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhCANHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:07:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614604026; x=1646140026;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=CVbse2MHkbC4rwa95gcRRuIm9za2QWQm4OfU+BNwtnIF91IeWEhuaWE1
   6y+4+sESd1tDX7kx4LRQ+14/Q6EKWwcEwlpcoW6cX74TqmjxyGS1oxBoT
   Az71USAhSE9W0/koasAjvE9298mmBzoNfws2AglBurlyNx6Ks2x9yPxBg
   dQm9Hxyhzsz5xwUEFdg8HmawF3FE3faNsCiGvk+vfc9nSknqAXgkDG2wa
   Soj6i7S0fSUiBSasqy3tRJgmgjJYlioJGF4AMZPMDFYQadsrq7IAOwNQL
   OIx3H6sA3ylF9xedf44jYFl993sEuLi/V9jT0xkc/Q4XRF3mGj5S1anYI
   A==;
IronPort-SDR: JPzy2c5CjGZZcPnyxlP8TW6JlyVlGThsfIg6tNCyb9RybCnEE1JmMW9Fzfo3TJDB04FKBZ6XiZ
 yL7tGDS0NucLQCu90Jc9L6c4ELH5zGHxqaxZI3PQlp1Rlm4JV5u+Kwe09GxddsUFq3yxI7hv1b
 8lLJwQNy5gyWB5S8/n5kKaADcCumWlmM8kj5FXe12OPe/FSJdu7aNkfbxil3tM4+8XpCV9oxxE
 uHSmdVGifdnMsNsA8NNvtJgkgcuVBTXB5iGtxMwY8Js7j2soIKLozRNtbuEYgb+uqUxE3fDnl+
 l+s=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271661123"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:06:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+bboL5IECkYbJQLcVp86QYERhIYbXmX/hOlkgJqwckVAX5mUKR4znJuV5il2+5WJ7vljqSXUGFTJO+B5vwGtt8facwJSnMiwkXSmqrXora+oNGtupDDX+QHGbXjzgeYl7upCl5BlfWai0sOi6cBCLe3Wh8C4LXr7zDaXlgd6BqjQPNZgA9yAWdxPMptijW6leRg+JegfhmZPniimkjhfnu4Ndb0TfuztWzK924pRDZmoDcg25FUYzwuS01G+idEfboVrbqoR/uNW1SHHyeLBVeftlgi4e7ZRlW468rV9BhWnGYiQlkSzJu/28VZ0T71PeFmqfi+c05GurHbwnjDPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=LU1or2lAEW25xPhs5Zwq2QUUcqkKXDdUMP4dP4rW+qBVgaDQlKVza3VUS8F+ghG4lRlpyF9F53yoRqYt/FE171WD+nUAF2cJKJFtXdy4D8V5jsXYNKcL9RfhkWwS5Po7tQ3GjNz8sdVxx/8S0G0cNVB/UBTU4i7ecDHnEtRNsQNXa32vx1xl9vongl7LnEFYqGOS6Ith2jpYkCdyZn0EejM6wbRQig9tTQWG0/PgCoHkBDyAwIZbgpeC+4sveMIgmppxgzs8lQLCkP9AsNT7f4I+adeZruiFKIcG96vkQld2XoZz9AzoKYpeD4Cug2xyKoAjLnknhpnYyIzmH9l8cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=BMipJW7e6sm2cyGCtx+aFaYKn2dTcBFvtKTrB0atcXtt3z7wHUJ59kn6OqhFdyMVYRoc5MD8Ww16+HavjnjxTQMuJXEZEswFl5+nTPbIRQ4vixGbQZI/ZGk45+kTXIdRCBuISTtkUHqnfEFKjSe2UkAvtGL6ETn505A+0b4mFeg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7256.namprd04.prod.outlook.com (2603:10b6:510:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 13:05:56 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:05:56 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 23/23] target/core: don't duplicate memset 0xff
Thread-Topic: [PATCH 23/23] target/core: don't duplicate memset 0xff
Thread-Index: AQHXDZdBp1c4eMNiMkifZM4DhG61qA==
Date:   Mon, 1 Mar 2021 13:05:56 +0000
Message-ID: <PH0PR04MB7416976C8BE425EB3BA1538C9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-24-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 852957e0-7471-4a3d-8dfc-08d8dcb2c054
x-ms-traffictypediagnostic: PH0PR04MB7256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB72566EDF294783640C2678FA9B9A9@PH0PR04MB7256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XZpzssa0A1IX0uXZDjnjPv1dTF3tL0f9HSTH/jP3kcmuc62Pwu1/Kj13wudl9FkD+GU1Uz0+HKhPwaJg5+r4grobRVzzpU3trRsCxzb2h9bh10kzw0jrkYudtAL/FDMFBCB57kIJYexdXm+yvnLLnSk9lQNvjlmnit1BI/EmxKOZKcx1zKeb6uow1UhcVdGCbsEL8OCqYIbGgxuZWJXaHmbjkLW1G/Qt4tWXSf1f/MBnDurTuKbWI3q0Rsz4wwXqiKE8cPIESBMTZwgfuZrlH3/AZFyBBwo+8H9p019KGV4gswfuGxu0FmVg0DSp4yyLJ1cid5398wBzHEK1z6G/PWKcE4+wy6wmjS/9EhCftwAO9FIgZbRQZQSBQirONnB6gnSGlSfd/U9jXdkfAHSHE360XL6jjse7ovgd0vVdfEtsJ05OYpj4Uagj5xK9TUzVHh2sbix8MWBbEBEIZGaBya3etrQGTPIT1F6wlt8j2NHvk5MDjuBdNotVuK1hAR1LboGtShVCZI/LyZkVDk/ClQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(110136005)(8936002)(186003)(71200400001)(33656002)(6506007)(316002)(8676002)(54906003)(7696005)(86362001)(52536014)(55016002)(66446008)(76116006)(558084003)(66556008)(66476007)(2906002)(66946007)(4326008)(64756008)(91956017)(26005)(19618925003)(4270600006)(5660300002)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PAboC5AlXDP0Dxh/xNEX6ncLAim1cieln2X2m3eE7+4zXUjZThrNam4xJIbv?=
 =?us-ascii?Q?1piiwnhyj4HJUWay9/aElA4K96qSkiYptvZebiDvOamhFv24aYMfl26sVZHm?=
 =?us-ascii?Q?i2oTKSxcjuX4fDlrKOCLDUgLpOW1/LJAlcB26tfHNgGrnhIxPciMqRWbwU1S?=
 =?us-ascii?Q?G5AmftcInFTA7RSsXgavjvHXFywllkWB4ANGHgcSGyAToR9248HW+aOBF/dC?=
 =?us-ascii?Q?uCzAfSwW5QotFK7OjrBLhEHY2gu6eo33dCZMOlBrDGAh1CxUb9kl+8lWpg8c?=
 =?us-ascii?Q?6VqREU/bk0/tkBLTQ9+UM7X1ReMO047/D5afyuvgjA/Vo98QPIUEj6rWUZzI?=
 =?us-ascii?Q?NnE5xysKD7pkp+pEohuzG/yfUPW58CjWCiHZCZ3S5P6MCEYQLLVvigyTt/Ez?=
 =?us-ascii?Q?wkIZ0m4t6j0N8W/tgRtvKwbr4ar0BzDvU+GsP5XvgYSuF391FasMoXUT+6/c?=
 =?us-ascii?Q?/NuAqKYRaf7DgNyLoYfMAkpkNpfVoECSzqV4YvTMCtpZrjrWUsuypdx2oHfP?=
 =?us-ascii?Q?yIJQbZRofOgcK5pk5n97N+gaSkAD3jlmk8+yO0BubHnPiJN8Y1ohH/FqDoXd?=
 =?us-ascii?Q?EDGA/g4zgZ7UDb5tdosjB8jOeagogT4oCxg3Z+wSVOjILf4o/9A6GJ6BAfwn?=
 =?us-ascii?Q?xAfxrSxrCJoWK8HqJhkRHA1xgJnsZQDO//gIsYyCOMdCeMpOgEaTAW7mYFkP?=
 =?us-ascii?Q?YI3pDJ+yeKA2D8BoIXYtq4B0uTgZKWjWUNAwzhmV1JAtWa6+ieMfdSbIpJ43?=
 =?us-ascii?Q?L7hPB6Zw42t/bfBRf7Cwe6rT6NXzpL4alq+Zvi9IRfis5iRZl33m0S5tnhr1?=
 =?us-ascii?Q?hjZwUxGPa50MV3bgmux9oDy/mfdh/+gjA6SP/81FAJ3WQKHYQcmmJP9FhZtF?=
 =?us-ascii?Q?JZafuzXBQLbsslGgpWVqmYJKEBgo2B1yUplodqlAs3enHhUEN/hJRB61eYqV?=
 =?us-ascii?Q?iWp4oecYKP01S9bEFOjQ5Xtbh7LNJSDTpNZB8A0kr/+CQH+hN/ypxfvlPWQs?=
 =?us-ascii?Q?Vq0yLIPc9eB2/PSYv+9el0bN8ErVcPsCxjeUdIToBKXwz0SsOqJ8ePbUg4Bp?=
 =?us-ascii?Q?w8vMHxUlTWQvTaSGFxjjSKXwdXtgGRlbNieOuj9s6JeRZlIzAQeutNFCxhfJ?=
 =?us-ascii?Q?MK/eKc8gDBwDOLavy0dvZKLt76ppxI70hb0VebPjchJ8GpjN2NT3dkghCdD0?=
 =?us-ascii?Q?EAOIEB/Sf9JXvF717OcrJ9CBuaSGnomLCh73KvhmfU6HRJsVQTHm+ZiCn+6i?=
 =?us-ascii?Q?ngt4e3/GjnaYf1EtdL4fww3fBQdB+J1fqrM+WvW+pn8Sy87RJhvVcVcsCVKG?=
 =?us-ascii?Q?MgPQZUVb2sWRrFv6dh6UkmbI6bZE2N+7XhtFnZ9pTFh9kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852957e0-7471-4a3d-8dfc-08d8dcb2c054
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:05:56.1055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: woKkNbb0I0Rs+wyYen6kRPvbxGJP92MsHjilAZo0faxMDgJjJl7ruUVADBNBNiBi26jPIABWzANvu3tYC7M+KBh02qFq1igwz8FFGzBeYzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7256
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
