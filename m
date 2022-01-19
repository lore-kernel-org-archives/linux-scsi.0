Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27223C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 22:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243951AbiASWib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 17:38:31 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17318 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243245AbiASWia (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jan 2022 17:38:30 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JJuauT014094;
        Wed, 19 Jan 2022 22:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=opxrvxQGgwqA02dzi+JUkRj+doDOygj7quVSQ472Sm0=;
 b=HPpql91aQM7Nd9vi7Uytgzlg0lBAxFCnxPaWtXwtDLV3zyf0CkIEJG7tHsA9GiGw1yMy
 DxS67J2Rv/0+qbgEwz8gU4SQH3/un6NfW9sZQ7aty4zxmo0KCiWULi99tul6L40ginho
 1Nb2QKl1qpensnxErFVMBfWrUiyjM+Wa+8km/M6L0CQxugN1PIh4fn1CuyQI+S+V+fPR
 vDbFHxKqqCGTWYSr1H6S95J2e4BPbzu2RGK8RrrhDqLF/gTJ0qh6y45/vmgjx0r6MZja
 M7+AibUDlH7+uSJuVCn49pZzBnVIClQ6FvqyDIJ01kDvQi98YkZdcazXwlMpKaHxUvDt IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc51e9p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 22:38:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JMUckE056758;
        Wed, 19 Jan 2022 22:38:27 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3030.oracle.com with ESMTP id 3dkkd16q79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 22:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUw5KSke63+OGf73X+/0/yWS6t9A2jQhW0RQ5n9KkKSJ8B7uah7OtZY91ZpzHR3gHGmaZm3Av4OvjQcsbM4/BHtIpI3hgQjI5/p/7Wm4/YLDK6OpJDbMwVG7GUjTYJOaDy4V564RVp9YB+sBDR6qr/mBJ8JvPdw6rngUqTd7TIkplo0LnFDiX8+KXQLivpAAmQ2rSDg4Vvtst+QXk/0wSqNYJVUasSy4g7DvGo7vgm7wfomO3wYKhwZizvM40/MTEh++NS4WQddlit8hGpvMe4806cELGJqX/Mf60o4cUfi7ptLVqpBFaYViUyUn2VaBVnCo0577dc3BJ5rULWMALA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opxrvxQGgwqA02dzi+JUkRj+doDOygj7quVSQ472Sm0=;
 b=BTTHVfGiurHUPTgjTTKVJBJvd6yb5tf7ke2hbSgHJYCYQMIzVkYnix1ZFolohWHbCcz8HuRVQMoqarVpKS9lEmgo3OZGZxmVI+XNaC6WB/kc/+o2DFbWeeq2eM/dkqCmOAds05DSigYF7YaS8D42HE0BRPpnynq/wcSWQqMUrdt43JqAN3Z4Zvae/AVkcKQIuFAa1c7RG2Hd9pZL4wHFc7louuRgHrl7vVqjkXtjKVZKFTx74XcP4LA6dxGlAOAyvL/w7yVVGnVY4dGWkoseWr8WV9JvmwCS5Zdp5R25mlsxUKZsT8zTvXBEYdmgbp31CQsz5alwwwHY8EX7eh/wvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opxrvxQGgwqA02dzi+JUkRj+doDOygj7quVSQ472Sm0=;
 b=Jr8utY+O4IoYO0iPP4q/cdeWiSJY83/F3bEGbxstLsW3wrczwovPro2pFtXW4I3ejedGcpbFB4IOCJq2yeXEp8KTa1ReNmULm4OWQmDfzrTAPbhKzjsqeCYiapcW5IST1pHljAFE1pJhJ86EiIYPSJGG0tigHisNSw6z7m0jXvE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4297.namprd10.prod.outlook.com (2603:10b6:5:210::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 19 Jan
 2022 22:38:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%6]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 22:38:25 +0000
To:     Sven Hugi <hugi.sven@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Samsung t5 / t3 problem with ncq trim
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tudzidng.fsf@ca-mkp.ca.oracle.com>
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
        <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
        <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
        <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com>
        <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
Date:   Wed, 19 Jan 2022 17:38:22 -0500
In-Reply-To: <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
        (Sven Hugi's message of "Wed, 19 Jan 2022 19:59:12 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de3daec8-a31b-4091-beca-08d9db9c67b4
X-MS-TrafficTypeDiagnostic: DM6PR10MB4297:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4297C4CEFB6DB77586DC9E7F8E599@DM6PR10MB4297.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BlzX+CtTDkGjQcFsgfEE7CpMe1QtQpBh4BsSSztOiIPHQBOFTbn/5u0jsjlVLKz71HwZO0nkzQxaykv9l8fZg6hOATn0B97Nzvtd53er19/G2IOeCWjVLJCj2AAlWF500ase93jgo7Fj27/QiASciWW7Q1LeATaYuWzGsohLliX2OYHXlG+i/yApYHobbmj31bkBcVcqbwbZKXSeAm5I+VOu5ZZwBlbHKJmcGbWlEVDnjBwARwIZBUiqkM5/ogKnR/NG9g/zE9NKGoAtZJzSwZiWVaaVj3BKbenYmwfENWqwGKENPpq4yaP7RTBJmkl25/PrR+H9FqxY/P296p5Gi5WeZvvJhXPviM+BGmDyYkcn0Yu9qqFvUrX1frNyPKnhCddc+0hovVpGI/pQhINniHXX3nqI+ro+LiC+DdpmAs7SbFNGy1Ti0Wi3k+y9fQslHZklPvAt31MiWVdFDg5iPOLIHYyUEwif04cjI92iCXanzHWLnY2JrWhWykSTPIz6AW3t3w0TIZeNtR4ln1/kPySie7GDEbWjzrcNasq4BhXv5LWCBXA8lkkhZVAqPPegdsOgQYuEsNUdTFxj+2lfy4XsxxHslECwxDzsVP1A86Jz0vr9H952xXlPVL7yJpkY+V77zVtOBeR4/Eks9CtMOyaSbrX5tNEGiHJdHU1rxZDpsWxJIbJzk8qrz3jaShZqAOtZzZOaCCPVfaRgE6sw6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(8936002)(26005)(316002)(6506007)(186003)(52116002)(6666004)(8676002)(4326008)(38100700002)(38350700002)(5660300002)(66476007)(66556008)(508600001)(66946007)(6486002)(6916009)(2906002)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QLUjthjXf+gFRGozFasxIpE/pL9tM/c0ikAnhAYWzeHxNzl8ZYXFNLBKZz4o?=
 =?us-ascii?Q?KYZjr/8u6fDDU/nBsF9BaoSQ0E//zZWArAJXcOcHiLEmRN1raY7+QuYTMwhj?=
 =?us-ascii?Q?Cc5HW1JAjfoG9lA/XSAP74SMwvLVLA11dRq+btw06YRP+KitrA4ppcm99pDd?=
 =?us-ascii?Q?R8GygY9RGb5G9aeh4EUlHlJbWqvnAZ/Si6q6YSio9Fq/ycJ1Wcnss1YyYE/8?=
 =?us-ascii?Q?UnAqwFJgb3mFhlBxm3GXAkh5lhksF52nyc30+uTUDDQelk8FBoz+R2cT1tLh?=
 =?us-ascii?Q?QFEnyXkcDGITIH/CctIv0hOhtq89BUDxBGwMmzbtUD6po8GgPKOPcDXTm2cg?=
 =?us-ascii?Q?YMw3lGAasFF9OXq/w8YA5RVhFLVFprRrfmuuEIu3yuyHNjL6Wd8BUAtU3xOC?=
 =?us-ascii?Q?zMBT0bvS2Alg3QQ6Vkc72bAdMsH2evHBeARNPf9kobuJXRW9O+SyVjiKfJcq?=
 =?us-ascii?Q?wd/hm8x0HHSxDcj7PmU8VOxCDqYsq1I9vkwrtoIyP0kUtBQKCRH4asJJ4hXK?=
 =?us-ascii?Q?dQFEj4weDb+eSAyFSpI7HgZOakFfn3W5msGHKxlGoQgamPQA3fenAv57wtg8?=
 =?us-ascii?Q?+VQPf7RYgXHESKE6yX+p7H9L6/DAY5mTY05YALa+ml9yvVy/rUcrZ4Nl9NoJ?=
 =?us-ascii?Q?zVMLRdqCSqX0YOLAPqbNjJy/lbg0K9NO4XYIr9RLKItKe05ZnbllJ7o5hhdT?=
 =?us-ascii?Q?DfrZPQG0YU7iTr3n+e5+RiU7VCtfYj2fiQeBZRYJDqqMHMPWwEmJZj9iGgAM?=
 =?us-ascii?Q?z+jvMM56C54iZzKYpAzrRqai973tqWPTgM9x0G5D+Uj2P/Sm2qaglrFbw3ei?=
 =?us-ascii?Q?Icw0jaRnWYyhNikPiu5hfC0ydHvshp2tL1vgvXYwvXKYWCcdh7lIhkYgsSoe?=
 =?us-ascii?Q?42VGZaSxhO5Mmg+v1VDojSHZNU62tMeUZQoXuIAZsbBNSeZNFcsBonfULUVR?=
 =?us-ascii?Q?wI/k71G6QTiuAKNLhoNpWZiJp26BAamdeiRB3I5MKQSoSMW8dSULDIGUk7Ge?=
 =?us-ascii?Q?/RMoXByclOvQa5VClIfnEpiTy/SNMkJ6S8rOwNVV/MOzFfpQuGPpkCaEINIb?=
 =?us-ascii?Q?27Mj++/fM3KxEBpp5xrFOpbiKn7zsB9dRbCcA+z1QqL30ve+01I4C1MTzFtR?=
 =?us-ascii?Q?BcFWgD+BrVTsAgP0i7ZjU/YdVOgaAMSDScVjNAuuTiDPvws+qZ7br36cLPs/?=
 =?us-ascii?Q?LIQtQlIuw5ujOcGnAd5TcMDieF5vCvmxhY/Ck4+wxSPYpF9AIAA1Kfe8dVu/?=
 =?us-ascii?Q?M+//+trbRkRSrCICd/ywg1rGNB3zgVupcVFRaTyByYE0s6dyaFDumeXrKHbd?=
 =?us-ascii?Q?veCBhiY/2Jr6K9S9/vNIFTzWTPhWOo7liqtP7gEXehVT5C9D5YR2SoZaiFHA?=
 =?us-ascii?Q?eHBFfI+YJOhrCLqwdie+0cVmOzKkT+pku/ga4ia0zWyKxvH7Kop3PWvn1FxB?=
 =?us-ascii?Q?VRttX6m8t08/2Nm0SvhXAUS01Z0/DO7bsg67XEEere6MtOjFgafq2Fz5ZJEq?=
 =?us-ascii?Q?BapU7MvMEz12s5+HYdo0QtOPBv8r0pXPaCgeGyiXy0UZ/Ei7cFf0T5cvBSgU?=
 =?us-ascii?Q?TX9mgwR288InVHrKZUigi0oxfRAojgLIkczTi7aTCDtAeRZADxQpXNeS36ey?=
 =?us-ascii?Q?Dyda5MYE6+cgk4ySiKltKAE90ciLSE9qu6rnmGsGNo+mCtJPkdrWz2ubWJxE?=
 =?us-ascii?Q?R1PmIA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3daec8-a31b-4091-beca-08d9db9c67b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 22:38:25.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luXJfoSDYEpzRaBAaj51I0oJPBfSU2TxsGI8jjlzMw31nu1VwCDQWDo5D76cpTvIFCuASdaGnlGWhzYLnWWlmDmfHBeiZMDVaE/z0/gRFvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4297
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190119
X-Proofpoint-GUID: RTGH-lpqfXD_6k9k82AERGn6X67I5FtV
X-Proofpoint-ORIG-GUID: RTGH-lpqfXD_6k9k82AERGn6X67I5FtV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sven,

> The 850 had a problem with ncq trim, disks randomly died and got slow
> af with linux.

The NCQ quirk does not apply in your case since the drive is attached to
Linux via UAS. The UAS-SATA bridge drive may or may not be using NCQ
when talking to the drive; we have no way of knowing or influencing that
decision, that's all internal to the drive. We only see what is
presented on its external USB interface.

I don't have a T5 so I don't know about that. But I do have a T3 and it
does not report LBPME which is the SCSI way of saying the drive supports
TRIM. So Linux isn't even going to attempt to TRIM the drive in this
configuration.

You are welcome to send the output of the following commands:

# sg_inq /dev/sdN

# sg_readcap -l /dev/sdN

# sg_vpd -p bl /dev/sdN

# sg_vpd -p lbpv /dev/sdN

for your T5 so we can see what it reports. But with respect to the
queued TRIM issue, there isn't really anything that can be done from the
Linux side since this is all internal to the device.

Had the mSATA drive been directly attached to a SATA controller and not
a UAS-to-SATA bridge things would have been different. The special
handling of the 850 in libata is meant to address the scenario where
Linux is talking to the SATA drive directly. In that configuration the
decision about whether to queue or not queue the DSM TRIM operation lies
with Linux.

-- 
Martin K. Petersen	Oracle Linux Engineering
