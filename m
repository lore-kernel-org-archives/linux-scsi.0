Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB421C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9069A6161C
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhEKD1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhEKD1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:27:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EMOt073520;
        Tue, 11 May 2021 03:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JYDsDK+fBlm56RFzCnGs6+WSnuaYeaj/EFDTNPc20T8=;
 b=Y/TT4EWqrfc9MJwZDhbqOFK6JgWU8zJW85FvHA1cHQcCElJ84jkNeFrQTw8M5SqY0JLb
 j7vxPsquHu3KfzP5Z7HBA8AO2pZWhSk6jyqKEaWsT7wxQ23+gkqZFzISrb08L967sRzg
 p/so20ynmPuJCjxIXm/ei/ujJrtYdCSfK6PKyWb5Zyb9RxCLfC1Izs88fPFNyyJQx78r
 Xi1t3vIh0H9s2A1S/LL7/qsEdcEWr4ZuQv4t3sipdYR9LFaG7Uqc8mHtWaKX7IqE/Vt+
 ZE/JsvpgjNIhkGXdGDRHUlMrMsFIS1Fj7FPz2+mlLl+4jc9e6M3sWphS2ymglUsFr2EB qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmd7vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Fo0e103027;
        Tue, 11 May 2021 03:25:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 38e5pwfpd0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0sEN1kK7xYen9/exSXKSyQZU1k9jpjDtK0kAu+RI380rCfMs+juX0+wRTdnSp/CrYquCbBBq/LRlo2xvM12Hm3OOFJimQcc7g6sfIys+/Dyt7UPTSVk9EP+Vp+bCdxm2Ae6vyv66onnq/e12bquA1XXLG9SRBW5WZKTt0UsrC0V+E2HdfsW5EoubP/VwCiQtxY/NxCaz0T1zlIARQawZo/hObDFM+LNnahjxrkx7HqtvVv0T7mAjQDiqEAt43vWKzgKFrvbZPJf+726xke+2U1JR65WJfp10Ds957QzZaHp0JgrV82YGqspUs8KYVhiUiUryX/QBXxYVpaj7S7Asw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYDsDK+fBlm56RFzCnGs6+WSnuaYeaj/EFDTNPc20T8=;
 b=cUL/GMASWh4fTJnMyDgWAdq36togcd2Agyjc3pfmNqB86RntISIlr7FfXS2LR19Q04H5xKoaUgsW5GV7CppITrqTdxlhauENcbCkM9egAbnxI7GWrnp6SlZUSkf23vQZ969+1lnRRNrVhSBJE8E7f3U2r0IPvdyYYPphD8Ky1ciqQloQPyE/JiZ6Qv6KLe1l+i3PChxSoPlEcbcay829PdKWqmkRIIfDAE9zjolZxS2kegpzCpkFvYUWDu+W1Ol2XI2cKuVWP9ZiCcUN6JRrUW0MM588KCa5obMN/QSYyrMWxz23q+1rLExGnkdnLyUJ+g2TrBCdGoQ316xYQWkMbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYDsDK+fBlm56RFzCnGs6+WSnuaYeaj/EFDTNPc20T8=;
 b=IvWm6Xy/9lGdudfczsZGFe/LBDWGqzx1LOIv6K3fcRgLF3/dmzRlcmfYgQUGxXzvMp1DXubybXYABuzSxRiNVzSSFyW82TYoAgKQd1FsqVPKzWCvWQT431qesEFttrezbOjXam/N+pcKn2JXiojCaAlEBGe9XdE3seuwKyZ+vgc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>
