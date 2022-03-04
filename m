Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15318C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 03:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbiCDDqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiCDDqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 22:46:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEC017128D
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 19:45:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240c5LZ014127;
        Fri, 4 Mar 2022 03:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VfotzsBFybBo1/2Bc8vl/zW720ItjET2yEYjIwmrz5M=;
 b=MRNKvtuAwzszxNQdsK2EMBc1Csv+Zf+PmATs3T1C97CwvTolT+O97Bj3WD6zFVp09tVO
 5peAgd7vBbM2+MTWmC+8YwdQsD/mIO39rjGUSZ2UknuBMg/+szAzpM2zHxOgcwlo49Cq
 5oNeQOnn8lXQQDltNFIfmnfTXJat7eiqQd2OABzwHOpWbB1bzcJF92BGyFOLl9HUG1wk
 drq5p5MGdjHgOxgyRuAzRerwJuo5FImFsOOzTQ7xmbqdN+uP2B1zP91n8lz6xjD6LNqS
 MPR9ZEpaPncMpBKwK7DLGXOvSjOo/aJuJXQvqqkzO4s6lyVeLgKxbHbDsqddDRv9QrJ+ 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv8p0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:45:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2243aD9U108011;
        Fri, 4 Mar 2022 03:45:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3030.oracle.com with ESMTP id 3ek4jtg5hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoA5lnV7FGUXBC6QAl7/niRb+qGHuUO1C1YjznlTXgRjtvyLDoutCQNaZdoVbfpGX3VgQLzfIpKULkQfIcBfGynctYi6lWY2KZTVqNbDFG1AR8tbV6ClC1cKkL66x4esSsPQ+T48tlN2O4zQo7MiP0pga+pK6gSHYaNsBrWpFuYB0xVBroU5X6t9PbR8KTpOqyMk/n8WYt4HBLs27yrdXJIvCmhkhNQp5uMerMFd8DiSSW9lwbOWA2AUMiWoMY60Y6ZG+gfuNABMi+foZrWkWLZoMP+QoLqT5TNZ6vvlrn46F61ZxarOL1lqYBG4ScSsJjlhS4eEEuCrmxF/XM9vWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfotzsBFybBo1/2Bc8vl/zW720ItjET2yEYjIwmrz5M=;
 b=TBIp0+tZrTuRCvxrhc4vRpEfcIJdQdXMBxFLFt2wuXQBWwlKKv0U2nIUjhDOAm6BnAGMX66uyF5m4gGhkRZQLHDOtkVlXj9eFxbMfiejdimi8r9ybrwIDuLxjriV/JoKb62lDj/uIMKCKgV599S94uEpb0nSa7tGOdpa/Ikd9iYxJMysPKQeYMAhaDTHupIUZunMSxF/G+1jIi2vpfs6KZ6g4ibbw2vpi32pajOEmEHP+hg2xiuKLsYAYRX0lPWIErWOUsT3cxE+FLjiTmhoy9UYOS1AB0/ZMBnaQApz7TjVUGxKbfVXBKaJqYUdbrDd3qHa1xpVFNDV75a4vmAgUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfotzsBFybBo1/2Bc8vl/zW720ItjET2yEYjIwmrz5M=;
 b=YD9ClQ0yDk9O8wgWQF/C1YBcSNEZQu/yNZfqLkPoEfcaA7ZposLB57EFRdbaWsv27TJrAJTPiNDY7RrT2Q8eOz+Ien6uQEohS5sB1Tw+No6bN+OmMXCnL7hjSjayyOW0Ok5/fCzxLnsVG1hsVSxq06dddgHnaV5XYWERcDPPXxM=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by SN4PR10MB5541.namprd10.prod.outlook.com (2603:10b6:806:1e8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Fri, 4 Mar
 2022 03:45:42 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:45:42 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bernhard Sulzer <micraft.b@gmail.com>
Subject: Re: [PATCH 08/14] scsi: sd: Optimal I/O size should be a multiple
 of reported granularity
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkymtmbp.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-9-martin.petersen@oracle.com>
        <8459576c-3f04-14d1-24d2-0edfd814a454@acm.org>
Date:   Thu, 03 Mar 2022 22:45:40 -0500
In-Reply-To: <8459576c-3f04-14d1-24d2-0edfd814a454@acm.org> (Bart Van Assche's
        message of "Thu, 3 Mar 2022 12:17:50 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f9edd1-b933-4e0f-c8d2-08d9fd9174e1
X-MS-TrafficTypeDiagnostic: SN4PR10MB5541:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB55416672D7BFA0514D1A26B58E059@SN4PR10MB5541.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6z/bB7I8OnnPojBU1Z6k5hFx+kuqq6qkPC3AMw0oiV9cOO2KuIFA55hP921tM39bDnla/elOIL5lhCs298iUS1rQTJ/IPwlJVF5yEk0UMSJM1lnwGNIi9vHPXnxSwDrksltE1P53jfxQmeB8fYhT6YHxcDWuVJ/gmrWxQ/ae1rn6Ng08g8EsQvOnSSuv1VzZO7O9x3ZN+AeEjfjXlpKAiVrHHtUzAf5VRwDDYlWL73rssWycn2PpOdVmPUBoREEM/E6920HaRYNcpcAo8H5nytOoKXzDdm3u/X45C8i9iSOa8wXkJdwRMOJ2WqGdvBAQ9tZF79ao0+og9c5sjsadqIZtp1FiWLz58QE+Z2u3awzFEsJGwFhl6Km8Pdeeclj9S/kQuyOLFVvAGZ6AtAKP2jAV/Y17eCoJtP3PwUqgCoay+yqw34oWPCWwoR1mLlC4sqroqy9rDFxVhc9U5KjNNArw0G0MFPceSoQWjrQjf4nl0eRKJ8mbAC9RpNeKjWqv7P2qbSWeHRM2X/T7IpVPzTfK9hoX7IXEpwDKThnySzjquXq7Arx5fCa+FpTH9ah3Q8hI/T6Noc+JeXUL4Ok/nvnf/+68hqs31ab76Q2DSRKstnxpSrIqn4Wv7x/jRZ6UbsFsWXk+XTjCmZiZ7NgLoo3ESrlHa6Hyf9YZGp2lUNcqE/VXgeJlzC6ftN77b3NAl6IumIFldLMZdeBrnb6aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(38100700002)(508600001)(8936002)(38350700002)(186003)(26005)(54906003)(36916002)(52116002)(53546011)(6512007)(6506007)(6486002)(6916009)(66476007)(8676002)(66946007)(66556008)(316002)(83380400001)(2906002)(86362001)(4744005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LB5bSu7fu6D+M4Mrkp/Tq6Fm6SzPKkPWj0lfx5kqvjk3/1B3VJKMfhRaNzMo?=
 =?us-ascii?Q?eBsrEP0FBlaEunb9sM3vkVhVe6awm5H7h2l/ikrxyk1XEofdV+sMWCHnVi/Q?=
 =?us-ascii?Q?CZLczB0sjio97BE+sUq24TVzzJY1HZl16L3Dlcpc4RkOx2BgVNmEYLHaYTEh?=
 =?us-ascii?Q?mmMfgCE/t/dQALdCqPGYk9xVWAM/Q9cqiodVUlxq+6/SWaeKWjwM8KVpe7lQ?=
 =?us-ascii?Q?TYLcDhzRGYQ9nYLck6V3cXVgpVT414u6Ja70snpSyHMYSxSPla7ZXNiDlFG4?=
 =?us-ascii?Q?np7NlR36rtlbru6lcQ9vgue9pHl+sko1N9cbT+SVhZl2iBOvKbYd3z3Rfu2v?=
 =?us-ascii?Q?ia9lu7QJRLZYp+HZpjSemnwk4vE+hE26M7Y9CY2afy4wexKU0UYedl3Hg7HX?=
 =?us-ascii?Q?OBM2fzOcJHZu4QSadmq8NpNpyMrjJT8+XygTFPi47ugGFbBhzeTma6KTZ4p9?=
 =?us-ascii?Q?qGfmG8r8k9+E+gyhc9Inqua6Qvh3W466JgweTX1btFye/00qB2a4K/+hd7lu?=
 =?us-ascii?Q?xlyjdAd9I2JKpXXBVgLz6BDX4e4atazrThwbcKLz0xHKVbz2ginJobtifzOq?=
 =?us-ascii?Q?fQYyqVybE32/SaKGjAhp0l/ppbyPrCcrX1QgflRWt8rkEaFSmQC4qVRwDETQ?=
 =?us-ascii?Q?41N2wa5CxwD9BIJItpV+LnbHa/Oluty+WbZJw0ZENkDoH3pG/ZqNk+EDo/nV?=
 =?us-ascii?Q?uVdIPgfSQLNdEda7vEEAqFJIfQSOw9VffhsifuldKaGWQOmsRzcgrGr8U/Sz?=
 =?us-ascii?Q?v2+xvigoShNbafwyWpKTlD36NwZd3lmGvi/mktHQMQ5NiufSKgJqDXh8A5vH?=
 =?us-ascii?Q?aHPItG30HmVCjM3vF886SpyFj/HM/crI3fesaMcR+sI3cZRZoI4Vy43pjWfl?=
 =?us-ascii?Q?75F36NRdfy98H89Ova35EZabISDj4hPymUcxd9+5d7gJHM0nWMfpJwwoFXzM?=
 =?us-ascii?Q?iD4jiI3cfqS0N7edFmlEcZB0d7LsRE2vqu4+WIEuZZXEFToEmpZ9fG+O/RNW?=
 =?us-ascii?Q?DEI4ARkwRxcb/2isM+T8Q+NN/D9ylwdXtHoF0Sp13wLyMDhVIa7FTC65IZ+h?=
 =?us-ascii?Q?5lw09K06bbmd30IWnxBcxhI5C4R2d8WKGsWvxRaRdAQ3977pIyuDc2lpFKN9?=
 =?us-ascii?Q?HAO/LY7Yx+BiDDEIz1qtHCwtI7fBuRNEdOpYN/b9GxzdaCLzYFIwc159BcYw?=
 =?us-ascii?Q?Wr2Fk9CtHmv+D+D9pTNSlfpzjSy24CASQZTawh/WD2xjjScRQWy31LaJVFFm?=
 =?us-ascii?Q?femfowTue1yBOX5F5j6SGB0/ZP7ywup+QRctsylLGV2J9FFWesWjvGNf7bcl?=
 =?us-ascii?Q?/N1XGR3OyRVrtZ/loRdAdmsaO/ZvuehhpcrTO4HPvz2rzq4WdpAG2vsaudNh?=
 =?us-ascii?Q?AtHugP3/ep2VFnnZ4MN1/g+/Dg/pAraa+hudZgxWy1zu/pNfdMod3caIYj9u?=
 =?us-ascii?Q?NHYLMIxW7xXqpp9WEzxWJk+qMtNjxf9Fo0aPxEJzWmXXzdSMM9yoNoooHXwU?=
 =?us-ascii?Q?AqyXhyopscvM5SZGkm8t3KFDTmT57RizM7HcE4gwrS6YrFHBAHbGevuxEzAn?=
 =?us-ascii?Q?M07w+PYBWcX20Ya766WkPkIp5VzPbt+bH/YnqrQjHOka6mIfgZPZSIuBzg0e?=
 =?us-ascii?Q?o2+OFDaSlynpekeqqD6PUzRaASTpTPcOiHeFbpotry35H4+g4f9NEQBxE4Ne?=
 =?us-ascii?Q?P5P+H7RsIa93Zpf42k6BHKOxOXg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f9edd1-b933-4e0f-c8d2-08d9fd9174e1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:45:42.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDnqDnlQFZrSRTM3o+IsiVeEB1qQlnJ9bbkR2De4K4AJwsnXZH108u5SmvOfZsQkAMQzbQ+kg1i7TsmcuWAYHVPnsPh0kTyPDcXhC5P1E20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040014
X-Proofpoint-GUID: R-Gt8hF5j2BEAhrStq_2l95hkfEmD3rc
X-Proofpoint-ORIG-GUID: R-Gt8hF5j2BEAhrStq_2l95hkfEmD3rc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> On 3/1/22 21:35, Martin K. Petersen wrote:
>> +	if (min_xfer_bytes && opt_xfer_bytes & (min_xfer_bytes - 1)) {
>> +		sd_first_printk(KERN_WARNING, sdkp,
>> +				"Optimal transfer size %u bytes not a " \
>> +				"multiple of preferred minimum block " \
>> +				"size (%u bytes)\n",
>> +				opt_xfer_bytes, min_xfer_bytes);
>> +		return false;
>> +	}
>
> Hmm ... what guarantees that min_xfer_bytes is a power of two? Did I
> perhaps overlook something?

Nothing in the spec, obviously, but I think we'd have a lot of headaches
further up the stack if that wasn't the case.

Do you know of any devices that report something unusual here?

-- 
Martin K. Petersen	Oracle Linux Engineering
