Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2801FC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 22:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF2722076C
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 22:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="X7xJmXGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCRWmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:42:10 -0400
Received: from mail-eopbgr680074.outbound.protection.outlook.com ([40.107.68.74]:54340
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbgCRWmJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Mar 2020 18:42:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oF3Tt2nlpsL3N8hv/bBrX9Oe1fq3AZs4r4ruGeJSuK7LU/UG2gUB+5y5ULwzsgp+ZbD84lJPr1FYqEUXooEoX1/tUJYqY1LjTb2OyP5s8E4BvKx70ubc1Y0YXKRJGnY/NnenNyfXQOwmnS55FWJTUBznUz2c29MVdV5Hy5JfxQq1/evkfN1EOZz46PJ5XTLX337bFRUOXfT7umIyv0OsZ8ojV+aEvt/eEBE6V/K7XGnCza3PbBj3jwKkYXeK2hVOTCyOrbAa8zsnSWJMAfPLW8NJFfpW9Fs6006hqJ0H4RyMgyDZjxZRh9T93rbCzmKisysQla2D8SNjJTSKeEgAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utB0GjzHmDgaVrKb+YqsjUQmVxd47V/C1anvWpZ1RVw=;
 b=dluwwNMRpCzbTXNo1ph5GMIka+ihlqQN/cmIiRjOxpZo2K2+nZN/Xn8nRkgT2/fjYw7J8+O+yRcwVsdI2Dm8gSWnLsuR3lHjSMKeU3CO/KjGqVCtmcbg9jwxzJTj8/l4H71YHjIJGMQfC2Uxj27GnMDtS8z/S/czyta+uyqPUvanb/EGmvlqMPYc47nXdEmr3E1GeaMvQGb2yp+D7kO5cszjWmxlhYTeA2QipW19aUuv0aXp1FVaFPa20CBBLCqIBkekOCVMDGGuYlbVgpKOEkJGT627/AugxTi05J8ivt8UZxZxwmtXd+GckVXqPBpc49fm0oFvdqhGasBqPbLeNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utB0GjzHmDgaVrKb+YqsjUQmVxd47V/C1anvWpZ1RVw=;
 b=X7xJmXGVt/1z/BJRoH0f+23LvAhuVOK7ZjObgTaabWkjIsz+znvxHob6KjHeRvfNxV9cztUiJaoEGier7fQFOV4xNtaRM6x1J1v0MdWAGM9A2u/KQWsgssBmmB1/en3DDB4mpI+f1zUzEldAtBGapcTMHUQUBCMU6DoZuThr6tk=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5524.namprd08.prod.outlook.com (2603:10b6:408:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Wed, 18 Mar
 2020 22:42:02 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 22:42:02 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.peter~sen@oracle.com" <martin.peter~sen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v7 2/7] scsi: ufs: use an enum for host capabilities
Thread-Topic: [EXT] [PATCH v7 2/7] scsi: ufs: use an enum for host
 capabilities
Thread-Index: AQHV/RGm5n2oCL7iW0eIfX+5z/Ar2KhO8i2A
Date:   Wed, 18 Mar 2020 22:42:01 +0000
Message-ID: <BN7PR08MB5684E1FE840F0BB1170D7196DBF70@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
 <20200318104016.28049-3-stanley.chu@mediatek.com>
In-Reply-To: <20200318104016.28049-3-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWFjYjJhOWUxLTY5NjktMTFlYS04YjhkLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxhY2IyYTllMy02OTY5LTExZWEtOGI4ZC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM1NCIgdD0iMTMyMjkwNDQ5MTg4NTM0OTA2IiBoPSJtVmFaVitxWnVLNXZ5QnFON08wTlNROHZPY3c9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUI2T2c5dmR2M1ZBY1RqSncyUXpwK254T01uRFpET242Y0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTlybW53UUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.143]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d7f66a-6a0b-4744-bb6c-08d7cb8d9384
x-ms-traffictypediagnostic: BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:
x-microsoft-antispam-prvs: <BN7PR08MB552482268B56AC4653244924DBF70@BN7PR08MB5524.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(26005)(186003)(71200400001)(9686003)(66476007)(66556008)(66446008)(66946007)(7416002)(52536014)(478600001)(5660300002)(64756008)(33656002)(7696005)(76116006)(558084003)(4326008)(316002)(81166006)(6506007)(54906003)(81156014)(55016002)(8936002)(8676002)(55236004)(110136005)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5524;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: guiT8fKOWQs9WE3rKXdabEVnbNUIfjduYX+nE3/Oiphe7zoIpoQeaAsTR7Xz8beaiXnQ+Tkl1WZ8UKJpkWDbewtrduaEd1Qf7T1sKPV6X3r5TrmriAs8M2i70ijy1sbzoILbCwezhSupUSZ4QKCdYtF6zeZ/hk//PiLfgjJGTHHk/xUjLAUgXHSrO58uDtzgaz55AdQMK993GbsuUmP9+xIWON4IlmKPV9/cXUkXK1MN3a2DVsxzNGfb11jkE6BsTBvP4zUcK1kF7Faj90q2OSN6u+luPyck5fiXmOsuLpZRStg3F4Mb0J7DVjjT/vIYeu9TLRSvyCKYH9ru0XqP+0QrRUnh/bLDYYIEyt5CvEPtakcKqYoXcg5za3VDA6Ce3ySQN/Pj6/Uu6I6UQNlu36eDE5od8Kf+MT1MTan6bhk+A0rzxRJf6REQLLr2tmKr
x-ms-exchange-antispam-messagedata: A/3xcVKDy024qnL+vmV3jj/TzaxfNnKnX4JBiKDvo/EmhT5hAwyL2PmRayi87+JJATge6tkLpp9MmJ50zK7/MsQ3Smxw4hYn8SEu1YP5z/V6RvJUPFW58hUwKw4GUyrpSNkqv96kcmhYOsJxDh9JMg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d7f66a-6a0b-4744-bb6c-08d7cb8d9384
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 22:42:01.9532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4p9+Z2zZ/+hjA39d8Rw10cDRut1WduQqgEClI1B03EuvdHZXqs6pW2QJGpeahmNoB2juJeuhlFDvEbzyg8ZRZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5524
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
