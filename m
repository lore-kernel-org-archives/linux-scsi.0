Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA2AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 20:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiI2UYs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 16:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiI2UYp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 16:24:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FD5626B
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 13:24:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TKKjib028281;
        Thu, 29 Sep 2022 20:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Uiw32WdPF5L4EbdY4zZF5b9f+3BQlzNPdpfj5RcFuZA=;
 b=p8QgiUfTd+/PhDOera5s/mPiaEq2anukeGy3IP86jDJFQGF9oPTdM624s1JK3ewJ595H
 fAy/aYkxrBT22GwDVXl4Qa0pMDg9yyegCOSnxof3oGMIweLaZd9mb2ts13jKitN/AY31
 UuXnt/rTpbLoypCZ72tMoMEpp2DzLsEYkz4Z3juuJXysQcOXg5EfssbKegDCPkqJw6y7
 BfGDybYcSRoNc18QLWUmpvXVHiKPeneLEmHYv05pjGO3Ym5SnZT1+Vx1KyrCZ+yBmymL
 YH+rp5q/+Dk7paQ5a7mf+ThpD1huSSKFVU6Xy9wBtfd4nwXNKf32oKrP7OrfN1oPsjZX qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubp2wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 20:24:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28THtn7w039473;
        Thu, 29 Sep 2022 20:24:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprwwaen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 20:24:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCbq6DzHZJVPKCRFqwXeUjB0e9qbP6aZblGk2H7lEXqRHBLqVg/d6rM8wBaR4pKbEewya1wWeGZZJKIh9JR7oz+4HobE7IqmRSSUY/DUv2pbLXBz4WsTej5neLw+j1U5EePGqAkjJWfRd1GwAzbjHWa8RKa0OrRS5M/bwkyBxzS4YSs4cWWMO4c+gBEpootTrriuBVkVYmLLRi2RuzUsbEtLOMSdKCoXhUjBxdPu68GytD033qyYnwM8bLycUQkE2NtY7jWlves1IdUxJBMtyhWnOw5ReX//KPpIleLSYF4JwImYehKtAQBGdY+KJiY54mExknChszZPahcGR7gusA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uiw32WdPF5L4EbdY4zZF5b9f+3BQlzNPdpfj5RcFuZA=;
 b=LDv4OIxin9nKf7w6KiN/Ixo6L7PFTio6vMJIQsUk3Eil/2pzJOlpnt/6z7gYsKxH3R9JzD+yT8mGjQtr3EuqaSYtmvpVRa7Ss45KPdICPlb613sML6JlflIHU30y1Jo9kuxLkV/zAOPe6fxw/8S6TZJX5G1FYBRFsN6cTv1l068hjgeDa4OF/tLluXi+NtzK7xm58D2O3kWqevc8Yt9FGvKLG7Gq+TxPceXvu+EqSy9f5NaxCg3hI5swIvWrTjKqlRMe/fAm5Zpbq+An/aAip55PKTGAaIhELGCPJvfGmK/VApjWbSZJzgqkBhojOsCXCB5Z6iSjM2dR5jeIZeGiHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uiw32WdPF5L4EbdY4zZF5b9f+3BQlzNPdpfj5RcFuZA=;
 b=pPBal+sco0mTN0OpNv8cAoOr0ahxhvRi0oqZfRVSyf96obw0GETyLj6oHhyITYQYrIh3xkRTi8wmTxZbGPlGyMHyfFrR15yjpd1Ws4dGh6l+6maptD/wgCDB7AGrVsBoGP+BpwndJxQoJ5DU67BmVO/bPowrz7T2Szk3YNd2V+Y=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Thu, 29 Sep 2022 20:24:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 20:24:20 +0000
