Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BA8EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 19:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjGQTuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjGQTub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 15:50:31 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BF4E1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 12:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689623430; x=1721159430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2hm+BrA9/PHJpilVFC0YxilDpxTElkvkBGCtG18doZM=;
  b=JVS8xt5upVruN9ED0l19nRHSEQ3/EeC/GZ24QtTwEM/laR5m/PRPZlRQ
   BSlkHowHfY7ux3Y2rjGdavi1eKk619asTgXcGV97Hid050l3Q3MZxb0eh
   zmbmWnfFpgjFbdI7IPP2k3mNeEtPOjC0/PiX5Km7wP7D4HdxXyx39FxJ4
   +PX7xMcwyQhY1XhU6xkB/oL/EgtEyvBYS9LcDRMbjNoFrwa68x3H4+Y4l
   u27wxiJPQyuc3PgdYgvxTmsTR1tMVti7AAuQxl4ao+3x4q2khi/hx+kN6
   un4AfX4PoNTunT0ylSS+WcsXGsdkxKQqQv+4jyy2+7buqCbbYv16XcrZ2
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,211,1684771200"; 
   d="scan'208";a="238680065"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 03:50:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqrwdDyQmcQHs7nZ7nx+4hjphlYe8FLOUJ4Z3diml5zSmcnW8/ZMJp9Wx/Mj7XTesZtJGmh38AoS8h1dQJpRqRT1l+90K9h8vo7+debRRVzgGVUxY5DNlM948Rjf8S51zQuyRkq19r+g335Ce+U+Kt5OulqOJfj64yJazB/bytjbffzJl/wFal+JspkyqIa3/TbDZtgKgAPowuoOfCkZN1w+qsDiH0AcvEvaxeIOCIFgabagwqpPw/annoqV2Mnj3gd6vZzSmfOP2Ldxc/B6/Oc47ORFikbtOGUGowc1sHvYvT10AzWNRTq20RdPNe4tklT1K/PtI1rDozMz2XcN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hm+BrA9/PHJpilVFC0YxilDpxTElkvkBGCtG18doZM=;
 b=Kp+S2eV9YjyiLypDePJAJTSRh1P5PqvJZjGiNKy3Wp6zox1NpSmCfNwxHnotrCAvmhcXPcSW/iFrt++/CePMYUY/ktW8YGenFPzeHd+algnJ2xGhm+gymgv/glO5gQU9/jproyakUkgf8m6LyI9xHBel4avvlWgqA7OWMlv6B62hnvEajJ5fiU/+pyfrBo3pyWKtUJJ6LColGJCtphLN5dEMN+yqbQya7D/0RUUa8wtaD6KlRHeQ/NuQnCtAtJuZ3gNB+i5uahhQAW9pO+wnGbFdS9KoU6mgtHn8i4oB3n+7mXHR0Pf8sKX6ONGsqJ5MrfBYpQK2rRO4ce8RrAIJMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hm+BrA9/PHJpilVFC0YxilDpxTElkvkBGCtG18doZM=;
 b=UUPOjhCZyxMDORRTIXigP/ocu6ucatXeBLndWog7esqr5m1tdpSrSwwifT6MalD09muvM5opHSfO0blcwm/wghIc5gdSVXOqrG/06neI7X9pzW0rbRhmo/N9RUYriox6EIzzmUpAU+JpFr5LRdGpFur3vuL6cy1brktUv24EoP8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ2PR04MB8460.namprd04.prod.outlook.com (2603:10b6:a03:4f3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.30; Mon, 17 Jul 2023 19:50:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 19:50:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
Subject: RE: [PATCH] scsi: ufs: Remove HPB support
Thread-Topic: [PATCH] scsi: ufs: Remove HPB support
Thread-Index: AQHZuOZQsuQ/66ZWxUSKUB3LYvhnqK++XdNg
Date:   Mon, 17 Jul 2023 19:50:22 +0000
Message-ID: <DM6PR04MB65754948477EB5DB6D935A10FC3BA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230717193827.2001174-1-bvanassche@acm.org>
In-Reply-To: <20230717193827.2001174-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ2PR04MB8460:EE_
x-ms-office365-filtering-correlation-id: dbc4fa44-d2bc-4cf5-30db-08db86ff0ef5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d8mO90UwREO46LJIynHl1FA/Q5gqnqxMcBPopJ3+2KCu1LCP9RigBxHbVKrbyQbfh+L52aB3vL4LMv3s7s3AkHcIJaedI2p6Cv+VGOiBe2slsPo36yKqPp4GWuSgm8fxM9tnP3cfbHLiina8yA4aLgkUMTsNwfg46AHDgupK1F4U6huTg62KGMAv1sbYMetI+6NhWd9kaVzguITOZnUwNEkeNnQQGTNAHolUJxObyRunlCHv7jsEGY5LSx9xPjTiWEAcQfbbHYdWV+HtVYEmzu9U/g4G2fphHonlD3TN6k7/LgiPXDHqJ9GY/YJIqTcq0WcKj/Lu/gFfy/3yN6J+HVSo7L+/s2fWlg8PR0//1Qn/VvNAPCK2KBJDZNUexdidZrPqr8ToS9wqqRomW9tOuIy7MGWNuv70tTrnYBzERGM65HW1zSL+glsxSsC/kmMUe2cqssoVVaTnKXWTQyUpHe5Mdp7rD4V4siNGjpcb59dEzqSee42FN+kh4bMlQKNYvKpa/J0T033h9Pitgeed/1KmhRyFdM9DcQkWga26r1qZaiSvzdfXmwNNp6jqOObfde1tOijsQ8vQhsXyURM1vIrKfshZlqyidmCBy4AC/Mgo1JmtyM5ZAhuL20lWsXip
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199021)(38100700002)(76116006)(478600001)(71200400001)(7696005)(110136005)(8676002)(33656002)(558084003)(55016003)(86362001)(66946007)(122000001)(41300700001)(26005)(186003)(66446008)(9686003)(6506007)(38070700005)(54906003)(2906002)(52536014)(66476007)(8936002)(7416002)(5660300002)(316002)(82960400001)(64756008)(4326008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eI8dNF5cvMQPeuqXssthx6QMfQYYsQZduFYNzM5d/J8axaQjR0lMl0C6ZiuT?=
 =?us-ascii?Q?2WtAgbOAG33qV1qRK0/ABrosYgrGfWh2sPvlLk08P0MIAME3Ppyb47JTA+s/?=
 =?us-ascii?Q?/SKP/HojFvmsvhhGU2zqIAPQ8TvQ727Whb2H6ZuL0yYYwPJOlG23K/pwI2np?=
 =?us-ascii?Q?xcw/XM45V5mNNVvghdOitooGzf31S5/JHVmzQajG5RLn7IrXjxWRQQOZfCKb?=
 =?us-ascii?Q?XFfSIRR9Aef1mmdv2CJibH1f6Y/BnQyknG5+JmC8RgXOHtUHBTU51tv7xbos?=
 =?us-ascii?Q?RBXdBL+ExU+3OP+GPWMP+bsUcanK3Ku/I/R/Q2S5j9ugFiEExuFUQiXMTbYW?=
 =?us-ascii?Q?qyhpP8nexxFYeTDtQNTfjb38kL3LVj6q/hAkVGpRGWtf/lE5LTOjOJK5BbC/?=
 =?us-ascii?Q?1G5z3Behe/9M5iidFqWmI2S8VXmYZ5YlS3dyfW30+pvl+yPwpOT0tZTrLmb0?=
 =?us-ascii?Q?kiyM5NsxjlS4IhQK8vQJcwDvvCvrqRTz3TxMf6iLDEQizh7WNeich2T/rXAM?=
 =?us-ascii?Q?aRIfL4uxu/HFQGh8pHyr32ueoCEdegqUFqF5bLY47HxNLdkZPpzT68zdugkH?=
 =?us-ascii?Q?kytsGUk8ENPJQvIWvuulj6EOgBHW48PZGpy/D70YhW/AGhIXF259aaeV6GNZ?=
 =?us-ascii?Q?Qk+mVItIEIa3rZBGg+jzI44PpEOo4hFqruI4WiRxcuY/yQbSB0QJ3P+HMYR8?=
 =?us-ascii?Q?gBpTRlwT4mSiWzaGUcR2+HwfSVTCl51hKkoWfOH2Hmn5iXFdWUuwry6SVrNP?=
 =?us-ascii?Q?LHYu1aYo6ksDFksVW6cMRN4BL+kB/4CupszEzdsRZGJGc9CPPC7hSu0msOep?=
 =?us-ascii?Q?uBJNvw5mtWcz6M1L9E6sG317woiHcHrx06gkKapeq+RoJZOK7x384PE5g1WA?=
 =?us-ascii?Q?hpIS7MtEcCzSfUpuOri85lZTLy6Jc0TMWIWWiXRz9dNvS3r3/sO7Er5SGYLO?=
 =?us-ascii?Q?5KM3mFdDSbCsgbwRvlbzlt3jUBv13/JJX7aOe0Fd8RiDCOjeEjoc6+sF937B?=
 =?us-ascii?Q?iVwqNRgGzkOtS9oY9hAPA56Znlu66WtVdcEnKWE0rYOAG/OkVR4Hl/F5H8PX?=
 =?us-ascii?Q?EuvArjXltqpVBTs9NnkFRcfO8nNcibvse7yjG+9Yj67nsVUKkDn6djWgsHCV?=
 =?us-ascii?Q?EWkWH0sBB8Q+00osQVr+mJ7koVIi4A1Kiz67Q1YrEFvZhK7aIIJBeibc/lno?=
 =?us-ascii?Q?N+F9g2SQ/stLoE3LFXGLyyosuDHYwremjOy/kU+wg7wjJ1WU75F5JJvrtpJT?=
 =?us-ascii?Q?E7+ienHbIwjizvX+/XTcBVhbD6oaOye0Imn7euEhHXUMDUwRTmXlzqeRAxaZ?=
 =?us-ascii?Q?buyXQO6Ws+4jwmZDFg3GLkOYSnoTseGufoE+Q3zEw/RT/mnESiDJs3PK+zjx?=
 =?us-ascii?Q?j4yo9k7oX6khkmkwMvZWo1humKLCIkwg31aopZqaxL+1W+BIpSLWR65zLehw?=
 =?us-ascii?Q?cxans9ELKiiyu0M/CQqURG2eEpDnRIZjf8QwV0ldBsqMapZc1Q/9ucegFUQW?=
 =?us-ascii?Q?x6K9dh0LSeogRLwBbwxXCsJFfIMqrnakUxJrzRY/RzkIYtoJqlSbsHw/pM0P?=
 =?us-ascii?Q?lwi+TAzDVhIj4KILAn8aKr19Mywm8lbZ/sVRUEiE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?no7wthbph7he7/7B8PZiwU9G7fTxgRU34YX/CCm+K0z3+7E7a5QxY/9fd/f8?=
 =?us-ascii?Q?7XEC+wG5lRhDj0OQVxqS8PrOpCu8Wk+oPVdw3Uh8FLCNsdAfBvJ+qbo52oS8?=
 =?us-ascii?Q?/W6c4TGjlJ9hobTByBjncAPskKTFCzRmD4Cmvy8+uaxVeFO1TYjDJYyFcspJ?=
 =?us-ascii?Q?ao1TKTWrnFVw+cyg+YwS+WaP4o5CAwGq2CIVxA5XA0xEKKmjmQT1h3+UmCqF?=
 =?us-ascii?Q?FwD/oWjgiG6VP7dXJ2CUtOPBdna5ZK6xwTXCbyOtzbUARWX9vy72/s2514Uo?=
 =?us-ascii?Q?KV/phS40XHW2oMOa9bgc8Uzcm6XaFeB+mHywRNs9UsjjKsVn4NrQCzXCfuYM?=
 =?us-ascii?Q?zr1BO28ZA7DBw/a0f9nuhNbzw3rX5uFy/Xd1gayE62dbeR5A8P94uB8bHK45?=
 =?us-ascii?Q?wqlvHuXO6X78CYhwqCBppv0Trh2BTdqJk8HZpv4nNiFJ7j6x3y9UWd12Z0HF?=
 =?us-ascii?Q?IfkCyXjchz5SaErKHbVnwx6Cejd551+iNBuWMQx6M4wNeuW4RO3Nkr1TLm0G?=
 =?us-ascii?Q?UJLpNwhzPAOP6YFdDPkmXONKkrfg8jQ5jjTIen8ZD0T3m+Asm9w6hzbyAx45?=
 =?us-ascii?Q?6wikJzlx+/qtOPLHJeJ80HGyqUoBZvWeIwO3EcMIeJXB5zz1XfVRWunTUjwr?=
 =?us-ascii?Q?+Xus6E13iHtFp1K5jO8vE4BweA7AI3lnhUT+3HJUp+ONeri4Ul/lUt8EG4nd?=
 =?us-ascii?Q?oBiaG4CvP2UvJZFg0pHiuWSxOHGl6hKGHroVEeMwSFqlyeUX83Ac5TIX+4HK?=
 =?us-ascii?Q?3RUOnDteOqX3WKhSPF3DO+iaR2Pxyoc+u87JHWACjwXWlugFZ5lxb+fXUvYc?=
 =?us-ascii?Q?Qie96Nvj85VgawoRk0Ncm/hv+2v32gjTkA0cdR90/T7TLm/fxiZsapKt+lPN?=
 =?us-ascii?Q?NX5fkQiWJgZIcy6ndrrQ4e1UHV3AcCsusa1iVYVP106ZepFz3bc+oOmgk1T2?=
 =?us-ascii?Q?njFKSW8/xO34javXjwgPzumXpTazRNi/dnoXKa1cAVQy5jabonTNe06502fM?=
 =?us-ascii?Q?szs+VCkKGNc3Z2MLwJLTlT5aD6KVbElZ2GSD1RpBCLM8f2RLnmYknOEBGClU?=
 =?us-ascii?Q?FczTTAZGGNsXO3eynqyZR7fZqgLHeR6vbuwNw8dn9HjSO+weqFaswypBCU+3?=
 =?us-ascii?Q?WDD46xZXgLbzCWB/3OHus94+zd7bNo/Y7ta+VJ6rtFEze6a9fVO7UOSSAg5k?=
 =?us-ascii?Q?lm/g/hUVZsT+Ce2d?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc4fa44-d2bc-4cf5-30db-08db86ff0ef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 19:50:22.8763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o+Vm/uu0qaFVDHxeEN7cZn084QUBW92BcSsk+k7obstR5IB9Xve5BbR5JmXXO5Cetv2DRLzPaVLh/UVyrMVMjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8460
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Interest among UFS users in HPB has reduced significantly. Hence remove
> HPB support from the kernel.
>=20
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: ChanWoo Lee <cw9316.lee@samsung.com>
> Cc: Daejun Park <daejun7.park@samsung.com>
> Cc: Keoseong Park <keosung.park@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <avri.altman@wdc.com>
