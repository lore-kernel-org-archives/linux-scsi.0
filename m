Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D41C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiCDJac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiCDJab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:30:31 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CEF15678D
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 01:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646386183; x=1677922183;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Fa0CRvWz7ZqXGApX7hiOlcJgsHN4BLMhhZfjSHJhu5VTc4GW1roor+8w
   DMrYnybHqJJglUCC8BrQYGk5WFOFkRBm1ZS8e/gfw0C3fD8LVtsrTlcOh
   wQPdxOIcJEpkXvpmCOoeZlGtebVwT9PO0QLIXqENnJvrSDYIF8ZR92BqJ
   kWtaW1LgJnUy3+JBNG5KNHZq7wmZuuAHcNnYyi8TiQUrxKrMN0UvIknwA
   ZxTXRBkqSZlcu4Y+gyeLmM0T0MMpZ1NcQ8Pr5InRS88AFdyLfGELtzuW4
   aLR5aZ7L8glvZNqhBMaCLYI+hOpT8VtpS/zxhqc/iqZMCpm62H3PKXUNV
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643644800"; 
   d="scan'208";a="193413965"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2022 17:29:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVu478zgr3fYZn/Rv/8M9aYJY2CT1wZQYx7xfp3ZEVZl7VFBlG4R5qWTe8bsGfDqNH7/2W1W1t6aBgLHxkSK5QX1048boyyJra8MkWFgxFk+zpfmsM7LHvXTAQt3a6pjqiE47dOz9CeeqqL2qI8GG/fL6UheNEdqN2rQey2eX4sCr1Z0TTiay25yVBZUX66Xe9hLon0H+jMAVVMSaLpoDp2Iyc5NyUD3XkX05KnF/TbdAHgTob7gLbuCGTr8s0JrumY05JNkYPIeHSr9dkhnJZ4A7/5nlAS+wAEQqRe+ANfpAyQADgD54DcUW3WzUKC9vPOIMAJMdMZ4ZAtvqEAvew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=KJ/tO3OztfaUlgKEJDTYR5bFqv1awXkv7CyPAodH4QPwlfmja3RkzRwlLpcbjV5eeq6UMhlZ584qa2bgngfycFUY0xGa9BM7HWduHeb6oJkDJex3aVies157sjkNe6wvMWUuhTMNzYmM6xD6qGb94nufUIQJIRhhEM0SuAZLFfNS6YxsTBeyKOnDu2FYilbTBMh02aDTzAacwEILi18XFx68V38N2tjw+NVgGmPrwfBGWl+n7rSd0mvtbKW08QjZtY4CAkC/eZzqVwjr5dc7AqWbwoDsqMtDQqTZml0o0OEr4SguE47XBU9Ni1vPWkWua2kgoMa6VAcVEFFao7y9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=rABfB6sPNAG5+hWcR8mlBQmqTlEuNv1fC9jjrYaDi5wKUmFEjnA8EuXvcrP4u0z7d6owLit+erTd58AR/cmubZV2HzIA+qX5APhJadxM2QTlNCTh5lEYOrehd936oBN+47674SfHSd/mxTA4l1H2pRC2qWMu8HSoFB0XWaDpc28=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM5PR0401MB3703.namprd04.prod.outlook.com (2603:10b6:4:79::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 4 Mar
 2022 09:29:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 09:29:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 07/14] scsi: sd: Switch to using scsi_device VPD pages
