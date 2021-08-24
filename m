Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE418C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BDC61206
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhHXDcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:32:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18394 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232605AbhHXDcf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:32:35 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xA2O012035;
        Tue, 24 Aug 2021 03:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=KSLyf1/kaJw1mKCODCklvIQeZZljXypnAuaLCCqGgGk=;
 b=xJXKzLDt0EMSH322CRAXKH7XDlI4ojjtauvOw6OAlBeJU8BtFMQIVfHsUjuhFPmgTRZ0
 /SdW5RnxkmS6HxxAptMru9V9MHk1jZ55NG9k2eoPktT4UL0MXomQ9DoeXpRiZdRFBZ5a
 gSfKwdx6LrrgbKWBx4sxIG9blRZ/3GDrrQxJr108EPEDyBadtVI9j0KQb0eov6DXcyhq
 kanmgJgmzLW6DVUTjOCIuXwRUAHWaQGdE+DY+5gh/AXAnUFWg7Z1PprvQ45L4sxq3y7l
 Qpp8pq79wbiIZ/pvcEH7WzdatJtYJfBa53tlBAzvws+1DnzS4HBLk9DL1gor+GuhHX67 xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KSLyf1/kaJw1mKCODCklvIQeZZljXypnAuaLCCqGgGk=;
 b=V4oiLoFm0878+K7BFESfk/to039dw1mCjrmgctUc7rFDyEGTWmsiG+IU3C8p/F/BmMsR
 9iACpmGgRoQG0y8S/maUS0W3+nkjtfpIic2c34XqjtXRHhWg88rh9dqCw96y2daYkxt0
 mEF5KBjH4IY+nGjjbdD5NXGU9N5hlPxjfE2V6+8Um2Kx/1D9BFkxV7606YaSpBkcXA40
 dbtcAzkw/x4d7oqo4t3VK6QuiVzJFH3QwPM22nKdaF63fKFhUc4EMOrCBgd9TYJZEbEn
 hmoCzzC3l7/jAesCAdARJNmwpUloP/pHSBRj1Qoi8dBNxozI+NA7FCVtpmiftwKwDYhe ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akw7nb6wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:31:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3VJaf078237;
        Tue, 24 Aug 2021 03:31:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 3ajqhdtmn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:31:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ie/fXJGK2G4SSwZRYI7DS8Mx/2kma2KePWWGpxMPEwh6vAD/p4DyEVYduNBoz1Md53Xu3rhEsDlzHu2ChaFqa13OTFZMybaBMAf436npJXOILH7Vrt0toDlDhywFybSYvEXu2TFib6xXsq2nhmspLRTxVzTx5IQz5Onn3ZW4DJg7mArqglCbOYNk1dcqZfo+zUhqQsX7TMPAZmcYMKD1I9/L9wtZjkE7A1+iEpJlyii/EeNBS/63iPoMQF7lUynpiKnoMvEjDxwhMCD9WlkVvwVbT52T9Z/esb/Q0zQQIIlhZHlFRK8Vqcx+LZTWH+f9WVocR2z8DR/UqpCCp/CDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSLyf1/kaJw1mKCODCklvIQeZZljXypnAuaLCCqGgGk=;
 b=h3BopsNdkPjqfH2tPWT7eY5rv+NYuZRgbxj1LuwnJLYs+CNUB08SKv03R8iqMnxZpvN0ja16e/iHlOzENuJa4B775vudlz+9I2Ba7o0SYYoXn3OipwsxMXGTLWjK+9C8/jxdfmJN/I2237kJx6MtfYhzt5Aklkph3LByEIlv9c6XlA6xs6OmLCxNuyl5srhL5kO7IwSD9iBU24PgS/4itW5h5bTsiJD1iiRwXrCChtE5v9TEpYRoTiH3joVJypLCUqLUDWzdynuTglsSU83r6aYVQw0Mw5k4cyOFyX1Sno2K8i8fEC5YrgFisdkCEw9Wi6MsKlmWscmWS/0cKIf7OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSLyf1/kaJw1mKCODCklvIQeZZljXypnAuaLCCqGgGk=;
 b=tqclQJwJR20YdyAZJ7686qLV3r2MWiyQG0Xfqkws2fLEG61tqAHSat8CAVzx99eo3Es+d7WK5I1DkQ7Zr3/tTJfxDgCiOI3SIR1jCUzhB7myZgTaKrqPsHX+25A/qSSrjRa8rIvBhFH4BiglXVHpe3jz1ZXuoRuCXyWBmyxICGY=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:31:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:31:41 +0000
