Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E59C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 04:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiCBEZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiCBEZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 23:25:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE335EBFC
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 20:24:51 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222goYc016793;
        Wed, 2 Mar 2022 04:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UC+BdkbXhZ1PEX4uNE3kvhxxtyOX7aFRQh2nt1dmHS4=;
 b=rVRXfrmSAjcr3eSV+rtWNAhPbnqmE7/bOTep/uy6a8UMQpTKD1ZJfH0wMrxXZrqd9sw6
 dK7cbi1Uo9yOF0h0sm5u+8+LokXsh6c9Y8mxQuvgEzmr7Yj/eEMY0ZwBkYyan6AhrY22
 pnULyQr6TpF+dWSeZajRQUAS9heZQdE2yc4eJyyw67gE4tVeb4atron1n5pJ6ghNTcNZ
 GrbmWR3FGpZlfpjZSXCOfnR7wb8NEb8gUcdu5ge45ZUw8fjkXeFiaXh2DA6bRi4RFhky
 8eIj73bufm4Hg8+8SUCbVfl6IZCWEHA/pb0Cz0DLdpwhzCafe3Yud5A31SVQGXIFEYkq Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehdayu1n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:24:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2224Fgjr077626;
        Wed, 2 Mar 2022 04:24:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3efdnp7r60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:24:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2a+Nd1S6wOTZbK1B+g5HdtDt7Wt3ZS3I7kSHaxuNmULW05GVpLX8kjqemE5gJvl//sz+KqbPM1FuxltDJ3TJ9HgzEfaz5h8DilWnATjRJMU4YZQsq5EQCKhYbO7JriVXdK4AhraRaEbXajBMAH6ZOi7QOHggoOnRyrcrx/1Z5S4x2o477tGyxFtV+hfPxW6T2yaYYUSeeLeo6NPvMkamqcpToSaZ4UN5DyCX40rAPa+XflLszVGdLuyGo/D6575CoGRqLhQnhEgo8Ww1DrRM2xqOHpzNToIDusLfRZAsXDb6UwnAdgs9UKWj4aL0G8n9cSLdwOMWOmWGePsZxbkug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UC+BdkbXhZ1PEX4uNE3kvhxxtyOX7aFRQh2nt1dmHS4=;
 b=R7Ax7I8a6RgIfsR6m9NKCOz/zvc+0PWilrhWyFFYFaa0qZ24I8mj9CD+VQ9Ve5/A1dOPYC7w60IlKS/KJGMX5TUi4mA/dA5ClqTs/HyE+zqki6w8fd7hJJmyjgLWdcop96UYXJK0dVQ+B34+2PnWxNj5UPQ+l4egybZ/odZ4ZTrOnDN2kS0kiT8tshvVVGWvCaNtS6U7IUW7z2giuqQP8YDnqhzXH4pF7bEbfkmR00rv8DHvdGbinN0MALDpPb6pnIY1D2bmN6t/mJ14frNwWvLeTovpHvCdE2pYNcSA54/8bHdfDzu2j0EvfIOb2KddW5AcqFXFW9Xw/Eyujmsecg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UC+BdkbXhZ1PEX4uNE3kvhxxtyOX7aFRQh2nt1dmHS4=;
 b=0Cxe17M/tMorroY7grhOu05B6QOBhTVlm91Rqu9g8vEU5veEzi+gj7LnN9J/Nw3QTgWWZD5t3qVINr8yiVk+L0GeCO4tDspHEXljeOfr+AHMvthMMqmFbvCdK/BR5a0H0u2uX7F4ZGLK7ub1lfB7CCu6JLPu+EBVJPIgr+9vQoc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1803.namprd10.prod.outlook.com (2603:10b6:3:106::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 04:24:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:24:45 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v2 0/5] Fix mpt3sas driver sparse warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfs1yob5.fsf@ca-mkp.ca.oracle.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
