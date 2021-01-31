Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7B1C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A583F64DD6
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhAaHJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:09:59 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10426 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhAaHJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 02:09:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612076973; x=1643612973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZKcHtOH87LL3iC7JfFVuiKxNnbkUhuqvFzjs7jaMdBg=;
  b=jUbqqvrHAHVBsLeP4+ztSyqNX8YvMScs1OtyhmMDUyUuNltE3YGMDlRl
   QHW9B292p1idtehIA31cGiMhMrQjM/grPGZMoZQVLHVWq8iEg6XZ2Nt+P
   g/QLDFvg3KK+JBvmYHL9eY1pJxWCNsFybRiE8LiIEHN7Qw4LSjHsiGmDA
   aHekr6vVsGSvN7WyHjakgaGnMBNjGwl8x3rAJvhh4bBsPDL/bGs+d1UI2
   6ctfhFWmaa3YzbJPDcHKQoDQBQIyfWVYihhGn4DEjt2BoFU6SKI6d3fBi
   SW7yDZR7lUtaC6j7LGjSyk66fkg9vG1GWrqMQfj1pq7HKR1rOBlB+dOCx
   A==;
IronPort-SDR: cRp41gVM3h3jvV96CfKg3dEYJwXqlGgBXpD4NcMp+UsEISAX7VBmsMCIZ7R5rSUDZsEdN8Ze7O
 DUiMVVyP8Tj4B9W/OJmKp66SE7gpLlIYlGHOnNdhAinCvuASIz8KpWYsGvlFGUj2aVBjN/q1/M
 vPB6/jcxHXsSGF0FluXsLMdd5Q6Jn+wIf0Uo/7NLhxy2c45BD0DrsvwFpbnPBKalaRH1fR1Xd/
 FB48oWAD3nGtudd7aisIGoVKIT1PZ8KRCxQ7ggMje1gdaRLMb8HcH8VvavzgHqHPq/WWmstMx0
 msY=
X-IronPort-AV: E=Sophos;i="5.79,389,1602518400"; 
   d="scan'208";a="163174863"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2021 15:08:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl4H8fokRKSX8BBlYmfA62jxd2MYXJNQ4f2Gc/WISVXGx3nS7igX2h8IKmPzK1x1jrZ6k2/ZMrF7XvhBpJZtHbBYC1NXvsXgdnoBWP2910VACvb+ztiZfBeFyDH97SkGe36RvNFyf8tI9Dt0XMqyy6yVBIP9XMwTyb0rcVoFln6ZOqr/8VBwiiuNzJ/E5hdPLOElZ4fY3agd74dzr8kHw3Q7TFbebocDP/uoPhrXAVFeOp1BuOJLIZHXJzUL2G/AD4Su9vL3EWRsUZc8zIFWjOgJbjnUP8QnalHsRna/YWknnF8NTQzinUCyV+fRpYYhT2B7Q/+qUvPs3DtridiCzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUjopHxsltI32R+0nV/Zot6ooXncw/GPNG8xAya5Bzw=;
 b=T9qYIl6ZehPlB2hQxmItsrzt/gIYHqm7VbrHu5B/31ozknn0nQIuqCE1MbV/W9+7mpICNwlnp14xMqNKtT6nL2KmkkkdLL4Me0EDHu37d+GAWHNZ20F7U5eaC1Kn76m5gq1JxtIL5HP4pjJZkgmaaZkYDMe7I6M13DUFadawN9mUHaDCPgccuFhl+A/TG4nJrIQxKXJe08IGbAr8viKMoFofGAyYmTU2grP9lUA6coiURvxFyMP7diDyYjDey4UzUe8jvGinoEkH08nSsWo2Sk86H+8Hys6Sm0EBu8rGlmCcJqlWY7Lp9ClTziEk2p0CMuXbMzgeIGOQ5YyBZAV9VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUjopHxsltI32R+0nV/Zot6ooXncw/GPNG8xAya5Bzw=;
 b=mjjorsyTt2Q/5Z0FR3VqLGgmryeZ4WLWigKEJEPxEL7h6YOC/ddzXvGyAK+8Cn2UxjbFBhquGldKNX5fziYkzm9EJlWWYR7WHieGqqmEvVH+SAUBsRS0WfMaplsOzZt6t43y3+NTka+FvCOYmfn9MtcolxPhpM75ZAflO9KB4Lk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11; Sun, 31 Jan 2021 07:08:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.023; Sun, 31 Jan 2021
 07:08:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Thread-Topic: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Thread-Index: AQHW9L7nyZFYPn4n3Ei9SDx+7JRxj6o7liWAgAW9V4A=
