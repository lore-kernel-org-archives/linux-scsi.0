Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E527EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 17:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A38CE64DA3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 17:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344041AbhA0Rkl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:40:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44028 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhA0RkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 12:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611769221; x=1643305221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KyOWUZfJBOhK5BKgnvAZFYJ9Pct2kJXntun+GgPEl3k=;
  b=Y51PD+z4x/MaCTWQ8R4i6JB0nfejkb8ir+iRfH3hHSVXNozYob3BF7zj
   fTcth+l6F3vB+ef4zkdRdXH1JDnbqxc27oTF8Scsvz0TwD8Cknu8KK8MV
   rnQknuJj+RhH6yPW46M+WZ8OVVzt+QIoQ3he++4+coyLsaNnUBwCgmDLY
   bi9Bbs/92K4Ta0clFeJEWOEf9RiSXVVatQGqiBJIVGpxksjVuKPgXBsgT
   pCyR/03agSlYGtReu+8OG5wCwxdw4NBp6DDgd3VfynTWOh+AVJgxcda5/
   +E9e4hkJTquP5eY+FUggtzyOaf3fJYEV/357Olf50fZiPBFoDtU9xgEfl
   w==;
IronPort-SDR: NiQTfJIcuF6MBtEsNZjE1ujv1KevjjVVAVfnHWQ6u8eWzLv4x09KpyDpldS5TOpcMsGWjFqceW
 igJZ4J6wIjelt7jXWnJsuIjNSxGhY9WV+v92iTw3yJ88vqHIEHwUqN4eSX0s7R0+sxHPpGzmWO
 C5P5PL8Lz0pXkutDftR1BflDHQfueAZhF53vGT4WVyfPBwyPQw1h8s+VtxPipBFvHLZlVGV/0C
 dkynXCgGb/1elXEi96PVPvc+FYPpe/auS7zpCxkrqumXnpFC2NL9aP+/wuNY7ELIT9HHodHOOO
 BoY=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="41978533"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 10:39:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 10:39:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 27 Jan 2021 10:39:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzQALixQCAd+URPEH2cCE9AsaVb9xu8mYB2IIvZ0I41lhMjpVALAk/tqg5mnnhCjJnNZ0o0xagukt2bYa1LoaXVKzXIa7yHpdesAPvxqOQtOpz5VThsMN/pUi3z0X0Ccb/EUf8ecDomgdtAoGwjLktz/+YfLwiR/aSeavwN/NlGTX1QQg/Grds0x9EwXYkyfTTOw+vSxc5U1wToqT19NUULqMiReylxEkqBC5NLpno8hsqtwZfPWU7VCThMNPXiKsZzebtPhQjDPZWloUnKcnq5J4GVc/PG1bBZ84TkS4AreKU8oIYi5oHcWR1CkdSu1KPxGwCXz2b+wqWRkjxwNZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YCIHbfhWsNyWz7XneQBsz5crx1EQSnDX6JpITbSzYE=;
 b=n2QsURbO7cJ5jYOkY2ZL8/t01bGUic7kt1JAhqrGFAF81FuSgF8h3wuvSmd8e4qotfVWwKIxSie0beppOsp/ZS58mPZjZDe3WVWGI3qK61O5c0VJb6o+Ps4YdM+fFWkVPoqdM3f7Dc4vg7nuUGNxO3VGPkkorpnV1FAyWTNir10boDScDGt1v0YtwekKHbys/T/vy4ckAuVGbK537qaP82vSN18LY2E9BEOpnkqdko/8Yq6yXliMNKxOEwxi+Tb38FpxB9NwSUrUL/0bBjj4+6wLoHLMXMvKJoL3f4CjXhkS+x6fuQZJIHXHMeqkVDNIOSl5Uos2mZt4UNbWxiJzCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YCIHbfhWsNyWz7XneQBsz5crx1EQSnDX6JpITbSzYE=;
 b=IFvc/HrZIpd50H62gjMNl0SEpU38+2tqJtt6985mjP8swQb2q8TvSalys5pwHRafwGdbDxMYlrgsN3UFuMMeMVeMP6iKoWAy/Si1wf8g0pa7o0t0JX9pyWSIyUirNK9HBXFPgUupXCRgKyPYFTTXIgFbudBte7ugNP/3GzFk0DE=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 27 Jan
 2021 17:39:00 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 17:39:00 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 23/25] smartpqi: correct system hangs when resuming
 from hibernation
