Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC323C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 14:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C83860F55
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 14:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhJ3OJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 10:09:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1306 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhJ3OJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Oct 2021 10:09:29 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19UDUnNs009158;
        Sat, 30 Oct 2021 14:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bgibXoZ/kHgfEJCpR0i6eBJkR2lm99RZowcDTdjJiVU=;
 b=L4YwYZHjnBxXp/a7KwSzyv1PtwYMm2G74eo5hEbGqmxOWtY3N+ib1iA+/fntiR0Dltxw
 8qWKeTzyFLJ9jQxin/ynh57ppgCE0axcD8VPrvRPh54YQ7E/yTvHRyPC30g2GU+fdVdR
 qpmHO1tPCE5JD3gDDtdDSHT3uj3ttTUc+eAoBf57gegvGMLKJQxG6Zjf81aTYFxSEQam
 nnQOH0BjcKLJr7D5wAeZ4IXzf6xvOFZF6ZeRw1WYhmce0VY7QKS+lp3GAYCJv2Z1VkE5
 yL5ZRcWTg3DAio0IaY5w98RgtjSfm/zRlqw/WWPl0Jmwtre+q3BofhLAn5BvAkCfPXYT OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c0xkvgsgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Oct 2021 14:06:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19UE6Bgr054570;
        Sat, 30 Oct 2021 14:06:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 3c0u5t238y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Oct 2021 14:06:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG05HY5dWJX1Uux+hrMyRTRmoxImWTSAjNRjp8noxGezKYryPNNSRwecRVeWkBdGEu3ceXMdum4KKkCdWxwDCoXp3G/k+v9SptaDMmEet6bcLiBBS0XncMk5w+xRIok0RHrsq5mwlexIUZK5ceXcl/MjvLKH3kzEbcy0KH+zcBnW6D5zXfiQ+svfb2+m4jkbLU9UXd2LFmt5YiqlyvT2fbW+g37QpHvrFCODFB4P8CzzYN/E77Nyy7wD9q+RB5FuHg/XZ/bpw8Fp88WVjNBj4fzpJwGLSqjHuJIyE96grhchnOE3+IU1Uo64HXvNJQ7QGj77waXZeE3McZ7pJ1+TXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgibXoZ/kHgfEJCpR0i6eBJkR2lm99RZowcDTdjJiVU=;
 b=MJXqGanCV/u8YY6sTKLQ9Of0bl/9o4pGbbYyBjEYU5BCcLN91XKUgrfzes2Ht/zpVvCzfmA9D4AblxGSTBD1gDAA/ROiFZByrJsSjchy05up3JSqD5qIAVbUJ9lftJ+yBkaZ5PAG5+bwyiCI0+1qcvx9jLkVnQW6sx/t+Jn5n08U8Zw5SjL7wwJzEMR0/zCQBK+9h38zg+xymGIno9iUprSrMdQacpRvnRphJrvFH+A7G8EYw0p5LvWulyD+BAcIrYF+Rpqr2TJjzNjvo6IcaTPYGW2gkMmhedVm1KJvS8RjNi9jgiLU3pROgQAzbJRAWYdxKG3qdQIUf8i2Dom/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgibXoZ/kHgfEJCpR0i6eBJkR2lm99RZowcDTdjJiVU=;
 b=BcMw15q7uIU4ThTY8grnCSpzuud8qcdlinGscOyy0gjo2wdg7x1lsrnSOEgW7Z0jdKvGAkvffhUzL5Gf/axl5jlFGKPgDTX6ZZ27dkYhaCD3EAeWXCDjqvk2BEkQJwYmHfRmx7mnVy0i/x0nbMIgo+1/Djs9KpsDKM7q5STxUCE=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Sat, 30 Oct
 2021 14:06:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.018; Sat, 30 Oct 2021
 14:06:48 +0000
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bean Huo <huobean@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r42txpi.fsf@ca-mkp.ca.oracle.com>
References: <20211030062301.248-1-avri.altman@wdc.com>
        <0f81b6d74a6bde6606ac93e20b65cc59b9bed5df.camel@gmail.com>
        <DM6PR04MB6575F504229146B3C465C8EBFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
        <DM6PR04MB65753D4C8069120AF4590D7EFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
