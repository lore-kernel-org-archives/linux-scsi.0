Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7638CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A6D6145A
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhENL4h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 07:56:37 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19787 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhENL4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 07:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620993319; x=1652529319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BskdVDjvLXeTslc9w3pfTAJQaVOXxcQMT3me9y7gpf4=;
  b=XcLQfimpn8GyiUxUwQjYuvQT4zn9xWLpMKDNp8MKAMT6TfUqbUM7cFGG
   rg6uAfLFWz8arUL48tDblVMPSa88CdHN1KtllaqpUl7KWQYD9BzteWrcg
   uYW++QlkziX6hIni7OoFW7nCd2Ym7FrybtorIWEmr92Bc06LY9+SXEQ5n
   yLh3wTChu54dvgLtd2+lXTqVveJmkdmZV1bmG0d0quhydsbBj0bdg+ZoK
   PG9dbxCI9MtOnuBRyD4r86dPlP/Ws80cbuoa8osVt0OBtQDi86A3R+ycW
   ve+G5au51dXMrYGVO4kec9cyqtLF1VAU0M6kn/0FiGXGk8eRQRnor22qh
   A==;
IronPort-SDR: oyUAlZCm+4Es0iucdm+smwVhxztWokfPXZM1qcceQVg2pB8Lupv8YGTzrL5XEhFx63I/3i/hMK
 6dRLLkFKSBXYcVmYpeGnDwEDpwARQDnj3j7I5cNc9KtjwB7l9yWEKS9mWiNQ+2N80yjmTlzFK4
 d6Z0BPvLKyikchm2hYhQCmYnWCLjAspOfjHDJ0K0MnE8IGAkMUg0Y17W0OPbmlSmYHWqBEDOGY
 /lVL4E2byBpgcQx6R2jqfi3Wo5xb7sKuOwATZrnisFjy2ddH9xyTIW7eHp/SvektkZguOxK9Ps
 Joo=
