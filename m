Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB803C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CC320724
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Y39AvfWa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HzerIGff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgGFJYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 05:24:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:17437 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgGFJYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 05:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594027493; x=1625563493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wOzUwfkHn1N/0SggVMfVTEWSFTR2cnnfDob6MzAvXdE=;
  b=Y39AvfWa0da5HOykSwviPlCuJEAt9AVWJHDdG+bbRwiPpKDFC7S0XPDd
   4h4e5jrhucMpI4352l56M32+k/vmlzlg2vDmuTyi5GGkOU9sFzxY+6Mnj
   tMzhyKsh0fJGdxz6oWvlB4Hi5KL91C9+c+3zg/0+u2ee+PAl6W1DA0CS+
   fCOssqZttp+5ns2JYZl3CH8nOY64mTCMslQiWUvuhOtDUDY1ZJ6rMcoOV
   uCbLNkBZmmQIwW2K+P4tN812yNGJcDAy+NMbE0E8fI2u85nngKcMC81+K
   XhuRzCqvXaol0R6frvfat4Le4oUAKlIV/SHHjiMx5oNBIz67J2vEDYhSR
   g==;
IronPort-SDR: 5fIPGTuNoMlgLhmj2gy+iLR4+kFqZXfdzLV0+qPfwp4ic3QTv2P5bnph/qnBnA4RORNn+OfNq4
 gXm4p4SVaR9lJMLMXwtHzT1ssWQy9HdFYaPaKmapMBLSiZU+wZytxf7Z+fVlAxzL8xdp0gNSo4
 wweDeS0U/97kjCRKun+bkwilFNNbwXkX+UcA1b4/J7F051jJ0xRckbriOuILGgogzRyFkU6suw
 TWWEmbRItjDbeXYBZkOcxSXOR6ITjYoWr32qspdqz6g1hDCBztfApY3Vp3U14tIdXslVxdm2W5
 HjA=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="141901912"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 17:24:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXshTSu9qWOrioyLATQXEcbq2uqUfRVxg/7svbfgsnSijdmv2J1Z/1NVgVlYrIhVXaZcb5yd0k8RSNi/KTikODUR7L7ful0zvFyoSoulVczwWXtxQELgmtPd90aj9/cOxAGuEFkSBydfPbfyKZwnVdcvz/G0KE2QZRz33RPZeLWPw/79u+aHUFHwMKMbWyrJj6fIhhhiPoB0iDkcfHEBAAikfWjh+9j3L8qOSzeB7Qir+FUlh88NIGrC4rJf4EW2kow3EBOzH7aIrR9nHhLWHs4jLFu9jaitvCTu+blVOp3GU5x5H/teeyfpKVlE3yT6ZcocikOuoZktdrwQw8rWKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dv5ZiIB5II1S5Og9VbQMO5yjkTa3g84z9VodtVS5hAA=;
 b=Ajy24TMAsXejjNKXfmQx/ktvR6LqumofEzZ7ZKzcTSGK28fS9SWqpiROnoNc8vie8uF6tWAekCXzwwfZdlZ7AyE5u0fcFFo0OmVBXVT4yetZ0rT0i/kZ28oJagTaDeYrW/79AOKMcXFK78mp2kGfbi6PqygdXymxfMPFFI9pPAO3prXKbJrCNOIeV4zJS3HnFMlW+/PqNoXpK1AMJOFykogpoHULA4tiNl+S8wrMbaMnH1cLarbonMLxRiyNi4CS/fOuvGAUc/EPDzfJNg4wMcvOE+a16AExgJKjX3bXalNlVkgZ1tZMoPK7eqxx28aE5xVDFFoZFRBYITGwMuZmfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dv5ZiIB5II1S5Og9VbQMO5yjkTa3g84z9VodtVS5hAA=;
 b=HzerIGffoVYVDXy8LjvT7JjjGbTSV0lG5+chNhXYktJjEJ2Igzp9S70ppJyEJqjICBOT4SlZL/QwLEaU8qT/NlxyOXKd5awcksoerl8zhPhOjq5XVnkMAJtFSRWDbW3lwzPFYbyhrulNVPnh05F8zRBme2JonDEVqx/KSTERooU=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4350.namprd04.prod.outlook.com (2603:10b6:805:3b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Mon, 6 Jul
 2020 09:24:50 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 09:24:49 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/2] scsi: ufs: differentiate dev_cmd trace message
