Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65C5C64ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 09:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjBUJz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 04:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbjBUJzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 04:55:20 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7C11BF4
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 01:54:46 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L4PXIN023962;
        Tue, 21 Feb 2023 01:54:11 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nty303kf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 01:54:11 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31L9pr5o009554;
        Tue, 21 Feb 2023 01:54:10 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nty303kex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 01:54:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+/eX3MlgEqBxfQsrVsBmnQ6+PZ3igWDXoTO7wm4/4MHyDiGk6ht05v3ORvR2Z9xLp8ShgMAhIrEhQCtoI4wKTK8sIexFJ6lburuT9h+9EAjJV2hVI2g0P+PvMvxveEzYYmDkUvFE6paslaAczogBVa2n54E+hZw509an87AemEgkxtbCHutGdtLLUfoTwcZMguBPV2fQLpGfMKpwMfC7KN2LEhGQT0esSVZ8/nbXDZ7C3eBxBD2JW2N/Xsxy2DINzdw8jYLvxciFrwl/DLSxZKD0aB2Ravd0/2cNASN0GY0CRUtGUv/bUNoTMCskHMaWDWRGYkgdAxJKJWsyJOthQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqIV2LuLrJi5j+OOOFTtf4YiOlKZK72To/9ZNo8nvwk=;
 b=lzcu3lIp5B8A9Dvr2vIoEZ/4VAea8ugiurZEcQTGQ8Av42sCp/9Tptgm40o5Oh8fXcmDGurthv9yywuCeQraZiIq9gVKEvEEuB+9DIN96umIkkfPYUeNhAY1yDp8Rzo3cqBcDpNsO4vXLwy9WoTLW7cT8uiPLNQgcSt1tXpqEFQWo+X2xo0wivbSmBXQzrD76H3flmyGEH5O+ewnfCzrhuc7wf9bqoMZrOZSNbw7vkhurld7BTCbId8KXWrA9PA7AGSPCaj1dUaNTymxB+yd080O2/yCJ5YSUStawibiymw7AZpcwXiaDnBX2oY65Jw481NwNbWGVsy6ZFwLHWwUHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqIV2LuLrJi5j+OOOFTtf4YiOlKZK72To/9ZNo8nvwk=;
 b=SungVh0dmUIaOgkAEEPD+xAgKezAsZ+/MA1issJwddq3RCClNycXvrv7aj8HnKeomnwNr6WC0MTM8VRxNzkHI/f2IHMV2XdglVZxIrSb8T76bIN3jQfN4Xjjw1wnlFviHHTB/+CsRrihDJro6UOodgQ9GHvzh37TighdGXEd4QM=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by BL1PR18MB4262.namprd18.prod.outlook.com (2603:10b6:208:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 09:54:07 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::1e01:6dad:5a1f:fc7d]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::1e01:6dad:5a1f:fc7d%3]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 09:54:07 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        Christoph Hellwig <hch@lst.de>,
        Nilesh Javali <njavali@marvell.com>