Date:   Tue, 01 Mar 2022 23:24:43 -0500
In-Reply-To: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Fri, 25 Feb 2022 08:30:51 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:806:d1::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d9e9159-bcb7-4cc7-abe9-08d9fc0494d4
X-MS-TrafficTypeDiagnostic: DM5PR10MB1803:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB180314D63D55DECEFE26357C8E039@DM5PR10MB1803.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWwTd3BN57YH+zszdEqlvQX32cXqYBoEYZ1hBqfwb40jfCXTxj9cWx0+fVnxUgXK1OlVX81rfdDw37mX66aNIhlGKG9uJ4aIumJiA7MkaIFXeODsCTtmGCOTwKN4AP/d2tIZnAVJO96GwQOUizq6e2WRSuEsL/ry1d13pw4uDKjOY3PReR7AMcUtpiJblBsjx0fR7JSNAUPmpazfHgvnKRwxzwmrEIlYLovygN2Cdoaajm9bYf2ggvjr7GeY8Zfacmhe7YyzKVxDnUx/LS8uyW06AkGETLAu9BEq+bSekOTYINB/p2nFDIM2yvugA+hLUvb4D8so34Lp75geZBMmU32R8egORPOtF2r9y7zQaPgyn720wq/UYzW4WEBeaz9BptQqavKeN2Fc7G709yJ7U6QtSm2pfs9H6IZFl5Ghvdy2Af+cbI+SzPPpd1JMtZV0C0JbD7gNzcuq15fajn7A/BI/+y8e1Rw+Oj+/U17vR2c+LrGprAg8N6hfwG+ij+TP7vcTHcTRg8rSRg63BpmNzsKUBd2IuztAywaAT1gWFtImL2hWHsK/w5G8u+rHvWSPVkgOzTm2YXNqn7XYCiTn7PsbufPEoiThw0TKbVVq+TrkFiYypv/KvCoWAYeID1H5q49dqeT/Rv1D+V503TQbRqSYQYaa/3MtzVcl1IhnakYGa/EpNq5jgDik3LH2GbBDxyHqFcuhMYv8eSL2HzxGhpc4OF+323lOxJZaeCxaWVEPesZC2Ek+bUnhQUHpTPaF/f7BbdvcZsJmZijR7ZmK0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(26005)(6506007)(6512007)(52116002)(36916002)(508600001)(6486002)(54906003)(6916009)(5660300002)(66476007)(8936002)(8676002)(4326008)(66946007)(66556008)(2906002)(4744005)(316002)(86362001)(38350700002)(38100700002)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+FdLOJuLPoeJsnW5bB8pUf/39AF+zGjCY4IMMbCkkr38WmwtvAHdg3jXngmR?=
 =?us-ascii?Q?YLbGJ7wwfheL7q9E8sXygeYlaBUYYtmwThaLfdHiTUeCbeRXi6rBGq8LCpqT?=
 =?us-ascii?Q?ZYb6/NX64RTpvu/OFGtZrlwYBBo0dI4viG5+qY/9yP24OXk2FFjqCcdDNJes?=
 =?us-ascii?Q?Jf9RSmc7fYbSdbi7cyH9sely/hRF3lUVsDKh4PHBExnerKRDdEmSrds4JSw8?=
 =?us-ascii?Q?A3o36A9Pf4MJEMGnMZnOY6pj3BwVGLenxHvrSjWReZueqlblJG51astV8BiA?=
 =?us-ascii?Q?5KR3UybjwI8vTKtXRXvL7CwxuOaskg4aIcIr2jCviePu+O7AwyJ2ZQYiO15w?=
 =?us-ascii?Q?54rh+OIx2I1My9lbZFFXWecCEWo4LHJLLyTN9UbxB07uhMDbek47MNDjqhWD?=
 =?us-ascii?Q?OvyrprT28/jv51t64H2yVGAw1GiQ9wdICmLH/cig5J61Y+sRQ3b7+BkEedrl?=
 =?us-ascii?Q?pQsE1mt4xFR8zVKUr/MNh3pX/moeEb2uGSWYUCTmgleuPpVXP2rmF08sUlVp?=
 =?us-ascii?Q?0ISmLdopPBaWJYYwb8vevgrhhWABaZNVUQEeQNU5yxm/8WvWiUxDHOv3jFa+?=
 =?us-ascii?Q?KtSt/THzVXV6Od1g5IWAoZWsiQwo8QgSh4LEvK9WCB9jHemYqyfj1BqQ7ibD?=
 =?us-ascii?Q?E79ExQxnlW94ZZ21WYdqRnRr2NHXN+kR5zh9OOJTTqc5n04iW17bXXZqLAE6?=
 =?us-ascii?Q?f9UyUrMZzhFghp+Aakklw6g1YG9Wz7o3X2Xfw/sG/JugvjhbWQAPP/e8hQXH?=
 =?us-ascii?Q?3udJU3C1RADVcJcPuMcTnu8aQCpW2cvU1dVXvs4WlaOHChmRQi52mdRyTpFp?=
 =?us-ascii?Q?H+fxuMmSmxrT6DkyAgiN2ys3SangnS9ADpW4UGkEHbx/NtXgB9tTRSr3mtvA?=
 =?us-ascii?Q?A9HYLbvFgvwv6CAzymM98EqTd9hxyIoOCO+TR6c8j7ggEJPM9j0q95Mq3Y7H?=
 =?us-ascii?Q?bkuBN6Fb1VjTsThvWvBiXffUKG7L708Tqe7ranOCrNZVyDx2DJJXE+i4rtca?=
 =?us-ascii?Q?zvEWh0WeaTn5LuiNoLNQXvB3yqouhqF9KNqmVRwN2qk6zWZM32mAb0qjbfN4?=
 =?us-ascii?Q?7/v7xUPAgk6GvY0jxyZxv7XWx4Swo70RW7XJSIeU67aymBf2LCPH5IciDoMG?=
 =?us-ascii?Q?Zu0wgtjI5tzUp7bBSlLwh52yxfRjmKj1pgERganNXH6x06Sd3m6zTKur1cHC?=
 =?us-ascii?Q?tqkMAM8yRxmgXo7Kme292fhSpTY2qyZbLBwWzZ14y2dfgJFwnO/GiUMwuqY+?=
 =?us-ascii?Q?1QaaqDITJZFDHpyJXDowH4VGYffK0VJDTy5S5naTUkJ/6xE1WZBWbBlesMYw?=
 =?us-ascii?Q?d0r70vG8+bJM1Hy33tdRtljMVgXYwVqVhYcqiFitnfPXhiB8YT1B35IxwL3T?=
 =?us-ascii?Q?A5sbdNey9J2PIJgnTRVq3mJosrdm1y7dlWVrbmHpOMBXXpRMY8V3g3P9FQvs?=
 =?us-ascii?Q?LtshuUyShddXwgSuR7qAxVp9JLQZMay1GRtv4jVS0aK+0tDMJpqOA78d5zsc?=
 =?us-ascii?Q?Tvx3ASaA0sDTCw6+/QEEU7Bla7oUNq48QbNgfYW+8nLm8SRgaF+A5gpu8ibr?=
 =?us-ascii?Q?GNkNGSK7IR/tAF+pMEOcm+J0+GfVuNfnVf+YyEXPnrKB3S+B3Z2AJCdLh+E5?=
 =?us-ascii?Q?b7cVUix2YVq+ySAzKwySrh19U3fO0IL5EcealHlQLfxcnDaJMd588N9CgHeI?=
 =?us-ascii?Q?drNRhg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9e9159-bcb7-4cc7-abe9-08d9fc0494d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:24:45.7607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSsL0RSTByWN2Ns2ZVhr4nV/To5I8CJ1w7BYGN2AcxEIieIb/kr/HxmfpFML0k8s6tu1AqgzEg+2dqCJbuK7htWT73ZiwXGqdd6CFZNee1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1803
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=639 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020018
X-Proofpoint-GUID: Jb5za39lEd76OnZ8y8UtIvdYJkGymALr
X-Proofpoint-ORIG-GUID: Jb5za39lEd76OnZ8y8UtIvdYJkGymALr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> This series fix (remove) all sparse warnings generated when compiling
> the mpt3sas driver. All warnings are related to __iomem access and
> endianness.
>
> The series was tested on top of Martin's 5.18/scsi-staging branch with
> a 9400-8i HBA with direct attached iSAS and SATA drives. The fixes
> need careful review by the maintainers as there is no documentation
> clearly explaning the proper endianness of the values touched.

Broadcom: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
