Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B7BC48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE60D61369
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhFPDvV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8538 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhFPDvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:20 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kUTj028393;
        Wed, 16 Jun 2021 03:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Z58l/30EEWmPB1ZeIpuQgg+Hh5OVs2GgWz6czHaDuEg=;
 b=q12UTaX1d1G7b2PzELBt7I3dxEfNyjsV5MO/SHQJrCCuMg/l7brejz1CsUZroowmJWfI
 UDpn+Bziszr8m6lSIHI6Gz7HKz7FhwR/87rBS8yOsFXvGG1bAKUTNFIWAv3jZU1uJVC4
 QFCHAdiewu7v7TbijuS5ro5hLtxlpRL4L8fdOk+wU2+hcgE14cx4j/dknAjgRuav3EUo
 BQSKC7OMaXCD1pE/6BFEHMS+VZhaVkOKapuUI6HM4wzTPcLhJodQSdIy3hsiO2RUINpo
 SITUufO7+VMt3BiP7Bl5UqMbZBOxy66Eu9GgkQDXGn2XAc+qXehDNI1vLPn6Fm4xAfux Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39770h857t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3j1QK034001;
        Wed, 16 Jun 2021 03:49:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 396was6yhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2CppxDKSCSdTFME8I/tvWJGqHZ/dAnmUQj/IECjRuCt8eP3llbUu8w1Gdu4kOdNtUxcFX1/gcDko++PvSGJxN5cMW1H33Tk/X7v5ZOACzWINSzyu2RrBlo2+nIL59qgOMvcxSAQ32O+brOGEZj7fBrsw936P/J9be9uawjvIbu8cw/7funNHk4LVGrY45Hbofz7+bkZ0JZ2R1UMJ6LhmnuuHVF1agw0biDZIYmXKMfIiryI2v+WtdsbDMeKeq2gqxtu7aonAcrHas0EvpOZnRqbJvpjy9gwUZEq8+ppLcL3+Wz+o0X20bwb8kLYZ3gJUVCpkvQSDDdzi6ZV/1R6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z58l/30EEWmPB1ZeIpuQgg+Hh5OVs2GgWz6czHaDuEg=;
 b=krHt4LQ3Xihd2tIA+tjsapEMoAebGlkvur35AaAmAXTWSD3iJ29ADK+ApUJrmUrNuuUv80hPdtRgaX/fFTVRIHqsv+uFpR+fOgwlQkbrGT+OcNus9LQ8z5lvCegX0Fx17Cogf6Eg1KJQQlx7HHP59mBm7Cm3655vk4qujsqPX92XHJZ08SxP2+IMSXYehhcVW2aGglugBR3JD4K/zYlImb+812X6aAq3nK7vFr05yP6yDV/02BJcz/cOvC8mY5WssWhunzynEGr9CmuJD2HWXuEDU34E/s08gK5nhLRoR03aOYxUzBtxztXgAtcu8wpDIJGgJGOlYwcb5CZA9S/y3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z58l/30EEWmPB1ZeIpuQgg+Hh5OVs2GgWz6czHaDuEg=;
 b=Vb9Bv/h0pigIVoXf+NggwtP+0vNCyIDG6ihTETK3ys2BxvXs4V6smHCUFXZstDfbHR7qrQlQWekARmwDiCRR8pqpju05nALx+/znblm5DJhoPL16y1I36cD2SKIC/dfdmYQJVtbujmq94mtKGwNNae9ZyxS/bb1YucbNsT+77F8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Remove irrelevant reference to non-existing doc
