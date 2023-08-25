Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98842C3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 06:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbjHYG55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 02:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbjHYG5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 02:57:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AABFE6B
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 23:57:30 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P3YHHS025730
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 23:57:30 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3spmgvrg9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 23:57:29 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P6p9pI020129
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 23:57:29 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3spmgvrg9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 23:57:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxpNTSAhlxKv+zRhzX36ywXHBOtyb59XAS3gfpQzlWkjelyv88JPxIsrDF74W4AWab5lvjzGcreAKJVFEfFz4cVYeelLy0iQqArqwdcX16xnSm3/h4Xv3uPkqte8OPep8hsmrXMniGqwQhguBCoG6gbVZPtb0V7+cvcnHqysjK/pfPXDg+TLYqE7Y4YJFkngzGbT1vytjtvIAKs8/ETNatGo5UaGPg4GsZwGzW86Sc/MN7/4mGS7T3AUmNIDHHcPSHiIW+jMLd5pvKDlFNSq4rVn9K9szBi8P/62QNQUmTKL7SRM+Kpb/Rhu0S8pQ5DFP3z/bjyu2SkoDF4nEF+e/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPewEcnGokOt2ZlsiqwkI0Vxd6q4T2ORdjSt89VoiwQ=;
 b=XeM4NZ7mo0em5NqtRzTHGVEgIYqSB+OtJAxf4j3oNuO35EBNhEXyKx7Cz242x2S2mig/xsRmyQuG+0v7Hzdk0uI6eO7750d6f6xbxp7uMp9HQEBPM584DOae3qCVHMZtdnVwEc7lb8Y+JMEgpLwQ7YTCw+D/pxNN7mfeI4p9CAkqOUXiLIN2QltpRGIg8gWbhU2TK6kfdjej3f1e4RcF3WHivKDfS0vq7HPJjbRJYi8vcRljXJDqeC8J7aBlnZrm4UZVyc/h7Asj1OCPnky8PLrQ8TNi9fLN9beyCdT+XXMT90/sWbt38LUw/6xOIU4/dXVjOrQMQrf0IOnkQ6Lbpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPewEcnGokOt2ZlsiqwkI0Vxd6q4T2ORdjSt89VoiwQ=;
 b=oi2maxXE2Z0x0X7ro0r3usg3/ibs82bV3sj/ENwfNoZXbU6FLHcMjO7qbPizgET1ZXlfMGiPnw0c46dnb17t3gP+0G5iO7JugzihTkYUqpwETU0XPHeglyZy/ytG5ZpKKeqPB4wmFmZplrK7nRpAOSHL2kKo0WymYK2PAd6OLfU=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DM4PR18MB5220.namprd18.prod.outlook.com (2603:10b6:8:53::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 06:57:25 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::3d05:8ef7:4dca:995e]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::3d05:8ef7:4dca:995e%6]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 06:57:25 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>
Subject: RE: [EXT] Re: [PATCH] qla2xxx: fix sparse warning in func
 qla24xx_build_scsi_type_6_iocbs
Thread-Topic: [EXT] Re: [PATCH] qla2xxx: fix sparse warning in func
 qla24xx_build_scsi_type_6_iocbs
