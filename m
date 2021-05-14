Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F37C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 17:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8619E6147E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 17:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhENRLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 13:11:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhENRLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 13:11:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EH4d01107332;
        Fri, 14 May 2021 17:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=V9gxAdbVlucTSNw84JScaifIFl0Is9BN9Ir31aLyifw=;
 b=OlFmir01Wfrz14xC/hXI94W7VQh51u4egeJRBO2HxJJJIsZxtnZREMyTMsmmf6wxPotV
 f3skjZ5U0UKlCpFdp/xXGUbVV0OOl58uXly++Zrij4qBCOEhQMPIdkYWHevL7M7i2J0s
 qc1RqI3wTNgA5GwKL5cS3QxXjBvKrSuW+Qz58agxpmjPVKq6/6KaM0PXNk0HpOyz5K2V
 ItzJTPnI84IdPxL6e4DjgjSi0LOdPlmnVZytzfs9wQryUuhSkaYizBAxtjFMYNZVEnPe
 4wfcp/FqthSwAhBCoHr6ZzSRv3MtjSnE9s63Wp6mH8dbspMgTWT4X3GgbYYe5d2vURka xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38gpnxvwgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 17:10:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EH6CTh164663;
        Fri, 14 May 2021 17:10:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by userp3020.oracle.com with ESMTP id 38gpphcjfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 17:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWLXh5arkp+Td4Tetdqn164Y337jFjxK94w07Bn1LfRhIJ3jvPJU8xO7Fu1j6/jYaJck17eFfyiWSmmxEozZ8sj9nBjwJhMnoiaEW6lsthk3djhDwtGKAqOb8L0T8WoO1tkrRUK7kDxsMJPudB4f6w/MRfOcOF+00ysbtY/fuArwMOtWAAoJjtmIKNThCi/iDTAkQAH05I0SlwN/FWoxBpY61T4hUlseJRtcyXjS4e4F8Z97UxHryxzTxs+3zI5MCJcgWM4frkBYFOrn9xh0bKPfY3sooCeYAApxDrc2ZD8nAEkrmyoKXtlNnfY2Z0xoFjCh8GG8p7DHw5swNrp+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9gxAdbVlucTSNw84JScaifIFl0Is9BN9Ir31aLyifw=;
 b=ii7CrKgBT92nlMxtqaW9mX3EoSz1WaKJWPAHtFnsyTydvOoKqOhAIQmBgcPu71iucQKiEEvKtidWa9CHx3rPtxoXSPlwAh/tPDzwqJxonMqaa/QlqpfZ8umrURBNw9f7uLnSys8c8Ybw3maC0jdjpWPFI6vr61jPBGekGwdI/qZfD1zIkjXENnwLZ4muNJZKVw+E3GvxnmbhCbw+AKZr8islUqlLhvbViXVUeZ2Oz3YbyUHsAbfYSw/2abcdagcq4qyMClPmb6h7SYvIbbXrdHmRy9TIuH4rw4qn08FC4yISslFKPZA8lmEaxqC4Z/TA8WIVMG5iAUo0UKgv1H7HQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9gxAdbVlucTSNw84JScaifIFl0Is9BN9Ir31aLyifw=;
 b=ZcXeBSbQPfNhK8ljIQH22IlvuXxlZsLkYfBdKHnVQ6igTZCz595RzHCdertwRq43uHk07eoZGoyUtXrVNP6fL6q4W2/7fmcRjTLBrVQiyquAvBwvBEEgCTSV9ogTyJktY6xzamqvOIJEu+fDhrjdlL5b1PkwuRfCB7D6fB2uNZg=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 17:10:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 17:10:27 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/8] core: Introduce scsi_get_sector()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8ddb64r.fsf@ca-mkp.ca.oracle.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
        <20210513223757.3938-2-bvanassche@acm.org>
        <20210514062007.GA5901@lst.de>
        <255c55c7-fbaf-9443-7d0d-16ebe0e37004@acm.org>
