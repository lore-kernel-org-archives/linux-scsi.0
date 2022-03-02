Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB59BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 14:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbiCBOSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCBOSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 09:18:53 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120343206A
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 06:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646230689; x=1677766689;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=UsnG9vGqtSuhLnXpSdZtSEGbi1CvmUWb6wSSQnY7Fl571Kb1jIbF6ylH
   HPwneeV/j/IF8A5W8OjRIFmdhj03+EX0R3qV+aZZjTw5FXhJYvYkbGqMa
   n6k4cuWK6p0SRtpWqhNsAzFtOXK11vcXhKLnpkrft8nXrpbzPtn+b/rYI
   8fSQ5o0zylty4A/DH5ALV7Dj+8swNEyBw1r+p0G3N5p0w+HdC35znuTg0
   N6MRD0qk8BlyiLx+UK7ECokc+Ti3YYVomM8cKRIZKftQ0xosI/rBGZbb/
   vw+yYB7iAHDdOWChmD+YL04XzGtX1uxAi0KS1zK2nfOuJ7lEkKzkHHtvs
   A==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643644800"; 
   d="scan'208";a="306199588"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2022 22:18:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ien5XvJYhhNgRB9KFSkl4rwYdXrJLh1dVs6YfOeg2R/beih3CS0IpHaXhZsg3Sg9NaZbIZDjC+cRaaxPgSbfbqFiIAMrkFoDgn9+5rAiq/T8FeyH+ttsK/Tnf8N3r1Yz5xx2epT0Flm5NumGtX7FFK88543sy/8uGfMg9Xc/9y5OP/toPAGIm2RB3wUrWMQ82g0cHn6Xg0tQZ25EduMIrHJvbVH8k7MN+owFw9o2wuCWZAvu6WqkccEKa+Oh/TUp8TfH1URrQZBvoNDIalyZ9WNBReUAj+tm+59w0AobvnldmE3LGdnveaSEHDuCHgOjT7Z3TmFoUzTEt7Bz7ni6jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=RM87WHgVxIkCnbf1c2LqJKYd5QCfyWxKN7rm7394DMR+6WVtAGZvdenSW5AwmvwooiyOOLlF73kcQb+axBwWADqyuMg63LUxNSappAMXkwG8OH7/Co2TtXpb7McXel2AHUqxnR/movdIZ3x6bqKmfWvAje0pmFKQg8Lu8QtYaWUXi7Uf4wuNu8pvTBpT2IPwKl5/sdGX02FhRLHc0e9gj3OoHsIyWDvdPSk2hncVXjcQmWYuA5HgqKkmHOkHzCPAI+aSiN/N10xsB1kDNI2XGt9SHTBxSGWsf3LjlZ+oAP96z46F/TPR2TI7qpRAJNrUB4aBeSAwl89RbsTIZT7U3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=iebx5tn943q5xPgOHRl/iO5A55+VINePchdi9htqHum+5IOam4lc9PXoTVKEyMosVYwqTYh+1hfud9dZeGkaWJF8DQSrzPp+RU+8K3VkcRrrbPj0SDudeQ8G+bR/MrjfwdxcEqFc3X04vgYVBeouy8eFvrYUNCWcPZYCDGzspVE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL3PR04MB8203.namprd04.prod.outlook.com (2603:10b6:208:34a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 14:18:06 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 14:18:06 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 01/14] scsi: mpt3sas: Use cached ATA Information VPD page
