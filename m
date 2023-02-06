Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3FFC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Feb 2023 09:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBFJvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 04:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBFJu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 04:50:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1B21CF72
        for <linux-scsi@vger.kernel.org>; Mon,  6 Feb 2023 01:50:56 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3167ptgs015079;
        Mon, 6 Feb 2023 09:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=e+od2eK3LdSJIpb1NSUaj1FovSXkMft/xgr7blui9co=;
 b=AKdAFP34TnDp4H9pbZUEQUCCLZZBpeuN8U9BdXD5SAtc1aCZDlZFHp2WP86xOnOQGcaR
 G91ICZBsjxoI/13iA9XUPRAuJpnugZreO2WEY4E2h8/EXRU9EPilphrVYpg+O5lXJi4l
 Va4/miH0WKpxaqbqKcHdzWLv952OwmtoP8ZEKf450FZpaOytoalTirm1zMGQmh4yUDZm
 PHtRBczIz3WDSQjRy0/3m5dY+9oIsHEJxVEOkd2CMoJr01qogyeiS/dX2YzqZmbsC9Cv
 hyiUw5itY8wDXrKrR4KSeJgitDbQ6RXH85pi3GC8gE/F6P8JgMncOlZ2+EcA1A3TsevF /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy12g54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Feb 2023 09:50:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3168549q011642;
        Mon, 6 Feb 2023 09:50:41 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt4avbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Feb 2023 09:50:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YibPioCZcexkA2Gnq19PAf75HPA1ntWfVrdkaLIfGwzZbodGxE4cmSLzbGskiYJK5ApdNi6PIrEGeuCNs2f6k/6zl2/qzD7UvAbxsgaX+ApMacXF6FhFpEwBlG4AqtCS5peXuyT5+NEIblXuGhnyM4da4TCIVKdshYoEeQvkMwzZ3i+H9zywQZmrsibctCglRIEaez+jjUeL7GUaN8EHlGuIWx57+gFySS4woiudljNRtq3KhWlPwx+qB5PqaIYD3YlNwMj8QDJszGpbh9l2bD9ZPZqnrWYdH67gTMso+jncdLTZcrFoHP6YvBOMklVKIu+Lria8FAkTnkM0JuebxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+od2eK3LdSJIpb1NSUaj1FovSXkMft/xgr7blui9co=;
 b=FUytKYQC9sY64SkQMOfv2xr3zkGRU1my9oui9X2T5BXA48zj1MUl8T48XjjdBUrj9Afi7iC5LhhnTkoKtsFhptEP3hod8h9k/LpP3y5V/IYT13ZaQ73yEdnf3yFL8JWuOzDoBOMzzN+brNrtHr3uTzQ2q3UQqJR4Qy/FiXQSfPOXdkwOiEEJ5bGBT5uu0CqXTLNKrXQzusdh7hVOnka7H8dwQtNmNTSJK4WBFw2nt8J+64n/TiXTmkbyTFnhPjkE2tbfJxe2UBz3n7Z8f1w1JKTGG1ao8gs1sDNn3oLL1l29hwP0J5/VZrtsXRNT47uma/4VyO15CsWKndxcA20tig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+od2eK3LdSJIpb1NSUaj1FovSXkMft/xgr7blui9co=;
 b=VOkUcxELah4uZPGaowXLLY/L/OPCbicDywyLUHOkL9chtq4TRpFHeE4fuR4/lR+flagvQeG/K3D/K58aRm88I+EUhWNUsl2aAQnhfoJZIS1rYJDGokVEluhWrdXRk58MQOAHp+R7URpif2AnDEjVJUuGousZDsU4hFvCKn/iD5M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6201.namprd10.prod.outlook.com (2603:10b6:510:1f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.10; Mon, 6 Feb
 2023 09:50:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%8]) with mapi id 15.20.6086.007; Mon, 6 Feb 2023
 09:50:39 +0000
