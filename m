Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A2DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 21:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D87613C1
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 21:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhEKVQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 17:16:58 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:15299
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229714AbhEKVQ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 May 2021 17:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMtFpeAESOnOlZ/R27lwiilVx1ZoYoeQ2EhdUegzIXX1eMq5J8/iKkmZL73ILk3d75bAUj3LS/XPjiMGJ8R0Nj1pyLbRsDt7mD6c44ADH0peV/iLiKSXf/FDCYYIfdRX3FWGFCbK9spjN2Uv8Jz7NaDUd6nwTX45NUH4I9dWs9pp+7bUUpR0ioY7VH0tjl/1upghEbPif3MIi730PV8yqUIE60XWE5/V31tMImLgF9dKMGE6YzJWEDoaBkhxBtTnNGRWs/WnOlY5KzLvprduIPgeZZj18qXT8Ddt7T3eiTpvz8Hj4a2+PhcgB9LEH8emLGskqYXMHDokMFtWJgCzsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbji2ahW2Xv6BeBd5BI/N36yUR6vhGBLeFmDHfFdhF4=;
 b=XENyy6g6F2bpm7Iy9zrsTI20oPE51/gBGJJDIqy5OdbodNBzFDp7tgWGRqds6GuZ0siyAGgzoAEZ5UGofra2wqiF9UoPhnJtNrJqaC7vOHAvXjEd7H2C/VbKguTkK55o1kShPKThQyXhixAgzsk96J9Vd+JAfXNlCTfu9cr+bSr9uIc8g42odsJsQWXCmMJP3CBxv3DpdoOx83dQ4bkuLL7fZZHt6GZEF2pVVYCABSj3zw1WT/GM6wQTR2S/55hqT7vp1R4jk4DPRApHFqSDVUrWHDMMwd2PVQzBEy7j+XcJuoOfUtEhyqu0WpJQFDYzPBmJfmD0hOFegExxlQes3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netapp.com; dmarc=pass action=none header.from=netapp.com;
 dkim=pass header.d=netapp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netapp.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbji2ahW2Xv6BeBd5BI/N36yUR6vhGBLeFmDHfFdhF4=;
 b=vOaYADRtKEe45z2cBcODN+Lefj3Cde1qxJEVLR01RENt9xdhEQxNbaRGcWwnMmbfgcPw9Vib15ggDi+xXZrwZoGB85YS5s++iIzCiR+jePS2j2Llj/ea7Na4I1pogNkxgGwDDOqgD63jK6NJlhF5ZGdRT9xJ41rA4rFdyx/wUKKFEYelpQzGG3+o8ptPP9B7ewPEv1mrYV9z2ayHIKR6m8ESlTNa0r70XpFUMxQpBM4wSz7oA/k9BNzityinoF4A7RldQmfF9UzK92fPo/PM7FsohpC1kuVXp0ZGrB1Q13YiTF3g2tCMJxybzD7K8ckVJpln11GAZ4ysd5Aeomz6kg==
