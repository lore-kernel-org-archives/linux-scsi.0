Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2A1C4743F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 541E961278
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhFHDHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhFHDHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834jQd001598;
        Tue, 8 Jun 2021 03:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=br5ePXZhOQtVHhfXOKK2XM6uvPr3PGnn3wOuoKu3kns=;
 b=BBr5bOP3ceJuPI0D/Uc4b/cWamd7TDIp/ucUYDksWbRFXUdb96F4dgf9SCpPb1zlgq4m
 oZMBf+ecS7fnt3ZZHrB4X1vWJs7g0DfyRehJ9OssA5AmLzQztULicp5VqgwCNXz/YpLh
 LY01AxN4Zd4aWVFvLdekvEUfX7iVW+wYl6IDmJQCDJgAVv4uziMn1SFFc0XG/Jt2S4zw
 3Ce7FD5hep1xgqo723BOyS+healP4v4LG8cbA4Njzxi9Z71Hg9GCc8wfZJ/ERBtrgPqm
 IckgB97/w1VSK0zz/f3j7fROe3NJt7fJOG+SzPd++EciKjMvJLGdK2Dt9kKbN3w+pTsR +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 39017ncjmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834pBn084955;
        Tue, 8 Jun 2021 03:05:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 38yyaahxx3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fR4eD0AtTXANaCSI2hFDOsTf1psKnWpHRt8gXK9K0ydTAREXDs5Om1hbfgfczCBxL2ZvigGqX19J9e9OIiFvAXO+YwrWksrIhi7PKy+AiF93r6LDh+m/3gi7gD1xh24IJ53oHu4pWfoDFLtPMV3HH6vfRWvUUFad2iSxeu1aamqH8JUfMiS8xznG5t7VGbRtoetEUAhAsTmXvcaTIitL5LhOZ4wKZ0sUucX/zrGwhbfuLS6vJRpVqmbN6aUOClkcGCsIPgiCTev1hx+pKXpZVIu0ZyJiE8CXE8itombE6041XYSdospAG9bVoG95ERDP2qtXGI2JYE9ydaNc3I6pMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br5ePXZhOQtVHhfXOKK2XM6uvPr3PGnn3wOuoKu3kns=;
 b=BGusMJRVKB7l0O7UkPPwoNHRY/SJI8q8hAC7TIXHTdfkOU1utQ+bwzGd5zZvPk1+v3I38QXb+jhozgj0ddhn4X0qAFg+x82IZBY6YTAdN80mX/NsCvQBy5REPSSnGJdPxSujg1VqR7NINR/H7AwwpB1Sc1O8hWMrbYQxyqZlCas8ChoXC1aFBW2Qe3KZpx5Dcri4MkPZquiANBhlwNFh5I3mH9m7krMa+DumhHOTl9lTBOvcSZhbCwteyfiHRZ0y3PcHc9yKYe4e9UZSOdoM2nIvMS0XwebI8t+h5eBk7mVS//OCNbQGbQzEnE4wePhh52LhjQGfRPIusU90fHOrVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br5ePXZhOQtVHhfXOKK2XM6uvPr3PGnn3wOuoKu3kns=;
 b=Nsidys6JwMinlYEQ8rxaQkpY5QDryU5QvcXqjUVgQd8ZJSt1gd7fjiJW1VGpj3BQqQdx3R1wGBaIOolP7Jz/Fyqf2NQhv1fGuG8x4aVkCPAMC83nKdbD2Z/RFhvSBvKMV1BmURjz20ums+/FimcGyjS63IpDpfFyFBDpYzLtYTs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] SCSI: FlashPoint: rename si_flags field
