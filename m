Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9893C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB55861181
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244396AbhHFJcf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:32:35 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18139 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhHFJce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628242338; x=1659778338;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/YHrjmSQZEk+DIonElp+nI8EKGPMisBvq7hFIkDJXqE=;
  b=fy8emELIlUtShJPHoTzqgAGjo0U02EoVF2D6WymSRvAoYfA6fPe44Zil
   8t1rZt8jqC1J1/M8S5zyb1R1qW6UeEBOSko5aLgNzb9uWH2/PlBggpkfm
   WlxvROxIYQh1CVjWXjLHZ5tT4Ttfp74j4WEfYdAtEGDBxfqzmp75ijYTw
   dKt5Vb9vJKWy0XDxMyvBjUzwTbl+KcdDhJ1A5tadbwFRnsn5Y/wzkFxoS
   hZxY/J5zzTwf5BzG3bAIOm48DVvKgE1Dw1HPrgjuOeSodsiuel2hRpimO
   KzHX0yETB5JQp12XbVmbmSxAD6oW4I9c7/FvvyYKxULqRyih6eXfQwPH9
   g==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="176491322"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 17:32:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHI+TbKc5I+CtIvbechHkX4ZkHpa/evlQLMlkVXb1HOcMYwzh7v7A8bRe7cw/dcYtkEUNkr8Wc7NLgJI6PZLkFpV5ABwnrLzoUr1fldtLkWItbJf+noRMq3a9fR6XOg/VTb/CtCssXH8e6JhlzYuViw1cUSbslkVaTfcQ3yxAE8//rvIeFOrWZJ9uBemnMfwAV0LFBfuiTG3BsjUUfSNU1ISM/8jBSXYMaZuz/ufTpgWgscYSEQ0UofHLJpWwb/ueGdGxMA5Bb8SY86EyyKAvpT08y0JTLzAYB9cVwAa8DVL8/8keM4lOrWpFts633qDL0szieAvJFghWs6RFo04Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGFUPIKhfrYQCImWe4pZPrJCHgcQy2rXWmmFyeLu8P0=;
 b=Ai0NyLIyOJqyiOs2rbXGLFYv70pbX7ylq0gckQ/CqLaItIweQamexR2YDozvPk15/KOKLJbUF42mMUl/6ShcsIWQMbTlIEPY6iNyD9zGG+e20h9s4cdHmGEpNV3+/lv55bvqYc/YYGgKqkabYXnibZLaVjpFYYIPXZPooI/OAPkXMC/vXKzVJkkr8lql5f8piwMSyVBQetoZAcN3Y0R1ogKidcJ0WH2SJsywIw5dBQ3Me3oMpsw60vnmUBopyAl5pmjn+19HcwIe5sQisLmssgDk7lGc3bVgMRtdFHpOANeS62afkbIWaeV6B3Pl3Hi9bBvG/deqPg+BVUBrFIzEjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGFUPIKhfrYQCImWe4pZPrJCHgcQy2rXWmmFyeLu8P0=;
 b=WUwZ1k4T+3eHHBnGl5fHmdn2zzR4wsJ+X/4QkVZOdenrx4eiaY5Okvh9hE07qkIebVND+tHIvsV7TN9K1ExJLZMA6Vz1ICcYZ4yNvNxcgsoW0BqP27M6CGp2/b/0JxoA7SQJUMkwfHPsWZT0/JinL9dn2HR8Fj8rP6gbG27VoLA=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5594.namprd04.prod.outlook.com (2603:10b6:5:163::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 6 Aug
 2021 09:32:16 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 09:32:15 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v2 4/9] libata: cleanup ata_dev_configure()
Thread-Topic: [PATCH v2 4/9] libata: cleanup ata_dev_configure()
Thread-Index: AQHXipazgzKCJe3fBk22G/vppECdlA==
Date:   Fri, 6 Aug 2021 09:32:15 +0000
Message-ID: <DM6PR04MB7081B75EE5507E4FEF9F94CDE7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-5-damien.lemoal@wdc.com>
 <cbba17af-a35e-a837-a5a6-1b12d6445f0a@suse.de>
 <DM6PR04MB708145CEBEF79D709B679090E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
 <0fd18f2f-dc71-9d57-cfb3-afca4b37b3e9@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36a22203-bc4f-4a99-c89d-08d958bd1413
