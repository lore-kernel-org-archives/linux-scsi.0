Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D45EC3B18B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 13:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8980222C2
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 13:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=netapp.onmicrosoft.com header.i=@netapp.onmicrosoft.com header.b="YxWvxtCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgBMNJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 08:09:28 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:33633
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729572AbgBMNJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 08:09:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqlwXSFcm6BHf0fvhNd1iymH3SK7++XzRB7IUmeykVmkK9/sBaVN1fn4wRwHaG77xf0xLERNtm+g9ceVOb/jqpIcx7nfRzIhWFWqrjr1ZaHaK6sMdviG32ix9UC+cjbwKq3msZOvi5jkKM37Iz7DK5OvKq2z2W3zAMsUtsFJYF1jCr/a9OtRoRpr6nQkmM6odSRVj/QJqwaL/H7loblSp80/Tiu+cHUb5v7JfG/MJQRT9dR81nCNARNI7lWeXCS5C0nmZir4vpbJHN6Q6xn3fCUCy03lopF7rInzFj0Fp8c4MNX9M8GfkI/3PzyGh9Ddcat0u+zecgosynT1uihDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lP0CnPTbsTlFMpm0V+aSh90H6d23ZCcGdW88nzAUU/g=;
 b=l6ORjq7Ybx59FeGsKDChJ5lcpCY72MSu6pCxk1PhQhVbZlDcCDu0IXWchoiKmfwdOFVO4RCPxvVJuSLQmMw6wV5TP+8a/fJo3iDt39wSQv9Tqkso9d3JEXzzJVO+MYqpmBMMXwBd3hVN5gV5vvmXHd0x3Ei2d+4mXiu2g3V/yYh2u3TAGxwK189Fu8VTUHIw3xVhR2vs4YyrkJm2sX6fsYwEbVcCip+V0Yp1qDSB0kilUETyi2q5xxEuOLID64r8p6zKCuDI661dyfCuW08WJCClVxWDShVtKKLINZpOda6YCBt5Qlc75qXa/bC4K7Kjrs4EsiH3I5iTt4LzQkdaKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netapp.com; dmarc=pass action=none header.from=netapp.com;
 dkim=pass header.d=netapp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netapp.onmicrosoft.com; s=selector1-netapp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lP0CnPTbsTlFMpm0V+aSh90H6d23ZCcGdW88nzAUU/g=;
 b=YxWvxtCL3pRkg18bpxkA0KFYNt94s5esv/eugChfvNsSZs8pp5Nn+di4lmgSHpVCX9WefwlDWQg3B65Zh7bFzR3pt5fu0BEwBT+/PhsHnDErDk8uJUeCgU38pY1fHiENN+qkZ+3hugVrPu5XEsuirhKP3QX0mD5xaiXnMRUGb0I=
