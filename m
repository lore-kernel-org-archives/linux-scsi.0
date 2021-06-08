Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F36C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE4060FE9
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhFHC1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:27:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFHC1K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 22:27:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1582E8H7190923;
        Tue, 8 Jun 2021 02:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=FfGogU0y2T+sUO6qBqvVpS+VQpNuZR638r5pz2ZKUN4=;
 b=Mrjk+5L+FngmMxlnS6eAN/1o40ZHYuIg2PwURZkSU1h/pmodmRKQzjt8y0BERfVNlwjF
 uQ79hEVMHOSqeHC7ETlyHUQclS4GxGQIXAN3zKK92ZUczdaz2gKwtT0Nhk076DX5lBNi
 tVr1NneBUS/xqCil8Qp3gUyhzJCuOLkAvei8ZdSHHfFcwkRLA5t65Sq/QenqRCMZj3YD
 c3bjZKY9EXHVkzUO+QHjB/l4Pe8iDagvryAthNLkXraifBo1WnqI1vcAtHsNSuuzrJl6
 YG+62akvbAidSi+kE+4AFmXPPn65DbbRvoBI7S3wXVQaq4UMLoPjJPvPrMJuSYZMYwz0 pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914quk29p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:25:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1582ESB3129833;
        Tue, 8 Jun 2021 02:25:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 391ujwf565-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8oIEyliB1+k/kvNNZlCCGHwZtotHUOFvCu+tT2CJHSOSSNM3Jlubk6+uZ3gfh3nxtLhkgYudCf+lOTNK0ur6rHk8218e8a22cILuSOJNnz+1wsOAOI5uzbCvT1t2zGf5po8dozLO6M0RRWegUAbDOctlWpzNvfKGrPklmdABY+OrFWoI13ynBiXwNOUpGJqHSLjfuRcPe/oZLYKWk/olh9u3yT4WUVAUGiuXNycRa5leMFym0FDIDWm6l2dKMkv+VP73I0ROpKKyt67W31om4Q6tkuWBRmC5Ymmhw5k58oOhctZcNExrSgOsamwxNRfiFKzl+tPVRxVJ39rbCnJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfGogU0y2T+sUO6qBqvVpS+VQpNuZR638r5pz2ZKUN4=;
 b=oHAVi6QgnS++okNjsG4J2pXd4BVIXu8+Bs/rA3HrQtD/hog6W/JuzN2dgXtdLIgP3gQSmDKUAFhkHRwTtjLzsxW5lLF7OmlS/+HeUmUJN9P2OvWQX2lZOvw1Fya9FiQPmbFM02UlHcmXnIG54afv3AwzLIqOr1/WQCED65hiijcA/h7ZHLU5goruHhRaI3lKrhJxjDmST4BCkmNta8f8HQ0Oly+6o+jnUBGXctvl7bUNi2AS+7xm5j7121N5mw1i9+wNUjDHVV+cKKATSiVae+LIJFKRhg+Krylvv+xHciXh+WVuFRYuhCtOSWEkBGsW+XIim4wYGdogbZqSR/wmLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfGogU0y2T+sUO6qBqvVpS+VQpNuZR638r5pz2ZKUN4=;
 b=dssqR00mOdAkMLROuu5hL8U5IvMf2qE9EiJ3Mq1CXC4xHDNQzPPlS/hkAgpNGBj/sBFL24GTyKETSrPz/8LgiaAax4wPD7iqnppmiFPb3wBWlZVGgyoxg34PF+7P9g3MxCnPw6FW04zoXgfCRYSjwxivm0Iy3fB/S7JTPDd0wVY=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 02:25:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 02:25:00 +0000
To:     Keoseong Park <keosung.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Remove repeated word
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0n5jdos.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210604024038epcms2p2801b5b2e10e93ba4ecf5f6069bf862f1@epcms2p2>
        <1891546521.01622777101796.JavaMail.epsvc@epcpadp3>
