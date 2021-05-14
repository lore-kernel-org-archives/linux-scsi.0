Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3E5C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FEF361402
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhENB7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 21:59:18 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30538 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhENB7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 21:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957486; x=1652493486;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=mRsmDjJHU7x4CB+iX7wgvnEzzbbgGKt2it12f/ZpQFg=;
  b=S1nY9zkejhxYmf5kUjleSfh2ax+0qU/tXFv8B/OH4mCd1LHXDyIjTBUQ
   ZsLg670bE0P9+Ka54SwlhHI6LqwkOm9nHysPrAx89WhJP0+6qiH82pt9+
   E6alYDJ5w5114X0S/5dYSvXSO7t2LU2923cLiZ5rZzhx/tx/jOb5tbXhs
   qqpqtEKpXAUOQBeFZq3NFH1vihTV1lZfpLSp0KIkKZwQGcGSeICB7N8br
   b5rzo9ODMIYk3dojJxTVArXpFWo1SVhaBxYOKgMUDtElFuXE8Ra0NjiUP
   aiW8YEps6G5W0EwDdGzTclVih+uSN04Oon/RSb3288COTeIrkVyHIWtdw
   w==;
IronPort-SDR: ykI0bmFmPgl8s03z5VP3IRRY0BouHSzR4QRNplIXN7ZD12x2I9C6fEiBRrBWokAhtX6M5pAKeF
 uKgwIuts+jga1730d+fIS+5tKsDiMWW7woWjgpeLQmNLt/hpRoFnyFI3OJoj7HMMhzc28BN5Aw
 pcNImrZ4avPhjrITpdUja6wnr7nrJuo9jtjBSZYWG4I7bYVStphmE64gTKzz9U67Oh2xPo6ue9
 q+rA8nNP3BhdEsf1r3whhldOfwtVFW/YBw6AyNZ9haGtGNefRSNhlDN3XxIAKrsih0HJdPfi/1
 /OE=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="168137173"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 09:58:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELcm8sGNLbhcpmBjOryaJYB8z6pgTFcCE9eq5ZjSQEleQjIVDmcW4dqUzN083ra1Glq9W8EXA8aBW0rGOYfNi97SxgT4uDrAltxaQS9wvMCwBDhxxOY17cF2sLm4dSd+n39ttAgSHT5dyjni4QdDL5gPAJXsXOvb46gekjJCX0wxvkwSc6hAt1+DqVSTFEQ8+iQFfaIgKg26l0Oy8WTEZzxWUUcmoKgauzeilvq/sN3aGmNe20TD64UNcBC5AYmbwzO2jq/00c3hnMH3PyCeXaj3DJP0QGjFnIBhXp/XwlaxIwn7snJW5foXwaZ4dQpeOl+ZsTM0WQGO0rQKUp5g/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N76W8juACr9Ibrt3U3kbi+vhcka+BT5PKQTRkE17J3E=;
 b=GhnibZOAw7g/LtdmS4gzjRkNr4vDKixBVopW6ZpQ60/GZcBAavPn6UI4szO+sY9Oc1G3W44cy6TkiRLZTGvl9Y7p40iPo2HV9aB92VkKmcaHvqcsrmkOGrABim6mjW3LvtVHpBljSL9pfE9dE8BgxVKY+jNv5h3aLiwRoIIsWFZ7trPA8GpR158rm6krBw8xmeRHKXCAFtgJ9WGqhHuIg2YjW5EQ9DUx7CP359iut/Z3Hzs54bui2/TcLkND/ckH5vflWQ2SqINdPaoOPjVEwLBa3vcXE0tC4zIn7ztqOs+/Z3ZgjWgTk/I9MLgbb/8gWwlKIvIe9Z5mvvpK+dRJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N76W8juACr9Ibrt3U3kbi+vhcka+BT5PKQTRkE17J3E=;
 b=bkDt5Rxye3b+HVd8HN+Aig5MP7U47sz5a3RUyToWywpplzFXW1q7/lGeweHkk9EP8K+Q6gl/ee4S6PuRywByhL0Ci4HljuNKAEJ+5/O0pYpelMyatMyyg3XOdX3sGDu4AWKEq3ctMOuqe3NruA4UouWY9JizLxwe5qFR3w/liI0=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0813.namprd04.prod.outlook.com (2603:10b6:3:f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 01:58:05 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 01:58:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH v3 3/8] zfcp: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Topic: [PATCH v3 3/8] zfcp: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Index: AQHXSEiux27LFlhxKkm5LhHyg7La2g==
