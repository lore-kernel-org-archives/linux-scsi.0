Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C13C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 02:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7319461419
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 02:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhEMCTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 22:19:38 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49900 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhEMCTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 22:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620872310; x=1652408310;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3LikOZGs9SkrM/HwZxR4TWQrwi44F9AP3FC3blv98lI=;
  b=JnuOF4Sb6MTuekhkJPOlT8s/ZXj/mzFp6F6OJzSLMqy16IZApJMEmjOu
   FMtxWrZDLXU5k+c/xvBdEpDNZIaY9MBWqXWSl0+XnQ0Sd00QLtgysmXFC
   zBnwios5K3uB3G4dwei/lvS///ZafopiXyN3Fgzd30kTkxQS6oWfyRRi6
   BiMJt6bFz0kXuSc0kyanGlK6q1Pte+lEVx1PMOSRYOuOdnWvNbnYx5BUy
   0wubAm6V3Gy6fstWqH81da8rvMevCs3nQ3Ml20/TQuYMcwdp8H9NIS+k3
   tJwfzKlXn9th5CLl0vvBHhIrpgG7P7H9eE5ErqNCpxzwHqTKfJBSGcYcA
   A==;
IronPort-SDR: 8t1KCUowB28NraE7jw2a5ykScdmLjoAqwxndvo96wUvo6A6xWKs/dzC7DwWKRz7gRZ+LUg5tQt
 e5GcwOqZsXBizoJdsmsC0A5rLXXSxfCrDFTE8938b5BEWI24lFzG1rveaMa8I6RXRjar2aTOMH
 fTgM9vXVn2i0c0KC6b1DRXfO1UYeia/9a5r+XJeAYeuBXCW1I2NUNjgG8ugJZP5NITig8M31/n
 9dkQznTWDGkedvfl3BLVNieD3+CJOHcwBN1hFChJs2nVjGumAj8b05n01iraLH2cxiFX2DyuR0
 Vrc=