X-IronPort-AV: E=Sophos;i="5.82,299,1613404800"; 
   d="scan'208";a="168198891"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 19:55:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHRjkA1rogz//xBA3wRuBafwMl01t2Bkxb5M5lEE9sJRMCcYwkalt5OP/bjsuK+olsRKnbLpKeJxZ4VBz0IRU5JOVy7RZJj6TWphzNTtnV3SRImFMiEtwOLXXZZXQFkdNfbHzt1sulLvwbRwXWXWjU7oZ2QeQxqhs1701tqCV9RMpPT34bMkZJZaV3fkU/EN0cxb8AbHqmFTXqfAytUdEM+iZtzCeH2jWeHp99t9iQ1yP9O7zGhiYayyVReB4x2DPSU0A9hQASbgQGu3u3CatNbbMNH1p7V4l+khVmS0DFkFawn/UoXIgPJrPGgaqIoBz/s1sfAMfeiOvcKgbmgUWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BskdVDjvLXeTslc9w3pfTAJQaVOXxcQMT3me9y7gpf4=;
 b=Aq89K7pHEFmT40H/n30MH2zNK41GcBuIILnMyJj8bUWfrwqKktBlsa82BDnr2JdX5ZEG4tuO0lXsF4ti9Izj7Mm/jlIe19In/oGCpnI4fYHQoxsFy8DwXgmKXm4GmOzT3yAOiavPVrGCPgHmMREM7FOL8cDRv3jPKREJBIHE61+hfvQr/BoVeWD6+ao7r/KQ35HaFK944ZUxuKek6EYRDyhAm6byMXO10BLi7Y0wQrA12EaDMJ3x1vxPJKBW67rI/Hxd/T/vsd5+AQEguNiHEpDFFTx01lUx0eH7INls++0LGeNu95xtDUkJrA7cTDiVEAykNlpkmPJ7nseQnSFFQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BskdVDjvLXeTslc9w3pfTAJQaVOXxcQMT3me9y7gpf4=;
 b=dashYTL6h5ESyRx6z+BFPM+b4c7NecQqI6TWIfVNV6dWg0VwJe53ZxkW0s8dxYPjn5nJEuSzWc3VN6IvYPc9gmvKdBKo/zmPyh2+0gpMlfvgabvSMkUG2lS/7YEtXv4UXA305tFkSKuzD2cjJTZouze1M63imm+p89YRopFR4zI=
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com (2603:10b6:a03:291::7)
 by BY5PR04MB6993.namprd04.prod.outlook.com (2603:10b6:a03:226::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 11:55:20 +0000
Received: from SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd]) by SJ0PR04MB7184.namprd04.prod.outlook.com
 ([fe80::304c:d92b:8501:93cd%5]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 11:55:19 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible
 code
Thread-Topic: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible
 code
Thread-Index: AQHXR7NmegEaAD9crUuzdjwbzEsc+KrhjAAAgAAHv4CAABoCAIABMtwA
Date:   Fri, 14 May 2021 11:55:19 +0000
Message-ID: <20210514115518.ekvegnbsymczezzp@shindev.dhcp.fujisawa.hgst.com>
References: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
 <d25b35e2-5ed6-4a00-56f4-71f31463ba1a@oracle.com>
 <58bd8a10-a3a1-3d87-0342-f6d49f5fe808@acm.org>
 <8b78d77c-2d27-8a5b-7b98-95302fbe9ebc@oracle.com>
In-Reply-To: <8b78d77c-2d27-8a5b-7b98-95302fbe9ebc@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01789f08-c0e1-4828-adbd-08d916cf25db
x-ms-traffictypediagnostic: BY5PR04MB6993:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB6993785258F2CC7F6F2DFE26ED509@BY5PR04MB6993.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y57mtqeug0MbQRquiSzDdFnXaY4XWvscKAjkN/q1sbbUoxHfvkF7Qr+Gjc2ikQoVRcg0vnL7Y8bGPluWcNcRqwfWibRsN9vZjiY1oPPiyNS8JHPL/pGpgyV20AZs/CQJTOTiKoNYbRS/p3e0fpcHEp7uyaKU9gailzRty5+1Cqf5RlqsBBibbf7VPzx09bA2h6h2eIxplJlTxvolhrFxDg85263ctFdudVWAfFyAJsI+86Sz/CsF9/1q2tZpn/JYtJwqveJ2Q3EXVq4qjsBItVU5PpGSoYWYlmGn0SrC+XkW7WTqLdZyURpzEDLmv7qXSqGs+8+514QZHoXrF+JHhhZTlMyJUBD5lHI+9qyd9HShEZU+GPsjx6PLtkRS5jsoDE8ctd9WpJnUT/vbdyeYVrAd3diJJRTZpTRk0eWOrDtY6qHTJMpzPOf7b8xL+hOLMXGDbgT6MIZ92w6+nbSgdNlWn3WDzJeyaan3dNeDWnbLxhfSRo8FAe25IJ3wEx/k4drw4uDsRsAiLwC9YkFwT3s3KdAL/7cX8m3B3pYkczzkgDFmVNotTxCVDQpyDYB08u9gcEfXP9gIHVQTJPS07wJ1x7pRpZbHZROWUMMF2aM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7184.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39850400004)(376002)(366004)(122000001)(91956017)(83380400001)(53546011)(6506007)(4326008)(1076003)(38100700002)(76116006)(54906003)(26005)(44832011)(6916009)(4744005)(66446008)(478600001)(66556008)(64756008)(66946007)(2906002)(66476007)(186003)(316002)(71200400001)(6512007)(9686003)(3716004)(8676002)(86362001)(6486002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mZWEPC9PJxqb3PL/6DuxOs5v3sXnTP+D4sKegrprnUuTHT5a+lSS0juU3iq1?=
 =?us-ascii?Q?Ke/jWXCRGBlrIMrP/KDiW7jh2qVbSrm27cCZNJ1NPMv0dV/cPCmkm3qJOz62?=
 =?us-ascii?Q?cBcu3To99vjoL/ZWv1XFyzM8QTt5EIG1ZwaEUy8AwLe+4lrWUlnKm6WaJQZa?=
 =?us-ascii?Q?Dmgm7vavF8st/TOl0JZscetvkhSCC1WGHUxKrQ3JxrqgvO4ERYupBaTEo+al?=
 =?us-ascii?Q?70Cs2kyf/ZMd2brszN6G0AOY1VZ0Ai9eYcpVsEp1g552nMhQIVajnQWLrFY/?=
 =?us-ascii?Q?mKNK8m3is8qig5MnW4/Ja1R+vghzlSddPhdRCZhW4/0Q+wxZ3BfcAsbJzx6n?=
 =?us-ascii?Q?rPv4vGi3QVI9wYoaILR7yXD0lBoupvRBK3DfY0sc8bPwf68DyabfVD3azal1?=
 =?us-ascii?Q?eOplZGk6oy3ScaH7siHuXyBKquxUQBE5czDhMmlFmH+Rv3stJhaoWKhsHK0I?=
 =?us-ascii?Q?A1jcHAXmE83+0LnI2w4M6YaKvgQD2gXR7mDqhMahAEPdvG9A0ARS9210R8NM?=
 =?us-ascii?Q?LHUqsWaomPIcasx3NYYBCsjI1WnnaG9F0/t9H5P+bCobkaDacykEtVe4RleB?=
 =?us-ascii?Q?j1DjE0dR1lo+kzjcrPzMYGywPhiPATXxUHfpoMODhTtjSIFvKT81oKRc87vb?=
 =?us-ascii?Q?/nrG4X8LW7CfnkBtJ+0PlSq3cwa2BAxmpvuhJj4Z0RWp9hziyRgMR+3InuEK?=
 =?us-ascii?Q?2YRB5kSj7hJuVT2/vwXJ6HNgV0YRgBKqDK1bfy2gaje4FuiWW/yrqncVZLug?=
 =?us-ascii?Q?e6XfKoR7NVVdQmm3SySDTJFvFWf2u55TCskCWOB5mCb7DZPQtSoZE1aKZKG0?=
 =?us-ascii?Q?E4kCcsWYsqJrkMzILZJGRbgChJx4qk2thXmPxkYpG4BPeTxdprUd3iUOVcMQ?=
 =?us-ascii?Q?fTy1EsDlQd6gL+xk9RmnRFHO0CyrDcZK/HWverW9jLjdlFXCbbukVjYqUrVS?=
 =?us-ascii?Q?lKunXgaKMr0oA/K2rOZZx6vPXadY7iV3xtiX2fScexdMMjyPQof3CTnOpFTV?=
 =?us-ascii?Q?8cPnAWbjMGrHIk/IVWUIuoiJJxGvHP5k3F98pzoFms1VesloawejBrkhxRv2?=
 =?us-ascii?Q?cEc0z6gpFzy+5hU8YSaI798ST9GfH1E2CEvfOnumcX2aN0U6P702lMeCn8L1?=
 =?us-ascii?Q?xV53i5QP8bqS/gRXLpsupF6GUFnolsntiKFdPf4j42V9eJtMD1mYakFxPkEn?=
 =?us-ascii?Q?9fGAppfJEusc8SdBGG5gnFL73NOnJQDkBjVG8cll42eG2cfPtCPEQmdea0DM?=
 =?us-ascii?Q?C4HU8IOK5YSjobk8ntqb/+EENX0n21KepXCoZiGVhzcpKRLTJJjZfRnp6yWG?=
 =?us-ascii?Q?LT+ExL5MVxQoHNVNYTu6IteU3JkZXo+0m3l+6yPMEdcFHQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF3F0A8B6A83A9499FC89538F13DA196@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7184.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01789f08-c0e1-4828-adbd-08d916cf25db
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 11:55:19.6381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tooLKnO6bMPbTB9Tv9eDftg3hbLquigon8Jjhdb94YArUidnY8YQvNa+uvnL+ujzmkNJfHXyzC67Xcval/SPREwpfrXzxwhMgAHQmZGd3fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6993
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 13, 2021 / 12:37, Mike Christie wrote:
> On 5/13/21 11:03 AM, Bart Van Assche wrote:
> > On 5/13/21 8:36 AM, Mike Christie wrote:
> >> Is there something else that's used normally? raw_smp_processor_id?
> >=20
> > +1 for raw_smp_processor_id() since my understanding is that
> > SCF_USE_CPUID is a performance optimization only and correctness of the
> > target code is not affected if the running thread is moved to another
> > CPU core by the scheduler.
> >=20
>=20
> Ok.
>=20
> Shin'ichiro if we all are in agreement then I made the same mistake in
> iblock_plug_device. I can send a patch for that, or if you want to get
> your patch commit count up, feel free to when you resend this patch.

Thank you for the discussion. I also agree to use raw_smp_processor_id()
instead of get_cpu()/put_cpu(). Will post v2.

Regarding iblock_plug_device, may I ask Mike to send a patch? I'm a bit
caught up in other tasks.

--=20
Best Regards,
Shin'ichiro Kawasaki=
