Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F84C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 02:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiFBCjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 22:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiFBCja (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 22:39:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C875D64B;
        Wed,  1 Jun 2022 19:39:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251NXnJB021718;
        Thu, 2 Jun 2022 02:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=D0X1jlHfpKUcBw1Kq61N4yQ7moqaFPp4NyMJJriN3og=;
 b=NhX9ErvlbmgZMH1KwCoQ8NCsK9oZECAHXZ/g+QimzAc3uvFWViDZ9Pls5iVCZTNmEHSs
 PAxC0ZDP48FL3QpfwzjP+v8doVqZAGJUQYTVETHsKTV/JZaW5GwPzsHVNxoXB696WMKs
 6NS8vRb0FNWopMICDrZo9FwZKhridauEdoRppaVOTRxAwYgdNo29ue3/vyhuT/iRXI7G
 qA31BpltvFkCM7sSM6euA795MRoSagwTmH0EMxkPf4JXACONcJBq9rf37O0Lv2C5j54w
 PPxpbixoxDwMV9HabAjDZ4Vetl0INed4rGY2Ayis/Yd9Qq5xfjxYwo4uvihnrbPev9sf VQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6x99cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:39:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2522Fwit019828;
        Thu, 2 Jun 2022 02:39:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8khmj7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:39:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFBf1rtuNcrJKYpPhkExNNb7eIVlTMQg6UUBqrh1SFsaiHBftvxyc5IhhGmTgjgOtI0Q2OI7os4JJ6nc3XQ+GP44+oA2Wm8QPV5b0DO8gyfNU/ig7BZQEt2WaHGSrxnH46Vv2ZyNUqSbFbNpKTrkkQUfQnBndiwk75Pg3oUrAQv0SqkQx3D6j3VqTHz6kGq/fMfWnyy7hDW9wuRRBC7bwl6BXV3hZ0irf3PRXzcgWtwMr4C9o8H6bX5yMNwErlPSqspjTF9tZ2dVJcNHevoZsTtE3wrsEt5IIDgvajZoALmpZE+mYT+btJcU5NiXgc5xUpfIPcOxZ/RJLF+56glFvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0X1jlHfpKUcBw1Kq61N4yQ7moqaFPp4NyMJJriN3og=;
 b=QAb0tPkqHpqdR/xZ7f1QzUWa9kmm8n7cBaPo1tc2lEK8LDpZhzAZB/eqmUXjAO3uIVl82Zg1sbrZZO7bkMQ+oxfXiYmHB/yzzIfZ3ZXyLZ5Kd+bVKxqD+J17e4rsZmrDDjRyHR4/AbbCO99dpfY+++3Hf/l8P0tfEPFUqH9lRZG+qznfLo87h9xI/ThVWorabizrrapC+ktsTsFT+RZMYGzzDTB64/NAd+e8bbUstkby7DDWZYIb+3IG7ClpaLGJgxlaheScMPFkV8B9lJX4YK9VEyzr2lDtqZSj+Jb4t18dqs6xPei0fiqOlNybuA5wfI6zsqSlN2e7EafLYdFSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0X1jlHfpKUcBw1Kq61N4yQ7moqaFPp4NyMJJriN3og=;
 b=Dn7CzlZTL+eIkqMyhSGGR2nP7jPpifHfLPhbmGwpxIVIgq6Zn0rE8K7eaF2utfmri6oZjrGTgaMkipoygBnr2FldaNLY5Ch9AhuczBDovFtCWkT9y61Ics5stETWYiiv7t/3QN/4pcb5GK/DXo4uAQCk8EXMOH+1LgmbC9IhXBI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4315.namprd10.prod.outlook.com (2603:10b6:5:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 02:39:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 02:39:20 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: return BLK_STS_TRANSPORT for ALUA transitioning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rqf6b7h.fsf@ca-mkp.ca.oracle.com>
References: <20220524055631.85480-1-hare@suse.de>
        <20220524055631.85480-3-hare@suse.de>
Date:   Wed, 01 Jun 2022 22:39:18 -0400
In-Reply-To: <20220524055631.85480-3-hare@suse.de> (Hannes Reinecke's message
        of "Tue, 24 May 2022 07:56:31 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45325a09-4fa4-4e42-710b-08da444118ce
X-MS-TrafficTypeDiagnostic: DM6PR10MB4315:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4315FE0E7FE5DFA40E3793598EDE9@DM6PR10MB4315.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KleaAbSwqdsiozzm43V5RqwWQYg+4qaAGQakgJaWNal8qZmGRKPWNoDmR7BTnKL7wtCNrm8S9XCiYUFi/MwSmJEJEJwWtE4xz88Mj4XHqkDIPAqo61fO/zgHOSTTWJqno763KxSHlIJb3RMRLLKhmHfpALTon24nfgWT60uhwpIcaFvqcvkDQemuhhdj3GpdJ8BYUkm+g0cKogxaOo+ANQeWGdaMVIRSznd7uDyzollVHdIbBJdMjDRilh5Sf2gCP8jtDxgFlY/jQse9fOqMI2Dx2MSy9bpOvuBetW6NGlKeeJs7wl78iIvfQ3V1nkoF2swC+shmZ7vWlxCawAN+4FC5GeJTQYzIVmZBFkLxTsryKObUaN6pbUMxSlM7HSuXmh6cg7Ir1W1LgS0hod0TbcdNWKUq2HN+HYcSZ+kt8CdDHcnlFeEXSDalSUTVejc4Vl/dloylRCEcRcYBOd+PifUEgslc/AifRtMvnrDswgFf7dZPps6K/jU7FI7afEp4Xm6U54ASBUBf8tBMq4jLJ5AxS2lvP7zm6s/xBo5i2PLaIaHPaT+6uahUxMUeJNP0kd8j+MqMGkLFhXHqJy2qDh0JUbkNMWDK5QQJFrhQv1QGP50CZsZn6EO+HHuerHd5K4RZAJzG34fYor0NsVez7a2Xmmrz1Xk/4I/3OH36ov/i+MuZqnBsZGDxF2NcS0c11K85lzPsjWfqHGGkxMO3ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(8936002)(558084003)(5660300002)(316002)(54906003)(6916009)(66946007)(66476007)(66556008)(8676002)(4326008)(6512007)(6506007)(36916002)(186003)(26005)(86362001)(38350700002)(2906002)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bVd34pseEtVaKgS+0NMlt83Ba27SeBj8ThHVER4TXN6dNRVdwXCQAMDnCqjb?=
 =?us-ascii?Q?4vKcQ1Mq9iwVyoDXNDd8v0gb3/glJvDx1xxKBPrLr0CjrTHcIoEZi5Jv5vBD?=
 =?us-ascii?Q?I6gtVdI/jw7m4ksPDA6LgHm3S2ysIIf9YxryAcA6nu7Duct7slIhpQHfVGS6?=
 =?us-ascii?Q?DWe650cmKBKJh64W6l2oZGGd/uyBJxIgbTWdrMBTWqgPKN3AjIxsstzNoAt6?=
 =?us-ascii?Q?5C0dFpfMRFNqxAlaAux0uvWYOdIQfxA2dTyw5SxaAOW4j6LyRBpij1jaQlqn?=
 =?us-ascii?Q?Aq7dnFCNgNo3iKNS7r7VvZkxCizPzAFxMDM9LDRVu9wrvRdc2qrGS2lvRYME?=
 =?us-ascii?Q?mhwq/+Roxi3n4g2eKAJ5qfNv1kAZQqw3lZ4OfT8b2nZ2Ck4C4M+rWzqYTPVd?=
 =?us-ascii?Q?WTQ7NYje0ME6p2CYAqtFFhl8naf/1EU8rVyGeRQFMpD0rYmYGjT0D0K8LMr1?=
 =?us-ascii?Q?9mNhpvwGzP00ANvbgrtlY6TY/LiB78UnWlCTUEpROFxV/5v6MHcLqs9Gc2D+?=
 =?us-ascii?Q?g2bGjNOIFWmWGYLUYIRif2KrIE5Op3UoMuEr6dtxVd1MLmOPXEbGUAkaZ7bx?=
 =?us-ascii?Q?atWqahMWor56zMjuVx8AWL0rRMkoUm3cuBxgCt30g+mG6aTgiZ9U0M/6lo6L?=
 =?us-ascii?Q?6C1cNOUfnGmFziePxd6jojDx9tptMZj13w6p3JSkvfI/8jNMMhzx8xBWIX1i?=
 =?us-ascii?Q?uQN7P1x+36MBLvFRTn6riqsGpYHLIm/lC5XTjW7d86mCo/YkF1UonZ/iFVad?=
 =?us-ascii?Q?HGKg7rEz3aRnDVJtkZEKHPJZHcAQXQFIB+ckfOcH+Sn2wsWqTS5HSN+30ykO?=
 =?us-ascii?Q?+4shew7+2lP8GyEs7aKzMBvGYbpYS5qwG7tyyOZ/gGa+k6K++kh7SyMyQOeO?=
 =?us-ascii?Q?ZuN+5QuBZqjqc7yJE6IT2sCjKyOaNLYczOmyNJ1ePCAdt7MAoZbl9/zwFMDo?=
 =?us-ascii?Q?8mPay8ERBMIt9XRVqvPJ3pXSy7wMm5EgGM5HAnCNs3hphI2pEE7lJiFTyHcK?=
 =?us-ascii?Q?7jwUlwyiGjn3eU/ic+iYg4hI0Qruh4UOG5wdxS38QWWAKDmOy+cQlo+DlePv?=
 =?us-ascii?Q?FxNHkbBu7snt7YneKuB6zHX8fdsgNNgkqqUqE2+ZgzvJzOjj1COI2AQMwj5H?=
 =?us-ascii?Q?LCpkS5+vRsY8zchOJGEeCNC1n05X+tGOzURbMqkmb/ImOYk6XSLjhDCuhBlu?=
 =?us-ascii?Q?m+6LpmTBIPi8trZ6cJOeOqOgx/j5wR1o9iU4u4voWOeVNRdphB8pC5ac91YW?=
 =?us-ascii?Q?kM6P2XX6s4vmYnGniepYYihhJfVnSzfXBwAOpBJ2Nq4ibpYXtbma7+97CXi4?=
 =?us-ascii?Q?UsxTbQdAZQ6KABDIfLenhV8X77riDZHTQdhIZ7ZZObhcd3JEEWVZlkKd1Qdo?=
 =?us-ascii?Q?Dv15uzhWmJMdKK6DJq3mNtNBk6/0/guFAgZcQPoEZBVGtq4ZJGZeJhu8B1m/?=
 =?us-ascii?Q?vNs5j+vd0eSqYBpNr+5Nycxv6Mu8+AnCLYhPm3J/ErjU7NkV3ha63D/D/+RK?=
 =?us-ascii?Q?LA+OSb6dR4UiH1nXue5r1eHMniS1LBpxnjsYcnMk3q3rgFGb3jAFAHDCNk3I?=
 =?us-ascii?Q?j/WVqseE5eJqf3NdxXPt59U371Ab/NSNkMxmk+7MZECwnAjd2gr1cvWHditw?=
 =?us-ascii?Q?s2pfyN+FmQ01bsanLjttClYooIogc3qUCA4iIrU/XXd9ZuvQlJzcge+nxq6D?=
 =?us-ascii?Q?oOYl6wpzNkgrA5Ms33hipJcUQjIcxnAEyMONqwu5H4B2or0ONQR3bQfFYgES?=
 =?us-ascii?Q?WPS7a8X0G/s/muK/zgqpnLe31aITk1w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45325a09-4fa4-4e42-710b-08da444118ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 02:39:20.7498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JN/6mjN1toQeJf66dOcV5ZDYDka/LjEw35Uhlx/T9Rk0hEPGhyCS8G2HBiUAOUkd2ECNDy16FyuU4PQlMoCeDyJQxUSsWkQj5qGTsd9lGUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4315
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_09:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=841 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020010
X-Proofpoint-GUID: WzQJZMbysd9B0X1Mms-sT-hyU2LNKLDr
X-Proofpoint-ORIG-GUID: WzQJZMbysd9B0X1Mms-sT-hyU2LNKLDr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> When the 'ALUA state transitioning' sense code is returned we cannot
> use BLK_STS_AGAIN, as this has a very specific use-case.  So return
> BLK_STS_TRANSPORT here.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
