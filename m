Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E612C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 814DF60240
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFHDGz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:06:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhFHDGy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:06:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834mlV087168;
        Tue, 8 Jun 2021 03:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ge6pzJt2eYFNPAQ/3R9HYRKTHYwHe7F11E422F5jOF4=;
 b=TKMxU+/8L/MgsxBfJWHBZpm+80n0cMhNuXoywel6qF43gsVhnJuoiiVc40e2D9+WkwdB
 ib1eVyaUaLOV3nG4vP9keQI5aip2tJRZwyqTALM2RM90LjAO0bn57Wn1azoBfnxd6yn7
 knr3jpGz+GRjvKaQfBvRQzPBoN/OLPRO3eumzp9XaPBIbZYyBsMcyXZGJy0BkFdJopF3
 Sa8YguciGAGmrvNpS5HE0COCXmTyr9lC3phD1Yxl+pbirfzYlLyWH82THhF6asNECZ4p
 is80+oV8FvmRIUUsL4pUWGloSj9KN5XafmE3Z6/ZzkS6XnOAPLqZ7p9v9xrsHI2fnxZQ yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3914quk3g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:04:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15830KYJ025584;
        Tue, 8 Jun 2021 03:04:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3030.oracle.com with ESMTP id 38yxcube6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSALj+DcmrtYuPw6l7sMhthESi+AubQkoxGz/qRSCgJQMYN+hB0/pIad2pjuPY0PbSVK2b/PbxovEgaqks+Wywq/O/RWOXerbWnfCllQXOzxFf9awInfpjUE0fDbvPdhbUUpOfMFp6L0DwgYp2Ek/lNRDY1slcFHWiy66z5h3z+NdWJ5rd8DISOlzSG2iAIibl9byRsDInyQ+RRXtDhWvuEsylKruk7leuPV7pHWM78jyUQ7Lw3WrIdboE1gG9/LWAkMlhoBH/z5/RMu6beP03GBz2wQD4gsJQUU5ZJ8DlDzJewUY8LWMp7JwZG5D3g8v8zpD7NMjhF3P0U75dbGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge6pzJt2eYFNPAQ/3R9HYRKTHYwHe7F11E422F5jOF4=;
 b=NXasfKS9/pNkrQ3yv9O1CI23t+KFcUkc2jAaulxBFbxYARdEbcl/xR3zQOhE3oycJWj9XNq0QQxmQhrQXR/Qgep0/TCtOxr/btNKAKjzl3n1kOiYqD6UqBxBoEnG9dYx3EnGtvp2T0rbWLAERtQcVFE9zTFZUIX8eYPREdU/OcM/BIjl3lpnRxXUbU3W6MCAWB7HNyZ/zasU6VLGM6ink8GZNTBBiZFxv3EipoGRP9pJu5D0YAE+sClakbfwgYpz6fOMzAqefkVxE9MucvcS7OfDj6RhnCBz9PKIxbM5G1dtW1YfBCbrYx4LudIO0buwawLecnRBRLnvGH8UkQZ0Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge6pzJt2eYFNPAQ/3R9HYRKTHYwHe7F11E422F5jOF4=;
 b=w5T2AKt8RLy1v74SeI/XGx8jTxhuvDf1dWhL31S17HogfOKcmrOCg8UUOT/Vqa0UBR8h+MHhVwqhPlKHu+RD4SwqdQy3nDjm8VEyxxU0xv/d27wnEOiBIdCGnBXZ4bUnJdEUTQM/JygEUIrN4y2o2Cw76MYKt4Xx5qx+x8QVDb4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 03:04:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:04:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/4] scsi: fix failure handling of alloc/add host
