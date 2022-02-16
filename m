Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9EAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 02:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343636AbiBPCSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 21:18:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243163AbiBPCSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 21:18:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126D2BF97D
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 18:18:43 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMZpLP031631;
        Wed, 16 Feb 2022 02:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2BlgPAoNA+uP73TePbFp4ybHDtscxZefOdyE38sU8Js=;
 b=1E2ZhUftpY8EyShVvMr2LERHv1s6DHgBYM52vjB+xW1IVpiwZO+0CkDABS6MyzeoELe5
 gwSHiF2FPstDwsdokQ0Qb6GjViVdlDTgycyf6J3ByEOqMr+yAHdBuodiF6RRbLmnkWeM
 6viQeJcndmcDR2n/6iJCVa1U+szRYEoX3FeE+cIYI+gdk4OTAJKPtIu1lwgNPP75c4Zl
 luhcwNGnLSOngrbyfSjie5Hz8hA9BcNYjb+D86jj4po8DiTXBXnM9T3toS7qQb2oxnuR
 zNjm3B2Yni4JBs+CrWMvLWVyPE9cyGGRxVI0u/YmWZCccuFHmEzKbTlu7vMgMA7QKLYd 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3f89gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 02:16:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G2BHhn009195;
        Wed, 16 Feb 2022 02:16:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3030.oracle.com with ESMTP id 3e8nkxjkfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 02:16:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjQtdhGN+y6WgQxO2qv1gUzLAxsIopzPR7pChIFwQw09SFDIpI2Ou+2PA3oW5oCjpAQSEVWybkIUo6FpZ5631Kgr2TMjhYdrfkdO5J9ssdJA/UNrpR67KnIShYRYHIe1EsigpMbKPlTYkwEc2Eu4J9nh2z9YcqNlQ15igy/r0cBVIcF7A0pg40aJjDsUq0Er5gVevwIuJNCVkZUuY2P4ujEytYdGoVTU345lamQwxXUqoAl0siCsquwpW0z0WJnhD9d0N2hL4yVESHe6n0oPAZYLgifsFOqz+Vr2B9mbA2G85NW2eoM9GjEg5gwrWcsxqd9Xmi0kSYIngyF1MTJDhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BlgPAoNA+uP73TePbFp4ybHDtscxZefOdyE38sU8Js=;
 b=cJrPCmcfaPT1YFJPVDaROfuKc/oJTvLVZ/P/XJdlLeb3kqP3faIezauWS9BrcIy4d2taHkzk0VSooqmqLdAzalSQ4NeCv2GJSey357X5QJEutrkA3DFrwlsOltHTCSJgqrMG8jDa8NugWKNDFS/c4vYaOOeXtBmuAfkvZzk3y4O8p88GoaPRXK91XkeztQy7Q1G26Ux5U9Y1p7XsOVkGp1Y8nQ2S5nIjHogZW1LbAobszqpAwaSIT6gRrTVWdbsG80J7pBbePI6fIaohAm1G3zpy8X17Z0rv7LS+bmjCt4bND9SvBgHZ+6+ditj8NPvuCF7WD6bVrm5MR0cuxYRI2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BlgPAoNA+uP73TePbFp4ybHDtscxZefOdyE38sU8Js=;
 b=LXQWAOOQpr9hDvxNN2f/tSRzEer0SLdnxurbptZ9iw8c411qYFiMpkfPOQXJQd5l7/ha101LBb59fhOyx+aageoUhXqi9T9d4E1dcI0jvFQG2OHgorFtfLfnZ9FLnnTrHBTMi60NUH0eztfdSirbV5QLan7DakqGfaysKma9gtM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO1PR10MB4529.namprd10.prod.outlook.com (2603:10b6:303:96::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 02:16:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Wed, 16 Feb 2022
 02:16:13 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] qla2xxx: Use named initializers for port_[d]state_str
Thread-Topic: [PATCH 1/2] qla2xxx: Use named initializers for
 port_[d]state_str
