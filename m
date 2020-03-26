Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACD9C2D0E7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 08:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A662078E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 08:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hTfAo8vp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OtffeYud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCZIXh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 04:23:37 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:54394 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbgCZIXg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 04:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585211016; x=1616747016;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=fHzkdRvUPdgeDw8eClwoMGLbeIxlhydHT//J8MZCEhQ=;
  b=hTfAo8vpl99SAarFwTr+3IN3Rq1hroCq6N51wmcEW80lS/1nXoZ3+L8n
   ok/IPlGTFKH4Hw1Sa46XANU06cr/l3Bt6WBKYNJzsneuZfiWS4d/YLtJK
   VUxGmqG9EEBv4lqK9SCrE4M7e+0KGhoO1Mzy4JDZQdAVSdnTDt0HQHxM/
   Rs11m3vsmX9/6lYs384nSt9eZIMqpUGjuZQQpdirXYQQBPoC+vphr46qd
   soNSIPbqpFmUZHQOTSZhwt5AoFe8+pPwPut9ZP0OFBeFOcyNvtxzgJvCV
   x5llrkXiXiFqQTkBpTF6ngunnYHP+aFtT2uy2y03LAaABeJfixYN9mVKt
   Q==;
IronPort-SDR: 8vladnJIL2LXHyKYIzIO5OP8KAoZmSJnhoiHQ1ngNakfirbd5GyWxaAooGi7HXEe9Btbaj6k0K
 V/dYrNwV61HzggMKGHO+ZTSw2awSuwnZS+H8WPqJhKIY33WcCUX4OW5/MWgd1Zq1sfjEvA9Xvl
 OSfMMxgkZ3ihJZLALFtAZ56SDxyaCCVsweRb6H0q/W3gxoJBL2x4SbtBXEsXDQfExgEx/F3BbS
 pQ+Kra82z4Ht+qEX86LUdba+2KAmuqFckT9UvOe3WtDK0ZQQcT4qYMv2wYckBnGhGVKMPFujx1
 65U=
X-IronPort-AV: E=Sophos;i="5.72,307,1580745600"; 
   d="scan'208";a="137935681"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 26 Mar 2020 16:23:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hw7TGHR6QnPwwkJWtXN83IyTUL9HpiFye4iRF3TDrY0PzCFjwjIDrXQcpEkdsTdLs06xui9ZdWP9D5BTHY2xFIjqaFio/sDM7hnboh0pEskVRK561rShYz1wDJMCXYudzMAR2YZG6PKcKofpc82zQS3QvJIsiEhJ24cTZdteidpgkbf0l371fAyZ2WSaC1fm2Da5AwoHTplOgnOHOWv/MZwDeHTXGuadi6a7GYe0fivdZGNIV34I9nyimFvz2UGTWB2sTmr/9ApELWLMCCsX/F8NIb5wbzU71TEoWyJ9r7CLmY5aPATGcvXHCRizhvNYh4iCchIdU/iuwYzkmIdtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ta6L/uUg9ySgz/rPHxWAi27CKENKaSbN7NfDZ8f6rng=;
 b=I8Dq7GvG+xfdsdVrAmcQLttOZx6SH0ZZDww3fUCtk6Si0WP5PMekuLn3NIyl6CUv2pTsVFg/8HlooAOjvmKGwsCBx10HwI1tKqSLiREo/WUqrUAp70WJRboVyGUWqgQ7WLhfARfbayYzL0iCqtYj4Q+I5X0hCHKrpLeiGu3S6dj3b4uv2s1JKKZoQFVW2VOj27zdmTkQGU9eJXMtB2DykCgS7ag0mRJcy1jgJXbh1Z/u/hZbDLZhqQP3E0u08ma0Ce2D5A2I4keWEyQqyInjpUi+hEjPp7+5jLjVdXYIca6tUb/8Y435FPbiQZqMVsKnLJ3nrA1BqmTuLYNKMLqWNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ta6L/uUg9ySgz/rPHxWAi27CKENKaSbN7NfDZ8f6rng=;
 b=OtffeYudG18LtnMygPVls74i920MECpeZlV2aoHLiVm6RV2Mo8jVZGwdG/c4+tEyIIDtUkNj15ERgB0GhC9+NofskEoAD/PbvmZBu4q7O+8WVdsFOjZlU/F9KrWqYf4NJ/lO7zHUrTfnoZ7cUXdl+1VKGmIfBcZ1D3tcKNdezw0=
