Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD29C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Nov 2023 02:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjKICnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 21:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjKICnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 21:43:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FB22582;
        Wed,  8 Nov 2023 18:43:10 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A91iVE2018586;
        Thu, 9 Nov 2023 02:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=IV3rmgp+j6WJb36DknjAtJTJiPkfeHrtZGdJrjBI4Rg=;
 b=MSDd/PpwxUrSxVDoWjFvhE9fe0+p9bIzadDhZLCKmAkHL1hM2gK2+mJ3mhvk/yNWkkC4
 vmTN39gFO8b270IeusZa6j3lc0nETxPW8R3qoAqSvF6nPBbfjdd8MWAgfTg7soANh6j8
 7plkYrpP0rnrma4iRGp0BMvQAeQreh7z4pI1EXZMhNS+qysEWvpSaILSrstdGiwYrtrZ
 j7QTk9rk4HaH5Wgl1u4n0wv8MULaBxUzVS/pfxSPyJKAvuph2sf9LW4e6a8nW11GE/fs
 LK5NEd3teSY4HUaw5wwD21egsNb30nTZXgurQwqGBzLEKjf+ss8CLrIoP2No77Hss2ko BA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w23k0bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:42:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A91lcpg017619;
        Thu, 9 Nov 2023 02:42:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u8byyph4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBau58ObHhNXCxj7klgDj+qGJQtJfLHyOgb5ORK/SUMxYR74EBbLISCKGCjLIX4i4KiQZVb/IR9EQZwPgF/nbW7ftPEN2gSrrgV7UdCFF7Fk9yvkDP2UkkwAAzfkhWCAK9blg74pVXc/5Twj6r+6P0+gT2kiRYQ4WJwFqxvuwUoeQ121TkaEcirrlLin3gYM/E3sFVGxSDk7aAzaUyeBQK/0u744qc+hOm3yrohvRGDhYoS5gJwfeARGPz/l2GcXMtgDSqQVPb1xT/nGkO7JbYc/H1c5JnSfzdelWiNIBkONsRvE6j0JTJRIpBpFezzm5vBfHjNTKNmMfFIv9s+vwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IV3rmgp+j6WJb36DknjAtJTJiPkfeHrtZGdJrjBI4Rg=;
 b=Nt933bSVj++Su/dVzbXOTE+Xl1ztgjq3Hq8+dC/vHx8BL14aJqIkR7S/0Tc/PwfaelX/77xnmMLRRHGkzmieUPXtxqZLfUUqKFXF9rO3qsJWVGuPoLzWqP76lJ7K+3CN3A/EcnWNy96mDam0ZC2RlxX/NvhHc/SQU35w5aVHYj/v3yy/KDh9N05wsENE9t9+xoHPFqvMkLYGhRS+/ME4BPBQLZOdjDkFwu8yXXW4gizPQNwwjHuKfp8+QwygEXDC23goG8HDY0okF7y9vEcmUHnrD2NizNc3vaEQu5wcdNsxIZFZeUe/HTZY50YuVsFOOec6wDSXlZyBzbyuBumung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IV3rmgp+j6WJb36DknjAtJTJiPkfeHrtZGdJrjBI4Rg=;
 b=IGmoFQRDVfNNnEay9qakJls8d1ENuIuS/B0yWlNyyf7h5U8yDxLAuPGTHSe2rKGhy1ilvzV1j60EEaUENa1aSfZdoGiC+EgmRzCOHXmmFaPG5CWuyY2bq/OXo5cNKhccbKlp/BifQ4V/VfPLCJb75ch+aLNFhSKOq0L/NcxojLE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5179.namprd10.prod.outlook.com (2603:10b6:610:c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Thu, 9 Nov
 2023 02:42:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.6977.018; Thu, 9 Nov 2023
 02:42:46 +0000
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 1/2] scsi: scsi_debug: scsi: scsi_debug: fix some
 bugs in sdebug_error_write()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15y2b6413.fsf@ca-mkp.ca.oracle.com>
