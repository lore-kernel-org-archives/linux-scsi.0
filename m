Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9FEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DE1206E2
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="REfdDJXw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aJn9WvH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgGHMPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:15:44 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39699 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbgGHMPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594210543; x=1625746543;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0OjtSRs7sWZpt6+z3ZySxVD8dK2AvCsDJ46hMtBnlok=;
  b=REfdDJXwTYInvu1ebpQs8jdZmYAlPtXWegA1c7O/tP80dJiKi4a4XhI3
   +WnWK4J19QzBfCgepVmXJR45jnBGzu50y/xiz7oZrCCHPjAk8TU43LUZz
   E8Om6WlAiVty7ENpHvvLJmGnr3eIApJPe5Bl9Goz1zHCfVrB1WyUbPv3A
   9ASW8Unv77a3oo3EglrYlDQ7b561ZhaG+GCOQm2ssX0QWME3typP6mV6z
   kbPTBuvH8o2nM18+GFWhx7pNNIGuHvB1p3zN+hSzwsC1TzCidrAvL520G
   a9GURRLgty9h7qR7d0OwIu9A6VnnJOzVUY3CJEJEiWZWuKv4xZ60EeFjw
   w==;
IronPort-SDR: VuHJ2bq+04rD9KPYSVAyn2jJ57iKGw8HiKwMUdoF7XBZ3ovafyj7wDbF7go+3eSx0FU8NxruSt
 C/JoEHxbWxjhritCMI/dgR+SxM8N6eRi+ntQ8BOYt+wsFR5A7ucv4Q/WOKE4YCkR0EOIDKKRus
 5ti7inD3GEHns/ORWwx8e4/81rSyqolnsQzawkkfdXWQ5ZdY2Js5lzYBDtSgEgVXAi1Topmdk9
 WHmcvYHT+JXIJWT6L/sAcdmAtou7UghaQkAOpbQfqLB7bW7roti4pWOxz/kIvbe+sUfsseUh5J
 3m8=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="146230393"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 20:15:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4sVfzGx5eu4AqluJP7zTCFrXbeBFAtTjA+SgssshNn0SMZkm1w5OJk6y62yleWDsGv/YVFg+b/zGqppLBTOqUWDeuOXgCQkGcwO5i+efYX0JOpNo+rokMYm5PTP1tACkrv3KTejBnbBN2lSJvbchkGoLazumK+O5lLbUWmuvQWJaBWrIx9nI0X6gXVgclbsSeyvDVJ7neBJSdulud2zpTcOH12zvlCUAGrne3cxa3c8NS4z8f3GoBWvfuLsfp8V87mZ+3pM1xaAI9eNm+5Lx5HMDla3wgKKrylMjHUKgOyzBoptFdrekbIkWm08T7/1HLCe1OIuAM4pO0+yy81uFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmYSxQI1WAjP0qOY73d9JsB2hlX45hRyKeGZoEQbFs4=;
 b=UJ0hMIh52mJFy6zT6ER+ODWeJ1PNh88crIVC5nVHm10MpnIg+Wvpfc/LFXpwjzfgB4ay/kmu4GyIUNMtb3j3ySNEDzCfC4boiYachGxdHUFpZ3M+Mk/VRAsH677FB7mIrSwWs9szXVMqfgyfoXZYYjlFSMsEtT+pMRSZeQSSSBIEthhgI0RGqcqZXwD0r9epGNr0gZOKzef6dfBBSe6Sqs34pYboYTmfA2QXa9mgkEgFTB+BuIWgsX8TbUQiCwxWooEqS8vIfUTNJ06HhzODON5PfgyrEJW02DOe8PUdSHCvn/o90GkDcUCOxfztnP2EOcME5nECfKTh3Db/J2DxIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmYSxQI1WAjP0qOY73d9JsB2hlX45hRyKeGZoEQbFs4=;
 b=aJn9WvH0eZkFiz0Xq7ACyqD3Yymlzd2Sc/fviGpVl3O4ULyXx3yFADc5h4rJmreDVYgBK4d+Rvg9c9ekNE0A1cXTdbU9t3OWCWYWCefv7E6PSOAQmj82crBJitDdcl2uxkORHdf2b1ZOA0e3VfoK285S6R8ZdNar5XEgdqhWTTc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3888.namprd04.prod.outlook.com
 (2603:10b6:805:50::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Wed, 8 Jul
 2020 12:15:38 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.031; Wed, 8 Jul 2020
 12:15:38 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/30] scsi: libfc: fc_rport: Fix a couple of
 misdocumented function parameters
