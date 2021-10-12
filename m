Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96845C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9806103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhJLUhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51046 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233308AbhJLUhj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJjlEe002221;
        Tue, 12 Oct 2021 20:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MS9HUfTpVTn2zuiJkLj00na63UclwEL+qXCsRR5S52c=;
 b=ZmyTBGyPSGxJha1yflnh7ehYQHvJfAwOJ+QVquoy/2Kju0p5jYQpFlD1WCwlzqLEU8bX
 7rPspoN6ZR/3heCNSh0A4CIbUX92piN2WcaMjb+6pmBI+oeRFMvkdEVKIAzVWbVrNlVs
 vbFjnY2TvJIJuzgN/kd2tJ7r/P/H99IeC/HA6gLwul0ihAYa8wNtdjwMc50Hp3qQpVKu
 BGnxFievL9vC2sqPAMiNMo9Kudquq41Kn3DFzhq+Nn5AB7qPguv8AMJKcSnm/WQg5vWM
 u/CoT0ZhKv7065coKLLUPqRtGrS9EJ4ZlNfA0ARJscmkg3phieEAMqyzNrizKgAhiKFN 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmv41ru5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ78c009550;
        Tue, 12 Oct 2021 20:35:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3bkyv9jpxv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkC2aBgqAXMGmLFqfrp1y/q/nBcVz/BDAcpBmX0CN//4qbGpP7svHGS2z1Sm2Cn5pccqkP0wRuOX/SHEusa3ixLL0c5zIXSdW+Jh42JZlx0lhivOsb6tFv5k/ZKmInhtk+gII1eINtCzHDETraGeYuyfvmlslpLPbH6Vf5XDJFRD20Q/fCU1NusjcmeTuPgLtq0tI26Kd7jCnkfik4IsFcalt9OSa+sLTHrY6hPB5cDd6dBlyg4HCcKUiU1HNgdZxzVgQ/nIaKEaEbFQG1NBX3Hua/2izVmtng/R9xG1oxMbFTZgBTJFqcamjQcRUXNKoP0j/eKPNZk4YthDDpfNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MS9HUfTpVTn2zuiJkLj00na63UclwEL+qXCsRR5S52c=;
 b=JPGdwwWByXLFiKtxUd1ucea1O1yso5muZUAd4JqyE0HQ3FU2pMLhdOg3PzKgbBSVpmUylzWtXnihUV9aIZzyEVKBweE4oi2VHUUbt6YNLfGS1jw3UM/fQSeDWac6reoauSKi57eDXk6PHKZe2IDpsnaOklRuP5bxxCveH0pxAMH/ZYMXLw4YSGQkouK5+wuPLX4xFEAtqsRD39qwsKSf45pM3WHbQe4S4uY84O8MdMm1/LYaf/0vQRPwfZMMYPfekCerT5nSsEAOSNyGkHk1uFEBENqb49Q0QGQNJUDehY899T8JSES8K3Qa7NkqTYVCtMGs4xhNDUAoE1l1HHKC7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS9HUfTpVTn2zuiJkLj00na63UclwEL+qXCsRR5S52c=;
 b=evgaj0U179ZbmIw8JUeL7TklbQe1uBtKfh0opVCy4nguIjjyVgSZUtWhPQ8qElXMFP2tU5aLIHGfezmbkbqQIF0oSOmZEIIE3FnSNoHdJ4hMdibzP3c8zlHEHu9cC/EL5iOluklAx4MYLUFXNUx6d6gUd7Fl92evWDwLU0SZyzA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, Michael Cyr <mikecyr@linux.ibm.com>,
        Chris Boot <bootc@bootc.net>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v5 0/7] target: make tpg/enable attribute
