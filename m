Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C732C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 02:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbiJ0COk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 22:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiJ0COi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 22:14:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6B8E0A4;
        Wed, 26 Oct 2022 19:14:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM1xTq014791;
        Thu, 27 Oct 2022 02:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VqXvH6oxjueV1w0Deto54Vc/tpRPm9m/GtKmolo5zEk=;
 b=neUFZsLkH/Fs7pbZYXMr5oMaY4i0xwWp3Tv6+x7uk8Zf1Hrt4a2jQjtij0YBOWGweNH6
 SQASknZ2xvs1H4ZunOEyormFkNWs1YWVxxa2wzWBk2dHsA/5TfAO3GFY+fwNQQ1c9lr2
 4dFKGjZAbC4Mz/a93/0kACQf5zA5SpBijGSe6eVq75PDuULbbnunqEdQYiqZfBVSXG0m
 oaQKlLhReGjPpOYFO3NPGdYZsTXCmVLshfhwSy6WuTcpeOPpOBtKhCuLPw0yidW8TlAC
 w33LNgEkYzsjx1/oMRBaAPEKPfq3GvwNstAgYwq6HUlPrbCsTfkgO3OU7o0zDQPtOORI 0g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0rh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:14:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMAJNa009505;
        Thu, 27 Oct 2022 02:14:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfageghmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+gyTl2/h7TJGHx8PCvCMiuknIPnRT3nGZoPCSLuc5/CzumupkgXHPBoSvscqrcHN2q8yXnO/sIb7FjIGxTf2zbZVv+810rVePzbDTPAG4a3UTJsy2rBwesX/42pbRIJKX7yyf+UVnhckqujZVTTFfG/U0lR+cAfSiV8QphXaW3kGz5NXHNMZAwPcROWiQrwoLN+QieyoOTGSEMQ034l56My4AAJEQuHE7MaYerMVM/3+gnrrV9rrwAwi0E2ezdhYegQ63HhZADMaUv+OGh1rr3utFW0dR0Us8muUHWEPSADApdVZeoViGouTYi0t9p0070dbh9c21youNt2ktWUiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqXvH6oxjueV1w0Deto54Vc/tpRPm9m/GtKmolo5zEk=;
 b=SC15zTsFm6Wz8sezZXdG7f3pswJxQMcHCwvTIAGX/EdnlLMW97WwiW1N5AF87XLCZVFbocd3G7xbvMaMppc8s5puau8/M/EJ76rRZjAvMlpkuwiZyzcjC/o2Aw0s2qrb4lv9/Oh5zsUeNjAj1icuOFOMv3HqekdMCM9UjN3j97VAdZOaPp213Kt4S7Qud1m3et6If3oDqtkOLAz1pKKc5LjGs9k0BACEy7ZdcPFsKf4sUiXyd1Wqv7dqnaneklpXTEP8+suk3Fb/cpPlCSwzgb7fhDVUa7hQTI4b4+Vl6OJKUovIf1wHq9/Sz0XmTfuM+HV2owbuh4tdZS0ooOgv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqXvH6oxjueV1w0Deto54Vc/tpRPm9m/GtKmolo5zEk=;
 b=m2fz7/xUwZOPoTkNv6Yf6FhxlXwbYMszTTZgf+3/fcaxu4n6ElBSIrFLLuggzxRZPYSUSECnSfHIVsSylZRUMF3iO/woYTsW+TEPBjQdxXbJPNpGt13Iee77gTLMclWJPkWpJO9hggm4+S034+G00luWxRXV/wKRKpV3gM5e0jA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6169.namprd10.prod.outlook.com (2603:10b6:208:3a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 02:14:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::17b2:d97c:d322:c28c]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::17b2:d97c:d322:c28c%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 02:14:31 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v2 0/6] add support of RSOC command
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgdirp1o.fsf@ca-mkp.ca.oracle.com>
References: <20220906103421.22348-1-d.bogdanov@yadro.com>
Date:   Wed, 26 Oct 2022 22:14:29 -0400
In-Reply-To: <20220906103421.22348-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Tue, 6 Sep 2022 13:34:15 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:806:23::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a65dce8-2b72-4562-3a42-08dab7c0fc0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pm8IWBxrRLPU4H4nzA0vn0648wHwAqj9Sg4lwUybPfqFdnAZg4t7y/Zj2wLoE/L1dJb8izZnB27BalJhAubQh0x5h900hRl4qTeQ0wzl36r2eTUs96zX628yTvLx1AYJmi0ED6Y7kMOWFUKjMIMSthuMfqmmvxFXbyxspFI7DlSjuiK2K8TuF4t22feSOSEl50+p9ycFY8czEfEU20cceC7jmo2wUvZ2wnp7SxWNxkBb2LLbenMMxZDU/quoz0hCLoaZPM7ivIq8WL2hZWnjAlD8YrWYxrqkFPbZLV2qq2TDc/cLB/n5epT8MKAZ0wwQwMGsT7kdrIe0gAzLZS3W9zdNG2OVAmdv86vUepUaMY5E1W+hzxHopAaRcaWyYNCfeliJmG9eDCJZABAhUKSh4DNw9Kqg/2SQYdAG2ez4zmsfCWUBDPDVGFru1OEDmw7tbBOdzWiU/yxYIrpRUWxeOI/1ZJJVawR11EepW3ALpBTT+KDYeDgWVzMJJWP+YY14QKWHKmJNY1UK5id3Y94FUxpqRwun2tyn+6BBFt4dCCtTuhHHuMpGHi4JQVEZ6UM6y473FvCGhsPNcijk7599XUPgymZsPHyYItN8+EA93n+xbnDw8JJHrMGc8rTmn9m2lMKw9RuBqNrtCf+I8wF2FvlTgcsBsHsDtP2B04YMwSxuuFMWb4OuD4fzw8smA0VE/SiHhZxAMrItkJo4BOMy9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(186003)(86362001)(38100700002)(2906002)(41300700001)(36916002)(4744005)(54906003)(8936002)(5660300002)(478600001)(6486002)(66476007)(66946007)(4326008)(6916009)(66556008)(8676002)(6512007)(316002)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wi3xFhsiubFY0/xxyoxUC3gkfThp2+Kpsjn/bZMiPMkwoH6GvndAmVA1gf0A?=
 =?us-ascii?Q?Oh4gXNjK1sNQ9Khx4wtpvyi3RzzSDEY2/dLhDFcbH5Sk34AgeNP5ZGlAzcJt?=
 =?us-ascii?Q?m6oMD68oTM8oNbvTOzxlXejbRhwpawa6ayHPB3s8hTwuDmhVVCDD8rfSx61X?=
 =?us-ascii?Q?ToXrvleIr57a5VeJZlDPz5mOmRU8OcxTQ58BzS1WrZWDCPuR9nN847JYZVq0?=
 =?us-ascii?Q?sSLED/UG/480sCDqBwn9BQJGF/P5r1oitruNojn8qx3S+VI24oApA1avwADt?=
 =?us-ascii?Q?DoIEN/wTNGmUhH+rVpEENqYg5DHuQ//I6mCR/61IbtpgL+DLXrQKHRPdSsNE?=
 =?us-ascii?Q?MTeZ6A2Hu2ujKCY8qtU2K2r7n/BnMYqt46E+M2pI/8geKYyP3XklPBGeWBHR?=
 =?us-ascii?Q?Aa8DWFapvg7EE/aZTTNI6XAbIEB9TC6tKaqxQ4Mue+ZjiNnS9DDYw4ypMobL?=
 =?us-ascii?Q?a0zicwuACg04dOh37MYTnT18AH3baYJJqyJIoSBc5Gfed0JbGQ6PaN0bMWPi?=
 =?us-ascii?Q?y40lxtJjgN0eIi7EgnkAoweFo60GHhQ5szf+SWWXkkf2+CoO0fBPEEZryrLa?=
 =?us-ascii?Q?XWVM04SymMcXMhcPqdAb+Pg+bDm5wqhaHi0urXqfvcSpFjL+sm1TLH+JNNE4?=
 =?us-ascii?Q?BDxNgIy346iZ4Y5dRJPeneLGwdQSBhAv3DtUUYKdrnu3/yH4mrd0w2of0XNF?=
 =?us-ascii?Q?HTD3/c0h8HVFRHahLbmrBFUrZT6rGfK2WmHfwBf+ykckBSkrLZJMf7ePt+Va?=
 =?us-ascii?Q?YMpz7ICsNiJJnIi7itNfCaf/zjLCGd8OVR0lVYZgeg0LIACSpB5cqmvtG/7R?=
 =?us-ascii?Q?mk38UrAhGqYvRSjwrgTF4U3ty1C5rjBCClgBd3B98DwdyiQBHvA4W5YRw7SQ?=
 =?us-ascii?Q?CsQi2T0riqCYMU3Bx8DbZHK/iOqFnIVzOPJLdBwyFyl5JGoasGvsmFNC38wr?=
 =?us-ascii?Q?YdSP4N/llG1VESVYcdremEezQvI5F1nZ3L4r7e5DuU2pjSN0/qn8ZRWIsVJk?=
 =?us-ascii?Q?EGrHv+0/LN8RLXyfQ5u8rPFg0iY8cWz7fi8OGu1nLyU1qCDA62h6wu9BgnNk?=
 =?us-ascii?Q?ViDN/f9gStf4qbwD3CuTkWMsZm5AHf9SRGydD+IIPw6MTqYVkpuTRFWxE0iP?=
 =?us-ascii?Q?00tFAD9XtjZ6FBrtSp266glE48IpOSgVHC9vUhobz2dG6ugBYrwtk7k929Ma?=
 =?us-ascii?Q?CRE8aQI+YaZNR2geTYI1wknd63OCmcYFyNnKL0WuS4Kyh3C0SNNN1b6BDwrn?=
 =?us-ascii?Q?5HImz+FXmpKYObL2mooyS/tdwGYdYAQ8uYYxRkJQFs9dn28UZci3Kha2/2WN?=
 =?us-ascii?Q?DYolYEOo03hZ/KUebQD94ScbwKbtBMfEYIf3ZtqhVGDQLh27fw1ejOpmwQB8?=
 =?us-ascii?Q?V5lIrHB9EgPOYcnjo5OBLtBGOaqu6vw/db3VZE79b6QjpVegF6K/zzLM9hdT?=
 =?us-ascii?Q?ZHEdm9xxckkAfV6T96AdY34cOSUPMKUk7/1hsQNzmjrerIiO80iPTHVpjklN?=
 =?us-ascii?Q?G+Wyxo1/LhyWEb0ZjbEr6VLZtkgex5tumJTcg7bkQp0nWkiAckSN1jadhhy8?=
 =?us-ascii?Q?g6PlSMQUwHllnZ8FmSSM7YDAPMEuwQRX5Hpg8s1PZ6Eblg2KDOO0AsWS58tx?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a65dce8-2b72-4562-3a42-08dab7c0fc0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 02:14:31.8993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /q0juc40h7ZBTSGqAuuq+78F6n27CgGUNuDwVOGRPc+2KDufkqRwV3QZC8np9VS3Yv3s4/n18/uIgPVwE/hJxwOuLnFl7kssHV//Q6MgszQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_10,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270012
X-Proofpoint-ORIG-GUID: xRJgeDjOxlsuX4tWpTrUWE18YJoBSnwC
X-Proofpoint-GUID: xRJgeDjOxlsuX4tWpTrUWE18YJoBSnwC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> The patchset adds support of REPORT SUPPORTED OPERATION CODES command
> according to SPC4. Including CDB USAGE DATA and timeout descriptors.
> Timeout descriptors are zeroed currently, meaning that no time is
> indicated, but an encoding of it there is.  Opcode support and Usage
> Data are dynamically generated - reflects the backstore configuration.
> libiscsi tests for RSOC and tests that uses RSOC command are all
> PASSED.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
