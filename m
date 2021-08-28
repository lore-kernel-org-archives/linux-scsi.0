Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536DEC4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3928F60F44
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhH1CdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38762 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233168AbhH1CdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLwKUZ025345;
        Sat, 28 Aug 2021 02:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fTp0EpFzQGUaz72u8+lVtSujQGjL2TEYfMf41pyq6Kc=;
 b=VStqYJG3pu2enrqFvgPwi5z/FeGn4lmYfbarCaS7jQgqSz6bIk7tcf/DZvUfyV7Wo6sy
 z3apV+6WlsTrj07WKBHFLtXBT2Q2B2qvdQm02zG9F+j7yrHBGpVzYykHjRdrHjVXbXK1
 wMk9UKbwF22/FTXafBzhqqJvW4hwDrpzaWyZ49kNrmZ96jfw4zI1hQsBPGPHwQnE2Iwl
 XyVsWTLFFOVeUSziIfurT/Y7xB1cHrY2J6Rg98FuyuQ6ngwCUYa+xidXQDVd/z7aPypt
 N1qHHe+Nbe8U3kqWuER9KyDJlGFYlHXKwBPIoDKQmGFKE9+STNooaGq1NZTtsVfGL4ve nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fTp0EpFzQGUaz72u8+lVtSujQGjL2TEYfMf41pyq6Kc=;
 b=yxsxqvwd7oSQa/9RekKF/xe2z/hcR+tFMxvfG611b+7D1W7vroYx7qivqDc1nWzrzNeK
 0yifPMd5RWhxik4+IEb4N7xTtrMyhitK/tKSr+2qFuidZtwzX5IQEyjD4hDLF8brTmQH
 5mSAGMWv9If9UbfyOuVty0j0zTtsuSavdTNZ16A4FkOznkZbG9ZV6DhWo0qB1HGBDtpW
 zMNOOeR/7EsbxnXcC/0J5krZZ56cusnBHrvmb+ZLqnY3Gx0nqT6phTssLEVBWb9XFkno
 s5sJOPjjgu6vWEfKlHAxWfxO6CI2Hc4PWFKrkfhVl0qmJ8PCTD3Eeu8ofb8f1ZV1jI+O mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvh56y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2Fm2f147458;
        Sat, 28 Aug 2021 02:32:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3akb935rd2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJe2DJnOIW1ZKEDU0dFHzWP08PEeKRDmwyZInm0mgO3jmwm6w78RBZozIzd5XZUD7kR8ox6H5cuHSgWgeXDjGzC08/O3QOojqNN/KlZbBwqY0LtROQjWpfRKrsBgVg9SW5t5j3xmNGpOhZlWxMFx5Va1b94C+7Rsj9nae4oZKnkuvaeJQgsDcknq456TglEdmViXU3QFfDKqtzZ77mUSqaORtB3/G2o8JbO/xn5aV3bKJk/M3HuWcUb3fB5vsbGQ7hc7fU3/oH0pOV1Jt1RKoPY3XCqJSmrHkrX+e8820jI6Te829r45pPRWeWNLAUXWvK3E2uXzfjAkgtNVLw2CHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTp0EpFzQGUaz72u8+lVtSujQGjL2TEYfMf41pyq6Kc=;
 b=hieHYTqPf4fiIJcJ5n1HztuDmBc5Ws5naoKeZzmwyFGE272F4emJkwHsjHRB3vziyrWUuxWWyUm/YhC0KH/SDt5U3ZJV/3pIyNPGm1Fp2YWnhVa3Z4wjh6jP4pCFegePERY/RXLjin2WhWfcqjiW+AsL1lv0n8YxJBnxoQzKHGUyl0GAb8x9CkN0YTTfDpJ8S/pZIwH5kG3YceFdu+tiPy0h4zFGLnnEj2izZctoypw6W+f9DF4NzoqtZJLheDwI0hW3ung70iNfjdSi5FqWSqEizlpXEmc6dTTKPmzmIhyIJc5JPSRoXqGU3xfI4yvpHP1uN6k1xvSxS/nUhm4btA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTp0EpFzQGUaz72u8+lVtSujQGjL2TEYfMf41pyq6Kc=;
 b=z6PzyUmVudFxW74MRtPNqyRs5XJbk+PhcVVE4ICt32/yBTAW3sJAr9uls/hAoaJSp4W9oFKOV3J30F/cWuxV7/Ph8o3nQ0hpyq8gOpXYlWF+yBoLX24MmIKlvQzC9Vyl5kMIOYXfUsGiqk+N5lAEb9phQSsa5SBuWK6rE8X8zB4=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] ncr53c8xx: Fixes for SCSI EH rework
