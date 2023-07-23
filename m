Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C68C001DC
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 19:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjGWTTE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 15:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGWTTC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 15:19:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084101BC
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 12:19:01 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NIvRUj010296;
        Sun, 23 Jul 2023 19:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ah3MUblsaPZcok3XmPke5mUElboqQ87Rms38MmIcfmM=;
 b=ELS5Jn3oWNeqVDCWZpNcZrCjxPFnvPsC3dEi/Ba66kpG4Vcosa7QRoKVgb3wEK/nVpMw
 lfBviDfPI4wYzAf9BUYlJ5Pl/wZUNDi8cg0o5Vrs3CWEndrgZqF3jo/4xnIuP1VmqIbn
 sRs4k1OvuEbVa8DqcjBhM2F43gPiIIH1+rEJAxWlASWyL6hUsAtjqaTz22r4dPQ7GJZ5
 UpaCcPiJsXIgLqs0OD6yODpgTHfu7gsROTN5SSY6q3IcEsxzJzt5+lO2w6b8yapUYRCb
 ykX0Yo4PNXLcS+Ercxpof6q5xp7d0Vof/DndLEzZhDBnubayhO2LuLT0yH701QZGh5va iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qtsfhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 19:18:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36NEeiEP003821;
        Sun, 23 Jul 2023 19:18:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2nwva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 19:18:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrlX3WJwg753nvi5hblHY7ujW/Q+yl/9/P6YMfoXtJajE45I8CzZNS4M0fCXTYzokhQaTPdcsD7MrtoTZQoRpUVQauQPp0oHwyLHbQhzSbiO0d0440icA94cx91oXNLU4cNS4XvSprPYpJ8+xzddKHkpY42xSQnwVg9Lhsw254bKTV/ERo5GoxYh0j2e3IQTPeFxuB8KOUVwlpIg/9SX85i0yHXWGzJWEdVDsMp/OkYZdC9BxwA3s4cJu7q+ug7w/AqVuK52Fekfw1vWSfe3FUQATBTKxojBjWZDYrY8qJ7X8FBo2BmkALnR0ECzX7cPeNvONX/NB6LDtt/vMeRzbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah3MUblsaPZcok3XmPke5mUElboqQ87Rms38MmIcfmM=;
 b=BB3QXdE8IU3jqqgdkVL+pTVlupJ3Ml/g2B1BptO88+EzExjGznSK2BSUcflWnhx6Gd86ttw+kAsGTLGUIPUOAQKgutpy8C3CDEXAS/Zw+AttFv0JmsKeuIf6k2GE8nxhJxlf++qSNTgCP/3kJj9tAKBzo8CChcPKZHfhMzqbUZS2pF+dPuSVrbGL8RdZbNqpWQN7EjTTN1vVVwuyRucnRySny777QTTbhF8zijrE/yWRPKVeYowOWzCYgw/KiVhRuEQiNbRtMlRTquDh3Jdn7+JlYvHfHrmhewB18u8BVwY7/LHPXc+CDkYoOHg5p5XN/i7ytsKHozQuw9TSK+ou7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah3MUblsaPZcok3XmPke5mUElboqQ87Rms38MmIcfmM=;
 b=ZkgaaPC/hL1KWZKa0eQUmU8zsF/Qnki+TNubsGuARF9aqYNotnoftKPXVdGmU1rKtiX+SzT0dpWrkv29af34yw9GtkMw0yzsQQD1QbmbLZjdr078QGMTVFlh43CwVDMXK8rfg9P5Cg3wkoQ6Vgk7Ay5aT4Rw6JTYY+buI2L/Jfk=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by PH7PR10MB6380.namprd10.prod.outlook.com (2603:10b6:510:1aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.30; Sun, 23 Jul
 2023 19:18:45 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536%7]) with mapi id 15.20.6609.030; Sun, 23 Jul 2023
 19:18:45 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Some misc changes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17cqq77xx.fsf@ca-mkp.ca.oracle.com>
