Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948AFC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B2E613F9
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhFODB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 23:01:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48998 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhFODBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 23:01:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15F2tQmB051412;
        Tue, 15 Jun 2021 02:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+mUqP4AY9fKYvA1UkgLIAgtkf4RPriE9VtQ8e+PHl0U=;
 b=P+99QxLNOZBRaYGXE3Rpj0csMbSgdfUesIVKp6SKEo1+6UOM5CDKurhTC+aRF8q+qnmI
 a4J37rb7YBUO4NBXCXStt/OZbd4WW0s2xbOhFNx2gxy++ILqDWFihR6SdWfOzD9Kpefl
 PJcdKnKnonEzLmwAS6AfWngCgK/oi3lQUygDFu6JGtmkJ0g1g/lc6cd9oX/bXg7VJlp1
 beVqWEQplicnJTEa2dNmUCTWz47dNNal6jcgy4a2gH8nEOtEcXxxLDSxZGVvsh0CepjV
 li7VX3fJf1blejRqCgFtgkNSeQm2ZHnZ52kECf6FMrWyfCC3FJkuW4N5PJf7p4pUOUN1 UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 394jecd1ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 02:59:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15F2swYu087627;
        Tue, 15 Jun 2021 02:59:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3020.oracle.com with ESMTP id 394mr7um4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 02:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SITdw9XN9rLHK430triNaKW2snSKushV81mQFNkYiSxVZiXU3pdN6K5GRsGN7ws19jfq4z4WL5uZvOdd2XL5WanVHBmRl709L8CgpWEvshjWwW6mLBEeQ1FZOBW4BfH1eECJSUMG4RrAQKGpy94CqkfBEjAaKfrFGn6iA8lHINiC7Peu75TLe5Me2Z/WT6d2C78QI2Zm3MUc5RX1PgZyVWL2vd8NUAiXa7kTjodoAfkGMiyJ2jSb6eI2AqYHpCej9kEAy5YW8tLMuwi3rQFkGLrEZ1W9b04xJH6v7uPHnNrtJArwWZuHdeYeNdiTuf73gbP/oi8nr0ziMBwSAhIKlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mUqP4AY9fKYvA1UkgLIAgtkf4RPriE9VtQ8e+PHl0U=;
 b=I5Ef5F6rMOPcZiosQgLpADcfSQD+LSstpCQ9hQHGG+AUKVz9LsaeWCqouNNRB8SRkZrPK+41NdXG3I87QXY4oRo8GcQHZqpYC4H5u5LSgQG4rWfDMQfg6y7l8/uQ7wWUxcfVMWM+sURCI41kOkioojGmV3IkqZ1/e72ARhRW8zF52BduQAtwy8AGQkEEv4tASrLztE+0nX49QjhoCb8m/EbxSyct49Y+5iAnhqfmN6SIgsSn/3TFBQ+4lv6jN3JV8NomekL52kzr+fZYcMGOuVinPE0K/3qlvjGu+mIZTBAay07D1EsCpqPSZZhf/7LX3ZE1uotRMJs5vceQgXNeEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mUqP4AY9fKYvA1UkgLIAgtkf4RPriE9VtQ8e+PHl0U=;
 b=c2RdhxFFejrSDutd52PK1xgF+h8qdEYvXL9DqDm9vajUKR668/6nifO57JFhirDb2AdbQkTFWp3OWudVvJWgf9E+goCiabUH1Wl17I8qq0ohuz+4PhsuTWe3nr4fcBmTZWCepR0lvHSLO64v6Ngf+oCL0vDrmCAg33JTuirtFAI=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4790.namprd10.prod.outlook.com (2603:10b6:510:3f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 02:59:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 02:59:36 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Jiri Slaby <jslaby@suse.com>
Subject: Re: [PATCH 1/2] virtio_scsi: do not overwrite SCSI status
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnqv972s.fsf@ca-mkp.ca.oracle.com>
References: <20210610135833.46663-1-hare@suse.de>
Date:   Mon, 14 Jun 2021 22:59:32 -0400
In-Reply-To: <20210610135833.46663-1-hare@suse.de> (Hannes Reinecke's message
        of "Thu, 10 Jun 2021 15:58:33 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 02:59:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47fb1ac0-54d8-42e3-b0c9-08d92fa99bd0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47901D27EEB528F8DD97AFB88E309@PH0PR10MB4790.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSM7Mkbxo6WoR5ikH7mpD08ZheWTE76Ey1/dIDncnNheUnTuWx1hD9soWvRgPmib11Cq4XVew0tqO9hgd2VWQYimX/cIgq01ul8e0b9bIavluZbh0VssAm5971tJGmEvpfq3iwA6WJmT91+CYpOvJtkbBhQUu9FrtMyclbKcCfUN2+J7CqnyJDDHlZlGFquEMBAgfBidPrM6eWGFH5YzRxrMWmedeWBhGsdZZ7juSWYOJgVUSQo0ZWlZcu1ylQaWS+5DMLfqpQ7FDkiwfTKfTZOEduSe3u9hHpmrigOEr9jr0LmYRkwG/JZ1Nxvqmm7Sv+MfT1V496e6gviGBzPyIJ0aI15sLvwQWjUshE98c/cYFLAtGfqtwXB5B3omC2jnESBy3TWv5GAXLIh0RFvSD52n33Jd5AicL3n7VOeRsnnyJOABZHYVNrH1HdrMt0TafRkVHl5agNRDi1lexU84b2t3nj9urrdNmxOny4JaYiC7j3JPvpnbglJIUcsEUYfLXtjfTgqd/8e+MYRqHjJN+EYV7y+zpafgDZnHoVyJaj8ZReehyy9pAF+ZZIh5d1jezR3WzAqfq4XK8I+AecTQ4+H8rhXIMKD261TTXhwScxjVAcUalW7AGtdpou9GL+dADrcDC8rvtuvLf3qUROEBqUbDwgubl+/hyorIy9f+k6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(396003)(366004)(136003)(55016002)(66476007)(38100700002)(66556008)(38350700002)(478600001)(16526019)(6666004)(52116002)(66946007)(186003)(86362001)(8936002)(316002)(4326008)(8676002)(36916002)(2906002)(7696005)(26005)(956004)(54906003)(6916009)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ogQ6EL1mZGkv20kixdmW+hLJivrCQdiMgkDafaA7ITSK6sllcX5/YqSXS9Nl?=
 =?us-ascii?Q?TCnGJVrM7koVkeuclNdHP8DvWloMaBdx8xylOv7o6xo1sIIHu01eKU3YitoV?=
 =?us-ascii?Q?2CaepOihfvHCK+hsS3CE1fNYlnPIIo9+xj9WOtlsp0qdY6Aj/G0uVG6Ext5u?=
 =?us-ascii?Q?iltiw1zjgHUPYFRvh2LZvU16IIMUpPlTT4At0p1yeeFrXAt5gDk4FrpkGyCm?=
 =?us-ascii?Q?oyyf9E3BxBFOETNE953UIcUHPv6uJ9/8GB+ZSAI9a2QwEwyJ0j79d85exhCk?=
 =?us-ascii?Q?o5PKrM+p5GckSP6/Uy65lMjtYOAC5WJ5l5D9vKPImQdifQgTuHNBSk3v5C1h?=
 =?us-ascii?Q?9kwcqxB8EGb19TMkGjpIbjcSCCxQWWAifh07ycjivwm4OBVoWfAhLrTNtUNB?=
 =?us-ascii?Q?laizJjVqESnJbTGpmdiTpT/CAwgCYUONNI0NR/1xf63qlR3dmt0TYx7IHpL7?=
 =?us-ascii?Q?XjCSipipyj7EYsvoVfjNDciQp4liLt1jstQB3iyzEMhb1wV30CsLNQK0g8PA?=
 =?us-ascii?Q?1gLQvH2OCJ1eMM+JQTZ0LtmuNnMhdazDxcN2I2kDNhAxcmBFcdmb7NanIh3t?=
 =?us-ascii?Q?6rleol9RtsV9j4gWxoFxsPw/W51wSPBTCw0I++r5fzq2bNhNFu4l/RL4TSP1?=
 =?us-ascii?Q?W0pd+F53vlEtiTKeMh25Ob4lSlR6D0b7TBUfLOlsSj+xp1PRplL17xH6fl0k?=
 =?us-ascii?Q?BduhDmN4belDTGiwfY/OA9Yn69k6+dg20rYpD5cySwFsXfPc+FwR5STC0YDy?=
 =?us-ascii?Q?g0j2dPI03i3qQFlPIPytTZkfv7MPY1GF7yHWGb59gt2+ScZYvIewfyF83Z2o?=
 =?us-ascii?Q?9G9AzY5utL6JtzGot1Cf6MFaRCfBqJoToYlXpOoEbg9MK1iLuYp6O3b3rCU3?=
 =?us-ascii?Q?xRZzzimLeYOt2LHXJKyFr+MGqUj5O4djJ9+qv63IMne7fkYA+M3ENJHToVIz?=
 =?us-ascii?Q?s0dBU/4StqtPOZ3vxFknLOsODZhgw09dZnlek1SNGfa7h1ymJ6Yn0Ay9RZ4l?=
 =?us-ascii?Q?W3O55XU/iPkXO3qYCmCcJwCFP0xbRRzV0DnODQOF0tLa84sgJpGvpx68GJOV?=
 =?us-ascii?Q?4t1rWbTcuY1jAgAvrvZOaSEqvAkc4EQFSYWmJEJmf3DFZhgzGdEZaMK2uhFn?=
 =?us-ascii?Q?y15HQ9j29uCClGovcTfdkDsZ7xk0nlbu7oiQoU60XuZXuuxsE/urw5aM+sj1?=
 =?us-ascii?Q?lMdsC9hoxDK+rcweSoD/9gkwGZZOxCmjfea6lZ5oi8mH7s0yMO6aj7j8Cp1r?=
 =?us-ascii?Q?4Bvm6s+4EWfk6jw25GOKZA2bRov3YOPo9aYyV6g+Clpxw9Ui4mXFDGRJ35Jh?=
 =?us-ascii?Q?PJWYp+OcQr9UPBAWyNvbRzg4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47fb1ac0-54d8-42e3-b0c9-08d92fa99bd0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 02:59:36.0575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIGUzCF/hk1W1OzbMYgTWE9vKbFTdQE9B7zCKKzI+2e1y8QmCWvHLBt13aWrdNDAaayOhMBsba/TgUV2WRZbnUlHUhkX70nVYFUl/8lL4pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4790
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106150017
X-Proofpoint-ORIG-GUID: 5PjSyyG2nAi4q7UxA7Jh8Hd51naRLzth
X-Proofpoint-GUID: 5PjSyyG2nAi4q7UxA7Jh8Hd51naRLzth
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 bulkscore=0 clxscore=1011 mlxlogscore=999 adultscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106150017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> When a sense code is present we should not override the scsi status;
> the driver already sets it based on the response from the hypervisor.

Color me confused. The code looks like this:

        if (sc->sense_buffer) {
                memcpy(sc->sense_buffer, resp->sense,
                       min_t(u32,
                             virtio32_to_cpu(vscsi->vdev, resp->sense_len),
                             VIRTIO_SCSI_SENSE_SIZE));
                set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
        }

But sc->sense_buffer is always true, the scsi_cmnd obviously has a sense
buffer.

Shouldn't that be looking at the returned response instead?

	if (resp->sense_len) {
                memcpy(sc->sense_buffer, resp->sense,
                       min_t(u32,
                             virtio32_to_cpu(vscsi->vdev, resp->sense_len),
                             VIRTIO_SCSI_SENSE_SIZE));
                set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
        }

What am I missing?

-- 
Martin K. Petersen	Oracle Linux Engineering
