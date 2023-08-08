Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2CBC001DB
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbjHHQyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjHHQxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:53:38 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCB018C2E
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:58:42 -0700 (PDT)
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 378024Lp011989;
        Tue, 8 Aug 2023 04:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=Z3jBIoxNUmjeC/MhQJbboXq2Vuqn7bov93DivPBrzEI=;
 b=XpMQS1kxvxmebBPfJ5EuNs+ZqVgZbVNMdQPUo2gbDStJzL3eUGy91Z9Sdv4kzXyqlk0g
 SHwTs6kvfj5KKfbltJCMCowJjX28wE4qE8cRN5FYQ9iGONcKdxcQSPAIGL6bQHebBOx/
 dy++5zDkWbr28xRIWcPZkd9FCZo7q0NwtHS/ZLQ8kAfZy/xzP9/jtH1EvLE/PRz64Qr9
 2DcOk+t9taZUFCv+uaB3snGtI49fNgCq/d5fKkysgKvJfnNPMgwmBWW7aTbFS54Hdcjd
 KUMDnbPNduJuaCeCZsR5EsE7ggK5eNqYeTatJ2B7FK6fO+uJh8p8vPtKEYQnagrDAV2p uw== 
Received: from p1lg14880.it.hpe.com ([16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3sb9rka81b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Aug 2023 04:48:33 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 148C880018A;
        Tue,  8 Aug 2023 04:48:33 +0000 (UTC)
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 7 Aug 2023 16:48:32 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 7 Aug 2023 16:48:32 -1200
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 8 Aug 2023 04:48:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTtkrMN9Dab5hj3m1WQvXj9kvyjiMJBCznY909myOF40DmURcNTKVRhUMJKkMQhSHIy7B0R4VRGfmpxK0hCQgFnRd+2xW5cegWUOnEerMa/SfG0fl2oel9cQMfqIPCNmJvMlD+KqocBRHVxalPtt6qf/xX8oQSF9mEplKmm7tzK9MEW/HtEHjYntj9a/UPFTICxPSzGo5VguUSUsNtoBDNt9nd2oJ0FEhsDtfz2lrFdtxEx11lQdz7Fd5DniPZzh4uLb6+ZKUQ1QgvuZ0X8lyDxafsyriaY2iKI6IVlgKqiQnRrM2cw0n/OvILsIbMwKnP6rM3zC8yTfrfuEmkyzaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3jBIoxNUmjeC/MhQJbboXq2Vuqn7bov93DivPBrzEI=;
 b=gcWGlys5dGbrG+KY/wvGwaRKOfGV8is5+KEv57gFdfG3WVPfI4L7Zx3p5qAXg0UeixwaiOMrZqvgee21eCxnZCunaJUL1r2OPdcCm+UgZ5b1KvcEOBYKflUVARidXou850I2vxximw4ppIVIiPNp7N0CnUQlVREzE53rwyVjc9DNQh6wcq1zvvnfa81+YEH5SyLiUYaZbdfdK19zWzBxXpj7SX09lAiEoHkIUeTQMRE2Mk6eqyJyERsv3YOho/LEHVi2Jq6IDlSIL74tXwxQO6h1RfHHJj/1DeUQJU71lhoQJvaDpVVoHmbrbyxafJgxgLPB+6t08uFiawcbfnakLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DM4PR84MB1373.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:48::7) by
 DM4PR84MB1495.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.21; Tue, 8 Aug 2023 04:48:25 +0000
Received: from DM4PR84MB1373.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::4f2:1b58:220f:ee6b]) by DM4PR84MB1373.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::4f2:1b58:220f:ee6b%5]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 04:48:25 +0000
From:   "Seymour, Shane M" <shane.seymour@hpe.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [RFC] questions about some issues in the qla2xxx module
Thread-Topic: [RFC] questions about some issues in the qla2xxx module
Thread-Index: AdnJs2/iBy9LHkcXTEqprEaFk1PYTQ==
Date:   Tue, 8 Aug 2023 04:48:25 +0000
Message-ID: <DM4PR84MB1373A4864DA533B83C017E71FD0DA@DM4PR84MB1373.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR84MB1373:EE_|DM4PR84MB1495:EE_
x-ms-office365-filtering-correlation-id: 835cd54f-a5f3-4561-c829-08db97cab3bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RoIaOFxvng3L7kbKgJMFTIs8tNjIsnI54+A8J2DwRrY/LhRjUzxInZAEDlwAZQ93kUTmEYDHMJFzTlFAad4f7IjG06ywegdmcIqFI4FLPX2XiEvY92zuK/J60KFibAb7t5XBAXzEH38qtPs8RTGpTQFawVWu7FZ8Gd0OuujD/mLwfJxf9O2Y8rtxbtOoQpKNZFliCefBaN9w4mztqlqxr4uiX8rvdS6hYBC5UYQQ/Pn457B/GQv3pQjlDIFNH9mCZ4oAeS5UjeWlM9bYYq41PH6O6tHaOap+nH4Z8AhaNMFOS+KrVa1hNhSpInXFF4GbsEv+9PArOvMQ3YUBfJ8zXhH4D8aeVAJSc43PLt5EPdxKzdJz8FQwibdUGOmVj32qgjuf3LCLoc8IE1W7YtCRwcs40BFj36IyxLMItfnZwCyiQh7eJ1E/3b7y/XQ/KX5ZnG7urLor0YzNdUx2PU8NzK/o7Kz+aYUpneZlf9GQP93AyjkVDpZLGmb5RFiwk9Bidv80aydajREbB+gaG2GCG27Rp8InV5BLwZDJHiLD9FP/YdsAqWbn/dICP+xPuFEX2U05JVGLwFME/oQBw2PZEbiDa9/N5Q0ovaDj3iceX+CT5m6ADAlkdsNR+k0WWMMAuoecU8pjkj/15Tf+OSitZhNmuytNVANefONMfGYAU3TW1y/QtLDcRhnIDktPfd7PBRhgu8mEDxhxEFw3ePdk5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB1373.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(346002)(376002)(366004)(1800799003)(90011799007)(451199021)(90021799007)(186006)(7696005)(38070700005)(9686003)(71200400001)(55016003)(26005)(6506007)(43170500006)(83380400001)(55236004)(38100700002)(122000001)(33656002)(86362001)(5660300002)(41300700001)(8676002)(8936002)(66446008)(64756008)(66556008)(76116006)(2906002)(316002)(110136005)(82960400001)(478600001)(52536014)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9VFe+i99M0+kHsarj52FoXxrOsMBdKeQMq3liXvnMZ7ftD86g33yFjYFwJ6H?=
 =?us-ascii?Q?IyrzNDFfBsHPVecTly9Z+n4p47Q/A2ktpp1PSVPnzaAtq7ikx1FQlWWXgpJt?=
 =?us-ascii?Q?Ci0IW5G+0BMoNowAXyvJ7uW3DrNZfsgxqEP7fxlYK5bdJAb/kPC4z/NlIMzo?=
 =?us-ascii?Q?vmG6u5CILqI6koyuQiGuwADmYsZ+dOegL7Agd9bki6z4WhBY0HMP5xCfwqdZ?=
 =?us-ascii?Q?JTOBWTJkLpGDFUqXgQ7D1Y9SuTuzwevzc4pcFvfI0n8s4Gd2yugFW23Gm07r?=
 =?us-ascii?Q?ASYvEXa5hzm6LNyGjCbjvlRxgPtEjRZSQ0UD7BZW6+Uecp0f4FYH37SjZlDg?=
 =?us-ascii?Q?N1yRM3Zvc2iV2K8zYDL9MsMPGBr7qqV45dsQmcmqYs2mlrmU+3Hk8bvc1nEE?=
 =?us-ascii?Q?xLfF3ulwjogR2U1q3E3yxezfvFwz0Xe8RLEJM/wcEMTutYzIwebw6Lt15/m/?=
 =?us-ascii?Q?zAgUDEx6o0GL5w5LjQ6KtdrzlmB3fsEw3Zqsn0X9s5TjdL0ezAl+/k2bSx1m?=
 =?us-ascii?Q?kzA9kKsNBXjc5ynW+mKLQD4HmAtVecUDQxa2wTLBJBo1ad8LsLyIWirRklMH?=
 =?us-ascii?Q?pqDYnP40GUvUdtchlylXJHq+gI1Reh8uMKw4+FxXsSpZCL9qH3k5feSvSzrC?=
 =?us-ascii?Q?55GpthcB8XyiNwWhrx48wTBXmCE21xWlzwmz3aiJk9/Ame1zz3A1/s434E1R?=
 =?us-ascii?Q?K3a2wh20kA0VW/XLFaCo1Zx0XZ7+9oLwtKqjyL72K+1pgjvIAYIwYw334M9t?=
 =?us-ascii?Q?uRUTIyNooMgBu26KEbHM1jfzehHmyV9x2vKdzRztKpASOYb5w0u33VmkmJQg?=
 =?us-ascii?Q?BzcMZKm4Rwr2pAyEFcxiITAr/QyROg03+K4iPARvMf5D9K1Vdfeu2g6/wrTW?=
 =?us-ascii?Q?Utu3oJIzVHB0p81xBq7Xy52uNh1xZNhaFkWItkmKxTMRWKLmEa8G84kk/7zq?=
 =?us-ascii?Q?C6yhNThJHo2jBiMvPELBYx6AYfTFaw7rb5X6Waq47eN/w0GYr+KSzRH/euTW?=
 =?us-ascii?Q?zMNe0kDPdwNj1T+9rQm+PGRoYb8fXnwCmAXO4D4an3WH2c7Lmm6fAhpvyF84?=
 =?us-ascii?Q?kaEq5Ty1AsjsLS3K8RdEbWMzY06O5G1hq/ECOfzz3aH9P+3UiSCpQ781qD1K?=
 =?us-ascii?Q?5ZNupU47tHuB4ix9c+ylNRb8YZgkwjSgDSpjg4lbOOfOvLTTc5RFHhBBW/S5?=
 =?us-ascii?Q?H5/5KI0z2sxO9huWLj/ss4t3EipW4JN8pI62x1y/o3szQnZj8zOQB9m8gWlG?=
 =?us-ascii?Q?vVEyPAiarrXiFKkzek6OkeIoNOVXQK2LJvc34+AorJgND6SJfi7HB2d4mOCc?=
 =?us-ascii?Q?Hj6vkSSZZ8XSlYjfjAx9ual5eMaY2HDXNdzNgnwk+Aq+97cqSERKrXUk5/8g?=
 =?us-ascii?Q?2irWfwDQYhK4CREKmxML54nivqRNxgFCQJjj2WByXmuBMoJq1UpM5nW4sXzH?=
 =?us-ascii?Q?5/MkqpptafuxXXKClh2OnAH9vOqKCANMyFQ6N1gOgGb4xOotjVRkskXD5QKm?=
 =?us-ascii?Q?Xi/prFigvPP14SM7/EbAbDMlvIXIdcx/7jMN4EMNdh1vv+8tR+9yWMH+/6S9?=
 =?us-ascii?Q?gl3fKevqjkJcVlHqH+bF082lSmwxUN6p2+OGq7ep?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB1373.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 835cd54f-a5f3-4561-c829-08db97cab3bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2023 04:48:25.7357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QHokRNrpBrx1Y7dTy+b75sP3xYk55PRxdKMMbRnfsFj4yi45ENl+BSandtpUxwUJ3Yry45+Ve4yJrcTuA6l70g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1495
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: pckcIfs5aIuLdkPyzY4QnfnDvi9TZfv8
X-Proofpoint-ORIG-GUID: pckcIfs5aIuLdkPyzY4QnfnDvi9TZfv8
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-08_01,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 clxscore=1011
 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080042
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello qla2xxx maintainers,

