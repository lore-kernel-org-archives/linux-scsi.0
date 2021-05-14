Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1695EC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC0DE61415
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhENCHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 22:07:03 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:58062 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhENCHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 22:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957952; x=1652493952;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=mJIeOG26Gne9kosdPfGRiX5uPrBU9bXYrmv+w9CbhnA=;
  b=ZAlFmK8sfbFIoqxiY1cOkqUDm4vLw3rkSwoWaKKsgrlvi/khwSD1eAta
   fsbXFVSDl0wPCflhy5BE6S7urxmolEvqU3ir5sbVZhcG3y1tqlrW6zcwD
   fwvDUIHuLK1KPVSXr0CFNV88MDG+JyflMsFe0NBtPQOxPDPeCi/ak3XQx
   Z88vSjq6hmgYlSvnKlMHxr6W2cR4VXl4JYvfwIsLtVaEp3scELeD4YZzS
   UE1eBtaBfsxcAYloiBj7/ytXiFW66IqBjAjYyMcrHb7zzTL5uinNMVW+1
   nqHQQMXfyVS7IiRCwN3YPsZuv7ueA+QsHjb5R8brHQMZNsnFoOGQQ0fpb
   g==;
IronPort-SDR: Gl+r8KFzjrnSurvzHZSHapUobZ0m7xgVbIiJXu2GWah8VtuWVIZoCWWXgevu/mKE35lLhllISY
 nQXCu8Q8K0bTppDsT2BJ5I3eKz3q0fYEgmpoLVw6yzEmFXIb+eYP6nGPTDXvD1vjPNiGsHJ+fi
 Jfm2FCtrK0E9d0n+xeWnWpp+bYqm1kohycNtLQaJPCr2ee6eSHRd3UYwJ45UJHcECeHje17VoF
 lMTGQd9rEKlDrytDZd78siOl5WgJOzKE1FTLwRZ++HqDAcNIJnnNBK6qjNYYCLdgyPOKFZoPcv
 yLM=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="172714283"
Received: from mail-sn1anam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 10:05:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4pfCTLgYQRtuDmlAgBeStZlFu0ifTNmObywDxXc+rHFlnduRispqO+/9R/atDn+Oovt1bSNSaEe42NlzbKv0sOHFoUtNyDWQEUs74fY+xtqPOoeejMWMhnW4M4zqrM/aiX7x9jbUjFW04JISGtBAN0JNOSQl28N2Ma6SC4jJ/6T0rSud7j88+9v4TencviEH9FG1ahdmA7tliHS/a+e5eJrXnLA6opZyRSl6u0OE451VQ3PzeTgDDXiU9Cve5a9cMOxYW2LRu6ZhZ+ap6FCmmxDj8eR7PWIxsGzeTGm+W8yeeVmyD2+SaRGFkLgTYenrbEOqQd7p9bwJqvRqqp/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJIeOG26Gne9kosdPfGRiX5uPrBU9bXYrmv+w9CbhnA=;
 b=SwgSJ3CQppRdyoadf+cC3gJnJ4l8+haa/5ce5yU74gEoRvDevIDk8F4jeDXZClC6BPYGD8HuJCZQm5gmg+qKh8z1HDRxRkXpxGYjfS7DATlMUGfi4NL0RlBqm5ZnNPWoRbgWMmAZot6lhH2/B8CkekhbXM4hpedmwcZ9Uv71cZngvccEeurInmQrXBPu5NzROQ+4ZLd4dlV9qoVU9aL2DI5Vwgq9thrTSp+04AETTg6dWrfMqvgdUDGNCdprOComqUjB83BdoOP1k8SDfCVp26Htgf2bEIXqy1JXyAIWRoxWsgB+0JwY9d3JMTA30RrgCxiOQJqPMcGmdl0TAyJPoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJIeOG26Gne9kosdPfGRiX5uPrBU9bXYrmv+w9CbhnA=;
 b=TskfSQT+DTs0MxyhcXB3VSpK+gePjisN6t2B6H8n7SeR/AQjvADa2MQ9CLOqpt3SJ7TLiqUf7vcS8vYShyNmur1EM6GPPcfeWOPpOT+GgTuyx9SkwrpEWrEbIEhU/xVGs1KZnDCxkAQxb66JihiHnBLka1qJ7rskRtUcGkhz1f0=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5658.namprd04.prod.outlook.com (2603:10b6:5:168::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Fri, 14 May
 2021 02:05:49 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 02:05:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v3 7/8] ufs: Fix the tracing code
