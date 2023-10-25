Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B97FC25B48
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 02:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjJYCfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 22:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjJYCfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 22:35:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69975A6;
        Tue, 24 Oct 2023 19:35:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OLUQRv019739;
        Wed, 25 Oct 2023 02:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=IKeb7EwBjAwj//BDtNWV8ccCA1Te5QdWtTRo/b+oMZA=;
 b=oXFweA52T/uukewVNWaZym2pch+HMmAI+8ZAVioR2z8d40ojXU28JcAVMKNIKG0uZxFY
 dT/k4UXuQCPrPdoBwGtqNgKvJgxPU3eBUqvi/buUh9dx5ktof78wZPyy4xqm+3pcZLYc
 +cDR9XAoMXGoGIZeVifOwUKP3wdlMiqxmsdl2lq5kRSWIx2ImTLRvWXu6WAbO72fHZ7l
 WYUThAsjrCQrbYosk0L/Yh6WbwVyjOWOEtZkLjgg2lzr/Y9K5J96+CWikHePzVrMXzX8
 Dqj8IJk9N/S6QHdpaH9x30/I5vPueVSF+n6hk+AuhCDitbwb6FkHEA/4T/Wh/WgoaaXT jQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68teq9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:35:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39ONhQXg015094;
        Wed, 25 Oct 2023 02:35:38 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv5362dcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A96Rg9o3j+QZYPerhlkFSZPnAsV7Ob75FsMETdzqz+2PSEwU9Mm3SqUu54EaYLpscnFs4xCGCZKayuvv8uR17Nh5VqHJYAqXaGv/pfekHrh7FbpK4eReqEok/vQIAgyHvkwqPhC2ggvq4/elGfFi0R1qxJDmvL/sriZiht9kfc6v13ogn0G7YiZXDg3DhbQA7wVmhTMJneg5lwynTqE5nJiBBJ4aV3/bgQpUDJrGHoTBAgRkm6fNDHSYgQg1rARgEeGTXkMRxrSfv/tX0Pzp5LJNa9ukVVD14ox7nSehBXd8VgdK9ti4fyiIHDq0kbcporXlGAPf1ASY/rG9Ng3vcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKeb7EwBjAwj//BDtNWV8ccCA1Te5QdWtTRo/b+oMZA=;
 b=h6vDF8C85grdavenxWwmV27ZUhqzDbmHtI+F00SoGGPxrnekTMF4Ab0gc5FK7VRVu7l/SXxxk57RzBypaa7+9votpPUh88/kVtbg6XVNNDcqFBAUZSVQHzW3WYo1fUzA7AeZz2qS7pXAehjclzs5Vbi1GT39SUTicftU2BCM2IMudPWDRfd2Q/7s8ad8XaSvJDYRkB2AJrskioHrJwrzssoeLcf/xeKLc3axdI1qQ5jhTj+rhgIa2PZV85ABmtTFE0tzSyB9x2ZKffmXT3rdGqc2CJ9+Svns2dHY2vdEJs3nFg4eTE933hwvyuqJ59NkF8GNeL/cwSh6BPoE/d71jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKeb7EwBjAwj//BDtNWV8ccCA1Te5QdWtTRo/b+oMZA=;
 b=gsR8Lz3uG3GblgM1piumaoyxuuo/aOu/a3c7GjUN/ruM005M8bYQGB/JHcYCSyrPFSXykeXLWrKJR1DDJQZW4ssVq4grFyUOfTDWjGorleq7nuAMEqC1DxJqkn+F5znqH8PffF3KKRInJF2ylAQJJamVn7YPpEE7uirPDohaiKY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7268.namprd10.prod.outlook.com (2603:10b6:930:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 02:35:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20%3]) with mapi id 15.20.6907.025; Wed, 25 Oct 2023
 02:35:34 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mpt3sas: Improvised loop logic
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lebre8ep.fsf@ca-mkp.ca.oracle.com>
References: <20231020105849.6350-1-ranjan.kumar@broadcom.com>
Date:   Tue, 24 Oct 2023 22:35:32 -0400
In-Reply-To: <20231020105849.6350-1-ranjan.kumar@broadcom.com> (Ranjan Kumar's
        message of "Fri, 20 Oct 2023 16:28:49 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0410.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7268:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff1a806-fba6-4246-6995-08dbd50310e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MnBE6jYDF9F2V7BiZjNi7mrNZxIzRY8HEdvB3HviUd/ESJ5TZQwFzzkEf2oVlHGhlGWT0VG9clX4aRkhWfCxja8LKbm60jOGjU+v8yDAc6AODWiwgS0pF2LMLkz9JNInbz5vzZSJEgEQwvREwLC19y00n4dqFpoL0dedzoaRcsQCPEkIZpohbvi6kGlCF4+Up3dqY7mxmlgqoM0YDOMSqKVykBdubQKTKkf82OMSPpyB3ti9uHoldxBC8++J5vOLMMBLAwqQ+MU5MWLOfkKnYfJOVaJHIRpH/ad4moHKYUz/L4w+WNch0n3qxDRVA6OydA2uFrgGRJfT5El8/QsI7UctqdwLITBXfZCtbblQLIgdV+kLsKQixpEe20b8mRNpyO/lObzdkzPaQnCDxCIO94u/JVZkEm7vpUNpswwVHlT+V4IdwjPaQz/C3fFwRD88O76a9pqTdDvVeMQf/HHnCnNAkKKgbtLuJbu+UoIiFWn3fqJDUkJSR4njUdAnTyyyMZL63lIPhHh4miGHddV4VOvMHotDFi+e31gxmhH5gtClKepPz6RroJdh+qZ3u2/rpuDdeUKZnpIbLBjAwIdp4/AWkqaQMfE9YbWz9TNwdY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(376002)(366004)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(5660300002)(8936002)(66556008)(41300700001)(86362001)(66946007)(66476007)(478600001)(316002)(6916009)(6506007)(6512007)(6486002)(36916002)(8676002)(4326008)(2906002)(26005)(38100700002)(558084003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fxHDoGicO38QFSZyKW/LO27EGbvyhsfxvEZNF0RJIi+B83F6ppI0+FOfDlOS?=
 =?us-ascii?Q?qSc+7u+Oz3e39to/VYBAGlnP2uR4yBUmGmT8p1z35i4GJMyQ2zF6e85PqG4+?=
 =?us-ascii?Q?y/5IVd26MG525dzlw64WTHu2f722R920ObwECpEVOBQKz6xhWuJ6D8IKChG7?=
 =?us-ascii?Q?brFj2ugz1gfVX4qtsYv0PGocmUWe0nYH8qf93CWPAdX7yJx2QAIJ/P11cxex?=
 =?us-ascii?Q?dPEQWbk3HHlMVe+tD2hP/UJ+lCajgNVio/VliqpPqFNOgIw/XCZwF2Is3njo?=
 =?us-ascii?Q?FW4Woy4CIEDaf2wn7IwcV1badCBU0pc/Ju/YRdnhKwZqNBPykOmkE74Up/nP?=
 =?us-ascii?Q?WVkzjAHq7w7Xmcq4nlOE8eDxE9tDiKpX2FypBQW++x6EB/5jtjUycfRUkHAE?=
 =?us-ascii?Q?rVIBHmoU8EA7ZMQM49QrvV3nN5XeSCLdFtuIjknMOPcK6KjeUbFLx/5alnY3?=
 =?us-ascii?Q?EdiaritFc3Ju2WcF7Jxc9Dv4aWUbN/IqNeRKhoIIKoWPiKrWdMKAGu79TZJ1?=
 =?us-ascii?Q?mFpwS9gS2UkfbDhhZPVNKUq1r83tVR8iJIePmo58SXJ6tbw3XOezNFrxXyqh?=
 =?us-ascii?Q?6xa8srZP4Swaa24av+f4SyC52ehXt6WCTyheGPhUiQohDwaRnnAzJIBgCIxI?=
 =?us-ascii?Q?Q76AlnNsYSsirFWY2vdHh6MBzlQbiw2KEWkImFwPSvqNpu9JmtUXrZAGi3ua?=
 =?us-ascii?Q?V1S2JSyo50UCqBDWdwkn4MI/y9UpcmSNeH8YKlGLn5C8RSKE/t2mN2hlyLhl?=
 =?us-ascii?Q?w2AQFoHCQYhasccsQzOqRZYpgA7UioAiaeWWtVhVGqztJywAB9fP/qbn0v1T?=
 =?us-ascii?Q?JGLds3c+m5qR/pmESiGXxFmHHFt6x2pGadrkYhpNLgKIQE4NAnVtI8mxKDob?=
 =?us-ascii?Q?U0/mcrfcM5NjvBoc1/hTKlTRebY8EME5dBBiw9crIy4BSlgnshYkPmrqOmz8?=
 =?us-ascii?Q?oSB4nBBOhG0TksU/WhjKeTFvstmgPFmJg/G/zn6OrZMj5j8ZViULmskKsqzF?=
 =?us-ascii?Q?O0MJYZJb4V5iFYaxwTPxUdvLZXWHwXQ5/3eSI+3bCu6qg5TYkpo/bBTstHGx?=
 =?us-ascii?Q?hB7F8YYE6dGAdFqPOD6rNib0SXzhg/BHVNLpGHLEZKox5NhsdA4AZYJeS/Na?=
 =?us-ascii?Q?mNS5BP8ztfAZ+NL4kH65s/RX7izpHCGgGPGFyEKR6CLD3FKRfqgaFFl/icIs?=
 =?us-ascii?Q?wg50+r9YJCpCzA45f4wxu9LiFI8a3tgC1qVhz84tougutAkMhkpVeAmnI/BY?=
 =?us-ascii?Q?w9Yny4pfpllboaJ3aTxoR0510TZW3cTuZKrFAQX+52vTG1Gk/1cJbbF53+oD?=
 =?us-ascii?Q?/UaajjAJ9HTxVcRIx3G0njm2q14HrJzKCawe97o8QxhuSGxey41jGvqoYSIl?=
 =?us-ascii?Q?x5PWBIobfseb2XyI3gfIwSSVAyCNVArJe2rKOu11oSlJfNhzsdAyQgH7vyZC?=
 =?us-ascii?Q?+ZkLIHa2nKWRJ4ifJ+SUGs8o9SyD2UQ/EWzK0PcT06+PGEVymAmgZu+irlaW?=
 =?us-ascii?Q?EWoqbrh8IwlvcWQc3DlAb+7mwlDs0kWKyEA1Yln5N9dkGDjxUlault34Ecx2?=
 =?us-ascii?Q?kv6xQIGRPosLSI08VI3CPPCEkqtpeFStf+WkEdBBzohNims+aMrT10qJe/o9?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gnZEqvdBQGHVwfWXv/QMqtDQsT/dPMzsoTqXq7PGs708GJ2rjAKsHfTYed2hHBp2t+qrsqJg05X7P/Jwv891k8euRUumgDVcsHkmpmhbTKz7B6VfrQlcoiwRSiaIokPxsTLTCxlja0sgE8CV9WoxjVKmqP0556cUg36zA/wPs0NxUVznnr8K+W/rukoc9NOsbE4KecnAFWkn82RjHHbB7t2hYdVwPo7vCUIbbiRE555aPY/LDyWGUg1ydh//J4ZXJSuE7DXUc5tXJHTwLsi+8dln8IwO5Rb+JJaXFj2znyU5ZSNhHdhhcc9axJyumyhZ7wHxbOqkSfzoK1KfFGA7m/1epLf8VzBtM9te2w4I9QFFf3y57if4sA3pIEXZOafC+i1Vy9W1vrXE9b6JUBnEqCkOEZbBWcH+TJQ4X1wtNkD6joJCnC+E8JSEMqeqZsUkZ+pTNZPbvuyWVSER8ruFIzlZhQemnquFe+QW/W0AWm5qQissi9af4V9iNN5c7yBR7qb+BCwLoq1fi0V5YodQQUSTed4XxThnAM6m+gqZy2WGIKx4U+Onxwj2j+60GCtM+N20vBb91YLhzX3pnsKVIl13IJO8tZ4YlQ9B3djjaL//iOo2+qx9zQf84rhmtW1u80sEV16JHKuVvM73JaeuN/1DKUG6SWtACSDKBK2ijJwyMLjjpkEuKV5UoKiL1Pa7tsidFuEmLkpEw5lEo++A3DeAZYi8BXRTOcB0n/Qen2H5GwIQEeH3O2UadhF5kSKJjumKvBv8saSsjda+qfTE3n9S68HEyLiJKAcR+5EOCp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff1a806-fba6-4246-6995-08dbd50310e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 02:35:34.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vqLorxOmW8F51gLxm4TYGdFFAF+V0tLMOs9GpzRYp1d3j12rdGIJxE40kKwZaHB/JhLMSJr/FGQVj/jlHYHglRuPWAAtp1c7OcRLBYXkcu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7268
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=598
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310250020
X-Proofpoint-ORIG-GUID: cU-K01OwZo14W5V-dewggyvX-W4iiUiR
X-Proofpoint-GUID: cU-K01OwZo14W5V-dewggyvX-W4iiUiR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> The loop continues to iterate until the count reaches 30, even after
> receiving the correct value.That is fixed by breaking when non-zero
> value is read.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
