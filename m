Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B027CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjJQBNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbjJQBM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0296EA7
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:12:56 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKOBsv017725;
        Tue, 17 Oct 2023 01:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=B2HktSUdnNdTrI9BozOKD2D6oq7450aidZt8fgRHGDU=;
 b=E+38Raad2GCCDuW3Xm6H6bakZ5jKViyAt7mIQCTbDJgjR53tq+664YkActMHc5ZNiL9n
 hTwzH/VSpawL7Kf9vO1mHjnAu2vNs+qkcNW0N4S5V1JjDUx6lk7HxJqPKGCNCL620W9d
 zjSPnatixVTIXyZCqOiXWWEZE3pppZVk5invCzgKN2+XMKtU2G8sQWB/v08RbTcuTM6j
 tWmLIFdT/3UC9A4MkOIMM0A/6ysfmiymvqib/nEH3iPob4UgHoEE82ny1EBWiF1xEcgs
 VUONA/MY4pnJXf95/b++vwrGBN5d6q7EytiArN78tnQCWjGRqIgnrM7Zq/mB9UZ8JMmh Yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cv0qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMIoeD028597;
        Tue, 17 Oct 2023 01:12:52 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy2wn9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csuk4VS5miICeJswR27olguYCFkJTAdi+jz57JeAxcdYODMnVp9P5eMSQiSRhYxCfcjgMXILntOTPvg5uXA2tDgyqADsmuI+FfGB871xekmqHAd7HO/xN/e6QbSWjP7FSX32e4+7IBkd2e1JUY0qHNFnkc+CTP/lVzt9j0HI0mZbRIwJpSbfhfVvJLA4GlmJzmYyw8WsJM7UOdAq+uD8c2DKWgB7dCo5XHqP13phA3Kh29sBLu4xeaNjjhT6g/ni0Esi+s8MGTCoQvP6mCBql2hnjwXrMAUkWY7cfhnsZ2sIkWjAJ/LE3DOl3nedmxFu6/o/HIcolhs8GMZkFtN5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2HktSUdnNdTrI9BozOKD2D6oq7450aidZt8fgRHGDU=;
 b=Z/4BLHCFZF6ZKwqIxgb9p/N5OVfD6pG+5lV/C5k909vm5nqMg/8DtSlLmffBUY8AYM5SSzwmFlrcw1/GP+zbCJjFrNvzGKq43qptBysx/QZqEH1aim0FTQjN885PVm1zMAMn8O/fXnjVod6zboCy9dF/b4T5wpYaT90isR7dKgXNte/fXCj9mAZNQOEoZTFBGNnezzGdGygw5jbWhpc6rDmNKW/nDaIi6HNF3h5qgF1dVvAcNzERxXA3r1EQj+jMwtO42EwuZCqOO/cJ7oixwn70ZICgrpKkeKM536AtvpMoSnsi7MiTo3o4TJLyvwqAhEgbGGx4CIxFxM1g5v/dhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2HktSUdnNdTrI9BozOKD2D6oq7450aidZt8fgRHGDU=;
 b=P63gazYVRSbtWb5nSo81ZVR8xb6eV6wNlZBmXHf2Pww2q2YVBrsScH1NOzRn1/cQ48xd26ADZOGa1wkIcZQ8RySE5eEEaolHzwYcVTTQ85uU1CtxJm0m4ZwZj9URl3fVSS1/xunrNN5NuXMQVW7qTbKzFwbZZ0cQ3jRqbr2+ils=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6878.namprd10.prod.outlook.com (2603:10b6:208:422::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 01:12:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Tue, 17 Oct 2023
 01:12:50 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        ranjan.kumar@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: fix in error path
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18r82hx15.fsf@ca-mkp.ca.oracle.com>
References: <20231015114529.10725-1-thenzl@redhat.com>
Date:   Mon, 16 Oct 2023 21:12:48 -0400
In-Reply-To: <20231015114529.10725-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Sun, 15 Oct 2023 13:45:29 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:806:6f::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3bb6ff-66fb-4ca2-cc6d-08dbceae2e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ax/PyzUGIraMEsxQ0S3cF6X7g3PHYLWr0ykIfnDufSN6g/mVcJs7q5+TTtpy8mZ380wjB2kxdxKCNok6fMQ6SVkfbcLtVHCMEZx2pCNk01dNtUfq6z7YE02mjBsw/Ux/4ue6pRwx8Ba/PY7fsCoURn5yPy+WVFF/m9RODLbzuJbF+SKih3W/yqP6+amhAU1sDgiCN9Lq0TacUMWCtjYoi1RqUS9u36En8OAP86k7iaAsaWic+h26/yFo4m4t2tjsRyERM58GCJUEk5nowthJuZqkenJra9r/MfbSvpIEu9t24nf9xkySl47Gs1QnLUPdNr3xgrUAQlM+PmU1hvlWvKaOVg2mRZ3zFQcr1EOeaye7QpUauQpIFa6eV3AdpVzGUfCLgZKAZcxd5LWPWLDHJ6Ln4dGQFjMrecREBEXkhR0pqu4Al0HhX6ciZyZ9miAQXJ7LMe+Ttj405YwQQfFBx8m10i1ejfPxI8rAv1y9AMe35aWhYIhNnvkm0UtBSqb1vJhwTTORJUmWVi8T06xskIiNHgCZT5iZDE/aF/28MslWdv4fGwwRZSFYm6ewiFEvQX12gp1XJe8eMhH42KEaLeDsYFrvXcO8HeJGS4UhK9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(376002)(366004)(346002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(558084003)(41300700001)(5660300002)(8936002)(8676002)(2906002)(86362001)(4326008)(6486002)(478600001)(6512007)(26005)(38100700002)(36916002)(6506007)(316002)(6916009)(66946007)(66476007)(66556008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S3ibbmpq7YgHal/t0jmJwS0sVJ9qQ1WURGoCFKN+6nr8qdd7lwnK5kSy19p+?=
 =?us-ascii?Q?fyg5PdlT4gaWKpoZ2UKVhcL/+HwSGS9uqaGp/tVwuhn3it27JYBX0Ykykmq/?=
 =?us-ascii?Q?DjCi8ENlVG39IU6Yje2Xnswdl7FP4mzIkMNbYoRXxpwBFMTVXRt4bARjCTlY?=
 =?us-ascii?Q?08Ww61kjJqK2gQ46qYvN4lNI0Z3MbjsCqBbuzTlYI2piLOYeeSr5GtTxRady?=
 =?us-ascii?Q?OgVu0acqk1MWSMs7pO94d70sqfLSpZacrWns/bUWdWJJG/CxhetvXTM/ViWa?=
 =?us-ascii?Q?Gh7PNqxN0CMo/aktCDJPpyILZzhhmIaljFJWysW0Q6fRISKyjfPzTy6vOC60?=
 =?us-ascii?Q?oBc02Le+97TOAfhMiMAEXC4fWF6ba9ZTz6aiGTiYPNeTqzIUu5gveydtVmMg?=
 =?us-ascii?Q?T8Jzp7se8yP7sHad0LsQmm24cGO2LUQ3A6JB2REdTneLOY5+lwlHU4PhMwhc?=
 =?us-ascii?Q?1lsg6lahyjfY4hxOx3tNusKn0VsKmw89XL5StyQjrytvzoL7vw/JsNTTKBb3?=
 =?us-ascii?Q?rqoJcmEv4+BdOLqly2biuYsVkHDNJEVPeIWsRe4Bk7xtnPdPzVW1HMVYCEDG?=
 =?us-ascii?Q?7ZGf02XIJDeiObsf1CvCXNhdKq6W8mfXQEDqVd9/H2TUdFPhYWxuVRP2o7Hc?=
 =?us-ascii?Q?JmDuX/w4r+MkVfzFVzl8tgLlohl+8aE3gcVqo2GxQBkf7iECxKQh/hQgFFae?=
 =?us-ascii?Q?89Op7pHxEjhceo2Zpio2ur/qLpnw9uQRRCbKoiPUTIM4aLmAcq/ap1h5H3ku?=
 =?us-ascii?Q?JMPsT/B8A01mXikKKHQLlXY60ntP82l4gFUkysmnisOiDEYYdbDqAjjJqGk/?=
 =?us-ascii?Q?ieQdiLFKJNNWPCC1CY9Aytv+omqqcqEek29GXNj7ys8xJ5YrhTEBmqm6gqpx?=
 =?us-ascii?Q?nKTpkK9tUtg1G1L6PgXFRmlY0LYYeFL06kziDpASD/h4eEQEjoOTKkW+DKTk?=
 =?us-ascii?Q?7vKY727iWq3cThyVeoajWvJ3CYaTRPD/JvYOlzPYblaKaKk6FtjA+Z0ZNhHN?=
 =?us-ascii?Q?eCW1LCHB4i2Otq28Fgj8CeX2yxGEwlEzaAGEPMgIYT3js6C5UtEJUORO5wee?=
 =?us-ascii?Q?lKSjHrQoYKzlDxOyyJpKkZTFjsNv9H66Jxom2bT1ifVKZfHzVJJnappEvkIC?=
 =?us-ascii?Q?iFxWzoy8HSjjkraT1vFnlXlFwGmluW2U0NY+kC9UuedHN3o1l189ujvHycik?=
 =?us-ascii?Q?o0yNj/sAtYKNHNCmju+8ybHK8KmXNbUEnUpCkT0mbKbHTVNTlg6WLGeGWENx?=
 =?us-ascii?Q?kXnLVpgXrlvPgPqRODl8nXe3tsZHOqPScqi/rXdGJQP7kxcXS7/HTTKSdCw4?=
 =?us-ascii?Q?lr5Ci6X3Qr8iWyy0GlUV97fzCysHviXVmnbBqSr9ORI+ZEMguOFGM8h4YQWW?=
 =?us-ascii?Q?ZSTJr7DUlI3lfEcUTKqwk6qY7zl73eYjfqTxazqvYcorBqHj7NyBp6DxuHu0?=
 =?us-ascii?Q?sZtR8y9NZ1zgmoXdx+5xZ9zS0PHJhg40d2Dz8BXCOBxpBNWuW9GR34tLC7h7?=
 =?us-ascii?Q?blE9Y12CB0S0YNXCR/aqysqIoWWrWwABlntYxYmt397C1TFM4c7Qun6sdCXw?=
 =?us-ascii?Q?QKxth2h9LaaXwYNcOgJoPwc12gqtGo/Ft67h2gMAkx1Oh/qMMvhuWDHC3LYH?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gbGfar+AjBNsEJjDS/qC/zG/nLfKDaI1QMiLkSWG21kTwPAr/0ksVMNCuzrrdHrkhyKP2Ko6fZ3xlwmwUsWO87uN5IGNQO845PPdNRURFScicp5xXJPYclZu3FQWEByI0IU1w7/hAkm9D2PPIGyz+P5StnHDPZ5RKVXiVw7uaG2oeopNnzppR/WWeP9Dkfexej5oVeK1db/moC0WyxwERhE6wwQ/VfLNi/JsY607EYJVy5os2hJkrT8gIk+FB6dfjhBJ5AVO5LaJqT4G+nONDwnrQGMhLxX2qWSQ7UnnNVpaRqc9NWPLLqQRShQYHJZ74ZbRAPIF5n6CxscrLCrZNn+dKfh4REbDPUTbsNudLmjrg853t2Aan7b8/HN85l0I/+A19RkFgnBvjKVGDajRH3Wxrbi6IKlIABTGyQGSX3x073CWvqf9vrl/mDUe7b+m9kZfXlvvgpTmbO2qzc3XYkK/dqzGYx264ow2TlMUGW8MrWEvpgSh8azp0Kj9Jdn7aKN1k5Ps0SgJwlUZCcIdqDFDiFd3sJnbiDkKfeOr5reAVS5MxhhyQ6UK14JIfIR1n+9YduS0m6ILErQ/ZkUfWbSXApWcxQDrEL/ALL2OWQH5ML9YJgwmIiC8jsM41loHvIPO3yce5SMTG0lYstxBmfQ40hC9pMSTzt3xq0Gc+9aeLtyr68WN4A4/hcjhinVmbw/E+kDoCsIZcAo4yqBBP/WR3QvNXzRmeAqYJ54ExQGv+Zs17x9AUb2gUdtwYRDiu8zq5XYR1I3rZzEGagrrxNVGkVXymbDEF0lKn/0nCrYuTRTI3P1GBIoEbpNv+660wP2DlIEqABcezfA1qKB4Kg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3bb6ff-66fb-4ca2-cc6d-08dbceae2e52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 01:12:50.0774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9Txck33q7m1cCv6qYsjbSqmn2zG9ldGyYGba2tsvwqNSkTgbrLePLKZLlfcHpuPR92qvzQYekLEHgBqKCL0Zcq9w7bSuCbBcPUe2M/fNpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6878
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=663 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: dmGym4lDfQ0pYuqB1VktRQk2DBJ6eXSP
X-Proofpoint-ORIG-GUID: dmGym4lDfQ0pYuqB1VktRQk2DBJ6eXSP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> The driver should be deregistered as misc driver.

Applied to 6.6/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
