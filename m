Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ACCC47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FECF60240
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFHDHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57846 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhFHDHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15835Y5k087760;
        Tue, 8 Jun 2021 03:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JQ4g2RoSIZybVC7HxQzBb7W6Wfn2Tmo7ek2fHyrh+ks=;
 b=AaLlBhcUxSVvpCus04Q6Q9UBps4kwkGoFHXI8EFNzwWXRwV9zQ5HTyABXlOHBkSQ1cCA
 TmnZ/XIh4kXSUE7RA5EiUpiyNGLhfdYDZqFkCWBI0RIJ1Q5JwQ1gQ70nNDzU0zvZMrU6
 L5jXvkhYNnAvE8Wz27J4IhwwYrwcnox1V8x2DByHQ78z3n1ZxFIjfrnqKdRBdulfCHFW
 6Q7Zh83oevltgmogcN9TwQ/hwvj66cY3KR0vkSpRfh12Uq8okWSxsybhlevxq5Il/kvu
 lV4RKL6hJg454BnqoVCf9fUi50aZMd9pr0/XM5w0IjOCNPJ1FrF/76HVtP9B5b+nkE2t tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3914quk3gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834pCW084953;
        Tue, 8 Jun 2021 03:05:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 38yyaahxw5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4wik/aMeHif9Gzb5jM1QNfaFdR186VDVLhkJvbtPbwvmLSa9HxJq2T/AR2VBUDtAaWJw44dWRmHJe9x9I6eBklWRiyQqzNcuwL/8BmXdQZbLpMRu5I3er5gjuMvVCSO0t/30jZYCV75z7fY019olyJ8pTMvAAxRGmvFsVqvgoU0b6x5TYnHOGlprRlPizraFTjw4P8J3ikFZZ30XMbqDYRALgM/uuX4LEogvbmXTPsFx9LHya+IoS55mJkwQvw2DD8kITLg2oyMT3mo6hgnDf+821MmRqPDXlV2ZBk7ynv2AqTtd6YFnrSER8h+rE6Gss/nalZOczRjfJZd7gWybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQ4g2RoSIZybVC7HxQzBb7W6Wfn2Tmo7ek2fHyrh+ks=;
 b=KfkrbXqBzIon+pXghoQ9PgRYr2LTi5EbQQTdPksWf1LL4X8BY/IgFCrTa8tZ3A5/Qj1EhPSjZnd/k+PGOm+6I4nfFGTb26MAlnUddkqGeGiK8x6FJxvcyhMOKALLydqQJcDjiTY8MCin3Bm70c89pGvZLWyDBlSNBcYhxJ4C8hvqnAXp1x77P2jzfACrlfCLQghOxJfTaphWKFauksRmZqCqFQkjKGHGxXaUA547T1ieU/+n4YAdN9nxpZ34HB8tpmu6Exg760gBiT8lCrN/xG6s2lTMDHQr6DwodewR6WuNHkjJVwetQI8HGU33/UaNqr1oufimG+HQ7ieoUQci3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQ4g2RoSIZybVC7HxQzBb7W6Wfn2Tmo7ek2fHyrh+ks=;
 b=wEmnjQso+dgfI8r3MEryG8WwLByGFy2I/MkQA6JGShwnRqCTGM86HhuTYxxnQhmrjustMFyRET3E1kAjVjwaU8uEnu0+KZC0dpgRR+ti5b3mpy5wY8b4m43YgNAkNM99mlMRoTkhC1mVp0IT2F8ddmVj5FBIhG5fmvaAcmmSenE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Fix fall-through warnings for Clang
