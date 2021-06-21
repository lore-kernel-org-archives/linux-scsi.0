Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C63C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 05:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD606100A
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 05:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFUFZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:25:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17990 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhFUFZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Jun 2021 01:25:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15L5GX9N017829;
        Sun, 20 Jun 2021 22:23:13 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 399g3qn7kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Jun 2021 22:23:12 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15L5IDL9020280;
        Sun, 20 Jun 2021 22:23:11 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 399g3qn7kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Jun 2021 22:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUGQox4f9VGubJlFwiLCSWSrq0Wb3IZH+hMSsklPR7SINvr52BRp/e67Net6fiBTO8swrfLJoW559lMCaL9ddCYecsjLEkXYzh/DOVaA6Xw5E6PLuAvVu1yJcjGkIj2Lu8sj4qN2muD3F/ViVr4NaZ+ZVsAHwuhLe72GytJlDWoKbmMBBrv2WlvadN3S3Tt1Hkjw5/Ehku5derL9PBUw/rz4uM7MZq8FPQyuoVbMw+60hzPj9UkM+eN+u2kCgWpICe/ynCA0hft40z0aExfU3cJcQs6oKy++5xfg5oXNOhFOV4XlJ6ok6tPeHduceIKpQMNKrIVhigNFmO7YnleJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT6sTws+zXkrGccPzPoqP92gtbXJGgtRHL5BXoZjXkQ=;
 b=LPw+U9fvmNuIEzhTSgp/OTyBddmss/6sS2423/evsuYxLF4sShvCdvXRsp2An98SzyT2oiBYRzkEfZSg6BkOD3F9cLXm6lPQDVINLqRHMSITqZVOlBbgtILt/pi+nb4+l8mETRhNjsBnOvJsRF8fXJrzR4VYqN+z0OtNtszsT+gYWrtgG6akqs3UCttURrb2SkkGXON5QzVrNslQo5OOeAUHgKOGJcLSUhyiLSA4ZlQu9AzpX3pBZ/THSywP3MkCWJ+DCqK9MvvxPfONER98c/jL9SOAOmCPOW8yy/Fs04msabReO7MBLSbukASuTzUCx/MIN7y4bIgLyNj4/VeOZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT6sTws+zXkrGccPzPoqP92gtbXJGgtRHL5BXoZjXkQ=;
 b=NkWx1swgm+8rlV1NUP32oFXM98CQJyOBG1O7Bu3YiJJnPNv53m3OoHSKv5YlOvgWZgjDcDjVUFa27Cvwyrzu0MySmNXJyNImferUoODFz96EYEx1bEYgzjoOS9Qtv+V2b1OarshcrA9UMUdMVmsP9y3/sYWVMN2VJ0/FSYX2pus=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3035.namprd18.prod.outlook.com (2603:10b6:5:185::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Mon, 21 Jun
 2021 05:23:10 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::b012:643f:6fd6:350a]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::b012:643f:6fd6:350a%3]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 05:23:10 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     SeongJae Park <sj38.park@gmail.com>
CC:     Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "himanshu.madhani@oracle.com" <himanshu.madhani@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>
Subject: RE: [EXT] [PATCH] scsi: bnx2fc: Remove meaningless
 'bnx2fc_abts_cleanup()' return value assignment
Thread-Topic: [EXT] [PATCH] scsi: bnx2fc: Remove meaningless
 'bnx2fc_abts_cleanup()' return value assignment
