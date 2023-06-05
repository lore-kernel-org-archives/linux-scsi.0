Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB54C77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjFEJ6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjFEJ6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:58:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5B1D3;
        Mon,  5 Jun 2023 02:58:44 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 354N0LHZ016174;
        Mon, 5 Jun 2023 09:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=uWWadoV9FrzV1kITJb4uukKeO0c4GhmTMsBipLgekAo=;
 b=oMwx9Ug0deYbNAJtUl523kj1S7X9MSNJbl5HLYDrYG+tN+0yroFkZ78D31e1CnFMdmhT
 rP/0GaLo+jex1hnkiun3SJesulZnvSAFGyorI5WVcfImiAkpmEH0LmBJF74m2cziWO4R
 0sKTDZ5CZYP+6OqTsSMGyGDT2jfmwpe2am5op+VJsigPOzgE9SItPmC4knKP761Jo5HP
 aCi19uxzNvoSG7rpXya7JFlZJAT0JtnJO/48fBwscewfyTFH6hHkZ1BfZonGROYDJTdB
 rh+/o1KAqsaauu0Oyum3sg2B3c7ePceq4yyB0edI/hMbXDsDxYYxea04jDaWd/fJJdHo vQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx8s2k0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 09:58:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3558HMh5020106;
        Mon, 5 Jun 2023 09:58:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tsw0p85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 09:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbBf7GV56W04CZPSk5fQSvZydY/rJ0aFE6bq7/UrBfvANa1jS77+UkjMHCy8xPsE9tHzEs3azokTPd4bTQhU7Y6YS/Ol4DcAhJMyAKDIyEYHwWtivlzvKRgwaEyU9NPMxeQp1iTtDrBBom3Ug8u/uwQ5/cGK5Nmw8zPjg4PJEq5iUWbEcVql0imGbfuUNb1Gh7m6FPjCyFbG1UsomL3z02MY8cleWBxtgHYcc5gvlSsPAHK4+iCZXBS59hI0B2iGTu4j4vjReWw7tdTV8nx7hlQAjcq6juOWj/4RgPRnxBpZ+Blpb8DpxozRbv/29Ej81ucgZJZ3bTgoECxRFstfTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWWadoV9FrzV1kITJb4uukKeO0c4GhmTMsBipLgekAo=;
 b=hssqIFIfDe8v9E2X9nQf7BFN6maeUs0rBTTF1XgYZkExlvF1uQr9xhbdgjPLzhUsxTAMY8u+GJh+iNkm3m9UAV30h6OuadP4BwaFpGV7lmAHCUObsI8jj8/Is/BN/wtDCydYaZKxb+AeEYTjN6QyeJph2BOQdVKdRDxv6gLRcoG4vwbBpiptZIgR6Np7k16P9pmgoWZv0cxCaf4XrZ6ZQPhfFintXmVdzeIUtFKSzlp4hFeyEDa0/l161fZdZU0b277bWXM9R2LAEbvX7TzapSpGDencA5uaD+fD9ndOJatBzqlBiqbWG3RrPeA3A/dpltXgOGyf2WsVRqQA36vCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWWadoV9FrzV1kITJb4uukKeO0c4GhmTMsBipLgekAo=;
 b=ANzhPoJfPs93hiyHIaoWc3ogiamO2biJiVuM/o7WYS+auheLs0H+5y9U/nBFFBtHaUCdk1/rzfpCLdk7J9Q4NyDg3b/AR6f10KU2HJpZHoPxZQU40LtTmfeB3rGOia6fgGy2pRF8meDGQgC8n/FVHZDGdlnCj2N4tSitwscapzw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5023.namprd10.prod.outlook.com (2603:10b6:5:38d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 09:58:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::acef:9a5e:9d29:17c2%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:58:32 +0000
Message-ID: <0b1a036c-d71b-3c6c-56b0-67a7ced0834e@oracle.com>
Date:   Mon, 5 Jun 2023 10:58:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] ata: libata-sata: Improve ata_change_queue_depth()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-2-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230605013212.573489-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0483.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5023:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b7b302-0310-459a-7b32-08db65ab6b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Ceavs5TjNhdpWxcOxTLtoSdAk/I7pIRtfRKgA/kK9nO5uqxg4F2hUAa6i8WMjUWef9PWJn1oFiiyqxE/y5PkRTXjbXKN5J2oigDTucr8fLrXnf9/vbnpHC+IwnLpPvvHjtl5KvUWcb9hi8JzGELu5hzZgjxC1MaJbCbk8uVH4Ba4oQgG2s1a49GLNZV/F+e53NbNYBmFVcfn/9lkfIkF267bdPc0BbumhWj1F+OVHdHtOHUIC20it+FRmmZZVXePt1iHwR3QKlXwkurBytRDjYezqV3blFKzFYNeS+KLHhj5OZ0LRrQbNhjkNEdHnC9uGNBrxYHV58QUoeKRMjmPueVDpRhhlIHqwC7HBHXIr3gOi64lI9lJa62GThzd6BgxBZLCu0JoIJPCdo6LriUOrXMig0CItWO1fuDGbsVcGbR45wYsFlo5RilalTKAGVL+M9aQmkf7p3Be2QjmWZqSAHBtphEmKUcflMf+ArujlA2RdAEhz4z//38OUkJBvGp7YOAAapf6azakHuQcBq+7NWSKD/AFy90qFjB+AHTJQh4Hv3cGFRg3s52rUAcNF3Ix1Nd9jXvkwXJ1k8x0u8d7l49KN3iT5HPaIvy3ix6wEFWFta1DGsfPd5vc/XS1vW4lqE7QEwrwdG1/jCfK+1c9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199021)(110136005)(478600001)(8936002)(8676002)(6636002)(4326008)(66946007)(66556008)(66476007)(316002)(38100700002)(41300700001)(2616005)(186003)(83380400001)(6666004)(36916002)(6486002)(53546011)(6512007)(26005)(6506007)(31696002)(86362001)(5660300002)(2906002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDBld01BU0ZqekpyRElLM1JkV25TWG10R0EvYjRSN015bnUzWjRQdlp0L2pn?=
 =?utf-8?B?TVU0c0JXdDl0dUNBRnFpNEZiQzZDakowTHBTeTRYb1ZHZG5ya1U4YTkxMGQz?=
 =?utf-8?B?SmV6eXNjV1BhbGJSQzZHemxYSXVPaEJqd1FHaXNtT3ZtVnRMSFdaR0F6bnRJ?=
 =?utf-8?B?TThOMU9icXNqNzBMbXh0eDFiU1VyRTROVFVZUUpxQjVSZUxHOTlJQmFOR0w5?=
 =?utf-8?B?V20vY1ZaR0hDS2taSzk1ZG9oSHF0R2p0YlNzM2xBYUMwaklYaXV6eFBvbWZU?=
 =?utf-8?B?K01XS00xRUY0TlFDaWJscnlyQWJzUk5uaEkxV1N5eEhrUWt3Z08xUzJCaTBh?=
 =?utf-8?B?YjhjV21RUTRkbE50KzVmS2QxajV3Tk15Z3JlUUZ2NmNiU0VaQ0tIa21UaC9I?=
 =?utf-8?B?ZWdEa29WOVY4dG9OaFdMMUR3MU9tRUhUY3NNMCtRL0I3R2V2NStBcGN5N2p1?=
 =?utf-8?B?ekRkdm41K0FQOGUwM2dRN2Zia2IzbTZVWWhoTDI2aitZWlNxTVlGa01aQ3ZG?=
 =?utf-8?B?TlNUd1BiTXZlVzFxRGgxME9kb0lReFpUV1FUaXNpMUdCSUprQUNmUEkxZi9B?=
 =?utf-8?B?TmVoVTZ0bkFUMFZVVjUxa0dOclVxeWc1elBya0U5ZDhkb0dQREFYOXVDNmsx?=
 =?utf-8?B?ZVUxM3dnS1cwb1RDdUdzMUNONlk2OTBTWGQ4eTdwS2haU3NEZEkwSnQrY2Vy?=
 =?utf-8?B?MnZsaEtBSTdsRFg4MFl2UnZoRFRGdkNSNzRqaHlxMXc5am9OQy9SWjIrZmpF?=
 =?utf-8?B?UXFGbWJCL1FXTHF5Y2NuUHBtSlBvWmI2NjdnUmFMbFBMS2V3a0lQWTM3dmtZ?=
 =?utf-8?B?cmVGNFZVT3cvUTNyaUZ4RlEwS20zVGxEWWFldFlXNUUrOTBhMmhzc04wd2Fy?=
 =?utf-8?B?YUNwR08xYjhMcXdFVTVqanhjQ3U1TFZzVTYrTmhUSGJFQS8yN1ZkaFFJUEZU?=
 =?utf-8?B?NzJLQ2Q3WnBkelE5OGVuYTJ0SUN0QzZrdmJUdUxTOXloMmY5aGVFNytXVy9m?=
 =?utf-8?B?NzBRbHhES2JTV1VxY1NlNmRZMEZQcFJlWVBIQ2xHUGxaZjhEVFk3cDhHZi9S?=
 =?utf-8?B?VGdMWjVUemcyREVWRFlzWUZkdTZ0cytXc3BqZVBtSHYxZyszK0x2T3JvTTBh?=
 =?utf-8?B?YXVrcFdWSVlsTkZYVmhzOW1GNDd4VWZjbGNEQ2NQYzZUdUJVeEtIejVGQ0Jt?=
 =?utf-8?B?QVNHbUtML3h2QjBVSld3WTNwSnFhc1VzT1JIeklWbkp2dkY2Ulo3SGZtT0JH?=
 =?utf-8?B?YlRWVk9FYWh0Z05BOVJFaGxQdFJTQmhtNUlRcXdkRjB4L0dvMGVtcXl4NzNH?=
 =?utf-8?B?V0VwR1lGTkR0VjZVeHJFdEEydDlHOEI4cytaUllwZnl3d0F1S2YyNmNHem9L?=
 =?utf-8?B?V2trbkQxRGJoU3FrM3NzcXphSmxKRkd4ZENJNU5TTnhKWmZnWnpIQTM5dzZK?=
 =?utf-8?B?OTYrdk8wYmVhWjNVU3FWaUkyTytjWjlzQ0JvbGpLZStaZlBhYzJzdktBbVoy?=
 =?utf-8?B?NHpGMEplWjlldElQUTExb1dzekZzbTBCVHI4bTFWY3pFSUNnYVUrVzZ6ODhw?=
 =?utf-8?B?N2FzWlkzTkwxaEpiR3RhaS9zTVU3RWxubzllWVErdVpiNUNKV284M1dabjhu?=
 =?utf-8?B?Ykp5VGZFSnBxN2ZlT1l0cU5Vd01aais1aEpxcHlVS09BOTlxV09IeEY1K2pm?=
 =?utf-8?B?VkxZT01XMENxaWFRZE9nS0h4YUJyenJhVzRSMDRReXZVcG9ROVRIeXppTHRk?=
 =?utf-8?B?TnlRMkpuOEIvdnlielkzN0ZsbGNpQTQrdVpERU5PRU4zQVhjZDNnMlFJYlkx?=
 =?utf-8?B?TTVzblgydVl1LzljN0RaZmFvYjlzSjRPT1R6aS9leE4veVN4MVhlc1VrMG1L?=
 =?utf-8?B?TTdpb25oWnR5MGw3ZURDcG9GNGMwWnB5ZkVCZmN6OXI0MnhSUTZidlNxWXM3?=
 =?utf-8?B?S3NhaGQ0dXluU0l1YStYdVN1WnFnUEgybW5JbUJEek1iZThOK1N0dzYrZjlN?=
 =?utf-8?B?anlldjdOUXpaNUhsb0FNaU9Mc0VYYnkxdmFDTUphcGwxakJ4dVArZHRCZSt4?=
 =?utf-8?B?YzZ6Y21ZUGRkTllzMGVwM0xHNS9LS3NaYUUrWTBRNURTbUhwQXg4UnZEdENa?=
 =?utf-8?Q?UUNBuApm24b7QYD4Va9TeOzje?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jCGqVCL0Cf+5F2JEN6BuU/ztaju/j/E3vY9AOA2vkJ/nxnx5vjp9bqdSIin7V9Xb1E43SEH2JxWDsYufMmsAIpD26Oip7DHirUHIzll+p8XsREqTrSCdUMwu8pAnckXIAWbbaaNMNRQePjlUaCrAhqIjFltZXl/mnkONifD0uWu6D/c99ERIshr0YFLoqCQbG75Cil4v2KTzH+XlPEkKmk55LyvV3WgaiG1WIWcMyVEwwjCSYY8UmxxxdMIh/lGteiZ9Y6KpoBo0IrjT5/PwlXewt3MCRJB/HOFozNmPoj/Zl5fuD+mS8rxAOAVBRRAgVxT4Ocm9QTv35v0QWwT6EwZQqp/Dx6tWwrtHdwl1NANYG5Kwcg4W5nDAySq9SVSezeYAS2Z8/YeUmJEMH4PcBlJhJhyWnGOMoHq5ynUsQqelR/W3HubujpUGIGtoyDAVsagWtKUlvp4mtVRBR8kE1J+uN3cXsyRw1oVvgCCXYXc/YuW3DHMdWRGCSzGl961M80cB+1VJlwLY9rVsSZZyGFN1CcbzmWfMcUmMKRhFQF41GYzb9uTRwaFHBjmvYSt4pK2cnsUZxxGLT13H1l8UQl5w1J/bwyqh5AGkLsaOcxK+PFX0BJWJcpnW91eOJhLE8ZKRaCaaUF4zP2jRCGyCra3bW5/HyQ4zS6WZbFAs7WOKGvu6pcf08MivfS3mly2tyiYaVsHmTkqIE1fHpeVPqAh5GD/3LmTgqPqnjD47tK9Sq6PeUFnXFQG41723Vq6rNSN1Mx2DbDzTFlVpETXHOPOmBpIQcokCjAEiHRIjIIHHaW3Wgl4alOHIxheqw11j
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b7b302-0310-459a-7b32-08db65ab6b5a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:58:31.9900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ssro6XlfhZFbQqK0ey1Lt3uqSgKvE5QP5r83HPP418igW9FPMbqqNT68VsF3MD7SjPqQ82dQ9sEoJEnDpjVpfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5023
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050089
X-Proofpoint-ORIG-GUID: Cs8JA7W7PbD3xxwuqCsqCkODEoPKvD3g
X-Proofpoint-GUID: Cs8JA7W7PbD3xxwuqCsqCkODEoPKvD3g
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/06/2023 02:32, Damien Le Moal wrote:
> ata_change_queue_depth() implements different behaviors for ATA devices
> managed by libsas than for those managed by libata directly.
> Specifically, if a user attempts to set a device queue depth to a value
> larger than 32 (ATA_MAX_QUEUE), the queue depth is capped to the maximum
> and set to 32 for libsas managed devices whereas for libata managed
> devices, the queue depth is unchanged and an error returned to the user.
> This is due to the fact that for libsas devices, sdev->host->can_queue
> may indicate the host (HBA) maximum number of commands that can be
> queued rather than the device maximum queue depth.
> 
> Change ata_change_queue_depth() to provide a consistent behavior for all
> devices by changing the queue depth capping code to a check that the
> user provided value does not exceed the device maximum queue depth.
> This check is moved before the code clearing or setting the
> ATA_DFLAG_NCQ_OFF flag to ensure that this flag is not modified when an
> invlaid queue depth is provided.
> 
> While at it, two other small improvements are added:
> 1) Use ata_ncq_supported() instead of ata_ncq_enabled() and clear the
>     ATA_DFLAG_NCQ_OFF flag only and only if needed.
> 2) If the user provided queue depth is equal to the current queue depth,
>     do not return an error as that is useless.
> 
> Overall, the behavior of ata_change_queue_depth() for libata managed
> devices is unchanged. The behavior with libsas managed devices becomes
> consistent with libata managed devices.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

