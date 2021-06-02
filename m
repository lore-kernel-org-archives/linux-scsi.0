Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB87C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28D561361
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFBFrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:47:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFBFrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 01:47:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525fOQB176971;
        Wed, 2 Jun 2021 05:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vCh3fZBmIFLJ6U3Mqd9lzC8iId/8qOYPbj992WNafCw=;
 b=Ja5kpJpkCeRv1es/VXARtoby7530xEnmleNA0pVyiKxCqhKJ1Y8HkhwqWump0UrkT7Zt
 OEh5HWGoXLZBxhXODZFBNu4MuY3oLP0ERl3bDFC6u7FTDVuAM1wFp1nyhuZ5WBTqjpVL
 XGZyKP/emXyef5njC8tcEXQJaW+lDc+/mgAxaRK5kEUjIygCVNXXNgNmuRw0+1LHqQvU
 uJRdYJrHmpflJ7DeAVOpxuNNyJ+aXzeAPugJ/xYKhmZe35iRLbPM35J8lPo69WBoGCHw
 ju+5n2lqhhcM3cyQmh19opD7UFml2ePXImwYYwpFY7E1ixo49STWrqDaP3ZcfRn+SnWR Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38ub4cqf6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525eb3E069828;
        Wed, 2 Jun 2021 05:45:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 38x1bck5bk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nS7it6v/hIUrPUAjRHYeupXZnbKPDwKDvStnzO5ZYSdpMAFDZjlDvUPr3zOINIY0EddSz7esYHVvJ27X6o2YnN/UgE7eLaF1Dldj8fteQcJlnlHXQaoSpUvPg2cyakOBQHnqv4AP216PiYbp5PEA8Yg/E0mVZNhO3lZ3+ZW5L5sa22qufTBrS3lKNHca8GoSpOFlmfqHCTY+Jqx3pGnGUL3w0jDRM06ASqUHEDTO0GzpJwrR4P8cXUUaG9byRUXp+z7djKcRuJBzmof/UisghnL3Zvls29jxllWPWSD7Ynpq6IA9ZMHTjTH2+6lCM1CLOaqK8tXO1zDiNySYW+x9oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCh3fZBmIFLJ6U3Mqd9lzC8iId/8qOYPbj992WNafCw=;
 b=V1r/cbkQh0rmhF/fWrakns0jSaGWzabSxCNwujYhRx/P4MvvnF4kEQFXwKWSsv9L/pVxePF9bNikh4xOWTHMcUFbMRj5bR1Mr+EcoX0i7GZ/Sk2UGHIIKPMnPm1HgeB3c304gWqvMgTNSMLrcl4RpiatGWQVGU4+KJKSQD+fC8ONvpuvfhCrUrb4KKWHPPkhU/t9rGnhhgU1GMEjsvTtTlhM53C2QAMEYK26SDy8XLSM+j4nZTc41s8ZjM5UlMz3Rn5M7zZRndhj2HR+Tnu01Zdwi1ax2ShKMADXaQjPqK7e+IgevybSDZJprlbLW3StrDxR3rms+gQh1pbO2JHntQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCh3fZBmIFLJ6U3Mqd9lzC8iId/8qOYPbj992WNafCw=;
 b=tHbR7acmQ2QvhbHassRly0aUqRqiDf5fVYdkV95hZoA46NcpGmFDJ3jt8ErfIEQOO6aOlaDfDQPyFzEo2GaLIyej+bYuZKhyDb/4E+RpJO4ULyljDi1clom8EkZgqpkeg7qLjg8sV9i26wegD/wnXwHP665NA3+lmbDZ0zSXgYw=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 05:45:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:45:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com, alice.chao@mediatek.com,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, chaotian.jing@mediatek.com,
        powen.kao@mediatek.com, jonathan.hsu@mediatek.com
