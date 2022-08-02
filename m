Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B611EC00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 21:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiHBVAs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 17:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiHBVAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 17:00:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D2D6246
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 14:00:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272KXirg023032;
        Tue, 2 Aug 2022 21:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Uhl/ow7O6sj+UlouVLxgmiu2l4xUo70VKvLd/7Nyf0w=;
 b=IqCJOdDYBlreNZ3g7SBwtZu8nRjIj9huU0ql+5L9yns7ed5wsuSCote52k4otLuNeGI7
 VC8lffr9vcWcPRhnLLskbTE3dcQBj1C8MMPjeDHLjtJ9H7BC7lI7xFCgwK65cPed8Cah
 S5xtlPd9BVyXuoBzx92t4ICbrOvTzke6KEgpSFrOEwlM4e3QFybtyFfM9iNd0qtydjhO
 jgHUEhrGnoASrohlAhZbQztcwhZe4ZPaivQY9gSTcN5+hb88JvQFyeOpnGtqYEKtg/Rr
 YQxz0fuTiwmYP8VrrWEpPe1qTnfsHDmhkTdA1h6pZCsJC7oKHm+MWUtV/AoPzpA1ZUzs 6w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2ra2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 21:00:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 272KxNp4031516;
        Tue, 2 Aug 2022 21:00:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu32qba3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 21:00:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaGbKrsQk77M4bzC8ZCsVEHkv6RUvSY2hr7Qlebas3vHpYJRGwIMCoFxIJz5fMjy0rsDS9GNvdIyGu6YjEaoJcgH4w5UiwOSn4/Dl5KIaaGcv0Pfki4G407ldwwquLjGtFg4hy05OCjf5Xm+6bBB57hbaTGbqf1diQWSeIAYgdruamqhGRya/xdQ204hi1F5wiVyYVsk7AEa9REHm7bvNmLN0PF6E0G89LXLLzVl/tZ2Y5hKdC8PoAg7DdnGwTcDIQkLSTzwjR5O47dV3pojCQiK5EmixtLoTxRBkXIYQIfm2Ar6KTOpdsqVU3476NUZTPCa+Bv9hjpsPOhSvXqs/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uhl/ow7O6sj+UlouVLxgmiu2l4xUo70VKvLd/7Nyf0w=;
 b=JmBAOHMrw8OAhv/06DzshamKUpWqp1ooBz/h8Aacp3l81YBg1+p2BfW3Ea3DzPCmOJVgWMQdYTcK/oFsHOI41744KoM30Rb28+DX0up3G0u0d4cjcrWezBBAZbUXjJ/AHynoPr61DhN78OdlsdWOSvs0+jSEIRuY4mXW+cJZCn9p6Fzp8AFWmiCyfjva/EMGIDhGCkWB++Za/vbuXhQmoCbG2xanDIPAwS3OND/2lfOgpycWy7iX7uPjUkkvXK34yDGxWWW0rb/0qZh0Rp/v94f6jHqicr+cr5Y8T2B4kD95XhkCCLOKsd6A58GxMEHAUilrYaStIxWjPAPGVRdsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uhl/ow7O6sj+UlouVLxgmiu2l4xUo70VKvLd/7Nyf0w=;
 b=xvpYSg8Mt7lK7+hrMMrdqNcZowY2K5SNxqzSjasTwhXxhWP7CbIUo/LO56cjnOSMNkKbp9cWDvGqhd6YgwPdbQOTHehRy+WotbB+wPb3ZRbBcfjBQ/ER+jAkAb1IYlYICDj7R4GzBHhGromhzI17wYCmXWTLIgKS6P9m+8WhB4o=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH0PR10MB4892.namprd10.prod.outlook.com (2603:10b6:610:dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 21:00:40 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 21:00:40 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/15] mpi3mr: Refresh sas ports during soft reset
