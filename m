Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E7DCA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 16:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B092054F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 16:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Dr3Z5HZT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cNSfJOFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfJ3QVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 12:21:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22071 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3QVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 12:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572452542; x=1603988542;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WuazeujtUXsW9cq5X3RIZ9Lbqsv57jUbpE3cgQZqc5M=;
  b=Dr3Z5HZTlwMCtqXif6QcFsVTKCJHrGSyULsBNdy0X1dwlpBXqLxBpyF6
   5vMkhMQt6XhOswyq8U64VkWUF+oiiN5X4uWGzeT49QVqLzpRBCZkuOWZM
   PFskUAAvumfGDeuFZTbSFqxco5FV4eEvS3RHPVFWIO44nRonfOd7+Tw0l
   RC6gfE581KTm9XrHyFaf99aq6C0/T0a0UOFI3HHY87EOa8R3xNHHBBMZY
   Vx3l/++6aeV6lKw32ROnIp3HFO+CjcRVWHgnt4WGFYg8+rfrMBlfcXVEz
   uSnDlVZRKDSKvbinPrMCXlotYCbrVrnrd40ilNKI8/olisf8LdOt8TDoV
   w==;
IronPort-SDR: jXwPatazL3qc/a6RMDqfnBaef8Y2DDleBuvBveKOQHPYXBgjTJfM8fn1HGjhzxK//nFqoCCux/
 LKdI8aUOxGvxW2UVYxgwjzKg49EEBebE1dUeVny41MzJka6NHMdPpGwwmNqwDA8gENyk+Gacqk
 Q6XyOfXlb5q7WhOkC2cdmtnI90H6gWPa+7Eh+3+EssHqx2+Men79gKfVEvKmOxvPA+VCVBalHM
 TDVjA3lUY3xyic+oH+bAUTfkIca7cIdkeBJqHChfTtqxqwkHQdFozS0go9WajLKkqSEfcdgWB3
 f6Q=
X-IronPort-AV: E=Sophos;i="5.68,247,1569254400"; 
   d="scan'208";a="222845401"
