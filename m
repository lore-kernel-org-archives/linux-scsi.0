Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22E3C25B48
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 02:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjJYCZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 22:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjJYCZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 22:25:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473D9C
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 19:25:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OLUQRU019739;
        Wed, 25 Oct 2023 02:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=lk0Y4KWM6DA8gx6j370KPbOB6cdbBE2EZZ1hjHnX4MI=;
 b=JEoMst+5mYzpwfvCt4e8z2OM3iLy14oHQ09hgFOKNFjlqSTirFLZMORZQF7NJCz+FBKG
 bL8PWLUqn2FZCIWrdJPYIiTN+Ic5n3ZzvIKcnbmaSQYrg8p3LdqDuNjaWaiBtY9jbzjb
 QXzd+SOsxXVjJSG3hjAzXp9F84ftTFx7O7Y6LFjqyxHCV+vHgVfe/Fj20xHkxjN3ieO+
 XKQI4nGscbc57Wy3IV8totmY00Y4T0aYEvZZokn+1AIFJo5GGi2niHVdtlcaS1EpiE3I
 Rznqpz6ldbl22WauMJuiBKWEuPtH5+JbhJuW9sYpP79ov9JJeWVJumQySwhX5QJ9gCgK VQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68teq04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:25:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39P1C7UC031065;
        Wed, 25 Oct 2023 02:25:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53cj6q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:25:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtn0Dah+3raaJ4R6oTrPFkCW24+H1YeIFLB3JqjZ96tdrMGWYdymC5r5xgnwFxkPj/fT08/qOHLBreDrY8+tRtyp82t2O4lbaI/t9GqIDKyERtZkr/ke/ANZ3TTfE6Yh9VjVkXxXrOkfswxfqTmt4U7aT5xbqtfjDzMosYrRZScnf/vKB26tVIFhW08OfMFXH+8ODPNwpSp/U634BQqkB5jJdBq6tF4Voimp9bd64pPn8t27DUEHeuq9eTVyhHNvaEWn2y3Vbcvy6gJMI8zDYyBHj9Cdc+fj7Ug6TPDTnn5GH5dXGI+1ZEHg+ttgZZnx9GoG1mrT2IbV01pGwHS+yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lk0Y4KWM6DA8gx6j370KPbOB6cdbBE2EZZ1hjHnX4MI=;
 b=mg49K5I1cFTs7Ct6cTwlTUSoJgM+wR+kbMfHabuuHw65e8j7t4Dk1Z0kd8Nuu2syoeQzqXWwO8KQKxLlW8vtqpDjvm8+/+V3WZwIc317bVajZOAe6fzl6RX+KoLgeZU2hc8ROECzX4Cxdzz5ivPvlACNy5VmHwxLQjXn4ktWlNC8cuk/JE6RUlHEb9eIwsynqCUVa3u4D3pwZWA3U6I1XokamOWNYJPy5xRfOQbaSt13SOc/e+R53c27nGFHDqECgdPdPhDB7Tzc4qrzRxlmdRlmtt5FpPBTWViRzydLXWbIqwaFUNfeTxV8EjnQZ3rtuSRPV27eL+mTHqMI2DstQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lk0Y4KWM6DA8gx6j370KPbOB6cdbBE2EZZ1hjHnX4MI=;
 b=KpKktpi7TOMBcUB8XB+cxnv+NAceo60yPXxIlo7UCknS5tRPU/75is38dArGquudwGvKkKNBkJJy70crP3KzdBBrq25Sz9oXJTYjtzfJtr6myMV+5EkhMdCZWUSV1oajokB/fEfkBV3ymFlyuzBtyGimJzOPhCn6cwR0XHiJ97o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6233.namprd10.prod.outlook.com (2603:10b6:208:38c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 02:24:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20%3]) with mapi id 15.20.6907.025; Wed, 25 Oct 2023
 02:24:59 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] pmcraid: add missing scsi_device_put() in
 pmcraid_eh_target_reset_handler()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmvbe8we.fsf@ca-mkp.ca.oracle.com>
