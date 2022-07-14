Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89E5C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 03:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiGNDwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 23:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNDwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 23:52:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAEF2655F
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 20:52:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3n6dI031492;
        Thu, 14 Jul 2022 03:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HYN6jc6przfCL8CrEpLKIGIH8vLK3woyM0/VzM+Wuko=;
 b=n4idwckfpij6D1RAARBFHgQLOAvxN1L4CasTh0NXcsiqyQKRxUpTDTRi5l+6f2EL2RqA
 gJ1fGao47owhgaub3fbIEDF065w4yB568vWCGNln9rSKJs3D+VMwluDnGefVLVNS3IrF
 5knvRS0H0usNUx7ywuE7BGz3D3Pr8Ko99QlRkaztDUcf90y5u7ZNO4sCm70vfx68VCh5
 dGGtrR1bu+bs+oa/bRvFecTwsPwrqU2uju+pr8zZjxv5A/DfS9JuorpUPjRbzfXFd8Z6
 5c6/4g2kxQKquD/lsm5H1lROl9cz6lKh1OcvNNzEDwG4TC9bAOQC9DkKeKILrFLR+8hx +Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727smamg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:52:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E3pduU032564;
        Thu, 14 Jul 2022 03:52:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7045sfs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkH+W7057518joN/K5dFurlrhKpDbhR9BdQVq7qFpnfvmIOcU3ez8oGCfQ0qkcNx7D/kIcM45XapD7fGi6NuijnXlstwqkvgjsIJCtAGp8b6uE4QIpVJIR3ocxGLKVadCL0VA8RrVn/KjY2qsLtkwFwvYhNQhBwKAeGCXdYG+YF2rtfgU9buva3qg3oABK95gdwJeYkvBxZE0g7KOkclDxN8gmC+fZgXF+fx52vWFrDqyaflsh/F/SKHYKQyYinqlUikZEUbi25UXO4KF+Hy81K4gUdWKMgBqi5ZuRPB4D2lsdk0eeaYs1A4eYGdCpvRX0le5s1tAudl/pDidQwN4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYN6jc6przfCL8CrEpLKIGIH8vLK3woyM0/VzM+Wuko=;
 b=hw3UDgB/d75QRb/JMtWMj1+8PvuhGmCa1YbBQ1P4oCyNuFklTnA0zHvuZ7kWga/oqE0vv86zNP+vaTzK9WZyOsvEbqm4WIs13rSaUy6cUnDD7ihb8E7LYwNrehqZQBMKZRpoJzMV4zs3/J9oS/DNqOrxkrhYrrsdTszsa2qwFKfLj3bxBK6qVHIUVp1Xye8/tLGbbSjnFd4up/tLNF28vh9Co6EFMz2S63aCN1gH+Moj8kXjmCoAkojj0B5QuNdowDK0geGIlkrxmj4cCQHu2MZH+W+v29N+OpY8295h01F8G8gOTw78DeVYSuH2fwfBA2O1xjsRnNp5xVMVv/aRgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYN6jc6przfCL8CrEpLKIGIH8vLK3woyM0/VzM+Wuko=;
 b=ZxbWJwV1m1jMIGc+3J/x/O9jOWQ4CCvYuPWvYWMkqrmeSwho945Ztlveekli6c17XAmXydQKBc7J9CFwed3wOpJTPKIZTEf1JKPY2hhTQPEXndIbI6CtGeQXbSzcTb1k+4rO/eNU4yFWb+91vGf/Yxh5cjVK6prOLkQBwExr7uQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN7PR10MB2465.namprd10.prod.outlook.com (2603:10b6:406:c8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 03:51:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 03:51:58 +0000
To:     Tony Battersby <tonyb@cybernetics.com>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND] sg: allow waiting for commands to complete on
 removed device
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a69cwdv6.fsf@ca-mkp.ca.oracle.com>
References: <5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com>
Date:   Wed, 13 Jul 2022 23:51:55 -0400
In-Reply-To: <5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com> (Tony
        Battersby's message of "Mon, 11 Jul 2022 10:51:32 -0400")
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f3f26de-68f1-40bd-bf24-08da654c3358
X-MS-TrafficTypeDiagnostic: BN7PR10MB2465:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFOMeUUShEiK6/qBbS0cvl1ayc1KdYiRK5JdgGegpqnpVKvgTuYd+UHqwUJxcfhBFMqNRJYKxl5ZSlJwlRCJdw8pwfcHYEba1SKAUjMrz9SxyK3n+4t9nDG0W/G1GNutij0Tszasqe3Jr2IVR8wQ2Aad71sz+NK3RisrwKjBu8oWPUWE9x3yzpQJvwtvrNy769JCbwOVC4fVRhAdX6amTQxz9l0P4qOsZbAcXt9hvfbvQi59Ty3LM3Lxfwsgvgc5mV3BKbLaOQMEafP44Dn3esymyND7clhO2GZ5UFwrjVhx6EDHM66kyCXXTnaCpBaepInjQ87VNAKOQqNGea2UinaMW0PJy+GfHBskk2TR7Bwa7RiMY5dsBWUJ97IXyuS9YHVTBXo96BVhJE1qLiCiucQXd75H3TQ0pJX+CZ79Z3CWsEZDq6Put+J78jiqWySpGiVA9xCBL08qQzH4IitWlotLyUIQR7a7k/+SLevyCDU6397n5z4jkLxJtTJ9FahNiYWaLQPXWblxAKkkA5KAkDGyz/d3+qkcBrIItOu4H0g6ryLpKAoW06mmNPSklL5LWhilHuPnM+LcRwy7KHMKU2fl6v5rhj5L/cc6QyrsCleT4p0Q95KZN35X2/nEB/DjMxJqkLbN1eMdLkhrW8o7ETpnNpG1j+FivhUyOs+shJ7yB2qkp2I2feiW5NIQiWjhQAhdf18gJltRVFUaPcO24Ghul3HWKoWQAo3W14OIVIGK/lJ4jjgdYyoHf+NEOdA7Lmfivvq1bdUw77KssQRN8Zknnh90+tLgUDwKKy2806ut7phhU4ATZUidmyZ+ifC/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(39860400002)(366004)(346002)(38100700002)(6506007)(6666004)(52116002)(41300700001)(36916002)(86362001)(2906002)(38350700002)(6916009)(6486002)(186003)(4326008)(54906003)(478600001)(26005)(316002)(66946007)(6512007)(4744005)(66556008)(5660300002)(66476007)(8676002)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OM3ItFnEdc0YIGq3TtNb4UwIo2QZoRZIM/tX/ZsRybEk2w2l5Oe8u8C3j1ND?=
 =?us-ascii?Q?DSKUrOKpfKadZsHKwWq/i/VmrzfE9LIGnaMaD4IBSOt4qrwWcsfTEnf1cdmz?=
 =?us-ascii?Q?kpl1EryvQKAnHkC7l8D3ZLGoH0zzmmVmQrUWkhvHWjevy2wdVjOQEJPkJEwy?=
 =?us-ascii?Q?SjfHLBpYb/dHNrtlnzLwn+xhVBg+Oym6r3ZrqVqcXJWbLuB/B8gIWhkltHPL?=
 =?us-ascii?Q?hKVTM3JIbSL3z1BWEluFV16+dWHVoaHw5IqY/VmTTW8ohOzWEtrQWjSOZNZn?=
 =?us-ascii?Q?nZcmVVfZ8bhrnM5ltBIeUO9tIP0geIiPXpQY9HfIGkJLxIrGzKKzxUGNLBOX?=
 =?us-ascii?Q?3iOud3Hf4rnH6bUVo59OnnAouXjqFJ5r34kfkBvqjEXGN44fyr2s4rO/LyL6?=
 =?us-ascii?Q?v80+KGfjkUznUVxWXdVAKXAzz6pYB+8JJQBYbDeoj3JB77jYF9+kokAC/txO?=
 =?us-ascii?Q?/csT/YuLZtMYhBfDuSMylmYcCSV4wx6I1tlvZN23/Dsl4gm4lLTUc92wg3Li?=
 =?us-ascii?Q?na9+hFB1NVbweUwN0wtEbB6GBqC/slbHWLVs99rpob9nEwu1cAY/bkZHzm0Z?=
 =?us-ascii?Q?DIuA3/ncL8QY7C1ytlZ83koLAFQ8Aki4ZZ1rS6MT7crkqqVBcrlgZbMKYQlQ?=
 =?us-ascii?Q?1xzivXeLaRp/JG6gvlLFpaaIifhVEmOhfciaRN5QltcYJFGv9NB+X30oJcpM?=
 =?us-ascii?Q?ISgonNnDkRY2Odx45apWJbT6ZmrMuiQII3Z1y8z6lFiTYVZWgmk3mMQTTZPw?=
 =?us-ascii?Q?+SEnj6aRU394NuCHf9VTfD7Z3+vezhXPUgQRTsMAixmyvPuRoMar/nLtxKdM?=
 =?us-ascii?Q?9F5lUBeu0s0O7k8OD6Kfar18kcTkbW6YnswX5Byy5noii21quD2KOGmVm9ch?=
 =?us-ascii?Q?ulLq/eKh1VLhVc0BDMQ/X/PcNgZX2se1s/IYfBzd1Ay5u961GlzkSp6ho1HP?=
 =?us-ascii?Q?+cQxzQjcv/rcvfy7tlUwPJb2wyweVw+XMI+HSqpyhjmly/bGq6enru3GnhzI?=
 =?us-ascii?Q?m5TlM85EnEJFRw4uhkdEAMH8ZRBPQfIwL8Rjlm9sSCsvD0QOSb8l0nehaGWy?=
 =?us-ascii?Q?mp3QCCSZusbHNXj+BrmmEwQQ4hiu4WagKQVBZIbR+tqUNIeLfz4zIMockQx1?=
 =?us-ascii?Q?28MQR5ZoUCTAjxp9+DcEIYB03qpjwZIUdohxH2ns/fvs9vXnVsTBAPS9s6ea?=
 =?us-ascii?Q?J22R2uxhaAiBBl3HrOCD75RcXW3TYIeqZRaFVGiaeI0xdAlbaoTh/BBlImB9?=
 =?us-ascii?Q?Tx33WhCrpCsVLPz87HNgln5BPXZ4AF6qVm6SdgRw8XmyGCt9HBYMB9gMTNBq?=
 =?us-ascii?Q?P3BDZl/Yz6vkR6fhhXyFzwVwYS39bexPHQwzioqVJY7BwwzTEFVyM9ap/B2J?=
 =?us-ascii?Q?VZWaXg1L2rHa+RvnK6TOlR0JSHgnMvwnto2gkvhn3BdY7SaQTzc9mujzAMbX?=
 =?us-ascii?Q?H6EzUt/ThFewIoJSUmaA/tOVFHroiFlyeC6AxHw6HYCk1wTZ2aiZetcqOeJZ?=
 =?us-ascii?Q?0PegdL7EfQbuosTDkDr7tA8WbUOzt9pxXiCCQCDUgayKSCsA4eZc6ZRgiCUM?=
 =?us-ascii?Q?hXL7oe36tvKVfwF9z9fVG/Y/bv8c5RDhW+bn3KRQ+iMMhXWi+rv1BZQ2OmGw?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3f26de-68f1-40bd-bf24-08da654c3358
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 03:51:58.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CjpDxAvPlkNNViaAclC8gtBWBPIHD2gWv+nklY8JhR9+0C9hmXHpyXQ5fUonNDIUDfxD8wJtP6qqfy7V4AEsTtwbQajBJnlM/lN8x7XZxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2465
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_02:2022-07-13,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140016
X-Proofpoint-ORIG-GUID: N5ocrQgbuUU5UhlLOTl4fBiNmMstSVQO
X-Proofpoint-GUID: N5ocrQgbuUU5UhlLOTl4fBiNmMstSVQO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tony,

> When a SCSI device is removed while in active use, currently sg will
> immediately return -ENODEV on any attempt to wait for active commands
> that were sent before the removal.  This is problematic for commands
> that use SG_FLAG_DIRECT_IO since the data buffer may still be in use
> by the kernel when userspace frees or reuses it after getting ENODEV,
> leading to corrupted userspace memory (in the case of READ-type
> commands) or corrupted data being sent to the device (in the case of
> WRITE-type commands).  This has been seen in practice when logging out
> of a iscsi_tcp session, where the iSCSI driver may still be processing
> commands after the device has been marked for removal.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
