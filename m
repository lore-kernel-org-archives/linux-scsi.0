Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674B2C6FA86
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 02:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiIPCFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 22:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiIPCFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 22:05:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47871EC47;
        Thu, 15 Sep 2022 19:05:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28G1wvpk018461;
        Fri, 16 Sep 2022 02:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=fECfvmDt1kBJ6mKuIFhYDTseCMIYHCOezjL1KcnTi10=;
 b=zlG2DWLsy48tO4rg7l1LPfAdY0Tjq+ISuUfNYmOli4vPZTZmP2awAbNMU+dbUiwD/KBm
 hWGQ1YZWWZFV29tANSfh0vstrq7gmr9iwURzbCPwsDq5GDHBgEV4vkrkf5HzwSucVQ8L
 MKTSiET8rDh8spHyFXBYWp1NoFxFOMrpmQ2gs1K+KdazofuVmCFJKbcGpvt70ydK4gKg
 Qeoj5hh4fA/nE62pgWjlNuG8IuI7IPuf2dnegACZNKwBK73MLW40qprN2ca7IMvSpo6O
 t/C/MvN/AFjT0zUF7Sqc0vBydehuQ98SrzzL1acXqNE2fw5vJ52JP2bAYtmjGtcOFovR oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8x892gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 02:04:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G0P2M4013045;
        Fri, 16 Sep 2022 02:04:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8x95m9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 02:04:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVGc7WpRoDVfo0zWVLem4r3CaD4pnahBu+O69SfHhQ4FcmFlNETW6RdPwvypjsvMjKqTWkiqyiab+mDEFZ3Eh+nM9MFaZYPzPjWcn5me2kYKRzZwTXB719DQr7KE6ijQGvezS+LqQ27ZrtCLqLBiX9QkdE8zGmiMxmryADtItGTtbOCawrmpxUsClrEnrvai7oVB1HNqCC2LdVR5GzwLhkVdsXxQjfrh5qmlAzx17qHfg8G/ABSVSX7qXCZarmxJAXYo/XwwCBIJKu1ZUQkRXX0z2ZB5u4Y0zuMgByz0eNG5PTeKl65t4Joe2AtSJ4FSapQvqFxzFaG1/k9b9Gx4GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fECfvmDt1kBJ6mKuIFhYDTseCMIYHCOezjL1KcnTi10=;
 b=mXXVRpoDhuLlaZEla4/mQj0wiZIE23P7Ft/IvrbMQ4lamqphua059vByVfAEeZnLEQxbB+bKLw+lZwiBk1YEn78WxXDdrMajD3OJ1YckhTlNmdoh+MwcVqFEPrA2uEVklU4EQW4fWDShmbGq9erHgQWkpnnQ75kWCwbPXU+RDHA3vsNdV5Dj4fbqt3h1fktHWSkWGyujEyUlOmUKWpAQGNbXh/FNcLZsNvdmkD3H2XTqYsLOj9EJ3abVD+7vT7D0lVwDa4d9Kd/V23ah+51Y8SR8lswMAUnSUiq+eTEtryVqA3mN0ok67nkpy28h/a6TjBVsN3fHOy99/UHvGlmDlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fECfvmDt1kBJ6mKuIFhYDTseCMIYHCOezjL1KcnTi10=;
 b=vOXLYnOcHMuVaQP+cuMlxmUON7mh44exDhBuJjetziqUIIA/GzWVG+C0xT5B2ZsM8nD6avby0In8nYAHhrFvQOORVuCOw4rwutTKuUq0r5HGNzY+0Xl5KbZo8JPGLtcvYBRnHK71MQQkaZNZn7JxsikBvXcw0yxAAjVePQ2XalM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 02:04:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 02:04:56 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: mpi3mr: fix error codes in
 mpi3mr_report_manufacture()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qsc2hy1.fsf@ca-mkp.ca.oracle.com>
