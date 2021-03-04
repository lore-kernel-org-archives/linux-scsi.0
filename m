Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1639BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B0D64EE4
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhCDERs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbhCDERc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:17:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12442BwF050923;
        Thu, 4 Mar 2021 04:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1N0XFWrMuK5PfmKxCd51ko0Y/6OXOG/KGSXx4fN7Yhg=;
 b=M4HC1HGRzjwTyOJ1wlr22aEDSRk6IypIoICjDncwRYF8Tdhq2c+glmp5bch+sIk2XCho
 7jONxK+22OhHTWK6pHC9HsekBT0fImztgRw74b71D/mP9kMyFsnow4PIZ8vR8bL9DLK8
 UYiRBkOEeWthBn1yiFREGefFclCMCO/psf0w0ync7k5agxFoKLRJT1MkVQioeCLD1i1X
 /TTwl+6c1yS74IGI8SnVgdT9EMufcSMK8QbeHufNGT7c671WiML4KmnzF7k6PTiAYaDr
 I5elD/p177X+oU4UKMTnjYPoJGWpO2QyKrc2qIV+BHeQBK9n+BC9yDWVEaJ9iK5v1GzD xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3726v7b7qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243t20P125591;
        Thu, 4 Mar 2021 04:16:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 370010a2ge-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5aVOkYjNPkMpmBFrdF++4YTilBsW1aKM0wAf27Ae2ZbgzDHDQE/MzuUMcYRP2L4ZnBdiCc6XGRMxExr5el4a+FtTJbZcsVo5HkQ2YGxmXm8CseIc/F010taVNN2jCO9WyMRdXUjj0UeawiCEsIcFRXM5ORyX2rzXX9GSX/+N4rVIhvlLulU3w8Y19y+wIod88MDtyBIApbx+O9zc0oYYLdiDQMDNrJvZTwdE6hop8rV0FsKh1s+TYu3dE3pf39cUbQumFgwnA+5D6BKqZQ/m1ZcZ0LeuCqwZhki21FkKQkIRNVWnKnxApIINRhTD75SVRuTbAncZdH0dJWceq3jWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1N0XFWrMuK5PfmKxCd51ko0Y/6OXOG/KGSXx4fN7Yhg=;
 b=YFQirkXO9FGRi1R4yyNTX5ahUer4inpvl4+N85BdlYUA96JD9xPLZcXXfqJNSm5N0ulvmpAVuFMC4m/3tLrjXr4TmJ+lfXnHwfyShQa4VcGQCxKyG77nU/pmSK8odFU4cy7HIryCQvdjslSF5PeTEO7MvCJSDWpFYo4wpejd4J+IQpoAjiNbqnAYbnXvXzx8pWPw2IEhIp5Bp7laNk94OVWbPrAH7aKRxAArc5+SModxEluJT60yp08a43qQLNdwB9kuJBfP6eGJq2CXmwawMJJBHEqZsZd8QmF7nTnlfgkmiU4TRZVANkOtS5e+0PiTZFOoUk2MqoVZegRJ5VS++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1N0XFWrMuK5PfmKxCd51ko0Y/6OXOG/KGSXx4fN7Yhg=;
 b=yUWutLKEkQssZXOtOaZnBXUuDvbRrvpjpAAdjmzAfO070hV1NUW3Q3D6tPDXGIHUlthM3KrLeKV3rviaZy7R4WRiilBy1i1UC/nOrVb/RO9aNYY9C0MeTg4A4P2wPfW3/yzvT/CftAAABWjiaockK1504s84u9UvtkqKSEPi36I=
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:16:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:16:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Vishal Bhakta <vbhakta@vmware.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
        jgill@vmware.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: vmw_pvscsi: Update maintainer
