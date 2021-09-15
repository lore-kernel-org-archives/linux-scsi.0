Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D067DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D8A611ED
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhIODRo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:17:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49522 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236149AbhIODRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:17:43 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2gnTh018578;
        Wed, 15 Sep 2021 03:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kHJEpHZzsfBqs8M7nM0sA5UhXh7ota6p+dCNxnjLC1c=;
 b=RzjifKIBx7cpJhKB49piNNOwuUErAkb2SHR9FRf+1nqkHtygxjd0bawMIIs3gHira9vu
 m8z6dwP255qip0ucj8pFWqYAgkBiHa6gkTW3V1P+fozugIofDyfCjpeBdYzM3JS+LG/g
 07Plgw/ANRIQbhLRnb+SIrQv0JKRydtfNj2Y5car2sTB3gY636wBHAVSKrn8TxgwcvFb
 tDm9VaSQUlKyH7kfd+SbvDwJMQPO8JrdOMiDG8UoyqdZC7ysgCiAi7tXECgx3duDcf/d
 F1KmTkOjwa5bQmNOtOOYoB53rP0V0QEFHU8A74d3kteHQ0q40TQEwmCJYCsoykwSAyZl Yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kHJEpHZzsfBqs8M7nM0sA5UhXh7ota6p+dCNxnjLC1c=;
 b=zEfh2xSCllxuvHg3QdS7uJvF9UzYAoDbql6hMWt6D5HITjk5NPDQ8DsvZsqHjFsZlJXr
 MnnC4LU2RJkSDmG2oah3nMBr0sdkJHBBhzNfomPRRD0IfAZvfqTELq01DjfV+5ofRQ4q
 X830c0Zz09Zv4H+FftraWFB5TGmIEqN+CKBCTENTpJGFweVLNo5D7CPVsQxYdBu6WEe3
 LfamSrDJeWKD3uv3I/t9Ey9s1pDGTvx5/oEF/FM7azvsJuKH+h+ok/RikJi1wGcb2760
 xDUKu/BzY1AmwN5ectBXTwWyEEalLVBX0gT8Q5X1XmrRmmW4wNBmOADsS47PqbRvP17U tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5uuc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:16:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3FWDW119709;
        Wed, 15 Sep 2021 03:16:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3020.oracle.com with ESMTP id 3b167syrc7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu50dyu9bWMLOi1ZR72JdzxML2352yLxLO/eslYuZWsbKO3N+81Ppb8HuOy8ERLWvMcvJo36iNL/+HWbUptCeuMic3OA/03impxd/PL93RxGScl39N+x9jQr3UD/EY7bmQCUGNZ147P6Mdfrti56bAy1vlgEilmgi1x6KQv9GlOS+osLIUfOoDt7bzze2u0HiloMgP4iBFtaypBJZnEwABUf5eRbb/SRUrp14gPFkrx9AzhMfaTJFcwvPiSsr8Eo/Q5bAAQ9hrJtDyw3FFM19OSHyRzKEGbJDfMNaOAn6ECTq3uZ+DL0m49DrDLreM78CmslgihBccaBrEAzrNxaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kHJEpHZzsfBqs8M7nM0sA5UhXh7ota6p+dCNxnjLC1c=;
 b=PLdQL+CLaBmjhqlfKRG+2aNga9adZ8JNhN14ob6mdCAdZe2tBWKp486C77tQ395s56hQ9UFutl1zrCpTByMj7L9DdJIormBHhvpVh2UPcZgDcOWtfD8dUA8+6ULhMonbi2IL9ORDK8waj2eqqb0IkO+JIxnvZN70VYmpG1XEk3V/+01vyGrTa/9LqKTlqkhNAvvEp4LaxdnEXHSiz9ZGFwWT8ZCNMPNPDjD/jKPpGBGcSIOPkzD7buzqx4x+9qXy/iwzctQE4R5bVg3PEdP8JkY7N+WyjG2FRjhAwpcs1O0kjjtlBl5zopPaWxUzWr8GJ+DYH9nfjje0MxcOEXkztw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHJEpHZzsfBqs8M7nM0sA5UhXh7ota6p+dCNxnjLC1c=;
 b=y0p41X15TIAi3ubhX+4mR7kRSPgNkGHPKLqNbWNzH4I/W5VgDDH0+z8JWucKGVtxUrynX7AP9UFpZ9MFWkd76MKg4ZPAdhm75745/yjMQv0CKtwhXLMFjt8Yif80ylJz5v5XNLzdGv40RXYD3RE20KZsFM0CdpgtGIQRJR1ZChs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 03:16:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:16:21 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/14] lpfc: Update lpfc to revision 14.0.0.2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilz2wmtl.fsf@ca-mkp.ca.oracle.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