X-IronPort-AV: E=Sophos;i="5.82,295,1613404800"; 
   d="scan'208";a="168545613"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2021 10:18:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNhNHXHiz5SeEXE/B4evfk+Kd9OjmJGf/bLMfoC1v31yYFwWe7J7Pvq/It6/89a3dVjNPBkL3wgyfD28GnMqdSio0Uvr3wJINVa8IDZvqXXheGogFWQuq5stL0FmKxriyGiDsUpVgNNGxu09crAwG1fSS9siG3sO6sgAeSbRFcZ6YteJPBCsVImwoM9BvaGADPISejeqrXUMXkXSrEjVt//uPRR3h2i6WoQXwkMlCGTPfbaJcK7K2HIrw93N5EgaSxArdkMRoJAUdN+M/hMD0TveiCVr+F20EJxEL6QAsIc0ejOrD9Rs9xLM0pLVXOPvfuRb0WbXT8Xiv1TW1QnMDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1vUWYVtE3TRZIkOQQPlicCELItlV0sZsJOGfzJehvo=;
 b=C8ktMgGk4dFGHJl6fIFbPZqvQD8vo2//o3excYvi1lvZAfLD3SS5Ph8bfkCBv2tNV8uZLMVaWwv+JwNyPPmDDB2q6Kc1VCYPxEUEHcy6b5n4XNL6GyT0Yoy9GMLkllBG2jd9S+O0bULD3jkIusrnW5GaaJClDQWIEbUaavoaIWt0oKCZG+8yezjJHX/RSf6AJk9oJ9WgwcjymDuNLwxsbCGNykxg6zC95/yQn9iMuDbuWBaMJ/8Cy55YAwjPVHF4bYqAuPFzFEGrGvAVZdByJoWwEAo880orog7M18M8hZM1m0rfHiZZaVjfuUzrjniBNMVgodiOBeJ0N5Idj27SHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1vUWYVtE3TRZIkOQQPlicCELItlV0sZsJOGfzJehvo=;
 b=ZatAsAF+nJO6AeT+Ae2lIxgrptK2ikjV1vS2iZ3slWqF51xX9DWiBAs9xXoYB3aV6PexrJ4qabPwPGCw4YUCPhyLemJwGBGaGES1Frn1vUV3cXWZ6YhDvpe0z1eo7G1cD0IcrGfsLtK1xo5hY6F12ga6/Zbb5On01zU8sVY96oU=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5371.namprd04.prod.outlook.com (2603:10b6:5:103::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Thu, 13 May
 2021 02:18:27 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 02:18:27 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
Thread-Topic: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
Thread-Index: AQHXR3kgi8EHa43bd0iJGbipmimK0w==
Date:   Thu, 13 May 2021 02:18:27 +0000
Message-ID: <DM6PR04MB708186DD35EB12B26BC9CE60E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512200849.9002-1-bvanassche@acm.org>
 <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
 <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
 <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
 <8d72e969-44e9-5453-70fc-c9cb0779634d@acm.org>
 <0c2d87fde65e40f34914e7555d3971f7b2c8f28b.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:dbc:763e:6fbc:5b5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d30ea6dc-5f0b-42ac-a072-08d915b564cc
x-ms-traffictypediagnostic: DM6PR04MB5371:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB53717D02C341F4322DEFD235E7519@DM6PR04MB5371.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l445pVcETPOsutpre37YAo0BwX1eZtVZyZmpFGk5LcbJn3OnUdgDnGUSIamb7je/GlAylm4/s606LT6ZriXtgRjI40KFor4ZqU5MtzRXUWgutA2Q0nzX0PuK5860bqvlaQz5OBs3kyX1mRZb5op4GXcxL0uSRI4Tqco09tX3bPYDDTuh0lGyBaquxPXfdJt3eLEBj1cUkdqOdvi5l9wLqjYOmKVU/DcghoynEwjpjX+tfx44sT1Semj5JkX2UciNPPGixsLoHerjXftqhCBXz3ayfDiyjNvQ3pIBLcobFtwCpRCGngNRcC5bGFAeznQrzqa2n+0C1gHpojjnmXJKF8wJ0dZfAMKsM1SVdJsXJmL9HWbS3P/Iepv9iXS/EK6ml1HWAG61QuLnCFtEWerrPo8HaTHO1WG2RgltGmjc1RnYnPjQ163sJoIKEMKI89dNcPqKny5JrrU0BjoOrnmovsrBIb+VNaQe1YqLq/2vWIx3EAEkjn6gu12Gc3EY7zhT8ajCkqhWB+zMC81Gqqd/tWAjY936pcQvhSQsqDCaSxNNJzljnuzFa9rWXCsnG8l8dMSfA6ahrqKXzauTUhWXerOtH/oCaTiSf4l6DQ0I+V4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(91956017)(66946007)(76116006)(7696005)(66556008)(2906002)(186003)(66476007)(53546011)(6506007)(86362001)(55016002)(66446008)(64756008)(71200400001)(83380400001)(478600001)(5660300002)(38100700002)(122000001)(110136005)(33656002)(54906003)(8676002)(8936002)(4326008)(316002)(52536014)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6iKnkZTgJs+xsV0eMCl5MRv9BKu9ub9I6/d8sqxtSPAN+68vhBJ+noHOt7k3?=
 =?us-ascii?Q?FF0zs1DrpMhI+ScUIrEPsl5TDLZjj603TYVV29PuwjQNZwz30flWnxCFwZXb?=
 =?us-ascii?Q?ZSXkz/fNL2rKa/lqA2i8bvvHmoDsn3s063rgIKFGM9nbgI/zqmE/QSkHofwH?=
 =?us-ascii?Q?nm8xcV5LGkH7zELe81JnU2cpQV366z8lyN4UMyT9jaYnn6aQqBR+/kxSIdg5?=
 =?us-ascii?Q?0jzPGThfXIGvfq/jUyks+HkUL9T7rvqyBzyHKhh8oZLeQ61h2oNEuAa+oSbk?=
 =?us-ascii?Q?JX5djfrxbF0lwTFUcbiKIYxgEw/52DpK4JToXmb1DT+0gvYoHmzpoHCwdnOf?=
 =?us-ascii?Q?sCvO1LxYbUqA/au+Tu7QnMLhv7obpEtZ4agRY5WY21tX4oi8HThleYwMw4js?=
 =?us-ascii?Q?BzpfAK5xWaHn9Rnryt5h23Wd6ZU3mP2ymSXObVpKQNwPRY6TCvbd+Tq6Sv53?=
 =?us-ascii?Q?W+EYtG1w6UCsOghAYY4AXLCnnMwvi6V93qLVW2bCCVDjha2LGlXK5I1dezql?=
 =?us-ascii?Q?pSHBoeyrn0ObkVYocbiAnH4YEhYSwgo2KRBPhfdWrpCg6HpeUJq2iotryV1e?=
 =?us-ascii?Q?8PaamDdhVF5lgTombvWbfL1fLkosNvCodwZ/hYaknwtorbz/rH0dvkHcVDJV?=
 =?us-ascii?Q?Iad4gE74JmL803AhySk7QmResCQrum4ESaVvvZBhgP33R0aUd55zhz6Z1ZgE?=
 =?us-ascii?Q?9E8CQMtpVAQ/STUVIRjhiekTt4yFlb4cP8nSD5Iyh7OOchWmvPUXKPzlnvnl?=
 =?us-ascii?Q?6moQSY7NbiyDdLQIOxikuyDNTvgHvx9bO+nNNgype7hzv550l3PgMzjOnHOD?=
 =?us-ascii?Q?U/XnyrBRBSANzbeiBQbgL0rhcQvUl+9cuUSwlEZy8mAK1ttHLFEVUX/NKQr9?=
 =?us-ascii?Q?rQ3MpkW5sIlPn7AFuCwhjAAMpPM/5Q15XJLXdg6rF2ODvvvNZIWGWCU6gp2J?=
 =?us-ascii?Q?4dbfmRTQjlufi7YyRYg5cE7ib8hi9wH5sxwaoAu8Hrirz/YCcNEKL07MEdI2?=
 =?us-ascii?Q?lOcBEgR9VgDyP5SX+rbJ5RCBo3lxrRzMaFUSqODM6lcJGQLLPYNN8pwBtwMN?=
 =?us-ascii?Q?4e7XRsgpxxr4Z7PXjqIH9G2CSdFwA5apzWEjo4Rk54UkLUcVMSFahWzDFeMU?=
 =?us-ascii?Q?GCUw8myA/0rFNY8UlyM3usv67xHyxKpUn/1ywjQZ8pT8RfyPiBHc9L0YogVp?=
 =?us-ascii?Q?021GzikA3mapy9H1uZ/0M3A2tzoJHwRFpE8mLeGO+ke5gcWeCV+gpI6q9v6A?=
 =?us-ascii?Q?8kTdclF7P3V1kyMaXoaRpIJn2nY9v8hjEHeZ2K4tyicz8W29+nL7vKtqsIkJ?=
 =?us-ascii?Q?39m0Bv/4du8kzyMHB4CkrGEVeF13KZc05Rf2bZfVVv1ir+wSEIZ5Z/kmVKpq?=
 =?us-ascii?Q?2sq3MoeMcVKZqMGoehs9B7RBg9eOVxDSwIX4XC4uBI7Ke6y83Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d30ea6dc-5f0b-42ac-a072-08d915b564cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 02:18:27.2583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +MlLbxM5peOh1ygy2KV+q6GQoHehnoQi2MBqtn+698BuZ4FNjQPS+299SLIdU4xwLiOzRsiWziIPlH5uKbhgRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5371
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/13 9:14, James Bottomley wrote:=0A=
> On Wed, 2021-05-12 at 17:00 -0700, Bart Van Assche wrote:=0A=
>> On 5/12/21 4:23 PM, James Bottomley wrote:=0A=
>>> No, we support physical sector sizes up to 4k.  The logical block=0A=
>>> size internal to the kernel and the block layer is always 512.  I=0A=
>>> can see the utility in using consistent naming to the block layer,=0A=
>>> but I can't see that logical block address is confusing ...=0A=
>>> especially now manufacturers seem all to have aligned on 512 for=0A=
>>> the logical block size even when it's usually 4k physical.=0A=
>>=0A=
>> Are we talking about the same? Just below the code that I included in=0A=
>> my previous email there is the following line:=0A=
>>=0A=
>> 	blk_queue_logical_block_size(sdp->request_queue, sector_size);=0A=
>>=0A=
>> where sector_size is the logical block size reported by the READ =0A=
>> CAPACITY command and has a value between 512 and 4096.=0A=
> =0A=
> That was for devices from before the industry standardised, which are=0A=
> getting harder and harder to find (In fact I'm thinking of making a NFT=
=0A=
> out of my last 4k logical/physical disk).  But it didn't alter the fact=
=0A=
> that the kernel internal block size is 512.=0A=
=0A=
struct bio and struct request use 512B sector_t unit addressing. So does th=
e=0A=
entire block layer, file systems device mapper etc. SAll users of block dev=
ices=0A=
use this unit. Yes, that is fixed to 512B, regardless of the characteristic=
s of=0A=
the target device. But to avoid confusion, we never refer to this as the=0A=
"logical block size" or "block size". We use the term "sector" and reserve =
the=0A=
term "block" for the device layer.=0A=
=0A=
The logical block size (the unit used for command addressing) may or may no=
t be=0A=
512B (it may or may not be equal to the block layer sector size). These day=
s,=0A=
most HDDs are 512e, that is, 512B logical block size and 4K physical block =
size.=0A=
Lots of SSDs are still 512/512. 4K/4K HDDs and SSDs are gaining ground and=
=0A=
spreading.=0A=
=0A=
I agree with Bart's cleanup patches. They correct a non-standard use of the=
 term=0A=
LBA to refer to a value using the block layer sector unit.=0A=
=0A=
Bart suggested scsi_get_pos() as the new function name to solve the confusi=
on. I=0A=
think that using scsi_get_sector() as a name would be even clearer about th=
e=0A=
unit of the values being handled.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
