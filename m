Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864A4C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3340822B3B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 07:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgLGH6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 02:58:37 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12758 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgLGH6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 02:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607327915; x=1638863915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qa7ByIQL7Vh8UG2z7963EzRCNRFEKeBA69bBqgkz8ZQ=;
  b=I2e6Ooa6CkUkBKl/p9vMWz+YSQi/MLB5/isZgVl3hYMq8ubBWojLN/4u
   JmsZFr9OeAOlXoXVYzAFpYy6pEWoq+Ovfu+zhKdnPQ0P+JFSSnweBf5e3
   iBxV6Tx+kxQiUoJbHgeBbr6KfnOHGaQQw1XRDtCyerqSxYrriM4pf3KkE
   hje1SLNogirCWTw7s9w/kXhokHp3dqI3vWe7iA3G4kgGJ88wKDQsiQyTC
   Mq3jJRAU1/KzLLeJYi2eWHxSEjLMHAP4Jee3vIq7ozZoxOdPVMEyZdxh5
   dwFE2LjrthaG85j/XchOMxQCSQsjDc8r3SJ3esKgl4e4Xe8iVWnBlAZkV
   w==;
IronPort-SDR: ibL8Y6XnXh4+dXo6xMgBnLtwpMVOssXHbzPXfi33YrC8jmuCATBUWkwp6vZ02r2+9pAWwWsZOG
 gTq1yAmOkFV13lceui6evS9w2XCbnFynIP9+HvkSQg4nedQ3P8L2IGxn593cFrk8i0eZIkjRUz
 nc7KQJ+P4BxGCF0zhnVNVJ44G3cPBXAxd0l3GozKFqj1Xvjnk7i5wthEC8ZTJbd/iHMBYQQxr/
 P0QAaNu9gYAfEO7CaKmhjHnYIpHCtZtEGJ6thl9BJPoJhZk82vCnyTysXhTqztta0WsNIphn9W
 I0M=
