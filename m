Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E88C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB1D860F9D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhJZS3u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 14:29:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38536 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236884AbhJZS3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 14:29:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QIR4Uj007135;
        Tue, 26 Oct 2021 18:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LALc05jRM2IapvGxZBdqHvJzLEu0mnMnwIysDMsgKi4=;
 b=lqfezGPLBGW0KPLX17+2MHjGb9tL0Gr9hw/hICi12eHVgC85XPydNWLdsi/r+0VBidpZ
 OezFk+x7INjTmYJAVAHESJ1or0Zu5+hP++RF57lzcVTwGFNnxSAeoPBeDPPo3KVTAZt/
 3uJ2aPUxbVbwkUPKDJY5CBd+rR8U6Uk+VhI0DfQz5VqfAQw6oVO8+uVRWZrgelZaCS9/
 +U3BtJKK095oco5XAdZx4SMecg6o6JxKN+tUzTjw9WHkJDWKm71v79lObUqyzE9KEK6M
 oGhO2H+V5Dl+hnbB5HXk0AzwygON/+VOVymP6PiZT5h5evvk3ICwIs3/t+n8v40v3TkH tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhxejq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 18:27:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QIFvuo056173;
        Tue, 26 Oct 2021 18:27:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3bx4h11wpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 18:27:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ke5yfkT0GSNLnuHNfaL+YJy/iXtMa4cT6jaizm5EwMGoQ7nftW2f3MMvrYBtUm3zChHXdm60WtqnJwGboZM+J13eRcN5j1NzT4dkATDgrV5NqZo9BtiwAxfbJ0IimdsuFX9Z0VA+1v0QRvYpfZZ1X26soiMzPOSrIJsfLB9fuwLH+vXzsbUaUPD42DVLGVcphl1KRWS/HJ2KYyK1z1hX88zC8xPM5WDQxpfWppDTxq3sMeOmgAVcGW9h17yVBVql6EDgWrVlVAf7g4G5I+rWsO8SRw2pXSwQEPNXO3phkhnjnnYtlpF5Tf2uPCIJ1E6a5QiCJQ9yLf52Wz0QL4rVuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LALc05jRM2IapvGxZBdqHvJzLEu0mnMnwIysDMsgKi4=;
 b=cq87DaQT3wHSD2Tj8AlueytP2D1OgQZNH1mkk88YdeiH9w9LNJ9jolLVGlMOjnr1Q+StoCN9fDAam1AQzWeZK3EICQ/iTsRWkQWVu/NVrokOp/VaeW9yAP7Cf9ChvaPKtmSJmUsDiCXeYUfJyY/5q6UDKokHyxoZr2UB1D0+um1YILxD+2Uxt3lmRjUGACc4Ajj0tF2C1nGjgLPOlHt5eAtcAbJeChL3U1tfJqtmHrxR9vCi4MjAB4oKdsDPeb9U5IuReauwO9DsW47gwH7EOp6R8DCXqCFJ6QLin0UDwkD7bYuwKwA4QrKzXAJex7561Mtdv9h4vUdj/nwNnt0EBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LALc05jRM2IapvGxZBdqHvJzLEu0mnMnwIysDMsgKi4=;
 b=esQ5d3pp5QHAkbMMFSVPavgIaAdcRVQ+kRY3XwLOTjD2kFb1a3MS+IT8ASz5aZBIs72nIMJy0GJuPAk/Jg5KfCKcGkgmgDByxH1r9gB1gQYDnNRkXYI3vZrhRG+xhtHV/EdS1ZVnm08VuegPkMuQVN/D1iKlf+tDRUbgfOh5nmk=
