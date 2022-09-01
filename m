Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EA3ECAAD2
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiIAET7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiIAETb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:19:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF731114C2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 21:18:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNmjPM026908;
        Thu, 1 Sep 2022 04:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=jgNgbRDmKdbR197hYX8WMt5a0EniKwCuw7OXMbiEj8k=;
 b=GmmInfNpDx+sKjjUIzexYlIPBX2+PRRu0RH/ELoSkCWq9ZzVGPknnDptx/eUdFhSurdi
 /grwqw+NRA9CoNDxs7o+eigOuKa1rnl4vcS2o4jV/1GDmAVXfHowI6OwOybG0ML5mtsw
 21DgGd7ijqyfrXt9uYkXHtYqEF7+GGiiaGKhd+ZjkHt//mK2/D9PFvfoWL7ZAAtdSA06
 2serOBRMR8a3n5lL1ZE4oWWpBxJ6raxUKkOzyE0qC44y+iW0Hop0fwVWX5/riO7tm6gE
 ekcFd5p/glyOtCSV50iJ6uh7CyIzeSxFp07iVSdknHjAhPdtbKydhaXmLrWEbarmswHP Sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsjwj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:18:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813Nti4033643;
        Thu, 1 Sep 2022 04:18:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gr2f87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpOfDXJmqKPhZBSkJAVTgvRfUngXcgg0+TXmIJip/EPKwapwsLon3Lg0rV3rxnzOozzdCqQB6WO0QUaSfDy7AeEVCO9pTLt/FUTd9qPrNDf77ZB/m4xbv78sow36aFu4VUl3F480PlzvhwYojuR4tWNO14ppuLXpgNrFLmBDcJ2hVPkcUZd8YAeeQTQmUifOM554Od55I5E5z/170PWtFmCQSKwuILmA/VNtfMWAsvk+E8m6wFmIb82n9dfi9vcOl1ZpEm2d+tSPcpesr/5XYakI2RWn7Nradb6ARG5JKKlZCSSx9DJjwg7V9K96Jh/lwd564weH5u7IuhYyXiYGZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgNgbRDmKdbR197hYX8WMt5a0EniKwCuw7OXMbiEj8k=;
 b=KDu+aikmxc8GMgCu4gEfHC3NL1dWp51bpNLSKXzxUx3P9TuMt8+kta5D/63yBMHsU30RUtNYn1fKr9/7DjvLjyOuQbQSMvxMZSangqgv7F/W8gfXaTSxTJl55GINnyJAWdGOv3MqGdKgVGcm/Q2S2KxhMg/GSdC9uzyFnJAP7efr8+MdlubngJYhimyacda6t9PZUWIH405vH0chhYtf9hQmxO5WhdjhpFKnAEO0iU10gSjuj9iSvSO+/WOoR7z71O859EJqUHuPIVG3QunaxtvW4R7cx7nC816wce0FQIC6QKJfaPwogEGxH45PbmSf31EABb48FrhrgG8c64heBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgNgbRDmKdbR197hYX8WMt5a0EniKwCuw7OXMbiEj8k=;
 b=c2rrRO1roWsV9NG+HAvprIJ+7E0iZ3ZF87++Zs1lJC7BcGo3hfKo62lzyNR+VOc9hD76GfOzLptU3KPEBiFi/cUJTT+zlXZcPYph0b30q5IJ4fK4bCoWsAk+vXNuUcbwlIDdz6Sl8eZ2yfXS29DM1H11+aLUi6tf5gSMtNCt/ks=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5757.namprd10.prod.outlook.com (2603:10b6:806:23e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Thu, 1 Sep
 2022 04:18:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 04:18:29 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 0/1] mpi3mr: Fix partly outside array bounds type warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k06nn2wr.fsf@ca-mkp.ca.oracle.com>
