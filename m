Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1130AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04E9206C3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hGvzyDfS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bluRJv+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgGHMSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:18:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55225 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgGHMSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594210678; x=1625746678;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=QrOrd7oOIBDz6wZaPdkydvHogY64h5YKx9+YBQdedfc=;
  b=hGvzyDfSEXwofk6TEAnS9HzkPRKsk+G4YHqY2kWJF5mqIJU4PL+MvZA0
   UclPIWUp8Hko/6TdxrP+LDovKJiiskVw/1pJ3gRYwVnUSfSLQYnso8GvK
   5kUl+VDjanGjI+vTAE4lDUQxMNyqobUYsGVPlYSGNwyiAseSmcrfYOkAQ
   i6rbjtyEGJNkdyj9n4Dg5GQtzeJjftcTWojkMdnAurwQJuCTRXCdM03e5
   SgPKWgygtOgZhdY1bU0Vfd2doLD5B8JibRCqochXDngL1jeQIxt6I9fpf
   IUcMXuiVJCzQ6awYdwnoKbrJd9rfb7gZc9mdvgN2lvZieiBLNf6L2uIFQ
   g==;
IronPort-SDR: a77WrvJ5vjSrFzpas6QtTOWpXUSqYcajxDQze4SgoljGt+xfnsItO7GLLvYci0UXUmpKI3JsxC
 dMts1sRiuLMJlxOx37JEzwIujx9IGpOmWa1CA+riM/5RLL88Vnrv3Mbq78VPu0cZDoxhmGaKP7
 a+XnDqx0V7w+/j2gWgcoTwn2rz4rfKirW5VK0oyU/NGqNRJYNAEmeGKMKw5y2OYn8rqHjJVY+H
 fegEz5qHQN6QZejQZYRrsLAUHsgVyiPmW7rZofmQy++aJGZgI/XWp1F0lqIrvmjuIw8s6ok1ML
 /z8=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="251162065"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 20:17:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIgjIpWKbQVp50OoRYbhoZ1n+7V2DgPo97Fm7cj9qVPK+bgUfAcmPX/InrYgxyqNiFUiCyj6igIhPGgyd34kiavAvFjo7r/iqxbS3/CSRjCH5YcIptqgVowjJRQM/JLcqtZqjHsudQHnqI1yroQExlQqLTm5GolT0fD/X/FpDq7A+8QhKXzogpfk7w4A0GcQxoeJQXC6H50jaNIjNcQPcazIE5R2S4Vx+rJBgcYlR76X7L8F9ZjHltWBhdz+23A4sb4cyCO/bgAPBxeU63aD3aGfE0WGisPseyQeH76kzp/1mpWi9LAEZwoC0lJnBYBiMNA3AuvuiO+rOwD77g2l4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuLSrOvyRbfzZmAXJimRiAXPrbeyRXvWQkvqQe8BDcE=;
 b=TqGTCiG0u5sVrtUoT+kxjpZkTH3cbB5y4Hji7vL5vbxknuvo7j2Mqh6g1eeFm7Hc9PTMVUntjr7tQIyiuwWc1B56nIvmO/dOgLsfLt4kNxJ6qTwXaApcyZVqNkkyMTv249otbOK42y6Yu4Vj3jZIrkp2CIuf93oowAwOagAz7ydjZZ2bhg2eqPNtqD6k8ben1meAc9gV7lBDWKKhghtMndXT+SvNzCSY6gzLV4GN0EIy3SWpJNygkpsQJErOZfut/Fk8h8qUgRQ8cnuwSpCVesxcH7ykADooevZaUFl3EK8Ukh8rfEUykw/O2Ja0yMtptPL+unmnBEsQsm5IamJbyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuLSrOvyRbfzZmAXJimRiAXPrbeyRXvWQkvqQe8BDcE=;
 b=bluRJv+1a+oDEktX/lXS5oQ8dKZ4TOSK95JUg8ZX5JwiOOZCZXaxpToHtGuhQOt7SImFgDeOWEapMc9HNhQg6mNy/TgdpZ8HWxATvGiuiaiQcYvcP+mhbJJbEvWR75lZQCKb0WaEvDWd9ntkh7qopxosfUjn7V7LnTxE4yHscTk=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3888.namprd04.prod.outlook.com
 (2603:10b6:805:50::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Wed, 8 Jul
 2020 12:17:57 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.031; Wed, 8 Jul 2020
 12:17:57 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/30] scsi: libfc: fc_rport: Fix bitrotted function
 parameter and copy/paste error
Thread-Topic: [PATCH 13/30] scsi: libfc: fc_rport: Fix bitrotted function
 parameter and copy/paste error
