Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ED7C4707E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B446135C
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhEVEmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhEVEmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZN8N056382;
        Sat, 22 May 2021 04:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SVDTBOjxIsbh8XPs40V0YFue5VaPRBgZ5Vj1froetEk=;
 b=DAnF2CN4126JyIW93AXdZQ04NQPmkWhI4c7IoYNDXx27la45hd+hI6f4q8giDy7E7YT5
 BmpF5CH9HfFd8hg3h3l+OKI4yTQbWh7hZ6Ns+1mLIwuhggmnsjVAv5ffodZbn9sbx82R
 oEtSAg9f84Q+kwhuIaxhIi9EPFTaa6J3VdSJaOcmBynGi/QRRh8UoRYxLOgzwjrtpeM5
 kh/ib4yFTJS101v8Qh27wkGuICGEO2jF/q5pDJMo8j8bi9UpGYBEU8BHOWBbBDx66zov
 8iaHm1XiuK2C4VLWrlQMcXwkdLvzlbf9k7GY3kclZ/atDl7uFSGOWsvgsWfj21aUy/HT 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38pswn818g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4aljI072530;
        Sat, 22 May 2021 04:40:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 38pq2rp5bv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqQearK1OFdCq/WF9Wyi3LCcOwdhcDYwXkyUSWWEKlUnSnOPlEbS3jaYgZj3sni0rArgD6F+Y6tzL8SNDBjKqcIMbEmvdFVS0eoBp+qYl3rIDjSzT2PY7YxSXKYD2DauGVwgH1LqWLFLYO6p5HTB0TlEZxH1Bvxf5SF3oDub/YsIsdT8Qbq7BxOZzYj120svec1jc6Hmqz6CZe9T6umec97Ye+JuV6jlRYA4Ak8s68t7Yi81kubA9u5Z81wC7AdMqd3Fgqrcf3vMUBLgPQrrGKAU8HdX6BA1hJp8MNsJSVAqGAXGVHpc5mbDyVIBSCtY/sYv37OTTsx6z4GQ8DeNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVDTBOjxIsbh8XPs40V0YFue5VaPRBgZ5Vj1froetEk=;
 b=oOwvIBSS/M3KUxI32X2ilEhtkr+zjphk3YREU+JiM/YK3zbzyVyasKv3M3sQpphKdiU3/nVwAdESmnI9cZAlMOHz6AR5D2o4em3cjROC15xCEySZE90VO5Mh3SO1ZmDu0cug44l0J3cKpE0M2RfEjCkAmnk2R5dlUGls0wNbRZPTD5Qqd01YxuVsg0PJgrRGhi/GMFeHhzr2vqToHy3/XcRh2nM6vgKc9ElC3/ioHc9xTUobMj+UZOSddd5opcWMhGBk1pzjmI61IK0bAM5FVv75LAmFiwt4rFReufZlW9lmSyRH+e6e4u2wWJdYnDENb23TkVHjf7EvTe8ogGOPyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVDTBOjxIsbh8XPs40V0YFue5VaPRBgZ5Vj1froetEk=;
 b=gtMv7cgDdySdFCNThOmAtrISNGmoc07042LXrcYThtgMOvG9YcjVm07merB0rOayvOC2Fm03vTpTpgcxbhWpBbmqVsUetVmi9++qD+1Bpb3iYnvlKCiJcs5pwg2JkbcUcrGQIfOQwxV/RnwjeqeGFee7mSIh2DZSQ+JRnyU7UO0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@suse.com, jejb@linux.ibm.com, trix@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] aic7xxx: remove multiple definition of globals
