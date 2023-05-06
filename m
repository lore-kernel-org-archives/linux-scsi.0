Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBC3C77B7F
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 22:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjEFWtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 18:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEFWtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 18:49:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E419C18847
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 15:49:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346LIZCV021741;
        Sat, 6 May 2023 22:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=GrTzHrDayoeg5NSb5pcrKHWUdiFpuEcHPIns7d/qLuw=;
 b=4SThai0xxuiCWLE/I+6Aucpi/uXeOOpbt0mhhwule1Qb/mTsL6h4F00fLj3YCkdwS57x
 wr7whGLRv3oGSUdTNpA4bChOAVFFCtcZzLDS/1WBVGeiA5Ib9a3+w+pH3HbGXoBQBoMm
 2dXNmg+gx8iijcBcCu9Wqsh9hKcG3lmhiJg4XWL1RLRdFBi2ej6imh+LTW58y5AYX2nY
 QrWjGEsPvjBP/H3P/3CJKzeEqwX2B0F84+kQsQD/cTnLet6/UWBf1pDph3JIsKnYXa+0
 OxyTDiINNcz+OZ23nOhb8iWLrEb5sGWX+EuW4cO7OhgZ5TaE8U7pZoMlKZKp+NC5s8bi hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qdegu8xga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:48:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346JURNY037486;
        Sat, 6 May 2023 22:48:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb9kuhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:48:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVpaa9aJGcJqHzQsfvQwIz/AVIskwh4vjZlMJCW7bMYaP8FX1TAXi64Vq5JU3i3D6M126d2a2dJOfbRdzzzkD2WSJmawF5XgRtAKulCJMADXSOm6Q2T9N2+pLt4ydygOala/ku6OTrTdyoRiEWPAlISbambgLP29h+IXITMiJ6Mca+xMnnHmgoqZYZoG/gWi9vtiMsE2KnLiMcXcWmtBXKzgSSBAK+F6k9ivmY5eRJsQNfMEdsyjdAwVuVCSYmrpJvgA2qlXQKJcNHOAj7icPIpCJa6KyC3kc98+HUQgXR48XgBI+u7+0Ol3TELsqPldo0j6N5AYUAggHK+VRStPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrTzHrDayoeg5NSb5pcrKHWUdiFpuEcHPIns7d/qLuw=;
 b=DeaEOSBAMekIRE4Ly1eqqqny+o6WoqJElWeM1LEVgpW/ZQ+XoLI1MqELeINL6y5LXPq24dSvktL7HGwAfko3M+3OEEi1M0Cs1nr3toRprWAF9IhTQy7xJquHGpE9WH3R5iTnZ3yHAFQkqVgGKNOzmeRYGyLfaXWOYI+6EYXrAnG97AmnpPYdFZIXRSrmFkSBj+eEcR5e5NDMM/kC7ugZZaQiahW3osrjWO1KK0fUQJJI2oJUYZpkjSfTepgfUT4goNJW9p1JRhk1W0jJrNxrNHofIscSvDnVJof309ID3IE+HSA1jTTND/QXu9UmJZ2g5tGd7HmjpOpNjjOoBbrC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrTzHrDayoeg5NSb5pcrKHWUdiFpuEcHPIns7d/qLuw=;
 b=ACbzWCBWrNpFE4ZiS+ciXF9R2NeV/CGjoF0qpGRCxjn3Shd25EQuver1ZglcVfv7h+o7ghcMfjJ1umfMh3i550uT0zi9OCqXVNexDt7fEV+AqmG57DRqvwpMbadNmEiCFoS2rCka435b5xZTtcRlkJKC170p8IDNgVqpkeRyGJk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB7526.namprd10.prod.outlook.com (2603:10b6:8:17f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 22:48:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.030; Sat, 6 May 2023
 22:48:50 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jop2i2g.fsf@ca-mkp.ca.oracle.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
        <20230503230654.2441121-4-bvanassche@acm.org>
        <20230505060145.GC11897@lst.de>
Date:   Sat, 06 May 2023 18:48:47 -0400
In-Reply-To: <20230505060145.GC11897@lst.de> (Christoph Hellwig's message of
        "Fri, 5 May 2023 08:01:45 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0032.namprd05.prod.outlook.com
 (2603:10b6:803:40::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB7526:EE_
X-MS-Office365-Filtering-Correlation-Id: 153c35f0-846c-444e-64f1-08db4e840f10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Cl0dOspIDwXR+glwxj9hUldkzP5CkB2WDwAhNHwxgg2TA2kOPPZ/mui1Z7gzzljG9X0TSU5wtka0Tux2y1VTMyXlcze0IAhiN9KwK5ikQyZlV8+oJQdSTCUIc3LFgfyLxqJ7tDsJPl4LE1NpV0Tb0tEKmzy6dHd2Nk7E7RX8CkdBqy18xL+llmfx/+IBu+N+AoZZrQmjdrMdyv5rBUwg74IHYTRToyBtuGQBK2Yr6fIcpfu+G5KEntMaGQqtIgtRUQVC9vTwG7PWO/YHzamydBivyiR/kpqhx6qcAtVGMglVpVL8kCiSusrwUeuRUAdBUQQkjmDQh0GZKYeH3GXDME4xdDaKlf1NnOLoSrAjQL916EF+nfotahr+28QKZIVJxO2FfWz5FzU+ews0fddX7BX7xTGOB4kn5BLpzZbkR1tYiq84dlEKjhM5ep1cWw280+pH15pPllXiowVaSdL1cw0Qa5zz7Nz281T9dGrRtG/+GEpXVrGpVTBtV6Vo0gqYDmF7Uper4Wg7ri3Eqn371e/oBZJm705pTKa/g4TNwWinLW+M5chpKVqMaXH07U3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199021)(41300700001)(2906002)(186003)(478600001)(26005)(558084003)(6666004)(316002)(6512007)(6506007)(54906003)(86362001)(8936002)(8676002)(7416002)(5660300002)(4326008)(38100700002)(6916009)(6486002)(66476007)(66556008)(36916002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XwF38avLB0Dvzy9pKdCn3NLpGrfq7xh37v0mq8LSOIC5bdJiUWOEhpjil4kZ?=
 =?us-ascii?Q?tKd2AcHtMWwAT3SxLSAGnBB4xeq7dA/HhF0S+PGGGdLEw7/j/H7Y+CSNvI4u?=
 =?us-ascii?Q?gjU6aloBg5Lw6nQSNXB/k8hJgg40L7AiXr66ydzHFg5pZ+VYbtJ5YDZub+vl?=
 =?us-ascii?Q?vGPxruGZfncorCCTWU0a3JY72OELUBQrLZvZuff+Pu0TtAPtsCxHbEnCTH2W?=
 =?us-ascii?Q?RlcXVXdhDWMmzHGYorOkDWV6CNEwMK7wtEmSnyx2/D9lbeIZMRQOCHJxdhDj?=
 =?us-ascii?Q?VwLStgldvvUsQBN0NdNiQIEw32Vz4+nzjpPuuX4ttB90nENT3+Dzm71WDIft?=
 =?us-ascii?Q?IGvJm58+pt/V4aztOP0H/Or4X39F1JscGr5qpMis1gyxs+iHNmq2wW8FDX2h?=
 =?us-ascii?Q?xGxbn4P/ayI3D0vGZ9CXIgHvKbuJctXxjjehBID7fgx/2/5f6qEJ58Tv6/2K?=
 =?us-ascii?Q?zIQief81i6ylKo/cbufHbEWqfmvC/6XDzD0a9P6vVZl6Y+7kctFbexz9fdyj?=
 =?us-ascii?Q?Yq1ms/j77TfdDwJCyHuKca6MgIHdiEJK5Z1KcP0H99x+2h3vxlIldJPpMGzQ?=
 =?us-ascii?Q?T8W1uzotCHZGW7Vi0YDbWNDFf0ijrKbXoVGgduiJQVefe8LjGygPgc4BF/bR?=
 =?us-ascii?Q?MCrfsNYczSANvYWCEVmCsyPoxmBJa8OKysHNrdVMUkKfoJQjZWB9/yMBz+3I?=
 =?us-ascii?Q?lIIg4+X1Wf32c+OpMT+DsWDmxypzTL1pSAcxpJ8FQyHO/FShrNplJZOHrtP0?=
 =?us-ascii?Q?nodGNw1aw1vGLke0OhAEOw8mOVAZk/kKdZekgkZZQGuPDp8XCtk7XC9f688G?=
 =?us-ascii?Q?msFJUuAuNQMOaiy1jKx3rEqjgEeDGmn9iHG71IGz+eJoUflVK5rqNSJKIjyF?=
 =?us-ascii?Q?Fk5WwNDENPfoSrtYT/N+uV95XG1qlhAIxTWK5XD/M76CZV+wXAqeojTpUpT8?=
 =?us-ascii?Q?yNAG7xM2yd3db4huK5V1yHw+T2fx42/a0903D71FLKzhgETs8vw80APTYIR1?=
 =?us-ascii?Q?pqoPzUbi2f2SKoL6fQlHRTd9jSx0eW8BPlCeqJvsulyFiU6/ezWlb7AiIwuD?=
 =?us-ascii?Q?b2lG0m9KZ2qvuAVX7DPAfjAxOdGXwn7Pd9U45AeYJN52idAHfp0PVHRxmKfH?=
 =?us-ascii?Q?XuYnYziGphOBeAJvpBOwqduwuZ9NOBqfnQife73cWTUEzBNJp2tmTHslWzf2?=
 =?us-ascii?Q?eXFlvDRYzhsjMDmP1b2MEu1xyPQ5AZb2U2227uwfY+wdg0nZj3Mig08WPVEH?=
 =?us-ascii?Q?BKcIOyqK6sNlrB6pj4PRAHPF3h0K+vaHAHTx3xvEwwZ9fKwkf0W451kwtndC?=
 =?us-ascii?Q?APDOBMME/tBYGxm4/f+xZu5wXgH2Vl8eDZrCCftiy6EkyJwu4x8qjO7vOWRF?=
 =?us-ascii?Q?MyAChnzRfAITR4Zs/JMh57pW9YS0kFBlv9YThZL+jwNDiTyTMkZ79qqspM8j?=
 =?us-ascii?Q?5Em79KN4ahyOYE6N96jK8W7eNkCr3KnqFU0BE8Ld+pPRIXDMNDU5+gFuVnor?=
 =?us-ascii?Q?Qm3doE2e0QxKiZeL8SiLhCgoB5QG5e13Eo8zl1JliObvwMKFGl3P0+GRazov?=
 =?us-ascii?Q?aY6GGXQESj+hRY5yKqkOzRk46mW7UXeY9cYhq43MYstiysLYK+LxkCsUFFTV?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?bFsKJu3QXDA2pX+mD724Mr9XdRjmN3XJKR0VfDaQ7pxqiWRHtLgtav2Ea09R?=
 =?us-ascii?Q?+MnHuDTqLYsQQrTcEE7jW/44es14nf8sGF3iXh9z2MtdWklVTHLW2A+DeP95?=
 =?us-ascii?Q?smLGsfSvrCjMhIuWskhLZfFG1m5zAiX+CUf4wSUPABjzeowYRXBalZgiespk?=
 =?us-ascii?Q?YpZQ7m5LvEZKXMY8bCS0pcmYfYPRjon55deNggX4Mns2ftJYblmGJZXY04qb?=
 =?us-ascii?Q?Ax5r+gBcMRfXIhWyZ/2uaebOjfZ9xoIZk6X6aCGYvbjtkFZNzDXeFHcyi+Nz?=
 =?us-ascii?Q?sxnFCokk3BX4BMYNvKaLiFU5aRu6VKzKi0GFkTUvHcZU1TDg00d+uX+nhXck?=
 =?us-ascii?Q?OWR+FDpQ0Z4bDzpqfsr4p6zkJ1/pYurkv3tCSTFDGwM8nDD5X63fosNqK5Nk?=
 =?us-ascii?Q?WkDMfs1vq5cyUxk2mfEjxhqIZJlEiTHOR2GlnaGJBLP84SkwmzW/EwTjYUXv?=
 =?us-ascii?Q?6YsQecBrUyBKKAnArJXYT03ufgjC/qikgb2h8PpM6XjFJxYV0t35Y1RPnfZG?=
 =?us-ascii?Q?L//xhSAWMW5RDWlpq76xnRPMY7BBHi0r3ebEGGUgbyKpajB4uzZBOTG5yCsz?=
 =?us-ascii?Q?mzsPoHrwKyq9R4yJYzTKprHVwPSmJCFogtNv8dnreUZNF9HCLTv4j9njYn1p?=
 =?us-ascii?Q?luSP1ASraCv0oUV3sHlxmobFweLaOR/EOo8txoTasZPyhLA5OznkyB5eTulI?=
 =?us-ascii?Q?cQiBdLJU7Oa1x8icKk3nbWGj420khWKP2Jq8LZAUwmnUEjP5ZrVBFExFivg9?=
 =?us-ascii?Q?AHg3Zle+Jc+/2njKNlpT3nq3xw2hs0Q9wXRLfzxaGaor+dKlqBBvOSpc0cB4?=
 =?us-ascii?Q?NU5PhxM0QzmrJF0fpt+AA9ywcwXspP5W4W8fOhbDl5A+PM68MZn4z5iYCMed?=
 =?us-ascii?Q?augy01w36mIZIKK0d0QdX22Hhqv7Se5xmC8S0Yz17hOF1FNJvVOYBJEsIDwl?=
 =?us-ascii?Q?LEAsTiWd9tIa0H2IuZav2A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153c35f0-846c-444e-64f1-08db4e840f10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 22:48:49.9325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnqf18OlqXt/XplrGtlYTz7MixL5nnXMKOR6ly+aN7Q96R2R2AtW01w7N4RDii1El1cOPpDdcT/o4JChNwzfYyPY5ZHRmeyrlHtw8dGryMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7526
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=905 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305060178
X-Proofpoint-GUID: ZMQF5Mc6ZofxWsJEKHrL-U_6Obxkpn4a
X-Proofpoint-ORIG-GUID: ZMQF5Mc6ZofxWsJEKHrL-U_6Obxkpn4a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Although, I'd also love to see pre-decoded ASC and ASCQ codes in the
> scsi_cmnd at some point.

Yep! It would be nice to have these readily available.

-- 
Martin K. Petersen	Oracle Linux Engineering
