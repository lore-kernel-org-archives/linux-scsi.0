Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C799C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 10:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjCJKeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCJKcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 05:32:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C9B1111DD
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 02:32:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32A2nSpx000499;
        Fri, 10 Mar 2023 09:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0LW+jHmmEPkhHG+ekOgq0Jw9JxqbOskJ92r1YxreR1c=;
 b=0vp6URy6+58LLySo5S9x2d9PAUjoqKUbt8MkFsSiY8Z0458TafO3haWTZdUjT7E0jCQn
 BGyxGZKv/nMjK12wMAzhAN8+iLMLBrOeeQzcw4ePv2SxACj/kQ5XIE0j/X45DuWw+Aax
 +vS64kEsFrky/WQPPdgJY0v9EMyaehUMNoe339/JKvufce454QlJe/S7d9zEImlqc/g1
 KEo3pT+2gWj3Yxeaklb3k8U7hL/J+NYX8MmEvM3HweTdSuU0FtLw1ZRgWmPN0CmeB8ut
 +5LW6pqdf9pbSzw8Af/nlJuPfIdsWMEaDd9EIllzkEDP2xstsoQjeF5qhc886fY/kkeN wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p7v3w0ey8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:17:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A8t8hS020778;
        Fri, 10 Mar 2023 09:17:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fuap1qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:17:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWa7/RtQgKmAZw5QWSxMiPdxBdsNo6tcpxVqAFPF8Fu14HnInkSBXIc1GFctie6p6LY5OE9Jrl+fVYEytveeTU9ZDvvEzMwLtajEPrfmcWk8gV7WQYK+sKiqA7ltrMRsqwGB/SWNa8oynHeAZUmcwg035VKHs+mZwqMAMNmdabty1Kct3Q/UCmnOlIvDwq/UVsEAHjH8ESTMvucX9P6OaTvS9Xu+Hje42bbAk2wP6gH7Su9fTSuGtYytRQZBa/7xweBLohpbAEL/9siTatveqmhy5pRor85zvxQOuuTGmcQfJdgGtm6w+3D7z9lee5wPR85S6iPrlEGAF99dPiOSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LW+jHmmEPkhHG+ekOgq0Jw9JxqbOskJ92r1YxreR1c=;
 b=Fhq3KHyny4jcojF73erkWDvk1H5WsWd0hCQ/1q7LT+3tUd74EmrljW1Gfhboem2JyTPFxLeSNIpS3X63YAxGI99RDoo+zZHI1ZM/Kjb/ZfiBRXsvaF6j4WIyIaYlCu+KLGQZjV+9mcs72soewsdsRjzzJlCb5QQW3XwCxinEB3QENmuj0OjX9aGGXNqV0snMQxHkx+mM191nOgrmP/1L64/PCcPJWFe425u6XKqsXKf6vHU27QFCs0jiEzNI6Xk/vknEd2EAE0NZ3fSKhV3QhrQkE0zMre46Rkz3Sglg+BdSVc8fMBoWfmjn14JHdQuhy6npZ+ofA2HtvRaqhd7lrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LW+jHmmEPkhHG+ekOgq0Jw9JxqbOskJ92r1YxreR1c=;
 b=altU/6GDM1hI6gG3L+Tan6A5ZsGEOd34R4A/7cyHFUExQdBPyLo64PESpLCvYyTsO4T/Zikbhq+oSMwe31Zw7YUH/i7NzlUlkzXVd5AQwYnFHbvJrlLR+ezzRKEOUW7C+xgFGg6zmcPj69E6OcHW7xfqjvykKkM74zuDUl7oT8o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5726.namprd10.prod.outlook.com (2603:10b6:303:18c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:17:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%4]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 09:17:29 +0000
