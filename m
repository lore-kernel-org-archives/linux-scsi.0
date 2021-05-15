Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F64C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 189516144A
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhEODPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:15:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbhEODPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:15:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F3CWcY076995;
        Sat, 15 May 2021 03:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WDQjwJCnv999VhHrMcRp4HXhYEqa5JJGrSIOa3wO1RU=;
 b=lOCDcouGSwlychbto87RWP/+HBXX8R6XFOBL2Au9Pn+3pjkjFRJmFyk2AooB4OVgoH6P
 k6Z33dBZGSCF6YtwG3Fyu3ZbcSW8x8fA3c7wy53EmgctSnyHjJBRwdtx9f91N3vcsjIl
 Cx34Hv3kkSJXa6Z0+pIbkVhBvSxzDz5d3eM3euj4yC9Cv1aBIp4pMU9us1QEcKyz8mTK
 TrZRfz6cWkKUNra5lJjmHmOivBE78Rpy/2JCMi0MVJGQwwJISKsDc1TR84SbW44mxBjq
 jZdZYcT8qjkfFKSxeWLJLjsZkcvr1dZ3+sfs+yPYqEZOLs4/CfZ/k6yobh7QGdcT6o8y HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38gpnunm82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F3ArW3100526;
        Sat, 15 May 2021 03:14:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 38j6410ad5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajRiZWrBY6djo18XYdzKmL6QJ7HMu87/QGYqDYQufE1yrYxOHsjQT4jUQtCYJOuo6i4HDYSTZBLzVcd1ZZRBdkteEJakcfXulJKsMCjLYvjyx3cZDZ2Ci4VikYZBe/Z5DiRvntBR8RUSVS48Surr/O27AJ01BW/iOM1YbqtDC23Xr528yL3fjeDHL4TjIqLwVuGMSZYa87w536+Z+zxzllUeamloJlqJA/e9XKTHaancsuTsDoI/3dHyYRC28pCvPkFUGv+oESvWcrDFXyo3eSn+H3xdwMkJsOig8Uy/CZvlYEOKJJhDGAY2H5u7iaofnJvnuEtFYPGWfeQbq0RQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDQjwJCnv999VhHrMcRp4HXhYEqa5JJGrSIOa3wO1RU=;
 b=PgEWWKi5FMiB/f6+dQHbE1AYgDWJq2lSZ0QeRPr846FecNbhcYxVcOamps0sOOKKdZ4uaj9w9yTMrZyOYFrt4qEZeZjGt6iz7aRreWhVkRlk5XDrr2w3HRHftoWMhUcMNfe23pU8xsQi7fKwC+bc2NkPfAxqv4VUFt+PGENL3HzqlBl568boY3m2xMMLSy6wrBhHmt/pBy5Na1SOfAhaHG/AbMyDyQD+AaaNkcXMAMeZnS3Ctx+LnmHwCmlK1Uxl0bYNdJMPLNHOJC6qm/ZBfFbf2lNbt/51o9QEHqeZHBM/xfAtUI/uogw8Y4EhJFNBXM248PAR6Yy8WHxgwf0pLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDQjwJCnv999VhHrMcRp4HXhYEqa5JJGrSIOa3wO1RU=;
 b=ZZ7h2ESA/Y7cGazmtENZDzK8PPehy5rRyXmhTAKRK4qGWmc4NKRJPCZtsBI/kSYwjd41T+OaXz5fBRk3BPayEluYrzsDNWeqxcDENruPJ9DPnPIsU53xUIRlvCYkrUGVFXfH4rBOmNpAlj3FJ0ipWALYDPYElcDpjlOH0fp3IVA=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5452.namprd10.prod.outlook.com (2603:10b6:510:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 03:13:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:13:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] ufs: Increase the usable queue depth
