Return-Path: <SRS0=1Iot=CB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EB6C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Aug 2020 23:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B98206BE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Aug 2020 23:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DvVvrfd9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="O6CjCByu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHWXoj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Aug 2020 19:44:39 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61728 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgHWXoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2020 19:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598226276; x=1629762276;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VDAAvvKs3cHXl6tt2AJc1FThNXFLvmnMx7woPw33dUI=;
  b=DvVvrfd9F1jAIc+ID+or3N7lDQsE3QDFgr1PlPjcbAJ2duR5Ovv5DATs
   kMrlwMwYH6D4tfe52l9bqyqaYasg06/v8S6x3BrWgSXp/QeX0HK38BYdW
   u2ek5bdvF0bWXU1bJP/B61ZFagPgudcHdzlxtlkpod34trQkFGjdh81tk
   AU12CMXZZ+lhHR7x/lgrJVYoztIpMOMLL7VTz60P+chFgFQ6bdoy8HJKL
   5ly0BI9aPQ2/MAtAdwV8jDAoQAAKabAnW7VJW0W90JjQr9hlQduS8bm5/
   UFKiP/ZUrZcE+20NAdu1YKUvHqlCc3Eu/1xz7xbeevUgtgfYAy3jlkvfy
   g==;
IronPort-SDR: 5WlYJUdYwNLXV47jNIpwExsvpgDVhSCLbPKXSJBec8U1XvM5v29rq4zGXgmMiX2zce9dxIYPiC
 Q5CPQj9KBtmBMlEuN0GGRtmmjHP3KQXh/UFvCUJv6a66AshbSdxr8HNEHTWUyV53sEWd9gyCbV
 v3gfUj/MGbBQqHVNbm5HvJOuHM87AwXckM764RV0LXybcs5PeWTunX4+2n2JT7u/ZySBElf/iE
 zoO3EXi0MVdbHkWb186M1uwxJRKnS90ex6gFn92tfVmqXqNwFEgYqsiKC+pQeEmwYPhh0xsYzt
 XME=
X-IronPort-AV: E=Sophos;i="5.76,346,1592841600"; 
   d="scan'208";a="255112906"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2020 07:44:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibu8BPT3PHX9a5puA3kC33FkOMQIrZeZz0dgJ2uE52ILS9HyA7ieRrcPqle+K0/7SqsQ3PUhMHB78uIsgYX/MnoTpVr1jQMMf0c61zTro5clEw0H3H26kGp3oN0HSog950ymc9Yi0Me+BL7n1EwumJVz/cHsrTyHapR5zo66FZ6Qj5FpINRtC0fD8FhO8meayBsy4J/zETWvkae1nn1BQjQr72kk60I/S1gVG+DHHMmoJlfMs4ADt10/dBq18X5qQSavaclz8d2drnFG1lefFjrrwQV6REAuvTZCY1dQfy7du8NWzkNmvUqyyMJggTdQkxQhQYmOJ9ReMLf/4Ox7sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmSvui3BKZWG7T96u/yWJyt0Ekux5ADNimtWiuypscw=;
 b=JafPUnanUdoZNAt1Uyn1YIeevGamqi7l9yQ35I50ThMwOnOF1jLgab5dWKYyjPf2tqEIPczXNOtKXcBszozuf58qed1huhL7SOs/wGoq9RCo+Pmr136sTqFkYa3C3xeUj+cbT5G+tt0iAoH0/yJ2sN+glUbpCKAeHuDg1kexRxZstsGrN+i79QmyuKGNvb8YEUNyAERhd7p4oa9OL65LTreW9rrg9IkezxZ9KCpI95VY5jMHmePAbPsppt+7GtG0yS6lADctmgTsrtGrZpKTrDgDN48hEUCYBlc2w/2mLY2/o4/D7HVQaFyO2lAFiPEw6AH+vfIgGCiKA/iz3IQ+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmSvui3BKZWG7T96u/yWJyt0Ekux5ADNimtWiuypscw=;
 b=O6CjCByu6rtuwbX+bwGulzNJ+2EYmjmC2BA0zfrC1P13pv6HWFruJ6SK6ONNxK3qnaRR/V1CiTR9aqxYm6plehs2gXPhDHGQxJUmGNqZe5sM7/Xt0Ru+/dp8yS4IUicOesderuY4NHtSk7il/ld2+tOc2e7uQab8XCTsaANUdDo=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Sun, 23 Aug
 2020 23:44:33 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2%12]) with mapi id 15.20.3305.026; Sun, 23 Aug
 2020 23:44:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: scsi_debug: Remove superfluous close zone in
 resp_open_zone()
Thread-Topic: [PATCH] scsi: scsi_debug: Remove superfluous close zone in
 resp_open_zone()
