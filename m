Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD967C5479D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 16:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjAKQyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 11:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjAKQxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 11:53:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2378140FA
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 08:53:45 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B9aFHf016230
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 08:53:45 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k56u3pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 08:53:44 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30BGZAVE022448
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 08:53:44 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k56u3pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 08:53:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXmPMNK4NophKvLf4/+s8joRZbCK4WIpN79gtyy9wJCp7ggL2j+PicqBfVHnbm+WFli2z1R0i4XO9n9Q/zhtlP7aZB1BhyAKTpSn5y4R+l7nfx1+BdhqNJRSN+2QmYQdUL7VddbeQcv38E85Y5C4lpNC209cLTFFHUbvT1rXVS6rfehZN3e++8590L1o3taAiqzUhXt9xh4Ky0WLgswb4g+WTtorvO0DuHiWJ2CElCkbGIN08jcXWDxK0Qn92OiqL8aToug0DYEjudnjO09SfD3ouridDPSUkrANjKe+/bxMDHE2+YWmwFineHVCq4nGekWD07Ez4NGVK2zrXb7/uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3FnzBaESNdxQbxeJKQInFslUCHVGQxVI42R9OlPooo=;
 b=L+MOVCpae8/2BSFtvBTdp80NSQOA6htDxhznWNHl93FeSG0B1cUrSq4W1F6yq4HQ6LHZLv9nBV7E5gqTZtQdF3LPOd5Ak3eBI72lmjHgZyLYnXkFHIAPOF5fzUDRQk06TOJlUEYiVwBf1BEr3BkzRUMCnHbXnUwnMsyHpQIoNkuzJVkvBPOuToitx7i+Bu3K0zP6/hCOq3Qd4YkIUsiA+xMOfyRupjjDKMxPYyeQuGCcYocn2aN3PIDfiZzGj9hk1ZQLShAB7ecqttmmUZoLQXMe5XWLvi8M69tDzZ1fvGojMeFP3ciHr9264qyNeWPUfzGdumg69hUsrssfbDeKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3FnzBaESNdxQbxeJKQInFslUCHVGQxVI42R9OlPooo=;
 b=U1VPZMJ4wWZHcdjNnvVj+2xjvCyAVSSCj+4gicMGsvHMJDhynKj0XgPEHblrbstobkUasE3JzJUW8LvhqgZv1Fu2AowgRQn4heBn4Yym2bueoeI6P04G+5YfK5UGipJ2JJPhH0JWp7DZeW1BOSnhHZA+iMq4m9+TwVs08vwrugQ=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by MN6PR18MB5442.namprd18.prod.outlook.com (2603:10b6:208:477::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.13; Wed, 11 Jan
 2023 16:53:41 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::9c5d:2574:11ec:b34b]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::9c5d:2574:11ec:b34b%7]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 16:53:41 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        ": Martin Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Subject: RE: [PATCH 07/10] qla2xxx: edif - Reduce memory usage during low IO
Thread-Topic: [PATCH 07/10] qla2xxx: edif - Reduce memory usage during low IO
Thread-Index: AQHZFb9yOHinU9MJvkKgYMo1c8E6za6WupmAgAH51aCAAM15wA==
Date:   Wed, 11 Jan 2023 16:53:41 +0000
Message-ID: <BY5PR18MB3345E0DB6B84EFA5AD669857D5FC9@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-8-njavali@marvell.com>
 <698E44FC-670D-4B12-AE8B-9A9B789B546B@oracle.com>
 <CO6PR18MB45000483BCBD811F77B98D72AFFC9@CO6PR18MB4500.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB45000483BCBD811F77B98D72AFFC9@CO6PR18MB4500.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?iso-8859-1?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccXV0cmFuXG?=
 =?iso-8859-1?Q?FwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0?=
 =?iso-8859-1?Q?YmEyOWUzNWJcbXNnc1xtc2ctN2U0ZWQ5MWItOTFkMC0xMWVkLWFlNTAtZG?=
 =?iso-8859-1?Q?M3MTk2OTdmMzQxXGFtZS10ZXN0XDdlNGVkOTFjLTkxZDAtMTFlZC1hZTUw?=
 =?iso-8859-1?Q?LWRjNzE5Njk3ZjM0MWJvZHkudHh0IiBzej0iODExIiB0PSIxMzMxNzkyOT?=
 =?iso-8859-1?Q?YxODg0NzU4NjMiIGg9IlR3WDdNa2pJcDVUaWU0bS82RWZGVWZMeGxkVT0i?=
 =?iso-8859-1?Q?IGlkPSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1?=
 =?iso-8859-1?Q?VBQU5nSEFBRFhLY0JBM1NYWkFiQXNUZVpERjdyUXNDeE41a01YdXRBTUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFIQUFBQUJvQndBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFFQUFRQUJBQUFBM1R6RkFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?SjRBQUFCaEFHUUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR0?=
 =?iso-8859-1?Q?1BZFFCekFIUUFid0J0QUY4QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1B?=
 =?iso-8859-1?Q?ZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdCMUFHMEFZZ0JsQUhJQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYl?=
 =?iso-8859-1?Q?FCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5QUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQU?=
 =?iso-8859-1?Q?FHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?iso-8859-1?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFI?=
 =?iso-8859-1?Q?TUFkQUJ2QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYV?=
 =?iso-8859-1?Q?FCMEFHVUFjZ0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOE?=
 =?iso-8859-1?Q?FiUUJmQUhNQWN3QnVBRjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdRQWJBQndBRjhBY3dCckFIa0Fj?=
 =?iso-8859-1?Q?QUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFaUUJ6QUhNQVlRQm5BR1VBWHdCMk?=
 =?iso-8859-1?Q?FEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpBR3dBWVFCakFHc0FYd0?=
 =?iso-8859-1?Q?JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpRQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhRQVpRQnlBRzBBYVFCdUFIVUFjd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR18MB3345:EE_|MN6PR18MB5442:EE_
