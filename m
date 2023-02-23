Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E217C636D6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 15:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbjBWPn2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Feb 2023 10:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjBWPn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2023 10:43:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBEF4E5C1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2023 07:43:24 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NBuaeN007873;
        Thu, 23 Feb 2023 07:43:15 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nwy8qk3y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 07:43:15 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31NFhFmF028480;
        Thu, 23 Feb 2023 07:43:15 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nwy8qk3y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 07:43:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkA9IOh8uYU59FEmIgrf5RSkR4pKqnZR6Yiis28JhvUtnYPI/UOOA2ZRIWjFp1XiJCsnffzdT2VeztEEYd97HcXC5vtZ1wdTb8zVnCNbQCg/+JnjvgAgvmT7wegQthT4wyfUqt/hBlaLvZhQ2jfCeoW1qpMDozo24TaTvpkxRhfZy5MpZYC5VwRAaHRM5cZL5DvmwP3fnX3LvTzm/YRqJC+7ogHAW5ZspRIwNQwaT/KJBI8KKm1Azo3ZiJeVVwH/lKr4UFVCHr9UZS52EpYO+/BX1DjVtByB8OQFYy8bPWCOOp6VCXRZIxeR0A8z12iXMYepomgcpqtgMKSaJ6chFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuG/WIX8wRmC1VgSxlysgic/281hIP0yphQ7g6U/9kM=;
 b=FDYHI6BHOcpgEWg19CbaZNdgoUXI2dxHOrBJkDNJVDUwmBBu/niQSCtqaB+nKDEiEWY48dijqX1m40kXgMzivdcn+xrvgfRsnjjTu1hJM1xe1cTYMj8lQm0uC5tbsx9qTsnB1StWDbqWyr8w+Z7uPps7Bm/wXFrbU/ZmKfktxmYj5sk5GrHKaibpv+ajUTbY2NgPNzWyNDeoWJeZmEmSLmhi958fBTDNNhwwF6osZH4CG+7qTjclVZF8Q7iWnwg1nFLYg0mD+6miv6USWq5whIFicZ6WxU3Fxz2LPXjhT1HDm8ZKiBfsGI0jGe8/uEGnM4nA3fvBq3W5BcyY1oVj5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuG/WIX8wRmC1VgSxlysgic/281hIP0yphQ7g6U/9kM=;
 b=UKuAIRO/7FDKEs6HmGM3posFT9ZEs+J1CPd+CNrY8zY8Ehg5JjliXraE3q1kJb1coe20CEmGirA+gI+yYOGRgGUnxpEReW4dGgIAMr5bExDEo80r89FkKhzCZW9zqYlR3Fi+3JF2EDkOr9uimrBzHLWM7iz+j0wtUbN2iYhefwc=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DS0PR18MB5285.namprd18.prod.outlook.com (2603:10b6:8:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 15:43:12 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::1e01:6dad:5a1f:fc7d]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::1e01:6dad:5a1f:fc7d%3]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 15:43:12 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        Shreya Jeurkar <sjeurkar@marvell.com>,
        Jeetendra Sonar <jsonar@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Thread-Topic: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Thread-Index: AQHZRdrilCFdosUYl0Ct9c26AwU+jK7ZqgiAgADNtRCAALweUYABezgw
