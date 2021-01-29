Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D449C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D2B64E0A
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhA2Spv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 13:45:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55330 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhA2Sps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 13:45:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIY01l027495;
        Fri, 29 Jan 2021 18:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=AvIirjUmgnSvNC6a8dvoEpGiheyzKBKbY80VUJJpQ+s=;
 b=AgZ3tZuzZs+bcwS0Osb6yV4+0sTUsnyUHxcx8p7f63fBtx3oX30ZNkCQvftFM9eQcRaj
 lO5/wFX+pYhzBRhsYHhctmvybJZ0E3Wg70uPouVrfWdyCPZRZSDpauFkwVZgjeusV9FD
 /7wfScVDKIktg3KATkX28D0kEQ8mV/w6Y1aCi6IaSWW+uWBDo3FKFmpwvAzK7gM/rP1f
 v6dqzJ6TDlJWfv3qUg/EBr9YvUcH3ua4p7+l+dw2IKwjij8Ke7tZPg6YCD7YKYme6jCq
 ik2zGzhyLQGqQoDHJYlwZXqc6tZ1I+F/I4oOPuhAY9L2zGuXiR36/ZFKN9UVIps0CjSc OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7rasvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:44:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TITx27157661;
        Fri, 29 Jan 2021 18:44:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 36ceuh27na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:44:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUSXJgo7sSNWXwBxN9LobweA+x3DROsFZ6BByC9O3TcEL3eRLYASsCBUf/YSHd5PnIAPyT2rctWARvvoRg5pumG1xfdZjX8i8oWr7syvhwyzQNy4QmVHOmmXUig+92bdYBBDYCgOTUpTuqaSYnNgeD61dn7lbTAgnMSbcOGSG48hMQYL7rNMRCno7xqDB1ppDvge79I/JbvEV8PDSPBZApLoioWB55Ij6IUrZ5efXkqwQYXAFmYlTuMS4qMgvv1rT7bpHmSdKQeW1ymocEW8w5TNDO+paq0NQfOC+jEP6a2bo0elzqeJOlurXm7NgmC0F3MwkSOMpD2VmsBN4aYyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvIirjUmgnSvNC6a8dvoEpGiheyzKBKbY80VUJJpQ+s=;
 b=Z0FFuLVq4T310nHex+43D6d0B2atlN6LkcJWMIeD3OMtyYC/G0bFaa/h2kdVNplTcDvBrBD7/2jikdKJPJBv3+WbOGwousRi5bIUgcfo1Tyz0gvZrRt1V+WRSkkdW2PtgRGHJ6Z6pv5KWm7L6du9JqFz3MoFadnFDIQzFFC0pAzP6JkeCEg9iESjSv3tnzwECV0PMvqWQvvo0O8b+1q4BwlQKZ996AiWinG5wj+kuRzQunaJ0DqBWlxEf8vgh2iUik1pLM5J5uJVYQIcGxWJS2S98/aOP10z1uAUxqiH2+hXUqt2USIn6M+2F2vqxZUBlJqrC5WmpfBaIFaA0owfMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvIirjUmgnSvNC6a8dvoEpGiheyzKBKbY80VUJJpQ+s=;
 b=vZVMQihvui93T8txvVyL09ZbANdzBZmzj/5kTnFNlxkAvQGKKAWWq9HeeqwTL/tXCkvYwHmp5JjGIScMAImw4z/Sx3KPwhYsd4qn7Hzw8sJIwiHRtasf2SXDnI3fyHCC+gjyU30S/PhLM9PgNh7dZOccrsQxZEXkN5BIkuiq6zk=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 18:44:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 18:44:46 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        bjorn.andersson@linaro.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2] scsi: ufs: Give clk scaling min gear a value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0rvzip7.fsf@ca-mkp.ca.oracle.com>
