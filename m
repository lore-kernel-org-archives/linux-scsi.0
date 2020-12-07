Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A44C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94FFB2220B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgLGHqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 02:46:50 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47967 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLGHqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 02:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607327209; x=1638863209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xh0ypUQYT+fX7cd5HPIrH3ISAjefbW+kmJF3Jh1ualQ=;
  b=FitMwOcJdbCTguUJ1264qRHsXlAYUxOft75xJwUICJmSsdFifmMsHJU0
   YJZO31qi3+kcMXQi/L1eK9268xWqKnDlHyaIytoQ62cuEppIupN6RZzeI
   wYBPrlQ5cMqtyvFoiigO7GLvZQEQBk8qb7a8KpezNENcE8wcSMXKgNoCr
   0w1RTKezKfDPHslJ5Jqz8Wi5FiqrEWTDrcOHmxxGZC9gxYDRS6YomZwLt
   1i18WhMOdAckmMuBZRKM7tvz8ERH0O/n7cPjuanKTgRRTtSlpLb4nL55+
   k3CnNJ0U7aD/smove5BVTKs6AIS3NFas7l7vLx+PzmnL0BLM7EtMgRbBn
   w==;
IronPort-SDR: ipo5ixYfj9nGb3NCK9rbALJM23GHyagz31rybyt4+7cJkiX6LGJRkhSEAT+Rd9gRMAHNpzua47
 aX70nZEYtUwnc9aY/sgEeT/uEEcHitA7x3czkadfdOjYLnNYve/B1LmlzkpTdSmAK8wucdcuuN
 ulTHNbyVMmF4pvQhm14A+MQkdexr4DKxh2/mCy16n0hxn7/1/RX/zMcU5UMr9IazFEviBn0wlY
 V0DedzoxcbMuUQv3DewrtcWfqHb9jvQuX1Zv15wTEzNoR9PNvMF9Xj8s69DOdeS7SPIW4HMoP1
 EKQ=
X-IronPort-AV: E=Sophos;i="5.78,399,1599494400"; 
   d="scan'208";a="154631386"
