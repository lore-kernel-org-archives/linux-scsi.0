Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32CDECAAA2
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 22:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiHYWJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 18:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235432AbiHYWJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 18:09:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CED804A1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 15:09:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PLK9Sj016920;
        Thu, 25 Aug 2022 22:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bhmpIYnkUWmbeFk7JHgrrd2qu2h21ymYsYjspjz6NQ0=;
 b=eLvOVCEhiNloU8LscoDzboSEz2E8PUXpnPOq8t8oTPf2oYHC+7VmH106S0d3Gro/x0Ao
 grCTGnJUgG5Qp8NokN5OklamLmD8OI8ge+ak4u9hRri0bW5yWzfoyF2Qj8lIexFK27GE
 rgyIypoqu1woxELpw0g9rU3VvLoYQ59tia5fwpHCoau6+kNHdqb2cxfW6WZtyfFA/2DG
 Ptsbo9zW4kYaWgakJzHOAa5rqCROYUcB/2Fa0NU+6KKT1/GqAeIENiNhf9THs7BK+l5k
 ETYbG8hNssF8B+TJQwqHL4BJjm63FVCWsDu4W0vkgazX9FR6L0XXNaJQp6zdoBsvj1MZ qA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5awvnpv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 22:04:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PK2IlF039461;
        Thu, 25 Aug 2022 22:04:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4n18xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 22:04:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvvGaVGetC3WISLh9rYaRBmu7HjWjIYz2u1CPlENz4IxDm1OohgirX+7XSIGj1XI8q7wtgshaxe3Zjywxpnkk2Da8Q/aq0FkBtfNmteSUB961QsSzO4Frxa8Mkjay/MMM95s7gerjGuntkOB9L+CeTJo5+52tnvcRgFYsIhb0sB4vK/Xl/ThU3fjBAejwU8VPi1H/xl2fQRMKc+FVQ3VlWKyQMmTZzbENqzaB3j2BHO8vbwlYkbfiPnZwC0+z1glpx5UHLlL+t0WJhAWUOGnl8FIsVUFQcyTmq5YACR2E/o6RZE4nNYvKhvi4EYnx+sxnYl/Epx5L52C0u0QfK7FCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhmpIYnkUWmbeFk7JHgrrd2qu2h21ymYsYjspjz6NQ0=;
 b=EKZHx5dSBCQgOFSZPrLBQOK4WNSSBwc0AZvb9U4ni5WAxbMl+6UH6GbRJfynoclGJyGNglvhWnFotrlmOk0Pahj8cUvTq29DpaeTOnZDQ7Qrery1x2ZfH0nlkCw+/LemloUVw7KIMzHFgj0YgtbK+GO5i3//pL+9n8UXSubQJjUH9bjbhh20WssOAphdHt/QHxUu5t3zvwxkBlSO1tNZG7h5wZ6YCjI1ZoiY5+ew+7N8utQrJgcHaAC+w55bNi5uSx6FjKbFC9ZSka5Fiw8KboXGzC6/ca0wIHQmjh92A6MNn6Y8CcHz+jmSiPjOUkcnXQG1BZx19A/WFthWt7INNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhmpIYnkUWmbeFk7JHgrrd2qu2h21ymYsYjspjz6NQ0=;
 b=Czb9G+Bqw0q9uHr4cDxocToPqDQkPkHQYT1sVBXWED3t/CAGttt95ieQT2lL6rWmjhj/jhdfadzkOxI1kQeIZQQkyC8NlkYQcHqwFr7k0263rn0U9j5Kf5QLe6EpC/qwd9E0mF1voFE1CpOSSU/qjUGF7gpEP/4ixplq3PxwKsQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB6082.namprd10.prod.outlook.com (2603:10b6:510:1fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 22:04:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 22:04:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND] scsi: qla2xxx: log message "skipping
 scsi_scan_host()" as informational
Thread-Topic: [PATCH RESEND] scsi: qla2xxx: log message "skipping
 scsi_scan_host()" as informational
