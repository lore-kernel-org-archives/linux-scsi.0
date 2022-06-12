Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579F5C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jun 2022 17:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiFLREk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jun 2022 13:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiFLREh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2022 13:04:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAEF33A0B
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 10:04:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25C7MsYI025872;
        Sun, 12 Jun 2022 17:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eUMIeDfXvMWNKEj3RXTaFEdGmBwbEqcLzivG0+bp73s=;
 b=W1RSJddgXItXsPhv2Wwim/3+KMg+sxd+Q3bqrZKdLYbvulxC/Pn9G0PBE9ZKph0smDud
 3DMPj7TcA5nFjMnK7LD7rVXsaRUzrTcQzkTy1A7IOXaXBH0WXko5EfOzQa+w/XMlj3be
 BzYK05+eNvGQRaNY2/UjHiozmRDxOu+aoErBAtxxq6iwthtsNxoYWBv5sWiuprSGmsvf
 BoT0ho6A/PukBx8qUCqSCPWPKWnr6+FLveIFAPvXrFeqrhaZBOn3dPw56VcmX5gE4FJe
 cTSMceMDOeoq4jKsskhDEZ1/uyNxke4jEYGfjhVGAbNxIIPBQCsJNNCTL+4Thqvav5Ap bQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2hmmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Jun 2022 17:04:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25CH0DH1010241;
        Sun, 12 Jun 2022 17:04:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg88hj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Jun 2022 17:04:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJN+nWwZtQdf3yVEIu6DlKxLERkq926Aowb3escbbkHbxsbacE52clgp4HLv5+vDqxOcvzVnNjkq4uNv1EHE1Z3E2o3pX/DZ9zbq8aVbt+ohjQF/9Ow10YOLoZK04KLUE0TCqCBjdCXi4Rp4W6BLn4elZIG60tA85Or12pzSSxbq02K4q9t1EAvtI/FRIwYJirU/sXmpB/WDh+J9GQmIEd2KEpBtikXSpMwrfUHKQWnsFntvaaVi02ZxkZpsFl7ybkpdxryhVTBZE2yHMA/xt9HvfW1Ky+xQdDe6QXmiLJT1rj+/7jkXnjSQwzBCVwwZ3zpkB7NpQbqkQXj/D8dzhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUMIeDfXvMWNKEj3RXTaFEdGmBwbEqcLzivG0+bp73s=;
 b=ToaFZgRt36wuImDjzrlCtCD40JgSpQbCHJpWtcF3Dv+enhYspW/dNHyqTT1Sil80rlhVD/Rl4oZsm4LBuB3Y0l2C5HNzScaNu/gwnkNN6JSuF0RvlNw+ffSqD1968xLmSbjKDETH0+Bk2ONO1gLab/Js2vGUdKr283BgOTUxevrzalYpUYKQWeBHnUezNP0WoKPQ+8kooohGuJx7wI0cH21Q3fYGyYYIIY7cGWY1FPG2dcwE0DFHmHrT/BKWayDo4QIIHjH+opZ8lwwUj9Knn/v2vb6jaQoglPZ2S6qKZrEmX0gye7Hv3JhyyJC82tueymnwgZoZwt/WMbqD0EDpjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUMIeDfXvMWNKEj3RXTaFEdGmBwbEqcLzivG0+bp73s=;
 b=jtiA5khJHJbxl69VE0SwxH49kRS1n1q3q4tLt2n9CE/Og+PEiBl+s2uTnCE5X+NRhzU4yl3M+FG0pXgc+PzXJyKr59UocqC1HY+kqtpyuyTGY0yOcpm/1RPJfGMD+KAl4j4bKsJcnkRSQWWMF1ZEDe5QR08TRIRpIMtkfa8mbAM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ1PR10MB5930.namprd10.prod.outlook.com (2603:10b6:a03:48b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Sun, 12 Jun
 2022 17:04:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Sun, 12 Jun 2022
 17:04:27 +0000
Message-ID: <63408769-5e2e-3768-008f-a7d41f8471bd@oracle.com>
Date:   Sun, 12 Jun 2022 12:04:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: iscsi: start endpoint ID allocation from 1
Content-Language: en-US
To:     Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com,
        Nilesh Javali <njavali@marvell.com>
Cc:     linux-scsi@vger.kernel.org, cleech@redhat.com, lduncan@suse.com,
        vinoth.r@chelsio.com
References: <20220612121901.6897-1-varun@chelsio.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220612121901.6897-1-varun@chelsio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:3:ac::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8280f207-29a5-4dfb-1e23-08da4c959b91
X-MS-TrafficTypeDiagnostic: SJ1PR10MB5930:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR10MB59308916C33B99D00D071FF9F1A89@SJ1PR10MB5930.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4QrLOaVFfd1zMLFzPPoNKhoUrtcYA/dLFA3d6PA7zN6Z/+iGGTe0k3Ow65pZpGkwim+ntMU1Mauz5tWwYEpGTywlBej9SH0r5e0OFmgR+4rYXBcvh2ifntMjt2pKbF3pJQUxJW/lYWilUY5QqmJVI7RvWQLOWLV6mhgo9dRPdAcsSm7TCzvtuHqbxpnm/euCDhGRxkpvC468WyEVKNuX9eqPyyEjUaYZo9wC/QADmtbpqUdHrfCyYCqGA2gxlL7seCQiQFIREVNbDg99qQZ/5uuPBwGjGTpLz5jb92W4jH096scJoFx0VHgFaFvlZ7s2MdZo78F6q0Buj7hsw+FrG9iRi6qHTDYjzX8Xe9yIhiNXsSvUaz+xXmYaN6hDzw+7SlFJ7OspcGB/d/vlRVfiTSLhv00p39n6ukxt8zxx0zJWLsbMyRwRdUETpVczH4FjkjUgfZzRCilRq2jcVPFbS6ERl6zcW6AKFhgLkk3JN8xiLvPJBpLUzFsI5NulSvPd17U4cGdGm6H1q10a6O2HQEVmVVOOq0WTFq/grC3XPk9QOmoHV7Ss6tU6hoOzFAAfyBkltbWZkBiXxxCz9rY1LlPlUC+Buzft9MXLTCvlPhtkHW6CwGwgjF5QlpFJjuAPOeU0DM8hqj/H0wrhBDB3g9dyeh7qSqdw3VMLjAQh6EMP9m6tkIc0rjQ/fXulBl+REeVQ5gykrNBPlR8tYkiR/X+qYZfB7BdFinQTdwOBsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(66476007)(2616005)(4326008)(8676002)(8936002)(5660300002)(66946007)(66556008)(2906002)(186003)(316002)(31696002)(110136005)(38100700002)(6512007)(53546011)(86362001)(6506007)(26005)(31686004)(36756003)(508600001)(6486002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YyszNVp1WHpNaitWZExVaEhWRXpCTy9VcHZ2VUtGc3JuM2Z2YjlFdnFKb3ZT?=
 =?utf-8?B?b20xaWlYRVFIckNPblpGSXM1enlhcTc3VlcydXdiNmpNZ1d3UGZXNVc2SVZU?=
 =?utf-8?B?QzI5UjFuVWFHVjlzYjBQeFB2dnZIWFA0V2VNMEdXSkZTME9JK1lyWG45N1l4?=
 =?utf-8?B?SWxMU1NURGN2R0JoSThaWVlyZ042bmQwSlFvYkR4TG1Ca0pJNDRTUnd1L2FH?=
 =?utf-8?B?KzVYOXlUc094QVdRN1JQRWNQU3VsMWV0Qm80UllPYUZLMDNESkxnSG9mRENV?=
 =?utf-8?B?aVd6WUtoRTVBMmhRWUpCVERHSkpYdnViZWl1Zit2RU5NM0FvUjdOTTEzWnA4?=
 =?utf-8?B?d3VxNjduRUpqUERzZ2hYa1FtRE5ZM1d6MzFNSWVMcXV4eU54dEQ1eWVUZFZy?=
 =?utf-8?B?d1JaczBheFg0R0JmRzY2MmpiczRReXF0ZmdRV1lFWUJxWnFld3Y3OU00bzRF?=
 =?utf-8?B?bHZ6ZmFVbDBjYmw3dWQ2OVlJaENtVjcyK1VZZWYrcWJpRDljZGlXMGd5Ym5S?=
 =?utf-8?B?VlIwWjl3V3dZM1puMHdrMFd4YU9vaEFoWjMyRHR3a291aGtIem0yazNvenZF?=
 =?utf-8?B?RTFOQlVrcTNPVldpKzJzcnliOEZHemE2UmZ5eEFWZk1PZ1dNREFGeWxhbDZy?=
 =?utf-8?B?bDBpN1FzV1pMRmxHRFpMZDVhc0R3QkluNHp4Z2R5QjJjWVhIUURXS3RkdjFl?=
 =?utf-8?B?VDNrQlVXdEJmQmV3cWhETVFsVTh2c3NpbkZ6MEJxZytQZGQxaXZXYVVGSGI3?=
 =?utf-8?B?UDdnRERabEoxNHhVVWlyNlRqNEkwbFppUTIyNnFLUWlmRUoxdjliMFAyeVNo?=
 =?utf-8?B?YnZtV3ZRbTd5KzRqU0kwMkNpWGhKMVdlTVRLckhKSG0wTkhMUnJJZURUOEFt?=
 =?utf-8?B?YllMckpaQzRrNmFXVmxydWNMYlpubWF6NndCRFdnczhyZVV0OG9IVmFBQ0hm?=
 =?utf-8?B?MUU3U25MWE1EbnN3YnIyb0dZNElVVXhXbE5ERzhScm1KdGhwb255Vm1VMVJk?=
 =?utf-8?B?RkNuQUltQ3ZjM0M5aGJTUCtGMDJVSG5wSnplUUwwQnpLTnIzQlBGQ2dZZ2Ew?=
 =?utf-8?B?ZkZGM2tvQU9tbEhrcUdjVmJPekcycWNseFlVSXdOOXVvNTdSb1A0dGFrY29N?=
 =?utf-8?B?VG9FU29XV0h1MWRTU2lUOG03UmZkSFdqUWJLZWNlZnFUVWZaSTl1bW9NSVJy?=
 =?utf-8?B?VVlhRm83V3BYRjFQWnh4MytZdVdTYWRJUGhYYklVTVcwcUkvWGpiY3VWMkhC?=
 =?utf-8?B?c2pHakgxVyswV3o3N2JTWXlRU0tTVHh1bkdrd3h3YXllbnpzQzlVSUViTTUw?=
 =?utf-8?B?QVo3L0lZUmcyR1BHK0k5a2ZiN3BENGxheThRMmh4Q0xPSXpjOThtVE91anBw?=
 =?utf-8?B?Nk5GbFZ0c2Z1NkxFMVhlY3BrNmZIV2VVK2RuNVNIR1N2NjdWaHA4WFhtQ1B5?=
 =?utf-8?B?Zm9vT1FBcmJZdWoxbTh2a2NhVktwT20wRGFZa2w2amluTXp2U0dGYVlIMGNu?=
 =?utf-8?B?U21aKzBsK3B2MmJ4dVdMOE9pNnJUdjlMb2lKV0c3VXNEY2FYUzFlZ1BMZEh5?=
 =?utf-8?B?WUxSei9RY1RsUEpZV2dJWWtLNGx5R082RldVRzV5R0ZNamwwVGQwOUwyMHRp?=
 =?utf-8?B?UzJTMldrSzI3UW5WQ3FCZWFiRmtHamgrbCs4cEtJRTZWbElTTjN2T05ETXJh?=
 =?utf-8?B?bVJHcDl0WlczbzVxU3ZaU3ZhTkNpblhMM3AwNVgwbnBjK3lQYTB1L210RkNP?=
 =?utf-8?B?OEV5M0lWdjd6dHMvbDU4WGwxRU5KTEovd25FTTJDWUg1amFOK3hsbEdvbTdV?=
 =?utf-8?B?Vm9TenFoR2loSEpKNFBJa1kvRy9UQWlNZlE5aFFNWVBiMlNRZ0J2TThESVhP?=
 =?utf-8?B?blZGMU1ncWZUcWcrczJKL2JGYVgwVTMvMFFsNTJhcEZXRkpYNC9ERHNwSWpX?=
 =?utf-8?B?MUZnQkxxMUxLYlhldExDT3RONVU3M1N0OFNVVWhuY2JqeUQreW5zaEdCUWtN?=
 =?utf-8?B?YUxOSFJtLzQ4MmRqSzZjYk81Wi8yS3ppN3grMU9oMngxcHRzY3B1a0xsejN0?=
 =?utf-8?B?cXZSbnB2amlrQnBVVnZpWnh5dDJBRmU0T1lkQ0xaczdQWmpJM0p6S1NGWFZK?=
 =?utf-8?B?bGtBbllNVmdjcUtRWHRUMTRPQWRRR1ZGcEsyZVhuclN3VC9ub1RCU25tRWVj?=
 =?utf-8?B?LzdTTzYxYVRYNTgzNzgxekxFV1J3dDlMR1cxdTRncHl1UUVyNHM1eHFwcExP?=
 =?utf-8?B?Y2QxR0oxMU5MbzZHakkyVWxraEc2cFgxemV1NTJNV3ZVcmM1SXYwa3k3WVZJ?=
 =?utf-8?B?REQrdFV3ajFGYnlqa0hyRk1LZW96cWs2ZU9oaTZpMSt3N3N2Q3hla3BoQ3Nq?=
 =?utf-8?Q?v7M/UUKMFWfuV+ok=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8280f207-29a5-4dfb-1e23-08da4c959b91
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2022 17:04:27.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuAqiCHktiEmsmnlnb46ZcTfY4MhWBjVBE4gtPRCfupGV99dvHQTaBmLxd0B1sTLMmqhaGeGu7vW/LbZGdkyvDM0VFnArA2beqzEkuPMPmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5930
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-12_07:2022-06-09,2022-06-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206120084
X-Proofpoint-GUID: JZKWxwLQ2e_Z7AmpcAMoNn4kHe-K0sKr
X-Proofpoint-ORIG-GUID: JZKWxwLQ2e_Z7AmpcAMoNn4kHe-K0sKr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/22 7:19 AM, Varun Prakash wrote:
> ktransport_ep_connect() (defined in open-iscsi/usr/netlink.c)
> returns -EIO if endpoint ID is 0.
> 
> int
> ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
> {
> 	...
> 	rc = __kipc_call(iov, 2);
> 	if (rc < 0)
> 		return rc;
> 
> 	if (!ev->r.ep_connect_ret.handle)
> 		return -EIO;
> 
> 	conn->transport_ep_handle = ev->r.ep_connect_ret.handle;
> 	...
> }
> 
> Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
> Signed-off-by: Varun Prakash <varun@chelsio.com>

Thanks.

Ccing Nilesh because qedi was hitting this. I had just sent him a patch for
this with some other patches.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
