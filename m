Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A1EC4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 09:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiLEJQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 04:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiLEJPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 04:15:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4E3FAD5
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 01:15:22 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B57XEM4002327;
        Mon, 5 Dec 2022 09:15:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LKhF8sF8rehAATKntXMD+QzZVIvuXotMRyVJKOrBHzE=;
 b=VaQV4594KNsVg2BSzccrsJt2rrQYMZd1KWhcPOJyAe/m8HdFemU+nxTnx8FkAtvL6Llf
 AIGuWgar1kPgE+3SF+9JYVJMizVQhpcCuI5Szyjv6pCZIP4LXAr66pIBS4ntQ2WMPDaM
 btpbHs9bnINLk5xgoYst29bHYAvIT03EK1j/rcEwIwg/Yf+JOmjVLeQKHhmaiBjGyLKd
 vz+2HTyhfKMveQ+uycj6z0BbHJc9QaTAIPNZ2dyFMNTQYQcPGt2p/vk2G+ZtkwesGjLQ
 IXwql1EMyfAksaqtnOzFrT3YyeIm1Tldm0gC5AsTCVlJgwk7euQ1mzLrVHJ1VWhtXTN/ vA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya434qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 09:15:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B58wjJt021528;
        Mon, 5 Dec 2022 09:15:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ucsbneu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 09:15:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmAvCZ2OMoafp3phVMFV60cZ6xKzFuIrSfLPrLmp6m1VY9tIDXbvtNWK5atsCZ6jvCmQEIJWjdDaOMR7H4KA2F7csn94XjnEzZ1bkaYFPIGayDvmb4TCegIJ8dv1jsMrPIITsEOCYULJrG7XHuhJVgueZ8ZSWVblxIcXlfr40MZOf1Y6tOWuwVQ+VBzF6YWOT5zZ4AdCgCb398+wC2PO8k7AO9O+IB++Zg1y1mAloY02PTVh3m7JVfwVZD4YdNknP+KnShbWK0VlVOM6p/dBTDwztxYLXDjbaZbMsEpnaq1V+JcZta8CgWHY5xVhelGgCOkRiFLV9YC3F+shDnzJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKhF8sF8rehAATKntXMD+QzZVIvuXotMRyVJKOrBHzE=;
 b=b2bdOJNUd5MafDm2LX1iYnhLw2T2GkBeWUs7OO0FFKxGynk9BvjNWCaz0S18KNFC9bsRW/WFYnq0L6shtJ28q54wmiJ+E/3Zea+OtnaSyWePL/FM9F5WomXobhcvM2faXKXT3vVCQY37BxxiCPPOnIdLXbS/3RVxNGlt+LIALbTiuu4sJw5neyw9hf6m3S2ePknLcUR0/pMlsyia2pXXJvqoo9ojo1glm+gTL/yUhzIbW7r9eIEIwKwh9Y8ov3vtsq6zNJujhcf2VuTwF7LF49FwAv1DxuSOh5CXe8wQoCzktcCfaMDJrgvmbgrZENuxBhx4KTCx4875HIJGBKFVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKhF8sF8rehAATKntXMD+QzZVIvuXotMRyVJKOrBHzE=;
 b=LGpLlUn1VL7MZJbgHIG7dwtOJv9b7XhocNSgEiq4vglTvlDvLLxxCprrhgkRPz59f4g4UsctrCgJsNnbdGmNpa+BXa/cEfbYvpRW8c9R6Mx+RM9KlEyQxtt6nbIhRtUFqQtQzNyVHJqbsLYaRCyiYhYsemyT7F/Ix+hUIuHYVG4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7378.namprd10.prod.outlook.com (2603:10b6:930:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 09:15:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%8]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 09:15:01 +0000
