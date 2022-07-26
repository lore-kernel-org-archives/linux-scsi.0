Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D008C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 20:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiGZUYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 16:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239831AbiGZUYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 16:24:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECB532B84;
        Tue, 26 Jul 2022 13:24:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKMhGr021618;
        Tue, 26 Jul 2022 20:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZWlVJYWOuDF8qWMKBLe5CjCBqShUwewCjvUa7SUXzbg=;
 b=h/yK2lTKB9Tc4XfUX+yYTu1g06+MAsn33veroIhxREl5r5a/ffod8EwSp0E9IarmbWLi
 ZQE0mjc60qJLc3BQUzaxR8sF6vQ1V/neXw6f3YsrqrjtTk2H+J++F9RnRlfUfut4F1dM
 kOPp+tkCbvmstdhioUd6cNtTf20ADdNxWZndfM1kPexnyM/w+lPvZK/svvI/dUIuOu/R
 ewRji/EsNDgyI57wSMTzHaMJV+ktGJtjYrQU/02vAWQDnpBAgNyRx0igSpRsYN+fFYvX
 xh9EOICkIPw96DQ+7S9vfQItslqb2OchIGmMtCoObaVaSj+stg0QXTGp13POIquUg3SO Hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9hsqrs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 20:24:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26QIlpwu031524;
        Tue, 26 Jul 2022 20:24:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh64sbwct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 20:24:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csT2lkmiTizsGZ2fDIG1BaK5ElbL/MUwRGZd02bOBKnSvVA02gm0dm5n7nZvOH5iAR9uTvTtURhngGm8ZKa0xKlbKqKrin2Rz0U3x+swnkqDkfb1RLGHhTT/57vZ3LnKybyajbujxpnSYBb0Q/Ul1xZkZhDqUOHmn4SDFsAw5SSTU2lZSnQS0OEdh0GUjU2tbYF7PfzNo+mCy1NVy8z0dgpF+MN+CwV6xCxFM+b1AZVvX2NhcJ/brp7Rqe76TiTU88d2BLEPm4kGvUchyP8uAned1hWRdagdU37Qanov5Fr7Qy5Z3/poX6kXUkCLvY8BAi/ERRiOPXCOv18uC5M+PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWlVJYWOuDF8qWMKBLe5CjCBqShUwewCjvUa7SUXzbg=;
 b=WINMvLZvHu+q8oGUKEg8MISXb2douoAr/u9SnY+zB6w0TYTlb4sXKSgA67nMZP5m9mTF41j56cYkqKy1ikRbEo1d5yQDMkzNPS56QKkzEtP4TqCil1iwJKB0DSvFzLj9M4B5s3IUaUzVyrz7wlHPXF3WcCD4Na42Zl2mVwst4WdNBVpAzNRyFafh8T0f2ekrc7MtAjvoIlKVEkin4mU/9b4L1ciOegZyNtwhAIvxD8d6OBHRLrGYZ0S3quTBq7KHv6jryAt4dfy8iJircxIA1Fpi2RfbdqAkGBdBbJNFwsZFBtiTQqUqWLtYzX+XOvGWo+mKbzlFxnTz+E5zMG79mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWlVJYWOuDF8qWMKBLe5CjCBqShUwewCjvUa7SUXzbg=;
 b=vU/0UTWQeA9aHRpkhgIVZg8SG2EFw3MQ0vpZtz/EiXXScSnwywyKWF7Y0FmwYq5WElDep/H7qRctTAcqG1wlDmTMEGca5CRaOT0S6Jf9vIfvEZA77sx4SBQrtCjgGOit51v1buqOeBfx5La/DdtGFWH/a/s/Udu7iZ03+ii2yyk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5056.namprd10.prod.outlook.com (2603:10b6:5:3aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Tue, 26 Jul 2022 20:24:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 20:24:30 +0000
Message-ID: <c3b0226e-18e3-7263-50de-9a6a5bd94329@oracle.com>
Date:   Tue, 26 Jul 2022 15:24:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 0/4] Improve iSCSI target code
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220718152555.17084-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220718152555.17084-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:610:b0::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5ddf674-901d-4b8f-3dc4-08da6f44d831
X-MS-TrafficTypeDiagnostic: DS7PR10MB5056:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: siyxJYmVAOUwoDzwIUVKE+jTPgypd3a/QFZJfd4AbJh/cDPE+zQMwHANTP7lwi+MLD8eWkKNnn1lSwjc+29L5NS+rZoIpHbPJ8XddlJj97sLHDtlTp0s21fGO31MZPGtvf0Gu3EkI9zPkWuubIppFgiQDwBWOiodfTlkxvkj/fUd3G3ML/S6lOibkpzYIMr/lKNSfdapPL8hob3Hzwt2QAvLXlNS5nxa+XImjk3x9mnUA01jq96p2e4O32sI8aoR/yKJzeSsoKJa9PkDD6NwksfJLMQBEAOzNycX37umdBN8xf2IWOGZnRhdEmgF9XnW2bF6QxOy19ogVs+c0wdmEFOE2bfu62v0zQNryg8DUxbk8im01I6XLJsuZwR0wlRQJYZ6W++bHBAqS3Afz9Ue9xexhBLaP2zUFkW0v9d0FmjZSZ5RaFXJDpyDMXqX5Wl+eZjGCtQFCn+mG8zcULcjlTbLlcocNycrTSjal372KNbiof1gqXrVwyV80LFlfcU1yGEQcJMcOtYyGwrbJW3yKkYYjIKK8CrJf8GMeQV9Wj+AgTNV2isBdsFfCwvUGi/8KFujIqgl3Qvvp/kc6lPYS/SVbt32sRXjZDmJ7miACQxnZjQ5ZUiBqSgZahKUllNe6qRbd7Mmc2Ssa4SkSTQmflWVtvxsmgYAah1IX6hJFcU9oSG/FNsupSFJrpkPJAjsWzCbNuyRgF6xGoqxXNq76bz7Z4sILDxl6wsb7/2cko4aFmssFOzHx+32Zye89HSa78t04ecRSA09e5VA9U6Kx7+EpoUq73ZhvnvLqk7eemjhyOHJv+KaLZbZIm0Tg1kHb+0VW07kV8f83COcrQQ+SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(136003)(366004)(39860400002)(2616005)(8676002)(186003)(6486002)(110136005)(4326008)(66476007)(66556008)(83380400001)(66946007)(31686004)(53546011)(36756003)(41300700001)(6512007)(6506007)(26005)(2906002)(38100700002)(86362001)(31696002)(478600001)(5660300002)(4744005)(316002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmVTNGhlYWg4Mk9MM0ZSNmpCemVESWp3MG1NNEhWNmxuZjhrNXhBdjFVWHRO?=
 =?utf-8?B?dW0zT0o1RTZDM0RiT2hDamdXbk1NdDdhTkY0SGlvS3krRmNFYzQyckM1V1dx?=
 =?utf-8?B?NmdjY3lVVHVqcmJ1cWt4OWNMVlpZcDlBSXdydjNraTg4RGRUR0pKSExhbUk1?=
 =?utf-8?B?bVl0MGJLNmVvckVXdVNTeXZDYWFXQmN3SmtUTU5Yd2FuVWhrTE9Fa2Y0OFBX?=
 =?utf-8?B?OUVzVU83dm0vdGhMc0JSdUVINFA3WHJuL0gzV0RzYUtpTHE0UnBoejBYWkJq?=
 =?utf-8?B?UG1LUW5yL3gxcUVjSWJNQ21neFQ0aVhoS2ZRL0NSZFBEZ0hoOFVEdjl2cGdO?=
 =?utf-8?B?NXI3cHh0dzE1d05meW1ITXhrUDlJa29rZ0I4dGhWbFI2QktOVnRKQzFpclQx?=
 =?utf-8?B?aVlLUE00TnlFU1BteE83YW40dTNBS0ROSU0rMG1qTHpMb1ZHOHFMZWhrSjZV?=
 =?utf-8?B?TUh4UVRSekdGTXdiK25FTGNZQlBYcERtYnVuMnJTU0NyNUx4djZrQWU3VDdJ?=
 =?utf-8?B?ZDQrM2ljbG9xVjVBWUpnWmYwM1hIbTlMVTkybkM1MGQyRGk2SERSVkw1OHZ1?=
 =?utf-8?B?Z1hWZi9tY3QyaG1qRkhYZXNtMTRZcHNQOENMVjZXMDhwdHNzVTF4TTVXODZD?=
 =?utf-8?B?R1czMlpVSFhySVI5UmpQcnMxZ3c1R096RzE4OWowelNBUVdydXB3cE05UDlW?=
 =?utf-8?B?RXpiczFOVExPb2RCNy9PV013Y0E2M2JmcFR6ZXhPZFVtcGVyL3F2SzYwL0Vx?=
 =?utf-8?B?WHNIRmM5RkcrVjUyWUl2Mi9XQis3NnJaa1REd0tEdkl5RVlhMW9UdkZPQkEv?=
 =?utf-8?B?aDZ3ajdXemRZTVdyR0pHZ1dGSUxtdlBLSldQZEluRXRGbEV2Q2VBQ2pHT1pK?=
 =?utf-8?B?NksxQnNsMlhQMUtSVytrU0VwWXAyczJOanhDenlSZUU4RjFndzJNVHZ3cUpS?=
 =?utf-8?B?b3AyUnJXVTJjQVUrMUw0U1AwN2RnN0ltSkFDK2lmWFpTaGg1MmZKRFBsZjlI?=
 =?utf-8?B?Vis1bUs5WWNMeWczak1CWk5tWHR3YnhYNEQxUUxkZWNhbkdTT0xySXpjbnA1?=
 =?utf-8?B?NmRtaVErNytoaEtYLzZTREM1ZTZTcUlCVzMxRFJVV1dzY3VVUlVnQ1ZYQWpj?=
 =?utf-8?B?YjJVUzVkNlFuVThIb3pHRFFzNXZiTko4NmFaNUJrSjY0QmwrN2pxaDh4dXhF?=
 =?utf-8?B?VzAvTkR3VTh5SVR3OTFTaFpGTEowd25UbDJTRWNRTVByOTFONGxnYUlyUTF1?=
 =?utf-8?B?Ri84c1ExT0Z0cnQzWnVwQVRHY3RFZ0plSDdPUmd1dEpyanJxVWloMERDbGNE?=
 =?utf-8?B?ZWVxWG1tU3hRdGZ4c0JmcCt4MS9FUFVJbG5xWUVMalhjTFNNTWZwRmEzR0l0?=
 =?utf-8?B?Zk85WHNnRUpYU3hkWnowKzI1SzFPeU5ua1l4Vm9CVEEzb0lYdlZwbmZHbGRQ?=
 =?utf-8?B?MHZjVS9IaXhQY2tLSVVTNWtXOHhBL3pQQ00wYTgzTmJkdmNmZk9LNkp6V01R?=
 =?utf-8?B?UTE2aGs1bHA2QWEzSjErNFlCTkZpcERnVkFtMDA0V2c1MFR5ZzFybWRSYlpu?=
 =?utf-8?B?R1F5bGhTaytUOVpuNWRwaTJhTFZZeGVPU0ZLSDdveEM3VmhDdnlIZDRKYU1x?=
 =?utf-8?B?R2pQZEJtK01oUUllZkMrdHRxN0Q2Q0k0ZXZTYXR0UzlnbVpZTHZ6cVAzY04z?=
 =?utf-8?B?c2x0cnN3Q0lCcEhXcHVRTy95V24wK1luUC9paTF0bTdkalUva21Pb0ZYT0lx?=
 =?utf-8?B?VGhEcDlxR0c3NUk4dWN3c1o5aDlrWTNiSktsRVRlUW45cGxDbzBEZm9DNTZY?=
 =?utf-8?B?aEhiZnpZemFTeWhPdlhiL3NGMzBtc0RIeEJQK2wxcXNVTFFIRDUyODkvR0Ja?=
 =?utf-8?B?K0VWNFJQbndYd0pMMC90QjlXQXo1RnExeDdHUllmNVBSNkVDRHhiU1RObkho?=
 =?utf-8?B?MVZaZzdaYjhSa3FPVE9VbWdIQjJWWTJuT1ZlVFhnajVHS2N4Z21hRy9FUFJO?=
 =?utf-8?B?VVo5eVNVbjV5L1kxQ3hZeFJ3eEhMNzRUU1NtTkxNOG5jaDdwM3liUlNsMmZU?=
 =?utf-8?B?MGtYVndBT0tkZDRFMmgxd2lNOTg0a0kzelVISko5cVFseEd1YStLbXpBZG1q?=
 =?utf-8?B?OXZKbG5MTW0rOG9mR25pUGs1YVdDMTF2TGVtaDJFU3Nnek9hZlYzelo1Y1I1?=
 =?utf-8?B?TEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ddf674-901d-4b8f-3dc4-08da6f44d831
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 20:24:30.3317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhgzSI3s5SxIWhlHokV7AG5py5yo8pJK69Ng11xspIGv77dfpPjWYHdHBTkjE7FyqTS04CMVjQEWx+UKHk4Z4fMqvntKbrW01qURZNEH8+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5056
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207260079
X-Proofpoint-ORIG-GUID: bAVgfSF4lAT_ycLnjGyw7qud42oPAY8_
X-Proofpoint-GUID: bAVgfSF4lAT_ycLnjGyw7qud42oPAY8_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 10:25 AM, Dmitry Bogdanov wrote:
> This patchset adds few improvements of iSCSI target that mostly
> required by tests in Window HLK.
> 
> Dmitry Bogdanov (4):
>   scsi: target: iscsi: add support extended CDB AHS
>   scsi: target: iscsi: support base64 in CHAP
>   target: iscsi: allow negotiate AuthMethod=None
>   target: iscsi: not require target authentication
> 
>  drivers/target/iscsi/iscsi_target.c       |  55 +++++++++-
>  drivers/target/iscsi/iscsi_target_auth.c  | 122 +++++++++++++++++-----
>  drivers/target/iscsi/iscsi_target_login.c |  13 +++
>  drivers/target/iscsi/iscsi_target_nego.c  |  15 +--
>  drivers/target/iscsi/iscsi_target_nego.h  |   3 +-
>  5 files changed, 173 insertions(+), 35 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
