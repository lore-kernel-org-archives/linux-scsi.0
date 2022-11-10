Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C289BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 18:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiKJSH0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 13:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiKJSHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 13:07:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD56636F
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 10:07:23 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHwxLH002294;
        Thu, 10 Nov 2022 18:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7VENDQNQi6+TupyFPOyuN3bLlSfpXJ9MS7nxTVR/Vqk=;
 b=DHbWwprvfsOc6zJ1euywH86by6E8Zp/LW7ZvWyvgXLVVDDZmzQZkgepwuL181LA+xiK+
 JSqgQtF7jCSAVJUc/wDJieCsTjTdzjzK4JjSzopZgA9NPQPdKZTn1v9HnUSArP/0B89P
 jWl86DzhYJTsXZ+GD9iQ7ayPkyYYqEK7flqcza73my0bnYzBwWFtC0xT3HYbJlUrq4nd
 CN+mqQfUIRHTCgpAiYhk9mIuL2OYWwCq9ZppFTiH98tvwRxiczoKfxJaArBTQ97V/6S3
 nnCiuEeJdjt8VwtYWXrj987AwtaiTYQ9WtslHGupT/yoNHXML9hlQcCmePHeTvmxgiKx pQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks5w5049b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:07:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHVZI2019818;
        Thu, 10 Nov 2022 18:03:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqkcxft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:03:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxkXXRujkNGMXSrOZZPMrdm7pJjV7FrRkHttKefsdxtj6e08fu3v57OpykGdxdFWOe+dL+LgDpXJzoX73fbGd2ryDA8CeDEF/T317n2VeY+yyvx0oBzrukI2P6XmF5jiegkBgNWmdjbiKuvDHGzUKMTJ4qcNXgI03fEcHMqzD1CjrW7Lo+5pR0UxfFAWFzurlNwKZcxZPEDr1rRc4cTaUA5ypFAb87ylsGeKBDZHPfEogyyRKEDFGGhjZgyRzg75Cq7yf7DJfo2ZtP2j/5h2lO3KQuIVOjMztr8ycMlpEATVBT/IP0kqdNeQSU6mr2GPOw7GmYW1mu/ledOFwcVKsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VENDQNQi6+TupyFPOyuN3bLlSfpXJ9MS7nxTVR/Vqk=;
 b=Z07Re8Loe+AsXrZw899+f/wknbjf2gqyO7Z4za2iFjWSPeJkYfb6ZyJfO+i0KH3UQa+h2mC5fnq1yh8iAn85pHO0Q18F8x+S/Ug+l1LGFCgKiwAKafl4DXFwwpf4NQeQnzv02ZYa2fDheyLqt3ElPbTYiUW6SxdMCMmLIa8OMTCb+Gin1EiA9i7huHpfMTSKTwqtzGnXOj09ua6Mbuf+TpMVAZTbFNQrsMUJ5lPDCZwvDkP9BqLUjxNd0DZv7A5sH4w4b3rs23xw08KpaNRIHyb+E9wprPaGu1khPe5lZO6UrUm5/TZiqzX9ePezzVPcjJL3hG/qOuXuoUMuxx2ZdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VENDQNQi6+TupyFPOyuN3bLlSfpXJ9MS7nxTVR/Vqk=;
 b=BvJs/Al3qhMciN1mococUsJHkLCobi8KhKl79lT6s69lnT80x7E/nGVRrVw9A0dUdcQktH7F+5S1wkEZNXJZDd4ziQhqb8EH2El0dp2tF91X/SPvxeygjbPXlsl3OhI8htuFMbLbnZwWDwljOxY+t9XhZtN+OnXGLMNxqY2hIzU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Thu, 10 Nov 2022 18:03:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 18:03:45 +0000
