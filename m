Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C065C2BB1D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4509206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Zm6lDnjb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EphnUZWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405547AbgDNFjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 01:39:25 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:16703 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405521AbgDNFjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 01:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586842764; x=1618378764;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UZm/gbt36pyrEG0k8XIqt9W92dsr2xFwCGU8+iVAsdg=;
  b=Zm6lDnjbvueqKYBZXpyuPTkPcH8lr2RXRVABgfp5m8aTzues/kO2ACDW
   tTiUm3PI0q1Bw5jIKPsJ6Coo1mazYGP3cNdYo2so+XKHaWNyWPw5VlOPP
   IkIipSsMeKgIvX6pKAq1whICzftX7Bpjcrd7K7FIi7VFI5N3OoId1+mPW
   0marVCIkjvPfu6hnRgzTqdhyY9ckL6hx48hSYCmuZeMS+8MXOzFka78Vv
   JG0EjO9UbmCFQ1uT/JLSc6HOgjnKUmP+whgHoq1toLFq4cDvjxzySIAyx
   FWOQ/7wYWz/LmEy/G9rm0aAkf5yuSM8pKd/Pdo5emOq59tvwXClNuu1lF
   g==;
IronPort-SDR: 4LEf1/UdniW1tnML06MtLnY5KjOL+Ftv6fHcdYrZSj/eXDyipftuDRWJ2fvrlrlD18zejWBsZD
 YF7FljEzYWfi9B+YutWQt0j93djAITIbQuTIZDGKWmVAWlMDZNvtVeEEhA8IKXU/tn750c+10/
 npWQWlimnldaUCXdTjLK3kCdZ+X4zRWBFGPtFlECbgcwocGEtVYN5Hes/CfomerE8/eIYbbtNy
 lnW2o9iNpPjphSnS6i/KIze0+uRBhm8ky5/aLJ4jrNE2xuVTiLr8QYYe6vLwlG794uWgUY7OfV
 mWM=
X-IronPort-AV: E=Sophos;i="5.72,381,1580745600"; 
   d="scan'208";a="243927906"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2020 13:39:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wq73d3f/GrWPTakE9z2rY1+zjxA2C/5wWXq1GlIo7rcILmaG83d4U3asR/b5gJHr2dDBssyRh9LNELodWAtLcJFTxpLhuHMXPmorTH9BQKGgdKCSbCuYsfSJ/AizDJG121Yx1tzyB6vCD5FX55I+jXELr9UOABa6NaslmO49LA345Rh3cGBw+Lk2c5fII7fqf44HwqkkoSjpT44+7uo9dzICOGaGyF1Ja2RAv1WbKl/cRohnJfwY5s/QyklURLoOQm55fJcZ2dq554xolM23xCefVtOTZt9KYnoemkduqlzohFdGiG8D/Zc5gtr+qEGMGIjl7vbcAYlpk+FIbeZLNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZm/gbt36pyrEG0k8XIqt9W92dsr2xFwCGU8+iVAsdg=;
 b=OippN9x36FJ0HzT7F5yf/L0LbMHJ3wk5Ob9+vqJOvakb6ykL1sYk5zPuXvrW8qo+FEog2yv9rnvNrZXSZpprIQY5x148CKXYTigPWqAnYw1bWxh5kn8t//xMYbneltAqEQLArSHMvsCRCCVo+fbhtd8SdfbClW1lEqkIHvdmAUjXKiSzm9RUDTd2Wi2kcaMdu/elxn5jKOKPMiiVbOF1kdPsmpLnuZYjz3dgjUW35Jx7ucw5hPcS9g+vTiOQDWWwIP0JhW5pEE/ruvB2PM0CKPw8QULv7lgzzMoFNAScuB8la6eJ4WdsK4urjV7ioXSgjSYxbQ8eFDUXVUQAGEOXvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZm/gbt36pyrEG0k8XIqt9W92dsr2xFwCGU8+iVAsdg=;
 b=EphnUZWK4HwpM21sEJk1XW/nfXym8dUv91g3STeDH30uGEBkAbCtXXYMAKOJdgBOt9PTIz7g22M8xU8kQR4pPFgH29Ylh000384z+R69wOrP1qOErCprr9hdFl4cT6vADbEZTVqb74fIIxr/E8AT9w+FQXOPR8jwTKWLrTXTt08=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6583.namprd04.prod.outlook.com (2603:10b6:a03:1d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 05:38:59 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%5]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 05:38:59 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v4 07/14] scsi_debug: expand zbc support
