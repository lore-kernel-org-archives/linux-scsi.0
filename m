Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E121C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6868A60F44
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbhINDqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62368 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239185AbhINDpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:42 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXwSC008716;
        Tue, 14 Sep 2021 03:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=akbJAWa2vqSzwV6zpjPUptyE3erpuUugE4MwZ3tp8zs=;
 b=lJZRVN7NWTRor/hpidAsweR0j9caDZxxmpDSlrrCFPtqzaSl7sBmN5bxK/eLIHI06WPf
 /r94vVpSV0ccuuwOY6/9N+AVIF0muhYjOMwjiTBN1MY7/2Y4THjXj0s3qpW1tuo2OYIy
 SsjMHXi4dtn8luuN94dxfNo9B92R1m9qTbeGIapNrmxtG1N/V/1NQmuNR1BlMfPglvAj
 MpGvKDdc6IMGRKyLt7ZnJldBgZt29QqPk/zVnWXcBJ7OBnBOq7QtA7NqUtVG3y4nOATd
 qNJsA5NhSkhyhKOwOFkIlMGdryVX18/nKw7lIXU2PdbgzdQwFV0IVlhXX5LgKfEstRLt XQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=akbJAWa2vqSzwV6zpjPUptyE3erpuUugE4MwZ3tp8zs=;
 b=YzVhU5zc8L9qpEmSLhCrg0Zv3IOaw2MfhMPVkQeIdj8JFXG8cj2dE0FR3O+1d6eMFHkd
 DxjWcIlG7O7INTZ3dF6N1+SUJ8x+1GXQTOXxf3HuDzoogEiFGAMBHuQqAfZbYLyLOMmq
 lhLNKom0G/8aOxCmS4k0rfhkNP+X2OnoELsD3/erfqoy7THFSUgKK9jTnKMSpNkqdK0T
 GYw1YqT/JakY5qrWo4bA9NmPQqxiagtl/pdkRhyomRjMtoT6fkN1rFohbRSgOCCHgmrj
 0xUJ9NbJvruO9mx48oHz5fK6WgpgGgDjnC40z77e2dgW7Q93c90nSckTsrG+828nGhi0 Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sd491-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f6LG097717;
        Tue, 14 Sep 2021 03:44:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3b0hjuesv1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9bmB13aK2m4P5fUX/8G56rxu2gIXSbPErV0ZylrO3acizTpJLANN/nnawD0a2UqBifo/OdApFEJi+l69afCffNWv4AzeEm0hRoM43U1YmmjYR32agr0SCs3w2IWdrr+Np0LlRoFb9YUdnIr0NfVpeVm9LGhP6ePIMlqbXv/pizJjqDGCuoySrezbfCO7PtGRf+KEGtrlX3Ju7IB90fpuhA1W/Ytj0MfUHGotKsqRp8uUm4tD+37gMOWydLYC1R/x8mnuxCTfWS2NA1tjJhZ+WxcKiMFsf9AWfCU1uF8JsqGnMp+M1HkCnG7XfutwvzCWo4bJXeoX5m3ysMBBGEo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=akbJAWa2vqSzwV6zpjPUptyE3erpuUugE4MwZ3tp8zs=;
 b=MfMRvkZq7umFodTmgJUxBy4yQvOaC5GwDIq1YwqzMp7WgmvJntN2frP7F+1DKjzJa3dwrzMA4n5MWJFwQprnb8JwoSsCoWRT/PV1qoXo5u2rs/VxF8+Kagq6PdJnxoomqL6Yz6JWF63mnTZUtZN2iLrMOb4gqEdcrKY1shya/CrazXeANurHu+O9HSV67HRvQcI+rKv3Z86NhbWv7AE6LUnYu8ewcaQ/hfRBXk52PC1k7kQPD+wVR0PYynpBwZ7gvFeUs39GG6ZjIZLsgpMUJ8yEnrWfuuFC4t8Ejc3aoY9B6cfE4CxihOzb1+2KN1GD0n4emoqIOS9jWUufQ0TcuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akbJAWa2vqSzwV6zpjPUptyE3erpuUugE4MwZ3tp8zs=;
 b=hbtaLBIsqgIXKuhZ2y7Gr8pdtt84beYxwbY8HGALU7N/32Kl5dKWAUpyZ1TBKlV5kd+Nqh0yUf3kN20ccllE9Mt0CZeh/VFo13lKWHj55CVoUA+qitjKbupQO4V8XjIrD0c08GYb/tHKvXugLpE7M4NvpuEtyEb0dW04gT7MOHg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 03:44:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, bostroesser@gmail.com
