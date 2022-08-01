Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C5CC00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 19:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiHATMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 15:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiHATLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 15:11:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12B14504C
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 12:07:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271Hs4Nk011773;
        Mon, 1 Aug 2022 19:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yVBozlPunI23kJa03cbGJvJWowM6ccoyGepDHvveIKs=;
 b=P7Vid9M05e6NgmrpHeUV5k+0BJ1wSSB24Z1mjS640MoOIecO06o3AOZTC8sl5xjO07nj
 iIHUtzypYseW8Le2C9QiHy7WLQOIlQZSQ5Xg/f0Rv4yiWIQ0qyKi01pqlRgR23Zw+OoD
 cKwSCdtwnGSpHa1OQViaPe/qIaSi75Ld/3hVG8tLeSDiOdJxHoUjID6D0njvS8YWwqrI
 zk/vQq3ShhYwYrlINnQ+0kXW6x0NRhB9nP9EwOcmAKQVaAjxM7hOLJXsstDdbbzvPapI
 +gLVrqRfu/riEBiKTAfizkCfhW88BJM6F+ENSTKd0k4lP+VR74bpZ3VlgFHWbgWJt9GI HA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8s4mxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 19:07:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271IUvf2010772;
        Mon, 1 Aug 2022 19:07:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31j1nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 19:07:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgePmL7KiVM5NHAeR9m/fqzWM4z93Hdtp9j11/pfr3nyiSzRv7M5GFDhJNQLvE1TZhfTOXtLCjaRlTSVy0vCFeI4+XUt6O2p8yeSZJAM0kbo6JCFiN0LTn6qzTdWmAzQb9eOtaiWBg6lrmztgZ2o8K28lPseAL39CXI+5N4DPzk3e6coS8uFM5Xu7obEwhb2EoPl3ADu2KRr7RolLHI9P+vep6cKoet5QGmQRJp9ol6yhYbmgmg5TWCFsVUUPhE8k/GqmwdqP4iRqDhoBm9VxKn2LjN5gwsBnJXt4EwAHA6siuhjMpraZEFmn6ElBsTO2kgaJEDfJD6/8zjzV+3eyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVBozlPunI23kJa03cbGJvJWowM6ccoyGepDHvveIKs=;
 b=EDBrTA2WxmWNlzLR+Ev3bSo9AMtm5RvBFzTr8hVNlbbIq2aXkdr//ogm323ab3LREjFu3XF1YLWoUBLBl/TeNf8huuBh00xXzDA+3IZNuV4ip6cFnXcG/L8IX1RzEOSJFXRiVHU/ySVU3ZGFLpqyeekHoWt9mjK+Elmd2mI4x31cQdFQrsQjCclKnkj5La8n5ytCDhb4mJj61NSO9E0eTrdyWKY33S3SITD/Qnio1XAR+g4qouWLwAJfFBxkYwmcdi1Fjcsjy/Wb6GvQBvXgz6Y6unsHTQ7Nxy4nZhHBVyp6XPSyBtiJ6bvgCO5Lp+j1y+IxS0GpdxIXau/cNHs4wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVBozlPunI23kJa03cbGJvJWowM6ccoyGepDHvveIKs=;
 b=M2DBvLIW3jWS62HvJrOgZ979HMjMwTf47nQmcO9Ty2LnkVCjTfa9kIJlHHy4Qspu4zEcaVHjyGnVr+Vc3CWIAW2K6K9UewZwIk21Mp92HVCYWLC4PrYcmM3Qq7g+Z71W8jaWRw2kOxfvvauNdTeMRmliJ1AW2ofWLHu2yB1X7Xg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB3013.namprd10.prod.outlook.com (2603:10b6:a03:8f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 19:07:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 19:07:10 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/15] mpi3mr: Add helper functions to manage device's
 port
Thread-Topic: [PATCH 07/15] mpi3mr: Add helper functions to manage device's
 port