Received: from mail-dm6nam08lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2020 15:45:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhMX0aUTF6ZyBDI3PsEYr7wQhEjVEyHGJmi2WB/yHQErB6GV3jx3QlojWj8SVOG80aRGQs3+Ol4AcCRThQm2VkF3BVK8TRWlk0mbPSlEz6GLLil/1Cbgv+XTbiqpsUkvef/F9N7V2jwRHznbnphVxRrpDW2YSkC91aXucuOseYDKSHnbpisNiwLrCPVBimyifMZNoSTgSlSCfmnNLstYCjXa0PF4zr1QnpMFvcykgDaQhY2Dp2YZyy4G7xmXC4157E0zvQ1wlCUnyq7DaOwE5nJ9FQhi0ZrHfRSGinbw70zzYWdVcgm/X0QL45HypDsDBQsV0JDjKzy0SUYJuzjNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pk+CgbMTJjA81sNmUmxCEqfIk7I0qAv634ZCoUdofpY=;
 b=hR0bqCF6RgFLwxoIcD9EngXAdCpMMd364JRwwHuNJApaGMQ3j4TkTCUSplhMulsdqkHU8vFKSHcjQSX9MfBLLK7aIycmw4OBRwTG5wOc3dfMcGPxtu4eVn88tHYa5SSuy/+rXpA2Cja+rwhpS9oObBH8r/+U/rGmxKsdi/IP0S75xq2DKDYaPIrqjIhElFQostW2wLd4MUwmLbWlIaNl1NIKrXV3MQTovX/ZJ/P6gL1/8eimdRDYPZuSMfzkccByhVxTJosfIETe7RO+SrtSE5UrUv9xJxEW82VM4/ntEu/8gAFGu4RshYLldBD1W+V7CEIaOSfHQqOpm0HUEesYqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pk+CgbMTJjA81sNmUmxCEqfIk7I0qAv634ZCoUdofpY=;
 b=uzOKUQLESWaNCVkMDdV8ELi3WsyE2u6kCH6XoYao9lMEoCdOZ37EwN4KVWGYe2HZDFKx6U070+k6JNzHjJ5AktIyDqAajdz8enKZAzLzTCJccZ1bAcvIx2g26+TmyxESWiWE1NslEbtAQ7uE5WM4id7gnNzF1L+DZeHPvsHee0M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5947.namprd04.prod.outlook.com (2603:10b6:5:172::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Mon, 7 Dec 2020 07:45:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 07:45:41 +0000
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
Subject: RE: [PATCH v1 1/3] scsi: ufs: Distinguish between query REQ and query
 RSP in query trace
Thread-Topic: [PATCH v1 1/3] scsi: ufs: Distinguish between query REQ and
 query RSP in query trace
Thread-Index: AQHWy+7UoD6YMCkFLkq2lSN/rWGYaqnrQMtA
Date:   Mon, 7 Dec 2020 07:45:41 +0000
Message-ID: <DM6PR04MB6575E8A098E324E2061C793FFCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
 <20201206164226.6595-2-huobean@gmail.com>
In-Reply-To: <20201206164226.6595-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 97439c39-4342-4f50-800f-08d89a8418c6
x-ms-traffictypediagnostic: DM6PR04MB5947:
x-microsoft-antispam-prvs: <DM6PR04MB59473B68CE3A464142376094FCCE0@DM6PR04MB5947.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HTUovSqq+KG2Wc+fnXk2RbePQg5SFyPHt8imTggl9In9yO6xKUavtasZNAdzvdZ+vTvRk1m2uifw4agjFPnJRHuAuxuYkv1uf0lw6VAZk3jT1jbdOJwQUv+l9zqIC8aENY2T+Aa7VcHGzhUOVNGiiNVpV3qbqdDzenaLjaZHSc8OWZiD0K5po5e/Iy02GXvVUnpTh9OQqTSgT0jXpm3PIZMyfKjw9vF2SMDwxfeFXpg63oA4dC8XpPa2xhyzLdV4o+YErJnHH7mYg0KjHlQCCkcEdXANPJGThnOX08vB9IxJUWoaG0kkaz71tDoMC+FuceIe8p6MHxGk9o6el2AmijAJ1N6w6HYEkckjYLIwhKWXPwJI4yl62SQPstZTmW3KMxzRp5qFNDBkI6nX1sCSCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(5660300002)(86362001)(71200400001)(33656002)(7416002)(55016002)(52536014)(9686003)(4326008)(2906002)(8936002)(921005)(66556008)(66476007)(6506007)(26005)(478600001)(186003)(83380400001)(8676002)(66446008)(110136005)(64756008)(76116006)(54906003)(316002)(66946007)(7696005)(505234006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kZpJMZY1ZoHMYp6zo8zAkiH6laW8ER2edelR31gpPJs43BhL0rS98VYswrbT?=
 =?us-ascii?Q?BVnvgL8+F0oFrZ3h+dBm37UxubOkOasSSZkWRwCgcaNbMXmY74gOXSPFi3ZR?=
 =?us-ascii?Q?h7swPvdTQPcIR6zz4Odg8Y85q5bcMjGIBeIDFWVmVCmKOCmmvrm3kItlozww?=
 =?us-ascii?Q?69xpWSy00Yu4HdqcEfkWLskf9ID1Fxfq+xXAP1sZPL4fG8++1Et5Wg8zG1iv?=
 =?us-ascii?Q?OislU7qCyGn3JtuV4q7LnmnlkPVVaeEzJ5zQWFu1O7n4kUgcyvMjTHiU1SRY?=
 =?us-ascii?Q?NDz5uZxEONF7zNy6OX+flov6zkMhoxSya6p2PcrE8QoWkAbuPri2uvnejPLy?=
 =?us-ascii?Q?73jm5BuhxPcGcsOj/DKk/EvbKcfx6hIpEpwzAJ1UjJ6cR8AsIHdKwdAkIJ7I?=
 =?us-ascii?Q?am2s/3Z7ji1y6LXfexbygj30vd+D9tLlDCT6MCBhoEQmmDAXkxnMT5TrwQij?=
 =?us-ascii?Q?dwbYHjajSAOvgFM9bdcyMXdtdYQOuXBkdj9AbgJ6Akid6u17SOfawxn/5Oyt?=
 =?us-ascii?Q?XQW11ivhxc71p1DJwHeD3f/GLURuXSanh2i0K/Qiv+eGAWv38N9MmcdMzm2T?=
 =?us-ascii?Q?yMySw1/HEhGRoHn1N8osnbnp1t+VmAeVFjXB+DpYjVEaB9Pv/VFwZfLJCWGX?=
 =?us-ascii?Q?kMxVGru20ay17w/tiCNWmz5psICJs4EAd5g4MIfj1J4g9DOpGbuaH2q10xUw?=
 =?us-ascii?Q?YRMQ070+0qyjx9fQenluRHUDQivKHV641lKrwQ4tQ0E7lVbwAqIvS4TJd40J?=
 =?us-ascii?Q?44gFYi+iHSDxLLYySaDuduB7TLAiTBIjX+msXdyI+jTO7FjSAbQjq6VDaqXt?=
 =?us-ascii?Q?3pDMVjgrMTqq+3JdEXIIwsiu53nFaKeQmCAmXiqv8CmMKvSSkSHorybdlYmW?=
 =?us-ascii?Q?87jRuFIjOhVzPR/emWUFw4ahk6YD2A3ND4MibGqmhBEeLscBN7Qs6FSR/Kch?=
 =?us-ascii?Q?hQGCi32e6VetapnsiD0xbd+6bjHz9Dryhz9lcqj7ADY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97439c39-4342-4f50-800f-08d89a8418c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 07:45:41.4201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQDjpixXPtwKCgm7cEdVwlZROZaWK9/uCGcAff+s0+sb0P3GPcI2SSSx5tvkosCZR13WgQUM/0DRPIZDKyPL9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5947
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Currently, in the query completion trace print,  since we use
> hba->lrb[tag].ucd_req_ptr and didn't differentiate UPIU between
> request and response, thus header and transaction-specific field
> in UPIU printed by query trace are identical. This is not very
> practical. As below:
>=20
> query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 0=
0 00
> 00 00 00 00 00 00 00 00 00
> query_complete: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 =
00
> 00 00 00 00 00 00 00 00 00 00 00
>=20
> For the failure analysis, we want to understand the real response
> reported by the UFS device, however, the current query trace tells
> us nothing. After this patch, the query trace on the query_send, and
> the above a pair of query_send and query_complete will be:
>=20
> query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 0=
0 00
> 00 00 00 00 00 00 00 00 00
> ufshcd_upiu: HDR:36 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 =
00 00
> 00 00 00 00 01 00 00 00 00
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>

But you need to change the complete string so not to break the current pars=
ers.
I would also pass to ufshcd_add_query_upiu_trace the struct utp_upiu_req *,=
=20
so no comparison is needed.

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ceb562accc39..e10de94adb3f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -321,9 +321,15 @@ static void ufshcd_add_cmd_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned in=
t
> tag,
>                 const char *str)
>  {
> -       struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
> +       struct utp_upiu_req *rq_rsp;
> +
> +       if (!strcmp("query_send", str))
> +               rq_rsp =3D hba->lrb[tag].ucd_req_ptr;
> +       else
> +               rq_rsp =3D (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_p=
tr;
>=20
> -       trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
> +       trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
> +                         &rq_rsp->qr);
>  }
>=20
>  static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int
> tag,
> --
> 2.17.1

