Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D362C10F1B
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Dec 2022 01:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLKBUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Dec 2022 20:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLKBUv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Dec 2022 20:20:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D7F10549;
        Sat, 10 Dec 2022 17:20:46 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BANdoNc025688;
        Sun, 11 Dec 2022 01:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=zZnpT4By82tN5evfraIBb0k2NIPt1m6sQNfjxqcuWdQ=;
 b=t3SKDrqVVvG2IzefLgJlFbqVOAO2udn4arwexwmGkyVVmxxQXaOG0m5XStMGirlK78Lf
 7dwpGqUQ9xAJ6EKK1dkWvcOec2OpGfBQ0kuqeptuynmMEN+6nKG2uiqTFGQQ0k1zOQSt
 XIwfsyil+4CLArYg1aBtt8swy0ygB17aeSb3nxDDiVRGHm58LHzi9dK2+Bz5uPgxnfY8
 rvBgs/Pz8favV7cijsVRO5DTYafoTZ6nsaEmt1ViJRPwgZI+RNohFzF2yyfHaflZKQEp
 fPEMXjbUBv0ehCPYaBKv185HlyuCTilt03c+cCiornWWNA6dPGULhwf665YF3pJV+PfL Ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcgw28t73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Dec 2022 01:20:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BAM9pPF019375;
        Sun, 11 Dec 2022 01:20:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj8nj9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Dec 2022 01:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgZORC6Pg1kELOXoqYyu1R2ZeZftxdcqeBrmi+LQySRCp46ZlrVLNn/+zSPz4/M662Akx/3mn2MABOEoLoPpA+XUpm7h8CNxIX6nFgUlLZsajcnvbXsLuVb3lgQIy7BQOUkRr7jOw7JwdE8JnPnJI9mNhIRucXSxXqZvfwyHVS5MlcDuC0CUXxO/MDp6/4wryuitihn4gUPs/hAFjmfVQ1iWBWD47MMV7AI3UT8LWQuy5c7krQb9/Kev3RJrJiWz2OlqYpnYh93Y2VmyAAs80idVlovksxLSjlRNyWaQc6ibggHh1sL4kZoNFkF7LoR4VvLsd5zNQY/kxT2Wz4EoUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZnpT4By82tN5evfraIBb0k2NIPt1m6sQNfjxqcuWdQ=;
 b=lec4b28tBAEUKzfe+9slnqhC1wNmLmqhRNbv79YAC9d/gERKbAUNqsS8EcsHkO63LUOjpFqgYgw6xnC/KAj4ENqCt1ToauuCUNAfnDhJdjtfiXngZbv0I9EJAfyitDEfiQUi3CFWf2FreLKaFRAbXQL3eQDFsXxXHeHevB7nTMZlLj/JFnU78T3C78Tf0hQh968UKOpk+Jy259f4VSAaYciPNKN1QDArK6roHLyjAuHO3dgEhdBvjdB9xlDl0NaccZXTRIWyA8ry224rsyo/AgLrySo1JcIw/WKTe5t40GDFOGlSNXYlUUksiJ8sXWc1VHLFmFOsE4aaFI1n7/iepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZnpT4By82tN5evfraIBb0k2NIPt1m6sQNfjxqcuWdQ=;
 b=f9RkS0RMhSDIhF1oORK8TO/3lJVnlYYrxJE8Z5jciir8e49NxF4Yl5O6Hk1gmpMCf7ZcfeCk9LKhmAKl55CUGemhzpxXOOdc1WJCa8twPxblcyNfxfInpALzrJPbTc+FSkrhoZqCXfoyt4/1x9g1po7iLyMwP3uOqiYYFdw7H2w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB6394.namprd10.prod.outlook.com (2603:10b6:303:1eb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Sun, 11 Dec 2022 01:20:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 01:20:42 +0000
Message-ID: <157ae074-b455-c604-2a5b-1b70ca9839ba@oracle.com>
Date:   Sat, 10 Dec 2022 19:20:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 5/7] scsi: target: iscsit/isert: stop/wait on cmds during
 conn close
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-6-michael.christie@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221208031002.106700-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:610:cc::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW4PR10MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: becec341-7859-44de-e0c6-08dadb15eb87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bh1QTGaahVqyeaWDQzxVrr6e2G/7azG+aMro1hMSfWRElOHyA/X2KsH9dB0FMVSMs3osADAlZ2ytfQzu7ioRD61vZ7GLsoXqMR2Bmi+1HsMv28vCzbbPbN/E/bqPMFFluPRKsGRTOvN0y0Epvz7LDc/vBhDFXEmN2JpX4aS4SSz7qa92+5Q0LgDSB//ROBTpHmgP2uaA8VebFG5DetT7MM5MFh+4rct3bm7WBmTHe+lSafltb2z4oVZRRQms0HjwT2Af365cLh1uz1AZzxU2WqCey1OHM9kTrqVAyzOpeGYGqO+qyXxpCVclNY6WzzEbzDno38I2iROM2yxPpHsoqJinxpaYB1IT0WcG/MJh43lDHrVvVBjtKtQYGOlVqpp6+2QgMtwACmctTsmhidppLEXKBVmiy+Z41tcS+m9QvB0xgF71LMeFRxvQmtUCFOWQQ94GESaur3CooFUwJkeKKqOe64nyx36fVTGhYobe5bG9kcDT9vedtrbKaVgsveBaS9MU01xjU5RcTZvJhgYDc1SRGJcgngOiVQoUbaeiwB5+aio1YMyf90JohUmH83Jdjx1GShUJt1krQiJXmpRMGv7r/wfklJwTOOc+V6uQSWhoOB9AJNdq6jxa2ZADs/uDXALdbny9lMGx6/sebFfsFeIwDKc4x4omEVN93bAuDg+jR5MWSd4cUk9/o+a8c9udJou1nSt9JnzMKReClJBItePJXEdwG58po16djmiLz2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(316002)(36756003)(38100700002)(4744005)(8936002)(478600001)(6486002)(6506007)(53546011)(6512007)(26005)(2616005)(86362001)(186003)(2906002)(31696002)(31686004)(41300700001)(8676002)(66946007)(83380400001)(66476007)(66556008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWowOHpRWUorY1l6NThKaUFBZnBqK1MvMlQzQXZzR0hBZEtJaUM0RnArZlJu?=
 =?utf-8?B?M3RDK0RncUxlZk1XZDdudGtzZk5MNDFzQUlrZUpvdHE1Y3B6TllWSE9adUsy?=
 =?utf-8?B?aHlnWC9Cb0t2T0M1MkJ4RDZTbzBXTDZoWWdTYWt3M0VMQU1xUThMQ1pVNFhW?=
 =?utf-8?B?V2VhZkJpV0FwVEtSOVIzMjBpd0tYLzlsWXZIeXdsUjdtc0FJbzJGMVBJNE96?=
 =?utf-8?B?VmV0T3B6V0t1SjZsN3d4UXlHclVTMHovbmVUTWxLcXc5dmVqdUFxeG1IbVk2?=
 =?utf-8?B?MU1YVklKTjNJNm10cXZMbThnL1F2K3NSdHBjbDlIT3E4SWltbWVkYnZjenJy?=
 =?utf-8?B?cjJCU1l5emtwa1BBWXlEYUhLUHduM3JUUDREa20zZHRPTXZ4a1lTTFNLU3Zp?=
 =?utf-8?B?czlSa3NlT1dUMHBjWGEzbnBSU21HVTlRZWsyMXNLQnhZenRaS0RDOUtXakh3?=
 =?utf-8?B?MWNSTW8rMkVJODI0Vm9uME9CODJOR1VpaWNMSkFrMmtQdklURVpsWnpKYnBL?=
 =?utf-8?B?YkU1SEdZckM3Y0tBV01Fa3lkczVKNGQrTnQxVnVUclpTZnVXaXgxRWRDMlBV?=
 =?utf-8?B?QzRKTHZ5OCtodmNuNnRldzBqSFBaVXFqMTlybkJJdGh5aGc4M1Q1VkF6SU9Y?=
 =?utf-8?B?TTBGZEJMSVNxOFgzaEZKekZXMTdrNnduYlFKdTN0a0NWVjIwd251di9PRVFF?=
 =?utf-8?B?Zm1xWTJ0WHppR092V1FPdCtNajFTQVUzUGxHRjR3VEwrL0JRclF2OWxIblU1?=
 =?utf-8?B?MWVHK0MzL1gyY2VjWXJZVFFsRDloTTlydjlPVTFqdFRjcUhiQkVjTE4xV2h5?=
 =?utf-8?B?akt1T0RZWjFZdktpSVgzYmhmWjFXSkdCQmJZRHZ3VVlseng4cGJOeWxXcjhY?=
 =?utf-8?B?RDd2dzFsZFhxWWE0ODV6VFY2ZEN0SDJtWGhubDlmQ1g5SlFNUXZ0NXkzNnhL?=
 =?utf-8?B?b1prVnE1YXNJU0pydVpkN0I5MHNoZ1hLMzRERWFsZGd1cG16NERNQWdEOGN2?=
 =?utf-8?B?TVh4QWVqeHJpRDE4dmNiNkFhbjVBNDZyRUFhTmpwRGZoYndrRW5DdUlHRm50?=
 =?utf-8?B?SHdCSE9tYnNQOVY1SmhTYmN4NnR1RWlOeTdsK2YzakNjbTBzc3NpVGcvZXp4?=
 =?utf-8?B?OENCdUZOeDBpejFpOWpnM05JUFZQVk9ibS92K05DWTBEd2hOMXBub3FZSjJV?=
 =?utf-8?B?SjNXU1ZaMmt1MXpmVG1TNHBHS3FhZURydzlET2hhbUZZQ3hORDd2RUdTR09O?=
 =?utf-8?B?c0lhTWxXVVRFZENWT2NsNG9vdHZiNFMxVU5zM1pOakZmSWRVUjA5b1A2aEhi?=
 =?utf-8?B?cVQ3cFRnV1psTXRZeFF5ZGRpVldEV2lCSUhESTNqb2ZyTkxSTGZDbnFqZEpG?=
 =?utf-8?B?N0xnSWRROUErMlptR1VkMnJobEErdXZweXBKd2NvSGtnb1hKVko3aFZYbmVn?=
 =?utf-8?B?WDRkbmNJaWxtTFVidFpTRkZMc1FUdWNNeFllaC81ZXhCY0dPM1lpcHhCZVp4?=
 =?utf-8?B?UXNRN0dsNE42K21STmg0Y1RJbTZ1bDJyRW9nK3d4Y1pQL3A3WEhwK3VYTmt4?=
 =?utf-8?B?REw5Y2pBSDNoQ09ocDlKa2s1Q2MraE5sMDhWdDhsRGRlcXRraFZuYklnb09k?=
 =?utf-8?B?NXhQam8xSzFvZE1PVG9LUU95VzR5L0NCalhWNVFYaUg4aDVUVld0aWZMcndU?=
 =?utf-8?B?SXNuTVpvMkVnbjkrVjFQVGVjK0phcVZBUmJzR2h3KzN5SGsyb0JvaU5GVXEy?=
 =?utf-8?B?U21GbGZ6cVJSYWgxdlNSQnFHSDFCQ3RodndPOWgwNWEyaEFXVlY5R2Jza3Ev?=
 =?utf-8?B?T1Z4ZllWMHFFMU1jcDJGWHhuOWxScjE2bWNNMktRRDh6RmNpZVg5bFc5Skpu?=
 =?utf-8?B?MnhicitTZ1hpSTl0dGhwSlBQQlNZTmhJbkpUaXVyUi9vb0lhOUlralVXR0xE?=
 =?utf-8?B?bHdLMklRN0YwMEc0THpYSWJreHR3Qk0vclVSbFBRS1RyWFVaYVdBeGVRekxk?=
 =?utf-8?B?MFo0TDVoYndoSzdUR1dBQXhqeXExOVRhS3F1TEFkT0luMVQzRDUrMXNvc0Ni?=
 =?utf-8?B?VzM4RkExcTJZY09qbGczNUNWcmUvbTF5RDRYekVvYzBEWktLaUJhYlBYTDZM?=
 =?utf-8?B?QWxUbGw4ME1OTUpXY1k5UFc3WFZMdWg3djNseEVIQzI2K2tHbGNEcWFCYUpC?=
 =?utf-8?B?U1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: becec341-7859-44de-e0c6-08dadb15eb87
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 01:20:42.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qys/bryrhpK3G4msYHIO8c3wVopsbAA6d6NBQ26FQSrBknWaE2ps+ZDzen02iXFhcQmjKq2wwqt693G8s+leEQR1ReFfqeHMevBd/9yqUwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6394
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-10_10,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212110009
X-Proofpoint-ORIG-GUID: AqRQHsKYmHaNScF6out8UFU0Qgty_ZEV
X-Proofpoint-GUID: AqRQHsKYmHaNScF6out8UFU0Qgty_ZEV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/7/22 9:10 PM, Mike Christie wrote:
>  static void iscsit_stop_timers_for_cmds(
> @@ -4304,6 +4313,8 @@ int iscsit_close_connection(
>  	iscsit_stop_nopin_response_timer(conn);
>  	iscsit_stop_nopin_timer(conn);
>  
> +	target_stop_cmd_counter(conn->cmd_cnt);
> +
>  	if (conn->conn_transport->iscsit_wait_conn)
>  		conn->conn_transport->iscsit_wait_conn(conn);
>  

Maurizo, don't test these patches. There is a bug where we have
a missing target_stop_cmd_counter. If the login fails then we
don't go through this path and will not do a stop.

I'll send a updated patchset later.

