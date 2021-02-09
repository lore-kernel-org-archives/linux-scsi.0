Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B70C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC21064E16
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhBICVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:21:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34078 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhBICV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 21:21:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191KILs056298;
        Tue, 9 Feb 2021 02:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6KmoftG0/boKrcbT64RjdXwa/iiaWEryYKs/Ly7H9PE=;
 b=bcMjcBFv+lNJpTZ3Hm2lu1EVtS66PQBR/haIXfbfr/6HWxD3Ed5NYfaZq3P38A8X+IhO
 Og70/39KqpZwrfFoCM3uWODP5lVMW+vAMPLuP02XfFw+RH3dIfvz/RFo1cmMTqvOVYAP
 nuc/uqi9CYLLu1Rr6sLewpkjRds2BGE0FhrjjC70Bc7o3ZvMy4IVA8LKcM519EVE66xO
 tItHzR2qz708DH/P3AdAJiZoqxeG8rTHlBQzEFvfD/fgWSKB6oDJS1cXVqczb97W7BTp
 gNKRjlx9f3mGcrYqwaediYYc6WMajt9tKoc3LIpXLXS8/2sv0nQ+OVa9B3BQp1ybKqeD nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmae4jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:20:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191Laax008947;
        Tue, 9 Feb 2021 02:20:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 36j510jynp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJWYHJWTRwTBtSjpVv4XdUL+AWPFjrCiewGzAc7t9f3tL6eYCoiH68+FLYy3bUoDJU7OtMVWqx/pXpIiVjZqp2jPPczzEtKkTtfCDdsgsIq7Ml3f/oPsBzHMVrCan6oz0pgkXB4hgnWlH4MRbNQu82n3vWkVx+jKwaBwoOynhrUDQRwa8kTEUq3C3R9wPCXs4XszMRfzgNqFsdlzYQ/Lb2LiWWF8a5N6rtoHDgCyoA/LISrcPWrgH+hDef2Nq8dA/bVh1cvuaQDVXvBKERTtGytNQ9mWcy6W+JytRACkPAiuAHid3RXRulprjdwmEavECUMQZyFd3tXVBqxXLeL29Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KmoftG0/boKrcbT64RjdXwa/iiaWEryYKs/Ly7H9PE=;
 b=beWCuPNzRTA0CvDF7LVZTxi+Zf8esDTI5P81yO0ieppZo7EFySeJeiZwsfIB6DLT8usvt39GmWNm0kGrrnNrMvkfHxKLIhOQ59rDLDOBFxG9QeaPYom8z6SuAoi1rZk7y8oGs1gmoEnO/xdjxhow/ng6jHzhLE3dEJEyPJljy9rYTMBpvNTfBX/jW6IrLn+OjqhBOuxMxOVGklKVk27+qPzCYNoTZppxRHVrB0HCgQYIasoKz375UoS7hPIsGh0OK08sm/sT2W218JeXb2ckVHtKgbjRH6jMDzJ7smR9moy2qIUGUN3hyLF6a8G259ZJODrned7E0A59AsP7mlze2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KmoftG0/boKrcbT64RjdXwa/iiaWEryYKs/Ly7H9PE=;
 b=MXoqRJ9rfIboCfV/05VPEruFhkDniq3QyzeE1ISHacCcEnewxMbk560c3YvW8zNXC0s6GyM9s2Uo6zuASv1MbUuLh5rXcTA0j2zWpkKY5G4/hF/QSmL9uUuEsdkksNOqHd4ow2Jq+UN/gAXjkFpsccs3PZekpo607D6ohm5ntPw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 02:20:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 02:20:42 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: fix ReplyPostFree pool allocation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnvirngz.fsf@ca-mkp.ca.oracle.com>
