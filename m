Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DA0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 23:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A651264DD0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 23:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhA0XE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:04:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30058 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhA0XCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 18:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611788564; x=1643324564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nWBTOezs2Lbb33iHd34suEYw2H0yJuZSqTcDMi0IT6I=;
  b=XRkaB8Snso0i6M0JKMe/2vUHndz1SNDYGLRiqt0j0Q3Tzue6l2ehmP56
   qSm/kN/CClSnZDjlV847VqdPsPRfsfBbtmLO+2fMxh5Sf5czKlTZs1vWt
   k1c0OpFxcrbF32xje1zQU0J9y2YbnXIkPHGlKDJg0ob1kWwuoj3I8zigL
   LOK4k+a/Ip5SgYa4CCCrzSNCw/58uEEUKyy41QJw3tLrbU9JvdT+gmnXn
   zWMSYBk9SwPgKyD+IUquNV0nRnyVW15WiCTiho/ZEmNKwoTzOmHbLUI6O
   Avt04LvCdUDTj1j9vSrjJ2ZQxB5C4w9JHm6qMhFSxgFFIJncqqe4Y5kmm
   g==;
IronPort-SDR: UEjqnYgF3Sgg1PM+lm2LeV9RXrMcTlyqD8dNraWAJ+Bvu5/806zaF0TylZB4gKJGe7o8aliylM
 ERGRo0atkhiwXQFGd6omZ14U0tCHU59wiQrIRqz9FrdrKaHteeiCdVTaJJNJhNSHjBSPI3EqKS
 KpUYGpXas08Hky63876yVw62MT3almwaSgYp6LDrMkAF5EBSX/MYolGvYOh7RcL7ewf5KwkOjn
 PKuoDMR6YOsWO/I3woNbbszuYNgGFLRRISjJytD1Z9ld8osCPZ3xJup51fG+1SVLSCGJHX7b/h
 q40=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="107556592"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 16:01:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 16:01:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 27 Jan 2021 16:01:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgL9jzq/NKsqFfhZPNQYIGvbEweMt+jtX2x/WMXtzO10AxzSy35hAWkosFTMBw14MunwkS/g50Nl2BuWrg81PZZwzseCk1ut3Zow4sw2COkfb7QoFPdi5Tri3O3vZRHryHDpP3u4Y6PYjmCvylobOcYijHyCRJ1g2Hwp7bZL+U3DezDpnmH95rofu8hygt/rYVRcsT0CAVV4d+9rJ3G1eCq5OFiblNOzaPHurwntC1V+r2v089x7WziJBBsYXtQwuYMyngBMA0Wh0LaMHPvhCFs5YYFwuYA6945EDUTw8lcym7kxParhZ8tb2IW3mLXgNYlI6fueJcJl5lGtSmYkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8JbJsRxVFvuhOse5XVB3bRhj9ztJH/+/KWMIlZBjXU=;
 b=B/r77r8JrLMRkkxURkgf6m89OJAoWoN9ydCeYRtmiAbU1+L5CLCpK0CS+o0hWaovIUNbKwaGexXhtVc2JaazFdj44S6NqREZ0MhbqfCwIQaA6AVyEi+Xk1wLiOb/WUVeNZkOfi8nMW6ho5Apb3BVXYTsmo2byLTB2GwqRKmSJNYupqpgM0tfLCzzGZASv13b0E883kBgrjzg82p0MXUddWyJb4hDNrmGVmuwT+cQziTCreJMKBAxnkCD2XPLchw4K8l8aAd2YcBwmysi1/U9UJfEyWbC92Sfep5YTG2V8ZuipxmTGCVHy6MWgpZeZZGUxeYLYClso5XI1939E4eNFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8JbJsRxVFvuhOse5XVB3bRhj9ztJH/+/KWMIlZBjXU=;
 b=ST1F7MWqZoJjfDRymzQEdXbz6upZ2D4tzitlvlWhG4JRlkNEjQJsBfS9Zx6rI++Uf/pgTJxXpAcaQIN5r9QFEphvL6NuQSv964JAt5mSJ+Q1T/XK2ULK8S4ZWExHj0v+368DDXCNG+g+wspteda+smZmDKMS8hfmh11D78+jzeg=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 27 Jan
 2021 23:01:25 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 23:01:25 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 14/25] smartpqi: fix driver synchronization issues
