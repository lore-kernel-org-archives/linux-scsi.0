Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346BBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 14:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354543AbiDVOy2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 10:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiDVOy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 10:54:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B785BE73
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 07:51:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MDXkZh024754;
        Fri, 22 Apr 2022 14:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=WkrQsVXguAFfahEB+Jq0SEhEsmkZcykajfx+S+OiA04=;
 b=adWRTb1idxqBpkdZx3Ztc+vBn4DzBZGNDI4c0L1Kz5ckhOPBZrJFdPr1pxFKdtKWRGBQ
 TMw/B0irrdmpUcHy8Ds4MUwGI+gd0eWBV41bFVGyjdIym8BizHtoOzAv66zjwvL2saMw
 xyFswuSXlwRW+XjRc9fSrxgZIR66SLgTm3NHWWDaMh2eaC26xIiBtfHBjOgz3h8rDXTR
 IOTZLhS4TwTtk84S1szVMS7oAjPLPafrCAJJiqY71nJQALd/Fyb0Y0x1luaALjHPOAY4
 kb93/KmUX56o16DMV3SF5zEqImt54QpmG4RiSqKnqOmxowteS8YYhWLcVyAUid26dEwA 4g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9phjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 14:51:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23MEjvt6037241;
        Fri, 22 Apr 2022 14:51:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8dq5aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 14:51:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMKU6vyCkahjkuEss+qOxYCvoIZhjGvD7IgbNi/PCMMcp41AvHgxHnCKnkQWHuJTX8iV7JC2Byhiie5L7VIMAwQ5F2NpbhSVLrttTbjeJk/yMw/ZAv4Mf2GYIyo4urD8E+jZYiB3VCF5NiJaq3rcTAj/HCiYnmlOXGlW/cbSNUzTnHcbHZYrJGGios65e/GuZO3rATdvmsNvZmhedBQBwJb1mNFqgXgOfh4bGD3C/COKHw4I1cFA6sJUY95qZjxoyI3W/j2l4cQ809tWhDACuAJ1CuW17l2Ihj3GlBgXY+SRVBpS5C8TUvmbztmZKCbwD3vxirgoI2uimogf5nLI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkrQsVXguAFfahEB+Jq0SEhEsmkZcykajfx+S+OiA04=;
 b=LSjKjJ97sUZL/KLxogSi5HZgGrEgR/da4CuHi/oE7puOglL9JMQFYKhcNHIUTNwEGDoJ4CLvrDWbi2j2OetYMvSE++TiPqinLYvuu7A7GWaMZeMZrcsOxaj5/03Pc0g59wQOMn91nDXlK9xSrTZtw8zoCSzNxlkgLkI5YuALYhdzW+DMYldaO1UHU1SaKmY+M57C9GlIW29pwPQzQIWbMKEq/EW0Lt9TqUy/aO3OLjcOo9Dl6bZa9H98TqWJKj+gVocfsxXW712OXx3EsNXpDr5GSWJ/QcV4HNludEXGZmlS1UUIMZMFkvprHjiZzgpq3xBrBrkVMRBBlzl7y2F93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkrQsVXguAFfahEB+Jq0SEhEsmkZcykajfx+S+OiA04=;
 b=L9LLEqOgKvLr4IH0pEKgp3foS1vsXZrIEcS6lTmT1yih9MKble9OzMaF93z2/wtI756M+GzoUUXXtX6Y3+Kt8yt75ohg9bbBCgfhkoMJDEHSZQQZfnK6yivV2CR2mxvqCCIQxbat6kdQW4easC70DNS2UFHy7fVN7deg3Bbvhi8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN7PR10MB2498.namprd10.prod.outlook.com
 (2603:10b6:406:c2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 14:51:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 14:51:25 +0000
Date:   Fri, 22 Apr 2022 17:51:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, James Smart <jsmart2021@gmail.com>,
        linux-scsi@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH 20/26] lpfc: Fix field overload in lpfc_iocbq data
 structure
