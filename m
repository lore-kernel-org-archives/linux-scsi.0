Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31B3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A42964E6B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhCANBt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:01:49 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51771 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbhCANBb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603691; x=1646139691;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=WDB/ngGQycQHGlpi2rlhuR5Q8GWr9UK90Ul2xYzqOkgzUwIR7GaompOD
   mhEAO7CcWyBbrt+tiS6qbJsIPZl7AJYiYvFkmIbl08UsfcBchdhhKNu7a
   K9D4KpVZjBD1NJ5w8vMxGhZCT/y5VUBgFbu1Ca/xhKeijj1s+V7ELAzhh
   PmiDlXo5FiFCqoVz4fM9LLUL36cqN9PLNJnK2HgV1tPawEzwvj+KUJEwx
   hjiOwJbFswVJxksb1Y8X7USVAR82KOtgZe2+WVzbvIjFwLtwifPPNI0zz
   BBsmxLt+wtskNhu34UCIAVf7nR6kvuk9bbJwCqCkG60QWZfX3ZxWczZqY
   Q==;
IronPort-SDR: 9qbvE8KB9qa5pnYfMzStFB73uPfic/i8AkZm0EXOYrJWk1+IDyL6BAo7337BQTcbf6rQaCsG2X
 CPLu0FIJUEiwMS1XMu4AYUB582FbwHV/hthsm8sbwqBpquVFf+j6GPWlZF4qHYFuHkoMBA3d4s
 BxUcjfZjiPy7VPa9TeGdSopMo8VEepoMttuR2XBFJE9QIS/8DVHwEdUoAKkXIWUmmHl9tOuplO
 OYqvFho0RvAZQEPGUzVjBLzDOyCYR1SPgl8av3qYJJcKhydZMDjdAvijaSTJTgrlQbIitDM8Ty
 +9A=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="162231349"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:00:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvZ8jd50cmh7++Shyg9c3FRV1Vv6Fix3PhOm3lPklUui3OHu8WNDId6yPaKT9WHnf7k286/np3NUoMKaEoS37mCdsjbn5IgkPehjlS7Hwgi/ZDPl40cvj35q9U66lNBABd4ftIfivFpPkHdMnTVdW2GAgGF3urhooGUouIcbsbRvsLT9InPmdQLUI5hSMKVz3C1zooNHfUOUCqKUdiFGTl63N4bWuT8cRoCalsWqlN0ZuYocjSQh5FEJefDXoNJHecawnQq++F1aWZ+TIFIVR6mkMiIepLbncV1+Q5rIt5aUGL/4jKC0aALMJ9VqPVj1AkIOlhPP6YGOL9G7wjTeNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=eDpgpZPTZVItfLdMfpEdOErMHQ0aKSsk+FXML7/II48LY3KIUa2+8mZZCrg+Yc0Y+42ITDS/DiRB6VubxFHAarcT4TtqJ6CdYNWsVCReROgky7uM9Bw38eLbRExUYlJ9iRxNgo9T/1JWUGeLlLI7TUXYHgI96ZPP8/92eGxwphtVLLXnZ5xNqFXSdAGX5632nb2IlDqWVMr1G6/8teTm8Gkcq1FqWkpRHmHQl2CA+yw7Hit99cJWMZvj35zonmhPw/sROrdvNoixEbxzgxSa4NWW985H62c1v84KEUG/rzfLb45ocVO9eIbDVHTXEBmS67eZ6XtHOzcv57VTImp8kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=iqJIBV4WhFhCFrte0RnOVknXgsxGbTuY7dyX1AfPCxrM8DHnZWBM3FT7Hw3SEwlO+aXYVdlV6g8bmw4jZI/3x5OLXzl227i3jf1FxhigIVBxwme80tH0gEIygklZxaqSjO6DHyBZyKXEXun3MirjHgx4xIeaupzpFI1xbFzrqwI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:00:23 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:00:23 +0000
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
Subject: Re: [PATCH 16/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 16/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZdKGptX3D3jaE6YYJE6eZusNg==
Date:   Mon, 1 Mar 2021 13:00:23 +0000
Message-ID: <PH0PR04MB7416C2288E21A048B1A59C789B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-17-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e2318e0-9559-477c-2eff-08d8dcb1f9f4
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7318E41A37D02FB4FEAD7AA39B9A9@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkJtTDFpHKIMyqH31l4NJUhrwpmHzixROBYtrT0651yI+fQpxs34hvD70rc8hfUco6T9pkIipK2nE9cZPZC9E+RWUpuRlqmpGlIAOv7vAJjutQsKkbd/thf2NSScFlMMVWQnLzEaIsbO1WbrrFLqeOkLKql+lvh32w/Wfb1I0EDRYVvO+8mwSFRvTVvl+T0R4T8pVGw90T0KAMJilZLTeuC5jQvoy3MVW/cFOQ1JZ/wz0hRbs1C1tNZVTYpofsaByQfPvO66ToWd9adjj3nPa+PkNrshkKG0iY36INMBxBjO8/0ik9xfDsC3g1JPf1R4zljq1ZhhW0M+VXhD4v//FBJOBUpYLGh0YFTjmv8xs5feg1Yu46hvlZLkpkVDK94cUM62MRCvzu21NpXUIyzSRSpiJSD1mbcKYXiaTx2CtMKhq5FEXI5gzDIwuVH2tAnIToRmEi8FeVy79qZE16+UIPUSeVQTc26hRbKA6bRWspgseSiVkEDq8GLP/lqWMG/6VlMNGwPflYojhphO8TFItQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(316002)(5660300002)(558084003)(52536014)(86362001)(54906003)(478600001)(71200400001)(4326008)(110136005)(66476007)(66446008)(26005)(66946007)(6506007)(55016002)(64756008)(8936002)(8676002)(19618925003)(7696005)(33656002)(4270600006)(2906002)(66556008)(76116006)(9686003)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2CYDBdNO6Lla7ipDzS68BwV1kP8LAr5Oo1r/6NH1gJBMHXcur4JZENCJQm6D?=
 =?us-ascii?Q?Oh+qgNX0ehUIYICIVI1IJfq5zbRSwaUKoGmBTvpR9rICSy5vxdKuTyi1KsHe?=
 =?us-ascii?Q?0alDC0enb/HARXjVFO/lDV7c7Kiz93yBtThWQRYXftSOHWNB7WCakC5wnUW5?=
 =?us-ascii?Q?yHZ3P0Q/9+tfcbMECo72e6lOh8oFkwFAnD0FNVFUOrLkOStkkgpEAWGUkf9a?=
 =?us-ascii?Q?qbXfBnWBlKjNtdGbQw0IXMZam/lPJdRELAM0k3VVseNw75wLqgdm9vZm0GBd?=
 =?us-ascii?Q?Gw62VK7Au948sW5YxYICrPBLudmW4PIAGaTC1+UvX7+teT60DjWCX8IT8RHv?=
 =?us-ascii?Q?GEV5tygKPJz/MDs7JYNin0OFFjMspeX0YYDKTHNvzh16OfJgysVJ9skVqjhC?=
 =?us-ascii?Q?xpif0/ITCYostUL6E9k+hq54L3Ck0lbyl5bbbWVxK1ZH/c2kqBPiRnHc+F0K?=
 =?us-ascii?Q?6C9/XxG39ffep7qULA1axWZILZeJvgOq51E696F0QqfY/TBoxJhERCrmc1vR?=
 =?us-ascii?Q?k5rwEusq/Kzl9hzrY4mcbQ6IbkmUffiIb4+ZOCfwduHB1fzDNEHI6erx6IIq?=
 =?us-ascii?Q?uCv0YiB9eRkVqo3bD7RvbgSdyCk5t63q4XSVFu1maJHOiqgcYt7dyOLiJcSQ?=
 =?us-ascii?Q?IiJUyIpJt+Z6z3jIhvlofy+mSHW0Cqu23putct+pV9DN+1Xc226xdzMjQz/Z?=
 =?us-ascii?Q?q0riEuRdXUtPJ4+A1D8deX1LtBGXckRugEPpmM5g0pTRli8prGERl1LmWksa?=
 =?us-ascii?Q?A7obH9etQ2YkleSaUCKesUyiphBb/5pfYMBpukPHCwumGUPKeRhCzoeteeTu?=
 =?us-ascii?Q?T7xQz762bFuO30iT9OUXtnMSIrSGpQeVyOON9EpjruyzsbPGyMhb0aE9KISt?=
 =?us-ascii?Q?T0AKmVEeg+1mNmXRwxJKfBBCg5qp5sA4oq7Sq+otGcjY7z4yRQEmayiasuVk?=
 =?us-ascii?Q?f9RHk16T+ZqkOW7zUqLKPWlSeiCkwkHGg4DtzFf2wI1XmC5lxg9AmiLwoeMJ?=
 =?us-ascii?Q?pCRk87NxlbU60+aB7JK2FFfNtOcuXXXg1GUrDsyXQrFZYjPHzF4tyEhmlKyA?=
 =?us-ascii?Q?h1FvbFzueOOWny6orgPbqOfEgHXPa6HpZ/N8IhgrrT7wHarh3cXFbqEio+xf?=
 =?us-ascii?Q?xEK1+SjoJi8APXJPffndNW6Chvdc3bYS8ZoNzi2t42RNkUkIwM1bgeGHZLwh?=
 =?us-ascii?Q?FExvO3I06sKCA1rLZl0DqsFymt+ypHOm/pfwN9FarCAGdu6ywSLNF6DAEY8p?=
 =?us-ascii?Q?aLOmfDqOoloaLBFUsvWQJ8sVSiy54BN3P9ddlzh3isUE22QRizXUR3+T4xSv?=
 =?us-ascii?Q?FbUHWykR7MxmU7LgQ9NDGEFYfIXyrzezpuWJIdyWVnN7tQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2318e0-9559-477c-2eff-08d8dcb1f9f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:00:23.2781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3dlqo66FJcRMo7YOPlNLyWCfGKf+BAlDyeaZVlDJWRggcKWV92Puw3DVrg9SNZvAzx1I5Ba2enBTFHAleCIp+Gr8fRjUuQvmuBGbvtwYWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
