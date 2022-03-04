Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED934C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 03:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiCDD3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiCDD3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 22:29:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75651710F2
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 19:28:29 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240gEYk013345;
        Fri, 4 Mar 2022 03:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ghuRT5SmaChVeOR/5l2q39ev2VZo+70Tms0n9r9msfc=;
 b=o5JVP5qgIckKLFAubBFD6yM3AIA4QuMXiIGt9BewuHDkhj9oyvGM2XQu8ptMU7z2vgL5
 inVCOWud5TmLxzyYvM+29SUAiRYHAafQ4Z77qlO++FYP5ooGwkCoqsXC0U1T08mkZnrv
 5FoSXCl6l6yIH9fJwwFUG2pgufF78BcMh1sOGfvEwB8Vq/YoWjyGMTiUFJ76bfavwFAW
 uNDlCUfMIhdEygrhVgfcuzHFKx/mVGBuF6fsKxn0ASxCtiDaHcIRcpi3bMj70HBTjq2t
 jcfL1QEZPgCHwc9hk/Khdz3Poa8eSQSH2lTtoyECXr2bpGR/W6eIjklRGPJPk/cJTsqa WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv0n0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:28:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2243G69l074176;
        Fri, 4 Mar 2022 03:28:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 3ek4jtfdkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:28:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm32QBy7vWpcVb+r4qiWJJ/u+ODVNlDXcJZJYRNFtRv3QCxWOmKIUi9Fgiwy/IiD3Pq7dqwrnFvGxEGVLIoJMMykD15VNMqW0H08To5Suncx9LKYuJQnIsM1POFm6dXLCdj6M6vG8bt23dJpelEU0DS+vAeyoK5e+g2YbQKYp83BYo+FtIZnNjMG6EcaHyZJIgPD+1YJ7K9k81Npp1DWpdYYUJK6oSrBv0bDR27w+ROgirniEy5neEra4GpxCFLcx3+jzdNfdPZEBTqvxk9meQ57YSmUXPu8DGU4iHGvzGLydx/uxDReAD4bIQ3soJLHcedB7s3vV3GJvbhIrR0IEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghuRT5SmaChVeOR/5l2q39ev2VZo+70Tms0n9r9msfc=;
 b=Am6TMTlv8cwn//wTk6prru5fD+nEWKXPX6G5gsheaN5eHW28JiZlno94iGANBMrIFCY0FSPGL+0JjrLK0sPYVYni1KaiCjf258vY4wFu8MVzR8ouDeLbtwcavX63YHCd5strPK4uWZXQm61nnrqXpf7WcS/UcnQsfcnRZPW3Vn7vabudrU3g81yL15nRGs/Bw3Ehb35QtrjTKPnx+UR6b3wcAIUqvp9lMVrd/rT+naoKmApEbzobAhh1WBOqaVjWfBlkAeLPCNDm39uGbtXOH4t0e3kkuwWDYoK+v0EG+h9LLh4kISRVpKl0zPKmLAORwlznF7MPZeKAKBFkF29HIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghuRT5SmaChVeOR/5l2q39ev2VZo+70Tms0n9r9msfc=;
 b=IvEZTxWpVDlEd0k6VTRTJ0bQloeeQnT0CJ1Y+N4U2ysXP5M/rhJ/HSbQutddrD2Xul8WjMj2+RVJOBvQ9lT35BV+aLMACQBuGA//oIJ4dSnvv2T5ALzGk8mPq3YLllb7VwHb+zeP7Sq2Q7CXE52Og8qv0oHLvm0OMBElSKGUfzE=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by SA2PR10MB4812.namprd10.prod.outlook.com (2603:10b6:806:115::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 03:28:21 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:28:21 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Maciej W . Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfrytn30.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-3-martin.petersen@oracle.com>
        <43d36f31-9f62-55de-219c-65c5e88fde69@acm.org>