Date:   Sun, 31 Jan 2021 07:08:00 +0000
Message-ID: <DM6PR04MB65756785F53B6D9FDE581013FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-2-avri.altman@wdc.com> <YBGEh4cfPldXoQxI@kroah.com>
In-Reply-To: <YBGEh4cfPldXoQxI@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a958bb0a-4497-4c60-1e9e-08d8c5b6f1cc
x-ms-traffictypediagnostic: DM6PR04MB4154:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB4154ED296E0BD56526483D07FCB79@DM6PR04MB4154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T7rgFlWilufBmxc0G/bIJVKhKpKqbgFH/c27LiZPZexCizo1S+kyQvM9rGydqF4jaoWT7JNfDb0+ZcOEBJO1lwAf5Nb0aB3D0Rg6FHkjX4zlMUdHt9O+sgjfdyB00kCOxfrKKj9Xrg1bm3QCKYZN7GsrzylQTf3rQN1ZTmCNEGxdUg6P1e3dqOufN3EvYJm6oFUIw5BUSYfLs79y34pZPo20QvCSUSRPuAiSTvsetsQYSX61QR5COitSjauOLIob/pOY4TqJz+BHXQ02VdM2Exe2ZzNWI2qC+zWVUzeKSeNh8vm/S+yHevtsX8cKPpABPUJIaWXzR4DzP7Ae5WywNvhyvM7gKJeovQzfC3V4J984jQo7GHS+wUbR1ij/S51CHnagEzFOnGPNlNcFQqrhzpPaPgSguqoojMDcdyWX4R+611rlKlgZyATxiTCWO4hA0NEf9oxEXlD57LvKHYNpN+BF8Wq9NE/47k16HYnkuR0aZfaf17+Jmo4BDtygdE6r28xcwziKdM3xTatFa8BKcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(366004)(346002)(376002)(54906003)(6916009)(86362001)(6506007)(9686003)(186003)(478600001)(4744005)(8676002)(33656002)(66556008)(4326008)(66446008)(66476007)(52536014)(316002)(66946007)(8936002)(2906002)(64756008)(83380400001)(7416002)(26005)(71200400001)(5660300002)(55016002)(76116006)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HCHSLHu400ZZ2y88CJOpIpQYELE2mZTWwaTimJYURXNi29pYxgeBk32QI/ku?=
 =?us-ascii?Q?uPZsxLRixVDY6v/ZVTtTheW+58movGMzrrA98nDvm7ieZrTM8amtVOqoFYMx?=
 =?us-ascii?Q?ZLiBf5xQi3wcsSTq5dezA/tnV68uNqQLF1csSDZRzvmlhDL9Mo883ZpNKDpX?=
 =?us-ascii?Q?67dCuA5Obs5mFKXB1T/sRZpFmmQI6/2/Uc57MoA0IN90I665Ru3g43V0peuZ?=
 =?us-ascii?Q?EhOV4KP6a5u5cMe8WB8Vb5Vsfq/25YqnZvodUnBD5/LIU7VJTMz/ff5nwcPw?=
 =?us-ascii?Q?psF9qUMUwvNqfC1Hbj8FsXIk3WgUtNWAKnINcdW2PF7eTQQi4zHBRxU2u7tS?=
 =?us-ascii?Q?gsc5ri4UmASWbWarnlnWvCuNmsguF7wN+S+1hdfJhCuHNsGYoPlDU2hFegtc?=
 =?us-ascii?Q?By6wwRJkSQrbWz1/xfWWWSay+7dDlwhFVLaCUxu2YG3pmdzlkjMkjIo4L0Pr?=
 =?us-ascii?Q?z3Wg6LjBMQwDe9WsKkHD5vSamtKR/NLCJSQTKiPEY4jYyiU+XWGmJC1JDicj?=
 =?us-ascii?Q?DxCKBLk6UksheSkDOC5qRXG3SE8dCk/fyzfSQnHZnUx9BJZaGXs/GnU0Z5Wr?=
 =?us-ascii?Q?EgGgT+g30HaPJhI14xjzuVVYm1g4SVlEkI0f+3QhXBJ95dVemNhaieZZLxoG?=
 =?us-ascii?Q?KkOeCUTlTSRSX8K9DqEX6uMtRf/CJqKMYX9FpAS2txuLNQsSQ7hno8HL1g2E?=
 =?us-ascii?Q?dng/Gy+v9VCc4/5iERoTclPc9E6BGN7rZYuB/f8LlBFXPeiWO9zFa9wKVOcr?=
 =?us-ascii?Q?O+bct3ZCbsZTuE/dkgaruGACPW+xHjOsWOx7DBwrDx6HQiBvKSmTGiGIkq4z?=
 =?us-ascii?Q?MH6xB7aMJwC7lFMV73Nz4cZYrQFXPth+oL5kyggIC2j1W2STzAf6/FUtCqbd?=
 =?us-ascii?Q?Md1M9ilQCdCFVZAo5ZOlRx3uSqwqLvdGsnGK5SjLLT0bh++Ukz3WGkUG4erD?=
 =?us-ascii?Q?4sOmXC6h0Y5SWLxs9gceoMnoCipj1zjHctaqX/RzZvKUcvK6DzJTv6kmlRhy?=
 =?us-ascii?Q?pwtNyVOKrxxj1fllVOMdvP3ZBAERbDL54WFya8KTtO5sdm4jbYtXVvEJwLXz?=
 =?us-ascii?Q?+s+69LLv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a958bb0a-4497-4c60-1e9e-08d8c5b6f1cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:08:00.3395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KEVFUSsMSSMsKBFtMLwrwr2iQHtqwxzahAQFK0XGeDiABbGug1XRIqtTZEnWk23SCyCgjuWHyY6EI565QcpQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> > +static enum UFSHPB_MODE ufshpb_mode;
>=20
> How are you allowed to have a single variable for a device-specific
> thing?  What happens when you have two controllers or disks or whatever
> you are binding to here?  How does this work at all?
>=20
> This should be per-device, right?
Right. Done.

Not being bickering,  AFAIK, there aren't, nor will be in the foreseen futu=
re, any multi-ufs-hosts designs.
There were some talks in the past about ufs cards, but this is officially o=
ff the table.

Thanks,
Avri