Thread-Topic: [PATCH 14/15] mpi3mr: Refresh sas ports during soft reset
Thread-Index: AQHYo0wQACj8u66nrke1aF3v2TKbG62cHz0A
Date:   Tue, 2 Aug 2022 21:00:39 +0000
Message-ID: <255C547C-CE98-48FE-962A-0E524F0DE77B@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-15-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-15-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb8843a2-f5b9-450c-e3b6-08da74ca0e78
x-ms-traffictypediagnostic: CH0PR10MB4892:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 72rWrt+McD+Zt9O0DEz53OuMgKC3XAiq8yI3ZsNxhdxV+mJDgrZVkRE5+bUxBrZD+F/3fFWVQLs28UeYE/AuGSw+WiKZq3Z+2/tM68zTePb4ai3Sijfz2eW44cxgkbttZLYcSbe570V5gNCN+MKrqfmiOmCz95h4bg+NYNLcNX5yrTqtTUb4qmAqyZEucolRBnxax19/IWnLDTQSLeQ/hEIzePmwEwUJkMgBc4jf6kzYvWF+LrEz1blrovBMnxGh/H734XCtH0frV+T6STklwAnNa1iLnwSM4lxVscs/qyr2lWooWKQ34w/HwDv/vZq6SgpISN4BxgrjSBg9R/jjwycLhkDNL37edbge3caLGfEyIxJP/qK84LGGVXHk5GjugEtg3ZsiX8Ej5yMNV25QQj2xSQ6/IBBqKUdgBJZxURnNW3hr5qpV/STGdQeut/sNPaG+SLlSaCMjjeL7h1hZ5T0Ua3lY+9OPSVAjiWIsa7SCFPMJ1uZdpllnVcRd/VOlX2nsvHZgc2u1iWQkbXcmm5vx6ISzDG8gs31gwnIopZgRMl1xdiC35urAgSq3siX6V5cZIAQYdTl11yILo7gkOxzKGHouKlzzkr3aNW/9mGidF8icIFR/b/WJnnoJsLHgOo35YIw73Hc8WbuqiRH7EnRLz1eOb2weezT0IWur31tnU7v8jRSCs+zmVbRof8t9P05r4d6sr28XkE314wPkLIAlV12vIxHQxx7ADX7tMWH1E46TTFqHCxENzntnPjoPI6GOCphj4AFXXoMDv76Nn27I3yMe59yXpvOsUZf0BNSAWUfmq+43OGU93Bg2Q7IlSd931KrhFSX3lmuF+3YrTYRmuAeRexKJSnG3s1PYyI4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(366004)(39860400002)(136003)(26005)(53546011)(6512007)(6506007)(86362001)(41300700001)(6916009)(54906003)(71200400001)(316002)(6486002)(478600001)(38070700005)(38100700002)(122000001)(2616005)(107886003)(83380400001)(186003)(30864003)(91956017)(5660300002)(4326008)(64756008)(33656002)(66446008)(66556008)(36756003)(66946007)(8676002)(44832011)(8936002)(66476007)(2906002)(76116006)(32563001)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yQCVVzIrN49GcenlFiHQorcJ/7xh8we0TKPane1ndVVMXI89kUDi5E9VKko6?=
 =?us-ascii?Q?ZulvAnpNNyZa1jlG77VtIdt8/62pIzg0J87kb1tXIw5RBZfnYzwJq1fP7lYG?=
 =?us-ascii?Q?C91p+iwvIjlOvneoBexvd7fF6e8wb/rmYfMBLDmMt4a08lzVZFYwataeTtpl?=
 =?us-ascii?Q?4KWJ5Y14P5DNE4VjI31ytSkxLzul4az/bQUuSI9wjzaO5Z28V5gKPLA8B3bz?=
 =?us-ascii?Q?5//lfsmlkqDLnsWCqW4UV9WQW3GAL6fWgyjpnFjg4BoenPgE1NhIah8JSNW4?=
 =?us-ascii?Q?pvbRU8s9aEnf6hjMDXhqUxAAztUt8E+JwuzcWLrsUXygybm7+f/HwVFEC3CH?=
 =?us-ascii?Q?ligp9mxktYF30INgkhFAJO2fz/ZmAJx3JURCABEEV/GPhmxoYf2+c/Q1jmG0?=
 =?us-ascii?Q?fUwLfLd7tK626G/hoXtP4/UGH/qsKI9E5w9oq6NPgom7S1tvSK+UpBF6IH9X?=
 =?us-ascii?Q?PBCbk2rYIpjsd3aJZVouL81oY1/BPRsg6M7LZoCaWZo36UIUmXRzdC3+BGBw?=
 =?us-ascii?Q?q4JUK95oPkCrdL0slRzjL34X48dbHq5sSb9U3TG12eCVL+k7MbZ4o4UkUuwK?=
 =?us-ascii?Q?bdCpOhuGohIVqkRAvaCJ0+WFsjpgV4A2wfcLjuHSPISK93r67Z/kYFWc7fxA?=
 =?us-ascii?Q?FcNYUNPiuWp12Ie255vo6XXeIabcyMDXv6HA8qGTDKkaO83C6u4mN0FhmO+9?=
 =?us-ascii?Q?ZD7LFYUDNPq1iovz9Pa5mzxEK/NqwXsKqgh5jnJJ7/B8ywBqAD+4m5J9vewH?=
 =?us-ascii?Q?yUjgBvMOkKG3bOlSDZpjqzdijS73fNoOCPqmeKZEDHLRUL2NAp7xGhIrHPnd?=
 =?us-ascii?Q?vScnEkZiMZmvwggOwaD0OFp4jzZ1PheGF+My1h/BzL+O37yHfEL3Rfwj9RdS?=
 =?us-ascii?Q?qCjnGP3eBEcEYGV/hRVhncdjjMwue/QYcUlt1rE0+66WALx9U2HqcftKhu7G?=
 =?us-ascii?Q?gn8vFOMvkblBmYxfhWhE8xhiR89xDcIB6yFrRqvJqnnXP0i3O5L6XQjGG29t?=
 =?us-ascii?Q?jlyFBvcWzIL0sUVySqbjb/ieb+gAQiJcz74enCZjFUqws5c+9tZuH07tVcAM?=
 =?us-ascii?Q?f8OKZlBeJgfkb8fYeiRcz+iLfFn9Tm4iYfuRLT9or60oTe3o82KoF9G+5dQQ?=
 =?us-ascii?Q?ddxhMHZZPTjzOheAsW4vkaNKr0ztfCnH1xSqAZkkekCUYS8nUgcKlxza6uo3?=
 =?us-ascii?Q?F+cF0U9RA+rzpJQxoXcyrj13B4Q3G/ZOXEtNAF7Py7EBUBmFbwRgI6D3Z963?=
 =?us-ascii?Q?IPgASgkYquRr/3jUHSJ+TJWkKVUImVXbbObFqQ1ijGCZkCWnBSjvyZt7+Un2?=
 =?us-ascii?Q?GnzSjhF3VytlxHUbQ72cjNa8Klbrz8/cgio8NC7mQzk/Spt91JouaWPKB+pi?=
 =?us-ascii?Q?rcclYHFqLLWO5jcVPkZuWFAUULTvI9tXy6ZeM7POC9LHdabAuaTe6T0sXU/e?=
 =?us-ascii?Q?2EpmW4pm9Cbg2Oxl3LA21SPAZYCFX7ZS1/Rdn7du9lLM38kLxrl+Fx4SI0gD?=
 =?us-ascii?Q?szlNpxMNtOqUJgsnwGdkyAUCQn32/Kk/PPRBd2kCFFJReI/50HDAuqDMvKFy?=
 =?us-ascii?Q?8yp6apl+0Y4rcZ3EjdowGhtP+wqfBQhe0fCG8MxpWGSYU7gnuDYAxiCiDne5?=
 =?us-ascii?Q?hA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA457B3103FC1142B153EA9EA9D6CA3C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8843a2-f5b9-450c-e3b6-08da74ca0e78
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 21:00:40.0897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 676XNkNOmOWvO5QwLV067d+df+O7GGmyaQhGaZuRGMLJhFQ/2CdrNGmJCq1H4PdKXbCsGYAbnrDnvFWMSiTQYnG0dtuf1DTdN/YmSG/2FCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_14,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208020098
X-Proofpoint-ORIG-GUID: Xj47-rUm3EWofIzycR1ESf7GzMbqf0gr
X-Proofpoint-GUID: Xj47-rUm3EWofIzycR1ESf7GzMbqf0gr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> - Update the Host's sas ports if there is change in port id
> or phys. If the port id is changed then the driver updates
> the same. If some phys are enabled/disabled during reset then
> driver updates the same in STL.
>=20
> - Check for the responding expander devices and update the
> device handle if it got changed. Register the expander with
> STL if it got added during reset and unregister the
> expander device if it got removed during reset.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |  11 +
> drivers/scsi/mpi3mr/mpi3mr_fw.c        |  10 +-
> drivers/scsi/mpi3mr/mpi3mr_os.c        |  50 ++++
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 351 +++++++++++++++++++++++++
> 4 files changed, 421 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index d203167..0f47b45 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -482,6 +482,9 @@ struct mpi3mr_hba_port {
>  * struct mpi3mr_sas_port - Internal SAS port information
>  * @port_list: List of ports belonging to a SAS node
>  * @num_phys: Number of phys associated with port
> + * @marked_responding: used while refresing the sas ports
> + * @lowest_phy: lowest phy ID of current sas port
> + * @phy_mask: phy_mask of current sas port
>  * @hba_port: HBA port entry
>  * @remote_identify: Attached device identification
>  * @rphy: SAS transport layer rphy object
> @@ -491,6 +494,9 @@ struct mpi3mr_hba_port {
> struct mpi3mr_sas_port {
> 	struct list_head port_list;
> 	u8 num_phys;
> +	u8 marked_responding;
> +	int lowest_phy;
> +	u32 phy_mask;
> 	struct mpi3mr_hba_port *hba_port;
> 	struct sas_identify remote_identify;
> 	struct sas_rphy *rphy;
> @@ -939,6 +945,7 @@ struct scmd_priv {
>  * @scan_started: Async scan started
>  * @scan_failed: Asycn scan failed
>  * @stop_drv_processing: Stop all command processing
> + * @device_refresh_on: Don't process the events until devices are refres=
hed
>  * @max_host_ios: Maximum host I/O count
>  * @chain_buf_count: Chain buffer count
>  * @chain_buf_pool: Chain buffer pool
> @@ -1107,6 +1114,7 @@ struct mpi3mr_ioc {
> 	u8 scan_started;
> 	u16 scan_failed;
> 	u8 stop_drv_processing;
> +	u8 device_refresh_on;
>=20
> 	u16 max_host_ios;
> 	spinlock_t tgtdev_lock;
> @@ -1378,4 +1386,7 @@ struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_=
and_rphy(
> 	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy);
> void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
> 	bool device_add);
> +void mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc);
> +void mpi3mr_refresh_expanders(struct mpi3mr_ioc *mrioc);
> +void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc);
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 59ef373..dfb7570 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3977,6 +3977,11 @@ retry_init:
> 		goto out_failed;
> 	}
>=20
> +	if (!is_resume) {
> +		mrioc->device_refresh_on =3D 1;
> +		mpi3mr_add_event_wait_for_device_refresh(mrioc);
> +	}
> +
> 	ioc_info(mrioc, "sending port enable\n");
> 	retval =3D mpi3mr_issue_port_enable(mrioc, 0);
> 	if (retval) {
> @@ -4733,6 +4738,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mr=
ioc,
> 	ioc_info(mrioc, "controller reset is triggered by %s\n",
> 	    mpi3mr_reset_rc_name(reset_reason));
>=20
> +	mrioc->device_refresh_on =3D 0;
> 	mrioc->reset_in_progress =3D 1;
> 	mrioc->stop_bsgs =3D 1;
> 	mrioc->prev_reset_result =3D -1;
> @@ -4814,7 +4820,8 @@ out:
> 			mpi3mr_pel_wait_post(mrioc, &mrioc->pel_cmds);
> 		}
>=20
> -		mpi3mr_rfresh_tgtdevs(mrioc);
> +		mrioc->device_refresh_on =3D 0;
> +
> 		mrioc->ts_update_counter =3D 0;
> 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> 		if (mrioc->watchdog_work_q)
> @@ -4828,6 +4835,7 @@ out:
> 	} else {
> 		mpi3mr_issue_reset(mrioc,
> 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> +		mrioc->device_refresh_on =3D 0;
> 		mrioc->unrecoverable =3D 1;
> 		mrioc->reset_in_progress =3D 0;
> 		retval =3D -1;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 139c164..d4f37b1 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -40,6 +40,8 @@ static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mr=
ioc, u8 event,
>=20
> #define MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION	(0xFFFF)
>=20
> +#define MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH	(0xFFFE)
> +
> /**
>  * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
>  * @mrioc: Adapter instance reference
> @@ -1114,6 +1116,9 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc =
*mrioc,
> 		    MPI3_DEVICE0_FLAGS_ATT_METHOD_VIRTUAL)) ||
> 		    (tgtdev->parent_handle =3D=3D 0xFFFF))
> 			tgtdev->non_stl =3D 1;
> +		if (tgtdev->dev_spec.sas_sata_inf.hba_port)
> +			tgtdev->dev_spec.sas_sata_inf.hba_port->port_id =3D
> +			    dev_pg0->io_unit_port;
> 		break;
> 	}
> 	case MPI3_DEVICE_DEVFORM_PCIE:
> @@ -1886,6 +1891,22 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mri=
oc,
> 		}
> 		break;
> 	}
> +	case MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH:
> +	{
> +		while (mrioc->device_refresh_on)
> +			msleep(500);
> +
> +		dprint_event_bh(mrioc,
> +		    "scan for non responding and newly added devices after soft reset =
started\n");
> +		if (mrioc->sas_transport_enabled) {
> +			mpi3mr_refresh_sas_ports(mrioc);
> +			mpi3mr_refresh_expanders(mrioc);
> +		}
> +		mpi3mr_rfresh_tgtdevs(mrioc);
> +		ioc_info(mrioc,
> +		    "scan for non responding and newly added devices after soft reset =
completed\n");
> +		break;
> +	}
> 	default:
> 		break;
> 	}
> @@ -2655,6 +2676,35 @@ static void mpi3mr_cablemgmt_evt_th(struct mpi3mr_=
ioc *mrioc,
> 	}
> }
>=20
> +/**
> + * mpi3mr_add_event_wait_for_device_refresh - Add Wait for Device Refres=
h Event
> + * @mrioc: Adapter instance reference
> + *
> + * Add driver specific event to make sure that the driver won't process =
the
> + * events until all the devices are refreshed during soft reset.
> + *
> + * Return: Nothing
> + */
> +void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
> +{
> +	struct mpi3mr_fwevt *fwevt =3D NULL;
> +
> +	fwevt =3D mpi3mr_alloc_fwevt(0);
> +	if (!fwevt) {
> +		dprint_event_th(mrioc,
> +		    "failed to schedule bottom half handler for event(0x%02x)\n",
> +		    MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH);
> +		return;
> +	}
> +	fwevt->mrioc =3D mrioc;
> +	fwevt->event_id =3D MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH;
> +	fwevt->send_ack =3D 0;
> +	fwevt->process_evt =3D 1;
> +	fwevt->evt_ctx =3D 0;
> +	fwevt->event_data_size =3D 0;
> +	mpi3mr_fwevt_add_to_list(mrioc, fwevt);
> +}
> +
> /**
>  * mpi3mr_os_handle_events - Firmware event handler
>  * @mrioc: Adapter instance reference
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index e8a9a76..c1ca97c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -9,6 +9,9 @@
>=20
> #include "mpi3mr.h"
>=20
> +static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_node *sas_expander);
> +
> /**
>  * mpi3mr_post_transport_req - Issue transport requests and wait
>  * @mrioc: Adapter instance reference
> @@ -597,6 +600,9 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *=
mrioc,
>=20
> 	list_del(&mr_sas_phy->port_siblings);
> 	mr_sas_port->num_phys--;
> +	mr_sas_port->phy_mask &=3D ~(1 << mr_sas_phy->phy_id);
> +	if (mr_sas_port->lowest_phy =3D=3D mr_sas_phy->phy_id)
> +		mr_sas_port->lowest_phy =3D ffs(mr_sas_port->phy_mask) - 1;
> 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
> 	mr_sas_phy->phy_belongs_to_port =3D 0;
> }
> @@ -621,6 +627,9 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mri=
oc,
>=20
> 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
> 	mr_sas_port->num_phys++;
> +	mr_sas_port->phy_mask |=3D (1 << mr_sas_phy->phy_id);
> +	if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
> +		mr_sas_port->lowest_phy =3D ffs(mr_sas_port->phy_mask) - 1;
> 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
> 	mr_sas_phy->phy_belongs_to_port =3D 1;
> }
> @@ -1356,6 +1365,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(=
struct mpi3mr_ioc *mrioc,
> 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
> 		    &mr_sas_port->phy_list);
> 		mr_sas_port->num_phys++;
> +		mr_sas_port->phy_mask |=3D (1 << i);
> 	}
>=20
> 	if (!mr_sas_port->num_phys) {
> @@ -1364,6 +1374,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(=
struct mpi3mr_ioc *mrioc,
> 		goto out_fail;
> 	}
>=20
> +	mr_sas_port->lowest_phy =3D ffs(mr_sas_port->phy_mask) - 1;
> +
> 	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
> 		tgtdev =3D mpi3mr_get_tgtdev_by_addr(mrioc,
> 		    mr_sas_port->remote_identify.sas_address,
> @@ -1565,6 +1577,345 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_=
ioc *mrioc, u64 sas_address,
> 	kfree(mr_sas_port);
> }
>=20
> +/**
> + * struct host_port - host port details
> + * @sas_address: SAS Address of the attached device
> + * @phy_mask: phy mask of host port
> + * @handle: Device Handle of attached device
> + * @iounit_port_id: port ID
> + * @used: host port is already matched with sas port from sas_port_list
> + * @lowest_phy: lowest phy ID of host port
> + */
> +struct host_port {
> +	u64	sas_address;
> +	u32	phy_mask;
> +	u16	handle;
> +	u8	iounit_port_id;
> +	u8	used;
> +	u8	lowest_phy;
> +};
> +
> +/**
> + * mpi3mr_update_mr_sas_port - update sas port objects during reset
> + * @mrioc: Adapter instance reference
> + * @h_port: host_port object
> + * @mr_sas_port: sas_port objects which needs to be updated
> + *
> + * Update the port ID of sas port object. Also add the phys if new phys =
got
> + * added to current sas port and remove the phys if some phys are moved
> + * out of the current sas port.
> + *
> + * Return: Nothing.
> + */
> +static void
> +mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_=
port,
> +	struct mpi3mr_sas_port *mr_sas_port)
> +{
> +	struct mpi3mr_sas_phy *mr_sas_phy;
> +	u32 phy_mask_xor, phys_to_be_added, phys_to_be_removed;
> +	int i;
> +
> +	h_port->used =3D 1;
> +	mr_sas_port->marked_responding =3D 1;
> +
> +	dev_info(&mr_sas_port->port->dev,
> +	    "sas_address(0x%016llx), old: port_id %d phy_mask 0x%x, new: port_i=
d %d phy_mask:0x%x\n",
> +	    mr_sas_port->remote_identify.sas_address,
> +	    mr_sas_port->hba_port->port_id, mr_sas_port->phy_mask,
> +	    h_port->iounit_port_id, h_port->phy_mask);
> +
> +	mr_sas_port->hba_port->port_id =3D h_port->iounit_port_id;
> +	mr_sas_port->hba_port->flags &=3D ~MPI3MR_HBA_PORT_FLAG_DIRTY;
> +
> +	/* Get the newly added phys bit map & removed phys bit map */
> +	phy_mask_xor =3D mr_sas_port->phy_mask ^ h_port->phy_mask;
> +	phys_to_be_added =3D h_port->phy_mask & phy_mask_xor;
> +	phys_to_be_removed =3D mr_sas_port->phy_mask & phy_mask_xor;
> +
> +	/*
> +	 * Register these new phys to current mr_sas_port's port.
> +	 * if these phys are previously registered with another port
> +	 * then delete these phys from that port first.
> +	 */
> +	for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u32)) {
> +		mr_sas_phy =3D &mrioc->sas_hba.phy[i];
> +		if (mr_sas_phy->phy_belongs_to_port)
> +			mpi3mr_del_phy_from_an_existing_port(mrioc,
> +			    &mrioc->sas_hba, mr_sas_phy);
> +		mpi3mr_add_phy_to_an_existing_port(mrioc,
> +		    &mrioc->sas_hba, mr_sas_phy,
> +		    mr_sas_port->remote_identify.sas_address,
> +		    mr_sas_port->hba_port);
> +	}
> +
> +	/* Delete the phys which are not part of current mr_sas_port's port. */
> +	for_each_set_bit(i, (ulong *) &phys_to_be_removed, BITS_PER_TYPE(u32)) =
{
> +		mr_sas_phy =3D &mrioc->sas_hba.phy[i];
> +		if (mr_sas_phy->phy_belongs_to_port)
> +			mpi3mr_del_phy_from_an_existing_port(mrioc,
> +			    &mrioc->sas_hba, mr_sas_phy);
> +	}
> +}
> +
> +/**
> + * mpi3mr_refresh_sas_ports - update host's sas ports during reset
> + * @mrioc: Adapter instance reference
> + *
> + * Update the host's sas ports during reset by checking whether
> + * sas ports are still intact or not. Add/remove phys if any hba
> + * phys are (moved in)/(moved out) of sas port. Also update
> + * io_unit_port if it got changed during reset.
> + *
> + * Return: Nothing.
> + */
> +void
> +mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
> +{
> +	struct host_port h_port[32];
> +	int i, j, found, host_port_count =3D 0, port_idx;
> +	u16 sz, attached_handle, ioc_status;
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 =3D NULL;
> +	struct mpi3_device_page0 dev_pg0;
> +	struct mpi3_device0_sas_sata_format *sasinf;
> +	struct mpi3mr_sas_port *mr_sas_port;
> +
> +	sz =3D offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
> +		(mrioc->sas_hba.num_phys *
> +		 sizeof(struct mpi3_sas_io_unit0_phy_data));
> +	sas_io_unit_pg0 =3D kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg0)
> +		return;
> +	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out;
> +	}
> +
> +	/* Create a new expander port table */
> +	for (i =3D 0; i < mrioc->sas_hba.num_phys; i++) {
> +		attached_handle =3D le16_to_cpu(
> +		    sas_io_unit_pg0->phy_data[i].attached_dev_handle);
> +		if (!attached_handle)
> +			continue;
> +		found =3D 0;
> +		for (j =3D 0; j < host_port_count; j++) {
> +			if (h_port[j].handle =3D=3D attached_handle) {
> +				h_port[j].phy_mask |=3D (1 << i);
> +				found =3D 1;
> +				break;
> +			}
> +		}
> +		if (found)
> +			continue;
> +		if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
> +		    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
> +		    attached_handle))) {
> +			dprint_reset(mrioc,
> +			    "failed to read dev_pg0 for handle(0x%04x) at %s:%d/%s()!\n",
> +			    attached_handle, __FILE__, __LINE__, __func__);
> +			continue;
> +		}
> +		if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +			dprint_reset(mrioc,
> +			    "ioc_status(0x%x) while reading dev_pg0 for handle(0x%04x) at %s:=
%d/%s()!\n",
> +			    ioc_status, attached_handle,
> +			    __FILE__, __LINE__, __func__);
> +			continue;
> +		}
> +		sasinf =3D &dev_pg0.device_specific.sas_sata_format;
> +
> +		port_idx =3D host_port_count;
> +		h_port[port_idx].sas_address =3D le64_to_cpu(sasinf->sas_address);
> +		h_port[port_idx].handle =3D attached_handle;
> +		h_port[port_idx].phy_mask =3D (1 << i);
> +		h_port[port_idx].iounit_port_id =3D sas_io_unit_pg0->phy_data[i].io_un=
it_port;
> +		h_port[port_idx].lowest_phy =3D sasinf->phy_num;
> +		h_port[port_idx].used =3D 0;
> +		host_port_count++;
> +	}
> +
> +	if (!host_port_count)
> +		goto out;
> +
> +	if (mrioc->logging_level & MPI3_DEBUG_RESET) {
> +		ioc_info(mrioc, "Host port details before reset\n");
> +		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
> +		    port_list) {
> +			ioc_info(mrioc,
> +			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%x), lowest phy=
 id:%d\n",
> +			    mr_sas_port->hba_port->port_id,
> +			    mr_sas_port->remote_identify.sas_address,
> +			    mr_sas_port->phy_mask, mr_sas_port->lowest_phy);
> +		}
> +		mr_sas_port =3D NULL;
> +		ioc_info(mrioc, "Host port details after reset\n");
> +		for (i =3D 0; i < host_port_count; i++) {
> +			ioc_info(mrioc,
> +			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%x), lowest phy=
 id:%d\n",
> +			    h_port[i].iounit_port_id, h_port[i].sas_address,
> +			    h_port[i].phy_mask, h_port[i].lowest_phy);
> +		}
> +	}
> +
> +	/* mark all host sas port entries as dirty */
> +	list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
> +	    port_list) {
> +		mr_sas_port->marked_responding =3D 0;
> +		mr_sas_port->hba_port->flags |=3D MPI3MR_HBA_PORT_FLAG_DIRTY;
> +	}
> +
> +	/* First check for matching lowest phy */
> +	for (i =3D 0; i < host_port_count; i++) {
> +		mr_sas_port =3D NULL;
> +		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
> +		    port_list) {
> +			if (mr_sas_port->marked_responding)
> +				continue;
> +			if (h_port[i].sas_address !=3D mr_sas_port->remote_identify.sas_addre=
ss)
> +				continue;
> +			if (h_port[i].lowest_phy =3D=3D mr_sas_port->lowest_phy) {
> +				mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
> +				break;
> +			}
> +		}
> +	}
> +
> +	/* In case if lowest phy is got enabled or disabled during reset */
> +	for (i =3D 0; i < host_port_count; i++) {
> +		if (h_port[i].used)
> +			continue;
> +		mr_sas_port =3D NULL;
> +		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
> +		    port_list) {
> +			if (mr_sas_port->marked_responding)
> +				continue;
> +			if (h_port[i].sas_address !=3D mr_sas_port->remote_identify.sas_addre=
ss)
> +				continue;
> +			if (h_port[i].phy_mask & mr_sas_port->phy_mask) {
> +				mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
> +				break;
> +			}
> +		}
> +	}
> +
> +	/* In case if expander cable is removed & connected to another HBA port=
 during reset */