Date:   Mon,  7 Jun 2021 23:04:40 -0400
Message-Id: <162312147179.23761.17928285777294218384.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602133029.2864069-1-ming.lei@redhat.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BYAPR11CA0037.namprd11.prod.outlook.com (2603:10b6:a03:80::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Tue, 8 Jun 2021 03:04:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3efd3910-1d1d-4336-2f73-08d92a2a2a86
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB451917710DC98B7AF28349658E379@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3cO5nV9nqA5M0mwKK7isGmX78lnzSOy6ke7Qf6HmpoEqjUAxmR1FKeOLdk4wS1cKp4eVPWvNT+bWEPGMF6rOLD4i852/fzrjznj7xNnx0LiX8e/oQ7wN+JCaKquWwmn0H0KiEmfuJj9DLajvFO8GUcuXIS0SG0ueJrpnp4ntffMCHbGx08lRoBlB8wjqFMe+jJ9Le3psetXSCpF/0gW6Va2R9LXbqtVaurWhK2KEYNe7dgxAGjVhUEDseRxbeT3GuHU9L2yBlFK0+yISBFAjRwrf5ooxgtaIK/r0ijRb8Au2aSOE9m4uI7RAHH1wugyicBHXtzXgawpmmEuXvJEe9Y1hfoaHlU8H0t3++vVfJAMxIQ0K8rb2ee2J3uwGUbuG6t5sbfU9eYAxYj6wiHMdss+/htaDVkj3HB4OaEeozPTZtHLkPFqRsgn4E4erySUpIdGoa1xcmxNlvwNb1s8PEm2LO2I8btiYAQZwaoiisOlfVxHt7EGlPw8kMiYq+6pr9HxquO+pbJawpGVuULWBgYVY0Keal1ln/j4RqSdGS8mKqH386iSbGYUaCn0GOx0HekNKh5tZFo2nexiBkDZ4FZVTRjxspxzTeJFyBzYkcZ8vs5Sg5+KECo3ScOrRRRQN+36Tu1vJtffjkYLwdEycu9YF4z+wvzLBIduelpOr0z8Z0VrN3UcwZSlC52RjoPLYzsEG1S2FBRkedszYevW4oKfk0UZVO/XIv1WzO8o7AKc24eXc4/Re+BGO3wfDs8EyuO0N4lBpySjEZ2ydeRAtk5obz9Htz1vimgbnj810FegC/UCkpwGUF8TjzLb9jzdB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(4326008)(66946007)(7696005)(52116002)(2616005)(8936002)(316002)(38350700002)(38100700002)(66556008)(66476007)(478600001)(186003)(16526019)(103116003)(26005)(2906002)(36756003)(5660300002)(54906003)(6486002)(8676002)(83380400001)(86362001)(966005)(956004)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEFXcEIyeGlINTBnZSt4N0EyWmEreStHbUdSQVFhdWU2V1ROcHBpMmxSV0Fy?=
 =?utf-8?B?WHlPR3VQV3ZZMTBwd0hCaFl3RTR1OHRucmZLQk5CQW10ak0yb0RHc3IxdUpK?=
 =?utf-8?B?MG1SOWczbGhPaDk1K3ZReXQvWGExRkhySFpxSXc0RjRFZTVIaHBpN0FFeEpM?=
 =?utf-8?B?Wm1UMnRMbTVGczFOYWt5Wk9aMm9MNUpMaHYwRjhLK0FWQ3RBUmo3ZkdZbmxa?=
 =?utf-8?B?ZmFZR2QyZlhFV1F2WTJwMzFrbm9YeTIzR0FZcGYyeGpZbGJubTd4TWhZZWFE?=
 =?utf-8?B?SEl6YTZ2SHMzSk5NVVpaVmdVUGUwYkgwR01HMmJmMHBjK2ZnWTYxOUI5QzBW?=
 =?utf-8?B?a2tTTnViaVZsNWhRa3VESk5PdlFOd2ttWFVsM2lYUWNtS21VWTFZRkwvMVNq?=
 =?utf-8?B?dFdNRGtaTnlTWU1qUkpna0VVclAvVHplZlBQYjFTUkpzSi9kR2tpeDlkbnk3?=
 =?utf-8?B?cnovYXdkY01VNEdYR0lTaFQ3Uzl3dnczM3BvdjVHdDlZaHpyQWVWRlQ4S2o4?=
 =?utf-8?B?ZEYrYXJ2NzJtOTQ4blVlaUFiaUUveTVxRVJ4VnBUQ0xyb0kvd2Z5S1A3eHAr?=
 =?utf-8?B?ekVQQ3U0Z2tqUU5jNVhWRXpZeVlzSmxhR3NuNi9qNVlWOThsVkRyZnlIbHEw?=
 =?utf-8?B?OVlwSlFyZkpPcnBlV2Y1Z3diN1puSytEMGtiUjVBSlZ2OG1JNGVTNjBlUmFO?=
 =?utf-8?B?Q3FiZlVwY2lvT3RVZzVKSXd3dUNOd2NydnJ3dVp6aWs1UWxGUXlpeHpIenRT?=
 =?utf-8?B?RkxVUlVKVEUrUFFyMGpLYVRXZmc2SEUvZlRIRXlaelpTOFhDN0k5ZmpOWVJn?=
 =?utf-8?B?TlBXdVB2RjhMLytUTGk2QXRUaXFuaUo2a0x0MzRDMzRpamtNYkU1eUNsWktC?=
 =?utf-8?B?WnVReE1zanBzaTFnQ0cweGlsWWhncVVhYytWWXhhcytmUkNJTlVqVTBWREc2?=
 =?utf-8?B?S3drYXJVZlBtL0g5d0NXd0E0QW9wMmxPZTNyZjBRMGR4dFBHcDRmQkdWNWNM?=
 =?utf-8?B?QlhGSVZtYWpkRzQyTGlSRDVyZVhibmdweGpndXhHNExVQlozKzNTMGlBZ0NP?=
 =?utf-8?B?dGdlVHU5KzN5NFFUZnA1SS85Szdac0NmS0pOZmV2MW9JVXdWYlFSTVRkdlIv?=
 =?utf-8?B?UWt0NC91M1pET0ZaZitvNjJmdnBrZm1QRGJaRllEUkpUU1BvS0RuYVVmMEVy?=
 =?utf-8?B?d2VVZElYVHpUNEN3dXkxUE42ODZ5d1lmcGhsUDFnRWY1SC9ZeW8wZTRqb3pZ?=
 =?utf-8?B?dHlMWmlBZVV4b2hBSHJxSG5XQ3B2cG5WaE1aZTdjVVB3WjRNZjJGK1diRDNJ?=
 =?utf-8?B?Rm9pSTI4UG1jbmZ0N3ZPUXNYZUtBVVRaM1VDc256RzhPZGZoTTZobTZCcWIv?=
 =?utf-8?B?OGVUUjd6SHBBN2d4VjhMd0I4c1BxMytMNkpoQUY4bjlKSWlWaVZpVTlqUlBs?=
 =?utf-8?B?RUJoMzJFbWRuVk5rN3pNNkxWV1lkbHJhK1h1bjZRV2FiK2JROUd5OHZoRXRl?=
 =?utf-8?B?S3lkNnFaa0xxN3NFdTFUdkpmYkNyWm5BY2p3eWMybG4wOEdSMnNuUlJGbUJS?=
 =?utf-8?B?V0tBcHdmQ0FEdG5aWDRwUCs0aW1mU2dNM2xodGxxaVdFYllkZUp1QkhHNjhX?=
 =?utf-8?B?dUtPaUZIaEh3MnJsSVF6V3M4V0pZMk5iZ2RNRDVRcGJ2WjFMSG1rSkI3Q01U?=
 =?utf-8?B?cXh2bkV4a0doejNHSE5ONi9NMTIzbXUxUzBDNGVpajJBMGNPUjljNU9reklx?=
 =?utf-8?Q?umHh0m3tbuIG/DJMlQDwmH4DH1XLDtC2r6l+JVB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efd3910-1d1d-4336-2f73-08d92a2a2a86
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:04:44.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NCEKHEI59NLJFU6KEVzJi/zLaMjhgp6WUE+7WZ2z5l4L6HaDMdTkT1i7yKc2rQpSe9c8teupTCqqRWftB28ZKVm6sMbq2Rs1LXbcfA6e0oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080018
X-Proofpoint-ORIG-GUID: aNsiNiFr20NeUaO0kXK_ehprB0CV2gFd
X-Proofpoint-GUID: aNsiNiFr20NeUaO0kXK_ehprB0CV2gFd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Jun 2021 21:30:25 +0800, Ming Lei wrote:

> Fix failure handling of alloc/add host code, and related device release
> handling.
> 
> 
> Ming Lei (4):
>   scsi: core: fix error handling of scsi_host_alloc
>   scsi: core: fix failure handling of scsi_add_host_with_dma
>   scsi: core: put .shost_dev in failure path if host state becomes
>     running
>   scsi: core: only put parent device if host state isn't in
>     SHOST_CREATED
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/4] scsi: core: fix error handling of scsi_host_alloc
      https://git.kernel.org/mkp/scsi/c/66a834d09293
[2/4] scsi: core: fix failure handling of scsi_add_host_with_dma
      https://git.kernel.org/mkp/scsi/c/3719f4ff047e
[3/4] scsi: core: put .shost_dev in failure path if host state becomes running
      https://git.kernel.org/mkp/scsi/c/11714026c02d
[4/4] scsi: core: only put parent device if host state isn't in SHOST_CREATED
      https://git.kernel.org/mkp/scsi/c/1e0d4e622599

-- 
Martin K. Petersen	Oracle Linux Engineering
