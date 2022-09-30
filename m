Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E93C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 02:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiI3C6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 22:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiI3C63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 22:58:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A62B10463C
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 19:58:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMiglb005139;
        Fri, 30 Sep 2022 02:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TBGcq/eJbva/4arz2DjziJxturBg8kKI6gOUj3tjYEg=;
 b=L5XsyiiFEPqoSCwYL/ehlmZBmZst6eUNvz3xbx9RZGcnRUASpUB+8sLpSwBFkHnVW+MZ
 t3xZ60yi/HlJuV/otU0n/D4OPq7g2++1VjU0pPqVCpqtlMaOj34emcCFjy8Cak0LVwo/
 /S0GI72rBxQz248bTC9ZSIa5djo+Qg8ZqMsn9eg6mw7zWUTIEWsNivZkbQa9ie9P33wh
 FyK8sXsPvEGJ8gt6oPVSixCTBuj92DMSUjq+ctZQRpzKm3Cvk19R13i0aGZxAKbcghrS
 1zkqD6xzZDNr/V6ZLDej8nVCadvRN8nQ5vCqMTASAouKQN3fz2Aq9cxolgu5IEWAFklm cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet72ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 02:57:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28U0WpiT033541;
        Fri, 30 Sep 2022 02:57:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv3ggxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 02:57:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PA1MxDC33hofkdE6vqKGIyqQZsnhRFpVINPHQIMTikxVEYeF3U0lApL8bCgWjduaw5KPHvwECDslYw8yf9RKH9TWzKEyB8bUCfvrj9NRlQE1ljbWYQfYcPlIVYmL0FkN4MvP9WdBdPdOi5yydbbnHVKnl9J9WEAz2ERRjXeNIKlQ8JU9WlzhC5Au2XTP8WjbIRsKNBSbxNG+5h0ZsTM26MA0UehkYtRuo1accICpx8EAGNf/rgcyK3chumhagLW2HLJqkw/WxCnQbfFc5spfe+pXQHBgLpNqwHi5ecaStRkG628wgU9uqp/NSxjjtcYVtD7bHXOSV4fD+4+N/zTEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBGcq/eJbva/4arz2DjziJxturBg8kKI6gOUj3tjYEg=;
 b=j/vcubSpMhZ5wXDurKswPd9uR8/Sb29t3V4f0WOek5B07ksDJ8Rkk/nfd3qXJ+dw18qNmxqrnISyjJvrA3vNg0vusDhkZ33zWQ9UKfJe7VXb2OW6q/vvKLK9DL/UP2xT2uSPYs7P9MW+H7lVWy4whX//hOU0UhLVEIZF+oefbCa6g7QvGs8coUv0FryqZV1Zb/MS4SlbiBqfnkiYqeOogHrza0PcLXVofyqq34kaU/n1NVWayCuhPY36XeaR9w6ElMA2Ohp+u411xwawl7X9G8GbrP/Iy8q9gHmoJJFXWyzT67yahDx2XJ8STun2auQ+TypbBiqYzOW4dxbRUwX6Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBGcq/eJbva/4arz2DjziJxturBg8kKI6gOUj3tjYEg=;
 b=xRSSpqxd7KFQa/LQNFj4A51+HXYchP/UOZlkm7T+JkTF9/JzmzkCZVjB82x2YFLofpLhhdu1etJDcfzxiSUUnFpt5SR4TPY2G7+Flq5Aq7sCI/6Kwb24OZgARcREQ7UF7TXFZIQQ0m8/XzaDanwLWF3ip/JfiL+kBqEjbu/F2JE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Fri, 30 Sep
 2022 02:57:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 02:57:32 +0000
