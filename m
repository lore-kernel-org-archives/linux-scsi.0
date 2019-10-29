Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEDCCA9EC2
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 08:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A42262086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 08:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="caqURjNQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cJDbleUm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfJ2IRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 04:17:22 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58318 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbfJ2IRW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 04:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572337042; x=1603873042;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=i90SBP+DU/MG6nMHnPF5/nSs77pdu5M5CRJxzbkGMVs=;
  b=caqURjNQVhXLNEzPv2mJMh+hMYZIjd/gH38GNI/KZw4keb3+nYaFnvtY
   C/K+/CxnW2v71ZPM03tlqnxG43i3DkoHe+Df9/ar8faDpjvUIm6isZqQg
   dCYh3W6RWt7AJzHqsdo3BgbS3uE/5QIGGLqDQbT//jfzengHrfHywwlAC
   cEtUjcLbOG/h74rUnRqqjcpB2XM0925y9dWg368qEAYl+yzul7CbStAHT
   +A4JbHfU+2dHNafgJj91p9JtDCl5QtHbhlT4hH5dFUY257zd6+Mgv/Sjr
   W2DNyfx29vkvSscBkxp5oAPSbSVzU4kYnXqgdFmEWZc/AtoRm5lx7BZQK
   Q==;
IronPort-SDR: lnMriUzBrY9AoSGeGqtDftUBEhpxc18+yZbQnY5MzkgiAPTzVT5EUj7Rnsr0vKlv4NicIqszt7
 LPwiiqLjYL572OhGF0htJh/jgX5aWczX/Uvi8xXpH9FhVrylLWq+BfhUiYy7s1o9+ELgWDnoev
 zYsxOv5sE+J1xYVuLyq1IW0K/vrTEPDProxJzfq8qun+vik/QivqA9rNuOvQm71bY02YRSvaBb
 ++o4RS1y7iRMxv1nYCVsvlFaWp/5z2v86KHNshV20OBjxifeXvp06atRq7cWhTAl/6yigEv4w2
 rVg=
X-IronPort-AV: E=Sophos;i="5.68,243,1569254400"; 
   d="scan'208";a="123158392"
