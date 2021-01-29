Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEC3C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5FA64E0C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhA2TF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:05:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56228 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhA2TFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:05:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ08ZE087024;
        Fri, 29 Jan 2021 19:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ASHwL4t0PAmyy4wfXsCe8923GXZ9Ta1ecIoWgswL5vw=;
 b=urhjAarhL4DiT5NjrCXT5GEGd6/Hv308DaDBRkZOHcMIfYk/0NpZubOXNlALDRePHMlC
 2jeJpjaa6Fj58ynYx06hgoxDJSCL7GDJa3fZ8yRTQoZ4AcPgeERllkVvkbUAEHsi0x1Y
 wK9caMvS70HstZnRq9fhbLIQa16MkTCPuy28iGhybDCLF1FqmEdtV6qat+YlLQxVxoah
 g9z1MQ2SXaayiYNfLn7gz83SfPTcrBG7ZB4oOVji7CplOPifaNulY6L8AvkTTOijdiQa
 KxLFasPPXyqh41QekhY5RnA0vktDXvtRV341LnfOG5ykQjydF/pyFPAy0vmWQf6j8m55 Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7rav56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:04:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ0Lpn014704;
        Fri, 29 Jan 2021 19:02:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 368wr2b6kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzL2LtuFttXabI/x/iHqzZoMncno2B5EhHu5bT2TgS+dgjhHcDz3f/W+bFryee2dE5BmuNkcpCmc8FOVsHkGdZ5uStTfYjkRNzw8/TsEzcMIlN7lLuN2dZvfPWL1p6DJTm1+I4f9IHhB8xjyxBMYgHzUOmcQ2rfw2otFoR3uDd0gNIv/dYJGOYlj06efqIKyrwQhscoTPgMlkSa/0wJxh5kssbHdvW+U3CTZQ64ptPeTq9k9u95m3uDRTup2wIJHtJzyPn+YzVhtN3osS8+TgyKntVkeF6CmgSCMyF7XqczOsKZGFy322y/rFGlxgapMBYmYmthj5QK3H0X4wReq8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASHwL4t0PAmyy4wfXsCe8923GXZ9Ta1ecIoWgswL5vw=;
 b=Ff7spuxSWzr6XiQL9kRa7KmflmdD3XSLOjNZpde8d6atT5eDvZoLF+8j4pBBeLBnKlEdAktg3/IBR9aR2NiYz9Tc3zVCT4vF1sNUrOveg51nIe7Q5fzPrkm6MFfMcF3md9sKIv6sah/6ESH9siEQ4E/k25PSDk1XL4CuXp25EThNBzVOi7jMuCtZHpKTz/sxxvzYJIB9Zw8yjEHnSXbp/lKjtsVdJ8AZ2nPwGoYcYNua9vHQ4rMjC3VHKYLj/zcQ5iQbv9QzVskJRQk4God2ufPDInSw7MBHPbOgmZSMxwnTCG8tg7kFARoj6i+0/EY+1xpMVWnZkZysHuFOeeOJjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASHwL4t0PAmyy4wfXsCe8923GXZ9Ta1ecIoWgswL5vw=;
 b=lVPWBU+E/fIRS0ntnS+kB8Izg6qaEMyHRU55Cop3z6WDyxAhmoG8AjpSWw4upQfI1tTW5tdbvyUx0i6zp9lYb/68SVZb4Plm3tBMziev1vqYsLSPgzH0pVt29djuwlNg59gjRhNopjhcfpxdN/4fT9fW6YY/3Eioe3/Z8pVeNrs=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:02:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:02:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        kernel test robot <lkp@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ncr53c8xx: Fixup typos