I have some nitpicks below. Regardless of those:
Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks!!

> ---
>   drivers/ata/libata-sata.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index e3c9cb617048..56a1cd57a107 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1035,6 +1035,7 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>   {
>   	struct ata_device *dev;
>   	unsigned long flags;
> +	int max_queue_depth;
>   
>   	spin_lock_irqsave(ap->lock, flags);
>   
> @@ -1044,22 +1045,26 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>   		return sdev->queue_depth;
>   	}
>   
> -	/* NCQ enabled? */
> -	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
> -	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
> +	/* limit queue depth */
> +	max_queue_depth = min(ATA_MAX_QUEUE, sdev->host->can_queue);
> +	max_queue_depth = min(max_queue_depth, ata_id_queue_depth(dev->id));
> +	if (queue_depth > max_queue_depth) {
> +		spin_unlock_irqrestore(ap->lock, flags);
> +		return -EINVAL;
> +	}
> +
> +	/* NCQ supported ? */

nit: I find this comment so vague that it is ambiguous. The previous 
code had it. What exactly are we trying to say?

> +	if (queue_depth == 1 || !ata_ncq_supported(dev)) {
>   		dev->flags |= ATA_DFLAG_NCQ_OFF;

super nit: I don't like checking a value and then setting it to the same 
pass if the check passes, so ...

>   		queue_depth = 1;
> +	} else {
> +		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
>   	}
>   

.. we could have instead:

if (queue_depth == 1)
	dev->flags |= ATA_DFLAG_NCQ_OFF;
else if (!ata_ncq_supported(dev)) {
	dev->flags |= ATA_DFLAG_NCQ_OFF;
	queue_depth = 1;
} else
	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
	
Maybe too long-winded.
