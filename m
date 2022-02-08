Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D6FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387343AbiBHWXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386454AbiBHUfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 15:35:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0622C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 12:35:23 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218I0hQR012771;
        Tue, 8 Feb 2022 20:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=T3shEKTQSl5ziLJNEBjm7cU97sYL2xYKUANgtcR9pMQ=;
 b=fssDilGF7Rol56bI//HQD5klzjLIU/vK3hEl5RI45R6sJUNyM9jaj0aFUnQtTwDerJFQ
 oxtU7VjRR25IBIlJjHY7J0oXJHGFbruoLWzyc4X3NhDCDAeI4Ad+NXtOa8L3eonjh5Gz
 y5Zgoh6rcJUKAEu+oHsxjgCPCjABYszUQQ361OqBcSK6QSeCvytIEPdtOi+y7p7sTKXV
 u5GF35+qXZ4OjKHQMaVmMqEb8MPcU0VMh4lKQCPnrKH/B9bCnPrDA2bNeLgGUrX/HTv2
 DC8GqGVUDpIpt1gM5LOTYGu2kpx/uNCdjGxGY8G3tt0mHGZLaohuikSPglQxmg6P+oe7 CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgjqrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 20:35:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218KFmMr175696;
        Tue, 8 Feb 2022 20:35:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3e1ec121pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 20:35:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mz65x3AymuBA+/SUnZLiH1a8VXvqBOe8UNZEeslWLk9kanpKoAP5BX7NKMI3/aTw8MAqWM57TCnEGE72gYWMINBZNoJ4hpSaRd5JwX2Fq2FMP7knThvHpvr+T7AkDV7CJ1+quwB5UJUKA38srOqjqzLCmTX9m0YmCsemdWJw80IdeM6pzJHOS5iHASwqtxI6l9JIati4p6DlM+0J3yQ33wxqy5c9rp6K9kuPO7x0cOmSO+IJqk9tHnwDIZkehHbfmTHo0o+gvTFDSiPQTrm3jsJ0atlsQmShBqrLkcXNZ0yqYCK30lQThsVfhpmqXmKW3F07xwg5FjkKBFON6jVb5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3shEKTQSl5ziLJNEBjm7cU97sYL2xYKUANgtcR9pMQ=;
 b=RMAY6zCZ0UiSvAyb6iyTJNwpdJZgzWlkbzQm919Jtr9o+KRMBoJSOX4pqfwKg78BgJDPnQIbVsAxUAzqM/VvL390TadX2delkkT3FNhOp9GYu0xE1FU/9FQYZCtbOMnTcOZ6Jo7ZozCJsNTW8VChRufAysG6PC6DJ1Wy5PwPBsG6HyrX87qL0x9mApzqjUQquvTMcSvP0TQ/KQvxuRpXJHBRKCkIndyO2j+3P+L7bSSjEEGM+NGEUnH3zYno+hDxoupUz4grVQYUw1SyUciIBWRY72sH6Fpujpi6RAE3JZLKIwah8X9iTSCrQcf/G1jU/lbckCNLsGzxWyRgHpM3KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3shEKTQSl5ziLJNEBjm7cU97sYL2xYKUANgtcR9pMQ=;
 b=T1UN56KiG6uNG91X5ix3zmCD8gxyRuV5qyp01roKJXRSAvqCSU5Pz0n20UgBIOEzncA9fhkvdEMNi27GXcbME45evnYc1+VufGhNYrIWgucmCj0d3bApcGdERl8Btnqgdzg3467ArrnqpESSqAghwQtFSuuE2EMMBN1EFW0r0Mk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB3301.namprd10.prod.outlook.com (2603:10b6:a03:14d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 20:35:17 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 20:35:17 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 17/44] fdomain: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 17/44] fdomain: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRENi8rYVx267ECDQCmOpUyjTayKHKAA