I have some questions about the qla2xxx module after investigating somethin=
g downstream
and finding the same issues upstream (there are 3 issues below).

The first issue is in qla2x00_get_data_rate() there are two code segments t=
hat are
identical:

int
qla2x00_get_data_rate(scsi_qla_host_t *vha) {
	int rval;
	mbx_cmd_t mc;
	mbx_cmd_t *mcp =3D &mc;
	struct qla_hw_data *ha =3D vha->hw;

	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1106,
	    "Entered %s.\n", __func__);

	if (!IS_FWI2_CAPABLE(ha))
		return QLA_FUNCTION_FAILED;

	mcp->mb[0] =3D MBC_DATA_RATE;
	mcp->mb[1] =3D QLA_GET_DATA_RATE;
	mcp->out_mb =3D MBX_1|MBX_0;
	mcp->in_mb =3D MBX_2|MBX_1|MBX_0;
	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
		mcp->in_mb |=3D MBX_4|MBX_3;
	mcp->tov =3D MBX_TOV_SECONDS;
	mcp->flags =3D 0;
	rval =3D qla2x00_mailbox_command(vha, mcp);
	if (rval !=3D QLA_SUCCESS) {
		ql_dbg(ql_dbg_mbx, vha, 0x1107,
		    "Failed=3D%x mb[0]=3D%x.\n", rval, mcp->mb[0]);
	} else {
		if (mcp->mb[1] !=3D 0x7)                   <<<<<<<<<<<<<
			ha->link_data_rate =3D mcp->mb[1]; <<<<<<<<<<<<<

		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
			if (mcp->mb[4] & BIT_0)
				ql_log(ql_log_info, vha, 0x11a2,
				    "FEC=3Denabled (data rate).\n");
		}

		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
		    "Done %s.\n", __func__);
		if (mcp->mb[1] !=3D 0x7)                    <<<<<<<<<<<<<
			ha->link_data_rate =3D mcp->mb[1];  <<<<<<<<<<<<<
	}

	return rval;
}

