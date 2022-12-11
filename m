Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E0CC4167B
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Dec 2022 01:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLKBit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Dec 2022 20:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLKBir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Dec 2022 20:38:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69FA13DCB;
        Sat, 10 Dec 2022 17:38:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BB1PXnR021296;
        Sun, 11 Dec 2022 01:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SDVJt8V9m1cF/eY9kfyPHNQE01xrlDqtWTTzjyP6yck=;
 b=ziwtBl5JYbClHdLPIBdlCW/OdrOXbZKKWVwK8blzP2FxufSD8aPhdvwzCvea4fBBM4cU
 sXk83f0Sp6YRUjBIquX1KoPLHnQWDb4CPgpYBQc7Aovh1o/22GpXcEEDaAC1O/GBhGff
 6lfZG9fwT5UqAxEWmww0mK+/BwazJm69teqk/QBF5z90qSIItiDsC9JiqukNm8XVqVGp
 y/W6rEojR0NA5ry7ksI0ReWdZIE5pUk/7PH2WgKXW842t3+XED6VOnPu2Z6AL9owJKhp
 7wPCW3xdxvSK/pDbPdhR5FJImfi1DyM3GKLNLdSAOLEsDXuQrnYSg3S9ZXfB9o9ANjJA 7A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj090ssf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Dec 2022 01:38:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BAN4tDM011597;
        Sun, 11 Dec 2022 01:38:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj8g18n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Dec 2022 01:38:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jn73PVglqOmep3HeEVOjvteez/9uXpzvJrhfMgNjckxT0a2WLnVJ2MVcrs7QxlvhaShNZHITgNxZmFtYFmZAoRGKr4eAiuKbwYfIYQXRKTkP1BstJmPV7y7b6kSJJELKbUQIEnepFulyVwnB37/1Yg3qtCmHEc38YmYYmx9X+DC8Gsxeu/QXJTHbpI2+Yli79uH9XU0yXuGW5mXCQ5I4q8PUU8gJRrRTHbQ44WkHx8jSu6AqMiYVoHrTFuyAQBg7IeiLKDA03M0majCppiDeqYJXutL0c/YlE01JP6Wt8398KXNDZbdgcdA8DRtd0g/RSHlKRYA3VxYbtJEYcAmdMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDVJt8V9m1cF/eY9kfyPHNQE01xrlDqtWTTzjyP6yck=;
 b=l4yILVWul0OA9qjybSWnFQrk5eKLAstCxLM994kmv46oZScGNjuGSkWq/L7qSjJrc/JIMfdPxLof3nNqgG+dJNx78KBuRtcLKGs00nAyQX24LSb8+zEJT3y1nwEOAGBdoY/OujijWW0zZh1XQIC3Yu0WTd2AgGAk5bFMLk0wkRCSlc5Pr808T+gucNv5zVpPRTpSUSHIUIl9GtAt7vQIFmty3J5QPiQ+JYnGYZucShvruMR4N2sBtxXzp5UMqRGwpsU8wUT8xQOrJgSyzfbbJi+UK2p9OQng+vYHGeeq9BVWzbYa1F6crpk/I4EDSi4jeLQGV79cxVS8EV8XmqTBaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDVJt8V9m1cF/eY9kfyPHNQE01xrlDqtWTTzjyP6yck=;
 b=achfP3LC9px8NXdbIlegYYwll6IAFTLgu2xFe1csP3dJ2SzVJNMqYyB0N4cktOpi/XWeKhvP+NdYd/IIOd1k6nI3UBp8bvRDBfp/wSSjX2pavgYD90F9LZ+sBotRkL4b9miFcqAYt/wrmwOph8jBo2iC1sDV0ShmrGjSGejD0+w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY8PR10MB7219.namprd10.prod.outlook.com (2603:10b6:930:77::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Sun, 11 Dec 2022 01:38:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 01:38:41 +0000
Message-ID: <785b5eab-8e2c-b5c3-e710-d16abe2a2154@oracle.com>
Date:   Sat, 10 Dec 2022 19:38:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 5/7] scsi: target: iscsit/isert: stop/wait on cmds during
 conn close
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-6-michael.christie@oracle.com>
 <20221209123202.GD15327@yadro.com>
 <5282eea8-6648-4573-057b-7350955b2368@oracle.com>