Date:   Sat, 30 Oct 2021 10:06:45 -0400
In-Reply-To: <DM6PR04MB65753D4C8069120AF4590D7EFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
        (Avri Altman's message of "Sat, 30 Oct 2021 10:57:09 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:806:a7::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.62) by SA9PR10CA0014.namprd10.prod.outlook.com (2603:10b6:806:a7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Sat, 30 Oct 2021 14:06:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fec73034-906d-4a0d-18b7-08d99bae8333
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:
X-Microsoft-Antispam-PRVS: <PH0PR10MB589393F24C69D6FE23E9D9B08E889@PH0PR10MB5893.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AVYyNeJs7KdE4WxE/uExaW+dfRkgNQes+e6Cs8shveF/AELo5fAo/kiGeXr+B4Zi2SjLEEy0CZQag6R4zK463fH8rpTQrvLA/r+YDzxAE2/kVkLaL9jIwmMHgWPT1TsdIR3YFyAbNa6n325Tw8/iZKgq7Xn3k3xg0q3oc7QNoVG+eM3RHJUSQt6ArX4+I2XP2aJZY52b4deuwa2xI0JWiWJ3ZZIbnoeYjaTHMi7hpWFXmwN0x1QlsJnBK8yEydcrLpOy6m5jmxMCfezcv520iyATSdKnKg+phXlestiNDXLxfPZ/yxfQNhsqoenDAKf65U3ALjBOv7mTy8xmMtUPEdizkZKH1W/sV58gmVjUUXO5sar3nwDPkerFwKHCHTCW1Rz+wdIDCnsMD7Vski6IxvnHCbzHI0O5q9Qpdk3A4g+rJfSExMPp9PNRWVFBeoha380pu8xHBl/RBlaDuJikzbidI2Bklb2a4A3IwvCRtjqR/Jhi/Zv8keM/DyVWhLdEU2/7KIZ6ZlRjzE85Pe0MKrvaRagdBaxEJBnNCSbQ6AP0/BqKfCKt/PIxBQAPi9AHfN48T8BA+bIac5Q7D411pD28cfTbLfnBGddzV2CBt3HpGbjF2hGf1hGcibu8cnSCfiBF+TFwDzQlp3V72vwsIxmPgsyHIq/Z0dm18t3ayKVp52cotbwDyXypgPsozl9AoTpkxItuxllc39jzCxYZbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8676002)(7416002)(38350700002)(38100700002)(66556008)(54906003)(83380400001)(66476007)(8936002)(6916009)(316002)(86362001)(2906002)(26005)(4326008)(5660300002)(956004)(55016002)(558084003)(36916002)(7696005)(52116002)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EJpSgv653/dqB8UHRbyXcn54MkEnpP3h80l1t4OAvZwmk/ZY8fFLY2VbYTCd?=
 =?us-ascii?Q?n4c7uH1CuDtux4h6Nu0h0w6nvSPFkkvQVazi+vnpoDlAvHH57MNtG2VC0gMO?=
 =?us-ascii?Q?mtmHYEkJeDbXNK/g/TXNoiApg8rbEy1OcEpjM/ApO3wgHryb/PSkiR/onjK9?=
 =?us-ascii?Q?exI4WTbOXXcOoAl5arpYDb8bEfFqoM89htXlTo9/2f/QeDGAiqsXNkw/n1rU?=
 =?us-ascii?Q?oI6twWeV0pg+CiMuHXqps3liY+QnGRyGRJHCHXianAteiCsGrkH5rTdB8glZ?=
 =?us-ascii?Q?MsZrWV9WAR/HTeqVXE7XM3hoEohP2cQMEtGSzCoEWgPLS1ywtHCej/yltG/o?=
 =?us-ascii?Q?iMNbLKS6Zdol+L6EkvMvojUMKUe/gnEtvpiXMZJDKV+h5lJ3f/JxLaXEsqF+?=
 =?us-ascii?Q?9yx10YnUWbUy3idcbAjlWAA6DTYwLFXHRl0kjZuDlZ+GJbgRVN0ML4o2hco2?=
 =?us-ascii?Q?rnJAFCP6nsc3JNWpbkvkf4hxFsdi1wKVDJwQzjjhoBh3wPxNB89L1R069mf0?=
 =?us-ascii?Q?gP3MOFvzTZn6cuT5xTnByL7O/SLr79J+VL+1XKED0+9oIa7SDiBea6sftiri?=
 =?us-ascii?Q?lX3+zFMkl1Wf7U4lV1FQZBMRRzWQqfrspWMt1pwjyNLBwOZ1ecym7O7cXFBf?=
 =?us-ascii?Q?aIb8YhZifwi29m+Q6CNJIjqq611c1ppk1w8+n0GwKlu4WGibAlp5Y+ueq6fw?=
 =?us-ascii?Q?ysjvbpJVpgutynGVfb7IpkxagAwHyxPvTFpxCkpd3qDAydDaUl8F1VHvmHg6?=
 =?us-ascii?Q?56G5NsTBF+gtSvq9yqUYHOTQscI4LDVAdzjxF0RLyIAike/UGb7pznLLJfca?=
 =?us-ascii?Q?YVoqYUgMO0ZOASy9BygCciwZURPG8Xv9M3LmuVrQlaenDPIM+MEffzlWt/vF?=
 =?us-ascii?Q?6r815xa7fdXFgTS202Hj3VTd/PkbJ0Ps7aLA5qESm33ORCBiN4Y0Dy3hunRV?=
 =?us-ascii?Q?q+lEKZPRPCoUftQr033fG/pWMSD3VVHRkHXfP38n0BXFFF7VRqjLViTWU/N8?=
 =?us-ascii?Q?CfUkmY+O7SCm2OWGagiv8Qpxon3xCG7X65Wv8p4+t6SFlKmqwBpxycu1QR48?=
 =?us-ascii?Q?SSaIjG0c8ZMRsZAmR1klq4fmVuwF5S8S7lU2b/ZoZM4AsGB0BwQHEyWgE55v?=
 =?us-ascii?Q?ncXhptwNQ+M1k/sRX7v9zATR10hO38OvPhYFapMkHpow0lT3npwaRWuKhSF9?=
 =?us-ascii?Q?LUwlG+rUT9h0COti3x6410/ERdAa1qfz5FvN9CCltTp+tEV5d32drga5yTSy?=
 =?us-ascii?Q?ZAsItWLCzglN8OUBwxmt+smLj2xAnBySA6h3DzwCLuh+dGzjdTyrLwbB7Y70?=
 =?us-ascii?Q?Sfb69a/5M+0nmcCt0deoT8D13MyBXJDvJP4EoQtb3z8LT+pIpWvag6Zph4Fv?=
 =?us-ascii?Q?R3YeHZ44Y53aEFLZm2Xj9f2c69wZmK8eFU8fdJBp8bJyFyPr6h7VaEvtGFGf?=
 =?us-ascii?Q?ClobPmvscXj4erSpK1c3xJK6anDF+hK8TzZLzeCsiAZ41rXWqUCE5aK2N7/q?=
 =?us-ascii?Q?Meh/J5OrvMDKp1B01qjVW6YKKpZjvxAn2DqJUXJ2Od3a8NA3mYRiA+BToJMa?=
 =?us-ascii?Q?ZGLSRdTULJLEreZuRhGTpIfdkamMAEJuSUbvMzzXHN3Sg6NkkayfLIN3uS1d?=
 =?us-ascii?Q?nLNEPNuuPjxnT5+Q8ekO0H4tB0HcP8QtR0T8ugdtEPbgFLh922VgJbUOy9JW?=
 =?us-ascii?Q?RIim+g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec73034-906d-4a0d-18b7-08d99bae8333
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 14:06:47.8400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVN2c2I5XGRHo/Sy9+3zMAqGc1yS7N8J6ZlH/FqZVPWcrp6xLEhYnXUG5VmsJ9YrPi01DWbTA9Y5F5zkIys6MHyhWbCZRpGHMeerauNB7oA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5893
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=984 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110300081
X-Proofpoint-GUID: m0eb9gvIaWO6SJpqU9qlRy6rlwF8nw4C
X-Proofpoint-ORIG-GUID: m0eb9gvIaWO6SJpqU9qlRy6rlwF8nw4C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> Alternatively, would you prefer that instead of all that, I'll submit
> a fix to facdc632bb5f (scsi: ufs: ufshpb: Remove HPB2.0 flows), which
> you already picked?

I updated to v3.

Thanks again for working on this, much appreciated!

-- 
Martin K. Petersen	Oracle Linux Engineering
