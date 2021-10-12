Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09997C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83856103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhJLUhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9498 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233019AbhJLUhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJjXQJ016792;
        Tue, 12 Oct 2021 20:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=61WpGsILURTqXAgB49nRvePgq0hoPgvURZoA5JHjOVY=;
 b=fyI7GXhV9uaJWQAx6E4zoiYR4GBTLPbg0eEyfs2OkLa9HthN0xs1+E3dsJoeeaHD9yYu
 J4VWYnTLE+VMkjO4hcKx+Lz43wlWofVUzSWAUrsR8iPmxNwx8e/zzWmfgS7j+l3cHGqP
 043V18K4erfAsee840DVh33L66qLJdbKH4yxWIdyOwVEpdlV3nclw16aW9iyPionyqId
 bPdZym3ohGRwigxrJyQGKF0kR9v8S6QUsFOfn/uwbTQHf1F6JAaxufDHtwGrIk5G6bED
 pIC9kpPU9KMFrh7KMbinb2noPtho6rNc3dyx+fNsGuyEOqVgtM2BwIbqWxS+4p9EwAfV Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ98l018006;
        Tue, 12 Oct 2021 20:35:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 3bkyvau7n2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0BqHd2+uB7uYpD5m0RcQJ1DgD00N7V6a/xzM67e4PgzVw87UE7g3+YcTyRclprHRkqCLNHxjStgXDOygns75oi7f8xivzG0+OjrhotQdppQyvgPfIo9VUSwxTL91DulBS+PbS+sHKYOuzD810gbMBEwLJb95zQ1CkwYrVj0Dnh04A8on2wV0rF5u8zlDpz4NScOwhC6uQQeW0vGmADa4zj3S79CsYOxVmwiHjkZe2KnMmFzAKsG6CLc2qfJkld5ZGePZ2895aUVpdCQNTGPtfIMnUFiequyrGMnlt+DQcihDe3VDucGVNLe3RfmQ1Kf9QtwrqsBlsStO3gR0YVpQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61WpGsILURTqXAgB49nRvePgq0hoPgvURZoA5JHjOVY=;
 b=Kib9ghag+eKjxvdXVWEsM9rRolR7QYYzcjbXB4O+1xpP+Wk1ru3e91IinFl2BfDZYYOQeSGaiYNP/GM8AZZP3MOvuI9BIsu5u9tvs6PgXu1kd7SpygwxnuxdGcC85aoK/dgtPCSq4oFa4mvPKWqUKQR+n+AWIXGTva3LNec0nxYr/U55sHZte4mZnIMfSLDH1VVrn+TN76YymAMmoPsLYkljBkyEGLo2B8q5mMZdcoYd74yk4kolR6XKJ9B1gCyxMcSju/LtnP2gh0tTCWlhirCBiEFt3yPKYu7+XIZl4U4pQaXifTJ5U9U4+mcWv349rcksqvrjWX5hDj99I4HjMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61WpGsILURTqXAgB49nRvePgq0hoPgvURZoA5JHjOVY=;
 b=VFYFqQ+DoA0gURYI6mkkFTJdKzYgqVMegI2PNK05q7Vq5X+hrbjCipD07NZ60lu5tgkhIngF+7y/Qi3mGMP1FrnnYFTFdCs0gEsNLbdopBi0PhAICyj8pGhUxxboIeFbXueRor6ATYWC4T5Ok6DzEAea3WZzVtVDm1oAub+74Ko=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:125::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 20:35:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        chandrakanth.patil@broadcom.com, kashyap.desai@broadcom.com
