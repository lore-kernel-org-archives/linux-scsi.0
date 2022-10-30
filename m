Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369D4ECAAA1
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Oct 2022 20:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJ3UzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Oct 2022 16:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3UzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2022 16:55:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3EF60F8;
        Sun, 30 Oct 2022 13:55:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29UKk1l3028231;
        Sun, 30 Oct 2022 20:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fB3sLTmQnVvFGazbWsnlZik/ceYH8MTKNRAw/DGp7h0=;
 b=Weow3OCSR3zxSwNButVx4eErn8CryHulsmhzH8JJZuCRYANRx5xdOYW2lP8IfSys/cGc
 uPTlhScMIElVXpZoRRANNAGUxCibrH/UPrnvPYfnpq0D0gWMgNjGwtwt3OZsbgbCmoJA
 SdC0NgzhMPj4V3PsRd70ap6bwV8z9GRaSdLrRzfqBQ4gSwp2rLO3rxb5oKbkQzJ/utnz
 5rDjrQ1R521HHLxuUOASCyhW+tDGPoyYSvvenpaFfQlhV1kehVWJ7lQd+oEPzS2zv8Ps
 63A4LPiAygE/uL3/UwTcvnsUWUi2ifed/+EcYTKFR5xEzkB/9tkqUHQ4y04XIx4TpxxK DQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgusshycr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Oct 2022 20:54:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29UDNUPt029388;
        Sun, 30 Oct 2022 20:54:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm2jqu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Oct 2022 20:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV9esl3WV3A37A59yrZ6T9NWMfS7hZTf66BetvpNdyv6/ok0kF9MZIGZ6chvcSR0Fg6TBZrfwKruxtyUbNUT28NcwOjq3ryge1fwoLzHtHQfe5nY6YhN7n1fNmfISGOUc0X1Z679pdALrGOSLQgJQh/BKvE05puvjMJs0cmokGzsi36KBTu/j/qHhSt+YFcXTJEYAP8PJOfS/abqg3hc3VKY4Ue3B2gVXentOP1vG5UOain4fFuUUxsYKAuc6MtVV/l/tiox+XY/vpRLdOXo4OwDFW9/m/A+RLzkeZxiMMgeT5AvCsOPoJ1QpWCOWVnKfYK5eNeK6mDoUERndDkamA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fB3sLTmQnVvFGazbWsnlZik/ceYH8MTKNRAw/DGp7h0=;
 b=ZjGaCHvOY3JvVewKbKM7EYJ5KFflfmII81mm/7NT8GUstn6rKCXnLvacckDRqlCroABeOXgEXEqUGp2nVG5AqSNaK0iR7PRC2QZ4J4oIok44VUBvOfyRQNetbZX7FtZfWzENOp3rN/IBtRpybKkIGzbdRCDZaV6NuhksUkVd0D9hoXW/SK7c6WU7QCysOb4vPQQtOyXHKDBUxCzD6+qbtk1j39xdCjmnlgxsmhGDSxOy1R87gInRuIfWe+SE8VOTXluJq2D1MW0iubYtpQJDu3tHfN55rcI7DF8cBGOMhGspYE3ESV9R+o9c4lBSIAOvxX9q+v+/kxz6UdRLuaEVmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fB3sLTmQnVvFGazbWsnlZik/ceYH8MTKNRAw/DGp7h0=;
 b=LOfNkp01COCtRDj3eSe1OgRDgMr5tUxvT3FTZm2SEmISTKQX2ttOqJWPVRtFbGwgkXbLcr1sa4v5PZwiMpX0t9O+4iejbDgBdsjCQtQVELplcyNeq7bET0b5AXn+u8kxla+kGZQ2doqNoH+QGDq5qjbNjCIK/dvbfbq6CGOKgwc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5240.namprd10.prod.outlook.com (2603:10b6:408:12f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Sun, 30 Oct 2022 20:54:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 20:54:49 +0000
Message-ID: <fb1fb550-14fa-d2cc-cf03-e0b129fd1ba0@oracle.com>
Date:   Sun, 30 Oct 2022 15:54:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 11/19] nvme: Add pr_ops read_reservation support
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-12-michael.christie@oracle.com>
 <20221030081851.GB4774@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221030081851.GB4774@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0018.namprd05.prod.outlook.com (2603:10b6:610::31)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5240:EE_
