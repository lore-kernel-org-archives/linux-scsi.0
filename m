Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8B5C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 18:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344166AbiFMSlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 14:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbiFMSk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 14:40:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D4359306
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 08:27:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DFGsPH028698;
        Mon, 13 Jun 2022 15:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PI2RJYQ2zLX7K2xyzD0Woc8oTNyUrksks0rKWto7qew=;
 b=HTxe/kbpa5IGuIBKef+ANcCYBU3N6r2IGtZ2f4H3anwFLIJ46w0y1AA1FiXod06Ha0cR
 w+gn7yWTNPlYzyKPWSEkrM03dbFWHw5KkIx5TO+XX8dR9rtNANJdupROwW0dcPZvzagK
 Fz1xvcnTNslR8vovv4O3od3ReNJsgjHr9LI77lQJh3eyrnBlxxIBrEpYI5e5CcFOYM4/
 X1Heh5gxviXfSRyRHKo710ypkhRTfMYk/gK8aWX7RO035QoLiflXJK8Vf8iLDZn3c++F
 /GFD31Yi9bnOVB3cco4NngEQE8Oz9Lv2gKcfREUel5ViHFhcObzWRb8bkB1e7yE2+qy5 ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn0bfwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 15:26:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25DFFXs1020547;
        Mon, 13 Jun 2022 15:26:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gp7k30spk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 15:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diXA06+8EldcJdRCnekd/BL6bEi0NEZ97M9RrYiqO/9SXYt2JwEhXYWRIK3iGRDrm5xik6uOYSvS3se3LKdZAeuVeOr68L0U5Wg5qEulnbolLj1Ydp2AXCX70yBaFyLIaVtDrPidE1mda684H07NsCE2d+KHKjagHDSReU9cNuYgfitFVJCQipXhONwWYsnBX7byhL+Z1kM6gRYdb2o/kbtI2Sjo++N+lj/HbKPvH5gS2MhzhF7oCjMHbTLBCyhcqvc4EBZ6smd0I6mrCh19gSoBPmaH5SLQKCpOdpBgvw7h1BQbLVq4Pb7nyGzOvIEhXtkxsNpycfDCiEYEGasWWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PI2RJYQ2zLX7K2xyzD0Woc8oTNyUrksks0rKWto7qew=;
 b=NyD20NrZLdR6rrpfOvd84eOVIEjO97hrmy+WlPOVEyMzkg7WM4ekpVHZ7ybSLhcG4J4alHq+/TyWs/arFQZA2LDyuWfy8oQ61na0Bamp8itVROnkd4yy1dssO6DvphJA2wevtfwaqayQ3Nk+cwos+TgL32zvzTtwKVCE1NQIUGz/38IMg40/cLJcOnwxXZbC/9K4L353Uq8/TITIfjk94ig5wJLeORzLopNfjhaUhiDOYrx7NiD0VOmufBhuiwKlpTtAqhKqPNeqMiaurd9XAnXDm2XfL1ecrVxyD8SkW2lIdCTBWenEWEJLhi3zWEKvNIOQ7L7vP9GberOglg57KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI2RJYQ2zLX7K2xyzD0Woc8oTNyUrksks0rKWto7qew=;
 b=DsElE2BpNhiqIlOjALbMiL4XGoAfr68oNA98rGvgT94pL6JgPdzIHbuChWiVbJ633GjgiILlE+IsGbL/1+zHS7l/HV9TptWgWZyNuxiFzdnMGnZlw8j7b/XGDJjS6sHumMJm/MObCwqIGyRCnBNSPbTX1rjWB9HkLBqZmkW0xyw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB3988.namprd10.prod.outlook.com (2603:10b6:a03:1b1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Mon, 13 Jun
 2022 15:17:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Mon, 13 Jun 2022
 15:17:48 +0000
Message-ID: <9abf7293-9159-305f-509f-2860a6d815f3@oracle.com>
Date:   Mon, 13 Jun 2022 10:17:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: iscsi: Exclude zero from the endpoint ID range
Content-Language: en-US
To:     Sergey Gorenko <sergeygo@nvidia.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        Varun Prakash <varun@chelsio.com>, vinoth.r@chelsio.com
Cc:     linux-scsi@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>
References: <20220613123854.55073-1-sergeygo@nvidia.com>
From:   michael.christie@oracle.com
In-Reply-To: <20220613123854.55073-1-sergeygo@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0431.namprd03.prod.outlook.com
 (2603:10b6:610:10e::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7567bc93-0391-4314-9c37-08da4d4fe00d
X-MS-TrafficTypeDiagnostic: BY5PR10MB3988:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB39884871801BBB2E353D255DF1AB9@BY5PR10MB3988.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfxaHS57iz8XDDNl3a+jbaBzbQ8nRphgx3NYIdVE6ejxI6hIKT0+nflP6fH6NgxBXZFt+ojfcZ9ypHV8xGFYVk9kn52Rj7RtcrSwTjr6rSamy5/PbI9v5trLMj3I0JPil6iULK4FT2ns7vTi9nvdWu1qkQO2I3WRGjnqRGPp4urSDvR7mLbiPoJ4DrfRB1ZyLzbbDQE51fxLNS2uSK2a/Ajdnz9XcgjP0NIBkoSomaMcJ0vfZUmk/umb28o+3W9y4ADx0OS7lJTeC4dCpJc4rxxe1PPURx0av+hDQMmAlQsopk56pWe/tLxEFx/JkRphdfIhmyGpM93JAVRH71nhYdl/1mwEzz3dC6d2xm8VLsT5XGJmB8e7bQu5ArzN8+kzLruYUEuTv0/J6Ymb0ztssHch5aUSwGWSTJ8XmIhZE17i0XY07uXRa5uRf6KiCNjKrZ9an4shMck2FgCsxXns/CbYW7rjo7MpygkaXYUdQ7pCXU+X8KPkbeSnJHLWbA8IfWSW4XrK9b5TaIEb7/pobbAswy3/QKgl0mpkDPzdytV/6mKnjjJPHyycwZox+DeqKN0/IWq4SiAuSfXgzm8j0b0JtlqBaqSO6jSsKu7bhdl1TfqJmZ1Zn/eGrsGm1ON6DbD5Tb4JM+EC/xN6nzySi3GOyrBwNDwTNvYgWDyXXsp0uPPRTsPiDUgB7pJfS4fMZ+ZMt++Qj2U0JOH079m6u1kTV88gno6gl61hiBVbhyCasKeQ6FLkrGaT+UGVWurfx+dcn+I/L7Bhc788Am2IdRDpRDKwEE/am9jsW+qUupU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(9686003)(26005)(6512007)(2906002)(6506007)(53546011)(38100700002)(186003)(83380400001)(2616005)(5660300002)(66556008)(66476007)(66946007)(8676002)(508600001)(316002)(6486002)(8936002)(966005)(36756003)(86362001)(4326008)(31686004)(110136005)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WW5hUnd0bzlqRURxdzQxbkJrR2gybSt5R2N5bXA4YU8wNCtGSmRDZk5wc0dz?=
 =?utf-8?B?VU42Z1hIaWRYc0J5L1pVMDR2bnZOd0lOSDBuU0pXWVVlaFlkZmVuZ1dSUVVn?=
 =?utf-8?B?d3BhcUVlWi8rNm1QcDl3S0NhaEo4UFFUSEZIa1lXdzBnNFc2WlA0Nmt5bW9S?=
 =?utf-8?B?dFk4OHB0U1ZKUnVZM011emh6dkRSVVB1QmJhdW1kL1REZGtOT2dVNGYyMWJh?=
 =?utf-8?B?Z3N4QmRscm1rRXNEK0drZGE4SWhRak1YbmJFUDFwREJPblpCdG5JSjRnMHRG?=
 =?utf-8?B?dTlqRUQxbWtuK2g3ZXhHOUU5c1FTQXF0QWNFcVhPS3h0a0Erb2tXd3BRYVI1?=
 =?utf-8?B?MEUzMUEwcUl1M2FEcDRhZW1MZnpPb0VPcXJONnZoSkJEOW1NSDlIUlJWc1hZ?=
 =?utf-8?B?dk4yRWt3N0x4ZnpLSHNyaVJFNTF2VHl2QWN6TkNPQ0plQ29rZ21BZ2JDV2VV?=
 =?utf-8?B?QjdTRkhXRlloSWgxaFBsSm1QUUpoVHpjOFpFSlJ4VGJUU2wzT2lMdzg1bkg4?=
 =?utf-8?B?QnlkQ242Sm1lOHV4TXVMeUh5RVd3M1ZEKzFaWkt3WnBkMDAyMDBjNEwxelZT?=
 =?utf-8?B?Y1Q0QTFab0grOC93RVdCRjk4d01tc3pCTjZnK28vRGF6enVmM1kyNkM0cUpN?=
 =?utf-8?B?bVVpSm5RUUs4aVNzdFdHQURVOTc4dGs5R1BzNytSZlI2QXFGYTJSeTNFcWJX?=
 =?utf-8?B?Mk5tQ2cyV1M4K2VPVkFMbnVoUENYWjJIYUNHZDJQRnNxZ3dVRzJEMGk5TlN1?=
 =?utf-8?B?Nk5MYnliM3YwN092TWdwdWpmSUM3SHRCcVNGRTN1LzJGQm9aUGNJT1FiWjR3?=
 =?utf-8?B?eVZzL3A5YzJ6T0V3cjF3RXh1VzJwT2N1dUJseHNnanh6QU1oN0NuL1JNOU1E?=
 =?utf-8?B?bHB6aHM3aEpqa0t6OEVMK0VvamUrcTA0bG5nTzQxQVU5aWpENmpSbzFZN0U3?=
 =?utf-8?B?bkhPQUFsWVh2cHdUSUI0WVZTbXhMRDE1UGhWaWtYYUk2eURnS1JKMXUwWXcw?=
 =?utf-8?B?dVVmc1Z2ZmVZZ25BbHBZU0FQNWNUN2MveEY3dkVLZGh5TUphNzBaSVVZczhu?=
 =?utf-8?B?SGZCM1Z1RFE1ZCt6Z09RV3NSc0o3UUorb1hHNGYzcWtLN1VRMmJOQmR3dmRD?=
 =?utf-8?B?aTM3SE51T1NiKythN2hTL21nRlhNZEVqR2x3UllGTzBpcHB4NERFcHRkTDNH?=
 =?utf-8?B?YmpUS3dFbW5GRWx6aEd4b3hUdEFTSnBhQmdUYmFSRHp6NUZIUHhDMzA5UHVh?=
 =?utf-8?B?Nnp5Y0ROUDIvc2g0QTVOM1FDZ0FreUhxcXp0SnRKbE1TMG9IbW9qcVdoQW54?=
 =?utf-8?B?RkpXdUFKcldVc3dIa0RQcmQ5aXBPcUZyZzRYRnJpL1hRZ1lLeEE5NG5pd1Zz?=
 =?utf-8?B?V0ZWK1EvT2xQL3lXZ2VXQXgrMkkxWDgyT0Nqb0Rnay93cUE1UlFEeTVDQmVy?=
 =?utf-8?B?QVVIbVg1eWQ5Z1BuaHlBdFhmRXVYWWRjdUtQS3FpaFhZL2hrbTIvYkFwb1ov?=
 =?utf-8?B?a0w0WGhCcUhYT0tNNysvMGZpcE8wMmUvNEQvZDF4VVE4NHZ5K3NuSE52NUpt?=
 =?utf-8?B?SGNrb2pyUFpVSGRTc1l6TWhUQlRMSndMeVExc0k3S21BU29oYWNNUFNMeFBV?=
 =?utf-8?B?cUREa1BCVzErSmE5TDNWQ0dYTmhSNDQ1NmtMVFVXSk5lcGxsNzdWTE45WHIv?=
 =?utf-8?B?aGd4dkgyOCtiVFdSMTZVRVA2VTBLbE91Rngxa2pUb0h6WVl5ODNKdnVzUnpn?=
 =?utf-8?B?WExrcDdpNWZSeGoyODNQSE91aDlzdU5pTDEyelRmV2V3TjluZktIanFSQWVw?=
 =?utf-8?B?YWNBTzFPb0E0R25lL1p1WnN0TzFic3VxdXpXZmpWdlV3cjZHK294MU9XeTBE?=
 =?utf-8?B?R2t5K2lrVnhzQlc3WDhKdFl3S28rbDhTeGk0NXl5RExrdWpkeUx1bFZXNDVN?=
 =?utf-8?B?RUlaMFp2czF3dnJJNS9pUGxENzduUDVobGRhVXlLemxDUzczWktnUVVveUM0?=
 =?utf-8?B?bVU3YjFLUnJUbFZ3ckg2ZDZjdVkzMjZTcUl2SWVxZUZFOW0zN096MUhXYVpQ?=
 =?utf-8?B?MUZ5QXQzNFJKTnpqYVdKRlZDTjFrNGNueE5yaCsvL2JWUi9sVkZSNjB1ZDNX?=
 =?utf-8?B?Vm01anNMVGVCaWpia2N3Q3p3cXNnazE1ckRybXVCQkJyaW0zTy9vSjY1YUVF?=
 =?utf-8?B?RGZaeEc4WlNYeFUyV0llalJhWnYweVI1RGx0eEtNdEhub1UxRmNNRUdjRTRD?=
 =?utf-8?B?em5CanE4OUpPWExCWFVjYnM0ekducEJZcldqU1dGYUZDM3kwNElzN2ZUWVJB?=
 =?utf-8?B?UlI1MUlBZUkzaDJCYitnTmczaFVKdWZ1U3MzZ0dGdk54NHZ4NzhSak1XdnZ0?=
 =?utf-8?Q?YxijPSRqLZ8K8q8s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7567bc93-0391-4314-9c37-08da4d4fe00d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 15:17:48.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7Zv2RCykLLOETArtALGcQGJpDo0t7O7dIi/RusFeV1JX+xw714PMGJALfhYftDq0NuVPoUkMpSeUhfxbKFuNG526DiNypkunJBZ1MEy0WQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3988
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-13_06:2022-06-13,2022-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206130069
X-Proofpoint-GUID: FNCXqwIaV-inib0AtAgMYjlxfk46GFiz
X-Proofpoint-ORIG-GUID: FNCXqwIaV-inib0AtAgMYjlxfk46GFiz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/22 7:38 AM, Sergey Gorenko wrote:
> The kernel returns an endpoint ID as r.ep_connect_ret.handle in the
> iscsi_uevent. The iscsid validates a received endpoint ID and treats
> zero as an error. The commit referenced in the fixes line changed the
> endpoint ID range, and zero is always assigned to the first endpoint ID.
> So, the first attempt to create a new iSER connection always fails.
> 
> Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
> Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Sergey Gorenko <sergeygo@nvidia.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 2c0dd64159b0..5d21f07456c6 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -212,7 +212,12 @@ iscsi_create_endpoint(int dd_size)
>  		return NULL;
>  
>  	mutex_lock(&iscsi_ep_idr_mutex);
> -	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
> +
> +	/*
> +	 * First endpoint id should be 1 to comply with user space
> +	 * applications (iscsid).
> +	 */
> +	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
>  	if (id < 0) {
>  		mutex_unlock(&iscsi_ep_idr_mutex);
>  		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",

Varun submitted a similar patch yesterday:

https://lore.kernel.org/all/20220612121901.6897-1-varun@chelsio.com/T/

Your patch is nicer, because it has the comment about userspace. Let's go
with the patch in this email.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
