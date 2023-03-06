Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5552BC678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 14:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCFOl5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 09:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjCFOly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 09:41:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1C744B9
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 06:41:40 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326Cwo55008330;
        Mon, 6 Mar 2023 14:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=h0z41Zn1zZ/cHXS4DVuurXtGbno1xeD2Ps/4sZEUtks=;
 b=lhzdE/QYHnf+6rKQd+Aphbh9Ts71skIcPf7zzf3FAQq2qNqGhcLSvo+bDbkei2Dvq2hg
 Be5bQLTjdy4rjc8Pdbj3FEVsMoXLaUC2b9QYnrn3JqSrxGyCivsLPrN5BKd+URWmoB1p
 1rqrBJ1w0m2evFWRf/68umrPFQYGLn6IMx/c9+cD5WScFb1ieX5fH1ev0zkS9FJbCriN
 CYk2sgRr9+oTnxV/IzT5A96ITKdcWDq+WkNAgBv461+v0ERSM3GTwEpNeprzDAu8Pszx
 WPexW+DOhUlzEJg6pyt393qiIRlsbumD8Y8eP3OH7zj1PXp7wbIU6cPODu30ssGqWhcC SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168k0sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 14:29:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326ERnCU026620;
        Mon, 6 Mar 2023 14:29:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u1djeg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 14:29:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeXDVsw2hNuF7fKSuhel+lBqNXKjauPFkXPoVgllkkFkUPpaalBbhZD9EYtEg8cDLXbh6sR+yksNiVV37C+blOOiip8U7d9RlfNsnKsfBJiUEmlKV1BHi9O8m7MsOc3doV1xeJG7cNiqBhZEBiNuXWEGV+HF+07gq//QP3tMsesVS8in/9Ha48wjMtarTX7B/MTFnDB+TbvVP4xv/HbjLg/bkjYPT+xAYTSBsMDon3QnO/ithMxjbbbM1rIzBbN8CkNtHwEzNxdeRGEqsSMF5V/YmngKrShgNPsk9My6nYBKYrnQZQ67rpzOkAxTbsZUukMEZ4Dga8pVKZPxZcHvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0z41Zn1zZ/cHXS4DVuurXtGbno1xeD2Ps/4sZEUtks=;
 b=Hxw7V+Hv1HqRnyDVomxE2Oah4N2dyGXlz2vAGSz5cytFS30BeixZ0sFeTQPPeUONI0iZc4fTU1973/4V9+ix6UEG2FsvXhqUt4O7TUpWWfffrCwOWRED/SFkIDOqXOFTGCHhzmanbaz+m+Uwh9M6bG7/GvGaDX/XijXkNNcwWju4lQfnTtbDXiHXYwrIgd/75n4pvbNT1nBd1qK1YCKXlEOoMIBY7uJG8fXT4LrT4RwdDTe4/JKpxIMSjDj2BybzStvSB2uvNXV8QXfd5sJkZQFAI4yk/Kk8vCzcFmb4oIUD2rq6dzT745pXfUAxFZINJN9qvM8lScnmHXt1Ap9EJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0z41Zn1zZ/cHXS4DVuurXtGbno1xeD2Ps/4sZEUtks=;
 b=U35bmcKxkNZOmPNzwLxxwJPNhLjN7crqxdAHeKQtZuiDaXXxEOiv+TaOZuwcbU0aEDwfSGeE0PMVaPn4iv6qMYDthC7Mhdxaspa71mnBiugzwKinMbfaOMtEoCZAKV7OAUJUtjiQ6lZJ7jDHvCx/CcjgD9ouBEic+T/5lgV9KmU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7347.namprd10.prod.outlook.com (2603:10b6:8:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Mon, 6 Mar
 2023 14:29:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 14:29:32 +0000
Message-ID: <495d7eeb-bf5c-8333-1945-2ab1614f011f@oracle.com>
Date:   Mon, 6 Mar 2023 14:29:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template
 pointers const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-3-bvanassche@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230304003103.2572793-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0295.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 2931f5b3-bd04-41d2-d427-08db1e4f3395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S69juOkjDxZVrdt2+zeAaZLUSyzpYW+HDK4TUIRXiB3C0M+fDChLDx4Prvbha3BdaBO4Ta7j0sFxqOMSiP+wLEk4JEaY3trAzBVdRSD7Y1CdsKBzU59i46R170Cxc5pj3XMN8YZGmu9Sq1MtqyW/iuvDIOO5dgPPv2YmLQmDQVix/kRcs5zYH2sEwM7NKc2zZ+u1eELfYV0mAlmdyReYqYhL9NPkAERko5Qtu7NT1jHuBOLhPfL1JfXwcOer/PV9qZZWd7b2JcMhB1ec935JZkQUR76yNxfOhuWHonThbI0RxELaYjiZTfX0OpXuJ52rzNiJzRJ4XGXywDAQZkZV+Aw85MlkWwh/u0RJ9FV7sKRgZiMmppr1hkPNvSbHK3B614m9dGNvPD0ngaAsR5V71XMD838GN3cus1m7INPqOjEYTzS9d6zK0hzvc/xTj3JY/SfV0XhXU8thzgP4vqPb+v5/Aoao3UNEk6XraZcajcGgSMazJn2zH33ZMs6iRCfs/UwQWMl6vknxlk/4z+fvPvv9K25ttpqc0JsrR5b/OajMOfIu77rYkZQBCOfeT9OlYnZMRN9vuPj9FphesJ4YeQUa58FK+7s1dPQmiCMkLJZI8kAVQCxriV5klQrzyXZCKc34jAZOQTImjNlKztDyF3U5uxWzo7tQFgWNqBk80ZvFx1mAsueMhHweJn7i24B6k5bEbUIKso0g01xMAGgXwYi6tulcj/Jlv0jQIbS8lW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199018)(36756003)(31696002)(86362001)(66476007)(8676002)(66946007)(66556008)(4326008)(6486002)(36916002)(316002)(5660300002)(6636002)(54906003)(110136005)(2906002)(478600001)(41300700001)(4744005)(186003)(2616005)(53546011)(6506007)(6666004)(26005)(6512007)(8936002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T21sZ3p3allqcUIwMTMveEZWRHE0dnVTWnczdEk5SmlleDZJUjRrQ1FRdUg1?=
 =?utf-8?B?bHN2N0JHc1R0M2kzMnFHSFlsRXNyVWsxZllldUFpWS9yTWxwU3EwaDRwVE1j?=
 =?utf-8?B?TURiTGV5dVBwMFB0SmVnOFNoSG1uZ25SNGhoaDdtRndISC9vODdzR285SzBi?=
 =?utf-8?B?UjVWSDlTYW9QTkRXWXlOcUYvV1h2L3Mra1ZVR2lXRVlCZnJMSjZDRlJHaXBR?=
 =?utf-8?B?ZVg0aFU4elovRjZxL0ZmOThISE5raVRUUWxjNlFXbVNuV3dBRHBBM2FpcHdX?=
 =?utf-8?B?RExWV2ZSKzc4QkR5aDlzRnd6Ni9aMHVuL3B0blNFZFFZekJmb2xROGdDNWY1?=
 =?utf-8?B?SkZ3N3BuMXZwK202OHFqQk00cC9iMEU2elhzWlZvalZZMjdEd2E5cWlZV09M?=
 =?utf-8?B?aGg5dUhQdk1vZ2VSN3hOUjFiRUM2dnJKQzNaVlNpU20yVHBNOG51SERBSGhx?=
 =?utf-8?B?cW5rSk1EOU93YlI5bys5SjBpemxwcU1RYllzWXdOQVo1WmQ5ZWZiN2I1YURS?=
 =?utf-8?B?dVVzY2hxdDhSV0dpU3BwMFpacjJjaCtSdlpIZDJkQzBPd0YzeU9rdm5oM3or?=
 =?utf-8?B?WlU0R29tNzloeE5xRllZNkJoOFlrTjJsd2Q1SEtPd2lYZzNLWCtIYlZQeVVH?=
 =?utf-8?B?UnlORmorTTgydHJhM0RkSDBqbWRFS1BjUFFnN0V1OThxRG9hTkFvZDcrdlp1?=
 =?utf-8?B?UWg2YmhZUE5nRWFKVU9WQW9ZSFBTVHo3blBKcnhkZ280akpqdytHSFE3dW9m?=
 =?utf-8?B?cmVNWDJTdDZTYXFGUThHeCtWaHZvVUpUaTcrWWJITHcrMnRBVVRBU1FiN21a?=
 =?utf-8?B?emtMZlhLenoyaEpOQ2tSVmFTWWJqNm1HU2lmSTBNR0I0bmIvdzVCU2tXckpw?=
 =?utf-8?B?ZW9KQnF1MHE4TDgrQ3BwcGc1Umhic2pSN0lMTHRyS2oyWlhNdkpyeVdmNzA4?=
 =?utf-8?B?TU9Lc2FxYlh0WktkeEt3YndRbHM5b2JRbDVrdCt5NWczRUREZTd3cXk4QldH?=
 =?utf-8?B?NENJMEZkaEs3L2diMjFVUmxGUnJhYXMvM0czVE0rQXRsbVdmL2JCZlpETUpo?=
 =?utf-8?B?V0R4dnM0UjJ3ZlFLbXQyZC92NWYxTG5pdmh5OW1SL2dqN2xQOFNBbmJxK0dU?=
 =?utf-8?B?ajNVWEI5SXlqTXZyZzczSkVINVlranA2TDRGQ0RQZXowbFFNWUUrZXQxRmV0?=
 =?utf-8?B?eUlWdjd5ZjNCclV3OWV4eTNHNWdvOGJSTGlxRzVGeGp5OFY4UWMxMFB0TGNt?=
 =?utf-8?B?OS9mZ25Idm5TaGttR1kzamJObmZoTVl5U2JRVCtJbjIzLzRkRkk4TDc4VDVu?=
 =?utf-8?B?Y3VzYjdyS0hGc0lYc3YvelFkWnlEdzRIbWJqWXdMRC9PT0Zwbmg1RVBOajFM?=
 =?utf-8?B?b1I4cDd6V3JjdEF1alhnZ25xdkVueXhzckl2NmxIa3ByWFZNTTljcUxIOXNw?=
 =?utf-8?B?d1VjK0hBNjFIUU5tUlVXMGY0cHJUQ1N3Q2ttekRObjlZS3g2QVllWEtPVW9k?=
 =?utf-8?B?K0xxSitNeEdxVFU4ZU1RQWZwOC90aWIweHAwdk9oTytoSUpwZnpjTE9kRTI1?=
 =?utf-8?B?c09icU5IUWpGcU1aN0YwV05pd0lWVExzS1V3VUJQM0wwdmhYc0ppcUNFSjZR?=
 =?utf-8?B?ZHRoaENVZENSSVdNMThWWWx6V2c1VC9qRFhLa2dtTGFZUWV2TTRBb0NLTm9j?=
 =?utf-8?B?Uk9vdnR3UmdiTWJjeEtHcFZSSlJnREhNa1R2QnpzdVYyMllENDJwd1NlZWox?=
 =?utf-8?B?YlpzMFc2WnYyOHdBZnJ4RDc2ZWlmU3loMG53NlhaU3FLQlA3QkNaZHNWMU5O?=
 =?utf-8?B?VTNXY0NTVC9Qa0c5enZqYTkwSytvaFV6c3VFQWRtcytRREpHQlBlUUJmVnhV?=
 =?utf-8?B?TTZpK1RuOWNOWGJoKzFkUzdKVVFydHpiZUtVWGV1Wmp5NElFZVZsRWtiYy85?=
 =?utf-8?B?dW56V1laU2pjb1NBdkJVL3RBMzc2RElnUzJEbXFHdVllR1RHbkdWWnRtZjgz?=
 =?utf-8?B?V09idVFZZnhhT0ZyM000SEV3M1NEYmpGK0Zsenh6TlVpYk9LQnhsei8vNnZ5?=
 =?utf-8?B?ZWpHNFZjYzZ6N3ozbWxPcGRGYm9SaUpNSlV6TEU0NmxJWWpDbkUxUjg4aEh1?=
 =?utf-8?B?K2N2V1VVV2JqZlBlVUVNWld4Q1h1VDducW1Wckhkdnp1dVNpUWFwd0Z4OXlz?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JffPyiYtOEt9Tm9qMXm79pSkAzHkiACJV+s6vMCxqswz+8Wk8Y1EmnTAVi42/dZ//m12Wfzv+LSmdDpv4n59YtmDFN9ZO0P6XKCFAaLpvSRoT9sCQeTRtr3Z3DtxDmYjMP1Zz4hXgjG82LT0fUcy2pcxGaZh2LUxvqh7SAFMfUmQulquJc2mjefa7BcJ1k75R386+PVSac6ZSPjkiFvhDRZvHVOBjtzrq3EgPnXxJ8Q7Ki1JQp1GwEM0Hr8k1eCJwdngGHGX34GDICKoVpqOF01iFa82taag2gG4GHv6squzGj3VikhkIDsN3KbLczRPt1MLzm98FO1YybcSUoUYjHCflvRagI1P7AQ7MFIr51IohOuX2apXJ61GxWBSg1V+RtSX4XxEcVwkBRyu5c0pfNIS1guBoTOGAhxHZfE+qfgcH3K2BWMGoQ2dh4eBZVEhx9w4D1qzaeUkbGlDqXTt+MWpdQOPgauL069ngjd8HqiU6c+cgrJCBI4eFhrFT1Asxk/1l47spHrsKwMBAIbc4WIoxfSh9bgD7HmZRt9dah3GyxXyTAsLIu1wHIGMAL8aIN0mji92EVHI2AucwDeNgfw31f4H4meC2HXfFwxUWY2E04R8U4ycunnUvU/Z+SHsDMHyU4AQl6ATeTKJM+9TRtCDjwzRRabRJu6wqEmaM8M8xxuWtO+CNeFjXzVrRd8h+kb9+4ySzgJhBsT9vNpRyoJmiQZvtwQIOO8Qz0I+Z/b2iIS5TYx08x55hmYdSY59FNom+x05tViqdWdgGCS0MPHvCmAbiqLjtqmljCBV0YZbt5nqKVZQJGj2Lg8ZyTTu0Or7Xt6a+RkRPwHWEgSXzfH/Ul3zuTjBdUZjCAUeU0uYskEM3h/hR92ijOmluYd0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2931f5b3-bd04-41d2-d427-08db1e4f3395
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 14:29:32.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLsJWqZGAa00DwGiU7ck9mKnN2MWrMcdJVhGygiHnZeQdMnaQN27hvQTuqhR/WC8+erc/fQ5o91OIyn7CwIWNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_08,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060127
X-Proofpoint-GUID: f_n_7RWdGFQ69Z_s726G-iDc7K4pN-lq
X-Proofpoint-ORIG-GUID: f_n_7RWdGFQ69Z_s726G-iDc7K4pN-lq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/03/2023 00:29, Bart Van Assche wrote:
> Prepare for constifying most SCSI host template pointers by constifying
> the SCSI host template pointer arguments and variables in the SCSI core.
> 
> Cc: Christoph Hellwig<hch@lst.de>
> Cc: Ming Lei<ming.lei@redhat.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Cc: John Garry<john.garry@huawei.com>
> Cc: Mike Christie<michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Hi Bart,

You wrote that most pointers were now cast as const - which ones where 
not? From a quick scan they all seem to be const

Apart from that:
Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks,
John
