Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8598EE936E9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjJDVAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjJDVAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:00:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60336C0
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:00:30 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ00l014539;
        Wed, 4 Oct 2023 21:00:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Cq1xukyGkWAjqQMn5Q/Vhr6q12at4D/Ou4kUsmzcDQc=;
 b=lKRqF/8aANlCgKXVg7E2ARqTdiYybdJ36QjZmnGU/pJbhoOhKl5WWTDe6zMS7OWMffDp
 eJR9EXr/40I+LnYKW4514S3l8iO9ny+E94689tMVwWwfysD3NW7MpkMMfo06SMId4WIm
 Z9DevouAwUNbvkKaggvVI+vaUL2p8rEaCM3TrMb2XeuBCHf23KppO93WWfIdWhfohW5q
 31bG73xYCvOzOj5WDQsbisODdi22sQOILlU+uEAUqUQMrei7Y2+ZL+n+LnwLWhIctE2l
 HNXXlfCpHWA+/W6lYYFGQThFQPPHO15vZmG3c2n0EIsCITUD56+gfmCHwLq83H3CIHXp xA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea9283kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394JYJA1003023;
        Wed, 4 Oct 2023 21:00:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4853sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0taiOOSbKdAW5QgMttEUw3xz1no4iTm5mtFUZ5q3D++2TK+WgUxUuuy6NS7s4Rzulvidg6zq4thDEkO3VK1Cew7V2zUvpZ1YKBFUNW4ULpD1gnEYxq7jFt8xDd462Gno0n7hYjCWtxa1i40Lvo0qClnR9BS9sG2qVlXg+CAZksFJ7ovL5389+5cezY6HSFTGMr79S65OL1v8UqgRD3oQ+yFE16dHHLwUeZNDsje0i2W62hDaIdNjZJpno9cFCTHddPbVHeXrXMHMa/QWiujodZEVTtKAQOMpBBHZT5s/8Ml0zMDV3epJVdhy/pTsYekRHNZyD1f67fL1JYGHLeGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cq1xukyGkWAjqQMn5Q/Vhr6q12at4D/Ou4kUsmzcDQc=;
 b=jrpszX5FwALYtDZcW430wTkXNw7vDDN75U4PocWwvG39kZx6BaSSmi/qS1nmpSe3LnDYTAZvV1GQZMBnwShupoqIf7X4UbJ3uJlwV81rIWxVbW7s+5hURBpQNekF30a19CXFxRDdGKBUekXt27bl6GVBGJ7DAh01hgueYOxgYcbWpvQDl+FMQE0Px92D8Qp+dicJ2W1hXZkoxMkOHD07E5kmiN2e9XV+zyuy2VRhV2iJl8kvQKU4OrY1cHnJWMjPo/m/gQmhQohiK5fBjnM0pfsdZl6Ehel0oc8ojSIp18bTr3TCQ73bzRKvheuVVWeLfYJTpAaN9RhxC/+vCJ1rQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cq1xukyGkWAjqQMn5Q/Vhr6q12at4D/Ou4kUsmzcDQc=;
 b=CiH9nUrBBurU3xsvBVjCQcyfuLVxjf6h1PyaGLXdaOVluAO3FdqyNedTsr3n407gAOWJ9uZK8079Z9d17wGllHmA+QH1LfjtmoZgEEuyux9zV2zJ4B0t50/DCcKkAH0AV8oK4RC21QTXqT0MdN/WJzXUBiTXEjmrWXrBoOVD2Xc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v2 00/12] scsi: sshdr and retry fixes