Thread-Index: AQHYuHqGLP5awdn9nU+ALacDaAbJxa3ALEqA
Date:   Thu, 25 Aug 2022 22:04:20 +0000
Message-ID: <032AA004-8C5A-4BEA-84A3-5AA2EDB5D000@oracle.com>
References: <20220825120159.275051-1-mfo@canonical.com>
In-Reply-To: <20220825120159.275051-1-mfo@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07b27460-3d33-4bcd-394d-08da86e5c2e3
x-ms-traffictypediagnostic: PH7PR10MB6082:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DjdpyEA6VRMsy8KsHh9F14S46fE66LySccB9xLuY147uvk04fe/iyO9z/H/f4EILFKAKFL5HmT7j+wmjNSq6cobqiBW8w2/jTkkFXnA/8ShK8vbe1hB1m5279eKbd4LLBGTQeZnwHcXGgrj1xNYr+XbID7XK4aKoRMZaF2UEe2wxwiKQ5xjNfJwykgYphcBUbXYcnM06AbjIQJZ+/jrhJPR5alKHWQ0hyLR097ScGmoKzNLWJkc+69NRga7ZD0aZcgc8O9OvdNPtUEMTJIruZnSUDOYkxPUkka50EdxP2GJbWSrQp2RdnnySvI13EwSb2sfrxGmSeYvs+VJAjuFJ/QGVyKqKgTuUmBGwsOyWjtB/Twmvpy7M8AC3Qxe4h+mUsg77pqYTBVz8W80m7v3YYTM8Im/dDNXgR/67OIlQ8dSNpbRFB9RzEx4qQ+r7U5O8dYh8QzGPpfmBn4OKAEG6isvJyO/BezqmVr04/wtHoLLeOjnyZfzg0Sx0RqwOsYN4sOmpwlfrDY+wIykz5GQSeJLaKBvgj1/4yepYSQhV0+5E6nsb3FBDq3jBTA6TXA9O+jPCUEHSJ5G/3yWvkqQqISs0dNkWohm1bFxSAmYsRsiEpuzIt5C6vQjubiXiiva2HerfwsKLYY5bvYJUK/FKeFuWc75CRPLy9eRi7hooto5A6dFVIi4k3dh1Dkf4MmbiknFqitC9Fw48hiihavjmQkl6l2bjfUJ0+ConzmJfMLL8RiHP9JDlVb8Xobwb4vaagXUbGG7NItV89gYVcvw5VdgSLuQCmoI6PqviD2JOeTA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39860400002)(136003)(366004)(6506007)(2906002)(15650500001)(38100700002)(6512007)(26005)(53546011)(83380400001)(186003)(122000001)(2616005)(478600001)(8676002)(6486002)(33656002)(64756008)(91956017)(66946007)(76116006)(36756003)(66446008)(71200400001)(66556008)(4326008)(316002)(6916009)(54906003)(44832011)(5660300002)(8936002)(86362001)(41300700001)(38070700005)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HmKte7Lq0+pfdt3yTjlFrAVe18hF1IWykJXo/jxlAcSVnSvxfgMRDL2wmVzE?=
 =?us-ascii?Q?XjUBteCUM6bBxgWIeqt1YicT+4sKxdwW/tYmVmTTgAULuuKYBdGPQDRJpNJU?=
 =?us-ascii?Q?wIRpsPM6b86fMJpUcKXd+V8CuNQ3qkEQhGrP13rlFj3LoBgUqlMDB2IeSVzR?=
 =?us-ascii?Q?8ntaBGeevzTZlPscYnONCVm3PVg+S0W5fJzWGfqX4YXLl5TA6yg+wZvzTxuW?=
 =?us-ascii?Q?EXFV3t7V2cENG0k0ijk5OxXa76YerQhHCSGMFTJbuez7yiXhhZWdw06x6/K+?=
 =?us-ascii?Q?hR5FswH4ePVqjfQu/VF/7RfFps88gocBe/xJ6I+1LyAqlopVnGKgkcDfIx6U?=
 =?us-ascii?Q?/3c7DzP56/yFRwiM9ZvQzeFxVRNbRDlRiN7kjzhnem9zrGJuQiz7ity2dwxd?=
 =?us-ascii?Q?8oJDEjZhW7nU3/O6lbW59RwyhDL7a71FyZ4/6SNFh/NqRIhGBWPPUe2CSR5v?=
 =?us-ascii?Q?vwPiWv9RSCFmt0eY4N1J/p1uyrzzbZQd46K4Ra6QhnXCZx0vYBigDw6CKpUi?=
 =?us-ascii?Q?dLuMXJW2mG81W8kYOa5fnOougCuw8IetOae5hNjsD2sMg7iKVUImlCLHwhQz?=
 =?us-ascii?Q?+INTjD5KXT2VvF48IYBW1fcopGvdr/SnHbGibYQ7gotm4X2fJX5e9C8TpH4V?=
 =?us-ascii?Q?T5z0v+INZqLqXV7ljbNQbXCE2ROfZUm0tpflJlBhtLabVyM1UOKWBfHQfjg4?=
 =?us-ascii?Q?oc8vvT+kl9/kvrQD3kL40gKnwV1Hp+sfuCZRvUF7sBREvr8aIMox4EulRrqF?=
 =?us-ascii?Q?Gu9dNqsiMR5nop0SDz/8s8uDHF43LorosDgW5cFeZz/SWrZS6dwg5HvrLesE?=
 =?us-ascii?Q?HdypNYVg7SRg7efHzrhRjGs3WTN7lrTulzJwRd4SmNSiS1CIVDR5CxJbplCV?=
 =?us-ascii?Q?LTZY4wTbsT2lTHd0aP1xrlpY240wWs7/P7kWAODA63sACdrqZ0rE1Drl0XWo?=
 =?us-ascii?Q?m7z32dC8CFHA9GTTVZKh+NhRusEUDOJdwAdtTrSPSt+8aTzXB1Y3iQ8hn2G9?=
 =?us-ascii?Q?xcR9yhv4MGWIiRr6fD4ufUaDsp6Tft+FmEWimxlEC7ytttTevmQHe+DXjUbo?=
 =?us-ascii?Q?flgx0TO3rh3HNJnh5LaFVUi2nPYrVaeBBS+QWN+I5Mhj+CWBdYrqtqlNQDzs?=
 =?us-ascii?Q?+3uKUkKzudlTTDOkke0Y/gdXcfmvgT+x84JF4kXXHSs8EQQnp+U3S5IkUD9D?=
 =?us-ascii?Q?CXfc9Ftfwj9LeZZlY1amMXdqB61dfWvGgeYu9sK5i9Vqb5lVRpw1kQ599hw0?=
 =?us-ascii?Q?awiiNj4dNhNTgJqGYblU/geKxFnPWpkkgQ5DFYvJ50qBPBK8VvQCZUFAXk76?=
 =?us-ascii?Q?ENjyi+38b/lPuKh3NsZqFqZUeS2hi4PLAdUhGH+yKUTDnG37and2o5XxNmp+?=
 =?us-ascii?Q?bAqZvI/4Bm6NaXWg4KNg/YZ1NmNCkNwvmmfLcx5Twu3iQ2WSn8XDbCxjwokr?=
 =?us-ascii?Q?hsoQcGrOKp5O4RNmR38fQnWGjLs7KNTBBHz/RpRJSBAZ6FSmI3LsA+okXmtH?=
 =?us-ascii?Q?9uG379fiaxeaWkv5KFXjcx5oxcSiQSr17+70O3WDZVdY5w9mxeBm8AT3vLEP?=
 =?us-ascii?Q?gjKjmtawOz7nCJz3A0A7IPSfZR5nUq/A2srCTADXlXn2UohKI8Sqz/iADzhF?=
 =?us-ascii?Q?QA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FFE640271CF16F4792453D56CC955447@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b27460-3d33-4bcd-394d-08da86e5c2e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 22:04:20.1181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u61AtlrHIWoY6hFtv2OhnULTwAWSu9nlz+EPRmUX99ltbbWkZRg9kdLQwJlfc1aBOuI1DgkSj6CKgio1m4cScK00NJpX9XvgQFDm/rSMebU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_10,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250085
