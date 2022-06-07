Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09770C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 15:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344548AbiFGP4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344631AbiFGPz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 11:55:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA122714E
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 08:55:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257F99GW014363;
        Tue, 7 Jun 2022 15:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=b/DoeItMhdXNWjtlFwiAftmT6L8pGEvtmSYr7X4W4pQ=;
 b=Dh/k2k0jtVVldn/e1TiIF75oiNXa19n6ZrL94jTQ053FXYpRzZSKCIwfhMYKKUkpPoOU
 kFrSLzzDVDRcPZI/RwnB/oXU2Hn9WNrVynu+p5SQn2QI0ETPWTuB39Pdgx/u3/DlX7O7
 /FeXOc5vC7KhKwEnJ9TTjgEu/k3qDSvNQjIW6NLXiXXOSgNY/TEZAaQezBUHn/qDoxVO
 FuFGo5f5+2c2y01LQcfjSJMkjOgcdsYwFJsYLwj+qNFhNYLEwe1dKLCcJbrjKfdlVKWf
 opFmq6pOBOKvy4/V5VWgX3nD9iKzG4be0/T9Zl8i47tGCmB3W22EpiZZ5A2Rs2ubKOqF QA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmvf7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 15:55:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 257FjQF5030297;
        Tue, 7 Jun 2022 15:55:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu9tyc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 15:55:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzPgp8w/BYA6fMsQgso/Pi0o2EJ6pcv8tcCzPfR3LuonlpUqKFibujhIfqwes7f+2VzwV42o37cAa9H25Pf+y0p2/l7RBAE9SEOw1k96lXQZePOvoYZ4uk19X+mwtGMQ/Y6yxQx0ybyWHF+AsuvAdKqh5U2TzlQDHooXpIb3BE6c6eK2UnPGAJUCJr62001piaOXFNsXnhIiXfSYIovd4hWqI+NNYdwzsxNkV9TXhp22vHSrqpPLrMm43IB1uASsiPAzzRlg99syAjn1ZxNAMGAYGCMeuRWxgVayfbrt26iWzDB+w5SPBveyYMz7DtXT3KPo1v2mps0S3FQ6RGP9mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/DoeItMhdXNWjtlFwiAftmT6L8pGEvtmSYr7X4W4pQ=;
 b=kf5GgiWqKpXd979Ei5mv+s95syFblQPgvBKep+CGFgNcnbuxE6gWZJwcYlb7d7tzieNwlj6GxSVrnx4NFTSxV7/EQgnYpojo71RGA+7YypxN8NIXXfScmUA3t8C31K24nKHhzFQ3XS8JsmKWuHvjf8x8H2Q1bafKAviU38QCaHY4nCSyS34qx/1HA6/Q94gusrxQHxt/X7tFS5suKDh7eZqPeGobpwBPxoRpMXxI6SYy5Eqf7YcrIxVcqbKld17LYjusdBk3PLFFGzu0D2jJbI4xC+fsBMmRellZeXD3sj3VYzigdf0X6FuY6eCyVoIxwmal9sqcDdgzupGfYjOYDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/DoeItMhdXNWjtlFwiAftmT6L8pGEvtmSYr7X4W4pQ=;
 b=iYF27eQPQoSIuvVSAxSe4lYwpnEBfk15NM8SDkhkS1AhQw9CCNOcDzBC37QKuPy3CLIt7xssMjrswn1FWBmLxAJrAJJh76hOY7ZE+YLUu76ikF1fE4bwyHxRyM72WW30ApTUIR14Qd90wiK+CHzu8SR9Yff1DmlP/8tqdraGaz4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 7 Jun
 2022 15:55:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 15:55:47 +0000
