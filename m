Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C27BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 10:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349269AbiDZKqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 06:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349278AbiDZKq0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 06:46:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE63125F8
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 03:38:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q982Yn027767;
        Tue, 26 Apr 2022 10:38:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jyZI6XjtrnjJRCVHtYfRhpORAxsSZ8AsfidSsmieQwo=;
 b=M6Gr/whPLWbxn7vhwMZ1YJXgJtqxQSqQjKRtqG7OYVuqRxwyud6tcXIJ9/hcrWI2hsDM
 We/3Kn1YkqX7PT+0ryFUR4Aa2m6OM6GYCW+j/yC5uXek+wBdk/s5PhWQJea4oWvyeRGY
 kYk7Di/Pqz+vXnAYqF8zDsLNrSxWyDCCZysbIS7612zRoExb4zc+hFmF2Djh7XmcScM2
 2rzW6r00AiUSkrbE3ZGxxzvNTc+OaNyCR3GUaCdNWJlBi5Lce51uwSqG1NDR92y6IF8G
 681ym3nBywTYAaC0CyVMD6Z2Ig+IUVFLzCM3PNLZv+9AfNJL8VmEb6TUAua2eDegkX++ MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9annk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 10:38:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QAEvu9004018;
        Tue, 26 Apr 2022 10:38:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fm7w367hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 10:38:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5vlUaVrEUOFi/S3AFCipcy5diKCgh0GYw4LssS6Ju1vk/Yr1QxGpbhNlCuJ67aIu3Inu1w+ej9HuaJcwOf/M0DAavObJ7dKGbinvH4UXMskXw5up4bK/ZgKaHSmaZ+wyC0Fe/OkWQewUjSt+CV+188r9iXzrl0Nsa+/XRUhXycAlvyFn3nTcyradQgeA0aeZmUwv/J5CyqDfor6BF+KGfkNSxWjW7FCFm+OzUf8JKX4vfpjWaKADNrZF6kXnTmN9llCTkZcRY86mbpEdm3BjsXh4L17UhCH+wYCT1NGpqu3i9hh9brUBTGrZDiyUaTnTJVlT3rybpe2cf0e60ZZxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyZI6XjtrnjJRCVHtYfRhpORAxsSZ8AsfidSsmieQwo=;
 b=mNo7eSXycSR9nH4yz7OHLYCouFLwZgJfJ/FLzm78rZ7jlEiQS3S7kHz0JCMO+gqywyry/Iy4YAM7vtFZq20VYeVNHFYnpWFDKIcaHdSfdcfLA6TqBn4Lcx7OY+5WpOpG73mww3O//9BGCOI38qVsoJLN0/1OQJLCg+XIF3KpOIrwHLUxsNLl5jVclmpnqt/WhuoL9Vk1ps55BXVkuX+NT0c9oMC7hVEKfeOVaA9qsuMUjxJjKchVlIyG3r2XSJLwlGQdt+9Ltc6rDfmnT+Ycm5TZ+6fZtxtcmoCNh0PSL7BRlRBltac4mRvxac9rWwmhZJLAhJAV+ccjVRKZz/tQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyZI6XjtrnjJRCVHtYfRhpORAxsSZ8AsfidSsmieQwo=;
 b=AiomM9Rzf0PDXdF2obUyNMuwd3FsMoa/PGBKCEcEuoMJL0NUFkaBBL0C6/zWdINHgNU1mELfqvgiraTXjqSX1fcYZWlMb3CK/3lScIVx+wIla2nltXqTPITwJQDYtTqPDuKHr/kX2DY292ae+6i4U8vl1wM+75TcwzB94onm8UY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB3574.namprd10.prod.outlook.com (2603:10b6:a03:119::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 10:37:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 10:37:58 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilqwuo5r.fsf@ca-mkp.ca.oracle.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
        <a1293ec4-d160-9ebb-d20c-d120b14e6da6@opensource.wdc.com>
Date:   Tue, 26 Apr 2022 06:37:56 -0400
In-Reply-To: <a1293ec4-d160-9ebb-d20c-d120b14e6da6@opensource.wdc.com> (Damien
        Le Moal's message of "Tue, 26 Apr 2022 13:25:30 +0900")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0011.namprd12.prod.outlook.com
 (2603:10b6:208:a8::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caaf1057-4fa9-472b-c39b-08da2770d434
X-MS-TrafficTypeDiagnostic: BYAPR10MB3574:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3574A1D79A4110C9C8C2330D8EFB9@BYAPR10MB3574.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+BBrljAt6lrHLk4GrqSNFrFQlcESwzHRmVNL+eHzf70259nzGgj1GUJ7ODegkGqKHyiwQNIWxzK7IomQOyZFLLSp4kw6mJMoEImNUD2qVVnZYnWSfvZXVqCwJQeeNkKxl4CpolEb5i9Duz6gIEBfvMBQRODeKyV31sCcXRWewF0Kb/XSRwAKRx8w3pY7HG5yZY45acnyBX3aWnfhzLUImybzfOprI6j3w1bEeRyT6Zqr7+UDbMdr97y6LzLBmstyaUxavjeE0AKxt36rAgUutAvsM1K2oGVToxtpdBUR7At4WWImMgNOOReQzaGnxGCz0wCVM21sTG5BX7OKUPCHNkBvjmUSsotlPgGtHmLBkNDkWWefpvd/dprYBYokGt/bHL6Z3sAMZ1hTwMBXoY9V0VHqY+GPkvbF9gv3I8YzRZHlrRy5A8xT/vhtkGvZJAmUPAL1PC8XY5L1hxtgfrtjxpLVkBQGduF03tbrpqktaF5EdqOuPZwWmgudRqLf5mrzD8JtqkIhW7rEXeBuLe8eb4Ht8eLeXiwGtQIMhIdGZvZkcJ7CeRkDsx0qwfL15alaiCnHH7jfybBwxb+zej6WcLtrOzpVaWtcTioJCL3GtgxWsRbC94wcZw7/hfe9zUj9r8mtcwKQE7Z17V2OJK/DOXo3qIPnhKKPD0v0aKUV6scq8euP0teHPpOwkfwtXUamVXiBF8erVEU7D2i5DaRKSu5yItmKTStZM+4QxUtTzTWO2T/ErgI/fTlfa1DwS4RJcZWNVbO6Qi+8r9AqQVNCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(558084003)(4326008)(6512007)(5660300002)(38350700002)(38100700002)(66476007)(66556008)(26005)(6506007)(52116002)(36916002)(6486002)(2906002)(83380400001)(8676002)(8936002)(508600001)(66946007)(316002)(186003)(6916009)(54906003)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IMwXNhpm7PxP9JMk8/2rkonBHElE5xiteVZUpIVd8tqns9wWAYaxLFRwH1VF?=
 =?us-ascii?Q?utTvsVFQcrqT2n4/+mQGFpyMFzyVsCXlc8JpjignJRog5rA7pAyx1iworWAj?=
 =?us-ascii?Q?x2VTguPASOxHo4ggkgdNhAjXWkiaUR8e1JnOs9NqL7aWfy0G8EncrVUT765Z?=
 =?us-ascii?Q?B+tdnimq6+WNDy39CqUJuw1axjA9Bg+dhzOLLzdm8ZLHDoWqNTfDs8eERuZl?=
 =?us-ascii?Q?4YIWi2LSkgSTSJ11KsYRwCSwICBh2UFOLWrLRKOHJfcaoPbJqWQ8Jkh/fqTp?=
 =?us-ascii?Q?kQl+1Db+6sk32B9Z6D3PHGO+F1q4B9xaFFwPlbMzfAs0qxqctT6czSbHqU/F?=
 =?us-ascii?Q?SPcKbRsgv/ER5baXBVwmAhSBYq5LFU1wJXcfahlsBjOEoRJ1uLYYP7RHM/I0?=
 =?us-ascii?Q?A3dkkc+Ns05G5gb0ujviASaRrlwWAJcbqz/nfkaEfqYzeyPOadj/4EPLU2kW?=
 =?us-ascii?Q?fi5QAWf21zWJxWIXNtf/telVXIXvZvkxTiDG3Ad8OV9YpIpCHO73/NFKXvHX?=
 =?us-ascii?Q?Kx5Lusjq6Pg9wxWfSZvYyfJfsHdnfePJOFmT3gKCDaA31/qYtbsxp8iDJt7O?=
 =?us-ascii?Q?81xaeWaTnBZkyXnxlJFoWjP9j18R8DGLdLikOKwwB9g1sue9wxEHydq67SmT?=
 =?us-ascii?Q?cgDwfS5f2AFF1dPUB2arGlTzwCtmh9NSSEprfuxVJE90Ns1nL1LAgxBd6c7G?=
 =?us-ascii?Q?QPXZo62TYY+4wehNQBCezb8EC0e8wviYAVBhwLGNXIrRPUVzqOlzRJWqig/c?=
 =?us-ascii?Q?JecER4HwVLSTM0sdpfbxSLUDTbk+uthBKXD12LA5vapyCJ5jBm0flOCuIWLw?=
 =?us-ascii?Q?1VxCYatfSlYUEbJjrfA4c8vKkJNKPU86onMxnitjS8iQutAh02nax+Q5eh6F?=
 =?us-ascii?Q?c+1PrPW/f5Fl7n84Dj/WUyUPpAudy0SH/d25v7k+V8G9Vr6YKrE8/x/JTtRf?=
 =?us-ascii?Q?gMES+LWVZ50PX/qFGx8SD6MxZ592MoAIqno+iXBUTn9jxsKiM3RWJrFnuCPk?=
 =?us-ascii?Q?7eEW722Ve/zFoqsx9bvQoWbqLRxv0p4q1K6KaPxcfe5WiORI4ngUtEQvanvt?=
 =?us-ascii?Q?B3Oh3z11nMo03/8TCnSrRlFujwR+AcQN55R89WEx2Ge10Ccy/sTaUbK7J68P?=
 =?us-ascii?Q?60jhf8DMvcLrQsyNxXm37b9hzh+Nb+bxQstrsuGzEth4WifS5b1jrzglFTRI?=
 =?us-ascii?Q?ZkJRdqRT0vfRcPtnV2NNQCO/FROO2DjBIn4QPC8Fjg4qkqTD2NT+aeQ1hz7H?=
 =?us-ascii?Q?92EJj9EXtlWSPUrNsFsjNX509aRZv/tDpaUPNaDzprNceZBkmUm7Rvr57ijt?=
 =?us-ascii?Q?c6BCrS0BObPnZA1I9Usu4WTlev9JPJjsobwvH1vQoK6a578DGQLYjV+Vr+xC?=
 =?us-ascii?Q?URxdnvfSV/bYHccwusBhzZ/5lE70agA/S35RgtRsFQKbhbR/L82m9KkQK4O1?=
 =?us-ascii?Q?gTEmiYsOW1Fgzx5N5DiM9r0WNNAu5OLfE+lzWvvnRmoqHVGjT4fIuNQP6C9O?=
 =?us-ascii?Q?l5/78qs5MvZDnXa88D+B9gTjYIXCNY9jfs750smLeP+y1VWCKLIXYHf/9qBU?=
 =?us-ascii?Q?sJuMwz8wXjSAc/fikqnS9yAMzqMQdW/lhxKAedXBHlIWxfBRs9yCW/NDtKe/?=
 =?us-ascii?Q?fsDPy1WLos8cJRcRAcGycfFhqYJj8VjivK68SWDTllEl9iKgRhZ6d6RCsXnJ?=
 =?us-ascii?Q?g9/xo1qmCHZTcepQAMI/1HBnC81EyWDUPtfdnps3ZmO5sj9vQDDa/IYrMtQp?=
 =?us-ascii?Q?Zrfj4zLUQRQRHALozDD7NUkRsJpM0n8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caaf1057-4fa9-472b-c39b-08da2770d434
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 10:37:57.8893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfJazLnTxFv2CChZ/ld1998VJdjzV9dRBnc3hsBDOvMcC5UdNjhAFJx8r8iz5VrkvvzgBivU2sSbLkq/MEtFVPgwXwEAiNXwjPtuQ8mZEe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3574
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_02:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=659 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260067
X-Proofpoint-ORIG-GUID: uCv3vAWpTAYuIxpTkQHVplUNZw89_Lwc
X-Proofpoint-GUID: uCv3vAWpTAYuIxpTkQHVplUNZw89_Lwc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Can we get this one queued for 5.19 ?

It's already in scsi-staging. Had some mail problems so not all merge
notifications went out.

-- 
Martin K. Petersen	Oracle Linux Engineering
