Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FFDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiCITFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiCITFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:05:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CDA3E5EE
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:04:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229IxALP021785;
        Wed, 9 Mar 2022 19:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MtWksE7+LFrIpy7Zz0ROzBXgJ9hKp2+P/cxAUgMoFkQ=;
 b=CHlsIFO6R4rIj0ZAtQ0A+LFoQiQl1KBafSYl4wkDGjGIHMC29sjejrpF3+KlmBJvX/4I
 tcUwYFSjGvxCXwq9c82pMM3uz0NyCTpbp8/C18QqadaNnqM+nQhXg6+MVqLAWN23JH2c
 ABhGVRZphaTqiPQGmATGiLTlI21C7+hf10wDTQQLH/ZXWzAy74hgslne31OLrEaQDmH0
 tgx89j8marY5Trt8k0zPN0Lz07dHOMEZ+nBZoW3F4drSj5j1Vm3crISe53OF5jYQ7aCw
 5ctbeWhANF1sDCxtgbV1PEkLz4hwRyppkot6cT7z39ZFlQYr4iwa8fQrLfO4qDb/hAS1 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0u3m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:04:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229J1FoD147296;
        Wed, 9 Mar 2022 19:04:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3ekyp345es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrgAeiiEajKyWKaqJWm+LMoFQgtyhZaHX/Jhq6JeWflv96n0xn3VMsAZSsoU/iDWzGSvL/G6VlbNbeMq++wD34mcKLfVSItaE9XjxXcKRZml47e3WSvC4ERDqYcsPQEQ+/Mav5mJ4/6j0UGO4jV8Djlo1V0ZWz1PbdoMef2k0v8eyPmpIxQI8Y1kgIQVg8moebFli1BolBiz0rQSe+uizSYS7hasCg43yleQ0ClFKRjknIIguBS4nTgwjd16TdXdFy1UEdVkjGubAr2GEfDao6iz9mzi6mF0+ot+qMw53OVEq6UvMlc0oMhkL5vzMtqbuSppLKW/cTMfw38NLvS90w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtWksE7+LFrIpy7Zz0ROzBXgJ9hKp2+P/cxAUgMoFkQ=;
 b=G8XtoOnfkZuCi4smILavE1uHR/grM96OsZCU4vzbXtZ69coPAICVNoF44CDiTk+bEzziuCr2XEq2AjkLYS44eU00UHj1x1XeC8480+Pk2VJG/Z4L1qwNobaM1XRA1GmrkfGTezE4Ey/CTYWT8UuTXx/JS3ogx+gqTukpT60+GPgDldUX7IpVrpDr+YfE9fLagB+KSzAUhl5YmSUXGKbItXqQkCyuy/m29PIkpxtHTopX4m5Ef34r/eQ0vxOFmgzrPOkfu8/dCNF2faKsaYC6E+BhFi/l8gBun+NP/ND51Vftw1qDVVY7YA7Khx3DEnkpTHLPG4oHLFbOo2giWvnyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtWksE7+LFrIpy7Zz0ROzBXgJ9hKp2+P/cxAUgMoFkQ=;
 b=gvIld7f8XWZ/shD0hwTU/fMQifYcRrqDwm5COZrtJHA4BxOSyDe6E92Sgw2jG08Okwcd+M9h/VtAl4tVeD6oi7QMeELC/E0z/1zuoaMMySEk2XRtB13l0d60cPEba6B2t6F8jPK2TnCWWfUUU09g9Tz1FrXcaI+74bM7gBCA7A4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR1001MB2065.namprd10.prod.outlook.com (2603:10b6:405:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.26; Wed, 9 Mar
 2022 19:04:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:04:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 08/13] qla2xxx: Fix laggy FC remote port session recovery
