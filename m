Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096A1CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 17:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjJMR7r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 13:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjJMR7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 13:59:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA3D6
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 10:59:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DHhsRb017639;
        Fri, 13 Oct 2023 17:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ZkGxArtqESMEw7NAIrYD+grJsXInOPl2RHV4sdJt6uQ=;
 b=PeEAe9ZKRGIbNuXERtyunGW41OfFe/7PDxRg1DKnhMmddRk+lgPej9h444GD+XJgEb8e
 hwsvssx+Po5H+jpgQPp1R/iXtRtUbHbvGWatyWqWXBy1LQTs0Lpg4oO/Xx4qa/wtB9JI
 0dGVotcfdtHbDa9cB4wcqU5yQAmb1JptHldolL2GQSYjsKEPGAXlYBdBXiYzKhecttim
 T6+1CiGw0LgcAaLUanwJkXcMucRvUS7MHj+wxaU5/kVKELTQ3IPMwkUkIzpfhk1t2TxC
 lwpG4Jv+AesnndPLyNuKE6I+D+TvHCGYVUl/uREOIooS+x8pz9/e2QkjXsLp+A6ds5bu Yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjyvuwj2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:59:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGchY9037671;
        Fri, 13 Oct 2023 17:59:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0uq590-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:59:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLym4b0ggg9sXFGbWGmqkJRqSLwPK+dRmaC9juGwpF1J063bEdDqN19Gnm5LP9Is/aggD+z7vU6/1mRRV1yYKFIoOPMrOQpLZKePGwJDpEGpQvtHclVnjxuQF9WNkf6PdC15JEGA1TDW297FCajy4ezJ5rIsPyKNM6axncBpmT1y4rtKXutjjdV93mkN2i9L8b/MHv3a4pR9HC6G2Mxuv2dq8p9sV3bmfz6hUtN3qZIraTEmWFHL8TE1Zz6GjFyBOhqfqcggQal9B2NxPPaiRLLjxi9xJbYR+c/o4akJuQ6PPwiAezdNfXv12WgXlQiGZpp4dEy7+bYtT/Lycf3CLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkGxArtqESMEw7NAIrYD+grJsXInOPl2RHV4sdJt6uQ=;
 b=MODiU9aAqGO+Shou7dozC68ppfjiPuaPkG1cmfcTvwmPjusAA9pMKg5/g+N/2taBjuOH0LyOd9JnA8MgcgNeY8DjrUJ+hD919EHega79eObHaa7xgAECGd7pJih3THPOw2p94GfhV9cckqI3WeH5ZrG7V6GkxLfZa2MNmCQnua83YhyC+k4N6GneA30UJcE81YBpjtQVE6d+CLAg0baXqlK+5J5Nnk3YWzpZnO2eZDycul6Xaxos5k13L+xt0zzk4yjtmDO6Aa8mewSua/30fkqHgMJlD2kW95GYMSxiLwqMnZVoxIiQz7Y5PfIt6zQSMB3/2hf42cLtAdi0ft2iaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkGxArtqESMEw7NAIrYD+grJsXInOPl2RHV4sdJt6uQ=;
 b=s3LM4cyK/9/Flo1wJoUJg4pUgLkmpjF8UJ4ZFv2kmP2yNgMeCab8dHeRmkEB0sSrmz8NqTJ/CfN+YFFpLyXgvbDgStOrKNETQk5s1SMUp9mDHD+kI7o6dLwOpypyzPOcBjqRcB++sRC3E0VjVS+266crZzzKedpmLRKpoKxV634=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6852.namprd10.prod.outlook.com (2603:10b6:930:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 17:59:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 17:59:31 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 08/18] aic79xx: make BUILD_SCSIID() a function
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18r86mmiv.fsf@ca-mkp.ca.oracle.com>
References: <20231002154328.43718-1-hare@suse.de>
        <20231002154328.43718-9-hare@suse.de> <20231012082653.GB13230@lst.de>
