Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F55C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09FAA611AE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhENCDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 22:03:17 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30850 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhENCDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 22:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957725; x=1652493725;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=YkVx5lzPcaIIDwOtHYWU2XtcSiJFfWdfkaQxmSBEbNg=;
  b=atkbmoCIVrInnGwQQclm6poX+YaI0P68gpHwG7qQQRl1k9MMt87QUjHz
   Yx/SJI8lzsecbCTp6rjH4UYA20Ip9tGSgtVA3TmFuLhz4weHEGv3/vzAu
   spVv/WWwNY6V8oW36iUiOywKuslCNSFumWQztt77SmVgQzSJ33wv0/rt+
   g3sy//nDPQK4BQLiEPNQAa/yd7XepEpS8uKikz/a5ukff/Ikda9ubdwG7
   Ypf2T9kXBv78izcFcqK0v4/oJOgaBct9FWO5ne8BHrLwTeWF0cQuDNdrU
   73XCfKZdKUGrnJdxq0MAF0dCkt+nF5gCiuUSZ9BX7espC/JfChIM+kYqS
   Q==;
IronPort-SDR: BVEAzgF/shIEX6MKqP57KRK0KcfmP/SCaTbzeGst9BWOkyuqBgE1/UXRu/WrqXLtnUyZTab0Wd
 zaK7R8XryEjqyfz5gt8NK+O+PpgMKdLAzae11BawCBBuwfsjzTBPp7KIDUbZOdam3kvfHIAMDI
 bsYnHRZdRgIEScQV0vZa2X7aHx8Z/UQw7McMDlLnVR6Dmj8hIXlID+VYRtYrKaemJYEpYqIpyy
 S7DvQ+EBP0XzbUm69zsDNsZHDA32cX74LywyFWnmncOQ9LLYYaDOW0ci1bNyOkkwyEeOedpp/U
 viA=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="168138423"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 10:02:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXoTH+HP4pJzU8XzKlrYVb9zDgwFoN0BJ/KDBZ72U+6rnJ51pKWYeyeJNOrM1i+HIVBAGOEVVLwV1RXZlMc5Au8luc4jnvAIHK5iu0hpWuCfJ/CrwOVaHTk26CgFN83yR2Dj+fxLx7lNhUWnZLqljChPjqQi0L+mwsaPRsbpH+SDbGzyQO1kKPNlp+3w5Mm2GUkfIYYD4l3VmBUoj4zc0XYs7si4oRSNHusYjFNIQ5adke3Wl4rCrZB/svW4ks/LN28PtW1DdhgRJKOfbHZAIOZWHmJsCQNkl76RkWSegpOC7w8xeVQtp4G4gwAidRtGlQaNFdSwikSbXNBFilogWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM73k7NaqzmHTQZHUKaXW/wqQ+7+FNTQzhvzU7do8aA=;
 b=QW7jMFhL7s4giO41fEC927eZLKh/TPESAgZKWKZ7iCyar4INTx/iyUM9I2+pnxTEl3DvHMVVpOe4YWduuh0lWlXPBoa+N/tt2GklJbDcJLh6rN8k3pkxQH+gZhA/GFilT9nfZhuccQfn2PmgOng9Q1V5zrYIITh7FGY87m5FL4SEeCqVGuIZ3qKH8HQcYxVLp6qrIMtUJUqkCgpNe+gL1fQ2tqK/iHD3u1NR4tmq40VmCQZubz1Z14sqFt8Z0HoysfzYmt+wTO99romjROJIgv54nIUuZ9ieqLnA02e2Ho43HR8GAC3aTGwAWJ0MqtEBYLmR1sY0UOkvpAWNsPDQiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM73k7NaqzmHTQZHUKaXW/wqQ+7+FNTQzhvzU7do8aA=;
 b=FtNTzhgA/chE+PF+9x4PofL4WyM2MuMRnrPQkd90JUmXlMnrzolUYIwuqFoX2TzT7HsJpa+47MN2AX4NPvUjARJ9IdXE2NtM7jwblCj6ooW1jcsYTN5QRsLSp0XFTWx2tAAOsnnXLuFTxHycSxDlX5vvTJPrR9XCax3e0yFdz0g=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4827.namprd04.prod.outlook.com (2603:10b6:5:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 02:02:05 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 02:02:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH v3 6/8] qla2xxx: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Topic: [PATCH v3 6/8] qla2xxx: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Index: AQHXSEit8fv+ynU7kU6+u1vnpUGVNQ==
