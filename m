Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD14C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 17:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbiBPROB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 12:14:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbiBPROA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 12:14:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071772A598B;
        Wed, 16 Feb 2022 09:13:47 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GGw5Kv030414;
        Wed, 16 Feb 2022 17:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=S6hCqgbeYKd54O5IBLhNKYM1KlQyk/ysPaqDSSmzJ6Q=;
 b=ZZhmx/ZD36aB6AxWAS9AOAteAwy7psZc5Nw7Yrg+VIkL0ljtGRAjrWR1Rl+3m0OZYIov
 pla19T5Rwr1z4/1fnff9+LXuIF7kAzbUiXp3cHyAP1CxvuRRA2MoCrYE7U/xc0vgIgCT
 r/XSGzpafU9qxizBK8sfKPKBS/YkTTuBjKpyULwWQ5WWW6wKa7GNi0rqEzgaGZ/G6NK/
 DUYHK0S07QuzlJuSoh0dc7lIv5LzmAtkgtXh60tWPv9fLG9OB91bLUMw7ozQ9p4qNEL7
 VuGrdBPBb+tjMfBZnBY6JJ3UuO06SYE+O2kwpxiLaAqllZecd6P28Mq22WL3faoJn8pv mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3jpqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 17:13:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GHBFpW169726;
        Wed, 16 Feb 2022 17:13:43 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3030.oracle.com with ESMTP id 3e8nkya5nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 17:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpWL9cAUXeANSJbw0A93uxd0LtQ2j9pAYaLqnKY4j4zMtvw75n0+6X7/YknOOixC8O1SFytYZ90VrlaI+ioLYV3aCZnkZD2eG4NspgUTZtDZCYkO0POBcUAsb7PLrQ6Ox/hvtzECtc19f3G4PLsVzKcobtCos3yo+3yFKlxIkR6XlU1S/FcA1VfABYjY9tbAcWtSehtW8R0R+lxV4IA1P1WkdxPQNDgKR/2Gz7ptCnsnZMmWb4HR+gE+BPh9+2hovJBS3utVIYznoLllrHVIlkokHkWMpUDwL9F4AIIVijs6l/ySLur9uV1VMCzavWaGkTb3dk5/W6Ofg7q29oAJlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6hCqgbeYKd54O5IBLhNKYM1KlQyk/ysPaqDSSmzJ6Q=;
 b=JS6iUe6i87EWWF8gyR0q5mLhqQznPUxUiJ4qfCBWtU2ecqGqFvCXHvGjGL4x8eMRHtM1WWdG2gWWZAwFI9hmbyupR5+xInW9gW+w75BY12o93IF0wkOw1R69N5SPoiGOnuxc+XUx4WJ0N/e3F74vf1dCMEPUm9HSgXl5JXWEL2a+ywFfXh7T6a/UtNGqLsx8BcFTgIJoZWVnZzenxXkdNo5D+XETnxdonxVUIkArBUVAu3NgQ3ttywq8k6G8AEPe5uMDFoS4sr0boO3BZFVvfSSCWSNcxVs0t53yExAfO/oQ5zIGl8nxkYLBXIV2x2ockUw1rEMVjbKYWf9lxdoqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6hCqgbeYKd54O5IBLhNKYM1KlQyk/ysPaqDSSmzJ6Q=;
 b=DcKocTtB8PJ0dQKPl3WzsfoJvmlSYU5y/pykD2gTn7fMpYk8VEo4Hsv84q06MV3USOWMxv2La3GzJAc0flmn2bzLEmJRO7UL7QxJyXPHGfqDUNPcAfc+Fg6vSwBYcSQO9pOHtkh10v8c5t+eb2bpK/fCxCnmfJGbMm36LPkiYcc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BL0PR10MB2788.namprd10.prod.outlook.com (2603:10b6:208:79::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Wed, 16 Feb 2022 17:13:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5%5]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 17:13:40 +0000
Message-ID: <1ba93dce-7dbe-89da-a026-e8816c678f9b@oracle.com>
Date:   Wed, 16 Feb 2022 11:13:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] target: add iscsi/cpus_allowed_list in configfs
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
 <7234209a-d308-622b-700e-e72907246ff4@oracle.com>
 <7ff3a449-980e-ab44-42cf-7520a0796483@easystack.cn>