Subject: Re: [PATCH 0/3] megaraid_sas: Driver version update to 07.719.03.00-rc1
Date:   Tue, 12 Oct 2021 16:35:17 -0400
Message-Id: <163407081303.28503.1776441364453793050.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929124022.24605-1-sumit.saxena@broadcom.com>
References: <20210929124022.24605-1-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b2d18d2-64a6-43ab-d2d4-08d98dbfd866
X-MS-TrafficTypeDiagnostic: PH7PR10MB5697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB5697339B78A2E66A846FB52F8EB69@PH7PR10MB5697.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6QwIlu/oXkcsXVvGAjy7mL93E4SWulg93kC6CURHQXg+CK3YHT0fR2zMc+SENOkBg7UoW5aoeq7fYGETA2w1O01wY6SzY7bcqRS16Nni+Hi6yhOUNLpmX1IGa2QpvFQ8s7/jDurAFL/iENYV5IBJEVbrUAB+FcrROEePfB6u3QODgSQhwh3iZ8yFJie0HpzomjiKT26jV6QDzp05o6nusx7mrpKHv9nI5dzzfwMnXkdwZuFyZ1hnD6FtGCG1pc6AzjnjkytmFujbw1xvh4KwYSN7QsmPYr1upyqfWx8sHSe0CtFzYSIiY7qGL+NI0w/cphx2hmCB3EmBAMteMUVean/5De+SVizy1oQSuTqY+E2SL5DwMxgtPs26Wkget2v2S036BWUmsdqc7wRJwHdp2znfXRxInnxn5tdiNqkHM3XlDzrN23+cGwMza8jxx7mklmOYp6I26d7KskZENmpielMRfe9kMiMg4xs/2RFMfPmBthcBWLeWoe+nxPNvqprDOVS8/xKg38jfFk2yW+/xzOClR/jH0z31Wj2GmKBsBD/Ii52Tgoeshy9lrKvPX0f4meaW1mI+uh88iofC9rPyuw3WzsM7VI6wNbhBcVR4o/9yf1PEcygcpwWQuSj29RKdL2p7sSUQiQr8H+mxCXYro5JIiYKQHduiwLHDVHYHWDytsAPKkrw42rxiDtC0rGs14xvWkX6Lbl5UlCbpC41H6GFRnxdZX6PfTK6ulFhm+dZglBg40XQ5S4pfP102F/EkZEKsVrWyiJ6rwJejING7Eiuy73Rt/HEt0mVK0EV9J9sIVaQncmXydLPJw3WHbXRXHk5dQP0PJRQ+C5xBkC+Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(6486002)(4744005)(956004)(7696005)(66476007)(52116002)(2906002)(66946007)(508600001)(15650500001)(186003)(316002)(26005)(2616005)(86362001)(6666004)(38350700002)(8676002)(66556008)(8936002)(5660300002)(38100700002)(103116003)(83380400001)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T015djgxcFlwTnNhQ2cvOFRTVVcvai9EWElHS2NhbUxSL3BtQkhINkR1VW1B?=
 =?utf-8?B?NnF1OFdVQUV1ZkZLVkNZWGpTeUxwVEZMQmxKYnBxODhydTltSzA4b2ZWQXdl?=
 =?utf-8?B?cjh0RStNVjk4Tk9Ra3Z0d01zWmNNdWMybnhhSVdITzVFSXBqNy9jVU9WMzln?=
 =?utf-8?B?ekNOdFJNMTZ6ajlKU1VENVdqM2ZMamorUEU3cmtJZWRodFVPczRyOFZrWkR4?=
 =?utf-8?B?aWhraDVMNis4L0daRzRxSXoyMkFaMGMxWU1Za3NrbDk5V2JwK1ZBNENtaVIv?=
 =?utf-8?B?MEtCcThUQ0Q5V3kwcWhuSmFoT3M5Yzltc2xaODZHZUFwY3ZUb3p1djR1UG1R?=
 =?utf-8?B?SXhoRk0vVzNKQTdQeVhzaStsT3hCTDN2QXAxcjIzT2dyODZxYk4zaTZOUnBV?=
 =?utf-8?B?aTJQa1ZpZ2FMWmZqSVNudmZlY3NDVXk5b3kyMDJnZXQ2U1Z6cnZWWTJPS0lF?=
 =?utf-8?B?SXl2cS9CTFdZT1h1TjY1ODNaYXd3NkxIVHFuVi83YUNTU1BOQ0ROZDJweUhs?=
 =?utf-8?B?eEVrWHU5Q0tRRk1adFAyL3dHV3BMbndTOWF3emRVdUNrcDNPWUZycG9DOGUx?=
 =?utf-8?B?RGVmRGg5cE5YKzR0ZTl5cmU0RWcrSm5tdVhTemNxZG9PTHFaV1JtbWNwOXVR?=
 =?utf-8?B?c2VicUR5YUFuR3U4K3kzbDJycGlBdnl0R2U3MlJqbWdUMFZkeDlheTVZYjZl?=
 =?utf-8?B?Z2RXRHUwdW8wck4rN0pobmRnalQwMFZ6NTVIa1NCTk1TckpFOVQ4S2xaV2lr?=
 =?utf-8?B?aUxJL0w5U2Q2TFhZc1ExYS9PczZFeHI5akJXakIzMUI2STdVb3V1ZGpHRzRG?=
 =?utf-8?B?STVqNUtWNmp3cGdyQm5wMjJud0YzaHZFcnpyNExkUXFKcm9OWXR3VkorcVUv?=
 =?utf-8?B?dmc4cjFOZ0ZMVFg0TElJU1dzWnE5L3RObmNja0NMUkljSWlvbExmU0JqZHln?=
 =?utf-8?B?Qng3V3NBSkZJQVlxMlZrU25EZ3l4MVlvcTg1Q1RHN3dhR0kwQVo1U2FLcXgx?=
 =?utf-8?B?djIxV3o2cjc2Qm9IYW1rdGtPN3BhcWt4K2taSGNMaGVyOVA2RkwxUysycmIw?=
 =?utf-8?B?ZWZ3N1Z0Z1hKc3J3dkhwTUJZY0Npc3plRFpCbjdpVGlFZ2pIdkppamlkZ2th?=
 =?utf-8?B?TU9UWWF0WkxIRFRyZjlqY2RDeXdnT1U2dmx1M3VKRmo1eVJNVkZxeldTbkpK?=
 =?utf-8?B?TmJzdVJmelpvUC9zbXFxRTc3YTVaUlIyaW9PT01jbkkzZHJzTHZwM1lzV0Fz?=
 =?utf-8?B?czVsK0RVMDMyb211cXBiUlRUODBkK2ZxelpNcFd5eVpJa2lEWGs3U1J1Z2FX?=
 =?utf-8?B?U29PUXZTU1VBVmJnQUlRY09uY055RzRrMTh4eXAvWitFVkdWMWhVNHU5RUQ0?=
 =?utf-8?B?TEVRSEVXdjc2dkpUZHNDN1VpRE9vQ2JEN2YzVXV6bmxvNFhmUEY4WDlweGlh?=
 =?utf-8?B?U2w4ZU92QkoyRStjTXdtY1FjYzRlWlY3RGxReFNBNnAwdjhETzBlbWVqQ0ts?=
 =?utf-8?B?b0ZiMndaYnJsdnVWVHI2MThxTnZkZFZDeHpGU3ZaVUkvYUpOV0Y4NW0zZnUr?=
 =?utf-8?B?YmU1ZU5pZlI0SHJvOS8wOFlhazVtZmVnb2cyTldrMFBSVXMxTHhxd1FEUlJK?=
 =?utf-8?B?MzRpWm9UcUtBNkJRUXBOV2FZLzlNOGxaZzJHQTQzYXZ1K2ZKeWl3c3JjU1d1?=
 =?utf-8?B?S0hhNWdoaHU1Vk1TcUlrM0dWOXE1eXd6emViOGwwakVOcTU1dWp5b2QyZ2U2?=
 =?utf-8?Q?IdUPp9sx15Uz1FC+5jHDHscOLinE8n1BSPSLCEP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2d18d2-64a6-43ab-d2d4-08d98dbfd866
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:36.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xp/EUCroUNF2daRnCoYqBwSLdChOw4daNgluPg78DQrRoXSxZxswF16J3Omkp4Yhhb9rmr02Cqk3QMXt1uPg8spJegwTlXgQNJwQxxcshf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=800
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120109
X-Proofpoint-GUID: Rc6M472V9Y2zmDQjJYBwln7jgCOr38UA
X-Proofpoint-ORIG-GUID: Rc6M472V9Y2zmDQjJYBwln7jgCOr38UA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 18:10:19 +0530, Sumit Saxena wrote:

> This patchset has a critical fix and added helper functions
> to improve code readbility in ISR.
> 
> Sumit Saxena (3):
>   megaraid_sas: fix concurrent access to ISR between IRQ polling and
>     real interrupt
>   megaraid_sas: Add helper functions- {access/release}_irq_context
>   megaraid_sas: Driver version update to 07.719.03.00-rc1
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/3] megaraid_sas: fix concurrent access to ISR between IRQ polling and real interrupt
      https://git.kernel.org/mkp/scsi/c/e7dcc514a49e
[2/3] megaraid_sas: Add helper functions- {access/release}_irq_context
      https://git.kernel.org/mkp/scsi/c/4c32edc350e4
[3/3] megaraid_sas: Driver version update to 07.719.03.00-rc1
      https://git.kernel.org/mkp/scsi/c/cdf7f6a10d48

-- 
Martin K. Petersen	Oracle Linux Engineering
