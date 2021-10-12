Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD6DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224FC610C9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhJLUhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8168 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234486AbhJLUhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJtV6x016786;
        Tue, 12 Oct 2021 20:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6JmGM5AhPqH0y3ZtYL0hD2kltNle9bzXOoNb8dF6Oj8=;
 b=aQtMZpsSpdL+9Qo2Nm8TUUTDFDNmPVyTA0eTQxHhmkjNl/hoBiFXeTrJ2RNEM6FPDeiA
 Ol6Y2ZCyl3nJqEbmC8J1HP63Woq2BxeeIlezjW/trySdeKVf34N+23ehGE81440dT8OO
 Ox+U5I/zBMYP8v9H/CbKFA6dgM9N3ci+FKfw4jeQVyNRpFHa4EInyQVRyHgZOsXYgdsK
 u4KZKqjkNZnE+tBF94WBnMytDWg31q7/m18LqrWxWWxninGJ8jCeBIs4Ki8T+zlXWi6g
 ClPaQ1MbRyJ+VulWc/ysEvTy5Zp5JAVvzXY8ug+53LW6LrbQaJ1vqAqYBmZan1CLD7Kd hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ7M3009545;
        Tue, 12 Oct 2021 20:35:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bkyv9jq2n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6hN1mXwuyvhoDiv8eZoJhueg86i4PoZViHJMpn9ZUdQuC/6J9vhV0I8bqbUwRyV3ChzkzLzMGHTQMQS7h2iZcwJJX+vtLBf+XEVLyvp0E//oiGZ7hT7To6RU7TnrCPqXMm1f+nQIfABTOinAR0hAKpprDmQmODiDbyuFEDaeVCbLd7cf1f+S8PB0KNsp+O3LHxiQgHssiRG1cweRbZ0lOB3eO6nTrVzAkrFMO3cQzJYgh3ufWeI+UXLOu+1SY9HP/mQLEd8XqLYXH9uEPg3jPijNGpzdwMweLPumtmjEm5vlUu0J9eR0Nefl0P9cpIYHTwof9OUohO6JxC3/6pOdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JmGM5AhPqH0y3ZtYL0hD2kltNle9bzXOoNb8dF6Oj8=;
 b=Bo0nLruQ/vNR9cp0orDFsjXUZlfN9n1qlNgfI0s40C2XaMhE7r4//aPKNfIxHsvNa6pdnl7h5kaHM2O2sXfJsX87kFYL8VuhW6raDkg1Xqb8f/Z5V8hM22C1e8L6ePqKvTiBmpnrZtmU9NLZGFA+2vwKUjOZMK1H3vR4uj5Re0cAhB4iyLSb+lZWOtR0LqJHS07Vet3meaGJLewBVeJLH4dHcHGH4woX29yWLuMSDuFQdAojFpT4ZBpwxKof52pXIhZGYRqvO4tk0HN9lyB9uPP7WsNuuAHw5wXRRE40lUm+pl8ZgoITMjjuQSzKVwlYpPoKq8EbTbMFTzl1G4lcZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JmGM5AhPqH0y3ZtYL0hD2kltNle9bzXOoNb8dF6Oj8=;
 b=eGn8gKzWRA6BFoTwCWDtjW5pl4+8GCLcv1zVq0UTIDfTW5tzlh4H2uigCY1x96BNzTr7FEBFKJobdkmKSavXouhxcln60zEgqLn/RR5I3Jht5XXJl7tYvD3qnOnc+bvyoaC9cCDaPXAxE6ZKzro7xPQhD91AsagU5VM32f1H/g8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: target: tcmu: Use struct_size() helper in kmalloc()
