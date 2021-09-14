Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CB4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F21610CE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbhINDpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41042 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239178AbhINDpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:32 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXjv8006598;
        Tue, 14 Sep 2021 03:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cu3RrlrT5VSCFZZWWV1OUBJt+9SQ31mR30HnxzKlvjI=;
 b=yAiNjJ8IAugy523KtoJAwIpCD0pEPBZrytam0DOH0KSPz/7Xuo1TtZdlcaRHr3DdiM6e
 h/hqsxGiKK/4G640sJjzT1aEY8z8jB4vN1Z5YrhCWO1vYLK2YFkIl4ZN4JIig97yTLjc
 mO5hLhJcHPPXILwvsZtsgid9RfaKuAim2q/wxJsw4u5xTA0XrBxe9vw6SftfygsAOveW
 eF1TNGZ1u/rxi3zfbDv9hdl1kLPYKnWp01cncFqUP9z2IgIVPtSuynCRTPnkmknqLoxf
 1UpMIdJhdQ2BnVeMPImGnQI+BsdGeLnj/t3rYarNKPnSR39pP4shOkk/d8PRuDq9HUmL zQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=cu3RrlrT5VSCFZZWWV1OUBJt+9SQ31mR30HnxzKlvjI=;
 b=sXBXjBQFQw5AATFwms3gybsj+/ezqTBeO0PC1Qhs/whpG6/bYoDUtish/FMlv/ixeF33
 O095ZisN5LdwfATHJLXS3QneCMmoksRIcoSLF/Ye4mNl9jWzT5xcX0+eiHEjtYLMyUJ0
 +NO0dsLy2yBlfoJmiOO3Iis2GET363gH0baZLRQe941igp/X+VD98htqlMCYX7INTvHP
 HLb+WcWAF3R+M6yYKm1+5uU4DZRWxF+oG9q1EphemjimDYZPE3MawsvfSJKnwVlmhatL
 Ur/Kdz0r8+1OZFBxbu18tHH1soizDzwWqkAedbaRymYFMZ6uEKEKjjt2EYaykon2+9uh Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rw0k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f6LD097717;
        Tue, 14 Sep 2021 03:44:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3b0hjuest4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eI+HFkM81p49eLJuzN8YHX0h9G1PlNpkxFWGsb77splfo4Wm6gauiRMf5GFyYoXvkKhVQfeUzSl2cil9lNE7q30zujtD38XgWaYABvpEEPbMujd36FRQ/G7cl+9C05Wkdks4k68DpwCqhQj9MsX0XarZ8ijnfAvv8Pw1ZB6kbT+u+JKzzdzcsVYSdwk/N+fvei6NjVLJsRi+jZ2Z+acz4ITPEi+7TNwURAd+gDOtgcRvZFPEXz2uCTdag00CZEIbMWWgcKCEJgseyUJKHfhxyuIxqFW+84NDraZTuBol97A1sQ2G009FxN4Sx+Dc04SV9Zr9sU6EU5DjZdVDsflcXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cu3RrlrT5VSCFZZWWV1OUBJt+9SQ31mR30HnxzKlvjI=;
 b=Z/FB4rWTNm95Dn2otPAFO9G4iY3UAO+l1ie1QmppOJ2XrjxQoSnvee2ltXNc87DXCXScHjh0vFhIC6mV2N52GlCOp9GU4yxSGkZXxCM1joEbOugzQT9PwXufhpfsE/vZiR04ELL9hF/9hXS4DKTNxEqLjVPL6bhC0AqklbO92f9DhyWZFaRxaAsnjBKRCEyePdUPY9xrHIyFm4mmdoPDtJFd85HUyypjOUCa/kfMvYjvDxVDZOhxj/AMoC1jjbJANK/8rVT6zY7xhJvN2pSrRywf5mExVcJGXNiTEZb13DXwRugMcjR6+eKPgoofFZI/c0yIOJpbnnu9chb0dmmV7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cu3RrlrT5VSCFZZWWV1OUBJt+9SQ31mR30HnxzKlvjI=;
 b=CJyWYu/GMHgusfKfolA6nUj2FXl8bj7WsH81PwP0KgMURyAnZsupFDN6x8vN9Jtxc2pmgJcM+Sk2EokqM2xGD8kGM4Wra4bRn3q8P/SWATPBwZID8K9oPYzXhBZugMgYJfCFwE7lmbFtsleynyJi1o+/N8XNfe9jtTHe7FCbZQ8=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>, linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: clean up some inconsistent indenting