Subject: RE: [PATCH] nvme-fc: initialize nvme fc ctrl ops
Thread-Topic: [PATCH] nvme-fc: initialize nvme fc ctrl ops
Thread-Index: AQHZRdWFaDmWQO/9wEKq+JNv03x+zK7ZKL/Q
Date:   Tue, 21 Feb 2023 09:54:07 +0000
Message-ID: <CO6PR18MB4500AB2CA0C64097EE53753BAFA59@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20230221091842.28219-1-njavali@marvell.com>
In-Reply-To: <20230221091842.28219-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbmphdmFsaVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWFiNjlmMWEzLWIxY2QtMTFlZC05NDk0LTA0Yjll?=
 =?us-ascii?Q?MzlkMzM0NFxhbWUtdGVzdFxhYjY5ZjFhNS1iMWNkLTExZWQtOTQ5NC0wNGI5?=
 =?us-ascii?Q?ZTM5ZDMzNDRib2R5LnR4dCIgc3o9IjQ4NDciIHQ9IjEzMzIxNDQ2ODQ0MjAw?=
 =?us-ascii?Q?MzE5MiIgaD0iYzdzaFhzb3N3N28xcW4rWlVOZGhYN3RjUStFPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFE?=
 =?us-ascii?Q?NGxtMXUya1haQVdQWGV0S2NIUDZKWTlkNjBwd2Mvb2tOQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFDUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
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
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|BL1PR18MB4262:EE_
x-ms-office365-filtering-correlation-id: 20400031-c1b0-4f34-a5da-08db13f192a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mUuAnv6Yigd5ShDOXVVIgWzkhyNTbbilFLW170YBW1bGRDgD71xb7/OIrRoeGezwbH9evySKzAwgsDcqRnjs8cYPfuP0NTJI2RIaBYBBHqAqxvx1hBg+phB9AAF8xArv6RepvpbD7RGAqOexNR89/NXlMLyUWB7vj060wzVWVIZsNxPNWoRNrlaAPZgGo1uvUnaaIG/V16nz2Isnxvt+FBOIlLdug7sxZAnNjuHvbXR760/VW6VCV0hrVQnoTgpJkJ3hIhFYG2jQJ71GPSUWRYFGW68OfvF8VzhM3fVHPM9EMBIKEpZWL6eBuxMHaXyll+qStVKJ+4HpSsHh6YqaWhhJ2PY9Ib73EAHn+RXOb+2XDQB+1LZ9yVwanL5jPMNRCT4szz8r79x28wT2NUzAC0Fv0zIkpp82FlYrbdrVDGOv7Z58Bqc5+6V6/SFJF5jrHRh9wOBkjBv7RGU8xFpWB1qJSQbKtNTjCiaRlsoumbS3utNxDtbsT6DBZxMFYXWD2neUZzzXXjCXKZSZb9yunY0p2KqKEiGkXsUJ0Dw0El91bjJQoh9XqGC1KVIJXbpGWKscuw45IWtJLIP3QhOAmfxziUvuRPbCn/aY3E73xBcdGFIxF/hnsg1Nb2GHVKBkJYBKDHt5q9MbnOfaE97JH4f7xtlUY9Wk4r66m3BG0wDeGiDuIdsSdmVhFWNE7Z6Zd+E7TTRrE1z629zOgrVBVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199018)(8936002)(5660300002)(83380400001)(52536014)(41300700001)(122000001)(2906002)(38100700002)(54906003)(107886003)(110136005)(76116006)(66946007)(8676002)(64756008)(66556008)(66476007)(66446008)(4326008)(55016003)(86362001)(7696005)(71200400001)(478600001)(9686003)(38070700005)(186003)(53546011)(316002)(6506007)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SESxgCRDlOHQl+1/4oBayHl98E+88bbNpHCgMoQMRvBY7qoa7WXgpaukcPgm?=
 =?us-ascii?Q?+oEswtPi8QAiOr5Fx3DnsPUcSLaWoqn8JX55PYNSylYLt431+HDME51Wq9Up?=
 =?us-ascii?Q?eHQVUKO2GnZhEIKNO+vhRS8DsYd3tRHgD3nczQjDb2NJ8r6QcyXSfI+qYnhT?=
 =?us-ascii?Q?woL3aJN1/73khNx/TAHeX9EeVcVFB8VtZHadmOfXWM4bhrcfk6ecwiK2hR/s?=
 =?us-ascii?Q?KVXhoxT4ZYSggb2gixav6fyQdPpbIphngC9MlLNK3XC38y0+EqHRFDSnCwvD?=
 =?us-ascii?Q?IVnYH5+sztmw9+ko3mX8CG6axiLWj8fRKCfKsugC8EhCW6XTSd5Tq6D8UG70?=
 =?us-ascii?Q?8q9YyJ4uSNAWrv4WROh7VolE9l7CjJtUgi7RUcAjWZmDqKnu7YNx+3EPN0zs?=
 =?us-ascii?Q?xo+ZYgPHDfAI65g+51xWOYLlNjWYofk+9080clBGWD4h4qXlVofdk24se7jW?=
 =?us-ascii?Q?FxZL9Hbo5r1543OoI3Z8/1G0v/LyEEhapX0BxjQCoigdxvJ7+I/zFCA5kAxl?=
 =?us-ascii?Q?rbimuqoFL68tLDHgz54TIkyvfMRIN0q5+80E3/CW6o4FJvtgqoIH/9r+EPc/?=
 =?us-ascii?Q?rXnyhA9BN0NHq0Tp/z6cKWnb4617d5W852Yejx6lNBicBM2YDmaRgA6IARG8?=
 =?us-ascii?Q?BZwtRY4ZvBPhLGV4zhOD3j8515dwnznPcleHolREX/5YwNMi1LRdQpRnsqAO?=
 =?us-ascii?Q?zyV16M8GVhu6iEnWEp7oyFN3hkJNqeJ1fauhlSjSjaXn7Sg62u70TP66yeYc?=
 =?us-ascii?Q?lcWd3cdkEMUTiVSaOJRiSod37kk7IBGozbtMi0IfmNLn0rN4unijbmvr6VmM?=
 =?us-ascii?Q?yJevuw7LPyeucNVrahEU55r211yFdMKmY7hjzreCnLSniUlyyLqmuOT41mB6?=
 =?us-ascii?Q?rOxvNXke7rgoZ4hV4YQZVLpkvLsKK+ura1Ps4UibwHbk9WT2o+kbcUdK/vhD?=
 =?us-ascii?Q?ArXSY7c8H0Omoh/ydlNp8GN/qPt85z+cX4S7n9yLtK1E7U09MKWpZntIE3ZE?=
 =?us-ascii?Q?nR/D2FYAdVbpIVMkIdZwqc4JH0l6sccbKNz8J/eo/fLomirg587DCQ4C8buD?=
 =?us-ascii?Q?gT89aBgFADUMkePgOxKPShzDTDRHVswP20oSpO+C3XcF5hqa6CBzRwbs0qlj?=
 =?us-ascii?Q?OD417l9Kq5ja3q7/lDs04++xe8nrNRGJ1Hy9kkbhdy6TCJ1qQ4WcrbGptr+m?=
 =?us-ascii?Q?/UTlWfHGLyCVOHzoZXpZEcedAk94HIg64FpYPuj6+Z8Sv4mCnl6uSyvss9Jf?=
 =?us-ascii?Q?ahVowb/Dpgtn0DzdvAM7Ohvegm/5lmGvFrpl81Ny47dN3MphukrZ/CyhTjDi?=
 =?us-ascii?Q?Po+ihnEGYPyPY402yBZOvpF6zGSdkV//d+r71i1iCuzvkgV1u/W0rxJKqzMX?=
 =?us-ascii?Q?uSgveaV/8MSodwh+QSlddqWOb0JNjD74GMz6XHdWwkgr4s0ZB6MLt2wvk1Az?=
 =?us-ascii?Q?aoTrGW2KN2lvPW6E/KlIBZHOvQmmq3KQU8F8biZ5dfwaR01XgNE2lsZaVBh9?=
 =?us-ascii?Q?E/Hglt7TX1XEQeYIHRsz+N2o8z6d3xu+GVUSoULVciVWSTI5PhTGYxfMbrES?=
 =?us-ascii?Q?282h5pFMUFZxuWsScnltIEhp+xoHRg8bsb6Aj7BDRv4fzrzs/yVFWJNkw7Hn?=
 =?us-ascii?Q?7m382r5jpmXLse+CTAHhEMBocWN/mRNOeJZlC0FhuxzJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20400031-c1b0-4f34-a5da-08db13f192a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 09:54:07.0701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oGXZjvkoV8GRwXuOCIqyT7SA92IawzK93vpy/rdk0fqCRJM9P2E6GVFWrFKRzD76MKifiE04GF2fUI0frzys+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR18MB4262
