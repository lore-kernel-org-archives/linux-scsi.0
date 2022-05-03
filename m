Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A9FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiECOsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiECOsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:48:07 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C839161
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651589072; x=1683125072;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=TLHepgLvAuJUADs6z6ZTK2wSiMirKR+xj76N/jdt4wO7HiOliyZBxiPd
   VnjCWBy6MsdtO6iTcBFiPFOAHJhhqxRlKadS200vU8mtZ40SIwSlvBtgH
   DwRFoiAdDwif75JMHgtzVfBP8NAkdIINZo4Sb6D5fJUegnF6OblbiF3PL
   0gSmDcJqhM/oZB59ncvYjF6U+CfGEGIFBMNTsGUMDJ+1mniS0nG527KzL
   CMqMZfObHdAkm6ARZkNmVN8uGY/A9hiQ6S1mrxNjS3Uw4cUVwUVgX46Qd
   +w1zKFKNn0UZzaZ9Sl/ojS1d4nJ0S4tduuPQCLvZAFz47OjaBd3xoPBiz
   g==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="199426053"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 22:44:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU4BsgDb3PdN2qfKUxKyeCIxNieezhHHrFhzmNiMfe5vkk62sCyZ7D9qkmtBYCWx0gQYkTVa74vfJs9oORiugVMT3YLJAI8dTS2UL5J0DKHAf53Z4DCxOTS728WFRFGgWAHYONsXI+qNxXIBksjyCAlb8HXao4JsbocvWGzA/WtKCiBuri/2T/V7BXCixrQ6iMzf84flRLrzt7nIWb9lHzL5fyeYzIjxgU44mWcTXSk1eZ4P+mnZnqTYEp+8x1XqoxIHmpNdTKzEkys96uXm6PKX+cGkVGp123/1c/GYemUiPOV7YIAiLzGH0fO1L68zroeu8X0Qzv68p06jZv0Tlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Xq3yIbmZHro+xhMOPXbRqMuEOvwvkxZDZFO0J6wfhoX9/sVXMh8nkmeCy+4vGXYRj1uIqF6kCJSZ1IdrGBtcCTfN3+RjM516ofauRn/FPQcd6JuuT/H0pBbJwUmnr3sEK0C4wiDbsDlegkifIb/+SD0yz4ZdK8lJTmXKMYN0d3m4ZGHR/YsnSApUSh+yaUNcSqs3SEM1ZdR9YSEZmU1yoUKkw0+CqEypjhYMoM9Yrv30brehyQkgBwkHeq66VBIOMAweQYE7tkrpaIzWA9frG5N/fIbkPAusZlFjfwDHGHiE7r2PElaTptfcXEE4GeI2x2ieyNU5sb14mZZ5xya9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=S27A+i0DRZDJCAjoIP5CabTN4UJT3Z0fXwBpz9TR5haZ9EBdujsDmhDmw+KWwbSiekN9GnrcNfuy1NXkqcm5I35gWPd43GI7f0NWEHen8Aoqg01b56pZ2HUr+l0tnH/rX6E0fd80iX7H0f+Bzz0JUBWFaN9qAfYJ2OVsa86O1NE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB3897.namprd04.prod.outlook.com (2603:10b6:5:ad::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 14:44:32 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 14:44:32 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 02/24] fc_fcp: use fc_block_rport()
