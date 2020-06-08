Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3158CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 21:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E980A2074B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 21:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="sW37xs77";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Wm0dHlE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgFHV5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 17:57:01 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:47954 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgFHV5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 17:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1591653420; x=1623189420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S81tll5qLAaEwb+4d+oyAIHN+kXShuFpJK0vdI9HtX8=;
  b=sW37xs778CKwnmvIebUDuq6PFoZ1x/iqCEsCaIixzeGbCz99CrJbxcgt
   KOlwdq9vulmu7gl+YlftmamiTjXH5exypf8XpQ/zegiePotd7ehZU6wdT
   TjTzTiFvoGxCF431sHIxU8zsthtcX/aBm38SjW/XWlbf8D6bkPd+aTGGt
   zDb8doybVxyE8Hhg2ANdpRyvH2D467qtPuiW9Em85A8W/31wtu5LzrTsP
   d2+bVXCzhqKyBgobSBFhyH5hh2Id0hNiRJB3tfhzYoWV3UsteV7gFj8QN
   IVSdGRBWJqF0G0VEwAd3nDaA29rvVN96aSJCcdW/MnlTx07xdBI9IHKCe
   Q==;
IronPort-SDR: tZrsCiZLdJuFdkFG4BJ4heTGhmUT0t/kfMd9jGFv8nd9qyzkn8rTQ+uRrBe45LN1nDbe2Jw3qn
 CsvrFmBaFdyk2hWEJE+YikhH2j9/Vobgy7c+9Zeyu59T3doVyYXz05ovnSim5qBlH/4gp962Y6
 JHCq4A0palL0WM8dkN1nkIpPUXn8JzeQKjvmyu6VJnSZBJOUN8y4q9ZCNJCAdavWCvdnVCRE5m
 j19EXEpWDCCiLbu0L12E8EAHOGP7nN5RNir63LDe2IFxHq9UVfuwqwsCNTGBKQfzEZq87lHh1p
 FH8=
