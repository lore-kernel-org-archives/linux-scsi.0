Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8649EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 21:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA0361107
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 21:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347697AbhIMVPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 17:15:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40590 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346066AbhIMVPB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 17:15:01 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DLDeKr018473;
        Mon, 13 Sep 2021 21:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+SFSW5oulJprkhCsszRI9XuB69cOLzg7Bp5vY152ghg=;
 b=wxtgh0uwAprNv5VHz9Hqudeo4JtqJUMuwn4gBh+fP9fMUcydZtr2RMImvq45v8n0BU7d
 KxgbMojI/1ID3SJixmOxpmGISOs3K08Brf+Sk8gcdfZ3fJ7AutZx6BDUWmmPCW+3cAeU
 VvCDjBxN1hyEwa6RTQ60WogQMZJOc759vHnrDVauDwX6hkIpbNAGtF3pyn27Y9hN5Z5m
 XAsCLaNKu8xjv1dTVsViMbxQG0BBAHCTEfSAcUjgWH/IHHwQvjZTMqkT4Bt90pbKGZ/s
 N3xUI5GKxqmVJeL2q8DFOC7YYOZud7Rknoon08/sQLFXwkDOcxbThHySZEYPfQWdciMJ 1w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+SFSW5oulJprkhCsszRI9XuB69cOLzg7Bp5vY152ghg=;
 b=tLiVQJQc5L6dD6XkchmQllH9DYgFhX8kclblH2a2An99MeUE1HONHeLT9ihpIoQbHqvB
 cR8kc/AVpcMR+WZv8ipqsZd6xEa3I4PNHNn/bcdoy6rJucznWLTwBnyvqXS4fHxZOkPg
 yiuhsKpMFtFBR/LznNXpxs3DCuFA+rSa3ywjFfxErA9eaM+nvzkZ2uA2Wb1HcpJ75HfN
 3UfVpYn4tDtC/7Lo6mupRLZhVSauRCPMHrdT+6u29jIINOdFa/aQK1CX5mxWwba6jjAZ
 ZToz/uHStNzMPYPhOkkO5QxOdhip7ojlIytySqrKNKkFkLvE2Qolbk1ObPjkV83mUYMk pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1scamg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 21:13:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DL6VmK036352;
        Mon, 13 Sep 2021 21:13:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3030.oracle.com with ESMTP id 3b0jgc3b89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 21:13:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ng/oCxjc2Px0mjUjzgTzreUyFmjYZgjqRSucO7TfjKORs4Z7V/HKCP01c46wKFRn2123N0yixh47IglVW1D4IUwDBA++o5WBMxdPgGYo4/+/7fuk9mkjXIIsHoF9vxlU7KiT1yQ94kGQ+vp8Bahug8m0QzK8qlPOJRGP2I9yizwhV3647SvBXpvRrbRSEYdk1SqCwVx0BhDT5G6zkSmzhY4yywSr4p862TEjSNoQ+AMU/HnXRzvnXtxalCw8qiBM9InYlpURDqGq356BMoW59dN7JX3+qMkqHCbhMgExakYvxZPZQbF4U+h3BneHbPclXGg6iJ127F8rjufpYEf8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+SFSW5oulJprkhCsszRI9XuB69cOLzg7Bp5vY152ghg=;
 b=J3tGz5aRNgxHB5BrwwMxnWp8cagA4nXX19uC8BDE+lpQJrO1ZZmcoxY1oVNC9X2G/VFKHzfFAUx3F3cr1wax4KW1MB/MViPrbOpgwly6A3qsNTizb5KJTa1+yg/NoVR1k3nSlWZ0mVWCz0DQD3Stkp5tKtG9F12OrpaqekJSu6YmodPLivPosiIxpNU5PTjwK03yIU7DBseHaUt2lAOYlCzEQIzRoieN4bqfBqMvirWegl7alRtm+Jwm//QtdtoY2SJIuudlazPuO0kcTbBuVI27Z7dq2Gu+Gsug2jhgFOn0Qa98QpTISVWZUYCZvTvg6xNasdry29SvrhJ63jelqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+SFSW5oulJprkhCsszRI9XuB69cOLzg7Bp5vY152ghg=;
 b=mycUcq/veRqy+HRg5v/VSZ5h5Rz+fCLerbqCtMzfadqsvGY0WV6fjNKJpJTyGpJ/ztFOW2JCTN3kgTTJM/uAThKdRzpEwloevs0PM6kQ4nzwh9Ji187wtGesDNVxWYZwZ0evJJ6rpwZDbgCloLd0RuKCavSHnommN07ginlgUFg=