References: <20210201141522.25363-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 08 Feb 2021 21:20:39 -0500
In-Reply-To: <20210201141522.25363-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Mon, 1 Feb 2021 19:45:22 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:806:127::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0219.namprd04.prod.outlook.com (2603:10b6:806:127::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 02:20:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e7423a3-c9d5-414d-6fbb-08d8cca14c87
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4678E507C2180464FC3A1DC68E8E9@PH0PR10MB4678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDLGGzIwNlcBS31U3tPn9y3I5sVU9zFuzdwlRo0pxbqqveZMLVf/JZF1pBWa4+nfgYeBMUp6a5hUCcnu0Mg7tfwrFJtLEDTGO5zI6/gzj7jwxn4Cr54TuwXrvUxDw5xDv7FBd4XCycvQSPuUPkNJtUw7pAJjUwzI3XIByDA4F6NrpiUyrRwNrxdw0/jgdTZbuwJ8iywTUw7ok8OFQ/Y2vuUkdePvA0HDzCdbEQ2HH8aF+P5IrJm+Fu7HB2RUmnAeT9g+0DP2fgbgRltNYBNlknVFekWvgeY2x0fmS05WqboiQfsw1AV29CrDev3YR0cPuTdAW0Uzkd/lcJMz286IllyDqgG1/a6HRrZKWX9FSPTAweLtJfjZggkXSJo97GgurPAObUlQuLjBJtJ5nsQyWGKpW5S5FFiFgyYbVMQB2EJEs3IPUozcURj7o5rmc5VFUW6pgmWL+JD8fWoG4IMPtlRxC/2PXB+8tJGPutmBv76iBeBr3dlmWRUgvptmoJXVvCiGFcT+IVFm1ec9uC/gpM7UMsn5gjj5PInRBsWmZwKZ31dCANX1eHehXaQbNCyI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(86362001)(5660300002)(4744005)(55016002)(8936002)(478600001)(16526019)(26005)(6916009)(956004)(66476007)(4326008)(316002)(66556008)(36916002)(66946007)(52116002)(2906002)(186003)(7696005)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d+g3LWTynxlnIHdnl3By/i0InPv+kj9HxZ4gC+wE6vwxk23FjlTyXM251ujA?=
 =?us-ascii?Q?xoPXJ4Jeoz9bs8oXiycmMGWu/Al/ij99lGHDf+vuGrp0XPZCp7fUaDWxPT05?=
 =?us-ascii?Q?61qM0MAI6EyjCKFbDvTd+bL2soop/Yaog4RzI7TXEFz46sJES7skJZTPce9E?=
 =?us-ascii?Q?aHTZwOA7YLRARQnNvqVdf+vfLN+qhOMg8D7A0e+Dfz8/FCj+WB816KYPjQgh?=
 =?us-ascii?Q?tJ7rz5gTE0eM4b5PeWPnZPrQDaPjhckS6FzCpRDNroDEXGmHWbUUV91RPFiu?=
 =?us-ascii?Q?IgrvkdvhMoe2Oqgr/3JIOrH1ZCVBnKPYJVZTSLoaLbkypqTmCzErDt753159?=
 =?us-ascii?Q?V8tLzU6hM0BXklLDl9uA4sBubhDajF4JDEXgh3Sefpkfq/lATAdQtjOdTb3Y?=
 =?us-ascii?Q?D2UtsYSGwWZ/eit+9Z5kXMSAPgr8Y/RkwBaPaHptvnVB8OJMlEFk6rGyIgNk?=
 =?us-ascii?Q?rZ/iiFkvtmtUTWLgGTDnppL7Az6ybUgiaxVVKpm2KdDWxhiRuQkYjqDM0T7G?=
 =?us-ascii?Q?z7UYLQqC0+G02VYF1bAMSXAbO1HvVsvwZArgAU+mWVUjzH+F7OTD7gQAzdNG?=
 =?us-ascii?Q?esNwGjV72UqUzeviFkb3+k1J/TSeiX+t6h6PwcwknvH7WTw2Z1HQGVqwArh0?=
 =?us-ascii?Q?i5d0hOvlS1Nk/FsPlj469iNyN9+fuhB6Vt1fCw7ASsOY1J55gDxanlcu7CHB?=
 =?us-ascii?Q?1ojvUZY9RXYr11jj2dwYLsHgmw22ADLTMvMT3e4JnG03LxtFshJ6cwqRturk?=
 =?us-ascii?Q?zG3hwER88MatmhSpQtOE5eqn4vT0y9ujPtxIqwOxeXu0fMK7vzQhyA0lYKX2?=
 =?us-ascii?Q?8IlPbiDjVELneFF7CAHTPQtbwYFPD5lV90hiD9fCPwHwE1dQsiohIVL0WlN2?=
 =?us-ascii?Q?9836IQ/qJFmOyi+UB8SyzOm1e/39EVI0aeJjjIDJyXtEou5YjqbO4CG97ruk?=
 =?us-ascii?Q?ViC9dd6OGV+2Six9Izg0fxQmsQxw2FiE2OhFPZPry4CERkFS8/v1kxhRIhwj?=
 =?us-ascii?Q?NCkQnBr+CfJ4KRseDCC5Gku/1iWMMwdg2XhRXKh+mh5jmpEgDrOGjQfD+pkg?=
 =?us-ascii?Q?0bTwioodsRHfTTsv2ehRoNNO+5s9w8aZUDukthD/S7W5O6Oz8zTFMhsnzf0t?=
 =?us-ascii?Q?s7hcsTxtkgkl0f2ShLr4b7VN0SoRpWBw8i+ArqSePR4vdCZlCBTIJL15Fjmd?=
 =?us-ascii?Q?MDgYlJAOmTYIQE17xCRytV6FET7fZvfw76cZYly4oXb0MHPk2zwBoJfqV7x2?=
 =?us-ascii?Q?ywQ6pOkhZJNTNN2qigtvtPKalyy7gP/ddE1e7R/zh4ATD8uvVcwOEQYIUCWO?=
 =?us-ascii?Q?cPwaneQ8T4b8PIdJMKlvKF8z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7423a3-c9d5-414d-6fbb-08d8cca14c87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 02:20:42.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5iviQudsog5zQGlLHoLq/1sJLN09tdrZXpSF2K29/LS8syeR9xELh9lFtqwUyOomYddl2qeZmRQQL50XPJQHPd0F71GA7orNMPRYsfExZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Currently driver allocate memory for ReplyPostFree queues in chunks of
> 16 ReplyPostFree queue count.  On less resource environment such as VM
> with 1GB and two CPUs, memory allocation for ReplyPostFree pools may
> fail, since driver tries to allocate a memory for 16 ReplyPostFree
> queue count even though the actual number of ReplyPostFree queue used
> is two.  Now, the driver will allocate memory for only the actual
> number of ReplyPostFree queues instead for 16 queues if the
> ReplyPostFree queue count is less than 16.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
