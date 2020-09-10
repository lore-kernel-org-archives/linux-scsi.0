Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBB3C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E16520872
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F2wuvwZN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rrZFMvqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgIJIGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 04:06:06 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:55498 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgIJIFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 04:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599725147; x=1631261147;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=F2wuvwZNoKigxpir70m5jsWkh4XfYpicwtnc/GI5ul75w/bCHcjndZut
   qlJ89PfKosFZTNWtzfv14UGqE5vloWrs+j7Mz0asTJhkTHt4Ss/hSOXgF
   rvMHEenQm/ya9mvZqwOW7y1rvmSpor9Ln/NbjQ077k31jbX0K92n6ZOED
   J8RhqKQJwTlBbzqCaj6zyqJrg8M6Bme7eVQI4yvNW3QRUNdRb9Aed/Jlh
   NPjC9sEzKuDgHyW4fG0GgQOivyZbiNLriLQ2vLI1Y7WXnpyjYUSaJDWMx
   lznWdgZkxtYqgL69X/HeTeyYltX31AsINm5/fhlcHfG6KoNuo16xqJmFh
   g==;
IronPort-SDR: i9AnnAPzJl8XXYea0Avwtp4rHfRy4Rs0rMbDFSpw1i8sR+YQuAecGaqoo9VmO0ST/t+GvhBrlq
 jBK0nU1dFQhPixPQBw8FkHvYXdqmiwmHj71ErWz9etebBNoxbI0GfdFXaid0uT9qztLkzSQzI9
 TUMRHHF6QmrVdckRtiX2lqFgmrtE/BqCllO+M0WtdbQpkEg8YRpougVpI6wuHgZNAe2KzVSrtj
 IeXOKQI+fhOLFr/kC3+yqW/eMLmK018oyvqbPf/lrfKURtGhWoSI6VuxIysCmpucwENZ1vq0ft
 4S8=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="151365201"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 16:05:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlbMEOz2yVS8dpHynHZol9pznAdvjYaKlJFU9CovAS6M7y9tPlrCn2yp5VjD7nmLXeTPYsd/dIEyaJ292qC/yyq/eH61o/0lgiHn7zWX2zsBSLRv/9TlzPSUsV9KtKeE6TRjubPFBjdwJhNHIV72etChsQLSPqQ7tZO4hxiVVTDtbY2ol3hcuiBMyg++j3/aHRvpLxVPADtI7H8Iz9eGONMxNHcb21YowIacE00Z/ya7l+uQAHbcKCcGqTL5Vy4o1nb+R1vspkIyhqlgkPchzhgLMMHlGlIIfjvZK5ZO82xN7aA9CQDGP/pIWbTUF9uuLVMeooeRXJ9L+kwFPb9Egg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Gjja9pAbsu38DEXjjkmvNr8pV/ecuPa6GFmFVOMMNQurAOw58lPrwQVNHAgj90ATh/ghagwO4wPxQ6zGGx3kxNkXF1wSUK3pcF/0M3dQKhG4Hr1oxrN97ANWXArDZFqjSs8Yhjirgvznp230oDWMO7L33fjGr9SpaYmHjqgONGyjC54A3kEBPjNTbELtwWlSWQzN9fEYGNcoIyWWg6mrX4XGEKIdBfnI34IEyv0dpTxXJ9+NjYzf5rjcNrzr4w3G/RFY0p96s6cy+jXrC48E21p745Z84trq49CK7WZNg0jYXzcBtn+LGd69CNXBAJ1wBWa2EVMkCSw0Fr/WIBg1cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=rrZFMvqY0NzQTmrC1uGijhik8JZmbeQIhR3XpP6E9SW1QhPL+/l5MlyA/XKJ/fzeKOzjzcr7JHqPGWIh+8I1ifD8udRhx037u3XO2wxfE9ELw2xBmXYtUxI8mhFkqts11Ry9kpRb8WJGefBV1L0Trl5e6HDYP6LIEaZROANx7gA=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5119.namprd04.prod.outlook.com
 (2603:10b6:805:9f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 08:05:41 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 08:05:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi: Cleanup scsi_noretry_cmd()
Thread-Topic: [PATCH v2 1/3] scsi: Cleanup scsi_noretry_cmd()
Thread-Index: AQHWh0bcipm5Si0CG0uB7iSJTl2kcw==
Date:   Thu, 10 Sep 2020 08:05:41 +0000
Message-ID: <SN4PR0401MB35989A6BDFF7839F168015D09B270@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
 <20200910074843.217661-2-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:142d:5701:2cf6:d0e8:5d46:4118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 890c9495-3cad-4b12-8ec9-08d855604f8e
x-ms-traffictypediagnostic: SN6PR04MB5119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5119DE2DB20AC61F291B60279B270@SN6PR04MB5119.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fL9VMlCPcnG3ydMBi/6TUpKbUD/V/1AzDog3vwBan0f8FdKMksTa1tGX2iEUAbStmcjfoGpHW3I54ecftQekPebFfkF+m/h7x4ps3dPO7sH/4rMKmIWOwu8I427KiRQbmzSJwxskj8M0hyVX/qx0T/l4Db70v1ktdRNawev/RmKEAdnEJK7o8VC4k1w5bsnOfMigEbFqxPgJliAvWTydb0R1QgrhDKHLHm0l9QGPxWyJ/j116Ii/6wKHvi/t6fDPUMTg8kJ4ltmrIWa7WU+jmuLfGamaJSB9O8XQv5aInNilUTHqAegnaYE7Xj4FYvp3Nd2sUyWuuysgyVOb1CiDSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(316002)(52536014)(7696005)(8936002)(19618925003)(186003)(2906002)(478600001)(33656002)(66556008)(55016002)(110136005)(9686003)(66446008)(64756008)(558084003)(86362001)(66946007)(8676002)(76116006)(6506007)(66476007)(5660300002)(71200400001)(91956017)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: k3R/c0b8xcp1khZPu6kkzlEHjLl5/Z/zpfav/ChukH14snrvdFZnpBJXdNDG+xzVKeyoOHyVSzBtMQtz8WFgL8JxtCs8s2ZiO4e2BEhTtl5ytDfGqwP3HADKMMnrWXVCemzPylxzY3rEn+noFxmMZwhTqZnN5mXO9ljT74cgHQkgGDFx1luOiaNfduP31CMCHzYA/pY08hbt17kTOuEJSrWeF7ef7ZRLRkd+rQkxn9jE6LwLWQMmvBeKf/PQspbRXnlpYiujBSYHIZWHxQzkeS8IhxLcsx2LAX+9Ud1wp7ppXszze3R/Ag102QiwNXRVSrDzP4RU3kyZ9+BmPpiSjSfq0NnBzRQTSoKcKapCVQy1Z27rHFMOJtC5/WqX5HThweSNLe9BquX6b88gAfpwS9YNoIYeCJq7EDCgxPZzUPxlp5zcDzVP6tx6vlBxE1XYMIrOGwqzw/6WngnjClUf58LNls63z3YqTaY57zV4B05/6Rmb7AtxhOwiPYLunfwzfrGD2TW6j7qu80mK3yGP7IHS90Y+Q5XMRaef+iQhBku3fW+wXLDw/1UylaBo7wuDLq8Uh4VcPIyBgnL+aKUDakaxmYVQXNcg5Z1TgfBG69hLytInjc0JPZXgrFZzDigaiB1/Dxq+Sra6mLUIUu9+eaAoFa55x6WF3D5wz4Y5zITS1+lPxac3NE6Sszn80yGkndCyxcPlPeA57rSS1Gzz1g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 890c9495-3cad-4b12-8ec9-08d855604f8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 08:05:41.1749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMgApvmh3KW3e/WC5lo7wA34SF7gKKMAAB+z5AK0QIZ48btdZgqra9GWIVBSeW+LWYvlWuF/h7vgaYBnJadsQcun49SfqaeWnHjWlkX3Sws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