Received: from mail-bl2nam02lp2053.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.53])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2019 16:17:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ne+YEUiCiXy110Ezel/md0cmGBs8EcgUzOlxWzvBbqDvHuh38uGBWkwiv9BKJKr/L+Ldf8uN4D237j/z98CYb4G5WbUsCj2SLS44tamUPDSkyWeTHHo5Orsji2p1b17fqgYqoxjzZLKdYGBVNIz034AuLs+XfYxatOayiwBJuNJy7lG3//5HeFUDGDUQQQenl5rOFIaUgHQ6pHxCmnrJk6KTWzxDbmgR8kmhdRXLV1P6RyaMM1fj2YfrfyNrmyVKgyl23aN9WHNUAdnmgj/0n4ncO9NKkaaLyI4pzXk5BcZuFqiur7yoQNaCY34kDqsENnPVxIajvmUcT+mow0DeWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEUG2Sf4F/3LQDjC82Ne2l1gAYjH07MkHV8IcqBdHAs=;
 b=hubiXZJeydKDEVTLxSCc5uPELfGnmJd1/k+pSCGTqjrtM0fbGDu1MAFVMLTbbwb/oW//892hfPxAo2z50VNVh/eYJml765SZkVfXJty4svyRh+6zs97UMl3+BBghtzRzheoBGCbqhyMnEMKp6u3FncYJhHv/PLie/axD/hCh0Ukba9SUaoZ2VX2eN+rsP0iv7XMciJJ/wD/eOuydjSt24luckLUb2eDU4+mBecVYUDq4EsGF8TUDmMs/XNGHytSkNeGmmGZQTx4Y8CuM3fN2ZCdMuwtrq8l2RP0McDq3Tyh4uGDXmdLncvjl2z5Be+qM9FAEdmlvQP1GEWMLZfYICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEUG2Sf4F/3LQDjC82Ne2l1gAYjH07MkHV8IcqBdHAs=;
 b=cJDbleUmEBAddqSaDuLmLboX+Yl7cvlU5V1GsRLGQbKPCG2/51G/PR6TvMEB5ebqVtiivN5QL5ImL6+rA3aLfXetcLDD2rYoo8Ue5Dh1KHBuV3OAHjgOEKQQYUAMw9Y/i1AuYBIbi/edmRgbHMbOadse/+j8R3QHT/pRX5l5So4=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5224.namprd04.prod.outlook.com (20.178.50.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 08:17:18 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2387.025; Tue, 29 Oct 2019
 08:17:18 +0000
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
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
Thread-Topic: [PATCH] scsi: Fix scsi_get/set_resid() interface
Thread-Index: AQHVjX6FczFTAsffsEmaAwnX4owuoA==
Date:   Tue, 29 Oct 2019 08:17:18 +0000
Message-ID: <BYAPR04MB5816FF25422E60C168F78308E7610@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
 <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 17b65504-caf9-4aca-5833-08d75c486a50
x-ms-traffictypediagnostic: BYAPR04MB5224:
x-microsoft-antispam-prvs: <BYAPR04MB52245083FCF2297A131C500DE7610@BYAPR04MB5224.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(6246003)(33656002)(9686003)(3846002)(478600001)(476003)(486006)(2171002)(4326008)(86362001)(26005)(446003)(25786009)(71190400001)(71200400001)(6116002)(316002)(2906002)(256004)(2501003)(14454004)(7696005)(7736002)(229853002)(52536014)(74316002)(66066001)(76116006)(186003)(8936002)(6436002)(305945005)(99286004)(53546011)(6506007)(91956017)(110136005)(102836004)(81166006)(81156014)(76176011)(66946007)(5660300002)(8676002)(64756008)(2201001)(66446008)(55016002)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5224;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lsM5sOdnBekAxT35W6AWTCHmLtaRnCM8XSEICm1XH6S4aPdSv1YlPfsodya0ANa4tHmqTFAvHr4W2DzcVWSMDlNhcKsc+I6/12BWcLcfOsnLqliMLI/WlwAtCa2shEP4yun1Vz7bCQiz0gQIfQkqcTJZayId+sF5YV1YGF5Yzsu/1AryfWav/F7Nbyp0hmM3pIYaPaya6hfpoc9Y+CJzU8OFmyNiYFCOSIRyw7DChsHGopRox9XRzjrZEFk6PAgpiAu3ANir9u9MHLJp4ibe+vt5rLLaVYy5+J0lJ6SmtEp3C/lu5KcUHdoAeC5idrFdKUWehDBveERZJXEaJ2KlzSpGrGMVL7YR3sB7Sa37UC9TUe5J17dVbo2nCUSkuiSXCrvHetfEjAp8FHTLNBkBjZXJFRGCt4mSEflAk8cnca54sTaKPvkxMwslNAM75/re
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b65504-caf9-4aca-5833-08d75c486a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 08:17:18.5226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JKw0LHdGRcNehqRE7ftEGjKm1WZ7AO/6bSbVZIYOAEmB/Hjnd6XSButSabfpFm1+N2VFP7cAc/XF3M5tjQoPyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5224
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,=0A=
=0A=
On 2019/10/28 21:38, Bart Van Assche wrote:=0A=
> On 10/28/19 3:57 AM, Damien Le Moal wrote:=0A=
>> struct scsi_cmnd cmd->req.resid_len which is returned and set=0A=
>> respectively by the helper functions scsi_get_resid() and=0A=
>> scsi_set_resid() is an unsigned int. Reflect this fact in the interface=
=0A=
>> of these helper functions.=0A=
>> [ ... ]=0A=
>> -static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)=0A=
>> +static inline void scsi_set_resid(struct scsi_cmnd *cmd, unsigned int r=
esid)=0A=
>>   {=0A=
>>   	cmd->req.resid_len =3D resid;=0A=
>>   }=0A=
>>   =0A=
>> -static inline int scsi_get_resid(struct scsi_cmnd *cmd)=0A=
>> +static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)=0A=
>>   {=0A=
>>   	return cmd->req.resid_len;=0A=
>>   }=0A=
> =0A=
>  From the iSCSI RFC:=0A=
> =0A=
>     SCSI-Presented Data Transfer Length (SPDTL) is the term this document=
=0A=
>     uses (see Section 1.1 for definition) to represent the aggregate data=
=0A=
>     length that the target SCSI layer attempts to transfer using the=0A=
>     local iSCSI layer for a task.  Expected Data Transfer Length (EDTL)=
=0A=
>     is the iSCSI term that represents the length of data that the iSCSI=
=0A=
>     layer expects to transfer for a task.  EDTL is specified in the SCSI=
=0A=
>     Command PDU.=0A=
> =0A=
>     When SPDTL =3D EDTL for a task, the target iSCSI layer completes the=
=0A=
>     task with no residuals.  Whenever SPDTL differs from EDTL for a task,=
=0A=
>     that task is said to have a residual.=0A=
> =0A=
>     If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the=0A=
>     SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST=
=0A=
>     be set to the numerical value of (SPDTL - EDTL).=0A=
> =0A=
>     If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the=
=0A=
>     SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST=
=0A=
>     be set to the numerical value of (EDTL - SPDTL).=0A=
> =0A=
>     Note that the Overflow and Underflow scenarios are independent of=0A=
>     Data-In and Data-Out.  Either scenario is logically possible in=0A=
>     either direction of data transfer.=0A=
> =0A=
> If the residual is changed from signed into unsigned, how is a SCSI LLD =
=0A=
> expected to report the difference between residual overflow and residual =
=0A=
> underflow to the SCSI core?=0A=
=0A=
As mentioned in the commit message, cmd->req.resid_len where the resid=0A=
is stored is an unsigned int. And it has been an unsigned int forever as=0A=
far as I know.=0A=
=0A=
So I think changing the interface to unsigned int makes sense in that=0A=
context. Also, unless I am reading this wrong, the above definition you=0A=
quote always lead to resid >=3D 0, so I do not see what problem you are=0A=
worried about. Could you elaborate your concerns please ?=0A=
=0A=
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
