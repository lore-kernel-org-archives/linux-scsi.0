Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E226C4332E
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1BE64F1B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhCSDr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbhCSDr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Uix2091172;
        Fri, 19 Mar 2021 03:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EAT0GUyO9satLLh/+MsPwNig+7uFfheiJ/JCxxyuYyI=;
 b=qzNBlrXuLS7VkEkMjdsvH47Yhs4Dj+dqXNuuJTqx1ZhNscjksyAEkmr9tYdLH5ghyUl2
 6wIYbtUHM3M+47cVntH8X7uYbz9lljN8aNIjMtYMfQL/0jLEUDkdubEAEB9ZvBXh6pP7
 NXSDAGEinAjFvVYqsuBsLR9aHzLzlUtw5M79elqdEpmFA5/fmet8vk1O/7vy8IfsSB33
 VsoH7cSFgWU1Z1m9gDoHaEIS4d6IGLlJPgv5EYwajhIN2Oqb5nbD7wufX0ZNOibqO/zC
 FcaCibWTCMQVSuAjpKbWS93M0ACqrnbO7MYBBVLlhpaz4U64jX9Xa554khQIsOlTexQ5 rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1p1fyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U8cm175034;
        Fri, 19 Mar 2021 03:47:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 37cf2v0ds7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQ1YRqaoMUtr9doAcKS36KdG93idcS1iO1XDoJl8+sgYnP5lTFUBbgwWyAzt/QoZ1rP8VS0A6w/X+nxrU418Ulqa48lR07+PNxriByvO1x7RqVMGNaorOQC8kqUv48UppK3QTbAZS9IVKP06mIETVD7HFQJOqT9MjYqtPD7CcGW+sGjxnp6Gupm/HQI9wubGwNm+sv/SN7hVSag3LOdrO22T/HG7K9XH2Cg6Po0de6LMJNCgQME+/N3sD/+7iTUeGEglNfiFMWmhCsDom81UQyaJMtxz/pEtBdJFYtxDkkkS2cuDboC949Ndh2qKjUqjfyoeCFcq0nMnKgac75vORw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAT0GUyO9satLLh/+MsPwNig+7uFfheiJ/JCxxyuYyI=;
 b=SKOAe1iNdmd6fppLBX8tAXz80lQTPPFKjc3i4K5ZtLaXdHzIaSiLSX11fB1RYxKcRzKZ6pP1InKn7rSj8S1LtI/LsFRV/Y3/Jwsq3meUwleQZPEuaUhkXSBu5WmE3DqZ9idP+0rfJU2L+wBEeU/vPRpZOpnd6d1rcZ7EibM1Z7ujwncv+ROgiNpfuJ15F8E9JKHKTKUW0j+i/YVgjZEjUrk6brnaO9lC2UntMNYsc3R5a48WL6GUvPHPRQUqu+rXpaG5B3pQRPkGlJb7NF6P5siDVcYj+zh8MQxPf5XXo41eE5iSGJ6wl9GtmudArnj6Ko69aSZCfRSrWMuYpYErRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAT0GUyO9satLLh/+MsPwNig+7uFfheiJ/JCxxyuYyI=;
 b=ftSik1NYi9IlYf7Cd0fiYTX2nQGKzFIZ1hJGllyaw4d9NSbwzUqh4HGw7qg7gWri702v+i9TGy+jEqCTooGK3wNLTWmLKHn7k85KlcL0RGctk5v9SsROpHmbmSsVpLeekg/5sxyKPfedFesI0AT4TQHKnFi6imPbMkB8muFJU9c=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, mdr@sgi.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: Mundane spelling fixes in the file qla1280.c
