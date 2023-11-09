Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F920C4167D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Nov 2023 02:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjKICdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 21:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjKICdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 21:33:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442662582
        for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2023 18:33:48 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A91hxjG020128;
        Thu, 9 Nov 2023 02:33:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=kp5Ieir8JbifFWTHjY26+ZoSC7jshfBvTSuFeN2M/PI=;
 b=n6Fd6MVXdtFQWSuD8GsLCxjr5gzODOaVl0Iy9grj27yLCfvfVSI1DHVkcSwkooJwI7Vy
 WpCdr2d5L/gnJdEZTGy72wM4au2ZJwcQ97wXwJAQ6DPS5f4IMjeF4iWbcE5AAhr9yp2O
 q9fUGyJ7pM/GSC4WGGIahyv0k/6PaQaVyCrLz9wTGlWSDiljf/DxVMwYMprh26M3iQM4
 F7yI2MjuNUdFjEmxEoNMiavW8+cyDdzjwksVOPaUH9DX/PU2O8+tV+OaPfg2B5oL56Tv
 55e0fo/aLUUbRoQCrzVoIi+pfGdoaRgojP+WO0eytfhrfeOUWLOj/bL0AVFO/qlQ5NH7 lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w2030nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:33:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A92Nlun000407;
        Thu, 9 Nov 2023 02:33:45 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1yre9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THRtdROjrGuNb//+WOhaGE0vBs6d/KDdk/3lquokDLW2eaSh2UXfJkecMvir1OGwt+QEBodIaqpWkXQIXf6URBOf4iVqeBViQZvRLxTxFQbrZuOiGvuMg8dwPZlnDfmkrCOL4KO1JYaY7ivj/uP8qdUD2imUP+EZPh2Su0Ybb6S9ogFZ8k4SmQFIaetKUE2OhP0QQXkDrv8UMYlgCEcWJMjLkXYI/jXN6zc8ytoLgvim99GpPxEGrAyphAfLfroSSfWJxb8BdXLTBNht4zwRsAwAKmhdas/Z94tmRj4oJvPUMV/q5HOzwBsGRX5lNHpBqB7IrXAzNgMqtnO5KU0aPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kp5Ieir8JbifFWTHjY26+ZoSC7jshfBvTSuFeN2M/PI=;
 b=Kgah61xvvQKidy9pYptfggbpOYXJumYSUgy0FI5cEBq8rFcABwBu9p47wbbisyPf8hcHm0o03tAjfQoP69YIKfYTxcDxKBALXltli3wPzKdqm7g3M21Cmp4GjYN7V8R8YcNbPKuHHD9lsiVVPYSlCLxRTyOaC4x5MTlv5B6+YPmrzaG3N8I5MB4VWSUN4kU5ypqO2UbtkSCo6pzphBoud0PiyhImixxdk9Ji1JXPnGhGqEbDlnXZ2XzsiVzpZXzYAMyNEF17U10uUWLDxwwU9I9zlBMwFCZuACZzHXpco76WlBMCKg0qEgqfMI4eAvnJ3PWmVj1uI+97a3O2xLFgRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kp5Ieir8JbifFWTHjY26+ZoSC7jshfBvTSuFeN2M/PI=;
 b=GIaRiug0/azN8f4jo9KN+k0IpqCn+8aWciKC0ZyUi8Bx+zKVMfYqXc00i3ozsOG8MHoJTIaEfFT+3yZjXRYghfYpzyG8UDmXvOXEuYFDnKnSdhnbqrczvo/puUdojQ42CIUynqzxRJU7GNLjbXrj5I/90xq5uwmiZ1NtMkjD65Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6667.namprd10.prod.outlook.com (2603:10b6:806:299::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Thu, 9 Nov
 2023 02:33:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.6977.018; Thu, 9 Nov 2023
 02:33:38 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH] qla2xxx: fix system crash due to bad pointer access
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1msvn64g9.fsf@ca-mkp.ca.oracle.com>
References: <20231030064912.37912-1-njavali@marvell.com>
Date:   Wed, 08 Nov 2023 21:33:36 -0500
In-Reply-To: <20231030064912.37912-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 30 Oct 2023 12:19:12 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6667:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d307ef7-7010-4904-6368-08dbe0cc479e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v69dquCvUWJLKT+JcVZ+vRxOWfSWVdn+Zi8X6AD4PRvfIcH9XRN3G8yfalJtkzm2BFvs5WLeWIIF5T/W1T8HWpf7t5H00SHXFvz4RyjW85BT7c2wRHvgFnZsXttBjCeHqH1kG90F1Zl1ASrq8anhQ0Z5i3Ky1I2dAoX/sOBjmPnr9miq2UcrCcHQ8ou0G0SAlrgn17GKy0DQMNzA9T04NUC+1ZMFkP28X38xhd6IXZc40ZI+1hMlSIW6Wso97igEgu36MDxaLxDlCB4H0CYk4AriRHFPAFOKva+z8jp39H1nrsIfBdbZibWxXujsBn4Im0iEkPFzdPQ7drfkeUnpW7S1m2IDOu6LZ+iPvTLLYE7J/xp8f8iVXgWqoXCZNjwHl+DWAv4/RkV81L0n6afdV8i4eE8CPmvoXbP9LOIMQsK4H4iskvfXxCvme1P378ShPYZ8HBfub2h9+ONwQbmmB0sDcPSOhsFy3XvSloq71Mxx0TiZohzzjMA9zgrRIE5GiADrPSDF23QpWCuxtNi8A3WurDx4scoe5vIASoqxlQYzDQwuFqncX7Va87xnPKHF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(136003)(376002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(4744005)(83380400001)(38100700002)(316002)(26005)(478600001)(36916002)(6506007)(6486002)(66476007)(66556008)(6512007)(6916009)(66946007)(5660300002)(54906003)(2906002)(86362001)(8676002)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ui4Jt9Hnh3gJi5SLPJRkTZ3hM41KPaXO9Xe/9LNUeNi/1bP2E7cTeRrzHQnS?=
 =?us-ascii?Q?mYheU/xd2nb52u9fr5fnD2sQ55OVXStGI+5Y18X6gAHFuOgUbR+lEt3D5Yjq?=
 =?us-ascii?Q?xkXkFaiTeHE3UYRmoPJVCGxXlqynrJAUiK+rfzcdUe7FTzKP5DvGsJ/+sGVA?=
 =?us-ascii?Q?2BRv04MagGJP6gWe7yUWxC5JDbQCWL4esO1M/8JvFIyr0cwM6TWAAfpA5ZRQ?=
 =?us-ascii?Q?0aWA1WjtS3zDukznit4zSh3ZBmObA6MaAveILZeAHaqkKImSUXQYWPSq1A3R?=
 =?us-ascii?Q?e6XW3oxSm5TnifWQO1Qa4FXxeNxWXPU/vSRt1r/CnRSGOIZGyh46ORL8Gx9w?=
 =?us-ascii?Q?o47JpWYzXnXVzfvFkA4NoFDcnUfHuCZwUZiT/41FrKo5jnMRM11zd8q2+4t5?=
 =?us-ascii?Q?LZTtZ1IqEMiliQOKOlC8iDNiuE2sqHoFRz/WlyxIgKBCyOsB7/Pb5O1Us4oB?=
 =?us-ascii?Q?vyLYJlUwkBFGkKTaFjj6qGlkDGbltxy7Fl2RnvKEry7PlgR7KIji+VZ9zrme?=
 =?us-ascii?Q?NrqwYbCR50fK+BNpj0RJjIA8AEshtlSXbeV3uYp8WMI2zTkEBiNNdmirPwXU?=
 =?us-ascii?Q?J4o6GcLKa/nvohjFIc73Fp23nZH+Gw4288Bd9zQ0zKAS7rvzEpaGWA/lepjR?=
 =?us-ascii?Q?WWrIxUM3mdmKTZzGBiWPAVgQFJbVKUurffbfOPznDZeZh64oJQksbem15CcB?=
 =?us-ascii?Q?LqLYByvg4nGi/UEszWe2px0rIOI0R7g+NQyfzv+QxKF2lDfq3lA+NKvYX5Dq?=
 =?us-ascii?Q?5+xkkforekWAWCNFzcXbEst+kz4jVaNnOUxYQ2Bbzf10p/XuT3D7nb03A0W4?=
 =?us-ascii?Q?0G/CXfLsNHKjgNDslTdigaHiGRBWAe5NIrRPkgrjp6eUXBfRonuBRkzZuIRY?=
 =?us-ascii?Q?cWHQMVXxTHRWppnB9pCpkMzDOfZXfsK8Drm/H81Oy04ICNf3qi1BM9RT156v?=
 =?us-ascii?Q?J9IEvRdevcnteIH5NZgxq8p82Yl2dc3Iet+E9OouWJW6u+nxvbScFizcuphE?=
 =?us-ascii?Q?I8PaXeitgJfWl5vIQtlTGnOyZYSJUI3SeNVCPNXw15WomPMsx6Z7H+Mh0NpW?=
 =?us-ascii?Q?3umYbPZeQwQBSjEvZjfLYlNCPFpkhsbvFgIC4w9nm9Q9thERN0uC4dEUBNZp?=
 =?us-ascii?Q?D7c5UpyzO7jKq7w7nMxqh0Ve8laGOHQUfepYi8DtHSX3f431/qjUP2jPjIrD?=
 =?us-ascii?Q?dPFhK8aefop1hUrK9v9oFk2Bhdi9kaXXfOU3BAFLyNxWqoIw0sponylOWYuC?=
 =?us-ascii?Q?fheOOf6vhFtAfklPegzMw+8mF4BkI09+OW4qcX6I2UxTI1mR8r1D8BVikT1l?=
 =?us-ascii?Q?H+NgczDCeMck2uIp3dzm3oRbzaPwtFcWpjym7tPq0VZYOIKoUeH85Vz0dXW4?=
 =?us-ascii?Q?GsJe0NabFrMIxOCIxRB1hApVwPpdiGMo6YFKgoqJvzmHe0DCUwQWN5NhrQKa?=
 =?us-ascii?Q?FudoZJgxsUu5SS8xhVO7yc9vVv9ljTQ7p7p+uwxLJGnWl+6fHhsCV+t/mryz?=
 =?us-ascii?Q?orNMNKpG3KPaAfvLlZO6Ksbsw5+vIH5nalCQDeoWG3zeVxCH8wfnbRBkOSyU?=
 =?us-ascii?Q?ri7inI/2wxJDXAUjAYpB6tBRdmVrxrxMJcB99AvYRZ8Ak7VGqeo8RigDHNyt?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iv8tub10/mOaPFywx7Pc7Nms5r1xTnIz0KKDMk35UyX4RLZ/NKMIPQ+bv2hgl6DnGuKkpdZ6hCLt0w7OpMtzZ1ty1+WViaaIKRDXlZZvXBFjVTfVZ2TzV9CBNpDswS8Cp7wQAIL0MupRjh/EEjAK8IFMJbtC73Z0j0djJph6kbb9tqlmZp9R6w8zkTTMCxpr5jbI1f5qQ4TObrkpQRkCRcvEkADKWJk1m/A0EVdvlzhlk/80Xc2oodRC8KBHybu25C5HYgfo6q+7ph2aW9W9RpK3j6b2TP0lNKvYybrvz/5yZ2SIPgGHwwzZ71AW/gyFcmhcVw00cUog/ANH0gALIDT9NQNirkDieD0PJwoooxM727UUdARp8ugn+/z4NOSfve1NWwCo06WJkGwXD3ESfYOCxUjj5g7nvV33SjXgrgSrm1H2E+E0yude4pF+9LKdETptmwc1L8qsNrmbNjAFphoai1YXDbnS1bgfspTRSGmoy73kfy47iEl6y75IbU1KsPOlm6DPJvVLF/hmVPCorsymPte60TPd/saiCZkHkk5WrdwuGghGsdgPtVYHcyUm3ElSMoEKrABDRgau1NqpkhTbGWtFWyLPjWZHZmQ0e8pmZ9r39cOKjWZxXBm/pPDtlf6BO4ZMAlCb1YE+xxV3Jgw2UkSjbd5bv3t2pRMW9HOOn14lukdXXJj1ummf09AQ6H3X9bNRvc/8kfGVaoUlA630YpdxGfkIRxDb8PzILe4Z2nzW8rZ+b067wKh/1ISH7WBA7nbRtvLtIjOmzwMQoSWtf7CAz8duuPaXA7FipH8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d307ef7-7010-4904-6368-08dbe0cc479e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 02:33:38.3691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmNY6eeEqse6uEXHO1D9cAbPg3pfrKNzWlwpZKaC+6Vegzv85kPUUy2Uqo+J/9aMrIaPWI8S/83D+lfJOMszwBSZSzFDX4/78b7qiIe5kM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=745 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090019
X-Proofpoint-ORIG-GUID: aK6UxdeIzPSGkiCUCfepyll__gYbNA-d
X-Proofpoint-GUID: aK6UxdeIzPSGkiCUCfepyll__gYbNA-d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> User experience system crash when running AER error injection. The
> perturbation cause the abort all IO path to trigger. The driver assume
> all IO in this path are FCP only. Instead, there are both NVME & FCP
> IO's. Due to the false assumption, system crash is the result. Add
> additional check to see if IO is FCP or not before access.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
