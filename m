Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84725C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C6864EE1
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbhCAMcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:32:14 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9902 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbhCAMbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614601908; x=1646137908;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8R1VHFvPi1BzlTczVhg7LVpzI2IUM0w3ti30gumsVOU=;
  b=RrtuUqv18NSR641yc+WRKAaqs1t95CttN4SZcHtXXaaYpnzZV/ntWqZa
   f3lWvyKb2yETp66PjIvoQvjydjgFWSNdq+Zkw1mb6itXWlmTrZ9jAVfSr
   uA9cKj58NTPC+PhzlOotdiVRC6fvRdu2RZggqx9X2bpBzIYpVpIldm12I
   t7fEf+6V4junO5nTXv7MqaiyG4BVwXKx52bdufiVgNRUXLVydeKSqit8S
   O0t7Ey88m2CbmQyIBymZBMf0/gUmKUv4PXrT8W8TzY1JzLBnikieiDWKm
   t4R/oFrT+zdOzQS1AQmckujpKa5PBetVHwrdyYln0BsiNahyK8bgJyEVx
   A==;
IronPort-SDR: 10LBdqdEvmZQDNG4UkFS9v9XxJb04Yw2RchQ1rany27iDt5k361KkSDlSuaoJP7tSeMmmxTL9p
 IAxCEraBCw7EsVBWA5pbsyBwWfFqLeihLTalckbeNA8mlZB8OmaC/HPU96FEDxdr8dUa9bJvJP
 OXaeipoJ8H/37ify0OZY/V0056R+qBoywcCv8PzQ/3HlsNa+uqoQV2cC5c3vIpZmBZ9a8cTYZJ
 vhHYZvvqnDEfYvLKKuTCiKHxfecZO1ARRtOAUPA8hBu7PplV/tATwuKDy02B5NuMXoQmLFcJyt
 phY=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="162229908"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:30:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtY02OkTcpvnDYyws7riS971X15pjucjvh+O1pikd1TNIgAezMLsN1CFkOTF3c5WtWXQgTnj/YMmfs9H67En+CFEHhMHvmwI3bRKrfhCJXX5mWA2SfeLQUFUYB2Lb5NMNOrjGSjxB3W+r4JaH0A//gQ84FJZbz+Uhe/5qWmRkoiLIptGvwljB1zaQDlrf0A9ghTT0eAk9LOwuhLu0a4S3PQGWO3G4Mhb9BG+E6syOk9tMjhNgKdTKjFRoZ4154O6a74y5uM+KsF781v1FVg2jENERgOY2kbhBo8O3a0ADRay9GKrG+sL3vZB8LOCbUzdb2I05D1HTdJJPIL4sNFdQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lcoo5cmQPPG2egrdQPRWUxjfG/Ts8gOJZZez9EzOII=;
 b=lwzbntLbozezJNtCHo8GxmKRPSPxaYdR8nqDGOFnJ9Fvpk5QDtr5kCNEygCshhKIBtul7VhiGa/1Nzm8hHZplArwzrfQjsSw8GGAzVS3r9y+fjHbmhObPs/yYOI0oNBRn+8MrXayTg3CWLH8pBKKdYcfQ2+mzcKLqrtINGYs0gIz4ZlbXCJaCVhoomToH2ODJF3dHnSTn/a2ud4uwazYDZgQ7jpgBGYJoFJXkrIz4TM42R7v+qmdnNPTzXTM2B6iDM94ZL3K2DiXfPxPk5N8yh/kqZBF163pJ54OH8lkqs3qH/qxjkhApb8Qx1AU6x4X+35gMMXQslNvxPAcjfLs2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lcoo5cmQPPG2egrdQPRWUxjfG/Ts8gOJZZez9EzOII=;
 b=GgoT7f9K5rPHaWFdRTxh2CTwmg98CnPSPG6Cw2O2p4yeHXhT4FBGVOfpYfN3CcT5yGTVpt95BLGyuOGKTA4yhxS8EbKAjePMjXGGV4Tj4v6udKAGJ7LR1q9uUxQpLI+l+94cU5xduZmqegmeulOHgjfkfwoav9RP/+f0n/VfHeE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7573.namprd04.prod.outlook.com (2603:10b6:510:51::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:30:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:30:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 04/23] targe/pscsi: fix the warning in pscsi_complete_cmd
