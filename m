Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB19CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F096117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhDPCwV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbhDPCwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oW39043730;
        Fri, 16 Apr 2021 02:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZFwFPlH7FlmbuV1117ZLqRfHbgoJTGE7pHybJaeKxGg=;
 b=MW+lFaxRonqkRYguFwU9Jqkted6EG/gQJamj605gbNdlSCGrXwvYoUatMV1zmurszlSw
 sfe00wMngfzzLPu/3w/e/dW+Mz1imecSY9XvLH2HSuy1SVWtm+PVwGlwSz0y2hFdSmN/
 wsw3dIqH40arDzp8e/G4EYYALlma5JTSq7vNIQM/tdApSnJQs/oMwMARkaoNpxhqYDzc
 fHiXkhuX22kJZNTXTg9EO+CjHzRrezCHd6ZKb6T9rn+RyDbpvwNb/nliKMZznEnZbkvQ
 WPri4qY1dXvH0TC0Mi1UxSK17x6yPNsr8pFjFJ4S5apenD9vl86twQzTxsmJ4rf1pdyJ Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnqp1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2no6C173409;
        Fri, 16 Apr 2021 02:51:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 37unx3twj9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLTjsE7a64/PvH6oskBzNklOFvGQ93fG0EcAmAJ6zOf3LxeQEHZlgdbR4zbzrGfh3ylKiwOkgaWzRcVbRzKxyv89bFWpMUms2DLm43xBMGPA5jYrblaN0Lu+jPD3nnlI9FdeWgqieZgtb71rO5OW57qBKZM0p1HKuoxNJK/ANu33Dy0iZgpMGHuUSPYMPuncscN6dQTT5rGxhyaQjh5an4IoiFD2R/nK5dUPnnugEvwtPovvyVzr6Hor8igsDoWN6uK2ZMqK2Unp+2kZhQoNZPMnjBjVXmh5FNFH64FI8EOWu0pBxQ2KGUxFYV/xMYq2VQnNtmfDb+zLm+owMvmvNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFwFPlH7FlmbuV1117ZLqRfHbgoJTGE7pHybJaeKxGg=;
 b=eBI2vguV8AVp43im+rCibwiOGEShnFJ4TgKL2F4rRkORzsw2u+eKlbcULc6aocFTnhRD1uOf4kRYn1YnguZhps+biSEZJGK5Pq3Jap60VTW6wxwVAiyten6IPEJu7MqPBn1NN1hJjDVld7oNXGEuNG2JWi2IQg2Y1Bi5EM9gsksgj+mXl9fclhYesiwR/PlrjI6oKX3lw7+1lJUrcqT7X93B8NIjLHeGO/Yh3Ihzyq+dEGm3lCDQgugkWh10Rszes8pdBrqv3xKcE0oYZlsMzwMt42yN6b/0U9gT5qTuNewpDr7+Vcu/Z2ai33zMWP/ci6+1k7xXOG6FkY7+0b7TYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFwFPlH7FlmbuV1117ZLqRfHbgoJTGE7pHybJaeKxGg=;
 b=hH6HfyYMhjkm1W/WF9g5svulGaMoiGR0xSWBwqyJhJO7TUSjp0HtkfCBmZUfC8sF/OmNJeIMbZ+HsKJwQEfYKDh6UUBvIGYdAxl+40a6CyKmfekhcrfDsy+GOQPZ68keM+8iRlbYkTkVceDp+djlMAYBtpoOzzzM1FvBFuaqkas=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Qiheng Lin <linqiheng@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: qla2xxx: remove unneeded if-null-free check
