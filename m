Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF64BC48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2EC6611CE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhFSCIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:08:11 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64456 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhFSCIL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:08:11 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J1vLtZ009609;
        Sat, 19 Jun 2021 02:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=U6n5CWICGiWDrZXdXpstJfzZMT3CBJPPeWIKXdBwUOs=;
 b=aPyvOpgjmVl/VcAYO6+FXI7nRQmvN6LQUzlkytdU1e1/CcklmSrVDbt2nA0G+hLkIt3K
 38F8VLzPQNPJmkElCgaOc9EOuaS3dXi7PZ3sYJIW4Yu9WwwQIGFvfbiM2/E7UE3mfujw
 ANFHwYzgtSsFrRA9U7unuLTD7JIk9spzIBYo55YTPKNEU5qZopWecYz6dU7T7Z8Cxdz5
 Fo79SLAGiJEjSO8bvPmsrul+RFzTEBsjbJS7rYZcfYvrVfFvojN1xArea7o17CMMxpXS
 eNIgsecKwt5yxD+cRBq7pTgnYN/eaSXdponaG14QYwXTcFtjdrMqU6KssWGVWm69Ul+9 Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg0j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:05:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J25Ekj123775;
        Sat, 19 Jun 2021 02:05:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 396wb01x87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:05:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESpHkI5UiisTReZOzBG6fSX/+V9Gs61fdxCUvThan9ug1k3eS9+REdXdIMvAYSb/WF9J/HCyCDxdvM0F6lT6YdRxau8SGGslk1jYlyUzgD3msoLurbPLsJM7Wkuh+9YMlkAQDu5V2VTAPNebZ6MrAY7+B6UeXZ4kNHtmpW26YiEN5i3aFzsHFmwaQ8b6w4QdHEJSplXhNkCvnA6fYeJGm1LFW78J7WCp64WzT3VNTGXrkQJ/orrHUjxAuQ6TvGDadYQS8g+CCIKdq2EaAmUdZlVfmjwHxVhdchNnU9AlXA/ZrqttsGmGVy4Hb7HxbcPGkF2+8vaz6yyrCf6k6eNQUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6n5CWICGiWDrZXdXpstJfzZMT3CBJPPeWIKXdBwUOs=;
 b=F82r/Pq/zmn8Kc9TXT/JrIloxi0XkzJhFW10eut36OgZvqD6JZp1locKERIacp4ryUC7i0TXe9TLOmFwJSrYkLWZKi3pteWwJrFV4y0IgQd24+lEEDkv3MmwCnsO7QLJtKWEJ8tzqrc0XscU63MWUJWYgsw/UeAQ3rDoj5jLriyvby551Mia3y4Oj9QzqjU9XvjfFNkSwLmGCdGGEXt+94udpNTxpsnOULb6dkoht9NdKTleK2FepbeStVrG3rNwPoCkME6VYp4KNF+mg373Roc5QsAFR9kzELysD8kOxJ5pnLJpXpCaejfo1VDp4XeDkFmUmknVgfieacKUC7biuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6n5CWICGiWDrZXdXpstJfzZMT3CBJPPeWIKXdBwUOs=;
 b=XvioIxQpTyOL1REYNjmcNWWkpvE10EgIe7iiO1DYOiYdXwYADiN8DhfaOeQ1zh+RcDWHu4AFGYaxE6BN/hH+iWMfbz6EV8xPUD//6tepw+ObfnNjH0w+u1L13RzQ985yw7fEgEy9Bzxw5JwKs0mgmum0YxwlmcPxjuiftlWLb64=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1245.namprd10.prod.outlook.com (2603:10b6:301:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 02:05:52 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:05:52 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: Re: [PATCH -next v2] scsi: mpi3mr: Make some symbols static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17diq1udn.fsf@ca-mkp.ca.oracle.com>
