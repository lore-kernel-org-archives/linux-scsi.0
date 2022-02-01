Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFE2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 11:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbiBAL7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 06:59:44 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41280 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237302AbiBAL7n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 06:59:43 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211BK2Sg031653;
        Tue, 1 Feb 2022 11:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=s/xoHoU7oLLDyXvTXIX+uEWlHDTZn0NMyE60CRf8G20=;
 b=oT8R3OPkE/X7F6LzPjn8qu+3FIekR0FI0q38Z3z04cd9WvjUsQobXhmsYYcCjOGVb8sl
 hgCL2iScFzf/iyxBST0VijB49as5EjhScL2xOhNcImNzqhS/IHzi+eZgUZxFc4CXfHjm
 LTIFIIzVd1BIfKoV7OncwjNRP8+p2rbu7oP4wn78MacPCTLqOaPQzSBB5I1VFeofMU+A
 vOC/4SRxgSlwq23r2X/OLdksWZfKmiuVL+ZyZJzUccM9nhg/gigsl49BaQw2whnJv5x5
 H4/uQY/OXhuLOrLeM+0+v6dRJgvQjySHHaw5wWeT0Om7tGiai3s3X64PzGUmMVBBgKIV 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjac2q14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 11:59:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211BuK3V174433;
        Tue, 1 Feb 2022 11:59:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3020.oracle.com with ESMTP id 3dvy1pt4g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 11:59:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZVDIzPs1PHvaelpDTbQsAU7tliBE/e1cq9Bo0rbhUKLFeHLD842L9qqyDXF3GsNojD5nPrWqNb4MPZcN2WF1Vh+/Wj7AT2U1ORprmfrV1Mdq5yKTS9mOlFbUDyuOYKsOKmTpuPjccZI54aqMIrNVuLv5hAfVbWwmG7a/U6Me6MYsOssKzLIseKrMO5iPrz+bfMhqzKMmrLSUNeLWmc4YO2XgF7eEj7wFoVwfesTshfnBLUor2fxogHAef+YY6sRyT332eAZ+AVVwLuqUAbNU8Wdd7NQZmaIBH5T1fqQOv5jlAR0XEHEn2NvYC2VHl6RThiFAC7Tljpy/e1wp9mo1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/xoHoU7oLLDyXvTXIX+uEWlHDTZn0NMyE60CRf8G20=;
 b=Qan1eZT3HrKOaELDUG/pP3CcBMEboPADI4yJm/VrLUWcu/Q1tFmClHX5sq0CYwXGD2WtSImSYD6DCsDrYlQHuT/riZ55QB+QCYKrgJ0mxSESLascLZ9fTM8QWWPvf3XFjy5jHShN5p5/bv2VhPpY8Um67urLSoRNAMidki/0LpmuuOVceSjc2jLrHRNv7vYclqersRobvYvY5YneawQejKbMvdwR10F6enKxPJS+XE82JBvSkOUCfUdNnTqbUreZE7iGezbFTCFsaGPBWX4yWPR2Z8nXkjxhBFxQ3bo4UWPYf4CjUgzSZdkh5v7wBCuxfpRQtO5DnnFb5qtc1EEZ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/xoHoU7oLLDyXvTXIX+uEWlHDTZn0NMyE60CRf8G20=;
 b=Cpp3w8n8ADrCNM6NNx6GBLs2aMx8LOvXgC6CCkU1Ublduajs9xQRfmpr48pF23LyjKUnTHoKUpBlQw+ytfWI7Z0xJQfUR4XSv8YFjeXKinRYatH2Yenrsre6CIV6Kd893+Ws2R0gLlLJ4qTBAt1y3/Mc3XGR+ixeczu8P+HQK6E=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB4381.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 11:59:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Tue, 1 Feb 2022
 11:59:29 +0000
Date:   Tue, 1 Feb 2022 14:58:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mark Mielke <mark.mielke@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Use strcmp() instead of strncmp()
Message-ID: <20220201115855.GQ1951@kadam>
References: <20220127084754.GA25644@kili>
 <CALm7yL0Z-A1mk5OfonTU9zu2izO54Q65nX55fpNYeaeaiZKX0A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALm7yL0Z-A1mk5OfonTU9zu2izO54Q65nX55fpNYeaeaiZKX0A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fac7309-68b4-4b4e-b2f3-08d9e57a4d08