Received: from CO2PR04MB2343.namprd04.prod.outlook.com (2603:10b6:102:12::9)
 by CO2PR04MB2294.namprd04.prod.outlook.com (2603:10b6:102:e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 26 Mar
 2020 08:23:34 +0000
Received: from CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b]) by CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 08:23:34 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: all zones zone management operations
Thread-Topic: [PATCH] block: all zones zone management operations
Thread-Index: AQHWAydCbik6RfBk9kK4q1a4/Owqqw==
Date:   Thu, 26 Mar 2020 08:23:34 +0000
Message-ID: <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200326043012.600187-1-damien.lemoal@wdc.com>
 <20200326072800.GA21082@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 68386f5e-b7ee-4a06-fdd9-08d7d15ef9b6
x-ms-traffictypediagnostic: CO2PR04MB2294:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CO2PR04MB22946BF1D412B0A35B150E67E7CF0@CO2PR04MB2294.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(7696005)(53546011)(9686003)(6506007)(54906003)(66946007)(66446008)(66476007)(76116006)(2906002)(91956017)(64756008)(66556008)(52536014)(5660300002)(4326008)(6916009)(81166006)(55016002)(316002)(33656002)(81156014)(71200400001)(26005)(478600001)(8676002)(186003)(86362001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR04MB2294;H:CO2PR04MB2343.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XnfXwwTkfBijsI57M8P/LKc/fo/y3xUG2Z0XV+PE+pC0XnbifVtKjhd7+HcN/6yPbOKSotQIzs+md8Jit3jOcLFb5HJ8GJA3SSu5529wJK6K0TXLhQcAtmQmJJqax6mnS/68ZEd8uTvA3cV5rnZ5o4K+A3Xv/ol0oLyOW/l1ankYMr76FT5WHcAiwGfmE/1PHnYalMSCqEJANVNheQ+B2qCLDQjp4PsJwweC++zGeu44uGcRJN8AEXW0/YF7tCv/3uVQgoL/meZBZ86uMTN5nBorwqnArGUIpBmt+4xcHUyaKwDC4K9sDd+v/PvncGh38I0vqcCFrVSdNhDGZAOvvi0LoBsU9xNMAx+1ixqBQiGelNPMr59e2USj7pkbM22YUyMOP6ihkfJYLBpyslNCjS2MpH7a+h8AsvKLMU7IZblRlzg+IQrMpi9ufkit2UfI
x-ms-exchange-antispam-messagedata: 8QGOEhYeIyf+Om5JKV4Z5uf1YyowXJG+V69ysnNOXpnk1hCZiU/gGNmbX50rdJgwtJuRK74efr2IHIQxXytEBdqhrdiW/Lo37xQznXEnWdYAiTRm7xij/HYiau+2i5Vayi1py1uG1UfskgJxH8N0Sg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68386f5e-b7ee-4a06-fdd9-08d7d15ef9b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 08:23:34.1945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KglXpvuLvqNtif28kQVNVSs3vC7YC6fsw9f9Z5azw2RcqZ7+dFy4BEqEnf0YRNllpCLxx33rUS+FefCTJgKANQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2294
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/26 16:28, Christoph Hellwig wrote:=0A=
> On Thu, Mar 26, 2020 at 01:30:12PM +0900, Damien Le Moal wrote:=0A=
>> Similarly to the zone write pointer reset operation (REQ_OP_ZONE_RESET),=
=0A=
>> the zone open, close and finish operations can operate on all zones of a=
=0A=
>> ZBC or ZAC SMR disk by setting the all bit of the command. Compared to a=
=0A=
>> loop issuing a request for every zone of the device, the device based=0A=
>> processing of an all zone operation is several orders of magnitude=0A=
>> faster.=0A=
> =0A=
> What is the point?  None of these actually seem like remotely useful=0A=
> operations.  Why would I ever want to open or finish all zones?=0A=
> =0A=
=0A=
Open & Close all zones are indeed not super useful, at least on SMR drives.=
 But=0A=
finishing all zones does have some benefit, namely the ability to quickly c=
hange=0A=
all incompletely written zones into "read-only" full zones. For drives with=
 low=0A=
zone resources (open or active zones), this can be useful to recover zone=
=0A=
resources. Again, not so much on SMR drives, but this could come in handy f=
or=0A=
ZNS drives with low zone resources (max open zones etc).=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
