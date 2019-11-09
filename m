Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85655C17442
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF81214DA
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:55:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FWSu4Xwv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EwAYo4YD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKICzI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:55:08 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:34425 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfKICzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 21:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573268107; x=1604804107;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=2CAPminhokyXBAnTQaASgCgNQTj161ctQG5mRFnIE2E=;
  b=FWSu4Xwv1VyFyQ1rp19kfsi9jMCZ3F3XCWZ0go4mmvT35QEIInK7Zc+f
   3Fpw9aa7dPt/yAOspVtaXUvTjWN4c8Ut0wbvqy3xDcQYUcRaQSWu5ByBf
   Dkh9ESVcmzx6nhHSTi0ss8ehH2fVPzsKhgDXAwQRpcmDgxKakn90PhF2B
   YKcB8w1b8Z3q8Iy0Pq4jFb5qhYYLoIQzPiA9VufgN3ZtKYY5CK6930bwa
   1gcgHEpF9a496d2TjloRfpCFPQqPZVF1xCbCQxvUa+Q9cylqovomQ1/7i
   /dzX74vW8kFlUeD6Bv880kv9yKtoFmXz5YTO6j+TltLGInv63f9zOLLdP
   Q==;
IronPort-SDR: JbZqacJYvB6LIVBQxQobo+fNuKz77tZLPVpydHynQd9ADS9UUTawx27UIlL4j86mxleL/IJGrp
 pSMeXuPxIGI6XLmI4p+ymggaF1GPxSNhNzN8t817MmBSdcRbz9B9nS8Vqq54ejDm6fbgn8jdAr
 3hLb2kh16miRoLaSS6+oSxmiWetPhLF9m5X3V0/cPDysAAFE6YwID28PhLFAu6Bz3MUcla1s2M
 LH8Cf1iQF02wKlshYb4EGozODNIAyvfhxfU0k9ZPtgMVwjHB0XZneV6MqGbEjzNnoiQziBviqh
 470=
X-IronPort-AV: E=Sophos;i="5.68,283,1569254400"; 
   d="scan'208";a="122553191"