Thread-Topic: [PATCH V3 23/25] smartpqi: correct system hangs when resuming
 from hibernation
Thread-Index: AQHWzzR6H92pk3ZLa0WfyGxhBW04YKodDaAAgB75V6A=
Date:   Wed, 27 Jan 2021 17:39:00 +0000
Message-ID: <SN6PR11MB28483741FE24DBA749ADF6FCE1BB9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763259402.26927.11602719287229380898.stgit@brunhilda>
 <42c087bddc3cc3f83a2c6e3fdd84940dc204ff5a.camel@suse.com>
In-Reply-To: <42c087bddc3cc3f83a2c6e3fdd84940dc204ff5a.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb01606f-5f5f-4c12-9887-08d8c2ea6e83
x-ms-traffictypediagnostic: SA2PR11MB4795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4795CE07CCE61792BE117196E1BB9@SA2PR11MB4795.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ily3hDdQpPh5w0eTaGfKjK1WTOXAbay2pPKkzoDUgUEJyBiY7Ii81FpAKPGKp3KngWBivgwhOYz8cDWoBtSi/xDmIQOPFuj6t1UgLRmu2RbGpu40HO8yuoOiIhQhC2K/vZF6Wd4EGvXcYSw/VfPSe19Xx/oKVVQ0gI1GxUilEgfM8wVlGyip+giweKcCtaW6uVL2Fv552vrpS3l1veXMxDQB7JiYKHXYetql1o2OiMde8snK7nTr/sOtET4egQbU+AWmAKFQS68PZG2r6lvvoJsL2fe1LbjF58oNRx7z5aMK2xv7MomUuMqVjXy2h3yPJbH8XjK+Kce3/NrqtCsfl4rdx/G/Dp2JP3t69zofsdECVKQBCY4Yfu71VwxpG1xbCmFvGUTskLHgXq9wjjSS1rX2gCj4W/+45jCLWqqIiZJV/5yPyi8OaPm+552Jami5lkr+cOvnViNhwbp9HNtCCLhkQ4ormNuwnxgqzBg59hK0SBhF0Bp/4kQi6oPX483nhOI1dmaCB+qMz/8O4OgB4iBfx8iR6MQQNnmnbQj2ytWO//HIdGAw750V9nwsZYnb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(366004)(136003)(66476007)(66556008)(66446008)(33656002)(86362001)(316002)(186003)(4326008)(64756008)(76116006)(110136005)(8936002)(66946007)(5660300002)(55016002)(83380400001)(921005)(26005)(9686003)(2906002)(8676002)(6506007)(478600001)(52536014)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3HMz2OrHSqIM075RY8e/o9LOQuAnXum6OGXsp3Gkuv7KEcFaqsHNPmq8tM6m?=
 =?us-ascii?Q?bdaU2Gk/U4Strj2WkyRG2o7t4gIoBgup7e7CH+h3bzq8ADKui9uhrrhhXf9p?=
 =?us-ascii?Q?ybAxLLTkCZYefNUCceZheLhNQGM2FvIW7/cRJ7zihKVB5t4XVl5xlgqBQpqx?=
 =?us-ascii?Q?0DzsaymycvSyZS7VMYKyCGWlkkj90fAoBmL6XEF5Dm2pn7nveUKm9KRovyZ7?=
 =?us-ascii?Q?NxIAN00pKcVQz6PJ/+yL3khKSCTyTBo3j90Zps88rRe6fxxohH6Zx0rHvlda?=
 =?us-ascii?Q?hfzvx8SXFFdaZwNlTl0RFXWnjsiFVIG70cKzf0EKQ+wiLW+DTB+eWRMAhuqK?=
 =?us-ascii?Q?oO+OGdbCNw6ST7Sqy5eHLCzMP+Jfu+yq0CqADrbHXevK6qY4SKGlumVuy9aU?=
 =?us-ascii?Q?7aEgckbc61Fgxqrj/EfPFYLwDdUhk/Vds5q96MiROMX50mhwcp7NNuMs87zi?=
 =?us-ascii?Q?3AU5Cfv4u0AnrEBL427M3iLNHZ+BokcTRexTi8imISdtct3cO5porKdePQn6?=
 =?us-ascii?Q?+foFzk/uNI405R/enuYcsEv+2i91X+g97kNVZeyuVkKrrnv6fryFsX32xVA+?=
 =?us-ascii?Q?mvZHvQI1zUxz6l5DEo2ySCCWrrA1avB75urlscZGL0shZU1NWXK7yIEHrhe8?=
 =?us-ascii?Q?PwTs8/vJA01MtNL69HxLdmNwUkL2o5mj61uEDP7GI215OepKjWywHf2M3D1V?=
 =?us-ascii?Q?RRtyDvYKZxeXhB4mZ/fYQTy3N332vOov3n+NVsWztsIwV4HVbOROFBvhXghx?=
 =?us-ascii?Q?0/fxBrTE7J77L+dFP8fEgWTQ5antgkpZjc5JXcuomaNa1Die71ZQm4EICvE9?=
 =?us-ascii?Q?lY7baGsmKNSonCuXULRtTM8E7YaBKhc6OVQKmczLRK1fjmQBTOaazuUDAi35?=
 =?us-ascii?Q?UwtmZy5ute4fg/g9qmMG9fJh9nhgLP5Up4/a5rzmNyr9A/ZigahGYAS/uBvn?=
 =?us-ascii?Q?6sVDF4GijnhMI15XdiYNU7mk05ZP0XgeV8g2zoyaUuE85NHmYcJGPFQGQKqP?=
 =?us-ascii?Q?VFQ2UKty+QD1nfjZU2Xa7/T8fqmrfpFfaNLnq0HNMjOJ7+UhBnNxGUzW9dOA?=
 =?us-ascii?Q?xTnq32F5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb01606f-5f5f-4c12-9887-08d8c2ea6e83
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 17:39:00.3949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qg0zhEYnAfLXcZwgQlk+sPlTk/JA9LfdmkoH/2mN6C0Hb3Q5hsmceXtkvuSLvL17O899Vj5iiFHIpA8Da8rjXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 23/25] smartpqi: correct system hangs when resuming =
from hibernation

