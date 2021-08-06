Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E923EC43214
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE3ED60F14
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 14:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbhHFOcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 10:32:01 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15270 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239813AbhHFOcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 10:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628260303; x=1659796303;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ssnx1jeLdiAwUdtT/XWoIzdNSE2NmTuF4YEqxOYfmYQ=;
  b=iw3sX6fhj8gvJZ2AhRBDAv28dlEqvQwdywh8gM7rnOnEFzpH0ijwGB7E
   iPoqizw7vdgeWdHHvZZbvJ6hV71DOaz55XFCQTfftmJDCoTYWUw2231fZ
   uTekS8rcV1C19EJB1cKCYKNf2Tl/RIvDpCgpjB1WJbs+9opUtDxQ+iCwB
   TEURSvMX1weFN3PMfI0PC6llT/IcVZ5vStMIkkXjp1AD0FxhO/JGPpRti
   A9zLlpY3bAT1nw7vLDgN5nwQJ/1bkzVS68b0nMzti6g3yKbzeP3QVI2tt
   EmCHzfDKPzI191BgGlUQKQxonFNbjAi0f9KIK1UplRbMCVD4OwHgT4yWp
   A==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181320505"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 22:31:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoVvRTliG3m/NGA+823n+s6OoGN9WMpF1T8oltntbs2osHj2lsAAU6+BAgr/poloOtMNQkp7jkMPGqoJURsjynUIs3t2tchu0FImBgV/I7FvfK5XRUF6WrsXbp8FzF6Q3T8e7wrV1oWogD+Q8zsQqi3FcFuAR+wL7dy9cl/Qi2wQyAuvQgPOlMtUlpb8uY5x/8TQxHRRQBt54DfEyvCc5e6P/aNe0ngznZmU8530SlKggXDsukLTyBIE0iQoaER/J4aWEB68QQXGzd0aPM55AAancUBqsD2JTe0IGMGhNNJL7kLivekPHukLB4h/iMa7oDNq5ojU9GENqGS0fkeYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwXO7IrGD7s8R6MYdT/WyNUeUbC8GFhMqFixiAKzpqc=;
 b=oUBatWWMCZOdgNnMtXEf/8JLVIKnysNnI3MQbZvzuHDKc+zSsLBydAROSNiLbdjHWeDX3CEwqqQr7YQ/aaHzz4e+stS7JMAzpYRzue0BNHlLNXxflmm5Ir4TQ4lLokWChi51HEJyOLySdDpZ7rbLvZBo81okigqJloYIVapLS/ZZ2idSg4PHGC2Icbab9Gc0vVpRYrslZZh5Ph9asVBRegzLSjJqvPxN4wvlvFXiJKwiZKo1ykL8Ki5EtP6TFVfFRaOrtDudikZ5bwfLn8Z8CsU8wsvmY0WM4siKDnJHQMvCjIcYX4WDfZO+XzVl0LkqfCDU29t5j2NZyoqkyZ826A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwXO7IrGD7s8R6MYdT/WyNUeUbC8GFhMqFixiAKzpqc=;
 b=TIj5I7GFziv/xRaskES68Dh4No9LyR299xyD7EwrgaWYjGP7sqNDrlGj4/LmU0qMyf8H87MA2N+I4vQiquqTofNTPiQX+lgX00ZZhttf1SrWjHRADSBEoLbHroGE1SFslzfUXJ/vniE7raiU4DVqJUCYpNaqbfbCRHf2FkJEgv8=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6393.namprd04.prod.outlook.com (2603:10b6:5:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 14:31:42 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 14:31:42 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v2 1/9] libata: fix ata_host_alloc_pinfo()
Thread-Topic: [PATCH v2 1/9] libata: fix ata_host_alloc_pinfo()
Thread-Index: AQHXipavpRU3Uyt3AEK3lwkwCL0agw==
Date:   Fri, 6 Aug 2021 14:31:42 +0000
Message-ID: <DM6PR04MB7081DFB4CEBE50C234755191E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-2-damien.lemoal@wdc.com>
 <1647f71e4ef539ff17538223c944d9ec58806bdb.camel@HansenPartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: HansenPartnership.com; dkim=none (message not signed)
 header.d=none;HansenPartnership.com; dmarc=none action=none
 header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a20293a6-b5b4-4387-a42c-08d958e6e8f3
