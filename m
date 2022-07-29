Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E88C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 20:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiG2ULY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 16:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbiG2ULW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 16:11:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EC383F3B
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 13:11:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TK6xvk010704;
        Fri, 29 Jul 2022 20:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ujpNtesIRaN8hNDY6J00VpYJzXDgT90SOvpGj7gPGxE=;
 b=SNlG+wxtrG44lN2UUtPUBN2JThSkhOto+QHrsr7+RvO8gZzDDBjkbq4FK8ETX5GqQHEP
 dPkZBR9ayP9RqWNO9NFM9c9a07PmkT1313wcCvHEWWc/l1wAVviDQN71TOtwfGujZNAq
 Wvm494Qzi53FZY11oziv6dzM6c3uvVxm37RNPbo9s8jMfX0EIkWX5VvqtlfLMhazqGa4
 AttYzNbAEd4GDtZZs1r/O2DsW0ytpFCeXwcUTeYeeCAcys5zmILWImWK2hH2zjU3YfCs
 sNjb7KXHOmpbSIUtWE5D0aa+rxGFVfRMCjtH6G/oIdLq8lzFRDxHymy6JshJbaCKUrGt Wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a50df0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 20:11:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26THKlIS019886;
        Fri, 29 Jul 2022 20:11:12 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh63bw54v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 20:11:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuiQ6b+2SJUfnicOGtGKbF5JCFVzhZgPT8Bks3f4CtsIw18sDOAGlUbKGEXqDvXsh5HuP7wCUbTKv/9Y70Nw03UJ6lz+DB80t5VNDrGqMzJxliAt+piw3HdRTPVZ9KIs7/Kz7JujShTQ45JXDIgT0YNgzr0Jf7Sg1NOzQlEJf44yksuax0fDsBlezPJwngarc8a1OqdEtqHEgLXhrhWJaOVLy4iKGyXhstG2M5OmvmSEglu7u5HduIzeCBego8NTkZYeI64TFBD0jvEA/CawpK/LryUck0t+xIeaDgPB7Y8X6CrkkjzhknUEtuF7q2sg6JDndyyu1IJv7PqNFhpX+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujpNtesIRaN8hNDY6J00VpYJzXDgT90SOvpGj7gPGxE=;
 b=MT46xApQopQtJ0PCjV8KM5ONHFcED7x5f23inMVb3QRUSHnfi7WM/gUDc0fNYcMZwy8bkTeu3cTZEQfKi41wfrsa7UDcXoM8mZpm6OY8mG45jzzYoriwIVdW0VBzBpHPWRBHxoedD5WQDVGZRiGWNlV+huMFXWjvjsKnHcKXuKk+Kvl56dB761mJOlRQy3wqWJmBntF7EJNMksknp/7bGxnESmVMmr2VVoSL8Ku0uofcTdtgurAW9nIh4Gztx4GeGjaSj+TkVWev7Jl/f8EqaUJBuLDvmpYwmWUQP/E7N4Xi0J8EILbo9obIRNsGuVLFDTc5VIwMYb/DEsGbBZr+lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujpNtesIRaN8hNDY6J00VpYJzXDgT90SOvpGj7gPGxE=;
 b=0FXeuy+bSPA4meT+fGf6SUKWQfWcjHin388tZVcGj1Oj+sAAu+6KEYGhJOlr79DYkxCNLzkuoHE8UnB8IpRRSQAd7dk/HOaY8CR5BRB7wBLJ9NFaRMbPsjdt4RAbiZ7dwl/NtHH1vaFRcJ14seimNNQOh8lZJ/pLADQoCt/UCbM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY5PR10MB6215.namprd10.prod.outlook.com (2603:10b6:930:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23; Fri, 29 Jul
 2022 20:11:09 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5458.025; Fri, 29 Jul 2022
 20:11:09 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/15] mpi3mr: Add helper functions to retrieve device
 objects
Thread-Topic: [PATCH 06/15] mpi3mr: Add helper functions to retrieve device
 objects
