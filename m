Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DF9C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 10:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC2420679
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 10:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="L93/Euke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbgFYK1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:27:03 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:6093
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403773AbgFYK0q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 06:26:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFMivYkG6xWRwD3+Fe5TYHqNYgnXVuVWrOwEXiksv+RWlj9MGuMpeWmg0S6cDVuxVP+Hd6mtT2Xy41cOtHCqQYiwrNEZvtSc+vznYrJCtMpCrp48miBLTVtn+hrDzXd5FNEomOJo15ZO512JjfWhE1yP3GYVhVPRaXxhg6mnpYzGKRammilCZ/MHxlRDi73JJhHyFK1nUPffkpHY9C8E+aBrLmePu+HcWF9rI6zIUVdw5mqeS8kNyHJJkxroea+lO9rXgUNi+P4Wpu0SSADrJLFDBkxtbz+qiu3YZzLcPsQOCOSrsW5tgUezrfRyD0jij0LMVRyxpMjbXVKT2FdSyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAxtKyg3NxuiRxT7de4qr06yLluAcmBjT7ukPQ1Wk6Y=;
 b=OuVGQaQJI4sSsgql96w4K/MTW160SlE7BTdJx+1Nxv1VXbwbONb8ZvqLwShcAwJ4iDNG4V0xY7Ko7VtBpLOTzvPqdf/wI0AxfV38Pfsy1CkuyVeydIbHc/KfLWAgiognqHgWm3rSPBr3RtzDdGw0cmLE+L3u+aOeRQh9X0m9SWFsZVnYziH2PE7xR0BngYYzhaUV/AH3fRIPq3rP5KMYk4bFkJKoYyOv0S65ecTR8kIPUPGxyj654rw4BvrUScFpfTYodgvO3ZPEw+vQ2taB23xxhFBIX1oNPVVUkHN1tPL7nHsKeWVO1M50TksCjUPUh8lhl65A9ErKrcNrpvGO0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAxtKyg3NxuiRxT7de4qr06yLluAcmBjT7ukPQ1Wk6Y=;
 b=L93/EukeiIaYc9Ti1mGojo2MYdXE1JjiJyZYAlYtl8w1xkIALEITJ5Tsc3ctbLfaGry0hOPOU+KEou90XW2kSaE5dEhBT/aHeISbqTw+SbmK6q4Ba8Wb9AeLwyRBRo/dG/iJFrLJKPfwVqC0MeJhijBC6UkokYxEE6klpRnpi7g=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4323.namprd08.prod.outlook.com (2603:10b6:406:f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 10:26:41 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5d19:e0b5:75e1:40b8]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5d19:e0b5:75e1:40b8%7]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 10:26:41 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [EXT] [PATCH v2] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
