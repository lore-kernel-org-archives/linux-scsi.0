Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8023C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 23:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A265761507
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 23:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhKPXhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 18:37:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16582 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhKPXhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Nov 2021 18:37:14 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGNODDY032014;
        Tue, 16 Nov 2021 23:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hMhlvCnEYTh6JHQetG7MgtkpSMyclPmQjRCVhxgz/f0=;
 b=YY/XWwbV9BGXsMe3a1TPynGQYYnGnmRervAnj/Kd1VtURlF2yEhLPNC1TNV/H8owCzK7
 aFUEA1lOQ+/ch8pzhy4Ohri+PqxzbZE0y22YgKQToI7/V83q16SaeMSzyjRI4Vf0cAHv
 sT6expIE9uVuy6yJ7A7ogBmb+Za3WkISzovGIBcMI4EZ7OIz+N389pyRFsi6u8hmEQA9
 /dOCdlRmG/pFHejsli6nu9Jk+k4i7/YZvx3BwWRI5IE9a5RMC+0PClYiOVpVZ+QTV1QV
 r1AcbZpzgKh7DEqOlYUR7SAoAVF8zwsw4BevGUU5Yp5DhA3Hjf7XhjX2aORJencXCM2w cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv85gth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 23:34:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AGNUEbA111930;
        Tue, 16 Nov 2021 23:34:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3030.oracle.com with ESMTP id 3ca2fwy46a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 23:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cv+E74HGXTRv2CyFaQ8CJvHhKGJaoPNpZ5lTtZZyZL3e1qJlpq+FJ8eja1AnDULRUoOkNqwpry2bN2CxC3U0P3cpjTtDya8U1sNePw5IknlDLcjR+Fa0kIvaRxYMlLF2Vofw4TkwThpcI/lUZeWuD3yPTqbzThwWKqHluEQUi97A7MRTszAavKnQgI7KFwY1NCX3Um8tn95ns9lXxJYGrHZf85d9vvaAr0m7EvXfrZe86lzDbhl4pyYydavcIKKC/u0H+fw7zLgUjoyJjg0bzk3iWkTAmjjP/B6PIW9M13Rw5rTyGg4BJ4dNjJL1g+jto93S/uaRc+UWYGPqdiUS7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMhlvCnEYTh6JHQetG7MgtkpSMyclPmQjRCVhxgz/f0=;
 b=kwtIkHKGsPXCSu964cEbUa+JIeAONFRdj3D/b/Ov5xHb6yv9ItDLn2T+qBJLS++ppTTofUKe+ujzTL5yDrrNTsSTsaCxXcSvCuHaPPvwSSS51GBjpMRqiNUXLmRLBAI7ZgkkH2LE+ykct83WkzNesWFo7T+Oz5jBOG1QOShbwVZohLVix9f8686vevmhytyHPlXOfC37iY/KUfIIXoskt67nqZ5uOe91Fojpn14j+/4F68cGJmg8TGscoQKGYwQHpE9T3INtq8DFmB7+b7V11rONalcJdbrNjwB1W7j93TBiN9N70wHzT/CmiowxrozNznxYeQTPDZarH95R7kVioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMhlvCnEYTh6JHQetG7MgtkpSMyclPmQjRCVhxgz/f0=;
 b=zm01ayKFWmVjm+JQ9EctSxP7lB9sKuNgYVhMi9g1vMIyh1Al/Hj6IiCL+RKLKHiVw5So15k3r0r0ZlMKV4CfbcxPWDOdmVY/uMOVFLQsfhPOmIi6ApqaoUFIs6eIKhEHh/ktRRurWMAiDsoHR/nBPkWvGWRziv7HBNH2atCvlIA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Tue, 16 Nov
 2021 23:34:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 23:34:09 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: Rebasing the for-next branch
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ysrad7c.fsf@ca-mkp.ca.oracle.com>
References: <652bab99-7c52-7378-792f-6b814671c0eb@acm.org>
Date:   Tue, 16 Nov 2021 18:34:06 -0500
In-Reply-To: <652bab99-7c52-7378-792f-6b814671c0eb@acm.org> (Bart Van Assche's
        message of "Tue, 16 Nov 2021 15:24:45 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0180.namprd05.prod.outlook.com
 (2603:10b6:a03:339::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by SJ0PR05CA0180.namprd05.prod.outlook.com (2603:10b6:a03:339::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.18 via Frontend Transport; Tue, 16 Nov 2021 23:34:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7131069-3c61-4eb4-2f85-08d9a95996a9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-Microsoft-Antispam-PRVS: <PH0PR10MB5449BAFF6E85AF673E96C9F68E999@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8rwFLzGvzoFUqXUlkBr8bxfL8MIE2SsZQJg0rPJAPV0UXL3ymGRP5ByNaY8ibpiDvm93zU86Ckw6YctSymxAqdxvtDxJF5WPfOprdOD4J/35pOKEZH/I51zbwlkWASpvbWPF4kpM7wo4K9klUw1meA38YQ6t117IC2o76DYrRSCaIhBoQuvGmrsxqD32Ws/1qzEQYriDxq1Dlc0CDrt3xmKw8nNy+5+tIRJEOZKbIx3m/hpXEuJAytPcLVJBV/EUQoZXD2RprfDXY9Id88c5+MBfjvasf9hdH9pI35Yc6N4rVtfa06ukI6IJFI8qt34k9fSpxoLJkx0JNcIjhIuuOJkF1FXo7Pct8WwKaJex0cMksKo6I+5ccQ+hgY0Bg6TfNKRyxgNttx/Uody4Qv+cAGWYBCuMS75dhlC/YYIhceW9LQyNJ7OEoRhkmFbjS2HLXebtOP+tdiHdI1IVnw7C53TYH/sllp4QQIe0EDI2+qEc1FVpm2gYXzIdopcyA5pELfIH60mAemK/J5d7vr4hhLsi1UZGeCfYFKkRMkoJEjNilbPTdTsHEiT8RpHbgbK6gJg2NxAkpSCczGHwGwsozl2DKtyGPAIrlN7uAYWJ9KEEZV+1jH553jL4HzDG4I46BPRrr77OJ1RIPwRoCRWgZfADhBA6yh7j9Q74QhLSwD4AKsg34OpKaDr+k8Zx0gNtMDfW7eIeGYgNrYI1xOZgobXKqcRe49B8xw5cR3JRoHJlMCMpHTvm1oEJXNikbXGanqv3LatKw23TH0Put6M1om+bAL1+7dK8Z40DmP5cWRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(6666004)(316002)(66946007)(956004)(558084003)(66476007)(4326008)(66556008)(86362001)(3480700007)(26005)(186003)(55016002)(6916009)(5660300002)(508600001)(38100700002)(8936002)(38350700002)(2906002)(36916002)(7696005)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sIy2YwjOIWqAKgCNuR7eki2sL+hvgijiRBdJSZmujBwZBkf6/mborSeC6YrP?=
 =?us-ascii?Q?vY7KymfOJyvq2YABQLJxP6X/lADrr1By1EKbcFWriC0TzlAXUfHwk/N+KSE0?=
 =?us-ascii?Q?bOuYHyUvhS8X1w8k5V4OpqxxGtFhntbWqoUK6j0R8Dk0Fm/mWfcBpb4AQ3Xo?=
 =?us-ascii?Q?DMihfBzwjEr41M/a9rBhCO69cpIqeiNcdH86nNxM5TwUoHrsfTBo/mge6v9z?=
 =?us-ascii?Q?DIvbLfog82eFTG2QudCQwkgyfIwOfB1gYESVkafn6ROFx06tu5HDfbJ+Kl6O?=
 =?us-ascii?Q?oNWm/KFwM+FnPwtycAiF7MSXjsR5s4rsPm0I/gN1bWt1U/Ly+L7EWzqdttGi?=
 =?us-ascii?Q?cINbeaR0EhV62MNLYA24CBD287qXEcM5BVGKNZLocNYnaxIojp4u+KjKSqhr?=
 =?us-ascii?Q?RCtcsRwwck4yN3Gumng2dq2CPR74w+OkNLR5RW2Hg0saXhH9Ngbmv3dKjKyH?=
 =?us-ascii?Q?UxiRUFweUckfqyJptUW5zVjieKXZdQYMQ2qk69pRjAVy9UtqFoq5JWVYikoJ?=
 =?us-ascii?Q?w+RgqKKEzdTMppgMVxRsWdIMZmb3zurCUco5BCJ4hyLDJTJ/sLjMTUDuNC6I?=
 =?us-ascii?Q?ZlDoAGFe9I5LEWHcsktYIbv4WEC/ADcPeqH7vFdXx45rvkz5ToeE2XVqlKQ8?=
 =?us-ascii?Q?Yq6bTp7iZTmcoN2H63fSX7gGezrqai/BHIIidURqj/PuR20V9x7QQqC9JuXW?=
 =?us-ascii?Q?VybPof8YDV+1M2gIbnKvS2cCy+xoq7Tmj2dzGk1A6hK9+8Q+ocwo000RGzid?=
 =?us-ascii?Q?u4fO5p+zSYyBMAs5xVI3SoPD9nQfjElsXuO2FqdCZpwWwahIWagpgB5yr1++?=
 =?us-ascii?Q?8s5Sau6Eovk2FBiE5kFHiH/pKOvwcdkLViWzbseFao481skod5ELr8TQlMwd?=
 =?us-ascii?Q?iDU3sBqznTqpEVOuEgggtAfMax84BQ/kg0JeCiRBpgg3MyQdWhjiS3OAF0Yi?=
 =?us-ascii?Q?Z2iQwx9E5tMr0E7VGKY8pr1dr7SsJZTCv1GBA/TWaA0UX1lSAOM+glbr5mUT?=
 =?us-ascii?Q?IYRhc2jWyriVDirFRKqjGzgsyyUYYj2XyaoeXUl9W1lyElYMYKS6jq6J9iiT?=
 =?us-ascii?Q?ZIucvWwfpjodC2wPJmJEHHlxruiCkx4p4DxNfK5sec8hYwoa/fHxvnHG0Gj1?=
 =?us-ascii?Q?X0DRQkI7Sljf+fvvchiJX+DPX8dZcg19sT/fJeqb31emEgvY29E4ZAedRsF8?=
 =?us-ascii?Q?T/E+h0QgyaFBpJFyHHerxFIh6ybPfQAXD86E3DBEsYtG27PMytyjMgI+wib9?=
 =?us-ascii?Q?cmHW7EepyMyBbj0ooHXzfOm6PDJXDkomghSr41a8lprnlCXSAG/itTGjlEgs?=
 =?us-ascii?Q?EZTH3xvKSTwrqyN27iqlgZy92vkEydSMitMmKc4iNWrD+xCISMp+Xrsj9F37?=
 =?us-ascii?Q?CvPKTJUAC8P4n4l9W//SB1PwQL7YXXm+8cZo4t0hgADf0CBcliP3lGoXjQfn?=
 =?us-ascii?Q?vOWo0vVLWGVewVifTxhU1KF0eF+tV09ur3P/g/hRjL+rR5nLo+treoEpnB5F?=
 =?us-ascii?Q?3H7+W2nnAz1fiEB8Ne/iOfgX9pGh5YmQbRAOH1OrADf69fBpWpc01P17idna?=
 =?us-ascii?Q?m8NS5OMxhDcuJW8VA7KB6PWtSNLfLV6NRr2clGSLNCUvfnsxNt4rdQbznW2P?=
 =?us-ascii?Q?fMb4yiWaTQwetYumjrreJR0DHvLLtiEcPFEk65+PDyfpPmu0bvD+6RutaNUj?=
 =?us-ascii?Q?w8ukQg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7131069-3c61-4eb4-2f85-08d9a95996a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 23:34:09.5724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: By04Iyvcw7Tv78Lm38q5WQdYFJmrX9ySOXnKEeG/S98SOht/dgRvC64rIjaXwBUkHj7Kfk8xJouO44gPohOwvqg6owk8Jel6myKVgZEgoKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=810 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111160103
X-Proofpoint-GUID: ZmFC-fL8tKaNI3KVVxZnFaRjbLDQK-dK
X-Proofpoint-ORIG-GUID: ZmFC-fL8tKaNI3KVVxZnFaRjbLDQK-dK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Do you plan to rebase the for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git on
> v5.16-rc1?

Yes, I'll get the branches going shortly. Been stuck in meetings all day
yesterday and today.

-- 
Martin K. Petersen	Oracle Linux Engineering
