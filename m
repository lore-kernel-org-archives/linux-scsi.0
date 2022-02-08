Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DD8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 19:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386006AbiBHTXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385664AbiBHTXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:23:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB50C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:23:00 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218J6vLG027133;
        Tue, 8 Feb 2022 19:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cl67RSYtVL55FsqilH6oYHGjB9keuG5Xq0Nq3syff2U=;
 b=JpEwmBUotcb5OFxMSjZNyr8pRzRasNVX67cLOxKfJEXTPmSm9pY0HTPgo3TzHTiOXmaB
 MLSkO/yJ+NWThzxkBs6ZZnt1aVwZp35ohzq18NiXahAeRNG1c/x+jFCEyPyxvxWne22t
 UG/c006tdYsbNSIe1KjtAvZoRt4mL8WfeG9Tn1cMnW13DEKFPHFpWuR1lVltQQa8ua5U
 I360C5vjAUY6WaIsW2a8t7Y94RJMXVUlMuvgkpVgnkZ+IE0lVHxQPHu5zp8ZHSrnw80T
 1we8PV4h7rSjYGxd4wyCIJLhfKhUUx3rs+uwVt10tP88FFuKfPmINYGtNPCfbSOmq6ky kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28jbuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JG7Z0024712;
        Tue, 8 Feb 2022 19:22:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 3e1f9fwe69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCxyd8EB3oCn4yuVTRWyWUdYxQQhQp99D7x9A2QRJs5q2mcxrePPpixCx9cv8d+oDQNXaYI6i+q7s3iBpkYD8CV0DpAPCVEgx1/8cVl0Ss61RVjmqrcD6p7yiPSnr3pKchJmlQzMhiL8jBBis1EV4Gkmd/CdxODKlE0dXDeOtw9zbrngU0cAU6AJ2LKeHAfsLSCehG2pfzXRdprki5mwA4FWb1/hNuZMuda2LK/kkwgqJ6zBW95bQ8QNwnIITFq3t8shR63/GcBcTgT9f6kPb7OnUA4MmXHYXSOx73NjKVZa/sJ9DDvwupx5kmuOQ8rIi0Vp9UQTzWlhR5l/BOulpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl67RSYtVL55FsqilH6oYHGjB9keuG5Xq0Nq3syff2U=;
 b=JhUeEbUUlguK4MzEy/z/YDuAL7Vtz4NOT+1UDBbdDs+U5c+jsR10/jChKKdcdEKAlT9D1Bhiho7oJeYlW0q9K6+WtAPsZ1wSP/ULNL+1OInyAz5DEbSMbzee1OA5hD+4kxPqhrR4WQQRWvku7Jiz/SH4nTzgSzzpSUWRdb76Eo1CLN0lkeWP13+9B1tjgcxVXWGfk+TpTKpLGo5wJWY0oVK+3GjCuGaGF5wzX03ytBhX129wof+BkHc/tM3yFOTeQGMLzREitTPlY60ktI0aWTzAM5WZK6kkhxkxKk/DTW2fAqwMTx67vT/Ot2boOQPeQVCAZn14vrcAKran2vPN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl67RSYtVL55FsqilH6oYHGjB9keuG5Xq0Nq3syff2U=;
 b=uYn4qI+pXcMxeFfBAxJ1+7kIOTajUb0Y9E9trvdARtwF3hKF5qAzXwSjmJ6QHJg1edrpIOgfcRkiSYWdLEV8cRCVbrbNQtTfyl/uFbjiy/vs/Wur1a5raV7VxeowDQ1IDpUBlZTPUReBhz5QRwZKT093te922FWzOT1ZNIVTKWs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB2969.namprd10.prod.outlook.com (2603:10b6:5:6a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 8 Feb
 2022 19:22:21 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:22:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 03/44] scsi: Remove drivers/scsi/scsi.h