Thread-Topic: [EXT] [PATCH v2] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
Thread-Index: AQHWSp1b4+/jX4X5T0+517Im0/M4b6jpIHNA
Date:   Thu, 25 Jun 2020 10:26:41 +0000
Message-ID: <BN7PR08MB568428CA4AC7FA9E6BB854FADB920@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200625030430.25048-1-stanley.chu@mediatek.com>
In-Reply-To: <20200625030430.25048-1-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTU5NDA0MDlmLWI2Y2UtMTFlYS04Yjk3LWRjNzE5?=
 =?us-ascii?Q?NjFmOWRkM1xhbWUtdGVzdFw1OTQwNDBhMS1iNmNlLTExZWEtOGI5Ny1kYzcx?=
 =?us-ascii?Q?OTYxZjlkZDNib2R5LnR4dCIgc3o9IjM5OTMiIHQ9IjEzMjM3NTU0Mzk3NTQ3?=
 =?us-ascii?Q?MjcxMiIgaD0iazFreEdwelNnWUNKV3cxN09Yb2p6L29GOS9VPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBRkFLQUFC?=
 =?us-ascii?Q?SWJwc2IyMHJXQVluNzEzMm5Hd3BSaWZ2WGZhY2JDbEVRQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBRGdDUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVCQVFBQkFBQUFWUThDamdBQUFBQUFBQUFBQUFBQUFKNEFBQUJ0QUdrQVl3?=
 =?us-ascii?Q?QnlBRzhBYmdCZkFHNEFZUUJ1QUdRQVh3QndBSElBYVFCdEFHRUFjZ0I1QUY4?=
 =?us-ascii?Q?QWF3QmxBSGtBZHdCdkFISUFaQUJ6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFhUUJqQUhJQWJ3QnVBRjhBYmdC?=
 =?us-ascii?Q?aEFHNEFaQUJmQUhNQVpRQmpBRzhBYmdCa0FHRUFjZ0I1QUY4QWF3QmxBSGtB?=
 =?us-ascii?Q?ZHdCdkFISUFaQUJ6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBYmdCaEFHNEFaQUJmQUdjQWJBQnZBR0lBWVFCc0FBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnVBR0VB?=
 =?us-ascii?Q?YmdCa0FGOEFhQUJwQUdjQWFBQmZBR01BYndCdUFHWUFhUUJrQUdVQWJnQmpB?=
 =?us-ascii?Q?R1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUc0QVlRQnVBR1FBWHdCdEFHRUFj?=
 =?us-ascii?Q?d0JyQUdrQWJnQm5BRjhBYkFCaEFIa0FaUUJ5QUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNB?=
 =?us-ascii?Q?QUFBQUFDZUFBQUFiZ0JoQUc0QVpBQmZBRzBBWVFCMEFHVUFjZ0JwQUdFQWJB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdUFH?=
 =?us-ascii?Q?RUFiZ0JrQUY4QWJRQnZBR1FBZFFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzRBWVFCdUFHUUFYd0J3QUhJ?=
 =?us-ascii?Q?QWJ3QmpBR1VBY3dCekFGOEFaUUJ4QUhVQWFRQndBRzBBWlFCdUFIUUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQWJnQmhBRzRBWkFCZkFITUFNUUF6QURBQVh3QmtBR1VB?=
 =?us-ascii?Q?Y3dCcEFHY0FiZ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ1?=
 =?us-ascii?Q?QUdFQWJnQmtBRjhBY3dBeEFETUFNQUJmQUhBQVlRQnlBSFFBWXdCdkFHUUFa?=
 =?us-ascii?Q?UUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHNEFZUUJ1QUdRQVh3QnpB?=
 =?us-ascii?Q?REVBTkFBd0FGOEFaQUJsQUhNQWFRQm5BRzRBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFB?=
 =?us-ascii?Q?QUFDQUFBQUFBQ2VBQUFBYmdCaEFHNEFaQUJmQUhNQU1RQTBBREFBWHdCd0FH?=
 =?us-ascii?Q?RUFjZ0IwQUdNQWJ3QmtBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFB?=
 =?us-ascii?Q?QnVBR0VBYmdCa0FGOEFjd0F4QURVQU1BQmZBR1FBWlFCekFHa0Fad0J1QUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUc0QVlRQnVBR1FBWHdC?=
 =?us-ascii?Q?ekFERUFOUUF3QUY4QWNBQmhBSElBZEFCakFHOEFaQUJsQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFB?=
 =?us-ascii?Q?QUFBQUNBQUFBQUFDZUFBQUFiZ0JoQUc0QVpBQmZBSE1BTVFBMkFEQUFYd0Jr?=
 =?us-ascii?Q?QUdVQWN3QnBBR2NBYmdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRB?=
 =?us-ascii?Q?QUFCdUFHRUFiZ0JrQUY4QWN3QXhBRFlBTUFCZkFIQUFZUUJ5QUhRQVl3QnZB?=
 =?us-ascii?Q?R1FBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-dg-rorf: true
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.77.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b07a64e3-208d-464d-435a-08d818f24061
x-ms-traffictypediagnostic: BN7PR08MB4323:
x-microsoft-antispam-prvs: <BN7PR08MB432312212C0EC6D7E1706E81DB920@BN7PR08MB4323.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dWq1Pz5pNUfW0mse8JfTr5272nSZr61mqKKVq0sLPSUCbgD9QKUSHua06xotkvc78bXuVqPlOMmZTzg6T8k2XHYPv7R6L9hhZa1YpRSk3UUxMUXY7c/TlI7x4tFjkNez3ACdidUSedgcug59BTWlEf8QZmIxjUutr56wEEp/Q2S8tQWsj1G/mJVAXe8AOFgv5WmzA9gO98jgXk0OOL3/extK/8AtY5UHdjIC6+veDSxW+baDbOABAyzHyP0JbAX59SboJI+OTI1wsl8SAgWHt9sRmkcmpd0I0813R9jQq1tjY60hYOTJAzAtrQ37HRKFK+yJD1uOWbJfAOPPK230kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(26005)(71200400001)(110136005)(54906003)(316002)(478600001)(83380400001)(7696005)(186003)(4326008)(2906002)(55016002)(5660300002)(9686003)(86362001)(33656002)(52536014)(55236004)(6506007)(76116006)(66556008)(8936002)(64756008)(8676002)(7416002)(66446008)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: t8bMr3J8HY9TuUodUgcAy/XSWrrx8lCdEqNHmzE+qbOqplQh1XN/+QZ33l5VbrYE8PgBOX6X90uL4L5HS332rIrCjlpbEdtnwMllWvw1gQYT8QRrWDxaAYkibMtZ3CKtLlLCjwupdjasYXQs8tN2GulSHrfmnmN7xMRzxnujkUVKLnV/AbeLGaIdMHNVka7i7vdFTKAcTIfkGM7YnSehn0fDVa2te/1ChB8JjjGZGyQEW60YfABTaTh7eFjho84tpHSsS9OgmSmbtcFgkjnaHau1PxybWeXdPLCQdogUriiW2cDgPKjBOmi/5giyK1GaiVkLu7DRMT9NwB+LzPo4RB987xyd2aisdX1fL266ZGWTv74b5iO7rX9jLTxtoPbiFWTEtk1iRecZXnEhLsvWB9VOiXNd55w0KfOleo3v99Yt9ab0ICMGUlkKxNOi0zOk8JSaSjdiE2A44spA0UA9VHbeupy93wtQb7XYu0PkpwY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR08MB5684.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b07a64e3-208d-464d-435a-08d818f24061
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 10:26:41.2154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rNDrY/pM/YYh96ZkJWbMOA6PHLV79H4X4xOQl3Sj4dG9d8teQiMzXiN7ggFFVrqK3J+x0gMWnvHwwRRWBzgv5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4323
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> If UFS device is not qualified to enter the detection of WriteBooster pro=
bing by
> disallowed UFS version or device quirks, then WriteBooster capability in =
host
> shall be disabled to prevent any WriteBooster operations in the future.
>=20
> Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Tested-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>

