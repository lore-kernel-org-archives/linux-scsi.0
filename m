Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CC7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA7686103B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhJ0DSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:18:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40208 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232490AbhJ0DS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 23:18:27 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0mtCq014988;
        Wed, 27 Oct 2021 03:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tPezlI91ZfsE71LAmht6I4TcIA/HLFasXlpEBQlnSr4=;
 b=vm0kwYilLFPn3/RpO0MlMI3wQXT9YDK/z60yjXvjaaKYrkgziG1qwPX/joSJI2AQ2U2U
 Tm/bZwaqBq7fi09crD/ZQv8SLoKEABtUdemhhADnegtamE7YmbJCqF6xLO1fQS23Enci
 j59pMlB6bWOYRPNPLtroHOQ018ByDAfTyQWriCBjZgO6QwDMiu/hCCjYd8JuQ3EcGIPi
 VGOnsrQhwkTlyvEA66KqwFJutQgcfwJ2lgJG2NXeBtp+Dz+EbrmXYdcEILjZ3Z2++IXt
 wWkGfL0fCe/96ZZd/J2dsvBEypLggYSHiZ13v60a2D7X8Rp+XsRUZnPMbnk9qk3plugF nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0dcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:16:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R35FAr006789;
        Wed, 27 Oct 2021 03:16:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3bx4g992hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:16:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYvxoMq2N30yPPqTj7hk5lux6Y5ZWPVZD57Jz/DQAGUJXGt8BPFw2F/h55mVoGAXp65AH0+SsidPeQwjA0YghIRl9WSABWiWql/2bF0ev4J1ByGDXMpPk9Z20VI74ofQqTAARWnpDuLp8RKYg8x4iplN94QXc/73dLfCWSlkx8YXpNJTcE56u6uSyEClJzlvj08uAdjMd2ouF26QdFMgoN8xQsito7/VOaFLW7Q2P98EQ7a33V8mmqKcIksx5bu2EKvdFNOWll/CnuCOdLbveyLmP4YdSVDal0tyA4Gn8vSo3/t1mDs35qItJ4cihU2Uv7JO8qagZGmCW5K0//hJzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPezlI91ZfsE71LAmht6I4TcIA/HLFasXlpEBQlnSr4=;
 b=WLMXc7Q75Cd4JLC8WgCPjNi4NhbocXTFScPE8geT74ncS6Fae4980xbtib5YolX7ItOWX7AD3D7kgpxu7jS+d+2khWgkoREL8aquBNmoqvkwNej/WBsouRqY4Dl8vJ1QHCznLAX/KeGWM/3B14nm0LtyWlpLQERjDw2uHGFHvn9tfb+UiEVvjVMaVVhdaJPNwlAZArvSrCEU39orYOHwG7AYNA6/mMEvBoOxBgl9G36bhclhhDBh4ngpaSavxE+YGn2mNLT8cQ5951yWeEqUIAnwct2fwwMCWlji+RtxAH575DPSM8hdKGEO5y6y+c6ks2MEGdjONk1D6wVEIdhXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPezlI91ZfsE71LAmht6I4TcIA/HLFasXlpEBQlnSr4=;
 b=A8mXc1UAH9m1EDYiUishye5Vt95dz4BR1s0DiaG1gA56laH6s3J88APNMuS4GrJhjlo5epmLnr06U2lXoNQWbTzerbJCkv90BN/qs2hIPq+3Wm2vVc2PAcRFgd4XgX51j/Lgqic+WIGCia0ywcjlH4pBYjkwqZkg7i8nqJKTNT0=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 03:16:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 03:15:59 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v4] target: core: remove from tmr_list at lun unlink
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnlz17kt.fsf@ca-mkp.ca.oracle.com>
References: <20211018135753.15297-1-d.bogdanov@yadro.com>
Date:   Tue, 26 Oct 2021 23:15:57 -0400
In-Reply-To: <20211018135753.15297-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Mon, 18 Oct 2021 16:57:53 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:806:126::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.42) by SN7PR04CA0198.namprd04.prod.outlook.com (2603:10b6:806:126::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 03:15:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46142749-35de-49a5-63e0-08d998f8197e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-Microsoft-Antispam-PRVS: <PH0PR10MB46614B84AFCAAA3B9659C1FE8E859@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +68Wl0Odw4d//whFWHf9ZK9qRC4wlmtkmliPjEB/NW86TFJts74kLbafTgUwpI+P5Esj18L/CfILGnkVlziq8dC3QFjdgv8POrkcVdeK6PETCtVl3l6GZe6+5b4T99VdKZj8LyXbiEEdyAjDuim7NXmIqAQz/7P394WEyK3tuAJLbpGGRLl3RpM+aIeAWeuX252P7a6xTOddLbKdYr1MEoEv2loGZYFi9tY/I8I260RvPo8vFHJB3ma025zn6fL3l+bixw7ZkBUako/4JSE3MRugnJ+7HL+POHhfsoayVVzG5m8uAQjVC7imks5a0MrcS+mZA2Yttx6y8WkbWrVbGDu6q23xdL99ZWrBTXi+ZK4QSC4leVrk1PDYQXemeEVkz/McuKL2pcOLO1ZlGyWVz4Sh3lrmTecKxvPv76Yf4iRIeEFkxzZ/Dt4nKbGWEwBXWVP+X62LJAQMFUjrZRkQuMWocAcyFC6LrGL0u7lRdRP0HWK39Bwnlxfc7HLghIMVSoVTuo8v1s2mC9WQyEeTe7RWi7/Q8y89LWvX/HcdfuczX53eHXxkZa0LEWCNZIrOCtNhbzYsiX0wYWG6tMMbAsIeGCol/bNtVgr39OHesm8aFIF3HJ+OvcKb8pk1mVEC4ViydVXMqa1LVw/FGQ58AP5EcnUPLHhznF8UnHAqAUfAglLUlk96yKPzaoWFmmYo1yieezKtgE0objTTpli0qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(186003)(316002)(26005)(55016002)(7696005)(956004)(52116002)(6916009)(83380400001)(54906003)(8936002)(8676002)(86362001)(4326008)(508600001)(38100700002)(38350700002)(66946007)(66556008)(66476007)(5660300002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+zcUidtEP+pWie9iklQkmPYpKqSrOKpUa4S3SXBLCh/UcihL65D6iWqs+zzk?=
 =?us-ascii?Q?XxxDr6+ixBrY508VjWDZUUW/5WRv5cEE4ryIA4UWCLGK7napS/odJvLPtgpz?=
 =?us-ascii?Q?7LdJClHOkcRlj8ulhpxd3EEriO871LwuDh9Jmmge0IwKMJzWhFIRpniXxVr+?=
 =?us-ascii?Q?X3JBBqWq+KkbOUDZ3XK+lWTUESLqbB+VKMahuMw0QKeiZglGqMxYt7FTMpaz?=
 =?us-ascii?Q?KnZju5rCRiLhzXVQ4cPg91NdJqAStUiVfzH2D5szuZXGl29iJ/BMvfO9nR/S?=
 =?us-ascii?Q?Agn8QT4NhbAvD4tEkpt2eYQLz2e5rfxV4h5RuNHrO1Sh4V9a9BKqMkJ0z912?=
 =?us-ascii?Q?LCC2mxlBMVqzE5xSQnVHRXVdNCMsggkH6G429EYt8vD595mSHk5T+pBz0WJt?=
 =?us-ascii?Q?GGbK74kdwQ008w9sYRdx1jk8V0jj411NbfIZ9e2isb8iYW2pfTigLiAczTYY?=
 =?us-ascii?Q?+GoCJZSJM0eX2Y1AsfU+BgvrB5oABIsfz/nXL0U7ts1jJhUV5oex9a67Ward?=
 =?us-ascii?Q?F+9h8QDVO8S5jNgG0R9YEgR9Km+IQiZlUvksLOVGgs2p5P18uK/8J59OulKK?=
 =?us-ascii?Q?W/AtxMbH/2OeSgO2Am5k2Vr3Hk+W5/Ap3ZcCYhk0+wFw5g87Qd7FTv3sHak3?=
 =?us-ascii?Q?edAIGbPbD7F+RYZSiNTAPhLlIJrrOHCoDkwymf888SqAkemJ0k/D9d+b5xbX?=
 =?us-ascii?Q?/NH6DHW3fNmjkKo2S4hehavk/OGxGobITxB9nxySEZMBXhmI6h5QdAPo0LFV?=
 =?us-ascii?Q?qwoi4vQ2Om2mhk1jTMJd3jY6JMt5i/Ms7n/GSmzng6qXkkU6hhxV8bQ3RVEY?=
 =?us-ascii?Q?xp6nioD4sCvp39MPUwI7cd1ic2j1j+z9+7dXmHURlljan2NRmCbe/UPCDq+0?=
 =?us-ascii?Q?492K7YCY8qIUTX82g8vgu6SWa5hxB1vNTx2hPCOaK2qvYlRiC2fYagIsJ6gC?=
 =?us-ascii?Q?WF4C3elEj67+hR39SDQgWnC+OJhqLj0zEJ2U5kLGADawqh4zl1dF/dR7xekU?=
 =?us-ascii?Q?4wLgoGSs25w47qVqsMs9osHFba78q7RD5wE4PzRDuHi0ZbNMOcCG8RcbM97D?=
 =?us-ascii?Q?Kh6HABYortfdeuG/EXEhmOgYqBoqk71F3ug6ZaR5DEHDVbyuCR7fTr9V8rnE?=
 =?us-ascii?Q?mtFrZe/nF26F1XLVv4BhZRxwSsnCbzYPwWpIpaT1aoOGfSULHAUab5AvG7PV?=
 =?us-ascii?Q?fQEnrGJhKQWOSwysFTnkulh+lPcP29U/Ixw3ShLmWi1Deb0j1aJRpMfM6xna?=
 =?us-ascii?Q?ZRU3FY0C4v6NE7uGfOchh/xgI/BOmRxM29Kpj/7c0/XZ2BRhINpRuAn1Gwgl?=
 =?us-ascii?Q?MHkEG1jawNDhRuK5qAYXglyMip0syhby0LbNnM7cpHXO+8O6F6C3RVNGA5Oi?=
 =?us-ascii?Q?xQGWQR4BjcbOeZJ5owAu8eyJt5gVe1d8VtTWt3K+KiWg4EcHEMQRTlxJqS4w?=
 =?us-ascii?Q?O3DuCucmVTxGZwqMDQQVB0bucsxFdI/SGg+c7K6p7nYkcIFoFaAFBtP8A3Tc?=
 =?us-ascii?Q?+Sm4wcnhsIrIydoDw92lH50vXpnP0SdFerbrw6WCYtqCl41Jz0GHOOYoMQqg?=
 =?us-ascii?Q?gGRPU14kHyRy2RyaYm2EyrgaCT0v4rOqfK7dg0xLSvgx6ckwhEe6/ej541O+?=
 =?us-ascii?Q?OvQ4MiWYFTaXeXXh/ErBlhTHk+Tjmy1FkjbY4R5h/swLNfaapOgmw8z7TBC1?=
 =?us-ascii?Q?Ok7b5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46142749-35de-49a5-63e0-08d998f8197e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 03:15:59.8432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HintLg6CdCZfwU3G4+1HHUZ98ZjNwV1TJGqAlayeChRvVmLKoM79XXVxkWL9VR42x+ayRbL9jGdyckM14YZik7CM7UQ2xsCZcEHciVfN7rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=958 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270016
X-Proofpoint-GUID: 5yAo3307odd47br_Lot0o1KyEgloWROe
X-Proofpoint-ORIG-GUID: 5yAo3307odd47br_Lot0o1KyEgloWROe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> Currently TMF commands are removed from de_device.dev_tmf_list at the
> very end of se_cmd lifecycle. But se_lun unlinks from se_cmd up on a
> command status (response) is queued in transport layer.  It means that
> LUN and backend device can be deleted meantime and at the moment of
> repsonse completion a panic is occured:

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