Authentication-Results: HansenPartnership.com; dkim=none (message not signed)
 header.d=none;HansenPartnership.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5755.namprd10.prod.outlook.com (2603:10b6:510:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 18:27:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 18:27:06 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
References: <20211026071204.1709318-1-hch@lst.de>
        <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
        <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
        <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
        <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
        <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
        <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
Date:   Tue, 26 Oct 2021 14:27:04 -0400
In-Reply-To: <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        (James Bottomley's message of "Tue, 26 Oct 2021 14:18:16 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:806:122::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.42) by SN7PR04CA0111.namprd04.prod.outlook.com (2603:10b6:806:122::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 18:27:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b18c6d83-9692-4ba8-6d8f-08d998ae3720
X-MS-TrafficTypeDiagnostic: PH0PR10MB5755:
X-Microsoft-Antispam-PRVS: <PH0PR10MB57558B369E823A965650B0EC8E849@PH0PR10MB5755.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVCpQCPOOzTkd4ewGaHZM283aABU4TZ7H2uzy/4uxRvIwFdt9y7KROoWq2ttPguWWjyJo6Gge1twTQwz5sdvN2kv6yj4UELeYGC2LCjuTGjdWl80z48prjvHfKNxJoFawTB4/pAX1E/Ue62rAB1FSFZ7L0/AhgHh23oP+rANAJqqoe495Rnj7JhsS/UWCv0AOgFPfUzev+c3O1KQ0COk/fs6aigZtKGv9BaUDuO71+xlh9BCeXAwN040u9F3R6IlSfvO3Anvcnh4pF2KKT6OsJbkbHYnT/DNXi34Zpv/dralSB0/qSl8DJ+KDZNi5YmfWjrOu9Z+5xYoofEAsyeSIgkxYCzG6sMhQxs4kfbw5iZnoqGn0A7SAtKOIJeNH5UMet/Ca8q8ldY1ceLXahGW5KrLhVq2gBcKvrBkvPFK1IKKuWxHYtSP0bt47GvOuMnQokMyv/l3gQhSY0uHXSvV3hXITGAKogKxKJrXWC44nn7lK1kFc9hF8nxbrhZL0lx4C+nzQJouL6FaYg54qDVWkxjl3ZLis+wQYQmwAWZf0ik0QbX+Wtt9lq4vAKuV9tuIZ/kcTGjWY3AUNdfFVS28Mnp0ErC5dzZChwpzknRBBWxHmr3alLqHaEfxNr9uJUgoLtuPt1S1rGB8UqVD/cuUTpXmLkbJwwlhx9NfCK5hwK3rm7zMsABTBK73WjTq3y31ytyNwXpmkW/1tT7gvreFQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4744005)(956004)(186003)(38350700002)(55016002)(66476007)(66946007)(83380400001)(8676002)(316002)(7696005)(52116002)(508600001)(5660300002)(36916002)(6916009)(2906002)(26005)(38100700002)(54906003)(66556008)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bZWY//XbFUemdtGqx8kl6uZc2fm46fhI1A6+KM7xB0qumQ7lbdSaKBuFWc1d?=
 =?us-ascii?Q?CLBz6+ZDYoEeKo8e9cF9yLT3aDl22jIa17hSal4reTtuyQ3z8JS2gCHSCRfj?=
 =?us-ascii?Q?4ZQcI1vNkQ+en8oi+XxbPpmkymjRqZyIEYciRz/37YXlo56+KvCVDWBs8uJy?=
 =?us-ascii?Q?n56taS/F5jM66LttT+n/ki7u4oBCbEjmspYFmwoIJQzZd8+bv2AzOL+V9pjP?=
 =?us-ascii?Q?7gaQBdb6+fyxy54arboLdc3QZfUNGQBvQL5YtBmPfRxjrLc8arJZTfw9+NHi?=
 =?us-ascii?Q?/tw1ukF75zv8bAipNXumP0cLFoGSfqiHWJwfhncMzgyKxlpVeRwKawovo0Ts?=
 =?us-ascii?Q?JlcEOm1XbgP3TikdikBQenCrfPW7U8NmhzGZMsgV8T9pTQTZCk0M2WMW+Dpz?=
 =?us-ascii?Q?CEolcpUYZEQXbIlIUn+dnRAgZ8sGWbCE6Ay6Z1LkNQqy7gORW0e71uhCvDpU?=
 =?us-ascii?Q?CSnJdjWRVQrepK1F92h7TRPEeUiDMGarbawLZIMinwrqn7vs97qFCBxnc8dn?=
 =?us-ascii?Q?tzcwDnofIYnqHJdVfoGPALua2DrIYkEd8qvq4X5ZSjKlUpDsbcJu5vVKmvhC?=
 =?us-ascii?Q?M/YzSFsEsktO9eVxOD4xJObfMZQZF3tXdCzWQ8Ev9Owz87a9hix53Wl8iOTb?=
 =?us-ascii?Q?8qecYX0NxpA8vo6lxeQo+ufSD0r8BDlm/0LcvdWGXUa9fqbTGMdQHsBgnDqY?=
 =?us-ascii?Q?nr1Y/RyU7CWk+zD025sjOAicDOoZCf4U6+k8Um5txh6/9v6y06Nk6PXPLZdv?=
 =?us-ascii?Q?pWcbLGqYNrt3pgwA8KUFdQUYmbj0tU9I7jLncXIqkwp+8SuDXviqiYcFS7uJ?=
 =?us-ascii?Q?1AKlyE+Rge7fVvTKNkRF/2f6HaKVwqqd5Gtn8j9Bzvx2aa6AlHM2H5vW7CTw?=
 =?us-ascii?Q?pqHaqNr1TPgTaEH9GiK5sUhYGtmbFsBLD++uu6OXvpkqbK4LDUtuS0rzrxZG?=
 =?us-ascii?Q?k4PHWeJ0j2uuNH18hyg0zyfb6ulHEY+qUW3Tp6QSK4V6mHD29uDfiiQMdbo3?=
 =?us-ascii?Q?3oyMv+SburUKADpRvrqC5buefH2yCtbr7T8lSasGxxQ9SBi+cI501JeA3mNF?=
 =?us-ascii?Q?+0z91rNe6wTINkrb/TajeNcwLs6bJ6CEsABLJt4RFu/+gpv3f4ug7A/WPx0k?=
 =?us-ascii?Q?FXR4/Bbfh3szl3cnGpKEhRyjafhScO1WYJ2cyU8ZxuuNG8v50N5TLyzrBBB4?=
 =?us-ascii?Q?vDQQbMErgueaeTiBmnzay4NNJIMuLORbkKUBkVZ7o0Ty+DdhXRyo5QoqssKR?=
 =?us-ascii?Q?bhmzcmKi5vd605T3/z2D0WtxhvAkkU55GNxL+Yi3yANCmpU5NgbIiDz5WNaz?=
 =?us-ascii?Q?xljM6xbU4CjAGsjfiB4vnGSMswBmXE2JafLVBPbWbZ9oy92KF9ItiiFecxYc?=
 =?us-ascii?Q?vgTr0TmbxOQstM0Wrhtrfvx4EnYDDlBSZOCNtKJFxZfFX6ddAPBAEfyI3x83?=
 =?us-ascii?Q?hoCRcqdl3iARDVGO74jAesrrVdoCeK7aA8Pxj+PJUjZqDlYwsFsW+DdL/8NW?=
 =?us-ascii?Q?Rfv1AaP5U7KRDmUlUP39wE57TShZYMDhswnKYG36X0nFDZmgBfgIUGlYk0E8?=
 =?us-ascii?Q?rhel+8h0MCLFjHqGOdflsd15d1aQo9dAngcfgOTIEkcarPe0BAScPQRXjEU9?=
 =?us-ascii?Q?vTdRuzXEDqPNvzudMeQsEc6RRQaNvGkADPWCqhcp3IwBWEzLJ+o/+znSLEFm?=
 =?us-ascii?Q?0O/FZQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18c6d83-9692-4ba8-6d8f-08d998ae3720
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 18:27:06.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idBZuMuiGHagg0oY+qJsT2Oowuc44RxlKRuiaUuvaLc9r1ICmbWklrHJYeEesbZFF2P3mn1IaAUWu8IWweMVSGBVYdmTS5q32+gM7o4+b4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5755
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260102
X-Proofpoint-GUID: U9qVuJj0kLvu-RG2iqCYJ2VgHDBr3EiG
X-Proofpoint-ORIG-GUID: U9qVuJj0kLvu-RG2iqCYJ2VgHDBr3EiG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> I was hoping the HPB guys would do this.

Yes, that would be great. Easier to validate for someone with access to
the hardware in question.

> Agreed, that was my initial proposed solution: get rid of the write
> buffer optimzation now to fix the API abuse and see if we can add it
> back in a more acceptable form later.

Doesn't matter to me whether we back out the 2.0 stuff or mark it as
broken. I merely objected to reverting all of HPB since I don't think
that would solve anything.

But obviously we'll need a patch to fix 5.15 ASAP...

-- 
Martin K. Petersen	Oracle Linux Engineering
