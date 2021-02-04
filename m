Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF4BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 09:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12DC764DA3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 09:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhBDJg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:36:28 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46384 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbhBDJgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 04:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612431384; x=1643967384;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=g2hm5SQx5nZChldMpLoR4eEX5GwnM+CeWzh9eeCiVfQ=;
  b=O3WFGuL5jKpUhBCHMCGgRyoAte/LxCeRnxoUVbKdj4zzt/LQOFtRl7cd
   m4hmay/CPix0WUj7O0rbN/argfOiBHbai+9/ruwKUImIQIHe3uGVdVciy
   bmlC7FT4Cxc4P5zDfL0EXh2PZP7yTxza96FTR98lGDgm31ukwNX9eIPhU
   NrEpFD2/HDjvMnk7NFnhGznfmY1Ou2Dloo1IkQFEO0UjyQZCeGljOggpk
   AJE7Jwwop3hpCeAn+kN3DYgCZVewoyVWVJU1yPMRf+xDRJvprTFMF5gKD
   DdEW34ajsKqQ3pH2Cn8CEBWWGuOkKvZ1qqltJExaj/cX611pu2VgYQAK5
   A==;
IronPort-SDR: 03XCtq6Nzugsi4RhOpDrgoqSGW08f/JllqGi1IMy7MJPFgZVEvO7eckRQjUx3NjGGh0AiLJe6Z
 ZIM5pO3+3fXzQOcJ/Pw2Zpnmx+f7Zdv3zZo0u7VXYCsxZIreOGifpw5HjSQM9ZDUxKz+D7l6Gn
 Bg/EWz8eHP4aCt8F8W/kxsq7bIVRLk1ovm8CW1mKs9WxiXc5ADC+dOfSpZPpktiXYK/+lClQAi
 424VITYHYltB25TWq6JTWwFe8w/6aiOhnZEeJqy6XbZWhROvuffN8RKvfk40r+T5tpiSl9eAr0
 yeg=