Thread-Topic: [PATCH v2 03/44] scsi: Remove drivers/scsi/scsi.h
Thread-Index: AQHYHREebvUIH2umRkWxmT5r4anjN6yKCD8A
Date:   Tue, 8 Feb 2022 19:22:20 +0000
Message-ID: <04F71D0B-DDFC-491A-B174-4DA49DAFA0D5@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-4-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8b6b728-b19d-42d1-6171-08d9eb385418
x-ms-traffictypediagnostic: DM6PR10MB2969:EE_
x-microsoft-antispam-prvs: <DM6PR10MB29690797AE091E3F37978E37E62D9@DM6PR10MB2969.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2y9mGnS74vskC0WxyLa8O5dhWxW+zkIG7VrGIjmrWkXK1nHubNLqx/NZ0CJ0P3sdxypO1T2Gj8vh00G89D7d7EZfEhz39nW7sbc7X9xTy3Rm4X5aF4Sc1RoWI8tIHf0C0d+kjP9fMO0uMJDB3eMHyBl2osWdco0HSjIoH8Gh8KvfpXKskD9X7h1fHI+Qtbq83QZb1xIWzQGrWWYd+gwU/wxMppY5T3EYp2ySf7xkorZ3JdS9NLIzKsNGdzPrOutub5DgWGDWAiowr++NUvRm2ZiMIDcWqQed6fKJ+gSdL9Aap2Qo/stdciuf9M/xK+dC8okmHo5ta8DI5Dpd7LEYmKDE3m9l2//W/3Fid+qhPVquOyqZkHWzbHDgDndUPyAzlEnqqr/uV0oRLVLH50NtioA2dr/jUKur83m/vZ5HCq/bBToweSoh/gyWsn0Z8VkpO0I+RJ0un2KDIiv1zARo7oIODboC4Pm6dKdHvMIJNk6spI/wkm4loBm1ZXhM9lHMIbaPXbFsvU45KiqGScp0v1LpMgxChH+R9ymYVAP7r1+3fauZqU+zoVfDmH6ibPrTRwZgyk/EGJFrQ50UB739mtM0n3h/A6m9Tx9Ic1YP2RB8CTxRZemNoonY5BIMZWfAblrz6mBey04UiR9amSGB/4N41YqY4WhTHSdNHrZcAagkAEEvzVRISKR4OhunB1HEhkUbj3rkVrXQWn/OqpqSOhj+U298S+ewOO5YYazVII=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(86362001)(38070700005)(66556008)(4326008)(36756003)(91956017)(38100700002)(66946007)(76116006)(8936002)(66446008)(66476007)(54906003)(316002)(6916009)(64756008)(83380400001)(30864003)(44832011)(7416002)(6486002)(508600001)(71200400001)(6512007)(2906002)(6506007)(33656002)(2616005)(5660300002)(53546011)(8676002)(26005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0cz5DvuVJf64hCFIH4qx2vriD9M96IK4/n+gejzeftNDW2F//QsvgCjJgp8u?=
 =?us-ascii?Q?rQ26J9S+w6JMXgyCVxKw9k/GyWxPjFKV8UCf189si2DkHw+PqMJ3BTR7foJw?=
 =?us-ascii?Q?uZW2FJ2lvimdYZkRzLk7N/SveIHFHvo+TU4bCCeL+NAOy0hsjiXtSu69KWrq?=
 =?us-ascii?Q?MSAy8oAY9jaBR2YRnaJg9OpXvMyPM6IyeloLymhW1bFGhjFH08kuisYiqowj?=
 =?us-ascii?Q?hGWH37WbMZdnnMbJ0ozX2EoMfhX/EqtmXt5OfzflQLf3e5aaB/Fy4TNRJqje?=
 =?us-ascii?Q?iM51IxaNVOqqm14vhWao7ACObDj3Ui8TrjHpNc1aGmm8N4Qiz22JbP/rMDyJ?=
 =?us-ascii?Q?bPUmmbsn2clYfxx+MVUm8A73QhCvZWCzF/iwds7yG9F4LkLvpvx/CMLsm3Sz?=
 =?us-ascii?Q?nehX01ZQhVoLgKSLRe46sty2nbVVnUZ/bF6+h4K2cYSGF0NDRs6cr/ej+35d?=
 =?us-ascii?Q?IJby9X8VSvsW4avPqwBOf1dS9UTxRA+dn7F/U1dmww4uHD22p7xRqHusq3IF?=
 =?us-ascii?Q?6nhB43XA9nSKUAsHUn8W1BiGlNj2RAKhgr6RLFjaQWDTBLAcfz29F2HJznj+?=
 =?us-ascii?Q?fWISLcAYRQFklu1Qnm7vLo5mdzB4qGU0aCs6Z5u9DNOrHZewZkdjgqWmThGo?=
 =?us-ascii?Q?QO6D2K9B8lS2X1L7/Rt9cLQ8ba+cfaw1ZvOwsHWL0iAvfCSt5rggwfBOFYrM?=
 =?us-ascii?Q?qxwHNR2+7Gu2yM9wpp/ud1v75UWFLqs2z+kWf7xAisOEtQn5H4ILoQlaFxkk?=
 =?us-ascii?Q?TeKM5UbTksMuHMisxLHpHEpmZOwWrpgWosGLCUE5vDjCSBeI133KslRW/hdC?=
 =?us-ascii?Q?boiRs/3FaXjlltLo81Y1A9FpQeKeB11yEqsNSS7E0INBrC7M0dCWXIdILSsF?=
 =?us-ascii?Q?SON2dXCza88BMtu8V6kH0eSf6AgvbdNHmwX/MNJRGO9w3FLL0bpDzrvlVNs3?=
 =?us-ascii?Q?Je15mjEbU+6aMYyR7JM4c//UjLSQpay++QGEQlVg2krLL4JXt0pkFkQkJ15a?=
 =?us-ascii?Q?j58pyd9XymtiQyK8T641WN1C0pxGH7gCp3A9fdm2J/6vUlSTidckhqJgJHPY?=
 =?us-ascii?Q?0pF/DIADWlSVx6Q9K81ZA8EEOBFJCdKmUovFWlPqEcMxajW9F4jOSLK4AzeQ?=
 =?us-ascii?Q?VhCoIiQVpig+5hWFIUkvWgU3hYXMlECRWP7Wr5W8ytd/dlt42bgd6ahCfkJQ?=
 =?us-ascii?Q?cGinod3AdKpzlxySXNXsTBdTFkuXKmjDqSzwzdu+qw61RinGEohDtA150TeH?=
 =?us-ascii?Q?BEDJuQdhruyrC9waV6SZ18XmFSA0zdsIxBX3eWWFM6GlkRmdXXuRekD/VXar?=
 =?us-ascii?Q?KnB2zw/Em9ez6G3IDkJ3xLe6ef6emZjddE5GTZCs9vRJg1cM6vVn2l7O75UK?=
 =?us-ascii?Q?2kZo+0Em133LL9dNo9a+KmnPqlE4HcA66B/Xq3T/ZiR80VPyWCkicLSpswUs?=
 =?us-ascii?Q?ZbNpYQ5NbFrTTZQGfUF0lp76tCQzlkmV+b4u/WGMvt+zGVpGJhGPDm/aIHJo?=
 =?us-ascii?Q?ESv/rFzI+YZiOTRosuxgq+dT1Q4XNG6OXlPmk9zXih/Qd778mubSFgTsgeqI?=
 =?us-ascii?Q?4H+po3PfYRmpOueUT00FZB8btpfHO0QyzzFZKYj5VK/dv4+YcXXBfdH3hLKO?=
 =?us-ascii?Q?ZOTkO+3l0Mx9HwGmmYV8vzcmsH5msYwS5nGUBiGdFh2FTL7YEPTQ3C2PpDAz?=
 =?us-ascii?Q?BzANNxuwsr98Zw2POKgg/Xh8Qlc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7FDC2D4BB476EC46AB0B4E8EDA7552A7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b6b728-b19d-42d1-6171-08d9eb385418
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:22:21.0122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mp4RiKN/8xgkgFvAXMl2gzGLtc9vARCV8GKs0W8L/txZMrcyDlLfWrie8IzmbTa5WqLicrXVtJkUuwpsOo8lrWd4rWEMcxhfC7Tc87zfNhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2969
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080114
X-Proofpoint-ORIG-GUID: NgoQv7su2BK94xhB3HXUDRO4hWvPe7QG
X-Proofpoint-GUID: NgoQv7su2BK94xhB3HXUDRO4hWvPe7QG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> The following two header files have the same file name: include/scsi/scsi=
.h
> and drivers/scsi/scsi.h. This is confusing. Remove the latter since the
> following note was added in drivers/scsi/scsi.h in 2004:
>=20
> "NOTE: this file only contains compatibility glue for old drivers. All
> these wrappers will be removed sooner or later. For new code please use
> the interfaces declared in the headers in include/scsi/"
>=20
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/a2091.c               |  6 +++-
> drivers/scsi/a3000.c               |  6 +++-
> drivers/scsi/aha152x.c             |  9 ++++--
> drivers/scsi/aha1740.c             |  6 +++-
> drivers/scsi/arm/acornscsi.c       |  6 +++-
> drivers/scsi/arm/arxescsi.c        |  6 +++-
> drivers/scsi/arm/cumana_2.c        |  6 +++-
> drivers/scsi/arm/eesox.c           |  6 +++-
> drivers/scsi/arm/fas216.c          |  6 +++-
> drivers/scsi/arm/powertec.c        |  6 +++-
> drivers/scsi/arm/queue.c           |  6 +++-
> drivers/scsi/gvp11.c               |  6 +++-
> drivers/scsi/ips.c                 |  8 ++++--
> drivers/scsi/megaraid.c            |  8 ++++--
> drivers/scsi/mvme147.c             |  6 +++-
> drivers/scsi/pcmcia/aha152x_stub.c | 10 +++++--
> drivers/scsi/pcmcia/nsp_cs.c       |  5 ++--
> drivers/scsi/pcmcia/qlogic_stub.c  | 10 +++++--
> drivers/scsi/qlogicfas.c           |  6 +++-
> drivers/scsi/qlogicfas408.c        |  6 +++-
> drivers/scsi/scsi.h                | 46 ------------------------------
> drivers/scsi/sg.c                  |  8 ++++--
> drivers/scsi/sgiwd93.c             |  6 +++-
> drivers/usb/image/microtek.c       |  8 ++++--
> drivers/usb/storage/debug.c        |  1 -
> 25 files changed, 121 insertions(+), 82 deletions(-)
> delete mode 100644 drivers/scsi/scsi.h
>=20
> diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
> index 5853db36eceb..bcbce23478b8 100644
> --- a/drivers/scsi/a2091.c
> +++ b/drivers/scsi/a2091.c
> @@ -12,7 +12,11 @@
> #include <asm/amigaints.h>
> #include <asm/amigahw.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>
> #include "wd33c93.h"
> #include "a2091.h"
>=20
> diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
> index 86f1da22aaa5..23f34411f7bf 100644
> --- a/drivers/scsi/a3000.c
> +++ b/drivers/scsi/a3000.c
> @@ -13,7 +13,11 @@
> #include <asm/amigaints.h>
> #include <asm/amigahw.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>
> #include "wd33c93.h"
> #include "a3000.h"
>=20
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index d17880b57d17..901b78e8ffe6 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -243,13 +243,16 @@
> #include <linux/workqueue.h>
> #include <linux/list.h>
> #include <linux/slab.h>
> -#include <scsi/scsicam.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include <scsi/scsi_transport_spi.h>
> -#include <scsi/scsi_eh.h>
> +#include <scsi/scsicam.h>
> #include "aha152x.h"
>=20
> static LIST_HEAD(aha152x_host_list);
> diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
> index 18eb4cfcef9a..134255751819 100644
> --- a/drivers/scsi/aha1740.c
> +++ b/drivers/scsi/aha1740.c
> @@ -55,8 +55,12 @@
> #include <asm/dma.h>
> #include <asm/io.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "aha1740.h"
>=20
> /* IF YOU ARE HAVING PROBLEMS WITH THIS DRIVER, AND WANT TO WATCH
> diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
> index 81eb3bbdfc51..a8a72d822862 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -126,9 +126,13 @@
>=20
> #include <asm/ecard.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include <scsi/scsi_transport_spi.h>
> #include "acornscsi.h"
> #include "msgqueue.h"
> diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
> index 7f667c198f6d..2527b542bcdd 100644
> --- a/drivers/scsi/arm/arxescsi.c
> +++ b/drivers/scsi/arm/arxescsi.c
> @@ -35,8 +35,12 @@
> #include <asm/io.h>
> #include <asm/ecard.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "fas216.h"
>=20
> struct arxescsi_info {
> diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
> index 3c00d7773876..536d6646e40b 100644
> --- a/drivers/scsi/arm/cumana_2.c
> +++ b/drivers/scsi/arm/cumana_2.c
> @@ -29,8 +29,12 @@
> #include <asm/ecard.h>
> #include <asm/io.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "fas216.h"
> #include "scsi.h"
>=20
> diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
> index 1394590eecea..ab0f6422a6a9 100644
> --- a/drivers/scsi/arm/eesox.c
> +++ b/drivers/scsi/arm/eesox.c
> @@ -35,8 +35,12 @@
> #include <asm/dma.h>
> #include <asm/ecard.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "fas216.h"
> #include "scsi.h"
>=20
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 7019b91f0ce6..0d6df5ebf934 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -47,9 +47,13 @@
> #include <asm/irq.h>
> #include <asm/ecard.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "fas216.h"
> #include "scsi.h"
>=20
> diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
> index 8fec435cee18..797568b271e3 100644
> --- a/drivers/scsi/arm/powertec.c
> +++ b/drivers/scsi/arm/powertec.c
> @@ -20,8 +20,12 @@
> #include <asm/ecard.h>
> #include <asm/io.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "fas216.h"
> #include "scsi.h"
>=20
> diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
> index c6f71a7d1b8e..978df23ce188 100644
> --- a/drivers/scsi/arm/queue.c
> +++ b/drivers/scsi/arm/queue.c
> @@ -20,7 +20,11 @@
> #include <linux/list.h>
> #include <linux/init.h>
>=20
> -#include "../scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>
>=20
> #define DEBUG
>=20
> diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
> index 727f8c8f30b5..43754c2f36b3 100644
> --- a/drivers/scsi/gvp11.c
> +++ b/drivers/scsi/gvp11.c
> @@ -12,7 +12,11 @@
> #include <asm/amigaints.h>
> #include <asm/amigahw.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>
> #include "wd33c93.h"
> #include "gvp11.h"
>=20
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index b3532d290848..021143bdee5f 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -180,9 +180,13 @@
> #include <linux/types.h>
> #include <linux/dma-mapping.h>
>=20
> -#include <scsi/sg.h>
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> +#include <scsi/sg.h>
>=20
> #include "ips.h"
>=20
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index bf987f3a7f3f..2061e3fe9824 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -44,10 +44,14 @@
> #include <linux/dma-mapping.h>
> #include <linux/mutex.h>
> #include <linux/slab.h>
> -#include <scsi/scsicam.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> +#include <scsi/scsicam.h>
>=20
> #include "megaraid.h"
>=20
> diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
> index 869b8b058a43..0893d4c3a916 100644
> --- a/drivers/scsi/mvme147.c
> +++ b/drivers/scsi/mvme147.c
> @@ -11,8 +11,12 @@
> #include <asm/mvme147hw.h>
> #include <asm/irq.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "wd33c93.h"
> #include "mvme147.h"
>=20
> diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha=
152x_stub.c
> index df82a349e969..332c6d573904 100644
> --- a/drivers/scsi/pcmcia/aha152x_stub.c
> +++ b/drivers/scsi/pcmcia/aha152x_stub.c
> @@ -40,13 +40,17 @@
> #include <linux/slab.h>
> #include <linux/string.h>
> #include <linux/ioport.h>
> -#include <scsi/scsi.h>
> #include <linux/major.h>
> #include <linux/blkdev.h>
> -#include <scsi/scsi_ioctl.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_tcq.h>
> #include "aha152x.h"
>=20
> #include <pcmcia/cistpl.h>
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index a78a86511e94..dcffda384eaf 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -41,10 +41,9 @@
> #include <asm/io.h>
> #include <asm/irq.h>
>=20
> -#include <../drivers/scsi/scsi.h>
> -#include <scsi/scsi_host.h>
> -
> #include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> #include <scsi/scsi_ioctl.h>
>=20
> #include <pcmcia/cistpl.h>
> diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlog=
ic_stub.c
> index 828d53faf09a..1c21d1b12988 100644
> --- a/drivers/scsi/pcmcia/qlogic_stub.c
> +++ b/drivers/scsi/pcmcia/qlogic_stub.c
> @@ -38,14 +38,18 @@
> #include <linux/string.h>
> #include <linux/ioport.h>
> #include <asm/io.h>
> -#include <scsi/scsi.h>
> #include <linux/major.h>
> #include <linux/blkdev.h>
> -#include <scsi/scsi_ioctl.h>
> #include <linux/interrupt.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_tcq.h>
> #include "../qlogicfas408.h"
>=20
> #include <pcmcia/cistpl.h>
> diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
> index 8f709002f746..8f05e3707d69 100644
> --- a/drivers/scsi/qlogicfas.c
> +++ b/drivers/scsi/qlogicfas.c
> @@ -31,8 +31,12 @@
> #include <asm/irq.h>
> #include <asm/dma.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "qlogicfas408.h"
>=20
> /* Set the following to 2 to use normal interrupt (active high/totempole-
> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
> index 30a88849a626..3e065d5fc80c 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -55,8 +55,12 @@
> #include <asm/irq.h>
> #include <asm/dma.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include "qlogicfas408.h"
>=20
> /*----------------------------------------------------------------*/
> diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
> deleted file mode 100644
> index 4fd75a3aff66..000000000000
> --- a/drivers/scsi/scsi.h
> +++ /dev/null
> @@ -1,46 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - *  scsi.h Copyright (C) 1992 Drew Eckhardt=20
> - *         Copyright (C) 1993, 1994, 1995, 1998, 1999 Eric Youngdale
> - *  generic SCSI package header file by
> - *      Initial versions: Drew Eckhardt
> - *      Subsequent revisions: Eric Youngdale
> - *
> - *  <drew@colorado.edu>
> - *
> - *       Modified by Eric Youngdale eric@andante.org to
> - *       add scatter-gather, multiple outstanding request, and other
> - *       enhancements.
> - */
> -/*
> - * NOTE:  this file only contains compatibility glue for old drivers.  A=
ll
> - * these wrappers will be removed sooner or later.  For new code please =
use
> - * the interfaces declared in the headers in include/scsi/
> - */
> -
> -#ifndef _SCSI_H
> -#define _SCSI_H
> -
> -#include <scsi/scsi_cmnd.h>
> -#include <scsi/scsi_device.h>
> -#include <scsi/scsi_eh.h>
> -#include <scsi/scsi_tcq.h>
> -#include <scsi/scsi.h>
> -
> -/*
> - * Some defs, in case these are not defined elsewhere.
> - */
> -#ifndef TRUE
> -#define TRUE 1
> -#endif
> -#ifndef FALSE
> -#define FALSE 0
> -#endif
> -
> -struct Scsi_Host;
> -struct scsi_cmnd;
> -struct scsi_device;
> -struct scsi_target;
> -struct scatterlist;
> -
> -#endif /* _SCSI_H */
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 6b43e97bd417..bbd75026ec93 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -49,11 +49,15 @@ static int sg_version_num =3D 30536;	/* 2 digits for =
each component */
> #include <linux/uio.h>
> #include <linux/cred.h> /* for sg_check_file_access() */
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_dbg.h>
> -#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> #include <scsi/scsi_driver.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_host.h>
> #include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_tcq.h>
> #include <scsi/sg.h>
>=20
> #include "scsi_logging.h"
> diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
> index cf1030c9dda1..e797d89c873b 100644
> --- a/drivers/scsi/sgiwd93.c
> +++ b/drivers/scsi/sgiwd93.c
> @@ -28,7 +28,11 @@
> #include <asm/sgi/ip22.h>
> #include <asm/sgi/wd.h>
>=20
> -#include "scsi.h"
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_tcq.h>
> #include "wd33c93.h"
>=20
> struct ip22_hostdata {
> diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
> index b8dc6fa6a5a3..874ea4b54ced 100644
> --- a/drivers/usb/image/microtek.c
> +++ b/drivers/usb/image/microtek.c
> @@ -130,11 +130,15 @@
> #include <linux/spinlock.h>
> #include <linux/usb.h>
> #include <linux/proc_fs.h>
> -
> #include <linux/atomic.h>
> #include <linux/blkdev.h>
> -#include "../../scsi/scsi.h"
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
>=20
> #include "microtek.h"
>=20
> diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
> index d7f50b7a079e..576be66ad962 100644
> --- a/drivers/usb/storage/debug.c
> +++ b/drivers/usb/storage/debug.c
> @@ -36,7 +36,6 @@
>=20
> #include "usb.h"
> #include "debug.h"
> -#include "scsi.h"
>=20
>=20
> void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *sr=
b)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