Date:   Tue, 12 Oct 2021 16:35:10 -0400
Message-Id: <163407081304.28503.15090852418195618906.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927224344.GA190701@embeddedor>
References: <20210927224344.GA190701@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac278099-7470-4852-7bf0-08d98dbfd3ac
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55144A5B094F184A15E2F7D98EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kta0cG6BxnpsuTuzFwXO9Lv/5X4Nj/ck06YyWeop4IrJynuNb66hfMBR/nUuhDo6hqp38R201W3hEvTBBOLGSNxOdt0wI2kfYUGR8s0qRxqTv+WZ7V2WRGVcqweyqrrfPIGuYLJ9223wUPh8zIPFvEixYQolpF98isCYx2ee3VUxuEtedkVhhgmMYkCRjQrdHODg4iZ7YxhlgG7rmsSTi+T0+7cd+F3PH/k599IBj2Q87N99lhAga/zFRVZ+k3wFTgIVBMIyJbX9AY+FxxW160+g0lU5eVPmPTUkcc/WRc6ZoGREtrzEDX9oUxe7OTxL0v3Rs7IXcRchXrwuV1yagN+7DkeRe3NvwsFBOGtpKTnt8Fu9qQSA6dhtCl9iI9CackTgczo+OGTVnQ17f6yZ0UGcjt7AupnUpCEoVvM+eZelJTuFrh1JJqagMVYSbcUIVHH389Eaxb1UR7in4rvePmhb5/OkBsEGsTlD+xkhWSTuStLKeVs2BHBswiV8AjJKQwTnsG8FPzd7e4YHxy620PVpxPYCLLY57nQgxGOeFeFbEIkkgv5eckd/C1hN6Id5PYPaujnTacUgT8pblBHjFPeqsHVuJQwG0rgajVWp9GlWCMIAzGEX2ECk9LTcoRkLuwrv/bF/p/Q7N571YErWcoejifHkpHrE7uzRqQxb4OjoBowhiyTyNtZ5ruvCV1xy7xPDxDW6FeQ/krNlQpVfRiG8z8yDEVXGDTbfuWCTFyH+P53a35mnn84UT40Y7JszpDPsykU38EQcIZdJSXdyTK4QdYuU+8s3ftYRJhJ9Ba8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(110136005)(38100700002)(8936002)(4326008)(83380400001)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXBRUUZvY1hkSy9lZEptak80SXJPNTlmb2pNdndKTVhlZmkzQ2Q1Smc2Y3Bt?=
 =?utf-8?B?Y1RteGFadlZEdURaSC9WMnpDK3JUM2dzMTM0RmtQbzk0U0tKN1dDUEdKTTdz?=
 =?utf-8?B?Y1c2bFRkMHBCOTJZeGpNcGNzVVlxcVJLME5nRXQ2aTl3elBnSEIrYzRLZXhz?=
 =?utf-8?B?cnI5MWRsb2J4Wnh0dks5KzFFNkZ5aDR3bFRDTjNldVpOU3NrSnNkNHRVWjlv?=
 =?utf-8?B?QmZPNWJnTk44MzJQNy9tYXVSdUFvZ1ZwcisyZkNya0I1Tk4wcFRFNENvZWVD?=
 =?utf-8?B?MEtKYnU2dG45ZU9zMDNpeVlhNTVpZGRkdjN0bTBRS1dDYkxPV21jYWpwY08y?=
 =?utf-8?B?MmJ6VlRmeCtQUGxZa1hGbG95b2krb1Z2dXV5Z016eWVnaEplNTlCaXh5VlNh?=
 =?utf-8?B?czdSRldzUzJlOFU5ZWZMOCtjUnIvVkNwM0FiYm5ncmNNOUJrK0NhZzZyVWJ1?=
 =?utf-8?B?RWdZL2M1WlorT1kwamtJMGtjUUllVW5jdUZQWjI1U0FoNFFMYVV1bzJPemll?=
 =?utf-8?B?NUkwU0ZzN3ZxdXQ3b2Z1WjdVZjc1VmZYbGUwNTZoVlA1N0NMM056cS9tVGx5?=
 =?utf-8?B?azVvZ0thYWpTVVRNVlA2WDJmWTlSRElodTh1eDJiK0hCSExraHE1cEhaTnY5?=
 =?utf-8?B?R253U0g2KzJaSE9yaTdOTnRXQnM0S0JSaXM5UnJpUUZOU1NYRTBCSlRzdHBD?=
 =?utf-8?B?YytJQXZDSStsUHFEY1g1eWVva3Bvd0J4YmhreXNvN3RuSHRRRU1tVC9HeUhB?=
 =?utf-8?B?NjNQV0dxUVA2bk1NenNrbURsNUdPR3ZrTElnRWhuWTlKTXRGRjNKMWdxekJF?=
 =?utf-8?B?aVZJdE54UU5MeXBMZWt1U1N3a3VIUkRLTlRZTllTbWtsekdHSnIzdDFySXhv?=
 =?utf-8?B?NTZybUxPUWlJNm1jeXJmSkdXS2liV0M5eG0wYXovQ01mb0ZOV3FxeUYvTFIz?=
 =?utf-8?B?SzhPRG81ekMzdXVhY2lrek16aklVVllNTEQ4c3hPOU1jaHFjVDI2YnpES244?=
 =?utf-8?B?ODZyL2ZKTzBKbkRIVkx2RjBpWmIvWnlaczM2aFEwMWU1ZFBVYkZEUFphTUVq?=
 =?utf-8?B?UWtoUVVPV0xrVGFvVFowMDZ2dmVFWlBuWjhKRkp5cnpQSlJENjFiYmZrd2hx?=
 =?utf-8?B?TEhiWFVTN0J3Y1VBL2NabjhheG5YNXFRNTJqb0lwWm9hTmluV202SXN6ZjV6?=
 =?utf-8?B?S0ZLcUNhbURrV0pvTXorL0tvNndnNkN6NDZvcEhxejJGT29GWnJJWVlFNGQx?=
 =?utf-8?B?NnNIQklnSGhsRFdEUmZoMzlHdEltZlZtVHcxalgrYmV3UlB2N3BlMDh3Znp0?=
 =?utf-8?B?K05xWW1JeEVCTU4yeEhCNlgzV3U4NytqcG5ucHo1cStsNGJ4VS9TcUZqUERD?=
 =?utf-8?B?b2FNRUFxLzR0SzVHREgvUkMvRzMyRFJwZnNtenhha00wbXYwdzJZMnBYYlRt?=
 =?utf-8?B?aUVWaUxxMGd2b0pBbGRmdVg1U3hRWkJPZ2FpZGlkMnpTUGowNUhPeGxxSjJC?=
 =?utf-8?B?eUFtVm1CNWVtYnVBVE83WFVVZjN1N1JoRXdlemllcjRjblNCZG5zT2lCTW1U?=
 =?utf-8?B?UjFSS0gvTmJwdDMvRnpGUm1tYWR1K3BaYTJzeXFJWG93S0loU05SbmV2THUr?=
 =?utf-8?B?V00zazZvWitsWWRZOTlSTE1HeHRkc21WUGd3QXFHVkhBM2lEMWRZVjg1TWto?=
 =?utf-8?B?NFUwK2RBcWxsUEgyL1ZyOGozYVdUdWhGOTU5d1ZjRkxXNDhuZWYwNUtwdUdE?=
 =?utf-8?Q?IyOmxkpLNiaJooa4RhIikitEuhOcmSTLFEQeonv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac278099-7470-4852-7bf0-08d98dbfd3ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:28.0974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Rxu7QZMPpS85i36Zior/t+bSsBIOgcKv+6NlcOojKHNIpVt9nXu9cDNhgafhM3sWFNh6CcfNcSBbvrebCInmvjklvfOum/biio132bL8+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=825
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-GUID: 7EWBxQIPWSzovIgItMUGkuXD4TZmePON
X-Proofpoint-ORIG-GUID: 7EWBxQIPWSzovIgItMUGkuXD4TZmePON
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Sep 2021 17:43:44 -0500, Gustavo A. R. Silva wrote:

> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows
> that, in the worst scenario, could lead to heap overflows.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Use struct_size() helper in kmalloc()
      https://git.kernel.org/mkp/scsi/c/c20bda341946

-- 
Martin K. Petersen	Oracle Linux Engineering