Date:   Thu, 23 Feb 2023 15:43:11 +0000
Message-ID: <CO6PR18MB4500165301204B45F173F2EBAFAB9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20230221095708.29094-1-njavali@marvell.com>
        <20230221173521.GA13772@lst.de>
        <CO6PR18MB4500B97E46D7749B2D957836AFAA9@CO6PR18MB4500.namprd18.prod.outlook.com>
 <yq1o7ploei6.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1o7ploei6.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbmphdmFsaVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWMyNzIyZDZlLWIzOTAtMTFlZC05NDk0LTA0Yjll?=
 =?us-ascii?Q?MzlkMzM0NFxhbWUtdGVzdFxjMjcyMmQ3MC1iMzkwLTExZWQtOTQ5NC0wNGI5?=
 =?us-ascii?Q?ZTM5ZDMzNDRib2R5LnR4dCIgc3o9IjE2MzciIHQ9IjEzMzIxNjQwNTg3NjA2?=
 =?us-ascii?Q?MTcwNCIgaD0id0NJdDhPSVpHbVl2VUFiSElPemNkN1hNS1FrPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFB?=
 =?us-ascii?Q?SU5uK0duVWZaQVV1U2JFNVVTenExUzVKc1RsUkxPclVOQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFDd0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
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
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|DS0PR18MB5285:EE_
x-ms-office365-filtering-correlation-id: 68e93f87-72c4-4be0-a7b3-08db15b4ab90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lze/3NMscUYyuobU901gO9sacZQwMXEnf/uvIX/sVPAZBc4tu6FEczd48jWoiVuUNmUPNSEcvoM4W1oAV5Rv0mA0HVDmMsyVDzCXzKMMe4YItqD7/CQEKdLSDO9nlc+xBZc9FUetR1nUctSVZt4vV+giQDDgw/jYVNisSqU4W753SJCQbWMaBV0E+aNXlzNT1YNy+A9fkWVZ1WDRqJbnmQNfHBo3RYCIY1oQaXbBC8CmIdQU7u+mU7SZQGevrK5XIvaZoKr3gcitVbtrJzG+TPiQL+QQNbnYblj8sXNmtXYBo4TyGh8RqqQeuPyISIMExWuC6UcoIPURlcf6tDQjuBCdC6z/WZTiyuwGqBWVMuWd8yJLn4C1QjKbyM2O2AHKFoSuG3B7sH883EGRIMfcsRCN0Kq1voTNJ9vbfBUmu0gbqkSSg3gLApkKJxQkaAv6gVYPubBNOXIUzeR9t1PFiv+ukr163kzL6+T5mJBwLpMzXADFVUDqwB857VPItHzGesDmkvpEpDVHPtkM+kBk6T+yNF5ZFM0nhS46UlGH8DNmCJQHkdVrmQzirQwvQN8PCQ7VdFik5QNXRIpHVz3ZZ+iWfFJcmM8c/ky5ATuhWTZRwQZERfWl/5w9v7xWNF9MKuVnvaJc4LcEZ5Og/y54zPhBx2w6Rt3J++vwQH/78W3fYhSXy/T0ddcI7bCIDFaLXc95/MQVHtVX0pcbgrzTxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199018)(478600001)(71200400001)(7696005)(316002)(38100700002)(38070700005)(86362001)(122000001)(33656002)(2906002)(54906003)(41300700001)(8936002)(52536014)(4326008)(55016003)(66946007)(66556008)(8676002)(66476007)(76116006)(66446008)(6916009)(64756008)(83380400001)(5660300002)(26005)(186003)(9686003)(53546011)(107886003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JiSEgYfrvnVAIpBzhvr5Z+jKpZSAnMnh2pP3+JoX09n3TWOkVv5PVGsg/G+0?=
 =?us-ascii?Q?sPVwFzSfrMDSb543aiY8qL8UgorX+FOaW3el0RaRkilHypLWXgcFIa7yQP5d?=
 =?us-ascii?Q?aopdo3qsRQi8FCen9ZVffaE+LsaWWKz6kjB3dlnFTmrHhUZw5xE1+6iIL/UU?=
 =?us-ascii?Q?+O4RbuBVwUQUt5iWFfy1zCeLXiJcJVLoUXgw8d0q3RQEu36ZrlR6Wc/Lgbxt?=
 =?us-ascii?Q?jM3ZUWUSZBD8B3lIwMhF4lauTjEuw8h/CEFxu1ozFm1Vzz2VfvqwMWYH5pR8?=
 =?us-ascii?Q?u5yZ+HyFaJOntI9ZdEGdkVNGsb3TNfPRAOLqpZeeZjJ2yDVmJAJBqKR8W/FD?=
 =?us-ascii?Q?8KmBOZKtt01A/ToWZgObezoj4PA9U9nQt+ncPtulPbDKz6U5V1DMJzawEM9j?=
 =?us-ascii?Q?Ecli0HywG/gAcljk115gWsjYjD9MOmXOmOomdujlwA8tgkgxjuZKB0k4J+ew?=
 =?us-ascii?Q?a/QbUFfHF4w0DkTj34o9f+cuDpa+ciyK1yB5Fr3JpbHeD35b4JZ03JEj10Tr?=
 =?us-ascii?Q?glkwk0PaewlwrW05H1XvtNCiLgaD1npWpSzpEECjPbB0HGQ+/qhYCe7eT5dc?=
 =?us-ascii?Q?58d1ZQuweKgMIBegli9VHQ8/MF2Upku/ar2eVGSC0id9Jyz6vRCPPOptj9Rl?=
 =?us-ascii?Q?+3iwo/BJ+qfojm0A4qWmdhI57F7PRtEIhU6p+CYxwD9hDgJB8czDDpyG+ZoQ?=
 =?us-ascii?Q?ykl0RrroYwGjuG60Z+oxtqk1MI6bIhePvzfw3nKZ2BhuUH7x7elWm6VyFpFC?=
 =?us-ascii?Q?JzUcgMQCGi0+Sgifj8YIGdnZNWlxBZPJqvTzHJTebGcmZbOZyUN0HnSHrY+R?=
 =?us-ascii?Q?lGwwjfb7msO9bNFQqFopNmpbJCAVKYfCOjI6ba3gsKQrV5nvCeaiCZV1fIGU?=
 =?us-ascii?Q?KK4oKfVz99R5cLKF60aR4/c+cqH6b1nEhSWBSlEq5XhhFN59iou4Vasv89+n?=
 =?us-ascii?Q?ty7JRA06Gs3CX5k3C06ZsjiRDCogExXC/MibW95+1S3Xvow8cJJHoCZydZf+?=
 =?us-ascii?Q?KSrEZ7iE0ILLByWz2sJ0VhJSK64+zZ4u8JprH5yYauy6bLMiaLjRjPgcE43z?=
 =?us-ascii?Q?ylurx37LtZOlgTrf4rMdhvvYMpEQCX+f/dbvSH4S7Sm5nAJ6dKj4pW7H6nFJ?=
 =?us-ascii?Q?C9ognnM6ekcReAx24NsEXk5f6qM0es2mRWeyAy7cPFF4m4z3sXNCTU0242eF?=
 =?us-ascii?Q?Thcq8A0T1yYMX/mMARe/gmaZ7fxwnpsvS8WMoFM7bQzDn2Paxy6G+Vlbec6V?=
 =?us-ascii?Q?rdxNpQxoHww0UMjck5J1yHF8YOGI7AX6s9MNlOLUwYSwblWudZkD2Ia3+w1D?=
 =?us-ascii?Q?rYFUsga4BqydV9DBohSnJl0ox2P5J7X5MbaXdvstUHBPKrxWPEVI2mrBBUBY?=
 =?us-ascii?Q?6dy3lf4uk+9VG3Zn6jzc+m2ZaBpZ14UURwINARX+LqJPz8ziLIw0pG2vQgqD?=
 =?us-ascii?Q?3qyInSmR4LUQ4cth0CE3h2entJce5oNJYsefkQVnxqOHCHh0wlVu7lH+DT+A?=
 =?us-ascii?Q?7qtmxSpHMj8APaKAyhwXM5hH0fX8Pkg1aBHpZbxilQPi/uY4gGH4aPkkZBBF?=
 =?us-ascii?Q?mIe2UQBps+vacQujOx0K+0OGXd0mJOdmgjpIzPD2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e93f87-72c4-4be0-a7b3-08db15b4ab90
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 15:43:11.9581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fidqQm179DOsEaQkCzqmaeGpIKCgzPw1WO75S3xUT99HC+DvQIN0cIc+mABj+mPnitcqXAGFV+sQbQbeIDsfVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5285
X-Proofpoint-GUID: pojXHhaYKbWrYQhUmO2pUwxRDyeRWnlX
X-Proofpoint-ORIG-GUID: KtMX7LFMR5IZ5ddY5BFwrQw7fegDMwih
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_10,2023-02-23_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Niklas and Martin,

Thank you very much for the pointers.

Thanks,
Nilesh

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, February 22, 2023 10:34 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: Christoph Hellwig <hch@lst.de>; martin.petersen@oracle.com; linux-
> nvme@lists.infradead.org; linux-scsi@vger.kernel.org; GR-QLogic-Storage-
> Upstream <GR-QLogic-Storage-Upstream@marvell.com>; Bikash Hazarika
> <bhazarika@marvell.com>; Anil Gurumurthy <agurumurthy@marvell.com>;
> Shreyas Deodhar <sdeodhar@marvell.com>; Shreya Jeurkar
> <sjeurkar@marvell.com>; Jeetendra Sonar <jsonar@marvell.com>
> Subject: Re: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
>=20
>=20
> Hi Nilesh!
>=20
> > The 6.3/scsi-staging or 6.3/scsi-queue branches are still at
> > 6.2.0-rc1.  That could be the reason we hit the NVMe discovery NULL
> > pointer dereference issue.  Any plans to pull the below commit to
> > 6.3/scsi-staging or 6.3/scsi-queue branches.  Or am I missing
> > something here.
>=20
> Except in very rare circumstances, the SCSI submission trees stay at
> -rc1 forever. I generally don't bring in stuff from other trees to avoid
> problems if those trees subsequently have to rebase.
>=20
> It sounds like you should be testing either linux-next or maybe a local
> ephemeral integration branch featuring the various topic areas that are
> important to you (SCSI fixes + staging, block, NVMe).
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