X-Proofpoint-GUID: DAk_Ofjy4VVEHqylWtu4KC-0SJ2H6az0
X-Proofpoint-ORIG-GUID: IzbDEpeoi96owZA_o6ays1TL0Laa3D-3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_06,2023-02-20_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please ignore this patch.
I will re-send v2 with correction in cleanup path.

Thanks,
Nilesh

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Tuesday, February 21, 2023 2:49 PM
> To: linux-nvme@lists.infradead.org; martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; Bikash Hazarika
> <bhazarika@marvell.com>; Anil Gurumurthy <agurumurthy@marvell.com>;
> Shreyas Deodhar <sdeodhar@marvell.com>; Christoph Hellwig <hch@lst.de>
> Subject: [PATCH] nvme-fc: initialize nvme fc ctrl ops
>=20
> The system crashed while performing qla2xxx nvme discovery with
> below call trace,
>=20
> qla2xxx [0000:21:00.0]-2102:12: qla_nvme_register_remote: traddr=3Dnn-
> 0x245e00a098f4684a:pn-0x245f00a098f4684a PortID:5a247a
> qla2xxx [0000:21:00.0]-2102:12: qla_nvme_register_remote: traddr=3Dnn-
> 0x245e00a098f4684a:pn-0x246100a098f4684a PortID:5a2d6e
> BUG: kernel NULL pointer dereference, address: 0000000000000010
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 61 PID: 6064 Comm: nvme Kdump: loaded Not tainted 6.2.0-rc1 #3
> Hardware name: Dell Inc. PowerEdge R7525/0590KW, BIOS 2.5.6 10/06/2021
> RIP: 0010:nvme_alloc_admin_tag_set+0x51/0x120 [nvme_core]
> Code: 00 00 00 00 81 c1 b0 00 00 00 48 c7 86 a8 00 00 00 00 00 00 00
>       c1 e9 03 f3 48 ab 4c 89 46 38 c7 46 44 1e 00 00 00 48 8b 45 30
>       <f6> 40 10 01 74 07 c7 46 48 01 00 00 00 8b 45 5c c7 43 58 40 00 00
> RSP: 0018:ffffafe6cd7cbd10 EFLAGS: 00010212
> RAX: 0000000000000000 RBX: ffff898e0c39c050 RCX: 0000000000000000
> RDX: 00000000000001d8 RSI: ffff898e0c39c050 RDI: ffff898e0c39c100
> RBP: ffff898e0c39c398 R08: ffffffffc0afe1a0 R09: ffff896ed602a600
> R10: 0000000000000010 R11: f000000000000000 R12: ffff898e06ea2600
> R13: ffff898e070ffbc0 R14: ffff898e0c39c040 R15: ffff898e0c39c398
> FS:  00007f9368279780(0000) GS:ffff89ad7fb40000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 000000210c570000 CR4: 0000000000350ee0
> Call Trace:
> nvme_fc_init_ctrl+0x328/0x460 [nvme_fc]
> nvme_fc_create_ctrl+0x1b0/0x260 [nvme_fc]
> nvmf_create_ctrl+0x141/0x240 [nvme_fabrics]
> nvmf_dev_write+0x81/0xe0 [nvme_fabrics]
> vfs_write+0xc5/0x3b0
> ? syscall_exit_work+0x103/0x130
> ? syscall_exit_to_user_mode+0x12/0x30
> ksys_write+0x5f/0xe0
> do_syscall_64+0x5c/0x90
> ? exc_page_fault+0x62/0x150
> entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7f936813e967
> Code: 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f
>       1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05
>       <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
> SP: 002b:00007fff4197a468 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000560862447d40 RCX: 00007f936813e967
> RDX: 000000000000012b RSI: 0000560862447d40 RDI: 0000000000000003
> RBP: 0000000000000003 R08: 000000000000012b R09: 0000560862447d40
> R10: 0000000000000000 R11: 0000000000000246 R12: 00005608624473f0
> R13: 000000000000012b R14: 00007f93682e6100 R15: 00007f93682e613d
>=20
> Initialize the nvme_fc_ctrl_ops before allocating the nvme admin
> tag set.
>=20
> Fixes: 6dfba1c09c10 ("nvme-fc: use the tagset alloc/free helpers")
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/nvme/host/fc.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 4564f16a0b20..6c0125eb2a0f 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -3521,13 +3521,6 @@ nvme_fc_init_ctrl(struct device *dev, struct
> nvmf_ctrl_options *opts,
>=20
>  	nvme_fc_init_queue(ctrl, 0);
>=20
> -	ret =3D nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
> -			&nvme_fc_admin_mq_ops,
> -			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
> -				    ctrl->lport->ops->fcprqst_priv_sz));
> -	if (ret)
> -		goto out_free_queues;
> -
>  	/*
>  	 * Would have been nice to init io queues tag set as well.
>  	 * However, we require interaction from the controller
> @@ -3539,6 +3532,13 @@ nvme_fc_init_ctrl(struct device *dev, struct
> nvmf_ctrl_options *opts,
>  	if (ret)
>  		goto out_cleanup_tagset;
>=20
> +	ret =3D nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
> +			&nvme_fc_admin_mq_ops,
> +			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
> +				    ctrl->lport->ops->fcprqst_priv_sz));
> +	if (ret)
> +		goto out_free_queues;
> +
>  	/* at this point, teardown path changes to ref counting on nvme ctrl
> */
>=20
>  	spin_lock_irqsave(&rport->lock, flags);
> --
> 2.23.1

