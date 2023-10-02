Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC6AE7490C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 18:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbjJBSow (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 14:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjJBSov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 14:44:51 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412EAB
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 11:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696272288; x=1727808288;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gc7xjoFgU6uU+afVMBssMz9c268iaDXC5saZVwhxDkU=;
  b=Kzo8WAtGcq4VcZLYGGtpRDPN/B2MbMSaGSSDzMxf5Syy+NinWVcfAPB1
   99w4gVH7MAQu+Yd65wpz6e1L+Y7OCRpwU3xNO7BBsYK6viCxX2HE4kuoK
   UDVtd9TwofMsBMcUVZ5UKlJqaMMwN1fCezidr1CCmTKm2lVXvpV07sQQg
   xNGwKGKUsUnIAqHG8WX1kAASFb/sjwk120Fv1rAb6ld9umpjN+QOxOXMk
   jtwfg3t/zPqBQf1/Zs9zRxybX+7fOvAUL4BjTi5w91YxULTllh7pKCVrv
   bdKRoblUnB7nTmM+n0pSrcoJT7AHlu0wQ0BamI53p+P35vA1kYY6PqD8X
   A==;
X-CSE-ConnectionGUID: S1Hlnj9uRNuUvbMgNjuKJg==
X-CSE-MsgGUID: g8STOcnxRYOs04zmgMsRjg==
X-IronPort-AV: E=Sophos;i="6.03,194,1694707200"; 
   d="scan'208";a="357586285"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2023 02:44:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+O3aasAYJhKCj4kB1xhVF6gkKOHl0p4kz6JKeZnn/Nzi5YxEGrAcah9JOUevkwE2+2/vB56/h0eIv9ubpku9z0vcER5V378yh+uf8jAK7NxlMQMgxWuQhwSyflqPnOePGJCrnvUKySEMmBJCv9/BXNkNI5YRWS5Z3sa57RAYzeGeqOzziD61ZhkjxXOFySxorrOMmPBMsVVpf3ky7DJxy7lpwEOPZ3my8GadfmTikzu9QvboKP5AUfH8jB1MLvRBt6JT54EFGgoJbmtFQ5oE59DfsqVsaKYIBawpUYk6n8iFe/RnACTtfLtEog2Z+i26fZ40VddV6Kf3Ggp5nptNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7um/wJI5xRa4+wzlnm+29+15Yf1oX4cedz0lia4fYLU=;
 b=Cyo4KF/wF3rO4db5jablR1jboeCZd4YirA22O6QwRWTZQS9OUWXU3QHvVeGPRs1vfRcDLWjVZVLVEl/5gbxL2SiAzZgb9zFOz3TZ2rF6Wmv8PriyuwMY2JWTYOuap7/sSBaSIi1oDfpF2fVFMjCQ5n0IYPP3v481jn836XM21XCJZ1K1ywl2Kkn2Jmw3jTPbIJa4mxm8LQ2JwwAN9FVcrD8knzXsy5bXc2y03n2slIho9svi0wwAtco17IByLUzYDNhElw3MayCm/nM2jiwut5aLS7nlnoVG3LpEK0G2QUHJD+9XV7M9FetGk15OxKd5FwcR1fW3yuI81fe9SFRc5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7um/wJI5xRa4+wzlnm+29+15Yf1oX4cedz0lia4fYLU=;
 b=viGtPQYf9t3X0vWtVKypbb5wsBC4truFSRpRbXCb+6Q7kom0M8ZCbBIgEvY5zmq5Y5X8gSyccCL60R+ACT8cY2KbXcu/51m7sCTLRlMxteyAgwIbKI0PErfuNPybbUCiCt3o24it8Wouvsk8qG0xlFK1l8z5hVq01/UQxep3pTk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB6537.namprd04.prod.outlook.com (2603:10b6:610:6a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.20; Mon, 2 Oct 2023 18:44:45 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe%3]) with mapi id 15.20.6838.016; Mon, 2 Oct 2023
 18:44:45 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
        "qilin.tan@mediatek.com" <qilin.tan@mediatek.com>,
        "lin.gui@mediatek.com" <lin.gui@mediatek.com>,
        "tun-yu.yu@mediatek.com" <tun-yu.yu@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "naomi.chu@mediatek.com" <naomi.chu@mediatek.com>
