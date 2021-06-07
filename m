Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE58CC47094
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 12:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD08611C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 12:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFGMdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 08:33:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGMdN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 08:33:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157CODwD132441;
        Mon, 7 Jun 2021 12:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bymi9i+96ojI/x1P9myxwsX1gpzfSJNgoZXnz+XmtqY=;
 b=Sp49xjyMLmCQ32DelIL3KpVithn9dgxaDWpXi4wrsLSDN5iV3dYHQa3Q0AgzV1c+0lLr
 GBolZ5c+lan9qvDpIQLvK9F19piaxkh4rbjLX28KLQdqZ+mthdE+QtK4uvEtJljc0Rx2
 Q7xhKBsKx4TSzisx3sij5n02gwfeerTo94wpK++vw1x4HP193oRwg+d2cLIWeqE3eEaT
 1WQkLc9/rY4ZrJScd82wCaQIUTXMGIB3jR5kznkq3iUcEcAfCaDzBfz2RapZ/ptxsZNE
 5MIk+we3QtLUxfFdNNdJC4rzGfyuryfbWTAT/c380cXp7Y85RJLEnrJN+KW8iujhVsdF 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3914quhbus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 12:31:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157COmdX186397;
        Mon, 7 Jun 2021 12:31:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 38yyaa2gjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 12:31:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOsutu/CpBzRX4eMxpkBJ4UWj6emBYwoB99xWfBDx52wx5QgylVML29uKNks9xCYtzCmH8sIzaudTxuGR46r0rw6Zk3YSBJKK8OfNT9jqL5RF7Tz/jdu0h4emwUo0/0u8/LBt2VZ7wZ61cpX91R2jPS7XR7O5zi1teEnWuHLE6x4+/hOS07X4tCIneNhxIz6MAKnenY57lY9+Peu5AjKZOCaWOFo/MijbwTPejLLp4VbU+PHNh8S8t+qGUGXEb0MG9s0322icjN9L0wqubBaRLGJ22Z8F2VPSaKgDcRuxqeznc8trZ5Q2xTRDLkXVE0KiLYEHrBhtZzS5gigFtItgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bymi9i+96ojI/x1P9myxwsX1gpzfSJNgoZXnz+XmtqY=;
 b=kxlLYj7gQ/nxQWNKEzaiZW0QpGh/jngweK0pE6SIIMA9w14A5TDNYIs2iXkBs43/UsjsjAALcGn1eVEWjuBDcDmlgs9NHvtnsHlbRrpucCLyUX+7OGDc0qcrOeVar2wyu1BhSXg9XIjjGikd0U8Pm5L6cuYoF7yFsEO8ENt5xMvQcJd8l7KdosNO1vhtmdkK2okNFSTGt7HW0sQXKhxt+3MIi45++TKXkg/iAJbvApCXSrrP2Cqr3h8r7+I59xl1CmJLL1djjApWqHNrnB8ObZ7Ip6XFr6jxMgbN8UynLa2SrH5MkchdgySWrlanoF0u8y5eKHwqqF+WHr2LzXMNQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bymi9i+96ojI/x1P9myxwsX1gpzfSJNgoZXnz+XmtqY=;
 b=ccINf5B3CJYB6ii6sqK3opLv6nJyDQ1vTNZOsKpEot2Z0cj97WWOK1rG0OdAOYD5/CDxkKzpHKYmF+PEvEkgD4eLcydgQgKAI71sMu2/TLkviSZuMXmt2HhaKUJHDOmfWQowdgbVBv3B7bYKJ4wJpOGwAWYo5WoMKq8lZ0OuW+k=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Mon, 7 Jun
 2021 12:31:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 12:31:02 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
References: <20191021095322.137969-1-hare@suse.de>
        <20191021095322.137969-14-hare@suse.de>
        <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
        <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
Date:   Mon, 07 Jun 2021 08:30:59 -0400
In-Reply-To: <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de> (Hannes Reinecke's
        message of "Mon, 7 Jun 2021 14:21:18 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 12:31:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69ceb3c7-9305-4093-c07e-08d929b01cbc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4808:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4808A4AFB9576DD1B7BC19528E389@PH0PR10MB4808.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skV8+MfWyTfeNmVO/nGKXpAH76HkmeVwr7u1X7SAWQ5C+lF4WE9YjEXQ/7nu7SK+8OeJaN/LoWVWsqAOjMw6ySw/QccnoOQI6ed/L4hea16vixtn3M3Zi+1VrITM7vRPlp5pmFVbPb/icudD6Iul64TVlry0hMAmoJobxx9zhRkYmciDkdTeMUMrGUqSHr+u1wC+nXcTKFdwEY2ta83gxaTNs8geGqKfDWoDOgUFWRffLTiSnP8IHb/lrYWrijrdyIEzvcRIKZlGrQFsQrw5dLkML6eTMFiELZBfLnzXI2EOZu3/H7ha4nW1nGCLURAKAYoIOUebJlBXOKUW1u6UKSqsrCAVlR27dJgmNz6mtuTxJxEt4r9IejbpeXsxIrI0uxUYSo8FLr8R3TcnAaAq4vgOB03mcYt8vtEZMlstpNyp5YBOvMYns6btF4J05gx81fWIjsDUCVaU+vxXz6DjLKPndqeh89AtA8Sn4DOSjlYJCAoKuqBhMKyEb+dUkQ7c+RYThsdiOh13NPsZXJktSAQ5TIkfG0pwKU3mPFGgZE/3ZH52E+ffTR1MFR+CLOHmveV08N1VO+j/ciNgtOO3d4iZRjgYDTMK5qukGfyqJJxiHA5DAZhfPVAdMPrKm3hDVD46ZVBRr7CO3nKt43C0Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(8676002)(186003)(26005)(86362001)(4744005)(66556008)(478600001)(38350700002)(956004)(38100700002)(66946007)(8936002)(66476007)(54906003)(16526019)(6916009)(316002)(7696005)(52116002)(5660300002)(4326008)(36916002)(55016002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j7NQ5+EodcUW5x7LzwHVr2KheDKT/WOM16X/IoPcEoOSmiAy9/VuRsQtn3ZE?=
 =?us-ascii?Q?OBm7wuoQWcgKzd3RKus0eDPREwGXmzkiqH+ncgIXMGzwe1fbCnz1wZGN6zOw?=
 =?us-ascii?Q?GzpRMnmQ2AuB1Q6Tt5Abhgr+8OiDNARhw/Y/WllizKYBA33TxVOy6KD9nubL?=
 =?us-ascii?Q?AvPSXZX16YbSb+nNOYurU6A/iVUeLIfD1L5b3iJHdE+woFOnk/ElVbWMshZj?=
 =?us-ascii?Q?j6nlwhiLv4q7MNpv20lhy9LhQRqy6cKmcBxpUPZMhq+EAyr0V7ZMqYKZkVay?=
 =?us-ascii?Q?d4huJXV/7rNjl2NixVgF+hBfcMBP3fTi3CqXm5aodPfdAK0S9OrVyK2sEM3M?=
 =?us-ascii?Q?4EeJt3KMguLeFtWD+dSbjK7LvOKjyaVWqKLZTbNK+nL4DK3bKDJd90YY0Hz8?=
 =?us-ascii?Q?IXIG/0IgW72OesBp+Y8rAilzCZLR3/reBYRQHp0w64zaUrESd6QYHOlySswF?=
 =?us-ascii?Q?feotAIXWi3rqsSMM3GLwBQwCgPXnQZpQd5MD5ylHZs95ped5IvyQvQbUUZvM?=
 =?us-ascii?Q?yYEs0Tv+gPnVTsnQfYe993FeQFDgF27eKyVh7ruzjpKMwXiTiGnzRy46hyEr?=
 =?us-ascii?Q?sim4KwuvVKT+0q2j3ttZFJS0TS6W6vhaLQqILGOzUgfqaeyw7kP4+k8ABi3I?=
 =?us-ascii?Q?XVOWECTj3BDmreVbDHbX5B1n+ke1EcttCUY1h5M8hB1gi2qwuaPkU8faWdkt?=
 =?us-ascii?Q?wwGlp+hA8F9QxLXwpZq9kfrjTb6WhVI9XcqnW8texhZAu/55I4rkVIcDppoK?=
 =?us-ascii?Q?sBsmOC0U7KB48sI3dOfv43qblqDHvjENM+3p6FRrFIkVCYvUEzOFfxk8JSum?=
 =?us-ascii?Q?77S+ewJuX9YSSVLUhTY54Ph+8i5B5ZohG+TawwrTpOPWoUS3pO1Qo4k0F/E6?=
 =?us-ascii?Q?K/jaSF75R1whLDJJbQfrdG1ePZvWKsGwkpDODxBOgHWVvb6W9I/TUgueBgh8?=
 =?us-ascii?Q?l4cR+3vtKPb5P/fBbgurQDMZ4dP2/3YZKip46DqYbylagnZEXAdnNbNeDDXY?=
 =?us-ascii?Q?G0hEOxyE6dkfBn5AuyQR9mIXYGxKGZgqIEph+8y/TBMF89QI7CtpFFR4GeKI?=
 =?us-ascii?Q?us/f7Dp4ZgWM7l5H7vck0z78VKcwlhKVRqtujC6QyFmi0v63ylcGWTujBEZN?=
 =?us-ascii?Q?sy9FL/uE0VShkejeGMZC7xykpAfKLezqHymLNP0cmv5YyknCuXwIdkpyM9VP?=
 =?us-ascii?Q?4KNtihfDOtB30eE2ChBbMWuQ/uqacJcai6GNesVhRokTf7JnUqKLuHxSrpt8?=
 =?us-ascii?Q?JQjE2shOi8EdRtb0OCGPVrF/dIS2hCEKL3ON0x0aMspGpBOeOoktIoau2ADl?=
 =?us-ascii?Q?4hHLbczz5caetgVcMJZLyfjP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ceb3c7-9305-4093-c07e-08d929b01cbc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 12:31:02.4274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDiJQL2k2UhLZhoFg+GWPPCphwHCBvJfonvCRY1l9dWlY6d7raQsJbJA0mCnfkqN8r1/APqWJBs6fw1MaiN6uPMEHvGD/j5kfk0amPEdUpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070094
X-Proofpoint-ORIG-GUID: qcIldgWOmwT2DwtjlnqeZAg6iA6hKW4r
X-Proofpoint-GUID: qcIldgWOmwT2DwtjlnqeZAg6iA6hKW4r
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

>> Any ideas?

>> Can you enable SCSI logging via
>
> scsi.scsi_logging_level=216
>
> on the kernel commandline and send me the output?

You now effectively set SAM_STAT_CHECK_CONDITION if the scsi_cmnd has a
sense buffer.

The original code only set DRIVER_SENSE if the adapter response actually
contained sense information:

@@ -161,8 +161,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
                       min_t(u32,
                             virtio32_to_cpu(vscsi->vdev, resp->sense_len),
                             VIRTIO_SCSI_SENSE_SIZE));
-               if (resp->sense_len)
-                       set_driver_byte(sc, DRIVER_SENSE);
+               set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
        }

-- 
Martin K. Petersen	Oracle Linux Engineering