As far as I can determine nothing in between them should change link_data_r=
ate.

This was introduced in the change 75666f4a8c41 ("scsi: qla2xxx: Display mes=
sage
for FCE enabled") and you can see the start of the duplicated code. Was the=
 second
instance of the if meant to be removed? It's also FEC not FCE.

In the message why use "(data rate)" when you could get the speed itself fr=
om
qla2x00_get_link_speed_str()?=20

The second issue is this function prints a message to the kernel message bu=
ffer but it
causes an issue in that qla2x00_get_data_rate() can be called from
qla2x00_configure_loop() and from here (that is fine for the former but not=
 the later):

static ssize_t
qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
    char *buf)
{
	struct scsi_qla_host *vha =3D shost_priv(dev_to_shost(dev));
	struct qla_hw_data *ha =3D vha->hw;
	ssize_t rval;
	u16 i;
	char *speed =3D "Unknown";

	rval =3D qla2x00_get_data_rate(vha);
	if (rval !=3D QLA_SUCCESS) {
		ql_log(ql_log_warn, vha, 0x70db,
		    "Unable to get port speed rval:%zd\n", rval);
		return -EINVAL;
	}

	for (i =3D 0; i < ARRAY_SIZE(port_speed_str); i++) {
		if (port_speed_str[i].rate !=3D ha->link_data_rate)
			continue;
		speed =3D port_speed_str[i].str;
		break;
	}

	return scnprintf(buf, PAGE_SIZE, "%s\n", speed);
}

