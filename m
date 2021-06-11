Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48759C48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 00:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291C261357
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 00:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFKA4V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:56:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38878 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhFKA4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 20:56:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15B0rpl1186177;
        Fri, 11 Jun 2021 00:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OfrLvI2h/NvRPoooY5q47nfxS7WrdmUMrn0+l4DHIzo=;
 b=cWLOzLjRgAv92n4Ukj7cfnCnBjEUU7ObEvLNjE9huqDdHaBS7/imzsrs6PQHJXA+nXxa
 SXmaqhCFsN0qYF4Jibn4b80OrUZH9Bx0NOgvFqvwh5L6hXe5Ep3ihvDNNepExJJUyJS6
 7kDPhpWuKboHMm2q/RBSQsQg1kMpf1Y19tq2kqLQ7/uhKBCVKtkvnQY0GC6eCJqD3C3d
 jfKHiMG2sZMx1KTFO7dZ3e7GRO6MRl7tC2C2RAhQsjULcoEjW+53wnhCYbx3t67R07a/
 ZuxxQMkAQzMIWOLK4NrrEFYs4SWKbYhHAOEA1f4r1ZDkJHfznYoKoUnqmwM/XTvmPFsH mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3914quuuke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 00:53:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15B0oWqW174515;
        Fri, 11 Jun 2021 00:53:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 38yxcx37p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 00:53:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktFKql5qPsdaTT0IQG5PcrDSp7ehSVkstis8ZONjlDrHTowcjP5Z4kgEEPcpRjO34F1wvsaBsBY7iIzO8CCJIiwl+AB+zKjC5dcFVTILJJ8k9D9NelkB/rfPOBWxYTmP1RHba3aHVyQdWO/CwGiY0z8xb8RyOwLk45SUzJOlxKoKZklsq37HXmxBupj4A4hgHn5reJ6HhhRGFF9jjafde7B2HyNHWb8XUpjSUTRiQnvCz0HO6cTzTNJQoZgSbmasK+yTS6L6GIvjm4bxWDO+Um07ndG36HjhNo/S2zdykZwdPAqkvWVmok75mkAzItDdSjZZzo3S8o14WZvMSeHffQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfrLvI2h/NvRPoooY5q47nfxS7WrdmUMrn0+l4DHIzo=;
 b=LK5P0+R1c+EhhJEs2c1tU2KbmOatkGnmT7iSINU4atl0LC0pEOwbL0Uj4Q5jidYStRkHhjmVSP+x0sJm238NKD17R+Y5pvRPQqvP8lQ3VL0z5SDrc1vH7+1u19tNzlN7r6kLquSwlM60HcaI911fwQhKwlJcEUx+kZMH7GBiJVGrlcPxbd/RCFXoJxK6dYnEaNdUsF+sHEPpgWwlCLHxKGIjVCCSkoYfxt667a2hBh52L4Am7DtR7Iyvl7NOybsuTZmHR06i5ICsIjgrpU8eTQ2W+As2pX4K2anSQN+A60TGJNERZ4XoV5d7UVt58HM2VUghTXvlP72WMkFRMhXIzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfrLvI2h/NvRPoooY5q47nfxS7WrdmUMrn0+l4DHIzo=;
 b=W8BVzLYDu+oX7FmS9ofr8B0wAGDvNpC0wrgmDSoXkq/YUmoBS/HxqF1TDdqBTYN+Aw2qV5ZmXMY/UyDlYhShG1tZbkMwjOMGlegTvrxNZBR9/dZK2XzBKvZN1001EBsVHRljrIBbIq2DVEQJ6qAs5qAmMXzav9E50/atmp59YRY=
Authentication-Results: orcam.me.uk; dkim=none (message not signed)
 header.d=none;orcam.me.uk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 00:53:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Fri, 11 Jun 2021
 00:53:53 +0000
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Nix <nix@esperi.org.uk>, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PING][PATCH v2 0/5] Bring the BusLogic host bus adapter driver
 up to Y2021
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eed9cjkl.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
        <alpine.DEB.2.21.2106110102340.1657@angie.orcam.me.uk>
