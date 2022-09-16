Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86EAECAAD3
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 02:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIPC1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 22:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIPC1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 22:27:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BFE78BC4
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 19:27:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28G1wx5h029399;
        Fri, 16 Sep 2022 02:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=l/De43TaGA4LDumf8w6qPZ79hOqDoYn/k3lC4XBA8cY=;
 b=V2TQ9uyypGBDVzM7xiMdd4pfsxpleCyTP4vJSMBArgODl9+tsmJt0waQRpmE2DDRS/6k
 2rIuRx2TH3jco8adrEqHkju+kjvdWOHyUc6A3W2E22fQl4US5vVpGfG9gcrYRoW1J1fW
 w4qBvGzamOD3Jp/C3y5GbEPKylOn1p8PYl7gLE9TdrrHHFI1+iTv2cedRBSdzDUJhpkB
 4JAF6ka2j8j5MXzVVzdNddODpcbrRv/Mff7iPFk8lM2isBIqHWtbNk8ASQcgJf8o/92t
 mMwezeQuk/K5XU8l0TcVYrV1BjwOyWq4WY59EWa+D7YUZhXx2lxI2VVcYpgrWLz9buq9 hA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8xc95de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 02:27:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G0oGBO016171;
        Fri, 16 Sep 2022 02:27:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8x8nysr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 02:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxTHjdt+Ug3dXrSA+j5j1U1t35jRgdkXp0OB+gUiq5kowSKK/HALRVkdk2oRVMbNLTTK9hZ8yFf+nDhxsW6tsT6Ci9U/y5OFwqvkTTRhhhkQzDvxZSQUXBIDetqSofzJmNVfWsOhOgXk0so789BaljvWHiwHBhUbj6vkFK6Hr1FkYFr5+WVylQei9j+gPUE9sy6IyxHhHrH05n1Gwvqq2F40SIbVsQf8K2wz5CsNxQTyZ/79uopbZLI94zACK++ixDxmcWXHdFbSpdHVChSG0dCf7kE0BveJBvZWeMN83rUDq38Bx8fzGizyjAP6FNOQ5svPEw/o2ymbY3UtaKc47Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/De43TaGA4LDumf8w6qPZ79hOqDoYn/k3lC4XBA8cY=;
 b=DHxAeLfG09XOx1FReM1D8hjFa7wIag1fnfWpyw326dczklFu6uYG/j5OozXdQb8maCW6wztGepUZ60DDdNaCnIqe4FM40KC6w7t8LsszWdebDM8bJnVxVLdE2hNDXvBCegpAiMNMICLb1NnPtNOV5Yh1P+wCqTzkxaHuLtM1/58O3z1jsHuJSLjj+yf3IiUWggQiIxWF968fZ227NfcHa0XsxzA2ykZvHG6AW6aXRHdooSncewi9ob9dqPofmvzwDh1Pn3shpr744P1buR2cH8XGSXCSbx6hvp+50iWbs4lnYsf9bh8sZcZy/8RaBVkPIs9XwjR2mvsOQ0SwBQjNjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/De43TaGA4LDumf8w6qPZ79hOqDoYn/k3lC4XBA8cY=;
 b=OpBGFzC4SBMFHw7AKi6BDaPFgBE2rEln55+sdZB62tQCBXub17dyImx7DhfoDK50edIgBos+keAsVwWAj+WIgVEEdKF9no2KQY16P/g6A3N/m11SPSAwvMt/2scz6JlE80hK8xvTut5qulEOEuatAayF+4ccAcuX2IqT2pY4VK0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6255.namprd10.prod.outlook.com (2603:10b6:8:8e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 02:27:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 02:27:46 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/13] lpfc: Update lpfc to revision 14.2.0.7
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8po12ax.fsf@ca-mkp.ca.oracle.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
Date:   Thu, 15 Sep 2022 22:27:42 -0400
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com> (James Smart's
        message of "Sun, 11 Sep 2022 15:14:52 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:5:335::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB6255:EE_
X-MS-Office365-Filtering-Correlation-Id: 349585e3-3a29-46ca-c1ac-08da978b0a8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01+NPcOuCnDa9yhDKdRHctbaGJx3qgJrj0vvas2tU7co7lxkVqz+1HFhlOje1LBP1Md3gO4e7JTUOxe37VeUiyIzMmrYTc3xbVhRKDEeF4oh1OcYwBVUkyNSGVmBjPyECToFrsjLFBKmS83FXKZE0ilvvlWWc4uGnAg9+z/P7HqJ2qlvhVVVu5m2NQZR3gu8EytY90mqD3zn4mGKBQ2yyxm1QZ2hz4Ki1Fh07er3omfJ6Om5mh4GxGqTEd0rcuXu7KZH6iF/DrLfm9V8TWWJ/OAdboAPs4tNrnDNHkV0V3plOusAiasImBj6gzSzjKFGwnQsj5MvssOuRbFMjzrzSDFAPLDGcn2aespzHWeQt00cGc+4I9qnKXHH0jn6+n1/RkUJRwzCY1M7y0toeKGA3Sqv+TdXDWEZdlKEhGpL8F8GyxkLvHcWXOKDPofODe0P1O9+VBRX4rV7CPi4PWnjU1tAcC8XjkCauMIMw//Nq8twLP3V9AWPxsVS6G2vX5bGnOPPVM0nB7wBgqVB5STUV1Iy6MdHR/KpU9x6Xs8XEKfP1/7+I/f42hcoI7pkkULaiOPs5/ksTePzKwi6iGu7T7iBAlUJHZdML84df++jn3ABq0f5b9Vbj2cyO8+9ubiKvfmAPiq2oTINMD4k0k4Hd/+Zo34P+rIWFPkY03dzT1IZus1e8sH6FGXWwWPnBgfr43XEyu7C+PSVukciNLq2yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(478600001)(316002)(6916009)(6486002)(6506007)(2906002)(5660300002)(26005)(15650500001)(6666004)(41300700001)(6512007)(38100700002)(8936002)(186003)(8676002)(66946007)(66556008)(66476007)(36916002)(83380400001)(4326008)(558084003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I8HvIPk/uzjSMQhuzvrxhMjhFzKNoZHSr2CD0jB1BhVU3O8RV8Kh0IO5iipf?=
 =?us-ascii?Q?/W6C/oI1feFUrhb9nzX2EUeS+zj6fxvS06M9GHP3CLPJJa0pKKgladH7IhMe?=
 =?us-ascii?Q?zSW7LFDn2NcSYgOPPslO1AV3PEEhPdSQnFE/rqLFCVqDaZuV8pDUbhZd+H7f?=
 =?us-ascii?Q?d4z9qWt2eSMAkCwSQGxBP8KLA3otOiY4YRw3umOCw7Iulnnc6J2tlE9/Rtbm?=
 =?us-ascii?Q?8EO+MZvoG27JI8njD/axwOu6UkrYzx24YujKDuJcKR7OY+1edFAtD4YQo6I8?=
 =?us-ascii?Q?q1zg6uvoZH0+ZK51qEZ/l658dhxX1jQvk0E0sgGHb0sV9JKBbwYG4Zu5+7q9?=
 =?us-ascii?Q?jhzifF+xC/z3PTPT2UdaFRSO+t4vsIUAvsP323+5+GWaD0yWOdv19TcBPuA8?=
 =?us-ascii?Q?kB9ubv9nyoXzoIEysg/WE3cC3aEh1bT2HJ4z+KKqrGYrKSiXkvKRWWud1V6Z?=
 =?us-ascii?Q?2ERQHGpUFNy/v7TS4To/XDaVG5AlXnNnXD1w80oo4a8A2U08MSbj7ZxNgWFe?=
 =?us-ascii?Q?YNTbOV8tbvAS4+HE0gX5Tvck6jDB45X4FZUVzTmKWuI0T3/NU4Rx75iIzTWz?=
 =?us-ascii?Q?YygBkijTVl0mrPPbFaT3uIBL9fCcmihc+xlrVsQByUWcDU0jorAm+onPjBBO?=
 =?us-ascii?Q?juSWOW0USLthsQoGli4OWUNkl+Hs16OhdYWEZaDsuxOVs0KbS+9RtfhAcdYL?=
 =?us-ascii?Q?l6rewh7+jaxjNG8A+wv1MsdIaEpA2zttHVQhNQt18DM15eOr7DGEjMOtn6i0?=
 =?us-ascii?Q?MSkR5PsoVHBQF9fe2rvU3Rio0K+xrZGjGyrc48R4FAAmlRQGjE7UbH594bXz?=
 =?us-ascii?Q?7LHxsauTYlYmJYVwPRzSj4UU/k1fiYBBljVxcySZ7HrMdwNvO/sgyr/TZ207?=
 =?us-ascii?Q?zQu9yN/RPCQRtjq98rmStxyZ8n/6kWeNfrjHGoB4mLONbY1SMCv9XGopLuqN?=
 =?us-ascii?Q?3OE0gDkCgDRzQuhXe3FiJ5WyK0tftaJiHvDnEKHQa7WMgYYeDIMsD4grkwBU?=
 =?us-ascii?Q?wEzqP0ID8JoC/3Pq4rzBdtBMEh6W+ofL0WriAKXTbqshYFcozESA53Qt5c7m?=
 =?us-ascii?Q?dV9/01oIf0oyzFsYAmZEOO0Qh8g5HHcCgmXneknfWjnrJQwZo0n0rI0nkgGL?=
 =?us-ascii?Q?4ohHD4n8e5tL9l7oz4xJOaDBLMVsEGJxLgI45u/gOxbu4YuQqWarnm00iTMv?=
 =?us-ascii?Q?VUgqE+CqH4VS19AtAm8nmSqwr4W3Bec3e2QmCwuixPA5pR/zmoEUwGNDpYp1?=
 =?us-ascii?Q?IFa1+4laomPB7CG8NzeeA00a2KPclk4gERhv3zSpnVZm8IeFpiFcI3T6qR1K?=
 =?us-ascii?Q?jSvO8anGCh16v2a21SWJJv4S4ctYzR2xHafJFP4w/lDjtsAx3v7ENIH59X9Q?=
 =?us-ascii?Q?zeURUcG3XQVAQwx4I2N729nmX3vWe14lJ8FdtVR2BucSj7sA4a4hMDxIFbrn?=
 =?us-ascii?Q?C3UMn0Pe9aSfdFSXGH+rSgkilKGy1iRFxEKM92VVz8Cs0LaymTt2j9ORg9Qd?=
 =?us-ascii?Q?SO68f1Jqp+hE0WzfeOrfTqjEsNktaYKgPn1fsVAu7c17P9sXbZxg+YyfPtuT?=
 =?us-ascii?Q?wYywkHayQ/AB1wp0i70q6TMPl1hvSLW9wUPEFDOJzwFDBmsSKdt8IGGdyIn6?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 349585e3-3a29-46ca-c1ac-08da978b0a8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 02:27:46.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOEE0J93h94ugRFMOQLy+6ellhhMrji0Z53jlhXEbuWrdVFFVPDW0DzpiuXoZLnuP+gjB16GI7RNwoUa+9zJ35YdcWzgerPukX+LPb5fW6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=758 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209160016
X-Proofpoint-ORIG-GUID: S_aTl6aQyGqO5mag4TBP-zMOsWQcMeuG
X-Proofpoint-GUID: S_aTl6aQyGqO5mag4TBP-zMOsWQcMeuG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.7

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