Date:   Fri, 14 May 2021 23:13:51 -0400
Message-Id: <162104840194.20119.9272641081207171278.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513164912.5683-1-bvanassche@acm.org>
References: <20210513164912.5683-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0226.namprd13.prod.outlook.com (2603:10b6:a03:2c1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 03:13:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bd068b9-9383-41c4-b1eb-08d9174f7b35
X-MS-TrafficTypeDiagnostic: PH0PR10MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54529349FAC0D63F6A8862DB8E2F9@PH0PR10MB5452.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4QhJwfWohZLfanSdc7Ta9jlT8y6jX7DC2k5o2/5dJCCeWNQx32Mem7On+S8t+JprKL3kds43cHJA5rOdOVZCDI7NXJDz/0kiM+JCqBwU0G5zEVusJvqHFIxDvQe5GQ+W9AaJO0MCnEGNB+edkSnCm4FkJKrOlGl4YNlQvDLrFjmqW6Rpc5wa8QcDNHbpCbS+fO8qwdnhSM/x7qpMcs/WcBQBJAm+qyfhapHTub4MHm/KrUc+A6bL/uBkpQmppsr+5ViPNEAQUbjKNb6Vjxbf7US1RDzpazUup0ZxO8ULGZXf11LS2i+jzFmEESKa1yrzoR/KdqSyIjm97wi+4ah5g72QiPaLKd+Z7W05M4x+m7tXucSnr36G4AD/vfGECapQrg7YepUZNl6A7YhuHmZxI/UUjTGtAyekxlgp5+VaZYmfTMqH9oeacaQ4+ixbYDzsq6K7DbluVxVLwVyug70WZ207Jo0dxk41ByJ/+MnwRxK+cl5Iet0iLxlIrnZ6h5EtVhy+qUDvtLrxZc3/ALmAZEUrHC/VETrHyIMiKzhpa/y8+a1xQgVAWG58iiTTPbCNMSXk7L8RETx0Q+VWVwrYIuFW0wlXYoNQUv0WAENrF7X0msOdqBon2C3lkJ0WF8bTIoPNb+MBdaEb3XRZPAZH5E+Fb9agq4G4WC41AquyVtXdyz2RgANbwpiYfmmvJmPZP0a/yftvSPXjqMud+lTRGZ2pKPnf8Y3Ta0gDZkok+jA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(7696005)(52116002)(8676002)(2616005)(26005)(6666004)(7416002)(956004)(83380400001)(66476007)(66946007)(36756003)(2906002)(6486002)(16526019)(5660300002)(103116003)(6916009)(478600001)(316002)(38350700002)(4326008)(966005)(8936002)(86362001)(54906003)(38100700002)(66556008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?elpNT0I4MUtJR0F4U0hKUWJIMnVmT29hdnpPbWFBT3orMlFTWXRnbDRsbWpJ?=
 =?utf-8?B?c1dtcHlmYktnTXZ2UjNmSlRVVWRROGd6MFRQQjg2dldvTkFMcm45UUFvRzAx?=
 =?utf-8?B?SVRRR1I5VjlNVFpQVklTckd5OWZPS2dEb013WXI5R0JMV2VaNFdnWE95M2VN?=
 =?utf-8?B?Y0VZd1oxUFRuWGw3ZkVrK2RZT0Z2MmlFUGtLcDZUSlo5aFU3bTFadno2aFMr?=
 =?utf-8?B?eUszMzRMcHhBSWRFa1MrN21mR2JVVlJhOWZNdEhwMmJCb2hvWFFuengwNWhP?=
 =?utf-8?B?YW5hV2ZJTlZVYXpvdFRkSGdJOTZYWXk5QkpoSGliYWdMYVZZeFp3NFdEb2d1?=
 =?utf-8?B?SGZNbms4L2JQU29sWHFiOWI2NGN3RDZuYnNJSVpxYVBIcmJRMW11UGVrbWI5?=
 =?utf-8?B?R0xzOEVjREFIeGNnbkJxQTdlYUwzRWZPMUV5SjcyeWVKbHdzV1J1cjF6S1lD?=
 =?utf-8?B?Zi9LNU1HVE9aNHJFVXBscVFVR2J0OTdzWUtDMHBuc3NqL1I0OG56NTZGRVpK?=
 =?utf-8?B?NG9ZSkNRaG1CV3RWc1o1UlpBa1VUQU0wenJXRkFpcHA3c0ZVOGcyVjNPSnRY?=
 =?utf-8?B?VW4wUk9xc2R5ZjBESTJLSC83R1ZlOHE1OTFvQngvTHdTYktRYnk5djBpa2Zh?=
 =?utf-8?B?MVVObW82bHowSjFkczlZYkt1eXRPVE43bFc0aDMxeUtrSm1vVG52enM4SjlX?=
 =?utf-8?B?ek4ybEMzT045bzFEMlJTOCtYOE0yZTlmOXFGSnhzZTN1VkFwSVNiK0V6TjdQ?=
 =?utf-8?B?dFJ0c2plNUhFRGErbjhzN3h1eXFKTm1ISm1mNERnNloxRlVZZFZYbWIzUmtr?=
 =?utf-8?B?dGhtZDRqaGx5WldQaEtScWVScVlMNXB0VC9pSzNvYUFYdFR1RzhhS2lGTElX?=
 =?utf-8?B?YW5tL0xXNDNNL0FLamNTbHAySWh6UGp6aVRKTGJrN2kwVDZEemNVcVVvQ3ZE?=
 =?utf-8?B?OVU1VUJFTVNDb2RBSHJ4cmVpbURGVE8zUGNuWjZ0WlBCRUJJTHNCM1U0VVl1?=
 =?utf-8?B?MERTbGtiZlQ1RzVnUXIrTDczWFA5bDdmVHlKdkU4cWFkRkZXNmNTbUk5SlQ0?=
 =?utf-8?B?ckZ4cURlSHJaWVMvSmdCdk9CcG9pcUVkMGg0czBseXUwK2xTcUxTWGhmN3Ru?=
 =?utf-8?B?aittT0pNWDNFbzNsdDRydGVVRXhLNzJXWlYzRjI0ZXVDSG95VjI0TTlKaDJi?=
 =?utf-8?B?Uk9ITDhWWUZ2RDkydWRhRXY2UFBNblBTeW96ck9uczdMbTV6ZG8rRWwrY3RV?=
 =?utf-8?B?SmhHVktmV3ROeW5HZHBsR2Q1Z0QweDZ6VTZaZXNudE9VVzJrZm85dk80QmVr?=
 =?utf-8?B?K0hsUXNvb1JDbmxzUGx6cW5TMXVrUGtIcmhUZkxHQXJUYm53cGo0K2Y5QnY5?=
 =?utf-8?B?QUMrVmdoR1MrNndNUlZVdkU1YTRUSm9kemhLeURUWk9uZkNkSjdNUkhrcmkz?=
 =?utf-8?B?cE5vKzUrL1Qvbmc2c1BUdGw2bmxnejFQbUVkZ3JFTlBlOWwzaU5CUm1lRFJS?=
 =?utf-8?B?SUtlT1hNOCs3cGMvSEhrc2NXUTVBaGtOOFM5dDlXTnl2ZUFwYnF2VGNjejR1?=
 =?utf-8?B?R0RUM0Zkdk1USmNJa3ZUTzdydTJubE9qR1dKQXpnZ2lManF5MlowVGNhK2tM?=
 =?utf-8?B?ZXNBdkU0S3BZVzVkblFFMFI1UWlGczUzN2ErTUw1L0pJaGwwQXppQytTdHRQ?=
 =?utf-8?B?UnRWV0dtSjNQZ2hCM1JxOEtNZmdqeHM5aXhpZW1BUk9LZElSRWlwalB3RFRi?=
 =?utf-8?Q?YQAxlT7exzVYMJDdxcvvj//aXCcuwL/bO4ac8dR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd068b9-9383-41c4-b1eb-08d9174f7b35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:13:58.8698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FUnr98nZC7RzJuSu2H16SZCAgITm1rYOp49nDPrge54YyND2UeCJvdL7tCYPGFIBEnujyEk3imNrv8yewo7hACmDL7R3VdeMKKEWedGRmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5452
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150022
X-Proofpoint-ORIG-GUID: aTzTS-rizl4O7fFipx5K6XeF7lISHYJt
X-Proofpoint-GUID: aTzTS-rizl4O7fFipx5K6XeF7lISHYJt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 May 2021 09:49:12 -0700, Bart Van Assche wrote:

> With the current implementation of the UFS driver active_queues is 1
> instead of 0 if all UFS request queues are idle. That causes
> hctx_may_queue() to divide the queue depth by 2 when queueing a request
> and hence reduces the usable queue depth.
> 
> The shared tag set code in the block layer keeps track of the number of
> active request queues. blk_mq_tag_busy() is called before a request is
> queued onto a hwq and blk_mq_tag_idle() is called some time after the hwq
> became idle. blk_mq_tag_idle() is called from inside blk_mq_timeout_work().
> Hence, blk_mq_tag_idle() is only called if a timer is associated with each
> request that is submitted to a request queue that shares a tag set with
> another request queue. Hence this patch that adds a blk_mq_start_request()
> call in ufshcd_exec_dev_cmd(). This patch doubles the queue depth on my
> test setup from 16 to 32.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] ufs: Increase the usable queue depth
      https://git.kernel.org/mkp/scsi/c/d0b2b70eb12e

-- 
Martin K. Petersen	Oracle Linux Engineering
