Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDFFCA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 10:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DF2720663
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 10:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="1+RCAfId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404555AbfJWKji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 06:39:38 -0400
Received: from mail-eopbgr800080.outbound.protection.outlook.com ([40.107.80.80]:51280
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404434AbfJWKji (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 06:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0QMwfPDf9q7ZEFlt202lHWY6T3Q0IXEBUHIun+h2vf/vUmlJkPUD17xyne8mdS6bKbD8VZwXRQ9R7HpFppgeMj7OSXhqi9CwD74MXhTq/maOd8xSfBrtsg4BvS3QJ1sR0FlX/jRgr/TOvJrdNgdD5gjGeaHcXHlfIH1uI0f7P3bvuNegLpArqe6W5qTCw+IBUAdbOsBEKgav0SsWqn9BPguNBWh8fw/GU70vsOcQJE4HQWgDenc11FafJDGwH9GfNy5O18JchwmxajX7HnP2Kyxetjb8BPivccQjvv2Kk187J0GZqm6bKO4Qc3YSf9EDYZBurwJJCKSUI1+mLFuEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xfev3vorbttKfuFA3t3CKZOF5qQq2SCeugCSPFJ1dE=;
 b=TyZPhzIPqwJcMzGABaL5SZPdNIX1aB3tSd5/+nxJI/nf/4nY/Vs1q6I/ByVlPiTJZk0DRQxYiY5gCyd08x2v6N5fhwTMbf6lbAhNHKxb9+Q0s8lWyds2o97Q+cYcc/Hhmn5YdmjuRg8L5PriCysP5OuipPfc6Ym/AvU3Qgbf9pUXUySCL/N5E/wrihTufq7kQF2vropciSUkoK+xJ3EsC98ciJa6tbRe5fEIiP6jMKC4C7GVfeLd4wPX4ZMyMQpwtpIND5xHL3g8gvV+gVNSCjk6XCH9NFqLZR4Wa/xWw8sqr/K2Ouxc5Gbw+tP+sudtpyupdKtrpkmhnHI0oqKUMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xfev3vorbttKfuFA3t3CKZOF5qQq2SCeugCSPFJ1dE=;
 b=1+RCAfIdtBwVnrdw48Dfu3SlV6LSm5ajtH1TM9B7WAKVLaHaUHACX44H3ZwVGgtaIp/bFKA28XiE/8269tXeJfAtbr9QmB3iVjVCSe1YcuKutSQb9mhc0kVF8hh6scWlZBaYYyO1kgMD5WZDdf9IdbY9lGH31Ls8/NCDIxsCGNA=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5682.namprd08.prod.outlook.com (20.176.31.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 10:39:33 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::8c6f:d978:fcc6:ecad]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::8c6f:d978:fcc6:ecad%4]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 10:39:33 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting
 host controller
Thread-Topic: [EXT] [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting
 host controller
Thread-Index: AQHViVhK6TPPhq95pk22+LkWdo6BK6doBo2Q
Date:   Wed, 23 Oct 2019 10:39:33 +0000
Message-ID: <BN7PR08MB568444BD52F49775D7EEB363DB6B0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1571804009-29787-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTY0ZTIxYTBkLWY1ODEtMTFlOS04YjgzLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2NGUyMWEwZS1mNTgxLTExZTktOGI4My1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM2NzciIHQ9IjEzMjE2MzAwNzcxNDEwNTA3NSIgaD0iU1diemI5Mmduc3lzWjEwNHNkWnM4QWV5R1NZPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 846a21c6-c8e2-42b5-3606-08d757a54ad7
x-ms-traffictypediagnostic: BN7PR08MB5682:|BN7PR08MB5682:|BN7PR08MB5682:
x-microsoft-antispam-prvs: <BN7PR08MB568258B5FAB2D3E55E8528DDDB6B0@BN7PR08MB5682.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(305945005)(478600001)(7736002)(6436002)(316002)(4326008)(229853002)(2501003)(110136005)(54906003)(6246003)(7696005)(76176011)(102836004)(55236004)(26005)(74316002)(66066001)(7416002)(6506007)(14454004)(86362001)(8676002)(186003)(71200400001)(11346002)(81166006)(52536014)(3846002)(76116006)(256004)(71190400001)(14444005)(5024004)(446003)(81156014)(2201001)(66446008)(486006)(476003)(8936002)(25786009)(5660300002)(99286004)(55016002)(9686003)(64756008)(2906002)(33656002)(6116002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5682;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HPL3d3WdKmiLLMhXUMCFvOhDKPghnZUf2rH1O3IYkK7iaVVCdOx7FnjL7cQT0pD7j5xepB/lIMmUj1NDkRDsLUC/aWXPvsjvKc8T0dFO5zLzWA+zivYv93PCqyyXeGFFG8YcNycKiA/wO24pE/MiFj8DzZKF1am68bq+KB9PknJw20ds++ypwRD8jwCXQNlAgGU73Cp/dFTHIXDpiwsD361a3cef3fRNrOJiwmpKJVc0UL04MFGMLiGz1MjrsB8dUslhhGo8Qm8nCDSEC0kEMWP8x19ITPHwF23UCRK/i9JliX6q8VZ4G6lZCipIKJogTxijafzSd8nU+jClk5RPKYufdZFeiPECu6hpoOQ7hXCDOC9HgXEkR/jddNkupgibomNPbjrKWB7as4WyUR0yph88hyjZ4Q26J5Sodh3J1DQvDw/Vsi0ZZbI/NXe1WkPq
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 846a21c6-c8e2-42b5-3606-08d757a54ad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 10:39:33.1683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9WHRffOvlsbfvVCYLxI8VTil4OEjme7DKbU+8KxHHnF0pDTWFJneN73LvK7aSvksmXOezVAQ1Bq+5NR56l6AAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5682
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can Guo
Actually, we already have DME_RESET,  this is not enough for Qualcomm host?=
=20
Thanks,

//Bean

>=20
> Some UFS host controllers need their specific implementations of resettin=
g to
> get them into a good state. Provide a new vops to allow the platform driv=
er to
> implement this own reset operation.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++  drivers/scsi/ufs/ufshcd=
.h | 10
> ++++++++++
>  2 files changed, 26 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> c28c144..161e3c4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3859,6 +3859,14 @@ static int ufshcd_link_recovery(struct ufs_hba *hb=
a)
>  	ufshcd_set_eh_in_progress(hba);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> +	ret =3D ufshcd_vops_full_reset(hba);
> +	if (ret)
> +		dev_warn(hba->dev, "%s: full reset returned %d\n",
> +				  __func__, ret);
> +
> +	/* Reset the attached device */
> +	ufshcd_vops_device_reset(hba);
> +
>  	ret =3D ufshcd_host_reset_and_restore(hba);
>=20
>  	spin_lock_irqsave(hba->host->host_lock, flags); @@ -6241,6 +6249,11
> @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>  	int retries =3D MAX_HOST_RESET_RETRIES;
>=20
>  	do {
> +		err =3D ufshcd_vops_full_reset(hba);
> +		if (err)
> +			dev_warn(hba->dev, "%s: full reset returned %d\n",
> +					__func__, err);
> +
>  		/* Reset the attached device */
>  		ufshcd_vops_device_reset(hba);
>=20
> @@ -8384,6 +8397,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  		goto exit_gating;
>  	}
>=20
> +	/* Reset controller to power on reset (POR) state */
> +	ufshcd_vops_full_reset(hba);
> +
>  	/* Reset the attached device */
>  	ufshcd_vops_device_reset(hba);
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> e0fe247..253b9ea 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -296,6 +296,8 @@ struct ufs_pwr_mode_info {
>   * @apply_dev_quirks: called to apply device specific quirks
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
> + * @full_reset: called for handling variant specific implementations of
> + *              resetting the hci
>   * @dbg_register_dump: used to dump controller debug information
>   * @phy_initialization: used to initialize phys
>   * @device_reset: called to issue a reset pulse on the UFS device @@ -32=
5,6
> +327,7 @@ struct ufs_hba_variant_ops {
>  	int	(*apply_dev_quirks)(struct ufs_hba *);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
> +	int	(*full_reset)(struct ufs_hba *hba);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
>  	int	(*phy_initialization)(struct ufs_hba *);
>  	void	(*device_reset)(struct ufs_hba *hba);
> @@ -1076,6 +1079,13 @@ static inline int ufshcd_vops_resume(struct ufs_hb=
a
> *hba, enum ufs_pm_op op)
>  	return 0;
>  }
>=20
> +static inline int ufshcd_vops_full_reset(struct ufs_hba *hba) {
> +	if (hba->vops && hba->vops->full_reset)
> +		return hba->vops->full_reset(hba);
> +	return 0;
> +}
> +
>  static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)  {
>  	if (hba->vops && hba->vops->dbg_register_dump)
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

