Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CCBC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 21:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiBNVBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:01:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiBNVBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 16:01:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3C47A9A3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 13:01:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EIJUKH021646;
        Mon, 14 Feb 2022 20:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vXNDnurWJMTDNKbqsWvDDkX8sFY3GybzGv/hzlSpcUc=;
 b=eXeh8WRLA2vJ1zV2jlAv1VODcwsAtDUxX232BQR4DFopbfpM+cIuBrmBhlxUQHOsIW1m
 qiK6X2qj4l2P02hRk+5Xii2O14mrKxTs8JOFnmPj292qi7lpdfxrLlcBqN3T1ETiSh8c
 pTl0lIYV/+4TUgLf5IK8XXK7elFJ6+ycro2g9SSzsZo1ZHQ6A+w9QZoR7s/PX7o4DmgG
 4Ayhg5+iT+I5bg9ZwAYmEVZdvrgfIE1y76RZTi0hQgMWKCJIuiauByJk3/rkaV95XYp1
 gm0LeWxP8D1VK/4PzaiDUBo01lE94Zk1lSC1LResJijx7TzW0ahk/8aO3eANzm/WOmAr sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63p25rtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:06:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EK0af0021472;
        Mon, 14 Feb 2022 20:06:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 3e620wg7dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:06:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnPZR7gtYdFfKhFH0IBRP2QwYj9H438HASzUBwWspVjQztwPQko0uuiteLQG4MiWe7JPpDQ7VWVDq0EE/FLS2BNJgou0SCOtcNRUs3STO95eN/p5/+AoFIfXBkWvoEH959PNBhh63hX6RbkrQi+dKo84zucS/rEsP2CDDYZUQk1hHt3Tge5eJR/qmtUdecaye/IhssmrZJ8vxyCJeffg5BkycULs7Zv6uA2mUGj1mZwOZxxy3ihi3BoJZ3sQXsNxrZi5rHYfaNJNQ/I3njEWwQWVd1TacIaCWxTyUqgp38hHdxGhN0basAihT7jxt+KbV2bDhJkutnOf0waJfYx6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXNDnurWJMTDNKbqsWvDDkX8sFY3GybzGv/hzlSpcUc=;
 b=G7TQa9w+CF5ugxymvvcYey1RY4jocyrSK09+qtLfCXCGEzrSSctsmJ0P2CjHoPjokZ2UibgOfkHzPANPIlagaJr6vThHCR5CCXBFYyt5ZRlfGZKUuBnZi5klnLGrMGrn0MaTrFqeeIjklRjVzEpGzGm3GgESTRXaBHNqyyuMJk1IcXRoRV6y0N6B/oD+XgfYwbLRvID5yvkP3QXji0xmVONRp0qxwTvmE448iS/J2IwdKOQBl4tejUl6zfpjD1puiB2tpGm3dFtt4ObAdWFWTT19bGjlolEKJLVezh125eXTJf/ACEFd/wBrxm8IN6C/Osrq2t0EZdbcy/00LCsxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXNDnurWJMTDNKbqsWvDDkX8sFY3GybzGv/hzlSpcUc=;
 b=zDEp8WtwnGjkE9rZ+Mv5iz2l8a5gH6Sf7Oc22CEXUO8zsi/stKJshIRGyIBQ0KUs1GRg4nYbmOzTA/pmFqT6bx+ux37rSADtoQ5WhOraDpdkcXgZDC9IrAc6mK4Gevgrtv6r+ndJTl1uNunK1+ZuGMVt90SObHyVABFXlZczVmI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BLAPR10MB5363.namprd10.prod.outlook.com (2603:10b6:208:334::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 20:05:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 20:05:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 05/48] scsi: nsp_cs: Use true and false instead of TRUE
 and FALSE
Thread-Topic: [PATCH v3 05/48] scsi: nsp_cs: Use true and false instead of
 TRUE and FALSE