Thread-Topic: [PATCH 02/24] fc_fcp: use fc_block_rport()
Thread-Index: AQHYXm0ApNdN+UEWMUS1UWPv0s8LSQ==
Date:   Tue, 3 May 2022 14:44:32 +0000
Message-ID: <PH0PR04MB7416F635C728345990E84C2F9BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-3-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 856e4e64-a572-4b50-d559-08da2d136f46
x-ms-traffictypediagnostic: DM6PR04MB3897:EE_
x-microsoft-antispam-prvs: <DM6PR04MB3897889BB883FE91C5A3F88A9BC09@DM6PR04MB3897.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +XeJ5ZwT4swlxRyyiBq1hpvPvk/1HaV8Zyw9PIIGo9EzKT27z5rR63BcWScq+/G7Rc0wlZOmsDM4CYhqxBlLqT6Glj6faQDtbJgN0NSdw3j9Yp7BLFVlMNmNisGuBrtU33OAQlqykVMwidQYcpbEbQmgAaDvLJUtdnQUu5372pcXU17iexmzjVHWSNUM3NUPETj7xfBcw99qpq7UGE23Gktxv+l/kh18An7yB5NbQXFXoaX9Rr8K8siLN1iowKpxC3y9NvsRsnGQFN0jnvveDddF3oZn0Vr5d8NRi1XlJLkODIoKeZgM9v3m2Ld3mlkMg4lKt9TYV9XfAU3fQ8yxJrjb99WOM92RuGeXrTk2oQjuFp1JWorZZf5U+c+TPMdzVv5HTfWUw/QjN8KVERBY1Nj0qG0Jbw8csdh7jr5c5zhsGFjvt5UP1m9fUNoAZG1Osrf5tL2l1yFRuyAI6klMf+LoT4vjVMOHyXeyzhmVbUGnI/14jLUGJ6qTQgrgQWjlfC8MUXbiGLXa35rwPRbxZXosXVhCN4ghepMd7aUnYQ/7BsOnY0reVz/mdx9RvWLiFqNFFWlwHR6PVjnfrMAaKUpIFzUtSQ1PY26aBfmd9+Zdc6XeZ82OYglVJxozz6w7b9CytFDZG7dhWnlSvpG8SoWukiA0iRzeAyF1puEPpyFqMKkwWdLAskXt2tAdSW5f42x97FlW4aJMuRDki5VsMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(66556008)(66946007)(5660300002)(2906002)(66476007)(316002)(33656002)(76116006)(4270600006)(55016003)(7696005)(52536014)(66446008)(8676002)(64756008)(4326008)(558084003)(8936002)(110136005)(54906003)(6506007)(19618925003)(86362001)(71200400001)(508600001)(82960400001)(38100700002)(38070700005)(26005)(122000001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kzdqLvP2/FCxqdl7y0aQk13STtPENENljoyTgcDAbVl+PqwQJfJdEvCDu3PQ?=
 =?us-ascii?Q?UnOBkQzxDwXk+YT4LFXEKzMZFH5nFIuHmk6rFk+nE26/LX1TEAHByP6FfB2F?=
 =?us-ascii?Q?eiLLFFSjv+IthfEOs3z89xaBM3Z/+Ve9Y5B0cFJusmuLaoPFcWaTZ2wrbcZY?=
 =?us-ascii?Q?THa3t9IA+yp8dad8y3Q8UqmeaGT93L+zI9AHysMTygB0YwrKERzQ/lrQj/4+?=
 =?us-ascii?Q?822n1buFkSxjonnMZLrT5UWfTeEv+IajqgC1ddkgX1GIHUS0vtlSWjHdxPDV?=
 =?us-ascii?Q?FD/1kw4noqMAlWm9BZ8kVU3grM0VeuH3M+W2pH/uuytcqJ5mIbOqSjFlTs/W?=
 =?us-ascii?Q?Cj/tq4BqlHAv6A21WOLRm8lqk8MqyX7t7Tk04tk907fZalVE9SYUclLjJ62L?=
 =?us-ascii?Q?6wynQEYe95wI4Q5DJj/WgHc01foyuZUE0Xs+zxwSXt54UFKELfUsn+DFsTkS?=
 =?us-ascii?Q?ukHTB+8AiRPut13vz7QhdV4xUl/03HVU43XPGfLCQC5kDOtKJ9lwQPXeztoA?=
 =?us-ascii?Q?vO6q3RoELnsfAR0nj9bdZZn1a1H+c33qQZozsPrQL6T2W3VCAnACLj6XZ0Oa?=
 =?us-ascii?Q?m+xKtaOASBzDNWJMFMwx1/yViiVvMOthUBCeYu/FusHMLpQA0vYhUSkXR+Mc?=
 =?us-ascii?Q?QMfcKkkPHsy8lf6eYI+8QQ89HkwVngxMGs+oQ4g/15VS11Q5I4ULCPGY1E6G?=
 =?us-ascii?Q?U91o0BYah3B+brd1zFRkMc6f+ANUEtdQQ48oSyhgdh+Rz81gSNyhakVKkVK+?=
 =?us-ascii?Q?AjYcAEEKz11Gm7f4g2aT/T8DGjZ3tD2Z11MZo6vXWOHuVlcTcXo+Xqmwqjpw?=
 =?us-ascii?Q?zL2E68h8niqSXHRenm6Zf6PxWEuUmimo4Fs3qzde7FAowxT9O6KAY33ItZTf?=
 =?us-ascii?Q?EiBQg5HqsxD6AJ0b/cCAjKx+na9EOYmJ33rhGUjlot+QngHZv8UwY6IIJry3?=
 =?us-ascii?Q?nvFYQHIT0ualdGQ+0eeZ7YwvF2xaUf46Zys+f9Z+/4SowGfBG6OlIbQMmcZf?=
 =?us-ascii?Q?MPITHww7SSZfor+sr/cnl35XS5pPe+CNTdcsMyh9MrJNly8+2ACUsJQA7Kcn?=
 =?us-ascii?Q?N/33Bxc+Il7mhzFX1ONbs/uzCBnp7QXt4N5+YoXsV5uke0WUg0NqjM6P8hM5?=
 =?us-ascii?Q?QnqkR2acRVijEOZ6C2EpcJ1J0wjxeF9fdaz10a1yxs2SFczTvgCLwBdrjCxp?=
 =?us-ascii?Q?5xuov7M3fVsPlG5jvMdJn56Rm6w1U9vjOOMNKrJFvOEIuNfnPp2i0bcLOK3Q?=
 =?us-ascii?Q?W3dxZuB5wpRKN0C2Zohsldm82UsUCl2T/8XDTzcguzcdSUZQcFL6VaRhL9tD?=
 =?us-ascii?Q?WxOvM88vlMFSEiwMOQS3w+ZtsHZjHZr1N5MOUCNUZ58vPbmIeagj+a7avCby?=
 =?us-ascii?Q?eZwxMaJ8aDHTl65w1naVcz3KaIuUhMxpUNgze8dXIkrPSgkieonnroOaFWdQ?=
 =?us-ascii?Q?kch2qvNl/bo3QRJDgbs6Rz7telf4c6xBP7pX5kByALNX4DUBFdo9HPmWCUnF?=
 =?us-ascii?Q?TUcirqWNlponbR75+QP0HuIGf4jgqqSWOAyT1HdYF4HYwCYE4+XWPpN/j1oo?=
 =?us-ascii?Q?tkUT1OJA0bi9BGeLa/5cx+Yj8U4ka3JLZwwXH98+1kRZOzzkI14ZTN2BWaAp?=
 =?us-ascii?Q?HN9v/lvTtwsBfZdtAwg5WFjSBJIbQL0htfrAFjVxLhj1GsCzaCuv8QL8fFs8?=
 =?us-ascii?Q?tsQAbxGMrh17dhM/IwsxgbmNHKEwYPwNsWVuvzFQxy8JKSq7GsaR1e6vh0SA?=
 =?us-ascii?Q?ZoLGfMQFNz2Qkl3lhKpbpJzXaqNRWZg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856e4e64-a572-4b50-d559-08da2d136f46
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 14:44:32.0575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YcZOutrdJtZZpqZFsUEjBKjtpQSm1l6WbWQPVHRwCj1erZIhSUjlIS4g6wD17ZU6w2sWlRmibUSixfl2PHfLME2Fln6AOwabWcVgxMjzlqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3897
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
