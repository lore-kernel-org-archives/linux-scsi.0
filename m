Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C5AFC6195
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 18:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A34021D7B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 18:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IbeitPbT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PiMgTMIc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKHSuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 13:50:25 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53151 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfKHSuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 13:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573239025; x=1604775025;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MMT8oK6f80z3AxJMhfh17WJXlM/067bjRtHO3CL6iBc=;
  b=IbeitPbTh2xjhsGdKcVq0dq6nny5a0Nx40Clih1mYZxku+S+DJvypVh8
   Uw9gi/HkSwz/sdqglzsRr1YgoTRgyCKj8QutKlMGoRstr2Q5yViwyjsLX
   PBfnYTH65c3qxXsMMyAO6fzC5qZzuEHReJM1qsxZXmZheBXzvt7z2/w8x
   0oCnQX7O9spXtSZaHrHiiD0/UujGoqu22q4wj2qgDf7wf4+36unxjiIzQ
   T1xi3s7csgQ/7ekjDAtWbO7PCn/tWPKX1kppvuoMOkRoamvCYILGdu157
   FR8Vq8C/dRi5h3jNRkCgWaGeZFTWAAgoZo0eNd44N6eTc/2GVoEfcpbSn
   w==;
IronPort-SDR: OxAJnPtem5ArCNNmgAVdLDOppM+BK5Tb9NnJsuKeGM8R5R4Y3a0T7nCp6T54Md7PGlVNLpLk1t
 lcKJJRshIyytgz+REu0JZ3KU+HneXrpzBAiWc2xz/nLrT29p4Ym7r+W6uyNwiIQfX7bzm1TiIA
 NitoxPqaHsDdEoVA4/ITi+aaYiwrakwCDBc4fKLjAJU9quLVe8HT8ddxmikm3G+0g7yc1ZIOi9
 Rr3h4CVapQ46nbsCazkoO+ZQkXu4IP0uXXjK+M1Gdrsbo5I/xt/AcotqSbuHxsOLSF74BPhRqT
 E3E=
X-IronPort-AV: E=Sophos;i="5.68,282,1569254400"; 
   d="scan'208";a="126961447"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2019 02:50:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTwE3aFfP+gppccZDMRR5XzZv22htUxNJz/XkZUPK5OIPPiQHZ54RK0QdlCDtEtD9BlRO8XWWyq7JXI/3gzAEGRQorRqkUkzaYNH8MgKMB2rJ0gP+YQtM2FOOPoISGawIOzSe/hN4n7F/z4OQgGcdGGeLLiIHPX8bBzC23IyZ1IjrsIipDlARP8Unk56ZB6fhAfk9bdrnJsDa12ZyKVXJSUojUjVviGcJmWb07OhXHfPomsLkmUwJqchRkitj+8UeUvokRq6iby+823kkfSyKNlY+9iR0QA/mzFCt4k2YjetoLL0JCE+vG/xT5qpBYLK+LqOF+i6eWljwYtU3BLl9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9878wIrxKKWXUHm58f2RklIM4TRXT/ZEmsge8xZ00g=;
 b=e5R0MIzkHJBLqmf88IlUk+zgUHnAP9yqDNl2vQ0mqew2drMUX0oB1bnTyUlJcfKcq9mOoPk6V2RUwKZJjJmJdZkXVwKDRIqV5DaecomoL1zW9ZrfXt9kG8WgYoucRnaZaFG6IjKMLtsV052HKunBFB1Jbb+9dGbeFACHovQ/Y5Y7+33+w6Pd21pRuwZvgnfZ4oi99I995LMOAjVNG7w8SV0CduobcxzIllcWnIbvJ0FyK31B5N+604L8pHduTRO+BBxaF+T46SaBkcut0WJePIWwrlaMeksCRH4ZQGrOhORdkHdkDW1p2Yq6pPI2wyLolmifD7ke/zbHlkLkosfutQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9878wIrxKKWXUHm58f2RklIM4TRXT/ZEmsge8xZ00g=;
 b=PiMgTMIcDaV701I0ppo+y45FHF2nKsIl//72iIvXcJrxmASimMWSf1v5forjDhnZfZ5ABUPy3jxL3CVktnIqFUAm4TjCkOM9WQvik0UQvx3hoMcV/Sjv3MtIli/+fiAHB1yu/bWsN488kZRdyLhSgqViUIrqxYGHwKMruJoBME4=
