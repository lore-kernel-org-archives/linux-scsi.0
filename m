Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0B8C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 13:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F50F61002
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 13:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhETNNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 09:13:43 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28722 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhETNNm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 09:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621516340; x=1653052340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t2gowFc4W3PJlr8BK/pbh4oXbta1jco0IX5EIrzoyXY=;
  b=DvnTzpWO5YpzKIwW0bomHwgqiX5I5wqA8DBRb9/Q6R2hnPmwNUZaQ+Hx
   KxLrjnepSKDVcX1900sBeQGwi7olOZ8Bw4G+ro4x+3XREStEQqNgf/lwG
   mDQIRgJBfcI7q8HEAT+XE2b/9wzmkYGGQu8MDVokwEnVD+7VRA7GWbAhB
   1QYypZO4PjmhqmGTpXws9REmRRQl9YHdQekKIj6sNxvYcNgu0tjaOtKzY
   2Klr3KrDZZzgGTXtIKzpVtpKYOpD2hIw6Ellv5REolTI7hvNZkIObCnlR
   jApFqSmyMyARXomIeQ8hiT5oDl+m64cc8fFzOoEpbcF0MWjIit0Blkbl5
   A==;
IronPort-SDR: K9E+dYlYTg3naS74Pqbvfc/E7yJR+X1stRJ091877sdOf2DT1bqsORPQ3J2A4Z7SNg6OeR5zRh
 P+iML1M5T+omiqrNK1bn2/LW6qtrnA2LUgADtykJg7Z7SNOoTciJUxfuUD1C6VrufGaL/lG74W
 ZnT2vsKy3guWFzCNrFR262ywU55eeUsiHVJU0Yz4ahxH77bkx0tXBHulwfwN76f/H5A1FHZOBz
 PqD3K4w8alu2NniizOiBj7p5sFQEK9OGMQB+qNhX5reNxZl/4ofHoo7CMP2lDLqvJJA3Pb+NIU
 jb8=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; 
   d="scan'208";a="168851872"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 21:12:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EB5GCtP2xLxB5EnAbO+XywGCX5AqMFD28evD0lYUn4f3069N3IFQYqS3Hz2BU0bpQ5cktZq9U27NlFktCki2r6P5k5pM+lFVZagKr0e7DkmY3NuWh7E+2IWAGXvyjmKuJn4eANy0DrEumRHbbWXFkGvHQOK951JxhLHMQ/9R/f1GGyiGKCF6GepfVXyU5lMzcXHrfei1lrvtui1rDmV1o0zOzYOvQHEVBfk2weGT2t9ZH8tiwQJNobeEIBn2B+saBAO/fb/mpBh9bY8BoB7EDmWfCOGYgsHWKNssoSkTrbZ3wcUzGZ5KdBZbfjft7d13OR+qyUi2j5UHT1TmnLQQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2gowFc4W3PJlr8BK/pbh4oXbta1jco0IX5EIrzoyXY=;
 b=O7DOHgsA6/BGWyVVKT3ZdtbB4dqkra0laSrsBk0ZFU2+QGJC7RV9YJByiVgIW7AwNM76LOSb0cozu7fybMJ8yboujQPh87DNKagdgEOaoBwImbwxzGqJaOoUhG9ZQPzaWcDgQSBs6asx424mwe+b0Hui01bcxYUQz85Tz+oUnRfNc3Mg3SWk+HaqUaHQ4aWu3kOVEvMChuUSzQqPkinkUpMJpvOjBLsx4r4GrgePM26sc3jjEajps14ee19K2ZTZw5FLCFm3Yomaf37t1Xip/l1T26m3VTnqTVuOcsvBbD6aIHTu3B2+VHd8bT628qbCwRk9VJ+KPoZIX6EkA46ijQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2gowFc4W3PJlr8BK/pbh4oXbta1jco0IX5EIrzoyXY=;
 b=FCdEmrETVYerDFLPFdTAt7HXJ8ImcCfUYUiUIu146SVi8ccJgR1eQY0oGWFRvliyiKJrRiXGhfZ1XpMrDMZDdk6/kwNRdQmvxT3cIn3monhQycf1X5VBioY8HCYKKPayIxfhfohV/zczlfeTP36l4DOAOR7ZeSEQEM4GlX0tR68=
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com (2603:10b6:a03:291::7)
 by BYAPR04MB4101.namprd04.prod.outlook.com (2603:10b6:a02:af::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.30; Thu, 20 May
 2021 13:12:19 +0000
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd]) by SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd%5]) with mapi id 15.20.4129.035; Thu, 20 May 2021
 13:12:19 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: iblock: Fix smp_processor_id BUG messages
