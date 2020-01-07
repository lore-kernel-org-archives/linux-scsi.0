Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD882C282DD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 18:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9169120715
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 18:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IcHqNOg+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OuRxqlmq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgAGSOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 13:14:24 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:34387 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgAGSOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 13:14:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578420863; x=1609956863;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=j2tN6+V1pVxcaWER8t6KvObGStMa9m3VVcoDZo3HOsU=;
  b=IcHqNOg+FY4t/L82GJi0BtiyfGt4cevxrKRPOILjGG+ucEeyKMMBgxVq
   qEXZtS0E73ycpAHyHrPDkCpYvnaN2WrvMmj4QJlTBrX3uBYpPnty4oEED
   rJDFe4ejeyjoGu0Bwvvrbmq9GLggthDGijSJ816Jq8AOIISXwXwF+KX02
   xoMjbfnd2Q98k26TYkb8ydXXX9F0ShUwJIGv2rsyGglpd62nSKhWbO66Y
   +mWUvTrywyH2AdrvKYQ2DJGGnuuUfybWrB7mpsmzHJNaNseR3dBjIGj0w
   bPu+vcxR+2/DpCFKPoFenxxCek+TFUkcqBU+oB8lMQ5uaZ/CK9qZFXWc3
   g==;
IronPort-SDR: 6NqzSdyPZEDLBekS4PclRh/hvz7Yn5TRJ9wx2TvAoohFquK5SK/fFi+2EoXrGWcq0hzL1IU28F
 vpgp/qSezSGp8ayjOJYlDwNFSEd5T1Qj8B+81mK1IXYWrPlT06oFyip1tiDBD6Yy+oQkVtdePZ
 m3W6vCd/6c/uYhAgzlBj/BYUFhBZeEiQ3/Lto+lHF9IH2Yo3BjwCjyXIywz1efaTO8SNmYrmUU
 kpSlXQ8VjdOXaNSZBiwQBycJ4+sXqQFSQ42gH+rI+8LWaw2jLf6T94VBDmf9O8MfAAlpI4HjrK
 kA4=
X-IronPort-AV: E=Sophos;i="5.69,406,1571673600"; 
   d="scan'208";a="234671188"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jan 2020 02:14:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNLVkqx2l2BLai+1l5Qh3uQOlhXIqvN5zbho10zBhGfMlkTVB7NUIa5D8LCainIZ7tQtatYxDSYFpFy6UWE5hHyb1NGV3TmYMCLxtIMneQU0GH+um2+AyrPZIH4d/jYCbaAeGyz43yBrnOt82YLnsWAUl4dHY6+SWI0PbNfqKp0IOmWvIeRZl8vbhAihDzOOOrAUOtNFZiF+V7iPIO3WKu/HD0wMYMGQZeBps2gWgnazuloVB5p8SOTKJt0MrRdAUpapkIGC/pEWQ2kCrcsZjOXZ3CTtincv50X1+QqcJzg0jGpg2ndoIsJPoWTe1St+BpJTHEjEcZ5b673VKQdFag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mm+UKAdhfdscAtLxwHrWPWYX+y7j7grRWRWz+3jKFEY=;
 b=JPWFrFlkO1agLrX/rtUdnIEA8ruNcc5i0W8350xt3xRskWXBxCZyzF6Uk+GWE+NLV3BS8fqGFrMjgCk0zS1dKyKP22GkKDoUbJKGM7udt4RPiyQCigbgELK2KtceCnYxpRnlFACu2icKxY7G+tWRAnIRks1tjMGCugxdTitWIoLh3AMto6Kv9Sv9hCdImIqZyt865NYzedyKDdrUkYNK6MkEK417Q1YBJ4ozcR14OJMhSZiB/EX0QJzCE0H0a8A8BJlcEWCjsbw0Kj3Hd0eoPvQ8ckJDoTwSR48dZ/+V9AZhDYl/psGSOa1E2h1mhJPFlnWieAIJZHlF6z1pknFwMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mm+UKAdhfdscAtLxwHrWPWYX+y7j7grRWRWz+3jKFEY=;
 b=OuRxqlmqL+bKIFRGQB1txxoKewoUGRDUGdhmQ75o1H92ThDCjJ32jCvDlWvHmEBUPOx+uiNKOFcKZB9hj821eknEqv9gbD03XUVPyJ5/61gZkqcQ0Nuey/Y2y/YJqQ7XTtLQ5LYXnYMYkvCAN8DoDi88AvEVCr2y4xaZ3U+KXWw=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB4470.namprd04.prod.outlook.com (52.135.237.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Tue, 7 Jan 2020 18:14:17 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f%5]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 18:14:17 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Bates <sbates@raithlin.com>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "frederick.knight@netapp.com" <frederick.knight@netapp.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>
