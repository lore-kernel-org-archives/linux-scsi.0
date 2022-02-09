Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B327AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 09:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiBIJHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 04:07:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiBIJHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 04:07:04 -0500
X-Greylist: delayed 277 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 01:07:00 PST
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFE4E019D3E
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 01:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644397620; x=1675933620;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=hYYthlBb0+zGU5lrvvRjJ6L2zdem/nDUC/DgZymEKpYlSpLW69xkBh9G
   IRHIw1Ae6q99nOebgN6xq5hQ+CrvOfPw1I5+JEAN1l0PEiXPaCPSe9fXR
   klylLpa5/uf4YpVBjehFwzjSbzHm9mXCnadyh6wyw+WrM0/MO2Eb4s5tB
   QMJ29FTm9CEdBFS3CbRUytlFT5P5+veBk1glJa3UPsiZP9rW+HmmxN9nP
   Sg6k0YbevE+ExVZrDQBkJptSp+x3P0XjqFU0SdCaY15ZqeO6o1nxEV7Gw
   fNsqs6TFhHEdsIX27zEIFyaD8Kbme2Jj6tvu8SVbM8TmrepGoRTkc34bd
   g==;
X-IronPort-AV: E=Sophos;i="5.88,355,1635177600"; 
   d="scan'208";a="193474076"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 16:55:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UD4CN4hCZ7mdhEhkR5jDZLhkVL2CZZ4/htD6z0nJXyR8UNTt7h5I+SIZXhlIumg9/I2NfkqTBtXuDUsTBch38SfFbGtw/PW8BfGxDYcXxPfmU11kiCxwC4YxzD3o2xiD6Z2vHYsjhgKPXc0+Uh3wLmGO7h5GshpEk1XO25ZmMFpYMNJt7x0qXTBYzNxZ8ulwBDRmIwGCkwl6fFwYBneqFwJnnMyktIjW4w2TsOfknFL5R6//04iVx7WoxZe0Wb5JrZiojKVe6/538YkD+25Dq0JFxiADB6nLlQ3v2ZuvaGqpqyQyF4epaqaOu8rw0STts4mlRj/SgG1ps+n8SbyEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Aab59BFsZ/cknlvC57KlxmtUxzykwnCNet8lgD9xlK1jAERyvugoSu+sVKwFf5zcmJdUxSiojFrwu0xqN3jGM45E7VxUyOpDWYqQNtnqTzbYZT9iDlp0Mq72o4K/yqijSLcnbodmcOMaMRNY0MViltARIlBL8AJG4zytEzWgXNYyHT2iqI9njHYP8horVMk5UiVxyRVFBbz/4RlWpz+kHYRam0E0/Qbobh7olLtFSVD8FgWvv3Kx3VIT9BaBqujsduJUwJsRllSSsBdgkl228b81mPAXmhcbWgDFV+wMkUlnbXwmtxvPkdj0y5wjRXXTqyrUCxGDaG60gWEDgd/kwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=UMrWM4AAM7MF8FrQ7rUlNQ9JYT8+3mk5PR7KsrvbSQirLuWyOG54urSxmoUjBei0FNtn1ln4cyfeTSknnk9Me+c0qjwCSv0uk0Qhp4gy18Xq53ovCCsf1yIYQlBKSyko4Ko3NrJLKtql7elBaCICffL67HHh7+xvRzChH/aeTTU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB4517.namprd04.prod.outlook.com (2603:10b6:a03:5a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 08:55:19 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 08:55:19 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 03/44] scsi: Remove drivers/scsi/scsi.h
