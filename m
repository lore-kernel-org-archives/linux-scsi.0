Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854C3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 16:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbiCHQxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 11:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiCHQw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 11:52:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C714EA18
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 08:52:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228Gmsf3004821;
        Tue, 8 Mar 2022 16:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uc8vYpGQGqhhLWrB7til4hUomyhPtaGKPVBfaLIyx/w=;
 b=v57uUMD6LQ4Od2lsLPzuGh0SrfE7g3QKu4IrGXf6C0rDvDR3DDX6fu7DOHCLOcmEfZYS
 bRhMxckvNkXzOcjBnH0dII5mbfXsVj5cR7DFF02hpWSLZr1sfWe6LJYSmJAN8PmcmPd7
 YwIeUs6byU33UoAswXsHU5lkonNA17PlmS3V3HJDWXM+WYvk6erkYTEjOwVwukFwZ2wj
 wzADzgLvNhqfjhpICvy6anmqskbite/ugs/OEoUkDxT7LnHiCw6/5dNqg4EPwlL/KF/M
 8twKOzW744/Z1SrfBkpRtK7fsVDJIFbNQImNXluGyV3RBzR73V3jEjfShxD5HQS8UptJ UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsfjyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 16:51:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 228GoM3k014680;
        Tue, 8 Mar 2022 16:51:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 3ekvyv2jqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 16:51:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWjsNGWxT0Gj3VybgUomR24Dy+M35vPpS9cDGLHzc1eCHTh5naOyzQslH8nOGrtmzAK/t4krahdjg769ZlN+P6TDDN7YwIQDosw62FrR1d1MyvRlIVnrSo5kWfAv93GT6iOr9dzMtm8HQGNPkTgYO+UVc+e3nf9DPdlnQIAiGB7tucr1c0sqY1Vkaw15W1Jtxa4KCYftgyBwlp9QhmzgiDMzPYguUGRKcfXHjo0OXx9TDjccCWfNKzYwdBjl8vzLXbY3QuNVwyVwEB4vSilvSuB2Twt3lC9XLYUg6haBbTbuQz10vl+dNUXEL/YpfxHNEZj8gS148CPt0MY1CQJPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uc8vYpGQGqhhLWrB7til4hUomyhPtaGKPVBfaLIyx/w=;
 b=DkQZimjYKXGPYelPPkpDOZpprY+wIZUDvu97mpEsgXSDVBYn6IqtSPPfaAItsm84Z0tpfUIEjAzT8S0Uw0KBRmI7qPWKpe9boEESh/mxpsrvkFlM3VKdi3Lt6nKArLuW+zPbG5N0GhqvKh5M+FIKUoHNlEJjoU9Y/5nfY7ouisEgxYaOvIALgKlkIsk/1CUjEseXO8+hAuOEwZfeoY+1qL3AWqIei8fDTO6mHdAlBg+8vLph9k/n3TqTVXTW1sY93oz4V7WQGBimu2ngQinawuTVCRjcGwBRq4BhRC644WXOcNK8bDpwin1j74tr/Z9tnUdoFT6NdWDUM80ZZNdixw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uc8vYpGQGqhhLWrB7til4hUomyhPtaGKPVBfaLIyx/w=;
 b=HGb2a2UV5Fccd315yi+XuCXvcRkyxYCxYGGi000mOjQDoWDlwyiG8nyhiF/75ceRadJ3u1/Mx3FmuroFt0HXLXROLa//SFVWuw4PEddmuUTkzpi0yZa3gMkGbjA3a/VW6kR+WJlFjjzAxOtVD6TtCD87ME4WHNP7UAqB0KovJ2k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3865.namprd10.prod.outlook.com (2603:10b6:5:1d3::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 16:51:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 16:51:46 +0000
