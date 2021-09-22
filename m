Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6C4C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E1761156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhIVErE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28306 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231704AbhIVEq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:58 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1put6021872;
        Wed, 22 Sep 2021 04:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FnlHQ/DBeQT1SMpdiuGgL1fY3Y4qFLCJnDv3incBVPU=;
 b=EoUdV0rhCX1jtW/KyOplE6hzkQTe1Tjq9WW1Gg3OqWdaxXTz60CF9D9QI/4H2omoh+5v
 kLK76m/sAepn0YCgjbKToFZdX2cwrB4ovSwTe6uG3w3r2ro+Tb1pEKmV3WnLhiYm1C6j
 WA9y48VKCPm06o44IhWSI4qTZkLy3qpJjM8gauimVPz0wGfbfavIdsI5rcJCYH/fQ/tj
 30cLLIDBZ1dLfRltafTyG5HmcxD36Ral51q6GoBHzW6iqnTx+kf7ep/Hatzx0xZwO3XM
 BYCT/pkL5ocn8uuYcHkdZDnFkygFq2/GptWrhfEko7jbKc86kaLtpW89wr3IQx/hvEAr MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p1by2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:44:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4a0AT101596;
        Wed, 22 Sep 2021 04:44:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3b7q5vm9dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:44:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRmdkheaja6tz16Ljcp1nJsvfr+C5vQr1JQ2Rfy4HQxM1rGa5f0HBl5VLSiJQuq/9i2L8XyBXF5DfUt4efB7SAz++YSJxTd8w7ETUcSJBVVSLjIyLBhEi2EcXCx4lihCqg5cLdicOpHKqj5NvSXFV5REFcMC/LkYAi9g8XrxSnHqrqaV69FixzjErf+Ft6PO1TpCprDoMIKm9NmV687zHX+EJASoV8C8f7IzR2Osxf39SUea05tjf36ELaa82cKRZ/OVU1Gw4fd47dIX4QSdGtg14fe/cUUoQdydw4jSiU3vPTI1spPOtqMT7dJbXebzGph1+3Icdmp+e2wdM4p6ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FnlHQ/DBeQT1SMpdiuGgL1fY3Y4qFLCJnDv3incBVPU=;
 b=RGuprjiSI7yX8B5mehY08yqZEVleFpodBS2YIlvLP2WBbvlQH4iwRPltSaw7IOvBN32SfBgnpb6ZT7YcaaTHGqkltvOac+cMURRB9IXytoBA7KrMaJ0IwSsGIRQCGtg23z7/xXYK7WljSqM/6m0Dh1ggQfYCPhuS+8J8rLBzx70tJ1gS9lRjgsyxVsBo/0Yv6rxHl3R0N47m4uMV2P1W3OHwZWPI5LBktGaqZ5hFSkeqfUbzbOpZUVtvbuYnYPKjM+VHWmvujBKOqq2aerSPWIwfe0jG1U0Zw8qqeKI1x5bRNVRbNvfxGfreeAmcJXnRW71hhDlMbyS9YGKVjM9APg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnlHQ/DBeQT1SMpdiuGgL1fY3Y4qFLCJnDv3incBVPU=;
 b=MhA/oh0pcFVPNhC8f1TCGRIJm1uJKyzaI9zF3/EFkGj1jTA5I8JI4sAI24tX9etb+YbCUI8mztGF1zTLoYbdUj8pH16MouIYLJwYo1xCNYfXDNbSuw8NXSuNdYMvuVo6YtMD86LagBuGrd+T/6nrhE0SWqfNm9b1FJ5T2P1V4oQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:44:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:44:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Wei Li <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] Revert "scsi: ufs: Synchronize SCSI and UFS error handling"
