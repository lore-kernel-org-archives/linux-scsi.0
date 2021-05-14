Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E529C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED4066140E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhENB7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 21:59:44 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53819 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhENB7n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 21:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957514; x=1652493514;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=YIYfgOVIdwVTOyyRn2cyMPqffh3/g0xYzMb6Sdgy+wA=;
  b=YQ0WuWHJsqfzR5C+JGDvsAOK1Qp0WeZ1GcHwZDuGimYBNVx8xgDX04rE
   sLlyfEgCB4rDoCoH7U4J4w6zQCk2OlnkFrrFaNB/CQ+Ombo5qarfxhr1P
   VwQsRfgVu1nfpBE0wY+66tKV4j5tSB9rCHWo/gofhSZA8c3ZdTEh1yykw
   P/RqnaFB4Ag+kIBGiQ2UDOXbTVXW8qit8GfuPOHMmI6g2tWXM31/r4UHd
   j1tvS56+WIBmwD4SUvfJpA+ZIv6yyTSC4V6T8tNvwnfKIcmlLrF+xSTOT
   FaTGtX2wLIdN3WoiI3PlkJWUHnR2TGQnbWd0pHn9n74xuhIkBZK6aF4+W
   Q==;
IronPort-SDR: FjsQ8Wc27p0JGCv+u0+3icPN5YUzW6aNxhEltEi01qRhhAVKJLmP3HcmtMEorGOUR4qWZJmRHc
 ztTiV1CkHhMeru0qabJyfjUWZ/sdZsn2D1lxiH7Sj9038Fwnis1N/aA76WTaUCIHC8Id8Pxy0D
 EeXB4SYVlFDXiHU3q23IYmGW3V/UG1KL4vzwyVAeDO3sP55D0MGIiIbujCYsuT55/8YQbZuZEz
 VUIGn5s5yXKfNzpkazs2DF8vngvbk3/ZILqCEBISUhbU++UAAilE90OCzC2NfRGLgOm5Mjvu48
 mVk=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="168681295"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 09:58:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f28u6yHUW9WnvICpcXG5JdQ4WkSOmisNPFuTDiCsB3xNJ5IWIMDdgoNrk6BW6NWSekLFT9AGS/CP2LLjLV4xGDyF9vMGtggDctB2AwfqPPn8kSzjxmDdnvGvjF97yHInpNOlOGq1z8tlrP/VFOfT0J9tz0QO5LcD7UlA/2tUN524QmRFn4zKBgnzZ85IM/CodOqVnbXOCOOVNm5xjnKNbxLKLMUbGFHgt7rP9uHkawwZJGYXA3v8jhnTTKCf7d/nOoP2Hb1X3OtHXbPE43PcZNOI9XbQeMTg9bE+qQ2n1X3iiwRQXIW1h8abjg9XRBjrHTwE1R8UolPbXm/hND4wFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLWrpYPfaDXuD7dRv3b4WYxaHEypvx/qS++/AFBgUwA=;
 b=UAKJE1VpWyJhikslVM8l7xoOJmXE4GITUB5DhXPBm0aOQ/qTmJYGgKS5l26oCs2h7uvzm8jTzbAM+qfO7/OOzLYSmkA9+I0dbNIhsRhnqBBYu4bavneJpVReB7OX8y+8hxTqSte3nQWJhwrR1D8WLBhTL1m/xkxG0Oy0XgGVaVC2nDkqdVzP4hPE10Nz5GFPiJkcNvxxUu60J2Z6q6wwjkMDZp0SJ9IcthiS1BcglhIE/YfMMI+Lx/UIX87LqWr6d+41IwWlHk0UmQsJJ5llb5DWD8jotCIo4qCvpFqEKdaIbULLUwO4clHB2b3ISR/IBYSlbZlw/1RTHWJv7UUIqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLWrpYPfaDXuD7dRv3b4WYxaHEypvx/qS++/AFBgUwA=;
 b=RY7IPePmmg4uzs0Cu8B1SAodrECeyXC4gJSnrR8wrPty6aL8taiXGAKUYy8al+I3b69C9oSGYvdhpPNUpyDsOfKWM3u/gKN4xZuwSbFdULMZAnfF0a816d4L+N4qCUpYzduSZ/Nv3GHzuV+Y+ZdM6jMy6sSZ8dczxysmgqqhLu0=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6828.namprd04.prod.outlook.com (2603:10b6:5:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 01:58:29 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 01:58:29 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Lee Duncan <lduncan@suse.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v3 4/8] isci: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Topic: [PATCH v3 4/8] isci: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Index: AQHXSEiuUfS/PZLq4EqVm/gJ5VTzSA==