Date:   Mon,  7 Jun 2021 23:05:21 -0400
Message-Id: <162312149256.23851.1213870190976778071.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528200828.GA39349@embeddedor>
References: <20210528200828.GA39349@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed960ee-dded-4602-fbcc-08d92a2a4757
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470662C4E8745459E9033C18E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/Pm4hvC4nBiL+Uy/J4bNR3YxiU4ASlQ0bLeOU3QyN/3JTsbT1zJHrz/nU0pIZmlZGLWq9TuYgJ0Oj8pi8YTQbBCTale4lQZ+y+ZPy2kBBan/283M75/estrqZEyL1Yxzy4m/QTXk9NWD40ea6BTH/IH9Se7hqD3pBNYJQtHCiIEDxuI2ATcogbEX0YSH00cLf+W3H6HZNx6x8tg7fOM/tVbdfsRJQcCxFjNpN8Um7h9iekFzlEQl3mMd6+kQaBjecAuz5yW0ucgI9ZNihh1WmqDfs7E3T9xavcZ5BELmlFYn0h+W20Eea7xgf6p9TMHaluxm+695pDIf5xeQN3DYcrz4I4tQJ8k0eHiziTSEr+7sbO9sZy5c6d1C/gpbfueKkytpUehLZo3k0HDefiskkbGJwiHvSL+lixl8y29cQKz4iEBNNJOdDropcpk/LGPmqeMn+b990ax2xbcZ+L/okMPEsp/CmWhsxSArEAG0B2ckT/Ti+ZPjkQf/9KZOJBKY/B/C92sAiGXDDm+w1Q9iT0dEwvy/ZKNp63keLpRor57A6bLgDS7hGyRWcJVXd0DTOlveN2jvnTXRXmVldHotZxy1lmQi24uaMvQrp+9QQVgCedoLtbWHr/wR2NWGvIREyPWV4TcNuZFup4IHfBXkOxRfrjlabmrPgWBTtFy3MlLKdEB2K6yMytF6Np0nfFVXYDMar9eBS/a5zm0lc2YfGHc6uV/QneV0o309jWxFsAoS53K9FSE7MZA4i2wl2Ko5BRe+6yn6MozZXR2QtpoHNmqAtLoqyVOOn0hnJvGuos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(110136005)(956004)(2616005)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXVHTmJJMHJYeEk1YlNHcnJ0SU9TWWc5dU9wbEFpdnFIT2t5NHJNQ2k4aVEx?=
 =?utf-8?B?MVBTOFE4N3pydXBhTlpCS0htSGphMkNyK0J2QTNDWVU0M1BPY2QwdEZYU2Yz?=
 =?utf-8?B?ZVl4aFVlOElYRmk2bHlqZ3l2NFlLM3ZuY2lSUTVsQktRS0RvcHBUS1o0SG5r?=
 =?utf-8?B?OEF4ZDZ0ckI1OFhhamo5eHhNaEwwZXozZkZ2eWw0VnlvSmdsZE1zNXlTdlR2?=
 =?utf-8?B?Yk1PNmV1K1VLUzVYMjZkeUZqcEZXS0QvQmxBVytNQ3ZKVnFJV3RyYmg5QlhS?=
 =?utf-8?B?N09WRnplQzRNWG5FMWh2c1ljV0kwWW1ncDJBdnBWNUdTZk5BdERGNkVjeWRr?=
 =?utf-8?B?aGFERWFkT1RUZDdFN3Y5S0FUdExsRFZsbjg1WWoyVVk5NWxqMFlubUVXN3du?=
 =?utf-8?B?MExFdDMvYkVZamxoQkdHUzBoZldXK25iNUNoS1dxRUdaSFphVFN4YkVSVjE5?=
 =?utf-8?B?elgxNmJzRk13RUNwU3pWTHBmeDYvWityWGVKR3duRU9aci9KcUpKcDlWMlBu?=
 =?utf-8?B?a1U1YVVaTGFxT3NoUS80UmZpak5DNlVDbnVQU0JRdHZGR2dFTjREQmJPaFhX?=
 =?utf-8?B?L3hWUmRjVkJKbW5yYVA3anc4TTF0Rmg4enhFTHdTS09aYzR6cE94Y1lTZkVV?=
 =?utf-8?B?bG13TExza2V5K2c5RUVwanhSZmdkbllvaEpJM2FmbFppOEExQnpuTU5hVWdF?=
 =?utf-8?B?ZlJXYllNQTVRS2QxQUxLNFZSVUFwWDAwVExpdEQ2eGFBYUhKMk1IbUJqU0pu?=
 =?utf-8?B?aXd3R2xYMmJzZGtKV0V0QXJWbzJlNDZlT1QrZ2pkbmJxVmMvaTRmYkxGNTV2?=
 =?utf-8?B?UFExU1RyYmtlaUdwQUtwRXphQXJqdmhaanZHbUlydmZ2VmpBYVkybVpMek5y?=
 =?utf-8?B?S3RwNWVEWnN2YWNzS1ZpU3JVeHhHYkE5Y2tQam11NWJxVHQzeWkzMnJxMmxG?=
 =?utf-8?B?UDR3ajVhMHNBM2ltZEtac3dLRlR2MjF2b3lONkFXRXhaZ1A5UmZJdDJMSnRP?=
 =?utf-8?B?ejJGV29xYmsrQUhPT1o2NnN4TlZVMmhXNHFBSEEralVTSzB2ZG5pcFZYTE1J?=
 =?utf-8?B?bGVmQjhIQ2hIc3pwcE8wWkp2aktEZzd3L1YyUFVmRTU1czY2MkxvN21tM29t?=
 =?utf-8?B?YmpzNzNvc0dRNUVUOUUxSnBMYm11OEZmLytuaGR6MTNYaGd6ZzNBd0FvdEtD?=
 =?utf-8?B?eGl5TzJEQUdVREJVdFJiQXJwUWY4a2Nvd3B2SGQvaFNGZnNtWExYb0plK0hW?=
 =?utf-8?B?Mmx0dDN4cGJwOGdsamw0YTV3QmY3Wjh6RmlVcm9INCtaLzBuTkpLUG80NFdi?=
 =?utf-8?B?MmVkMWxBeHVwQ1ZqSUMxSFU0K1hmVWs3MEttUVovYjM2SmkwYzFRV0ZBL1BD?=
 =?utf-8?B?MTdQK2Y4RXo3UnZZY0JxQS8xZ0k0MFJlRk4zQjJUSXNJQlBtQUt6dDgzMkVy?=
 =?utf-8?B?Z2ZBbDc5amhUVWJHU1M4elpiYUltR3hXQ2ZVVy95aVJPeGhwRzJlMEc3ZnJR?=
 =?utf-8?B?UitGaDlDYStkcnFvL2o5ZXZDWWdLR0NtUWt5bU5EdFFmVmJ1Ty9qd0ZJYml1?=
 =?utf-8?B?Q0txc0Ywc1dFTlRXVlJWY2dZU3p4dTBxYUNPZFdkRGwyWHl1bEdEazQzK3VM?=
 =?utf-8?B?aHppN3FKNkVoUUh4R1RSeEd4TG1VSFFDSk82bzlSNFZ0SDRLYjBtVm80Z0R3?=
 =?utf-8?B?ZmFSNlJkeVdqbkxML2RobWx3UU1PMVgzcm5jRHkvS0lFMW1kdVVmRnhQNjVV?=
 =?utf-8?Q?BZIXUlFIP7QMuuz/bFfL93fqZrEZ5MF5lxOMPyK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed960ee-dded-4602-fbcc-08d92a2a4757
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:32.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +FhgKFyTh9Obi7sURP69oDAo4gMSU03UxBwVDUOdpLv/C1lofIjCQUcRR6zqfSGiRmXYtz/V0AOtVtPO+LXgLuMO/J8l6iRwRaioTyBHOq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
X-Proofpoint-ORIG-GUID: VPmhErK5dqpIBPwFI7-29d5Lq_L0tjzV
X-Proofpoint-GUID: VPmhErK5dqpIBPwFI7-29d5Lq_L0tjzV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 May 2021 15:08:28 -0500, Gustavo A. R. Silva wrote:

> In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
> of warnings by explicitly adding break statements instead of just letting
> the code fall through to the next case.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix fall-through warnings for Clang
      https://git.kernel.org/mkp/scsi/c/84a84cc6aff4

-- 
Martin K. Petersen	Oracle Linux Engineering