Received: from BN8PR06MB5908.namprd06.prod.outlook.com (20.179.138.28) by
 BN8PR06MB5490.namprd06.prod.outlook.com (20.178.209.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 13 Feb 2020 13:09:24 +0000
Received: from BN8PR06MB5908.namprd06.prod.outlook.com
 ([fe80::7d67:47bd:dfb1:c5ae]) by BN8PR06MB5908.namprd06.prod.outlook.com
 ([fe80::7d67:47bd:dfb1:c5ae%5]) with mapi id 15.20.2729.021; Thu, 13 Feb 2020
 13:09:24 +0000
From:   "Knight, Frederick" <Frederick.Knight@netapp.com>
To:     "joshi.k@samsung.com" <joshi.k@samsung.com>,
        'Chaitanya Kulkarni' <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Matias Bjorling' <Matias.Bjorling@wdc.com>,
        'Stephen Bates' <sbates@raithlin.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>, 'Keith Busch' <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "'Christoph Hellwig'" <hch@lst.de>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "javier@javigon.com" <javier@javigon.com>
Subject: RE: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHVxYZFlOEpmvYia0KWnm3aEM0giagYzQoAgAB6PQA=
Date:   Thu, 13 Feb 2020 13:09:23 +0000
Message-ID: <BN8PR06MB5908FB1B3093D3E50EE6A379F11A0@BN8PR06MB5908.namprd06.prod.outlook.com>
References: <CGME20200107181551epcas5p4f47eeafd807c28a26b4024245c4e00ab@epcas5p4.samsung.com>
        <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
 <00d001d5e22c$0ebf63c0$2c3e2b40$@samsung.com>
In-Reply-To: <00d001d5e22c$0ebf63c0$2c3e2b40$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNca25pZ2h0XGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNDBmMjIxNzUtNGU1ZC0xMWVhLTgxMzEtOThmYTliZjY3ZjIyXGFtZS10ZXN0XDQwZjIyMTc2LTRlNWQtMTFlYS04MTMxLTk4ZmE5YmY2N2YyMmJvZHkudHh0IiBzej0iMTA1ODUiIHQ9IjEzMjI2MDcwOTAyNzE2NTUwMCIgaD0iOEtMWjJDWnZ1cDlZR25kbitUMnVBbjMwdDU4PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Frederick.Knight@netapp.com; 
x-originating-ip: [2606:a000:1101:c26e:d845:45a4:3f05:798b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ee1d357-ac73-47b1-3776-08d7b085f28f
x-ms-traffictypediagnostic: BN8PR06MB5490:|BN8PR06MB5490:|BN8PR06MB5490:
x-microsoft-antispam-prvs: <BN8PR06MB54908319E288B2FBE0114DBDF11A0@BN8PR06MB5490.namprd06.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(199004)(189003)(86362001)(186003)(9686003)(54906003)(52536014)(33656002)(110136005)(4326008)(66574012)(53546011)(2906002)(316002)(81156014)(81166006)(5660300002)(966005)(478600001)(6506007)(66446008)(64756008)(66556008)(66476007)(66946007)(71200400001)(7416002)(55016002)(7696005)(8936002)(76116006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR06MB5490;H:BN8PR06MB5908.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: netapp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aGRU/ft8PyrqGHgpvuUYgLHPPGUXcAaeNptfHzOhiwufLCGdTtpkbx6rsTK0lFUT4M2wlJB66uQv/XlVsMzxeDAutPuP29m02PQ1Ah3T11JB1a5EXMVt+lv6Vsb+OXthJNO9pXIVZN2YDqszzv/d1ly/MYhFKOeva+sNVEQuFjVntWfBntsXp4Jby3q4TBFtLxS9yOgclYS+atpP/OPup37LayqJY2qc1Wrca5AX4wekmIZcyyE5IKXKOAnWm0MnxiAEjRkLLav/a8OCOZqhOYNRvtfDGTxtG3r0zxtFXvj1p7tbI22YmutjxLiAWWiX7tTKdRupCUDkdtSQl8qNavgJYNG0XTMgRXrjlkLp5TYBOOoZFVqxjVUXadNsZhbC1hXC9z7A1xq9LjMXxqb25bSnOHfYUHhTgVcvdu4jCJQR9qDAj/vFom81O3YKb8ofNswa+wBz8Jht4t05vLOJCUUzJpI3zYPDP5fc5HQNn11Ah9M/hY68nLqTExs/ky2o2+yTQZbyGxOGgr6xlml2zT7pX+kWDtJWtaSjomMWQGi2mfaA1Ysu0vTmhLyLeV+kQSgqSBLYBPW/D8LMDQOkcg==
x-ms-exchange-antispam-messagedata: pLX+5csax9ZBfvv6yDAqQycvSWI2+2BFvy7KeQe7oFzNM5/H5uUbgzqtH2qgo22/uZC4+8Qi97aZ8hyIPeBZhtl1BAfWLbnDS+jJdqHclISXXjegMWBDs7IJ7m5gwOm62c2SllnbXmVMKQOFmoMrhSTjMVIc3irxg+7bscPXMO9e3alzx0g2u4BnhQ1vuNwnZpEfay+9qBY2ZQ1EThQKvg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee1d357-ac73-47b1-3776-08d7b085f28f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 13:09:23.8667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vCFGo27YhBrgASAUitT/HFTuSAFtpXxlQ8PNSqKVg30Mgc7UR9GcEN3AhMe1GcJxxlYr+BDqRcgjnuKNcskIBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR06MB5490
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FWIW - the design of NVMe Simply Copy specifically included versioning of t=
he data structure that describes what to copy.

The reason for that was random peoples desire to complexify the Simple Copy=
 command.  Specifically, there was room designed into the data structure to=
 accommodate a source NSID (to allow cross namespace copy - the intention b=
eing namespaces attached to the same controller); and room to accommodate t=
he KPIO key tag value for each source range.  Other people thought they cou=
ld use this data structure versioning to design a fully SCSI XCOPY compatib=
le data structure.

My point, is just to consider the flexibility and extensibility of the OS i=
nterfaces when thinking about "Simple Copy".

I'm just not sure how SIMPLY it will remain.

	Fred=20


-----Original Message-----
From: joshi.k@samsung.com <joshi.k@samsung.com>=20
Sent: Thursday, February 13, 2020 12:11 AM
To: 'Chaitanya Kulkarni' <Chaitanya.Kulkarni@wdc.com>; linux-block@vger.ker=
nel.org; linux-scsi@vger.kernel.org; linux-nvme@lists.infradead.org; dm-dev=
el@redhat.com; lsf-pc@lists.linux-foundation.org
Cc: axboe@kernel.dk; msnitzer@redhat.com; bvanassche@acm.org; 'Martin K. Pe=
tersen' <martin.petersen@oracle.com>; 'Matias Bjorling' <Matias.Bjorling@wd=
c.com>; 'Stephen Bates' <sbates@raithlin.com>; roland@purestorage.com; josh=
i.k@samsung.com; mpatocka@redhat.com; hare@suse.de; 'Keith Busch' <kbusch@k=
ernel.org>; rwheeler@redhat.com; 'Christoph Hellwig' <hch@lst.de>; Knight, =
Frederick <Frederick.Knight@netapp.com>; zach.brown@ni.com; joshi.k@samsung=
.com; javier@javigon.com
Subject: RE: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload

NetApp Security WARNING: This is an external email. Do not click links or o=
pen attachments unless you recognize the sender and know the content is saf=
e.




I am very keen on this topic.
I've been doing some work for "NVMe simple copy", and would like to discuss=
 and solicit opinion of community on the following:

- Simple-copy, unlike XCOPY and P2P, is limited to copy within a single nam=
espace. Some of the problems that original XCOPY work [2] faced may not be =
applicable for simple-copy, e.g. split of single copy due to differing devi=
ce-specific limits.
Hope I'm not missing something in thinking so?

- [Block I/O] Async interface (through io-uring or AIO) so that multiple co=
py operations can be queued.

- [File I/O to user-space] I think it may make sense to extend copy_file_ra=
nge API to do in-device copy as well.

- [F2FS] GC of F2FS may leverage the interface. Currently it uses page-cach=
e, which is fair. But, for relatively cold/warm data (if that needs to be g=
arbage-collected anyway), it can rather bypass the Host and skip running in=
to a scenario when something (useful) gets thrown out of cache.

- [ZNS] ZNS users (kernel or user-space) would be log-structured, and will =
benefit from internal copy. But failure scenarios (partial copy, write-poin=
ter position) need to be discussed.

Thanks,
Kanchan

> -----Original Message-----
> From: linux-nvme [mailto:linux-nvme-bounces@lists.infradead.org] On=20
> Behalf Of Chaitanya Kulkarni
> Sent: Tuesday, January 7, 2020 11:44 PM
> To: linux-block@vger.kernel.org; linux-scsi@vger.kernel.org; linux-=20
> nvme@lists.infradead.org; dm-devel@redhat.com; lsf-pc@lists.linux-=20
> foundation.org
> Cc: axboe@kernel.dk; msnitzer@redhat.com; bvanassche@acm.org; Martin K.
> Petersen <martin.petersen@oracle.com>; Matias Bjorling=20
> <Matias.Bjorling@wdc.com>; Stephen Bates <sbates@raithlin.com>;=20
> roland@purestorage.com; mpatocka@redhat.com; hare@suse.de; Keith Busch=20
> <kbusch@kernel.org>; rwheeler@redhat.com; Christoph Hellwig=20
> <hch@lst.de>; frederick.knight@netapp.com; zach.brown@ni.com
> Subject: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
>
> Hi all,
>
> * Background :-
> ----------------------------------------------------------------------
> -
>
> Copy offload is a feature that allows file-systems or storage devices=20
> to
be
> instructed to copy files/logical blocks without requiring involvement=20
> of
the local
> CPU.
>
> With reference to the RISC-V summit keynote [1] single threaded
performance is
> limiting due to Denard scaling and multi-threaded performance is=20
> slowing
down
> due Moore's law limitations. With the rise of SNIA Computation=20
> Technical Storage Working Group (TWG) [2], offloading computations to=20
> the device or over the fabrics is becoming popular as there are=20
> several solutions
available [2].
> One of the common operation which is popular in the kernel and is not
merged
> yet is Copy offload over the fabrics or on to the device.
>
> * Problem :-
> ----------------------------------------------------------------------
> -
>
> The original work which is done by Martin is present here [3]. The=20
> latest
work
> which is posted by Mikulas [4] is not merged yet. These two approaches=20
> are totally different from each other. Several storage vendors=20
> discourage
mixing
> copy offload requests with regular READ/WRITE I/O. Also, the fact that=20
> the operation fails if a copy request ever needs to be split as it=20
> traverses
the stack it
> has the unfortunate side-effect of preventing copy offload from=20
> working in pretty much every common deployment configuration out there.
>
> * Current state of the work :-
> ----------------------------------------------------------------------
> -
>
> With [3] being hard to handle arbitrary DM/MD stacking without=20
> splitting
the
> command in two, one for copying IN and one for copying OUT. Which is=20
> then demonstrated by the [4] why [3] it is not a suitable candidate.=20
> Also, with
[4]
> there is an unresolved problem with the two-command approach about how=20
> to handle changes to the DM layout between an IN and OUT operations.
>
> * Why Linux Kernel Storage System needs Copy Offload support now ?
> ----------------------------------------------------------------------
> -
>
> With the rise of the SNIA Computational Storage TWG and solutions [2],
existing
> SCSI XCopy support in the protocol, recent advancement in the Linux=20
> Kernel
File
> System for Zoned devices (Zonefs [5]), Peer to Peer DMA support in the
Linux
> Kernel mainly for NVMe devices [7] and eventually NVMe Devices and
subsystem
> (NVMe PCIe/NVMeOF) will benefit from Copy offload operation.
>
> With this background we have significant number of use-cases which are
strong
> candidates waiting for outstanding Linux Kernel Block Layer Copy=20
> Offload support, so that Linux Kernel Storage subsystem can to address=20
> previously mentioned problems [1] and allow efficient offloading of=20
> the data related operations. (Such as move/copy etc.)
>
> For reference following is the list of the use-cases/candidates=20
> waiting
for Copy
> Offload support :-
>
> 1. SCSI-attached storage arrays.
> 2. Stacking drivers supporting XCopy DM/MD.
> 3. Computational Storage solutions.
> 7. File systems :- Local, NFS and Zonefs.
> 4. Block devices :- Distributed, local, and Zoned devices.
> 5. Peer to Peer DMA support solutions.
> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
>
> * What we will discuss in the proposed session ?
> ----------------------------------------------------------------------
> -
>
> I'd like to propose a session to go over this topic to understand :-
>
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
>
> * Required Participants :-
> ----------------------------------------------------------------------
> -
>
> I'd like to invite block layer, device drivers and file system=20
> developers
to:-
>
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
>
> Required attendees :-
>
> Martin K. Petersen
> Jens Axboe
> Christoph Hellwig
> Bart Van Assche
> Stephen Bates
> Zach Brown
> Roland Dreier
> Ric Wheeler
> Trond Myklebust
> Mike Snitzer
> Keith Busch
> Sagi Grimberg
> Hannes Reinecke
> Frederick Knight
> Mikulas Patocka
> Matias Bj=F8rling
>
> [1]https://protect2.fireeye.com/url?k=3D22656b2d-7fb63293-2264e062-
> 0cc47a31ba82-2308b42828f59271&u=3Dhttps://content.riscv.org/wp-
> content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-
> History-Challenges-and-Opportunities-David-Patterson-.pdf
> [2] https://protect2.fireeye.com/url?k=3D44e3336c-19306ad2-44e2b823-
> 0cc47a31ba82-70c015d1b0aaeb3f&u=3Dhttps://www.snia.org/computational
> https://protect2.fireeye.com/url?k=3Da366c2dc-feb59b62-a3674993-
> 0cc47a31ba82-
> 20bc672ec82b62b3&u=3Dhttps://www.napatech.com/support/resources/solution
> -descriptions/napatech-smartnic-solution-for-hardware-offload/
>       https://protect2.fireeye.com/url?k=3D90febdca-cd2de474-90ff3685-
> 0cc47a31ba82-
> 277b6b09d36e6567&u=3Dhttps://www.eideticom.com/products.html
> https://protect2.fireeye.com/url?k=3D4195e835-1c46b18b-4194637a-
> 0cc47a31ba82-
> a11a4c2e4f0d8a58&u=3Dhttps://www.xilinx.com/applications/data-
> center/computational-storage.html
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy=20
> [4]
> https://protect2.fireeye.com/url?k=3D455ff23c-188cab82-455e7973-
> 0cc47a31ba82-e8e6695611f4cc1f&u=3Dhttps://www.spinics.net/lists/linux-
> block/msg00599.html
> [5] https://lwn.net/Articles/793585/
> [6] https://protect2.fireeye.com/url?k=3D08eb17f6-55384e48-08ea9cb9-
> 0cc47a31ba82-1b80cd012aa4f6a3&u=3Dhttps://nvmexpress.org/new-nvmetm-
> specification-defines-zoned-
> namespaces-zns-as-go-to-industry-technology/
> [7] https://protect2.fireeye.com/url?k=3D54b372ee-09602b50-54b2f9a1-
> 0cc47a31ba82-ea67c60915bfd63b&u=3Dhttps://github.com/sbates130272/linux-
> p2pmem
> [8] https://protect2.fireeye.com/url?k=3D30c2303c-6d116982-30c3bb73-
> 0cc47a31ba82-95f0ddc1afe635fe&u=3Dhttps://kernel.dk/io_uring.pdf
>
> Regards,
> Chaitanya
>
> _______________________________________________
> linux-nvme mailing list
> linux-nvme@lists.infradead.org
> https://protect2.fireeye.com/url?k=3Dd145dc5a-8c9685e4-d1445715-
> 0cc47a31ba82-
> 3bf90c648f67ccdd&u=3Dhttp://lists.infradead.org/mailman/listinfo/linux-n
> vme


