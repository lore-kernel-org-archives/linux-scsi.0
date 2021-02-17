Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE91C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0845764E42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhBQJTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:19:46 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25461 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhBQJTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 04:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613553584; x=1645089584;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jaN/nlQijLzw7G1pGEfMhTmu5+O79aWAhQb1PS6QUH8=;
  b=P/+nYa43C1Fc0+v92qChT00znaxCcy1D6c4XS0QTylCW1jfCGJfdWVXO
   sYH3+F5zhERIMEOhA+oNFeDcg2M1thY3mQQO4ybSzTeKv5av7ABCsEx9m
   JuB4+kHds0c4EZ9JWqI/1t/DfsiwwzcmjHQQe7ZH3Iyf5uXTZyml9xFhg
   PvqXcgngDHtMvc13OOmtJ9MxsFKbEjXM0iWlnxRB8DjkIYhbJDUUkisvM
   AUqizeiLB97p8WZov7523OcVJrOUAHN/k/Y/6EoxQAIBllshWIsGilqu6
   mUI03DtTfmjjo/aQKtvkIlUnHhZjQHJFM13OHy05JkxmZ9+kH4wNcgA50
   Q==;
IronPort-SDR: zHSMsptzc09Wr3klEf0E3cDTTyhoXvOrj/Gau/nFfWqcM4Mnb72MMUK2jbB4q8SoKo5VLG7UWs
 lJg0gZ5DUGyRocsribQoKBeudyVp4+64I6QPDb6xZf7PZ9H8QCOhIglwLeRFva3CuT5XlRfgn/
 vmw1u6YXGA8IPfjrxTAJzK/C3WhrpeMoFYyJNgwIsyXhZASqag3gT4RiPgT01n9E0QhmnVihn1
 DEyOPpX6OPuOiGGTxgxgfPpNCt1JQJx1uB43xNqkZ+Ebv6kwEf+vxFC/1EQn2/CSsGgbo+mHkI
 yvI=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="161316399"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 17:18:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0XEc4ba24VEdLIad+NFhIJ6/+u6h3TUXfOkxuRNidxl0YRH5auyGAcBuNbZMKCgjQFqWr92h3S8kSq48ehl0GiwwaycVSLohbk+6QsPlD+eRHEKGA0fF+XbaXGBu3nBzWztzovCifIipw+kcImaVPBdLj/v5cSP1O48rTEAnKRqhmPrSjvjmYAJapiV1+YmMtefM2qFwRlSjM0wrDC9oDi/KX9Kcb9ePyd93+HeqrBHQOfc/7y00QJw+Nq2ntWiWwHS3SG3P3ag8Tk0WnFD9pjYmLf7K/XzkKHqQGW4pc3nSYxzttQsS5VsaIJNiKEuKXMI1QEdXLLWfioGG2cYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2TJZ1LIweKyvMsMgMjiOnA2kkL0T0N0SKvm6qHcXWs=;
 b=oeIhaXPHRGyK+YdvGAxJMxHV7wApZUTp2LD2+8o0lkJJi4YlqUvkEU1StX/hUD24zsCTEIaHW96BbbAKrPlR/9n88mOhbaahp6DyiZ//hMS+Q4jx2P8RIFXC6wYh1KhWmq66ixdM+5QES21bZ38U6oGpMAVbFu3K1R+25sAxTTuw4ed8m1QKvkYdjtBYViSoJvtphNHisfCerNzFr2khI3zjCMU2/Ik5kfj9w83AsR7iCq/b8QEOWEqW3/c1+EwB4i0RPArEyww0RqIpFvGf9jBe7HhwGLT16UGwxlqElkhrfm+Woch1G9OnmVDXyztzRsJOqV0FoQdO9yNNS2wYBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2TJZ1LIweKyvMsMgMjiOnA2kkL0T0N0SKvm6qHcXWs=;
 b=XUv7EQtAYOz/hClsX2BTyz+FSuqGli5ty2dfO6ZpApWnMKvfrTm/zrVvYROr4KxQW84sZo3GCv8OJ+MlUXoYmA+FN5FbjJ0E+ejm9QgqCT5Ra5LDAttAyGSkBwwIQrUPWxQxytwZUJNVxqzPZi2zJd1RIc5SRVx0h38/7D473yM=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3808.namprd04.prod.outlook.com
 (2603:10b6:805:48::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 17 Feb
 2021 09:18:37 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 09:18:37 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Michal Hocko <mhocko@suse.com>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJuZNMPC4HbBMEOENoattX2qog==
Date:   Wed, 17 Feb 2021 09:18:37 +0000
Message-ID: <SN4PR0401MB359823B2D42A6E31D5F6E5369B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
 <BL0PR04MB651453A8B57118B3C1818ECDE7869@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:1923:7af3:ae74:5873]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5b3d4648-4ede-4ad8-df80-08d8d325021b
