Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E173C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 09:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ACD261266
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 09:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhG0Jqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 05:46:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53532 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235897AbhG0Jqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jul 2021 05:46:38 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R9fv0p000356;
        Tue, 27 Jul 2021 09:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=wSeD3GOS9nj/574k/cV7WCr2Kb2fkTdgnXNfBXei508=;
 b=YpF2eY4un+vb9ePsvIO/+T49usDK8aFkRFt5trALDf5X9KyCGQ01ETzcnoyc4fuMjzwM
 t4DlYiwXFVoDFMTczf/a+7H4fqmwjoI/hmX2D9BBR2/LUpqHc2ygRE+VPxO4xMXRcMVH
 7wqt0lYvz2wNwJQIQeyBB7Nsdw7Djn/0y2ABCIpR9CwdaGJEyIuxs2BHpJdBrz/Z8Nnb
 fx+HHQt20SXOcSwv9l8XDK50FSZ0GF1Lj+3CklKHB7WRzSlg1vClmNJQ7db23wbai0hG
 UeaevvYt29jHALsITjyvb+Y6z0YS6VBJmXIdCzXJ9ZOYSqhBMI4B/AiAsFSg6SjoOZRA 1Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=wSeD3GOS9nj/574k/cV7WCr2Kb2fkTdgnXNfBXei508=;
 b=Z80eNEVuP1NHzda6IYXpMsBFakZb86qKLrW1pD3YcZ9PsD2DyQUqWFGt+FwVxSA+w8jk
 kqTtokruCCqKYhKmDOAMyr/eGJqEe+gAFYRUXVIzBfzdB+JZFyPnwfnrLorR6KXhPDXh
 WXHZj+Ck6sxCACYj9rgeSYCXGSO5kE/s7mYQRnA+ougL1pSqITmQL3hViXzjtYInv978
 2gPkBwxm9qwFz2Zq1uyviDOZeTazlWUm3t0gM6jlXvfuu6uAXk7PbOrkiyCxsfGJKR9T
 9aHjfyJ6CN77tljuyP/5PAeQ4UUjtl/aXgKQrXgzD1i1MlIUBQ9aw5d+Fd0vlmrdx/V6 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23589b8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 09:46:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R9ekhu142841;
        Tue, 27 Jul 2021 09:46:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3a234v5wp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 09:46:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6E0i0k5R/G4pMjuEgqsXxo4vl0exkwYZIwqI9GyspGv6unb55f+dQfWtlhMxaOAl5zkrg2Axb+AUSUEVULprfFBqDm0wq3zu13cW+fLnQJ1Qu7kLysAH1+NuQIfk/nF/jfeEfk6fFLTQCD6IuDKe7ccp3aR1AI2h74km3ztvr48bOWcxJ4w9akpntwAcrbDAYsRv3WtfWNyJh0lLXT9FRsTyvnuqtNAYG7U2l2PiHrdekAGb6mXrUdcjL2u+M2VAFT+CAaVlUrjuicrV+obfQ36MyB6dPamDXCkEapwodr4o5Hx8aM4nWBz0PTx4dsLnaxHafRaE/l4cO4NAMkyyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSeD3GOS9nj/574k/cV7WCr2Kb2fkTdgnXNfBXei508=;
 b=MUBAjpQFv9qJbbxK2TVIVPPEga4hFZ440bbjXf+aOk+Y2rqEGpRVDmHdPief7164KofX6i1yGbrs+zxLnZHSchBgydjAoL9s4Gu7vRP/Q+aS1n5x1KwI1abqWq0LzOZ/6JX5vCdp5RrnRTdVasAnYrIfGZd9AdmbeZjm0FBQ1pe4T+0xDnYXHGZhDH/QV3UhLi/xxvq6NkAP4ryXTRF54x+31NewhBqzYagFG2PLeNP1HPev9GI9E0f1fmp3cau1MjccdIg4Q2n8gMXnl+W7gso1YjIsbBWeTZ8qbJk6/xqq8ZYl4HGXFkQa7LQiGxgZ7nqdjQuDbsWwUrMyafcDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSeD3GOS9nj/574k/cV7WCr2Kb2fkTdgnXNfBXei508=;
 b=SdZd1PJZClIIfyn2H+/vd9PH4BzHg6/Ga46N6/bL61Ik5/yyDW0q1Rm9SaHpcwu89S9+dw69+q29iubZZoi9VII0ylc23yYhxTZ3Kj3lEb5tozKt4Gz7X5aINhjMJwUcMoWmu5J5Fne9nnUMCmwzP/EX/1ko/rZRWGYo2Dh41Gw=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2093.namprd10.prod.outlook.com
 (2603:10b6:301:36::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 09:46:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 09:46:30 +0000
Date:   Tue, 27 Jul 2021 12:46:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     alim.akhtar@samsung.com
Cc:     linux-scsi@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [bug report] scsi: ufs: ufs-exynos: Add UFS host support for Exynos
 SoCs
Message-ID: <20210727094619.GA27436@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 09:46:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87f6d80b-8b2c-43dc-281d-08d950e368f1
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2093:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2093961A553A7B3738A0C6668EE99@MWHPR1001MB2093.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gR16t1coXOUxyf+TnJhCZa9Ey1DCaiPT8DuPZpSyM8/iZIzqzLuvcok3IpGUl8qNazK58XYioslBRE+gFYZ/tlzXpSW5X962ISCSRkXr2YQPK8NkkAwDv9Mn1W4XUriUgjKJtGHqIbWute4JTT1GBauIDomW/jFPsMAEfEkHKbMajbV5nl++IORZ+8AlsAE29klJWLiV3LGojd57yrxQUev605nSIRqznGUAYJJCAFKasrpJuMF+HASG3fO9Zb/9sw3C25SFHPJdG3iQFkLD4DT3iFg4/QE9D6SeJsDRyHX9vfTDwaiZr4KTNls0lGS8I0TDNNf3y/xqI6ttMzEBc163thOV9ggIj2ouPpBXW8/XYfvpqKHeOmBxcPXHyNxi9Hwt8jKIya7DIE69N+UXe+2ZMPIFHoMI8uR+OhwRagrux7NNfqSOmp+Zkia/ItF/xI3DdHCtUF6kJRb3GfRhfw5qNnW5VnwZwDQClasjgwzByZ7p4xZQPrOZ/o7s6ibadJTaHS2BttXz6xZWLnLlfrR61AJlt80Jsb4VO9ecL3DoLLcAPtnTIRpazReJ5oY02lTv0da93t1OMW9WxqLvtv9hnMsDMlprqOwqbGo/qOb9r7GGry6rxxdjJBEJ3xpFPMhzROSMm9w2OBMCv/Oy8UINnJYX7FWNR8jwl5g3WBLUA6tehKze4EsdR2ZHbve8OaWqxloX+U6vCvcPiajbjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(396003)(346002)(366004)(136003)(39860400002)(376002)(83380400001)(44832011)(5660300002)(2906002)(52116002)(6666004)(33716001)(6496006)(6916009)(38350700002)(186003)(38100700002)(1076003)(9576002)(26005)(8676002)(4326008)(9686003)(33656002)(8936002)(66946007)(66476007)(316002)(66556008)(956004)(478600001)(86362001)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5K4rajF8D/c7PMBQkcvCrcBLhw0djQuzSpPogWLTe9DsprPOzaF0kon+Q6f?=
 =?us-ascii?Q?N3VUo3kkVFQJ5CtLdthmFTMYOyQe/3+Cm27xl1icVEwmUyqPsa3cMQssYPE5?=
 =?us-ascii?Q?3dupVnq3G4xBHy2ZSMUp7hz94aNJVEdZ83QsUPFcQTB1V1H0l4jZMuKBew6g?=
 =?us-ascii?Q?qeBo9RPPUl1V1jqe51TwsnPRTybKgFziSdRVBwerwsNwiApnkeHONhXCMCcu?=
 =?us-ascii?Q?lCd7E2OHHrTGYyvyxENQr78nMkubQFXVEvoO/vGLAuqEzClGWKblKqRCuN5L?=
 =?us-ascii?Q?gF7P10haY+HwZwYKrb/cTSFZZ9lqneFu5iwEnfQXYqZnGBb1TUgDiQQLntBu?=
 =?us-ascii?Q?KGqpqe2ys5MOqvYk6BIOEmwel2T85isB27CL1/RPgyi6pQqP1RJxpJ+zJFcr?=
 =?us-ascii?Q?3hTHy8HMOF55V95nx3gImx0QyrUJ5etEjXTUdtXtRTpnl6L0oCzV/gMu+qcA?=
 =?us-ascii?Q?m/AnLFIa3TtjK7s3MtbDY6KzbAuUkqTeUY1FAYiFhmm2nZC09rqBpyIMGWcx?=
 =?us-ascii?Q?EuSTCQeHndwdiO9ErAlVCShU64GCcmirx5lIq25tufKr3PChtMNJITqvggKC?=
 =?us-ascii?Q?yLTqp7i5hMqGXLbh8j1cSM+rhvG1MJTraekBCn8CTF0O7fcoOeJmhkCC9QdU?=
 =?us-ascii?Q?XyRCVC5llgNiwix/fJPPER1kwsAkxi56BBYEcS35+1ljoMQ2G5QhNpoBHyzp?=
 =?us-ascii?Q?pJrxJeZGF+XYAT+pu5BR2gWp8O2uqgVCx0gL0DxR3j1Qf6fbiAhA8ZawN8G4?=
 =?us-ascii?Q?p3T6rfuSWOk8dPdmcI6QsnQLlQ4nyqS8HwVjfnAv1bBXSnRqROIw4ayHsjL9?=
 =?us-ascii?Q?kMp07+gLkI67G1QsGaIwnz2Zc2hDrjLxy8MWnM1og/A0qdYuGkqSbiNMiJ11?=
 =?us-ascii?Q?atg0l5+fN782/ikWu5sCYseRNsJjRgjjU+6q/RQZ9z7mk2rv7lyvQhxG/4rv?=
 =?us-ascii?Q?iGI7FgBkcXDt8XBNYoDFQprwPPyguXluNqcsj1owUHZuKRZ8GozybRN4BqGo?=
 =?us-ascii?Q?wzICwC1Y7JHqDY87JZKcMq1tMl78VcgRh27QCZ8aJ6gPIpc1ulndP24KsIIG?=
 =?us-ascii?Q?IDUu9XABb+Dj64iMXQAMEyp3HcuAZPVkfwViciiJi2vSBfYBdRm5l8Wh0+BW?=
 =?us-ascii?Q?2vnCAwoErqe8sdccP1u3ymgtRJvZgToYfLt8j+H0ymW2kna3px/pb7dDv75S?=
 =?us-ascii?Q?rCHVFtKXqoMf8ltG3/3mbUYCqZIVZ2Ej8EgG1OpdS0yaSXR4+Xg4FvuGNk12?=
 =?us-ascii?Q?ygY3YfpSyTpjFjT5sWc0yGDeSsJcGzelIWONJOf4gwiymniBKdQky7Tvj4Po?=
 =?us-ascii?Q?G1UhxFCsBkTGA1jLK7PmTCL0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f6d80b-8b2c-43dc-281d-08d950e368f1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:46:30.1277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ad9oXC9IkNKze8FbsQJw2dY9Ei0EAPUu77G3aQnpRDnNnQSl+wPYTU7MO/4FnY4Z/tzqI3udtE0+gbg2Uv2Zkk9ykvBGHo6GzwS+/2Vs58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2093
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=994 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270056
X-Proofpoint-GUID: lk_QFFqb93YgwkkWZJ5o6lW8OrMOSyyB
X-Proofpoint-ORIG-GUID: lk_QFFqb93YgwkkWZJ5o6lW8OrMOSyyB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Alim Akhtar,

The patch 55f4b1f73631: "scsi: ufs: ufs-exynos: Add UFS host support
for Exynos SoCs" from May 28, 2020, leads to the following static
checker warning:

	drivers/scsi/ufs/ufs-exynos.c:286 exynos_ufs_get_clk_info()
	warn: wrong type for 'ufs->mclk_rate' (should be 'ulong')

	drivers/scsi/ufs/ufs-exynos.c:287 exynos_ufs_get_clk_info()
	warn: wrong type for 'pclk_rate' (should be 'ulong')

drivers/scsi/ufs/ufs-exynos.c
    258 static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
    259 {
    260 	struct ufs_hba *hba = ufs->hba;
    261 	struct list_head *head = &hba->clk_list_head;
    262 	struct ufs_clk_info *clki;
    263 	u32 pclk_rate;
                ^^^^^^^^^^^^^

    264 	u32 f_min, f_max;
    265 	u8 div = 0;
    266 	int ret = 0;
    267 
    268 	if (list_empty(head))
    269 		goto out;
    270 
    271 	list_for_each_entry(clki, head, list) {
    272 		if (!IS_ERR(clki->clk)) {
    273 			if (!strcmp(clki->name, "core_clk"))
    274 				ufs->clk_hci_core = clki->clk;
    275 			else if (!strcmp(clki->name, "sclk_unipro_main"))
    276 				ufs->clk_unipro_main = clki->clk;
    277 		}
    278 	}
    279 
    280 	if (!ufs->clk_hci_core || !ufs->clk_unipro_main) {
    281 		dev_err(hba->dev, "failed to get clk info\n");
    282 		ret = -EINVAL;
    283 		goto out;
    284 	}
    285 
--> 286 	ufs->mclk_rate = clk_get_rate(ufs->clk_unipro_main);
--> 287 	pclk_rate = clk_get_rate(ufs->clk_hci_core);

This a new Smatch warning which is not yet pushed.  The clk_get_rate()
function returns unsigned long so I guess ufs->mclk_rate and pclk_rate
should be changed from u32.  Not sure the runtime impact.

    288 	f_min = ufs->pclk_avail_min;
    289 	f_max = ufs->pclk_avail_max;
    290 
    291 	if (ufs->opts & EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL) {
    292 		do {
    293 			pclk_rate /= (div + 1);
    294 
    295 			if (pclk_rate <= f_max)
    296 				break;
    297 			div++;
    298 		} while (pclk_rate >= f_min);
    299 	}
    300 
    301 	if (unlikely(pclk_rate < f_min || pclk_rate > f_max)) {
    302 		dev_err(hba->dev, "not available pclk range %d\n", pclk_rate);
    303 		ret = -EINVAL;
    304 		goto out;
    305 	}
    306 
    307 	ufs->pclk_rate = pclk_rate;
    308 	ufs->pclk_div = div;
    309 
    310 out:
    311 	return ret;
    312 }

regards,
dan carpenter
