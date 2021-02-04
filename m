Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE36C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 09:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25B3964F55
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 09:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhBDJeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:34:31 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23158 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbhBDJeP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 04:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612431894; x=1643967894;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/v+UehsQwS/ZG+XPawqxOiSSLBGh7ofKGzN2z+q0zbo=;
  b=JC9JIAnMdoPII2zAv0RB2cWw4BTr4Y4hjREz+WB9yHEovSJXNDJKk5gj
   blrvLXy2r4HgIYnUbMg5diXdQA6i43Nv1gT3Jzbd8kcRl9XWWyK/nJJW0
   djKtnquTN0t5Yf/KjNEh8OgVV+La7W/Ow2rZcXVd6zXtwsT7c897EEOtQ
   JLjNx4AkxgiSsCUFFyUoh8yzratTy0+og0V4nko2VIJ27f5sXGvOFDOLB
   eNLs2RR4pR5iEAGrvgkt8J+A/Ub7ecY0eomoRHhzpk0uOWKuTCY6ile+A
   A9W9nb2ppeFYcCEi9vDj7DKvovcBFV1GeOvl86pl7bnfAMDI2rh6/pv3o
   Q==;
IronPort-SDR: nL+K9OBZyCJQB1X/EOtOd/9n2ixDFmjQQ9g+BAsxmovqa/Vzvcjk0kwJVclhhYevkSvERSw+/g
 4bh97FAYXwPhTdd/ST/kcRtI3kZVJusBYBbF1BFzVvdAp37flarZl90W4Uw8pfg6fhOG92bzr9
 /6A3ypAKa9zmUEpNQ8d9IvU8fyM4NrPgKdDT4+JkWTAVJ43nhkH0eBAAselmaE3vClT67hei1n
 HDzjKfuUo5d4ibgA0HzlUCGJ5f65XK5I9n8dedrMziUqom15ukr4YrvIQrrmpZARB2KhqYcMSb
 zxQ=