Message-ID: <167f3346-7823-eda4-fcc1-61727f98acee@oracle.com>
Date:   Thu, 29 Sep 2022 15:24:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 03/35] scsi: Add struct for args to execution functions
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-4-michael.christie@oracle.com>
 <d77c03f3-9908-1d3d-0526-57cdfb5d5ce7@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <d77c03f3-9908-1d3d-0526-57cdfb5d5ce7@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:610:b0::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: a9580bdb-2c9b-42f5-ff5d-08daa258973d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HrH9AJgL8m2jlSgf0w6wBxRi4XvE1hGX5P2R6wJ3p9sC9SonPVWrAqeebXCAx+0zYr9iivQXp9T1iVLsSXUU3u1WDy14Qlr2bBDHNlsueHxyMI97ydcmJhdC2fHAqGAFH6u2iBQByR8t2ehyDHUuGtI6VVh7yQaNkPYtlxQ8jqfb96Q5uRfzo6M6qUkLnUCleIAADIbxEIVFWGE/X1B2fRwdpOLdeKzJ5TgL3vilQIUfL2YNZ+taL9Tkks6ATgkwqMuTGgUutWfb78vcQSrYiSzvr4lUblAkV3fU8FUdFmtSYwMIvbw5MtfkWybagMGIG5NZhy/wVsJskEwE7/sVZjX4QZsuPpqDDuohqhpanlgCb65xD+c0Rkd/DHLn4We5me4MK/khFJJXQf03xmwsQITG8WIBrA2zeTZ9acYoA3Bxpzk5vIdmTn9RLbKcMvpl6yhQneV5yw/tlYcq+csTJV4Yto5z2E2SHtHJMTCPOfoq3NJ44pdYUGUHKW1Pi8PxaAI5akwSslsWunhtN5jaaMAFRroIbEnca0Rwj5GEQT3MMwcmkebjoTRvUKIAyOC0z3FiMDn8BWxS2p04ug5dBuScoscFFQKsQx/Se2ZDqbQfH3X2F/hvs4/CKj3t/dBhNL6hv1auOybBgFobfzpdMbRV3Rd5OtYNS6MP+8ChRRDZVP4rWXnSr2sHvsYkmQHflv87HJr/hf6j84Vfkz1zYINclM5d5q4qWjFlBEt22T684tUuZiJAI0FfaCZ5hzLxNQJmqfGZ6UXa6ezxKUOiXLMc8bsDYfLh6htrs9In2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199015)(38100700002)(26005)(31696002)(86362001)(36756003)(41300700001)(6666004)(6506007)(5660300002)(8676002)(66476007)(6512007)(66556008)(8936002)(6486002)(53546011)(478600001)(66946007)(316002)(2906002)(83380400001)(2616005)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHNDM0ZjQjArelFnTkRBaS9ZcStjWERzVDhSaFBuVlpJVjJWb3pudUgzeG4y?=
 =?utf-8?B?TUs5NGhGWndSWFFzWm1zK2E3ZDRBRmdRZXlnSWUvZTZ1RWl2dDdKR2M4ZkNy?=
 =?utf-8?B?SGQxS3BxNk9DT3VIL2ZBYzRldlQ0ZlhyTlhJMW5wOTJDSVBVRUZsdVdQL1Ez?=
 =?utf-8?B?Y25JOU1lcXd6Um1idnN6akpaWDNjUFVOY05sUjViTGZmREFDVnpwSWMvMnRY?=
 =?utf-8?B?RGthOUtmbnFXWUJaNXpuZnM5TUdsK1FNSStibWtpZ1ZBaGNtOENreXVQa2cv?=
 =?utf-8?B?S01VblZWeVV0WXhZZld0aWR3c2NVa2NSbkt2cHhwc3o2Yjh4c3RWTzZyR0pW?=
 =?utf-8?B?U09KQUxDZEk4QWx4Q0VxbWNlaXpEYXNWV0F2cDhpb09GUlhrb3VER2hVS1FP?=
 =?utf-8?B?dWdzTEwrM0I4c2E4eHp0Z3NsclM4R3FkY1pVS2NZRVNqdHd4Vmxvd04xYmJx?=
 =?utf-8?B?aERxckM4S2d2MmNaMDhhSG9CSDlya2dvd0M2Rm40UGw1MEtoaUFIOXQyZ0cv?=
 =?utf-8?B?Z0xINVBjRDVlUWlmUVlOanlqbjdzWlVnKzVOYzJNeUd4VDRoNmJtYW14VmxY?=
 =?utf-8?B?MkdyT0oxdXFPYVczM2RxQnYvZURzanliaUhmc0xWa3ozNGVTbEpidnl1UGZE?=
 =?utf-8?B?TGd0dFdzbm5PMEF5VGJ6Wm45ODVQMUt2QVlGQ3dDRDZNQTVtOFZkb2xhVFhR?=
 =?utf-8?B?aXJuYllYa3FBNXV5YmZJVE5FNmJoUkxrdkMwb20vemo0Tit4MWxnU1RGemc2?=
 =?utf-8?B?d2JpMmUvQXNIaHQvWHlTejd6azRNN29HSzFCUktrZEpxVXhCRm00eDZsZUNl?=
 =?utf-8?B?N1Zacy9xdEdGdHRZTm5XWlIwMVZseHZwSkpDNzluTUMxSzkrZ2FsV1J5T0Ro?=
 =?utf-8?B?Nkl2TDY4dStPMlZWWURaRkl2UkloUzhCaldHdUJucHBMYllRYkgzMHZPYS9n?=
 =?utf-8?B?QVNBZk5QTTFhSDNOWGIyWlh2WFQ4NDdVZklibDNDSzFydTlETjVzYzlzYklr?=
 =?utf-8?B?di9YeURKQlliUHpocFd3NDBCWHpBTWlYNnpMMFZXYUtvb0lhdHZKNjJlcU5P?=
 =?utf-8?B?QjV1STNzU3FWTUxjY2ZuM0kycVhUMGNPZStHeWZ0eFpBeEdzSENFN05YY3BL?=
 =?utf-8?B?TDU3SzZLbTVtcnBPbllJWnNkTHZ2ajhMemxnekhaVTBlTENyQnlYeklQTTNv?=
 =?utf-8?B?cmxPV240MG5XbDF1eURDS08vV3FGTG5KcVprZ01Mc0orU01JMUZCeGRqcGln?=
 =?utf-8?B?aG0ydFZHcE1taE53YUxRZkNQT0xJMVJlUTRaYlpsbldmT1h5UHl1bjlidVNj?=
 =?utf-8?B?SmxrcE0zYTBqMmhpNjlDUVNPRCtMb0FkclRwRDFoWjcrSm1TdjJrSGZYbkh4?=
 =?utf-8?B?aW1qblVQOHpQblJyeXpNZXp0ZW1TZmZaY1FaNkNXZnMxODRvVnQwQktuaVky?=
 =?utf-8?B?YmxXVVJ4U3V4dVdOSkgzSmdyRmw3czAvQXFDSXZPWTlmem5hZmFhOFlETTJS?=
 =?utf-8?B?NjZ4SDBCQTRHY044Q2hySjZtZVltYTgrd0RLWHlQRFhaLzI3Wmhac3BIZmtx?=
 =?utf-8?B?SDFGVGJpaGlMTE5WNXlGUDgvaUJTNFBFNzN1VXlnNUFuRHU0SHdNeUV3SG9W?=
 =?utf-8?B?Z2xiMUNabHB2RXNmMXl6ZEMySkxWaU9ZTWZTY01tTnlMck5yY1pvVVA5eDlr?=
 =?utf-8?B?ZzhyN1B1UFVPRHdPMjRxcTFHMDBVOVJCNDF3aEhjVjdaSVl5OFpDeFBvMjZZ?=
 =?utf-8?B?SDY2dytvUU5aOWtIMzFjVXhCU3pjWWNia2dwZEtYR0JqajJJWkNjL05yWEZq?=
 =?utf-8?B?VFVsWFlSR2U3Rk4zMHZvdi9FTE8xQkFGRUY3N0VVbzRRcmswUmNxdElmZXlY?=
 =?utf-8?B?TnBMaUNFekJxUFYrRWVrQngzZEVoMmFSNTdwMzZSSlhjU0ErY29oMGpUem9z?=
 =?utf-8?B?WXpzNVY1eE9yN3k1VG5tU3hNTUswVjFlS2NzMXEybGlXSCtSaDZxRnpnTWpV?=
 =?utf-8?B?SGhhcEhxUVdhLzl0cFI0WWNFR2lYVXlmVXl6MW9mT3RGMTVocXh1c0N4b0dQ?=
 =?utf-8?B?eVczMGp5OE9xVElteWhRdjhsbHlLazQ1RGJ4MXNIbytkdUxQQUVGZ1dJQjg3?=
 =?utf-8?B?bUx6Y0NHZFVJU2NuN2taNjZJaERKWGlDZTE2SlIzU2ordVRYd0x5TEFkelRs?=
 =?utf-8?B?SXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9580bdb-2c9b-42f5-ff5d-08daa258973d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 20:24:20.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7a4iR+2MbgVVocbHQ8P5SIoWOaz/LgM7iO4cRhXZ8Xo4GAULE+oZdNmrfsEkSpgHOD+UgBmUzw682NSe+LDe4UPvTV1uwIdQ6Vrryfdq3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_11,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290128
