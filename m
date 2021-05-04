Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550D0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1CC61283
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhEDC5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 22:57:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhEDC5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 22:57:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1442tD3G098512;
        Tue, 4 May 2021 02:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=galAmgIzb2D78cm6ZPkcD7+N7j6Z8w3zY6QM+mMts/Q=;
 b=HoUI3CamZohEPDmPSv3LELVvk9ZgY2f0RbMWmhP4scYE9aAuTZPK4PaduaLQXGeuOdhL
 D4Svr/Yk3QPeBgzE9+WvmsbbYM8gM3UMIhjbuphOc9CVxexuchn6wXRPcXXC374lGKb6
 1OGvl7KWAF3U7WlSj57ggcgIDWlTXCM3c6OK/thUWJpVVlwtS5Hg2e3+N7lBUG3A9AOh
 XXxluVk8UdiURsehxrSq5hyovBDjLat2Btt3XBk4cgnYB3OPswElU6i6dbRJpXyx14s+
 ebzqtVaBojHYm6QJzm6psD0UvOvvv7fKJpLwBG4fFCr4GqUWhZQ8TiVKwJTJ9U81l3Kr OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 388xxmwfdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 02:56:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1442tCGo161779;
        Tue, 4 May 2021 02:56:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 388v3vrfuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 02:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrM9TPCwkb0TbM+PUvMQOKtwILt65LhbPOunpQNbmP6T7J2nkQx0AbSflfQHM0do9gWBy6yEB7+O6st0CaDy95MEO+iZ7D1W9QbDLR242TFC2R4OWqK0ZvdXtK6Q/VWrp9Swyn4C3cv2BO22kv+X8Js40JKTzklNpScHl9cTPu7UZK+pzRee8RXq3DJrIfIxaUiX82iTtp6VsXgdJKTErHHwDUWwkL8Ft7QLhsoaMili9au/mDz+33RyQtSxLVVCDQybrZhTv6u181HwSbB6Lm/6LkjcfYc1bUvrO7htsKLWH6burusyYKlTcDTPsdjs0Y5vBA25WhD2o7UiErhEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=galAmgIzb2D78cm6ZPkcD7+N7j6Z8w3zY6QM+mMts/Q=;
 b=b00RW6Qkf8kfI0/bQK5UlDDtFLbtFGcmoJGZzpY8t+6fCkqeeRkdQM4fukKL7PJsknDL+CW7i8n++sym1arwbtzNRee11x7K//YnAEsW45kYrfpPx8XyDOJI9mWln/vR3qhYPa7htJmLnwr3zkKwv/JXglbL5h7R3TiCC7IBk6/msGGOrqTHzJLh963jIYRTDGgCXL4K26YiDY6MWvkl0k8FKbd+4m8ANown1f6ATHe4EbtYMVIDROlK1kVlyRko8OLDiVbaufq1y094B7c7rvubzpoA+vB2JWoT+GMBng2feOZlCQWvDDGFGKQr2MMW1PVr+q2VeLDFmeZjrG4Kmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=galAmgIzb2D78cm6ZPkcD7+N7j6Z8w3zY6QM+mMts/Q=;
 b=hMHw2VqqUnl/QvYppduQs/VdfwSttCGchwXs6o40FjcAtybM+Vdwni8WRlFE9KAZY8zNCT9scs6rYmmerXjAfMRMgYPJ51rHVZWoml3GE7T7f6zyqijA+dVwUYSJVV9oP/1wTjELG4In/yMqAJDi0hz6nOc+SAqBfjD7dyIGdwU=
Authentication-Results: embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Tue, 4 May
 2021 02:56:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 02:56:16 +0000
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dkfky0x.fsf@ca-mkp.ca.oracle.com>
References: <20210421185611.GA105224@embeddedor>
        <d26823dd-5248-4965-cc30-f9e6294536ee@embeddedor.com>
