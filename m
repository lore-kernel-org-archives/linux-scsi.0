Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77622C47071
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 16:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjKPQir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjKPQiq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 11:38:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372F3AD
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 08:38:43 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGXrJm010037;
        Thu, 16 Nov 2023 16:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=PI5uaIPl9cq/qnrK+LlY+ygDET4lMeXlxNQKCEfN+Uw=;
 b=eLFkMCYuQ3iGZ+wYUDbtlnKZdfYxCcPjW0yb0D5OaprQ6u0KBTKQ8a2Gf8n4sXwX1igT
 0ixS/Myjx040wa+drBXXhOxtOiikjg1xMhAnpr7OqnMpCA0QkVAfg36XNCCiPfGlsVqf
 uAbDlNJJDvZVRS21TcB2eSxFtrwWjBpFFmnMQkCpeL/XehzbgE3DV1iMs4e7ELk22pm/
 BrGQqA3+wntWMpE0etedyPZ7mhCbEKJ9ZPAtrF5ZaFSc1/8OcCVF8ifv5ymUl1sOLI/8
 v7DpYDX+O1bXROPRt3Dpz087zFo7HG3wZ87F/SD82KSE8QN8wLdiGIIWzR9D5qiSnRbk dQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2mduq5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 16:38:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGRVtC031556;
        Thu, 16 Nov 2023 16:38:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh550au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 16:38:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STs4RIoVyio8JxbHHy6H2TR7SRllTQVIqc3cZ1zs+V2MOBe4QUv+nMAbcVjEatZgmHHiUY7RfjLlMSBgCcZ+0kLQmUMyRYFV7yyLXpr9OWiHp6jCjfosjGvVHFtIAkoZ5+0wbagyqowEzYafyKkYNyDPW/erk9vEEy5rust+Ek6stqXYPJD9fg6DmXKrIAmdFxwB8oGc5pajTMKhU28ecybg6scsUV4eA6fD6Z79Gr9DIw0D5jn+iFdwtJx1DRpM3v14dhzdHedWC5eegoEF/qXJ1BwM/O4d0WXSbWNh7S/qDm9Xe36Welzma6EAp5HK/pfGEvoI6C5pXsqWF5OTAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PI5uaIPl9cq/qnrK+LlY+ygDET4lMeXlxNQKCEfN+Uw=;
 b=lmNzwpA2U7nYUDllb1/Q8tT52kGrH+n3kKUvns6zOtr0t+j7AbGi/G1bxPduEiCrLYeBO9xA823R2g6ExIJ+0OoJRv2o9epy/E0+dVcANEV2kw8aRCtAvgJsMwwGJFp5ZqTJsLvBiUCyf8EefVPkXlviSLfpqnv30UC89OUuxdnbLOFfRcdGIunMuIgcehG8p+znP9Q0/Lbft349ytuE0eh2vCEYgyrgLrMjd2XhDXML+Suqw6bL3kxImVqF8sxthYAYhzduUStH7i4KLfea1yvPhvaKFE3jCXjvplLwBaaSvrCqTa7r04qDnd4uYjvM3d0SZI14fdU6y9Mgi2Ppgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI5uaIPl9cq/qnrK+LlY+ygDET4lMeXlxNQKCEfN+Uw=;
 b=CDCY8IGwN+GoPK5bDqxKK9dM984ivp6Q6wZ0DqcHCwb4EBxzImrA0WlLwtpSpq7uvP0zV3SeJnQH5rkPrKo6aOpEIapgmQd8hnwetI8DVr1y6psjGYtgLBikIQgfuesTCI0TMN9F4HXuQ5z5poyizJGghDKtfLqNj3puyQw2S/0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7430.namprd10.prod.outlook.com (2603:10b6:8:15b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17; Thu, 16 Nov
 2023 16:38:23 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7002.019; Thu, 16 Nov 2023
 16:38:23 +0000
Message-ID: <40b44ca9-9b5c-4996-a97e-ad6ce29b01f7@oracle.com>
Date:   Thu, 16 Nov 2023 10:38:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/20] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-3-michael.christie@oracle.com>
 <2d3bee15-fda0-4838-bdcd-4970f7cf675c@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <2d3bee15-fda0-4838-bdcd-4970f7cf675c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f45d06-d289-48cf-3b9c-08dbe6c27323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 21BTHFLmR+XSEf+V5BY0HXCrr1bAOlq/4HJxsHzgY0xRGzLuq8NTKjwwakH6eBc/AdsKSHEWgZD3bRERH1fXWTRg37gre/hJVg4jpnnwZCVC1EjGaZsudbxcBAF5MiXpF6hZoyEEfkSBrRz0R9mf2Fl1nNnztigVQpRWSA5QUEWLBfdK7Zv+FqLUo7/Q+B/Ky2w145js2NWz/rhGYSxItvRsWxIFuECUX2q46yg1tvxdAkpbWAvNf9DjYpxNH3AntbYl26HfmJRzEBern02VYE8ulKpABYFf/VDWltEpaw5afbLqJVSoLrIjOl1sBPusBbOBWMtmVsdxAPFVkEPFZpHU5aWVG7+8Oa53nY4xfytqcey8iSB/YV/t5uMBCVFKMIhizudmn2o5zTe5qaQNKsN/V7n8bLQx6dUlmlL3ciSZU+iRHUS9t0pf9/cTe9M96a+rvaSYUUuAb/TGf3vzrCncy1Cfr7Fo9W3pCiJSdw4bfj81bsIfKX80KZel07s7Nv9j7ZJL2kmYRTNGgyFYjZAaQTwGmdiKoKfftPGQL9EmXHp6imvs3IZTKPAdzBYEcDQPuTTLPhr9txzsdszoXwG9jca1qDD6ubG9PKCNvhafm7AMJmpNklxgGPWSuGJid5IBfkRXZVLVnKUIyOjbjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(136003)(366004)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(53546011)(6506007)(38100700002)(83380400001)(31686004)(2616005)(6512007)(2906002)(86362001)(5660300002)(4744005)(31696002)(66476007)(36756003)(41300700001)(66556008)(8936002)(316002)(66946007)(8676002)(26005)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmhDR0xSZkxWQlVrQ3FtYjJQTzRWcitvK0FmM0oya2ZHUXFaN3JOUW51SlRo?=
 =?utf-8?B?Qk45ZFE3VjdrYUM5dVBMaG5MQmovLyswNElyemhjaWtIc2Y0REFHd0xobjRJ?=
 =?utf-8?B?c1VyS0txUklkRXFkR0wxTzRUS21Xb1QzcVY0ZThscHQ1NU5VSEdGd0pFcXVn?=
 =?utf-8?B?QWVMK09Id0REeDN5eDIvcFNtelFUV2hNWnRlVTVLUVRESUZveFdWWjFPUUlS?=
 =?utf-8?B?bVdpcDlJMGUyRTVtVUxSTXc3c25EbHgvVEpnZVdlYUE5c0wvOWk5UzdrZm1p?=
 =?utf-8?B?TTNsVDZJS3kvUUsvUFZJZG84VG1hUU1RRE5mbjkrNXZDVUF5Z3V1dDlZa0M1?=
 =?utf-8?B?akVjLzlLWWhBSEJTTEN3V29hbUJJSDVrY0FEVTd1QVQ4Vzh3NFBJZjhHYjlt?=
 =?utf-8?B?WnRTL21yVjVEcnhHZVRiT2RLMDBTYXZ6Vks2QlRBbmEzd0Y1YWtnclFNVis0?=
 =?utf-8?B?OVRicmlaUm5aOFkxOG1BNTNWMjFyOUNpbUxKWjhVQmVvSUxxN3VPajJRZEdK?=
 =?utf-8?B?dVI3ZjJlQlBWUG04eUc3UERUK2RIdFhlQTA0TUVHQjhRQlNtQUllN0VDdmJ5?=
 =?utf-8?B?RVQ5UjYyZC9PNU9FbEtNMGxDKzgrT2c3aW5FVXZaQzg0dDUxbk9JU3hQMzB5?=
 =?utf-8?B?RVZ6cEV6aDZLblJvcVZVYUkvREJuMC8rTXlsMnhIa3hSYnVjOXJ5V0VncFg1?=
 =?utf-8?B?NlZNVGd5c2JkMUhFNVg3TUNSWUVkVFZqR09lSUZuc1dMaFdtc1dVeVpyV1Z5?=
 =?utf-8?B?dU1aR1lyTGhFdERmV25ISzdWeUZaVnZwTjc2RDRwSUdrMUtueEgzcTU3YnNi?=
 =?utf-8?B?ZWRoL005dGdOSjEzQWFTQ09RdG95WVR2bVNSNE54VE1KVmJRNHRCNFNvL2pF?=
 =?utf-8?B?Qi9zRzdiTVpCS2s1MlRpNGowakVkN3pmMC9wTmRKbisxZWFwbTNiREV1Nm5C?=
 =?utf-8?B?M2JNaDhOc093THNWZjA0eXIveXdtT1haeVBDREN3MWd2bk1uRU1wb0ZnMzc4?=
 =?utf-8?B?ZzcrRlFybjVoR2diL3NLQlE0M282MS9pYkhmbDIwZGlCVzBRYjE0OWordzdw?=
 =?utf-8?B?cTRzNGxKRWlrTjdhYVd1dnI2NzVhUEVDSG1tdmhzS1VVOUlLWm5qL1BhcEU2?=
 =?utf-8?B?dWpTNGEzZ1dpaisrZzJwTVZZNUUxTXJPN2VKUVhPdHJvQ1lNMk5tWExPalU5?=
 =?utf-8?B?c1hmakNLMHhLZkVLMHJ3OUkrYVZlN2x5cHdmVW1OMzM4Y1hmUXRxQmowaXpx?=
 =?utf-8?B?UjdGSXU1ZVVvOFZyTjNoa1pCWHBTOG9MNnFXcFBIeENVeGliY2N4b1B6Qmtl?=
 =?utf-8?B?OGF5Q1JQUXdHNE0rK0VsZWVob21lbnl0a1VGOWRVL24xTnVIQ2pUZ091Snpt?=
 =?utf-8?B?N2pEZ2VSeFZHK2txTTJoQ3lSZFNrbjhMeWcxM1M2Q1ZLVENLbncvUUYwdVJ4?=
 =?utf-8?B?LzFUTUlnWUk1VElGZXdCUnhVNmhkWXhiMjFRZXRUTUhpRU5qd3pmMnlTRjdC?=
 =?utf-8?B?dTBHNzY2UVJSNDlSUU9LdlRpZzh0dnNycUZ1dWg5aUVISkRoNjdsTGxIanY1?=
 =?utf-8?B?aFBMRzRQbng1S245SkZaWWN0NW0xdW5ncythalFIU1RiS0MrTkd3OFpmRnNH?=
 =?utf-8?B?WC91enY0Q2RDYU0zVWdmZUl2QWowaHFpOHY3QUYzTFJiK05TNU5rY21TMWU2?=
 =?utf-8?B?NnlVUlNtTGE0dGRRdndRbnJ5d2xZMDdFK0xjeHh5dk9XSGNPTElZZnNJOUhw?=
 =?utf-8?B?WGlUZkZiUG5OSzdjWEVvVE01bWZCNUpPQlRhNFllR056WHlGLzY1Zk9qTFlB?=
 =?utf-8?B?dWVUYVpxeGF4di96WHB2SGYxUC9jcmdkVStLNTF6UmU2aXFxM3kraEVNQVpZ?=
 =?utf-8?B?SW1ndDRiTXl4OHNpbHpnd1pOZUcwVWZPUDEveTZxblNvRjlTb0Vnb1ZPUlla?=
 =?utf-8?B?cWtDc2pjYXVvbFhzUUVrUmE1WG5jZ3pwbW16dzBBMFhQQTA2b1BZd2o1QlJZ?=
 =?utf-8?B?WjlTZnp5Y3p0VUlnelZtcWtTWWFUR0RDbUZoNWJkaDdmTy9NNVgxcDI4cUdR?=
 =?utf-8?B?dGFUa00zQTdDT1oyZFlLWlREbmNTZkxibFFkalV2aDJlN3JEN0kvMlk4RVRa?=
 =?utf-8?B?cVlnak5DTkZTbWJrSGZtR2hYdDU0SzBJaWg2b0p0cU5uczFOSEF0eWZ2WmJX?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Hnjnr9KfvuypIj7YwlMSlyPufg+ToUiAD8IYSvlaFpH3bD4OfPpUGbcuzT2/FI1++AvhWlI3jmRBQLYvYXNbvc8KGq10yC+eXEDDH0/6zVKtCLMFh6V6jt2FE0U+qLMEtITKQ5VxuooMHE3ARSlUeGobjZDvkK/EONgqQQz8/Huc/GaWwbclUZ2OctHSRPcz9iSG5vKk9DN7SrlHxE9ih4IKhL152A8z7NkDEoAYNAL/Cetq2E6vdUPi4IWxShhnpno8OwsHgUg/caigO9YpW9HgUst8SCe4r0EHy35/EMt04XUiUqBu5tffuJIADoKX8ujnpk1xM5SID9ehnEj8x5rwTd/sR23gGLZe6Mevj3ZQtLKC+qzalgwdd0Nd+oO4FmNBMsaKCVg9cYpHyYz2THIbcCH4XNNGgVUvT8tIHdrB4Ro2zLKbSCms3by0pRPSEBrFAV0NbI0eC5iGjbl1bTJpm7GGcl6yLcETSiEPTbQUhQXhMiEVb4S6vDs768dNeaGHsEgHe9Ddd6myVxRp45+EG4JHKv7jUdn44WwywOCC3N99NgkG5c93rQYy5PlwVNWUsBvoaUJEZECn2cphOA/o01fh0nBx3E9o8zBUqkVCbJ4X4w4adW1sWFFjP/fy8K6PVdEdR33a+OCLTMkPhXMSDjpPJzqKWyglpLEWsMbAum+TL7BpdJEjGIF0OBVQ9iOYN+bdB0B92w7Bl2CI7zxgsmUj5WrCcQHuf+xQO6tHvsiATQFg/i/tTC9p2OkA3uA44PLiG8xIeU+YBDr+2gQmRMnnwcwKQ5mC19XnLri0fkkTL3XqsckVlfjPsIWDHqgQ49imqOO0pRnOGX7N5KjnEE0YJA7xTEzRaXxdDyqfBb1+RBYa4ArpaimlGsHk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f45d06-d289-48cf-3b9c-08dbe6c27323
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 16:38:23.3614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQHVh/1gcxuKa7cSbKuezH7JxIiYoE6Qzc8I1v6uYVqgWJCCdXzMk+Z+atTKUP3ZcT/72YbdFjfoKEGYqc7CZlrOOIEgKAiBEFaHqN21HIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7430
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_17,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311160130
X-Proofpoint-GUID: PJSazo16A6v8H9zdvb-bU1I1cf9HWlhL
X-Proofpoint-ORIG-GUID: PJSazo16A6v8H9zdvb-bU1I1cf9HWlhL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/23 5:14 AM, John Garry wrote:
> On 14/11/2023 01:37, Mike Christie wrote:
>>         /* Each pass gets up to three chances to ignore Unit Attention */
>> +    scsi_reset_failures(&failures);
>> +
>>       for (count = 0; count < 3; ++count) {
> 
> So do we keep this loop for the USB workaround (not shown)? I just wonder why we retry in this outer loop as well as now inside scsi_execute_cmd(). Maybe I'm missing something ....

The outer loop is for the inquiry len retries not shown. I didn't
know it was for usb. It's where we retry with a different inquiry len
to try and get more of the data. scsi_execute_cmd doesn't support that
type of thing where the data len change between retries so we still
have this loop.
