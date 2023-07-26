Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D365EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 01:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjGZBYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjGZBYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 21:24:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544C6212D
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 18:24:29 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJITZx025744;
        Wed, 26 Jul 2023 01:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=/VhQ7Xm/TRig0ZzblkSMzVYg6X6ASj7L1mVwNMSXqdE=;
 b=gsIS8JeNNmHx0zYNRuxO2prRGG0US0V6nqwWE34hk2Jz2qaIk8iIiZ+IrmcvaHCGSviO
 HkCdVGPRpcssyj1qcruyfeyk3TRRl6F/cdBYTH5zV+pCfBiW2oOw+K3prD2Z0FzaYyNs
 AenrwHtL6dBdAuTAbwDUPb/dU2Y5tWAyIeseRRma2PfbLQeeXiJUBTebLptu9pvDMOOf
 0qOyh2QZXnuCl+UeWtZAUK8gi7ahJFqaCVhU91/Da2prGR99leQW+nUMV/L84qiaZR9V
 fEJw2AGhoXh/BlLp1ryPRS+rOUZdCvi2tOEReBAnHoxRbxjvy3AMwVHZYnzt6EqQBvCA nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d6esr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 01:24:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0UFFx029647;
        Wed, 26 Jul 2023 01:24:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5hx4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 01:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWjUgxm0YgtozK4n2aep2uAXaONm8wAxrcrVpO7bfDdRdUgzVLN7MhYG5ElJpQ5xwMyUbAPiayBOKhMEwe39gKXegkjY1Zw/0eJ/6stnTxqqJ9BgiwzYHrj+rf7cAzR0CxfEU9FQM+pBGDxJ2kL6kscyWXXlOInRBEX3W83zol+WATZKxEfO/xrDM6dkVRKWR9I8/7VouZClVrGKTK+JR/UbvG/gWH9VhQz9hrF9Yt2fi7M/b4wYeiqCxXE2hPixLg0vwcoX0HT9gmknN2zu8bsEakYU3OmyXIFbDsWajNj0sbkP5w8HuWqn4kwSHdYMraptoVe8Bt/3TeU/aRqFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VhQ7Xm/TRig0ZzblkSMzVYg6X6ASj7L1mVwNMSXqdE=;
 b=jB1rrcT7iwXWpCKr45hs09ghFq3wv2MnutRWiDWGNAOxtyNzdfR+SftdoE+AG5vgP5aL+W4gFKXtYKcRxFfqsTnRwHLkZu7KrLyus486yIBsfa7CRCB4V/+PFx2pr0Yt2ZKm3Y9zIiRHkOVioZbgC0dYV0lKKvQaBbgwYL8nKDlPl0d/qJcxZDexbVRolwsQh58SIbFS+uF7/8iBcqPyCI4TyyOG+N6EdDcqpcY6KJ2Y9lM66gbrttl2wdz3nlYxcrLaJJfQhmDTpA0V1iQIMJ9tsjued6cKWhIUcO7ouf4p/s7XR5aWCbWdjhv/8CwTiYhqHiCpfnkA2ymVeIi8+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VhQ7Xm/TRig0ZzblkSMzVYg6X6ASj7L1mVwNMSXqdE=;
 b=N0CbFiV7z4FeznBUcCbwomFY8AnlkyFrSPqjs3vghrUOS5AlaF1q2XQ88eBp2SadF4M3NOAZ40fa02k2v9tGRpmI0yQOK10wdk49QbB3sJ4SFgkqy8wnbjII+OrPcuuINVJ8VGtTRlmYSkFgHgN813xknx+U2oNkLSxGv6RT5v8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 01:24:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012%4]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 01:24:21 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v1 4/6] mpi3mr: WriteSame implementation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pm4fzdmv.fsf@ca-mkp.ca.oracle.com>
References: <20230724132303.19470-1-ranjan.kumar@broadcom.com>
        <20230724132303.19470-5-ranjan.kumar@broadcom.com>
