Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDBDC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 19:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiJSTxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJSTxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 15:53:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABC81A20BA
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 12:53:07 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JIOoPh011504;
        Wed, 19 Oct 2022 19:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vrabkVt8w1ZM1jaB46YO47AyC1eZRG3FAY7VxqPKxHM=;
 b=3HJrpGDmYCIBb9J2qx2cXGXn/usmMZwieI3ANZyHHjrh+2Ysan9JfrNS5tgiCXaAlbcD
 yyPByzOx8Wh4h9JQXRdqML3vBK1z41xP6pD5xvNcNJGycxzp2Sjaa0sRlly6wlP4uvU0
 8I6HW5iNpa9OhTcCDbmnjyuuVppuR7bVysw9726HivYWABpuTKs2N4HIsl2RAznUfdit
 j0KYMPzOEL2OHJqn0a1GfWDJgKKxXU+R4lj881VXK1FYb+dskYgp++h87mGIjeaQUC+U
 Z21l98udI3BpZf8JTbfhcOboF6t9PkH47n9TVE1aR3XOwPo2ZA28MNNHD9W1NFjlAxAq 0w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtkppf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 19:52:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29JHo6Os002775;
        Wed, 19 Oct 2022 19:52:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hthvvbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 19:52:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9SU+V7ySGKYceqcXN0g3EgWlVl5S6M8BSU2bkolaevEcqs3bqVgHSEPwGAX9/IM+sI6KcxMrJhGPNwr6TTgLJVktbUMsbGA4NEoOrKvYKvL1/KTyT/Ed6hvbPnUww4FKQ/t8uTqb4y0I52Ina0hWGFRFGEZliqKtq8FPHjEDbc0boJwv8vhSjEh7pfKEj0Cls0ra1tRaGqtKJdC1aEBsC6xaQuwGyPUafj9kRgi/XmzcCG3oSW8H+D6rQS0NKg/kjlgHg1TuF0I3q7mtAIQJWXNY6gwTg1GhZv3Eyp44A2HlV/VKW0QukevYhORNbOaTsK+qgQWx1d/dCmpyH1Nvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrabkVt8w1ZM1jaB46YO47AyC1eZRG3FAY7VxqPKxHM=;
 b=GbxrmhcWjgYklNYmRlqtoUx8fT/89sTnHH8rbgBe7e7wCGTjKzmTGRmlzVSDLBiN1eCk+uW6mRub/bcDWDxEYf1YEzbGz/g+gQm36xxt8qFKvTlmEMQv/1LGHodWXezeWLy2abe9WpzPXaNQB8ibpv1rvmTaSW6zJPlm33NqbZOYb/XRx9E1UOkhKTcudpmKSJh7k/9QPvSgDS9SACYd00jQy9ObTokN2tw7vWx9mUR3S/6b9v4fLmxY4fab6m1TMeaUeDrYPIprBVMMXong/h/VfawWJcpAt77gj9Gb5TQUG50GXxzS++PkbDkAtv3rYMGrisDQZc1LANQ3HK9naw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrabkVt8w1ZM1jaB46YO47AyC1eZRG3FAY7VxqPKxHM=;
 b=lPTRlLPcCV/Nj3J5kyW/k5iuAQx6RcjEiX6Oj5y1D0bIrz6SmZ4WMyyo7mCadlzyhGRASk9LT3VODBfnjayV0TnRix2iQQDBb74Il0qFwiuR7LZXvAmzG/EiUXv3eQtfjlHH9fJnP9Oa3cICXVkzxQXehRol/2tvBsT+omahrIA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 19:52:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 19:52:43 +0000
