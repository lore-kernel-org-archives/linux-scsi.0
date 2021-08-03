Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC5DC4320A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 07:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D58360EC0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 07:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhHCH4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 03:56:09 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26736 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbhHCH4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 03:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627977358; x=1659513358;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=f1IRkIgrppr239CmS/2Nfh08DEON1nhJOpgTf2Dvoso=;
  b=fAhJxf355Vu8/jMRk/LQU/ARZhRoNJZN5LfAc9K5L7MhNTQf7B4BUAIb
   AivZywlAssZkWkNb4yemzkNYyBubYYEnQyqFWMtLBotkQyEQaU/hvLwgu
   E2M8TXfCWpHyLbIm2kr+nbunNNiMahDkZbbXxlRg6JijJyIzJSbKEY54B
   L/waxgYH5LWwxWGdIr1tNSShW/5bpANwjYf4ua6lEkZ5E4cEGyCU7FyEQ
   zn+G3BwZBIWI1A4cWwEuH/r4tNQDMEwDz0o19zsiyzcMeaVFG2ErzAxwk
   /FNLxGiHqjUEMessLYOjuPQnECX23fFtc8+I8jr+T9z0B5EHSVPgs9JRF
   A==;
X-IronPort-AV: E=Sophos;i="5.84,291,1620662400"; 
   d="scan'208";a="176738409"
Received: from mail-dm6nam08lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by ob1.hgst.iphmx.com with ESMTP; 03 Aug 2021 15:55:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nw69OEIIPvr6T5VFmV37v2HTRh8AXHsysAjLhIuTOudS9YGDR4OJwHUP3xRHc/vrWMcjSDNev8u/EhIgmn8IwOlT+USZIfhunKhG12FXInLE7a2KnHz/HPgfa03TXmAadGs13kaqS7WZO+1fijVc+QAmervA8tvu+X+FXzGpd2+d0ymACzQzgFLLESicWaP5+SyBzXRBzrYxqWzzpG2fiptuIxe2yn7Y7Sc56AEd8M7TtpVDUapcsB1l+WDclkNkfCDW6Cf8Q7ZvcRAm0QfUUMMNtI0x+lV8xEmVrJsfD3N/Mb4KuB6r3pjGXNILM/Sr4+7Vwxs8fgFJV6syc6OW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1IRkIgrppr239CmS/2Nfh08DEON1nhJOpgTf2Dvoso=;
 b=C/NsfN4NEyAVdv1QBnA9940I4+s8FKvVbt17GwxveeoWVAdjOdFgRAGEk9YHq+dMFf7jMqLWy++Su1LzUwDk/wFvOy3E1+kTiR3wz9SF5psaeXSMYtxUqQ/rwOumgBh7oIB0+h/qNSfz+fqaQ3P5DhIuFw2OY++jTJwYwsIbIXy5+eiNSLfOOGlW7PxD+FppD9ABoEPioMDZrqisjZK7V/lNXrqbod6O9sjg/JbM2BJ3lC8D+RFqhLdfDQefYiuta3UFS1la5UjYojvk7dx6Uai8FIQctfCUtOJ+mncaZjQDHjZ71laNff69PlNwXgum6tz7ThjkjUmX3KfhK55LLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1IRkIgrppr239CmS/2Nfh08DEON1nhJOpgTf2Dvoso=;
 b=U2kqrijL0WBevEpB6/LFqasRdVWUMFvpTX77qkLpqJxSg7GempsIBEQqZulIRKjX1C4fh4n19YeIHBZ8r3Go/DXIkG2BQZX2Xm8cR2VHWVRkXH/QzMo80/9KyO1j+EduPDPUEtCkOu/l0yfM/wvs435JziU60GhDjD7xYUXeBE0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7254.namprd04.prod.outlook.com (2603:10b6:510:1b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 07:55:54 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d978:d61e:2fc4:b8a3]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d978:d61e:2fc4:b8a3%9]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 07:55:54 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs
 sttribute