Thread-Topic: [PATCH v1 1/2] scsi: ufs: differentiate dev_cmd trace message
Thread-Index: AQHWU3aK/GC0GWUMjkikzdUPEKmA9aj6RxFQ
Date:   Mon, 6 Jul 2020 09:24:49 +0000
Message-ID: <SN6PR04MB46404BDEAA0C802DB2592C34FC690@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706091905.12885-1-huobean@gmail.com>
 <20200706091905.12885-2-huobean@gmail.com>
In-Reply-To: <20200706091905.12885-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6396c5c0-7a4f-4206-799f-08d8218e6eb7
x-ms-traffictypediagnostic: SN6PR04MB4350:
x-microsoft-antispam-prvs: <SN6PR04MB435011BE3DEA41918D8E615FFC690@SN6PR04MB4350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gC9gHVHPUKIt6chPkOf9Ip/Gd5uTFsAo2AQrHE6vub1FyYys7d5ls2jVUvXbfop/ZP4T4DsgE+FX6TEjBz0ROn4g8TE4MUfFEFynPyNmlOhYtOp44JR/gd5V3G2kDj8/eELzn0Gt43/9iRTIAn1NBnC78xjXbERqHjYlLrZ2orZf78BpMkivPpr10SgdoYTPFouBpe/+4PUTMcjmweTh1p1xc8RoXJqSp2vntHwn7LtmLP8J8ZcV+XWTqgk8prpbwAFiapwell+/kqXvBZGKiA/g8m0c6iEHbBUUKal0iP7aIRcn9jGBmuc+yWhm+Qvv7kF5lfLR99rDLVeC6ta+H2nUNDItQb+S9hLhXGP1mEHgWskjfM8pYDFtYfpwZfva
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(55016002)(2906002)(83380400001)(33656002)(76116006)(8936002)(9686003)(478600001)(7416002)(15650500001)(186003)(7696005)(5660300002)(66946007)(8676002)(71200400001)(86362001)(110136005)(66476007)(66556008)(64756008)(66446008)(316002)(54906003)(6506007)(52536014)(26005)(4326008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Kuqx7RzIjSTTOHu+sZzvCYGF6Un9SYWLG0ISYhqHVl8jbFW2uiiKECjCzrCLcnLCR6IzxLy2mF43pD4xBSngVhHkFLh58eijNiWsqzua5ae3sSvWedINaqCa6mC17jwaw7To0/n8rKs8R+XOOMIGCzFo9hqW2Ln6cLHmKeIHsGLHq/RSXtzthjhiIXNJcg6mZj9LDhWWnse5TFWUJ2IR+p0JnMjW3XIAfHm/k31baj2wjtcc0GJGplOYXYEwSGT67zjCL0UU//ZReIlYksElJml2EhY6i1IyMFLxRkfLWLql588lJ81b6aqxwdOKxLgUvgR6KsTudmAXrVra0ImfLZ6FVYPdl+LTEJjvBE+8dFqLGowYKCoBe5DxAzGwSuGZOHZN1R0QnY14J3uX+juGzBGWQEWGhyA555zsrAmMilVQiEBHlfR2IqdZEhVaLdx+oMVU4jtjvcgs1hEm7pNID6xfDNwIPUmEG8LJPyX2ZTQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6396c5c0-7a4f-4206-799f-08d8218e6eb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 09:24:49.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kuBJzKfyuTObgdj8lBwWDuDkg4eCoOqRAvZn9OqX7zLlIRSQiEm5LDh6EAVB5QsWrRq+ckFJLckIwyqGEVfccA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4350
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> fshcd_exec_dev_cmd() can send query request and NOP request, and it is
Typo ?

> confusing that ufshcd_add_query_upiu_trace() prints us the "query_send"
> string in the trace log. Change it and add NOP key message in the trace
> print according to the dev_cmd type.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Our parsers already looking for those strings.
You can add stuff, but do not change anything that user-space already expec=
ts.

Thanks,
Avri


> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 59358bb75014..173deee37e26 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2727,7 +2727,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>=20
>         hba->dev_cmd.complete =3D &wait;
>=20
> -       ufshcd_add_query_upiu_trace(hba, tag, "query_send");
> +       ufshcd_add_query_upiu_trace(hba, tag,
> +                                   cmd_type =3D=3D DEV_CMD_TYPE_QUERY ?
> +                                   "send QUERY" : "send NOP");
>         /* Make sure descriptors are ready before ringing the doorbell */
>         wmb();
>         spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -2738,7 +2740,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>         err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>=20
>         ufshcd_add_query_upiu_trace(hba, tag,
> -                       err ? "query_complete_err" : "query_complete");
> +                       err ? "dev_cmd err" : "dev_cmd complete");
>=20
>  out_put_tag:
>         blk_put_request(req);
> --
> 2.17.1

