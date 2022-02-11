Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E1AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242929AbiBKWHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:07:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBKWHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:07:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCF7C7E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:07:31 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BJdntV011211;
        Fri, 11 Feb 2022 22:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=n13kX4/FHegiIpTAGpVRSs1mx45xEJV+C98Dca1jvTE=;
 b=CYXXADtt6UxZSXWtXpSAuwzC6AIJmE7tkjZ8S7SdoYRsjLaShk6+bL/KJBAlxYMsl/DG
 5dlp/+cTG5+f8TSGLMTgU4JnyhlFUr+Hh4QzITqVjdWxmey52RzcV3Jhj/2fZCEAHYce
 RYdGm2JstXWBRv0j29NDm9v8l1+WNpdMBti2V3KxaGiAsgrCnBb+wBBzfwmrTtELX3Or
 vYpLE6pZMV9GkBvrHXpWE+AjDMgYX7ECRICxaVnMFgIgaR3db64bvqNSNM5M/gTai+H5
 mGSgMzmn/6i6PhuKGgysNsdkkz0SRTxRhYhbrJbvQMr/dqu0kw20SI9IbaC1dT6t0hWp vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5njr1n53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 22:07:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BM6JEP146685;
        Fri, 11 Feb 2022 22:07:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3e51rw18e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 22:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxOZjrXbSpvt7Mc5CcLkXxrAbjWO9m9wNZlhg2EO6tkS+DH8b7irwWvYa8N83iDhqevLgaFMqkK8zWYz/2fPPxlz/Im42yTFOn7hCOHzH2OVUgBpS4niKodDuNTWuDdFra9bZGyY15acNZb3vPd04T6WfsK45rVds+3DU/+IowzDjm8GJrtz49fwKcQ7F8EEHJDIf3wluTPum5qxssvTITPPr4CzRJmEUYCdg+447YtHZtK/fhsCv+/Pk/aj6jYVwecWBCjBeODIc9qkWyb5H9JK8FKR4N3d1LdsGlrx5RAregFCgz5S+thI3cywbVh/A26FufwFN0YRkSKXBQsliA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n13kX4/FHegiIpTAGpVRSs1mx45xEJV+C98Dca1jvTE=;
 b=kc1NayfIi0TSCMzISnSHpYRptH6Gw+G6k0zpqnSVOujukH8cGK1LZ94pTdQAOCo15SN8J+LRcK1wPERGz69Hx83J5y8n2yOOz7wy3g1tDB1VuNl1i9RRoX/LFmeVM1VTpUT+LbHNLlGJIkugJewC0hcrmgnq0VXEXwxaJvIFcGmgEkaBETrut0l0cD33u81eqhoQ57Log8YddePou7RrkB9DC3TOPWMYIYYIfsjY3sYa4aK/ZQNoIU0z5DQfXx5VFrHeuC5uKvaBSlKo2li9/egLUDnbLKBpEthOJxtT4r6edFJ33kfx6pWfhkGLfzeXpgbVI2C7AaY28pjp8Y453Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n13kX4/FHegiIpTAGpVRSs1mx45xEJV+C98Dca1jvTE=;
 b=NdNaQKno68Eym9728CjJG2EYxoAOaQh+uGGj/65Iwy/W5O8V9wpPvgtxTPoeZN0deCrJe8oR1HbnGEebBNnAtU02hTv9qb20NU/f42P4qruCSFvsWGF4an+Er/9URkpVDoy0Gzbi5HeBHW8GEwK/CbBZw0psbhsu9kjnemxHZrM=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DM6PR10MB3001.namprd10.prod.outlook.com (2603:10b6:5:69::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Fri, 11 Feb
 2022 22:07:27 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 22:07:27 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>
Subject: Re: [PATCH] smartpqi: fix unused variable pqi_pm_ops for clang
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0e1oy6y.fsf@ca-mkp.ca.oracle.com>
References: <20220210201151.236170-1-don.brace@microchip.com>
Date:   Fri, 11 Feb 2022 17:07:25 -0500
In-Reply-To: <20220210201151.236170-1-don.brace@microchip.com> (Don Brace's
        message of "Thu, 10 Feb 2022 14:11:51 -0600")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::17) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9a7acf3-5050-454f-52fe-08d9edaae3cd