Date:   Thu, 03 Mar 2022 22:28:18 -0500
In-Reply-To: <43d36f31-9f62-55de-219c-65c5e88fde69@acm.org> (Bart Van Assche's
        message of "Wed, 2 Mar 2022 16:30:45 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0093.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa472537-eb0c-4e30-1565-08d9fd8f0852
X-MS-TrafficTypeDiagnostic: SA2PR10MB4812:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4812F6FCE0F5DC9A848C453D8E059@SA2PR10MB4812.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3aXrNet9pFQhdCIKLIxhJU+yHsBYrcWvhO/1ANtvY7aQffWGcVOIEdt/9SpmE8mw1LHlNRmuwYfzt2D06JkACMdaoTPV4fhw35uFHYROXlYQrjYdwNOMDR9NyPngO2qQ7vdbv8J7HJ06g4ixxQHo8/hzaClUyxW4MGynib2KUf7DE0ql/V/IxULIciMYfMc0RVcNIB6+TaSZKBd91H/BEFVYozqYAIxJORzEbcQtlEq6YNHT/V9V5PUFcyK5jGCREtHKA3UBYzoyPkumppCNUDGaQcIWFIsbQu1QLUiooN1xWSzvsezY0RCjcR1T+48y+MK5EIZxZWcp72SKZJXyUBM7Bhfl4R/e23K5BhjER2trOl5CS7esAagFIHhknH2it467Lh3T+9CFCv7xN1eefTimPszNauT7Fk6XfH4KUZH0xwuo7aDFBoP1YkEh0+Nsem0/hGv/Vub7YuNAYoG/tD1gwjK6Npi8cVcLk4KIAdVHR52U9tzfj/+kgqsnPEeQ2sAx7xrF5Uw6bgdQUiD2kvuLWth1Aw1zyMPlo7oy8xFkwqbp5BOTyMrIwshdjYE13BsHTWuxgvPHtc6AdoEVix7S16YFOS+1UD9g66/56WITXEUe33uR41Lhw27NvoSJfU/s9cA4EZl360gWUpAffOuJT8Jz6NnpAINGlhnX8+1srSFQn2YfLlSJgylzua9/z/PZp768UybsPQG8DJs0bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(52116002)(6506007)(36916002)(186003)(26005)(5660300002)(2906002)(8936002)(6512007)(38100700002)(38350700002)(4744005)(86362001)(508600001)(6486002)(54906003)(6916009)(66476007)(66946007)(4326008)(66556008)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rFiGWshPqj91eV815B+ZMg1QUNYCYJhvzt+K8k/c7KsbJrjj120T6WcG9f0A?=
 =?us-ascii?Q?lMmJPRB+EPfu7G/IIvNKNhiifkYJuP9ME5P7ReoRgjZB1jqFWBZ1xsKCHv7Z?=
 =?us-ascii?Q?vVymvmdLQlfe2GXEHjQ/J4gGbdnoLIcmiSwNLXlsy5EjDqfVTI84uJOwxreH?=
 =?us-ascii?Q?kGhULps6cbg8K/PIu7Ca+keMzIz8qZoUBjR+sSvvpAaPvqL7XoZ5erlFfGZN?=
 =?us-ascii?Q?NaRvzlhLEsV1hYDDEB9wtcRzx+65wDAVJFXfUx9RqC284cQgoSM2/TNGRLpJ?=
 =?us-ascii?Q?8zNXX21Pk3FstJMD3KCtUVDuj+f0g9ubncmb9hpwh97bLrQR0Rj42rjz8s+W?=
 =?us-ascii?Q?aFQbUfZA1p37N2hRnDmpOSRUXLYpqUHdF4mH5EUEeW4PAM7AJ9q/1MH8pMCd?=
 =?us-ascii?Q?de+6MVrXzyE9WLNBjfO/kPQekcsvTPKpJCueqAdsiBECMFG4tHl/AWhEB/+8?=
 =?us-ascii?Q?6QRxhHw0EsIifm7Tm2+6ujDa9nUT7zLzFZgIWZFbiQgl7ooz7ARbp9F9cOU+?=
 =?us-ascii?Q?qbvw7EBLK0dJoFMhdMhu+7OnTUOafDNJqxhapgqVvRz39c8xzML8uuLl7P5M?=
 =?us-ascii?Q?CebW/B/HpOOzSkk5/h699e/aoRXCWSdPBmpcQbM0jmmoFKq/uQNk4+CvKYuD?=
 =?us-ascii?Q?4JSWr0hFLYIZJ6Vdzpm2IwAwsyocN4MJrK+LHuwUgQ/7c9dwzclEKlbWtKzc?=
 =?us-ascii?Q?/3e0PeF21rgsFHyXFHTU/6l5EA+zU3/aLzkHGfi2gEA3Ai6CiJrMth+tDiQ9?=
 =?us-ascii?Q?VmDgPwZCAsBp3umToFZ1VXa13BaH2sVzj4E9RUEJLJgccaZG6pwACqLVkIiK?=
 =?us-ascii?Q?ZFKhniJ94C2t+ibMYgU3QGFciYOqdHOAjYaymCBJAb2rx/yF/uURgILj2gIs?=
 =?us-ascii?Q?tw7O9FNn/1NanZCrC7slyGPh6RgQCB98AnXIMUqDrnSSWcxB5/3pNF2fOtaG?=
 =?us-ascii?Q?rmZNrL3BYcVKL6uQAfy3AtV6v/hiFl8/SPGaBHRzUGy5rg+PK4OZY0yLwK+Q?=
 =?us-ascii?Q?qJ5JxzNh+pLNfLMV2tdU20wBiCmK2Jv7SO2G+MrQIcyfYz6+c4NHAX1XzTdl?=
 =?us-ascii?Q?i6W7dmiIRWsjTg5/i0668eapt+qEJUgVpWhAMEiQ4K8/KHhVOp9lm0mfv420?=
 =?us-ascii?Q?OFQhe3b8EJmB2dy3n5P/TMgvrsDzOsd4XwFPm3ZIEjCwJh05r+g88ITWlF+O?=
 =?us-ascii?Q?Q7w+LdSu1kLM6xTZaQwKR1oeJul6oEopIZ6z1q03qBHKukvFOGZE6pWdDMeS?=
 =?us-ascii?Q?vM3FxIvGH6j3ZEq8hle2C99un9anQk5SuH5W+6HQJDdKY/ujkzgtA2k6mzo/?=
 =?us-ascii?Q?aCGqwaBUsuC3QWe9nbzj15PblOCtwQd7iW9B/3Xe7EB8p7bx0Zchixb9fzo9?=
 =?us-ascii?Q?JTz1SM5tIIkb1tl1SYAfpNixPTI/BGm+kvQVHeju7WekzDNLYaL+laR8Q8Di?=
 =?us-ascii?Q?w9GkHe+B2qJoTEzoZWPrAQRi7NrmbGVES2tE1+5QDlhZSv1Sav0AJxI847Uh?=
 =?us-ascii?Q?sT9L5VsqV7nkO+1+65ZHJAr5J0pDgBh+CrPE9L8g8ev7NgZjRoTYd8dMGMXr?=
 =?us-ascii?Q?5yDApJN9l+xO7++aGHMP8Fb+JDLOpYXEoRxOYv4+6TJpjo/6YvTn1mBM51YR?=
 =?us-ascii?Q?uN08bhOeqYf24a+xlMJoP9wKTmkezu3rYHKRA38ZZ5MKwHlL5Az29klBt4lO?=
 =?us-ascii?Q?jJ07NQKnUMjHFj0gAUbcue+je38=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa472537-eb0c-4e30-1565-08d9fd8f0852
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:28:21.2320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GD9G3W6kc6seRmCqCqTieuAuVu9g4Cljei53sNaC+NPD49P0XjZVVwIbhvyPnlfpW/c3acHCJuB8YX4+RhGlrHBha4arQ1FMRrDCUEv4OIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4812
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040013
X-Proofpoint-GUID: aktv8-AXqrKWni5aS_1zS3sqZ1t5fuF_
X-Proofpoint-ORIG-GUID: aktv8-AXqrKWni5aS_1zS3sqZ1t5fuF_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

>> +	vpd_len = min(vpd_len, buf_len);
>>   - found:
>> -	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
>> +retry_pg:
>> +	/*
>> +	 * Fetch the actual page. Since the appropriate size was reported
>> +	 * by the device it is now safe to ask for something bigger.
>> +	 */
>> +	memset(buf, 0, buf_len);
>> +	result = scsi_vpd_inquiry(sdev, buf, page, vpd_len);
>>   	if (result < 0)
>> -		goto fail;
>> +		return -EINVAL;
>> +	else if (result > vpd_len) {
>> +		dev_warn_once(&sdev->sdev_gendev,
>> +			      "%s: VPD page 0x%02x result %d > %d bytes\n",
>> +			      __func__, page, result, vpd_len);
>> +		vpd_len = min(result, buf_len);
>> +		goto retry_pg;
>> +	}
>
> Will an endless loop be triggered if the VPD page length is larger
> than 'buf_len'?

Ah, transplant thinko from scsi_get_vpd_buf() which reallocates the
buffer on mismatch. Will fix.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