Thread-Index: AQHZ1p34xE6KPg93OkuY6IZoRXRmoq/6OIuNgABcDbA=
Date:   Fri, 25 Aug 2023 06:57:25 +0000
Message-ID: <CO6PR18MB45008C41EF0721C74ABD4DF8AFE3A@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20230824151626.35334-1-njavali@marvell.com>
 <yq15y535328.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15y535328.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbmphdmFsaVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWExNjg1MmMxLTQzMTQtMTFlZS05NGEzLTA0Yjll?=
 =?us-ascii?Q?MzlkN2M5NlxhbWUtdGVzdFxhMTY4NTJjMi00MzE0LTExZWUtOTRhMy0wNGI5?=
 =?us-ascii?Q?ZTM5ZDdjOTZib2R5LnR4dCIgc3o9IjI1NDYiIHQ9IjEzMzM3NDIwMjM5NTAy?=
 =?us-ascii?Q?NDc2OSIgaD0iNnkxalpTMnhPRXNxQmlLWU00QmdtS29jVFlzPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBTjRQQUFD?=
 =?us-ascii?Q?QjNmUmpJZGZaQVhZYkNuZUFxSitDZGhzS2Q0Q29uNElaQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQnVEd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFFQkFBQUE5UmVuTHdDQUFRQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFDQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFZd0J2QUc0QVpnQnBBR1FBWlFCdUFIUUFhUUJo?=
 =?us-ascii?Q?QUd3QVh3QmhBR3dBYndCdUFHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1B?=
 =?us-ascii?Q?WHdCeUFHVUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFZUUJzQUc4QWJnQmxB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FGOEFjQUJ5?=
 =?us-ascii?Q?QUc4QWFnQmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBSElBWlFCekFIUUFj?=
 =?us-ascii?Q?Z0JwQUdNQWRBQmxBR1FBWHdCb0FHVUFlQUJqQUc4QVpBQmxBSE1BQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFHRUFjZ0J0QUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refthree: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJ?=
 =?us-ascii?Q?QUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBWndCdkFHOEFad0Jz?=
 =?us-ascii?Q?QUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBB?=
 =?us-ascii?Q?WVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QVl3QnZB?=
 =?us-ascii?Q?R1FBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0JqQUc4QVpBQmxBSE1BWHdCa0FH?=
 =?us-ascii?Q?a0FZd0IwQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFn?=
 =?us-ascii?Q?QmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBR01BYndCdUFHWUFhUUJrQUdV?=
 =?us-ascii?Q?QWJnQjBBR2tBWVFCc0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?MEFZUUJ5QUhZQVpRQnNBR3dBWHdCd0FISUFid0JxQUdVQVl3QjBBRjhBYmdC?=
 =?us-ascii?Q?aEFHMEFaUUJ6QUY4QVl3QnZBRzRBWmdCcEFHUUFaUUJ1QUhRQWFRQmhBR3dB?=
 =?us-ascii?Q?WHdCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBYndCeUFGOEFZUUJ5QUcwQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VB?=
 =?us-ascii?Q?QUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhRQVh3?=
 =?us-ascii?Q?QnVBR0VBYlFCbEFITUFYd0JqQUc4QWJnQm1BR2tBWkFCbEFHNEFkQUJwQUdF?=
 =?us-ascii?Q?QWJBQmZBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QnZBSElBWHdCbkFHOEFid0Ju?=
 =?us-ascii?Q?QUd3QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFH?=
 =?us-ascii?Q?VUFiQUJzQUY4QWNBQnlBRzhBYWdCbEFHTUFkQUJmQUc0QVlRQnRBR1VBY3dC?=
 =?us-ascii?Q?ZkFISUFaUUJ6QUhRQWNnQnBBR01BZEFCbEFHUUFYd0J0QUdFQWNnQjJBR1VB?=
 =?us-ascii?Q?YkFCc0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJ?=
 =?us-ascii?Q?QWJ3QnFBR1VBWXdCMEFGOEFiZ0JoQUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5?=
 =?us-ascii?Q?QUdrQVl3QjBBR1VBWkFCZkFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdCdkFISUFY?=
 =?us-ascii?Q?d0JoQUhJQWJRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVB?=
 =?us-ascii?Q?Y3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZHdCdkFISUFaQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|DM4PR18MB5220:EE_
