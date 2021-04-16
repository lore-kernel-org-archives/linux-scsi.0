Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA34C43462
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6635F610FB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbhDPCwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbhDPCwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2pc52048351;
        Fri, 16 Apr 2021 02:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XG9r9/5GAVlJO4XkfuaorN4HEhvt44zGSxgtAuKtrxs=;
 b=VYboNCV1rHzxqJwxI+/OTeG3yEywMmWj7irF/rjrwj5MwYyzJ7SqZr+N8nv65TR94wsG
 FfXQYTIZjyNcCAuniTy7PqRXwp8hDQ+sGzCtfZ6fEZ9S/do+AIQwHuig71aSpBy4XXNm
 xuDlW2k/Vz+P5kkzuSw4VARK2/iOqUjp7TsOXX4UKfz0uL/ImMrnZYCyAAAL4Ll4mP2R
 QW1rmM2FpsVlEe0o/M4Vn44uyHB+zLNHFPOQVx7XvaeiaiaORHtVKzDF9werKGE8wHsH
 7MqQF52Y7sfPn+bj0q/3QVpoADsR1ySqtk5tgIFbhoG/su4QGWG7n7Wif8ZlmkogOtcN Pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oeFi162577;
        Fri, 16 Apr 2021 02:51:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 37unktgk4m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vb1X2qWjRVbgdiu8K//NySFbMnqnHONP2TGkOzE4uR5YTnHs4ykaXSJ5Q+6Ml7+BhwQ76La9K2ZRGoKoHzkE00fkrTYuDyu+nvLRoD/C4fR/RytOLtkQzPXFgnjhHtO1/FrB7W7IvBKuJrb1Jl72VFvGl8RY0kE6WG1En1v4kgWu2PHDS/YPkP3CEFzOquSSS1xzRtv5Y8jQ+9VjR8nZT8WOWJflgKvz3aw1HQZZ/xzzuQQO24hnGcXJ9Wkvk6Zc2IGOmkUlMzfTh2MLcU5VRdLPk54Appil6qEnttRC6ZnXXzyP/Jp5TFbhOxPmkOEKR3K8S14MZ38ZyWggUdK0aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XG9r9/5GAVlJO4XkfuaorN4HEhvt44zGSxgtAuKtrxs=;
 b=T4d8CmgphBWpr8q0QZ2A6PvyBFIDzRCWnSGimv7on0kDexpd0sCPqPPHWdtLaHrTm0/COF3Zk/ntPYCLowfSTBy94XniUiX67qGaaB8gKjbpNSjEUC63qm2wuDiL3Yu2JwA0jpRUGJHPYAnGf+Rqr7SU8FBjBoS3rodq0r9yGgWNmunRjUwb01Z/2vlfyQSQ8GZi9Syp37laWQ6x2VRnGmBH4uH4efx5yjFf5aufRZTa8b3bzsqcJjFBFkZ5iH557O58mrxzEo8DQ0jKeeEgCrC5/jSiqT+/VALr5RG8BzF7ss1BacvqKgQ301J7YheuCXnCjWU9ZMNp6LmuYsV/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XG9r9/5GAVlJO4XkfuaorN4HEhvt44zGSxgtAuKtrxs=;
 b=Vd7yzKjUPXrGZkNBshs6tS15a0KJzi71udM1UFEgdvFed+R2OQSutm3srjJxuF6XfEiVX9+jAfS7dM3OPOnI19d8gwVuZVshP0ZXQ4fpV/vJZAT4o3347gl/oGY+miQPXFsuUoUDz6tZa8lsd7SuO0SkNHgRYyBhPdQYCIaY9Yc=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, dingsenjie@163.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 15 Apr 2021 22:51:07 -0400
Message-Id: <161853823944.16006.18198051253732167029.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331065326.18804-1-dingsenjie@163.com>
References: <20210331065326.18804-1-dingsenjie@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c34d6cc-c4c7-4d46-b305-08d9008288c1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45682DCDD7C0B47463CBA1F08E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwN99YdK2T0luEuPcVnU8tktCM5UZsOoKTDxUy1Yu+jnGphPhpTgo8pv6BJcQByjp/jNQQEXjpkvF6PTWnOZSmPiFupsX/i87mIz7r9Ddzi3Pxlnmw0VEyoun0/yCRskGjgWjmMooNmySEdUEJzvNovA/SgyDqgKBuUWDNEur7htuKdaAzmEDmSPfV3u+DUyFbG6eeD/GWe+/wUG2xCRu6TnIp0iIfNlBmnIX9orAF9uab3BOW9DPF9efWnYZhYNRwul/mf8KOlETv0fS3qml9Nr1sK8FWquQgoWpGlF0+tC3PlQnHC1DQioCm90Vcww7+gAt5OMII+TMYu7aSNHYzb4FHENyw0pLZMeQTXJTke1EsqDqpwBdeF6lpp6ZM8QdKEzOHY2itGHGvNYnuA4ShUzagrbbJiFUn3KJaFY+EDjjgXcCtqLjkEKapzAHWmptoLOG7ZXGgLtrHLFtANH3ITXbFGCSE2r2LknracxsA3uPv3AidmFmndyEWFxEFj4KPY5fdb3qPlrNbIdpw/T5KqrfRGH3aI0c8EO+XS1hrltLryaIgni3tflBQh8kYc91qfXCeV8W/5BYmHiyLKni2PfAosccuK3DCqqcnTsYcOAz5ZbOrbQOT3NS+cI5sKxeXAz6gKBVRizermIDs787epx0Oe1OAQSWOls1Tr13J+kcr68sG9139dAhYgm1bWq9Uqn5nnJrIO9TR196lbX0mUAYte2DZtXqptQtb7zUz0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(54906003)(2616005)(956004)(8936002)(16526019)(66946007)(66556008)(558084003)(66476007)(86362001)(4326008)(8676002)(186003)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cFJhdUlkQjZKNDlJNXJ2N1VMNmJxRSt1QmM0QlBEcE1tYXpZNk1EMnY3VEpz?=
 =?utf-8?B?TXBpVXdEcm5VdURMSEh0MnZMbmd6OGsxZXB1NW5XSWJST3FXbkw5bGR6d3Zw?=
 =?utf-8?B?eStnWXRuRjJ3SWR0MUZWV1hSRnNpVndzZU1uV1JJN0ljMzFXYTRpd0YrNGF1?=
 =?utf-8?B?WHo3aDlxb3ZUMGRVSzlXb3JIYmN3MlJINFlVVjNPa1Y4RGpxUFNQdmFPRTdO?=
 =?utf-8?B?dStHOUlwNDBwcStjU3E3Zlk2WUp0cGtNYTlyY0c3Z3Z6aDd2aVl2bDIzVlB5?=
 =?utf-8?B?dFZ2bHluU2xuVjR5dmJ1TG9DOFFGTFY1UXhsUm5QZ3grVmg4L1FwMHllRDJX?=
 =?utf-8?B?S0p3ZDhYRkVaL3B2SWhkcWZjYmcveDNSRFhOdmdIci9yRHdxNHZ1NjRBanRk?=
 =?utf-8?B?Vm8vVGwyVEVoNzRFdWdhL04wMFFSU2FsSUx4TGs3WTEwMWE0MUVHYkFIZ1RW?=
 =?utf-8?B?RVorME1jK0VwQjcvd0VqQ1NRK0xoNVAyNkozWTdOQXc4T2UwbVRUcEphN0xk?=
 =?utf-8?B?YVhzSnRWWXVUV00rb2V1a3lILzFQNDU5Q0RWMDZ1V1RuNVRGWmwwMTFQclMy?=
 =?utf-8?B?WUNsT1JFcG5RUkRhY3BWSVh2L0VOVGxUc2xZVFpVNEZEQlhmVXRRcHBrQ0Nr?=
 =?utf-8?B?UFFxNUF0U2pJbU5DOXMyeHdSVDB5NldIZzF4WFpEQStQZzdydzMzTWdmTENS?=
 =?utf-8?B?Qnc5ZnpSMHJJVUZROGcwSHpxZDNSVGZnUEhtQ1NjVjhUS2xUQWNzK1dZMmdh?=
 =?utf-8?B?WmhQR1dxNVNXQzNpL3NwWGMvK1lid0ZJNHFWTTJJYjB2UEc3Z2tDanRYeXNw?=
 =?utf-8?B?bCtNeTBua0VEZS9INGlHQmdmOFJIVUFZR2NmQUhPOWpLN0tNMTNoLzRNcFVj?=
 =?utf-8?B?WkQ0QXFWcnQ3UlcvcGs0SGdLQVp3ZUlUSEtveUJLbFdOSHpqTHJRaDR3NHBF?=
 =?utf-8?B?STBoZ1dZa1VZbFBuVGlOdHlPRnlXWFFtemtMME5EY05naGtwL2ZYS0xZL3NY?=
 =?utf-8?B?Ymc2QjhENEZlZ0xoRFBiblJsYzgwdzhSbWwxdmRFK1NBdFdMbDBEanJQK0JK?=
 =?utf-8?B?ZzZlVEZzNmVjQlZQTHZXOFlHdmlOKzUrWkZuS0ltR2lxTmNvelFEOHZXd2kr?=
 =?utf-8?B?L1lCcmIxeEVVNFFhVTBHYnVrL3ZjeFl4SXNIcEtSK3AvUG00VjBMR2JiUE5Y?=
 =?utf-8?B?YmV2V0xpRUhBaXFXQmw1dFNnajd5bEFXQkpEVmEyT2JrY1V0bllyTFFCSVVh?=
 =?utf-8?B?VTlaeWNDQVFyM0RBbHg4dDZxRFJWaFRmSnB4NjVhd3ZmcXVmWmY2MkdIT1pT?=
 =?utf-8?B?MEdOYzBsdFl2M09zNlVpZnNUM0t2Y2dlT2hMcVRaLzhBQnZrRS9yRVY4Qjdt?=
 =?utf-8?B?OFVxTEdkdS9Rd0grbTQ1bVFXQVM0Ui9WVjNZV2tGM1I4OGxCQjlqVHYwTUpM?=
 =?utf-8?B?dnFuMW9pU0NTWjZLbDAxdk9qT2dBcE1NWnFCZHpyaXZ5WGlwZ0RhNE9qTWJp?=
 =?utf-8?B?VWFKSEg3SGcxM3ZJY3pyaGxkY0tCL2ZJdWRiOHJJb2kzWU1kWWdZMFM1SFQv?=
 =?utf-8?B?SVIrL2d5ODIvMnlOSUpxRCs5OTJjWHlNdjNnU2Ywd05qSnRoNjlFRFoxQTYw?=
 =?utf-8?B?eU1GSmtwMjVSY2pZQ1ptWFM5akRSdVNiMWlROVlwdXhtUnVpOXVLZnZIVE9y?=
 =?utf-8?B?OEdncnVyMHBoM25sMXBXYkNkRFM1WFNmSCtLc05KYW44cDRUV1VNOTFGdUQ0?=
 =?utf-8?Q?SV9u8axZV5f6tY30CPl+Er70NJUBIJR1TvlQ9sz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c34d6cc-c4c7-4d46-b305-08d9008288c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:29.1562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v0jGzecS/Er0PORjIzkhzjFaPW/6wUyFtzGhgjmJBBzQG4RY4BRslBEldgJOZJXVJLXYzDrB+Z0t/P6EeVbvyxJ7b54oo7uGGIE46lNyks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: IHQXIIXycVGmZqBNV6chUS_xnyelctGU
X-Proofpoint-ORIG-GUID: IHQXIIXycVGmZqBNV6chUS_xnyelctGU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2021 14:53:25 +0800, dingsenjie@163.com wrote:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: snic: Convert to DEFINE_SHOW_ATTRIBUTE
      https://git.kernel.org/mkp/scsi/c/54300bfd738b

-- 
Martin K. Petersen	Oracle Linux Engineering
