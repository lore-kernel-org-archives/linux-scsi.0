Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B150C54EBE
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 02:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjANCSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 21:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjANCS0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 21:18:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5A8BF0B
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 18:18:25 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E1vgo8023256;
        Sat, 14 Jan 2023 02:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=oLPCNxmKOTZO27WBhtSu0Mrr27e7tokIe/D6baCYRig=;
 b=Tsb0YqwY5MZxZjVATYvmQDgdF/e3Z46lUqyOTAvPWor71bLBm6sQ66Dr0hTw7M3dTmcz
 h3Io5w5sY8C0a5v9aRKxhNOKU3vW10h09hrBMi6eBJzbdxD1c04+u2sGQoWn8ASIqLvw
 4Pr9Y+du3x3M72Y1Mz30co5usR/Wutw+VvjiOefREhmlEDLH5ajd0lj4klgHzS/uO2ad
 DftYzKGyeMZl2W9VmM85GHjB4ZEjBsiBcmwh0E4MtZP9RkpTk2AAfktbNwnxNDDD+9uG
 DUz58IpYodWB8CZIKL4UfRP/M20zzizqH85KfJ5WIzRvbDmJ2XBD7S6NjQ9f+BZ8+d1f 6g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k6c00be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 02:18:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E23lNb019037;
        Sat, 14 Jan 2023 02:18:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n3k9fg84s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 02:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrUSWsmMSzaKBbpUKwqJtTNbXp3veHVYxWDhHD2Lr7ahmJU4gXlRLPc8WlDMPox60pi413Pua2P1boa68uxXoF5E8GRA1FQhV+9HL3NRUu7FAhwGgBaRPn1FULlpjTzSPVukT78+hTK9dPLOrthgLX0Ma//uLhsVxA5M6yECaG5dqeotjOikek6Dc1aCWbDPHgyx0Z1tuNeeHTc2KElR2hJS+nKu05bP3K1c/OBOhMqzyMVLeZiX1QbjK4zjFf4zSaJyN0PNB8pnAPL74GHECS8gNTyyD9Kt4sQinlsRcsDO5rFuh0sftAm/bvNSjFBblQZJIgsdfC8UvF5Tg1bsSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLPCNxmKOTZO27WBhtSu0Mrr27e7tokIe/D6baCYRig=;
 b=MvgYW7y7S8twEkfY7BKhUhS+pmAlZ10wXqDmcKH39oia1vtCSAXVaqIIu+0soK5dP4yuE62IUW/zFcj7PjVCqj5J7CKklS9AgepXuc0Jjcen87/n4lwl1zXyFBX+MtjhNfnLeGWd7pKlgLbQEYXNBt4LTt0PObnr02KcRu1JHcGDszuqCt7yIpLBUx2Q3GvTBLdMl0W6VGCLh3NuW6VwJ6/21H8sS51ckLTTGptS23BMclTF/ZDd6LPZW9Px9d30NTmfe0l8S50t1B5iHI7fQByMLKd+7xJWw9k+ayQSUy4xFWxqfJHnR3mrz5D2U/s8LvpvVQWP4KdCryT32REC9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLPCNxmKOTZO27WBhtSu0Mrr27e7tokIe/D6baCYRig=;
 b=FymAFbjlDfyY/Axrq0eq/3kx0UzKxRlOHAvONGzlSm3+QZ4mt0a9SpejW/D+KolJ8CjkpU2eKJwp9Pug/iC3ksv11cLt0ATU+dC8zejlufn32O30AmiyYVO4u3h5dS1wMY1mSK4bQxV7CRuWmm2S664MYecdk9ACzbRUxeii7Ec=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5999.namprd10.prod.outlook.com (2603:10b6:8:9d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Sat, 14 Jan
 2023 02:17:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Sat, 14 Jan 2023
 02:17:57 +0000
To:     Can Guo <quic_cang@quicinc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <quic_asutoshd@quicinc.com>, <bvanassche@acm.org>,
        <mani@kernel.org>, <stanley.chu@mediatek.com>,
        <adrian.hunter@intel.com>, <beanhuo@micron.com>,
        <avri.altman@wdc.com>, <junwoo80.lee@samsung.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] Add support for UFS Event Specific Interrupt
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qnxuage.fsf@ca-mkp.ca.oracle.com>
References: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com>
        <yq1h6xc4jgh.fsf@ca-mkp.ca.oracle.com>
        <0282bb4e-9b7b-7454-4c90-c7cfd1cf21c7@quicinc.com>