Thread-Index: AQHYo0vzR51WFO8p1UixmlfS5L9lbq2VyBaA
Date:   Fri, 29 Jul 2022 20:11:09 +0000
Message-ID: <14F6ACBA-27D4-4E0A-A788-5103145E7DD8@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-7-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-7-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6956c6b-987d-4603-79e9-08da719e7a3e
x-ms-traffictypediagnostic: CY5PR10MB6215:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fduUlqjyp03gpnHjQak4SX1VYUb/DhM5NnD/9BUfkDC5nXlBs2dYaf/W+aDDmXXuuCS9C9RdGRLPOzjyL6fUVjuDJfSJPbweFdG8vv0SqX65lzSP7/SG9yz8XjPED0qRAsO2ehSGs+aBAk4hRgqoWDqZX9DIAJZNhu4jNfsfQiXswX3jTkZHkrqlW63J4hnxkVsXzgVWWjz5MFOgL9nasQXswUne6yktp4vmN6zsm3mvmyMalGQOl1tW3ivbB8s+qLp5/ey2spJQfrDeQA0Xx5Kh0Aw19/BrvGQcoP+B4Tplg+aLecF+ecLQQ0AFphnYyYk/xp5ZFxk7kY2m0x336OnptRzznXKBAGT0En0BB0hDimDK3AuhVDe6wytxMJ40fTeClgDXce1HGxY7q0x6qMzmgdOEJ2Tb9xYL4WOPkUgYt97P33XdaP6gQNcdQ43obDVuDjFoQ8kXJU9fNnHpL2RcdZWjUIPjo+imfrS2brbRXJBLWTm4nMnPpwv49AbD9lSnSWa1Ghk0d2c7uV3lB1ikkYD8RcWyKAdhvBO1njkbx/dcj41vAPHIdfy895S6sIiDdjKIoecYbFy6sU3tKUZKvWp6OThd1k9b6DMOC6FbZM5vVnTPSmVb2/b0ceKS+GBPNfVnp7RVD8l22ig+KRlUawglhODYd6OxW/jnTHKx7sQ0MTkqKweOI9qjpFiQmwjn8++vBQXPFPmIaIqq3/uWosXyuVZY3brhq/tR2gqCvUqES4CSpmJ4Kb5F7UbW4vknL+U1OOpONqcqC1P37XYLzFYFa7SnoCZajKKsAXZY9GSnc8z3qvd52rLiztaNRLjeYejigAEChyXMDpcAPHXbzFNLO9av8oPX+tUloGQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(39860400002)(376002)(38100700002)(36756003)(66556008)(122000001)(8936002)(26005)(54906003)(4326008)(38070700005)(8676002)(66446008)(83380400001)(66946007)(64756008)(44832011)(6916009)(76116006)(478600001)(107886003)(41300700001)(6512007)(66476007)(71200400001)(91956017)(6506007)(2906002)(6486002)(2616005)(30864003)(5660300002)(33656002)(316002)(53546011)(86362001)(186003)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qGKLujzmKxWImPD4/awTKbGKAf8vAiHOcGDldP2a0VDfoJ8cH8mGoEwkFr6S?=
 =?us-ascii?Q?bqtJXU96M5iFnBgJ3hUuG3PO15xWGWMElpUG6SICNjCYEfgrWuIJnzgoULIv?=
 =?us-ascii?Q?pAUobNnMyCrTJs99MwgmAGYeb3uTeBb56iBxKg7Tw/NM4Wq8+o4oBZMLdk61?=
 =?us-ascii?Q?R0n/PlTDxc7tvZQN2sRP2bO3K4gjkp2T9EAd+W6VxBHOJ1rWeqzv6xBParXv?=
 =?us-ascii?Q?LfIP8cmY3S/tiLNeBj7oNivY3ZK4VTLEmG/LqwYaoB8zA21AluEiwM4Cufl9?=
 =?us-ascii?Q?mmYYlYGTE3Fqh3k4CM2sc1RHF51Y9+hKBzR+virpUgTxIl6Zi/5/MClghWhZ?=
 =?us-ascii?Q?V4S/rCIrDVmPJd+d4q66gZ4CS8eTjhV0/1xKmLDLJAaHRUP7JEcs9rck6Plw?=
 =?us-ascii?Q?qOiA0r0Ptyg0HTFyU2ww35y0ugobyScmEqsGwN+KiRNRcXHPO3ltMlQevkgp?=
 =?us-ascii?Q?7o2VB5Jn0ZuKmlkXc0Vl68vrRSVMRDp1NToB0K7EOR/F114/W8KVzvHwsclo?=
 =?us-ascii?Q?05ghnEqkOafPYh/MUEowlW4/11ml2Ypk+VMWdFMWXuIfdKCc0iiXigs3n+IO?=
 =?us-ascii?Q?+0Ge8Kb7D7cG7KyhYE0KH4Wq6kAKe9bDDPEjbDNUMRGnDFU92OjEKQIkHJYP?=
 =?us-ascii?Q?6tq5N4ZpQ8bI5vHuA9viiZvMawYpYEbjCe4/R7hOpflikEjCC2RJn4QU7p8g?=
 =?us-ascii?Q?RY1VgvZQvgWGhMcnC1PJy18croJZ5TXi6ZIlU/jwF1AFi1L0aXSPF8SltZ+V?=
 =?us-ascii?Q?ZCKvzdOK/JQC9zlD/JHtzBi0SfQRBoG5PVt8LBzT6g/tsTDC8HTr++MNEwNs?=
 =?us-ascii?Q?PhJPIKtrK6JJgnJAbFG0p9m6jatd33LiVJWwhYzQ053RHQnwtiqMPaD3ox9u?=
 =?us-ascii?Q?jGJLC2G3aEb4wC60tu2f9WL8r7h4bYMD/J8XhTrlFp44gR6XBgWFbr3Gj26C?=
 =?us-ascii?Q?nLgLVfENU3e1qKDC6Z9tPIIxWneaR6G9Pu+YB5cSqzV9WSIB83K04WIH86Fq?=
 =?us-ascii?Q?aBOxLMvGwLNTv3rQ0x5y4ALBEBXHycZRtW3f7LNb7cWz+tl/7KKf0tPLwjsF?=
 =?us-ascii?Q?SySxYVor7XqWfeo/9ADLLw8/gslceFip2hlHNTrw6ZA4/tChRVeQk0AcjOpP?=
 =?us-ascii?Q?ANKpvLRsD9kSpAa1E83AueNxhG9iJDgq+NiBShD6QuXzxRPc3cLI+0Fv8f/9?=
 =?us-ascii?Q?yqucYvwHkG9fUnGM190IbxT/BLYFkj4KIFvT4dS8dSW+q16H3dUgybmiU5S8?=
 =?us-ascii?Q?b+shA95lE8WIZCyRkfSYNAVdB/pqnNebk1fDJ3S0rfPVdXXOJ35tV+gl7PQp?=
 =?us-ascii?Q?whWyLwHhXqOgSKA6YqSx5ryIwrrMekCOXfZiwTlmrh0ezGQ1aMgcgfe5+3wc?=
 =?us-ascii?Q?T4svLN+ClUsgS4zjOk88rBRxbpQ4kbVlIzzU6jjGdztFUg2+3H4MYaMAuNsE?=
 =?us-ascii?Q?2x8Em/A3Q5Tgpwy6WixjeTHsoWV2sQOdI5jc+swxnKlvBQs8sDNQ/h1877aB?=
 =?us-ascii?Q?qVu3BZdWgWprqo6eIU14TVNnA5nTdla4AUKaVCXGpd0Lug002+d7CpxaHw3Q?=
 =?us-ascii?Q?tpDEBcnb4m5Yz073yIekHGcGAsiVEpRhxgcbEAm0gNphpcNCiYavURvK3sBy?=
 =?us-ascii?Q?zR8Vlx+woyhJTKLU3ec6ko4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A0506F16088934C8914E9C5CFADAA1E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6956c6b-987d-4603-79e9-08da719e7a3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 20:11:09.5876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bD/dA2zbYymjFzVsU4fMAcjqtvj+YuDzdFdf05/Ui/O775Bm8p97WBmD/7r1ER8LHrwEqgRQJT1RDVMas19d3//cPGqqLwOlV3hu2XOp93A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290083