X-IronPort-AV: E=Sophos;i="5.78,399,1599494400"; 
   d="scan'208";a="154551363"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2020 15:57:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKSE204UcRUfEHfp8ax33FMMb+5E+BHMlf7jAZ/WQDvSv35bLDrOeKGoSPpPczjnvHnSCRiFI3ZwDJplG93KXVd1f3wM95MoyfAuOedY8b7Fl2XnfIAauFk50ClB5NAlGG9U2HAEiBWfG++WYEtTiK6ARusqzUhAyy7Yvb1HmiLW8MERqOVXgq1EVNlUOdVPtUIvSMf4epyRkhKoA41wgt5wDTop4FMDc4Bt9v0kj5UKICUVPmKkCQF8hYFEiWGeGBF8iSU6mMUydft4uNqVU5Aa1dh2X2mKVzrw7ZhspJ+R6N6EeZfk+x97A8HGoQexXaF3XY1ny+A8tiu168nx3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XccahQTnd88KStYTkRI8BAQac+MFPP/3aDdB53IcsUE=;
 b=mFQ6pLdIPrBqnrm5F2UN0aAldYLyol2/XI1uHioI/C6zsY7g5xR0hECDBpZVueMMRV+1OSmawahd9pwPbVY/8GxZErRbCSpDQAgw9/cGrN9g6KfM76baGGr7a2caejHcy98bNk0oWH1TUmRyEXeup64Sc8c6WEQQ+qccW6Z1TRoaHZx1p7iaigD4eGTMnamFwZUXcmSuCZ6XsyDS2pn+2ktbiW5tuNUvZxOMpOAgfOjo7/MPSs9oJXj8eRI8w2yTZOiehpyPCjhakTdZDDiNet2oV1Io8libsoI/DwOy8vrlwWkl6xtAVIHdcrsSZTmH2D65G/26pDY3/L23remo1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XccahQTnd88KStYTkRI8BAQac+MFPP/3aDdB53IcsUE=;
 b=wYlUEIj6tHlTzltSFprg9291cfvBlg+F/RNdhgM3qkvHR+wzYn/oHpXiiY91OAiWhHMXeunR9OPdPbKvbqGTHRklBEk862AFYRIAnrICutC5wxq6N/oPuU7UccylohbceLaz+0oMBXHdVg01RIJAfGZ5jDSMVICVqXWZe8dr3hM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3654.namprd04.prod.outlook.com (2603:10b6:4:79::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.21; Mon, 7 Dec 2020 07:57:27 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 07:57:27 +0000
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
Subject: RE: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Topic: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Index: AQHWy+7VP58/cpTtqkiyF4OIctzYqqnrRKJQ
Date:   Mon, 7 Dec 2020 07:57:27 +0000
Message-ID: <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
 <20201206164226.6595-4-huobean@gmail.com>
In-Reply-To: <20201206164226.6595-4-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31e35903-95f8-4d9b-02fa-08d89a85bda7
x-ms-traffictypediagnostic: DM5PR0401MB3654:
x-microsoft-antispam-prvs: <DM5PR0401MB3654B391DC1035CAFCE83592FCCE0@DM5PR0401MB3654.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HWD4xV6W4cuZJjY06Tf40r97/Nx4fh31o0BGmn6rMPpLr0fSzfeBG5P1RJLgjI8jSpj6o32V52Gsv+tLsqpJNOzIfrWmQzdQ/NFgOsY63FNieidOVMpHOwZNLp3AVjAOh4Ywsnry1URKV7m9dsWNzL5e7iSGDQWLRkwT6+2QtjzOyHzxON0XTKTanQeTstkmp8EKc8/6tdG9ygeduZFeZzmhmy2Z9oiH1a58a9cZGtFn3RO1lSBiru0AGKLYwZXCOPoEN4558mj7E2IpJp+CaVRspXc4kfSB44FH1sfVj7aypvsuRlBkI5XruMHICEw+GjebCcfC8N27T6FBDo9+ShkD2T4lRXhMa+9t7FtvUq6HHawPEm+ojFsRVkb0tcY9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(478600001)(8676002)(66446008)(7696005)(9686003)(186003)(8936002)(71200400001)(76116006)(86362001)(2906002)(921005)(66556008)(7416002)(64756008)(66946007)(55016002)(33656002)(52536014)(316002)(66476007)(26005)(6506007)(110136005)(5660300002)(54906003)(4326008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6MzTmaojwbsLJsuT01H0+RW7pxRxjF5PQk1ikmyRGhXQ5e7TA+YyNuO7np0K?=
 =?us-ascii?Q?5wJMAf94gQluyzoEdL+CcpESrhmYV3+zg1JsbaXlA1ZsIfn135acQHg3zO5j?=
 =?us-ascii?Q?kTxmY/fvkJxw7JKGhkkpjv6xAdSb6m3BG5qfxyK6wpNmLbdske4rCg6ZkGXq?=
 =?us-ascii?Q?7zBJSzqEqesAcVcHRLK7QoxicihIkzq3hGSCRZ1BC/+BpZJWGDy8fjdWC347?=
 =?us-ascii?Q?7pOjvvFbJWxi/KsYHS1f73f4mwIkk/ke9xm+fAJCGPpyGtKmd84m7WdK/PAC?=
 =?us-ascii?Q?KYvNl4uuZAYg9AGR7Z6AkonCkjXpLwWdmvagu6/oJQOkVNd8+APrhvURPxUI?=
 =?us-ascii?Q?Q8Oh9vIQvgiBZJVPULyqXzcB9p7zcM+a5d/POi6d4qflKerJfstFOYpw488Y?=
 =?us-ascii?Q?RopPYN8iVGZEzQFzTFSND/n/z7pmV0KVK7h7HC7dZb+627Hn9/U4vYJtgXeW?=
 =?us-ascii?Q?hW8aRdC2jrTNYZl9thKsfneeR4V7YSVXlvE1F7wXI1M+l2HTkaCJUuFZghXt?=
 =?us-ascii?Q?7MG/I7fDMactPRAVRhBXBrbQvRabFiYRnr2IgmsLeX6N2XDSnRh66aQBn+p9?=
 =?us-ascii?Q?0xx453lQvtlLqRdW9DyplR6k8w9vz/n3FNxl8B0acwYojQlntoyd9dW0K+e9?=
 =?us-ascii?Q?cERHxob/owktoFXt1OR32sJf0RWV//K6Y9xz3eYOAx5XcbK6RU+WfDS8wr+g?=
 =?us-ascii?Q?fQPUp+8y89701twHFyTFAqf7Al7iHxbsFtpjfnJRj5DIq1Ccl1o49Z+A3ncS?=
 =?us-ascii?Q?6byVZGq9VSQIuXkEE4QroS+WdlaGViI/FfcEVeFvlyRjs2+YR4uovD8olzuY?=
 =?us-ascii?Q?AhY3inX7f17K7k2RmzIpGbkyst8IE0pl6yl7qY7uYGHDDpThAQO5toPDZ34Y?=
 =?us-ascii?Q?q4CxI4okBUZEp92gEQ5uO9tYNrPrb8bBEDLTTLcw25hac/rV394tXZbKBwny?=
 =?us-ascii?Q?jBqgoXjlWHujdLdsisW3gHIiMsTxiyzWO3kv8UqmQic=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e35903-95f8-4d9b-02fa-08d89a85bda7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 07:57:27.5166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gyuictb3F93OUzuwnTKgkdxGmSazwCwyGc5rjwlpqgjFMMQJl500hVI/Vtyc01n11KjhWqJdl4xS4LLt8cQezw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3654
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Transaction Specific Fields (TSF) in the UPIU package could be CDB
> (SCSI/UFS Command Descriptor Block), OSF (Opcode Specific Field), and
> TM I/O parameter (Task Management Input/Output Parameter). But,
> currently,
> we take all of these as CDB  in the UPIU trace. Thus makes user confuse
> among CDB, OSF, and TM message. So fix it with this patch.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c  |  9 +++++----
>  include/trace/events/ufs.h | 10 +++++++---
>  2 files changed, 12 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 29d7240a61bf..5b2219e44743 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -315,7 +315,8 @@ static void ufshcd_add_cmd_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>  {
>         struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
>=20
> -       trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq-
> >sc.cdb);
> +       trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq-
> >sc.cdb,
> +                         "CDB");
>  }
>=20
>  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned in=
t
> tag,
> @@ -329,7 +330,7 @@ static void ufshcd_add_query_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>                 rq_rsp =3D (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_p=
tr;
>=20
>         trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
> -                         &rq_rsp->qr);
> +                         &rq_rsp->qr, "OSF");
>  }
>=20
>  static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int
> tag,
> @@ -340,10 +341,10 @@ static void ufshcd_add_tm_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>=20
>         if (!strcmp("tm_send", str))
>                 trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_he=
ader,
> -                                 &descp->input_param1);
> +                                 &descp->input_param1, "TM_INPUT");
>         else
>                 trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->rsp_he=
ader,
> -                                 &descp->output_param1);
> +                                 &descp->output_param1, "TM_OUTPUT");
>  }
>=20
>  static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 0bd54a184391..68e8e97a9b47 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -295,15 +295,17 @@ TRACE_EVENT(ufshcd_uic_command,
>  );
>=20
>  TRACE_EVENT(ufshcd_upiu,
> -       TP_PROTO(const char *dev_name, const char *str, void *hdr, void *=
tsf),
> +       TP_PROTO(const char *dev_name, const char *str, void *hdr, void *=
tsf,
> +                const char *tsf_type),
>=20
> -       TP_ARGS(dev_name, str, hdr, tsf),
> +       TP_ARGS(dev_name, str, hdr, tsf, tsf_type),
>=20
>         TP_STRUCT__entry(
>                 __string(dev_name, dev_name)
>                 __string(str, str)
>                 __array(unsigned char, hdr, 12)
>                 __array(unsigned char, tsf, 16)
> +               __string(tsf_type, tsf_type)
>         ),
>=20
>         TP_fast_assign(
> @@ -311,12 +313,14 @@ TRACE_EVENT(ufshcd_upiu,
>                 __assign_str(str, str);
>                 memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
>                 memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
> +               __assign_str(tsf_type, tsf_type);
>         ),
>=20
>         TP_printk(
> -               "%s: %s: HDR:%s, CDB:%s",
> +               "%s: %s: HDR:%s, %s:%s",
>                 __get_str(str), __get_str(dev_name),
>                 __print_hex(__entry->hdr, sizeof(__entry->hdr)),
> +               __get_str(tsf_type),
This breaks what current parsers expects.
Why str is not enough to distinguish between the command?

Thanks,
Avri

>                 __print_hex(__entry->tsf, sizeof(__entry->tsf))
>         )
>  );
> --
> 2.17.1

