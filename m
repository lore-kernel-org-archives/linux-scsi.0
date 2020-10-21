Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2401AC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 10:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37C722251
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 10:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Q8JmHRLe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441714AbgJUK2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 06:28:08 -0400
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:15488
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2441712AbgJUK2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 06:28:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4LYhZW+DTWsNRV4D+Epj7gQpUzlQSVpj4UGITwqEjjnYLF2i8t3VsDCF1d+/NXfwO/PIz6mVA7+r6V4B0F/w26t7kiiXFnG7elflV8xE1Vh8hF5YdywED8rRiJvuhzha3fLaEPnGI1P4eTCwMSTtXXBsIfg1+g07vtt/fQ81rTutD8WhhA8mMFyzLL6Fz39EMpuHsfmKnGWunCJ1h1ngnS47m8UL19BEZqyQ7AdFmvsz5BGeSdc1nYUVrm2JagxcViK873xmlzzuAe6o7FPNlCTtRiW1F/R7QjEyQWqsYuASxCjaNuYGQP+0pzosd8xqCF7Eks/HJ9ML5bV2V2Zmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VD4biw1mzcrTfjStRPbAFKZFxIgCdKgrByE2PrQwT80=;
 b=Mm1HUBTc/q5eA4CvkkYbR2axVdDzGGCxG1ZLQ5u7U4JRP8ruDhZPMc7p9seGXFunQF35Vr5eEUavIT6+zO3icADGnlSk+PhU8ZsL3C/cVlntxpNgAC4i02Fztko25oQc6yeoKBIqrfLIq5d+dZiHIfU8MwjCMkwtPQs6sZdV4TuZiCKkgEIRallHzDeFvjaxloDsl0IUupL6goibYgfoSEMDr4sMgCO+itbYE+psIrQbrZIky5i3AG3CLCyT31p+GW/ghUbfAGJ0d2vL0/bjQK7vfGQgCMiibOA8eS8s+wVZj3o4B65K6UUUlR73u6RzieTp9wEidAbOZn7+OgmIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VD4biw1mzcrTfjStRPbAFKZFxIgCdKgrByE2PrQwT80=;
 b=Q8JmHRLeo/gK/GUbjIb0ns2AXT/RnfPTKz1AqxTsYymqyAJCvzBKS8Jwbg7+AxP1QX46OLH6tpm4KpkNLv3fCC+kMZc0X7FCfiZj7SKSJJGVIJXngRCs7qXueF/Vl06ngK3OcN05Dgh5jgExW9TkK313M/pAWGQb/Pe8EXuuVc4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB3987.namprd08.prod.outlook.com (2603:10b6:406:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 21 Oct
 2020 10:28:05 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::75eb:84c6:b0b8:b321]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::75eb:84c6:b0b8:b321%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 10:28:05 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE:  [PATCH] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Thread-Topic: [PATCH] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Thread-Index: AdanlNtcqX/aNNyRQWauBNFSsLSOoQ==
Date:   Wed, 21 Oct 2020 10:28:05 +0000
Message-ID: <BN7PR08MB5684527CDF23C3A49B7827C7DB1C0@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.203.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfab0a4a-8ca4-4a65-e6d6-08d875abff2e
x-ms-traffictypediagnostic: BN7PR08MB3987:
x-microsoft-antispam-prvs: <BN7PR08MB3987B5942A904318C2B0D4FEDB1C0@BN7PR08MB3987.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UxMFaiZyBNMh3+glNArXyY9CHYTQPlzfg2YYBdhvoD+5c8N9uu+XXR4EKFWr1vkHZzLOA+5v098KIp+QNRIW/op+ArQsAIWXXLiwRjCmg/zbt6wwNfHESoaADviD0/6+4Ys+gv4MGHzUGlGvA+5Qc7CzYR1JlLceoYi9awSIYo8zmjCqq3EmzVA73MjUAhiCjWXuFvtQXxVEQdIqrytxtnFzoLB+X81/BJWZIKUP4H5G+K/v/E60y3kilhtBIRkdtbml1MB8d1mZDtjn2envt7zJgqXWCh0gblKIOl5orUFUSqqYIVN256ZzkUD3EH5kRs1Af7pRvcykRC0d0gYY2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(5660300002)(9686003)(83380400001)(71200400001)(52536014)(4326008)(66476007)(76116006)(66556008)(66446008)(66946007)(64756008)(110136005)(478600001)(7696005)(54906003)(316002)(7416002)(8936002)(33656002)(186003)(2906002)(86362001)(26005)(55016002)(6506007)(55236004)(83730400002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vpbF8J2FvIYY8qa2jemmstrf/aoB5nBIdoD7y0HpgrDb0NuEglmxbTInHBet82CGkOgHr3s446wf1Z4USJfC9OMLlmWKMKKdaIrf42kRzN7eRCkfnF6vGWlKfOMPr7kwJZBwshBB/4k0jrhXGixN3QPeNatNsRDKxqxbRR16z9MoA9yaCCLXNzX0+suQPD8gme7eNayelHPIBG1yAFZR+ItBigU9C3GP+dZbBQXDNMXATuO4xT3SB8RzFPEajEgx6vYUSIiyD6aMw2zbSCf68Kwauncz5q5U3rCoB9wKTFyLMS7dtVX80WmMdhcRRVde52Y4bV8CTDOXq7QaGRhQgeyc8oonQI6XVuNPig5JXcjoGkSO5HYXveFUOVXGBGA+UgNmcNriyEDLNw0ijPaTVyZ8TnNMOeJlhf5h7xPo8Uj3yUYx9kQMnNVwLAhq1XV4Du39nDAt3LKdTaEpRXHAa/Y2k9nAl+fumfkyfbYrxyn2DFuRk1uMTo1EHh5KMSyQNGwu7Ie13mtw+eqvZOYuBPlLC9++8Ba3WtQgzQQSha49c7FPMNZaZOO4clw0ISs5AMBdzchAriRnMJvym10rWJ8Wxxd8/IJEU/Rt38B/0ZibRhOCM0m3H2lT7R8UIuLD+haXccH71yvAxpLAmdniqw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR08MB5684.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfab0a4a-8ca4-4a65-e6d6-08d875abff2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 10:28:05.3007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gTLqBg5E4hqAzVrwhr6fAP+9dD2v24hnlCYAB9vSxDFHKhwO0HlZXAOaGE/OoL7ob2rHT+QMgDSTULmjGrc+QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3987
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Can,

> Since WB feature has been added, WB related sysfs entries can be accessed
> even when an UFS device does not support WB feature. In that case, the
> descriptors which are not supported by the UFS device may be wrongly repo=
rted
> when they are accessed from their corrsponding sysfs entries.
> Fix it by adding a sanity check of parameter offset against the actual de=
criptor
> length.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> a2ebcc8..8861ad6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3184,13 +3184,19 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>  	/* Get the length of descriptor */
>  	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
>  	if (!buff_len) {
> -		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
> +		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (param_offset >=3D buff_len)
> +		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN
> 0x%x, length 0x%x\n",
> +			__func__, param_offset, desc_id, buff_len);
>  		return -EINVAL;
>  	}

A brace missed!  This right brace misses a left brace.

Bean


