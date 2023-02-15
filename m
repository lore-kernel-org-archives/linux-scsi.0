Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6B5C636D4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Feb 2023 05:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjBOFM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Feb 2023 00:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjBOFMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2023 00:12:54 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94C1AE
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 21:12:49 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31F4xt0Y013773
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 21:12:49 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nr7f5u6vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 21:12:49 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31F59PNI005971
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 21:12:48 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nr7f5u6vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 21:12:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d76HD4kDnAm4e1Ca7fzzEusHs7E38cjf48kab+KtO2UKNUvPT9R8g5Ky2P/n6pRv5xKES/FkXTT/kynQAFZHl3ROZ6mFZFqmFmkbMwCrDuFYUJymU741qauJFIxH+LHTfk2Tgbom7IaGZpW1PsW6qlWkqE1OxB22R5HOjOIypj5qnx12INJqMabn6bnB7nS7r63ejhOzaOkfXhnL9+62M0diOZbII9yk06MHKCitZly+nZrCLfQ+7jhq+YV1cltg3JyUF1pBPemUZKV80fD1d3GEoJwLoRv+6ipCEaY+PkShvtEW4VbjAR562VY1fan206KIL0odRn02ek0Il3yPBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llHj2wRStXcJeLP67zRt2Ys54GfGltktBfxpWBpGp2M=;
 b=MSP9W6/CYodVmBZAjRSE+H2rnkAJ008gZ3MQBIrPaX4RGfHH3PHeVlFdo1w6cdFUEnAxs26GgrSyUQchzhSVc4IbVko+qwZLHNRStYxn5Z9p+g3q9XgsYkIQk8MKA47kcTDMX+DGjTDji0E4Oa5AG942eMm1Pw66xjXlt4ectWuGej1GfGSP3WSFrB3p7wWttpFAP+CbcAlxeSn/v9r9sk5VFUWRpaXqo81hX+SF9/9/begbkqmUWY4EEzRjlZpnRPpc4BRn6n60N28d6xJfMxpOSwMidzPv781G0HFLFBVdp99s01vT8aaPSVZhzFQ382fBTEyQMJ1U9g3V2lFShA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llHj2wRStXcJeLP67zRt2Ys54GfGltktBfxpWBpGp2M=;
 b=e32F588y4kl6tpgleI18jEQ/uXzboEoZ9Zqn91A8Fkc7H1KAw0tSoST2AtdyPvSPk56sd1MCSYlpW/VCJGowKPuoQAGzwVseVjMK9zdtvfA79ab25V+o6V6QVhPXCodeqwKjF0VxVBCzp1cJAg2cMxLgEz3pOx25lnDWg6hftpM=
