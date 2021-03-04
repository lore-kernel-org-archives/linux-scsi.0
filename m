Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD8BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 17:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0E0F64F5F
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 17:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbhCDRCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 12:02:45 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:35635 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhCDRCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 12:02:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614877334; x=1646413334;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uHtxgf5TkAfUXGt08RSOzsoXH0/RguohKF0Wgu2IV20=;
  b=BHuJSiaf/jOlFm1AVT/xgGALeadzNXti1vFqH7jjbCDK0gBAxPQ3llji
   c+ex95uNcqEQRukfmkjH9tknV3aEwX6wks7xdoK8yn00lOrPCWF+0jbXO
   VSNTWcpr+UWQ7jDZbIuUE4o5ck5Ka54XrAVZYUEiYKzrQ10b3QyYDDsP6
   6SJOPzxnVSX2xEU5EGubQB75z87qpTfiwgjAZZXoULkck9NRFt5HD5fQ0
   d4PZSrsMXReHVsndVx75UqL6//sxkax5yuIS2WwqchJzg310xqOhUwzKK
   Je0ng6CSc58pfumUnmJzqwKkHYbpMvjz6Dw9ldX5UJdJ+YMdYYyhzV4LB
   g==;
IronPort-SDR: GSbvHc/g4/HJ3pqjsEAL6TWOPAZZ0Fm/cdb0auvRedj8BuusJgoGpfffNeEUgo9aJLg052dbFL
 K43v+NyQZ0qGMUwS+CTxCrC6hVcBNM5bRlQcd7Z/wBz+fQa9T4yq4keFf8I1h8cFxe0LygpuX2
 1X7KNM2snCgSXl3qwFWjTCicSXGbzGTXvPE+Iq5FYroGYsyq1x0qEePOeycAlGsLMCpKTGCsJR
 GvDUpsPzxZ0vARHg9L2EUGyCryniWCdK09yZZK7Dwi21c35GI82BK4vFV427eYcITWO+IgxSc3
 c9U=
