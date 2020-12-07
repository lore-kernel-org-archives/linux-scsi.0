Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22876C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAB01225A9
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgLGHus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 02:50:48 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2812 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgLGHur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 02:50:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607327447; x=1638863447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WMbNqxqvaoEw/4RFosj2ua9zUv4jMWnDFBWrX85cxbM=;
  b=rrn35ZwngAt5SDYPcZORUs0EAo4BhIMA5TFgYDixb0odEU0Zwv1dylFW
   KVmuXtmH+ap1knNfMAueUx2QbLhNdlGaC+OsHaRJZF/64vU6zR5On07NG
   +FR5S40dyBccBmy22I1sREy6AECbugK5I5AxCnd7ijiNn/NVNPnqfD0ch
   WRTas/mOM5WKDJnCs3ChY5I2lb10RElptg32vLsiQq2h7/AO02H5siFC9
   7e89zwLDYS0qKLCnp3BjOLhNdff7IE3sQF1ztlpoMq5hs1Ab9g0vz6rUv
   N6FwlaNPXaDH2JcyWccbyaQvZuXdWDsc1dXsmK9wtkWk9klD7ecIYXvU9
   w==;
IronPort-SDR: SjaOyJdEm3P7hNweJDUainsLzsf98Ho9/BQctpRY1K1bShEMR9yO+ey4KMKMecGia4MXuFdINK
 T45INQgaIzIHjxWShPSWBuANVh4D5tO61rslmHincB38bDyYSamdzoUEwL9ZqX2dclpIf837bA
 RTB9CVkF2I49NYo0u9a0dy7E/revN4SEC1tQ2PBOUJmx5UrDAkFPGKzHnBzTzXaTG/35fgvYtE
 AArdCLjaPIdSwmWZe7qjptGtRukPCNGuBzZjA+YHmd0SYvhOLyy/BRHzenV8pXIwHrs13ETAH0
 kTM=