References: <YyMIJh1HU2Qz9+Rs@kili>
Date:   Thu, 15 Sep 2022 22:04:53 -0400
In-Reply-To: <YyMIJh1HU2Qz9+Rs@kili> (Dan Carpenter's message of "Thu, 15 Sep
        2022 14:10:30 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0127.namprd05.prod.outlook.com
 (2603:10b6:803:42::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: e98a14e2-81ac-4ca4-775c-08da9787d9df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZEKuoskmBmYtBynmsxMG/tWiZzIqMxOKn7NIyJpLWByiff1UlLPNXQVVziPBnQJ4oUrQj03kiCwtPjs5d2J7DuTXMXlMVJ9EvmqL0O5UgOHvTeohI2lbojxtdaQoyWEvhzpcp5gzsGvn6g95+v/qUlnSpxXIPgAmOo5rPbgPKxgoiukYs01hsBhHMC4oT8Ycs8KgurZjprbaEu7CMzf+/sA+YevO/+d3uaJoBdfgLei3LZwLxDvvcTuibzHTQNnKh/+YShh2W6+ERZY9a2zzhn4JbcgCG3jKGrpqo8rW/CKsupLT8IZcZMvEHyI+WYkZxwtJ275U8gsSda3xb+lbpAd4FBmd+HYOhCoSlHtcW6h1Za8LStQCo8ZcFGk7iA9aoqakc2qSmpuGPULiLfu0sZECNsnL5bE3xa9wHrMIAIXxhpviFSiTMO0wgPU1bldq8VXJ7GwsUE4jJgx8XV25vC2YglGFP4RD5U56+E5n3PiCKyrQCIduXToRLpngmhh6FvnNgG4DIKE+b72o4pJzs/jTYGVbiEyfYQcqdJ+JYdkt5SXAdrL9OERF4evrO4aqPPY0WzTwNQZ4ML/nA3xGojeOn9q78Ty67YpOvxdYiNRLsuo5E2Q23l/LnvxcLGAHb9LN4ryCIXbultU86Va9It6UEmCCqYL6XrFh1msoDvQd9uPKeD5yjbdNSon8SbffoLPVcjj2daJb61VtBSu0aPUGbqLe9ZuMdmHIpyVTd/DS+GuD4wP8nLYNSe6joAZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199015)(38100700002)(4326008)(66556008)(5660300002)(4744005)(8676002)(66946007)(6862004)(8936002)(6636002)(54906003)(316002)(86362001)(2906002)(66476007)(478600001)(6666004)(41300700001)(26005)(6512007)(186003)(6486002)(36916002)(6506007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DZI0R0mCHnRGOU18e4bqa3IT44JueoCLiXAsX4Qdab0xt+14CPRZ6Cz9SY9W?=
 =?us-ascii?Q?UUpSr5pGItfRkR3tSq/mAxV3zr6BecA0WW503FyNz/r6CzP73sjBNQVRFYC6?=
 =?us-ascii?Q?c079qG6LjQrPheuf541146opO9aPwiKe2ip2aHOs95TleBwuIk444xILCpN7?=
 =?us-ascii?Q?PXdCuCdk+jfVgP3lw08QxJtWVtsbk+nuLbxCPT/EUjcm3X4k9KQ0lUX207nk?=
 =?us-ascii?Q?1avh1EDrVWOl69DCtKM0mj+1/OQ8UTIHUzRq+fp7tEbg5Rua//AuwpHS7h8m?=
 =?us-ascii?Q?+44nVOiFXD8gpmHbBmnB5W6laaA0DstWWgxs3Y364yyCXtbGvw3Zy+Qafn92?=
 =?us-ascii?Q?daX436/U6vap0ewyJMqzhIQzrk978vwOWjG9jaZHtOPTK8pnd/bdNB5U0BxP?=
 =?us-ascii?Q?76errMNCjD58YXGhcSYPOuEr9gfd5ZOlWe1gwkwC0APoiAIvGNFcWe2n71Op?=
 =?us-ascii?Q?baf9rXsOZ91iwf4qYcg5SnhTJEQKVX4lkmFcLVmrhnRLoZJiM8Cwve2+35Cz?=
 =?us-ascii?Q?gNpuboey26rCfZJxnT/cOMoVD7viH8e5yHrtIHElbp/XaWWioaRfCs3s2OWJ?=
 =?us-ascii?Q?yWYDj8z6jHFhbo5V7TfacZ7006bRZEfSPprymU4H9HSrsRa3DGL7MxxK4be0?=
 =?us-ascii?Q?HG195XiJSVEQEph9dZbdcYJwIppGe2XRVCy/6PsGNZ7b9gwVc7Wg7MId3kkZ?=
 =?us-ascii?Q?P6fKRdKR7EReqtaqJF+Xx4xnUbokhWNvRlz9zy/0lo/kRQX6wx67T+SC06Mm?=
 =?us-ascii?Q?VKhByQah8DXBYT3VR+s/fMWt98q8ZMzCMyQ5AA4Uk2/ZnrHDfz8B+hSA4xOu?=
 =?us-ascii?Q?j6n+TLWkEtG3fbxTwie6j1V9IjhE9HB5zLen0kIDfVEwegzvkS0Gm5D8CXbu?=
 =?us-ascii?Q?kC9aajWuCclfQCnr2L7IvJisMaw8QFzheKHxrAdV7cNLZCMnMMBwY/xbnZP7?=
 =?us-ascii?Q?Z6+qxW1thpXGqzeZSxnKdwgAaU/gMQ+9asmuENa42ZdvMjvSK7ptm2PuFBs4?=
 =?us-ascii?Q?AYin931wfet6/sdxygoe9DlKrnLrMg3nesI+3fusMueUMco65h9LWSuaV8uj?=
 =?us-ascii?Q?88vblS47Xerk9OEOPgMIIR0xOBhLGjecPbYfhtxa7URDA5c0boID0dC4cjTX?=
 =?us-ascii?Q?8G6ACzTRN0nhmmNM66YUF6Mg2t0+29tzS12Mwa5G1UAwbwtR235wjG1l0qVe?=
 =?us-ascii?Q?66hS3L3bZlAJYGZjKqAFI29yVeHOZJj1GDqA9mCqW40QlB51kIqFoVfOsMI8?=
 =?us-ascii?Q?S7eEAWW7KAwcZOE5GZS0GgddtibmNnvDeZpGdMnSFNLAIijjnarlQpYLG6Vn?=
 =?us-ascii?Q?Yxj3xo4/65DT24nhI75vKyaL+tobhTQTqE+vrZR8Mea3tlR+9EZq6w+jH7Rt?=
 =?us-ascii?Q?611U/U+qHJgZFrvYSZMbZD3n/QJyI7WGFmm9stJs5UXw7cZx3rh6W1UYmdY1?=
 =?us-ascii?Q?5iVXKysK+aEJxtwgswm0hBD0uKCR02Mjque/xobz3HbMwN7T1WsieEByNjB4?=
 =?us-ascii?Q?I9suePSqvSN8Kl3M2lm2j9/aarbNb+SbzJ/mcYHP2bMSZXkcKGqBxB/rd9kL?=
 =?us-ascii?Q?SohwAqxZnAFmVSTexYb5yeUKA7lSjlrPxPAZqqs05OJPcLT6qbctSWGEr9MR?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98a14e2-81ac-4ca4-775c-08da9787d9df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 02:04:55.9120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSaQB+5kFm2uZzDKJ3c2jMplMHIT2oCljlAIAfRQkgBnevJ1XDYp6hqdsYKqth+przLBmqdEwJW9GHI3vzMr6Ovp+st+QuMaDOnQP8V6Nj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209160014
X-Proofpoint-GUID: CBfysSATc2ikLC4zzitbzk2d-VFGXcew
X-Proofpoint-ORIG-GUID: CBfysSATc2ikLC4zzitbzk2d-VFGXcew
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> There are three error paths which return success:
> 1) Propagate the error code from mpi3mr_post_transport_req() if it fails.
> 2) Return -EINVAL if "ioc_status != MPI3_IOCSTATUS_SUCCESS".
> 3) Return -EINVAL if "le16_to_cpu(mpi_reply.response_data_length) !=
>    sizeof(struct rep_manu_reply)"

Applied patches 1 and 2 to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