References: <1611802172-37802-1-git-send-email-cang@codeaurora.org>
Date:   Fri, 29 Jan 2021 13:44:42 -0500
In-Reply-To: <1611802172-37802-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 27 Jan 2021 18:49:27 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:610:b0::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR03CA0022.namprd03.prod.outlook.com (2603:10b6:610:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 18:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c741f16b-9613-4302-64ef-08d8c485f336
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466390BFA3D81207164004498EB99@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKjUXJn/2Pd81+av3TX8WybVNI5G9/SQ0Ud06w5UQWF5ZPjWlmCr1LrJJAez7caG5Ce46XjshhBC9UNE+500iWxQWACNv5bUnaPb7lDzo7l6ioD7Uko+XAcWB6DfnMpTJnqJaUtV7hVVWa+Y2cs9PZq8C5RE/TiSHiejCl21/cgu3Xp5WfrpOYrC/lH7hJs/fDLuIgKTgqFD5pQrrbULtnuQDcO+Qaf/7mmbUL3e1BWaZqVEI6mvL6qQU3qxEttJEiQKpHTH7EVoIILN0VILK2o72VvcZDGuRuUuAgU07wJyOHXyWOIgVFNuajgYCUPdkEiQKD27qKKeL5WLttxw8uOsZRtbtPtxqbDvB1ezmbsBv3IGqrnLLoiaGqLMUbaVmLS73owb2IntcdDsYXuODfCGGgUXNizt5OIf2bU3jXlhGEfmGhyL2Qulxg3G00567Pu2KStdV7OmDgR89FXRDsGzJc7U2D1v2BJLnCy3YJ8TNQShAR/ZAB2Gyj/93jEiOqiS6WKOEH/HGBiZYXXW4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(396003)(366004)(36916002)(66946007)(7696005)(52116002)(86362001)(956004)(558084003)(6666004)(66476007)(66556008)(26005)(16526019)(186003)(316002)(478600001)(5660300002)(54906003)(55016002)(8676002)(83380400001)(4326008)(6916009)(8936002)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CE/nxLnTtj/80+ea/9W4hhfhEgTHHqZ58h6CRd6AHlvqHzCVoMfFr+N25G5/?=
 =?us-ascii?Q?ZS7quQTDamQsvduO5JXFXx4Bm/2jCa0HE2JdUSidlx7lP2LTPTTb2SZaWdvq?=
 =?us-ascii?Q?FqTeWiYGtLOOmfHo/hxkkQbmwzr/w92NyrU117A9Jli5HINfrgDPkUulFVPS?=
 =?us-ascii?Q?wde/fDAv7Z0osPma8+I1whGRjMwZDqA4E+49cfzxXbE+QwolY0UlJ0BrrvBf?=
 =?us-ascii?Q?2wkJ7SEc6eE/0yTVmTn0DsJVecgwMV/igChc+VH0hlnUtSNU49Dth8Wq4GQa?=
 =?us-ascii?Q?rCuwD62zd5FGuQfZm6/XVqKz+TFxBvfQBkRhLCJKLzPoE5ZzdDbKmk2CB9Rm?=
 =?us-ascii?Q?H1WDla9gRkLGFXSXXRekP44LXB7IOsBuenHlzQy+12eLYWjtjfYClXouq80N?=
 =?us-ascii?Q?/Hkt7pQ0NAHKRkRddTfzTrL2qXRFqX+HZpgP3FzaT+VhubWRObm+VGhsPzAy?=
 =?us-ascii?Q?7SHkWjV+VKG9Dh3sn5TwN0kfr6xdM54HgxSq9Ico0G5kwVWOu1jXe8YmtQ13?=
 =?us-ascii?Q?xQVuiIv/ULqeJdWuZ1EZGwatCUAWRrJ1Tnx4Vd+IyEX8FthTq5qMqpCnPlU/?=
 =?us-ascii?Q?fF0eVPkDpfFniaP9dYDkjHVkms1fGLhPE4khDMjnQVaZgTjzI0UoUP2w3uCV?=
 =?us-ascii?Q?RVLiLECIYyaeN4QsEpArziA2OCPTcsRJM40ZEuXRqaIpt0OSGdSh8Z15e7vZ?=
 =?us-ascii?Q?EllzBFpSzfuHS73v4QyPTFYOkSiZkabta2Arwm/INMMNJwSOWIVJ7EjD84sR?=
 =?us-ascii?Q?6XmT0U/4wVdonIlvryveCCz1nC0OJli7odQg/G7yEygfNzxcb9X4GsRsdoLq?=
 =?us-ascii?Q?0YOnl6AqXM5T7yVUZqAW/43pK1CAb2yjG3R5KgXUh9MapO7YtLptWnjnZ9jc?=
 =?us-ascii?Q?7BGw9NYBIfjY9YLeYAIf1VeG60eGoh5cuXB+sZ5DDD7lP8voPNyKBzKxlPKp?=
 =?us-ascii?Q?lhiJXigDSezHgUHmExAARuzE44ndDcLaCUWWvgS0VjgvmWgfroKKxhDh5Xsy?=
 =?us-ascii?Q?/09xiOuTxKS81JrC2PFHAHsUlIV31HlwHHMr/wtcstjJ4upXVByTcxnZkLeK?=
 =?us-ascii?Q?Uu79eOTm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c741f16b-9613-4302-64ef-08d8c485f336
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:44:46.4222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sToAwcwnqv3VepQ8/CBk0MlxS4VMbPu7NFhF4w/efzKmTs6wTfLdQVudVw3GKC6tt7YFP4PuFPtYslpUO5sRmchuqYJ5qoEAsIf27JlfVT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> The initialization of clk_scaling.min_gear was removed by mistake. This
> change adds it back, otherwise clock scaling down would fail.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