X-MS-TrafficTypeDiagnostic: MN2PR10MB4381:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB438173CF02D996BD277A93F28E269@MN2PR10MB4381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bTuBRNCvI5Oug8ilNi3E25MHTF3C+qOzA842GUFqWk0WozqEA66lXXbfI7V8Bwy6TNJw97hQMyom4XH8E9A486z5Z59WaIvpLWLASOU2DObK/QIwNdqJUWDpnwesvshIjQpgStkP+wcpgzbhy1DckbBSSh7z/a4uUvIleTB7AWXaqy6NvPGQ9u0fIGuU+uWLtSr90RgFZP1fZn5nbAJXZro0k3lA7Ts3Ec8Ub3fMQ04QM1aV/gxFTChcbpSZU+koJSkfyVCWstFJ3R0tk7lBoNFeXkThzMG41F7RqlbEIfgZWGe4267DwEk1eKa35ww7cy0FqtDSqxv8OpT5UZSnrKR1CQTiGFkBfq4wmdDHezshYDiLFTHLZyfAk1iXFRp04pQTwQGx4Kes8gZJu6oXv2HUGOvVs9RPKuax5xAzxvjo15DnjGBOHDQKDFsFlQAnEo0egrXgGfWyaSDqU3AiZy1fKzTPu78lfjp7GSCO8RgXlDjgp7FUt3rwMCJOuWzSwDYaB0WCVObIg/R3xSstNi0ZZLd7ZjAGW49kM3w5zaisRSa+fQmvIopbJbVxMZZnDEGRpK6KKbEm6uhtERSbO+Fi+0Y4q6awHI9hEoDzTPLnrcxdGb8bz9QDWANZC9ZpeLHbHOPTCFnkJfa47J0EapmzusCpBsEbMBneF4csGqqTrrfN9L1fVyy79yc5BLNCNZOnuH4U9EViSnNg4Xib4TNMYEeOM3MiQRzl4bCrAI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(8936002)(66476007)(6486002)(38350700002)(316002)(86362001)(4326008)(6666004)(66556008)(8676002)(66946007)(33716001)(54906003)(6916009)(508600001)(9686003)(52116002)(5660300002)(186003)(1076003)(26005)(6506007)(2906002)(44832011)(33656002)(6512007)(133343001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LP8A0AH6X6U00/2+DwmdakUbs2M7/GFRLTOkK8O5i7u5Zn+GKgm/9JLg/WvI?=
 =?us-ascii?Q?umtEN5Iv5unK81Q12mXlmCeuTxzGsksHkG6OIKYm54+f4jQHsuDKD4pD70Md?=
 =?us-ascii?Q?2kl49RNx/NNle8ZxjPlBEhGMast8k5BsNxUrVqT/5eL35tV2LH6oii5k9nk8?=
 =?us-ascii?Q?PJk58VmyKwsOF6B1ddnxpWYwe8zMi6wVqjdf8WSgtAemNuf2wFG1zKtrzN73?=
 =?us-ascii?Q?qzEAUSSGFq52f6F9pyR+1tJgqYRzpdAKFBagrQD70apd7X4zOyBiHKIgEG6m?=
 =?us-ascii?Q?a63S/s5WTFLeF7w5kSuJchB5yoKmlmYhaI9aoWB06fCv5RnH3RKvwkpoCfKl?=
 =?us-ascii?Q?CkbqzKil+6Cq565HgDl7rv8+CYbnwpfI1x8Ouywg5gH2SsyI4o4uStG+2Dkg?=
 =?us-ascii?Q?GzgJXh3GO58KCL0jyLNetf50mr2X9ip9o0zdPgNMu68SnyShGYA58XQIbJBp?=
 =?us-ascii?Q?ZTHpSM5uVU5KMg6carJHbq4u50RD/BQ8f3F6lLDEjaxZumuAP2wbKiBE/SKt?=
 =?us-ascii?Q?FKyYxHG5v2BW6hgpoXKRATBPxWjxzzO8eo6yS8KbPbXhWWijRmQNz0hcNGq8?=
 =?us-ascii?Q?1/ZKQyVDeVVtIsDmbR2zjjWJ+YQGkMWmpEObJQrXdpyo8lwGwmvD6u9zIOAh?=
 =?us-ascii?Q?Dkot3wjG9JsaOtkZiJnFuUc7nITruci6cRvu293W7jTvTobp74phLBJdhKxF?=
 =?us-ascii?Q?OFeu97che0voMVeuTdgeg6VtOemTUPeH5yXNW24ebIL7gTtE5j8GGe7TWe2A?=
 =?us-ascii?Q?aojqy0LWKcEBq4/k5s6Bs8wHSUwUGfqbcpxTbHsqAFrqDKuTuLUi+Kh0sRBO?=
 =?us-ascii?Q?LRw5ocUYrA35kOulvk+RAS8Px7d91DHzY7W4bd1YhjG7NyOm80Fkx4/mP39L?=
 =?us-ascii?Q?0sKISRdAbI0KJFbGr0Og01cuzDuGN+Vpw0zt5YFqRq6AIWQt8LKiUb25AvjR?=
 =?us-ascii?Q?wBXLQcVGAL192pJXP+gvNz010cxPkSBKuBiSEwW40H1yG2UyGd9/o5AtAHiE?=
 =?us-ascii?Q?3q2J3eml2TGk0E96RvEab2M9zzJ3s/gTGGWrkeNQxE39RzCYhzMCbJFM04lX?=
 =?us-ascii?Q?bfvIyQwRnsTricOU9nfp1f854WA1ojMMH1AYuD9OX4CQQVOoNKdhunhajRYx?=
 =?us-ascii?Q?xyvdr31zNwXRVKn0yMNa3HKGNksS9NmoQKiTRsjMc2lTQin88lJC0q4nAiD3?=
 =?us-ascii?Q?HdQgVPsXHx78Urx0Rekf6LNyACx/U+NhIOnL5rXXjoqhn/qOkPaOqEkw18V8?=
 =?us-ascii?Q?kgtcdG0zg2SuXUiPt5H8SPF93iwP4ybYb0TMCbLsNfpJ/aCvqyizHhtJeV2d?=
 =?us-ascii?Q?31AG4huXJyZ6NAoZuRBFdbI1PS8iDfczfE0tRqpK18IUPWXrAlumz5z1/Qqj?=
 =?us-ascii?Q?dex8jnUKwIs49jDqDDSLZgod14NT+haiMUxgWAhJ4FDc8eoYqD4c70I6Xpl/?=
 =?us-ascii?Q?SCWVudB2OvmbcfCSXDbLz+VmGODjI/S3btAd5TQoYZS036QVesODSJialNDg?=
 =?us-ascii?Q?0XJqaS+liBJKMq7Y8nSITDnubzTCdcrjYg9WuFogxvxW6F/r+C0Lg7qHg0sU?=
 =?us-ascii?Q?n3Fa+u1ijULkg07vPc0Bx158qBSxQZJsr7tpoUKXkYkSPY+kHRuknKj8Kf/h?=
 =?us-ascii?Q?PAA73dQPmZ39U8ule0VOk52Qp2iqFMGY1eAYlZA2MqHwf7VwG6sM0w9aj6oG?=
 =?us-ascii?Q?4Zbj7J13dcRRlxiyTLpTetiz95E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fac7309-68b4-4b4e-b2f3-08d9e57a4d08
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 11:59:29.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzRY7jkmKBlAULBMDIaSEYXHwVdvn3Vl95oI8LrxtucDTLR3j3sXrQnfxqLj0RhCJ1KMgTeqheVgteiF6aS1EbdBAq78ToXQj4LAYC3bQwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4381
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=893 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010065
X-Proofpoint-GUID: fQlGzzlRXLxX107iqGbmY02TwCO_mRkb
X-Proofpoint-ORIG-GUID: fQlGzzlRXLxX107iqGbmY02TwCO_mRkb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 30, 2022 at 01:00:21PM -0500, Mark Mielke wrote:
> Sorry, I knee jerk react to "partial match", which was a red flag for
> me, so strncmp() is almost never used for "partial match" in my
> experience. :-)
> 
> It's really that strncmp() should be used for buffer overflow
> protection, but in this case - it's not. Since, the ", 5" applies to
> the clearly visible "=All" that is both allocated and '\0' terminated.
> It should be against the remaining buffer size of text_ptr. So,
> removing the ", 5" leaves it equally as bad at buffer overflow
> protection as it was before. :-)

This isn't really about my patch we all agree leaves things "as it
was before".  In this case, strncmp() was just copy and paste from the
surrounding code and not used as an overflow check.

What you're describing does exist but it's about 1% of use cases.  There
are about 2868 calls to strncmp() in the kernel.  In my x86 allmodconfig
only about 18 of them use strncmp() for buffer overflow checking.

Then there are some real puzzlers which do:

	if (strncmp(variable, "foo", sizeof("foo")) == 0) {

regards,
dan carpenter

