Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B543FC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9341E61439
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhEZEJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51780 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhEZEJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q408fp185050;
        Wed, 26 May 2021 04:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=CSxY+7lN9HFeSoAt/O1b+M7rA5R0fd3oJUWMqG3FHaA=;
 b=OVs9jMBy2gfUFum2basNxlsR3krD0mAv+FgmFbi9rIrSMXl9PJlVbpNAumaJ71yxIRSi
 6XCnKS3TscksVolLUMguAJtESfcHg3B1NVTI44osgg/krGq1r9RJidgrZ7+WyRl3CHDB
 H1S4zVmNkHTrP1FIzRgpwMOIWx7xEjRuZPrM+6d+MtfA3/Jh/C3LQvfRoyywbF7wHRmf
 wnK0vzaAYqWbR4xaNqDcGrKS3qSheWindXkADeuT+lVaII+kAIlAhrb5c+S48DAQ0YJO
 sG8uSfDc/xiJo+6FzqR1NUV765xlFCR29GzcG1dLQ+SFR6wx3OEDrijPKbKDpsX78v7+ fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcftex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q465TM164130;
        Wed, 26 May 2021 04:07:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 38pr0ccmg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mzf+Yj6Rf/mWGGc9WQ5BRqaTSAheLDmpSP3VF0u2aFTumdPXGVZPR923MEVd7leTR162/M6g18qX2bf9JmAb61rHIxzFPP4it+Tj9GbqVsSJbpWwJU8i/7RFPeeS9cpXfweX+INkPc0uxUUTKeBFg3Gu3z2Y561y9t+Aea0/InVa6Qq9Gz7H+FUZPxI743EuwOKWO8yUfFfyLFbs/cPVDjyOz3kghDynusmsfO7NZJ3O7Yqslw3Ni4D9uMAMevMk0WX0gcTI/G8qQqEuPHx5DibZc+r1kFbKUR+U+7qdqqY9FiD82YZPNWzzHdv0Tn3De25PSEgTmDWcGoeQxNGHjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSxY+7lN9HFeSoAt/O1b+M7rA5R0fd3oJUWMqG3FHaA=;
 b=E1A6anL4YhVSjAxO54uJkxdbNxBTj5/bYsQ5vI/Q1l/9SIT6M0T929HRXpO0ykXL9Ox/fgLy2sc443ACL91XqtUJDRqIGuCpl+f7TICIosEj/zX9F60m6eiYm/ceNi1LKBgCpdWm2cyWPczGZbmZPP5EZyIqGIdOlHC158Sb2vOgywqHQPzqeiuCN67C7OdG7pRRCCEGC7DEZxWWD8dlbXEfredNsF4AHtv9GGxlPYUDV7Ere9oIxFdagfT0aBb6/7yRLHihjBfkpWD0MWPe7vl9nTh6dFijOFpSfuxmnhTLa7cuamm9AT7f0ORPGm3FMkxu1xChgfSuegtx88SCCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSxY+7lN9HFeSoAt/O1b+M7rA5R0fd3oJUWMqG3FHaA=;
 b=bgY5mkTHg1z/hv/NITHS2hCjNpg178DpyP0OF+fAXe+LolUpu0Pn0a/6wrDYrqKNcfx2HdB6p2TSPVunCThW/sJlg2kZwUH2v5aruuNWilCyzx7b1E6xSmzGI9uogcT2uTKl1ZYo6XHvPTjLzODOQA33szJJFKj7RC/fVXun2f8=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>, mwilck@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        emilne@redhat.com, James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: alua: retry RTPG on a different path after failure