X-IronPort-AV: E=Sophos;i="5.79,400,1602518400"; 
   d="scan'208";a="263195900"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2021 17:43:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kyq/IwjsNDUr5DCAK+UnrsvLDVddej+HGUrIMAZEredvA4aw7pF+ZA2ii/dv5AH66QUOEylkv0FL9+P9P5xnWL3O7LQGINtwRDARNipugblBE2AHUSOa+iD2O1r1L8yZu/2ZH8zgkfRFtyVZn4tLV97fq/H1ctfGC+ME6meEi6lqGuiUmuvNEjiPqiY6YFYFQGYJCXJ2AYtJynZXMbVPCnZHOX+gdj436LJGtqdUIPti9pA4rkELWwZPDi5lMWZ0Av3AutTdNiUjNh4kOc97UO/BCoXvOVjdvl8i8X1PrXoESOY9KS5hr1Ira7SRcfEg/2l3VDW8fkmwbvk2prUCzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5KHF0iYIOjW62NVtRpH3N8n5sVd/y9uSX9lkzBha40=;
 b=cB9XSGBMAzcDybaXALwBFUpEqEDEKvn9wYWoS2rGGFxjdWTYeVdv1ircXHdleN2cMm9NnUWLK2JUuFTwtajQUJgJRsbQvlJ9yMi4fGm1M89+aQzhOO0fSeeP9jD6zKQRGbu5gVFxNFWxuWPFvWjQHBul4Q/CH6RIeVZw2xjoiKl+zDXokP7Pcz+6e469MJq9EgeqPMBfsv5bhhQY/pLHTXPq8exk6a4lLkcobAVrp7vv4XfvIxGfOxPAn+6KO3yTLI7DSa4TrXGkIm2jv3fx9kQHo3C9I4tpwFw/HjHpZ62JUhJu6qgFHOQ+VU+BFMNgUfRVM677a2mqiIWIf1ohug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5KHF0iYIOjW62NVtRpH3N8n5sVd/y9uSX9lkzBha40=;
 b=cEo56uWlFfSQfuTVei+EYieBCjkB96cA2rGNjjxPonRvuLSl5ZWZDQQo7FfJr/taTSukSL6WeORGbn6lByqkHOMbRz7oVoCFMxm9vPzIoJaKO7wU7rdKoWhJezXTnFQr7mQfiPIbxHKmNALh3OPQA86g5cBTAqCgf6jEoDiTlh0=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3599.namprd04.prod.outlook.com
 (2603:10b6:803:4e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Thu, 4 Feb
 2021 09:33:07 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 09:33:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Yang Li <yang.lee@linux.alibaba.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "brking@us.ibm.com" <brking@us.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ipr: Remove unneeded return variable
Thread-Topic: [PATCH] scsi: ipr: Remove unneeded return variable
Thread-Index: AQHW+sdPjcW8ddogR0uDkhrg8dfJcw==
Date:   Thu, 4 Feb 2021 09:33:06 +0000
Message-ID: <SN4PR0401MB35981D9E1825962920A0CB6E9BB39@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <1612423568-81006-1-git-send-email-yang.lee@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:51f:6b4a:2171:57e6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74315d2f-1025-4765-2642-08d8c8efe109
x-ms-traffictypediagnostic: SN4PR0401MB3599:
x-microsoft-antispam-prvs: <SN4PR0401MB359945A238CF102BB9D6AF949BB39@SN4PR0401MB3599.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CwsKxaPVqIIzw+8k2k6K+i498EV4Qe01cTGRXbEmsZEeB1NVAo2ij7BuRhd8HIR33ezo7ud/Mt82bzrI61zfQ/aR8GjmnibFal3EsdXvvK0LRx9sCcSmb4iMr1mvtvKwLGr1T53akF9X8kgsBeyCaKJdAp59qYOdZBqJY3myFCKDY1SdWL2y+gWsILtaoWSYDn8Bd6hDGHXtAqFCpd93dFL66aMzf2KRolfZ89SaBJ77Xf8L063RRCs88U3P5BN8JMogTPCzDR6bFX6kVJgsScPIZa5v8yh7zS1ZhSJkxNBJDYvKH3eqWRokhtVSsbJQfSh+A5g3CApbmu7jukAC6ZIhz+FK/VM9OgxpI6DZKYEmc9j2r+/yFWwx2jdlcY+0RYBjfgnMfANIfnlzHHddWnMe82LT8dxxKMyqDEWe1q5NnoD/gBzm06RXcojs/xSCp6XfpWsz2uRRBtaSqsl9U1O3fZeYuTwDHE9F7YSaHEMH3LcKWs7yG+NdikWS6m4XyYkLPiPPpSo7kDL8VVhz5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(9686003)(54906003)(71200400001)(110136005)(8936002)(83380400001)(5660300002)(7696005)(55016002)(86362001)(33656002)(52536014)(2906002)(186003)(8676002)(6506007)(66556008)(64756008)(66476007)(66446008)(4326008)(53546011)(66946007)(91956017)(76116006)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?x+6vbGW9I9n9m3s5yAbqRW/j8N4gvtX61cveivpztQTUY/ZD2Of5qm5Hf2e4?=
 =?us-ascii?Q?8GP6Xaqdj1fzVbbO1/SQJ0ktuMYOHreym62z2UpRBDdWU54lrYtNba56NemK?=
 =?us-ascii?Q?HrdTldTRIMFCGA7agNJv5DEtDgQMx2OBfIx6Oq1Th0usWOnRR9vfvPbQ6Yj4?=
 =?us-ascii?Q?n/CenN1eQOTNv35CK4Wgz8USQkwg3Q2wgmwlX9WkSw8xN2uXJldhNUXXwcr/?=
 =?us-ascii?Q?tS18XNhZwh2UD7MHFYMQGSAx6RmK/1WHrgaNZJfGXu0mbXu1vBR7QAZLV2ys?=
 =?us-ascii?Q?OJbsVPH9AvvulS24qzZwDVH1XFOO+ZIs3FzWTUtg6hkqCTkhGsef3gfo3MYU?=
 =?us-ascii?Q?f1MyC6Tv784LyeeMxzzy9C9LCyQuV7FOWYokOj57zQBhUEyb68tyAJYDG1zo?=
 =?us-ascii?Q?3MyYvOSgfwMoRaj65qjKXzPkoHFss6Cw4mnkWZBmAC98NKVfGiSjvbl+AgE1?=
 =?us-ascii?Q?XDdMqeKZv2Fy3b6S5RSEtt3bgDYoxPay43e0ZBKpHTYxqqzKDjrzC7omkOOM?=
 =?us-ascii?Q?ZEXDKkInKbNaJnHiC7w0fulWXJMTH5INfusWi2tCqffDxfIBURRstaL1CbTw?=
 =?us-ascii?Q?+1PMonUJ4MR84yh/9fhF4RSBbB78gqUMh7jKkzIJWWqLL4jQM4aLgbQXB/gN?=
 =?us-ascii?Q?rEvMgBZ1iVN9w9uiQx/eGjWBI+C5GxJGlhT/JAO20L68c5q3Elcl9ebJyDLj?=
 =?us-ascii?Q?ylQF2CQFw1jKWaFSHybUfDQXvPk5c3QC4djtCbZzPH8yfwEfUKzgxFu3wi+G?=
 =?us-ascii?Q?CWauOum15/eBRY3N4Zzns6JBkOvQhKKbuovcBkEZoqhOjQB93DfVaOFYFdk9?=
 =?us-ascii?Q?Qh9Rr+0y+jNmnjn3PVUq+yaQ6o/1BZ0t7pL32KgJSPj4PnAj8Al1Pjs28sQV?=
 =?us-ascii?Q?9b6vrJNkLZ2bsxHZ61yzQAy7M1QbpZzPLde2XrpsLnyYzEF/PMnKvmdNDfSU?=
 =?us-ascii?Q?XxE2nkuLM5NMbNz1RE215o9crW+gP2D5POpVeaOMgHxSF1IRjurSx0VsrYHq?=
 =?us-ascii?Q?0+NqU3iMRcD5fiJA4SQ9OMnVmFVdSCUCpTqtVqwO4sFNyAgEWn8kW8V/CWBf?=
 =?us-ascii?Q?NqCKIra4GFSYkyNjhrn2WDp5KwtU3FFHdrfntZwDQktcHh7D6P0byEqh/4q+?=
 =?us-ascii?Q?OuwaNVug1k99SEn0jlOFCyjEuDXHCk3/IQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74315d2f-1025-4765-2642-08d8c8efe109
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 09:33:06.9978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FsLh/8EulViacvtZdWVsHEQQbDVRhE5MmTlswFew+P5q6dQVtPPL/zjwR77UUrIPenQ+NG0OwW0SkH/u4IxrZ6LEKcv4H3MUdHzfnDRXsuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3599
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/02/2021 08:28, Yang Li wrote:=0A=
> This patch removes unneeded return variables, using only=0A=
> '0' instead.=0A=
> It fixes the following warning detected by coccinelle:=0A=
> ./drivers/scsi/ipr.c:9508:5-7: Unneeded variable: "rc". Return "0" on=0A=
> line 9524=0A=
> =0A=
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>=0A=
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>=0A=
> ---=0A=
>  drivers/scsi/ipr.c | 3 +--=0A=
>  1 file changed, 1 insertion(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c=0A=
> index e451102..8eced7c 100644=0A=
> --- a/drivers/scsi/ipr.c=0A=
> +++ b/drivers/scsi/ipr.c=0A=
> @@ -9505,7 +9505,6 @@ static pci_ers_result_t ipr_pci_error_detected(stru=
ct pci_dev *pdev,=0A=
>   **/=0A=
>  static int ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)=0A=
>  {=0A=
> -	int rc =3D 0;=0A=
>  	unsigned long host_lock_flags =3D 0;=0A=
>  =0A=
>  	ENTER;=0A=
> @@ -9521,7 +9520,7 @@ static int ipr_probe_ioa_part2(struct ipr_ioa_cfg *=
ioa_cfg)=0A=
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);=0A=
>  =0A=
>  	LEAVE;=0A=
> -	return rc;=0A=
> +	return 0;=0A=
>  }=0A=
>  =0A=
>  /**=0A=
> =0A=
=0A=
As it's always returning 0 this is dead code as well:=0A=
=0A=
	rc =3D ipr_probe_ioa_part2(ioa_cfg);=0A=
=0A=
	if (rc) {=0A=
		__ipr_remove(pdev);=0A=
		return rc;=0A=
	}=0A=
=0A=
I think:=0A=
- static int ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)=0A=
+ static void ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)=0A=
=0A=
is the right thing to do if you really want to touch it.=0A=
=0A=
=0A=
=0A=
