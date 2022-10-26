Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF51FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 13:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiJZN7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 09:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiJZN6k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 09:58:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD52958174
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 06:58:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QBEFOJ025336;
        Wed, 26 Oct 2022 13:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=WAesuRm0RSGric+6JUUXjm1Ub9im85aniTkBCTVME4o=;
 b=PlmYX7rGomGNXEnzG9V81nVos3AImHrIERLp+R4b52ndRrV8nPVgY4uRbldrvVZx9QBS
 OsWakPuYY0l99H088YrzQPaIs8uoYZAZUzHKWdV00RVa6j+f3A3SRG6vdlKBwzqIlm0w
 HjQmT6Q89EwnFXubNS3xAEyLLuX0UUfwb61RFPmmSgG2o8xPV+JraA7nIflE/HVs/B5t
 9uo+A5iPombh1h7/JOmuOr3phJCWeE1B0b4A9PwdAQL/cj0YwlQHLnrh4h/LtK3gSemV
 F8PnBRs76tMcgkykTlWrSLYXP8FvJ0XutNjmi8PBcX2/QlhT3QhK/ikmsrjjrbFX/4Mc MQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xe5wnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 13:58:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QD1Ljv020945;
        Wed, 26 Oct 2022 13:58:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5samc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 13:58:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyA9H5XVMGZByFS96B+p2nUbIuPUDaTtOB17jFQgdq3kIa2nLuDs3No4MuHV0wYhtsVpoYU71QmE/zt6oVMgAfhh2pMV8llMooVR3B8WER/Sw/d1ljvHeTSVrmQzTIKaZAvhgNKygLi2BbrpSH1dzxq2hSLPEZm4Lkt7JN4HI6EbEmWouZ3lXxLVbT0cpjnFBoC3o6jjkyIYw95l081bL1KCZ+r0qf6ihfs3Vsh0HrLGnUOWJgIjX3uFIvKKkWJ622HUSvjMiWbCXazonel9TX98tR9AZCr/jrleBwrFUj+DLA6eehbSJnqhR98VnhCGT0p12HLSrpjZm1/e5IuyBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAesuRm0RSGric+6JUUXjm1Ub9im85aniTkBCTVME4o=;
 b=azUUzjY/cMmR8Iub9DXyjQUbhCFteHHfCQQLo5Cuen9CK4VXJF1x6vFRCF2zJ2ES8wNELOpAwyMOKHGpzrwkbQycwm7DDk+AYj5z/XzMR7mCe+OFd1jOG8HXU1hWoAacrVRpf2kCbLCqtZux7FU9mHyVXlwEssasKAT5QSoA3p2rDhxMhyPBglxX3mn4OMOEN7hxjwGmvROZrxagEvFRi0PbiyGLMsBdQ0/Ebhky9yCAC5b6BPQX3HYu9eAuGBRO+bXyMpYEFIzkz9/yNWM0+IQASnCVLqp7Xwj2nWNRxLaFBxcylN8YbX43+6XV55EFjLYtob1eDPjHJfZT97oZ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAesuRm0RSGric+6JUUXjm1Ub9im85aniTkBCTVME4o=;
 b=oWEWSixaBPBJPkh1/TVwfLFh3hL1frmnzxnHRcgbI7ynACY5ZMgveKpWrhdn9syv+Jr9doprHBgFnOQnDQ1fVvZ1ZGiTTjIH+2D2FHK0X6T0kh9SF4t1GYeXjCPH/N90AwLS5E7FHkthu0GQ9DJuQLVy9N9hGkHw1BjVmEbzII8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4119.namprd10.prod.outlook.com
 (2603:10b6:610:ae::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 13:58:33 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Wed, 26 Oct 2022
 13:58:33 +0000
Date:   Wed, 26 Oct 2022 16:58:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: core: Release SCSI devices synchronously
Message-ID: <Y1k8+fDG7FFOnbBG@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH2PR10MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d8322f-c9aa-4e9f-2c83-08dab75a2af5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8okG2Jzf7keollHXQ2x9lk0dxcsiiYSSC80nEbOcMSxIHVBYaJ3m7eamQ1M2IAqwkIajX7T3Ewm2NzNjIcHw/U5jighLsz5+8wVse9IKBkR7MbisCT8iK5Jldc/gMcLU5JXIRz8t/uE52+wiunkKvQ9SmPAfrDPdRFfDvucVCKMG3RRE6Onw2mxUTNJmqxPVJpn868XgjOwraXvHdP//pjCVheVdBngEi7+BUqHMWno9iru8ST/42QOKaVcP0eLa8xgVOa6NNgJcJxiZvF4e/BWm6svoKL8fkHWuIg6JnEmMHgNoSEe9wy3UPgxdlC4/9t8GeLE4i73Rr1FeJ+r9vXpzTL3/ITMNrK6h4hpOSnht0+Nh+dRd4bcIuNEQKXCtA5roOZ+vx87XOfvGiSALlmcAr87gtx6kyZILsWQ87fWnrs9+snCkaqAghi9hroiL7Us0QxCdOR/MBaX2/xVKgzfH6dV8Z6pnSaUPyx4SPaAobHjkskODcDujm+FxbWfEPh7Ckm0WlG85Y5qXTIa7pP+VUHBCys6GuKnihdAzbd4TjSL1tR/q9KwZ0KaNOGofrudjZpalDJY0mifgagE8sNmRARuwomc64hV4IUkT74ECX2k2QRZs1FdFYpoeHP5QmItusxO03pFDlI+/WAY7PtU9dS7QMuf6lrcItnR+D90g7gy7aCoo5xG+lf+Z1sIDM7wZjX5Yu2Hh0BczDnLYhGeAYURekMiUParO8Ttlrytck7g7SLSGL2d+nw/u+W5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(5660300002)(6916009)(4326008)(41300700001)(26005)(66946007)(8676002)(66476007)(6666004)(66556008)(6512007)(9686003)(316002)(6506007)(8936002)(33716001)(38100700002)(2906002)(44832011)(83380400001)(86362001)(478600001)(6486002)(186003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pzaplpsz1tZSZ6tNQFxtQk9ODx9Mu3uE2bGTLt0hhHl5WvZVnw+S1fLInzM3?=
 =?us-ascii?Q?5fKIvRti3RFkfwUAT11TbrgXFA8vl1Z8whvCA8bO8qVzL9WnSx4upjHMBgrG?=
 =?us-ascii?Q?1Vacj+jY2rncvgBqnyQCjIG5mLP8e/dw+Nge0cHO7ag9rvkrx6LQHABDlW63?=
 =?us-ascii?Q?R8H7zIViooWbr8601Us1+aoZU56SsomD44SmC61WZHfQae2w17zZyPYXZyXK?=
 =?us-ascii?Q?QN0MIRSkEYks+tCOuS7TfTWmTXhjF7eX+zYv0sLkNgqhMSeFhW2j8WuW2ee4?=
 =?us-ascii?Q?UKs2nxVxzCSzJIBrq7PDUDCyU7ldiHBtmTayy46fejsZePRsfaq5LKGCIE/p?=
 =?us-ascii?Q?ib9B4UTA3mVvN7h07TIFn3ywcUlsAsI4ycEvzKwT7QYgztEJa5CrBJ3dzwop?=
 =?us-ascii?Q?9zsh9CN0qe149p68JOo89QJexv/lYpL02nO+ImjosYswt95nx4gSb5P20wWu?=
 =?us-ascii?Q?rl5Ax53YRbqtCGGPuS83HiiZlANMvXDsSEu4ygp6TC5Mj3/rzmvg7F9vC699?=
 =?us-ascii?Q?Sifr4gul5VNGTiJub/OmQMoD+NdC//e4civh1c9bvW/YaIU/cpAaUZgaVWRc?=
 =?us-ascii?Q?uDtRzZ8qLliQblnltlxLHna5F7SoZvWcC5NdwjyjV6vMIJIeukh/WrmKXQAV?=
 =?us-ascii?Q?hFzWHAL25FsQmTnV0JdeN1whoOxUWCRkH8fE5QoSZ7OBTdi9XRnv0uQMs76X?=
 =?us-ascii?Q?nnuUug/0wwy2eYJ8bpM1n4SrvwiB3L5GAw3e2NklsbWZS4twsKifF2HqQCEj?=
 =?us-ascii?Q?01a0wRM8/aQ9bBVFxqhd5raBoDY+IIBYalKsgROJRSUTh+I5Exz66SEw1WrI?=
 =?us-ascii?Q?FAwcx/WlHghk7NK6OpTJTcYJ07kAIdbMJcswHRtvDuXleAN5bL1FDuKW4Vbm?=
 =?us-ascii?Q?rEimEOLlDiKsgY6W/9K14sItHPj5XBIw5YSTDcVkk67cfzkTvhgLDH2RKxV+?=
 =?us-ascii?Q?9FnyW1gXUWHZ6jTM02EnQM/xxybRCxo7H8qAHj9QNs+D12E39eqD/hAd07sN?=
 =?us-ascii?Q?2D3+36BBjLA9YiHeEpsP/aOeqgq+mG3mBW9wfPzgdHmaSeyV4AKAGZuTHOkB?=
 =?us-ascii?Q?WxlfXNtmbRpQUe1EUqYZNL+CN/xpw1SI2XT19vC8g/Rnoghyud4e7iED54We?=
 =?us-ascii?Q?9DInganX+e655wM9iH811S441b4plcIbquhXxl2VjZkZTaYpz/ZzIWyOCSQD?=
 =?us-ascii?Q?p9k5m8KRZTpLWpLSbB/79zT6+LDjm4fHt07/jkymIcv8y5QPBxMxu08kOH6B?=
 =?us-ascii?Q?TacpqAQcqXWj+bl9GwJYVkF4TKV49nK7on84tyM/HCS0HbPJsWuwIaj4I9BP?=
 =?us-ascii?Q?zlkeEwvfhSMxJzKI8qq/ectAVn13U8QzF9NuflANrzSaQ5tQibtkgaMTyCuX?=
 =?us-ascii?Q?2SwUIIMHslvngv4uPYcuRLCLXbpqJ1z3UK15aKuKX9c7k6fmIfJi1lxwUv8Q?=
 =?us-ascii?Q?NcyyJudVFVIvqlteUve75DIHr2zeNnHGwAuo4vJJdH/AUF8qz1bYSkEufIde?=
 =?us-ascii?Q?t96Zwjt8cT1mOkEgg01SYbYkL3BieVJUE18SRDtwCCrx3DCK43SoVpmxWe+F?=
 =?us-ascii?Q?8mRW/jeza2618WGQEnONfrwtYhmvlfOu1YIAPdEbwZgXtq3lboNUM66qd/+f?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d8322f-c9aa-4e9f-2c83-08dab75a2af5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 13:58:33.2464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvG3sXAzb1kUpZKp2xo7KwXgyH97gEGthkLWpQ1T8+9YCKXwGZb0qvDcNCTGRKgGBUhiczpU/EffxLdbogR1KLY6lI3a1L6QaVk8T73ot2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_06,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=873 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260079
X-Proofpoint-GUID: PdGm4kEW_5J6vwfPpPzHQkq792IFkwE_
X-Proofpoint-ORIG-GUID: PdGm4kEW_5J6vwfPpPzHQkq792IFkwE_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart Van Assche,

The patch f93ed747e2c7: "scsi: core: Release SCSI devices
synchronously" from Oct 14, 2022, leads to the following three Smatch
static checker warnings:

1) drivers/scsi/bfa/bfad_bsg.c:2551 bfad_iocmd_lunmask_reset_lunscan_mode() warn: sleeping in atomic context

bfad_iocmd_lunmask() <- disables preempt
-> bfad_iocmd_lunmask_reset_lunscan_mode()
   -> scsi_device_put()

(This is inside the calls to bfad_reset_sdev_bflags() macro).

2) drivers/scsi/device_handler/scsi_dh_alua.c:853 alua_rtpg_select_sdev() warn: sleeping in atomic context

alua_rtpg_work() <- disables preempt
-> alua_rtpg_select_sdev()
   -> scsi_device_put()

3) drivers/scsi/device_handler/scsi_dh_alua.c:1013 alua_rtpg_queue() warn: sleeping in atomic context

alua_check_vpd() <- disables preempt
-> alua_rtpg_queue()
   -> scsi_device_put()

Hopefully, this bug report is straight forward.  The fixes are probably
complicated though.  :P Basically the function marked "disables preempt"
takes a spin lock and calls the other function which calls
scsi_device_put().

regards,
dan carpenter