Received: from DM5PR0601MB3624.namprd06.prod.outlook.com (2603:10b6:4:7f::28)
 by DM5PR06MB2665.namprd06.prod.outlook.com (2603:10b6:3:45::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 21:15:49 +0000
Received: from DM5PR0601MB3624.namprd06.prod.outlook.com
 ([fe80::150d:3a72:7776:a72]) by DM5PR0601MB3624.namprd06.prod.outlook.com
 ([fe80::150d:3a72:7776:a72%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 21:15:49 +0000
From:   "Knight, Frederick" <Frederick.Knight@netapp.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>, "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>
Subject: RE: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaKrex6mw
Date:   Tue, 11 May 2021 21:15:48 +0000
Message-ID: <DM5PR0601MB3624FF16F91F5F03BB5F0CC1F1539@DM5PR0601MB3624.namprd06.prod.outlook.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=netapp.com;
x-originating-ip: [73.61.33.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e90c35d-dfcd-4091-7017-08d914c1f33e
x-ms-traffictypediagnostic: DM5PR06MB2665:
x-ld-processed: 4b0911a0-929b-4715-944b-c03745165b3a,ExtAddr
x-microsoft-antispam-prvs: <DM5PR06MB2665D136FF4DB8581C83C384F1539@DM5PR06MB2665.namprd06.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLFCiPFHbn/JENKd+JURno7KX1xiyHyrJ0XqHJeOw2I6JakYPiztMRsdq5ftL3rkoe/S9H20lLZ0o3tRbM/ImhvedAum8WOM10smW5Nw2oLWjPJ0OkopiNgq94Y8qfj17jLGa44s6rJbAKb1y+ZkJctPBfMlGazw1dctwZgQzp+xYV5xO8Hvq6C4xCLjsf3Rtw325FsRwvzBhzb6rD9PTMTAJlS6KlMzwjdPRqlxQRV5wZGc3hTSXM8Xh9y3nwHOELYN4fKr4ZPNXBDraAdAXAHaGdgcQoF5WAkLT6GASOXA5JzaGF4J+ClelcGGHc0mojf2pJEzmra7toLVEln4a0TxjN72soZXeDTzPWDr25g5plekwempZ0WeN5gL/GLGnQLnRcuAxG6LzYF365MgHiNMUmqz6JGYpU4erkmJlXkXHBtaW0e0aTfxbf7B6/aNqWa4s2SrNrE4un2IC1uC6cITTGROtYgJI6+jPTuC+qk6SSLeSsD39fp4rUCMBkenyQN6N1YVbMwX9GO2LNzTsO/RasE5yyOIBK6Ujx8lR0FULS45QJKpxvTd9R3EU1UmoFYoD6PsSEGtDMtJxbALu8aH1rLbG1HYAN341seoF4pqqrp+nls6JEEn9YJH04Yy8UE0eMy8LdeOfGnL+9LNrdoybP+ULXcbxoHd/L2CZECE5VE6MYVEGAa3QDbTpPzoZq6QmHOznAMeD5L2QBppaHAYK/DxDdrDTYdp6r4oIiEVzgL367+cSRGXCSk8hb7KBLNkCsVkxyrnwUWwU31eNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0601MB3624.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(76116006)(66556008)(66446008)(64756008)(4326008)(53546011)(26005)(186003)(6506007)(66946007)(71200400001)(9686003)(7696005)(5660300002)(966005)(83380400001)(55016002)(33656002)(2906002)(8936002)(122000001)(110136005)(52536014)(38100700002)(316002)(86362001)(8676002)(66476007)(54906003)(7416002)(478600001)(15398625002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zF/rIesUgD0FxYYP7bNVctWDpi8RivEA2VP4y9al5Z0QKnX9BjkI2Xa2NGAE?=
 =?us-ascii?Q?RnasfhuLO6Th5+3BLLce1M1YDar9MFnzDcbsNl1Yp+V6G3w/TZKHfjwl2Wh/?=
 =?us-ascii?Q?mBpiQq4SmiGeKOjSVIq+6MyWPXELWr5Vse51f+3T4ghf48hVtcUJ7CxUKncr?=
 =?us-ascii?Q?LktY6IjX4OINh9uZLtAmeJ1KbCkSk+Riiu+WM+n3sB7NAzU0ZK02/5ATOpXc?=
 =?us-ascii?Q?2LPtIzKrq4jvW3R586N1mi6oD7oSmoR+2HQvxv7yGQAg6yrJqCZHiv1DVn43?=
 =?us-ascii?Q?oGYUXgLzReyz43bWU8J5fx0ir3aPc5nGhVpjaI19RZAEMbDdWqE6/n4woWu6?=
 =?us-ascii?Q?Kwe/kHXjRjR5l3vdTGi09NdbfQbZIG92wztZusXrV0bdybVUUUbROn5sx2Q/?=
 =?us-ascii?Q?ppMK8btGyCnw4p3mNijrdSHTwXmbsmz1YAWcoECuHeyiGnBv1V30pdSwb1q3?=
 =?us-ascii?Q?LY0wHERTs1fQ5GkyxlyctlZ8ZAqIrBmUXzgqauTVHzxFMS8V+Vtr2budLuGV?=
 =?us-ascii?Q?l7H1MMJQV5CWpWdUFkfzm/0k3H25mfuCx5e6B0ZB00LreipLzwPnA2r4uxZa?=
 =?us-ascii?Q?2YXlnVbtxJM4gPO3Gm9ZJ+AnaKG62MPR75j7apL7tbjgk3Fa+5+dear1EYk3?=
 =?us-ascii?Q?WhbVwkm98dcvDv/OzUSzmlBr0KLprTbV+SfF4KCJ90O310PwJmVuE0sQozCS?=
 =?us-ascii?Q?TzBOl9P4SvqoCHxlgy+AUWBDp5+sFGuPls21gpxXWGpMPsodwWM0P26oUc3h?=
 =?us-ascii?Q?ThiW5pFla/7ppvQzDfPUB8KeyDX/BFZftQrIXOiStB0z3lHhqbMtxJc8ZF2X?=
 =?us-ascii?Q?Do7pDlYq/bMl6n8AMOqpc72FNU7kVHns0HcqeeFiBwKCkDu50MSAC6FplZoE?=
 =?us-ascii?Q?S/trfYw3ZpYNWdPLH0kLQB8uaBLx2AxSgUofgMjdSfiBhJwUG3/lGohqxXaB?=
 =?us-ascii?Q?AvrFKPzJVJki+3nZt3Dy4y9nCB8fMaLPZAkpieyc3vvjDbFAb5hulqnuZ4AN?=
 =?us-ascii?Q?eIDdnx4RHFVgTqkcvgtFJIKwDe3LrFun+ci4mNv33BIeRI95iCaF8szFVI1N?=
 =?us-ascii?Q?GdN5YJY+EB/aisvPZMVBqFcQ7wBn8B2j9+oXG56HgkxMXn1E5OmJ1Z7fEv7L?=
 =?us-ascii?Q?KtyZbUyrm7rw7vFpYkMroqY/pfDDjIU0wT/lH6K10XmjQzxC+UE/p1TaIJBu?=
 =?us-ascii?Q?++v6BtfgwfrNne/ezqhZom0C2GdsdLrtnzGJ+yV4viNz2nHooHPDkWuaKuDL?=
 =?us-ascii?Q?sH9blHm4DxfDvi8ePHPpctMiRMsqSOMiSmbkeGbDlIOFxqbJqcvUeaxeOvNn?=
 =?us-ascii?Q?6ad7vxO/QwAe2HQ2Uo99jSQ2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0601MB3624.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e90c35d-dfcd-4091-7017-08d914c1f33e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 21:15:49.0205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cp8buXOjdiul5izwUJFs4ZhZTV3vhDSZyzBhK+bmPjEVwMIFopYyfJyMB+m6poxPASDln6xleCg/hEa9tvRM2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR06MB2665
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'd love to participate in this discussion.

You mention the 2 different models (single command vs. multi-command).  Jus=
t as a reminder, there are specific reasons for those 2 different models.

Some applications know both the source and the destination, so can use the =
single command model (the application is aware it is doing a copy).  But, t=
here is a group of applications that do NOT know both pieces of information=
 at the same time, in the same thread, in the same context (the application=
 is NOT aware it is doing a copy - the application thinks it is doing reads=
 and writes).

That is why there are 2 different models - because the application engineer=
s didn't want to change their application.  So, the author of the CP applic=
ation (the shell copy command) wanted to use the existing READ / WRITE mode=
l (2 commands).  Just replace the READ with "get the data ready" and replac=
e the WRITE with "use the data you got ready".  It was easier for that appl=
ication to use the existing model, rather than totally redesigning the appl=
ication.

But, other application engineers had a code base that already knew a copy w=
as happening, and their code already knew both the source and destination i=
n the same code path. A BACKUP application is one that generally fits into =
this camp.  So, it was easier for that application to replace that function=
 with a single copy request.  Another application was a VM mastering/replic=
ating application that could spin up new VM images very quickly - the sourc=
e and destination are known to be able to use a single request.

When this offload journey began, both interfaces were needed and used.  But=
 yes, it did bifurcate the space, creating 2 camps of engineers - each with=
 their favorite method (based on the application where they planned to use =
it).  Each camp of engineers often sees no reason that the other camp can't=
 just switch to do it the way they do - if they'd only see the light.  But,=
 originally, there were 2 different sets of requirements that each drove a =
specific design of a copy offload model.

Even NVMe has recently joined the copy offload camp with a new COPY command=
 (single namespace, multiple source ranges, single destination range - work=
s well for defrag, and other use cases). I'm confident its capabilities wil=
l grow over time.

SO, I think this will be a great discussion to have!!!

	Fred Knight



-----Original Message-----
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>=20
Sent: Monday, May 10, 2021 8:16 PM
To: linux-block@vger.kernel.org; linux-scsi@vger.kernel.org; linux-nvme@lis=
ts.infradead.org; dm-devel@redhat.com; lsf-pc@lists.linux-foundation.org
Cc: axboe@kernel.dk; msnitzer@redhat.com; bvanassche@acm.org; martin.peters=
en@oracle.com; roland@purestorage.com; mpatocka@redhat.com; Hannes Reinecke=
 <hare@suse.de>; kbusch@kernel.org; rwheeler@redhat.com; hch@lst.de; Knight=
, Frederick <Frederick.Knight@netapp.com>; zach.brown@ni.com; osandov@fb.co=
m
Subject: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload

NetApp Security WARNING: This is an external email. Do not click links or o=
pen attachments unless you recognize the sender and know the content is saf=
e.




Hi,

* Background :-
-----------------------------------------------------------------------

Copy offload is a feature that allows file-systems or storage devices to be=
 instructed to copy files/logical blocks without requiring involvement of t=
he local CPU.

With reference to the RISC-V summit keynote [1] single threaded performance=
 is limiting due to Denard scaling and multi-threaded performance is slowin=
g down due Moore's law limitations. With the rise of SNIA Computation Techn=
ical Storage Working Group (TWG) [2], offloading computations to the device=
 or over the fabrics is becoming popular as there are several solutions ava=
ilable [2]. One of the common operation which is popular in the kernel and =
is not merged yet is Copy offload over the fabrics or on to the device.

* Problem :-
-----------------------------------------------------------------------

The original work which is done by Martin is present here [3]. The latest w=
ork which is posted by Mikulas [4] is not merged yet. These two approaches =
are totally different from each other. Several storage vendors discourage m=
ixing copy offload requests with regular READ/WRITE I/O. Also, the fact tha=
t the operation fails if a copy request ever needs to be split as it traver=
ses the stack it has the unfortunate side-effect of preventing copy offload=
 from working in pretty much every common deployment configuration out ther=
e.

* Current state of the work :-
-----------------------------------------------------------------------

With [3] being hard to handle arbitrary DM/MD stacking without splitting th=
e command in two, one for copying IN and one for copying OUT. Which is then=
 demonstrated by the [4] why [3] it is not a suitable candidate. Also, with=
 [4] there is an unresolved problem with the two-command approach about how=
 to handle changes to the DM layout between an IN and OUT operations.

* Why Linux Kernel Storage System needs Copy Offload support now ?
-----------------------------------------------------------------------

With the rise of the SNIA Computational Storage TWG and solutions [2], exis=
ting SCSI XCopy support in the protocol, recent advancement in the Linux Ke=
rnel File System for Zoned devices (Zonefs [5]), Peer to Peer DMA support i=
n the Linux Kernel mainly for NVMe devices [7] and eventually NVMe Devices =
and subsystem (NVMe PCIe/NVMeOF) will benefit from Copy offload operation.

With this background we have significant number of use-cases which are stro=
ng candidates waiting for outstanding Linux Kernel Block Layer Copy Offload=
 support, so that Linux Kernel Storage subsystem can to address previously =
mentioned problems [1] and allow efficient offloading of the data related o=
perations. (Such as move/copy etc.)

For reference following is the list of the use-cases/candidates waiting for=
 Copy Offload support :-

1. SCSI-attached storage arrays.
2. Stacking drivers supporting XCopy DM/MD.
3. Computational Storage solutions.
7. File systems :- Local, NFS and Zonefs.
4. Block devices :- Distributed, local, and Zoned devices.
5. Peer to Peer DMA support solutions.
6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.

* What we will discuss in the proposed session ?
-----------------------------------------------------------------------

I'd like to propose a session to go over this topic to understand :-

1. What are the blockers for Copy Offload implementation ?
2. Discussion about having a file system interface.
3. Discussion about having right system call for user-space.
4. What is the right way to move this work forward ?
5. How can we help to contribute and move this work forward ?

* Required Participants :-
-----------------------------------------------------------------------

I'd like to invite file system, block layer, and device drivers developers =
to:-

1. Share their opinion on the topic.
2. Share their experience and any other issues with [4].
3. Uncover additional details that are missing from this proposal.

Required attendees :-

Martin K. Petersen
Jens Axboe
Christoph Hellwig
Bart Van Assche
Zach Brown
Roland Dreier
Ric Wheeler
Trond Myklebust
Mike Snitzer
Keith Busch
Sagi Grimberg
Hannes Reinecke
Frederick Knight
Mikulas Patocka
Keith Busch

Regards,
Chaitanya

[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-fo=
r-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterso=
n-.pdf
[2] https://www.snia.org/computational
https://www.napatech.com/support/resources/solution-descriptions/napatech-s=
martnic-solution-for-hardware-offload/
      https://www.eideticom.com/products.html
https://www.xilinx.com/applications/data-center/computational-storage.html
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy [4] h=
ttps://www.spinics.net/lists/linux-block/msg00599.html
[5] https://lwn.net/Articles/793585/
[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
namespaces-zns-as-go-to-industry-technology/
[7] https://github.com/sbates130272/linux-p2pmem
[8] https://kernel.dk/io_uring.pdf

