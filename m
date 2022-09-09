Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0977ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 17:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiIIRZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 13:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIIRY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 13:24:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4201930F7E;
        Fri,  9 Sep 2022 10:24:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289G9k9t016419;
        Fri, 9 Sep 2022 17:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jxF0z6fHbBrKzObFZ4FIocHuUUrxeSIabHWzO87XQpE=;
 b=a+EyPq+zBGpDLoXSuRZNZtpyMes05+fClZ2UGBKp/1dreTMojrnSHsYky5pCWNnvR4Kx
 t4oedaz8kIVxVDOQEOoeD75NwU+FCvxGEHsWirivbLhVMBnlygFExVmBQQnODyyLxYkv
 1lt3QliusiYNiGPfQFxDyS+VgoPTAmOXvyFaUhdL9BZlNnwN9ptniSBql8jjTHWx/d5r
 uNFnyhLC4fj35ZuYCGNdEuTOSt5l71qICYTtXLAKfl1gmyL6XMOqNpUpuiTSSpSytumd
 7Njz4vwMbFi3dErEWPAkoYphpIyNud6wDVq292NWpu/zS0Ekeuj/orijqGugkz+isRzL OA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbyftywar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Sep 2022 17:24:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 289G6NjA008641;
        Fri, 9 Sep 2022 17:24:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc8eu45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Sep 2022 17:24:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/NR/R3PeV2L+vcQM7IeszUAmciWjcK6HdbcySbasbT9jPsJtOuLy6GUvYaWALuEG0H+3yxPp5kG41FRhjLV2l3P6yqiEKM8YJWHQl1b7ZoTFIjF0DEnYadAMPiyUzcqnfSHX8j/Uk8G++2nWZNySsTAOqEccrwtgUshnaAyKiQksFlIaD2LFddCTY5NV6fWe2U3nFC/w8K4VoTqKXWnrBH3tjJ1qBp4HjWSDC8CwJG++qVD9Sr2tRCbox5MhJZn185PnwDAoF+cQoEuGQaph7Qi7YqBYtVJ5YzHVu6VCz7jWZGNzBBzpDolQQv9JMZHVn9VUbZFg+F5bFODIU33bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxF0z6fHbBrKzObFZ4FIocHuUUrxeSIabHWzO87XQpE=;
 b=ddk9bVZcuwa3WwcZ+sUpPLB/Rfl+dhXI5/aEoC1AyK8IvTa05DjH3s4Ve6wFIwQBApKIEEn6QO1PHNCwOBzpriCUYLtfpsQ+4MpPF2zTeLRCyjekq+Ieehfz6rH2L6zKh2sH5VkxaDkUFxa7ZwZ3fMa46XlRjM/YrM6UbwhiCwHZSm5UwwTlAKIS/SDsDt0lhkrFQ0CLrDdvp3Cp7/i/JcNkWEZm5WS3gN9roKZZwt4gZICzSNXi+puUzPdoiiY7d8tT1WeAlyo90MZyevkZViyI6S/LVNIGvOGMcyIhR7iZ6ofaxJzYGAqLUJF+NK/2BuZjpi4DBoeDbb2PO+iSEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxF0z6fHbBrKzObFZ4FIocHuUUrxeSIabHWzO87XQpE=;
 b=qAqmoinweAUMRUSkr77k/8v3Kzunku6u8qTpk+up/1mHoSOdu4hVZuAufEe1Oj5sn81XrcjxDCB+mJNs8ScHbASZ3HSf1qy8tuzwUYW2IVHtssugI+50KP/qF9JB+HaYpFtGzmF2s3P+bXnw+0eDwzutTEPjXYqRyWNUWogCZdE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4780.namprd10.prod.outlook.com (2603:10b6:806:118::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Fri, 9 Sep 2022 17:24:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.021; Fri, 9 Sep 2022
 17:24:53 +0000
Message-ID: <b5dc6104-04e1-c3f0-b22d-ff9043cd9f36@oracle.com>
Date:   Fri, 9 Sep 2022 12:24:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] scsi: target: core: Add a way to hide a port group
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906074903.18755-1-d.bogdanov@yadro.com>
 <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
 <20220909112235.GD9218@yadro.com> <YxskUBeZeMPi5By2@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YxskUBeZeMPi5By2@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0330.namprd03.prod.outlook.com
 (2603:10b6:610:118::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: f4885155-53da-43b9-dea7-08da92883512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Og/wZb5DLM/t/jQzjMBhvtkuXhLjdK/tFvippAGeTRkcLHlzXJMRys8qp1uA7PaWou//p9RnOh7yQfmrwGrkQ7OYZdXMU4oJk+GdQde8skx7LtimFnbAxN0eGSY3lDS8chX3avahdfngARPzgOU00kwes3YBPkx1gzmy4QabJUOIeqp9f4WbrFwauSwKVpfHtDfo6rSYqddQVV6IvFUXsU97+wAipzkCoyqTZFijKSW8AoHn23y8fjE8njcU2CgpkWVgGhXbJp4cLAsNv53DF36IQzk+PfpPdOOeWYsiaZY0hFe1fN25yX2J35S83WuOVVWJIXq6voeWsBh2184gIbMMirq9MxaB8vlJ3plsFQOvHdlR7E7mMrXJcIUANY3N96Oorcxf8OuQEsu3XkxNy8nGQft0O6sGn18H7fbcPnmR7PdZr02wDtrc6EpTsZoYno5rQPzU3yPimqhXEWQGJ/qfcrnzckBjKHPG7Wa/iQVo53vKogF2fSGt6gpjeXFqUjGPUn1TF/Jw/lLEXiNII9bAxh3oBVftALExJB/HC43Pmc8l1ibPfmqHw3FLuRag5uMnOxGOfNYpDHcq3wKzWx2zf3yhr+NSju6LcRBzjbE32XKfHGQeRghmRPFH9nMbaGbJ8YWUWJqJkHCcLPnCsLldbK7V+YAs+2UPwVjQzDiTeCeLfvCQI84AnjmGDKzmK1mgxnNc2AMrDBXkdcVfisaU+oOd5FKNe8uieGBTVqkZ1LPtfjEdJ2kiVrccerA2vnB9jFJCXOjq2H/OrQK70Kzto5m/vrgDbmAonuqkhYtrk11UgN1fFQxX2AowFDZ4WA1R8pSNDNZBUi7iLPnjsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(366004)(396003)(136003)(316002)(6486002)(110136005)(54906003)(31696002)(86362001)(2616005)(186003)(478600001)(6506007)(38100700002)(53546011)(26005)(6512007)(4744005)(2906002)(66556008)(8936002)(5660300002)(31686004)(41300700001)(8676002)(4326008)(66476007)(66946007)(36756003)(43043002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjlrV2txd2w2dFUzbFhlQ25yTGpXc1ZmNjhtZmd5VFpzZ3dIQ2RuRVllVzVX?=
 =?utf-8?B?Y3FFSmVIMVBlcU5rNW5QMXVHYnJkcXFzNlBmVUM3TjJSVkpGelFabDZKdVZH?=
 =?utf-8?B?akhsWVlOUmdqQ3F1d3FCSkVkaHZWUWEraWxLSStWQUgwZEtXUGdnTDZLdFBL?=
 =?utf-8?B?cUtYdUpoNDlIZnhDMXNFeVhmaG1uYXlsSi9kZ3dKdGVpUlhiMFJ3dEJNLzh2?=
 =?utf-8?B?Qi9QSmQ1OFRUaHFGMlJnbGNxRnhPUTd2UW1TcnNnR0svaTFEc3N0RnRwYnBm?=
 =?utf-8?B?dy9Uckd3SkJKeXQ2WGtoTFg1YnhsamI1Vzc2WFYwbS96MEQ5blZCOW54dzJp?=
 =?utf-8?B?di96dmhHK2luaVBtNHBKS2ZuWldBTlp4bWs0a1NZVStKcDRtdnVRN2oyTEQ0?=
 =?utf-8?B?YkprU1FBSDJpb0xsTHRKcFI3c09FdENPR1owdTlyV0dkWktJZ2dDcVZvcVVU?=
 =?utf-8?B?VHVkVi9NNjlIckowd2Qybk1DSFVvYjJlTWtJRUw3N2ZVRFE0cHdRUUMzbFZU?=
 =?utf-8?B?R1FlRHp4UThIdHJpVmJqZ2VPUTlzRSt6K2gvSS95U1Znc3NuSkpJeEVYdUI3?=
 =?utf-8?B?Q0NQU1NnampTMm1XaWU1b1V4cTFVbG5WVzBkd3VXRXM4Z1VVVklPYjlKRDRU?=
 =?utf-8?B?YW1aMVJES0FlbmZZa0szMFlLM1RYeFRYQmtZek9WeS9oblFaWFhUWGJHdkt3?=
 =?utf-8?B?MU1DNEdvdG5tYzh2UHpJTENsRTlvNlFSRmtCQVYwY1Z5STVxZzJOa1JUdmN1?=
 =?utf-8?B?eFBEa2RURmJ2NXd0VHRScVYwaSs3eWV0UnBGVVBJVi9FSEszSXQza2JxRVQ4?=
 =?utf-8?B?ZGhzNHFSbkk4aEsxc2liS1JCakZMMW9tTC9BR2FUU2xhRmdoNW5vRWUyMmpm?=
 =?utf-8?B?L0x6Zmk1K0VyUDVyWVRyY0JDNnhIbXdwcU9VbTgzSnhqRDZkaGlaUnVkQUNk?=
 =?utf-8?B?ZnFHVGpGRktpcUczL1ovK3owNjBOOWxUMzI2Y1R4bHh4RWxsYnhxM3crNDIy?=
 =?utf-8?B?ZkRCalNKWWswSmRQeGJBRnNKVERoZDJTK3NsSWZDWVJwcHArUjNNVVJGcHR3?=
 =?utf-8?B?TDBUM3N4cElKd1h5eWtjTVFEYlJjTlRaRzhLU3N4VUhXZitpQ0p3K1JZWTBo?=
 =?utf-8?B?NC9OM2doM0hlR0pOMW9sVktaUkN4U1BYR3ZiYW1TU2llR1ZhL09OWm1WUTIz?=
 =?utf-8?B?b2pMb3Z5QlpnZXBOdWpXa2NDN3hjNVlDQVJycDZNRmZJNE1XS2lwQXhhSXN5?=
 =?utf-8?B?MFdhS0hLcGVzVlBmK2VCMlFiK3RJeXpWSEdtdzFPZlNsdTdoVVM5YTdRM083?=
 =?utf-8?B?TDA1U1dtRnJPVlk1M1BzeXNVTFJLcE01N285ZkFYYmovZEljM3FTdGxVNWg3?=
 =?utf-8?B?M3BpM1VJQzBXRkZrRzY0ZE13OVBHTW5xbVFqN2JwWnJkN2tjTjNlcmx6bERm?=
 =?utf-8?B?WThUVmJXWHpSY1N1RE14bU5tY1R0aFpkeG80Q1FZY3FIaGJ6Vjk3Sm9lbnZ3?=
 =?utf-8?B?VkxvYTI4VStwaEFPcFliTTU2ZkhBMEg1T1hDRGVtcVlnWE1hbU4wVTlUbDU3?=
 =?utf-8?B?NThMSStlOXg5QlpnYmxldVgyU2h3VXVQdTVaUm9ZU1U0KzJ2blZiSlBESjg1?=
 =?utf-8?B?VThNUnVMSWhrc3JCQ20rS1FCeHNoSWp3dklqQU0xRVFkRHdDdjBCOU5pOVM4?=
 =?utf-8?B?eklSNlBPNTI3ZVNLcnJWNXRmSXFYQXJKTTNOS2xBcDBlVGIybUNuUS9FWEpS?=
 =?utf-8?B?OENMbjB1VEErZ29PMjZpdFdqOE1CdFRtMGt1bGlVQi82RGk5OFNOOUpXcGhC?=
 =?utf-8?B?d25YY0N3UWsrcUhNSnhxR3R5TFcxYm5Nd2F2eHF4V0Jzc3gwSzArVkdROStW?=
 =?utf-8?B?WFBOemxhRU51c0dIanB3dzRoRytiN1FJb0pJYXd6RGdWRnBoQ1A1T3Nrckho?=
 =?utf-8?B?Slo0M2RVYU5PWWN2c0Y2MFl1dyt5WUFNaVE0YWxpc05EazlLblowMGZFN1hz?=
 =?utf-8?B?UUs1YTNuejdFRU1adEM3K3lTcEtXcnd3U2JaeFVpcDVWVTQzREVVL082bkRr?=
 =?utf-8?B?QzE1VDRrREg3d0RzbVdWWE1wQkg2VTJXeUVkOTVNQ1FQNTZndVRrMllvNkNL?=
 =?utf-8?B?MWdPdkpldWVtdVBUTUNtU3N6VzNmT2JNUS91RlVialEyMldzUCtZZlVXWlZ3?=
 =?utf-8?B?WUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4885155-53da-43b9-dea7-08da92883512
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 17:24:53.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QCP1QWpTfac85nZl+4ZPb/X4mYvK7FHex2fiSScWg9vSMFR03Iwvg/W2z9LWP0LsUUvA+uEECey3lUp9V35ijaQ8/XBrFRhOmhmLL7qReY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209090061
X-Proofpoint-ORIG-GUID: kdGmbIBTz01Pkr4vRc0Tro1Kul-GkAEd
X-Proofpoint-GUID: kdGmbIBTz01Pkr4vRc0Tro1Kul-GkAEd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/22 6:32 AM, Konstantin Shelekhin wrote:
>> The patch solves the presence of non-deletable empty default_tg_pt_gp
>> in RTPG.
>> May be, a global attribute like target/core/alua/hide_emtpy_tpg would
>> fit better than an attribute per each port group?
>>
>> I would always hide the empty default_lu_gp (not configurable) but I am
>> afraid that it will be considered as not backward compatible change. 🙁
> A module parameter perhaps? Or a CONFIG definition.

For the ceph iscsi project we wanted this same behavior for a while and
we had to use distro kernels. There are probably others that need the same
thing so a kernel config option wouldn't work for them.

Module param or a global attr in target/core/alua like Dimitry mentioned
seem fine. If the new variable is set are you guys thinking that
core_tpg_add_lun would just not call target_attach_tg_pt_gp? So the variable
would be "make_default_tg_pt_gp"?
