Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10E0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 05:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbiAEFxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 00:53:18 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3178 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235987AbiAEFxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 00:53:17 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204Nio4o008994;
        Wed, 5 Jan 2022 05:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8tbkI0p5SaKxtbs6J3fXO1WT4TuMjaIBylSH2OFO7MQ=;
 b=ZCySVc3QpVq1/o7dCuq7ji7ELPls504H0dxUlv0HlMQJ5jDGCtEa8XQ2itzS174P0Gd9
 +lWvz+sF7+nOkwvA6Yh7fwcjhiL64bPq48Hrxfvy+Td1vxeZLr5bIpTOZr5S4O01geZf
 A+xioRBSbWf+AjtsCis4B0Z+LCRx9dwR2vveMfLhm+0gfs7YqWRhwQoz6JtFUjF08uO8
 3jn6hH6lF1MaeMbnjfv43rLVtye0xUDSRjkcp/ujJZnPbdfdBVNG+IQRyOFcI+fPvYBo
 rIUi2FDBddNpD27znzRUjZV9r0oVMavz6nxDbWDDzPm3v5OzPJhwymsZqVDFYY16MZKF nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc9d934w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:53:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2055pkHV031424;
        Wed, 5 Jan 2022 05:53:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3030.oracle.com with ESMTP id 3dac2xqks5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:53:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+bThYKBM9i5U49R/7D1WMnXf5NBPI7sChrl2b9bCK3r1tLXIVSW30Fdb5PDl+cxNvUljEsfpUPgE2dUiGftvGA9gAbi8XD8zGzIoIVgEOpS+bMEvJuoKwREGiYlLRPmKiRqtyVOl8oHwzhQXNXaGhc4dZz3nHNP+wcNkmL5YEbcKpmjBjhJSZEKDzTCPxUPvIJRdTRn+iZs2CukMPaeYIr5dvWph0hnSqCR4p331BGB7OL9q1tGpMAdV88HjIFw9aru5WvcZQd1frhqVYk20YpLO0ecoFbxsTxfZNvOALtla9yn4vM2CS/b5P4Ce2CfFpTHM5uq698Fa4njYSXzlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tbkI0p5SaKxtbs6J3fXO1WT4TuMjaIBylSH2OFO7MQ=;
 b=eFCPLT/ALuZMxx0OKONJkWT8i3oA7b2Lc07Nn7h/k2JqShqc1czN/xcm2Pllzn28PlU4LImOgWtdSaFUxNG8bOajA5XC9JISaC9H9Cjsn404a3kJBC5Y04PvBTAPdhtavjmz6cvrvUSfFIR9wt2frkgp4Tvh5JjnKt1BeWhQ8w0iYrNeg1X8Kf2ms+B1X3s21O3wO+oxdK2bUe/2+SaXoNbq65YCP8kX44ksS/VEi/NTkqTcUZz5FO/Y+11ulv48azrYQ+q8Oy+V1OSLxAVn0ya3l5+u0DFELAfLtiRjstxt7mAupUv5tDZOjXgRI6ewAGU8iOJLKeY9piaOvomwvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tbkI0p5SaKxtbs6J3fXO1WT4TuMjaIBylSH2OFO7MQ=;
 b=Vb6QENpClSdfcucFjCgTMrQ80qjc/jzA7V+nzHP/lqG05EMlrsNE06HyhpI9bQ3gU2JmVBWl9zGq4CckjVOdvGSvN/VmlZSohv3p5zIkfjC5lD8ZkwFLcVk0Dvxm1oHHFHAlWMXO6qGmpQ6HmoLA5IvW/UACw7hMjB8Engyo7uY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5746.namprd10.prod.outlook.com (2603:10b6:510:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 05:53:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%5]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 05:53:11 +0000
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, "Jinpu Wang" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: pm80xx: port reset timeout error handling
 correction.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnjeybid.fsf@ca-mkp.ca.oracle.com>