Thread-Topic: [PATCH V3 14/25] smartpqi: fix driver synchronization issues
Thread-Index: AQHWzzSSsdBsRT4A0ESvA1E3btB71qoc/EEAgB8oiRA=
Date:   Wed, 27 Jan 2021 23:01:24 +0000
Message-ID: <SN6PR11MB2848C1C9B0F446E2D8F30F00E1BB9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763254176.26927.18089060465751833560.stgit@brunhilda>
 <76f8c5cbdd1722eecdda017c46c0d617f5086e1d.camel@suse.com>
In-Reply-To: <76f8c5cbdd1722eecdda017c46c0d617f5086e1d.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df080b6a-0e56-4c93-68af-08d8c31778c0
x-ms-traffictypediagnostic: SA0PR11MB4542:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4542EA2A997CB71818D44865E1BB9@SA0PR11MB4542.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1+TQb52cAn5jopFCPZ6IwFiu990Am9HdiM3co8NXhLGFF8uUQO/Lf3obh9TbDEQ5+wHWfEEAiKRJTshRnkeGDlORwrqAacouYHUMBNUwz4ggIbgpsEcVx4wR/mYxTMRaPSoF1skfAnkMLGTRISJncK8Nis/yViS3zmBS/q5gUzT2xsY9LvMtP+E3Kr6CLeiBF0Dq3kNHb42ttTy1inccanLvMI6HLOU9nkQtVkWqn5OAvZoHVcrmO/IoAfTBYtQkztlf6BspLjvUusMk+cqOeseAnw7YnV53Y84KMPOsdZZe8P9ZmuItioYLcUdxfwqJHY1Jenmg9JqqU85XUyoowCLwNP6nAxlHz0QLN2vT+YXUK7z4stLP/CI/td3e+XimsYH6UTxGSnUcNQFMd9ZOJahdMDDcIwi4x0A66nII/xETXSZXXetjpZ2Gy3474qK/ItWQ0KLXeqPXsc6S6vp34fBlLewE4Notr1PcMU5e5M40pW62i+Hxd/sJGDqrdrR1vdKtJSS49uVef2+8Ucnu85/jwXd/QRC3gE7C1ZdVFMv+jIgjZWqp37pAJO1mxUA+szsGavoiiiTJ2nC092MO9cjDV8PminOXiEelTVcSQ7003j3QL2lTPLfzalMXFKew0NMnJ8d4v0uEaz9fjife7K0BhOZHrfrnIPLMIt6tZt4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(76116006)(66476007)(64756008)(7696005)(66556008)(66946007)(52536014)(66446008)(30864003)(86362001)(2906002)(110136005)(5660300002)(921005)(6506007)(4001150100001)(4326008)(9686003)(186003)(316002)(71200400001)(8936002)(55016002)(33656002)(66574015)(26005)(478600001)(8676002)(83380400001)(404934003)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?cqn0P1NRaXshal2qT1PcyYdzmpUYS8xANXufXouYYoAuQWCItgKv2OipO2?=
 =?iso-8859-1?Q?PKz8aY7P6R9PqfbIXfmNrXAypJg1cizpyQ/RqzQwV4GeTn71H+f9NkHZkG?=
 =?iso-8859-1?Q?wkPJlP8srk202XWXHo285hGZBH3TWOE1zAlvjXg9wA1jt5svQVHGLN5ZJG?=
 =?iso-8859-1?Q?gY4yNRTiaZvzVRqJgWg1g+KhLwzpTxHhZmBY71LKMU7gUJ7aMtH42uWruW?=
 =?iso-8859-1?Q?tjEFA6ygJ7ErI2p1FHeVrYlraWyyTf5zY6NHyrMiMUnRFGSUMImGdOJR+s?=
 =?iso-8859-1?Q?LD9HKfVASGDO8oOCMi7IkvqhB0say58q+KvmWhGykDOfVfFRPUnynjjh8M?=
 =?iso-8859-1?Q?GOAFUv63h0zqZr+0XTorHXPFJINDULom8UYAacdZVuuWw/buMO62/qz3iT?=
 =?iso-8859-1?Q?R2wiYtf+OCRz3kTZUmyxgpyZi8U+mGYaIlw8ckiiShDGkZ+RS/eseq6bmL?=
 =?iso-8859-1?Q?V9EBVHzvP0HsYCNFvqh5BQflZE7zmpMD7BHQ6IO1duTJGJ3Jn/zgq7KMgZ?=
 =?iso-8859-1?Q?Tuq74McDNX3CKWPIWSIyuEe+gFcNQpkEkvuNMqi2b2xzN/IKrdcLDGR5AU?=
 =?iso-8859-1?Q?+I0Z8zprXCoZUnnoeWvamamrJUNrmRyzWvqQRvQjxujueKwT1L+pFUTXEw?=
 =?iso-8859-1?Q?aiIVJYdY8yjhkIc380DqUo6TawJiH9YzJ5COY4GqrXnNlMYqL0sTeFigZz?=
 =?iso-8859-1?Q?RpnHQzFwR5uDr+/1lUppNvbPV82ZF9vXQqa/PI7gpty0NA1sE23cTfV5LG?=
 =?iso-8859-1?Q?9zhYGs5p0wTS5wB+B3fqHxMZr67xBl+RaDy/hnqhiaUPu8L8kbq3cPcBSO?=
 =?iso-8859-1?Q?wg+MX0bdjKzKUcN6WXo9w8EBiXfQ6r47W8FUmAGHb5kRrKMEFQYav+vYy9?=
 =?iso-8859-1?Q?xuZhUQxaqvnz5Dq5HYTFGHXGoltUVac0ibHXfnj00V4NyUvXNmyelqqM+A?=
 =?iso-8859-1?Q?jMzFEFMwXZSpg8kaRMNXgEP0yWNIx9Dgmihk+QCqaq/2L1Pn9TY88Ivaar?=
 =?iso-8859-1?Q?7VWomf1RxwPMZJDq7k/XcaWgx9LEjieyno1+dBLtOx0VujwkJnXwRCH6/C?=
 =?iso-8859-1?Q?k2oTEQjAfjlsBECKsOMS3XdzYGaRJePYouWaHAC4EM0Y?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df080b6a-0e56-4c93-68af-08d8c31778c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 23:01:24.8166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e5feAHlFPSGs2EelPY4CdYQdrQVV/KfVmS8dZfLPZWoSt1gYh7NmnfFzkbnD8pmDQX8fyqVFIU8CMOXqWkn4SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4542
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 14/25] smartpqi: fix driver synchronization issues

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
>
> * synchronize: LUN resets, shutdowns, suspend, hibernate,
>   OFA, and controller offline events.
> * prevent I/O during the the above conditions.