> +	for (i =3D 0; i < host_port_count; i++) {
> +		if (h_port[i].used)
> +			continue;
> +		mr_sas_port =3D NULL;
> +		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
> +		    port_list) {
> +			if (mr_sas_port->marked_responding)
> +				continue;
> +			if (h_port[i].sas_address !=3D mr_sas_port->remote_identify.sas_addre=
ss)
> +				continue;
> +			mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
> +			break;
> +		}
> +	}
> +out:
> +	kfree(sas_io_unit_pg0);
> +}
> +
> +/**
> + * mpi3mr_refresh_expanders - Refresh expander device exposure
> + * @mrioc: Adapter instance reference
> + *
> + * This is executed post controller reset to identify any
> + * missing expander devices during reset and remove from the upper layer=
s
> + * or expose any newly detected expander device to the upper layers.
> + *
> + * Return: Nothing.
> + */
> +void
> +mpi3mr_refresh_expanders(struct mpi3mr_ioc *mrioc)
> +{
> +	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
> +	struct mpi3_sas_expander_page0 expander_pg0;
> +	u16 ioc_status, handle;
> +	u64 sas_address;
> +	int i;
> +	unsigned long flags;
> +	struct mpi3mr_hba_port *hba_port;
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
> +		sas_expander->non_responding =3D 1;
> +	}
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +	sas_expander =3D NULL;
> +
> +	handle =3D 0xffff;
> +
> +	/* Search for responding expander devices and add them if they are newl=
y got added */
> +	while (true) {
> +		if ((mpi3mr_cfg_get_sas_exp_pg0(mrioc, &ioc_status, &expander_pg0,
> +		    sizeof(struct mpi3_sas_expander_page0),
> +		    MPI3_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
> +			dprint_reset(mrioc,
> +			    "failed to read exp pg0 for handle(0x%04x) at %s:%d/%s()!\n",
> +			    handle, __FILE__, __LINE__, __func__);
> +			break;
> +		}
> +
> +		if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +			dprint_reset(mrioc,
> +			   "ioc_status(0x%x) while reading exp pg0 for handle:(0x%04x), %s:%d=
/%s()!\n",
> +			   ioc_status, handle, __FILE__, __LINE__, __func__);
> +			break;
> +		}
> +
> +		handle =3D le16_to_cpu(expander_pg0.dev_handle);
> +		sas_address =3D le64_to_cpu(expander_pg0.sas_address);
> +		hba_port =3D mpi3mr_get_hba_port_by_id(mrioc, expander_pg0.io_unit_por=
t);
> +
> +		if (!hba_port) {
> +			mpi3mr_sas_host_refresh(mrioc);
> +			mpi3mr_expander_add(mrioc, handle);
> +			continue;
> +		}
> +
> +		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +		sas_expander =3D
> +		    mpi3mr_expander_find_by_sas_address(mrioc,
> +		    sas_address, hba_port);
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +
> +		if (!sas_expander) {
> +			mpi3mr_sas_host_refresh(mrioc);
> +			mpi3mr_expander_add(mrioc, handle);
> +			continue;
> +		}
> +
> +		sas_expander->non_responding =3D 0;
> +		if (sas_expander->handle =3D=3D handle)
> +			continue;
> +
> +		sas_expander->handle =3D handle;
> +		for (i =3D 0 ; i < sas_expander->num_phys ; i++)
> +			sas_expander->phy[i].handle =3D handle;
> +	}
> +
> +	/*
> +	 * Delete non responding expander devices and the corresponding
> +	 * hba_port if the non responding expander device's parent device
> +	 * is a host node.
> +	 */
> +
Remove newline here

> +	sas_expander =3D NULL;
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
> +	    &mrioc->sas_expander_list, list) {
> +		if (sas_expander->non_responding) {
> +			spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +			mpi3mr_expander_node_remove(mrioc, sas_expander);
> +			spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +		}
> +	}
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +}
> +
> /**
>  * mpi3mr_expander_node_add - insert an expander to the list.
>  * @mrioc: Adapter instance reference
> --=20
> 2.27.0
>=20

With the small nits fixed, you can add

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