Subject: Re: [PATCH] scsi: fusion: documentation cleanup
Date:   Mon, 10 May 2021 23:25:30 -0400
Message-Id: <162070348782.27567.16629853060967046296.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210418203259.835-1-rdunlap@infradead.org>
References: <20210418203259.835-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88412278-5cae-41a8-d382-08d9142c7766
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408D4775E8EDADE8BA4C1D28E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CgBKJgJBNakX3kSlPO1a3e+TkD/vPRnvUPxPoVgDzsqhIysxX4MmIFhzBIlIgnzCHS+1SECrM3l3hsOGE1CQxZlo0FInkgOCiZK7kUToqr0BX3YHWmwH3QlrAWyjJzxh0TvMTNf7i+WBNRnmHlMZp4sMX21/Lg/zOJGydiehXKd2HAbvw3AaNewAh4LsoH9upJi4gD85DOf6ZMCq0+gnbjUNIEaOTDwkD4uWKQZ0Vmt+U+Ko1VnSu5ruEyQXaCHr/6nSM7NSpL5RDx/ZuIHuPUkU+RkDernXsPFmTlubGRrG8hRI3WSW+4vUmgF6WwPJU4I8IIvZgze6oZTU0ijkTr7brQUkBosUXdGRBx5ihL2wIp50vA/xhNomcsoxxBF4mdzJgJU9RX1i29Khd5Sj3k9UF0wGWUmG9iYnqihBkJBxA79PCUE3xOb4thsMqe9vGA9YOzkNt4oJJXrQuS40RgbUjuUaHccBawiHncmeJ44F+NBQ2QknpQ1YFPK6qWSvdE7MH0TcBWxR2eeb8SITdCyZLdmOV239X+amLEoW1FD9X1Gby/YRcJt5MCWh4wa8E7SZidWN7sXsb2a6qmk24rZMRiheCtyt1PbJhxsjSMem5vdedWMQgWugA9SV+Et3QA/dEqNXm3pGXTaQNsRoy+Joxme91GkOBoGHtRp7hLFhyFDzXDXABXNmwCPBZ70B4MFCbknVBb7JUp/NQZaEeX0S3hMT532rfth0eHvjGI8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(6916009)(2906002)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(54906003)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFdxL2svZmg5K3lFOVg0cDZwbVpvR2ozY2hNYkUyMzZWYy91RFJXK3NFUnlY?=
 =?utf-8?B?S2VpWGFwZG9XQ2VnckszQnlGUnNWMXRGcFBiMkpzWUpZN1VnUXhsSTNyNFZ6?=
 =?utf-8?B?QnVLbnRWTUhYaU1CVGViaE9NSTJuMjJVTUdsenljSHhJZ1ZuOHJ6TVhOSzNR?=
 =?utf-8?B?azBvRTVPQVdTNm0xNnU0QWN2aWlKUDB0cVlhcFV0K1VaZkFMTk9kRndsRXhy?=
 =?utf-8?B?UVZvdjdsaHg2dzF1cG9ZYUVOcUk2M1V0Z2FUZnpWdzhjVCtINFB5TGV3aDJK?=
 =?utf-8?B?Q3E5YzZVblR0OVd3YWw4TkdYbktqVEJCU1ZFNitkWGlNSm9MOEUzNHpTbENV?=
 =?utf-8?B?emV1QWpodWgvYWhVcTJJdUR4SmFKeEpRZGRISUV0VWxHb2VLallvaUtNQUFH?=
 =?utf-8?B?dnBmVUJ6ZGpYOWZHSHhFbHRrQzhySUdqai82OFdYeTBYbzFHVzJraGQ2YXNB?=
 =?utf-8?B?NmtGMTkvWVpVT21hYWdoN0JJenBIUHJEWm1weDBZNEJPMG1RU3pkS0Y3bk03?=
 =?utf-8?B?bHNlM3VyWmZ2TWE4K3JZRlByV3lSSUpZd3BONTBWRTBwdmxMMFZSUUo0d1M4?=
 =?utf-8?B?VkpXVXNEdVFMZHFXQk40dGZTZ1pYYzFYcitYcFpTbTQ3c285ZVhRVmIvT0Rm?=
 =?utf-8?B?aTNZcEdkZXNpb0JtN3dudGtQbjFoMVkxRE93NDVRRXZ4ZTRJTGRmdmRHQzha?=
 =?utf-8?B?SisvczY0TFZid3k2U2xNc1dndjRSQnR5bW43OUh1WkhObkNyQWJUeVlQS3k4?=
 =?utf-8?B?SVRVcVUzOXJpM2U4N0s4amxvME5FbWhaYmd3SFFWRFA3YnloQlh0cHJoZmNZ?=
 =?utf-8?B?Syt5UThRaGVjSnk5SEtWR3BmbjJpN3YrWDBMcmd4TGZCODJSbWxKanE5UnNz?=
 =?utf-8?B?Qncxd0JuSUJtN3pxR0RwcHdybGUwZjFhN2g3eUFIR3J2YlAwUFlIYmpuWUJ1?=
 =?utf-8?B?YmZZc2NNWk44V09Vc0VuN01WLzFML3BKSXhsamZEMmVWd2VISDJkNG1uVzRn?=
 =?utf-8?B?aExnSDd5ME9FYjdHcGRqM3lYSGVETldkOVJwTnpsZFQxb0ovZ1RUNkhnWEFS?=
 =?utf-8?B?YU9qeVB4QnBReEhESWgwUURqanRXVWEzdjRnaHBaalgzWEtuVHN4R1NncXpl?=
 =?utf-8?B?MlI0TnA0bWNBSi92NVRsTGI1WE5RREF3R1hTQnpZWHZSV3UxcU9nUm9ld1lr?=
 =?utf-8?B?K0ViRlRtWHc5N0dnblhMSG53N0dTTzlLMTNWNWtDcEZUZTlwRExOS1pJR3B4?=
 =?utf-8?B?UDRjR3F6TUtrWE9JdHlmNldySS91MTZiZnVLVmk5Uk5id1ZhZ0I0eHFPTnhF?=
 =?utf-8?B?TVJmaUJnRUtRaU4vemw5dUZCbEo1Y0V2Mkl4RmtTTm5WUDc2RjZxdEV5UXBM?=
 =?utf-8?B?OWFuZ3QzUUl6ZHlGMWtxL29NdmRFbXhUMXF0SGVUMkloT3FVdGExSDhlZmFT?=
 =?utf-8?B?ZnJERkErNXovQWtNQjhIc1MvU3ZYZmFScVBsYW9YbnY2amF0SjNZTlRMaVpl?=
 =?utf-8?B?ay9CUHpsL3JHSEJFSnR3Z3RqTzBiY2JVaUlxR0Q2c0ZVSXFvTkJJSENMZ0NZ?=
 =?utf-8?B?c1lSMFIwenJhcFBvWXhzOTdlVHcyQXFEWElOQkRrOEVSWloxdEl5L096aUMz?=
 =?utf-8?B?c05qNWR5OWVDTlpvdGpOOVlGSHFySVlMbXVyb1ZZQXd6K2tkOGZOdVNrTHhm?=
 =?utf-8?B?aTQ0aTNLUnVrL3QzZlg1eWEzRUdaUVVacVB5L2ZRRlJydExTd3BBUDQ1T0Ns?=
 =?utf-8?Q?qYWpOYpM44k6caDubNs3+zyma/ZjP2FHDwG131t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88412278-5cae-41a8-d382-08d9142c7766
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:46.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2moLDrp+8N1eX1hI8i5XYlaXovZqND1DGZHctrY815eBI57hfSJCKPIEG/MI9oBULBG1cGAq8GX3Hcbf1idcyLphS8RgjnyQDsRey2cqXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: y4WDhvuBz_mtL81sO8IfMeKVcqbKg_Da
X-Proofpoint-ORIG-GUID: y4WDhvuBz_mtL81sO8IfMeKVcqbKg_Da
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 18 Apr 2021 13:32:59 -0700, Randy Dunlap wrote:

> Fix kernel-doc warnings, spellos, and typos.
> 
> ../drivers/message/fusion/mptsas.c:432: warning: Function parameter or member 'sas_address' not described in 'mptsas_find_portinfo_by_sas_address'
> ../drivers/message/fusion/mptsas.c:432: warning: Excess function parameter 'handle' description in 'mptsas_find_portinfo_by_sas_address'
> ../drivers/message/fusion/mptsas.c:581: warning: Function parameter or member 'slot' not described in 'mptsas_add_device_component'
> ../drivers/message/fusion/mptsas.c:581: warning: Function parameter or member 'enclosure_logical_id' not described in 'mptsas_add_device_component'
> ../drivers/message/fusion/mptsas.c:678: warning: Function parameter or member 'starget' not described in 'mptsas_add_device_component_starget_ir'
> ../drivers/message/fusion/mptsas.c:678: warning: Excess function parameter 'channel' description in 'mptsas_add_device_component_starget_ir'
> ../drivers/message/fusion/mptsas.c:678: warning: Excess function parameter 'id' description in 'mptsas_add_device_component_starget_ir'
> ../drivers/message/fusion/mptsas.c:990: warning: Function parameter or member 'ioc' not described in 'mptsas_find_vtarget'
> ../drivers/message/fusion/mptsas.c:990: warning: Function parameter or member 'channel' not described in 'mptsas_find_vtarget'
> ../drivers/message/fusion/mptsas.c:990: warning: Function parameter or member 'id' not described in 'mptsas_find_vtarget'
> ../drivers/message/fusion/mptsas.c:990: warning: expecting prototype for csmisas_find_vtarget(). Prototype was for mptsas_find_vtarget() instead
> ../drivers/message/fusion/mptsas.c:1064: warning: Function parameter or member 'ioc' not described in 'mptsas_target_reset'
> ../drivers/message/fusion/mptsas.c:1064: warning: Function parameter or member 'channel' not described in 'mptsas_target_reset'
> ../drivers/message/fusion/mptsas.c:1064: warning: Function parameter or member 'id' not described in 'mptsas_target_reset'
> ../drivers/message/fusion/mptsas.c:1135: warning: Function parameter or member 'ioc' not described in 'mptsas_target_reset_queue'
> ../drivers/message/fusion/mptsas.c:1135: warning: Function parameter or member 'sas_event_data' not described in 'mptsas_target_reset_queue'
> ../drivers/message/fusion/mptsas.c:1217: warning: Function parameter or member 'mf' not described in 'mptsas_taskmgmt_complete'
> ../drivers/message/fusion/mptsas.c:1217: warning: Function parameter or member 'mr' not described in 'mptsas_taskmgmt_complete'
> ../drivers/message/fusion/mptsas.c:1311: warning: Function parameter or member 'ioc' not described in 'mptsas_ioc_reset'
> ../drivers/message/fusion/mptsas.c:1311: warning: Function parameter or member 'reset_phase' not described in 'mptsas_ioc_reset'
> ../drivers/message/fusion/mptsas.c:1311: warning: expecting prototype for mptscsih_ioc_reset(). Prototype was for mptsas_ioc_reset() instead
> ../drivers/message/fusion/mptsas.c:1951: warning: expecting prototype for mptsas_mptsas_eh_timed_out(). Prototype was for mptsas_eh_timed_out() instead
> ../drivers/message/fusion/mptsas.c:3623: warning: Function parameter or member 'fw_event' not described in 'mptsas_send_expander_event'
> ../drivers/message/fusion/mptsas.c:3623: warning: Excess function parameter 'ioc' description in 'mptsas_send_expander_event'
> ../drivers/message/fusion/mptsas.c:3623: warning: Excess function parameter 'expander_data' description in 'mptsas_send_expander_event'
> ../drivers/message/fusion/mptsas.c:4010: warning: Excess function parameter 'sas_address' description in 'mptsas_scan_sas_topology'
> ../drivers/message/fusion/mptsas.c:4783: warning: Function parameter or member 'issue_reset' not described in 'mptsas_issue_tm'
> ../drivers/message/fusion/mptsas.c:4856: warning: Function parameter or member 'fw_event' not described in 'mptsas_broadcast_primitive_work'
> ../drivers/message/fusion/mptsas.c:4856: warning: Excess function parameter 'work' description in 'mptsas_broadcast_primitive_work'
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: fusion: documentation cleanup
      https://git.kernel.org/mkp/scsi/c/cdcda4651d9f

-- 
Martin K. Petersen	Oracle Linux Engineering
