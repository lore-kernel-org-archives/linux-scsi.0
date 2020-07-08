Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A9AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F50E20656
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AkMZL1Xf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yWlUc1iN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgGHHfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 03:35:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:29485 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgGHHfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 03:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594193704; x=1625729704;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rdx8Siw1jiDWoY46qypfI8UNT0gyPtbWq5s9oOFXkpo=;
  b=AkMZL1XfwUJCBUJzau7wYkoeg/VsRCZcJi2omas9N7ReJhga+DNoCc/y
   zv4h13msA7dZv4aVShbfQ4AwX2aK4aY0mjK2tOrPPy92VfAv4EV+DqpGX
   JQnOOj2XThQUxocRpYzq5lQYOxBS/BG+OTChV+8wcOYwX8OPovexGjOG4
   Yc51ZvPJMbx6wt0tJM5ReLQZg2efDj3DbtPs7hwpjOiK4yT7ZbkJYoJm9
   uwKxVMXmem/iGf7BBd5BXVof93wo6wwXt5+0ZYDoV5UME1Y/Olrp/nKS7
   9N8vJ0fsQeuCJptwdZuWPbqPl4czvpTOTmRrVrn4eCrl5NLH9XUjgOwhK
   w==;
IronPort-SDR: o9o5M8qdFyRmP6HJIPNu8RF7XYXcUrgACwbpEnRxfhWM1VR1TSzZngEnF1XYNoDHjOjZVqJri2
 voJT44I3bQa0lS2oXnfkATiap0PSJkOhY2qhlSSNKDLUQEm5l94EqfXUAu8S/ID8L8nkmfORqO
 PIN7g4P+IL4l/b0vUImQCN79Elde2ai6vPEXDH6lIcVZJWvdLdEVS1e/pjqOoHMrxmYI0Zv7sT
 qvia9e0iZnaOLMmusE2GjDiq1HTU7b44ySLbRUKbE+IExGvJS2zo3/EryobHQsq3Hx3brGfgBT
 2A0=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="146213648"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 15:35:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUO8j28YQrQNjEglN0EYlpbhOYkQu8aGhT6mA5zr1C1ItKNqEQ15JrcJCTeeYwmIZH9wWP3lrQbZoU10vDjcc1En5UHmHDLBPw6ka3RzTB30sYRicCbHZsDMjRWHyAV+8HnkK+XJsAwzJcLZCabQUHYpJ9PAVR9vcIKw/NO/GFnV3LHA1CwOLnZhYxErUyVqBkCRKp8fhqHZj7CPvqq0KWBjelTjLsqg3UIf2C254Ze870U9YkS8pcY4Gq6VNeGnvjkI8kVN81UrhSXFz+jvtfwv1zolZRuiXIhroVWo9br+zqKqlybKvWmJBYtyKzFg3g52k+bFtiEVjAsGfYqhfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rReTwv/JxUUm4r36lbb3hhBUznvARayPgtCPx4b15AM=;
 b=LH52HYk9SFCaKCQL8w5n220NHTO6ykygAkeZ15BrPwZFDwMV1W70zG3beu4UlKoiEweFrJJRCULr1HFCl3O+nYvaIKV8Ym4c4wDyy2jzymvu+rwf+K9GmJZBIZ+/ucEVf/pdqT8jfOXsJRU0HjBXv8qVb0/c9H0l53R8gh1KAIZ8pdvFXrtFsEENHJUl+ZTajyJCfh7O86+51Y4JrBN5rDeYW+JTuICiCSRXGzjWofc9sloPveWj9S1FoB5oP0Rmj32OuboTERGPjzPOTQ1HuLi+bzgaqqDFc4k64YTc3KwnPkUyJB92ehNyzZOs1583yRgQSsw9qVp+8tBLmDdapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rReTwv/JxUUm4r36lbb3hhBUznvARayPgtCPx4b15AM=;
 b=yWlUc1iNnHZPFZ9FNbLj3NK6ptpj8yaGzQEQEU897tVEKq9Ra4ap0qNFrUHWqm2x0wvygc1416SejtkFio9PPYgY2m83Bcrs82AaIjxEUnIiWjMmiizAxXpu8WSapO8sKHraHCnTk4WpYty8LUY3FhPRQxQqDQRpjm+Zf6YtYYQ=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0968.namprd04.prod.outlook.com (2603:10b6:910:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 8 Jul
 2020 07:35:02 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Wed, 8 Jul 2020
 07:35:02 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/10] Fix a bunch SCSI related W=1 warnings
Thread-Topic: [PATCH 00/10] Fix a bunch SCSI related W=1 warnings
Thread-Index: AQHWVGcrhLvM8odGu0iXEs5vj7X/Jw==
Date:   Wed, 8 Jul 2020 07:35:02 +0000
Message-ID: <CY4PR04MB3751007285A0EB45A206A95BE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
 <CY4PR04MB3751BE9A73158B811D163EADE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200708065136.GL3500@dell>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b4c945b-7657-4b0e-9940-08d823116d07