X-Proofpoint-ORIG-GUID: lTum4zz9OonnzttK1YWC6_2jwpSFNx8i
X-Proofpoint-GUID: lTum4zz9OonnzttK1YWC6_2jwpSFNx8i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added below helper functions,
> - Get the device's sas address by reading
>  correspond device's Device page0,
> - Get the expander object from expander list based
>  on expander's handle,
> - Get the target device object from target device list
>  based on device's sas address,
> - Get the expander device object from expander list
>  based on expanders's sas address,
> - Get hba port object from hba port table list
>  based on port's port id
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |  14 ++
> drivers/scsi/mpi3mr/mpi3mr_os.c        |   3 +
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 280 +++++++++++++++++++++++++
> 3 files changed, 297 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 006bc5d..742caf5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -570,10 +570,12 @@ struct mpi3mr_enclosure_node {
>  *
>  * @sas_address: World wide unique SAS address
>  * @dev_info: Device information bits
> + * @hba_port: HBA port entry
>  */
> struct tgt_dev_sas_sata {
> 	u64 sas_address;
> 	u16 dev_info;
> +	struct mpi3mr_hba_port *hba_port;
> };
>=20
> /**
> @@ -984,6 +986,10 @@ struct scmd_priv {
>  * @cfg_page: Default memory for configuration pages
>  * @cfg_page_dma: Configuration page DMA address
>  * @cfg_page_sz: Default configuration page memory size
> + * @sas_hba: SAS node for the controller
> + * @sas_expander_list: SAS node list of expanders
> + * @sas_node_lock: Lock to protect SAS node list
> + * @hba_port_table_list: List of HBA Ports
>  * @enclosure_list: List of Enclosure objects
>  */
> struct mpi3mr_ioc {
> @@ -1162,6 +1168,10 @@ struct mpi3mr_ioc {
> 	dma_addr_t cfg_page_dma;
> 	u16 cfg_page_sz;
>=20
> +	struct mpi3mr_sas_node sas_hba;
> +	struct list_head sas_expander_list;
> +	spinlock_t sas_node_lock;
> +	struct list_head hba_port_table_list;
> 	struct list_head enclosure_list;
> };
>=20
> @@ -1317,4 +1327,8 @@ int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_io=
c *mrioc,
> 	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
> int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
> 	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
> +
> +u8 mpi3mr_is_expander_device(u16 device_info);
> +struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mri=
oc,
> +	u8 port_id);
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index ca718cb..b75ce73 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4692,11 +4692,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct p=
ci_device_id *id)
> 	spin_lock_init(&mrioc->tgtdev_lock);
> 	spin_lock_init(&mrioc->watchdog_lock);
> 	spin_lock_init(&mrioc->chain_buf_lock);
> +	spin_lock_init(&mrioc->sas_node_lock);
>=20
> 	INIT_LIST_HEAD(&mrioc->fwevt_list);
> 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
> 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
> 	INIT_LIST_HEAD(&mrioc->delayed_evtack_cmds_list);
> +	INIT_LIST_HEAD(&mrioc->sas_expander_list);
> +	INIT_LIST_HEAD(&mrioc->hba_port_table_list);
> 	INIT_LIST_HEAD(&mrioc->enclosure_list);
>=20
> 	mutex_init(&mrioc->reset_mutex);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 989bf63..fea3aae 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -9,6 +9,237 @@
>=20
> #include "mpi3mr.h"
>=20
> +/**
> + * __mpi3mr_expander_find_by_handle - expander search by handle
> + * @mrioc: Adapter instance reference
> + * @handle: Firmware device handle of the expander
> + *
> + * Context: The caller should acquire sas_node_lock
> + *
> + * This searches for expander device based on handle, then
> + * returns the sas_node object.
> + *
> + * Return: Expander sas_node object reference or NULL
> + */
> +static struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct m=
pi3mr_ioc
> +	*mrioc, u16 handle)
> +{
> +	struct mpi3mr_sas_node *sas_expander, *r;
> +
> +	r =3D NULL;
> +	list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
> +		if (sas_expander->handle !=3D handle)
> +			continue;
> +		r =3D sas_expander;
> +		goto out;
> +	}
> + out:
> +	return r;
> +}
> +
> +/**
> + * mpi3mr_is_expander_device - if device is an expander
> + * @device_info: Bitfield providing information about the device
> + *
> + * Return: 1 if the device is expander device, else 0.
> + */
> +u8 mpi3mr_is_expander_device(u16 device_info)
> +{
> +	if ((device_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) =3D=3D
> +	     MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +/**
> + * mpi3mr_get_sas_address - retrieve sas_address for handle
> + * @mrioc: Adapter instance reference
> + * @handle: Firmware device handle
> + * @sas_address: Address to hold sas address
> + *
> + * This function issues device page0 read for a given device
> + * handle and gets the SAS address and return it back
> + *
> + * Return: 0 for success, non-zero for failure
> + */
> +static int mpi3mr_get_sas_address(struct mpi3mr_ioc *mrioc, u16 handle,
> +	u64 *sas_address)
> +{
> +	struct mpi3_device_page0 dev_pg0;
> +	u16 ioc_status;
> +	struct mpi3_device0_sas_sata_format *sasinf;
> +
> +	*sas_address =3D 0;
> +
> +	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
> +	    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
> +	    handle))) {
> +		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_s=
tatus(0x%04x) failure at %s:%d/%s()!\n",
> +		    handle, ioc_status, __FILE__, __LINE__, __func__);
> +		return -ENXIO;
> +	}
> +
> +	if (le16_to_cpu(dev_pg0.flags) &
> +	    MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE)
> +		*sas_address =3D mrioc->sas_hba.sas_address;
> +	else if (dev_pg0.device_form =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA) {
> +		sasinf =3D &dev_pg0.device_specific.sas_sata_format;
> +		*sas_address =3D le64_to_cpu(sasinf->sas_address);
> +	} else {
> +		ioc_err(mrioc, "%s: device_form(%d) is not SAS_SATA\n",
> +		    __func__, dev_pg0.device_form);
> +		return -ENXIO;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * __mpi3mr_get_tgtdev_by_addr - target device search
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of the device
> + * @hba_port: HBA port entry
> + *
> + * This searches for target device from sas address and hba port
> + * pointer then return mpi3mr_tgt_dev object.
> + *
> + * Return: Valid tget_dev or NULL
> + */
> +static struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr(struct mpi3mr_=
ioc *mrioc,
> +	u64 sas_address, struct mpi3mr_hba_port *hba_port)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	assert_spin_locked(&mrioc->tgtdev_lock);
> +
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
> +		if ((tgtdev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA) &&
> +		    (tgtdev->dev_spec.sas_sata_inf.sas_address =3D=3D sas_address)
> +		    && (tgtdev->dev_spec.sas_sata_inf.hba_port =3D=3D hba_port))
> +			goto found_device;
> +	return NULL;
> +found_device:
> +	mpi3mr_tgtdev_get(tgtdev);
> +	return tgtdev;
> +}
> +
> +/**
> + * mpi3mr_get_tgtdev_by_addr - target device search
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of the device
> + * @hba_port: HBA port entry
> + *
> + * This searches for target device from sas address and hba port
> + * pointer then return mpi3mr_tgt_dev object.
> + *
> + * Context: This function will acquire tgtdev_lock and will
> + * release before returning the mpi3mr_tgt_dev object.
> + *
> + * Return: Valid tget_dev or NULL
> + */
> +static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_addr(struct mpi3mr_io=
c *mrioc,
> +	u64 sas_address, struct mpi3mr_hba_port *hba_port)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	unsigned long flags;
> +
> +	if (!hba_port)
> +		goto out;
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	tgtdev =3D __mpi3mr_get_tgtdev_by_addr(mrioc, sas_address, hba_port);
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +out:
> +	return tgtdev;
> +}
> +
> +/**
> + * mpi3mr_expander_find_by_sas_address - sas expander search
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of expander
> + * @hba_port: HBA port entry
> + *
> + * Return: A valid SAS expander node or NULL.
> + *
> + */
> +static struct mpi3mr_sas_node *mpi3mr_expander_find_by_sas_address(
> +	struct mpi3mr_ioc *mrioc, u64 sas_address,
> +	struct mpi3mr_hba_port *hba_port)
> +{
> +	struct mpi3mr_sas_node *sas_expander, *r =3D NULL;
> +
> +	if (!hba_port)
> +		goto out;
> +
> +	list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
> +		if ((sas_expander->sas_address !=3D sas_address) ||
> +					 (sas_expander->hba_port !=3D hba_port))
> +			continue;
> +		r =3D sas_expander;
> +		goto out;
> +	}
> +out:
> +	return r;
> +}
> +
> +/**
> + * __mpi3mr_sas_node_find_by_sas_address - sas node search
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of expander or sas host
> + * @hba_port: HBA port entry
> + * Context: Caller should acquire mrioc->sas_node_lock.
> + *
> + * If the SAS address indicates the device is direct attached to
> + * the controller (controller's SAS address) then the SAS node
> + * associated with the controller is returned back else the SAS
> + * address and hba port are used to identify the exact expander
> + * and the associated sas_node object is returned. If there is
> + * no match NULL is returned.
> + *
> + * Return: A valid SAS node or NULL.
> + *
> + */
> +static struct mpi3mr_sas_node *__mpi3mr_sas_node_find_by_sas_address(
> +	struct mpi3mr_ioc *mrioc, u64 sas_address,
> +	struct mpi3mr_hba_port *hba_port)
> +{
> +
Remove new line here
> +	if (mrioc->sas_hba.sas_address =3D=3D sas_address)
> +		return &mrioc->sas_hba;
> +	return mpi3mr_expander_find_by_sas_address(mrioc, sas_address,
> +	    hba_port);
> +}
> +
> +/**
> + * mpi3mr_parent_present - Is parent present for a phy
> + * @mrioc: Adapter instance reference
> + * @phy: SAS transport layer phy object
> + *
> + * Return: 0 if parent is present else non-zero
> + */
> +static int mpi3mr_parent_present(struct mpi3mr_ioc *mrioc, struct sas_ph=
y *phy)
> +{
> +
remove new line=20
> +	unsigned long flags;
> +	struct mpi3mr_hba_port *hba_port =3D phy->hostdata;
> +
> +	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> +	if (__mpi3mr_sas_node_find_by_sas_address(mrioc,
> +	    phy->identify.sas_address,
> +	    hba_port) =3D=3D NULL) {
> +		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +		return -1;
> +	}
> +	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> +	return 0;
> +}
> +
> /**
>  * mpi3mr_convert_phy_link_rate -
>  * @link_rate: link rate as defined in the MPI header
> @@ -428,3 +659,52 @@ static int mpi3mr_add_expander_phy(struct mpi3mr_ioc=
 *mrioc,
> 	mr_sas_phy->phy =3D phy;
> 	return 0;
> }
> +
> +/**
> + * mpi3mr_alloc_hba_port - alloc hba port object
> + * @mrioc: Adapter instance reference
> + * @port_id: Port number
> + *
> + * Alloc memory for hba port object.
> + */
> +static struct mpi3mr_hba_port *
> +mpi3mr_alloc_hba_port(struct mpi3mr_ioc *mrioc, u16 port_id)
> +{
> +	struct mpi3mr_hba_port *hba_port;
> +
> +	hba_port =3D kzalloc(sizeof(struct mpi3mr_hba_port),
> +	    GFP_KERNEL);
> +	if (!hba_port)
> +		return NULL;
> +	hba_port->port_id =3D port_id;
> +	ioc_info(mrioc, "hba_port entry: %p, port: %d is added to hba_port list=
\n",
> +	    hba_port, hba_port->port_id);
> +	list_add_tail(&hba_port->list, &mrioc->hba_port_table_list);
> +	return hba_port;
> +}
> +
> +/**
> + * mpi3mr_get_hba_port_by_id - find hba port by id
> + * @mrioc: Adapter instance reference
> + * @port_id - Port ID to search
> + *
> + * Return: mpi3mr_hba_port reference for the matched port
> + */
> +
> +struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mri=
oc,
> +	u8 port_id)
> +{
> +
Ditto remove newline
> +	struct mpi3mr_hba_port *port, *port_next;
> +
> +	list_for_each_entry_safe(port, port_next,
> +	    &mrioc->hba_port_table_list, list) {
> +		if (port->port_id !=3D port_id)
> +			continue;
> +		if (port->flags & MPI3MR_HBA_PORT_FLAG_DIRTY)
> +			continue;
> +		return port;
> +	}
> +
> +	return NULL;
> +}
> --=20
> 2.27.0
>=20

--
Himanshu Madhani	Oracle Linux Engineering

