Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCFAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 03:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbiDSD3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 23:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346671AbiDSD3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 23:29:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498972899A
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 20:26:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23INW3RL013493;
        Tue, 19 Apr 2022 03:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OOSF4qABviAcS2yuoBCiPRwZrPY88a+Etnj4KsxbTAw=;
 b=Hyje9bLTmd3jcLzMcJo7Upnf8eLA6ARqRH3dMPFff9Ln43utj+qnxMSAbgXMoJD6UVdQ
 ogMUzH0BkJuJELed+0ifFqlkyUJ7lE1x5sZYFCEzGvMfkIE1roxala8cXCfNcAxH/iy/
 VxYxMuyb+MzUstW6z0XOsASIAb0IwJbU7rI+f4GbIaOx5MVpE8mU6pGh8oLXlcBmX2xV
 hh6+RbxI/RTaZp8tJzy5SBYbE9jmdYfVvzYImDmteAkML5NTeANic57ZhaN9Mb688MMh
 QRpONYXvNunQ30oKafmmXwwHhYkRyfzKTyZunTG5qvEy21m3NWk7vmlCMP9de5rx3h1I hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffndtct2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 03:26:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23J3GSc0009989;
        Tue, 19 Apr 2022 03:26:44 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm87tqam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 03:26:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvdo1TckkGGBrnKGw4bHP4FTo7pp3dlFU2OAaQ++c5IsH9FCDCsceb0SRNTq6CXXE45IofkeM+1EDam5q+DY9zr4kvBovC147VuCENJV5+YTPtBwArE0O4AEJqMSZGXfqm3Hqi+exSTLUj+XAnvoUa75bW+cb79tSwgAxKq2zcPJDWZygstsgX4RUw8SbRg0BxxakG2q0Hi7kwX3V4NhBpiovPbj6S7by2FHbkkqf7RxD711LdXFVJRrt88ebPaj0AUV2MveQvulNWpCSG8UeKgFSKGT3Q5AdftUeIph1SHn69zgb2K8o73icsYhmmrRtoIJ6Oe1Tjr7neYpTdmLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOSF4qABviAcS2yuoBCiPRwZrPY88a+Etnj4KsxbTAw=;
 b=DTqzg7tdzvTGDOFRlSpPfU74Ww++PstFtJiXkvM4hBioTACkxHPdDJuWabDONH9K1mt3/qXCO3LsOI+a6Jm+Bo4kHxij85WfAlNOUFeE9tk+Qyaft9wbzd/p2RB8GTrjGpYRWlb2Yvolw/8+GwGhMu2ldosSN1PNEhV5+wE5zqpl8VECraFCdFTucTpVBq8hgP2oVPDEb6GVEwOs7OBDiNc6aq0t1avFD2yDAYOawB0myiFoDzqNnzd9KOrl2UUosZcFIwm6VL5zocjyMmGZtSV32XWqDzoxkmrEKL5r7EYoyfJQb+32QVonDEP23+cYH6+SoAL/ipOtKarpzbp5WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOSF4qABviAcS2yuoBCiPRwZrPY88a+Etnj4KsxbTAw=;
 b=b+ThbXPmnwl1U93b3/9/zIokAdSloiUBngj/kOfKpJNgy+QMGWDuwxz6gIu+x1ywFCYZq2/u0OIEbEg8u44Q/3wP/XUFgrlnuUdJ6Fzy0JdxpWO6MbRL5FcV5fNE56xVjg9/5kf1wWCqfGPV+da8r7RpohX5hcfmZhUsEr0iAUQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1873.namprd10.prod.outlook.com (2603:10b6:404:104::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 03:26:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%7]) with mapi id 15.20.5164.018; Tue, 19 Apr 2022
 03:26:42 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: Re: [PATCH v2 0/6] scsi: fix scsi_cmd::cmd_len
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lew19310.fsf@ca-mkp.ca.oracle.com>
References: <20220410173652.313016-1-dgilbert@interlog.com>
        <20220411050325.GA13927@lst.de>
        <aa2a08cc-ba98-b538-2448-d528e8eef917@interlog.com>
        <20220411155258.GA25715@lst.de>
        <67af49ba-0d39-d0f6-b6fb-cd49dd32bbb3@interlog.com>
