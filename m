Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A027C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DD8206A5
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FicYWswZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mv3W28r3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbfLKLWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 06:22:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58109 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfLKLWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 06:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576063341; x=1607599341;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jU8Be9VJO8Fp/ByQ2bZpPUodRLDXeSLp9sW+OcUN4oQ=;
  b=FicYWswZ9ocdwTMKFgHGRAiScRGorlAVV21J2YnGBUXpzCuxK8WmoeXL
   hPxZfFIKrpNRAmmoA0BNrtRMvn2wvVtRnyG/U7HrJaw2ESNYPIuKZAoC0
   +Ra5huknDEL0Kv/14XZ5cDIHEOqSoaeuNwM+tWu0WQPW+AAuPDa632FzT
   fnkCVKKPz90x5w8vk9nEPQUMY+bLu0MKAt7niVfJwzY0gzqKuMZ9mlk5K
   swct2UToNqNBSFBUdvaCbMcYxQDTJbCVsRpzn8xGOp2ryZZqwi91TOQJe
   iL5hm47xMsdFvsWdCaLOdOkNNdP1eClUzDdqq2d8uDC38kBhmzoAP/ll1
   w==;
IronPort-SDR: t/iIAM6Qzo7vnC9O8+ocUC8ANH2R1Bnf6fRSATBqdmvmrEkDa57bHJn9fOCzMFChItvqOJWFgP
 XmzpGHpCS3kHBwtNTDiGxHgzqnd/RpD0hlaSqIJaGnTWaL+dU9WHAb4UsQf/ubwLfzoss1ijaR
 8IHf5WY2OZLIzJyVEYaJqgHDezbyzv8Wc5kOARBL2FQXk7rf6Dlgv+6JmU3p+1zunmbrSB2XdO
 UDuG2TDbkpsoiseLgvBZlvhwgJLD5pQFp74M+U8JhOWDvqhZOYpp4mmCYGvqc5GLVvYhQdGgjP
 jK8=
X-IronPort-AV: E=Sophos;i="5.69,301,1571673600"; 
   d="scan'208";a="125869692"