Received: from mail-sn1nam01lp2057.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.57])
  by ob1.hgst.iphmx.com with ESMTP; 31 Oct 2019 00:22:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2vgYkyWgyTB6fLeFxV5vzOHp8s0z8NqOVnFCR5uYrLNtahn0Or3FbWCV9JO58VUYXBcReAv0fXqqo9+xiVLIK0v8OzxiRaP+jd+33Di7EAsz9STHdTBw7bK36x1iwMFDSF8nP1rSC90VLye4jiq5k4vjytkX1+nIf6IRVQmOQQiyMx6o0cN/DEsWJYB1f7SVNBIygMeNssXCjdEhWJ2Tu6sDXEhCAvzbW8wLjlk4ZiqZWug9sePVug30Tyrz6l9t+WtWsJfDen2N/NS/8hRVPKd/5eUh45L3Lrco7vwIEOxfZ+tQeJ4w/Ao7wm05LfTW/iYET4BwEswupPfWu1oNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9onWDjDeru5/Ig5S0u1pswF7GT7sYNeYWoXvXJm2bw=;
 b=QwBM5pMEbbwu0wglmI+25LiUeVV8oTK3gv/nl+TsdBZIA/ai53jhSxsw+4AgO4bUFSep+oDOba5XBfQoOsUDo68Kzv2tZCA5+AuvJHACta1ek52WIuunyq39kCWZxMf47KJnJxcxMiNTGTV36ZCESC1rMYZSvB28jZhsBGd20+jz2SbXzlDGcA0Mcatv6xL2Q0OnMvbkL8nvtUyIH3OVIa8dI44V5wQ4J+570AyH8PbPgwSrzcyNII1ddwmL+qtGaBAmnSvuuAmB1YeF55GxfFwQGST9WxeHffS3QyG/irhy5LQEM6XCCb0eE/e3ppAUrU8ckaTz4P8/NKpMNqBrwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9onWDjDeru5/Ig5S0u1pswF7GT7sYNeYWoXvXJm2bw=;
 b=cNSfJOFoGjT1LKrfpEB1ML6MJvmADCq/zBAzCCjNK+xuUfy2d1YAx7yiVZKh5VWlDrP37Cf1KGNBhGGC+uqfL3qTAipYtWWSma2vBNV5XK+KkDE/p0tggBUfCUC85ehsjmeO1UKAzMyNgKhf0ved8N99pJibNwlq59uuVR5NYcY=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4101.namprd04.prod.outlook.com (52.135.215.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Wed, 30 Oct 2019 16:21:31 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2387.028; Wed, 30 Oct 2019
 16:21:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Thread-Topic: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Thread-Index: AQHVjwGpa2dwZOHBZEqGAzLsDczxpQ==
Date:   Wed, 30 Oct 2019 16:21:31 +0000
Message-ID: <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
 <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [77.158.50.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb3ac024-8894-4bf5-24a9-08d75d5539a8
x-ms-traffictypediagnostic: BYAPR04MB4101:
x-microsoft-antispam-prvs: <BYAPR04MB4101EE2EA3B5E1DC2EA84703E7600@BYAPR04MB4101.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(189003)(199004)(6116002)(6246003)(66446008)(81166006)(64756008)(8676002)(91956017)(76116006)(81156014)(102836004)(186003)(52536014)(5660300002)(110136005)(305945005)(66946007)(74316002)(478600001)(2906002)(3846002)(86362001)(71200400001)(8936002)(7736002)(316002)(71190400001)(2201001)(14454004)(66556008)(66476007)(256004)(66066001)(7696005)(6436002)(476003)(446003)(9686003)(486006)(229853002)(55016002)(33656002)(25786009)(53546011)(2171002)(6506007)(4326008)(99286004)(26005)(2501003)(76176011)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4101;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jtz4X3Ks/A0YptKkjHMLDm3pOP0eleKVpwfwmgGKofcuwfqQpT6ucTMr7BeWWzO/qE65C1ayZFLmMTQS1t4OeMDf1pHIQW2QCMc1h41CZJblaepj8t8gjR2sAGIEstlCdbYqY3LUGv5ZD4wxtAR2B1ZqZU3bB8SpwFUk07jWucmXdCepoE39eajZb7J3dNCtKB/Kr7DhlOSKtLluQDx7ezlTUmUZ2ZlE0EP+9Yh9AVRR1QQvNM1Z38hnVFbaA0cQEPHH9qvRqEjwBggRbuEVU1c/hX5Nzd20VK9vqxfzkkayeqA3v7xpgmZzrbRpdNl6iGwWGuOh+sMUNKaDCFysE5e/CEBIg67/vnjL0tXOWdX8zOEQVbqcsAQeoh7jM4omIfNBM7uGYHjdPOXrNyjA1gWbM2nfmm+XE3jZ+IdWzo4GDKjXbfEcuOsEUGxbNM3f
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3ac024-8894-4bf5-24a9-08d75d5539a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 16:21:31.4799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xWAlMSVgxFnM0unP1J77DijpyVS6lCnVi1eK8Ge6tSOEQRTddmS7xEFzxsFB+XCeE9+UscpkIZOMGVlV5yt46g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4101
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/10/30 16:15, Bart Van Assche wrote:=0A=
> On 10/30/19 2:08 AM, Damien Le Moal wrote:=0A=
>> struct scsi_cmnd cmd->req.resid_len which is returned and set=0A=
>> respectively by the helper functions scsi_get_resid() and=0A=
>> scsi_set_resid() is an unsigned int. Reflect this fact in the interface=
=0A=
>> of these helper functions.=0A=
>>=0A=
>> Also fix compilation errors due to min() and max() type mismatch=0A=
>> introduced by this change in scsi debug code, usb transport code and in=
=0A=
>> the USB ENE card reader driver.=0A=
>   Please answer my question about how a SCSI LLD should report residual =
=0A=
> overflows. I think this patch is incompatible with the approach used by =
=0A=
> the SRP initiator driver:=0A=
> =0A=
> if (unlikely(rsp->flags & SRP_RSP_FLAG_DIUNDER))=0A=
> 	scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));=0A=
=0A=
be32_to_cpu(rsp->data_in_res_cnt) is always >=3D 0 so no problems.=0A=
=0A=
> else if (unlikely(rsp->flags & SRP_RSP_FLAG_DIOVER))=0A=
> 	scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));=0A=
=0A=
-be32_to_cpu(rsp->data_in_res_cnt) is always <=3D 0. But it does *not*=0A=
matter if my patch is applied or not, this negative value gets stored=0A=
into scmd->req.resid_len which is an *unsigned int*.=0A=
How does that work ?=0A=
=0A=
My patch changes the function resid argument type and that function is=0A=
inline, so in practice, there are 0 changes, none whatsoever, isn't it ?=0A=
=0A=
The problem you are raising here may exist, and how the scsi core will=0A=
handle a negative value cast to an unsigned int, likely resulting in a=0A=
value far larger than the command buffer size, is certainly a serious=0A=
concern. But it is unrelated to what my patch does.=0A=
=0A=
If you feel strongly about it, I have absolutely no problem with=0A=
dropping the patch. I just would like that it be dropped for the right=0A=
reasons...=0A=
=0A=
> else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOUNDER))=0A=
> 	scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));=0A=
> else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))=0A=
> 	scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));=0A=
> =0A=
> Thanks,=0A=
> =0A=
> Bart.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