References: <7733643d-e102-4581-8d29-769472011c97@moroto.mountain>
Date:   Wed, 08 Nov 2023 21:42:44 -0500
In-Reply-To: <7733643d-e102-4581-8d29-769472011c97@moroto.mountain> (Dan
        Carpenter's message of "Mon, 6 Nov 2023 17:04:33 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:a03:255::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: 9268979d-afcc-4f46-ce1b-08dbe0cd8e70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGbT8HJ3LEEjhlJhyWExq5CVfcI201qtdJoQyQE7aTPpcxWXTfwTYvgBTzfAAkJSVxvlTQWUBEMGhltutlEUc2Qq6CHfCc95iHk5hRjjn7ysH4Y/eHmeCjrvZdA2GNJw7ztcHyhb+0y52o2sKyEwfEOoZ4h0kwi9lxGZvXP/iAk458peEQTBIKoGc44fA2z0AYTLE6ko43V29nwR3ODPrRuIR9nVawk6H7PlyTTCaS8tKxJCd4A61fQ3HupyKpgvNzNwvmLECBbxoSPTvY1XBMG3pbKV1wfTn3GJeeJ4OESHuNEPcUgKAO8WlEX+KwtfmECzFqfvL64n7eo5vaS6yvjVrojY9+OUxEHt+jjl24nh06rjMf9mgkJbpowg6Cb2cnTWigomVhvdOjBkaF0XWUCIQEH0FvmChXfC+b4mng2jN+8fch8vocg1HFlHlI33R5/PQjUMU48JTP2PUcwFtpf9Pb3g/NUqcJJy07fTFH9ORcO2zsteimdmLZRyNQGfsdvyw3DQe8WB0cOFnEgSRlKPrP1eWy6Ra4L7DlvRs7FcqLHYETAtED4wDygU4u1X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6512007)(41300700001)(36916002)(6506007)(38100700002)(86362001)(26005)(316002)(54906003)(6916009)(66946007)(66476007)(66556008)(5660300002)(8676002)(6486002)(8936002)(2906002)(4744005)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jyV5P+CejNd3VxoaVx5OT4piXXiMJd4SPbq225D3TFhul4iE58tcmSw/sC0Y?=
 =?us-ascii?Q?+eD7Q2zFkHyN2ZhlKwkc5yxFXjKVJhM2EIuMQULbRFEhq5Q1N9A7gpOxZEHo?=
 =?us-ascii?Q?S/PI4oEkqzMetwSO4trbaStyi0UoT5hap5WqMFq50Gw1bk3pg5Io41yxjTRG?=
 =?us-ascii?Q?Y5jKgh+K7lDffaTzIV1yAIWMZHW9Er01uw70leBrZ49IAoLRRHQhFmZenvzH?=
 =?us-ascii?Q?aYVoafKrXHv2KeoyuyYd0pXU5YjnsJdERwSgRB0Kj11DiB+xeWxsCoEzt5sb?=
 =?us-ascii?Q?2cqrQ2gPCmeIwXazFgWjZ1oPzuGzHYfvbC4N7FZ3bGpWh5SYOihEnRHxZrjN?=
 =?us-ascii?Q?kj0RR85EXwbRVnugvyHuW3m1fiEc2crbEtmbP78aFSsx0Ci8z9OF1IQxWyPM?=
 =?us-ascii?Q?GFwlw78shjCGeN8uiHIYoeVcKpEkBWRaaDX6r17YP8l/v2z3EQnL0ap9srJk?=
 =?us-ascii?Q?+uBwNpZBHwpTdG5ldpIv35YEu/vtlS9rHf5T2Ow5oNKY1ZAU/pPItp0Luw/i?=
 =?us-ascii?Q?kBwL55y1YmN9HlROOwD+Qemi40h1+LnVzvHLDp7dqG2BuQVDZmHAtgWxxL6G?=
 =?us-ascii?Q?4jMMar/FQhwylU0vTSuwT82CdDDRlbZuqJVyQ+b3dX2SIGiBNFXcLb7ZMJql?=
 =?us-ascii?Q?PmMe+Zs5FtY/e3Y6oLB7IRcK4v//2gPvD0CiBf+tthaQsQRKEo8gZbyV+bwc?=
 =?us-ascii?Q?/FuRkmAzZfJXbSlNus+Mw5DT0KwGSXdi1LYEBOJbpOeCGBrRBnEzXgrORXYX?=
 =?us-ascii?Q?w9zMxJ/iAT8eof8qyb9kTB44GSEZtBO7RET5pKou9Pxkxs+TWhmVgw5AqFyz?=
 =?us-ascii?Q?U/GjrQ9p19/W9P38t5Ww+n6pVUy9Na5UcxYkxNsQLQJ7e/CLA+fq2Lh14SpM?=
 =?us-ascii?Q?6rugJ6zIPWiGJ6o/Vhxu2liwj6tyo/Hh622ewQrf3lR5qy36V6DNKkhfz6Y9?=
 =?us-ascii?Q?52Cv4V20u5SCUluJfYwOmgh1Cul4XreZDDhaWoX4ydH9KtRCxhdgAecN3igi?=
 =?us-ascii?Q?lDGbUja1Xy8uckcmk4B4zBbGmtm2fVeG3nDrf2UzFB2p4E1W7en0w3gV0VvH?=
 =?us-ascii?Q?KNWrTi6MzvkDS0Flyj70bgMkvmbOukPHWViadh3Nrn5yEZMdLBpVZaydTuyj?=
 =?us-ascii?Q?S7IT9pD4fc1Ydl48da4khf0hKHCJ29FXE0nv33Caa3kcdgfBgE8SJN+qZXXy?=
 =?us-ascii?Q?HdWPslRl76NVhQLQl228t403avTXOqWNFDTPLbx50DndW+Dn1d0WqOglSx46?=
 =?us-ascii?Q?L9nxF9V2eUTK3MnRcXXymYk/5RU7dSD3MZoTqJxULphL4ftCKUBbvbucUL9e?=
 =?us-ascii?Q?MlGPSdVhJ6l70zkx55gTpyZff/TkHqDbcdPWKzuPOG9NBj+USX3QqKGsoB2z?=
 =?us-ascii?Q?X0yot1TZLqvz1SZFKxX2wigDe9M0RxPQi9s8i2M5hbSkJN2wlNVzIrLpoxmq?=
 =?us-ascii?Q?Jm3I6Rk16Jm9zc3a6xyYm2Ai7GFSYVOVqu1dsEzvDUShFQclH9lBqUbJ3NbI?=
 =?us-ascii?Q?fY9FrEv5Mr4zfd2M6N6ei792A9qZjRORgq6HaxzSI5VYc9h73ivEfkWs7Msg?=
 =?us-ascii?Q?bIcqi6iajXlkwRKfuR+duYMy1ckc27Vxmpl9FXlBEMgrDf4MDJ2D/ymX/+aV?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WMIWIQsaSKKfOVtVNYgESqTb3a5PoiFR+/TQNXya6+Dcqu7T+znsAxmM9F6Ie8PfJT6zyM475T1wVZeA95whRs9yDQCEmeFa/CVdUg1uNxp2HiiWGzPIsFxdzrP6qUFYUdTDMdrpD8P6tnr78rn+OEaKeSmkfoV1Z9ormp/XsDHwvXsoWklxMBQxwkDYleIAJfjCMYcwzqIXzyEqZKCVT0xNkySTK8PUpPJG7AzdwOXJ4j4cFafYKAubitOdbgCqyUueYbdau4naMflQnHK+ohpwveAhWcNIBzbGQpS/mfe/4XqCqqifOm/6tInByUg4UX6MB4JNGapLRA2eUzZdbH+N/1QkoUwsrc/SpZPdj3hdLbafcVlQ8YdIjsihyzau93rSU72xut+SO70j7vhq7Nqvq2zuDumY/spRm5i1aOPb94mqKL3vD8SJmU6wwlql7fyeu1t+yQUZW0uxNgX7JncAURGvg4jih3XQgLdZ0ygqColFQ7qd3G3VIfPTwlNFe0VlhcOJ768JvLxiWn57wMrr4fQHkAaZ2leZ9VJ0KTTnTHkqxbnCNR2Fo05MmDILDFI4hw9k1ZpiBCVXRj7dC7AsZSLOYxnRKS6kgTzHhGqx+2AUYGNlxb9ieL3yh9xwdt9cE/31JuyGSVy+rmEYoRiIdcGCJPwkT1PMIl84103trY/UCQUV4wA+NmB1a0PJi9rnfv4STZL3MNeq8Nhab7lWg7ZLv+bPvbP/oXS4nk9gOdELWWoJiaR9YSfc/EwCRBFjygBNET7ScFVo5FEY391rVVFRp4bI72mC2Redal8EzogAP754yNKRQutik2kDeYGUmIk/nec/TZVPVWFnBJr9+lMyMj097a3YG+1qVuHx35RpC6PYr0BYrMXZMpASerfRU5UJ2++23urWJh4Okg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9268979d-afcc-4f46-ce1b-08dbe0cd8e70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 02:42:46.8561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEYjS6h8/LOPQqxRsmUe0XWiHttjV08ZFkI5o3qPkmGi+quEfNr39eQ7rCBGuV5PK15CapJswUcbK1YSneiMtNJUtBGA+WSG0IwmQxKhkPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=646 phishscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090019
X-Proofpoint-ORIG-GUID: KPBXAowRPP6TuDJO_1f8178e5T8PUGX4
X-Proofpoint-GUID: KPBXAowRPP6TuDJO_1f8178e5T8PUGX4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> There are two bug in this code:
> 1) If count is zero, then it will lead to a NULL dereference.  The
>    kmalloc() will successfully allocate zero bytes and the test for
>    "if (buf[0] == '-')" will read beyond the end of the zero size buffer
>    and Oops.
> 2) The code does not ensure that the user's string is properly NUL
>    terminated which could lead to a read overflow.

Applied 1+2 to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
