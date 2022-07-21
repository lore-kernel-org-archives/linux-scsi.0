Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58557C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jul 2022 02:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiGUC3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 22:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGUC3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 22:29:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188127748D
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 19:29:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L0WICD025046;
        Thu, 21 Jul 2022 02:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=QuUobl3hnGKXFl/gMMaHUvFG6+LCVpxoc2QIjct+5nk=;
 b=XBeTZgZ+oXU/DWrgtrUTrESiiF7scZMdnyLWtCtbq2p9bCxp9xjoP5yHEtnSqPh/JHI5
 OKtWYbXCtRRO14QCax63yerf8xFlEHdPPRg1oEQUAmOL6fotSZM4tuw847/2EU0t/rV9
 CUK4BAnap+w0bcuL281vanPOWEpXUUfS/nMJUTYJ2Cu91iNcc0r7xPD1bs6U9hOAKSfH
 AQ7D67jsW0e3XIYg5y48qVCmx3ehqflV1xtxMpIBLq2Yk5tWJFNZH59OXMWGuzV5aGtj
 /Mi3t0SjqNq9lSUw1Mo2JvWa2oLYF5qj05Hv5r/t1A67Ogtc+QdOc8UPz+TsG3GnMhJ/ xQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtk7qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 02:29:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26L2AMQC039198;
        Thu, 21 Jul 2022 02:29:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k64av7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 02:29:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOQqclmkKz7qCDeoRN34t9ncsVfF/2Q/+/ZNpQM1jumoKUvN1/fPu0M1kODzW/V/FwNFgRf/q3IlY36uJL1+VfoTM4hsRbAogEI/FCobtvR6d+byb+ihdOcX1nEkdH5g85EK9B0wyV9xDgAqXvmF7o++US3fRkPX9DWSnbahePmPIXBPXPJ2zngAs/P6t2alV1aC1DT8TLbqa/LVvvf03X888JyC5ghlQlTy/SbQSBzg2Qrk5WEnqDrvGRoMfWqM7M7LMHlkmyMEM+eygz92U+oEQW0LyyQtTXwCqfcUtIyXf1NiicStRq3hOOMhyabXg7zSzzjnG81fcrncgkr4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuUobl3hnGKXFl/gMMaHUvFG6+LCVpxoc2QIjct+5nk=;
 b=R+VVfiG2fUxy1/xsvpE5NU+wlC6qGArAtctb0zy4sHa/x2PHHXAfCU8hcm6/3gw2pjUdVi4vkrtAPfT0rcewTEKoSKERhzejFXqdeiZeYEpf4cBNAznQFVjDcnflwk3ADLo52dTWX4kacMHT4UfHJ9tUd+okbueeesr+msqrTbLpXXw9LcBx2JUEAMvKL1qv2tUS5Nscc6e6ZNe1jWiurm9DW8644RBDDrrVUq7NfWZ5SSbNxwoO5OaGx/XNVwdkxtslM937MGQAl8kGUYK7E2485dlnJu1H8xil2+l3AQeUdwNM64KluHDS0O0RLxXRCazbnrQLkiS6CMo83z7IHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuUobl3hnGKXFl/gMMaHUvFG6+LCVpxoc2QIjct+5nk=;
 b=YVnFkSgkF5ZCHDOYNUFBmP6rDvAiQ2/ImGLh5cIqAbMDzDBfP52j7lRx2y6GEqJ/BC0IHNCIpyOLS5s3ERw5R6U3R63bZUrgksG7fuQ0X3vp68d7bsp1Ipzc/zk2L341fky6Y5Pu2Y1nP2rldC0UAc/SlPvQQ212QxTapbGQNZg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3835.namprd10.prod.outlook.com (2603:10b6:5:1fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 02:29:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 02:29:12 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: regression next-20220714: mkfs.ext4 on multipath device over
 scsi disks causes 'lifelock' in block layer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8rrkxwv.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-11-martin.petersen@oracle.com>
        <YtWPoZISMLxHA/vu@t480-pf1aa2c2.fritz.box>
        <yq1edyhrgpi.fsf@ca-mkp.ca.oracle.com>
        <YtaXi23TBli7F8Pz@t480-pf1aa2c2.fritz.box>
Date:   Wed, 20 Jul 2022 22:29:06 -0400
In-Reply-To: <YtaXi23TBli7F8Pz@t480-pf1aa2c2.fritz.box> (Benjamin Block's
        message of "Tue, 19 Jul 2022 11:37:47 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86e51170-6433-457f-00a6-08da6ac0cc35
X-MS-TrafficTypeDiagnostic: DM6PR10MB3835:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /RdQ1J6TT5zCtEz1aiUNKeqQcCEBBR/BK5ZhrSCZz4vds/I7GiCwKnNJPsf8u+hsCKRxR1x7SyqvnfBBN/wDuLej/tC01k+ABeLrpNjo6+jdM+B03FVBa01G5rfe4EtbN86n0YLSrM99b3LOFOxw5qCEFcTc5nNmJHBMwa5dJnTjJQ8jeRhpYGacKlvtPHEj9yzg82LM89RMVeeFaSUbbuj09XtvHYa8Sh92xSCoBXJ4+MsWJyHEBxlQov8wqLYZe9aKWdQrf8fL7vnwXHqLvd7+Vwkx2xFB8gmdZXvJwp16DgkBGUOmzPknikJl8vGSivNbiVfm/PShXZwpnZAF1FFlhe5gXi/5flCRdVYnbeJR2rFi8xRMbD3YfNpzo3eQccO4Dqo8V15jn7Y4D/OpK7+S2vSeKd1VWpGjxj1kgrpYMQG3OuLun2pA80JkqkTAC4dPAOhfE1R/bgjRnuTHl/Q4d8XLuKaod6QKeRG00oHol+jcyYtGpHMj/8xVBnFu2EXcgsZurHr8DYGc/wDw6rgclD4f8A0id6gCmrB8V/Gujn/p2lMR+noqW3LtF3oNUDvYu0iNXG6KayWuYPCn2IN3A1nWV99e/GLgOXyLyEf/Z50HME4GLOEaRkDkyAdj0C0LHORS6HKwlV06GA+4JHCTXypDxk1n/XkRKEjrMAGNQzK4oW2lUSXz69C7X04nLq5NfvUOr8zSOgmzFFfaBcTjNd8kqC6cs2KdKhXwBAXwRYaCNNs9/Yg767YKSqAOhMZl12t5GJ7nYPAq4k4VtzxJ4aAwhPJoasEKj/xAKDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(376002)(39860400002)(4326008)(8676002)(8936002)(86362001)(66556008)(66476007)(5660300002)(316002)(38350700002)(38100700002)(52116002)(66946007)(54906003)(6916009)(6486002)(41300700001)(26005)(36916002)(6506007)(186003)(6666004)(478600001)(2906002)(6512007)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TvW1oGwQhkjTa5MRJ6owbnP3KBtWk1I5Ue4GxsWnynWDDYYL73Hs0U5c6cDT?=
 =?us-ascii?Q?OBOQlrewzFVKiVP3NKHG29IhixTU5fkpa6JTMjXuV88i1tj3e2EJ01wtJlqe?=
 =?us-ascii?Q?gVi8EImQQ1pCv72LbWjCKOYxMIhj0WOQgvVbAGSEGNnVMRLB9pVmrHXDq0Yq?=
 =?us-ascii?Q?NMMzPmdHxsS8V8k0C6jXkadRmQyhoU8VgE+jP1VSOANdA5tESvidyTbRpBGU?=
 =?us-ascii?Q?DkyX8wcvkqN+JS4i1kr45gKY4p7SwwH9LgT94psbE9Hi5ppw9+y3BV0ACfeK?=
 =?us-ascii?Q?5oCPFL3WHX5x+jb+KknOAVJudDX6KHWjhUwlDvyMWVzwBmFZD4rSl+XrKejV?=
 =?us-ascii?Q?LyNBL+GnT9EBj0o0VVajbvTH7PX575ovGuhraVmEmUOv6B1mZJ2Q5UxN7srS?=
 =?us-ascii?Q?iKRBPTpjwypCxE5qyESwpnZ6N67vo/Dm5oo+x3OqMUQE56gWmQw2pr/cFF60?=
 =?us-ascii?Q?u8+qZK4ga8lgmxT0KZrZ/akF1UwmYTqLhVkQm+LAZfg3kyW5QKpbkqK81nNE?=
 =?us-ascii?Q?ry1dvV7wipxZjNd3a1t0dHfR9PKT4GF9kg+umkcU3CSTZIwBzRWt2mXVVOFV?=
 =?us-ascii?Q?4MEomjxec6EtVrVsWUhjPBX08b7dInc0XGOslo+7n5moMsD4VYd3w7aEvyou?=
 =?us-ascii?Q?pCIKfBY4fRJhjj41j3lqutAls8leIh7HOIKTFWwcZRRlT65gUURAq75cgfxh?=
 =?us-ascii?Q?QP5CYmhKpq85HtLLoYid8XX2H8PmnEv5MNavallD9BKQ1clkjnpvLJi8OGCv?=
 =?us-ascii?Q?EwXXgoLoziWweXBhWmDQvjPXkZa+9uipDE9oD/uZhImRPYdmo2Q7LYQ1NFco?=
 =?us-ascii?Q?4ZKSDDdxFPWIYUXu+RM4Lfd8jm+EDsrH58tsBwYCO5m4imymNpPSdpg8uFML?=
 =?us-ascii?Q?E+XSfgjYj+cUYWTGtcp7jeflZGeHkApw9aLawQfOWQEyjTTKe05bl/ImC1UI?=
 =?us-ascii?Q?iygDWQCKN2SgFO25kvrMpOFrevHjEClUE25kZO+GHOHD4n4NgRURe8YExZ0Q?=
 =?us-ascii?Q?hhqqLezTSGhrc7iVv6RoMt4rRCXCvyS/UIkN4TLUS8Y8CAarNbsFGI47JSN1?=
 =?us-ascii?Q?yC75OLNrjNiOnQC4lvPO0G4MEJqCzdD39B0cBTv20eZDP3+DIyMVd8j+LHUD?=
 =?us-ascii?Q?pryRrlmEtTmWvyTcNsF2BeuQpvDFfIlQLHTUKQQ7ocAXD/7ui+B5xGqlRsoe?=
 =?us-ascii?Q?fGPh0dwJuUyxq3uXWfH1uuyRHqe/JjZe3r78XumutbPQv8tTCszmLYZm+iNm?=
 =?us-ascii?Q?7r20MJgmjygo0dEH6k9Dz2WUEEvxkYb8TCh9r7HgWECWULpTuvofxoPXHvKk?=
 =?us-ascii?Q?cQ9hU9vLDjMKrgNj3inOjFq+c3B4PIGk5bULdreMfTOiUg2yyUh2+Z25z/zi?=
 =?us-ascii?Q?jq1mQjG32ooM9u5zctKybQ1gs1FmLrwhDi4kmuSjnvtbNG/uiT6vWt7x8tIp?=
 =?us-ascii?Q?BhESLXye9Hg7KYpbKx298onFpK1xrph5+wFxVcppmkj/rpRADiQESdIZh9qc?=
 =?us-ascii?Q?l/VfO8V7ZqXrGvMn6EzrGwFACo0uzRDcsEevuSpsd9p5HKIQbNoo9Md2IWCm?=
 =?us-ascii?Q?6VfnHVfQiuVFq7VIfneMWucdCDEYkpP0GaKBZ+93HnKbgNG+/gTPcrNvy+TS?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e51170-6433-457f-00a6-08da6ac0cc35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 02:29:12.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJPmv6giOq6g6CJKN8u2RqDrNr4vxdSUi3Nn5pmb8S2eZgzAI8TZXfnt/cIIadMqeOsMPplwWEP7+mA83VgCt4UU3JdGfi0UUIsCVXznEtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210009
X-Proofpoint-GUID: I62NuS4qaBvHV9c56UYRETPLUqJyiNt0
X-Proofpoint-ORIG-GUID: I62NuS4qaBvHV9c56UYRETPLUqJyiNt0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> This is one of the oldest storage boxes we have right now, and this
> regression it doesn't seem to happen on newer models as far as I can
> see.

I have not had much luck reproducing your results today despite
reporting the same parameters in the VPD pages as your device.

I would appreciate if you send me the output of:

# grep . /sys/block/{sd,dm}*/queue/write_zeroes_max_bytes /sys/block/sd*/device/scsi_disk/*/max_write_same_blocks

for the failing configuration.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