Date:   Tue, 15 Jun 2021 23:48:48 -0400
Message-Id: <162381524894.11966.16303439250847488407.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603122209.635799-1-avri.altman@wdc.com>
References: <20210603122209.635799-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55cd05a0-5b27-4bef-c2af-08d93079b1c6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466358F3C34C4E295D4B18C18E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ljdPSWjOORFCtDAfSXH/TBuLFS1Q8n5mXducKIMH0atO+945EJb3S7ZcqLrs1zJJqAdz+8BQbmRxDQ77bTrXp6nlkLw+0Xg1fvOdfyBXWqYOOi0zouoeex+OvoDjCNdgc1u4e4vJ4CjlEyFAwfe46fsfp354UdskNQyJgTkahZCgXiYpwTVQLHNF2R+IaS8W5etOp6g8NF2nvb9FbdiSGGfmWF2bWpKG9nIpLgbob0B8R+q7STbkHlh+yV3yFOXGjtc+2WdFR3Cu646VpWDlI6+0nRB/qwfweirm3r+55IFa9D1z7GdBWlh7CoiaLQVkAxylK5gnTPz+KczGnb59X9bmXnZac3BhAB6WStD6pN8t8bFIe9313GjlWeu1d1lVXoY+fYy9kxiV41qEh4zMYtkaJ4X5faCnxVi8C1NcyJL5ZJTGefKf9a5AlfwSPrGx/z/wZ9ziB+Mp8wCRrohzMgoxYxFB1bmTDANeS1gP1bBgRMX4cP70ZgFeTgNK7Yi6zP9QRaCM/hxfIDdUcLhfaCLt3JnL/4ieGsWb+2KimEpuKlcKKmdmEZyXWcD/1xe9RIJVDfWWal72B4+Zs99KWopM8D0RpkRAYjqYM1SGZ3d7QP7TWVnkHUtazTecNFUzOVZw1ZGM1Kh5GVHTyDH2wqijubK9pdgD7oUwlbqtW5xB999yJG+lt4UUw3vY+QYT93fmgUFewUilmcmhgyZCmiVtt/pS7dMeJSbe2IgoNQAJxcLu/Aeu5NL/pb6qWYplaCmrVpOZszexufDQYti2Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(110136005)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1F0R3hYSTJHVHZMWTZWVkhEZFlMVzFVREswcXJJVnJTRERtZkVwNi8wbHVl?=
 =?utf-8?B?MjNtemR1RjhQUlF2L2dEK1BXUWtRdWVWVitBOUdoeExzUFI5RG9zdlNPQnU3?=
 =?utf-8?B?aXpqYjR0K0xYOEN1OHJXOTFuYWdCSW5oK0p1ZDZZRm5Td0VjbEthL095SmVs?=
 =?utf-8?B?d3FKb2tiYyszRmgvRjRtOExBeVhPaDMva25zV3VGbVgrbFZrMVVLcXhGeElz?=
 =?utf-8?B?VDNOMUVTZzVEcFdVb3ZycDVqazY2d3ZkMHN2RUZlaUFGQWJtTHhkL2tFakwv?=
 =?utf-8?B?eFZLdXlFUjdlbFFzaVFBeCsvYUFJeXd1MnlYU3h1OTNlYzdxR1NJSlJINnpI?=
 =?utf-8?B?ZWhVN1pqVjNQbzg2VllKQ1hpUW1hNTZSR25DZGs0UDVCdnJxU2wzOGZvMGNa?=
 =?utf-8?B?Z3ppYUxYcnFGajh6NEN6UTBpdXRJdFJKUndHMFhxeXBVQ25kYWx5N1VrOS84?=
 =?utf-8?B?aU9WVmhsL2krZGFpUExyRFVROHRGR0hjcHpYTTlnUmVZZC9hd3F2Sk94WnRj?=
 =?utf-8?B?N1NaZ2M0SnlLK1pZUHZBcHRtNVJ5b0xMUkR2NGxBTlVsMnZaRTNqb21UWUV4?=
 =?utf-8?B?SE9EVjA4U0dWWW5EU1JOQjJqR01TbjBzTi9sTThzMldBeWdpTUkvVFEycFRa?=
 =?utf-8?B?Yi8vb3VqRDQ0UTNENDdUellJOUxGYU9sbnRaTHpiaU82aitWcFYwaE5LUDRX?=
 =?utf-8?B?azRnOUQvRlJ5Yk5JcTFzMGFDTmVkK2ZEMFVTckplb0hXVU9hM05GMi9wZlU2?=
 =?utf-8?B?ODBzWFFESDBlVmlQWlFwdzB4MWkxMXQrV0FCRzZ2NDlGR2dTTmYxN0o1YTg2?=
 =?utf-8?B?RjF2cGw0WGpzaXBWcEhMWEdaQUNBc0dQUmRmU1F4ajNqbTA0U0REU2YvbFRO?=
 =?utf-8?B?MnYrTkFGcjUrYXUvdjNNY3d1YmhqUlZQU3haTHQ2WkJBaS9WS3BFaFRZL1lY?=
 =?utf-8?B?TkgwVE5ocEEyZ2JoVXNPeVI2N3F0VTd4TlFSanJtNEJQRjFmbXJQbWNlamR0?=
 =?utf-8?B?Y3VqME4zaDdlcWpZcEJrOUtwYjJNc0JCTFBmRVFuZUlVcG5SOEJ6WVNJeExC?=
 =?utf-8?B?RW5WclN4Z1BuOHprdWQxOFBqYlcwYWhJUDFUU2w2Z1VmQ2c0L2JTTUNFKzQ5?=
 =?utf-8?B?REhUaEdabVZFdGhCRFNQeXpLZTFsNUVoQWsrRzA0Y2Y1WmZHd3NzdUZhN1pu?=
 =?utf-8?B?dU9MZ0ExRmk0Vy92OXp5QWU1bmZWQXI0YUV3SkRTZGQ1L2tBaGw4THVETEV1?=
 =?utf-8?B?ck5PMUt0OG9xMTdRanJzQTFiaGlmc01ITnI0UHVOSmtrMzlvNTZOMlFLU1Vp?=
 =?utf-8?B?V2JSMVNETTNkOHVoN04xUzdTcFRCcElHZ1VQamtwcDF0RUZSMDlRR0l4ZUor?=
 =?utf-8?B?WkFsTm1CdVp6S1AxNUhxbDdTTWhtbWY1MUxNTHpjbDdmdHB5RkpVbW9CbXpS?=
 =?utf-8?B?QnV4dTNBR0NQKzlEYzFlaVZiS0dYMkxCNmx6MS9RS2RLNjR2Zk95SVkwOFNy?=
 =?utf-8?B?SFVBSnJpbTMrQXlXeUtxelMyeTdoeXo3UkZwWU5RZ0NFNFFydFlqcWR3U0Z3?=
 =?utf-8?B?TXBNSnYvNFNubWdibnlZampYNU5NdWNOSnhXalUrcTZ0REtaMGMrVkFnZUZx?=
 =?utf-8?B?Yk5oU0FnWXJQRWZhbGpSSUFzUytnaDd6OUltMElqVk0vVkxmN3ltc1IvV1lF?=
 =?utf-8?B?OG9zaG5Ec0pRWStIeTBDMHg2U2VFeUVvRTdNejR5THEzTmd0VTNnaHlzY1E0?=
 =?utf-8?Q?o+7C4K49uxOrpeSzs9/Tq1jJNyap8yjcyi5z5Fx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cd05a0-5b27-4bef-c2af-08d93079b1c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:08.3615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1EIZY6ltzTCYUOYMfjQn5Jkq+VJFryrhNwq1NvyKzy+phusOwchmYfqbt7COd7H1oVgry+8Y0QNCbetogpdkkjABjboIoS0HYNDNMd62uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=545 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-GUID: lnRo3Imjq2Tcx6qkuW_ncZR03Abuiwrp
X-Proofpoint-ORIG-GUID: lnRo3Imjq2Tcx6qkuW_ncZR03Abuiwrp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Jun 2021 15:22:09 +0300, Avri Altman wrote:

> Remove all references to the description of __ufshcd_wl_{suspend,resume}
> as no such description exist.
> 
> fixes: b294ff3e3449 (scsi: ufs: core: Enable power management for wlun)

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: Remove irrelevant reference to non-existing doc
      https://git.kernel.org/mkp/scsi/c/8b1afb7ab0db

-- 
Martin K. Petersen	Oracle Linux Engineering