Message-ID: <b4cb1875-19f4-c7b0-a1d3-4f41418e44fe@oracle.com>
Date:   Wed, 19 Oct 2022 14:52:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4 03/10] scsi: core: Support failing requests while
 recovering
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-4-bvanassche@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221018202958.1902564-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5030:EE_
X-MS-Office365-Filtering-Correlation-Id: c662061d-6c60-46f9-4073-08dab20b7c5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETz5oy2c86Fa8ifqLUZGuqSB8VfL1oEn7LkRpRW/Kk8vbnmEyMhkUvxFza8Vc8Dhtuwc0KLT6OnkPCzduHzGRJ5xD69jMtV56zALll4Mabc6tMds/to7UxpxUVAABWHlj8ZuRoZ1ozPnr6DVtGsDnPZI+clJhQrd5ucJWJAsyP9aXGLTt9tw8lbxVNbWSCWtEiRRCYlQizOy25QZJsnXkgwTUotzMGwR8huD7/mPDsIuc+NC09YZkjk2J5SNcMeaGY1Ch2/m6GCxQ+0ydkx8+N8G8Yo3eSn5SzcDXtde1k4yPe2oCtTx21H8OtB/zALuEefYRZqdek9tO6MxfB7HRG+cyGeLZ4XHuYh7XrAI3BaopbjxSwgUoiEVxLcx2NwjppVIiv3TBYq1rqDkTkgvPH25dTGWFfuUHLUcsXDvspzT7RlCeO583MqYVhszayTud86pKcHqtfbtSCtzhTxBdfuPHRv7UH1+wihYleImdBFiKb7anyI8eK0JLgDUFgSmaUfeDTx+r7wT4buZfTzHfZoC3E2/q/tskkT1nMF5KmNd3DK+7322FgAfyS+1GAhAT5OyoBvfHia2GTjF2Von5jWA8eOeTTl1cW+eBN6ub+gtx3ytugcyNijcxYv2SHnuqp+kuUu1lDeAtOJ5iCHNjTHv8UyaxBs0efBGDmLC2OTx11zOaY3i53u1+bOFtYch1z5xPJoI67On/KY9PBn4M0lQ1AmONDwsBQhPcxOna5nN54iAHSJ1xXiNj/uWcILCduDAXycQKR3qA2GWn4VwF2TkZGcsCHcH2aMANg6SjS8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(186003)(38100700002)(2906002)(2616005)(6486002)(478600001)(54906003)(6636002)(4326008)(66476007)(86362001)(66946007)(8676002)(66556008)(110136005)(8936002)(31686004)(6506007)(6512007)(36756003)(26005)(53546011)(83380400001)(41300700001)(31696002)(316002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlZaVnpvWHB1T3pydy85c2lqZkVZY2RFc1ZMS2plS1FuSEcrV05OM25sY2dQ?=
 =?utf-8?B?OFJObG9TcVhUcnJVZkQyT0MvZUVPd25YOVRweFk2ZDMwazFyRVJDUHJxMnR4?=
 =?utf-8?B?ZXlLcTRqaUR5OTlQQnZoNXA0eFdQUXpHN1ZpWVpKUEZhV0wvd3NmWno4RXk3?=
 =?utf-8?B?NEZXS1BuWmlCRlFwSlZHb2M3QjlHMlRpYUc1NWN4anhiZ0pDVWFkVmtuWmc1?=
 =?utf-8?B?cldHMzE5bFZPaTc4L0JzRFNLcjlpRzBZdGxGSllzUktNZUtZOEViSXNXa0Vx?=
 =?utf-8?B?QnFPQVNuQTRIN2NSU2NUakVTekpXb0VjOUpKVm8za1NQcFpXSFl2dUwwRlFv?=
 =?utf-8?B?SWNCTjJJN05ENUk4cldzVVAzR1d2UXRRMXhLZmNwUDdUZzNJUDJtNEh0SEJU?=
 =?utf-8?B?OUNNQVVuY2xlR3VpTUx2bWhOL1BYTWtpRXJGc2lONzl4R3NKUTR5bUd0VHFF?=
 =?utf-8?B?ZDdCL0lJTHNaK1h1RXkvUVBhSXdMTmVQdXNVUDU2WEpuaUZjYXJKY0dVWTN2?=
 =?utf-8?B?dXJIUFN4V1hwd2E2TlNMaXlYRE9LV0N4Z2lLYnVteGdrREN6MXN1S3NzVGlm?=
 =?utf-8?B?REw5aFVqempPNWFsYVBCbzZhWC9Za29oTmcxaTNmRTZrZCsrRFh1c3FDeXd4?=
 =?utf-8?B?MXRPQlkyZVovaytiWnVzYll6VWNYOFZzQUpKU2lOcUcwK0JSMXVWajI0N1lh?=
 =?utf-8?B?KzVSMjZhTTNYbkxzYklzaEUrTDZnelRmaitYMlF2cm8wM1lwWlJxdnMwbEdQ?=
 =?utf-8?B?QWw4WlZPdzBYcFFZRjAwMkJCUGVheTgwZXcxZHZtZGdGU1IxbkRYUlhxdFB0?=
 =?utf-8?B?OXBZTFZNRDkxdVVaS3NGY1N0VVRXR1J4ejhTYXovdXFjK1I1ZitaY3U3akty?=
 =?utf-8?B?OUYxcEhldExhT0N6RGlLUHJlMzFWT1poVlYyZWJXM29ROUp0a2xCRlliKzV0?=
 =?utf-8?B?bEQ2NENEWU5taC9UOWN0Y1p1SEdydGVjZFZGS0ZrS2U1QTg0UzZrTWNNZG9q?=
 =?utf-8?B?NVFqNnFKUm45TDBrMUk1OFJhS0RyQUtZOFVyUk5Icks1ZFZXK3JCUGlDQTdp?=
 =?utf-8?B?aFpVK25XVCsrZXhld1JYQmV2aVlHaFZnK2MrL0x2TkI5dFgrVS8zYnJzaE8z?=
 =?utf-8?B?eHkvTS94K3FydlM2KzIwVVRFNmo3SW01eHhKTW4yYkZPSE1Vb3FUbFBrcGZQ?=
 =?utf-8?B?dWlZU2h2bXByTyswdGFUb3Q3S3BJQ1JGSXUyK1VrcCs0WW1LZzZWUUlXMTJu?=
 =?utf-8?B?d0RWWE1VWCtQQ24rYUxLWW9XaUcxMnVrNU1JVGZhN052YUgyTDJqOUZ5TlJH?=
 =?utf-8?B?ZGJIbC82UW9DME1mekQ2bEtZNEVCVzBuWERDN0dlRjJ3dlR3OHF5bVhqeStr?=
 =?utf-8?B?VzdTbWllcUZoajdoSC9tbS8ydGRSd1pNTEV6b3d5Q3pqSHlQa04wdVUwODVa?=
 =?utf-8?B?TFhmRndwOG9DZTZHMTByYnJ3dzNicUZRdGdaYWZvS3FjeHAyTjZEbWVVTHA0?=
 =?utf-8?B?d3RxL3NMQW1rUzR0aXo0ZjF6cDdmZXFrUzVKOVVEdlhrN0hRVHZKSjFQMGVi?=
 =?utf-8?B?R1FEWEhKZmJ5em94OUpyNUhJZ2Z1ZXk1dHBCSGo0ZExmTEpRYStZTG9abDUy?=
 =?utf-8?B?L1JDWTBUUUdwVzFEdHRKM1huRGVYR1BtZE03UGZabGpIb1FCS1JSbzEwSlo2?=
 =?utf-8?B?UmM0SUN1SmxPQlc5WFNkb1dvdnFwaVFtZGVpMWY5TG5qYTA0Y2d6OHJnZHJ5?=
 =?utf-8?B?S2lHTHRiRWdaT3dpcUE3T1R1cDVXQ0R4T0YxU25jMHZVSUZGS0p3bVdVWmlO?=
 =?utf-8?B?UTYvSnBCdzc1V3N6NHM0aDI3QUN6VFVDdndiaDhGQXdJbXF0clNPY0pneGh2?=
 =?utf-8?B?NG0wcVdrQ0pqd042VWxLcnBQVmhrNDFTZGdLTW5LNjF4YlRvV3VPMU1oWDRI?=
 =?utf-8?B?WmxlTi9NTmxodUdvM3NWSWowU0Q3Q3NMaUI4OUtPVFFSUUtYYWlXU0FsMU5W?=
 =?utf-8?B?cnJWY3F6VFJLWnRycEpIMlhZTysrTTkyaTRiOUlTYVluMm5ZQXR5NjdCWjRi?=
 =?utf-8?B?NzFqN2JnT1ZDSDZvaXl2ZmQrUWY4b2FhM0g4SGdJbVNuTkl4QTRsaFBGRUNa?=
 =?utf-8?B?akZSWlZRTDBVbDBXNWY1UURoeGtza1U2U0pIeDl0ZzU1Y1R0R2J4eDFXUmM3?=
 =?utf-8?B?ZlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c662061d-6c60-46f9-4073-08dab20b7c5d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 19:52:43.0185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vqe0ZWGxE+rmlrHYJPNPc7V47poqzpM9mdh+e2o9alQ6EbEkdaAHJgQuI9ThKQJXHFxUhvbLa1p1kOxC/YoZ3NAIw7fXWN4opEuX74e9oNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_11,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190111
X-Proofpoint-ORIG-GUID: fx_j9VFsQODnOcChvgsz-4xraAb6FJha
X-Proofpoint-GUID: fx_j9VFsQODnOcChvgsz-4xraAb6FJha
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/22 3:29 PM, Bart Van Assche wrote:
> The current behavior for SCSI commands submitted while error recovery
> is ongoing is to retry command submission after error recovery has
> finished. See also the scsi_host_in_recovery() check in
> scsi_host_queue_ready(). Add support for failing SCSI commands while
> host recovery is in progress. This functionality will be used to fix a
> deadlock in the UFS driver.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c  | 8 +++++---
>  include/scsi/scsi_cmnd.h | 3 ++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fa96d3cfdfa3..ec890865abae 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1341,9 +1341,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  				   struct scsi_device *sdev,
>  				   struct scsi_cmnd *cmd)
>  {
> -	if (scsi_host_in_recovery(shost))
> -		return 0;
> -
>  	if (atomic_read(&shost->host_blocked) > 0) {
>  		if (scsi_host_busy(shost) > 0)
>  			goto starved;
> @@ -1732,6 +1729,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	ret = BLK_STS_RESOURCE;
>  	if (!scsi_target_queue_ready(shost, sdev))
>  		goto out_put_budget;
> +	if (unlikely(scsi_host_in_recovery(shost))) {
> +		if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
> +			ret = BLK_STS_OFFLINE;
> +		goto out_dec_target_busy;
> +	}

Hey,

Will we always hit this check? For example, if we have hit the
device's queue depth limit so

scsi_mq_get_budget -> scsi_dev_queue_ready

is returning -1, will we not even call scsi_queue_rq? So because
we are in recovery and no commands are completing, we will be
stuck waiting for a token to be put back on the sdev->budget_map.

Do you need a similar check in scsi_dev_queue_ready or should
the check go in there only or can we hit a race for the latter?

