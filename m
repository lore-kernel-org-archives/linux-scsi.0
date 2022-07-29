Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E402C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 19:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbiG2TmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 15:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiG2TmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 15:42:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221EDEE0F
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 12:42:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TJcKmx009577;
        Fri, 29 Jul 2022 19:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=UzXkPJ8VUIskuXvqMPbtNatNPzCKy8O5Em1l0b08pj4=;
 b=kT11v6FqZJm2Z6PCo41bUIHFS7zEAEMV/bEkY3tJ6DGeuPCbcqRfQYROF66jm2mCqLCL
 +ZEdYG6GosLimcfEQ7aIKgiZXCbIZVX9aOcpBmUfHWzjemzo2ygO/Alq480J0X+S08zQ
 UG8MHlragSE0V55cBDqaip6AnFL92QAyuGkhEKhmuMtfc2aDVfdA1vJsQwKSCPSwxx58
 /8zbToo6hmR3Q7RPhcQ2Ku0rdlgS4C6Cz37VxMGhNG+jlQP+f9fkVwdZ4oMK68/3y73p
 aa19+ngDWGw/o1vIzxAcf7HvrsflTP2ZpFmSTzA3b736ooD2ei6rhwdh50O5iUP+yLch gw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9ap7kk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 19:42:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26TH0wgU020657;
        Fri, 29 Jul 2022 19:42:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh63bvhvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 19:42:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuWLVOHDVD1aOdRgt3AfZyKISWWIzB3VlTamDqTyb30I245HstJ/SQ91HuRUDciDCY482EVFEHGKMFej7FT9ObfvTzS47TaAdrJ2ArdkM5eLlVDbTwMF8J/QsDAyxLxwyFgNOMSOi9P+Bdt8/JRYWPs75nmxGTi/Wyq8czGhSS5V+GnHzPIcbW60If55AsRxhdbdZVXI/qqcDsQFUGjN185ktV+MccQeO7+r9HVGpa5n/woUdK+03H0IHbSQXF4TCRCqmKkypkt+Sgm4YNVAIwn/rtb68Ri5kLW6RrftffRqIHQ6pkRWyqirmnJnnSzcqH7iO/KTyvIOk7p+t6JP/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzXkPJ8VUIskuXvqMPbtNatNPzCKy8O5Em1l0b08pj4=;
 b=Qx/V331QaEzi20QOy99sRCffFJY8941/s/Awx2YeBVucJJgnYn7XK64pXv2TnVPdXWCB2zRmgINU5ja4o5IxQggGGZEdx5EaLbJTGZo6n10dvg0vgfFN1dvNDT6WlPC+4xmFarO9hzq/4sBWtEqGOt/WI1hwfdUCeqnrQ0aS3VmmRrqYluMPTW+odgxLEnjbDzC6lebx1SrPGl7Fx2hA5xsBSOpKKcL/w51rL7+UzRxu++zh/CavcWBRYjTSQKEBO+NC1wEqafW1R/SqSDdBq3GF+sQHStKVEJlINiaEpAXdrsS1I9RnVhpxMB+e0fjXPl0BR5+mgSBx+zXYGC07qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzXkPJ8VUIskuXvqMPbtNatNPzCKy8O5Em1l0b08pj4=;
 b=rmUut4WfvKdZxNhaZ6h38AL7OXilqvM9Ig/RAMHOl+daqmQ+HK3BsQ0JKg+vPmXIiZuLgSxAdU9johcp0XvbdHIicbTvjw7bVNzjyCrJyugkLLVdyNT1J2r7OEllID8vXXzN9Ppa7TgJQOEjssV6P7Hne8dnPpUH8OG9zlAehLc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 19:42:04 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5458.025; Fri, 29 Jul 2022
 19:42:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/15] mpi3mr: Add framework to add phys to STL
