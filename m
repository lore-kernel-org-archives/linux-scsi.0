Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22449C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F0E6109D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344627AbhDMFta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344699AbhDMFsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5idIk057946;
        Tue, 13 Apr 2021 05:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8Jm5uOGi3BO+/ccl4LMkQw12ySZV6MmoDn3PAtDKyiI=;
 b=GX0PUdrxB8toTRZdGsBruGcoraYQhVQKhej0B+XcCwTZfnUxoiBrtlkzoFT6vRgDXdNN
 3JnTn8iUViqUTLM3NselczqhQuklkRkiigdLLCN4bWKPp3x1Vb3QcrbmSVTUlV8xF5Qq
 RiYfBD1Gl6QNOWWYv58RxVmIIcfnxyD/uI2RMpgRctlfBEON4Vo3o0dA01khQx8Td81M
 hj6RL5IO2bhTFNHTTxb2k8sm3XYYzoMe/6wG101z66y/01HVPQWoh5krw5SK4eK4iAlK
 NNF0fpWf8J57Z75tLeBK9njjjCLKsoqPOhUTDqucNjSDW49QRrxSIZqlVP0jqSoANpyo ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erdusu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRYH137164;
        Tue, 13 Apr 2021 05:48:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3030.oracle.com with ESMTP id 37unkp3mc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbnzpTFCUQu60+JQ4QtMYioaU72kFmRrfsjvgdTnBclXgNYutl5vkUPJ9cNJKpl58g6e/8FbWBqMPAJi7lRSvrgmFiaJoohpYuKBU61zNDls5A6tvTFQ8MJvAh89yZrV+UTCOe/Sf0YKuGVZAPxg2oABigDqMWwoZntmfEfDmWdfbfKI9mS++gKUCnThlDnhZKaJm6vU8baxjFBqe3WFfDwWqFwAX5ZhD4pu5vvx+zvR9N5l8a+jDtX6kxtYa8xfzXy8OvOz9gOuH0NX4krNaqrlqVu2/j9n8yueQoeXxdZQ6tOpuvHpBh5Nb7jsUbSVGT4cr5a1XovJ5uGFlPv/EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Jm5uOGi3BO+/ccl4LMkQw12ySZV6MmoDn3PAtDKyiI=;
 b=hciDV0sSAkIesaz3LxWQSU/uPiYJ3Q/sc7nIyTziVrFEK7vAUhwIEtCZQndlELzsPhj3qd40Cw7C4WUJHITV3p+I3bd+X9VhebBxb24FjPtIttwiFe6z+bhlDRmnRs36ElsNKdH6UDdURoX+LJ0GFsHsf7lpmhSExqO9ykmdx3mN62C5cszWYm/sARdgrV9EB8GdHLid/cB61TQHG6ztrgSWf2dOK+MsaPci1mpS3VdxjzWFOvicJw5rGN22j77Y8MpZ7xX77jwI8ENP9xNP5ruccHbWVH5YVWm7mEwq4Yzn3lQB1jD5R3kmoTyPnpbrOIVrVcjQz3f5xg2oOqdUaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Jm5uOGi3BO+/ccl4LMkQw12ySZV6MmoDn3PAtDKyiI=;
 b=xn3Wkm6ROUj7vZUOtes6+CjR0edrelrmzpmoKdR/vSQ3HETYjd1WlvSSKwKRlwGwdg2OLiO6qTz+2HOLobx/HnZM8jve0leu4JqqGIdevwSRoY/T0QoDR5yJBIX95ZC+qmIxuKk0UD3w9nAm2QwdvE2tIB7z60nhqkA06eJB2ak=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Pittman <jpittman@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, djeffery@redhat.com, hare@suse.de,
        emilne@redhat.com, jejb@linux.ibm.com, loberman@redhat.com
