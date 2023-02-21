Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED16C61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 23:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjBUXKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBUXKJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 18:10:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2E026CC5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 15:10:08 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMi44h003936;
        Tue, 21 Feb 2023 23:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=OjXytIhsi6pp2RIuxIV3jUyqy6C+LZwZp1obndGmWlc=;
 b=DxayOEsTagCcHAUZ3Yl3/2A5S14G/FJAKVL8NTLwr0JjgezUzjCWnvvAT9GHjG0h8W8r
 yATZMFv4uCPeA8JqGKPOS7k/f71/DCy7hTYPoGxihCSwXIJ0GY8pYiU9jjeXDpDjnTrc
 xjPGwZHZ90rMo80PPOgNg5whFATPSWNn55ZZmQ/HDUsvDmtmPoFT7XgxhJDXxcTIS6dV
 QgkaiUTGkTVE02Xil5qlKSq0Bz8ckCdVuCiOVC7pGXMb9immRoZJ3J6CwYi4E3BAu69Y
 Eq/jGNKmATdjR+bTRubJCnMihYXYbryDqxB9BLED/+4OlmEbAQTeSFiRQIEk9BEnZ6kX lA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tpm7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:10:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LLXlQk006939;
        Tue, 21 Feb 2023 23:09:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4cccpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:09:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKMiRNzBr63TWu+oJYE4zqWtV43Jvb5xQ5X3r6jMTjvaK+aE+MaDQJKPNQNBTPxsiVtQpvN1Bzu1l2K1vaMmQXL3q1pWJlJzDS3S0a5FIn/Yy9+htZmFIgiLM4JXyJ49qC9gzjNY17O+61SYyQ/+NlmBIiUKR9viki7eGnEjb92p9amV+pIzKzJCPh6e+6dDIGwYUvh5s2QDPiN4Ik9vXrL2tw3ukQxZ7XldyClkNDCkFX07CET82C3sukwWiqRu/HeKicj1mhaJ8MJgvlregs6w//SnjOLhVu+/yZrUBiwZlmbetCX8qJOINEgGljk/k8P5FeXJ74K6B86oSkE9yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjXytIhsi6pp2RIuxIV3jUyqy6C+LZwZp1obndGmWlc=;
 b=ZlzBc3KpFo8BKIB7t8DUu8zpA6FZHprv5ZVi/6kvUVSOSE4PNcpLmkfT0nlpi5xbWCWjHzOL1oEQR6U0zH2OaAUPB5XgZYB+K5T+Z1R0hR/TuiRMxhOLu0GOde9KlMZssJLKHMWL+3nNtqQnvVD/+jo6g+HvZRVkonTLd/fj0dJ/mnqYQCTQIz1PpscQ9zlS6/8Xc7BpHKJW725ReHnZLxisNd38ydOzVVdziKqudxOWoPAH35o+KNr/f78kcv8OAvsFPq49q0cbr2AfaH537XYidk640P5BWVK/GMAJ9uYejGr3QqjjajrkTBtLcqmOJt0Jj8JWIhQW2gGuDEuJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjXytIhsi6pp2RIuxIV3jUyqy6C+LZwZp1obndGmWlc=;
 b=ykja6eMicnvqW2rznLNERgARm04CUiPF1HNk0L3INUXy5DYRqYwmVPB0cDiCG3bPIateTm6MA06bXhGdi/T9jp4M3M+aN7SJdjG7Kw7V+ZHSwn/cJcabalfWaN5GAyFvZTfaSnfMBpbIjeAdUX394QaY1A0zlQyEain9DSMIjEQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7141.namprd10.prod.outlook.com (2603:10b6:208:3fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Tue, 21 Feb
 2023 23:09:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6134.017; Tue, 21 Feb 2023
 23:09:56 +0000
To:     Adrien Thierry <athierry@redhat.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: initialize devfreq synchronously
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ybusjih.fsf@ca-mkp.ca.oracle.com>
References: <20230217194423.42553-1-athierry@redhat.com>
Date:   Tue, 21 Feb 2023 18:09:50 -0500
In-Reply-To: <20230217194423.42553-1-athierry@redhat.com> (Adrien Thierry's
        message of "Fri, 17 Feb 2023 14:44:22 -0500")
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0040.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: a08e76e6-82c4-4672-58e1-08db1460bf76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4Q8nY1Ue8yMmSw7JhrdZx2klmeY4BygwOnJn2D/VZ+CPF/ie392jw2nYKlrnAwvQRgsL8EHtvBoWmldg9xMVoeJeXzvcAxvLR8rsqifis9iK4n2RA0I9U2ahTABeReZo2hZWV+aRJ6SGFjZlPeZxOXLhBt3tud7JiVBnT/ZTbPGV/naTGxsSHGXNU4XfSShEgfggxU/92gk3mSgum3/j7V1LAGfWXhj1BEtIlS5ludBc7gl6HYrAQQuMnwG+U198ZVkvLyQ92jtO3EpyUuN/x5HW2FS6DylSk2sIPi9WbPZIkVzznjkF1PegDQqJqvTBdcZ7TdnyFRxXuRQaQFTjnoC1EuHqBNfU1X6rknatN0W/mIEQs8u5gL3rZHC1VNJsSUWKbcn5F186695G4/aXOcPx1oHyGIgdeJXgvuotY1phC3lWcpUGrTWvPpqGeVdqUX0beTW/wftBIVRUtm1sT/qnkoU/LciP99QKOm6bnDP6gkrY1GNsto3tA95u2I994RfHYMVYW8iiAt7/uYJTQHYVfL5FAzjVjeoB3WH5swUjByGytrYTJDIedo2a6QuBjgQnG+RlrV3wSFYiccKOMbdWYseL/0rai7ZCKlxvqJqLSltyRhU1Z0FYQ7B9MP1b+mwko4VGKaNvHnaPcfNgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199018)(26005)(186003)(38100700002)(41300700001)(6512007)(36916002)(478600001)(83380400001)(5660300002)(8936002)(6666004)(6506007)(86362001)(6486002)(6916009)(66946007)(66476007)(66556008)(4326008)(2906002)(4744005)(8676002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7X45AMiWrhqa+XlWfD2G7nVV/ith3yUwXhVZLp2cvOecGYrwT82n73550k2L?=
 =?us-ascii?Q?LQlBM65G34C4BcPstzds2VDT3GL2i+76mN4kIib8eWIcXIBSzIxtVWhLQOFY?=
 =?us-ascii?Q?nAObWsWrfgFGpOopGx3pvAa4dCa2Z8fdmeFIuo5bV4x9PiJYYbgCNMzvMbnf?=
 =?us-ascii?Q?NouSfrIEZkn9y3OI7WUf1wSw0T0OHurwGsnjdxrrMErfoE+i6jVko3+NTp2g?=
 =?us-ascii?Q?f8wl8pVLKkefrC0O0y114ZvvJOP7vnuH5ru6jyTJ/CGax4xACf8S8uoG22WH?=
 =?us-ascii?Q?4Y83MKXB1t1uG7jCFgA8KuVpfD8tlgL12ooCWjRbg6Tf766q7S+6qGnxLdOs?=
 =?us-ascii?Q?UlCMdhWasANmIsQcnKKZFpqw+mVp9Ke0lcgtW7F9VHcm22ilRfNJdhVFREGV?=
 =?us-ascii?Q?5TwFRr8rS/kNxaYkgr3ziJvHs7bBc7ejzhAJX/a3M3MZRceP8paADmDXhQJ1?=
 =?us-ascii?Q?n9wpyRGbAtKskPKyDKahPXS1Yb2mRDfNFQS+88AfNtzd2zmLuw9vsaxy5Yr4?=
 =?us-ascii?Q?0sB2ahH/umR5E5lI7hWBwSoch7c2LRktvWSvJjrGz74WltkESVRCM11jDK9Y?=
 =?us-ascii?Q?IvZtjPJ9EPNpHIuicdh9kpP8PQBAERaYlMht1h+h+Ac9i5piqtSVFDVHQgfh?=
 =?us-ascii?Q?Q5EsfGaEZywHdFHWDBgjtDE5TSIHwmx74sVD4PkBdifUtm1xLAyFedn+lhmR?=
 =?us-ascii?Q?FZeMtr28fuE36zSQ4Ok4nJb5gtiVrX0Z2+/7gRwTntjd/N5+vEzPwy8EMGpo?=
 =?us-ascii?Q?6akahH/54kYJZiWATEMys6sHXJtp7ehvUUjL3PaRnif+VrOKZIi7UA3yHiI/?=
 =?us-ascii?Q?idVZ1WpHFoZiqrL6dbm9KGjt7TjL2tygdnjIc8DD8Lz7DeLuQKyXcEmLmUzW?=
 =?us-ascii?Q?HDdV1HrLVRkWXnhU4AC5QxHogwTy4rO3JykmkWcQWm84NFc4net2DWkfUqZe?=
 =?us-ascii?Q?wkRkBdXb9jZYGCdW48KQ714zkdsXPlJID0bk0+m7EHT98TXLaoroIw2nH5F4?=
 =?us-ascii?Q?qF0rnVUGny282NFcxRS/N/Mlxntqy3lo69NfASARwE23i5OhshFI9Osfsx/e?=
 =?us-ascii?Q?prp4gQ6YgQCrFsgHJ//m2F+id4tEXyAdxHnHYKtPdzHQDRvp20WULYn7mhGP?=
 =?us-ascii?Q?tA5IGLnsXoJ2CR1YshC5JBIU5J4c65o74tj8DKuJQ2RzXphBjPjkTfgZV/ry?=
 =?us-ascii?Q?ARl3b152NgQPLkmejQcNma8ZW6qNO3WnAiJz7Dd3sSvcTDeIH/qxmxQ1991A?=
 =?us-ascii?Q?l+C87sOXVm7Zl8yWeQWS1pCWQw9u92oJ2usqhUvWUWbb5HvHKoqR8TFWjHh9?=
 =?us-ascii?Q?CZAGzP1DTWmKmsaUKouiJg4CrxcjC4Kh6huJ7r17H/9ok4ZIQ5OcnBkQt9FN?=
 =?us-ascii?Q?rJLGgjeSzJdScvb854kMdkeIOa7Vmv0/gCNRpkNuqg8Sg4agUivxwkjBXIZU?=
 =?us-ascii?Q?X7WWOM+1hV0xlxKXHNswi0aublErBbWF0rSIyco8DEuz1yyGtT4s3AqlswIN?=
 =?us-ascii?Q?YUBedq0m6ozc6eWxv8R0ERZuDsV5CcVHwP7rkh0G8tIbO2CiVgdiADXjBncU?=
 =?us-ascii?Q?pgJ/HvAutbt+Q4ydHTfDPF4hDhiHFOBiUiVMcKwIlV5+PJdhaqczBtqLI/dS?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cZrgTJ8PTcbIv7075eaTAyJ/6SkVS+CrRFwthIPtgLY/wZ6QbZUR26HXeqYLjJMvzSRjfjYbj1eP0h+GkTb8AyTp37+5Dt8uCc1untWS6tnWYXWgQgQxM24Ec+qWDWZp9MPx0UL1wIK74VAsyd5pzh6+VSEfDkTpru3lEl4OrSzs56G7YFg8rnL2hHnNMYotDJeY2GteKfcjB51qiwTkH3ujYPKXLY0PsZYvi1nfWcGRiwuNOqfJnNbXYUlRvhdQVqOEjGPYrjipCZCMKO0/L+ugl3OWoNYOl4yMDr1jHYIvjshsIuJh59LZR6pQ4tvSTdVwGvkxgOEL21nxFniFREHDz2IwMG3WjJhV79iOYuqYO2I52HqRiRjQKWODcZDSqW0TSDKHm4m86yqwy8iS/ySfKHx7AZ+VUePPOyVIhgmqUudFc43kli1s6uDhheLALzZ/UJpowle3hU/wjfQ3lMeFq2xgSXZQZEvSBnrcacau1sNcsmQHMnkPbP1anei3bNcF4CBX5Bhk9Gru3Ctm8cAAMQnWoC+IWMAt1b6Ave/QVGrbnt7s8D5427q/oxrlQc2wM3MICThYPinZwsQb9aPYyOPGigp8ntDn/SpO2lgNGv3Uk/vLud6y+k2KF4VlgwSucjPzxkqdEv3D5yp65vx8mIkRhA/rD41r8Y9ADsqFIkgDvCKNWKOBjkQ9VqYxkjvBCC5OIdxXDHF9LBXkjuhMcPPFRKIUa9dq04MMykJVafiffGSmI+pDS9wugKUV2BvdP9DZeUY+PDVz0fHoQmBCqkNtDac9CPdKPl9XRmT1KYHvhMICqw1eucORRI84lEIa7jZv6CIg5ndIIiBGS95R8P7eB8km1t5gC31iY0UniKm2ntp8+nJU5xjj4x3EBbiygM9Of9Oj9a5LUyA00w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08e76e6-82c4-4672-58e1-08db1460bf76
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 23:09:56.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJxHldczK5w54HHt2U0px7DAp7j7g+wZk0ZS8dMd0QAGaIHaYaThIncA+f3fzkImLGKIXJ8Ehws+KC0D89LrxTRnHMeL0+8HRPOer5FtLwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=841 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210198
X-Proofpoint-GUID: D5IMr462rqnf_yzhbQZZYKbADwSNCCqm
X-Proofpoint-ORIG-GUID: D5IMr462rqnf_yzhbQZZYKbADwSNCCqm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrien,

> During ufs initialization, devfreq initialization is asynchronous:
> ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
> devfreq for ufs. The simple ondemand governor is then loaded. If it is
> built as a module, request_module() is called and throws a warning:

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