X-IronPort-AV: E=Sophos;i="5.81,222,1610434800"; 
   d="scan'208";a="108789855"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2021 10:00:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 4 Mar 2021 10:00:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 4 Mar 2021 10:00:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsISq1ZgXPKi54EnBmo6brv0NZHEEUdNlVMg2Pi4K957W3xi+NqqE0rLQBEIjkLismloXZOUwImCg0qbdN39Yd9TfKXqKE6kIT8HdPMfVkZQPgDYzVuhzIWz5iSBZbylvo8XLC7gnQSaWnojDxoBEo+AOgQ9y9s5/HDzhn++zKoH1hewwf7iccP7o3jyPmS0O4CZpVLuAtMPSJHEkv4iAzYediBweCGPpDeDoSAssquZ9NntDdtXbu7N5I2iINwI3SdC6HJcnhcNs+z2GkXjpIyjLmXmSmEIWefnbUBJ7Ip/+4yaPnXYcQEp5ci6Beqg6zjVl4WqdgRvEV31DtEnrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5M71sbgTGTFZQFZFVqtqmEkklkMTkeskeEg5KKwWyFQ=;
 b=CrYBgSNQ13W3JR4Tgw7u/smDHT+Bf+1+g5Ckio3IlzYKaXeKlqiDR5xcUfZBRXNPDQmGjvLNndGF1PEadEYLBWjNC/cqajWobsznKvmGrke+U87I9/MCNAlyKHVpkeaKI1D9Vqc9WQCqvtf6bQa7IPOLYjtsRwHoW1FzpA55lf4XKa8/h5BqPspd25ghZSLqLeYiEp+2AiwDOOzyH7/olBiQ/DzaaaViYLRHGRWap3NDrh5RPDqRQH2DUGa1sg10P7Pp1w9G8pxSNYpEoMXlpmcDWYxCFIzK9fTxMXHeOBoqqPK6sptcRYzEsDys32mLZjntb/SlkF7u3nJ+5uOhYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5M71sbgTGTFZQFZFVqtqmEkklkMTkeskeEg5KKwWyFQ=;
 b=iwtRlG7R1FoZOb1CjBXggRgEFwQYq0TWthmtkWlXxjs6h6ZOT0cpN+hwhF/3Hva6QE3PrEdUDk00PpSb6kEu1cJ0qja0duFmEmAWRd/H8nzGk+HYJW93ik7IhO2iw2CjmNiygz/ZUyrrOtc8uTSy8nTZlZ9WNBVbKyodfZZe41M=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4922.namprd11.prod.outlook.com (2603:10b6:806:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18; Thu, 4 Mar
 2021 17:00:56 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3912.017; Thu, 4 Mar 2021
 17:00:56 +0000
From:   <Don.Brace@microchip.com>
To:     <slyich@gmail.com>
CC:     <glaubitz@physik.fu-berlin.de>, <storagedev@microchip.com>,
        <linux-scsi@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jszczype@redhat.com>,
        <Scott.Benesh@microchip.com>, <Scott.Teel@microchip.com>,
        <thenzl@redhat.com>, <martin.petersen@oracle.com>
Subject: RE: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Thread-Topic: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Thread-Index: AQHXD8NYByGFLRaE+E6Jw8YXZ2Cxsqpx9mmAgAB7hnCAAGDGgIABOu5Q
Date:   Thu, 4 Mar 2021 17:00:56 +0000
Message-ID: <SN6PR11MB2848371902B9488289A7B4C7E1979@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210222230519.73f3e239@sf>
        <cc658b61-530e-90bf-3858-36cc60468a24@kernel.dk>
        <8decdd2e-a380-9951-3ebb-2bc3e48aa1c3@physik.fu-berlin.de>
        <20210223083507.43b5a6dd@sf>
        <51cbf584-07ef-1e62-7a3b-81494a04faa6@physik.fu-berlin.de>
        <9441757f-d4bc-a5b5-5fb0-967c9aaca693@physik.fu-berlin.de>
        <20210223192743.0198d4a9@sf>    <20210302222630.5056f243@sf>
        <25dfced0-88b2-b5b3-f1b6-8b8a9931bf90@physik.fu-berlin.de>
        <20210303002236.2f4ec01f@sf>    <20210303085533.505b1590@sf>
        <SN6PR11MB284885A5751845EEA290BFCFE1989@SN6PR11MB2848.namprd11.prod.outlook.com>
 <20210303220401.501449e5@sf>
In-Reply-To: <20210303220401.501449e5@sf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a379e4bd-f05d-4329-3807-08d8df2f13de
x-ms-traffictypediagnostic: SA2PR11MB4922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4922D412E28719978577E97AE1979@SA2PR11MB4922.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kSdPJKcSNgkp46p6vWuvyZJdmzY8z9uYxdK5arUCStChicdPUrO0Jcv0pxuWSDp3Vski4JjdeG+hS6mb7bFfVWT30YmxXLvgp+p9PsyjgKQDUJG0e4+y3Gs3mGjQp+GGJ0OmXlPOqi9QdOKxaf2LQz4hNtlfUd6u6XEEDj0y4oaLp2pavQ8zEaqIEYaUdMwARLw+Z5nVSaUf+9FCTG6mf3TgWOrQqdWYj/Nl01UOib+lG5O9QDz1Nud97qezwS5j9/Uab5/K58KPouZq2tzBleNzk0CdLMg7fPCJP7iAweP/ZkhYU0/R082Uu3m4vcqQ+UUnIqFi1pS0pNA+IWs74T1e1sfHkYPxMsJ8V0lhoPmSh5dF3GZRU4IlG9Pv7rpYGqbeCgLWaejHDAw1C7JYCtcpoY7YGTl0ol9oTIXkwI1d8j0hOwT4HNuix8itOgHx3zY7mbIZ6HCWPGSi7bqMaSLY7u4yLwZennbSQNyB0k72KcnQp7V+tYXtB4UrW6lkg1+8bfInUFD1H9Wdwk9xHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(478600001)(2906002)(55016002)(53546011)(6916009)(26005)(8936002)(6506007)(7696005)(186003)(52536014)(86362001)(316002)(66446008)(9686003)(66476007)(8676002)(66556008)(76116006)(64756008)(5660300002)(4326008)(71200400001)(54906003)(66946007)(33656002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6uXQc2diLrcrcf3BUETCFuu9iI9STMzB4yQFSF8MfwY5xlUsT+bYHa48PxNu?=
 =?us-ascii?Q?ORLFDAWaFJsmOCtAwe9CntFwyJ1fx5L93Xc/z3cDH0UaNDl0bFNulfIIa/Bd?=
 =?us-ascii?Q?fU7VM394AREz31zzfeo+pQhkbAhs7fBbzsPHauHR4EZeXkMdrYYBK5lXMkkF?=
 =?us-ascii?Q?qA5EzIaF2YC91MlgbTg/rxrCys/imU/7uSs7geQveXgDLS4DyfimVHwxU50a?=
 =?us-ascii?Q?CCl3RGSgMUBHFVtTs7t7deymnFBCGFILEzQRwJSO2+tc1+VbYy8ur5/qRn1/?=
 =?us-ascii?Q?BBG5qPCJd8ukBBEDuTTHQ15vnLY44UVO3/AAWZ8ava6K8xXJ8ZselUhnX7Xy?=
 =?us-ascii?Q?C//KIqrZVER+YjuUa9vqjZUKzCAdRuQPb+e8yqfwrFfLXoRcoYosiSnO3Nwv?=
 =?us-ascii?Q?ZetGJkwAJnk2eb6nQpmrAcOp0hqnctymZLzAu/F/ZpQABLLRJX9KGZvYYUFq?=
 =?us-ascii?Q?9yAgCEtnDfGTlSlID3eyQF769+DA2Ah4v483uRrjSXJUZYQM3GnE1S8tsGkJ?=
 =?us-ascii?Q?LZJSWE4SPNNa3eWu2qhNtK+J5XP1zHM3wDZuW8YxGPj0u+ISO286Rju8o5/K?=
 =?us-ascii?Q?06xbal1JgS3FQ6IU//QfMgHFaATgrHJNcJkiJUECQ8T+KW0FySmPsvyh/RU2?=
 =?us-ascii?Q?Ieg7JUSk/vFgDdnFSt3EeUJ/CjgwfBALKKkXD0hThgadVEFct/cX7hU3Lre9?=
 =?us-ascii?Q?xVNcPmn8zAxHmNHqTOXz3PG6QTDe7f63fd6rVNWGEq+ESs+jX63PAnQ6ZkrM?=
 =?us-ascii?Q?1mdzb9IOahSuMD39nQ8n8/CjIBxm2dWk8TFV2wLXcVRxbi4tvDFq1i4bXsDR?=
 =?us-ascii?Q?ldRP0093bqs5Jyd7p5rx0MsTrXVSoc+RSkqkOCgDXUNTTUxs3pmQtsgYmeyd?=
 =?us-ascii?Q?HeKGfwsEYalAmv74qdwpdlnb1ypaQ0DRDlI2/N3tB46PJ5fSiXykV4StjZs0?=
 =?us-ascii?Q?cbfvVsa4MbsAsS26SXWsLLX6fkmzepSoCDt84zEIi8qDSJQzRkuUOa0lrifs?=
 =?us-ascii?Q?B0v1VB2Ql8Rv+VPrCJQiOsmRWVu8ChfgeCQhqraDxtP9xyXiOTKeUVq/q9aK?=
 =?us-ascii?Q?f3udYTfC3UieNirlC3d0MiRCB9qtFy9N4Vzteppcbgl1SQcGsLjhvzz8AfJb?=
 =?us-ascii?Q?7Bt0yB4oujpFGProPHpNerNNsbJQzKDAzdv4+pAvAaKKRufzGlQqnTIP6fgJ?=
 =?us-ascii?Q?VbQlOOnlZHgEFNOq8aG4fBaf0GLXEqDna86C+pbTU3SLYtyiS2La7BaFYLII?=
 =?us-ascii?Q?SaxCDmoa7Sur/0g/Rd4i8WjxKx4Gf2lamxlPTOklM2cnY3jbqLtOYg6iMpKJ?=
 =?us-ascii?Q?SB0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a379e4bd-f05d-4329-3807-08d8df2f13de
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 17:00:56.1323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ObtOl7KJE0z9XVq5R7FAhrMaI/XyuWdTFytEHTaLQCRY7B5JCWQ4+BO+9SwiDObRN76MLHrOLijfjJnozJfDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4922
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Sergei Trofimovich [mailto:slyich@gmail.com]=20
Sent: Wednesday, March 3, 2021 4:04 PM
To: Don Brace - C33706 <Don.Brace@microchip.com>
Cc: glaubitz@physik.fu-berlin.de; storagedev <storagedev@microchip.com>; li=
nux-scsi@vger.kernel.org; linux-ia64@vger.kernel.org; linux-kernel@vger.ker=
nel.org; jszczype@redhat.com; Scott Benesh - C33703 <Scott.Benesh@microchip=
.com>; Scott Teel - C33730 <Scott.Teel@microchip.com>; thenzl@redhat.com; m=
artin.petersen@oracle.com
Subject: Re: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev =
cmds outstanding for retried cmds" breaks hpsa P600

Glad to hear the patch works.=20
The P600 is an unsupported controller that was removed some time ago (by us=
) and re-added in this patch:
commit 135ae6edeb51979d0998daf1357f149a7d6ebb08 scsi: hpsa: add support for=
 legacy boards
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Aug 15 08:58:04 2017 +0200

So, when testing the original patch, I no longer have a P600 to test with. =
It used to be supported by our obsoleted cciss driver.

Since patch f749d8b7a9896bc6e5ffe104cc64345037e0b152 scsi: hpsa: Correct de=
v cmds outstanding for retried cmds has
already been applied to Martin Petersons 5.13/scsi-queue, perhaps it would =
be better to send up another patch to correct your alignment issue on these=
 legacy boards.

Wondering what others think about this?

Thanks,
Don
