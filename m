Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FAEC05027
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Feb 2023 02:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjBOCQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 21:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjBOCQB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 21:16:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03E25941
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 18:15:58 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EL47Vh014396;
        Wed, 15 Feb 2023 02:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=3Ptl9UgUSaoGR6EndeQhc8rIdm8WYZxYOxUjNROZ1EA=;
 b=iT7aLzJAR47DY6SB/k9IoY9aAmJyJbXSp6yl/RFGp2JbhYKzufYrMju9iZCYdAw/nFRg
 6MOP0VdVw4LP6HkHsMNRaIRx4MhR7Tsev52w7EaHzDUxVV44fUUS6gPrkUGIgRZ1Ysnj
 6eNjZ1rE94GCMyOctNFcV8xgRkZrG3hkUvxZYeQcH31FZI/bVzXUVLqVfHMpe99kh0J1
 HPjun5X6lGthk0wY5x4GOuHM3acgHgSpfbe4WFU1hjqoJSKiHaXlGKyGjo6OkLkTtzlw
 lpWpzSx9t50w/3XfEB5FVJfMQyZEujnX3Ml0Irr8qjA84mh/zsUn63TR6E8bdNNOad8l 4Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m0y5d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 02:15:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31F06j54024647;
        Wed, 15 Feb 2023 02:15:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f6xwrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 02:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJyX2G9U+gSp12Nk27XAEhTA/Bsc6fQTcn1e3mvAewFj6mAEibo+GCDUkVxXI21TYDZ9/2u2nxSSeRSHrLhgrRJPb7zE7FKy1RVROW/Xc2w4Z4i/TTXvtOwNqXZipwxHed2KviCRImIFU0/aWX9puWdQGFHpLcbFmUcs+25pm+K2+dvYVMCx4jx5Jh1MHwloFrc59H+aug0CAYZyEfuINboWutEJS2a/6kPn/unKnzXklb3X50jpq91ngmC8U3QIGWB+V1rB9obIxVVnutiG/dz2deBJ+UOA3QPzL8iXGPm7myL8YpILf4nK9POqPc0s7Enja8GIxTG+TRHx5hdKqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ptl9UgUSaoGR6EndeQhc8rIdm8WYZxYOxUjNROZ1EA=;
 b=gBIwSvP5Ro5+mDKGFZbWrGE6Z9QK432AGb8Cl8monZUuJmH5QluV1Syh3+TBP6KA2OiXVFCLZDp/YtNQJBGbrV3jjrcdOgaSnsp9s0xzWDzF0ukAoeoJz+h1dvGNZ2Ma6zK5TXt06LlmbB+4T31Jcu+CAv8urZAC5sncVBj9li2KofLkI3sgzeqEFC7XSLEl+3dy+i+ZcZbL9K8nIEZlXiFqWxnW0hEKGgH8e+4gCaf4pv81aNfA9G4kd0kia//ba5KaS5e3HH+wRQ1Beghihwfk61sJRhPiaUzZPDbpXtaB4q1Oyss2X93CoHPrPvjhgE1HqBu+uPjfNkH3e/5eNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ptl9UgUSaoGR6EndeQhc8rIdm8WYZxYOxUjNROZ1EA=;
 b=a3lRxBpZZvdaXOKlilB6ebfSi1fKcBZo3CTArhGzhTzGv54JU4BTI9a9UgzS0wnEP/L4d1cRezuoVN5LU+P9B9a4DL520pT1uzEHV3DCharT+g73p2pyg2sn4LpjkskMbuT0y+X7tF1IhRK0yeem1j/3vThb4t5uc5K+dpumrvg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5162.namprd10.prod.outlook.com (2603:10b6:610:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Wed, 15 Feb
 2023 02:15:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6111.012; Wed, 15 Feb 2023
 02:15:53 +0000
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Girish Basrur <gbasrur@marvell.com>
Subject: Re: IO error on DIF/DIX supported array
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edqru22n.fsf@ca-mkp.ca.oracle.com>
References: <DM4PR18MB5220E0AF6564DF1A1F126EF0D2DB9@DM4PR18MB5220.namprd18.prod.outlook.com>
Date:   Tue, 14 Feb 2023 21:15:50 -0500
In-Reply-To: <DM4PR18MB5220E0AF6564DF1A1F126EF0D2DB9@DM4PR18MB5220.namprd18.prod.outlook.com>
        (Saurav Kashyap's message of "Tue, 7 Feb 2023 11:20:11 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: f32d7d01-0bfe-4fea-2207-08db0efa9092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pbYxcAsQItQa75uZ/Y3V9S1fZdyXyyD8Ks2tNNYhwzD4ScUh81sS8WUOCTXzmyDuYwlk9go/TRRQ2DxLIAnQexGqfs5y4XbQ1mw7g59EKqkPXjU2HGtkg37/QBGEiADRMCu40mP9aDPq70BvkYMzii13k3v3IzkIyEmKO3gJIIa7kkXHQKcZrBs506VrL+opWwTQQQPfXJNJnteGXruaGPJZ5jmN54yMvS/WC70YuyksINZO2YWvUUOgGvEFk7vWeABxomNCouojb8TxdWYFcYkS7vRCkNZ1Y+U3chdFzw/lNGPw+gC/bZHR4D3PMLTawl9D0nujaX3o2kUyuTX2Qo5cQ9Uh+J2NJzug3laP+/HCHm0Bn1+iqdMdJz7GrpU4Lz1X2q/7ykZLgOZTw8ydSuqQ1bc/Gz4H1NSNTufFf4dcJuR1ao+q+JPnWXJVhnOIEZ62rbSS6jVjar1phkWXByOCNpI4V9COcRWYFCLseBQVDARERiQCYATOf3vaxKOiPKEXAUEBWBHj3tens0WebK6KKQnX7XxLLMegwEUUO0vHrcRy6lrUh2k7mHKW4MTWREWx/73HP80HWHAyOxrLzswtQewgUlimd2jb+oRByMMvOvedS8DkCaYt8+iz4q+9IC3MyvVWfuPdJjcAFti0hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199018)(4744005)(6512007)(2906002)(83380400001)(38100700002)(8936002)(66556008)(66946007)(316002)(86362001)(5660300002)(54906003)(66476007)(8676002)(6916009)(6506007)(186003)(478600001)(26005)(41300700001)(6486002)(36916002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0CUT52hGpeq1K0nnQm12FZwAJ0thhFLyZa4y3iII3Wz5RfDM7ripIb44C6xY?=
 =?us-ascii?Q?WIeCl4xOH7v5y/Ix224I40N6rf0tKWCJZt86KYev5tZh6Us0lv+CqjbMXeNw?=
 =?us-ascii?Q?kuUHEkKob91xvQ8VqOR0y6f/SdIfRrAVbiCOiIiRxCIWYab3pEu31jiCQhgA?=
 =?us-ascii?Q?sMpJLZ8g13POu19kS2h326tlZRQEznM3bqt2iKXTP72V8FIhYMvyXGhZWCbg?=
 =?us-ascii?Q?ivSNEF8DtZWQyrPc4UXgeu04ZsYxedt/f/7ZoMLRLNSOBDWQRdD0tZkLv4Jp?=
 =?us-ascii?Q?91lCanVtUkoaW/E3gbi3VvcH/efE8R+TOxjnVrgj6/AZzg+4kmwW+UIindZE?=
 =?us-ascii?Q?ixtfwxeZ5Ophp29Wlx1YtEGbgHcuo8t4hCSC8jXrUo2pvCsdj181tyr5Xr2l?=
 =?us-ascii?Q?6TXuZ8hnG/vmcb9ZzRNSmKyxP9zplghOZdL8kijTDxeWoe/QTVpEPwzDHiU/?=
 =?us-ascii?Q?thUbrqUIeMdhzf6E2I83u1/1B0TZ1Z19ehiSdmGUjlDiqscDtjeRmw+HZA8Y?=
 =?us-ascii?Q?Jh1hzAn4DN33YniixtRKGhrvl9EAcmAp+uzeYaZPirXf1kWV4YeVNipyFqLA?=
 =?us-ascii?Q?1x2dyGJOHZZsWEhLH4D2AIRt2iy02yGHvy3A1QD0zN/atAFJdKNYrJ5zN7Gn?=
 =?us-ascii?Q?Vz53HJaSJpbDfRupFBJ2ueQozxNADAE+8kW6Hzd6CQQs+Kju+DOXN06B05zZ?=
 =?us-ascii?Q?crBrekDsBkO/wA7CkM8OihGUoZwXDcvS9RflihMIJadW9zJgNpjLlkCEiN2a?=
 =?us-ascii?Q?lCFuUtmt1q7xYmwbwEpLrb4jvX19b+PsJkDs/jKSmgFj6By724serufBtXSt?=
 =?us-ascii?Q?G3EM4+GuXG0g6f+Pf9MCOB8WEK0ZM6/o1SL8yXZ5z6t/Rjb24oD3ZoOQWKAE?=
 =?us-ascii?Q?YLRki3asEJzYgiEP7l4H9vv7Np58Eu2x/BYLPrXYOW24b4pzNl7rdmV+Yezy?=
 =?us-ascii?Q?0fFPd8mhNavCEdQbhMZlUqroY7HM5YlaoWvz35di2Xbk7WPaiX20QvRmEGn5?=
 =?us-ascii?Q?3uaNpHB+BjLE4G8IEbk2PGQu9KvvTfdbLhwakOENvuGnezDAF/eN3lycJrX9?=
 =?us-ascii?Q?15uoAMadvXcAL7Iir7Y49BZ5xrmHjzZVxMtzv90iBrt5348PsyBUw0oXW3al?=
 =?us-ascii?Q?GaG0CTvP/qI74c9ZGoRe2HuILFY/gzO7LbW1SoWVuB/OhcZU80IGZg4pC9uC?=
 =?us-ascii?Q?i9GO8NyLZxmU4pxZvs/dVNwcQUgsGeTGKzHE3eS5DjNHWquOaTkRczOkifuk?=
 =?us-ascii?Q?P/flytijEvK5A/rAIivofRXZwgigWEF5JtAnLcDC2yOjViE83CrI0m7/4vfv?=
 =?us-ascii?Q?STVf0/xU5FkKKHA73v9M+umCQl7Lt1FOSsXD/ymWUbsjnVk1nUPg3d79DGFr?=
 =?us-ascii?Q?fT96XlZDolEb/M9Z3CJkEKpbLh6LqVuCzi2jg6PTJ/A+7/5qOXFsVKdxpC1K?=
 =?us-ascii?Q?3ElGE/58UHdCB135qA/kkHhxWxPZziAUkD+ZDtoRwGioclpT6A8tDlfz+7F2?=
 =?us-ascii?Q?hE7Cym/NqcTGqQZagCKDFJwJnmnSQiva5Xl1aWACnTRX+yslOj/FA53jieBL?=
 =?us-ascii?Q?NsgJIr4JmLcWeNc2Xp+QzezIRimBnkl9WQJWk9AdF0ku+i1YDeqU1XCp57FU?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AHTAdW9DYr8TaMEnPCOtPZj7zNjFD0pobKW5xkudOx9YhObYua2XsONNnu+/rrXhLjt30FtvWn3lGyITHkuxcb+SUcxZi2SGl93pG+sflJZRqlU+n70egNzOCk43H6DvG3V17W2lCCDbL2xW7L/bulPoSKjF81ZWJqR1JaTsIy0p/M69Wk15UZeoGx/UD0iBtEiUWJwmt/z2ZUJfSpZlqNckUTulL/J8cA/Dm9idenxLtSSUfwA6asT/LRilIDYw7VR+sH+M8qpsb/gnDWtJRaHo1wC1+dJnNAbcXGSmOPVfMedWy0iJz9TnXg+EKcAtji9w8Ufvjr4r3jE8+Gl4fz9GwF7IYjFmlt+sk4eUlLOvBtUO7DkoeuNJbqTE/A6h/2HwB8FKgeilrMLqqqCwyium2KQy6n95oepeKsfTjbHFtNS80XV+EAmFnI7JMH/neIL0eGTUOddkR4a4BobY6H215nLZf/xij1HmDJh7q25EklhyjckE427qFiQIWXUiiHbbmnVITYTTi9h5ohjBroMwFhxMzgoh8K1DMJz0QtYmplALOpuk9UzChIkRkzBMsRYGyHvSUSpk6ZhboC8QFv3a4UKINEFvwVanD1dEh0XjiDly7X/l8NUr1YojTFooERQNXY5ZfhS11thJUwKDevsX0T6TUpAuZXMDPck7k0ncqyEubd7iUq+2WiDUS92msUhvwn6meZiIV/dD4x/eV6LKynrYCvuAxCaWQefSfhT7XBU2phXektNW2lsXMrB7SvEZU3QjvetBvftxCLRMfCItwYH9mu+l4UfJTuTsjQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f32d7d01-0bfe-4fea-2207-08db0efa9092
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 02:15:53.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YMIqLUpHk6jp0Mpk+BYTAYCckEEv4ssuDibrltYZFq7lo6z+YrA3hwaX+MlrP1v+04e5T0XWq90REPtm03QtGl16Qr9j5SvnJnHEib4D+po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_17,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=966 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302150019
X-Proofpoint-GUID: hZfwt4tlWGaK380LTnh3e1xGX9zFc94s
X-Proofpoint-ORIG-GUID: hZfwt4tlWGaK380LTnh3e1xGX9zFc94s
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Saurav,

> 1) Is there a specific reason for not copying the bip_flags in
> bio_integrity_clone function?

No, that's a bug. Not sure how that line got lost. Can you please try
the following patch?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 3f5685c00e36..91ffee6fc8cb 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -418,6 +418,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