Date:   Fri, 14 May 2021 01:58:05 +0000
Message-ID: <DM6PR04MB7081B268F8888646FC294A44E7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83395723-3d15-4959-d501-08d9167bb6fa
x-ms-traffictypediagnostic: DM5PR04MB0813:
x-microsoft-antispam-prvs: <DM5PR04MB081355B89FEBB703089693F0E7509@DM5PR04MB0813.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VmwANamICt59VmVfq/7qncb9KgX06QpOpd0AnAaRtuYxRYjXIMh+p3jjRhWDtTt1Lv8MqIWK3nEIj8sGe6A3x3TL0Faz9/FXyjjWNusYEbtHBT01g3Ajn97GcWSm/ZmRHEScXccu8IuaWizD3ao4MyHUnJYVDW/3rkrHqWxQ4pDWqjL+rogBX7Kak3t/Ecj/ks3FPspjs0v6HySqG1FLY0ajnOYNU6fSc1xSuH1KUKCy/36XYJZGrDVuJaCq32TpUV/gyKQxhC+nVuzmtVFz/opkDabGcpZgYD7JKrBa7ojPyv/N//ekB1Uh4zGj7HkCr0Z0YYbSQr4GwL2yWjGUGW1wvDilswDNj6OOSRoQuaanSHCvv8U+qqPvLoAwlY0qejHpJCyTWWIw7BmtSSr9xRQCVuKAffcIKg12LOCsUZLTbk/2/tjkDEPjwXehxHI8tHMpgBYIz2X+4bYMhPzZu/MtDlQVXcsx4gwf+4WOSXZnc/9mESwwA5wxSxYKNvVZoDN4aDjl3q4HKeSqMtFt4Yfu2fwX/ywzhfzd0ro+cHNXOhTeK0KKaKSLCRAd3syGueZx0HhJee8G2DphDfoJXuiANg6q3Hf1jCn40dmlAYI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(9686003)(33656002)(83380400001)(55016002)(4326008)(71200400001)(478600001)(2906002)(53546011)(38100700002)(122000001)(8936002)(186003)(66476007)(64756008)(316002)(8676002)(91956017)(86362001)(110136005)(6506007)(54906003)(5660300002)(66946007)(76116006)(66446008)(52536014)(7696005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7ud7TWW6FvnTp6C4dj9uWY4BqUqBDBmll4B7ePoxKI9uYpdjjrTZdflTaq02?=
 =?us-ascii?Q?IKr3F9eijdn2nmh7Ur4ULCznYqkk9HutF0kCnAPY4Rmb07Aa7F5BqAS1UcBm?=
 =?us-ascii?Q?DC2WDQSa+0lie0np0Fdx9tBH/zzNrNfcZrLlU6/ovLQANt1MsLXpRCdKEmf3?=
 =?us-ascii?Q?T3SEkPx9QL4Uvtsp9vGfgUH+M1skPanxB18GHxIXYMXkk8qMHsJUlBOu7Sz+?=
 =?us-ascii?Q?KU74KFKySxHeyg0RNz8OyQ4NlN+SRsX101OACaX6DjbZI8ssUcp0FQLa3s9O?=
 =?us-ascii?Q?0+IAJ4r0qcbpBKIfehB+mhWIgYzkGuicO0xkT8KMAvLQKgMz/RqdP1IAyoBx?=
 =?us-ascii?Q?s58MK91WS95VXQ3mYOGHAtZTrep1NnY2ZejtIPhf7DxvYhn4jNXWZ4QH2Wt3?=
 =?us-ascii?Q?PTucjml99MBRoe7cL1+c49KgP6Jm1w5MgFS6VJGsaz9X0MeJAM31KSXq3cGm?=
 =?us-ascii?Q?ThX5sShhy+feoNkRpG7t25L7nnm51G0OmO3oVj+mfDctwZxCCFPRvi9lZoaE?=
 =?us-ascii?Q?RBRXe3GtGr+ouyK5q8cIhnRvA+URrmWx57GiWpK+e+hGKzio1M1U0YYeYQK2?=
 =?us-ascii?Q?za7C2GwsKO/i3vHMJHSw+3yQ/R9QwPSpoQ5OuA7rHEU6EwJt3I4RnLjWkImX?=
 =?us-ascii?Q?xwiLhm2+QiQ/FnQCFYAoxObnuudc8jlwVihFTqWqc5gPLYiMMwHT06C45BdB?=
 =?us-ascii?Q?0bsaSzWE8+YJNWxxG0ivSjnxZs5wuEsJ3oujKSt5iXIcuASZ3Sp4UAZ1EzsG?=
 =?us-ascii?Q?obkz0+wnL4RjysguGGe6bEYcRBnptC0sgkAP4GnwgqyKYY5bOpd/dpsV01JG?=
 =?us-ascii?Q?xj7rZV0Qt67fJSxXaPJfnibydaEJRa0QHggXfjSMH76aiCtCyTlkNxlOY50V?=
 =?us-ascii?Q?3kN6DBfgAADN6ZnFiTdW3ryG5dYSK3EqPQKAq70lckMYbnJ6DZp+1/PIolqX?=
 =?us-ascii?Q?qUNgIZYB9mi863RX2Um/V++trL6bjA6huwCvSEKVAlKYth4ShFSkvskT1LfU?=
 =?us-ascii?Q?2nSkzOUF+xmzKwo+U/ywCsQkb+EhdbzVxpjgr+psj7vM6e3IlVtN5FBkqaZm?=
 =?us-ascii?Q?3EaO58tTEw0XfBkJNcN0v6MlwC/GFQdhBakkaRU3806Gk2hG6m330K+3ZRrv?=
 =?us-ascii?Q?SWl9M85vhGVXXzx/lA9rl0ksjY3eN08bjMspxGyTWo8cvr2z/3VN2DTJNzdx?=
 =?us-ascii?Q?ye0hdmPQ+LKFjOhnF17stShrhGUN27AO985XNd3MyoGYSMSR9dPXhqTN5BH0?=
 =?us-ascii?Q?UIpoyldBhzIEWTpcJ+8n+sIxzT8zFkQsc4lM0dGRe5mVqffqa3LUgsr01ses?=
 =?us-ascii?Q?vjsh3a1mFyr1um/fYwII813dxCo4pE/kOZqXjU4vHXl9HbM0p/M2BGckc7To?=
 =?us-ascii?Q?QMdyUdDb0rpMubfOtu04cHUrv60p8pykcGhi7mmsxG3hIDRhbw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83395723-3d15-4959-d501-08d9167bb6fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 01:58:05.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wd6V41fn7AXUV5HgCOws794Pg291hatdRPkpT7lSSb2K3OoOkmoh1FkelPiQKwW7F+UhI74g+jOIALkBY7ogFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0813
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the=0A=
> latter is confusing. Additionally, use lower_32_bits() instead of=0A=
> open-coding it. This patch does not change any functionality.=0A=
> =0A=
> Cc: Benjamin Block <bblock@linux.ibm.com>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  drivers/s390/scsi/zfcp_fsf.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c=
=0A=
> index 2e4804ef2fb9..3d9a3dc4975b 100644=0A=
> --- a/drivers/s390/scsi/zfcp_fsf.c=0A=
> +++ b/drivers/s390/scsi/zfcp_fsf.c=0A=
> @@ -2600,7 +2600,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)=
=0A=
>  =0A=
>  	if (scsi_get_prot_op(scsi_cmnd) !=3D SCSI_PROT_NORMAL) {=0A=
>  		io->data_block_length =3D scsi_cmnd->device->sector_size;=0A=
> -		io->ref_tag_value =3D scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;=0A=
> +		io->ref_tag_value =3D lower_32_bits(scsi_get_sector(scsi_cmnd));=0A=
>  	}=0A=
>  =0A=
>  	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
