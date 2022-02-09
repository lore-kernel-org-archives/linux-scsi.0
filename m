Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2693C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiBIS2o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbiBIS2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:28:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11258C05CB96
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:28:45 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HQ7Ix020167;
        Wed, 9 Feb 2022 18:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fOFFN5UYTjuoTzTtc7Qf4rk3fwZN9hzp1teH8Zdy8L8=;
 b=F7s3wINR3CZ4kYX+GIJ+caOgAiIF4TtmOQZ1mAtKhv4hEyXvWfq51BjnaOHwWhl4Q7ds
 z+hB2cKCY+AaeT6nQglfgAmT6vtY5E2WRQwZPx25SybMeDlO6c6terCodX3SKVFG5L5A
 p/iTyvuh7ppbCW9diCHLcKu9IIbSp7CY7OMviFWA5X9UMv/3+fy4cinzob9LpfwLJs1B
 w6cN4cKGwYD/TqlmAp7pG75dr6MUo/rlgOZQQXzhx1Q/cD9+wYGipI0zEW0k/qwVLTIp
 KEGtTbEB1lZNNwakWiZonK2NslFDPbOz2ufEVFXJJliuxmvoejn42SYCVpjJQ+WZuuOC OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e366wxrg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:28:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IQAW0167645;
        Wed, 9 Feb 2022 18:28:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by aserp3030.oracle.com with ESMTP id 3e1f9hu17q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:28:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXd08uzxVM8DVU2EdnSRTeknIZYLy9hp2K6cxc8kRuXiIlCYylNPgWCso4QeaJ1dFQQxQrH5SarPyAFXE4tJIipAE5VsgfKqAOuHcaqH4T4AsBxoTX9sFdmxbbBtLNt2Fp8OI8dTW+M8t/zgkhhas29kjp5jSH/46urXNa/ofEjhLG9jFPOV3dxNs9kou2K8XxrfgfD4szAoszNPSXhsCRPj4etu25GJffcTHdX4Y4JmvtvfaVsroznFQnzdFck6DP8XkKKUn0bGNjaeidpkEoBSiJ0ItPUYyQu9cKZV2DUp6dQBG1Za3a73lwVoDaBtjNMxWWfSUjoaoMzMyZo+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOFFN5UYTjuoTzTtc7Qf4rk3fwZN9hzp1teH8Zdy8L8=;
 b=enm3vJHzWzvKlLiz/EuPF/Zn8tHDhe9MLaY8g+tDk8ssczQPyJ9cXMUTkq5JoTc7POUeJrQZGdcKp9X6nCsMDUvWy9xsrMr7ecY+HZs1v2Qef83FWJQ43wAmGttiCFm/tjufKgweUN0KZ/160kX1iUaXE1q2oOek4tz5P3tAjOAV5W940I52aZPzBX5i/Ft9HFPzoc2hwPoOAr/24nPJ4gM+s9TOzCQ4E+hsNJGW+Gfd0HSFmHzb1fg9gnaaFI3ZdLYF9UQhX35QVihRtV10pyH75IHPINv5JJO1L6VvHGyDxh4+W0HgD25QOkLubysUwD2T+h5uW/WqLNpbv/ld4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOFFN5UYTjuoTzTtc7Qf4rk3fwZN9hzp1teH8Zdy8L8=;
 b=c5IzIGsxndnvwm0u1vAFfRhP5FOjbIbfKgC92dkfZ/mAQ6gqecveR8fmZj5XcqOyaI1hU9UHfdEOWxls2EgK42yiMKBoM9KmXJtWSRgRo4XCeUzUf8i4vI3JfKHH5YUDVhESZ9tBL6JgKNvhv6C1h3vt/RNuTgTZExHn0+ibmCU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR10MB1615.namprd10.prod.outlook.com (2603:10b6:301:7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:28:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:28:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH v2 24/44] libfc: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 24/44] libfc: Stop using the SCSI pointer
