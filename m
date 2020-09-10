Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EB6C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3049C20872
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OPqb3u0y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CoKO9I8M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgIJIIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 04:08:32 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14097 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgIJIIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 04:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599725303; x=1631261303;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=dMtI3KdRliy4vAyZ48mVySDpKYn0iuvnoYGcgnknxac=;
  b=OPqb3u0yxhr0wkRbTs+Od0yGKFXR7SC8DrRRtkXk2Daq6EFnc1N3lCaE
   N1RKPlWIa0TclS+Pg2NFbhDmB+xFBii+m+W6YrWbcb6SeKJuSsexT6PMg
   EKKmeojwXk2iFk985c/9bwfH1cfYaLQQuZghZ1UiyMWgTvhA3YLY8O08R
   hYrRz/kCMsUsY0p5/lZosOaYSoAp3ow+ABzjk8ULZLLI7vJ4Eo2xj7uK2
   M5mcYzFljjEeptDiMPwzCodjN1Eswr9avfkU22W+qAdwLE0v84t0fWTPp
   qNwdS5+FL939zluh7YuBBJA4WGFrllywtRXc9hDk2LtcegXwhGEhqNATP
   Q==;
IronPort-SDR: 9Rwl7uQpIGNfYKkPkdkTrB1PxP7Z90hfTS4w62VpMJlmVm7GoC+ACCLnCJbXEvp5KXPSowLDBU
 LrrcCJ6BiaKIs8duuxnPVn98ZLN9pDK8Jfga252JJNccmBAxCew37SrEKli39gh3lGY74oBUHs
 OqpJFQ1/r+AzqH1mQmI3F9I84uCdZqOBHPeji/2Z6DIs8cSQ0uy7mOx3ZQyu6XSS9MJyTOpg5q
 TuI2f3JzLZVTpw/sY0D8g1UpaLo2iT9TSwltZlR4ZAuPMvaH4DiwK5PtqRVXCCJvtAbh9v91Hw
 Oe8=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="146934135"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 16:08:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agkoOSEx2e/MS396eDiavdHJ96UzGPpwA5YkgGciMpme3DipIN+rlNE7uxwF5A7ZDz0A+hdeIFA2rXjwGRt3ykn0dAZZ5bCxTR8bJ7ZkJs02jgCe3MJouuhqxJa9eA4WzhushViDn4PMcGvSk9GH89W8ymd6RXHMoX6mjZUvWm2n+7gJZYP8I3g+ZxoaarUQ3LKiK4Yk4e/SC1cJFnHObCXVf6xjBK07G+iC+ugXODJpfESJ+o+BzuduGo3+uRBJdKt77XQcD888+qQpgr0o8YWNeW4gWxzNHhuYW26x2dw7Akv1xZR4ccJ30FIvzj4K6utw44zbrkv+foIiIOCZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMtI3KdRliy4vAyZ48mVySDpKYn0iuvnoYGcgnknxac=;
 b=aC3DjqclgnwsqOnWlQWNxtpv+BPtE7TKSGxBK5T56vHMMOAwDixcozV/+cqWeb2bKM9bmxk+/Gk0gatkHwNcVXpjzeaG6cavswLhgW8KE+KrBT442Zbo7gqSEpIVdl/hcvmIprpvHZcW3OeYBb0gveAbvXRWqNNjRg5BqDhxetQp7NgHFLuhPhqUSVjbNgblIod8OqpuLwkqcrRnk9xUyECogJWFl3wghpdSBncP1pr51wrIF4rbNYy2YZ7DFAi86RC0hRWgWIMyK3To/CyOkN2TGLigZarvXeH/R0kzGAM03gSCmDulPD/pJTr/lSgxh9vm/RTJ5PBkUNRuBRn0Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMtI3KdRliy4vAyZ48mVySDpKYn0iuvnoYGcgnknxac=;
 b=CoKO9I8Mp9n2OXo9pMG8tYUcsOEY07PImBcA4M2b1zAIuasgRLykkYZPZW7fNpo9q1mp4VXRrc4LqWVvk8cjUF25safW0JG9QsFNjs8YVWt0CDAxFLKB73RLLJKiQbMVokjXRVxsW46DqwTJTXZ1u/3eAPAxRVopdSwC3S2EDsI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5119.namprd04.prod.outlook.com
 (2603:10b6:805:9f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 08:08:18 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 08:08:18 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/3] scsi: update additional sense codes list