Message-ID: <b5ac4103-87dc-f3ea-a2ef-67b3ef41bf66@oracle.com>
Date:   Thu, 29 Sep 2022 21:57:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] restrict legal sdev_state transitions via sysfs
Content-Language: en-US
To:     Uday Shankar <ushankar@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220924000241.2967323-1-ushankar@purestorage.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220924000241.2967323-1-ushankar@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:610:58::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb010f8-4a0c-4412-7852-08daa28f8549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qI7fRCyEz20YN5fLjKW5FOhbKn4T8A8qRdbWXHS5irAVSEoQnH6i2iq3iY29ea5NMEpXSRJ9GiXiskA0V3ar6c5DwZi+7Zy+u/jEvQHRGRaAu555paa7j96LPeP/zXAeFt7G2XlL6C4cAckKPUP7crR6gN8g/7ZMU1leUsatdcpjgDHukmUvHH5FGoluQyMDYWS10KhRGLX76eV3jR76OgWTTdZwsULqI+FD86zpPwNtuA07IQXrVWQYepMoLYcsxNTf/g6e4qz7DENGXfdYCJ855saYQHXDl8YZhOw6Cns4h1ZqYax62A+BBXkxUbZFGExVdf4dhIsc+bKZROXsmpwxE57Q08A7hM64Xlva70d8x9YqExDJSc/QQx7xtbEpyOxz+cxQLfKe/tdGtGTvseGSwpLxYXY8WuM2PSI0vTfn205l2q/NWabOcFHgzH54+aZWJBc2sfxxb7NnuNlK33y8DpVIiRYBMWcxI8+Iv0ZVRxEv4fRZKbdW+xUhDmfawnwXQ2CDhfC3rRFBXC0losTtX5NeMXTdPfR4bUzhgW3kMEs743pZ5ddY+28ZHcy9zaS+rY9He+YGv9fmT6X2r2Na2AgEpIfk0zv2zhqbqkhcJn/gp6RSvEBVdE5VjNYM15vXJXoENZZkIzZOG20dmAoGJuhJsh5n+jPgq4RvzLlAR5uD5pJuYXj84oDiZwuHoJ734ftsmNFYatoozwcYOiokIeSk4EJ4FEn2ycpQi4dZa0jN7td5J6yoTk/Turj/fFKbMOApHbhgqIgqCJ0cIUy16TurAahFe9Aynon/Ovg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199015)(5660300002)(31686004)(41300700001)(8936002)(2906002)(8676002)(6506007)(4326008)(83380400001)(107886003)(316002)(6486002)(54906003)(478600001)(66476007)(66556008)(66946007)(38100700002)(31696002)(186003)(2616005)(86362001)(6666004)(36756003)(6512007)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXcxd2o3UFFuajZvdEF3SUhBZTB4RnhwTDVIdDMrQS8xNlVSL3ZRRi9meDhp?=
 =?utf-8?B?TlpZT0F4eEtmVzlCYWZCSHc2RW1WN0NSMzgrWGFkTnRFdm9JNGZEeUtpcUJq?=
 =?utf-8?B?dVpoNmJqWFowS2ZqNklKaVdRYkZnVUJLNkJ2YlJxdithQXJDOElLMUNUdmNa?=
 =?utf-8?B?RTVtVEJ3OTlxUVJFbHg0OWM1NjR0NUJ5am9maTlHS05rNERpVjV1eEJZbzlj?=
 =?utf-8?B?OEkvL0d2VUhFUi9OQVc4YUd4aUxldUc4Wk5tdjJLc1JWdjdQcE1BdUNvSy9v?=
 =?utf-8?B?L2F3UWgzRTJ3UEVYOTlYVnRhN2R1TXdpemVYM0lzY01veUg5OUNnR2dsNkFV?=
 =?utf-8?B?Y3VqREVFL0piMlhSbngwYnoyeHBIQW5SbEZRWmtDeGZGR1N2MExHS3hFRndz?=
 =?utf-8?B?bE5SY094ZnpHaHZNQWNoYys4MTB6SjhTSWJUMVd5UG5OK0lJc2ZOWTdaMWxS?=
 =?utf-8?B?S2Z6eVRpYnJuRVM0cm5KTGFmWmNYTTA4LzZJUnhxa2hCWDRFMzVkcWc4Z0Rv?=
 =?utf-8?B?VkszalY4Z2pkT0pPUnJEMmVGRkZNU3Z2eU5KRUVQbkRwZ3ZhM1o3amtCbUpw?=
 =?utf-8?B?Qkw2M1ZKenVadlpGZlZWQ0tsYytJZGFPMkVQbDVPQnZDbjRCdFZYc3BURHZK?=
 =?utf-8?B?REdkUTBvbDNxOEtwWHRqc2JjeW0yUUU3V3V3bGpMRkk3RHlkejloeFNmZ3F0?=
 =?utf-8?B?R1cyYk43bi9HU0x6UHZTM3JYdzE1Y3Z1cURiT250Z2hzeFh1dzdvampyL1M4?=
 =?utf-8?B?cjFjTGk4UHRmbmRFc2tJQzNTQmR0LzlOKzIzVktUUmxmcmMyajF1K2dKQ2ZO?=
 =?utf-8?B?RzF4bkJwcmQ2VDlLdVpNL01ncGxUUE5jVTR1WCtwQ3pFUVlSd1FKcEsyWkZM?=
 =?utf-8?B?cVdOM25uaWVOZUN2ekJGY2EvZ2lIRlhTQjhtQnp2L08wUlhNQnRRR2NJVTRy?=
 =?utf-8?B?OWdaZzZSZHhzNDd5REVQUkhpd0FCTk0rci8xOEVRK3VSUW15STBqYldKdXBn?=
 =?utf-8?B?d09reGVTVDhOZlFVUHNVbHJXSk00N1pGN2xEMHJjTUxpZGc2RHhlclhqdjQy?=
 =?utf-8?B?SmVqazF6cFJMMTBRVzNCRTdQM3RUUlNTNXpBZjNiQ3dKcE9vVFowd3UwVTlN?=
 =?utf-8?B?d2xwb2hQdEF5Q2JxYXBOSENBSHcyNHd2Z3gzYTFiRVdjVzhUVUpkOCs1ZzlU?=
 =?utf-8?B?Uzl4dk5wVVh0dkErbG91MjZMK3BmWVAxN2I0NllDUXVUb3hkVmp4YU9DdTBV?=
 =?utf-8?B?RW4rUXdBZU9TR0hpNTZaVWhzUlVmSkpZS3RkWVJUMEV5YWIwNzcvZXg4UjJy?=
 =?utf-8?B?MVlJTjVKL3FSTnUvZHFrSmxxMXRjUjRBdDluZi95LzZnN2xlcU1DcmIwZnEz?=
 =?utf-8?B?SFM3ZkU2TC9WUTFZYjN1SWYra0pGelZFeUd1VVBEU1k2V1gyZXlaUkp4OTdL?=
 =?utf-8?B?WCtJVXNDNysyS0hlaFdBd2JRR00vL21uT0RIZkFBczNkazlpSFFmUnNaTjJo?=
 =?utf-8?B?YTY5TEJYY0pZTXpXMmVKNCszaFZmOTYrb2o4dHpzdGlDR2N0L1dKY0tPQnIx?=
 =?utf-8?B?NzV2ODFhR2E1WHZJdWM3eThMT1NSZGxzN0pBYU1vcXBCdHp6enQrS3pzcmJ5?=
 =?utf-8?B?YU5qNWp3Nkc2aThCLzczdkk0VnAvZkdxWkJPYnhtb2p1OFpLcktMOUxyVkVq?=
 =?utf-8?B?Y2NYTVlVMWNUaXlDaWFrQVozc2tzZ09DbzFZYXZuUElWQU5VL0FPSHZUUk9y?=
 =?utf-8?B?N1dIQ1RmRXUyS3VZUFl5eGZ4MkwwckFQcCsyOWErelByaUpzamh5dURpSU1p?=
 =?utf-8?B?cFV3WGc4UnhxcnFmeXJjb2gxSTlPeUEyRjJQRWFvYmJhejFnaFBQZHJ1Tklr?=
 =?utf-8?B?US9uV09yTXpnelluWUpCNktXUnFSdXcrZ1AzelJZZlk5azlsOG5EUWVmS241?=
 =?utf-8?B?elREbFAwOFpiMFBuRHRRYm5VSzRPTDZCR2ZsWnhNUnlCRDhLZ3pORTB2dUJz?=
 =?utf-8?B?YzByZE9oa1UyU1F5NUNrbmx6Mk15dVR0eXVsNC8zVWJORUF1ZFhEeE1Ya0Fq?=
 =?utf-8?B?bFlwUWEwOTRJbzdWRVg1cnJDb2hFYmJlQTJqMjFPdzZ1SnFPdGdlM01ycVp0?=
 =?utf-8?B?Y3ArSnVkWDN5MjMyWmhqQmxwNUd0UEE0Rk9mY1hiRjlYRTRZT3R0NkN5azN6?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb010f8-4a0c-4412-7852-08daa28f8549
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 02:57:32.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYaFe3d8a6r9r3qz7nuU17o6+FtiroF0NZzHmt1dQXW33SySFyzjAOD4CYjxxl6PGt7Z25d8JxH5EimSOJD4etJgQJ6b/ugTRzJizkLDm48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_01,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209300017
X-Proofpoint-GUID: K_weanhsev0_zjPFtxBz6VoDkukXv7up
X-Proofpoint-ORIG-GUID: K_weanhsev0_zjPFtxBz6VoDkukXv7up
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/22 7:02 PM, Uday Shankar wrote:
> ---
> Looking for feedback on the "allowed source states" list. The bug I hit
> is solved by prohibiting transitions out of SDEV_BLOCKED, but I think
> most others shouldn't be allowed either.