Subject: RE: [PATCH v1] ufs: core: correct clear tm error log
Thread-Topic: [PATCH v1] ufs: core: correct clear tm error log
Thread-Index: AQHZ9S/Y3heZ3ZMPy06KQOtp4mUk4LA21oFQ
Date:   Mon, 2 Oct 2023 18:44:45 +0000
Message-ID: <DM6PR04MB65752685E56C8C86F44D5381FCC5A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20231002125551.15111-1-peter.wang@mediatek.com>
In-Reply-To: <20231002125551.15111-1-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB6537:EE_
x-ms-office365-filtering-correlation-id: 70b9cda7-314a-46c2-3395-08dbc377a5f2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ntuDNkzVI3tkRPSLpf22qtHL8dSsGOW7bNM4CdOlUmxVFzHiB4Bub/bTkG070qVLXXTKTNe2Cbey1sEf7n2vHJ7tnTb2y97014sPbnFfWVfrPUDGMAV7GaiFzCiKOt2tiXZUM6NO14lZ/f3N1oXosDLvV7zc5qDqcNXfo1k2y7yf057bWL2tO88MGu1ezBYDCxf3lDobo094rmkJG+4qh92pSndCVHatdio4GblFEpUqDxlsVwJufLGarKvlrZ3Q7YjNx6gMtsoeg9Gv0AHYxRAeGLcDalIBGLPWtvPWtoXZx5dCBf5vLMJPuPaylAjcV52OcSQxLq53yOhsy3lEct6He9BTBA8nkK5Me8s391R9GOEqpjUtJUM8BwW961b5pidoPoQ08xKX8LSxwv+sIQh+AlZ8E3Xv+NBqYu32kiZwhp1d7g7azNJxatQj5f27SLPq4yTBj9XgBYQluPJqsTYtFVd5rkAow69yBizQuispOJb397C7zxhFoeoFR6OYb/7QsetGLZwnoiOK5KuNbwiTS7Tz7ay1Iddr0AaGzFRb2UZtWQ8cMBwgha4UGMt6RYExxAvG1BiHXjMSKutot5hr4bgE8/JyNRhhlKe5jjhisUmv8mqvjCj311Q7N1Eg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(396003)(346002)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(8936002)(26005)(7696005)(9686003)(6506007)(83380400001)(5660300002)(52536014)(7416002)(2906002)(4744005)(8676002)(316002)(478600001)(71200400001)(54906003)(64756008)(66446008)(66476007)(66556008)(41300700001)(76116006)(110136005)(38070700005)(66946007)(38100700002)(86362001)(4326008)(122000001)(33656002)(82960400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7pgu4HADoMlSMUyvTUs9gFMH6ro9clQjDq8YY64lqIH14PhgmHmRn7NpPv4E?=
 =?us-ascii?Q?3dd64X9TcNZGSm8beNKL2Ou0bvEgMIQSpu+VMzC8Mtu90wwPyPijc2ReY316?=
 =?us-ascii?Q?S/F80WrgoVWL1UbYWfQZ3pQxkhF4NIKDUinscFQBv/Ilz2t05Nu3QezEx8fK?=
 =?us-ascii?Q?8JH0CU9HrV+bi7+gnl9DnJZrBwhWdqNXWb1vTiXo1voaj8K9BBjSJRcZ0poZ?=
 =?us-ascii?Q?S1FwVh4zjlDDX6oj7NcSQwvMy44qjBEZ+BDQ9ZSMjjaoBHVXCBdIC7QuheDs?=
 =?us-ascii?Q?oNN4O/YUgg1myhg7yrZfizkgT84zgVrGS3dDh8ME7Qd/KWs52s4ijtNN12RB?=
 =?us-ascii?Q?qiaX0goWItt6cEhGpVyhGoppGkKustRHAkeDA4P6XjN9/m6z+GarI3yLn3G0?=
 =?us-ascii?Q?4m83KdaCQLadJNtdFNfTz5ydMMB9S3Cgh4GTwIP8Vw9tEvqkwtavcK4i+3UU?=
 =?us-ascii?Q?MIFIuOSpgGSmEfw+6q5NUSiV/h0eldTa38MdF7yTSGKv59QcJ1aPXhhqd/Nt?=
 =?us-ascii?Q?B0X5QaDQjncLHamiEQytbtt8xsMWNXI4sdvddM/E6KAtXEJZHPSHEGkuIFLo?=
 =?us-ascii?Q?/FLKcrA4PBKKv3IdHuR4HgxY1ISB/g3KCzzU9GxtvFtWLyavQjFBAHA5akKT?=
 =?us-ascii?Q?m4AJUFzLZ2pdKMnIG1UbQKIe60Ou/Ie2Fnut5QjPvRLNkEStVCSnLzRQ7Ret?=
 =?us-ascii?Q?N4FYEqC1ysn10UqgkpFUMNMPfSMkLiVEFe72LjzGpJpBNaM/xe4Q9LQptLfd?=
 =?us-ascii?Q?DjZtr/BJyxzmAFhsbTwFpgwRrxtIJy1/DwB+8SxGq66nFrCvCLCyt+DT86LS?=
 =?us-ascii?Q?ak5wG5x6xupFhe5ezubudpNWYJCq6bWAK1aFjvzv3oyX5udxaQ4IB8wJVGzT?=
 =?us-ascii?Q?zOKSUuJCOoTNGC+Bm1zrnQeh92GwfOl6cJ2ai+eZgXGgVlDtmqE2eRh/qA0K?=
 =?us-ascii?Q?Iy59e8ebhWRNKdyGF+vjlpbAFsGT7Gql/bwY2xjENgqt2OKSeSI+hQ+E45HU?=
 =?us-ascii?Q?IeRRNZtssYb6u1J9Y09FRFJeZ+iJi4YwLcnMDI6IfqYSYAVheK8Zw5mmF44/?=
 =?us-ascii?Q?Q344olXvNgj/Qc8QHG+ntgCEG7WS16vdYSIC4442aSVZv53kHtmllvZEOD1f?=
 =?us-ascii?Q?mD5uPZggwvWwdM0/t33aKIfp4j+XsrRPRA4Ts78SeGufH7asaOxvUldBtZZR?=
 =?us-ascii?Q?NwF+QemJttx22b7/D6lGB7dKkJxzbBipFNmHHf/YVf8YbMlYX2u5oNzB+vAz?=
 =?us-ascii?Q?szvaM1xTqT5nEAA46qCjTErAC30OsKajiVQuiPEJrSeJ5k5TDJTzURP9jmt8?=
 =?us-ascii?Q?7cPQU370y9YkYxV3eS/ciZo5ziM5d+n07q+Pp3aI++tHqWtXAlccnmpbFttS?=
 =?us-ascii?Q?eo02WH1m1oDN37+r4GWk9jZQvopPQA5A2bpef+UA2qWJB6A8UT65sOgVI/7o?=
 =?us-ascii?Q?bsIvgoKW8svgl1tHTadWA79lPEp+LexrGlaChLcYZxOTS5CYeaqeUoiwu0z4?=
 =?us-ascii?Q?mU0Z+pkfXEZWgxTzXPPFwc9FXKvTxFytH3qrAFVPObXbH+GbW0vF9BM3TIr2?=
 =?us-ascii?Q?UvifL06cp+YJ/aEOAsAu5Eo0Ek2c4yk9INIcg2Mk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?iejdDCnbEakCFulDY63PXLOgtqSZyntstOhK/vzIuFmu52tibyAI4szkR9fV?=
 =?us-ascii?Q?D6zT4bo5m0vIF2mYlpvZTcXTX8HeSbET4SOoHw9OeJ9H4m8cBD58eLTOoFVr?=
 =?us-ascii?Q?K8a3Qdq2paWtysVb7EQKeoQMuSzIqTNXn24zCYUxj1YWMNvb6y3q3SrMUocE?=
 =?us-ascii?Q?heAgFP3WGN/AlzKowPUsTnowrDVTCkH1F6l2W8w4sjbw6KaBJINF8pLoG2p3?=
 =?us-ascii?Q?cnzSCcVpA/83+8wi4oV6N/HF+ktOw4oSK38RRte0OJTeBTEmoJL/sGK0QBHW?=
 =?us-ascii?Q?PdOIDv+ktifUbBgbu3Fun/0CT8XgW8bOFbnVgCh2koNsnc3jRFfFsWqssQ8F?=
 =?us-ascii?Q?SQR1rZaNCjYTXJNAX8NKG8XtoiPPrejTLpnHtiYq4gLT3TJzXA9TCjT4LZls?=
 =?us-ascii?Q?Hn5kElctItNIbFsVxgjRdvSZvlXWBg7tJiEDRlrY4JyBqB/trUlCYfd1iV9M?=
 =?us-ascii?Q?d6+Rj8Qk6EuyP5sW6o7Opbu7yOBeM2kjP5fcS2jVWdF0Tl855D7Vyev0Dw3A?=
 =?us-ascii?Q?/iRCAepfqlHR2qKOJQI/Fjw8JQUFAAJt39uV0MdG+/0Jr2zBbqr2T4HqrAkJ?=
 =?us-ascii?Q?psm30Bb1ZZnzWSkkP7Pxh4KbuYXTmo+MXxDS3w2Mwwgp3NlfkQR0cqKmVnH8?=
 =?us-ascii?Q?WoL4mXPcIpb7gsucSHysqLJImzaH8bH4ymUfI6AW0P3Jd3ji5HoNXwDRoJ8z?=
 =?us-ascii?Q?HA4EVqMifHPCPHFHuVgB974Kh8y4E77jz1U2hBENpgmlNrCJio6i6Vv9Y2/Z?=
 =?us-ascii?Q?fAJ0aaW5dWXaLIvAV2nANe1/bfaAwq+SOPtfBLXW+n/1iZXn4aB/DRcYMnWt?=
 =?us-ascii?Q?Je5a+EbT4/v1lKnv8NJb7ilm6ds6Z3JIZCKCTcJVVWW5NEC604RLiK+GcuoV?=
 =?us-ascii?Q?wG3pJHykL+nWi/T6MhDhXtNDY1lxvL44v8jMt31ItpXWRPaLriXwkuYj0AvL?=
 =?us-ascii?Q?FXCkr1Mxt7wJVS8UEbGsMg=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b9cda7-314a-46c2-3395-08dbc377a5f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2023 18:44:45.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0rtQXIzSTM4kQfTEq1ji1aTmFdS0idHzMGh8Wi+xMtntR4PIzbhz1iUj1/2Q9rAiPDyDcfOL38uxk01Lv+lSFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6537
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Peter Wang <peter.wang@mediatek.com>
>=20
> The clear tm function error log is inverted.
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> c2df07545f96..4095d88eee44 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6895,7 +6895,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba
> *hba, int tag)
>                         mask, 0, 1000, 1000);
>=20
>         dev_err(hba->dev, "Clearing task management function with tag %d
> %s\n",
> -               tag, err ? "succeeded" : "failed");
> +               tag, err ? "failed" : "succeeded");
>=20
>  out:
>         return err;
> --
> 2.18.0

