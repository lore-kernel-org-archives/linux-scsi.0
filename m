Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98095C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiACAiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:38:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50544 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbiACAiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:38:02 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029CiqS000532;
        Mon, 3 Jan 2022 00:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tjYlAMGz9ToKMHTBqTsnL681X/O5MPrL8rpcTU7aSrc=;
 b=KrOBBoDYCirjfVqsRB48hqAn/yAuyM3iQXeReN/qiSR11h+mUUNzTiFxX4xThqcqCcIz
 +MJD07nrhZL3fhvGFSCHO9zABPhlVNnxzSu2mVV7NFwnMMUwYXkiMadvecB/H5yL5emQ
 4j7DhNU8vN7xwS3A8xmzg0XpCJ7DNpe3HSArLCqICR/y9jtSJ/RRzsvi/vji3RAmiKmc
 4LYeUnOqxzYhauvmVKCxXnjH60PxN5UZAwEr7A2mtVqbkJHVZjtgDfRjAXYzXqNCwWkS
 QIUhn1UUV0UiokjjIOMlndgmGDZ1eBgo0kKnIA4SzKQPmpzmbdAyNgx5MwoEDaG+Vw08 Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daejshpuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:38:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030b9RA166667;
        Mon, 3 Jan 2022 00:37:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 3dagdjuc60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:37:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZ4VHDOS0urUUF33SjunFNeDP+djHfu/MYRzSQsLzplTtuilgt2c6PmjcSO/kAJLTTfGJHmKs7GjjLIfr6Z58AJkq18DYp+rdX4S7fZXqPubCBUkmqer8kgJB+qLnNq/JcKQeO3fwoyL8qNh0xCvrdk0oUaPhScsStuH2XpQKDI0p1s0eOAPkrWHaM03e2sCkqeOHjf3ectwDqFfRqMXTW+Rr3vDKcXv5W3i5bTiH9rRc7Zsk2hiO5sfQMf2wMF6Xsy5lG3XR3kYafXb1mP0MfKOBVRuAGv4YouV0mewTyovZdz8c7BSZTt+Ygw2m2KFl7aDYt19cGYJaIXh+RYdhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjYlAMGz9ToKMHTBqTsnL681X/O5MPrL8rpcTU7aSrc=;
 b=KBkD+lUUuJindRoGpiEJ7irxpmfP43jKgvSwHRz7FBtSO55haXUbSsebFogx+UuZE2nN84I5DzTmZ5gxQ8GxpAFrBmQCoR5DbY2s3g/KHOjhZ+6Z0ncpn9DarUAC0hKoMRyo2Z5f2Yhz98/RV7CIOlZn4P/VpdulkePnDLeWFQDj5KEH/hV8bkOF7d5ChKhx89GWaSU6K1di47wkDMnMsdWnpRHvXSZkBus3RzNRMiXIwkc3apQe6SpYeROLLycrZtj1QEhewUg3KujKpaFs84mq65TeAE4mSvZ+oP6jFaTOXWDv5LDHkGL5EXI4vZnKVj6j/omsVI00yGCQDJR+Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjYlAMGz9ToKMHTBqTsnL681X/O5MPrL8rpcTU7aSrc=;
 b=Gfi+5sJwTAoDkV2AGl1Z230PgTNEt7+2NAySRRS3FdVqawCrfXOUVfJ2Gmzphwe8IJ9gw/n2IwyPyE/jdOHI6kSspQYoNjpt8fwXzPCwyCwt2MN7EPeeidHXad/gClkj2z26PBWxPGFsBNd8rfZ8xiz/i2SOp5sO9LDepCChQws=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 3 Jan
 2022 00:37:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:37:56 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 04/16] qla2xxx: Fix warning message due to adisc is being
 flush
Thread-Topic: [PATCH 04/16] qla2xxx: Fix warning message due to adisc is being
 flush
