Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DF6C77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 01:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjEQBhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 21:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjEQBhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 21:37:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5646246BC
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 18:37:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJx1cE021201;
        Wed, 17 May 2023 01:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Eq9Ii2h0X2sALF1SK8tvS01XmBjrVxd4BjNJIqEyP8U=;
 b=oLRGDBXpo/xdzT1aPpJ4qNqfonGxbGxxaNrvAiw+9Gr4WElXhUl71tOEkjaPz0VKJzWg
 XGKXUJTuwbDNCN2TyrAXAWOyTgwwFU7kOhDqh+wUeVQFJ7upB5uxpfQ0IoiLXrHTWQtU
 nkxNX2IY4DUIInnE4yQvbPTD5WM5Se5ZiItcd9eLox2St+7XNSBJ9lD6sYYRajzy3Lm4
 j4fcv1kbQhXkOcaM3HGjjcXaVjnvmbZ5YBZQIBQ4Pd7/0v/+Wjy4pKwM8oxkyTnST/v0
 BzazEYSBhRlhghoZ71XsYyG5J/xz1K7RaDNvN+N217zW+EPIIRHB82diGBe9JLU+aVPs bQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0ye4esv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 01:37:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GMrmtE032186;
        Wed, 17 May 2023 01:37:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10au37w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 01:37:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doDqVvaKnaV3yQ/YcMN7ORT0smOiwPfZXYxgGAmvOnlSX6pvW/CbYzcmFSzf4othPCMdJ4nVSIh8u4GiJKXmfdbYnmyDFghoUvtntO7/OQBn2vuapsX7u3e+3WtSL9OezI8e4QvafC6D3lZeFZG+yw6dHgaQ7DzyMmvCoC84qcQiP5KeM6kAhgOIZV82mPJlT0jTkBd4cvBIw53zJDIOiubPGSwkX5bfLxDEvHHxQx3v3k18BOB9nhL5CVoTuLJRgDjmM5aGlVfhDT+VW2kF1PuwjI0uhOOKIGymE85ZzksGO4wVbg48l6WleDKrPqh04H44kpna98zK+80sanDglg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eq9Ii2h0X2sALF1SK8tvS01XmBjrVxd4BjNJIqEyP8U=;
 b=AIBLZOVsNzX61OonmWLNGBu95Zi0qX2vTOjltPo3FnjB26axc2Rsa9MtruU3Y8ROX+RU8ruj4LcPIWtHie0jShGA2Bsx8vUP0d8+dxP8ioNOK2pjxuFLmKOdS7xb6EBK8T1JvYAster8f/D7hZ099a42tTrp7WWfA0rUETO7FdEwNgxvrfDiCoFTZOHPY9e51at9IOwDcgWm5HalwFgiXGQTidu46nEmr4hh20og0R3QkzH6Qm/ofrjPzBG6WZh0xxEf+cc2i86Iog1WbiNbyrQxi83pIUo9BA2Lhci8buGcA6iYeJEyP3itEEMoGCrkGFVb+6Rh0Qhh3Vu/AyySJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq9Ii2h0X2sALF1SK8tvS01XmBjrVxd4BjNJIqEyP8U=;
 b=p+YzgOi6fcE32gC4IOeCyYxZRdbnVgmOd90DnmhjICRj2LUzu806gc8rj9mrbEeng8+LxC+lKiyFcO4aEPwK/RM6K1XK/BPVWtiaE9VXXoGW7ug4ufaReYjqKMBR9xGvMdb3YOlnIz/cCVIAwqtfSnDgMNufHZ5uXZOhvXtRl0Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4867.namprd10.prod.outlook.com (2603:10b6:208:321::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 01:37:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 01:37:24 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH 0/3] scsi: hisi_sas: Some misc changes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zg63u4ac.fsf@ca-mkp.ca.oracle.com>
