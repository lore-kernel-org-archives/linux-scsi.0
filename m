Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CF5C636D7
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 00:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBVAu5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 19:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBVAu4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 19:50:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F655274BF
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 16:50:54 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMhrGx009748;
        Wed, 22 Feb 2023 00:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=mtj0wbXNsNWRZ8n/iP8JSCDenXMwWfj3x40n9ZrCgz0=;
 b=OhgZFVBlFRVRbN8gTqo+p1jUR0ZPwV/xFPXL8l2514AyH8kUch8T6+OUjLUyQaWq5ELK
 RgL4iQwkiAwb/tYBWRAAvx/UGYUKgLrcScwayW4NTtz/psfCET8lc76PH+2xZq3xxNDl
 ytX5g2KSEueqVQEWgFhK/XsE14h7w4tVACOhnkLjEP440Brpw4OLZ5zw/UaCHf8w2JfA
 B+h0EbUQCh+1JTX2K7cGqtXur3xfce9lyHrAoz9REE/oYxDMZO4bKPGP/rfQOvUKY7wK
 E8Q25gYgg0dmfvENR0wjHUX4ch0YVSzepaSsaVOdtcZmzBJOQytLq+Q/coMcruXwSkFo 2A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnf3eqgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 00:50:52 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31M0Q6Jg006666;
        Wed, 22 Feb 2023 00:50:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4cfbm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 00:50:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4UjVIJtIwYQ7bReNhXvKZUsM0V5IXzDqdJlqvap6lncoD+bsd4rAXjgHsW9Ty9iblK64uiEvseeXDmLMYS3vbwaflJ/n8lEtclS0ZSxe7NgO90rZwrOsM7TsOPD981nTrVqBGuQuFFBrZzzAaBtcE/qzPNeDxJ+1BTkcII4gf402a97giGs/re/F3yoAWD7Il7w9MFxpeQ2iVQhZ1NJs667AqU2Nmj5Vtu9uNmRF5OTX9XQnLWU96W0A6hHUbZ5xXFFxg97tPgvKpueKEr9+GSyPjsJsbKUIgRIRL12UqUe3NNNphN04qicJXuXL0BbRujCUNsK9KO0almatJqAuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtj0wbXNsNWRZ8n/iP8JSCDenXMwWfj3x40n9ZrCgz0=;
 b=hhBuKfXQ15SreP0QTMR+QwhoGdDD6J6ngXEi6mz11AKmihslBO+PJIU/XvBz+AIpRDINZWH0kyASarRQB1nvsE+K3ZWXn4BNRn8maEJ9J6xRz//b918pM13HNfHf7Dri1cTpA0lP8Zfty2i4zWqkzcfn81pmwLW6EJefH6u7DspIc2WkActCiI4Rd0TYIDz6LMxqU7KHSrQp5ddoU2NIDTjyHFmPyvPdrZ/UoLHQHqQ3Jhkym1xaZ+DFu0vd7ednTRBkmDANHn6JndzppGQx3skGf6w7QR1XzM7wWxIiHIpUoBfdFnEu0z6h94RDY04iU/aXJ+mVe4q+JgYVwcEwwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtj0wbXNsNWRZ8n/iP8JSCDenXMwWfj3x40n9ZrCgz0=;
 b=FxBFOcaoOCcV7YsoS522nxQXtsfQmkkuGwJTUTkXTjngAHOoX5mjzH9V6LlTNFSm4f0EYnn/h8KfP7aXSFawoHObBeupYzNDjnnDkc35A98DreUP8ZjtVMqGMvVU00aPY7SgbhRVHpt+HhkSquJuzqH0AQJAvfioy8rWcLIGHWw=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BLAPR10MB5011.namprd10.prod.outlook.com (2603:10b6:208:333::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Wed, 22 Feb
 2023 00:50:49 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::768a:9658:9df:701]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::768a:9658:9df:701%5]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 00:50:49 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi: mpi3mr: fix an issue found by KASAN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ybur09s.fsf@ca-mkp.ca.oracle.com>
