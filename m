Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE72C11F66
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 01:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDDF6613C8
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 01:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238327AbhGABQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:16:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2810 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238299AbhGABQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 21:16:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16117eqH000537;
        Thu, 1 Jul 2021 01:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nPDFQetROCBgFMsvbt8JuJHawu2FCAWX3gcA6fWdVEM=;
 b=poEn4gan3fs8rD6YjL3n0iPHIl7koEN4x9uxkaFJdqNpiQyZHvYXAkG99bvi/gQ8TQuf
 sXEEwZWcwqOxFEgJ3QjOF2GZ7x2Gw5lF+m/pgvHpR87L3S1KU25cg5CIcA14NgvSOR/7
 9lEULSZ8jOW3jtnqEN/85TLEbWS1LJqapihirnOjgcubUUV6pLRD99rBOUu3YcMderb1
 7bquPZ3Emu/4cmqKl88NhLpjnoet0sP5xDjkU40EvP/rshm91LQ8AxmAzzYxH2avldQ5
 McYAHWa/PFyQtXBZt808fMa8LhEk4vcv3mMMPvtVBJ9Ls/90I5vT3Ch8rsVwYzncN6wr ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39gha4a8sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 01:14:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16115mq6127528;
        Thu, 1 Jul 2021 01:14:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 39dsc2nrr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 01:14:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnUjMe+gKEumgT3kX7+S5CtTKNDb2BLIpwtcjpNoRrwRI74KvW5RvxEYcKCxwemHfbDGypG/IYSk9jQoI9W6GS+1HhXKzIQNNUhEZZx4tLpJD1Axbt6uuHYBecaf2/s3onWmRzUqXyjz3y0pYVAeE/7W8BL7SyCkx1k6vAO1LZCZNo9X2w+wU4biSH4BWafcYfC5jdz6/yTSb+NSA6q/3HW5yrGu04wR6HYwMb4DtQSZcuLYyP+T8+k2KXJIz58AtBD8KMp9OWzLYIeyEEf+QoMK3gT6yBXGGL9YtfL9Zwta+gC/UgF0/DONX2M9QJAwP2E8vjHR5vBUa4Ay2N5K9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPDFQetROCBgFMsvbt8JuJHawu2FCAWX3gcA6fWdVEM=;
 b=AONdDdHtUWcc7o/bPAr91ZLP4v16uQDFWUfjrAIkvn82asB7ckjlfRuOom/6e/hIkiejToYLG1Ed4SSp25XAhm9ja3iQSXpcaLqIAx/UickEJ4Z1FzWp19mElPcLuVDnQoHQkVkn+jY8KQP/uQMxmedCRBeqltmqDhJnO3TWNyR4Ku1FPi3z6GrA+bdgXWDbTqLXGZEnvvqVl9kYUYGgO+PYRVtX+tzTe2yQw2faiM0SXgCY1LVJzdLPgBEda3P88Wqd6dVRN74d4w8JwRjP/MZ+iNYyrqMS2D4DUtKO4IJXnE+r60cQJKRK4YQjGr0jFwx9iPobEq8ZTpnvFZN1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPDFQetROCBgFMsvbt8JuJHawu2FCAWX3gcA6fWdVEM=;
 b=MwyXg7PcNRAG2x0na9aK7XGBoVyJImboiUTCQzkKahBcHf8XRFfVt/YvQB10RdecPuH/tLImUJ7mbO2WHGsGi2G5sJ3kJORUDvxN/N3i7xOfyjKFcoS33Hxs2BwjSdmuu5dQwHoGcXs8f/2iU/hFmauIPxz65hPA48h4elNRMhE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2424.namprd10.prod.outlook.com (2603:10b6:a02:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Thu, 1 Jul
 2021 01:14:03 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 01:14:03 +0000
Subject: Re: [PATCH] scsi: be2iscsi: Fix a use after free in beiscsi_if_clr_ip
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210524095039.9033-1-lyl2019@mail.ustc.edu.cn>
 <yq11r8kibzu.fsf@ca-mkp.ca.oracle.com>
From:   michael.christie@oracle.com
Message-ID: <826bb7b5-c7ea-db24-878e-a2997a1cd9a6@oracle.com>
Date:   Wed, 30 Jun 2021 20:13:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <yq11r8kibzu.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:3:5d::15) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.12] (73.88.28.6) by DM5PR06CA0029.namprd06.prod.outlook.com (2603:10b6:3:5d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 01:14:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bf800ca-3028-4c34-5b03-08d93c2d836f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2424B98E8545A5A47E45412AF1009@BYAPR10MB2424.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9WANn/RDe+XViy/jmwXT/L1PS5UB9ol2wp3GPOR9ONQKr/Unx2zYELXEe/rw654hbV7KbZjT4Egw95+77LLQxsKCMi6ZVY9FZ7ddgdJ6gXjDAy33hWrrCdUzuG2nK4c2rkF9kNiH1YTJxjuAABNQE9p45Na/gnOxrvfRSWSwKix2nsx3GMjO9DLpeQwmm5wVvyyPOsDRG1T0LIgzCVKECkSqB8Ep7rp1Sirxb2IzaC1+IpGI4FlpaQz34P0wo/OXJCVGe+Evu8wUpw8FDaVNtM0VpiEL2ioAj7lruswyVvb9rTA8ezoZFaLkgJQgK6Pls73wOIk53VJqQ7kXtJNR+xt+Kl563GQAPTvjfO69oiTkCGnR3YUSUF79F7tGYK+GbESmjeKMlXaYQ8wcjEG57ovYazvxJ56/b4Yss4Nmql3EijN30qPlPy1V21QbDJAoRTHteIMNBwow+2DHXDwROweo7pnHr0OKjX7I6PgFTeiJuVYRCL+g77RawFk+2X0qHQEg5Da78B5IZPJbR17USWfCXos27yvJY6deWk47LfO8PwIfug6fCQb3GWi+CPRd/2d4sjhc2Jk7mqNMir6iS1bTUBpq/Q//NJ7qkf5ctArD5FKD8JOlnS0rrOGk3emYJLphjck/5H1rC1BbtjZ0HvPzRGcW86Ss+B2yoWm5AfYq19Xn1B06/IoZorFbhNDhykfXDUhSNU83Al2FLC/v5WlFrK3PxOh9f8dvfHnIRMCW8PpgRsHUtv+zDCBUa9fNuJL1Cq5MpipD4n1J6znVATfubsffmHoyp+jUuQaQCNYR/PxJYgQF297PVjCL/UEzXpnItXonYxMexXkcicVgVr8Fv8f4TJ7xpcHf9ccz/10=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(39860400002)(346002)(136003)(66476007)(31696002)(66556008)(66946007)(86362001)(9686003)(2906002)(2616005)(966005)(36756003)(8936002)(16576012)(316002)(38100700002)(956004)(4326008)(478600001)(16526019)(8676002)(6486002)(53546011)(5660300002)(26005)(31686004)(110136005)(186003)(6706004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjlMK2x4OThMRDZON3hndVlQUTFZMlpqcG05RWtnY0w0WXljUUp0OURvT3Vi?=
 =?utf-8?B?dzZhdklvbWdIdTFqSk5RM2Y4T1ZmTURWSEsyRVlyNWJRci9vSWdBYXJvS1Qy?=
 =?utf-8?B?aFdzOW9GOHJVMlJXYTRXVjM1Ti9Wb2JPL1NiVWFOZnBaNHhoRWJJTWtDcXdB?=
 =?utf-8?B?UExOY3BLNUdUc200UHdIUWQzdGFaakFrZjNEOU5ZZVNPYVoxZG1RT1FMR2cw?=
 =?utf-8?B?b2VBNFppSEF3ZzdsOUlGTmZDcUljQjN6MXVxL0hUQjk4cjFXUC9Eb05SRGNs?=
 =?utf-8?B?R3prV1hwUkpvdndKY3FxSnJCdTBmcEx0NjRKQnVLSXJ0NUtURktEbXFOQ2Zj?=
 =?utf-8?B?blNFODZFVU1Ga1NZd0xTejdUZUp4TXQ3MUhxbGttR3pHUGM1TnBUTFFuR21O?=
 =?utf-8?B?Q1BGUUYxalJ0UGJzRXJLUS9lNUhFYWFFZFAwSUNlTlZKczZyYXB5UmxBMXgy?=
 =?utf-8?B?dnVtSFZkd0VMNUpDVlcyOWtzZXlSazJLeUNOVVJvNWM2NGhNbDBJVitxVmxO?=
 =?utf-8?B?L2lVZ0NyR0hDUlNRYlV0L0E2N3A0ZzdGRzVCb2ZWNHk0ZlpHbzdIRDh6RXd1?=
 =?utf-8?B?ZUh4NEZpY0lYQTgydGNpWkVpdExCWWV1NHpadEd1dWVuYnRSYncxK1d1ZHJj?=
 =?utf-8?B?NXhoMG04MUhubUNHUDA2eTdyblVJeGxDQU1LcExhaWd3TW01WVJpUXFGV1Jk?=
 =?utf-8?B?T1ZsMER3cDlKSXdTaE5ZTnNNUkQvZXc0dlpTbjgxb0NCKzFzdnBQU29lNzQ3?=
 =?utf-8?B?QU9HTTJqUEM3K2tFUGFqdEltRTI3WE05SklUWEk0VjhyS1dibml6WkpBR3FU?=
 =?utf-8?B?dlY2OVpUS3pQZC9KK1BxMldvaU5LcXJGS0sxZHo4ZUp4cU9aMVl3WFlnUG9N?=
 =?utf-8?B?YnVhaFBLVEdNa0cwS3lzYXlvUk5PYlZRS0xqcG5rRlIybWQwYmNYWG9jb2RB?=
 =?utf-8?B?ZHk3SDRxT0daYnZwbmJHWkNDOWl4dlFaWG1zVnRNZ1F6UW5PS1lPTnF3OWc5?=
 =?utf-8?B?Q3hUZFROUEx2czJ0dnNoMW9xTFZJSExPRlllQ0Rmek4vYlFrdDZ2aE1EZUJJ?=
 =?utf-8?B?RVJoeWM0dGpxdit2REp5Ni9WYVQxREhoOWRLdkNkYkdkOE9zeFRSUmdKZWVX?=
 =?utf-8?B?WGVTOGY1NlFDY20rYjNNb05wOW5sOVJ4VTdwL3U5bG9pWVdLcW5hOGVRN1Qz?=
 =?utf-8?B?Vk40SVNiUG0xYWZJMEZoRG1zZ3RBaW9vQm9pVWtKb3J4aWorNDM3UTJOQzlQ?=
 =?utf-8?B?YzNEdnE5c01YQzFvWVJWUGljNVAvam5mNnI0bnc0bDNGa0Z4L3F2UnZqZ0du?=
 =?utf-8?B?T0c5SjY4QkRrWjQwN1lJTkRxN1dTTzlpME1kYWR4cEk0YU9sQXRkQ0c4czEz?=
 =?utf-8?B?S1lyY2YwbUxqTXUrL04rWW1sZSttK2ZUcDRhVU5BdEpkZkV4blo1K1lsa3M0?=
 =?utf-8?B?K1hrZFQ1c0tzN2ZVeWFUak9vRk5uNU1DWFFSenFWcE04NkdKUEpVa2ZzclFP?=
 =?utf-8?B?ejNSZDVzaEtxQXpXeUhzNjNTdzdER3dLQm8rSkQ5ZWxrc3dzbGhUQzhmWmUv?=
 =?utf-8?B?SVphU05kUHhiTEtRR2JvcHBNUXdlU3pFc0JjaTZ4SFUxbHMwR2FUVWpVdjd4?=
 =?utf-8?B?WTJySVZqMW42amExSEZ6YkRua1QvZ1lsN29HYlhSdkgvMnhVeE5yTTlsK3dT?=
 =?utf-8?B?Q1dHbThBTUtIU0Q2RjFvNklENCtHYlFQYzlRVEtFZ3RuRlgrMXYzcitKd2tB?=
 =?utf-8?Q?3jm8unQMhwUlc0+CUKW+jJ3DGf3SpNLgfPEOYcu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf800ca-3028-4c34-5b03-08d93c2d836f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 01:14:03.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTeO1f0RVhVy58Fignz30C5pro/srz21f16O3JPSIgjCtFeulPmzdnwpQrwN3qg57+wP86uk9E1mQH3+tdKDclIx+Aip1Je0Ei1e1kxtHxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2424
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10031 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010006
X-Proofpoint-ORIG-GUID: 5xg5vjlGNGD5844QrceyNoxCu5IP2imI
X-Proofpoint-GUID: 5xg5vjlGNGD5844QrceyNoxCu5IP2imI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/21 5:02 PM, Martin K. Petersen wrote:
> 
> Lv,
> 
>> In the free_cmd error path of callee beiscsi_exec_nemb_cmd(),
>> nonemb_cmd->va is freed by dma_free_coherent().  As req =
>> nonemb_cmd.va, we can see that the freed nonemb_cmd.va is still
>> dereferenced and used by req->ip_params.ip_record.status.
> 
>> My patch uses status to replace req->ip_params.ip_record.status to
>> avoid the uaf.
> 
> This status is captured prior to executing the command so it doesn't
> actually reflect whether the operation was successful (which I believe
> was the intent).
> 
> Some of the callers of beiscsi_exec_nemb_cmd() pass a response buffer
> and a response length as the two last arguments. Since
> beiscsi_exec_nemb_cmd() frees the command before returning, passing a
> response buffer seems to be the only way to get meaningful data out.
> 
> I am not sure whether the OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR
> operation returns something useful from the controller. As far as I can
> tell not all operations have a response buffer defined.
> 
> My recommendation would be to add a response buffer and try to decipher
> what comes back from the firmware. Also, beiscsi_if_set_ip() appears to
> have the same problem as beiscsi_if_clr_ip().
> 

Hopefully the broadcom devs will chime in, but it doesn't look like we get
a response buffer. I think we just need to move the:

      dma_free_coherent(&ctrl->pdev->dev, nonemb_cmd->size,
                          nonemb_cmd->va, nonemb_cmd->dma);

to a helper and have the callers free the cmd.

Oh yeah, I guess we haven't been able to hit this bug, because
beiscsi_if_set_ip/beiscsi_if_clr_ip hasn't been run since 2013.
This patch
https://patchwork.kernel.org/project/linux-scsi/patch/20210701002559.89533-1-michael.christie@oracle.com/
allows us to be able to set the IP and hit those code paths.