Thread-Index: AQHX+JT9GIaWhWCw0kG9cCgRqRUrf6xQgyGA
Date:   Mon, 3 Jan 2022 00:37:56 +0000
Message-ID: <54275E65-DD0B-4E5C-96B6-F23E707238AF@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-5-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a4eabdf-6c86-4654-0dd3-08d9ce51496b
x-ms-traffictypediagnostic: SA2PR10MB4537:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4537ED5CC2D31FE98553F1B3E6499@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RC5DvZ6dNIge4EC9P86uyEVAcy52Ay+AQj/DdQaluPUswdCCLIYG9nwG3dpBjDfc+Cry7+5hHcg+HlueKI8cs+gy6L5WNIvYmy75lTDA/ioTQmpLavbmc3b/GqX+XRrkWyJ17orYqihuXpgLYu+ZRi2ApzI9UOXqIJiGUBb2KYquTR6VlSbFM9+bPEvChkxqU64fsNvqNtWKauz8iZMgmjHqCxd/NJHVYkqGYAdi1QJxIky8O7DZsPEOqX1CAqzsMq2zQOM1tSxf9W3+KcZyfIKIarSIix410UXNMHrBcNVzvIU6/ZMMhR9NdAplAFtNnJaFBs9u1Vm2xZchGCEDeA6PKNitBtl80xMSzHv3bFnNBJ+nHNitYz5D3e21PvMgElby3/qBh4lWHEXmJ+EGTQ2jcU/HsDBeZAexUU+faMWxGTRHpr12hkPuttWA0jhVHXtZJRMga0PUeolS6GL8gccSRwqgVy5oHgCk64VaGXD1d395hnSlUXyG73FaXw1ltUnfyRmhP4/Z2BPSZYPIBfO7Go+JeOsRdp0BpqSmoFlqrKDLcIxAtb2GyZdlyu3Dr+BK/Eazf9irICJH0p/uYUCcSCyB36N4JbcnQb5gIEKLxiNeVbdq0cGc6/UXWBhc4UdiFzBdLWsMi1hlMbiG4DiXSW440mh+0PmPVdP9WqqVigG8dvjZ6yQyAkxwr3VnKiJK41mkCoU2KCeypcBTB/umQM6XVNHRfkaPShuntlQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(8936002)(6916009)(66946007)(2906002)(76116006)(6486002)(86362001)(36756003)(83380400001)(26005)(508600001)(316002)(33656002)(4326008)(71200400001)(38100700002)(186003)(122000001)(54906003)(8676002)(15650500001)(44832011)(6506007)(2616005)(6512007)(53546011)(5660300002)(64756008)(66446008)(66556008)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?is+umo33K7NzYnBtAWjmhRShFIu/nnEPTydo6RyIoykKPCvXwg7oBWoiYrAB?=
 =?us-ascii?Q?YKdFfVH2bCPgEXoE3A+ozyPOdFF+h+ILEb2zKDErbMLcMNExCVfUPTOnOd12?=
 =?us-ascii?Q?tPNM7ME1o6WMwujVAKi+ENiLmGDL9bwHsba+LBZDBinKErF3ao6fqRjZuS9p?=
 =?us-ascii?Q?8+SP9hIpkP4jABp3Btp6YSaOI65SrphEYtgiNSvQIBBtbm3WLJpILKmWsir1?=
 =?us-ascii?Q?ZKZPRpKMMLV6VjoahyQv/8oiYG/w9O0yfNjQCIKfdzoe5yVtXwgyzQrWgj7e?=
 =?us-ascii?Q?8lucPXPxvDq8jjn76i3QtmgO0GDp/cclbBho15PO09LDJooqZmKlxwGrGbkL?=
 =?us-ascii?Q?39eHlmkM7+1wOxAH7s3f97zM6OgPNmgujkt2XUqYLLcrEIlbPOleSbYcPl89?=
 =?us-ascii?Q?Jrrwd/DO9sWkzuGE12Tpn6w10TUjLfkYpY9P+yRo6CIYiT5vunRkApxZanL0?=
 =?us-ascii?Q?76hMTBxEcnk6j1FszxSqdcZ1P98XEkOwGPnUOMoMc89xIsFiz6DEq8R1asyM?=
 =?us-ascii?Q?s1lsl5KQ1XYcqWgbuwTuzCNOv8eu2m+85ACS5bW0ZhoaDY9ThT1DlOJyXN/y?=
 =?us-ascii?Q?M5ieUFdHx4Oy3uCp0y9uuQ9ToJp8xWK2QikMy0bY0f//+i2ysjVCu6z/2iDE?=
 =?us-ascii?Q?x/LD7mul9GEl3zg93Qu74j4lil8kLgwnoJDWDLXlaHrEXLZv3g70E4sl6WcD?=
 =?us-ascii?Q?ffwDSYLMhmqP/l/0OWTlzXIcu4Caicdv9hf08sDqMpJMWgDyd4ELPJj61Fcy?=
 =?us-ascii?Q?kaLPxQszaNCyxKEij0L4G1FllBG6EuOVfp6U9h/W+CT8P1Z00m4Xzmj4m63C?=
 =?us-ascii?Q?Z3AAbohgDRwLujWeA2OUVKoWkWmgVlLQdUGPTYI70bwwgwK7VPhWVfqajXwg?=
 =?us-ascii?Q?TD8qqa9ziCqUEO5T/T1T0BTTcIcsxrZYrxnOVwJB8bIBIFv26B0zZsrhNDuq?=
 =?us-ascii?Q?rjSKd6puoXYGFtUEmxnXczsspuIoQZUN5acjw6dC4mONkvJ+VYPQvJe29UwX?=
 =?us-ascii?Q?eQz/wmHZK6Pjg8yKi2SH5lQjt/vFzbcR9BLEeqmE/jVW3na4FMpLp3MTNDQE?=
 =?us-ascii?Q?4sLkUMx98OBiln762oG0vho8HB5UtbdCnSLlDfpox8l6Zo0P8I2ZSC30LcAX?=
 =?us-ascii?Q?8NtoyXWu3ptNQ70WjSjMVOSG9io/zxqIhx+AJHm2l2PCnWSW/I1hyYryg9f8?=
 =?us-ascii?Q?ZfzIf0m++mHqVRytNpoHuE/rN7t+PASy0o0snuTda0rPXN173ViLYqAomSsS?=
 =?us-ascii?Q?mEg6FGHb3yv77cfSYDIVCav8KuA7vNmk6WhXP46qme6myv9dzn0yT8B8cKV/?=
 =?us-ascii?Q?g1YqlF8GLEp5W/WdncdJt1Y+aU4JI8JvIN+B2CM7p2AZwtFUKSAyxEJ1WUMo?=
 =?us-ascii?Q?jeKNk2cB2COIEL6HPTfEBsyYtusGPjLNiQjctelTXOilbB2v6okZW0JDue9E?=
 =?us-ascii?Q?QvRuBu0M3zHsGlIXPsQKRDJM0Gy8v8YebROxpzP1BrsGRDCQCQMw/AWsqt+g?=
 =?us-ascii?Q?VFc9sJte0BopSOXlmz32NmMjTlGKOCeIMCInfdfu9Vnsz/PpYZLpjrF2sqpB?=
 =?us-ascii?Q?GhJbzjs4oERy9eNpNbZbgVc1Wt29+kKf46fMz+3xT1Z4jOKM15zzMqAUbgTC?=
 =?us-ascii?Q?XTVTwa2N19H77HjKJGqc4mpWchf9BaUo6lqF/le1WmmnTlvbghIdVW0Ohx3E?=
 =?us-ascii?Q?hagttap27GtvuN35/KKyYnq9lOM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85AE6FDA4B1C594BB76FE5B1E7ABED07@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4eabdf-6c86-4654-0dd3-08d9ce51496b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:37:56.8592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbZx88dB7C5NLtijFdKRpk7mmxHdMyuwYetDcpc6A5X162+52JjMovcFjx8I25U88UxCbftCABGk1KSt+pBj0d9XPr2NVpL5f059UHDU7bE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030003