Date:   Fri, 29 Jan 2021 14:01:50 -0500
Message-Id: <161194526371.12948.4451569270862782731.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210125085415.70574-1-hare@suse.de>
References: <20210125085415.70574-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:02:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cb122f4-17c5-42a1-a4ce-08d8c4885dfa
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677DCBDF8F77DF6CB693C668EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4NN8LTWkgOWehwaiAzVyho5sMF72x7192F4aIwYXkMzvhC37peMh6+yykWRf9sRbJogI+T7W9PNWz9bLjDXiNzDSAl8bLPnWzN7GTecIR/hWB+6ZKqjZaio8Yxq6ZV3XdiSPMR23R682QuTXrZWV4vqxOnBE+MAfXqSRtngknZrGAky4NWH2je5ID+TaBHvrzc/kKDUdOjG/MTnPiZOhoU/R5qBoqoNPLTXqU0PObnarCfId8BJnlgYWJMQmqoKuyEnwTAaEDhwaBWXXQ1OleopudZX7aQmtpsjMlTfWaXff3+9aZi5XmkEDwK1KSWY8tejXJCk2T2hKF20+JvOBdWEBUprOzqrInKvIJ83mzsLj2igeEudHAktogrHO/RJRzPDsdTpBXOX35ijnuPcxDfm2ldySUNly6Xex9wPIdtE52ycFXD/CpqJzvTFLzECSIcfLc+SpUPTB7R6VFKDVtjgp6Np46Es8HU5c+AHNx1UZWcUl8xdVfxgEbewQa5md0Q9grDWNi8TDq8BrHmmFw2/rsbBVK0ddcbExMJfefpb33avncxNiQaKfrwPXBxp16aBZvIJLdASJWdcumdyyCtRVKDx+PbQ4s5GrdQycXlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(66476007)(2616005)(26005)(52116002)(66946007)(558084003)(316002)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(7696005)(6916009)(478600001)(86362001)(54906003)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V1IvUzUyclFNaU5pV25TSGgyUmR4WkJmYnpPUUdGZS9PNkNLTFNicHpZQUVk?=
 =?utf-8?B?cDhzM0szTVE0OEd1UnZiM1dPMzB0NG1XQ05zajNmZHVUeDlnbk5DeVMydjJN?=
 =?utf-8?B?VHJ0SUs2UkdYYkh2bE5Cb0RnWlpsb05iSTM0YjdLc3hpNkNFREdIbUZla05r?=
 =?utf-8?B?djBqNHR1ajdLaVM4Ry9vbW1pbDhpV3BrbTQxdTNub1c2NU8xamRwQ3FEYmt5?=
 =?utf-8?B?T3hBc1dBbytkTGFYTlBWQnF5NHZLd2VFZitpK3JKbFBnbGZLNnFybjZDZXVH?=
 =?utf-8?B?RWJoaTczeUhoamlvMmo2ZElpcW1vOVpYNlRmMDRyeXRiNC9WQi9UdGxsT200?=
 =?utf-8?B?RFZnL2JEU1F3UHYxM0FFdDRTYWttUmJsWEtrbnZmdk9QRklaQlRXSUNERUg0?=
 =?utf-8?B?ZncrSHU2Y3Q4dnFVZkJJUEtTSnRNM2JqWVBBR2JGbFcrbzhzZUdCa0tCc3NR?=
 =?utf-8?B?d0NEUDh4R2tFWjZyYllVMitsSys2ZGR5dnhXZk5UUmx4bm90Tk9KaUR4WjJ6?=
 =?utf-8?B?TEVIUkNmZzV1NGo3Nm10aEs5RlpEYU1OcHpZSFAzM1BpYjJPeitSbWRGZEFI?=
 =?utf-8?B?ak1DaUVuYk1XQ0tYVWZ6RTdhbjFDM2RBK3FMNkJOcFd3RGNvVjMydlZQbWxF?=
 =?utf-8?B?RW41MnRpRlh3Skt3WVdrb0lFNi85cFNBYzRoWVlvNm9XTmtIbnBiM1puTytV?=
 =?utf-8?B?L1JaS0JuY280ZGpjUmFUWkcxZnlLL21PUHVqSlkreXA3RFROYlFCS2I1cmM4?=
 =?utf-8?B?MHd2dy92R2lhVVprNjVWcDNmYzFSK2pBMW9zMEh6QVhuN2o1bnh6RlJVUlB1?=
 =?utf-8?B?dURDTGRBS2hMaTQ1czAzZVJwaXIyZkpCYXNwZTJiVWZNaU1TalBtNGhGcG5n?=
 =?utf-8?B?Uy9HMzdJVlpldjBub0V0alFzMjU5WjFTSTdBL0MvOER3VzJJeC9nN0VxMkI0?=
 =?utf-8?B?V2Z5eVZ2b3dOaElTZmtLL0haUU9NaVkxVytjdFh5dkJmZHQxaGZEM2kyL1JU?=
 =?utf-8?B?ZXhlMjhhMCtDVDFYMmZhR1lpcWJJbmxjZDRXdDFaZk9hU1BtU1hYUmhYU3Bi?=
 =?utf-8?B?aVgzTXloOGN0ZTJiMHlZMHpCOFEwM1NhVWdyVjJRdHZIYi9Ud1RneVE3bEx3?=
 =?utf-8?B?dUdXNFJXRStMcy9Cc0EvWnJ6YUxWOTRqR1hINlVmaDJaU0FGeG4wR3dFMmtn?=
 =?utf-8?B?K3R2cWhQTk9ucFhTdzR4elpUOTBNTGZoNDFWelNYSjBCZWhoMGR4a1Zza2E4?=
 =?utf-8?B?c1hzWllDb2NieUJzTlJFSmVzd3c0WDRJc3JZZEVpUEI5TFZBSTBrYjJEbUQ2?=
 =?utf-8?B?MUlKYlhTRWc1Skg3b1NYUElxQlhaY1BMWGExTFB1UlZ5dnJ4VElRdGZvREI3?=
 =?utf-8?B?cXJ1aXBKZm9kb282eWdadXBRSWRaRTNSVklRdUpBa2p3UWcrU2ZYTDEvb2FH?=
 =?utf-8?Q?Tq3+nJ4O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb122f4-17c5-42a1-a4ce-08d8c4885dfa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:02:04.6897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 987cQu/U4qyneKKDBFJzodz9IEE8s+5mA26AE54S9SSLWZV031GHeLK2VNPW5Qc02/RUK6LJBIAj4NHgRBSLxA2b9+xp/QcbXzf+9iXiMi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=974 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 25 Jan 2021 09:54:15 +0100, Hannes Reinecke wrote:

> The patch to switch using SAM status values had some typos;
> fix them up.

Applied to 5.12/scsi-queue, thanks!

[1/1] ncr53c8xx: Fixup typos
      https://git.kernel.org/mkp/scsi/c/3ae0819079f2

-- 
Martin K. Petersen	Oracle Linux Engineering