Date:   Mon, 18 Apr 2022 23:26:40 -0400
In-Reply-To: <67af49ba-0d39-d0f6-b6fb-cd49dd32bbb3@interlog.com> (Douglas
        Gilbert's message of "Mon, 11 Apr 2022 23:05:34 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0077.namprd05.prod.outlook.com
 (2603:10b6:803:22::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f48ce81-33d3-42fa-2c12-08da21b46c42
X-MS-TrafficTypeDiagnostic: BN6PR10MB1873:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB18733D1E98215721F0531A1C8EF29@BN6PR10MB1873.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkPBpTMQLNOJae3HSva5LaimwY2zpBtUdOjpn3DGN4TDpGLDSyGQu7YOUfD150yA+bRJgnF97FQXoPUtrznFB6gYeFOY6Hm9T+/7a/h5gnnk0O7gMijmOJUmYv4IAIjaTvPpKckxVapfAkC+y0W7Pz9STD/fUs13ZLSKP4ZcCc7UvUlm4OIlRnFtDwiB2KLPGuKiAL69RaDr15VSnqKpmqXk14ytZbo+SunjSC4JOFDfbvPcC3MoFxPz8Bk4MIWle75pqBKQjIG7aVLf5qY8xFaDXPhByHGA0owtGy0gVd/NkODY9t+ya9PBJLRNvsRXGHiJzIMCxubiJXsFMwQGwnSBGP+OkHQ6t+qz8i1hr2I7UJweNVod0Qx8uNw6KSKbLcoUnkWSvvtlm5hzTqD6JwC3LFO3LVKahGIk4L2w9b/WvjWeBhGO/z93cWABGGPwThu4Uk+b+QNV/GLvKRPC7DjMxp3GxAvv0Da/lrrm0P1lIavewP0HYZZ8mbYGguqQBU9D2I+JsM97eifFB2pYNi+bPIURuthDk0pSWP5kRd1xnqD4cYOqh+vZ7AiOfhEivdtnc0CVytQ3vyQwi7UVh4qwZoh4H/Z8NJgufsJgQ9jvjJ2OmilwLyJlfZBMDb3yRcTctizXYrftKPDNcDA0hqYyofOyxgtOGSqWOjhhISyoZaSXNjJ/j4QowESI/l3T/LDaQdAd/aZWOEZBjf8o9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(86362001)(2906002)(52116002)(6916009)(508600001)(316002)(6486002)(5660300002)(38100700002)(26005)(6506007)(36916002)(4326008)(6512007)(66946007)(4744005)(8676002)(66476007)(66556008)(38350700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tbT/SOLDNeL2oAwUNu67lk9ZqTFHkJFEdk7Jt/dlUPQUZGckeBporvtcUDB5?=
 =?us-ascii?Q?VtIOuWKiLf2UusV0TArgBJfZemKNLfpa8U9l3YZ14i4MdsFYKV3rXTqwd3hz?=
 =?us-ascii?Q?zrwY0WqWbXHLI/1kz4Egs6jURlrab/3NnkHwUoMltxRocayklHqQUoHvYKv2?=
 =?us-ascii?Q?maVxTm7WXgC8W+477O0g1HQwre7SCK47dd4k58cjy6DrZUG5KhlYMwKiptxK?=
 =?us-ascii?Q?4NkpfeDDRa1BR9aYA53XJ3gVPV9no0JqRlYTIOt9dRH4j4h+nZWrROjGT+dk?=
 =?us-ascii?Q?TVvfB1CtTeCHn/8wyZ8cygLGnW7e1O0CoXk5AavXEmJ8fPQSHC4vh1ND9MzG?=
 =?us-ascii?Q?vbVu1FtKeYaVV0ddDyBFumfQdMYWnuzJgxLQtTU9GpEQlMOuXmzyugsmUhYE?=
 =?us-ascii?Q?tQJcksfWmZUN7UxUmeUzRZeR0t2V2QBGgjNk3wPf+h7LHZp6m9jmOCKHZAZj?=
 =?us-ascii?Q?Rk6/Ifc+lg9uX8r++E/6qwclyavyGPBj0hwQ41iNS5BE6SV+pU8jfTdks5Su?=
 =?us-ascii?Q?2aMgeM5JSX9NrTmU3zKD6fu5JKlCV81TycFsL05uFFRfvxWJwfm91CYZCl2d?=
 =?us-ascii?Q?MLzR4tmHxzEgKWBvbMDIpMMD1ErK6tBdyQbWCzSiMteWdb7LSx9uqHanV6jJ?=
 =?us-ascii?Q?MbzWjdaVXawcxCqQrUjf6XIUwKTdW9hQlODD+25mgTKSzEeEFo+tl+K4prnU?=
 =?us-ascii?Q?uvyfeIDNXT+JFZ8emnYEVRdbiML5K/kuRD9UIZhbZWu8NBpZd4RZVUbKCyBm?=
 =?us-ascii?Q?im0+jC/nnJke+8CxmwSx4VX/d76DB07/NjfAoyJkLkyL+5/xGJBhmR3vV1vz?=
 =?us-ascii?Q?XcLDDPQqzUWmPFp9Uvvn5WkBCFMzIrCOZrcuSaVcweRkfTo1KVOWUJDQgAaa?=
 =?us-ascii?Q?9pkd6zn86VShWFMk7i3dSc+seJ/ZEIVuMnzFSMDGiQQN21965iqggw+cLaAh?=
 =?us-ascii?Q?OoOoQUPYJFXkoqCrJlfTF23dHU1Ioi37cgnQvzDJQyIUNuc5RCa8Dj4Fxl9O?=
 =?us-ascii?Q?h0beKcOkw5y8ja9otXMLmLeDhizhV+ukWtfkiqA93Qrm5U6+HWG/86FMnD5d?=
 =?us-ascii?Q?x3UTmKUsrAHieEuaP7i8ygRHoxW2c9/TZk0hAbKXJw2Ub7gOzEjtk43C321w?=
 =?us-ascii?Q?KFbXlZmV1eIt+deezD21RKnU/rt1Rl0q2YRj9X4vMLnaFGtuVYANM16nKXke?=
 =?us-ascii?Q?Ut/k7Q9JrC78gOgzptRETUKPx1rYFrPh6LZc0gngVl4QjcTwXLVI9Prbbh9q?=
 =?us-ascii?Q?RFPCym9+9lFeuBIHheJAvkaHt1IkJagpXT23FZNMSXcyQDPZSyR6ikkf/VWr?=
 =?us-ascii?Q?uJ4CWeUgiELIJGe0P9cnMebjdAl1r3MOxKm/TjEcEErCiKbCxZKFfTBenHSW?=
 =?us-ascii?Q?ifOh6Qn8Ko28qFR1wagHK5X6lvyHjAFxeHTLaYpeQ2qg85vZ/9oKyBd+mOiq?=
 =?us-ascii?Q?nYBc7isFFZjT0SXpvNUt2RrdLxOrvLD5hjVRe4KaPbWTMOQA0r05+tadoqdX?=
 =?us-ascii?Q?IhzJH/TTBuidDv4qdexAADfdcJxwKCrHsOt2Gff55nx37rsKgUBy+EKS5Xia?=
 =?us-ascii?Q?Dqvb4zB7jBrhUFqFhlZ3cbi9e5ES502JzQ5PIJ4OUdSIhN3f1KG6KF9ePz/t?=
 =?us-ascii?Q?pmHOfqFph45RgUAR56LbO/SqUXuhnfdLXo64yXdrd80jwvjoEn86d9VgAbKz?=
 =?us-ascii?Q?Jcgl7p0IWD+IitTP4QCoMogCfuG8x6ulq7DAD6tuIjtzQTrkOuaVbwHfIXxK?=
 =?us-ascii?Q?KUplHIva9LDuAujShe8egQov9MPBdV0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f48ce81-33d3-42fa-2c12-08da21b46c42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 03:26:42.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tS+tEiG3DjZwOnCp2tatigN42/rMhPNax+3le0TPWLyHGXQFvDgVDNehEBchmrTi9NqNshFqSfipfZuHBVMVivojWpEHsbDHdpXxrDo2f3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1873
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_01:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=483 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190015
X-Proofpoint-ORIG-GUID: ISlX2qxXWL1Eg0M_vRdg98UBLaN9x6jO
X-Proofpoint-GUID: ISlX2qxXWL1Eg0M_vRdg98UBLaN9x6jO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Douglas,

>> What exact regression causes this for real users and no just people
>> playing around with scsi_debug?
>
> Sorry, you are regressing something that has been in place for over 20
> years and required by SPC (1 through 5) standards.  The onus should
> not be on me to prove that regression is not safe. It should be the
> other way around (i.e. for you to prove that it is safe).

Christoph's question is valid: Ignoring obsolete command sets that we no
longer support, what is the real world use case for variable length CDBs
larger than 32 bytes? Which devices require them, and do we want to
support those devices?

That fact that a SCSI spec permits something is not the same as saying
we must support it. "Required by SPC" is news to me.

-- 
Martin K. Petersen	Oracle Linux Engineering
