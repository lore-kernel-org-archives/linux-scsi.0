Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDDEC4707E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004466135A
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhEVEmR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhEVEmQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Z33a056344;
        Sat, 22 May 2021 04:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NCd8+Q7sW9451BS7JMAVQkYI3VbEBD1XRmTWGTTpKsQ=;
 b=ced2vXRdQanYvokqIJweZ+fJq1JlkuA6aFHOpt+qbveaRkTyapYleLWhv2sFmW63NCPU
 S7hTHUkBvQg8caJfprwWAOgJdtWF2CurvXEnyAOL7u4MVhN2NJ7sRSVniuNQG8dNm4ZY
 dF6+Aiv73u+O+b2MvaXs2PoOinuRbc2cy9S5T5OiClV8lNnX4zRndC79BFwNUVkBQrRy
 +nPYGv5K3jVykpkS0ZbN//vOjNk3LqHcU8uZBmeuevCKdRGpt7gPNvRiPjwx+MfWVikT
 1dVUVOY/3/pueLv01g8H9WHIpjRJGxrXDlRfsNpoJd7Calgcyz/98fJXLxSTt7QusQ/B Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38pswn818f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4aljG072530;
        Sat, 22 May 2021 04:40:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 38pq2rp5bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8hfQBJks5Bs1eBhPzHjAR+D7UFChz2RSKcfcEjzL2u5WF/XsxYPRut9O+M/xowdDgZOc0eaR9OQlW8S21EtV5UtqzTu315v2U4OwuW2HZeh8QQYEMLY0pZUWAM/cCphu3qRHw9/Fogt97uutTDt9hYeVXKPzh0vD1eQl0FVp8fXO0DH1UUxsvXKomz5E2gfctgCOfeDfrsM89vdk4rVGraPqrqaiTbFo9PFCazGAUWLygVk3R7Mtnu1kg7IUkyKZQwS7M+3B4tRNF0wFqBwiyazc4wErGVFDHD6bbvb09Obc9G/X2RRNOQ/sFeQCw55x7Yuqoj+RkxnavqX1/GsBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCd8+Q7sW9451BS7JMAVQkYI3VbEBD1XRmTWGTTpKsQ=;
 b=BgoMHeNuAjjN4bFLJBg4y38hq69o3IDDJiYJXLySVlJWm4rq+F4ypwuGroeQb1ifNobliDSQMnhIe2D2w/ca8DlFvNz97RY19YG4InEm+6cABCRO7t0/5/qfoFxIJFkNrY1KvqQDhLbiv2sLijNy7kCse4Hwg24G6A9ww0mXIddPVNPUKjQpHiJXdGubhfcprHKXqD+KaKvgC+t9OqjRbZVWF9zswUBbdTCB/A0IpAZ/wZ5XPLOSSN1EA+96nNkldEdbceGn0Q+WFOYkqg6tkGAWD4YzV4wr3M8bOlddVWdAKULweaJqLlLveqHbJTdV5sQAcgG2swXLtOuwUTjMMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCd8+Q7sW9451BS7JMAVQkYI3VbEBD1XRmTWGTTpKsQ=;
 b=pAhjImYT9fWGlmOC2nwk/XEIYOjKoIZZi/75IyawSkbBBNZMKraejtbdLcHKgdtK7+BAfNLZ5zI8/lAThYOViKgyXcc086/hQnpbfeWbJiu/tEyyzqS3VvPc3UqSlqgvyn2J4w8iAf+FgtZOhXRtl0BX02k2nnVtvwYClK/zI2k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v2] scsi: target: Avoid smp_processor_id() in preemptible code