Message-ID: <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
Date:   Tue, 7 Jun 2022 10:55:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux@yadro.com, Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220607131953.11584-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:610:32::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8744ff85-009a-4714-ffb0-08da489e2fff
X-MS-TrafficTypeDiagnostic: BLAPR10MB5169:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB516939793E512EC377FFD784F1A59@BLAPR10MB5169.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ra04KP9nVEWad9iTT0ayyuBLp9BK2pO5n+/RbvZRQKDP4vbe5lnPxX0DxEQ0x5PD5ZbaXHJ+vc5i8PUjBC7pTtEXB3vly5pvwVh8KPm/gsWCKCCP/6t3kQYF5db70SrD1OVL8A9TKX66MvO8s5g0NP3SKTrdU8odrb4pwVQcBOQa9Pq6/4lLeQ8PfqAlSPLOjfYE2at7QU0+YETljy5V2xY4WW8eS7SQZwR7HIcxrhgnWl9MVmBktgp6XceISjiDe2akhqmaNHNvYhxGH37ELKvAKQIC7xBmlNNnwy7bRyUBkJUDkQIYcESRqJZ9Cc64LhGdHeFtxgFRNhk0p6i1iiDjHM2soQM46NPzYUlYan8pQYb78rqK1AaAceIE5dyhREFfqonCZW3EXPZ2FaH+uyU3+BHWnjyVKfJUHxT5gtEs1gsQFM89bVO357/UnYoHDG43dw5C04lEVQAJSImPzWWu0QODvmqB7dKxpF+62Zn9fHMH1MWpv+olKdFEai3t6xRKxaRF0pF0bYMzu1ItjBRAZjZ/dnIK21D38tVPsqLTq5r5Wcc2Q3OHdeY/IIJcyhtRBcBNV2TD0vIjt/rboJ9WdH0rFTgY5QdxPrDVoC0UoA40kpTPMqehjSLMVpDr077bDWLh8RrdCKZZnNBG3eRoZVrKEqRUB1YmTpNBPLYEAAl9B7kJ0fq6iQCn9Q6Lc6AdlSM70RHCVEi7IPEWIJ1W1/dcOmn6rdY7cR5IJuV20LMRNVmPMMuUEZXncQL1mVh+bZomPuWilhouIEdbIlcitmxIOevqgn+j555vRRnH05Afv2X9Ktwv7b+BcjMM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(26005)(5660300002)(8936002)(508600001)(966005)(6506007)(86362001)(31696002)(2616005)(53546011)(6512007)(6486002)(186003)(38100700002)(316002)(8676002)(66556008)(36756003)(4326008)(66476007)(31686004)(66946007)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0o5NmNkTEZkMHhDVFhkaXBMR0JmZkpKOGZFVDFONk9kc0ZLeGRCTVBkdEpz?=
 =?utf-8?B?UGFDc1VjWm1jaFVaZnVLa1pmaFRDWnltUHBQbStraEpXMFc5UGhFVHE4REtl?=
 =?utf-8?B?TGJWS2IvakNVY25pNitXZEYyMFQ1enREK3VPV3hGRzhhYzFzYnNNUHVVaFY0?=
 =?utf-8?B?YWxDaW8vRU5xSzJYWlhvQUs5RjRJS2lxKzRSWTRSSkxHY1lsNCtEY1JPajJs?=
 =?utf-8?B?aXFDNTkxSyt3aCtQZkE3ZEpnZU1BUkwyVUMranBER24xNm5HMnEzcDdyV2N1?=
 =?utf-8?B?TXFGNEMwTzA3WC95c01KQTJReXZ5RkROSytZaFRMWnJuVllWMjlrU05IU2JJ?=
 =?utf-8?B?OFVPUlRyZjkyNkRBN2JzQ2tja3JVREJDSjBWdm4zTEJCckxrdVpCRjYzQWw2?=
 =?utf-8?B?RGFZZmEwUHNjdnZXSTJzaExDUGtjY3AyL1lCdUlWcTV2d0FOMi9tbmZoZ01p?=
 =?utf-8?B?UU01aitqakNuVTBINVBPTU1PZGIwd0dLKzVHSmhMV291SnNnM0pDTzNsRzFh?=
 =?utf-8?B?RUs0Vi9uVHdFaWFSRTZTNzdHN1pEYTlFOElLNlp4QmF4Ny8rZ0M3ZE1nVWsx?=
 =?utf-8?B?VlRrRC9BNHJpU3RvK3Z6MVRFeTZwajZEeEFuQ1kwK2xhY3BNUFlhalR1ald2?=
 =?utf-8?B?UXNnZUpPb0J6bmY0MGtscnNickEyODltd3hNa0prVzd1SUpoSkUya1B6czF6?=
 =?utf-8?B?T2ZHK2wwcGxCYkFUam0zZElFVkxsR0wvL1A5QnVDZHBkYXZvcnJkNXYyb1A0?=
 =?utf-8?B?RWlEL3R1N2JXMUVuODh5NGFHcUdhWFVKWElCRzBRbGFueG80MFoyZTh6L0dj?=
 =?utf-8?B?bk5OL1NsMzIwRTl6SUtDU3luYmdiR05pdnY5YVlEbnVqVmp2TFlpalV5VDh6?=
 =?utf-8?B?TnVUWlhGL3N0MkhQVm13RGhKRzBDRkgzbDR2N2FKTVNqY1B3MVhjaE5td25w?=
 =?utf-8?B?UWJieFhuTVdvdnIzOW1BM3lFMGNac1ROVVJ4emZiSFJHWjVFd29qZnhsRFVT?=
 =?utf-8?B?NngyODIvWlgwUVA1OEpXVlA1bitPQ2RnUTF5WkpSUGQ4ZGltQXRJcnhxN0Fz?=
 =?utf-8?B?dXlqRjU1MmFkallMaU1NTkZUcmNvUStQSlllRE5kdDIya05neUFUSHpvR0lp?=
 =?utf-8?B?dDhHcURwcVlBOFhoOGJnQTUwL2ZVZUN3dnlXa2pHL1JDVDl3bEE0ek5EUXBo?=
 =?utf-8?B?ZHQrSjF3VzNVeEU5cCtKam85d1ZmVzlMQVovYS96TW16S29ib1owS1hPa1I3?=
 =?utf-8?B?YlVTTzZ5Rm8zczMyWHdtRlRFN1N1aWZudlpSTGtvNkg1cFpJeGtlbjFVTHRp?=
 =?utf-8?B?N2ZVbVJ1cmtxU0NFYXVEN053SUFVa2t6aEJFdVplSkZTa0tHV0tEL21GU3dv?=
 =?utf-8?B?TWFSTm50UGd3OHd2QmRxbWR0emdRWDFBT0FEY2dHT1M1dGw5VkwrYXVlaXhD?=
 =?utf-8?B?Y2FYZ0pKWlo1V0Nzb3RRVFlEOWRoMkNFUGRMeCtUT0J1aEtUSTZ3SVo2Ylcr?=
 =?utf-8?B?eXdNRmxvOEx0cXo4NnFRVWpxSnBOTDFMZEp5bDlXUWQ3aTMwRExUVHc2bmhV?=
 =?utf-8?B?b0E5U29LUXR1ZVJZMXN2RkQrMk9rempWa3NVVHJIRHM0VmdoT1ZqODUwek1i?=
 =?utf-8?B?a0czdUoxSi9xS3FIQnJ3UXNhS2twZGRKUVF1R2xEbW04eEt1V1NGMXhObkdy?=
 =?utf-8?B?YkVLcktGZHgwZEZoZVNFSittMUpUYS9CTmdZZ1FSNG9OVTlyZ2dYY1VmeEJo?=
 =?utf-8?B?R0ljdTBES0RwZTRXazlkeHRJSU5Pcy96T1Fac1ZSWnV6NG0ybTBtRHdJaXcw?=
 =?utf-8?B?dkc0cWlaMTlGc2hRMHlMMjN0RFNxTFFKSjQrbEFEeW00V3ZjREoyVlhIWWpu?=
 =?utf-8?B?blN2ajlkT1RJRHpIVE8xSUtybFViaGM5VlhzUkVuZ0FXVldzVFZCaitJQkx3?=
 =?utf-8?B?NzBiTVFPNkwvaEVYN29pbU1aV05OUjBoTGxNYWdFSitMMkRVRDNQL2xBaGVN?=
 =?utf-8?B?c3B4WjByV2JTY0k5bUZxVjJGcmJxeTdVazJDU1c3SHdUcUR0L1pEQU9HVjRL?=
 =?utf-8?B?WUxZei9Eb1FocDk1dm11NTNZZzBNRDBoTDFscCtOYTFXT04vOWdyVTVQNVAv?=
 =?utf-8?B?ZEk1K0s5bnNpZjNQSnFkZGNuZndHS3dpbjRJN1RCZTRCK0h3eFNCRlBEenVQ?=
 =?utf-8?B?VDFZc2d4NkFrV3A1WG9mM2lRbTBPcllVeWE2V3dDWkxKYzE4V0s4Y3d1b1hI?=
 =?utf-8?B?WFVFeHVuV052WXNXK2FxbUlXbUNPVWFQcXg5TDY1cUxoaXo0TmY4TUt5b2Fu?=
 =?utf-8?B?eHZVY3VhTGl3anJyeEVkR05uRnNPV1NxY2xORStZWTArdXRGdDVMaXdZRGdE?=
 =?utf-8?Q?3d99WN6bnGTryDzA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8744ff85-009a-4714-ffb0-08da489e2fff
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 15:55:47.5560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIWiJ2MXjcg48pT6vausklapXzlFS3iWwwkm/z1w4/y9219n3CUC7MQOBdKzSCaKPMj8D59bIylhehuaq5n+2Z/pFlD4PAj8HGB9U4qlupg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_07:2022-06-07,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070064
X-Proofpoint-GUID: Lr4IUr4S6m0_gtZQvkXkqLfFfK750_bb
X-Proofpoint-ORIG-GUID: Lr4IUr4S6m0_gtZQvkXkqLfFfK750_bb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
> In function iscsi_data_xmit (TX worker) there is walking through the
> queue of new SCSI commands that is replenished in parallell. And only
> after that queue got emptied the function will start sending pending
> DataOut PDUs. That lead to DataOut timer time out on target side and
> to connection reinstatment.
> 
> This patch swaps walking through the new commands queue and the pending
> DataOut queue. To make a preference to ongoing commands over new ones.
> 

...

>  		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
> @@ -1594,28 +1616,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		 */
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
> +		if (!list_empty(&conn->requeue))
> +			goto check_requeue;



Hey, I've been posting a similar patch:

https://www.spinics.net/lists/linux-scsi/msg156939.html

A problem I hit is a possible pref regression so I tried to allow
us to start up a burst of cmds in parallel. It's pretty simple where
we allow up to a queue's worth of cmds to start. It doesn't try to
check that all cmds are from the same queue or anything fancy to try
and keep the code simple. Mostly just assuming users might try to bunch
cmds together during submission or they might hit the queue plugging
code.

What do you think?
