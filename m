Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DB7C04FF3
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 03:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B436613D6
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 03:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhEVDJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 23:09:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58932 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhEVDI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 23:08:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M34Opt096438;
        Sat, 22 May 2021 03:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RNjg7sMDPgsdvM6Yhd+6e0YacmEgZZxIxXUs20Z14kQ=;
 b=EVSF/20xI0vB0+H78GG+qdBfD+wYRCTFXD09PYbsjenWldGIqu5bI25ypCC/cV8bIHLT
 DYPigwLEVO/l6V71eixITvuZTHIlrxagl96VFbZfsO86eZ/KLpHdZKXmvrclNWETlaAb
 l86bKGkbH2k8bhRzr0NAuLM5rk4/YsSEx9RXCDXWpDZE6zmvCmppHnU4s2P1qW/ruJtF
 jWBuB4e6cDFEsjmJb1dPkeDsvKOCj5/L/boMaWp+jd231vOQdaH+K0EaypdHcpV35SiF
 gIc/tWPntvxtBT0GxxVBeWkKUt5zxpK1A4s2j6uK+rpCkjHLhO8RN2EdRpOCHWKbhvRN tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfc82s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 03:07:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M35aCt195425;
        Sat, 22 May 2021 03:07:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3030.oracle.com with ESMTP id 38pr09hmmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 03:07:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcK3nkAbv2Y+11DFxy9PNTfpkwNZgFmYi+i7gtm/Vc0nlxjFSnukrYSw5Nl4s3NMmY8ZLTarxigMIJa5BQ2EkZW5UMoR7OQmXDsJeNPXnxpe6zP5YrirXpAdG9AoPBQ9NubA8EYaQSc5r7Hh1WVAt+oJQMB1rjQJWSsHds3pCuxc6YKmcEYIvVX0o/40FpevqKupA57otKad/rkbah/R3wNehjkVtFCmDm+5PjToBkGM4PeC+Fy2hg0IDV6rA5pVRiVt84laemR53HK0t2D2kbPiWd4L92nkPLon7K6bmv0mKtL4NzrMxXa/Wvmj9JDfiNVAi24P88eUJk0QABgNuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNjg7sMDPgsdvM6Yhd+6e0YacmEgZZxIxXUs20Z14kQ=;
 b=OhLrArAXamxPsgP8UhkQQK1je/5P4SPRitJGPVtBZzmRBu6kSFSsb6rAmHOr5WOKZiTAEOioJKniuany795aNsRnmSGLxeEZGJYXCLq5oc9Is3qzrcbMtjNgryhfI932PFwGL9Sn/VnPgnGZlE7orazje8VIUKjGUzuawxzUQs8rmOMHdZuwc9VP6CX04yH899tqWSdnoB3dv8y8DtXSK+QqhdjlDfepJVCj5jf7N0DNy0KmChu1Va62jqoX39W5iqGhzrqNXTIUFGwQ9e6pzPKTJDjuIJ0kARUCjcOIt44GnCncnrQ6qAdHvdKttl44cByKT/aNQD+5po7PGiKJrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNjg7sMDPgsdvM6Yhd+6e0YacmEgZZxIxXUs20Z14kQ=;
 b=wtxUln1H3gcwZ3Wuy7sr7SZ0lvFGHdrr/Kchi6Cdg9tL6DI7XI0a7lSNPkLfUuIZTLC0oaQsoJra5AOTSwmLJ0nG5IXG/T+WqPuErrJqY74zc9ujzgCDAkCLpQhJ1tIGnmKff0unGuYN1Vh/44N7dBk9D/UCXfeR5PKqsB4HFtI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5401.namprd10.prod.outlook.com (2603:10b6:510:e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 22 May
 2021 03:07:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 03:07:21 +0000
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>, emilne@redhat.com
Subject: Re: [PATCH] scsi: alua: retry RTPG on a different path after failure
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1hzzctu.fsf@ca-mkp.ca.oracle.com>
References: <20210514153214.5626-1-mwilck@suse.com>
Date:   Fri, 21 May 2021 23:07:19 -0400
In-Reply-To: <20210514153214.5626-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Fri, 14 May 2021 17:32:14 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0015.namprd02.prod.outlook.com (2603:10b6:a02:ee::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sat, 22 May 2021 03:07:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cdeeffe-6795-4cd9-d77f-08d91cceb767
X-MS-TrafficTypeDiagnostic: PH0PR10MB5401:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54017AB01F5191AD465ACC518E289@PH0PR10MB5401.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5OmPKP3Oy8aYgRTZOvJEtlSmzsXaMWrA7/jMv/fI6+ZE/24F0ZmSyx34T/hKnaYzHJMDtEG4o+j/CWNIhrNSYwrWbrPNB725Om2r9atwgG3z0nE5ILsAVAikZFqAkpoy+3p2CKQTTVCyoPC4mdTrrBjRUAjN8f8fk7vtkRc6mDxpbGM+G1j2KNQYpK5Oy1seQ9Yn+5sxXHD/lGN1ORRYtqF75auz6dQmIN5WV464Vp2WHyNSo1zhzHVT0Ok7Wiwil1YUhkREtKKcwRqzA45h+ElPf7ewRPk04/2So878B/M3FOq8FmzCNTWsLLtmroLHFEk/jLyp2faZhkaX7K6+znUvLewn/IIWQQU9ZcHdxht23nE8jcPy8h6GnjaF7IB5vX9dThmWpyVNdjfyPxvF516QB3Ss1V2uVssTdUyANARSk+KvS/7uv7l1jXB0OtlhLxovq5/iMlkUbY3kzaAzFSmdaRewPhz1FxUeqZ3Vz/1Er8KmBhmoncvWoSsOv8Phr3LdbdZ7HDwAhEvZ283GBl1dwVNtWdG0xRaVA0YmrEDW9SnAvLy9nBMQ4mS8p4LQkM3YnOQQM8j8IAPDAUrn/KuQgFYmKFQ4JnJPJdB8z10AbU0Wx/YyUhOkDrvvOZ1zrGlKnJWc8FY8KxepEiSmAOom1BiOovSw14pQvK6x4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(26005)(38100700002)(38350700002)(86362001)(16526019)(186003)(5660300002)(7696005)(83380400001)(36916002)(4326008)(52116002)(66556008)(54906003)(8936002)(956004)(55016002)(6916009)(316002)(8676002)(478600001)(66946007)(4744005)(2906002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?70wGWpSQbPrpJ5v4ct19jdsYK2uGYuGG8JdeCtOJWNESJ2JBdhLqsTjYlP/4?=
 =?us-ascii?Q?NyWDv6h29GNMWr7/Q+kFatgSRRTeBUdlBIqEgE1vK/5+l7igWwOPi6QgO4YK?=
 =?us-ascii?Q?FxMbrz5k7PuJWQyl/MqyCeg4FejqPOG+QOvyrDysuPvXQCZJBvRuGaBfNyOM?=
 =?us-ascii?Q?z+2NmPzqDRPTS+EDb+rUgg8FWzZiw5DBZ/bPnlkjVD9UwDtmpUiCtf8WsQnk?=
 =?us-ascii?Q?utckS7bsRcwUzF57f2wM5G9Pq3JQIYYfTPQ2ALqYefaJE/la8Vj5qGPd/HtB?=
 =?us-ascii?Q?DelO0P7q9YGDRj000isW7PfS74mv+u8qIjjQoBg7cd37tDPu1SUbkO9M+xmr?=
 =?us-ascii?Q?zq5mbLilYdB8AES/eFt6JcROYGcOI+5GGf9H23ENdejeXFHvx0uhZi1OpVwJ?=
 =?us-ascii?Q?qAqruD4LugVXCi7kfKkPrnbrfVM+UFft6kLmg+CD0h63eoi3VJic31Txn966?=
 =?us-ascii?Q?Qix5FgjEbQloNZEBogVicpeEEnhbThIV3YJku0ARri2U2mux4lkLzraMdkIl?=
 =?us-ascii?Q?6G18yDuZr0pJ2QuoKS+ozrWVyV2DpiNJhBlTFK5LrUyXtvkEkgru4bLxlbaY?=
 =?us-ascii?Q?3tp+x0UDvLVMXdobvDRg9/JFuja3SLCNrez8Z805seyizWawCAeaQGJ/27LA?=
 =?us-ascii?Q?kMVNV3MGuf3UK6LCP5baqjvOYazKGk6D5Jl2M93PZh/6gKcY23kNrkIu/ZPB?=
 =?us-ascii?Q?B7ddAlPD+fSkCKD9+4OVA5bMrmC1L8OjOV7w6/SPZwlrVya8Nh0MDUBuTGJF?=
 =?us-ascii?Q?YA1q1ot8u2i0k90uECJaaLojW8ZIMtILu9xkU0aaCWjvt+bZTmP0jHFDfblw?=
 =?us-ascii?Q?yBDTYEc3lqnnEzTQnp30AmdD3ipUUrL5u7FHIwJ7LoXF1Rd6pleDkghK/Uk9?=
 =?us-ascii?Q?kRlL+50tLbIIBi7Pji6Y95NRjnCFH8j53wUAi/PvS7V3aGgNVYbh/IsQjpr2?=
 =?us-ascii?Q?hODY5g+Zo4VnXQ1OE/mW6z1Hx4kGHVMzznuVoDsWqJYiiNwtO+dKQFO5eenY?=
 =?us-ascii?Q?PcGr2ni83IziwudW+adEcSySVG7C1b+g/v+NN/RTiIy5Rw20iD20cWelDyYK?=
 =?us-ascii?Q?js++t+bqkErqKqve1kAgoSYHY0+RLPpp+aZpH4HdEqIWaVPicdco2ehioMB5?=
 =?us-ascii?Q?g3sF7OhPqo8uut542deb6V2ubxUZPQHzvs6qX1C6X2xXmI+6qH+zWJ/gOC3d?=
 =?us-ascii?Q?smfodd2I+IFQKWJb/Hae/6STnNeFRonASnK8jrZLReoDjDizhs9aYgH7Aq9/?=
 =?us-ascii?Q?OKKKVfKPX36AU8OxNxor/QHleM6JQynxm2iqzTWjOiIoBFdeIANRJrfRIG/j?=
 =?us-ascii?Q?Du9HFM8DNbacIJ4Yjxa6Yif9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdeeffe-6795-4cd9-d77f-08d91cceb767
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 03:07:21.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r30lRu8koJWkFwyo+vywh/8SeD2FJHwInE9xfTQiyyaS/PEf6p+LY89W81jys4pUr0I+LGo1x70/JcpRJ+QSQmXzXfY4b37jVAMfRY7CgoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5401
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220018
X-Proofpoint-ORIG-GUID: m3T6jQ9TM2HFPM9e0N7GAE71av4aaXi1
X-Proofpoint-GUID: m3T6jQ9TM2HFPM9e0N7GAE71av4aaXi1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> If an RTPG fails, we can't infer anything wrt the state of the ports
> in the port group, except that we were unable to reach the one port on
> which the RTPG had failed. "offline" is just a secondary port state,
> which means that we can't infer the state of any port in the PG from
> the failure (in fact, even the failed port might still be in
> "active/optimized" primary port access state).

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
