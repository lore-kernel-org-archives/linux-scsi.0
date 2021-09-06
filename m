Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB437C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 22:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FFC6108E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 22:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbhIFWeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 18:34:17 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9018 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhIFWeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 18:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630967583; x=1662503583;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=AMbpB3IzumI9aS4pMgJyBuXjiDQt26M/l9BMwoJ5kYs=;
  b=GWVTaj55Y4opcfnaPYKlgu+8awJ3D2MhuRN0w1M8ElJlGJ70xBy4hkyG
   bVa5CzEf6Qs2WE8QRlYs/XcWJsAyDuN8NhKiOk9DVwOtUmMa72Ds6g/QX
   EuHUflfzOrQ0IzPhxvyRc+r26VTQIkQ41fiTMglEUwqN+JSR0ohTZEMIA
   p7x6984We+yIlGPf0lz2Eo2T+lKFFXtZY1SvdALMwGwGICerR68BTFeo5
   taOBYXPCFyFTRselzVTwmQ6AlhZRcgizoVh30vxpDK9Efjhk5M7yk9m/h
   EwcYyHOGTo4G15EwxJovR8nin28BOY99qOZrzWJiV9lIh/d35ADxMGOuZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,273,1624291200"; 
   d="scan'208";a="179853330"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 07 Sep 2021 06:33:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/MO0CbPkvKMBgXK6kBIaDDbcHg7CkBNRlYgGDRQY5Azc/1QNtsKG9KB68Q7KpxEFDBiet42IwTFpwo+uGkxBoZPvIq9fDUYv+UB2xfh3KtMi/pU+d84qHlAc9EA6psfjsrNEhJDfPnSJUQw5hty/vtTOijoUD8bil6ZfT0hdEMt8x4Q+5qcp/rfky+BJLOB8mkpimBtpCC3Y435nNkBZ7oTc8Zp4fsly4FhMTxMXDg/acf+Bg0gK6UgrtHpAqRrY8Y+pc8HDOlFJQys9h5nZSYRCiCiUqhqUSGP7howrRHsp2fwxxzEfYT1pNfAb+mR9388Rt/VgsB7ApFomiHJRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w/ejeD3faJJ8qkvBoC34/bhh9XfEmSeum9dJmNim9To=;
 b=hHKCkcqSmavvLr49b0Bvsb5vAvuxf+AOcEDGtXCO9RbrEXsqSnaBrWkvLWjB6mlRu5pnu/rtpw923uNaJdzX0NbibqCkZ0GZiMVvpRKERFj+9HuRZwTojJYPAx8jRXjvQPNedCaM/R3an2XdQ79W8p+0Xlnb1i5KCYSV0lQqcrdiT0YG7U4Sgffg2OQhqzVS+SQzZkaMKJE9lboLtSMHmyojxekBMPm+N+TDarmjnaNXd9/aFrXKMwG4snizxvAQaoaOEkdpei75IS0fcEHa1EHosBNq2zzbHwQoGwrKl8njXEESNOsU4SOFf7vdaEtPmaho4eCM/0ywJXa6dy5bgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/ejeD3faJJ8qkvBoC34/bhh9XfEmSeum9dJmNim9To=;
 b=z/1IxRe3EN5uafGYRx83qYRIqmJ3VEbcbHJPAV6erRuPU2NP0pMyUTokEzLW0ZRDzNGkk0/4oL1TEDyKxnoyxmBJKL2jseloY8m0bjSzFVczIQOttKujFRS4gGY+L1fGopBF2YoqAwunuQ/RyTVnC+TB6jkax7qrK5wLMOHSL1w=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6940.namprd04.prod.outlook.com (2603:10b6:5:241::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Mon, 6 Sep
 2021 22:32:58 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%7]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 22:32:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to
 SECTOR_SIZE
Thread-Topic: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to
 SECTOR_SIZE