Thread-Topic: [PATCH 07/14] scsi: sd: Switch to using scsi_device VPD pages
Thread-Index: AQHYLfeC17oPMgpouUy0WBC/Z2oOdg==
Date:   Fri, 4 Mar 2022 09:29:41 +0000
Message-ID: <PH0PR04MB74166080422EFDD4019612679B059@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-8-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 101167fd-3b7d-41b4-c673-08d9fdc18313
x-ms-traffictypediagnostic: DM5PR0401MB3703:EE_
x-microsoft-antispam-prvs: <DM5PR0401MB3703F6E6ACC952D2F01E6A339B059@DM5PR0401MB3703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UVhnLycfRH8/5v2rbG/jg/4mYOnjAx8oLgISDACqB81bJJk67ENnPUcym+uaxXeE+j/OH3A87B65U8BOH02zm8bdXC+eyl6pTho7EY5tfUkZOmtffDtjewdWS7OycnGBV3O22kQqiCJhjQF8wW57q5YZtTSgqYJxVlNRRABJCOu3besPyVYWtCHMzSbSNfMocFW8+3L344hrMhbsIc6n19vs6+U+wdcfx+bWg1t9RPf7vmN8yMe0UANJwt9HOh0EMjmEo3PifpM1utPXKRkt8fP0cvJRcQe0U3Fb/6jbsy87mTbmUmz12Egy5elNH2Di094i+GEuBpsTPTqyO3z2Bea+eJ+blvWdWxwMDQHEpxhIksL7x01RR3o9fdXUqRwXp85KFJvAzUJgW0UtICOiI0yUDgwvhEQL7G9h83UyTTb9T6+Gwnp2536wFxCmV4caOz3D+iwpmT0vgrYuYe+UprJAz/1UzfEGf16TnjlbOZ8O3LEGth9VaSbjbJ0IuYssOWFpInCzR4NIhTy4QyW9bu9q832UtK+XmLxjqoRU3e5L0ZVxzysB9C0B9L4O+WnEZQbai1Y9FnFqNHkKF9d4rWGXYBF7KM+Ng0sLlXCgqnG9r1uopd96kAOuriypCy3JY2WMXy7mED76h4/Eo0YC2iZy2ZIDT2XmFLw8BSkvFjhK9FtDIuOmWq/IOsG3BqO3lbRHa6dzwdH4PQz6IeGFmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(82960400001)(122000001)(186003)(8936002)(5660300002)(55016003)(19618925003)(558084003)(2906002)(33656002)(52536014)(91956017)(508600001)(38100700002)(66556008)(86362001)(71200400001)(4270600006)(64756008)(66476007)(66946007)(76116006)(9686003)(38070700005)(66446008)(316002)(8676002)(110136005)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kQWM5Rxx3QnJBgPRwhRxQXPcMrvnZ/bgmWfsyqyEbaoC1f+ZGsgfU2CevQ3/?=
 =?us-ascii?Q?U9dHYD5PTt5gpvqgHze4GjLmBz7pvKaTdO8CQvzwoH+Kw69woFu7mc0BDMtv?=
 =?us-ascii?Q?OCUA+enTKY13+kwM6rLbw4N99YK3rGA6ntNMpYLj3ximwNVKeW10NmdMaovN?=
 =?us-ascii?Q?DI8E9PQnIykz3E1D4aAD9aBf/xwSO+BzSOEb06+0CADNk8fMfh1GEkK/QrAy?=
 =?us-ascii?Q?Z2/RjJskwXldLy3iU5nsIlIozf38NYyqG199opuJ56hiIuwGMEncT7OAXrT/?=
 =?us-ascii?Q?Nbk4il42Skf/NKKbQaDXtw/fmnP7FgFf0/jRvSHpqQsxEvgPYEEImK3Xoa45?=
 =?us-ascii?Q?lkqFUMbfOR+UID3KndQndqsiiO5BLK+f4MOM+nc/OrCwtjCG51eE0joCLCFK?=
 =?us-ascii?Q?rEfpukw2oiUbn0O9cWdzKjSSBaQ7T2oI0Y50zDHG6z4gB5l4Hs8+WGclMj7f?=
 =?us-ascii?Q?HONHuM2F/90+DNUTV4T+6OUiPt657rfIOOO90xEJ6lxM6Cmk6GY+B+pdl+87?=
 =?us-ascii?Q?/tX9hyeLpaxgbRvMVK9L6+lRH76vcdvBf3JntQq03XtC7MWMuA9yc3AezuCg?=
 =?us-ascii?Q?FlDcsvlHGWxR1Y1tdZUHxnaKsztSbQttXayOuN+cbl6Hvpx3rY1a/jrmaJ+m?=
 =?us-ascii?Q?sK4VY8qseLLFJd0yD9F80bLgqIqueRlkBivFW3FBPWA+7Ah2sh/KGeCP7xdM?=
 =?us-ascii?Q?8/u2mPjQ/bZHwW0Hod9ZI96GxKXkCF6matrMgvrfcPFk0Ulavn0voH8VVjzP?=
 =?us-ascii?Q?Dimu5Q66INb0IN4uf6LD5PzMsaNISM4GLefzTOK6LKx9naFBh9/E2EdSJgR7?=
 =?us-ascii?Q?mzBtZeCHf32yuN//FLXy6ETM+CFOn2rd/BmgwJkW8/ii47DZoLWBehNsBI/l?=
 =?us-ascii?Q?15yv29Z1zOvByUcSd2qc9h/D3JZfyrG5EAoGZ3pg6d4o+eTK8F3Jta/6ESX/?=
 =?us-ascii?Q?/GTnx+iuYhhx1+nO0IqPeB7GUccQeMQzzPvzogFhfJmj/NUBDGCxOwHnxCyu?=
 =?us-ascii?Q?zmo6le69Nua65mVBw/yXM0fP0+2TnCyBHe5HTK0AvzKyFqOqfXbW4X9vesIZ?=
 =?us-ascii?Q?rkll5arvapykBKYqS7yxs218a/IFwRXR/nHbXZUYpueocbEDU5CK9IRlOb87?=
 =?us-ascii?Q?4WpJngpCqsVd3FwE9dUPdSODwTTqnhI0zeiks3EeVlps+7oY6QbaDoOFtyV5?=
 =?us-ascii?Q?mFXvxJIOGxMJEaHRYR0HnXW5QUhw82Zc4x3SI23cNvgskgd/YlMZKkeFXDuH?=
 =?us-ascii?Q?qG2MOQdP3dyFJWIfwenUMvAtzw12N813wTMmvJum0QdEWaEo5ssgGyZ4O0z7?=
 =?us-ascii?Q?yLPTxH5opBgXoJoXtUA/1uv4fzApPQqTorXN/5KtTGVYpf3SSj+dgpjNy7yE?=
 =?us-ascii?Q?h2/CMMSKEx5DigsNXAZMtBfunG6B30kd049AYwJ0pa5TGwKjKpoMMHlJVOiB?=
 =?us-ascii?Q?PU874yjoquSOpZrDyM8/OfAbzDVB2J7EYTApUqVOygE2R7qQMKyZlR/q2OPR?=
 =?us-ascii?Q?xIc1phcG1kY6SloBoQku+2zDwydqVjp7de2o0Gg87p5E/rCi9iLOREIW8vsn?=
 =?us-ascii?Q?CC0rbPVxImldcfQFD04GC6mJi6jmpahBmuF3cn48Kl8CR1PXJC32XSc6VzZT?=
 =?us-ascii?Q?hVkV04cyRD7M5Un3DY924xqw3X4Z9p+z9zg2k3LfbT9ougQXI1JsGNr06eTB?=
 =?us-ascii?Q?+nn4mos4n/3NKlJt/5up6i76cgFEcbmf437PmWJ42Iu6NcHVEbvPN1Equ86V?=
 =?us-ascii?Q?PR05wnnJ1c4LPaQSmA7ovpz/VCirztM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 101167fd-3b7d-41b4-c673-08d9fdc18313
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:29:41.7857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d7PYF4R603+1v1k5MRE8v7lXVwJI2aIqMP+JYTAxZM1Z9QkRGAQRwfYwZ3BV/3Mi54Zy9W8twpio5rOB5LZNvv8lMiyg0zjSglAuWZUTebo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3703
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