Message-ID: <df45a2e0-ba39-b49d-27c7-91e390247dda@oracle.com>
Date:   Thu, 10 Nov 2022 12:03:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] scsi: core: sysfs: fix possible null-ptr-deref
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20221110142917.373925-1-yangyingliang@huawei.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221110142917.373925-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:610:4f::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f86ef8-e39b-4145-891b-08dac345e8e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxzp9ymisL5UVhBqOhsjq86SljryKLTnuqjWNmQSQUOitiP3KD2GJxxXQzyCQ2S7/IoUUMA4x6MhZqyZ9ju2rfo8H2Bscvv3JQt6KTSB0lYjW/P35CxJfrL0FaITvnCO1PmwmWIleAI2NJ+CqMOznkNNLlpCMhO8wUjbcKT39rSJC7HXPCX9AfAa9Sy6zbjQMwQzDQ/qvCymuZS9zt/ySYp9t3prfL6GTS0siln/zEfwaslalI6sxgrpmHPD5KZSgczUjXuKGsgDS4GcRVGf2Re14MUkMXvTVtGMgykAFhVCPpOBozzRx97dRakGtspFt4tvJf+KQESDFSIEYOJU2cDjQRCDDnBoBD45unEcltQdU9HyE7HIcVXfz5rPMCqvwoLCC9wrVbaDQhoAEjIEzx80wH0qmwBZ4vZ4zYWsn1EgPW4mRQgWfFa7h6TfLJdRNgV2r6kAm0B2f+MBPjYVLt+DHwCdEyuklP255XOXUqJpxcSLwM2SQmWdubLy+azwlxH2izMPkFkwRTFhiFng61/Of243iTRzLXAtOpDgrhpYxg/uE+fKFT6Z45BnPL50771rMDVyPh1uwTRhVGOPMdGlv80yENUjS3grqiL605qaGfHniKq5TdsS8q7ygDuBzlhTbu0Y0Pn6+o0iAReD7CtF5hH1pGbkQk/h6ova24aIcJXDKouAxAigfkj2U4sdYwTA/BeVWTdGzRQzeDTvQhUouUVBHtsjXl5tnT/LodMh7SDS/ZBvbiIoKrkIo5VR5k6Zo1iEOCjhR9X0elyoDIHevbm+z7uwCnNcqMoVFS8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199015)(31686004)(38100700002)(478600001)(31696002)(83380400001)(36756003)(86362001)(107886003)(6506007)(26005)(2616005)(186003)(6512007)(53546011)(2906002)(316002)(8936002)(4326008)(6486002)(41300700001)(66476007)(8676002)(5660300002)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjBCeTdCSG9GTVgrT3FlbzRyZlBkc015cnRud2xoTGxOd05UNVZlZm9vb3Y5?=
 =?utf-8?B?NThycmxncHkxMkVkZTFEa0NTeUZwbVNYQmJWa2crcDZISU5tUzNYQW1GMmJn?=
 =?utf-8?B?UjhoLzRPaW55WGdSOEZQbWE5cEpZbTZNWFFlNzhTZTQ4U2d6QjNsMEtkaVJZ?=
 =?utf-8?B?N0I2MUQ3Wm5mMUJIekd3emFRcFhhNW9Dd0VDRWtYZHI1d1BPMEplUjlwTU56?=
 =?utf-8?B?b09pVTJCaTAzZTJ1TUZVQks5RGxaUGV3elJXVDloSndPYXpOWGlwdjBTbCsr?=
 =?utf-8?B?U0FVRmFhbWJOWGtqOEVYMWR0OFp5K1FVMFZ2QXg2MFV4c3BBV1FsUVZydUs2?=
 =?utf-8?B?U3ZxdGJxVURUSWFxV25jRTBtY0RSQ2ZjQmN4VE8wKzVWZ2JaZitNcG1QT1ln?=
 =?utf-8?B?ZDdwUDFVNDFGdzlsSUE2NE9FNWVTbHNoN3JBcm5XSHB0bTFqNWQ3T01PSmgx?=
 =?utf-8?B?MnRQemg2b1A2OFpneWlRSXRhNVpaSVdPTENPUXMweHdneTJueHRXQTFUNFNG?=
 =?utf-8?B?UDhSVW9jaHpSdUxuck1SUFBBM1MvdzRNaFBnbWRKcGNpUEdIUk9GaGdTRE0x?=
 =?utf-8?B?N0ZJYzhmVUtnVmhQOWcvMzdVWVdiYUxmMDc4RXBid2V5UFZGWFozd1ZGTEQ2?=
 =?utf-8?B?YXFZUHk0T1Z5YXRCSjUvT0w5NnhFMEU2cTc0YmNaTzdhRytzRzBPcnFrdGRO?=
 =?utf-8?B?clF5ZE56OHVENFRUbmp2bDdpalUvZGR3NmxYT1RpTmJ6WFFrOHVXRUdYeFZL?=
 =?utf-8?B?M1JGemRnRHZ5elpEWWNhRkY5ODJvSyt5RVRBemhxMGovemNhcjRtVTJSUEVa?=
 =?utf-8?B?cHlFeFZuTk1TUzE3MTdabVArWGp0ZjYvVmtkMGpmRU8yT09HYlRVRm9keEdI?=
 =?utf-8?B?dHMwRk0vOTByS0I4cHNvajNCTWg1QjFjRWRHU0xEYUhNU2lSMVhlVW54cEZi?=
 =?utf-8?B?TklHbkpxVXFUSmY0WTFLT045WFhkcGpka2gwSUhoN29heWNYRktOYmF3MmFY?=
 =?utf-8?B?alRaMUNsMUV1MHZrM0JSMEpNUWdUWmREeEtXdUpzZVZ3QXFkYkJQaW1tWkUy?=
 =?utf-8?B?UE5aZTVrT0o2M3lYZllwYkJFOFBFVTE4OWo5ODJMclY5NEtqNGJ5MFZEdFBJ?=
 =?utf-8?B?Q2RUU29JQk1aL3FPaEQ1akM1VFhTMyttRFgrMnN6aXVXOWM5N25DS0NyZTR1?=
 =?utf-8?B?c3NaTFozbktXS1pwMjNoYW54WndJOFQvVU5NY3pZMXpXN0pnTXkvQlA3dEg5?=
 =?utf-8?B?M2x0cTdiQXdaRDV4MGs1aTdHM3UvREV0Y1drbjZMY0xRQTZWMDNxK1BKRitj?=
 =?utf-8?B?cEs0UGlTMHRlQ0FaZ0V0MW93UEt1aGdGNTNHd2NHWkJCdlRrbnprLzBsZGlr?=
 =?utf-8?B?TFJKV2wrZkovczhTd1grQTN2L0FqcGpOS0Zvc3NNZkYrM3YvZ1psZ3UxeHNX?=
 =?utf-8?B?N2FiQXpEVGJCUGFZZ1E3bTFRdk4yQkJIOGlHOUczTitFTmZhd3lxaHY4bXoz?=
 =?utf-8?B?RGFpSEdpTURVRFplaWhKS3luUE1GZ0wxd28vdFlGekl1TWMxN1NRS3hDa3Zl?=
 =?utf-8?B?b0VWK05mMnl2WjBYVFFIRGpHWngrUmRMUkZlbHN4cTQ0YnpZdkRQRlJ3Nk9s?=
 =?utf-8?B?a2R3RzVtaHo3THl2cFMrRDI3Z05ybW5GcnVhN01pdWtqdHlva0orV3l0VHZY?=
 =?utf-8?B?ZEpqVFNvZitOMVlmYlRWZzhyK294dU1VRThoc2p1YkZHK2k1NlEybDdXM20w?=
 =?utf-8?B?dEpKMFc5ZDFPcDFyMVBhbmszcVZncTJGMTVVdmQxL2wzQVFuWCtWQzZWaG5y?=
 =?utf-8?B?V3RxRWVsUlNrQWE2RG52OWZ0cXZ5cGNmY3ZqR3FHcXY0S21yM3ROWGZjdjlC?=
 =?utf-8?B?RVhNdWtMa0NhN3R2dEFwWUduc3Zyc1ZZOXZEWWNHSlMzdDc0WTZ3ZERYL2dz?=
 =?utf-8?B?dUxSd1pWWGtlYktpYkJubk92Vk1nZEJrcDNOWEQ2SzNrZEQwRmRmd1ZuMEF2?=
 =?utf-8?B?MGRWcEU2RG5MTzZkYXVlN3RWbmFKN011OVJ1V0pCa0RjTjIxb1FLTmhwTkpU?=
 =?utf-8?B?eE92U041L200cDArTXh2N1laK05QS2pZTWZ5ekdGem9TTCsxVGpyZUQrdmYx?=
 =?utf-8?B?TkF6UC8wS3QxWjdhbU9veDVNZStUaTNrR3VjWGhzck1iaklia3dmN3R0cnJj?=
 =?utf-8?B?Vmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f86ef8-e39b-4145-891b-08dac345e8e9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 18:03:45.5375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AR5+VLp7rgZw+q/JAVCPYagUvz+Y7aM9/aWUjsPNXtizMb1hj9mJmAHARkF000WjD2bPCrZMe+TCn/Ja7c/0Mp+nLeriJkcmMjNvrsshuQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100126
