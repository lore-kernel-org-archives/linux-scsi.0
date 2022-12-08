Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC414C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 23:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiLHX6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLHX6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 18:58:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233607E826
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 15:58:11 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIvc6020772;
        Thu, 8 Dec 2022 23:58:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=oPZheF1Ysyjc5O0C/Kxs0C+Fas7lP2vJ7xcZhckMhdg=;
 b=vUt6LP9HIJgiWATmnhHGHldlMwIxg5sfBfCNK61klU6vhl2iTjR6x9qptcmgG8uFLMnp
 2ePr9gek+viljhLF6VNd7VGxE0Bf1d8IPjF/ySEjWTmMSSBXNlEE+Z8QLIJ5Enw4f1la
 4YGAawrxrZe4GTjk9U2bHO/5ihXyO/yQbGLb8Ft2THLO9ma+WcENloht5pcrmIz1jiih
 lPsyGm9d3dMwnGVjmTWqBjIF4XwexsVInLfcp8A8O2KahAq27lyMmdR4YsZcNkNUJgDj
 mUtf59T9vhxXH6aB+kU0ShzjqgNjeGqne7igJ26oFE0iSVg+ymqnJIYCfRsUcMPBJYcF uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maxeyubqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 23:58:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8MArCB032745;
        Thu, 8 Dec 2022 23:58:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7f2s6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 23:58:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTNkioRVZKNfi3fD5zRHupKh4jUvvW681IHFCuxQSHHQoQ6fZG/iJKydKZgeVaK0c+QYyzpL8Kdc/5HkMws2oV7ZgAOfntFr3I1NbIhiJrAJZL+EnY0ScT7FazRhZg6owBcCci31iiMZ/GBDC5MevHYc0VdUzdj9Qhjs+U3W4EMH95bHxrbLfU96zfkMS/JilTEii3JsIAIbNT59lWFmMlA+SRgkK8iVqvhsvUdK7ikOVTpxcmLc+AeoLyK6AcIyiEG6vW/3aSHktedYKj43kHvM++6FqQNjRq6toBmOjEmz17rAOeHV2Z348kEhw2CBBfYsyo5Hr6UyDWZITUMNNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPZheF1Ysyjc5O0C/Kxs0C+Fas7lP2vJ7xcZhckMhdg=;
 b=nAySUvGcHW0fA40yFpfbq/RDijBY6hF11zBgZpy63d9vySWye0pvtcN40MnOEp6SWolGyIUIXvy/XmH/FDWQznqdgaQ1ljWYvAof1SR1ANXbpPeJOzvSCEe2u+qnzqCq/5L+mqqSDypXWFbNuaD9BnxNNZytCItNjji4QCuMWA0x18xKvnuRIk0n9LByLmqCnxogsQxzD5cf4+SQ2JbgC9LlidlfC5P/1anOYy2LPcY6VGP2pFJdSbLdntywBSxCzjwfoU0/SatumdwpOGcE/HBW04dU9vqwNQLobgL7bhGBsY2/gaWZ9iyI4HQgTqeZaFSpCJsjSOtCCTNHTMIRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPZheF1Ysyjc5O0C/Kxs0C+Fas7lP2vJ7xcZhckMhdg=;
 b=Lmsgx+Z15DGl8zxdXWOSKF6rtow2GoxAWb6gBBLeSfNeDmce8esbDotldDwGERmgWV7V813OyofBHCIwZyyWqdCpe2s89CwbF5tMLJuRdJ/cgVzaoSGEqxRgPW5rDKLej6QLoLmtUd2nDTxIERSLmwJPBhTV3b3z34equkH+8DE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6820.namprd10.prod.outlook.com (2603:10b6:208:437::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 23:58:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 23:58:03 +0000
Message-ID: <598b6852-06f6-af3f-57a9-63cee9865b99@oracle.com>
Date:   Thu, 8 Dec 2022 17:58:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-12-niklas.cassel@wdc.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221208105947.2399894-12-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:610:20::48) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a9da85e-ce51-45b9-05e8-08dad9780b1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9VjhisyQeuxumpxmbKOYrNfG9p9O6oO60p+x56DTRxy+e4P930hlGTmWKeMAMd2CQIpyhHEtxc8yhkP5x4sbzSYfonBAy67LIwabn8h//l3GL1ntS9R7Jg44ROSopuaMrkAStWDeiK2UujR43aAbvR8S6tBrlrKdzttvA0Qx6jAZFGAGrKAGqJ1kCoUHuG8qknxKTxC97lr/JR3YJMfrZdVtAbUAu4iPzPBykXzjQCq4HRaxygQs74e749QLwnOiV7h9dWpHSAT26bLf+u4rs8GgX8PQD+V2086nZAIifJ3gc1ep03H9Nk1yIRPy1Mgeav0yfEpvQjo0WaAoJNFbkKIrb8kXjDh0bbbx/xseqAMf4YzEd/kROymG4at3nai6iavfWEHEZOm3jg3t4riYGDz/ehca8PZNaMXZCLOLb8S/3r6OmItsyTEDqvTsDbzKnCPyf8hS/SsGfJNyg3j0D5ANdA9xaloEoO4DC3Yk/cbcvu7yyBtTM35lyApSEJTBN9HfZSpd7JMSri2T4dCwlp1iVqXO9qB2nj9CO+K4TFRkt/P4I9gv7IpnZycsOJZAODJEr2sC7k7khVzfxl8VLW10B2yUme+e7qzpodDeHSZ9V+gr4z9IrtuZwsU5ly96qyIxDLKW976qLCoieFyOhgoBxBnAPxkWvWr9OXolmkIuBKOVk8a+fNoUXgBmjBSz43prYNZc0zXJpkYp2VfWbIoJHYFnPCaXVbjexrd7Qi0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199015)(478600001)(2616005)(41300700001)(31686004)(6486002)(8936002)(53546011)(26005)(83380400001)(4326008)(110136005)(38100700002)(36756003)(86362001)(66476007)(6512007)(316002)(186003)(6636002)(5660300002)(66946007)(2906002)(6506007)(31696002)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dngrOTE0VE9aWi83blBLeDlpYUJLUHEvbDBiRk9GY2hCc29rVXdWL3FIT1h5?=
 =?utf-8?B?ZERNQnJldDFLVXV0NUNGOXRiSTNZWmFta2JiVEF4bEJSVWxhMTFlRjV4SWk3?=
 =?utf-8?B?S09MSFhTdXpjZXZlVldtbDRQVWlXM1o1a01SRDFQUEtUbkNoSmxsN0w1cU1w?=
 =?utf-8?B?MlVRRjY5SU9ndThlVkgzQTN0WFNQNWNjZEtkL2E1WFR6WlZQS3FiZCttMm5x?=
 =?utf-8?B?ZStQb3RPWEszR296cjg4Wi9mRTkyWGFIeTR2ZzBHNjQzdzdRSFJXWlBmSytw?=
 =?utf-8?B?bXVMaDdXQ2EzZ0lwclpHUzFIa1crZUYveFN0ZnFuK0MyZ3BIUTFQdVdOQkw3?=
 =?utf-8?B?Wm1tdzJ5YTF6bzhOei9leWI2OHFtbFpMMDdGem91YUZHUXRRTXpqNU00NVdz?=
 =?utf-8?B?WVR1QzlWT3krTE5nTHRNZkF0SUtBTjJzOS9MWEVKbjZxa3JxckdmMWpCMjFV?=
 =?utf-8?B?Z1BnK2I3ZDJueDdQR3hOS0hpTi9wZmptL2xEMG15dVQxWEdhTllKNEowODZB?=
 =?utf-8?B?R2xScS9WTUF0c0ZXblIrQWQwNUUrSVdRUG0vNjZZUEROWDNOOTBnN3U3SWpQ?=
 =?utf-8?B?RFQvcWpPRUpNSStXVnF1Rjl0cmtvaytVTGhnTE1HR2x0SFE3R2pZOGJhL1NM?=
 =?utf-8?B?SGN1akZDeGd6TDJPSFhpMVhBUG9MQlJtV0VxaU42ZVVPaXJZNFJwckJxOFN2?=
 =?utf-8?B?aDRqRjkwYXdsMHhDMUpadUljYmdYTWV4bnNEek9jMlVLUkErL2xQYXA5Tlhp?=
 =?utf-8?B?NjF2NnZOMjZYTTg5V3dHNVpwUTA5T1k2SHJ1azZweExWZ0JoR3k1Nk9OeDdJ?=
 =?utf-8?B?UVhkOEVGbFBWQWZ4Z2pBUENYVVVnK2xxTVVUbDA4K09sUmVIMzl6clZldjQy?=
 =?utf-8?B?MUIvYVh4WXFpY2p1UDBZN29QdHlGOXE2SHpjREhFRGdieTdXNjlsTG9lbnJB?=
 =?utf-8?B?TjlMWlh3UTgySFdaZzQxQTN1VVVSV3FPdTQ1aThtMVNSU3o2T05pMWprTXh2?=
 =?utf-8?B?c3g5YlRXT2NlZWMySjNDVlRLL0NueU9xYTNIVkhvNVBLVUgyeVIzV29IM2py?=
 =?utf-8?B?b0UvS2dKb2JjZ25KWWUwK1crbEhTT2RQUDk4VmF4aWRrdW1kVlFUMUVpWXZy?=
 =?utf-8?B?RkJCTWtPYk1ST0NYdjhQN1phUzQvdXlncU1udTdMbWpGcGdON2FqaWppQnYx?=
 =?utf-8?B?RlhPbEJiN2VEM0gzbFYzUkhvVzRrRi9VdXpuUDFGWW1jM2JuSmx4OEVuZlhi?=
 =?utf-8?B?ZjN4WnZsRmQ2WElPNXBRZDcwenY2aVJlYmFuL014VWFiQWNjWWk3UFFsOWUx?=
 =?utf-8?B?Z01LaHMyM0FjMzhNOFV5MEc0Y1NCOXJuK2JnTlZjYUpTSnQ3Mk9Bbm1td1dr?=
 =?utf-8?B?Qzd5Mmc3bTNrUlhhNGdQYjArK3lRZytHcVk3KzVVSW44ZU9zZ3FxUWFSV0JJ?=
 =?utf-8?B?YytzVmZSTGtnYWE0Q1lwOTVMNXZvUHBLUVlDUHZwdFlrejViamFlMEk1bGtr?=
 =?utf-8?B?Y1U0K0hiUHZoSlNvWjFJZ3pyN1dZbHBmeXpIV01RWERDN21MNXFxbWI1cXlq?=
 =?utf-8?B?RWRzcU84MURybWdQa21IV1RWcUx0b0laVDdOR2hocEpqT25pLzVLNUVUWlFa?=
 =?utf-8?B?blJyTXNQRklndUNHSmhVS2Q4ZHlPVU9jTm0rYTBvbDN4SlZYaXB5cmtvMUZ4?=
 =?utf-8?B?T3JReXNOblkxaS8xV3FFZWc0RFd2czloTUZXdmhDdm02SVcvKzJ5RHBFWGdS?=
 =?utf-8?B?WkRwZnNkMXgyaDJ2VjJaUXM3cEhPQ0NXNDJsajAvUjJwTHhFS2NZVUM0ODFx?=
 =?utf-8?B?WnI1QzRtTnR4aVdlTkVJZWFpN2hVdlB3QlQ0enBnRy93WWIxd091Y05mMTha?=
 =?utf-8?B?Y1dMeThadWYzb1o1ZmFBTWEveW9CWlo1TS9iV2dVUmF4c2pvSEp6ekxvNzRK?=
 =?utf-8?B?RTgwbzd1c3RqT1Rpd2xTL0RmdHFYbDBwckp6eGt3RGN5TWRqbE1wQ3hUVlp6?=
 =?utf-8?B?L1RPdGk5NUF3OThYMlFLVk4xRUsrQjk3cElPNWk4TndqdlhZY1ZPNlM4R3Jo?=
 =?utf-8?B?RzZ0aUtMNk9TdDZSNDZORUpuSHVxb3NkeC9tYUVwVGtiT0ptajAzS09DWXFH?=
 =?utf-8?B?dVptbURQNktGNDRKTGFsVVpqRnJadm45WEJOL3FYQXk0S0RQTnRac2pMb2sx?=
 =?utf-8?B?TkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9da85e-ce51-45b9-05e8-08dad9780b1e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 23:58:03.4353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZEvh3HF4tHQbMAVAzfbT09scTfHN3jrLJPR7vYqWPWc/iGqjsgjbO1BN3K86/8iFm64wofHMpNBFc/01k/+35joTkvcCz2HHZFYmmaket4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080198