References: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Sun, 23 Jul 2023 15:18:43 -0400
In-Reply-To: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Tue, 11 Jul 2023 11:14:57 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0069.namprd12.prod.outlook.com
 (2603:10b6:802:20::40) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|PH7PR10MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a55700-7a05-48d1-706c-08db8bb1a24d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CwUdRkZvMTXAyVUak4FRTxE/kv+zDCAR32LWj9R4UWorjBPBY/vbeoIwAYaU5f2aJ5FvExXJ78SFYwo88hm9l/REmG78ZAIHKC+J1HPGo9MIBD9A/uPtqxXkePd3c83Y0annfUDXwhi5MH5SVGODD7Opg77zIJ8y3Ji3uq7WkizEMYb7z1na890WgW7Vo0EUJEpG4ASGGcuu0RlpC9NH7HSGNO89wv1IaXU2888ErjmbfAtsePKlXM7GYGHsie1uxg4sjdWrtM5Fh2rIYUjPEEsoLlopfYLZwoS5Ukes9COum1qqtmWpMpn7OgWzRMtIpxUPEo3nBAFBUf/DYstllhXDnchzcBvriPTU+YldQdcyrSBKdh6usO1XhocFPCTwqig/NNFtdfhGkeztlSxj4ycKo/6eJldi2Veorv9sFAeR7RxX7b0YIL6q2bmpHQHfz2aKoJc0q1e0yJm0vuVVIoxYRJWjTvymaU1jOn8BbdsblnTFV0ii6nsrX2uJ8NS0uqEV94wpze6kdi4YROQjg6+y8x6Av29JcQPkAczTRsvGSQRJmbeHfsA94TNJu1c0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199021)(6512007)(6486002)(36916002)(54906003)(478600001)(83380400001)(558084003)(86362001)(2906002)(186003)(6506007)(26005)(316002)(38100700002)(66476007)(4326008)(6916009)(41300700001)(8676002)(8936002)(66556008)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/zeOZMIIBi42oLNVSr2NDon9AdtChRGwAUjp60oQnOt+UmzM7PT6EIeNGdK?=
 =?us-ascii?Q?Wv1nWj8J4NxEHNTnoKnFiAN0pIu8j/PyqqVyIn2qiTw7yd7Dx0XiJ7xVgm5k?=
 =?us-ascii?Q?BUrs9zzno4w08E+VoX+uEaz8/lthBUEG/zCeioHlkOGyNTwaTO98ytVr1T6T?=
 =?us-ascii?Q?qbsc9DiGQmf93ZeEWWxgQr7sRKNQLIpDw9o2ZDsZqBLI7Sd9lewqmZnXTO2g?=
 =?us-ascii?Q?3/+4UezgcM2SgsyEmMUCg/gx/t6Qe7X5zY4nRrONqxHpySRP5YODJnsLYhvP?=
 =?us-ascii?Q?T4vIvpBEgxr6cBmlD0IxViXsW6+G2Y56c4UNKAopbKwcf97XrGE+R/uANo91?=
 =?us-ascii?Q?6/+UV+bNP64bCXlRVRyCNaF8MCaDAhT75ZMsT0VJZppoUyUd0xu95XenC67F?=
 =?us-ascii?Q?XhzXart1D0rhnPS8HV3EfaN5efb1QS65OtZM8PKe6qyNGGZTWaiwdDMOw2WE?=
 =?us-ascii?Q?LVy+HnhbzmE5X7BnLvNeBm7HcTV1JV9lFWHd4VnxeMfW46DV/K7GJCrHEqaT?=
 =?us-ascii?Q?DE2cXRbbdAG9FaO6uVOUKYTr8jbBbK1HoBfpCcgms2RBgsQtCzgQ5z3d2w+h?=
 =?us-ascii?Q?az1clB6IG+2kRpTAZzOOqyxGY3JWs5n/IUhRd4y/Ces6Y6ejVivyTO42fmUd?=
 =?us-ascii?Q?vhwDQ4ymIuXxUMmIx138ZaIoo1Uv9MTDU3W/0jjomarKTuXRcla+XTPuWx2s?=
 =?us-ascii?Q?b0lKhEdeqNAL3y4vqU3iJW4mRJJV+8Pj8fmHCBwkAAhJcjLUjCfqptpxEAIy?=
 =?us-ascii?Q?6HJJt9apwSeHUo75s3MbkPHWS5r/zoSVnUexn7BWI+j7G75gifvfHe2zMy8M?=
 =?us-ascii?Q?2dP+KLWNZ/nEmj3U1UfuVbRCUOKKensvXMt8riGrgQqhWLSC99NHIzpyQ6RB?=
 =?us-ascii?Q?buu3FHM1KI/78R2RwqmFyvlVIZ/lqJqgGM6C4Nov8GowfCmBmBq0CS0jyXcH?=
 =?us-ascii?Q?5qp/oJ5QjznLcJAlS8z/FcNB91GU0qT5hAGFyu0QUDNSjROFeOCLvpfVQJ46?=
 =?us-ascii?Q?x9GsR9SN5xS7+2Pb2IOtWXUawHcFdQH2dHhXGvJeonMZ236rApL6rlwG9+lN?=
 =?us-ascii?Q?5XVrpw9gj2bejVkepp06o8+Seb9Nuba0mkyWRE/jseay0kPeRE/GkT/2kAP+?=
 =?us-ascii?Q?cXNU8BsTt4BhBkLJji3eSKPdp9aN1VHpf/YR1q8j4qPNqmctohauMPLWMDmd?=
 =?us-ascii?Q?68drgt1kdE55OoAKCf9cBBz8VQOV99NuH6GHK+i6Y3KG/8I7POeLwfjpl76T?=
 =?us-ascii?Q?9WrrlBi3tZj6m8bDe20m4rU0vrbvNVOOWflIHdJR/fG0AGhOecA2QPFw95j7?=
 =?us-ascii?Q?v0ld73rCde5tUVT7pFlpJfVs9UUdgW1vXOx56O+KC1lMlE0M4NkGxuYURJP6?=
 =?us-ascii?Q?RUlLHel4UNfRtmIKGxfym4XJU30TDvbifK4U18l2j+y0F66a24HAfM3BDJJs?=
 =?us-ascii?Q?JTxJngJ3WbymHYByhhq7CSFg3T4wSBvEe19ruIlbTKMJz4wviRwVH5afHeu4?=
 =?us-ascii?Q?bpZXzy/+bG6tlmDJbOltcWtvEHI0NI3ZJ+gsPptynEfbvV9T/oya6UHlDQhx?=
 =?us-ascii?Q?8f+uIWCzfo7NpzO4FUMFH7TD0jThy4xDVuh/q4nwZZPQeZ1vABNp8tTiQHV5?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iQzUA35iQiG9cGKc1D4tO31WyJ9Dz5Nnl5IkMUfgWuntYOAjrprlqcW75hrLnPyIkyWdarwGs1Oeoj+Y15q9JC2sNmmqRhkPDqfxL/DXnyteuQoJiwcU5Yg4cb4wK5sJ5CdjkTAyvJM+uqkktEkLeQ8t8ES538gIK4ujo3/QhTmawA7/Hswc5MH8D6/qCG9It/pAwfn2Zp/qNiv8y10PrmwzHRIiGR3/IBPLOQbbyFVr4eHb7BSCRacGtVzwecah39JPOcOgKga3/WjrIYKQ9xDvaXcVdMZF8KDFe5Y0omocuYpHmdMq2VKqtjuVpy+nUv5gKo3F/HOiZK6CPqMz4sD/Cs3O4t1SAeLzD18KYL0jg2hUkbBuIvBshMlgg1oar2ntK5pM+Ny7svpn/OqLhrMpKLtw6rrcynpiQ0qMynwOQf04kZE4ISztAyrI5Yyp6FVL2I2m6HBd3wM6UWu8DQGnfv/LCmlX0uak3l78zAk7FlmWaq9tHL16Gae5NkgILlfpPO8mfy2KooyJJRt8IG6eI2dThWw5i/lgFc7htEMYhPTItLaCxCZiUCR+aP7kZM0Y8Jsx0RVmhWTMgrirlQ4qrVkfgk/JQFkUt4Ynhju3UDswGsZnuL5WuxwcTF8op0OBuF4DFgfPoNezoytKeWwOorcFThfVd860IOIVOJbhN1K3ovL0xCkyLWaqE91pPkJDR9rO2OA3kNhoceaz1h7VKG5QVqZmMI5iEC+Fg7l8Ik9feagjbeshLw17DKPgGS24jcppTJFzl9PA9K36KFTeycbx7rqQoKpHTrlak1l/vlVbxWN5vl0Lm52TzkjkhqZp7rQaflKAijeXZ48wB6C5O4R+3Z4o4dNUQtQ+W5/u5fHrTCYvcTRPgWTwy28t
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a55700-7a05-48d1-706c-08db8bb1a24d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2023 19:18:45.3427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7pCsOFZCBP1lKFnD3zd11SqxCZuHDmBY+Oj5JnKS0tLfk4vd1zjOyXsjRKBvZ+ZvNmvIgu4pVJo35jicdEouoLedLSIsFnfKE1fXwyAbI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6380
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-23_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=962
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307230180
X-Proofpoint-ORIG-GUID: zqtqztqOSHQBPJ8m5kc3if0I2LO1ymSd
X-Proofpoint-GUID: zqtqztqOSHQBPJ8m5kc3if0I2LO1ymSd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> This series contain some fixes including:
> - Fix completed I/O analysed as failed
> - Block requests before a debugfs snapshot
> - Delete unused lock in function hisi_sas_port_notify_formed()

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