This description is too terse for a complex patch like this.


The patch does not only address synchronization issues; it also changes
various other things that (given the size of the patch) should better
be handled elsewhere. I believe this patch could easily be split into
4 or more separate independent patches, which would ease review
considerably. I've added remarks below where I thought one or more
hunks could be separated out.

Don: I'll start answering questions. The overall answer is that I split thi=
s patch into 10 patches:
+ smartpqi-remove-timeouts-from-internal-cmds
+ smartpqi-add-support-for-wwid
+ smartpqi-update-event-handler
+ smartpqi-update-soft-reset-management-for-OFA
+ smartpqi-synchronize-device-resets-with-mutex
+ smartpqi-update-suspend-resume-and-shutdown
+ smartpqi-update-raid-bypass-handling
+ smartpqi-update-ofa-management
+ smartpqi-update-device-scan-operations
+ smartpqi-fix-driver-synchronization-issues

Don: and I'll answer the questions and give the new patch name that your qu=
estion belongs to.

Thanks for your hard work. It really helps a lot.

PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME     15
> -#define PQI_FIRMWARE_FEATURE_MAXIMUM                           15
> +#define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN    16
> +#define PQI_FIRMWARE_FEATURE_MAXIMUM                           16

What does the "unique WWID" feature have to do with synchronization
issues? This part should have gone into a separate patch.

DON: Correct, I moved all of the corresponding WWID HUNKs into patch:
smartpqi-add-support-for-wwid