Date:   Fri, 27 Aug 2021 22:32:01 -0400
Message-Id: <163011776501.12104.14243630538682872585.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210820095405.12801-1-hare@suse.de>
References: <20210820095405.12801-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e94b112-5e3a-4456-dc9c-08d969cc0eb2
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515EA3973C4293CCAE98D2D8EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JeuWsFz2krKCtPkVM4cdKESV3ORR00oBGHFNGRgjuspUG5urM+2ClEhfZf08esrivT67RzgU8VlVv6ScSGppB75AWX5Hew0iUdCvWvsUpzQbEQEa+EQVBjOAx+bksP+wRNTyBzIYSK5ziBX/4KrhxqeDudi9bFYoLLXMWMlVedboJGcPGmswvG8JYakNq/MKSkPzAvYqD6gRYP/tT//RI3j6/7otGL7S1K3iXFMtZ517v3ZkruH4nUGpUdhUjBEzb7/c7nEkRc4DQW8oNsPxAdMcy37pNzBMk+0IUrPn5R5MVtqkJfbLQy1XIR4SntkkTs/shRKMyEsm+Vi9UKItSNDg6OJBuWogLtdnrYbciXNThIYGDrFRk8yTa7kcCiwFn1G3fsw90Dc9PJpbQJSKSRnpEvG/N5BhcsJOlnen/lOx1cY2ygLjizhxqV8gsJa7Ov7HW8NB2USZQmISWdDzySanaE7jD5A3bguFWbtdo5mEb69iBQ7wKfDbxnUmRQjg8Nc0qa60uRj7zTEzHIWYgmiUvMVjY9qMPYR2YFacsZWmASZavDAFRY+6ng+cAPbThu5lD0kPCYMw5KA78amq2wi6wqJPK94KSLHpZ91qTwOZXD/kvNw6TBCuArIKtqN+GH6Llw9zlUCojsdUwjFQM6djXddk9V2bWK1i2CdzTHfBCXma9WkVNzvxX07rGsf+gfxY4yaAv0mpwHcvhcS4KOAiM3aCGEScfa2sLnuT1yzGDfP2T7E71tVwX2kSXwxHQ/kHtSeMsQdU/4aprebWXXBYczQOvk9fPRty79mcK+f6a3RI3XJLybRXWzFxXJz9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(54906003)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(6916009)(103116003)(66476007)(66946007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGhzRGFsdWJoMVFCdGxXT0IyeHZsNk9ZcGNFNmIwZUFRWHUrb2FOdUxkS01P?=
 =?utf-8?B?aHgwaTNWOHBRdlJxRnhFNkxxQ3JzeFB0MWtodm94TFVaa1lLUGxvMEQrSDVv?=
 =?utf-8?B?RWZqUEpreGFxYUtDTGI5U0lYc2UzL1lIMlh6RmFUWU1wL2JMQ0N3N0xrRjZG?=
 =?utf-8?B?eHUvTnk4WkZNeFJOSUo4OFkyZWRtOXJGZ1NjY2NwK0pRc25CMXpIQlRiWjVM?=
 =?utf-8?B?MkxwbGxnamYzWGk3bjFRQUlDUGlqb1ZaeXdaWjQ4Tk9LbERsZzZBd045TWdt?=
 =?utf-8?B?M2tTTnNERC9PMTBCZGpScUNhaTFkQ3lqb0FiM3g4MGU1YjZvQVJjTUZ4SEdJ?=
 =?utf-8?B?OWdaSVVtanVPaVZuVTBsNVlRTU5JZDhLOHBrNTlXVnZBSmcxdURTOENjNUhj?=
 =?utf-8?B?ZkNlT3laSC9majdnOW9ITkR0MWF0M2s4ZG9WVm1SZE94Y1NlbjZySnVrZ1Nq?=
 =?utf-8?B?dVQrVWNvOFVDenlyNjZvK2lZeDhxakVuVHpIR1pnbHV4QlNlUm53Ni95eXVE?=
 =?utf-8?B?MWMySnMrdlJPazQ2UUZ1VFZZTXpOd2tjLytOWmRoMWJDUmk1RTNseWIxUlh6?=
 =?utf-8?B?WktuTU45T1dTSkkzdURFOG9Gc1JEZHZnMnV6V0Zpd0RKRmNtc2tXTzJZdHNs?=
 =?utf-8?B?VTZVc1VaVmVTU3ZUZWcxSG5ITmdyV25VaUZnanR1RWdCcUVrOGVmYXF1YUxm?=
 =?utf-8?B?d2xDMEFXZVdTbDVPc3RZaWVKYkdtWnR1UHI3VEVSTXU3clRLZWcvNDNKajBx?=
 =?utf-8?B?a1RlY1ZQYzZQa1RtbnJ6MnBobk5mVFYwU2sxMlcrRGQyTEVGK3RLcFBVU3ZI?=
 =?utf-8?B?bSs5UitETjQzVUpBendXL3hJd2FTeGY2eVN2dm5OeTExUUxkdzBaYjRkK0JF?=
 =?utf-8?B?Z3ltdEI0aVc1WWpXc2VxWGg3aTNnQWxOak9xVGxrSkVmd1Y2ZXVxb2RlTWpP?=
 =?utf-8?B?Y2ZBSHg0OXlrUGEwNnhKZlNmZkQ5VUkwTWgxUU8zdTZ3dTZEVnRiKzREZm5v?=
 =?utf-8?B?cWhzMzMwZENURHJwcHpGNmpuenhBWVorUEFZWDRmckVNVHk0N1B3OWNYYmtT?=
 =?utf-8?B?alJBS2ZKMWZyRWlXVkpRWFg2ZXR3ekxneUhFMUN1Mjk1NVVQc0hzdGhhSnhx?=
 =?utf-8?B?VmZjamdqZGtibnJaRkxmZ0M1enk2R2Y2TXNXL0Q0eDlQN3hkYmZ2WUtpNWhU?=
 =?utf-8?B?K3ZpclRkMVVBSThoajgxdEpNWU1IdlQ1ZXRYcW5rS01iT3JiNEtueUVjanJa?=
 =?utf-8?B?dkx6RUREZGxLM09hWERCRW9pVEtybnNrQ1M1ZXhqV0YrN3QwR1hNdjk5OHFL?=
 =?utf-8?B?V2J1NTNhWkRZMlozU3hPMk85WkZTS0N3WmtnSkUwMjhSWEp4aGRDNVB2RlB4?=
 =?utf-8?B?TU93bVBJVExCaUZ0ZmdpM2N5dExNUGRBRWZxWDVFZ1FzQW1SMmdLWURtVEpk?=
 =?utf-8?B?aDRmWlp5TGhJN3V3TVVNajVhVGRxWlNwN1ZjUjBzamZ6YW4wdE1RcW8yMFJJ?=
 =?utf-8?B?LzUzQTY5S3dxeFBzbjlQS3hpRnYwQW5wQVluTThtS2JDck9veGIzR1JZcVVh?=
 =?utf-8?B?QTFJUmJwVDBTUk9DRUh0cTJHK0NIbGxnbFhqenNLQWJUWlh6bWRGZmtrUmdH?=
 =?utf-8?B?YUNyNVhMV3hRQjdNbFdJRVA3WGZpTkYyWjEralo1Rzd1cFBiUUlOUlFGZzY5?=
 =?utf-8?B?ekxpQm02bnlCNzgvYjdkUVlha0tIdXpBVWszWnJsdzVEaDRubFd2UzZkVURR?=
 =?utf-8?Q?XjyWgg/Fl+iu5yDoYlJnAynXTenjgaizHOCTiRH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e94b112-5e3a-4456-dc9c-08d969cc0eb2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:19.2972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KnENUB/nFClPpt9FneFHQ69R7jPmFWDgOpYdyoBciEqi8/5+/k6ZsEDiJySD9DVjBQdwjCyCpocN1/jqc3qSsqyn87+J4nz/x4AeF9WWfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: MuNbF_XfvWaH9Cm71NMUzkrXVPQ-SF1t
X-Proofpoint-ORIG-GUID: MuNbF_XfvWaH9Cm71NMUzkrXVPQ-SF1t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Aug 2021 11:54:02 +0200, Hannes Reinecke wrote:

> with the SCSI EH rework the scsi_cmnd argument for the SCSI EH
> callbacks is going away, so we need to fixup the drivers to work
> without it.
> 
> This patchset modifies the ncr53c8xx driver to not rely on a
> specific command for the SCSI EH callbacks.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/3] ncr53c8xx: remove 'sync_reset' argument from ncr_reset_bus()
      https://git.kernel.org/mkp/scsi/c/227a13cf12f9
[2/3] ncr53c8xx: Complete all commands during bus reset
      https://git.kernel.org/mkp/scsi/c/f434e4984f5f
[3/3] ncr53c8xx: Remove unused code
      https://git.kernel.org/mkp/scsi/c/1c22e327545c

-- 
Martin K. Petersen	Oracle Linux Engineering
