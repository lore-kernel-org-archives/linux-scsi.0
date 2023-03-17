Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42174C74A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 03:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjCQD6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCQD6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 23:58:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D4F2194E
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 20:58:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32H3d8Fw014354;
        Fri, 17 Mar 2023 03:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ksUAxqrlMeeWT0F3qRpI3RJIE8UKTd5cgbyKhO8CKAw=;
 b=JYzwyrnc8bKgwSqEwAvaiVcTpztzNZ2uY88krT11yNCIyKUGMwa1rJGHiPXUX6CrrgUb
 P6ZF3xpb2f9KjIu5RMIIYgQ+sbbn/svxkX/16WX7GFNt1r1A6j+GrNiB/XWH2v0x+3UM
 sRscnbHrb9Ay5v+Pf+N3j0XHRvEzFWJzOWurJ4JTLQwvHpt2u/5DcrMB8gGso+zqEEAu
 AsN9yB0xylQZ8ppeFz/j88KdBk02kL7uKIzD2pxFRBeN/eeUBHwPhrcshkNT0E5v8xBL
 GJe6G6csPaMTHfbZeqDCyXXPwDMFPxJt1XLntBw84ufRmMr15vh0BfJfbkZoTisWmET0 IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs28jyme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:58:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H10549020552;
        Fri, 17 Mar 2023 03:58:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq477t06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2fK3pv9wSenJzsjDsHJh7+1Jxd3xzu9+vWVWlOQW7WZKd2XqNhFXMMu5jvirHOu8bylhVrcQT/jVlzO2dIc2gXZvAndgSdJbIi+Xfzod1vyLi4icABm5k8jPSf5+gAD4ymSsQGzggXlRPXlat8+Htqc21qnMc6XiLeakhyAgRHPtSOw6iG1Oro5FtIkt+auiYBZWB+VTF/YbUbLRyoQhxnz/v50S/3CuH3hIOELZdri502R7AjJL8gJH7Zp/6QWymZP3809uXVxaessZvzXsKcEDpNRQaTIHsdp30xd8KZVvOue0UE5UFJ3pP13CTG2NKip7ji+GGBPfjKuFHUP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksUAxqrlMeeWT0F3qRpI3RJIE8UKTd5cgbyKhO8CKAw=;
 b=gJ4n7awa1wtBgfvl5OVvRFeAIMTJGPLY9gU5xV6Yxo2VV5pr5ANOdB4URXg8/3IxGV9670xsrV8WIDWiaD24zU9vuHsYB1iV9UWNGAHdorjrl9HK82xAPIrnkCdeUC6f3O72U9yYGQl+XbiPJUuLg5WCQJZUykV6ignl2AaBh/WjQe3kA09OParyUTK2LfNhyTpqUKwBkBQ0PC395iV/IxKFPV9tHoL47bi6x+KYpj+2CvZEoCFZLLoLanpN6SJX/c08dhY8CGSrpmQpFmM6w4uEBmBaAAxjvXr+hjWo89p79i4nr3J2dJLvbO0Onism9eVtZe5m9zPxoI8OC2UrKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksUAxqrlMeeWT0F3qRpI3RJIE8UKTd5cgbyKhO8CKAw=;
 b=c72wOUwJeSaom731aSTyvumV6MsXlCj20zq7yYqffuuhdh9x2XhtB8Q01GhjXEGCPaZ4Fb8R+xb8wRUzjku7WjetGWIhwsoOKtRwYPsF48HSe/F5bI62SPx55vFYMKossom58XgzNH6IRZEzoNhsEuFT/eoZnJpgW5iyt9aZk00=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5176.namprd10.prod.outlook.com (2603:10b6:408:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 03:58:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 03:58:12 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/8] mpi3mr: Few Enhancements and minor fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttykvxkl.fsf@ca-mkp.ca.oracle.com>
