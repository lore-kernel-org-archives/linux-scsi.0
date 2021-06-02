Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BB5C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E228660FEE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhFBDkw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:40:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFBDkv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:40:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1523Z4vU015162;
        Wed, 2 Jun 2021 03:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ypf16uckvpLVoBxAzUkkzkLCiUKVmBRUdy/VN6AtOO4=;
 b=b1eqkTTOVGtfjstzRMxP9KRiDAtIbNOQTLny7+DSD2/xhBTR00WISkiYZvvF0BtsyE2g
 iK1/TA3KPi/X4uGVUHsv012e2JpGmQqOFdcobGnepPEhbI7n0GlOEO7/x7tlcFpHRJza
 Yl0XVghiv14oLcM4usuHdwlo0ZmlRa0RarzCf2l1JOV+0liSyjtepEAV3bpRuuT48ro0
 Cro5kXA+HMqoHUcwZNz3eB8i/TjsxiCLrRfEUtOSIRpOFfaTqMVNI2uWqmFlTNdClEFl
 eMwDixg73h0rNhT2wLQIsNoc/zdoh1IlxRHvMr+Yp41+g7+kVpEtwljrgMqN+5MW6rMh WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38ub4cqag7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:38:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1523abIQ190688;
        Wed, 2 Jun 2021 03:38:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 38x1bch5ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:38:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epW6MMqBHuZrD1O81TlV6bBTWL4SgDmv+OKcBrXlqBcsMel0TNQugzx4rwXqsj3G8XjQv8HSepth0v/pXhwkSrk/LA9weBtc8oUzTuUSQB+K91+EHkVTtPtvI7HTvg3m7lQfDos9S0QH/H23g5ri8JKTZM8v4ErKlkfC5t7osx1HlJF999LaVM3JnBQYwvEFIiaIvpghTS6UpKCXPm0nQct7KsQhFP7BROmLEuojxkrw2JFaFHbfV/as+7vXbaHvELysyiltEQJyy6Jvq4/6Xe/uiJ8yZYzFgZxryaUJaVYVzlOwn1rKWvw7dLka8FtNqln811TQVDwNHAfa0PD9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ypf16uckvpLVoBxAzUkkzkLCiUKVmBRUdy/VN6AtOO4=;
 b=BxOO7K5IGDRm1FuXWklRaL+5PWTrcdMfRXTX91lCk6Do8Bv5+yzePNCfF3CADKjcME4pmQenZfKD80s+4HEHH4pJjBdj8yh+WcnTcFLIpsbExrPL3Ch/HXkKnkGFwYm7On/LooVTR/UkJlaq0UI78fF9aD9/fUL35viElxLQueyUvKJk8JYUjaac63oQEI5eUPnDN0KDC0HgIbY/RXMSUWdJCoDZ4LTw0drzj8DTP0Rut96RqybJq0FDSFSDaJRfUkoR6bP+osehRe6n7k5cD5bsOpAIMJ2gFLiJTcpFU3VgiXUYFURMcertjeJ7OEUikbAyr3WHIa2nAtLL3JOPxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ypf16uckvpLVoBxAzUkkzkLCiUKVmBRUdy/VN6AtOO4=;
 b=Y2IN2OlLVI2Qu/QwevZjQ+ya0tuKn3cuAE6Vcze2VaDYhkghOot8NiNK/RqZOZoAvvNwaUrrxrRWUBE3pCj8HCWq4DK6bwS4WcquijHrzCVzin+CrjzQ44gTRAWOfc77Lf7v5KhgOL0RWzUI05VvPyCAoz6WaQyd4/MwSLAUXM8=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 03:38:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 03:38:50 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/3] scsi: Fix a handful of memcpy() field overflows
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eedlos1b.fsf@ca-mkp.ca.oracle.com>
References: <20210528181337.792268-1-keescook@chromium.org>
Date:   Tue, 01 Jun 2021 23:38:47 -0400
In-Reply-To: <20210528181337.792268-1-keescook@chromium.org> (Kees Cook's
        message of "Fri, 28 May 2021 11:13:34 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:806:20::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0009.namprd03.prod.outlook.com (2603:10b6:806:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Wed, 2 Jun 2021 03:38:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 605ca0a7-d230-432c-b401-08d92577efc9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46783571878B4336E29CD2768E3D9@PH0PR10MB4678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: taIxnaxReZNrcX4vthFC+X26nNJ3CSxc23XjrU+/8DiZmigD6862e81W/3gd79fW7P6FrB1s3L+KaxdLqGnlHbyFn0e8TgrE0PnW5nPqvLWHH3BM7gn/HXtN2nPnzNyQ3h8XFo8td2a0iAJmeMXLdctZeEsJGeFq16BPYh3qQOppMQOvL4Ge5RQTouvBAe86H21e784haOj4lIk4RjMAJ2EJI+23lV9xcYQMRCmDWYYTo53svrLStaHZenatOxKS6sh1UYcaO+by6p5YYNAN0LmtzukyMJjxRsSU/ANP6by5fHyBmqRtBX9fq7QCigkrB91/TCMr05ycH1OtmQtigVRo412hG6x9dIQ80J//VvIFarz+yKJ2ChxcH0BhV0/KMXnZg0n45SfCNDonHGObJ8FAz2ZMB6ExyOtKsuhrkWdCunO3VzAnTjGPdp4XnlkolvygBaQuT/rPAjp291F6HcKD0GWXZTtPcJvaOXce3TbQH0o3vuGdFCUvzHYzNMaBdV7OOKONPwKaUn88HVHECSgQ2PwOHx2sGa8w/0qHs/G5CzJC9cWTiowGGrS9QQUWS9Rf/enR2WuxeMAjKW9ntOQn8UxxnLP1xjaFWYVjMvlG1TLrgUxzRsZxOuPnO3UOAIyy2Hm+DIhJ3dLYVa5KgPUcbeD2jCIJPKqlQQB0XAg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(8676002)(8936002)(54906003)(86362001)(6916009)(316002)(558084003)(26005)(55016002)(83380400001)(66476007)(5660300002)(66946007)(66556008)(38350700002)(38100700002)(478600001)(2906002)(956004)(16526019)(186003)(52116002)(4326008)(7696005)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ATRNAUjYojdJbp9lj7Fn3wF7OQFS6X+wbjL3oFSXHI1ap6S0cAil7ZYOS5QL?=
 =?us-ascii?Q?ohk+zZFlr7aijwQtX0mjuj/+OpFG4g70V/QLQalOi9jrYy/Yb9yS51l6wbQ6?=
 =?us-ascii?Q?8ZV31fxSENSLEmV/6KJTVAatrVT3ea8hMPp6OuXZAhiodv/IyK0uwkvSQXpG?=
 =?us-ascii?Q?6iUogd2uC7ypC4bTpu62enizSUN/P3qKOq2vseUrFDmO7USKbO5hbO9wwabj?=
 =?us-ascii?Q?nWcIejITnrAihS0R93ypce0mmWFK7m7toSsBzX+SPqxVHIL2pRJjB/AHenwv?=
 =?us-ascii?Q?8y4/amQpI8oRWsX5sWeDnGTiGKXWggatWopvJTAeR01Xh2PxEwF+8baHdw+o?=
 =?us-ascii?Q?Q5tGbZtxnhJ/EfrPN1ntKROH49cHqJgePHuCdxl7Bhh75Vq8a9URQBvQFPlj?=
 =?us-ascii?Q?QAjEh77lVQEkA46w/8KxE3hPBhcn71aU5veyuBOPob0ih58mMr7U1cJFyiTe?=
 =?us-ascii?Q?wdAudbq7+Jk6WfXCE5Osem2qDcirJ18yz8UCHuHwWpPjXwwZ72waBRCsS5g1?=
 =?us-ascii?Q?nEhF5vrRZBav3r6LAKPeBMdaa/ioNcE0Fqga/HL/ZojZ/km9R6Bo+Y3MUkuX?=
 =?us-ascii?Q?iflsyiMCUvxokw0FlQSRCxIKSb+OfeNEzv85hoPfWpHylUjSmXwbOHyUuVVB?=
 =?us-ascii?Q?MJbLLdM2D9TwFmZZHsSAsfxVgeAMKd5oF/rD5TNW4Y3UuTvk4fOLNeLJCeE4?=
 =?us-ascii?Q?TFI0p++O7lXoUpBRZltCUT6C9A9EXwGBMdNBEXlKzaZQQ+R4ReSf/qXDC+Xm?=
 =?us-ascii?Q?URrVBNs2OI2jQ1vlNvScLf5B7IWr+iBMFIkZ35W5iBR7aViNifRlQiW29q9Q?=
 =?us-ascii?Q?zW6ORTYR9qtjG0w+UEvtQnzobO64aL6fO40qEroKkBUlZk0o6NfUQDFfHCNg?=
 =?us-ascii?Q?twY1NzGANWLHxFCKjBTaRVxGT8O9pHtuA6IR4q7YPXa7U65DDWk/nQACbMtT?=
 =?us-ascii?Q?w1c95+O42XVbfxSfuXWmk6oHyV/A8UrXi/MMTx9PGy8SmRGH8UmtFoA1G/i6?=
 =?us-ascii?Q?YLfqErpgUEE72w31sX9bCrFCo7k7QUPY+RuIah5XALQeQCnnRpqIig6+/0a+?=
 =?us-ascii?Q?z6WKeB/y3kONvW7vwpvUgGxsqdL8zb4fq8T/Ngt2HlPLN5y1Z/jbzOMkMZHk?=
 =?us-ascii?Q?Su5rq1qaen5ZWlPYba+OkMcNntcJp3YKUJTS50xt6vps0f9dXjvWYvg9sqtK?=
 =?us-ascii?Q?VkqsbUuw1lh0zd4NZRFJfq5v3j/cjNK1OMzwl8G6SDYPtmNNzdMrBILbWbn+?=
 =?us-ascii?Q?CF9TiDc+yry0P46wfxYGT8jZU5yCH2TGEQGmLEUbqqKrAkKcNwLtOTllFn79?=
 =?us-ascii?Q?FKFskvqppB+VVRn6LXixule3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605ca0a7-d230-432c-b401-08d92577efc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 03:38:50.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FOFidct4n2pG5kImombBSqC6g2rIEfr9tps7RO3CN8LVZjt/VMBe9zyQ93vvxxbqdGi3BLGRwJMu6hKBNTQ+2SpoPoiFqu33ccjTkB2PtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=840 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020020
X-Proofpoint-GUID: 6q-GbjM3AVXaJb44z9btt5GJVxx4Rg6X
X-Proofpoint-ORIG-GUID: 6q-GbjM3AVXaJb44z9btt5GJVxx4Rg6X
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kees,

> While working on improving FORTIFY_SOURCE's memcpy() coverage, there are
> a few fixes that don't require any helper changes, etc.

Applied patches 2 and 3 to 5.14/scsi-staging, please update patch 1.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