Received: from mail-co1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.52])
  by ob1.hgst.iphmx.com with ESMTP; 11 Dec 2019 19:22:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkb2C99Ven5Ogo/vBTptBhnw2S0veMrPUo/8amgQyr5qEMqyjk45XPIT74/zUz2MS+xVuFL7jQI8k+rrrojdYqxiGFfz+q9QoDyno5hc0vre59p0On0RLqSooIaW3Fjl3ciKCh6c/YzdIEa6lm35q0gA99qEj0pg3qzfaHxMCALp7pfr+tejyNZexC/ri6BNHZQFMT9xlTVUFfRu6mg1itL4ziFLuBW7J4q7YoZ0+acyfy2fnzmSK6/6rQxnTcVOcB9HuSbQbWRAxTS/THriNJYZHCk+hnZb5RJ9Tsr0Lqj4WuqZftkXN4YjlfEyPemKL2/HPibPJHrXcOcWhgZoSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQrQyCKzV7HHqilCCgUZcBBB67DR6dw3/wBXdQ6iNjk=;
 b=bYe1P49H26dDhvPTPldBV90azi7zb8h6BgKElE1W2OFpHoxu3zesQQx8WzEaDKC0Z+YPtsZDswUHfa1ftRu2cgA4NU7OHuu99c+tlxxDwiJHBwY2Qk6zLVFpN1blnN4BSShm3wYQK43N1j3OAS1V+ki85ovXLJ9FKH7ttE5mc1xAf7hEdSBSBelkYg5Vk8CRebeOskxQPfi+6ekVDh2qdvHu0rXaIhmkpy+SXngVp5RIz7ikIbuI+Weaog2KW6+Dobq6QePD/QDtPHMX9YR6b0KoplPnFuSLr+woe4VtBq1RZrW3FklguyvsgtfsGchWo2UeU+OAy7A9Eq0R4RDOXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQrQyCKzV7HHqilCCgUZcBBB67DR6dw3/wBXdQ6iNjk=;
 b=mv3W28r3SK/bxvYqNqMPq5JOx5K85UF5YBE05GPdxkCeNw/AjlE8NWIbPD2qNQGjo4zDmuLpSXKCbiiIlH4vWLCWWnVmvazhGbQrVShZv4PjiJWPIxFsfXCDHo8WnslaB4dYEp6cTkfOyUnLqWCGyNaKbw4Jmg8+vQolMm0eWk0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6671.namprd04.prod.outlook.com (10.141.117.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 11 Dec 2019 11:22:17 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.012; Wed, 11 Dec 2019
 11:22:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
Thread-Topic: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
Thread-Index: AQHVr//RJYxYdS3dXUmhxTnGX2MLCqe0vdGQgAAIXgCAAANkQA==
Date:   Wed, 11 Dec 2019 11:22:16 +0000
Message-ID: <MN2PR04MB6991754758E2840B6D529112FC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef4259a7c-76bdf010-88b1-4309-ba24-8c874734184e-000000@us-west-2.amazonses.com>
 <MN2PR04MB699184D76E7F9BABA923043AFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016ef4a3e5f5-915372c8-5e1e-4db5-b3da-f97f7ca963e4-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ef4a3e5f5-915372c8-5e1e-4db5-b3da-f97f7ca963e4-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ecfac847-ff81-4d64-1555-08d77e2c614a
x-ms-traffictypediagnostic: MN2PR04MB6671:
x-microsoft-antispam-prvs: <MN2PR04MB667182757A68243C01938FC9FC5A0@MN2PR04MB6671.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(189003)(199004)(53546011)(6506007)(478600001)(316002)(6916009)(86362001)(9686003)(7696005)(76116006)(52536014)(7416002)(5660300002)(81156014)(8936002)(81166006)(4001150100001)(4326008)(66946007)(8676002)(186003)(66446008)(2906002)(71200400001)(55016002)(54906003)(66556008)(26005)(64756008)(66476007)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6671;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 441leW1Zk8LlmI2ykq5pJAqcvFJQwZNgZNwB98y9AhfuxUJ5gXna3n0QukjC1G6EinLSN535ryTFgKvRoFW40hWXnBBztzvuMMpcDKzQ9XksNA+Ul/hGE/bCJUQ5T155r0b2moxC2xIaFmk9Q5NVG+3f5rEV4i5HFIQBDceLbQvArmCZeAKLWzR8xqYMM0G9ZAGfJTzxD6nu6VkGVLbGYga4Z3UqPDcJtvo+PPMjWG4O/zFtxbAb0myA5WLyXytvbnk0p6racOtjy2XzmfO29C0VQUFuB9IP/nk4LsX0Ec+yNUq6cOBZtkmy5G6788ixTnC9QvdygadLkAeK4KTWmNxUN/e7YtbQflC9toGkODbCmYjWkyNjqlu6KoIFRpfnYcqvqRqWgXPrHhL8TZjPwIe7hKlJSAidPTV4UzdqyVCu9ge7c1ucAiumbckiTFTM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfac847-ff81-4d64-1555-08d77e2c614a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 11:22:17.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t0/0ARc51fzEMlq8EU+srEq/oljAxtR8vnuz8gIiqq6rJhRXMCHLNf/RZmjawmjZIfNOHFObmioDqZomufiErA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6671
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> On 2019-12-11 18:37, Avri Altman wrote:
> >>
> >> In ufshcd_remove(), after SCSI host is removed, put it once so that
> >> its resources can be released.
> >>
> >> Signed-off-by: Can Guo <cang@codeaurora.org>
> >
> > This is not really part of this patchset, is it?
> >
>=20
> Hi Avri,
>=20
> I put this change in the same patchset due to #1. The main patch has
> dependency on it #2. Consider a scenario where platform driver is also co=
mpiled
> as a module, say ufs_qcom.ko.
>      In this case, we have two modules, ufs-qcom.ko and ufs-bsg.ko. If do=
 insmod
> ufs-qcom.ko
>      then rmmod ufs-qcom.ko and do insmod ufs-qcom.ko again, without this
> change, because scsi
>      host was not release, the new scsi host will have a different host n=
umber,
> meaning
>      hba->host->host_no will be 1, but not 0. Now if do insmod ufs-bsg.ko=
 now,
> the ufs-bsg dev
>      created in /dev/bsg/ will be ufs-bsg1, but not ufs-bsg0. If keep try=
ing these
> operations,
>      the ufs-bsg device's name will be messed up. This change make sure a=
fter ufs-
> qcom.ko is removed
>      and installed back, its hba->host->host_no stays 0, so that ufs-bsg =
device
> name stays same.
Looks like we needed to manage the ufs-bsg nodes using an IDA, instead of h=
ost_no?


>=20
> Thanks,
>=20
> Can Guo.
>=20
> >> ---
> >>  drivers/scsi/ufs/ufshcd.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >> index b5966fa..a86b0fd 100644
> >> --- a/drivers/scsi/ufs/ufshcd.c
> >> +++ b/drivers/scsi/ufs/ufshcd.c
> >> @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
> >>         ufs_bsg_remove(hba);
> >>         ufs_sysfs_remove_nodes(hba->dev);
> >>         scsi_remove_host(hba->host);
> >> +       scsi_host_put(hba->host);
> >>         /* disable interrupts */
> >>         ufshcd_disable_intr(hba, hba->intr_mask);
> >>         ufshcd_hba_stop(hba, true);
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> >> Forum, a Linux Foundation Collaborative Project