Thread-Topic: [PATCH] scsi: target: iblock: Fix smp_processor_id BUG messages
Thread-Index: AQHXTP4VDBrWNlKukkGBaFtJUdZkhKrsWYgA
Date:   Thu, 20 May 2021 13:12:19 +0000
Message-ID: <20210520131218.yxmiwriwbyq4v5q7@shindev.dhcp.fujisawa.hgst.com>
References: <20210519222640.5153-1-michael.christie@oracle.com>
In-Reply-To: <20210519222640.5153-1-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa2daf0e-12b5-4a60-08b3-08d91b90e5ce
x-ms-traffictypediagnostic: BYAPR04MB4101:
x-microsoft-antispam-prvs: <BYAPR04MB4101B3C77706EEDF3758088FED2A9@BYAPR04MB4101.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLznUVJ+udr6hef3wogik/nNBpCNsD20Jnq98tXLqzVQvYQ5nKjUDhGkM07l6QLGrfns75P4nSVIGO2CnRmgNf/SAJ7hEdQVCCxKy/wH3hod4gNmo84a2IYtzWjiZuESuugTiGkEej7CcxZerrojrNEKBy7pdsD3FIq6WDxlTJxS2ux7xonOTu+RxcrW+oIwZhhdJgiAfdxWX+akN/mkzh0Qf2iZO62y/nZQUd8oOZTn9su8AutEVNAhM3B0YnPSCKm+ftxmNo+4qRKIb0QXmTYxpNf9NWmuRywIq6r+pyLPbWuxqTChSJbRM09iwJbO6XoiIeWJ7kLYkpn9y7aTSuOTaqGLYkvH0h8WZVwMW0ROaWRJNWz9enuuKPEGkm9tFZwgRMO9dcs4bGl5KSsfv7FUJMEBFGJteAYVv2KonLtiVfBf8mEjE/6TWHIoY/nP77yZ+mEMZhcBEEgq1IemVcb31FM82PdMfZyI83/DojhnnncMdLhu++R9nltydfBBS6WFft+PJ+JlklYjECwaC6cYNYY+xNCoBgimriXNPsWQB4q/u+q9PBp1IvhmQ5fdjmTjsX5LGEo4oZk4jRWsrP4909cynZazv2zJuUP7WTMQMxRrmuTuExn3MyyxBHBTd0bNBvadv6yFS3D4w+lPkplKW8hv1flku5CeW8O333zQ+Ng5v1PnGUwqTGvIaI9mWhIvQ6qSFPjLaguh3ZIzNPYiCyPOg+Gx0RV7mEMno+g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7184.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(6512007)(6506007)(9686003)(6916009)(122000001)(4326008)(6486002)(5660300002)(86362001)(38100700002)(1076003)(8676002)(71200400001)(8936002)(26005)(966005)(478600001)(316002)(54906003)(186003)(44832011)(66446008)(66556008)(66476007)(64756008)(76116006)(2906002)(66946007)(15650500001)(83380400001)(91956017)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bvdlzlO9Tu3+GbXtHqIWzoSO3mzlKEGuwPtxpPuxG3Nyzbv9Hvs4uV60fsPc?=
 =?us-ascii?Q?GPUwdcTsSFxRw5gMrIGtj14YLioNlfklHlw7P51YLxqI5wKJt+ivSiF/I1a1?=
 =?us-ascii?Q?AR8aU5r50qmVvkKC2OkRmZvi3uxzPomfvLcS4TfI2Zt/2vj6SMr9ZVTfa5tX?=
 =?us-ascii?Q?nLWoMFJaEWVTgQ++ZNIqX48pJW5AYnAgCsr8/3nC4aaesNe7hPY0ImtWkULZ?=
 =?us-ascii?Q?3g0qMt2B+LmLyBWQYcWOIjcPb55E7xM0N5tfKME8WPr1+iMg1hwOYQnL/qQF?=
 =?us-ascii?Q?cMxujcnQA88yhk28KCM7w5aws+fEAO925HtKeB6Qttmm4FUiA6sQretJf99g?=
 =?us-ascii?Q?xGKVoUIx8XuxEiHIyAc6tIBXsGxsMZYqbs9LN4NxJct3K/WesUxadGUmsMxT?=
 =?us-ascii?Q?T0DjpjfL5p0AB2ASYEn+I8WEuVtduAcxR4cK6PM5sbrnqN3qHLPtecaX3xPa?=
 =?us-ascii?Q?7bLzuPH5zkdRy3Qthw0w2UckcZjBVI3MdHtyfuEZjGIaHS7SD6XncwaIST4C?=
 =?us-ascii?Q?NJkCriWG7iUoPVubxAn9YCnK1Jo6ZNadpKPalpvbGs87SAWVJUKIOMYkkFrk?=
 =?us-ascii?Q?5jXZj0DFk7+rUSW/BXkh9s8yXzBAxHBdpTRAviNytED6MeJsudjggEMKdF8n?=
 =?us-ascii?Q?Y9zR2CojfSn9u+IrAii3bc7a+uYllhgcMOWv9HrZbXFvLSSE7kuGaZdih28r?=
 =?us-ascii?Q?ReW3BhkL/Hs2hK+2Asy587FqYASepQMoYaot2daREwPsCV+YzC8OtKf+4rUo?=
 =?us-ascii?Q?Xwia7NNCbbxnDI/04AQTBD0nxuxDCVR+YX8XJ+VH3AL6h4MdSAKKITb/KbRm?=
 =?us-ascii?Q?Ja7ZPqbplYsf4D4/pwXeNSjjxtQxiBKh9pLLRrRsZQE/h7br66jWLAEpYvB7?=
 =?us-ascii?Q?AEac6puAOyS6Gvl6ipugtzWDXFJKottj9sObEThKAp4w/CGjPEI/MWTGphct?=
 =?us-ascii?Q?e5EP6Cj350PlY7UnfWKsZn8WUEbDhXPsU6xHLKi+1szclarmo28q7vuiZpH3?=
 =?us-ascii?Q?5liGeOeeHe2TbzOdRltiMCUjvN5xaZfASf7jHlAdZAYdMOzBuitd8tk0sT1r?=
 =?us-ascii?Q?C4wHzoe020YiHPAVgXzP7sj8uaoEXq3+2Yo1ZaXuQFNqQXFIH3zSPELu5L9j?=
 =?us-ascii?Q?nrbIUcozo7wSzFnKioKtFijMIs1C4K0QHhFpsphczDL7nqbyI1Tm4mWIzR08?=
 =?us-ascii?Q?/RaN2ryPph6hCc0Yob6heeP0Quu5uFkkyAgDgjTlUKuXnzJSrlhpy4Rn7Hm3?=
 =?us-ascii?Q?O1J6mSW0UF2ydEe6Fx8/ajVolLbK81iymCDCqvI2G74ayhCFq6lg8thgST6X?=
 =?us-ascii?Q?DkxP68+iB7p6sS9Dr/v06+FHuSSMNpPWn6g1mdjI+/I1nA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E5D1088E8BE8B94AB2C4AB686F51A294@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7184.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2daf0e-12b5-4a60-08b3-08d91b90e5ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 13:12:19.2748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKTBL6g0ROqqrBxtjkWyLzr4mRaSchHx8CTMeRCeqnxasjsrrk4FX/Im2+RGLG11owJBuja6J8Hsm8vAY9eUhm1rVxsRAnm9y4u5kGZbo/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 19, 2021 / 17:26, Mike Christie wrote:
> This has us use raw_smp_processor_id in iblock's plug_device callout.
> smp_processor_id is not needed here, because we are running from a per CP=
U
> work item that is also queued to run on a worker thread that is normally
> bound to a specific CPU. If the worker thread did end up switching CPUs
> then it's handled the same way we handle when the work got moved to a
> different CPU's worker thread, where we will just end up sending IO from
> the new CPU.
>=20
> Fixes: 415ccd9811da ("scsi: target: iblock: Add backend plug/unplug
> callouts")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Thanks Mike. To confirm this patch, I tried to trigger the BUG message usin=
g
block backstore on kernel configured with DEBUG_PREEMPT, but I was not able=
 to
trigger it. Having said that, I think this change prevents the potential BU=
G
message with the same reasoning as the other fix in target_core_transport [=
1].
As far as I read through the code, the code should work even when CPU switc=
hes.

[1] https://marc.info/?l=3Dlinux-scsi&m=3D162106219905019

--=20
Best Regards,
Shin'ichiro Kawasaki=
