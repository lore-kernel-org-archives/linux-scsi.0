Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399E6C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 20:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D766622CF7
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 20:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbhAKUzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 15:55:06 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54060 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbhAKUzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 15:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610398504; x=1641934504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wF5z1juOhytTEXYDDc0WkWOJPrIzpmDscluVf8sKLwI=;
  b=FKPfPnr6KJKdMfasc5ovrX1IfGwLPyEv6XbrR/4DzkC81mnOtv3zejOs
   hVfJS2bilzKu80hIsReL739+QViBNlwaJTwUptl4Tpybnia74e7ywdOGn
   nPwJIS1pbHFIcjOSpluwNhSwrswfek0jC3iuEg8pLEWw2Ylkif6/WDkmY
   vslocPvRDFfTGEjXtIfl84xTCwBFjq1wJ3AYQPT71yk3UTVjUsqeopNXl
   IMfWY1PzXLYGOeufkkFjBpTeRvNkRYEWYJD2PlkVAi9X+2oFT5xApaxJh
   bUA84Dndu9z0HtI3LhUk62BX/PktS3TtQIgup3qNVBN0bItipaDr2i/a/
   A==;
IronPort-SDR: Ht9Z6VPVCYWdg1lXrrgJ+T4aDUYbjjoFd1YC1GliQIoEhuZuidq5dOvsZPmwfao+kqg301OXTs
 c5+TOUYpD+I74KGGwlNOtYMxBAPNnK/N2lPLeu62P44FTHYvuuLxTfB5/LmC8kyUOeUBYq+/qn
 DTYBsYKyb/HX+VJ0027Sdw8pTB1ru3+dqUPWs/+WSaJwTEQ2YyDmbA3kFcgeElrVCP6pqch4FN
 KLo2mbnuJmnvAW9uSWVXXgQpSozO8rORjbEJPI9SovtTw1d+2UzwmTIITnJpdzqdtMrrT53szB
 qag=
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="110613145"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2021 13:53:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 13:53:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 11 Jan 2021 13:53:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeBwK/6mnX/30bPXTMLxJY3tqzaS9NQ2nZ3wYJA1DbK4NUSkIFH7UXsJdawDF0Vwn6cW7p0hcCiMm3q0+jXTsg6RaQK9Qnh+Reu0wQJUpEB9Dvjfo+oEd6gTmbCajZZyTPpI0TQnDH3nnRCGhRtUUYm4DCgh56XIs0kWHm9xKhgAbBWyq0CLht0rJfZWCM+7HC9TMSKLCUUzMBRw+DBujTUVLh7Ge42YUZxSHcC+iqWYaDj786bY5VfVohBn22hJY/p48q5xCyr1bQ8mEoH3BW1gR+gx1WvR/984pxAf3Ay6qKR92u4cSRShkQw48TJ0D6UQfsXLdPc5Fw2R1dntDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCAktD+c8yVCCWMIRdQpZgpxjAmxBWEWZ7ppLowKYCU=;
 b=M2NOnYGlR4rXIGWkxmyHvZM7/IDaJ5kAdfI2N1U0c0HHlvsd0wkCpt5Bh50b5aZEOHZ6how6PhhWP1ymUGJpUXotk7zSp8cT9zqf90JzyGSX4ipklwnIfJbeELMJy3axuth8caNbblEVeTfpR7yugc4u2qtNYsDgHnjQtc1tX6nxierdvTw3XOdKFCGuqlx7pM+swPzWgwAkD9z0Y02EfzoHrTLVG1zwjxOgnQRfuXFayNvRTikZzG14rHj6DCfxkuaPY0RbkfMVQAGU6V4BO93/Eny+icteZZvlQbIi8yZSvCyM/BUSuqiGVhI4Xt9Fe9NJyBpPqI0m1tDRLqGHnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCAktD+c8yVCCWMIRdQpZgpxjAmxBWEWZ7ppLowKYCU=;
 b=ASDC/W4rZb6g7D7B7AlZlLfJyTfNtg5iCMs+zahzd6+mI9v6wolkJeZCANGRK9joMgfcCA5MCY4AgF5EC8FDlSpYpl14WCeNwAUJDJjFRvrnzxM+9uergw1E9t0rroRAduDqdc5eehULDoWkgu+xMdREhgzST4j/3850QbFF65U=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2701.namprd11.prod.outlook.com (2603:10b6:805:54::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 20:53:17 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 20:53:17 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 07/25] smartpqi: update AIO Sub Page 0x02 support