References: <20230213193752.6859-1-thenzl@redhat.com>
Date:   Tue, 21 Feb 2023 19:50:46 -0500
In-Reply-To: <20230213193752.6859-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Mon, 13 Feb 2023 20:37:52 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::22) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BLAPR10MB5011:EE_
X-MS-Office365-Filtering-Correlation-Id: b8065db7-5028-439e-e4ce-08db146ed70b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yV20autVh7OFUJyLwFWxJS/q2QklGbOyLWAp7/BBEjeMvDZen/X0m9MyTAxMwhma3zkni3thYkAw17pKu5+1KzYFPGOLAXZLl9/mO4dEKrcC6VxQe31FxePHV+of3jNDff4XY+cJqsdOcPOB/yuTM0q3INxfbQYbdAkdrVH+DFgHc1MTLSfSp9zsfBiAa/ENe3lIgUFPUG0hJ/I12avwrwqUwlnQicY4ZpZaAj6mdaW8Hsm7qK1qEA18kYQMYJ3XD+TLzxltfIDJIyylXf5jg9KYcDCP7XJo7mQWgug0ZSkKS6aywaYKrxpudENUCicG172WmMKLhK6ojrkwlsyW/NIY8bgHosTh+B0pWnxRYkBr0ddy0tRZkjMFO5qXbOhlSsUxdcLeNrN8GcI9UYeyTIgPw6D9+NoF0be8aPSl0PAVc1Db4I4TUd9acaegIeD/lcwz0eBW9KgoUcZpRr/53QXV2h88s6yGLo8+s3Xjlv/23Be2sAicinGLAep8g/qWtKwY9esIesnswScCvu4e09FBsOwP+2NH/Ecbj5iGnMpXt+flJdXF4pop4ZPVezSCrq9chkPzk5PhWkpF1KmYYuQ3tnofLNWlRw9tHTrc12aKfN7TTEEBhMMdWebIWdXpmiHSERaLawAWaP2dvy3uoOi3VBJV01/U+NyVInyXAzcpTX/pPeIT7PwCel7e++UK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199018)(8936002)(86362001)(558084003)(41300700001)(5660300002)(2906002)(38100700002)(66476007)(478600001)(36916002)(66556008)(6916009)(8676002)(66946007)(6486002)(186003)(316002)(26005)(4326008)(6512007)(6666004)(6506007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0RhVruNkdvtDcVhhsTbzzaNGWxr6mqJC67pD2NSGD2XvoFKVah7PEvkPCv7u?=
 =?us-ascii?Q?go+U4Nyrm+Q8kJxa2ezY8k4rK/qGFinKPQfbQuVCGvdSWjzcBx27be9L4E0n?=
 =?us-ascii?Q?7Pw89HwRXDiWl3OGz/wmSefh4qY0mGvcWgOb298iFoht53LrjTxqs2pWguUh?=
 =?us-ascii?Q?xRKBwFaNNYvUrYav39TjDMmDrfvz0dXlsk7Clf/DKyn1+bEZq8JbpfDJM0Uk?=
 =?us-ascii?Q?Lg1cpXnzOGbtYJkxbheniJzfniPIq+kb/kmMHbpRE8hX4OyEIbKuUWt4HzxV?=
 =?us-ascii?Q?V2N/x4V7rJUpff2p9stlpjhA7QkWU0uelq0MYnK5ZbMucCwpfItWhndBj94z?=
 =?us-ascii?Q?gXc0sqlO8e3DZ+7sSIOIH8/9V875xp+hE6hq2D+g+8NQ2QsD8zo2z79hyaKs?=
 =?us-ascii?Q?C4hWFQgZ+rQm92+igL/R4/47jWhAgoYv03/HYmO7Sz5r7hCSD3idlR5Z8T3j?=
 =?us-ascii?Q?iyhMwb2gDuxQIGbqVZ3H9VeAJFype09keUfuBIQQBgnYgCTHefdHXW1tL4ao?=
 =?us-ascii?Q?zWylF2+4YXdyhgLBaQM4nK6oiubkazaGyBbC2j9UzlpF/PMMDiXd07Xws0Fl?=
 =?us-ascii?Q?/KgUEr3yMXDQTt0e9hbQTt52ayEny9aNn7q6lWDhNijx5pSeXNfEad5RDndn?=
 =?us-ascii?Q?LI80IC104CyAoKYWW79ntbZZxC6WaEz0miNVWZe0g0YGiOKbH13UUwLJ/va1?=
 =?us-ascii?Q?awr3EgU9PlGkldH1DpIXuYG1fKUMZYhDOqIcjF/Q6Ioa/7NZLH3MHnh5SAeV?=
 =?us-ascii?Q?UbrKuTrlesACel+X9dKZYJRKKUj/aKnxh3LVaX2/iuuK89qpK8d2Zz/lING2?=
 =?us-ascii?Q?elwePl1+OXnB0nTwbyDguSFK26jMyuIABUMlciKEB34Nc0sXsNPbnkF1XKVq?=
 =?us-ascii?Q?pLZtjv+PwUHhKvJ4QKmYKEKYXee+9JlvGmLPvb8cwMHp1PhHg6Z8DpxPwuhA?=
 =?us-ascii?Q?ofZqsGsykTs21CDkmx/gzf2ulw6ztBZN/XxYQqg5IxtTa/xVK+WnK4sQ7sT1?=
 =?us-ascii?Q?tPZztzaueSmvX+xlMGx/EdlqDxdR6u7lCi1TDiRs8qgZZhONOnCFI0Zgo9qI?=
 =?us-ascii?Q?XLsIIirEnOQcQOWg8S85GlNs/LlD8ZmmF6+ZzysXHWUguUyoKpnvt3uGBmmX?=
 =?us-ascii?Q?yrvpnx8ag3saCrWGOtv41ZowwJ4ZXomSzwWW1IDNWF7hWkGQTEML0aEDvovl?=
 =?us-ascii?Q?788TRPi1oiE7AeJnepIZbq3un7M1lexA1tCQdxU3YWTVb0/nQyOJKheuejOP?=
 =?us-ascii?Q?sPJdVJGEC5AUzwIrj/PwWOt35vJ8iaqWJZWa+Vc0km3+M/vLeIvV91D4lel2?=
 =?us-ascii?Q?z2Kjw1SXryMKPsz4+WtSA1YgS11lhB2qDdfdYc9YIvHrWhXZOuSjY29+M93W?=
 =?us-ascii?Q?c1olKI7BNq3Vcz6pSc1NIC2q0M8EzHoTvt1senWRwhoKFGOi8Qh2DrbuwaxI?=
 =?us-ascii?Q?LYnnvvR5eUh2+Qfy/ePANdmV/zWoa5Fzr3JUlg8hb+uzxLaRAivTe6EqyhFK?=
 =?us-ascii?Q?T0VEPy3kXd3cfd+xg9W9/j2MrQyqcqlKsOsf7qdUofm9bqsoQClY9gFB9wh5?=
 =?us-ascii?Q?xSi2fowkW6zdoD7UAKJIklOYSKM+SfQ8BfEzjEngFb0DFWV5GypBK7UJP7lB?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UpglM8JOs3iuaAh8FQ5uvAaOHMhfUEzMGOAWuqycbplMZAGAFIKaooeESqv7FPeuGTi9bG1V+Q6ywNFvvGHCF7sOvWyqEh88aunXVj3U5cL8WH9+b74/Vmk4AAC6Tr26xO9+ypaUI1mOctIUDMSZB2NaCiLf+H1CGgX6EKAesHQa4fWv77w9KpS7ZKpnLxzzZyYDk1nLAPusTljm+fN8qXVcjITng/eIKMn0h+bdUGQuhNAz3O1l/szqLy65AA6wAOTaGBv+DEfT8N+ffiNg9phEfnLo6CRInKYORje3JCfEWrrz2cBKe3UXbC9orjJrf+s9LOkvJFjY2U6SpRWumuo063O0X0U/39npTACiTZH4RGBbbs/y0y23ZwznnFJ+PMjbb5bWz/ptuzfjXjAjlyoalZgE1OWVZRggxw/RRR+mvNxYK/f5YfJFHeNwukrzZa+vHNyisUOpImDOPs2zKYKr35O3M+u4H2gJwT4OZwKLDpvm9NB92QubRQZtF/0lkV/0hgjOa+7qPV9QerKfOKfxEv+qBkVusCyTmjJlZs52C/4xOptX3bhoysCjZ/OVkSgGAR2kM06LcIDmQcFOut7bBQs5E+pK1HYamqtp7WqLeglrQlCZ12r+JaL2sfoL+9CAgpekX8NHgoNIcS5LAplRRC/6HKLNy3VsGbb5o/PgQSRxh7cuEMfWUwLbLp1h4KhJAEG1DaDuLGuwSoQDU0JKOgqhdzsdVz32D1BKy/50NRblwUFqJOiObWdAxNz2bYfdonHyR5M6aMg7Wb3DIpDdkLeqe6Z+fOpfNj8fdP/pAGA52/VjCLofexRcSJjpByqvPmoi33sR8t82qAqxwg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8065db7-5028-439e-e4ce-08db146ed70b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 00:50:49.1906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXkRgyETqIZg1LPfiD0jtC2SJPlKIi3h7hXU76zkjAwKTJwJSoA7AWNyFly8s1ioihRnFvg96vxilHeBf23WnZg0O1wBckGkB2pk+kwzFPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5011
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_14,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=669 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220004
X-Proofpoint-GUID: Sioi8zb3fB59XgdLB6MGmqk3qfh8sERZ
X-Proofpoint-ORIG-GUID: Sioi8zb3fB59XgdLB6MGmqk3qfh8sERZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> Write only correct size (32 instead of 64 bytes).

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
