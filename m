Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE684C3B183
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC12422CE3
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pXmh2ThK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="s0i1NmPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgHFJ4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 05:56:22 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37240 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729002AbgHFJ4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 05:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596707778; x=1628243778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XUN4Kn/guvWM7WwaJzsJWDONJ/scCUORhIEQCzCitAA=;
  b=pXmh2ThKqhSfdMsYS7DoSRzwNLqTHTuRbX0Ad674cB84Ff91rHd6gGvQ
   0BXVHKV3CamB+DSZUoITYEBoh3Ua+5LYt8HpLXFlIuVJISJAdoAstiZ4/
   cq7i84xANWYtUvJxWSqB2wNZxfGscOEb5fob/rPAw9/6/lnxl/iGxnq2T
   5Oq7dHDRZZkXQpvqDuZQsmqonJlTgn+BRPHaebd2E9F17CPolR+0yE2L8
   KuWRsIsK068kxvE+eyWM2bRY8Gc7+QQCZHS0QjuKmjBxQtlOgBcd+XfRb
   EFcTiC6pDV8nxUMfGZqyYZ1NWYLszHuAwibNoa5/xBrnHsEhKYN61HU25
   g==;
IronPort-SDR: qmW0/v2SAtKXRah28vezHbPZiwV+xeGJ+5pqImdMrcfziog+riU5PQJ2AeuOVozyB66GeYFvq5
 8hhZ86+b821ZJxhSYDQO2O+ql1cmYG0LDFc2cMY5R1++8iW8Tsuc4SSur615LJs7Symxk9uzLV
 xilkcG7OzmJSs+H1F4XDRJ43NnipxUuh4NsSDqpBDz24UFWX6sLVJ9zymG9T54cfkNj8b5307n
 9m3EaX6uhokLUynvzzby45Z/8hkWTpMw707ya1OvBzN7pIUbpiapFCjegfjEmbE65AebeSOWe6
 Z+M=