Date:   Fri, 13 Oct 2023 13:59:29 -0400
In-Reply-To: <20231012082653.GB13230@lst.de> (Christoph Hellwig's message of
        "Thu, 12 Oct 2023 10:26:53 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 005a264f-954c-4ee9-4d08-08dbcc1626cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJlSo1eh0mL6kWbOdVOCo3Rh9KoJm+A3+gjy+/qNX8yzI/AtWbYjhJXuTOeZcYfRdjnH0et75Z2Z1oJ6kxnPn9QjOXhoSjkdDisZ5KPQ1SDuNve8Ua+eJlINJC8uCn65CmfbQFkZOw7XJ1DI9DoG6Dox5r2q6brVijB9q64Yj8aOxMMN14CzYyJDwJHa7yskujUcyYDSUK6JipA6k0NKrMIWKj7pXpaoMwKyHV5+wvdm1f1Okfd0eRurmMVg9gimbK3oM0PV+OcTOoQn/ujOr35G9xvT7PC0F6xSsC+B2DHPqaycEBLnhJnsWYu5Bz3ZMKsYxBWqjXuUU2vo3rsbdC9zldzqskoc51/5TMda2Nr/ippc66EnHCn5BxzTr20ujDapYRGpSrpahnD4huSYoZ8koAE5Uc2cty79nLrqp/cgHSlFng8pYSCnqevPTnxinjqpbI0f1zuSB2DbdJ3FtTaUmQ6R8LpXDC4E3OhdhNcWeZ7AeCGSCW0166q4jzUsqmF9UPq9YILNsSKQPd9qDXbmq4oFB9GR80taZbgAICGJcOZkgUjOzblMX/SITW3P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(36916002)(6512007)(6486002)(86362001)(558084003)(6506007)(38100700002)(6916009)(478600001)(41300700001)(26005)(8936002)(8676002)(4326008)(316002)(2906002)(66476007)(54906003)(66946007)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bKrREmf4cal8lJCJn55CxgXnN3qLIiSsz8rJwC4ZO/B/uZ8NNR9okgxG4cHG?=
 =?us-ascii?Q?R5oNBXW4WxL2p0KJHyisrwTSmYhLOyaY/e25hlXEKBzlmsZe5lhTmgywk9Gr?=
 =?us-ascii?Q?u4vFpcSeMkt+AIo8eBL1hcw97iKhBrEKPo0JZqySYIGMR3jvCGU8sVoFHkfT?=
 =?us-ascii?Q?IcaiZDZv3snk99gT9ZvQq0KoHXsrr1cGuuLsnhD3fTIqjcGi4QQ3MqHsVoRN?=
 =?us-ascii?Q?IpGZq1q7d02vun5yhVj49zRJkwYIEmcdmcU6ZUnpZcWQPt7hFqSGWs3n+Fg8?=
 =?us-ascii?Q?UMyGf+mFbiHCnzZjE+4Yr8KykJkA8CUr8bjmxAmK3GlnaacKN9obO4NoC52k?=
 =?us-ascii?Q?R2oxFEx9Zw7RPYfyplv93mLdTGq4jf766gWZaKFUu+nF6WRWzSdKbGINW5Hk?=
 =?us-ascii?Q?8CE0Mco76oqeu7oUn/E8vBX9lIT7HOJlGtvVuIsvipR9wLI8eoH1B80AzFl0?=
 =?us-ascii?Q?D8lC7rZAZpKvc4GmKM9q4N9MOfwx7tAq1ChmTJMh/iR33aWNZjwfySzSDvrf?=
 =?us-ascii?Q?6RelFMMqEtPncduH44rwceOIF9iBIMkja6c5CQjOfU2Ht+l0tolVtjftLDoe?=
 =?us-ascii?Q?0vdcdGDAwi6F41UKaRPisIbQhB/uZ/9S7+N2qHI7kAKlU53ZjqfbEMmV4Pr3?=
 =?us-ascii?Q?XzDHGxy9FvVb+c8Ould2bHoNJY4E8LZzaPyETMH3lvUviyzAKlZxsG8oBOqI?=
 =?us-ascii?Q?4/tCGJ/biUMSKPji8a9Hya0Z7BRkn4dl2hkVO/teRF9BxCrDEAatiZWd2u00?=
 =?us-ascii?Q?RASmJ4gdZfvbiRJl7EXyNjUfrgGkuBIzRYNblcdkoATqL77/M2VQ24FcBQDJ?=
 =?us-ascii?Q?yXeqGL8085yZZfQ2PznPLN/gS3ie0RB0lhUyUp33GmPLbcKuovJ7AZmTYyL3?=
 =?us-ascii?Q?ypdDZ4xl2+tWVz2Kozv/SY9wWTqm2WBAMlsDLNAVj3lDYitYZj+v0vLrxyw0?=
 =?us-ascii?Q?AKhGEQ4YuGQrIV1IiQ+NkU2ajiO8T2+OTb6RSbE832plS9vGy6gqyMaP5XnK?=
 =?us-ascii?Q?XBmDbM3nrf7dvVbOeTD4i4d+FIBMEpbWm9RJq6wX8tQgNSmhdP0rK7YHnPHf?=
 =?us-ascii?Q?mUTrXXHzzE2Fwy+2gN4il1eqfEmAr3itpjs5NWwTBhf+Wo+cQrZeNGGEYKyJ?=
 =?us-ascii?Q?9K+W/gAc7fALa9GMZe0wcJS062kB9CV6qm0tk5LJfewMjI1zTYbqAQTfSyWF?=
 =?us-ascii?Q?2H5qw3DyvBS09J3iyXgHuQSDX9y0d70KEpeUK4gbWUqjdCLixyYHe/nJBN1h?=
 =?us-ascii?Q?3lFEcQ0/0zNwAegERhyT4uprozKoZof15LyXHHNMwdoQuJViMEjntiza+LO2?=
 =?us-ascii?Q?Z7bGSgIKcgDo61ofrMyEWJlNu1chMwywNvo6Kp4KxF/m1YxA/WCFz9KLkVwM?=
 =?us-ascii?Q?AdnYYdHUrFoFHL8g8Kdc9bKf91kj2o11FouDhBgugIj4Ibtzi768qtms/3Wr?=
 =?us-ascii?Q?qLzx0W0ucJc/cgV7PyQu81P7HWlTiw9/VCg3WxnUS+TQL+aZ69ronGij8I/1?=
 =?us-ascii?Q?f4e3VNX0M8NcNXrtBi6xKx9MzQoc2/4+D0KLbrKH3iE5UrXUtwURMutEmJcr?=
 =?us-ascii?Q?lCQtQl3rtSQ4vJ3E4ZHhCNav1etQFdoU+KQgOXXqnmi4/z3PktJfgwZrUC2X?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qTYcC0fN1BY4PzsulGbd6uLCdKaxML1Ivp3NokoRCoag9EJxoKw+mJYTUPaaWzjQbd7JkUDd2hVgrWASuRmWv3BXZEc0zoVm09oJInL0XjgVhXIaIJ7S+VfnfOdI/1nIpyvWfPh+/K+21NNTMtNhk0ipBj5U2xNodOcV7ah+LpnQ0AjbKxXisj4XRplpUmpwe17l7h2HWR3R1OuDY/fG3YhMcHmUkKDUP+kNogVvX5j+uo9Nlkfb0SvCwtXBG3zPLS7wG8ygni55z/n8cNohQ+Rp6xIukoJwbpuvjNkmw87f6p+BJWYxU6HlkeHEXWXhXD7Hb04ZauU8iXGofIcrVJ+VfEeQnQOaAt4n51Lb6Js7umcviKiTe9f6Jpito8YUsD5mG8p4hO6FTQsd7bvA1AacQ9yQ8+Oa5U/dpxpsaSVU40NiBXkB21/24OJ2TT2Lt+xjED3iRXGag1e+hMkt1YftyXZ0K9gmjEHrHGIQvBhOiN8dmhZFGV2hKP1Ms2PXBH4zR9zMAge6jLGkIMWpxAW9R+jUOdq25VkLgb88QTVM4csbW8NSoL5pBqw1+bX+UgNh+maiH7+ECKWKPGgYkT5zs8I/OMfC9ChH8GZtM/+rBeeUwByiGaMVcm5N5gO/qGQTdhqHyjMLmnXM4ip2Ixb16olGoVAG8lFvjpGgsZJyUGI/8vJZVDTuukGLy9OWyCE2AaxYGPK0cTBYO/n+ipdniAw0dNxy+Z6FfzmdIpNJ0mzefEYwNit5LEEvQOl5DszKafg5QmZAaaTzznq9qCvVtDQVqWWEi2Am8D4SHYm3YI3i1n4ToC3ft2KapPuNpeef30Sn7Oqann6pkFqZosjePJ61vJQJpq/VfB1xJzGKryC+hHTHiCc3dvhDb5d+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005a264f-954c-4ee9-4d08-08dbcc1626cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:59:31.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vzd99nnQO3iCrSOV4B9iH5uiQrQBugUgcMQlJVADgxpgLkU+RUCfLfV7BWJMyzbCJpQydBATqvlQ8yw3Z3ZkQSXEYIggpqdhjR5UW7LZJnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=560 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130154
X-Proofpoint-ORIG-GUID: dQaVZEHC8jVrGBBkeeFEb4_AuF2sIYEj
X-Proofpoint-GUID: dQaVZEHC8jVrGBBkeeFEb4_AuF2sIYEj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