Date:   Thu, 10 Jun 2021 20:53:50 -0400
In-Reply-To: <alpine.DEB.2.21.2106110102340.1657@angie.orcam.me.uk> (Maciej
        W. Rozycki's message of "Fri, 11 Jun 2021 01:25:36 +0200 (CEST)")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 00:53:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8321163e-22ee-47d3-9606-08d92c736280
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54194AFBCA6E586C21179C9B8E349@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EHvMYZKVQCwF8qhpSeultS8uT4u7GygPHll+omhmknoSQ/Trt2+YZ764BEqwgsYHQvlbuT0NSH+PMBi7+Zu//yets0UZX2PSmfO2PeSZg90isfardCRi/uMbu7zGcdbZhSHPz/PxhldDcdGawfFrbQLoFHHJxnnWttH1tRe+9MZOvRuAvA9SwIE5gLuhqQwBALO6wfCo9Nbq2tEXvCs5bmo35gzLKyvCeLh+K8n/PR1e4ts1+gbVSqU4M1U3laITcG4v0v2SF92hKvebNldwdLTcetOVVBx0Mc2BH7yFoQBKtvTnSbHSaihHr3HwISCeL8ebQUYhIB3FpY6xT03kBPpf8Jztgk0RIgUk2reX5A4J3B8LerhMmYGov0Y6YH9CJZmZmn+Sdw8aFpTGq2DOiDFiFuJDnsQH3A4ZkOpR8UA9vZV/iOd5c8GXcRRxCTGeE0G+J5Jr9/dTuBdHHAYGQbcoisaCgEDw3HNkb7OdjDVsiU9J/m+Uq/hOi1VooRi1zjU0c8DHwrLNc3qSp6A2AxJkXPydADBVcfM35mXSx9R+UYxVSMNkIpRbMy+B7amBgPEo7dEwEYAgW8uHwJ0MxywUso4Nhv42XkPlcVb/lzJRLAaeZLd0pjZUNF5lMnqhiB+gIDcZzv7Qvd/Crqr7ZJvCPTiQRQBLxTNJNmmMZKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(136003)(376002)(26005)(6916009)(8676002)(4744005)(83380400001)(55016002)(2906002)(66946007)(54906003)(7696005)(316002)(16526019)(186003)(66476007)(86362001)(66556008)(38100700002)(52116002)(5660300002)(478600001)(8936002)(36916002)(4326008)(38350700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MRcBCqht+baB+AR8bVepXoP4f9hXfvSnIUHsP1+0/EcFO4fxdUOH8u2w4cW/?=
 =?us-ascii?Q?B8lEWDds1ewAD/V2CuAMziQ7nAiBd78uGs1YguQxtG4JDAW1TAA84h5uUPc3?=
 =?us-ascii?Q?MEcbj98NR7SGQZEbi0U+WBRtI6f3H1LM4J/uivVP9nr3RtVeayvmzDkHwpYF?=
 =?us-ascii?Q?onj4ElSnJNz1ABl/rY7KFEr0hXYtEFGFCMjHnEZINHkBSwWQSccWeA6ecHwb?=
 =?us-ascii?Q?jKlWZyX3xTUH3aqfJvIKp9GOtGm15IEzZ/g+/Shpq24sWS4gb1Cw67L07sPy?=
 =?us-ascii?Q?P97tLMTtfg5yrROHfJzlSbxWECTqnWzDJtJRL9trD7KqAFaJmqEcCCgT4Ebq?=
 =?us-ascii?Q?kg5ioQU8+UZEkd+4pYm6Pkxp+P4vDTrJwWWfaILq2/3jpgf5ipX6vmYCcJF3?=
 =?us-ascii?Q?oijFBhudbprZkNuEN/VyD/gEFpnMvi4HwXjQLeaMjH7LqnZGEdm1Y/Aq5rl7?=
 =?us-ascii?Q?1xnHxhN0jzqPB7wawrpiZuEFZrPMJViaxeQ8jeKRcHKqlFzkahYtEpGLyY7S?=
 =?us-ascii?Q?h1Ashd/zBY5wxFwgsc2uZ+bLyPTcyLLmyh9MGGN1Cv7d1oXlTJeU5K9QYLxY?=
 =?us-ascii?Q?+G9LL/nVJeeSYQivFReNLgNHx5mzuoAlUnKN8yTmPh1ENeAiPEm5HX9XGzwJ?=
 =?us-ascii?Q?lOvpvgfEFzI9C3daUjPWOR5mbL+X1tioxn/6SvonZE0OOizJvtGOElV8Mcog?=
 =?us-ascii?Q?OPvtNO6XXEBXvUIkIID8VmhJJG4e5Q3qhGXhQgxE+3WSzVxiDOesCrjgkXZu?=
 =?us-ascii?Q?nHIbsR9UPpIPiqPLoANDuxyrgk+QTYKrIH1yvhOnP5PVWA9f4EpwnG9TXR6i?=
 =?us-ascii?Q?RbwtCQNBfX7swREiQi4DZOa9Xt2O33mZ72zGWQHI1LxIdQrSukyfvWfA7BAh?=
 =?us-ascii?Q?JYTeEy7iOpSL0FzPLt6DfeUHjjE/f0oMAadd+bP1mIDYGFywyN/Vk3i7PlaQ?=
 =?us-ascii?Q?TzmufLVsabKEwtC9zw40PIKkGYpNGGEsThiE+HmBJJBks3nlofEiWJWKiB88?=
 =?us-ascii?Q?eQmz6imUysXG6xi0ypmQbFPJR3cdQ/PfUYd8Tp9za/nV4u2xSjAbTE+bYd2W?=
 =?us-ascii?Q?bHz3Y1YtVPt2MFS6ZpcwWSM7xB5ooXqSjPLOaGZky1Q8cGDgkUXNDVJ74fI5?=
 =?us-ascii?Q?R48tCNBxwaMrkPinisf2CG3rD+R9nDTgOKQrnzPmn1uh03CthlAzmtX1Lvwe?=
 =?us-ascii?Q?aWKfeqxmcS1xt8qButAuTbnU/grcU47EAjMYQ5CtMG4aYG418LS0W8pdaOMu?=
 =?us-ascii?Q?YovB9KePB4PyAdJy5aKvFpxyOQkGmVzUpYKyTrgokw8KNvj0rVeyElsmZO8Z?=
 =?us-ascii?Q?riPnUcftkc0/BJDtrXTmXTte?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8321163e-22ee-47d3-9606-08d92c736280
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 00:53:53.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QR467b5ep2iDFfk9p3usgKIvcMB0OROONw7Z6Gvwb9sLcWK5AvbNBFrQhNnolKk/BkDTyR9Cm1pQrM0GWi6tuYH4CTbdzAbXv/9E/Ke9MQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110003
X-Proofpoint-ORIG-GUID: FXL2kZajWEn59b1yMD970aGB5NjzVVXd
X-Proofpoint-GUID: FXL2kZajWEn59b1yMD970aGB5NjzVVXd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110003
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Maciej,

> Where are we with this patch series?  I can see it's been archived in
> patchwork in the new state.  With the unexpected serial device fixes
> which preempted me and which I've just posted, moving them off the
> table I now have some spare cycles to get back here, but I'm not sure
> what to do.

Some of the patches were clashing with my device discovery changes.
Your series is still in my inbox, have just been swamped with testing
and integrating several fundamental core modifications the last few
weeks.

I'll get to it before the merge window...

-- 
Martin K. Petersen	Oracle Linux Engineering