Thread-Topic: [PATCH v2 03/44] scsi: Remove drivers/scsi/scsi.h
Thread-Index: AQHYHRDxweWjkHO+40KFbiDmOz+E3Q==
Date:   Wed, 9 Feb 2022 08:55:19 +0000
Message-ID: <PH0PR04MB74165D4E1AF7737077DE58329B2E9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cc2f86e-22a9-4d96-bd1e-08d9eba9e62b
x-ms-traffictypediagnostic: BYAPR04MB4517:EE_
x-microsoft-antispam-prvs: <BYAPR04MB451754101C69ACAA88C26C8E9B2E9@BYAPR04MB4517.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f2/zOltqe8/qhT1cH94JPTcwODsc09XcHIW3awQyG6BtO8YhmtUj9Lvxwld6Rg+fAYHew93dksByJZaBOAWcg7f60iTk9128Cmj/X794HpC2GhyxZy/PYH2LxtukMQL7+eEmIN8L8TcGy+akgNCSFjv81OaLUxzDumZzwnfplVNIjIMUgXPEgV+qH8D7pGtXhuCRMvlkQ9npYJMuaxVoYonhEkTMmMNTGSGjdcioA0JcswawmUyJtMsi4yKcL2+aDR6FMiBF47hjB/iACtIKalciKs54ZOd2gVNUhv4tOcXp88CrFcVfvklv8Y9yIoGq6fsaZADcamdftMyduoBJQO0SmOZOvw8F2wyONIDDPumeyrf3PP/ID/MjzO5pGQx1ibWW+fRFK5A6jSJf2/rLh4CyLeEDaYX9C+QjwsC9Skohmn/klQTtMWoTDEUw9WlYdZ+Fd+oPtvGxwcWKUc/H0dWxMj4sNpOAoNGij8lMEBwJIKAiSLjx0rO3yTqXZSr5OzyiIP0gHgCNoCp0fwhgFMw3a+HuuF+IRd7E/BE1KWxX62WwmvgCtmD1cKNqBQmEP4iNUtOCLVN7IUCDn2tIokxHj428kbsKYf3pW0Lkp8ijCm7SuHIK3hTuholUBEiBzIBw/j7GbpExhKV8+VAgzes5KuiwzLwQh0UyUhIXD4nPqjqLQAbfKDFHXGJrvBGKFqFkh6BwtLJq24uCn0ZPWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(91956017)(82960400001)(55016003)(508600001)(66556008)(86362001)(316002)(122000001)(110136005)(76116006)(71200400001)(6506007)(8936002)(7696005)(9686003)(8676002)(38100700002)(4326008)(19618925003)(54906003)(2906002)(558084003)(33656002)(186003)(64756008)(7416002)(52536014)(5660300002)(66476007)(4270600006)(66946007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IODWV7Q88vSUFUOf/mmJLxpDdErOj5tvxwYiahgmgWBDP6YXR883MCyn6hfN?=
 =?us-ascii?Q?bLrYATBo4twjQFm4w827Kv1aab6a5nco0WzjPjkHaUiuHSx8QPQCXm2HfdF9?=
 =?us-ascii?Q?ofwebijnuhBxEccwcmb2aOgiGmhjLyQ1LHoA26SpoPe+28p4w8csp+wqAzJn?=
 =?us-ascii?Q?JYMgxgYTiQ49YGIXHcyDQzo0c0sgYl0W/lEAWx43PxJCA2LxH2gXPIL+B2A7?=
 =?us-ascii?Q?dIiP2cLvpE4MX9kHP/vfirBUup9SZ7+Sp9p6xSWVXH5Smf1XrswhMySb31UD?=
 =?us-ascii?Q?WvRGnRA6yvRrEkAKpnNDK+ijcgQFWX9/h4FuExVj9j1ijAS8hod4Q9KGGecX?=
 =?us-ascii?Q?DVV1lwjEkp3bpk2EkGnRMnBAaQSUmleMZTzL+4VOPHwDDasCbrJAa9gSvAcI?=
 =?us-ascii?Q?R/9cbLKm14Hh6bw+cT7GQwUwgtNa4RP+qLJtM6O2jzxyRXRFsb3tVbKf1cvQ?=
 =?us-ascii?Q?7GvfCbCSEYvD4XgfylXk+poPMdfKCEIvF84bcNLwsTYDctPP/of4eAD32x2t?=
 =?us-ascii?Q?V7CwXxPy78tOUjx4eMASx7/3RSOPs4gKgaE2IXtVKdbDOpjwKXF+ZyIpBLbp?=
 =?us-ascii?Q?7Vdn2IfbHZWfGBXkL6RNL03UfEzeT4mWPp/pK6bf1HXHiPComW4oowp4svlu?=
 =?us-ascii?Q?sLhE2BdIyHpRNl+v+s2sknqRd4IpcGdYBJYHdo5rXlWeW3kTfKik3a2gVGdd?=
 =?us-ascii?Q?/sD9HHMCcIL3jf98cbH2U6JqszfMDbNJjExuPUgS4MBxV6cetvcDG1lHpfjX?=
 =?us-ascii?Q?KelGiXZL2T/ESbHO/dG4/anYWF5P7cSByHVUEnhMVf8m8011i3y+LNhHn3qf?=
 =?us-ascii?Q?XFRXttbILNRNU9J6IAsmMuYf0IdlHbKsoTwBhmjJJhRlNFIHPiBr/FOYVTh3?=
 =?us-ascii?Q?Hieoujvg8EmPKzheEQ6C7h9gkI3xvkzGcx926Nprna0y5RUXn2HR0QgL83/Q?=
 =?us-ascii?Q?9a2V7qr+SprwwarJTQMHU0d41bpTb1gu4tMmof5N7mjLcvHygV1nIBsVMwSz?=
 =?us-ascii?Q?GYf7aHwkQzj4QU9YFc7xzi3oc4xscfT/aHbN3wLqWVUjzVdae4my6VfyNlXk?=
 =?us-ascii?Q?bIR/kiAcIi6RbYopSAEgCkEy2hjsiToPXCMxew7rG6cpgHzc1xbtxh+Pj/51?=
 =?us-ascii?Q?+qU3l7PEUGpTGr1kxcpe1vmD4ha1Xg5L/N+kafrolZja764yUOHkbuZG45F9?=
 =?us-ascii?Q?LcCXrHB5Vey0wbYN6eUbVWZ97wcPqIz8k8y8mBWNN2VXV/x2dwMXQB2JL19Q?=
 =?us-ascii?Q?xtMdzfltGvA3dStUm8g12QyKOsV2J7VMyWkPzWG3BETLqiEK12RlP4SAzj5+?=
 =?us-ascii?Q?GkeCcoULpUUBrszOLzQptlHp/fHpCbWxTE3Iiu904VDnX45AymgJEmYNUTMf?=
 =?us-ascii?Q?FqTKGi+u083Fkv7FyVQUua63Dm2q8hr852usZLJ/MP1dLrXAYqeDu7qidDfb?=
 =?us-ascii?Q?tn+Fa1T3U4E4N24RQAR1Fk/sWlU2K5ilD5Qt2cCM1cOWXL1A1pxNJ/If6nI4?=
 =?us-ascii?Q?VQ76RcUME5mM2YCUjOnrd2cu+lAfIWVMGDvM2mtX7hGKR8qFYhZXjkhDW57B?=
 =?us-ascii?Q?CbHSlasFGYz3Q0+Lwyrz8ZyI2zR+wLIlRCIr0ww6LHnpyz5YbYqIqsSoKX8G?=
 =?us-ascii?Q?MD0eJSUCbUj76oadMHodoLLbmhkPoLD/K55D6M0e3DbakJRiXq6LQd3iYC/F?=
 =?us-ascii?Q?9wD5lKlyjPe8C2Pv5Z6F6jQjHHjMkSAno4Go2Uw6ex7LF+B1gsZf839bebiu?=
 =?us-ascii?Q?X3y7YxlrVhBq0aGJD9FilEeNlq7DTB4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc2f86e-22a9-4d96-bd1e-08d9eba9e62b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:55:19.1700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: COnCr4+bCPKOuWtxG2IO6BHAh9gLc6e/4pa5Wm2DZPFaRyONmO2ie4nCYqyGBSDsYSlIfVbiqo+NpjE/WJSfOJXCAU6ipySrdlZV4aL7BQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4517
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
