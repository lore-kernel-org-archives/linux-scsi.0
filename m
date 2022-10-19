Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E79C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 19:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJST52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJST5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 15:57:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE341D7991
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 12:57:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JIOUE6012321;
        Wed, 19 Oct 2022 19:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XZOTZjq2FxH2SGBfnQ0+qhm14Ihn6bq5ihCwU0yRLRA=;
 b=P5ilhRWMC72saV4vLGCG0KkQFN1TAdmFD1GIdOhRTqQJqqdhzgyz2EsLZgL/HMeoGfxZ
 QURLWVZS4KQ/rAz16X/EV0h2dapWj4XLWezIUzavVK2PVkZ14wbxtnQYYzY4pNmV0PIP
 Bzk5IxMVqZnjEY+idM2YiXTBuNPFQWiYOC6Iny6Yur5Ph5rM8s7NI7f3oH+G2WAP92Ct
 eMLCRhlOwDlDsXDqNWtwJdAiAXh7snZDQCM+HnLD08InjzCo2mdhwoIKoWnaNuOpKFBX
 V18Pw79ciM2wB/jYht1AvMYP4j6Du3nCbH1/8arCc+FdPN84LaZU+4FazHJGpmHWQ99D qA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7sphs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 19:57:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29JHo6Oh002782;
        Wed, 19 Oct 2022 19:57:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hthvyew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 19:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRjj9bDGddq4t7ieRa3Sn7AHn+pHxMqqgD/bc9CFGjsHq4HeEmmHIxBiFh7xRdm32F44r1HiW71Eao0ftN/OINxHM/mEcCTgUWAp/eu31kBp+nWs5wT4zMcobymilxWoylOXozGAvucTN5ZGzfw3hm3SgctrlxS6oFunYm2yhc2oIFuBnhusmpeCoB0Bx1aRHr1dFliTO89YFjkGLsDLxLYavNKDuMawk0CeTP2mwQtCXFuLUN2q3THsPFqY1JEFqpL6XsBwg0s+Bt1RNuZ/yuixhWLbecADDbACnRKvl6q5tZb4FDyg9GiR1dGKpZkhAjy5+ONJ5eGRSsCryoIyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZOTZjq2FxH2SGBfnQ0+qhm14Ihn6bq5ihCwU0yRLRA=;
 b=oCEBhJmk/YxHXLrDerfVMvQq78DRe4erblz6/o8R6NAiRam4ymz9wD49F+ikt2ZoGZLTQisud8HqMWBgExoeh2q9V8BVWLcgSnFxRogp6Kewy5fQPsUoehiPMxuJlT/uwHJgkqFmp6GWvhbAwgqwoVb4layRYlFI+GO3xwQJyzAHzrEUgI/kLbFRTOAKsg4norCdBrRYZZlUPceXztT8d9N5/eUUZGyVRpW4Znplg3pUorBso9Sl0T+hO4U1QQdj2ToZl2ttqUsvFyt0GeWn6LHmskOcl2M2JtJqpG1U8bxnAK06/qY+arrau9ft3CH1zX7OVMjbB638lwq8jzK2uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZOTZjq2FxH2SGBfnQ0+qhm14Ihn6bq5ihCwU0yRLRA=;
 b=noCpZ7Dj05AlS1YKskrlpjhyKuEpPzsPQYpfFLVw7j2nT/Lv6qN9SpGmttu5X+AMWh9a4ZBTKps/3he2F8fwkmckHlR8Qo724RYv/owXu+oBnuoRte90cs89EVp6i6MmKwEX0bf4JXyw0u02lE/13ZRnz2rJjoAM6UKo60D19jQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB6000.namprd10.prod.outlook.com (2603:10b6:8:9c::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.26; Wed, 19 Oct 2022 19:57:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 19:57:04 +0000
Message-ID: <d3d656e8-f855-9ecf-3d8a-0da0e0f12cd0@oracle.com>
Date:   Wed, 19 Oct 2022 14:57:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4 09/10] scsi: ufs: Introduce the function
 ufshcd_execute_start_stop()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-10-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221018202958.1902564-10-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:610:74::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: f71c703a-645b-4879-41f9-08dab20c1803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWOlGUj+Oy/dEw/nocKnIx830+QbUDKKCEETGTLq7pqloaJj+1szebSTi/UR9TN2mLALt9QYbtVCEDVYVoo/QxKAjhSwFzAprrDjhkeI2A5/y2yQ4Wyez/L+vb5Vc/l5MUDLD+yquNZ3rCwcF/03fVq+Rfmc6+xfW9RyxoIe+WQUw4uY+AWZH1aFGqpAhB/hzMKRSB+ASS+49SoCV/Uo/TZcF3hLxK7hOMMkpCp7s07/GhxaTukOjfOVHUoylOvkLqcUxj5tOtBoG3olq14ajdUAYJpGH+e16AAPwX1bfNvnx2Uy2FTaglPcINZDdkaCsh4XwPgN68D7ymgvMAu/scSNQZxzR37tXOH9juhqUHAdyBlxxPz13oRfFnE2H9lql3hG2A+3Q1ZJMdu6MQHM7Mh7itQi0IdQbnoGXVoFQxE97vh9OO33h8oDPmLn0ATneWAId1F4D8D1S/4c3Wge/HUt4BxsvqvDwADCxQTv0QmZmcvD/H6s9ZWLsbvGYlCa/WQv9L1pqrrrr2n79nKGTaAe2pleAtNJuDEax9OvpTOQbVImzhoMIIuHM4MnFm1mytqyCGjp6JN++6T3lQuYqGtklBXXRhikTgOVvDjEw3SvK5A6+N3TcqXfeM9w7cL7qakS9+NAL/KnxcQu7vDEFyUl43PLWuIeqYVdulNrn0S3RQTJWNGWf45I8prOE49BDMIvYENVtxm2ZyndJ7Wjj04QuAn2kep90CLJb+yIsTDLhSE3BkZnRBwfhm08OCTuIet/+mbLuPaYCA13/wIPov+lK3/GQmQAbAFBZqgyXAU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(36756003)(86362001)(31696002)(38100700002)(83380400001)(66946007)(6636002)(66476007)(54906003)(316002)(110136005)(31686004)(8676002)(8936002)(2616005)(186003)(6486002)(41300700001)(5660300002)(2906002)(53546011)(478600001)(6506007)(4326008)(66556008)(6512007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnlWdmlEUG5Ic3lqeHBUc0RqVjFKMGZyTmVYR2ZqVWRicGJubGdyWDdqMWpv?=
 =?utf-8?B?azNCTjBOYVE5WXBWcng0WUxuTEdYcWwrWnlQNmNwdzVFa2UzRGN3eGNHa3hV?=
 =?utf-8?B?NTRTMlB2bkEyb2VaS2I2Q2pNZk5DaVdjVkY0ZUZKQ1FQclJzTHhqMW9SRTZr?=
 =?utf-8?B?OGp4bnBXemlUN0lrbGR1VEVWVkNMTUlGL2FYdjRrcjI0T1p5MGt5ZWlENkFD?=
 =?utf-8?B?SEFldDhFYzhMY2wwZVN1dGFPUEFHemEwdklzVExQQnArWk44VzdiRGRQT3dO?=
 =?utf-8?B?bk9xbElXNUU5Y1dSVml4NjF6Ky9XSlE4RDVJa3NmTWs1WEh0MG1hSXp0NU9V?=
 =?utf-8?B?Z0pkN2lxcjY3MmtaRXlkeTU1REduNHhmTHc3QmM1RHROWlRWcmFLS1VPRU1y?=
 =?utf-8?B?Z094K09Pa1VlMUtmZHg2b1c3TDc4b0JYbnJxTnVveXJVQjl4UnV1bHNJOEFk?=
 =?utf-8?B?K3dJU2djbjUrYmxJVG8vM2xubWdmMVl4emR3Q3dmR2pKb1dQT2RlQ2lXMkhr?=
 =?utf-8?B?bGF0Mi9DVzBMUG1EYjh0TzJGdFRVZkZ3ZzN3ajJmME15d3M5a3FnT0hYQUNT?=
 =?utf-8?B?MkpBWTZSd3ZPdmRiVzJkWUJDdG1RV2FLUzJnUlB2T0g1d3RGbXMzWldIUUQz?=
 =?utf-8?B?OGh1YjNhMEw4RjRjWlRqd1F3STlqRFFzc1JXdFZ2L2VCSkpnSmJmd0hDdFdP?=
 =?utf-8?B?VVIxb3lqUGZRc2poL0JlK0wvSEM0ekRiYzhLSzVFRjJBYitsSGFINDhScFVi?=
 =?utf-8?B?RnhJcTJZR3hLWkx3UjhyNFI3QVg4R0NVNDNxNTgxVWVOMDhqcDNUM1hVbXF4?=
 =?utf-8?B?aHV1Rkc1OTNDc1RQSWpoWkViaEg3eTRoektCcUc5aUUwaG1LN201TjhSWnBV?=
 =?utf-8?B?WGhuNzg0Uk0xNDJZSHZWZWpvQnBmUVVTakxKT0E3OXluWGkvakp3NGJjWFpL?=
 =?utf-8?B?UmdSSEVva3Q0VEN1OG5KUlZjK3JNbEFRY250SkowOUxzU004K0c4UXJKdFpP?=
 =?utf-8?B?Uml1MCtrVmtybVAxcXVZTlpXMTRHUldIeHFHUGp3T1dldTU3aXVwUzFNdlE5?=
 =?utf-8?B?ZDJsbWZsb1BkdFdzQ2lhcW9zVVBzZ0FVaFJNbTliK1VJWW9sY2UzRmFzcHRp?=
 =?utf-8?B?NzNkVmF1eE9YWkR3VGlXYXBkMzAwb0YwNXFiUUcxWDN0Njgvc0s1dXpIU3ls?=
 =?utf-8?B?UVFPNGd1OGtzMTkyKzB6SmFVNlFEVitlRUJkK1AzK2hocm44MHc4ZmRIOUVh?=
 =?utf-8?B?Q3JSR2V2UjZHcldXQW94SXlBVWVJRTFQRm5GZmV3bk5TUUl0ZUJHZlBMV2ly?=
 =?utf-8?B?VW9NcmtIbnEwN2pYN0c3dG1oSytJYjY1aDRYOWpzR0F1cHZycnlXNlRJUG1w?=
 =?utf-8?B?dHV2KzBCS0dqYzJZYThjb0RzYUhMUTliSWowb3ZsckdqN2FoV2xtY1ZidE42?=
 =?utf-8?B?U1RWNFdnYlo5OEhPNTd0cEJ2ZTZIb3hvTW1zS2JHVDFZYWJ3RGFsZElUOHEx?=
 =?utf-8?B?cWpHdGtWTEVicUVZTVJnZTNtaGgwbjFaektXbnpSejk4OWIxL1JQaHJuUmZ2?=
 =?utf-8?B?cEJSUGlXUUw4cHhHa2E3aWtBVmt6OGxaNHJ5T1NSc0RoOGpsZnJqT3NudW9i?=
 =?utf-8?B?NFhzSEhHNENkdW9WeUNKSUhpWnJiQmdoU1hVbWhLUTNxV081bCtoYjJoTlEy?=
 =?utf-8?B?TVo4ZzVVQVNPVjVVZnlxOG95VmJsMDhzRW1DcXhVM1lWNGdFSU1aWDZVV3J4?=
 =?utf-8?B?bnBFeWhENVBHcVluZklab05Ca0VReVdJZHR3bDQvU253aFdMSnFpVm1qaERN?=
 =?utf-8?B?SGc4em9XbWMwUkNoRGVYaWM0MVBPSEkzWTBScTBhR0h6WnNnNUZwRnRueFZo?=
 =?utf-8?B?bEpKcjNjUnI3ODVHVnlPQlNNVzlsT3MzVm1WKzF0NGdmSW1yUDF5ekp6MDBz?=
 =?utf-8?B?QmtyRnJKZ3FPYjVCM3NGa0JGM2NJdThqV0cxMkk2c0pLWER1RUhMZit5Q2dI?=
 =?utf-8?B?dkhSZzNycWkweHpMcXUrRkF1dTlzbExWdjdBeXRpZ0J4cGFpSWs2NTJPZXZX?=
 =?utf-8?B?UnNsYksrdXFSK1BBNndzdEZkU0RKem5KbFNSY015T1M0SHZobFdvTHVHak5y?=
 =?utf-8?B?U0w0dXFuRzBHaHo3ZUsybHl4SE5mU0hpOTdaMHVzUmhPY3FiVFUrKzdiQ0lH?=
 =?utf-8?B?Q0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71c703a-645b-4879-41f9-08dab20c1803
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 19:57:03.9970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJrv34THQAlYFDHA09jch3vl7GuK4mN7/IQswJ1WnSDtSwtr9vrFykowpCumKUSVL/J7Se0v2aN98Opxp4nncg4H6a59bjrnIaJm82EDEx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB6000
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_11,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190111
X-Proofpoint-GUID: Mz9TVVgp0aAygVhdYD2wL4cduVFUW777
X-Proofpoint-ORIG-GUID: Mz9TVVgp0aAygVhdYD2wL4cduVFUW777
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/22 3:29 PM, Bart Van Assche wrote:
> Open-code scsi_execute() because a later patch will modify scmd->flags
> and because scsi_execute() does not support setting scmd->flags. No
> functionality is changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2a32bcc93d2e..c5ccc7ba583b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8729,6 +8729,39 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>  	}
>  }
>  
> +static int ufshcd_execute_start_stop(struct scsi_device *sdev,
> +				     enum ufs_dev_pwr_mode pwr_mode,
> +				     struct scsi_sense_hdr *sshdr)
> +{
> +	unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
> +	struct request *req;
> +	struct scsi_cmnd *scmd;
> +	int ret;
> +
> +	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
> +				 BLK_MQ_REQ_PM);
>

Can you hit a case where we have run out of tags (__blk_mq_alloc_requests
is hitting the blk_mq_get_tag == BLK_MQ_NO_TAG check), the host has gone
into recovery and so commands are completing to add a tag back and then we
try to call this and get stuck waiting on a tag? Or for passthrough do we
have some special reserve?

If so do you need to use BLK_MQ_REQ_NOWAIT here? Maybe do the retry loop
yourself like:

retry:
	if host is in recovery
		return failure

	req = scsi_alloc_request(.... BLK_MQ_REQ_NOWAIT)
	if (!req and we have not hit some retry limit)
		goto retry


or have some special reserve command/tag.