Thread-Index: AQHYIo4mcTFVAdEJS0WML5Qqc+V4sayVcTkA
Date:   Wed, 16 Feb 2022 02:16:13 +0000
Message-ID: <D4EF3E44-4094-49FA-8A00-BB49B6F9BC58@oracle.com>
References: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1af3a86-4b24-4b65-ef35-08d9f0f24e16
x-ms-traffictypediagnostic: CO1PR10MB4529:EE_
x-microsoft-antispam-prvs: <CO1PR10MB45299640660373A8D9DCE2C8E6359@CO1PR10MB4529.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:53;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ugiWsLTSD8joyPl7QhwZVvN6U/IgyaFU3pGrNpWqrWd2gvhgOezgG92vL0wLQ/LJFjIATapVL8KB1+ui4XcNI0FgzaW1IqRJ/EvRa9Zs7O6IIwNsgsxG5uxyyuQ+lf9nVpxrUMEJCZP/+V15dBVq5fB7UJjpatUg57VGKvL5oZaHDEtwAfNPPgIZKTzWtgNjjtPy62MHPxB/zkbeMMEeHr2J55AR9u5myCr/jDQ7wdp7itCTcwVVWetAgu0vrvO6vJEy1XY/HM6jhjOtG7Mnpb3D6sRMRM+DTX/3ruhSvKiwEK+E8Djab4VP3qJEK2xSEl1tgbPcAbMR8o930DnJwwTaFglwpR8AyKG92foiwnIgfyES9Wb+d2GCun+g06mpIMI6Q6vL0cTFGIAw67msXsqEU4dGNZZ/xAcuiO0IGFzqPZRCc/ZE6G9UnXeWp36fmAbi0dTOzQukx2/PavCJm+ocsQd2hIpXYMDB0wYQGBU+DLN9Ib8POYlopQm/FSXDKkeCv3cgfJ0ch4qGAx5rbk5GAFTDGxVIk1E11iL4KoPummd29V/D0q2aJCfxJ6fbEyjQMpjllMyiAEhjz6JseXXXED5HE9sK8zYO7YiAHQjSd+0Bmfb972AqLKRNDekqUGtcvWyK/y2Jstgx0JPkA44V7C79a49czgGHfjo+VHkA70VduxdlIacoUGYDI6Dy+E4+Bc4ORh6x+krJISTn1tO44+FUxZUW5RZP4mTF2VGEajECOpKdYGllaW0Hot2x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(36756003)(64756008)(66446008)(5660300002)(8676002)(4326008)(44832011)(66476007)(66556008)(8936002)(86362001)(38100700002)(38070700005)(6916009)(2616005)(508600001)(66946007)(6486002)(91956017)(76116006)(71200400001)(53546011)(2906002)(6512007)(186003)(83380400001)(6506007)(26005)(33656002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7EHXwZUtFRkaLtt6mU06XjKUg5amPZRLWzPi9x4/hvAuMQHK8ruA3Qwgbosi?=
 =?us-ascii?Q?ZHwYClzhvSTlPsY/QeEYj9Kf6oNSczYnCZCpzB2B59w8usbOrXbb4anKPP6X?=
 =?us-ascii?Q?tVh4flv8uc4NiDyWQsfbin6GjylqNFBHqfNMY7Lsm3Ky1o2CmpJv8NYI/l9b?=
 =?us-ascii?Q?nVaSJpasgOh5SvIeEbnnBvN2qj2+C59Z0PoBuIQpVpQeybznaM7qFiHA2kQU?=
 =?us-ascii?Q?G+/TtT6kj1o715+paI9faNdg8Snhj0voJMf8N6zAt/PAcJcn6sL0XlOcS50n?=
 =?us-ascii?Q?gtLJYyviG34Wc3gEZo+vJ0lcJFJ0dgSVfshmcIpuh1RCPG7IW/yDQWpjgTe4?=
 =?us-ascii?Q?L64zbvevCnSdPtXUcsfO68MrrgWrpO75sOT7K84Ty89tIrsH4eWLwI+TU3C2?=
 =?us-ascii?Q?h5H2jWl4jA7jIolepw1gkJqPwOkfSWL1AtDTN2ZqmdkRVn/hHyl4VBC8e35v?=
 =?us-ascii?Q?uvorHSI2nNSSduJ/Imv/SS2QeQd/6Nst+BX4o+P4u9bRtTTOJXywyBnY5sR1?=
 =?us-ascii?Q?LNlAnVvlJBRTx1AyjXPnsHnE4rSmxvKoX5d+lqRvR/i1dstoA+v26LoQu10i?=
 =?us-ascii?Q?lvY/RBmwYtJY3KrRXIK6xelrv5X1webb3mxBYA+qiYeeyyXdz0HlvZYbtjGf?=
 =?us-ascii?Q?VhqLdv9zCxyHVRA6PbHtfGODTLUB20rDF2bA2QypZTeUd2n4kJe1FUbjekNf?=
 =?us-ascii?Q?yedXryyJuRCWdZCLNZ0FdJBLtNQ4ejkxH4DtOJLy77tsJcMfCorxmD/+oa9w?=
 =?us-ascii?Q?vtXjptpkzZKY9f+sqMKl4MEauXYqMdvbDRJMKeT+PatMetIsWerID/IY/htd?=
 =?us-ascii?Q?KaQu3EQBTq2ZtUqRjPMFG1as7Swzb+Ee4Z50B47U8VtDzRiG5+BaG68qyg5D?=
 =?us-ascii?Q?G2/2xu5I6gADtCtlniC1rI0VvSwve5pNs4YIyikdB8Uf7wdm6DlrFqrzgPmX?=
 =?us-ascii?Q?ZTF4qSjjthOv7ioaQpQw5LizN2wT9zEOWqNbQY22gef1tC18ca3plj2fJkDP?=
 =?us-ascii?Q?KBhwR+ZoWTsKSIUkVvyeXckgZnGNkD+6lrzVICpiXzhQC/3a6jISdDHbF5Zf?=
 =?us-ascii?Q?DgsLzNBETKEl2P9hGgVQQ4cKtfTLq5jyDkCn7YHCa0VE6TE9tixeKMWA8hLg?=
 =?us-ascii?Q?QJtZbahXt7uWGh49yoMWjvoXnQCL1kqEzDeRVpntmAlpWnF+CAG/Lfor/atU?=
 =?us-ascii?Q?itZuPA5b07dVOUFjc82AkErkokhZKkMRypRZO+qunhEx+y0YsqC/HgE3cfxJ?=
 =?us-ascii?Q?95demjGVKYP9mKA8Z0naj93liFbRl3r6eV3Kzpdx7aOVrv+I+MbUc7yEMgl8?=
 =?us-ascii?Q?+GBiNzVOYtC55WKr7YglT5XCmQ4SWh6A/gE8Guw0yyz9kYwHQF4+FmNYaHlg?=
 =?us-ascii?Q?ieFz7gUvwIpJ9oB3jhXRMZEdIt4TrptlBhIK5RujIYQsee4xxNtns2WtMpDv?=
 =?us-ascii?Q?f7KeJKiE9Ck+l6jhSTr00KL58JQQKPEoiin8HuknPcoE75rPNmcW6Xff/qny?=
 =?us-ascii?Q?TlhKbzuSjQnFmeEkV1pnPoZRZ4Y/ovbpAJbDMlgKolFkjFKLNEEtlSoktz1w?=
 =?us-ascii?Q?RkKE1Np7y9FKAxKx3cwyHd8D5yBSqCKKZM1uTQWaILwI3cMdTqyjBjTpGXMv?=
 =?us-ascii?Q?Gt9aZt9AbAEMZfasar5W8uM/mfz4dP2j58jJ20jX4jq1cjd0iKuC9vG0rtJb?=
 =?us-ascii?Q?9UnmnzP5/mDTNr69auauFWscxCU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <376937B9D8F2A644BF3CFBC3ED862FD0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1af3a86-4b24-4b65-ef35-08d9f0f24e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 02:16:13.1419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53vCU4c2QG8rnIz9DIW8+dWP1F9fk9aVy6rX7pLYyP8VApiBZp8Pic4CVmSUbx9+jAMLluYBYkFqm54Y5GlxUmgOdpq/mGWkeCS+CHfihuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160009
X-Proofpoint-GUID: X52GPeQS23poQTqINSsQa5MGCIAsxYxT
X-Proofpoint-ORIG-GUID: X52GPeQS23poQTqINSsQa5MGCIAsxYxT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 15, 2022, at 9:13 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
> Make port_state_str and port_dstate_str a little more readable and
> maintainable by using named initializers.
>=20
> Also convert FCS_* macros into an enum.
>=20
> Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h | 35 ++++++++++++++++++----------------
> drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----
> 2 files changed, 24 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 9ebf4a234d9a..b0c40f6ab25d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2666,25 +2666,28 @@ struct event_arg {
> /*
>  * Fibre channel port/lun states.
>  */
> -#define FCS_UNCONFIGURED	1
> -#define FCS_DEVICE_DEAD		2
> -#define FCS_DEVICE_LOST		3
> -#define FCS_ONLINE		4
> +enum {
> +	FCS_UNKNOWN,
> +	FCS_UNCONFIGURED,
> +	FCS_DEVICE_DEAD,
> +	FCS_DEVICE_LOST,
> +	FCS_ONLINE,
> +};
>=20
> extern const char *const port_state_str[5];
>=20
> -static const char * const port_dstate_str[] =3D {
> -	"DELETED",
> -	"GNN_ID",
> -	"GNL",
> -	"LOGIN_PEND",
> -	"LOGIN_FAILED",
> -	"GPDB",
> -	"UPD_FCPORT",
> -	"LOGIN_COMPLETE",
> -	"ADISC",
> -	"DELETE_PEND",
> -	"LOGIN_AUTH_PEND",
> +static const char *const port_dstate_str[] =3D {
> +	[DSC_DELETED]		=3D "DELETED",
> +	[DSC_GNN_ID]		=3D "GNN_ID",
> +	[DSC_GNL]		=3D "GNL",
> +	[DSC_LOGIN_PEND]	=3D "LOGIN_PEND",
> +	[DSC_LOGIN_FAILED]	=3D "LOGIN_FAILED",
> +	[DSC_GPDB]		=3D "GPDB",
> +	[DSC_UPD_FCPORT]	=3D "UPD_FCPORT",
> +	[DSC_LOGIN_COMPLETE]	=3D "LOGIN_COMPLETE",
> +	[DSC_ADISC]		=3D "ADISC",
> +	[DSC_DELETE_PEND]	=3D "DELETE_PEND",
> +	[DSC_LOGIN_AUTH_PEND]	=3D "LOGIN_AUTH_PEND",
> };
>=20
> /*
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index aaf6504570fd..092e4b5da65a 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -49,11 +49,11 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha,=
 struct purex_item *item)
> }
>=20
> const char *const port_state_str[] =3D {
> -	"Unknown",
> -	"UNCONFIGURED",
> -	"DEAD",
> -	"LOST",
> -	"ONLINE"
> +	[FCS_UNKNOWN]		=3D "Unknown",
> +	[FCS_UNCONFIGURED]	=3D "UNCONFIGURED",
> +	[FCS_DEVICE_DEAD]	=3D "DEAD",
> +	[FCS_DEVICE_LOST]	=3D "LOST",
> +	[FCS_ONLINE]		=3D "ONLINE"
> };
>=20
> static void
> --=20
> 2.35.1

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

