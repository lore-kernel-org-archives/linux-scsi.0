Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49BAC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B60C610A5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhD0CsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 22:48:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhD0CsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 22:48:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2hdo1063970;
        Tue, 27 Apr 2021 02:47:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Jeo8VjoIVEfV8zPVHs6fF00pmQE5kr/djkNbfkjGohA=;
 b=rwDAAg/FDOx6ilqT8CfgivdqxNxQvFoTHuMAO3CD9twIgD1H6wT89S+FQWkrolY/doVr
 u0uWc81WGhEBPY4nPqOyAJBYtJ+cyvTtvh51Bs+UhoPr+nQOXtLLJ95dmo33oXRXOUcR
 mykd80GIy2wLgZ0ljru8Go4yWDbwmnlyQY0hCFySHfx1Y/v/sRgCJR6GR2w/G85Mu+D5
 S7xcG1UtDNLE5R3UAUZIURU75Z2vvH6KkkP2qiPAzaqW9M030ac/wXYPPDJsgCihuv8H
 r3OEAyz6xjG3ooB3RLmHHdMnrvLJDYd4J9kJA4OGyAkbrOtro8+E4fQxVKorqcmVlxdl 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 385ahbkyg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:47:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2eRNw088376;
        Tue, 27 Apr 2021 02:47:27 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by aserp3030.oracle.com with ESMTP id 3849ce2fes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:47:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIre3hURERP32F0vIWt3iQIBnaSlqAvXvV+uWtslr0GbxnIQMYWS0WYD1KnADxp1zr5j9IMiuWBZCj2xHhPuQ84MbUF+3eR21+PIiqQlxXlTh5OAQyzOG7GmK12ZfDYp5K3tSQX/evZ8LIA6h+D0qqIpOeyOsHxpJ6HcVqsHH6/y1a4fiSna/Zir/lhrmI6pTrA/+t6Wp4FqBpIsl8U5TcaNFmEErn22foizTuKLOTdJFw5d0lY6OhgEb8obbvxaCVvJoaYDxy1pBgGPF6UEDGB2qj1FlOI0qU/3d4A8JZdoS+QT9rnvc6NdxKi6XNOSbAyoGOwvsr6lqktKimQc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jeo8VjoIVEfV8zPVHs6fF00pmQE5kr/djkNbfkjGohA=;
 b=BBjD90wJ8wWkxUpIJGfPgIEG4NeWkc41sAvDuGmso5QAfX4px/VBxkm6MyWjL/yxRDx4/l/K1y7JitYQk8eX3lpTxN7GsfM2wSbCpQLmPPpgGJknjOVZSPritLLf0WlDQ3GO2Qni1PezlZ5SN4YE1lPqa7XY8Ndw4Boa/3WyjSUT9OoyCPTtBUnkBHZgAke8WK+3BHlmlwIFDP6Im0lKevvbMdsnUdhedHbHtqmtDl5rUw6Gt6jsThlwu20vdJl0z+XhMPqZVIFsBKs+EvPOj6lr64kICx3Srcxv3TgCf/MyoLeE99vOvPGIot2sbs3i+FaIyX7hy0jMUvIM5CghgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jeo8VjoIVEfV8zPVHs6fF00pmQE5kr/djkNbfkjGohA=;
 b=WyVVc6rnxeSNmxlBtdV7oCu0C6REFXjsbMpWW4hx3LST5BLQrLES73HYu6m3YPvzMDP5t6Dfs0yiQqQcaSS0aLcsU0IMopsj+msf0+H+8nr9Zrpo+QQLjZ2Jvc4C90kFfwzr+YQ/ktv+oqU3+SgoZAlZUvFXBXReLPGrjHQcgh4=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 27 Apr
 2021 02:47:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 02:47:26 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fusion: documentation cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8e0o34f.fsf@ca-mkp.ca.oracle.com>
