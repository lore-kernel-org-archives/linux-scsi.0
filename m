Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ADAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 12:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384841AbiEFM03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 08:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243253AbiEFM02 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 08:26:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7318E27CC2
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 05:22:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2469aId4030616;
        Fri, 6 May 2022 12:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=6UFWSaB5m8LQVXiww7kJbryePN1KZUlTdPgeq7yA0e8=;
 b=Ma0lph0c27SxF0vBVaXgPB4XG1P2R7OYCpVolee/hvjFfz6OHGF88cmelheD3eur2ymu
 Hoa+lczCTbDXDaa17nTH7aor9EICQwKH8GzHnelqWI9iC7loH0/IwiU2ER2Ji3E+vCvx
 rRZe7OJCSIyVf181KOOj005kw4z1pY1qIMIskGxtKqn9DzKP/TgsZCIn2mGYPqLbGbSj
 NPVDoPYH/XvGS8NN8jyqoDVNBD8vdmA0MgeBzTGYZCpzE1yNOd7zn473DKVTgybu6UUS
 /IQcNSTOuJRYc2QPVUcW4k/88SNDG1E5mvs0CoWZWwwIm2SR7E674vHusRQRpWp37ob1 6A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0p21s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 12:22:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246CBZaq016594;
        Fri, 6 May 2022 12:22:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujbxpse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 12:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvyr71i5AowAzTKCji+cCROvT8CiqfEuzw2x2dZT1USYDyTSm1aiDcLMpErfFcKTNbTOBOqivJJW65iiN6o0DuOPH2OX4Oe/sKHu2t6155oRblwoZ0f3XwCCLJXDhDHss82rDBl4yZxsLIijL/Ix1TaPCBiNnjzlS6AaxsFrgx+1HL6C1dAEj+UWFSGIOivyYCQoSwp4ugKcZGSN4iy+gvQ1ioDLtUoHpDWrKVh3TAqS2nMU82tRR9rT2Ke2Olh6W8ACRHUPlNPxGCIZ5ISWXCS5Sct9EvKkzKB/EF5I5mB3M0OA1JstP/dGIvOWZfoDbawNwBrC8pUPTxhokiALBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UFWSaB5m8LQVXiww7kJbryePN1KZUlTdPgeq7yA0e8=;
 b=CMtcQSeRheAg5bRG2behklVito8Dth+zseSV38wmF738Oo5CpnaoMmxliN6QtDXUwh7H6N3HADE6yEOXbzf6BMZhdf/8A+No7kP7/YzfuZ3yMiCGcmaZPh3B6f5JehNLQEcndQtEwAuq4mCZ3Lg1xRbN+cH5l5eJmbf1PvURrQ95upwoC1pVgYzWy63OCNBRtbZSPwDoOHXEwbvkokh4AkeuUJ/tPSUOM96myPKY7rHCB6qX1zYPh0wVPKXr1BysTo8vIAwy8Ap267NMUm3jh0mmlp4WU51yUxRaIcWNwGtZZG5qe5nHVM7KIaQYp65PV2eayBVqwueCpb8UrhAtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UFWSaB5m8LQVXiww7kJbryePN1KZUlTdPgeq7yA0e8=;
 b=gl7vSTm/7EnoSOMQL/QVJzNZlPbiAOkU4H99m9EcD7gOtX7w5hoM5xtivyWHjkpQgOwUG/jIWzwDvO/WPIuAHUeBQcj2Md1MFQnNF7Zyz+bCnfzzvhDcVBNlmlK3Tvkfuwan79b/r9wcPG9lzHvWeEtgG65XjxHGtfPUWXC+o4Q=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 12:22:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba%5]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 12:22:41 +0000
