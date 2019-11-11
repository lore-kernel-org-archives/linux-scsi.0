Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF691C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 15:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88324214E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 15:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="IUPJMwWl";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.onmicrosoft.com header.i=@synopsys.onmicrosoft.com header.b="U0+lvWyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKKP1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 10:27:49 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:46078 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726845AbfKKP1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 10:27:49 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EDE2DC0E01;
        Mon, 11 Nov 2019 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573486068; bh=81cMCScTrJweMXO3tQrpAzQ7GadVxb09zwg3mRWELf4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=IUPJMwWltE93vYYQdcNqx62lw7uUhUkjjqpYIGnipka2q9L4f8guSc5ZAZz6keHhK
         oNT9TPNbBwAI1Iryf5O8sI2tgqLa3+VqywXSG6FOA8E+UubWrZkLLV+ZnLs1SMFjZ1
         SkuHnq/cXj+s8ro5r9kZc2Im/ECT0y8WzTpDmts54ua175pH1vsvaFoAerqCWdzknH
         2gPC+rpBuyANOQPSyMbhwgHVP2Kv9Lo49kxQrshYFLIETIFa4uwv06HqOr7JEd+wyr
         6PU4wxku2HFmSsPp43Rc6cWVf9vWKKX2xuV+QMdezra+VrdRIChdfLeIhZBvif1IxK
         YAYBcIfiUnemw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 755E7A0066;
        Mon, 11 Nov 2019 15:27:44 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 11 Nov 2019 07:27:44 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 11 Nov 2019 07:27:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvGR507NR9hdpi4pLDM9M0jySq3X5IYMENgKUWQavlzop8rvYD/6rQ8MELIWhsGK+fihKRTGYhb2y0vFd9XwCoYTWRAOSNPcwMJ4R9B8xK/VhhtpTYWV14+t7r6ZNAma/XbFaEyDauKWKz7Di5ZAc6VNYlTrDG+r3aNyqXt5BeG33HBqnZwnhg2+pja19dgAT7TpnantuIafcLCU0LA//ork1UZwYAlZHnKBuLY6QFCipfADHigsF87wmJPwnX+K/VZDrljAq66kefBC4qN6R0TZIpEv3ap7OhJN1euss1fygkaaj2Q1g+782rHRZFMToK2zEKeWfwBlI2K7H0kMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4hYj/D2IhV826POaSI0GU2TB8ZS3jDIi6+sHGuDowA=;
 b=gxEct0dz7ns5Qx47hB9CUOHkkH+T79ozY4Gyhtv6KkxBqQf4Tso63JEXdNaxs5kzYOfc7ExP2DXlcjyNyYWnm7KGKyjISSTGiHAbxFBto3MiSkVierpdNNmhSjXnc6b7JUoJEONmhtUZyvEv1Bo5A5mH6uonnIVQTeV0O9TVuf4tw9QIV+eX/CVB5B9EdYgp23LsVQUl6HjnZsAuJu+v+Vv075/9O9F3WO7qrobwsPnY+pCr+pIvGPUlSqvA7CedW6DucAtcrrvfNlqMvXPOcTGbWmTI1nHfnjurY5q30TFRb61yARMnH+TDYRSXOkLkXVl1gqM5+h8RZC2F2/Qufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4hYj/D2IhV826POaSI0GU2TB8ZS3jDIi6+sHGuDowA=;
 b=U0+lvWyodlvL64GavDjvX9Pz1i701nC4wdXQuCgctG0m2PuJGmHXHvjDMxPAmB44dQ+/ySHJJhZhhnlrOJSMKwkz/qJN8PQGZSVNF3i6GCeoMi//Z3lz8s6SaAdN/GixrdQajFuHP4INSVN1QRdyAeOkEm6xDbsh4BDJSkIa2cY=
