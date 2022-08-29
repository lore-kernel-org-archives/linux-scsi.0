Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2B1ECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiH2QZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiH2QZy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:25:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A767285B
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:25:53 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TECbQl023539;
        Mon, 29 Aug 2022 16:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cydl8MdnMLgs1KmwgBTK/brziUH0UfyzBPoV+v+VUdQ=;
 b=I3UCZDBMl9GXm5BxKKue9A4RAr8WMRCjEx+aX6jhvZ9M2p65wfEBDtTi1rzjFpa1ezS3
 T3fl+Am3Ec65r0qis18WyWhLfwIFCgnB54o3gfUKYY0L85g8qxzpipzaDY3tAlrH0tx6
 ElQ66mM1KFafYMf9QbYAJtDQlCcGJ+JnMSdGfYfBuQ89gq8iPdZObh6S4XBubEAVJLm/
 wxwEVzNH6hlX7G15f268ZcXzQHNC/Q6fFWxWU2B4zEap4PAeoyumH+SV4T5iNnyDP2Mu
 MN5IbapKcTd/oUsORQZk7rD+f0hdc4UtDGEVV60t4D9ACNgTcSkiFvzbnq791+yrY97N ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79v0kx3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:25:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TETJqf034942;
        Mon, 29 Aug 2022 16:25:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2kqgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:25:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ7L4Duv54NkOyKizfjs3qsVs+7gXgPy++UF/W7F5Br99dPFxW1sC8U138nG2BEqeE6dx1fo10NHK44fbMeRnuch71qiui3ILd95zqtQP0mljBy/IDhzUv6LCwBLoVyCJ+gC1q1dzq1VRqoTl1pB5V/bCR7LrpfJWFifpsWb0T0/Mjbto2xn5bnE7Q2lj2m3g+Zcxwbs2ksa01h7ORh2dIxG5s9WN/1WS7Gw7MEplFKInP3jkvgJZgUb3iV1fSoIo+BbydjZKHC/PbKnvhecDXq99MKmlXob/IBJDETgtVm3yXbIc6NhE1YPAuCVdQ5IPHMhTBg5d0fCGtg1KWQhpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cydl8MdnMLgs1KmwgBTK/brziUH0UfyzBPoV+v+VUdQ=;
 b=XnTcNV0nWkiVborw82eBy+jLyTSyUCOErlDmI9/iJXw8iRsceW0mPQL4YOjNXE8hQdQFwN1WLColyTCT3pyyonwvD49zuoCAoDN8h9jG0IAtsm+PO3PnfxOC3FT+GqHao/Fch+48lpZPQA0RjCeO6j3mOOq72aFzUZQvvtCTydLYNYjm1wSKltUOnCOUxiiPv+g7P3mp6JyfSCFF6mUi2a/2hEP7a1CkwAUE8FpVFSd7rxQm/ZdUrxatUOTR3O6UU24rMEEaECUJlILk1yYBlm1JAZF4Nj/ezFM+s4hG/wnm+aza3NNozBOHdomi7ds39hX9CfNclcoOTterEV94/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cydl8MdnMLgs1KmwgBTK/brziUH0UfyzBPoV+v+VUdQ=;
 b=R81mfGG3LEUmJxSzqIfP9LaOQ4vaGK1rNRRizwM7sALugqaK7vsP4xtMd53Nu2mmwzwdWqBoJFblRzZ1AgBhxrFcyTshGvdyyhGBkyY7c56beeS1ilTvE2rgsxzoj9KwAaX958Z48tj73hW/HQKMp4uFSFO4+QlFop/VTqeygOs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BLAPR10MB5075.namprd10.prod.outlook.com (2603:10b6:208:322::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 16:25:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:25:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 6/7] qla2xxx: define static symbols
