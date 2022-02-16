Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED27C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 02:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbiBPCTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 21:19:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343646AbiBPCTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 21:19:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C53C0848
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 18:19:04 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMYj5S031011;
        Wed, 16 Feb 2022 02:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eu+Sv4wgTCjJNKkZ2+flfTjJrr4JzlMJXhTF5gl1L6U=;
 b=q8DL0Q6gq1SQtw/JIcqCv78B9VY3srbZvtSg/Fl4FWDApcJ2WaqfNxQjXhNAyZziPbCQ
 4Oe1g/0wQNgvhSxbOvt3oP9SmBO/SFsptl0meA/3trh3dQUBUo6saxKoZoGQqRiItPKs
 pQ6bjiQ4QCWqJz4dMuty852iMOFHZ38G8pbeV8CRaxGELQBoppb3Y2fNvfeMsHHkxU8M
 CUaI9L1cIGHkSKH49wK6P8u2VeDpWI2A2l+OoRcWabpJmAPjHFueaZMVVU3uQ66mvaND
 Qd42UXuNGHobL3xWFeOgvb6KWR752dlGhEFtB18pfUfDNVOXb5Sqxdpbt5uIIkIdlPw7 cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3f89gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 02:16:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G2BJcI009509;
        Wed, 16 Feb 2022 02:16:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 3e8nkxjkkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 02:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7IF6BApfP5JQ99YOIrz89dWEHLoNFP0AsQY01m+Eo8tSuYrbQiTnXQ4QlmAXYLECZQnbhgK53TXkZ7h31lQUaFO0mhbyjfKFmE8ZfwyKPFevmNjDkhC+VaNZXZQ7Mn5AC3Me8R2DMyJJ6kvOwt6aiGC3rSdlBRDcaNxX3nNh6v3lU/RmC0xyqTCJk04EtjMDcDUstNLiy4sQuTAaxO+ABUGLFlfSM2BwumShNbBqX+84JRoBG8lWqLykYkYdXRR8xTgMSkNmdZoh/UAUyD70FMr69oPruXRoWTNjOHLmjMmYkl0nLLRg57w9OWC0KDYHSf14AFgJ1iCAjTi4v0HAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eu+Sv4wgTCjJNKkZ2+flfTjJrr4JzlMJXhTF5gl1L6U=;
 b=PYH5xbAOB47Oz5K7Mtlco1T63jNCI84gijpFWONnH3oRd4d40a1EDOyeIRjrP1C9izVtt9Uv7ZqqajbyBV5L8Uiog2OkIa0i+lotShqpVB8YdkyGMkYwXHYr6C6Z05crabDZVH0i3yD20fF9cqjs0KNceUING3AzGEY6BirEzzL2EF3nYwVJmqRosMbBvmauuAFjX+vcBUydH4qfxX88RHcqApaQD7kTyhtj9cvhxlgLoKAgNI9llcFihe2CwYS6ruRhRC7ZYGXUKR2KUDAQUpf8vPbcT7suwfUNEOETxTAe3h/qUh772axJqN4/4xIUcT5uqDOnk9wwhauwJX+blw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eu+Sv4wgTCjJNKkZ2+flfTjJrr4JzlMJXhTF5gl1L6U=;
 b=DlgWbSoThMu0koSIH3mZUXLBByJD9zfyHhkwp11uCoBxPGAv01BCKs+8NUNnu9kvxYEVYIyUFgdGpznkkSHG9uuTi783RsCEj/BO3LTMF4RN8wfzOk3pA3LT1A4XgSxmKP8ONEv/8iHb3CyyR/m4daQXGES3MiHve8YnkSwZM4I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO1PR10MB4529.namprd10.prod.outlook.com (2603:10b6:303:96::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 02:16:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Wed, 16 Feb 2022
 02:16:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Use named initializers for q_dev_state
Thread-Topic: [PATCH 2/2] qla2xxx: Use named initializers for q_dev_state
Thread-Index: AQHYIo6lxTS1cOPenkSYe6rvU6E7bayVcVOA
Date:   Wed, 16 Feb 2022 02:16:36 +0000
Message-ID: <81A0F208-F28B-425A-9657-8765C07EE620@oracle.com>
References: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2d005cb-9b83-45fa-d266-08d9f0f25be8
x-ms-traffictypediagnostic: CO1PR10MB4529:EE_
x-microsoft-antispam-prvs: <CO1PR10MB4529D2448C38925D2EED6C1FE6359@CO1PR10MB4529.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:37;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2AsBePH4bv4IZBq5QFo6OklLoBOlCAzHjUBYfLxttM0ynxsMtljgkofgKb7AQPk7tT8Vgw+6a+ikcNIoRrCz2tZmWqtmRkqcQk1YbTpcug/nTED8iz6fFkSPfFB4s5PCHnOpjJyOpxwJmU3ra/u6MYMYPoeLdlPH048r+/jA5bcW78W+nCg22ac31qbHhDSYo0vbbC2lcQK0nqA2BfQahg7iVZgwEsEHb3W2AjlWmiDE486hX4lUZVJoVwbZuHoTeWNXZ1+6tS9f3PipvRX3HAKEeqKqVMUxr4ZvwCr16p1wLmN080ewP1DKjqvFGCY5aZJgLpz+hTeQ4GvZZ7iPCgywk7KT+R3O0l/OHCP+84RmhpySxz8YpxaZUtc0MJkTHZ/i29wJfEhZmfuo35rdlqKnrpHmmOx27DqaWgEJL/9Xjdsrn8bFphWFSLn9i1rJmdYu3nX8XSHwp1pqBKVu/hcln46f+TnJRB5hXvnATfDTNYn1/06fYivi9tvumRjsVfyG+0FoN6FTRJsHA3jahF+TmkXGEZ7yuUxGQ1t/PuP4K7YgWRHay3t38bq5XkwDbGtsszhv09TIKyzz9MIft6rl+ULAIIRO1+W8AKQjuKy91sUNg+MHyYO2hRzdnV6ukjdiLe6deqSTDCvVMRhrrrqi6OodgpfmfEaVoTBlMd4KNeFOobigwlwN5vkcTnNTrGLfwOGOYTJrUdqMYwvELQOtM1hui7IgtYajZId+BH2L49IDOkWkdaM2UT2ANDoPN8hhzOc0C2mt/NQkwk0how==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(36756003)(64756008)(66446008)(5660300002)(8676002)(4326008)(44832011)(66476007)(66556008)(8936002)(86362001)(38100700002)(38070700005)(6916009)(2616005)(508600001)(66946007)(6486002)(91956017)(76116006)(71200400001)(53546011)(2906002)(6512007)(186003)(83380400001)(6506007)(26005)(33656002)(122000001)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AGCeZi17MM77XdCX2vY4GR1TSEAdk194IhJWp13fXmcy5bjpkPbiAAPGj6oX?=
 =?us-ascii?Q?Qpn51Xl3Gz8OSRFg9HifW7HW4WN+VMngIGvn/QNZeDi4cPyyVuqZ0GfnkABH?=
 =?us-ascii?Q?BVSr4Ss3dRGruIwzCsqlWgHU/JZlsXBXnYQS2Pg9uhC8DoEltbjB7QkXH2Kp?=
 =?us-ascii?Q?bS9y7YBnC1/qrAMKwVsTZkTQ2kXLvaUqFuGjzsCuLCEccWrr83xNveO6y+Hu?=
 =?us-ascii?Q?v221PJIADQ8+Go3r2QoA8HuvfKdKkPIi3X+u2A7Lfiu7h0e5+PsMCU0SqTSY?=
 =?us-ascii?Q?qRjtxydCZBHxLDvPU5zTDSxhAX38N/IC+jj3WZC39wtCvdPFLOZoer1zrh4w?=
 =?us-ascii?Q?bwVnwc+IcAILZ0l24MGziA6PtF7PScMM/HtrSbpgs94etE/4TD1+GvOu3E1D?=
 =?us-ascii?Q?4CT0h1gFrsPEPQb+It5ZzOk9/o54a5HT6n1LYbHqw1/tUHlDkSU9CIpOvIql?=
 =?us-ascii?Q?81BXEtbqV4pAapv2M49Inif27AbjLiNYHIs95s1Vg8vIeFSwbGOBya5GwhOB?=
 =?us-ascii?Q?BkswgNiVYZJHeiq6nt7/Hh43gGPoTcHUETqPLGllrXpH5V3L5cGD0QzUwz10?=
 =?us-ascii?Q?Qes4Bi+GqQPrXpHK5u05WZNnx5HmvS+Ozv4MLstozOVIABF9eoFanF4frNsc?=
 =?us-ascii?Q?gIO58Q3QlDl92dMkPcHtQpJU+/71UCaBZa/0pD3APTkJdcEL1mRrrc6W9Kk2?=
 =?us-ascii?Q?jNQVxnYEzAfsAz7wU4Sy2u6lYwmtoBIx9iXOH+cH3zyFTHsYcg3jMJVwSZTY?=
 =?us-ascii?Q?tW5DOAv3gtfEZgZgvpry72kEDgIQtLyXLAnM/vOVHjzOaoVKUO0biBCdHa54?=
 =?us-ascii?Q?Q9qyJYV4gnD7a2Bfa7yVj+3F739Ejif0GqsljfrSTsKMB994tTJj+AKIBbmF?=
 =?us-ascii?Q?HN363LIx7ZU4hIEs4puyROPd7yXqZAmGR4Wneunxto74UGNInEQLwY3Dm8o+?=
 =?us-ascii?Q?UKrffA5GO78cf/GLgJpQEvjq+h1FmQmDGTmx4+2Z3tB5OCfJrUm/TWJ63y0g?=
 =?us-ascii?Q?h77wwb2zmPZSx5Vg4NtpEBXTp1CF1LIc/GYsdJlAbkwpc25QyUDGnks5DYep?=
 =?us-ascii?Q?QeZlcaJJFt96RL4RwwyzL8C1QeiHaCBrGyn+PnynkmWwEa0jSNjGfPhv6onO?=
 =?us-ascii?Q?ZNZRPs3F6FyxBORT9reqvdVV6QBcQZVN6Zfp5S4BNs23sAUpHQFsYfTl2ST3?=
 =?us-ascii?Q?bOnJ7FHI0wAMwCgFym84/TlZ+4k8edsAoGA63kECNxEz12yGdESCgKQrWTui?=
 =?us-ascii?Q?R0KqNiUkDzds2Bw9Ba+zmaO0ONP+f5ebOVqycZqUIGxBDmKUKcDdDlFS4Rq5?=
 =?us-ascii?Q?4TKOa857o0OaGBoj60e7b1+Ru9qshZ7SLRJ0Wtao/Ns1WdAAGQ4HwTkjpkwm?=
 =?us-ascii?Q?Qn2lL9uQUypA425tML5Pj6en4isJQ90JzAmKfMmF8kOP9v9FU846/RhGwVyF?=
 =?us-ascii?Q?QuDOlnKBNU2ytNqSnJ52E7+i7qlqqVA1V/k2N1Qwt01ESxW/PWyWYSQE5VE2?=
 =?us-ascii?Q?IcawNrShlEZHl5YIJyTS6yceiIkePChrQZ8dKTw6+vq8bcCjD3DkG6k3hfof?=
 =?us-ascii?Q?Ao6AxRr7046etYJDsAKsxGtAsNulbeloUmFvPjbheAp+Om1inHnuQHymHnwb?=
 =?us-ascii?Q?zneTTJRrgWFRhIBikbahcdO/P2on4nAURtPs5rIUgR2/QoAWGtX3yhmS/yQb?=
 =?us-ascii?Q?NYUR4O9BkAqNYrSPqSJ09FYlsJU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B97B34CD99B4246805B9A9287EED522@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d005cb-9b83-45fa-d266-08d9f0f25be8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 02:16:36.3122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nf4nBRWJybmB2zJ+tDW3z/9zDLzdyc4EFYvkzLYPGDxETdNcNPP+gFWbO7miIwgRpwSlQ2gWmrrrlM672C6iDDnXnFeEYuPT8/N947OL7T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160009
X-Proofpoint-GUID: JD0JOCdeJ6teg506RcqZ2jVj6-Wp_9Ir
X-Proofpoint-ORIG-GUID: JD0JOCdeJ6teg506RcqZ2jVj6-Wp_9Ir
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 15, 2022, at 9:13 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
> Make q_dev_state a little more readable and maintainable by using
> named initializers.
>=20
> Also convert QLA8XXX_DEV_* macros into an enum and remove
> qla83xx_dev_state_to_string(), which is a duplicate of qdev_state().
>=20
> Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
> ---
> drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
> drivers/scsi/qla2xxx/qla_init.c | 28 ++------------------------
> drivers/scsi/qla2xxx/qla_nx.c   | 35 ++++++++++++++-------------------
> drivers/scsi/qla2xxx/qla_nx.h   | 20 +++++++++++--------
> drivers/scsi/qla2xxx/qla_nx2.c  |  9 +++------
> 5 files changed, 33 insertions(+), 61 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 8d8503a28479..7e93ab9104fd 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -890,7 +890,7 @@ extern void qla82xx_chip_reset_cleanup(scsi_qla_host_=
t *);
> extern int qla81xx_set_led_config(scsi_qla_host_t *, uint16_t *);
> extern int qla81xx_get_led_config(scsi_qla_host_t *, uint16_t *);
> extern int qla82xx_mbx_beacon_ctl(scsi_qla_host_t *, int);
> -extern char *qdev_state(uint32_t);
> +extern const char *qdev_state(uint32_t);
> extern void qla82xx_clear_pending_mbx(scsi_qla_host_t *);
> extern int qla82xx_read_temperature(scsi_qla_host_t *);
> extern int qla8044_read_temperature(scsi_qla_host_t *);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 1fe4966fc2f6..b07ebfb02ea9 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -6773,29 +6773,6 @@ __qla83xx_clear_drv_ack(scsi_qla_host_t *vha)
> 	return rval;
> }
>=20
> -static const char *
> -qla83xx_dev_state_to_string(uint32_t dev_state)
> -{
> -	switch (dev_state) {
> -	case QLA8XXX_DEV_COLD:
> -		return "COLD/RE-INIT";
> -	case QLA8XXX_DEV_INITIALIZING:
> -		return "INITIALIZING";
> -	case QLA8XXX_DEV_READY:
> -		return "READY";
> -	case QLA8XXX_DEV_NEED_RESET:
> -		return "NEED RESET";
> -	case QLA8XXX_DEV_NEED_QUIESCENT:
> -		return "NEED QUIESCENT";
> -	case QLA8XXX_DEV_FAILED:
> -		return "FAILED";
> -	case QLA8XXX_DEV_QUIESCENT:
> -		return "QUIESCENT";
> -	default:
> -		return "Unknown";
> -	}
> -}
> -
> /* Assumes idc-lock always held on entry */
> void
> qla83xx_idc_audit(scsi_qla_host_t *vha, int audit_type)
> @@ -6849,9 +6826,8 @@ qla83xx_initiating_reset(scsi_qla_host_t *vha)
> 		ql_log(ql_log_info, vha, 0xb056, "HW State: NEED RESET.\n");
> 		qla83xx_idc_audit(vha, IDC_AUDIT_TIMESTAMP);
> 	} else {
> -		const char *state =3D qla83xx_dev_state_to_string(dev_state);
> -
> -		ql_log(ql_log_info, vha, 0xb057, "HW State: %s.\n", state);
> +		ql_log(ql_log_info, vha, 0xb057, "HW State: %s.\n",
> +				qdev_state(dev_state));
>=20
> 		/* SV: XXX: Is timeout required here? */
> 		/* Wait for IDC state change READY -> NEED_RESET */
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.=
c
> index 11aad97dfca8..6dfb70edb9a6 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -335,20 +335,20 @@ static unsigned qla82xx_crb_hub_agt[64] =3D {
> };
>=20
> /* Device states */
> -static char *q_dev_state[] =3D {
> -	 "Unknown",
> -	"Cold",
> -	"Initializing",
> -	"Ready",
> -	"Need Reset",
> -	"Need Quiescent",
> -	"Failed",
> -	"Quiescent",
> +static const char *const q_dev_state[] =3D {
> +	[QLA8XXX_DEV_UNKNOWN]		=3D "Unknown",
> +	[QLA8XXX_DEV_COLD]		=3D "Cold/Re-init",
> +	[QLA8XXX_DEV_INITIALIZING]	=3D "Initializing",
> +	[QLA8XXX_DEV_READY]		=3D "Ready",
> +	[QLA8XXX_DEV_NEED_RESET]	=3D "Need Reset",
> +	[QLA8XXX_DEV_NEED_QUIESCENT]	=3D "Need Quiescent",
> +	[QLA8XXX_DEV_FAILED]		=3D "Failed",
> +	[QLA8XXX_DEV_QUIESCENT]		=3D "Quiescent",
> };
>=20
> -char *qdev_state(uint32_t dev_state)
> +const char *qdev_state(uint32_t dev_state)
> {
> -	return q_dev_state[dev_state];
> +	return (dev_state < MAX_STATES) ? q_dev_state[dev_state] : "Unknown";
> }
>=20
> /*
> @@ -3061,8 +3061,7 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
>=20
> 	ql_log(ql_log_info, vha, 0x00b6,
> 	    "Device state is 0x%x =3D %s.\n",
> -	    dev_state,
> -	    dev_state < MAX_STATES ? qdev_state(dev_state) : "Unknown");
> +	    dev_state, qdev_state(dev_state));
>=20
> 	/* Force to DEV_COLD unless someone else is starting a reset */
> 	if (dev_state !=3D QLA8XXX_DEV_INITIALIZING &&
> @@ -3185,8 +3184,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
> 	old_dev_state =3D dev_state;
> 	ql_log(ql_log_info, vha, 0x009b,
> 	    "Device state is 0x%x =3D %s.\n",
> -	    dev_state,
> -	    dev_state < MAX_STATES ? qdev_state(dev_state) : "Unknown");
> +	    dev_state, qdev_state(dev_state));
>=20
> 	/* wait for 30 seconds for device to go ready */
> 	dev_init_timeout =3D jiffies + (ha->fcoe_dev_init_timeout * HZ);
> @@ -3207,9 +3205,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
> 		if (loopcount < 5) {
> 			ql_log(ql_log_info, vha, 0x009d,
> 			    "Device state is 0x%x =3D %s.\n",
> -			    dev_state,
> -			    dev_state < MAX_STATES ? qdev_state(dev_state) :
> -			    "Unknown");
> +			    dev_state, qdev_state(dev_state));
> 		}
>=20
> 		switch (dev_state) {
> @@ -3439,8 +3435,7 @@ qla82xx_set_reset_owner(scsi_qla_host_t *vha)
> 	} else
> 		ql_log(ql_log_info, vha, 0xb031,
> 		    "Device state is 0x%x =3D %s.\n",
> -		    dev_state,
> -		    dev_state < MAX_STATES ? qdev_state(dev_state) : "Unknown");
> +		    dev_state, qdev_state(dev_state));
> }
>=20
> /*
> diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.=
h
> index 8567eaf1bddd..6dc80c8ddf79 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.h
> +++ b/drivers/scsi/qla2xxx/qla_nx.h
> @@ -540,14 +540,18 @@
> #define QLA82XX_CRB_DRV_IDC_VERSION  (QLA82XX_CAM_RAM(0x174))
>=20
> /* Every driver should use these Device State */
> -#define QLA8XXX_DEV_COLD		1
> -#define QLA8XXX_DEV_INITIALIZING	2
> -#define QLA8XXX_DEV_READY		3
> -#define QLA8XXX_DEV_NEED_RESET		4
> -#define QLA8XXX_DEV_NEED_QUIESCENT	5
> -#define QLA8XXX_DEV_FAILED		6
> -#define QLA8XXX_DEV_QUIESCENT		7
> -#define	MAX_STATES			8 /* Increment if new state added */
> +enum {
> +	QLA8XXX_DEV_UNKNOWN,
> +	QLA8XXX_DEV_COLD,
> +	QLA8XXX_DEV_INITIALIZING,
> +	QLA8XXX_DEV_READY,
> +	QLA8XXX_DEV_NEED_RESET,
> +	QLA8XXX_DEV_NEED_QUIESCENT,
> +	QLA8XXX_DEV_FAILED,
> +	QLA8XXX_DEV_QUIESCENT,
> +	MAX_STATES, /* Increment if new state added */
> +};
> +
> #define QLA8XXX_BAD_VALUE		0xbad0bad0
>=20
> #define QLA82XX_IDC_VERSION			1
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx=
2.c
> index 5ceecc9642fc..41ff6fbdb933 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -1938,8 +1938,7 @@ qla8044_device_state_handler(struct scsi_qla_host *=
vha)
> 	dev_state =3D qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);
> 	ql_dbg(ql_dbg_p3p, vha, 0xb0ce,
> 	    "Device state is 0x%x =3D %s\n",
> -	    dev_state, dev_state < MAX_STATES ?
> -	    qdev_state(dev_state) : "Unknown");
> +	    dev_state, qdev_state(dev_state));
>=20
> 	/* wait for 30 seconds for device to go ready */
> 	dev_init_timeout =3D jiffies + (ha->fcoe_dev_init_timeout * HZ);
> @@ -1952,8 +1951,7 @@ qla8044_device_state_handler(struct scsi_qla_host *=
vha)
> 				ql_log(ql_log_warn, vha, 0xb0cf,
> 				    "%s: Device Init Failed 0x%x =3D %s\n",
> 				    QLA2XXX_DRIVER_NAME, dev_state,
> -				    dev_state < MAX_STATES ?
> -				    qdev_state(dev_state) : "Unknown");
> +				    qdev_state(dev_state));
> 				qla8044_wr_direct(vha,
> 				    QLA8044_CRB_DEV_STATE_INDEX,
> 				    QLA8XXX_DEV_FAILED);
> @@ -1963,8 +1961,7 @@ qla8044_device_state_handler(struct scsi_qla_host *=
vha)
> 		dev_state =3D qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);
> 		ql_log(ql_log_info, vha, 0xb0d0,
> 		    "Device state is 0x%x =3D %s\n",
> -		    dev_state, dev_state < MAX_STATES ?
> -		    qdev_state(dev_state) : "Unknown");
> +		    dev_state, qdev_state(dev_state));
>=20
> 		/* NOTE: Make sure idc unlocked upon exit of switch statement */
> 		switch (dev_state) {
> --=20
> 2.35.1

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