Thread-Topic: [PATCH 04/23] targe/pscsi: fix the warning in pscsi_complete_cmd
Thread-Index: AQHXDZcGpvaC2eoEI0az98DETPJ2PA==
Date:   Mon, 1 Mar 2021 12:30:33 +0000
Message-ID: <PH0PR04MB7416CD9028BA4018C349D99F9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-5-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1aef5d6-a0c1-4563-1886-08d8dcadcf77
x-ms-traffictypediagnostic: PH0PR04MB7573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7573507A56C650CF0D92D1CB9B9A9@PH0PR04MB7573.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNPoa2e/dK5BJYItFySolforev3LzLMXnCHkoEsML4D+9sqcvltCs/h6Ch8iywOkBl4XtslX4J9luMbGCwjka2vd4VR9uYW+hKuXiknKQYyPdI0YwwE/qHeMlLWQCFnAcDqKgNHC0pFMskrPsDsMSr+dV0Mm2fHpyMIwOi4Yxll4GceJ3KxmrntWuyUi4qIASJT6CRMPH5ZbP70qLOCexFzQNAYGgAypauKYQIZmXzaQfC2/jUQg5k1lAlVzekwTeDPIexQw90S9zi9Reb1M/X1j4FUlTG8RrS63JEGVgDr55OftFE+3BF/HgA5ii9IMWWYTFuXBP2rdEc0wCSsDWDDzRJwTCI0E4cr1rE9nE8i1sO1kDJv3BdsJvTl8DNhh7SnxwXwt+DHTc6AB+3N4J4nh+CkuY2UqLxbLF/xqoh/E87/Qd+vaglhk0dSSbzY3+dO8VuuIFlzw7OEcDguKPd4lNih3U3FMKqlRoQBv0rW+ARHXn4xrsTeSW81a4h83raFXNjluVwkEe3WHWif8L33fthZB89P1ZiJ0nd+CB7R7fSask1stnCVHxIaWkF6W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(376002)(346002)(366004)(5660300002)(71200400001)(52536014)(478600001)(8936002)(110136005)(53546011)(2906002)(54906003)(55016002)(9686003)(6506007)(186003)(76116006)(86362001)(66946007)(26005)(8676002)(7696005)(66476007)(316002)(66446008)(33656002)(4326008)(91956017)(64756008)(66556008)(83380400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?DDfFjEsLLqiFJ0iTuY0xBJJR8rHBvV/fFNJtTK3HRGwiDFSaS4xqLta5?=
 =?Windows-1252?Q?s7BQmGZyigWuyaQEIIV5ddevoD1Srgq4C6M5zA8ho+SCnoyVAFfbNIe2?=
 =?Windows-1252?Q?PbOoTAEmcytqlILIqWXrlBNZ4aJZiXvIXle0ARRfnABG+sw9vHD5G2TT?=
 =?Windows-1252?Q?FimkOyh2TKkFe7RYjECCoK9DVeX5tWcNSP3/iu/l8zULGPZdK1e8M0rU?=
 =?Windows-1252?Q?RHpoi6Wfm1IXcPiC15cwjYtCq0Vr8+eu9Km/x71P12+3yjU9KuNZ5ZKW?=
 =?Windows-1252?Q?DWEr0fppHkT3/7wJ5LvkLhaJ74hW9lP9ap8NtWSnY0W6CZqZXazacCKN?=
 =?Windows-1252?Q?5wj6uo3ViSDhdC23nyPhZb/2USigkwtcsI7DE/+YLnDDBpLUcZyGhxGW?=
 =?Windows-1252?Q?vcOW9t/aY21H0pJDEZhoFKo92RxhTCgD0C/BcWaZdE9A4Ei3/woA6Irb?=
 =?Windows-1252?Q?ARRUx44nFWGrJUVx2euriW7tzAcEcjmI8VJNqBbTJcLJjRBcFYTfPuln?=
 =?Windows-1252?Q?vANRQsZ4yQDmyawDjWhfWeORKNec3xY4K4VMWaedsI3f5xQJwBe+HiRk?=
 =?Windows-1252?Q?MLlhKQBmnMCNhZeDSJqnK9OMfmWCOWfwBlt/AIgkqX08B3SNNzhMwbox?=
 =?Windows-1252?Q?uYMiw+KwcU6gqw3Md1kMgsfDl4C0yVil7o7+aKm06EgCjFqdkVTywef8?=
 =?Windows-1252?Q?wNAXfUhJn4D/k1T1SRseQccjDjKVJ/dsOf5uiUNNhLSKkfTYPrNIWXT9?=
 =?Windows-1252?Q?AHOWP9jub7LAz0LdPIVxYi14hYQpgJr5i3uI5NAmiyb2pLEfxiM1Pq49?=
 =?Windows-1252?Q?ArZJklYwbbzdGcKiG2p74OOYqAxElMvwyHdP1WP0xMabpEzQqtTeOOPB?=
 =?Windows-1252?Q?xMFF9SiL1pSiG9uRqS5nfF7JbD5/0Cjo0ejpVK17fYqazWz5uNKliFJW?=
 =?Windows-1252?Q?dNRYktb7HByokBGjOCaOGx7kaDcABby2mcRB3oPZ/ovPAEVw45Xxb/hp?=
 =?Windows-1252?Q?NBQpLxrUaMa7BpwfYwoQy2uOtSeq7T/YjRu9WPJkGhxMlGpTHkBiij0D?=
 =?Windows-1252?Q?JHaV2ipV2S1w+vAIz1ZyzoY6cT0FRONpP4+f4l3Zpn/iMtOBYHwZ2Z2b?=
 =?Windows-1252?Q?ZQqxOUG15MDijRCjOkw1OQBU4WfW3TEDdvUdSTkJ8VcUCjLAwVcqKJMd?=
 =?Windows-1252?Q?uXE4XFH6YByeWEUTNyDrku7ZuI30rxtAY6X7+Lkq7VauC+wjWl466fGk?=
 =?Windows-1252?Q?slnDdexJbpZbI9l595rWMUV5C/Rwve2QBP3BnY1HaymvW/T5c0eRG7Kh?=
 =?Windows-1252?Q?K+FMceD+o0tQdYHJreu9LDrNdXB481OTrsz/EdRfrPvQOQUrqK+W+M+M?=
 =?Windows-1252?Q?ok7ah1h13sriWGRrkjiH3+ibIV5W22otORSJxgJ4PXa2xcr9aMy1Y0Df?=
 =?Windows-1252?Q?g+kUtEl34aNFtU9P9nRtxw=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1aef5d6-a0c1-4563-1886-08d8dcadcf77
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:30:33.9503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+COhf2mhR7VwuN5z5iwm1w/rXDABG19uRyomxtPDhOVRJuddtjWGhXRHd1XrZ//3oH92xAnGE9/uW+16SxDNUSEThgJ766YtNWjkEZdFQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7573
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/02/2021 07:00, Chaitanya Kulkarni wrote:=0A=
> This fixes the compilation warning in pscsi_complete_cmd():-=0A=
> =0A=
> =A0 =A0 drivers/target/target_core_pscsi.c: In function =91pscsi_complete=
_cmd=92:=0A=
> =A0 =A0 drivers/target/target_core_pscsi.c:624:5: warning: suggest braces=
 around empty body in an =91if=92 statement [-Wempty-body]=0A=
> =A0 =A0 =A0 =A0 =A0; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */=0A=
> =A0 =A0 =A0 =A0 =A0^=0A=
> =0A=
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> ---=0A=
>  drivers/target/target_core_pscsi.c | 3 ++-=0A=
>  1 file changed, 2 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_c=
ore_pscsi.c=0A=
> index 3cbc074992bc..689e503e3301 100644=0A=
> --- a/drivers/target/target_core_pscsi.c=0A=
> +++ b/drivers/target/target_core_pscsi.c=0A=
> @@ -620,8 +620,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8=
 scsi_status,=0A=
>  			unsigned char *buf;=0A=
>  =0A=
>  			buf =3D transport_kmap_data_sg(cmd);=0A=
> -			if (!buf)=0A=
> +			if (!buf) {=0A=
>  				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */=0A=
> +			}=0A=
>  =0A=
>  			if (cdb[0] =3D=3D MODE_SENSE_10) {=0A=
>  				if (!(buf[3] & 0x80))=0A=
> =0A=
=0A=
Do you have any plans to actually address that XXX? Because if=0A=
transport_kmap_data_sg() fails (and it can fail for various reasons)=0A=
and we get a MODE_SENSE_10 we'll trip over a NULL pointer.=0A=
=0A=
I know this is outside of the scope of this patchset, but would be nice any=
ways.=0A=
