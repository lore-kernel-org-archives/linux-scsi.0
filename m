Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF3C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 22:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiBSWGF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 17:06:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiBSWGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 17:06:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3CB3D49D
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 14:05:44 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JC7UTU006723;
        Sat, 19 Feb 2022 22:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xlexbrdEFMCJO2ySPec1o6CoefirLaRDkGxMzTbf4Y4=;
 b=pEisXFrhVK6lLMLYPQ2GTdRGDN4PH0y0lIqFew8WOFKtLH231FWrym8e0BKDbvKFxgIU
 v4yKn3wivBivFFWJobjipnniZrVkoySLjKOqU2J2z5HS5ZcqZi3s4p+Ii3Hzu0ql9jsQ
 LfzkbZuMDDaQ2ziGHWFH/DZS1CybBnNrNaA8XfQQxPpGoI4JoWliw6ZIex/ymAhN8ECc
 hWwrooi+2U6wTX48RPuYzgPP6vJMpQMiSgySO4VwnrUYzydabLHeh8gxKGwGYPa2u6Mr
 7Yg8ibjkJyAktjGX9yqIvJTH5xYyzNIV5GEoWhLKzr8GVM00gUF8yxwXdiFBLbws4AgE 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v0xsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:05:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JM1QTj129219;
        Sat, 19 Feb 2022 22:05:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3eanns1krh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:05:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diqheSd68ZMHhg9AxaPJfAqUs4DRIq1w5czs4wuSNHQcFSsAdpdRmuUCk9RIfujeJC7t5BNtMPvPRvKRBsyPTFEi+0jA4Zlk7iN0SUVCzSqN2AqpRHgrevYN45LO0y7qkz3d2BQA+VX02DlU7Oj/knP97Y73nbbL2b4Wj91jZCIif+1LOnk5NxfLC3p4zj+D5aSc111BDOVr02TnZDvf2TRS6eJjcUuCOXHs/Ed6jCBQ312/FSDpacRnUu32JvCACuu07CokhZmNFAd4BWV7RqFyM+BSRfDKD/J000Y2NUDPyD09ouqoWI3CQkyzVdTLEUzMnbZ/h9EsZ702j3VRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlexbrdEFMCJO2ySPec1o6CoefirLaRDkGxMzTbf4Y4=;
 b=DQvVge+V3KUM3DVldQnnxt8ATmVTLmuorbwJ2vkp4R2f6fJh9jKtN2tQ+1I6/uyiyKGZrEDl2WFSkbTx2kiQtoF9LFYt5k9uXEatuVKUKT+s0NodHLNkH2bqtLObwEvUxqpmE6nMFz4UnB9YaAV1tCuW0tA0MfK1TqLRjaHzXAw6EMH+/DxK1nTEV4XYk4SmykSyQwOxX38zBwlTJy9sHWf0KUpbZBVH1VnqcrxjzkM952x2lNu5uvBoRnrgE0cAN2QnkknXKk0Sqq+osVsapSuDywemL6MUmiA/TJ+bLLah6c5mA2vDSzjkIN8UlDuEpdO6IM8koLr9ijSDbj0bVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlexbrdEFMCJO2ySPec1o6CoefirLaRDkGxMzTbf4Y4=;
 b=uABy6vnG2JCAtymEGXLDWBD7JlRB9DjcbWlotI1Qm0o2nca+H/deHAijuAxprRNFi1ubuaWVjiyQ5u0JuVDRO/2a/D7RisE7G3EdBGiomKngG+y2UCAQghtUzbANWlugfhLM2I719fxRFfSkr71sZM5eAZ20LKQswYOHYKCnbFI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR10MB1381.namprd10.prod.outlook.com (2603:10b6:903:29::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 22:05:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026; Sat, 19 Feb 2022
 22:05:39 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 00/49] Remove the SCSI pointer from struct scsi_cmnd
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tucuh5qx.fsf@ca-mkp.ca.oracle.com>
References: <20220218195117.25689-1-bvanassche@acm.org>
Date:   Sat, 19 Feb 2022 17:05:36 -0500
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 18 Feb 2022 11:50:28 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 925644b6-6f72-4b41-12b7-08d9f3f3f691
X-MS-TrafficTypeDiagnostic: CY4PR10MB1381:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB13819977F907F52A44EB2CE68E389@CY4PR10MB1381.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJDQ0OfgTu1JVEEEJp0QidZqLp9NvHseAJxUmiUFthK0o7rheAUiHb0z8if/jpfNV9/5pHZed/5fUNA1FiJp6JtOh4Iru0WTrZmsfwGL5Tq3nZnej8HwKWZZqXSi0TGMzGXXFxcIBX0J7RetlhmdShZzvKo5DlTshQKEbJ3i0OvDGD/h+YIjWYufFYYYAusOJCyDbaTWbMQU4WDZlRXBtDqFEtYBQa8Bffwb7Fhh+zDRiy6CdneojWn/d4WwVJ8Vth0ypo//c2dYfR2lzoZfxWsVsko8fi/hF5NlpazafQRlud/90/Kbui/jjmUPl0OTCuL16WEvE+L8TqL3lFJeez0BrF0wfnDu6k67Pf93fUF98Jp0kh0NGErmiOLattwcymMZWZy1HSAAQzK9Kb8CTDy+4jHkxE7OSbJ/jyA4MdPH2ksSARr2SY+9ZNQqR5sFyX34auCARsou14cnMFMe2NhXO318VVHc5CWwOTxoiN/eKpfk4xnuGoe/70X7bIfGEevWmFPnjTiWy/Cuuj6Cs2w+LrsbN9m+TogiUv1rtI8Kq+3EndosjA5uULNAx6/8JllWFYEtcgJmbjSLB8bNWWDm4qCMs8uONYoDm9H+UYnomjc7E7Mcjkj39H6IISDBdbndFb9Fe7vZC8qj73kizwmim6uLkpfmBUuoFN2Ph8nNSKLUNN8nhClwVVyPzJzBCz5Cg+yCjB2ugV3K/GYrIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(86362001)(2906002)(38350700002)(5660300002)(4744005)(6512007)(186003)(26005)(508600001)(36916002)(52116002)(6916009)(6506007)(316002)(6666004)(66556008)(66476007)(66946007)(8676002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AlUWsNvUx0u9lqkXbWkcHhSKE20q5lQI2PVl+PIQ3m5hdz2kskGiwQooIJ2Y?=
 =?us-ascii?Q?qn/wzjp5jkna6z7IE7fzBM3z8aEGnYPHKszKEeN5sy390PcKSVwhXQ/3Zl/g?=
 =?us-ascii?Q?ZvoO8nY1JLMOnKTUWp8ltSbOjkVONGd0PEs+rJuMlxpWI+lzvdMiADFo4yYd?=
 =?us-ascii?Q?qWDkRdfxcbZaMtB+3G3Z6qqhOwhJt1p9faJPnQwGayokwK+j9YfUQ5D+pfxw?=
 =?us-ascii?Q?Km7sSkUxTCa9Zf8tOdieWs4rThK1kvMrlLHM9LjoZFTyMZSEyvIo2xG0vQyF?=
 =?us-ascii?Q?Y7HhH4sQ5TcM6s5nMT8tcvhSDtDmcqUkkOOXRDX2J0RjVWWLmCDUEW44hZlA?=
 =?us-ascii?Q?2XZcKZgHhGApzaTO1XL7b5sdx3m5pKfQufEcUcjQsFh/7jPxdqJIbw5uLViN?=
 =?us-ascii?Q?uQbwHZIC9X/oCEW5iiYfH8AT/JPbv/M61wAeLeknR5AxHlFcqiOIzYf3B3QY?=
 =?us-ascii?Q?ohhR1m92jp948XEw8hQJaY0oswZuELCQQDrHT8qnKp5VkkHvAt+lZYOzKsRB?=
 =?us-ascii?Q?E38vMyc1NwtHowGKwVtuUESW3UhmcFNOmQfeI5U83HPvteELqdDq/u8JIBcB?=
 =?us-ascii?Q?lwKHFJEueLVW74d79ksEihk5lFvZDkgvJzJ2fpsp1lvyVx29Sd8E7PYX1fVm?=
 =?us-ascii?Q?b/q7uqAb9juiKVcFPakPRZ/vrpcPpCwExJIz3aowcwEAIq+yiIlXdgYLn2vn?=
 =?us-ascii?Q?VhNXbIEd98dVa5QyZHdAG9qTWvdWG83IQzkYkFtzt25QWqAq4lxiJHpExecF?=
 =?us-ascii?Q?BZJ4m1L5t7wH6ONhCcdv/hcozrgYTOiFV7H5LWeKg//ITdR5PKRbIGAVMAuG?=
 =?us-ascii?Q?g3wd5S/60m5sb95827tmU6OO8U6PObSWp03ZSZ1s+6fo5gPtSSg1ho5GQ9SB?=
 =?us-ascii?Q?H3LJ/6NAtgh/7ewkoQmGBBCKHqFYgd1zy1SB7pEAL5SZJsM16HikKFFgM58v?=
 =?us-ascii?Q?YVQRjKhgf6oCSv2Obj4CxhnAyUi1qlo6XeM5iEeNihjAnx2/ZLKzbp4FP1K9?=
 =?us-ascii?Q?APNkz4nc3S/b9QT0oac2Ycoaul7C5O6Dpa2DU6ucuLfYXr4kEeGYdBulonvR?=
 =?us-ascii?Q?eyf61X8AuHDtrO1XnBGxBgbJqtskv0H7zzaPqb0Pon4f6W/tSlUSV0cuxDy/?=
 =?us-ascii?Q?5JoIg/thaJ1CdTkt8oA37vyRcc6W3ENaDtv9gB5Bj4VZr/jXbSWLm87wxBjR?=
 =?us-ascii?Q?tVVqPIkwRbPc7kZZtTXrpG/KJZUYRkJzV/j3ICl1aTWlIl8Jdb+8MFVsA0Fl?=
 =?us-ascii?Q?+J95+mytCNT4/Yfb4Man+LP+UWnaV2PCoy6+WqZkSliyGbph+DZjnHiG1Ld2?=
 =?us-ascii?Q?9kboBewkPumqWGY+DgBvtifwVe+1dsLIRccMrXy1nAFxk+s4pNm1XabW+H8u?=
 =?us-ascii?Q?aTa+sPot4pTXEgZ5+5FNCRV4HWBCfFNHzNkMmHLGC8HkgmyJB1yQEj4IsAtQ?=
 =?us-ascii?Q?xYfRlManqpx8PX6E2ihwT8yTWlrSEVB2WfthIQZnEJ3n4LcC+LJbPDA6gdam?=
 =?us-ascii?Q?UxdMw035ZvFn66VOuejo64ebRUP/M6qbOtX6fnTnu4T4H07syNEcB5+iJrYo?=
 =?us-ascii?Q?Jp3j6X+5HQDhXSF145BuaQut7ekKP4RAa7Vle+Gkjq4C0Tp3xkj767YbXfxe?=
 =?us-ascii?Q?oul/pqZS44Wdkrrw15+QRudcdBbD2gZiHdHC5r+4GtcbeEADiNg5meOxqUzi?=
 =?us-ascii?Q?/EQ9zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925644b6-6f72-4b41-12b7-08d9f3f3f691
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 22:05:39.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJh/omTZztjErBlKuF+UVuTWWTg0tksdENwwmVzGRJ1cxI9a4AjixfCHUpV6kQHUXs0jIUIwr9jnlscGNMTX7YFjzoiu7MEZLoV4W3dgjqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1381
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202190142
X-Proofpoint-GUID: nP5e2A6yEqnOX7Bun9L4JncAdB9kEGm6
X-Proofpoint-ORIG-GUID: nP5e2A6yEqnOX7Bun9L4JncAdB9kEGm6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The size of struct scsi_cmnd matters for embedded devices. One of the
> largest members of that structure is the SCSI pointer. That structure
> is relevant for SCSI-II drivers but not for modern SCSI drivers. Hence
> this patch series that removes the SCSI pointer from struct scsi_cmnd
> and moves it into driver-private command data.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
