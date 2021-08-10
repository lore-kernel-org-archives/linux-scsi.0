Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E64C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89A0D61051
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbhHJDN6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:13:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9622 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233199AbhHJDN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:13:57 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3AbZ0024283;
        Tue, 10 Aug 2021 03:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=B2bFqVAOV2YlfNmSTmchb/1HdNGHkbgkK7DUghuC/+Q=;
 b=PWW1GaOc7ozWavn/V4Z2FGzte3UAuBdK14R2ccddaQ+F1AHrBq8DV/MRa2jRru34Sr/W
 O+M9b4Xj0hfyjcV+am8D0xfWdejdDF8Kv1w6Gri2oRareqIwjJrlvQhiKmx2/wCydK0j
 Su4+bCiEjxvv1uIrH7kMd7lkqzwK1qDXATiqQnKcTxkNgiJfJfOBQo5RsMTn53UqADeW
 COjE8cw5Vn1Qt1gzgkMPLWYJMrJ1kYctequJeMkKCK8ESSmInE1EIUJQuxfywimCUCqE
 00rR8uuZhwYQoXLJrSz3PDjaI3MJpzfJKVMhAiUfmCyBtQedWJAgm2tEH7pWe76qoh6+ GQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=B2bFqVAOV2YlfNmSTmchb/1HdNGHkbgkK7DUghuC/+Q=;
 b=JIoSOJi17F5w403w2RKSgmtHU5YZ1V7CeTrQ3FnDJz9OsP5EHqCiXQNGGRMEnxkx/imS
 uBo/UaMPaClZ5QgpBAiGtpH0ZOBfkoDcZdtyrtH++TgG+UXiYJdWodVUlXAq3Fr6HIqO
 OvYBePS1nEuJMV7nSDm2pe1OwjCPeF/gx6Fg5R/gHtxDTUmodeD6qKHin4cIu9CtoYYU
 E1/Vxhh1lQAeQu5ellXc/9gZFaU9TmUR2iDFBwROqeDko4L+uw1bOC6qPie+YWNf0Tn8
 PWD3mIgKOHf4lj2wihHe7gGL+1HGmFUiAKXw0Xn7s8vKeWpeYTvjXN9mCgJzkbDMGa1z LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab17dt54v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:13:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3A7Nr053916;
        Tue, 10 Aug 2021 03:13:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3020.oracle.com with ESMTP id 3aa3xsabrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6UK3dZzqYznTJ+AcglMWE7o4YwmfoxHsEURYIJYBexLv/oRPcI45M2L/1doqEJQch7MxTBY8MuiXcc6nOT7K1YcKVEZgYX5UnQpy+p/omTUVB+XSvOfh3a7qD2zAsQKA2Ndg/f02M3IpQkvqjVithI3nn58ch7qw4FTqYkdhsHEZ+J98113mPR0Fv1yfvTTTBF7dfhS207NbMEqLCM7DvnOU8VSkIzzzNigZUm6RzwjkuE4RaKQcO51RkyXPx/r/pXkTQfPWOnLfkCfwhqclUxSCBKZpq1wMf9Ch5I1ZgeOTfayY1q9p9lS33ZTDu2ifTiUYR09HZRwo1sM2iSPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2bFqVAOV2YlfNmSTmchb/1HdNGHkbgkK7DUghuC/+Q=;
 b=he/aEWrSdikjMklqYL0Ql9l/LaWuESLI/eFHOzvJf9jFD93G2+JAlPvSKLClWLDfBu9pUz2DE6owhlLv7peYHhYWGR3fe4udH7iXHGH588IPjaXzeFVVqv8zNkai432Ui2piqEa912rpz6tvam0rs9uozyxOcoxLuyveyRIIP/uO30ds7+NVsyC1gGksexxpnIl/Lq65o3gPFxE6pvOOPACqWJ8u33xPa/k7vl1GVnDY9HL90qnX+vsqfNqY9CyneJ/5cevdhaHPpBv01nGNwZAYxvykEo/o4jvxLSfr6417HMdu75Tuy7tX0W8RQHyPBaQLahSui4c9x/8XE+LVmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2bFqVAOV2YlfNmSTmchb/1HdNGHkbgkK7DUghuC/+Q=;
 b=xTNsAgYEgyodqMikMuWZf+s2N0XebhGOMsfqyDRCQM8IMjzgieGDYgwcG6cUh9jedOoED0fRkff9atiAclZGijGqXUbtOBTfg6YkhgH99rvKCxavjL8GTVizJyn/wgfIkz1tRi/1uB9fvlVVF269dCkkiN+LpJfwJvOVMYVazas=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:12:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:12:59 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 10/10] scsi: mpt3sas: Introduce
 sas_ncq_prio_supported sysfs sttribute
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r72xaal.fsf@ca-mkp.ca.oracle.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
        <20210807041859.579409-11-damien.lemoal@wdc.com>
