Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122BEE7D0BB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjIVB3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjIVB3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:29:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5792CCE;
        Thu, 21 Sep 2023 18:29:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIslUP031538;
        Fri, 22 Sep 2023 01:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Ao/abrzjCHTBh9CaAv+11LBlFzJwMkGajbLMQlAQl8I=;
 b=fY8vNRp+H836WGhJ68xphjvBxj0y1EBortIhWtm7dzShw7t+ZgrxIC0aCeLkg7UAJSKg
 AqHEtDGZqFP9PfIofqr2hvTgpCkRtLsRntpXCBhyeg15Ry+1htTKin/JxOv1Om0Wzzjo
 EVNZeySaQxV5zu5mySt9dt+AIRzaQ91wlYAOGNY2lgKs7iG4vEWT1DRotCAdQh7lBLGN
 bITuXyD53DjaTLXxYsL68sqokpVWKuHsgqnfFs3ZEo+Lz+r4EPrrNhArT4jOz014ELK5
 jFxIFpLN+1kfpy3TpPho/yITQyOvbj2M9VTZLPS2UNLfHl5VKN+X0dNM/eO5yzvGcqZ+ qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt08k4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:28:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMfUvo015716;
        Fri, 22 Sep 2023 01:28:35 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u0uc06g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:28:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyCqaw3gAsCe0RZ10A9u6BB1e8uvLTxVYJ4H31mBUZBa1vAUnpLPu2Ubs+6gTK3Y/4XxSu9o+yAVDe8UjFnXtnJahTw5bFxpFKmInOibLFVcZT4463nKNcNlg2ADud7wpkUFCS6olrdYd3t3ZmjZXE1RWHs8sBDXV+P+2eTnah/NcrBzLXRD3jtpCcuFn2piDz1tDAfbTmL8eQwgiO6SKo88SVuh8nbqdqEhLaVaQsMpH260Ubr34Q7S4WkcwUmif4SJoDPOTjnU7HaecfxR+00nbVKdqY/tjteMIkVxC1dJRLmfJerj1uTk0rQVEEzBS1ucq3vW130+QyUt4u1BBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ao/abrzjCHTBh9CaAv+11LBlFzJwMkGajbLMQlAQl8I=;
 b=hF6eaXKtVLd6bP4Dyayh18OW2s4aWwg3mqT6GLOndsURA+MuOjSaxwXFER6dFJNmwQTecGAdWumtjzwLZU2vD6YcXE5fq0GMlpWwjRxwS63Y7GrrUDjqF5oOap4ruT11/E/40hUHXMcIn44NX0j2EBNyYibvIYBfAFdhRFr1qvQO+IQvImkBhQivnkaiRAPLSVkxqPYOSvkM1S4V8dR1PlheUBDSAL6JoBz2yg0wpIzluTuIf4PXMeGFMuufLZ1RC5M4vo/WYXewPYGfhjMFle3kdkrdzNmRDX2JUtBZGPGdNWGePMfWRyN1gxTlOF6GiY+aYhsBIvmY1j31NMGTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ao/abrzjCHTBh9CaAv+11LBlFzJwMkGajbLMQlAQl8I=;
 b=x3FrUr2G84qTZHYfbLtVJ21vi13e0xW0odtBE1x/+AaFQn3AzP5sFD+dSkpMmhkExEq27NIOFidsvyJLtf7pBQTTVOWlgVEcv0miSE+38gCNGutEX4pm9cYLlzs7eAlHKoKcbETodtpKDnXbJGRzqwak7BuOoFJjZtSAjLq7zao=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5266.namprd10.prod.outlook.com (2603:10b6:208:331::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Fri, 22 Sep
 2023 01:28:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 01:28:17 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v5 00/23] Fix libata suspend/resume handling and code
 cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq134z7577n.fsf@ca-mkp.ca.oracle.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