X-IronPort-AV: E=Sophos;i="5.78,399,1599494400"; 
   d="scan'208";a="154631589"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2020 15:49:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNvZC9k7h7Zq904vjzje18q8dbtHDTfptHCnT4AklFBqswr+wxub7FtHJZ+zaPlo2ZATZ/oFeJFOB3B0jZwNJTpS2Sa7R2tImLkhEnUy/GPoc/8TL8h1PUR4+SH3otBrEUpo+l5lhQz+sdEPROczJ7LlLxYVBG5e6Z3AWFs+3yg8tsZoDTAXUIjtrp8/qGV+ymU1vfNPqku8WQxMg/E5Q7W7hqVFLttxlGiGx+MWweXOPB0mV/AD7Au5GzRadxZ6hEztMk0bljg0O+OG56PRyNFTd8NYMZP2GBbfcddpg9LsjHj771l9VkPCYpsJcHpSL8NyN8H1S1bFOO5uKljpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcJ+3A5IYQX32eaamtB+PZhpdZHQeYLOoseRrxKdcIM=;
 b=dsiFVH6qk+BF/b74v7pqNVcU87ulukmqkJtR/dBPzAcNY6I2IWmU/PEDp8Owz3HlsZw+7gt+whWpRT0NJZWhxDnMdTfTD5EPhz/VlB5ILHDYDvIXoCsbwdvBq+V2v/IEDmL180Q6A3uNwTA2Pdaz/KQeYeJZpIN8S06TQ0SpOqAn15qwRhWkJdux1ImxkFK1RhefHDveBXSo6l5bvxEIqXR5aYlgl/Exfjo4h3LCNW2JW+8tilk2r/yojpVDSPcPd6UjBJ3JH44c9Wf1pCnIWU3r6HjJL7PJMImqwvskXj0WuT2n3txqLSiCYXT9NTCn4rKzCAORRy78U4TPn/wk9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcJ+3A5IYQX32eaamtB+PZhpdZHQeYLOoseRrxKdcIM=;
 b=I4PuMRD0uRRVUrDSqSar/9r/arLn4Dj2UefDy+8rTh+gNq3it0Oksku86JSnCRkJHGJhyPCDEVPpia9tH/rmsH8aNBmI++xLE8SSvcyt+wY04LZHPOClbzBJZ5rSCAmtjAczKeMnhtuN9T5O9+VPCTTol2tGKX4EhKTZX5Cntgk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3654.namprd04.prod.outlook.com (2603:10b6:4:79::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.21; Mon, 7 Dec 2020 07:49:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 07:49:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: RE: [PATCH v1 2/3] scsi: ufs: Distinguish between TM request UPIU and
 response UPIU in TM UPIU trace
Thread-Topic: [PATCH v1 2/3] scsi: ufs: Distinguish between TM request UPIU
 and response UPIU in TM UPIU trace
Thread-Index: AQHWy+7WlAKMNaTMjEeUciEKEXKoOanrQkmg
Date:   Mon, 7 Dec 2020 07:49:38 +0000
Message-ID: <DM6PR04MB6575F3AEE424287EF666A591FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
 <20201206164226.6595-3-huobean@gmail.com>
In-Reply-To: <20201206164226.6595-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 45afe380-360c-4176-614f-08d89a84a5d1
x-ms-traffictypediagnostic: DM5PR0401MB3654:
x-microsoft-antispam-prvs: <DM5PR0401MB365427B77E2D9270477DFFC3FCCE0@DM5PR0401MB3654.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVPYDTVDSkxU4BlpkY0cFQXGOUj9ujzxB5QiDuEGK7cjyllcRoDhm93ROStynzaEAvZdTU2h1GT5m2DTb1gqziKf8v4OjfFD1WcwN7xs2h3bTC1N0yvyWUSNxSrChdV6xw0OxeyAfVJsL3XXbuBM8ST3c8pxoajgaqPGSLouT/UdzEMNdPUxvRNhqa48QDhy2fvJcWun8WiqHjOUmbXjJlpwKEW7MxJhoSzIM5kOYd215hpzNyI6hyJFELFDtZvUc3sF72DyBHTLEan1BvLip8bijPHsGR5tvoEWE0xNh1iFCsFUC8WKUICKvW97RnK0FrLtiwuTQz0J+RhARSBm1yS9tDRWUoiZscXAS4UZoweIXyfA/+mLXWiGCfw+/Ife
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(52536014)(316002)(66476007)(26005)(55016002)(33656002)(5660300002)(54906003)(4326008)(83380400001)(110136005)(6506007)(66446008)(8676002)(9686003)(7696005)(478600001)(86362001)(2906002)(7416002)(64756008)(66946007)(921005)(66556008)(186003)(76116006)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XsIQ+3b4fNutACW/NOiX4BQTDiLlPjeM66vtjNJpAjzSr0Re3V/5wuhy2rUu?=
 =?us-ascii?Q?8rBfxgY8/f4P3rq4C9w1nwfaSBzziXbyVtXALJPWMgSoppP+i5eEa8OC1hbL?=
 =?us-ascii?Q?Xi/uE3Np8FtANKFCyx6/C1slapdzQsXkU1l97gcGoouA1zhKq40hIlH8xFdm?=
 =?us-ascii?Q?rCbNuR/OcONjnzjAY8S4CCrqysQbblh1vbF/N40z/vpUvABA5SwjzpJaoUWK?=
 =?us-ascii?Q?F9lVuywh3IhoFC88u0y2QLir21e0hv33hlOxU7K2X95fLcyWfcUuoKjYZD0C?=
 =?us-ascii?Q?jdlCfvkC88zeyTa7+ZAQywzudyRdDnWxEKz/9oW5X44L6Ey+RKLBaCCl+Nqq?=
 =?us-ascii?Q?N7XaF/5OztmN35gDybAmZQQ6p36ju6y9vCfoNZ/Jav7SLO9e2JBzQueC75tq?=
 =?us-ascii?Q?o9toxGYDnOn5q9F6OLL593Zd/df9e34OSj8SdL6AQ179FPOWaaC6b5JEQmE3?=
 =?us-ascii?Q?64UvAYuI/awWtTAZAW6JnMvDBP+JlswlG2NKtHlBqIu9Ssj43PZJ8ivUSwE0?=
 =?us-ascii?Q?xLn93pua0/Hse/KqhlSLIFVkk0XbwT73BOSdoynst/kymmIaVnhjoRI74AKW?=
 =?us-ascii?Q?viSzQ2qmL4Ft4kiU0rfz4lvPKBgBYoBH6dDWlYAzqVub6DEmdVcqENTnwtUN?=
 =?us-ascii?Q?bS03S8jVewpqEsSTVcql9vfzsfX6eU21L6x761T4VP4kCt26XgNS7K5BEiFL?=
 =?us-ascii?Q?utmw8p8sIsKO511I8Hgo8yNAuXJ/iS59ZfWC6tALqqoYmdFm8TKzQHdlStlJ?=
 =?us-ascii?Q?PiMwS/iq3n3MIu7hoh5K9p4NkKsIbPEM0ABzH6VZH/7ELihbIjUsFkAsF2bW?=
 =?us-ascii?Q?poesKkWdmO50ziVZb6H0GZMpsfVta7NfN7aAJJOkMhB3Sw+zRPfiQg7TICND?=
 =?us-ascii?Q?9dtLusDXFUXThOboVmSDTuhEzPAgSRQXwFm/knLyEkMHoAs6QO8qIvxfP/2H?=
 =?us-ascii?Q?R406LbX39wGA6iFc9kqlMYYc1q+GLJ1VxrYD+a/zYTM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45afe380-360c-4176-614f-08d89a84a5d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 07:49:38.0272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rd9XiAv5zhSLVoNMWiz3+4Cj2104NIbV7MBEV97wyxZoKwIhzywDT30Izwek62aY97Q7vLIrud2IWlPNUmv6UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3654
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Distinguish between TM request UPIU and response UPIU in TM UPIU trace,
> for the TM response, let TM UPIU trace print its TM response UPIU.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>

Again - same comment:
But you need to change the complete string so not to break the current pars=
ers.
I would also pass to the  struct utp_upiu_header *,
so no comparison is needed.

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e10de94adb3f..29d7240a61bf 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -338,8 +338,12 @@ static void ufshcd_add_tm_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>         int off =3D (int)tag - hba->nutrs;
>         struct utp_task_req_desc *descp =3D &hba->utmrdl_base_addr[off];
>=20
> -       trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
> -                       &descp->input_param1);
> +       if (!strcmp("tm_send", str))
> +               trace_ufshcd_upiu(dev_name(hba->dev), str, &descp-
> >req_header,
> +                                 &descp->input_param1);
> +       else
> +               trace_ufshcd_upiu(dev_name(hba->dev), str, &descp-
> >rsp_header,
> +                                 &descp->output_param1);
>  }
>=20
>  static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
> --
> 2.17.1