Thread-Index: AQHYH5dfIlf4ctZ2VkKKbHhQVwdWl6yTfV4A
Date:   Mon, 14 Feb 2022 20:05:58 +0000
Message-ID: <400E8C05-81AC-4B3A-B394-CBB481CAED74@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-6-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3757912-fda4-4355-01aa-08d9eff56a7b
x-ms-traffictypediagnostic: BLAPR10MB5363:EE_
x-microsoft-antispam-prvs: <BLAPR10MB53636BAD20238EADB49802AAE6339@BLAPR10MB5363.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kIUhSX0p38xvm9kAFQAUYvk8H0i+vhMTveSx/hE2HbaHxh7HLy+w/7+kWSysZGb2fOjbbDE54hSWexVqFlYENj3D127/97qWO4feu+NJzdum8UfMUCxBX1cla7/MvWHaN4FqGwb5UJMAGAQGbsoZfyPZAsQTbahtLsUpWvbQh6gxe0KvYEcVjIMre2+r6IsLvVnGFjwJYTs7chZGZ2BgBjh07ZLz+VycJ09p9MMv6adIJZeHR/8eLdzptlEU7e79qsBxbXxoK0qiVXrXCG2/A49sUrmGzisUYewXASj4YFABV7I4q1w8G0n4tORnvM+6yKDAaAONiYSNHp7p7OTik8y00HWN6qooP4GcxR59Fieo2F/+OSeT2n36UhlEHNGMCy38QIWgVyyOfW8N1yTFcDtVd22AHAZ9cAte4CSYnttk1/TsRhJnIJb/Kga89p1WLgzCAN7diMiAGQRxKA1L1O2TuX5M/upviU6cOXDQJykSWAKNLYfeFc/Q77oDI+X46Bk2pHvWSQCicRnutrpV1xxfckwIGdhGlyBCvCrRmEXV10x7HfWCbqZSPYX0HwiqQwmLICyi7nSmoNRZgaU1ztEhsf/6TT26U7dmN+hIuqnnTkHyFssAXDvyCTb+3160avJfAa1jeOIr7V7KepcKHsZpGVtGb6u2/STeFAsbuogUfcWssUb7dOG2hALvRws5PBizabYHkHI0tHNbtNPDJms/FzD9kFVhnpE7L98KfUc3M5LZmU9iVIHL0dLCqnUC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(66946007)(316002)(6512007)(6916009)(53546011)(54906003)(76116006)(83380400001)(2906002)(38100700002)(66556008)(122000001)(64756008)(66476007)(66446008)(36756003)(38070700005)(33656002)(86362001)(8936002)(8676002)(4326008)(6506007)(71200400001)(508600001)(6486002)(5660300002)(44832011)(2616005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MpQtL3cIAPjwHYvHuNXPtmamijr0oLJ940WModIQwXEnJCL68KMYHPUYCgKH?=
 =?us-ascii?Q?XlKeo2hZ6bJ+Z/NK5gGRE+AMuY4UrCuuL8eq7DPbK+kTg13csV4gbUc47zfn?=
 =?us-ascii?Q?b2pl4skZcvpIlbVxVBQTVNy+ibic/x1sU/jtlMvoz/Txwhp3aIMy85nyMuAv?=
 =?us-ascii?Q?SntEElIZM1ua/tDt0L2/9ZBe26V0PZzWYyL8UWemYfxA+JjOFrOzCGJ/DZOM?=
 =?us-ascii?Q?B/a13+qktAH1yNwsHaq529dBb019q5KphnqaYNHq+wGWi9zkI0btsSVIG1EV?=
 =?us-ascii?Q?iZISUuzHHHacOkHPhjRC2wES292xjKX/cdRLCd8UIDdcOolZK7UZA4zK4OSf?=
 =?us-ascii?Q?fmjEValOkRnV6xiKcMotdABXQl0+xGA/3UqgpLjITuuR83AMPwL0JyOvOIjX?=
 =?us-ascii?Q?WSk8Fd6NbxoE76nSpCWBX9ZGwVibPFuo4jKk4gTySDMMIf232u8x03/L1EsK?=
 =?us-ascii?Q?y93qgpy74P+S3laemPClGcpVAgDUh+VZUd5A6JrqdQGv07vJ6QVUgiUDTBLs?=
 =?us-ascii?Q?731riWWrYBvUHy2nqKuN506tjQcqdBZ2lzcNLt0Vt9Ovma3z2rSyAEqu6UYo?=
 =?us-ascii?Q?s3xIM5CTR5hZ71DnVf0Gz/8fK0bsjvH872D0EtwtiI9egO/iZ3ur0iZWOygh?=
 =?us-ascii?Q?8QEQtA3rIhEV8J+KMcF+CbztHaQv1h64kqI/A3dvc4WZds1AXDehSVT4BnIV?=
 =?us-ascii?Q?nFHFeok07tHr2D0fKF9vwFXFsDDt/ZPwHw1l+oSmsn9LVWb+yqVnBIT+uSMM?=
 =?us-ascii?Q?xxCQwGDxr9AakdhOLg+jbHGbnMnFPzb33Ox87boGBXJHZk9/75f4p10OHejR?=
 =?us-ascii?Q?foeIUZsNhSNx+sjoKG1TKRmtFpGCg9NBZlg4iHCi5LOtcWDgKQWUOO1qc3o/?=
 =?us-ascii?Q?ih8gmzW9A/+DGUKu7cXF0RM2MDKzgb07izb1WNRKLp9QlfSdUGqiuSOZo/he?=
 =?us-ascii?Q?IA76AC7j6VA1yYAEvRw6nrgVBhZDGpzHbu/5ugj+xzmOC8fXXGJk8ofgHYA+?=
 =?us-ascii?Q?E7xqkjaI+K23io/RDlr5Gpb9LW0aiiu0vH2/WN3tLb7CIUIpuyHmOtLoSRFR?=
 =?us-ascii?Q?mRdKa/V19LhVZ6snSXoF58vsrBQBcJIpihmC4B/x1Qdco6ktFlmSekIPiDjK?=
 =?us-ascii?Q?TwnSJP/k5jwbylf9nOjhMjv4t/NiN7WD/XvOptiRwMbnnxhoUYaPDAZfe9Pe?=
 =?us-ascii?Q?VZQ2AcNE/82YpGEKxoqedGDLG1tX3tHUP35ScjXBYH/tZMldON2WHNZ+hagi?=
 =?us-ascii?Q?DO5L+WLcK+LkAWuR84TZr7PKkNQK7w0pSr+oJn5LvYjPXjBOhEON8t0mHsWS?=
 =?us-ascii?Q?ylyG0BCiBGU7iEa8cubq1vFEQj6FIHe7GIRkyrOUDGYcp/v8bIgIYgOlYjeH?=
 =?us-ascii?Q?g41rBq15OGfhUSeLae26E8zhdXeJ+2jJ6ZlwngCeQPGgfMzWkeEot13yLfE9?=
 =?us-ascii?Q?S8v1vVUwThtar3+Vni5/zEF5O6W6CxnrBaK+X7e+nK1fqEPWeg7lP/LJsfVu?=
 =?us-ascii?Q?aGjAVJo3aixzR/6Wm6cETI7B/rIplM2n+KWfIP//yJcHYugaigqkykXQGOAU?=
 =?us-ascii?Q?KeSNwJzn9FT99pQE1AllF+UbyVgvwfmf9pU/40k3dNV8xVWVdklIdzQFYdEK?=
 =?us-ascii?Q?JkXjQMSrRcz4siO+Z4gEjfpJoHFRcUyn3TTTeZnYD92abNdM0/Dw70VvtKHd?=
 =?us-ascii?Q?mGskAZM1rHiXVi/7v++qjZHz4wLOVnh6GJzjyWf/hCYFfy+v?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5DA4F85960DE4B40A96CDAC47036AD79@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3757912-fda4-4355-01aa-08d9eff56a7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 20:05:58.1326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUEoqOMY/rEr5okZRHVXXZArL1I/+FzRi3+m3iQunqr1z8zFXQbTrhOGdG6IMmj4MZjofBdbAEK9NOPPIfjfbvvU0q2s+gA5u+fntMRQOko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5363
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140116
X-Proofpoint-ORIG-GUID: 6YEpP_5GAUH2D6jsNNDVJrn-myf6Ar47
X-Proofpoint-GUID: 6YEpP_5GAUH2D6jsNNDVJrn-myf6Ar47
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch prepares for removal of the drivers/scsi/scsi.h header file. T=
hat
> header file defines the 'TRUE' and 'FALSE' constants.
>=20
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/pcmcia/nsp_cs.c | 26 +++++++++++++-------------
> drivers/scsi/pcmcia/nsp_cs.h |  2 +-
> 2 files changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index a5c2dd7ebc16..a78a86511e94 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -243,7 +243,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCp=
nt)
> 		SCpnt->SCp.buffers_residual =3D 0;
> 	}
>=20
> -	if (nsphw_start_selection(SCpnt) =3D=3D FALSE) {
> +	if (!nsphw_start_selection(SCpnt)) {
> 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
> 		SCpnt->result   =3D DID_BUS_BUSY << 16;
> 		nsp_scsi_done(SCpnt);
> @@ -263,14 +263,14 @@ static DEF_SCSI_QCMD(nsp_queuecommand)
> /*
>  * setup PIO FIFO transfer mode and enable/disable to data out
>  */
> -static void nsp_setup_fifo(nsp_hw_data *data, int enabled)
> +static void nsp_setup_fifo(nsp_hw_data *data, bool enabled)
> {
> 	unsigned int  base =3D data->BaseAddress;
> 	unsigned char transfer_mode_reg;
>=20
> 	//nsp_dbg(NSP_DEBUG_DATA_IO, "enabled=3D%d", enabled);
>=20
> -	if (enabled !=3D FALSE) {
> +	if (enabled) {
> 		transfer_mode_reg =3D TRANSFER_GO | BRAIND;
> 	} else {
> 		transfer_mode_reg =3D 0;
> @@ -348,13 +348,13 @@ static void nsphw_init(nsp_hw_data *data)
> 					    SCSI_RESET_IRQ_EI	 );
> 	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
>=20
> -	nsp_setup_fifo(data, FALSE);
> +	nsp_setup_fifo(data, false);
> }
>=20
> /*
>  * Start selection phase
>  */
> -static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
> +static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
> {
> 	unsigned int  host_id	 =3D SCpnt->device->host->this_id;
> 	unsigned int  base	 =3D SCpnt->device->host->io_port;
> @@ -368,7 +368,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SC=
pnt)
> 	phase =3D nsp_index_read(base, SCSIBUSMON);
> 	if(phase !=3D BUSMON_BUS_FREE) {
> 		//nsp_dbg(NSP_DEBUG_RESELECTION, "bus busy");
> -		return FALSE;
> +		return false;
> 	}
>=20
> 	/* start arbitration */
> @@ -388,7 +388,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SC=
pnt)
> 	if (!(arbit & ARBIT_WIN)) {
> 		//nsp_dbg(NSP_DEBUG_RESELECTION, "arbit fail");
> 		nsp_index_write(base, SETARBIT, ARBIT_FLAG_CLEAR);
> -		return FALSE;
> +		return false;
> 	}
>=20
> 	/* assert select line */
> @@ -407,7 +407,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SC=
pnt)
> 	nsp_start_timer(SCpnt, 1000/51);
> 	data->SelectionTimeOut =3D 1;
>=20
> -	return TRUE;
> +	return true;
> }
>=20
> struct nsp_sync_table {
> @@ -477,7 +477,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
> 		sync->SyncRegister    =3D 0;
> 		sync->AckWidth	      =3D 0;
>=20
> -		return FALSE;
> +		return false;
> 	}
>=20
> 	sync->SyncRegister    =3D (sync_table->chip_period << SYNCREG_PERIOD_SHI=
FT) |
> @@ -486,7 +486,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
>=20
> 	nsp_dbg(NSP_DEBUG_SYNC, "sync_reg=3D0x%x, ack_width=3D0x%x", sync->SyncR=
egister, sync->AckWidth);
>=20
> -	return TRUE;
> +	return true;
> }
>=20
>=20
> @@ -633,7 +633,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCp=
nt)
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
> 	SCpnt->SCp.phase =3D PH_DATA;
> 	nsp_pio_read(SCpnt);
> -	nsp_setup_fifo(data, FALSE);
> +	nsp_setup_fifo(data, false);
>=20
> 	return 0;
> }
> @@ -927,7 +927,7 @@ static int nsp_nexus(struct scsi_cmnd *SCpnt)
> 	}
>=20
> 	/* setup pdma fifo */
> -	nsp_setup_fifo(data, TRUE);
> +	nsp_setup_fifo(data, true);
>=20
> 	/* clear ack counter */
>  	data->FifoCount =3D 0;
> @@ -1210,7 +1210,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 		//*sync_neg =3D SYNC_NOT_YET;
>=20
> 		data->MsgLen =3D i =3D 0;
> -		data->MsgBuffer[i] =3D IDENTIFY(TRUE, lun); i++;
> +		data->MsgBuffer[i] =3D IDENTIFY(true, lun); i++;
>=20
> 		if (*sync_neg =3D=3D SYNC_NOT_YET) {
> 			data->Sync[target].SyncPeriod =3D 0;
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index 94c1f6c7c601..7d5d1a5b36e0 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -305,7 +305,7 @@ static int nsp_bus_reset       (nsp_hw_data *data);
>=20
> /* */
> static void nsphw_init           (nsp_hw_data *data);
> -static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
> +static bool nsphw_start_selection(struct scsi_cmnd *SCpnt);
> static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
> static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
> static void nsp_pio_read         (struct scsi_cmnd *SCpnt);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