Date:   Fri, 14 May 2021 13:10:24 -0400
In-Reply-To: <255c55c7-fbaf-9443-7d0d-16ebe0e37004@acm.org> (Bart Van Assche's
        message of "Fri, 14 May 2021 09:06:20 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0225.namprd04.prod.outlook.com
 (2603:10b6:806:127::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0225.namprd04.prod.outlook.com (2603:10b6:806:127::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Fri, 14 May 2021 17:10:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f2d871-7f8e-4b78-f91d-08d916fb2bc3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4775748E98D485DEC2AE24E18E509@PH0PR10MB4775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+CipBduL32I7yq69L0eqsN/dz9XXDXePdmjrhT9Z117IAO8aIbFMOWlT7h09iEus6Q7dKSZbYFLN1VPtU/vtFbIml5rOLZ+4g6aRYoZ8FQQ9s2/fRJsO8FgY2Yzfuujs1IDtiuVnZsAwMF0zYdEWn6zAn4T2tqdD0u/TN1iUsiJfM9AtZJoveONHE7U0sBBbPUqIdT9vlRnKJ6hOdwhApyK6ljYdshpVdw+hXx4cMwznOEK0MAVyEVB36Y9SWixnls/+55QC6yG0j8NhgrpHhmFV6GTqrCEMhz2a6JA/mALDB1NwF2fWLIsH1uuig/xr+G7LTCM84nDvNe6Qx35XI8fcGA/hsF85jHUlBXwWlIhdK8j8f0JZV5egpjMkF/r1LZTgMAJ73cfIaOUckuL+CeNQp4Q9i9Pe63tcJOGoqvuhgJIyB9lykfRIJsuoFede/sA0EYp/1FOW9K8bbJtUZHwOdXhY5S2JNDyEX0ROBCfW1ADFXrU9VxYnVLPuAGVPD4gf23NPPq6rWB56/qfqUtCnm+JZgZUWxEYscZJ/59dVIipqDnisiVP0dzxBIJH6pNvI1i+DuhAoymYRaMmAL4TpCRYZnETR6bA+InbC0HmLr6ofqzF9rpuru2ndbFfVauKgnpKxF0+IL+poe1rH1dWbajK/cL3bUf2VC6HmL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(346002)(39860400002)(52116002)(55016002)(8936002)(83380400001)(66556008)(66946007)(86362001)(66476007)(316002)(7696005)(26005)(4744005)(4326008)(36916002)(2906002)(8676002)(5660300002)(6666004)(6916009)(956004)(38100700002)(38350700002)(478600001)(16526019)(186003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K3/EehFkfVEOYF7IlK10OcsjcPt4+bik5uUzYeU6AJNqTjIn/LJKsJAwX7/A?=
 =?us-ascii?Q?zMlSLCsk0H19xVDIQOhVk5hbHafUdJQoyKnOWdq9B1ncILK53zSFfrbp/dds?=
 =?us-ascii?Q?bNXqWjRecWksEErZHyfWYcJeSPpnVgjCmEKq65kB4XSBEExeI+ybaKANbpzF?=
 =?us-ascii?Q?JD+pwEFxP8QiJIMDT1/+akj70gsNPC5F2/a1/DYb3V1lzqcnPuAQKYZaQgF/?=
 =?us-ascii?Q?zCUAdyZaxO5hozcLz1OgoufjixNOucT7nS+dWDTz78WhacQDZh+vLSShT1BH?=
 =?us-ascii?Q?PS09zU0ZK+PT6xzxyqQXnevfICS5Gms4EieoIp4j6B5jbp65x9e6BUNfuUJ4?=
 =?us-ascii?Q?+FDH2arR1ruzBFPc8WDggMXuGTIzebFHWmQoixaOVjkhG9vG/wCf3aIyRACC?=
 =?us-ascii?Q?h51lqylfRemCJfzQhFskpamQmS0hHOzPrpaLRC55faW4Q9QMJK4S6UVrf8Kq?=
 =?us-ascii?Q?QteQtjIclUH3m56wk/nLNczTffIsYX63PN4VCY3Yz1Jf3CUlbhuyvV5jqmOO?=
 =?us-ascii?Q?XkyUyNxubniGq2ADQHACo5hxDdFMpTZPr8mJhkSnmrYlWdONQ6ZJlnxLhH5b?=
 =?us-ascii?Q?Ll3DyoSHgYFFs2EE7Kov0ZQDMuShHYuCYZAF/jnQPEDtyvgR79PzzCJTosqn?=
 =?us-ascii?Q?hXvxp7WN7Q6NFnhmrQlXio2ozyEPt53bVHlOamEEpfNbrLrQRvuYMjcKOfRW?=
 =?us-ascii?Q?eCKffpwnHUZ4oIpVGwIx6AsMjJsiujD8a24X+0D+BXHK7TP7V69LJ/ms4zkT?=
 =?us-ascii?Q?jMoxSOYR5QAQcCrQtHANWNfhdBHDKqLIgyF9M4ZFqaT/qAGvC4IPFg1II9J7?=
 =?us-ascii?Q?C2uZ0skUIX+AQhrwdObop9s34C0SOHwRA95pSQbsCoIAW0M/JXHrYFeLfzV1?=
 =?us-ascii?Q?/nvdxyEuZAA4mFA2IZ0CddnO+MSn+thkRRDSl+AdoMpP/8ep9QSxPgaIqGPB?=
 =?us-ascii?Q?IDmW876+Y8O8Y2So2DdpZG7QRqEo0xaJdp1kbXcWIbP1vz4ZwvlR2o+f372u?=
 =?us-ascii?Q?wrRAOiASR7qQf79tINxuOC7ElXwcWBYhs1FtnVkO32jBTSHROAh0HlkkG338?=
 =?us-ascii?Q?2sFYrEEl4dgm+Cln1rQNetHf2SNrkEViDgc+ldaFDyEyQRzyp2lOzqq1UaDJ?=
 =?us-ascii?Q?+0K+xbzrYTfZOw0Zoa/aPWAJY8SsBhSi3/FLYuAyqz+57zYlQKvXIMMQZKdO?=
 =?us-ascii?Q?0Xl3dwcD273jhMtC1qk+Ikfbfg2l5FniPcm6eUinZ6P8AroX4kUFEHpbu0Ej?=
 =?us-ascii?Q?4+ssd56abeFFCXJX4sV1yr/H03DytLtOUbGtOYepw896ZODIfIo2ypqbPR79?=
 =?us-ascii?Q?bpFngJZCZoJebNICqA309Tsj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f2d871-7f8e-4b78-f91d-08d916fb2bc3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 17:10:27.7377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PhuyOmTaOSGGKs5FrZzW5pldylDBqpHRhZpgUwLwp13qKo5aL/sWJtNKMoWX9D0Ki+b9ceeXlUPskxkKB206YgNoisK/qZ28ga8kLGoe5Ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140136
X-Proofpoint-GUID: NomECR4HaCWqHiOySC1pTZJIVl5_h2XT
X-Proofpoint-ORIG-GUID: NomECR4HaCWqHiOySC1pTZJIVl5_h2XT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105140136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> or in other words, the starting offset divided by 512 is assigned to
> the reference tag instead of the starting offset divided by the
> logical block size. I think that's a bug.

It is. And I have most of these fixed in my integrity branch that
reworks how LLDs interact with the SCSI midlayer. I've only done
mpt3sas, qla2xxx, and lpfc because that's what I test with. I.e. I
missed zfcp and iser.

I will review your series shortly. But since all the integrity stuff is
transitioning to the t10_pi_foo* interfaces, my initial hunch is that we
probably just want to get rid of scsi_get_lba() completely and use
blk_rq_pos() directly for the places where we want block layer
addressing. I'm not a big fan of _pos() and like _sector() much
better. But I do think that the blk_ prefix makes it clear that we're
referring to sectors and not logical blocks, physical blocks, or
protection intervals.

Anyway. More in an hour or so...

-- 
Martin K. Petersen	Oracle Linux Engineering
