Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB419C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiDEG30 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiDEG3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:29:19 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4108C4BFC3
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649140043; x=1680676043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zgxqi/oTTCX/hGvi4lva94Q6oFA0VVTQ7nakMZWjM5E=;
  b=JhmNeBJEONYkQEUC5Rqpk8V6b31sYKIiV9RQaGdd78dCdzl34wc9KHmM
   SgAs8Bc9v0gv5sb+hr6yyMQy1SVveDxt55uqJLHpp2/wd6XlY7WO8YVRI
   takX5lttvFvQ9MWjcR4xjKgHpaxUz1mEL1RzoB2N2Jypkyg8HUagddknw
   zKPSWwWg5d9vLsk1RqXPOEIRc1fOaKbCjvUSQZPbOduknWwl+XYZg7hpY
   9li0h55WS1SMnMF3aXa2J/sb6JqrONFWJGLZXslrgB5XiDrpHY9PM17ae
   cvudCq7I996uS3H14zMjapomlYCSK00KHqBs4xOcZA8kbqL/fM31Tz9gM
   A==;
X-IronPort-AV: E=Sophos;i="5.90,235,1643644800"; 
   d="scan'208";a="198008762"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:27:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMenpnVle5DxN9OBvw+08KE+63WZxdiDYmmh1N3hSc6dcnMWsjgEdRKsLryj03mW/lnJLiBgTWkePH51ei29VpW48piW0q+J+VtRyUCSpC9mn6C3jNuAW44Ic8FfVW/MpkZMxIimQA76Bqig/Dok8AMnbwdbTSId2nZ2Iol1iXsUM4+FeG3fOHa5Lu0SEMZmJx6R+quxRDzUZihAzubcP7pTlqm3Mez09YhEAYbj9bNXSE02An9QT2ArtTGR6udnsjNaO0zlAit8n17vVMhCqmcVwDZj8ayWh43gkz2CZ+Jjf0y9f9Ob3Nmv/NsXQptgyotVaYwNXF266PT5z043mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgxqi/oTTCX/hGvi4lva94Q6oFA0VVTQ7nakMZWjM5E=;
 b=masxBxzt4RdW4C92WjVgM14bM6jCz4BQIcnrerRYlRNetEnYLp3xROQrxwwVUfzUAloPp38gPQJuNo8Oq/e3W2nkPnT7a4LBrLu+ZPNUZSGnzLTj8lEo4AHwop6Am1cbmGQrkVjXuFEooTKgFZ7v6X9/Ed7IetP0revaMJXllN+5TKFsXi5axE+xEvHPLTTCRuxtRbr+FHZgE5KetXg+juM96+rZWMFHUz9DC0qar0BzPbY6aAndVy0/OxFMVukAZuKmHIiq39ORSPSsJrX70cmEHt9EWi9PuuGI3+NLJr1PjAEWB04js2teaEZhny/Ysof3WA3yx9emP3azBH1LxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgxqi/oTTCX/hGvi4lva94Q6oFA0VVTQ7nakMZWjM5E=;
 b=WsDOzTtIJpCneClLRn4m2Is6CSz63nu+v//6zLBU5+wK4/rGiNznWihWXRtNl5ndRgDCfwS+kNTcjDsxXYl7vO/PcZzrJBxkrZTOOm7HNkRX7KVCD7ZAS1TM9TvKrl+0fHsNK2nysmNbr6QaIUldFiFYHfkhxyETlp1LtZ+7V5s=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN6PR04MB0741.namprd04.prod.outlook.com (2603:10b6:404:d5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 06:27:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:27:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 24/29] scsi: ufs: Fix kernel-doc syntax in ufshcd.h