Date:   Mon, 09 Aug 2021 23:12:56 -0400
In-Reply-To: <20210807041859.579409-11-damien.lemoal@wdc.com> (Damien Le
        Moal's message of "Sat, 7 Aug 2021 13:18:59 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0017.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR17CA0017.namprd17.prod.outlook.com (2603:10b6:a03:1b8::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 03:12:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1be74e80-aa0f-47c2-962e-08d95bacc190
X-MS-TrafficTypeDiagnostic: PH0PR10MB4648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4648C73185CE90F980B258378EF79@PH0PR10MB4648.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCGDEY75gto03HUcVgbynD6YAFGdeYOqWUI/CPbgWdAynhHuGwsZrtswc7IUkzbaxCu9Aq/l48K6snb2Ud3p2NYHSf9xd5AWhG9kJKO82jSTeUVP/I+N8HVJTZlanwDdOT1bhbzJPtCMWFc0MEM/bOaoPaiObEAF1ZtZ/ed0EX+NIRwiXFA59slaMNkOZEKU4hcqXILUEY3vsy2g+Cjf1ieHSpgrrJHTmBTCcWdFg5VnnCPQhEInNbhIzC1AJ3PbNNrc1Gs6wUZ4MLnUujUk1UNNG9r3cO2t5JfSrjhL3ut9WnGuMw56zDeGCMYuwseJ77h62l350swmfNatqSuovp03GjU1dV/2sXDkH6n5N9FpbCmb64kKpSUX/kliJuSSm94/qb4R/pfUI86hXE2VDcpHwINyFO6sSUwHudYB5g9+EkXZjJFeJwo/eY37qAFcGrRFLYYIDUFFSlwe38rvHY/NUkEssSWKN6p/mXCAUDvFAgI/K3jKtbihpuCCJrOvh+TW72t9QwlmNopVFq57Q2SQqNJK4rWo0D0fKHljWlqLvZh8RVqXomkmJgBAYnhjQZ/BpXSa7xF4KglPwXLtDShE56o6k3JNm1LHOPjGh5zW7qEDHGVUWeG+YjcYwnypvU+5dvZNOCICvow1c7VbIv7zfi+Xzx5NRAhntam1nPduXZKzTdve51wBhoHbbM5pheyrw7Kqu9ha/UVmRusk9FKpKKmHCk4Hm9qlTvkkZoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(366004)(396003)(26005)(8676002)(52116002)(7696005)(2906002)(186003)(316002)(4744005)(6916009)(66476007)(55016002)(66946007)(66556008)(86362001)(478600001)(956004)(4326008)(38350700002)(38100700002)(8936002)(36916002)(5660300002)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gXTqlp5MhdGB85BQSmL6qFM0UvrrszYn+C8K4eB+fi6G1mmLloCi/af0j/39?=
 =?us-ascii?Q?fAXDaKcGEVQhiS49CcVAiz+NFvPeuBp7YZ0yKK7KXWHDCBW7ctQAk9vZrTbE?=
 =?us-ascii?Q?Z6HLQxbKg77RJtLmidzpHAZZO0uME6wT4ZAofJetvjUU1UU4VXx1mauwu8/S?=
 =?us-ascii?Q?T4DtiLTsBkM2P7zVtyKJzhzd9xajKf7HsqEdk9+IL9dVo4VDBBVaKCzclxDI?=
 =?us-ascii?Q?aFbydwfCUMxdAguRsEeE1It/PuXxUwyCPa0ZKdcz1saTmVa+hlEHMXizGKJ6?=
 =?us-ascii?Q?W28Y8FtD2/DZiVt5QD+c6bfQZyF/Zd3tx7J8SH+f7ZrRdrEE7Q0MyYFVVZoS?=
 =?us-ascii?Q?Hdd6RqggPj1pTaJisFxPwgIsj1nkdC9XROnzaCqm0un2pCu/zIeRr+GGLEew?=
 =?us-ascii?Q?qtV6hpaSJOPMgpPZoQV+S+nX7sJ0XxSW2MbkSZddiGJf2NCK0bE6ipPVQZ0b?=
 =?us-ascii?Q?Cd4f2wzr/GWdFmxDC3ZwDzjF5q6zVW7qflPkjfGoZoa8UKeFvuhWapkxfdOf?=
 =?us-ascii?Q?FdojzX8HOsIYqWtkKHoBTbDDhbWZJTdwrQORZcTzj3iqia/4uzVDCu8mTb9G?=
 =?us-ascii?Q?F8H9yw1w9yQ4B4Z1cu1Ta/VITLhjEXE/mqi270q2ORxm5HdF/rVh56Hej1+e?=
 =?us-ascii?Q?g5erUBXsxUlLwIcRxYfKUHS81iN/jcQuLIeVy8qalufiAqfZ+Svoq7LCmh27?=
 =?us-ascii?Q?bqPKxTlDp5fPYGfvM1i7Gy3UFlZtisL0eczSl7PtG3eIWahJrVLmwNPxfMWe?=
 =?us-ascii?Q?p5WELaPuaD/ht6dii8NOXqrPo/4ZwZfVKpY2fSBgKNQdCV90r4JgoDgpmFal?=
 =?us-ascii?Q?iJJLN7RIVdbn0oJ1VMvhaPfR7JsQRMG2omYur+THKTkcJ5wIlfaP/vMSr6yW?=
 =?us-ascii?Q?BNaxG0ugV2GTcVYjeq03102JH/WhLsIPPGFRVm53HUEf98qWHPifQ3C6db4E?=
 =?us-ascii?Q?xXAFmnfcfZCjv9vZQQsFem/ZIdLSoX2YGLrqnXYtgrTE/wChS9BpCl8F9CgY?=
 =?us-ascii?Q?Yz8ybrJK8R7WG40D8rJK6nDNMVQ1H9xJU6sOn2y/o7vdEKef3bVAdfRCTsLo?=
 =?us-ascii?Q?Hnkuzb61+d/FXVWMwxfVIlkRitw9W/nPo0Nml2UFAcv+uj41bwXo27W/oGcy?=
 =?us-ascii?Q?f4vrgxGFK9JaCqRnCsJAv3MxsNG+KPi52A+QoZAagZFF9jm1wEUGuZLpeZXy?=
 =?us-ascii?Q?imo/+9NMrRpE/8+ckQXMfSFSOKYjGcPuLVmt1QnQVfAFwdpIqwoDv7Pvzr1j?=
 =?us-ascii?Q?0BeTv1IGGXrGRJqLcKU5jdupd8sknmaOYjFz4SZBmzrGlE/VWiVPnYW+2GOB?=
 =?us-ascii?Q?L0CreyEz0M7AYJHLbumOcGAx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be74e80-aa0f-47c2-962e-08d95bacc190
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:12:59.0502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sI4Tbc0nGnrIKDR95RIlm5EoJkKp0B56aiqXeTyZd/+w3Wdvas4rAqdae/g8qNCg6/CCuke6TsQYJpyJrGfwXwtp+CxWiNNO+gt20IenoFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=908 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100019
X-Proofpoint-GUID: tLbr_rARRb0hz93rgG9UchhMw169g9TG
X-Proofpoint-ORIG-GUID: tLbr_rARRb0hz93rgG9UchhMw169g9TG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Similarly to AHCI, introduce the device sysfs attribute
> sas_ncq_prio_supported to advertize if a SATA device supports the NCQ
> priority feature. Without this new attribute, the user can only
> discover if a SATA device supports NCQ priority by trying to enable
> the feature use with the sas_ncq_prio_enable sysfs device attribute,
> which fails when the device does not support high priroity commands.

Applied patch #10 to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
