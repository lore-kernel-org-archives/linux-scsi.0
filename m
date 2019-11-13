Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73FCC17440
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E1192084E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dgDNb9Wk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Xj+aSUQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKMCkn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:40:43 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52209 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKMCkn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 21:40:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573612843; x=1605148843;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UOyFzuk191NyTka927CFuHmlBapMRxNyBOZHOt3Mb0I=;
  b=dgDNb9Wk2r7otszK9P59mDAGS01QFK7js39h5ooMtopAx0oNAXpaa8er
   KNBPbjZlsVzuF0YqGMHnom/JZ3Ebsi/CptkjJBB2lWMUJ7PivxhH0u6Cv
   Rdx3WQpJlagoa2z+k/LAHgJRCY5w6qsFgYOzJ+DuQx5Z0FNkcaDC74Wr2
   tGfl74tac7wVUS7neTmp4vHaFRJkHMnZcLZVGVuZXf6yfZQkS+HXQjm69
   DmwZFiX2O7zmfz8bOHnJ2X78zHWLs75fc8GpEU5Ml65O30TwWLZQCnu++
   14cJe6eT18lsSAu6Z9MtyS/U1Bp71MNCoGWnw5Eiav4ZlErLb5GbcDesG
   w==;
IronPort-SDR: 4/MjnpWoQzAUn/ubQB5/08QW4gKbD0Yi6zFOJ4mvbLM1F4AaPssX6Z4upVYo8kZP7aNY56KJmB
 JDJe3k4G4sBQfcOxPDSStXvpddmJkxsngIkpcxLEQ3UwvYJUHqtKNqetywFHil4g58fiiUwe9S
 Op8u/kM2e/e2bO5YkMvDdsa8JtwAnZFFFm1iyYrlE+eK/HgOm+8kCVwpJ/2yY3dR+OiLBguFMJ
 rvOo9Tz3cbAVVXgF16wW6uBhyacTPlzivU3QtKbLmXhswERcCFltmrlJadh2AnIcHp0mc75NIV
 QEw=
X-IronPort-AV: E=Sophos;i="5.68,298,1569254400"; 
   d="scan'208";a="123596481"
Received: from mail-dm3nam03lp2055.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.55])
  by ob1.hgst.iphmx.com with ESMTP; 13 Nov 2019 10:40:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5eMai9EfY9eaLTT2HH7l1O54w+i+z+9Jfq896tVIlFEZAJKwve7k1CE2j+NVefPvu8DiK3F4PbwKzy4avm1Eiy6rCjnoKTbZTxzOgmE2Zo05S/pxsHZc6FrD4IxaP3PsuCbzBZm31sCodfr1dmWye4eXtDTgn8zeud2nIG6BgZjs3vmk9hFD77W6KJzJRxjB3EbSdoyeodhyi2ylNi29tCXbrttpW0ahDCQ5CunuQmiMpTH6mN5F1a6YjglnKo3sP679VHMKUPMNT/pmslWqWp0/Bn0UXDchpzqTN0vgisS556cBZZzbjv0OCy3vpiIW/gDHtyIagkaurBe1Hf9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOyFzuk191NyTka927CFuHmlBapMRxNyBOZHOt3Mb0I=;
 b=iDP4xmReF3tZ1WSsBocMbhJY+j/6aVsUu5RqzbiHrM41aaMIq9yb0Id0C4MCEhKXbNIQ4XNYMdqe5fqoQdL3fFObtZKblHdElzJIFn6JtGogUP6xCwt6vRvlRRMIoSvzjsgDPrVRbeOZutrniVRBbAoSQyyfPRNCRo6jzb1dAeYDy3k5NeQDpR3ZIsWjksvS2oLnT61QBj8H0GYqk+k0j88KSR3QiHgUjUCDUOXl9f8M6S/Vs/XW7taTrriQVLKY7TpZvWKH8wSz7k9rYH5nYzvCB8vnVbQWPsRDnvsHXs353QSPt2LIVJTQhRm1C05QlydNn3bjiVnCb0ZSHAWLvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOyFzuk191NyTka927CFuHmlBapMRxNyBOZHOt3Mb0I=;
 b=Xj+aSUQPtlTt49cKOqT4jGV0NI06ceYIe009EKdWuN6ucXFQbxbTNbTMa4ByQxB+Hdyj7yq6J6n9DZbbCKmTcsWjtbA5sfeT/GG8FTG4YjE4gEoVyCdgE5fEA2NE4RgXKuF8+qpJXSZ5y/4YvOf98hNGyS2OKQq7BtY2zfP0NHE=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5303.namprd04.prod.outlook.com (20.178.48.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 13 Nov 2019 02:40:39 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 02:40:39 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v2 0/9] Zoned block device enhancements and zone report
 rework
Thread-Topic: [PATCH v2 0/9] Zoned block device enhancements and zone report
 rework
