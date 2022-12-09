Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063BBC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLIKVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLIKVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:21:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DCE6721E
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:21:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nwud027260;
        Fri, 9 Dec 2022 10:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=mxy1OtfHRvKKlineCEHPf+LRXHtA6/iKDr6MJd7dHpQ=;
 b=eDV0if5dKkvJIorBUrlZMKlrJg0HY1c3kIsbTwG9CatcFVUO6BtpXyp7QufLcRdvsRCq
 JKDetRtHBxNqBcqKCHSpjCgwOZjEQ01yhs6Gm9+WCZfs8hvaYKQWp7d2QiGznXDalP7m
 bR94KjjFPW++0WdUMI4VTh8+MqbKHtCRr7uCUfHeKtYPhgp/nmNW25xHuqKP0VsINOsw
 PuTbyIy9zknqC/dF6p3bc5ACYeqsg6hTCl1XdERgBIMoCE3zuOTa+XB3U6iqjUZxoBT9
 TRBEHMXm3C5zWWTanZwnwTbrS4xq1UdPYlirSiBAFqF8SP5NGMzEcAd2QgNTDvATkys6 dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud74xfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:21:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98t6k9032657;
        Fri, 9 Dec 2022 10:21:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7fn2w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gtib5fwx7kCZk9Fi90u62BYvd7ovwihr6J4AX1C04bjZJAasY1pK75VeHdpwy1kRITmwhMzqbV8NJy6N/qFlwog66UC6d6u5IQoFHeHLSqwm0ag0DabMek5Isje8SpfG7Z38HbcOoEyOEyoF1n27MNjlkpf0hy4vT1bgtYuRzYhh/OmIXNB0FvfRk5Cv4PU5/xxQ+QanSU9qvvdYdOoh38ja0uqOMZQ7Mg/xy9B4wQNfjoOyrtzPImQG4EL7Wh86QTPyRRtdS0+zdtw0QbX0Q+SnbiCmc06/zzAHpOnhFPMYN5LDmr9W9WGFcVGE88Gqbsf/R6q/L5iZbGY+s2MRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxy1OtfHRvKKlineCEHPf+LRXHtA6/iKDr6MJd7dHpQ=;
 b=BprSqgwvh2pvV9mY3Yaw1cYZEbGBSGs384JaqHUkMSKkrdvCMyqJZqStBvbIv41Yw4M15U24bzfvSYvVyiaJtd9nAEAAi8iCAVhkvKs9Q+HkD41FUCOcvQDFE7sDOHOJgunQONvKsKw9FadFNoF7u1lKQ/y7k+itDHRHHFXSIBv83sgzf2tal3tDV6kMolvYy6zqoACYIednnttBY+KeiCQn8tkAhTYawlyZ3EhB4MvYwbqo+9WiZpv9t46ZhfOHLyndQvbRjng0FT9aISSdHnhccxcsCcRaF6wLnQd9HcOwujv8KnOruGs9rrmnFJreRWzdmkOVmJnram/TpOIoPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxy1OtfHRvKKlineCEHPf+LRXHtA6/iKDr6MJd7dHpQ=;
 b=z6deWZrRdCd3lUWOLAwae8O12Esq/ZJDMzMDZ7BV1aD7Td7zxgq5JC7Ci16jjC0lr+jEtYW/tbXxKxVV/nEx0ac05ljLP/Lmw3+f4YzHD3MVzraq9TJ9Gn47/HcjTO80sshfFpzxvkSiAQw9FCiT6/cyI2K3dnF1PR+tZ6FFZ/M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:21:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:21:31 +0000