Thread-Topic: [PATCH 11/30] scsi: libfc: fc_rport: Fix a couple of
 misdocumented function parameters
Thread-Index: AQHWVR/zyxPFHsr+v0q4Wm7/HgybCw==
Date:   Wed, 8 Jul 2020 12:15:38 +0000
Message-ID: <SN4PR0401MB3598867C90BF92465D26F1449B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-12-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01f7a307-40c3-4301-1394-08d82338a044
x-ms-traffictypediagnostic: SN6PR04MB3888:
x-microsoft-antispam-prvs: <SN6PR04MB3888775E446FB07A8143D4899B670@SN6PR04MB3888.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjMDaS8kRkdmcoDKxBuYKVWys25IuEh4YdmVz1C7RLATS1fyV38KrYW8opRHNWt14MliJkxYckPP4b6nNNbB1XwxraX2plbABZKVvTzUkhDHTJbKbtgxMO/m5eiXVwvZ4E9TAQDK4MxY4nOJ2tVq8tLgtiDB/PnLDVHYEoNE1ARjoE5ZndIUZXdjIGhyHDVrF4raBqL1s5Pl5ZWLfYwLwKj1SBtV1npFEVVZMaey9ithRf8/nSTxTB76HhqNzmUNd3qIvVFXNSFPCbfqaxM3tYhF/an4xCGC+PA9l57paD8j9jTTc/PUkipuOKev0dqls019A21f4Vi5EEVpS6dZpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(66946007)(91956017)(76116006)(64756008)(478600001)(66476007)(66446008)(66556008)(53546011)(186003)(7696005)(6506007)(55016002)(52536014)(2906002)(9686003)(26005)(4326008)(5660300002)(71200400001)(86362001)(8936002)(316002)(8676002)(33656002)(4744005)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jMn/N33UW7ism9A3EwmFn9DCUiqyuYM3FwEuUevnkvzkdp5BbKEMbeoa4lbU4GBlTzcsetE1MPaJ/2IsbEEkCVjeGRjpZSje5dweJpY5/6gaNYRPYNrRP7Ob/P0mx9TtrbKVIn608jY5IodwJ0fLR7fyDgv26OKLE8RWFzJXK38AiTby/Q3ExA3Q1L1VDlTbD0oiRGauzbZelGWHiOZPSaMYo5yz4u+afzD/byB+wtm776aqRg4zTZ266OFRvEaaTFuX5jmLjzjkGoJ4P7BQdMWUqHGznyy62q3fMJswBEAoFtuNmsXFDrn81JrTWQ1IQeR6ZOmFXZGXxBW1FEWZSDDSUWAXau7ObJPaluHaKAy2rbXexXMzVft2maF0pq7OAcfyyADWdgOPfLosKKUoBIChwm49LEOAr10nIkNGFcGAvGEILf4BNzlmj+ssnimmsEnuKHVrF0ESwcUKCP73XrtMulo3IMFTQq5UVSLG3h+o5YotQ0EIFW/lBfwoSXXD
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f7a307-40c3-4301-1394-08d82338a044
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 12:15:38.5778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvk8bsBUOt+qfUywOSGQs9Dg2fUaGIYl/FSDZbPyid+jQg2t1oaqEhDAnuH/voM6WXyuscHL/cKCJrVh/7vZPaUP/33Mo4VneGOsBttFMOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3888
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/07/2020 14:04, Lee Jones wrote:=0A=
> @@ -1445,7 +1445,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_p=
riv *rdata,=0A=
>   * fc_rport_logo_resp() - Handler for logout (LOGO) responses=0A=
>   * @sp:	       The sequence the LOGO was on=0A=
>   * @fp:	       The LOGO response frame=0A=
> - * @lport_arg: The local port=0A=
> + * @rport_arg: The local port=0A=
>   */=0A=
>  static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,=
=0A=
>  			       void *rdata_arg)=0A=
=0A=
That doesn't look correct, s/rport_arg/rdata_arg/ and an rport is a remote =
port not a local port.=0A=
