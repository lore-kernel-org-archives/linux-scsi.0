Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234F2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 03:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbiBWD1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiBWD1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 22:27:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2193136E2C
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 19:27:16 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MMnHuh000629;
        Wed, 23 Feb 2022 03:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=X8dsiYNqKvB7ZnoVY39uRDEuNkP8YJ80ELuMbG3RfV4=;
 b=Gjg5nHE0oejY+sivqoukH/LIz249aHfw2RJ/H6BpqTWuCK991u1XFnzbiO9g7+tZzyiY
 +4eTsItSRq9rftrn0g6B5vERPuiycly8xx1mHmfkpye5roYQ/ydlEk3rctJtqqwFgdQH
 j1b+K8AtvQ1cH/2AbCFpR/OvDOjnvKGAcLIPMXtR6i69+XjKOf4XBHKRws8acO2aoiOp
 0l5faxVryxtO/KNmUJzfVanqoguKRrM3fTT4Ohb06D3msIyIPVF1B176WOQhKITKUkKf
 DB0hRgowxQP0DJz8+iZdQJJfbuIrxyJ4y+g1pL9K569u3v1zW38iyBZ6ubVSkV267RS3 vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfat7wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:27:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N3Ai0C125507;
        Wed, 23 Feb 2022 03:27:12 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by userp3020.oracle.com with ESMTP id 3eat0nv64d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX2JPTKJBAcExB9LYWPOE/Gcsk/KdWHadXRzkqZJBKVdoLKaIt4aPP1kxjbJKK+tEhQPNj+6/HdjDEOdRkI67D34ohUHqIWKlYuQr6GdKiX14y5EXb0XbOU0pvcW3YYoTY0DcV2BKVGZxi8J9Seir55R+koYf6rEXJvWrwkSzNJaFo7WN8cZz58Ybb/1EU4nmqZARda7xPhaRZizoSi3bbBYTrrmAHyWlCifcya+0a1FzyZ5HpMxMlVi15lghg0fwqP/TJr78EuRlw847Rr8TpyVHne18PFDpr+8nrnPlvxNN1NydAzsGBFHF2HzbO10Uv+sfCmRXorRoiLr7A70qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8dsiYNqKvB7ZnoVY39uRDEuNkP8YJ80ELuMbG3RfV4=;
 b=CosmVMYwo/kG2bdXOjgP+BXx9oeCF04T39VV3BZQATmV4cDE1r4gRijHYtxDOhtjJrQACEnWgRya6c2E7ILpJ/yiOsn0koZhW8kBO6xsKIH/0IaBUW/FmKQRuzTxvdogsD+5qt9ckjSFhOItyHIAHsHOdKPIyHrLvKStMpQ56Uo+vkZSsGz+60wAgmffzwkL8akBd8sh4YP9w/v52BipBHj0byDvGiky1BT6rUn6Woxf+S9t9cxZJ3dW2G8btMnI7mvw+E7Cx7C3KNCop5Ll00p0K37LMbVmyebHkoDDzpNjRiZOUag13Wm0DNBZWVn+ccFMOkGneMl/sJ/49ROALg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8dsiYNqKvB7ZnoVY39uRDEuNkP8YJ80ELuMbG3RfV4=;
 b=cC6LFmaR0ZNjHGuqU6uKCKdfwsiqvy7CqeR/Gp8MD5h6kT0kgTplDTF+AlUYAyK8k+L0JBSu0EcRH5By4pOU8JPfahXVu+koUxcOtatx3RiibJKiY4THAsFbfO7dbAhd886kWSS/NC+uDczT541AWlL08eNmlxMLO+8cUbiqHdQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:146::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.25; Wed, 23 Feb
 2022 03:27:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 03:27:10 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: sd: Unaligned partial completion
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r17ub8fi.fsf@ca-mkp.ca.oracle.com>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
        <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
        <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