Subject: Re: [PATCH V2] target: fix the pgr/alua_support_store functions
Date:   Mon, 13 Sep 2021 23:43:55 -0400
Message-Id: <163159094720.20733.18176421723624507614.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210906151809.52811-1-mlombard@redhat.com>
References: <20210906151809.52811-1-mlombard@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e20b1ba-c51d-4510-35f6-08d97731edc6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4725711ABDFBCC55391C660C8EDA9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djII/fs9ntqDaJJzAqV5cg8AVjrfrVoZ/KbW4ok4UUIjFJEx4MwYdaEbPqUUcRP7jUrpYz85XTFFmfRqDCbqtZGHbNgJBwuzXLRTfKTv31mP1HHPJHRwGi7exzT6ScByUNu4MRqI7YOtsiWNUj/OGPDckQwODTSwO3p/NwZjrNYqRkQely97aA3xeKIdfJA0GnxcJAnJMdf5g9ydlnTuKlshoGe9k4FEBBCae1E4J93IxKpOQQwT7RnUgTpczgy6jAw5ur7lyJS43D4UDiBqf6vBh8c0T6VBK1zSbGz8Jb35ikMLsoyhUAjgqyeiNbejJLkRifsHlGPjFeUMTT3Tqe2s7vaW3U83LlYwbnOVYfJtnV/PmWDefcNlzBBdFFgF3uskm8qhhiuj5PDItG8OujulmB7FYX7rs/8msTjNkeTaqPUeoW5bk32iXy+OmNGhkpC17LnJvtgeu4jQubSuoKZxhDcP3rR7aLmF5n9kQ9VJ8Aty1rjRVPdflXLfBVH3fg1i3vLMp5nakDpme9UfKbfrPMmvK97vcchqysf/fgNma5wEju2wGAsNiHCR3ZLIebkvrbFqSdrZznMhjV0dPiYATKiwrwlfRGjGGWYFsvGfUwybJJc78sZAGGLg0P46sYyrda3OmbpawUoj+9tUwdfjCaJvSGGgLHpYkcwlK3wg7w21mlizXG8KAwuSNPGHlc67ozdXnycVE0sbMwh6dPTjSIXSX4B6X2UGK1U5qbcjHJjfFwZS1qjbEnH5a4iLAmMWQyRSdXLVoGT05y+q4ui9y9+kQUuS5KgTI2JiCWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(966005)(186003)(38100700002)(6916009)(38350700002)(66476007)(86362001)(26005)(66556008)(83380400001)(52116002)(6486002)(8936002)(66946007)(6666004)(8676002)(36756003)(4326008)(5660300002)(316002)(7696005)(2616005)(2906002)(956004)(4744005)(103116003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVB3U2F1b0ppOWw5c0xCZTNLSS9rc3d0Rjk1aHZOMlUvZlN4RW9IRXgzeVZK?=
 =?utf-8?B?Z2pVeDdtRHluQ05ONGxjL0FDanFlMDU4RExxMlVnM2JiN0dDcTJuU2FOUks3?=
 =?utf-8?B?K0hMRmhHdmprYlNVYkFhVVJPOVU0cUFpeVAvcXlaNEloVHhlRHNNMWJ5REhR?=
 =?utf-8?B?SHpxMGl5TXpLVUdLMnFYUlJUVWt3a3dFUWNDaWdVSUpXOFdMakpqY2NuMXpJ?=
 =?utf-8?B?U1k5YTloS2Mxa2VzcWlCMmtrdHIva0hZd0RLUTNwMGRUVzFqazdjaXd4SEJS?=
 =?utf-8?B?R1dMWjU3RDBlVWY0QWRlaWp1aVdNcENOTEdXL29WMUNyQ3M2R2Flb3JySlQx?=
 =?utf-8?B?RUVGV2EzS3FCU3BpTjNNWkczNmdoalR3ak5nVTZiYWVFSFhTYmNmSENiaHdm?=
 =?utf-8?B?bGFDd0VVaHdoRnB2TzhXNityR2ZwdHJOdU13OWYwYVlwWk51UlpRd3Fmb2ZV?=
 =?utf-8?B?SnE0akFwMmpVV0dnM3FJWDNRaXREU0FSaFNxYWF3bGdzellUMi9wU0dNbXZY?=
 =?utf-8?B?ak9nVjNBdytneTJkeVMrczN3QnZLMDA3RTZSL3hDbDZwcHFTMmxtVGJBOXlT?=
 =?utf-8?B?L0xXU0lPUUhXaGFuWHFoQy9WQVcreFNOWDRVRWpnT3NpNXpQdzBudFlpQUln?=
 =?utf-8?B?dDNnOUVPaENXQS9jSitHb2Q3UmJ4OHpyMHZlTnA2ZTRaUURJVEZRcnplb0dK?=
 =?utf-8?B?WVdSM2VSb3dSMDZqWnVqK2dDR1Z0M0Y1WUNBT3Q4eXJhRGlCRnppRml0ay9n?=
 =?utf-8?B?TVRWcnZWTzJBRGlrQjQ0Wkk2VE1rcGszNzdrMG5lOFZwU2w3NHhsUFlSRkpt?=
 =?utf-8?B?aXZDT1VXOXNHZW5jK1hOY2J4dUNvdlFmeXpKZ216Z1ZHWTlYOUhYV2xaSE1z?=
 =?utf-8?B?dXFFMDdDbzlETUpXYjhOSmdkSmFEOEVLbU9TbWZHa2xiVTgyak5jY2RGYTVj?=
 =?utf-8?B?VDVPU2NqcjQxTWxUN29KRjlKalpYN2xIdXFEUnlnbzVnVFVBV3NhenBHSlZH?=
 =?utf-8?B?YS9UdG1LamQxY296OG5lNHRWSWk0dDg5dWwzUjRyd0ljMGZldmZrbnFHdEVu?=
 =?utf-8?B?bkoyNUxtbTRqa2pXYUhDU3VEU0c2THgyWisybTRjcFcxQ3h0V2ZueXZ3Rmtv?=
 =?utf-8?B?Wm53aTV0amJwN0lhZmN1L3NUaEdpcFpEMGhBaVRXazF6dDlsemlVUFFBNDdE?=
 =?utf-8?B?YlVlQjZtOUZoQzQzMjR4S28vODRtQUF6akRFZlFzZnZWUUhOek4vMEs5dDhj?=
 =?utf-8?B?TW90b25hQS8wT3FMZUZXd0RoejY3S2pNdkNuU25UYllHMTF5QndrcUcrV0hn?=
 =?utf-8?B?aXlNK09xZWdWSnNSclNUZjlxMjdxQ09OUEI1OWt0SUdzblFmZnlQdUovRkd6?=
 =?utf-8?B?eUVRZ05STTRJZVlWRGpmTmpJZytnNURlNUU1ODlPVjZwZmJrbjFsWit6K2J4?=
 =?utf-8?B?NUVTTnJ1SWtleVMrK1NpUTN1czBySGpiQmZZNERRWHRvTFNucmxPOStpeCtt?=
 =?utf-8?B?U1NvRmYrY1Y1R29JZ3ZscWFsa08vU1VwU0QvbG5hNW1rM3FGTUh1WUxLZFlH?=
 =?utf-8?B?OFBVLzlPU1F1THA4SXVKbEJGOFgzbll3bVNXalBiVnZNZG5VVmtqa1lFUFZk?=
 =?utf-8?B?dkVEeWRHamlaOHlDM3dQRkhRamoxc01jZFJjR2FJd3FEb3lzUkJnOEs5UGF3?=
 =?utf-8?B?bzJqMllvNDFwMTFsMG91cVAxdTRsVHRvRFZFdFkyelp6b3R3M0hsNzYwQUtx?=
 =?utf-8?Q?BqoFynyOx+2uGppdhEUlPDZ85gop366Jkz9Grzf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e20b1ba-c51d-4510-35f6-08d97731edc6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:17.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQ9gT6ByeqjlcmwxaJe0CXc+8CBD8goxsVqQE+y2AQeOQABSQGk367uXG9+GAXEzRPj0DeA6QTlsyTGjdQIIFFFojchUNO+sR0TYS9g36Jk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=994 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: 1B5F4lIU0DMYKB1a4YkGW0H9_WZzRyUI
X-Proofpoint-GUID: 1B5F4lIU0DMYKB1a4YkGW0H9_WZzRyUI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Sep 2021 17:18:09 +0200, Maurizio Lombardi wrote:

> Commit 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and
> alua_support attributes writable")
> introduced support for changeable alua_support and pgr_support
> target attributes. They can only be changed
> if the backstore is user-backed, otherwise the kernel returns -EINVAL.
> 
> This triggers a warning in the targetcli/rtslib code when performing
> a target restore that includes non-userbacked backstores:
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] target: fix the pgr/alua_support_store functions
      https://git.kernel.org/mkp/scsi/c/ef7ae7f746e9

-- 
Martin K. Petersen	Oracle Linux Engineering