Thread-Index: AQHYHREl8X4iUoolhE2cqqFzZGf9q6yLi4UA
Date:   Wed, 9 Feb 2022 18:28:27 +0000
Message-ID: <C65F54D0-FCF1-45E3-B78E-E37E5103DF8A@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-25-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-25-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33598b2a-8f34-4bec-79a1-08d9ebf9f702
x-ms-traffictypediagnostic: MWHPR10MB1615:EE_
x-microsoft-antispam-prvs: <MWHPR10MB161524EF0A31E8C41EEA5E3EE62E9@MWHPR10MB1615.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HAWWs79UDO6gTKUN659GLGCRj00CcLmmuPPf/ifq9d0G2qTuhrsHoUoC0Vp6Hq309SaJsA35Vc0IBqLVkaaVV8SjJm51WaBv3szcj1Ld9MiDFawItrXNve2e+BM90D5K15mmXuyDNgwV1IlGFbxapxtJZxEIsLgrJiEoxe/RYElgyXRTZxxBe1I+59wq2UCB/qAtC23q5I0VQfzM5zds4WnH3kteoeD3u7zwz6VJwjvxOVtUKR5NFNX5JHfEXyZljdS0eHuK7eD/AB4m7np4/XmZHnz8/+0KgovgxjDBsXI1RI4LJnqEY+10ND79f97OLyjckIbrvQwMe2raBWDqE9JVv3TBhmvtswK50H+2YYY12ZYM5OmI/qOHx+A6CCWLBC8Qd1WyntEmYSwI8grAKsQEFESS0v0Ci2TDeQFm4W6+Xj7Wo9TKphI4Vh6A8UzLUAOVFEsGU0z9gNhF3R6Q3dZwYX7F7FzGVYKj3Uor7lR77w2MN1tZwhXfoFxc5zqwVVExphR1B1wF9TzlkQ+omlboKMi4VN+5ukX9aBOqskoqBNKtIfOH2ai8ELEeWn8tXx7G+hoUJte9ZQpvb4X190sidEz0Ae5xlvaKc04lOa4ye0t0TtldvUsMJGVtGT714H/3I2PqhRrB6wxGNHNfmsygFPQ/0IgGQkLtt6mgmt2mxQyjRFSLydw+RYBx4QCPxceKXulouYS2EkGcGQefi4D/ypqyJ5W2I7q45A8pazO0tdKKJ6xdrpT/sWe4lP2Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(6916009)(76116006)(186003)(64756008)(8936002)(66446008)(8676002)(2906002)(83380400001)(54906003)(66476007)(66556008)(91956017)(4326008)(86362001)(508600001)(30864003)(6512007)(53546011)(36756003)(6506007)(71200400001)(33656002)(5660300002)(38100700002)(2616005)(7416002)(122000001)(316002)(38070700005)(44832011)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3rC4+RXooBJWkHnYtgnuQpEoH3yyrqW7KsAzi9ymMyssYVpoL4LvxYOcoJSO?=
 =?us-ascii?Q?PQOj6VHTWYkHlcBLOziZvXtAMh7kmmIoAn9bNKaCo8tGYwS1MVYT2sUBkS/K?=
 =?us-ascii?Q?WVwL5cgzhbId/URzaIq1CYuWwTOT4X01mqYjkO3yLW0QlocHHsSoP/B/3Ibe?=
 =?us-ascii?Q?4V379OvllQBDuCE5RzRqm4EduJLRFTkjDPK5vlj9WLiYxDlLtMs5dMT853UV?=
 =?us-ascii?Q?vG8sm+0TUz9Ug5Ajrgue+iQSyYI8uCbiydvHnbpV7fzz/bEp4OLqJQyz05ey?=
 =?us-ascii?Q?di9esRRmOLprRWy8r5OHD4bdiIBjxc0bwNJt4KSonzVcvxPyaqPFlv2JV33A?=
 =?us-ascii?Q?KjYQ95KN4/Nsxg1xr6lQtHF8Y2TT4tzUH1gHhNRxL3m+HXPzzXqXoeyh5bG2?=
 =?us-ascii?Q?BfZGGxPvkJ7lVDCzxt+sfa6tY6gDmzieonLsI1hoD7vX14c5I5a0R5BYGI4B?=
 =?us-ascii?Q?MK0pnrzCP3W4mcUpHonBIGXbsaYiL+pCW/6k2cYfw2y2t276z2Xy/GzDci3s?=
 =?us-ascii?Q?J4JkewLV16fe42IQ8cMGOk5iSj+Pf5RrSg6eosS0yOjZBLfw0EdLPHnMrn9V?=
 =?us-ascii?Q?m+BPEUx5kjs/K+d2opWEfXLjVfOyV/qh9x8b6d9z7Om8JvXmmKtNU3mq500t?=
 =?us-ascii?Q?cxxXFqv/rN6bFT/h1qX2yB+jn6BM85tJeQF4uMRBOG3gn9/ClaVveFrzpI9z?=
 =?us-ascii?Q?0ivO9bUPebxJnKUSwDR2XLFRi5PJl7e+2zmC75leGH3CcGkpaNyLJ4ZHaN4m?=
 =?us-ascii?Q?AIZioExDT3vTh/FE4ZiXTjYbvgp9ilypLAsaZUjasMQxFIgfyZ3xxlfsOLMk?=
 =?us-ascii?Q?5lZ+Z51+Bmj3iNhRgnL5nab2m90Bm0LvY/7jiS0U3M1PHP45+d7WVNFkF0MR?=
 =?us-ascii?Q?NerTuDM0DsK8BTD4JCM8IiNn1JBWdIl2QelCD/P8mpaBKkgy1oKp6225MJvv?=
 =?us-ascii?Q?fi40AA9qGPurykNDaPX2leh+3wxCIC9vl14FrBH58JyrsAHibCw/eRQfDaN4?=
 =?us-ascii?Q?HQA1aUjFWEJ3trWdTtSG2k0jeg1iFX1ul/dqvGiCw1o8OGpeQAiXd4Dav7hw?=
 =?us-ascii?Q?txHaud5dSTunuuEgSr4pHgCD+lXsohGYIglAoaNXx6wqygnOVYIHd1gO65v7?=
 =?us-ascii?Q?CdP+LEVTu0Uj73Y+3uybEbr/3tZJCwuc9hVb0ocO/WsGXI8zmehRdq6Q8g/a?=
 =?us-ascii?Q?vmLM0zqScTPaMLcbeiEExQnCjqENrxNUTe8aoGQjO/py+VbpCf/6SO5T1KUW?=
 =?us-ascii?Q?K4Uf/UioNsLlsrBe51SCNMfa6jsaQlUP95IapfqsPqgJlHSeB5Ud4s0V8vhC?=
 =?us-ascii?Q?tBccC9MxBFXkI/mD+aGlH4uKDAM2OIdMKhzZN3j8Q5Dqkffx7z803AzJbe78?=
 =?us-ascii?Q?2/GoUAKwgqvftH/qwFZfkHpSR0iCbEdbDUzV+Pp6el5dSpsQ/7tRJUKj1r8e?=
 =?us-ascii?Q?leeMe7ruQAPk+s9iVY7QRFmD2UDMZ4M5St+xuoB536uktYk8YpPD5LWy38y1?=
 =?us-ascii?Q?7fnnyvnlxmYRkI31lWfvPKKghxSjptjKjwLylC0Zgz/nmB/zwiJaYSeLI5GG?=
 =?us-ascii?Q?Zed3SSy6ao+X170Zy7GCwwGiFEleocWvOMt1E5jkf7UT7Lwpr3h+LxsW6EjB?=
 =?us-ascii?Q?BXjHZFYhUDfJlZbU1U0ZX+VagNOtsh14wu3HWGEjgtYIBpscvNDwbgtkGTju?=
 =?us-ascii?Q?6HHQYTBRDsE043S9RIAMEuE0FlSJrEjNBbQoclvPfBflMPLQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C68E8BEE44DABA4AA19A1E3D6BD316A5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33598b2a-8f34-4bec-79a1-08d9ebf9f702
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:28:27.1904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B+HaefzoUHjsj/rwdwJRegarK0VN+5J34CdD1PfY+WQsE2TbcHelBoKQEXVnUjrsUyhnYvqkPlzQkJ8gIFFYA6FY8UT1yeYta7vrrY0uc84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-GUID: X1ClbcQ6jSNMGmb83bZd0q6oDjxQTxEm
X-Proofpoint-ORIG-GUID: X1ClbcQ6jSNMGmb83bZd0q6oDjxQTxEm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Move the fc_fcp_pkt pointer, the residual length and the SCSI status into
> the new data structure libfc_cmd_priv. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.
>=20
> The libfc users have been identified as follows:
>=20
> $ git grep -lw 'libfc_host_alloc' | grep -v /libfc
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> drivers/scsi/fcoe/fcoe.c
> drivers/scsi/fnic/fnic_main.c
> drivers/scsi/qedf/qedf_main.c
>=20
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Saurav Kashyap <skashyap@marvell.com>
> Cc: Javed Hasan <jhasan@marvell.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/bnx2fc/bnx2fc.h      | 10 ++++++++--
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
> drivers/scsi/bnx2fc/bnx2fc_io.c   | 20 ++++++++++----------
> drivers/scsi/fcoe/fcoe.c          |  1 +
> drivers/scsi/fnic/fnic.h          |  1 +
> drivers/scsi/libfc/fc_fcp.c       | 26 +++++++++++---------------
> drivers/scsi/qedf/qedf.h          | 11 ++++++++++-
> drivers/scsi/qedf/qedf_io.c       | 16 ++++++++--------
> drivers/scsi/qedf/qedf_main.c     |  3 ++-
> include/scsi/libfc.h              | 11 +++++++++++
> 10 files changed, 63 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> index b4cea8b06ea1..08deed26c51e 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -137,8 +137,6 @@
> #define BNX2FC_FW_TIMEOUT		(3 * HZ)
> #define PORT_MAX			2
>=20
> -#define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
> -
> /* FC FCP Status */
> #define	FC_GOOD				0
>=20
> @@ -493,7 +491,15 @@ struct bnx2fc_unsol_els {
> 	struct work_struct unsol_els_work;
> };
>=20
> +struct bnx2fc_priv {
> +	struct libfc_cmd_priv libfc_data; /* must be the first member */
> +	struct bnx2fc_cmd *io_req;
> +};
>=20
> +static inline struct bnx2fc_priv *bnx2fc_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
>=20
> struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt);
> struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type)=
;
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2=
fc_fcoe.c
> index a826456c6075..2d5c71967ee3 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2975,6 +2975,7 @@ static struct scsi_host_template bnx2fc_shost_templ=
ate =3D {
> 	.track_queue_depth	=3D 1,
> 	.slave_configure	=3D bnx2fc_slave_configure,
> 	.shost_groups		=3D bnx2fc_host_groups,
> +	.cmd_size		=3D sizeof(struct bnx2fc_priv),
> };
>=20
> static struct libfc_function_template bnx2fc_libfc_fcn_templ =3D {
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc=
_io.c
> index b9114113ee73..a1d0f7d34466 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -204,7 +204,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_re=
q, int err_code)
> 		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
> 		sc_cmd->allowed);
> 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
> -	sc_cmd->SCp.ptr =3D NULL;
> +	bnx2fc_priv(sc_cmd)->io_req =3D NULL;
> 	scsi_done(sc_cmd);
> }
>=20
> @@ -765,7 +765,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_c=
md, u8 tm_flags)
> 	task =3D &(task_page[index]);
> 	bnx2fc_init_mp_task(io_req, task);
>=20
> -	sc_cmd->SCp.ptr =3D (char *)io_req;
> +	bnx2fc_priv(sc_cmd)->io_req =3D io_req;
>=20
> 	/* Obtain free SQ entry */
> 	spin_lock_bh(&tgt->tgt_lock);
> @@ -1147,7 +1147,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
> 	BNX2FC_TGT_DBG(tgt, "Entered bnx2fc_eh_abort\n");
>=20
> 	spin_lock_bh(&tgt->tgt_lock);
> -	io_req =3D (struct bnx2fc_cmd *)sc_cmd->SCp.ptr;
> +	io_req =3D bnx2fc_priv(sc_cmd)->io_req;
> 	if (!io_req) {
> 		/* Command might have just completed */
> 		printk(KERN_ERR PFX "eh_abort: io_req is NULL\n");
> @@ -1572,7 +1572,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_=
req,
> 		printk(KERN_ERR PFX "tmf's fc_hdr r_ctl =3D 0x%x\n",
> 			fc_hdr->fh_r_ctl);
> 	}
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!bnx2fc_priv(sc_cmd)->io_req) {
> 		printk(KERN_ERR PFX "tm_compl: SCp.ptr is NULL\n");
> 		return;
> 	}
> @@ -1609,7 +1609,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_=
req,
> 		return;
> 	}
>=20
> -	sc_cmd->SCp.ptr =3D NULL;
> +	bnx2fc_priv(sc_cmd)->io_req =3D NULL;
> 	scsi_done(sc_cmd);
>=20
> 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
> @@ -1773,8 +1773,8 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd =
*io_req,
> 		io_req->fcp_resid =3D fcp_rsp->fcp_resid;
>=20
> 	io_req->scsi_comp_flags =3D rsp_flags;
> -	CMD_SCSI_STATUS(sc_cmd) =3D io_req->cdb_status =3D
> -				fcp_rsp->scsi_status_code;
> +	bnx2fc_priv(sc_cmd)->libfc_data.status =3D io_req->cdb_status =3D
> +		fcp_rsp->scsi_status_code;
>=20
> 	/* Fetch fcp_rsp_info and fcp_sns_info if available */
> 	if (num_rq) {
> @@ -1946,7 +1946,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cm=
d *io_req,
> 	/* parse fcp_rsp and obtain sense data from RQ if available */
> 	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq, rq_data);
>=20
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!bnx2fc_priv(sc_cmd)->io_req) {
> 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
> 		return;
> 	}
> @@ -2018,7 +2018,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cm=
d *io_req,
> 			io_req->fcp_status);
> 		break;
> 	}
> -	sc_cmd->SCp.ptr =3D NULL;
> +	bnx2fc_priv(sc_cmd)->io_req =3D NULL;
> 	scsi_done(sc_cmd);
> 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
> }
> @@ -2044,7 +2044,7 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
> 	io_req->port =3D port;
> 	io_req->tgt =3D tgt;
> 	io_req->data_xfer_len =3D scsi_bufflen(sc_cmd);
> -	sc_cmd->SCp.ptr =3D (char *)io_req;
> +	bnx2fc_priv(sc_cmd)->io_req =3D io_req;
>=20
> 	stats =3D per_cpu_ptr(lport->stats, get_cpu());
> 	if (sc_cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 6415f88738ad..44ca6110213c 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -277,6 +277,7 @@ static struct scsi_host_template fcoe_shost_template =
=3D {
> 	.sg_tablesize =3D SG_ALL,
> 	.max_sectors =3D 0xffff,
> 	.track_queue_depth =3D 1,
> +	.cmd_size =3D sizeof(struct libfc_cmd_priv),
> };
>=20
> /**
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index aa07189fb5fb..6ab444650f02 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -93,6 +93,7 @@
>  * These fields are locked by the hashed io_req_lock.
>  */
> struct fnic_cmd_priv {
> +	struct libfc_cmd_priv libfc_data; /* must be the first member */
> 	struct fnic_io_req *io_req;
> 	enum fnic_ioreq_state state;
> 	u32 flags;
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index 871b11edb586..bce90eb56c9c 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -45,14 +45,10 @@ static struct kmem_cache *scsi_pkt_cachep;
> #define FC_SRB_READ		(1 << 1)
> #define FC_SRB_WRITE		(1 << 0)
>=20
> -/*
> - * The SCp.ptr should be tested and set under the scsi_pkt_queue lock
> - */
> -#define CMD_SP(Cmnd)		    ((struct fc_fcp_pkt *)(Cmnd)->SCp.ptr)
> -#define CMD_ENTRY_STATUS(Cmnd)	    ((Cmnd)->SCp.have_data_in)
> -#define CMD_COMPL_STATUS(Cmnd)	    ((Cmnd)->SCp.this_residual)
> -#define CMD_SCSI_STATUS(Cmnd)	    ((Cmnd)->SCp.Status)
> -#define CMD_RESID_LEN(Cmnd)	    ((Cmnd)->SCp.buffers_residual)
> +static struct libfc_cmd_priv *libfc_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
>=20
> /**
>  * struct fc_fcp_internal - FCP layer internal data
> @@ -1137,7 +1133,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, =
struct fc_fcp_pkt *fsp)
> 	unsigned long flags;
> 	int rc;
>=20
> -	fsp->cmd->SCp.ptr =3D (char *)fsp;
> +	libfc_priv(fsp->cmd)->fsp =3D fsp;
> 	fsp->cdb_cmd.fc_dl =3D htonl(fsp->data_len);
> 	fsp->cdb_cmd.fc_flags =3D fsp->req_flags & ~FCP_CFL_LEN_MASK;
>=20
> @@ -1150,7 +1146,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, =
struct fc_fcp_pkt *fsp)
> 	rc =3D lport->tt.fcp_cmd_send(lport, fsp, fc_fcp_recv);
> 	if (unlikely(rc)) {
> 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
> -		fsp->cmd->SCp.ptr =3D NULL;
> +		libfc_priv(fsp->cmd)->fsp =3D NULL;
> 		list_del(&fsp->list);
> 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
> 	}
> @@ -1983,7 +1979,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
> 		fc_fcp_can_queue_ramp_up(lport);
>=20
> 	sc_cmd =3D fsp->cmd;
> -	CMD_SCSI_STATUS(sc_cmd) =3D fsp->cdb_status;
> +	libfc_priv(sc_cmd)->status =3D fsp->cdb_status;
> 	switch (fsp->status_code) {
> 	case FC_COMPLETE:
> 		if (fsp->cdb_status =3D=3D 0) {
> @@ -1992,7 +1988,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
> 			 */
> 			sc_cmd->result =3D DID_OK << 16;
> 			if (fsp->scsi_resid)
> -				CMD_RESID_LEN(sc_cmd) =3D fsp->scsi_resid;
> +				libfc_priv(sc_cmd)->resid_len =3D fsp->scsi_resid;
> 		} else {
> 			/*
> 			 * transport level I/O was ok but scsi
> @@ -2025,7 +2021,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
> 			 */
> 			FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
> 				   "due to FC_DATA_UNDRUN (scsi)\n");
> -			CMD_RESID_LEN(sc_cmd) =3D fsp->scsi_resid;
> +			libfc_priv(sc_cmd)->resid_len =3D fsp->scsi_resid;
> 			sc_cmd->result =3D (DID_ERROR << 16) | fsp->cdb_status;
> 		}
> 		break;
> @@ -2085,7 +2081,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
>=20
> 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
> 	list_del(&fsp->list);
> -	sc_cmd->SCp.ptr =3D NULL;
> +	libfc_priv(sc_cmd)->fsp =3D NULL;
> 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
> 	scsi_done(sc_cmd);
>=20
> @@ -2121,7 +2117,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
>=20
> 	si =3D fc_get_scsi_internal(lport);
> 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
> -	fsp =3D CMD_SP(sc_cmd);
> +	fsp =3D libfc_priv(sc_cmd)->fsp;
> 	if (!fsp) {
> 		/* command completed while scsi eh was setting up */
> 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
> diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
> index ca987451b17e..abb0c26da36e 100644
> --- a/drivers/scsi/qedf/qedf.h
> +++ b/drivers/scsi/qedf/qedf.h
> @@ -91,7 +91,6 @@ enum qedf_ioreq_event {
> #define FC_GOOD		0
> #define FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER	(0x1<<2)
> #define FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER	(0x1<<3)
> -#define CMD_SCSI_STATUS(Cmnd)			((Cmnd)->SCp.Status)
> #define FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID	(0x1<<0)
> #define FCOE_FCP_RSP_FLAGS_FCP_SNS_LEN_VALID	(0x1<<1)
> struct qedf_ioreq {
> @@ -189,6 +188,16 @@ struct qedf_ioreq {
> 	unsigned int alloc;
> };
>=20
> +struct qedf_cmd_priv {
> +	struct libfc_cmd_priv	libfc_data; /* must be the first member */
> +	struct qedf_ioreq	*io_req;
> +};
> +
> +static inline struct qedf_cmd_priv *qedf_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> extern struct workqueue_struct *qedf_io_wq;
>=20
> struct qedf_rport {
> diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
> index fab43dabe5b3..ed78a03a7e7c 100644
> --- a/drivers/scsi/qedf/qedf_io.c
> +++ b/drivers/scsi/qedf/qedf_io.c
> @@ -857,7 +857,7 @@ int qedf_post_io_req(struct qedf_rport *fcport, struc=
t qedf_ioreq *io_req)
>=20
> 	/* Initialize rest of io_req fileds */
> 	io_req->data_xfer_len =3D scsi_bufflen(sc_cmd);
> -	sc_cmd->SCp.ptr =3D (char *)io_req;
> +	qedf_priv(sc_cmd)->io_req =3D io_req;
> 	io_req->sge_type =3D QEDF_IOREQ_FAST_SGE; /* Assume fast SGL by default =
*/
>=20
> 	/* Record which cpu this request is associated with */
> @@ -1065,7 +1065,7 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *i=
o_req,
> 		io_req->fcp_resid =3D fcp_rsp->fcp_resid;
>=20
> 	io_req->scsi_comp_flags =3D rsp_flags;
> -	CMD_SCSI_STATUS(sc_cmd) =3D io_req->cdb_status =3D
> +	qedf_priv(sc_cmd)->libfc_data.status =3D io_req->cdb_status =3D
> 	    fcp_rsp->scsi_status_code;
>=20
> 	if (rsp_flags &
> @@ -1150,7 +1150,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, st=
ruct fcoe_cqe *cqe,
> 		return;
> 	}
>=20
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!qedf_priv(sc_cmd)->io_req) {
> 		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
> 		    "another context.\n");
> 		return;
> @@ -1312,7 +1312,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, st=
ruct fcoe_cqe *cqe,
> 	clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
>=20
> 	io_req->sc_cmd =3D NULL;
> -	sc_cmd->SCp.ptr =3D  NULL;
> +	qedf_priv(sc_cmd)->io_req =3D  NULL;
> 	scsi_done(sc_cmd);
> 	kref_put(&io_req->refcount, qedf_release_cmd);
> }
> @@ -1354,7 +1354,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct q=
edf_ioreq *io_req,
> 		goto bad_scsi_ptr;
> 	}
>=20
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!qedf_priv(sc_cmd)->io_req) {
> 		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
> 		    "another context.\n");
> 		return;
> @@ -1409,7 +1409,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct q=
edf_ioreq *io_req,
> 		qedf_trace_io(io_req->fcport, io_req, QEDF_IO_TRACE_RSP);
>=20
> 	io_req->sc_cmd =3D NULL;
> -	sc_cmd->SCp.ptr =3D NULL;
> +	qedf_priv(sc_cmd)->io_req =3D NULL;
> 	scsi_done(sc_cmd);
> 	kref_put(&io_req->refcount, qedf_release_cmd);
> 	return;
> @@ -2433,8 +2433,8 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 =
tm_flags)
> 		 (tm_flags =3D=3D FCP_TMF_TGT_RESET) ? "TARGET RESET" :
> 		 "LUN RESET");
>=20
> -	if (sc_cmd->SCp.ptr) {
> -		io_req =3D (struct qedf_ioreq *)sc_cmd->SCp.ptr;
> +	if (qedf_priv(sc_cmd)->io_req) {
> +		io_req =3D qedf_priv(sc_cmd)->io_req;
> 		ref_cnt =3D kref_read(&io_req->refcount);
> 		QEDF_ERR(NULL,
> 			 "orig io_req =3D %p xid =3D 0x%x ref_cnt =3D %d.\n",
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index 6ad28bc8e948..18dc68d577b6 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -740,7 +740,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
> 	}
>=20
>=20
> -	io_req =3D (struct qedf_ioreq *)sc_cmd->SCp.ptr;
> +	io_req =3D qedf_priv(sc_cmd)->io_req;
> 	if (!io_req) {
> 		QEDF_ERR(&qedf->dbg_ctx,
> 			 "sc_cmd not queued with lld, sc_cmd=3D%p op=3D0x%02x, port_id=3D%06x\=
n",
> @@ -996,6 +996,7 @@ static struct scsi_host_template qedf_host_template =
=3D {
> 	.sg_tablesize =3D QEDF_MAX_BDS_PER_CMD,
> 	.can_queue =3D FCOE_PARAMS_NUM_TASKS,
> 	.change_queue_depth =3D scsi_change_queue_depth,
> +	.cmd_size =3D sizeof(struct qedf_cmd_priv),
> };
>=20
> static int qedf_get_paged_crc_eof(struct sk_buff *skb, int tlen)
> diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
> index eeb8d689ff6b..5ae6d504e835 100644
> --- a/include/scsi/libfc.h
> +++ b/include/scsi/libfc.h
> @@ -351,6 +351,15 @@ struct fc_fcp_pkt {
> 	struct completion tm_done;
> } ____cacheline_aligned_in_smp;
>=20
> +/*
> + * @fsp should be tested and set under the scsi_pkt_queue lock
> + */
> +struct libfc_cmd_priv {
> +	struct fc_fcp_pkt *fsp;
> +	u32 resid_len;
> +	u8 status;
> +};
> +
> /*
>  * Structure and function definitions for managing Fibre Channel Exchange=
s
>  * and Sequences
> @@ -862,6 +871,8 @@ libfc_host_alloc(struct scsi_host_template *sht, int =
priv_size)
> 	struct fc_lport *lport;
> 	struct Scsi_Host *shost;
>=20
> +	WARN_ON_ONCE(sht->cmd_size < sizeof(struct libfc_cmd_priv));
> +
> 	shost =3D scsi_host_alloc(sht, sizeof(*lport) + priv_size);
> 	if (!shost)
> 		return NULL;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

