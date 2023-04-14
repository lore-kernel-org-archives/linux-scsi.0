Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24ADC77B70
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Apr 2023 08:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDNIeO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDNIeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2023 04:34:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B205BB8;
        Fri, 14 Apr 2023 01:34:08 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E48F7u012860;
        Fri, 14 Apr 2023 08:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2qZoZdw3v34LlXdLGTcn05ySSlWd/jWkVsjT18aLKxk=;
 b=JpP7Ws1SsCs9SNQqMSiF0rZvQIBMwpjDaC2RcHCpagiIlFFShOoHr4K90qTlScxyj7ZT
 h4wWKQuU+BzYCRgwYXYk2/Q2aOYP/Lbrcj5CSGgICJ0WFa/NaPXgSBAFgLRLtaHExwxh
 0v1LDmSjPVjqk0cdMMavWe/BtsiUqggUEo8+4JPDorJagW3fX1DC7nSC6EWdJsMETVPW
 HUWdTeBO+TSc3V2fMgRE6vhS34QeBYldKW8GVzT9KmHLD9s5hK6y67xTKePTWiyFojrA
 rvxAfaOg+P2gQ0KmClCtz94oF8+NfiMkFaXOVy4UoDYvBufmfxDD7WkS+pI4cdWIgVV7 Yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwnmrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 08:34:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33E7IapT026965;
        Fri, 14 Apr 2023 08:34:03 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwebxb2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 08:34:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMMn2uZq+s0EkoKS+cQiot553E2uyjlA49m455tnNA4DkJbNvd3cu6DW79vmmAkh+d0ulr0EycP/w3elqcRxTa1kGNqhVM8OXa4Sutf/Rf4m0k8vQhkIZwChPniM9zd8DgTx539I7Zck4Zd17UGITW3qhUdQyOQ2bH4SewdogHU9iHRS6t5WuPaOUEs394FC7F0tZJ2dCS400wQ1XkURMyRWIEaVggUK/Z09HnRFpIviKT+7CcziYqULWU7Pn2gTYdEXuiJGtQkpV5XzLlBtDUatzJIimg7dQRcXjeyv2oX/+nycfqB/5spFRK2N3I/M//niVHHgbo4bixp/2u+iSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qZoZdw3v34LlXdLGTcn05ySSlWd/jWkVsjT18aLKxk=;
 b=EwaZqCSPMI7MM/LHL660BuZ1HdObEogYa28jEKOwe88Te3r4UFWlSqPbULSmgj5X92xpiBwy4HpBRh1K3TxzjJbZlK1qx0URddFq6iEcJZaGXKv9z+PWU6Nc7zCxm6pQEY/NZi00AtpJxRnBG4uW+GHeFvBqcmBdSR6eGTrV+VEMa78Ds/0io6gv3YVmUJWm1abbzw5uwUen6htAFRYj9AunUCqKKTIJZ1IpwiXybyAB5yNzS6kVFr2vylP1ngA3MsVjQB4w/smqedsWdYmGOIL8m4OTO5nqU4A9ZA2rGoKxUq8Tsg3ejavPn/0PrObprqStw1BVhC1tPTuU9DSkAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qZoZdw3v34LlXdLGTcn05ySSlWd/jWkVsjT18aLKxk=;
 b=L0w6oEz/+SCntE56pzr6TjI6SF7LNDrPMkrjFD8TIF6yKMXW9V6eSxWSuvNn9nlPDuW/hiyOIByjpO9/aNqt3IXVve/Vc0pxBcLz4ABF6B/4jOkiErGbS3/jfWVtuRv3IGQYon0jFnQBH6CgrDjoqZA3wmMswhUAgbXsJ0x84CU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB7412.namprd10.prod.outlook.com (2603:10b6:610:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 08:34:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 08:34:01 +0000
Message-ID: <5ebd61e0-0835-94cd-b55b-942a9c72b5b5@oracle.com>
Date:   Fri, 14 Apr 2023 09:33:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: blktests scsi/007 failure
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0240.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e9762cb-1edd-49e8-ed06-08db3cc2ff64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qCAtulDzujoM2q8qBHZtyFnPUZZxcw3/0UhF6sJSG8n3MsCTTpt8dGZQuBtYDrlPpRPhml/S3Ae2WC1P7ZY2/G3FW5q6rfOY2Ts/reWUb7Dkb5fRwXqlpVz77iTTO8AJd77N0YYG3Cbbbj+xexf9MrQAzhJFnUokD27EzF2X55XLgWSKeXYf8uCwlGsgv6TFnaBiD+gARtNcPfM+SsC6Ud5n9KtIkgYIa0wlQzzzJxeg743ypS64iggk+4qR+kZQ90T1oNEP9edUE/xgspurmcxFE6eyofkYN2JyZw07cjICJFIc7arRPZIDm5mdimeZqjB2Rv5SwYRihqUFCMb76Zr7AQDfPpaLZ5P81G/kid2ZWkEX9MtP5ruh0FdFmuwl2W/r0SSr3Q3ziJg4PxoKb71+lfcydtnwZo7FBI93gqOQlStjHcGT3atPBKipT2dw0FtpOt4eSfMLZgzKe7hIHRB/lB6dTfXZoI/mU4IENviY18Ey/Z0v68lOMaSMMDLugeRIzLhCL2nEWShCZPju0IsJe3xcitBDcOhoFDj4IccRBl2a3AQauJ/jS1BmkKu2f+CASiKqf2BEBlOgSttbKnljWNSIvBT+yOmt+Tpb3J+krqR9aoFweyZ7wycy6WIHC8YrHDE7k9jxQGuBUFguFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199021)(66476007)(31686004)(2906002)(66556008)(2616005)(5660300002)(66946007)(31696002)(8936002)(41300700001)(8676002)(36756003)(110136005)(478600001)(316002)(6666004)(6486002)(36916002)(6512007)(6506007)(53546011)(26005)(186003)(83380400001)(966005)(86362001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmE0SUNFMEhRcUJlMVZhL0xsSjNybGVrRkQ3cTZhZXhqOWROalphUUFHNDNp?=
 =?utf-8?B?bUpqb2g1M3V3aTN6aDg0RjNUU2MzTmo4MUZXSHFQb0VVSWRLaXdRQkJ4SE96?=
 =?utf-8?B?dWVieUE4Ymh5a0J4cXExS3EzdURyWnhEWTNHYzRJa1MxVlQzb3Z5QXlWWnM1?=
 =?utf-8?B?VGV5cWxzU25wbUZZVXUyWXZzd29JMElTMUV2OUhTaW9IZEtIZEhETzZjSlNx?=
 =?utf-8?B?T09tQTRKclB6U3J3VGlDNHpZbDVIZkp4WWh6bWZBUXN2ZWJYSTNZNTk3U1c4?=
 =?utf-8?B?OU9HRExuZktuZkw3Zm9CQXpWaEFyT3pqbjZ2N0ZUZHV3YjJiQ0tGbldVS2tP?=
 =?utf-8?B?c2xoMDUzSnZzMXphNEcvQ1RaYnA5QkdRUWZ1K1lBYW5CTmJML0RaZG1iYldY?=
 =?utf-8?B?M3pRRllXVjUvOHM5T085TUZmeHNHLzVSYmJDSFZUWmpZUmlQZFFPVkNMR3ZE?=
 =?utf-8?B?R2Jkei9SU3p0QTJVRENTR1lEcjhkZ0JVNzdHSnBZeWttc2hic0FsTUZpeDJI?=
 =?utf-8?B?eEZ6ODBBWFp2RFU3WE9vWVZRRFhyUFVqR2x3a21qcERPOHY5MG9KcG9IWG9T?=
 =?utf-8?B?MVo2MGM3di9rV2IvbVlrNkpUbDlzcHh4OEtvOTR0aDZhZUlqajFOdy9zdlZW?=
 =?utf-8?B?WXZ1eU02RW01enZ6dXZoRE9xQXZHM1c0KzZ4UEYrR3J1dTVvU29CZFREMVl5?=
 =?utf-8?B?eWRtcnd2aVJiYzZuOU1EVklMRzB6bE9iRmV6cEZ1SkVWc3NQRlhZNEYzTFJp?=
 =?utf-8?B?NnpWdi9OM0J6cDlROUlWK1ZYak83MndtYjkvVFJXcTkrT1JqQnR2Vk1YRW1m?=
 =?utf-8?B?UUhtMklJVnNUeTF2R2V5YkZQaWdIWVlWbEFBNkxQbVhXZDhPNVBmMGVKVXdW?=
 =?utf-8?B?SkMrbjNMcXQ5a3lxY0JidFJYRmgweFQ0bTVHS1o3MEdIVVlGNmFKNVJIY1cv?=
 =?utf-8?B?Ymo1Z21qUGxyaWM0Mk4zZHNCQnBkTVVKSmljcjJGbFZDYnVSRlhIL08rbitL?=
 =?utf-8?B?VHZQVzVVOEZtOWRWajJYL1pTV1ZTbFV0UHRkK0Z4bENMaW5KNDhmRm1yMlg2?=
 =?utf-8?B?WXJzMU4xeTRUbkw3RkIwMHhZOUtwRS9hNmF5a3BnWTlkaENtRE1DcHhDSFEv?=
 =?utf-8?B?cVJ6T3pGaUNBVGZ2OElrRVBxTEEzdVBhK1ZXY1Y5V21oUmRwNTNnWURvU0lS?=
 =?utf-8?B?UC92ZnZ1UHhkbW5zVDVwc3drdldieEVidVVWK0dSVnRxblVoM0NLUU9HSDVC?=
 =?utf-8?B?Y2h0U3czVTQvMExmN0ZIT3R1MUEyRGFSRTY0aFlqNW9rQlRJY01lbFIzemtw?=
 =?utf-8?B?UGpwV01wNm12UGhYb2ozYUxVN1Fxb3ZXaXBJSW0wbXowRncxc0F3c3lBNm9O?=
 =?utf-8?B?SWphclJmbTlNYkdNTThXam9USENrT200OFBVeHY1MFhjMWpmUDcxYzhQT3Bl?=
 =?utf-8?B?MTdtaVdiSFJqSGVFS1FDdVlHYWJTMHJ5WmhSQkhWOWdkSEpvOFVyL2FFY21j?=
 =?utf-8?B?VTBpVmJHWXN2M0VQN0h0bC9UU1ZsV0M5dGRadlJqa1lqb3JCRUV4MkxWcXdi?=
 =?utf-8?B?SjRPK3p4Z0FzWGI0WVZNNDYyWm9iVWZCWnRmdVc5T2VROUNnUEhaNTlid3h3?=
 =?utf-8?B?VC96L2s1TVV6TXhFQWxraElvakRiZmF5QUFKMEdrczBEb1l3bmNvMVU1WjRU?=
 =?utf-8?B?NlZoUTl5QTlWOXJXZzk0Rnl2bkRjWk00bEp0T3g5ZzJLSGIzNHNVNEZZWW1t?=
 =?utf-8?B?YXVtbDkydkhDby92N1llZUVXS3lnOW9WMHhTMWpKRjNDUTFOVUhlWkkzZCtv?=
 =?utf-8?B?VlM4Q3BLSDdEaU9TUFhDOWtMVmREQUVsMVp6VW10OFREWmFGeElwcW1HTHUz?=
 =?utf-8?B?bzE4MFpvZWNDUXlibElqY0JFNGNxWWRZZ3crc2NCUktyWFhBTmdhdTNTNUZr?=
 =?utf-8?B?K0lHYmt6NUtkYnFpdnlpN1h0UkRzajZWQkJKYnkrUlRZN1NuUkM1VlBBcEEx?=
 =?utf-8?B?RHp4UXQzRFhBRnFmbEJ3RENlb1Z5OXBSK0NQcCtMbjBGZG1teUl1Y1dhVjln?=
 =?utf-8?B?MjRPazF2RUhFWXlhRE9VOEVVcjYvaWpvdkh3NzlQREhQb08wdk9BUERzTzVa?=
 =?utf-8?Q?dmjFcfTz5vdatlzqTSXpCYeLJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 89AMAcXb7vZ+tEmvyP7ZpxI2M3GssT1+d5zyzLFAEGagR34Urr51ePlcTi8foh3ApPgW7AVw9h7A5umrMhOOD78HVn+gI4RVpKi0NtWKM1S/HLr95ziuJMf4PIDJMP1nMVzmP3DKr9YouqDtymTIHTbRavpbkOV2WPQwgXzI1xkhpWOlNkQt8ABJkz3fbvRJyp5FDiPqt6ZNIl9ByiO2MjURCTUS0zCsa1S/DvoMgvfn0KusYuCkURNEmw9LGfgrNKZrvUfr54Mx6UFs9H/Xgk4M7KdV4ArvSlYFuFe7axXPwuluCt3qCTeE9ZdMX+JGajLBIESdmoZh9dXwNDMmIT5M43PetKH+6PHVp7LzQapeQd1q1m8zj2FEfNveeO2c+BxmKTF/V6zYOPyzRGF3qKYTP93GdjLZPwbvc77fjUpSs2JUo2V99bcxcLaoBi0qzydwGW1jP/JfoouiNhHlp2U0WvMkhMv1fNI3FioNzQmUkZWw1At9K6R5Bz0wDphUQR/B0HLRE4EUmkXIN+ns72y2Upj4XvxtFy6PIkxmuhNvZwfy6byjz6AUMZmI+y91yd8fPSwongly4ICUlMzxtn2rsj73dFb7q1GO5esq+k4iMCWgYKt1uaoXtzntuFfDWMKE4SRhq1ix/4lHr24ExsHNPgVl9HuUsrsi1iYfz+c9E71IKMZ4cmKNsG8tppx16wmtAYk6bvT/pCa5GG4nh+5Mb/BFnagvSG0Y4Ed5lo3iwmLG/Z0Ram+1JIy1VRM1lGTYC9RiA3PoeL+P8SeYM/cgdm1ZMoTEN5X7NxGx0T7o0Ehi0L/afiZXU3T7qNzB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9762cb-1edd-49e8-ed06-08db3cc2ff64
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 08:34:01.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bXZ/KGwwXLarpb7GeIZHGRj4hlr/7Z33pVbSnUmvvLWZCmiiiLCGkgPZNfR1MzPrZEvodzJdqGOxGrOU4pcLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_02,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140075
X-Proofpoint-ORIG-GUID: YfdXSF7BdjGAdAF7dzHhw9ARM0-VvEu-
X-Proofpoint-GUID: YfdXSF7BdjGAdAF7dzHhw9ARM0-VvEu-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/04/2023 08:36, Shin'ichiro Kawasaki wrote:
> Hello Bart,
> 
> Recently, I built a new blktests trial environment on QEMU. With this
> environment, I observe scsi/007 failure. FYI, let me share blktests output [1]
> and kernel message [2].
> 

I did not notice which kernel you are using - did you mention it somewhere?

> I found the failure depends on kernel configs for debug such as KASAN. When I
> enable KASAN, the test case fails. When I disable KASAN, the test case passes.
> It looks that the failure depends on the slow kernel (and/or slow machine).
> 
> The test case sets 1 second to the block layer timeout to trigger the SCSI error
> handler. It also sets 3 seconds to scsi_debug delay assuming the error handler
> completes before the 3 seconds. From the kernel message, it looks that the error
> handler takes longer than the 3 seconds delay, so I/O completes as success
> before the error handler completion. This I/O success is not expected then the
> test case fails. As a trial, I extended the scsi_debug delay time to 10 seconds,
> then I observed the test case passes.
> 
> Do you expect the I/O success by slow SCSI error handler? If so, the test case
> needs improvement by extending the scsi_debug delay time.

The failure may be due to one of my changes. Please see 
https://lore.kernel.org/lkml/5bdbfbbc-bac1-84a1-5f50-33a443e3292a@oracle.com/

> 
> 
> [1] blktests output
> 
> scsi/007 (Trigger the SCSI error handler)                    [failed]
>      runtime  25.594s  ...  13.646s
>      --- tests/scsi/007.out      2023-04-06 10:11:07.926670528 +0900
>      +++ /home/shin/Blktests/blktests/results/nodev/scsi/007.out.bad     2023-04-14 16:09:45.447892078 +0900
>      @@ -1,3 +1,3 @@
>       Running scsi/007
>      -Reading from scsi_debug failed
>      +Reading from scsi_debug succeeded
>       Test complete
> 
> [2] kernel message
> 
> [ 3714.407999] run blktests scsi/007 at 2023-04-14 16:09:31
> [ 3714.523102] scsi_debug:sdebug_driver_probe: scsi_debug: trim poll_queues to 0. poll_q/nr_hw = (0/1)
> [ 3714.525023] scsi host3: scsi_debug: version 0191 [20210520]
>                   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
> [ 3714.533733] scsi 3:0:0:0: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
> [ 3714.543198] sd 3:0:0:0: Power-on or device reset occurred
> [ 3714.543250] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [ 3714.550936] sd 3:0:0:0: [sdc] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
> [ 3714.554821] sd 3:0:0:0: [sdc] Write Protect is off
> [ 3714.558024] sd 3:0:0:0: [sdc] Mode Sense: 73 00 10 08
> [ 3714.562414] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [ 3714.566601] sd 3:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
> [ 3714.570045] sd 3:0:0:0: [sdc] Optimal transfer size 524288 bytes
> [ 3714.586397] sd 3:0:0:0: [sdc] Attached SCSI disk
> [ 3715.999917] sd 3:0:0:0: [sdc] tag#103 abort scheduled
> [ 3716.015174] sd 3:0:0:0: [sdc] tag#103 aborting command
> [ 3716.019935] sd 3:0:0:0: [sdc] tag#103 retry aborted command
> [ 3717.090803] sd 3:0:0:0: [sdc] tag#178 previous abort failed
> [ 3717.098780] scsi host3: Waking error handler thread
> [ 3717.098917] scsi host3: scsi_eh_3: waking up 0/1/1
> [ 3717.106279] scsi host3: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> [ 3717.111212] scsi host3: Total of 1 commands on 1 devices require eh work
> [ 3717.116170] sd 3:0:0:0: scsi_eh_3: Sending BDR
> [ 3717.120493] sd 3:0:0:0: [sdc] tag#178 scsi_eh_done result: 2
> [ 3717.125183] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd timeleft: 10000
> [ 3717.130301] sd 3:0:0:0: Power-on or device reset occurred
> [ 3717.134935] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd: scsi_eh_completed_normally 2001
> [ 3717.140241] sd 3:0:0:0: [sdc] tag#178 scsi_eh_tur return: 2001
> [ 3719.033180] sd 3:0:0:0: [sdc] tag#178 scsi_eh_done result: 0
> [ 3719.037656] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd timeleft: 8114
> [ 3719.043293] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> [ 3719.049631] sd 3:0:0:0: [sdc] tag#178 scsi_eh_tur return: 2002
> [ 3719.055489] sd 3:0:0:0: [sdc] tag#178 scsi_eh_3: flush retry cmd
> [ 3719.061420] scsi host3: waking up host to restart
> [ 3719.069512] scsi host3: scsi_eh_3: sleeping
> [ 3720.175944] sd 3:0:0:0: [sdc] tag#180 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=1s
> [ 3720.182709] sd 3:0:0:0: [sdc] tag#180 CDB: Read(10) 28 00 00 00 3f 80 00 00 08 00
> [ 3720.189825] I/O error, dev sdc, sector 16256 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
> [ 3722.342015] sd 3:0:0:0: Power-on or device reset occurred
> [ 3725.349863] sd 3:0:0:0: Power-on or device reset occurred
> [ 3727.275069] sd 3:0:0:0: [sdc] tag#79 Medium access timeout failure. Offlining disk!
> [ 3727.279944] sd 3:0:0:0: [sdc] tag#79 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=7s
> [ 3727.285131] sd 3:0:0:0: [sdc] tag#79 CDB: Read(10) 28 00 00 00 3f 80 00 00 08 00
> [ 3727.289961] I/O error, dev sdc, sector 16256 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
> [ 3727.294862] Buffer I/O error on dev sdc, logical block 2032, async page read
> [ 3727.996161] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
> 