Thread-Topic: [PATCH 01/14] scsi: mpt3sas: Use cached ATA Information VPD page
Thread-Index: AQHYLfd/zdEpJxLjx0it26cL7loqMw==
Date:   Wed, 2 Mar 2022 14:18:06 +0000
Message-ID: <PH0PR04MB7416673C5B776D288A9E63979B039@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-2-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b5c7176-ed74-4b28-77df-08d9fc5778cd
x-ms-traffictypediagnostic: BL3PR04MB8203:EE_
x-microsoft-antispam-prvs: <BL3PR04MB8203A2DC08613DCB58BAB3DC9B039@BL3PR04MB8203.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ocFHmmKZFluE4TteLFpZtLNg1lXx5CJKy4SSnvMBrcDrbOrs7W/dUAbOBziurWzdZxuDmtSxB4YhezwyK3AMW4blRas6lCAS4YcviedpLQ61LrKISNrtc6HdY06VGXhISCcDubxuqXzbFGvP8qh8lI4nF0pv0uusvvZaD4tPqiiuJoXuQiaig9vQZw9X90iG8uAt6OuK6TvKgPQy+rhPiPaIWBAbYh9YlSz9TSAKZqXzcLGTCTJ4sR/lW+or5xgRcyCf8PHLy91oKa9gTE2Sk7EwIP5ARi7wjQFk0/9P9A6g67ekIJHQOexhtDLKVA/ZcHmAx9gOEaL9BARVErNnG8IpzhrGFVjK+ugsubUoD+SEuiQGffNFF4onEMOrAQ3UZqsKJGYwP4qv8EWpcp44oGL4T6DCdrwLEcB8I3fta3ho55xKCyQQZqdnyeOrA8zNjjmMgRhWdlfPJ61h5Ib2C+AIzaoujNKfFjGjAkx2yuj6AmS/UxmnwK0UYiHiopDSEwkYE0GHlzD6lgSTlUrJ8UzFfmeE2M8YFNSuTqbEMFyXEGpUgp3x+0DeP8CG/xfs5o9+wbAPeqTyJ5CJmI1RAjPEbvGIJd1HoFr6Swd0SzLLwZRqHQT0Q2C16/2ycvnYTYmeoOpp2WbDykLwJtdbIfAIvsOtNgTiDwAjemklFLQQmCQP5JHpsJ3ufRpzfTKZN1HGRKo1FI78wcT/qcuopp+1SJW4nL7Oph8ZSA3FQA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(86362001)(316002)(71200400001)(9686003)(6506007)(7696005)(38070700005)(110136005)(8936002)(52536014)(4270600006)(33656002)(55016003)(122000001)(66556008)(38100700002)(66946007)(76116006)(19618925003)(508600001)(558084003)(91956017)(186003)(4326008)(64756008)(66476007)(66446008)(8676002)(82960400001)(2906002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KBwORvUqEyOGGRZ2+5i6ZSouMWcQQu1g5bZ5AYmgaoOhfsOfVA39e79MxQPX?=
 =?us-ascii?Q?+Iyf/xGwZ/Dgm1a8kkEBhDNXZNa4N+yCgDunscksJSJ90cK3NsRNdBvuB95w?=
 =?us-ascii?Q?iudUeZ8DI5tdRgL9nYpxUsHspgzTXlKWJ0ZefwZY4JcuPNewLwNe5o/DT9G7?=
 =?us-ascii?Q?l3oKBi3PlHMKmimwrKYszw2hU8/Th9EFur8vxc+GwR6JHhCsgwIf4Nyc2u5H?=
 =?us-ascii?Q?NgKAXjt9BsZPL6nGAUcuHxjkEY5Wm5Tx1rMip4UIvqSBiVHZanG1Ufzh4QEB?=
 =?us-ascii?Q?4ekuVS2rAmBdVOt4vehuGXLXWFwR6q2lk0BShalGWu3IPfHdZny8OnStVlPq?=
 =?us-ascii?Q?uDIOKmeymRxL9KjCb7IVp/rwbPxhzBpD9fJwhjeQ3IFIO/76WnVjB/3GAvfR?=
 =?us-ascii?Q?NwUrXoXXnZ7rnoJr2mp0uzB/rYfjwDu5wb4Gh0Yw210M47gW+DaN34f2jMcX?=
 =?us-ascii?Q?DZo9G9M7COo0r95ZN1mfr+SVMC8uaq596TKr/nIV1vsSWeAZuTJ+UwxOJJog?=
 =?us-ascii?Q?Ou+qW7kHyUd4Qj/d/jInudC0Lfu4I9S1PCqgvC+HRrjtyqxk3rj7QRQfJ5CI?=
 =?us-ascii?Q?822b1i3tJl+8n/P9sgMtu1Ve5os51T0BjKo9e8iVPcI5PkuqOMyY2tbxrALf?=
 =?us-ascii?Q?ON3YHspkLvpSKGoZIW/VeFjyKwAXc81g9w/x5JRABMPDPo05cUK3+zl+fstx?=
 =?us-ascii?Q?SunHXkAFKYjPdJAFr+/+qX5hLwOPhZzVMGsi21jjohElm0ftJAE45BrjVM3y?=
 =?us-ascii?Q?R1PPsljPYuOgli0BjhbeNMlC44A+ibKEQN9YL3jmyJ0pFS2rcg1ZqEt/BQy3?=
 =?us-ascii?Q?NOMkhgtWt3OI+dqlk8cb4ezhsUg8Byhhs3oZ9QTCnk0Nh8xsJbNqyRX/dagm?=
 =?us-ascii?Q?5rE52s71q8nW81QCIaCf8/9b9wsTJifbufsj8K4G9iTBXbtUEbG75LD3td8H?=
 =?us-ascii?Q?Z5LCi9eRFzkj+nZKIidsOBRsBnFSce+inGgbTJ0Cwxg7VhbM9xfvgM3qmVnO?=
 =?us-ascii?Q?TjG+j6dle1k6FIArVo5eX2inpvcrvQrudRTi81JQHW45r6ucwLH1zKIfxOwV?=
 =?us-ascii?Q?Yh7IG8slFsbRE5wKwuIuDFECo6S2C3wZRHLlw+Ccg7zLlB4L/fpjVeCAj+hG?=
 =?us-ascii?Q?6uziBxwsa5Jfv6ZubLw4//ouAW3gBXqa/2hrAXuuXn+i8h+1sdCJn3ItF9BM?=
 =?us-ascii?Q?rPBZQlKrBIbBjnM2WLnoGwdvAsjcGOsKLN9QvGbRZwIErpJ6sz2VkodY6ZaX?=
 =?us-ascii?Q?8VYVYGOO05XfVIRae/8edNsKrOE6gcy1GX5pi8kfsHMQqmWQbryPRVMHmtIE?=
 =?us-ascii?Q?V9/yK7BJSdtSP+6CHcoB/7bYfgUjB6NWRI+KXC7bQmma+EfgUUCPHScmi63v?=
 =?us-ascii?Q?TchJsfkAKlPj2rlLHRRRVRxCr9Z+yEmqH7Bkbe/y8l4fb1UGIH7JKYVnMygD?=
 =?us-ascii?Q?1299xEIdJV8F0oq6KhTLPpEJHzp5gWnVnjVHZpz5xGsDwqGYGttlrCdDpOQG?=
 =?us-ascii?Q?kHWSG0/b1E8CtYf9yo9DwXMVLU63vxYd003J3zzGb9IganXabJWQ91TdNdet?=
 =?us-ascii?Q?wQ8ftupa2SpKUhYwQH1Oh9ryXPcFWnHf78a4WvagqTYnLecGqpefc8DohCJX?=
 =?us-ascii?Q?Kdam7Vg4ESB8gQ7KnOsDrLho0bumhHSDCgJg8xBZ0Qw+atm6MyIUwFrcVjny?=
 =?us-ascii?Q?D62z1MoIFP/UvPIfevnxBeBrSftXjJXSy4sN25w3qB1SpdfcOkNT1plKlPxf?=
 =?us-ascii?Q?ViOQiiAFMf8nBQ7cVH44OaLHf9TvRrk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5c7176-ed74-4b28-77df-08d9fc5778cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 14:18:06.7315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zPDdRuhxc0voCxWIgfcPPjASeI68sk4ldJXjDkDp4+r7SMHflHUNkfwTbt6XGZ+NQ8qJYyRKyUyLR8r7gkmolyvCmUR5guJameaE3eJP4uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8203
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