X-MS-Office365-Filtering-Correlation-Id: 769593cb-9fc2-47a2-6220-08dabab8fc5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOx1OLF8wyQacWok9mlzvC49Z1fVgiq+CjM/Aq+FBzuzgrGCapaJeINBnfZ5IYcoaL3UMQQlN0qkDh4qHyaZbzVdyU0rsvb9xqMxaI0vh4NIZBEWu/eklRNn8OAh5RJ+1taNASzZ4hPXwLOPkYpjvRJt/4TDls1pSdch0o83LgVqHzkWBclRoKIuGb2iDu/sp2dpJYApL80rnplIGWIkAE7Y0y6iPRQIKsJ7AH9jiTNWPZXafXlV6Ew8rd46hwXS+1zKOcHNp27GA0j/xuIVKNbLKcNMTOIbN8pOHi3vtqWMQkvqlJZmJpE35CyndWzILpvjsDis5gQovpiPNB5iHFwG9hq4HNICb/6pTNZXib77ilx8qarjH6RDhzOyLKi4ZJdKrGPb7TS9m1d8H8rEEjYSuhNVdNKyoV/ZbS2H1NPBNgh9gm2Ky7mMtVD1ZWL2MvXnkNeeH4orTFbbb+4Y2cJwhQmp6cebLms8upDp11BkDO9tLVvLHejWgTiiNJ2NGumIM6K6BMuZUER02EtonRtD9zQVDdzxxy5TOeo9G8dMbm0E23XpkiBrcMJ5zZYkc5QfX8eqveiewpxDOncTpX1wycZkK0kHEu2+eq00IynsL3rPQa2qyR/1F9Mh42BmXJ1HRe/bWTZu4HPc1J0XsVdK23kflthvgTmGxnV0W1l/7gY4g8ksKVVfODfpXW6KJs+ByAMiwXu1vvo61Oo2zS1VRvyqE/88sYS8MK8Qa6+EzmGCqyZyGKsrD76WDhOaqw8q8c+Jlmd7zUAtHO6bXcUhuDcYJPcVT0rL8at160U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(36756003)(558084003)(31696002)(86362001)(31686004)(38100700002)(2906002)(26005)(6506007)(186003)(478600001)(53546011)(2616005)(6512007)(316002)(6486002)(6916009)(66946007)(66556008)(66476007)(41300700001)(4326008)(5660300002)(8676002)(7416002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDdYOS9qTEFNb3dncDhzZ3NCbENyTlVWclVmSXBYa0tId2pKVERFTXNER2JW?=
 =?utf-8?B?alJQMDR2eFZUV1plSHV2QjJYT0pHRVlORU5Ibkp1WUNySTZSODErU0dmUnkv?=
 =?utf-8?B?cTdQWTNBTjN1TmFPZTRhbGlzQ3FzUWxuck9pSnlmWUFCcThxaEp0WGVqR2Nz?=
 =?utf-8?B?d2kwTC9ETXpVSFkzMmdmWU9sUmc4cGVWZFJjWjgvaHNtQ1N2dFZvV0IyOVpI?=
 =?utf-8?B?SXo2b1lqOFdJa0hzRFFhOEZZMUtvOE1mWXgvTFd6RldjUzluU2lOdk5DQUlG?=
 =?utf-8?B?ZXMxdzZMdC92RTVVelk3VGVuaERHc0c1QzA2YlJjVkNNb0NpRVRON01nSGJU?=
 =?utf-8?B?cDViVFV0RzZyQVVNVVNiaXdsMlhGY2JVUWVxMDZGYk10dm1LNFAzWjRRREh0?=
 =?utf-8?B?UDlwZFpML2NoczFZNExYcXpRT3R4N3R0dmhTa29qd1J2ZE5SNFBaTHBWRjlL?=
 =?utf-8?B?UGVQZm05VXU5ZXRoSk0vbzQ2SlVTOVU0OFM5RUpPVEQ2amtsbjlLa25OMUp1?=
 =?utf-8?B?Y1lDbzRpcU1rYmN0VXE1UWRXQ0VjRkdmVDh0K0dKdndjU0hUNmZld0hCV2ty?=
 =?utf-8?B?dWRlQ1c0ZW4rQjVHMVNjMloxRStXRWFmZXptSjZwUzJKZ0F0eXh5dG5zQkht?=
 =?utf-8?B?SnJadk9Id0dyeXpEc1FIRnhJNGx0MWhWTjZQZUl2QlN3R0lNdWt4RFRCMFRs?=
 =?utf-8?B?V2tnbHF2Tm1WZjRqWTRGc1pZMW5UVUNkRlZrWm95TnM3TDBNKzNLUGhTaUVF?=
 =?utf-8?B?UU52MDloVENWN0dWSTVXbEJsSFpTU3FjOEhnUE5kNlBudU5YZTV5aHJUeWMw?=
 =?utf-8?B?OW9JcFk0cGR0RWd2QnZRd3lMV0FWUXk2Q0tONFM0dFRUWC9kamduRWdGOTJw?=
 =?utf-8?B?bU1ZWU9qMHc3dFhFalFRb2hkZEEvWVpRVFhnc2hzdWF1cDU4TnlnZkZxWTJa?=
 =?utf-8?B?UTlaaEpOdjdHRHoxcHo0eWpZRm82eTkraXpKVlNxeDFjMjN5Zi9UZ2Rocldi?=
 =?utf-8?B?WXlrY3E5dTNxaGFNL2VBemNjbWlRVmdYdVhBaXA4dTlxYkF3cGFTTE43d2lF?=
 =?utf-8?B?cE8wb2g4OU5aQjNIOGZVMzA4ZUtsNEtudkEzaG9KdGZKeTBBWnV4aFhkV0ND?=
 =?utf-8?B?a3JYVmxjeEZ0aTdxcjdzdTdSeEZaeWc1V1BmaTBmMXVZaEVJeTFpUmdldkhi?=
 =?utf-8?B?aUpLNDBHZTMra3doWE1YWlpqZXpDbmh4Nk4wN3VsalBBWHIwTGpXVUNGOGpT?=
 =?utf-8?B?MlF6UWRkdk55NHU2cHZ2K1FnLyt4QzBJb1V0S3E5M0ZrNnB2YzF4S2NrbEJV?=
 =?utf-8?B?RUFCVG0zTTQxTE9lSHNVYjVIelY5R0ZEOU0zMlFxanlpMXEvWWF0dm9NSklJ?=
 =?utf-8?B?dnBpR3RBWlFBMlpwYlB5RWs4WGZGUkJkK09qaU9pNWc5cUJJMUI2ZlV3aGwv?=
 =?utf-8?B?aG93NUNPZnNLM0taditIdWJjS21TVGFtdzk5cWpJeGtSZDMweVhrWnJ6SFo5?=
 =?utf-8?B?SzltZVJad1FZaVVGNEo1aXAvUWE3aFlmejB2aHhkMXhYQ1VoMjRTRkowWlJ0?=
 =?utf-8?B?MTREUm9EQ29rWEpNeUFicWNxVnVreERFUTkzZ2dJOUJhR1lYZU1JVU5NSFpT?=
 =?utf-8?B?Tm1nd2FLTlVtSStWMXNUbDl4aG9nYVplM043dHhCUllId0szZHBnYXk5M0dY?=
 =?utf-8?B?eEFiY1BPNEhpQW5NOTJUcjZYTUdiemt6S0lNUC9aRUhhY1hlOVo4UVZLOXcv?=
 =?utf-8?B?Q2ZBNnFxeEdxZDc3WG5FOEwvOGlJSlFvN2NFSGhiQ3NZSFd5YkNJN1ZSMkhR?=
 =?utf-8?B?di9lN0VrNzBoMC9mTHVlY0NMeG5tYmFQWVlodnA2Sm9aeU1zSHNQeXFUS0pK?=
 =?utf-8?B?NDQ1UGMvU1RVYkNqRVlQZGRHR0FKT2ZoM3ltV0U4QlhMbmozbHcrU0xEM3ZC?=
 =?utf-8?B?QzBtSEN5S1ROY1NnekxKRjBrT2FKTG00ZjdVc3NEVjZNVDMyV2xVdjJtTWZt?=
 =?utf-8?B?NVEzTkJLYnhSOWMxTjliSHBiVldrRWZPY2RFaXQxNlNvNlMrZXV1WTc2aHRr?=
 =?utf-8?B?QVFRY2t3WGJtTSswcnFVU1lKdEZKbk03bGFVRnptaGpHdXkySTE1cE1iRXNo?=
 =?utf-8?B?RFRRQWhHdHNzdmw0NWFNSnd0Q0xSZFJBTHpnUHJsWG55OTdHbG4yZytMWHJS?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769593cb-9fc2-47a2-6220-08dabab8fc5f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 20:54:49.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYkCD5emTAE1U7JL2Nt1Wo6WnQOthxuLk/3g8E2DPFPEnOdEnQ/rKarHmGzf0vzrZorCW0xoVXgHs6/swQtd8P9LIwIaJAQu4lEweN6FkFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-30_14,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210300142
X-Proofpoint-ORIG-GUID: XUE5_YiefUfS4tIyHvsEWWwk3WCfUqV8
X-Proofpoint-GUID: XUE5_YiefUfS4tIyHvsEWWwk3WCfUqV8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/22 3:18 AM, Christoph Hellwig wrote:
>> +	memset(resv, 0, sizeof(*resv));
> 
> Is there any good reason this isn't done by the caller?

I will change it.

I think it was leftover from when I was experimenting with
some mulitpath support. It's not needed anymore.
