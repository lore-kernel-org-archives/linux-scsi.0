Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AC0C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 17:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B7AB2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 17:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="yEdfkLM8";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="KOGlldrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390098AbgF3ROf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:14:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59468 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729337AbgF3ROe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 13:14:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UHE9tO022572;
        Tue, 30 Jun 2020 10:14:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=v4LlXs5VW1TkWWYG0PD8ApgT80S6rxQT+JYv9jmQ6PQ=;
 b=yEdfkLM8FDLSSbbWJjWb6SJe9kf3wnR79WfyaVRT1q9GriQIHD1ulxXttMHNyMfeEpBB
 tygnZFXYmy6Ybeoo7UzFqS3Rbi1R6t791y644Gq8d1bB80aVNJnVGnibQg6qC4jqyPlk
 zpkUzdJWXrGsSOCWt/xKbGncNSmWs2ZcJVl5Tf94kseZydmejOqPkcd9sS4/pNRRtYmM
 E7vqCFc+LYm1Vhui5eOyPlJD+DqzJIeh8ZDI6SplIAcGByifCj30DVa1ncewGlu1rniX
 WEBtXMmbu/Z1+LBz5yLN0g2N/xtpoXVwy5AYrEF3PfBafM9VXxjmqJ/ZrjGNxPrPsFEV bQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31y0ws0qgu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 10:14:14 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 10:13:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 30 Jun 2020 10:13:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLEcK9dhFQYmbk6yzjOFZ0+Ywc6bzCfRZyrWrCQyBeRXhytfuOLtZHqUrSPWlMcOukmQJVRVod+QaL8xq0/uS1WzW09sMzGImstC5pMcmCNyL52sp0HKVI5f3P1CDjbl4BFjppUhp/7pXJz5BfT38gVqOozJXTNlRdjKTDixfikk18gNX6TM9CsDJp6xdt6gJ+y5SHB3kC4BL3vKI1aj2dnH4rRF3D/A2PNWDoFpEeRI4O2wxPcW4caJwLodqdvBFzpQg2nrfUEP6o/K/NU+0yhm866RmlxKJr9K20gKEU/AxFAva3u180MAYZ+I0o5G5/sFO2R+y+4lpXEbCDEWgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4LlXs5VW1TkWWYG0PD8ApgT80S6rxQT+JYv9jmQ6PQ=;
 b=TKnYsJIio+UhODxDCQnsJC28s9+O3QoC7N0Cj27PrkMDIPQq2Ui13KDMudRM0w7ZhAtQ4fHeIakw+Eau/I0MNjLeE9WpRcgYT0zkC4fFdcJTVbR11OVAMP4wRynA4KABJzbeCMJZHhLxFqKUPj/g27DRbw6U+quvBJpcdgc2P2bMZojoPcLcLTLRLglB7ztM0sva29h5bgDPgWagHZjHiGgwUzkhGn1lXU6z+uDYHTWVwint7M8eq50Jw3apRpraG3Rl7QnEmR7ZwVTeV3x1kPWIyRCAG66uhnxz1xHY79GuTi46xkgNxJGgad6RiBlVR1vkRptTmJDY0Wd6X0QBgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4LlXs5VW1TkWWYG0PD8ApgT80S6rxQT+JYv9jmQ6PQ=;
 b=KOGlldrtgeybB1pT7zdAcqXZR7HgFvWexVc6kJMh8wzdSzTWt49rrze9wrYwotGACE6Cm2wvjLPFrW8OptOynByCjxBh7HQJkEyE2+5oFXy80ZrFIOCLgs0wbuSKdA0GG4d0SHjy+2sWrwRfiTgWJ/VxYeZOGNAL2Ce2Z0/GIo8=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2550.namprd18.prod.outlook.com (2603:10b6:a03:138::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 17:13:09 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3153.020; Tue, 30 Jun 2020
 17:13:09 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        "Roman Bolshakov" <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 5/9] qla2xxx: Remove a superfluous cast
