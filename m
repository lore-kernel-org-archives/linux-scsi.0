Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4125C49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB10361059
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhFSCgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:36:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45312 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:36:53 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2V1WM005428;
        Sat, 19 Jun 2021 02:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HW9rPK58puV6vSiMPcN+Zkfr8zmsDLDohMHPKeWcgn8=;
 b=yh2fu2nYfObsB2wlEaIznGtfwiTSiCDTY4fiEw41nflsRjNwHVpDmQ8iTLwgVL9bigxh
 /ApQcMYnRKySeSCzUnvPJ0/KcjkAqpgwok5WxvxtcQZ2ofNZCvFpf6YN6qOluXEjtGvs
 FeKZN8OYdq7vlib5ckctaCnxy5dCHGtyWFQYVIibwTbzzUbwBPxiO2Xjcg70cagii8Hy
 +hsB5dTwL7pxyCSdsm+Jx+o1/giLRvsbK/9cnQr9b4gRQziERMHx4YFscjgg8Pj8eEgV
 b4lpeUlxZWPBhfN6qZ6hOZmo1cP4XDQSrY4H9vmT2vbPtTC63tf795AxtGVkh67cqZBJ dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg13x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:34:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2FDLE148320;
        Sat, 19 Jun 2021 02:34:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 396wb02ttq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:34:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8+imfIPsh6bkiErSSZXtzdRuEeVqnxDAZ5fLioqY5+oJTOeW2vX2EapkVW4vqxWYg2L0rSTOD6lwvI7Nu5wZzrDPTuowTikM7t+9Gb/DA2WuTktjXuo+3pJEKlGWeLf3GcTHj9OGQzzqTzhCKIqesmc0TbR9NQ8nYSH3FT8s4QEetWg9EEXZSMhmBEM21yz+uV3AFaTrjcQ0mv4CiIAmuoDYB21PeQ4CUY3z5qahv11RflAAmcy59AxXfFqeHYe5Q06/oyG5O1Vpeim9kTrVc0zBNHd7WvAplZfdttEjBYhEHQWrwvX/MBaP7MaCDusD+a21T4l8OczniRtYesTXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW9rPK58puV6vSiMPcN+Zkfr8zmsDLDohMHPKeWcgn8=;
 b=CQufBqVJ313D+rYduNS+z5uEa2ApT85ZwqmOK9oCG8lmE0bxXnaD2y7DFD61/PKoeZPUxIL66ZFfiIp7gA2tE9NSYLzmz+nA9FfAY+xdABGLKhWQUcTXsCibRXTpMzY2xNFYXLzUD/5RVvmvtVsbguQAR7O6JvCym870VjQ/tKIlMA7ZzvAu9FBphh7Y3ZKB2CnnejobpWr6cm6GtIjhViM8RPmYtaKkOECh0QeAC9x3A5elGy1H/cVS8qrQitebG+ORFlzsAGF3m0Af0LkrZfd/el1vwAK96qZkAPT/Ioy4TmYbc3ODTYO2yu6X0KkJySU0WLCQIs+hD5TQSywGoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW9rPK58puV6vSiMPcN+Zkfr8zmsDLDohMHPKeWcgn8=;
 b=d7cSNSEHZeXYoQEVLwpc6dsNvUWCadjSIwt1GHbHw//FH6cKeit54QgUV39xT6yaBVcnC812y8VQPlBdr85YD8oWvAzMndqYQ/qvpE4xucgKuTw2Fu09evrSxieKJkIBuQp+qQdBqrsEuZ1WfC+8DOT/NB0aT8JpWezWK7XPsmc=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4533.namprd10.prod.outlook.com (2603:10b6:510:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 02:34:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:34:36 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: remove redundant continue statement
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1gyy43w.fsf@ca-mkp.ca.oracle.com>
References: <20210617073743.151008-1-colin.king@canonical.com>
Date:   Fri, 18 Jun 2021 22:34:33 -0400
In-Reply-To: <20210617073743.151008-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 17 Jun 2021 08:37:43 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:1d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 02:34:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28803f72-0baf-4e3d-16a2-08d932cac7cc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4533623555E68467D46A0E558E0C9@PH0PR10MB4533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIgbYZ+OOOfBFbiUzdminfkpXixJy4hMpNeGBAcYcrZjufAyqdxC+IGUd3r5OuYsx0FEFAzh+rOMbMw0l1QsDEZtJzJcXMlwHrl1Py/5PTHAO+iED1/1TSSh1VxeRIKJmqLX5aucRCNZJTr7v50oHW7gsFFUo2THKN0SXNczLFYO76WZAyv/E1SYn8dtCHb+T36mWsxyPC0jHmEGPu5vDgh3dvLzozExU34ocpRJlHO7nC96h89mP885sCXPoqDrKn2A8vk5z4co9Ac+jGvqAmho2pPZuVdfdRyGKhYJ+mHNnnWTd9VBVbz04oebQPG56L4sDZu69e67NnKBX/BJyNW1231wws2DyffHkx5sF1EEvGBguP9L8kJb2ETzdOsekr+REM/8lwlrEri8nKvPPcSyaAh9s/vxUoJErqJI6JkfZgPUKJyDx0EutoPpbbsyJsTLm52EXO+MGxaVVRNmGIqwFy5RHnfrb/Epj7t5l9ox31473Z4yJKLwRDfpfAUgWVkRFx94As9zc1Q/TiIWqnLgXmg3ODlNnF0/igS8lQ6TiKxxlZVZV1r3Mt7zRPHkhH9GYBgz2fBNvZQ8mI0kxLXdtlaSLbF9lqW1+n0ep/nRLTkYkIgcy6/ZlZ4KKn2CetZs9hp16UNYOH60T4hPNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(6916009)(8936002)(86362001)(478600001)(5660300002)(8676002)(558084003)(54906003)(52116002)(6666004)(36916002)(38100700002)(55016002)(26005)(38350700002)(4326008)(2906002)(316002)(956004)(186003)(66556008)(7696005)(66946007)(16526019)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bJIxAZ8A5MjMpj6yJzupfJ+BHM3HyX+ZHqbdUwzFE39d7STTcElLfeTMMwqG?=
 =?us-ascii?Q?UjEqUa/jzKIGfwGTI6RavLuzQWoOxNSC1tNU0ohyhHCp+UmvmCIPfEZSDmLH?=
 =?us-ascii?Q?RB1RR91lu7TA0sKoM0bomU0fpTuAobYi4z/7pJCFFTNhIRfNjuIliZGaMk9d?=
 =?us-ascii?Q?3AdWxzOUB1FB2s7piyliI0b7N8+MTXRW9Et9tWPhlzI7nI/bqE4YxG+y6hvz?=
 =?us-ascii?Q?EQSi/ZIe1haz28AlWKmJwz5GZkson96HsBWOoofP0QNNrYREeaW0VA588sAo?=
 =?us-ascii?Q?GUnEqeN06AWnvbeBQWTVACA13U9ghhwXt5QpQxY71OLlpYDcSjWz9GMF5aJ2?=
 =?us-ascii?Q?ATkGrddVQkIbXGvVkt0IdXGCEkMRVoOUb5oxSRZzgnSF1oOd6rLTqnLVEXlO?=
 =?us-ascii?Q?j58iQH8WkLxPh6mOJrgc8EvzEwlHFZqRAVoiQL+tOL77Xbm4Ei6/qmGLQL7i?=
 =?us-ascii?Q?Ex3H28UNiPelJoRq5CKJtAietggBiQgQXXnH+1NyJitjtLRKJH999wTgCfmi?=
 =?us-ascii?Q?H4Ms7n0ahr8Sf46JO+YU8MA99g4bGpVFBBwqKgoduTtVi8usj5LoqhTyrBhJ?=
 =?us-ascii?Q?UlWwvvIR7toUCsYTIpdrDL84nSid0x/46dhJ6TiUCGOtKTSygLSQwHAqc8ZL?=
 =?us-ascii?Q?xnoqkPbOQs7diKAB4tmc5jk2bWQuWVHvoP34yapgxuS8902K3BUUVexSHhQI?=
 =?us-ascii?Q?TGss3fsbs2OsUaAtMyOrsQpHBQ57x7vug81mRh+z6RMQd8EmnTtbzh9fuq++?=
 =?us-ascii?Q?inT1Gp54X2Tl1wQuQntFGOYoW75WTG2rQTPAjiqhxp2M+vhLa7uAZpLw/1v/?=
 =?us-ascii?Q?AXsQYb0SoWoeukVHTsuB5GsPPr0fVLb29q2GWo1npN/6hBh26cCL5W4CsHIq?=
 =?us-ascii?Q?iljxOtDZ9D8FIdxP624ZwjEIeOU21emJRvilQ88hdHarG4LYPa4lfudxw6zV?=
 =?us-ascii?Q?zVX1z5/nNY7u77MwVQBJHTqhVyHUNwk19esdIyde4ltAn88pIy0+BoQ26+p5?=
 =?us-ascii?Q?XSLmsWg+y7Lm59q7JBNBwTOGXI251PTk92rZBntmD35BLo3SyNVwhnjvvT24?=
 =?us-ascii?Q?Z63XvhQKdn6Gfs1v346wAfZgX9ozMnIBSVlcYMAjP+FCOQs8fXVPIDgnYRer?=
 =?us-ascii?Q?hneXM61tnw+T6VFXvvYvu06p3VyL4sg5RcEtVPkRSDJLbWxjvDS7JBkoDfKN?=
 =?us-ascii?Q?FEU/BRH1KxxnKwAmQJ70zJilT6/xKfzsxwZfWR0yCOPcQM1/6GWvMgBjw93y?=
 =?us-ascii?Q?0svW7tKS1ExRA24HYPgrUJ4yESRTrNcPKp7FNo3r/8RsxYvTyWcn8q+i6/tN?=
 =?us-ascii?Q?L3gHwbig2dqmjx0qQ/H71rza?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28803f72-0baf-4e3d-16a2-08d932cac7cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:34:36.7654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m42bhV7fLq1JaCsOU0+mk6ODmd4xRDSS6GmtluSKN6nBEc/I8cY4clatAFEg9+CYPK3HIzGwSmybAnH/9iFqDNfIFUkuG3TuVHjvF+GcDgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4533
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190010
X-Proofpoint-GUID: SOj7wdpnY76IUk0ga4lMCp7RBWyzrbLN
X-Proofpoint-ORIG-GUID: SOj7wdpnY76IUk0ga4lMCp7RBWyzrbLN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The continue statement at the end of a for-loop has no effect, remove
> it.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