X-Proofpoint-ORIG-GUID: o-XoYL-PHmq_Sk1C7ZQYuB9xlnmlmwle
X-Proofpoint-GUID: o-XoYL-PHmq_Sk1C7ZQYuB9xlnmlmwle
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 8:29 AM, Yang Yingliang wrote:
> In scsi_sysfs_add_host(), transport_register_device() may return
> error, if it's not handled, it will cause a null-ptr-deref while
> removing module, because transport_remove_device() is called to
> delete a device that not added.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
> CPU: 12 PID: 14570 Comm: rmmod Kdump: loaded Not tainted 6.1.0-rc3+ #25
> pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : device_del+0x48/0x39c
> lr : device_del+0x44/0x39c
>  device_del+0x48/0x39c
>  attribute_container_class_device_del+0x28/0x40
>  transport_remove_classdev+0x60/0x7c
>  attribute_container_device_trigger+0x118/0x120
>  transport_remove_device+0x20/0x30
>  scsi_remove_host+0x150/0x26c
>  sas_remove_host+0x54/0x70 [scsi_transport_sas]
>  hisi_sas_v3_remove+0x5c/0xbc [hisi_sas_v3_hw]
> 
> Fix this by checking and handling return value of transport_register_device().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index cac7c902cf70..41de795f1ab2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1607,7 +1607,11 @@ EXPORT_SYMBOL(scsi_register_interface);
>   **/
>  int scsi_sysfs_add_host(struct Scsi_Host *shost)
>  {
> -	transport_register_device(&shost->shost_gendev);
> +	int ret;
> +
> +	ret = transport_register_device(&shost->shost_gendev);
> +	if (ret)
> +		return ret;
>  	transport_configure_device(&shost->shost_gendev);
>  	return 0;
>  }

Do we need to do something similar every time transport_add_device
fails? For example, in ata_tport_add if transport_add_device
and we later do transport_destroy_device in ata_tlink_delete?
The SAS and FC classes do something similar and in SCSI-ml we
have other cases for device and target additions.