Message-ID: <e7189780-084b-fb28-c6e0-e07beeb6db8b@oracle.com>
Date:   Fri, 9 Dec 2022 10:21:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-13-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-13-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0233.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d88c7fb-6f1f-4853-412a-08dad9cf2400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6tMzqJzBFmKCM3V8obOz4LzFe2H2K9L2jcU0R+SVD9zt7hhqiKygUF6Hoy1zstvalgCf7EbVeKE/avBC5wdbdCu9sGTuR/XMEnByNUDZs7A6lmUPWjoAvSXwPP+na8F94RyS2P/zjwZwgE1uZtF4pY048kuP/GV+oIF/VD4tgEzJe9B3VaB5XBnziNiKjvoLcpcnVzwYzinqb6LQQ0lMxTr6y/sQ1WmBm33AbYUGtFQbzhJtx8txf/IXsJXQChnt1Hm3hZr1Mw8loACLNQrqpjl5xcxop+82kzroW2lYuz8ZmBxOFQ8B0IMNKR41Uj7QAR+0FbQztqP3PtC1S+p4FyXNXhdxCOrFXjdOIxk+Jp2FbTU+Ssz+vZJpvPHW8K2Le9+1jVwrdnrpvHV5FMfmgWGDwzR+/9LUXjQ+Qnv7aTOe7iPFIx+DNQu2EWrc2deT9x7f6ftmEh0OsKb5P+qP29S5nqK/IJsq2Q8fM8DmFhcwWq5wzdOm9p0PeiaQX5TchKXP9WtnxM6i+HH5rVlwK9mQX6rBXENJbkY9lWfvLujM78PDFULlOwnzE8FLoh14c774xNxi/33PQPhA1sIx/TxaeSGS9QarcmCbdScAxew3Zn3pIMfIoesxJMeNGR8hxVGLjgMsvjkHO6FeqbzfmtWw7nEfBu0+8/lKB0A1ulmG1W+VbbX6hMj5eZcSmmD2kguuhlLoy0qSwfeYILztJZmK8B/AMG1JMgnOpUtGCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(31686004)(478600001)(6666004)(6486002)(36916002)(5660300002)(6512007)(186003)(38100700002)(6506007)(8936002)(26005)(2906002)(558084003)(86362001)(31696002)(53546011)(8676002)(316002)(41300700001)(36756003)(66476007)(2616005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXJNbFpLS0doUFN2Y3FjT1BkSzFyRVNmRUxXZ0NrTzI3Nk5jZ1NwYTZuTG1N?=
 =?utf-8?B?QnNkdWtIMXlHNWFTV0htU3Z6bjU4WjdKOW9KWko2M0xzRzZCdDJkNmloSVkv?=
 =?utf-8?B?RWZoMkhNdlpsZ0tnbUtiR2NOc1RuWXJJR1dEazRGMjlpd3BFWUsxRkNIckts?=
 =?utf-8?B?MFkyS2laZlZqSlloV3VvenY0MC8yT0lySlVVQ1dUN2UxRWRtLytORmpaOUFD?=
 =?utf-8?B?c2tzV0lmdUxkRjdpbFF5K3FqenNHTEdyYW52dVZXQVBUOWtWd042UU8xRExF?=
 =?utf-8?B?eHBOSTdUcHJIaGpaSTBhcUpEbzBtMWNvQk5rMHhYOW9NODlvd0dXSzg2VFd1?=
 =?utf-8?B?VTRhc09VLzRuYjdpa0J4OU83Tnp0V2dkLzBuZ1lJOHM5OFRBZ29NQ0hiZnFD?=
 =?utf-8?B?WDcyN29vUUlIU29jUEVzZG1sdktvWTZ5am9FNzV3YmVXR2l3UnIwSmxMYmky?=
 =?utf-8?B?ak5RLytsYWQ2VUpJaUVOejNoYUNLWm1uOGgwRURySFNqc1VhTTVmblJwdmRT?=
 =?utf-8?B?VmtlNUlrM1RET0FKWDFFUGxXZ1lYTTdNbGJWT3pFeU1kTnM5UUdwWkxpVi9l?=
 =?utf-8?B?cFB3TUJuUXpnQlNMZG11Zlo3cENlQkMyU28vZkdncEl5Vyt4SDdOZGg5T2dn?=
 =?utf-8?B?aG0wbnpqeTZFNU5sYXEzTUJJelJidFhBT2xISzVkOEd6Mk5LRTJ3eGVMbms2?=
 =?utf-8?B?eGRpV2RzOUFlcFJQSTB4U3Q2SVlFZHBEMmVlYno2aXFjV2FsSExra0dBYVVJ?=
 =?utf-8?B?a1g4MHBzSk9aRlFLaDFUamhxSks0UzZ6eGd5L0NBVUVwSS9XQVV4bXd4R0lt?=
 =?utf-8?B?MGhINjJNN0Vqa1RHY0V3SGI0SmRNOGJubjdGY2ExQU1MSWdFZ3M4NERsZmll?=
 =?utf-8?B?bUlUdXpWeU1xVU1hT1lQakJQc3pPb3QrWVBHMU4zdmdMNCtIY1d6b1kwdjl1?=
 =?utf-8?B?NTdHaTgwS0MrZE9JdlpRUHkzSGFTSzNRcXFBZlhLVEVmSGl5UGJMY0M1OE8x?=
 =?utf-8?B?OHVzczl0QUk0d3ArL2JpcW5uYnlxTSs3ZGg3dXVieDdtRmJTNHRhTThXRjFW?=
 =?utf-8?B?QXdYVm5zczJ0c1BrdHcyUzBCS0JUNnNZNnNnMlBSK2UzTVh3K3dDWmJqYmNw?=
 =?utf-8?B?dXFPOHBDc1p1NUliTzNqTlpidWhqWnMrbnM4VnM4ZzNOWWlWVURDNHptTkov?=
 =?utf-8?B?Nk9EZXlONnhyOUlldFc4SGxSU2x4blZ3aEpVMWR3QVBMRDIxb2JQME9WTXhG?=
 =?utf-8?B?dmRTcHVvVXgxZHgzeXNDRGZWYjZWRVBuTXh0S1MySFd3V0daaVIrMWMwWnNK?=
 =?utf-8?B?SWIyb200TEovSGlNdkZKdnF6bmJOVjBNMEI3eDdIRElHMnF3eENRbHFWdFdR?=
 =?utf-8?B?WTBFR1BYUXBSUWwxaXQzU2pOS0lJTTMwZnMzV0Y3eWVDdzBrcmpjMkd3eTdD?=
 =?utf-8?B?Nmw2TGtNL09SRlhDM2doVGpwVlNJTGgrM252SWRySWErSFV2ZGlmb29XMDFk?=
 =?utf-8?B?ak1rUCtXRktMYzB2YzdadkVEK01jdmVSTFVMNHV1azAwbGhlOHFDa3FrR1B3?=
 =?utf-8?B?cU1HZnQ1RnIxWWs1Y1d3S1FucGxWSnJCNmtVbDNjZTVnVHBXUW90akJsVEZy?=
 =?utf-8?B?eTdYQXY4ZmVtbWNsN0pONCtzL1lLLy81YW54RnN5aWxUK2ZpZHZXcFhmRXNX?=
 =?utf-8?B?YWhWUGF5ZnNaL2Z0c2wzVk9OVVFCZE5aYkF3T2dxZHNYT3FUbWpFTW9Pb0Rl?=
 =?utf-8?B?R0cxTXR6Z1hBWVhseTFYTG1OT2xHcWZzandrV0RGa3lYUTQ2dzFQV2JGbWZF?=
 =?utf-8?B?ZzFYOENwWXp4SFdGODhLVWcxZkEwOTh6N3N2bjQ0TGNwMVdmVlBxYitrMTAr?=
 =?utf-8?B?ZjZick9Ncm1TdkxJSGxUczh0bDRPU1E1eE9ubUcybHI5OUg3RXpBRHRoVTFo?=
 =?utf-8?B?UHlQSG9RRmh4REZKMmlLbzNlMDBoQWFlQVZPb1ZVUlFWdFQzMHFvZ0ZKT3Ra?=
 =?utf-8?B?THFtd2laQnFldXdGak1RaHJ6SXBDSjY5c1ExR0ZUQ3lVOFBlaWxhYTFoaTdH?=
 =?utf-8?B?ajZ4SnNRb3gyenorOXF3QWlGdDVQV24rK2hmU2NQQnZQZWE4WWU0eDJiaGpu?=
 =?utf-8?B?L2hMVDJDempSYkdYdmtvdWJTWlNoVTBieHJnbmJwWWIraFFoSFpkT1FJeHBJ?=
 =?utf-8?B?RWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d88c7fb-6f1f-4853-412a-08dad9cf2400
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:21:31.4768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ko7GSfQgMEyqKXn8/mGb+plBJwtTo1vKm3KrJA+zgYV8TD1HZ0iib9kzoSdWN1XlsrNtc6pjY/KtCUlkB0dkmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: XLSelmtHDbIP33Di6ffteF1GqWvu62ov
X-Proofpoint-ORIG-GUID: XLSelmtHDbIP33Di6ffteF1GqWvu62ov
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert virtio_scsi to
> scsi_execute_cmd.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