X-IronPort-AV: E=Sophos;i="5.75,441,1589212800"; 
   d="scan'208";a="145520906"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2020 17:56:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXg67DcdvVPnybFbH7QHChldnG2FWkgQc/dWPNabp48sVJnEYSZTXq6sOVDljyrkdRbGlrOKuccZhPderyC7BPth3rmkgNo5zkxYfaUauO/bMfGfNh+TiMhWyLLnR/twK7yEqNOAczWrxkzFQzE3iR9M/s5BJSooIIFgfBuLPXruEeRSmoAYZ7xH1NPwSS0q5NEuRWxa9CW42m/R8KI3lXq5PISZ/36CcacDlrfqLnfbb72pfpmAMfGs/UR7GSEeJVMMxA0MmK+WhXVhZFObT1dWNcYPSdLgyDPmKDlBDEBRa3YLvZodScyWVODuAw/8fOpiPUZsebHGpgYCrkKUWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUN4Kn/guvWM7WwaJzsJWDONJ/scCUORhIEQCzCitAA=;
 b=jAiHw2T8hiEvb83RRRf1LLly+FtHC/6D1mjcM4AjrHVaZ26Zoy973qYH2YQG4SpgUe285CFJP1rjSyc0l3pgRt1S652cKqLK/4pepzA5Dx52oVE8L/KLTv8Wg7J48E0l5Ssuknofowx8Yrye60DmutS7ww5F5NbiQRwCCO8VAa36mwXvVYedQRUrhnJj/c3G29a2/+14MjHN/ecxN2SIdScXg2SCLryvzI+TGkfzhJsb8SQcOntZHA1TVZLYDUDCXlsIerEow6w/z3v+4qbHRGdvM5BVy5v8vy5hd8cLSJssNuM+XEC5/Rw/EGdYeEnLP0eLbNkFg3Kcah2XqFIejA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUN4Kn/guvWM7WwaJzsJWDONJ/scCUORhIEQCzCitAA=;
 b=s0i1NmPC3qlmV0klnth53FyCxPcb3mjfrH4OCypI4kbijCYsV36VPPEqDRguGFpQC4w8n3CxzNRca35PW/N8E1u8AQtenW/ZvXRV0ijHlWAkzPSR8xkDMxofaBz8j80MKX7nXL3Xxl7Fapi8cjh5FCoqwkhFTABbH3Y5WU6tfRk=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN4PR0401MB3550.namprd04.prod.outlook.com (2603:10b6:803:46::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 09:56:12 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 09:56:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWa8+0AqkNRErINUCUKezc5qYxwKkq1vwAgAAAvyA=
Date:   Thu, 6 Aug 2020 09:56:11 +0000
Message-ID: <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
         <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
In-Reply-To: <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57405058-ed56-4808-4280-08d839eef34d
x-ms-traffictypediagnostic: SN4PR0401MB3550:
x-microsoft-antispam-prvs: <SN4PR0401MB355010C82481F7DFFDFE92A1FC480@SN4PR0401MB3550.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mheBpQSvTyr9JvHuzRt98jfiwG6vZczkVNVVynl4p9tK2Uz1KVkAZfkGd2+onu+/sddqC9OLDLzwC63cZKNJLiuZ/UUewuSM95yVhJdvhHR69y1RZAQrsNJKGdjPIX87GBGmAU1SnNKXddLCp3Lq6430nFdHbIvfRtdfvCKI+rCoQqsEunMi7V57CYjXSvrFXmByk7TQwApNIoD5Fcmb6l9SYGgDIpL6/WOmjconvnIaY7wL5Hf2xtfsUxu2PoKBIC30KNTYIaos5pOcT4G4wRG3UygaUYXh0PRCg5uNQV1LWnd7N4hmAitp3hNJgdzFOOIh5RpfoCjPsMgvnB0FJ2+iLSU25TysX7Q391Gsy3HTUm51Cc/Dy6voMh4wBB41
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(2906002)(6506007)(316002)(7416002)(26005)(64756008)(7696005)(66446008)(66476007)(66556008)(186003)(76116006)(558084003)(5660300002)(52536014)(66946007)(54906003)(86362001)(9686003)(8936002)(110136005)(4326008)(8676002)(33656002)(71200400001)(478600001)(55016002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v+HXlPdk2fvG3WafjAQAt/xspojZ/HUCpiqAeRTgvUH6RmUSqS20skmsqqkw1AmqmHhbTmSNtSqUC9qHsLQsIw50355EHhOSKwUsnEm2jEvnPoBE2yfSNHINEatk0jrwR1t/isR+t4JpjUEjsKX07e+DPK3rpyS/jTU2I63WnkWcRQwvtwA3iUUo5s6bpqfUADBb6TDZ0P5ND2QPDWsb6cbDHfuQjPuMbbm8ZDr73M2zXCFIz3v5cmCUkEIUF8RoqWqU7KOuiuZDC2ax3KNdMt69aF507u3T5Y8naR9C+JdJY+HNdYm2XUqkDDMvv3D1iVZG8db8odyz+QoRC2NqONWoZJmEoO6B5J6Ob4FK18Jsc29YqIZtP4x7zchDpKzV3KtzbdTFnbnhv1GB70wpEvWlCw+R2ExzSRIhCTNccEZHRXcQB2B4tBRXZ5Na9hBVSfh6SJ6gjyBgOv3ZCoGD/XefV6IAFA0tifIqUkzi1VTR2+sp6S2y+0EpwPCeU31PqKn8/rzOhrbTjT2amFjt6QywPHnvekSJL4sk2yiurhlRs3ZG6mRS99chnY3AwQPjXJF7bsdOXbWT/kUXZJbPkjtMtbR875FVLpKC75eqRbMVykSvoFwdyIiosVYSmhyIp9SjfhQ3jOPY5YEjtY+uBA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57405058-ed56-4808-4280-08d839eef34d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 09:56:11.8622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lBXgJwZ9ygrigIMjrthhDUhXj5LowNTpHuj7E/etQTQCvzmh5BzkL83xeYKNLdQDTnJ3P6PGphjAuUs0xRcsWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3550
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Hi Avri
> what is your plan for this series patchset?
I already acked it.
Waiting for the senior members to decide.

Thanks,
Avri

>=20
> Bean

