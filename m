Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0690C54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 15:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbjAIPKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 10:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjAIPJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 10:09:48 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF8AB90
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 07:09:47 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309COtgx018465
        for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2023 07:09:47 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3my6yw4cgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 07:09:47 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309F8P3u031451
        for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2023 07:09:46 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3my6yw4cgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 07:09:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l49qkGOav+lsA8kCcLl/PG9Iak31lK2kR/8XqXiKreg0VvIHfFEYFQA/xs/Cs0rxeXkXHlEZCRgYnx1ZTAbkByGVH+5UjFnByWbLOibSqEl3S/Sa2gN6ZuAm6G1NcIt7V+nVq7O2WuDVFD1vl02Qcr6YDdp6sjC8MFyDzWJwi2nX+a96uilZvdk3RNMkiG0SFDzQ3hon/dLXxmwN/Zah1xMq/bm2720HV625pd7gOWPeErBjKpoSNGyY9rRLcvdYudqI6mQMuWdbR1M3Rn1tx8RqLSM/QJ5ddBmO6HUBHO4WoA5aTJ1p3BFedP+jvM7V8wD6fenYNClG0JLRTxc4dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m65EPcFuFwVSoM+n6DITdU+/WXux1NHMIFY6HpHnMdg=;
 b=B4TBXQjS0V6cgMBgN7tR72hNTYaKg/CUroWiA86Kah1EzEimbmeK+95Ai9ZQoOzR6rZ5JW9+1uO3gUlk17L6OXyoNrQuHih9SZbJYG9ly8plfVDmsHRG1rO72nbzZ0QOje5H5er/rpeUPlQzvQMD5SQETN1nMxVlW+pP/XB2v3q+nia0tjs8fBkJnX4P7qHEHnkop7B0gQs72ghwnN6bd2up/XNguqhuSy6L7QQznDx6EcAQNBHdG8r0OwUd07yZX8Iz0/V5/I5sgIXhMqoL3hT22lJqaC0Ubnyn98dXK4kaWKPxHIVcTVBPoMvOIaIu+XRQZU1v9PYy1aLZGiINDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m65EPcFuFwVSoM+n6DITdU+/WXux1NHMIFY6HpHnMdg=;
 b=gwtppeiMTumAj7DW+WFfK1JvNBFMxhDMNpVjxnFlICFXYjbz7n+e1VVJ9bJXuMpCadzXIIbTcGsUAZnoEpp0W9PpMd7GfPEVwu+n56mS9dLtJLn/+srBN3ss5K2tYl1zpvELfmyXAJ/P5LwocDM4Ac0d2y8yad83aevkSikXjCo=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by SN7PR18MB5361.namprd18.prod.outlook.com (2603:10b6:806:2e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 15:09:44 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::c54d:f75a:3934:cda5]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::c54d:f75a:3934:cda5%5]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 15:09:42 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>
Subject: RE: [PATCH 00/10] qla2xxx driver enhancements
Thread-Topic: [PATCH 00/10] qla2xxx driver enhancements
Thread-Index: AQHZFb9rII6CORAf2EmFwOVHb6d2s66WTDdw
Date:   Mon, 9 Jan 2023 15:09:42 +0000
Message-ID: <CO6PR18MB450025856B0B2472A29A2062AFFE9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20221222043933.2825-1-njavali@marvell.com>
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbmphdmFsaVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWEwZGQ0ZGY2LTkwMmYtMTFlZC05NDkyLTA0Yjll?=
 =?us-ascii?Q?MzlkMzM0NFxhbWUtdGVzdFxhMGRkNGRmOC05MDJmLTExZWQtOTQ5Mi0wNGI5?=
 =?us-ascii?Q?ZTM5ZDMzNDRib2R5LnR4dCIgc3o9IjMxMjQiIHQ9IjEzMzE3NzUwNTc4NjYz?=
 =?us-ascii?Q?MDczMyIgaD0iL3ViNUxJTEZBVkxxNFNzaUhCeVpQaDRRbENvPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBTmdIQUFC?=
 =?us-ascii?Q?TkVueGtQQ1RaQVV2S3RWdjd6d0RDUzhxMVcvdlBBTUlNQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQm9Cd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUEzVHpGQUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|SN7PR18MB5361:EE_