> +static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info
> *ctrl_info)
> +{
> +       ctrl_info->scan_blocked =3D true;
> +       mutex_lock(&ctrl_info->scan_mutex);
> +}

What do you need scan_blocked for? Can't you simply use
mutex_is_locked(&ctrl_info->scan_mutex)?
OTOH, using a mutex for this kind of condition feels dangerous
to me, see remark about ota_mutex() below.
Have you considered using a completion for this?

Don: This mutex is used for application initiated REGNEWD, driver initializ=
ation, during a controller restart after Online Firmware Initialization, an=
d resume operation after suspend.

I believe that all of these operations are in their own thread and can be p=
aused briefly to avoid updating any driver state. A wait_for_completion can=
 cause a stack trace if the wait period is over 120 seconds. The authors in=
tent was to provide the simplest mechanism to pause these operations.

I moved this functionality into patch=20
smartpqi-update-suspend-resume-and-shutdown.=20

> +
> +static inline void pqi_ctrl_unblock_scan(struct pqi_ctrl_info
> *ctrl_info)
> +{
> +       ctrl_info->scan_blocked =3D false;
> +       mutex_unlock(&ctrl_info->scan_mutex);
> +}
> +
> +static inline bool pqi_ctrl_scan_blocked(struct pqi_ctrl_info
> *ctrl_info)
> +{
> +       return ctrl_info->scan_blocked;
> +}
> +
>  static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info
> *ctrl_info)
>  {
> -       ctrl_info->block_device_reset =3D true;
> +       mutex_lock(&ctrl_info->lun_reset_mutex);
> +}
> +
> +static inline void pqi_ctrl_unblock_device_reset(struct
> pqi_ctrl_info *ctrl_info)
> +{
> +       mutex_unlock(&ctrl_info->lun_reset_mutex);
> +}
> +
> +static inline void pqi_scsi_block_requests(struct pqi_ctrl_info
> *ctrl_info)
> +{
> +       struct Scsi_Host *shost;
> +       unsigned int num_loops;
> +       int msecs_sleep;
> +
> +       shost =3D ctrl_info->scsi_host;
> +
> +       scsi_block_requests(shost);
> +
> +       num_loops =3D 0;
> +       msecs_sleep =3D 20;
> +       while (scsi_host_busy(shost)) {
> +               num_loops++;
> +               if (num_loops =3D=3D 10)
> +                       msecs_sleep =3D 500;
> +               msleep(msecs_sleep);
> +       }
> +}

Waiting for !scsi_host_busy() here looks like a layering violation to
me. Can't you use wait_event{_timeout}() here and wait for the sum of
of device->scsi_cmds_outstanding over to become zero (waking up the
queue in pqi_prep_for_scsi_done())? You could use the
total_scmnds_outstanding count that you introduce in patch 15/25.

Also, how does this interact/interfere with scsi EH?

Don: I moved this HUNK into=20
smartpqi-update-suspend-resume-and-shutdown
The function pqi_scsi_block_requests is called during Online Firmware Activ=
ation (OFA), shutdown, and suspend. I believe that this HUNK was in reactio=
n to test team issuing continuous device resets during these operations and=
 each needed to block any new I/O requests and EH operations during this ti=
me-period.

Since I broke up the larger patch, I may be able to move the smartpqi_fix_h=
ost_qdepth_limit patch before the 10 patches created from the refactoring. =
I think I would like to get V4 up for re-evaluation and eliminate as many o=
utstanding reviews before I attack this review.


>
> -static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info
> *ctrl_info)
> +static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info
> *ctrl_info)
>  {
> -       ctrl_info->in_ofa =3D true;
> +       mutex_unlock(&ctrl_info->ofa_mutex);
>  }