Received: from DM6PR04MB5754.namprd04.prod.outlook.com (20.179.52.22) by
 DM6PR04MB4042.namprd04.prod.outlook.com (20.176.87.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Fri, 8 Nov 2019 18:50:22 +0000
Received: from DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::65c4:52fd:1454:4b04]) by DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::65c4:52fd:1454:4b04%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:50:22 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 2/9] block: cleanup the !zoned case in
 blk_revalidate_disk_zones
Thread-Topic: [PATCH 2/9] block: cleanup the !zoned case in
 blk_revalidate_disk_zones
Thread-Index: AQHVldfc9s3RcjAaAUWO67LxGbcSfg==
Date:   Fri, 8 Nov 2019 18:50:22 +0000
Message-ID: <DM6PR04MB5754E84538F2E0AC9C3FD797867B0@DM6PR04MB5754.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-3-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 335b990a-eac9-4400-7934-08d7647c8272
x-ms-traffictypediagnostic: DM6PR04MB4042:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB4042D948C540A667C897611B867B0@DM6PR04MB4042.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(81156014)(229853002)(99286004)(14454004)(66946007)(6246003)(86362001)(102836004)(4744005)(8936002)(305945005)(14444005)(486006)(76176011)(5660300002)(66446008)(7736002)(446003)(74316002)(81166006)(478600001)(66476007)(66556008)(64756008)(33656002)(9686003)(55016002)(186003)(52536014)(6436002)(476003)(110136005)(26005)(91956017)(2501003)(25786009)(316002)(256004)(7696005)(71200400001)(3846002)(6116002)(53546011)(6506007)(71190400001)(66066001)(76116006)(2906002)(8676002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB4042;H:DM6PR04MB5754.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VefVcdWrIleAOQ3p2ujBxXhf7nDGY/mWMgl1miqXRiNkPRH/3yNKUPdqBrZFONYt2zIPOgHuCsVfE5pxxb2sVFF5Ewp+7y8iwrHpzK0PBYNJYgQDhIZ0FXBPkehb4cH6bilx+s1CW71yZaHnralPe0ae492BqAzF2Y4AN49KZfLoxihP/+wru6mDrQMu1fcNpw5irXx0ipAn9QY2EXq5I4KtuBJoz0bo2Jls57xHv+EC6JdIf41VZDDycWPN0DhpeyDDC25jwpiaLdIzAqji3Akh7s1UaQzz+Wn0Y2iliNxSrtkR3bjF7JZ6cR5zY3MZlKLBMeVzYbkWfeX9WKyUGh8IvzL2yVz5jp9EQnY2D3EkULohxfqgpWmx8zGA8MMZNUbmgTxI/hifHw25Oba4iFGkLEdjkRiRtkYdpMKWmo4zvZgW/1vgReWpGBFmjY6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335b990a-eac9-4400-7934-08d7647c8272
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:50:22.1658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/mqLsfKPN3fR+TDy77ZwhjMImDOwK/kri/RvC4q0GO80xZhwyDiqmL1NWs7qnBqBzYH6yUBd8F/q1coVcm/pTrSxdRZINhHJecRK7nqAHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
On 11/07/2019 05:57 PM, Damien Le Moal wrote:=0A=
> From: Christoph Hellwig<hch@lst.de>=0A=
>=0A=
> blk_revalidate_disk_zones is never called for non-zoned devices.  Just=0A=
> return early and warn instead of trying to handle this case.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig<hch@lst.de>=0A=
> Signed-off-by: Damien Le Moal<damien.lemoal@wdc.com>=0A=
> ---=0A=
=0A=