Subject: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHVxYZFlOEpmvYia0KWnm3aEM0giQ==
Date:   Tue, 7 Jan 2020 18:14:17 +0000
Message-ID: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e26e0278-6748-4345-c3ec-08d7939d6903
x-ms-traffictypediagnostic: BYAPR04MB4470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4470E21158188BE326CB46FE863F0@BYAPR04MB4470.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(189003)(199004)(53754006)(33656002)(2906002)(4326008)(478600001)(55016002)(9686003)(186003)(66476007)(7696005)(66446008)(66946007)(66556008)(6506007)(76116006)(64756008)(54906003)(316002)(110136005)(26005)(8676002)(66574012)(8936002)(81156014)(71200400001)(7416002)(81166006)(966005)(5660300002)(86362001)(52536014)(15398625002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4470;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDiD37JNy1JZmPtUS/37Sot6KGO73Hr4rc05OR1VzDSubpJwBFTBrLy2vPoeuGAMUDb4oy5pRobKRBOlvIJHO3PDlOIaUwFDwBRNDwx6E0rHT77ih8YhfWSca8Ew3nJTXYnRtK2HCwvL8uucm4+J9kOYyPtrNZM8e/yHIDa+91/8cA3n2zKOWAKEzoVydKcOFy+C+d2McSr5/Vb7EG7fpwg0Zf4tggfjt0NAoZ2S75ZmPYrhVNnFs2sWnu8e3Dzn6Xjb8vHKwkQ78uEg4mnajXZ8DaDq9kqf3T6sx7H4muj+ig1W/2ObezykOBLiMCW22m9oYGQl4Cwq+QqsdX3GqBi62qzuW7z6iW1ri8ZlfEN6CslbzPwJ11T6GI44O3M3IxNg6JTwd4V6uxskDZiK5UFra0oPZXZK5Xzdp9bTpnBBqkI4XDjMoe2/uKqB/fRbfk2KPJb4L6AfrkuqJH5geTlZphIyKCyN9CoaxrhFtdYYxe6Q1rDArZ49Mh/1O6twzdsCNl1D3CYPR311WIJF6nPdXpFWRTg1XsOe1YmojErl1R9aq7dzI0uqlsuInACjt6upEoY3J1kWn4Y7WbpUNVmbmALqJdbqzHuQai2FUlE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26e0278-6748-4345-c3ec-08d7939d6903
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 18:14:17.5528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uV11/h+HQVGH+b5DmUGntMKLo6BW2Q3YISL02PtEEeMRyp5pY6axhwkDnCH4dH8iJ4f4lPAG5T0mZXteMpMAYj8MU3qAbjzdfNp/Y0hhgoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4470
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,=0A=
=0A=
* Background :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
Copy offload is a feature that allows file-systems or storage devices=0A=
to be instructed to copy files/logical blocks without requiring=0A=
involvement of the local CPU.=0A=
=0A=
With reference to the RISC-V summit keynote [1] single threaded=0A=
performance is limiting due to Denard scaling and multi-threaded=0A=
performance is slowing down due Moore's law limitations. With the rise=0A=
of SNIA Computation Technical Storage Working Group (TWG) [2],=0A=
offloading computations to the device or over the fabrics is becoming=0A=
popular as there are several solutions available [2]. One of the common=0A=
operation which is popular in the kernel and is not merged yet is Copy=0A=
offload over the fabrics or on to the device.=0A=
=0A=
* Problem :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
The original work which is done by Martin is present here [3]. The=0A=
latest work which is posted by Mikulas [4] is not merged yet. These two=0A=
approaches are totally different from each other. Several storage=0A=
vendors discourage mixing copy offload requests with regular READ/WRITE=0A=
I/O. Also, the fact that the operation fails if a copy request ever=0A=
needs to be split as it traverses the stack it has the unfortunate=0A=
side-effect of preventing copy offload from working in pretty much=0A=
every common deployment configuration out there.=0A=
=0A=
* Current state of the work :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
With [3] being hard to handle arbitrary DM/MD stacking without=0A=
splitting the command in two, one for copying IN and one for copying=0A=
OUT. Which is then demonstrated by the [4] why [3] it is not a suitable=0A=
candidate. Also, with [4] there is an unresolved problem with the=0A=
two-command approach about how to handle changes to the DM layout=0A=
between an IN and OUT operations.=0A=
=0A=
* Why Linux Kernel Storage System needs Copy Offload support now ?=0A=
-----------------------------------------------------------------------=0A=
=0A=
With the rise of the SNIA Computational Storage TWG and solutions [2],=0A=
existing SCSI XCopy support in the protocol, recent advancement in the=0A=
Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer=0A=
DMA support in the Linux Kernel mainly for NVMe devices [7] and=0A=
eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit=0A=
from Copy offload operation.=0A=
=0A=
With this background we have significant number of use-cases which are=0A=
strong candidates waiting for outstanding Linux Kernel Block Layer Copy=0A=
Offload support, so that Linux Kernel Storage subsystem can to address=0A=
previously mentioned problems [1] and allow efficient offloading of the=0A=
data related operations. (Such as move/copy etc.)=0A=
=0A=
For reference following is the list of the use-cases/candidates waiting=0A=
for Copy Offload support :-=0A=
=0A=
1. SCSI-attached storage arrays.=0A=
2. Stacking drivers supporting XCopy DM/MD.=0A=
3. Computational Storage solutions.=0A=
7. File systems :- Local, NFS and Zonefs.=0A=
4. Block devices :- Distributed, local, and Zoned devices.=0A=
5. Peer to Peer DMA support solutions.=0A=
6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.=0A=
=0A=
* What we will discuss in the proposed session ?=0A=
-----------------------------------------------------------------------=0A=
=0A=
I'd like to propose a session to go over this topic to understand :-=0A=
=0A=
1. What are the blockers for Copy Offload implementation ?=0A=
2. Discussion about having a file system interface.=0A=
3. Discussion about having right system call for user-space.=0A=
4. What is the right way to move this work forward ?=0A=
5. How can we help to contribute and move this work forward ?=0A=
=0A=
* Required Participants :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
I'd like to invite block layer, device drivers and file system=0A=
developers to:-=0A=
=0A=
1. Share their opinion on the topic.=0A=
2. Share their experience and any other issues with [4].=0A=
3. Uncover additional details that are missing from this proposal.=0A=
=0A=
Required attendees :-=0A=
=0A=
Martin K. Petersen=0A=
Jens Axboe=0A=
Christoph Hellwig=0A=
Bart Van Assche=0A=
Stephen Bates=0A=
Zach Brown=0A=
Roland Dreier=0A=
Ric Wheeler=0A=
Trond Myklebust=0A=
Mike Snitzer=0A=
Keith Busch=0A=
Sagi Grimberg=0A=
Hannes Reinecke=0A=
Frederick Knight=0A=
Mikulas Patocka=0A=
Matias Bj=F8rling=0A=
=0A=
[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-fo=
r-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterso=
n-.pdf=0A=
[2] https://www.snia.org/computational=0A=
https://www.napatech.com/support/resources/solution-descriptions/napatech-s=
martnic-solution-for-hardware-offload/=0A=
      https://www.eideticom.com/products.html=0A=
https://www.xilinx.com/applications/data-center/computational-storage.html=
=0A=
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy=0A=
[4] https://www.spinics.net/lists/linux-block/msg00599.html=0A=
[5] https://lwn.net/Articles/793585/=0A=
[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-=0A=
namespaces-zns-as-go-to-industry-technology/=0A=
[7] https://github.com/sbates130272/linux-p2pmem=0A=
[8] https://kernel.dk/io_uring.pdf=0A=
=0A=
Regards,=0A=
Chaitanya=0A=