Date:   Thu, 18 Mar 2021 23:46:42 -0400
Message-Id: <161612513554.25210.6305317898716665830.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315021610.2089087-1-unixbhaskar@gmail.com>
References: <20210315021610.2089087-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99c889b3-e3f0-45a5-70d6-08d8ea89aca9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44707DEC8CA39A62CD0A9DFD8E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fxD/d2X9sfvhQnE+I9T2SA7hyLgcWPcmxAPuTVX2ECAd3JULNldy97tFHJOFZfvhbEj3cyxYwbaka0w03wzIurg5xlXbLjCGVOtF4JR+wNY58v5WjKOuwhMD/+3dj3xXodKC/k/nsfJntXhTfhtA6kUZmaKCMCWgy7iHBFxKKMBDFG9zED5VFgp4CkSPNz0XJIoTLDtqRWcQXKsJFYlPHM7nmk8MiyVpQdM9wGZkxjGparYJtvNC3XeHZJKEdtBua74uB8eb3AspS2irDOKMV1PTqv5Lkms13mIYIKApAx1XZG5wEf+jXGcj2uyB9uRQknnRQmlbtCDQfXZDJCq9mpNl+D7xx0X31iDRZrl08Av5cZBFC1OCxpZ2WScLsLxvAZYUZwNiWldi3pFy46b2QYNzmFvRA8JK0MFA5BORUP5JBA/VzsHc9CWaAUuwn0EedISFfKjxybmxA16F+n6T5k7NEWnZVTGjboLgwBF7ayi+XodgKHLQg3ftkbq1oF6+U2WsI6NjXtURIoifXNPzy2N1N/OV6WXW0xeH6bXJ34WaG+KWTc97vyINKoLaKQlebbwpre2GuWpdd61/2kIylQNRC7cbP5hX7bdhmNCzdOCapMDfnlaDhchuwdgP3ORPMwd+rgRwJnz/TnrcYTE7YABnznVLLOYl2Zf3bUeBSbbs6Gfag4xR1kjnRcDlI9K4YyLTdemJJtUYkcYfkjsKpv1BCqzYwiBSYXLiw/Ar5FA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(6666004)(316002)(8936002)(103116003)(86362001)(966005)(2616005)(26005)(4744005)(66476007)(66946007)(36756003)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dy9SeENqMUJkNFpyQlQrbkhMcGo0c0svR2kyTmF4enRwVit1cnhSNUFKMTVi?=
 =?utf-8?B?SGg2cDBuMklLL2NTcUg4amNaOWpJb3p0QTBLQjVKVDVzYktTWW5JMDgyTXZJ?=
 =?utf-8?B?alZEa0hlYjlQNm1HaFRHTUZXRWpLVUZVM2hXbzR5dFV6UWJVa2ZjeElVZDl3?=
 =?utf-8?B?bkRnRTRNN0FEN3BaSHd1Z2dhcHN2OEZYSkJOdmkza3FkK3V0ZGxLS1VIMnZi?=
 =?utf-8?B?TlF3TWpKS1drRW12WFlXN3N4S3M0M2tMVXFqVzhmcG96N0ZxZFNGSWhPVys1?=
 =?utf-8?B?LzVDeG5wRnRvbUNPQzdPQkkrOWpVQUh0bHNJSGJESW9uNk9kZnE4WGt0R0x2?=
 =?utf-8?B?dUNSSFhSN0srcFM2YzdxUGRiRXpFR3U1ditETk5WblNGY2k5b2JDUnNrYVVl?=
 =?utf-8?B?cjhwMzFEWENXN0FJYlNFTFRidE5RTUNtRThWRjV6TDZNWmJlV3U0RUFLRTZa?=
 =?utf-8?B?a2tjM3F2a1lTL3ljV1J0cndTUGxZVHg2TktmV25ZazFGZXBsM3ZNbGw0bzM2?=
 =?utf-8?B?VldjbDhYb3ZQNDNLT0doeWxlMVE0ZE83cDNJUzdpMnIxelJ2b28yQXdhcDRP?=
 =?utf-8?B?ZkJrZDdhMzQxeUkvbVRMUGtvZU9qdWZDOWVtcThDMHluNE81aXdZTzhER3hK?=
 =?utf-8?B?bkEzMzA5YVQ4K0tBVFlTTUN1ZG9kVzdRVVZQamdzVm4yU05FeEFvb2c5MWI4?=
 =?utf-8?B?bFFGZmc2TCtZcnFzNE1tdU5iUGZCVVg2T0ptYkp6RytETVlXM3NETHM3cnBy?=
 =?utf-8?B?Q2ttSUNuWWZtMThYSk54V0Z3NEl0MCsrbXdjSTNMWGdFRXhWdkw3MHlDcEZT?=
 =?utf-8?B?QUgyU3lyN201MlRYYmQraHZvZ1Q5dzNBQy9QY201bk45Ykh1TS9PdGtBZEZw?=
 =?utf-8?B?SjdUNFFVdnNQNU5xQ2krc0pWajFEN2NvRE1wRGlRQzVOSWNUb2VtSkRpN2ph?=
 =?utf-8?B?cnd3bGx4MjQ0cXFHY2FnMExsNEZyVDNDeDlzS1ZMVWxOS0VKbW1YLzh0TVAw?=
 =?utf-8?B?K0YvYmRkekIrQ2N6V0RFa1JnVm8wL1JQb3Q5cXpBVUxjVUMvMDB3WEJqTmNM?=
 =?utf-8?B?dVBxWTZEUHh6SS9Ra2RpSW0zcXNTK2ZnREExVG4wY0dWeVo4NHJjK1NSVE9x?=
 =?utf-8?B?eCtyOWtLRlpTL2NGdDg1ZW9jR29sekdVTXR0dEpLNk1kVndhN1dtZHNZb2NV?=
 =?utf-8?B?S3l0UWw5T3psTCtwaDNaMTFqMm5BTUg0TGdwZVVBM1RTN3FMcmZpMFNBbXZ4?=
 =?utf-8?B?YmkxT2l1VFhlOUVYUmZISWt1MHh5NW5SeVJ0TFk1VUNvek80Q2hGbkl2WFoy?=
 =?utf-8?B?SVNpVnRYTjR4aFNwWEpFSmdsaW84RHJrZmVub05wZ0VrZ1RkS0NiOW5TVDEz?=
 =?utf-8?B?Y0NwVVVuaUhFOTU1cWRlY1FYckhlb1JkT0tpRWZyb3pXV3hFcGNmcGppdWRX?=
 =?utf-8?B?Wk5PcXlHYU5QNFNvQk9ZZ1p0KzVGV2FhbVQxeGVaL2RJcUw1Wk80YWxMMFZT?=
 =?utf-8?B?cnFnYnhRQzl0OWVRZmlwa1hKd05RSmNYc1JDQ0I3c25MaS93WStOVWFxcXlS?=
 =?utf-8?B?eUNEcnp5YmdDYXVuZTNxL3NDRWMzQlJCY283eURKb1lJYzBSSjBCYUdlWVJm?=
 =?utf-8?B?ZUM4Nm9URyt2RTUwbGlWTjZ3ZjE2MXhwRS83UE5yWWlUZXV6UGhBN3dMQ1BH?=
 =?utf-8?B?N0twWmJJNXFNM1FXazFKakI4OTlMZ2ZnQ3VPOWRxUmc0MWFMeHlFcUNub0wr?=
 =?utf-8?Q?gVIInVx9NYZ1dlNHlWeRp7UNVDFeq4n9mMiB4Be?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c889b3-e3f0-45a5-70d6-08d8ea89aca9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:10.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7lbpW+/i7z6AGCCOdhrMjMV2znsfM5HLQ8eZCZgz0K+GPQh2bERWpcO/AYuL6j/JHCoPTivxj6166fyDEFxgrf1ssCIFPxgeVRwNstAm2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Mar 2021 07:46:10 +0530, Bhaskar Chowdhury wrote:

> s/quantites/quantities/
> s/Unfortunely/Unfortunately/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: Mundane spelling fixes in the file qla1280.c
      https://git.kernel.org/mkp/scsi/c/1bf5fa1a2916

-- 
Martin K. Petersen	Oracle Linux Engineering