Thread-Topic: [PATCH v2 5/9] qla2xxx: Remove a superfluous cast
Thread-Index: AQHWTmhc53wOSPk9PUaLAQBFlqvhD6jxZqIA
Date:   Tue, 30 Jun 2020 17:13:09 +0000
Message-ID: <C4D658CD-28DD-4E51-84A3-8DB67A67B1FB@marvell.com>
References: <20200629225454.22863-1-bvanassche@acm.org>
 <20200629225454.22863-6-bvanassche@acm.org>
In-Reply-To: <20200629225454.22863-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:c5ed:f3c:3605:6488]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abd9eada-789e-4976-bcad-08d81d18dcc6
x-ms-traffictypediagnostic: BYAPR18MB2550:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2550C4BB38C61FB88D88DFFEB46F0@BYAPR18MB2550.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dvCrRRYe6rp/8Bf5IuVXMQdFgKcNykr6Y0s7BcVJ05wBbqMikB/ktISRQSN8Jrz7LSd5opVWdQe4p+hoSs7tdqy0xXbvoBxuTEv2BH4MJFr/4EQfJtfp6ucyKkX2ElnAHwtgr8P4fTPIDtbTMHC5xVk2rfH4zydPlZpMqmSSsZSTYmf0LniCHKiFwyHiwkqedbBboX2G4HtRB2uucXO8L4bv7WjuiR53uOJA2XUiKhu5vUcExCh1Yi1lp1FRHlnnR2iVzGPOBEKoKb44FgUa6iDTrHET938a3U/gkmPiOzvaHl8870pqGn68AmQ+IZqifVblTd4EdjRt0Xs7PVeKKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(2616005)(5660300002)(53546011)(478600001)(83380400001)(36756003)(6486002)(66446008)(66556008)(316002)(64756008)(2906002)(8676002)(66476007)(6512007)(4326008)(6506007)(8936002)(76116006)(66946007)(71200400001)(186003)(54906003)(86362001)(6916009)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ApfThEF/nFzfShbg5wjZgUaZj4j20oG1r/xFN7FMZcLfjhrgZpnLB7P3axBwAdGjOiRfrc4YUHxtNyOe/Umq3oZ5Z1sWCLsncIp3SadX4SE7wd/iVmv+hcNvJAhf7Wd1eE2+QO05qgM349oAtQLKyPvuESb7CSo4IhFfNIp2i9AcV+L53IQJ5J5coELDTvucadMMBhxDYiBXb0JgIT8ZyFaiKTpO/pdEpyUw2OWIX9WtW/aqVCwbVZBfmbRmOc1rrgsXAw6yG2DrI1Iyu2td/+u+UNTjwhVDGeS6xLmklXIBWv43YIB4CcZ+xF1vFTngrkzQ7eAPPSl864tKwHFooaL4B7pXXqADyOVCmHCkEXr0LIyFeeDpc3DA5t23Gv3/paTmVv/9RFdkasG8d1dGGqwMWb+kxYxg3o3c9yAJYNggoCFe4gtRTiGchjFHbY/sRymWzYQ7czlHfVNgnA2sXRxpJIWDplp7ykISiQuXBpmE1iub6pSVeWlY9/Frih7tzftPtGOjwYkqQwMsINYahuPqvegc01YF7yp5zTL33hfkLi17IizCxFROl+/eI4JF
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D0CF4E7825B5C4690358017C434B43C@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd9eada-789e-4976-bcad-08d81d18dcc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 17:13:09.2398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C8HeGOgPeLJYyFTRAalLzvJSD3hdPB7N4Mh+4OYZxD0OtznUns2kDpQusQU+XaghghKPqVQA+IiSyoxzIq5a8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2550
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Shyam Sundar <ssundar@marvell.com>

> On Jun 29, 2020, at 3:54 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Remove an unnecessary cast because it prevents the compiler to perform
> type checking.
>=20
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 88c0338a2ec7..67efde1d4b8e 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -223,8 +223,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job=
)
>=20
> 		/* validate fcp priority data */
>=20
> -		if (!qla24xx_fcp_prio_cfg_valid(vha,
> -		    (struct qla_fcp_prio_cfg *) ha->fcp_prio_cfg, 1)) {
> +		if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 1)) {
> 			bsg_reply->result =3D (DID_ERROR << 16);
> 			ret =3D -EINVAL;
> 			/* If buffer was invalidatic int