Date:   Mon, 13 Sep 2021 23:43:46 -0400
Message-Id: <163159094722.20733.7944616495273545485.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210902224215.57286-1-colin.king@canonical.com>
References: <20210902224215.57286-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 081a9852-dc3c-47c8-d374-08d97731e87d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502FBFBAD4A6431D794EB618EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kSmW3bsBnu6F38iwjB6uGZX3bXohnwqgDWgZHpZXBnsFfiooaDbqbkkENyd4Pyg+E56/kim114T8PgB40kBgQIplc7hYxqp2pb6g9J4NvS9uFMGOYwlUCyd2bkALTZp7neb3CtFERBQirggIg4jqOddo0pDlxLkrcAf37d8BE0jwdxIWjWnomWdjMv1mPNOTWps5+zBS/vFbN+jNLl82zersUKNst25e3yTQuCiVTzzqhG44uZKlTkVAWYIfhTA7aYPc+6uPA4xU9UaOB5VR+/0M6UkfoF21ZNV/Xf3AbxtbMA9INNoB9vtaa51GuEHywulZNLHylcqtRXEUSck4OYrqbeuGteDIzQepk0jLeBhiszy/n0MGgvUdNoRy2ShOnorKREt/SuG7iefcVheV7auilsCR3/HFTlK8T4zznyXK7KlOWLVpRdenjJjCqf5hWAIXc5FYrR39ko/Py1lGzhumbwyUHHStbkm0D9U1FAujlkJpIBjoVudaOQCK3fPSgAOwVDa6YlNqrYqRvjSCSzEgYzbHegioV9gY6KC5B7Dx7x5jo+6IGJFnGpIksa+qkhQQAonduK4sugmEtrNtbxq+zvG/1dpau8efegn98YNXDFEQVLhT7V2l7JlKqHzfpZsSNYwH/zoxnvepQZhelz4fhBFyNT8EIa9sAUX5lAa4fqYCmTBZGnY+4/RNRrYGzS8dGdix2B53xJqDR4fqvBpZETFXRiIA/XA7XIi8eaSWCScyNL8xYDC1uIC5tdPUg2f3iElQdAxMP9q3/WDktmdNWwEKbhubGYLilF293kETmngh+7g5Ekz+64yJNWgB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(110136005)(38100700002)(2906002)(956004)(8676002)(36756003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWk4QndPWlkvN0pLcTdIa0lhZjRHU3N0ZDhtbS9FTlZ1Z0p4UmU2ejZQejBr?=
 =?utf-8?B?LzNibzZ3NjExa0hudm5DYjRESlFkQTgwZmp0cDBBSS82WXdRQ0E2WC8wYnNo?=
 =?utf-8?B?QURyTjFVS215V0MvUG8xZVBsOFpxc1F6TGh0aUJOWG9LUjNkWnlqdXlIcXhh?=
 =?utf-8?B?ZmcwbkJJVk1vZGUzN1phL3VnbjNwMVo3dmtOMlpGTTFQcGZrUHdtN0tmeS8y?=
 =?utf-8?B?N1pTTEJYYVVGdC9pYzVlejNpNC9BOXpHZDFRc3RCWmd3a2x5M0RMakc1dDRZ?=
 =?utf-8?B?SlArRmE1bUVWMjBNZFFvTDBlRmJFRzBCemVWUzJxaHozcUg0Tzdtc1ZGY09N?=
 =?utf-8?B?bWJPTHlWWG1pbjI0d3pmTUdUZFE2aHowVmlnWXZkZ1BkckEzVm9JN3NFdkNY?=
 =?utf-8?B?ZFgydk5mZmFZa3pXWHhXYmkwSjdxaVlSWHh0MitER1B0dkRWYXhuZEJ0NmFY?=
 =?utf-8?B?K3JBbmU5ZmgwRzRsb3ZHMFY1ODFmT2trMWtJTytIZ3FpUTZ1Q1F6dWV3ZUg4?=
 =?utf-8?B?RDZXVGhhcEIyVHZXZmxHaDd4SFpoUCtBMjVuSVBRNFBHRUJDdngzbkt6QUZO?=
 =?utf-8?B?UFZTU1JGanVBYncycDBlditCV0NJRFBleUo3aVdLZUdXbCtYVFM3OG5tQ0lY?=
 =?utf-8?B?L2lSV2N0NVczTjdBSDZPU0o1ek1UN2dkNnBJMW5WOGhteXovWExqYllHSGds?=
 =?utf-8?B?OWJCcE8wZlpsM1Y3RnIycGs4Vld3Y2VpWThOUkNkeGZtRkYzeEtsSVNLWGY0?=
 =?utf-8?B?cXV4QlhDTlUzZk1vejBXdkt4cVNBK3hKNUc4cTg5K2UzNlczeFpYVWVsQXRp?=
 =?utf-8?B?M0hscTBxNjA0dXJMcEhDU1NtM3puSVdiOG5mc3R2Nzk1N1FFc3NYSzVBS0xR?=
 =?utf-8?B?d2RjWk1Qa0lDam9mcjFDYUxWSDdIbXQvOTJjRVR0c2N6WnUvdWhUbWgzS0hx?=
 =?utf-8?B?akpVcUMwN2hqWlFQdHY0ZWcwVDRUM3Nma21XWW9hTEpkRkFMWjR6RGpoZUcw?=
 =?utf-8?B?aUs4cU85ZXFZWDlmWUpGN0R4L0g1eFNNR3dkTGRtUXhmVTNINDZYNFBvTEdv?=
 =?utf-8?B?MmVUKytBNkZzSXBoT3A0d3h6cGw4MXgrN08yUm5xMTVkL3M2N2t2UndOTEF1?=
 =?utf-8?B?OE5PeW5lVmgvSC9qeFBJS1cxUnB3SzBmU21VVGZPYTRpdkwxbDBoUFFyYWFk?=
 =?utf-8?B?dEFWL3RRQTZlbzRUQmhybFo5WDZhUm5RZEVBb0FxNWFoaDZvQWRIYXRUVEZO?=
 =?utf-8?B?czdoWjVrN1R2YnpuTk42d3FwVnFUaHVZVFZsR1I5ankxN3pBZUQ1QkhSZTJj?=
 =?utf-8?B?bDdpSFhOZ2JvR3FqODdvdHhYU0xEU2hIaDdWV2RQb0RsTXRrZGNWUE9QUGVB?=
 =?utf-8?B?ZStXUTZ4V29jNlJZUm5tZVhWWjJvTzZkZjA4L3JmQVhEYUxDV0hQNlNRMnlu?=
 =?utf-8?B?THl6R0JodElEUVNFZjM1Q3kxYkV4M1dkOWROQmcvMjlNTnRFVXhKQWF4Yksx?=
 =?utf-8?B?MUU1THBLd25FZlhHNWorakltdmlveEFDaGZPNXNrZWZYWDQxV21iM3hNTlYz?=
 =?utf-8?B?aEVDT0M3Z0pDZUNoeHdsVk51cmZmNEJDRHcrdjJGUHQ1U2pQd0ZhdVV3RnVZ?=
 =?utf-8?B?aVhxL01WUnpreVNvQjlyRFM0ZlI1L2Y4RjBab3RWQTJoQ1NyZjVIMHU2eVBP?=
 =?utf-8?B?V0J5U3dsNHhoWEVubXpFSHROTi9RMC9nQXF0MTgvU0ZNbWgvN0s2d0hHTDNF?=
 =?utf-8?Q?Rt2Lw4XCqzufs+A+JjNNonAIa3kUDCW6YGhisGk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081a9852-dc3c-47c8-d374-08d97731e87d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:08.9011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+cCN63WxxGO0tjIDKS8QOwUgSh3tr/iW9/U2StEVoAKIgkn6LedX8cyPvFrRbZGGn7fEz3RR4RUhy4M9jE6VkulJFX8eOTI8QFNuMLWOBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=846 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: AoTJtQktqC2IfgxbIBMxMgXP-lDBtta1
X-Proofpoint-GUID: AoTJtQktqC2IfgxbIBMxMgXP-lDBtta1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2 Sep 2021 23:42:15 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are a couple of statements where the indentation is not correct,
> clean these up. Remove a redundant break statement.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: clean up some inconsistent indenting
      https://git.kernel.org/mkp/scsi/c/04c260bdaeed

-- 
Martin K. Petersen	Oracle Linux Engineering