References: <20210418203259.835-1-rdunlap@infradead.org>
Date:   Mon, 26 Apr 2021 22:47:23 -0400
In-Reply-To: <20210418203259.835-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sun, 18 Apr 2021 13:32:59 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0187.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0187.namprd13.prod.outlook.com (2603:10b6:a03:2c3::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Tue, 27 Apr 2021 02:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b358c5e5-6f8b-4bff-787e-08d90926caac
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45191A52DAB2780004D1B7308E419@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qa/fL50foO+iU0A4xx9BZ8atOnDlFWnVIO0wxV7Csr+rtBVYxgWqQgj9uzbQKtLDEGdahhcVt/fqYNDZe6WPEQmY8R6RqH5y+OjkFDpaMx+9/NL6R9hfJyVmzDCMdXAMe2h9IROORb2gEuvy1jvoE8ikP/+UXr7/wE0Kdtj3l/GKJS51YDNFbxHYmkye2EF3Xj8voShh9gxwr4sN8j+7tZbSKlomqpu8CnhhwFewwH6w6ltxNORFj7ah2e1YtqszYPMs3HiGXTxN/sOBW0gePeoZidcUrytGsDO/oSopmWIRZCWwivcFdsZSKU0c9HcCorWOZOAAbVlc5goWDprl8pw4qWOo166ZIZxo3XG5JFUEgITqVIXtQ/u7TqHeUdAp5Zzfg8HZXQvdd2hLBYomw4C7n1YX0aywm5Bg4iVt9uontyHiX1mQxdlWz0T81Em+VcZWD94jfdxtOV+AuZgNRMaON4ie4azuxqqd1nrmXBMqgaMw/ywQTsU6of82BjacrKb+P1aN4gvsSUFS8fpmNIdWrOyR8jTuBD2CBDhg3m9bcSP2mrG+DA0wJVDexR6ABbubqaJoLlnOiMX9eMkoUEUmeiYBHRBzF/M51hC3pnERcLSQjBQwhYZ6wIS1b6FeqQIc8pPM7lRRJxXoJcxRP/eDsMSTYVq8mfgYivSqJ6M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(52116002)(7696005)(38100700002)(107886003)(956004)(36916002)(2906002)(83380400001)(86362001)(66946007)(66476007)(66556008)(4744005)(16526019)(5660300002)(186003)(8676002)(8936002)(316002)(478600001)(4326008)(55016002)(54906003)(6916009)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NrXqttSqpSXZ1jNSX4LGWDAWkm/RFooBOslgYBvRHf4NjNiZY9+MHWPHhT/4?=
 =?us-ascii?Q?rwoqAPsOa/kMgY9tm5x2H7DgDip5QQQblkIPew98MMxTuiZIfRlpuRcF7Tec?=
 =?us-ascii?Q?CrcGD/yWJh0Cig+7GuNRTJUb66drj6t+l4ZYqq00l8YgKIWW1h0539WSZWh5?=
 =?us-ascii?Q?przl05h+fTHVC2pYBGFFgNL3lGA+3T1hiGvpzScbTXMCx2dR/L0hxZGXH6Bj?=
 =?us-ascii?Q?2gEHsbzJgzNzRnfk+LazgZAH1LyT4C9B+vGmUc7uoodG8RKeu0OWbXrT5qIX?=
 =?us-ascii?Q?iuUGIye1sxCqt16DpBS9GV42TJkKMIHEAhwRE2ClsF2XA93/YgyqJYBdmYJd?=
 =?us-ascii?Q?B7IS7Jt7uGOc5z3v1gQmMDtrOVi/l1Jj4p2DA4YGpDXaIeb3oSnOXT6hreu9?=
 =?us-ascii?Q?208MGedtqxAxhJMQvXKN0KgffFhx4+Ts5iHC5icoqP/ThgA1EU+04174/KEr?=
 =?us-ascii?Q?RmURDRxuJHfd/SHEZ060Vg/Er6I0eLYtlCMzwgSi/24x+rrqLIXnAFUbvZjC?=
 =?us-ascii?Q?XHVIEKdaMxnNBjHsq2AlM+r5bXosYJbq5NbrWf4GfeiMZDkTx/BCNwfV+hZj?=
 =?us-ascii?Q?qfhQ9TWv0zPz34DjqdLoByEAJzahIe0O7S/q/zMTG2igxFP1/zNZSkZaYMJ0?=
 =?us-ascii?Q?Ogq+Bx6czh3Q76ns6uVxWeQSAc2ExOdXPWtaSJoyFuTn8bxunNJvZYpx13lJ?=
 =?us-ascii?Q?D/s1w37fysrAIrwm9cBUZK7sCibSAKmiKHYASlgX3lO1P07y7C3BDUSlpRho?=
 =?us-ascii?Q?8BGkatk3IUo7PSkreDswxvOqlL6zIjSI3KKub99NKjJ8llpaTN4ARSEXFqgd?=
 =?us-ascii?Q?2l0WrBqBkCeL3Mp1KwhgsE6KARKHbw0pv1tEDouniSFXOh00sjFdn153sCxv?=
 =?us-ascii?Q?WOONILvaXBZE18GPNTIT7g26IAbOj9CjDqVl6TsP7n9nZiFpiv7YnRZV3lY1?=
 =?us-ascii?Q?GPwhEuQiD+JrOfbIJ3gV7HMMY/kyhHYEsLxRYNdJkO2l+PLbFKoLJ8yw+Z5o?=
 =?us-ascii?Q?Pv98lGLHxR+QLnNBILkGf3Qm5gMHiGLYW+V7vjsGnFuzaM8Nk7cbuxGDIRup?=
 =?us-ascii?Q?zhpgI2B72erbUtIHrzVNS4DWpgwRNJY7lRhGyRju3naFHdiFfGuYjRnEm6pP?=
 =?us-ascii?Q?kDyNMor5rEVZZkpXkxeoE2UhOqJrnEGYt31ck15bUtaVSa63P2xh6H32SA+0?=
 =?us-ascii?Q?eaDk4mu7dnyqvRyZlpJkcC++fWvu93Zh6jcue96JECQi/zfmZRcDFXzt3nwC?=
 =?us-ascii?Q?r4sQOPY9t0JIM0tQTDjDex1/uOngWO8XdkEK7wBPkMde68IzX4nsA29Q6QGG?=
 =?us-ascii?Q?E6hPoYSjataUJaz0+ZZC2T76?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b358c5e5-6f8b-4bff-787e-08d90926caac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 02:47:26.4498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSPv/fDx/1tJgOcD8zQyV/qg2LVsoEtdPuYkqfSl/KGGaIHdAc4PwI5clhuuQ8hRtVWCHl6WfitgD1Rk52Z8RlPrHaQoFbP0LYRvQpGMMNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270017
X-Proofpoint-GUID: bygfwVCJPDemgaKYBZZMxXjibvdZyu4i
X-Proofpoint-ORIG-GUID: bygfwVCJPDemgaKYBZZMxXjibvdZyu4i
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Fix kernel-doc warnings, spellos, and typos.
>
> ../drivers/message/fusion/mptsas.c:432: warning: Function parameter or member 'sas_address' not described in 'mptsas_find_portinfo_by_sas_address'
> ../drivers/message/fusion/mptsas.c:432: warning: Excess function parameter 'handle' description in 'mptsas_find_portinfo_by_sas_address'
> ../drivers/message/fusion/mptsas.c:581: warning: Function parameter or member 'slot' not described in 'mptsas_add_device_component'

[...]

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