Thread-Topic: [PATCH 08/13] qla2xxx: Fix laggy FC remote port session recovery
Thread-Index: AQHYMsWEHzgaHAOYRU62lWdStDbt/6y3a1uA
Date:   Wed, 9 Mar 2022 19:04:08 +0000
Message-ID: <E5AE2112-92DB-4628-AAE1-B96661D3438F@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-9-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3416945f-72ce-4a27-1c13-08da01ff96ad
x-ms-traffictypediagnostic: BN6PR1001MB2065:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB206585538719F52A7AB6DCAAE60A9@BN6PR1001MB2065.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ll4kbkEJs4Hlxe4G7tZ53Q4JdxjT3imdtsANPItXJc5TrydGzOPiNIAv/juC8SQYMItzUdVbFIIT5mMN4VzSlQsH+BP/MpTsHgrAt4NKN7gL9H6e2tEanqlqmiTixVb9p+h+CBqWEIIBjezUNXvIFrPpR6jLYHJlzjY7fBUkUqpwLKo7CC0561xmcYzdGEYY7d3PQhtN1R6NAnJzaa87f3XfzdYbzICQnp5wk1gZR1pUVDioQOAnGevQZ+R4By8AQ21znj61H/G0pTzRSO6dI5RVFfZTAI1fcYxMGtkPebs241PxKOl5psCkVsBCNGcgr5G7kHcm3cBUiBNY596RerhivUK3DciQnSi6wXKXa2UzOnKDkXKnuJ1blchE/enTEtUo1o39Vbz4hpSpvU5vbyCMSCLboisdQtgUojzpyvGfJ6fREzjAf5gDkzKZLDZhFfRnvg53AaQTUWTlJSsmgiT+uwnTczqjA9yrOSJqP/Fkkvbyb8nfPgaWpWjsMVy5qWxWLoZ6Gst58RCLcGuiV2rahznbfKoPYd26XFly9mGLH6C88BvmqF95FTPvWQZ4nAXNJKX5nc0omN9IQzZKuOL+/k0H0jEqqEBvCzFo/8MD+DL4HRF0ihVMI6jtNu11NEUASSZ8RVg+cAaLZ4AdIUEe8Uz2d+8G6u1KMeLOISRd99oqDu8CDxgzoiGGdnylBd8wLBt0FKtA8eW12iuTGlbH9b7Qc3z0yUKw1N1jjmpQRvdrAB69gsW1hOqbOV5f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(316002)(6916009)(38100700002)(2906002)(71200400001)(36756003)(26005)(2616005)(186003)(508600001)(6486002)(54906003)(83380400001)(122000001)(8936002)(66476007)(5660300002)(6512007)(6506007)(66556008)(64756008)(66446008)(8676002)(91956017)(44832011)(66946007)(4326008)(76116006)(86362001)(38070700005)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gEjJ+JKuWpi4SLjNqvOUIAhPkHoRaVoiaiTOoZGjrhtshBJR1CyqjpLadL0g?=
 =?us-ascii?Q?2ibljsIDPmE2AztEjUqb825vumTn6UmGKGlvQz6z4WT1TZ6eEdpZOEORBaFH?=
 =?us-ascii?Q?sT6j8HNYpIBp28CWsaURzOdPo75RWeI2v7X8kJ3/5QGqvq1UbzLFU/ySMN1Q?=
 =?us-ascii?Q?dPjbYtK7ikt1/yTGh88VsZ5TPE7f20IrGGbWqyrX32kvXPlvZARdMc0+wbZ6?=
 =?us-ascii?Q?0B+S4wOoogWMqCXpVzNyQGyGyoVPvFu9r3cwDCG0zHoaDcn04B0Yp589PxHD?=
 =?us-ascii?Q?VH7riEXqioWHaWgeXMTmg1yJ5h5GD5F2BhCjexCFaOWbUU149jCuqEFv32m2?=
 =?us-ascii?Q?APValaRrw9wsqVUcv2xTETKVR/u1haUtG6F/5Ki0mljHm44AZUxxtCt72ua+?=
 =?us-ascii?Q?6FAZEw/dUnubMqf6xeg6Rj8Fi484L1TuWjQCAK45UJb9QjKGcfmuNJqmRNTJ?=
 =?us-ascii?Q?0GKOSwtU7CttfMu6Hyf1t7w5hUT02rUNFwfFMiYGfUX+SCkwJ0e6sauZQqhv?=
 =?us-ascii?Q?fqAvQ/qoFcqNbnivWoe+l4uMAx/lRRpvOhP0mzbDWD2Qvd8O4OBDJX+wJslM?=
 =?us-ascii?Q?sO0iJr0Jij7p3LHrx3ofoN6t6JixBSTacwB5x9MzlGh6Z0dc59iXIvJOK+5K?=
 =?us-ascii?Q?rqjPklgJDV7xeTMbs+xPbqBxlpfZdGaOr3YITMbUr6a8mYfWr6sZ1ShU8poQ?=
 =?us-ascii?Q?PuDTRS2ZcbWbb3Jv7m073e+M/4yR5KuJ/dcETTdl8wTap+DEfG5EWnDP+ADO?=
 =?us-ascii?Q?6JvRNYlfloIUCWgyLFwdFYjX/WnafuJ7PBy16s1SQoZkqxYC91i5TwEaQ6F1?=
 =?us-ascii?Q?wL3HHbpiv+76uyQ8xmLW0Os927nOSdk8pOukImLeQezPLqMUsN7LSwRsJYSH?=
 =?us-ascii?Q?MSPR2zIZhp+iT8dGYwGWWFTSG3md/N0elCBX3JuksqzMktJaY+zdV4tERY0A?=
 =?us-ascii?Q?Q1vD7EvqVfLqXIjsL6SQcjk5ZNiHmgiuNOm4ohnHZRLs6Ge/MvZ/hHuG47zR?=
 =?us-ascii?Q?018KWfZmLvTFdgsE4TmznTBxlW6qf6K2wnbLQA4oGFQbQCv5l6fkx8kiv9I1?=
 =?us-ascii?Q?Unsn3eRLDnwe3+dlPvafEl8pPQ5KtAM2bRSJ7CqOfLuhNYmxYr6EOLDNOjD5?=
 =?us-ascii?Q?RL0tWLsU06p2NwLngXcvqZF6hKXVLP3HtUI1AGjyn3/HceyS7gHCE8tJhKAr?=
 =?us-ascii?Q?waclwKTHwL6TuiNjKZjvYQzPNp2UkcKPcC7GzCVgVAtGznYqrPrboGB1D9ri?=
 =?us-ascii?Q?VyYAdLaMibT5JwblQKsgkn1MI9mWeWqtDu/54KpFqvDZJaMKe+GU/PHwBHnu?=
 =?us-ascii?Q?sV9YMGMojwrbLdRUEKAwS1z22iroM1BEt4hRCKTfut3mhy08D3gmgsamesxi?=
 =?us-ascii?Q?nGajopWoW6LDrKo02JyUweARhj2hQrK2rt4D7BvcoMCHtjXK5FT4SoR5Rhab?=
 =?us-ascii?Q?CH2LyG0JyK6Xwb/zj/+V7uh8YkCN5W6s7tFctkydYXMsBgyj09n+Ts2UHO+T?=
 =?us-ascii?Q?vLKEvwT2pq6/glteqBwG+FMv3eGLl5Iy2yW0PMZCGPcb5Zn/pTRMctlaVbwX?=
 =?us-ascii?Q?TH8bgwlf1P72OzdqO7WygvsSOBrUF/sAzNSCkqd20cC6wkGg2ykmVB8thRJe?=
 =?us-ascii?Q?62D5TmBeJNvLRdoSftWCgDiMrka6HhEbVIz4fn0LSOZJzAwRQgi1PPgDcsam?=
 =?us-ascii?Q?4UdutKBdHx4YC0YMZiSkFppKNsI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE776D1AAF7FBC40B12AF2CB0DAFB3A8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3416945f-72ce-4a27-1c13-08da01ff96ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:04:08.1937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8oDT0dxRodjc9h92iUShLQg9Cbl8iOgCm36QwyXMSL0/PRdTl/5/6IwStLa/6dxAiUrtwDT7XHbG1UiesV8mUaqP4OCquwGvI8TT9FkO7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2065
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090103
X-Proofpoint-ORIG-GUID: rtGXcJz0-LyLHypXxTPkFgHtY4TMdywB
X-Proofpoint-GUID: rtGXcJz0-LyLHypXxTPkFgHtY4TMdywB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> For session recovery, driver relies on the dpc thread to
> initiate certain operation. The dpc thread runs exclusively
> without the Mailbox interface being occupied. Recent code change
> for heartbeat check via mailbox cmd 0 is causing the dpc thread
> from carrying out its operation. This patch allows the higher
> priority error recovery to run first before running the lower priority
> heartbeat check.
>=20
> Cc: stable@vger.kernel.org
> Fixes: d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h |  1 +
> drivers/scsi/qla2xxx/qla_os.c  | 20 +++++++++++++++++---
> 2 files changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index b0579bce5b88..80b02b077753 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4621,6 +4621,7 @@ struct qla_hw_data {
> 	struct workqueue_struct *wq;
> 	struct work_struct heartbeat_work;
> 	struct qlfc_fw fw_buf;
> +	unsigned long last_heartbeat_run_jiffies;
>=20
> 	/* FCP_CMND priority support */
> 	struct qla_fcp_prio_cfg *fcp_prio_cfg;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index d572a76d0fa0..89c7ac36a41a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7218,7 +7218,7 @@ static bool qla_do_heartbeat(struct scsi_qla_host *=
vha)
> 	return do_heartbeat;
> }
>=20
> -static void qla_heart_beat(struct scsi_qla_host *vha)
> +static void qla_heart_beat(struct scsi_qla_host *vha, u16 dpc_started)
> {
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> @@ -7228,8 +7228,19 @@ static void qla_heart_beat(struct scsi_qla_host *v=
ha)
> 	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
> 		return;
>=20
> -	if (qla_do_heartbeat(vha))
> +	/*
> +	 * dpc thread cannot run if heartbeat is running at the same time.
> +	 * We also do not want to starve heartbeat task. Therefore, do
> +	 * heartbeat task at least once every 5 seconds.
> +	 */
> +	if (dpc_started &&
> +	    time_before(jiffies, ha->last_heartbeat_run_jiffies + 5 * HZ))
> +		return;
> +
> +	if (qla_do_heartbeat(vha)) {
> +		ha->last_heartbeat_run_jiffies =3D jiffies;
> 		queue_work(ha->wq, &ha->heartbeat_work);
> +	}
> }
>=20
> /************************************************************************=
**
> @@ -7420,6 +7431,8 @@ qla2x00_timer(struct timer_list *t)
> 		start_dpc++;
> 	}
>=20
> +	/* borrowing w to signify dpc will run */
> +	w =3D 0;
> 	/* Schedule the DPC routine if needed */
> 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
> 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
> @@ -7452,9 +7465,10 @@ qla2x00_timer(struct timer_list *t)
> 		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags),
> 		    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags));
> 		qla2xxx_wake_dpc(vha);
> +		w =3D 1;
> 	}
>=20
> -	qla_heart_beat(vha);
> +	qla_heart_beat(vha, w);
>=20
> 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
> }
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