Date:   Mon, 07 Jun 2021 22:24:57 -0400
In-Reply-To: <1891546521.01622777101796.JavaMail.epsvc@epcpadp3> (Keoseong
        Park's message of "Fri, 04 Jun 2021 11:40:38 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0172.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0172.namprd11.prod.outlook.com (2603:10b6:806:1bb::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 02:25:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9441bc6e-70a2-478d-3976-08d92a249df7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4437DE56D10503D8E4F537A08E379@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6vNNo/gHyXDFt8w7w4eMwgwSPa9VhJcqt6xObYo14qmPJygbMr0cormkNuaMGGEYAA06waE7bu0zr0tt0gCx+BDOBmdz1RQAq2FD3mXt0KJ29kpayhDQo5Wu/SbXvP5edntlWC3ZorDhkzZelnkXCjdzrTIWsFK8jS/FFTU88Us/Hcok2fCSqm2ntkwkbUhBpkODzu8Vi++RP1O2jPHj7mvgkRGBKAOqzXDL3qBrEiXJx+aYnM+TdDs6J+PoWBaYOWO4c7ciWJOsoXio9wWphBo2NiXYCRFtdiGbEsFXnAAZz2xD1DFTfFX8CDvHAoktxbWtaGX5lHg0jOlOY1WJru+pTGtpGvkMc34U5qQxgA+ynE/irbIHe23HfRn6TNcIcV7m/wmS3iGa/nqa/hEVwkI8uKUwekOF31CKGVjpv262fhI/wpYQnaTOPn4GX+XQ89nTpEon6pY/YdCV0FVGmfD7xp9riUu5lvDExAzRAhJZSD45FtUtyRS8wtGcZHXLU3LppI8wDgnATFFJfDid69cXA2Byx4aw5/aGhnkvN3TfbswDbfDs4l6aYkEKqyBZ6rNxWCnJmhDNVygV3GMPanj2X4SN+fk2C13wlKeo/GOGTv6giTXL7YSQXYRBkva/gBk1F22mLWs29CsHIvBLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(366004)(396003)(55016002)(36916002)(66946007)(66476007)(66556008)(5660300002)(8676002)(7696005)(38100700002)(38350700002)(54906003)(6666004)(8936002)(52116002)(86362001)(7416002)(16526019)(26005)(6916009)(186003)(956004)(4326008)(2906002)(478600001)(558084003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BCP+Js6AMnhGUv9q3CZHia4HOmg+/FvWkebLZLo/JL8xOR8gN2oIhePj09vo?=
 =?us-ascii?Q?rTEh55c+Ha0QApuSstt15zp0JtsXpYdkViHBXBwjSaC6nWX9lzzVTowN5gJq?=
 =?us-ascii?Q?SeluCGh+4ufx+Ojf/vCnsc0r2OiqPX33eW5B/YU60wUmQRmWF1g/CktzmTHN?=
 =?us-ascii?Q?sVXGpAScLMnukXmbBbdhPHeV7aX+qxTsjI2iJKLrg7K2YxySwaZalsWAUDcv?=
 =?us-ascii?Q?iEwJaes5kgyiimCGnqS6dnFP5eb2gFVKI8giMuvtu9H39SlyLjROTGtXNsVO?=
 =?us-ascii?Q?6pxXVYtRrJwx0L2JIIXHKyleXwFfF+vGqP+A+LQB9vRAo1u+12mMazNj1D5k?=
 =?us-ascii?Q?jNumbkswFdvBgjNfrTvwULrLLMrR2Ju15xWBLhTBPJuK1CyDorW74vSc4frL?=
 =?us-ascii?Q?sBcDaknThpbhKEh1449FfR+mV+wARI1W81tHeB69safl4JJVzQosotO1wPRA?=
 =?us-ascii?Q?kx4WPWscLO7AW2WaogfKPvlWtyq1LslghHAyMQL1YMEDoirE7nia6bbvWWaU?=
 =?us-ascii?Q?pKiFtwYtXXNXQnxChAnNBz4X/RYbgy+4cWaZ8Fui08f3v8qig77uAj99ydMu?=
 =?us-ascii?Q?M9/pnBms1+Cr+K/ebcgBsVsFf20PPcUlZiC4d56deC5evjQnnwa/7cfT/9UF?=
 =?us-ascii?Q?ykLiG29JoxYlJhELFctI5FewYitH1yBO6CBoJFbag1x893K4e52etBHW5kQz?=
 =?us-ascii?Q?0Zzm+9GfL9kiVpQf41373r17Fgl+OhVzMkbBT+3EQqLTUZN4oRxezSLhyam1?=
 =?us-ascii?Q?u6Tc+da3lldG7Ix2MQsBdoHO57Ew7X6onpm2kJiUggIsvs8R/xI2o/tIOyQK?=
 =?us-ascii?Q?J/3wRDktM8nFtc5w6vfNc8s1uk/4+Xdr7Ag34YKGBp2qXc9dQVkI3ulfWMRt?=
 =?us-ascii?Q?s9NUENPawBfEX/r/miCUU1FNL9B7Rayly98E0eoEW9eOm2NheTVEubuHh9Ge?=
 =?us-ascii?Q?RWv9yYqR9Qj+JD8+Adl1ZKNkyPUTMN+80KYrP3QKxklKonpUg5iiPN8YHON1?=
 =?us-ascii?Q?NF6F7XdzoTEcoTjLuTWgkxhukGYnz4q2Zgof+RaCsZ0+yP5Atc8zUbEGy9D5?=
 =?us-ascii?Q?voACY0/PDlij/p6uDNH77r1GSlgVmHC48pYkZn8X/pMANhN6b3HcT/bybbfx?=
 =?us-ascii?Q?LXdz4lwatfO+HGij7pAOZckXxfYnU7ugVOUVny+z1+HwXE1DVUEwOaRJxNoW?=
 =?us-ascii?Q?vT+Zvq8skneFPTjtRajVEOvAoykiwspslIwLRQrldgZfuy5HFGt997Wx0PBW?=
 =?us-ascii?Q?hL80vJEPEr8ckUbEFUpd0zUpZSxNq1GCzviG4mZd4zCII9YIr4NlFg93M4oN?=
 =?us-ascii?Q?I9gXbPio8NiXcprhHxe0p7ru?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9441bc6e-70a2-478d-3976-08d92a249df7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 02:25:00.8095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOMQE5tW0jnQjj6litB8NUTEILKGO4fD8Q9Tcrx+uhBN732sR48WqmZFDVwvtGULz1/hAsHQH7Y2CQVMt5aqZh9/8pO092hLfw3mvw/I6KA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080013
X-Proofpoint-ORIG-GUID: SGTDAG8wVLFhfHdxVZ5lPlHYqHubfRrU
X-Proofpoint-GUID: SGTDAG8wVLFhfHdxVZ5lPlHYqHubfRrU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Keoseong,

> Remove repeated word "for" in comments.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
