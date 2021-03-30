Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB133C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 23:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E4B619D1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 23:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhC3Xho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 19:37:44 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59038 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbhC3Xhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 19:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617147451; x=1648683451;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XpfMJEfgcwLJ0cy7ggZ8HN0bKYv781FAQMo71D0obkY=;
  b=Psq1kxPxZyMmPK/0nUn8bo7kbNt84Pebj8ucxI4SsvKjc9xVZXhX+zIz
   M1Bgb7fQq0rXkGaCz+eXYM7ehe2jVNfPFmtFOIlJn+wFhtUvyFLYuNXni
   d8Momka/aY7Ld8Oqd6rVsnOM18SYzdCVN+iWT2Bi/Eeh5/lB8kjMcn9cI
   T/yXZdiQTh+67AIvUfiUftZYyERrtlzIDBD2Vggxx9ZgQJ9XDJ9SCpVfc
   nxso4DPm7YOk1uKNjFYEfvqUMcfXtTMw7eZIHLL1CufmT9UJcJRnKo3OC
   t7KZmwes4RV6WrrzJcPe4JpTIfjbu9r6LJaz5jLklLwHFsr0BBcchUf14
   A==;
IronPort-SDR: 0ay4L1RYQe6b4MwELugiZQO1clpfpnPykhJvKtxOjVkWK1UWcBBNP9r2ZQCAEN6cgeHVibFFc2
 LDYsHyaguJ8ndxMI45TZXeXb4ldJptjiS81lxRMQ/uWBkWWMfHSOHl3pqoCl0pZLqyg4mLgnex
 iqhg3ZiiXtko1MXSvjV5Wlw6Sa9gNLyHf1ICmUvsi85MSMa7P95lANC+jU7Jyl470I+4c3MFE7
 jqKhNDMxuFeXEjxzPSgYRnlcT34Ei6pD9H7qw/Wf8s0S4MHwQP2vsIk2oG78jDMYs99WNjlvL3
 deA=
X-IronPort-AV: E=Sophos;i="5.81,291,1610380800"; 
   d="scan'208";a="167867931"
Received: from mail-bn3nam04lp2057.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.57])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 07:37:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLmlyBuROMHo893SNMh1Aggh4l5Vyt0WolZNZ0M+bVsWT1wknDTNjWgQGg6okbP6rWTxCo9QnvFAmBPY8Al7Xw5le3yN4GK54+DX1oMXAs36Ne51Dsq9ANH+ZaHyIechRHCxtB/X7S8pgnZ709bmtkwXG/5cLpi9JxeFcTPN0a+rzT6lHn3U+Vu78OS8J6Y7gyHNO7B231zbLxpuI7p8lbMe1na7yAJOh906zKHDpIzXSPB0AZBrIxk1ufcFalRMgu3sqt75nLnwWxKuebHUSmm+wxQDTIdJBAgqRBFsXJtcZSD+rJd7M0iUrC2HK842pWEjbs7At+8fJZ99cAsDKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpfMJEfgcwLJ0cy7ggZ8HN0bKYv781FAQMo71D0obkY=;
 b=Ox1YYZhjq6nRazbQK1ITCfrRHnXYmJ3ev+SbSuvWPJ7H1YekkIbcAyFDrN6kzFFe4icnoaQIuGc7MvT8xYTHJSjkqaNDgUDXTOrwC/ve2F7ze9rN9zzISpi2gRFSxXXQRWOl8RIzm9HGksMC9hcLemd5jH3zmgmCfVu8djXHmuro7Be+4C6ZmZWdAssnKRRQ9GRr0QY2izV/AhUCPse+oKyywmnFqJ4z7uIfAK2TG7tD8x9TvD5dqCTwl2Z7MC8dglKaJQet5w7AQibznvMh+t5JlMs2JbXt6+ja17BjGqgjp0/7L/1P57i/w5DzIeKiNFoDlXxTUlf6vcy4qSOCQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpfMJEfgcwLJ0cy7ggZ8HN0bKYv781FAQMo71D0obkY=;
 b=TU/zEBUhxjJbvdZBFFp87JAv+woy87IXI4Cu9IqR1HXaxIzgh+TIxhBDl2TBQrRHBjLIGaSTgpf83WKJxOJsUMa3uWpme/8Rm0WMbxJ59/WbdPQookHdcDrFmekkLbsfza6+EHFOoRCbgXa9AYq6ZPx9XnHm/s//cscWGLZPTxg=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5592.namprd04.prod.outlook.com (2603:10b6:a03:10a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Tue, 30 Mar
 2021 23:37:26 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 23:37:26 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
