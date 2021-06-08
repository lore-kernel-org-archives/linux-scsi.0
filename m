Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9386C47095
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A43A760240
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFHDHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhFHDHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834Evl162479;
        Tue, 8 Jun 2021 03:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VFZMXmXU2jSwLcWOD6oxl0lCkKabxQ5s+CkxKn0Xiw0=;
 b=usghMQCrpugjKJLbSW/5oxwwQrsN7tMHF0VgWoqJ8WpsRZn8jVBPPqcuMGUIDD5a0Hpo
 B50EjNCGTMCSbD89+To3Y0LccJIYHA1dP0JSSIRzKfx23DL0GH7+PwoT0LPbyLMaoTaB
 dbSIx+jad9jHRE5VIQqNaIrUwsvczCCGnXIAue/nV2f+dYVTlvTgpAS9+JE/fTv9I77p
 kxpRhZlWZ7hDBcPHxX9zAhKgcbR2I73RLvD+6WRzkUAxksneU1MYntqukxa4GTvEqStY
 XyjFjjmpTwQ0ecBSFZD9rphPJlAcyFqLzrVckYo6hbL/PQqcnAmUu15b22Tmmm4EMSIQ Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900ps4kd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834UCf151447;
        Tue, 8 Jun 2021 03:05:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 391ujwgtw8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/MW5nckLD/J/PHz3ULt5czBKyXFriAB27tRIdIIJ26Vp2IbK2sKbYFOz1SGVMk40XlgOST9QtomuyIG0+6FE68yfp6MbiSGJM9revMZrkoZ2rmrB4oQHcOy+jaUimE6vBmFFOMcmdjyWWhXCXv3j5AnOQiiAdcYc2cEnTBhaQBBeyZhv/qlqeMcylybgRit9hpSb6/GMF1VMZTjmdrEVc+HmgNeXd6/QqxXFu5rlhSK3/+yM3x57MeKRk5p24nh6cw6T8ZBNW+wTrByYbW4jIoHLE+tg8/dIkmfaZfehzWlvcAiUbKvpz9cUd8hiWXQ51FsVkdBlHTSz80i8sr5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFZMXmXU2jSwLcWOD6oxl0lCkKabxQ5s+CkxKn0Xiw0=;
 b=BcGgGRE9Y74+93DZLhU5mep9K03jInjZ4fLVWfx6BtLy/CtNIWHWFQFvbPCfxgm6NL4cRkMJNuM/2llfKSq298rJo0UO5OmyBWSGj4E2mUqYlhI2ydkkWY9U5LSbcOUarOtMQK9Vd3VKs9HaGjTCBAsAiMWts4kA++zWMpxMNM6+hK1hpkmVPPmTtyHArp2oWSSsL0GtxAPoC5rPtxCR/Mw5r0jQM15AMTAEhJFZEN3uQs6X0mo7fqlinh0r2PUQ+CEf2jlRdH7e9r/uxYJFMK3jHknZVFe9l7I8A3HXDJJOlpW4v6vLfIZaSkrfPVUYr5oW0ggfdWUgwIUHdhu25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFZMXmXU2jSwLcWOD6oxl0lCkKabxQ5s+CkxKn0Xiw0=;
 b=oe6PcIgso1qlOt+BlSfNcsgjJC0QpHn2+c+qFxShKsELju37qePq3NAREWh0oAAKWC/crCcFm2Aug+mjxPkQj3WxtN/yQt/A65zlp65sMFIXT/rh11Mc6qI/R/WaCRHIc81GsVjsqoY99KlosDO96L2xsoyJxT4EnxV5EVjOqj4=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] scsi: Fix a handful of memcpy() field overflows
