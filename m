Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D545C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 01:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiIPBkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 21:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPBkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 21:40:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A8D7435D;
        Thu, 15 Sep 2022 18:40:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FNnGuS013546;
        Fri, 16 Sep 2022 01:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=sBfI0TTisYl7U0TBoGirf+w+E00dpdqPaJp3a0MnskY=;
 b=fyKQ8oCmRqAco73i223CjQ5Gf6KPxwURh5VEWgDcKo7MeUrqS7vJUx0XIZapmqubUPs0
 cHJ9Nf4Pca8eLtWwUYXqg5sTuihJZlvlSoiWNe/fNdJ5ms7OxmmReqa+FqB9q7rdkfCZ
 LK/LpyagSJSFf71nyD+TV37cQrlQCzY6xp4WfFT9+VZylbjLMAy6KkKE6EgPmbsJA3vZ
 iYUjj8kfBzfdyXGJbJG5sGkeJi7R2CjZi/RdGe4TLcwYxhy6fnZWjjqz9QJtPtfE78Mj
 gX87fxEhEuW2b6mCuywd+LuUOPCNPd6bFCDB3R/3b8GzzdVr1HKuF8DSPYp2mZLR9eUF Yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8xbs57p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:40:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G06Jtc004158;
        Fri, 16 Sep 2022 01:40:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8xenbn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:40:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ismadmuFz86W57c5duACIHbTYrsXGGxrxr6N7x3BhIDXrg3NWa9fCHdF79oCRnuEY1eGijXksIBahm+byDiEroTJQHkRKMQ/26qQhSlcoK5RbtYd3k/4eRAzFOS/OSH6AQTa2s6uIWy03g0WtTaKbBU2ov5P3moTtTpJql/be2jTY/iLkW2eCg6CO3bVYM5TOpyEfYXDTXYgXIbD1nsrv4+uKZTVmzJI2gDtjok8W159RBEVoCjvNRs0QMzUplnZvqWIDiUzaN3j6GYke2OViEigJd1V9N34Dr7/l7lxe+rGJxOLy2N9UdE2Iwdm/b8yF/1jUC6VHdYWE21rI8oM4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBfI0TTisYl7U0TBoGirf+w+E00dpdqPaJp3a0MnskY=;
 b=Yx5qwxKjO1rD0Vmtws2yFQKjXDrGgPA1SuvALsy2gltBj0WvD7nyYFbeVPlrBIPlrpyeSFCRatPk3D33t9c//0TdS/2su/MQtYKpx9tO64TbOr2WdwX85nx0Gilw5+RE7qtJSjt2YBdNU5O9BZKU6eQt6Nro8b//wm9tdnbs7qP0U33WgsUZanj3V7cmNsltihfjxGOmGl9+2YRMSmmqayQ+zQS+QsLPe/yjwfPnDmbsKgb2Xu9KCTR7ewoWuQzPwGUfNeEeDzGbh8S/tMtFsyaM6VXEekVAhySnGxAH0jnx1LlyeC9dQRGpEHa23N6SzOJhBuCfxiRn2Hj0m+zkhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBfI0TTisYl7U0TBoGirf+w+E00dpdqPaJp3a0MnskY=;
 b=h2TmyHZX/2mdRdoHks4o7g/tjBUDGY+boMTzFxHw/bksZynh3j5GoLGsrcaRysKrbor2GOEnqNGZVAeK/cMUPG3qOAN/7YMgPPZyc8TCWIHRpqRVBkIbgNGt1JDgs8nsnWXi4m5/ZjMaCga5ukfeFD0UU8rrU2KeZRS5rSBbLgk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6108.namprd10.prod.outlook.com (2603:10b6:510:1f8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 01:40:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 01:40:12 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2] scsi: target: core: Set MULTIP bit for se_device
 with multiple ports
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu582j2p.fsf@ca-mkp.ca.oracle.com>
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
        <20220912125457.22573-2-d.bogdanov@yadro.com>
