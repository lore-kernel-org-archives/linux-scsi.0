Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7F6C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC33061278
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFHDHl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19370 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231253AbhFHDHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15835amw004671;
        Tue, 8 Jun 2021 03:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aAxSpGxv5URgXaVzqsiDqV87+6LqjCvzu0OX94SVxT0=;
 b=m8YVYcKg4n8+8CrxFsQNbuqXEEMP1R1xCiAtHNheOBK5haeVdYUSChA7VgkUKQyyilty
 YmeCPOvCU/nPRwtrqE8SG5KNPTZPnbdJLN7cOOyyt+/V9mtWMcH07HVVCm8RgCc08B8O
 9FBrLFLaeAS3BXichWxLNCUuUncP9T85T/klvoQVzoRZVsWvK0UJmbMaw2zbZ4fmTRhB
 5eB2ZOvyc1la+GhhL607bkztU/emv/FPbrwBmkVRSm/HFj3YR42GND5dO0CmHqGPMZXt
 cUlhJgs+UrwvqNV//Ddi+onKcTp881Jkg5YKS9EJ1WBMfvZmKXfes9+UqlV+79klqYvG AA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3917d4gg04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:36 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15835aUM157171;
        Tue, 8 Jun 2021 03:05:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 391ujwgtw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUn0FQ0XlerysiL9Rgm/DZbUNJve4RhQRahT75i6qh+tEkHQfwksc1lXt/F3ZOkReSmEwn0MC/h/cKVgQ53s0JaBR3jBHs+uARcuaxfx6mAEeej/1RSHXTgeAGSqK4DO84uPy4RCm0aC0aejrFFZu5O+7Ck/LlcFu8NrSWk1DomfIqBUJml5bjd9eSjxniL2e2TQ9fcRb33QBAWgdIfhrD+mMJ8fRGtSLffgz9jk6CFyEUF2DLgenv7d9XO4c6XNKF985MIg4+Z0YstBHgz5kwuEcK+nmZsBUxQRfILuuR21tCj1YLWVldjJY4Y0p8XvZ/gGHfrXb+cAux1sFNB8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAxSpGxv5URgXaVzqsiDqV87+6LqjCvzu0OX94SVxT0=;
 b=MR5QUdc499QzN/imcz8WfoisLgqVmPrHeTNIFQpAaXOFZpJcOIbViQ36sDl21zIqrRCCEVWgXjt8tntgQXXkyZ4hh6jDZozPidR71MdScqGfaaD8ocRortEiHIkjQSyi6Pg/UM7OosPnErHU4HER9LlWmP+po/kIzYgn/utvLzrhSkBQfbShrGGAQsMDI15Qw0SKDokIFQI+hWG5WN8otLBUfXEphgW2Ll3IH+VdtgI5gGZHmql5tVR4gnf7UaXjh8N7WXqGeYFLUomBk9i6e+vCwpv8fHxaE4DRvrxd+wPuMv7qRYJ4CD8uTh7F/RP1ta6eIMrHhUOTaaYK3GnbOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAxSpGxv5URgXaVzqsiDqV87+6LqjCvzu0OX94SVxT0=;
 b=aZWZXRTuViXpWjOV0kEQyFTdTDAXCOUZNp4jM2+ZgfERNHZD+mykiwqVgajlIqiDYtHr4SAVeW0iv1OWIn+X5ChfSzEnnY+zGk0ANe3CTUwmUpTy7k0Ls8JaCb5A1HHAfrUK4o7gD1RuduxMqe3G+duMg/nt2mmPOHNuD1sWs5c=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, beanhuo@micron.com, avri.altman@wdc.com,
        cang@codeaurora.org, bvanassche@acm.org,
        Bean Huo <huobean@gmail.com>, tomas.winkler@intel.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix a kernel-doc related formatting issue
