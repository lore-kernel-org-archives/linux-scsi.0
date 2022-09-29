Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62170C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 20:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiI2Ue6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 16:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiI2Uez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 16:34:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B71424977;
        Thu, 29 Sep 2022 13:34:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TKTZhU022963;
        Thu, 29 Sep 2022 20:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CEU61tIdStpKj20jbU/zVGfuEkIYsBs62PUCSThqi2A=;
 b=Cah7ZIgIaBlQWek5dFLXWYIGSGN8WzoL7Rue013BHO7nR6qZuSko94MGzYd08QtpFBF3
 qSB/H8Qw7fWEPo1sTCsYoSvsmit4h1xU9Bq9XW7B+uJDK1ALlG32THwBvggohkMLWb4c
 3ZcDar2Hhlipx0MAX+TtBUouicujDyv46HmWOeiN6IWJr/R3T+gO0fYX40d5GxoEeMzu
 xWSmwglmBlguODGr3Uv1GRYInW67ne596jep/9Yn19B8LySsnThV2CEZkR/b8KfCx5a0
 SZMY2yGI0uETJfuaMrH9gEByldQ4rFs4IMe2lz14a0RQJdZl0JrQOdqdMs7xR/4icqyM ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet6gnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 20:34:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TIVME7036958;
        Thu, 29 Sep 2022 20:34:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvh0kxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 20:34:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A75QxOwXsvT7ybvViV3O6JiyA1CuB39cfIDLx0i2VRArOswBn41ZAX5Pq7wwLX7cKIlHGdAmsdIv7cIi0cP/KUzNUxJXwav/gWwLznkQa83b9dZfuifFlZcnkPj0hn5uNLa+ALAlkK4x2H4zylH7x7Sy9QtjYASFw67jLxVEjOmI/57eMpd7W8X0spPku0YpMRuLppcocILM+nkrG27TFaJ63oWaORJkw/I1oUQ7Id1a7wx4JFxrijT2XghKdPbV9/RHazRfXf2tV7WAsVAlOUlfqBP7fJ905kpFc2tyXg84QjyFsV5O+Lv3+olluqxrG1e8iBzc3FdzdQN7sBe3MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEU61tIdStpKj20jbU/zVGfuEkIYsBs62PUCSThqi2A=;
 b=IXD1sitLVqmg33MHiqnhAfxKjxe234JAtO+JvOq1fkw8fTVdqJp0wC8NWB0n7ln1Df0xTFBfDovDh4zD0XjsIDqFUVT9THyP/iEclJmM+zR11GFz1Y+AbVqgv4bRkF1G1rXYDwliaVmZvnVyEGoG6jQitojo8tbq1jOiC8uY6jQ+W8PDMuO4/s2CjUxOSbGO9mFGMwQ5Jb92oBq47mE3zfTNrFW8z06FHy5L7cD7GW5bYDt8UTZV6Zl0yW7h/l9GC+HIFvM0MaGvNSPTU+qX8uD5AzfSj3k8AOMlc0BgLUjtS/+VOC0vPnSYZ21cQA+JI06gFo7JadgtnDxvd4On5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEU61tIdStpKj20jbU/zVGfuEkIYsBs62PUCSThqi2A=;
 b=tb3sCu0HqC+S1iTHBtXg6m+ujd39HIMRxxLF8YAbhqCYD6aPKDQWwwk3CHu1BbcQkx9/pEtl/DaSAt214ZaxejOcR1XKzEdlJYI13zv+iiW+gww5JwC3tD7yK9rp7n8hOa5K+vx/JuDlgG43m7kUxrNvBPrK724MnyOaEU9siqM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ1PR10MB5906.namprd10.prod.outlook.com (2603:10b6:a03:48b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Thu, 29 Sep 2022 20:34:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 20:34:47 +0000
Message-ID: <36ab142d-d79d-01f7-4478-66cbd2909a9f@oracle.com>
Date:   Thu, 29 Sep 2022 15:34:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 0/6] add support of RSOC command
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220906103421.22348-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220906103421.22348-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:610:cc::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ1PR10MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d66256f-8c7d-422c-e368-08daa25a0ca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1jw1Ndbj42YGIoSP2rn7L5fjeRKwx2ZicjUIuJhvcZqWOWJYZEbKBkD0TtoTnpJ7wp3KbH983LJOVc707DPt9SrNyKIkMswpx3DRBcBCvz5uGhgXXiaR610j6gt1hpZ/+NkrB7Hqubr3bOkpQFw6Mu74GoPCBi2j7yzaqsdkffAohHUHGv1bLtACqzF1R3xguXMdMEgcsAcvofnCHPMi7n/A4cid9qPhmF88ejFLAve5rX9Xx9FRxQivxUaEgRBrBkzXiVpgeZY3Tbn4sgLJnua5iXOr1LYJYWhougSsh75xWgcuaO9vOOBO+QvRs6WC4/5d7eFOzeYSh1mP+M7ICAPaELVRYnYPkrqHOtCLMJDhm1/Z94Vd/39rPEQsqGeHPvWhN5zGgAwuqWh7H7JqYEtzqDbHsOQgsNz8odGlJqR+OIhKwQGKJ25/3G3UJjETyr7YuPybjkajPnnWyBOIAveYH63f0VpnMANYjrbXAr8QiuzkkPiq98KTrQQPF52sPruiMUXMGm8qNJA3R1m051i/89+ijr/W7vqkZa6+f/hiGWsdXbz5cIY+zrJpEYm5uz6pBufP+GRRwYF1Dy4LxMnSATFlp4K1gufytvsHEatc22dgXCfnq5j855gmfvAJxqfRFsMxZ5Pnbpj44MXTQcNbqwcvjgWe9XW3g/SJnJI5oStbii05tr1yeu+R2altoJGm4ZxacyOmjaiUhI6Ih89hUljWLwB8nAAYUmBZXXOh0udfrUx2Xqd2lBOrhaRV0lvJ5w6oos2/97/XPXODDr+cMUSoja1wNKcrL1/Sbs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(478600001)(8676002)(66476007)(66556008)(4326008)(316002)(66946007)(110136005)(38100700002)(6486002)(186003)(2616005)(6512007)(6506007)(26005)(53546011)(86362001)(31696002)(83380400001)(31686004)(36756003)(8936002)(4744005)(5660300002)(2906002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjZyUVdtdDhUZGhZeGp4QjVJdWNuMVY4NVpPUjBwZjJBZlhvb3J5aGExMThw?=
 =?utf-8?B?M2N5WXI2Z2VCRzVabEVpUUJ0aTA3emZtaFVlK0dkMjIzZ3VmbmsxT1JDdFlE?=
 =?utf-8?B?Y0VRVEJVWm9SMThyN0xiRjVIOTI1bU83YXg0VCs0ZG8xOWZwNldoT0E1UURW?=
 =?utf-8?B?bG92OVpEWDRaVW9ScUthUmI3WkFkczBNSmNnUFJnRWRZMXlYMnFObTQ5ZlNo?=
 =?utf-8?B?OWZUWVFjd3ZEYzB6cVg4ZkhVbFBuVXNjRXhUamtSaXpsS0QwdCtORldtZDBV?=
 =?utf-8?B?bGFBUjJQNFNTZVNLTXkvOG1ucjAyUWhGWWE5L1hGSlJENm55R3VQbEx0QnRh?=
 =?utf-8?B?UjdDMGM5MkVTNTVreUJZQUtsdkhtNURCZjZaaFF5VVQrTmIrZnZ4TVVCQnlH?=
 =?utf-8?B?UDZ4YW41cEdKelVoOVVtOGN1bmtqTThuZVEvZGxERWdsM05Ib1dDQURQYllN?=
 =?utf-8?B?Rmk1UC9YWTl0VjVJRWFLNnhZMmlkL3g5SVZGOTRtQW9UamtJdTlYdVUwdGc0?=
 =?utf-8?B?RnVwQkY4RTNiemJUQ0tPeEVyTFppeGcwN1BCM25jOUhDUjFTa04wdDk4OVE3?=
 =?utf-8?B?Ykw4aW84aSs4WFhTMXd6SGxYVlkrSGp3Q0xsQ0JDbXhkd1d3N0FVenJyYXZ6?=
 =?utf-8?B?TEdrbnJCOVdpMGw2ZjlBRHVhNmZoSVlodS9uRGxaTkptVzNZai9oZFlYQ05D?=
 =?utf-8?B?Y3lRMHFOOUVjckpNd3kwSjZmS0lQN1R6RDFnUnFFWjFnS2VVdW55TGZSeDBZ?=
 =?utf-8?B?RzRNRHoybnVqVDhROUVVdlZZaCswamRoZE9DcVdWYVgrb2l4VFMwdzB5V1p5?=
 =?utf-8?B?ejE5bUJzd0NRWjB5UENXNFJYUXl1Nk5vU1BGc2tNb1R0bmdJN2JSM3NNSDdV?=
 =?utf-8?B?U3VpTHAxeUZrdGw4NE1mMGlvOUtBb2ZmRVVqeDgwL0MxenN5eStDOXdRb3Rp?=
 =?utf-8?B?eHVUeSs4TUNNSFdxV0RCL0FjZkNPUXpzaS9EOWttb29wcHgwSUNtM3Bpb0ho?=
 =?utf-8?B?WDlWOWM0WEQyL3ptQXNFZkFwOXQ0QzNNNXFtdGZWay9uVnRuRVE0TXZjajh2?=
 =?utf-8?B?MXhTVGwxdEpSNlUyYzI0USt0alIrSDBzOUUyejBTVUhheVhmT3kxd0Rnc1Nh?=
 =?utf-8?B?TjJmWXpLUGZQRFFUSzBuWStVN01TNkZxUFc5d28zYXNyeU1ZMTQwMUptc3dr?=
 =?utf-8?B?eHJBTHR5TUZLUG0yRzBraUhhTTRZMVdWVzVoV0NmUkVRL2hUd21kUFJiTjdT?=
 =?utf-8?B?TGNRT1JxRWFvUGkzMTlKMk5NWm1XL0xCK2xPK3hwSW1QNXR0ZmZBK3BCQUJS?=
 =?utf-8?B?Y3oxWWhGSDNBS1RZaU5ONm4rMjlvNmRpU1Y4RWxFK1JZSGxoN2NkL2RRNXoz?=
 =?utf-8?B?QXdRbHNBSloyVStjbkxEMWs1cTZ4aGxDWjhRN1o4SzJNR2RqSk1lOHd3SkFU?=
 =?utf-8?B?WlI2V0V5ck56UlBjU1ViTjlmS0IzWjlTeUF1TEl3SDRqUkNVZXV5QXdMOUJH?=
 =?utf-8?B?NkQwM2J4d0tjZUhTMFhRMWViWmJDdEh4a000VG9FSS9GcUpqLzUvREMxR1J2?=
 =?utf-8?B?MkRXNTlCS2tEYUVNMG5Qb1VkWVA3TlJTeDVXbm41UHFYWFhhd01IOUdFZENO?=
 =?utf-8?B?bE16eHZOSXQvRzluRjF0OFdnZEs4TkdoclFPaFNPYTBpa2l2WkFpNzA2c2tG?=
 =?utf-8?B?N2NzRHZsUUNZQXJ4RERxRDFmQkhiUHJXNlBGakhWVHZsaUY1M0ZmM0hwTTZx?=
 =?utf-8?B?bmlNSUJpUkpnUVVkaVpzNWVwSEdXZVN1OGZrSVZCdXRkcFAzZUVYVkdiSzJD?=
 =?utf-8?B?Zlpjb2p6MGlFUXZSVVgyamtwa2xOQXFFbjB5Qkg1M0doVnNFbzhEcDdqbzZJ?=
 =?utf-8?B?MVZsa21nVXBlVlNRS0VaNXZ4VmJvMmJmaHpXYlArSFd3MWM3Z09zWTNCUDJS?=
 =?utf-8?B?NnFnY3NOQzhhZG92VW1Cc2xxdm11VUdjbjYrZitVR0QxVCt4TjA2REFjY3l3?=
 =?utf-8?B?MjVjSG1wYVhTNzF5MnQ2YzJ2VWc2eDRrQ0ZhVEpqeDNVTXUza2dEckpvWU9m?=
 =?utf-8?B?M1RCQzlOQlRRSEEzREhqN1BoVE1SeTdDT3lJdUZmVVpPSDVTMlNyT3U3VVMz?=
 =?utf-8?B?T3hkaEcwM0JwMWxqaDFySmd4T0tVQVlNd2owWVFnSVM1MXpTK1d6Y0hFMmtu?=
 =?utf-8?B?elE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d66256f-8c7d-422c-e368-08daa25a0ca4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 20:34:47.0954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxOWqfajwU2Gu4CqKK95MTSVv0df8nyzL+seN4wDoFDWCFlcx7N7Lb5JMIdx6tkvYNUQ3kFKeZCi7fAubN5tBmowU/pbIbM4ldNSrYOWnMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_11,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290129
X-Proofpoint-GUID: ldhePxmhRiERyyV30dwhdPIh7hKSafyH
X-Proofpoint-ORIG-GUID: ldhePxmhRiERyyV30dwhdPIh7hKSafyH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/22 5:34 AM, Dmitry Bogdanov wrote:
> This patchset is based on 6.1/scsi-queue.
> 
> Resending with a current datetime. Sorry for the experiment with a date
> of the patch creation.
> 
> The patchset adds support of REPORT SUPPORTED OPERATION CODES command
> according to SPC4. Including CDB USAGE DATA and timeout descriptors.
> Timeout descriptors are zeroed currently, meaning that no time is
> indicated, but an encoding of it there is.
> Opcode support and Usage Data are dynamically generated - reflects
> the backstore configuration.
> libiscsi tests for RSOC and tests that uses RSOC command are all PASSED.
> 
> v2:
>   fix sparse warnings
>   remove extra space
>   remove XDWRITEREAD_*
>   fix tcm_is_ws_enabled
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