> @@ -8688,6 +8688,11 @@ static __maybe_unused int pqi_resume(struct=20
> pci_dev *pci_dev)
>         pci_set_power_state(pci_dev, PCI_D0);
>         pci_restore_state(pci_dev);
>
> +       pqi_ctrl_unblock_device_reset(ctrl_info);
> +       pqi_ctrl_unblock_requests(ctrl_info);
> +       pqi_scsi_unblock_requests(ctrl_info);
> +       pqi_ctrl_unblock_scan(ctrl_info);
> +
>         return pqi_ctrl_init_resume(ctrl_info);  }

Like I said in my comments on 14/25:

pqi_ctrl_unblock_scan() and pqi_ctrl_unblock_device_reset() expand to mutex=
_unlock(). Unlocking an already-unlocked mutex is wrong, and a mutex has to=
 be unlocked by the task that owns the lock. How can you be sure that these=
 conditions are met here?

Don: I updated this patch to:
@@ -8661,9 +8661,17 @@ static __maybe_unused int pqi_resume(struct pci_dev =
*pci_dev)
                return 0;
        }
=20
+       pqi_ctrl_block_device_reset(ctrl_info);
+       pqi_ctrl_block_scan(ctrl_info);
+
        pci_set_power_state(pci_dev, PCI_D0);
        pci_restore_state(pci_dev);
=20
+       pqi_ctrl_unblock_device_reset(ctrl_info);
+       pqi_ctrl_unblock_requests(ctrl_info);
+       pqi_scsi_unblock_requests(ctrl_info);
+       pqi_ctrl_unblock_scan(ctrl_info);
+
        return pqi_ctrl_init_resume(ctrl_info);
 }
Don: So the mutexes are set and unset in the same task. I updated the other=
 patch 14 accordingly, but I'll reply in that patch also. Is there a specif=
ic driver that initiates suspend/resume? Like acpi? Or some other pci drive=
r?

Thanks for your hard work on these patches
Don