Thread-Topic: [PATCH V3 07/25] smartpqi: update AIO Sub Page 0x02 support
Thread-Index: AQHWzzRIQPDjXVzpgEi8h+Qf83sSVKocinKAgAZ/v5A=
Date:   Mon, 11 Jan 2021 20:53:16 +0000
Message-ID: <SN6PR11MB2848D8BC7E383F83D02885BEE1AB0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763250110.26927.1557519699967861731.stgit@brunhilda>
 <d084a9fc0757a0f15e860dafe8179679ab620a5e.camel@suse.com>
In-Reply-To: <d084a9fc0757a0f15e860dafe8179679ab620a5e.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b469134e-4d14-42f6-379f-08d8b672ebc7
x-ms-traffictypediagnostic: SN6PR11MB2701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2701F3C09C2BE31747C1A848E1AB0@SN6PR11MB2701.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUl7g2WQLQmduR4+wMXJnrNzct2Eul7ufsTlNI4Sqe4nPWna4IU5RK/j3SEg1iLzds7inNiWVvbiV13jaK7kyLkXhWgODD6cTw8D4mDnWiIfny6iDF7TOpbyjUoXZGl8iru9gCZaNJkNIetQxvIUPQQ34bzF5e3GRQOjvNQiUq4mEpmwrkwXoliPMQ21A4NV0mVsiAD+t/qifgDljyvOe5Tric+XfYKlDKzv5gseQVMzEt1Z4dTtapSWhuirhm3qbsB+5V5PVyBxumEYceXt0uXizSnnnAb+8cgf/S5JpNHLZhbapdVwBkff0rRgvs435UcaDOQPMTdVVTyK/7+dbQWO7704Z7Gp9BwsFQhoJ2Sgos8gvKTOeb35CgFbwhfxGP8uUR9iy5ui6cBL/9+p4Tx/alGARuURAVa4b+JuANqqW7bt0wqYDC10MXcqnCCk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(66446008)(66476007)(8676002)(15650500001)(19627235002)(66556008)(186003)(64756008)(76116006)(2906002)(316002)(5660300002)(4326008)(921005)(33656002)(8936002)(6506007)(478600001)(7696005)(26005)(83380400001)(52536014)(86362001)(9686003)(110136005)(4001150100001)(55016002)(71200400001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cFrItMcO+HD1zakBanfj3qUS0jDTC3AOlLXmzfRNVf+KIXE0rhB0x5qWVUSO?=
 =?us-ascii?Q?oHRtzvEOhsW/X9ZazdWwmEw9pEpAZ233ygnFXewI6FweSSAxc+7a7/Ld7+QN?=
 =?us-ascii?Q?c4ycF363Q7E6psH7979O8AjMz+n1EUf1iNJbLZodIZvfoz7guia2cHBYHbUm?=
 =?us-ascii?Q?Iog2gTPo8no/lcvoNOKbDK/EbbOJebTh/8LML4J8cDL9ayOoVhJgg/sgnHCI?=
 =?us-ascii?Q?VU1oI0xyAWiVpMCFYo2fiIb21/fFgAaEd9Niqs6+ZZQMqwwo1tvAiDZ/wIrY?=
 =?us-ascii?Q?N5Pl2NsStm2gCX9XmYWsj0F/v3Ma0Q4vwDQVsU/iWlpluGUJwLIVZ3hlJBFO?=
 =?us-ascii?Q?qa9wmkY/r25HoXPGb47IcLYvi1Zb8WHWNYL8Hn1HNsZUvZsr+hJ/d7zuzdLZ?=
 =?us-ascii?Q?Rj1tiFJ2l3WGoFAkh7JWIYCxuw7RqCvm7nEpii9uxjt8jC4HVud+jKzPbrun?=
 =?us-ascii?Q?aszNypPVYcjAEbHP31JQsri3hiKMjsqAqg1fRvH61HO4eC49QZd3taFgq2sH?=
 =?us-ascii?Q?PmjeeAsaWEdx0j8xuEoWxyhAfMmvh/qi2+nCj13+U9OajzgKtYyKe/yqRaLc?=
 =?us-ascii?Q?4MXAphc9ki+4Km/umZPDCf8jdfMvLtztZ06CFlf77VPQKIQZ3oLRkxVEu08L?=
 =?us-ascii?Q?eRi50iJIDKZXKZivCygmrCgDQi7kC99iSgb4xYMHNf8w2LC1tkEHyAk46XZ3?=
 =?us-ascii?Q?jVZsqD/VMVywMq381qpUQQ20BDPClP9c0Ga7DA5rNkOe9OCZbwMHFRjQNS1d?=
 =?us-ascii?Q?G5CBwVgJr/dF9T2z6Uzq2zdxTKHIbuf8Xucf/fcKpCaviJi63OHrnzLKVD1X?=
 =?us-ascii?Q?EX5DP8Y/bQJjXEjsqtFvrvP5Ka1GAmYNsr7F4Km01bLH5g1OBH7ahAP57ErI?=
 =?us-ascii?Q?Kubu6L/Igy0f8uxta5OfmtcSkSIsejwU6ZUVOh+ioQ9zgL7GU906aimB1uto?=
 =?us-ascii?Q?UYM12OtoTw5Mu9bHqY2eqrc6DbAaYMNBDs7NDb5qiwg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b469134e-4d14-42f6-379f-08d8b672ebc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 20:53:16.9734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vUjedCKPv/7esyuJ71gdfEFbNd3pj4Kprv85ZgQ8vc1oNVeD9wCvkDpIwVIO2eCxxww34tSjjVx7VfwCYzMBdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2701
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 07/25] smartpqi: update AIO Sub Page 0x02 support

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
>
> The specification for AIO Sub-Page (0x02) has changed slightly.
> * bring the driver into conformance with the spec.
>
>
> +static inline u32 pqi_aio_limit_to_bytes(__le16 *limit) {
> +       u32 bytes;
> +
> +       bytes =3D get_unaligned_le16(limit);
> +       if (bytes =3D=3D 0)
> +               bytes =3D ~0;
> +       else
> +               bytes *=3D 1024;
> +
> +       return bytes;
> +}

Nice, but this function and it's callers belong into patch 06/25.

Don:=20
      * Squashed smartpqi-update-AIO-Sub-Page-0x02-support
      * Moved formatting HUNK for pqi_scsi_dev_raid_map_data into
        smartpqi-refactor-aio-submission-code
      * Moved structure pqi_aio_r56_path_request formatting HUNKS into
        smartpqi-add-support-for-raid5-and-raid6-writes
      * Moved remaining formatting HUNKs into
        smartpqi-align-code-with-oob-driver

Thanks for all of your attention to detail,
Don

> +
>  #pragma pack(1)
>
>
>  static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info
> *ctrl_info)
> @@ -753,33 +766,28 @@ static int
> pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
>                         BMIC_SENSE_FEATURE_IO_PAGE_AIO_SUBPAGE ||
>                 get_unaligned_le16(&buffer-
> >aio_subpage.header.page_length) <
>                         MINIMUM_AIO_SUBPAGE_LENGTH) {
> -               rc =3D -EINVAL;

This should be changed in 06/25.

>                 goto error;
>         }
>

Regards
Martin



