Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C253C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C208E64E16
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBICYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:24:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhBICYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 21:24:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191JUbU012706;
        Tue, 9 Feb 2021 02:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RgIqZtG/nZVbWIwxvviwscpOFhvpcyCoO0paH1fyDG4=;
 b=nVx6AbKtMKr6qSTITCeX2axrEk0VkEdNd1ZGg+mpaukYQ1jTqrNKuooxJWoNhjajs6/0
 F3nkCsjkyf7EYiGW87B0VrK4dWSrs+CUB9ShQS7yzhfZDiBIoG65RoE4dFPjI1fXeOth
 YE8UEJgr2NoAT1J6wVMZ6o+6FvDkKWC+LYZkLpQZPoXRl2aXlEtmQuQWXz5prk3dCM+O
 o1xOMNJfg1RcdyE77UcQjfp4ZWDRWAp3/AV8p0e4SJTVOU9RzbHvRmtWSIVM/rbhdGN2
 xfxosGkOfxJpcXT2fwNg2wMnd2zp6L/0Cax+WeQ0Z+L2Qh9lf8ucpKaolpyQdIKy6PSj fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36hk2ke0rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:23:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191KpNd089753;
        Tue, 9 Feb 2021 02:23:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 36j4vqnx58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:23:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvBCf1JpVnvWWGvCVGQRTVkc3gIw3px+6C666G5o2rRXijhkM/YatNYeYXJd0rVm1LANLImYQqpqMej1noMhwQax9ueyCXeAgQuZJqXK/LqBbWGp0A40Dl6k2dPMt3jFQgGPmZdM2UgnaLz5RenVTModGDQURKbz3xx9YiNfQexPRx6fn0hK6lXXhzidfDsBV8AgeSNvySS4Sh3K5S5FsH4n1PNRZTGyjCOcTwCzimvPx9tqeTiMFs6EazpIC/bnyQKFxwYu4mEhMvTwyWHjzfn7/81RpMv923PebHYadB1In6PkLBORZ2q9Pc27yGezKa9TPUAa4M1eru7oPTmA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgIqZtG/nZVbWIwxvviwscpOFhvpcyCoO0paH1fyDG4=;
 b=kIOKTRpzveGod9JZhTFUNgFj+k4GZdbnVNznBtTsQ+U90vKDgkysUyVp43ebnFdB31Pwexq3OjVOKlctQ1fsgCtqvDwrOS0FGpjpkuQ3dDCWs1F+gHZZSjrjQabG6/bqeXwIw4PvhbgZmlnwM4vsFm6EbBvVp43JtyLPO2FtpB2uhbP8NAIEAjRI/ZSD9/+uLRQzzrRrS6SwRlCE5IpcJhTmX7j3JbFSCbG8wv0oeveSjVLoryMS63lFPTGHab/Pjm+nrDLL/Zs2olQ0UyC2LG2PBLtyeEyN2wS0cUiur4BEKt3eOMxdtUlH0ryZCZ0iMBFRJIxC3CBKuvlvOs24aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgIqZtG/nZVbWIwxvviwscpOFhvpcyCoO0paH1fyDG4=;
 b=edEZAbnZ9Wv5XqXW0FpSz7JDvY+yQ0NkFDpDC5cAvqok1EefH297QfP2GYkSFYyMqARicHG3cCG1yHG6jg5+qo8BbYQ5BdAgpd7/VITf1d0bmBd7erlD0AYeOYnQ76IonGiz43S0/oKH8xMczmPFLoEUv2xMw+tcRjpBmD1/TBc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 02:23:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 02:23:17 +0000
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Satish Kharat <satishkh@cisco.com>,
        Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: fix 'ioarcb' alignment warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1lqrncl.fsf@ca-mkp.ca.oracle.com>
