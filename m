Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763C8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 16:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349117AbiASQbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 11:31:49 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30444 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231152AbiASQbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jan 2022 11:31:48 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JE4698001398;
        Wed, 19 Jan 2022 16:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BxcDd+v6lMyBEO7urbmM6FMCK1qBVMH4TVol0HkWlI8=;
 b=EZ/Xoim5+ZNWD8wbKG7b6TjlX7XizCiBXPJWRyUF/GS9YyFgSOGgysY8rqepY5rc8wy+
 zdw093oJuNk2Sk2ZOWZf0KJPHrVeWq1s1RyvSrCQ67fg8p1HgRJPaqxfT7NwQihUVBlA
 mOmvbd5l7pozNCpsEOGp9aea/0ca04ITa5nJlhF4WXCC9iiS1Fm9vl+tQ1kEQiqyjo+S
 zEpR/ynh67AlvmJH22Z2ZyBtZ0TKQquB/aFbPjkrytMTTIB/LEmFBZf36vTIxIEBFhZf
 4gVel1oXSfKNZN9yTH0ZIPFhwyU6xv3Tm3AoFkSXQWgsL3TvIGNyBK6aEnnIKFdW2Ibc Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f5ht4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 16:31:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JGG6Id130102;
        Wed, 19 Jan 2022 16:31:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3dkqqqng35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 16:31:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6y8g3x5149MFN3ZD7Jnqno/LIKQEyZGK9+N/Wh+23DEsM7H5P16ROTzwmYArCYbFg1/vZkLKdMfy03Ig2Z0XNfvEWn/AHeeosGsrlcqC3he1czk8EV4+FAtCsemAVZfJs7QFQAyI1IpCcgkumXz7YDcZnfNPqWQoCseGzGz9CrJHSHI7Dr6Mp+U9ykyNUQzYHjHk12OCISYu1huyMVwT88pb+YXd1hm0UJAg7GZ+dTTiyqMyWrd2t0sjJc3qdguPbXa12YhTtA9VtTAp/+l4Acj3Np0/M1dGC6UoRR8yEZb6318Hqlxi/HE3OScZsnN+X9327Cl9QI3ZW/UMkfvFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BxcDd+v6lMyBEO7urbmM6FMCK1qBVMH4TVol0HkWlI8=;
 b=M7z1aSSTvnnQOMYFoJKiMCBb63S60eBDYLbp5pXwkC79iCr4ySejwOvmRaCdMze83ANNFSF4pRIZc8TZ+z48k+CmrswDqYNUHczQNqt63sVaG+NmIsxEyOC2HvXSUbucUqeo4o7S5NVCa5wpDujPfs5fFn80gu3gIENb2WUyiVyk/QYTNkVLFlGR/m5pukLi0Ka0YD1QxUrMJFHFRsdmjuWQmDqDs/1LnnrJhg3UPbZ/7Jfe9OTqF9BV5aPVy3VIYlC49Xb7QpCm+F8UTBzYtWH9Hq2pAzyvYbDdfOrMxVyj5IwEyV8gmuvh65h144fQnc9MhwMsJNcbLD7SW8AwfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxcDd+v6lMyBEO7urbmM6FMCK1qBVMH4TVol0HkWlI8=;
 b=OJSBJK6sPMryojcLbMe8wscpyAgDagzqSAq7HGGSKWVY0wYNGnUPdf51DCNkUNtqWIdDquOsPyBnjETa1YvMJCVKPQeN8hY0Ohzd64Vu5ySN9CoKxlLiL8WSTTAfaHwoctGJChvPYY3xfPqivHTmUw3957PFBzsZdEsGMhBNytI=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 16:31:42 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 16:31:42 +0000
To:     Sven Hugi <hugi.sven@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Samsung t5 / t3 problem with ncq trim
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com>
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
        <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
        <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