x-ms-office365-filtering-correlation-id: 773928f0-d2cc-4cba-f795-08dba5388a04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gLZzMiae5VGsZ75j4i1//jxDmT0DfLFQG0rOitQadM4KNPEmSlDlYrRyF+NVy7eh38EPZsKvIVbXu6gSqsXaVQpzA9c7XCYUf19hC+GrgiboNwbW1DypQV/A18vZuQRU1BB3WZ/5omEB2iE+1+nj/awDEZjwbZGRN2wLhUOzUtWwNJxOy7bSC0s6dZhBs7wdUqIjQ0Pw5PMOBjPW7GXxJhmHPCLLKuQ7ut0nIzbZ97n+YK/pS9JWnAYJMQXjNKaaoEJ11JPCGSuLkFf1pl1i0gCJ6s5mB/9B5VjW06iv6fe2I0rWsLXliZMi1cp2oZm0GKMmHQFjyYsQ4M+2Nkjix1rpO/tTvVl1RJotirTh0T7hys5FgkEQ99uKogfHSOhrqttKMKy5hVJ09kKS7UK5Xa8KMzpCfXVne1/rwvEJVSU5ueyKq8dzcQmzYBZUde/+spIPJYKE3muxY1XdL+/Kuy8yOJdhLdurmMvthWWnHn/8MVowbBzIpyOoSO/w7jc/gdcrkUEG0WeLn2PbX0gKrU5nBPqMAozyAiqN68N5fJp0ugR3dHo2+lvDZxCDm57CyIpzVXIy+KruYgKmx1EheELl/HMuz91Ub7NwHL9v5Ok=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(376002)(39860400002)(366004)(1800799009)(451199024)(186009)(83380400001)(9686003)(26005)(478600001)(55016003)(5660300002)(52536014)(107886003)(966005)(2906002)(8936002)(19627235002)(4326008)(8676002)(38070700005)(38100700002)(122000001)(6916009)(66476007)(66556008)(66946007)(76116006)(86362001)(71200400001)(41300700001)(64756008)(54906003)(6506007)(53546011)(66446008)(7696005)(33656002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7IgYPSCLaAfHoos8YX72mal8Br4QD2l4uNcf8lHCf2VATk0py21cr5789G8/?=
 =?us-ascii?Q?dkbimzIUn3GrPCR+3MhNi74Xhg1Zw3Dl5LTi9dzVUf/HFxORIEb2PNZOq7PB?=
 =?us-ascii?Q?+XqeE4DEqtHuqb0qmQeX07vlqSZpthOH1oNfBAgo6zdNQZitkF/iqHv2+xA6?=
 =?us-ascii?Q?E6dlXhx8IClotg7P3fKgq4jfvyE9L26myyMpibtxzxUUrs6mQTPKrIyul2Xh?=
 =?us-ascii?Q?AuLexy37eK4OOcJFfnKeRl7w6cgrNWtfTuUl8Vq7AFS2ZIADp76w3P41Byyg?=
 =?us-ascii?Q?qHJIsMvfD9nkPwvtlPfaWP/g25jrNlhpRK0fhmVm+8tU3einF62KrQC57jbZ?=
 =?us-ascii?Q?3fkJNCHlY/YY5EydDDUHc8ZKQGGlZusm9jGeMJBqnaE4Q7Cex1eA5qglP4Am?=
 =?us-ascii?Q?AsJuL1govkB/DERany5F6yQSIXROHj6YQ3sSh8ge207OdPVBcA/HvjJLsSdv?=
 =?us-ascii?Q?KFecQ7YD14JTxPKFFaYveowBs+NhKMFFw7FFvaOZTxaAiZS/yWxqt/pmAoWt?=
 =?us-ascii?Q?0RaF9WnlewXlIcfmhaSL/4pbID/t1an0j/WocZkWovrYn/e63h8l3XYuXD3v?=
 =?us-ascii?Q?EGBNJFZH+hzvI1Tyo/CEB34YNPIxCjU22xkmdqDPahQlaqU0J1tsbSmiQKBO?=
 =?us-ascii?Q?RNrR9LhydS56kxcXFq/AYNbc6G+Ne8g6TNHptrMUQil9y3up/eKcDjpwZJRf?=
 =?us-ascii?Q?2Ng80ZgDw6zvoxdIAG3xBl3lnDeEF9KhuoMzRr/gUU1eF090Cn+Ru7hF+c9t?=
 =?us-ascii?Q?1jKxrwUO4aeW0S4uLCGO0CD+MHVs6v+w9K/2+jfyBx2gRzDFo4fzyf/FszXa?=
 =?us-ascii?Q?gydE8vKuHl3ywIGFzf/ETSV4T/U0z894nXwTzMX/8N3mqCqrvWXQ++qU7icy?=
 =?us-ascii?Q?hFKvwgmywhVrYN6KSgLM3NExGUlNSfLH61xVVCrTKoZ532/xy2eMm+zyRekT?=
 =?us-ascii?Q?3yYkxfkEpmuEl0Fvt1Ekr5PrahaAIaS0bWmOivwTlLSoeknGd6tfqzT6EpFP?=
 =?us-ascii?Q?VKaEiAwkwfQkhpoYKCBxPNegCfL0titz6i/YfIz5VzYIcXzkz06AnpPq0OjY?=
 =?us-ascii?Q?jOIhxqTbmzk7M9AyACZTnccaQDLQXDt4+9T/opQdY4Zgg7wxSCyEgmF8bLqW?=
 =?us-ascii?Q?Ck+sy1WRBi31r4zBBV2kgZNi76DFfp2Pmsh4g8Hk2cY2eNbQMK8IJ5H0y2m5?=
 =?us-ascii?Q?84+SkGnNDzZV/OR3nsJ7ElNs4fReJO5pMgyKq/qCitC84m5xE06IegGiOK63?=
 =?us-ascii?Q?IRjmPS6mpJiGXC35HU8kbETXx794dv/e3L/mBQpgYGzbZJtyd4ao9VHWRVk9?=
 =?us-ascii?Q?S39b+R9fUa0uZyJSy+5AHdNroXTC/3mGiuzdLKmzbbFQSEaZRqYZrz38exOK?=
 =?us-ascii?Q?zyn36n8lSXRzBQo0YmhKNpvoa3vhISZvZddrTnlO3PS8gB8BdNzcs6lsr8qh?=
 =?us-ascii?Q?Tp+FtnnHeSuGjKZcoBx1KCV/BTd3+xgSxBIFMnASUkqH/JZsgX0kbQseuKtZ?=
 =?us-ascii?Q?Et/Cn8imaiixTORCIkrfyTa3smp59LST3xtyWAongKJfNtidR1MS3DY5pR8f?=
 =?us-ascii?Q?0h8MNpKl349++8aeF3syoN9YFL85KXLbndr8go2R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773928f0-d2cc-4cba-f795-08dba5388a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 06:57:25.4991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8vmhSyd4ViXm1A0qWwKTZboc0L19UMnXkz6s8IfJCDPkzef9u5cDAp5dNCdt3OsMZrkppnOre9WQMErI6osCVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB5220
