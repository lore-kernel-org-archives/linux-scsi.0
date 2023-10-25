Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3C6C07545
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 02:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjJYChF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 22:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjJYChE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 22:37:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7216D10C6
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 19:37:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OLUNJa004142;
        Wed, 25 Oct 2023 02:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=lYiL9uVCcLfyzFxK0sfg7AXvRjZG3iZjlePrpc66uIQ=;
 b=eVrMSMNNFSX7tDCre3SCP1XsyOxDGm1ZNLsX4JsW1ypEGP2JplAxalLvtk+LOVL2eAG7
 xQ7SdPleYfciTHCnsRZP3mEOq3RYVP8TUFr43dcwMbFxfe06jgGKDnEW8VuleHGbs5xq
 iaGZ3AcTnNYap6HU6D7zJOnVB/6poXkZkTc7f0SIj05DeMsJtJCM27lorV0fqPV2qwi7
 m/3Qk+RZwjGelcdCrcJ+tc15Q1CP3NtUCnopsp46epaB+m9Ep69rEeY6IcWkXOW3jl6q
 cvYsTQQYBVZ3eo06H/Vp4hCQ/3zwF639uDnyUjFilIMETRlodeEmOR4kO4KTu3SqeC96 Qg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581prr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:36:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39P0paZQ019000;
        Wed, 25 Oct 2023 02:36:52 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv536a6xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:36:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iumHD5haVVmSoWlKf3UvOfqzn/uI2YZ+Oi6rUwZZk06Q8GsuFAlkMuk1/gm+VvkZkngWJYWkvMjcusG5QALkTIKDIvrJsQigZKcGATVkYLczKcRhtEYIIwomnECrco+gGW0El9MUXAc9pmBEhWFSCqQ1iH3e6gUYVhu6kFpXd17LHf/TIay8vPMal5UTW/Wr+QonaFNMMpXmU0ojTWuUZE5QVfiOHj16Z6U5aPoV5hOIYcyEaIPagP7j5gk5rR7mVdPR9L8uSFImV68KepATYkuyveDlLwkTiTvEaRZMcOx7AqTcCDdYkR3BEilb27eKR3+p3JP/n+BuwPRIahj/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYiL9uVCcLfyzFxK0sfg7AXvRjZG3iZjlePrpc66uIQ=;
 b=L8W5JnZPZqNv66Xh7JUHehW+KUIvbFA2qXVPO0rbnV/lFs1mXlRvXkBj+V0caH/N47hlMmpXPJziwomlA23QAyQAWblwNoS436gQDjJUOkYvAwGKQQHo2VS0cQTUPLQJmlCjl5fum1IAsnmSFnXKjd6SU1bRjHm3sq7IWEIau0dkTBljTbMfuKympo1R0ixMytzQB5xvaJM/6ZR16jhQ9q9hcWxNvr1ylNBuPgQ0WJ4bxgaT+Ca7bs0dyyw1Q7uEEDCPtKSGvijQme8IPVEFtfE9bJVHUB/g5LX18RmGATpoGSlBKSk91PicMqPzWqNQfUESkMaYBqMco9uXvwREYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYiL9uVCcLfyzFxK0sfg7AXvRjZG3iZjlePrpc66uIQ=;
 b=xHhN6Kjsc9GhY8TW6DVNDwXfw14coXwtte8br74+imtSkeewh73Asq8q+df1XPdDinRjNowrbZHXxaq3xO/4KRB0M49eGHAvdlIihaBMOzq9KtxSIL9Q4wIqrvDHxI3Bt4JAmFHkXfjkmumKmmbq8Ml9/N3Dg5ZEGLDkZxF4ypo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7268.namprd10.prod.outlook.com (2603:10b6:930:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 02:36:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20%3]) with mapi id 15.20.6907.025; Wed, 25 Oct 2023
 02:36:51 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] mptfc: initialize return value in mptfc_bus_reset()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fs1ze8cl.fsf@ca-mkp.ca.oracle.com>