X-Proofpoint-GUID: UyahlKT9y3F5vtKkZGikcRNZmM5I15no
X-Proofpoint-ORIG-GUID: UyahlKT9y3F5vtKkZGikcRNZmM5I15no
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 4:59 AM, Niklas Cassel wrote:
> Move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c and
> scsi_error.c will need to use this helper in a follow-up patch.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  drivers/scsi/scsi_lib.c  | 5 -----
>  drivers/scsi/scsi_priv.h | 5 +++++
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9ed1ebcb7443..d243ebc5ad54 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -579,11 +579,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>  	return false;
>  }
>  
> -static inline u8 get_scsi_ml_byte(int result)
> -{
> -	return (result >> 8) & 0xff;
> -}
> -
>  /**
>   * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
>   * @result:	scsi error code
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 96284a0e13fe..4f97e126c6fb 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -29,6 +29,11 @@ enum scsi_ml_status {
>  	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
>  };
>  
> +static inline u8 get_scsi_ml_byte(int result)
> +{
> +	return (result >> 8) & 0xff;
> +}
> +

I made a mistake in the naming of this function. The get_* functions take a
scsi_cmnd. The ones without the "get_" prefix take the scsi_cmnd->result.

Could you rename it to scsi_ml_byte() when you move it so the mistake does not
get used in multiple places?