Date:   Thu, 15 Sep 2022 21:40:08 -0400
In-Reply-To: <20220912125457.22573-2-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Mon, 12 Sep 2022 15:54:57 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c874ffc-f622-4745-d522-08da97846573
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xeXOvoqhFqHlteL/A7TMBC5iSGpDb1xycJlp2Gkkzrcbb1tUdJEo/qGkpphS1zosMyq7hDk7721NMBJzr70bVkhLfxjQnp2wAC4niMyNgA3ropk8EGsMg6N5bVu8BkDTH9U6WGBiF58/8o2YmW11EIyQGEmh2nd/6o0PYjpK0JMRBt4O96bQXph8+XgPMuekUW1HQR5ogSqe4NW0LCWorp9HxGVCbsKEbmVhgweSRexumcXok1SA2Zxgjzh7A238L276jkDU1wVJKwnqMTl/alq5oVPUmjPUW/FdIb5l9qWkw7dp11m5o/wd6930JCtQfEnS+JWW943972YjvsheqZBlHZ20IVUzoqN+msFcME2tdmN09Ca9qr9Hi+8BjgeqXISHkApdv08oBFlkXhpA7SRgAf4l0ZSLSrjxKPmN8SNWnnQpGVeoBF+FnyKs7SbExnIw1KqgNanknDfS0A1s7pYAMel1rVsUIaeTrBKkxGIFlGmA6qM2bI0mjyrbukiy6kpnOv4ACiPyGM3qDI4HbW+4RLRJT2ZikviF9Dx44uzTsikey6hIKjNAZmyebcEngQu7HcbbuFWhMAc8Zn8MJWYcI9apyXKAHt0Zk4/hwCIVri0JAXR6JOSKNP/NsCt/ycg5Z+uhB+57jrL0P6+QaAQaldHOJNh4DIJG8yKBh5qz3OS7m9FT+So79dHcNh/ofo8M73fZxJWPhqZ5/oPAEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(6916009)(2906002)(5660300002)(66556008)(86362001)(54906003)(478600001)(8676002)(6666004)(316002)(26005)(4326008)(6486002)(66476007)(186003)(558084003)(36916002)(41300700001)(66946007)(8936002)(38100700002)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vhofh74xNmOOAVNC5E9xLaCISITh2McEMf5V1Xs7UaE8ZQmGma35g1cUPfMR?=
 =?us-ascii?Q?V6eKsImWrADmvCilC3W4obApx9utr8MXE0+i9VM0NDU1cAEcSMnwkZn6KfYe?=
 =?us-ascii?Q?1pqiipBm73j1WaWW9vIiABBoMaMoY+qJ/9D/EV4kqhESWXZTK+6Inw5ZMKcR?=
 =?us-ascii?Q?3us+uu5RlmDxTEN84Am1cMQ5HC0HRPrPLxM3CkjCx52xrGqyZl3cUxSTaGWE?=
 =?us-ascii?Q?v72fIW/BM06Kgrq9mn1i3HM1YdeP/UnD6FMsIN7x7x940oGP3N3AgFmyEUaL?=
 =?us-ascii?Q?Dzbk3HdvDyPgXDxux0PgCD4I/UIJxkU3UcBLTTDDdLa1LR6NjzKVJk3opZBJ?=
 =?us-ascii?Q?G+9HreMc8Eoo4FzMwR4HFj0lys6M8SaRQQeQJ2Exq7A4J/JoZf51xryMhoTS?=
 =?us-ascii?Q?hkC0C5W4VuF8pCafh93zgMdO3rXxS487vLiyv4/CRLYTf5XyfHs2cElv0foI?=
 =?us-ascii?Q?DKGdtviHR7lHV+vMOllhcWl1maByUZVsKcQC0vzjKqEm/lt+GjEgV1YkCmcR?=
 =?us-ascii?Q?ou0Ve+RJGYToMA1MDXMYKVzH2FCETQ86nAuPiBLLKj4iQDJk+9UXom6ZQsTY?=
 =?us-ascii?Q?jBKe2pMO1fYFTel/N44OzVsXV32GLzGjmTGfxgBjYcvVS5xLdJl8CyeZMj7T?=
 =?us-ascii?Q?T8wYQpOFuNYe5qTGjVTciuaEBEc6bWtFX+VHaSUp24JwqDX+yBo5l+Lvb8Ph?=
 =?us-ascii?Q?dm2M5ALnksfgJN4nTNqMX4kJIXEGLzYe9u/hLInFixTRXu0tpet4d8D2QfU4?=
 =?us-ascii?Q?+3R0yTpu9d4P3moL1sUBdF/I92l6V6N7IB9JHa1wTtfZx93KujuqDvKazl/U?=
 =?us-ascii?Q?zwN9sm+poSslliDOobIyIPv2SshTQZ4meo88ZrcvyFHHanahdlb+C4htx+9f?=
 =?us-ascii?Q?b8LHyH8juSdtA8RaZaLBBnSxlj9dPY4ZPN3P18TcxSygq/cCTbGkv26hxfV+?=
 =?us-ascii?Q?43lH1aSjNCQSSjITJWPzJoF7SFn5ArgY5N8Q1DZ5iHMh+ghIDteBPLrKjx/+?=
 =?us-ascii?Q?kDLO12Gr86eQ24QqESQ4xwNl3qQBMlRJy2dQgukt9VJ3qW0HS1CrjuC3amKv?=
 =?us-ascii?Q?83naZp5N5KUkQz3B5OiM1Wk6pjHzNRaDkONGY2MS8Llq2i0zrkc9vIy4JIsh?=
 =?us-ascii?Q?OuTq0EbYRENlwSpvl14cIeR5wuEm3tO6QteJHbUSLzPKuT8TYFBXIeVhx4e2?=
 =?us-ascii?Q?CqY7II/Yic1/V9yB3T4UitzO450hQ0qNC0/R5Etbr6kSQC991LdgkSYrtomB?=
 =?us-ascii?Q?cxpSCN5awfUuFWkqoxLsPT+5hVAtpDhEJqy/XCMlMQfma+GQfuMisRU2r9tW?=
 =?us-ascii?Q?y/5uxHyxWvUQmUJJcTLaITFCBZyX4479JxNyd4sYXxm/HSy3DK15Y3BJzOEn?=
 =?us-ascii?Q?XkbM5tSnBtaW5ajVJQygA5rciAabuK0QT2rvFpon1rPNjok11o0eRWzEgQgh?=
 =?us-ascii?Q?HXdEwqn/yA+8Zj5B5tBbXJmQqSkJX49H7R/fm3DFA7nXBvmE7CYzQLA/D2ZX?=
 =?us-ascii?Q?Cs9BpE78S5mfdp8OyuZMgb+Whus0uXm7JdHFJM8s2qprxcOMMW7m4H9dsUrm?=
 =?us-ascii?Q?8yG6BPCXRFUO0lhiOXQCIRRDMzc6DpwqFwPPlOn4Qaa443Gnho3Igbg/HGyg?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c874ffc-f622-4745-d522-08da97846573
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 01:40:12.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVwcw/NDgOFq6gbeamxYQ4cphJckSup2FPxNQghIrAw7RWubVarbodwk2nE9/tJWsBgAMki2C3rrmhMIPnHJnyNCe4oFUGWFOEgY+wlMhVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209160010
X-Proofpoint-GUID: iB1VIDehcWCOxlpb6I6Zzg0m0yAttKrJ
X-Proofpoint-ORIG-GUID: iB1VIDehcWCOxlpb6I6Zzg0m0yAttKrJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> SAM-5 4.8.3 (SCSI target device with multiple SCSI ports structure)
> obligates to set MULTIP bit when there's multiple SCSI target ports:

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
