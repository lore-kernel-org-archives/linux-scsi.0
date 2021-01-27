Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F9DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C8E2070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhA0Fic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:32 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36324 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238731AbhA0Ezl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4kGp1093348;
        Wed, 27 Jan 2021 04:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EGGERSsOFFvjl9qECz786qpyiV9uR5FPECmuVpHUfQg=;
 b=WyuU7H8MoT0/rTEh0vzk3xmUYV9jG1k8Zfn6yMIn+vOegMZ7d6gsY52czXZbdUKDmxYq
 iofNaEtfDGQ/9e1zcYUt7azoTKegsZXRhNKUtHw2ryYcrJAbykT2LXcK+Ewn/7sKslbG
 /7DxcHCqXb5ftbrLkNO3Rf/v+WsBBbf12pSrWNMdPyd3JMtyR1mGIDTb+QirSozi1xqH
 SUuJkNvBx/E5SYGUBzNLSKmqpU42a0gkdMsizwD37/za65CLt5fHsJV8eBa2d/2wuDFN
 a6PEFZbn4ygA/6O/CRSS0tqcYGWVm7hJxbu4Xt/FAgEDxS4c8xnVDXoGihOYYSewk5zy dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3689aanbb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4o8Ml088816;
        Wed, 27 Jan 2021 04:54:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3030.oracle.com with ESMTP id 368wqxb8v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BE9Z3qS/34ODVFLjsGwHQLm3JYOmgLde8fU63tQBCSKDZ1v7mzuH4lpD/VWAN92ImdqLJREiYwIg1s8frVnKl1FD5VdkKb95lRajv3/1uvXRa4drN8YqZT1GniGeqMLdHi2jjBFhPaO6i1dgZhc1D7SS6n460XK2nmjO3rRRbwjgHUDFHZA2kd++N0C8b0sczhna3Rm9BKjDvFJZvmEEycVpQRS1SgFmzOz8L/zDuF3syIaCuDXdn5GFBc909kKL5psO3Vm/cmaPYaLp226m0NLy/cKVJm/Zs1HVeJaWsk2Q/hBIQkPQZWHnKTSpCkQcEzh/WupbNNNWW94yme4uEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGGERSsOFFvjl9qECz786qpyiV9uR5FPECmuVpHUfQg=;
 b=MlQefRlr5geRsbwzu85Aan2S+q4fWG6tVxrSTT3u1gHDmvCNjYMUgMmxc4FcvPLQrcZnWYRg38VI7eQqTVSfD/zaTJCn5HyCCszB7d7RopWAu4SIWLH0tCyk2UK5VbE4NVAH5tG8XlxGFyVoSSVOeUmClYtUBWxKjbjxU69ieGDXm1y4XYPAxdBAwdz9+8c0nyrwv3JAAsQuZbNDznZEOEWS4lB+72W1iGxc7VwioWyqUMqKDuEDMDGQwpDYR1dnBYD4jO+2OlxW1UibVaVXOIo0/bEqyDfVobcdfcJClMl7g0XhW0hcaPqUQBbsp8nVAPkYi85HWFxos+QgN8x4/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGGERSsOFFvjl9qECz786qpyiV9uR5FPECmuVpHUfQg=;
 b=ZwNBlg7NApt0f6eG+nDyigtnNbuLQIi/bnxidU1R5JiBLTHU+Ut9etlrdy7cHfjzUu4gUZcGyl4yHhq/xsPNupLtQQxbI8cPDiINGB7EnSODYJrOhqK7bpm7GEhH1Bpl4akMTA308aOkkgbPwTDzlC1J+IMmayKagUSbKjwI7RM=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        kbuild-all@lists.01.org