Thread-Topic: [PATCH v3 7/8] ufs: Fix the tracing code
Thread-Index: AQHXSEi0CrUphkgj0kiT2Sq0wjR3ag==
Date:   Fri, 14 May 2021 02:05:49 +0000
Message-ID: <DM6PR04MB7081584FE78B57432CBDA545E7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2180afda-d0e4-46db-cd90-08d9167ccb48
x-ms-traffictypediagnostic: DM6PR04MB5658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5658C0B423B50C5A861B29B4E7509@DM6PR04MB5658.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QtZXwb1eVDsWYQiH2i0X/kB5OTQJSN90Zn4GmbV8N9PXwCmsvO1y8jf/XzfDpMAaGf5rrOCkC6OtsFrop09+UQY9OQIvyNTcHNnQAdAmqPgso4mouPPcdAf64jsuiX6YGQOLFnLOEz0lKneMSHJgiqMEWldWSMHPZs5DZ7cB/gVk1PxMNNehaWyTCnBTQqp0cO0gSXD43oRUAIzgo6vM3pV1R//LvgnCjB/h2ed5MxL7Y6HaHIS/R+LbU7AaZGSqAzUKsknPCUylWVrYvnR7r/6JVmX9jLH0mDG4J/fLwVW7ZetcUirk9NQVkF7kOcWsK7O3Ulvxm7yH56wQmErDmMew4Ta3FCjb/CjJRqyWsn3MC6MrjcJDmwHLvFeiH703q/VfqPuIkrcV8daZNMAe58lr8Dh6snxi1lc61LbQThFokCFQbwfUIe0PpNUaPwrcYl0Xg+3UooNQqIApgA4YLIyqFGFJFYzp1u6FUY3FJnNhFJx2B1IGHL6Hx93HMZySXcMlAo5NxkLiX1HKtf5IbERT+eLv65kI/x0RRXDrw/4RUAwflQzOWBWAbFrsrPOYuxTv2MQz74nZwGV4KsO1oQ0XVmaMoI2HTmica6V21G0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(478600001)(110136005)(8676002)(186003)(38100700002)(316002)(7416002)(5660300002)(8936002)(66446008)(64756008)(66946007)(4326008)(2906002)(9686003)(33656002)(54906003)(66556008)(52536014)(76116006)(55016002)(4744005)(91956017)(122000001)(83380400001)(6506007)(86362001)(7696005)(53546011)(66476007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AYuG+oLeAMGiarEF1qjDwaMnRYn3K3A5Wh6G1y7Ual6SNzPnV2ishDO4qD2y?=
 =?us-ascii?Q?QX5V7PiUiq5BZloR2qdgJux1Xzyzg+KTw/7VcKZ72WHArbgTk0BpdNoVd83I?=
 =?us-ascii?Q?mtuUXmXccmuYMNXe4Uu8gtngeH7YwvMXS7G9H3SnWPbf1cBSmmKafJhpP6x1?=
 =?us-ascii?Q?LX8NSmX2w2zyVTut2PUJ/wITHf/ChGKwyDGnorRWHJhCVifPPNWxtTfUJICi?=
 =?us-ascii?Q?AFtUaBeQ4IL1rId9x0r4HZLIuJ1mOzhKl1zuAd3zEVURRrF60EFr7mLQM6My?=
 =?us-ascii?Q?S6T+j/wYTlQWcUt+xrWUuss+PsoJO9GvNc3uwWx8U5wyE8z1q5Jl5qhmbnSG?=
 =?us-ascii?Q?L97EUKKc6CSgVmxVdaNGkvGEah2otkeUTiMik67EG9AU9ZXssrJU3ocYa/+D?=
 =?us-ascii?Q?ytAKOLhfbVijbU/gZofSpy5EeCKEajA48btPIz4dh2AJaKohou4yqYfP9JgZ?=
 =?us-ascii?Q?SJtotQfXAiwyW3AsEhQI16VypJjdFDby16L0l2in++he02/oX8RDfv+GvPCL?=
 =?us-ascii?Q?DD2HicTGrh1rT+Ola1xxmK+DQ4AWepuORyzpQEA0S1fNGTSkLbvB0OTr6e8r?=
 =?us-ascii?Q?mtzl9IdvHMHladDCHuYwEMOXYl5rG92OIz2pMUdi3hj9NjHXMcNfezsa8y+k?=
 =?us-ascii?Q?x5fflNFb4u3ul2dH0vEPL05ut+OjtdbxdQlgwS2WUDa/yfi99zhjBWXHirzt?=
 =?us-ascii?Q?CJe8Vf+Ggazi8yLR9oMPwUh2aA+miJBkHp7xbLTLbv8Hdxl3wG17gS1vQRIv?=
 =?us-ascii?Q?HqDum+qSBXSRPEjilppT+29pTQtwv/qHlephQApknVbS0AGM3f2ro68ZHhKI?=
 =?us-ascii?Q?oY97KM0xMRUOLj5TNexvXKrT/SnsFWXY0GZ44EzVeffCSCDGYq09Ap2qGMsL?=
 =?us-ascii?Q?tLJJj5yqIbQLvIS6a7oy5Lga7r+nO9mceV6ZHZc3eTdoU9r7QQWRfppOb70w?=
 =?us-ascii?Q?pRU1d+UfHlAQJmuqAncb2ABnOVwb6cVopez96aTcJj2PiwkXesdDwMYVNQjv?=
 =?us-ascii?Q?2jg98uwxpvxOm3TVIuLK9P30KLtyJe+r5VYPCg3nECZKHGLJgbwqJvM8s8m1?=
 =?us-ascii?Q?VbpIkNZiYtBYoV69SGMLPD8GeGLCIJs0oB01wsP5IbscB4tvT0nJkw/SHe+K?=
 =?us-ascii?Q?xdyCCS1BUzAtX3uveUmoT+yOkHh4DGD8OAmWNd6X9+j0QUA0u9zqbFaYGF0e?=
 =?us-ascii?Q?QVXkJUE+l7cD7OkIsXWVRJ/2oy9hAmWdff02xogADCzjXTmNsk1ArJXZ0zYX?=
 =?us-ascii?Q?2tY4/rhjGxfDKN/cDTL3WZfwwdF8CaAkIL6wEOo1y1T4Xd53HoltY0jPA/yY?=
 =?us-ascii?Q?ixGRFObGAdWmJIZ2C1YB9r+AZ28/lKoYCFdKghiKQGDY9JC01rxRDH0fvVDu?=
 =?us-ascii?Q?D1xwAPWQz/d3BGhVHRUgSIGI8xkaKEtIkI4Sd2PiT8mFVtL6Cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2180afda-d0e4-46db-cd90-08d9167ccb48
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 02:05:49.0802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qaUjyzKfU8pkgilXdltJZ4E9I6H4i9eogKk2l9m3SQXqAYLy7Ob+sJm8Kso54l/e3J/spZFWF2PHgZvFuAdMYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5658
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the=0A=
> latter is confusing. Use scsi_get_sector() for all SCSI requests since al=
l=0A=
> SCSI requests have a block layer request attached and hence calling=0A=
> scsi_get_sector() is allowed. Convert the scsi_get_sector() result=0A=
> from sector_t into an LBA with sectors_to_logical(). Since READ(10),=0A=
> WRITE(10), READ(16) and WRITE(16) all have a GROUP NUMBER field, extract=
=0A=
> the GROUP NUMBER field for all four SCSI commands. Apply the 0x3f mask to=
=0A=
> that field since the upper two bits are reserved. Rename the 'transfer_le=
n'=0A=
> variable into 'affected_bytes' since it represents the number of bytes=0A=
> affected on the storage medium instead of the size of the SCSI data buffe=
r.=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