X-MS-TrafficTypeDiagnostic: DM6PR10MB3001:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30016E0A32640EC9036A451F8E309@DM6PR10MB3001.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsnIt6wd7PRROF3tW1WgCOYERbtyiDnA/E1fzPbAJEgNA81gv95GdvOnEEafpTMvGTfS9IM1pTt1n77HrqwrvDRKp6P80HOOvnYC66rPCDBIMESSteXOduMC0oorAJL9fR63GbRUVIuhsCQcRgPGCeez/Y61pke/2gG25jMmFTQ0XObAJQPjg9Pagbd6JGj0BHlmvcapwNL0VoZHRjJVXjw8gbydq7IbUe2JwpO1M2zhXf1bH12P0VKv/YQsx+OnRGrOEWPpH5kMqNZCcWei4xGv4HCazGusmecAQDbvpf1TgYP1lTwnEkgHoa1wu6XBuRQbMAR0yIQ1Qi2opNs56mCEJBAwHdD8B71mIn174iB/kVCwMcfPLNEEEINylrnfRq/Ykj3pr5jlj4G5RlfrB8L5adfuxVDUTUq80k72ZLjo9BLN7EAYcR90z/vYKfDcJXThD4MaYGDnvGxtm+GWpLB+EEFJUbsLSc9+FsXFPvN8A1II15l3ftEOnEbfREAJZzKh5SY46VdH5xT01e4kSpm1WkMpykA/ONdaUcayK488V2x2UQ+sHP9X/gnncT/5nS7zhXTSpNGCUS3Tv6Lm08YZMiGkRCBRW8zrd9/rveFr/WSSqBTMdE+Q3dM/P240TUSRTpXWW8JZQBfBPf86uuE10onJ9upq7c+mqBhsYBvcXUKBwTTW2h8n5Wm5p7zQ92Er7MVVg2FuJCd0ZKkLjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(186003)(83380400001)(26005)(38100700002)(38350700002)(316002)(86362001)(6916009)(6506007)(36916002)(2906002)(6486002)(6512007)(508600001)(66946007)(8676002)(66476007)(66556008)(5660300002)(8936002)(52116002)(4326008)(4744005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AOimyVlS4TPRdvP+ZvYKzWG3BgHyAx/1RevX6JYldjSR4ZJ3W9KZFzYUKzI5?=
 =?us-ascii?Q?m/ZAbzXkL1FcmmwUgkd4H1hFQ/F98enTFN6VBgQZzQOHGgl3xQAloYvM1UXp?=
 =?us-ascii?Q?5ZMDGwGcsYRJbMeSEM24iK+Rgre2kDtGQ+ptzTP6psKN7/f1WWCCR9EeFiQ7?=
 =?us-ascii?Q?RuMXA44ddGixSY1yXhqNefHQf8rKSTsuLjFeG09YdbOWtP69EJ5DKAstKLU6?=
 =?us-ascii?Q?UyDtcBsXab/S2HixDDmodMTWwKm1HQyRjvNzQJQ6gY0CkizgPVlh+vOpMUVp?=
 =?us-ascii?Q?Nd2NfP0B/LtCNrwwvr8UULKYBoyixWGh1pwAWsoord7nvJ4CSXZ/9DyvedwC?=
 =?us-ascii?Q?q/Eh26+eciuX2J+j+h6MuOQdCunaDOnBwHF4xrL/A7sPv4r/WcuwyOjlvY2R?=
 =?us-ascii?Q?gMjf8q4ENjrUwXpQT/qNgAYx3duH238c94nioC6KlxA1KnXWAUutdN8fM+ny?=
 =?us-ascii?Q?Wh0YfP/L7ARCfyXDP6+4Ovotnby5hX2MpMmsGkS6N65CN5/nMvQ40DoZhk8a?=
 =?us-ascii?Q?RnBwi77uP8KPWJgNXx2/WwxXZxyYLcymwXLtOPIf+zfZCam9M8JHKl5gC1su?=
 =?us-ascii?Q?MSee+E3jRv2Oga5sSFiofdTpJDZwoNV1KUTzIWw0573LLP0yfDjpCwOX9Twe?=
 =?us-ascii?Q?pZUDPCw19KLNMD0qqXnszBLCWYMGF6mZcOUJ02WhcVcvkte3gafLHq0Cu7Rz?=
 =?us-ascii?Q?0G8QIYpS7OkEtmi8xDk90plK5lE4fJoonAXOa1qcCUU6b2FLDfoi0ZnY+mJk?=
 =?us-ascii?Q?u37d/8JHR4QqJPxRvPbxKcbG8LGYxdp/S1MiL4ciDQUJICZR4jF/xPE+CYQb?=
 =?us-ascii?Q?4LB0kaFPFrpP+LGTh2Jq+v7xESfO24ngnBemYtL5vWA0tGwivPYS6vQR7ofC?=
 =?us-ascii?Q?flDTTDqR4/mMGV0tgaw+nEtGjs6RnSFqkJ/9raHHu6C6kXd/EfupgM3wgR5A?=
 =?us-ascii?Q?cMGIWk16BkNwHJKTSZMAd1xJybo2jFMVwhP1EiD8z5uT85LymNWSxrE1x5kP?=
 =?us-ascii?Q?gm2wR6HQjm1qbPbkz7prVjBGSg7uJKQK61YO732EtjTC4ZGNuqT+rDgmMsGe?=
 =?us-ascii?Q?4FFJ5gwSMYd8Qaq0gj09R5WQOjcPo/uonYD6OyA+Kokp07PPpgPLbSOG44oS?=
 =?us-ascii?Q?9RApYwVau1RPgOMncoF9fa1i0sqQEpOCM5qXp8Ujbhoehx+ZvT08cxQ5eedO?=
 =?us-ascii?Q?XP/H1KZLlX4KX1jADD9XtYpA8ijce4nltn7rZU7ODr9nuQMoNE4dOEO2XGvT?=
 =?us-ascii?Q?geM1OLbx9bjjbJbnEwMQ7Q4E6XzBR7MyJkiYSCjXXJMs8DjCBPXFoiuTnSMw?=
 =?us-ascii?Q?bPczR9B775qsUDy/tS6XA6BatDKIt1aWQ+iirUFEP5cwrpl6TI0J7Jn4Ndi6?=
 =?us-ascii?Q?vR0a19yOZwUkaXdWjTSZ7qEpcGaTVpEFnLYL3HQ75JcrK2QW6lc2s23oBW46?=
 =?us-ascii?Q?Ym32ZS3ilFG4lhkRuab9ohwEaSUwKPvk8m9ZSxNjJ2JrVhRO7N0RuDzAuH2h?=
 =?us-ascii?Q?pENo/IdZcVaSPjSH47nFIWfnxPF5TF92LnEaJFg6HA+GX349O3O7xIHSL4on?=
 =?us-ascii?Q?y13CJ+/M5grM8MXk3R+hzHlY14EwQOGvLkPp2NPCWijZmvJHgZ6YT1NvlCml?=
 =?us-ascii?Q?ecpC7Mw7h63w3aUJyZKXY+sb/0I417mtakffIXlxN+LLVUxuC1nxsAuZoXgl?=
 =?us-ascii?Q?VNLG/A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a7acf3-5050-454f-52fe-08d9edaae3cd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 22:07:27.2680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mV0MlF1ksXF4yG3aVSV4dwI6QdPFFhjgNU/E+EfHGZDAcSfK2jTBbLBI7LvNpsMmBvfc7ArSOAcjh+9WNpvcN+No0SCcP0D3Fzd7bkZ9OuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3001
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=564 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110111
X-Proofpoint-GUID: th_Tl53OeIRcPrhrdNd5vxAHg5O3hfbD
X-Proofpoint-ORIG-GUID: th_Tl53OeIRcPrhrdNd5vxAHg5O3hfbD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> Driver added a new dev_pm_ops structure used only if CONFIG_PM is set.
> The CONFIG_PM MACRO needed to be moved up in the code to avoid the
> compiler warnings. The HUNK to move the location was missing from the
> above patch.
>
> Found by kernel test robot by building driver with CONFIG_PM disabled.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