Date:   Wed, 19 Jan 2022 11:31:39 -0500
In-Reply-To: <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
        (Sven Hugi's message of "Wed, 19 Jan 2022 17:06:49 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:806:d3::32) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f6e333d-ac5b-4c25-704a-08d9db692d27
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4538329CB9ED833527B929768E599@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xo2e0hAMQM8M+qAKs32hHJBmHzWVcEE8tYRK/dR0FBInrC2Ur7//UbDzcgJOV+Nk1dNL5/jQKLaTzdiE3WwpCvFkMUAO721NcsDIccPoKx4g53+l2MprrVck+GFmDtVZZd1zxr/86ORl3rQ8t6KjDg7WZED4YR6fZ2eKSDAPIqHUmdEJDGkuIKQftZJ7AP2BVzOwmhagJ6q2anPP6CqOvddvMmMUN4niR8cUxu6CaJo1kS6zzcgLNsHpgNURBFeBNknTRAwYcyfUBH8jQdrrFGjY1bC3fqZO/yLo+uUmxaMHZetGqiqwDC/Hdjl7kAaZHVLDuOvb6nsz2MS2V+ZglfVHrs3558a3PjWZcdob8kinO9u7Agb05ZjddXgOdccXFsSrIvhRRFRM0VHBaQXEyfnnwNUIZa69tEQrFbPADps6/xMotGolYbKq1tdOW4VDzyRKCq6DSWqVK80QbJ3d4w9z/vOrdtk2rqembkiArW9QFmoSG5prcc5x0gSG7EEav3+X4XlM8YDDu2M65ynKUS4v1qtvKj5yusw/b6NWGvxwpa28vJA7h7wt4rheiZEyXUU9DI4pNzOm8XkgHdYQvInozXnIdLxe0gO/q4p0C4s4RhQgWnvjtIKs2jAutftw/Suc2NjTu6emrTc3z9hiMaHOCHWiNFXkakJJU8qn+xnVbRqsLpTYFsCHvJF81Toqus+AYFPf0LNtyCC7om/IGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(508600001)(26005)(5660300002)(6666004)(66556008)(6486002)(2906002)(4326008)(316002)(66946007)(186003)(6512007)(36916002)(52116002)(8676002)(6916009)(66476007)(6506007)(86362001)(38350700002)(38100700002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J3xibX2giRYJsquNaXOyQnCSl7cVatl4xGwETrI6VsRfcED+zmdC3CFbuYR5?=
 =?us-ascii?Q?UkJ11ZE77TdJrU4iu0isbGk4LbZV2QLZKk4dxtn+lZVQOgKhGuKQkfPuWhlZ?=
 =?us-ascii?Q?9Mkbs1U9YyKBCwixFJSzrX1413V/0SUj7zTyQbB/9ZjlZKcTkot9gtChjdlM?=
 =?us-ascii?Q?eC18t0ZKe+pC0bPLyTXp3OqPN2HNr1IRYzHEBNc5b2ZokVqfudqCuv6MWZLs?=
 =?us-ascii?Q?1GXij396b142PuoS8o8xgpqA7yf3xYSS88Pm8jIA9OcsaEhYGL7YBvvX9tQo?=
 =?us-ascii?Q?tIr4kHMGW5aNaOMpCMAjxTUoy9X5ZSYRmk4GuvL2zWRjnWQueK8yA1aOFxBr?=
 =?us-ascii?Q?CQ6qpk0ZfUAnpjsyi+NbVi23G8GswckxR3DhwA8yDD+v2muz1eMYbn6ZWadj?=
 =?us-ascii?Q?QUcl8VuqpUNGchIQa+IrzAKZ8T3N8tI7wScM+dd+WD4fSUKBpOlx4Jon2d2j?=
 =?us-ascii?Q?x3oKOMslnMKlBhuUHs+dxgKiHSTlpkugQsWfrlMsX4PRNW4KsPIQtXGGt9bY?=
 =?us-ascii?Q?MvIrigmV4aKphQ3vc2HnxRq/XNZhY0PEJG9yz3HPDGLWsflHhBEgxJjX343T?=
 =?us-ascii?Q?OL1Sm6NJy3zXD5CsWvJxXV9/iK1j5y0fRlNO6Oh21kspQostVoSzSuW/xo+M?=
 =?us-ascii?Q?l9etgkZ1oxiSm5hWWOwwetMfUMj/cb6zhHXDc2KmQU9Y7yIvepDQedDF9K8W?=
 =?us-ascii?Q?0HDEQZ+nZwAKl5mkpe5FfwqtYswgE2FKrClOl9dB4FmCMN8e9Ob6bAAadwsu?=
 =?us-ascii?Q?U2UcMSTmScXFbXmO2aZfphXSjrq69LsuuSvW+Mg5yysgqtQjZlEM2/QSnppg?=
 =?us-ascii?Q?JlJGnfNqQtWVz5dR6/LUCBD3okz+qk9ZgO9peqkTeOUTAh7Tc6TbVY7+lIF9?=
 =?us-ascii?Q?uDDDzjuVy8+fLF7YD0k2TdAxOwVvPxgHMUqEsfd4y5nqPehA4eGz9G6dq31M?=
 =?us-ascii?Q?5Ap5r7zdsgn1JLqqgz0N5pqerY4+2bghNs4xhcPC+BxdlhVyiwBFD8cLd1CI?=
 =?us-ascii?Q?t1jYau0AU0n7jaftA+cjg3qC1XmFKGUpvgBlAGKCFrFZzTGyhvkWg57gVsEo?=
 =?us-ascii?Q?qCqN+tLq2RveC9SHzSSEx9/AhQGJ+xiq5W4GEbDhciDZz3WvqRt0pEYWlQ8s?=
 =?us-ascii?Q?/CHI/qnH5cyn4pTiDL8evYTQX/mdXgndGASQFkhjkz2hE2iU06yGwRRxRNoQ?=
 =?us-ascii?Q?gD7hxeM7Eufbv/5VaIxiDqyd3WwE2of33actUtM2rwdDmMQqP7kt4cli+7GM?=
 =?us-ascii?Q?ZFkwEaPh22wy0nii6J0qxPAusM8vhRBh4XnnDW+SDqTxLGt/UERcCF7QWk2d?=
 =?us-ascii?Q?TKKoPl6s5Tm0wVL7xscub3eYrEdeqnZujVG33c4/rqCJJbW6Sb97pj1v3Sy2?=
 =?us-ascii?Q?aK1Ouoaa12eXh8Sbdg+/ABuV0n04CZdO82h1+bXxqvle7GOumdubs0xTeB9k?=
 =?us-ascii?Q?rBVQd7WkAC7ZTHSY/p4ofn6Xz5su3xVmaBPyAVLcZnGGXchvidHlka06PDvN?=
 =?us-ascii?Q?sMWbuGrT2fqru+d6ZhvU7gyC6rjY3on291xTQIpYSa7rZGUQXANLKb8jSdy5?=
 =?us-ascii?Q?5Owz056x2ZEDLInKdc/AErJP5RM9nIzyUQOEoHHrzSfAkuxi1184ngWvTm6s?=
 =?us-ascii?Q?l256fEjVRIP76W7/vK9adCt0w2fuhuMc0ixK/deUFshO2x+hclI8svCiZuQp?=
 =?us-ascii?Q?++gqRA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f6e333d-ac5b-4c25-704a-08d9db692d27
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 16:31:42.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxG0kraY4nkUzkymTI+xSIbXXORQD/Qom/DQgNriH7cfKm7L/itBfpEeaGXOvLyLvpSG8MAQd56yCY95bCQL5Ursj2gvMkrFpiTxbv56hq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=950 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190092
X-Proofpoint-GUID: f5hJLF7MKlqfR4govLZUC3bv-e-WMwvU
X-Proofpoint-ORIG-GUID: f5hJLF7MKlqfR4govLZUC3bv-e-WMwvU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sven,

> It seams, that those 2 ssds do not like ncq trim

Please be specific wrt. the type of error you are seeing.

-- 
Martin K. Petersen	Oracle Linux Engineering
