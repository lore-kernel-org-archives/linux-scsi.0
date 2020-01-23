Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F24C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 23:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6961920684
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 23:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="ERI4ttiZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgAWXLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 18:11:31 -0500
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:6122
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729856AbgAWXLa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 18:11:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCu0UJ0z3mmmXoAQcN6taGZIb+tGVcNbaPr6IsWgcBP5ZM7LZpYeUMPeFNPh93YM/uw9fkmZRGSSP5TM/x2m3CkATth9YVRfq/83Gb5CZKMBfGIGxT13vWGtI8SJKsdcAOCBJGK1NH4CyK4PeD2qnwr9Rqmo1VSmC3C84FWbR9qYLbXMqireWw1iiTxPpxEGMwl9XSQY+HzOmLKADqATqY+OBPjYImVdnMwdjuzuqWmj7WyEeFdjlag7cDOdoqIxM/dBiUFvy5O23SFib6IABEn7GBPWHncCxjD/COJU3Wp6V+5H5rhWBKkK5eygSBlDPc0Q41SMdpSfAnKdpzHKJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7kB4iEppudzQFEQ7mXbjjcX57yhENgppXLNQtCq7Xs=;
 b=La/YL5XNkxj5N9M8ZvDLX+QaCAUessSGnjB9/I2AuYezCWcGFQiFC5I/MuEAGK/3ixXO+PanYZ9TN4iML2I/caKcqenA7O5hpP1Vv31xAzaEQatICCMUhijNTN7wf8pSnbZDpB+3iYcvavnHL6lNkF1Npy8tGUjv+IYb83t2egFjnbFTmp+kzaM6eyIxvhlFqle06aQErQL88Oy5+Rqpylq/gvOYPsH8cECeq7Tz9q8Kbzk2yjHfl8ujPItQ0S+uz6xtRo6bjB/p78UN0ewiYjOtParKPWjgGOtLRBR+NMXyssTCNvl4qhIBq8I9zMDeChI5apEiwJHFeJvHRewmDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7kB4iEppudzQFEQ7mXbjjcX57yhENgppXLNQtCq7Xs=;
 b=ERI4ttiZtJZAGhw+kDV1w+9zT9rNUXACDaH9c1r7ZDMXRn57W+DXSgWMjzOIzU8TSDoKNLJ8QMvSL5irzZCLwQFE5iQr1KYIDIpWIbjFC9+5Pn5b4pg82nxIlrNhQSB+p6lqpGMfRnH9InHrSe/MFH6XF7pAc21CCHRcaAeDXrU=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5218.namprd08.prod.outlook.com (20.176.26.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 23 Jan 2020 23:11:26 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2665.017; Thu, 23 Jan 2020
 23:11:26 +0000
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
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v4 6/8] scsi: ufs: Add dev ref clock gating wait
 time support
Thread-Topic: [EXT] [PATCH v4 6/8] scsi: ufs: Add dev ref clock gating wait
 time support
Thread-Index: AQHV0b5x4/fsh3ghJ0K+tlX/zBIPzaf44R8g
Date:   Thu, 23 Jan 2020 23:11:26 +0000
Message-ID: <BN7PR08MB568451D6C66F4C6FB11E6EEBDB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-7-git-send-email-cang@codeaurora.org>
In-Reply-To: <1579764349-15578-7-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWFiZmI3YTdkLTNlMzUtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxhYmZiN2E3Zi0zZTM1LTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEzNTgiIHQ9IjEzMjI0Mjk0NjgzODE1MjczNCIgaD0iMzQwMEh5NEZ4bFBORUFLcDQwRGsxWW1zV0xZPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFBZXhsWnVRdExWQVdqcDhsR3o2bnc2YU9ueVViUHFmRG9BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUEvaFRDdndBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7490bbb8-96cd-4b72-12b5-08d7a0599244
x-ms-traffictypediagnostic: BN7PR08MB5218:|BN7PR08MB5218:|BN7PR08MB5218:
x-microsoft-antispam-prvs: <BN7PR08MB5218FB29581E54D3581F110CDB0F0@BN7PR08MB5218.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(189003)(199004)(8936002)(81166006)(81156014)(8676002)(66946007)(5660300002)(55236004)(478600001)(66556008)(2906002)(33656002)(7696005)(6506007)(71200400001)(52536014)(66476007)(7416002)(54906003)(110136005)(186003)(64756008)(66446008)(9686003)(55016002)(4326008)(76116006)(26005)(86362001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5218;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rqzFSOkp6Gt2Qpe/2bXChqrC/G+G0+GL5dd9zsvpGinhQlACbM5Pnf1Rq3sB18FtMqHjUGT3x1cH3ZU3cVjcapIWSbbA6cQ02RZnABnxMAmyeP8EcWT26IlzTOIN8Dg5ZN/YJ7bcWd9VNfM3f+LtOloq79PIG3gFiuZF072ZKn3aYtMdlGGnSqoDaaDesEwEu9KVFB0mFTEij0u2cXRXMFLCtHehBq6Y3W20nIZ6UXqlFy6Ao2zb9OsGxztEPrJVV6JeuXIyEwboKmbts1RoYlGnToE2OIbtvZc/AM4OiNfG1p6Qk+gFFp3CpJQWhud1QMyTdC1RmDc1MVaASp4mcmIt+BNxoJJ79ZEjK48v2CWh2KQu6qz+EoA3QX2VKN58Dz5oBtG6Sa3qXQCvoxdxA52qixUF4y2UrYh2/jJZHcm7o3Z6cpc1hN3888N7yEnT
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7490bbb8-96cd-4b72-12b5-08d7a0599244
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 23:11:26.0314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QXUw3PrOvffGJtoUD6MWfX1U5bVJfQU+pH2WJYsFt2w2ReHaE6Jxian1zdtZXFezrjuaItiqgTFrVppDc2fVEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5218
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,  Can

>=20
> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime defines=
 the
> minimum time for which the reference clock is required by device during
> transition to LS-MODE or HIBERN8 state. Make this change to reflect the n=
ew
> requirement by adding delays before turning off the clock.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h    |  3 +++
>  drivers/scsi/ufs/ufshcd.c | 41
> +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> 3327981..385bac8 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -168,6 +168,7 @@ enum attr_idn {
>  	QUERY_ATTR_IDN_FFU_STATUS		=3D 0x14,
>  	QUERY_ATTR_IDN_PSA_STATE		=3D 0x15,
>  	QUERY_ATTR_IDN_PSA_DATA_SIZE		=3D 0x16,
> +	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	=3D 0x17,
>  };
>=20
>  /* Descriptor idn for Query requests */ @@ -530,6 +531,8 @@ struct
> ufs_dev_info {
>  	bool f_power_on_wp_en;
>  	/* Keeps information if any of the LU is power on write protected */
>  	bool is_lu_power_on_wp;
> +	u16 spec_version;
> +	u32 clk_gating_wait_us;
>  };
>=20
This one also need rebase

Thanks,

//Bean