Message-ID: <96a3a626-d8d1-98c4-57b8-8ad669372739@oracle.com>
Date:   Fri, 10 Mar 2023 09:17:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 57/82] scsi: mvsas: Declare SCSI host template const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alexey Galakhov <agalakhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-58-bvanassche@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230309192614.2240602-58-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: e2402978-2d6e-4105-1b11-08db2148456b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gy4ejyOvh0V2iZsZYCOBTFHPnntfZQSwDRfUh6sik7sQ0DVknwWIjyjrdB++0WZtqXh4e7P+K/YzhuEYclgF5lZV2zO9fBEGFhqb3Nkv4XDbVdkL45fA7y3Y0U4i+SbrZ7zpICbBOwaP66LqpiWMY/BFRmzIIs6ZH9mbIEYvaYjQUkLfgXYvxFliZnPdvgy7NmqW4Sg7UIJcHVte8Nu8k9B22EOKUNLlXutoaHWz8NKqa9dwvyNuz4/cfNClwYrKbaSvVPTLjc69Vc6n5DepTAQf4Fh9W30AhrIeB8fRXl2EbJx3QHH+e5ld9DQrod797plP9t3lxn5lUXMnSChRT2ZSpy+s86CEYcxG7MsaNxYnZL0tKnpI04Q88ZotlvMfcO5rKE3vZXlLkT/wWJjTjV/+mwpGx8DlYXVyWzPzggawmuwBGMomQwI88msI0mR/IYBiyW1r2bf91TxU1X/OIu14DirsVObEm6lKTsTD8JyTYwL6ZMFjFrUPIR0Zz+XgYKqBhGcm/WrL3L9lQLZsb0y9vzWtzgOjPD4FzOdEkqhft/w1CmYb9JxfmW3XNJrSE9/AltMSqxbe/e5GLsS+rg+x/LKTEaWM2HrKOK77eCKGmuaosX13P0QgZmYiIYqKi9FlAmQQqwjTlhJZ2Dva/mMOSTqWwZXwZuTmULSpSlYZim9CAXi0eXkUcyUlCp3FtZDrcKXGhSs9LyOTSFXvLwNYkMjW6sWSjE9dtOb3ngU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(31686004)(110136005)(54906003)(6636002)(38100700002)(36756003)(558084003)(316002)(6506007)(86362001)(31696002)(186003)(478600001)(6666004)(6512007)(53546011)(26005)(2616005)(8936002)(36916002)(6486002)(5660300002)(41300700001)(2906002)(8676002)(66556008)(66476007)(4326008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk9mdHJWWjN6akYwY1piWHRRc1h5a0w2eWpoUldmQzZ0TUlZOVdBUjFxWEpP?=
 =?utf-8?B?U051K2Z6cWZzY2ZoT2QyaGt3eUxQckp6RU5JTlllUFJEQkUyQUhlWGgzd2hu?=
 =?utf-8?B?Uk9jTGdqTktSYTlQV3VHSDdidzR2Z290bUdZcjh2UkdFKzNCZEdZdUVWc2pn?=
 =?utf-8?B?Ukp6aDAzRTh6M3dtK0s1QVFxb0Z3cU9jRnkzVzZTU0lVL2JZQzBpNHI3ODBq?=
 =?utf-8?B?anVTVEN6ZG5wSHdUdG5JZDFIZDlHL2xQUkE1Q21JeDlPVVNlbDZOWnJ1TjI2?=
 =?utf-8?B?NWU0enR0WmRBV25VeTg2Vk1uazFVeWlvbkVueGhleFZEL21nUUdiSGFrU1dK?=
 =?utf-8?B?VUxac2JaQ2pFckFQellVNjNieTQ0b2tjMFVzNHl1VXdVMXBhVDRqVk9tMXJ5?=
 =?utf-8?B?VHI5LzFUTmhrb1dGdmlaVHRGTmZ3S1kzRWo4K25BdDluOTBGaTJ5RFlwYTE1?=
 =?utf-8?B?Z2xYanV2MHo3aWM1dyt5OENpUjhCcy9rUkpQcHFVcUlMQmM5ZG81cnVCcldQ?=
 =?utf-8?B?QmNaa1lpeEJEak9CMkE2Rzl2dENqOE01c0RMMnRoU2xXSUF2WWhsUG5PQVg1?=
 =?utf-8?B?d3JWSVVIMkJTZlMrSXhtdmd3Y2wxNWlENFZXekx3aVR0NTdxZ0JPRW9CYURJ?=
 =?utf-8?B?N0sxODRidk9URjVWdXpHOWZZRUdrN1MwS09ZZTFnVjhXWGFvSEJwRFJMVHpM?=
 =?utf-8?B?a0xjY0Q4c2FLZnNBQUhaRS8yTmtQL1NJelY3NVZYb2huY0N3VHBPanVzQkcw?=
 =?utf-8?B?eW1tUEZyZXZhdmdsNzlTK0JHNWRZZnM1Z2JtVStsYmtubHFESzhVYytiVDVx?=
 =?utf-8?B?ZXAxdEFjaE8zNHRpWUNQWktJS2pQQTZEU1dlcWtFVkV4Y2YrMng2b1JacjN2?=
 =?utf-8?B?bUdpTWF4blFPODcwamt3NEJsVklXWDZtT1FaMVhrRUNLQ1MzMXNsNXIyeGpm?=
 =?utf-8?B?ai8xOHBjT3pyZUNzazgwVUU4SXdXdVpGekp3YjBlKzFoOVUrbU9TNG5kcVR3?=
 =?utf-8?B?RmxvK0NRYWlCWTJHTE1KeXNITjZYL01qL0NrTm12Nm9hMmJRVGQ5MWZ0QUtH?=
 =?utf-8?B?TE00TTFCR2xrcHBMU05vbkJkeHZKRTBYRDhDeGs1MkJEajFQWVBUK0NvbUx1?=
 =?utf-8?B?UU1zbGdXa0N2SUNaQ28rT0R2VTRleUZZQ3phVW5zMmpUV0VGRkkyUzZvTFoz?=
 =?utf-8?B?cjlFb25VbjNqdkRWOHJqQ1RDWTNsOU1OVDY0ZVZSY2kzdHh3QjJQMFBpcXd2?=
 =?utf-8?B?MVN4czBOZENLQmpDcmc0WEVvZXJMdi9peHloMUMwUllRa0lyWjFUbm1RTkxw?=
 =?utf-8?B?eXRHY1h5aU5ZQlB6TkhLQStvaFFvNjRpRmp2MkUwb0pZVmE3VEl0aU96bmN0?=
 =?utf-8?B?OTRiblUvTUFwcVV4ejBnQVlaYmhwZ1R3ZnpMeDFIeXJtYkZVRndheTdmNUhS?=
 =?utf-8?B?bXlXQTRyakJOY2ZuYnFBQnpVb2NHNEE4RlV0ZTB3UlEwMXU4azNJQU1tSU9I?=
 =?utf-8?B?RjExY3JwTlNqbGVZVnNuRVM0clR2OG1Nczh1eXNESW5ibnJNbkVJK240cmsx?=
 =?utf-8?B?QzZoWHducU5yM0ZIME0zOFJlR1cyOEdmMnEwbHRSbFVTbVZMRVJBa2E2OHlX?=
 =?utf-8?B?U1NCaGtNSDBVMlUzcG5YOStMU3pCMmQyd3NQb25RLzJYZ0J3VysxZmZDc2t4?=
 =?utf-8?B?QlJRNjdRZm1iRUN3QWxFeklMWTNTUXFWRm9yaDVmOU9OU2h2TWE1UjMyZHZW?=
 =?utf-8?B?eTcxa2tlZVdHV2dBKzlhNGF3cmtPVWpYelg2Qy8wU3hSc2xsU3JHSDJxWHd3?=
 =?utf-8?B?WVh1cGlVbGpzTmlQSXJnOFhrR3RyVGwzempQZXp6bWd5aUoxOFV6MGt6bE5K?=
 =?utf-8?B?RnZvSCt4LzF1bFQ1ZVk0UEJteks1SGR6ck52d1ZjenQ2KzN6YzVxWFBac1VQ?=
 =?utf-8?B?cG9VM2NPQWFTa2dZUHNpWlFyRXdrU1VRdmZodVMyZFlRdmpTLzVrRWJWR1p1?=
 =?utf-8?B?eDF0eEJXYSs5Z0VoYXRPcHlMcDVSV05ZNTJXZGUvMUEvZ25nZHc3a0dNQ3RC?=
 =?utf-8?B?eXlVQ2xlckgwQ1hFN0RQVVdMYVQ3NVFtMVZoVFpnbTUwR3daN3ZxN2d5emph?=
 =?utf-8?B?M0UxVjdnd1I1SG1NWkZuQThJa09heGRmeUhvYUpjZStaM0JPYitQQW5BdTho?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Qo0vd4/VpWFtWxowncAoIJvwlT42V2rpdPkMMRW7U10n7aWQ8nuGIzLSOL4RYVYFjcrFjGArSoAEKFHfDC8Q8dkBqdMfqBacDF/WgaiCApeag78jrCsVWksD6wwY71k6YEimvhNY/RAly156RjFY8Ojj6rh9Y6bpUHSfa1VuCB/XsO2TVqbdWeXOEeVaEeEpeD1UxKz4cQGqnASEIaoM7Usb9hAFOol+OZRS7Mn+q23J261LmXfXXbi6Zr8/KitwSSFjHfd4TdV/t61WAxQSSJ07q1u7aB8dgI1ddM8QBdM+jsCNk+fNt56kSfuMhl9f7qNS0OrB17UzaM1h2ozN2a7g1t7YTr6K/psuX9yLYerrOxAhdh9HNEC6jx/jrJM1uxrTkCGxrPG/BtIoLescID3FmswjNLt42y7uaD0mC0vil2g35FVWRypu6oCc+Kz1I1lH3JDBzVXYF+ayMNzINhIWh2o5PNVSd2HdOWe0to4BcS9mbWuR8J8gB+RRQWioa/YtlQ7lAyuDiWW0aIp+/pliEsZdk/IxOUjSEsObq50u076ZpIM3t5UQeOQjWwJjFIgHY2M2VY+wbzs8+P7QGEoNxaImH0Y56vK5Xkwi0UbmKxyghp5uvJWvKaGsHFeCq0/QOGq9Gav5ClJ1ncGJxIYjkw6Fav2LKvNWA/uf+U1vMiBrF3KHrKodqMoWTmmv00fpQ44ObLxiHFEhbkN+E9Xh4o1ABP2O1ciON57Kot1sLjbmDYDxRAJR1qJqjmErJNo3EEsoExuncrw3Vz0svbakNXla28hfEXweE4n9/HRg4m0NmEotAqdIcmEyhLRYpfobcZLTkyfUXCtPQmTHE6AAwrJanE/q91auKpwJpDzaajk0sHcV1wS4pYQLbTRA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2402978-2d6e-4105-1b11-08db2148456b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:17:29.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWbn8IvGVYr4s/TPEkYGyxryjMdchFneX3l1T7eamyGDHdXEiDDLbcPzWWOzmuV4VcGEjOJTRaHmumyFKXuuCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_03,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100069
X-Proofpoint-ORIG-GUID: ZdzjrB5UUlkUyq2InvEHCCqbvlEsEEHP
X-Proofpoint-GUID: ZdzjrB5UUlkUyq2InvEHCCqbvlEsEEHP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/03/2023 19:25, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