Date:   Tue, 12 Oct 2021 16:35:07 -0400
Message-Id: <163407081303.28503.8165623863464063041.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210910084133.17956-1-d.bogdanov@yadro.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36f2d7ca-1f68-4f78-7961-08d98dbfd12a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5514CC377D183B957536CE1C8EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J39fsAlPKKg3vgSeACBWMNf8X8uBIWn5A2f/NDWgLLeUqa/z2Qjbx3UdxzAIphBJPAdy15F9UvTlLmhvf+CfxfhnRNdayQFBsGswj/LDvfbQfgxpepwhwH0DGWJT95ZTeUyBmwUmLbVyGFyOUgwfPzOnClcs5RdtVlgsidwegH9rcS4mMdXJow/8KXhGU6n5zCYkpeF3T1T3ut4VRvNnhjfFg6eeTLdMvA/xKSOk4aDfVSPcDGoHdyKX5+HOoklqBfgXMr/JuW1/0J646RtR4iDCYHa205gL3SwfLnP/GsDQFb/wedDda9KqFqVYIWa6XnSkZtyYj+aAtpMeIibid0O5qGpAFVDP6hZRmKQPBnO1b5JUjaQ0QOVXAa0+z9cCD07ygCLHiKCJH2US4ya+7TR7J1NaoFnwlK5KH6Vn7TYZoDxeXqULCxq5CjtA/coELEbU2Pd7NYquVwxbMJp81bv7jcqHnTYIFYNjWzq+yWLgYExLT4sHm5wFjfsrmuQfaKsP0e6QL4j89RxYA6nl4iLR4mulMWVIr5qh5jqzyVEYcLhw1jR1qbkUTkMYJ4nwKFJ9rFtncG8HCvOGXRt6hWUH82xYRLtvjyje9kl66/ZBz4GK0C6P0O7omI9RvyihcaKYF3ZSkv4/D5H7Ed31whRei3vFAqlTXJZuUKExOGKJ6yD4FOOEDsYRgoHA5dvWo37JkujMttb492Rqt5xISciohhHCGXTmuUA1jXKztHvNavdQd1vZ9O4iSopQAJByTjpfsJ3b8FjbhJ64yE6W1nBD+rqP9MMLGRDJsJfd3kj9jKyh43sw2doPQx/1zmatDo/mNsWY40F1ReI1yJ4rVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(86362001)(5660300002)(8676002)(2906002)(6916009)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(38100700002)(8936002)(54906003)(4326008)(36756003)(186003)(103116003)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnB2UjdmU1djRjZ0NllQQ2R0RC9Oa3BTMXhZUWR2WjlNS0RldW9ZanA4RXg3?=
 =?utf-8?B?Zkp2dG9mWHV5eUJlU25OcUVSUFpXSVpVeWt6UnRiVzllUDBOTVlkQmRXeUgy?=
 =?utf-8?B?c1hOT25MRDN2dUNLZ1dDb2hmTjh1aFdxMm1Qb29ZeDR1VlhVL2NXYnZqR2NM?=
 =?utf-8?B?RkM2T3h0ek1YdDBMeld6VXY5T3JUODBBT3pqcE9zQmRqVEZtZTAyb2F5ZmRF?=
 =?utf-8?B?ckhNNmJTbndIWUNrTlZDKzA3ZGRyeExtaE5ZZUc4RHIxZG9EWUxJNzMyOHBE?=
 =?utf-8?B?eWlyMmxGNW5uRXYxNFYraElpOUt2Wi9EeUJuZnM5Mm5wV1gveUMxT2ROTVBa?=
 =?utf-8?B?Yk5xaEUrV09oSnczLzk5bnVMaFBHV29oRHBrZ1ZoSUpKaWxkQTFUMndNcE90?=
 =?utf-8?B?ejNwaEJ5cHU1WVRjWUEyT2ZLOGQzV2licWErdTcrSDJYb0lsK3VrK1kvMExT?=
 =?utf-8?B?TXh1UWpvZVpDZGJJMVFMUzZZazI0QllGQkdMRHpSbUY3ZkU3NGFtcGk5eVoy?=
 =?utf-8?B?ZHlybG1SMnR3TnZDV29NOFBSN0tFYXFVUU9adGZiN1I0QUo5V05hV093OFk1?=
 =?utf-8?B?VFRET0ZJSlpPNWdld1RnK1JFQW5XR0lHZ0JFRUNoNHVqSjRLbFV3c25MdUk3?=
 =?utf-8?B?NVR5eXFNS0haVlZDR3hFOVYyUEhBY2NpUUVqdk5YKzkxZXRJY0J3K0pqZ0F2?=
 =?utf-8?B?bFV0VjhoQjZsWHdRNk9oTVlta3k1VG5pMFFsNWRPQzZJTlFmbWJRTm93V3lu?=
 =?utf-8?B?SHVVSWpQeGlydmNVdmsyaW40SUhiYXVCWUE0K2FjQnpQMjUwcVdKaURIWUNM?=
 =?utf-8?B?aFZZd01hNFJSeUNsOVg0cFdYZDlpRStHN0RUUjlNaE9xOTgzMFZFU2gzWmE1?=
 =?utf-8?B?SWpCMFpJZzI1MXRBSUhQSVVjWFkvSlAzcHZ5TWpiU0VjNEdzNlBnTTJkQ2ZT?=
 =?utf-8?B?QW0vVVFXNkFXbC9wYkw3UnIwdUNpTlNTWXlhT095ZWNRV25oQ0xPSnMwbHd6?=
 =?utf-8?B?NUNXcFU0R0FaT0Z3NDkzUW94VHA1TEZKaERSbkptL1FyN1JxRFF3UzlFcnpC?=
 =?utf-8?B?cUdaOHhZVHozdlVsa3huRGJzSndlQnpxL0VBWUEwKys0MlkwQ1NBbURrR2Ux?=
 =?utf-8?B?Z3d6eWJlVXBDMkU0VGl6R1NXSHZ3QmdsVW5aUUFPcVFraTJJeHBvV25lVkho?=
 =?utf-8?B?a0VwVE45WTFVQnFhSzliWHhranIyOHA3SStJU0VIVmVuZVFPRkhHbllLRHRw?=
 =?utf-8?B?ejJTVTlJTlpkYWRJN3B2RnNtcWZkL1FxVE1SQmErSmdBeEdQRmJYOUViQWpB?=
 =?utf-8?B?aHE3WUFKTWlYbXVXcGx4Nis4SUJFbkl3TC9pb0RmdklZZEQ1bzRIMzdoWTg0?=
 =?utf-8?B?RXdIYzY0UHdwWFFJOVVvck9zVnRGclFja1F6ekhPVlY0amV3Tm5WZ3ZnU1E4?=
 =?utf-8?B?cXltVHZwL2p0aDZLUk9TdGFoK0kwNmRZd0xwVGtEcEZXTVdiMm9LdWJWQjE4?=
 =?utf-8?B?bytXMk9aeXczWVBNZkFMRlQrcExjZ3dabk9sK29KMFZWdGJvS044alppVlZs?=
 =?utf-8?B?WFFJMlZ3WFJKUlFPWFVSUFhZNmpUV2JOTGNiOUxtNXI4akhNNDMwY1lsWmZD?=
 =?utf-8?B?ZVJGcUpCUkE3OUo0SjNWLzc4V25ReTZkVEJ5WUZnVWpWdVZZYkNHZnFOaG8z?=
 =?utf-8?B?MUhybTVIYm1kTUQxa1B2M3hMSlVBRlQrZWY4TFR3aUF4UVEwZGY5eTFoRWVr?=
 =?utf-8?Q?6B2EU/hfe1RN665W00TrOIrWZXVT0XOmqPetUIi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f2d7ca-1f68-4f78-7961-08d98dbfd12a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:23.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waIZi/mBiuzfrgg+6/sRfqrfpOCjzgCeSJydyHvDSEBeLQ++umUZC03RKUo+/tbH157p3y0MGQI15jbXYCw51cPpogmvZdvQCm5PSOjWdCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=846
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-ORIG-GUID: mH0nCLLFz1UqRJoqJX_i6hgmgXoLk-1N
X-Proofpoint-GUID: mH0nCLLFz1UqRJoqJX_i6hgmgXoLk-1N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 10 Sep 2021 11:41:26 +0300, Dmitry Bogdanov wrote:

> Many fabric modules provide their own implementation of enable
> attribute in tpg.
> The change set removes the code duplication and automatically adds
> "enable" attribute for fabric modules that has an implementation of
> fabric_enable_tpg() ops.
> 
> This patchset is intended for scsi-queue.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/7] target: core: add common tpg/enable attribute
      https://git.kernel.org/mkp/scsi/c/80ed33c8ba93
[2/7] target: iscsi: replace enable attr to ops.enable
      https://git.kernel.org/mkp/scsi/c/382731ec01b3
[3/7] target: qla2xx: replace enable attr to ops.enable
      https://git.kernel.org/mkp/scsi/c/cb8717a720a9
[4/7] target: sbp: replace enable attr to ops.enable
      https://git.kernel.org/mkp/scsi/c/fb00af92e5db
[5/7] target: srpt replace enable attr to ops.enable
      https://git.kernel.org/mkp/scsi/c/9465b4871af0
[6/7] target: ibm_vscsi: replace enable attr to ops.enable
      https://git.kernel.org/mkp/scsi/c/d7e2932bba1b
[7/7] target: usb: replace enable attr to ops.enable
      https://git.kernel.org/mkp/scsi/c/5384ee089d1f

-- 
Martin K. Petersen	Oracle Linux Engineering