Thread-Index: AQHVmDlFh2i7Gy20+UKGQOmTx+pYMw==
Date:   Wed, 13 Nov 2019 02:40:39 +0000
Message-ID: <BYAPR04MB58165811E5614D9B0B122CB5E7760@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
 <a0c1c1bf-d6e5-8be1-ed99-6bfed3483d1d@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47d3c709-3176-44d6-180f-08d767e2dec0
x-ms-traffictypediagnostic: BYAPR04MB5303:
x-microsoft-antispam-prvs: <BYAPR04MB5303483A8913749800B37D33E7760@BYAPR04MB5303.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(189003)(199004)(2906002)(476003)(6436002)(446003)(74316002)(9686003)(305945005)(7736002)(86362001)(102836004)(6116002)(6246003)(52536014)(7696005)(5660300002)(66066001)(26005)(6506007)(186003)(486006)(229853002)(55016002)(53546011)(3846002)(76176011)(71200400001)(33656002)(316002)(76116006)(91956017)(110136005)(71190400001)(99286004)(2501003)(478600001)(8676002)(8936002)(81166006)(81156014)(2201001)(14444005)(256004)(66946007)(66476007)(66446008)(25786009)(64756008)(66556008)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5303;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8WsyXzu1M0XucnpG5Sa+BvI1xn9hhOK99sLA8Lc2VTfHQaW0VmMvcA81nF/lH2LkYvux8KPSb+SIepLHCXqVHmIes/K8NIsZuIEbjLVDOeUYZNZ/BeZ6CnR11q8zO9tphSbcAH7muEudbyZV1ZX8avgi+5f4vIioh3Ir8U+cOqzRQs0TQTUPxIddoDmeUZPz7UwsoS28Iifsx1Ihk/svHK1/bOw9udVzG8cAohEfn2Waf8mqvQXfFEtGvwHVE/jiNuMtZTALz9Lw7jo/AETcNHelzY+qSdqLdEckCcRc+zdvBc9HtXi6CbM/GDKm9cwRbuv31iWomsNHI5mfWoVdE4c5aQ5CiOgh8Y7GfPi5BYY4fRFdwnhp6fM3VDzI5/zWO0Z4WbwB9ZQgDOwRWJdrgf5wdwXSb+WXDE2/geiD1hUN+DCSNToRDfplha+jtSom
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d3c709-3176-44d6-180f-08d767e2dec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 02:40:39.2436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D5g6Ltu06NQziqZyUCPiutOAm6nAT6e9n0L68r7aycF1/+2qg4WQNZ8a0cjPdnlf7jaRHRTKvm9TG24WT9NmbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5303
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/13 11:16, Jens Axboe wrote:=0A=
> On 11/10/19 6:39 PM, Damien Le Moal wrote:=0A=
>> This series of patches introduces changes to zoned block device handling=
=0A=
>> code with the intent to simplify the code while optimizing run-time=0A=
>> operation, particularly in the area of zone reporting.=0A=
>>=0A=
>> The first patch lifts the device zone check code out of the sd driver=0A=
>> and reimplements these zone checks generically as part of=0A=
>> blk_revalidate_disk_zones(). This avoids zoned block device drivers to=
=0A=
>> have to implement these checks. The second patch simplifies this=0A=
>> function code for the !zoned case.=0A=
>>=0A=
>> The third patch is a small cleanup of zone report processing in=0A=
>> preparation for the fourth patch which removes support for partitions=0A=
>> on zoned block devices. As mentioned in that patch commit message, none=
=0A=
>> of the known partitioning tools support zoned devices and there are no=
=0A=
>> known use case in the field of SMR disks being used with partitions.=0A=
>> Dropping partition supports allows to significantly simplify the code=0A=
>> for zone report as zone sector values remapping becomes unnecessary.=0A=
>>=0A=
>> Patch 5 to 6 are small cleanups and fixes of the null_blk driver zoned=
=0A=
>> mode.=0A=
>>=0A=
>> The prep patch 7 optimizes zone report buffer allocation for the SCSI=0A=
>> sd driver. Finally, patch 8 introduces a new interface for report zones=
=0A=
>> handling using a callback function executed per zone reported by the=0A=
>> device. This allows avoiding the need to allocate large arrays of=0A=
>> blk_zone structures for the execution of zone reports. This can=0A=
>> significantly reduce memory usage and pressure on the memory management=
=0A=
>> system while significantly simplify the code all over.=0A=
>>=0A=
>> Overall, this series not only reduces significantly the code size, it=0A=
>> also improves run-time memory usage for zone report execution.=0A=
>>=0A=
>> This series applies cleanly on the for-next block tree on top of the=0A=
>> zone management operation series. It may however create a conflict with=
=0A=
>> Christoph's reqork of disk size revalidation. Please consider this=0A=
>> series for inclusion in the 5.5 kernel.=0A=
> =0A=
> We're taking branching to new levels... I created for-5.5/zoned for this,=
=0A=
> which is for-5.5/block + for-5.5/drivers + for-5.5/drivers-post combined.=
=0A=
> The latter is a branch with the SCSI dependencies from Martin pulled in.=
=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
Thanks !=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