Content-Language: en-US
In-Reply-To: <7ff3a449-980e-ab44-42cf-7520a0796483@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR12CA0018.namprd12.prod.outlook.com (2603:10b6:4:1::28)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a148fca-d51e-4e05-1b44-08d9f16fad6a
X-MS-TrafficTypeDiagnostic: BL0PR10MB2788:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB278874C3F6AFFA18918A6F5CF1359@BL0PR10MB2788.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CO/ufk5VN4QqilXKD6U0HHqjNILQDHvF4zYmM/+Junk5t3c0qKjVeSvFjzuMQ9nid0UTD0U5W/2MtMh5QQ6WxxSvMj3R2UdBZG6Lmj4bDf+SNKyf38Lts4YXeHBmFAcGYdpGOX5Xrrk9lVP+h+WQJ/1eENauQ9uThfgFnBONpQM8Zfi9kLyzpJnn96YAAYEExmL/SuSpMMmEkAN0XjjABPJUhQNW/MeF6YkjQ+J6VENnQDR0O62fyX2UHWs0X2dq23cd5yZp3pmgwm0J4GNRZZdImUKQ8BYapQEL9rWYfn+XqLvRAbR2FKs5qxbyLsdFUcpa6a+VsXffuKZFSGh/c2QHQJtond1azSoitNr1ZD51KmuQqvbXCr/uU/AO7bih++iE+VHEwIZwl6Ks/Kf9XsmiMOntIVnConmKJlLhGZwcukyfdtzLY14uKXxDvHFcn6DspZhqksIBfpYXUf4Tj4XJuT2UVgSFqapgat2QlOwlL4XcQZ0VPoYbAwNC8GVt+Sb9ANx9kPkc1/o1YFZdcImmBwaHjKC+fLaP8gpNzUauiNrAV+bg0XhVrQLmNuF2OetCwJCyZVurc8UyOLqmEeXVlURbgZtLIi1Esl964WbAsuSSmYNNL4YviUPtny/XZ8DqOeihY2sTSkyYcq4FsmPm9TKXtLJzjE4IMDESu85hLgIh/8oHni7DxVRCinXw1zQp5iqNMokiPBiQdyF0PmkvxqP4UoFzEfDk55QC4LF0aoy7ybklMHd+Fo6nh+xn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(508600001)(8676002)(66556008)(186003)(66476007)(66946007)(31696002)(6506007)(53546011)(6486002)(6512007)(26005)(316002)(2906002)(38100700002)(31686004)(4744005)(5660300002)(2616005)(36756003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUE2Q2pPSDAxNDZGMnZ0d2ozVURHVHBMWDV5cENTbUdsZTBTR1ViUmd5MUZk?=
 =?utf-8?B?a1B4QjR4YnVyU2w1UVB2RHdmNml6VXlzY0R5eXVRNkV4QWtsS281ZGNMbVZ2?=
 =?utf-8?B?MEc3YnpidUVBczVsc3NjdmFlNlJxODdwYUNpeUlBTjlvVjQ5LzdHMnNOdE0v?=
 =?utf-8?B?aFA1VmFUM0lmKzZ1VlpWcmJmQXRpT2tpMEk3ZW5Xblh1V2xteFBYdlUrMGgx?=
 =?utf-8?B?bXpzWVkxWkVoTUh1VDBMWGhrMjBQY0VNTWdidFJzYnJwNFFXcTBSVmhiMjZa?=
 =?utf-8?B?QkpkaEhpcFdxd2M0bCs1U3lCTTl1OVoxSkRTN01jcjlISFFBVzFaSFhGK1dn?=
 =?utf-8?B?TVZrOFJNc2tHekRiYzBCK0lVVk5GUHNkYzhXdks3NUZQVTgyNVYvYlZ2bWNt?=
 =?utf-8?B?OHRzVE12Skx3dG1FeE1xZnlsci8zbktiZWZIc0h3a2ZtUlp3Y0dGa0xuRG4w?=
 =?utf-8?B?cHdFZ3l0emZEVXlEeGNBZjRwdkdWRFIwZ25weXlxeWp4S1RjV2VJM29MZFph?=
 =?utf-8?B?MC9nZmdlV3lIREthNTA0U0taVDFwY1lkODB4d1gvVWYyUk8vdnU3S3FtdGlE?=
 =?utf-8?B?Skk5SjNpYVdxaW1iVVUrNGVvVldkSTBjdko4S1EycGl5MXRwV25BN000Y0J6?=
 =?utf-8?B?MVg3NFdRSU9SQmxrTUhnTDNmcDRPNEdXT3BNYUtIeVpwbTZudGE5RHo3cTlD?=
 =?utf-8?B?bHVjQlVDRS8ycTljaHZtV2pCdmJna1RvdzBrV2NraGJveC9nTDJJYUhRZEVs?=
 =?utf-8?B?NDR4MUJvRTM3U2NpK0NrTTVLaWN5ZHBBLzdZb3dMWUhNekR0UlNqdFdaU2ZI?=
 =?utf-8?B?N2R0b1U2M3JmY3dVUjR5cktKOGxrQlhUcVl1L3JJVWRIQ2tOZ0RMZjZKQm12?=
 =?utf-8?B?c2xuck5HR3I0U2c1SGZpWERiRnVjbTAwQWJTejN1MFoydVV1Tml2aFFDMUlw?=
 =?utf-8?B?UjRHYnV3ZFI1ZStKdTltTXFGczRmUDBiT05aUHhaU0dYYXg0V0wvUHJBS1do?=
 =?utf-8?B?bEFubEtpc081UjRJTFU3cm9ZSHE1aExweTdWSnhrVGQ5eDJUUVhrSXNSVGt0?=
 =?utf-8?B?ZjNIdHZ6bXZYRUxyckNleExHZUZ6MW55MzZlbytmekVxSFZVdExRaHlsbWZ3?=
 =?utf-8?B?N3dsbkNpUGRtOGQybVNwdGNmaWtOSG9GaklOaFFFMUZlOXAyQ1ZaSTArenU2?=
 =?utf-8?B?Z3dDN2VWVUxnNnRvbGF5M1F5NTlPRjE1LzFsVnpMcDlZa3JGQXI3OWkzbm1O?=
 =?utf-8?B?Z3gzNlNNZmxydC95TUc1cXdZWEcvTTM1N0ZLRGMyRGIzNHdjOVhueFh5Mmk0?=
 =?utf-8?B?SWkzS1NBOEVNajZTNWlaYW9ncGVKekNrVlhZb1NoZW5xZmt5SjJSU0ZobVV6?=
 =?utf-8?B?Z1NwQUhid3NBd3YrWGsvYzRQZmxuckNPc2hhOTVWdm9xQ2RFUnJ0bzhnMmNk?=
 =?utf-8?B?aVFlYmJCVHV1dnFGWFp6bVE3QmlWZlBBRThFb1UrcXJ3azhhZXlQenlrSWU4?=
 =?utf-8?B?MDF2NC9PYTBhYXdFQ0N6OXRTZDllVlA4UUc3QTFyc2JQaGZTK2NvelB0a1pi?=
 =?utf-8?B?TUNIVzNYWTV2OTd2V2ZuYUJtMjVNU0tpNTFpZUFlS3lrSmdZU2VKT2d1K0tD?=
 =?utf-8?B?ZVB2Qm9MQXJqZlcvSzU3RHJTRGUxY01DcE95YlNOOHg3ejlGUjRpZEZ1NGhT?=
 =?utf-8?B?WGRDUGNaQUtnN2NmREVCZ1FVd3BZeDhTdU5hdGt4WmdNRWJ5K0RZaWg5cHhx?=
 =?utf-8?B?c0ZyMVhRck1RbEpISW81THBqTjF4VHpxU3hodzYrcSt2TktaMFFrRXJrTGQy?=
 =?utf-8?B?dXRqaVYyTkp5clhpcEdhZDE3Nmx1a2xpMWZQSDBLbUk3cDZpbWtiSDR4SVJ1?=
 =?utf-8?B?VkhVdjBvTFhtOUJQYlN3MVN2c1UwaUluRFl0VE1iUEZVS2FjUDFLTEt1T1dH?=
 =?utf-8?B?Q2dEU0tNa2hROHpFODZYU1BBZ3AzN3hnUndNck1Xdk9WQURzUDd4eERqUlJa?=
 =?utf-8?B?aW5RTmtaWlhMcURrRzVnYVJXSnNoSjI0ZjBzZFMrVFVwRVJyZmZXbEhNNmt1?=
 =?utf-8?B?OC9vS2xnbDl0Y0VqRnNIKzl3YTJXSDhSV2RwcG05NWlDYUJrMFBOVGxXcWMz?=
 =?utf-8?B?R2ZHQk9NOXIvZjJSZmV4RldIeHRxcFdFMi8xWnpwRjNUeG1SQmgrZFZRMlhu?=
 =?utf-8?B?UkNUSm1yQk81RGdnWmlHWFNUdjVyaU1WZ0xWTU5nZXFGLzhLeTJ6dk8xa2ln?=
 =?utf-8?B?aVhjRHVzWTRaUXBuc0dDVUJHRlVRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a148fca-d51e-4e05-1b44-08d9f16fad6a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 17:13:40.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTm+TiygH/jOYvtPGT+e0SQ3sqD90m5mJEIydSUy2ug09q4/JhqRp1bP4c8dkAJFCvYLX9GLfERjVHcvpMYvA4GQGxmuiFSci2PFI5m9/1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2788
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10260 signatures=675971
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160099
X-Proofpoint-GUID: LDPEMMsKNTjscLh3egH2udGzhe6CBRVG
X-Proofpoint-ORIG-GUID: LDPEMMsKNTjscLh3egH2udGzhe6CBRVG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 5:48 AM, Zou Mingzhe wrote:
>>>   +cpumask_t __iscsi_allowed_cpumask;
>> Maybe better to put this in iscsi_target.c with the other vars like
>> it.
> 
> Originally I wanted to put it in struct iscsit_global and use it in iscsit_thread_check_cpumask.
> 
> However iscsit_thread_check_cpumask is also called in cxgbit_target.c. I don't know if I also
> 
> need to modify cxgbit at the same time, and I only modified two calls in iscsi_target.c. I would
> 

The new configfs file shows up for software iscsi and cxgb right? If so I think you need to
modify both, or you end up with a file that returns success but doesn't do anything and it's
confusing to users. It's also a simple change to cxgb.


> like to know how to handle in cxgbit_target.c?
> 
> I want to move 'static inline void iscsit_thread_check_cpumask' from iscsi_target_core.h to
> 
> iscsi_target.c and EXPORT_SYMBOL(iscsit_thread_check_cpumask). Do you agree it?
> 

I think that is ok.
