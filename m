Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E9CC47E49
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 07:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1605F21783
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 07:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jBh/MHev";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FUhpg6oU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733000AbfJ1HzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 03:55:01 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39073 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731133AbfJ1HzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 03:55:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572249301; x=1603785301;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xg3rEGJ+EYELZpQFLwSVe7679+oPhPBrmV5fAjYXncU=;
  b=jBh/MHevivf/+6eYVVdW+9PWvflDMrlCJOlpajuZQve/t11vVbtPJNZe
   tPLFpCEGIoyfDLHz/Arw9aHH+4SAaFl6LvRy+2x30wATjUANiurIpX9XN
   BxA5sbLCpq5qF65EX7+Txqt4oyXN/Xmz2gUFIrDnKKWNkrgHEmnOTkNyS
   gVM7l/erplidDt8vnVJo16D3K5+T2cDzp6l7KxeZJFwkro7GajygJzabx
   0aRyONW0Um3jSNV2QkK/AN0i2M9YryMXxIc04WvZr7oXcQUUUwI9p4BiD
   JhOUy+6f7xDTTNDUcZrraM27NkDrn0VamqdjfO9isOfi8H+TPOeTZr4W8
   g==;
IronPort-SDR: IOotOmiiiKzZcfhrmAvlZKu+10WzLfJErl9quaY8zqLkJTwIrvzjJhMBj3q96DCNynzISuMPre
 lo1sZ8ZucXb6IYFHFa+yhkoU0lV/7raucJdtARGEnJc/mseqlA9KZabNQuwsEDGWle0I1xlO1Z
 hPvhVl7PAVUUqubpT7JnZUFkWSK77fAr8KsVsEisGjw26f6XZV8GGz9xBOc/1Swk2+dZxSTjTH
 l/rrKm6SabGSpFUrZ3kuT9xyEZ++ftbsLK760Dikl1d9d337G/F5KDsJwgd6SLpIDGfnbSZyTE
 JkA=
X-IronPort-AV: E=Sophos;i="5.68,239,1569254400"; 
   d="scan'208";a="125883062"