pqi_ctrl_ofa_done() is called in several places. For me, it's non-
obvious whether ofa_mutex is guaranteed to be locked when this happens.
It would be an error to call mutex_unlock() if that's not the case.
Also, is it always guaranteed that "The context (task) that acquired
the lock also releases it"
(https://www.kernel.org/doc/html/latest/locking/locktypes.html)?
If feel that's rather not the case, as pqi_ctrl_ofa_start() is run from
a work queue, whereas pqi_ctrl_ofa_done() is not, afaics.

Have you considered using a completion?
Or can you add some explanatory comments?

Don:=20
I moved this into smartpqi-update-ofa-management and
Hope this will look cleaner and clearer. The corresponding mutex set is in =
pqi_ofa_memory_alloc_worker.


>  static inline u8 pqi_read_soft_reset_status(struct pqi_ctrl_info
> *ctrl_info)
>  {
> -       if (!ctrl_info->soft_reset_status)
> -               return 0;
> -
>         return readb(ctrl_info->soft_reset_status);
>  }

The new treatment of soft_reset_status is unrelated to the
synchronization issues mentioned in the patch description.

Don: I moved the soft_reset operations into patch
 smartpqi-update-soft-reset-management-for-OFA
Hopefully this cleans and clears things up.

> @@ -1464,6 +1471,9 @@ static int pqi_get_physical_device_info(struct
> pqi_ctrl_info *ctrl_info,
>                 sizeof(device->phys_connector));
>         device->bay =3D id_phys->phys_bay_in_box;
>
> +       memcpy(&device->page_83_identifier, &id_phys-
> >page_83_identifier,
> +               sizeof(device->page_83_identifier));
> +
>         return 0;
>  }
>

This hunk belongs to the "unique wwid" part, see above.
Don: moved HUNK into smartpqi-add-support-for-wwid


> @@ -1970,8 +1980,13 @@ static void pqi_update_device_list(struct
> pqi_ctrl_info *ctrl_info,
>
>         spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
> flags);
>
> -       if (pqi_ctrl_in_ofa(ctrl_info))
> -               pqi_ctrl_ofa_done(ctrl_info);
> +       if (pqi_ofa_in_progress(ctrl_info)) {
> +               list_for_each_entry_safe(device, next, &delete_list,
> delete_list_entry)
> +                       if (pqi_is_device_added(device))
> +                               pqi_device_remove_start(device);
> +               pqi_ctrl_unblock_device_reset(ctrl_info);
> +               pqi_scsi_unblock_requests(ctrl_info);
> +       }

I don't understand the purpose of is code. pqi_device_remove_start()
will be called again a few lines below. Why do it twice? I suppose
it's related to the unblocking, but that deserves an explanation.
Also, why do you unblock requests while OFA is "in progress"?

Don: I moved this code into patch smartpqi-update-ofa-management
The author's intent was to block any new incoming requests and to block ret=
ries while ofa is in progress to existing devices that will be deleted. All=
ow any pending resets to complete.
I'll add a comment.=20
Thanks for all of your really hard work on this patch review.
It means a lot.