X-IronPort-AV: E=Sophos;i="5.73,489,1583218800"; 
   d="scan'208";a="75900026"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2020 14:56:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Jun 2020 14:56:59 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3
 via Frontend Transport; Mon, 8 Jun 2020 14:56:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JorlTzDCepTpzUfsjmfv5N3bRY//j6/9eCxWaDIAqOhGV9GQBoDEsZDRBKioy0wS/nH5NlcUb9QismQb1wsP/njScKEmdCOArX/Jt+kPnGcIYPfxwkhnwb1tJ/uA7iUl5zXe8JAsl4rp9ms1nYi6wPttUuAtP+2Afjp8raWhDYzJ6jCzyhK+B2vlfXdGDqxaT3nuie94Tt+WtOcosZfALPPc5ektB4ipcnLyv5HHKNVnY6/xNninb3jzTOHKn74zEdMrr2bUpFIV2gA7s++LBEOoTMKhpuERvnMTZlowJAE8i2ese1VG2ysNcR/kEMm3+L6iOoMKyVasc3DY4tvaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ms70kLWeg3Uo26Hvq68MYCxVAUM6biw2uPVeRGVq2Q=;
 b=KnYovoCx42gLegHgNCeuO4eMXQE/uZEeJv3a8y1izq77f4T2opOoJsnv5RsKIdUXlCF8yeTYYUXABFVZjd8FYnZyCNfgMmblIj7Fa4S8uvPC/cseHJiV3WeFWZYC8VQDRmGibsnDhrYzLL9pp3mavys1wuxoNdfqnJN29ofLk5D8gRPlqiGvDdFDUWMOsuR2tSkHM1Dj68yZkBj/8uHefyAAd48ssdNZx3hpfKoGsgdv4UXC89L1h0vGxBnaeStcro0vb9OX4D27hKvtpM7S3R1cL/0kqO9iE2b4k7CYiBsdwXLXP7JQAqo2jiR9EUdbgHYqMk4uDNKkDJjunH/qbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ms70kLWeg3Uo26Hvq68MYCxVAUM6biw2uPVeRGVq2Q=;
 b=Wm0dHlE0tGazdo4xjAeo/i/DyYC+F6egMl2Ehi+cMI/UhGt9ITVOPxn9b0F/fsvq/SNfYL3GtYuKYVh6JFB2plnkEOhccJVAHzHEyLFREimdTs+Nte1bcSB14f3FZP25fev7OPsU1tIhRugUWguz6V5OxUVhKGokbGQvxeoacAQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2573.namprd11.prod.outlook.com (2603:10b6:805:53::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Mon, 8 Jun
 2020 21:56:55 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 21:56:55 +0000
From:   <Don.Brace@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <john.garry@huawei.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
Thread-Topic: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
Thread-Index: AQHWHvI16e8yEMfm40m6UaRagmZt9KjI9ulwgAF97oCABQndYA==
Date:   Mon, 8 Jun 2020 21:56:54 +0000
Message-ID: <SN6PR11MB28486606DD67A1893E42EDEAE1850@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20200430131904.5847-1-hare@suse.de>
 <SN6PR11MB2848512EB578D01F981F8705E1860@SN6PR11MB2848.namprd11.prod.outlook.com>
 <1331858c-6111-aab3-ad6e-16e27661a35c@suse.de>
In-Reply-To: <1331858c-6111-aab3-ad6e-16e27661a35c@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.211.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c24bc2e-6d4d-4e24-8fb4-08d80bf6dbcb
x-ms-traffictypediagnostic: SN6PR11MB2573:
x-microsoft-antispam-prvs: <SN6PR11MB257315244D120438D52185EFE1850@SN6PR11MB2573.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 042857DBB5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkX7575Ynsas2tyHIgqrcqLfuMZMtyZ5CltfnHRibEhNgJ8rz4cwuc3MT4FlbbP+0xlF8LtSWDjir793z28zjQ0qLBIVLu9gGVMsnwsqaABWgHtE2ylzqSnJGRpY+wlqs16BXUgYIBvEwM8rznnB3+/jQm9Da1RHzzV7gP5ouQ092EFwYEM7ROPvnVQIYhLeTG1a8l9F+k+reb6X6RwEaJSGEoVLPpgK8XnsHIj4s0NRTOCHD/ogXEGjS9hED2uXSkiG5H08MoRblNQMFy0AIXvI08pfwi2I3d7Fc49HbsQPihUqTK5Pt+Kd35j0/aQ2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(396003)(39860400002)(366004)(346002)(316002)(7696005)(33656002)(5660300002)(8676002)(76116006)(8936002)(66946007)(52536014)(4326008)(186003)(53546011)(6506007)(2906002)(66574014)(66556008)(66446008)(86362001)(64756008)(9686003)(55016002)(110136005)(478600001)(66476007)(26005)(54906003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kXutwC1IT4vl/QfA07YGtiLFtRetAMDI5kLszEVynK/Ja9ma3y7q+nYzpBcnmbtMPTDWofSN7FeG4gG53rLx6pa+KkP8PRaUfb0L+SN+KzJZpSs+MybqW0CS/nclY/hGd0MKprlmGXlZVaTRw+v+TQv90G6kEoQvY8SbjTzHByTI3yW+MiR+5TVgzyWwXAZE5QyvcJ7ltodIlR8cA5VYCjjg5qBWyPy1SokHSHt90WD6RAJJmClwZ7iVjoeuxTJEOslUEd5mJjFwCtdwKwr1oqkbsJF3pitmubAlMilrsdFF4yFRauPNJIYM9+IaaK4dyK8eqrWwZsnK6IbecpbVdziP2TVSf0Ky1t/rQZ5JKcUQGQW2smhoThHJzJuhz1DD4t1x5teVJV5NFJeB7TRFQ0G+eKROigipq292uKck7tUiHAhoJ0/7V1McH9RloYT+6eLcLIUsd8jJZf7WTrsP7vlpX2BQyEW5uikf+ylSnns=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c24bc2e-6d4d-4e24-8fb4-08d80bf6dbcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2020 21:56:54.9566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CarpMwm4p8T8k5vdTu7XKlVTjwHsCstUkrLDITzBAkY5nhkCmQ+QHgNXkDRahDVReLZ2DiyTPJiPDh+inGO6jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2573
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subject: Re: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs

On 6/5/20 5:32 PM, Don.Brace@microchip.com wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git=20
> reserved-tags.v3
>
> As usual, comments and reviews are welcome.
>
> I cloned your tree and ran some tests using hpsa.
>
> I used 3 SATA HBA disks, 3 SAS HBA disks, 2 LOGICAL VOLUMES using HDDs, a=
nd 2 LOGICAL VOLUMES using SDDs for ioaccel path.
>
> I have an IO stress test that does mkfs, mount/umount, fio, and fsck to t=
he above volumes while doing sg_reset opeations in parallel.
>
> The stress test has survived 2 full days of testing.
>
> However, my insmod/rmmod test causes a kernel panic.
>
> Not sure why yet. I had re-cloned yesterday an d the panic is still there=
.
>
> Earlier kernel versions do not panic on rmmod.
>
> --
> 2.16.4
>
>>Ah, right. Of course.
>>Should be fixed with this patch:\
>>Can you test with that?
---
Applied patch...
Ran 8000 iterations of my io stress script with 10K reset operations in par=
allel over 3 days.
insmod/rmmod
hpsa_ioctl testing
controller FW flashing
kdump/kexec testing
reboot

Tested-by: Don Brace <don.brace@microsemi.com>



Cheers,

Hannes
--
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg HRB 36809 (AG=
 N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer
