Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B3CC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B0DE6101D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhHJDZZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:25:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4370 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232741AbhHJDZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:25:24 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3C95o008719;
        Tue, 10 Aug 2021 03:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=D2NiHjO7tuZOky51Wf0TrBJOUqFv/x1FFJ8pgGoXujK5AWsATaLQSox1bAnW43yqLyNx
 pxLaZ656+RAvbvTBRhr/mv32nNS9TPo3vKdabujL2ygyYU/mfsifH9J/v2B/4VszEIei
 PpoRlwnw/yygFceZqG5kX0AqKS5fsf7Qs/GuczCnE0t7KTb8XsqWzV3Gw4sS2Lrt2NAe
 yEkciJjuHVoNrev2/9t9nGGXCbELocMaJm0UFX1eRMK9NsScjZKIEEZcKaH7gqzv2ik7
 TbVMGpfzzn8Ym1QuivZbRHIdtdSdsEReE/TOT7KQUBBc4Pf4kdTeFh2NVx+udITh2O/S +g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=Fc+qLZB3MWjg4fvy5DMx+4XADCiWAjvgEk4a7uf/Vm29glY0zRJyVnUbcUL2MgIDSicH
 ForJlhPjpPFifgUak4j3+LzVUoodTIcLiHtx4K6MTZ7vvJR0jeqQSb6ulAl65anD9901
 UPsA4ebxKsZViErim2vLKc6V6w53xPASg+bLrSqmox2Ayb6jMFtSHXQUE2uXZpgky/Co
 t2pzzi9YQjqrfAneoY8FSwuCfwZ+F1KSqML7AsrodNarE5Y1CnzdBHgHFgtSGp18t6rL
 u8/NyZfPHTPb4cyvynqwlZjvDfIkLlSeiuEYWRVbBccnOHZGza/mEW8qKT/F+Ps0QF0o jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fth7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:24:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3A8Xn085113;
        Tue, 10 Aug 2021 03:24:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 3a9f9w37gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSc+YKdg44rlcRqSfqy0S2ZzUKsbcDapu3s0PZ8QQhL028Hatd7B6I4HVxZMnMozP6gkt+l36PgXWljzo7OQkwdY2SXS2XRnrNO3Zy90jvW3jfm7CEMMLHUV6+CgOkB3bAlr4ROdZcie5huWb/Dx2rX/BJhy36tYrFbZCrregj/ZcB5nK1qEcJW3HcEvKuQdLCtvgLPSYuVY5VIQPeYBFCXuZAhVohHslAaDesMPIZ3cHfMkZksxenF/4bPD4dNr1pJiHEEpLS7Ihgr2hguPee/2Bej+Djj7y8WNZt9Y8N3Es8mHOwuPuSfHVtd0VCA0vdurpxNEFLgLoGjyktpVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=LL0YdWoVj3YngJCz6ZMgY5Q6y1qKOpt1Ksz1/je59dXzzfjwyrh9HNDIDkjFXzx8MgWcprHzlPQgiSDQdinWUrBAhgLEDg1WCJP6doQH477OipcqCXUbScnVRWlUOtH780JHK7205P5+rClYp0D/RTxvMc2AcMAjAvLv6tLbPYdnmOEcu7cQGAAQslX/wpd1U6nTGBoI3G65/RcAa41BGWTU2yykScQDh+KoyVVtga1UczFr6jmh62aN4fiZbqe6vPPNRoDu5QZ6/ZJ9CZcw3QtAdV66qfX9iIGNeorNG11ktBt9ctVBgnKw5O6RvciCXbzD9BdSzEmVJH4vU2Hf3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoSIQiBjJr6Qoqq5TcAx9HLnZUaHMZ+jxwmkKG6oG18=;
 b=X5ItaiNPrEoMjueLmbg4jbRpGZvfWSBl0AfLyQIpf5DG23X+MtCH1XEVlSb8W5kH/dOeugsqKm5pTLH58lKP53cAfLcPyoVRqI4hKFh4jBPHBB2kNlR8QhXJ6pPX9j/7mbXiFxzrNg6230aKgOuPazI0ptPJSYysQjMgGN2oCRc=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 03:24:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:24:55 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Remove redundant assignment to variable ret
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eeb2vv5w.fsf@ca-mkp.ca.oracle.com>
References: <20210806112313.12434-1-colin.king@canonical.com>
Date:   Mon, 09 Aug 2021 23:24:52 -0400
In-Reply-To: <20210806112313.12434-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 6 Aug 2021 12:23:13 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9P223CA0004.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 03:24:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4c02583-e4b9-46ea-e172-08d95bae6c9a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54193917D45E2DC38320AAB38EF79@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWuE2vfAC0pTir9Q0ePHM+N4yGrS8gkM/dYap8mj98Q8rTXdUqcgN8b5jx+9YfP8ON+2+W3FgwJb0i1rn71XsDoVK+JLU8blI1tLzJeRjW6L4RRAXQVdXl/mrxV/AuZX0nAuTiof4fus5tHSKuQsYtdwcaC5BUiHoLga0ahETww2RSGqrudjhHUFOtQyAPt/uxG5NrtoMIu0uxLxl2YlIBIDEng4eJTKhacINcHH5xMTP14a6VS5NN9ovgu4psTOeRgyFveLCev9H5xRFzkzmzAhSb1Zmb65Eypd3o4GxCeWMVXjVZwychbHIZ8Y3Dib80DpSi4fGD5y/PiqC8MhbzcMwin+twy0JKvG5gEDUWpRitTD5U+8jSjyVRjaNdqHKnrVx/Npyl/2rA1pbzQsvbKea9bp8zMtuBjXl4kYK47H5cAhzSngucv8qNMcaStF6J/zPGSSgDILCRdK1TFqsPFqRAzPdLPu5Fhu7zbx2WnHq+tlNBuXXaQcYXKD/dGFMCw6OpneV5bTe4wfQqWsGGmR84+AfJaQFzk213NxlOFoL4ev1kHKQ8e0LfyeDMFN7WXdTly3b/+b0L1ICGbIzUC2lvb55jPbAcDWjk3Od/APhdequSrFAj2VdUte1hzxSOAQS0qMT43HX2w9wRjTec8hGZH/s1CKJISIuIuK9hCfeEH+KKmJPaqp3uH/2mverqiXI0MCJ612/nRZrUz9Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(26005)(186003)(66556008)(66476007)(54906003)(5660300002)(66946007)(4326008)(52116002)(7696005)(36916002)(316002)(956004)(2906002)(38100700002)(86362001)(55016002)(6916009)(8676002)(478600001)(38350700002)(6666004)(558084003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5zKgCd3h7ymCbR/U098sETznOpHgHLAy8Sg/PgB+8R6y/qq+S5hEU9rFQg6?=
 =?us-ascii?Q?0ganD2UTKcgk4LaWvPeBnmOdEQqmIg49fl0b77BRMi9iwPaEC3L6qcidgP3P?=
 =?us-ascii?Q?/OQmrzgLGQBCRKBBQ5YxoBSaz21UpN/Yvg2ULxqHIgar9HcgudL4KTX/G52a?=
 =?us-ascii?Q?Z+V4UH5QZTNieuoI4SmC4KwncR2D5t0uu9sm4jyOLxusv9nQ2qzBebH+l5AP?=
 =?us-ascii?Q?Kf4PsgtDAZuSInHNWApq1Rj4lXjJaJMrSUmuc42eAFnvX0/9NHADHVv9rt1R?=
 =?us-ascii?Q?2OKh2N6crDeU9CLFemiNZkh1vPqlpABph/zsk6TerTi6Tq81pPmB5qJ978EN?=
 =?us-ascii?Q?YopLn+ozhQEoiKhOKo51fTakC7fsLpBjBHfQ0XITQv3Pi61luZHCfAQ9BNTK?=
 =?us-ascii?Q?A4xblrhOt7C5sEeXmNPYRwNHbuo/qS10sVGVAZcxiQswUvS/QauLr47yC0Zl?=
 =?us-ascii?Q?3kB3zHNrKDFJ3ekcHo8m+MbV4XzsNUQ4vT9ZjkVhvI8STlPisTMjNUUJslbq?=
 =?us-ascii?Q?uiRxCVzga7S0uHw1XAw2fkBj/hmfcb7WdTx8ETGhIbP8JlcvHNDy7S9I+Y6r?=
 =?us-ascii?Q?FYQisz4vAZuw2f88jSZ+SFLuzkqt+gaNaNV5uLzbKsrTHjIqnJCcX7hNMXoe?=
 =?us-ascii?Q?ieuFm8W2yZZwuwoTw5PuxCJZSttShl3NNCvxMgYR8pWuoq9nGYKoSg+xx/wj?=
 =?us-ascii?Q?eCM+Gop2JejOhtQH28GuxwGQOHa5LXMD79+uP5Q7w7vlESC3s4l/oSebrtap?=
 =?us-ascii?Q?0th9M9l26mjx20MhqeITjxpVZMxlKUXGH1qja70k0ldYdRIxQIfjOU3PzKRj?=
 =?us-ascii?Q?OwKD+IQ3YJyz0MntoQI1+4z+5jiUusIoS8/0QIggr473LcYPx3FwUeGXHAHj?=
 =?us-ascii?Q?XD9sD8d2uALBSzlackqaUC0Nr+Em2H2edOHLivo11hp4p0rnmKBzlXoQ6KM4?=
 =?us-ascii?Q?2AYOUIJmKguBl+unFt590fRPsWFchs/ZRBB4qfu2jerzLuxlT65eiwfMEEDJ?=
 =?us-ascii?Q?vMeBZROL8wcZl07CBPfXK9RGkcmaq2paIaLkvruPb8kXixcz8FIGvIeU9ZWS?=
 =?us-ascii?Q?RHMuGKF+rtAH0/+XfbNtkfpKwPJcAy9ZWn4DZLjTnonhjGFasXH1ewCgvSQn?=
 =?us-ascii?Q?TQW4ZhNtI2BR047EOrkBDznqazB/R8Bzeacm83UqKO95ens04/23UqyF95yL?=
 =?us-ascii?Q?B3U8p6sY/TlYUTDD+DSphZk9A0JNfhzcoRBjAdVgRzzbIk/ThFZfE5Zv2VYc?=
 =?us-ascii?Q?KweK9/9FbLu+OhLsWmyGqePtjq4GaBwtJ/h+7chfeTGlhHvW4g54Q206Al6c?=
 =?us-ascii?Q?ORuf4HYcZJE71nNpm40re/Y4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c02583-e4b9-46ea-e172-08d95bae6c9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:24:55.5924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FILN1ew8WBg5uWduF/Jh0BWxPnvW+3XHNKOEXn5a7UDXLTql1wli9NK1CgSWkbP7VOUQEcSqdbV8Q49kQb7JM/XqJqPy8y1Dm3fw4gXzcUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100019
X-Proofpoint-ORIG-GUID: KeuiHbZhMdbn89diK5YU4_IYGy27VlmS
X-Proofpoint-GUID: KeuiHbZhMdbn89diK5YU4_IYGy27VlmS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable ret is being initialized with a value that is never read,
> the assignment is redundant and can be removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