x-ms-traffictypediagnostic: DM6PR04MB5594:
x-microsoft-antispam-prvs: <DM6PR04MB55943AC0578576CD7F859A44E7F39@DM6PR04MB5594.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:114;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ohvznF8OrXsk3GbIW8f2ETIClU+7s5O/mBsIPhlM+u8/pQpROJfHip5GNcbuxUOegJJuhSECzAXKuENMowQyoYNQIJmCnmCALr26u8fJPCck49ozfe+QK1yMef+z/NwVowjA9PBaKHx+96fsjnHQgOdvwQXhs1vlKwsxNpWQWqwm/3JEhRcFeqR0ykJL7r99VOVwV/xqomxVkQTS63ivhilgF9oDJ9hcnnPcTqskYWvCiGh1yj6saIxnFIMTjQf47pSM0SKHNrOnw15PsSHQbcUy7YQANwnhoAlXFdmhGgwkgTmdjQfsSNP1gykukc8fN513VDAVN888+9FGN/MEs1oSHnG30vij6n+dksUaeeTQ+75OcfQy1By5K0OPm5jQarl21DtZfppwHgNNL/FQB6LTyt8kQogiZIik7FXMR42RgTxdw4TBwTJYylYXpOwpO7X30L/dKzXo9yZPR2VYpvHDdNBo87taXM2xjGui2dvNpIK1+nsSLD5b9Mu9QrTDh9Qy7gegpyBteHAzHkSWc70pQ4zJgIoiUs6VE1fvY2YiMJvavn6Ve2slC/9sN0u22vpVROdzQKOBDzJ78Hcdz7qvHu65KBE5X4rZk0SXQudgdcHBWloBtYX3zwGdQEgS2rNlqUBusMOgrBNAr0DOw9svJ/VaSLzUBJihIGaIvbrUE9PVeVWpNoMcbzVMid8ya4TLzg3Gt5VPL4Plm7Z6mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(55016002)(76116006)(316002)(478600001)(71200400001)(91956017)(7696005)(110136005)(38070700005)(2906002)(122000001)(54906003)(38100700002)(5660300002)(9686003)(6506007)(186003)(83380400001)(33656002)(53546011)(4326008)(66946007)(66476007)(52536014)(8676002)(66556008)(64756008)(8936002)(86362001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5EeBO/SH5PuxHy+4vseaMtBBIGIYpTHE/cCYdg3C8vzAKS6oGeZxShdr1p8O?=
 =?us-ascii?Q?RskC2BQtZ0wjueBInWusAipNyZ6c2mT4GICXRVIGT9pVu1tBvpoXcFSJtQqx?=
 =?us-ascii?Q?z0D49nTaHzTXbE5ARDEacb4j7hVCTe5bvfdlhbmR3b9b/7VixGCGO1h1iy+Y?=
 =?us-ascii?Q?YJdJtpxxYvbP/uKtUoU9u0jL5lMNr+/jvTeOamn+IbuHR2IuijEM/vQsoWAO?=
 =?us-ascii?Q?WUcBeq2hdBSJ7Ao7VmGu6oBz9VOGoOhU4TBlNK7Bp1iaGNhSKWwo20w0jXz/?=
 =?us-ascii?Q?bNhhL4hMp5OAuJj4UhRLu0cQ7CeGmftZ0c+RTVNb/enYnYBJeCIWDTZmO4Hi?=
 =?us-ascii?Q?B1HDb333Dc4xLpByoj3SX390PlMcKwacRDilhYe+y7GZwcewc+jUdsxS5zN4?=
 =?us-ascii?Q?ctNWIGKxNaz3Vr2Fjfjwq/SV2L+l94MQQvM9BTeNfoO2WbpKgRUKX6+hhysl?=
 =?us-ascii?Q?MeA7YK/AhSJawnEW90+1Uet6vQ0Fq5klunD9I5b+33QmMJJY5Heq/yAM2vvd?=
 =?us-ascii?Q?xLL3vh7ksUhC10XQ0GS/nElQhpMQIwDQo1tVJoY9iVOikPlrS5M8w0CW9rnr?=
 =?us-ascii?Q?7faYLEl05b32hWYXDihKKtDv18uAudoewH1MP0T0JqWFlEVP94Zsx03G1n5Y?=
 =?us-ascii?Q?bDVqu1mgtsrLtwthIKSDlmPBVw6H8ya61AcMbwGp5JZAufpAQ0FoWO9UFGGJ?=
 =?us-ascii?Q?MWBKct1yw9fjH5B4zN6lrlHoJ/7tC1cvvffGyXCl3CUPZgs3cx++wMHWN39O?=
 =?us-ascii?Q?XK/xjLuy8u3+Fqarzl3AzIZkvZs5X6h/weE420ZAmzZLMGvATiqUdmPxtFp9?=
 =?us-ascii?Q?pQnu+kvnwdO+VgfG4BURf/6GRmByfFlFJwX665y7b0WI87277T6mSz7KexWi?=
 =?us-ascii?Q?SQHu6MdfF0N0yzeuA2OJLbZ+nN//n2VDCVUwy1ZAF0YaHSx6DrS7HTvHuoU8?=
 =?us-ascii?Q?ePWT5EF6FzOLDG45wCLRq8a/0yKg6lBfJGb0JejjjRsK1PekpSAr1VfqoiMf?=
 =?us-ascii?Q?fEXS+oqe7aQ+0zuGiFFFhgnVgOxIK64MGg0uJplNPK7UH5aux/ABSIuM4HdT?=
 =?us-ascii?Q?+La4pKnA4FzwHRpU1zhIpmgMnuXKPUGOSKt9BucCsQus480iV3FPDcx2Ss+z?=
 =?us-ascii?Q?TcKRGIlctqRu7xzGZTwcyNuolK0dAn4Cw+P8gRAR5Vcr8e/VsADZw75/P13y?=
 =?us-ascii?Q?+W1AkC+qn2N+GThIFOR/NfAWuPkWgPRCKbRJ8ivT6Kk9VJdIQlvw3MkgN/RL?=
 =?us-ascii?Q?zHpdI0A8rbSkvBTuPQBL29JXjyPsIRk8FbiiDoeyuyAx7GvxLXwXIne6ydcr?=
 =?us-ascii?Q?6I+tWsT+5H7b0m9BTt2kPX5cFKq6VPADCwtYCm0pTxw+KxdHx4vCd3/188u5?=
 =?us-ascii?Q?uDsd3csQYVJiiYgoaJGBHL7fvehV5XPCGvT7xQVwF/bmZS+Qdg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a22203-bc4f-4a99-c89d-08d958bd1413
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 09:32:15.7096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EbVKsQSgHcxf2byTGxUkQtyNAVb9eGxgX55UYIk46MqDAbZxT6L2YEj0OVnYHo40pJJwU7mR1mlnFX9n4z45Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5594
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 18:28, Hannes Reinecke wrote:=0A=
> On 8/6/21 11:12 AM, Damien Le Moal wrote:=0A=
>> On 2021/08/06 18:07, Hannes Reinecke wrote:=0A=
>>> On 8/6/21 9:42 AM, Damien Le Moal wrote:=0A=
>>>> Introduce the helper functions ata_dev_config_lba() and=0A=
>>>> ata_dev_config_chs() to configure the addressing capabilities of a=0A=
>>>> device. Each helper takes a string as argument for the addressing=0A=
>>>> information printed after these helpers execution completes.=0A=
>>>>=0A=
>>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>>> ---=0A=
>>>>  drivers/ata/libata-core.c | 110 ++++++++++++++++++++-----------------=
-=0A=
>>>>  1 file changed, 59 insertions(+), 51 deletions(-)=0A=
>>>>=0A=
>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c=0A=
>>>> index b13194432e5a..2b6054cdd8fc 100644=0A=
>>>> --- a/drivers/ata/libata-core.c=0A=
>>>> +++ b/drivers/ata/libata-core.c=0A=
> [ .. ]=0A=
>>>>  				return rc;=0A=
>>>> -=0A=
>>>> -			/* print device info to dmesg */=0A=
>>>> -			if (ata_msg_drv(ap) && print_info) {=0A=
>>>> -				ata_dev_info(dev, "%s: %s, %s, max %s\n",=0A=
>>>> -					     revbuf, modelbuf, fwrevbuf,=0A=
>>>> -					     ata_mode_string(xfer_mask));=0A=
>>>> -				ata_dev_info(dev,=0A=
>>>> -					     "%llu sectors, multi %u: %s %s\n",=0A=
>>>> -					(unsigned long long)dev->n_sectors,=0A=
>>>> -					dev->multi_count, lba_desc, ncq_desc);=0A=
>>>> -			}=0A=
>>>>  		} else {=0A=
>>>> -			/* CHS */=0A=
>>>> -=0A=
>>>> -			/* Default translation */=0A=
>>>> -			dev->cylinders	=3D id[1];=0A=
>>>> -			dev->heads	=3D id[3];=0A=
>>>> -			dev->sectors	=3D id[6];=0A=
>>>> -=0A=
>>>> -			if (ata_id_current_chs_valid(id)) {=0A=
>>>> -				/* Current CHS translation is valid. */=0A=
>>>> -				dev->cylinders =3D id[54];=0A=
>>>> -				dev->heads     =3D id[55];=0A=
>>>> -				dev->sectors   =3D id[56];=0A=
>>>> -			}=0A=
>>>> +			ata_dev_config_chs(dev, lba_info, sizeof(lba_info));=0A=
>>>> +		}=0A=
>>>>  =0A=
>>>> -			/* print device info to dmesg */=0A=
>>>> -			if (ata_msg_drv(ap) && print_info) {=0A=
>>>> -				ata_dev_info(dev, "%s: %s, %s, max %s\n",=0A=
>>>> -					     revbuf,	modelbuf, fwrevbuf,=0A=
>>>> -					     ata_mode_string(xfer_mask));=0A=
>>>> -				ata_dev_info(dev,=0A=
>>>> -					     "%llu sectors, multi %u, CHS %u/%u/%u\n",=0A=
>>>> -					     (unsigned long long)dev->n_sectors,=0A=
>>>> -					     dev->multi_count, dev->cylinders,=0A=
>>>> -					     dev->heads, dev->sectors);=0A=
>>>> -			}=0A=
>>>> +		/* print device info to dmesg */=0A=
>>>> +		if (ata_msg_drv(ap) && print_info) {=0A=
>>>> +			ata_dev_info(dev, "%s: %s, %s, max %s\n",=0A=
>>>> +				     revbuf, modelbuf, fwrevbuf,=0A=
>>>> +				     ata_mode_string(xfer_mask));=0A=
>>>> +			ata_dev_info(dev,=0A=
>>>> +				     "%llu sectors, multi %u, %s\n",=0A=
>>>> +				     (unsigned long long)dev->n_sectors,=0A=
>>>> +				     dev->multi_count, lba_info);=0A=
>>>>  		}=0A=
>>>>  =0A=
>>>>  		ata_dev_config_devslp(dev);=0A=
>>>>=0A=
>>> Hmm. Can't say I like it.=0A=
>>> Can't you move the second 'ata_dev_info()' call into the respective=0A=
>>> functions, and kill the temporary buffer?=0A=
>>=0A=
>> That would reverse the order of the messages... And I wanted to avoid ha=
ving an=0A=
>> "if (ata_id_has_lba(id))" again just for the print. Moving the 2 ata_dev=
_info()=0A=
>> calls into the respective functions was the other solution I tried, but =
then the=0A=
>> functions require *a lot* more arguments (revbuf, modelbuf, fwrevbuf, ..=
.) wich=0A=
>> was not super nice.=0A=
>>=0A=
>> This one is the least ugly I thought... Any other idea ?=0A=
>>=0A=
> Well, it should be possible to move the first 'ata_dev_info()' call=0A=
> _prior_ to the if(ata_id_has_lba(id)) condition, and then we can move=0A=
> the second call into the respective functions, no?=0A=
=0A=
Indeed, it looks like that would work. Let me try that.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