Received: from mail-sn1nam01lp2052.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.52])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2019 15:55:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBWytp1zzYlgLWp1HaMdaCPh0H9XCnzdfeYZ55ZKdQG5u5H8hvyLVaTL5GxDp7UqLhAMtQaUUnHS7QVZsrffrvWAF3x/jtBpaDuTelSb+mlPpqXaCmwDtBAvvnbAd2BH43OyC21BlsBfZYvKePpCgIahoUfijjkhrAjalvylsdFR9RxrvtMwL5NQAwtcSpVVdoI8MR4OZpipmpmbdeu6rKbjNNPELjGwHXGUCPZzamEAkJsCtJsyzyT/MoEpCcYP5bewZ2d5dHU1vImjqvkVw8ZV8EUNg7xl0tlcYP/1V8G7cEgwNNL/N7VP1ibsJiiq6/asmobPFwQrgyHGwl9OWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xg3rEGJ+EYELZpQFLwSVe7679+oPhPBrmV5fAjYXncU=;
 b=f/zNG3Ma8O4JYE+ugfJGeOGztf3fSVEQASJ5C4zzdrFKXZo2/tMgvx00IKrlFkMEzYqw7WljgJAAxtqqnfHCLPRV27V2XGv3ZCRztGxF/Jpk/58K1H44orZYp/f1pyDOTFTX++k8XOFgVci6K9YBN3+65xbm/28WqQ49MvVA4oKsNvXapG9T7z1ODdAu4gIn/3xZki4gZ2iIjfP3bPXqIuiG3X7ZDgWfYEqNzI81XHFCgHv+q+xjG6GdCZj4XNqCpSho+anB+jSuXtSBtBsXF0PnNmYkq9IWEfggSXTZ22CnqwZHGrShXUx3eOdcXZ0lOzHWGd2QStYiyb+RE2LWUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xg3rEGJ+EYELZpQFLwSVe7679+oPhPBrmV5fAjYXncU=;
 b=FUhpg6oUEJ/IyUQMJWSNBxHpMccpHSCMbYyPm6/OQYS4PaJK0vivxWp6OlRmI1/A/lb6FtzjqNkTlXIYkLFlAYCKd0XDl4zb2WLV2PCwLR3f+cABe6vjH8IKd4d1hyj91TWRym7OYE/wTN97LWdYUpIONm1OvfZ7Mo+oiiuZqI8=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5671.namprd04.prod.outlook.com (20.179.58.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 07:54:58 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 07:54:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     Ajay Joshi <Ajay.Joshi@wdc.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Thread-Topic: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Thread-Index: AQHVjM+qyQ9jYQA2rkqW8qZgt9NDUw==
Date:   Mon, 28 Oct 2019 07:54:58 +0000
Message-ID: <BYAPR04MB58160668CEB54919B22AC2FBE7660@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-3-damien.lemoal@wdc.com>
 <BYAPR04MB5749C25A8558C0ED9AB3EA6786660@BYAPR04MB5749.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [91.217.168.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c61a2b99-f81b-481a-5094-08d75b7c20fb
x-ms-traffictypediagnostic: BYAPR04MB5671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5671B45DD221A8B9D3184CFAE7660@BYAPR04MB5671.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(199004)(189003)(14444005)(256004)(25786009)(33656002)(8676002)(7696005)(86362001)(476003)(229853002)(2906002)(6436002)(486006)(66066001)(66946007)(305945005)(102836004)(71200400001)(186003)(81156014)(81166006)(71190400001)(7736002)(76176011)(2501003)(6506007)(74316002)(99286004)(53546011)(8936002)(110136005)(446003)(316002)(66556008)(64756008)(66446008)(66476007)(5660300002)(26005)(478600001)(55016002)(54906003)(4744005)(91956017)(76116006)(9686003)(3846002)(6116002)(4326008)(52536014)(6246003)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5671;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 63uhsBDpCP9gDxYvCjYXc9+Cnm0OejHqk74TlkVAGAmdWzd3iL0toD2mJmkwwUXiYB4LD0n/1GsTBhB9qI22FpE5C6paHt+HMw/kTo/UtqhQan0R8hQm3FaC1FzKzlogXJAYsfpfeGngqs1PY9tBmu5D0NwiweXejiwTW1xTpbLjraL9ugqFaTyiatFSC9xo+1MnkcynLu2EGysVHX3A7IQcFRe0ngpgIPvJyMMk8QFpoE6m2r1wzc5nfnt71e1ZjJlrpBexsgHVBn1/GnOmNYf4PKl/Pbz8VS5ISgkGP5T5q3j1ACtov811aUyYGBxY9+UnPLtAoP1WRKEXkpxCFGS90s9O0Potmbs6X065B0WYJtEfGhSbr9PybKkQOxVHDwZnEp3QtKdhFcn/NbQdtxvI6YrN0Jqg42yXQL548dV1Yv0mqhb3jDkJmXLB2/Po
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c61a2b99-f81b-481a-5094-08d75b7c20fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 07:54:58.1758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIRfo35TkisZoU4QjW36MYARXL+7l933TB/Ai/TP3+LqwHLe15IH3IUigRizIUV7zJJlfAR3UvYMoFbAX1DOmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5671
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/10/28 8:49, Chaitanya Kulkarni wrote:=0A=
> The reason code for REQ_OP_RESET_ALL is kept in a different function so=
=0A=
> we can clearly differentiate between REQ_OP_RESET and REQ_OP_RESET_ALL=0A=
> when we add new tracepoints with blktrace framework.=0A=
=0A=
Isn't the trace point under submit_bio() in=0A=
generic_make_request_checks() ? So removing the function is not a=0A=
problem for tracing as far as I can tell. Am I missing something ?=0A=
=0A=
> =0A=
> But if that is acceptable, then,=0A=
> =0A=
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> =0A=
> On 10/27/19 7:06 AM, Damien Le Moal wrote:=0A=
>> There is no need for the function __blkdev_reset_all_zones() as=0A=
>> REQ_OP_ZONE_RESET_ALL can be handled directly in blkdev_reset_zones()=0A=
>> bio loop with an early break from the loop. This patch removes this=0A=
>> function and modifies blkdev_reset_zones(), simplifying the code.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal<damien.lemoal@wdc.com>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