Date:   Wed, 22 Sep 2021 00:44:43 -0400
Message-Id: <163228551950.26896.8778051355757118484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917144349.14058-1-adrian.hunter@intel.com>
References: <20210917144349.14058-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:44:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce468465-f029-4d62-a1c2-08d97d83b996
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44392B5112AD30F1FB4337FD8EA29@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7EGcBLJtMvDYTp5vyUVN+//4YBBvCTSeVMCMdWRrylYuub9d+wgCesj8LSzLnaeXQuYXdy9JJPyP74f/FV9r2p32AIaky33ui8Zc8CowKoBpb1L1pfnEykeISofvhl52LZX+ebeS9F8KHBYtLi08ZTX/tf4DzYtzQlEMuQuEFo56yTQCEIKenUrmkP0xtoWGfJN2beFxtWQntHN/e7QF5x4Aj/uEhm8wholYS5VKUCMaGG86Y7N0QPYALlYGHus0Ngm0jrwAOMehJCqlrS1y7H2Yp8xtE6X/8mkP+CADy0kFRfPf2dFAv2tdIW9K33F5qFWhK+POf9SeDnagGwV8odbisD6h/z7JctgfPIwDkUCkOb5D/7fPjfjduSxC07b3iyL7VHlGlOiV7iHR+mkQ7i7XtReuSlk+cs541shAh/puQ4KJwZft5pbZfMQaIDQ2UnXWCLMWZMVWWl9vbkhCU5S9KlErBVuDEA6FIhvgv3jLLhw8VOYaO4U4FCg0XZMRcaIG9Zc5OEDW1GG4m7ejac0dvYS8gehcO+1wC9L8xdvBUO4s7AyoItK6AWG/peR2gAgJCpaJyfz4f9JEE4KDTkjmd7wwtEO4EHYKHGgxEuWRSzwZBNCsfOvsvJAoltF/N7X4QGU8OWLgjHFV7E7soFCFC6vcCYxMfPopwxFkxsgtDm/+EuRNzMpZwiNE7gBFMzmvWM8n6wMKZ9/Uk9akv9SMMgHnhC45VuUnB2b1zG1Vgyy1sfHQpdM0/qzGcIyhgnTuLM6esq29zM0CnLbNDzMkkwO49YPJMTPjtNY1Vpc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(316002)(38350700002)(38100700002)(4326008)(6486002)(26005)(8676002)(508600001)(8936002)(2906002)(86362001)(52116002)(7696005)(6916009)(66476007)(83380400001)(54906003)(103116003)(5660300002)(966005)(66946007)(66556008)(2616005)(956004)(6666004)(7416002)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFFYZmV0N1I2UGhkTmN2NUJvSERWN3JiVVRGZVNEMkhMY2NNUHNKa05kR0Nq?=
 =?utf-8?B?S3FNNDlqWWliTFhGbDkybzlycmtvZ1BxNDIyektRTjdWbEp6ak1NYjFPcEVx?=
 =?utf-8?B?eHk3NGxQZjNxdDhoSEpMeUdsVFJhZ2hJaUpEbWxQYWNDWDZ2cURXSEJwSkZI?=
 =?utf-8?B?cS80cnBERS85QTlpcXBWbDVjYzNpQnhJV2FmUitqS1ZGNW4xMFErZHg2Z2RN?=
 =?utf-8?B?S1JQNWlNcjV6WUtIcUEvSC81WllVblIyQUgreWlrTDZvT1BHT0l2Nll6NWdL?=
 =?utf-8?B?MzdTMWo0aG5hTmxrOFBoT2ZGMEwrNW9lVms3NXFOZkJUZWVvRVhUTENHalg0?=
 =?utf-8?B?MGhZWk9CVWFWUkJ4d3VWQVNTQ0Jac0t2bHFSSHVSVUcwU3ZYM2xwU0FQeWph?=
 =?utf-8?B?a05Fa09qc3ZRaTdtajMydXZOOE1JTithNkFaRDFUbUtLWW1HVjhOcCsyMlQ3?=
 =?utf-8?B?R0I4dXNWOUdIaW9aRXNBd2VUVG85d0hiQmF3SGZnczZzWEtkSDk2OFB5aTVt?=
 =?utf-8?B?OHhVN09tZWFQb1BqcHVzWUFJY1ZjWTNvbmdIVHVLSHJKTUt1Z01qYnhMck5H?=
 =?utf-8?B?RjR4RVFNTE9Odk42MzVUTGZZM0VuM0hQQitNRmRGYlIzM3V5by93azhvTVhq?=
 =?utf-8?B?aVhzMDl4emhOVHdDQ3pJWFEzZTRnNFl2d2tpYWFjQ1Y2YTA0WmxSVi9GS2Nr?=
 =?utf-8?B?c09Qc1d5Tkd6Vkx2V1ZvL0ZTZmVvclNLL05BeEkvelRYK2xKZmUzT2VwMlVh?=
 =?utf-8?B?dmJ1MUdXa0tabHlYVi9rK2Q3a1RZYjFMc0lxNlVPeklzMzhoYzJJYVFDeW43?=
 =?utf-8?B?YUZieGJ0RmZFM3poMjlrZTVDVlk0UEJjU0JVYXYxZXZkdkR5em1pdlhWVCtO?=
 =?utf-8?B?VHJ0MjgrTkNtZFpRWk5oanllMmFROGtlTllLTmwyZlhEZ01HNmNsSDFFV3hM?=
 =?utf-8?B?K0VTemp2SCtjYVlnaUhDYmFsS29sazFCbVFocEtsYmQ5ZWt3aVFSZnZ3WHBL?=
 =?utf-8?B?YW5PWXZ0SUIxeE1HUkhlVEppN2FDQ2NIWFN6RlZLWUFHNmdWQnZSZ0ZvWkVD?=
 =?utf-8?B?djNZeXcyemhpSkgrNHkrTlZzbW41aTNiUG50VGZGVHppamc1c0hJekE2NmM0?=
 =?utf-8?B?cGpEMkJUN2UyNE9DV0QreS9SUTBuWGNWMXdpWktnalpjOWx1RytWMHhBayt3?=
 =?utf-8?B?cG1GWVJIRmVKVFRzRHNQWUwyV255ejRla1YrWVk0WEZ0R1B4MDdsaUxPTXFJ?=
 =?utf-8?B?Mm1TWjc4Nmxva2lLQUIrL1Q1WXErY2pXejlXektIWFM0emdha1lmdklRYnZ2?=
 =?utf-8?B?TXhNMlQvM3ZHYkN5S25TMGRXdnRiQmtYSnR2RXNXZnlCdU1iLzEvS09XMlhR?=
 =?utf-8?B?OWg2djF1ODlSOWUwTldyeUJRb0IyUEVpY3VhVnJQTno1UExxQTZxbTljcHk4?=
 =?utf-8?B?M3h4dUJkUFhmbkF5NGhCMm45eXhTT3FIZHlnaWh1MHVFRjdUbmpRZDgxamNw?=
 =?utf-8?B?ZFhweUIvTVFHZUtzTFpLZHNWZW5GODM4a1VlMHBTaDVZS3d3Mnc0ZDF6S3ov?=
 =?utf-8?B?VUdwQXhxS1NmTDhQdTk2Um5TczNBY3lhVkhUb3BrVnlwNTBUOEhwTVVFQ2dw?=
 =?utf-8?B?ZklTTDFGeXBvZE9iQ0pUeWxIMEI5a0I0NEwxY2lVSWdocFhnWWEvREtPNTdz?=
 =?utf-8?B?a1NWQkNSM0ozanBvRWJvaW1vYmxxL1daTWt3OUZHeE16Q3Zibjl2b2cxWG9z?=
 =?utf-8?Q?tHJiQ/3ztvZKEKSjVW/gpnBz0kzgGA+N9OCue/T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce468465-f029-4d62-a1c2-08d97d83b996
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:44:55.9063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jp2cG689a1Cmc2I0vpVExw+s2cF+JmJRiN/NtP6ln3QIAKy3nqOKAkPMtC+tevZCuFbUoKGvtFGO5MzmGertCXLaO80NpXjQWB/UDWu0bNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109220029
X-Proofpoint-GUID: thNOltrIGaPf8tPjopG51fJhTAE5FFp3
X-Proofpoint-ORIG-GUID: thNOltrIGaPf8tPjopG51fJhTAE5FFp3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 17 Sep 2021 17:43:49 +0300, Adrian Hunter wrote:

> This reverts commit a113eaaf86373362b053279049907ff82b5df6c8.
> 
> There are a couple of issues with the commit:
> 1. it causes deadlocks
> 2. it causes the shost->eh_cmd_q list of failed requests not to be
>    processed ever
> So revert it.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] Revert "scsi: ufs: Synchronize SCSI and UFS error handling"
      https://git.kernel.org/mkp/scsi/c/88b099006d83

-- 
Martin K. Petersen	Oracle Linux Engineering
