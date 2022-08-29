Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB0DECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiH2QY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiH2QYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:24:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E5D21A5
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:24:53 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TECbQJ023539;
        Mon, 29 Aug 2022 16:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rbZENq2bCLO0eZ5YsjNu90CxbryqHE4F8k2gnWWyQjE=;
 b=PyyI6/hYGxS4+dICoptHY4f5UgYkyB3g7x+ezDtIJnOFqrlOVPUvD0paTAJTl7PSbyOJ
 eEUxwb0pZqFTdZv4JxHE6Ly7KKXOLcG+sygUE+V7eS5YPLdFWcH28VQY0gGClBA2Fi9O
 vvoqHAtq2unLD9r2Qvn+FX491VUEOrcfR4c8Le1W/+pt8FpZiMIgz8tJqaTCaYJvHIdj
 H+OqO01zae2zv04VnK88QxnScVeT+yksvor5iEJcArjselVgn7iRxi7nq4liqTspezhR
 I0mrLVBUkEeMBEMAhmsSaFqc+esjyTwGz2a00qRjRMo7rRFvQ74YmdnFXSM9iSCNbg1a 3Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79v0kx09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:24:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TGJjiK005403;
        Mon, 29 Aug 2022 16:24:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2kj7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:24:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Agw3ZOZvs89f/fmG09QF9noUaj42pRBkE0T1wSpX6H2FpkflXW20/JasxosT9O6p66zD54KWY5TD83UDIEgWGtb61jdbIIkxP7G0kBuzeBdFvETncLlQA0aC5vLn4McpoWGBf+VS90VxwFJotQ37qC2ueGKeKiHeUX4f/Mn4We1pMjYjqEhTJwavqcscVi6jcVWA2kPVi6xFINyHx4hmbczaz1Y6X/FrRR/y76bCzc/SHmWiVJ6J4mO1RgKH+EP3zdmhmM+qwwEaUVhmk3QqaMMtXiFz3A23HBEtOSHTJCezchWMthmKIjcnrHu6KRrolR/5VXRiJqT6QzYZIwOSlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbZENq2bCLO0eZ5YsjNu90CxbryqHE4F8k2gnWWyQjE=;
 b=UierelMsCKPEDCox+O5r0Hch2aZrBxXVJW35ZWgJv0HPrXheQONGgFaYr0e/vAdL26BtzOCzrds+lIT/B4TpW5UMzbKPX4J73giqgHrKECBmuCnrpz6kH+SiTw95MaOBAQZKnDpjXPaFR+X4+AwgolTizU5bvnV86d0aeRPc2PqyU0via+B1gJwymugJPiGI3BEomzhmRUdIC7ZuGkIgB2xipGmy9Z2K+oHB6pSaYALsB0M8AYlMzfn+ZKRFqznagl762HB3AtHVgTW3lHuF2tVQT8uGqcJIGumtQGfEKq43r8dFVzMp5UtZP7XW32spxCzfIhJf5GwNL/8v/NC+mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbZENq2bCLO0eZ5YsjNu90CxbryqHE4F8k2gnWWyQjE=;
 b=oAaZGtq82Ma0msNV3h2pzc8g7G/16fVfaFYkNQgjXCC1yeaQb+tNHe+UuP62hk0Zt2nbdfZiumrM2+75nZqjyvFCPlHg8rLC3nzcVwKRseB9sWTyigdcujIweDQ0NpUrELoLmOqlXgoBXv/mO6tuD0DbsBxf6pVuWncN1ii3FXw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR10MB1783.namprd10.prod.outlook.com (2603:10b6:910:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 29 Aug
 2022 16:24:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:24:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Thread-Topic: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Thread-Index: AQHYuTZTuG7nZCJ7MkyaI5tU+DlS863GFUiA
Date:   Mon, 29 Aug 2022 16:24:48 +0000
Message-ID: <773B9D53-D043-42D9-B830-694A3E21A222@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d48ed34e-1837-4c8c-154f-08da89dafdd8
x-ms-traffictypediagnostic: CY4PR10MB1783:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vAM+9qbsxtKupSxEgP9XIB7UhSkmlUGjo5vTiygbwEcmhQ2GzFHZRtNa49eHiP6QwhngS1fLpzyH4IdITsrGAb/yznii52RcBUp9GEjJALBtX7azSprsq22KQfePucsCH3HncXUBsaGggRxCQMNQz29NjR2EoV3kWh2s9iVIfWyilLNxsAmgbLpJHZvUFo6C8yr1g0+an6RxOU/PaAEaQJaE4ouoELGksYtJN+xjGQq3fzQxp6ZQs2a528e34amOvPsStpGZCZfEGHmoeFhCh0jShbyt7yC5bLN87jmJ792fLvvKyGch0ZJuiIaGuEcG2TlX6RNOo78GjqTnADB7d64aMAlgLb3GULzxSJ/GKsgtpP28E1IEYTofQgWJKvAa+0wlTtmZLV1/DpSCsdLs0ufEf2ozJ1lTmvP6WDkgmAf2inRTIbYBCSpL1HOXnpPFNfSws6MhUqe8Df7UrrCt8H+7mgM37tVG7oI92wUElTWW+/+sgNvCU87UZ8G3l3VajCdxQSwSECCjSgVqeT3UhtvxLVbAPAZNmV04BLugDATFi3T4qvueMqeqBs/4//zLvCM0YYZ2fnJkPyRCKAXQLEuJNa2XZpbwFJWrLvQprvmQAKAC0VhySKOVclxfpFqEezs4/PkdMC11mSs5iq7gUjEYcMiyxCO9BQ5HynZbTuUZQxQxOFH551S/FQO7FkpCIsrGQ9bDrJVgYP/KMUhufjjSnWpZTp2sOvVK4wuVbiBrrFaWLaHkQLtmw4qy5h/U5kRXdtiDY8pfpaWxOjjkSW/cACp7T2jPYHwZ/ttG76Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(396003)(346002)(39860400002)(5660300002)(2616005)(38100700002)(86362001)(41300700001)(122000001)(71200400001)(54906003)(6916009)(33656002)(186003)(8936002)(316002)(83380400001)(91956017)(76116006)(478600001)(6512007)(44832011)(6506007)(38070700005)(2906002)(53546011)(6486002)(64756008)(26005)(8676002)(4326008)(66446008)(66946007)(66556008)(66476007)(30864003)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jz11yW9CoEnD10lL5Ud6Hu+ae9NRoQ2gDuaRQCZ4khpRcSrpqkLuK+CJUKTH?=
 =?us-ascii?Q?GlnxLNYra0UfaQS5w7nWZfSfyhesxc4ESwcCMGKql4khT92PJMxjNLx6n7ly?=
 =?us-ascii?Q?nuxDX9obeMBJivA0U/zP9EmSVzdTl8TYZdKyythckSrAk6r9aw92vZLiXEsO?=
 =?us-ascii?Q?3FzstWPNDLjMB17s7C+NuN2hNVIB+rfSfjrdMgIXmYkm4oeem70ET2uThnOS?=
 =?us-ascii?Q?PIEeoc4JTzlo89MsDIp7pCyY398ZYMvC9sogCjrSmmajwmHsQy5TObAFhERm?=
 =?us-ascii?Q?amNiE5n2QouhVkpJbGdtDLesTBBTixIU/AHXt2ud/N5nzi6b0K53M1SCIGwQ?=
 =?us-ascii?Q?NGN+I60QLFNhwT75RkcHegoEtddsdmqc+pcZ0wenkEgak8UrvyJ+O9m3wwMq?=
 =?us-ascii?Q?hWhsJ6Nt8pXJs7OElZdv3xGgB6pwC1UR3P3zlJqKEA5jITHz7T26aesXsioj?=
 =?us-ascii?Q?EBHDlZexEg3wUS/2KvSyuB822qkubibpgulcHaZIIW7becZZqfjuNLL/YF+a?=
 =?us-ascii?Q?tbHpSJGV8rJnd6rswH7d5taj9mCyKLiGb3laCzOIYnODRMMDtBhPLDz1Dsdv?=
 =?us-ascii?Q?445eRneb/FjFiIEkp4o4bC89xecdjEUzrTiM9WzYLouSKwPyAPbmveklR6XT?=
 =?us-ascii?Q?dSN3ifJOLbGm62M/+Dfg+ZfN/2chuM5CaEDcmsuJToIeXpU3TWOwBq3P8si/?=
 =?us-ascii?Q?Gmp7MLSKyPlebh7CUQDK5MziXoL5scD/Qx7q6qQNtLB2V0wPZryBWhkKcSzP?=
 =?us-ascii?Q?unc/s5C629g8AHGlHZIzrzAeng3/WymIsdzdxBohPdx47CEB/DjplR4nd+fH?=
 =?us-ascii?Q?GJG/WX5NL6/3tzc6bqbrBInBut4GoFjGtOGxVvkVBZILuDLRP1H3jmcvTyvI?=
 =?us-ascii?Q?7526W54YnsMuAD0GXeoFzilyEd/EBadLxXJNhmg1sxirq7Hpcszsj6lR149r?=
 =?us-ascii?Q?ZpuZxpDZDTXARvnsf7HdHECJPnGgIBkJ3hZRPLeBaGcUw8jLnKI/QZA1zHjx?=
 =?us-ascii?Q?aKboLux8wx06ya4NnFj/R0CucyUvcjmz6xRf0Lgo3R2DFzySVMswHXB6PLvv?=
 =?us-ascii?Q?+fhbFnd/ZDRZ/FNQiWpznpSmZggRwwSvD9qnt2i6nWTfBxvTVCuxrPAr74pA?=
 =?us-ascii?Q?8F0q1aBecl8id/IEmiY85+KKq3pd54YL35uC9om81qxAaofvKlcQqFbUjlhV?=
 =?us-ascii?Q?/wmb6mcVPTo9aEsZDnbcTucYS4aqw2uUnum61vSlAqv2fq90nDd2js7i71Wv?=
 =?us-ascii?Q?SBMe2KScf62OVSL44WwNw7p8ZVdfx1853WgAm0MAtDIjzKNyGpp6J1Mo2/kA?=
 =?us-ascii?Q?KjA0TgDsx4lP5BaIuOvvLCwS0lekwqw+60CevIwlL79Ib8bY480hDmoTSOQ9?=
 =?us-ascii?Q?O5PXP4v97Y7rkRGJbQP6oD8UUnOZT1DLQawv1xqsP6Lw1PzYAdxMQ3B6e79s?=
 =?us-ascii?Q?0TDPoXKYlhtAABwYAS3++Af+0VuqAxEcTB8vUmnEW3EZvIbaCYFgyygfPXcA?=
 =?us-ascii?Q?p7/W4fVymmZFMS+3+QDKYb+0fFE+LK7BuTCKgmV76tbys0Llpq5odZ+WBhc5?=
 =?us-ascii?Q?pAd7/yAkqCjekmNrEQacFzJlaIl5Pfhtlugj3u24U5WKEAvzO2Y9xSJkL8u8?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67A3BBFEB929AB4FAE0A3874F4F45686@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48ed34e-1837-4c8c-154f-08da89dafdd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:24:48.0862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rp0ikk1OFgd6FOp1kG/iETQVdfJXInI1NYg3JnFCRovDeYrJKOe35gXC6kmug69FobelQeDkceatQ4SFWtw3pCJ0/yfAQ6KzoJYKOtOhOwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290076
X-Proofpoint-GUID: Hw55dOF43K1NBQsFdw5WbCoKeq34l_1X
X-Proofpoint-ORIG-GUID: Hw55dOF43K1NBQsFdw5WbCoKeq34l_1X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Small nits

> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Older tracing of driver messages was to:
>    - log only debug messages to kernel main trace buffer AND
>    - log only if extended logging bits corresponding to this
>      message is off
>=20
> This has been modified and extended as follows:
>    - Tracing is now controlled via ql2xextended_error_logging_ktrace
>      module parameter. Bit usages same as ql2xextended_error_logging.
>    - Tracing uses "qla2xxx" trace instance, unless instance creation
>      have issues.
>    - Tracing is enabled (compile time tunable).
>    - All driver messages, include debug and log messages are now traced
>      in kernel trace buffer.
>=20
> Trace messages can be viewed by looking at the qla2xxx instance at:
>    /sys/kernel/tracing/instances/qla2xxx/trace
>=20
^^^^^^^^
This should be /sys/kernel/debug/tracing/instances/qla2xxx/trace

> Trace tunable that takes the same bit mask as ql2xextended_error_logging
> is:
>    ql2xextended_error_logging_ktrace (default=3D1)
>=20
> Suggested-by: Daniel Wagner <dwagner@suse.de>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.c | 50 ++++++++++++++++++++++++----------
> drivers/scsi/qla2xxx/qla_dbg.h | 43 +++++++++++++++++++++++++++++
> drivers/scsi/qla2xxx/qla_gbl.h |  1 +
> drivers/scsi/qla2xxx/qla_os.c  | 35 ++++++++++++++++++++++++
> 4 files changed, 115 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_db=
g.c
> index 7cf1f78cbaee..d7e8454304ce 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -2455,7 +2455,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha)
> /************************************************************************=
****/
>=20
> /* Write the debug message prefix into @pbuf. */
> -static void ql_dbg_prefix(char *pbuf, int pbuf_size,
> +static void ql_dbg_prefix(char *pbuf, int pbuf_size, struct pci_dev *pde=
v,
> 			  const scsi_qla_host_t *vha, uint msg_id)
> {
> 	if (vha) {
> @@ -2464,6 +2464,9 @@ static void ql_dbg_prefix(char *pbuf, int pbuf_size=
,
> 		/* <module-name> [<dev-name>]-<msg-id>:<host>: */
> 		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%lu: ", QL_MSGHDR,
> 			 dev_name(&(pdev->dev)), msg_id, vha->host_no);
> +	} else if (pdev) {
> +		snprintf(pbuf, pbuf_size, "%s [%s]-%04x: : ", QL_MSGHDR,
> +			 dev_name(&pdev->dev), msg_id);
> 	} else {
> 		/* <module-name> [<dev-name>]-<msg-id>: : */
> 		snprintf(pbuf, pbuf_size, "%s [%s]-%04x: : ", QL_MSGHDR,
> @@ -2491,20 +2494,20 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id,=
 const char *fmt, ...)
> 	struct va_format vaf;
> 	char pbuf[64];
>=20
> -	if (!ql_mask_match(level) && !trace_ql_dbg_log_enabled())
> +	ql_ktrace(1, level, pbuf, NULL, vha, id, fmt);
> +
> +	if (!ql_mask_match(level))
> 		return;
>=20
> +	if (!pbuf[0]) /* set by ql_ktrace */
> +		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, vha, id);
> +
> 	va_start(va, fmt);
>=20
> 	vaf.fmt =3D fmt;
> 	vaf.va =3D &va;
>=20
> -	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
> -
> -	if (!ql_mask_match(level))
> -		trace_ql_dbg_log(pbuf, &vaf);
> -	else
> -		pr_warn("%s%pV", pbuf, &vaf);
> +	pr_warn("%s%pV", pbuf, &vaf);
>=20
> 	va_end(va);
>=20
> @@ -2533,6 +2536,9 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint i=
d, const char *fmt, ...)
>=20
> 	if (pdev =3D=3D NULL)
> 		return;
> +
> +	ql_ktrace(1, level, pbuf, pdev, NULL, id, fmt);
> +
> 	if (!ql_mask_match(level))
> 		return;
>=20
> @@ -2541,7 +2547,9 @@ ql_dbg_pci(uint level, struct pci_dev *pdev, uint i=
d, const char *fmt, ...)
> 	vaf.fmt =3D fmt;
> 	vaf.va =3D &va;
>=20
> -	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id + ql_dbg_offset);
> +	if (!pbuf[0]) /* set by ql_ktrace */
> +		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), pdev, NULL,
> +			      id + ql_dbg_offset);
> 	pr_warn("%s%pV", pbuf, &vaf);
>=20
> 	va_end(va);
> @@ -2570,7 +2578,10 @@ ql_log(uint level, scsi_qla_host_t *vha, uint id, =
const char *fmt, ...)
> 	if (level > ql_errlev)
> 		return;
>=20
> -	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), vha, id);
> +	ql_ktrace(0, level, pbuf, NULL, vha, id, fmt);
> +
> +	if (!pbuf[0]) /* set by ql_ktrace */
> +		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, vha, id);
>=20
> 	va_start(va, fmt);
>=20
> @@ -2621,7 +2632,10 @@ ql_log_pci(uint level, struct pci_dev *pdev, uint =
id, const char *fmt, ...)
> 	if (level > ql_errlev)
> 		return;
>=20
> -	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL, id);
> +	ql_ktrace(0, level, pbuf, pdev, NULL, id, fmt);
> +
> +	if (!pbuf[0]) /* set by ql_ktrace */
> +		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), pdev, NULL, id);
>=20
> 	va_start(va, fmt);
>=20
> @@ -2716,7 +2730,11 @@ ql_log_qp(uint32_t level, struct qla_qpair *qpair,=
 int32_t id,
> 	if (level > ql_errlev)
> 		return;
>=20
> -	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), qpair ? qpair->vha : NULL, id);
> +	ql_ktrace(0, level, pbuf, NULL, qpair ? qpair->vha : NULL, id, fmt);
> +
> +	if (!pbuf[0]) /* set by ql_ktrace */
> +		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL,
> +			      qpair ? qpair->vha : NULL, id);
>=20
> 	va_start(va, fmt);
>=20
> @@ -2762,6 +2780,8 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, =
int32_t id,
> 	struct va_format vaf;
> 	char pbuf[128];
>=20
> +	ql_ktrace(1, level, pbuf, NULL, qpair ? qpair->vha : NULL, id, fmt);
> +
> 	if (!ql_mask_match(level))
> 		return;
>=20
> @@ -2770,8 +2790,10 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair,=
 int32_t id,
