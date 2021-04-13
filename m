Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937FAC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 04:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE096120E
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 04:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhDMEwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 00:52:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhDMEwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 00:52:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D4jXvv068137;
        Tue, 13 Apr 2021 04:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6eq4oEvPiEf9Sf08lZVeJ+920VGVPJTDCpZkBBlVTCs=;
 b=hmCmsfqr12ImaqTFztY6C5Y3yDg/B6BWgVH4huM5avU6JyKHkwVF0gzCPpUIwwuIoUzJ
 d1n2NV9WaMGdRla+7sEBJO+9W01/lIosTf1HK6IPVAstyyiAB/wtlg8Tu7S3TZCF6500
 ucZpEHESI1Rxg3Vap6bx21ES8++7LKMFshPzhSkjDNJEkzh9C9gu4AJ0WbnRxMUp4fSx
 PQiQYOCDLjngBwgbGwMZD2M/D08dXS3xH3sFCGBtqKKbUNM4/G/ZnHe8tIkQrr1RO49u
 bQ7IVHaUbNDNEAFZlyPb/nd5QsJarUkcx7j0iExumnvi7uzatvtO1wmQndjCGGJT8Wyr fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nndqgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:52:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D4oJ2Y111959;
        Tue, 13 Apr 2021 04:52:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 37unxwch0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJAmqLvrUoYjhz/8DdSD20vonKzyMzklGA3RLkBSzhpoPKgCbTjOu0wUhdriVdR7PLARaRxONICbCweNK4UYEpTZZTGkQHW5qztl7InNTBo9bJoFmVR2s90csh/gaKRgTcB29RCNZ6ex0D2zbaKL5i2fs69E/7K+oHpzufveBVoGK0v0APoP8PbRyUF84MF8bJYSPRL5kXIE2cvdxxdV6jzjMqYxlCjk+TNHoKiwyoZUZFaeztr/QDix8aFmQUs+Nmn1m8ULSgqH5b+B52DfDRQEv+QWuYgP7U6vTo+7S0Q/b4J3DHiaCtGCHJBPjj/WEte547K4sCqJERU8BzxGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eq4oEvPiEf9Sf08lZVeJ+920VGVPJTDCpZkBBlVTCs=;
 b=jMLKs/wSP6MIPhR0NciTRhhtyWl30xzg7yyDuxOjAMKtITx8zQeBUlbvLBow7bn6E9hoW5vMtsOpAg0uyWdDdYF3fmxFbiNjcfFDxvKg5XHB2Ty6QnlzUMi11f052RWJSREN1A6i4wPEF7VxgdJpj44JvYQhKuoI0Db2woBF+Yp7CGmX/0Qu825QH95c332VhB7MkCdBrfi8M0vYSjZNN/mdFffLMEeH0OdXpypcmgWamwrkOQOC2laJLNJtJJT+Bo0Q6MOpukaeU86tfdyM4BsmIsjo5f//xc7KKgM6AiggXWVTyA74Q4Q7tt8PSvcojGTGBFPC+pzobyQR0dJOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eq4oEvPiEf9Sf08lZVeJ+920VGVPJTDCpZkBBlVTCs=;
 b=Di3ZYqbfW9kLsHtYLgViol2oJ2wBYlGZj1oqW11jxfDMnLDUIcbFmXoeVIHhdG49Om7L7CHJDjShXGQJf151c5VeSsbV/pDbouMH2+XU1hgWvGTW1LyKZhdW9RUXtkxVsh5MU5WpqPBgtoZOBFiQFEMahxLpAU8RIrigt/X5fhw=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 04:52:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 04:52:19 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ka7q68.fsf@ca-mkp.ca.oracle.com>
References: <20210304203822.GA102218@embeddedor>
        <202104071216.5BEA350@keescook>