Date:   Thu, 21 Sep 2023 21:28:15 -0400
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Fri, 22 Sep 2023 03:07:35 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0186.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3591d8-8984-442b-cbdd-08dbbb0b32f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SS9SYyQhRQGlgkapGERAxOvXPRHfTLqNtRAnd8TmF/WMGQMNyBoy/cwN8E3yZ4rOMgHL1cOg0BSVJ3rt4zvMlBZkDk+fj3klQVRFc3DjJ4HTwaSz+24xykCfRmGFJXbU2eGCwIXO9Vf3QIx/KMnTIoRnvEnNdraS1u/w8S/hi0r+7A0BOsYRkXlr72S6t/9g+hjNBe5bRlHGOsViqfcU7Ga+lgmGOY8F/MKtWWcCpEbcQKcUFiVEJ39LcJ+Pah0lOLarFPbAuwdLhOs5nFrUcPTwoacXJt7iVcvKww9Fyo1DXDqI529wSA0zJwplKBsEHp6m0g0kt7BkC3o+Wu61qR78elzetysus+O7DYmVSmdilzUyjNWT0mxXZM293sgU5qpsm+VgrcuNVE/tgaURYLMZKNEI0YecJM9BHjXMiFIBhPUFKf4rKgyLBIocNNwy/ZD+oze3FSYg7uzrAHW8Ob4gHJszTPqRYi0+4nlyUVSVdOmKGS4WmTXkoHceE5PxKn0naWJZIjxIpHWxy1DVVRFIxZJM3IGO428LWLmm5aDWyixGKgo1oJYRK1dgEmSF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(366004)(39860400002)(396003)(1800799009)(451199024)(186009)(83380400001)(6506007)(6512007)(36916002)(5660300002)(4326008)(6916009)(2906002)(6486002)(4744005)(15650500001)(54906003)(8676002)(316002)(8936002)(41300700001)(478600001)(26005)(66946007)(86362001)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gz/y9lnHHi3TaViCuk8sS7DFaeW4vMFLlWjZow5BsdAP9df3lmuRHASVFU+c?=
 =?us-ascii?Q?yxbmYeAhgc/IPGNWN9nPiD71jJbTYS8xHtvjHvUdNGWGzwdGpdhaqjir95mV?=
 =?us-ascii?Q?g/UQkP+D5svXb/3ENgmXwmoSvgtVAz0tbeix5Rpb97gPvLPyWfNSQXUhu0ZA?=
 =?us-ascii?Q?Dx6DnnkYoziMqfcP2/13zaBFyi7Psde0UkYGfwscw9XkzYERV5Zq3IqE6I5R?=
 =?us-ascii?Q?l54aX09Omld3OzHMYzslRbYQpwamooOBGUnzvFY+j2DpnmMY7wFdLO2zjP/q?=
 =?us-ascii?Q?2WBAwjk9j9xmu96TPTGdjx99IqOmzQvwtF1QA4eGg2iie3QLU6YMadJYbfJr?=
 =?us-ascii?Q?RgFWLIq95G9mdu1qQ8QY6X1LQ/yNkkRjehYfguX8h6jPcFDwe7VklKUW7LzE?=
 =?us-ascii?Q?jJe/i39qmi2xn0xiMsZbsqdThuD0Nhev2z3lZo4jzGgUmp6UuwqLWwKuIWfU?=
 =?us-ascii?Q?gl5qPvNcVGSMFydsKxBJL93k28Cv8HX3dWBqlFS77G1ahzUOLiXnMvHpYOt9?=
 =?us-ascii?Q?c24Mk2VxtYPuNhGYiGrpiLV5NpIbVf9NLsWsOlydsYluESieivqunXQYG9Y0?=
 =?us-ascii?Q?nY7ZsMueb+XL8nqW8rN7lFZU/0a4YIRWHQ/5mv5qjRmsot3Cd0i6uMugpGwa?=
 =?us-ascii?Q?WKa433/0wDP9rNJtztvGlx2wMWd1U+vmlFcoLXunnRL0buPtGqoGSwy1H+mr?=
 =?us-ascii?Q?WGl1OzWe2UcXHGkUi/+YIOOtuGmuDJ7VTKGDPj50Vl0iVQPnFNKTE2MwRp3I?=
 =?us-ascii?Q?0LQ+oJDZVQSI59bATBOC3x0JSz+l9vs8GpZ5ihOq6bsKcTdAIfiyipnzty1Q?=
 =?us-ascii?Q?SKfmdO1+AG+zuG9iANBgqrgx5T2sSL8KN0/3VooLDU3LCLKUIfwRUdZEv8DI?=
 =?us-ascii?Q?+1wHKwnPd5goFtDPmLFCjqlXy5IhYg1kG9dhF0RJooxOlnu0ZL2bQEezNtCx?=
 =?us-ascii?Q?PhTWqCvHE8ui01lfYbhPdRxUVVWrqtbXJ1c9F8f2OPZWE5sF87u/DbkutEWA?=
 =?us-ascii?Q?h1AG/4czyYeRcCxREoC6Z+vDpb0kEOBx38N0hHD2LrAMJIl2DfIj+8VvfM1I?=
 =?us-ascii?Q?J/7OdCABgxmDJbyIYQXIsE+TqsxXnSJ1GwMOukhh7Qvo79eeILnePBSr08J+?=
 =?us-ascii?Q?s8HBjuzQfHrFKaDmCTeq+GGvXyT2w3XR45z2YkwUIk9VyQTOYyiKSOtO/k7U?=
 =?us-ascii?Q?nXiaoc1+y3B1w1mx8ud0fIIS+7NOYAAAGGDar5GioRgcm9+lc9IHPedAUID3?=
 =?us-ascii?Q?mCkcqUOcTcc5/oUn83QR6AyHPqJOl6EjClWABWg2aJ3Dv2aW+dDgh3gXbyHu?=
 =?us-ascii?Q?0WitZLgmJw74gIM2a17dt1MOqIuLTfpupfWRiutGGb7cOZLpikiubCH45JA2?=
 =?us-ascii?Q?U2maaD5/hR0Y2a0XXYQCJrLMoGyjVkgUsr5vYkTN4Q/c1012fa+O4Zu+tF0p?=
 =?us-ascii?Q?b3ImP2XzJDdP4Zw+ZCJk/dyjS7GXD8KhzE4sQKhx1lqiUcyDyvF/fd8BSh4l?=
 =?us-ascii?Q?LyAnmTJAz+mKHgoSIZ2apZqjXSaq/y0F2/ctIL2dBiusvpHaY4rU5Lil2Hli?=
 =?us-ascii?Q?NrXKL0J5Rpa2xQAIw48GjFiITlGpbn3mWzDin6nvWi8BCZwQsJ8mzGGTsOyn?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?mtWViREawQ/sBdT7R+zX1M+B7/+wY6rCWOb9mpYv6ye8f1LD+6eTY1nspnOz?=
 =?us-ascii?Q?qAsZIi9RBILoVd34yGeQhLh/Bc7APJ+RXae/L40rMy4Y9IDN0x4scA1jJQoo?=
 =?us-ascii?Q?c8S6ZOkwHhujHd2iFkT69yNdw893QWLzXarGCKukdfKlAB/dn3p8zwd+FgOH?=
 =?us-ascii?Q?1g2rf5G4aA++5xlkD5GgiKI1+cbiqUH4a5Y3smAkc7vzA/uUvW1Gj7Cccig7?=
 =?us-ascii?Q?Qb8gEyM0EnsH/ztGBUmvucDSGffzXNTWgOOgs4MZaIQLEnYDQb7fTA5fSE5l?=
 =?us-ascii?Q?ZLmSbslZMn7HtKb2MTWkFs3Cg8BOJGJr4smGBVHMjL2etH2xBBtJq4gv+EUO?=
 =?us-ascii?Q?dIEr3Ero8QLhZLcZ4nhN6tCNQZmb0iUEEHi7yFkguZrKkDLXCRbB6p/Sv1Ym?=
 =?us-ascii?Q?q0OIsYW0RPdU+3jhdPZWW6jTUdVPJmcGI2iv9fi14UWLQMGOBU+svZEBiktl?=
 =?us-ascii?Q?jr2XJwge6tbDBdjdG1W1wWLZ0pJcQ9Xjwz2DxCuyav3UyWCoi1vTlK/mCtkE?=
 =?us-ascii?Q?mbtkN9Bp9V5d8tu9ZvEcjNnZXvmi8UtlPAEf1K1GAZFAR6uI1B08c4t9V+Ca?=
 =?us-ascii?Q?waIjTz7Us7MmeQB54ORjap9cMU7h2TfUwVO7nLI/hDldiIhXhdTFHBAMsuPS?=
 =?us-ascii?Q?lqlNlEfR8ye9s90sm06axFa7n4XA7ahcZJQhI+suzoiTgejqsge+TX3ndur1?=
 =?us-ascii?Q?pqOJC25RaNFpVNkhB23nXNooYsmi14stx7Jd5YkzAJlCadJWujDjT4dLeAob?=
 =?us-ascii?Q?ioFPJ7IEQDxxVq+NmLx++V494/tw11eGivKj1NTb//e2CHZTN8EirhHYa1uA?=
 =?us-ascii?Q?fRv4UnHeZ+teZ0gR21splRTLvEZDSKRgnMALtDcxKgCg7Jgp4NxS5lTdSfV6?=
 =?us-ascii?Q?/NkcfuIoyrgj5lFeY2rOa1MFW04G0+h8bate75nOgRIlb27dg6PhJ/rCvPdx?=
 =?us-ascii?Q?/Hzq9P03VCY/YDEJFPiSrQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3591d8-8984-442b-cbdd-08dbbb0b32f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 01:28:17.8880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etgMA7THphBMTVpesUDT0I01bZmY9+n+STeZMs8/6hJatEQyYjdJ98NQG5VSfcVLr5HC5xVLHbSTRcZK1hSbeyKibEz4WM5uCIyJ/GBbhaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220012
X-Proofpoint-GUID: dv7sksZ3INwgYEhJGYLCKI0QY-ad-Iww
X-Proofpoint-ORIG-GUID: dv7sksZ3INwgYEhJGYLCKI0QY-ad-Iww
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The first 9 patches of this series fix several issues with
> suspend/resume power management operations in scsi and libata. The
> most significant changes introduced are in patch 4 and 5, where the
> manage_start_stop flag of scsi devices is split into the
> manage_system_start_stop and manage_runtime_start_stop flags to allow
> keeping scsi runtime power operations for spining up/down ATA devices
> but have libata do its own system suspend/resume device power state
> management using EH.

Cosmetic nits aside, no objections from me. Glad to finally see the
ATA-SCSI binding established!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