Thread-Index: AQHWd7sKZy5BiYNcUEKAwI5V0qcAbA==
Date:   Sun, 23 Aug 2020 23:44:32 +0000
Message-ID: <CY4PR04MB375193F975BECD0B5C45C026E7590@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200821130007.39938-1-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 341ce7b9-b6f9-4f7c-ee07-08d847be7c7c
x-ms-traffictypediagnostic: CY4PR04MB3751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB3751334973C3712F6075788DE7590@CY4PR04MB3751.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iwb+tJlAHAtGt/xRpY8rAVS5zImiEVL6O5u9D06NkP+jaZ1dGwmQ4kF3Q7kWP/AuQ1zHwXXc4NSjvrDL5q6idWKEw03WdGarclwXPifArqxzZYoEFEmYNGwsBzc1hIt0B83PlRDMnkMISMYpbrIS0KhGWsGECGzP1rO40/tADnKIcMa6EGWYzf47QHBvz25kUvqCUuI5Fy6GVOkepWzMXl/2yjWVFZmpC1yMzsbEgPv6J+tHSN9TlVoxm9nDemV924f+5u21pN99oFkLiFXNCduReiF1I7ZsrZfsbuzUm4G6UhthfqJ9K3hSV1D2Lbf18E90T7JebtFt/htov7MB3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(376002)(346002)(136003)(9686003)(66556008)(2906002)(64756008)(66446008)(55016002)(5660300002)(66476007)(26005)(91956017)(186003)(66946007)(316002)(52536014)(110136005)(86362001)(54906003)(71200400001)(53546011)(76116006)(7696005)(8936002)(8676002)(4326008)(83380400001)(6506007)(33656002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /cpm+lQYYuJmpJSbrw3wjd0Svrzw1HDsl7dyoX+UtELWORywSyhr9OYKQEvKlxlhxfgC0oNukGd/NNjO5kvFam09RSYNTcOXjftEoilzAYYut/gS6WRP4Pq6VLCngH5xs9LpyY9qCFmZlgqwFIqh0glYMDZfhsArV9f6BDA73JtCeiclI9PefO0guk9t62zBSU8j4TGKQJtbjCQw3T/7O6guFqO4PRFoUYtTDIHWQ0xJ6BxQGHP9oC15GGJqHYnFMq9R8eNljKW/XnlLGTxT21wfLlHuW22XmSmnFmCjnyjYS5dk+gjWytOCeV0d/R2hzbg9UmLbHQWKs/GteWvShuCuS0osI/809FxD7cPgwNga9IAmENIpbIdvTobQw7GmOBNUWeakJwUSblKqjBlZ2O4jGE4rQ8skCFarG9jT1+P0eZLY7ZYJg9MJLtKdiMCIXhArB/GY58Nbz+7E/dEoO+PgMh5SXTQOUNMTzvegQBIHmCDGwYWLrI99NGiYLLxomjtJQsCPXSVc2aq8hwDe9I3n8olULp+KEKeKQCe9H4qFl8v63tZzGp7fc6AO0cYm8Hr5YfTWSysWVOhAYxmK8pQjfqkzPQdwWFj71AoHRkzHm8EYop8Js3Yp2FlmqT1oX/51xdq6Qj14Vk8HIKU5tg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341ce7b9-b6f9-4f7c-ee07-08d847be7c7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2020 23:44:32.8696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Enu5YEQFag+/1Q7v6wKUc1IHaC+CHODamDPwk7nNKTA9Ie8OCxmqoEo4OXDRdjyv5uAdUfgWLdC+ysid6w5fRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB3751
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/08/21 22:00, Niklas Cassel wrote:=0A=
> resp_open_zone() always calls zbc_open_zone() with parameter explicit=0A=
> set to true.=0A=
> =0A=
> If zbc_open_zone() is called with parameter explicit set to true, and=0A=
> the current zone state is implicit open, it will call zbc_close_zone()=0A=
> on the zone before proceeding.=0A=
> =0A=
> Therefore, there is no need for resp_open_zone() to call zbc_close_zone()=
=0A=
> on an implicitly open zone before calling zbc_open_zone().=0A=
> =0A=
> Remove superfluous close zone in resp_open_zone().=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/scsi_debug.c | 2 --=0A=
>  1 file changed, 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c=0A=
> index 064ed680c0530..912d6f4878bae 100644=0A=
> --- a/drivers/scsi/scsi_debug.c=0A=
> +++ b/drivers/scsi/scsi_debug.c=0A=
> @@ -4482,8 +4482,6 @@ static int resp_open_zone(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)=0A=
>  		goto fini;=0A=
>  	}=0A=
>  =0A=
> -	if (zc =3D=3D ZC2_IMPLICIT_OPEN)=0A=
> -		zbc_close_zone(devip, zsp);=0A=
>  	zbc_open_zone(devip, zsp, true);=0A=
>  fini:=0A=
>  	write_unlock(macc_lckp);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