References: <20220830085011.26079-1-sreekanth.reddy@broadcom.com>
Date:   Thu, 01 Sep 2022 00:18:26 -0400
In-Reply-To: <20220830085011.26079-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 30 Aug 2022 14:20:10 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:5:335::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 797c4484-f2c0-4586-7f0a-08da8bd105c8
X-MS-TrafficTypeDiagnostic: SA1PR10MB5757:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrHPiADElrOBM4o5s9NFet/mp+w67IDFXEA2xiK1fqoN/6fx8lpsQqc4UgxMUp08bmuwPXPrGZ6tsFhwcp8QORRUyWOcceaCFF3+dE0rYxZDcdtaMfpmSI4eDO7+Nye42jo+T2C+7xcxPAcoit6mKqLNn2bLpeLSsd+lWlrWVnLUILV/m9udtXkJNqB4GPymf9qbqpwl4n59vIAy2euemJzCUGUl1vk+8Xdsaf+kfoTTCEA4KhwmF7ZiD4fSYPiZ9ecew26LfSd74UW+iifqeDftllvA7jC3sVMewL/aYHqPmKbIoeADlD94sYU1aKoEAWu9U8XfhiqUkvYRlTftQPsBMkvBzwloEMAIWLQNHk7lHk6YvQ7IXgzdeIcUFEhBpoQJ4lVnwJKkjG3Gf1DmQOhaOYDGj3Jec+fRXBhWe++xqYFfhoSqYiG88A4ytDKBqbOkz3NpPSGN5pxSSaop/H+A0nFHlgM4KgbCCoKtJ2Rj8YppxWQxRG6oXuDiDmMGgzJl1gNuqmctdXxoUJRo61G9OIXIqu9+hiVII/r0LVQmcEgmapAHYcST0yGTWyIojoTy4sD5rx7J1yVIfRbv2pRQBvOjxl9ZjsZNaEcOaRopcWu3MzhEYYF+I07HnZ+2PhbnblSccDgU6kqdn/s3QuFfFhgtpL/Hk0EEVyg8ziG4gSQ+W4UEfbefUoxrVrBpwONc8JJQQSGcHiSHLOOsfmJ/87XFfe1rZmCguERd+zc0RQUQDQEM6U9oVm8eodyeF/NVGzQ5zJ/xt2tEFJlsVFP6ooKaXaFhjF8stER+/nM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(346002)(366004)(39860400002)(316002)(86362001)(186003)(2906002)(38350700002)(6916009)(83380400001)(8936002)(38100700002)(558084003)(66476007)(66946007)(8676002)(66556008)(107886003)(6666004)(5660300002)(4326008)(478600001)(26005)(41300700001)(52116002)(6512007)(6506007)(6486002)(36916002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CCZWXcOKZZyrnwun+0ynVe6moIJYxBXJa3lX8paB2LBr7pRgZKHdE7SzorRy?=
 =?us-ascii?Q?gsT/LyP1RqtzsHYvYkOVlLyyiUBa4aDhglZOwu7ppQncXKWQPpcZevxyGWiL?=
 =?us-ascii?Q?JzHxykUN4A+jtyc+LGb6p+ICJNkfPrq2cgQMlKFVQjH39Fc9PTh34r13i0yp?=
 =?us-ascii?Q?aGbC3fySqwOykbNCSGtc5qgYLf2fY+54jFi6//Fif5IHB18Z62ptiNCuB9gI?=
 =?us-ascii?Q?CWO4o0F56JEyffBwB4mh976hwnXYzyXem7yUvU3u/rA8ry13QjBIjH4wlSog?=
 =?us-ascii?Q?cMnQNmWn63QsCTsE1BxAzcf3KAbiYGGu8gTeleNBp60ZuQ3W1x/E3F8Mc+UB?=
 =?us-ascii?Q?gKZ83VADRUUsIL0+aa25VVMWJOM6tVLH0LcByvONxwXrKLH6Hnfxsvv8Mn9Y?=
 =?us-ascii?Q?t8oqNdYoPVURZQgQ0o9CBFSBLpc91/W5Bnp78/WsUGYFhij+V/GqEbqpmDxB?=
 =?us-ascii?Q?R0J4KUwGiYdD29K4k99mcK0wZfIKPfY1xy/BZkLC6vyGxobPVoxHoCILCjm8?=
 =?us-ascii?Q?ss03V6f8fR3PrASTIAPnUmEpcxAigRY9qfC+S8mIDq3b06+TR8pkVwi2X4vu?=
 =?us-ascii?Q?Ofz7M9M0mXUikCpCZPCYHAu9xpn2ZSYgckAiq5I06TwMOw4jgqDDrUfW0kBd?=
 =?us-ascii?Q?HXLc0VyYGFeKvQC32TNabUSWU4ZGNL0Guqq0sepSw42DhmAv/YeKVnXQgnvb?=
 =?us-ascii?Q?Sc6DTbnGieCjkWrx4zAuhkmWJFAnmKdcrzq6N6tdvmiXAebwY2nMH/jN0Iyl?=
 =?us-ascii?Q?RJQIo7loMUVpwnjrQSGSI0uWCqDoE6iANkLAgw1aaOQRtPtVt7Dda3lHuKA8?=
 =?us-ascii?Q?24GeznFA2k+R9ykqd1mSqSitjliQ7G4VRsIPWLFjQEA7IedW+B60O1ECnQYj?=
 =?us-ascii?Q?bnkorgoa5WLc/1FJzBVvz5lh6oyD/Zj3F7VnR34B1d4cFcP3G3Hm1+IJd2No?=
 =?us-ascii?Q?z2pBauzNrOqjxwdEZ7QSDbWj5Orqcx41929iipIsLHSzVVBJcK/eiqovvZEn?=
 =?us-ascii?Q?DBvWhzD88cZdsySGHrtkk65pZThjPa+D8MeJmnTKnINUQCERe9lytuekaXTA?=
 =?us-ascii?Q?qQUyfXXVYJl4revEs2GcfEegdL+eIwH0yQreQEP95No3+MuzN6h1eS1UmXet?=
 =?us-ascii?Q?FgaKStOjoYVLtI59hreLpLSKB/gx2wNIng3xG/XC+EalP+SuauwelxRQGkgH?=
 =?us-ascii?Q?inqxObhY4Ijn19m5TH3azPfn1+L6kW0i+YNrK5mKh2gtNHsdkLEHSPWqZ2Iv?=
 =?us-ascii?Q?zdWy5W80tOs5wx/zMZLKIegXA+HUej4cwThUHk856C8FS8p6cu/A/ZQFrtNM?=
 =?us-ascii?Q?48KH7VF8lQwB+PSb3UYr1Fu05/WeknEEum+ROf/U+ZsF17T70D0CxW90y7F5?=
 =?us-ascii?Q?XAmI7yhl/jqIAYhSbhcv1PzUmcrsTSxabyoPeUzh0+An8VpPskYUMdDHXSls?=
 =?us-ascii?Q?vDJrvsXs7q5CK+rB964LtdCRdnPz74Th/jvZ7xssmX9cX4qCBciu+Xn6KLZg?=
 =?us-ascii?Q?GubGqvSlmlr6oL86umGPvVaaIWU5OX9mW5ok+iLQU5mYZG/WLQB54PIOwSRq?=
 =?us-ascii?Q?tuu5O4FenfcMPqeAQP9zwPtGRIz/E3Mp2bQjW3h78VhCXO2AfY+ZMYYBSCai?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797c4484-f2c0-4586-7f0a-08da8bd105c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 04:18:29.0141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NQPdYUqjBeaO5ibbEbRXPV1+gckch/X2CVRjSv6PUOomMxJ2dbRor+e5sajcVJYSYnxd15gidevEz0HyHI57erXouEretx4sxhzufBGjbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=822 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010020
X-Proofpoint-GUID: 4O1vJKCM-akOwuHUFDkqnqokGHvgu3Hs
X-Proofpoint-ORIG-GUID: 4O1vJKCM-akOwuHUFDkqnqokGHvgu3Hs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Fix below compilation warning reported with W=1,

Amended original commit. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
