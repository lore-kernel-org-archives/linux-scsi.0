Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100A8C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 17:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIVRgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiIVRgt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 13:36:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E75E8D8E
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:36:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MH4FZ6008171;
        Thu, 22 Sep 2022 17:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=NZlNrbYqkor9JzFtDSauiJtt9dQgauLb9DrzaEfMn3k=;
 b=vfpnalHnLQKaoY+uJS+R5y3YQoI/3AwbiYfuAy3RFIQ2lo/QMyvHM36mDSfRGvhGfnyw
 zUWfOaFi6pTN3SMq3YahJ5T5VKSXSMFmNTAMGb9Ncm4pyqFobPV+ws1EU+48hoVJwoWa
 cEH6/gCON+AjhRWNBxJS7l28x8hgmyA7VX1NycVxJvSs5utl5Snp1JBbl1hgrTcE2ngy
 y6ejoT8H12AhXGHG5gp0OF1BeUtoGWwNQnDIONuqPwR7EqgniT2HWX8eaNIpVCa80tbt
 3gcq6UMoQ7O8hWr6O5PNEhXfgJJYp2g+pK9lXm1+wBX5rADoVpbgPq2qPa8IzZQHtgeb bA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0nv55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 17:36:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGLqiN032412;
        Thu, 22 Sep 2022 17:36:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39g9s24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 17:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm0+VNSTnnJyyN9g1Egdo2G5BLv8YqtwjNQjkkvDA4OcBmwlOJo//hCzvR1P34qbxxMy4fDaeC2lZ5wb4lvm8dnZpzLpfR5ZN0vxjotTnTdBajdjgMhgZFKp0rrxn9LeP0fBuVK1aKcr5FFiXLJz7FddYw07i9DtE20DWbzoEOp9SsK6QTS66SpdVxNgBJltRHeym9aTWtayUu2atlMNEy2pDDa75ie2id6qsr0nI22CpTgkRdYb6PGgVvzqofna37epuep0QOvtbtCq7OTyDSR/6WFVHmZrfOJ8HcSbHXJPjAwdRWh8miRtstiBk+TA+k3LMEmggzA1lHor73s7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZlNrbYqkor9JzFtDSauiJtt9dQgauLb9DrzaEfMn3k=;
 b=betmXstYNRHtE5eF90bwQ70pNvBHT44gJj6SHdDpZwtsRuwjS+iKq/JItQcs+qGMJTn1tCH9EjOANJRpN39xq7fC4jHIdMyhRoUv/IWz1Fej8z8FkIC2lcxNkDne6HFBhJ1QwNf6DjIVC/YDY+WMpdZkz3KYWF9B2UKVR/fQ6Gf3QqqL/kCNFzEy4p8Wls5DV8+KNYAN+FqgAIFnmAVBsO5olbc67vUGo8ra6Uois+DeE524KrfQQrGJxaLs49+o1+Fk58Yis+JBdS7snxeNQAbR7oCPnTrv17d3pUz3NGcBG4Tkz6zShWYAwdRK35aZ5yjqGp19KIhaYD48Sc617g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZlNrbYqkor9JzFtDSauiJtt9dQgauLb9DrzaEfMn3k=;
 b=uswX/uU3/Z0uj13cgCZiGis9zG9fIN5pgF7CUAZt0T7y/hY88KO2zmi2akUfm0jhB4SIoYnqeHY4XLPIqVuN+07ntUxV7DYqZMx60c9RY36k2jKtimfd7b/PkGvTAjftiMen7cRGqtOmhs4kCQ5BeQLKxBUbeKvvInPu6Slkyrc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 17:36:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 17:36:39 +0000
Message-ID: <ea1c4d77-0712-b782-1e02-5d92f9584b6e@oracle.com>
Date:   Thu, 22 Sep 2022 12:36:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 01/22] scsi: Add helper to prep sense during error
 handling
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-2-michael.christie@oracle.com>
 <d31df5c9-3e5c-224a-c8f8-296402e4cb58@acm.org>