Date:   Fri, 14 May 2021 02:02:04 +0000
Message-ID: <DM6PR04MB70817364801262A63932A55EE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c68833f-3cc0-4107-5021-08d9167c45b5
x-ms-traffictypediagnostic: DM6PR04MB4827:
x-microsoft-antispam-prvs: <DM6PR04MB4827198F19E96F435A19C296E7509@DM6PR04MB4827.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWBbBlC47GUp3YsjBfOY5dQclBKycdvW53BsjlSiO6r0ZcEH3FDcQZd0fprUn2CyJVZWvD1BAfY9SzxjrM4/SyqH2tTUC8IShh6ZD6zlPG07tZPpSdIDAuTRT2nPIqmaXLNigLrwtrbEuXhKh7VzNkM5R5LbpXMYCV3asm7yASRugfEHUB9hRRBTLs3HXgebCt2k5N2DwL7wm8XMlvruYw0CMWY8vXzTc+whrcySHZe+EvxCMyhQOYA+qDCLqqcQUpmOCchK/UvNrHFVv/pwKMBZJtH4TW0fQCsTOORJvmDE3HO0ptMJK1diBCB3NPE7y12oT2Vom7qA0HK2R+57rC8gCGl2TptpP+K7RSP8TFqjwXqD+RszGbN5yyZ04JhHPgGh9y6Rdh0/8w97ToylBcAtUa0cCu6O4wfSibcEicnxnYR90h2XKZ00qDsHBMV94+Q3ZaNer1sRevokexMm/0B2Mf1V60EKgicqI+PiPqk2VENm1wTMnNxotCZ3wRmvqvWUePUeXuwTTvYMfNmhgi3m2/X4A0sQnOUdWC2LVc2QsEX1myyzrboZJZKqGfIHEUd1kqE89EdHXwLsFE+cJbmE5muDdeQJTQYTfN6u1BU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(52536014)(76116006)(2906002)(91956017)(53546011)(110136005)(71200400001)(83380400001)(54906003)(5660300002)(4326008)(66946007)(64756008)(66446008)(33656002)(7696005)(66476007)(86362001)(9686003)(8676002)(66556008)(478600001)(8936002)(316002)(55016002)(38100700002)(122000001)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?z5spUYI9xg/t6mAAGbrZKSMGs4wVBwTbfBsStOHPrusYRyM0I/TB4+FHJmA1?=
 =?us-ascii?Q?d7NNm4epsMRDeH1Zvh2zrWmr6bFCPsOpHXP0thSFDaQfo3Uqz8AVW/t5cPs+?=
 =?us-ascii?Q?kY6Iq3IKkI5GJdrylnOcU/81GlgIElmcflfS/9qifaoJxHFjKmzyzyUt3oV/?=
 =?us-ascii?Q?EIWGsVF0zPwEXikUw09KLIoQlPPqG4iSIEvKML9TN8TUY09B91m5uq2Dl05H?=
 =?us-ascii?Q?frkjjb87tTrVqeGDMAdkDZTlDiTBP/cr6IUIAVijxw7KMINzyo0cpAAf6fCE?=
 =?us-ascii?Q?kxdVdDhXLsJn0XTEJYSfm8n01bSPZ1IIE7wCrVokIh5wtTws1Ca31iPGQTbf?=
 =?us-ascii?Q?4ex+Cnr7qc+r8dN2kw3WK3elRwGFgZ84kPeqe4SdSjVtVGVFs4agaLUo4PNO?=
 =?us-ascii?Q?JNJFEjW9QdG/iiWlpRck1BtNtraLQ8xQfZSwLUklrOOLGDVnKc9MvzXqOGRz?=
 =?us-ascii?Q?n/Tl2HA6vCFBvMcqhKAp+Jw5ud2fxBbYgqp83yhtMCMGZFm8/TQMMMtra2cq?=
 =?us-ascii?Q?KZnd3ebPWRo3PFVy4eXSsdw4zRxMXm5r/tPlkjAJDriNCh/o2C3Gic5YreeI?=
 =?us-ascii?Q?KFKYGt3tXVUOB7H0TahRGdGpu91wsesE4bi0wa4dKHKMOKa3u+yGMBUMmZUH?=
 =?us-ascii?Q?HZMDMufTA3G2/BUkHdDS8Pb/obz6POj6/c+hR/XAb072COG7oD2PSTfFtnq4?=
 =?us-ascii?Q?Ua02MXHj4pNQ5sc4T7shPwkrRfzXMP1Ty2NqUyxW8QmG5fGtFX0ZJFjPMJuQ?=
 =?us-ascii?Q?OXHoliEbzIoYORZfCbAYKjBsMk13HjYJoa0IiUFWn4KSA7IJ2Gj3ADnbHaQT?=
 =?us-ascii?Q?LU7Y+DYlAF/GDUrJj8e7eGft75x3J6YXW8kQwZlDT02RAU8K+x0HDuatvEQS?=
 =?us-ascii?Q?FecEnG0gRBRjUOS+AfHYbvaPeSsL5M+qnpkLXInfETVeHNfJJXKKzHVinLgb?=
 =?us-ascii?Q?SPoqsNGWlxSKw5MWJb/0cIdoWTTu4S2Txu3zF/D3R2CMMYYOebnjiE1oQSz5?=
 =?us-ascii?Q?WseC3CoxCGXVg64rEbyOo7eqjJBpqkTz9xCEk4xYPUFSNMtUu5rSDKn3lo/q?=
 =?us-ascii?Q?vJnsRYjF3QlZaPPYwUTbPdf03kFR4wLMK+eOsU+VKm5CG+uFipe6erCM5vic?=
 =?us-ascii?Q?Ijz1siSw78jnQI30TtiIoXKzdQAqZOsBivKiiAZWe+/FihhA+NhdUpW7tpSh?=
 =?us-ascii?Q?QeMkem3e2N2gC/g3Wby+kb0rDtpZht93DgxceJVcsIYccIvH/WcXOLQy2Gab?=
 =?us-ascii?Q?LuN140FyYSC3eL3iDWHiBGwgSsX7+o2xIrFpcAxF6bM/hQwBCnoP97NEkDZ4?=
 =?us-ascii?Q?Q7t30DM5tMGy7jP65W4pE9B14Bnwf9i6KamKv2z20whAt1xQcl+Eui3CdDB0?=
 =?us-ascii?Q?39u0WVJZknsGXVKAXCjBtgL/+buvfxsVhSn55kfmGacLF3xA1w=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c68833f-3cc0-4107-5021-08d9167c45b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 02:02:04.9234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uiEcaiVbEmuKXUC2cHQTgIlyyFVLmUA641RanhJjHrHHp08q7oC1nHnRBgcbGpw+3xTEIL6olaGiCcB+kxJruQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4827
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the=0A=
> latter is confusing. Additionally, use lower_32_bits() instead of=0A=
> open-coding it. This patch does not change any functionality.=0A=
> =0A=
> Cc: Nilesh Javali <njavali@marvell.com>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  drivers/scsi/qla2xxx/qla_iocb.c | 9 +++------=0A=
>  drivers/scsi/qla2xxx/qla_isr.c  | 8 ++++----=0A=
>  2 files changed, 7 insertions(+), 10 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c=0A=
> index 38b5bdde2405..28e30a7e8883 100644=0A=
> --- a/drivers/scsi/qla2xxx/qla_iocb.c=0A=
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c=0A=
> @@ -778,8 +778,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_cont=
ext *pkt,=0A=
>  		 * No check for ql2xenablehba_err_chk, as it would be an=0A=
>  		 * I/O error if hba tag generation is not done.=0A=
>  		 */=0A=
> -		pkt->ref_tag =3D cpu_to_le32((uint32_t)=0A=
> -		    (0xffffffff & scsi_get_lba(cmd)));=0A=
> +		pkt->ref_tag =3D cpu_to_le32(lower_32_bits(scsi_get_sector(cmd)));=0A=
>  =0A=
>  		if (!qla2x00_hba_err_chk_enabled(sp))=0A=
>  			break;=0A=
> @@ -799,8 +798,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_cont=
ext *pkt,=0A=
>  		pkt->app_tag_mask[0] =3D 0x0;=0A=
>  		pkt->app_tag_mask[1] =3D 0x0;=0A=
>  =0A=
> -		pkt->ref_tag =3D cpu_to_le32((uint32_t)=0A=
> -		    (0xffffffff & scsi_get_lba(cmd)));=0A=
> +		pkt->ref_tag =3D cpu_to_le32(lower_32_bits(scsi_get_sector(cmd)));=0A=
>  =0A=
>  		if (!qla2x00_hba_err_chk_enabled(sp))=0A=
>  			break;=0A=
> @@ -824,8 +822,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_cont=
ext *pkt,=0A=
>  	 * 16 bit app tag.=0A=
>  	 */=0A=
>  	case SCSI_PROT_DIF_TYPE1:=0A=
> -		pkt->ref_tag =3D cpu_to_le32((uint32_t)=0A=
> -		    (0xffffffff & scsi_get_lba(cmd)));=0A=
> +		pkt->ref_tag =3D cpu_to_le32(lower_32_bits(scsi_get_sector(cmd)));=0A=
>  		pkt->app_tag =3D cpu_to_le16(0);=0A=
>  		pkt->app_tag_mask[0] =3D 0x0;=0A=
>  		pkt->app_tag_mask[1] =3D 0x0;=0A=
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c=0A=
> index 67229af4c142..24d406411f81 100644=0A=
> --- a/drivers/scsi/qla2xxx/qla_isr.c=0A=
> +++ b/drivers/scsi/qla2xxx/qla_isr.c=0A=
> @@ -2632,7 +2632,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entr=
y_24xx *sts24)=0A=
>  	    "DIF ERROR in cmd 0x%x lba 0x%llx act ref"=0A=
>  	    " tag=3D0x%x, exp ref_tag=3D0x%x, act app tag=3D0x%x, exp app"=0A=
>  	    " tag=3D0x%x, act guard=3D0x%x, exp guard=3D0x%x.\n",=0A=
> -	    cmd->cmnd[0], (u64)scsi_get_lba(cmd), a_ref_tag, e_ref_tag,=0A=
> +	    cmd->cmnd[0], (u64)scsi_get_sector(cmd), a_ref_tag, e_ref_tag,=0A=
>  	    a_app_tag, e_app_tag, a_guard, e_guard);=0A=
>  =0A=
>  	/*=0A=
> @@ -2644,10 +2644,10 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_en=
try_24xx *sts24)=0A=
>  	    (scsi_get_prot_type(cmd) !=3D SCSI_PROT_DIF_TYPE3 ||=0A=
>  	     a_ref_tag =3D=3D be32_to_cpu(T10_PI_REF_ESCAPE))) {=0A=
>  		uint32_t blocks_done, resid;=0A=
> -		sector_t lba_s =3D scsi_get_lba(cmd);=0A=
> +		sector_t sector =3D scsi_get_sector(cmd);=0A=
>  =0A=
>  		/* 2TB boundary case covered automatically with this */=0A=
> -		blocks_done =3D e_ref_tag - (uint32_t)lba_s + 1;=0A=
> +		blocks_done =3D e_ref_tag - (uint32_t)sector + 1;=0A=
>  =0A=
>  		resid =3D scsi_bufflen(cmd) - (blocks_done *=0A=
>  		    cmd->device->sector_size);=0A=
> @@ -2677,7 +2677,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entr=
y_24xx *sts24)=0A=
>  			if (k !=3D blocks_done) {=0A=
>  				ql_log(ql_log_warn, vha, 0x302f,=0A=
>  				    "unexpected tag values tag:lba=3D%x:%llx)\n",=0A=
> -				    e_ref_tag, (unsigned long long)lba_s);=0A=
> +				    e_ref_tag, (u64)sector);=0A=
>  				return 1;=0A=
>  			}=0A=
>  =0A=
> =0A=
=0A=
Not entirely convinced the casts are needed for the log calls...=0A=
Apart from that, looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
