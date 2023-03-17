Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9A0C74A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 03:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCQDOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCQDNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 23:13:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F2C9E04F
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 20:12:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GLd9K2004303;
        Fri, 17 Mar 2023 03:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ZOCRqDffiL6C+a4IE4F+GvLoeop9QEWOpZJXAKHYN98=;
 b=dDCPjFApse0Zk6icvsgJDBFa3vExTFJkgNw1H3niWVWrswfePKOXptYEPIzM0qtJoYQt
 MRdpK4ncIvv+6tJx6ixaGSVN+pR6k5Wrvf2QoYbvIVDCEPqD1VWxg7KLb9qV7dORfA7w
 LxFbNUwK4BVsvmzGetyqjOTguFoDsH/j2I2R14GHfyuojJ1KwkqCtkMbHGIEY5d0setE
 dnkBSP0TgbVck7AlcelvMr91Q9ZVRI++NxIwuKybIn/6F1+DqNPwRTRfmcqQ7rFmxxH9
 kwAYEgP3bT0P/z7OU42wAFjmzKRRJf7JOtSEaDgSwVdjR/wg3fIWKLjE86eA5+2+v3Jk 6Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs28jxax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:11:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H2ZPf0036952;
        Fri, 17 Mar 2023 03:11:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pc01qpbh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 03:11:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyvOnSCeadUUPrk0ETAhgE9zh64W8/Iqul+aqWwB7Zr1kk91yAGj6ePqFpYb5kXIkYyK/j+ocLrKgW0OnrwMF2+ppo/xw05LNp46aEjAR7NJdG/W1md4Pd9Ph34gEPxhvmc+g+B+ycrK82QPDjfAaQlI3aF1eW+vS8O1GsLJI1Sl1DGU1IW+We/y4zZDBNTce5eZZiipV6D+Ep2UCy3RZCMvQQPo5vJ65IxCM+cmJWNUAiw107wMEU/o3A+liADNjnptXt4nvtltkVrHWgtmqZeUY2j7usTRPm9elONYKo3FOLFMT4SpowzY21QQCaVrEGORy4ajP1udCNSBtf35ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOCRqDffiL6C+a4IE4F+GvLoeop9QEWOpZJXAKHYN98=;
 b=OC5xduQYqkZ/tWb3++OL6nVzBNBMagYbu6tuouAmmAtfAJRRbkUMnhbD4sJ7pjybv8EkX0nz1jRe3C31Bi3mLay7a610/SzL7qpFs8cjXHcICSumOeyLx3T/ZE2uRe4xDvaNQoLNyWBeehCatND0xd+orWdTfJrWMKxPw6mCTyArV6NN33sAVp7MP8OxqYndpSj+bANnupog99CSIbIXT/U63xpqLtPwlPqDcFhoPPFnpqIkpEpIPZRtUxc/+/kbprTyoHNgCz6hVVVOn+k5X1R79MKUH2NuKxvKJSpYBOlOF9zVhdc4nqOm9TQgaGoM1Ko8Z5Bv6NG8sY6MVmncHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOCRqDffiL6C+a4IE4F+GvLoeop9QEWOpZJXAKHYN98=;
 b=hLUinIldT339NwwB5t1/A+zjVZlDO+K/EBeI2aCZLSN2ozwMPy1lkcBl8TYsLLKRmsMoJRHIfVIkvH0W5UEC7e/i1mcIK5NOiNZbjrUJYRJdj/LCy+wAjrP1w1czENSIGjJJqsRH8HM60G9QO+K1K/5oMLxCCMtZyP4Cp0U05UI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6955.namprd10.prod.outlook.com (2603:10b6:806:329::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Fri, 17 Mar
 2023 03:11:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 03:11:26 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jqkysvd.fsf@ca-mkp.ca.oracle.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
Date:   Thu, 16 Mar 2023 23:11:23 -0400
In-Reply-To: <20230314205822.313447-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 14 Mar 2023 13:58:12 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0059.namprd11.prod.outlook.com
 (2603:10b6:806:d0::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd50db5-68c2-44e9-6815-08db26954b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9pGR7r1YctOoBDqf45XzDebnGmx5qzcNhPwrIN7D4AHRuYFkPf8dqFCpTHjNMRb1raxC+iSinjyY9AC+tG0oZM7w3RrHAc4RmgGrVtwixRAlXPJjar4idSPkgrniL0SiB1Zc5Z1u4RyDPFrH6xs48+xNyI6kVNsMBHbg4KsRSfYlkhicEbZwKAYAot6EUZdMOzwfpSEccBRDKlg+yMVYhvyEQ/7vZ2fa8kHZAF+7/9xXT7nvx21U3soGV3vOEnDst5GEI8dAnwePgETON7g3aKB0qxhWcAzIeaEbjBzA2gjOYfR3P22sn9yOFwiTkn4sjAshHuGyXM+0dd4RiB3v4Nwm9AidmyBD4slSOKlffCx5O2LutWC16ufzmK23HgoKqso+E9lMdTnRQ2pu0aUZyddXe8cVWxUjayLPW8No8GhPidaRqyNzPPWd+RCQ5lhRMgucQcD8lOhghuni5dwCFwPSi456x9d4waPT+Hn5aIqIn2qLfXzFpujb/U+y0V6uePEOF8/N10RkcSAQYKLNC/1eLSy29SHch2ai6pHWQuFrJYaoRxaBaFj7a1QqPMriGP/3ympukwUjblzvd3wrcjnLr/gErlsI9do+s8Vv5sj6POPJ2wR4cdNGNTxdroZYp6j6IOEHtuUJuYF33a7tpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199018)(86362001)(6666004)(36916002)(26005)(6486002)(6506007)(66946007)(38100700002)(6512007)(66476007)(54906003)(478600001)(4326008)(558084003)(186003)(316002)(8676002)(5660300002)(8936002)(41300700001)(6916009)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dJf0F0m6cxzjVDn9Nks6FotG+dsrDPxiIGspGkKgZKksmxNu8hm0+JpUv7M7?=
 =?us-ascii?Q?KGFUTvvJOQiTsGeHSgCrvmBuVXwdATbkf5FgVUhUsEAEAV5jrIqva/3Jlk9S?=
 =?us-ascii?Q?eh0xaeD6gPftJUp9BbcRUfZAQyzethOhEpxs2pdcafTLEasaFFVHG4RChBfV?=
 =?us-ascii?Q?GEZgoWdACURj8SlNPKZXgYn77aR5VX+q2PfC+AVeZrZkdvox3qg4Q7QRBXBd?=
 =?us-ascii?Q?2jaKR5nMYxGEdua1jGKvWwT3GBrcSLZToHOgSao0a3tsTEkqyRx6OoWDQFYD?=
 =?us-ascii?Q?QikFw+eErsc6gmASEHWoZJGRICYX3hkL0mgj0FE7LqY2d+0go5WgD7PUJYOi?=
 =?us-ascii?Q?9HNnTa8EiGbiC/nU4YWyE9hNV4fdegvmD7/RdjCuZLkKZieFpY30pyaGSTGM?=
 =?us-ascii?Q?1/QeOWYg91IcTAmRl5XwTpM9B8QN3ZkCj+mVUN1PyeLNqLSkS+HRsSAC7ptF?=
 =?us-ascii?Q?iGCxqFf/kGYve6Iq5aR1dLhVQXwSZFwPyZ4pp+l0YFZLGfVXrnbQWREwKWfF?=
 =?us-ascii?Q?nQlLiI+67XS2SYLagtKHBjVppn9TzdQNlA3WYtYZcnQJuJVYyxhs6R4fgywh?=
 =?us-ascii?Q?SRLxwXw51dwdcJlte5sppl45ugX/JZEauYxjhZFEM7KHnrG16H4X0fbTEkhA?=
 =?us-ascii?Q?T5Tt/zWc0ar11MPrUxuqkGa7WiZXqsFrXs60e1z4sW0+eoaVGEZ2QwZIOfo8?=
 =?us-ascii?Q?xuc5XuIJ6tzK6ucaFAHUfsCZ+Ql7LRfQdBEyxX4JLn0I9+phgusYX3sbk3Nl?=
 =?us-ascii?Q?oMzPcoLZazk9LIgTZHfqT7Nh+K6I9QiILbhlzZI8Kw9EN6oc4PGjdawwM8o5?=
 =?us-ascii?Q?j5cEO4hfd9eVvjE8GPU0cMlhLcbDI3twa9j5zkEF1jBebgGwUSQIVURWnqlL?=
 =?us-ascii?Q?chhEOConjqzUDaNTvrJH8Uca4/MytaOy796fBniywf5M4I6m2q2VeoJaHFpC?=
 =?us-ascii?Q?w7e/68t88kyTZSzBZh32jvMGZw6T1VwMGyLjQOWmRyFhNUCz1Zctwvhuec+v?=
 =?us-ascii?Q?q8E6tmGuBieFkf2I4pnpc0AIRkvbJLbr+1uyrVSwXHEJMmG9CkWQ9CbvcPtX?=
 =?us-ascii?Q?3cIPeKM4XLBJArp0FneAcZ7q5YFvMigpnP705AfwxMagbQtuNW1y0Wx3rk/c?=
 =?us-ascii?Q?BYWdLZYWictvQNASiTeT86qcJJolaqRjnGxjnPNDFwA1UnlwvDRrAPib2h4D?=
 =?us-ascii?Q?x+q64Q9lWyQYBAWvArsg1DfYH8qOE+SrMF/PIi0MGKSQcCdkFWYQDQKOc7EX?=
 =?us-ascii?Q?Gk3JH+tuDanln7GDEbgGkurbC+TqU4SGQHqqxNp7DTN34BUts0IQAWl6QDiP?=
 =?us-ascii?Q?bvwM/RfMLC8Kh4tUZudOiQyBOTOttYzZ1HVtbnXlO0uQb+ZA2joADGg79Z91?=
 =?us-ascii?Q?RJWtT9pW4H9LHkJ/VNdGrowFfE83d9lSXGuuAak2tbwKOlLEX8JzgeQBCQ81?=
 =?us-ascii?Q?+v24or4/W3mfWTOP1PwW663KBz5VmgDeIWN0XFf5mjzWkamCV3ZSCFLZ0xQ/?=
 =?us-ascii?Q?++nr4eW8myn5k/DOqS+ReCSptbTLYbcB4Rqc7jzu3g8tlIFKfuVOUqzpMlxC?=
 =?us-ascii?Q?Lr6YWf1GR5e/3McTVnEav+h4Haya3WqEbzh5fcV38vrw+2AmKmDunZ4jtMz2?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?uYfHUpQTYsU9V2qT9ZfYKBMjGenUA2g190FhOdnB5R0M2bMHlk2xJiz4x7tN?=
 =?us-ascii?Q?wPqIDzmk72uRTS6MiF3kNwfgYtOZkSgROBWraSy4NtCOuw+nIWygqxXvLIoZ?=
 =?us-ascii?Q?zDjF+mjtnCErbaADBHfirYTMaR8B2qFDw00s9sDjUpmiBUV/wG75EaSRpkp8?=
 =?us-ascii?Q?hatkIHlbx1sosWbnp5ScdGSUv8h0tl8X0AwiuGu1W06f5oM6hLYOOQXRRQnR?=
 =?us-ascii?Q?0ZJF5gAJiwIxmqUWSQN4CMVjmUR3DJtm+F9tqjAE/gDx2cgK7jEAxpTTjGCa?=
 =?us-ascii?Q?fxt/MLaJz+SGRb0DrMvUe4fth0XWudLHocumOURQXTOm1ugTPvRZxjl86MnR?=
 =?us-ascii?Q?ZRkp23dgE8BkebYaVfiJNSXj/MBhAvM/xHB+dEso9/OBdGo4SOvT0Jr51YUI?=
 =?us-ascii?Q?8YMIdFEW8H3aXp3at8N9Tb7w6kzdAwqGwZ5pA+cHMNwrawTsjeQA/ENH5DPb?=
 =?us-ascii?Q?jkAdzImcHFW0PjfgE5xXOGBj/bLFmbxSmGyiooVEs8WOjBmsxRsOuZTXuqdP?=
 =?us-ascii?Q?1ajVbi7OT8P1ZEpRKhjDzFZIbb3YC5bL/P52QpynYQJaSR0qtuYc2/TBYH1f?=
 =?us-ascii?Q?iMfWE+X7YNQYg2JmqRPEVMtgBXFlX1PE6i//FZPE3EudMQhnQ9O9fO3IUUVg?=
 =?us-ascii?Q?cE5n4rvupsnpMfKQsVdvKItfMQGJDMt5xeY5i5P2/MTN1Xg7FojaR0EBdI67?=
 =?us-ascii?Q?emUasPz+bgryKvyzNTQZovtcVpqJG02lkAx4W/6iX/31OhjBux66p8evvavA?=
 =?us-ascii?Q?anHe1o25hst7w9Urn+KelQWlSsCK9LdbtYFjHI98MHsy0hLRzr1wwxYEyZR1?=
 =?us-ascii?Q?RTvHcG0jkwsj4CypJjKJRlRi5OqM8Zl0wCiz9kUaG6Grz2lzm81kMIR0gjhF?=
 =?us-ascii?Q?ygcZATQ9BKOwqB28FPwm0Ce54s+hEx1Ttd9igy18egUPyz9uSZO2z2Rep0dx?=
 =?us-ascii?Q?xbSjl1wAjuZoKUd/RAw6qA16upiuIgzXpdH73bfaKwo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd50db5-68c2-44e9-6815-08db26954b49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 03:11:26.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+zIxkulk9js9fXhd1mv5EcDFtCApQCruCFm1eD15JQVeWeKBOe/W/TMpIv4HrrojvkSXX3WJNC3oTAuXInGfdapMEz4LtRTi3HDTkFeWls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6955
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=755 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170017
X-Proofpoint-GUID: hZuASQxFFa8gUQzTbWMcEBzJpDIaHHgK
X-Proofpoint-ORIG-GUID: hZuASQxFFa8gUQzTbWMcEBzJpDIaHHgK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Neither UFS host controllers nor UFS devices require a ten second delay
> after a host reset or after a bus reset. Hence this patch.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
