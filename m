Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49ECC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 01:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A48EF208DB
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 01:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="NuFO9+BX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIABSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 21:18:55 -0400
Received: from mail-eopbgr760103.outbound.protection.outlook.com ([40.107.76.103]:49984
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbgIABSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 21:18:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYUIhbSBNr4ImebbyazDz9DJRsKOT9D51wWee6CNxUbhy0JFmiShg2Rkeqm3pXhX79V+URV/qp1o7HfWsTTEyoJOGe/aaaMhEJpvFLGiludZGTgmAxGnNYQRVr3dYL6MacQidu/I3bftcZ1iRboH9W8zmzCS5Jt6YS8hu5X0Kh1QBZ9IgblXnWdOZntPP3BxS0TMdA2KLwMiG1YbZLnqcEDlDmjIVuzWruZFssGaJYt9XzYndxfYAXc5LPOtGM9lDdrWmaBxE68NL9JDJ1LoNAjFaHSm7g8IjOglQsvQkuLAQ1jSwxxbGHTn5DGwLFvklUaDAxWdV9kYjem2oUIl8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6wz6zbLpjsXZjMKwcAnVCXR/FhexfQimBojoBYUsHg=;
 b=NSmbgM/oEVaxhImZqQpKB/j34RHFr87GgwS6xnxr0MtTxt04CeWbMzhRx2DO+iAZ1vM0H+ksFQ2QNKmrQR03FKj/F2iO/8qDlQeFKBBiJsW4yOXWiM5GLfVX1W0yO/0yKp/6ihz5wQ4Qyww6JcLZFrCscKTYuH8nUpumPTYuGNXkD42UF+9cIOb24BvbjScdzcMz1VEthfDrn4W5J1Tr1NOebBYvWEaT+mJxasZ0Lmcd1xLIlzg/p5w3Oc2w/3lctKsCbM9wORieBTK+aNZgijBKhQPXPzfVE78UWCewZFi5iTs31Jxny9HILQ66Hl61eEDsNdm32l7jazGHsWVzzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6wz6zbLpjsXZjMKwcAnVCXR/FhexfQimBojoBYUsHg=;
 b=NuFO9+BXDh0706WQmzWeEgA5bdpRmINmtBY6MSibIaimLGwmanT5mh0wDnCJa4sSAgyptKZRNteyLYI50ka/HehjP0fayEsdTOr8soM0kKE25WnqZqtSgntCiXrzUuGAXtthMpKRSiH2dl7rcZll6Ahw9DMfgQnVqvWAF4XGADA=
Received: from BN8PR21MB1155.namprd21.prod.outlook.com (2603:10b6:408:73::10)
 by BN8PR21MB1268.namprd21.prod.outlook.com (2603:10b6:408:a1::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.1; Tue, 1 Sep
 2020 01:18:50 +0000
Received: from BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::bd1f:fcd4:1c46:ae91]) by BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::bd1f:fcd4:1c46:ae91%9]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 01:18:50 +0000
From:   Long Li <longli@microsoft.com>
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: RE: [PATCH V4] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Thread-Topic: [PATCH V4] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Thread-Index: AQHWdH5tP2fAcy57gE+531Qmfsu0I6lBEbOAgBH9iYA=
Date:   Tue, 1 Sep 2020 01:18:50 +0000
Message-ID: <BN8PR21MB1155A14705AA35680B25F9F4CE2E0@BN8PR21MB1155.namprd21.prod.outlook.com>
References: <20200817100840.2496976-1-ming.lei@redhat.com>
 <5805af73-c3ec-8393-0dc2-18fe797d781b@huawei.com>