X-Proofpoint-ORIG-GUID: 3lGyv9w51WkKzotJP6HsFZEnvDhR_-db
X-Proofpoint-GUID: 3lGyv9w51WkKzotJP6HsFZEnvDhR_-db
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 25, 2022, at 5:01 AM, Mauricio Faria de Oliveira <mfo@canonical.co=
m> wrote:
>=20
> This message is helpful to troubleshoot missing LUNs/SAN boot errors.
> It'd be nice to log it by default instead of only enabled with debug.
>=20
> This user had an accidental/forgotten file modprobe.d/qla2xxx.conf
> w/ option qlini_mode=3Ddisabled from experiments with FC target mode,
> and their boot LUN didn't come up, as it skips scsi scan, of course.
>=20
> But their boot log didn't provide any clues to help understand that.
>=20
> The issue/message could be figured out w/ ql2xextended_error_logging,
> but it would have been simpler (or even deflected/addressed by user)
> w/ it there by default.
> (And it also would help support/triage/deflection tooling.)
>=20
> P.S.: I can't test it on real hardware now (built on next-20220811),
> but it's just like other messages in the same function, just below.
>=20
> Expected change:
>=20
> scsi host15: qla2xxx
> +qla2xxx [0000:3b:00.0]-00fb:15: skipping scsi_scan_host() for non-initia=
tor port
> qla2xxx [0000:3b:00.0]-00fb:15: QLogic QLE2692 - QLE2692 Dual Port 16Gb F=
C to PCIe Gen3 x8 Adapter.
>=20
> According to:
>=20
>  qla2x00_probe_one()
>  ...
>          ret =3D scsi_add_host(...);
>  ...
>                  ql_log(ql_log_info, ...
>                          "skipping scsi_scan_host() for non-initiator por=
t\n");
>  ...
>          ql_log(ql_log_info, ...
>              "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
>=20
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 87a93892deac..8bd1947a650b 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3530,7 +3530,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
> 		qla_dual_mode_enabled(base_vha))
> 		scsi_scan_host(host);
> 	else
> -		ql_dbg(ql_dbg_init, base_vha, 0x0122,
> +		ql_log(ql_log_info, base_vha, 0x0122,
> 			"skipping scsi_scan_host() for non-initiator port\n");
>=20
> 	qla2x00_alloc_sysfs_attr(base_vha);
> --=20
> 2.34.1
>=20

Code changes look good and are also verified on my system.

Aug 25 15:01:20 tatoonie kernel: qla2xxx [0000:04:00.0]-0122:1: skipping sc=
si_scan_host() for non-initiator port
Aug 25 15:01:22 tatoonie kernel: qla2xxx [0000:04:00.1]-0122:10: skipping s=
csi_scan_host() for non-initiator port

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

