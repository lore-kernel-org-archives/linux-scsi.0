Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B2EC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 07:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275A664E79
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 07:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhBHHv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 02:51:59 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37447 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhBHHv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 02:51:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612770717; x=1644306717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zSTotmdq6zw/19aXZyCo9OTGSvs8ZIj39T+shCF/ZiE=;
  b=inDj6VqYv/d08eneFRsYRXOuyvaKa6pVdRGS7tsH7eNzYr19SziZCf5l
   pCtoQ+HcvQ5H1vGpYD1aRKBnak338gdTEeny5DgvmdRlzsa9UVeSqPzbL
   f7JPz/dTJ/m8KxMUeTPLO2Vgw1BYphheJRiejE2KPAHh68jwaQenEH/o6
   jO48mfughxq7oC9JNmzW/sSQxnwgXvC/31yPnKH1vJczQSNOmR5pkXqwe
   VlT2EviZHNCo/ATgdHd8anLIdEwQNc5JFZQnrn5z23QGl8/STfEYJrQDi
   D2LqpXQgEsrooIImfSTk7UFbYdOpwUdB/osiH0sGccR8svt6sojwptP89
   A==;
IronPort-SDR: VO9egRakpOUPUKzaFYRGjBw8xqVirL2DLInRzXZdBG7CU7mBcYCPNxsyTsITNBxlB1FIWoh/PF
 JbRoCKuKF8+zMdYhM19NzgcOWIXjbkWykr01WDgk45MBA4jgvH86me6I8D85hfkDJHZqcj0/T+
 j7cthK7YeDrLda3mcmorhzoXUM7LMFJjMkd4pzaV4MbNYBQVeHLGBawdxxrrCs0hq4+VDMD9zV
 9ayhQ1tGKpRAgpeXG32N08ehCXVMnL0YqHItBt/FIN60j6NJQ/u8UplkyZOBLaeDrSTd1NHTjj
 gm8=
X-IronPort-AV: E=Sophos;i="5.81,161,1610380800"; 
   d="scan'208";a="159431634"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2021 15:50:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNwqjaszbWv3SNcotPho9L6BkpqHJLeDNSRx4TmOmFTFdfSEafcJ7YZfh+1U73NjCs7zEt89KYO5bhZQZgazD+JIrazmoBoPDEhO7/vjd7oYJooqxvqviJGmmbwLv+rU3zIF2P28xgJXI8+R6u5udCcwsDAl99qXdos22HVXF29BjB+Hq/0NybgujWOAZFsVJHWye9OK7AyCe66+9xi/wiKcU6O7eE4nmBNtTEEzxdT01tVRgp88it7kClvig4KOov/LzX96ePve34kTiOOIoOiPeT6MXX2Q65XBNh6w1UH1Ecm3GGi9k/nVN/5JYcvGfzrlmGdmj1gOqa8lnc6Gbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kB4OcgKrGSPvY6XjiT+eMx1tQpisc32Y4vNjYkEslc=;
 b=dtFcIWTx+rvGUNNiUks5bsJR5HYSw6INJVApRUHRywmJSu+q5LDDcZl1lBC1L/T8ICqxG6d9a3AskF7OwnlM1eigw4LWwH+TRTuPwbzMrquSErCH9Kzk6yHlvyN/qw+OnTMJlEwHtwfl1zSRHmjsGuWRHkDnugSrWcqnl4tsVn8ugbv/3O5HsbI4jbjNQ+chH0ktLXSvgrF8/BLnuX0a4Q6x4tvjYlnK7Q0MJS7aFyROHdEm2ZBIdbyV4O/VEeve6E8SkQpgl90QbXM6DdzQcpXNeoKPOs6m6HZYpkbKpryf2iSfnV7DMCf8po7HL3yZYiSMoO9n53S95USwsQaaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kB4OcgKrGSPvY6XjiT+eMx1tQpisc32Y4vNjYkEslc=;
 b=Vz4pVH4X6GvbG8C71M5eVwD2owF4UwtQWn3bgIr2qGkfwoXRgnD0TBBvvX9B3XyRas6hml+IDguTMIFQHVJCL/y8L+L5BDuEcc213TWAnwCVnryBAVFv6tIQyyyUP2XX39FqN3A1RmZVoMF7pzlE2MyqM7hXbk5H1Ht/yr/5twM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4170.namprd04.prod.outlook.com (2603:10b6:5:9c::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.23; Mon, 8 Feb 2021 07:50:50 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 07:50:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 6/9] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v2 6/9] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHW+T3HVj52qXrLJkOljnc4s62oj6pN1oaAgAAU7qA=
Date:   Mon, 8 Feb 2021 07:50:50 +0000
Message-ID: <DM6PR04MB6575477CCE75422702460035FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-7-avri.altman@wdc.com>
 <91845a884facd63d9e9d62e2e3424cfd@codeaurora.org>