References: <20231023072957.20191-1-hare@suse.de>
Date:   Tue, 24 Oct 2023 22:24:55 -0400
In-Reply-To: <20231023072957.20191-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 23 Oct 2023 09:29:57 +0200")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0196.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 3215aa47-da77-4540-f0d5-08dbd5019655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySZ8bqdLagUexlsOGWJnvKAL8DXvd6LirHgf4wrWwO19gmewM1/KpV84apBXHdC+32bQrvdvPB3laIZkJTXXSZ/J1rj6p92mDnQbyuKTt0HSWACsw0U3TJOWjoeLmKrdAJEZ7g1L3xq7ErP54Eu3HfKw1crn/GNrHwWkd1nD03PazLvrzZ/lmYNIjb0/HNgT9MSTP4KmTxzzh+bWvj0VpzxbYZcu3Pn6Lxx6ux8pacal8K5NGaSO4eJr5HJidwhdz5EKRz4xNHO5dlRWdJKVtVsqz7iA+UpPudeLe6hb4Q9vxGsUeahAQMm4o+zIKRQdZYmVOW77xahJhOSNU+bfdTbUPw99xATW9CY3qhPRF7v8nNKHMTc2TKG8/mQwaikW72CgdhvrG2pPN0BuWaZ0vM4c9Yy8OZr3S67wiDLMYVZ7uZkkzidVDrm1lGGoDPL25f/Il8hzbiLoBirFXKJO4ZzyPjbLF++ulERR7VWQbHyD+e8McfLApcAHVyR3qIraATyttFexKPrXbKRrSF9uZDjsYzshQaP3g1Lt3zgNYLAxDJsC0GUyGZQdHbn6UVn7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(39860400002)(376002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(5660300002)(6666004)(66556008)(41300700001)(86362001)(66946007)(66476007)(478600001)(316002)(6916009)(6506007)(54906003)(6512007)(6486002)(36916002)(4326008)(2906002)(38100700002)(8936002)(8676002)(558084003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/t6xq4PjU2pewYOIaaGI5aVLV3igYN/saMeiurFYBbdpD68dPsIFRkXUOIc?=
 =?us-ascii?Q?3r+qWKi5CnsK9rtqKp+Tjar0HtuNx2hU5KFZQOPML0zdDstV+MuctaNrNESr?=
 =?us-ascii?Q?v7Sd/lsYUamhXXi0b2/oMAzOJ/WOhyRyWRTll/zKBkLSGvJS1+KmKS284rNP?=
 =?us-ascii?Q?rju6SSwXC2UMupsaRbXwkLn0xYEINj9uvrt0Hr5ZeLjPkmM8n++6D1h4+u0x?=
 =?us-ascii?Q?kjfPPSXfOtKn9JAwtmoNAOmR13ySjMXybhhemFHFvyF27dkLbymCPbtpoZ2X?=
 =?us-ascii?Q?kXXpbNiO5taNYwCpPu5XgXGmbI5M4q9miVje0MXeFbA6I9GgfTGQeBEoUC6P?=
 =?us-ascii?Q?8X9bQL/uSC3qe1F91iHg0ZymjKuM1nOT/VgjCDRUrUGLpbwqJwUoZmhnYaBy?=
 =?us-ascii?Q?Y93xA9jdW2dImimXhiIaiEa68gKo5tpRQWyNpZpV2LgYI38GICoGQ0IZ/meN?=
 =?us-ascii?Q?nkbPVCIj/wVOPc6VbMeA3dE4StVu5gZ+pk1nmJn38kGdq1V1vJIGmjhdn3cu?=
 =?us-ascii?Q?BKVioq1lWYv8nCQ+w7kXa0+Naj8co0NX8Ouip7E7Mq4z6IiFrWTZpb3Lexbc?=
 =?us-ascii?Q?BlGBN8TnjW12QMyYTaXx8LkRN/76tWkNvXNCb1gRhmGsVKIHVlo9T5+tl51o?=
 =?us-ascii?Q?LA8CRYOvNAiBQNA/NfBUxdqSgsQh7qqfM7nxC/UQtueIwDEGgXlKmy5Ymm+L?=
 =?us-ascii?Q?1OcCDqQvVm6rRpQDqn5VDn+jZhSNQNt5FRalh1qX9CVaqaAFMev3W6I+JwEb?=
 =?us-ascii?Q?9qTlgbkLdtLBk7SVkh/mW23ti+No/L9S7Y38X76p69jzqPFlDSw18HhgRWFB?=
 =?us-ascii?Q?rDmji8l31oHTI3J2a9lKXRsJAKI0sH4ZsZxWRzZpanQ2mrNElNYwfjgyPTSM?=
 =?us-ascii?Q?JH+GpdIaPfUWCA6RuxI40+ZmdvfatPXvXW70AuAmNKg8ZNskliCNJO0GM/Bj?=
 =?us-ascii?Q?ZOP4qCeeGsxBbD+TUejkMhsTnPEwuTLvsp0PesU1iMfoSHG/4W3k/kzomXAe?=
 =?us-ascii?Q?4fZvBAy8sTbd3NnlL4pBm1Km2NRV2XSVB+bDQxB3OsYG2/lnf4HoHrKa4HWu?=
 =?us-ascii?Q?a6giLWdhk6A6z4YiF1QroxdamAKyrlSi2lgfTKr+Xtfk1ulrS04T00cu0Bvh?=
 =?us-ascii?Q?5l0iuI4KopIfpjuoTLjDrVhhfdEaP43A5wxEkb516puYXJzFi1l25TXOBOSm?=
 =?us-ascii?Q?2wR7migG5HjM6JK7wgoINYNBZ/Em8byTC4inOTQjCC/jjyIS71SW1NKOX9YB?=
 =?us-ascii?Q?CC5XWk7dvI3urR5AbhMss9wNbagDKJGiIK1DfDobjSsq7vdwX5UxkhDMZwp8?=
 =?us-ascii?Q?ugAzd4bDfjqN7MsngEFN+uyM2Ou+4Ds90INu6jwyiAIxd/jt7yFE5J0cw5ZV?=
 =?us-ascii?Q?gW7AA8ottSkkgzR1qy6UgpMD99lGkPXnoYMtOPVI4wOV8GVPiLq4fAkAz1vp?=
 =?us-ascii?Q?Z5qfBzer5GehZPYXzh2MyeSN0HGXPEiGV0erwGtWFnU8oWrXtU8WZQYB+h/c?=
 =?us-ascii?Q?zZ3ZFVEPo8Cdwfg5pqnQefdObIhrYRLYJOkgbmC/L8Qi6YIVcSiAPfYsN5bl?=
 =?us-ascii?Q?mdk/iUPqikCf9dOv2Wf8K0uUtvQRacODuj2ZTNHW/TNoX+NlOHWiwXWk/Cm2?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gRdp1UFNvMozx2eIUTnHUumhY+0hV3i7KjSOAo+tmfQjxD8q6aJRxYD1793e+MoaPgOUzROoKGt+APfgCIQS3eA+cOkwxEmE5J0Ob4p9z36I/h5y/IBIpVyglxvc+fVz1CnFy7VD6IE26BACOMTHgfGgK4jw9JAVP3d05q5HwPB7dGnw0WftP4FT9PeKgF8kT627c2zM5q1IwJWRUMI/aCZxwtLkMiCTcsflEQAGvOLlB8C+DXWHzlXWRKloF/zIOS6IA0ukKBI0eJBPuSwLsmiKraw7huWi7THLB6EafxG1BXOBs69uoH5xWmHWSQ+BHQh6AhN92pWccvybmEd2EAqUBi5mCZAlU1aPttSu6baybLhDWYq5oEvIMOtlt92Am5zp4vCRzKvHQ0vjUcbZZOUJFUFGXbnS9ySTMbYoWgK0wOiXRBwjG2HqJVmvJ9zIlzsGnLXw5CKgt3RoJ98GS87/Yumwt54yVEqdVK0uwxd6XkTaNMyeoO6ItPk66gq9o1w43SEPejU3gbnKMSp5ZM9t0uaui2sAcGAQ6q+xQtPWAwOHR+EkX2VlPAQik9Z0H2A6aKBRtQjnxqVvNN+tZfEU5ylMQ/IrZV21CxHzL87OMeXkjIAib5KFUIoW9RmOBXDSnbv767V7SE6WXT/Zn16srXMEalY2a/MytxZomssIm33Gt0DqFplFp4QCVygiJfDMOzrIK14dp+Vj9+6zqhemDCUDy3VhiCds7/tjkqfbNc4a0F58VUXLh3o/hixb5XYv4FmjYS87iknarg25HPo45Eo6bqFtiNmPHWeIRhK0gdtPHNAlUT8Tgjsb8Mo36r1Eo0ad4SgjFDZo3153SshAE8S3a18PfCHTcET4c18=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3215aa47-da77-4540-f0d5-08dbd5019655
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 02:24:59.8421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdKvFAamSIm4jX2ZA7SYB4fiIRR4hVL2642eVirsPIRqCE3oEfahqILDEcpP0ljIn9o3BoIWyvqjbmALG+SQKhiuQu28lOLEQvEzapxIYMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6233
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=840 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250019
X-Proofpoint-ORIG-GUID: WG0F3kEP_2cb75_fHnQZAPL4IreqRYl1
X-Proofpoint-GUID: WG0F3kEP_2cb75_fHnQZAPL4IreqRYl1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> When breaking out of a shost_for_each_device() loop one need to do an
> explicit scsi_device_put().

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
