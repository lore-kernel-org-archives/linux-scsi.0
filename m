Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DF8C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 03:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCJDOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 22:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCJDOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 22:14:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8EAEB8BD
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 19:14:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32A2nUC3000532;
        Fri, 10 Mar 2023 03:14:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=QamI6lsR3gT6RDTkKixnbHoQUaz+tupJEZxfdLvpL9g=;
 b=X3329nMesKwVPB6RryrGl81MM30Z/oGIoZZFzo3pd/rZZDCiU8eqHGbWnkEoHIT4lwdS
 Ef6ueN+xOhcxFJkNes1V8ir81EPeAdCH1jEBPIwyZOBecIqunkCZMbkYPEavGB5Fh0fp
 IcE3p4xPSYF71iGeFkLaRCePKdFhX7XANuQeuUxqPMBB8t6KgH/72KL0kIht0HIEuCgM
 N657L4gbFAYWn/3vyVP9pi8amKxnLYRQPdVUp2HbUZi0M1ig6dUgvWmvR/KpgPk+4rdR
 VnlDHJ3SBYLlJs3RwakbbOvHXGDGtsnoMv+MIfDOgW1wM8Wu+em0RkB6Nah3fROdpGC0 fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p7v3w00vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:14:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A0k7X9020941;
        Fri, 10 Mar 2023 03:13:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fuacc44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN7oaUZOhnvczStd3tr1Vkgu+UDjoWXI+CsGBfTZjAz0yCqtKmJsBXDdzZvB33T8PjW8YlpiFiFNPVIa/Gxywjsqr+FTIWMLZvFKXwuOO9vG3MEq0OtKUtefvbLHh1Le5EfQrcoXdYE7dMGiFTsCRLGxA2RFjeLeAQcVhRJaLo6cU3J1tOjUH4VQiTmn/Erf4jx1W58t18MNIk8BAkB6Fk3WZ7XhNoHCHBQ+8wLOk5HfL1lQsfWXWzgaiVWIzUcP1rfm77Gh4xJJkZXyE6Kwt6iLW6H9yJ68eU8jAbc0foE4Q5k+0K25S5bdoUjiK6iaEFbna5C+3aZw3iylHLZ50A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QamI6lsR3gT6RDTkKixnbHoQUaz+tupJEZxfdLvpL9g=;
 b=HUbHgsiBCksf/oB+9QO7X4zlQbgtestZH0YjFCTNv6fkCZ4algjqyfZLhtRZf3Swh4fkn88ZUNw/UP94fSZC2D1XbAWX3asYH00JBoU/fYBmdSGDaU1IIkTUs1T4hzdrop9dsuIOkC8LaMYonbawItiRxD9EobGi4fJUieRqRd+i7xpsBJ4HiPwlhtBVyxS+PdmV/4nP6S42yJCSmVDvFE+66Eg6+gjxdNh6OTr35kulqtnIcjuybMjBtNAPHmlAI0clqluVCSKAaroPWMaPB7cqFkAJguupbUxiyvRX8oaqel23Of4Fgzv1TBXa34gqq/j5en638+sTACGu5UDMTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QamI6lsR3gT6RDTkKixnbHoQUaz+tupJEZxfdLvpL9g=;
 b=JyHzNHACmv7wHjcXcmJiu0wn2j8r5+NSRHvC087DiMJm82utwSVhxm6O1HLT+5Rxdbhvrnaerr0ica7D47PXcScXWv/NiGlzuTKRfC8clM+4fEkexs5har7BI8bOZwkxbK4sFt2nsXTkT0SPdI3pgOz8jayNaE0t5aopozhMt4o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ1PR10MB5978.namprd10.prod.outlook.com (2603:10b6:a03:45f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 03:13:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 03:13:50 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com
Subject: Re: [PATCH v2 0/6] scsi: mpi3mr: fix few resource leaks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttyt70z6.fsf@ca-mkp.ca.oracle.com>
References: <20230302234336.25456-1-thenzl@redhat.com>
Date:   Thu, 09 Mar 2023 22:13:48 -0500
In-Reply-To: <20230302234336.25456-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Fri, 3 Mar 2023 00:43:30 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ1PR10MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d1c2ec2-ce30-4bcf-53d0-08db2115788a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OumZQjM6/rBiRAg+CG23/0PV4y+BBMkDCPPRC9IplHFo5K0wo23ngsjjJppAT7jYztFB9mwAS3M4jd9xUZsphdFFI4ayfSpXreaSuGHHZ9qoibmYZQJBbQpT0lpGBuSi0o/is5PQ2nDABanc40qRMZm3tUMURhFBMCoP7o+7CV73+3O64gQm5kBqvcrgGlYqKLFvdi2m9vKVhmiu1NA7Wgp/S+zqziZAh7Yn6hGgywvTKwT6j9JL/z0uyOdFzjqdv3EOy2835GZyE50Q+0/y9uRLPzB/J5kC3KtR7PsjKYCrwUMidBy5MPAytw4MTsWJKQFDoOXtVR/Sh7w0VIhMSoTz/g2XFbJS1ZOsIFExVXlyitiLjCSBxhlrDNk5oSeAzmA43MPUpK7Sj9HA4BiA5lXPfGOZZHypIUMU7gbpJOuTJFZMi92cE546YmHbbYprxd4GIVFZMjAtk0YGaZULs2T/0WtCPl76oLAitl/tNGmwAboeTJbMSOzGwnDF6W+4OgazbENvVssbfpkezT2sIu4zzUgeS762Fo6jSdGwbm49D89SJME06Cxw20YcD+onHNUSomJcHfI7csJjkNY5VWTPnPxmAHsPCULz4l13xKFE/gkdTAlLFEuEG062w+KFSN1USkKEtjpC3bRI4axzIx48uloDg9IiBl5cAIYYVlDUMnlK+ULpIkc1Zl6pJLC/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199018)(558084003)(26005)(186003)(6512007)(36916002)(6506007)(6486002)(41300700001)(86362001)(66556008)(2906002)(6916009)(66946007)(8676002)(4326008)(66476007)(8936002)(5660300002)(316002)(38100700002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6O327VuGtfwEDvJZLnDqkq8WcVhNTtEhZH53whQLhRXfPejyRNGKXVfontwm?=
 =?us-ascii?Q?VFCc4lOAYgYskwgmcqkpQhFt+SoU3bIfb2k/gT6bbvhyGhoJSxBjPb3dbOzj?=
 =?us-ascii?Q?MwBZC7ee4AHQNnIjRwW6Nir+hjux9fKSPMtYt4sM0NqbAENSY157xxGscgiu?=
 =?us-ascii?Q?ATiwpLyEtUpZgLhX677t7GpnkYT5ksXyVSHlseIag4FGxhqzXdgdxv2xqM0X?=
 =?us-ascii?Q?y4bmRUOvru/ihpUk0LLcTKgepuAoxzU91xlXXtSONI1rg3567jh7YFdF5QZt?=
 =?us-ascii?Q?zH7of2J3KZrkp9GvIqCVKRa4q4p5zzj2IHZRlDtZFIHGAjm2qzathJisxUfo?=
 =?us-ascii?Q?FkwbzORxQMAhSGOZI16bauKGaowWHa1V2kei141ft3zyMYM/mhRScEVJALfY?=
 =?us-ascii?Q?YHxjvzu0wk/55ArXaGDfTCYrAADz9oWlKlQnxkwQB16QJPFGjBrWTRGjsROk?=
 =?us-ascii?Q?6WLfeYnlctrPC5dGhXzRuDiNkE+NgLZLv5MykvoTi/CF76O5cqnAIw0hQAlF?=
 =?us-ascii?Q?4vhgGv8WWKKRVe58Jq586W2JCZIdKrF0DmPD8Fdwg6NSwvqkHsAOZxvDLAQ6?=
 =?us-ascii?Q?DsIoo8eJMct+7ousLxImD0Bkt83SWueEIOTdexzL9Nk0lx4rywvdUbXEN5Vw?=
 =?us-ascii?Q?r5CGof70CQsuUfwLzerarYkL09ZoUHgJ2JEqIiFLeNwlH+kdS2YJjz8q2KXx?=
 =?us-ascii?Q?izmbVWDhWBG6XvfX1+G+KnwYGxh2i+c4o1G/pKifYliaEQFuxj8mgSphWIBa?=
 =?us-ascii?Q?msRVhzJJjtKktlIfrvcMMfmCE0HlmzQeg4oyhO3Hbpdunb5FAJfADOeBcqQy?=
 =?us-ascii?Q?1cPp4VNODYq4Fq9MuuyS2zBeiCj4CrdVeVURemxHOsyLR+mvL0V0NqmKVaNK?=
 =?us-ascii?Q?OXyFQMp6XEFFOXnzxCd8pEzOaug/PZIYpmnfs36hhmcEl+91ohlRIc29Lu3z?=
 =?us-ascii?Q?QyUCrbAbN2yRJYCaU4wWDcjVIo2G5OEEw04LAhkttcvz8nmE3C06IWkKrhwD?=
 =?us-ascii?Q?febpOCX9ZBkgEArCg1otYY98qQphEWMBt9ftKd59+Y4sFmD4qQXhWKvY/5nh?=
 =?us-ascii?Q?RDoTBmIfTRoVbiw+kifW21/nPiAqs0J0AJXMEuAzBNaPFuduxyYIVK66CVZ0?=
 =?us-ascii?Q?eXDmdLOG9IqhNep+sYrGYmrVvSQBGkxY2yXCFLPeDhEgsuYOrL8TTOU43JAg?=
 =?us-ascii?Q?0AUtgR0LghGWc1BFHEl59whnplt2Uohlgc5Zsbu1FkDoHfaXz9KHZx2qFJhj?=
 =?us-ascii?Q?qG9ozW8EF2kLpnrRekHNdKeC5YAWdPBeI8FWmKxtnaSjZn4RguNdAB6LWh0R?=
 =?us-ascii?Q?697UtklTf9SWuNirDEOum57uY+dXdk8wC+yiBO7bPfa+ziTwy/8ZelYctYVO?=
 =?us-ascii?Q?65912wJNyr2oR4HRv2tOTgxtZQFRQN0vRONLtKiv95OlshCRXzpmZXumu9I4?=
 =?us-ascii?Q?SBoKLUD99OhUTyjPGCg6yI6OUXTlfKZ3W3quI5Dtz8B5lP13Mu6mAQ8ItR8C?=
 =?us-ascii?Q?SU5JLQ3XiWSxKbdO4zrHOqqZFX5HENk1ElqfBIA5vV6casGxGnMsEx/U9UUN?=
 =?us-ascii?Q?L/Gz9tYY2Wy/7291LjmqRAEA+DxgH6+DJc3F3m5F5kfq9NR49bkQBzBudLJA?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ERExTEM/JKQG6hjU8SUD4sxfZrZqCXUoIWgaRqbQuK2ld5z9dV46o7/H+0nRflyx13ypPWsK5ucnbWqjHynz8CLiOur0t5dbJGjmWBp+uZBqZaSsGTFP8KoCi/tcQJB74qRmCFlAomKbCX3CgtsRZvMZelDug7LjEAhneGpsMmjW4SqxRjr2k6vCrcu5cpz9zuiT5cDjdzPPnMyf9+/EmrVZq+oQ6iy98IUEflO2TDp5TcPF7ziLnBtsvRh5XO4s+zFkDsoM5zB4DImwSsH7vsMiB/GZDdOthIFWmDr66fRhni6sTNzzTTuHIo6tp71JVFRtXnqo+jyvfslupjZUQgt1g93gWvT76h9Vv+7nRGeWwoS//I4TAgcj6rnD6GzBaxA2uYr7hbuR7HopFr3MV543gVxMsG2+0Y5A3icC8VaQaRqavUPXyA/Nb7fGMVD/kXyiDgKpT+cKHT9bYftUFxGMQttXkbLs84TenrFBkKWb+AyUyEstj1+YUaSJA+ZdFdki/oJT8lE4FhGRppK7jxefVRlfd4NGsW4IVT7giSE5D0VRgNrT8AtFqdC06TlX+ydMZMT8jBtaDUsBn99Jvl8sskTdIbiGCpUW0zP0duQ2TaCKsoA0SLMwVEPkwC6pdIgWqqArJ2gpa+Fd7aE8gga6gW+/uIV3yjPtVzXgvD5d/sadbcno7QEYW9/pvDtY+ZlgEPR5k+irHe8iN2mHBP4pvxnM0ee/UCxPcidqOBoEV7v6TtrHQnOPQcP8TGaqhOcz/jtVPcqFgnco0F71LJyN4tzKHRhfLLy2CTevc6h8HmXfDhsMVjJOU8UFBv/WS1l2DlbcRyxgz1UCv2Pl6Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d1c2ec2-ce30-4bcf-53d0-08db2115788a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 03:13:50.5461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmCvNHMn3w7AQVhf3LxrUaeZ97qNcEaJ3wPxLBNI0/+QKH0KvKUVf0cwTzLko9ll6aJinXF4A4M/VncXxPhcvy44IzAIEDXaAY7NBulW2GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=587 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100023
X-Proofpoint-ORIG-GUID: OXegzLFnyLQtkNXcpoM9EqXw5MGVa6gb
X-Proofpoint-GUID: OXegzLFnyLQtkNXcpoM9EqXw5MGVa6gb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> The series applies on
> [PATCH 00/15] mpi3mr: Few Enhancements and minor fixes
> from 2/24 posted by Ranjan.

Applied to 6.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