Message-ID: <202204190252.8068PeSp-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412222008.126521-21-jsmart2021@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0078.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::24) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1457c698-f009-4b3e-3885-08da246f92e9
X-MS-TrafficTypeDiagnostic: BN7PR10MB2498:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB24980EFC48AB8C656CFF28748EF79@BN7PR10MB2498.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +97Nv8v0m+vqLGajh3+OOpqCbJDNbuacb/PT5aGlAEXK0xwaRvyN8XZwX57tYf5m5lIFF51Zc2vb5WwO6F4QjNyNtjRb5wXrdv3siBd0Jz+O6pbSmPnjI2ibZ1zpCQxhmthPdpD/YaTpEFBSSrEP7seF1x6vwpfczUGqIB+I6j6EOXe0Injnva9fUHeHoJDKvyjAaGsovbITpvWRQ98oJnFtwfdGBaZeuOOgeF0wK8Jx52Fy0GoDkMBZtWHBlSsVoxOQtRGRBtI8yrH+yoNFsg2siLX9GGgcr8xu2a0y7ZOLhSuHVBgOMF4senq3MoqyMj6/UX0Q6Xl4hnk4poLASezpzhHbiBvElYTxxO2C8a3QuppxHXjh2Y1eWog3W3g/x+g0hzZfqLKexs/Wzvn7iNKSzRIlp8P8JHyoLw1B5wxNFHeyB6kD0zmmU4HEBQMnJJInPAXLEKvg2KalAwntlp9MToCxzAasdtWaxDra275f7UdxQW1c8Td/Dz/GelvaUhGPPeJaFZEiS7lm4C/SxFtQZbUVdCrPBzRQ6Kcziav2H+0nUKahbC4bZtpccxE0XlTKIpVQxVFcwRk+GJviuCLtAcBVt006/qB9C7w3vNMsUHFhYHwLDIOTy0TG9XPMR00gs63NNtxZx0c3MRErzXvOUDdQgu3buUqpJ+Ogoc5erp45a6krzAkN2mkrDbmKfo+KMYWtuVoEV43VCvSM8QntOCqvkRGM+CDdXhgA2Eld+rEX8XV0cFs+9ltenfQYWnIb/nYdUnUQOK7/kG00GnZF66eadnoeI/6+YPoXpIMo+7jy2Cl3JhVvzjTLwQcH2KUkyKew8KWUMbrbI7tPbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(9686003)(26005)(36756003)(44832011)(1076003)(38350700002)(38100700002)(52116002)(6506007)(2906002)(6666004)(86362001)(4326008)(966005)(6486002)(8676002)(5660300002)(8936002)(508600001)(186003)(66946007)(66556008)(54906003)(66476007)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rFHJDr1EUVwY8K3wxuJkvPLSIpZG7JmQvWZNdF6//ASMoSYur6fZ96X7snbg?=
 =?us-ascii?Q?qrkU12jdnYJ5g6grcLdX5TU2T7sGr12zgCiOWyGlEuwmq0BelgIAhdvjO3Pg?=
 =?us-ascii?Q?MhYzpv10kg/haSPkXBQA+fHCgVKqcmCvaNB497jfP1PzKNKZsDSgqHRStE9b?=
 =?us-ascii?Q?MkSCH88hhHqDYvOi7XtHVHYcD+HxDxzfoSb8enWcrPFlDzwyr5vVP9WwEBXs?=
 =?us-ascii?Q?Ry5Al5iRih/SlE3SpymbW+kEfqQ7w1Uuwo99MMNQ685xC/fc7n/5DLU+uayW?=
 =?us-ascii?Q?g4KvlNwmgkuAddqUx0J3/qEqZppitbFSNhPWjJ/tP/MeLbaaOJsteQA8xVOy?=
 =?us-ascii?Q?eAP2nD4sHzGNZYivAYe7Z6TM+S8RhuStXoSvfN7qZU+ayucdXkaQzJcrlLpm?=
 =?us-ascii?Q?h5jsZKGzZbd4o82vl6msvwNocr+vC5PiprbWM+s/y8JukFV7RLSWKPREsjE4?=
 =?us-ascii?Q?XjPO4+C3ezJ+9vPcnitTOoIWqUAoxy6/w36AH9zuQnp30unOtJLXAnScQdYl?=
 =?us-ascii?Q?kS6FFc8SqmOBHep/h29qbsgl0U5pYZvga/RLWU1qMGeeJo/ZFykEcXRX0TjB?=
 =?us-ascii?Q?oMMFr10lhgopIkIj3B5HhuoqJkakrLsLou07lI7i1t9eMdObhq+OEPYjLebk?=
 =?us-ascii?Q?doxYnd6L/1xGvkreAOLrERkgqukpANP+5+9FBo+jfq1HRV63Vkjhnkyh25wR?=
 =?us-ascii?Q?oXskUzdLM/WYSOg1/S/61bTAkklkv4h/syXQjB2b2wcwmaJnqvqoYbAczjSU?=
 =?us-ascii?Q?w3tjK1vlUKDdWE+6xtKFAb3p+Bx+CVUA1UL33+gG0LcsKJig0REjDn5iRRbG?=
 =?us-ascii?Q?QoULovF8Ox9qAft6iUz4fgcxDhmI2AuMh4gXQfXuqq3aFuZPaWlKWYs3p9Ig?=
 =?us-ascii?Q?xiS0lywxLCl+4zNiiCVtgFRtxX5Y35UOXOCwycI/IksZoXCh0vxnrcbl/H6a?=
 =?us-ascii?Q?BXIDMYV/VwOu9FgH3QODgxCOYjbCDPuIaVBe4i7pb5/Dd0R4gwCE4m4H3XU/?=
 =?us-ascii?Q?aAq2qEZ2zoKL45RuqbE0sLO/5GpkZldHY3AB8Y+flADTN+hA2lJ6As7YkwDI?=
 =?us-ascii?Q?Qsijoywd3pyFvm7e/PcT9BRCsJ8L8RYCGZypc5U+5V1KeAGJAdgM30QUtzK4?=
 =?us-ascii?Q?v44esbrlLrrE6l5HB+ttW7EVo8kxZfl1HMcmwymNB9qIAcJzHjA7go+tGPL1?=
 =?us-ascii?Q?Lha0enKW5E4DVZw/5a0L8t9BC5oT6OTTaxXqeh8HctjZVdbTn4zPUE5Eplv/?=
 =?us-ascii?Q?kQiEWyb68VrKjVQeZWw96Jyo4Xzc1uNq9CaJBfqyNeooLw8iGf3MCIb6A6Zp?=
 =?us-ascii?Q?CqGxMooKYiN7DFSwDmlwz105jUlAtE4Er6el9Zbjvo+/a8rVp2HK+IDsJw1k?=
 =?us-ascii?Q?Rx/Ekf/MbXemMLwof24QwL/uQBOCJ34fk1EhJrfPq81LKIiwj3uTxGA1tG7a?=
 =?us-ascii?Q?O2VEB5GJqt41K4r6DqzkVox8i6+mvYtzGd1pbjHCAAN86voDTFhE7Us4q6bE?=
 =?us-ascii?Q?ZrEJjdsOnPpdRG2iZmMgJOqvlU1chENDVJd7OphPFwvDf7FdmyLbZmQfCCxJ?=
 =?us-ascii?Q?s91DHHlXG+MD5v5T48PXO5IQ6+jUOkAIGytKd49a4F4OOY/m7WlvMeW741Xu?=
 =?us-ascii?Q?WBOLZcueEvD/kPrZSHeDPAsqGj9g+jVa+kw6VRkXXTL2xXh95u+SX0FyBeUL?=
 =?us-ascii?Q?vc4ozQLJ+OMD/W/zk3LulskuHFI+BRYIg7zybCkIzRYyMlV3e6YbWAvzDraX?=
 =?us-ascii?Q?PA+/TOJKVAfP5QW2DydkjSkYZK8/YXs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1457c698-f009-4b3e-3885-08da246f92e9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 14:51:25.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+tTRFWL4bCO7fyESq3bUBc9kuyALp1sh0B6Zr5qRYu2VUP2APTnyTnEhJE56e8fpThMB5dnHkp3GtXVNZacBo5mWvAZfI6AK2B/XtyCrHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2498
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-22_04:2022-04-22,2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220065
X-Proofpoint-ORIG-GUID: rgoODsSG3sRZjUhL1Qd8goWWyT_qa3pg
X-Proofpoint-GUID: rgoODsSG3sRZjUhL1Qd8goWWyT_qa3pg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