Date:   Fri, 13 Jan 2023 21:17:36 -0500
In-Reply-To: <0282bb4e-9b7b-7454-4c90-c7cfd1cf21c7@quicinc.com> (Can Guo's
        message of "Wed, 4 Jan 2023 13:20:19 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5999:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4affd2-f548-4c69-b008-08daf5d58d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbzR+3ZLx7cxXF8Oz2arTa+1AY/xzFqXBhzYSM8t58oIhEjno4aP2/a1T9wHy9dnuRYfuMbhApGIO+UW+nK5JbBA+0BOmMjHFr7eqtJRnkRNdAZBbmjq6uFaA5vlYh5hgyFpy2BhshFdtBkgPRzERkpCDsDmduiKo9V4Zp7GDAZlBDZAiAXbn6G4ZlbWzlH18YiOatzYPpfGFK7jYckoZ2Ii6kiYnbABTDiLwHM0Al7YMwLqelhyoS4yn+2DDjPGgLf8TYEmQYMr/Ofo8lPLtQjnpLcGK/WPUcQILKTSQVntglzOwECdxTnbNOgNXbx09FVCiVnRGaCKsWFeHZTar0sGrm76QydPOx+977eBbp/S1SMl5Qn2DTyCeK+zNTFeZhH8IAZiNzvuHgOqj3EKw21liwUa6by0/28FAX3WVBY4CIpvhURFZSWAFKZAE+fStAZ0/ElT/LG+/SqNw87iInkLSzpIr1dppjiYatxKFlB5ygWXLZGZVkf9bqEgowlJdNO2KxOsfecIxNQm5hv76aCM8UL7QML6nMz0l8c2rY04MdtA5SavlNCGIWV+rFgPQNG7EbtbdaszHfmxQDMI1jeiDIVYqi4D5xEOA9OAgeraWrJD3/2a7OZsF1om3MB7QWSBBZc9hqe9BjY6cJV3WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(38100700002)(86362001)(6916009)(4744005)(5660300002)(7416002)(4326008)(2906002)(66476007)(8676002)(8936002)(66946007)(66556008)(41300700001)(6512007)(186003)(26005)(6506007)(6666004)(54906003)(316002)(478600001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?edkqeCjJul6Sc1lJsUv/AtfnmQqIt1tbUEquP45yoNJ6pnM4RvCy1gdPOarV?=
 =?us-ascii?Q?hCR9VpIgfRhkv0p0jd0Dnf9eqdRIRyRV4SMM75zW/c2C89R8DZp3/Xr3CRMk?=
 =?us-ascii?Q?8K9AyCcSzF0QBsMmLR9dSqMiAPh2+HR3+DvUuDvZ2rBsw17CaH9gVTSFsQfY?=
 =?us-ascii?Q?ROuAA3Tz9pdiX6/ol8X9F6PU3hxRi/lzVQrYf/+odH3/O3mlnyH4L44IxjKl?=
 =?us-ascii?Q?XN1/Atco9UwyV5ruZKUs86N+90tKem/1W/JFYGl8S88xq9+sFYUqLTIwhoGn?=
 =?us-ascii?Q?LqEDKkBqZGAxtpNHk+ws4RVgvEibquxVg4585II5WuNTliixZ772oDU1J3Zs?=
 =?us-ascii?Q?VcYP6zT6j/5ph/ieSSMACexI5Bnj8fzIaMj1pQzVQ5VweAA5GEFxXAy0RH+e?=
 =?us-ascii?Q?ZIzgIdRqRKbS/nvtGFIzf0No+HMS7VeVz0z8G4cKakyoizP93fmRpgEI7xi4?=
 =?us-ascii?Q?esC9EyIe3N4YK0dllizmB8wNjfDRPw1HYua7lEduDy1N+Ox5n2Ets0Wo+qgY?=
 =?us-ascii?Q?tHWLeXd4XGGVGQN+UmbEcUI5Lh3rrDlQSra/vornQZ7/g42dMj9YG1stfxnV?=
 =?us-ascii?Q?fyAHR1rznD6iuQY+0RgcAafRRfzp4XRmG23J90yZSJVevP/M/E3ZF5R80wZl?=
 =?us-ascii?Q?6rIONTqrF19xphyyga+qRAVtKDhylLLgjfzQEkUR7gaEVbrpIWocMhbOHzwL?=
 =?us-ascii?Q?5MpMxW7AuWUh0uFmxTIYzqRs4/Zdc8YtZJFglw6qR76PMFqza2NWBAVBIPwR?=
 =?us-ascii?Q?+Sa9hepdgEiapX78fphmWHQEYDDk9xS+Xa2ljwXDeMtIIBn4bhD05923gpnw?=
 =?us-ascii?Q?eZZxvWOGtSd69hOU0r5AvyykteQW3t9SFNBnPXfiyXo79OECUhb513A8C7nt?=
 =?us-ascii?Q?Pcn1GWWXG/7hurWpQW2Cpk18BUtyVMhE3D4/8s45C/A3b6keE2EgcP5mkLq9?=
 =?us-ascii?Q?P7ZruGeWcNTu/qFJYerYpfaaRxom70FXOq/3PRZxIOTIAmuOr/FB52WsQ/Ex?=
 =?us-ascii?Q?DgGi94jrOu8xHVeWkMqo77daLGj0RznQaKSJby7L8xGlhfY3ioPQaJ1i8lY7?=
 =?us-ascii?Q?knhL03Qclk4i2Oe3q/B8NEqfTrCJvxrOMokrLU0b9kWJdi1VndUkwRh+rDqu?=
 =?us-ascii?Q?Kor0nQvzfojSCPkwShzWLuuaRdvZNB5dtYm6i9z/jHS/w9SFvz/mn/yNhpk0?=
 =?us-ascii?Q?jpd5cZumOqGwOImJF3nsEhYTUIflo6c67knDg1Ahu2Ca5HYnkSNqrXqR+sbO?=
 =?us-ascii?Q?lgyCxDnniCyjjmnbDiKvWwIAKaObKTIC3LCGdp3tzuiV3nh5cSDGCrBJi/R9?=
 =?us-ascii?Q?UN5JS0osKC8IJ0r9NKaIBHJHsg3cnLeL7vosDFEhaITgNC9nybsl43AY1gGc?=
 =?us-ascii?Q?M00nPbyxWVCKJRmEE5EG2F5Le/TnITeuKZxcjHU9LM7b71jW9oD/E68aqW3Q?=
 =?us-ascii?Q?nFbWL1ZpbPU//eeV2CWzIguLclJU3/yvBYtuLRLZL1omaiy6A+LaClBBGtsr?=
 =?us-ascii?Q?P8L8Umo3ng2kPaeFE0bTx5NvQZ4IqqJSvcbSQ1PgWduUyvqgaO1MYUZdEYK4?=
 =?us-ascii?Q?KHMXZahBWL2LpXDiHupkySI06yd4S1AjHgfbPToHYy08Rsj6DNDIOyBMSm5X?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?3C4HQh5maB8xX4EUJLZfb4Sfck2+ZIGXmDCUC+ZhfGos9tTjXDZWbbOM1ZxH?=
 =?us-ascii?Q?gIK9bhBFLdeAdoalFM3KojD6CMWLhj9hC6LP4SMVzH9I/e79u7pAOKbPRbsf?=
 =?us-ascii?Q?Y8clrZLbWudORMqYX0u87NJcufV6a+tE6t0BewSPwUj7XB/qAqV75cVTrjST?=
 =?us-ascii?Q?6G6OZR5AvdCZpy78+9m978bWMe0MXm4AoITTnMVoIz0jDG8KpM6B0HkO/roy?=
 =?us-ascii?Q?9egaDSPCaMY9Ac9xGio/m8pf41oW8j71jpxv3SUA1ypqYptDN35k/lENKaGI?=
 =?us-ascii?Q?RX95JO4iRQ8U+GK1nara1cLYwk+XcKGmj5K9iVse0zEu9b06zEqOdS/ZD3Nl?=
 =?us-ascii?Q?XnAk4eYnGHpK86bzgcLe8JUKs1Ha/amIMijrVQHIaAaio/mhaoeOw6Udk6Aa?=
 =?us-ascii?Q?SFjERko7QqR1x6+Tc0q/davWeX0pTtswNa8wYz6lSAOd6xpBnSnivMOHuXdM?=
 =?us-ascii?Q?FXBQ6EXjgKK1JS+hNjdBc9W4gdBPFOwVFcVi0/ki9HtHAplpAyBAePS49NDd?=
 =?us-ascii?Q?uT5jv6wQQKcVECYofvcyB5Jbpbaf19wSOznriM7cfwivPol66jj9Nfj6TqGA?=
 =?us-ascii?Q?NogNefiqacbmdgiiu9HJBmi0VDmdnFvBRCpghRn/k8ERrLiv/dCcLmzzW8bQ?=
 =?us-ascii?Q?llu3LINNkJVIW/gLF4QwX5RiHfRYBlTQ/tdEetkOY6pkIVPVn/mKApMW6vPv?=
 =?us-ascii?Q?NTA/EEPBIPPM49ujLoDIk45knIogEtXmSVvQ7ZyBcxZ66vWg5NQgLXkQQoG+?=
 =?us-ascii?Q?rV3kB1864vWjq6S1gST+pJNW/4e3f2XOh41sNHPt0ogq2yj70ZJkyeKooWIR?=
 =?us-ascii?Q?MQ5rTWuUzc3HeAsEzxnShtyUXHdXDmaHCdTMl2UcrHRRCBccarbZXAHXvuBK?=
 =?us-ascii?Q?sWGuVlOD6mZbC/4EBIG/F6K89KhzbsGBUGViUzDdukkWJgoeLGV7SUBily3q?=
 =?us-ascii?Q?oNZx/LlWiBMkt0R4YZdO0dkrgdn3JXGk3iRh1r7yTxs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4affd2-f548-4c69-b008-08daf5d58d1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 02:17:57.2840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9s9t6q9DBZGhBLFW6SROF1U1Eb3DJA6KiBDd0e9T4yFXnLtiA5F4d+ZgbtasbTsnmzWf6mYQJYoQwbqsxCookT8HXjsuwfe51EPVceo0wmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5999
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=651 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301140014
X-Proofpoint-GUID: jvBPzRYx3WyZUSuteapD268yytpYODVi
X-Proofpoint-ORIG-GUID: jvBPzRYx3WyZUSuteapD268yytpYODVi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

>>> UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series
>>> is to enable Event Specific Interrupt (ESI), which can used in MCQ
>>> mode.
>>>
>>> Please note that this series is developed and tested based on the
>>> latest MCQ driver (v11) pushed by Asutosh Das.
>> Please rebase once Asutosh posts v12. Thanks!
>
> You can pick up this series as it is after Asutosh posts v12, it
> should apply cleanly.

Applied to 6.3/scsi-staging (with a bit of fuzz), thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