I think it's ok to be restrictive:

1. BLOCKED is just broken. When the transport classes and scsi_lib transition
out of that state they do a lot more than just set the set. We are leaving
the kernel in mismatched state where the device state is running but the
block layerand transport classes are not ready for IO.

2. CREATED does not happen. We go into RUNNING then do scsi_sysfs_add_sdev so
userspace should not see the CREATED state.

3. I'm not 100% sure about SDEV_QUIESCE though. It looks like it has similar issues
as BLOCKED where scsi_device_resume will undo things it did in scsi_device_quiesce,
so we can't just set the state to RUNNING and expect things to work. I'm not
sure about the scsi_transport_spi cases.

It would be best for James or Hannes to comment because they know that code well.

4. The transport classes are the ones that put devs in SDEV_TRANSPORT_OFFLINE
and then transition them when they are ready. The block layer is at least in
the correct state, but the transport classes may not be ready for IO since they
are not expecting IO to be queued to them at that time.

> 
>  drivers/scsi/scsi_sysfs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 9dad2fd5297f..b38c30fe681d 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -822,6 +822,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	mutex_lock(&sdev->state_mutex);
> +	switch (sdev->sdev_state) {
> +	case SDEV_RUNNING:
> +	case SDEV_OFFLINE:
> +		break;
> +	default:
> +		mutex_unlock(&sdev->state_mutex);
> +		return -EINVAL;
> +	}
>  	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
>  		ret = 0;
>  	} else {
> 
> base-commit: 7f615c1b5986ff08a725ee489e838c90f8197bcd