X-Proofpoint-GUID: 2jPyKs1gkphWPe1uwuomrkp8QvLDls6h
X-Proofpoint-ORIG-GUID: 2jPyKs1gkphWPe1uwuomrkp8QvLDls6h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 12:02 PM, Bart Van Assche wrote:
> On 9/28/22 19:53, Mike Christie wrote:
>> +/* Make sure any sense buffer is the correct size. */
>> +#define scsi_exec_req(_args)                        \
>> +({                                    \
>> +    BUILD_BUG_ON(_args.sense &&                    \
>> +             _args.sense_len != SCSI_SENSE_BUFFERSIZE);        \
>> +    __scsi_exec_req(&_args);                    \
>> +})
> 
> Hi Mike,
> 
> I will take a close look at the entire patch series when I have the time.
> So far I only have one question: if _args would be surrounded with
> parentheses in the above macro, would that allow to leave out one pair of
> parentheses from the code that uses this macro? Would that allow to write
> scsi_exec_req((struct scsi_exec_args){...}) instead of
> scsi_exec_req(((struct scsi_exec_args){...}))?
> 

You mean like:

#define scsi_exec_req(_args)                                            \
({                                                                      \
        BUILD_BUG_ON((_args).sense &&                                   \
                     (_args).sense_len != SCSI_SENSE_BUFFERSIZE);       \
        __scsi_exec_req(&(_args));                                      \
})

right? That didn't help. You still get the error:

error: macro "scsi_exec_req" passed 8 arguments, but takes just 1