Subject: Re: [PATCH] scsi: megaraid: fix ifnullfree.cocci warnings
Date:   Tue, 26 Jan 2021 23:54:26 -0500
Message-Id: <161172309264.28139.12684031311043907871.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <alpine.DEB.2.22.394.2012111113060.2669@hadrien>
References: <alpine.DEB.2.22.394.2012111113060.2669@hadrien>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: def36121-6be7-49ff-0540-08d8c27fac84
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584F981596E97C250A588C48EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IKX7zBHX07vRJf6Adf0OcDX2nExXBW25mS0zcNUpcyNq43QUdS5ENIpzOF6kw7KgNUDi180ZrS4LLshNsQx9+Yhs1NJ8ZzcplAVcQWDxWg8r4zoPbNUyhgUATOB9dkGEfnB7Cm2xSzkuAImVfuMe5d2IlLlzQ5o87r7wMGELAqB1QN4M/YmdHHeRpEHhIVjdHv+1K8+uGUGD/gBRK7nG82NM7adbKBFbqm7DN/w8fJntFBef5N7c/evsfDhR0BZhittA/Gvx6VBTjsNjXMs1QXeZ+WIVsWEu7ByaZdDVeIxuZvCMyuQJz3KFvEappe+AT4U1NRLOCOUag0AhfDekaU0ReuId6xH5rPwEx1o7wtHD0q0R1VW/TxuP3LIogpW+FMmRd8+dzNxmMYrvOyWa2NOf3VbpWCP1VBJYsS9qA734cEUtni7hu/MKdPsL+PrHfbeUX3gCPWIKN3K70Uw0Sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(7416002)(4744005)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(110136005)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmliV0I0RjQwME1jUWdVZjc1NjFtWHgwTHcwd0Rqa09nM0RwSFdQOEQ0R2ls?=
 =?utf-8?B?UE5KL3c2U0VNVVRRdEhGY014THN4YkdFYjNTN1B3amowMVhtS0lCMWR5aWt0?=
 =?utf-8?B?U2ZWSFBKM21RQTZ5Ym9kZ01KN1BVcnFyZ3JnTmRkRm4xNmNmdlBhNW4wNllr?=
 =?utf-8?B?ay9icjJwVFJjbTU4WExnMHE4NzY3aDExeUxEZTFzVitoRjhUM2Jvd0c3aGpG?=
 =?utf-8?B?L1FCRmJUNGJzT3ZPaXlaQkZLajhhVlI0clZOa2ZHUUtTazNTWlVpTmVRYUNs?=
 =?utf-8?B?L3U2dmsvZFlUKzQveTcwSmp6Y1d3QkFJRXV6UHJiL2RmWURCSUd5NC9XclI5?=
 =?utf-8?B?ZlhBSCtraXZDL3Zmd2E3bWZvcWo2YzNBVGIrUnAxNXZWaHhzRUcxeTRlV0JE?=
 =?utf-8?B?TVExSmd4NkRhQ3ZBSlNNYi9JditXcHdvYzNIa0RkNHp5bG5uRkNGN0llY25Q?=
 =?utf-8?B?bVdoa3F3YlFVTE10dEVpYy96bWFDcnhMRVMyaXRpRDhaL2VBUG1iV0RpVmdl?=
 =?utf-8?B?aW9HQlBJdno3RWtiUTJEdzE3SzVXV0lDNjVPaHF6L3NWSXE4a1RDSFZEVm5B?=
 =?utf-8?B?Z1AzUUtGTHlGa05yV0pjK2J0QWpabmFqMFNXU2g1ZGhzMk9RZmxSQU1uRGZV?=
 =?utf-8?B?VEU0Vlc1czd3L3pvQUR0MnhOdy91TVpmTDRWVU1vd0xsVTN5ZFNlNkl1L3Iw?=
 =?utf-8?B?YjIzczlqcHF6VzMyaytrU2p2dnplN1g0NXBJZStsSVp6MjdDYjBVWlM3YTAr?=
 =?utf-8?B?SjdsbnIxdVBIL29CN1NWSFhkMTVsamZiSmVaS05SVU1PYXhoUERkU3VRZFJC?=
 =?utf-8?B?VE43ZTJvWHd3NzM0T2N1QVhLb20vbnJxaGVyYTBiN2JxcGRRRGpoYk9YN2E1?=
 =?utf-8?B?OG9nNDh1U3oyUkNKaG5ISUNVYkdmMUgwRE8wNnREVVFxVzV0b2VNVWt1c0oy?=
 =?utf-8?B?cStWQWJXd3RlU3dRZlc5OW82R1lHbjBXTjd0V2IydUw0L0thaUJvc0xjS3VY?=
 =?utf-8?B?ZGFseld6V2hmbVpCV1NKTSt0WE1WQ1YxQWxGMkhmL1FqNnMrUUQ0YkhjU0J3?=
 =?utf-8?B?OTN0cGRWZUg3L25CQkdUcTlETUtoTTAwMUVlc1hlL1N6KytiWWh6ZlFWaXZq?=
 =?utf-8?B?enVXYVRqcTFFTU9qWlpCQ2h0M3cxM0xUeG9saTN6S1ErTnl1eWhsenhXcFIr?=
 =?utf-8?B?L1UxeWJta3dMaEs1U2xkeXlNK3NKVWQrc3hWQm1xeWM4TytXYlhFOVdJNjdq?=
 =?utf-8?B?VXZoendsd2xzR0hXU2VvUXNnTHR5YTRTQytkQ0JRNm96Zk1xVXJsYVJDaS96?=
 =?utf-8?B?SmN4OFkzSUtQMkJDK0FJdWtQd3VBQnFYZWttWk9rN21Cb1ZCeldzbERSaHdo?=
 =?utf-8?B?emhoUCt6MDBKdEVEcURTOU9yTVdZaVBOVlBUQlNHVUl2aThXVHU0OHNEQVc4?=
 =?utf-8?Q?gxKR1Fe7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def36121-6be7-49ff-0540-08d8c27fac84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:48.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOpHB+IplHapjMvVPLA0WNbhzvUwJImePqZi36oWO2epliErMBFObg+NWjPuBKLyEoAJkjm1vRo1cDi0tWv+OVKsiFPQ7WcO6YrCjMerXmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Dec 2020 11:16:15 +0100 (CET), Julia Lawall wrote:

> NULL check before vfree is not needed.
> 
> Generated by: scripts/coccinelle/free/ifnullfree.cocci

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: megaraid: fix ifnullfree.cocci warnings
      https://git.kernel.org/mkp/scsi/c/12e3ef8b3e7c

-- 
Martin K. Petersen	Oracle Linux Engineering