Date:   Sat, 22 May 2021 00:40:34 -0400
Message-Id: <162165838886.5676.10914513483315221530.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210515070315.215801-1-shinichiro.kawasaki@wdc.com>
References: <20210515070315.215801-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68e3d4bf-e91f-4ac1-5532-08d91cdbc45b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5481BCFB639C4C922F282C088E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +UrLvmIGad0ktMwMTPWLApMyeI7JLASPmBhAi3gTyCrVFEi2pSnrL5XaYQIbRWSsmkAxEL0QG9gUnUoVdupe0KXARlxD4R026tJYgwcur10AAr5kQeLVuEofd6a980QXXwkhbGlYqyydey1qRjJAtnGLRt60UMsfjh/e9zTwDh2lvFxL+GAqZQiKmajL+tx430eP8WVXwjJ0pes//4cuuHSi5b81FjIHHnGZB2w79CxpIbFzi+0wPwQEcpM7w5NapnHkEuI9SZXfMB/pNInV87kxBsZq8n9DFYqvbL6bxx4i8yuvKKzT4LWYbBr/uDQez0Q6y1aNiCFp65qKRB3ChCXAgFqIevUoyj88I0yW19PqSmUkanPJcXzwhJjlD1kd8FKvPLZB3KuJqPrHX5IjXT9fqBVIyq+aIMZ0g9u7hvQKMVsI5RqYSYA1y1HvQ1md6lluqlLKsrLMHxB2pugOFoOL0uDg/dAkn1vnyw5fnWiyZwSKLvClV/L4l2BsUnpWJY7u+RkMSqKInhMzfVVVR3asHM59mVx6XLla2GceUxmdlcCvbAXHG1NtcqEYK7cQq3bLxvbNYAWOWfVzvhVu2W4Xkl0fe3XWNUkTSUSkjmg/htpGUYzoTkdS6kMIcmzUIODAsQ0PmeKddS6qqejQMAZN/4foAKO/0Zi2KtApkWr62LH164iEkvqssJTRr46WXk4j2ETyeCNdhPnlOrEX5B+Ix+83EbLAyRzXWI79V9joXofQhH3BYZA0hmhGqcVtOKB5rm3BU6Bp7Fzryvje0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(107886003)(110136005)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cnoyZWJUOE5PT0NDRVpsenJ4ZDdDUUpBTzR1dm1FK0dvNGpPd25SM1A5dys0?=
 =?utf-8?B?MXViVUNUVjVhZWVabVVLUkZWQlI5SUU5N1lQczB3TnRmM0ZSdzVEa3RmUURy?=
 =?utf-8?B?MXp2ejQycG04TG85TUc3SHBOOXlMdWJNOUcwajBNekJJQVJqeGFjc0krSVJQ?=
 =?utf-8?B?RElWbFhhdkI0K3ZTblJhZUlTQTlsc0dhOHpaazNFVU5FRkZpeXVFZElhd21a?=
 =?utf-8?B?dzM1UmdVSnpnTVpyT2d0Q0dCNFY5UjBGM0dMOXZaOVRvay9hT05vdzJDVjR5?=
 =?utf-8?B?aEJNOVIvWml2aVVKeGRlN2lOMUQvNXlzUlh6QTN4TEdVTUphL1lIRDEyd2dm?=
 =?utf-8?B?TE1XMzhZeXFKTFJZR0R2OVhwVWo1aDFVY29ZQ01MMFVvbHRUMDFPTEFMZ0tn?=
 =?utf-8?B?WTdJZkpTNXZpZEhYejJucklWWkl2ZmVyWE1OZ2FpM3BkMkExbk5MYmlqVi8y?=
 =?utf-8?B?WVRXdE5qUTdobjlSb1FkTFZ1MElzUzdoUkVZeXFlQUtJL0tPZDVTbzVXQkNm?=
 =?utf-8?B?eGhHMi9RRGtDOXYyWitycXNnektZNWVDR2M1VEF0VzBuQ0JjY0phaklYZDU0?=
 =?utf-8?B?TFZlOU5DMWhiNHFPQklTWkNpU05NRkR2cUl1NmZkRTV5R0psdU1YNFl3UkZ0?=
 =?utf-8?B?TmNRNVc2MjhYNVlobnlsSUxMOVpaOTAvUktxUW82M1ZtZ2NwZEt4V25hN2NI?=
 =?utf-8?B?QW9BRGtQZTRiVmtNWEk0eUgzbFE0ajF1VzNBcS9RbnpqZHN5T2NXd0Z0L0NB?=
 =?utf-8?B?R2oyK01uUmdpa1dwVERRUlV4VFloM3l3THJ4VTl2MVV6QlNOSjJFYjFURFkx?=
 =?utf-8?B?c05iQldVZGR4a1ZpcnQ1M3FKRWtuT2NmQ0dLUFlCdzNkV2ZrWHhtb1VLdHdr?=
 =?utf-8?B?ay81T3BnVnlIbCtZZW50M1M2SnBXYzRoWTlvdUVnZjNBMzcvaGdXQ2o2QTRk?=
 =?utf-8?B?SFdBa1pkcFArV1B6bm9vRlRZeXJRaDNveU05Y3d2Z01VSnluUmU3K1U4OCtX?=
 =?utf-8?B?TzVUcHFxTDdsdlBibWRiNFB5MFRQdmcvVGJLUEo1WnNqN3FxLzVIUFJhYjNY?=
 =?utf-8?B?bGhxMEZYZGU5dVBOdnVzRzlnZzlnUkhXUkN0UkZIdkNTNGFOVC9pK01jYm5U?=
 =?utf-8?B?dmNTc2Q4T2JEUWNmS2lLYVFLZG1RYkRNL1dLQnlvS3BEZ3lnWWRvMnVJQko4?=
 =?utf-8?B?aDFxRXJac0llRDJyMXdxVzhRNDZLT0ZFSUQvdUNFNkgwd2dyVFFGSXBGZnRm?=
 =?utf-8?B?WHBLM2UvczN4Q2twU0kvT0NMVVNvNG5FMzhDL29yT2k1WkJQbEVFWFVlaG9R?=
 =?utf-8?B?UzZSejZsNVpEVkR1VnlpNG9JZytKK0dtRlY3Tk1qbDFydlZsSEdKYXh0enFN?=
 =?utf-8?B?dTU1TVFQZHl0SW81NlRaN3oybkNUblNvcWtMcTlzRklZUWlqOGN3REMwby94?=
 =?utf-8?B?REN1RjFxOHoxOW16TEIzYTVCRkxoSkc3ZjRZbFhuMWgyNjJwLzNBVXZIbktQ?=
 =?utf-8?B?U3JLZ3FocVl0SkhkT3d2WjBZUUlrM0lyNFFjdFJKR1RweVRHUlFZU1JHTEx5?=
 =?utf-8?B?cEdsT2lBQUV5VGcvRG5pbGY0SW9pWjhsZlFEVUMyUlJ3WnV6YU55YUlCNkNC?=
 =?utf-8?B?eGkwaWZESGUyOEZLdDNQaTRIclVyMkpjZG1SOHgxQ2xkcFJ1UjRTOXVNcktR?=
 =?utf-8?B?RFBVM1V2OXI2UEl6L24wR3lEM1FFU2ViWmdLdjN2V1hEcUNEbG5WL0RaN2Y4?=
 =?utf-8?Q?qAhdYh0khjVFkSwX9jbLqfiMctM+BkHnwojgMxf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e3d4bf-e91f-4ac1-5532-08d91cdbc45b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:46.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AhD2sW3icflPuJENzqFCdTpgY+QZJy1aUVGT2gJM5+eKZ8VI/U4PjvTPYbIA/xLFzxS6D/oVijobFi71zkqU+TuCa51eIFhwOtsUYn1Rjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: ZIswAbhGtmO3_Zs1j5g8DQn_BpVibSr8
X-Proofpoint-ORIG-GUID: ZIswAbhGtmO3_Zs1j5g8DQn_BpVibSr8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 15 May 2021 16:03:15 +0900, Shin'ichiro Kawasaki wrote:

> The BUG message "BUG: using smp_processor_id() in preemptible [00000000]
> code" was observed for TCMU devices with kernel config DEBUG_PREEMPT.
> 
> The message was observed when blktests block/005 was run on TCMU devices
> with fileio backend or user:zbc backend [1]. The commit 1130b499b4a7
> ("scsi: target: tcm_loop: Use LIO wq cmd submission helper") triggered
> the symptom. The commit modified work queue to handle commands and
> changed 'current->nr_cpu_allowed' at smp_processor_id() call.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: target: Avoid smp_processor_id() in preemptible code
      https://git.kernel.org/mkp/scsi/c/70ca3c57ff91

-- 
Martin K. Petersen	Oracle Linux Engineering