Message-ID: <eadfc942-4c6c-969c-8ff4-e357c3601b9d@oracle.com>
Date:   Tue, 8 Mar 2022 10:51:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC PATCH 4/4] scsi: iscsi_tcp: Allow user to control if
 transmit from queuecommand
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, lduncan@suse.com,
        cleech@redhat.com, ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-5-michael.christie@oracle.com>
 <56f5c05f-561e-0079-6996-866a047d7535@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <56f5c05f-561e-0079-6996-866a047d7535@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:5:15b::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ed0b737-b4bc-418e-e40e-08da0123eec0
X-MS-TrafficTypeDiagnostic: DM6PR10MB3865:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB38651A54A30D602EEAC0BFDAF1099@DM6PR10MB3865.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EkPNxeO/j9H6z6ZlJZIqjTpJm558Jsm8vzyBbAtGip4Q2FTWS0NtxfOaHWCogrPfIg7ItRlXC1pLKn0dZIurXw+BWw6bEPAlr1froTYFBlWQy4ED04aAFDj9TcwwiQHXSXCsPFemsGlAHgBApc3dJ49FLogvgvFSG2uR+Qgssc5GH7+D4Da9W0ZBzjEMfJlSEBL4PL5cwPrOs5LRtPVgdNq66Hm/AHXIIgkG9XLGiUAcaaJIRQ/Du7e7A3FdrzbQph6NhgC1WCsNlOp44IX4PNDng0NcS6Scbwbzh5GgM79+4ulHUNP4GQZ7EIemaRsJW3YFc4ovQH05m9mIav9dEfpOjp8sSw5zoBT0TANUENSe0+1P4twWvePkcFUleOjksjKLwpD5Z0WQW0ICnwRAUJMTNbqdoTgNlJ28V4E2mospMpG38GmcrJ/zcNmhOb45Nm3vm52jMr6gHUqe1TKsqjnvqZlHdZLLJuzTrfITd7dmuctWr+uOH4MInLVVShmkBD80FpafqfyNO2EDFrasWbVVQtnNB7nzh/EsnEtzi6eGgwkoau+fcJZvfx9dUdA6aleU+Gzlunw9onN5RdO+91LuA0uVeK6zytwPEhh4nbLUy2KSTC8+6KWwFvwnRV0LGH5i0PMuvtfUVqquD5fuTYzlDO9Z3KOmO5ax5wHonIxzxmi5g7f3JKtROnaLwaNdVDOvLBPebiXPuKDppOQfp0Vg6gwxd4hnHoUWR7eHDHKVYogw/dKIbaYMuxXfzcV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(31686004)(2906002)(36756003)(26005)(6506007)(186003)(2616005)(316002)(6512007)(53546011)(86362001)(6486002)(31696002)(8676002)(66946007)(66556008)(66476007)(5660300002)(8936002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmVQZzZrV29BSGJiY3FUd0xUNzAxWHlFa1pjSTlseW8rNXBFcExCR0JtTWN5?=
 =?utf-8?B?WExOL1JPNzl1L3NrMW1LVzRUNlVBK1loanhkN3VDa2VBa1dXK2JaTHNyNC82?=
 =?utf-8?B?MVh3NlViL2ltZEVKbktTSW5rT0tveExuSmthMlhGUm5wUUNtVjd1M01HVHhB?=
 =?utf-8?B?M0FZUVZqVWFOYVo5WHpHaS9jQlpSLzVJLzdHMUVnMmtZY3lKd25ETDFUWWpv?=
 =?utf-8?B?RTdlSGYzampVTEVaS0wwaysvMlBJQVBSM2MzQlFkU1ZqTkRBQWJKSHBhTUlZ?=
 =?utf-8?B?VDBZeGFiNGFTa3Vpa3lrV0xFTTJ4ZmViRWlnYUJqeEwrK2xYRDlYQ1RLOGhV?=
 =?utf-8?B?LzdKT0gxdG5EWHpGMDhGbnU5VS9hNHdyeHVhZnpIbGYxUk9IQXBnK1QxSmFr?=
 =?utf-8?B?bkhHRXhRSlpjOU9KZTNJSmlLZlVJL21OaVdtV0RzcEtJb2o3czVDZ1o3ZHVF?=
 =?utf-8?B?UGJNd3ZjRUdKT01Id3JhekRVRkdpWVlJZUZrcGVNeHhkZFBZOHlITC9NajhU?=
 =?utf-8?B?SllMc0VlSnlzQVJZM2srVFZ0SXcza0ZKOE9uYWNhR3A0enM3S3ZqS044MjFw?=
 =?utf-8?B?WC9MZW5qQklua2d0WU1SV0pxcjl2RktXQTFVQzY2aXRlWmwwUXpHWTJRTmRp?=
 =?utf-8?B?OHNMUWZDNVQ0cTlsblM0QVJTQVhoN1ZWdXBDcUZhTFNmQ0xkcmI5cUZLUHRo?=
 =?utf-8?B?ZmN3cStpQlFHVzZGUU9CWGdEbjB2QWNPUGJtMXNabFJJNER5SXZDZkFFNUE0?=
 =?utf-8?B?WDB2dUxoL1oybzM1djErQkRKdjBra09PNG01OEo4ZkNnOFZ2ODB4Yms5L0Uw?=
 =?utf-8?B?M09GL0JJWXcvcG1hQVNmN0NjaUpybk4vZjZLUUkyY1Yxenl0Tmd3UG5HSDU0?=
 =?utf-8?B?UnBKSzBxbHpwbDNRT3orSDRyV3J3WmFmZlBHRDB3UWlBWjJLVGgrMm45Q3Jk?=
 =?utf-8?B?SUR1RysrTi95RTN1SDArTHdvT3JCQlIvTFc3Mk5pR0R0d3Y2RTArbmZIR2hy?=
 =?utf-8?B?TDdSd2tEa2tlUjkvWFNjVGppWW03VzNMcWhwL1dRc0Jnc3RxVldKbjhPOEgz?=
 =?utf-8?B?andQOS91Wld2ZHR6QTBNWE5RcVh5SjNrK0VLZkl6K1lHMUord3kwcGU4RWw3?=
 =?utf-8?B?cEx1N2FyUzRnc0h0YlpIWW1aejQvVDVBWmJJVi90V21QanRDSjF5Umg2dngv?=
 =?utf-8?B?cXpVT1k5Wk1wcWhVWExjS09FRVFlZ1RBWHRLOHorUHpxUVdZM0dUUCtaL2tr?=
 =?utf-8?B?ZGs1dkJVaEIvZVdjdHdWcnpTU2s1eWk5dC9jbU5UZTBnV010MU1CM1h6b1JU?=
 =?utf-8?B?clRUUXJLS2piWFVKQ2RHdFZ3b3I3dEJ5UEJFWmtWcGNuL0dyQUF1OWR6UHk5?=
 =?utf-8?B?c0M1WW9NUnl4d1JtSGw5d0pOZ2xlVWdlQnFpMVdhK3JaYThjR2Z2THJVekh4?=
 =?utf-8?B?T3k5ZHF3ZGZuSTVFb1c0NzNQQVFMczU3NGtFbUxkbkhWL1VPa0lNN09mc1Zu?=
 =?utf-8?B?UndRQXFmNDUzYzZrK0VaallzNm5KaVg4Z1NCeVVzeTB0K09oZW8xVEU0NzJs?=
 =?utf-8?B?OFZwZkt3Y2R0T2pvcjZZNVVIemxUTGVxbnNtbEk2aGNiTlF0MUowUFFnZmp5?=
 =?utf-8?B?T21TUHhqdm1OQkcrRVhSQ00rUFIxVWxGNXJrN3phK1FQUnlYb3dmaW5hcTZr?=
 =?utf-8?B?QnZrdUYxeEJGRVIvZWJtVldFTVJMaC8weHlSU01BQ29tQWJtZE44N3FIK2tt?=
 =?utf-8?B?WE5pcWozRXA4RzB5NlR1dnBXTEcrMUdxSVRXZVFsNkFPR3FEWWJZVGVzY3lE?=
 =?utf-8?B?RGZaZmMxQmsrTS9ta09Pb2o2MEM1anZ1UlJocDNQeHUrOFNMM0NKZUx2MlB1?=
 =?utf-8?B?c3RXV090NHdEM3VEempYTFFFWVZWandabWFFRFNvSkpjTmx1WkdFb1J3Um1v?=
 =?utf-8?B?OEZxZDkvWVd0MXR6RFNvZXoyelpKWU1Mc0VUeFF0RnZhMFM0UVFualA2RmVM?=
 =?utf-8?B?ZmdVTk1TTHA5TFk3THNEZ0VvcGQ5U3BQTjY0NDlxQ1VpNkV2TFVVeW5ncE9q?=
 =?utf-8?B?U2szeWFpRnIwdzBXR3JaaHRHbktwa0Q5RjFHTFpzeFV1TnJ2bGhZWlhTZE5a?=
 =?utf-8?B?YnMwZ0d6MnJUc0R0UlRKR29MTnlOMUR2aEMyVDR3T2w4cmRzQ2hhTFR5c2Iw?=
 =?utf-8?B?WU9QNmYydnF5WDZSZWFCODVkUXdqbjd3dzAvYkpRRHcyWXMzNGx0b0VYd01w?=
 =?utf-8?B?UGxpRTByQVNPWllUOUhtZm5UemdnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed0b737-b4bc-418e-e40e-08da0123eec0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:51:46.8542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rP5PU55XwZ7zt1/3IjhWTLWyL5b5QcGvLbJp0/59oYzcj/2kAoF5l95GuDXwJyKGez1WdjJVqO00nUJ7mH0m2IyhcXTRliSfWbDNxGzq0Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3865
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080089
X-Proofpoint-GUID: hl0XtCkpLJI8ulNtcGhw1KuoX3h_IzcC
X-Proofpoint-ORIG-GUID: hl0XtCkpLJI8ulNtcGhw1KuoX3h_IzcC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 11:10 PM, Bart Van Assche wrote:
> On 3/7/22 16:39, Mike Christie wrote:
>> +static bool iscsi_xmit_from_qc;
>> +module_param_named(xmit_from_queuecommand, iscsi_xmit_from_qc, bool, 0644);
>> +MODULE_PARM_DESC(xmit_from_queuecommand, "Set to true to try to xmit the task from the queuecommand callout. The default is false wihch will xmit the task from the iscsi_q workqueue.");
> 
> s/wihch/which/ ?
> 
> It may be hard for users to get the value of this parameter right. Has it been considered to make the iSCSI initiator select the proper mode depending on the load? I think the DPDK and SPDK software supports this. This is supported via user-level multithreading and by scaling to more CPU cores if required to achieve full performance.

The problem is guessing what the user is doing and wants.
Users just do a wide range of things for whatever reasons:

1. No tuning at all. Let iscsi, network and app run wild on all CPUs.

2. Pin iscsi to specific CPUs. Let the app run wild. Or pin the
networking and let iscsi and app run wild.

3. Pin iscsi and network to a specific CPU. Let app run wild.

4. Pin everything.

They all have their benefits drawbacks like if you put the network
and iscsi on the same CPU (or put them on different ones), and run
the app on a different one you get the highest performance for a lot
of workloads. Abusing the CPUs overcome the loss of caching. In this
case, you might not want to use xmit_from_queuecommand because we
could be transmitting from the CPU the app is on and it might have
wanted those CPU cycle for it's own work.

However, you might have to put everything on the same CPUs because they
can't interfere with other workloads. In that case you take the perf
hit. In this case xmit_from_queuecommand=true works really well for you.

Note, if you start with xmit_from_queuecommand=true and if the user is
doing a workload that doesn't allow us to transmit from the queucommand
then we do drop back to the old style of doing things. We also do that
for the case where SCSI WRITEs have to be broken up.

So I didn't make it dynamic or change the default so I wouldn't mess
up existing users.