X-IronPort-AV: E=Sophos;i="5.79,400,1602518400"; 
   d="scan'208";a="269533232"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2021 17:35:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=decfmweYmadeikZRJONCAbJe/1nYuwyfkLGbikkr/yITlW5Lf1tPHj8wf44OyUlGIG5PsnRWFrDVlU8CKYXu6tkEKP02NKBgGbsqyhLn9NLK7HgBGwUSp8N/XI3IjBVAGDNgUzlvxg5M+acFy/LZoP5sC1rPCa2UiUi+0hVkPByTuL12fo/j4avQAp2tKKDq1PA/rDzf2WsrM/dI/5cW6L02lPH3/E98+zgZx4YuzUBnyGofBTM9lcOoj6gYaBFTb1ZHls+WAMhdmEMEYXUhHzk5ufwfI0uyeTknUoQnYHkSs0HKBSVHuEdQJ2nCFRLOZKntICt6WCXEkCufjdVuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Axh9kPoANs5SIkSefBj8yRPMcJphlxeAXu43DArp08=;
 b=X3PMNJFhblCKwvF79mZZZL/xoxZhBornUWcadzottqNA6vWCOfM8EACinAFE/yh4wHPFkRbg/g4bPFw9f5QWi/0sGC9i3NHQsZmGTrXAk0+qC4Qrr8NSvJ/R3Rx+uX3K7EqebeBEWigd461ijwtZqXODAiSW7w50NEUUYiOJ3WCT79G4c8vd7TbE6SItR0sX48oHcexzu8uy5su2wIu29WlHTyhevQ0P/1v6W/Sxh7KrMQE2MTxsyvYEyxVNoFOwQzOGFto2w6S1j7CjzO4yY6jSB0J71p2mD21GbynctgEqn+VKtMHQTx0EKDKGB3M3n6hnIaFlJO2cHYkiQA1/LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Axh9kPoANs5SIkSefBj8yRPMcJphlxeAXu43DArp08=;
 b=gy+gBzg2Klxykr1elmAFtjAbtOW+8meHPFPoMYoM/dQpQNiCqUfeJQAyKhRlD3+xmGG5jq/PDL7IxQxXKohZJO2wmd+l7cEqusOVFQGCfUaEmDCvHjEOuD8GULrLjnqekrI3qpa/y11Q5ObpdhNvLHgPfJ0IvzsBH4hHAI2RPAY=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN2PR04MB2141.namprd04.prod.outlook.com
 (2603:10b6:804:10::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 09:35:16 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 09:35:16 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Yang Li <yang.lee@linux.alibaba.com>,
        "njavali@marvell.com" <njavali@marvell.com>
CC:     "mrangankar@marvell.com" <mrangankar@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla4xxx: Remove unneeded return variable
Thread-Topic: [PATCH] scsi: qla4xxx: Remove unneeded return variable
Thread-Index: AQHW+sYuEnydvZTO4EK6h+U4cJLxOQ==
Date:   Thu, 4 Feb 2021 09:35:16 +0000
Message-ID: <SN4PR0401MB359888143238B80B16BFA67A9BB39@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <1612423057-72018-1-git-send-email-yang.lee@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:51f:6b4a:2171:57e6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7cd26223-d8a5-412d-38af-08d8c8f02e3a
x-ms-traffictypediagnostic: SN2PR04MB2141:
x-microsoft-antispam-prvs: <SN2PR04MB2141FC10C0A92026AAD868F09BB39@SN2PR04MB2141.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hy0Oj2wwWUyxZaA3y5OCcnqyYsCfSbJGr/miOGU0vJolL9RSZzjO/0sFd+YfYylErMf1wqfheqASM/qVfe7H2KZcZ8NpyMPP54EcXvJn0HShR1Rvjmr2PbYNzVS9wDuPPWY89Uu8JdkhYqIuFS9/l2vzOV6FIG17rQ8D/0YuoL/Hu3Vf0o2ADnPKKJ/CK4nbXTa+VHjdMSGPsfTPhCuZNHZ3cxRMRcj2gKZf4SYBEq5qJqcucUK83y0zxchnJmlliGcDfo9qXbamctEILswwtlGVtHUqt0yPLUxEL5sigRsHxzLxmNCR56qw0zB1xHkt5QbFq77YWQ2zLqECKGBX5DEJ80e8iDUU+NStBJopK6BaWHLt2wnFgmH8txhzHlAv7L2uoSMU/WG8+hzuu5z7p6CCrk/yi5pCPqojcvEM2sxpq4rSSHeMOcFpwKkkLy3gG58eNQT1n1neORuIYOAGMHDq/nIwWyP6H3glpGjeLjKsC7fP130+S3jRxa7EMEQvwudc5GdQQuLnS3Rxk4g5lGqqGkoJorxcV0k+mBOpy2EVg8xrdDkVDAK9BY8quAi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(86362001)(478600001)(33656002)(83380400001)(71200400001)(54906003)(5660300002)(186003)(8676002)(2906002)(76116006)(110136005)(4326008)(55016002)(66446008)(66476007)(7696005)(66946007)(64756008)(52536014)(91956017)(66556008)(316002)(53546011)(6506007)(9686003)(8936002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iqJYFa996UVyFXcB6PD9nnsU7sQXqS6s5gWQfRqX6rmU6J2hKHZn6konpwEa?=
 =?us-ascii?Q?QnyVbG+sxWvDJ3NQ2upma6hv8lRT/KWb46zouoYOX9k/5uAyIzl8ih9lpD1o?=
 =?us-ascii?Q?55xA/ewpj+upFKyEievISAOD4YZ2pU7T5h3ZawNBawLh7hbs0nV7ITCbxKPM?=
 =?us-ascii?Q?M2Q9ntqo/eJwYUnItXsSjhPcyW3WHi2j0kFcZNTylTRyYYdshdfYlODTrUk/?=
 =?us-ascii?Q?QixlKHiUV48XyZt+WnwH59QYs972PGLqfXpeH0wpCImif3zMZppaPtMSTJA5?=
 =?us-ascii?Q?TiOeVkJWKrUyyHWKql5OsogzeSXXf6EdNqQ/b0gMtApgQqDhKLQd336O/Pk7?=
 =?us-ascii?Q?UWeOna3xQs1nNt/Ibv7B97CwBfMhHF4m1IRNeQA3qhscY6rt7I2DElC4LSGu?=
 =?us-ascii?Q?lptvaBR/ZAvAguf1VCvFMNW5eQrBn0LgENC049KcmT6K9ve73p5rgq2lpYcX?=
 =?us-ascii?Q?PXM/f4FyyWvFj/zBWizEmiG++vPogj9hEkmmd3xIyN4DUnxuLD3VD6eKMjYO?=
 =?us-ascii?Q?bcwF7o7i+pRZ2agtrhS9iMvcl273HUfSYvPC9a7/sDuw+utrQ3/gMTRYvX0o?=
 =?us-ascii?Q?KgRFzIeh4SMAHzUetGPa32VTHRfNXJ3+6dacuNRU/3nwRoZsw6zkaf7bsae1?=
 =?us-ascii?Q?ZhhjVorhuV415/5MPSRE8N31DWMbsM0XtXAn5JtPv15nPNorVeDgCFde/F7d?=
 =?us-ascii?Q?Ic3+lucfMz+m5y6CWJZOpgLH5E7R3AGRGkGMvglvgf75LQkErcWAUD38RnDe?=
 =?us-ascii?Q?uKK1LpLL5HiVJPK47bw4g5XEx9tWA+MiH5MpcClzT3yscG6TKrnyE33dFobg?=
 =?us-ascii?Q?1oTOMy3wBKuC4BwAwzRqY8aU3bKAkBWSuQDeaiy7oeSoyUsdL7wNm5bkVlCT?=
 =?us-ascii?Q?M2XBqnE6QD9BL0gBWQof5Lh/EMYpCLA9DmqzDx8hvgoRD6C/UBuxeiHxouZ/?=
 =?us-ascii?Q?K7duSj+p0O5M2hmJAoKeVRD+49U+kmSadkl1FB3WMf9Id+vdorXENsdNsluL?=
 =?us-ascii?Q?sj2Hu5cLtqg2R97/GdTG7+ZrMlSmc8/cPrZJ5r6qWmQ2vOeK3WG4YcxvvCz+?=
 =?us-ascii?Q?r5Xt1+SCJKm0oJEp48muDYSMbbfjft+NCiEAMitWI7mQwYUNoGUPFOmaObmO?=
 =?us-ascii?Q?Xn9bJfGg/dA5wF+Sg6z9Fl5caY8dQ/gotQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd26223-d8a5-412d-38af-08d8c8f02e3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 09:35:16.5339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1OOd3xqakjHu/cXTTDxYGXvnWbvulbhU8vfr8s83IxmpM8d5drukE+ZbBs6QbcPyPlDkGA35/lxiLl29zA0uvLE1qCwkHEEljdJlsfgRVTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/02/2021 08:20, Yang Li wrote:=0A=
> This patch removes unneeded return variables, using only=0A=
> '0' instead.=0A=
> It fixes the following warning detected by coccinelle:=0A=
> ./drivers/scsi/qla4xxx/ql4_os.c:3642:5-7: Unneeded variable: "rc".=0A=
> Return "0" on line 3741=0A=
> =0A=
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>=0A=
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>=0A=
> ---=0A=
>  drivers/scsi/qla4xxx/ql4_os.c | 3 +--=0A=
>  1 file changed, 1 insertion(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c=0A=
> index a4b014e..ed92534 100644=0A=
> --- a/drivers/scsi/qla4xxx/ql4_os.c=0A=
> +++ b/drivers/scsi/qla4xxx/ql4_os.c=0A=
> @@ -3639,7 +3639,6 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi=
_bus_flash_session *sess,=0A=
>  				       struct dev_db_entry *fw_ddb_entry)=0A=
>  {=0A=
>  	uint16_t options;=0A=
> -	int rc =3D 0;=0A=
>  =0A=
>  	options =3D le16_to_cpu(fw_ddb_entry->options);=0A=
>  	SET_BITVAL(conn->is_fw_assigned_ipv6,  options, BIT_11);=0A=
> @@ -3738,7 +3737,7 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi=
_bus_flash_session *sess,=0A=
>  =0A=
>  	COPY_ISID(fw_ddb_entry->isid, sess->isid);=0A=
>  =0A=
> -	return rc;=0A=
> +	return 0;=0A=
>  }=0A=
>  =0A=
>  static void qla4xxx_copy_to_sess_conn_params(struct iscsi_conn *conn,=0A=
> =0A=
=0A=
None of the callers checks the return value anyways so you can do:=0A=
- static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *se=
ss,=0A=
+ static void qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *s=
ess,=0A=