url:    https://github.com/intel-lab-lkp/linux/commits/James-Smart/lpfc-Update-lpfc-to-revision-14-2-0-2/20220413-073746
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: x86_64-randconfig-m001-20220418 (https://download.01.org/0day-ci/archive/20220419/202204190252.8068PeSp-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/scsi/lpfc/lpfc_sli.c:22305 lpfc_sli_prep_wqe() error: we previously assumed 'ndlp' could be null (see line 22298)

vim +/ndlp +22305 drivers/scsi/lpfc/lpfc_sli.c

561341425bcc70 James Smart 2022-02-24  22239  void
561341425bcc70 James Smart 2022-02-24  22240  lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
561341425bcc70 James Smart 2022-02-24  22241  {
561341425bcc70 James Smart 2022-02-24  22242  	u8 cmnd;
561341425bcc70 James Smart 2022-02-24  22243  	u32 *pcmd;
561341425bcc70 James Smart 2022-02-24  22244  	u32 if_type = 0;
561341425bcc70 James Smart 2022-02-24  22245  	u32 fip, abort_tag;
561341425bcc70 James Smart 2022-02-24  22246  	struct lpfc_nodelist *ndlp = NULL;
561341425bcc70 James Smart 2022-02-24  22247  	union lpfc_wqe128 *wqe = &job->wqe;
561341425bcc70 James Smart 2022-02-24  22248  	u32 els_id = LPFC_ELS_ID_DEFAULT;
561341425bcc70 James Smart 2022-02-24  22249  	u8 command_type = ELS_COMMAND_NON_FIP;
561341425bcc70 James Smart 2022-02-24  22250  
561341425bcc70 James Smart 2022-02-24  22251  	fip = phba->hba_flag & HBA_FIP_SUPPORT;
561341425bcc70 James Smart 2022-02-24  22252  	/* The fcp commands will set command type */
561341425bcc70 James Smart 2022-02-24  22253  	if (job->cmd_flag &  LPFC_IO_FCP)
561341425bcc70 James Smart 2022-02-24  22254  		command_type = FCP_COMMAND;
561341425bcc70 James Smart 2022-02-24  22255  	else if (fip && (job->cmd_flag & LPFC_FIP_ELS_ID_MASK))
561341425bcc70 James Smart 2022-02-24  22256  		command_type = ELS_COMMAND_FIP;
561341425bcc70 James Smart 2022-02-24  22257  	else
561341425bcc70 James Smart 2022-02-24  22258  		command_type = ELS_COMMAND_NON_FIP;
561341425bcc70 James Smart 2022-02-24  22259  
561341425bcc70 James Smart 2022-02-24  22260  	abort_tag = job->iotag;
561341425bcc70 James Smart 2022-02-24  22261  	cmnd = bf_get(wqe_cmnd, &wqe->els_req.wqe_com);
561341425bcc70 James Smart 2022-02-24  22262  
561341425bcc70 James Smart 2022-02-24  22263  	switch (cmnd) {
561341425bcc70 James Smart 2022-02-24  22264  	case CMD_ELS_REQUEST64_WQE:
536304e3919a95 James Smart 2022-04-12  22265  		ndlp = job->ndlp;
561341425bcc70 James Smart 2022-02-24  22266  
561341425bcc70 James Smart 2022-02-24  22267  		/* CCP CCPE PV PRI in word10 were set in the memcpy */
561341425bcc70 James Smart 2022-02-24  22268  		if (command_type == ELS_COMMAND_FIP)
561341425bcc70 James Smart 2022-02-24  22269  			els_id = ((job->cmd_flag & LPFC_FIP_ELS_ID_MASK)
561341425bcc70 James Smart 2022-02-24  22270  				  >> LPFC_FIP_ELS_ID_SHIFT);
561341425bcc70 James Smart 2022-02-24  22271  
561341425bcc70 James Smart 2022-02-24  22272  		if_type = bf_get(lpfc_sli_intf_if_type,
561341425bcc70 James Smart 2022-02-24  22273  				 &phba->sli4_hba.sli_intf);
561341425bcc70 James Smart 2022-02-24  22274  		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
536304e3919a95 James Smart 2022-04-12  22275  			pcmd = (u32 *)job->cmd_dmabuf->virt;
561341425bcc70 James Smart 2022-02-24  22276  			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
561341425bcc70 James Smart 2022-02-24  22277  				     *pcmd == ELS_CMD_SCR ||
561341425bcc70 James Smart 2022-02-24  22278  				     *pcmd == ELS_CMD_RDF ||
561341425bcc70 James Smart 2022-02-24  22279  				     *pcmd == ELS_CMD_EDC ||
561341425bcc70 James Smart 2022-02-24  22280  				     *pcmd == ELS_CMD_RSCN_XMT ||
561341425bcc70 James Smart 2022-02-24  22281  				     *pcmd == ELS_CMD_FDISC ||
561341425bcc70 James Smart 2022-02-24  22282  				     *pcmd == ELS_CMD_LOGO ||
561341425bcc70 James Smart 2022-02-24  22283  				     *pcmd == ELS_CMD_QFPA ||
561341425bcc70 James Smart 2022-02-24  22284  				     *pcmd == ELS_CMD_UVEM ||
561341425bcc70 James Smart 2022-02-24  22285  				     *pcmd == ELS_CMD_PLOGI)) {
561341425bcc70 James Smart 2022-02-24  22286  				bf_set(els_req64_sp, &wqe->els_req, 1);
561341425bcc70 James Smart 2022-02-24  22287  				bf_set(els_req64_sid, &wqe->els_req,
561341425bcc70 James Smart 2022-02-24  22288  				       job->vport->fc_myDID);
561341425bcc70 James Smart 2022-02-24  22289  
561341425bcc70 James Smart 2022-02-24  22290  				if ((*pcmd == ELS_CMD_FLOGI) &&
561341425bcc70 James Smart 2022-02-24  22291  				    !(phba->fc_topology ==
561341425bcc70 James Smart 2022-02-24  22292  				      LPFC_TOPOLOGY_LOOP))
561341425bcc70 James Smart 2022-02-24  22293  					bf_set(els_req64_sid, &wqe->els_req, 0);
561341425bcc70 James Smart 2022-02-24  22294  
561341425bcc70 James Smart 2022-02-24  22295  				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
561341425bcc70 James Smart 2022-02-24  22296  				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
561341425bcc70 James Smart 2022-02-24  22297  				       phba->vpi_ids[job->vport->vpi]);
536304e3919a95 James Smart 2022-04-12 @22298  			} else if (pcmd && ndlp) {
                                                                                   ^^^^
Check for NULL

561341425bcc70 James Smart 2022-02-24  22299  				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
561341425bcc70 James Smart 2022-02-24  22300  				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
561341425bcc70 James Smart 2022-02-24  22301  				       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
561341425bcc70 James Smart 2022-02-24  22302  			}
561341425bcc70 James Smart 2022-02-24  22303  		}
561341425bcc70 James Smart 2022-02-24  22304  
561341425bcc70 James Smart 2022-02-24 @22305  		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com,

The kbuild email generator chopped off the important line but it looks
like this:

		phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
        	                       ^^^^^^
Unchecked dereference.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