Subject: Re: [PATCH] scsi: scsi_dh_alua: prevent duplicate pg info print in alua_rtpg()
Date:   Tue, 13 Apr 2021 01:48:12 -0400
Message-Id: <161828336216.27813.1909315127295178076.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331181656.5046-1-jpittman@redhat.com>
References: <20210331181656.5046-1-jpittman@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 788a37da-dea5-4fbe-6ddc-08d8fe3fc1dd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614DE5CA092E2F54B8626E48E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxIKvkf/JlRVXA4bL48n3c4PwUnVsRTRFEoNtn6c4tMUVh75l9B+43qAVP6XkncjK5EGWTOzknArJJn37GtObXkCz4ulEroKBzhdeVI/grVLR09kr3NnbEyRU9doevs41bwEBhumuygcT0pVuh1xKwouemTpiueMWLv9ayMtGXPEdKcr9z2eRv1eEtDOJiwaaHOvGNfszbOnkT8rZN8dVc9cTORPleH+coUKgChS1oHWEic8WsOSHPWXut1A2pnL4RDrFbBijhn2K95Lxn5JpRS8knafuDADZ++L+8SIQk+rE7jLbaUJ14eN2esp+IANZWPNpvhwR4mb9EuibWX0+MlwVuV8P+29bk2ohHi4rCVdeYE1IC5C97b4CNSguWjPV54QyXdbC4gc2MC60eYojXLdz28t2sxHEHLdHZQRSchLKR1/qmlvcKDJMy1QsF2moZhW7QOxP80MxN1uHJ+5g4l3U5ry/1V/eUA1xtjJS4xgCz6Eah9UcW9+8x4rnySVZ5ohJWCspresPUA7NlKGsGVkA5ja1ypFoQsDY9CuoRbgG+SmxJiFmNlazbc/czoqcECC8Ly/XSqCGCPq6RZPgmaP8+JtgKsr/zBsA5UzglL1Hmcf0vn56Z/zu9sBz1aose4QUygEr+cSz5rffQeIlnv/sUzk3YOx/baAQu2PV4AhupK+ulk8s3X0ozzvFLNavuMlxzkafUOa0iwusoPwETey6icrTa3IWRfc96vy6R4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6916009)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGwvdW8rTjY5c3h2N05ObEVaRHhacFE3bjdIbUJtRHR1MEU3QlRwUzlQbHRZ?=
 =?utf-8?B?cmRxMGN2a08zQU1CNjFFTzV3T3ZhVkNxRitlVCtZSXlwbzNsS3k5WndZekht?=
 =?utf-8?B?N3h3QW1Zb3JFb2RaemZROFNka1FtU0hKOW9nWWNsYXV2THBpWmxvTW9vbmFS?=
 =?utf-8?B?QXhrdXNNVUJqSnNSVkZIZjJLdXg3TkRBZE9KZmFDYW9IdHVRZkp3WHZuZVR6?=
 =?utf-8?B?MVNOSmNUTC9kUVl5alZaMjR1R2NYVHZFMHdtVzJyRVJ2RGJSeHNsUTJ5WmJ0?=
 =?utf-8?B?UUhpZjluWVBqQThJUnZnSjVrRFFoR0VoYkp0S1lEeGhDa1ZHWk5TN1hoOWlO?=
 =?utf-8?B?WGloNVZQWTdCaDFscit5aXVmaWc4M25PUVJXTUlOTlk1UzhHdGZqSThKTXBQ?=
 =?utf-8?B?VHBTMTlCdWZ0S2c2OVU1dkI0c09pL3JKTE5YSTNUUkJSNFZTblZldWNQcEpn?=
 =?utf-8?B?eFJaYnpKTlNLNzM4aFVRVmxHMHlYRjVYSitCZSt3MUxPaWlEb01qbGhNTUdv?=
 =?utf-8?B?Tmlldi9abmh1MW1ZWE80NEhFZzkvcDRDZ0xzRVVTdU0wTkwzeEF1dDJoZHZL?=
 =?utf-8?B?QmpsQmlBSklla2szaEVKNmREb2xrYjQ5K0I1YkRiby9yb2JkR21SNXRGYjBB?=
 =?utf-8?B?aE1QNXNtbkw1TGZQeDVoRjNHellkWjBBd2xUa1JyK1htZmJCWXJjd3FHL0N3?=
 =?utf-8?B?NVVYZ3hwUm9NdHRlK3AzRlkxWHF4RloxZEN2VlVLY2FPaTJ1YXUvL2hJQStF?=
 =?utf-8?B?QmJmRnNsbGZxY3RQSlFnNko2WHgzaVVESWZKMFJSR1pCQkJhTFBEMEg4ZDBw?=
 =?utf-8?B?blAvem8xdjdFMGF6NWlzNTFqcWwvUlZsdFB0cmxDVldFMW9JUFA5VUNSMzha?=
 =?utf-8?B?b2RERFRRSmNQZ1VSSk9SWHBDUDFxVUlYS1lxUjV0RC9qY1hXRzRRSUV3MTFu?=
 =?utf-8?B?cUJVeUU3LzNucDhIUlMxbzdzemVTSjRwRGZxMEViT1JLc2U2VGRCcnpoSlZC?=
 =?utf-8?B?VkhudWpZWW10dytIbW1KM1BGclk3NUJyYXJ5cDRwUFByQzRSc1B2eHlwWkht?=
 =?utf-8?B?enk3K2dRbGJwUzRXMXZzeTBXTmxDS3ZMQWFqZW9sbkYxMjhoRGpuL0FkWXZD?=
 =?utf-8?B?dlpQd01KbVdTWEdrSkJMMHQ0d3h3WWRlNFd3YWw0bXpXVjdJVHFveDJ1ODhr?=
 =?utf-8?B?K2p5bnN4bEtSNjZzcmZxVVM2bXE4QXRWbG5HUVBKWElqMHljT1hXZ2FONUl5?=
 =?utf-8?B?Z2RsZVpVSzlmL0VjYWZsb20rS1NKbGFRUUNLYXI3MFVvTXdwanBNWVI1azRu?=
 =?utf-8?B?R3FmcFYyaXEvdzZ4SnVna0VlWlBidWlGRURZWnZGM2xtdGdmM000OHl2V21X?=
 =?utf-8?B?b1ZFMzJ4ZFRaU2tSdTcrdEZJUG5Cc1djbHlzQysxb21HRmJOeUhFR0ltOTFK?=
 =?utf-8?B?SjZkdVBwWE9yaTByaFRxcGo4TDNFbS9hSlBoZERpbVB2TFV2YmV1bmpxNGNj?=
 =?utf-8?B?LzlOcTMxMThkRUcvdGFXZHFCb2ExYXJkNGdqR0hRZ3djMFFnYkc5RTZqcXdl?=
 =?utf-8?B?bCtURTlFdmdzL3I3Y1FXWThHeEdmNmNoR2dWbjhtbGo2cnJBMDE5ZERlQlh4?=
 =?utf-8?B?VnczQklFRUgrRE1KU2dLZ0czRTNPRzNGNmFnVTdQbHNKSWwyYzZ2L2ZFb2Nu?=
 =?utf-8?B?VTd5V25Ga3NvZnVkekVkNFpQdXVnY0JPeXlndmFxTTJjTis1OCtHMkQzamNh?=
 =?utf-8?Q?6RazPggSqjjvLzvHbgbSG9hvkl6g1AI06QfAqng?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788a37da-dea5-4fbe-6ddc-08d8fe3fc1dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:26.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rqdb51WkqfTn7b09CHl+fkhjOl7F6TxJ52k8yHo2Rrrw0VHamnS2Fiev0bfb3ZXIr7sVTrow/Gxz7Gx3arc+nMh+SxyWzi5bJhmB3Di43M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: aCRGRXF79PnuFxeOf7YBeYjXgSufl2p2
X-Proofpoint-GUID: aCRGRXF79PnuFxeOf7YBeYjXgSufl2p2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2021 14:16:56 -0400, John Pittman wrote:

> Due to the frequency that alua_rtpg() is called, the path group
> info print within can print the same info multiple times in the
> logs, subsequent prints adding no new information or value.
> 
> To reproduce:
> 
>     # modprobe scsi_debug vpd_use_hostno=0
>     # systemctl start multipathd.service
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: scsi_dh_alua: prevent duplicate pg info print in alua_rtpg()
      https://git.kernel.org/mkp/scsi/c/22ec513e7057

-- 
Martin K. Petersen	Oracle Linux Engineering