References: <20231023073005.20766-1-hare@suse.de>
Date:   Tue, 24 Oct 2023 22:36:49 -0400
In-Reply-To: <20231023073005.20766-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 23 Oct 2023 09:30:05 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0055.namprd11.prod.outlook.com
 (2603:10b6:a03:80::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7268:EE_
X-MS-Office365-Filtering-Correlation-Id: bd93158a-6a16-4b41-9eab-08dbd5033e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5T1gFoIo3wi3SISmEhW4GciLBDLZjIly1K/0acR8Zu/QZs0iS0M/KBv7sU2FsfkDop76FlRlBgu66ovM7pgdPXwDTgoitrO1tZCV5U/tmmk4PswguhqjS6WRRSik16ZEVJb3JjnDer3obVYzH8GAqP/tCPtUoVOU16ncZuNCBxrp0yUpkmPtUrHP2dIdFugHwYjsGebpFMSl/a/fECXPjEi+VsUd+4G6xtmJUHDiWCDYbtBQoVJZqhuDvcbDUBOFYIwly685RK/NqBQ57XPV5Jrt3Alxma0Ds08syrrfDAX54+u9R3s0uKuosCviwSYRAJSK22OOjPxIXKKa9nSS/gORwYQHjmz0lPYnJ3xblC0NfVyB4LdGcuoZ00HuimdppMjy2ZLGLQHcNa0uDBb9KUA5wpZgwNG4rtNe+7P3mMrGZ6hN3/nHb2o0cziap/1YQb217yVAFGmki3HmhyXbe2MUimOI0wUIPvfl6dj55/8eAvqkkxTTZDCAy3qKeQFGoqLTr7PJahvPzMeLFIl2IfnpPEmp3ylvDURct2ZMes2QzVW+hZPqprGwJAwXGU6E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(376002)(366004)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(5660300002)(8936002)(66556008)(41300700001)(86362001)(66946007)(66476007)(478600001)(316002)(6916009)(6506007)(54906003)(6512007)(6486002)(36916002)(8676002)(4326008)(2906002)(26005)(83380400001)(38100700002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKWhD5kMtAXh5CuF7nCr7CsycPUZOrcFp0XctnzwhvljXKlJopRtXJs6XLlI?=
 =?us-ascii?Q?xApOxYovpSLX83MBgZV/xuzCyJQuaYKRhy+sNmtXCRLfHXP3RGO8K9xK0bBk?=
 =?us-ascii?Q?/fd2zKdhyhe21I+6rplE6V+F9SCQ9C2CFmK2izpyYj98a1eisMoqBMEJoBcF?=
 =?us-ascii?Q?YWvjASkoBeaqazURYRaDLUtSaP3/ShARndJ7bDlzP6xeA6zWXsUoHjXJRCXM?=
 =?us-ascii?Q?ORZZFvtA8/jYzFXY+pK37QPeFS8ZLjnGCh3w0Ji7hLzTONfPSBwP6K7PDGqZ?=
 =?us-ascii?Q?6TPz1vfDNOvlElsdTOcmRNBidwXPD2bXeOAtlHbAEbTAL6CudVrFLY3grg5Y?=
 =?us-ascii?Q?OKRwwZeTA8VtjRbF6QJwcZTOYkubbwiVFN/5ZIo2y3Q5JE5jYeqL813FHwJs?=
 =?us-ascii?Q?BZ0DbMK2uh8hjvxOn7C6+RNbn68BNkil6L3lGEB8S7vJgfAQzEo0WVBKTDl6?=
 =?us-ascii?Q?ZpFWkMJtWWoo9w8F2QlNX24UvPLiA1WDJ6ix86Oi7pHVDZoOz7zxg3GJgh8w?=
 =?us-ascii?Q?7aDiol4B9GdAEQEMqYTe275EOJn3ZzzXsLjMWyIFbOrLRk8Wfiq91wYs8Bs+?=
 =?us-ascii?Q?woOxUi+lUmeBQyF+Jpl387Sgo/RwHWnKOV5buO5aKbSbT3KaIaCbfBBAQbsI?=
 =?us-ascii?Q?BfLJdWelDdz0LS+kaZWfa8zf/55frYcpKA1ZizEF82Y7CEILeiSUBzQIpGSZ?=
 =?us-ascii?Q?KS6Ke7fuK951bUrea46yOUWIpfy6r5ytp2loqhN1mBVr+qgdhJJ8e7GIiuht?=
 =?us-ascii?Q?J2j+x+E9Edp1NfGOPbuVgHtAYwNEp+1ao3VnmYghSqiau/1m52E3P6mkxP4v?=
 =?us-ascii?Q?0jxtqp+MSWZ8rilooltKSNceDshRtOfXCUSqwnTX1tEDNVFAlJ9RqId9gDMf?=
 =?us-ascii?Q?u04iKey+9vG7e5l6bT8FGaEPc9lGxc7Y75hX2IY2pbIM4Xht5MPaR7xgOK5z?=
 =?us-ascii?Q?dZXKsm8vqEH6Lap6YZ6pxtRnpzO6phw6AGmguH9Z44PPm6rF+xVPVN07wWMc?=
 =?us-ascii?Q?d9pWKFsN3hCTgyEPK71rgQMBLgi1YwLmUUabbYBqeYaWxJjbgm3WxRR7KXkB?=
 =?us-ascii?Q?lE4lb2XPTC7GdaftYJIavJeRkpWb7idFaOHbJZgKcsolh6HyPLyixGfO5L5b?=
 =?us-ascii?Q?fGIyVswi+bEr87EgFFA5vZ2mFiLU3wmlG4mvnxiu8bglf52FHjxeuQSpmrcd?=
 =?us-ascii?Q?pXie2Wx1DdQn+ZqTGL6QoFDuePQzTfKaytHPhVbfyx9cHr1Q+iMSpw+oMoJx?=
 =?us-ascii?Q?uBGFMROEqleGXRfvCv6Y/hhfPZWgx1Bv0qGYj15ZQEDyQTCd2Y+5VlihDVO/?=
 =?us-ascii?Q?lRtkELbK9CHGjocqO32wsmkJXVW9o690QTbIRYR1r0KLogD3O8CEz4lD/vTQ?=
 =?us-ascii?Q?d7EtZVCmqVyH/073TvYNAZPB+GeB8qXJTxgdFRtNQJpMTUTPt1B0Z2+Kmo8p?=
 =?us-ascii?Q?8csNKnNujXVxmnZStR63La9zgWHbiq0W5zeBbvi2UmOqG6mL/CfBp+ziWyg9?=
 =?us-ascii?Q?VtIi8kWO0sfwCPVa5JKSa3UpNaQU5zZiLcj1SaWVO7M9Uh4XpArTiBv9aQSf?=
 =?us-ascii?Q?zheuKxCB9MXFF/sQ2smnVABzoLw4R3mIPgAlhN2SLCZKwVPJ59RWvVsCrG0o?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BpHHsvqaJbcvnR4Mw74aSfCBi2FItszvJYnGYhHZNINDkm7EYs8Y7qauGXrNY5IopMRR+qhqwpb1nsLBNHxcXZKCoSrGHpvQVgOODwyzEQYJobTPkUljYevLS/s7U7s59VukLsQl6bwxBd80CDw6WiXCWedNvq07s0/6jxczGhrJK7/Rzxq/psrIpsDb/59fX8+IVx9yey9t9dHCWEIagfGsQTtbwX4fQMVwGttTfXKU8fsoCLevwFI3sJVZN2FfG5iyG6GQoliKm5xLEiadewNG4lkJXJ7+mmx3vrYdP59dgSDv+ytu51++LPaoAAFrCFxeKeZaSxN8QidKLPsYXzYdtJ6ngxpj8xRT1LeRUhPr1FxkMrRFCkwuAhdJGpF6/MMHNWfKJSj6QFm92ArgXblURgk6zyukSek8W2ZJb0sg7qHZ0+fXf0inUKpvCDqCQOYc4SdUbKnIxoiFBbfZETVEBNoKawCBCtm2YGB5m/wwO2r/RfNjBXCHOQn3u4oGMgCeHHtEFXD6lNbG09Iedq3acpVarwyqjYIXK5U32H6mdktsbn38hfOMCFzc+8K59Ex7UDdfw8DIwLliCtvgJ55ATnVTht0Zob7FFb+b/a+W1RFcl/aZ2hE03FjT5wOtQL8VeTGDdL3IOgnC3dugZcrK77Y3kI3Il6z4jSaLtYAmRgUssRwB0iKre93ywfgckYPsik7eMVfWZJR2bZwk3+vNMZHIx3zCbEbWp9vHr0uUdlyPgt+z+GussrwlJUwzMT2Tf8zWH4V7vh8f0eFsbsn74y+HcCru9ZpM+yXuorThl/sZc5JqQLSoLlDYqnDpTOsKgM8MpnGGAWWaSyPa1/1ztCwXrNjGKvl7sSvcp/P9THDmCuENJ3NKhcZGhCQVVtExf52GcIOUGrz3qvJZCw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd93158a-6a16-4b41-9eab-08dbd5033e65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 02:36:51.3708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1fHMAvLbQjOEE8Q+dDEQgNflzLkdY3vjUo0oqNLWsnVy8h8Pab6FOE+fU+J8+Ge5JxHydw7CuQvSn4sM3j28QAPGG0X4C08pTHlCvGHV28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7268
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=798
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250020
X-Proofpoint-GUID: iUJq8QyqmCOgF9-BNPATdoeFKILWOBpo
X-Proofpoint-ORIG-GUID: iUJq8QyqmCOgF9-BNPATdoeFKILWOBpo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Detected by smatch.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