Message-ID: <aaeef818-97d6-6f38-4a10-36a5d5473b50@oracle.com>
Date:   Mon, 5 Dec 2022 09:14:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 4/6] scsi: libsas: remove useless dev_list delete in
 sas_ex_discover_end_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-5-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221204081643.3835966-5-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0401.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e779404-2b1b-4661-1447-08dad6a12f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWvPBCLeZqrlYHCKEAR/8lbO86j3kyR0wuG8BOBUnVLBJ8ms4L4c46zTjpw3TZfMEzS7pqFXuZXob0LdAhNQn4Iz2VoHBoWA+oazvdrrGyMpIkKVViMm2KQ15BCG5gJm8F0I1i73Rbtmyi0U06chmpl8+KqNdqwboaBci8PYN1ylRsDR58YWwbXdjG28kumA9KXuY3oVw/N3CNTYAS0xyDz19arUYMLUidZ4SS55eL4u6/RVUPEQAOswmlmeYM52oqNCf+B/CvU/N8ml7xwjWVMS+n4ur5iGklHtUNsFUzBD0mh8y7fmKhft7RkU3cyfUo67iNcbgCcUPXWPWFRvYA6+84ve2BnIgQvPr3zm72tXVp2QSllGqbypLsUvCfHTxFBYnuOseg8pdAg7w2JwU+6Y/Pe5RuzrfwDqUzukLm2NmhquKWcq3/m90YSCOt+5V/H/p9A2ZQFgLk8pMNeXFBxcByfRHeUjZNMa5y5RiAQ/E3Xbm8bpmHzOT9KkDgkahSCPxuHg5I1ytskb9BcxpQx1bfq9m2szIzDkmcvZvzNAPaq8fFjot+V2liwoUeHmncH7mqYuQBSWnK0n5rJC3QaM61l9Xjc604ZCnE8GV4M5gwpfSoc/IK27Bhgd3cZBShbM1tOg39pYLDivLbS6V69vUt2KbVMm95YMJWj4+8uTbrlOFsBz/gbs2Yf+v9tCI9ldVcmlkRnJYpuHD50s4JMqnvftnqQykKyZJDjjAek=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(31686004)(86362001)(31696002)(6506007)(478600001)(53546011)(36916002)(6486002)(36756003)(2616005)(83380400001)(186003)(38100700002)(8676002)(4326008)(5660300002)(41300700001)(6512007)(26005)(6666004)(66476007)(66946007)(66556008)(316002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDFBKy9OTGJkK3V5Wi9DUUxnUE9kWldUQ256Wi9zeEJBTDloa2FtSGt0aTNR?=
 =?utf-8?B?elUwWnFWb2JWdFJDYmV3OGk2SHFHRFBBOVRjUWVmaWVRSlI5RWt4cVBueFVr?=
 =?utf-8?B?S3RmRHlDdzQ3b0RzUUNDVm1uc0M4UFV2TUFQcGlKNFJJdy9waXB6RnpOQTA1?=
 =?utf-8?B?RkRnUEhIRUJEUE9iYVcxSDZGaXkrdkpSVUxiaDY4SU1RWjZ0MjJmWC9kVGo0?=
 =?utf-8?B?VWZBVjhrZU9XVGtZOXJraDUrQjArSEVMZVA3OTJ0Nnk2WGcwUU13NFlVSUln?=
 =?utf-8?B?WnBIeU1nZ3hoWXlMMmRRVThsOGZqVzV4em4zN0oxMTJSMEtJV2I0Qk1LbVpu?=
 =?utf-8?B?NE44VWxuZmlVMGZWMktQd2xId3YxZmtFT2NWekFjRE83VVZzUDI0STZ0RFR6?=
 =?utf-8?B?S0p4cUZuWW0zNE9ydDlFRVpMYjZEenE2N2hvUFNURy8rZEhPOUZaNHk2MVQy?=
 =?utf-8?B?UlhYaEJoSytRcjVqRjJqcWlTMjZmckJnRlFvM3FsUjNwSDNWajRISm5jYnJV?=
 =?utf-8?B?V29DR1lnRUdrV3c2NUNhSThqNTJ1ZkRucDBvMjcycGppYTkxekd3cWNad0Ni?=
 =?utf-8?B?ZFFGMTNuU0lpcGVvY1NnSXRMMkVuNDg2M3JDbytnZzVvRTJEVks0eHV2M1hy?=
 =?utf-8?B?blMxeXZtYjdxVTZOdnZ0SHVRK0hXWkpnTTR6L0VoTi9tQ2lZTmF1ZlBmVjNw?=
 =?utf-8?B?NFpoYitEc3lmRFNQUCtSb1dTWENSWG5FR25QQW5pOTdzVFBvQUgyc2hmbG5D?=
 =?utf-8?B?TXJaaXBKMWY4dEFIUjlRYmRTdXFDQXNPaE5PM1QrVnlJL29PV2ZzOXpYNlZv?=
 =?utf-8?B?dTVTR0xmM29sTTBMbXRzOTdLTTdhaEUvZmtUNDlBSG5xYjB2RlllZ3c3d012?=
 =?utf-8?B?bXNOOFhkQ0dYV2VkNjdqTXpvRnQ4VmlaSWY3OSszZWEvaHFoVjNTTmZtL3F6?=
 =?utf-8?B?aUc3Q0UyUTlIbjQxN0V2WjFpdlJra293c0N6Y3M4ZWszcms2dGtBUldNYjlX?=
 =?utf-8?B?WHlxVUt1R21la3dPaE5aV1RwZHJiNDZFWkF3Ylloc0tXT0NqbGlUR0dHTFpu?=
 =?utf-8?B?UGtaajRNQjN4UnFXellpWmFkM2hrbWcvbzVydmNIU3gxMUw0L0wvYmlxS0l1?=
 =?utf-8?B?S3hDNG5Od2RDUGc1dytBRFFENmxUV1U4S2NOVG9ZZUNHeTluN0c1R0lZcDM2?=
 =?utf-8?B?dGUvbGlBQ1kwMVppbEZCYTN6OVkvYnZVNlNxSDVwMlRVOWp4bkg5VFNtMlA1?=
 =?utf-8?B?cWhEdnpsVzJ2R283ZDAzcklmU014UlBPblc5bXpUaU5MWG1JRjZtWUlOT214?=
 =?utf-8?B?dU5Dc3pGU3NiU0kwNFRUNU8yRlV0cFNXaXVNbTVodHllMXR3anQzN3lhcC91?=
 =?utf-8?B?R3VvNmZBZ0pBb3Z2dXRoSXJMKzdjSTR5bjl6NzIybWszQ3JlMDlmTWdqV0pX?=
 =?utf-8?B?ZktQWnZNUWUzZ2h2SWRYUDNhdXZhbUkvM3dLK3NTd2FkbDdtOXM2U2dHNHEx?=
 =?utf-8?B?YVllQnlCcVZRUUlCaG1xRnc1VzRJNCt0VmdDSFgvSS9IRER6SWk0SThEOXZs?=
 =?utf-8?B?K3p6eGpXb2lyY3BvYmhTSGNlMUUzc0xmNkRrVzIySlg4QVZCNGwxSS9XcktV?=
 =?utf-8?B?RG1NWVUzQTArQmlmaHdncm56aldxb24zbDBzU1lDa2NobVdsMlFQU3N1OWJ1?=
 =?utf-8?B?ZWZDTDFBaTByTDFOenZnMjNaV25aNllITVpoWDlzMGJKVDBCaVlFYm5wSmNv?=
 =?utf-8?B?ekIwKzRkeVZ4OHE4SEo4K05oWHY5RGUwTzlTR3dQZTZmUWdvNjZJY2dxNlRZ?=
 =?utf-8?B?bmlsZ3hVN2cxL0Fsd2hpWXJTK1E4a0Fza1UyR1k4YlVqbW9UNk00V3VMMXQv?=
 =?utf-8?B?Rlg4TUtjalY3blJPMGtjY2djNXZwNllRaGZtRzFOMzEwYWRxQ2NXUHEyMkFD?=
 =?utf-8?B?Y2ZQeWJrVmZ6MHBUTjBGRTdnMUVWY1BaaVRvM0VJcnhtbmpTblFDcFJsdllY?=
 =?utf-8?B?SmpWUjhJUksxZHlSOE1KUG1tZ0dpaVh4QzhZTmV4QS9FWFJVS2VtYnROaHF1?=
 =?utf-8?B?cmU5WXQvZ2FZcFllQVVLNW85bEVLZC8yUDZDSC9Ib0Y3Wk9zZjF6Wkw4R1Qy?=
 =?utf-8?B?VVlzQ2ZHellYRllmYXRFODhKQnBCUldSZFp3Z05FOE1NN1Fxcys4U2dCdUYv?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NFcvd3p0RXN2L3hjQ0dsUXBNaUtYVzhUVlVPMFBDOHQ3WW9XM2wycXk1Rklh?=
 =?utf-8?B?L05JbEFGUFVNOFZiREpOR1lkcFJlRmRteGcvMVRqVklZZVJ0SGdmbW1ZNmh6?=
 =?utf-8?B?a0ZwMngyVjdWUWhSYllTRFVPZW9Ca08rT3pUNWhKd2V2RnplT3VRTnF3d1pX?=
 =?utf-8?B?WmtnT3VQN1E5WEc4OFQ0NllLK0ZJN2dSTTVYdDl3MHcrbFB2bVpscmlwbnRZ?=
 =?utf-8?B?QjRFMTVWNGFMVzc4eUdyN2hTVXEyOU1LNXM4ZVhLTit6aDYvYXFRRi9rS0pm?=
 =?utf-8?B?WGxGRXR3UzdtR2RJZlhaU0tCeFNRQ1dTZFpTckdEMFZtTFQzbzJVcnpod2Va?=
 =?utf-8?B?ZWlEWnRtT1BYajlYQmw4TjNZNzdSdERuQ3lRNlI0YUFBRHdaN1N4UGJzV3Rr?=
 =?utf-8?B?Z0VQSVg1ditMM0dKRklwelo4Q0p3WVBJL2o3M0pRb1VqMWI0SERxNTlSUzE2?=
 =?utf-8?B?V0pod1h4a3VvbFVtaWdpY2NxVG1mNG5ma0ZibWxYUFlnUnVwUzZSR0lmZ1Jh?=
 =?utf-8?B?NENuaHlIQnJZNUxGcERUNllmZDR0ald6dlpBbVZXNnVaMHRNNDYvMitpWEJs?=
 =?utf-8?B?RFdoRldGcWE2L0JLN1Z0bXUwbER3TWE4MVo4SnowS2VoMVFlY2EvQVkrdWhB?=
 =?utf-8?B?Z29TVC9CWDFQZ1h4VzE2cFRTODRCZ25wNDRKM1lEWEFPOE5ITCs2S2VjbFRL?=
 =?utf-8?B?Z2cxQkpBNU5sOVNGWEFqOUZKek5Dc1B4SXp4OFBubC9BdU5XVFVVRW9uMHEv?=
 =?utf-8?B?YjN5LytXZi81Kzg3NUtRV25jTnpuWUdTWXhMQjZ5bk44MHZBdC9PL0xVRnZZ?=
 =?utf-8?B?ZzNFVmdVVkh2LzEyTlBGSnhMVVM2di9Mek5aVU4xQ0Q5bDFGTkNwTDJTSEYw?=
 =?utf-8?B?TnVONHlNck9pRlF2VWQ1WWpRQVVMSGRLRHJXMzZUUWtVbUFUL0hibUNUZkFR?=
 =?utf-8?B?MW1yc2x5cWN4c0VoR0pBN3A2UWtwaHArd09zUTdFVVBWek5ZWHBtK2ZsWlRv?=
 =?utf-8?B?K29abzV0Zi9QTTBVaWluQTh2USs3N3Z5Sm9uY3dhd2VzTDRyQ0JaT3p1Y2xN?=
 =?utf-8?B?a2lhaEpRK0pSMmdiSFBzK2NXcXpGRTEydGI1RCtVQjZKb1NaUExKN0dZMU96?=
 =?utf-8?B?WXNraVBVdnN5TEJWWGtGbTFXanQ5U0Q3SVB5WUxqVHhDMDlLY2diT3lEOEhj?=
 =?utf-8?B?N0ZsSHFsczIwTmV5MldGelVPOW1VWTN6SVBlcURNQmQ5WVN5NDNkdkd3cm9P?=
 =?utf-8?B?aXRxd3hwNWdYcWxDWVN6TzNHYk54YWRKS3crbVlSdDJkODhmSHVPYlBXdnA1?=
 =?utf-8?Q?oatsnWSrUC5p4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e779404-2b1b-4661-1447-08dad6a12f91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 09:15:01.5420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SIMbkA94HSPDzLMRqEmBbXy/yk17jLp/Tz0xd/CZ8p2VoAx7pd6f3MWiT4w65hp3Fo1qjQ2Fp2iFkCa5JGCJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7378
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050073
X-Proofpoint-GUID: UUfZTZr0NS6HYCxHX746HLRZ04H7aWp8
X-Proofpoint-ORIG-GUID: UUfZTZr0NS6HYCxHX746HLRZ04H7aWp8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/12/2022 08:16, Jason Yan wrote:
> The domain device 'child' is allocated in sas_ex_discover_end_dev() and
> never been added to dev_list. So remove the useless list_del() and
> related locks.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index a8af723fab3c..82ea7560a888 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -875,9 +875,6 @@ static struct domain_device *sas_ex_discover_end_dev(
>    out_list_del:
>   	sas_rphy_free(child->rphy);
>   	list_del(&child->disco_list_node);
> -	spin_lock_irq(&parent->port->dev_list_lock);
> -	list_del(&child->dev_list_node);
> -	spin_unlock_irq(&parent->port->dev_list_lock);

Since we have the spin lock'ing, this seems to be have been 
intentionally added (and not some simple typo or similar) - any idea of 
the origin?

Thanks,
John

>    out_free:
>   	sas_port_delete(phy->port);
>    out_err:

