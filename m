Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D06C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F22600EF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhHRC1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:27:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28374 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236471AbhHRC1R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 22:27:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I2AesL031952;
        Wed, 18 Aug 2021 02:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=X8+etp3MSnYs+FtTnpAaTagJ/dDZGLCACh9jX60X/ZY=;
 b=pb3fInmVgqq66mRUQ9bMqnJPpLrpNdhZsxYd7at5t5sgp4aYptJX7faeYiPGnGpCDTRm
 M7LfhBPqnhSMaorb8s5Iff+o8zNgzH9F6I08iT/+7j1bMpktnWFTOGIJjX5ULy5XhTGr
 98XGwQnMXyGqjEzEG5Nj+tzXaVuemY3ecD1Rr95LX+LhbSIeQoztV9AUMyzVYEW0lFTJ
 n2TK6RMeX4KJIXv7Z9dMDeG1Zuv68uJHxBv0Tk9jiLP37Rb72x3kRu68k2ObjhyzeJUb
 zF65kIqzTBbPQTUK9IkeFiHv5Nf8JeN8IEdMdSOEcdHn12n9h67l4E+HWaISODmC4wGD 6A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=X8+etp3MSnYs+FtTnpAaTagJ/dDZGLCACh9jX60X/ZY=;
 b=RxDMLzGnGx+07oJB3A6318LRAb92qJu9+cGZieJUNhSvTLbMwXxfQDnd5VJwOWWTaOJt
 b0o2n2Q0UPgqfCsZB0zo5dC7Zk7/sy1P4qVwm0PXuVYKfANg/2I0URvNVaT++TeKbAfV
 6wRajIHHn43RsqRtZoTaC6u5SA/60l9Vb6PoQJ/x+CLeAJBMmhcs6Rm2DopFQbjMxpFK
 2d5NWN17U+eTE8kNr3VsVIsHa60xB6Xv0M7dY6wM5PWc0sU7zyGvivlMdF8mgfIM2uoV
 afWSRm6KfsL2hC8lfqhIAp6Ew8yCtxrBOMHca43b7Kexf3aHW5DPPDh5oX1F/zFdZWwr 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpgndjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:26:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17I2B2Om178321;
        Wed, 18 Aug 2021 02:26:36 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by userp3020.oracle.com with ESMTP id 3aeqkvagxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:26:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3bqYORohoRLi+/EO+JtOComt3hJ2P7w2LtY96uV5M7mEhOT0NpNE269SMkLz7sf6pC7l+4nJBqFDso+/NFPI0R7izLTT1DzljP/C0GdjNZX+08U+mGOTRcP5x4mpVqlLA2rONRDwwe6zThKdn4GjmxMf/gN5vnD1SzqrsoJ5GGFOHHuwJ8zm3SDguC/zcfFjOTwDvhRYNybC7YJDzk0wj0KkyI74WMI0zb6Y088BzmBFVu+4lbwfA5lzKvVIE1FYna60r4QNOhrLRitaZKiDIKHEEwIpbjnwfH03ysEK76CqX+SnLBpii/WuIhw61yyuSkxFvO/aZxOo3D5UbZiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8+etp3MSnYs+FtTnpAaTagJ/dDZGLCACh9jX60X/ZY=;
 b=IOt8+nAeyLDrKeKercA41qpUpG9TVcGiY2cNWjKPhmpjPuiDCI14euU8/7wqiZTeZrdvPTHF3OWF7urIYPDZlr+FkNQThZ4LfDoFUkeIkpulKU9nloZRVp+vaNNHJYnHn9A8aCeaEbV2LJvByAOI/diA5LV8olTalgNpR3mmy0EATnGQjtFMPM8ZGOpkKLkyRmWhGklzs4m5w5pne+WLsOgWb2FZX2b75qn3v3Uok52EHQZXF5FPBlh2FLEgkqRMXl4NKD8sPlOrQcWFySLzteD/2DzICNhloZ9PBUoedisvf5bc1dsDeQMgVrQAkqdS8jdp5ivPcTEAyf7Yq2hQSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8+etp3MSnYs+FtTnpAaTagJ/dDZGLCACh9jX60X/ZY=;
 b=zJ3HP6plhHz+O3fdIYZLJ4yNanaJdD+/spR2Q4q7cB9ctHhV0oYUQ8XHTvFnWlOCrMDc8INdotXERcAFkX8PV9OsPa+I+SpUE3hJ947TqfuphoasFkTyFKK7VgeS0GRkGVCaQuv96pEUXktQ5L2NfUZ5uARlQyumv6EOUIgG6DU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4743.namprd10.prod.outlook.com (2603:10b6:510:3e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 02:26:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 02:26:32 +0000
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RESEND] ibmvfc: do not wait for initial device scan
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6lfmqt4.fsf@ca-mkp.ca.oracle.com>
References: <20210817075306.11315-1-mwilck@suse.com>
Date:   Tue, 17 Aug 2021 22:26:30 -0400
In-Reply-To: <20210817075306.11315-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Tue, 17 Aug 2021 09:53:06 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0373.namprd03.prod.outlook.com (2603:10b6:a03:3a1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 02:26:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b41f0b17-70b3-418f-db34-08d961ef9807
X-MS-TrafficTypeDiagnostic: PH0PR10MB4743:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47439A82F9FA1A93C6D3F49A8EFF9@PH0PR10MB4743.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRhKNBWWSpuLVuZB70fZ4pMc8x6eWAZXLckdqXsgT5GSO6diED4jhzLmD88h/zlojuTi7x2lpmESfQVFY+IJOzZK4GasNp/S0KXmtOI7GOZaB4OLY6x/DY8Gl/eY33aa4Y7QWobH/bA9vYs1aj+nAV9iZduvQmAehJ/CkT04Cw2OWLnrNwU1Yre0eq2LXdIU6tKzGSyjcObL9VQ19yQpQAXK5kqPZzK6vjAdqgjZHSCT6Ci6V41GAgnyeHUN/M2dwoQTLF5x4VW1QbVWhIC0wP9kfcXyxIZ9VtQ/MGEUwXAF6PF81ULSCWiZtu4lxhID49JJ7R1AjaCJbDnchM9ZXmwKAKBzLNW2VLNk5aLBE8uK4Btb/F/Ycmx3WwTxXcSHk7P0aTDE6kWXKiSO14As0uSuK5wnoLTm+UbYLRCyZjrXrbQwPtYtPt0vgDrguW7u1mRieoK9l5GH6gR6ocyUhn5MREcOcWXnu/C7WHembplXMOEi8NWdWTp9SXA41VYZc9QjHt9HUAhFZgQ1udskVlcpZt0/G7FUnbz/LcVFQ67PcTy4BMZpmAAAB0t8IMBFNgRE2Hi6aXkZwJszbVj6Exbmb47LiUSlYRON8QMXjRiTrCMJbK+7EcrOVtLj2euRgLY1D9UTzoj2A7yXaX1RF1jB/KRcF4FgMiEVNJtjpwfLH0r1FFd8ec+8vkdkBhJUkyD6Zc2RO1jQtNjBtw0ejQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(478600001)(36916002)(83380400001)(186003)(52116002)(38350700002)(26005)(38100700002)(956004)(4744005)(4326008)(7696005)(8676002)(5660300002)(55016002)(316002)(2906002)(86362001)(8936002)(54906003)(66946007)(6916009)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2AKf95muKkvXkg01pbGmrgi1JDCGwm9/EimOOQx9HpRoIZCFWEB0PkX+nx5U?=
 =?us-ascii?Q?ke4fUBkJU5XALKEAXRbk7RqP/P3pkpbuhsONgSk1jL8ThhFOyTF4chFThfG9?=
 =?us-ascii?Q?1gia1FD8DKWVBMP7sWIGRc/JaKSeyG9qEcAASoHfO68yQr+g84qvlSLtaB/W?=
 =?us-ascii?Q?NcNEgH7ATFV/YnUKaofleIVMRCT4yqZViNPX1T4HIVJeaVYZDKP9NRcszPAh?=
 =?us-ascii?Q?JdK3avRdCc/Qra2Tr0Q3TlT/WZAGcOlpsLMvxk6t7Uki4LKFskN8Btc+iOwr?=
 =?us-ascii?Q?gr3ijAz+PYeryOqIiC4P2UeBpzRezdt78RAF9vtduLMG4xJSKJGXgmKtB2ZS?=
 =?us-ascii?Q?J5m9p5J5dyVPMOtQFs4FiQXJbSW9PsDhr8lfQtr8MsVmLVon0EUD9+cMT6OJ?=
 =?us-ascii?Q?E/reUhOluk5w3z+ACFqTvn62fQ0RJuZWLXd3q/Ypv8elLEXbHHmk/MuFuh+x?=
 =?us-ascii?Q?ZXohXSeUGOoegGg0OSDseMi9nNQEE8wm8/R2PO1My2kF5j8sxMsBVsqslul1?=
 =?us-ascii?Q?9iqALUsC5MYfsrHshIT6+TC8Cc2uZiANNvmAeVBj8lMSs/W0GjXokme53qk3?=
 =?us-ascii?Q?nmZteftVXsIYP67rpAeQRXDDAB6boeBO6s+DAzgCipxZWUVh8MG6JIuyND5J?=
 =?us-ascii?Q?5KcLm4w3Q4rtsYJayxKkQV6KHjjzpXcADN0Lz61kymfiu3GOMA0sPvPxPhtJ?=
 =?us-ascii?Q?Qsz8cbsczq7/wYf1a6iu4yA3/vKgPuLfsgz3/Au9QdlQTcA6lfSrli9XK81n?=
 =?us-ascii?Q?Q4kKGISd4kF9fDZq8Z18WZUeuE2i/OAroS6Sa3dFv4AVNcF3VjLfUjGR+fcD?=
 =?us-ascii?Q?qQZCayBwkC8ksl7a6e1cMkOYE0ZOtXPeVTNaj1f077406MZeUJ7UAC0FB5Bj?=
 =?us-ascii?Q?qVTo+LAPUYsLgJfj0IpLZSKtgcQe9u6s95RN21khq2/nSShVCNWoGdfeuSCH?=
 =?us-ascii?Q?KXPrNwf1xKaIvjBq15aC/c76/wsxp97QmrIy6nPCx5KOq8BWmrOZp+SrG6Hz?=
 =?us-ascii?Q?+QupZq2FQb2R/oEZE4JYjz2Uh/KBuT/cBgMI/BQ3wOED4YYJ6vfgl86zTFSW?=
 =?us-ascii?Q?DDdxi6I8tFTecISKf3+kFMz793Tgt61k0jKJQwpxpy5+1r8muBJqJZIz++wr?=
 =?us-ascii?Q?bywrvBryMHAnIY208P/n4wcM+NMT5Y3w85WMZPKITwIl78ktJlpmeWNn1Ok6?=
 =?us-ascii?Q?H+k5vPf1g0BNgGrbTTj7Kp1Qwafv1kMv/Mas5vhJk8tgx2+ie5DdYtp2+Bzg?=
 =?us-ascii?Q?Gniw7SBdrd0nwyGDfsw/F2m2I5n7aSBVQ55r/X7wNBkuU3f9oPiShBYOr9jp?=
 =?us-ascii?Q?oS4JpytLYc5bddL6zv/o0ENY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41f0b17-70b3-418f-db34-08d961ef9807
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 02:26:32.6231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UpX5+lHy+gX3+wWSHqdZCBs+mnrePtoef3Zaz9aH6OTQcWtJr1F4VT/ykMQS2oWiURTZ4YEraFynqDo5CM8kQ5YmszjfeoXttbN4dxnesjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4743
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180013
X-Proofpoint-GUID: 7V3pF5qkLL8aSL-2_JqHyM-dkgcymKQ_
X-Proofpoint-ORIG-GUID: 7V3pF5qkLL8aSL-2_JqHyM-dkgcymKQ_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> The initial device scan might take some time, and there really is no
> need to wait for it during probe().  So return immediately from
> scsi_scan_host() during probe() and avoid any udev stalls during
> booting.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