Date:   Tue, 13 Apr 2021 00:52:16 -0400
In-Reply-To: <202104071216.5BEA350@keescook> (Kees Cook's message of "Wed, 7
        Apr 2021 12:22:52 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 04:52:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5409df9c-b585-441e-0e28-08d8fe37eadb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774A6DE187185CA43EF9E7C8E4F9@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QKOhm8B04NPuzn0huQr00WJYwzlptEWSEE4OSCqhrYuJUEUq8I8Nff0iVe7oYYtEMI6fUZE96997qSw1DoZeIwMLolex0LnDdfQR2WvRD/O1SOL2dXZmu5qGuaamki02L+HUV32P65lPsUWWWLlbG2wnpp+mgvlKOLts//rG74alZX9lOn5eu3Jv+ML+rUU3ZntVJM175sWnDmBxVbJc0lgmGwGyZ7OAgQLB0j/uGyH/wuys4392qiCeXwX1u3b8+IAOFgJJsj9ijeha/DRhACVl0nstvAmFOTgf+lY2pIZP2xgP40plRf9b6DHw55V0iEo/KetY35qTj0nyhQyI4wWZCf5IvT1omgCL544bMKBYEguWW4RApDluo1HhNUGJ4IM3TaYM0Z/jpN+5REItLGMKdCQ7GGtQoyFkPF+CjveXCyUXIOq/GZJIMLC7nrV4noie8IQggfAHa0e+i3B19KOE0ix8oDZHUMYBH48FM/QHAWDdZvvgsIkcO9eFWZ8wqHK0M8VjerSFFnH1Zh66fc7j3CrCrXjuiWCx2jjLQy8bfVvgqbDOzpXbN19vvD+KNboY0dKsV2Uny7yBzzzIQK2EoIwOXtvcxqzUF+A2L9nQmS9H+/xdOx9C19aHQkQifpKfioUO9tV01fQfmZwNCtV01S1M5rXUZ8uyWAeKapE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(366004)(39860400002)(376002)(26005)(4744005)(478600001)(66556008)(66476007)(55016002)(316002)(66946007)(5660300002)(8676002)(2906002)(38100700002)(16526019)(4326008)(38350700002)(186003)(83380400001)(86362001)(956004)(54906003)(6916009)(52116002)(7696005)(36916002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pg1blMOHhp5AH/yK9e0+MYNQx8qn3t/A/Xo9/2fBqWQXSQ3xWwcRAZg+sNjt?=
 =?us-ascii?Q?DmDmGT4rjSCIgSJlZJ2DTYe/tRDDj5mrj8P0lzBBrxxPstr4OqfXyKa3jOWm?=
 =?us-ascii?Q?JPYUjItiVu/dGpcfB8W0n7tStX/UzU1wEjuLCXERTGMtI9vcvDYZ8YF9/z/H?=
 =?us-ascii?Q?rmKbcmUJN2W3eGz0x6f3bZ41CYOBKbah+jkEpRx624VHBFrN2eGvAC0MG0qP?=
 =?us-ascii?Q?HinqBF5r8+sFEIiGJ0vWVxBNLNvcV3Cp1SzP/ue9qYQ4KfGVpGYfIYwn4sis?=
 =?us-ascii?Q?lJAPxpyb3zGrOSJtLeDKlAwBMOi1UqejsOMUzH35kcZS2UEnYth01vYfqiAD?=
 =?us-ascii?Q?e7L8h0lYJeHD9DO0Qt9FiET+wxfIe1E6RXgePTEs13FWofc93lw+0aL8vHdk?=
 =?us-ascii?Q?+AVwT9e4W8xEPi7JpY7hRV0oPLaBhY9p+wk79W2v/UIs055aJrTv5ur9yh5p?=
 =?us-ascii?Q?TtUxCa7+0WfgfMS8QIKXgK32B9EFe89kdYmWmjupnJ3UsqfwM7MR+vKKDMwb?=
 =?us-ascii?Q?fCnpDRTIb3eo/qboZAnBGxqy0Z53cHeC8ygjwLqC9vZgukzJQAfdDshyo5OS?=
 =?us-ascii?Q?kQiD5n7ifdSFpPJH9UOu9xuhSH63ZDBCZ3LewTAuqMOiENnm+Z3tT3CuCqsA?=
 =?us-ascii?Q?vohMITphwAUkzB/GfLGyE/SMVmcJB+z5I4N5864x/crP9kcLen4ru7+xeBbB?=
 =?us-ascii?Q?FmX0NMg1AppxcpzRJRw4wXMn67qnPf69TkSlB44F0oiGdR86/RSXpGCf2ft9?=
 =?us-ascii?Q?UKmJ/d0Sdxj6xgB567f7EW8LD7qTFYUpovXjQn6OhkL4UnH2IxFAmo7HAOdJ?=
 =?us-ascii?Q?MIROlVPDW3T4elbu6VMZwu4aDaTEOZp57Bnz4eXNf3Xw35lcgXCtDR8NAbJD?=
 =?us-ascii?Q?kr8iuUojiM9BqdwlPBhJn0K7YhMDtoIOwOOwWsNys/NKVsQKgKCep+ylEUUT?=
 =?us-ascii?Q?v9lRNgQf2vl+z2uaX9hnaK8U1CaZZ8D6jM91hMH+vFNBBkfA1mKGWL8iI1FD?=
 =?us-ascii?Q?vgcnupneI6EA9ycCjnRNH5UEd8BR24sUpHxKX35Ohhpu0PjQI0bG9QHqKZdl?=
 =?us-ascii?Q?eDrqO9ygogxRlP/8FWH4/Xz0I9Xy2Ah8IGczMMCx+gdIF8hH9VcSyA1xoPQP?=
 =?us-ascii?Q?OLge5cMesNrAyezxaK32tudAZjcF4OmAJYfWXeSJb9tgaaJ87HH728CWziWU?=
 =?us-ascii?Q?DwxZJgSw7k+2+MJfBhVDL8TgMmq9RtFlzdXSgE3sr24v/oxEhicBfdeWexZU?=
 =?us-ascii?Q?y947OE4hbGjgCCJDuciHBnPIXI6VMBRnZa7T9x8qxiRfIq8NPcGX1vRlgWNG?=
 =?us-ascii?Q?T4GxqiHE65zu+0d5BBxmlgo/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5409df9c-b585-441e-0e28-08d8fe37eadb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 04:52:19.1468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1txcgvyaTdQaAn7TqwI7oS8VFtn0mGhzlNz6OeHmQ259EZJYtQkg+TKfwrAeCJoJPBUo9nhVdGuWTpr3Np4Yg2RoVfSDXSXoLEtw0XX1As=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130031
X-Proofpoint-ORIG-GUID: GNbMjlXz7ddO4DkzAqjBK_Tmbh1GXETc
X-Proofpoint-GUID: GNbMjlXz7ddO4DkzAqjBK_Tmbh1GXETc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Kees/Gustavo!

>> @@ -4020,7 +4020,8 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
>>  		}
>>  	}
>>  	sge[pos] = rio2->sge[nseg-1];
>> -	memcpy(&rio2->sge[1], &sge[1], (nseg_new-1)*sizeof(struct sge_ieee1212));
>> +	memcpy(&rio2->sge[1], &sge[1],
>> +	       flex_array_size(rio2, sge, nseg_new - 1));
>
> This was hard to validate, 

... which is why I didn't apply this patch. I don't like changes which
make the reader have to jump through hoops to figure out what the code
actually does. I find the original much easier to understand.

Silencing analyzer warnings shouldn't be done at the expense of human
readers. If it is imperative to switch to flex_array_size() to quiesce
checker warnings, please add a comment in the code explaining that the
size evaluates to nseg_new-1 sge_ieee1212 structs.

-- 
Martin K. Petersen	Oracle Linux Engineering
