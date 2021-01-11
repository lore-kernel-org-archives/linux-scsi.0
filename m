Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B0FC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C7D22AAD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbhAKRXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:23:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:34805 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbhAKRXU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 12:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610385799; x=1641921799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H8o67FjEoYIhPZK5danaCpumvAVKpVJTPHNoe3pDAhU=;
  b=b0skJgt8gOEnKG98ks4Y07oWD90WaJ2UTQxLXfEWciC+Zqp3GSYF/IpT
   LF8+108O+MZriBKz7Fuozu93yl/4eOZ2PJmVl2BwRcprgIWdQpAEWBSYX
   0nMv3nUCM+7H+TFfmJ3gqVrPjfhX2drRuQ7lvxjja9BcQXNLa80iNlLff
   UX115y5B8rd5HpT4ABK/DQyzmVDWopLg32A5xSThe9v0799uPKgaTlERe
   X8ygbW5WOOIqF+I2DLc4ZUM0Fvpaiux4oLVmaKSgf07dIeiFB3gluqGmj
   iWbCegKmzbQrvDkdsXEram3Al3cgVYpGQcb9vvKluzX2e5WWngHWh/f7L
   A==;
IronPort-SDR: HD1V5MLnK5qL7ByyBez0dlTiWqHXqIdifFxsvlqZ3BdiurT9F8IKkLPvSjMxUOYFcpoRFzOK9b
 kMCIhEfJRQ0MN5NDv2/dBNOTWmvmZQk0P81MnOa6ZmsFKkH7HiPPXLmFBneHjYi5HfeAHSpSKY
 VZt1qtVB/wr98nK7DkQonKjIvWxWMRp8LmS0Od5QHEORo9lQgehR2RfC1Gsgced7A/6MnzFN7y
 5K8tpVZq+9hYLLsXJmTQGqJipPO4mOVKsq1AA3Z3l18IlAoi3v0zsqWo7tH+fydJpcc/7vuvY4
 6nM=
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="105550316"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2021 10:22:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 10:22:02 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 11 Jan 2021 10:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrxptVQmX62kn9DYxcPPbhR4eY49cqbuxWti2SKyJRmaPTukQOawDeiy7jp+NUpT9ocJZUhHk0eYZFqBF/UWywbCHLAsZjAy0gzTajA+51Em2ENkylnsU9IP4umIrQC3A6AfO1zkxnO1Wyler4dqyUWHuMwFwF8OvuXkcZvyRU0HoUDKyWI9F+rAL4ZLmVLIxipl5riQueJQHTwAzUBMvFnnFLHT9ocLG1AuiWNjXcN0JpudtYNOKIunEEvJXUySgLT4/VL93rOvaxufjx+ewkNV3utQ+WMmsElV3X9el6N6fDQ7Eoz3W7HeP5DCRj7DkB2VBBuWJUWkEwNcqVZOLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viWJ6D5GDctwzceKeIkvmUHOsdh9hXCHtl4oIuLyd8g=;
 b=dc0iJUTRiPeyz81aY8a9dfTVqkncWzjgurCYI0j8oYw0xFURdvF6qj1pX6gdZtYBOsFWO0FQOKYBprZHuYYfFlQymBIBFwesKSbaNgTtIiK9OmX+jnpEkzfjOQTLNjFKBKqBK1SKNZxIJsRpIJi+fsBqQq1xI5JZpvk9yyOXKnnRLMzEck6iaczWs92tTEFr7sHqFM2TYottx3YDmwiaxQvxZT+fb+N3Kq6ltqoqATzqRlUbDuBZpIb1bfDzO/YgjhBvbrUSl1QXP+HdihpvuEmafHjyFbQiuY5+BGStWFTDhau6eOduhRvp0jMZcaPKKt83T26uCtJcJFoIIXJJ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viWJ6D5GDctwzceKeIkvmUHOsdh9hXCHtl4oIuLyd8g=;
 b=Fy/UQP+a2KeMHlCKOjakMF5j6j1BQnVY70SUlsl8340L/VvMXnyFqb4G3rsy5yoY/Yg9kERnz9d6TjSadIHbnJCJc7JNctVBZHFmtXp/q3MyutpoIiiYh2rBcD2DtDRLMCnU5klYPH5CEAsNTq7Pc4g8aoHUhLgmSXNja0tPhdQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4702.namprd11.prod.outlook.com (2603:10b6:806:92::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 17:22:01 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 17:22:01 +0000
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
Thread-Index: AQHWzzRIt89qrNM5ok2u1y/ER965vaocimaAgAM6vXA=
Date:   Mon, 11 Jan 2021 17:22:00 +0000
Message-ID: <SN6PR11MB2848EEEDE5E77DCAC5935A7BE1AB0@SN6PR11MB2848.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 1c9ca2a1-893a-4817-28f1-08d8b6556850
x-ms-traffictypediagnostic: SA0PR11MB4702:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB470280B13DED8EA1DDD89672E1AB0@SA0PR11MB4702.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7RLNmfWX6fnqGuJo+d2kJOprNRZSfKx3rWdbP2qU18ZNfcj4eWQtWjJvG/3ywmgrVLLe5quMyTh7vzzOR0Mh8CFjz+UKQM6fxIvkX9gE2aHMPuEsRCreGY+aeDXZwsxWiv2yL3tlxf1AawrIPGyrTSaj4u1gzijOV96evdL6WxmaaFgDwG1aCoUsre6+94b9X2PPDSlfOd96EPg8uqlzVTKDGjU7YEeuAaRj94MtltnhyaZ/IOMDDVIFknDIHAYIu3odCw2U7oFCT431n2TTQ3UX7nfHsJND0Hv/qxQk16LNmUAemUyce6B6ITfeECgFrmyMkFVEY+79yGi0OgdBUSzrzmpvpBAwtKsPDWEvxqo5UsZWl0/L5ttFG9v3NmPjMhP4NgVVM10RiOkyviV6fSvvjGW2Pe3TpXA/lLCJgBdRqwSMfeZeBHzyrchc4uZl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(64756008)(66476007)(76116006)(26005)(52536014)(66446008)(33656002)(186003)(921005)(86362001)(8936002)(66556008)(66946007)(8676002)(4326008)(478600001)(71200400001)(9686003)(55016002)(83380400001)(2906002)(316002)(110136005)(7696005)(6506007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Z+IItR+ddLN6JbefHarZFn3MO171HbA0sJEwq0gnnLL5ug3dD/VT4G75j3os?=
 =?us-ascii?Q?ojiEeVDIzhQhdqBf5JyJcwdKbSaooDaYI/kZe4mc8i84NEvNT3JCJnuT4jT2?=
 =?us-ascii?Q?pKoWzg1ccfU1/JNX/fcm0KfoqZ//7RukVyAhEPr8qzrT+YzrdMXaHy4ZySXF?=
 =?us-ascii?Q?xSjRu59HZVGb8uaOQeXdTkHq9r+irgsSOLCqvGixGgg+9nyTkaU5I9tnd7cB?=
 =?us-ascii?Q?7AqBfQed+tRvWO5fCHkS2Z/0UoH/1oyX7B/tmgDgnWMSq5+0g3FUoYE+BB13?=
 =?us-ascii?Q?okF7STYXDKxk049xttjUpEmn1Ezc3eBVSDEevxPQ+If9ewkaI/iXIG+0IIA4?=
 =?us-ascii?Q?7AQGWgRquzUqibYjzHLOhrj0dbnltbWt2I3itKAZHEgsKp3r9Yocq3uj1m3F?=
 =?us-ascii?Q?c2BL2vjszmVDl5vHXb8inl89hOItw36w/iBhktjw5eh18TO67MeS8t7n+mdH?=
 =?us-ascii?Q?bJ/RxU6BflK+TjjWuK24OBkZhNowKfXrzV5AVAPEl5W3bQtjl/36krNKTRx9?=
 =?us-ascii?Q?7Lv0E22QogCSNb1TY164ZvekOzaH1cgzLd0Wy9OXek8qOS8ofGBWdW0fQH9g?=
 =?us-ascii?Q?df43keWL80I3JMOaI3teg5kvopUqSvtA5glqBTQ8146iXN52gcoGTubq4K2A?=
 =?us-ascii?Q?Ei2PTfRlPNlgRPVtaBbgSschz7PCmi0K84ih6wfgEge6Xi7EP0HQHbqN13w9?=
 =?us-ascii?Q?xY9UWg62Og447vVxp9qReuGaenikLOCTmiiBSQWKo2qa/4U4+c6DTA75I+XT?=
 =?us-ascii?Q?e/5Q6Lhn0o/nxtjwolT9DGM9J1njYaKEcFYtgEIDaRHMaCb/Mk4mWCdqXdA+?=
 =?us-ascii?Q?RVUnR23YqknJAZ/JPujhS4mE+4x/vR1EDa8PXWFFP+AHv50sE1iBfc19lD5m?=
 =?us-ascii?Q?N3R4MA7GqFH/13mmH+4n9psh5pwQu8ZGZ5eGY2D7sI/p839ECsLow/oXCYjX?=
 =?us-ascii?Q?WI3gVCs6vIXQmkfCe98l7xcvfMmLPSmM8KhUejr3Z/w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9ca2a1-893a-4817-28f1-08d8b6556850
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 17:22:01.0245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GLc8S9QljhpZZ9bq5e+YuLyhSiVn97+0yf7iJ+UZaSZS5/APYtv6OGNpJwROLDOMRBfWV40EJ2XYL1da8mNfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4702
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subject: Re: [PATCH V3 06/25] smartpqi: add support for BMIC sense feature =
cmd and feature bits


In general: This patch contains a lot of whitespace, indentation, and minor=
 comment formatting changes which should rather go into a separate patch IM=
HO. This one is big enough without them.

Don: Moved formatting changes into patch smartpqi-align-code-with-oob-drive=
r

Further remarks below.


> [...]
>
> @@ -2552,7 +2686,7 @@ static int
> pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
>         u32 next_bypass_group;
>         struct pqi_encryption_info *encryption_info_ptr;
>         struct pqi_encryption_info encryption_info;
> -       struct pqi_scsi_dev_raid_map_data rmd =3D {0};
> +       struct pqi_scsi_dev_raid_map_data rmd =3D { 0 };
>
>
>         if (get_unaligned_le16(&raid_map->flags) &
> -               RAID_MAP_ENCRYPTION_ENABLED) {
> +                       RAID_MAP_ENCRYPTION_ENABLED) {
> +               if (rmd.data_length > device->max_transfer_encrypted)
> +                       return PQI_RAID_BYPASS_INELIGIBLE;
>                 pqi_set_encryption_info(&encryption_info, raid_map,
>                         rmd.first_block);
>                 encryption_info_ptr =3D &encryption_info; @@ -2623,10=20
> +2759,6 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct=20
> pqi_ctrl_info *ctrl_info,
>

This hunk is fine, but AFAICS it doesn't belong here logically, it should r=
ather be part of patch 04 and 05.

Don: The patch adds max_transfer_encrypted field as part of new feature sup=
port. We would like to leave the update in this patch.


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

This function should never fail, so a failure indicates a serious problem. =
But we're considering some changes in that area that we may push up at a la=
ter date.

Regards
Martin