>
>         /* Remove all devices that have gone away. */
>         list_for_each_entry_safe(device, next, &delete_list,
> delete_list_entry) {
> @@ -1993,19 +2008,14 @@ static void pqi_update_device_list(struct
> pqi_ctrl_info *ctrl_info,

The following hunk is unrelated to synchronization.

Don: Moved this formatting HUNK into smartpqi-align-code-with-oob-driver

>          * Notify the SCSI ML if the queue depth of any existing
> device has
>          * changed.
>          */
> -       list_for_each_entry(device, &ctrl_info->scsi_device_list,
> -               scsi_device_list_entry) {
> -               if (device->sdev) {
> -                       if (device->queue_depth !=3D
> -                               device->advertised_queue_depth) {
> -                               device->advertised_queue_depth =3D
> device->queue_depth;
> -                               scsi_change_queue_depth(device->sdev,
> -                                       device-
> >advertised_queue_depth);
> -                       }
> -                       if (device->rescan) {
> -                               scsi_rescan_device(&device->sdev-
> >sdev_gendev);
> -                               device->rescan =3D false;
> -                       }
> +       list_for_each_entry(device, &ctrl_info->scsi_device_list,
> scsi_device_list_entry) {
> +               if (device->sdev && device->queue_depth !=3D device-
> >advertised_queue_depth) {
> +                       device->advertised_queue_depth =3D device-
> >queue_depth;
> +                       scsi_change_queue_depth(device->sdev, device-
> >advertised_queue_depth);
> +               }
> +               if (device->rescan) {
> +                       scsi_rescan_device(&device->sdev-
> >sdev_gendev);
> +                       device->rescan =3D false;
>                 }

You've taken the reference to device->sdev->sdev_gendev out of the if
(device->sdev) clause. Can you be certain that device->sdev is non-
NULL?

Don: No. Corrected this HUNK in smartpqi-align-code-with-oob-driver.
Thank-you
>         }
>
> @@ -2073,6 +2083,16 @@ static inline bool pqi_expose_device(struct
> pqi_scsi_dev *device)
>         return !device->is_physical_device ||
> !pqi_skip_device(device->scsi3addr);
>  }
>

The following belongs to the "unique wwid" part.

Don: Moved WWID HUNKs into smartpqi-add-support-for-wwid

>
>  static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>  {
> -       int rc =3D 0;
> +       int rc;
> +       int mutex_acquired;
>
>         if (pqi_ctrl_offline(ctrl_info))
>                 return -ENXIO;
>
> -       if (!mutex_trylock(&ctrl_info->scan_mutex)) {
> +       mutex_acquired =3D mutex_trylock(&ctrl_info->scan_mutex);
> +
> +       if (!mutex_acquired) {
> +               if (pqi_ctrl_scan_blocked(ctrl_info))
> +                       return -EBUSY;
>                 pqi_schedule_rescan_worker_delayed(ctrl_info);
> -               rc =3D -EINPROGRESS;
> -       } else {
> -               rc =3D pqi_update_scsi_devices(ctrl_info);
> -               if (rc)
> -
>                        pqi_schedule_rescan_worker_delayed(ctrl_info);
> -               mutex_unlock(&ctrl_info->scan_mutex);
> +               return -EINPROGRESS;
>         }
>
> +       rc =3D pqi_update_scsi_devices(ctrl_info);
> +       if (rc && !pqi_ctrl_scan_blocked(ctrl_info))
> +               pqi_schedule_rescan_worker_delayed(ctrl_info);
> +
> +       mutex_unlock(&ctrl_info->scan_mutex);
> +
>         return rc;
>  }
>
> @@ -2301,8 +2327,6 @@ static void pqi_scan_start(struct Scsi_Host
> *shost)
>         struct pqi_ctrl_info *ctrl_info;
>
>         ctrl_info =3D shost_to_hba(shost);
> -       if (pqi_ctrl_in_ofa(ctrl_info))
> -               return;
>
>         pqi_scan_scsi_devices(ctrl_info);
>  }
> @@ -2319,27 +2343,8 @@ static int pqi_scan_finished(struct Scsi_Host
> *shost,
>         return !mutex_is_locked(&ctrl_info->scan_mutex);
>  }
>
> -static void pqi_wait_until_scan_finished(struct pqi_ctrl_info
> *ctrl_info)
> -{
> -       mutex_lock(&ctrl_info->scan_mutex);
> -       mutex_unlock(&ctrl_info->scan_mutex);
> -}
> -
> -static void pqi_wait_until_lun_reset_finished(struct pqi_ctrl_info
> *ctrl_info)
> -{
> -       mutex_lock(&ctrl_info->lun_reset_mutex);
> -       mutex_unlock(&ctrl_info->lun_reset_mutex);
> -}
> -
> -static void pqi_wait_until_ofa_finished(struct pqi_ctrl_info
> *ctrl_info)
> -{
> -       mutex_lock(&ctrl_info->ofa_mutex);
> -       mutex_unlock(&ctrl_info->ofa_mutex);
> -}

Here, again, I wonder if this mutex_lock()/mutex_unlock() approach is
optimal. Have you considered using completions?

See above for rationale.

Don: The authors intent was to block threads that are initiated from applic=
ations. I moved these HUNKs into patch=20
 smartpqi-update-device-scan-operations.=20

> -
> -static inline void pqi_set_encryption_info(
> -       struct pqi_encryption_info *encryption_info, struct raid_map
> *raid_map,
> -       u64 first_block)
> +static inline void pqi_set_encryption_info(struct
> pqi_encryption_info *encryption_info,
> +       struct raid_map *raid_map, u64 first_block)
>  {
>         u32 volume_blk_size;

This whitespace change doesn't belong here.

Don: moved to smartpqi-align-code-with-oob-driver

>
> @@ -3251,8 +3256,8 @@ static void pqi_acknowledge_event(struct
> pqi_ctrl_info *ctrl_info,
>         put_unaligned_le16(sizeof(request) -
> PQI_REQUEST_HEADER_LENGTH,
>                 &request.header.iu_length);
>         request.event_type =3D event->event_type;
> -       request.event_id =3D event->event_id;
> -       request.additional_event_id =3D event->additional_event_id;
> +       put_unaligned_le16(event->event_id, &request.event_id);
> +       put_unaligned_le16(event->additional_event_id,
> &request.additional_event_id);

The different treatment of the event_id fields is unrelated to
synchronization, or am I missing something?

Don: Moved event HUNKS to patch smartpqi-update-event-handler

>
>         pqi_send_event_ack(ctrl_info, &request, sizeof(request));
>  }
> @@ -3263,8 +3268,8 @@ static void pqi_acknowledge_event(struct
> pqi_ctrl_info *ctrl_info,
>  static enum pqi_soft_reset_status pqi_poll_for_soft_reset_status(
>         struct pqi_ctrl_info *ctrl_info)
>  {
> -       unsigned long timeout;
>         u8 status;
> +       unsigned long timeout;
>
>         timeout =3D (PQI_SOFT_RESET_STATUS_TIMEOUT_SECS * PQI_HZ) +
> jiffies;
>
>
> -static void pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
> -       struct pqi_event *event)
> +static void pqi_ofa_memory_alloc_worker(struct work_struct *work)

Moving the ofa handling into work queues seems to be a key aspect of
this patch. The patch description should mention how this is will
improve synchronization. Na=EFve thinking suggests that making these
calls asynchronous could aggravate synchronization issues.

Repeating myself, I feel that completions would be the best way so
synchronize with these work items.

Don: I moved these HUNKs into smartpqi-update-ofa-management.=20
 The author likes to use mutexes to synchronize threads. I'll investigate y=
our synchronizations further. Perhaps V4 will help clarify.=20

> @@ -3537,8 +3572,7 @@ static int pqi_process_event_intr(struct
> pqi_ctrl_info *ctrl_info)
>
>  #define PQI_LEGACY_INTX_MASK   0x1
>
> -static inline void pqi_configure_legacy_intx(struct pqi_ctrl_info
> *ctrl_info,
> -       bool enable_intx)
> +static inline void pqi_configure_legacy_intx(struct pqi_ctrl_info
> *ctrl_info, bool enable_intx)

another whitespace hunk

Don: Moved into patch smartpqi-align-code-with-oob-driver
>  {
>         u32 intx_mask;
>         struct pqi_device_registers __iomem *pqi_registers;
> @@ -4216,59 +4250,36 @@ static int
> pqi_process_raid_io_error_synchronous(
>         return rc;
>  }
>
> +static inline bool pqi_is_blockable_request(struct pqi_iu_header
> *request)
> +{
> +       return (request->driver_flags &
> PQI_DRIVER_NONBLOCKABLE_REQUEST) =3D=3D 0;
> +}
> +
>  static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info
> *ctrl_info,
>         struct pqi_iu_header *request, unsigned int flags,
> -       struct pqi_raid_error_info *error_info, unsigned long
> timeout_msecs)
> +       struct pqi_raid_error_info *error_info)

The removal of the timeout_msecs argument to this function could be
a separate patch in its own right.

Don: Moved into new patch smartpqi-remove-timeouts-from-internal-cmds

>         if (flags & PQI_SYNC_FLAGS_INTERRUPTABLE) {
>                 if (down_interruptible(&ctrl_info->sync_request_sem))
>                         return -ERESTARTSYS;
>         } else {
> -               if (timeout_msecs =3D=3D NO_TIMEOUT) {
> -                       down(&ctrl_info->sync_request_sem);
> -               } else {
> -                       start_jiffies =3D jiffies;
> -                       if (down_timeout(&ctrl_info-
> >sync_request_sem,
> -                               msecs_to_jiffies(timeout_msecs)))
> -                               return -ETIMEDOUT;
> -                       msecs_blocked =3D
> -                               jiffies_to_msecs(jiffies -
> start_jiffies);
> -                       if (msecs_blocked >=3D timeout_msecs) {
> -                               rc =3D -ETIMEDOUT;
> -                               goto out;
> -                       }
> -                       timeout_msecs -=3D msecs_blocked;
> -               }
> +               down(&ctrl_info->sync_request_sem);
>         }
>
>         pqi_ctrl_busy(ctrl_info);
> -       timeout_msecs =3D pqi_wait_if_ctrl_blocked(ctrl_info,
> timeout_msecs);
> -       if (timeout_msecs =3D=3D 0) {
> -               pqi_ctrl_unbusy(ctrl_info);
> -               rc =3D -ETIMEDOUT;
> -               goto out;
> -       }
> +       if (pqi_is_blockable_request(request))
> +               pqi_wait_if_ctrl_blocked(ctrl_info);

You wait here after taking the semaphore - is that intended? Why?
Don: The author's intent was to prevent any new driver initiated requests t=
hat deal with administrative operations (such as updating reply queues, con=
fig table changes, OFA memory changes, ...

I'll add in a comment to new patch smartpqi-remove-timeouts-from-internal-c=
mds.

>
>         if (pqi_ctrl_offline(ctrl_info)) {

Should you test this before waiting, perhaps?
Don: There is a separate thread that will notice that the controller has go=
ne offline. The intent was to see if there was an issue created during the =
administrative update.

> @@ -5277,12 +5276,6 @@ static inline int
> pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
>                 device, scmd, queue_group);
>  }
>

Below here, a new section starts that refacors the treatment of bypass
retries. I don't see how this is related to the synchronization issues
mentioned in the patch description.

Don: Moved bypass retry HUNKs into patch
 smartpqi-update-raid-bypass-handling


> @@ -5698,6 +5562,14 @@ static inline u16 pqi_get_hw_queue(struct
> pqi_ctrl_info *ctrl_info,
>         return hw_queue;
>  }
>
> +static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd
> *scmd)
> +{
> +       if (blk_rq_is_passthrough(scmd->request))
> +               return false;
> +
> +       return scmd->retries =3D=3D 0;
> +}
> +

Nice, but this fits better into (or next to) 10/25 IMO.
Don: For now moved into smartpqi-update-raid-bypass-handling
Thanks for your hard work.


> +       while (atomic_read(&device->scsi_cmds_outstanding)) {
>                 pqi_check_ctrl_health(ctrl_info);
>                 if (pqi_ctrl_offline(ctrl_info))
>                         return -ENXIO;
> -
>                 if (timeout_secs !=3D NO_TIMEOUT) {
>                         if (time_after(jiffies, timeout)) {
>                                 dev_err(&ctrl_info->pci_dev->dev,
> -                                       "timed out waiting for
> pending IO\n");
> +                                       "timed out waiting for
> pending I/O\n");
>                                 return -ETIMEDOUT;
>                         }
>                 }

Like I said above (wrt pqi_scsi_block_requests), have you considered
using wait_event_timeout() here?
Don: I will start an investigation. However, this may take a subsequent pat=
ch.
Thanks=20

> @@ -7483,7 +7243,8 @@ static void
> pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
>                 break;
>         case PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE:
>                 ctrl_info->soft_reset_handshake_supported =3D
> -                       firmware_feature->enabled;
> +                       firmware_feature->enabled &&
> +                       ctrl_info->soft_reset_status;

Should you use readb(ctrl_info->soft_reset_status) here, like above?

Don: Yes. Changed in new patch=20
 smartpqi-update-soft-reset-management-for-OFA
I guess since it's a u8 that sparse did not care? It's still iomem...

>
>  static void pqi_process_firmware_features(
> @@ -7665,14 +7435,34 @@ static void
> pqi_process_firmware_features_section(
>         mutex_unlock(&pqi_firmware_features_mutex);
>  }
>

The hunks below look like yet another independent change.
(Handling of firmware_feature_section_present).

Don: squashed into patch=20
 smartpqi-add-support-for-BMIC-sense-feature-cmd-and-feature-bits