Date:   Mon, 03 May 2021 22:56:13 -0400
In-Reply-To: <d26823dd-5248-4965-cc30-f9e6294536ee@embeddedor.com> (Gustavo
        A. R. Silva's message of "Mon, 3 May 2021 19:19:25 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0085.namprd12.prod.outlook.com
 (2603:10b6:802:21::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0085.namprd12.prod.outlook.com (2603:10b6:802:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 4 May 2021 02:56:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 476b16b8-7fd1-4f49-1126-08d90ea82f3f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696C893F3E7B47E20CE01D58E5A9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76Ib0tCalqToucTlMQtv4G/rpTlVn8ftRKAbk4ctXlVBrUb/ae2UT14jAZYpia2fkBCchV/rmgZlNKDA85/gTqo0v7cw44i8h6ymndTYU8l0wFDauVEQ6KKIq1fTRaHCmhNsGKRK257evaUpTiV1eRI+bPTDFMznnRKGiyPYDbdX4ZcvGEZzhHHsLRlyxK9CqAsu8G9qNTgV9RBg6kxIy+qRtt7SL7Aud8/Ngwfw3LwVpGcTJGXspP1cZb7CUURuimNGlvZmLgjxx2CX5Q8AsBy9FT8W0aEIr12dNSXolKWhLrPtLNCfmtX/x/mSgYBnfC77N26tru6ij1pU5EyjbZnnljFoMStpHETYQ59ax1cJ9tPFSgGjH6aix87zo3mZNwz4desvx2MMjzQYb/NeaKA31uFsmf8xSs/V/xuWuyR0wiwXd2Bd48XShntlsC/qhnUAolo/+y2X79FRRyeQIFg8pJzUGUUVDppkMDLjONnyAViQvluveH8Isge6uTp4Xi+bSkRHqb/5fk7LHmnRB1RqVGI/OJDW34+ydirME7IkdGdi3Z69/5VF5yiFDcWNErO42GWh/UMnXCqvSK8wxvfhPLudcMJ9np4tKSrfy2mEmf0dJQ5Pcz4tUeS+vsrBKMcWszV5lIdouBNqWgsj9nLao5DDEQ901CY7CNikqFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39860400002)(396003)(16526019)(186003)(956004)(7696005)(2906002)(86362001)(8676002)(4326008)(26005)(55016002)(316002)(478600001)(54906003)(66946007)(38100700002)(38350700002)(6916009)(558084003)(8936002)(5660300002)(66476007)(66556008)(52116002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gVLlILLCA5Y5CVbsoUzN1tMYWXjQBgwdIDiLIUavd1Y2qTJtFC5ReweJJcw9?=
 =?us-ascii?Q?VOsif3CuTzyWnT7CTXN5GOa+dUQDj9xkAIRCP+l8VR3KOgQRLLvJOl2n5lX3?=
 =?us-ascii?Q?1/pPTi3WglHy8fhiVpGGgty7daHS0/QQgli7Fonrn3PPancQ3jpTj1dC43tx?=
 =?us-ascii?Q?MCatG3KnTcHCpbpBzO4aPuJ5cieJtAJZdzlquYjL8AG6+MG070RH8+Xyt+P7?=
 =?us-ascii?Q?TzB9BiO4zuyF2LJLp8h46NJq9MYJEI1K9VvC+hktWNCb41C3wJBdaFMY4i5L?=
 =?us-ascii?Q?LVRRvi3gbfLf7MuYzfp9SkYwOohxgR/RtOID7WJp8QS6/dSIp+71GJYXI1oQ?=
 =?us-ascii?Q?uV2PRW2rNYbyvD4/kw96RZnSYCSan9O8JPAi5smp1Gd+gNdCUsSJ3x3s4AOz?=
 =?us-ascii?Q?a3IfFtOhqAXaOF3HFKX1K8Kkfo684aUObmcKILWioIJ3bftauzCIQ5B65X+h?=
 =?us-ascii?Q?J7XMZg9PzjUoRPu6O7mfMTKX3DoqN9OKZTb2BVh5vnZ1bsD9Psn9kQQgo1Bi?=
 =?us-ascii?Q?MDXrczn1WFz6wKFsoa5AkBg88R0G9s97SNtlcVG3c0GEBXpjtyXhhEiISQBI?=
 =?us-ascii?Q?D04YLbUPNQT0QnHjXNTvhSlsm3LcduDCH/mgsPb7/DywCAxGeUrJQEUNVAj2?=
 =?us-ascii?Q?kxOQ6NwjHWbL5g1kyoYv7Wc8mFOVNjFQUK1DhrsFWQfMu8/YbICrzaqQMGA0?=
 =?us-ascii?Q?kdueFoWxC9z/tYnr8H85Sd/K4uYHYETfCWGzFC9iXN4LQVAdaNQ6MjPDxCxs?=
 =?us-ascii?Q?LNI+NzKC1JoILs4B5fP4enPH+6uwBQzTpOaQFGrTY0F6uWbnYk78hQSM7GLY?=
 =?us-ascii?Q?/93himoOk2Ivf+29fbJjnUxQ5iP8mxYnDoZ4zbq7aGl+ch3Xn1B118dgqFDJ?=
 =?us-ascii?Q?meOaBq8JZwtMF1bGCXA7VPYhVCZbTviF/vqerhtygFBuqLdkmtVUHWW52wmz?=
 =?us-ascii?Q?GyXcukHaa9JeRyFsqCZHCENAiby/aDJem3KvTr4wUjlO8KHbHRLKm0SgZMep?=
 =?us-ascii?Q?Go89IpJH4Pk0xV0nnhk+8S2xKYvVDKMazAKWhCFWmMAz+oRcrzxv30h4KhV0?=
 =?us-ascii?Q?m7ha+IQ/ttJiIVFbmr23lzMa8nA0gb/lX94iGlGrBhzJRvwZwtQmryE5T23N?=
 =?us-ascii?Q?wHaVlMhtLbMx1iGenqEAwUXwdThCM/FKaabcFFEOYDSlYvle2/1uRsjfaxG+?=
 =?us-ascii?Q?hG8DpUVZu6hp4Q+HE9umtWgri4xywVHywZe5wkY3r8DeRJINkkd6nKuxkOe3?=
 =?us-ascii?Q?QJYz+OBl0sUp6mm5ylf1ysIKM/mtDG6iu7x+jtGMQOHrnKWCDL7RC8yTPVt+?=
 =?us-ascii?Q?2PV3HiOwt4hg+ZXBpeYzKM/b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476b16b8-7fd1-4f49-1126-08d90ea82f3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 02:56:16.0458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnKoD6hNElI+fNv6A+Ow/alITbzvEEijfSBG8lcDyVe91VsXeKzkskTy39+OVhI2nxO2ahzJ9cs6zv9lnMtlLkhgrRKHojCEsGSnEas9jxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9973 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=683
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105040021
X-Proofpoint-GUID: 3zsNHXhdkm2_SbsLJGOpwP96KEsnIixC
X-Proofpoint-ORIG-GUID: 3zsNHXhdkm2_SbsLJGOpwP96KEsnIixC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9973 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=877 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> Friendly ping: could you take this patch, please? :)

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
