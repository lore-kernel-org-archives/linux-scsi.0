Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7475C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 01:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870C861A18
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 01:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239588AbhCYBVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 21:21:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54624 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhCYBSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 21:18:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P1FFOj171979;
        Thu, 25 Mar 2021 01:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=H6Ah1Hb4Isr6d6RZWUNWmjFNE0nbvR+bFHHK2OxyPN0=;
 b=BBNBclaTs2/zUbQkk/Z7WeWdfnSSZ9QMDhDj0OIURL/slYPvJQ4H0hfxI4Sk2MtluWTM
 Cp0MvgeIxWs+I0GhRZY6JsImMLwUPvmLsf6NhcRnIDZ6YwuQUX+/aYHNmMlHWdkANgE+
 6ksN+ld3Pq7Z4/P/WBj6MX7jNxtyoBaTJt5ZbXr5BRvdeU78/EMJfH+Q9DPYqe6RvKTM
 1DB78V0QQujNc3oiF34sPfYzonW6kpRPwwgyBQ8o2bY/JhDcVqdjL0g8IDzjNFVYRGep
 /2IblHXpHKjIJzjIDE6SkiXBKaCCHoIl4FyQ/dn6mSlhfr/QJjZEjRHa7vSgBvP32QM3 zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37d6jbmtp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:18:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P1FEgm108334;
        Thu, 25 Mar 2021 01:18:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 37dtmrhs3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:18:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv69Tcw1jUD5E52LzktrFO7FO65sjJwcWLdEhTf1j74RKdBUW7XueJXXf7E17q3GFr3GLKGbtwL+SY4OGq5LUmBCfEWCgbp4lkabShZ+eA0Xp4c9dr4K+PXBnjveGJvh7qCXmyg3f4v9KF5Z5FspFeRmQXUnev5jVkT0f2nP5/nduPIMNxAqYxkEjNRhHYGWeL4OY37G+UZh3YI19HXBa9tlUFkRZZOgj4lprhpQZX7Ug3RTohHkz22gr/gJMHprbeDpspqgnYZzaEv5u5JmgsYDM2QMMQU1mhnrkK3dFaXt3CmJq9/PLeNMQ4g6opXWYdTEnw7Q6DCKxcof+zzp2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6Ah1Hb4Isr6d6RZWUNWmjFNE0nbvR+bFHHK2OxyPN0=;
 b=SW7/Mpxa6QU7XRNRmliXv3I9tY4tP0LR4F0Qjs/cZALdKCEWtJ2yWHGeuvxpw7PK5L4wgZMM8k6yqH5uSWDawfLNCVQKNufKOqR64rEfv2P70ml39OsK69SFLohdF4n8otjc6oVbTKZtPdMLxURm3BleDKnp6TJZ281yczQMZxD1pHv5joLftpctPyoAl7C6rcIO5QA3SjIbk/bBrmyu1y2xuZL7+r3hCalL8M1t+rlFW6yZCoVRwcuRTH2tharHBOOuEAM8KwVYNIe/xVLi6NKWWHEQ1oBfxzZMQjffrF9aDHhTLNA0e8yWswGji5YHjJqYX148gLRIHD3JXojFLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6Ah1Hb4Isr6d6RZWUNWmjFNE0nbvR+bFHHK2OxyPN0=;
 b=E1Yn0oMqb2Mnx2sClZIdJoptcGnViQ/kh3rB5KafFcMYdq5juxrDm8rrlGqSNTFyIWB8jUJt3KAldQj2D8SPlD+1GICaPc76qqf3bD7bvDgD6B/fxO13fSaZVheTr3CWEbLpQpDuX7ijckDRpOUsYJ7YDG3TYjNkZNaQlVhLqn0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4520.namprd10.prod.outlook.com (2603:10b6:510:43::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 01:18:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 01:18:18 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135wkm410.fsf@ca-mkp.ca.oracle.com>
References: <20210304203822.GA102218@embeddedor>
Date:   Wed, 24 Mar 2021 21:18:14 -0400
In-Reply-To: <20210304203822.GA102218@embeddedor> (Gustavo A. R. Silva's
        message of "Thu, 4 Mar 2021 14:38:22 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR14CA0010.namprd14.prod.outlook.com (2603:10b6:610:60::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Thu, 25 Mar 2021 01:18:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf0b024-bd11-4333-e9ab-08d8ef2bdfa5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4520:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4520CD9770DD10841B62BA498E629@PH0PR10MB4520.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvtR+vbf1w+FLLbqGBEmU2BG5vtg+IFTFkyrdx6tMLkne2YiM7CpHW7QS6k+3fsus9y+ztB5q7PvzcysRstEM4NTqZHmm1+/y1tvvjpy8iTMoHFdUxTMBd4CXLPRi5p66yrU2679JltV5o2FK6nnEDATprInrhsbgu+kee84mE+Lf05U0fJjFjN7t/RWNxygUHwlkQDqt01Rx753dbc8+T0qeKTfifQVOR37AdTEfmUlUVc1kqmrt/qeC1PKL8vF5I+WjUlsMYhgDGlVoCiZeBiolp/qjsIdCfNEIunzU8Iy2pT9bCprepq3XTKbWB9jesv481WkI0tdy/ULWC/yeFkj7e7bW5i7D7IoSR7dypsxmpNtXRu+jMWtpfhQzOuG89nurF5b+xPGPq+vG/YsdbGI4s+T6fkLUkF4itVOz19XCGqTdPOlQ8E4altxtk7uSS42wwluajN7A7VWmF0OS+DnSH5i1HwqG4uMVc1ImbZ/9Or2e/0/aLyQbuj/wl0+TI//nTqyft2vOKbG4tUKKcA7RmtEQsRb+80HAgij8emeUJIYcDQ5cgvYVNtnNSoyTcd4Ht6whav0iMttSnbTm9Rw0IKDEglBU1P+c6H54m71Msm7XDWztxXz4N5JRiMxXc2KJglhQ2nOnOpg0VeYgWwOgOGGNV6vRUsSaMSghu4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(2906002)(5660300002)(66556008)(6916009)(8936002)(8676002)(66476007)(4744005)(55016002)(66946007)(4326008)(956004)(6666004)(7696005)(54906003)(16526019)(186003)(38100700001)(316002)(52116002)(478600001)(83380400001)(86362001)(36916002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2maOkdklZfEwHGdDf6pskCQmBdhkwczvQDjp6BvmEDOC1qZfvMpiDLRjnQaN?=
 =?us-ascii?Q?DOWm0+wJU//yKANze44GOt2pdWYmkvZgKS+B3dl5czFqp3X/iaqRMmpA2Dj4?=
 =?us-ascii?Q?8JAJsgvfynjsSXHXBqwOZZOUQ80/YIhQIsrNxVnSKWhxp2DYx7HGcmN2GZV8?=
 =?us-ascii?Q?pG3Uej7MAz0AyVJDukTUPbGUhRCSx1a3epNXB1UaewP+NMhoU3Bqanlq4AWw?=
 =?us-ascii?Q?ayGSH40gKGouNJhaiT3gVl2+0Jr2G9JmKWonXfBZfuhw/3aQPUlua76IIuPf?=
 =?us-ascii?Q?ZgMs9arpFAvcv3XNNyM7Wd8x09pD67gk8yDVkeNNeiIjnvGOaw2MLzdQQldb?=
 =?us-ascii?Q?QMb0EkpmEtwt9z0ySra87cgWieZZqNYuxP0k9aWJvZtAqCxjZ4V48TGLL7fr?=
 =?us-ascii?Q?AJQswj4877/Pm4Y9iV/5R5AuER9UpKBnjAQ9WE7UG7VeK/87T294vC9qUZcD?=
 =?us-ascii?Q?wkZ6dGGSoirwyS+YlXNn+Oyyp2JKL2rZpQkCcMFkXucZTKUXDJdQ0iwzH1+C?=
 =?us-ascii?Q?aBnzybel+IkgsPh8N9WZMQq3Z0AOCZLirr32fE8lR2/uej6ifgoPAr36HBcM?=
 =?us-ascii?Q?YipcBg6Wrr3egcW31QAzbU9z9LF6ucDSuQStnU1Rpri97TD/72K831VfDDfL?=
 =?us-ascii?Q?qLAubmgS8+suTbxkxWzw8SopVIwCd28jl7cNofi/Wwuh9n9egQPtbGP5yyVB?=
 =?us-ascii?Q?ZpOFqqeXhP9HcVoNkQCnzFQXK9NiS/58dhy/oGYKaNEtsF7RQvOpcKu0Rinl?=
 =?us-ascii?Q?Nl+Qu670KwyCoIXcNVakHnLAqrYfZWHGA7G/wZqiEOjASiQ4UIUtBNCOLNhw?=
 =?us-ascii?Q?KDzmdkR+aSarRa34cxbdxe77Tb2ZCJ8lDkl2NKNuNuAwVeP2TyD5TvNa/vrZ?=
 =?us-ascii?Q?ODBKveCnWNnvGNQLHykwktGjf9OVHzeKl1QsJWX64f9RxULTRhfT4DNT9NIS?=
 =?us-ascii?Q?hU8iNjaK3CX3vE7LBwROJXFlZQkNMrtTYOWbA8asMklNfr0GHfjDIGGTqosX?=
 =?us-ascii?Q?tlUmt2W8ANBkYwycQXX+PClgeKQIhFSi+CvWDa77H70baGZJvh8j9NRKCpEO?=
 =?us-ascii?Q?W9iCCaoYzxS6k5qlUZMaOpIwWmFGcCmP0NXj3v1JikrgF4CqQqs/a2ZN+4mH?=
 =?us-ascii?Q?qMDcBaSboJkhhUygCy3f9NraY7T8GqIYAQshd5EDgUx8v5TbN06McP1sYJVc?=
 =?us-ascii?Q?Vd9zzi1sfzom+a2z4PLQNGQiBgW5DV6eyxmPpPkRa4TlSwRvTNDIciqccY5H?=
 =?us-ascii?Q?bn4vMW1HGTVpHiftgmkz7rvd1DwTlxUhwJlyciBnxhm2QgwiNhMpxUaImflH?=
 =?us-ascii?Q?KbMYZcAi2zSQ2iovN1v/0nM/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf0b024-bd11-4333-e9ab-08d8ef2bdfa5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 01:18:18.8596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9idRj2UoTqVnWY/VC+4/4AEnIqPHxMr4zN0UDEmZfvOE2IJOIWTWL8Lk5Gp1MOBvVpoh+8dtw8G+AqZ8hY6uxx4Q7eodlXdEwJXXSqNFRs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250006
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Gustavo!

Your changes and the original code do not appear to be functionally
equivalent.

> @@ -1235,8 +1235,8 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  		if (ret < 0)
>  			return ret;
>  		command = ContainerRawIo2;
> -		fibsize = sizeof(struct aac_raw_io2) +
> -			((le32_to_cpu(readcmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
> +		fibsize = struct_size(readcmd2, sge,
> +				     le32_to_cpu(readcmd2->sgeCnt));

The old code allocated sgeCnt-1 elements (whether that was a mistake or
not I do not know) whereas the new code would send a larger fib to the
ASIC. I don't have any aacraid adapters and I am hesitant to merging
changes that have not been validated on real hardware.

-- 
Martin K. Petersen	Oracle Linux Engineering