References: <20210604071407.1360742-1-yangyingliang@huawei.com>
Date:   Fri, 18 Jun 2021 22:05:49 -0400
In-Reply-To: <20210604071407.1360742-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Fri, 4 Jun 2021 15:14:07 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::13) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0308.namprd03.prod.outlook.com (2603:10b6:a03:39d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Sat, 19 Jun 2021 02:05:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04e3ae68-8bd9-42a3-cf00-08d932c6c41e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB124517EEAE9817F5234A36E38E0C9@MWHPR10MB1245.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:164;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MVzXNGc+Riqg46wRt1wpdwp1+qCrN213sa2CGVwsfU1999Fbnl9ji9OPSuddYRhs4n77Y+1YVXGhEBQRHCzUN088r/eLVHN4aVAbcFwwrbQSHj5gikRZo59ayFLexmP83SOln4SstN7vmpvsO/KBuzsrkY+1oj/jFxAuWzUyEjN0jF25UFi4Ydx4FpG4pZqFeTUgTjWY+4HTz91zmlPFsURSoL8BC+ARQjiVJbQXlk5pylrg3GqufDEUo7bkoSaZifDh1uSF/OhNak0QhiVs8w7OdswDau7Oh9DPFSe1bWZ0cZHMqvZpWQ+BVaNDbrxUkbID1od4J55Z3DbN1fv+DkCDuAZLvvQu6DL7hjfDOSHI5h1UFJU+VyhZpQGGM/eYjVFgMa6kd7To/nrGgvmpWFRy4rDFiTSG04aHzGhb6mbAxPcnuvmWIxBqjWueGnWPfzEVuxC8Afoln6psGsDDCBbZb2uwG2l+BUiSfpOsPQIGYnA0tevfhQS7XYjc2nGvce43tgUhUJMwPARvaaYkEQPsjFFjAIk5RgBzedzHJszcNEWa18ckBKnP9s6wTQPQliQCLQqACAU/W24eS4NgaNNpkqqEsRte9lHepKvaaC2A7E8/LWRxD2Lv0FA2zzBEhJ3a++jGT5AdolqqJQQEtEPmR/q/PAkRXGS6ncXhlgJvJbvVrw/lwUXdwGHWqW2G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(376002)(396003)(136003)(4744005)(956004)(26005)(6666004)(316002)(107886003)(8676002)(186003)(66946007)(66556008)(66476007)(54906003)(16526019)(38100700002)(38350700002)(6916009)(8936002)(4326008)(5660300002)(86362001)(83380400001)(55016002)(52116002)(7696005)(36916002)(2906002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SuFsbb9weeMD9BfHQ0xy9rbTXU8+k/MCqCxXyg374cRYVOKjEw3Kn1x7ZpF0?=
 =?us-ascii?Q?maP05w4PLjuZzClQ4VgAAdsQQI75GreOcT1eUQsJxjbi4Pv+jw+3j5U8CQm5?=
 =?us-ascii?Q?QBjfpTTM4/0HxpakmWtIEZQEDFXsgDZgHPDlgE5Dq7jdXlHy6djWpFFsVj/x?=
 =?us-ascii?Q?vOq+kl4CTwi2DtC5FsUZPwc4GBCB6TTv70K44ClfWq54SUuzE75fQSlvp00k?=
 =?us-ascii?Q?wTu/R4JfHXVi24b8q5jhQwD6tpmzkjzZZG2MCOojyFr2DEtNP/L7URFDi4mf?=
 =?us-ascii?Q?fZ6cpgCbsgxVM6ptpFYd8f8Xlh3pVol/P5X2i9bMeIgNldSJQ1oTfjNpPKKd?=
 =?us-ascii?Q?y3OkiovRBBtsqz9DUl8R02zzuqSmwUYXvf556Kk7uHsAJ4GYUITuic9ZXLi0?=
 =?us-ascii?Q?BN3SAzppX1urFznORel86dLYePR/qGXoqQWA46Ciqz2wAClHVZ5c358TYVp4?=
 =?us-ascii?Q?DVUSvzOdvNFLAnHzVtcjbdKlaAm4uCLFepDNTAOZdfyTKJQmXYYUnTi47zXL?=
 =?us-ascii?Q?mSg11qlbFpn7NRIbTZOn4posNPz0Ifn/u0wZBlK98fI8Wu3E2QATaTUEAtkT?=
 =?us-ascii?Q?vVCTI6quiNGVuD0GlnA2y2j8YMzc1+K05AoGCnxcfoW9QgDAbCDPyo1dQZ5G?=
 =?us-ascii?Q?TcGnq9OEl6ptKgXvPGyW+a3W+5o0bD0x41v2gsq0yGE1TQs5z7krUPA520aB?=
 =?us-ascii?Q?jzQeAtpG70ZEl3uOTOI9nuLywXCK+w5AVv/2OO71ZWQVqZ+sK2rz6ktagaON?=
 =?us-ascii?Q?2xsWb70j1zrWiOP/PggpbJKQxAu93CS2fc/CT4Yi2u1hWsVyM14XYX7vg52G?=
 =?us-ascii?Q?1CSBb9OG8O1WJVM2GNNVajzEo25fo2ifPXO5A+qvxF+wAVjw+PWk85buBUdS?=
 =?us-ascii?Q?kcY58lB36Q4QkwBZ4uY4s7aHp/i5Eya/z19NC87HvGKi0UiF6ndZTrJBmrHY?=
 =?us-ascii?Q?nSOQ1rsIJfefdNbFomLZdFi4w323DyqELxRnZovEz8nhzkg15QagedGi2I8Y?=
 =?us-ascii?Q?pfDgcx9XjSfUFemex2K5cZ6MGkRkZUB+sqgxdLiXfcVMvIvRYNAwC/oUaJa7?=
 =?us-ascii?Q?MUb6rLc4Ej8FZZ1gs8TM1DqO9hMtulIjJrr49mrgQW6AmGYYVdtc15MJGExq?=
 =?us-ascii?Q?emufDo3x9Fw9+igVEeTQNmzWd8goHzeRft4GG+dSwJrCcv4Es1ojlQ+liGNM?=
 =?us-ascii?Q?XR1ee7btNhgwLYkVfB1TIV75aiJ+8p+W3WDakiuU1oyqMPawac6rrTp6a5E7?=
 =?us-ascii?Q?PkYujPZktwn1s0Hi28oQ2hMdV2h+5IVEp8AmZOCKmSa9SSHvhmPu3iYiWLeW?=
 =?us-ascii?Q?Cp5H1zHgROUhEKnPLi0tUGtx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e3ae68-8bd9-42a3-cf00-08d932c6c41e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:05:52.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /811ggxvLYpRp/19okPujjXPJOZNv4uFZrBvb1CrDc+hB5VOVvy+/FubXufXAokGtlsbv/ExPO/qQxp1xSBW9Z2K2f7w81lQLqlQzhZJx4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1245
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190009
X-Proofpoint-GUID: Ds_kf7cc8rUwk5JQbZQqZMBfxnzZb76u
X-Proofpoint-ORIG-GUID: Ds_kf7cc8rUwk5JQbZQqZMBfxnzZb76u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> Fix the following warnings:
>
>   drivers/scsi/mpi3mr/mpi3mr_os.c:24:5: warning: symbol 'prot_mask' was not declared. Should it be static?
>   drivers/scsi/mpi3mr/mpi3mr_os.c:28:5: warning: symbol 'prot_guard_mask' was not declared. Should it be static?
>   drivers/scsi/mpi3mr/mpi3mr_os.c:31:5: warning: symbol 'logging_level' was not declared. Should it be static?

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