Thread-Topic: [PATCH v4 07/14] scsi_debug: expand zbc support
Thread-Index: AQHV66Q0jOmaKf8utEaf1qVGuuBg3g==
Date:   Tue, 14 Apr 2020 05:38:59 +0000
Message-ID: <BY5PR04MB6900F73DFE5AE1CC03E598CBE7DA0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200225062351.21267-1-dgilbert@interlog.com>
 <20200225062351.21267-8-dgilbert@interlog.com> <yq1a73fvvmi.fsf@oracle.com>
 <BY5PR04MB6900CB37BE3A595454FA476BE7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900A558706F2ACBA6BDE602E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <yq1eesqu8yr.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0723beec-a188-4929-1fd8-08d7e03621c3
x-ms-traffictypediagnostic: BY5PR04MB6583:
x-microsoft-antispam-prvs: <BY5PR04MB6583EA881C392ABEADF66F24E7DA0@BY5PR04MB6583.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(9686003)(8936002)(52536014)(33656002)(498600001)(55016002)(2906002)(71200400001)(86362001)(8676002)(7696005)(64756008)(76116006)(6506007)(66446008)(6916009)(26005)(186003)(91956017)(53546011)(54906003)(4326008)(66946007)(66476007)(81156014)(4744005)(66556008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dPC/BlE6FK36LC8vjdjWFVvc4AOJRmX9xlFO7ENMgyM0cer5VJtWuuywpdbqr1SU49II62cd1IGZkekzfhMBAn5SzeeSPA/5ePjQgab/42CcgQ6d3F4zdOb4MpS35ESkvJOrBeu9j0kws6n/PPnFT843UwC5i4CHn8W2fOC1WvLsYU0raexCpfAqX+8A1cCrrZ2bDZwqYpKERzyOOm1tbUJsjocQ8RKdX8AvMwTtrfW7D1IgqSr7ylULeivPYcGmggtpHQWgN3L12WDPg5muwRhBme6rFsoYX2HlF/TmUSu/mxzwAgn4v8NrYCpl7h6QPpu0l9UKO44QNh0KV5IkiT7CViMw4rniwMfEhyLX7TajRYicC66C4FVLbLJk1xMFVWQBLuWDnEmQYa6mnDQBVuPf5+1AxDcghpSntIRdzdvZLMoxTiDYBW0X1CH0+rA8
x-ms-exchange-antispam-messagedata: Qkn2R8pZR8kS3u8MYRgOyrqnUJhC+wynxx4uRJOI8Rmi7bMx6VM1ApfPVxXauFp2Xvj1E98wzbeg3800gguELLfB88W5qXAZKzM4uyyy1F1iy2b9zR6EjkuY9PSRZsIIKKIyu1SyDPIriH6zPj2HIg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0723beec-a188-4929-1fd8-08d7e03621c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 05:38:59.4022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XzM0jn+fDGoMhgpGqNA7Z3+GPxv61XCCbeArY5T7sl+VqMyOMY4JCo7py+0HVOkE1e95LjtDbpGUuQ/DFcqjBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6583
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/04/14 10:55, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>>> Tested-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>=0A=
>> Oops. Should have sent that in reply to the patch email... Should I=0A=
>> resend ?=0A=
> =0A=
> I would prefer the ZBC changes to be posted as a separate series with=0A=
> your Tested-by: / Reviewed-by: tags added.=0A=
> =0A=
=0A=
Martin,=0A=
=0A=
No problem. Will do when Doug re-post.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