x-ms-traffictypediagnostic: CY4PR04MB0968:
x-microsoft-antispam-prvs: <CY4PR04MB0968FAA29788D971CB6DAD25E7670@CY4PR04MB0968.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wfknJD3/gMxKG+rE9Xt//X5rnswpBrI6W+KBWuQCf/XFWWYZKB7p61E+kPkZvcksoVMPtR/1OWHhp2iNN6A7mNSqaJCqe9YccFMmKu1vfGNZAftxNDJmQkbCEB5B+E/JCmY1P+lseu1m/r06N1lFWA3omoqnYgFbJjU0Bz1TrVDHxJGDJp2HgWgaZkYx8meuJkkrtcV/Pc4xqK1qfpaafLQsNXdmeEsVpF0G4GkOCtAuiYPel4C9EHeis97kFjyTP/Z2dWUuY0Ua6Gdg69l5V9SDzTofZWQ5sdRYoUNJXAt2EeCfiRGaDbgdX+398EjrtbBosc0b6VFml+RkNYKFUnBQM+2gGen9CVdn3MIlYTkMtT8dxd+UKYrv4gVE/+XiYL51qRZ6DuuqteQ50hfU0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(478600001)(966005)(6916009)(2906002)(33656002)(7696005)(71200400001)(5660300002)(186003)(54906003)(55016002)(86362001)(9686003)(8936002)(4326008)(316002)(52536014)(83380400001)(76116006)(26005)(53546011)(91956017)(64756008)(66446008)(66556008)(8676002)(66476007)(66946007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: m3DEddc4+MAs69s/lqEYLDr4ae5N/i0xJurqRLUMWDeF9NFD6tC7f5YCDUZALrFNqRxTTi8b6KXwI58m4TQplJxjoYd0F+zwAYifgz5MuHHeT0p4LEZtKn5Id0lUkoof/3ToOoq/2mjR84CwSC3+ZW+UbtQKCLFjUS0tGu9+wJGF5OxuTInXpjoqB+4DKnq44G5OZr/OINtee+D0Qi47R5bO6INqU2UtP1EZ+51auxBErj7KLZORiOnkQca6hfvXgC1pClGruVeHmIDJDk/3jWHaenmZ7CjGBQPvB4nkhsBJHPFEzpv7/fD7IWJRfRdsK7Wb0NY8pw0a/ZuSsM5HRCOJQ4Olgw4qfLgXvF65WyIiIy1JsgWXNAC7Lv5tJg8vu/fqA1sNyuaaqFsaXinXUm2HtADyBjmnQEjQpuZQV5CHSYgkFaKi1nr07XRBGMhKtPTDfrNZwIBtfMSCPRdoBehqpHraop8C9Egy0vTEZkgi7HwK2dRIBQ83fAbFAbHy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4c945b-7657-4b0e-9940-08d823116d07
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 07:35:02.2036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yyIid5Qob+DFcmsJbL5iQOwlE3K5lAuAZkkLpJ2LBANI2KNkyl0pyM0kd/hu2Uw7BWkjEIqjkjtl5ZgXWpQNHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0968
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/08 15:51, Lee Jones wrote:=0A=
> On Wed, 08 Jul 2020, Damien Le Moal wrote:=0A=
> =0A=
>> On 2020/07/07 23:01, Lee Jones wrote:=0A=
>>> This set is part of a larger effort attempting to clean-up W=3D1=0A=
>>> kernel builds, which are currently overwhelmingly riddled with=0A=
>>> niggly little warnings.=0A=
>>>=0A=
>>> There are a whole lot more of these.  More fixes to follow.=0A=
>>=0A=
>> Hi Lee,=0A=
>>=0A=
>> I posted a series doing that cleanup for megaraid, mpt3sas sd and sd_zbc=
 yesterday.=0A=
>>=0A=
>> https://www.spinics.net/lists/linux-scsi/msg144023.html=0A=
>>=0A=
>> Probably could merge the series since yours touches other drivers too.=
=0A=
> =0A=
> Do you have plans to fix anything else, or should I continue?=0A=
=0A=
I only fixed the warnings for the drivers enabled on my test setup. No real=
 plan=0A=
to continue with other drivers for now.=0A=
=0A=
My series did not touch aha, pcmcia and libfc, so these should still apply.=
=0A=
=0A=
> =0A=
>>> Lee Jones (10):=0A=
>>>   scsi: megaraid: megaraid_mm: Strip excess function param description=
=0A=
>>>   scsi: megaraid: megaraid_mbox: Fix some kerneldoc bitrot=0A=
>>>   scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused=0A=
>>>   scsi: megaraid: megaraid_sas_fusion: Fix-up a whole myriad of=0A=
>>>     kerneldoc misdemeanours=0A=
>>>   scsi: megaraid: megaraid_sas_base: Provide prototypes for non-static=
=0A=
>>>     functions=0A=
>>>   scsi: aha152x: Remove unused variable 'ret'=0A=
>>>   scsi: pcmcia: nsp_cs: Use new __printf() format notation=0A=
>>>   scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'=0A=
>>>   scsi: libfc: fc_disc: Fix-up some incorrectly referenced function=0A=
>>>     parameters=0A=
>>>   scsi: megaraid: megaraid_sas: Convert forward-declarations to=0A=
>>>     prototypes=0A=
>>>=0A=
>>>  drivers/scsi/aha152x.c                      |   3 +-=0A=
>>>  drivers/scsi/fdomain.h                      |   2 +-=0A=
>>>  drivers/scsi/libfc/fc_disc.c                |   6 +-=0A=
>>>  drivers/scsi/megaraid/megaraid_mbox.c       |   4 +-=0A=
>>>  drivers/scsi/megaraid/megaraid_mm.c         |   1 -=0A=
>>>  drivers/scsi/megaraid/megaraid_sas.h        |  25 ++++-=0A=
>>>  drivers/scsi/megaraid/megaraid_sas_base.c   |   4 -=0A=
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 102 ++++++++------------=
=0A=
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   6 ++=0A=
>>>  drivers/scsi/pcmcia/nsp_cs.c                |   5 +-=0A=
>>>  10 files changed, 81 insertions(+), 77 deletions(-)=0A=
>>>=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