Thread-Topic: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported
 sysfs sttribute
Thread-Index: AQHXh3088tRR+dw6akGj3LszsN7uOQ==
Date:   Tue, 3 Aug 2021 07:55:53 +0000
Message-ID: <PH0PR04MB7416257D854F7B4D43339A969BF09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
 <20210802090232.1166195-8-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fe26266-3e8b-4bb2-21ee-08d956541ea7
x-ms-traffictypediagnostic: PH0PR04MB7254:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB72540E2C79C966090A1007659BF09@PH0PR04MB7254.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vQIukQlUoCBTJ4jLG4jv/+pNvf2sd5CX1L2wjF0xwqBm9RS1ZAbB1tHhiy2mWPMG5WPr8vfBXAm8PljUwi/dyEbHgsb1gAkVMiP2qWIOaAXTnz78hu8XzHGpJk7Oq3/CI9sk3fRU37FUoDgDgGMvjv+wNXdMAv3KWk4IPG6/fYayFyyVf+FthGwqm86uLUEHj0N6tnuwf2q5VJuxDT/siMmFeaw7tA9fWE4RP4kLb92+f2e1nUmJn0lCxi4Xa/GWedew0L7pGk6sHZoe6YI2lG15kLRzl6k8OE5F0elwgfVf4KzJfcl7B9Fnc9krw0O1fyk/DxGenkPw2a4YkM+tzKG6d/Ro8tnXfmB6z0oVflu2YgURalebr3y8kTD2Q+kuW709BasGio+w0hz9ndVnZPigbK1xG/hfVtuQsTYKjXeN6TISxYmEDWIIGx3iZWJ9NHxARgs2gO30n+MwRiDWXyTxOoHavcgPVS+IVq2sVfNMxx4HHqHtiUl7r+hVkUkO0rlvQmQv//1n8pvxsyHlGeaPmGDvpCj7tOURk+H6RMF3w3EpUMjcUoIzaky8twhC+GH7Mxsq0rL9aHtChLqiDBDxrn1qjcffQ3dr7Bm1r+ANLyiOyOHv2sW9JLoXU2OndDazUlyybl4CqyoRRZdTF72YpuIouu9mncqNvROTj2WK26FE113Iw0CQaVvNVXvPCukh1bjGtDWCr+hQhM/+hg+ptllpoZhUsOwJShj6TQg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(38100700002)(52536014)(8936002)(64756008)(186003)(5660300002)(122000001)(8676002)(478600001)(86362001)(33656002)(4744005)(9686003)(66946007)(38070700005)(6506007)(53546011)(55016002)(66556008)(316002)(71200400001)(110136005)(7696005)(66476007)(2906002)(91956017)(4326008)(54906003)(66446008)(76116006)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+L10Hf/FPHH8biFghx8rFi0Um9HSB2rCkbR+Al+YCRCi9UCeHn3FO5jhZTkZ?=
 =?us-ascii?Q?ractk+XXBPxlxmjHmz1cYRvj0u3eahZSm50tSh8aFNUP4Or44c5Jg7Ym8+BQ?=
 =?us-ascii?Q?4txl7+/dYL4qAy6DyAfSBl3Ar3HWRIhz0qClekdQpCQtk7oBabStt3lQr1wi?=
 =?us-ascii?Q?xrD/pPUkWgPTucZ33+DMWuRRieZKTuPzdnRhAb0tqUo/MKCQCt9LkHEGeCkp?=
 =?us-ascii?Q?x+i3cAa29ahJmhLFo30z6uoLZfDd31x9fvDJOU7bSN5pTLZjVoV1JeXfxTZB?=
 =?us-ascii?Q?dsS9spm6/EhjBCWT0gxBmvWMNjaIg1+nGHFyErgFpat5dg0tyZfZIYlHxQAS?=
 =?us-ascii?Q?EUN22A8DBneGeF23tnYzrn3FPO1QTSdnAHNwN2aC9pHtIj1A+8lbWXSKeUki?=
 =?us-ascii?Q?qcVPg6NwHXwJZpKFmthudS6lh451eLAeNeSUhjIrkr8UPFqxaalvfelN8fDQ?=
 =?us-ascii?Q?dxL8+UaJCn+gzEjvAw4dPqgogQqPWjM2LeHu9m/1cW1hnHpEzQeda8PboAT6?=
 =?us-ascii?Q?lrRkLYqX+Ly1LOlNmKk0CtJND//VHPDPBWU59J0O8rRFUeXRUNAs+qf5rZVt?=
 =?us-ascii?Q?g4EhEcw38iSMsKmuRxGxxDpiQbPQovjRyCn9zTRpew4kFJm2j5kOItyu4XV0?=
 =?us-ascii?Q?MhpsF+LfKqpdDtQotJboltIQ/YAwohNoSosgjyZvdsVkUYCmp/C8kKc50S9f?=
 =?us-ascii?Q?W2H2zF5Fr7s/okDAn/dOdAg5cVXJCSXH9/tdDpnggm1Egf86UiuLHnL1ySAg?=
 =?us-ascii?Q?LyHonpW5bc+2o4T4RyELpkW27l51XJ6ee6OenOS+PJkiurmMw3sOxMYULMhQ?=
 =?us-ascii?Q?zYew0Xo0vBpTn1nmxluPTISRZjdZQizeNmaDp31R8Lh4XxQRbWLePlLugfuf?=
 =?us-ascii?Q?SeR9ejlyLanCBL1JrNWur6/ga3sSC0taCoj7bLl8bsCl6EVNDyKeuvvAvbBv?=
 =?us-ascii?Q?53PCgsh3BwyA6DSeEjruLOLH8RJavbf4eleYuq9hJGBtr+ESvGQXw2f1pDIo?=
 =?us-ascii?Q?inEcNjHQHVOes+Or+DSfFNzdx0+gLnepPgzyPeVUDhjjsUPuu4CYA99FQc4A?=
 =?us-ascii?Q?Bn5TVLa8neVb/mwUOHXExLssiJEGMXOYRW6o7A0RH2eXhM3QGmygYTsVfIKe?=
 =?us-ascii?Q?Odc/AMPwojiy8FEV2P4h3WCLw17oCNmvenPYI5IVnhPxb0rcm4nWLNB9o/eD?=
 =?us-ascii?Q?HT3CGYx/YZPYCIdXPis0L21Le8Hz7R4WrHA/dj0dzMAiTp+W4jLAEVYJfk5t?=
 =?us-ascii?Q?MB4pdtoeJPRMridYXtcTG6TK0EsEPC5G2Z01rKxlBxCm4f+AYIzaDtctct7R?=
 =?us-ascii?Q?hzaca7rX5ahxuIs/mFe5IQcG8KKknaTFmmHB0C4XLamSOeEHrhwNKPPwhCnt?=
 =?us-ascii?Q?CBbVIDQRV1jq10jaNGZtnKyXqyyMJxlgtSpFbXQqei2AxiXwGQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe26266-3e8b-4bb2-21ee-08d956541ea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 07:55:53.9803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2Po70D74N2pnqUdkSB6UUpZEna5jNCbauvEH0WZtg7RVVT54JNx/YVObypuISOLbKO2Zd5OvfkAQJhAXpMKv9iOa91Wt/Qqtb7YPBZSupU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7254
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/08/2021 11:03, Damien Le Moal wrote:=0A=
> +/**=0A=
> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priorit=
y=0A=
> + * @dev: pointer to embedded device=0A=
> + * @attr: sas_ncq_prio_supported attribute desciptor=0A=
> + * @buf: the buffer returned=0A=
> + *=0A=
> + * A sysfs 'read/write' sdev attribute, only works with SATA=0A=
> + */=0A=
=0A=
[...]=0A=
=0A=
> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);=0A=
> +=0A=
=0A=
Shouldn't that comment read: =0A=
"A sysfs 'read only' sdev attribute, only works with SATA"=0A=
