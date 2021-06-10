Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4784C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F7D60232
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhFJEDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:03:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhFJEDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:03:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A3EwG9148773;
        Thu, 10 Jun 2021 03:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jVYsibgo/ZQx9K4rT/zXTH1072Y9sl8T6pTetrXwSiY=;
 b=T7i93RA9Z2qxkiX7cxNlUFLxgvuPYlT9orz+8FVAYp3hu7NU+2YeIjbQcF6HSVJ69IQ5
 CcWCZTyaranh5aupU/7aHtZ/H+2Lmr6NDkJQVI7x53QuHSc8gpffuSCzSXCCPfJsc80M
 eaFhxCXqRdLxbACAIc5f5EQVUBa5D8mVx+0HG64Fa7exKpzu41yBXJwiE4BtEpSV0Ct7
 lh3wZ+MqYBC0ULi5Qnebk2sQNokWQYarnsddEEbECvbizXq9eKD0KlFP6RPUwN2Uy3Kt
 rsSXhEEqcAcHCNgi4pnSsV1654AUSE8orVavvv8BL2qEipe3me1DOGr/WVIqm0LJXyoN ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qus7wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:19:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A3B8rI023196;
        Thu, 10 Jun 2021 03:19:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 390k1sg7j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:19:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJPL8sEl9rQfGvQfkrBe57Q17tQaIkeD4oMtLuuVq3HcT665VMOGoBpVP0z57wNXZEtGrswrJ6u78+SIgKYueBq0MXd2lpGEZ8NXAhp+IaiRsnKf7paTFjFYO/hO+LGuHu/Xi5SzLALZIBXyGG22PISPLdeSdewOQ/DmgOkc34xq23kLyemesLnHIP2RdLOQBr+09+sDZwFgVU2DtFwwq3u0dIValZn74LmKpgXhliPaBKyCrRM9UtK5BFmF7c9pipkd2UhUTcsO5aIcTNbzbwiZZixC19bhRNdf+wlLz1XRYfkiW192OFce6sN6OvQnPoBrp/PL+JqPRPin+zzjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVYsibgo/ZQx9K4rT/zXTH1072Y9sl8T6pTetrXwSiY=;
 b=UrOd83AI//ZzxzJyFAbPgzL8B7AM+sMHwW5AD2QVd/kwnd00MUZoRIY6vSEwCRXCSYhhaIEpIKNkS9WCGpXFsey45Xsby3Ufcc0/m871OkBlyvJ3VhPHi4vlgcj/fG2wlyKM0k3cmLSf+RgLMx/o2sfojmk4il9kyD8r6oa3hYQQaYlGcMuym7sQjIT/JABwcYZJK7Uo+P/xOoKdQvMiQrTYgdCHOhfrgsQyNQwKK5Og2SlP/QLuaVypcnLzMvuMLwx8nVgO396uhm6XKVLTQDMtk/SwIbNS5K4q3mh5Yv4Xrq4ZuazXzfPhmuWm3NvBlIClwLJbksPJKXB1JjN0Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVYsibgo/ZQx9K4rT/zXTH1072Y9sl8T6pTetrXwSiY=;
 b=yMRhfwsHYTg1KS7DYyi+Eab8d1Mzl4mKAn9qL3CcTmXtnPELZjG2MqaaYSNIvbWdB/nVxZYO6wgNxn2i+7K3D5LduS/8Gq69p8A+sLoR18t/oGz73fLidg+boZvbOUgh6EL1N+i6leEADEdqrvUKBSehurtw5OSNbEQyU2NPe8c=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 03:19:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:19:13 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 13/15] scsi: core: Add helper to return number of
 logical blocks in a request
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im2mflzw.fsf@ca-mkp.ca.oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
        <20210609033929.3815-14-martin.petersen@oracle.com>
        <a3687cac-dcc9-5579-5767-d211be505625@acm.org>