Thread-Index: AQHYo0v9CkQqoZvoCkSM/ZXSMysBYq2abTOA
Date:   Mon, 1 Aug 2022 19:07:10 +0000
Message-ID: <8F938CFF-31CF-4892-90AA-B1F3301E0135@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-8-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-8-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e6b6b0f-86fe-4658-4b26-08da73f10969
x-ms-traffictypediagnostic: BYAPR10MB3013:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3bXrxkMnmunCjzopYNOnv9KjxXWedClE5dYePvLJNvVxcMvEDjUVmxzAnC/95V0CSwV7K2/cTRAdt65kTG76ppdvCiOjiexXSHQWloRNakyfEpUkopt3BOY03TXas53q5BBxXYQTj5UhXW/cuk/P8iEMo8sxlENkxykliHd7W3n+xCVpOk2hiyhlhzkQutkI3phBoRfzp7ceLSye3ZdGP1BnplaOlHbdPgQCaDifZbwHJjXUZd/FCA+T6NJ8ZYNtQ6+gsbon49uCyngxw58rsQHszXpFEP8JnlJ75oHlwrz0ldVIPGsAduIjs0grA/Ecngu64BgopnROS5zEkFIgWtk8BIOPVPowfzmkj+t4TasKwsK1V0lp3Q3YtK2Rb7dOSkzQY1rlch4ln1rD/20nro31m6ftzw6k/D4RjNbtQ9Rq3LBGfDuUGmttFBGm3J1q0PHHowkrhE6MX33mcfl2ak6eplbMK9G61n6vEjYsK44NxdPemgzmKOoVIf2CKdGnDihDYxgwI38i/KBVPW35pmUpaLIsPPaS20uZ+ciTMREvwfbJn+0nktghKS3b1cCgKGeNE+ffS7kNn4TZ5HHzBkGYP6F3sAeztaMrVHX5IlR4J5Aq7hYeTolhtZYGct5JKi4jkNCaEH4CnkPPNcOqdjXcTbKMsb6nmH6UuaYIOHZQXdT96Xyr4NXadC8b79W0Nb5pHVRFyPmuzCZbwolOLMLo+yv51CFUGJ4e0K7jM7j7/lrf7Efw++t6WApoRFR3Ga6078+/7/2Dh9GGSW0RW25D1PtVNBCFRvXTARdbJltVnvZK1kNN9Kd2PA/ibUphsgm5hnyYp4uG1qm2pSM4QEPWNQH1/4NSWN4TtuESKUk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(39860400002)(366004)(376002)(346002)(6486002)(36756003)(38070700005)(44832011)(33656002)(478600001)(30864003)(38100700002)(6506007)(41300700001)(2906002)(6916009)(54906003)(316002)(6512007)(64756008)(91956017)(76116006)(186003)(107886003)(8676002)(2616005)(26005)(5660300002)(66476007)(8936002)(122000001)(66556008)(66946007)(4326008)(66446008)(71200400001)(83380400001)(53546011)(86362001)(32563001)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DsDHrK80dpyRBbwSWz8YgrELg/o2qH/bQL3Tr4b5VIFoVPbz0F/kqjVPznu5?=
 =?us-ascii?Q?hsYol/RRxciF2icJ9vBMq4WuO198J7P4q8YFXIpuRX0kVPYe8ckNz0sVtFP9?=
 =?us-ascii?Q?6eZH4/Zkc508lAYPcrvLH3Q5j7O1Upjah0VFt6cd0hjfdHgZUTDal5tOghCZ?=
 =?us-ascii?Q?qcKnimh+opsD5agg0Uji06ePqDpt/CMCBoSE2KEjGvHY3Gf/pKYPMeFHJUj+?=
 =?us-ascii?Q?KOftt4xOEaBTZOgeIoUeDHC6DMGapbPa8fCDfpFNJ8VqKA70g+hfnzhq/5lD?=
 =?us-ascii?Q?9Vj0dLFhlwx6sLNk1ygqCydfSwJ6/AbhtOyN5fERRbZKPU5xwMkRDYkSQHTe?=
 =?us-ascii?Q?I64jIgxTJofVMIrat3vs9wtHUYXy29Esp4+wbL1OwPzqJmBof4vGMCSfIX+L?=
 =?us-ascii?Q?Mn8EEA+dZNhJvC25+fFvIAzx0PobfsCg/oGRIZWdJp/QPWIC6ZmCUZW4GBiu?=
 =?us-ascii?Q?comnu16f7lChfvMpqdxf42+ORVEEYhHyA3RVtat2XBqxC8T/S/drtOYAKAGa?=
 =?us-ascii?Q?T+ZBUUvBaHAiyAIIKWDU/5oTdSVCNEjKFn/7CucaL53Q025oXy3GtR8H+2KY?=
 =?us-ascii?Q?q7ixCqRC6Z/3PR8UD/vbzAwRCcqc+USLQmhtQ3hFxOs40Vaqfff1nlKZK1XA?=
 =?us-ascii?Q?3extlgxRuB75c1ECJWu2Z/2I6yc0nSXFPIcsviqOSDLPZ/TYwFXq8xSGNkVu?=
 =?us-ascii?Q?/nMpr0koRj6DYoxmqQbsos6NmWM/Z4raKiRtV+ddT36W6nA6/qrcsZYF/86q?=
 =?us-ascii?Q?MonfhjvyDjIraxSts+OK+b4AxJTtkcojg9ClKbmH768OdMVsQZmIJoh3+JkY?=
 =?us-ascii?Q?nOFrsmFrb9cigPF/FegrbFp4ynRZnPyv0BNQouLMbOsu8A+xIl0t2iLPyj2z?=
 =?us-ascii?Q?PwdP9iN6JEqWx6bLvGtSvfVWnTjI6TtRVskd6SO76SUXremiDkTpcbp/f2wy?=
 =?us-ascii?Q?qr/eDLgzySJ9TTICJtJFmqIqo5gPMoUtSUfOn2GI0X0XdHS31pDSIKGjP1c5?=
 =?us-ascii?Q?JBozYCzxbFKTDkjWltLR3636tj5uXv+kb6n3dQGhIctdeO/C9nN+lvSI1j0f?=
 =?us-ascii?Q?oRcGZkqMQIyqd5UTx7IWfL7VfpZnqPy6I/jSbVc3LMyg8bGLKCKkYP+6UnxU?=
 =?us-ascii?Q?4/AbaIfZz57Jok2ECt6HIohJI9+8B5NP2jxclz1wJxzu769JkD4XBjJr559G?=
 =?us-ascii?Q?SL7zbBfbYl7+QfU6Ttcb8Qh7rURsu5r1WnxJVyFGRj7fQERyEbvshDaPhCE1?=
 =?us-ascii?Q?FkoAI9yUBIL3mCGFZFNKFyJKovvXlSjInrpQ8yUpdAGAfHGzxUMMaYPBtnYd?=
 =?us-ascii?Q?wpBaMWqEosBHM8QFG4tjnZM69Ae/dQFRQqmtaF6vwMT55SnGg+GTR45Eovhh?=
 =?us-ascii?Q?oSdQSOsgFbQLK/+110WhjpzKDlGJQNqw7rBwEsTgT+fmYr4O+JtXddleKqUv?=
 =?us-ascii?Q?v6QPXOJjL6nxM0diUOtXe6detI2hhAo/Wb0G138X7S1OxYf5aVlMBBJFMzi+?=
 =?us-ascii?Q?JUhKyy90tJECFgJkCvW8V5zfv1UUJOUp/CPzCGmKK7wOXumFe8EpoHS4VBwr?=
 =?us-ascii?Q?hkNIxr8takCSAS4DrGOTIZXG1v9sBAZ+89IXzDAxHpONflyqsxYXyYw6aaHz?=
 =?us-ascii?Q?Og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C37A44615D1FB742B5123ECA1BFD976D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6b6b0f-86fe-4658-4b26-08da73f10969
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 19:07:10.8085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L36B2Yv1qUYvcGJRr7nNgSSpGf8Am0gE7Nl1jW6bsEZKzQI+Izru/1lrVLrEUgl+qNk0AEpT22Clm8s5agzvglV7JK6oQCQDeeBFmM3NTYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3013
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_08,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010095
X-Proofpoint-GUID: -FLsFooCjF-i6UuS4XhIOPNEBphGGR05
X-Proofpoint-ORIG-GUID: -FLsFooCjF-i6UuS4XhIOPNEBphGGR05
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added below helper functions,
> - Add, update the host phys with STL
> - Add, remove the device's sas port with STL
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |  13 +
> drivers/scsi/mpi3mr/mpi3mr_os.c        |   2 +-
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 527 +++++++++++++++++++++++++
> 3 files changed, 541 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 742caf5..8ab843a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -570,12 +570,18 @@ struct mpi3mr_enclosure_node {
>  *
>  * @sas_address: World wide unique SAS address
>  * @dev_info: Device information bits
> + * @sas_transport_attached: Is this device exposed to transport
> + * @pend_sas_rphy_add: Flag to check device is in process of add
>  * @hba_port: HBA port entry
> + * @rphy: SAS transport layer rphy object
>  */
> struct tgt_dev_sas_sata {
> 	u64 sas_address;
> 	u16 dev_info;
> +	u8 sas_transport_attached;
> +	u8 pend_sas_rphy_add;
> 	struct mpi3mr_hba_port *hba_port;
> +	struct sas_rphy *rphy;
> };
>=20
> /**
> @@ -1331,4 +1337,11 @@ int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *m=
rioc,
> u8 mpi3mr_is_expander_device(u16 device_info);
> struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrio=
c,
> 	u8 port_id);
> +void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc);
> +void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc);
> +void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
> +	u64 sas_address_parent, u16 handle, u8 phy_number, u8 link_rate,
> +	struct mpi3mr_hba_port *hba_port);
> +void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
> +	bool device_add);
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index b75ce73..905b434 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -804,7 +804,7 @@ static void mpi3mr_set_io_divert_for_all_vd_in_tg(str=
uct mpi3mr_ioc *mrioc,
>  *
>  * Return: None.
>  */
> -static void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
> +void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
> 	bool device_add)
> {
> 	ioc_notice(mrioc, "Device %s was in progress before the reset and\n",
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index fea3aae..b85d60f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -708,3 +708,530 @@ struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(s=
truct mpi3mr_ioc *mrioc,
>=20
> 	return NULL;
> }
> +
> +/**
> + * mpi3mr_update_links - refreshing SAS phy link changes
> + * @mrioc: Adapter instance reference
> + * @sas_address_parent: SAS address of parent expander or host
> + * @handle: Firmware device handle of attached device
> + * @phy_number: Phy number
> + * @link_rate: New link rate
> + * @hba_port: HBA port entry
> + *
> + * Return: None.
> + */
> +void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
> +	u64 sas_address_parent, u16 handle, u8 phy_number, u8 link_rate,
> +	struct mpi3mr_hba_port *hba_port)
> +{
> +	unsigned long flags;
> +	struct mpi3mr_sas_node *mr_sas_node;
> +	struct mpi3mr_sas_phy *mr_sas_phy;
> +
> +	if (mrioc->reset_in_progress)
> +		return;
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	mr_sas_node =3D __mpi3mr_sas_node_find_by_sas_address(mrioc,
> +	    sas_address_parent, hba_port);
> +	if (!mr_sas_node) {
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +		return;
> +	}
> +
> +	mr_sas_phy =3D &mr_sas_node->phy[phy_number];
> +	mr_sas_phy->attached_handle =3D handle;
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +	if (handle && (link_rate >=3D MPI3_SAS_NEG_LINK_RATE_1_5)) {
> +		mpi3mr_set_identify(mrioc, handle,
> +		    &mr_sas_phy->remote_identify);
> +		mpi3mr_add_phy_to_an_existing_port(mrioc, mr_sas_node,
> +		    mr_sas_phy, mr_sas_phy->remote_identify.sas_address,
> +		    hba_port);
> +	} else
> +		memset(&mr_sas_phy->remote_identify, 0, sizeof(struct
> +		    sas_identify));
> +
> +	if (mr_sas_phy->phy)
> +		mr_sas_phy->phy->negotiated_linkrate =3D
> +		    mpi3mr_convert_phy_link_rate(link_rate);
> +
> +	if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
> +		dev_info(&mr_sas_phy->phy->dev,
> +		    "refresh: parent sas_address(0x%016llx),\n"
> +		    "\tlink_rate(0x%02x), phy(%d)\n"
> +		    "\tattached_handle(0x%04x), sas_address(0x%016llx)\n",
> +		    (unsigned long long)sas_address_parent,
> +		    link_rate, phy_number, handle, (unsigned long long)
> +		    mr_sas_phy->remote_identify.sas_address);
> +}
> +
> +/**
> + * mpi3mr_sas_host_refresh - refreshing sas host object contents
> + * @mrioc: Adapter instance reference
> + *
> + * This function refreshes the controllers phy information and
> + * updates the SAS transport layer with updated information,
> + * this is executed for each device addition or device info
> + * change events
> + *
> + * Return: None.
> + */
> +void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc)
> +{
> +	int i;
> +	u8 link_rate;
> +	u16 sz, port_id, attached_handle;
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 =3D NULL;
> +
> +	dprint_transport_info(mrioc,
> +	    "updating handles for sas_host(0x%016llx)\n",
> +	    (unsigned long long)mrioc->sas_hba.sas_address);
> +
> +	sz =3D offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
> +	    (mrioc->sas_hba.num_phys *
> +	     sizeof(struct mpi3_sas_io_unit0_phy_data));
> +	sas_io_unit_pg0 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg0)
> +		return;
> +	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out;
> +	}
> +
> +	mrioc->sas_hba.handle =3D 0;
> +	for (i =3D 0; i < mrioc->sas_hba.num_phys; i++) {
> +		if (sas_io_unit_pg0->phy_data[i].phy_flags &
> +		    (MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
> +		     MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
> +			continue;
> +		link_rate =3D
> +		    sas_io_unit_pg0->phy_data[i].negotiated_link_rate >> 4;
> +		if (!mrioc->sas_hba.handle)
> +			mrioc->sas_hba.handle =3D le16_to_cpu(
> +			    sas_io_unit_pg0->phy_data[i].controller_dev_handle);
> +		port_id =3D sas_io_unit_pg0->phy_data[i].io_unit_port;
> +		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
> +			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
> +				goto out;
> +
> +		mrioc->sas_hba.phy[i].handle =3D mrioc->sas_hba.handle;
> +		attached_handle =3D le16_to_cpu(
> +		    sas_io_unit_pg0->phy_data[i].attached_dev_handle);
> +		if (attached_handle && link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
> +			link_rate =3D MPI3_SAS_NEG_LINK_RATE_1_5;
> +		mrioc->sas_hba.phy[i].hba_port =3D
> +			mpi3mr_get_hba_port_by_id(mrioc, port_id);
> +		mpi3mr_update_links(mrioc, mrioc->sas_hba.sas_address,
> +		    attached_handle, i, link_rate,
> +		    mrioc->sas_hba.phy[i].hba_port);
> +	}
> + out:
> +	kfree(sas_io_unit_pg0);
> +}
> +
> +/**
> + * mpi3mr_sas_host_add - create sas host object
> + * @mrioc: Adapter instance reference
> + *
> + * This function creates the controllers phy information and
> + * updates the SAS transport layer with updated information,
> + * this is executed for first device addition or device info
> + * change event.
> + *
> + * Return: None.
> + */
> +void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
> +{
> +	int i;
> +	u16 sz, num_phys =3D 1, port_id, ioc_status;
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 =3D NULL;
> +	struct mpi3_sas_phy_page0 phy_pg0;
> +	struct mpi3_device_page0 dev_pg0;
> +	struct mpi3_enclosure_page0 encl_pg0;
> +	struct mpi3_device0_sas_sata_format *sasinf;
> +
> +

remove extra newline

> +	sz =3D offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
> +	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
> +	sas_io_unit_pg0 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg0)
> +		return;
> +
> +	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out;
> +	}
> +	num_phys =3D sas_io_unit_pg0->num_phys;
> +	kfree(sas_io_unit_pg0);
> +
> +	mrioc->sas_hba.host_node =3D 1;
> +	INIT_LIST_HEAD(&mrioc->sas_hba.sas_port_list);
> +	mrioc->sas_hba.parent_dev =3D &mrioc->shost->shost_gendev;
> +	mrioc->sas_hba.phy =3D kcalloc(num_phys,
> +	    sizeof(struct mpi3mr_sas_phy), GFP_KERNEL);
> +	if (!mrioc->sas_hba.phy)
> +		return;
> +
> +	mrioc->sas_hba.num_phys =3D num_phys;
> +
> +	sz =3D offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
> +	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
> +	sas_io_unit_pg0 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg0)
> +		return;
> +
> +	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out;
> +	}
> +
> +	mrioc->sas_hba.handle =3D 0;
> +	for (i =3D 0; i < mrioc->sas_hba.num_phys; i++) {
> +		if (sas_io_unit_pg0->phy_data[i].phy_flags &
> +		    (MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
> +		    MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
> +			continue;
> +		if (mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
> +		    sizeof(struct mpi3_sas_phy_page0),
> +		    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, i)) {
> +			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +			    __FILE__, __LINE__, __func__);
> +			goto out;
> +		}
> +		if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +			    __FILE__, __LINE__, __func__);
> +			goto out;
> +		}
> +
> +		if (!mrioc->sas_hba.handle)
> +			mrioc->sas_hba.handle =3D le16_to_cpu(
> +			    sas_io_unit_pg0->phy_data[i].controller_dev_handle);
> +		port_id =3D sas_io_unit_pg0->phy_data[i].io_unit_port;
> +
> +		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
> +			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
> +				goto out;
> +
> +		mrioc->sas_hba.phy[i].handle =3D mrioc->sas_hba.handle;
> +		mrioc->sas_hba.phy[i].phy_id =3D i;
> +		mrioc->sas_hba.phy[i].hba_port =3D
> +		    mpi3mr_get_hba_port_by_id(mrioc, port_id);
> +		mpi3mr_add_host_phy(mrioc, &mrioc->sas_hba.phy[i],
> +		    phy_pg0, mrioc->sas_hba.parent_dev);
> +	}
> +	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
> +	    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
> +	    mrioc->sas_hba.handle))) {
> +		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
> +		goto out;
> +	}
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_s=
tatus(0x%04x) failure at %s:%d/%s()!\n",
> +		    mrioc->sas_hba.handle, ioc_status, __FILE__, __LINE__,
> +		    __func__);
> +		goto out;
> +	}
> +	mrioc->sas_hba.enclosure_handle =3D
> +	    le16_to_cpu(dev_pg0.enclosure_handle);
> +	sasinf =3D &dev_pg0.device_specific.sas_sata_format;
> +	mrioc->sas_hba.sas_address =3D
> +	    le64_to_cpu(sasinf->sas_address);
> +	ioc_info(mrioc,
> +	    "host_add: handle(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
> +	    mrioc->sas_hba.handle,
> +	    (unsigned long long) mrioc->sas_hba.sas_address,
> +	    mrioc->sas_hba.num_phys);
> +
> +	if (mrioc->sas_hba.enclosure_handle) {
> +		if (!(mpi3mr_cfg_get_enclosure_pg0(mrioc, &ioc_status,
> +		    &encl_pg0, sizeof(dev_pg0),
> +		    MPI3_ENCLOS_PGAD_FORM_HANDLE,
> +		    mrioc->sas_hba.enclosure_handle)) &&
> +		    (ioc_status =3D=3D MPI3_IOCSTATUS_SUCCESS))
> +			mrioc->sas_hba.enclosure_logical_id =3D
> +				le64_to_cpu(encl_pg0.enclosure_logical_id);
> +	}
> +
> +out:
> +	kfree(sas_io_unit_pg0);
> +}
> +
> +/**
> + * mpi3mr_sas_port_add - Expose the SAS device to the SAS TL
> + * @mrioc: Adapter instance reference
> + * @handle: Firmware device handle of the attached device
> + * @sas_address_parent: sas address of parent expander or host
> + * @hba_port: HBA port entry
> + *
> + * This function creates a new sas port object for the given end
> + * device matching sas address and hba_port and adds it to the
> + * sas_node's sas_port_list and expose the attached sas device
> + * to the SAS transport layer through sas_rphy_add.
> + *
> + * Returns a valid mpi3mr_sas_port reference or NULL.
> + */
> +static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mr=
ioc,
> +	u16 handle, u64 sas_address_parent, struct mpi3mr_hba_port *hba_port)
> +{
> +

remove newline

> +	struct mpi3mr_sas_phy *mr_sas_phy, *next;
> +	struct mpi3mr_sas_port *mr_sas_port;
> +	unsigned long flags;
> +	struct mpi3mr_sas_node *mr_sas_node;
> +	struct sas_rphy *rphy;
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	int i;
> +	struct sas_port *port;

> +
> +	if (!hba_port) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return NULL;
> +	}
> +
> +	mr_sas_port =3D kzalloc(sizeof(struct mpi3mr_sas_port), GFP_KERNEL);
> +	if (!mr_sas_port)
> +		return NULL;
> +
> +	INIT_LIST_HEAD(&mr_sas_port->port_list);
> +	INIT_LIST_HEAD(&mr_sas_port->phy_list);
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	mr_sas_node =3D __mpi3mr_sas_node_find_by_sas_address(mrioc,
> +	    sas_address_parent, hba_port);
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +	if (!mr_sas_node) {
> +		ioc_err(mrioc, "%s:could not find parent sas_address(0x%016llx)!\n",
> +		    __func__, (unsigned long long)sas_address_parent);
> +		goto out_fail;
> +	}
> +
> +	if ((mpi3mr_set_identify(mrioc, handle,
> +	    &mr_sas_port->remote_identify))) {
> +		ioc_err(mrioc,  "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;
> +	}
> +
> +	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_PHY_UNUSED) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;
> +	}
> +
> +	mr_sas_port->hba_port =3D hba_port;
> +	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
> +	    mr_sas_port->remote_identify.sas_address, hba_port);
> +
> +	for (i =3D 0; i < mr_sas_node->num_phys; i++) {
> +		if ((mr_sas_node->phy[i].remote_identify.sas_address !=3D
> +		    mr_sas_port->remote_identify.sas_address) ||
> +		    (mr_sas_node->phy[i].hba_port !=3D hba_port))
> +			continue;
> +		list_add_tail(&mr_sas_node->phy[i].port_siblings,
> +		    &mr_sas_port->phy_list);
> +		mr_sas_port->num_phys++;
> +	}
> +
> +	if (!mr_sas_port->num_phys) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;
> +	}
> +
> +	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
> +		tgtdev =3D mpi3mr_get_tgtdev_by_addr(mrioc,
> +		    mr_sas_port->remote_identify.sas_address,
> +		    mr_sas_port->hba_port);
> +
> +		if (!tgtdev) {
> +			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +			    __FILE__, __LINE__, __func__);
> +			goto out_fail;
> +		}
> +		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 1;
> +	}
> +
> +	if (!mr_sas_node->parent_dev) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;
> +	}
> +
> +	port =3D sas_port_alloc_num(mr_sas_node->parent_dev);
> +	if ((sas_port_add(port))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;
> +	}
> +
> +	list_for_each_entry(mr_sas_phy, &mr_sas_port->phy_list,
> +	    port_siblings) {
> +		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
> +			dev_info(&port->dev,
> +			    "add: handle(0x%04x), sas_address(0x%016llx), phy(%d)\n",
> +			    handle, (unsigned long long)
> +			    mr_sas_port->remote_identify.sas_address,
> +			    mr_sas_phy->phy_id);
> +		sas_port_add_phy(port, mr_sas_phy->phy);
> +		mr_sas_phy->phy_belongs_to_port =3D 1;
> +		mr_sas_phy->hba_port =3D hba_port;
> +	}
> +
> +	mr_sas_port->port =3D port;
> +	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
> +		rphy =3D sas_end_device_alloc(port);
> +		tgtdev->dev_spec.sas_sata_inf.rphy =3D rphy;
> +	} else {
> +		rphy =3D sas_expander_alloc(port,
> +		    mr_sas_port->remote_identify.device_type);
> +	}
> +	rphy->identify =3D mr_sas_port->remote_identify;
> +
> +	if (mrioc->current_event)
> +		mrioc->current_event->pending_at_sml =3D 1;
> +
> +	if ((sas_rphy_add(rphy))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +	}
> +	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
> +		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 0;
> +		tgtdev->dev_spec.sas_sata_inf.sas_transport_attached =3D 1;
> +		mpi3mr_tgtdev_put(tgtdev);
> +	}
> +
> +	dev_info(&rphy->dev,
> +	    "%s: added: handle(0x%04x), sas_address(0x%016llx)\n",
> +	    __func__, handle, (unsigned long long)
> +	    mr_sas_port->remote_identify.sas_address);
> +
> +	mr_sas_port->rphy =3D rphy;
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	list_add_tail(&mr_sas_port->port_list, &mr_sas_node->sas_port_list);
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +	if (mrioc->current_event) {
> +		mrioc->current_event->pending_at_sml =3D 0;
> +		if (mrioc->current_event->discard)
> +			mpi3mr_print_device_event_notice(mrioc, true);
> +	}
> +
> +	return mr_sas_port;
> +
> + out_fail:
> +	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
> +	    port_siblings)
> +		list_del(&mr_sas_phy->port_siblings);
> +	kfree(mr_sas_port);
> +	return NULL;
> +}
> +
> +/**
> + * mpi3mr_sas_port_remove - remove port from the list
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of attached device
> + * @sas_address_parent: SAS address of parent expander or host
> + * @hba_port: HBA port entry
> + *
> + * Removing object and freeing associated memory from the
> + * sas_port_list.
> + *
> + * Return: None
> + */
> +static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_add=
ress,
> +	u64 sas_address_parent, struct mpi3mr_hba_port *hba_port)
> +{
> +	int i;
> +	unsigned long flags;
> +	struct mpi3mr_sas_port *mr_sas_port, *next;
> +	struct mpi3mr_sas_node *mr_sas_node;
> +	u8 found =3D 0;
> +	struct mpi3mr_sas_phy *mr_sas_phy, *next_phy;
> +	struct mpi3mr_hba_port *srch_port, *hba_port_next =3D NULL;
> +
> +	if (!hba_port)
> +		return;
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	mr_sas_node =3D __mpi3mr_sas_node_find_by_sas_address(mrioc,
> +	    sas_address_parent, hba_port);
> +	if (!mr_sas_node) {
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +		return;
> +	}
> +	list_for_each_entry_safe(mr_sas_port, next, &mr_sas_node->sas_port_list=
,
> +	    port_list) {
> +		if (mr_sas_port->remote_identify.sas_address !=3D sas_address)
> +			continue;
> +		if (mr_sas_port->hba_port !=3D hba_port)
> +			continue;
> +		found =3D 1;
> +		list_del(&mr_sas_port->port_list);
> +		goto out;
> +	}
> +
> + out:
> +	if (!found) {
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +		return;
> +	}
> +
> +	if (mr_sas_node->host_node) {
> +		list_for_each_entry_safe(srch_port, hba_port_next,
> +		    &mrioc->hba_port_table_list, list) {
> +			if (srch_port !=3D hba_port)
> +				continue;
> +			ioc_info(mrioc,
> +			    "removing hba_port entry: %p port: %d from hba_port list\n",
> +			    srch_port, srch_port->port_id);
> +			list_del(&hba_port->list);
> +			kfree(hba_port);
> +			break;
> +		}
> +	}
> +
> +	for (i =3D 0; i < mr_sas_node->num_phys; i++) {
> +		if (mr_sas_node->phy[i].remote_identify.sas_address =3D=3D
> +		    sas_address)
> +			memset(&mr_sas_node->phy[i].remote_identify, 0,
> +			    sizeof(struct sas_identify));
> +	}
> +
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +	if (mrioc->current_event)
> +		mrioc->current_event->pending_at_sml =3D 1;
> +
> +	list_for_each_entry_safe(mr_sas_phy, next_phy,
> +	    &mr_sas_port->phy_list, port_siblings) {
> +		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
> +			dev_info(&mr_sas_port->port->dev,
> +			    "remove: sas_address(0x%016llx), phy(%d)\n",
> +			    (unsigned long long)
> +			    mr_sas_port->remote_identify.sas_address,
> +			    mr_sas_phy->phy_id);
> +		mr_sas_phy->phy_belongs_to_port =3D 0;
> +		if (!mrioc->stop_drv_processing)
> +			sas_port_delete_phy(mr_sas_port->port,
> +			    mr_sas_phy->phy);
> +		list_del(&mr_sas_phy->port_siblings);
> +	}
> +	if (!mrioc->stop_drv_processing)
> +		sas_port_delete(mr_sas_port->port);
> +	ioc_info(mrioc, "%s: removed sas_address(0x%016llx)\n",
> +	    __func__, (unsigned long long)sas_address);
> +
> +	if (mrioc->current_event) {
> +		mrioc->current_event->pending_at_sml =3D 0;
> +		if (mrioc->current_event->discard)
> +			mpi3mr_print_device_event_notice(mrioc, false);
> +	}
> +
> +	kfree(mr_sas_port);
> +}
> --=20
> 2.27.0
>=20

Looks good. When you fix the small nit above, you can add

Reviewed-by: Himanshu Madhani <himanshu.madani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