Date:   Thu, 15 Apr 2021 22:51:14 -0400
Message-Id: <161853823945.16006.892185272815878704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409120925.7122-1-linqiheng@huawei.com>
References: <20210409120925.7122-1-linqiheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 798e4e23-1fc3-4af4-f00a-08d900828d10
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5466EEB50925CE68E72C4A518E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9AAH4pQrr/iQVp8h1HimhFH9PLtaVf0wVW0liP2+wIbRH0BMNoKTw8Ejq198ir6nSfoOkqg0gkeblVB42wAbQZxh3JjJt5tdymjWY1GzFPA9/hGIdJec/Dv6wWEuFTdSzoKxvCGIJFaGL1B4CVP+QLU4VRXdMmppuR1ZY2ZMw2aW8oWdAHsgjK+dk8xMvx2WtpdWaGocprEzQ52u8SnScb4KTmmSIfk9Q91YTQWHoTunGOknmC9IUHsGOQlxKgfl8gUo1ghnSJqnl1/pIRs+r4Bc6rXZtQl/gbOnMGY7kCB0A5Wn8oH33KfEF6ghXtOnZSy5YnnzD4jTk+03KIZ1ypB7jIlqlf6UOmsWZ7t51OYZEYb9tEH5zBFwFLch+pwEUMCiahJrohIJ9GMWCIXUYS3Ui081lrB/KSLpXsbWWkfHaaHD7/Z0UkyJ9XJhxyVRQkuPKEy14Virs+rTTEbuzlTGpBMdGLqvCFMqviEWm7FCfuz792KgjR5kGquMFyptFMHG9N7pCLevDBZGI54EwrdXFQvbxKXOsNDgEpd6E7HwMLQUAkJX8sAQZDmzQw+zXFZmfGE9Zk7CdCIzpvayaGJ2VRz62bBQ3dzsyvE9PpxLdwKwelJTJZn4dIxK9TJ6u5y1Kdue7pyA36tHX+cW0BxHjn+MaORJFhxH9rbaiu/PO004z5rj9VgZ8uRd76Ex9fDN6qZ5iDkBd8zuW6V75yN049UfIPhRDrJ2Wg8lupY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(316002)(83380400001)(66476007)(186003)(6916009)(16526019)(66946007)(4744005)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WDFQeTMyL1FzenZUZGw0dDlrL0pSTC9Lc1JITU1WM2Nmak8rN1ZFK3hZS0gx?=
 =?utf-8?B?VmJiWmNQbnRVMGdyVkxmZkhtY3RMc29HRHZVaHNIWWVVQU9sY2IxVmZsaE5l?=
 =?utf-8?B?d3oyTndhZTR2dFFkRVJkbE5Xd2gzOWhBTHVzN2JZMVdlNlVIQktxZkp4WjZD?=
 =?utf-8?B?dlhLWU5FeDZsbndwMFlBK2s2YlJiUmNMVWQ0aXdBQ0VFWUpVN1lCRnFYVCt1?=
 =?utf-8?B?VXBTRzRBWGxBczE0amNXaDNxeG9NcHA2MW5iWE1tck5nMTErSTFPek4xdnBL?=
 =?utf-8?B?c1cxRVUwaURTeWFJY3NvYlpPR2oxVEZQWU53YnNDT2xRM3NITHFFT2lOblpq?=
 =?utf-8?B?YTlpalY2T3Z0RTlpQUxGbjAyN1dEeU40cGdJZS80WXBMb2hFZTBpTWxZbVlO?=
 =?utf-8?B?dXNya3VXNUlmMndrRlNMZDh4bTF3MVpodkhJQ3NDVk9uQkQyakJnTnZmY3dW?=
 =?utf-8?B?d2tseE5RcWRHWlQwRWF5ald1VSt6dFcxamUraVM5MkdLVStwbTlGVVVHbnk2?=
 =?utf-8?B?cTl6TXlMWnFodUlYQlJ2cWo0emNzZy81TW1aZEI1Um9la2Z6Y0dKUTFHOG0z?=
 =?utf-8?B?WjUrSUNPR3VuNkY4eUhEUDZuRHFKMlJyUkFiV1NMY1JmZlMwQWNSbm8yOWFI?=
 =?utf-8?B?TlpzV3BSQTEySEQxUnF3TU9NbUtwMW4xdklQRWZrQTAxcGpGTkxLWmVGVDFa?=
 =?utf-8?B?cG9mQUE2WnBCc3hHcm1RSnc4ZjVseFNOVHI0djRlazlsS3JPU0tpRmlpb3Nt?=
 =?utf-8?B?YXA1NzB0NkFPWWttZ2grYmZQbVZmcVhLc05oSEJxTWRBbkQ4TTFadDk0N0Zp?=
 =?utf-8?B?OXFVRFZ5MWhrbnkvRmdFNDc5TVFjbU05M1JaMGlCOGZLL1hMcGg4MlpCNDdT?=
 =?utf-8?B?UUJwRHpQQVJhOHA5OUVGdjJzanRKSEM4V2ZGdmt2dVZFMFl2Ymd3WHFHTk5E?=
 =?utf-8?B?S3pNSzBLRnVWUFJTcFNWeU9PTmpleGw2MGhEaFhjaXpMSEJVYmpzcjJpL3Jz?=
 =?utf-8?B?dEh3bDFKQnBTQXJKc3BYcy9XSm5hZHJyTlA3UlhpK240cjIyTmVGKzc1blVI?=
 =?utf-8?B?cVVQUnRsRHNzWFF0c2RMV3BST2lxU1VrM0JGbVhIblhJb0lWSXZTajhXcmx4?=
 =?utf-8?B?eWh6SEdEaDVadEtINHVxcDRxWVZWMW5aMk1qeFM4eFJKcjFVYVZCV1Vtc0JP?=
 =?utf-8?B?V2RsLzVMYVZVc0pCZUMrVjA3ZUFaaW1FY2FnY1QrMG1CQnlYMmgyVTNqZVN1?=
 =?utf-8?B?Q3hDUlBub0VzbnBkaTMyK0xCYXRBYW5veDJ1eXBwckZsaTZJVUJYTDVHUVY4?=
 =?utf-8?B?NTliZFArN3B3ZzVraGdsRmMrdHlnOEVlZDNQQWhaWHJIangyVTRYNHZidStL?=
 =?utf-8?B?R2RlODFYZHlBYW12N2NIbDNGbThjWFRYdzBlU0YwM29yK3Y2bnBEQmd6Nmxt?=
 =?utf-8?B?aHlHdm1NZnkwbEpYVkwraCtNRm12M0dYWGF6enBjSFQ1T3VuMFBzaGpTQUdI?=
 =?utf-8?B?VGs0UVpTOEhYZXVQSzNhNk9oQng4RW1nT0RRdFNyMnRmRTN1d2ZHZTZnR2tK?=
 =?utf-8?B?dVZjV3I1eHJPQVNrTVRsdjdwUU9PRE1YYk9Scll0NCtnQytCM0tsVXNMRldu?=
 =?utf-8?B?SG9xT3p1bWpITEJtTEZQUFhRRTYvWWtqM1RUcU9OWHBSaUYrakxFZ2c1QWpE?=
 =?utf-8?B?ekMzNmtIekd4M3JGd2lBNE9WRHEwUzF1OUdZUm5aNkNqd1V0OWUyemJqbnd4?=
 =?utf-8?Q?l6C1TOev6ipX0giSAuubIhqEWLIgLW5ij1gqQhj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798e4e23-1fc3-4af4-f00a-08d900828d10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:36.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6in51vGeycuDr8/FCO1+v7GxVLTW1gVB6utyKFqF3vUkvsFUw1rb+Si/iUThOhy3/spbQih2c37IpOQcC8uJY0zGBH+LsuEWooxnLIyB9XA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-ORIG-GUID: 2FTCQHJ-dtTda4J21YyN8QiRWlN4ronn
X-Proofpoint-GUID: 2FTCQHJ-dtTda4J21YyN8QiRWlN4ronn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 9 Apr 2021 20:09:25 +0800, Qiheng Lin wrote:

> Eliminate the following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_os.c:4622:2-7:
>  WARNING: NULL check before some freeing functions is not needed.
> drivers/scsi/qla2xxx/qla_os.c:4637:3-8:
>  WARNING: NULL check before some freeing functions is not needed.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qla2xxx: remove unneeded if-null-free check
      https://git.kernel.org/mkp/scsi/c/efd2617100d9

-- 
Martin K. Petersen	Oracle Linux Engineering