References: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
Date:   Thu, 16 Mar 2023 23:58:10 -0400
In-Reply-To: <20230316110209.60145-1-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Thu, 16 Mar 2023 16:32:01 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fe70593-a6b3-4fa5-6a29-08db269bd418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MTdhoHbKm9SdRLfSEYU2q5eZoiosEGiXFl1m1lbwfJe2r3OWwdDB/E0VJJhMyeBOPMmoO8bHF9jvGUPL/JWakCwO6qCdN1vRdDhYa4JjXzFoBwQwX11ApVfu0BMATWtrEAM0RRxBHDGjCMrCajtV6JZeZtNV5qYZ6HUQPc6tJtJvXdQEH0XKF3G+QKNXT62yj/JHOk8sBhZZD15i8C945do4D8Y45w2SrSMaEm51tEd5dd4uAZZg4oh95i+MnRck9GsHQbZPtuWrtNJtYleO+jcpD4YggLFLltF/tTBBsvP/7SzbhCCny2TOi3HGq3JRG4mftZDTempx65wioGOTervywSEK37BjWAXWxe8+y5YCil2WbwHQKT8KDlOSe3ijrW8SYsW9M3xNo/s5RFH3fyUJwSyix1zpIep/TpqSJ7mJxYYCG8hdCZ9vH8ehjpqbLODpxBYt+svENVRvWZq46lJEDpOfGF79/TjZTJRKXvrwgoM6tYuB2jdeioSoJaIRerHOFHw3faO/OSsRy3PrG0FjN3VfeRZVCy6VYxcC0F2MyiH8xSGNxLxhkFSfnCgwR0TmK+gTWqZ6bOGt7kd2zJdeTAZU8TB+LJBTy3LFvCG1uslU0CFLqhMD+/jxB24Tphua1HLL7SR/Tso2bm0NlxshhpZpNtF6TO+MXNJhW4SeUNs9cMyBdR7i3NWDF1x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(8936002)(5660300002)(41300700001)(6916009)(4326008)(558084003)(86362001)(38100700002)(2906002)(6486002)(478600001)(186003)(36916002)(26005)(6506007)(6512007)(66476007)(66556008)(66946007)(8676002)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+5FMSCYAhRWZ693BPpZ0dGDdzqLLh42ddRzCX4i1ATaB0RdgTLAt10j/QxK+?=
 =?us-ascii?Q?Fux0jiliR47Ui5ziZUfsiBV0YBssTno1DzPw5fLlCnoiL1uZTUN50Mut2zUV?=
 =?us-ascii?Q?LsoD6S0oazFG/ooTFxC0bzL+wbD6gqPeBDjWEiCWYz5RKM+K7b1EfwPzV5fd?=
 =?us-ascii?Q?NO6yGVQY37T9+TAzArbqFOThCy9N9QGacSsnSUnxfBCW9dS/uIfL9csgPhuQ?=
 =?us-ascii?Q?TpkdBdlQrudklzMKi2asrjoj9WwUePqJJMH/pelmhqWiYgTX0OC4GCym6vSS?=
 =?us-ascii?Q?2DWqBgoQbD10QxymYnKY/XLRGAU5ACQzQbpauAVPEK4LSP93tJnv37Izu0kB?=
 =?us-ascii?Q?oUBMXrcsYlc0MXcOknb2+n+QAKlwA1IeQFWD24+jhDX56ko/xS8mEKhwRc+m?=
 =?us-ascii?Q?0wZiYgojzV8wzGr1/gdmin3xM/rLo7+oq8z/QXlWtN42fkORJ8Njc9eVylOE?=
 =?us-ascii?Q?JVR4K79ZXHvw3PegeXhMCrpuMTkY5Yvi+w35Olc7AFG85DovCkHR0ZxuSGFV?=
 =?us-ascii?Q?Nz2oD2Sa/FzRVb5aVPIyXOIn1X6gsGJOGeHp5u88n0Z/5NjB1ljCw2p+KB6Y?=
 =?us-ascii?Q?crZIxUexRshk4ONaxEi90EzP+3oyC+GOToqo/QO5LcRBK+2GkPK+k/I6mrqS?=
 =?us-ascii?Q?XRHV1k0e/HWoQHfLq475hOjxXqwR7uidRlP4BpK0zlWO8bVtBzCq+k391yBd?=
 =?us-ascii?Q?PIlzQgy/+603o3oRJpXmJy7APdgYqjem9iYQHiYGPGb+9PJ3oHq19lAM1dPc?=
 =?us-ascii?Q?plaiLO36EPbue+B+wC9pL07zEUoWyhMourbOO6UcjwpeFB6xE6BvGWX+4dXT?=
 =?us-ascii?Q?sALB7HXyma4jnYgzDgICpAqC8mHgR+gSRwk5T+vJ+NRn/aFpsBDGQhu8AW7D?=
 =?us-ascii?Q?Ig8gGOdHwQFiA57ot+nKbKtZdyJktMeAp3LxFlkaTJ4TXI0FUvE1nfSB8H6O?=
 =?us-ascii?Q?w0I9j7ILgZBJcu0gtSh+cFGgJnSp5bSskVEpVwqCR+ooWGbSDB2PxflrIGmk?=
 =?us-ascii?Q?tYzlpSe3nMNhMRruOQxcTNNMvg4gr1syTb6Sb+QJPJQWk1bxuYrLaUcxweYp?=
 =?us-ascii?Q?KEB8hAjFwwZbsD5uXFHxoKpdyFM8fwR+MPjCpzFH3JTaWNeIhmwbdrl38PBL?=
 =?us-ascii?Q?KwoJdhy630kcKgc459LiuyXCdLYx5f1TwlS02CU0zEo7JUIDTXHSnhbWql8h?=
 =?us-ascii?Q?FuuRnNKne6+dmIp1NdND9rweQF2fFqlLirCTANn39Z7OZpO+ZiaoXKVbTuYs?=
 =?us-ascii?Q?1we571qpXOdB687hz4o/Wph1PCMleY0xkiOkKzZNxVp4PT0yHzW9/bWa8+Se?=
 =?us-ascii?Q?T4RKpr1JlxjT8RczBSycC4lfq4U1vgtN4ZCH/H+hjYh7xxsoA7grz8BYjtN2?=
 =?us-ascii?Q?wMQ7Hfm4FgcEH1VNSeIpwE099N5FIcw8rL9xMG8VFhmCvU136Y7k4Bab2s9x?=
 =?us-ascii?Q?eL0/4nFB/lTpNzjB+grGVuzj4GW3W8h+8d7l4BINHY9Kh6RT0i7I2C4k3G5V?=
 =?us-ascii?Q?0rwff5eoOGuT5LK7Rf+Po8MoH9i9/dyMF1ZWsuVhPsOxiBww7G2tkuu59754?=
 =?us-ascii?Q?F7EIalzwGEQKEfckAqAnx9SihVN4vkqSC+S5jPLqaqUbCMkZFbvHCIlq7U4I?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XYvpFy0QFJHB+l54uVxpAfvOQ6/ItAgxqjqFQsv3ScMtvTtITOxi9n7FCMs5/Ss5jhciWtiG7c1zsAankSFps2fTnfNhVqcOSmgL5534ewtNkeCN7Nws1x/YKSu8Cfj/oLuao7OTajFbtq1jw23mtBBz1c+dQC4l2c/6Rh8c/S9e8MqYPKvHRmp/PO+RI6HDASu1NliU/BnQWvGJTMsFBh344nHiZhabDBxny6rPmB3AViKYfUOTtetHwIBrXNE/qWloFSfmWKIFhn1dz7N3qolGGu6BzyMSLQep+A6mVjuwsnPMLDhWV0rYXsSHOL8FCuqdRU/a7CsoB5rrLlIBqtTeCwU0P0PEN1k7FAkTSh5JrOvVcGtkNeVBf8LojlSmDYGxlCM349bkTk6tvFi8l+XUJQ7yFub6OyAUTnX7CDPX5vb0T/BvUo4i6btUMR0hNJ9l3OVWwEkbDzj9VfSfGVzgn1hf8jAnnur1j22cg9OJ1AgrDsyYvucyFlrKMeH9J/APcYbpEoKUU9bNLNt0YtnJpIS3kWfzQ96vaJncaKuH6LMLZ1jccUXeZJ5/rYd3DArK5d0i20ntsY2zNr77t77i4IPVJQ5qBC60CzFUD8vYZfSJjSki4xWEOLaawyAidYn69qToPC0jS+ZIfD3T4PscNr0WAl1VQ6sF4mHPFDHOWyjAUBuGM4gsc1rKzLN9SIrHYoZ7KUD3HazxEJLtF+GCjaoZX8Vn1PKxPKTmhGLFs6/+WpbnjNz8YLgWuFXRbb4eO7IO5EhDIxtUU1I2VzfJwuoxkxvwZ+qDg6qOd/I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe70593-a6b3-4fa5-6a29-08db269bd418
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 03:58:12.4931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oynhRAvarhiqaPH6cJ1S4ElSENsqSH52KlpDYC5BVsptHbKo7+MnGBPg9GuA3mOs670rgS7OWvoTJBrXG+CVTcOjEZfRglva3DW+H9WNAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_01,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=827 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170023
X-Proofpoint-GUID: yiY69qbcwt5yoIeDv4e91K53WaHEmHTG
X-Proofpoint-ORIG-GUID: yiY69qbcwt5yoIeDv4e91K53WaHEmHTG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> Few Enhancements and minor fixes of mpi3mr driver.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