To:     Keoseong Park <keosung.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: ufshpb: Fix typo in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl5necx7.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210818094139epcms2p745d70390a0e328f3ecc3b266f092c9f7@epcms2p7>
        <1891546521.01629282781634.JavaMail.epsvc@epcpadp4>
Date:   Mon, 23 Aug 2021 23:31:38 -0400
In-Reply-To: <1891546521.01629282781634.JavaMail.epsvc@epcpadp4> (Keoseong
        Park's message of "Wed, 18 Aug 2021 18:41:39 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:806:6f::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR12CA0003.namprd12.prod.outlook.com (2603:10b6:806:6f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 03:31:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50f219ff-2e28-4f2c-9950-08d966afb079
X-MS-TrafficTypeDiagnostic: PH0PR10MB5579:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5579C0C40BE0CBEF303CB77A8EC59@PH0PR10MB5579.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1fLdvzQlxfDNlIMpowGX8XqQ/5GsEhfAYpiYfbibzuhMZAnaXs+StMT8QtW0F+q12/LpJrsb9LJKxr3rwGx4vfswuVTvcjVXmHog/55lOpgBHydEFLWQCD1qIUa6SHvQVLF+TPsalFdUughLG6ORRM0Y7ysr5myPOSKz4Xb3wGGdnADgUhanWV+65IH3Drea1eJm1RuWN3MbiRdmu3GlA12FJ3hIbPjzfrlKQK5BBap8tuDExZTLI0djgYiuDprNoe3PCLT4+Riqyv7DaJYtsf6P44NyBl+1DmpQBaE+Zee963XknWb5PTLd46rIr38QAuohctQ9XMgdO9RB93o5QE7EH6xenf1st8pA/ILNGblWeqXXFmfyKrKLETe+beSPzIIRoz6q+lVem4/pSae7KqLfqmsPNI0XeszLDSW9JVLGn/2VKj254W+cOhjRGzogIn5EunNZMWgHEhjZutOvzchlsW+3s/TtPuhrMjqtOzRaDXUoPPRBd6wREoGgzv2aL79QEsX9WmavsjqLbQJ72TRl7bZi61Lv3sWjnmaS5m+MU2NAKPZFZ50nmaKTu9gjoEWdNMklNnlrFeXVBiKISrJ4+fB+kyJXyW2il8nOrSbEGVRUzcRjM+ffg6zoxxePWf/bUAVPDrm8P3Ede9mDU5FUotSdgzke8u90O+uBWfHp/SbzoyIgeZF81b7Qv1q0h+h+UVXT68lz7lXAT4Wrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(36916002)(66476007)(4326008)(38350700002)(38100700002)(55016002)(508600001)(66556008)(86362001)(26005)(52116002)(2906002)(6916009)(6666004)(7696005)(5660300002)(316002)(66946007)(956004)(54906003)(186003)(8936002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0y7H1J+PQyn/bHsT/BekVEjU9kGk/+1SJWycvZJ4k6+lqvvCeSfj1Z5UrqY?=
 =?us-ascii?Q?kiHx1Hd1gWo7rcPoeNCVI44V3S7WcHa++Lr5cDSobwN7nLd/ihmkRuEgKOfZ?=
 =?us-ascii?Q?1IOgrMgLFNZSczDu/jmjYoA5W4jQTDkTIhL1hU+2LpIP2jBxRWW+bNAJPvvE?=
 =?us-ascii?Q?vt4RU7xu2p37+oBL/eIWCCd85i7jRr/8TlZ6CUVKtgG6DugOKgbAzPaAbmR3?=
 =?us-ascii?Q?l5Yul2WeDLKKcjYbnjlFsiclfCInNNyrBRJsZaoaN7PMC12Ji1bmR1Jw8TU5?=
 =?us-ascii?Q?JxhQ0UQasjWMTplgsQ2txIee783CK13v1wCCQwiLW5pRJdeJzc4XJ9cTHicS?=
 =?us-ascii?Q?533gxGdL3wYiZMZhw6z0c6ZGm1wXu9EQbrhVT/q8Q1KZA4rU9G7AAKwNTpIL?=
 =?us-ascii?Q?lPKxSn73jK64mtVocawaGOi5FhCXbrcd2XCnhYYkISJqFwW2Byf/Uur4f5hr?=
 =?us-ascii?Q?IuRWiosi5qPrwwCvBEt1NFNEQWtH+oRLtECJD3ehZoADkPd2BDeG8dMLj/qY?=
 =?us-ascii?Q?1rg/oFRgthIcrwElOtgzrRY+phIcKp9an3vU3vmtzSrdvP8YXrO7oxBCDp38?=
 =?us-ascii?Q?0QPqhjhS8AcXXY/zJ49gyvO5IJZKNnm7QH1/BWCJkTD6HbKJz3Ii6INrRB+9?=
 =?us-ascii?Q?IiC0vdqsmvPDPBShhGD5A0o1UwAGeO94EgVPiqocTNNRiPzA5PAdzO1m132r?=
 =?us-ascii?Q?asumG5yws5SGonNveIkIrQd7tnYl2AS/kvZjdjkFUMd8YlQRAhgXb0zWApxc?=
 =?us-ascii?Q?zzUkWW/P0mSDaOBHveh+xH0yYFilMFz92MamskPfqweSwl0LRyOMyd3oZmcz?=
 =?us-ascii?Q?Fns8BhhtcdLmT40AW1+XHId+370nq1/MN9IyepnnKlanFH4b3744DvyEdItX?=
 =?us-ascii?Q?dhMQaX3IgImRR/w8qvNkjHndVSiqW4lWmhq3pd2Hiztoy8FE3t3aNa+PkaKp?=
 =?us-ascii?Q?sTVJe2Hk9mTHZb5Ag4EDCgkqQPHDfQeUc9OIs4mDTHZf6ymHv0JjOCu9tdpW?=
 =?us-ascii?Q?ZXBbmXniKjiRAL1CqxnYAo9xft1an3PMc2uoXcFm7elV3IW07Ar4SsSGWVys?=
 =?us-ascii?Q?SwPht65ChgZM6d2G0nqNpkbXGnWGBOjlSjM2Ef4enZXJ5a8KYE9nSIuANYu5?=
 =?us-ascii?Q?BbpMvm8KNPfRwBAM+rM9NSr698O2UbwDJWFXnCOzy28WIMZkfk5190rzLY1C?=
 =?us-ascii?Q?d2hx8OMO8eEnGL0/lf/LSCwG6P6cibhTmnEDQXsZXIjpA2XXQ+WCQ4WOrBHl?=
 =?us-ascii?Q?TCVbf3mpiN1zpk+SDkJHqBc7VQHQ0pPXNsZxW3sM4raLjAqbT6bSyrgq9ZyH?=
 =?us-ascii?Q?v+vI3xFtBwWeLSiAD29HYoPG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f219ff-2e28-4f2c-9950-08d966afb079
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:31:41.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kNUCO7LxKhAK2kf0WGjouTRKlAuRRPArmZaZlwhcg+PkRBI/k+40M7TuQYbO488rusSAuRcEwvIkgsoh35kzj8XX29Cl8IoQwjkF2R5pP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=996 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240020
X-Proofpoint-GUID: kcWqB4KO-7H_gdszTS1omppi_lYeZqXa
X-Proofpoint-ORIG-GUID: kcWqB4KO-7H_gdszTS1omppi_lYeZqXa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Keoseong,

> Change "allcation" to "allocation"

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
