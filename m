Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C919C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 09:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119596126A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 09:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhJDJq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 05:46:58 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:42798 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232161AbhJDJq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 05:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633340707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=30bfmAp7SzI1LgEw5qrAlAPJuyIm5i6lYZfMhUXfSJo=;
        b=WI1v6XNthj53c9e4SyXqPP1KO+7mF5CfjzMPD45fTcqoxTWssMy6QzReU+TT/a1Mx7k9Bu
        T9ljAvp7OSbpbB206A7gFcYiY9CY6x+YQEMMrDwFL44QU0O7aLJUUrOfq72hsAj/OO8qXn
        zFqX4KX2QUOlbTtC57enNqgHsHlXIw4=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-MURGkQXVMUipi_UwF9qw7A-2; Mon, 04 Oct 2021 11:45:06 +0200
X-MC-Unique: MURGkQXVMUipi_UwF9qw7A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhfrJZ3rY9UobOLT+UH+GD2n4t6eJE//6S+yu1lTk6VaM9uYeRH2cAkBR9tUZBgswRZ6UuwyhE28JyDgvQAeu3VyHORpe9mIBk3owIGd1UN1n3wsA1hN0gz3NDQgvSiPpQlCR/BU6BuoeR8Rj0d8uSB20u0vA2qKoJXGTIfZoDB/mPMvupQOlroIPfydE2qDFwOL8BdPfpCtjpDGr6NMbHt+wV6BA7BnqNulp+yilnsXGJndeFJvkoMetuLHhTQq5blDeYIBC4fbJe9+xwh8Fhz4Syj4Aty7LYedoh4nnIhHRNMY8tMKKCpZsJFij9BWMsWfae5WndR5G4XQiP8AYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6K26Uvrjh6Tthi1kL6/ZDXdBU76QC/S7oq5cizIawI=;
 b=Gs/zzFGEacjUBes+T1I1DGjN+u2ptV5+Hs6W3uO6+BpjShhlEelAY7ZJhF88PK+bH/3Qq60XIiZRy4QqRwmpYzIY3rqPUdfDlAVW/ciHurQgg9pK0q/k+3WXsCw+op1o5VfqdfJW6heuTcNGNQ/sbwdfJrHTlq4yEV5KIfEZ/XzPcH0l9YdI2XetBj7oa0aX0U8podksfotGHFkdnoNMR1bGKHTm1/pqT43iUT9WtQzx8w36ANIBMX55/Coffe4uRQNAWMDnovQD7U06qchg64wei00043s9vp3FC2JFvtRrRNR8eHsRo0qQEWZalrHwNi1TDKYzpy62HWZUPr2Brw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0401MB2647.eurprd04.prod.outlook.com (2603:10a6:4:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Mon, 4 Oct
 2021 09:45:02 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 09:45:02 +0000
Subject: Re: [PATCH v2 28/84] dc395x: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oneukum@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     linux-scsi@vger.kernel.org, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-29-bvanassche@acm.org>
 <0b774aaf-1981-2934-adfa-c1d50e43386d@suse.com>
 <71cbada9-f98f-316a-9a58-04b4555234fd@acm.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <0d29b6ea-0590-0c8e-e4d3-67c1f2c861e7@suse.com>
Date:   Mon, 4 Oct 2021 11:44:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <71cbada9-f98f-316a-9a58-04b4555234fd@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM6PR08CA0038.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::26) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from localhost.localdomain (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6PR08CA0038.eurprd08.prod.outlook.com (2603:10a6:20b:c0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Mon, 4 Oct 2021 09:45:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74493558-fcaf-445b-32a1-08d9871ba307
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2647:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB26478F45D623D2DB01C960C4C7AE9@DB6PR0401MB2647.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1iP7SgBAWcr6r/lHdC2gz4GZaHp7/L1PBKiZwYw4U36pYnypouTLiklDUrz5FXZq/0/KI8WoF/sPxl8NQfewnjWXv5IEP+zBk5Oc/2ZWwEb/ugwv4vAlhyYDrQ2q+r6lZ96/AGT7ZiQbTh9LK9nJfQRPRlZ2wI3Pp0BjGKdQUJA6w8wAx9SioFNNXi4lMO9rbD9yTGdocTidgr6NyEmLAPVN/W+jNeiOgrOqRohW9UVLngZMN2NcR5RwFAyCf/Ygwm4l7XBVofHUIomvbhAZB5pg+62u1Pyu4C7P0uAvGdjucSmaDhL+L+BmQg/UK94HR63KfDVq9VPO6huzV6XkSqhhJOn1TgRKmpbZLG0OYFpW4vlwG3wB3t5g5fRj4v7FKXRA3V5NxD0Gulhiy7fsJMh441yAVlzruxCPY0PxMIUuRp177OO9tdC/cYp02g/QNjivd5s3f5g3Au/9MiEl4XXXygMMnTjV0iiPzFiAYRkS+fZnNjua1pEQej7qXtoOnSyHQuK2d+VwRr0L/oOWhchmwkbrIKz5K29UkSQmXvlXSQnLy/fih+5h0LhcjTtX2RHAwDaZcQdJ/nO6RQWsrAFcCmrMfUrPY89bLJJKRRTvD0NrZo8tbfjOpvXNyMHpSc1CGb9mcinGN1gxzRDQKD9R/JRTPZ1EvqQp5tpIrF7vw/jSr3BZAqyfhy6BKMk5pjDOdjlfxPSv96WuuzwHXo3qwtld31eCgboBK5PGQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(2616005)(6486002)(8676002)(6506007)(53546011)(508600001)(6512007)(36756003)(31696002)(86362001)(31686004)(66946007)(316002)(66476007)(66556008)(4326008)(5660300002)(186003)(2906002)(8936002)(4744005)(110136005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QDgBZsTEFSDjG/R23PkiJBqP05lKzzheyvvHd5lyCWEq5SewYJPvZ65MdkDw?=
 =?us-ascii?Q?HOR2N1wcDk0TEOYiH9ZR8ZWSiivNctXo3MfUUdfnAhdfNLaZhzumxQSzbpBF?=
 =?us-ascii?Q?siTMBH+e3+CUXMUspepyd+8jvLEuj2d5CJ1I+8zdcQNTUXEzlJjTQ0sfRLZj?=
 =?us-ascii?Q?mMsDeEOksGd8cjidulNTkMfKPDf+YfNS7Q5xn3z5ex2UcpEhX+HGHEX11PpW?=
 =?us-ascii?Q?F7/iDvv7RFnZYJVLE2szXfA2ZY6CZQ069xUxs6oOWuVOFze7FHTzZWYye27r?=
 =?us-ascii?Q?67l7qNf0ZBfbOdcVdffhwhHGXRcA7OArLwmkftyuVOWrDMcWZf4MQpN+JgWa?=
 =?us-ascii?Q?xiivTk9f+9Dnp9HmvBXfu0ltVusVGKfgr/99f8qFQXeE3Ke9sWC3dZG63CDl?=
 =?us-ascii?Q?H69h3dgaAKIUX9wVbciFohxEN7Bai7kUARF7p9LwMtfoV8lPLKFmlXREZzky?=
 =?us-ascii?Q?55Rk8LjpW8Ysiogf9gnAh8gTaZdCqzqL6U36/VojyVR1O2lkYg3RSnmSlEGr?=
 =?us-ascii?Q?6SIibw5PFhlWSTtBzEIeTagNVe+vRdmmqd7Viegzw2+Z+BwTCaPYPrUebMhE?=
 =?us-ascii?Q?Sa2VT6oLSYlRf5D4gycv8K2opsvM4aNernZMuK2KEh5bdlCvFiiHaAXcrtPv?=
 =?us-ascii?Q?KpT7gpzGyPILLHBkwN7TAYXv0HtevpwovZeYgeE9B7aWaaWIOVWd2i3EMvVM?=
 =?us-ascii?Q?HMQnrA9aR39UMm9aE2nYK+vaWLkaYSTRP2uV9FzDJ/q93C+WXHA046tWgxxG?=
 =?us-ascii?Q?TVbskoEXEGk7141Y3Z+ofBfBtOaXe0xG3qL+Ay5AoosSGfeI1dHXschFrZWs?=
 =?us-ascii?Q?0URTgdT0LIjbI4wxzPiLujc9u5kQX47DO0B23ERRR7TG+6RRyYmzX3HdVsvn?=
 =?us-ascii?Q?6vX3GRTy07X4wqBOuppCJ6u6EcBYUlwHB8u+tQc5sKwii/qdKJv+fm7ccUfu?=
 =?us-ascii?Q?heS4v1BFAua7WGMkF86muEI9corblTIVe0tJ3VyhbnBrMrSIpnzU7/+K2dv0?=
 =?us-ascii?Q?sZqEDw5aNFgZAXR8BclBUPQ4V003tT57l/Dk+Af17mipjf/yf7G9cwwBkm0B?=
 =?us-ascii?Q?9/bqmtIhWUYpRD0ofuISzV4UoaJOLFshCmwZ6Q4gzvKNa5592ec/S+6BkUgz?=
 =?us-ascii?Q?bOVLo9F1A+caEtHwWYgfpoLiO+RGKwJVCn1z7v7YKQe+eqXwXFycFpFjpleQ?=
 =?us-ascii?Q?6fCL+1luyeobFcTyQgzyUGU+IC+Jd2dTsxw8eEzKlrsm2Yq3x3KfjCD7zv9S?=
 =?us-ascii?Q?5tlaaIFfq7yEnYN9Gi5/rwXgYAsCjNNoYXEYNV7lmNrbmH7ctdxfbsVe16eU?=
 =?us-ascii?Q?i80avzYgSk1D9YFieD0thjCY9wDRwCE2ejlm1qnb43wqWhZZyu+Rv0DzYdTe?=
 =?us-ascii?Q?0lUUCT4KBymiy7E34QDI4LjDScxC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74493558-fcaf-445b-32a1-08d9871ba307
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 09:45:02.0699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLiiyZaUCsIpeM4eMvcQRB4oP31rf7IFtu8uG4i3jSK3jMJjuQz1XJ8aXkVykQG6w3518O801yL3C51gUU0QBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2647
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 30.09.21 18:04, Bart Van Assche wrote:
> In other words, the 'done' argument can be derived easily from the
> SCSI command pointer.
> Do you want me to include a patch in this series that removes the
> 'done' argument from
> the queue_command_lck() functions?
>
Yes, if we pass a pointer, we should use it. If we should not use it, we
should not pass it.
Then the SCSI people can look at a patch and decide that issue.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