In-Reply-To: <91845a884facd63d9e9d62e2e3424cfd@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 773ac80b-5efb-4aba-47b8-08d8cc064100
x-ms-traffictypediagnostic: DM6PR04MB4170:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB41705A72917FE27B15F9E12AFC8F9@DM6PR04MB4170.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DHBqzCSOI8lAhUbUAonZnnz205cDDlp63sf3+OHc4Q4v9a/vAs5SlVswdiKw3eio2PPmg1rZqzXtuk7Ci46ftuplTG4B1s+EK0GZYuYPAC8CDsPDWzK/KMxH/rXYmoso6ECeRn2w5A1V5duPnPpCrDkdHT9+6+AQ7Wnb/vCn5RbbKFdb8Y6EEEuMHiOln4DRxDJuvbFOXPTxz4J3vOfsh/Zqb4EKLyjyro0/U7u+Aen/uwGPYpx+64UpbX6gBpzt3ClL+5G8vFYAlptJJeJVmOIy6DCkoWg8u1ITzN+LmnFdk0THriNFLMTG0BXFiYbJwYYSp27wjoDW7hnYNasb99xFmJT7HYp80UBCp10c7E6jszwC9/WL6kKNaC1bRRGdz93GOmos+WgeGHp5XvDNSEh9v0+AKo4pwU9rv544X2MimmOrl6uzVmPhSYDxjPP5DwGXgpQbTFsmhwvhdmZkW2jMqgBHV9xEGxSqKOBwvtfglcHbY6WY4F6Trd00J22CfJItHNT7FhDYWBxa9s3N9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(7416002)(6916009)(2906002)(5660300002)(8676002)(66946007)(4744005)(186003)(71200400001)(66556008)(26005)(7696005)(6506007)(86362001)(478600001)(52536014)(54906003)(64756008)(9686003)(316002)(33656002)(55016002)(76116006)(66446008)(83380400001)(4326008)(8936002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ezvf9Ph05+ZDe7CeA9gcNQ53Lc2fXh15HxIXDGwb4w7iv3zYiFXRzvkX2w4L?=
 =?us-ascii?Q?mX5prHPUplQyhWoI0LJAPAc3o+kt1AK7uC6vtLDBhjyFW4wKXjzabAsFwPP/?=
 =?us-ascii?Q?BTm6FWVxekSb2HdTWmX7Y6ckHt+U3r+75PsfNriW1Kgva1qUA2cJkY3B7RNc?=
 =?us-ascii?Q?KmA/3n8IXdVRlzPW+pYbeVFU7acZ6PizS41tKQhwvAaunPbLjGlsh+6CgwQ3?=
 =?us-ascii?Q?0VgGUHZfMIpECahbvLdi9N/QEaPvHLQlsNqK4149SNTHlgBHVoVXtSGhPb2d?=
 =?us-ascii?Q?5PLhxQpS+7S/ewsbkEmngFkqicpLBgxXZVCnFZ12EHO1IrmcYhOUPewTCi5i?=
 =?us-ascii?Q?pPqpHVa2CADL/qGz+hG2aHv2p6poMLubZeO7D9Vmamot9OWl16GGYUVq/GEM?=
 =?us-ascii?Q?NfnXc0noAMHdK2u8G7eUyovDkmvG8585UItKJZkZqyyagH+pJaT4iCCxILRw?=
 =?us-ascii?Q?Kw3BnDk6md9r3IJlXgn0GouXaTEH5It/mF4Foh6OSuCcGpJasuukyz/im8z8?=
 =?us-ascii?Q?nA3chiAAW87IrLm4fL6WlQNwqCqyu9MxMIB6f9tpC1gp3w/tQPNJUV2RJ/IS?=
 =?us-ascii?Q?2e4JPFB1vUk4xTt4nUBPiuNvKk4WPyHDaipQKEo92/i80MPvhPIlQyTB1cBt?=
 =?us-ascii?Q?gJE9JOdkKm4u+LfrkDogE+0c2wyk7U4IAU9eGXnsa66x2vnZLApalvCnmgEF?=
 =?us-ascii?Q?TtU3R1wARuYTYPTAoBbWKMgiRMHuYd7BDG6UWzPSSbiS8gK6je4eKQarA6vb?=
 =?us-ascii?Q?AqHwqEuAoRnQJZa1456jugFjt+5V7e9wx3rsit5L41lWVIkJJavLjCa0xp4+?=
 =?us-ascii?Q?zEGbBDv5BSLiUAXNjSAu7RigBnKfNhX8jpEXJVj/iC20Nj92KEDJT+RlGVif?=
 =?us-ascii?Q?xGyRk3Fp0w+KipKXW9ZY7b+TnV/J4mPf01knIHBn0yfTpWjV/2uFmXf8rGU+?=
 =?us-ascii?Q?846AkMw+iPnOi1w4mxS/bAG1SX3EgBrGTgMXdG9XE6BoR4URCmoEtkk8Xgn2?=
 =?us-ascii?Q?25vX3eeHwG6JYZDZLxbMpEAFggVpoWCE/JgXqy9tn9cCMclmtmrMIT/CQ4Da?=
 =?us-ascii?Q?LKtIxSVDebzenSpMg36j7cPzI55ZYWGdVzpKjrT0WzX9xD48k3KuBSntEB+D?=
 =?us-ascii?Q?GAymRthKQkVIkJmxBBVAxQ5QtbGTqrDBgvoKs/U7N8QtVCBJOfIyzRxwXlc2?=
 =?us-ascii?Q?uA9EMWLA2bLtRMfj5p4fGe/48lpDdSkpQjCeFfVVBD5c1Dmz9EGDwINeMCFF?=
 =?us-ascii?Q?eyfCOBeUH1YqgIXi8G1kbTJQGCZ06MNHsXXJTHwsohdhvehNOY2dvqz33sYu?=
 =?us-ascii?Q?Kw6+v66TqOvjIgMpukpLsJHA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773ac80b-5efb-4aba-47b8-08d8cc064100
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 07:50:50.4157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TfvCKQzSP5HLmDLmH0TDguoPskeYeq+B1mvvvebub43O1KRyTySpHCDP/eRSgLexEbyZbAKzCITwlI8EIPC5qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +             if (hpb->is_hcm) {
> > +                     struct ufshpb_lu *h;
> > +                     struct scsi_device *sdev;
> > +
> > +                     shost_for_each_device(sdev, hba->host) {
>=20
> I haven't test it yet, but this line shall cause recursive spin lock -
> in current code base, ufshpb_rsp_upiu() is called with host_lock held.
Yayks Ouch.  Will fix.

Thanks,
Avri