X-Proofpoint-ORIG-GUID: 4_yqnQymzoRGoWVmirTZSP7713il2ojP
X-Proofpoint-GUID: 4_yqnQymzoRGoWVmirTZSP7713il2ojP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Fix warning message due to adisc is being flush.
> Linux kernel triggered a warning message where a different
> error code type is not matching up with the expected type. This
> patch adds additional translation of one error code type to another.
>=20
> WARNING: CPU: 2 PID: 1131623 at drivers/scsi/qla2xxx/qla_init.c:498
> qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
> CPU: 2 PID: 1131623 Comm: drmgr Not tainted 5.13.0-rc1-autotest #1
> ..
> GPR28: c000000aaa9c8890 c0080000079ab678 c00000140a104800 c00000002bd1900=
0
> NIP [c00800000790857c] qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
> LR [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx]
> Call Trace:
> [c00000001cdc3620] [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0=
x2b0 [qla2xxx] (unreliable)
> [c00000001cdc3710] [c0080000078f3080] __qla2x00_abort_all_cmds+0x1b8/0x58=
0 [qla2xxx]
> [c00000001cdc3840] [c0080000078f589c] qla2x00_abort_all_cmds+0x34/0xd0 [q=
la2xxx]
> [c00000001cdc3880] [c0080000079153d8] qla2x00_abort_isp_cleanup+0x3f0/0x5=
70 [qla2xxx]
> [c00000001cdc3920] [c0080000078fb7e8] qla2x00_remove_one+0x3d0/0x480 [qla=
2xxx]
> [c00000001cdc39b0] [c00000000071c274] pci_device_remove+0x64/0x120
> [c00000001cdc39f0] [c0000000007fb818] device_release_driver_internal+0x16=
8/0x2a0
> [c00000001cdc3a30] [c00000000070e304] pci_stop_bus_device+0xb4/0x100
> [c00000001cdc3a70] [c00000000070e4f0] pci_stop_and_remove_bus_device+0x20=
/0x40
> [c00000001cdc3aa0] [c000000000073940] pci_hp_remove_devices+0x90/0x130
> [c00000001cdc3b30] [c0080000070704d0] disable_slot+0x38/0x90 [rpaphp] [
> c00000001cdc3b60] [c00000000073eb4c] power_write_file+0xcc/0x180
> [c00000001cdc3be0] [c0000000007354bc] pci_slot_attr_store+0x3c/0x60
> [c00000001cdc3c00] [c00000000055f820] sysfs_kf_write+0x60/0x80 [c00000001=
cdc3c20]
> [c00000000055df10] kernfs_fop_write_iter+0x1a0/0x290
> [c00000001cdc3c70] [c000000000447c4c] new_sync_write+0x14c/0x1d0
> [c00000001cdc3d10] [c00000000044b134] vfs_write+0x224/0x330
> [c00000001cdc3d60] [c00000000044b3f4] ksys_write+0x74/0x130
> [c00000001cdc3db0] [c00000000002df70] system_call_exception+0x150/0x2d0
> [c00000001cdc3e10] [c00000000000d45c] system_call_common+0xec/0x278
>=20
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 0b641a803f7c..e54c31296fab 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -295,6 +295,8 @@ static void qla2x00_async_login_sp_done(srb_t *sp, in=
t res)
> 		ea.iop[0] =3D lio->u.logio.iop[0];
> 		ea.iop[1] =3D lio->u.logio.iop[1];
> 		ea.sp =3D sp;
> +		if (res)
> +			ea.data[0] =3D MBS_COMMAND_ERROR;
> 		qla24xx_handle_plogi_done_event(vha, &ea);
> 	}
>=20
> @@ -557,6 +559,8 @@ static void qla2x00_async_adisc_sp_done(srb_t *sp, in=
t res)
> 	ea.iop[1] =3D lio->u.logio.iop[1];
> 	ea.fcport =3D sp->fcport;
> 	ea.sp =3D sp;
> +	if (res)
> +		ea.data[0] =3D MBS_COMMAND_ERROR;
>=20
> 	qla24xx_handle_adisc_event(vha, &ea);
> 	/* ref: INIT */
> @@ -1237,6 +1241,8 @@ static void qla2x00_async_prli_sp_done(srb_t *sp, i=
nt res)
> 		ea.sp =3D sp;
> 		if (res =3D=3D QLA_OS_TIMER_EXPIRED)
> 			ea.data[0] =3D QLA_OS_TIMER_EXPIRED;
> +		else if (res)
> +			ea.data[0] =3D MBS_COMMAND_ERROR;
>=20
> 		qla24xx_handle_prli_done_event(vha, &ea);
> 	}
> --=20
> 2.23.1
>=20
Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

