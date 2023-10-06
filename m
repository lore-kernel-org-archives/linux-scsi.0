Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7B2E94136
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 22:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbjJFWjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 18:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbjJFWjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 18:39:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B8983
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 15:39:19 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 396LOPTB024925;
        Fri, 6 Oct 2023 22:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2INWIUSx1ETHu4Xw1BAy+C6exHqUAQD+Npb+wfvyaGc=;
 b=3ETvYWRVBg3SS6Ns4l46waU/30i7hZYQejMIByeQdEEsx7pIj9/QaEn/M0yGplGglHfG
 orX5ItVXqOL/15U6K/NcP1OzBfKULUZ8L7ZkMtEkwdWDVvbzjVjJyCNXvgqrksB4+7yW
 DyJsEMy4VuB23H3Nk0wF+LMpE9aIdXfhRcAQ13Akh3/uaERQ/9PebIYxYKRzBOO57jx1
 5Z2ZLlM1AHIHrtg5AvpjG3ARVxxfmIessIlf6TcZQRotgT0eU3w7OA1FEnDhcvQ0kpog
 ++8nGxxH0ZZ2HA10/ZUknKscv7AiKG0wqRdS5ZXaDtvHb/dUj+R/eWz4NiJcXmZnlLQ5 Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcmw1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Oct 2023 22:39:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 396K0oVC005872;
        Fri, 6 Oct 2023 22:39:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4ba9wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Oct 2023 22:39:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVkOMYsHsRg5BQichqi+EKgKwTnFUmzPMF4EV4kCK4BcowpoJhV8KNsynHa2qbCtXNCrtWHJZc6jFSHKLRB48nPtOYsCx+6k8T2dz/ZnWFCiGS1KhvEFAqicMRFIxRWfnnCMwGSUNQnEbIZYAtHBiHHksv3aYC96JwWHn+VlrveQZxDRoVLe3AxYIwilgWtf6FMPWIm7VFlhmcLKQfVXndN7dDXzmM6Z7+eZA5LOQtrDzNDOEWKAdmRrr+vE0/won2pznzPpWGE+1iFx5/Bgh7NncQXrAiv8G3k3uMhb4yMBTZVBKoVeqfXVR3Bxih3UPPRRVD0ItX7Bf/bGsUxwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2INWIUSx1ETHu4Xw1BAy+C6exHqUAQD+Npb+wfvyaGc=;
 b=VNxvSm8r0zg3VAvh3co13fLefb/e4e2oldJi+K+wgW0gGNXFTCvuqCCl6B6f1MMEEEEYM+n4/tYZxu+kszHpd4j+HsG9G4GPlo1w2NI5T/Sd3x3HDEDt2H49yGnJNICzDnXPqFqPbZZn5YKq8g1LsTWKmRYReUClyHKUFPLwrmKNbZ/ZPyuHVMNGc/hRXNYAIPsZcQ0K2S2GBapA5XpsuwXnb0bP0VnofqdvVJqRed38T0x59pxXxqqfK3zccSGe7ATwC2v1orKN0FPLgL8qdDVcd5xW2TVaHmuFUJBoNClbVhgSSdY+kR6BXSCbLOO7JBAYiUAF2Xzma9601Z+kFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2INWIUSx1ETHu4Xw1BAy+C6exHqUAQD+Npb+wfvyaGc=;
 b=ik33++eLiBNzSPOM6JBTmu5YhPAKlSuWcqgIgObYDtMR8Wn4X7ipDx3+yxcHPV/3dikjyZmYDzp4k9Pv0dPs93aRwUvQHZ2r7509hk8a72q08JqfoYmVNWU2bh5MSfld4r5RGP6F0/vPcezyePpt2zO+Sw+4UTzlTRT6Kbr+Hus=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MW4PR10MB6462.namprd10.prod.outlook.com (2603:10b6:303:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Fri, 6 Oct
 2023 22:39:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Fri, 6 Oct 2023
 22:39:03 +0000
Message-ID: <b972544d-cb62-4554-8795-e27d98abb63b@oracle.com>
Date:   Fri, 6 Oct 2023 17:39:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
To:     Damien Le Moal <dlemoal@kernel.org>, mwilck@suse.com,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20231004210013.5601-1-michael.christie@oracle.com>
 <20231004210013.5601-9-michael.christie@oracle.com>
 <3e87f523-5e5e-dd67-26f3-8187b44b23b0@kernel.org>
 <c630ca48-7747-40a2-8c12-d1b212f07c07@oracle.com>
 <83ac5491-f73d-c446-e3e2-68641ce6347c@kernel.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <83ac5491-f73d-c446-e3e2-68641ce6347c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:5:174::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MW4PR10MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: b167352a-bf54-40c6-5385-08dbc6bd0a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XYokJO7m7PxLHLEYMGF2my+xtXx+uRthy177xRlbIpEH5wS0N1QkB5PaFRYqIjs91PgdRjEsDilAt3nycaqYUAX7E4pwv6eZqTO1C2/ii967/vvCwTyqOi08c6bqN6VhCIDu+5iOfUZxWAqEvYcZSbm+vFSMfA3cGJjokxNSG8Ydj2bDrd7PLtcvYw2IKJ68Udjzt9a7av0kbgojZL1SEyiWsgWBM2/d56+RnFygaeXkVuiv0nRvq5FB9M4Q17nD68ZcxWV+704pegI9I57lDM3EZ6eNTNN7uVCuqDThbvEaWvpQWZqd+5Hbask6TSwMgv5n8mNE70wJKJwz+qjXcdzyvhHLaXsSHOxVStdM6t/Rlg+2Tk/p8lTpoOvDtqNE4VOLYmUtdV3aVBwIJ9I/Iy3yOTn0PuKhMC1622kFjAvY1HwmoKbKaV453WAa8f7/ufVY3lUcWwegdIFqQ01fRD59oyJfURRLDfZqdZtxaNbA4UZAka+phTYzixiR8Usq/ToY70WcyWoT1JqfUUpd3WiwKRlEAb2GUb1U6w+Q2w2F1TxyJ8VeFTSNjDNvWPgSSSNG4s1E+oEV1NcCu4Y8l5wksySDCq4kGJQFsZriMibgM7lnc06EHcGFWmBAh1q2DhsQVfwnQVOuR06170CBDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(39860400002)(346002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(31686004)(6512007)(478600001)(66946007)(66476007)(66556008)(316002)(6506007)(38100700002)(53546011)(6486002)(2616005)(5660300002)(26005)(41300700001)(8676002)(8936002)(36756003)(31696002)(86362001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0pUY1ByR0pqY0p1K3ZpbjFsQm9wQzVGZUFFczE1TTFLdG9lZmlVQXNnQWNO?=
 =?utf-8?B?SDRadWZtK25nZnlVVktSbWw4Ym94MjR6TGxoeFNUbTBmTFBXUU42bmRQZFFl?=
 =?utf-8?B?emp5NHh2aUc3dWN0VHdCS3RIS2JxTDlmQWJMT21UcVBRR2pGdDE2MXBFNXo5?=
 =?utf-8?B?RzB3Q0gyc0NTS3V5d3F4TzlwNFlpYkJ1MHhQbXRwUDdlTXFpM0E4bkZ4MXp3?=
 =?utf-8?B?NlBsVmovYlVkVmUvR3FEZGtsU2o0NXVnTVBMbC9GV1V2TmJEOUdPOXA5Yjln?=
 =?utf-8?B?NDJ4ZEdZOU5TYTNOa205UXR1MHlPbGNFeFkvek9jVVpoZlVldXN3TmtQcUlI?=
 =?utf-8?B?WWIxOU1wTWFaMnRoUXZ5QXJlVlZPVFdBY0VPZTJyRzBOc0VaSFkzNDJyWlZn?=
 =?utf-8?B?N1hYYUlaTmh0eFJ1K3JLT0t1TGJVZUtubzVsSndNcStERFdyZTltclNFMUU1?=
 =?utf-8?B?bXFCdVNlaCsyMXQ0Q09ZL3FpZllHQ1NlRC9MeTZMV1F3VWtRVmFRRFk1cWJM?=
 =?utf-8?B?em44eFNsc2JneVYycjNBcjFLOWVwRVpaLzBNZDdiT0xJR0EySWV1b0dBcEtz?=
 =?utf-8?B?K3dRaXBKWUpaZ1hVWmcvRGZoaTV2S1dreDdaSmNIcHE1dTdZT1FSLzBySk1k?=
 =?utf-8?B?Q1NkTGZiZFk2RHNQSzVYMC9zVGdWSTFoeVRzelB1YWFoQTdoTlJFKzlXVGhi?=
 =?utf-8?B?TWxZTWZva1F5Uk45amF1MWxKUGRxemdvV3VPQXUyYnlpTmRGa3FueHMvVWhy?=
 =?utf-8?B?bHF0emFTbDhUS0hhQ1JIK0twYUFCVkN6UFhoa2t3SjBBMExkOGhmckxsOHBy?=
 =?utf-8?B?UjlvTXM4Q3gxZlRhNldwTlhZWHFSTUpJS0ZMeG9XR09WcnQyODFldnhzQkRx?=
 =?utf-8?B?Y1p3d1AzMGIyRFE5NnFqTmFhLzBBbEtldzVWUGV1Z0dpWE9heWM3SHRLRFox?=
 =?utf-8?B?SjhVMzdDQ2RIQkxoRmJkcnB5dUNyK3dKUEF5ZE4za2FZa2szK0dzWnluWmxn?=
 =?utf-8?B?V1dIc09BY3B1T2VFM0t1bDBrZEVYdy9VK09MT0ZlQ0hVU29pTzAvMGh6SzFm?=
 =?utf-8?B?R1dLMUFhWDIvS3JYUm16dUl5KzRnTmRsODJKL1pET3RtbzQxNTczUnR6UlBZ?=
 =?utf-8?B?cExta1UvOGp1cFB1bzRkZUlqSk53TjBvSkVYSDFRa2Y3WnV3NHdabWNhclp3?=
 =?utf-8?B?NlVMRHNnV1Fyc1RYT3VvbXhSZVJHd0JVSWpZZ016b1JQcloyM0N3NlVJT2V1?=
 =?utf-8?B?YU1PbnhzWjgxZDVBZDgzcHBjRXpnNk9QRGZhTElJcWdudmE0NDh4TThJc08v?=
 =?utf-8?B?YVVsdEZCcnJSV0pKS3hRTmltV2pOcisvTWMxN1QrQnNFbkNSeDBIQ1JISnhj?=
 =?utf-8?B?Vm1wdVpFejgvY0ZTNnJFOHI2Yk9Nb3A5WmFzQlh5SmJrd1FiaDdFSy9IUDFs?=
 =?utf-8?B?YkpRVHpJUjI4WTNEMTVoMzV5aFJmRzNJTEpaYktrSjZzVm05ZUhTcGtIbmdw?=
 =?utf-8?B?WE10NVdMQmxaL0lLNnU4TmJHN2dNQmxMVmgrdlJJSG1nZGJCZEk5ZFNhS3po?=
 =?utf-8?B?U1dWam1ML0pEU3lYNEVkTU5FZEhSalFtMWg4Y0FFOGkxUGo3eVVrSG5BYmZT?=
 =?utf-8?B?SlBOZGE5ekp2T1ZYK291ZDBTMkRqa3BnSHRaVDl0L0tLdGhWTy9SSTJlUVl5?=
 =?utf-8?B?cEh1RVZFbVhoeHMxOUxBc0VrbDVCMFBsSFQyQTNheEp5eDMzelRXWVBMS3pN?=
 =?utf-8?B?enFCb0ttUjVITDFwYllCMklCQkJUNkN2b29xcXRVRUpqSktQUlVaUVZ1QWY1?=
 =?utf-8?B?Y2N2OHNpY1FHSVVlWnBiU1dhKzZJemQxSjFwVXpZWnZOSXRWNFVNUDlSbVc2?=
 =?utf-8?B?Sk9FMzU1ZnJoRVZRd3huMXk4Q0QzSFVMdFU1d0RUd2xjb25wdGZWQ2RBZTVW?=
 =?utf-8?B?eHJKZm5pMEMyeVNYU2tYZ1FZdTVMRzNqbGFhelVpQkFWeWUxeGY5MzFHcis3?=
 =?utf-8?B?UnlTL1RpeTkrZm9HazJpQXRtS0tyaHdWaUV6QU1wY3FmREtmWkxjZTdIK3Yy?=
 =?utf-8?B?V2FDWUoya1VXbWdoWDJ6WDFiUisvbVBZd3Flb0NWb2t1KzNTM0JtaU5xSERC?=
 =?utf-8?B?YkdrcmxwYzZLYjNIT0dzY0dnalhCWGs4L0Frck1raGtyRDF5SjlmV3A1U2Vx?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xEe8N+xw1DLfM/75bQpw5p4fdzD6LCn+VnWUGwHrZ89NQq1m/1nbvwmDhuGop2uBAQ8JYTrbRzKRiHWXWj5uhUh2o1J/8LoI4nZpb8J8ONBc6VXiJo1J98RoFyJ3dCp/t2Vb7xxg8c33XJIAueG5qVF4fUGEgYs2VXIHUfjI0MeD1pM5LT1K2d5rFg6cA2ICdgb0EkDLma7c284yaIMWZbXDq8dmwAkRDKWZ4mHS1lUAEZi2ljGXF8MZAGvAb+RDmDHOyo7tujMaL0wgn+PRJBW6QaAwdAH3zmTXXdRxhsStZpkiaL/VV0gIvkYbquY9N546N9hked44AxE6ac0O5whbr5yDH+7xZ5Dc+pQkT9F7yitwUb3yJm6ec/dVaKz6Eq7XwVwNF56MSIS/AUpl8hp+B402J/X4s0KURE+fXYb4Flz4r4bKBx8NkuaU8Qt6SxN/ho5klBNUUl+9NeEluYayNk8jNdcWcWVe27FaP16oaAPouZse+FOIweetsKoC4oUpofOF5fqjHWigDqTvykwL/+mWkfAGB7u9iAHkCpjIpMdANVD7p4h6hG/PS9FN+sKq71LMBSKNHtB4T0nS7BzXbJU+BqPeUlIaNFFNp1YIwmUsW6+Twk0svhvMA7nGV0aQ5BGfq+4uNhvDDpniOCT0vcIaAiAQrxZZ2YhEThiD9aUWv1WMJj3aTw4jNUZ55jWEA6RUynWcMQXRw1kUQEXJSrsRXbPeU8Rk2qlxK/0rzhi94Yv6dbYjFLsUmrGtblyDY3lk99gtvz5I65lx5Tiuvvrv+ssl/lOrxJQMQaBb68YOeQ9FfuRI3OAFexY8sWqtjFyRny4cfxXseWGzAsqTQgBemJNcFB0QiZuK3PmlBgdnV6yBzfJMMamLaJSX92R8nnvnetL3pmzuro+/NAzLVb4PzW+OBwmJHhpxcrM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b167352a-bf54-40c6-5385-08dbc6bd0a77
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 22:39:03.1379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHEvJOfxgtoZ7RUOd2rPaDuTCmrnGLhHFl5C4cTS7GarG3kAG0uNEBTE84rmLk67Ejj17sUFxWFZpsEhc1e/YThqK2v2mCVhPGCH02TJU18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6462
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-06_15,2023-10-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=692 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310060175
X-Proofpoint-GUID: VZ3VGw2EzUsSnKtAMlu74RaYk7b7t6jN
X-Proofpoint-ORIG-GUID: VZ3VGw2EzUsSnKtAMlu74RaYk7b7t6jN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/23 8:12 PM, Damien Le Moal wrote:
>> As far as future safety goes, this patch is not great. Right now
>> we assume scsi_execute_cmd and the functions it calls does not
>> return -EIO. To make it safer we could change scsi_mode_sense to
>> return 1 for the case there is sense or add another arg which
>> gets set when there is sense.
> Indeed, that would be better because scsi does not prevent a device from
> returning sense data for successfull commands as well (see device statistics or
> CDL as examples). So that would be a better solution than relying on -EIO for
> sense data validi

For the sd_read_app_tag_own case and similar ones are you wanting to
log the sense for cases like the CDL where scsi_execute_cmd returns 0?

The thing is that this patches uses -EIO to indicate if the sshdr is
setup (not exactly that sense is valid). If it is then we check if the sense
is valid and if is then sd_read_app_tag_own will log it.

In other places we do something similar and check if
scsi_execute_cmd returns > 0. If it does then we know the sshdr is setup
and will do something with it like print it. Those cases will not work
for your CDL example because scsi_execute_cmd returns 0.