Received: from DM4PR18MB5220.namprd18.prod.outlook.com (2603:10b6:8:53::16) by
 DS0PR18MB5477.namprd18.prod.outlook.com (2603:10b6:8:162::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 05:12:46 +0000
Received: from DM4PR18MB5220.namprd18.prod.outlook.com
 ([fe80::bbcc:7359:7a4d:3e3b]) by DM4PR18MB5220.namprd18.prod.outlook.com
 ([fe80::bbcc:7359:7a4d:3e3b%8]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 05:12:46 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Girish Basrur <gbasrur@marvell.com>
Subject: RE: [EXT] Re: IO error on DIF/DIX supported array
Thread-Topic: [EXT] Re: IO error on DIF/DIX supported array
Thread-Index: Adk65h58aAJPomO/QEKOGTaF0/rqJAF/VSswAAYhF0A=
Date:   Wed, 15 Feb 2023 05:12:46 +0000
Message-ID: <DM4PR18MB52203B718C5B349BE0302769D2A39@DM4PR18MB5220.namprd18.prod.outlook.com>
References: <DM4PR18MB5220E0AF6564DF1A1F126EF0D2DB9@DM4PR18MB5220.namprd18.prod.outlook.com>
 <yq1edqru22n.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1edqru22n.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2thc2h5YXBc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy01ZjU0OTVjYS1hY2VmLTExZWQtOTUxNi00ODJh?=
 =?us-ascii?Q?ZTM1NzAzZTVcYW1lLXRlc3RcNWY1NDk1Y2MtYWNlZi0xMWVkLTk1MTYtNDgy?=
 =?us-ascii?Q?YWUzNTcwM2U1Ym9keS50eHQiIHN6PSIxMzcwIiB0PSIxMzMyMDkxMTU2MjUy?=
 =?us-ascii?Q?MDYzNjAiIGg9ImgxNm1BSTBwRkI3M1VCbE9mU21VYnQ5VUNJMD0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZSUFB?=
 =?us-ascii?Q?QllNcThoL0VEWkFXUzZYMnJ1RU1sOFpMcGZhdTRReVh3TkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdC?=
 =?us-ascii?Q?MUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?TUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhBY2dC?=
 =?us-ascii?Q?a0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcw?=
 =?us-ascii?Q?QVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFjZ0Jm?=
 =?us-ascii?Q?QUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFB?=
 =?us-ascii?Q?QUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhB?=
 =?us-ascii?Q?Y3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FB?=
 =?us-ascii?Q?QUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFa?=
 =?us-ascii?Q?UUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpB?=
 =?us-ascii?Q?R3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpR?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJm?=
 =?us-ascii?Q?QUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFh?=
 =?us-ascii?Q?UUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtB?=
 =?us-ascii?Q?SElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQlFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFI?=
 =?us-ascii?Q?UUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR18MB5220:EE_|DS0PR18MB5477:EE_
x-ms-office365-filtering-correlation-id: 962f740c-5388-4199-e8ef-08db0f134662
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Vv6OaCZGj821mNUpj9iuG3HjAc3+UM49z9aVvWHv7U9n7Q8SqAW3c2KylmkfZqFYm4fTi7R/WadHxhRSSAKhy3h2aH3ukZZRcvMeXUzppuDDdx/Q2uZwiqfqmK+oVT/ytn6yglh/vrnWW1mqytwojG/rzouSKPdsecSnSt/zrs7ck0qYmaZsP3HNAS9ddSMeiQRXUae+6oDn0Ay6PFp6WvXHJEy7F6ZZfkjng3EntPE5//TYokmv5Jdin6iqNxnqb6C9y6uXA8/S7DQZy8g84u4YCHFaqrIubo0wZ56K2chgMREndYojSYD4npGC5iY7yeW+1t9/taGVnmGHRi9+xximGd6J+aI7ftRGNaKP59hUbfC70vlbVofqMjBOlu22/h12lOsNNpglZTvg8aPv2F2SJxvbN5FhMf+aiAB2d+sShHLYk637VoMkEJ0CJ55AJ/QovVgbYvNYYBYSpQPfoSs/D92o/t61QH0jDvPPRvpcx5pTl5qMGFiKlAe0Myxq6tN9ctZ2Nk5ec3XTCrorhd03p4RdjjYjbOTIO/cll2rl5cK7UIIzjyaJJEISGsqTb3ME7GFKCUi+0K8Wp0j0WlXFL1Ge14a/y0zmsoRG2fmaT6IpKD0Kin+SMnzXlnHrH7QB9FDaGo6aOTImWOsLDRW+MiqGzWISSUZBpKGFwjhgiMzPMiBXGV7vhYz0pnpOEi2cPS2T+BbrYqjCao06g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB5220.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(41300700001)(76116006)(66946007)(4326008)(6916009)(66556008)(66476007)(8936002)(8676002)(66446008)(64756008)(316002)(52536014)(5660300002)(9686003)(54906003)(186003)(26005)(38070700005)(83380400001)(2906002)(71200400001)(55016003)(86362001)(7696005)(478600001)(6506007)(53546011)(33656002)(107886003)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?72LLYSNwVc2aEFi2vmsqeR3CHoedYiYhZUWtHl59ivnJ3C3DhxfNv0Rn7CYe?=
 =?us-ascii?Q?1NKjUPQv3AhMzvcxqqG8Px3o6VEI6mthrOXrugN4i1wFJko2vTLo2dFyfw1G?=
 =?us-ascii?Q?RgCenNqrKntc0J69eWz1s7lJ+jaXOq1Vm+w3dLsoOn4d+OfA+HpCsdpB1trF?=
 =?us-ascii?Q?5It+2kJjyuSh2HOhMaEu38TiCCgEv1+y+HFDDpaMkLHpblMvJo6d9f1cUXo0?=
 =?us-ascii?Q?IjUavmmO0OIfs4Wrwe0ewLnCwd4KV+Sakts5whllJjhMSH3HS2IUUVMUcRog?=
 =?us-ascii?Q?ko7OhFzZPgcYfwVf0aXFf9/k+IpTk/GH429yRJkzWahgc8llrKuIYYKtoFsU?=
 =?us-ascii?Q?DXjDOVX0sx8lupAtmCtyAcGwYi7X1DLzb2EQgXm9u4vdlXlj1hDyKdJOqMnD?=
 =?us-ascii?Q?RtTQ0jGXVZSDHUC5p6qNnsrgDirqd91RPIhGVx+eKYt4an+XxZ3QuQLq18t4?=
 =?us-ascii?Q?yqxFMjLI76HNBgIf1ZS1Wp5RtQ2Nq6ZZsrAogWW3LcMe96XQbmMApEcjW43v?=
 =?us-ascii?Q?+OdwnmFvgzChMNANylGWbf/jKnx44qnXSrmob/FX59vymJye9KIlOySXLuD0?=
 =?us-ascii?Q?TnTbxuiIhwsSBuwM3JxHMHLYFKKAfponZSHXcXGBZ2yM09Pd50S/SmL9UPeA?=
 =?us-ascii?Q?EfpAAzcTI/1WFUQUSUWGpRKT4FB8PRJJpaY87HR+5pCF5wq6uJVpThGrJxXy?=
 =?us-ascii?Q?jwK9Ing2T75uhG35KuSrBuWa9OzBCyCt7ed0E5k2nqiGwtIZzePZ8cOTIAjL?=
 =?us-ascii?Q?1LiOr4a4pz/zZDRKnYmUPQ3BQksCWwcHFEeqs8/S3bwFsWP+tV8jLL1ZoVOt?=
 =?us-ascii?Q?zJNfzMWai6WN8rRu2RmpJtwApdzYdU8bxfJosO6ED7sY0h56Iu0Cs02Pv2Kl?=
 =?us-ascii?Q?fYo9GEgmEnguTXWtt3nGOaJSbCNYfUuFRtKG5Z0pmG828Q59UpdE5mz2Hmee?=
 =?us-ascii?Q?TLPgeOvh+rzHM90Jxr+2irQLc6x8BPLzSsYTBYRfJ1wJDqLMRzljKttja18x?=
 =?us-ascii?Q?eGciKjD05vu7hTyZmC1xgR8IXhB+1TukHElMiWIs8ZniO4i8eNUAp/rifFVA?=
 =?us-ascii?Q?vXroRJKmLNv/0cC1wPXA7uZMzwLdQYhmlDyBBPNc7N9UcqrVYJnZbNmrbltf?=
 =?us-ascii?Q?nLqGJ7aV7rfHwuPimekTPI96SkeTrNGP1rEOPR+jUb916oNY+v6PSuwy0iMO?=
 =?us-ascii?Q?IE2VNbBybFEfTnAHR6pY2jfLoG+bsylAzRFflRzCgfkGjpNYkQ1B38UlAXE6?=
 =?us-ascii?Q?4vTd8xQ8O9FyfC6MBKr6l/XQFCDbxUy1ALaHFKGm4s95yA54KaFuDt8RZl37?=
 =?us-ascii?Q?NJoMW0OeqLZpebg90TQ25PKLq2EsQKe/gpR7uPTdvNv4un+7nU0ZaxwJ41cf?=
 =?us-ascii?Q?hTkjBtScs8MT62c5d6oZVppBZc/NA98VawXYrcqAfARfnb2zKjL7D4kH5NQZ?=
 =?us-ascii?Q?7zwvJGKm8DcuQdNktRclGIHLV1nRd/kBm+fVXxhNvlhpG6BHh/NjnpFiVR8u?=
 =?us-ascii?Q?MBiPaixKtzUdD2Aqh3t3mhXIXDw9gv78Aw1ocXRnj39xLjVaoNIU4BH8QfmF?=
 =?us-ascii?Q?iNujLsYXKP5qjC101+EIiYkTjVnLAjGTn86a8Puh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB5220.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962f740c-5388-4199-e8ef-08db0f134662
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 05:12:46.2114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoj4Rfpl8S+oqJyBhVl3gpWrjZdNBIMuD3wxX7E1CzSsWpTS+ziVqpylpqb8G+EKpwIDw6b33Ao3OFoiCMtJjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5477
X-Proofpoint-GUID: 8tE-efMP1cyBntleP4IbkCuDaJV8HUNM
X-Proofpoint-ORIG-GUID: o09FiDgUP_qM8nthGTS0kGvuqUSm7-Wo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_02,2023-02-14_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,
Thanks a lot, below patch have worked, kindly post it.

Thanks,
~Saurav

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, February 15, 2023 7:46 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; linux-scsi <linux-
> scsi@vger.kernel.org>; Girish Basrur <gbasrur@marvell.com>
> Subject: [EXT] Re: IO error on DIF/DIX supported array
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Saurav,
>=20
> > 1) Is there a specific reason for not copying the bip_flags in
> > bio_integrity_clone function?
>=20
> No, that's a bug. Not sure how that line got lost. Can you please try
> the following patch?
>=20
> Thanks!
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
>=20
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 3f5685c00e36..91ffee6fc8cb 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -418,6 +418,7 @@ int bio_integrity_clone(struct bio *bio, struct bio
> *bio_src,
>=20
>  	bip->bip_vcnt =3D bip_src->bip_vcnt;
>  	bip->bip_iter =3D bip_src->bip_iter;
> +	bip->bip_flags =3D bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
>=20
>  	return 0;
>  }
