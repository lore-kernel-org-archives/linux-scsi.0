Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CA4C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 701A960F36
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhHPR0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:26:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65132 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229872AbhHPR0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:26:23 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GHHcng015618;
        Mon, 16 Aug 2021 17:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xarUHRSAtQXZwqHJ5/qvid2BZIcHTJVnj8x8FRr/W7c=;
 b=QIGwz8FWoFkYU4S4rmkL1GMGOrdBri8tSqeynWzwTpv7WR8T41Su1eXxeodj2vdX3Rhn
 J5Cjh2hAIwm7GRXRPtfrWMCsKZRVW6J7RlGygEj0PkDA2ICAy4OL1HYG0Ur1/LduOJMr
 vtvd34UeIYJCyDhmKL9jTMFKxjqnx7+bjpK0WZ2RyzIBCQx+7vqg8p7s/xe4U5pPZv4e
 uwMVl1NAbjrR4UrxBjoMRFpFNxiynWGsu5JUG2Yy+QGH+aRFGzp77FUyUkS3TxdLMxfG
 VZQa/u/+GBLvB2FXld28dpQaFndZAMeYMZgJHdJdwkor06aUQZr63Jq3DoMBOUUBtW41 5A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xarUHRSAtQXZwqHJ5/qvid2BZIcHTJVnj8x8FRr/W7c=;
 b=w+dxdIhpwe3+wS583IsiEpsDx9ybPMuqXm1z1EaSitkThWKANPlCt7qJ9eofsr8QNQiw
 sDfycuLH4gC8DRmhxk0OqppSAC2W1bzxhc+rWQlsOXMWFhRvfjvbWonIR1eTt6UqeZgJ
 QgfJPN/jWPmHPpGH2zqzqBz7DDQGRjU1mv4v4Bg2SvsrA8tnXLrxq5HwtzDRY57QUAyk
 Kumfi1uOdxmgLV03j0nZTDl1OZPR9T5vz+elYvQAdszpvry31bwjHvLi/cRhiwNQ8Iuc
 tVMljB6UBOZwkrrJegGq/N475u5Tyxwv5iT1aS5UaYJB5B1JUcZ7u10eRu4wS6tqeRd0 Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpghqvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:25:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHEpMN096466;
        Mon, 16 Aug 2021 17:25:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3ae3ve5c8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:25:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5pnuzx92gGkTwRDKzwFaYGPfJZTIwRD0rsUFgkoJyU05rWUdrCPCSCtXEu6fyXeVlPuBKp9a8w2EbXOlTrohhqbS/88pmQdmJ0JHIGp86Mkl6lEk3RDN2zKkwvAMSyqLqu1WcSzBaCEPnqr8CXuPanq23SswFbz53lbENTAvDIwdzE7N/LteFWhI4mPS4hsulZB6x9wYytB/7g1D2sxRIfQ0ZTD23oSFMg7yZsozvy4OGheGvATjhZFHuseTTCIvBb6tGrXc0bfhIhMzu9OG3HwBTm5BpISdmP8PbHjjBag+3Mq5Kse51jHEsnlazBVxmRashy+U/xh3opsbPRMPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xarUHRSAtQXZwqHJ5/qvid2BZIcHTJVnj8x8FRr/W7c=;
 b=KlJuhWJbJSxCRmYyG7qO2eV87838Uytl9DBk9S1BQfW60FzX7y1gAnEn0ow+bSbo7esbmkwhY8IFsKRO1VFbGHhSaRkBmBhJd0V+OJxtyWP+J6M5R79/dlNzHgFvZ9s/531yvTCiTAkzCDFV1C1MjlqeQv3jTrWyCKTB3rr8aPdmyLVdjsGGKc9vkb/ZLGS6Qg0B44ooN69VZZWXQw+x5Uv47JsaZZNMlO8W3p+iImsniTaUjkxsVgaRW0LlMjp5K4J51WgsuRyfEiQtks2BkEt6NMMAgSfq5G21dtLbSQVV/gWjEyJZHdbJ7VDKp9AsEQh4z3guxyoo6aYahSGLHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xarUHRSAtQXZwqHJ5/qvid2BZIcHTJVnj8x8FRr/W7c=;
 b=U6XM+JAzNAluDUiDsqzIRclTA/oC2/xUo9cWkXdjcfF0rVcGcmeJgr3H7saWp9XMdPzlNMPNuuAtySDlsfOAX7RCrNGwTJxMsiIbbhyuHzHc6G1W5R2RvnohA8teOd63b025GOfQGRFgMpOfrgybtFPXHoW7DceRbOOzcyDa9HU=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 16 Aug
 2021 17:25:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:25:47 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ondrej Zary <linux@zary.sk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pcmcia: fdomain: Fix an error code in probe()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsv9pal3.fsf@ca-mkp.ca.oracle.com>