x-ms-office365-filtering-correlation-id: 13c5df81-bfe7-4c1a-8fb6-08daf3f464aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qAcf63Y5jQ4mrH6pKyE8X+VmOvt9p0nwd/l8YbX9lgfdetQ3rO7CloP34uEKH6qIKzJVtKCG+Y8r2hf4h1Wh+P95/V0MzcFySkWQAS7IA7Ptrcb97l0Q03Be/OevE0Fhn5macVT+damBhgZPm60J6BArDXOC/SVhwky+XROaucDn3eAVsKC1upPXubQ9YiUmEAHX1C6qZTzkRIYpCeUYRykrSQ7g+QdXyuBSfoVvqAM4BkfPY9yjMDm7cA0ozWd7iRlCykUIEoku72Xd5vmfJByKIo6/4rJiDQx101lElDzT5Akoal6wVgMgHX0KHFva4j6yfOWKvCf3wR3A8z7w5Syuf8EIRMbkMReowBgFPgO6bNmQMuaJSRFd3KmXqAFV6zYknrFOctoeUdxHMwRum+gsBpvZffMZwk8gPN7n/bnWqvq7jMDl0GLkfyn5Wl8aU5jAAVpQOHZIHLw+eMxf3ltW4iqJ0nd1vVbHPwNaAhfWQhLLLuJG/VYUG0KoIvNmNmqcH3bvFddoOdcFnAnwfTpZ98LMr0bjbJqR2gleP4OitCfo6E8/zq9v7sYtJG7Z2CeiI5tTemKmTjsOrs+XKmTU+w0QCL4ZoqZT1EgfMZYiuda0HP9WVio2er7QdixtCbioawheL+C6Ru5VtNuORrkzH48XqsYQ0sWmIRI8IGA1ucRQC/jKi4S0MZQLBoAobrwJ8Y54Vyur473QgCwkhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(2906002)(33656002)(6506007)(122000001)(6916009)(38100700002)(4744005)(5660300002)(86362001)(26005)(52536014)(83380400001)(41300700001)(8936002)(76116006)(71200400001)(66556008)(66946007)(54906003)(38070700005)(4326008)(66476007)(66446008)(107886003)(64756008)(55016003)(7696005)(186003)(478600001)(316002)(9686003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?AkoVfRMoiiHhHZz31jnGxrgFPQ5h1OTh5XeoIkWb0xtjbNcmKtCtdcVHNR?=
 =?iso-8859-1?Q?tmhyvpRlq+avp8eWiWXUy6MaY35TVYwXMUn2HHwM0cqHF2bJGbHY7nzWeV?=
 =?iso-8859-1?Q?nH6vSFgvkVpBmZlOMbEsmlKeDhuS7dFRRneUso2KqJgnlyKmrtFwhmY5lr?=
 =?iso-8859-1?Q?9PeqXVgdOumWCFS5QFKKlszKhkOoewUB196KhY3XVdEa5wRx26J33aKDxO?=
 =?iso-8859-1?Q?HJFT8Q1wVASWy9Rf8PfrGDz3RONBTC15sy95rah04o68i68i8dbilF+q7X?=
 =?iso-8859-1?Q?CnzYwhnAvTzMd8suwpWWmvp4eeAvgC3399AmEO2j28JrMrtn6APZYmtkM+?=
 =?iso-8859-1?Q?UrUyZ0Pc2h8rrtacW6w42xLybe5iS+JSbFPwzMtx8kifwpib5ZrzHS/Qwi?=
 =?iso-8859-1?Q?SaXGEYBh7oHGuKAshIjPen2n+Lkn2Ag29isyURUguYaxzYB6WGsYi54Pgc?=
 =?iso-8859-1?Q?J2TUxPJsi2Ox2dy4G1PpQH6tfVho4RLeht/N8STQxREa4k24PpFcEfmVHu?=
 =?iso-8859-1?Q?PHLEcTnYmpbmAcwLtzg8/5gyov/ehGRkAAPIy9iEwTq/PIuwoPWXZSGihb?=
 =?iso-8859-1?Q?lk3PSRJCH8N4LTKxKOzEsIaJMLJsdck4TOuCYUPG1F3oifB/ut7lrhjmIm?=
 =?iso-8859-1?Q?ZNXnyi5WEerADN+tQeDWP0eokKK1Q7S8pcqY8PWTGV3zVat+iaj5tpXTY5?=
 =?iso-8859-1?Q?4XOZ69ueyH5pyQZwECAh+MX/120DAouxrkPDHwkFhuA2hboXxxEdVQseka?=
 =?iso-8859-1?Q?GW60/j7f9Gs8WzI5VaKckPH9fBMMRjrX4oZspDglW7BbkB+Upz5/Fw9Gh5?=
 =?iso-8859-1?Q?T3vzUKcR7wZGL1PHnKQpxJ+R0u6G7fVQYrnS4LuUWHU1z7jFeJbSGV3Q6J?=
 =?iso-8859-1?Q?HM2uM5BMXtrcetbJlxAOeaTmw71xZ0FwyeBi0W/VFl9PGpPp4vyd15Egic?=
 =?iso-8859-1?Q?zY1T3iY96LSj4SjAeLjFeF+iMon1ZBMwOHOoMhHrX2dz+AIp3ID8c1fZod?=
 =?iso-8859-1?Q?7OjAVUMNofLoZF4VzSlPspQFjVSHXgBMvYD/xr6eifRlWPgbt/O5oWK5fy?=
 =?iso-8859-1?Q?ioB1o93Svs6gHPEwfA6L+an/XLX6JbtaiKzjXWfeEpgDKKHPGmKI0ajA1D?=
 =?iso-8859-1?Q?T5iN6BCTsqqp8V7VeXzooushGqJtYOqeSiRICK4TWm0iXxSY6Lga3ch7U5?=
 =?iso-8859-1?Q?wMcuT/XaFmxBSPMaWtY5rsOndMI9lQUCZwZe6MBRDp7O7MQLJKPbI3FdBe?=
 =?iso-8859-1?Q?xIkPTf6mm847WPCkscZ8Q4PSXhtRSoMVaEqHJYsJEDxyn4asRZkJFGnxfR?=
 =?iso-8859-1?Q?+spVrt2hfVEWPkMgXnWeGmNwN8c5Y+80PZUSeaM85uzuH13ipS/Lkwz6lB?=
 =?iso-8859-1?Q?eV3iu4wghgTmGamtz3ho0QNsCt1nNFpq27dVykdUywJCjSRSSFslixTMLn?=
 =?iso-8859-1?Q?ED5KTDD1dE0zz9/tpKNRe/T9brbD/EkOswjt997vHrGTS3rx/BhiJZh7f0?=
 =?iso-8859-1?Q?FW45Icn38Rg+6el5cWn1/W7Na2vbzekaWg/IipdcKaoFnHCBBR85m9lBjl?=
 =?iso-8859-1?Q?gACZ5puvlbcQ0OwVXVzAhtQgAnHTLbSTgZvMdGuOEDNAZicZ5Sw01HuF9D?=
 =?iso-8859-1?Q?3CDOF95OyvAzk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c5df81-bfe7-4c1a-8fb6-08daf3f464aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 16:53:41.2190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xtfxHwU3GxCgKDLwML/tqaXtq12cSqxCcsbBRaZagILDfgu8N6BSfndY+9Cto1GibfR8I8AsbncLWi29QkDR7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR18MB5442
X-Proofpoint-ORIG-GUID: 0CIZ-a6m-RwBKxHILxbWiG0nbmori-ka
X-Proofpoint-GUID: 62LPvdA127OrtzZ1rpxFboD7Bx41sHeL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_07,2023-01-11_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+void __qla_adjust_buf(struct qla_qpair *qp)
+{
+ u32 trim;
+
+ qp->buf_pool.take_snapshot =3D 0;
+ qp->buf_pool.prev_max =3D qp->buf_pool.max_used;
+ qp->buf_pool.max_used =3D qp->buf_pool.num_active;
+
+ if (qp->buf_pool.prev_max > qp->buf_pool.max_used &&

You are assigning qp->buf_pool.prev_max with the value from qp->buf_pool.ma=
x_used a couple of lines above to max_used ... . This check looks incorrect=
 because now the value for buf_pool.prev_max will be the same as buf_pool.m=
ax_used.=A0

Am I missing something?

QT:  Thanks for the review.    The 'qp->buf_pool.max_used =3D qp->buf_pool.=
num_active;'  line seems to be overlooked.  It changes max_used, where prev=
_max is not the same as max_used.

