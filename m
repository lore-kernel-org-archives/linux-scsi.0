Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE256C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB6761154
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhHFDDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 23:03:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12570 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhHFDDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 23:03:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1762v2OT016672;
        Fri, 6 Aug 2021 03:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=018H+h7sJCAbIcj4sphYTv8ZTPUilByX7deJ562iw5M=;
 b=TfnOfGzQzGM1N5pFMHssIX3LqEei/SyJUKknhbnwsUchfkQQTG9zpSjPMLmpqG6bHolw
 GHK1siQwfwl3jOSA2bDCidgz0dXR4h3kY5TrlLScwIz37VheCM4sGne+XskPe+8vad65
 Hhd6OqGqKYNSDWm0iHGkZrMPlSaLq5ZRQrKZRoFEUd33NSQBKsW8ZZiCE3eAPwAc9BzG
 3YGaFbnWWfofN83HvFNaCwS4s8YrTmQjbm8L7thksKaG7mCB8lgAmJZPc3zghzbSXqIf
 BQJAecToet1lgNtOo+rrVuD9waPC0jTOZAieLqPKJ558FPeK+TFHByi8ohGBoaRVITaf 5w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=018H+h7sJCAbIcj4sphYTv8ZTPUilByX7deJ562iw5M=;
 b=PMOn4Bdvv9wOgHNRYMQ+iRV0TxcksLnbjb00HKIhNrzstSHiESvDcot5cVyMY2LJnd6s
 Tb4HeewOdULTcfzbDRbYOU1inVmZQtRubBFTFGwDB4nvESS+zU+BiJ18fJOFPQrUhklD
 uA9itg4B16eRf0G2l/D3kY6GkK/UnWOzJHejvFNrHSptFJVFc3WuZxeETToxI/i1AcaL
 wCnPxG0dyxT+d5SB4FqHWOpEtW+yebJfiIHauKAYpmwMWcgCLisOPP+TywbcWpEg81qh
 kVUnGBRjYDOKsliID4iIM5bji5uL+yrSLGa+j9TIzPb27D32e9IX/MdEq0DiWTbM1xo2 eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubts1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:03:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1762uEW9047989;
        Fri, 6 Aug 2021 03:03:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3a78d9rjs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:03:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bftalp5orHpdYInJ0LcPa0AdXwPLPGoZPFeTxeoj3VJyW2P4QofLoSFImP5RyySh0+PLuyXXzNU6ru4yk5vultX9ugas3CHuiBTPMkxIafYZa6aR3ud4iSZ/EXkR0L9d4SVNGbHMJmGlBQmWSXjE0gRJ0axnVE93Vj0zMSYuvZ/qT1uM6y5k2vr2UUXIj2/pn2I8lNpLlQkaksoqIQJFBLOTOjsTDBpQr3LMXAboa6dkdlmKQaYqObKv8fm3T+8EINolQidAQDKA7J4sJrCR4DiftRpeui+iQoaX+ue2PM5UIEcmiCZFDBgJmOJefDus6zdsQgw1jfa6HEibxyPGKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=018H+h7sJCAbIcj4sphYTv8ZTPUilByX7deJ562iw5M=;
 b=OsDKrCiG4TKZIEv/Ev1NdbPSqCXyayRe2Gtpn+w03uYtjhg5xzJ9KnH6kpLO8Trzd+SQNwLfszxttVJpXqo7cvX6RIyIyW+Kk+keQQFUjeNEEu8YkooxmA32PmBcmCFrY+vczr0edg6m5vSrrIRxM3IJG6ksAPufsNArQkMSjSTK+MWeXOMQHAylbLfiAkJKVkw9wmq6ipIiei70e+B32t+3JWhdG8p4+5axfoTVwgnuPmqtUHJIK1myze3PhI619Bs2rdr9pqwavKRf7igTQqmtpTsuNHTxa8O9dYtk0j3iJ/odErrPP4Ewe8og1rTFw+laNKue8dT46K02damxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=018H+h7sJCAbIcj4sphYTv8ZTPUilByX7deJ562iw5M=;
 b=HwIi63zgDoSVUVMucSPs5pkKxTf1mxmZMBJF6EJ1hprdf+wkuSNQuWYvJbNiXMfbOc+3EjxIJe8os/nWfQd9ukmU5t6CDn+PJmEPSY4jVgegCvYgAuL40jiRSXNFSW0VMIA5dp+XVatqVfC6ByjBf6cl7hIo6pP4LniqeplsrNY=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.24; Fri, 6 Aug
 2021 03:03:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:03:13 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 0/3] Log correct rpmb unit descriptor size
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dgzgtrw.fsf@ca-mkp.ca.oracle.com>
References: <20210727123546.17228-1-avri.altman@wdc.com>
Date:   Thu, 05 Aug 2021 23:03:10 -0400
In-Reply-To: <20210727123546.17228-1-avri.altman@wdc.com> (Avri Altman's
        message of "Tue, 27 Jul 2021 15:35:43 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:806:a7::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0013.namprd10.prod.outlook.com (2603:10b6:806:a7::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 03:03:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 705a804c-167a-4ca6-6911-08d95886bae9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4648658B59A5B4B9EF790B098EF39@PH0PR10MB4648.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGG7tR1W9kR2laWrBFm5GpeSAMSzR4VKSff1iybX6E8e9EcZ2igPvrP4i8WIuMJWDaFKzU/2vwy1WoSk+xLq7ZvevDKUCf4BxQLXADDKkGo1qz3xCP3cB+tCEEv43JEwh6oHlgV8j6QANVGtXkXIxwWDp4XW2spgVT9lx0A3YvD98TQdq7xBYd76fIakWLdZsW/FgUR9qQdkQSda4P7Ps1e6dWoT3eKElCTSs8XJqOmzc1jQMbChGka8jYqCB/6/UPUe3frnz5QFTtH9wXP3ki0zlK6OVlcewqmk30GfJZbH0RW1B0MwaoCstYtF8qdvkIAp+8GIGkp1KnIl7IUFnm1T2GxUoiXjxCbShsdVecb22dQ/+V8OV3InF0T/zFVEyda7PCdkW4g83XfuoYmfqPT5a1H0KYqYzpTvfBnqbVNVNgo94XvxuwqoBD7/ynTdfNHbNTxZbE7RLMS5wYfzr+skhjUdnbpEPYox6kjAcpDZqlpT+qdbeTcOsNrVpDdXZtofbWkqj07yYIln7Bgav9zVOGSC8HPQa/jv9zdEPpiQUgIb9voUTPtwHlY43eNvrapdKIAfknvLjZ5OxHKGHH8sHs5vmw0WZAY2CF646ltQW8MVTCKiL2z/c+EYigjMOPju7Vvgxo0n66PyX3wSbBytaUuir8RM0haxOxTvSbW1JxkwstAsAEzlSqZm9mMOnWO1LFGS1zUI9vIUaXq/cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(5660300002)(55016002)(186003)(86362001)(478600001)(956004)(83380400001)(8676002)(316002)(54906003)(66476007)(66556008)(66946007)(7696005)(36916002)(38100700002)(4326008)(6916009)(8936002)(38350700002)(26005)(4744005)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lHRpW1nMAPjnj1s/GL58HEr3aYUoRPiwAPp/AXg4FkAzdpyLczlB32QdE17P?=
 =?us-ascii?Q?69m4GxPXuZkapZAXBJav8BCqvMxXRFmzX3Fkx4KqvBg+goerZthlzMGz6JCS?=
 =?us-ascii?Q?Q6MwkkC7ZIzgu7vQwu254QWYftgcRrp5e0d6wIteYvOu6KFNV1G5r/lRZwVv?=
 =?us-ascii?Q?m910VW7kD6YcZhpTznFSHpcLCbFEjYyB3RvXUGLTLHjnrLqn4iCcPG/gP23c?=
 =?us-ascii?Q?wl0bmWAlNgAl68qlB3p5dnRrRlx/sGm7YofRvO9vySxZbfb6UnKYuHIMzY5+?=
 =?us-ascii?Q?+UY3SJcYksapECX3AsFaaaggKr4js0ciPR67yHsDWIix+slzlKUey3mAhWxf?=
 =?us-ascii?Q?5rC/IW5ZmrabY0aeR6bekkVcfd5RQW5wMt8CJrV/4lR6HHwnSDK6UjbGrsZ0?=
 =?us-ascii?Q?MbC7IYFFNdEE+7NWjg8KbAX9+xhy+Bqx91HVUQa/PeVIYGDXQO2upXFLDnfm?=
 =?us-ascii?Q?gd/hzv2p1WuphTDudpe61QiDFLy2iqE4UmKmJM2ORGQG60eIvtiQalTEJqJc?=
 =?us-ascii?Q?BPjKYe/Z23yDWuAFmBB8Vv4Kn5ajOo5FAZZbebMVjB9LCLZRkR9hGZlO+5KV?=
 =?us-ascii?Q?0jTVcA7dfZ2Cx+hxhTtyf/7tMJzYlqGJnVB+RtKU7ffal8J1aScJNkcjduWW?=
 =?us-ascii?Q?eLzmRdwmsjik7MD1ou2U1xLHTDZqWUts2peRV0EOHF9LRxZNOn1/NRW1Jnw1?=
 =?us-ascii?Q?Nly0PSDg9dCvt9t1WFD0swS7UOQHsijJmRv2CwVrDc4aa5Ow9RyU8O1G4F/+?=
 =?us-ascii?Q?18da1mJhRGGNcOp3snMjZs1bZzO+lgxiOLO0PLKkOFw2jCyGc+CJ+NrmCIaZ?=
 =?us-ascii?Q?DX8FAhL6Dekw7rPK1mZrkmYsD4GLhV/9AcHajcCWljI2Lbd11BWvE/OD66RH?=
 =?us-ascii?Q?AifgpkOhklT0kq1SQXvYL7siXZoqJioyRp5BzLyuI5qln4V1X9GOrxRogIuo?=
 =?us-ascii?Q?EN2cPzXwDMfLVhJ4H7mescSnlYq8TVY26PCTM5ZFfq8seOlOqNZ4eHfubAjf?=
 =?us-ascii?Q?ykdC7SGEpFlwLZ1/kg/kizP5vR3ObXMypwldcgB8GC4+5iso9jhH0s9yCegi?=
 =?us-ascii?Q?c6WQvbdsZsS8QFU9xCqFotP8wZCGJRIXcbpxu3mIS/ivw5BFY/6ZalegllCr?=
 =?us-ascii?Q?BVsNw0GFfLfBPC9BrN3rmmSzBD7uxb1LTvsJu0rkA5fiAXCVtLeVUgYY6fzs?=
 =?us-ascii?Q?QuoyuB308N81nWhkd/dOTmkLMRJeB80WgNW/JOz5h9QNVh+/tB6AOWMD8/tQ?=
 =?us-ascii?Q?vxbWEf84saAiH7EZ+iNTQxxFcf0vRalFqZLQjQ6Dq0kGLOPNkXi8iruFrbVi?=
 =?us-ascii?Q?1F1sw9ovTySGEgvgORWTqWYC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 705a804c-167a-4ca6-6911-08d95886bae9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:03:13.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VGcMnNsbAavQ4V24by/9ja9uC+eyuQG7pmFXXBbNB6xkvSNz6Br1iR/N5zP9iGtloNK5ILNX2dxe5siLzuoSpYIAQE32V0reDi6nTpvFVsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=978 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060016
X-Proofpoint-GUID: Rp2viR8Xbqh_w00Sc70P5QoD4o5a4F4M
X-Proofpoint-ORIG-GUID: Rp2viR8Xbqh_w00Sc70P5QoD4o5a4F4M
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> For the rpmb unit descriptor, if the field offset is larger than 0x23,
> it may trigger a stack corruption because a) we do not log properly the
> rpmb unit descriptor size,  and b) ufs_is_valid_unit_desc_lun() test for
> specific wb offset case, and does not verify that the requested field
> does not exceed the descriptor size.

Please rebase on top of 5.15/scsi-staging and fix the resulting
errors. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