Date:   Fri, 14 May 2021 01:58:29 +0000
Message-ID: <DM6PR04MB7081C9DA912AE66BC57DB1EDE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 668210fa-7188-4a0f-0091-08d9167bc526
x-ms-traffictypediagnostic: DM6PR04MB6828:
x-microsoft-antispam-prvs: <DM6PR04MB6828299FA5ED4E069F56226CE7509@DM6PR04MB6828.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yfQd0pKlIQSzT+EO6bSJY1GkI1OuwJLmzY5KbXvx/xBtOx83j/rW+qRkYqyEQ/5s2AWQx5t/dP0PaDg3VCvNJSamlgbyiA0uus2SU3uULdvqyuHfGIZWQQIcf3HQ1GZGRvtCIijFncUmDNw8G9PLoECDbxFveSKAxTOtDfvvBo+EyM8tisvlYiTB9kZvaz8uYJjRvRdRi2W8Hu1XT0Cr1czaKPGIT49OuE+927Bzq7qDDR6n8ZhM+MYj7uzv4ogfFlxmrsQS36vvo/JLmpJU0qbXFbaia9S4dKLDAJByZY5mkKgltzlYU3RALx90daCwm0dgMEyjzQjPQ42FnJ0BDTGvlWogNTFEseWgGq7zqRfxGVpflfyi7SdqVM1/gFhu9F3V4M1NiZVXZkkeWeuFMOEy/Vjeokk+E/8MpfYhibEVG4D92fdHw11SzpzNQ5PDRH/db3PlhNSAFB/adDCd1eAYIVLl6jFOSABWL+duX5gvsbgSZ6HIVJaIjSfdYxMGfnOU8ISCmRTQlZ6gnU3Iu4/sYLoIMUqxr6YryVFKwk9km2n+Vk6pUfzBAWg51P1GkUKwK+Mr/yjZE/oJ/kRmorVPqFqyyf34YBpncNOsLYY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(71200400001)(76116006)(2906002)(91956017)(4326008)(122000001)(186003)(83380400001)(52536014)(38100700002)(478600001)(66476007)(66446008)(9686003)(8676002)(66946007)(66556008)(5660300002)(86362001)(55016002)(6506007)(53546011)(7696005)(8936002)(33656002)(54906003)(316002)(110136005)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WpUR1TAKkhCZKVcupLYN6xDrkTCjOl7l5li+WVX7LcMDMon7TJQQdbZP0SDn?=
 =?us-ascii?Q?D9IU9s2E80u/LLr2DHolpxHLTT6fvg2D55l2bMtbbCkvwvZI15nGMNSLi2v2?=
 =?us-ascii?Q?FgSZJk/vq832HshcdRCfqITgxD1ZiVPmKxfOKhY/BUsEmquDLE/jkqt9Ct9R?=
 =?us-ascii?Q?f5MGZNaRRS+75Xwcrg58uG3qOFZfTU037LEGGsFnNLtiohUT1OYSmGhvD07n?=
 =?us-ascii?Q?nvpjnaeSdpH2vnRazlkbDeFhCLk3UngHUkPvcovheSn/BPOBbnekhZeCaKey?=
 =?us-ascii?Q?ruBCZn01Y4ejvFPUn50/P/cT24j8jfkE2d8CiwhJAxVi4yp4TAIiJpBDeiqo?=
 =?us-ascii?Q?/3L0U8UN1014rBo84hKNVWOusShAKqumnFyqlxnldAEO20a4HkdUok2M3SMQ?=
 =?us-ascii?Q?QcGN7Do8sKExmn7lhbacUbp7JCj8WjFE7Q7X+3/TW2vP+QzF4a7ZQowbybRX?=
 =?us-ascii?Q?6fObPAwqar8ueRjYFk+qtjwGnsVT0SSP8HisAKte60An7DtuqBoXfPr4r1FY?=
 =?us-ascii?Q?0d7OwCxPJ1doL0mFYDZNeUTRvqqjj0f6g6qlx/cbUpsSe+sPNYUbw/DGYSHN?=
 =?us-ascii?Q?6Ilyhx9NhJUieT1iJWvQB+gRetLw2bz2eEa5hVxy64os82GYte6Ek9WqXfx7?=
 =?us-ascii?Q?1ns0UnqTLOtIQ76tDXRxErayvvSiNFuPyn1LiK24nxKtTpBnMA0jvFQLh9JP?=
 =?us-ascii?Q?og6iJQDQKrxVzGzLd/Q2I/puLR1bwc3BcLNiW59QdyEiCos1724iTCZzWGUC?=
 =?us-ascii?Q?oN9jjJPFA3dPVGaFr59bWnDxycwdHQay5vLE5v3pzf36LNs/5Kb4HEAg6bXR?=
 =?us-ascii?Q?RPcbYN3RGQMvGHBxrMk6i43OPFWzuQQYVyV639moeqJadWefpemB+3URkL0g?=
 =?us-ascii?Q?j7NsAiJrsxE1j2MOtZs1NMYG/srwRnXtZOH+3l40tfNTCQ+/KTE+jaABkUZ9?=
 =?us-ascii?Q?XDYFmt+v7qn+agXy/Fyr6D8SxcDELHqUZx/gq54vvqzRdbx4SHoL9RLAQpql?=
 =?us-ascii?Q?L0m2DW1RRsnFo82G+v+vj+LljjFHcBMdILV6JCOdcZ6L2hSKliGj2c5hvB5V?=
 =?us-ascii?Q?dLPJYqX8IsVOT7L6TkSAL+P4s92XCELK1JrRSy9UjBZUu//ZAkhB3iJO2fk2?=
 =?us-ascii?Q?k56cDpS46rrPl8KkxitJzEMdZJa4TgJMqnSD5Gyf05UTqsqW9Xivz1WtFFKZ?=
 =?us-ascii?Q?jD1OzhT7nOEuFk0fEfPJiFfE5C4vXqxYbzQlR6bJbB2fcia9XSVEqfVS06Ze?=
 =?us-ascii?Q?UmR4P+Gy2H04knFzjmUJING83grmZ2S4GJAjaqAsn4T9y/UdLjGMbNmlEk8Q?=
 =?us-ascii?Q?x68oqrNWLv50lUTqQWD54r0CH6g+8NrQPyJdoJzSgtaa9n+EAga73+sukoBy?=
 =?us-ascii?Q?AEbnZUK87CBLkBTciXcaVL5Jao0b7uB7GXDn5DruIUzZw43Mag=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668210fa-7188-4a0f-0091-08d9167bc526
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 01:58:29.2169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALKw24+F2BnX7lI/TMPjoAAmku7dIie43pmdQIhcBkKJGlINCKeXYPGQTnV/Vf3keVHl7KfN9P5lpoRGnSyS0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6828
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the=0A=
> latter is confusing. Additionally, use lower_32_bits() instead of=0A=
> open-coding it. This patch does not change any functionality.=0A=
> =0A=
> Reviewed-by: Lee Duncan <lduncan@suse.com>=0A=
> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  drivers/scsi/isci/request.c | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c=0A=
> index e7c6cb4c1556..ad24ddbcaea3 100644=0A=
> --- a/drivers/scsi/isci/request.c=0A=
> +++ b/drivers/scsi/isci/request.c=0A=
> @@ -341,7 +341,7 @@ static void scu_ssp_ireq_dif_insert(struct isci_reque=
st *ireq, u8 type, u8 op)=0A=
>  	tc->reserved_E8_0 =3D 0;=0A=
>  =0A=
>  	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))=0A=
> -		tc->ref_tag_seed_gen =3D scsi_get_lba(scmd) & 0xffffffff;=0A=
> +		tc->ref_tag_seed_gen =3D lower_32_bits(scsi_get_sector(scmd));=0A=
>  	else if (type & SCSI_PROT_DIF_TYPE3)=0A=
>  		tc->ref_tag_seed_gen =3D 0;=0A=
>  }=0A=
> @@ -369,7 +369,7 @@ static void scu_ssp_ireq_dif_strip(struct isci_reques=
t *ireq, u8 type, u8 op)=0A=
>  	tc->app_tag_gen =3D 0;=0A=
>  =0A=
>  	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))=0A=
> -		tc->ref_tag_seed_verify =3D scsi_get_lba(scmd) & 0xffffffff;=0A=
> +		tc->ref_tag_seed_verify =3D lower_32_bits(scsi_get_sector(scmd));=0A=
>  	else if (type & SCSI_PROT_DIF_TYPE3)=0A=
>  		tc->ref_tag_seed_verify =3D 0;=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