Message-ID: <a81cb9bc-246b-1b82-fcc6-37bfb5829bab@oracle.com>
Date:   Mon, 6 Feb 2023 09:50:34 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] scsi: core: Extend struct scsi_exec_args
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230202220412.561487-1-bvanassche@acm.org>
 <20230202220412.561487-2-bvanassche@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230202220412.561487-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0429.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c276b1-1f8c-4ab4-9beb-08db08279a4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NcfSUfBvEDHvO7TDIQFP3igNs/t7/9EMSWlqbu2+VsDSkw+FRDL1GF06Tyd9b8oX9HL3fpIxtQsNxHnioeCFCIzYnvfSpcFeZRfHPClqxc6NeucRLv1bVnrr2xhya6S3MjGN61x4MJnCefnukc1nqLYmYugCjvNIIAkK6dqbHTbbd7g5BGNJypykfe8CoZnAJjJ9ql4EwZcfQREQMTteJL/3matDn/KkeMm+vDP5XAtLIuDK9HKyhXWr7Shgrjp7AmZeCPMCkvyfLyPwUo34vn/c0OitvsjqroS+o9uXUMcb7JI0ctYhwgQNnNtb11O3xGbNwv8R3VnMdN3bLul2TYzIUBqdCC7nU/ECBrWn637Ne8xy6E5QMc0gR+kn/ICMVAhnyUiV7ABqpXvpXGzk3YpXKvYT1HrckJuVMncPRBWcYj6hUn6mbCOgobP1zPXT7aDX0JQCv2kx1EB9R81X7uFo0+P+EPs0/G08+dP0d30zGAHRjucEHWDfbzmlXT5K+H+A5nl2neRe9TbXZ11ZBOpK9nE+QQ3SgrY7YiWsdJu8KZAt9BvGiht7SswKnXOX6VYeQbrkg/t4R1i2taOe0CrFr+k4GGvG6uHSvSAKMNjK9T+f7rancMjJlfxBEhvKh/Uw4UlHRvw6N1NtrB5UUU7L09ajufYm9Q9GOi9u/BekE9Hw0+UQJs9WY6FfAzxfTDx6DqBc9sxgghlC+93JTI3BHXIHgNOuEUhI1gy7NwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(6636002)(38100700002)(36756003)(31696002)(86362001)(316002)(66476007)(8676002)(110136005)(2616005)(4326008)(66946007)(66556008)(6486002)(53546011)(478600001)(6506007)(6512007)(26005)(6666004)(31686004)(36916002)(186003)(2906002)(54906003)(8936002)(83380400001)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlJld1hDdWU4V1VmMm1tKzY3NWtIak05cmNYWUprMVV1T0tuMEt3dkZndERm?=
 =?utf-8?B?dS9OZ01DNTNzZW5ienNUeXlPQ243T0diVUFlZFVmQUxCTXNkYWo3aTF0UmFZ?=
 =?utf-8?B?UEFobEVYYmdTdWF4MkdBWXFJN296WFFaeEsvRUVHVHEzNkdHSk9mbjBvZDRQ?=
 =?utf-8?B?ZHZnVjFGMjdkbUVLbG9ZVE9mY2JNMnY5OWplbDRhV0hvazNhSDdKL0tLVTVp?=
 =?utf-8?B?eEtHU2FnZWorRDZuVFhHVkxRaE1sUmhEVTBOand3WldGd2dXaDVWMTRMZkR4?=
 =?utf-8?B?M0xFcGcrL1hVelpUNGFyaDlHbHZzdHlFUk1MOUk2ZnVqUnEzTWRqRkwvRjRB?=
 =?utf-8?B?aDZiM1BwQSsyYmpYcFdJQTVUWjNVWUREeFBoWEdPNWVrMGwraHVad3dERTUy?=
 =?utf-8?B?Z0oreHNWUnVMSnY5VjNWeVIzUjQzbHdSSThMK0ZueEYvdkMwL3UrOVF3M3Zq?=
 =?utf-8?B?eHlUejYvcVNzMTM5MlNmU2NsWitVTFltY1Fza3h4STA3TkFKeTI4U2E3VDR4?=
 =?utf-8?B?K3lDSlJVSFM0THZCbGpqbzROWjF6ODRZdTNMVHRrNWRUUTFnSWxKMkh5WEdX?=
 =?utf-8?B?NVFTR21oWVMveDRKS1FtVEMvWnc4cHdTekplK1FHUFZ4TVFEeXJydGsvaDJk?=
 =?utf-8?B?dmg0aFE0ei9BUzQxYVFWbjEzbnpLcENEeDEveEUyWWtIWkoxczlNZDBqQXlX?=
 =?utf-8?B?dFVVRlNFN1ZpRzM0SHdrQ2p3TnJQZEJZdnJtcnExYnNqaG0yYmJTR1k5RGM0?=
 =?utf-8?B?dk41SDZES1dGc3VscFhNZmRLSFlTVTVXM2RzUkNNdE9EZkJFYW0xa0F5YXN2?=
 =?utf-8?B?OGxtRk1MaFliUjJFUWFQcXl2cG5WTHQzTWZ4ZXlkZEYvbUtCdjVyUlZWdGJG?=
 =?utf-8?B?S2ZMRmNTd1JNaXhqU2w0M1F3K0EwcFNXdTZ3RStxVDUySEdyZHFSUFlGa2lh?=
 =?utf-8?B?L2FERWhQWWdJN0RnNDkyYWRJZFFlNVMxNlZPS0dCM1l0Tkk5Uk9vSUlCT3hU?=
 =?utf-8?B?V1pjZjJwZXloRGF0S0krUEg4K01WMzkxRWVDSHJHZjRJQUxoV1FrYkV3NmV1?=
 =?utf-8?B?SWNxSXA0ZERHY093NlNFdE1PTlRBSExWdDJ0M3BWbTR4ZVlYUzVBMzB2TW5S?=
 =?utf-8?B?ZU52OE9WMW5jU0V2Nm5kNnNNb3JDbk9MNitGYThrakhqTS9CZE9WUENzY2VV?=
 =?utf-8?B?MDhld1NTRHVENGhOU1R0cURVblVvdnk0enJ0bVJBVUMvYUdxa2hDM3E1Y0Rh?=
 =?utf-8?B?bnk4cEM3SEJzeUhQY2NqMVJqQmhlRUFBNit0K29xYXl2RVNiU1VJblVTdlkw?=
 =?utf-8?B?dHRVMWEzUEFyUmM1TElPVE8yOEJ0TmRmaW1QUklGeGt6THpXOFA5UWZRSlQz?=
 =?utf-8?B?YkZYSHlyaFpIbmoxdWJzOFhUREdhSmR0TGpJYk1OWFU5UjQxU1R0YlRscGlC?=
 =?utf-8?B?eGdrVG9FVmVSKzc4dnFvVElDTTU0S0hxdXFESk9ocWcyMlNlbzIydEROdEk5?=
 =?utf-8?B?cFdIQUtmREZpanY3VEtmQXF1REI3NEJjbms0ZGJHRFpObERKNTl3YldLVk1s?=
 =?utf-8?B?M0ZJQVg2RkRONXJTSkNiVVRPQm9acEhTdFZvb2twWi83K1RiNDVuMUlZV0w5?=
 =?utf-8?B?NjNxSGdnYkJXb1lseVkyTEd1REVrOG9wNzk4ejIrSW5Ra3l1QlZibW1aNmVo?=
 =?utf-8?B?VHlMQkpZcXRHcjVsbjUzVmV6c0NXbHh0aTFBMG13RVJjWEtpVUZuTHpQSHJG?=
 =?utf-8?B?ZEpMbmtRK0NwNHpSVW9CTUVKcklJcTlyR0JlZ1pMSCtxZVUrdlZWck5iVEdT?=
 =?utf-8?B?M3Fub0c2NDdDWjhRM094TkZJaWtJTkFWM0xVN0xLcElYaWFORFBHSW9vZFRN?=
 =?utf-8?B?WEw5eEZFU3I1c0tDYWJpRVNxd2w5MHdNRUJoeFFYZllScVNURkhtSXo0WWds?=
 =?utf-8?B?MStDMlQvaU8vUUE4dUMwMGUxcWV1aGl4NGd6am42ZUgxcnY1RFVkTUFJMTM3?=
 =?utf-8?B?UmpTODdrU1ovZFEydGRlQjdsWGpOdWd6M29jTUE5ZkFod202TEZEa042djhJ?=
 =?utf-8?B?UHN1NS95cFFPTWhGTXRVTHo5dmhkZDFwbTEwek13LzVvcXBWVHlEa3JiaXVk?=
 =?utf-8?B?UW8zNW9rcndHZDBwL2tudXB1S1NvUjBDTytoK3hFSHZEMTVkU1RoZyt4TkNa?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KkFzGXrGV2u/LJFmrtgWSM/nIE6Bv1FB9BaJ54dwdKH5xF6UfPSdHZM4lVCizbDU1Zfu1a3Snoorvbrp6gFz77zuir8T3tYwMIT9YCWn4BAoexvSqO3J7fR/xc4/pb1+tjksjlQ2bvAwnfQkajIv78P5bonsfu9K/A0K0XlSm2jIT9B6It9WNVA77KXOCe/jIb89paVDIcJuIm3hLrplAUr+lA52D3FXQLpx6NCTUn7g14S74wQ0A59wjBFdwucvFEQ8GDc118CsG7cCKdt6FYncyOXOy6rLXlUSr4gnTIMMYV/ZVo1IXUSAnLOKmqC44kWleHXA5NkeqwOWXkU8BIZBeyRPv18UWEc4TOQ9MznBar5HFJ+73eceaxCeeBnw//vg9alMU58MuE3q2cG+NCRlZPS4wWTnPH+8xvjjC+gLWE2Bx/Lp6penhhsQTJsZA581OF2TaMkNuAe5xnlnMlIN0IrSNnK5DCmXh8yWX4GKiuyE3iBpAe/5jc3CkAQsx3NqtbsZIQKK5JGZVWikPYQAIfIHd0fuoLUrVaVDzRM69CLES5uM4YVUtalTJxUlxWzpWH4tnYZgImtOrQgVAf4vQbIXa8dXA7FaASKgxrwIzjyVKbAlcnVyr+VtS1vnlJkjEpkYj0jKXL1eU/NEELMmssK+v1vME95vAA55cqdAyZIZCOALND4QguiF1m974AG6iNhwncOzhlTzzMj3QAVsFwQzEohrk5S/pl7YmdescC4mPjni8TqY1G6I4CmKX7l7mxTO4j09I9JuGf2nXEQIh3bCByHqF692Y8H5g57p3O38MUmF5d1wgvZN8HrI1A2vpxmjW2Spg7bXXSC4DBek44CcisJg3BN37D+xnMblRoX5gRhxG4FuoHp9gXAzjRNwgk7xDTi3c+owQRx1UQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c276b1-1f8c-4ab4-9beb-08db08279a4c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 09:50:39.1015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HIISRrbh23KIJqhlF9DzAZhTr9kR2Q7qdPWnkAfrgYAPKjOyFE3qpxYl2iHSjNAdVGMKcJvI1UsK2jWAOba2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_05,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060085
