Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCA3C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 06:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjBVGAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 01:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBVGAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 01:00:09 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E15F2BF32
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 22:00:06 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31M3rm2s021179;
        Tue, 21 Feb 2023 21:59:57 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nty308ept-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 21:59:57 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31M5u5M9031014;
        Tue, 21 Feb 2023 21:59:57 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nty308epn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 21:59:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfcFFgUX3+7aat5YWwRioFWpUbvaSyIYFHXxY12rdCkRa9bdWHEKVXtsMD0HcS2JeTASd1gFsn6fRVsgQ4o1tG+fI5pJFkmvb6AxfVTwGD6cOQXF8wiMatOn65eryVWXQw98CiB+5DpPiUVIcXxjVhiXW8RLv4AkEPK3poisdLmq5eo0LM1/E1WS9nZ1Ap/cbzVVIBFp+kZR1oBbxx7Wnk39OCF/SDxlXybcgKhdnh0dVGd981MtX9kwqvxtqy3/+m0KPov0+2qqz5cQMlBCOpgiF27cNa2ewrbQuq2x9mW0c6XABislfDkOtXERG/uc85MWTf7ATCmf52vPMXSSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5WwhhDMDnkOiZ43bCxs3ZR7aQg40oT7G/1C4de94Es=;
 b=Vb5CTIT2s7yrhSDSZYV3VS5gxNEkW5tm8PZPbYRDgnwiknmj5LNIvgsHsSqSFAtXjYHjYOePtI18tDKhG98JHbs0DItrgYZwCEin+HXWWG39ZHtVYoL16V3D+JbfCGDMjQ3T7CPfglmCOSYLy35TomZDmHXptWpbmm0RsgF0tdCPs/KVcl+tYUYLaZ92/jvNYENmqNpXNY0Ba9qZ7+juMB1bqXhvXZnOaCVbJff65H2IgLhyySjIB+aK5KzlKiiL6Q9CqEv7WrRhPQKRdqxS29JwFnfp7Lroyvy8Pzkswn1167nZuPm20FoYHIjqUlf98gfTAKbrEDF4Qw1ECy3FJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5WwhhDMDnkOiZ43bCxs3ZR7aQg40oT7G/1C4de94Es=;
 b=JWnDiu62tGfU8FI0R6CcMCREkNtAH4h4B/KklUDP4B56Dhp+ebuk3WNQLPOdefSRFakj8snExRKgRlJl3iI1G5d0bknSfe79nCsd/R6gii1Pi3ptPKljCZB6RXTuaCclJ+eyYGBbEQFgt7vgDog6raZTq866dUxSH6kxjef12yM=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DM6PR18MB3473.namprd18.prod.outlook.com (2603:10b6:5:2a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 05:59:55 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::1e01:6dad:5a1f:fc7d]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::1e01:6dad:5a1f:fc7d%3]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 05:59:54 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Christoph Hellwig <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        Shreya Jeurkar <sjeurkar@marvell.com>,
        Jeetendra Sonar <jsonar@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Thread-Topic: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Thread-Index: AQHZRdrilCFdosUYl0Ct9c26AwU+jK7ZqgiAgADNtRA=
Date:   Wed, 22 Feb 2023 05:59:54 +0000
Message-ID: <CO6PR18MB4500B97E46D7749B2D957836AFAA9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20230221095708.29094-1-njavali@marvell.com>
 <20230221173521.GA13772@lst.de>
In-Reply-To: <20230221173521.GA13772@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbmphdmFsaVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTFkMTVmNTVhLWIyNzYtMTFlZC05NDk0LTA0Yjll?=
 =?us-ascii?Q?MzlkMzM0NFxhbWUtdGVzdFwxZDE1ZjU1Yy1iMjc2LTExZWQtOTQ5NC0wNGI5?=
 =?us-ascii?Q?ZTM5ZDMzNDRib2R5LnR4dCIgc3o9IjE2MDIiIHQ9IjEzMzIxNTE5MTkxMDU0?=
 =?us-ascii?Q?Njc4OSIgaD0iZWJCdThoUTk3RHEzSFlHNUZKaHc3ck4rdDhjPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFC?=
 =?us-ascii?Q?bGZZUGdna2JaQVlmWER5aU40c1BOaDljUEtJM2l3ODBOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUExRkgzYUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFDZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhR?=
 =?us-ascii?Q?QVh3QmpBRzhBWkFCbEFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWRBQmxBSElBYlFCcEFHNEFkUUJ6QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|DM6PR18MB3473:EE_