Date:   Sat, 22 May 2021 00:40:35 -0400
Message-Id: <162165838887.5676.14999074050933925606.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517205057.1850010-1-trix@redhat.com>
References: <20210517205057.1850010-1-trix@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49c51341-d565-47af-aae9-08d91cdbc4e4
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54811B35B64737AEF54A599E8E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8rMoY9Q/d5CpTAEfLCnnxKxjWw6/vSCb7D0kh4DMr6Z+9yrOSL2c/DbRkj10vL4TKheL5VwqDqb6ecknxUyz8RQUFKs2h5hvkvKgyFjy+OLMZcNWUFMUtCG19bE2X9WbAEPYUUvnIE2H1e6nDqbXsgDK3B71P/oOBjfNFoR7mWV3CNDdBrWzJ09eg1UOVQgOvv0cUNvIEJ02Zo/URNR68D/xurSf2l3npdmyB+N31EDGinVtNhnkoQ5KVALNl1feDtu+sWTlRd9H24V3yR6xnNZk5YVI/D1j1qRdiLQ6IDrw+/tuF1F8aRFQNxad1Xh8acbCZypXUOUjQhYZzHsouZ8GNE5vVO2hS9G4A5O4+SjtcH6m32/ZTyubNBAwRRNru/ZbL3UbOs/Lx1s99A1nsNZ4to3vj5gakWgFmueo/aZff9ed5c/kvWFwE+w2yvYGAxyLn0zSUPC2EvVE7lDTy7ahpUCaln+QQ3BwzRii7nRQcwM43UfcYaPbvWgbrHJZ4ri9O5pjuqLf+kguv+A8CcWC99+uBI6343D15QGNEQ29K+IsYG568BBEDp3YS97cg3i3QEIVMU+ZQYyvmfl8tuze82XqqQ2/Pojf0YZWhUpor0jxcLzEAxHHOCJH8eVJlEKmTrX+GmHKc9W+i4ym/wQ22ZM0d8KrkwFCq2uY2jTdouLWoVJb3RRtDpXOGtqV05wfT6Os+fK2OyTNB41xm+788jpuSt9s5jj5ECz7tV0cXiqNFpf/BwnPnVsZxElqv1jz0me+8ShBA4kixRNsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(5660300002)(2906002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXJUa2d5YXJtaWY4VUM1Umx1VTFjZTRaeTc4enZNdmt5dlovNGNVTEZVMG9P?=
 =?utf-8?B?TDhPczVseVp2ZU5lZG9taVMxUG1aN09vVTlYa2E2NTJZdFBjekJ4ajIvSnhV?=
 =?utf-8?B?MktyU1hFWVJEaHFGbGNmSlorcVphbVVTaTlNVTRCOHQzOWs0WHcvWFpHdUts?=
 =?utf-8?B?eFV6NWsxYlJhTDE4eDNQVWpkQjJsVk0ybGI3N01ZaXc4b2I3VVhyK0Jta3p3?=
 =?utf-8?B?OWdkeEYybXg4bVBaUG9OWGJqditBMGtOQ2ZCYXBtVXU3cTNpUTVDeXF2bEc3?=
 =?utf-8?B?S0oxalc5bXhaU2ZwQ0laeUFHRnI3NXM4UlRCNk84emJTTlBYakQvRWJFekNv?=
 =?utf-8?B?UTZaaEVXemxNNXYxdVBEZjFZcUhVU3FkTmRtcXo4cjBaNHIzeTI4cUdyUEVR?=
 =?utf-8?B?ZE1VRytpSk9LMTRCanBFT0JIWUdJR2tRRG9IdUNNWXFyRFdqUGFydXcxTU10?=
 =?utf-8?B?MFFaYzV6eXBkNGZ0NVNIUTJNMGdma3FaNkZXcFl6M2syU1l1bDZtYlZnbW1D?=
 =?utf-8?B?OEcwcHdpUWdXTGdKNXQ2bG94cXhwYWdTTHJ6TE1JVkFlSVpVdWZLYkhvU25M?=
 =?utf-8?B?cGRqUXh4SXdnUjFQcUQ1bmgyOXNaVzAxbTdMMTU3cnhzbFErWCs1RllVcDZW?=
 =?utf-8?B?OWMvbG1NeTRCS25hWWdPOE9BRm1BcS9nc1M5d05nQ0luWHdWRzJmdEppMk9S?=
 =?utf-8?B?R05RdkV1TG0vdlZLSDByNGIrMlhLbHh2MkJXMmFodk85Q2JOQzFtYmxlM1c2?=
 =?utf-8?B?RVJYVkhJN2JlY2pzRWg5QWp3ZTNOTUJTK04vc3gwc2lTeS9hNDJ1MnRkUE5Z?=
 =?utf-8?B?SE9ISHlObWFyMFBTb0UwdjZsbUVEU1J1TkNRNzlsZUpwOEo5K01PMFZZWWZ5?=
 =?utf-8?B?M1BOWjdRdmZtdTNGRld3ellWdHVBbFI5UU8wa0E3aXAydWZ0TUl5bmhSR1g2?=
 =?utf-8?B?ekV1Mk1Id1hKREc0UVFKc2UzYVlpbFlrNVE3MlZVSFBSRHptSzNaMVU1SGN4?=
 =?utf-8?B?RGM0ZHNEZ1FmbG1LTzIvY1VGT0xhNnh4Z3o2TDRxRFpsbDUxNHdVN3RrZHpD?=
 =?utf-8?B?QjFjODI4bzVDUnlWSURyWUU1bVNjaDI3cVRXZVpKeEo5V1gwNUc2Q2kvb1g4?=
 =?utf-8?B?eXc5MmdXOWtLdktkcDNWTWxRQWhOT3FKaUlUei9yVndUV3NMRTRaT05GeCsw?=
 =?utf-8?B?ZzdQaCt5QWdJV1NUWFdiNEVrdnN3Q3dxOU1nS0JPY2ZBOFA1SkFJZTNpTkty?=
 =?utf-8?B?K3EwRVlkY0taR0g4aWV2YU5QVDhXKzVjekdvOEk4eDJsQkZvNVRCa0VLeC9k?=
 =?utf-8?B?SzRhWkVyakUwRkY1ZVk0ek9FSXRWdVM2VXY3WThEcDZkdXF5TmI2Mzc4TlBk?=
 =?utf-8?B?UmcvUU1qVHBFY0RHVlU4N0NRK0JiSVo4ejZSS0dFZ1RMZGFHOG1td2RYalg3?=
 =?utf-8?B?MjdHd2ZJbnhUbXFTZWtORGdiZmphMWNuTWsxeEVuaWw2SlQ5MHpBaWtaUjNK?=
 =?utf-8?B?ODk0Ny8zaHU2OExEQU1saXpGQm5ML0h5MExsdFh6RXpmdEJKcWZxSVljbWsr?=
 =?utf-8?B?NmtqQkxlWkh0RDZyRG1STjFvS01rUHg2RmtjKzFPYkF1TjNDQ0hDL2Z5a2FP?=
 =?utf-8?B?b09UaFdHWWxnRUdYN3lYOVRhTklhYTlkWXRxenNBdk94OEZ0RjdycXZkMHdk?=
 =?utf-8?B?SkxpelZVNFlwUm1VZEkwN3dIUFM0YWxuTXJBL3NkL3FpRWFCYzBYSTJSNGhx?=
 =?utf-8?Q?7feOFFiO3D5m1nj2FiFCrCsfk9cnkTiL0m9dhHg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c51341-d565-47af-aae9-08d91cdbc4e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:47.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izQH1Bh9koUUrkwqSHrFl/iGxgHGABCli90QXAfsR4Jabptj61U/zbdtOPRaaqQTV3zkXrk499veWKl82LwMtYmrr4d2WYTRmESYCyQtSJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: ssprGEnw45a6ZqK-3EU6B-seXUnoFJB0
X-Proofpoint-ORIG-GUID: ssprGEnw45a6ZqK-3EU6B-seXUnoFJB0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 May 2021 13:50:57 -0700, trix@redhat.com wrote:

> When building the aicasm with gcc 10.2 + gas 26.1
> Multiple definitions of global variables cause these errors.
> 
> multiple definition of `args';
> multiple definition of `yylineno';
> 
> args came from the expansion of
> STAILQ_HEAD(macro_arg_list, macro_arg) args;
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] aic7xxx: remove multiple definition of globals
      https://git.kernel.org/mkp/scsi/c/b4de11dfb569

-- 
Martin K. Petersen	Oracle Linux Engineering