x-ms-traffictypediagnostic: DM6PR04MB6393:
x-microsoft-antispam-prvs: <DM6PR04MB639367AAF615EA5CBE128BFAE7F39@DM6PR04MB6393.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rmIZ4XORXUjNfvDdlRdRFzSKUBkLTnT2cRUga7V1SweeZmraX0ejK2U5XFbxVwbQ8RkiCKJVKDiv+F+rbmKyzvmewsuG373DU+CvzKePI+Us/0wPDAFp0jOAlLQ2gFteXYTLawHHnAJaX2x3xx9gsowUyr1c/zva1oaS1L/mILHEdpgevhHIhWAHXO/URsO1wCEfQY1X5ilXcX8g2KoQbNUPndvwyy47CfmakF8QEMuRlIwwHbe2CZvIq3I6Z7bmJiMWFialrRPgMVicB/FQTxk1wKC5kDkHcJ++ygni2piJvqprLa0xXdnQUDJ376vOCklM/mUcN6YfUEsuQgm1QE1ZqMSLx+MDTuZHRzvDdnFD7lmIWvBXPyoH8XxmhT9Sf5b4xBGems6PKdqB1Qlw4M44XdBwk1uamiGtKWvTG54NwxdtSMmWzFsXRl1SrSiROSm+osin8HyRKYJmNkLr7zcGtZ3NM87AX8cYjBaYXJ6viWYglusqKhsfpTDDqLdaMWCcmVm2s7oQdSBDrDO5q5owcq9HpehAZ08l/4ld+9rR5x3EJVYHiyP2Viwo6OUz5qEzENzQLPlWPmWvIdKCgUYSQ+Z8U96f3rFGK3D16QuKc0PuggQLgruiYwzAaaZDSNO+GFKMu0KshuWYKAGyTr61+9WaB5PLkKpf3n1E0s6X8EdHXPyiTl3V2B/O4TYiaeWtujY07dtNsm9y7Sl4ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(86362001)(478600001)(38070700005)(52536014)(8676002)(66556008)(66476007)(66946007)(71200400001)(66446008)(2906002)(64756008)(83380400001)(91956017)(54906003)(110136005)(76116006)(4326008)(8936002)(53546011)(6506007)(38100700002)(7696005)(33656002)(55016002)(5660300002)(186003)(316002)(122000001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dInfnkAA/GXBBHYeQE6s32wPNrt1EHBpto3IwKFzqMhVUH7JIIQQvFid5UgH?=
 =?us-ascii?Q?j7MItedWwHGPmGplLBlkG7uhYHiV+f/pckOi0JmiO/hTupMlSDex02DSfYR2?=
 =?us-ascii?Q?6wILRM+Ay6u/pe74KgsrMAPuPN8oCYLt3qoKk7Z5a/LTH4zXWvjQ70jfNZHg?=
 =?us-ascii?Q?PDrb0JObEZbImaVYDXFG6u9Ad0YT6/M4VqN/f2WvZQYYkp4r8ZhrP0lCyxSQ?=
 =?us-ascii?Q?789U8Qsw/8KudfA8ynixP0Yiv4MbVdRurc4+LkxQ3B///cAsaAb4hx/ceQwr?=
 =?us-ascii?Q?MhwYxrybbicQk29fki1IAouj4xCp0MEaxEJGzmYh42gVj03jsML1v9Z0uE6E?=
 =?us-ascii?Q?q68D/aZUZBtV4SwBAk1NYPgVaNetVm5iYe2f9Yl3Zcqxpj5zLjzi5zFUs/JD?=
 =?us-ascii?Q?Oa5AKYaWaPRh4ujxD/d6KdcPWbRe59yvN0RnCH7Vcbie/NoiTZtCwJn1Ioub?=
 =?us-ascii?Q?eZhgYaQVmG0Gbb+lFS+4S60lBhXuwZ+B46ZWZTCxpSpb0/Pi2hN9V70MKwVm?=
 =?us-ascii?Q?azU2TUQ9kPc2lDlMqhyFfNtoScstCRBks0+Sb3Z/eBrzNQNVavFDJzFOqg/1?=
 =?us-ascii?Q?HNZRcIYJXgN3ce3S5AKukEGORXqXq9TrJe2XvZ2YxLlZuRexbvxxFiuICnpt?=
 =?us-ascii?Q?3C9tOPUfU0vfkuRv0l/zwPKlHDHAWksPrAMMNhoBnsQy1vAZ7YIFf4sHHur0?=
 =?us-ascii?Q?974VtRMRb8LD0NjPGUm8uKny8cseMriWQWw50hf7kxvOiJQvKF6EboWgsfdd?=
 =?us-ascii?Q?PexVeqI1FZAEXYkt9/KEFeCLBsBfNfoakQqqH1xkggkQCd9024pZwJ08YoSv?=
 =?us-ascii?Q?YRFZevEbstOIpcXEkSndPGY3qA90zMwRURx23lpoZ6exm9OC9OpltG+6SMLZ?=
 =?us-ascii?Q?CUsKUjyxQ/PO+9gSWy4+Mp0ZhyclDuYfoJdj0ReOF6sEYGziIPgGymFPfe67?=
 =?us-ascii?Q?u8AbuQSEAhk8Rt9YAsFUNCd8C5UXuOEHkxJxrhIUoJFqBu4IB9o05Ye3nmys?=
 =?us-ascii?Q?cV12LE5njRlXPgG51uJAo54sqY1DYe4dpHl4EsSBhb8qFmOHVXQjOBvyJekE?=
 =?us-ascii?Q?tgPTlO88u2lIveGTGHOz3Q0U269P/UhXGK93pGV3bBekHq69Y/5Nm8p+6W+h?=
 =?us-ascii?Q?yO90ecg1SekI1jSwhVHR87xDDbV5ArOdfHkp6IK/Kl3c8giM1iVpnAlKFhOQ?=
 =?us-ascii?Q?F5T4MuKsI1JRprMZYvOPKHuNo3ldR26quxHDIzHv7lZbzdlwpPFEsvX4ja7T?=
 =?us-ascii?Q?wKW5PKBdv4ZHT3WH3KYQfRnSo4JyzjDlHA/ppgFDxqNXznShqdKxXP9/uu8l?=
 =?us-ascii?Q?3RhHcGhZKagK1Jd0VO+qG7hYdB4+Mm7FUpy/TdccdjE0qKgKsvKNYkGHxx/x?=
 =?us-ascii?Q?zFDoFCg+XB8Cqra6PLUfsKm43AfT02FHJJABN1o+NogPlR9cEw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a20293a6-b5b4-4387-a42c-08d958e6e8f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 14:31:42.2594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHATJbu5P+ybC/B7L7RBjylVn/vOV+oSFlsd3fjM3F9Wn6o21qkYZbHUEezUTX2GKPMoMXcPiYi59Iu273Rb5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6393
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 23:25, James Bottomley wrote:=0A=
> On Fri, 2021-08-06 at 16:42 +0900, Damien Le Moal wrote:=0A=
>> Avoid a potential NULL pointer dereference by testing that the ATA=0A=
>> port=0A=
>> info variable "pi".=0A=
>>=0A=
>> Reported-by: kernel test robot <lkp@intel.com>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  drivers/ata/libata-core.c | 2 +-=0A=
>>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c=0A=
>> index 61c762961ca8..ea8b91297f12 100644=0A=
>> --- a/drivers/ata/libata-core.c=0A=
>> +++ b/drivers/ata/libata-core.c=0A=
>> @@ -5458,7 +5458,7 @@ struct ata_host *ata_host_alloc_pinfo(struct=0A=
>> device *dev,=0A=
>>  		ap->link.flags |=3D pi->link_flags;=0A=
>>  		ap->ops =3D pi->port_ops;=0A=
> =0A=
> Hey, pi is used here=0A=
> =0A=
>>  =0A=
>> -		if (!host->ops && (pi->port_ops !=3D=0A=
>> &ata_dummy_port_ops))=0A=
>> +		if (!host->ops && pi && pi->port_ops !=3D=0A=
>> &ata_dummy_port_ops)=0A=
> =0A=
> So checking it here is just going to get us a load of static checker=0A=
> reports.=0A=
=0A=
I got a load of static checker warnings already before sending this :)=0A=
And I got lost in that load obviously. Will check again.=0A=
=0A=
> =0A=
> James=0A=
> =0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
