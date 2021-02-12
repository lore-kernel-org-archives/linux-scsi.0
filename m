Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530BFC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF1B64DF0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhBLTLR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:11:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36560 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhBLTLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:11:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ9rEN031507;
        Fri, 12 Feb 2021 19:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XqtnxhLcffsY9d9UYifdy4suihKys3qfkF4JvUKyxXg=;
 b=FoIJ7NEZyDLxsWnhoNKmth4+IjQswWNiqnNrKhzW/XFY9lfPROH3JB7MFoCl2nMIQfjW
 WZIcRywIdczIYVh+6WbXKE3ZxvF/GwneXYuckG+iEX2IMgmVPri+I2v5yIC+IfKlHA6l
 qXI054O501Hy5Xn8/JruHSfTfgXT1q+8JOFtnY79qUTx+WBwW4+uaYys4fhwprXXZo8u
 Fv6/V+wCi3BqEg0C0vVGxrCIHo8tUUv2Lj3S/6lQc+FJvOzZDZuL/03Ojdt208jfELyE
 kVa000ZpbvfObXTZeCPVDkGjnaxJ7ZW7PtaQmdlxpPXc5r4SZMJb8xTIuMWV5ZGHzPnr fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36hkrnc95g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:10:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ4qpR108901;
        Fri, 12 Feb 2021 19:10:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3020.oracle.com with ESMTP id 36j4vw3g1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:10:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ3kVH/KPT7yxQZkVr8NOeEns/QuNpzgX3AAoHDuoecQBy5g+1Ectc5lkUeb9PH+oAiQ2GttY1khyL2XoYSBu2ex7ntjQZ1bxJ4I86mMIf0no1eL1uqCoX297HQK9YvFebuFSHQ3QRfZKVKJ2PN88vyiZSEWdeKB3eJBBPu5ONnmiC44I8GfXUjgkFZuzsFz13et+9ybInuwTWRze8b1xwlDpBn+1c6d0PSW3UlJNlQCuvkbZxCBv4kVUfoKMhbr9T0/NW2WE9i+E4J4ksspH7k+ZpLSEjSvogu1mFK6wOgxwsQMmAId0aE0J28zAZENYBvDrq1A06bU5XInBISo5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqtnxhLcffsY9d9UYifdy4suihKys3qfkF4JvUKyxXg=;
 b=PDZIfNzKt8S/nm7O7LwwaKgoIz8YNpegGTreaUl2eOg/tK97OzRFY9cBDIKgAhI52eN514TEA9JNkjdKf8wbAoN8Go9juo5vc3iVPLJvaWMzxuWEKzy7x/k9Jwc8RtUIl3OVay5yOlChXuCjeLjxgyKut2FfJcqKI5z9mun7d/WIx0XCXx7hznKeCOirJnZt+/FYxmxXxYUsF0iVkGjwKU1kEy9kXzcJQ8m3ZS946wHQClbsSmg5gbmaCo9TlDDfSDONMXcoDmT24V4ZOct4hIpSigtLwEAXHKRKYg0Mn14KciB0JUS4Ri9pAEBtRfuwJ4WeX3eVVWcffZHhA9AeVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqtnxhLcffsY9d9UYifdy4suihKys3qfkF4JvUKyxXg=;
 b=tLd6CcVucnETxQaBwcr7/aDvk9ElVOfjiOm6/M4ytJwt0+mj40Cx6pRkw0Ftx3QrUk3xcTKWOOeiu0sujgon2Lk7f2W/MZbXaTulnA8MyeFu3MLzMwCLx9pJB8OpP/IFJEVb1FeYnQGyV8Mjh83P+sv1rinv9xQAqTKiP4cx+Sg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3453.namprd10.prod.outlook.com (2603:10b6:805:db::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 19:09:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:09:57 +0000
Subject: Re: [PATCH 04/25] target: break up target_submit_cmd_map_sgls
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Chris Boot <bootc@bootc.net>, Felipe Balbi <balbi@kernel.org>
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-5-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <bdf02cb5-3296-fdac-2e50-94737d3f1888@oracle.com>
Date:   Fri, 12 Feb 2021 13:09:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN1PR12CA0108.namprd12.prod.outlook.com
 (2603:10b6:802:21::43) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN1PR12CA0108.namprd12.prod.outlook.com (2603:10b6:802:21::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 19:09:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffe7fcbc-80ca-4014-22fe-08d8cf89c9c8
X-MS-TrafficTypeDiagnostic: SN6PR10MB3453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB3453F261BF08BA69041B0D2CE68B9@SN6PR10MB3453.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIYyD2kvm6aHsOdFevXBMWvTG4RuRUgf+HSUnyTpNV/2xA8BCmgrrJNtmjfWPI5ssosWEGcDJ2wg3uW8A+zCHAx5tNxulkaVSnWfh1dElMhC+uzrTzcII1XrJHNHAbz31x02JrL6woe0s5Oqniwg9lSyKZ4Aor5UE1w2m+pcLgEzovmqt+btECXfj3VVSbhVjdHk1AFYRcQ2XSviGpCXzPBYPfndxdjGzHS14VcCk2s7k5H8vZvuOR94mjJyUF++o7jeVbXWRywTP253pdMQSiidBQpKW1A+v2V8Wcq0/tEDLKl9CcAIuOWRUmyqJ6opptT2KeKoEPxipJpy68uoKNHkKkO9hLY0inm8fSW+wtRzHC35or08la2VRKjC1UCLLFLSkI9kUeTZsB8ebEn6vdJyB3IKurY8NChuCoVhN9oNN4BSfPuN7Vcuw1r0J4e9i7bHQWCj4D68qxDGQAdRdSFHKgB/07CxWTfRxHIVSl7mKqjYQRvnXRB4xhl73b+tC2ykywEZ9hxOmT3RmE1JvvmSQQYwSi7GchRxALwgpVfDvcjea36Sdq2/o4FZp+B8HNtFPFLcS0m+FUsi9+VlVjRqfHDCbb/p6aDmszL47ho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(8676002)(44832011)(83380400001)(31696002)(86362001)(2906002)(2616005)(956004)(30864003)(5660300002)(6486002)(36916002)(66476007)(66946007)(36756003)(16526019)(54906003)(186003)(7416002)(66556008)(31686004)(26005)(16576012)(316002)(4326008)(478600001)(53546011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?akdRWng1UUV2eG95N1F6VXgxdFUzcTZIbEFPeE9uVkFhU1I3cW1TOWJac203?=
 =?utf-8?B?OHh1THpWam4xUExkUTZJNmY3eHlvdHQ0czFqeVBLZGdGTmowTlhPNzJiQTRP?=
 =?utf-8?B?Qi9oZXdDVFZJQUxsOVczRmIrT0FRMkprZnFtbkNtUTBRN0lnU1FrdzhMazRZ?=
 =?utf-8?B?cXRWZ3BvSEs2Nit6SkVFbXgxOFdLemp4Q2sySS96VEZNUVBaTFV1aCtoL3lh?=
 =?utf-8?B?M3ViNzBON0J0VVdJL2xIRHhzZkthRmVtZ3NrTnlzaVB6V09PdWU0RnlCblRp?=
 =?utf-8?B?QkVnMXRiclJYOXBkSTNnN1hDaWprVzhPTjEzU3lvVnRYMytPNXpSSWZIRkhi?=
 =?utf-8?B?NkxwRS9EbzhVUnprTVAvVE9panlKNnFJZExuUmlXaGNIdDVpRSt4ZkwwUXgx?=
 =?utf-8?B?VDdWM1dNblJ1MDdUQVBBdzdCMVd0bmpWNUgySTVpcm9qMkl5NjhPVGRTS1ZT?=
 =?utf-8?B?RHFxSTFZc0xRZFJZUnExNGc0YnBMQXh3WW9DVWZIZG1XSTNRNnM1RWZDZlQv?=
 =?utf-8?B?eFJMU3JjcW1KV0MwMFJxRytySnQ5OUpOd1Y4L3hIMDVKcFhzWGhNbEtHbGpT?=
 =?utf-8?B?V015SVZ0SjBpWDNhZXBVWTNIK1YvbXh3ZVZoNFRwUFNOeDh6N2pUSU1ZMkdM?=
 =?utf-8?B?SkQvMUNFYjB5d3Y0QjVIYXFMKy9ISi8xUVRkcUhUK0cwL0tucnVKeURid21L?=
 =?utf-8?B?UFo4Mk5DSjdUdmV3c0JKb0c4MURBMFJFblNXSE9OSXNJSnFxaTNMeEtqL1Rq?=
 =?utf-8?B?cXQzaEpYQ3lUdU1kN1RCcmhlMjdOY1VNMFhKZGRNR0NxQTR4MDdBbHFWUnV3?=
 =?utf-8?B?WWszcG5TSXVTVG1KYUxwRWlaU0hBdFRveFRtZVB6d3dudmxJYWt1L05tZWlF?=
 =?utf-8?B?QnBDOTF1MzV2RzlhL0U5aE5CTkhyTUtMd2pvd2ZiUmVmOVVpVUk0Q0lqbzRM?=
 =?utf-8?B?K0JPd3F4WkJlTDZlaHlQTkRmaFEvUmhwMUxKMmhPV2JGR0IvaGRwNWRQMnRr?=
 =?utf-8?B?RWZBYjViTkhnRmR4WXNaV0ljZmlGMTZ4cTRlclI0cTZDczd3R29PUXgyZzE5?=
 =?utf-8?B?aFMvSCtWYlFsbnB4MTM1UkVKRS84Q1pja0pUd2tKRWNjcGQ2cDhERG10R1pl?=
 =?utf-8?B?SWRxS2t4MUZVYWYvaTFyMlRnQ1poS1JrazBJNysxODl5ZTZvcVVsemJBRVZI?=
 =?utf-8?B?ZXpjSkhsSGUxSVZBRUswdU16MHBoU0IyK1lhMzVzUFZBZjljdTFJREZoblVG?=
 =?utf-8?B?R2xYUGNlT1FGd3o0MGdKZ0hLR05nVXJMd1JnUzMzMHdxdUZjZDFJaVlwaUlL?=
 =?utf-8?B?MXJCdzBJY0NYYmcyQ2syWHA2TjdmSnN1bjAvR0c2NnlBd2pFdEg1UEJXV3Mr?=
 =?utf-8?B?Yi9OalRnYlp4VW9DK2U1WVNRd21sd2ZOb2RvVXRIVVZjK2h2dm8wcE1RNFIv?=
 =?utf-8?B?Z2R5RTRKRVNNWnRxOXN6MjZjS3lrQmkzM0hhTVhFNWtTbU9KWkx4SnNxTnUv?=
 =?utf-8?B?eFFqZXY5cHBxbEw0b0dpbGpZZDBEemx1T0RHb2M4UXEwdjJodmNWMFlPTG5m?=
 =?utf-8?B?eVdHdmVYWmd3Z1lvV3JQTU9paUl5N1BtZEMzOFBYdjJ2U2JoWGEyQmhLZEJW?=
 =?utf-8?B?UXhVMUxjWU1WZ3N2cHd1YTRoTEgvcWJnUzlSZWQ1dVpJOFZiTEtCWlFUcDZL?=
 =?utf-8?B?U1VIcktwOHVYK2ZLcW1obi9rNUJvS1VPamJ1aXJaRUJqNFFWTi9VdWxXRWx5?=
 =?utf-8?Q?dLi56bYzEMpllRbeAzc4i595vBVon6zyiEftcoO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe7fcbc-80ca-4014-22fe-08d8cf89c9c8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:09:57.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zY2ajjJwkNNs83TFbeA2xW9onHED/W1P8GR+dIDsPyeFAib09T7wK318Q65HYHGyAdDhujT3fDvPgjKy/3StUVe02ncgjNNY5/lW5cAK1i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3453
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120140
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> This breaks up target_submit_cmd_map_sgls into 3 helpers:
> 
> - target_init_cmd: Do the basic general setup and get a refcount to
> the session to make sure the caller can execute the cmd.
> 
> - target_submit_prep: Do the mapping, cdb processing and get a ref
> to the lun.
> 
> - target_submit: Pass the cmd to LIO core for execution.
> 
> The above functions must be used by drivers that either:
> 1. rely on lio for session shutdown synchronization by calling
> target_stop_session.
> 2. need to map sgls
> 
> When the next patches are applied then simple drivers that
> do not need the extra functionality above can use
> target_submit_cmd and not worry about failures being returned
> and how to handle them, since many drivers were getting this
> wrong and would have hit refcount bugs.
> 
> Also, by breaking target_submit_cmd_map_sgls up into these 3
> helper functions, we can allow the later patches to do the init/prep
> from interrupt context and then do the submission from a workqueue.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Michael Cyr <mikecyr@linux.ibm.com>
> Cc: Chris Boot <bootc@bootc.net>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/target_core_transport.c | 200 +++++++++++++++++--------
>   include/target/target_core_fabric.h    |   8 +
>   2 files changed, 147 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 013f4a5e8972..a82b7da09872 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1571,46 +1571,31 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
>   }
>   
>   /**
> - * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
> - * 			 se_cmd + use pre-allocated SGL memory.
> - *
> - * @se_cmd: command descriptor to submit
> + * target_init_cmd - initialize se_cmd
> + * @se_cmd: command descriptor to init
>    * @se_sess: associated se_sess for endpoint
> - * @cdb: pointer to SCSI CDB
>    * @sense: pointer to SCSI sense buffer
>    * @unpacked_lun: unpacked LUN to reference for struct se_lun
>    * @data_length: fabric expected data transfer length
>    * @task_attr: SAM task attribute
>    * @data_dir: DMA data direction
>    * @flags: flags for command submission from target_sc_flags_tables
> - * @sgl: struct scatterlist memory for unidirectional mapping
> - * @sgl_count: scatterlist count for unidirectional mapping
> - * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
> - * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
> - * @sgl_prot: struct scatterlist memory protection information
> - * @sgl_prot_count: scatterlist count for protection information
>    *
>    * Task tags are supported if the caller has set @se_cmd->tag.
>    *
> - * Returns non zero to signal active I/O shutdown failure.  All other
> - * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
> - * but still return zero here.
> + * Returns:
> + *	- less than zero to signal active I/O shutdown failure.
> + *	- zero on success.
>    *
> - * This may only be called from process context, and also currently
> - * assumes internal allocation of fabric payload buffer by target-core.
> + * If the fabric driver calls target_stop_session, then it must check the
> + * return code and handle failures. This will never fail for other drivers,
> + * and the return code can be ignored.
>    */
> -int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
> -		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
> -		u32 data_length, int task_attr, int data_dir, int flags,
> -		struct scatterlist *sgl, u32 sgl_count,
> -		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
> -		struct scatterlist *sgl_prot, u32 sgl_prot_count)
> +int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> +		    unsigned char *sense, u64 unpacked_lun,
> +		    u32 data_length, int task_attr, int data_dir, int flags)
>   {
>   	struct se_portal_group *se_tpg;
> -	sense_reason_t rc;
> -	int ret;
> -
> -	might_sleep();
>   
>   	se_tpg = se_sess->se_tpg;
>   	BUG_ON(!se_tpg);
> @@ -1618,53 +1603,69 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   
>   	if (flags & TARGET_SCF_USE_CPUID)
>   		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
> +	/*
> +	 * Signal bidirectional data payloads to target-core
> +	 */
> +	if (flags & TARGET_SCF_BIDI_OP)
> +		se_cmd->se_cmd_flags |= SCF_BIDI;
> +
> +	if (flags & TARGET_SCF_UNKNOWN_SIZE)
> +		se_cmd->unknown_data_length = 1;
>   	/*
>   	 * Initialize se_cmd for target operation.  From this point
>   	 * exceptions are handled by sending exception status via
>   	 * target_core_fabric_ops->queue_status() callback
>   	 */
> -	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> -			  data_length, data_dir, task_attr, sense,
> -			  unpacked_lun);
> +	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
> +			  data_dir, task_attr, sense, unpacked_lun);
>   
> -	if (flags & TARGET_SCF_UNKNOWN_SIZE)
> -		se_cmd->unknown_data_length = 1;
>   	/*
>   	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
>   	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
>   	 * kref_put() to happen during fabric packet acknowledgement.
>   	 */
> -	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
> -	if (ret)
> -		return ret;
> -	/*
> -	 * Signal bidirectional data payloads to target-core
> -	 */
> -	if (flags & TARGET_SCF_BIDI_OP)
> -		se_cmd->se_cmd_flags |= SCF_BIDI;
> +	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
> +}
> +EXPORT_SYMBOL_GPL(target_init_cmd);
> +
> +/**
> + * target_submit_prep - prepare cmd for submission
> + * @se_cmd: command descriptor to prep
> + * @cdb: pointer to SCSI CDB
> + * @sgl: struct scatterlist memory for unidirectional mapping
> + * @sgl_count: scatterlist count for unidirectional mapping
> + * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
> + * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
> + * @sgl_prot: struct scatterlist memory protection information
> + * @sgl_prot_count: scatterlist count for protection information
> + *
> + * Returns:
> + *	- less than zero to signal failure.
> + *	- zero on success.
> + * If failure is returned, lio will the callers queue_status to complete
> + * the cmd.
> + */
> +int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
> +		       struct scatterlist *sgl, u32 sgl_count,
> +		       struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
> +		       struct scatterlist *sgl_prot, u32 sgl_prot_count)
> +{
> +	sense_reason_t rc;
>   
>   	rc = target_cmd_init_cdb(se_cmd, cdb);
> -	if (rc) {
> -		transport_send_check_condition_and_sense(se_cmd, rc, 0);
> -		target_put_sess_cmd(se_cmd);
> -		return 0;
> -	}
> +	if (rc)
> +		goto send_cc_direct;
>   
>   	/*
>   	 * Locate se_lun pointer and attach it to struct se_cmd
>   	 */
>   	rc = transport_lookup_cmd_lun(se_cmd);
> -	if (rc) {
> -		transport_send_check_condition_and_sense(se_cmd, rc, 0);
> -		target_put_sess_cmd(se_cmd);
> -		return 0;
> -	}
> +	if (rc)
> +		goto send_cc_direct;
>   
>   	rc = target_cmd_parse_cdb(se_cmd);
> -	if (rc != 0) {
> -		transport_generic_request_failure(se_cmd, rc);
> -		return 0;
> -	}
> +	if (rc != 0)
> +		goto generic_fail;
>   
>   	/*
>   	 * Save pointers for SGLs containing protection information,
> @@ -1684,6 +1685,41 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   	if (sgl_count != 0) {
>   		BUG_ON(!sgl);
>   
> +		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
> +				sgl_bidi, sgl_bidi_count);
> +		if (rc != 0)
> +			goto generic_fail;
> +	}
> +
> +	return 0;
> +
> +send_cc_direct:
> +	transport_send_check_condition_and_sense(se_cmd, rc, 0);
> +	target_put_sess_cmd(se_cmd);
> +	return -EIO;
> +
> +generic_fail:
> +	transport_generic_request_failure(se_cmd, rc);
> +	return -EIO;
> +}
> +EXPORT_SYMBOL_GPL(target_submit_prep);
> +
> +/**
> + * target_submit - perform final initialization and submit cmd to LIO core
> + * @se_cmd: command descriptor to submit
> + *
> + * target_submit_prep must have been called on the cmd, and this must be
> + * called from process context.
> + */
> +void target_submit(struct se_cmd *se_cmd)
> +{
> +	struct scatterlist *sgl = se_cmd->t_data_sg;
> +	unsigned char *buf = NULL;
> +
> +	might_sleep();
> +
> +	if (se_cmd->t_data_nents != 0) {
> +		BUG_ON(!sgl);
>   		/*
>   		 * A work-around for tcm_loop as some userspace code via
>   		 * scsi-generic do not memset their associated read buffers,
> @@ -1694,8 +1730,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   		 */
>   		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
>   		     se_cmd->data_direction == DMA_FROM_DEVICE) {
> -			unsigned char *buf = NULL;
> -
>   			if (sgl)
>   				buf = kmap(sg_page(sgl)) + sgl->offset;
>   
> @@ -1705,12 +1739,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   			}
>   		}
>   
> -		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
> -				sgl_bidi, sgl_bidi_count);
> -		if (rc != 0) {
> -			transport_generic_request_failure(se_cmd, rc);
> -			return 0;
> -		}
>   	}
>   
>   	/*
> @@ -1720,6 +1748,56 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   	core_alua_check_nonop_delay(se_cmd);
>   
>   	transport_handle_cdb_direct(se_cmd);
> +}
> +EXPORT_SYMBOL_GPL(target_submit);
> +
> +/**
> + * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
> + *					se_cmd + use pre-allocated SGL memory.
> + *
> + * @se_cmd: command descriptor to submit
> + * @se_sess: associated se_sess for endpoint
> + * @cdb: pointer to SCSI CDB
> + * @sense: pointer to SCSI sense buffer
> + * @unpacked_lun: unpacked LUN to reference for struct se_lun
> + * @data_length: fabric expected data transfer length
> + * @task_attr: SAM task attribute
> + * @data_dir: DMA data direction
> + * @flags: flags for command submission from target_sc_flags_tables
> + * @sgl: struct scatterlist memory for unidirectional mapping
> + * @sgl_count: scatterlist count for unidirectional mapping
> + * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
> + * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
> + * @sgl_prot: struct scatterlist memory protection information
> + * @sgl_prot_count: scatterlist count for protection information
> + *
> + * Task tags are supported if the caller has set @se_cmd->tag.
> + *
> + * Returns non zero to signal active I/O shutdown failure.  All other
> + * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
> + * but still return zero here.
> + *
> + * This may only be called from process context, and also currently
> + * assumes internal allocation of fabric payload buffer by target-core.
> + */
> +int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
> +		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
> +		u32 data_length, int task_attr, int data_dir, int flags,
> +		struct scatterlist *sgl, u32 sgl_count,
> +		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
> +		struct scatterlist *sgl_prot, u32 sgl_prot_count)
> +{
> +	int rc;
> +
> +	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun,
> +			     data_length, task_attr, data_dir, flags);
> +	if (rc < 0)
> +		return rc;
> +
> +
> +	target_submit_prep(se_cmd, cdb, sgl, sgl_count, sgl_bidi,
> +			   sgl_bidi_count, sgl_prot, sgl_prot_count);
> +	target_submit(se_cmd);
>   	return 0;
>   }
>   EXPORT_SYMBOL(target_submit_cmd_map_sgls);
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 4975c4d2a933..4b5f6687393a 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -151,6 +151,14 @@ void	transport_deregister_session(struct se_session *);
>   void	__target_init_cmd(struct se_cmd *,
>   		const struct target_core_fabric_ops *,
>   		struct se_session *, u32, int, int, unsigned char *, u64);
> +int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> +		unsigned char *sense, u64 unpacked_lun, u32 data_length,
> +		int task_attr, int data_dir, int flags);
> +int	target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
> +		struct scatterlist *sgl, u32 sgl_count,
> +		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
> +		struct scatterlist *sgl_prot, u32 sgl_prot_count);
> +void	target_submit(struct se_cmd *se_cmd);
>   sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
>   sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
>   sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
