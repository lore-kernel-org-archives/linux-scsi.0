Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FE4C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CA86128A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFBFMv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:12:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhFBFMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 01:12:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525B6Ol138208;
        Wed, 2 Jun 2021 05:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IWm3Yr18bcRXsLJOOeF9Lp90g3YHSSR4tmm0JnA8TLk=;
 b=TA76aKvSA/xv8NswBIaKJWqwCzoBvYp21eSVlVSKq0QEZSkpP0J2T+s5KbPg1NLR3csH
 bGGJYdA6CFRGERBRvYGb/iQxJiWwGGU8hFfHBFpo364OQk/JGiXr+diZJ0Q0saMKXEGY
 BZ0V+2ic5IS5Yx1FJDnsfSBGvW5vRBqBc0rESl3fKhgCh3d3JWl5mKg8q4WVrYy+oocI
 3lftkUwrybZh96rXEUP+SjVp3ntiTD/FFpSqYsoWxTST+3998CX0a6ZX/YpQwBTU5GgW
 hkkpx2L9m7py7n27F9PdtYvnI6ZXVkbLu3O28opQ1uFW4O/Zs5I9+CrGBMAHbgjhLlNc ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38ub4cqdfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:11:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525AV1s126984;
        Wed, 2 Jun 2021 05:11:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 38ubndqhbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:11:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWk46ODFXI0ylX6fpHHWmYrLweZfj0t6kxM6/WpERonpqf4MZiKGaesVLHuiraTgFPZor7niiESawPk1slQEQ8RNFp8H7twY7XbYqJ9cR3J4zlWR9K14pRIM/XDGFOw2o2HAM+lREGm8YhDtS1vxzHrd9BknqqTv9gaDR+D5BXjljcVoa/shFAsRUkKv6ESufIddSl/S9o8ayODgPDR2rGPbDcdFanEtkdgu3VOhq5V6FsCPetNCs1b+6XWyqK0jerdVhBUx55jkz6I+Vfp2IjKtAA6SUW1vWbGllk1e5EZMY2FFGEOmHSoIf/Yr211OSKACOK5zLGqvmp2PmEvZAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWm3Yr18bcRXsLJOOeF9Lp90g3YHSSR4tmm0JnA8TLk=;
 b=MV40cSwPVrmOCfMLiJUO5Un1goMe1vV4DdUqTBdVDllb2WE4fVftThdJ6quG0PIyoiyntz4O+rzuL7VyK1N27+wWPkio4oEvvTSTbvqnr95zNvF2wufzffEsJyo79mTF/SsXliD1Cscndu6apW0jGOdnTBmH5iEz2QBIsOaaP7XRcED0T+PHBRyoSCnEMP7TX3aQ9aKjfYyu2OLAjaLFstzP3AylUAkK6bPfxVbEc54XgjPugJ6eeETz5cKAT4OlV6/DnjR73AoUC0G8aGATKCZ2AGHp2FdtNH5ET9mEBqXMivDFdFtuXFpp5vO3FsBVCc9x8mCs2SeEVVDkhasVLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWm3Yr18bcRXsLJOOeF9Lp90g3YHSSR4tmm0JnA8TLk=;
 b=nXMuY9HrjzIib9IuElOXuV5gxtE5kI/lf+dyHu2TegwF1ZxOe/Wc6eawLCUln01t2RT2zTizJi6PGhTeX+YchNL2tqmbe3jidqWeaB/s0HfJW4yZsd1TrC/Qcubdx/kblGMOFGsFi7yo+mqtTnSjek/f0c77gdq7M79kEzpUm7U=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5403.namprd10.prod.outlook.com (2603:10b6:510:e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 05:11:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:11:04 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, steve.hagan@broadcom.com,
        peter.rivera@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH v6 00/24] Introducing mpi3mr driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf7sontw.fsf@ca-mkp.ca.oracle.com>
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
Date:   Wed, 02 Jun 2021 01:11:00 -0400
In-Reply-To: <20210520152545.2710479-1-kashyap.desai@broadcom.com> (Kashyap
        Desai's message of "Thu, 20 May 2021 20:55:21 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:806:120::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0044.namprd04.prod.outlook.com (2603:10b6:806:120::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend Transport; Wed, 2 Jun 2021 05:11:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60204363-248a-423c-fa29-08d92584d204
X-MS-TrafficTypeDiagnostic: PH0PR10MB5403:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54035D6DE9B4AC58CE054E768E3D9@PH0PR10MB5403.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rL7AkKuV73wmikQmzWfHp+4PrqmreCC+o3WMq8mP7q7CIL5R2ljignvFasxUs7PrgH3b/GNAqCpvDSnGaerF2Q7OyRMV++uIFLdE8R/mMfj2N18Ojac+g5F7PFqBLZG7xmV+YdSfC3Hw6bGU0YKxIkeyc/+HK5z0Mrj7355oBENWWeOG/I7heBKNZlRVoxoxtkuhXtjNMLfxx9OgHRusMx53KEAq6mz5wm7o2UZg4xdhTTe0QaMg6Z/8VDvcOTk+2XrXabsYoc/gzgC+w4FmUUEWAKLEoMBTZNA7hAr4KYEWgoZU8odJ0EbxjvS64DBZb0odsqCGQzkfx7TNCj3N+p+VU3QFGmUOcE06RQBIcsJZbE941jM2y6Nal3WFpjPmaIQeaNmPnW3lXAruuyNR3YCoiJ3mBGT3DltjDaxf4FlUKhdO/elM2ZempA452UQq/Ucv/VvZ4f+ex4Ko+1An1Hf9GjZD+SGwmqWW2jf6dkUX/vQmq0cHF14iPXRQhiY7Rd56f62KhRmsdmHitG1HRrnwUutR/itNeClzWOVuPV8fqBfTDlGCUgaHiMzi4MpwAhIUH0hk28HBmUcf/LahmtG/69+bYugb+u+mxBTgPMkELHULmAVZbzytTzanTODh4O061LNE4vFCnxWRSU/rD4+vmcbtldLkfZhtBjxvOST9sIAE324/AEQ65qyzG1Ar5NpB3gMuxSlFuHpfC0Ufqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(366004)(376002)(86362001)(316002)(16526019)(186003)(55016002)(4326008)(4744005)(956004)(5660300002)(38350700002)(66946007)(26005)(6916009)(8936002)(2906002)(8676002)(66476007)(66556008)(36916002)(52116002)(7696005)(478600001)(38100700002)(42413003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3NyPM4VVST5HsqNorH2Io9CgGZgIb2q7MhLpzmvyauEGXMiV9nCll7UsHqBG?=
 =?us-ascii?Q?NwaTxKjUVq+u/6tqVdd93JNei6VWA0BBpM7W+MKcyEuy8G3ZoVz7s9wLgwIK?=
 =?us-ascii?Q?LCc6MYm2B9lxuNCuHCKIaPmwv3iYckwVH/FAnIFqJoIFoLsbEZr6w61qWMna?=
 =?us-ascii?Q?z43un1PBMIZq2ekp48L+FkAGYuJHLrBeu3ckzAIOgVG0bE3jb5c0m1mxiso1?=
 =?us-ascii?Q?vhl7321rpN6zCSGDNypnDCtpMQC+0IZHn+7OiV1Ls8pL6lJVu10LgUOaHxVJ?=
 =?us-ascii?Q?TLSBUbfFlzEh/5DvmCTWr94TRaIdFEkyYX3vX9ORUrRbYAFP9Qhtf1QDqBRB?=
 =?us-ascii?Q?Lq0vyVcv30DOlC5IjCKy1rS92nF5yGtfSzL3VxVEpKPdn0GdS3B697zqe6uh?=
 =?us-ascii?Q?5KzjFa5nu0KcdRAb2xBuq61cW2dCFx4cs00UZSr72c5lK96IGXMfgWVzOC+v?=
 =?us-ascii?Q?przAffN3hRcuY88PtX0/vmet01f7b0xypeLA68qRvNRfhzXVqPu/KL86t7s9?=
 =?us-ascii?Q?kVDFyg7aizbnMECWb20vpiinLrSs7pUshC3kLrlEKGNG1gwvTeaXSZ1WnowC?=
 =?us-ascii?Q?IxXTMh8RUaPjEhqbJAnSWxF85KARRWy5N5uX8gDxhfFKwmC6LodVI3sVYoYW?=
 =?us-ascii?Q?aGzTmgI2mu/nc1sioso0jygEziTLdfHqHny0rajL/8UJanQa/+RKNwyISYXd?=
 =?us-ascii?Q?BQf+GrEdr8orIJPUILECYEZ8fj5tUkiCW+NxVh+fjXeFcaK02fF2c7DakA/o?=
 =?us-ascii?Q?Ef4H+yIkA+fGBysvIrOng0Uun+ySH1NsFWavIClX2VqXsNWaEYbM+4Imusey?=
 =?us-ascii?Q?qXSb+pH7m9Cn7L0W5n2sepY4Z9CAlzlkr79UZFkfSFtPmExtrff6z44ZMzaw?=
 =?us-ascii?Q?EwuwoMEH+WTT1rHTqfl090vVTyhc1NG2/pqhnRdIwukT/SmTTBRQwSjafGh5?=
 =?us-ascii?Q?oipXO5kMyjn745SEbJzBtenbuXw7OhAYdE0xTW23FclHtj7pxRXTB2mFFgoz?=
 =?us-ascii?Q?6TpGb65SD1LeiJfFa25KUUC1RwMkaH2HIHenTXvraKNInfjCcqc0B7wPVXdc?=
 =?us-ascii?Q?gNMhpMwBiJVhPcu3pgAyeh4INptfwuEJM/L0p9Vsrvd2B4wYfH5OsxOe1aW0?=
 =?us-ascii?Q?soqvVYCNLdN2B0MIqybjIxjIto8xRtnRD9vx57VVO8x7aKDCRx11WKnV4Ve/?=
 =?us-ascii?Q?a1KgEPwtCubSkUvzzoc1QdFiuvA2hsU/9kEBkrAvVPT485EWhtjuJEqeLs0b?=
 =?us-ascii?Q?VI4xCGaBc6Sysm1VUVmOfKqQ3oVaw+hcijN3XfYE9Mh6TcP029GFi9hEUsOR?=
 =?us-ascii?Q?a+ig421onDPaBNgUWjkC8e3s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60204363-248a-423c-fa29-08d92584d204
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:11:04.0213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04Dz+Zz0vBDiclnk+fW1g7WTBf7l9YP+fjilGs8LHy4HAGOpxE+Vw5DoeIiZUGEj0oGMLiK16LWF/+yQB1otNyM/OwNAlf1cO2qcl9bnBuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5403
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020033
X-Proofpoint-GUID: 53ZLQE1LRnWggTj7cRuZIPcGwS6u4iVK
X-Proofpoint-ORIG-GUID: 53ZLQE1LRnWggTj7cRuZIPcGwS6u4iVK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

Applied to 5.14/scsi-staging, thanks!

All your patch trailers were bad:

---8<---
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
Cc: bvanassche@acm.org
Cc: hch@infradead.org
---8<---

You can't have blank lines like that.

---8<---
Cc: sathya.prakash@broadcom.com
Cc: bvanassche@acm.org
Cc: hch@infradead.org
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---8<---

-- 
Martin K. Petersen	Oracle Linux Engineering