> 	vaf.fmt =3D fmt;
> 	vaf.va =3D &va;
>=20
> -	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), qpair ? qpair->vha : NULL,
> -		      id + ql_dbg_offset);
> +	if (!pbuf[0]) /* set by ql_ktrace */
> +		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL,
> +			      qpair ? qpair->vha : NULL, id + ql_dbg_offset);
> +
> 	pr_warn("%s%pV", pbuf, &vaf);
>=20
> 	va_end(va);
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_db=
g.h
> index feeb1666227f..70482b55d240 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -385,3 +385,46 @@ ql_mask_match(uint level)
>=20
> 	return level && ((level & ql2xextended_error_logging) =3D=3D level);
> }
> +
> +static inline int
> +ql_mask_match_ext(uint level, int *log_tunable)
> +{
> +	if (*log_tunable =3D=3D 1)
> +		*log_tunable =3D QL_DBG_DEFAULT1_MASK;
> +
> +	return (level & *log_tunable) =3D=3D level;
> +}
> +
> +/* Assumes local variable pbuf and pbuf_ready present. */
> +#define ql_ktrace(dbg_msg, level, pbuf, pdev, vha, id, fmt) do {	\
> +	struct va_format _vaf;						\
> +	va_list _va;							\
> +	u32 dbg_off =3D dbg_msg ? ql_dbg_offset : 0;			\
> +									\
> +	pbuf[0] =3D 0;							\
> +	if (!trace_ql_dbg_log_enabled())				\
> +		break;							\
> +									\
> +	if (dbg_msg && !ql_mask_match_ext(level,			\
> +				&ql2xextended_error_logging_ktrace))	\
> +		break;							\
> +									\
> +	ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), pdev, vha, id + dbg_off);	\
> +									\
> +	va_start(_va, fmt);						\
> +	_vaf.fmt =3D fmt;							\
> +	_vaf.va =3D &_va;							\
> +									\
> +	trace_ql_dbg_log(pbuf, &_vaf);					\
> +									\
> +	va_end(_va);							\
> +} while (0)
> +
> +#define QLA_ENABLE_KERNEL_TRACING
> +
> +#ifdef QLA_ENABLE_KERNEL_TRACING
> +#define QLA_TRACE_ENABLE(_tr) \
> +	trace_array_set_clr_event(_tr, "qla", NULL, true)
> +#else /* QLA_ENABLE_KERNEL_TRACING */
> +#define QLA_TRACE_ENABLE(_tr)
> +#endif /* QLA_ENABLE_KERNEL_TRACING */
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index bb69fa8b956a..2fc280e61306 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -163,6 +163,7 @@ extern int ql2xrdpenable;
> extern int ql2xsmartsan;
> extern int ql2xallocfwdump;
> extern int ql2xextended_error_logging;
> +extern int ql2xextended_error_logging_ktrace;
> extern int ql2xiidmaenable;
> extern int ql2xmqsupport;
> extern int ql2xfwloadbin;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 1c7fb6484db2..4a55c1e81327 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -15,6 +15,8 @@
> #include <linux/blk-mq-pci.h>
> #include <linux/refcount.h>
> #include <linux/crash_dump.h>
> +#include <linux/trace_events.h>
> +#include <linux/trace.h>
>=20
> #include <scsi/scsi_tcq.h>
> #include <scsi/scsicam.h>
> @@ -35,6 +37,8 @@ static int apidev_major;
>  */
> struct kmem_cache *srb_cachep;
>=20
> +struct trace_array *qla_trc_array;
> +
> int ql2xfulldump_on_mpifail;
> module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
> MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
> @@ -117,6 +121,11 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
> 		"ql2xextended_error_logging=3D1).\n"
> 		"\t\tDo LOGICAL OR of the value to enable more than one level");
>=20
> +int ql2xextended_error_logging_ktrace =3D 1;
> +module_param(ql2xextended_error_logging_ktrace, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(ql2xextended_error_logging_ktrace,
> +		"Same BIT definiton as ql2xextended_error_logging, but used to control=
 logging to kernel trace buffer (default=3D1).\n");
> +
> int ql2xshiftctondsd =3D 6;
> module_param(ql2xshiftctondsd, int, S_IRUGO);
> MODULE_PARM_DESC(ql2xshiftctondsd,
> @@ -2839,6 +2848,27 @@ static void qla2x00_iocb_work_fn(struct work_struc=
t *work)
> 	spin_unlock_irqrestore(&vha->work_lock, flags);
> }
>=20
> +static void
> +qla_trace_init(void)
> +{
> +	qla_trc_array =3D trace_array_get_by_name("qla2xxx");
> +	if (!qla_trc_array) {
> +		ql_log(ql_log_fatal, NULL, 0x0001,
> +		       "Unable to create qla2xxx trace instance, instance logging will=
 be disabled.\n");
> +		return;
> +	}
> +
> +	QLA_TRACE_ENABLE(qla_trc_array);
> +}
> +
> +static void
> +qla_trace_uninit(void)
> +{
> +	if (!qla_trc_array)
> +		return;
> +	trace_array_put(qla_trc_array);
> +}
> +
> /*
>  * PCI driver interface
>  */
> @@ -8181,6 +8211,8 @@ qla2x00_module_init(void)
> 	BUILD_BUG_ON(sizeof(sw_info_t) !=3D 32);
> 	BUILD_BUG_ON(sizeof(target_id_t) !=3D 2);
>=20
> +	qla_trace_init();
> +
> 	/* Allocate cache for SRBs. */
> 	srb_cachep =3D kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> 	    SLAB_HWCACHE_ALIGN, NULL);
> @@ -8259,6 +8291,8 @@ qla2x00_module_init(void)
>=20
> destroy_cache:
> 	kmem_cache_destroy(srb_cachep);
> +
> +	qla_trace_uninit();
> 	return ret;
> }
>=20
> @@ -8277,6 +8311,7 @@ qla2x00_module_exit(void)
> 	fc_release_transport(qla2xxx_transport_template);
> 	qlt_exit();
> 	kmem_cache_destroy(srb_cachep);
> +	qla_trace_uninit();
> }
>=20
> module_init(qla2x00_module_init);
> --=20
> 2.19.0.rc0
>=20

When you fix the commit message.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