x-ms-office365-filtering-correlation-id: 916c672a-1741-4387-a3a1-08daf2538953
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3HjhC11kC5bWcRtn30KkjxaoaYz/n7hOmiK86omM/hw6RZnUXIoDTkOJCR3scEOrCboGOaVdX4f5vwtdIx0aJv2rpVIE7JiDhlMV7qSsDT6p3BkVyEghHjCUvEjnDEU1wDuGXb4YewicqC7ZrcJXVILRIwSqzgCwkBR/UeDX7LwdDp7+0++Xwzpu+J3H2mh9ZgY51oaO3kcWEtJvR9N7LJ1dEdf84vJivqLLaJd9HNQrPFuTFXWhWFxnqeN0/yA2BOZ2d94PjKn/u4S55A4KvuyFU3Qq6O/lvFlv/UJXxNViXWrEwybToAQRPKe6QkZbVr+amW/2iMPbS9PjGfxDnR63NVk4qHQ3svjYuHs9JIiTVpjXScaL4E8lsEy13KAclKAUfbWNY/H6M66SZCUhX5rYnNUMEO3YwXLr48EyZ8E2t7dRIAj/Pr6nfhlFtCgN2JHYVVtmJ0HEX0hN+JM6FkLLQ4lRQZwrSLD1rAsfmM6tCUfhBLP9HisPfcs0TI9GyyfnvSkUlvbGcsy9VUpyP/i52TwOqm1vOZW7Xs+wrR3KHFLEm8XaLRCS2fx4VU/e9BMBYCngrzrOLZNr4xS0LS/MHQoYbyCzH1Y6kHyZG7E6fyBagp77drTeVN58RWEgZeYlVHwXbLIkjWJCGQFycpbNE8/EqV9I0KaWouKDh55Kz4AIOkUof93knv/fBPg8TSoGylbt/Df0A3yNKbmZgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199015)(41300700001)(54906003)(110136005)(316002)(64756008)(76116006)(8676002)(4326008)(66556008)(66476007)(66446008)(66946007)(86362001)(38070700005)(38100700002)(122000001)(5660300002)(83380400001)(52536014)(33656002)(55016003)(8936002)(2906002)(6506007)(71200400001)(53546011)(55236004)(107886003)(9686003)(186003)(7696005)(26005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ej11mUaIl+Nb7hiKeyEhgvFN3h3D0rC9445mMiqVV7GejH0e+kSWOq29WlKo?=
 =?us-ascii?Q?ND/GoJGNKyDix56tjqATrzrpCnc2kJtKZK1NOOfcMr2SqU8njY7Vr+Ip0PGh?=
 =?us-ascii?Q?MUsitFE45c+xc1sblVcqKHMnggOY1vp/D4RCpe+eHz10iMX5E/tNzTZsV3eW?=
 =?us-ascii?Q?etLLR4KeXCFIfY80wvaxaBcJPEro+BfXOjeppljyuSlUmgdQ+gewQWhYu2c6?=
 =?us-ascii?Q?UGq5VOYKYE544LDge15VcOiWx+q6XgQYjCgfHOWvyZ1PvIb76/N4lH4kf2HD?=
 =?us-ascii?Q?dLqju1MEQ2OmT2PTkue/X5j2fPixCf/PyeR+TyGIKxI9xjTdJBK81rDaElrU?=
 =?us-ascii?Q?WT3+ThQHzRtj6CZ7kPVVpUQJA6wT0fwQtFv9dwFej5PBOuttK44THg+sqcHw?=
 =?us-ascii?Q?R67W2WjhxxsuUPOCgi7YZmy0dsWN5Lb7x202+x+QD7CWILu2fuBUZgRVknu9?=
 =?us-ascii?Q?kcKAoccNwGkDo0uyHiMzsmtywNXIis54+r6YcKv6ykh3NJ6yUz0tc7m4gSGP?=
 =?us-ascii?Q?UD5agu9DtTdvQKQGMHmCRKSJ1/tbOmkt4tMhVoSo97N7hogMKWDbD9148PwA?=
 =?us-ascii?Q?JowUyGoRwTG8p1HbQ+7hqYvk/bEj059NHvLL53ue4thkxd2PZzkKpUBMkAVu?=
 =?us-ascii?Q?v8nPQjMlT7t97GPDSy2/vaHjaiUjn2QtgEYfxEkhg4O6ily9v5/UmgHSVciG?=
 =?us-ascii?Q?a53BnVFOLrG8BfpnRzWeEQNs60KHyf0UpPJSSMv1gIB00SzbaiDoir+Z8qcK?=
 =?us-ascii?Q?vSnX6+8JXZ2wwMM4yXWCKwFMy0BK6aXsdi57xyWeAv6G2Ycc6gQbR8PvxW9/?=
 =?us-ascii?Q?E8vNF/MqrICdQCCGgbea2WVU1a5ktGN0U8ihByeqXTlU0/3C4Hrvzj7MWRHW?=
 =?us-ascii?Q?v08Olej4zx4DPnkWaSH4YbBO7D76A+Xb9reMzRWt3tqjBrOiTEAvEipsAG67?=
 =?us-ascii?Q?o7cEj47k2CgAThd/m8PoxaX77s9ueCxuL9TupXZoBxVTpWjAP6cnFDxgVQHD?=
 =?us-ascii?Q?ePUURULyCxflw4g1pLhc+BbRON8nc+MyT0RrcA4TvvQp/eovpQH6gObzUOhy?=
 =?us-ascii?Q?9aPBpGjnx3IXSLR9td0Oz7OZfM1OnOEQK2V7rzKWDwiklHE9j/UA04/+3zw3?=
 =?us-ascii?Q?NgkOUx4C/hqEKP1zSY+IfSqbisDVMpHoa3K0glHvB/Ks/OaXtBuJb9ArAfO7?=
 =?us-ascii?Q?K7kizfoqsXOlaUvgVYsLoUzFrM1Sj5o4AI9UScBqWFYtdLYt1ECX+vWej9yG?=
 =?us-ascii?Q?L5ryeJ76ZOb3z67HYijRUMxrjocW4DBo3mTVT8O1EH2H/FzfyX1oYdoKMukw?=
 =?us-ascii?Q?gWjqokroUlNeRa6nbkYHrw09+FYqsDbWv8AN81dbQkfIXzOZG9/5ZOD614sv?=
 =?us-ascii?Q?8E1nlOWbv4xVA9cC6+dhqmAqjPk2ojjnF3/dzfV3CpOycBqGtkiSGamGq8fZ?=
 =?us-ascii?Q?juc9Uxw2OCifLdkARkqjo59J/nhqzGDXsoq+kdW2wQZe+vG6uR0jipyR2v65?=
 =?us-ascii?Q?/BHMtcMCWoddmUk36zZFVhA02FuiuJGsFVZARbUguBH/YyKbPJmo9pN/AhL5?=
 =?us-ascii?Q?Gvi1PBvMu5kBSUi9N/HRtN0uN9F3tHADEE/VZp8l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916c672a-1741-4387-a3a1-08daf2538953
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 15:09:42.6357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+Yxavi+nBGtmRQGyKOwR0w5wrMtpsOneDRKhfp4wcr483o2lX46cjHZaDr6TZIjVDlGFn+1iARuDEK/WvdxNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB5361
X-Proofpoint-GUID: SreSQsrlA9GK9xU-3gZkqy26pBfqHjjw
X-Proofpoint-ORIG-GUID: YUaU4YOgbbHfxRwKhKHt818Stsx59mAO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_08,2023-01-09_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

A gentle reminder for review of this series.

Thanks,
Nilesh

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Thursday, December 22, 2022 10:09 AM
> To: martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; Bikash Hazarika
> <bhazarika@marvell.com>; Anil Gurumurthy <agurumurthy@marvell.com>;
> Shreyas Deodhar <sdeodhar@marvell.com>
> Subject: [PATCH 00/10] qla2xxx driver enhancements
>=20
> Martin,
>=20
> Please apply the qla2xxx driver enhancements to the scsi tree
> at your earliest convenience.
>=20
> Thanks,
> Nilesh
>=20
> Nilesh Javali (1):
>   qla2xxx: Update version to 10.02.08.200-k
>=20
> Quinn Tran (8):
>   qla2xxx: Remove dead code
>   qla2xxx: Remove dead code (GPNID)
>   qla2xxx: Remove dead code (GNN ID)
>   qla2xxx: relocate/rename vp map
>   qla2xxx: edif - Fix performance dip due to lock contention
>   qla2xxx: edif - Fix stall session after app start
>   qla2xxx: edif - Reduce memory usage during low IO
>   qla2xxx: edif - fix clang warning
>=20
> Shreyas Deodhar (1):
>   qla2xxx: Select qpair depending on which CPU post_cmd() gets called
>=20
>  drivers/scsi/qla2xxx/qla_attr.c     |   5 +-
>  drivers/scsi/qla2xxx/qla_def.h      |  45 ++-
>  drivers/scsi/qla2xxx/qla_edif.c     |  89 ++++--
>  drivers/scsi/qla2xxx/qla_edif.h     |   2 +
>  drivers/scsi/qla2xxx/qla_edif_bsg.h |  15 +-
>  drivers/scsi/qla2xxx/qla_gbl.h      |  18 +-
>  drivers/scsi/qla2xxx/qla_gs.c       | 407 ----------------------------
>  drivers/scsi/qla2xxx/qla_init.c     |  75 ++---
>  drivers/scsi/qla2xxx/qla_inline.h   |  55 ++++
>  drivers/scsi/qla2xxx/qla_iocb.c     |  12 +-
>  drivers/scsi/qla2xxx/qla_isr.c      |   3 +-
>  drivers/scsi/qla2xxx/qla_mbx.c      |   8 +-
>  drivers/scsi/qla2xxx/qla_mid.c      | 302 ++++++++++++++++++++-
>  drivers/scsi/qla2xxx/qla_nvme.c     |   4 +
>  drivers/scsi/qla2xxx/qla_os.c       |  52 ++--
>  drivers/scsi/qla2xxx/qla_target.c   | 103 +------
>  drivers/scsi/qla2xxx/qla_target.h   |   1 -
>  drivers/scsi/qla2xxx/qla_version.h  |   4 +-
>  18 files changed, 529 insertions(+), 671 deletions(-)
>=20
>=20
> base-commit: 1a5665fc8d7a000671ebd3fe69c6f9acf1e0dcd9
> prerequisite-patch-id: be976009b5ea7851eb74cc9d2319ac6382f488d8
> prerequisite-patch-id: 752681cb1db6b24e510674ec0d74df41eeca8cf8
> prerequisite-patch-id: 0b446a33d76b16b1a439885ff70f49c1ece3ea5f
> prerequisite-patch-id: 61d396fc35fa2735fd25b9cd0a272ec0541c3711
> prerequisite-patch-id: eedf715f4751c46c16551b3a2148613c52021415
> prerequisite-patch-id: 69cf2bdc6e811b5e2c34c525e738e4091746ec98
> prerequisite-patch-id: 921e1903d89e66264af2378b608cdd1b2b62f61d
> prerequisite-patch-id: b5fd5b67208c4a553cf4de664e671e07d899435d
> prerequisite-patch-id: 96bbbf7f836bed5400912a1dcfb97716649e94f7
> prerequisite-patch-id: 4c9a15be983c52b527cd83a242dd90f66b80655c
> prerequisite-patch-id: 5c8db5ab15495994d808f149a1ce7a8bb126e697
> --
> 2.19.0.rc0