From:   michael.christie@oracle.com
In-Reply-To: <d31df5c9-3e5c-224a-c8f8-296402e4cb58@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0420.namprd03.prod.outlook.com
 (2603:10b6:610:11b::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a7e6a8-4dda-4884-9086-08da9cc10133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKiMXKBzkYzNjJDk9it0ISp1CzFVo8u38KgJACi87OeVQ00HExksn8zcdgNH0QdlxypBe3UCeMOZoCQPHe39GABgldFNxHhvwYD8tU/aIzXlki31n+xfdHLe29e/5uBWXF1ZZgGPKczPW6KQV0jY9IurfoCigZXuq05mulGInR3CvVpQxTWdk8NV1+5t+vP9Wpbac35DK710oupgKh4XL+xBXcbvhSW8KnceJU/MY//x/TzOASr9HlC6XBCd49WJoyaDYe9w1yfd9eh+bHIXbwZZadh/Q8zSd2pJNif15Xn515F5kBFJRYLirf7/ksNxBtwRLHV2xvhP/JPF21yetfcP8pVYhfhXRyOiLU9ZpOkTd7uuFPeHBLVFolUmEwAK2m+8Kr4Mo2YAnS2/MamnQ2UetRPEee1it9qWBwv9OiQoa4/Zwdsu0JhVuGxI3WaNTFBp7NwgrF4y8UJBOAt17rtuqACd9RsrKJKwlXQAUKu7Us5oT5OAiriXWSdu1YQa5RtQKM3VWLqyIA91Jh1mW3Yiyd8psbKYqxMA0+8iQnvDWyVeAsHQyBMHp5Poy8pLy5niPBHfaxSkNUfr4Rf1bUg3pwlL3QAuXmBV5qdjTKM85EC0D/fuvcdwHqHJzAGCowzp0brHzpGAHLTUb5aWoiiA+kxsmcGPISsWhM5Bj+BU2cIrn0doiFG+/aFLqd+kKD4W+Km4cBywnS5yygsDmRxn/op4RHVmzn08oJYg7d8/LchpYYwt7kOf9lEhv2y9ZU5RM83AcPDrwFbl3iG3IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199015)(41300700001)(6486002)(186003)(6506007)(6512007)(9686003)(26005)(53546011)(2616005)(4744005)(2906002)(478600001)(316002)(66946007)(66556008)(8936002)(66476007)(8676002)(5660300002)(38100700002)(31696002)(86362001)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjFSSGhSQTRDTDQ4YVMxanlhM2xMczhScEtVa0loVDFZOERYc295dlFWZGtp?=
 =?utf-8?B?NGpyNEprRE1vN05LNmVzOTM2Mk5ML1BIMXpBTXBBVVBnckRYZlBPSnVSU1ln?=
 =?utf-8?B?ekdUNFNtWnB4UU82Z2JvaGo3UGF5MkpibVJ5RkdLUDhuRVVuRjVocFVzQnVn?=
 =?utf-8?B?eWU5MjI2REZ4ZzNxNXpocWhQNFRXUEhycWlsQWdraTBma1N6WkJSYnZGYUxj?=
 =?utf-8?B?bHd4L2FJdjFRRDg3VUZvbUY2bDNHT3hVSUFMRTI2UTZCNlFGYTBaeE1mRk9i?=
 =?utf-8?B?Yy9VWnBNWVVyTXhOVE4rYWJNT2RJQ2RCYm5mQ0o4bFRyYkxFTE81M29UQmJy?=
 =?utf-8?B?bkJGWlJiZ0hjQVlrUnJ3dTM3WlNhYXJmWDR2NWR2Z0VSb2cwMjBpQ1gveWxS?=
 =?utf-8?B?U2NId3NCR2x5eTRWc1hiZW9wb1RPbGh3NVc2VjB1cHBCOWF5aWFZeExiTGxl?=
 =?utf-8?B?R1VnL01rQi8yR1hBVWRKVWNFUXMvTmVTYVNIMUNrc0xYNlMzODVFb0UvSGgv?=
 =?utf-8?B?YlZSNGZVYUFCVWpyT0tHQUhmT2FOdkx2eXJPTEJkK2Nta3pJd1FBR3JhNE9L?=
 =?utf-8?B?bm1BbDA4S1d0bXhuRFJZK1l4V2l5WUpxd095c0FXK2lYUUt3TFAxdUM1dHZk?=
 =?utf-8?B?TVQwYWRZSDdpM1BPSU5hRXVOL2lpa1VNaHJieGdMR1AzOUt3QnlUWVhDRi8v?=
 =?utf-8?B?ak9pV2RoVG9MMDBadkFRdTVWWmdhRm4wYzh6VlpFNVZ0eVNqRmxjWitacXZ5?=
 =?utf-8?B?YTBPZ3hDeUcxcjVHSjFhTEhFN3llR0xjblFrNmc3Q2d4RHM3ODdaaGR0QUli?=
 =?utf-8?B?MlBIUDlYK3ZpQkwyOFJzQ0xENXY0K3o2cm81UEcyUmp3MG94cVR5dUVJeitR?=
 =?utf-8?B?OGRQTjRaSUFIQnU5RTJGa2NDTzc4dEFEbU0zb1B0Slc2SXBuekRyUmk3SXdh?=
 =?utf-8?B?SFdydHlPWGQweU1iaTZSVmlWS2RFYlRZRkgwRXpLSzZvQW5wVzM5NnN0NitH?=
 =?utf-8?B?S0JXdklBcGR0NE5ZSE9BbFMvVlNpaVpLL0thRmltczcxOWFIMmoxeVUvbFFC?=
 =?utf-8?B?Y2F3Q1RIeHN3czArb1kwSGpQSVF1TW5WR0Z4cVRWcENnNlJicHhPR1dwajBP?=
 =?utf-8?B?azY3VHExWXBNUVVycmZvNVBUME0zN2FhdzAzTGxXcjlkMldZZDhrT0RzcGQ4?=
 =?utf-8?B?SWYrZlUzSG8zN0tKOUxnaVlaaGRROGFjZDF5RDFXOVZ3RlVJcTVxVEtLdWtv?=
 =?utf-8?B?RkFRVWVlbXg5WVB5VlhzUXZISVRnUXpCbVM4QXFNbVRKb01KcVNJZGNNZG9y?=
 =?utf-8?B?NWMxSE9yOVBGOEhZTisrbm01QzJIQlBRQ0RSK0k4aHowZlBRSU5icEJsNnVG?=
 =?utf-8?B?Q2luajUrUWtqVGswTE9qZDV1TFVnL3lWZWlYdkFCN2FSOGRGZ2JQTmV6TnE1?=
 =?utf-8?B?b0hxeXdVUFFwbXdpWDZqQlNtb2tuNXQvbG9PckxONk1kSWlEYW4xMHYrN0tW?=
 =?utf-8?B?YWdOQkVGU2Z4TmUxR2cwQTY5c2NQV1g5QzVReHJBZmt3NGFqSHpQR0hzblI1?=
 =?utf-8?B?Z1FGYnhDeko3am9MWC9aVU1nY0J3cFBGRmdJNm4xeHJDbWZMWnFTU0J0YnVD?=
 =?utf-8?B?b0hqYjFDaG5DakJBMkJlYVVkTjROK09STW5DMHErNUxmWEJhSXllUWo3NVZU?=
 =?utf-8?B?MVRMSnpUdnJTaldXZEFVT0FqNW1FaW9XWFJLdnJoNy9GK3loc3NLWmJxNHox?=
 =?utf-8?B?SHZ0Y1NSd2dKenEyN3NZLzAxSUxqNUplcVJKajhRTFEvTlo0VS9hbzdyWnZB?=
 =?utf-8?B?eEZJWkN3UENvOVBVVlZwVkcvbG1hb1IxTVVUUENTOWhESXB6SW51V3pIMEVM?=
 =?utf-8?B?UCtRd1hnaWtKbXN1NWZPN0RIbW1qMVZ1eTlEaU1jNWtjQm9EbHU0MTRMQUZ2?=
 =?utf-8?B?RklMakRJVThSeFJNL0dxd3ZpSEFGQjFvYmVvbmdWOVFZWkVrcUM4RWR3R0N0?=
 =?utf-8?B?ZXJyLytyTHNKSElFcnlheWhGcTkzS3VMMGJ2T3o3V3lETjZ1RklKUHNGNVdO?=
 =?utf-8?B?TGtiakMxTEI5VUFTZk50dWF6SFA3Zi8wTlRPYTBTVkxWcWd0TEEzWU04NGQ2?=
 =?utf-8?B?ZUZHMHAxRzd5SEJLNllUOXY3ZHlSOHRYUVhQL2N1ZCtWcVZIMTV6V1hQODBZ?=
 =?utf-8?B?YlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a7e6a8-4dda-4884-9086-08da9cc10133
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 17:36:39.0686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpkhX5zknCCGDyQyPTArPg2QY37S18wol1d6O32FI4CflbNILWLK4jAyOTukbzSWr0N5b2wMOmeYK5lxbSWEEkLamqK8oAdqTHw1S4BZRX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_12,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220117
X-Proofpoint-GUID: w5N5lEV3Cz8jE8MhiM4D5trOLrZVyL-W
X-Proofpoint-ORIG-GUID: w5N5lEV3Cz8jE8MhiM4D5trOLrZVyL-W
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 11:57 AM, Bart Van Assche wrote:
> On 9/22/22 03:06, Mike Christie wrote:
>> +static enum scsi_disposition scsi_prep_sense(struct scsi_cmnd *scmd,
>> +                         struct scsi_sense_hdr *sshdr)
> 
> How about choosing another name for this function? All other functions with "prep" in their name are called before a command is submitted while this function is called from the completion path.

I'll think of something. scsi_init_sense_processing or scsi_start_sense_processing?