Date:   Wed,  4 Oct 2023 16:00:01 -0500
Message-Id: <20231004210013.5601-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0058.namprd14.prod.outlook.com
 (2603:10b6:5:18f::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 88824576-65cf-486e-a054-08dbc51ce94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fdNfCdaA0Xh3EGO8icAUWcJRf5v5jeLJ9k8WQU+P79yIyOgJSVNZUIF7MPOnHDC+GADUwWeXuDoQQQRv6Ybvy+8y24E/iMi+CXTAoigYPzgrFs3lf8ZYghnjRunhfSKTPiic4vaH3v3g6QuodXc7yGw/iBD4AegDhuovOjXVnbkrcs4p2L4JsZr8qQ4jO+Ul2sdwMzXiBm57r5g3wGXnusRzCrAj1zFrOgUNpGGw+IWbxfkyQuBXJeeYwKCzHJEfC6ryUagAvG0g0v526SsLzYSF77vB+6yBkW99u0C+bhNNnpuj2G+p1MYibkJ3duZp2En5M0uAaF9wqHS3p6wnHlJUGQDnsVlsoJ0Z0PIPkjGEKbX7iUJ4Pdfql0Gkn55LyOZlf657/sYzO+6sIbAzV4TQlI+PR97ivbBnssCqKonosVbnkCgUo7jhuIracEeBxoo/asqeE/pelSUwSUIXDzNIElqS2XFZxBEwZ/X+1AroveR23jwsPO+Jn595tbNDhe8xONEUX58tVGA4424QDex5Gmjlb0VNXMxKV90svrhAAMLNZEkY3IURhArwbaSn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(4744005)(8936002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p9f4SrbnkhmD8OiREgi/P43M6CJzc4rdYscEYTFF21V7L5xpPM3ijT5hPKcc?=
 =?us-ascii?Q?kMDaW6j+8ZmD5W8G+rEkENHkNnfW5AeYmCx224Yid1dXhbGLMS4XYk2mKots?=
 =?us-ascii?Q?E0S1gJigJ5j/Na4h0IIb4y7+H8BZVlOn5L7Wswd12dQ8s1i3q3t+JxUP/J7F?=
 =?us-ascii?Q?gSlgCF14dtGMzXbCNkOVwMdE7m6UjcrTvt1C/bjX02acP6k25y2MMsJdQeP/?=
 =?us-ascii?Q?NDzq8Akhud1Zq9t0RtUbsuj8yrVdC/o3Kw1YFaU0F5ubIdFW7OgyGtTgCjgi?=
 =?us-ascii?Q?ilfzWFhOmKrMXcoeJ95UsJsM7zlgqjL2QMbr5hyfZSHR5jw3bvq5hH8ygKCf?=
 =?us-ascii?Q?7E8QXz5wTiah55bF2Bm4CCg0pIMEfiYZy3YCcslDAfy4/0uR3x66wUK95vJO?=
 =?us-ascii?Q?GVViWFXqC7Jks0SaYkV1K8KQRukIQPK3+Xuk8fGFTk+P0JM5kaz4EYRFm847?=
 =?us-ascii?Q?aF+NKreq9P5hT1G4isIQGMKDbbVVch9QEOK6PkCFq/n2F326vYLsyArtdc2z?=
 =?us-ascii?Q?TstMcbrW1vFNGOd0Y3cA/cHMkMljpGS9NJTkgNsxWKenhwDOuDrg0s/7FKzF?=
 =?us-ascii?Q?inSbNE63ixcoZw6xocZyqc02X+O59GJr7gwwT3i4nFDtUnbj8L+22mOgxnrU?=
 =?us-ascii?Q?V7HCD4octKYRDvqO5txE5Hk1GoU+metabFqp1Fjav9DIgKrqYfFaFln/bNGX?=
 =?us-ascii?Q?PfyNCiExQ27YN2oNOWLi0Y0SJK/igwCvncGfAmpthN8yelDupfTvgVbVQ6cj?=
 =?us-ascii?Q?896zEog78YlhP0lVI0p4O/uW+JXsadoiCL9QBcNg0JzK6QCOEQrTQi0SeTue?=
 =?us-ascii?Q?wK0P/GJ2wVWZW7SOyfuSGntBa36CY7E2UdeQir5UNMDTh75teKzjsAlfWXki?=
 =?us-ascii?Q?24HIAopYPQ12mmq20zqHow3vLpFgavJsvVwM6dNE8+c6imky5uTsCGG3dpY7?=
 =?us-ascii?Q?PkyIV3o5RaarpTZN9NOdKSQ0eUiQKrMa2odi3RJnYUg2PZs6tXix071i5wS2?=
 =?us-ascii?Q?cx7yvSkzVeuN3etPa5u8T55hgyUI2orQ7Vhisno1NsXJfPva353aPKyevE4i?=
 =?us-ascii?Q?/Vn8VXB6Uval0pxMGy4T+KAmai5pX9dk6lxyCxhYbmlD9houq69N3ltgkFpC?=
 =?us-ascii?Q?vHXrpgY6rGsYGKkpFDtCUFXqcqheMqvo59MrwKBIOwWCbaLgAZK+zk8QTCEW?=
 =?us-ascii?Q?R9CCmgntLiLZcWLFnEtXQPZEHt33eMhOSX8yAi7L7FstyvjEZ/O6w8JEncNH?=
 =?us-ascii?Q?vAgbn4fx1QQGpatnJLCje4bjCiES7/Mti4X5AXxfH1FZ8gTv2FUs8PNDgR+7?=
 =?us-ascii?Q?R4St6vpOrXrohrSDObz9kAgrf3Q/lbhyLsQrOeNijoiESw3IdZnHulj5kM3D?=
 =?us-ascii?Q?FY2LN2kCwuj8RORpHOegia9J72r4Iw/Fbb47S5nWcOjqwnuWzJTUyY/+eezj?=
 =?us-ascii?Q?s4xeB8sSnvK0FPXEBuDUDOgIHkm0HxFcMwDnVYAPG2z3toizori/hv6uuGO7?=
 =?us-ascii?Q?5fRN0v5ArXAYMS0RO7hHzBq5ghzNy60Smy63UYTCE8gNcFzvkSlZ3sgtIWNq?=
 =?us-ascii?Q?CrO1OUcaXxVvKynNVtN0fUSlxm0jXfA99uMhUS3RiatYiNCo70pkm8W6fZub?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 150CBVuf/Dc49JwUQgl3K5BAkJ4RyUajVB7BEH08Ddr6y+f89WMX9QJmMDiqUp9ft0fvATBPgefLzLJ68nYrEyOV4XuN6LHBFd+KArf6YwnAP5aph2vIVXtggYoHBPrdYNbqPyNsdHiKbGLKYHBb24tyc0yWLrOKBl47mTmE/rrtb3vtqugXX+MOEgAs0RvjfFom/Bt3RDpmsJW94XKpxh8D8uBl+1H8X3R6egQVbsQSr3UYfiK0+rPH3lNtzXQvMt9ovGP2St+bzoqdm+0K/IWOyNA4bUKTKumSvFy0NyZF/vr3Cb3fOsvwR7mP2aERLezsn+bBQuqoup0DJkdxvePZ1uULHnEizHXosx0mSCSpLnkaGnixFsTp3m8zrdBDxNDVmTMFq6Cc5tJQREHHlzw6Xbu7N+jO1mJ7cLFJCq3k/UFVIDVJD8/QUlsT5kdnER1iayVHSpBGKSzaL5jTqOqzQHiK/kk4ly107sYnrXYwRQ4K50f7Bu3UdRXMtZca9QSHPy16rQhDwvVxltIb83DpbBT/RnK8RCBzeupisrqKC6nbIQ5aMVXhVLtciBSGUOXgsiq+v4GBrVwNAa7LV6WN4KFCGto0KkaGXi/7vF+wE/2m4eCE88NeFN/Vi+Xv7ZtUf/9/tOonAhOd5O6mo3HO0WJ9Sk5nBYApktqO9Uv91EUJWESC7YocxXWaUVGYaVcQ7lJmCaxDssbsXCHn0CqASi+J+kb5K/UWPVhd+lQAYSsDUrSJdufeUN8Wuv8afxj5U5qF4bIzQitX99Qkb2MARomBFsGfoJUX9MATtqoIWUfwQmMCgvCSzLNMUpleVt4WlZ4x0vsT2FGd0q6+qquhxDiqrtkCSowgcjV4CHovC+A/a/7UD4PRP0majgPl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88824576-65cf-486e-a054-08dbc51ce94d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:16.8132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5P2VRwPRQ6gN8tH4ZbUf+laalx0vEEdKOzSFoy7XyUQvslTSrX5CU5/4GJnoIhBFfp2nBRjSdL3jum8rCEf9vS0W3vjJrDZmzVeDOLbyjqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=934 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: FP2NifDhSRKSQyGJ2TJjHaD-8GjuBM0v
X-Proofpoint-ORIG-GUID: FP2NifDhSRKSQyGJ2TJjHaD-8GjuBM0v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus tree (Martin's 6.7
branch was missing some changes to sd.c). They only contain the
sshdr and rdac retry fixes from the "Allow scsi_execute users to
control retries" patchset.

The patches in this set are reviewed and tested but the changes to
how we do retries will take a little longer and require more testing,
so I broke up the series to make them easier to review.