x-ms-office365-filtering-correlation-id: ab889c83-400f-4025-e839-08db149a0529
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i792buTCf6FR5Jz/+gmsxGCDyHssT8hHnr/HhlclGvphNWAXZWJlYQmIhHdwoW0F+0c5Mbu2UF2v5VM6LL8e3PkShPSLQAV7niAZOInp2LWXcpcnQMs6J1Fr19lZaTW9+6a1PoietbHcgKdRpoTvmaCgUkqGfxhJuweN7f9MuQ7Lyxd8m6SMIBbe/sjhekJRitAuzBVbgwCeIjZouiPapnsyZRToz3M8tBEG110SSI3VBfifl1WvbV7D9TPMsK/1IhU+GnIcQVxlWBt77PE8jaq5p/3hQ5oPppQpVPOwniQF1006o1FvWY4pKhUJjM3/lfyUChbtoYZQSHvU9BrYIye3dPWfOsMU0oSyd0D+5xtmtMl+3NoB4QKDXw8yFYtv9P94ROgJQgcwnLUNv3HAY0b2Etz/vbuVr6inR0sEtrjrwPMmHXmjCgtngO+V7Igpsa+gi1MY0q8WoXmU0WXKoYVqE5GWTkRdDaTP1Qb0lNeH53pBjHPFPQ6UF9IgEQkNuBwAVHvZ/N5byCIAbcOcAGbSzHTIXFYUAnkqd/fOkInRYRGqHRUOzgFVI7h7MUZgs4psK/Ptvb2uaY7LYtITNKHdTAdjSi/knMDUiAbBI55LL3atUuOepWxKKXXPDeV0vx2kqDOIx/rpiH08xbnXEKTtpSu71oEFtrUV31Pq59TWqs90Q9+jndYJanQF/+6WZFEBmQ+G553TqV2ipDRRVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(186003)(26005)(9686003)(53546011)(55016003)(4326008)(76116006)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(5660300002)(8936002)(83380400001)(52536014)(107886003)(6506007)(7696005)(71200400001)(478600001)(316002)(41300700001)(54906003)(110136005)(38100700002)(86362001)(122000001)(38070700005)(2906002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HAFLQWNDjkLj61CesJt9omboDh4dSxacKlemrXcVaWmT8pAstOsjDo+LUeaR?=
 =?us-ascii?Q?mjaiLmbXr8rsTQvLSC9SkjIPxSnpHsONf/QwXx3TO1+HqHhtCaPnRr2A/DsS?=
 =?us-ascii?Q?CBZposqXUxYX8QhmfMFD2DOwWGlmMcnfbxoOKqwRC1NcC96LFMK0ZPifTPn4?=
 =?us-ascii?Q?y/JDB/HVaYA096Vp0kuucm7Q4Crj7OtrF/ENzqCVH8drIqA37StsnlSvoBno?=
 =?us-ascii?Q?2M6FqDKL4BnMQVPyxicrMWB6kEE6mQXwptBNJvpRxs2Sk/pKZzs+Zk++hT15?=
 =?us-ascii?Q?ctXKyAZTF5NWky4jKcCsuSF4rhhc6UsinAglGErFQEtKfzKGXdYMPpzKPH90?=
 =?us-ascii?Q?ht90A6ByJuhyNdAT1diEqWUZ7xTgkBobNEveD6fB+Q0goAz1yaHt5LgimR5F?=
 =?us-ascii?Q?2xpv9Dh2pW8T5m/8kUN6kYIbnYvW/w9vKq5jT3WnD6bINEEa7+y7V4aS+Op5?=
 =?us-ascii?Q?Vc7YElCHBwPGfEb0DFvEZqIpPtVxrS0k+8oZmmDZ5zmkt7i14WRflD0fYmaj?=
 =?us-ascii?Q?k1U7y4M9EuHGPqAXiA0x9yWbvI0d0b1CDQNszGrDspZtefokWcdvDPo6/rJV?=
 =?us-ascii?Q?Jtxv8hV+gYbIkQbvvGntY2dnE1UN3i+jX2resMk4RNuRMgmN0bV4voCuzNBZ?=
 =?us-ascii?Q?b9HKJ8qcqU0k0XEaLg0dRT7jh+QcgdmfOLJ+yyIx/Kh3fQ6Tu57ezcM06t/W?=
 =?us-ascii?Q?/j4s6bJXfS6RPiOKq1Y7PQKeFxLd/2Ih3aA3GMsDyYb2eQBrScBtrtGYck2Q?=
 =?us-ascii?Q?lj6p57BNba22bVTcYF/H6XoObTSkIgQ6+cprqE//gFhsMWvVcCQpx0S76XQ3?=
 =?us-ascii?Q?gAIj/4hLPbFOS+Pz5cj4iVFx0hGk1vezgdBnDBtvk+nodyaBCShTpDT6S00J?=
 =?us-ascii?Q?W4pSP4s8W10EQbIKaqOd9mqPGsJWyZZDudE6Z8OJyBxExixzbrsKfOzFdM1w?=
 =?us-ascii?Q?1GltVSwz2brrMsx56WZkf95ejif3kOmEyDVQwcZvO/slD17vUvHwgIqxJl68?=
 =?us-ascii?Q?GhOmwCmZ/PnJzUIkAKApzDJhFgYCukNwm1eoRB0tkxO4W4AoVVBSt63zeGR4?=
 =?us-ascii?Q?QH+K0PW0Fhft5cjapdzbL4aksopcBwnBCxYuLMUFSiz2Rseb50upgQL5D9ke?=
 =?us-ascii?Q?D50W+gB0rBpLSqmgvIotPPNIOl478UN+Hy42xLDj5JBYcxo/At18Bq9ZMx2F?=
 =?us-ascii?Q?S5La29sez+GSJLC/jTYuHyTemWhHahZseOL72LSWzdMaSs+DjOtlk9hfEwRw?=
 =?us-ascii?Q?kUaTviwKXik4sVd+95oTGQu7yo2g9ZKbrgEhXN5ZVzSuVzE4YHZwsam5V07h?=
 =?us-ascii?Q?cvgxEkKeaxvmLQEsRQjRVyDqv3XEmePhR+8XXgYIrl3gF5mqzjlP1lPAdFJZ?=
 =?us-ascii?Q?Ic7Vv/FahwMm/APF0FteLcAhK4zluzpCm6Lag/reLYxeiWyfkyyotm2p7kkT?=
 =?us-ascii?Q?S9Wbik0KHSqmku35RVkOSZ1cNm0hcxrsw7tpbw6kP7L/vWjGbetH1mz7wNP2?=
 =?us-ascii?Q?Sktl6gLOpvcgoyybAIHL0xpcZq0ZDnIvghVGdjsQIsx7cVsEc9m9pGik9nth?=
 =?us-ascii?Q?Yq0LVXdhDB0B7XzoaNig+etbe5xujWGmqwawGc3R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab889c83-400f-4025-e839-08db149a0529
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 05:59:54.6883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zs2BJu0hojtEDx53dA8YNfo3FP8ulX5ra/pPxr5HDhLu9I9YEGZfK8NBLCMO0OBJM4FgHbUpLSqfW5c6VNpGrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3473
X-Proofpoint-GUID: _84KPPEuOPJLL3xGCfOdUlzTNy0FL8nN
X-Proofpoint-ORIG-GUID: aCifVVSykMkSzVJiqWPx4Frd8b1n5LBT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_02,2023-02-20_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Christoph,

Thanks for pointing to the commit.
I do not see this commit in Martin's tree 6.3/scsi-staging or 6.3/scsi-queu=
e branches.

Martin,

The 6.3/scsi-staging or 6.3/scsi-queue branches are still at 6.2.0-rc1.
That could be the reason we hit the NVMe discovery NULL pointer dereference=
 issue.
Any plans to pull the below commit to 6.3/scsi-staging or 6.3/scsi-queue br=
anches.
Or am I missing something here.

Thanks,
Nilesh

> -----Original Message-----
> From: Christoph Hellwig <hch@lst.de>
> Sent: Tuesday, February 21, 2023 11:05 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: linux-nvme@lists.infradead.org; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; Bikash Hazarika <bhazarika@marvell.com>; Anil
> Gurumurthy <agurumurthy@marvell.com>; Shreyas Deodhar
> <sdeodhar@marvell.com>; Christoph Hellwig <hch@lst.de>
> Subject: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Feb 21, 2023 at 01:57:08AM -0800, Nilesh Javali wrote:
> > CPU: 61 PID: 6064 Comm: nvme Kdump: loaded Not tainted 6.2.0-rc1 #3
>=20
> Well, that's a reall old -rc.
>=20
> This should be fixed by:
>=20
> commit 98e3528012cd571c48bbae7c7c0f868823254b6c
> Author: Ross Lagerwall <ross.lagerwall@citrix.com>
> Date:   Fri Jan 20 17:43:54 2023 +0000
>=20
>     nvme-fc: fix initialization order