Thread-Index: AQHXoyiJsu1NjIkfXEyw4FhrAEpn1w==
Date:   Mon, 6 Sep 2021 22:32:58 +0000
Message-ID: <DM6PR04MB70814D38382FB9D185B7EA4CE7D29@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210906140642.2267569-1-naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92166f87-33b2-4f52-f826-08d97186472b
x-ms-traffictypediagnostic: DM6PR04MB6940:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB69407A5F1261DF90A975B92EE7D29@DM6PR04MB6940.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1oxv2iB9nFBTBbTs7tKBpnPNJajH28QRaWE4w05WkyIALEdy/2Su6I4dVkvK/OWiCvPO+ion1IP/oN5Vf6AD/87nlJsF33gZOm62q4By1Mom6sqksKbXBpyfcUjkszJdXH/aROevd9r/yNKiLV7TrMruCOiOyYVgRalFk4EG8xvBkzemabHP1gciF6w5gi/PSBSyT8GEGPA9aIL4IPq4BiJPyTdd2BXumv6UpLHgeEZHUZv+LRuvWCzbsbzQgrPtUOcqCNVKJJyK9F4YG+2wPaP1rrCtIHVwASomydw52ZuT/oNHbu7hHU7F7oLbO/e4Gw1OKeaNsFTb7DpYKWH8ZLlUBjroiRncKuIaWEZ+K6ALrbgbOhMn8pn6anRSoCTQiPbZRYweXz7ifbf47o44f04shP8KLwhzQvaEIIdRSdW6/1Cv5lRJ+FojAaGS5N4johp8KlsmMOswwsz+li3Na1XQLzb8C/nns/t8K4DURvT2UFbYBMFNsiViKGkgzRd87DXiYbdiUPnLAndcQaxB7HTfOFpzhgDvKkzREkSwpXwVfjSnjyaCWToyJMwb53jBIn9khXzZwzEXbeo1NtPn6WZojBwFGkPpM+h/PJFetVVEhZqEfzKPtbrmj6p846tWnJPJSP55+4fLGtKxCi/Ta+D88oAP1LRxigL8q5Syc9MwEWJ1Yap9zpimv+zDGsNWu+dPIpU3jWOmuU8vjEI+ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(110136005)(7696005)(122000001)(38100700002)(316002)(54906003)(186003)(8936002)(52536014)(5660300002)(38070700005)(64756008)(33656002)(4326008)(66946007)(71200400001)(91956017)(76116006)(86362001)(2906002)(9686003)(83380400001)(66476007)(6506007)(66556008)(478600001)(66446008)(55016002)(8676002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z4WJuupkiFJLGsJQGJhfYjrXD7RKqxI4JL67tB/BFNPSiNZ8kRgI/Mr18949?=
 =?us-ascii?Q?Bv7/hjGGJWBroTZZd82xeucqNNNoKp+B/qjkM3veQ2RBTWqbosyWSWW0kA3T?=
 =?us-ascii?Q?eSRXWxKsq5hnDnSv514OL1bzto4vrjgHCC0fEcYj09YW6y2KvLacJWBmp/y/?=
 =?us-ascii?Q?ZfFtPmIrpYn/nTVBS+0K8KlctfzdYoGRZH01fgA+kt+GirjHb+124pcJc9bE?=
 =?us-ascii?Q?pK5rhMgWAp4ztnLvcEXMCxlMsGOqvQjAt7mhh6VDk9pRBEWGVm/oQXUVnyog?=
 =?us-ascii?Q?a9XxYTZOqoyPFjXY7tO+bH5qe4p6qR0wHhRrOUK+ptRykMw8iMRAOe/4wW35?=
 =?us-ascii?Q?mg6m/t+Gx3QgphRwB20LVc4rB6S7KEyjHMUusN0glE55jSYWqA9TP7itafsN?=
 =?us-ascii?Q?IDj06K6hMV3NHuNYChcb6+wKChqgU19PQseSUJvlUUoGRg1A+593DuSRT3sQ?=
 =?us-ascii?Q?6q6sikOMGB1KsYtAFIxEIjTmzbg16gAg6OvolPXhFa8ABdGXelwErFhlIQyb?=
 =?us-ascii?Q?cEoruxowPzPKfbogu7iSXZ0N028assz8IUX4+9HG10Gen0zSzau+8OiuySTw?=
 =?us-ascii?Q?zBCw0wlvWhhtOe4KAmUeVw8RQeYmKzwzCA/nX3ASyJzNfHT1HOS/M5uVNgf5?=
 =?us-ascii?Q?VtdbmummIgLUSwLZSQ1/34I9war/zfQBh9jyAtXTypQio3N1EqNMEPiowhZo?=
 =?us-ascii?Q?Mhjm8HojGK34UrGBvpKBuhbalcAnuLvAeFFQ5ryWFu0y/Hjkc97jtUnDkM4a?=
 =?us-ascii?Q?8CDuvH3eDctJ4zKsgoNDaYWqRXR5H9wDHrS1rC2HzBX8nJ1LXh7cPxqNuZ+T?=
 =?us-ascii?Q?P6B9z+qcUBCm0f/jeyhB4NyVvpWxmcnR06H0QJ0e2mEek0d8k9Sge/nFocBS?=
 =?us-ascii?Q?mT0e+MZ1Qph1yHUw5LBcf/a4nFL/CffWU2RxsUFDpD/xVM2aRO6ukO74r/Fz?=
 =?us-ascii?Q?ASnyB3NYWdJ3XuZaRbOHVxnIwMYuBuPta9z31V1j2Lmt3Ws6t5eMvq2YT3tD?=
 =?us-ascii?Q?EnGORj6gTMh9LdmIS8hS8ov8jr2O4ev5wOZUK/aJjD18ueuJ4IiiraIWi6zQ?=
 =?us-ascii?Q?j4q8x6r08cwszbWVAJ6UEb+cWNoilBGaMG/jT7UDpTTS9tKD+NizlohEMhd9?=
 =?us-ascii?Q?d7vKivDHMKX7inocYnS1uLWpmHAOXdALdVOvjpNO1SYuePHVTuO3h/I342Er?=
 =?us-ascii?Q?3If5+U9bA5JcBJdFhFFnvJMjgKOv73tHhJcSkzXQzAgrAMp25yNdP5CraVRc?=
 =?us-ascii?Q?2RIn6+0DqAJFx8UBwDDzgncBkWJmIT7ZsR3pt6FbQBchYPzwghIQvohnGiG1?=
 =?us-ascii?Q?pXGES1surLFW2d3RU0+KIH9nriBmyFMHGa3CpblKg5yqHrXfyXs3yepKOvcC?=
 =?us-ascii?Q?PRne4a3eKudPt7hOBF9MinRXeG+5YFKvyCBhjSSeGf86YEHBTA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92166f87-33b2-4f52-f826-08d97186472b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 22:32:58.1444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lk3kKP6343PL7t5IZjevFjdQ5Sd/Tb8/EVrWb0gHlx/6TwzzlIc6L+slbwZXvO3zDbo4ZR/jgfxkkmjyLZldyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6940
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/09/06 23:06, Naohiro Aota wrote:=0A=
> Reporting zones on a SCSI device sometimes fail with the following error.=
=0A=
> =0A=
> [76248.516390] ata16.00: invalid transfer count 131328=0A=
> [76248.523618] sd 15:0:0:0: [sda] REPORT ZONES start lba 536870912 failed=
=0A=
> =0A=
> The error (from drivers/ata/libata-scsi.c ata_scsi_zbc_in_xlat())=0A=
> indicates that buffer size is not aligned to SECTOR_SIZE.=0A=
> =0A=
> This happens when the __vmalloc() failed. Consider we are reporting 4096=
=0A=
> zones, then we will have "bufsize =3D roundup((4096 + 1) * 64,=0A=
> SECTOR_SIZE)" =3D (513 * 512) =3D 262656. Then, __vmalloc() failure halve=
n=0A=
> the bufsize to 131328, which is no longer aligned to SECTOR_SIZE.=0A=
> =0A=
> Use rounddown() to ensure the size is always aligned to SECTOR_SIZE and=
=0A=
> fix the comment as well.=0A=
> =0A=
> Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()"=
)=0A=
> Cc: stable@vger.kernel.org # 5.5+=0A=
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 6 +++---=0A=
>  1 file changed, 3 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 186b5ff52c3a..ea8b3f6ee5cd 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -154,8 +154,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_d=
isk *sdkp,=0A=
>  =0A=
>  	/*=0A=
>  	 * Report zone buffer size should be at most 64B times the number of=0A=
> -	 * zones requested plus the 64B reply header, but should be at least=0A=
> -	 * SECTOR_SIZE for ATA devices.=0A=
> +	 * zones requested plus the 64B reply header, but should be aligned=0A=
> +	 * to SECTOR_SIZE for ATA devices.=0A=
>  	 * Make sure that this size does not exceed the hardware capabilities.=
=0A=
>  	 * Furthermore, since the report zone command cannot be split, make=0A=
>  	 * sure that the allocated buffer can always be mapped by limiting the=
=0A=
> @@ -174,7 +174,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_d=
isk *sdkp,=0A=
>  			*buflen =3D bufsize;=0A=
>  			return buf;=0A=
>  		}=0A=
> -		bufsize >>=3D 1;=0A=
> +		bufsize =3D rounddown(bufsize >> 1, SECTOR_SIZE);=0A=
>  	}=0A=
>  =0A=
>  	return NULL;=0A=
> =0A=
=0A=
Good catch ! My bad :)=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