Date:   Wed,  3 Mar 2021 23:16:41 -0500
Message-Id: <161483137624.31239.5659498721124296581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210226234347.21535-1-vbhakta@vmware.com>
References: <20210226234347.21535-1-vbhakta@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:33b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Thu, 4 Mar 2021 04:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3b06801-1687-422c-8bcb-08d8dec45490
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45525B9FC5B163CFAF6D36848E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46oTk7sIyCv7DfsT9i3LtAhk+6adLadV4iEfaksUXIeWNPTCPp19oqNUzSRc5INsGpEYtFzU07ZJtk2H/cSnguNJmmOFk9Vj9zlsm0a7cTAoaTK3IGHl6Wb+No/ahsBm5TADfl6cC+vr1gk3+i65eBeuoibEjVlTQoLtg8QTFsTISyKbD5fLw2UlAw+aDBJSxe2lKwbnLai0EP4Ije1LDPRKbSKn5mti6kOuSKxDyXL7Iaeifvx81CsShRxSm3aNhMPimEXGgBSN/KiLQhVAxTOcfVeWEgpaniylF2WiF0rUPfOv/HfmS/MZllBepMpezxWj2WdFMCP+JsfVRiAT6+nyhqs9uPjGmsk3gUnQUUF0vSN2xnjM8Wz/40WSxGADBlvq9ZfHrbtx16dB/xIk+CrhJkfJtyQHe3l0BUx0WYP2EaBGp5HHaTBW0KCCbOkmLf5DuInlasVHYZ0/adKwVVMBaF+gUjh2FnOUzzy2MA2AFoAcgFWHFAMeIWVHknlLnAKrFIJ2fgqqDCJHbRAfzYwAwVeVGkfGeO3nwt00ke9qBmEg2ehe9966CURex2hYxPkS7HwtqJI4m4ncSJN5118jQT7RRVrWiMzXFpwBLPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(2906002)(83380400001)(186003)(558084003)(103116003)(15650500001)(956004)(2616005)(36756003)(8936002)(4326008)(8676002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFVkWVlHQU1Vc2d4bmpWRTdFdytmVnEvQ2M2RkxMaXp0Z0NLSGtURWhFbk5x?=
 =?utf-8?B?V2lGTS9POHNFdnZmSXdjcks0YVBMSmtCdUdkdXlmSFNxOG1BcEFxZUVuekY2?=
 =?utf-8?B?ZUNjaTNsaExYU0NhOHIxQkx4eDcrM21yNkJKRmQ1QWFXd1dnNU80QzhiTjVR?=
 =?utf-8?B?T1RnbkRHQTBiV2p2aG1zRjhmUWRvdkZvcEdiTmw0cld4MVc3WVYyWGdQYlBy?=
 =?utf-8?B?VUhXWWpPQWdLSkRmS05FZmZ3cExLTTdudzZsbjRGcWZObHdVd3lkM1V0N0ZF?=
 =?utf-8?B?SUc0TTNXZUwvNEhPQ3FZcjdxNk1uaFdoVEN6c0lDL2J6TDdwTk9TMWxBV0h3?=
 =?utf-8?B?blM5QXRGSHhRcExHMmZmQUlSY3Q0UmFlQVIvWUVYekUxM3RPM1F3OW9HL3Rr?=
 =?utf-8?B?QzRjWFBuTmlTdGVwemhiR3hsdzNaTHEwNnZwbEhJc0tpVnVOY2MzWE8vM3VP?=
 =?utf-8?B?L2NiNWpBU1h2ejVaV3A5MEozRjRwYTNxdmVBdEpOUlhkVEZVdU9IYU1QN1c5?=
 =?utf-8?B?NVQydUZkY2lYK2QwMStrK0pLK2pGeGRQelJZejZpTCt2ZCs1TGl3ZWFpWHkr?=
 =?utf-8?B?TDVIRHNtQy9GL2lRaHY2ZkRkTjRKSEFxZ0txOVRSMmJWVUdsaE85SVRGbDlW?=
 =?utf-8?B?Q1BvUFU1OHd1Z0tBL1FybEtwOGwzb1paQjFzbzF5WklSVXFkTllaUUdwVHFW?=
 =?utf-8?B?SmtLK2RCS2NReExPL0w0aktjNWlCSjg3TTlFekNraHBqZC9QZ2g1T2ZMUVMv?=
 =?utf-8?B?NlIyQ05wUEo2K1JRWEoyQUZXb2hsa2dOdjU0aUZrRXZUcVBpUzQwN1U0Qkwr?=
 =?utf-8?B?UUdtdFNrMktFa0M3amdoK0p1ejZTSk1jTlJoUG4wVVo2MXlVR3hRZDczWFJH?=
 =?utf-8?B?SHdaRnA5NzI5Q3RRN21kV0xVY2NSQzA4bGRRTlAxbFFNRHNNOG4yMzJQSzVE?=
 =?utf-8?B?cmJYWFBxVDVIV0JZS2R3aVJnUVd1Ykk0TUgwRi9URTBwWDdWMGxURGZaRnpr?=
 =?utf-8?B?bmpNc2MyQ2JUZ0l1bUR2SVY1eTNxbWRmUlZXUGQreEVrdHRqWFJyVy9UNnJj?=
 =?utf-8?B?Skh4VWxvQ0I4ZklCRXE0REl3M2pOVUlXNjhKL2tRcmNUaWtNU0dwQm5pVlFD?=
 =?utf-8?B?U3l2RnhJbzFFN2dqZTB2M0V5MnpwUnpnZjVLZSt1TzZsVGdMRWxYcjdibWUr?=
 =?utf-8?B?YmY3TkplVmt6NjVSODNTWGVwTjd0SkI4ODRzcng0Z0hyMEo3Z3FZdW9pMExa?=
 =?utf-8?B?SzZFcnp1SFhhdjdlb2xvUGliSE5FZ1NJU1JSamFwNk4yWlNwSVZVWldIUnlC?=
 =?utf-8?B?RXRNZFB5eVhwMWczWnBxTTA2OEZKdnR1a05KekZvNVNKaVYydnU2d0R4M3hp?=
 =?utf-8?B?ZWo4YmJQc214NjJlQjBsSWVpMXlrR1hGa1EzdjQyNCtVSUpSaDVPMTJ2QVNs?=
 =?utf-8?B?VTdIa1c4WmZMOU43QkVjQjkrQmFPc1lhWnlZOU01a1hIT0tSdTFLQXZzd0RH?=
 =?utf-8?B?SU4rVkFwemZzdGwwWHZZcnZkTlUyelRvNUtCbklnZWthelVWN1h6T1ZrUWJs?=
 =?utf-8?B?eWMzMjFLMmJwcEdSUW1DRWMyYXNCVzVHVjF5QkJ4TGdPYkFIODdDV0RGOFh3?=
 =?utf-8?B?aWJCSVc1bGF4a0RFQTh5YnUyUzNiSTRIeFlXRkNNQWU2eU9xOUFLV1pzVEhS?=
 =?utf-8?B?TmhwUGhLVi90MVArZjA5bUhKY2ZzbkY5L1Z0bHR0cm1VanFERjdLdU4wWFhM?=
 =?utf-8?Q?ouw2bsm24g8JwOiVMhqAZoXisAUA2zSLu/9C7D1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b06801-1687-422c-8bcb-08d8dec45490
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:16:48.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZUCUTAABCCaITCJAilRFHgi+dBI0HkPobxoYZ0r89uJQLuIfaY9GugrHSi5uAq3kgWSlLK5ku7s2hq2EUHaCg5gdQ2+hAg3bZY88beseEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=855 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 26 Feb 2021 15:43:48 -0800, Vishal Bhakta wrote:

> The entries in the source files are removed as well.

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: vmw_pvscsi: Update maintainer
      https://git.kernel.org/mkp/scsi/c/1dbafd931d90

-- 
Martin K. Petersen	Oracle Linux Engineering