Thread-Topic: [PATCH 05/15] mpi3mr: Add framework to add phys to STL
Thread-Index: AQHYo0w3Rof0Ai1MmUuaQEWATbqLE62Vv/WA
Date:   Fri, 29 Jul 2022 19:42:03 +0000
Message-ID: <A42CFDC9-CB67-4DDF-8029-3A6AAC8A41DF@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-6-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-6-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6f0af21-ac09-4f82-2f28-08da719a6992
x-ms-traffictypediagnostic: SJ0PR10MB4606:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pALkBg1ciLgtExPj/3JNyhC+l3OMqfV10uXYTPLrhtO3kWrwhE/x+760dhigs1w4s/I/o6NQa4p7Mrb80lECN5b7u7bIop9hpJ1AqOSM116D1eK3w/yTWEespRLYdObSuIXTtyb1ZkvjyWE2RoF585dRlLBhdlg9zIXFAq3dLg4CqG5EmrjyrVN3tsbMKetUpel9btsy8o0Y2OFgE3PtEEwiAzfqkmeJJLfXmzJ8NiXKsvZgWgiBQAQbc/GpX8WGMAWXgvNJ46Vq+0X9/iaDxqtdif96uaxx74donh9jiF6N+hWOhCrCubWYXtjz84wbnOfA+THJXCFb5Y4vyM4fwiLUL7tgGzGTYp3mxDdSjKlopzRtnGKPSRHlNJoVK3PwN+YN8KtvMP+u6PV3oQ1XCgvp2Mj+94L1FUw10quQeYhuyiU37l8opO+Ofb0pmyncE8UNP3MUHaoO3v10KWue2252qDq2H2QiCuUMfHl3LNwoqRniKtR+o+5wMymJGsl5+r/fXpGazqPN9IsHyU8tGA5G3lfoReogIMuiH7y9tQsTET2PYtmI2kugcJsA/iUI9dwYVsVGte75qHxJa/K9aGvFmoCGcJHteMRu1fvTkul6uSvv+aK4e6Fws8uXyw0GqxdV8nVvMtt7W2g7WWQ9r0OjBA51/nRKdnypYcIvhxkH5xCBGkHSrZ28B5RVkxiPMfpvNjDjKrewu/X371mo+9xx6kLRQQLpQuuHsL5qhR5Ny4w6wPsvi/i72nfFWuSP+hCr969q2kYmLZQuwFcSQNyKY9XJ0MXbtXV4WaqnuBjWv9CGsotV5loxO2ULajiE7TF83iXTaUknHgZWCXkElmS8vAzN6e0wgMdpbxxOLCs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(396003)(136003)(376002)(366004)(83380400001)(41300700001)(6506007)(53546011)(71200400001)(478600001)(186003)(26005)(316002)(6486002)(107886003)(6512007)(2616005)(8936002)(6916009)(86362001)(5660300002)(44832011)(36756003)(76116006)(33656002)(30864003)(54906003)(122000001)(91956017)(2906002)(66946007)(4326008)(8676002)(66446008)(66476007)(66556008)(38100700002)(64756008)(38070700005)(32563001)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8+8AhBStlJvhB4TOkr76m2RIJPu6zQLtO1tQ86fyamB8qebtvUoLPcentbXH?=
 =?us-ascii?Q?/zQJPEYVG+WsrIv4IEWj+4KdOBkH66FpQDAKZRNxsrAUl+F1k7TqtgD1otnu?=
 =?us-ascii?Q?xUTf08D8x4F1Mwx0NIvLMFk4MZGIdDUkPw1tdSZZ38z/1lcL3avXR5ap9JxG?=
 =?us-ascii?Q?sAAjpGjx4aoexP0OuIk61QdaxgJY/s94KiIQ7GW4KoZWJET3uNgUz2miPPEX?=
 =?us-ascii?Q?LICrEoupejeKr5boDxNFkGy3UdjBdLu7/kFux/6n3ZJXPaifpze64Jdl404V?=
 =?us-ascii?Q?yg3bV58bPjo6ibLOUG5zeg+laDG3c9lfVzOM8BPyebdBc9yk5LGwRLd78TcE?=
 =?us-ascii?Q?wLbIvszIl1ir2iNp4iVwIp5Th8pomwPNBpYccF9Z7uQQoF5c3Ua+JLFlNwJL?=
 =?us-ascii?Q?fewfmix22hOlLINTQctEITV92+YNUDVjq9MozvjBHaM9tbjsVAK0WwWPXg3I?=
 =?us-ascii?Q?uyMpvqPmzb0EdBWjh+/I4RqkQWGq2nIPiFZv3dKTcQihrBUH6s8Iyj8yxA1P?=
 =?us-ascii?Q?bj9dBOnkRefOSXWAL9zS1QaKWMIDQaWuKfYQsAyiP/QTfQ+uhomoWmx3HLYy?=
 =?us-ascii?Q?hjsSR6HOSzNeMVGL6GnvLcd7FnOF0d8PfSmgSnF89sqcTgSnmhfTaP2ff7aZ?=
 =?us-ascii?Q?Z/zCU0tIPuC0qIyx/ePy7Cyr475z7ghxFtuwlUKFdggyY78TnK0n0Kctk9lH?=
 =?us-ascii?Q?Mo/xDgqYEAx2syLBBojelwLiZklNmZOr+mZttPAdZzELo1sb2OhuRRlrCgmG?=
 =?us-ascii?Q?pqqEp4W1ISTrJAg8V5cIPWF5q2p4kC6eAjRIkZ9/g6XE9nF25EAwp1y1SuHA?=
 =?us-ascii?Q?4KhQksuMHVP7F8OPaDBUewS/tyRtdKpyjUNSzsc9wuOjz6KJoX8SFv0RWYQg?=
 =?us-ascii?Q?AohcNKyRvxgsxa71Z8pAoFbtrZsoIVLHIOqp0WqSZvzChHLG1vFFE9hjYwtG?=
 =?us-ascii?Q?JnusF1dSMZpQB/ifrMxt/61TS74fSROj0fh/qRLjgdBtpZZnbT/JxXQBDkV/?=
 =?us-ascii?Q?jLZj506xzGLmPVaWSqKyY12E+mDK0n4NhoqrnkuOeW4B11bj7sq0F1UnggIq?=
 =?us-ascii?Q?bP+hheOreDNMAG9hIaDb56e6YC7QGRKsD85pzIj8+CZzKRevpn1V3YLa55xR?=
 =?us-ascii?Q?qyXmdSu7loupoZkht1ZhkqBW4wzcV57eQdyF9F6/5VHSsojVduiMj0uOThhb?=
 =?us-ascii?Q?cQPBqu9dq+cU5DFrj6c/JMrgFcGe3poqaTba9Yn9JBnQ9I7D6Y31SKOfdoDZ?=
 =?us-ascii?Q?yV40DCD8Al9YUdP1DCpGyRJi7GW9fa9cdUhidRI1jpE4TC9qZ8IoSY8CR/JF?=
 =?us-ascii?Q?z6e87oDZKkOzcc67Uc476/HHt3eUsc2wFDtlr6tt6f3qnzg97iCdtVVxseR8?=
 =?us-ascii?Q?uYDqGWH6Wyq4DhsfM9rv7LxKFXaLodMrit+/q3dMHF2FJOhby5rd/a8p+yFw?=
 =?us-ascii?Q?MNZuNMV8nVCAkAP9AgAm5T4EV3ht2faCf/1azT3LyVy/VKsYpO4IpRRBELFs?=
 =?us-ascii?Q?d0AejMm6Y3BuMwuBBNr56tP75JhoqwZDuzbJJgvv8UUX+oSPrFW4rakMJHkA?=
 =?us-ascii?Q?Mih/vZKYwriwRLQJLIoqgNmzZ1CLNzUEO1Moj7n/QeBjuVmipoGxpz9Gv/jX?=
 =?us-ascii?Q?zsZNrHRCu4K9R5N9Dt1tDBE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C25669E5B644FA4999AC9DFA7415BEFA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f0af21-ac09-4f82-2f28-08da719a6992
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 19:42:03.6280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PEjH48Huhnvu/B7QoVnSShbpqsD0o3vfN1e3Nj05UY+AGwmX3mUxO+N20oK85PU33rLuFZ5hzVAZPi3Yr3AKT13fNkm4pi6E6DiqSEjZPnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290080
X-Proofpoint-ORIG-GUID: FVlxhxEQnuqR04Cy8mnwZ7a7pRq1oHlg
X-Proofpoint-GUID: FVlxhxEQnuqR04Cy8mnwZ7a7pRq1oHlg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added framework to register and unregister the
> host and expander phys with SCSI Transport Layer (STL).
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/Makefile           |   1 +
> drivers/scsi/mpi3mr/mpi3mr.h           |  93 ++++++
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 430 +++++++++++++++++++++++++
> 3 files changed, 524 insertions(+)
> create mode 100644 drivers/scsi/mpi3mr/mpi3mr_transport.c
>=20
> diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
> index f5cdbe4..ef86ca4 100644
> --- a/drivers/scsi/mpi3mr/Makefile
> +++ b/drivers/scsi/mpi3mr/Makefile
> @@ -3,3 +3,4 @@ obj-m +=3D mpi3mr.o
> mpi3mr-y +=3D  mpi3mr_os.o     \
> 		mpi3mr_fw.o \
> 		mpi3mr_app.o \
> +		mpi3mr_transport.o
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 542b462..006bc5d 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -39,6 +39,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include <uapi/scsi/scsi_bsg_mpi3mr.h>
> +#include <scsi/scsi_transport_sas.h>
>=20
> #include "mpi/mpi30_transport.h"
> #include "mpi/mpi30_cnfg.h"
> @@ -461,6 +462,98 @@ struct mpi3mr_throttle_group_info {
> 	atomic_t pend_large_data_sz;
> };
>=20
> +/* HBA port flags */
> +#define MPI3MR_HBA_PORT_FLAG_DIRTY	0x01
> +
> +/**
> + * struct mpi3mr_hba_port - HBA's port information
> + * @port_id: Port number
> + * @flags: HBA port flags
> + */
> +struct mpi3mr_hba_port {
> +	struct list_head list;
> +	u8 port_id;
> +	u8 flags;
> +};
> +
> +/**
> + * struct mpi3mr_sas_port - Internal SAS port information
> + * @port_list: List of ports belonging to a SAS node
> + * @num_phys: Number of phys associated with port
> + * @hba_port: HBA port entry
> + * @remote_identify: Attached device identification
> + * @rphy: SAS transport layer rphy object
> + * @port: SAS transport layer port object
> + * @phy_list: mpi3mr_sas_phy objects belonging to this port
> + */
> +struct mpi3mr_sas_port {
> +	struct list_head port_list;
> +	u8 num_phys;
> +	struct mpi3mr_hba_port *hba_port;
> +	struct sas_identify remote_identify;
> +	struct sas_rphy *rphy;
> +	struct sas_port *port;
> +	struct list_head phy_list;
> +};
> +
> +/**
> + * struct mpi3mr_sas_phy - Internal SAS Phy information
> + * @port_siblings: List of phys belonging to a port
> + * @identify: Phy identification
> + * @remote_identify: Attached device identification
> + * @phy: SAS transport layer Phy object
> + * @phy_id: Unique phy id within a port
> + * @handle: Firmware device handle for this phy
> + * @attached_handle: Firmware device handle for attached device
> + * @phy_belongs_to_port: Flag to indicate phy belongs to port
> +   @hba_port: HBA port entry
> + */
> +struct mpi3mr_sas_phy {
> +	struct list_head port_siblings;
> +	struct sas_identify identify;
> +	struct sas_identify remote_identify;
> +	struct sas_phy *phy;
> +	u8 phy_id;
> +	u16 handle;
> +	u16 attached_handle;
> +	u8 phy_belongs_to_port;
> +	struct mpi3mr_hba_port *hba_port;
> +};
> +
> +/**
> + * struct mpi3mr_sas_node - SAS host/expander information
> + * @list: List of sas nodes in a controller
> + * @parent_dev: Parent device class
> + * @num_phys: Number phys belonging to sas_node
> + * @sas_address: SAS address of sas_node
> + * @handle: Firmware device handle for this sas_host/expander
> + * @sas_address_parent: SAS address of parent expander or host
> + * @enclosure_handle: Firmware handle of enclosure of this node
> + * @device_info: Capabilities of this sas_host/expander
> + * @non_responding: used to refresh the expander devices during reset
> + * @host_node: Flag to indicate this is a host_node
> + * @hba_port: HBA port entry
> + * @phy: A list of phys that make up this sas_host/expander
> + * @sas_port_list: List of internal ports of this node
> + * @rphy: sas_rphy object of this expander node
> + */
> +struct mpi3mr_sas_node {
> +	struct list_head list;
> +	struct device *parent_dev;
> +	u8 num_phys;
> +	u64 sas_address;
> +	u16 handle;
> +	u64 sas_address_parent;
> +	u16 enclosure_handle;
> +	u64 enclosure_logical_id;
> +	u8 non_responding;
> +	u8 host_node;
> +	struct mpi3mr_hba_port *hba_port;
> +	struct mpi3mr_sas_phy *phy;
> +	struct list_head sas_port_list;
> +	struct sas_rphy *rphy;
> +};
> +
> /**
>  * struct mpi3mr_enclosure_node - enclosure information
>  * @list: List of enclosures
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> new file mode 100644
> index 0000000..989bf63
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -0,0 +1,430 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Driver for Broadcom MPI3 Storage Controllers
> + *
> + * Copyright (C) 2017-2022 Broadcom Inc.
> + *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
> + *
> + */
> +
> +#include "mpi3mr.h"
> +
> +/**
> + * mpi3mr_convert_phy_link_rate -
> + * @link_rate: link rate as defined in the MPI header
> + *
> + * Convert link_rate from mpi format into sas_transport layer
> + * form.
> + *
> + * Return: A valid SAS transport layer defined link rate
> + */
> +static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
> +{
> +	enum sas_linkrate rc;
> +
> +	switch (link_rate) {
> +	case MPI3_SAS_NEG_LINK_RATE_1_5:
> +		rc =3D SAS_LINK_RATE_1_5_GBPS;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_3_0:
> +		rc =3D SAS_LINK_RATE_3_0_GBPS;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_6_0:
> +		rc =3D SAS_LINK_RATE_6_0_GBPS;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_12_0:
> +		rc =3D SAS_LINK_RATE_12_0_GBPS;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_22_5:
> +		rc =3D SAS_LINK_RATE_12_0_GBPS;

This should be SAS_LINK_RATE_22_5_GBPS

> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_PHY_DISABLED:
> +		rc =3D SAS_PHY_DISABLED;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED:
> +		rc =3D SAS_LINK_RATE_FAILED;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_PORT_SELECTOR:
> +		rc =3D SAS_SATA_PORT_SELECTOR;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_SMP_RESET_IN_PROGRESS:
> +		rc =3D SAS_PHY_RESET_IN_PROGRESS;
> +		break;
> +	case MPI3_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE:
> +	case MPI3_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE:
> +	default:
> +		rc =3D SAS_LINK_RATE_UNKNOWN;
> +		break;
> +	}
> +	return rc;
> +}
> +
> +/**
> + * mpi3mr_delete_sas_phy - Remove a single phy from port
> + * @mrioc: Adapter instance reference
> + * @mr_sas_port: Internal Port object
> + * @mr_sas_phy: Internal Phy object
> + *
> + * Return: None.
> + */
> +static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_port *mr_sas_port,
> +	struct mpi3mr_sas_phy *mr_sas_phy)
> +{
> +	u64 sas_address =3D mr_sas_port->remote_identify.sas_address;
> +
> +	dev_info(&mr_sas_phy->phy->dev,
> +	    "remove: sas_address(0x%016llx), phy(%d)\n",
> +	    (unsigned long long) sas_address, mr_sas_phy->phy_id);
> +
> +	list_del(&mr_sas_phy->port_siblings);
> +	mr_sas_port->num_phys--;
> +	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
> +	mr_sas_phy->phy_belongs_to_port =3D 0;
> +}
> +
> +/**
> + * mpi3mr_add_sas_phy - Adding a single phy to a port
> + * @mrioc: Adapter instance reference
> + * @mr_sas_port: Internal Port object
> + * @mr_sas_phy: Internal Phy object
> + *
> + * Return: None.
> + */
> +static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_port *mr_sas_port,
> +	struct mpi3mr_sas_phy *mr_sas_phy)
> +{
> +	u64 sas_address =3D mr_sas_port->remote_identify.sas_address;
> +
> +	dev_info(&mr_sas_phy->phy->dev,
> +	    "add: sas_address(0x%016llx), phy(%d)\n", (unsigned long long)
> +	    sas_address, mr_sas_phy->phy_id);
> +
> +	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
> +	mr_sas_port->num_phys++;
> +	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
> +	mr_sas_phy->phy_belongs_to_port =3D 1;
> +}
> +
> +/**
> + * mpi3mr_add_phy_to_an_existing_port - add phy to existing port
> + * @mrioc: Adapter instance reference
> + * @mr_sas_node: Internal sas node object (expander or host)
> + * @mr_sas_phy: Internal Phy object *
> + * @sas_address: SAS address of device/expander were phy needs
> + *             to be added to
> + * @hba_port: HBA port entry
> + *
> + * Return: None.
> + */
> +static void mpi3mr_add_phy_to_an_existing_port(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_node *mr_sas_node, struct mpi3mr_sas_phy *mr_sas_phy,
> +	u64 sas_address, struct mpi3mr_hba_port *hba_port)
> +{
> +	struct mpi3mr_sas_port *mr_sas_port;
> +	struct mpi3mr_sas_phy *srch_phy;
> +
> +	if (mr_sas_phy->phy_belongs_to_port =3D=3D 1)
> +		return;
> +
> +	if (!hba_port)
> +		return;
> +
> +	list_for_each_entry(mr_sas_port, &mr_sas_node->sas_port_list,
> +	    port_list) {
> +		if (mr_sas_port->remote_identify.sas_address !=3D
> +		    sas_address)
> +			continue;
> +		if (mr_sas_port->hba_port !=3D hba_port)
> +			continue;
> +		list_for_each_entry(srch_phy, &mr_sas_port->phy_list,
> +		    port_siblings) {
> +			if (srch_phy =3D=3D mr_sas_phy)
> +				return;
> +		}
> +		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy);
> +		return;
> +	}
> +}
> +
> +/**
> + * mpi3mr_del_phy_from_an_existing_port - del phy from a port
> + * @mrioc: Adapter instance reference
> + * @mr_sas_node: Internal sas node object (expander or host)
> + * @mr_sas_phy: Internal Phy object
> + *
> + * Return: None.
> + */
> +static void mpi3mr_del_phy_from_an_existing_port(struct mpi3mr_ioc *mrio=
c,
> +	struct mpi3mr_sas_node *mr_sas_node, struct mpi3mr_sas_phy *mr_sas_phy)
> +{
> +	struct mpi3mr_sas_port *mr_sas_port, *next;
> +	struct mpi3mr_sas_phy *srch_phy;
> +
> +	if (mr_sas_phy->phy_belongs_to_port =3D=3D 0)
> +		return;
> +
> +	list_for_each_entry_safe(mr_sas_port, next, &mr_sas_node->sas_port_list=
,
> +	    port_list) {
> +		list_for_each_entry(srch_phy, &mr_sas_port->phy_list,
> +		    port_siblings) {
> +			if (srch_phy !=3D mr_sas_phy)
> +				continue;
> +			mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
> +			    mr_sas_phy);
> +			return;
> +		}
> +	}
> +}
> +
> +/**
> + * mpi3mr_sas_port_sanity_check - sanity check while adding port
> + * @mrioc: Adapter instance reference
> + * @mr_sas_node: Internal sas node object (expander or host)
> + * @sas_address: SAS address of device/expander
> + * @hba_port: HBA port entry
> + *
> + * Verifies whether the Phys attached to a device with the given
> + * SAS address already belongs to an existing sas port if so
> + * will remove those phys from the sas port
> + *
> + * Return: None.
> + */
> +static void mpi3mr_sas_port_sanity_check(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_node *mr_sas_node, u64 sas_address,
> +	struct mpi3mr_hba_port *hba_port)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < mr_sas_node->num_phys; i++) {
> +		if ((mr_sas_node->phy[i].remote_identify.sas_address !=3D
> +		    sas_address) || (mr_sas_node->phy[i].hba_port !=3D hba_port))
> +			continue;
> +		if (mr_sas_node->phy[i].phy_belongs_to_port =3D=3D 1)
> +			mpi3mr_del_phy_from_an_existing_port(mrioc,
> +			    mr_sas_node, &mr_sas_node->phy[i]);
> +	}
> +}
> +
> +/**
> + * mpi3mr_set_identify - set identify for phys and end devices
> + * @mrioc: Adapter instance reference
> + * @handle: Firmware device handle
> + * @identify: SAS transport layer's identify info
> + *
> + * Populates sas identify info for a specific device.
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int mpi3mr_set_identify(struct mpi3mr_ioc *mrioc, u16 handle,
> +	struct sas_identify *identify)
> +{
> +
> +	struct mpi3_device_page0 device_pg0;
> +	struct mpi3_device0_sas_sata_format *sasinf;
> +	u16 device_info;
> +	u16 ioc_status;
> +
> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &device_pg0,
> +	    sizeof(device_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE, handle))) {
> +		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_s=
tatus(0x%04x) failure at %s:%d/%s()!\n",
> +		    handle, ioc_status, __FILE__, __LINE__, __func__);
> +		return -EIO;
> +	}
> +
> +	memset(identify, 0, sizeof(struct sas_identify));
> +	sasinf =3D &device_pg0.device_specific.sas_sata_format;
> +	device_info =3D le16_to_cpu(sasinf->device_info);
> +
> +	/* sas_address */
> +	identify->sas_address =3D le64_to_cpu(sasinf->sas_address);
> +
> +	/* phy number of the parent device this device is linked to */
> +	identify->phy_identifier =3D sasinf->phy_num;
> +
> +	/* device_type */
> +	switch (device_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) {
> +	case MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_NO_DEVICE:
> +		identify->device_type =3D SAS_PHY_UNUSED;
> +		break;
> +	case MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE:
> +		identify->device_type =3D SAS_END_DEVICE;
> +		break;
> +	case MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER:
> +		identify->device_type =3D SAS_EDGE_EXPANDER_DEVICE;
> +		break;
> +	}
> +
> +	/* initiator_port_protocols */
> +	if (device_info & MPI3_SAS_DEVICE_INFO_SSP_INITIATOR)
> +		identify->initiator_port_protocols |=3D SAS_PROTOCOL_SSP;
> +	/* MPI3.0 doesn't have define for SATA INIT so setting both here*/
> +	if (device_info & MPI3_SAS_DEVICE_INFO_STP_INITIATOR)
> +		identify->initiator_port_protocols |=3D (SAS_PROTOCOL_STP |
> +		    SAS_PROTOCOL_SATA);
> +	if (device_info & MPI3_SAS_DEVICE_INFO_SMP_INITIATOR)
> +		identify->initiator_port_protocols |=3D SAS_PROTOCOL_SMP;
> +
> +	/* target_port_protocols */
> +	if (device_info & MPI3_SAS_DEVICE_INFO_SSP_TARGET)
> +		identify->target_port_protocols |=3D SAS_PROTOCOL_SSP;
> +	/* MPI3.0 doesn't have define for STP Target so setting both here*/
> +	if (device_info & MPI3_SAS_DEVICE_INFO_STP_SATA_TARGET)
> +		identify->target_port_protocols |=3D (SAS_PROTOCOL_STP |
> +		    SAS_PROTOCOL_SATA);
> +	if (device_info & MPI3_SAS_DEVICE_INFO_SMP_TARGET)
> +		identify->target_port_protocols |=3D SAS_PROTOCOL_SMP;
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_add_host_phy - report sas_host phy to SAS transport
> + * @mrioc: Adapter instance reference
> + * @mr_sas_phy: Internal Phy object
> + * @phy_pg0: SAS phy page 0
> + * @parent_dev: Prent device class object
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int mpi3mr_add_host_phy(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_phy *mr_sas_phy, struct mpi3_sas_phy_page0 phy_pg0,
> +	struct device *parent_dev)
> +{
> +	struct sas_phy *phy;
> +	int phy_index =3D mr_sas_phy->phy_id;
> +
> +
> +	INIT_LIST_HEAD(&mr_sas_phy->port_siblings);
> +	phy =3D sas_phy_alloc(parent_dev, phy_index);
> +	if (!phy) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -1;
> +	}
> +	if ((mpi3mr_set_identify(mrioc, mr_sas_phy->handle,
> +	    &mr_sas_phy->identify))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		sas_phy_free(phy);
> +		return -1;
> +	}
> +	phy->identify =3D mr_sas_phy->identify;
> +	mr_sas_phy->attached_handle =3D le16_to_cpu(phy_pg0.attached_dev_handle=
);
> +	if (mr_sas_phy->attached_handle)
> +		mpi3mr_set_identify(mrioc, mr_sas_phy->attached_handle,
> +		    &mr_sas_phy->remote_identify);
> +	phy->identify.phy_identifier =3D mr_sas_phy->phy_id;
> +	phy->negotiated_linkrate =3D mpi3mr_convert_phy_link_rate(
> +	    (phy_pg0.negotiated_link_rate &
> +	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
> +	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
> +	phy->minimum_linkrate_hw =3D mpi3mr_convert_phy_link_rate(
> +	    phy_pg0.hw_link_rate & MPI3_SAS_HWRATE_MIN_RATE_MASK);
> +	phy->maximum_linkrate_hw =3D mpi3mr_convert_phy_link_rate(
> +	    phy_pg0.hw_link_rate >> 4);
> +	phy->minimum_linkrate =3D mpi3mr_convert_phy_link_rate(
> +	    phy_pg0.programmed_link_rate & MPI3_SAS_PRATE_MIN_RATE_MASK);
> +	phy->maximum_linkrate =3D mpi3mr_convert_phy_link_rate(
> +	    phy_pg0.programmed_link_rate >> 4);
> +	phy->hostdata =3D mr_sas_phy->hba_port;
> +
> +	if ((sas_phy_add(phy))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		sas_phy_free(phy);
> +		return -1;
> +	}
> +	if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
> +		dev_info(&phy->dev,
> +		    "add: handle(0x%04x), sas_address(0x%016llx)\n"
> +		    "\tattached_handle(0x%04x), sas_address(0x%016llx)\n",
> +		    mr_sas_phy->handle, (unsigned long long)
> +		    mr_sas_phy->identify.sas_address,
> +		    mr_sas_phy->attached_handle,
> +		    (unsigned long long)
> +		    mr_sas_phy->remote_identify.sas_address);
> +	mr_sas_phy->phy =3D phy;
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_add_expander_phy - report expander phy to transport
> + * @mrioc: Adapter instance reference
> + * @mr_sas_phy: Internal Phy object
> + * @expander_pg1: SAS Expander page 1
> + * @parent_dev: Parent device class object
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int mpi3mr_add_expander_phy(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_sas_phy *mr_sas_phy,
> +	struct mpi3_sas_expander_page1 expander_pg1,
> +	struct device *parent_dev)
> +{
> +	struct sas_phy *phy;
> +	int phy_index =3D mr_sas_phy->phy_id;
> +
> +	INIT_LIST_HEAD(&mr_sas_phy->port_siblings);
> +	phy =3D sas_phy_alloc(parent_dev, phy_index);
> +	if (!phy) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		return -1;
> +	}
> +	if ((mpi3mr_set_identify(mrioc, mr_sas_phy->handle,
> +	    &mr_sas_phy->identify))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		sas_phy_free(phy);
> +		return -1;
> +	}
> +	phy->identify =3D mr_sas_phy->identify;
> +	mr_sas_phy->attached_handle =3D
> +	    le16_to_cpu(expander_pg1.attached_dev_handle);
> +	if (mr_sas_phy->attached_handle)
> +		mpi3mr_set_identify(mrioc, mr_sas_phy->attached_handle,
> +		    &mr_sas_phy->remote_identify);
> +	phy->identify.phy_identifier =3D mr_sas_phy->phy_id;
> +	phy->negotiated_linkrate =3D mpi3mr_convert_phy_link_rate(
> +	    (expander_pg1.negotiated_link_rate &
> +	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
> +	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
> +	phy->minimum_linkrate_hw =3D mpi3mr_convert_phy_link_rate(
> +	    expander_pg1.hw_link_rate & MPI3_SAS_HWRATE_MIN_RATE_MASK);
> +	phy->maximum_linkrate_hw =3D mpi3mr_convert_phy_link_rate(
> +	    expander_pg1.hw_link_rate >> 4);
> +	phy->minimum_linkrate =3D mpi3mr_convert_phy_link_rate(
> +	    expander_pg1.programmed_link_rate & MPI3_SAS_PRATE_MIN_RATE_MASK);
> +	phy->maximum_linkrate =3D mpi3mr_convert_phy_link_rate(
> +	    expander_pg1.programmed_link_rate >> 4);
> +	phy->hostdata =3D mr_sas_phy->hba_port;
> +
> +	if ((sas_phy_add(phy))) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		sas_phy_free(phy);
> +		return -1;
> +	}
> +	if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
> +		dev_info(&phy->dev,
> +		    "add: handle(0x%04x), sas_address(0x%016llx)\n"
> +		    "\tattached_handle(0x%04x), sas_address(0x%016llx)\n",
> +		    mr_sas_phy->handle, (unsigned long long)
> +		    mr_sas_phy->identify.sas_address,
> +		    mr_sas_phy->attached_handle,
> +		    (unsigned long long)
> +		    mr_sas_phy->remote_identify.sas_address);
> +	mr_sas_phy->phy =3D phy;
> +	return 0;
> +}
> --=20
> 2.27.0
>=20

--
Himanshu Madhani	Oracle Linux Engineering