Authentication-Results: imap.linux.ibm.com; dkim=none (message not signed)
 header.d=none;imap.linux.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5578.namprd10.prod.outlook.com (2603:10b6:510:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 21:13:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 21:13:40 +0000
To:     wenxiong <wenxiong@imap.linux.ibm.com>
Cc:     jejb@linux.ibm.com, wenxiong@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com
Subject: Re: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1v934yysg.fsf@ca-mkp.ca.oracle.com>
References: <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        <b73451e25a3f7881fb507500cb6bc0eae63f605b.camel@linux.ibm.com>
        <f754c31d348465f96ad4cd7541a86168@imap.linux.ibm.com>
Date:   Mon, 13 Sep 2021 17:13:37 -0400
In-Reply-To: <f754c31d348465f96ad4cd7541a86168@imap.linux.ibm.com>
        (wenxiong@imap.linux.ibm.com's message of "Mon, 13 Sep 2021 15:51:50
        -0500")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0010.namprd12.prod.outlook.com
 (2603:10b6:806:6f::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.7) by SA0PR12CA0010.namprd12.prod.outlook.com (2603:10b6:806:6f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 21:13:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a04271-a23c-496f-9ddf-08d976fb5bbf
X-MS-TrafficTypeDiagnostic: PH0PR10MB5578:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB557867695E8E32D6A678334A8ED99@PH0PR10MB5578.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSTfPerRqpJAax7+3dBVXyYsRxCkP3K3p16KbRGPF41mmWO7s58MKITTtVg13rFgAf02fMDDBPMTgEZqmCwWrp8fAqc1OAueaNZHzvOD1pBYeApzJtaUSHjAsvY3exMJVn2+L+1qpDiy+w2wGyzKiWSqojuluWLcfeNrVUGd6p/rbrJAk7WXVizO1diEsFOB55a3j8A8FF8Btq7Mxte6xpKKjQ5Cec3tC4qbP9ZmDIaU+SGPYIOFTC0t3M3pvYr5TwgIY7/mWXz8owuV0mWVT4aBH0fyGCrwhCbGUCP3vTF5ypwJD3oUKzHsspbT3hMjB80Oiuu0XK7pf375buiCsjhi2wamx+S0CjV8hg28T1kzAPkfDHMw2MmuRAnQhLW/Qs0wKfq/47fzpDzohkc9Yayt0mxEPxFDfNol8m0WuE/NZAOHLPcY5/V6m0QcLbGBRCekKcKmX8VFobcQGxEPBPK1BtNxIzsz8Yophr6GzeR5aIVyYE4C/ZOhokBFk+W84Wqj9kBRF7fBJcf6EKtK+vUiDobvGrJnyVIfzwJtn6jckaPvUpXIssfb3DCb/GHxuqquD0bVEzqLJo3D18nehERJU9dhZgJqmXy4KvultBuhYtXVcPX5xsR/02ojIGnbXC06dQ/NQp3B2hHs4n41yZaiyFRJQ/ql+27qEix9FQjwB68n/gzMAIHU2EbXc8bYfMxlYPuHoOJFQCusvCJf3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(366004)(136003)(346002)(6916009)(38350700002)(316002)(26005)(2906002)(478600001)(38100700002)(4744005)(5660300002)(4326008)(8676002)(52116002)(8936002)(186003)(36916002)(956004)(66476007)(66946007)(7696005)(66556008)(55016002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4rUOqAceKxcKpjIwSVjpNZyFM12/nUTboKFhN4dsjRiUSMgdS2dIsSXrfPZn?=
 =?us-ascii?Q?8V1UV+Uyllbrun19ki9MfetGiYgwprijxd072fGUSCaLj58laCScjieQn4st?=
 =?us-ascii?Q?/cDf/XkVr6FidUvKsFjgqkzhzl9q0bJtrLqWMIRQm7olDFPGXpagsxAhXA8P?=
 =?us-ascii?Q?y3MIor+PB+ZCs3sHaduTCCSgFHdgMPH9d54MT0N2vIJMM3rjVgt6OvH8CKXE?=
 =?us-ascii?Q?8jU0xGF7r62C3Jjp1pnVEW0PSh0Y1hslftsHp6b4lm3S7GHxYETLLa/P2m7/?=
 =?us-ascii?Q?6DmB6xkAFWJbh/gx+Sof+iEyt9Vw8pUMq+fhzhnwWExVamAGFvE+U4fCCdLo?=
 =?us-ascii?Q?1FFJ00NSdAR6FFrp3ze8gjlYaxck2gs/AMZCUsxzY4/BONXZ284mhm0Izbzz?=
 =?us-ascii?Q?0uy9jD2mpJ7fraj0xG19aR7vBcLJkQYDUSKfsy0ev6ly/rg1KmjueaYakK+2?=
 =?us-ascii?Q?3Zy76gnjvqN33/BTMTcIkqTWZZhljiJSqMCYGSh/Ea4aXmYbCJtuM6qNFKu7?=
 =?us-ascii?Q?VPVvp7uI9nbOEu5Dy/H3nthbvXw/3OJ3PgjxtIILyyFIrLuz1vozIwklRufR?=
 =?us-ascii?Q?wcqVNsTUeS8j0jJW4jHaSswgsj2atephdv63O9nLZ5Cuk8q7v8fDdOvCk44f?=
 =?us-ascii?Q?ieqPYdtwzbTO0IMxc01Ju4baFu+xVmWvmOmAhsVj2upNDLqL6ZRzz+Jy1Jp6?=
 =?us-ascii?Q?WOKvH9M6esNoY0Kake70u6H8xRbPgV7v7qMfCk9j8JlQaxhwwibofrDxUw1t?=
 =?us-ascii?Q?eLO4yWyZkHX2c5BYdvB+jMrB8NAkEMEj2mVsPgNOz8EaM4MuHKMsQyJOxbnb?=
 =?us-ascii?Q?1QuXzSYQ4nPrH2Z7oLqNqfWrZchEK5DB3krBkSOo0VWPKh6G2tgFAJi/8abs?=
 =?us-ascii?Q?qers5f8y/ASFkMFTO4g+FvcufK8lhOVPNbk0IFCzY9u1EP8ynSA2GUS1b9N9?=
 =?us-ascii?Q?7chM1FExJfgvrbAq9xBQV3HWrkone+aQx67Qxi9EqJBjZmmSK9JHwGj3FnYD?=
 =?us-ascii?Q?mW5LRk4wt/psWqu0Sx2CX8RkTaX7j/brW43BLlVspup496MhwL+EPK9DSivL?=
 =?us-ascii?Q?oNCiXbrJZCiHWZLeBOwc/YvMpIb/28m1RikyQ/U6/o/LQv1etAiln9Kf0QgM?=
 =?us-ascii?Q?t70LrV7s8n1xk14VF9DvXMf5MHb8ksPP5c6tscSADJD5/2gKGpnk3R91YGFv?=
 =?us-ascii?Q?JSKPAg3EdSWZ0Ytno1ScilppLuFEnxX+/OqQEaXPFX9kceyTd9D2hNvj7KAi?=
 =?us-ascii?Q?DAjWsRj5366z2SwId1PvFCkq2ciY68w2dUeWXV/V6qD4vC4YPZlR5MNPDNfp?=
 =?us-ascii?Q?bZgqzD43vJhtDXYiqQCz9UhK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a04271-a23c-496f-9ddf-08d976fb5bbf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 21:13:39.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TzBJEcngKmjIPIwcAAWacBb5NoA0rJMfduECVgD/bbhuxosEI+0vVRkf5F7lWxH2nBGKvY8m3ZmIhp2JMIJVFq544UdCt7jNIT0tNjQLW+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5578
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130126
X-Proofpoint-ORIG-GUID: r1S5IyNNzk6OwU4f-s8vhQbT2z1g70oj
X-Proofpoint-GUID: r1S5IyNNzk6OwU4f-s8vhQbT2z1g70oj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Wendy!

> I am going to re-do V2 patch with retries. Is it ok?

We probably do not want to blindly retry on all errors. We should only
retry in cases where the command has the potential to subsequently
succeed. Hence the request to retry "transient errors" in my previous
mail.

Classifying which errors should result in a retry is the important
piece. And for that we need to know exactly what error your tray is
returning.

I also suggest you have a look at scsi_check_sense().

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