References: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
Date:   Wed, 05 Jan 2022 00:53:09 -0500
In-Reply-To: <20211228111753.10802-1-Ajish.Koshy@microchip.com> (Ajish Koshy's
        message of "Tue, 28 Dec 2021 16:47:53 +0530")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:208:234::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a648e52-4ef8-423c-b242-08d9d00fa7de
X-MS-TrafficTypeDiagnostic: PH7PR10MB5746:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB57467BE83F92F82F795DBEBF8E4B9@PH7PR10MB5746.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddDqLl6KR9SUtmC7G/sbmxN6dGDohJiGFxAcZTK7HNWb6dS1q+zm2WNxfP+XDDzVFUtdVkdNgXSXR97qFCpY4IuZnTbr7SAoCrD82eY1Oa/kCO4dgHQyAHJ1HeRewtBSil7QH+EDt+hlg6435lAYwtF+7frYfqca5GgV9mp6VVV/AcaKJwhfBTEYBxRzzcBaHCI/6r5XD2Ek5iEbvhwz1zL//yoBmrnAhmTL4PN39OYhuvxlGpuxLf0nxlDt/BP3TBswXzMsZ8t/BKJpLYlHYOU/iYTRAXddeMGUfjiZ2WB2JewaOk45I6mBUMa+s2lMdktTe0/lACg+8CA06YPcxeUu50qHr9J171txKM37nPxb4Xv9td5q/Aj5gCN9gkUr6VkC1VIhCBI2kDnvBpaVpA2zfs6YjjGA1i+jGqLDZ0F822PmQOi0jr/h6ImBfL1IbBnP3qkyjmhXfmUIN0h5DmVWcYO3xjdViyz6obBN130a6hxS5gtjZlzqwk229wCZ9XwTg9guYecRq7KiEU0vEqYhBVjtaGKP3TJ6lwa49XlXWkv09xTSeGUtZfYrfc2Ufpoi++f+Pjq1BcoSlgzQCYV4Vuf0CkeL/LLIrXUz7Tqn3uX8ANeMscXbkhceyJupNC2WcGoQcWXsZ/5sYnr4dhAZfGcWlsq0nuaFRvj6mQz+xbo5FtwO1S53BJGGvJD0TZetVy0Y3CEUTbjUwjItvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(38350700002)(316002)(5660300002)(8936002)(558084003)(8676002)(6512007)(186003)(508600001)(6506007)(38100700002)(54906003)(66556008)(66476007)(66946007)(52116002)(2906002)(6486002)(6916009)(36916002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9RWeNZH/U1925gK/IqkLgzbw/2ndWLdBNhP6uZ2k+10uhqaHr0Z16TuBSjV2?=
 =?us-ascii?Q?rgfVk5GAVHtZek+YyJ4sO9183OJomo8+3HeZDBL/4YQmvIOtouCZsV9rx13C?=
 =?us-ascii?Q?hyX068rSzMMedMc8/Rk4tSv186qDl7sVktenEiTtwesUFh+/EDMVKrcVAUNA?=
 =?us-ascii?Q?F7PVaHvXR8hf9WWfPXGSF8mUzg155U9K4PAKHDJUHOOglLxtISQke5LZHC2+?=
 =?us-ascii?Q?4/RLYhGOn3/FhmuY0a8ZWOoButBIdtNushQGUxZfptunD8t4huy8QeAVuDwr?=
 =?us-ascii?Q?lDkIMkibBQYxA9jAB2sCy1msYEj6M+irA4U6DaHBA/PK4H2c/H7LHJi59tfw?=
 =?us-ascii?Q?4i73Vs7Aqms/E2Du3qdml2Ef7Tvu8uK8HMZ0j+0kIUs0gC5oXVFItWdPH6Mx?=
 =?us-ascii?Q?9sOmajARflnPvyrsyiTn6wa0vsGWA50gzssc4N1xuF/tqsnl76Tj7TjYpyzW?=
 =?us-ascii?Q?Bzpz9Cgpp9mYKieQKW+kWILDYgL/z+9GYYaxjEeOIIjevII0GUT9SNxACAW9?=
 =?us-ascii?Q?+m7jFkvKHvrIss9jzEmRiobJR1ZqV86YG1Sn173lbc9XSxGOYuER9dvDzh6Z?=
 =?us-ascii?Q?l8liAsn/I1sgYHJPKzyoJ4CL/7hNnRYsxF3ZsPVWYtPzzS1e49fcjGhqWozy?=
 =?us-ascii?Q?y2B7aMpLHkbBns/MddedtpQ873ueVGJ5sQjHpEd19ReW01tk+lK7jDeKUcq4?=
 =?us-ascii?Q?YfZPDY2kttjTSjQ95beVblqhzly5dMFowrRyFxdvuCcfXWTtyQSQq06rpGJj?=
 =?us-ascii?Q?alyaD9I4x6yl7yDezQN31Sw63uTWJ05FJEHTP82CZDPWUxQUTVpKKtrOmnYU?=
 =?us-ascii?Q?vrdgao1WCgE0kSXPIKZ51XIPFlMmkzXEqUjBOoxC0BDf7CbVe0scujGQzqBn?=
 =?us-ascii?Q?QnU+bMOZO3Y7kfawdzw9/fAJ3AH0Ab4p+4UnKrldXQf74YjWo2fkGbQYZJXM?=
 =?us-ascii?Q?Ym1ZfGtekQQOdP/FzfhmqisdJM4qiM98e02WaeXhUzG90f6pOPVU5TEE6W+I?=
 =?us-ascii?Q?QVney0ar4EPSjP+F52dTPWcnl0b45M2PPTFxDOR83VFDXV9d3fByX5an1DVM?=
 =?us-ascii?Q?5HMPHFwWpaVkfXDBOs8pNq3R5tlf6zB5Oplr0E+lOxX3IaFZBHuMK6ik4fPb?=
 =?us-ascii?Q?3abIatnUVY9xXwObLFoBOR0/9XIBCeQFQhe9CfE/a4V4/tIEYBHACqYGXVB1?=
 =?us-ascii?Q?QAOk7jUfDdsbqW5XcURp9ub4ocKaujbWCtkn+rXs5vfEnh4W0K5ArKPxGKAO?=
 =?us-ascii?Q?ijTTdqny77BYlOBWcn4XEyHjLlQT3ptrYqrtSpDeWGIDoAPBOH0VSoIPy6SA?=
 =?us-ascii?Q?4oagqpIgHu9LLDU5dLXyFVV2TokAaDMsdf2h42Qj+J0wvSM5Hq3bBeZgTKo6?=
 =?us-ascii?Q?1mjn13ZAvvJ4O00MK6KL44I7lxrACcMFO/tBpIoFkFKTzz5Xo4zR8MeP6ZwZ?=
 =?us-ascii?Q?Yt9kgt2PBfY7Qr19+fmBdgRUgNm9HDzxR2oFUxDoThfy0i/sA03B4nJO8oKB?=
 =?us-ascii?Q?xNYJXuua3MaBSc0E0TpzQ/inT6JPTiV3kCNpyH6nUv2FO/Ym2NHXebEAqVac?=
 =?us-ascii?Q?FANMj05v74n4RuNzQo/e2ETa9fFSGB+1lu9r9oQEvB8MIlzyYLLCxpqOAtTU?=
 =?us-ascii?Q?13hsTEAPIqNQSFdCqbt+8VTSUTu8yGWSH195jx5u7UrtuhMjj5Qme80qXbnG?=
 =?us-ascii?Q?cbTazw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a648e52-4ef8-423c-b242-08d9d00fa7de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 05:53:11.0987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwZFgIirmFUPZdmQD0iCB3umfzhvqkshN5ewDxOBOUC3dewKZi/z8xBVkxC5gEdETlty4+nbK7kuQ3i2b6EeCNkYiBPLoQ3AvtzO7ycKgUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5746
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050039
X-Proofpoint-ORIG-GUID: 17jpdLYLjQhVkCr9v9OeiuiUrrCagjVs
X-Proofpoint-GUID: 17jpdLYLjQhVkCr9v9OeiuiUrrCagjVs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ajish,

> Error handling steps were not in sequence as per the programmers
> manual. Expected sequence:

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