Date:   Wed, 09 Jun 2021 23:19:11 -0400
In-Reply-To: <a3687cac-dcc9-5579-5767-d211be505625@acm.org> (Bart Van Assche's
        message of "Wed, 9 Jun 2021 12:58:26 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 03:19:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f816544d-c69a-46de-d13e-08d92bbe85b1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45499B62C0DEE33EB7FB2AC98E359@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uc1DOO1KVeaonMAImlwNIavFVDuuqfPBxtr9puneF61uMzmEL222h9cUw6OG+juPr4+fR6I+1hre2bZXQyhhNAVGROgU7aj7cG7AjlfM5aYcmAwcOAelmclZy3yIflQoO9BxfxBcQWgEkwmhnrtum1n7yPLHQmmBuUt0NaINtUsNx0s4715NnUpWctNGV/FIzcUe3uN/aMWSaq4t7cCpU74TT9tzA35OIjJesKjbgBKMa/oaEYqOU3zamiXylfIIlAUirfr4ePNrin/aF5uVFGv5T4twvAeyF9MXWi5cKmpa/n2oTFetjziwxPk/Q0e+KuEqa0DbEdnUf47EotnXHEcGoam31Lp82XqqsIgo7tVWjxcdX//1WNDj2N5HE6AHZ5tsRB6GBw9jI3HT9GEHedsyWPTZdyag/TjXwRrXF5UvlnMrmXKEtHPHWTdgGDtpnoQGvZkOh6ISK+Jk0cP/CiuBMG852VgmWwVpoZr2bAHh/FNp95n0sM0xrP0pBtV3qNctdnyJulrSM1fZDVQ3tGEdxVG4U3TwAvz99vivJZTJ5CCnmVmcUIAFIpXCD5Qp52KTzLu6hJTzdRd2OYvnkUHLOYXmj5MWEi1u7VdxQlDsQuKBltbZNvNBKdOObiITCxl3NBgQGnmwznJpHlEmeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(136003)(366004)(6916009)(86362001)(478600001)(8676002)(8936002)(38100700002)(53546011)(5660300002)(316002)(83380400001)(4326008)(16526019)(38350700002)(36916002)(52116002)(2906002)(26005)(186003)(55016002)(4744005)(66946007)(66556008)(66476007)(7696005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZC3XHsyQTXVsfDv/BICxbrBwHBA3B3inNGyx8hp2BBnTTnhwojAIQ/Iu+rC?=
 =?us-ascii?Q?7EDQZ6fh1YFJRrmjZv4omdeecr8mKQOiU9VM2S/xd9RsPXpogJrqknhAxDnt?=
 =?us-ascii?Q?4gwPQSUGOwuUDIdUmjzl+AJ7N108EGuuYxBwvD8n7BrYBGNnisnpL4sD1eQG?=
 =?us-ascii?Q?cbpA8HYp9lk5R6/tQ7XYaG8tRfrIcEWHOh4vx3RY0VXvoqKJIhBSUcF86PfC?=
 =?us-ascii?Q?99ahIEX6YgUdpZS28xbp/5LYklApCN88qdUrqtGBAZVgtdaUXkMUMxpQboB5?=
 =?us-ascii?Q?O4N9U6bhav3QMWRvDk+No46GScE0Dr71PlbUQ1miaixaOH7GA6NEDR7bwmz4?=
 =?us-ascii?Q?4EY6yOSXAdV4Lna937DkaAaY5Lv1fXsmuB2VFt6WBRkm72td2XpQCSnluQit?=
 =?us-ascii?Q?XsVFy8LJVg4fyadWcz73chBeHLWX5xcTUm1aLQoRyUjW9KIb1lzs/OFV0fWr?=
 =?us-ascii?Q?RFn1FLF5nL8CF+EiXEBtSNjUTZ/ICVF0Ee6WxKwnK78YyJRwbf5vy9WgYbMe?=
 =?us-ascii?Q?Dyr5Sli8Azx+YNKQI1pxXIkPXofuuG2G4zss44uvhi9iDDmG41xxgR0RWRlg?=
 =?us-ascii?Q?nXtsUvtyF/fCiz2cLFBEJLdziiEhD4NMWeujH4SYfI/4RL/70oisJutudFwd?=
 =?us-ascii?Q?ACIzAzRNOh1v+T9/wOLDMdf1O08QUJu8i4FD08oj5AXllIPz/39lt2jtcDR2?=
 =?us-ascii?Q?Q3DecDWjxxnmTfT5+7BCoGU+nKrmgK3fJ+I+YmiKKVzlsXFq3osB7pF+jYF9?=
 =?us-ascii?Q?1hhjVfMaioCrtRXbzQOlxWZ6HRjqLfZNeMdO2tT6iAdl/oBBCVk8ync8g575?=
 =?us-ascii?Q?gIHPTeoWCJQN4RjfpjF1pfpCR4iOy1ZEma4keeE82B6rknukLMyEh+gCUDZw?=
 =?us-ascii?Q?IsZrwGsOBTE9VutM5vwblpQGq6SGVvh/OffywHHmgorEhJznNvl/JvXT+m73?=
 =?us-ascii?Q?mVMbdbYlt7K+V34AGbc/ACBBcv+jlvL5EeepwWm3wXueHqjpCbIActb7O0qa?=
 =?us-ascii?Q?bhhxNFMpoYOuo2F14of8EOEvNywjXmr9uePZTIZiS+2y2D3Mus49w2AIk4Ex?=
 =?us-ascii?Q?G6I1NN55ksvlcV/ZMLWU58QylNJcwN4/Y7mYSus8d2uiErQifpLcrSipuJtv?=
 =?us-ascii?Q?tKePQpn47WiksSQBC6e11n1mfyXPmjA+4rUkbpHzkYTWIcDvUllegy+UXaWg?=
 =?us-ascii?Q?eelXSs+duGCJYeEd86m3r3UR2SKaaU0d1bsVm14SUKvtFE+ggNeUw1E3gXGt?=
 =?us-ascii?Q?wB3xJyHkVR5kSUY1peYYHVVDlU8sBd9t4k/lY/x4cNf0jpwK4LXfg/MIM8Nr?=
 =?us-ascii?Q?YQA6ew8Pko384O9QH9YIm8c8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f816544d-c69a-46de-d13e-08d92bbe85b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:19:13.8311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KjhIasLtVVanTp4zyhqd/bauCKqK8Q5e/0a0aCoKPH8zpv0ygb5Dn+wSot2iG91CQv4eUUif/0ee4m/hBg+nF3Tqjp5KsePdfFmk4Qz6H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100019
X-Proofpoint-ORIG-GUID: TWlw84ZGpt62Tc4yQorXcIENUl33OsC_
X-Proofpoint-GUID: TWlw84ZGpt62Tc4yQorXcIENUl33OsC_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> On 6/8/21 8:39 PM, Martin K. Petersen wrote:
>> +static inline unsigned int scsi_get_block_count(struct scsi_cmnd *scmd)
>> +{
>> +	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
>> +
>> +	return blk_rq_bytes(scmd->request) >> shift;
>> +}
>
> I think we either need a comment above this function that explains that
> the return value is a number of logical blocks or to change the function
> name to make the meaning of the return value clear.

I went with the scsi_get_ prefix to match the scsi_get_sectors() and
scsi_get_lba() calls. Felt that "block" would suffice but I could make
it scsi_logical_block_count() if you prefer?

-- 
Martin K. Petersen	Oracle Linux Engineering