Date:   Tue, 22 Feb 2022 22:27:08 -0500
In-Reply-To: <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com> (Douglas
        Gilbert's message of "Sat, 19 Feb 2022 19:56:23 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0047.namprd07.prod.outlook.com
 (2603:10b6:803:2d::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2300e69-3f1d-43fe-be9d-08d9f67c605f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB57770D843722C3AF48B932A08E3C9@PH0PR10MB5777.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLT2RiV9p4/w8tBVcxHm/pEI+iU8jqEgCKK6bu5lb1a2cgcOce6JYBLPP5hnn3Kp11UP3f+JD9dma8N/ktx4bPoOzognb/nvJGg2/JYzcvhJ6qjol3sWw/3se7vLYbTYw3d1FtitHrc3PECnMFdu2sYF4JqX6WiCQQrfR4iSacFxnQmkMlEvtK2fFM0isdwY96CJP69cbfUUe+WfSKtBSfLltT9gFFVgFeq0I16CnI8c8H30K4JW2INCae6gqgqL/Ms1SvFWdEZz0xvFlGmgVMNM84Hv8simscitVLx5kSd8Kg/aEfxMbOVRsIWyH0nOO4TeAFMAr8dthxNF6i3DtR5ZWe7EYUqA//k4sae2EJDxeFBZDUUgRtDZmwBGj/lsz7CjIc9WfcmeiVpDg4nF+Y69oHHUfkywlzkYut57KvF0q8PTcmeEi7uedmkfH9awub9U6/F/Zii1Lus+PXyoxwInL1H2wm/qKSZXbWuK753LZMefqz4x+PgHnbvuRGId7rXykLSQt8Bd5D0wZLDuW1pncSc2Sisrk0ppVAuOxwG1CflQzc6kmUh/52JipFmNSirtVxRu1m7x+kNMA/rhQ17zg/fQElTvL7vERRbBDEVmi21ZRMPa9u/mrpdm92xl7MAdN2ZV2sAGMKVdDDx11OQK/NGeuSclDKmNQNORsaGBVixaNHuKxUSvUuwAORu7Dp7nVi1LSCiqIXte4MMAaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(6506007)(508600001)(8936002)(26005)(6486002)(2906002)(316002)(186003)(6916009)(5660300002)(54906003)(38350700002)(38100700002)(66476007)(8676002)(4326008)(66556008)(83380400001)(6512007)(52116002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4zstDZACt7ykXdFh2zYvlHfaB2kEWH7+ReJVDCqXIRwy+Gu/atZ6RQtswHy1?=
 =?us-ascii?Q?IsNSm/JHIPmsCerL8DvOeBlFncpajZZ9ecpg8s2Vh4VG5JYNYRGIjw0g7hhi?=
 =?us-ascii?Q?AaiwpvGtSJLOsLSuet7/fyRSBk0pd0QyB12AehqEHVJgAqURkkxYf2l7eiM+?=
 =?us-ascii?Q?gJZ18MdrOsMIF+U9ysGccPgYg4S1sYK4sznpIjn+uhpNBqvGMsXqCR3zNeq7?=
 =?us-ascii?Q?X7DTIs2B4ZxwaaDb8NfDcB8xs74IZkIhoclsiUk56j2EVwXdbdIMh2LQxRJ0?=
 =?us-ascii?Q?aqy5vuqAFdoik89L7IQuBhNB8xrGACWJmexLm5PzkXBgRbWWCh7lUmSa/kvC?=
 =?us-ascii?Q?2eZX7CDquYAlTS3p7OoMeV1P8XHt77KhYGwPJobYZsVKr5g7hyTkwUHfCzvY?=
 =?us-ascii?Q?6B0nxBqTB2xqPyjf5LkgEF9TnMI5llhq4qFQ4YWgBh/EPjf13tpBFrCdw5xa?=
 =?us-ascii?Q?Pk6maiZVON3hnoOZVcS8K1nZxalf13cZFV9rx72pzWHNWdXwFcIQuW+ZgbO8?=
 =?us-ascii?Q?oDLXxnyynuzv5Vz8FfE0txZCQhwWgWW0XX/QrSQ2pLzST8tuN+WwPv4YBRwo?=
 =?us-ascii?Q?T2eVbaikrInDMAwliOtKiqvxf87gb44wW1DPbAWUdgEW9P5qIoHJr3qcAp4g?=
 =?us-ascii?Q?9JBbosEsqGmL+a85lNdajGoo1oQoMPImEVs05LK6z3vMYw1Xz81TqCv4jkZS?=
 =?us-ascii?Q?FwRC+R8bYg2Se2jIDYSop4YL5aK9/UuZqd+XYDdoCLCqB1oYY0ulPgKaBpJK?=
 =?us-ascii?Q?4pnPzoGo1SWElVKvlVCBysW2b2jh2SJTYZpVfPTccW1IcUVN5BD8zddyjVF0?=
 =?us-ascii?Q?Yp1s+olR28pdy4e4qsmZnJbDP8X1+Ib6UqIiQey8poZ8WGbfZ4u9rZ/aOiZv?=
 =?us-ascii?Q?yXHzNRzV0SKnNIDBZKTGmEJYYL4971Wawd+k9j6/xOzmfaKFNHRfvkGWcppd?=
 =?us-ascii?Q?shdJb3KOf7Q24VWSpW0RAJvMR1RJ0R+LLVSnXMs68UKReRKEYY+xR7aKaj7y?=
 =?us-ascii?Q?lefS1OXG4tpkaHr/lFbj6ZKkd4WSAHf2WuZgOjJDJYlVN+DPu6aD2X8usELI?=
 =?us-ascii?Q?XFaX2owYW/N0WOEg7gc9HeUcbNLR4DteL8U4chuGV7/YdUpfZkBAGrVqzReQ?=
 =?us-ascii?Q?ZYT+C48DiF/LSCa1Ke5PgTTWLdGU84wdgrQuAPDBHXqXXmcS52KY8vTRL6Zj?=
 =?us-ascii?Q?8SagHjS4CjLKeii3Sb3oKUM8JBuxUk8mlaRI0XYYNcS4wIgtk/pMjUDdBNfo?=
 =?us-ascii?Q?0jwo2WtpIJiGLvGCJA6RLHy72oHbaizmQAVWh9Qbz4pdJDt0lYAv8s4sdR55?=
 =?us-ascii?Q?jB0G+rYt0itIV+P1cjf8N+z3uFXKgKQFqm6N/XJ6k9H6GeinBzPi3DJ3+Tb8?=
 =?us-ascii?Q?nljexpZyM4phK5Bv8hADutatXQrrvsElLgEOa5VQDnZzh7xjD1L9c4pY/7DG?=
 =?us-ascii?Q?susis1152glxnjT5s55P62my8jknP1AQ5XPwJVyPEdtEaue6yWUOZueXayUh?=
 =?us-ascii?Q?tyCuiw2ucOdQcI4ySQ+UtRlSOisGf2mbQY98eO8gGVk2WDc8PNBcpuJT3z7e?=
 =?us-ascii?Q?lkM7aDV5PctyF2fhObdlsx+7LzogUpsi+s0YMuOGr85PiYdJS9sDE8OQvRvs?=
 =?us-ascii?Q?MvFjtb8PZkS3jmffYQ92v/vGoWncQYAw5AY+dYORxWErmXXjPBzcyAc+7uA4?=
 =?us-ascii?Q?7JdyM6N3E4vdmNPjVnJRvebJL0c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2300e69-3f1d-43fe-be9d-08d9f67c605f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:27:10.4150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSXvUZQj3ILNr4UCLGiP36IebxgjIhn8+CGdbaNsrN2i0JsxCLL8F5ZU3Ggvw0Xv4cZHAusTiK9qrqWQmP/3k5bJa7NoU579OJX5C5kBa7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5777
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230016
X-Proofpoint-GUID: gu4YKwWUzI3dzok6aGrwjhLZrLPhzRhh
X-Proofpoint-ORIG-GUID: gu4YKwWUzI3dzok6aGrwjhLZrLPhzRhh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Douglas,

> No, of course not. But the kernel should inspect all UAs especially
> the one that says: CAPACITY DATA HAS CHANGED !

It does. And uses it to emit an event to userland.

In most cases when capacity has changed it is because the user grew
their LUN. And doing the right thing in that case is to let userland
decide how to deal with it.

You could argue that the kernel should do something if the device
capacity shrinks. But it is unclear to me what "the right thing" is in
all cases. What if there is not a mounted filesystem in the affected
block range? Maybe the reduced block range it is not even described by
an entry in the partition table? Should we do something? How does SCSI
know how much of the capacity is actively in use, if any? Also, what's a
partition?

In addition, given our experience with NVMe devices which, for $OTHER_OS
reasons, truncated their capacity when they experienced media problems,
I am not sure we want to encourage anybody ever going down this
path. What a mess!

> Also more and more settings in SCSI *** are giving the option to
> return an error (even MEDIUM ERROR) if the initiator is reading a
> block that has never been written. So if the sd driver is looking for
> a partition table (LBA 0 ?)  then you have a chicken and egg problem
> that retrying will not solve.

For a general purpose OS it is completely unreasonable to expect that
the OS has prior knowledge about which blocks were written. How is that
even supposed to work if you plug in a USB drive from a different
machine/OS? It also breaks the notion of array disks being
self-describing which is now effectively an industry requirement.

I am very happy to take patches that prevent us from retrying forever
when a device is being disagreeable. But I am also very comfortable with
the notion of not bothering to support devices that behave in a
nonsensical way. Just because the SCSI spec allows something doesn't
mean we should support it.

> The sd driver should take its lead from SBC, not ZBC.

The sd driver is the driver for both protocols.

-- 
Martin K. Petersen	Oracle Linux Engineering