Thanks fix this.

Reviewed-by: Bean Huo <beanhuo@micron.com>

Bean

> ---
>  drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> f173ad1bd79f..c62bd47beeaa 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6847,21 +6847,31 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba
> *hba)
>=20
>  static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)  {
> +	struct ufs_dev_info *dev_info =3D &hba->dev_info;
>  	u8 lun;
>  	u32 d_lu_wb_buf_alloc;
>=20
>  	if (!ufshcd_is_wb_allowed(hba))
>  		return;
> +	/*
> +	 * Probe WB only for UFS-2.2 and UFS-3.1 (and later) devices or
> +	 * UFS devices with quirk
> UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES
> +	 * enabled
> +	 */
> +	if (!(dev_info->wspecversion >=3D 0x310 ||
> +	      dev_info->wspecversion =3D=3D 0x220 ||
> +	     (hba->dev_quirks &
> UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES)))
> +		goto wb_disabled;
>=20
>  	if (hba->desc_size[QUERY_DESC_IDN_DEVICE] <
>  	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
>  		goto wb_disabled;
>=20
> -	hba->dev_info.d_ext_ufs_feature_sup =3D
> +	dev_info->d_ext_ufs_feature_sup =3D
>  		get_unaligned_be32(desc_buf +
>=20
> DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
>=20
> -	if (!(hba->dev_info.d_ext_ufs_feature_sup &
> UFS_DEV_WRITE_BOOSTER_SUP))
> +	if (!(dev_info->d_ext_ufs_feature_sup &
> UFS_DEV_WRITE_BOOSTER_SUP))
>  		goto wb_disabled;
>=20
>  	/*
> @@ -6870,17 +6880,17 @@ static void ufshcd_wb_probe(struct ufs_hba *hba,
> u8 *desc_buf)
>  	 * a max of 1 lun would have wb buffer configured.
>  	 * Now only shared buffer mode is supported.
>  	 */
> -	hba->dev_info.b_wb_buffer_type =3D
> +	dev_info->b_wb_buffer_type =3D
>  		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
>=20
> -	hba->dev_info.b_presrv_uspc_en =3D
> +	dev_info->b_presrv_uspc_en =3D
>  		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
>=20
> -	if (hba->dev_info.b_wb_buffer_type =3D=3D WB_BUF_MODE_SHARED) {
> -		hba->dev_info.d_wb_alloc_units =3D
> +	if (dev_info->b_wb_buffer_type =3D=3D WB_BUF_MODE_SHARED) {
> +		dev_info->d_wb_alloc_units =3D
>  		get_unaligned_be32(desc_buf +
>=20
> DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS);
> -		if (!hba->dev_info.d_wb_alloc_units)
> +		if (!dev_info->d_wb_alloc_units)
>  			goto wb_disabled;
>  	} else {
>  		for (lun =3D 0; lun < UFS_UPIU_MAX_WB_LUN_ID; lun++) { @@ -
> 6891,7 +6901,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8
> *desc_buf)
>  					(u8 *)&d_lu_wb_buf_alloc,
>  					sizeof(d_lu_wb_buf_alloc));
>  			if (d_lu_wb_buf_alloc) {
> -				hba->dev_info.wb_dedicated_lu =3D lun;
> +				dev_info->wb_dedicated_lu =3D lun;
>  				break;
>  			}
>  		}
> @@ -6977,14 +6987,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba=
)
>=20
>  	ufs_fixup_device_setup(hba);
>=20
> -	/*
> -	 * Probe WB only for UFS-3.1 devices or UFS devices with quirk
> -	 * UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES enabled
> -	 */
> -	if (dev_info->wspecversion >=3D 0x310 ||
> -	    dev_info->wspecversion =3D=3D 0x220 ||
> -	    (hba->dev_quirks &
> UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES))
> -		ufshcd_wb_probe(hba, desc_buf);
> +	ufshcd_wb_probe(hba, desc_buf);
>=20
>  	/*
>  	 * ufshcd_read_string_desc returns size of the string
> --
> 2.18.0