References: <20210810084700.GC23810@kili>
Date:   Mon, 16 Aug 2021 13:25:43 -0400
In-Reply-To: <20210810084700.GC23810@kili> (Dan Carpenter's message of "Tue,
        10 Aug 2021 11:47:00 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0015.namprd12.prod.outlook.com
 (2603:10b6:806:6f::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR12CA0015.namprd12.prod.outlook.com (2603:10b6:806:6f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 17:25:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbc2e2ca-a8b5-4928-1164-08d960dae28b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB541740E7D29035AD2D3FE59A8EFD9@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fT5HuHW+R3ujef2TJYL1jiBgXRJZIVM1mnvSL1oauv6O3StdcUQGDmRL+0GNhNpfaR0AU+TMASAEh0FzRvYfiJX2eYVMJGOI8bMdk8w21Vcx8y35PZ6O1oswYK89/c8gyDLDQZwUFTcLSqn9yiKgZ2qNiqmfMkUt4O+tjalCPvL4WWEQ0nbP+gTO2sNM1wQVTGF5N0rbcb5JRA8KfYTuCr+ohY+NNQHM3sjRrhy2bwt//EoS6bD49caqt/aKaKvSjo+tbMq3JMnvVEz6ZbPRu6pQyKjsyZORmK/EaiezdqMGQ5hdQcBtK4r/MaLlJnGIZsoWUeYwxfGvZd6gLw3wE2pCVUYGyVxecANySIrlR0JvVZ566JbMIa6qN58zfos4hFdtMA40q5vprSibwansyYuxyZRSObMFwiPwC/Alw4oxu7bo/OPVdda30i8pGpX+TBUzAlFHP04nWQ3ShIMWrI8GCCXZRf1s+CyjXGF0mVFksN0kIOhjTWu3rj8jpk/ZRvgYCE+khCdrFQvqc93pvvViNW6bWn3rwEVa7vEO2udHrTigkX9gXEYmc6fDRMw8n89DdTzvixCsbJ74p+fCfF3qkoyWM7VTh1Eg8gF2Llxr+E+4LP1FIqENLh0H2ze1JVIXCNjE2S3sK9PaGHEg/SyClHfB6HGN0otLbi5XIcHKhCjg/JMTDCNqh20yHC6cSM38HT82u2ToHD2bDiGtSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(26005)(6666004)(5660300002)(2906002)(83380400001)(4326008)(316002)(66556008)(956004)(66946007)(508600001)(38350700002)(38100700002)(6636002)(55016002)(558084003)(6862004)(8936002)(54906003)(7696005)(8676002)(186003)(66476007)(52116002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tCd/oYiRs3MNtDZbp37z1c1hhuga7UTqLdqzyHICYUwD8DwHplUFxZZZ7EoE?=
 =?us-ascii?Q?aBVs0jv7T2wIePJMX0jtRSK5jSKqZiigWQGBAD3eHdRdscmvEfoi3wbKTSXo?=
 =?us-ascii?Q?Gm4eNvO4T9+uqH60FtP+jgmXw6KV/bm3MCiwlPKysdoJ+jDNJNfysExI2C+Z?=
 =?us-ascii?Q?uS5GMWZFyHTi6J+6Zwq7own5kT5VjVUSR0GNxrd9Xa0yq1JbCX0iPBlPltyI?=
 =?us-ascii?Q?1taCrwCF+MF0tmOP8+xhafyiW9EZeQhMZ3D21ULVytMFho5Tl4NFo1FYS2Vx?=
 =?us-ascii?Q?F8q7nXBMoi95rzkSEwq7tEtGpfP+plcvpf60zxKqutd6jFOBh34a5TiSrhLk?=
 =?us-ascii?Q?4M5RQD4mkGLUMNKXnNZPLJg/mMefswLxiAIJvP0O2iol1hO50H5ok4rx6kkA?=
 =?us-ascii?Q?5G0MU9bHgp0Mim3V6czxthxJKiD+AYiRcB5BFoXaMTKmcfUvzo99vbRfOw1L?=
 =?us-ascii?Q?/e5gsJ43W7d2wwdCLIXUNhJ6f6WAZbst/Ozrug0rX4s50Iarxs5WQLqEefKX?=
 =?us-ascii?Q?dirqOSjkuc+wXAMQSOS0Gw0761bTBPChN7U99gETOkzm6RyqEyvwnOIhlrgc?=
 =?us-ascii?Q?bJBU5koXm5oour2K1z6L4dL/W8VK2fH6szIVry4RaBFTpouLaFbQqj+ziSGk?=
 =?us-ascii?Q?t+y/0GTOLL4xyvk+RevX9ew/HSmBt1Ib14xJCjnyIHBvqqV4BmTuWK3g6uYl?=
 =?us-ascii?Q?uJxCGsGHTzi3Oc3Ob8cttARzfPPEpqoqb/WFvIi5pABG/B/4Jb3uW3gYtRXO?=
 =?us-ascii?Q?+2vyrjUPnFHKnQthciJwY8o1kIIvW0b+k6/YXG3U2/OxTFREqRXmqp011eCk?=
 =?us-ascii?Q?LNIEVTsghAD5IuffGc6hrviYS3x+RbnjIgNEF5yCfGAZ+u5dSunPEgElzoHK?=
 =?us-ascii?Q?ZYrdbXKZ4Libw4uxcerdWjKat9PVtT2J2n9BdMCYyrMVJilB6Zh/pj4gWJJg?=
 =?us-ascii?Q?ynHlQSTqa+J0zXDSVPu9hiE3uqp7Y70VkhAyWz/yWbeQOCj2GLY1c4HQpFmo?=
 =?us-ascii?Q?wWSWOuS0Sx1LMVdkXYsH/FSd8R9vvDm2p3sXAixyr9TpgnL0j6tr77XZbcpq?=
 =?us-ascii?Q?Cu/AuqPCzgiuHlbD6i2Ekc8W293udnYXK6mTyR7jOYvigCqxIWLAx3NRchBW?=
 =?us-ascii?Q?yb2cCi7XKsp6kmIAK2Un3qWmtCcDXX/67L5/YRzNFmS24emAYdwHB2GNdZ65?=
 =?us-ascii?Q?b9Pv17EUuvWybXHOgCvrJQbsLryBM9nZ96DB/2c6KHju97Sqp366t7rrVtPs?=
 =?us-ascii?Q?EbiUP1RhRTxpgJ/13XaBI0G+kIByxdrjSTp+TultHBktgdIsNA7rJwZHwsI8?=
 =?us-ascii?Q?DnOCZkbmJsF2YfDOMkqK/+s9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc2e2ca-a8b5-4928-1164-08d960dae28b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:25:47.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt+xMLgLcNiiJg1tmSeu29kefAXyGbaoE/l4n01AkbISI/c7Qf+46KcqUIEzgb5ghr+dwEu+yaSGtwfz681lP6wcbigb98sO0+Y6lself1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160110
X-Proofpoint-GUID: 51tAKJkIQdyYCWE4XfT9ETsl_IF0vRq3
X-Proofpoint-ORIG-GUID: 51tAKJkIQdyYCWE4XfT9ETsl_IF0vRq3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Dan!

> If request_region() fails, the driver should return -EBUSY but this
> code accidentally returns success.

Identical fix was merged as 632c4ae6da1d.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