X-Proofpoint-GUID: 9DcPy1eUXmkEBNW0erkhWoPtr8g2eluE
X-Proofpoint-ORIG-GUID: 9DcPy1eUXmkEBNW0erkhWoPtr8g2eluE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/02/2023 22:04, Bart Van Assche wrote:
> Allow SCSI LLDs to specify RQF_* and SCMD_* flags.

As I see, if BLK_MQ_REQ_PM is set for scsi_exec_args.req_flags, then 
RQF_PM gets set automatically in blk_mq_rq_ctx_init() for 
request.rq_flags. Christoph previously mentioned that we are required to 
set both (BLK_MQ_REQ_PM and RQF_PM). So where does it matter that we 
need to set RQF_PM (that setting BLK_MQ_REQ_PM doesn't cover)?

It would be nice to mention the reason in the commit description.

Thanks,
John

> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c    | 3 ++-
>   include/scsi/scsi_device.h | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index abe93ec8b7d0..5feb8be6d956 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -229,8 +229,9 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
>   	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>   	scmd->allowed = retries;
> +	scmd->flags |= args->scmd_flags;
>   	req->timeout = timeout;
> -	req->rq_flags |= RQF_QUIET;
> +	req->rq_flags |= args->rq_flags | RQF_QUIET;
>   
>   	/*
>   	 * head injection *required* here otherwise quiesce won't work
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 7e95ec45138f..79260e98774f 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -462,6 +462,8 @@ struct scsi_exec_args {
>   	unsigned int sense_len;		/* sense buffer len */
>   	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
>   	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
> +	req_flags_t rq_flags;		/* RQF flags */
> +	unsigned int scmd_flags;	/* SCMD flags */
>   	int *resid;			/* residual length */
>   };
>   