Date:   Wed, 26 May 2021 00:07:29 -0400
Message-Id: <162200196244.11962.12133907404367804581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514153214.5626-1-mwilck@suse.com>
References: <20210514153214.5626-1-mwilck@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35bc9c72-0775-442e-7664-08d91ffbd4cb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB446915E5F2B4070F2782AB798E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScT9JxItVcxM5hOjD6nzmrTqa1Bk96g1Xdb0K3huJy+V7aKqTZ4du3dYu1syADh88oQaVcf9Qx+zJMegQGH4CwsyM6fEfT90quCi4Ji/JnooAHQk6jVHii2vFq3KSFdbE/a+mRxpzQygmFKF6KXK1vo/3ls82E0Vk2p9ZOnZD8OOjgJdYn/emx26tTi993j19+cFFfJeVk2Sjg5Yr/gptNUm7+H6rEGq0Vwhv0gdnRPHPhjh2uKjrxeoOyazRiJAcEqC3+eZMF87RmGqb5KVCbPz21jbORfQO+AQAAq75v6/m3XvvCNU+3KJ9HCXpWJ8unBfPhNDpakC3zbFUbHKnA9jBJ5+MVVv/olCxb1emy9ph/r27tWxkoDAPK+XBCj5w1V/07LbZQvZnQUcdn4bjNdds3hiZSnE7gUhU4bEADFCjUm7/4XAhIpQ8l4bOwd1m2PTspEzBrhfK4+DbB7/jSk1oxpAIE8+Ji0GTFCRYzc+RmokXUp93SIP0+zQLGbPghNPpvqczs7Po1XADbJoXpvdT9cuZKlWC4wBUuiA94bmAFl5o9jyHOwoxteCsLuEROv9Ckm+iKCVqwfbDviq3VH/SWt6IOXGqECxlOTBtoYVU8huIXZO10cjlFxgjU+3QmJv6dHid6hJUwstPDPTJubj3rvN4vaDLL+7kQ1GXd4M82znRt0baVHRX705G/F2QN4KNdUvsWiyFN6k4SxisWtB/7cxdZKty9MLD21oWpDOlSfEZQBeHs4EFmYpTqhhQszAfZ43QAKlC6szppXOkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(54906003)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d0Y3Nk94eGpQZ1JtZWl4MzY5MWMxbDlDZWYyUjRQWDJVYjVya1hMRGF4Y2Zx?=
 =?utf-8?B?MjhCcWpBUDYzZDBLWjVEOXN5Q2Y5SmFsU3FjckFrK0R3T2R2eG42VFlMUFp5?=
 =?utf-8?B?TUdva3pVMytmY2tLR1kzOG9PRTZXSDBqY2c2cWR5RU5ydmxsVTZUS0Z1cDdO?=
 =?utf-8?B?YktGYko4elpKYzFQNzU2bFdMeGpzM0JucDJkVXZicG1QcnVWSHBERThldGtt?=
 =?utf-8?B?VDVnd2hKSUJIMWx2L09pNWF0YWlUbHpzTDN6SmpJcHlwdEFCcWVFVWpvZ0VJ?=
 =?utf-8?B?ZU9pNkticGVYb2phc1k1Tm1rQXBiOHBIYXNPQzVZSE1QeVd1RzRvaXFlbjlV?=
 =?utf-8?B?M3FWcVNlRi9RdkpPL29GWnZ4b2IyTU51T1EzR0tTUlYxVDRPTllaT3diSXV4?=
 =?utf-8?B?SkJibC8zQUQxeDd5MFNWemU2U0hkUFZPUjFUSWR1UjFFOTRIUTJIdVo3cVVG?=
 =?utf-8?B?N1FtQTA4dE5jaFl0Nkptb1k2SHA3NnFmQzdaY2VxaXFFcGNJSk11L0hVOWdP?=
 =?utf-8?B?QUZVL3dLRmxJUjBrOUpyRnYwdmViVXp3c2U3L0h6ek1HZ25TTzJnRThNVWt0?=
 =?utf-8?B?S0ZVaUozOGVXMkpObnhTaUlpeHJ6MVZWVThOcEs3UFRkRU1xSzFWV0lFRXBB?=
 =?utf-8?B?Z0dQMWNBNktuUmhDc2lKWlVVdVlLaE1DK2ZQT2JlVUMxaUhxOEZGRVlTVVJZ?=
 =?utf-8?B?RDFNM25UVVFMV0x5T2llSzBWUlFLM2RnWVZHcGV5Vnd1WFMwM09heWpSMkdU?=
 =?utf-8?B?VjJxUkJ0b1RVNW9nZjIzajVzSU5KamtidmJoWVJFUkJGUm1icTd2Vk1PSVJn?=
 =?utf-8?B?dVJFdVlOZ1p4bEh6TUhCQnNPR1Y1NlE3T1oxSU5QQlhXOTdjU3A4bmdUQzJV?=
 =?utf-8?B?U2lRYjNKNFRBVlZhU05INjBJT2JsRmdZZy95WjJJSFJiQUg5dmFSKzhvcVBl?=
 =?utf-8?B?MXV1NnorNWVXZTNBUEJiUzAzZ3VxRzE2RWJac290VFpXWFB1ZnZJRjBOZEFl?=
 =?utf-8?B?Ty9SdFFicHJvQlppOHQ1aThtQjF3elZVZFdGc2FTS3NrcWVDSFhpb1ArU3g3?=
 =?utf-8?B?TmVUUCtJSWN3Yy9SZy9BUUlJR2JpNEUxeXRSMDFDNWoxYUJaNXF0WGlScnAw?=
 =?utf-8?B?dTBOSVlYZUM0U2J2c3NCMkNUcXFPTUxmVXRJYkIzSEowbXRjN1NQaE84NzBx?=
 =?utf-8?B?SDVtaG9kTWh4WjMrbUNycFdXcGhZZldhc2hOamlxYU5IMlVLMFAxYWJ2Vzhp?=
 =?utf-8?B?K0pZU1VXSUdnNW5kUXNhbFFNT1NMYlJiMlZGbTlwZFRadXFERmNFM0tlSDhF?=
 =?utf-8?B?WVFuT1hwM2tQYjNDL0NFWnJUS0lTbGpjRlhLeWhFVkh6bEJFaS9yVWV0YmFa?=
 =?utf-8?B?UGhwQTkveUxvYW9SWmF0WGRTU09tWFBIWkFYcHErcHp0alR0U1A2bDVtTHJi?=
 =?utf-8?B?RE5tdFBEMFd4TGFDZ21NNHpibEVLeXBpOHhaMFZ2aW9YZ1ZlS28ySlJVUUd4?=
 =?utf-8?B?UzRzZmZlWGdJOWZxbTgyMWs1akFkZHhYYnBCQzFDcjdrNWR1MldYV0VFcE5a?=
 =?utf-8?B?bFFiYnVZYldkNTAvR0hsNWJpUUxyQXMrRTZCaFBCeUxSN21XclNDZDUyb1lK?=
 =?utf-8?B?d3BvK0MzZjFQS0NUcFlJc2dtN0x3VzJIRTFqTFEwYS9JQjQvYkx6cnV2VEh1?=
 =?utf-8?B?eXRFVk41SHZmK2hCaDlzRk1JeVkvYlJLckRDdkJocEF5MGY5alZoSHIrdVdp?=
 =?utf-8?Q?riJH+MvyyUHOiVEE2QDmk4t+bCmcu56enhgIus0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bc9c72-0775-442e-7664-08d91ffbd4cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:51.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFiNCB1gZgsmb+jAaE8i3wEthLIG3aqDnZ2Zd7pzfbb5bdSS6QD9774dUPOyyVCNNbEjZ9iFXViWicJusOpUsnuNj6eLNf3qdq8nbX+68jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: X3KK74AyMdFh9LMFqNb2VnSujgcBBksH
X-Proofpoint-GUID: X3KK74AyMdFh9LMFqNb2VnSujgcBBksH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 May 2021 17:32:14 +0200, mwilck@suse.com wrote:

> If an RTPG fails, we can't infer anything wrt the state of the
> ports in the port group, except that we were unable to reach
> the one port on which the RTPG had failed. "offline" is just a
> secondary port state, which means that we can't infer the state
> of any port in the PG from the failure (in fact, even the failed
> port might still be in "active/optimized" primary port access
> state).
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: alua: retry RTPG on a different path after failure
      https://git.kernel.org/mkp/scsi/c/ee8868c5c78f

-- 
Martin K. Petersen	Oracle Linux Engineering