Date:   Tue, 14 Sep 2021 23:16:19 -0400
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 10 Sep 2021 16:31:45 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0002.prod.exchangelabs.com (2603:10b6:805:b6::15)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN6PR01CA0002.prod.exchangelabs.com (2603:10b6:805:b6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 03:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69bc5e33-d355-4653-469d-08d977f73133
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB541742EFFBC4B3CF1DF6D31A8EDB9@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgDcOEUj1qpmXSQ3Sy85YFjR01vWHsKl6JX9E7dOJifuLlmBLBIhXDqUjXD8r2tboV5PKmvIVXTkLpsX91vksoDF8FxYTjBOieoxI+XvbOCmRNptnfj23068goD2TAUWBDfU+lhXJcC83ijMw25t+QcoUACSQ419ioBiYpPSVUL9GJLhRCpss9vRZaI+NijjxfMRktS6eDXvS/vOKiU8GgYaliGfEbnvLxA9ELbx2A3AeaTwx/rlrISwzgrJ2rBqvIesK7UbIFQl0qMI2kAWxIRCQOzCvznUrXil126tszIrmyxqnt8MyTUGfXi4SzQNRDV5QHcSeJ5fDNKDkTEq8o8jgLX3xT/17z4r4SGDItif88EufD55x966nqcNAU1cs1CYUH12WqKy2XCL+Ml+MszZ1HiBS7NzaEF30e6bg/Z9MWLKp0OJaJaqczhgzwhkYlBFO7F6aJX+0vXNiD6gXC9K3RyghucSL6HxcFzzfw81u0iYwP1MeFXWDkvOYzJEWpJmi09H73GSXHDCq6ZB9fpqBBjfY6isuUgEneeeeR/rYwf0QgekjNe8gKR9eX0t52j6Me6P25ld144fqHu+mBsQefgaMwE20L4hLGfGvz4n+xGXfrvY/2m+MjPDDDcg7hblkCvR5mt3JlUpBbYeFzQ1CM63coiKwpEebYD8vp82yRoYBD6G4vcouExLekDG/wCoWzqOhsBZT5Iaopu44w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(558084003)(508600001)(8676002)(52116002)(83380400001)(5660300002)(4326008)(15650500001)(186003)(66476007)(66946007)(956004)(8936002)(26005)(38100700002)(66556008)(38350700002)(86362001)(2906002)(6916009)(316002)(55016002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OmbhJkBhv+YQzQDvx8rlwNMBdluzYU0sj1m+Np4hJ3DV4G7gjyGCDh/iQAZz?=
 =?us-ascii?Q?K3qfUq7vceWkTJlg1e8DmAH486q01WyuQt5CiELYED0kg1lJ9SFoEUr1jEqx?=
 =?us-ascii?Q?1itcz7oCOrmS1K69wUqIUP89MMmNN4LpZxBvy4RICfP+X84cKQ7MGm+p715V?=
 =?us-ascii?Q?X3vh0lWLp/pElaF5yJhjcQeaHX2iDRtofxzinazYON03czEJIP/iQib5qtN+?=
 =?us-ascii?Q?9BY41XFgGuzt50R14BqlOj5GJwArkU2SavxFfAbsXk/OrcK80y5F4GYlE05w?=
 =?us-ascii?Q?Gta2wg2dBqF+viLSlnHiT+hxVBSY8oNIi2XPbt1FrHteBTqgeACgZPSrIBR2?=
 =?us-ascii?Q?oPpK5tLLT+YdMSgcO7hDGHtfrbs5uTU/fr4PKyZoqXYuvM1zSJG6MTlZG9lg?=
 =?us-ascii?Q?qoBGZhD4aSyq8MfM35ToGWoUiVL49IT/s++7klBtUbeZi2OF/McY7ileZQ8d?=
 =?us-ascii?Q?i70PxMXdKa+tPFZyfk6ytFyQ6SDBTR1RRcrXZpVm8L7HB/Fqnx87+o5Y3XAV?=
 =?us-ascii?Q?EHeq0WMyevR5zst9kvEOI30d6yXSS3nowzLrMTpp/qsEdQBmeoHd4SAF5Rwm?=
 =?us-ascii?Q?Dr08rsUrZw58NfOE4/Vw6c56BYqcxtBKUseYmAaumrwMd4B66KElqFWrf1bL?=
 =?us-ascii?Q?3xz7oBB0ZmJhpx+xes7CVCXbZfNsFgytxOCcdvLvKfAjf0ysnJm9nS3Qwv7q?=
 =?us-ascii?Q?2Aida8w9fHvglwvyC08cwlH58c0/8GWQLT75c0R8m7rKrP5JQNR589ZAvlqc?=
 =?us-ascii?Q?wz6ObPaS4emHeq7GRfkNweD7ZV8sGXmG43iV6jayH6RETKNjOT+cK1lxm969?=
 =?us-ascii?Q?yIAGwn46Ccy3qk8LvxmBKIRxy135ORSE4j5rcw82gG+wQUeSs+HpNTcjX3ZF?=
 =?us-ascii?Q?yANEgQF0np0ROCF28ba5c8Az+HD70cyR+8okh651Groaf0m9fJUHGXDeQjrp?=
 =?us-ascii?Q?cglaP0/6trrPjnET422oRkqAz5erTFJzSNssNjKi6jupI7YTHYZ+reVyyahc?=
 =?us-ascii?Q?j8TX9R/2hpIrcFHnmFvZhSwkAUMG0RbEL8LOt7r54v0gZm/3rXYJ+LQbNCAE?=
 =?us-ascii?Q?/1andD/lCaadLepsENO87zCFAnX+CipXq7MhDAFbZQGtGc7a8p/1Yf50wslF?=
 =?us-ascii?Q?M3kW1ZvIpbb8uI120I2dLPkMgc5kt9S3j9aVzHcoVYtr/n3G0wjzPwk+1dV0?=
 =?us-ascii?Q?56GD3H8d2tnS5mM0lSE3sGnVbMEh4RoH47DEXhjnyny8Ff8U+MR3rqJpwALS?=
 =?us-ascii?Q?obUkGkuewQ30XRJVoY1td29qsCyZrcgIFy3JDcik7E3TdFsyx4Fs5WzMI6ZX?=
 =?us-ascii?Q?dFp2fePLSC0oAsmHu2VtM5N7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69bc5e33-d355-4653-469d-08d977f73133
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:16:21.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBy1tN0125hUr2hPRJB0ylQJLqbOeuYN4GwtnGtemjO3DtprFaRMetCIMkqoUR9v7jB4oWq7Fu4VSZLLVumbjgJbzi0KpJXn6u6JRVfU60o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=878 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150019
X-Proofpoint-ORIG-GUID: iR0dkNI95DgByXZqQe_fvgpKICcmiOXU
X-Proofpoint-GUID: iR0dkNI95DgByXZqQe_fvgpKICcmiOXU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.0.0.2

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
