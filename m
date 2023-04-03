Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC7DC76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 01:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDCBhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 21:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDCBhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 21:37:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA17365BE
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 18:37:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332LwHoD014865;
        Mon, 3 Apr 2023 01:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=WdLqSHybuMzkwPIqKF8ptemwjSVxG98ZLpFWubhDB+Q=;
 b=B5zHtAa3P8OGEA4n/Aie/LWgWxpdfURnioSrouwqWUfLxhFgBKGvu8kERa6lR25Jkyqt
 KyxoGvVUkS/X1aooFycRoD3fnIkeSyn50M0H6XFx1cdB5CwAPFcfvqUjW+jB5t3eO1fi
 3F96ZwJml/JbEYbYoZgE9mquAUP4aB5eId8fnKybvntwWOjaEm/p3PX8Fe+C7tbd/H5Y
 B6v23f872Brt2CQIjarU9Zg0eogIQxFl7c7MZE4nLUczGgBEhAL9bIoLHxj+yVWvyEkC
 dmIxOGap3yxZQJSYDUz4W/127nrGCfyYwiDU5xtqrAEJz4PwFd+baNK+i7doXzdcT9OH ww== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dhydp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:37:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332LTgpu013751;
        Mon, 3 Apr 2023 01:37:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3dcce5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:37:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCl7fk5snrdpqK6bQE2w7j+VW8hsDWbYfyzEifMa1nJjD1Nb98I0PVymOo+9XGaCd+SCc+Kn6LZNk/ruL10EYmnvgNgi5oDXgEsuHoaurnJQDHut2UYCrx5fM9euOBg1Domu0DNrsPPOmS/8LlNW9ILMI8VQn2HEu4R3bFsvLlGWwQrvKE/PVpN9Sn7HkpQEHFI3337ObgjsyvXtMBUHcLwVp1dNdBKxg7LbNMgac7BWfSyPTA7KC1QHADfVvZK/WIp+zsg+3QPi+j1ws7hLgCaB64OcxhocnrooPeRrh1S5Gi8qXTnUc4O6NK9BWODwRks6L+fNHMCEB/G4EYiq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdLqSHybuMzkwPIqKF8ptemwjSVxG98ZLpFWubhDB+Q=;
 b=NZIF/HG+pa4endbZesJqVzHswGk3Idd4yLoLr9ime3jG1nuYbhilg1Z2w/PsF+/A0f9P1K0x9+OjjatNL2qt+uUEexR/ilnjX47Jmz5l05WcwP2B7usHLgfFV7LXOWnwFM7t6bqm0fjQlI0se7fWpB4tqu5N8xs/6s85pSasA2CVpwSNY0kbzNvQhFnYOQ72Yf0DO0647ESt855ASm0NqZQbKmZ6B4Du11PjeGSHgpO4AcVSX2lE9BFVmKra9NNTJ0Y06PU2BhldzjbBGbmbfm+ODiPNkx+nCNdbHcVTJ5nvrFY1eutAmJYxgHdNVFzXfm3IiPBpLECrs/esIwtuHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdLqSHybuMzkwPIqKF8ptemwjSVxG98ZLpFWubhDB+Q=;
 b=RKN+d2oAhpnBN4OX++kKTJydRnC5ubsXm+CkQWlrPIvpee49kd+eAA4qOn19sk2VOd/vvVpUfJyVJEclA7JolVpco+Ea19B7xvT65ghJUGWdTYpT76Q3hkI8S5oA38nmM4OJ3P9+ac7iGuhfTjuUY7oHJWobc9gZtaINbqI2AYA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7547.namprd10.prod.outlook.com (2603:10b6:208:493::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 01:37:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 01:37:03 +0000
To:     Enze Li <lienze@kylinos.cn>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, enze.li@gmx.com
Subject: Re: [PATCH] scsi: sr: simplify the sr_open function
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jpxyceg.fsf@ca-mkp.ca.oracle.com>
References: <20230327030237.3407253-1-lienze@kylinos.cn>
Date:   Sun, 02 Apr 2023 21:37:00 -0400
In-Reply-To: <20230327030237.3407253-1-lienze@kylinos.cn> (Enze Li's message
        of "Mon, 27 Mar 2023 11:02:37 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:74::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d22ac73-786c-4c01-6ceb-08db33e3ed16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 255C/41MW8YoWLpdFo0MOM+O3SI/qFvfJgoIXn5McJQ+zJdq0HcMsIoOhDXJrzEHi+L4P3BT6NOqNmJhuaGmkMj0GCjHYa7J5BJAjdz2WfIkAr+PtAry6eLEAAIQKMDPNHlHgUP3LRL0B+wwTZLWDwS16lOj9gAmxyxkkZQhaBnl/0UFrhqxaoaCNoi5264BIgd8D/rZnj2kn8YrWYnYCr4Pf9jOG/KBUJfw0W16SY6YdAiL2KVgVhcI9iece3i01zcibxW8Gcdi4Aa5e3CUiGJBOCfdg4zb0hFSd4w4VwkkVX8nyAkDP7m0epgyS0kgFEUeeON+QStQORXXiWWMYDy/w+SMRjIOzvLH2NqUJa5D4npBZ06SMOejq0CIsyTkWDmcyoRwHa8FS7e78Yugg1+kwbOHQnORfaKI8LpokhB1CLc+nVschVZlmK/WZ0jlxhIsMxW6QThERE53JRPxw04pBGhbjeyhl2UVCW5s7f6+5Ck08tx2srIYvYSp20QiY2yMAeM9i/IjZxlvF5KSmnNNX42vMQ+J8KcTSmDsrCxZLqqTcp7LTcQHQVKuYY1m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199021)(4326008)(6916009)(8676002)(66556008)(66946007)(66476007)(316002)(478600001)(8936002)(5660300002)(41300700001)(38100700002)(186003)(36916002)(6486002)(6512007)(6506007)(26005)(86362001)(2906002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gStgnwqgFyz/M1KF+yYDQG45gXzCZX4q7g4lh7RdAS09Tg6BOOiLj9Yo3+3J?=
 =?us-ascii?Q?b0VTIU6gfCTrSFI01pnq3f9bhdcykCDfmP8dQ84Ka5w400vMQnFLnFpfmhPH?=
 =?us-ascii?Q?C/NBOoiRSpHUKo1HkCZf2gkOoMCbqk1fdy0p6sCSCf6d2wEFhBVT91vNzW+/?=
 =?us-ascii?Q?1rKhd3PZ1cctXx1wXkKxPLIy0H6hLQrrEcnxiECPtanjFuwhY9xrpCWulflP?=
 =?us-ascii?Q?z/6/n+8pgy6NotFdJI3b/MUuF5XdynMEQvswZJOyfbo1/+yLkcrTmYBCfFJM?=
 =?us-ascii?Q?FVv1AuQR1Vd79CPynBF2oH0aBk5LywuWxgQBcF4nu/0JY0n4pJ0w2aXVaAcr?=
 =?us-ascii?Q?q97djnG9IyFkS+RlmXwPxcDTBoI8sfKzeSn8yQ428qle51hYi2+xRfBgyyZV?=
 =?us-ascii?Q?nVPHiEcyn1mHMnP4RNnhknIZ/rBunx6DMtPHx5mKX9x7cswS3uLVK0yQgveo?=
 =?us-ascii?Q?hTHk+zSR3++qAdi1L2TBRi5Bm32xY15mguwJsvtL9Vf9CEiFHck0jUUMyJ5l?=
 =?us-ascii?Q?IxTtGJuKX24U9f0GKZlA0Lyd6e3uEbmDNe5vOQqpAgFtWI4pvRKcFQhVGi05?=
 =?us-ascii?Q?a9dEMZh7S7VuV18s036OjNyeMtRmUFl2hvve+btRazqCl6rN6bKWsgJeYHcD?=
 =?us-ascii?Q?DWejfuRSacM2OE22hx2zRPa16S257SbZ5rdhEEe5/TKgr58Ynnj2XP9umnxU?=
 =?us-ascii?Q?Tw1waB5hJ/qrFvx7DWH/j/9iFdD1Ro98HlK0KOl5Y2P4xM+iIwA1z30nx0Rd?=
 =?us-ascii?Q?I6NPiI9PRK8xwjIYLZZuRhh3hDH9XuK6OEt518sLfB8yW1tdDKnLSJavUXzV?=
 =?us-ascii?Q?WM2wefBoKDYRBzCk5iUeJJ19ww+0lEXRxCVOQ3N8fldazSUtTeVYXHaOIJ8s?=
 =?us-ascii?Q?8GTUXoQ+wtKwyhQrp/KgLu6FvvrcUkwKZOQ8TqVkdKod9uFZa+GUTqXSfvbO?=
 =?us-ascii?Q?zGz7I4Ftyjrtt+m3nUT+nNnZGGGhbSw3F97NmakVXKKv5gbsKdOsmpQqtfdU?=
 =?us-ascii?Q?rRA3abucaQUQoXCbDRxbP/W97oEhcXtMT8QaXJe92MnYHMdd3UxTtpJXYag+?=
 =?us-ascii?Q?GgVnS4N0MxPlYat5kGIbM7pR9+cazE4ue8tBK3ZX4MHHnGeNleH62FIG/vzm?=
 =?us-ascii?Q?3eqirPIka7CTnHNmNhR4OcmCDdZaOa5hp4RuBFDt/7cu2N0eMNb2fyXHKtc+?=
 =?us-ascii?Q?r0wLqGqrqSelXkbUcr86dSWmCcF/q4eqcqT/KCftBZVLo6gNEeHSkos4PtBt?=
 =?us-ascii?Q?WApeL2LyRmspTmzPTBIaRG0PpwP5rJYfhnOxAHrxtlYsVgikruAjnXedfyW/?=
 =?us-ascii?Q?fUhVYSOI/hQDikaoX9srpciCtqBmfnlyKiBDdNnW14ndNjvapYyeuEZtVv1J?=
 =?us-ascii?Q?8rdkPiM5cp9L8Xk/gF7fc6OwJBax9M+JR8CAqUzKg5luoCjcp1ZmDxtAs4pr?=
 =?us-ascii?Q?PmaE3RDNASZsEtbEZMzMbPZ1lxGjmm1EXQHUeuGjanJIVp1qQzEuuDSTksE0?=
 =?us-ascii?Q?GVFP/md/5BAVr2BLAnBV/0gEUsKrCyK8Kg/aPSk3thSKrgqTDxET2XOrYXzX?=
 =?us-ascii?Q?WPNzElfLUh4gSl2B4SqiJ1jjEoKkHyoPUMrqARlE0IJxUxvSBJidHGO3cy+4?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PebcyRGHVjXuxe1bE1J/E0zHFlTbWUSukZsJsJz7Y0t9bp/EdfGVquvTzUiGRfFhuiasB8RVdQIS+F1zMtYk3e8XE0wXqPAmWvrbMU64WOq9THXXh92E4yEjcMrR2qbA6Sa7BcC+vrtLlB5fGEEuzxeEks2hUUeTXO6iN8r66HpFkyv2W8Xo3yi/oL/NSK0g0CRJphgUlHzaqtVUFA7H+/bbYKzaYbcR+usWgMQZc602awWNiFBDw+n8/N0Rs/RbW6fgGJ3W9tVwi/AyrOyOWLau8nrBYT93weJvwt6YQ6isscJoUknvVriObVC5oAt0ltFqaeWEO3YH7156CY3ziiAJbe517PHgDZqMcVguIR2br82Bie5irJ4sEiE5ViqmOeUoHefCBIfkv7TaMGEQkfEdAPkw57dBEpqDEMDUwexwO9JUubFDUeXxefdg5f2oF3CJt+PXu8erLg/gfXeuiX0oMFRSTyNYcnQZVACOSXJVzmE8tpRFdDVkxObnuM/nMh8bwGeLGyckwdnNeWjcx1rMEAf1g+DpHxyEBbaMXsswV3u4w8wdq+p92gYEAAnRvXgmI4aQ4wuznBVmREG2j5W9tT91aEsN62tyH3E0lvnjorrJ/gk33ESaZjL+BiO1cYiDlUCeDPQrSWK2QcP+0BfQeeN7eyrJb/dA/QZrcA3eUbIQKUkhQE5mDjoyAep+1U0KY3PtQ9xbTlVLDTS0EJFFBl+c4SiJq/v6OWAndQQsdM7HaYtfB22SeSA5StRkFnrvYKrEYH2nWfY++IYzT6igL3JIXhnl8VJdxx+56o/9L8DtqLg3mbqs0dp3LPq9/HWeOlkOqyygiY6E8+3Q9AhnCPnjLSBStRARyc81vUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d22ac73-786c-4c01-6ceb-08db33e3ed16
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 01:37:03.2867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTNqf1SATUt+1ApSk0KQ+ipSdrHxCcp9rF5NLJyyp7mmN8L9lwc4ulFtZii9ZIbzOxa+HGLikNQUNp3a3mbhudYiuutzjQLD8ahgZFKLxUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=729 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030009
X-Proofpoint-GUID: ieiXaDm0uqd5La3BU8IfRW4sb2NMbSGy
X-Proofpoint-ORIG-GUID: ieiXaDm0uqd5La3BU8IfRW4sb2NMbSGy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Enze,

> Simplify the sr_open function by removing the goto label as it does only
> return one error code.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