Date:   Tue, 8 Feb 2022 20:35:17 +0000
Message-ID: <3D315778-8C8F-4F1B-8037-51DE4D468BC8@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-18-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-18-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 151790cb-ca67-4e57-b7b7-08d9eb428498
x-ms-traffictypediagnostic: BYAPR10MB3301:EE_
x-microsoft-antispam-prvs: <BYAPR10MB3301728CFF56A6B7A7927D47E62D9@BYAPR10MB3301.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+UMjfXy8ZZsJRu4etNT32CL+5S50GnxG0QcT5nLwSMrQusuyObnAyIv7dv4ZBBJA/bfu4jGUTsYfWVfCsixXskDyUTCevqvuIEdYFv2RkLYalqQ4D6pnfGtNtbsXwcA4+cZ3P0ODN4Zf/cjQTqwg+XIRF9sPrDpV3ICKkZHD9lAnI/WFn57yXcpYlgCQZFFSckRq90R0ZJpkcCmJ20icroVnQIh4GrDjwM8YMSU5sdYsB6w7ad4/m1/8ADMWyXVEBNsztRdHjQsHTgacgU8m93+84Imq+cfQ05Nnkd5H3Z9jpildh2qLFhCJgx58dXq/vow3zER/dyVDGWIf/3e8rtE0z4910vQc3dyblLqV99q5Qk/MGgDXwyN3gYNvQShKO7dYsJaWLNoSoPFqMoIBzQijqLv3Vy63roCDqGlSp/txgnMxx4PdRA7CL6t+GI94cmQzbvUsv702d4TORZ1LVSvcGFwO728TNhfUfNJMKk6fHgodSvirwTVjpS74LWSAuVBOLUzCB5vFS3ROouafp+uBvasge0fwF44kfZzJI3lu1Jjb9VFakvfYn5hOU4ep0aXjCV0Y91fcg6XmN5iNHFe4W2s6ehZGjaBgJDYLQhIYOs7faJNpgXJ510PSHQy6tYHOANrQuieHsnY4TnZ+fZAgyyznFo2yapMr6myB7sBrpJstF+PjoSa350CRdBmQSzaRdOGeU6LJHcszYKcDooguSHjdlqs3eOVdObZ0Q7PguIEcfwr24fOEGXK5S8Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(6486002)(53546011)(8936002)(83380400001)(66556008)(66476007)(66446008)(8676002)(33656002)(76116006)(316002)(6916009)(54906003)(64756008)(6512007)(36756003)(2616005)(508600001)(71200400001)(6506007)(2906002)(44832011)(5660300002)(4326008)(66946007)(38070700005)(38100700002)(186003)(26005)(122000001)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YPKY99PmBgVRKbTo5Oyr8PiMg+DAJ0qxpre8hoJLbnVt3rCTMlXpLHddUW+3?=
 =?us-ascii?Q?LfBY2bw2A13AbgbVmZ3ZGJhQttauAuQzu2RG85vgcX8NdAUTZCHRzRkTlCOV?=
 =?us-ascii?Q?ZQO2ggHOgQZB1ZWLN3jccNC2nNAFdY+AVBXkfa1g3y63ayz8XaVJXHajSvuF?=
 =?us-ascii?Q?D+VXtCAdA7OFSXyQcglLvF9az6jiyhsZWKqOdh8DcxI8kd8u+P7hiNljW0KS?=
 =?us-ascii?Q?8+YRJqpQxnTFU96VubgviRwpVH7OfQHT5BiWFj2uKBDXuckeT7sZfWIvtNyY?=
 =?us-ascii?Q?UmT9WsxMm1My/FuDwKuygEZJ465+gedQQoVY5OddiUr8tFd0OWzvJBJl0MQ6?=
 =?us-ascii?Q?F827uais4e9+LlA1Ui+An2zgX6kOEiUvhBGK+qLdWbB0R2rOQffDp0BjjyG5?=
 =?us-ascii?Q?5sDScPEOdPfLTbeWb5bgoaTvIxIMClFlRCnfp4HWvqUv2yafgfzgWZmdGP9p?=
 =?us-ascii?Q?/I+nh7xETnFnmbMsM1QQqMzrRCPGe35YFOCaxgjYf91Eeyk6VP3PwFPU0ydZ?=
 =?us-ascii?Q?IGceYo+W8VV0sCpWZA7qdUlKCoGueugkkIXWK4oAiJ662QLCQcX9Nho/KKBp?=
 =?us-ascii?Q?Psw6y6jEcL1DvswxcryFscAGnK50+aLJBM5lBihPns2xZn6RE54a6+k6iqW/?=
 =?us-ascii?Q?+OSGYfx640cvwmIAZd+Zue3GvWd2OzhJq5Zq+nwPDAAHseke0YBiQSe/H28d?=
 =?us-ascii?Q?N+pMNIE4WriNA6FmDrjMKZAvls6KWiwJprp/muL1ELlEvWCudJ3+/feVUfTo?=
 =?us-ascii?Q?M8XwW+RpJSo5OqUtLrFv6Mn3Atl1NeBBLVAEj0F1o14rmZEt2wBw8/EJ/knL?=
 =?us-ascii?Q?lwiz75kB5VrluUxNnQo9hTHRl3lKIs+H/MlhHg0grbijrfPIqeEOqj1XqqDk?=
 =?us-ascii?Q?AJhwUJ1bZHB06FkeIoKhVps8GBYRJo1+mKbH7i+zwZfnHFPTMFUIGYbhChvI?=
 =?us-ascii?Q?knZ4QqdUsJEDunP8XK9vEQi2+/+oeU9WSl9vuquiBqQ4o4bQqyI3/PcIbcNe?=
 =?us-ascii?Q?pgQCaVJ4Ek5mRG4njPxgkpmkTO63OtVq7BX1nZdDAH68ZJz387L16Y+aykZK?=
 =?us-ascii?Q?RZe56f4qKhuluSnUpGL87Z2lKb3LdCMIiNb7UwH03LDffeY8YoViiLzcxF2R?=
 =?us-ascii?Q?jJHp4OoC6x2Bwvz5HRFny2VVzrjva/PyfoWt9XZu/rSMUFUgM0oNAZqTYfs1?=
 =?us-ascii?Q?vKhrQ5Hf++8lhU4bgBhb5Zmg16d8iQxRSIBJXLALymna/fxxHyEVNySBUN3D?=
 =?us-ascii?Q?XK9xvQGsyRAl6xcYvY/9VMNsVyL/wVh+4CGkB8qWidP8XUh+WBoXhsKIHgYe?=
 =?us-ascii?Q?xydFQJTsEx6ZSZHmjWOB0fz6IZ8x7t4syzJTspFutKjrtFE4tmMdRyd5a7a5?=
 =?us-ascii?Q?0ZM8hJdKWxefFlSC4gdq/zilsrMg+kzpI+kWSbpPkuW1fflHEMH/Mx/4v9Bj?=
 =?us-ascii?Q?/u3ufjGfptTZGw9P8dLR+e0Zf5KJ5BzK275YPQuJT4QrsiZ5A8Bj5iss1q3e?=
 =?us-ascii?Q?mwY9bVZQY8U0hTgIvVVytJdyrBQZeCyE6429gBt5bzRyKCHIysV8+ECSlNmp?=
 =?us-ascii?Q?oGDzzJ+XYOqKK7KrgIv8o/SCW0bLpDNSTYS5LD7JSNqqd3iji5heEYAfXsr7?=
 =?us-ascii?Q?JEyKMMe7hojfRql/Zs/asHd1TUV/GgSoax+rfsdYgkv3MLToQ1mDYqvsmwyi?=
 =?us-ascii?Q?G2xhS4xvCh+9oAUU/TLSA/ZPHpY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA043EDFCAE3CF4F8C0F5E72BE05C46F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151790cb-ca67-4e57-b7b7-08d9eb428498
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 20:35:17.3824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1lDxpq2cm7qxRxc3NjEGooBxi5R7rfCY6x73HHMsX187mNOu4W2ohVv8pbyraiqGhhoyC8dy9Xwu82HS6XPHfwDADOfOt1JOwPqG2ovedM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3301
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080120
X-Proofpoint-GUID: tVir-tJwNDGi8juqGuks3GYcRfYdt57a
X-Proofpoint-ORIG-GUID: tVir-tJwNDGi8juqGuks3GYcRfYdt57a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/fdomain.c | 70 +++++++++++++++++++++++++-----------------
> 1 file changed, 42 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
> index 9159b4057c5d..e24c1baf2d2a 100644
> --- a/drivers/scsi/fdomain.c
> +++ b/drivers/scsi/fdomain.c
> @@ -115,6 +115,17 @@ struct fdomain {
> 	struct work_struct work;
> };
>=20
> +struct fdomain_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *fdomain_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct fdomain_priv *fcmd =3D scsi_cmd_priv(cmd);
> +
> +	return &fcmd->scsi_pointer;
> +}
> +
> static inline void fdomain_make_bus_idle(struct fdomain *fd)
> {
> 	outb(0, fd->base + REG_BCTL);
> @@ -263,20 +274,21 @@ static void fdomain_work(struct work_struct *work)
> 	struct Scsi_Host *sh =3D container_of((void *)fd, struct Scsi_Host,
> 					    hostdata);
> 	struct scsi_cmnd *cmd =3D fd->cur_cmd;
> +	struct scsi_pointer *scsi_pointer =3D fdomain_scsi_pointer(cmd);
> 	unsigned long flags;
> 	int status;
> 	int done =3D 0;
>=20
> 	spin_lock_irqsave(sh->host_lock, flags);
>=20
> -	if (cmd->SCp.phase & in_arbitration) {
> +	if (scsi_pointer->phase & in_arbitration) {
> 		status =3D inb(fd->base + REG_ASTAT);
> 		if (!(status & ASTAT_ARB)) {
> 			set_host_byte(cmd, DID_BUS_BUSY);
> 			fdomain_finish_cmd(fd);
> 			goto out;
> 		}
> -		cmd->SCp.phase =3D in_selection;
> +		scsi_pointer->phase =3D in_selection;
>=20
> 		outb(ICTL_SEL | FIFO_COUNT, fd->base + REG_ICTL);
> 		outb(BCTL_BUSEN | BCTL_SEL, fd->base + REG_BCTL);
> @@ -285,7 +297,7 @@ static void fdomain_work(struct work_struct *work)
> 		/* Stop arbitration and enable parity */
> 		outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
> 		goto out;
> -	} else if (cmd->SCp.phase & in_selection) {
> +	} else if (scsi_pointer->phase & in_selection) {
> 		status =3D inb(fd->base + REG_BSTAT);
> 		if (!(status & BSTAT_BSY)) {
> 			/* Try again, for slow devices */
> @@ -297,75 +309,75 @@ static void fdomain_work(struct work_struct *work)
> 			/* Stop arbitration and enable parity */
> 			outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
> 		}
> -		cmd->SCp.phase =3D in_other;
> +		scsi_pointer->phase =3D in_other;
> 		outb(ICTL_FIFO | ICTL_REQ | FIFO_COUNT, fd->base + REG_ICTL);
> 		outb(BCTL_BUSEN, fd->base + REG_BCTL);
> 		goto out;
> 	}
>=20
> -	/* cur_cmd->SCp.phase =3D=3D in_other: this is the body of the routine =
*/
> +	/* fdomain_scsi_pointer(cur_cmd)->phase =3D=3D in_other: this is the bo=
dy of the routine */
> 	status =3D inb(fd->base + REG_BSTAT);
>=20
> 	if (status & BSTAT_REQ) {
> 		switch (status & (BSTAT_MSG | BSTAT_CMD | BSTAT_IO)) {
> 		case BSTAT_CMD:	/* COMMAND OUT */
> -			outb(cmd->cmnd[cmd->SCp.sent_command++],
> +			outb(cmd->cmnd[scsi_pointer->sent_command++],
> 			     fd->base + REG_SCSI_DATA);
> 			break;
> 		case 0:	/* DATA OUT -- tmc18c50/tmc18c30 only */
> -			if (fd->chip !=3D tmc1800 && !cmd->SCp.have_data_in) {
> -				cmd->SCp.have_data_in =3D -1;
> +			if (fd->chip !=3D tmc1800 && !scsi_pointer->have_data_in) {
> +				scsi_pointer->have_data_in =3D -1;
> 				outb(ACTL_IRQEN | ACTL_FIFOWR | ACTL_FIFOEN |
> 				     PARITY_MASK, fd->base + REG_ACTL);
> 			}
> 			break;
> 		case BSTAT_IO:	/* DATA IN -- tmc18c50/tmc18c30 only */
> -			if (fd->chip !=3D tmc1800 && !cmd->SCp.have_data_in) {
> -				cmd->SCp.have_data_in =3D 1;
> +			if (fd->chip !=3D tmc1800 && !scsi_pointer->have_data_in) {
> +				scsi_pointer->have_data_in =3D 1;
> 				outb(ACTL_IRQEN | ACTL_FIFOEN | PARITY_MASK,
> 				     fd->base + REG_ACTL);
> 			}
> 			break;
> 		case BSTAT_CMD | BSTAT_IO:	/* STATUS IN */
> -			cmd->SCp.Status =3D inb(fd->base + REG_SCSI_DATA);
> +			scsi_pointer->Status =3D inb(fd->base + REG_SCSI_DATA);
> 			break;
> 		case BSTAT_MSG | BSTAT_CMD:	/* MESSAGE OUT */
> 			outb(MESSAGE_REJECT, fd->base + REG_SCSI_DATA);
> 			break;
> 		case BSTAT_MSG | BSTAT_CMD | BSTAT_IO:	/* MESSAGE IN */
> -			cmd->SCp.Message =3D inb(fd->base + REG_SCSI_DATA);
> -			if (cmd->SCp.Message =3D=3D COMMAND_COMPLETE)
> +			scsi_pointer->Message =3D inb(fd->base + REG_SCSI_DATA);
> +			if (scsi_pointer->Message =3D=3D COMMAND_COMPLETE)
> 				++done;
> 			break;
> 		}
> 	}
>=20
> -	if (fd->chip =3D=3D tmc1800 && !cmd->SCp.have_data_in &&
> -	    cmd->SCp.sent_command >=3D cmd->cmd_len) {
> +	if (fd->chip =3D=3D tmc1800 && !scsi_pointer->have_data_in &&
> +	    scsi_pointer->sent_command >=3D cmd->cmd_len) {
> 		if (cmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {
> -			cmd->SCp.have_data_in =3D -1;
> +			scsi_pointer->have_data_in =3D -1;
> 			outb(ACTL_IRQEN | ACTL_FIFOWR | ACTL_FIFOEN |
> 			     PARITY_MASK, fd->base + REG_ACTL);
> 		} else {
> -			cmd->SCp.have_data_in =3D 1;
> +			scsi_pointer->have_data_in =3D 1;
> 			outb(ACTL_IRQEN | ACTL_FIFOEN | PARITY_MASK,
> 			     fd->base + REG_ACTL);
> 		}
> 	}
>=20
> -	if (cmd->SCp.have_data_in =3D=3D -1) /* DATA OUT */
> +	if (scsi_pointer->have_data_in =3D=3D -1) /* DATA OUT */
> 		fdomain_write_data(cmd);
>=20
> -	if (cmd->SCp.have_data_in =3D=3D 1) /* DATA IN */
> +	if (scsi_pointer->have_data_in =3D=3D 1) /* DATA IN */
> 		fdomain_read_data(cmd);
>=20
> 	if (done) {
> -		set_status_byte(cmd, cmd->SCp.Status);
> +		set_status_byte(cmd, scsi_pointer->Status);
> 		set_host_byte(cmd, DID_OK);
> -		scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
> +		scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
> 		fdomain_finish_cmd(fd);
> 	} else {
> -		if (cmd->SCp.phase & disconnect) {
> +		if (scsi_pointer->phase & disconnect) {
> 			outb(ICTL_FIFO | ICTL_SEL | ICTL_REQ | FIFO_COUNT,
> 			     fd->base + REG_ICTL);
> 			outb(0, fd->base + REG_BCTL);
> @@ -398,14 +410,15 @@ static irqreturn_t fdomain_irq(int irq, void *dev_i=
d)
>=20
> static int fdomain_queue(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
> {
> +	struct scsi_pointer *scsi_pointer =3D fdomain_scsi_pointer(cmd);
> 	struct fdomain *fd =3D shost_priv(cmd->device->host);
> 	unsigned long flags;
>=20
> -	cmd->SCp.Status		=3D 0;
> -	cmd->SCp.Message	=3D 0;
> -	cmd->SCp.have_data_in	=3D 0;
> -	cmd->SCp.sent_command	=3D 0;
> -	cmd->SCp.phase		=3D in_arbitration;
> +	scsi_pointer->Status		=3D 0;
> +	scsi_pointer->Message		=3D 0;
> +	scsi_pointer->have_data_in	=3D 0;
> +	scsi_pointer->sent_command	=3D 0;
> +	scsi_pointer->phase		=3D in_arbitration;
> 	scsi_set_resid(cmd, scsi_bufflen(cmd));
>=20
> 	spin_lock_irqsave(sh->host_lock, flags);
> @@ -440,7 +453,7 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
> 	spin_lock_irqsave(sh->host_lock, flags);
>=20
> 	fdomain_make_bus_idle(fd);
> -	fd->cur_cmd->SCp.phase |=3D aborted;
> +	fdomain_scsi_pointer(fd->cur_cmd)->phase |=3D aborted;
>=20
> 	/* Aborts are not done well. . . */
> 	set_host_byte(fd->cur_cmd, DID_ABORT);
> @@ -501,6 +514,7 @@ static struct scsi_host_template fdomain_template =3D=
 {
> 	.this_id		=3D 7,
> 	.sg_tablesize		=3D 64,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> +	.cmd_size		=3D sizeof(struct fdomain_priv),
> };
>=20
> struct Scsi_Host *fdomain_create(int base, int irq, int this_id,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