Date:   Fri, 6 May 2022 15:22:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     sumit.saxena@broadcom.com
Cc:     mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpi3mr: Add bsg device support
Message-ID: <YnUS9ujzQXihvk/j@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0162.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d40b425b-1420-4a92-63ca-08da2f5b1d31
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4752F3CB607D8B17870848148EC59@SJ0PR10MB4752.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GebAZzE73izgfwN+LqjTt6ftPjyORQgmLcKiNp/M+YpapuASgSbFS8dHWBYhVabDZygNmhcpbFwOWsDtB93xnSTA8vDQ8MP46IxdFI2PdNifVAJ/BtFrsgK59mxXlwt4onglfbSl8fCY0RYu67SkicOk2pa0/dFgAf15/SSwRh40rJ5+VPdBIqDwOWBVKNtxC0v0aRcPv1DkhR1P/+Iu3T+b09C3Bolqju/+xwB6orUOYmY17UQQUt0c0e9ZQg7yvIYnBViddJl3+vLGUR08QbX8RzVJ6n21vX7n7TyPpMA06htVlmwuIu+omQLJxuAqlLaG7kgVa1AV/A/2tzSLtD5EvNeubbAukNF/erNy3D1XfijR7RegnDa8zz5fJospsQGwLFmb+duZ6xikOXWZ9q5uo/P+smiGoVmeNbd3EIjBxLqEE7FR5n6NkzeDceeB+t5IsPCLjiynzt9Zs7AkXzXAPDrTLl+pc78inO+Bz1Y6qLMlVUb2F8PDqOhHy8KlMDj3olRh6Up0T6R/WXCA6f9uldNabN1m/oZ4G25zWnCV1JdLoWGcI4h66Bvss6uhs/ljkeWVB22NKcElW/pMKH4Lgm0KoOddACU6XSnBWDCzKB30Fov6snpCGmO89/8+H4sa/Y0cUJGWKjF7YrWrQRuUpQIfn5NbCjcDiQYtiE1j2j14Y5RuhqFgxlcoi2TSQl3VcsCEZpRE4l8gJWUgVed1YNfqQG3xXVr10c5fxIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(86362001)(4326008)(38350700002)(38100700002)(8936002)(44832011)(5660300002)(33716001)(6666004)(6512007)(9686003)(26005)(6506007)(6486002)(52116002)(316002)(6916009)(508600001)(83380400001)(66556008)(66476007)(186003)(8676002)(66946007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vvUzrWvcXpS6OPv8nTEUmfdvzTW8I5yExV3y1U2PBW43iFLuXf93DjtStruF?=
 =?us-ascii?Q?1xSVpuzgyAqYH55V0hXJaqF5h+0tt1f1W4x8KrEQpDgR9fLd2COcY6pLTe5T?=
 =?us-ascii?Q?xx8l2+EnN5JGcVvQGE4xLl80LoWXKFNW8Mk6OhQ/Mdv+Qy4221yncIh+JYNT?=
 =?us-ascii?Q?8nni+eEnqEXaTnYII2Be/GBg1jgsk0wVE4b79ZHCWLxgNhoHnj6XJMRdbAuU?=
 =?us-ascii?Q?1XWpoOL4wnwU78g2uQPrw8/Y1IP45tmuzeJQuD4mk68kulSopl54tYcpsTLc?=
 =?us-ascii?Q?eCnqXPxrlcb9vK5J3T2F6jNg9pqdpqO8fsUhMRXMeGus7tkJgWYbqg6A41II?=
 =?us-ascii?Q?PaA46FI8Jk1nacmkoZeEY9eoTUZK2fX01vNqfowjBccDXvXP5KQIxu2jrFdm?=
 =?us-ascii?Q?3telmeltJ5IX7svGzkK7Yrc04S7u8NTmhTK0wen8RitVNg6rKyJsiL2XMfKc?=
 =?us-ascii?Q?XL5hjz063Hg6a+KVfhpU2bsiNgbkwTjAgdlbtASjUSh1lU18hoPW6nY8gEE5?=
 =?us-ascii?Q?Pfo9bziOSDCpZkwh9TbzefTl00UgCWunFKpf/TKHDg/mjC+kYoyTpT8Xb/gB?=
 =?us-ascii?Q?nQOIzaeDFuuQ9F9FMnqOHJGP/2xWJcsA0Iz1J5p9ix2RpZwPpXRpfKIO2uAt?=
 =?us-ascii?Q?HPtC7npLIIMAmP1cpcRsMHTZea84lq4q/JEDaP0izk2IAOAKpAGU+L8odZo3?=
 =?us-ascii?Q?Gaku4mbWs7hH9YepvGckrsZs0CSzuYv3/MkJ+7F7ERIBbDapGHm82MtswCwc?=
 =?us-ascii?Q?qfb0yWJX7tq2xq+WiCapGj0u+/jdIfBY+fX6t2bns9WMoQWsS7pylh1IFMhK?=
 =?us-ascii?Q?zwR7koHAI/53a/oO8uKeF4icOtwDra8gYCQxI+tIxhlmq09XY0B1obx9euOf?=
 =?us-ascii?Q?6OpuO5NSs3CfEXsemYNWn+fCbuJcKb/WQudZXB2DTsVHOxSyzd/2fvRcJ4uN?=
 =?us-ascii?Q?9KFIxzYeb+Nx7UQDqRoLMfsZNhsh66vVMGO+U3lM3fabCF87HqlvLh4TRyGe?=
 =?us-ascii?Q?EcAnWfAWYsiJvG5hhfYbWzD7fedrsbgZIstccIQCHLSrC5tHwuswze2fqG3/?=
 =?us-ascii?Q?+8SHuKBmqbcaE6FSAC3joy9xN+BgssWU4G2i2l5Cpre1nbt1IcrBc5HEOtZQ?=
 =?us-ascii?Q?tEtaEYblMe0V40O9r4A/wTlMVPR5n3B7HniBlV9R6LM62ihfiULkOVVHbOok?=
 =?us-ascii?Q?cGE1VOiCv796Pmlj8hi5dBs4rm7ea3S6DtmtaQ1iFuhwVagpf+G7gLFv83MW?=
 =?us-ascii?Q?yIcDWaKihlVSGlBoigybtHoKl/HsTNfPgExK0naRopcihrrIsmzeb2yJA7fP?=
 =?us-ascii?Q?WVAiwrmFP1McShWAO0t+xeFQvJxWUDyuFxPfz7asYt/yjkSz8hrZcbdPnFqM?=
 =?us-ascii?Q?CmK59lPEkUg+vDuVLIrROPLBHw0bdxWeT99FxVHtK4ziwXsVSFq5MJTEJcio?=
 =?us-ascii?Q?FcFPx0GJzeEHRd4j9NDmU6VT8AIQqh+KBbbgM82mkAwSVPaIaOUWS2oDwK2x?=
 =?us-ascii?Q?8pPeoqeXh2fXvFzh6d7rOnNUfTuOz1OSE+t3yfa2LfQydlcQjKCd256XpZrV?=
 =?us-ascii?Q?BvybN13zrzRUtnMyPmOHhuYVWE4CRegLRaX3Af8LyVSoi9jW6qZ3C8CknKMq?=
 =?us-ascii?Q?dV74q1VLOVPWREzTH5wuaqKxtf0PIPZZFDbXoaAssIyzZYu2kin49YAg8P/0?=
 =?us-ascii?Q?cFD7mPMf8nt4AVBQw0CVUWQTjhReMATf/JsrCJXclNMaYpNcaxUoyG5zqsLf?=
 =?us-ascii?Q?YrKTQ2DCAQc/mqE6j7kHRY17iuJ4Rnc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40b425b-1420-4a92-63ca-08da2f5b1d31
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 12:22:41.4026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KKyC20DuqdpdnfT7iEB5sB9hAI0hrHSELOUMslfDj2ZYzdu2pMwCTJJFJAehhgJp40fRy+m8Y+hvvc4MykQ/1Tsoch7QFBDIyyWFW3UoLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4752
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_04:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060069
X-Proofpoint-ORIG-GUID: u82ypKW3UtQfWkrf1VLDPuZkPnLGZ6UR
X-Proofpoint-GUID: u82ypKW3UtQfWkrf1VLDPuZkPnLGZ6UR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Sumit Saxena,

The patch 4268fa751365: "scsi: mpi3mr: Add bsg device support" from
Apr 29, 2022, leads to the following Smatch static checker warning:

	drivers/scsi/mpi3mr/mpi3mr_app.c:1539 mpi3mr_bsg_init()
	warn: double put_device() 'mrioc->bsg_dev->kobj' (see line 1539)

[ This warning is from development versions of Smatch that I have not
  published yet ]

drivers/scsi/mpi3mr/mpi3mr_app.c
  1480  /**
  1481   * mpi3mr_bsg_exit - de-registration from bsg layer
  1482   *
  1483   * This will be called during driver unload and all
  1484   * bsg resources allocated during load will be freed.
  1485   *
  1486   * Return:Nothing
  1487   */
  1488  void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc)
  1489  {
  1490          if (!mrioc->bsg_queue)
  1491                  return;
  1492  
  1493          bsg_remove_queue(mrioc->bsg_queue);
  1494          mrioc->bsg_queue = NULL;
  1495  
  1496          device_del(mrioc->bsg_dev);
  1497          put_device(mrioc->bsg_dev);
  1498          kfree(mrioc->bsg_dev);
  1499  }