In-Reply-To: <5805af73-c3ec-8393-0dc2-18fe797d781b@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=877a38d1-72b7-4e51-bfae-577374230989;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-01T01:06:24Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2001:4898:80e8:0:edee:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a040746f-995a-4a0f-76f1-08d84e14fbd6
x-ms-traffictypediagnostic: BN8PR21MB1268:
x-microsoft-antispam-prvs: <BN8PR21MB1268C357B56012588FAD4732CE2E0@BN8PR21MB1268.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SeqqjqkHtRjcFCvMkjYL8aAQ1Rknu1RYiDJmMUObCNJ0je2h5iF31UjUg7wK0JFmiOusnf4SNhujnhXa6tWM7zXFe5yRMpTdpAFM7DhUcJQwOGdvCPxeY135+DMlgSR9MEmjnpxG4JSmMMA7avH+mDo0hpJjpFF84NJQREx+kunaI5uGnGwWxz/fNyr5QRXDy1YpyOfFBebM+gtnqp4Y6qJhYNvcbIRY9oTYZnHC0vRYaJiWJfPwNisfLSHwIwM2lJ5y4M7ypJgBHNoGKCVpM0ZJ3zbPPlD4L+DxVJJ+4sl6fql94lfEGQruUAzkymGOHc4CHxpQZKQ0zW6JDcPL8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1155.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(33656002)(6506007)(52536014)(83380400001)(71200400001)(4326008)(110136005)(7696005)(54906003)(82950400001)(5660300002)(82960400001)(10290500003)(186003)(64756008)(8676002)(8936002)(76116006)(86362001)(478600001)(8990500004)(316002)(9686003)(2906002)(7416002)(55016002)(66446008)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bfQYaurQTKljXJfdVQp+OzBErr5NoDd/gsmY/xk43FNmaUQYdnMX4S9yCbHRY4nv+JqZc/USVMXutTLQtjnYsgckLKzBdg+l23FBLB9VBHdiUVATVpAQ5P0J9Y2SwmmEGyPx9MvG0c6x0/Rb2vmn5WWMBv7ZuTcYXceF/21zt+AopHC5FCFIRWalitEVQMbm8no5+9uH8jdTUQrtwe8M7f4TSj/QAxXD3q2bw4Gp5JBxg3R8WJ9F3BbvbuJHZ3HqMVB/0Cyw95dPs6clRAiCC4DicQ1GNaFg5VIT1gMcACju7yEB5Oel7/jE5DRIRlj24siee19GLkK963ld4ez0IL1V3fy1X8+ccVnmAk3vDhpXgFCyOWKjuSsTQMVzNl8kUcGq+nANECyD86gbPr/nBGiG1xrXJF0Z5HfhrUXQ3fiYnVhcngwKqYMQyeE3DCzkQ3iBMx1v9CfivtBtKvzhabsx1yFpSl0vemS/EOwDeT9goRoo8ykeuX/hEL2O/RNc14SLxf2bJ2YaoM2TXskuO7s/XmaVGGVC0yDQDNB+kCaNmFZmDf/vXZJs14ndUq0ARBz03zCm8upenzWFswSjZrdnOGIwOjfxjPZUvC0KLGZowp0305rIuVHEQdijm2BcOes97ZWCY6fwOfwcmjCuBnDeJ/m7X9DUOmT1XP2frb/zk/weUYuHLSKm35ZjDOE5GiDY+L6QpwN52buxCBBhQw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1155.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a040746f-995a-4a0f-76f1-08d84e14fbd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2020 01:18:50.2864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4QoM0nxKKFqOWb0ur0vWlTMvqLEpdT1Z/CipJZBHGh43axAZCQ37O57YidvswpxGe/DVqMgmu59RDvliSMF+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1268
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request(=
) if
>device queue is busy
>
>On 17/08/2020 11:08, Ming Lei wrote:
>> Now the request queue is run in scsi_end_request() unconditionally if
>> both target queue and host queue is ready. We should have re-run
>> request queue only after this device queue becomes busy for restarting t=
his
>LUN only.
>>
>> Recently Long Li reported that cost of run queue may be very heavy in
>> case of high queue depth. So improve this situation by only running
>> the request queue when this LUN is busy.
>>
>> Cc: Ewan D. Milne <emilne@redhat.com>
>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: Long Li <longli@microsoft.com>
>> Cc: John Garry <john.garry@huawei.com>
>> Cc: linux-block@vger.kernel.org
>> Reported-by: Long Li <longli@microsoft.com>
>> Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>
>FWIW, this looks ok to me, and tested on scsi_debug showed less time in
>blk_mq_run_hw_queues() [for reduced queue depth]:
>
>Reviewed-by: John Garry <john.garry@huawei.com>
>
>thanks

On Azure Standard D64s v3 (64 vcpus, 256 GiB memory), it sees better CPU ut=
ilization with the patch.

Tested-by: Long Li <longli@microsoft.com>