x-ms-traffictypediagnostic: SN6PR04MB3808:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB380871E091C528C41481B3DC9B869@SN6PR04MB3808.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FUjI2hkWZRpJE5Dp+lhyGEx3epd1gHB2k360rq17hONNcz8ZMUjrvYXKJZL9Fcm2pAEHms++uR5ikRdVUSULCUjNegODOec4E1cLlf9CELQVRw510A436S3/Q+rjppcaqxjtuoTdUu3Y5Cz00GuNTHP5uXnvLSEGhGORk7VCbkOd3StzHk3TYVF57gUiLH2WAWD+nFYvL8piuquMHxksxP4fKF8uP6urB1qsJkRjHWwxlh8ifEzkhQQe7clKeMyfBqMl5cXNSHKMSBQ0oVjmgu9kjbNQE4nlq6DMEWIdVhdQ0GSpq77FVCxDC/7Vbi03ieV/VqDIcYV4cxZ/i/BbtasesoRpnQipgT5ndlPkyuv2BwQ/PU3np4fBf7Trypu026DEaXMANHYrosyi+S+BN/ZuVKx0D0jCMAT89utsV/6kR3vMM+m6JrAhVH/0pHLC/fvCkfT6O3F5DbW2PShpg2QeLlfWyZN+z2Ll7O+AAXXm06EjKP4yJfP+0xi8nTphVcC5rP1fwYwp8n3naEzPOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(396003)(376002)(5660300002)(86362001)(186003)(9686003)(66446008)(83380400001)(55016002)(64756008)(316002)(52536014)(8676002)(53546011)(66556008)(6506007)(91956017)(4326008)(76116006)(2906002)(54906003)(71200400001)(7696005)(478600001)(66946007)(8936002)(33656002)(110136005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Mhs4cKZxdDkFV1Fy+Hs0ZBRRdukCn3Jn5D+eUgQ2AIkJG3s65f4Qkazw0WHU?=
 =?us-ascii?Q?QEoUPxPAxVDi5eoUAt4wQnQShohxdcTla4yI8WbtKNa5tCvW0xa6tZ0a9E7F?=
 =?us-ascii?Q?2EK7Hvir7uwN45TdWJaT5XlDNsDy/nDFgfiJL8DY7Hhu/pQBCL9ISxUwWSyF?=
 =?us-ascii?Q?7kJYDfiV3+43OcN+YZ2PPnGrKB8J0Gu0rFi1GTAoYXfqWbl91amQe9ZVNQec?=
 =?us-ascii?Q?JydXlw0OYeS/Le0X000CUptI8LMYCoJfauM+dxIVaGa5hnt8CE4iVABP561J?=
 =?us-ascii?Q?RIuFSUbK1weSXszgp6j7DTWYol6CMKq25UAYHNo2f8oG304VVtZ23w4Rlu0L?=
 =?us-ascii?Q?zbl2GJtL94CHstZAHdaMK3ZEESXwhwor5ppUPp5pTyGNM2yFoTZxTtX5U2y3?=
 =?us-ascii?Q?hIFaaYgdBDVsw2Y/ttV0B25iLWLUQGA8x171oZe1U9t1puNCpBh9udiszjQ5?=
 =?us-ascii?Q?h3ML6nRccKVtDUXVtvxL0FYvxsPdNw22owJHX0/sK57OowLTtZVxCQl3dsFj?=
 =?us-ascii?Q?nAWCRc6lQj4vrE7C2FmS1w4ycOGS/cIKMnalYlRk7QAZ/tnkSg3vVnK1mgTE?=
 =?us-ascii?Q?pu5eIS4MzL4i+vowzd5xAypJUQIJCjtBoBCMI3TRry4fdnL7IH+D8n9kGcvp?=
 =?us-ascii?Q?26LS673a4b5TPx1WA11/AnX6+pmAbpFZHVNlif3MlZrBkwqFL29mboRn3OHp?=
 =?us-ascii?Q?H6GIGH6fSZ2BNy2/l2SrM5QdFAwvggd/7fkNq9ID4ZqUJR2m55QpY9f7uECr?=
 =?us-ascii?Q?GV8QmSNobPT1T8Mvgz/rSXXtEoGHJSzt6LWahRSZzTvI+Om2LhLI1aO19C3U?=
 =?us-ascii?Q?8DhBptvCFf9U6BNuRd6YgwMG+++Ee8s2sAMLsOuVQcDsbBkUemhKsHgeRWUr?=
 =?us-ascii?Q?Ro9zvAXl3Q31nFUvOaThYYNVqDBuIYFA2xNZfwjSMLmsZYU37uZtH7g+CNs1?=
 =?us-ascii?Q?9cgIXB40WuMFRqBEYPt6JRxr5uM3B151JHgkct9NNeaBlf30+iZ0B2rqEVWs?=
 =?us-ascii?Q?RlhNBVGBVytN9rn1P+brerl2bTmtr9/K7p9mJiQMA3JTI2jOHD7qm4KKKoF/?=
 =?us-ascii?Q?SEMLyrd/aVAI148Ap5P46l8ed6A1MzWuN3/8ggyeeLePf7494+UasnVUh3kw?=
 =?us-ascii?Q?RNrLHLlREiLeqXrpoQkciSVYFQS3LpINKECyw/XxDzeR1F+0ImtW4YBitKU2?=
 =?us-ascii?Q?A9f/yvWCq95iyuVMb6i2f5SBpBaezwxN7oiMzpMo/DpaXYFjSslANL1xmfh6?=
 =?us-ascii?Q?/SfUvi/lAmbYjdUqYfaSzzQXMvMDig8hTQWz+iTj59VW9fY9Rfsi+0lc4O2d?=
 =?us-ascii?Q?c3DvmYrNu6+nQiXSGkgwKPXQzKxjJoXbLxRj9ndTMRcH2XAgwLtCO5ryA4Ub?=
 =?us-ascii?Q?yZhJqPAG+EdViJAI9WWpqyNwXOhsPdZuTi33Hw9ej2PqZuVUWA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3d4648-4ede-4ad8-df80-08d8d325021b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 09:18:37.4737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l0C8Sq/C5u2t2UIplR/QyuyEIpn+99Bkg0gzcbc9fUKMx89SBD1vx/+m6GNgXqBT95VA6IxteghXEYQoFK0mNmJCM1robFQPZxBi9JMQK+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3808
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2021 10:13, Damien Le Moal wrote:=0A=
> On 2021/02/17 17:03, Michal Hocko wrote:=0A=
>> On Wed 17-02-21 06:42:37, Johannes Thumshirn wrote:=0A=
>>> On 17/02/2021 00:33, Damien Le Moal wrote:=0A=
>>>> On 2021/02/17 4:42, Dan Carpenter wrote:=0A=
>>>>> Hello Johannes Thumshirn,=0A=
>>>>>=0A=
>>>>> The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"=
=0A=
>>>>> from May 12, 2020, leads to the following static checker warning:=0A=
>>>>>=0A=
>>>>> 	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()=0A=
>>>>> 	error: kvmalloc() only makes sense with GFP_KERNEL=0A=
>>>>>=0A=
>>>>> drivers/scsi/sd_zbc.c=0A=
>>>>>    721          /*=0A=
>>>>>    722           * There is nothing to do for regular disks, includin=
g host-aware disks=0A=
>>>>>    723           * that have partitions.=0A=
>>>>>    724           */=0A=
>>>>>    725          if (!blk_queue_is_zoned(q))=0A=
>>>>>    726                  return 0;=0A=
>>>>>    727  =0A=
>>>>>    728          /*=0A=
>>>>>    729           * Make sure revalidate zones are serialized to ensur=
e exclusive=0A=
>>>>>    730           * updates of the scsi disk data.=0A=
>>>>>    731           */=0A=
>>>>>    732          mutex_lock(&sdkp->rev_mutex);=0A=
>>>>>    733  =0A=
>>>>>    734          if (sdkp->zone_blocks =3D=3D zone_blocks &&=0A=
>>>>>    735              sdkp->nr_zones =3D=3D nr_zones &&=0A=
>>>>>    736              disk->queue->nr_zones =3D=3D nr_zones)=0A=
>>>>>    737                  goto unlock;=0A=
>>>>>    738  =0A=
>>>>>    739          sdkp->zone_blocks =3D zone_blocks;=0A=
>>>>>    740          sdkp->nr_zones =3D nr_zones;=0A=
>>>>>    741          sdkp->rev_wp_offset =3D kvcalloc(nr_zones, sizeof(u32=
), GFP_NOIO);=0A=
>>>>>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^=0A=
>>>>> We're passing GFP_NOIO here so it just defaults to kcalloc() and will=
=0A=
>>>>> not vmalloc() the memory.=0A=
>>>>=0A=
>>>> Indeed... And the allocation can get a little too big for kmalloc().=
=0A=
>>>>=0A=
>>>> Johannes, I think we need to move that allocation before the rev_mutex=
 locking,=0A=
>>>> using a local var for the allocated address, and then using GFP_KERNEL=
 should be=0A=
>>>> safe... But not entirely sure. Using kmalloc would be simpler but on l=
arge SMR=0A=
>>>> drives, that allocation will soon need to be 400K or so (i.e. 100,000 =
zones or=0A=
>>>> even more), too large for kmalloc to succeed reliably.=0A=
>>>>=0A=
>>>=0A=
>>>=0A=
>>> No I don't think so. A mutex isn't a spinlock so we can sleep on the al=
location.=0A=
>>> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_z=
ones() called=0A=
>>> a few line below also does the memalloc_noio_{save,restore}() dance.=0A=
>>=0A=
>> You should be extending noio scope then if this allocation falls into=0A=
>> the same category. Ideally the scope should start at the recursion place=
=0A=
>> and end where the scope really ened.=0A=
> =0A=
> But it does not look like __vmalloc_node() (fallback in kvmalloc_node() i=
f=0A=
> kmalloc() fails) cares about the context allocation flags... I can't see=
=0A=
> if/where the context allocation flags are taken into account. It looks li=
ke only=0A=
> the gfp_mask argument is used. Am I missing something ?=0A=
=0A=
=0A=
It does here:=0A=
=0A=
void *kvmalloc_node(size_t size, gfp_t flags, int node)                    =
                                                                           =
                               =0A=
{                                                                          =
                                                                           =
                               =0A=
        gfp_t kmalloc_flags =3D flags;                                     =
                                                                           =
                                 =0A=
        void *ret;                                                         =
                                                                           =
                               =0A=
                                                                           =
                                                                           =
                               =0A=
        /*                                                                 =
                                                                           =
                               =0A=
         * vmalloc uses GFP_KERNEL for some internal allocations (e.g page =
tables)                                                                    =
                               =0A=
         * so the given set of flags has to be compatible.                 =
                                                                           =
                               =0A=
         */                                                                =
                                                                           =
                               =0A=
        if ((flags & GFP_KERNEL) !=3D GFP_KERNEL)                          =
                                                                           =
                                 =0A=
                return kmalloc_node(size, flags, node);=0A=
=0A=
	/* [...] */=0A=
=0A=
	return __vmalloc_node(size, 1, flags, node,                               =
                                                                           =
                        =0A=
                        __builtin_return_address(0));                      =
                                                                           =
                               =0A=
}                                                                          =
                                                                           =
                               =0A=
EXPORT_SYMBOL(kvmalloc_node);=0A=
=0A=
We're not reaching __vmalloc_node() if GFP_KERNEL isn't set. Also, from the=
, function's=0A=
documentation:=0A=
=0A=
 * @flags: gfp mask for the allocation - must be compatible (superset) with=
 GFP_KERNEL.                                                               =
                               =0A=
=0A=
So yeah, we should've read that before calling kvcalloc(..., GFP_NOIO).=0A=