So every time some reads the port_speed file it can log a kernel message so=
 if you=20
read the sysfs port_speed file a lot you can generate a lot of messages in =
the kernel
message buffer (messages have been changed manually):

2023-06-01T11:59:11.180034+02:00 example kernel: [2399544.415344][ XXXX] ql=
a2xxx
 [  0000:61:00.1]-11a2:1: FEC=3Denabled (data rate).
2023-06-01T11:59:11.810042+02:00 example kernel: [2399544.415764][ XXXX] ql=
a2xxx
 [  0000:61:00.1]-11a2:1: FEC=3Denabled (data rate).

Is that a defect? I wouldn't have expected reading a sysfs file to always g=
enerate
a kernel message into the kernel message buffer. The change that introduced=
 the
message doesn't seem to have taken into account that function can be called=
 from
two places.

Also, why isn't qla2x00_get_link_speed_str() used instead of adding
another structure containing almost identical speed data?

That leads onto the 3rd issue the really confusing ql_log function:

2572 ql_log(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...=
)
2573 {
2574         va_list va;
2575         struct va_format vaf;
2576         char pbuf[128];
2577=20
2578         if (level > ql_errlev)
2579                 return;
2580=20
2581         ql_ktrace(0, level, pbuf, NULL, vha, id, fmt);
2582=20
2583         if (!pbuf[0]) /* set by ql_ktrace */
2584                 ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, vha, id);
2585=20
2586         va_start(va, fmt);
2587=20
2588         vaf.fmt =3D fmt;
2589         vaf.va =3D &va;
2590=20
2591         switch (level) {
2592         case ql_log_fatal: /* FATAL LOG */
2593                 pr_crit("%s%pV", pbuf, &vaf);
2594                 break;
2595         case ql_log_warn: <<<<<<<<<<<<<<<<<<<<<<<<
2596                 pr_err("%s%pV", pbuf, &vaf); <<<<<<<<<<<<<<<<<<<<<<<<
2597                 break;
2598         case ql_log_info: <<<<<<<<<<<<<<<<<<<<<<<<
2599                 pr_warn("%s%pV", pbuf, &vaf); <<<<<<<<<<<<<<<<<<<<<<<<
2600                 break;
2601         default:
2602                 pr_info("%s%pV", pbuf, &vaf);
2603                 break;
2604         }
2605=20
2606         va_end(va);
2607 }

When I was looking at the driver I hadn't looked at ql_log() and was having=
 issues suppressing
the kernel messages from issue #2 above. When I did look I noticed that ql_=
log_info messages
are printed with pr_warn() (so it's really a warning not info). Should the =
log levels used in the
qla2xxx driver more generally reflect the kernel usage of message levels (i=
.e. ql_log_info
should use pr_info, etc)?

Thanks
Shane