Received: from mail-sn1nam02lp2059.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.59])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2019 10:55:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvQVQusr949NOG3uSXhIvsu9RwBzOUWrQ6wjDaihq1gwN6hAzwGL5d10tjkn1+Xfu2o/L92z8H+Dhubx9EkWet4EZaNdmSFhX+B6333G3oeQ5v4wWapGJUyV0QoHqUC8n7DvuTZblY68yw+3Jcx0LsDSxP2uKum4+1+Czl+LbpVWmddBbzHO/R3CJ7Y9tPgx6qB8WglCcCUS8iwBfBIlTUekmR0ApACFwbzQ0vShF/vUNohFMIyZDrA1O+l1NwpRsKppzQ9O/6Oz9iW9JJmfgDD6T3gpQ37AjIC2SgvgEPQBW3IqtJClCl+zfKVXhQvPd6s9OQ1D3oPbLQGn/DsZfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gjk9nOJ5UJRbckE4eVtvNGUBa32Vm2r1cGh+n/nsbfs=;
 b=lS0GMqjF2ARMAyIsqZel8P+vpiTWLY8V/VvDDjKKLTgtEHRJraoOu1MjemTYk3V3CTvxrSKZChtLV25thiIVSVWR1OPAeKtCWQaMDVVL/P9f0sGzQ2j8o4KXqH89LvUwfAjEU5Z4r1xGC82nQzbJGrzlSa3z3zQ1GolQDTcfSGtwdFBizfTZtrKNNe9kvT2ciz2fz1zW0z/rDCgRf9ra9gnumHmDmIwUvAWb0Zl7gtbEzPEf5FG1Zl0IZSApPkdwcwuUp3Y/VkCTxceAYJI1JO9CCn5y/3cTmnZvqZCeXjeQR5T3LbnL4yqhBQvtlnrGaglKHwWpKWUflcUS5nnvPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gjk9nOJ5UJRbckE4eVtvNGUBa32Vm2r1cGh+n/nsbfs=;
 b=EwAYo4YD9E4JaJ7Bjq/uIjm9K4oQ9d2Yl9twNYk4BJstb527/HpeMbLTQozEqdPgSoAvNOxFp4MBPcDxJ7m0TAcieZpPVZYQ/al/5oSZJdrvvN6gX8LwlAOdKLg5/NAEyZknbytCNbl6TvgvMC/tPN9Z/zPYSv9PV8ZTdP/1nxI=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5399.namprd04.prod.outlook.com (20.178.49.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Sat, 9 Nov 2019 02:54:58 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2430.023; Sat, 9 Nov 2019
 02:54:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [dm-devel] [PATCH 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
Thread-Topic: [dm-devel] [PATCH 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
Thread-Index: AQHVldffBc5Ki7sIvUSBN93lS3Roqw==
Date:   Sat, 9 Nov 2019 02:54:58 +0000
Message-ID: <BYAPR04MB5816C442BE08F9973C2CDF15E77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-9-damien.lemoal@wdc.com>
 <6a1e0a08-d65c-b075-9bac-23519e9e91c3@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2ba0ce0b-ffea-4a0b-a89f-08d764c03522
x-ms-traffictypediagnostic: BYAPR04MB5399:
x-microsoft-antispam-prvs: <BYAPR04MB5399FE791B868154F480E0BFE77A0@BYAPR04MB5399.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(199004)(189003)(229853002)(186003)(2501003)(64756008)(76116006)(7416002)(66446008)(66476007)(71190400001)(71200400001)(99286004)(478600001)(7696005)(66556008)(256004)(14444005)(446003)(86362001)(476003)(91956017)(66946007)(486006)(305945005)(7736002)(9686003)(74316002)(3846002)(6116002)(4744005)(33656002)(55016002)(6246003)(14454004)(6436002)(5660300002)(102836004)(76176011)(8936002)(2906002)(81156014)(110136005)(66066001)(81166006)(53546011)(6506007)(316002)(25786009)(26005)(8676002)(52536014)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5399;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NpsmcKm5loFjUW6HJU4oa8eVTlqHZQdoDKtmbkCEAbxh7CL61bPKOJpCWkk3qQoSSyHpYziMQroipEkP4hJkw9Q7awq8/nzwgMpu6XU6tCCJbgZhY8BXyFqBPiDpBJhE6lFKdsLbegeYKuo1uoYIyoLs+0Vbhf9Uu/nQ7x+W7PgtQonwEJi/hs4qME0WgZIr/OH7uLHKWIlXTmxSVO066e3XP4jqL/zCjkpR5rJn0/0YN+8ND11LZbwUVfcZhnl5lHyZXDg7tHbumfeJsyqP0uPJ4P48KXf3hMJnvMbyQ/AmwLkx7M532F897rMcTMHG246QFZgDVqkUEvSJFAJfaRDLBxPZgsgoUdFus5xwjmFxvMx/Na9UaEsm+7DjYkyjYEjdPfXDf04Ji9iljJ8+a8cFqiVBO9UAzf5d3g0h3awcpRXgBCpPWhEPlqSDCejk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba0ce0b-ffea-4a0b-a89f-08d764c03522
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 02:54:58.2627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfQqGPa7XDHQA37emap82qTB9qdIx+KD13Nnm6OW+Gn/zHGkRIgJbb+FuV0dfSWUTpwkj5OenBPYLWgjlSWEgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5399
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/09 4:06, Bart Van Assche wrote:=0A=
> On 11/7/19 5:57 PM, Damien Le Moal wrote:=0A=
>> -	buf =3D vzalloc(bufsize);=0A=
>> -	if (buf)=0A=
>> -		*buflen =3D bufsize;=0A=
>> +	while (bufsize >=3D SECTOR_SIZE) {=0A=
>> +		buf =3D vzalloc(bufsize);=0A=
>> +		if (buf) {=0A=
>> +			*buflen =3D bufsize;=0A=
>> +			return buf;=0A=
>> +		}=0A=
>> +		bufsize >>=3D 1;=0A=
>> +	}=0A=
> =0A=
> Hi Damien,=0A=
> =0A=
> Has it been considered to pass the __GFP_NORETRY flag to this vzalloc() =
=0A=
> call?=0A=
=0A=
Do you mean using=0A=
=0A=
__vmalloc(bufsize,=0A=
	  GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY, PAGE_KERNEL);=0A=
=0A=
instead of vzalloc() ? (since we cannot pass GFP flags to vzalloc()...)=0A=
=0A=
Note that this is called with GFP_NOIO set for the caller context in the=0A=
case of revalidate zones, and default to GFP_KERNEL for=0A=
blkdev_report_zones() unless the caller also tweaks the context memalloc=0A=
flags.=0A=
=0A=
> =0A=
> Thanks,=0A=
> =0A=
> Bart.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