X-Proofpoint-GUID: UMntzvlyG5BaY30pY4itSaLi8YRTLcN1
X-Proofpoint-ORIG-GUID: F0LA-5wyN9ld-BT9gLcw9pQckmFMtEUV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_04,2023-08-24_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Friday, August 25, 2023 6:54 AM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; GR-QLogic-
> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>; Anil
> Gurumurthy <agurumurthy@marvell.com>; Shreyas Deodhar
> <sdeodhar@marvell.com>
> Subject: [EXT] Re: [PATCH] qla2xxx: fix sparse warning in func
> qla24xx_build_scsi_type_6_iocbs
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Nilesh,
>=20
> > Sparse warning reported,
> >
> > drivers/scsi/qla2xxx/qla_iocb.c: In function
> 'qla24xx_build_scsi_type_6_iocbs':
> >>> drivers/scsi/qla2xxx/qla_iocb.c:594:29: warning: variable 'ha' set bu=
t not
> used [-Wunused-but-set-variable]
> >      594 |         struct qla_hw_data *ha;
> >          |                             ^~
> >
> > Define variable 'ha' before exiting the routine.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_oe-2Dkbuild-2Dall_202308230757.VKMIztAB-2Dlkp-
> 40intel.com_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFAW9wuzbtHIZL
> 7SV63sr8rG59Hctu-
> eGu0G9pxwOXgQ&m=3DTN8k607nHWpfz1FmLLOobTs3fJwzwYurDnbRAyMwDi
> S95QYsQ8IIX2XJsUy_SuUW&s=3DODpU0qHQ2MPh7GQA6i-
> 08iusSGol9W145Tb2U0EqYfg&e=3D
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_iocb.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla=
_iocb.c
> > index 7fbd917f6e1f..0eb8df5ee73c 100644
> > --- a/drivers/scsi/qla2xxx/qla_iocb.c
> > +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> > @@ -591,8 +591,8 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct
> cmd_type_6 *cmd_pkt,
> >  	uint16_t tot_dsds)
> >  {
> >  	struct dsd64 *cur_dsd =3D NULL, *next_dsd;
> > -	scsi_qla_host_t	*vha;
> > -	struct qla_hw_data *ha;
> > +	scsi_qla_host_t	*vha =3D sp->vha;
> > +	struct qla_hw_data *ha =3D vha->hw;
>=20
> It doesn't appear that either of these are used at all in that function.
> What am I missing?

You are correct. My bad, all statistics were moved from vha to qpair render=
ing the variables unused.
Thanks for the review.
I will post the v2 soon.

Regards,
Nilesh

