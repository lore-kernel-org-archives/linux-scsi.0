Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62247C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 02:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiI3CoW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 22:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiI3CoS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 22:44:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AC3184809
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 19:44:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMitrg026770;
        Fri, 30 Sep 2022 02:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BuKFVfkEDvJXOz8dlAzIEaWiS1myVlXlSsagq2p8pLc=;
 b=nwOHMhZmxx2ltKVq9xwmLDXM3BEC34zqssAHxRxcCbWq15awnK/DuT3Ti5ENV671PwmE
 BdpSETyqr/qaxmteeoxnJlBUFyzRARQrstar3C0n9I2ARFr86tRFrRluri/ysvhmZTzr
 BdbQlQAIC4ySezPYNrueVMldS9JXNlLG7UIyZ4KFb0GTkqFJ3Fux5/+V9NGnY+zSNexi
 sPu9QXIgu3/GwjrZYlaEOI2dh6E+NbcRZ7aZTp3kOhf35xsqrsHeS3t9jA+KuCvLSOrQ
 DGcLCaYVJ/kMawm1u/7HWTGFy/ZmhMlAAXJc2aeHRjU5NHQis9EJN94DX9E1XQ54l0Ti CQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kx9ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 02:44:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TNi56V033711;
        Fri, 30 Sep 2022 02:44:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv3gbkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 02:44:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C88lI3F7nt0jjVTaoFBDga2PaldKedPeBhXspywA/1OEtDrXpmscpZ07G3F8I1bIiadmO19171zf/i7iMO6XJob/uoSmOj2bnsF4KNSTN/u76/mdIrpFJlRD6gLBaZgqifzmSHt6+xe2SqGssPX5AW37a7qLaPQt2npcjXhEcr4FuApDHAO0ltGbmoffpWnI49aQ5RLOs5y2eb13Yu3y+T2h2JVw2jAgd2dW59ie64imlG6w01a8qst5SOQ0xXugDyadmbaYz7T5RCTiUSxAAqauasoGw7CfX3IJw+sVVcY3ERZDNW1R05/iDDC3tgd4zcwS5ZI/V3j6ByKjpMZKqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BuKFVfkEDvJXOz8dlAzIEaWiS1myVlXlSsagq2p8pLc=;
 b=P0lO66C27KB4SdJpaU3ogumad6GGnp+5I1Jq8jAZr7sXS7Cple5lQ5gy15eqSnaRas3033hsX1k5Ts5OAgdyIJqoUV8BeARNlkZBV4Gh2AAKNe8ACar+qXxA57ofpKJpsTt9IReidlnnaPtdEmQVQOSP8lt7pkgolr7OV5lr5gybNv215N5c5K6LDd1DL76JVR+GxCCyi4LU8TVhkCVztXNXtH1Fc5woCnC/FeY93Pnk3iq0QISumu2DeJ3NCbGh7lkjrvyBWRXHgVnofwmgbptoCY/LGSiYD3ctuZyH8awLV4XPETjOUYGH6SSIPer0SWgy3MxO1PcY3HzrO+r8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuKFVfkEDvJXOz8dlAzIEaWiS1myVlXlSsagq2p8pLc=;
 b=Vz5nr5EmLsWanAV1GebBPSUzVWc0aEKstoyHX0TRnCBNAHr2vQx0cjmgy+ssti5s5J8rrmpfzKP+8clDotQ0EPbJM52Yt5YDFe1MHQV1nU/M5vLxxXgVKhQhbbmksdFZSkkrDxGrKl/krMnI7zpgN8VE2rTjR875hOgv02JNiKY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5034.namprd10.prod.outlook.com (2603:10b6:610:c9::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.15; Fri, 30 Sep 2022 02:44:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 02:44:03 +0000
Message-ID: <9f501492-415e-f7fc-137a-bd5b96a806ed@oracle.com>
Date:   Thu, 29 Sep 2022 21:43:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 03/35] scsi: Add struct for args to execution functions
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-4-michael.christie@oracle.com>
 <046b3307-7a7a-80e0-e34a-9fb11171e241@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <046b3307-7a7a-80e0-e34a-9fb11171e241@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:610:e5::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: 1718ccdb-3db4-4bf9-c3d7-08daa28da2f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPY1hoXOV/7S0ry2tsbfYrvtkayq9Eo1RHzpUkCWckOJB+ikrrnWNoPFZv9vv9FSDayV6FvcuJZrI2Leqtsf/zPcbQP85e9fbFWMjLD5shPW1MWLTw0qVR9WQXBAi7WCjPCnBGQxsj+2zADk/hx2FSk81CChXQzdhkVL2tzKCldZ2z08U6EQ0u04ObAEX9+Tgl4Nqzuw/ElgpZyWvLh05/bAaewd/PptsFkGJcuFPMLjaW2IkWnK1bXJT6P9QCWnMKOuSWoH8ydml4U/I5LxWY5Muxx1xai5XPW1PB09fBoOYtDYj9mxoxX3VsScWpwNSB+4uXrLrAadq6CFIN9YSkmLf10vHw6GCJiKiMbbHDBdGl72CgBePknXfAyTBvgzsfdhgooWKxHSqc/ikclJe06tolckS+qdXzLIcRNwdCZE/IzET7hGs1478F1G/5nKbRg+H9emoFvNxhP5Cwyg9Q1wkepZXZ59kZhnML8IXhuDwihVfra7r2LL4TchKPVsnltUiBCwDGkRNpV+oPPIvnoP5tSlU/zXNDFY+ZjkUI2Y/PCAZvDd/iUr6OsNWk0UnDzmDGdSuuyK3eEEMKvGDqn3kOEzzI5A/XwKOkFqMh2vSuDHyq1JQh22lNhclgmdSkJspsl4VOANdHYfqEi+EBZNjJmm7+tY8JaDF57DZvwl83+bjvNQRuFLbhnzhdX2A6oSrLvJFGIl/5UXpIh7T4r8FPOdjc2IkUrRBaimashiZkEHCG5WFvFj9MMRjzxZz6h2ZDW9GTQuAjcryig93kHsrBTrRdRNOEr0PPnSkbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(36756003)(31686004)(2906002)(26005)(53546011)(86362001)(316002)(6666004)(6506007)(6512007)(31696002)(38100700002)(186003)(5660300002)(2616005)(478600001)(6486002)(41300700001)(66476007)(8936002)(66556008)(66946007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzliNytOK0tDNUNPM1BORWRLckppamtVVU1vZXdIOUJ4TVFya0J6WExMTzNL?=
 =?utf-8?B?eExqZEl0QjEvVERyZHZYWW9ycVNGTXkxNkVMejAxSDRqOEh5bnppOHozdDQ2?=
 =?utf-8?B?K1h2eVZWM3o1L1M2cjE4cFh5QlFrY2dLNnlNWW84aDladFlCeERscmxEOFhp?=
 =?utf-8?B?L2trYjdEZjJHRm1kVTJOUE1WNWdNV2p0ZEJkN0l2b29sRzR3WWpKRkpKYWV1?=
 =?utf-8?B?YkExOE56V1o2ekJPMlUrSWFrSnIyWHFMOFJacUR0cVJrSGlhbEU4KzI1RXo4?=
 =?utf-8?B?Ylg2YTR5T3hKbWpQWE1GcUs0M2dQSFMwT0FxMTRZY2VqSCs1bVpYY1FRS0hW?=
 =?utf-8?B?WVdjWVI1QzZGR3AzNnhNbUJ1UGc4QUhzQzZ4aGJ0RTMzaG5kbG9iQzgvNU44?=
 =?utf-8?B?M2ltdEtQNS9JVkNBczdiWllNN1lRUlhOcEE4L2k0TmJtLy9wTkJTQjhtazgw?=
 =?utf-8?B?UDdGaDFJNmpWcnFLYXNIUERhYU9HMzBKUGM3Mzgyb0Y5V01HeUFLWnFJL0lB?=
 =?utf-8?B?aFduWkYvQWYyZk5wZ1dPNUFRUy9rWjVQYlkxcG4wSThXazRQRTh4NkIyZU5j?=
 =?utf-8?B?YS9DdjhJZm5oN1BNTTJ4Uzc2cUtBL3BEK2NkMU5CSVQ5WEl2SlAzMGxpRXVM?=
 =?utf-8?B?enZPdGhySVJBb2JocmtZL016cm1jN3RiMjdEQ0o4c1BIWEhFOXdyUjdzcmJ1?=
 =?utf-8?B?a3ZxNTdxSlVLRmZla0FHRTFSdGNkanoxTUJsNnlrTVhyaW9pVytZMmxPcGFS?=
 =?utf-8?B?RGlSanZNTnUrS1FEZmZLaGhYVVB5VVl4cDdWQjZNY3RKNFo5WGlEOG1lZlY5?=
 =?utf-8?B?QlNJMFMvSkdwMEJoanlIMVpWbkpRS3NESXpQSG1ScE9nV2NUWFZaenBlK3Fl?=
 =?utf-8?B?R1hpOXJzYmhZeUhaOGpyU0VyVU5Fa1ZyNi9xdmtjayttcTlDQ3lmWHU4OW5D?=
 =?utf-8?B?QXVTR2JYRmQ2VlFrL25wZGpLelJ6K2pReHhFd2NFOUtoenN6YTB4NHVGQVJC?=
 =?utf-8?B?M3ZzaFhwSkpHaXBmMCsyTTl3bWVkekg4ckJJem5xN29DZGcwZ1RKc2FlODd4?=
 =?utf-8?B?NlVVaGlMRlpLWXZ5clZKeUMxMzRFSjRIay9Qc09pdnEyM3hCczlSSVVPMWVI?=
 =?utf-8?B?cHNOWDNJOE53eXZqMmFnd1Zaa09PQTUwY0cyUlVmRWQ4RmIwYTdUcXFvUEhE?=
 =?utf-8?B?eVEyVzkyd05hbW1XZWdMWUlROGVkTDVGdTBjM203bVdDMHAyTTRCM2dQYndq?=
 =?utf-8?B?WS81ZFN5aTJyOFNwK0p6RzV1enJGd0RvT3pNbDhyN1I2cnhvdHVGVlh1K0FT?=
 =?utf-8?B?WnNmZmdUTkF1a0FrOUU1bHFOS3VTWDIzSlBPS0VETjAwNVdqSGFnaDdYUFZp?=
 =?utf-8?B?TDRvdVhxR1Y3NUlIdE1NdjVlM3R6SkRJRFlGTlUrVzlzenN5dzFVYTA1eDhQ?=
 =?utf-8?B?ampjWXZGTUZ1UTJLTGd0TXVMcjNGY2NlUU9LZVQrbDNkS2VIRFRhdFZUd3pM?=
 =?utf-8?B?ZjBNY3h6RDlIQmN1dk0xSkt5TjhGbzdmRk03ekRQZ2lON29aTTJnT3hHNnJx?=
 =?utf-8?B?K21JV0NKNmZsZHBLaGhjWWtVRFF5UU80dlNydGVDKzd6QUdhV2JHbndFTWFm?=
 =?utf-8?B?M2s0UTVoWXZmNzlPWmRVS3grVkppZG42SnAzdXdYd1NDclhHWUovVnQ0aDhY?=
 =?utf-8?B?S2tVUVozWCtxWTU2QWZVNTBvZ0JvaktQdDdzNE9WSFlQRThUc0pXN2RQMmJM?=
 =?utf-8?B?Q29xbHEwcmlrMGd3bTF4b0lKQ1d5bXlZTmJTSlNqRXpFcUVjb1JBTnZxb2k4?=
 =?utf-8?B?cHo3VVc1MWJZeTdWU3BwMmRVaUxWNDMrWkZVZXE4d2J3SWdQSUZlTEdZQUtY?=
 =?utf-8?B?dkhKSmR4ckpuQW5hdlpVNVZQR3ROT1dXOGxBQ1JCNDNnQnQ2ck9reUtvN0U3?=
 =?utf-8?B?d3lVVzc1REFPSGJPb0tQVGRaczRhRm9SVnBYTkJ5TlAxN01EYkoxVGI3Ym8v?=
 =?utf-8?B?Y0V4a25XbnRoNGh0bG1RYllsRGFXaVdyOURkdXNPdWlvVDAvWEhrQXpibGJi?=
 =?utf-8?B?RlpraDd5QnpHejZsanloZjQyTWNRaEVBekdhSGxGSFBmKzFoL3ZibGE2VDR1?=
 =?utf-8?B?Y1BCNmU3ci9RVmxDT0pieXQvSFZOeHZ1eFVzRHNYMXNzOXV2RDh5VG5nby91?=
 =?utf-8?B?SWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1718ccdb-3db4-4bf9-c3d7-08daa28da2f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 02:44:03.7197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8d3trBS3F7WgOnKkdg/eTuAgG1mYzrtNE5dLSgEo7GEeDkKfVAR9svRGuE3DiqtoXTCMFDTQGkuywud3cMMZrl944nsAsZ0sD96xwJjJqGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_01,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209300016
X-Proofpoint-GUID: lcuTyf5pzGWwVj_uAsNm_zetWHMwzQOW
X-Proofpoint-ORIG-GUID: lcuTyf5pzGWwVj_uAsNm_zetWHMwzQOW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 7:12 PM, Bart Van Assche wrote:
> On 9/28/22 19:53, Mike Christie wrote:
>> +int __scsi_exec_req(struct scsi_exec_args *args)
> 
> Has it been considered to change the argument list into "const struct
> scsi_exec_args *args"?

Yeah I meant to ask you about this. We do end up updating resid, sense
buf, and sshdr, but because those are pointers I can make it
"const struct scsi_exec_args *args" and it's fine since we are not
updating fields like buf_len.

I was thinking you wanted fields like cmd const though. So do you want

1. "const struct scsi_exec_args *args"

plus

2. pointers on that struct that we don't modify like cmd and sdev also
const.

?

> 
>> -#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,    \
>> -             sshdr, timeout, retries, flags, rq_flags, resid)    \
>> +#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,    \
>> +             _sshdr, _timeout, _retries, _flags, _rq_flags,    \
>> +             _resid)                        \
> 
> I don't think that the added underscores are necessary. Has it been
> considered not to change the argument names?

I can do that.