Subject: Re: [PATCH v2] scsi: ufs-mediatek: Fix HCI version in some platforms
Date:   Wed,  2 Jun 2021 01:45:21 -0400
Message-Id: <162261189570.29465.5342351281266203996.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531062642.12642-1-stanley.chu@mediatek.com>
References: <20210531062642.12642-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0033.namprd13.prod.outlook.com (2603:10b6:806:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend Transport; Wed, 2 Jun 2021 05:45:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e4dce2c-2375-4e8f-97fc-08d92589a140
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5418053D73E7268A792F129A8E3D9@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSApuvxCA0GE7/RC9rHsoVx0eUh7unigfU/eAGVXhhUWyxneykO2Y6sDECGGTLJGjQL/4IuRZoKrfhmVHDqWklRGDkwN10P0Jdm0+jJmLyeGpJInP2Y3+OXjtwsfl/gvUW0+saqBnUa9JbVdjh/pHJ/a4Z75uwcOJxA/sXoMeg8GoZJ6XaDEjEUJ5P9JkpCwIJskqolnm2+xtprqDvb4BaB1frp4dSS/G+W29ZScdkiZAkFJcS9zJq9/iJcxASGn/FCB8bzrBZWv8LF1JoqeFZv858h/NrrxX0EeX80FQNIA9l+jhOF27MNxZuq69UOTPJ11FXoZWEuuK3extnz5u7I0WzVF/W5smcKqn+uB81aoUnhnC0FrgdboUkYNLUk7EcgBaUB7H0/kqOZ5CpbUekHjk05zyr+WdxokVbrKYmcLJ0nd3x9tV2Srt88lOdOJKBV8CeAYo6WwApxRV4JbQR6xrx9ZkBAg5EATxsa1aLKJ1lT2TqKEdHBv6yGq/CfM+4VrfCBHtzpL40GFeF+yk5pTGgqieX514zLoKp/0yX4HJK6vwBQDiD6N3E3hs9X8GQ85/CXMrvswe46kHmmjrqA9zAgKG3pluNozoGsLcqiETVDSxQge8qOXWdEGCBMiZNpnNQ2NVFKgf2oAwFTSOKCVF69BU2cbCLJpKYbbt4XGaHR54Rl3WA33LkidTlfV9N7rFTdqGyr4CU5Au0TeTMSatgx6qTZP6yer4naRfdjx6sbMXWEjPRcR3Mvr/GOg7AmDTvUi2dwJer+LYf2rFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(956004)(2616005)(6916009)(8676002)(966005)(478600001)(316002)(6486002)(86362001)(6666004)(4326008)(7416002)(38100700002)(38350700002)(7696005)(52116002)(186003)(103116003)(16526019)(26005)(5660300002)(2906002)(4744005)(36756003)(66476007)(66556008)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUhRK1F0K0ppY0RrVjZQaGtkVm8wcXY0eW1BcDQreXl0WjZNSmpRbzFQN3Nq?=
 =?utf-8?B?bnRHUEtITlVIZ002RVVDQ0tqVytXTmlQN1pJd0hmb3g2Wjg5WHU3N2FDcDNH?=
 =?utf-8?B?SEhqSnZWbFBQck4vVG04ZmFIRVFNNTFPUUl2aFBJN2NnNUlQdnRUbVhMRVRR?=
 =?utf-8?B?eWpIeFNuaGNWbEE1cmpjWWFVK3lvMjBiTlJQMlFaQWI4VW5KSnNiQ29BNTRG?=
 =?utf-8?B?Ykp1WGdUT0NBT3U2amYrdG5senVPbC9OM3ZEL3M0dEpUYUF2UFQ2Q1pqZjJW?=
 =?utf-8?B?T0tYR0ExSk1oZ2hJZ3BLdVZ3TVZ1U1o5N2dVZTNhdEEvaWlxa0lMOGhNRGhH?=
 =?utf-8?B?QmNyY2N3S014MEtOamZnOGN1T2s0eElqZ290SlB5YkwyczZDdzhIdTBCZ0dp?=
 =?utf-8?B?WDlwdkFkNWd3ekRCTzUyOG5pTW43Y0c4Nm5zUTZIakRmaGhYOEQwWW1hTy9X?=
 =?utf-8?B?MlNrQmlRT3RHeVNEc3RCdkoyakc1dkVZVWtML1p0Tzdxb20vZG9QT20xQXMw?=
 =?utf-8?B?M29tMjhWWi9ZNzNOb1ZXUFJTQk84c3BLWkk0enhWRHVlc0hrc2xNbkRXRUhO?=
 =?utf-8?B?YTFCNmRmVWd1YWVIcVFPellESkJaSm0wVjZtMHhJaFRkeXZxRUtiVVpoL1kv?=
 =?utf-8?B?U1dabEZUQTZ0WnFESTJ3d1hvbmZKaWRsM2hLOVNKSm1saC90Z21IRjJqWm40?=
 =?utf-8?B?RjNiQkEyeFpRVmVFc05aanBHYWNwQVV0Mnl0WkJlZmhlQUdXR0lNbms3MWZx?=
 =?utf-8?B?TDhMWG94WWdMRmVzWkU5YlRoSkUrYk9zaEUwUStVOFR4MENKRU1KZGVYeDhl?=
 =?utf-8?B?UityQitXWk85WERWUDRxbTFaUEV2MzhZVzIrZ0gwWGtVRk91aktQMHpxV25p?=
 =?utf-8?B?OGdjNHBvNHJha20wZ2xHWVNvQWpFQWpJYU51dk9wdmtac2J1QlVFR29CUWd1?=
 =?utf-8?B?LzV2THBmeVMrVkRjSUJHVzBjVUJGcllGbHZ2ekZiZSt3MEtZajZKTG5iU1BV?=
 =?utf-8?B?MEJxQVZxc2twTEhFTmVtV1dYZTlwRzNHaW91S012dWowbVZOclFLS3g5ODJI?=
 =?utf-8?B?dHd3SHcvN1JHM2NJQWdzZmNua2p3S3J3U1g2NW1BVEJZRFN4Y3BtTHo3U1VQ?=
 =?utf-8?B?ZFM4TU5jOUhGME1NcWVUNDJCVU9UK0tSNkovWk1NbEN1dy8yLzhSWnpSNEdk?=
 =?utf-8?B?eXlOeWZqRVRuWjVkTnl4Sk54cVMwNER1eElRSS95SG1DME1sNmtOckxuRVdK?=
 =?utf-8?B?aGdCbTZBQWprTG5reHpNZTlpbHZCNm91THJ2M2cxZ2VrNnFYRllnMmxKWFAz?=
 =?utf-8?B?ODN2UE9rVzRKV1c2dDAvTk5tR1hzZkhmM1VJbTluSERUNjNiTzY4VHpsWWQ2?=
 =?utf-8?B?cFdzY2RsakYvdUZZaTI3M3paaG5SMXNZSnRmK0lDdk1ibVpoemZabFNnU3pY?=
 =?utf-8?B?NVV5cXBybThJRFFKUXBzcW9ndlppRTdFMUlkMlppa21kTlFFVlhXcUY3Q3F0?=
 =?utf-8?B?QzI2d2NvU29mNmVNWHYrLzlEbHJsM3pyTEkrVDJxMGVvNWpQbUx6WjJmcTJa?=
 =?utf-8?B?ckpDcVlGTG16eWtreGVWZVhWTlJqQUt3UkFyVUNjVnlxZWZLdWNTOE5KS3B3?=
 =?utf-8?B?czZFRXFqZTFFcTFaWVdHUzlmUzEwWjdVcVBrR3dTa1h1akp5RkkwZ0pWSyt3?=
 =?utf-8?B?TlFSUVpIbXlXTS9zNTVaM3hISmQxbk5WL2lRR3N0WlVXQ01adDRoMlpvU005?=
 =?utf-8?Q?aX2/Z8LwpcBfPlwIP8u4ek/IRjzHJaZwnL1lhNO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4dce2c-2375-4e8f-97fc-08d92589a140
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:45:29.7689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dj9k1uwh1mf+PbQjK5jGTVPcqOxApg+HwoG68d1UnwdMMWckh1ZzKIn+J/YGManylub+bCxinvoVf1NyFwV/biIvy1GgMJX4RZsm2MkiaEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020036
X-Proofpoint-GUID: FAV1nQvoR8JBBoipMjKIX5-ZxHjH-deT
X-Proofpoint-ORIG-GUID: FAV1nQvoR8JBBoipMjKIX5-ZxHjH-deT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020036
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 May 2021 14:26:42 +0800, Stanley Chu wrote:

> Some MediaTek SoC platforms with UFSHCI version below 3.0 have
> incorrect UFSHCI versions showed in register map.
> 
> Fix the version by referring to UniPro version which is
> always correct.

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: ufs-mediatek: Fix HCI version in some platforms
      https://git.kernel.org/mkp/scsi/c/2c89e41326b1

-- 
Martin K. Petersen	Oracle Linux Engineering