Date:   Mon,  7 Jun 2021 23:05:26 -0400
Message-Id: <162312149257.23851.16460562737804756307.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210529234857.6870-1-rdunlap@infradead.org>
References: <20210529234857.6870-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0290d15-ae4c-4c86-16d5-08d92a2a4acb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44702F08B440F6D09AF5D23A8E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7uFmx/q8ciEQBUp5RNItJ7hIIeBuL9OT3lEq0JTw6uQ3jPj8EcJimfkN/gVF9Wzn+wy/na6R4RIALW9IIHALQdlpzM7NDTV7Q3y6GcxyyBTwjuQnHEt7MgkIqvTM3yWGEqVZeiU5176MHzdUxlJV/O5LxqmKfGeEwa6shstUorT3zCxT0xbOKi8KM6QigLM6zP5cX+BGo8YCepvJ/PQ72I7xAtRIe4EAjVS1LBk2Oi7odJeenhNiY1H6GGbp8L+ekiF1VTbFRm/DVbd5blXsFLZsH7aNWPwwgT+1q3UKTTLtKxWhnNvcyJeZsuLoEq3/sa26q6xODbYKFq+8OgoPgzztIFoD86khgyPNnY2u04tEjxQ+UGY4GQaI972OlG45E4p1c41kk18V277rDM0W0QiiiPp2JGBmxVUaRVue+XoBRhEoeh+Gwwi2TjYltw8RyK776sXjJMM1o3AYsigNCV24285yAx5nMhcRsZSvQLXUDmXuELD3+NBX6DuQe1x2UqVnfA+iC8e8EdClPcNQMu587ySnpn1IkZf5rKcly9BsFA79cL+SCBPMlC+CgHuaUF7j28S9oG8K/T17PDK90qKfV5t+tbgyJDU9iP8qfoRPbBpbjzAusvclgS3OQVMHCNp/PjmfByThrF4zTFFbxm2BNKl/RRVqbpuJ2naGAWu1zUbFj+WGMqVCTptxmeQ6KmsN1XNwAp8Jo0WSIN9+jWtqNQ1hCfpOoetsBJGYQaLtLBjxixL+xN314M1NYk3W9Tf535ccgCQe+ODcmXBy9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(6916009)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(54906003)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDJFbkNoMmRqVWNuSHRRdm9zM2NGTWJhb1M5RUs1dWRqYngwOVdsdWFOUC95?=
 =?utf-8?B?dngxY1Q1bDlQK0lOeUJJTlkvMzl3NEcyNW5zYVlIeEoyT1lMdlA5MTZaYk1P?=
 =?utf-8?B?YldxMi9wSHJVSXlNWUMvN2ZtNi95WCsrYm4vdkRpYW1XdDRGUFd4SmNTUm5O?=
 =?utf-8?B?T3gwVkZpTEk1MnRFU1ZKNy8vSjNRaHV6am5jRlNXM29BY29ScEQwSURtRWov?=
 =?utf-8?B?ZE1BM29YSlBGRGpFUEkrQWNCZmZhTXZ3NU10RnIrVGttcTBJZDJlU21JaXJM?=
 =?utf-8?B?UU1xZnBkNEtLSFlEdHdsbk45YnoyK3RPUkM1Z2lhODZvRks2SHFTQkhJZFVQ?=
 =?utf-8?B?ME9ReXlrWFBuNkRkZFJRS1AzZ1RFK2FmWTVZc2NIRExJWEkzc0dvU09wSTRy?=
 =?utf-8?B?bTRJVGE2R3N0Q1BZL0VJbENRNU5zS3VUUVB2c2IzQno5NDYwWWFUcmE1N1hW?=
 =?utf-8?B?SEptQTZCeHZyenhKVmkvSlZGMWFmRXU2RnNYRmpKVC9aV29tTytvUmp0QWd5?=
 =?utf-8?B?QVdhdkFTL29YQXJ5amxvWlFmM0RvTjFYNjIrMGZPc0V2bnJGUEw1OFlDTkZm?=
 =?utf-8?B?L3NRK09qaHgyQjB6SktpejJEQzVTbHlEMGdSUUsrcGpoaURTK3JOUWtKRFFT?=
 =?utf-8?B?UkdrYjdrT3RrSEJYUnNvS2JHSnZmTmdHeTBvM214aDF0VHpXdUJzb1VwbEg5?=
 =?utf-8?B?eUgzQ2l5Q1hacHNrY0ZkZE44WEJZa1B6SkdSWUFQSjdRdklYWENLamp0OGl5?=
 =?utf-8?B?eGxoRER5TjhJdStCTTFxRlpjcWlFUDk0enZFYU13M2tBbk12THpudWR5OUFX?=
 =?utf-8?B?a0xmYW9jMUxBMnZPVDdKY3h3MFB6ZWpvVjZIVkNEYkx4RDNjWEcxcy9PTEZx?=
 =?utf-8?B?c1BmV3JHeEt6SkdJaU5Ra2tJeTRveFR5MTRJTzZaS3pHYWtYYnVBbytkL3d5?=
 =?utf-8?B?dkpTVnB6VVp6dE5VWVBzTjVxUnZsa3ZTejh0VDRJeG9zMjdHWGdRMUVUNTI3?=
 =?utf-8?B?YlJwZm94Nm9jMUROZm8zUkVSNjBWVXRXT2NpQURQcGY1bU5lTEZjbWp2L3NF?=
 =?utf-8?B?T282bHpjUytsRyt3bzY2N3hQNUFwa0IvcmNsNUtjaHJicmZ0amlYYXRpdWtp?=
 =?utf-8?B?M3F5eXpjU0M1OUV0Tkl3TjhvbXhHZTRrVEhXY1pxRXU5Mm9KamppR2RwMk9V?=
 =?utf-8?B?dUtTdUZtWXlZZVdONDNYNGp0b2lERGg0UGRYcjRDcFRVVlNnREFMTkpiRTF0?=
 =?utf-8?B?K29UQVg2djVFK01aLzVxODd4ckZQMFFmbFBqM2Uxd1VXaWNoSU5xU0VDaHpC?=
 =?utf-8?B?cVNDYzFRL2phbDVybTU0MURpcFpYeVRCd3c0VnM0Q3ZSaVUwRi9ZZHVxNGhY?=
 =?utf-8?B?T09VSXg3KzY4K1lCbHlmOEsrV2I1WXBGNzYyUEluaTJianF1cHdYRUlTWFN3?=
 =?utf-8?B?SUdWZFBJaGwwd1F3SWFpUC9zWE9FbW5tU25Ja0I2U2JpdmtKTnJZT2JWV0pF?=
 =?utf-8?B?ZGxaSXQzRXZSU0x0eVk1ZXA2NW9YQzF3VjArMGtCTi8yeFg0QmY2R2hnb09M?=
 =?utf-8?B?WFZLZWtSaVZNQlB2MzdXTitUVmlFNnNXRFZHSzZLVkdQVEJKMmF5N2NqTklV?=
 =?utf-8?B?UXpvc3JJNDhWYjBQYjJMSkhCNHhaSnY3UzNnN3RJNDJzVVVPdzdKQ3NhcjNT?=
 =?utf-8?B?U3JyS2VLeWNxN0ZEdHNZT3d5VU1UYzJNOGpKVDVVNEdUZzliKzVyTC9ZR2V0?=
 =?utf-8?Q?aR208a++OwuiCLa1xjj8kji8ilCWh+iH5tazsn4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0290d15-ae4c-4c86-16d5-08d92a2a4acb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:38.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPcHyoIHOoghSgwucwOc6ODqIdK0Z5F2T8CjBPmaAEStLXwR1mxtObLXvbCgBIw5lsbzgQhbQZWbdO4VJTDMAabMT1EkCrTgRFIJHFVLliA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
X-Proofpoint-GUID: M1QEj46Mjo7kgoJIhMCWrkjmjK64gArc
X-Proofpoint-ORIG-GUID: M1QEj46Mjo7kgoJIhMCWrkjmjK64gArc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 29 May 2021 16:48:57 -0700, Randy Dunlap wrote:

> The BusLogic driver has build errors on ia64 due to a name collision
> (in the #included FlashPoint.c file).
> Rename the struct field in struct sccb_mgr_info from si_flags to
> si_mflags (manager flags) to mend the build.
> 
> This is the first problem. There are 50+ others after this one:
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] SCSI: FlashPoint: rename si_flags field
      https://git.kernel.org/mkp/scsi/c/4d431153e751

-- 
Martin K. Petersen	Oracle Linux Engineering