Date:   Tue, 25 Jul 2023 21:24:18 -0400
In-Reply-To: <20230724132303.19470-5-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Mon, 24 Jul 2023 18:53:01 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: cb79d3a6-884d-4a55-9240-08db8d770a34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkX8W5lsvDNvVG8KK0JWk1Bui5drvgqzvqNXWKwOwg1tSJjT7Ar3z2X+TRx+dZvxujzcpqthR6WBA8cO38cgxGry9sKkhAOhAsSzmF4xEA+Lsiej1rmWeECvvpuNI+Tk5JrHwPVMrsbHRitGeMkquljoXuTnYfwu5RNMotKA7wFJXnnoj36pYb1c22NNmVGGViFnv2Zk71Qphtm9SNp34M5c7VQgTiRYYZ0tHSYFG0un6xALa9bBugySqysnN45ukFO2Ya0qFESuntZMktBJkL+O5KBrInetXfRUL25rc+2psBwB2Vx014nzWRP0L8tEtf1+IunXMqyiJAHGqNNz0jQXt7htrQ4TlaJlEOSOGpmn/x8wmK4Is4pNr32eqBIZ6ZGVW4uuJkmxC3WY98MwGEde08c8GsI5YIr64uRvWfY5R1Mx/N3VOBpedcMrpci8Jo+efexFO1m4xzS4qiiUvvY/AlsEK6JYV8Ii2WDyjs/SuE7/rOgtFk1K80PDAM6nQc9N20y7dyJyINlx4Ns38k6LBFwBPp88u6KrDvI0ilbYdEiRVehpSUdWLEdNE8uyFzXjDh4ZoQpTIHEJI15MVHVkU/xsfAoNydaSpaLSTRE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199021)(66946007)(66556008)(66476007)(6486002)(36916002)(83380400001)(86362001)(38100700002)(6666004)(6506007)(26005)(186003)(478600001)(6512007)(5660300002)(41300700001)(316002)(4326008)(2906002)(6916009)(8676002)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+j3N92wkSaJia0wBj9d5P2clTuhXgdlttjCE8hN/SYIYDjUemcRvzLUw78jO?=
 =?us-ascii?Q?ULltT5R6evVdh2JMb2HvgJcoLajPxvv2cx/j9IJ4HlCYWmovkbp8xeFQR5r0?=
 =?us-ascii?Q?VoK5jSfsYW4VkqXF5BcBgfKe0gp+2f8+1Muiy/LHQQ16FPwxMfgvibBmzCU/?=
 =?us-ascii?Q?d/wSlszQKGYzGppgeQzzkgEv7INifFHJJlGXrUXd7MpYGoEzOrzHEgW6ipf6?=
 =?us-ascii?Q?ToOG5G8vhHkwYpT86o+LpK5WOUW9ZxO/X5FzK9V9hlARE5+fAL8FOUByBxw6?=
 =?us-ascii?Q?KWvKTDD281FYHBff9Mftf2b2sxZppHS71GFZOBYyMbbGjJ15gcniVV8GzZLA?=
 =?us-ascii?Q?s9FYY3mkfgwjrn3VvAzIanYNZJ6jbE+vUy8kGLRWi87kymMwVjxOeuwxIssh?=
 =?us-ascii?Q?IMCXgH8Pl9UKqCozJWFWLExwekyujGIpRkV9Rt0ShFDFonmOFAkB9Eh6oCuC?=
 =?us-ascii?Q?xdgVZwR4ts9jJGrDz7pWVgOSbMpoLvNLpP1Eew7icAmZ8anLiyfaJenLA93J?=
 =?us-ascii?Q?j4zEI9PPytIdDSuS9jCbYiS7jrU7Q+qA/8dD67FxnlWbDGUonieV/jqrndnb?=
 =?us-ascii?Q?EssqLstr1XOdjPRQgAWsegBhRi+5m/MG+evAwjIi2tSUi4h316xxlK7H64DP?=
 =?us-ascii?Q?VUXsyw5sKN5IelpEITiDNQUq8wPazdUKf0aosdfsyJ08iYng4zedf2Hdta/M?=
 =?us-ascii?Q?JWzrbDZX1HkDqxAkI1opYgV473iSOj2bpmMO+nnba56uXyh7wQTBb3FB/ECB?=
 =?us-ascii?Q?uBI22SdpCr5Plekg+a78CGiQdz+DuDPEENxfRgIoT3rkqfbWzE6tw2qEFnGt?=
 =?us-ascii?Q?Z6+ZW1+qEn1o+SvB75KLDaKosCZ9xyxaA4mmCRNs8rCDo40HlGf4gKJBZP7F?=
 =?us-ascii?Q?fnsLMSA0OfdD7Z29gGbSVzSxfPaKdXZoYMM9v7l+sHe9Rm1hjhe6tyc6Tr++?=
 =?us-ascii?Q?vH9QqK23tI9HMWUzNt3aV4SAd4zpY5lDeHhEDaJ4mX0DsAg2EaR4dVFQvc70?=
 =?us-ascii?Q?LaaMzthIuJJxDsAzjUndDwkGu9FmfpFlx1p9j3o/cAJR1iKtAUNwWGMzn/pq?=
 =?us-ascii?Q?KmYPcUiF7rDIyTZtLTJ9vC0P3k17xmSi8v5BALl77X3XGNyy6v/BS4bE4r+U?=
 =?us-ascii?Q?ucHva6esere5gbVrPAHqRkZNFVIGx8ZzKPs4I2qgdGVfrznSBvNnHmBTuSxR?=
 =?us-ascii?Q?zAfScxsju9NaDnwlzsDotrQPac1e+hppuuFo5iLMN32sttxf6MjrU7HiMJjV?=
 =?us-ascii?Q?PzdmA1hFt7Q7QPs34wD+TnMG69nIAFa5ng6bkFTmUtSfgYXDrnWRHmogj0lc?=
 =?us-ascii?Q?vWYLxQH64QgnNPd0zSrAWUg406NDngVWJluhSx7A8Owk0vbeEa6ViyZTYO8u?=
 =?us-ascii?Q?A3aB5mUHjADQkTVziycLroXqbqMdsCi2qz/GwHupd8WVY6Mhvr5POQYLkUxU?=
 =?us-ascii?Q?CtFl4U3QRzbd3a7J03ck8f0gj4nTuji85IO4JdfOyltaQB7x2scfchtO1Pcg?=
 =?us-ascii?Q?DyHIxK42Ullr6r9EPVoeSikAWp/DH4EY+7/zHqTEdOS8nSmbuP4pWGHKH9+g?=
 =?us-ascii?Q?kEQnuELn1xbu6dSkdvrHd5ds0JW9gSvBRnCt1mBXDUpg4lqs8HQa4AOJA81z?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zFXiu1XOJvsYm2M5UDuQpaW193ZXayetSQu3SZ7vp5B8h1GChbSf9xKRDYkETOqqBvXgvlLUjB+bRlNJUyg/XJa5fsGs+t/POSPvguJjW3hUwvg3/mxn+8IdnmsTMPdeNmtZxmYCe2yWDO2PTJ8VL0V6nd3fiMt5QjfDVfl1VgGAN0gO+kyWzAZv3LnJDMCSAoNBkEPk4EfnseMbtrj8OFQT66zLxKOvqBqW6+uIAuKAwUYB0aZtU6Zkqa0YnXG47ZYSnP2ViFXsmp2S0hNK/JOhtI7C05Clj1m1rYzPs4FRPIdsH8ZXyDsLJzfXjRfzmD+h/53BZiAb+QUrZD46rC6T5Wjte2shvsN2VZCz234RlOr4Y7EvJB+Q097ljHr0Vhve49EknmZ+ARLlkmbUjXcfXmbIn35WldfKvxNHNVlh3WxT3Tfb9kLg+wLQYMALn4sqd4ISFuc9XPaehawUqQmbbJ4+j3rCc/J9/3D6N5m9/haoqikUQursbzN493pz9VKewBmb6Z5lDAl0vJbHRmYhmFecuXQD/ZmgdL9a8WJZjl4SF3dwM1qhvdQwg43JPIlEGRgXKwoqQc7BeoAn4qCmxUodJDYJIi4bRMsN+0C8zhiBXZXm7nc6wGR2t9tfA2enTX6wRBF4mhAyj9+PHx4cy+dgqd9tXnE1FgA6MuP7nrrwTkNJ3pAhk+WFenchyXHzA3keSnYDz+WO+BWtv/1hl+HMX5VSYesVORSlTLLvNMnGdbBZ0549KdZUeTqIYOziC9ORdIuXxtOH0H0ibJ9oPwfbgsgA6MP94vLF02s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb79d3a6-884d-4a55-9240-08db8d770a34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 01:24:21.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2ln5LbCVoPEIppVhzTRdMki5ugTSoXtm4KO6rhMF9CyYVzwFqYsfqJBKtl5h/ik9o2xDAmpQBp1/xb0crdWSEb8Hh4cuP26LIZRnTw2C3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=811 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260011