I'm pretty sure this code is buggy.  The put_device() has a config
option which adds a delay to calling the release() function
CONFIG_DEBUG_KOBJECT_RELEASE.  So if you enable the delay, I think it
will dereference "mrioc->bsg_dev" after it is freed.

[ snip ]

  1501  /**
  1502   * mpi3mr_bsg_node_release -release bsg device node
  1503   * @dev: bsg device node
  1504   *
  1505   * decrements bsg dev reference count
  1506   *
  1507   * Return:Nothing
  1508   */
  1509  static void mpi3mr_bsg_node_release(struct device *dev)
  1510  {
  1511          put_device(dev);
  1512  }


Normally, the device struct would just be embedded into the
mrioc struct.  (Not a pointer).  So this function would normally be
something like:

	struct mpi3mr_ioc *mrioc = container_of(dev, ...);

	kfree(mrioc);

But here it's a separate pointer.  So I guess it should just be:

	kfree(dev);

[ snip ]

    1522 void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
    1523 {
    1524         mrioc->bsg_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
    1525         if (!mrioc->bsg_dev) {
    1526                 ioc_err(mrioc, "bsg device mem allocation failed\n");
    1527                 return;
    1528         }
    1529 
    1530         device_initialize(mrioc->bsg_dev);
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The device model is very tricky and it confuses me too.

After you do a device initialize, the you must free mrioc->bsg_dev
using put_device().  Calling kfree(mrioc->bsg_dev) is a bug.  I'm not
sure all the implications but at a minimum it's a small memory leak.

But we haven't set up a ->release function at this point so that's
another thing.

    1531         dev_set_name(mrioc->bsg_dev, "mpi3mrctl%u", mrioc->id);
    1532 
    1533         if (device_add(mrioc->bsg_dev)) {
    1534                 ioc_err(mrioc, "%s: bsg device add failed\n",
    1535                     dev_name(mrioc->bsg_dev));
    1536                 goto err_device_add;
    1537         }
    1538 
--> 1539         mrioc->bsg_dev->release = mpi3mr_bsg_node_release;
    1540 
    1541         mrioc->bsg_queue = bsg_setup_queue(mrioc->bsg_dev, dev_name(mrioc->bsg_dev),
    1542                         mpi3mr_bsg_request, NULL, 0);
    1543         if (!mrioc->bsg_queue) {
    1544                 ioc_err(mrioc, "%s: bsg registration failed\n",
    1545                     dev_name(mrioc->bsg_dev));
    1546                 goto err_setup_queue;
    1547         }
    1548 
    1549         blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
    1550         blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
    1551 
    1552         return;
    1553 
    1554 err_setup_queue:
    1555         device_del(mrioc->bsg_dev);
    1556         put_device(mrioc->bsg_dev);

Smatch is saying that this put_device() will trigger a call to
mpi3mr_bsg_node_release() which will make the refcount negative.  That
seems like a reasonable warning.

    1557 err_device_add:
    1558         kfree(mrioc->bsg_dev);
    1559 }

regards,
dan carpenter