Thread-Index: AQHXZGFW/m6s108dKEO3/NZ6aDBFWasd8fYQ
Date:   Mon, 21 Jun 2021 05:23:10 +0000
Message-ID: <DM6PR18MB30345324649F1B1E05082970D20A9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210618164514.6299-1-sj38.park@gmail.com>
In-Reply-To: <20210618164514.6299-1-sj38.park@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.82.96.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e881f63a-cef9-4243-77ea-08d93474a8de
x-ms-traffictypediagnostic: DM6PR18MB3035:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB303517ABECC4D38DD937A509D20A9@DM6PR18MB3035.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J52OXRP73UF6qKC+5mfrS4duxRctsQ3Ni4x81Bg1JhO/+C+ZDfZb+VAe2BNP1Ruc9zLutKEavo/P+zLnA5RGgawYlixhYlnU0GR5BgqIZwyS+AFkcSiKZYgceqDEjgDvTGsjyhLDSubgCZAGpwQdgi7t89MqbhK6I78YcotuEucRrfdlIQZta2J1tV2/FgFzW8am2XDR+47Kqcvex2E0qwMuma6zkWeqabFsU8U0ReqK+YgjdA7NSi4TL34si5nrGhGuN9gzZnjfrDb9Qf9OP2jPeLfEXwX1AcMW0Ohq/rWLDeYZ37kPrnSx6smrKPPVw+dPBpzA91aVih3695gK+pcxYsVFSkG+OKuS7iuK9nYtG0ijlJFGiwTxV9DW308A74Uc8b7Z/bpvYKtSV9DIiR0CN77hg4ifPA6hTopkk8fy0jQZTxz2V4AEvVyViNBxztwTkuDFY5PQVmyQIGU41TrF8S3n0wGsKcfZ+poANuWVaIGmzgrbaCfz1LJdKF1Q2WGr9tWuBFqVLHn8KrJu4dAiR+tdwGNiv8WikjPbtqp4Bku2rQd8qrxcgwskZLVi+09WFHQt69q7MwO2fIRfW2BKpj7NxAtTMqsvEihYCLY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(8676002)(8936002)(55016002)(6506007)(478600001)(4326008)(186003)(9686003)(33656002)(53546011)(26005)(83380400001)(76116006)(66556008)(71200400001)(6916009)(52536014)(38100700002)(86362001)(54906003)(7696005)(66946007)(66476007)(2906002)(66446008)(122000001)(64756008)(316002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Kh2aNon/I8JbzdDKfXXha3wdXbF3XfTjxtwdOI+rG/kpErHLTZpyxxqg6Nm?=
 =?us-ascii?Q?DNF3OPBbBRUiZtw/Qf1DvcQYZx0tLvU5toOX3hclyhOr+akM23z6161JIzbX?=
 =?us-ascii?Q?iL7cN8oDcI/SYtvu5HWZWSu8pe8+mOxEJ4oHOkw0w03zGRtSnOPLouWxHkUJ?=
 =?us-ascii?Q?o00o0Tc8D6yGFw+tL1rCW7AH7j1G77obl+EXINLKjCBMdevTkz5q+hTQX7jX?=
 =?us-ascii?Q?jVbwyaix3Jw7H30iuq7Rv04IhPH9B96BCK27tjn6aJHHK/HWytMqJVpupYhK?=
 =?us-ascii?Q?ag6tV2TiI7pYlA5EipgHDvMiU4KLso9oOAqO4gUqR8mwrKKzGqa0uLG75W4s?=
 =?us-ascii?Q?/VunYZ7WMXqjkXxyreC5mBOdWFYmOL8U9S7SidwxB2TJfRvMkSGrT0WimQLl?=
 =?us-ascii?Q?rfCKwr0OXnvd7EoWCA4d9CKMl8P/uVd0if6OQ8vKKmGFKRguiYyCcc7cO/Ck?=
 =?us-ascii?Q?Qnuax3w/yX6QcwObmLDZ1oMwXhNwwxC2S4rKj+rfVSQjt4q0ViIIkleAzfiH?=
 =?us-ascii?Q?Q/HJB9z7Ev95DkbsZppL2OXoDQCMloACssh2RDWMbs6NOd2BpBhbQHTadCK9?=
 =?us-ascii?Q?YaOLpYsmaSw6wmcQ2RU+OU+yJKSiC4dNsKg5SBXE2yAfE9HAM1FcBM7lP7tT?=
 =?us-ascii?Q?lBzrVET5P+Vbv1bSDASjVOTWH1rvhrPOGOcsZNoDTuGZu3FaUkV02qXK+Vc8?=
 =?us-ascii?Q?LXKk6g3Zy2y45Tj0esqlaW4JnNRqB1N+h3agUScxRXY2/QoL9o+eX8aFkMgo?=
 =?us-ascii?Q?TnM5AUsGKjdxBIIFGVeqeD8uh3GnhJU2RVFaVNzGyBh2MCS94cCsve+NOMEL?=
 =?us-ascii?Q?IU9DqdXfMyuMCm9mv4yLKDjzwDVyhsLp671xTfu7Q/FjjAyg2/OtS2FUd2pX?=
 =?us-ascii?Q?OA3sLj8ssUdYmU4+6X/5vDc2+pcSxNk+I4xKqroHJufqf38sukR2/ym3NHXu?=
 =?us-ascii?Q?8ttk6iV7/2BMgQKaMU982Kw7ET+ngecb5K96ilzGoTCgz/tOgVv3tFo14cWV?=
 =?us-ascii?Q?CNSXHM8PA2i+vMniIsg/Pqfjt8PYnzT0CeQIxW8+VzWgcUSuuvYec8+ggiYk?=
 =?us-ascii?Q?4HBvr+zgDn56N0D8a9/JDDJtLilWd9JaVb4DJsWvZZgWgYxx7ACWAbQ6p3Xh?=
 =?us-ascii?Q?JKVmx9QteHhOcBfTPOtencMfzQdh/Cmf40vej7nGVPimgzH2c6lZIUBFamKp?=
 =?us-ascii?Q?88PECaaTGmcb8J6tbIRUOT77yXgAu6f0xjtPDOcSino+pTi79zA587t+LtuJ?=
 =?us-ascii?Q?uF2w/M2jQAnmHpU1ShPaVNteeTO7fujAhADY1ErBwxjVQetY5g4/EKnMrhF/?=
 =?us-ascii?Q?LIQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e881f63a-cef9-4243-77ea-08d93474a8de
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 05:23:10.2179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x2aDj9cHqpj5fkIqbScMPNQBgZF10T+O8JvctTTAsqrZgxXBqNICZrSpWQETjOWhTh2+3qVtwd0yAWx7z8E+ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3035
X-Proofpoint-GUID: eABGIRwQPbsFBudGMlv_oM8ilsb_Teki
X-Proofpoint-ORIG-GUID: sS9PNEQGuNlnOJqr05dX7IiEDNf6bQbo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_01:2021-06-20,2021-06-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi SeongJae,

> -----Original Message-----
> From: SeongJae Park <sj38.park@gmail.com>
> Sent: Friday, June 18, 2021 10:15 PM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: Javed Hasan <jhasan@marvell.com>; GR-QLogic-Storage-Upstream <GR-
> QLogic-Storage-Upstream@marvell.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com; himanshu.madhani@oracle.com; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; SeongJae Park
> <sjpark@amazon.de>
> Subject: [EXT] [PATCH] scsi: bnx2fc: Remove meaningless
> 'bnx2fc_abts_cleanup()' return value assignment
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: SeongJae Park <sjpark@amazon.de>
>=20
> Commit 122c81c563b0 ("scsi: bnx2fc: Return failure if io_req is already
> in ABTS processing") made 'bnx2fc_eh_abort()' to return 'FAILED'
> when 'io_req' is alrady in ABTS processing, regardless of the return
> value of 'bnx2fc_abts_cleanup()'.  But, it left the assignment of the
> return value of 'bnx2fc_abts_cleanup()' to 'rc', which is meaningless
> now.  This commit removes it.
>=20
> This issue was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.
>=20
> Fixes: 122c81c563b0 ("scsi: bnx2fc: Return failure if io_req is already i=
n ABTS
> processing")
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc=
_io.c
> index ed300a279a38..f2996a9b2f63 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1213,7 +1213,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  		 * cleanup the command and return that I/O was successfully
>  		 * aborted.
>  		 */
> -		rc =3D bnx2fc_abts_cleanup(io_req);
> +		bnx2fc_abts_cleanup(io_req);
>  		/* This only occurs when an task abort was requested while
> ABTS
>  		   is in progress.  Setting the IO_CLEANUP flag will skip the
>  		   RRQ process in the case when the fw generated SCSI_CMD
> cmpl

Acked-by: Saurav Kashyap <skashyap@marvell.com>

Thanks,
~Saurav=20
> --
> 2.17.1