References: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Tue, 16 May 2023 21:37:22 -0400
In-Reply-To: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Mon, 15 May 2023 10:41:18 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB4867:EE_
X-MS-Office365-Filtering-Correlation-Id: d046895e-5fbd-4510-cd7b-08db5677440d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CL8JSPW+Uy9gZtBgKuqZNI3MNrndXhsi7fokfk2pa6fpaZ0Bx+aHeGnHtgdppVdcR76bUJ+j1mVkxZPrkjLefRIdgEzWsajx32J9Z6fn3Y/+CnZ0PlBVcqHcFQ0fIof4gGHyu12+2vB2ZukUAzGibg7b5c8So+5zy1SHXQqvgA3FGGAOQLPDt3e0NeNjsnNklTkqGZUlV9k0GA1smSQ9BhfClnie4nut7EnkDl951IIiJbOOsOYxkfx67G3HjxYHNke0fxBRVWJGikfEmbCPRNMdbDtlXjEyGnUpIBW8v1voRVb7UXttLyWzhUDda1DoI+EdGX5cGhIOqMlqB4+q7Yv30x78WbaCkmYCgqyIpDVn+x+Tu9VzvRxSpAx9uzi73NGFRCAj3T5uQzM0/PoxxnACh8Bj8tfKrrMIH26fGDwVIx4mWCnGiRhLC6gq+b5ZxoffxFFjLfSRf9dmODYZnjvO3JS3ThVd2IOjORjv4R410eVUa8U5brnEtlJoq64Ri3Uwk6zOSoTx8InPOQI9he6Xvz6Snug7NSvu/ATf5B0GJMT+AuefuvsLOGywN39f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199021)(54906003)(2906002)(5660300002)(83380400001)(8676002)(8936002)(41300700001)(316002)(66476007)(66556008)(66946007)(478600001)(4326008)(6916009)(36916002)(6486002)(558084003)(26005)(6506007)(6512007)(86362001)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pt/qv/IRXCmCLwqaRAvGd2kDzhsuF1VH6C51qBdsfYh+2SWu+aIOcKHp8Ivu?=
 =?us-ascii?Q?L4K1tb5C9U7UDhISNgNojmlbz0tdR/VvXgEyveOqgDHItZgE9wno1nFna7C1?=
 =?us-ascii?Q?RXZ9Gs0kD/OGCC8AT38py33jqnM2gc4ZwAHbnWUHwKJrNtw7qJp5JkbnPzBM?=
 =?us-ascii?Q?ytE5tFSWfuRWtdNZCSGNz8p1Rf+6HHWJ0oAwMrFc77w8FLSxsxR8RDutzqiC?=
 =?us-ascii?Q?2PnOp/v6giSj9Mkxhx/axWH8dwdmZsNUkbFcUh9llxudhtkLsvj5eiHIU7aF?=
 =?us-ascii?Q?glyopzUGOFClCQc7HU/wMYcC3OhzYcu1n19fIIZbGDoo9G5u29grboFt4aMs?=
 =?us-ascii?Q?3i0W7Ux7eZccqxj6/YmniTEe/668rDiVEhnky/IOEDQMLuoNymz0KyATjfi8?=
 =?us-ascii?Q?+jJtESmVKgJ2fYBV8Ci4ImzXJyzgkwlOi4SJatKKbTDy+j2uqTOA9Hl9vV+k?=
 =?us-ascii?Q?8H2phqGCILHQkO5wSmyijEh2hljVrq50IUHKmd0iCVaHR9g74k16ts9CiQJV?=
 =?us-ascii?Q?IQwO6coBFLxGiS4BhrKVMhG60NIfc6HCns0y8eUaCxvhr2cNlaFAoJcU62IP?=
 =?us-ascii?Q?rYlN37PyeqeWowrWriTunIctKsAvlpBtDjkMqXi9g5HyMA7xj02HYOfrnhjz?=
 =?us-ascii?Q?+qowBDufpSk1YbsY+ohpFQi/kaoW9XE7XsNGuA2zBGhlElxvGnNmPetKVpB0?=
 =?us-ascii?Q?bdpYkT9ZnpAad3H3tGuGdLlJPc3nwacUWZj6JRVyFmsFAMsaP9vg2qbt4I68?=
 =?us-ascii?Q?r6jXt5BGpBynYH9+VQGeHnTCApQnrqUWYrI3wKSpIlEIdR84HDaOrATzxp9b?=
 =?us-ascii?Q?Y9Mcu989lLroUzyGmUtXg+05E3rfZx5h3ZCh8vOKKqyPaL00goly9i0zoT9g?=
 =?us-ascii?Q?NSyJsaepqX1RfrjbmmtwC/tawW4qoVqnXMm/4M178DNW/TGCA/m8dW2fwZej?=
 =?us-ascii?Q?vA9ZuQ0BaCMwuQhKVr4wOUrWUkzKM3ZwUg9tTCaHV5itFk6qjZ9Ad1dF82yw?=
 =?us-ascii?Q?Ye77DajQD0SU3c0vTZNBVHTyFKistE5Y/a/Xyja9HuyBFGx//EiuKRAQRW4g?=
 =?us-ascii?Q?AMt+Oy9Dafx/RxeyxlGzlIYEsE6rnGETCsF9owXd+MD1FbRHhOr9NhmmAglx?=
 =?us-ascii?Q?Fvcz6i7WJoWyOHrEPn8u6j4UBMP0zChsxB4Viu51IWlPje476jXsdEXSASol?=
 =?us-ascii?Q?ZSxWo1PCZAT95O613umuKSBSzPQ5QLzhpQNdaSWzoyGBpKnqa894DBBFv+FA?=
 =?us-ascii?Q?+aBMYEdvAvwDK8Ic4PlOAn7XoR/shxzSRtJwKEIJGcSt5PMSUmYnzQpzrO7z?=
 =?us-ascii?Q?djWDH7yUpQri7FyEOh21sgAbhRIB4+yYH3raAbS1TD8KSE8wtLFydDF+9zFk?=
 =?us-ascii?Q?oeQF3uLDx7IaiMoyrmVqzeqqrZepMYcWDAT1/zUFpX6McGuDT1wBMxwHEwka?=
 =?us-ascii?Q?JCJozbUTwRRxnR333z4xRxsdMP2Aiq9DPeHyXdEyqsLb+BjvVCjivyZpHI5T?=
 =?us-ascii?Q?Nix5f0oUKOxWGNPyG2pg/4Z3zvjDUcngFenLq+X0G00BgZ506u30JFqvYGDc?=
 =?us-ascii?Q?GUv8SfggENYNc4kKuiRni5AQTfz6+FdYIMzuBjO/klb/TpDeJ1F++ue3Rk5z?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KqSWy8wRldhLZRDtqIDGo+OviT7ig34IJglFlKtZR7AiF6Cy9/Ss8WtKJnjnPwqnxOGlj/Z52XhOGxBLh98ciYGiy+ts6hzg8niOxfbuzsi7rfb0sxgiastae1gMXFtqTVv0kFfIg3arTsKgcwYeTnZpo7MBOtOJ1uEqLTxi7+HAxiVeZMQBAj5G9QoaHlPN5I75til6N2uS+n5fMgyQ/VR4Ymsqun+m7Q6D3JGAXl5+Q1JZJOBNKdLk7FGD6yMe3eP2vI6MMPOLE2ntZeoUSRRyQ5FQjwOZppqPkBKHTVEkJIRRubKnHcahtUZjsW7yCoNhLBm0g8WwQ094B2Mvr2OewhTCjcDPx1ep0j01OrBn3ukExjKS5MJXrPHLLxTkT+JrRDBrYcsIbDLnuZd/QnqcGgk8NecVEqUAms19s0YSCLUXJqVt6t6RbJhurQiwV3YHG7OyVhwHqePgPKOuRX98M2sbtYmiG5u5lMKE82fztqMo3MP3/DZZffuAXt5zUiOIdpZx1e5uJLVNspdIjKb1/cR9t2cpOwcqBfbYLo+guaKGlmKB5rDye5kBAcP9nkQTIKbfp/0N0HGK1cQGWI8s/IYrul964vg4Y2M7vk+WUnaHE9hCzWMENYIQDgzd/yAF74Grx18A5HIJXdUTX11Xzopsd8ZQQWVUdGcZgRmFSsovLRDPeeC8akpsWeOLoEMU5rehcdzXCKc8SCs419B/yrzzeSUPpP4fX8Nrgb7KhX0jtQHBxqBSU2Z9yY7bnAXV1970zqHKSCiMN4IGv3Hn8pJGfIzVaGXMFUkINJROX9arbiRuX3VJas0mmon3Hulr9H6g6UNB3LrjmWH9h1aNEyMskQoQir15xsg5cHA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d046895e-5fbd-4510-cd7b-08db5677440d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 01:37:24.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBRodE/xxH+dOeBZhXIQQ89+nLhAlyJbziZ9Gkq0VjyXioWf/wTnwKQ3ASuUN3FNUxL48dj0IjT/G7qMwWGKsc0WnTkmYo4dAzSqusghCm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170011
X-Proofpoint-ORIG-GUID: LhlG6WE0f8o26C_-QPGdaRZ5AZORzIqq
X-Proofpoint-GUID: LhlG6WE0f8o26C_-QPGdaRZ5AZORzIqq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> This series contain some fixes including:
> - Configure initial value of some registers according to HBA model
> - Change DMA setup lock timeout from 100ms to 2.5s
> - Fix warnings detected by sparse

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