CC:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?iso-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 15/15] block: remove bdget_disk
Thread-Topic: [PATCH 15/15] block: remove bdget_disk
Thread-Index: AQHXJYB1ivNr0nKwiUeBS+wVdK9h/A==
Date:   Tue, 30 Mar 2021 23:37:26 +0000
Message-ID: <BYAPR04MB4965F1A6315DB0EB9AF9EF72867D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210330161727.2297292-1-hch@lst.de>
 <20210330161727.2297292-16-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe336cda-f1be-4636-6726-08d8f3d4c6aa
x-ms-traffictypediagnostic: BYAPR04MB5592:
x-microsoft-antispam-prvs: <BYAPR04MB5592FF69566B3EF264F7241E867D9@BYAPR04MB5592.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1FWUgvjCQUtYxB6GILSDvQpcjtI+KYAo9z96IGQuWT8iUPb7jVbauql4btSvN1yC8oPdNW3Pt+p8MkQx1M+5h9+ws02oRXCirgVbT08+dfSHqPgvM+g1JfzMbj2Y8wUL7fov1kmiXMKZLp/8JrjmmfT2GAt2nHqW30kks/F8sFLd/2F7FYDlhMmLege+baDlHXHHhrUHTIukqGFZ7XlR0SL6Ev8sCt4q2N/tVA/se/0yBf12razob9izfMv9fZc++Xx8uR74aCIEJPxBk0jP98Oaak91W+djG05xT8QiugpU7fFdeTicTR8vuaT3eHbhBsIKK5aTM3S1VrAnqeqhPQq/6N+h6dbkVW6xoFYUHIPwx2C8nLTPweGpt1lxLqc3PrNEyqwzsliCZ3qh7y71BCvSZ65FoJAozJmdr51Ob8x/4B9Xn4AVc9DbzFHE9//5Qog7o4MEwngLVfYpelUrRZ5yfJTl14WvLW0saz7bV0h/5G7frJUGkvdLO2h5+EFB8lTMfM+b31X3X8W54ttkZrRawIRiG4srOZ4voBvnbHRLgxkZqmlZYp8ND6X5r90CP811qHOfUQVPs0LF0wQ9wV8ghWzk8k3yiNnizJjhj4JRifikkLi7GTsZWA/Sp3sTpwwszIqcu8YycSpL9EdqoyVF4OO1DOxGLk/I2tHYKI8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39850400004)(346002)(136003)(376002)(6506007)(9686003)(71200400001)(7696005)(76116006)(86362001)(8936002)(186003)(7416002)(478600001)(53546011)(55016002)(2906002)(4326008)(26005)(66476007)(64756008)(66946007)(52536014)(66556008)(66446008)(110136005)(316002)(54906003)(33656002)(38100700001)(558084003)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?VxJFcGN3CGUOsSRJ9J1rQ+9jH5vAA4gLmUSwel08BC1+v/UW7hOibmY81Z?=
 =?iso-8859-1?Q?2Hk+I8pf6W1qAScrEYOicVob1RVWc9FCopQl8JneSYgzpT/W78qUIIMV+m?=
 =?iso-8859-1?Q?L9We/N6a0FJ0wRIR7C6fsnL8BdtehVLlpeXdMgWhoebgVH/DIDioQWw5Vq?=
 =?iso-8859-1?Q?IgEnNp56s8kON1mK9UgswxMjEirSSb96Zx7OL7ClN4GLx9SODETNI5lSoQ?=
 =?iso-8859-1?Q?ugzKg/EtCKmgQEJmPX/k8NIo0oZBiiKb/mvza+62HsNaXI1dlbFDKQqNCJ?=
 =?iso-8859-1?Q?PQs5/t664BIwnWhNqWCrulryY7b4icKJGVxzZJfjJgziXLn+znIq6zcIkJ?=
 =?iso-8859-1?Q?G+o8uLrsoV8P3uQ7Qrvqb1L9h4eIc9EegO6UDzfUUXWAcVyL1/fZO/Wr8j?=
 =?iso-8859-1?Q?vh4WZN8naXsenfqALqbBgY5HprhABBuZ+u5ANvXb1ICY5mq/6Pm8+ZjBWa?=
 =?iso-8859-1?Q?PSbA06aTHYKJwNsclLUSkxPALKnDamNDF0l9ciADH1HwAHIFOFhaivc8zJ?=
 =?iso-8859-1?Q?TN4ZNH6aGa0RStITKS6rqplgYI3PAuTi+IpzLFU3Sk617H+ZCynIKNA0Y7?=
 =?iso-8859-1?Q?pCOFasa4VSZvxVvowdfitX4fuJxDdRSmFjuyXU0Di7YxNgM+NK8sWImqeE?=
 =?iso-8859-1?Q?qZ2flfACD01ZK9V8Q3VmUZGoqE8SPwHJqmlmIN+RSQa3DTCp1ex2Ll1QcE?=
 =?iso-8859-1?Q?C4P3IWufHQiA6K1LV2SmjFGIIrirGwZIEcq4C4g2m/JdUm+0K9DR7yUBcA?=
 =?iso-8859-1?Q?LQDEfTstE6k7LYy1RjkkiDuhuczfjGqw0rmxdSRpYPOKb+3GO411cmbbHw?=
 =?iso-8859-1?Q?UBMyUKbvR0krwnb4x5A/MWMje5a5Ey/LRmYajFYpxxl7E9uyTR3v2i64zL?=
 =?iso-8859-1?Q?L5ODdaI6PBvcaqxX1eRXe8dx+fJBfT4001xDyaJWCBB3/Ef0JzF+CcFb6h?=
 =?iso-8859-1?Q?Mslsl7OsacnUpZ9Zzenyc/o7mbYkWL6g8dHsNuVtZO+Uv8AuAF4BAhfL1B?=
 =?iso-8859-1?Q?txdLrv8inJ1G1GL5IM233x9z9ZIt8YWNfmf8Fcvm97irRraFz7MVUR8sB+?=
 =?iso-8859-1?Q?aNmscrWoStMuYH46XAUQuSrdcZsscRGKEyTzg03Qf+/UTcCvsy2uIsbZM1?=
 =?iso-8859-1?Q?EhaZ4ykjvqdpq7ITjG0H+wj1wJbukGyZ4qsA+ALQdy8HuR1AmAJw5d3OCI?=
 =?iso-8859-1?Q?yFHFRinKauCQcagI+M5TS4xGMz9JseUcyDai2X899QKME468aV6Fhb0AhW?=
 =?iso-8859-1?Q?vli1HraoxHkaVa5oNNv+42w5OAcwhQPCRa+8LaOoo3gQ+zFIz6whdEeELE?=
 =?iso-8859-1?Q?9vzUrT3NRABf6lWEwPedvoYIB9yjzqPRsMrJBqZGjQBOf8egWw0BJxt9fM?=
 =?iso-8859-1?Q?UToGg7nL3q?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe336cda-f1be-4636-6726-08d8f3d4c6aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 23:37:26.3548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AR4GJbH2ohqNCKkb0m9j1/8LYFUSd5t9vcTPHihyckcX8SyPV6129oYQhO+jHaqzAzrW4Eyrz6khl8RTCrDGifcxtd96pyVQnG8KEKAweeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5592
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/21 09:19, Christoph Hellwig wrote:=0A=
> Just opencode the xa_load in the callers, as none of them actually=0A=
> needs a reference to the bdev.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