In-Reply-To: <5282eea8-6648-4573-057b-7350955b2368@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0328.namprd03.prod.outlook.com
 (2603:10b6:610:118::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY8PR10MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: 498f7ff0-ec94-430d-b9fe-08dadb186ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u1ILjRCDP8Vx3xC/hxHqAtY+/3c8+9bIBZkHAvXqTm0O5W6hgihlXth2sLmDS2cLVLWMwikzLF6qrDSV0bDJhbsvCbAxhB3hW+JGf0tqm1gVFUursnP8QgRLMWeliWz7DR6IA528+T55EpuORZKNkxSXm9yiXA0BzwFfvf7IuE1sCbtx1Qvno0H5FSo7wD2mCWaZIkM90AdYrrkLijaNtbzgfQYdnZRqxNUX4BIobzOJjoRfArzCWA1YUH1JwPQQ3aUv5q1ZSmZZ96uaMHeBjWoUBjmfb7aPHpwaeePMrJn4+6U2z1OQXamC60cTqYKUF/QVwfMPfOv9WtA5JCf97q+25Mj2chSeXwLx/IqFKEytnNSYkRsyMLZUb9bjeP+x+BspMVZQkPYVtVi5p5yjV1V5ZniQlGtjJfD8JFh/xpWWjGzLRPlRe4zBi/lFA+WehBGScAvK5A4wiV6g3CvYNckKyXYj8kyeRSofHrrDatFSJS1Y1UWbOOeEjKKhu6AjOU01ASBVq+laNhdUHinmFssbIYqZrH4AtpGAK3150PzGPlIs9U7I4HLXuFj5Vz+Am6f4A4kh3IV8+df5qJM97YkFpvXWVYHutmyMTfBSCE2trYriNkxxJXZ9IDTaOAm+aW3vtoycsEwyCr7RCFv8+xg0KPkTYzKl5IfJxg/5GjKT3lHs8kvedWyqqmpX6QqWrwCNQ4lvVTtPtJ/p6TfpXXUXFateDBIIWk4OHq+eh8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199015)(36756003)(41300700001)(8936002)(6486002)(478600001)(38100700002)(31696002)(86362001)(5660300002)(2616005)(53546011)(31686004)(316002)(6916009)(66946007)(66556008)(4326008)(8676002)(66476007)(186003)(6512007)(6506007)(83380400001)(26005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUs5ZzRuN2NMTXVyTFlkemg3elNRcE9pckRYa3V4Ujl4Q1V0WXFlakNESUkx?=
 =?utf-8?B?UUNnMDNxOWRGRDVTRTl0Yjc1a3FQSmJqVXZtR3JSVW1QME5YeVdLSm04bjhj?=
 =?utf-8?B?M09QYU9jRVJBallsemxLUUdtcGd6bU9TSCtZL1ExRkdLSVMvTmM4MVhveElh?=
 =?utf-8?B?MUQ3cEtaazRGeGxNTHUydVBXbDRHbEJzdmx3WGdMejVpK2N1VHBNV0hqenZs?=
 =?utf-8?B?a2xFS081R0Znb1pncXhNQ3BuZ3Y0YnpPenpQNjU5aVZub1FML3BDNDkyZ3VU?=
 =?utf-8?B?ZTNxblZpOFRvTU5GcWVqZjAzdnVMUG9NVUY5d1p5dHVJbUtaWGhpc0RlcG5h?=
 =?utf-8?B?RFplWnNHOXBxMUd3eVl6U3U4WVg0OE5CajVBbEVXWVZ3KzgzMWR4NzVXOHNH?=
 =?utf-8?B?UnJYTDZRSmg3Q3lpSUFOaC93bjYwQ0dxUkUxUlNuMUN5L2g1U0owa3BGZHRC?=
 =?utf-8?B?ZU5wNGpXeStSSlk4QzE1TmhKYzlXaU9RUjRIdUQyaHJMU2p2eTV5T0N2TWcx?=
 =?utf-8?B?RTd2Smx6QTQ0NEFqdGE1TTFyKzFzeFFQSm44WkVYNFYwM1V4MHNYS3dOcVFM?=
 =?utf-8?B?WEtESWZvWGJsbnVQSEFkaktMRkg2V2pqeXZoRnA4bUJ1alA5Y05ZNVJCUG1L?=
 =?utf-8?B?YUtXSmlEc29ramVuK001UGwvNUtQUTJhVU1Ra3MzWU44WnNmNVBXMFJEd1VQ?=
 =?utf-8?B?OHBPZWZEaHR5WjNQUCtCR2YvY3VhZk1ObnRBS0wwSDlVL2QxS2pGMHcvUDRi?=
 =?utf-8?B?MnlKMHlsZGxzYStDMkVXblZ2ZHo0QmlQS0s4WC9YYW43WjFhYVArOTdJa1hY?=
 =?utf-8?B?TDVzVTcxQVc2UkNNMm1RSmxYMXJ4RCtBeXlDcExoc3RMOFIwdVlIQ04wZUcx?=
 =?utf-8?B?RDIzSWMvbkNWZE5hc09rZEtmUkE4aWhBaGZOc2RZTXczUlNZUGNxUGhBb2p4?=
 =?utf-8?B?OUtmRUc0bjFZWXJjcXRDRGI0OHJQZXJrTkFMRVBkTm8zTzJ4UUFYMWh1SWVv?=
 =?utf-8?B?UXpQTWMweWJENEtKN1V2VnBqaklZWnFCWWpjVzhYSXNnVUJjL2lPalNmYlcv?=
 =?utf-8?B?ZmdMNHVScjg3WjJZNEJ6SGw5YTJWZjRQbFE5ZGdDTDRub2E1TjF5RHVVMVZN?=
 =?utf-8?B?djhsTE0zUldjUHAyelh5aE55Vll4WFhHYmdkRExjdHZ1eXJnRkxYSHVHQ0tX?=
 =?utf-8?B?VkJLMnFFeU5MdFczQ0dwS2dVU3BRdlJUMzVWZEErbGJwRzRhMWlwTlo4c05i?=
 =?utf-8?B?ajYweFJrdG1QVHk0N1oxN1diU0JLa2lncHdxWGZ4MDcrQTdZdmJSWnNSOGZq?=
 =?utf-8?B?RUw3K1JHUk94VDZueldrOFVYanFmeE9PUDlWMmFGSElTbEJuamp6VUo2SjJO?=
 =?utf-8?B?U2loakVmNitOVm85ZldHNG9nbEdxSjIwR1BlMXdxZWwvS1dhUUhVNlo3ZHlw?=
 =?utf-8?B?QnlCY2xIbDZLdUthMjIwZ2RKKzNQdCtWQXZpcDh3bklPdkIraFNUZlM3bHB0?=
 =?utf-8?B?Zlg1UWFJRlBJd0hvMHpmRStRdnN0djZ3eStKMERRV1l4ZWpRQTduTGhETTZK?=
 =?utf-8?B?RHp3aVJTbjdCNGZ1aUYyZEhycE5tcUV3OWtrMWpURDJnR3J4bWRGY0hHVy9Y?=
 =?utf-8?B?R2xGTTIxSzVzWDFPaEQ3UlRJL0prOG9nNExCT1F6YmRLdktLaHlobFhKWHNt?=
 =?utf-8?B?dVpGM2QyeGR2SHY1U0MvRkI3Sk1mWkdnNXRlMjhwdnZwVnVmN3JmcVAxTWU5?=
 =?utf-8?B?UWVJK3MrS1JmY3JFUjF1YlVqbWY0UStOQzQrcm4rNWtPU09idnVJemlqYkZL?=
 =?utf-8?B?SDhZL3ZnZEV2VVA1aGFLR1ZXaUJIZTY5R0NkdlJwc21sUUUzMEQyRVBKWkVH?=
 =?utf-8?B?L1ZQejYvWGt5YXpGNnRzL3JkdVlXNkJGY2pNa3YrRGQ1cmtpNE5QNFp1YUQ0?=
 =?utf-8?B?bVJzNmFWb0kxdkl2THM3SDEydVpnOUo3WEhQZEVNRUs4ZmhtYWRhT2xPLytJ?=
 =?utf-8?B?ZkNRa3Z5WmtVNTIzU2c3N3U4YVdOaFl1TndUTTZrcWxYNjkzRUNZZnB3dmds?=
 =?utf-8?B?dVJVSlJMM0hjYXBNeFQ3RVRacVp5aXhlVHBkeXRnRFh3Q3Rsbk01ekE0dnBz?=
 =?utf-8?B?Y0dtVlJEdXlaaXNMSDd3SXJGdGlrR3h4a3pXTkorSXcxNG1UOG9zMzRLeUha?=
 =?utf-8?B?VUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 498f7ff0-ec94-430d-b9fe-08dadb186ef4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 01:38:41.4826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGDccMZMSjJGcgStBK//EekBniKXbvgO8j3LSmPIC++tXcMA6C1cDWN2GQjqJeUa1YMb9mrcGElLsxJ562Rz3N99KA9mjJyX8nHQMKfbolA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-10_10,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212110012
X-Proofpoint-ORIG-GUID: IWsnaGMyZ-wfYKPIfuZawEGyrX3cdwwZ
X-Proofpoint-GUID: IWsnaGMyZ-wfYKPIfuZawEGyrX3cdwwZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/10/22 12:48 PM, Mike Christie wrote:
> 
> When we do iscsit iscsit_release_commands_from_conn we are:
> 
> 1. Waiting on commands in the backend and LIO core.
> 2. Doing the last put on commands that have had queue_status called but
> we haven't freed the cmd because they haven't been ackd.
> 
> Are we hitting an issue with #2? We need a proper bug and analysis or we are
> just guessing and am going to mess up.
> 
> For example, for isert is the bug you are worried about that we have a missing
> isert_send_done/isert_completion_put call because we disconnected before the
> send callbacks could be done or because the ib layer won't call isert_send_done
> when it detects a failure?
I tested this and it's actually opposite and broken for a different reason :)

It looks like we will still call isert_send_done for the cases above so we are
ok there. The target_wait_for_cmds call will also sync us up those calls as
well. So if we move isert's target_wait_for_cmds we have to flush those calls
as well or add some more checks/refcounts or something.

It turns out instead of a hang there is use after free. We can race where
isert_put_unsol_pending_cmds does a isert_put_cmd but then isert_send_done
can be running and also does isert_completion_put -> isert_put_cmd, so we
hit a use after free due to the isert_put_unsol_pending_cmds calls freeing
the se_cmd.