Thread-Topic: [PATCH 24/29] scsi: ufs: Fix kernel-doc syntax in ufshcd.h
Thread-Index: AQHYRVAG6zReAMbB2k2oNilyUgtHYqzg4Txg
Date:   Tue, 5 Apr 2022 06:27:19 +0000
Message-ID: <DM6PR04MB65750BAA3A40338493128357FCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-25-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-25-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e513fb67-f59e-41a4-4e68-08da16cd561a
x-ms-traffictypediagnostic: BN6PR04MB0741:EE_
x-microsoft-antispam-prvs: <BN6PR04MB0741B269053A542747A286E1FCE49@BN6PR04MB0741.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VHQHWh4AnSI7Wf7vssXemTTHYOf2vZ0Aqv1Sq6FefEERQ5EJhUmF606YHj+6n4yca0EkFSbAsFhfbYWHFx0DKEUW+vzYReYpCEiV5Bo/WtFC5fetXUv15SqdtYUTK7dR3A7KcCRjUFK81W57hjUU4psJNP8TiFmVkH1ECYWs3LK8CVQDrb/oSaWTvgE5LAHuA841Rel2iK52TrT/H6KKZ6FpzX0f9mrsT2NiM4Zlq9bzZfvEn+bShtncR6a6gBs1B2Wf+ya37YZ9hAAc2v2fxHiD+3Iz4iUxhn/sy8Y0rmBVO5nJ3hn1atNynyzuWTV9+Gwrcx3JCKFiRmrMdaFPWb0N74pebLn6RkB/m6yWzDWrEN1YcWWB0lgrdpY2/cD7+zRGddzUNEuSoYOIV2A+HMi4vvAYSHwous519G5bprOO6SJJE8sbH4dP9xRkO+s+5TCLTsmT5Uho+vyBlMk2q0GAESjzUQ9dV3xHMC/T81RVSiV35jiHdtbbuzavqdJpnsxBMPD1/rac2EPZHrRIBf0DoUUIrJ022WYe+RT1e0/s4cDPbhQzzSFt7U9H/Kj1VubSYZ7NMYCjin0Nfafz5Jn26AQMQuxaO2mezGFP+Er90p0hvc9pBOZVKirQLmqFODQ+qRrSlBFtQYktT6jzG5rQoT2aVpVIfmNecduKXWqiZZwGdTQTnny8RlLE0lIhr1l1f+KGvmVc708TF3qJuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(82960400001)(38100700002)(38070700005)(6506007)(8936002)(55016003)(7696005)(7416002)(52536014)(558084003)(33656002)(110136005)(71200400001)(316002)(86362001)(508600001)(54906003)(4326008)(66946007)(76116006)(66556008)(66476007)(186003)(8676002)(66446008)(64756008)(83380400001)(2906002)(9686003)(5660300002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uFt0Ielp8/JRnRDvUOse+5SZdAR54XDikzM3F0TuvouvXNsbeF8lHmwqojtx?=
 =?us-ascii?Q?l4OGzIXIAJV30vSL/2QbX2jeWQBMp6lBG5cgy8m6Ug51kiRldB4mH98tJOIM?=
 =?us-ascii?Q?GuncWjKBDpRhxgv+8Wtz8pn/Ut0JpQCTLsc4Vox+LjiHD8ZleDLCcYrWySBI?=
 =?us-ascii?Q?mzkp4xuKrVPAevbwNtl/aLRlFQCVs37iNO7fragEb1iW/A7ahtWzwVjHzIfT?=
 =?us-ascii?Q?AyoL7cTKtoqfXftkRR+z2MrgmPHz2FGkpa01h6+K6Df7Ayx28G+aLbCIXuA3?=
 =?us-ascii?Q?Zxz5cKJaYMyyCYTRRoggXbjFfsgvXAOymMRZE33P96wF/Lv6m0R74scPF/SY?=
 =?us-ascii?Q?qXQvxnKKyU2JoHhO0i1tX0m4qYmt/BPFu7HREzJ/NVB5hIT/MVfbnVEOx3i7?=
 =?us-ascii?Q?WsqlBxwKpjTqory9WlVSXHWVbuRS/lKUvL/M1klct9zHFifRM11WPEKLXT9O?=
 =?us-ascii?Q?awn184Ftbqi8odsOY8dumpMlCcWyTo936HSUyeKZJkfG4IuM81p4IeeFNYFw?=
 =?us-ascii?Q?0+z5msYXaRPhUXcRkwuJnYT4niGI37gn1JMc/ynCGo4OflvggRNIqCznbG3a?=
 =?us-ascii?Q?rZLkfM9mghdQiJxJfUHikZsYAzMl0SGTE3jCtxRrT/lzWeGs47/TGPRgHMJe?=
 =?us-ascii?Q?MpnWAvc5oOQ/sQMpvFo6MI8S0/6MAOUc3a+gTRJtlBuuunnNoe0zxOQXBDiF?=
 =?us-ascii?Q?yF0aJD2vWusGK/KwufKNEjz/6w6ajgn4qOJsGV4mEwInJRkTC+lJNeOdW9Hw?=
 =?us-ascii?Q?5GlaGqYsk/S1GPG5MjfNjc/oMNe4QsqiW2tmnNsgdkaEB268v1V3hxhvPRQo?=
 =?us-ascii?Q?SUSIV+RfRiSFClp2CANEVcDsPzWMsYfXbXn0YnNZX9r2bqcDAutJl4YUXexX?=
 =?us-ascii?Q?m2fsjArc3GWo9o2fzBGtBaxzNV1/ZQsv+O5OCIqP2UTQ9tj7dPye9IscHH+B?=
 =?us-ascii?Q?X/bmyuE9B1j8+bJTvNDqeP7Yud/jPVR9H7EMrIbfguf1EZSHwihuAnT41k38?=
 =?us-ascii?Q?YIOTpZhY/VvakQyecGmlAQ5MHWjaSmdoHtXyz+dFb6Ftr4vqR17Os4xQPsat?=
 =?us-ascii?Q?wCie0hd6SD/7/x52rDuFvWyGJ/s6gfNtzhFad5PqOIxQ7adi8bbz14BhU22Q?=
 =?us-ascii?Q?D8Q/BQlOxu1jXs2OAuoLlYy6TybFnPB4sNB3ZrCPyP3zIF3945hjHMqZfTkA?=
 =?us-ascii?Q?dd5s9Rd2NdY5HLa+7TdPHM5i2loMcbaKkjMkhy7ORg3zmlsneO76DlTG6xdc?=
 =?us-ascii?Q?l80Z0RitHW2U3uTK0YGxp8JXAuVWzvwW19FNzlfMj/mmRmXBLfMpOjbGL41p?=
 =?us-ascii?Q?bi3Ocs3/ldI5JbcHkuW/2bHdKdRFiS9xR5ImOWT5ExXRADh87ilPztkXNtLk?=
 =?us-ascii?Q?Mj/Z8cz9WvHvWRjnie+VnCTfC4VbnLT0+o0TfH8AyCwQL8tGlxSU3Njw5MRS?=
 =?us-ascii?Q?+4ebBGNTmOdLI4ddNHCoDKXHffPz+LYymahJAt35Lhu+kIIeFQD2XDEOF2kg?=
 =?us-ascii?Q?wJUSwYxplLVGZCdhWQypqbFQJilKxaQPmHNfhaU6DIYAocJmchPJreqY46yE?=
 =?us-ascii?Q?xaKB7erazwl2+2Z+oSQonpwuJbkwzQQay7882RaI+nj3GJeQSKgZKcJHr0aq?=
 =?us-ascii?Q?54vWHXVifoIW1z+wedqT2cd0CSdf/cMhDzJouWhpMq+owNKYgBpFZbN5fp0c?=
 =?us-ascii?Q?OtYu/Q3eodJhtkjAwUacoipps/am2W3/EE8eboBur/wa0xMfASeGWCm6UuN9?=
 =?us-ascii?Q?5ylczOCDxg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e513fb67-f59e-41a4-4e68-08da16cd561a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:27:19.4392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDPiM0rEmkoTR7hefMkFyFDkenEz8J1Ikrt0sY0EkbGId8qAbVHzGlxaP9SlonioFc5HAPQ9UH+1LEh38ts8IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0741
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> This patch fixes all the warnings and errors reported by the following
> command:
>=20
> scripts/kernel-doc -none drivers/scsi/ufs/ufshcd.h
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