Date:   Mon,  7 Jun 2021 23:05:22 -0400
Message-Id: <162312149257.23851.11215801156943215694.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531163122.451375-1-huobean@gmail.com>
References: <20210531163122.451375-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 190084bd-5098-436f-6d37-08d92a2a4815
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470ECD267875B476EB828CA8E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSj4Bgnlob1+HTdQxgKD3lt1ubTLdmRTsThVSApP9Bl5pTKdAYjz5xoKPnxX2bDnKmclomcqHRp8ulMk1NPs3OMsYAJAyAoHuPS60SpCiTEadaa40nRFlD8CTFKCd19GHXP169iqOsz4XdYp466UomNODNtC7BWHz7Tm/xrwiW5WB+ExgokBYMEA0cCaNCM0H79mako6PFDsjzblxDIg5XKui3oq/43GVOycJcKLfyDN0FPuysnpm6PUNdZwSVVNhgT1I/JMvtIhmNEuZJB4ymupV/izqDUlWZ5q5xCWWUDQRB+6uDjpv7lw5THQ0UaL4Z2gbUFr2noZva964tCX1I5IWSHXnf0EAtZdj9WFV3ob70lvaeinr0uNA4DC/VoQ4Bf+kcS1mz18LVVSbJL58vsc/1N55B8X3lsZr8GioQuHwaA+xYfA8NlOhcMVQo2YV/c42MtQrrnROX9KCWekj/MXrcnxrlqJ2BEjZkE7lNvEAJH51iRgrWYlMSAxcnkOoguS2aBg/regOKq2iK0nOWCEHwaXCl6yP+jjQ89fRpcgWLoQTEFh9avZc//UcoGMw/W0eiXP5GYZzaakK3QCHkoXhw43miAvStbcmNPAG5mzW0b7KSDxtbguW3p0YpM/1bdvyHL40jgC8K0pSlJM6Nr1Og0Fq9ebgZj8eEXbw0slXgEQkGOkEOph92tBkeMF3Nm5zeZD7fSuqnVrAzAIc9MOsKYXzBmR0fcKhrN3SUpt42hTwPhigXB0gqqDeSnerZu0nzQkNEYCO+dGMLTr+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(66556008)(66476007)(6666004)(7416002)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkVXelU2Y0V1ZXVFcDVIcnFzdmVSOGZaK2hDSWQyaFRsUU9RZTlKNHFocGpV?=
 =?utf-8?B?YnFTTEthOElGMjVXWVNZaUxEK3VSKzV5WWVqT21HSC9rTFd2ZVBjV1ZZYmZx?=
 =?utf-8?B?UEYwVjhwT0g5blBJRUZTM2o5d1pxTHZGLzNxOCtaOFpLdWZTb2s1Q2VxUzRF?=
 =?utf-8?B?NHBiQ1NyZm9maEhlVjFrMHdzNGdHMnNkM1hSWHNXd01pT2FXN3RnNWhBcTQ1?=
 =?utf-8?B?R0JoSmNKZ1FnK1E0dFRzU21nb1lENGhJSStVU25kMnN1dldTaUpLdGRYcXdJ?=
 =?utf-8?B?UXhPZlZBeTZkaVFZTWF1b09kUy9jc3Fuc29KZVVjcndndm1jeEJyd2N1aWhZ?=
 =?utf-8?B?K0hHNDZscWtuSVpVcUQ1dWpCWGlRTHpXU0JuK2xFcjdiQy9HUm95ZTF2RUZY?=
 =?utf-8?B?RTUzSHVqcmpoc3Jta2lHRTBrT0VTK08vYXhJNzJlc0dmSGxkd1hDQUM4TkIx?=
 =?utf-8?B?WSt6c2VaelZFYVFjS0dLbkhlZS94OEZBVTR0RUZFS1F3bzBTNEg3VUJyd1hh?=
 =?utf-8?B?MVNvbkhoZis1SFRnd1IyT2kyMTB6RTE1dS9NRDNnY0lpL3lJREhSNy9EazBM?=
 =?utf-8?B?TDdlRTF0LzF3YnZ3TlhwOWtqWDEwR0dlVVNZdlJwOEFTL2VqU2VyOXd1YTZp?=
 =?utf-8?B?dHhrd1JDRVZyc0RLejFDSXJqOTVEY21PVHJ0THluN3FwU3cwKzdNZ0NEN245?=
 =?utf-8?B?RlVnWFVHcjRhSFI0QlB3WFFaN3VYZHFTdWdNMnE1OW0xSjM3R3NlWnR5dDJu?=
 =?utf-8?B?T3BQN1lJd2ZVUmFVdXcxd2xRdjBydC9oWERuN3lxVmp5Ui9hNFd3WTE4YU1N?=
 =?utf-8?B?akpDU2FMWjVxOEpnN3ZicDB1K0kzamh1Q3dBaVFEcmJGcHNIOHU5Y0hBMXRr?=
 =?utf-8?B?a0tzS3JPWWdERWQvSm9rVmxwZzRTVjYwV2orWTA2NHU5RnJxSXN6amcwdjAw?=
 =?utf-8?B?dDFsUExBeDd5T0JSZHIxb1phV3JoQUtGQXhFTUU0Q0VkNVpPRlJKZ0d6bFJ5?=
 =?utf-8?B?RlN0VDE4eVFsVkZIRVdNRDF1cHR4dzdwaitFWFkvMUJVMlpCNDh4TnZIc2x2?=
 =?utf-8?B?SGFlUXBpNzBHa0VVTzJNa3RMT0JiM3JKZ25GT0J1enFEL1NQcnVrZUoxOVBY?=
 =?utf-8?B?V1VGeDhGN2RXQ1JUdVdPbE11ZWp1Zlk3ZXp4MDlYWkVSMGdQajZXQVFrRnBZ?=
 =?utf-8?B?aVFFOVBBSXlOQmRYVExYNFVaYUJQaXFaTGo2NEIwZDNXVnZhVkxabm8wc3NG?=
 =?utf-8?B?T2hhMmZhekFyZks5c0M4WWFTd0RUaVZEdEpvYzJQNndyQ0RQK2VjUCtoaXJM?=
 =?utf-8?B?N01JbTV0ZDRCWEdpMTlFU2lpcnpIaFFQeWE2S25ZMzE5SkNyTk9jSk56YUsr?=
 =?utf-8?B?T3E5WjBaNWxzQ05pdVFxcmk2TXkxK0lUOCtKOEtxY3F3Y0o3b0hJT2JlUzZu?=
 =?utf-8?B?YUJubld0WWZrWFJtdHppNGl2ckFqL0lUeU9seVJWR3g1NGdtUXA1Z280R0xZ?=
 =?utf-8?B?bDlzSXhYYSs2MkxBT1JRdWlVV0p0SWlzZXhzalpFUUtidlBlMGZsK21PRWNR?=
 =?utf-8?B?WTJnTitzRGlqbGkwN01wLzFQYnBCczdMN21QaWVQVEV6M0hXZVk5d25IdmlU?=
 =?utf-8?B?T0ZNYVFtTWFpZ0RRNHQveG5uZElHQXlCR05abXBsRXdWUWJPdlljTVpzU0Y3?=
 =?utf-8?B?dlpHcFljTDZZNlVwaXpiSlJBWTBQVVJ6azIyNTRYYmRXN2RxWnI0bUVBREw2?=
 =?utf-8?Q?pjhwil+4r22OuAoAwgOdJoCgNFWQRNigVryEZtj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 190084bd-5098-436f-6d37-08d92a2a4815
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:33.7854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYPRrgG4Zc4gPFT69hyJeO5mpT28ThH9plm1L42kR4Ane1sJzT1bdq880rKIByuRtPUp2VrrS1LCaceb7gxTwsg7uTmosYZ/lOCxWMTel7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080019
X-Proofpoint-ORIG-GUID: 8xyVHltXij3m2x0GPxbVqK-wk6viUoia
X-Proofpoint-GUID: 8xyVHltXij3m2x0GPxbVqK-wk6viUoia
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 May 2021 18:31:22 +0200, Bean Huo wrote:

> Fix the following W=1 kernel build warning:
> 
> drivers/scsi/ufs/ufshcd.c:9773: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: Fix a kernel-doc related formatting issue
      https://git.kernel.org/mkp/scsi/c/f6b414294224

-- 
Martin K. Petersen	Oracle Linux Engineering