Thread-Topic: [PATCH v2 6/7] qla2xxx: define static symbols
Thread-Index: AQHYuTZT/kMYVsTWk0ywRpO5+SQtM63GFZCA
Date:   Mon, 29 Aug 2022 16:25:48 +0000
Message-ID: <56A17B73-99C3-409E-926E-72B487D59229@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-7-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2753c786-c990-45fd-b8bb-08da89db21b9
x-ms-traffictypediagnostic: BLAPR10MB5075:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FDil10ruIRe3AdXePgPjdpRsUKZiCSpYWrNnnzePDIUtUf9eSd/XtqdFBg4v5lE3QuP++vAOyv1WGKe3Rgq7f2P8aMY0lTFVabj2ijkNFtHiBWFa73jfO6WmLAiCsexkTfqi+wXCaJyiIaMA9qn69IlTg/lcLtRqHBqpjZPetHcpfMW9/tLR36V2k0d1uIN4/uKBF0SatzXpN9rpVY8mRbjbXGKsGfJ3StcDxd655osOXDMQ9DJ1vsM7z5USHfue8HVUhdXSnMITMXI/PFFmJpBMc/3V/dSkX28HJk4nRjF+0XplFR/u4papb3idsYbv78CK8d22D/ME4L78kcZEZQvgwoIHRO5KBpjByssPyjP/gTz0xt9LI5HodrPgn/hvpwMzUgPt7kbI7sxIKrZ8bvS/5c/eP5n5aaf5edbdXoqo9fGpHJe4ftjeO4b3B1NTzCvhAct1cN/kkdagz0c9LJM1UO0m44jdk9RqzqH6d/GtzTDQU1Q9hg6rdNWAu/eLqcviZFA4cbT0iz9zRErnwDq1IsrQQ37O3AV3XCV61C4P+x1UUhT+tQcY7Qs50/ggearPUDvfMBm49YDhX5Qvgr6RVlxvcI7fKmhC3OozF2lDXOyD4Gu9roI4b2nKiNH2mJ/p4le0FEmatCX6HpUmogdUrD6whgvvEJFqK8jymgs/9CzxKH1J2o8c6kgoJb4qnSP3WsBIKqmIMy4y8wUE91XfWw2tKhmsindwMLuStPj4WdR82X+P+3g65ZDZYcmRLdUW2+HHPyhFI/CwikDZ39eRmBIyn2/nrteMVDiXoCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(376002)(39860400002)(346002)(41300700001)(26005)(6512007)(53546011)(6506007)(6486002)(71200400001)(83380400001)(186003)(2616005)(66476007)(44832011)(8936002)(2906002)(5660300002)(478600001)(6916009)(316002)(54906003)(4326008)(64756008)(66446008)(66556008)(91956017)(8676002)(66946007)(76116006)(38070700005)(86362001)(122000001)(33656002)(36756003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+JTZX4x5s7aREPnK7iewFXmfUxpKew79V3KLqYod/qQmPTblwGxiEfKYoxJt?=
 =?us-ascii?Q?GCiYUlUuxgmMIQh66vfRnEMrC23w3jih5JHoumbW0a9OzujTchqdrQOXIonA?=
 =?us-ascii?Q?HKk1M0UtWJnzc4OZbuG9JhPkAjaHknDw7LtmvLRNvBCoT6mZadRufVeMYM8Y?=
 =?us-ascii?Q?dc+R4Xs6+oOoCEd00cctJDVJCMJadFGapjUtXhA937kurnnUJIag3uAkWAPM?=
 =?us-ascii?Q?FOHJ1VeQu1gIGA5Zy7brSOvSfIt49ZuBlOodUhYOKhlpT6wGzd/dYzOQPmRf?=
 =?us-ascii?Q?XdobUz+TpbwPsDzbIOhgMC/dCeH1S/0jWxkdGvmhXKhTlv7MaECoiI1IGEd9?=
 =?us-ascii?Q?oaa2vAy3u8qfhxcILKqPhc7/h4hVFfVqlh9GEeEbF9kI+zDok0i0O1u8UqyY?=
 =?us-ascii?Q?0ZTQd5wnAiyesuI3TvrJIpr1ODFzyZOkO3sUANhcPpMy+/O0aipDcOmpt2iE?=
 =?us-ascii?Q?/qHjpcGay1HQrJoqBl1gBj1AelfB3LZro+Bh7nYcUgDs8JL8iNdkqEzlI4cU?=
 =?us-ascii?Q?U9txzlb9oGS/BpOIvv2QXi+xLHiB51OOU/WReTC7IVBpm1dfBs2wNou+pze8?=
 =?us-ascii?Q?cGeHgzgJNR9IWCzw8eDXYGEiAL4WJInRJgQKbdYGunmk5CRfYWXtrGKUGIPf?=
 =?us-ascii?Q?EqEx1X//PbekosSektpjO68lxtv19dory+FeSrQNR706vWTb19GdqvI8bVh/?=
 =?us-ascii?Q?yGg3r8MxMw4rrpn0e5S0IrLHeFuSCIE56cXhckoFMzNACGPe8E8sUmPsv0Xs?=
 =?us-ascii?Q?pfzR1zvN1A1X2xdIB4UPodUJS0sKJ6yOmEgBdpc3oKT9tZW0BL/Vr0STLReP?=
 =?us-ascii?Q?UlE2s6koQa0ulw6o2xRbqurYBHol5WniTzsaQJ7SMZQrK88KW1dvJ8vuluFS?=
 =?us-ascii?Q?alJ6D4fqUof0gYdwdAufuhbO/1gYIYRAYPFYI/NVequLo9BMlM81e0GnDnja?=
 =?us-ascii?Q?m/pMq8rJPmidf75Lr6OGKTpcYKBC2lraeOCkc1s9Iw8+bmqGHCxOjZbglLuo?=
 =?us-ascii?Q?sQb3em5xD4fDtSTwILlROQzbRLOBkNZt6mg4Im0tc+dQXOYmKs5b9waL7cpM?=
 =?us-ascii?Q?0TaO9krs9vcLgH1wV3ZpD5WPKVipcqxkpfqm48kP2YxucVQbGPtHeH/EZpwW?=
 =?us-ascii?Q?5oWRobQwAx4SPZWmSCiDEA86RHUPzRmLI15jIEUJe6X16vc45lquMEMfwGYZ?=
 =?us-ascii?Q?Ik0AWgBTmfdubM/eBvk+0PF1yXcchS671dEp/Q5FeKTAUgeGQ6Z17toZ3bGm?=
 =?us-ascii?Q?rf1Ee7w/f1+XTVbSFUSPEx3hg3sLcPq6eyoA9aYbr/vP3JisJYEJqNSW2Ur/?=
 =?us-ascii?Q?o5GM5OUHh9zsxQwOkwwzSzE4ogTJ/kpJwWaiBf0heiAMDgLD216uUBeOcZBh?=
 =?us-ascii?Q?T7uqIqSUV+gquEc/4yqGSvlRp6E/An9T8A/iDcwyswBoijRsh3E2cJ3H0sHz?=
 =?us-ascii?Q?r2ykcFXgpp0pg8pkbmBrXkq1w5rEJEwUpolbVgl1TdqVHJvhMQ7mGx+3bijG?=
 =?us-ascii?Q?ggOL2tzWFzTf5XuXoGU8lZmqgcVqFo8mfIYlxkag1C9POJkjVjCYm7GnehcR?=
 =?us-ascii?Q?mqgPWaY/Db7E/LjDzUDMMzVT1SdNAnF8l3Bq+qD5zXkL3xnY58f+mX4D0pub?=
 =?us-ascii?Q?RQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <059DE800DDFD4846B941959EC492E7AF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2753c786-c990-45fd-b8bb-08da89db21b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:25:48.2696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gIctuRLsdVm+yUhqqZ4Y57FQ2xv1YQBKkuBwDjLJ7fvd7WKLQ5WWFgUCHZju/hPDKxGjExeq+vubDJA2dXH7x2DukcLmZpCTCR7dvXg7Uvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290076
X-Proofpoint-GUID: snWBEC-RG3pJtb7w8ZTSVEBC5aqA-ddb
X-Proofpoint-ORIG-GUID: snWBEC-RG3pJtb7w8ZTSVEBC5aqA-ddb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> drivers/scsi/qla2xxx/qla_os.c:40:20: warning: symbol 'qla_trc_array'
> was not declared. Should it be static?
> drivers/scsi/qla2xxx/qla_os.c:345:5: warning: symbol
> 'ql2xdelay_before_pci_error_handling' was not declared.
> Should it be static?
>=20
> Define qla_trc_array and ql2xdelay_before_pci_error_handling
> as static to fix sparse warnings.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 4a55c1e81327..46c281b55c63 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -37,7 +37,7 @@ static int apidev_major;
>  */
> struct kmem_cache *srb_cachep;
>=20
> -struct trace_array *qla_trc_array;
> +static struct trace_array *qla_trc_array;
>=20
> int ql2xfulldump_on_mpifail;
> module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
> @@ -342,7 +342,7 @@ MODULE_PARM_DESC(ql2xabts_wait_nvme,
> 		 "To wait for ABTS response on I/O timeouts for NVMe. (default: 1)");
>=20
>=20
> -u32 ql2xdelay_before_pci_error_handling =3D 5;
> +static u32 ql2xdelay_before_pci_error_handling =3D 5;
> module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
> MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
> 	"Number of seconds delayed before qla begin PCI error self-handling (def=
ault: 5).\n");
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