Received: from MN2PR12MB3167.namprd12.prod.outlook.com (20.179.80.95) by
 MN2PR12MB4032.namprd12.prod.outlook.com (10.255.239.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Mon, 11 Nov 2019 15:27:41 +0000
Received: from MN2PR12MB3167.namprd12.prod.outlook.com
 ([fe80::2974:feba:8a00:35ef]) by MN2PR12MB3167.namprd12.prod.outlook.com
 ([fe80::2974:feba:8a00:35ef%6]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 15:27:41 +0000
From:   Pedro Sousa <PedroM.Sousa@synopsys.com>
To:     Asutosh Das <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "vinholikatti@gmail.com" <vinholikatti@gmail.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] scsi: ufs: export hibern8 entry and exit
Thread-Topic: [PATCH v3 1/2] scsi: ufs: export hibern8 entry and exit
Thread-Index: AQHVicHiQdVJ7uEJjken9mNQwozXTaeGLVRw
Date:   Mon, 11 Nov 2019 15:27:41 +0000
Message-ID: <MN2PR12MB3167500F195C920A90840315CC740@MN2PR12MB3167.namprd12.prod.outlook.com>
References: <1571849351-819-1-git-send-email-asutoshd@codeaurora.org>
In-Reply-To: <1571849351-819-1-git-send-email-asutoshd@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc291c2FcYXBw?=
 =?us-ascii?Q?ZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5?=
 =?us-ascii?Q?ZTM1Ylxtc2dzXG1zZy1jYjI3MjE0Mi0wNDk3LTExZWEtOWEwYS1iODA4Y2Yz?=
 =?us-ascii?Q?YjJlNWVcYW1lLXRlc3RcY2IyNzIxNDMtMDQ5Ny0xMWVhLTlhMGEtYjgwOGNm?=
 =?us-ascii?Q?M2IyZTVlYm9keS50eHQiIHN6PSIzNDk1IiB0PSIxMzIxNzk1OTY1OTY5MzMw?=
 =?us-ascii?Q?ODAiIGg9IjJRQWdBKzY2YnFXRFJCdFJQcUpNVEpTQ1V2ST0iIGlkPSIiIGJs?=
 =?us-ascii?Q?PSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUJRSkFBRFk4?=
 =?us-ascii?Q?YmFOcEpqVkFWai81cXBrYnhHbldQL21xbVJ2RWFjT0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFIQUFBQUNrQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFRQUJBQUFBbEF3ZnN3QUFBQUFBQUFBQUFBQUFBSjRBQUFCbUFHa0FiZ0Jo?=
 =?us-ascii?Q?QUc0QVl3QmxBRjhBY0FCc0FHRUFiZ0J1QUdrQWJnQm5BRjhBZHdCaEFIUUFa?=
 =?us-ascii?Q?UUJ5QUcwQVlRQnlBR3NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhrQVh3QndB?=
 =?us-ascii?Q?R0VBY2dCMEFHNEFaUUJ5QUhNQVh3Qm5BR1lBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQVpnQnZBSFVBYmdCa0FISUFlUUJmQUhBQVlRQnlBSFFBYmdCbEFI?=
 =?us-ascii?Q?SUFjd0JmQUhNQVlRQnRBSE1BZFFCdUFHY0FYd0JqQUc4QWJnQm1BQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJtQUc4QWRR?=
 =?us-ascii?Q?QnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRBQnVBR1VBY2dCekFGOEFjd0JoQUcw?=
 =?us-ascii?Q?QWN3QjFBRzRBWndCZkFISUFaUUJ6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtBWHdC?=
 =?us-ascii?Q?d0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCekFHMEFhUUJqQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWmdCdkFIVUFiZ0JrQUhJQWVRQmZBSEFBWVFCeUFIUUFiZ0Js?=
 =?us-ascii?Q?QUhJQWN3QmZBSE1BZEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQm1BRzhB?=
 =?us-ascii?Q?ZFFCdUFHUUFjZ0I1QUY4QWNBQmhBSElBZEFCdUFHVUFjZ0J6QUY4QWRBQnpB?=
 =?us-ascii?Q?RzBBWXdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFIa0FY?=
 =?us-ascii?Q?d0J3QUdFQWNnQjBBRzRBWlFCeUFITUFYd0IxQUcwQVl3QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNB?=
 =?us-ascii?Q?QUFBQUFDZUFBQUFad0IwQUhNQVh3QndBSElBYndCa0FIVUFZd0IwQUY4QWRB?=
 =?us-ascii?Q?QnlBR0VBYVFCdUFHa0FiZ0JuQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCekFH?=
 =?us-ascii?Q?RUFiQUJsQUhNQVh3QmhBR01BWXdCdkFIVUFiZ0IwQUY4QWNBQnNBR0VBYmdB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBSE1BWVFCc0FHVUFjd0JmQUhF?=
 =?us-ascii?Q?QWRRQnZBSFFBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQWN3QnVBSEFBY3dCZkFHd0FhUUJqQUdVQWJnQnpBR1VB?=
 =?us-ascii?Q?WHdCMEFHVUFjZ0J0QUY4QU1RQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ6?=
 =?us-ascii?Q?QUc0QWNBQnpBRjhBYkFCcEFHTUFaUUJ1QUhNQVpRQmZBSFFBWlFCeUFHMEFY?=
 =?us-ascii?Q?d0J6QUhRQWRRQmtBR1VBYmdCMEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFIWUFad0JmQUdzQVpRQjVB?=
 =?us-ascii?Q?SGNBYndCeUFHUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFB?=
 =?us-ascii?Q?QUFDQUFBQUFBQT0iLz48L21ldGE+?=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sousa@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e3fdc4c-c33b-4212-702f-08d766bbb16b
x-ms-traffictypediagnostic: MN2PR12MB4032:
x-microsoft-antispam-prvs: <MN2PR12MB403273A39CD1755856997979CC740@MN2PR12MB4032.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(346002)(366004)(376002)(189003)(199004)(13464003)(7416002)(25786009)(476003)(11346002)(81156014)(81166006)(66476007)(66446008)(446003)(66946007)(76116006)(64756008)(2906002)(66556008)(8676002)(2501003)(33656002)(53546011)(6506007)(478600001)(7696005)(14444005)(52536014)(14454004)(8936002)(76176011)(486006)(102836004)(5660300002)(256004)(55016002)(186003)(99286004)(7736002)(74316002)(316002)(9686003)(110136005)(54906003)(6436002)(305945005)(26005)(229853002)(71200400001)(71190400001)(4326008)(6246003)(2201001)(66066001)(3846002)(86362001)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR12MB4032;H:MN2PR12MB3167.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5m71ETKLoIehZl4tlhWzNcqh1w8J0O9WfQCgWkfHPe9n4z+mFEjs3AKhzTtcSeAZIWHD64/gjED8NOfSVbjmV3AA8PQizb7tTsOzwFStRJX5bpxIeFiN703+Fg91fQDyBc/tqQ5k1NnhoU2s8Ngt65DzxSMsoGGjiOMQTMSpMCubzAV+TY2liVdXVGkTPjTtghWT5Tzq7NmSBzipRtWiP1kGZiLots8K8dmd7+FALGkOnWJd5U9JthnCvc0E5rwQy+txsaqb2pDxJPgdc1JVYCPlplP46OxVo/kxynx38hQA6Ypw/dz+vfPDtdNee2DdgdwMVJuktce8IF679hUn64/HdxOrVQi7STf/HQx/qvh5kThUgsg3E1HbZFclVzuofLzwA6csIsis+7DrOeVkgEftK5/uOO1Tkd1VydY5jIJryS1CXUpZsdBZk/+HkmV8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3fdc4c-c33b-4212-702f-08d766bbb16b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 15:27:41.6091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: flnlqBE7B5xJMbsfXixwgflOhk29QsSTzkJLB12tK4TxNx7SvMB3a2siZ7hEOONPTdG/ORmJIhLDGcJgk0o2yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4032
X-OriginatorOrg: synopsys.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Asutosh,

Reviewed-by: Pedro Sousa <pedrom.sousa@synopsys.com>

Thanks!
Pedro Sousa

-----Original Message-----
From: Asutosh Das <asutoshd@codeaurora.org>=20
Sent: Wednesday, October 23, 2019 5:49 PM
To: cang@codeaurora.org; rnayak@codeaurora.org; vinholikatti@gmail.com; jej=
b@linux.vnet.ibm.com; martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org; kernel-team@android.com; saravanak@google.c=
om; salyzyn@google.com; Asutosh Das <asutoshd@codeaurora.org>; Alim Akhtar =
<alim.akhtar@samsung.com>; Avri Altman <avri.altman@wdc.com>; Pedro Sousa <=
pedrom.sousa@synopsys.com>; James E.J. Bottomley <jejb@linux.ibm.com>; Stan=
ley Chu <stanley.chu@mediatek.com>; Bean Huo <beanhuo@micron.com>; Tomas Wi=
nkler <tomas.winkler@intel.com>; Subhash Jadavani <subhashj@codeaurora.org>=
; Bjorn Andersson <bjorn.andersson@linaro.org>; Arnd Bergmann <arnd@arndb.d=
e>; open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/2] scsi: ufs: export hibern8 entry and exit

Qualcomm controllers need to be in hibern8 before scaling up
or down the clocks. Hence, export the hibern8 entry and exit
functions.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 drivers/scsi/ufs/ufshcd.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..57d9315 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -250,8 +250,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
@@ -3904,7 +3902,7 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba =
*hba)
 	return ret;
 }
=20
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	int ret =3D 0, retries;
=20
@@ -3916,8 +3914,9 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *h=
ba)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_enter);
=20
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
+int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd =3D {0};
 	int ret;
@@ -3943,6 +3942,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hb=
a)
=20
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
=20
 static void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..1e3daf5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1107,5 +1107,6 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int=
 scsi_lun)
=20
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
-
+int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
+int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 #endif /* End of Header */
--=20
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux =
Foundation Collaborative Project.