Date:   Mon,  7 Jun 2021 23:05:24 -0400
Message-Id: <162312149257.23851.2059527786955087070.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528181337.792268-1-keescook@chromium.org>
References: <20210528181337.792268-1-keescook@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ad24b5-60d8-4012-95d3-08d92a2a4962
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44702B6E9C69704C3FEFCB7C8E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpXbnmTH+Ik/HcN4z3yq7cZQcPNOmQH6+P6lfePaU1Hp6DYJ3Xlq5EFPCYCvPI4qYkk6yBg9Wu27cGScxMOFyYPcE/Z/sexo8q0J1dOK4YjAjG/HjWAne9r7Plo8RpuRfQ+E/fn4HJuCRlDS+U+yX+4Ln9+HRsOSKStXrINtDur8z8wPnzLWHmkRV7KwITY+v+ptmE2mMj8aXEip6jV8K3u5rEeJdPV56tbQLU2KL/E84qRtbBJrqzAlAgvOz3WVGq4ty67yLLvflR5asRg3zHM4s8CUtI1iAideBvNVTpQTRfIT6dUHji8inpsy6QWZl7f3e6cNNQM5XWSx4JMVfh+n2NUZGu3n4+CFQr9foN9wgqOd+L68dsTarNfE95k5l7+Ou56oqvlwgi5q005XuuA56Wohzgw9uJZlJPUD1we85lShWvH7dnAajQOfKwIL5BbKE2e2WIPmKdHMVlunwXRUeHTwh87MJ5v7/Ym7nL9fNIXPXJtaaF9r63uWqaeane43OsPtFhEHT8aTPrsStvYviVWFt07Z9IEavuU4wJTZRFrYypSXMIkO+hR2hlwcXod001axgaCb4uV+WaGRqjoyHLECEnebjhtZ6rv56fVVhL/QJNxViX7GfMCh2c71pXZ8fbT11HnCcjbIpqWGGrARVgjp7eudmODu70UyZb00itqlI2T4+D5sRNX00gtuutYSXIf/d6PLBWu10UjyNRzHJ3E4Ua+xfFwxW+cl6NdV3+MGBEVV8Mfh7XNoaBV+dl9tS9lo+f2XRjDEVpbL5RV6HrRxGB4nOH49GPhUHMRUSmGpjxx7mltw5caSkimU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(6916009)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(54906003)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TENhTGQ2bUI4SWdlYnFWMndFTDBaZTdiT3NsQ3NLcTlJTEhWZ2xNVHFwOER2?=
 =?utf-8?B?Myt6cXdlLzQwRm5jY0o0MzF1UkMwTlUvV1ZzV1pTOSt2TW4rSGdwMTJnckx0?=
 =?utf-8?B?L25sUHAzNjJpbVFSUFdZaEVjSVRrQWVoUGljR2FMSmNKalZQeFZiM2J4eFJX?=
 =?utf-8?B?MGQ3VDFJOC84WTZHMFpGUlVyMDhXZVZyWjM5UCtCNjRaOXdMZHBVNDdOQmV4?=
 =?utf-8?B?RVo4bVhtZFNPT3AxT0JJRElqQ2cvUlRXS0JraGNoTVlvdCtyTXpKMjFrMTYy?=
 =?utf-8?B?OUtIdlJSYlJkMUxDeXNuVG42ZU5RZ0FoeU9PM284VnZKK3BxdGZ3RGhsWTB2?=
 =?utf-8?B?b3NjSksvR2JuSjRSd3gwbjdabEN5SEJuR1RjOUI5MnZKOTZSNktWL2Y5aXZk?=
 =?utf-8?B?bVpaeEhoZTFhbklWSm0vWUNyREJpNUpIbWtaQkYxOFhlSUpqYlkzSGRtVWVW?=
 =?utf-8?B?QzRrU1laUGVKdjhuQUwvWDRodUJ3T0Rub0ZFVC9sc1p0ZlhSNFV1b0RKN003?=
 =?utf-8?B?ZDhFTFV6dWdTNmx6MzZBd2d0TnVCUDVGNWdzZCsvS3F3d3RHU0ZxS0xvOWRr?=
 =?utf-8?B?b0Roekk2UmFaVE5MNW0xSjZXeVVQaVNIKzBsaHp2OW94WE5EeElOU2pIbEpm?=
 =?utf-8?B?SHowYTlWcVREUjA3dW1tWDRCRGtuS2p0ZVRYOW1zNitGV2ZpVjBvNDlGNzVy?=
 =?utf-8?B?THMvd2lFUHdyaDBGSkpaNnhXUkRwQlVEdzQvcXJzQi9Db0J3TTdQcjhpUzZW?=
 =?utf-8?B?akQ5TzhraU9QV1YwZk9TYzFXM2NGOCs1K3N1NGxhdExaTldIYTRyUHlsQzlZ?=
 =?utf-8?B?NkNYUTM0L2x3UTM1WGprZGRJZnFKRi9WVFhkdW1HclBYTnVlWnppdDY4NUxE?=
 =?utf-8?B?aFhrZXE3eDIxSU9neUtyd01Cam1KdFhXRWxtTWVENEtWemJQZVJiWlA5dVN4?=
 =?utf-8?B?eHpMUDZ2T05yWFQwdE5Ta3hrbVE1V29KN09VRHZwZ1NsTVNyN3QzL3QyT1NK?=
 =?utf-8?B?dTJ3eFE3QkJqTmtnVVRJZU5YVGJnUHdWNEFxN1hkS3JGZGxPb0Fac2pMQzRq?=
 =?utf-8?B?WVROVkxDczRYYS8xOUR6cE9lNUFLVXRYWEl6bVBvSko1SHZERnAvcmZubUhz?=
 =?utf-8?B?UkE5SnVmZkhPOUhoRXZJY0NwY1Q0ZEhobjNPQWcvc3c2S3ZldTBlODB3Y3BF?=
 =?utf-8?B?VUNQRlNVc3JBalVqQXdLTDYvUUVFMVc3cVNvVnJCNkZGaFFZSTFLSjN4ZzZz?=
 =?utf-8?B?Zk1tVmpnd0FxSUxOa3RBVFM2L1RiTlNXdnhlTUxxeGdVWjhRNmx1M0lZb21T?=
 =?utf-8?B?SEJDUWg1cWtiVkZCbGhicjBxZzJheE1GSnpLN0tOY3JQMlpneHVMcFkvZitM?=
 =?utf-8?B?bEdqSVNCUU9Ib3duZGhFUjRZSnlpQitYME55S3ZYV0hIeVBlemlwOVhnc2pF?=
 =?utf-8?B?TWRQbzVsRUZVeGxUaDBmbFA1bDBKUDZJT1dHNHdlZFkxQVJBM3VCR1Z3SDBK?=
 =?utf-8?B?RW9jU2lQN0x2elc4eitISmZLRm1nR1p5K3BlUTJkazJKLzMyWE9VdGhKZlIx?=
 =?utf-8?B?TUwrajB2TnJkcWdhZlZ4YUx3bDBkci9sQmdmUjZ4QSsxU2FoTUowTlRGaFFW?=
 =?utf-8?B?UmsyQkVpZWU0WjMwczdRN1licWRseWNIUjZTWXRuZ2JSdVZaT2N5S0dXc0VF?=
 =?utf-8?B?eWVPcGZFMDJwQi9YWWdNNmVCRENFNXgya1MxRFM5cW1FRk56OFB5RVdlaHYw?=
 =?utf-8?Q?nPT7cCNtz44C5HlahCsKRbRGQo19IhBkFi70qFB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ad24b5-60d8-4012-95d3-08d92a2a4962
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:35.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hC3tbb9pT9s8XoVlCXOhzWIlRsXxINMZzUlcf/S2zccpz8Bl6kKFsw8m2aeV36AVAMuRUOVr/6NbIZ7qcCmJA7btSs8EFKCMalwv0kM5HOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=878 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080019
X-Proofpoint-GUID: lKCDiGiAHNCN4ycD6rtXXDpUPsOpCI8O
X-Proofpoint-ORIG-GUID: lKCDiGiAHNCN4ycD6rtXXDpUPsOpCI8O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 May 2021 11:13:34 -0700, Kees Cook wrote:

> While working on improving FORTIFY_SOURCE's memcpy() coverage, there are
> a few fixes that don't require any helper changes, etc.
> 
> -Kees
> 
> Kees Cook (3):
>   scsi: fcoe: Statically initialize flogi_maddr
>   scsi: esas2r: Switch to flexible array member
>   scsi: isci: Use correctly sized target buffer for memcpy()
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[2/3] scsi: esas2r: Switch to flexible array member
      https://git.kernel.org/mkp/scsi/c/66fc475bd9e1
[3/3] scsi: isci: Use correctly sized target buffer for memcpy()
      https://git.kernel.org/mkp/scsi/c/5250db63d140

-- 
Martin K. Petersen	Oracle Linux Engineering
