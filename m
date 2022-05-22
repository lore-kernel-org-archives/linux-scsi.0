Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B7BC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 22 May 2022 16:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiEVQFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 May 2022 12:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbiEVQFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 May 2022 12:05:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685C9167F5
        for <linux-scsi@vger.kernel.org>; Sun, 22 May 2022 09:05:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24MDXnxi026088;
        Sun, 22 May 2022 16:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9rBNh+k9L7CzXdlqco4VHh1HQalVVK2TRMvCsng88LU=;
 b=VPsStNqtzzpSLusYH3Dc31VCZGsPzwbi/XvlMr2LxWtpufkFDOCcdBWWH1kWGmipvQfb
 uciYvU9AM0Ax+Ry+tLAuD1+sCF4gYAkB7mAUYkyRTeQlzjNW+2hACx4nl47/vjBiXXY6
 VZ+fU0cMyJMS8Ct5phUmyrTN3HHH8vn7C7E/U6cPX43/gDguu79mLotGkESqTGi4aqi+
 KNHbGUOqvxgMYGEmxr357/p7hxblxQoNNfB3j/QdQexR6p7/kW6ENP8PAUBU0fXkjzI+
 OjUVJNrQlkVavhcHdBxpoxYRfTzmmEEI8yhV57uqddCNHveF7NmGjkVW4g/W6gpUqGOO rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qya1pq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 May 2022 16:05:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24MFwoQa007320;
        Sun, 22 May 2022 16:05:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph0wd1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 May 2022 16:05:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIzVriWOhoKBIXTMQsV3vhOzI8cZSpap3VkdY8BzBhLFdiVYQPNrSdppt4APwZgkmDfwhEFvewe4P/K34ialdFmIHHQu77lmGqiHRu0eaB4WQmQ5ELXpqTm2Mvx0iSgFV0I1GOznHLYXxmNy7pv67zuHJdANmUMaa11mK93V+ceDkLbRhqg+rS5fzVt4Kcm4ksYC9yPQlzVP2H+9ixKO0kfYe9zXKxyUeSq9TI4p6IfdK04/qz5tTgo4RjjamlsK7BA2x8slhbe23nBin9oV5El+F597T0hfqtiBbDlf+fBQbMmlAw767hJBifde7T358pxzGT57Thb4pvVQiXkccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rBNh+k9L7CzXdlqco4VHh1HQalVVK2TRMvCsng88LU=;
 b=XUHP/30hZb9ZviSBugJc3a9PezOi6baMTquV968j6tfSU7FhvEcIXZlQQKd12H6ha72iFVwGOazmF8oVNIq20+C7oyEpDFl0iEbOUAf68O5f4lp149qf5gF/hxihITOQkeiBzlc0+u5FiVPHfYzSTET6h2YWHQZhl2HkZ/8oKnmcSzod82OCjT5dnfLgOT7D3zSSeLghV3NDs0/AdDHRbwiFIjbF2GWv4qplA8PA7nh3zVRaoQoFd5Lk3WsRGD4YHcMDGpUaX24olS1sCZemD4V2SFw7SMtV1oKpmtwkwPRfjVyapgqZoG0Q9XrnVFuBMTLFz8K5HwuC1NrbbrIRRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rBNh+k9L7CzXdlqco4VHh1HQalVVK2TRMvCsng88LU=;
 b=UCV1WTqA1Vq9U6sJsU3OIRc5pAecWg59TUiIVZxfAchXWAzvKZWfVx6mVqVUcyexzNE6nCSZIhUo7XRNATa49LDBQ4SXJezYlw68XJrqDurLVRBW94vR86cWbCwv82y2brUgA2a31sdEc1pxpXcgZhPVJuJztVYDYr+9lQR7xFA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4900.namprd10.prod.outlook.com (2603:10b6:208:30c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Sun, 22 May
 2022 16:05:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 16:05:32 +0000
Message-ID: <39c7df3b-fd51-bc7a-1227-48a2fe786b03@oracle.com>
Date:   Sun, 22 May 2022 11:05:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [linux-next:master 13298/13468]
 drivers/scsi/libiscsi_tcp.c:563:2-8: preceding lock on line 542 (fwd)
Content-Language: en-US
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Lee Duncan <lduncan@suse.com>, kbuild-all@lists.01.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <alpine.DEB.2.22.394.2205221153070.2871@hadrien>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <alpine.DEB.2.22.394.2205221153070.2871@hadrien>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7305177-94ee-4ca8-fed7-08da3c0ce5ee
X-MS-TrafficTypeDiagnostic: BLAPR10MB4900:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB49000D5534839CCF049F6385F1D59@BLAPR10MB4900.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3h0jKkJYYBL7AtxeYsfzHUSmeP6Lam/OW6++dnHhPNGWSa+riVHEyFM2Zce/fOwq8rYt51gCQ+w5d4GiQSOk+HW91wpqg82BCDKOWCPkZTubP8bEwfnFFoD7SMNvukuO1n0JvD7csiPp3GlijyGuI0AVGDhZcNzJP6a1pGQ2n0GbDCjhIfjusqA12EXyqhZb5maP6XfNxmlHmre1meKTD56aQIFv7iaX8F52Eybm2LnddDJZ04PL2+pG+NWUs+iAUxkY5M6J8bdG4LSafdo5oW46JBu8zsKo4iix5i04+3WhzLwzi7djriGmyZFB9k/XxWPRsZmKrBzvDNRIhXXc21uFJz5/nKK2Mkj/eUMsPqtNLWb73BJwnYaS4SA0gSlw8GZKz1dNLOMDjm4vtBaH3u0v5tpjVef66dEG/YFEh3PEMtbPfg5AUG8V5K6L7JC4EPtOoSkN1sjtFgtDhENV9tn51yCJJYqW41hIdpQZJBOrZpWyoRBTpHMXfdzAGiBpcvmSYwAFeD4ES/05CiSqcKqzlhxAHT05FetLHnewayW0JAAGGReJ1ECn3xciZVY17z35+mOfDKi9iNq2u58fOcQ2ASkLL3vYy8D1hT4XvlBp2ExNBFLooADyfr49bNdiW1D6PZ0c8p7UDlsIuCkbkWa6zF9/fkdnnVj2USgDSBPPS3rbbhpjKZ9Ptg3q/QjPuu8IZfJp+wX9+OjgedWE70VZnfqzl78jauyO14kRCK4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6916009)(5660300002)(31696002)(316002)(4744005)(508600001)(86362001)(8936002)(6486002)(38100700002)(66556008)(66476007)(26005)(2906002)(2616005)(186003)(36756003)(66946007)(53546011)(31686004)(8676002)(6506007)(6512007)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWtQV2Z2ZHEza3VNekRoUGRiaHhrNk5XZy9vOG5HQzlTWDk1dWJ6QjdObUdD?=
 =?utf-8?B?dTV6dWd5VUNENHZIR0RGQ1NOdFFrR2Qxb0NhMWY5M3dVeFlCODh4RzlaYVJq?=
 =?utf-8?B?Q25Ma1dKcG9YUGUwSVVJbDNQTmp2dEZzV3R0UzJBM3lpSGZXMjFTTTJYUURv?=
 =?utf-8?B?ei9YV3lMOGk5R3BlUmdZOURRQ2oxaHBXYmpmMWVjY3F0ZXkyRExnM1FlZVAz?=
 =?utf-8?B?VXlrSnNHaTZQWS84ZFpVZEltL2RUVjlURTZzZ3FUeTVWaHp6Q1E4RmFNQ2xP?=
 =?utf-8?B?cG9jVzY2dndONjlMNHVFRi8xa1ZvSmxjKzRHZ3RmNC9NUFJIcHRzVEVtekg5?=
 =?utf-8?B?QloxUlJFcVRPN3RTcG50TEJYUWhrZUFLbm1XT01xVytneGFsd2p6MlVXSHFE?=
 =?utf-8?B?SHJYL0x2YndrQjFhdHJFQjZndFErbVhHRjFDT29NeW5pSVdJOExlZ0dEV3ow?=
 =?utf-8?B?K1ZjWnBDK1ZEQUp3bGZFaGs4dVM3ak1tcEJnNXVna1ZFV2srT3lZWDhVNWI3?=
 =?utf-8?B?QjRnVnVCQkVwRURVQmErZFUrZVB6cGt4bDcwWEZuNVVzMWw4RGpKZ0RyUVV0?=
 =?utf-8?B?VE5kRWpJdnYrVGVGaDY5SDRaUzdKVzhlVEpBd29kRTRydmhBdEZlSWtqNVgz?=
 =?utf-8?B?WTFRRVhkTXQva3NQTUZkZTI4UUpRVFpld0lGUTUzcG4rZTlBQUdxaGR4cGFE?=
 =?utf-8?B?U3Mxakp1QTVXKzYyRHo0aStpMERyd2hTbzFQcTllOUF1WnlCVXZDcndtcDZp?=
 =?utf-8?B?ZWg0RHlFQ2MrNEREcHVNQ2ljVTh3K29WQjcwWE1nSEE1Z3M1V1lQUjRDRVBN?=
 =?utf-8?B?YXRpc1lCU3dnaHJIWHFrYW1BQy96OVRwRmJPNDZUQUpEQktWNXJIK2cwdC9B?=
 =?utf-8?B?Nit1QnMvdlVQa3RReXFKTWNsZ1grQ1ZOU1NFeU16QlJmNUVBc1JFellad2t2?=
 =?utf-8?B?Q25UeEdBQS9qT0ZwYWFkOEI5N3Q2UEMxM3ZlQUpucTQrU01RNm9nY3JnSGFu?=
 =?utf-8?B?c2NDa3RicVFUSXl5eWVHTlA0dm1XUy9DVXAvT3g4NTRNb09LOERLNjBZaHZZ?=
 =?utf-8?B?aXloNUtNVkxRZW90d21iblc2YkF4U1pPeXhYNUduMUdwZHVHdTlUYmN0L0pu?=
 =?utf-8?B?Yjc4WE9EcVdnWHRlMFIvaWVhTmdITi85WXRZMVdiMlhXaTZRYUtzU0Nlc0VQ?=
 =?utf-8?B?dndObjJQWDRFNEJLcDJZNXZJSGZLclFxZjM0Q3l5eUFPcEJObUI5KzdlMWFQ?=
 =?utf-8?B?VUJleHZUdE9mRit2bjB2ZUVxRkZyYjdtTFBOS0M4YUs5MWVrVXFIOWlXaXJ4?=
 =?utf-8?B?bmU1WWRRUTZVaFZFdkY3ZDh0TzNzZDlnbGJ3MVIzbGRsTzF2dWFuNXpxMDQz?=
 =?utf-8?B?RURsWnNCc2NwU0V0b3Z1QXFFNlNoVDYrdExsQitoRUtUbHRzTWp0M2RvNmZ5?=
 =?utf-8?B?TDNIQXZyaGNJTm1ZWmJ2aXA3Tjd0UUZXb1ZiR0orTEdZWWdBTXhENnRQZklW?=
 =?utf-8?B?cjFQczY2czVSNmtycmJvTkRZVUo1RDdrNGVyaVhLL0grVEs1K3hrUnhSZ0xS?=
 =?utf-8?B?RzNPc1J0dXAwbHc4NlM0ZkZMekh2LzVhTGNrOEh3MzF4VzBHbEwxdWVMVENL?=
 =?utf-8?B?WVlhbjZudWRPcVI2UWlKU3lUelJuVUtxYVhuOVdoWm5qYktTdjJ0bk1BTktH?=
 =?utf-8?B?eGRyTkdFV1FWYVRLNDFhTEp0QnRFa3htVDJOd0Y0WWxLL1g3bHE5VzRMc252?=
 =?utf-8?B?bE9QVlNjcDRORHVxM0FVVFF4SStHYWtLUXRLZEpZa1BGekRybGZFWVphaTc5?=
 =?utf-8?B?RU1lSERVekpVQ3VoVGdMbHB4RFdrUS84d3NrUkdneE11dEY0UTBTdUs5bXR1?=
 =?utf-8?B?MzZUMGxQWGtDRklwMTBNeHBmT0VPb0xmZ3NqVEpxUzlGalQyVmpxNTRGQ0xV?=
 =?utf-8?B?MG1CV3lBWFVwUDh2K1VOZjBuWWl0Rm1qUWdndVJxVzY0L2EvOFcyRlRIUTNQ?=
 =?utf-8?B?cE5SVjFIN3JPODgyMmZkQmNVS29BdHFIcHNqNUVDQTJpS3Z5OTg1L1ZsbDdD?=
 =?utf-8?B?NDVrTG1FSFd4em1yVjdpNUtpcE5JZytLcGp0NEk5SkdIYzhNTXlQUDUwdU5V?=
 =?utf-8?B?Mzh3S3NVcmpUaUptRUE3aFY5UDBCRkJTT0tnT2hOQWhSVXJvTHZlZFNJekFK?=
 =?utf-8?B?eHJCb2c5UHdsQ0RpL1EvWnRQM0xjK2Z2Q1VzaVE5UjFYQUF0MysrNVdGSHo0?=
 =?utf-8?B?aC81NldPWDBhdGdWK0lxNmVya1lmc2ZEN2hYMXpkSDFtS0poRy93cURZdWNU?=
 =?utf-8?B?NkpBL1hENHJDemFwelE5YkJwS1p5b2RxdmZPcUNSMzB6V1NPdnN2SXFFSW94?=
 =?utf-8?Q?rmvuXchQi0BTJZDE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7305177-94ee-4ca8-fed7-08da3c0ce5ee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 16:05:32.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X/Yro92BaG92QS45OQRI1EkUW3POwW+D8i9SuVwWvG258MdsbqVgRdLmSJJ8oDUj6TqBmCn90tAmK2aXZsz5mgiUTtPpucxOHs8HyroWvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4900
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-22_06:2022-05-20,2022-05-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 mlxlogscore=903 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205220100
X-Proofpoint-GUID: bLGs7kGeZVg1XgR9jM-EwLExe2aRV4PW
X-Proofpoint-ORIG-GUID: bLGs7kGeZVg1XgR9jM-EwLExe2aRV4PW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace linux-mm with linux-scsi.

On 5/22/22 4:54 AM, Julia Lawall wrote:
> Hello,
> 
> Is a spin_unlock(&session->back_lock); needed before line 563?
> 

Yes.

Martin, because the patches are only in your staging branch, should
I resend the entire patchset with a correct patch? Or, do you just want
a patch on top of what's in staging?