Thread-Topic: [PATCH v2 2/3] scsi: update additional sense codes list
Thread-Index: AQHWh0bdBrQreca8cE+H5iG/E6RaEg==
Date:   Thu, 10 Sep 2020 08:08:18 +0000
Message-ID: <SN4PR0401MB35982B78E275DFA5AB64C26A9B270@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
 <20200910074843.217661-3-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:142d:5701:2cf6:d0e8:5d46:4118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3409c9f0-b2cf-4f7d-f6a5-08d85560ad35
x-ms-traffictypediagnostic: SN6PR04MB5119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB51196D1D8B17B33BEF9BCE879B270@SN6PR04MB5119.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PrYwac7haMrKcKJDnPs97+44XEQCxt4vFVPgnWDuVgOuTTdLtTU3lmUomRvu0etDaJgqruhvXLHJQ/lAamGlVK3gVlN0niUBDPDtYojD0fMNo88ObrueTtunu5sHoSIh26HEjRlmXS+liUFCB4WaaeYd50VqXEKcUREzsBHxtFXDL0l0uFHPkNQjAllID6k7qax+2mCSRzuaDDHNXNnbRfT7xHIstwhuilQcJl5JIQCT+IX1EpI3/qs9g1VS/6go7gkZKUOT8WJAVyLGOdCkvQLws2MRZkh+z0nY6HVYoLeUqgut3aoGzr39t56FrT4v8X7RTAMKCp/xy2ya6p3Xmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(316002)(52536014)(7696005)(8936002)(186003)(2906002)(478600001)(33656002)(66556008)(55016002)(110136005)(9686003)(66446008)(64756008)(558084003)(86362001)(66946007)(8676002)(76116006)(6506007)(66476007)(5660300002)(71200400001)(91956017)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: j5DQcmqpjO+B3UuWN4tn/iovZQ4lsF39nBIPVUedxmUAKU5PiQMZTrToxdvHLJcn1gUDyQg7wxxCr6ER7r1lO3bwpKyMJyVYd0eplktqdLsxDB9W5s93RRDPqlYHX+4nQGr4c9byYtSoag+cxYWMeOj18knlsgLjPH3tupaFKVpRP35zsWLZNGTe2UJyCdb+jHLhH+8rL6Mm2JHcuelvYz6r0f1CMSWbOokx2V0Ia0MK+bn7Z819zE9hYHH0pX6Te6O+oM9LLDpFWdv0CKarzPQxfMylyky106lIema25jhctOgxZgr/QPREaW2Rgj88B4QYZzGO9mCLTFy53qeog+Mjh+N2oDOCSDoeY30Zl2Ao92vwdVEaFatL42jfVZQa7U1QYJFUTiaxLUrekrf85O6INphPC5FTWulTSab6pe9vDI5nyPJawOG2eFzxAmnf/TYDZ8aOwZgOXdFeo4xK7I1BdgfAUSWPgyDQRGzw2NvPRTbt/nw5UXmtuwgBfRmi4WFQcPjqvfswBKvj4eJwdkF9vQdnQOwKzC0lCnAAAlTvPSySJe+ibh/bFVT458yGrZCIf5m4eevRHPl7/uULXexXp6SNqpvo2Q7s0Chanms/rHUrKPVC9SVp6OmaDrlecdpawYaQ75/QQ5eFotAcs38VNJkjqpgKbMoBivqMGZOwgCU9deB4TL/n2oAt6NsIwQAVo7UitO4+1WeSZSsp3Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3409c9f0-b2cf-4f7d-f6a5-08d85560ad35
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 08:08:18.2922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLywZx8UobJjwjQ48W7MJ+2PEOsPuyCCJAq0Fgsex0weOirFKQDcyNoOGMRsue6NAyHoRVgDCzUwsbDnLv3+8ELgpm0oFy4Ejdi9NuFNL2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I haven't cross checked all additions, only the first few.=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