Thread-Index: AQHWVR/rxKfallQICkGWIIap3hEicw==
Date:   Wed, 8 Jul 2020 12:17:57 +0000
Message-ID: <SN4PR0401MB3598A5AF95715606071A64939B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-14-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 612d35c8-e8b1-494e-0ca1-08d82338f2f9
x-ms-traffictypediagnostic: SN6PR04MB3888:
x-microsoft-antispam-prvs: <SN6PR04MB38885E1628E258686CB672769B670@SN6PR04MB3888.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: phdG3gAZ0i1kE0hKKJJ5EWihJCBIu5qzdCnh0rLa2GF1OgM8enuRkoRAScDf8V/ph3CFefFyxiC0qjkXtXwz6/C1dN0h91lLK+PmHTS4GsIiC+cWkRWsiGKcZ5jYUGvMd1iY1mKwh088p2aL48vMAmNYZIyfnqu4uZtMbH+0EOUhf+ki/haRanB+wrum4DhclanJt+NJ658n04oa7MMb96MlcnO/IDRElpWv1KrFsWDFgD5R6qNq/jFI6IZ/SUy7nr0jawjH/dWJEJu32gYLZ9I/0KR/CiIFxVmJt+OJ1DXnv1UPijmubvpaZ1uXM1sjkBuqXRMWUwS9c0kBW4CJBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(66946007)(91956017)(76116006)(64756008)(478600001)(66476007)(66446008)(66556008)(83380400001)(53546011)(186003)(7696005)(6506007)(55016002)(52536014)(2906002)(9686003)(26005)(4326008)(5660300002)(71200400001)(86362001)(8936002)(316002)(8676002)(33656002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kaWPN2n2yFQ2dugFhh9IFYebtn8MIIX208G4I2CYf8T87wsGV8gBNECIdRCd18C0Ol/PG+7NLL6jI9qiuddw+KCWGjNnSZzomH3QW2xUtd5gMZ2fjtZvHdgSYPCmfKzWdkScVhKEJLgpZLxQ+rNlONUGiQ/2sgIsaEFAGFm4+dnIhxDmNrzVQuxMtRlrwCsbebLiNbif4D8UVv6/f+l3rHMboH5FLhmiLYgX46VA/wRY9iq1s9IbgSWi1sxK9hFOF64OB6jmIcyZuUI0SStccLFDEP04tHIGnXA3MdSuCRD2hh5Atk8jIycbLjK8PKu74nlFSn2K9W+pCz7QWt68e43jE0AMWmpOCNZ3OWtKYRzTR/c717eIaJxFMMcKWlkOEym71RQZHSGVBmC6d1RR9aif3GiRsPYQ4Vby8wztL5iuO6/auQj1H0hTI6CsuIp4xB4KW1CUvuSEbqFljdm8o+crB0IRvJUYPKQKtKLNMOdVbNEkojaEyHgNpIlcOnaN
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 612d35c8-e8b1-494e-0ca1-08d82338f2f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 12:17:57.3146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S561rZZQwjMRl9kTU0ETE27E84KSluJK5151JL5pxcr/WFd5Tci2ry8gUs4ojun1a8haCwPoWx+OukN0UdmAsAgUmdcIz+9r8AOD4R+velU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3888
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/07/2020 14:04, Lee Jones wrote:=0A=
> Description should state 'remote' port, not 'local'.=0A=
> =0A=
> Fixes the following W=3D1 kernel build warning(s):=0A=
> =0A=
>  drivers/scsi/libfc/fc_rport.c:1452: warning: Function parameter or membe=
r 'rdata_arg' not described in 'fc_rport_logo_resp'=0A=
>  drivers/scsi/libfc/fc_rport.c:1452: warning: Excess function parameter '=
rport_arg' description in 'fc_rport_logo_resp'=0A=
> =0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Signed-off-by: Lee Jones <lee.jones@linaro.org>=0A=
> ---=0A=
>  drivers/scsi/libfc/fc_rport.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.=
c=0A=
> index ea99e69d4d89c..18663a82865f9 100644=0A=
> --- a/drivers/scsi/libfc/fc_rport.c=0A=
> +++ b/drivers/scsi/libfc/fc_rport.c=0A=
> @@ -1445,7 +1445,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_p=
riv *rdata,=0A=
>   * fc_rport_logo_resp() - Handler for logout (LOGO) responses=0A=
>   * @sp:	       The sequence the LOGO was on=0A=
>   * @fp:	       The LOGO response frame=0A=
> - * @rport_arg: The local port=0A=
> + * @rdata_arg: The remote port=0A=
>   */=0A=
>  static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,=
=0A=
>  			       void *rdata_arg)=0A=
> =0A=
=0A=
=0A=
Please fold this into patch 11=0A=