X-Proofpoint-ORIG-GUID: XnGFSU7jvyM36fy6_fMbz1Po7r93Y3FD
X-Proofpoint-GUID: XnGFSU7jvyM36fy6_fMbz1Po7r93Y3FD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Ranjan!

I am still unable to parse the indentation:

> @@ -4445,39 +4500,50 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
>  	starget->hostdata = scsi_tgt_priv_data;
>  
>  	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> -
>  	if (starget->channel == mrioc->scsi_device_channel) {
>  		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> -		if (tgt_dev && !tgt_dev->is_hidden)
> -			update_stgt_priv_data = true;
> -		else
> +		if (tgt_dev && !tgt_dev->is_hidden) {

The block starts here                               ^

> +			scsi_tgt_priv_data->starget = starget;
> +			scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
> +			scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
> +			scsi_tgt_priv_data->dev_type = tgt_dev->dev_type;
> +			scsi_tgt_priv_data->tgt_dev = tgt_dev;
> +			tgt_dev->starget = starget;
> +			atomic_set(&scsi_tgt_priv_data->block_io, 0);
> +			retval = 0;
> +		if ((tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_PCIE) &&
> +		    ((tgt_dev->dev_spec.pcie_inf.dev_info &
> +		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
> +		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) &&
> +		    ((tgt_dev->dev_spec.pcie_inf.dev_info &
> +		    MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_MASK) !=
> +		    MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_0))
> +			scsi_tgt_priv_data->dev_nvme_dif = 1;
> +		scsi_tgt_priv_data->io_throttle_enabled = tgt_dev->io_throttle_enabled;
> +		scsi_tgt_priv_data->wslen = tgt_dev->wslen;
> +		if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_VD)
> +			scsi_tgt_priv_data->throttle_group = tgt_dev->dev_spec.vd_inf.tg;
> +		} else

and ends here.  ^

So either everything after "retval = 0" is incorrectly indented or it
belongs in a different scope.

-- 
Martin K. Petersen	Oracle Linux Engineering