References: <20210204163020.3286210-1-arnd@kernel.org>
Date:   Mon, 08 Feb 2021 21:23:14 -0500
In-Reply-To: <20210204163020.3286210-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Thu, 4 Feb 2021 17:30:14 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0043.prod.exchangelabs.com (2603:10b6:a03:94::20)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0043.prod.exchangelabs.com (2603:10b6:a03:94::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Tue, 9 Feb 2021 02:23:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c585b61-968c-4eff-1843-08d8cca1a971
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4678330981DEEB5B9F4B87D18E8E9@PH0PR10MB4678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BX5hoitoNsN1qc/83e3g/PqiMVAAenbNOtvOi5RubHHiN8e5/DtlSQ03vacm/f1f/bnon33wHXZokXq+sz1ZMlwzYCVCZdXzyXSAbF9oBFTSQhfb6HgjbWGcbhagjH9rKorZCAaRdIVAhbsq2C9/jGp0Id/RjM54ZY1o4VSErqyAa/iVl3UgmcGmgPk/W5ONDxqYxVUgOkJjx1TTLzYigfEFniXZOHmG0UBgBMiPoxba/EX3vw1Nl5j2NZAYAUQb3fYofDrQzQN4VC1ZXeAP9eomyEPfhuoEXN41j/Qz1KDBRaYrO1c3fLfz0xMFG3EbzdEIIQb4eEwH9KH4Mv+8mx/C3Mnfh0cV/r8ML+Hd1w2UriaPmjqg3Isl0L0E0WxfvKYF0q1yTWORyqipF77KoVaXcCM6+7m8d/qOhhpwg9hndZE7D9NAjPvlskAgjp5mOac+eS/p5r41iBvqlP7HALy6YZ0LwNGub+7ehWKRp2IvS4+12E5nanvPs0FPuJXpHZ/mtYWKhg2ezVmP9VsCag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(86362001)(54906003)(5660300002)(55016002)(8936002)(6666004)(478600001)(16526019)(26005)(6916009)(956004)(66476007)(4326008)(316002)(66556008)(36916002)(66946007)(52116002)(2906002)(186003)(7696005)(8676002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ro3XjzuK76dXUcYowG/hVcZYZCsLh4SnrmX6lqw23N5x0oAZXZD6UxFJx7Zm?=
 =?us-ascii?Q?eyLvs2DFnq4Q1Oraaz9sMgnqT4+yJPMF5CYjMpB/gp4Vx0T0oOl1A4A+pmdi?=
 =?us-ascii?Q?TCUdlGyQrDwTIGjaYoMk5Mer3WU3Baoh+ZcXbxhfzxKQsbWaV9uLKRZoF+gb?=
 =?us-ascii?Q?wkNpAqri3reVeBo54ogRwebRZlQ4nZbcwIBNWSSZ4CFno4s1560DAQxVVmQn?=
 =?us-ascii?Q?AeqQNrvl2UrD2IFl8ooAF/X/4oRw8igt7tgLznJq+5J09eIeFQ2gqU2b3v4c?=
 =?us-ascii?Q?8La2DP+9PLVJEB4yfkC9DWM/2TLekI2pochl1GgYWUcPY2i1tiw0BLyMfrZl?=
 =?us-ascii?Q?t3z96a5v0YsV7S1rJ66B5u8OzVjGhXuEEQjhaCD/deCtn7oaUhJBwLJhmtv0?=
 =?us-ascii?Q?9rFfCLTrctm0HcvLVH+v4JgNGgKohoHnq/3epHbcF9vorZv8pPGnc/0eTN7N?=
 =?us-ascii?Q?OuC+igM98Nz0jAiL/5wFsMqD+rNFd//KGMKl7i9Ya+wkeLhdi6+6QUhC3K0o?=
 =?us-ascii?Q?pZXCyFVlvu1ZQ40fqmhtqO3DZ36aPj8PaAp6laJKOWU0gPrTuPQBfXAANZrL?=
 =?us-ascii?Q?3EAtUceOI8iernB5VbeZ+AeN53XVB+POQ78qkgbTl5Q3r8C/ZeTDpYahqaeB?=
 =?us-ascii?Q?dLCJzSbFrqCEvGYblaoH3ZjawBatdnGQkAXQ0K37sV6KwEU1k8EzKy66kFX4?=
 =?us-ascii?Q?8XRQazFtf/kYOZC6F9+V5fSoDEWCgqP2N88cOcEB8HnxIY7Cpjc2NPpAtBHe?=
 =?us-ascii?Q?DTFzs87qkpYZbbEPFTWPiEdc3h3T23SuDBY2kWA8eNfOuYpzyWFfWFsSB3El?=
 =?us-ascii?Q?vhqc0qtdO398tGaPWLYNaigm1TSM0yaFD9BtvTjWKiCQ6yxre8FihGvWlDab?=
 =?us-ascii?Q?0P9HnrWeGnwZFvDcmD9id6K4CMCxpmojUVd0T5xUprXWVluTw1/NHvmqPRaw?=
 =?us-ascii?Q?WO94OKMUBMITcY6RGJPKcGfGcsAiRWsShh3sPdUwZrT+fzR9w+DRx5qcRNrL?=
 =?us-ascii?Q?LRmovztH4l6T2ZaEyU12Yna0pKwoiZVUeSoWfc7fNqORuj3Rg3JCmT/IJ/fg?=
 =?us-ascii?Q?XzVvPsCokkgq+/GV1wIwekT8qpM+zKwWJEoJ9RzvlgA/zJpU3QqLe2gSPkJe?=
 =?us-ascii?Q?iVDlRKHdKWFupSvyIAhA0MN4PLkgDWkvKVujc5T/MztQVWIzDgatJgg5b59H?=
 =?us-ascii?Q?PGM8JMErijMqvFIo2oSnEV/l8bpLl3YKm2URmw2EilhU0JQWodxSttYsWNsy?=
 =?us-ascii?Q?D7OFlG3Dnd3UKFbb4Yp5o285woKtXFq63Jq0fKuh8EReicdCjqYgqJFfsMjt?=
 =?us-ascii?Q?RiInXqSBziSP8j78tRypxd4u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c585b61-968c-4eff-1843-08d8cca1a971
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 02:23:17.8453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6aiF9R88p8rmTwHoTdhcSEJnztIy1fU/L4XCY3gT6FG/k7XGfvBkAXCYly/kCrIH+EAk+RgnyBHy0D/tgCvSqpJQAbQb9uwUvSVMILkOus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> Building with 'make W=1' enables -Wpacked-not-aligned, and this warns
> about pmcraid because of incompatible alignment constraints for
> pmcraid_passthrough_ioctl_buffer:

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
