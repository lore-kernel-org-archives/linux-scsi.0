Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C698C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 15:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbiBQPNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 10:13:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbiBQPNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 10:13:47 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 07:13:28 PST
Received: from smarthost3.atos.net (smtppost.atos.net [193.56.114.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E9C2A228B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 07:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=atos.net; i=@atos.net; q=dns/txt; s=mail;
  t=1645110808; x=1676646808;
  h=from:to:subject:date:message-id:mime-version;
  bh=3bn2Bl84KiztvDFkISS3U/4kcPTtVmx7wHgaUoFOMQY=;
  b=9JPS6eyOybYmaAhjQAS9ixIkLOoeePLgp/rAPLfw0c/L2mCwIuhwAiRE
   k90nTl4QqMiZ9lp3eiCXHQ6vbLJSQugIW7xfuvSNQKsP9CbyViogrHEZ4
   v6PoO1LoJBcuiXA98VR+U344UnvQk9lDDtL4F8atLyayYjGy4urx/mU39
   4=;
X-IronPort-AV: E=Sophos;i="5.88,376,1635199200"; 
   d="txt'?p7s'?scan'208";a="314953703"
X-MGA-submission: =?us-ascii?q?MDHxj72RbJSkI184bdJVZWVFOTxc5x7yZggyjC?=
 =?us-ascii?q?vnKyELm11ePhIwEk/ikZkgSmTH5QN8HOAjHCfEIu20T96z8FEqh5joYz?=
 =?us-ascii?q?bC4SX6i5o4GFzX/SI4m9xOmMDqYBFCLCNACM6Y4WPPqX98JACdn82gj/?=
 =?us-ascii?q?RV?=
Received: from mail.sis.atos.net (HELO GITEXCPRDMB21.ww931.my-it-solutions.net) ([10.89.29.131])
  by smarthost3.atos.net with ESMTP/TLS/AES256-GCM-SHA384; 17 Feb 2022 16:12:21 +0100
Received: from GITEXCPRDMB21.ww931.my-it-solutions.net (10.89.29.131) by
 GITEXCPRDMB21.ww931.my-it-solutions.net (10.89.29.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Thu, 17 Feb 2022 16:12:21 +0100
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (172.16.214.171)
 by GITEXCPRDMB21.ww931.my-it-solutions.net (10.89.29.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18 via Frontend Transport; Thu, 17 Feb 2022 16:12:21 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMEbgvOSjBX+h2DHQUT7G7Zmv9MdaMp39inr44X3Al03rKqIzC9fRu450T/iyLrntpGLlzbLMIct2Xp5mBvUa1VkbftjeME320BgN5rKaIDKf8E4P8P7RnPCB6VsmbOwi82Jc0y2iyqlOap+A7xk/0dpK39SJbbKzb6F0qWfe55jcSsCWyLaQOAl7YF1XBv5SucKoMJKkbO952oPKhYQ8uXlOipF9pDJ0uUQWs+vY0k+tkZYzrQ1II0GgqA/kY/shs5Y8cmUDlPoPsLhaTNZEe9lRTWdYDn9afbVpNcT7b5p+suAgBTmaG/2EJn5darvW4TTy903Oavcwu8tRgqgrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QaeMk4wNhT54KeyNPyzxGgXHdnR/A+8WjeNhY34e994=;
 b=k/obyHTi3h9P36I/GsTdNkSHYYXoR1JlPSc70GVg3Sg71qZSEHXD/izlKAYnZ2lP7VfMnGDgqRzhv7/webNNi2kJBb1ploWuKCH+l+rR1Ogx53iFpBjUNFAfCwJVV6peqy07+Zfyr1oPWnmdihqnTxByZFGimgBn4jZCOq/wEgW8jPttd1//cSWITkHNz4m0TD329VmX0/C/PFv2V4JHcB6v+PvNJLhF0PFdfGbSRcumDXpJnZLS8TFMDpemPDGCGY7Hr0xC1sUjHfKT2sVdeOnA9D8JifeJAxMHdaSw/1rkpaGR/x8HbqGscY3c0CWc/pz5TJLi5p9IRsxVktX45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atos.net; dmarc=pass action=none header.from=atos.net;
 dkim=pass header.d=atos.net; arc=none
Received: from AM4PR02MB3204.eurprd02.prod.outlook.com (2603:10a6:205:11::21)
 by AM0PR02MB5011.eurprd02.prod.outlook.com (2603:10a6:208:fe::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 17 Feb
 2022 15:12:19 +0000
Received: from AM4PR02MB3204.eurprd02.prod.outlook.com
 ([fe80::fdbc:14ba:b032:2fda]) by AM4PR02MB3204.eurprd02.prod.outlook.com
 ([fe80::fdbc:14ba:b032:2fda%4]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 15:12:19 +0000
From:   "GIRAUDEAU-BOCQUET, LIONEL" <lionel.giraudeau@atos.net>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [aacraid] 60s timeout at boot time
Thread-Topic: [aacraid] 60s timeout at boot time
Thread-Index: Adgj56Ujlr6LlFYmQ5ywwNUw99xoDQ==
Date:   Thu, 17 Feb 2022 15:12:19 +0000
Message-ID: <AM4PR02MB3204526E714964A140F7098CFC369@AM4PR02MB3204.eurprd02.prod.outlook.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_ActionId=f9da26b7-f7f8-48fd-97ab-3fb081d43689;MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_ContentBits=0;MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_Enabled=true;MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_Method=Standard;MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_Name=All
 Employees_2;MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_SetDate=2022-02-17T10:17:35Z;MSIP_Label_e463cba9-5f6c-478d-9329-7b2295e4e8ed_SiteId=33440fc6-b7c7-412c-bb73-0e70b0198d5a;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cad3d680-fa8d-4294-cd54-08d9f227e40f
x-ms-traffictypediagnostic: AM0PR02MB5011:EE_
x-microsoft-antispam-prvs: <AM0PR02MB501159846494CBC8E86D72F0FC369@AM0PR02MB5011.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2fYecEWxzdTioiXoXulQxVXXM0sAP7FMsOqP38vZUzW6+HMl1tp7K/4xB8LZqu5YHWELLEPbisR+lIN4pDK4FC1RwXRlErN46tBRfr1zsXs176tDKo4Hdc60M1SEyHa4euevL3Gg/HQZC6hGff6Od94eIHd8eXqEumNY3vECg4wn+5Nv9Xh6j9/t6PiuI/EDzwxs4ZJMIrrLLuRCfhDhaWz+zC78g5nKbgePuUcfHH+/8oxc1ZEUFw4wNSceX76xvPKybY2go2pQAX6jFfkM+Ik/QfISquq9UH6Y+aZ2dAXeAC3gJh8laMPbE7BvkMc6asWEKnwLQsz5vgVIgHjr83SN4gAgUQqcr1HznV64e5UoK5EjFZljgAYhHeeAdCc2C4KfslO59WCsXiZ7wbIKzlMnowvymg4DgZtU6Y7inWbMa1eD7TE/CSt5eiHowuhbxum/HW3Lu9DUIUDib+BMJwZIbyraIIxjN7r0e4ZRiNdA/oWSp/cJ/gCAvA0evbLLPVGClX2Mu0BY9ksY2eXa9hPE1tCcrPrmhqcF+tmHvopAMpbQREi3zE890hbDaau9fDiF72kAc48eqlEUDyXJI7kBDYDHTV5YuBMKIMXsV/kYkWNd/0G8LQBgk7pYLtwCm7t/SQHOrZsdM4HVut/RB7+meaOYHK8JIez4CTYgkYl8RJOlmXO266LBYZ+CUV9ZH/K2sayFmM82GrJnqI0q2osd1riXKUwPdc1rTPPNOVqB9H+wSQsB+WUYv7GBtMS5MexBez3qW3Dumv0BNKqad9x40AVatUcxUuBliuKszKc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR02MB3204.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66946007)(6916009)(76116006)(66446008)(66476007)(64756008)(66556008)(33656002)(9686003)(55016003)(71200400001)(86362001)(83380400001)(186003)(6506007)(7696005)(2906002)(38070700005)(82960400001)(5660300002)(8936002)(966005)(508600001)(52536014)(99936003)(122000001)(8676002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vUMB+q6zJO4VYGJ5m0/M4ZASYnW4TJhf3D0SicRKKL+Pm/jSCwSNGIMiSqkA?=
 =?us-ascii?Q?WzuxVVjKla3iPgeZFpUqweKEEXfKtSv8quVHbgpCq1FGFqUC3xvDONDNLlRX?=
 =?us-ascii?Q?DksRQ4Misol/8izaPLBa+8Le026YWOAbxMH986EBnWcmPXKnlQzFDyU2mDN8?=
 =?us-ascii?Q?s6PFDLTSTUg0x47rA/j/azdA3hX8yII97f7oBXlOTC3RxVX9iX182hfzAnWI?=
 =?us-ascii?Q?tnIn5cFmS5i+70Xskn2rgbbEXds9YyguIp9H23UqVc594OzGx+nx8Mi3jHWR?=
 =?us-ascii?Q?FlRwtfWtOP7CB8RSz3Wo2G59RJ6MPyV/gd8rCHJhLh+Ia5KdqGML5GQ+tD/T?=
 =?us-ascii?Q?JBSgzMuyVXjMZLoCFp+hQyiMtMfhgbAv1FFWmzEsf67m+tcBb2QLcbGVYChE?=
 =?us-ascii?Q?IOQi13nVxF+zJQLG8Fj5IAnYrh9rjMd6M+d11QAD5Plz19l+pM71ewOhmsAx?=
 =?us-ascii?Q?KgvLgnmxvXAr1bodCLvP58r3vgxSX9lVmoyEhNvpyFJa/fTMbrkKKVwM9UYf?=
 =?us-ascii?Q?jYdW78/QXMfBAZa88lBXYId0cIhflzdjV5rSOnbomo+x4ukaus0lxWjFgd4I?=
 =?us-ascii?Q?aElpBZEq+0Lj0pzpv0kRlvhjb3cVvPlg6hBAEzXoXfToNU2Oi0X0EFbuQBy7?=
 =?us-ascii?Q?aEzR43b2ecsSVV8+BCwhJi8+aMUdqVnwngg4IXOupTQHt2ffk7BTz7/1b9wH?=
 =?us-ascii?Q?SD+3dwWcGZbZSwOxH5ML6wUKgXatnKm3TuA+j36QHL4T9r+OhTZYVvFgG8kT?=
 =?us-ascii?Q?VJISgXb+oii0eVccKZSIAZDMkpW9ROE9AHZQvzHCrYBbfoMyc0u3TLN4xLfg?=
 =?us-ascii?Q?7G5mG2J8WDvsATta5eRNkboeADo8UbMJCMXjDionIo/s99ONrhn1F3tBi8tc?=
 =?us-ascii?Q?tV/TFnF7jyyICDXJpy5bjKC8Md8xePmWIbBfeF5MzheDPFGqKZs3aqlGbmiU?=
 =?us-ascii?Q?y82+3JYCVbXN4eeXQVCvpFUuIcsuStNGVwWal9ZmBTWQ9OYk/UHGvyBWyMqV?=
 =?us-ascii?Q?rHp6uhl6dwUdHONj6wVeAJ+BJDRMVDgiCwqqWDVxO68esocGoJAtcGSQaK8Z?=
 =?us-ascii?Q?RzUqWgtZgA9QmOODaBY/ZlgWFzvXGSW0m8uuksZAdS3M5/gHLeoSmBxJfhsX?=
 =?us-ascii?Q?ZV8X01X8ThU8lZBujh1jerNZLPdhMhQxV2KswOOslYiuh824wWXl+7MGc1tG?=
 =?us-ascii?Q?SJI35gjar7M+s5z637Oy/zyNcBkWUibRt+zTJ/mQx9SEmYqngGIscca7YLo3?=
 =?us-ascii?Q?ZhBi5e81uLCtU9YrEviXogT4FGNmxN1sZHdq5A3VpsbjLNE/pETqMZIJatja?=
 =?us-ascii?Q?+tgRcgDbzEFYS5tFHQgq6nPjlS7g2f9ONCMQS3xAIjBck/TXkDYzuHrIBJGh?=
 =?us-ascii?Q?BOg9fzMv7QIDGt+XSL4mPWhWy0+VWNfrPptex64dWmEwvHmjLIGK2imu46f4?=
 =?us-ascii?Q?ReyUVZFxRcnVCjCg8OQkRaDhR30YiIVXya8dB+TPXVFqO1PLmwn/MghkykDM?=
 =?us-ascii?Q?TCNgHoiPUX2bMhUrhXdnOhs4zp8Ze0E3hxBVLGlkmrftRHEfMbg6v9CcC/ay?=
 =?us-ascii?Q?k7fimPFxDgt+zvm8ckay5KtqMshMMjUvN+Oamt/mhbqXO1wqiSZ8Py4FAkTz?=
 =?us-ascii?Q?yUv6j8O3qEgJbsW5O0dz+0aMo2lsFDUcCqxxY8aokkrCrI0krWaAt2w9nnCw?=
 =?us-ascii?Q?4ybc1sUFMb4w8fV7Mm+iGWz87d8148aMvqlcFOs4aQOnZQOIn09bck7COUGV?=
 =?us-ascii?Q?3z8qniOUxA=3D=3D?=
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=2.16.840.1.101.3.4.2.1;
        boundary="----=_NextPart_000_0006_01D82419.20CC1E60"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR02MB3204.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad3d680-fa8d-4294-cd54-08d9f227e40f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 15:12:19.1960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 33440fc6-b7c7-412c-bb73-0e70b0198d5a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RfR+uQQpG1nJtaOA3JMSL1jj/BHoMUt29UXK7tD03j3PfLlNoW1tF92wkJY7uUt31EaMax52kWuGxn0gFxddKFs0ymDxDAtRT4C5LaoIWx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB5011
X-OriginatorOrg: atos.net
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

------=_NextPart_000_0006_01D82419.20CC1E60
Content-Type: multipart/mixed;
	boundary="----=_NextPart_001_0007_01D82419.20CC1E60"


------=_NextPart_001_0007_01D82419.20CC1E60
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi there,

Sorry if I am not writing to the right list/person/etc.
I just grabbed the email address at
https://www.kernel.org/doc/html/latest/scsi/aacraid.html

Here is the problem :
I have a server with an Adaptec 5805 SAS/SATA controller.
It was running well under Devuan 3 (Linux version 4.19.0-17-amd64
(mailto:debian-kernel@lists.debian.org)).
I upgraded to Devuan 4 (Linux version 5.10.0-11-amd64
(mailto:debian-kernel@lists.debian.org)) and the problem appeared.
Well it is a small problem because it is only happening at boot time
(dmesg.txt included).

After 6 or 7 seconds, the kernel tries to mount root and give up :
-------------------------------------------------
...
[    6.525212] Adaptec aacraid driver 1.2.1[50983]-custom
[    6.530560] aacraid 0000:84:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    6.538504] aacraid: Comm Interface enabled
...
[    6.832965] scsi host5: ahci
[    6.840919] random: fast init done
...
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
[   36.107674] scsi 0:3:1:0: Enclosure         ADAPTEC  Virtual SGPIO  1
0001 PQ: 0 ANSI: 5
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
Begin: Running /scripts/local-block ... done.
done.
Gave up waiting for suspend/resume device
done.
Begin: Waiting for root file system ... Begin: Running /scripts/local-block
... done.
done.
Gave up waiting for root file system device.  Common problems:
 - Boot args (cat /proc/cmdline)
   - Check rootdelay= (did the system wait long enough?)
 - Missing modules (cat /proc/modules; ls /dev)
ALERT!  UUID=b2a4b397-1c2c-4f9f-8f2c-06e7db328a0c does not exist.  Dropping
to a shell!


BusyBox v1.30.1 (Debian 1:1.30.1-6+b3) built-in shell (ash)
Enter 'help' for a list of built-in commands.

-------------------------------------------------

At this time I just have to wait for the following messages :

(initramfs) [   65.163347] ses 0:3:0:0: Attached Enclosure device
[   65.168240] ses 0:3:1:0: Attached Enclosure device
[   65.215668] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[   65.221384] ses 0:3:0:0: Attached scsi generic sg1 type 13
[   65.227084] ses 0:3:1:0: Attached scsi generic sg2 type 13
[   65.227216] sd 0:0:0:0: [sda] 975153152 512-byte logical blocks: (499
GB/465 GiB)
[   65.240256] sd 0:0:0:0: [sda] Write Protect is off
[   65.245147] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled,
supports DPO and FUA
[   65.310353]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[   65.330542] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   65.469563] ata4: SATA link down (SStatus 0 SControl 300)
[   65.789599] ata5: SATA link down (SStatus 0 SControl 300)
[   66.109825] ata6: SATA link down (SStatus 0 SControl 300)
[   66.429838] ata7: SATA link down (SStatus 0 SControl 300)
[   66.749821] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   66.760943] ata8.00: ATAPI: TEAC    DV-W28S-V, 1.0A, max UDMA/100
[   66.772859] ata8.00: configured for UDMA/100
[   66.782398] scsi 8:0:0:0: CD-ROM            TEAC     DV-W28S-V
1.0A PQ: 0 ANSI: 5
[   66.820588] scsi 8:0:0:0: Attached scsi generic sg3 type 5
[   66.857354] sr 8:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram
cd/rw xa/form2 cdda tray
[   66.866116] cdrom: Uniform CD-ROM driver Revision: 3.20

-------------------------------------------------

And then, resume the boot process :

-------------------------------------------------
(initramfs) exit
Begin: Will now check root file system ... fsck from util-linux 2.36.1
[/sbin/fsck.ext4 (1) -- /dev/sda1] fsck.ext4 -a -C0 /dev/sda1
/dev/sda1: clean, 40277/1525920 files, 463661/6103296 blocks
done.
[  192.728216] EXT4-fs (sda1): mounted filesystem with ordered data mode.
Opts: (null)
done.
Begin: Running /scripts/local-bottom ... done.
...
-------------------------------------------------

It finishes to boot and the server is working properly.

So, the problem here is the controller taking to much time (seems like a 60s
timeout to me) to be ready,
which is certainly related to aacraid module because there is absolutely no
problem if I boot with the 4.19.0 version.

An easy workaround to that would be to tell the kernel to wait a little bit
longer but this is not a proper solution.
Do you have one ? Is there a secret option to aacraid that I have missed ?
Or, as I just realised when I read the first line :
Adaptec aacraid driver 1.2.1[50983]-custom
this "custom" keyword is a hint that I must ask this question on a Debian
mailing list, mustn't I ?

Cheers,
Lionel

------=_NextPart_001_0007_01D82419.20CC1E60
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

[    0.000000] Linux version 5.10.0-11-amd64 =
(debian-kernel@lists.debian.org) (gcc-10 (Debian 10.2.1-6) 10.2.1 =
20210110, GNU ld (GNU Binutils for Debian) 2.35.2) #1 SMP Debian =
5.10.92-1 (2022-01-18)=0A=
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.10.0-11-amd64 =
root=3DUUID=3Db2a4b397-1c2c-4f9f-8f2c-06e7db328a0c ro console=3Dtty0 =
console=3DttyS2,115200=0A=
[    0.000000] x86/fpu: x87 FPU will use FXSAVE=0A=
[    0.000000] BIOS-provided physical RAM map:=0A=
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093fff] =
usable=0A=
[    0.000000] BIOS-e820: [mem 0x0000000000094000-0x000000000009ffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf75ffff] =
usable=0A=
[    0.000000] BIOS-e820: [mem 0x00000000bf76e000-0x00000000bf76ffff] =
type 9=0A=
[    0.000000] BIOS-e820: [mem 0x00000000bf770000-0x00000000bf77dfff] =
ACPI data=0A=
[    0.000000] BIOS-e820: [mem 0x00000000bf77e000-0x00000000bf7cffff] =
ACPI NVS=0A=
[    0.000000] BIOS-e820: [mem 0x00000000bf7d0000-0x00000000bf7dffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000bf7ec000-0x00000000bfffffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] =
reserved=0A=
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000063fffffff] =
usable=0A=
[    0.000000] NX (Execute Disable) protection: active=0A=
[    0.000000] SMBIOS 2.6 present.=0A=
[    0.000000] DMI: Bull SAS bullx/X8DAH, BIOS 2.0a     09/03/10  =0A=
[    0.000000] tsc: Fast TSC calibration using PIT=0A=
[    0.000000] tsc: Detected 2667.003 MHz processor=0A=
[    0.006904] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> =
reserved=0A=
[    0.006907] e820: remove [mem 0x000a0000-0x000fffff] usable=0A=
[    0.006914] last_pfn =3D 0x640000 max_arch_pfn =3D 0x400000000=0A=
[    0.006918] MTRR default type: uncachable=0A=
[    0.006919] MTRR fixed ranges enabled:=0A=
[    0.006920]   00000-9FFFF write-back=0A=
[    0.006921]   A0000-DFFFF uncachable=0A=
[    0.006922]   E0000-E7FFF write-through=0A=
[    0.006923]   E8000-FFFFF write-protect=0A=
[    0.006924] MTRR variable ranges enabled:=0A=
[    0.006926]   0 base 0000000000 mask FC00000000 write-back=0A=
[    0.006927]   1 base 0400000000 mask FE00000000 write-back=0A=
[    0.006928]   2 base 0600000000 mask FFC0000000 write-back=0A=
[    0.006929]   3 base 00C0000000 mask FFC0000000 uncachable=0A=
[    0.006930]   4 base 00BF800000 mask FFFF800000 uncachable=0A=
[    0.006931]   5 disabled=0A=
[    0.006932]   6 disabled=0A=
[    0.006932]   7 disabled=0A=
[    0.006933]   8 disabled=0A=
[    0.006934]   9 disabled=0A=
[    0.008767] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- =
WT  =0A=
[    0.009381] e820: update [mem 0xbf800000-0xffffffff] usable =3D=3D> =
reserved=0A=
[    0.009390] last_pfn =3D 0xbf760 max_arch_pfn =3D 0x400000000=0A=
[    0.019140] found SMP MP-table at [mem 0x000ff780-0x000ff78f]=0A=
[    0.023531] Using GB pages for direct mapping=0A=
[    0.023823] RAMDISK: [mem 0x34a6f000-0x3652efff]=0A=
[    0.023827] ACPI: Early table checksum verification disabled=0A=
[    0.023832] ACPI: RSDP 0x00000000000FB190 000024 (v02 ACPIAM)=0A=
[    0.023837] ACPI: XSDT 0x00000000BF770100 00008C (v01 SMCI            =
20100903 MSFT 00000097)=0A=
[    0.023844] ACPI: FACP 0x00000000BF770290 0000F4 (v04 090310 FACP2317 =
20100903 MSFT 00000097)=0A=
[    0.023850] ACPI BIOS Warning (bug): 32/64X length mismatch in =
FADT/Gpe0Block: 128/64 (20200925/tbfadt-564)=0A=
[    0.023855] ACPI: DSDT 0x00000000BF7706F0 0078B8 (v02 10100  10100000 =
00000000 INTL 20051117)=0A=
[    0.023860] ACPI: FACS 0x00000000BF77E000 000040=0A=
[    0.023863] ACPI: FACS 0x00000000BF77E000 000040=0A=
[    0.023867] ACPI: APIC 0x00000000BF770390 000112 (v02 090310 APIC2317 =
20100903 MSFT 00000097)=0A=
[    0.023871] ACPI: MCFG 0x00000000BF7704B0 00003C (v01 090310 OEMMCFG  =
20100903 MSFT 00000097)=0A=
[    0.023876] ACPI: SLIT 0x00000000BF7704F0 000030 (v01 090310 OEMSLIT  =
20100903 MSFT 00000097)=0A=
[    0.023880] ACPI: SPMI 0x00000000BF770520 000041 (v05 090310 OEMSPMI  =
20100903 MSFT 00000097)=0A=
[    0.023884] ACPI: OEMB 0x00000000BF77E040 000099 (v01 090310 OEMB2317 =
20100903 MSFT 00000097)=0A=
[    0.023888] ACPI: SRAT 0x00000000BF77A6F0 000190 (v02 090310 OEMSRAT  =
00000001 INTL 00000001)=0A=
[    0.023892] ACPI: HPET 0x00000000BF77A880 000038 (v01 090310 OEMHPET  =
20100903 MSFT 00000097)=0A=
[    0.023896] ACPI: SSDT 0x00000000BF7812C0 000363 (v01 DpgPmm CpuPm    =
00000012 INTL 20051117)=0A=
[    0.023900] ACPI: EINJ 0x00000000BF77A8C0 000130 (v01 AMIER  AMI_EINJ =
20100903 MSFT 00000097)=0A=
[    0.023904] ACPI: BERT 0x00000000BF77AA50 000030 (v01 AMIER  AMI_BERT =
20100903 MSFT 00000097)=0A=
[    0.023909] ACPI: ERST 0x00000000BF77AA80 0001B0 (v01 AMIER  AMI_ERST =
20100903 MSFT 00000097)=0A=
[    0.023913] ACPI: HEST 0x00000000BF77AC30 0000A8 (v01 AMIER  ABC_HEST =
20100903 MSFT 00000097)=0A=
[    0.023916] ACPI: Reserving FACP table memory at [mem =
0xbf770290-0xbf770383]=0A=
[    0.023918] ACPI: Reserving DSDT table memory at [mem =
0xbf7706f0-0xbf777fa7]=0A=
[    0.023919] ACPI: Reserving FACS table memory at [mem =
0xbf77e000-0xbf77e03f]=0A=
[    0.023920] ACPI: Reserving FACS table memory at [mem =
0xbf77e000-0xbf77e03f]=0A=
[    0.023922] ACPI: Reserving APIC table memory at [mem =
0xbf770390-0xbf7704a1]=0A=
[    0.023923] ACPI: Reserving MCFG table memory at [mem =
0xbf7704b0-0xbf7704eb]=0A=
[    0.023924] ACPI: Reserving SLIT table memory at [mem =
0xbf7704f0-0xbf77051f]=0A=
[    0.023925] ACPI: Reserving SPMI table memory at [mem =
0xbf770520-0xbf770560]=0A=
[    0.023927] ACPI: Reserving OEMB table memory at [mem =
0xbf77e040-0xbf77e0d8]=0A=
[    0.023928] ACPI: Reserving SRAT table memory at [mem =
0xbf77a6f0-0xbf77a87f]=0A=
[    0.023930] ACPI: Reserving HPET table memory at [mem =
0xbf77a880-0xbf77a8b7]=0A=
[    0.023931] ACPI: Reserving SSDT table memory at [mem =
0xbf7812c0-0xbf781622]=0A=
[    0.023933] ACPI: Reserving EINJ table memory at [mem =
0xbf77a8c0-0xbf77a9ef]=0A=
[    0.023934] ACPI: Reserving BERT table memory at [mem =
0xbf77aa50-0xbf77aa7f]=0A=
[    0.023936] ACPI: Reserving ERST table memory at [mem =
0xbf77aa80-0xbf77ac2f]=0A=
[    0.023937] ACPI: Reserving HEST table memory at [mem =
0xbf77ac30-0xbf77acd7]=0A=
[    0.023949] ACPI: Local APIC address 0xfee00000=0A=
[    0.023974] SRAT: PXM 0 -> APIC 0x00 -> Node 0=0A=
[    0.023975] SRAT: PXM 0 -> APIC 0x02 -> Node 0=0A=
[    0.023977] SRAT: PXM 0 -> APIC 0x04 -> Node 0=0A=
[    0.023978] SRAT: PXM 0 -> APIC 0x10 -> Node 0=0A=
[    0.023979] SRAT: PXM 0 -> APIC 0x12 -> Node 0=0A=
[    0.023980] SRAT: PXM 0 -> APIC 0x14 -> Node 0=0A=
[    0.023982] SRAT: PXM 1 -> APIC 0x20 -> Node 1=0A=
[    0.023983] SRAT: PXM 1 -> APIC 0x22 -> Node 1=0A=
[    0.023984] SRAT: PXM 1 -> APIC 0x24 -> Node 1=0A=
[    0.023985] SRAT: PXM 1 -> APIC 0x30 -> Node 1=0A=
[    0.023986] SRAT: PXM 1 -> APIC 0x32 -> Node 1=0A=
[    0.023987] SRAT: PXM 1 -> APIC 0x34 -> Node 1=0A=
[    0.023991] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]=0A=
[    0.023993] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]=0A=
[    0.023994] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x33fffffff]=0A=
[    0.023996] ACPI: SRAT: Node 1 PXM 1 [mem 0x340000000-0x63fffffff]=0A=
[    0.024003] NUMA: Initialized distance table, cnt=3D2=0A=
[    0.024006] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem =
0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]=0A=
[    0.024008] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem =
0x100000000-0x33fffffff] -> [mem 0x00000000-0x33fffffff]=0A=
[    0.024020] NODE_DATA(0) allocated [mem 0x33ffd6000-0x33fffffff]=0A=
[    0.024041] NODE_DATA(1) allocated [mem 0x63ffd5000-0x63fffefff]=0A=
[    0.024450] Zone ranges:=0A=
[    0.024452]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]=0A=
[    0.024454]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]=0A=
[    0.024456]   Normal   [mem 0x0000000100000000-0x000000063fffffff]=0A=
[    0.024458]   Device   empty=0A=
[    0.024459] Movable zone start for each node=0A=
[    0.024463] Early memory node ranges=0A=
[    0.024464]   node   0: [mem 0x0000000000001000-0x0000000000093fff]=0A=
[    0.024466]   node   0: [mem 0x0000000000100000-0x00000000bf75ffff]=0A=
[    0.024468]   node   0: [mem 0x0000000100000000-0x000000033fffffff]=0A=
[    0.024470]   node   1: [mem 0x0000000340000000-0x000000063fffffff]=0A=
[    0.024475] Initmem setup node 0 [mem =
0x0000000000001000-0x000000033fffffff]=0A=
[    0.024477] On node 0 totalpages: 3143411=0A=
[    0.024478]   DMA zone: 64 pages used for memmap=0A=
[    0.024479]   DMA zone: 22 pages reserved=0A=
[    0.024480]   DMA zone: 3987 pages, LIFO batch:0=0A=
[    0.024481]   DMA32 zone: 12190 pages used for memmap=0A=
[    0.024482]   DMA32 zone: 780128 pages, LIFO batch:63=0A=
[    0.024483]   Normal zone: 36864 pages used for memmap=0A=
[    0.024483]   Normal zone: 2359296 pages, LIFO batch:63=0A=
[    0.024485] Initmem setup node 1 [mem =
0x0000000340000000-0x000000063fffffff]=0A=
[    0.024486] On node 1 totalpages: 3145728=0A=
[    0.024487]   Normal zone: 49152 pages used for memmap=0A=
[    0.024488]   Normal zone: 3145728 pages, LIFO batch:63=0A=
[    0.024494] On node 0, zone DMA: 1 pages in unavailable ranges=0A=
[    0.024545] On node 0, zone DMA: 108 pages in unavailable ranges=0A=
[    0.033658] On node 0, zone Normal: 2208 pages in unavailable ranges=0A=
[    0.034319] ACPI: PM-Timer IO Port: 0x808=0A=
[    0.034323] ACPI: Local APIC address 0xfee00000=0A=
[    0.034333] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])=0A=
[    0.034344] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI =
0-23=0A=
[    0.034347] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
[    0.034350] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high =
level)=0A=
[    0.034352] ACPI: IRQ0 used by override.=0A=
[    0.034353] ACPI: IRQ9 used by override.=0A=
[    0.034356] Using ACPI (MADT) for SMP configuration information=0A=
[    0.034358] ACPI: HPET id: 0x8086a301 base: 0xfed00000=0A=
[    0.034366] smpboot: Allowing 24 CPUs, 12 hotplug CPUs=0A=
[    0.034388] PM: hibernation: Registered nosave memory: [mem =
0x00000000-0x00000fff]=0A=
[    0.034391] PM: hibernation: Registered nosave memory: [mem =
0x00094000-0x0009ffff]=0A=
[    0.034392] PM: hibernation: Registered nosave memory: [mem =
0x000a0000-0x000e3fff]=0A=
[    0.034393] PM: hibernation: Registered nosave memory: [mem =
0x000e4000-0x000fffff]=0A=
[    0.034396] PM: hibernation: Registered nosave memory: [mem =
0xbf760000-0xbf76dfff]=0A=
[    0.034397] PM: hibernation: Registered nosave memory: [mem =
0xbf76e000-0xbf76ffff]=0A=
[    0.034398] PM: hibernation: Registered nosave memory: [mem =
0xbf770000-0xbf77dfff]=0A=
[    0.034400] PM: hibernation: Registered nosave memory: [mem =
0xbf77e000-0xbf7cffff]=0A=
[    0.034401] PM: hibernation: Registered nosave memory: [mem =
0xbf7d0000-0xbf7dffff]=0A=
[    0.034402] PM: hibernation: Registered nosave memory: [mem =
0xbf7e0000-0xbf7ebfff]=0A=
[    0.034404] PM: hibernation: Registered nosave memory: [mem =
0xbf7ec000-0xbfffffff]=0A=
[    0.034405] PM: hibernation: Registered nosave memory: [mem =
0xc0000000-0xdfffffff]=0A=
[    0.034406] PM: hibernation: Registered nosave memory: [mem =
0xe0000000-0xefffffff]=0A=
[    0.034407] PM: hibernation: Registered nosave memory: [mem =
0xf0000000-0xfedfffff]=0A=
[    0.034408] PM: hibernation: Registered nosave memory: [mem =
0xfee00000-0xfee00fff]=0A=
[    0.034409] PM: hibernation: Registered nosave memory: [mem =
0xfee01000-0xffbfffff]=0A=
[    0.034410] PM: hibernation: Registered nosave memory: [mem =
0xffc00000-0xffffffff]=0A=
[    0.034413] [mem 0xc0000000-0xdfffffff] available for PCI devices=0A=
[    0.034415] Booting paravirtualized kernel on bare hardware=0A=
[    0.034419] clocksource: refined-jiffies: mask: 0xffffffff =
max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns=0A=
[    0.039205] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:24 =
nr_cpu_ids:24 nr_node_ids:2=0A=
[    0.040593] percpu: Embedded 58 pages/cpu s200536 r8192 d28840 u262144=0A=
[    0.040605] pcpu-alloc: s200536 r8192 d28840 u262144 alloc=3D1*2097152=0A=
[    0.040607] pcpu-alloc: [0] 00 01 02 03 04 05 12 14 [0] 16 18 20 22 =
-- -- -- -- =0A=
[    0.040617] pcpu-alloc: [1] 06 07 08 09 10 11 13 15 [1] 17 19 21 23 =
-- -- -- -- =0A=
[    0.040667] Built 2 zonelists, mobility grouping on.  Total pages: =
6190847=0A=
[    0.040669] Policy zone: Normal=0A=
[    0.040671] Kernel command line: =
BOOT_IMAGE=3D/boot/vmlinuz-5.10.0-11-amd64 =
root=3DUUID=3Db2a4b397-1c2c-4f9f-8f2c-06e7db328a0c ro console=3Dtty0 =
console=3DttyS2,115200=0A=
[    0.040734] printk: log_buf_len individual max cpu contribution: 4096 =
bytes=0A=
[    0.040735] printk: log_buf_len total cpu_extra contributions: 94208 =
bytes=0A=
[    0.040736] printk: log_buf_len min size: 131072 bytes=0A=
[    0.040990] printk: log_buf_len: 262144 bytes=0A=
[    0.040991] printk: early log buf free: 119560(91%)=0A=
[    0.041281] mem auto-init: stack:off, heap alloc:on, heap free:off=0A=
[    0.067898] Memory: 3305328K/25156556K available (12295K kernel code, =
2545K rwdata, 7568K rodata, 2412K init, 3680K bss, 528628K reserved, 0K =
cma-reserved)=0A=
[    0.067912] random: get_random_u64 called from =
__kmem_cache_create+0x2a/0x4d0 with crng_init=3D0=0A=
[    0.068208] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, =
CPUs=3D24, Nodes=3D2=0A=
[    0.068229] Kernel/User page tables isolation: enabled=0A=
[    0.068262] ftrace: allocating 36444 entries in 143 pages=0A=
[    0.083963] ftrace: allocated 143 pages with 5 groups=0A=
[    0.084372] rcu: Hierarchical RCU implementation.=0A=
[    0.084374] rcu: 	RCU restricting CPUs from NR_CPUS=3D8192 to =
nr_cpu_ids=3D24.=0A=
[    0.084377] 	Rude variant of Tasks RCU enabled.=0A=
[    0.084378] 	Tracing variant of Tasks RCU enabled.=0A=
[    0.084379] rcu: RCU calculated value of scheduler-enlistment delay =
is 25 jiffies.=0A=
[    0.084381] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, =
nr_cpu_ids=3D24=0A=
[    0.089634] NR_IRQS: 524544, nr_irqs: 616, preallocated irqs: 16=0A=
[    0.094219] Console: colour VGA+ 80x25=0A=
[    0.104425] printk: console [tty0] enabled=0A=
[    1.125807] printk: console [ttyS2] enabled=0A=
[    1.130081] mempolicy: Enabling automatic NUMA balancing. Configure =
with numa_balancing=3D or the kernel.numa_balancing sysctl=0A=
[    1.141367] ACPI: Core revision 20200925=0A=
[    1.145435] clocksource: hpet: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 133484882848 ns=0A=
[    1.155762] APIC: Switch to symmetric I/O mode setup=0A=
[    1.160800] Switched APIC routing to physical flat.=0A=
[    1.166223] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 =
pin2=3D-1=0A=
[    1.191761] clocksource: tsc-early: mask: 0xffffffffffffffff =
max_cycles: 0x26717b65048, max_idle_ns: 440795334055 ns=0A=
[    1.202355] Calibrating delay loop (skipped), value calculated using =
timer frequency.. 5334.00 BogoMIPS (lpj=3D10668012)=0A=
[    1.206355] pid_max: default: 32768 minimum: 301=0A=
[    1.210408] LSM: Security Framework initializing=0A=
[    1.214367] Yama: disabled by default; enable with sysctl =
kernel.yama.*=0A=
[    1.218389] AppArmor: AppArmor initialized=0A=
[    1.222356] TOMOYO Linux initialized=0A=
[    1.235470] Dentry cache hash table entries: 4194304 (order: 13, =
33554432 bytes, vmalloc)=0A=
[    1.243119] Inode-cache hash table entries: 2097152 (order: 12, =
16777216 bytes, vmalloc)=0A=
[    1.246499] Mount-cache hash table entries: 65536 (order: 7, 524288 =
bytes, vmalloc)=0A=
[    1.250462] Mountpoint-cache hash table entries: 65536 (order: 7, =
524288 bytes, vmalloc)=0A=
[    1.254792] x86/cpu: VMX (outside TXT) disabled by BIOS=0A=
[    1.258372] mce: CPU0: Thermal monitoring enabled (TM1)=0A=
[    1.262363] process: using mwait in idle threads=0A=
[    1.266357] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7=0A=
[    1.270355] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0=0A=
[    1.274359] Spectre V1 : Mitigation: usercopy/swapgs barriers and =
__user pointer sanitization=0A=
[    1.278356] Spectre V2 : Mitigation: Full generic retpoline=0A=
[    1.282355] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling =
RSB on context switch=0A=
[    1.286355] Speculative Store Bypass: Vulnerable=0A=
[    1.290357] MDS: Vulnerable: Clear CPU buffers attempted, no microcode=0A=
[    1.294478] Freeing SMP alternatives memory: 32K=0A=
[    1.414915] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5650  @ =
2.67GHz (family: 0x6, model: 0x2c, stepping: 0x2)=0A=
[    1.418572] Performance Events: PEBS fmt1+, Westmere events, 16-deep =
LBR, Intel PMU driver.=0A=
[    1.422356] core: CPUID marked event: 'bus cycles' unavailable=0A=
[    1.426356] ... version:                3=0A=
[    1.430355] ... bit width:              48=0A=
[    1.434355] ... generic registers:      4=0A=
[    1.438355] ... value mask:             0000ffffffffffff=0A=
[    1.442355] ... max period:             000000007fffffff=0A=
[    1.446354] ... fixed-purpose events:   3=0A=
[    1.450354] ... event mask:             000000070000000f=0A=
[    1.454479] rcu: Hierarchical SRCU implementation.=0A=
[    1.463818] NMI watchdog: Enabled. Permanently consumes one hw-PMU =
counter.=0A=
[    1.466714] smp: Bringing up secondary CPUs ...=0A=
[    1.470493] x86: Booting SMP configuration:=0A=
[    1.474359] .... node  #0, CPUs:        #1  #2  #3  #4  #5=0A=
[    1.494358] .... node  #1, CPUs:    #6=0A=
[    1.084381] smpboot: CPU 6 Converting physical 0 to logical die 1=0A=
[    1.590490]   #7  #8  #9 #10 #11=0A=
[    1.604624] smp: Brought up 2 nodes, 12 CPUs=0A=
[    1.610357] smpboot: Max logical packages: 4=0A=
[    1.614356] smpboot: Total of 12 processors activated (64008.27 =
BogoMIPS)=0A=
[    1.638419] node 0 deferred pages initialised in 16ms=0A=
[    1.648587] node 1 deferred pages initialised in 24ms=0A=
[    1.654597] devtmpfs: initialized=0A=
[    1.657780] x86/mm: Memory block size: 128MB=0A=
[    1.660423] PM: Registering ACPI NVS region [mem =
0xbf77e000-0xbf7cffff] (335872 bytes)=0A=
[    1.662427] clocksource: jiffies: mask: 0xffffffff max_cycles: =
0xffffffff, max_idle_ns: 7645041785100000 ns=0A=
[    1.666460] futex hash table entries: 8192 (order: 7, 524288 bytes, =
vmalloc)=0A=
[    1.670480] pinctrl core: initialized pinctrl subsystem=0A=
[    1.674643] NET: Registered protocol family 16=0A=
[    1.678447] audit: initializing netlink subsys (disabled)=0A=
[    1.682367] audit: type=3D2000 audit(1644923691.512:1): =
state=3Dinitialized audit_enabled=3D0 res=3D1=0A=
[    1.682480] thermal_sys: Registered thermal governor 'fair_share'=0A=
[    1.686359] thermal_sys: Registered thermal governor 'bang_bang'=0A=
[    1.690355] thermal_sys: Registered thermal governor 'step_wise'=0A=
[    1.694355] thermal_sys: Registered thermal governor 'user_space'=0A=
[    1.698355] thermal_sys: Registered thermal governor 'power_allocator'=0A=
[    1.702378] cpuidle: using governor ladder=0A=
[    1.710387] cpuidle: using governor menu=0A=
[    1.714397] ACPI: bus type PCI registered=0A=
[    1.718357] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5=0A=
[    1.722459] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem =
0xe0000000-0xefffffff] (base 0xe0000000)=0A=
[    1.726358] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in =
E820=0A=
[    1.730364] pmd_set_huge: Cannot satisfy [mem 0xe0000000-0xe0200000] =
with a huge-page mapping due to MTRR override.=0A=
[    1.734892] PCI: Using configuration type 1 for base access=0A=
[    1.738870] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'=0A=
[    1.743225] Kprobes globally optimized=0A=
[    1.746394] HugeTLB registered 1.00 GiB page size, pre-allocated 0 =
pages=0A=
[    1.750357] HugeTLB registered 2.00 MiB page size, pre-allocated 0 =
pages=0A=
[    1.954749] ACPI: Added _OSI(Module Device)=0A=
[    1.958360] ACPI: Added _OSI(Processor Device)=0A=
[    1.962359] ACPI: Added _OSI(3.0 _SCP Extensions)=0A=
[    1.966355] ACPI: Added _OSI(Processor Aggregator Device)=0A=
[    1.970355] ACPI: Added _OSI(Linux-Dell-Video)=0A=
[    1.978355] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)=0A=
[    1.982355] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)=0A=
[    1.993085] ACPI: 2 ACPI AML tables successfully acquired and loaded=0A=
[    1.999751] ACPI: Dynamic OEM Table Load:=0A=
[    2.002366] ACPI: SSDT 0xFFFF974AF3DA8000 002A00 (v01 DpgPmm P001Ist  =
00000011 INTL 20051117)=0A=
[    2.015157] ACPI: Dynamic OEM Table Load:=0A=
[    2.018359] ACPI: SSDT 0xFFFF9745C20CD800 0007DD (v01 PmRef  P001Cst  =
00003001 INTL 20051117)=0A=
[    2.027285] ACPI: Interpreter enabled=0A=
[    2.030373] ACPI: (supports S0 S1 S4 S5)=0A=
[    2.034355] ACPI: Using IOAPIC for interrupt routing=0A=
[    2.038427] HEST: Table parsing has been initialized.=0A=
[    2.046357] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug=0A=
[    2.054634] ACPI: Enabled 12 GPEs in block 00 to 3F=0A=
[    2.069318] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])=0A=
[    2.074361] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM =
ClockPM Segments MSI HPX-Type3]=0A=
[    2.086360] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling =
ASPM=0A=
[    2.090491] acpi PNP0A08:00: host bridge window expanded to [io  =
0x0000-0xdfff]; [io  0x0000-0xdfff window] ignored=0A=
[    2.102358] acpi PNP0A08:00: ignoring host bridge window [mem =
0x000d0000-0x000dffff window] (conflicts with Adapter ROM [mem =
0x000ce800-0x000d4fff])=0A=
[    2.114556] PCI host bridge to bus 0000:00=0A=
[    2.118357] pci_bus 0000:00: root bus resource [io  0x0000-0xdfff]=0A=
[    2.126355] pci_bus 0000:00: root bus resource [io  0x0000-0x03af =
window]=0A=
[    2.134355] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 =
window]=0A=
[    2.138358] pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb =
window]=0A=
[    2.146355] pci_bus 0000:00: root bus resource [io  0x03c0-0x03df =
window]=0A=
[    2.154355] pci_bus 0000:00: root bus resource [io  0xf000-0xffff =
window]=0A=
[    2.158355] pci_bus 0000:00: root bus resource [mem =
0x000a0000-0x000bffff window]=0A=
[    2.166355] pci_bus 0000:00: root bus resource [mem =
0xf9000000-0xfbffffff window]=0A=
[    2.174356] pci_bus 0000:00: root bus resource [mem =
0xfed40000-0xfed44fff]=0A=
[    2.182359] pci_bus 0000:00: root bus resource [bus 00-7f]=0A=
[    2.186385] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000=0A=
[    2.194382] pci 0000:00:00.0: enabling Extended Tags=0A=
[    2.198394] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold=0A=
[    2.206461] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400=0A=
[    2.210380] pci 0000:00:01.0: enabling Extended Tags=0A=
[    2.214393] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold=0A=
[    2.222472] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400=0A=
[    2.230383] pci 0000:00:03.0: enabling Extended Tags=0A=
[    2.234393] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold=0A=
[    2.238470] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400=0A=
[    2.246377] pci 0000:00:07.0: enabling Extended Tags=0A=
[    2.250392] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold=0A=
[    2.258471] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400=0A=
[    2.262377] pci 0000:00:09.0: enabling Extended Tags=0A=
[    2.266390] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold=0A=
[    2.274465] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000=0A=
[    2.282482] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000=0A=
[    2.286367] pci 0000:00:16.0: reg 0x10: [mem 0xfbef8000-0xfbefbfff =
64bit]=0A=
[    2.294491] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000=0A=
[    2.298367] pci 0000:00:16.1: reg 0x10: [mem 0xfbef4000-0xfbef7fff =
64bit]=0A=
[    2.306482] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000=0A=
[    2.314367] pci 0000:00:16.2: reg 0x10: [mem 0xfbef0000-0xfbef3fff =
64bit]=0A=
[    2.318483] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000=0A=
[    2.326369] pci 0000:00:16.3: reg 0x10: [mem 0xfbeec000-0xfbeeffff =
64bit]=0A=
[    2.334483] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000=0A=
[    2.338367] pci 0000:00:16.4: reg 0x10: [mem 0xfbee8000-0xfbeebfff =
64bit]=0A=
[    2.346483] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000=0A=
[    2.354367] pci 0000:00:16.5: reg 0x10: [mem 0xfbee4000-0xfbee7fff =
64bit]=0A=
[    2.358482] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000=0A=
[    2.366367] pci 0000:00:16.6: reg 0x10: [mem 0xfbee0000-0xfbee3fff =
64bit]=0A=
[    2.374482] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000=0A=
[    2.378367] pci 0000:00:16.7: reg 0x10: [mem 0xfbedc000-0xfbedffff =
64bit]=0A=
[    2.386485] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300=0A=
[    2.394392] pci 0000:00:1a.0: reg 0x20: [io  0x9c00-0x9c1f]=0A=
[    2.398482] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300=0A=
[    2.402392] pci 0000:00:1a.1: reg 0x20: [io  0x9880-0x989f]=0A=
[    2.410480] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300=0A=
[    2.414392] pci 0000:00:1a.2: reg 0x20: [io  0x9800-0x981f]=0A=
[    2.422487] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320=0A=
[    2.426370] pci 0000:00:1a.7: reg 0x10: [mem 0xfbeda000-0xfbeda3ff]=0A=
[    2.434432] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold=0A=
[    2.442456] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300=0A=
[    2.446370] pci 0000:00:1b.0: reg 0x10: [mem 0xfbed4000-0xfbed7fff =
64bit]=0A=
[    2.454427] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold=0A=
[    2.458450] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400=0A=
[    2.466431] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold=0A=
[    2.470470] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300=0A=
[    2.478392] pci 0000:00:1d.0: reg 0x20: [io  0x9480-0x949f]=0A=
[    2.482479] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300=0A=
[    2.490392] pci 0000:00:1d.1: reg 0x20: [io  0x9400-0x941f]=0A=
[    2.494481] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300=0A=
[    2.502392] pci 0000:00:1d.2: reg 0x20: [io  0x9080-0x909f]=0A=
[    2.510461] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320=0A=
[    2.514372] pci 0000:00:1d.7: reg 0x10: [mem 0xfbed8000-0xfbed83ff]=0A=
[    2.522433] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold=0A=
[    2.526453] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401=0A=
[    2.534496] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100=0A=
[    2.538429] pci 0000:00:1f.0: can't claim BAR 13 [io  0x0800-0x087f]: =
address conflict with PCI Bus 0000:00 [io  0x03e0-0x0cf7 window]=0A=
[    2.554358] pci 0000:00:1f.0: can't claim BAR 14 [io  0x0500-0x053f]: =
address conflict with PCI Bus 0000:00 [io  0x03e0-0x0cf7 window]=0A=
[    2.566357] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at =
03e8 (mask 000f)=0A=
[    2.570356] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at =
4700 (mask 00ff)=0A=
[    2.578356] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at =
1640 (mask 000f)=0A=
[    2.586356] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at =
0ca0 (mask 000f)=0A=
[    2.594360] pci 0000:00:1f.0: quirk_ich7_lpc+0x0/0xc0 took 54687 usecs=0A=
[    2.602472] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601=0A=
[    2.610366] pci 0000:00:1f.2: reg 0x10: [io  0x8480-0x8487]=0A=
[    2.614361] pci 0000:00:1f.2: reg 0x14: [io  0x9000-0x9003]=0A=
[    2.618360] pci 0000:00:1f.2: reg 0x18: [io  0x8c00-0x8c07]=0A=
[    2.626361] pci 0000:00:1f.2: reg 0x1c: [io  0x8880-0x8883]=0A=
[    2.630361] pci 0000:00:1f.2: reg 0x20: [io  0x8800-0x881f]=0A=
[    2.638361] pci 0000:00:1f.2: reg 0x24: [mem 0xfbed2000-0xfbed27ff]=0A=
[    2.642393] pci 0000:00:1f.2: PME# supported from D3hot=0A=
[    2.650449] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500=0A=
[    2.654370] pci 0000:00:1f.3: reg 0x10: [mem 0xfbed0000-0xfbed00ff =
64bit]=0A=
[    2.662372] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]=0A=
[    2.666501] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000=0A=
[    2.674369] pci 0000:01:00.0: reg 0x10: [mem 0xfbbe0000-0xfbbfffff]=0A=
[    2.678362] pci 0000:01:00.0: reg 0x14: [mem 0xfbbc0000-0xfbbdffff]=0A=
[    2.686362] pci 0000:01:00.0: reg 0x18: [io  0xbc00-0xbc1f]=0A=
[    2.690362] pci 0000:01:00.0: reg 0x1c: [mem 0xfbb9c000-0xfbb9ffff]=0A=
[    2.698376] pci 0000:01:00.0: reg 0x30: [mem 0xfbba0000-0xfbbbffff =
pref]=0A=
[    2.706419] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold=0A=
[    2.710384] pci 0000:01:00.0: reg 0x184: [mem 0x00000000-0x00003fff =
64bit]=0A=
[    2.718357] pci 0000:01:00.0: VF(n) BAR0 space: [mem =
0x00000000-0x0001ffff 64bit] (contains BAR0 for 8 VFs)=0A=
[    2.726370] pci 0000:01:00.0: reg 0x190: [mem 0x00000000-0x00003fff =
64bit]=0A=
[    2.734356] pci 0000:01:00.0: VF(n) BAR3 space: [mem =
0x00000000-0x0001ffff 64bit] (contains BAR3 for 8 VFs)=0A=
[    2.746479] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000=0A=
[    2.750369] pci 0000:01:00.1: reg 0x10: [mem 0xfbb60000-0xfbb7ffff]=0A=
[    2.758362] pci 0000:01:00.1: reg 0x14: [mem 0xfbb40000-0xfbb5ffff]=0A=
[    2.762362] pci 0000:01:00.1: reg 0x18: [io  0xb880-0xb89f]=0A=
[    2.770362] pci 0000:01:00.1: reg 0x1c: [mem 0xfbb1c000-0xfbb1ffff]=0A=
[    2.774375] pci 0000:01:00.1: reg 0x30: [mem 0xfbb20000-0xfbb3ffff =
pref]=0A=
[    2.782416] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold=0A=
[    2.790380] pci 0000:01:00.1: reg 0x184: [mem 0x00000000-0x00003fff =
64bit]=0A=
[    2.794356] pci 0000:01:00.1: VF(n) BAR0 space: [mem =
0x00000000-0x0001ffff 64bit] (contains BAR0 for 8 VFs)=0A=
[    2.806370] pci 0000:01:00.1: reg 0x190: [mem 0x00000000-0x00003fff =
64bit]=0A=
[    2.814356] pci 0000:01:00.1: VF(n) BAR3 space: [mem =
0x00000000-0x0001ffff 64bit] (contains BAR3 for 8 VFs)=0A=
[    2.834379] pci 0000:00:01.0: PCI bridge to [bus 01]=0A=
[    2.838358] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]=0A=
[    2.842357] pci 0000:00:01.0:   bridge window [mem =
0xfbb00000-0xfbbfffff]=0A=
[    2.850406] pci 0000:02:00.0: [10df:f100] type 00 class 0x0c0400=0A=
[    2.858369] pci 0000:02:00.0: reg 0x10: [mem 0xfbcba000-0xfbcbafff =
64bit]=0A=
[    2.866364] pci 0000:02:00.0: reg 0x18: [mem 0xfbcbc000-0xfbcbffff =
64bit]=0A=
[    2.870361] pci 0000:02:00.0: reg 0x20: [io  0xc800-0xc8ff]=0A=
[    2.878366] pci 0000:02:00.0: reg 0x30: [mem 0xfbcc0000-0xfbcfffff =
pref]=0A=
[    2.886360] pci 0000:02:00.0: enabling Extended Tags=0A=
[    2.890422] pci 0000:02:00.0: 16.000 Gb/s available PCIe bandwidth, =
limited by 2.5 GT/s PCIe x8 link at 0000:00:03.0 (capable of 32.000 Gb/s =
with 5.0 GT/s PCIe x8 link)=0A=
[    2.906404] pci 0000:02:00.1: [10df:f100] type 00 class 0x0c0400=0A=
[    2.910370] pci 0000:02:00.1: reg 0x10: [mem 0xfbc3a000-0xfbc3afff =
64bit]=0A=
[    2.918364] pci 0000:02:00.1: reg 0x18: [mem 0xfbc3c000-0xfbc3ffff =
64bit]=0A=
[    2.926361] pci 0000:02:00.1: reg 0x20: [io  0xc400-0xc4ff]=0A=
[    2.930366] pci 0000:02:00.1: reg 0x30: [mem 0xfbc40000-0xfbc7ffff =
pref]=0A=
[    2.938360] pci 0000:02:00.1: enabling Extended Tags=0A=
[    2.954376] pci 0000:00:03.0: PCI bridge to [bus 02]=0A=
[    2.958358] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]=0A=
[    2.962356] pci 0000:00:03.0:   bridge window [mem =
0xfbc00000-0xfbcfffff]=0A=
[    2.970389] pci 0000:00:07.0: PCI bridge to [bus 03]=0A=
[    2.974391] pci 0000:00:09.0: PCI bridge to [bus 04]=0A=
[    2.982426] pci 0000:05:00.0: [197b:2368] type 00 class 0x010185=0A=
[    2.986377] pci 0000:05:00.0: reg 0x10: [io  0xd400-0xd407]=0A=
[    2.994481] pci 0000:05:00.0: reg 0x14: [io  0xdc00-0xdc03]=0A=
[    2.998367] pci 0000:05:00.0: reg 0x18: [io  0xd880-0xd887]=0A=
[    3.002367] pci 0000:05:00.0: reg 0x1c: [io  0xd800-0xd803]=0A=
[    3.010367] pci 0000:05:00.0: reg 0x20: [io  0xd480-0xd48f]=0A=
[    3.014378] pci 0000:05:00.0: reg 0x30: [mem 0xfbdf0000-0xfbdfffff =
pref]=0A=
[    3.022494] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'=0A=
[    3.034366] pci 0000:00:1c.0: PCI bridge to [bus 05]=0A=
[    3.038357] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]=0A=
[    3.042357] pci 0000:00:1c.0:   bridge window [mem =
0xfbd00000-0xfbdfffff]=0A=
[    3.050374] pci_bus 0000:06: extended config space not accessible=0A=
[    3.058382] pci 0000:06:04.0: [102b:0532] type 00 class 0x030000=0A=
[    3.062369] pci 0000:06:04.0: reg 0x10: [mem 0xf9000000-0xf9ffffff =
pref]=0A=
[    3.070363] pci 0000:06:04.0: reg 0x14: [mem 0xfaffc000-0xfaffffff]=0A=
[    3.074362] pci 0000:06:04.0: reg 0x18: [mem 0xfb000000-0xfb7fffff]=0A=
[    3.082452] pci 0000:06:05.0: [104c:8023] type 00 class 0x0c0010=0A=
[    3.090370] pci 0000:06:05.0: reg 0x10: [mem 0xfaff6000-0xfaff67ff]=0A=
[    3.094363] pci 0000:06:05.0: reg 0x14: [mem 0xfaff8000-0xfaffbfff]=0A=
[    3.102420] pci 0000:06:05.0: supports D1 D2=0A=
[    3.106355] pci 0000:06:05.0: PME# supported from D0 D1 D2 D3hot=0A=
[    3.114419] pci 0000:00:1e.0: PCI bridge to [bus 06] (subtractive =
decode)=0A=
[    3.118359] pci 0000:00:1e.0:   bridge window [mem =
0xfaf00000-0xfb7fffff]=0A=
[    3.126358] pci 0000:00:1e.0:   bridge window [mem =
0xf9000000-0xf9ffffff 64bit pref]=0A=
[    3.134356] pci 0000:00:1e.0:   bridge window [io  0x0000-0xdfff] =
(subtractive decode)=0A=
[    3.142355] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af =
window] (subtractive decode)=0A=
[    3.150355] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7 =
window] (subtractive decode)=0A=
[    3.158355] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03bb =
window] (subtractive decode)=0A=
[    3.166355] pci 0000:00:1e.0:   bridge window [io  0x03c0-0x03df =
window] (subtractive decode)=0A=
[    3.178355] pci 0000:00:1e.0:   bridge window [io  0xf000-0xffff =
window] (subtractive decode)=0A=
[    3.186355] pci 0000:00:1e.0:   bridge window [mem =
0x000a0000-0x000bffff window] (subtractive decode)=0A=
[    3.194355] pci 0000:00:1e.0:   bridge window [mem =
0xf9000000-0xfbffffff window] (subtractive decode)=0A=
[    3.202355] pci 0000:00:1e.0:   bridge window [mem =
0xfed40000-0xfed44fff] (subtractive decode)=0A=
[    3.214384] pci_bus 0000:00: on NUMA node 0=0A=
[    3.215141] ACPI: PCI Root Bridge [BR50] (domain 0000 [bus 80-fb])=0A=
[    3.218359] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM =
ClockPM Segments MSI HPX-Type3]=0A=
[    3.230358] acpi PNP0A08:01: _OSC failed (AE_NOT_FOUND); disabling =
ASPM=0A=
[    3.234558] PCI host bridge to bus 0000:80=0A=
[    3.238357] pci_bus 0000:80: root bus resource [io  0xe000-0xefff =
window]=0A=
[    3.246355] pci_bus 0000:80: root bus resource [mem =
0xf7000000-0xf8ffffff window]=0A=
[    3.254355] pci_bus 0000:80: root bus resource [bus 80-fb]=0A=
[    3.258373] pci 0000:80:00.0: [8086:3420] type 01 class 0x060400=0A=
[    3.266379] pci 0000:80:00.0: enabling Extended Tags=0A=
[    3.270399] pci 0000:80:00.0: PME# supported from D0 D3hot D3cold=0A=
[    3.278438] pci 0000:80:01.0: [8086:3408] type 01 class 0x060400=0A=
[    3.282380] pci 0000:80:01.0: enabling Extended Tags=0A=
[    3.286399] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold=0A=
[    3.294452] pci 0000:80:03.0: [8086:340a] type 01 class 0x060400=0A=
[    3.302385] pci 0000:80:03.0: enabling Extended Tags=0A=
[    3.306398] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold=0A=
[    3.310449] pci 0000:80:05.0: [8086:340c] type 01 class 0x060400=0A=
[    3.318385] pci 0000:80:05.0: enabling Extended Tags=0A=
[    3.322396] pci 0000:80:05.0: PME# supported from D0 D3hot D3cold=0A=
[    3.330447] pci 0000:80:07.0: [8086:340e] type 01 class 0x060400=0A=
[    3.334385] pci 0000:80:07.0: enabling Extended Tags=0A=
[    3.338398] pci 0000:80:07.0: PME# supported from D0 D3hot D3cold=0A=
[    3.346452] pci 0000:80:14.0: [8086:342e] type 00 class 0x080000=0A=
[    3.354466] pci 0000:80:14.1: [8086:3422] type 00 class 0x080000=0A=
[    3.358463] pci 0000:80:14.2: [8086:3423] type 00 class 0x080000=0A=
[    3.366458] pci 0000:80:14.3: [8086:3438] type 00 class 0x080000=0A=
[    3.370443] pci 0000:80:16.0: [8086:3430] type 00 class 0x088000=0A=
[    3.378369] pci 0000:80:16.0: reg 0x10: [mem 0xf8efc000-0xf8efffff =
64bit]=0A=
[    3.386474] pci 0000:80:16.1: [8086:3431] type 00 class 0x088000=0A=
[    3.390368] pci 0000:80:16.1: reg 0x10: [mem 0xf8ef8000-0xf8efbfff =
64bit]=0A=
[    3.398472] pci 0000:80:16.2: [8086:3432] type 00 class 0x088000=0A=
[    3.406371] pci 0000:80:16.2: reg 0x10: [mem 0xf8ef4000-0xf8ef7fff =
64bit]=0A=
[    3.410472] pci 0000:80:16.3: [8086:3433] type 00 class 0x088000=0A=
[    3.418369] pci 0000:80:16.3: reg 0x10: [mem 0xf8ef0000-0xf8ef3fff =
64bit]=0A=
[    3.426473] pci 0000:80:16.4: [8086:3429] type 00 class 0x088000=0A=
[    3.430368] pci 0000:80:16.4: reg 0x10: [mem 0xf8eec000-0xf8eeffff =
64bit]=0A=
[    3.438475] pci 0000:80:16.5: [8086:342a] type 00 class 0x088000=0A=
[    3.442368] pci 0000:80:16.5: reg 0x10: [mem 0xf8ee8000-0xf8eebfff =
64bit]=0A=
[    3.450472] pci 0000:80:16.6: [8086:342b] type 00 class 0x088000=0A=
[    3.458368] pci 0000:80:16.6: reg 0x10: [mem 0xf8ee4000-0xf8ee7fff =
64bit]=0A=
[    3.462472] pci 0000:80:16.7: [8086:342c] type 00 class 0x088000=0A=
[    3.470369] pci 0000:80:16.7: reg 0x10: [mem 0xf8ee0000-0xf8ee3fff =
64bit]=0A=
[    3.478497] pci 0000:80:00.0: PCI bridge to [bus 81]=0A=
[    3.482403] pci 0000:80:01.0: PCI bridge to [bus 82]=0A=
[    3.486669] pci 0000:83:00.0: [15b3:673c] type 00 class 0x0c0600=0A=
[    3.494409] pci 0000:83:00.0: reg 0x10: [mem 0xf8a00000-0xf8afffff =
64bit]=0A=
[    3.498551] pci 0000:83:00.0: reg 0x18: [mem 0xf7800000-0xf7ffffff =
64bit pref]=0A=
[    3.522456] pci 0000:80:03.0: PCI bridge to [bus 83]=0A=
[    3.526359] pci 0000:80:03.0:   bridge window [mem =
0xf8a00000-0xf8afffff]=0A=
[    3.534358] pci 0000:80:03.0:   bridge window [mem =
0xf7800000-0xf7ffffff 64bit pref]=0A=
[    3.542407] pci 0000:84:00.0: [9005:0285] type 00 class 0x010400=0A=
[    3.546372] pci 0000:84:00.0: reg 0x10: [mem 0xf8c00000-0xf8dfffff =
64bit]=0A=
[    3.554389] pci 0000:84:00.0: reg 0x30: [mem 0xf8b80000-0xf8bfffff =
pref]=0A=
[    3.562403] pci 0000:84:00.0: supports D1=0A=
[    3.578373] pci 0000:80:05.0: PCI bridge to [bus 84]=0A=
[    3.582359] pci 0000:80:05.0:   bridge window [mem =
0xf8b00000-0xf8dfffff]=0A=
[    3.590410] pci 0000:85:00.0: [10df:f100] type 00 class 0x0c0400=0A=
[    3.594371] pci 0000:85:00.0: reg 0x10: [mem 0xf8fba000-0xf8fbafff =
64bit]=0A=
[    3.602365] pci 0000:85:00.0: reg 0x18: [mem 0xf8fbc000-0xf8fbffff =
64bit]=0A=
[    3.610362] pci 0000:85:00.0: reg 0x20: [io  0xe800-0xe8ff]=0A=
[    3.614368] pci 0000:85:00.0: reg 0x30: [mem 0xf8fc0000-0xf8ffffff =
pref]=0A=
[    3.622361] pci 0000:85:00.0: enabling Extended Tags=0A=
[    3.626431] pci 0000:85:00.0: 16.000 Gb/s available PCIe bandwidth, =
limited by 2.5 GT/s PCIe x8 link at 0000:80:07.0 (capable of 32.000 Gb/s =
with 5.0 GT/s PCIe x8 link)=0A=
[    3.642403] pci 0000:85:00.1: [10df:f100] type 00 class 0x0c0400=0A=
[    3.650371] pci 0000:85:00.1: reg 0x10: [mem 0xf8f3a000-0xf8f3afff =
64bit]=0A=
[    3.654365] pci 0000:85:00.1: reg 0x18: [mem 0xf8f3c000-0xf8f3ffff =
64bit]=0A=
[    3.662362] pci 0000:85:00.1: reg 0x20: [io  0xe400-0xe4ff]=0A=
[    3.666368] pci 0000:85:00.1: reg 0x30: [mem 0xf8f40000-0xf8f7ffff =
pref]=0A=
[    3.674360] pci 0000:85:00.1: enabling Extended Tags=0A=
[    3.690375] pci 0000:80:07.0: PCI bridge to [bus 85]=0A=
[    3.694358] pci 0000:80:07.0:   bridge window [io  0xe000-0xefff]=0A=
[    3.702357] pci 0000:80:07.0:   bridge window [mem =
0xf8f00000-0xf8ffffff]=0A=
[    3.706385] pci_bus 0000:80: on NUMA node 1=0A=
[    3.706500] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 =
14 15)=0A=
[    3.714405] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12 =
14 15)=0A=
[    3.722404] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 =
*14 15)=0A=
[    3.730407] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 =
*15)=0A=
[    3.734403] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 =
15) *0, disabled.=0A=
[    3.742404] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 =
14 15)=0A=
[    3.750403] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 *10 11 12 =
14 15)=0A=
[    3.758403] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 *11 12 =
14 15)=0A=
[    3.766487] iommu: Default domain type: Translated =0A=
[    3.770381] pci 0000:06:04.0: vgaarb: setting as boot VGA device=0A=
[    3.774353] pci 0000:06:04.0: vgaarb: VGA device added: =
decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone=0A=
[    3.786360] pci 0000:06:04.0: vgaarb: bridge control possible=0A=
[    3.790355] vgaarb: loaded=0A=
[    3.793227] EDAC MC: Ver: 3.0.0=0A=
[    3.798528] NetLabel: Initializing=0A=
[    3.798528] NetLabel:  domain hash size =3D 128=0A=
[    3.806355] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO=0A=
[    3.810380] NetLabel:  unlabeled traffic allowed by default=0A=
[    3.814355] PCI: Using ACPI for IRQ routing=0A=
[    3.825581] PCI: Discovered peer bus fe=0A=
[    3.830355] PCI: root bus fe: using default resources=0A=
[    3.830356] PCI: Probing PCI hardware (bus fe)=0A=
[    3.830377] PCI host bridge to bus 0000:fe=0A=
[    3.834356] pci_bus 0000:fe: Unknown NUMA node; performance will be =
reduced=0A=
[    3.838356] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]=0A=
[    3.846355] pci_bus 0000:fe: root bus resource [mem =
0x00000000-0xffffffffff]=0A=
[    3.854356] pci_bus 0000:fe: No busn resource found for root bus, =
will use [bus fe-ff]=0A=
[    3.862360] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000=0A=
[    3.866399] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000=0A=
[    3.874400] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000=0A=
[    3.882395] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000=0A=
[    3.886398] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000=0A=
[    3.894394] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000=0A=
[    3.898394] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000=0A=
[    3.906398] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000=0A=
[    3.910395] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000=0A=
[    3.918394] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000=0A=
[    3.922394] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000=0A=
[    3.930395] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000=0A=
[    3.934395] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000=0A=
[    3.942380] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000=0A=
[    3.946396] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000=0A=
[    3.954407] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000=0A=
[    3.958397] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000=0A=
[    3.966394] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000=0A=
[    3.970395] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000=0A=
[    3.978394] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000=0A=
[    3.982398] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000=0A=
[    3.990394] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000=0A=
[    3.998395] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000=0A=
[    4.002397] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000=0A=
[    4.010406] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to =
fe=0A=
[    4.014362] PCI: Discovered peer bus ff=0A=
[    4.018355] PCI: root bus ff: using default resources=0A=
[    4.018356] PCI: Probing PCI hardware (bus ff)=0A=
[    4.018376] PCI host bridge to bus 0000:ff=0A=
[    4.022355] pci_bus 0000:ff: Unknown NUMA node; performance will be =
reduced=0A=
[    4.030355] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]=0A=
[    4.038355] pci_bus 0000:ff: root bus resource [mem =
0x00000000-0xffffffffff]=0A=
[    4.042356] pci_bus 0000:ff: No busn resource found for root bus, =
will use [bus ff-ff]=0A=
[    4.050359] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000=0A=
[    4.058392] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000=0A=
[    4.062397] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000=0A=
[    4.070393] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000=0A=
[    4.074392] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000=0A=
[    4.082392] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000=0A=
[    4.086392] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000=0A=
[    4.094400] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000=0A=
[    4.102393] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000=0A=
[    4.106393] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000=0A=
[    4.114392] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000=0A=
[    4.118392] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000=0A=
[    4.126393] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000=0A=
[    4.130395] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000=0A=
[    4.138392] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000=0A=
[    4.142395] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000=0A=
[    4.150395] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000=0A=
[    4.158392] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000=0A=
[    4.162392] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000=0A=
[    4.170394] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000=0A=
[    4.174394] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000=0A=
[    4.182392] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000=0A=
[    4.186393] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000=0A=
[    4.194394] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000=0A=
[    4.198401] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff=0A=
[    4.206361] PCI: pci_cache_line_size set to 64 bytes=0A=
[    4.206403] pci 0000:00:1f.3: can't claim BAR 4 [io  0x0400-0x041f]: =
address conflict with PCI Bus 0000:00 [io  0x03e0-0x0cf7 window]=0A=
[    4.218490] e820: reserve RAM buffer [mem 0x00094000-0x0009ffff]=0A=
[    4.218491] e820: reserve RAM buffer [mem 0xbf760000-0xbfffffff]=0A=
[    4.218523] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0=0A=
[    4.222356] hpet0: 4 comparators, 64-bit 14.318180 MHz counter=0A=
[    4.231401] clocksource: Switched to clocksource tsc-early=0A=
[    4.248989] VFS: Disk quotas dquot_6.6.0=0A=
[    4.253005] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 =
bytes)=0A=
[    4.260095] AppArmor: AppArmor Filesystem Enabled=0A=
[    4.264877] pnp: PnP ACPI init=0A=
[    4.268109] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been =
reserved=0A=
[    4.274790] system 00:00: Plug and Play ACPI device, IDs PNP0c01 =
(active)=0A=
[    4.274883] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=0A=
[    4.275079] pnp 00:02: [dma 0 disabled]=0A=
[    4.275129] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)=0A=
[    4.275311] pnp 00:03: [dma 0 disabled]=0A=
[    4.275381] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)=0A=
[    4.275617] pnp 00:04: [dma 0 disabled]=0A=
[    4.275664] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)=0A=
[    4.275788] system 00:05: [io  0x164e-0x164f] has been reserved=0A=
[    4.281772] system 00:05: Plug and Play ACPI device, IDs PNP0c02 =
(active)=0A=
[    4.281910] pnp 00:06: disabling [mem 0x00000400-0x000004ff] because =
it overlaps 0000:01:00.0 BAR 7 [mem 0x00000000-0x0001ffff 64bit]=0A=
[    4.293987] pnp 00:06: disabling [mem 0x00000400-0x000004ff disabled] =
because it overlaps 0000:01:00.0 BAR 10 [mem 0x00000000-0x0001ffff 64bit]=0A=
[    4.306927] pnp 00:06: disabling [mem 0x00000400-0x000004ff disabled] =
because it overlaps 0000:01:00.1 BAR 7 [mem 0x00000000-0x0001ffff 64bit]=0A=
[    4.319774] pnp 00:06: disabling [mem 0x00000400-0x000004ff disabled] =
because it overlaps 0000:01:00.1 BAR 10 [mem 0x00000000-0x0001ffff 64bit]=0A=
[    4.332790] system 00:06: [io  0x0ca2-0x0ca3] could not be reserved=0A=
[    4.339120] system 00:06: [io  0x0cf8-0x0cff] could not be reserved=0A=
[    4.345444] system 00:06: [io  0x04d0-0x04d1] has been reserved=0A=
[    4.351424] system 00:06: [io  0x0800-0x087f] has been reserved=0A=
[    4.357402] system 00:06: [io  0x0500-0x057f] has been reserved=0A=
[    4.363384] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been =
reserved=0A=
[    4.370057] system 00:06: [mem 0xfed20000-0xfed3ffff] has been =
reserved=0A=
[    4.376729] system 00:06: [mem 0xfed40000-0xfed8ffff] could not be =
reserved=0A=
[    4.383754] system 00:06: Plug and Play ACPI device, IDs PNP0c02 =
(active)=0A=
[    4.383922] system 00:07: [mem 0xfec00000-0xfec00fff] could not be =
reserved=0A=
[    4.391951] system 00:07: [mem 0xfee00000-0xfee00fff] has been =
reserved=0A=
[    4.398632] system 00:07: Plug and Play ACPI device, IDs PNP0c02 =
(active)=0A=
[    4.398816] system 00:08: [io  0x0a00-0x0a0f] has been reserved=0A=
[    4.404801] system 00:08: [io  0x0a10-0x0a1f] has been reserved=0A=
[    4.410779] system 00:08: Plug and Play ACPI device, IDs PNP0c02 =
(active)=0A=
[    4.410894] system 00:09: [mem 0xe0000000-0xefffffff] has been =
reserved=0A=
[    4.417579] system 00:09: Plug and Play ACPI device, IDs PNP0c02 =
(active)=0A=
[    4.417731] system 00:0a: [mem 0x000c0000-0x000cffff] could not be =
reserved=0A=
[    4.424759] system 00:0a: [mem 0x000e0000-0x000fffff] could not be =
reserved=0A=
[    4.431776] system 00:0a: [mem 0xfed90000-0xffffffff] could not be =
reserved=0A=
[    4.438802] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 =
(active)=0A=
[    4.438885] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 =
(active)=0A=
[    4.439012] pnp: PnP ACPI: found 12 devices=0A=
[    4.449384] clocksource: acpi_pm: mask: 0xffffff max_cycles: =
0xffffff, max_idle_ns: 2085701024 ns=0A=
[    4.458417] NET: Registered protocol family 2=0A=
[    4.463248] IP idents hash table entries: 262144 (order: 9, 2097152 =
bytes, vmalloc)=0A=
[    4.473535] tcp_listen_portaddr_hash hash table entries: 16384 =
(order: 6, 262144 bytes, vmalloc)=0A=
[    4.482836] TCP established hash table entries: 262144 (order: 9, =
2097152 bytes, vmalloc)=0A=
[    4.491616] TCP bind hash table entries: 65536 (order: 8, 1048576 =
bytes, vmalloc)=0A=
[    4.499290] TCP: Hash tables configured (established 262144 bind =
65536)=0A=
[    4.506140] UDP hash table entries: 16384 (order: 7, 524288 bytes, =
vmalloc)=0A=
[    4.513343] UDP-Lite hash table entries: 16384 (order: 7, 524288 =
bytes, vmalloc)=0A=
[    4.520972] NET: Registered protocol family 1=0A=
[    4.525400] NET: Registered protocol family 44=0A=
[    4.529921] pci_bus 0000:00: max bus depth: 1 pci_try_num: 2=0A=
[    4.535649] pci 0000:00:1f.0: BAR 13: [io  size 0x0080] has bogus =
alignment=0A=
[    4.542666] pci 0000:00:1f.0: BAR 14: [io  size 0x0040] has bogus =
alignment=0A=
[    4.549693] pci 0000:00:1c.0: BAR 15: assigned [mem =
0xfa000000-0xfa1fffff 64bit pref]=0A=
[    4.557598] pci 0000:00:1f.3: BAR 4: assigned [io  0x1000-0x101f]=0A=
[    4.563757] pci 0000:01:00.0: BAR 7: no space for [mem size =
0x00020000 64bit]=0A=
[    4.570954] pci 0000:01:00.0: BAR 7: failed to assign [mem size =
0x00020000 64bit]=0A=
[    4.578509] pci 0000:01:00.0: BAR 10: no space for [mem size =
0x00020000 64bit]=0A=
[    4.585804] pci 0000:01:00.0: BAR 10: failed to assign [mem size =
0x00020000 64bit]=0A=
[    4.593447] pci 0000:01:00.1: BAR 7: no space for [mem size =
0x00020000 64bit]=0A=
[    4.600643] pci 0000:01:00.1: BAR 7: failed to assign [mem size =
0x00020000 64bit]=0A=
[    4.608198] pci 0000:01:00.1: BAR 10: no space for [mem size =
0x00020000 64bit]=0A=
[    4.615494] pci 0000:01:00.1: BAR 10: failed to assign [mem size =
0x00020000 64bit]=0A=
[    4.623137] pci 0000:00:01.0: PCI bridge to [bus 01]=0A=
[    4.629438] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]=0A=
[    4.635597] pci 0000:00:01.0:   bridge window [mem =
0xfbb00000-0xfbbfffff]=0A=
[    4.643510] pci 0000:00:03.0: PCI bridge to [bus 02]=0A=
[    4.648536] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]=0A=
[    4.654692] pci 0000:00:03.0:   bridge window [mem =
0xfbc00000-0xfbcfffff]=0A=
[    4.661544] pci 0000:00:07.0: PCI bridge to [bus 03]=0A=
[    4.666577] pci 0000:00:09.0: PCI bridge to [bus 04]=0A=
[    4.671605] pci 0000:00:1c.0: PCI bridge to [bus 05]=0A=
[    4.676633] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]=0A=
[    4.682791] pci 0000:00:1c.0:   bridge window [mem =
0xfbd00000-0xfbdfffff]=0A=
[    4.689636] pci 0000:00:1c.0:   bridge window [mem =
0xfa000000-0xfa1fffff 64bit pref]=0A=
[    4.697454] pci 0000:00:1e.0: PCI bridge to [bus 06]=0A=
[    4.702477] pci 0000:00:1e.0:   bridge window [mem =
0xfaf00000-0xfb7fffff]=0A=
[    4.709324] pci 0000:00:1e.0:   bridge window [mem =
0xf9000000-0xf9ffffff 64bit pref]=0A=
[    4.717141] pci_bus 0000:00: No. 2 try to assign unassigned res=0A=
[    4.723119] release child resource [mem 0xfbb1c000-0xfbb1ffff]=0A=
[    4.723120] release child resource [mem 0xfbb20000-0xfbb3ffff pref]=0A=
[    4.723121] release child resource [mem 0xfbb40000-0xfbb5ffff]=0A=
[    4.723122] release child resource [mem 0xfbb60000-0xfbb7ffff]=0A=
[    4.723123] release child resource [mem 0xfbb9c000-0xfbb9ffff]=0A=
[    4.723123] release child resource [mem 0xfbba0000-0xfbbbffff pref]=0A=
[    4.723124] release child resource [mem 0xfbbc0000-0xfbbdffff]=0A=
[    4.723125] release child resource [mem 0xfbbe0000-0xfbbfffff]=0A=
[    4.723127] pci 0000:00:01.0: resource 14 [mem 0xfbb00000-0xfbbfffff] =
released=0A=
[    4.730423] pci 0000:00:01.0: PCI bridge to [bus 01]=0A=
[    4.735456] pci 0000:00:01.0: bridge window [mem =
0x00100000-0x001fffff] to [bus 01] add_size 100000 add_align 100000=0A=
[    4.746058] pci 0000:00:1f.0: BAR 13: [io  size 0x0080] has bogus =
alignment=0A=
[    4.753077] pci 0000:00:1f.0: BAR 14: [io  size 0x0040] has bogus =
alignment=0A=
[    4.760101] pci 0000:00:01.0: BAR 14: assigned [mem =
0xfa200000-0xfa3fffff]=0A=
[    4.767035] pci 0000:01:00.0: BAR 0: assigned [mem =
0xfa200000-0xfa21ffff]=0A=
[    4.773888] pci 0000:01:00.0: BAR 1: assigned [mem =
0xfa220000-0xfa23ffff]=0A=
[    4.780733] pci 0000:01:00.0: BAR 6: assigned [mem =
0xfa240000-0xfa25ffff pref]=0A=
[    4.788028] pci 0000:01:00.1: BAR 0: assigned [mem =
0xfa260000-0xfa27ffff]=0A=
[    4.794878] pci 0000:01:00.1: BAR 1: assigned [mem =
0xfa280000-0xfa29ffff]=0A=
[    4.801723] pci 0000:01:00.1: BAR 6: assigned [mem =
0xfa2a0000-0xfa2bffff pref]=0A=
[    4.809015] pci 0000:01:00.0: BAR 3: assigned [mem =
0xfa2c0000-0xfa2c3fff]=0A=
[    4.815867] pci 0000:01:00.0: BAR 7: assigned [mem =
0xfa2c4000-0xfa2e3fff 64bit]=0A=
[    4.823250] pci 0000:01:00.0: BAR 10: assigned [mem =
0xfa2e4000-0xfa303fff 64bit]=0A=
[    4.830717] pci 0000:01:00.1: BAR 3: assigned [mem =
0xfa304000-0xfa307fff]=0A=
[    4.837567] pci 0000:01:00.1: BAR 7: assigned [mem =
0xfa308000-0xfa327fff 64bit]=0A=
[    4.844947] pci 0000:01:00.1: BAR 10: assigned [mem =
0xfa328000-0xfa347fff 64bit]=0A=
[    4.852418] pci 0000:00:01.0: PCI bridge to [bus 01]=0A=
[    4.857442] pci 0000:00:01.0:   bridge window [io  0xb000-0xbfff]=0A=
[    4.863598] pci 0000:00:01.0:   bridge window [mem =
0xfa200000-0xfa3fffff]=0A=
[    4.870448] pci 0000:00:03.0: PCI bridge to [bus 02]=0A=
[    4.875474] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]=0A=
[    4.881631] pci 0000:00:03.0:   bridge window [mem =
0xfbc00000-0xfbcfffff]=0A=
[    4.888479] pci 0000:00:07.0: PCI bridge to [bus 03]=0A=
[    4.893506] pci 0000:00:09.0: PCI bridge to [bus 04]=0A=
[    4.899565] pci 0000:00:1c.0: PCI bridge to [bus 05]=0A=
[    4.904593] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]=0A=
[    4.910749] pci 0000:00:1c.0:   bridge window [mem =
0xfbd00000-0xfbdfffff]=0A=
[    4.917596] pci 0000:00:1c.0:   bridge window [mem =
0xfa000000-0xfa1fffff 64bit pref]=0A=
[    4.925414] pci 0000:00:1e.0: PCI bridge to [bus 06]=0A=
[    4.930436] pci 0000:00:1e.0:   bridge window [mem =
0xfaf00000-0xfb7fffff]=0A=
[    4.937285] pci 0000:00:1e.0:   bridge window [mem =
0xf9000000-0xf9ffffff 64bit pref]=0A=
[    4.945103] pci_bus 0000:00: resource 4 [io  0x0000-0xdfff]=0A=
[    4.950732] pci_bus 0000:00: resource 5 [io  0x0000-0x03af window]=0A=
[    4.956973] pci_bus 0000:00: resource 6 [io  0x03e0-0x0cf7 window]=0A=
[    4.963211] pci_bus 0000:00: resource 7 [io  0x03b0-0x03bb window]=0A=
[    4.969450] pci_bus 0000:00: resource 8 [io  0x03c0-0x03df window]=0A=
[    4.975692] pci_bus 0000:00: resource 9 [io  0xf000-0xffff window]=0A=
[    4.981930] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff =
window]=0A=
[    4.988953] pci_bus 0000:00: resource 11 [mem 0xf9000000-0xfbffffff =
window]=0A=
[    4.995973] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]=0A=
[    5.002383] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]=0A=
[    5.008014] pci_bus 0000:01: resource 1 [mem 0xfa200000-0xfa3fffff]=0A=
[    5.014342] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]=0A=
[    5.019973] pci_bus 0000:02: resource 1 [mem 0xfbc00000-0xfbcfffff]=0A=
[    5.026301] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]=0A=
[    5.031932] pci_bus 0000:05: resource 1 [mem 0xfbd00000-0xfbdfffff]=0A=
[    5.038260] pci_bus 0000:05: resource 2 [mem 0xfa000000-0xfa1fffff =
64bit pref]=0A=
[    5.045553] pci_bus 0000:06: resource 1 [mem 0xfaf00000-0xfb7fffff]=0A=
[    5.051883] pci_bus 0000:06: resource 2 [mem 0xf9000000-0xf9ffffff =
64bit pref]=0A=
[    5.059177] pci_bus 0000:06: resource 4 [io  0x0000-0xdfff]=0A=
[    5.064812] pci_bus 0000:06: resource 5 [io  0x0000-0x03af window]=0A=
[    5.071051] pci_bus 0000:06: resource 6 [io  0x03e0-0x0cf7 window]=0A=
[    5.077293] pci_bus 0000:06: resource 7 [io  0x03b0-0x03bb window]=0A=
[    5.083531] pci_bus 0000:06: resource 8 [io  0x03c0-0x03df window]=0A=
[    5.089770] pci_bus 0000:06: resource 9 [io  0xf000-0xffff window]=0A=
[    5.096009] pci_bus 0000:06: resource 10 [mem 0x000a0000-0x000bffff =
window]=0A=
[    5.103032] pci_bus 0000:06: resource 11 [mem 0xf9000000-0xfbffffff =
window]=0A=
[    5.110050] pci_bus 0000:06: resource 12 [mem 0xfed40000-0xfed44fff]=0A=
[    5.116515] pci 0000:80:00.0: PCI bridge to [bus 81]=0A=
[    5.121546] pci 0000:80:01.0: PCI bridge to [bus 82]=0A=
[    5.126580] pci 0000:80:03.0: PCI bridge to [bus 83]=0A=
[    5.131609] pci 0000:80:03.0:   bridge window [mem =
0xf8a00000-0xf8afffff]=0A=
[    5.138458] pci 0000:80:03.0:   bridge window [mem =
0xf7800000-0xf7ffffff 64bit pref]=0A=
[    5.146276] pci 0000:80:05.0: PCI bridge to [bus 84]=0A=
[    5.151300] pci 0000:80:05.0:   bridge window [mem =
0xf8b00000-0xf8dfffff]=0A=
[    5.159184] pci 0000:80:07.0: PCI bridge to [bus 85]=0A=
[    5.164210] pci 0000:80:07.0:   bridge window [io  0xe000-0xefff]=0A=
[    5.170366] pci 0000:80:07.0:   bridge window [mem =
0xf8f00000-0xf8ffffff]=0A=
[    5.177217] pci_bus 0000:80: resource 4 [io  0xe000-0xefff window]=0A=
[    5.183460] pci_bus 0000:80: resource 5 [mem 0xf7000000-0xf8ffffff =
window]=0A=
[    5.190394] pci_bus 0000:83: resource 1 [mem 0xf8a00000-0xf8afffff]=0A=
[    5.196718] pci_bus 0000:83: resource 2 [mem 0xf7800000-0xf7ffffff =
64bit pref]=0A=
[    5.204013] pci_bus 0000:84: resource 1 [mem 0xf8b00000-0xf8dfffff]=0A=
[    5.210343] pci_bus 0000:85: resource 0 [io  0xe000-0xefff]=0A=
[    5.215974] pci_bus 0000:85: resource 1 [mem 0xf8f00000-0xf8ffffff]=0A=
[    5.222311] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]=0A=
[    5.227940] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]=0A=
[    5.234446] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]=0A=
[    5.240084] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]=0A=
[    5.248365] pci 0000:06:04.0: Video device with shadowed ROM at [mem =
0x000c0000-0x000dffff]=0A=
[    5.256934] PCI: CLS 256 bytes, default 64=0A=
[    5.261150] Trying to unpack rootfs image as initramfs...=0A=
[    5.751631] Freeing initrd memory: 27392K=0A=
[    5.755715] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)=0A=
[    5.762217] software IO TLB: mapped [mem =
0x00000000bb760000-0x00000000bf760000] (64MB)=0A=
[    5.771085] Initialise system trusted keyrings=0A=
[    5.775762] Key type blacklist registered=0A=
[    5.779932] workingset: timestamp_bits=3D36 max_order=3D23 =
bucket_order=3D0=0A=
[    5.787666] zbud: loaded=0A=
[    5.790487] integrity: Platform Keyring initialized=0A=
[    5.795430] Key type asymmetric registered=0A=
[    5.799587] Asymmetric key parser 'x509' registered=0A=
[    5.804535] Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 251)=0A=
[    5.812048] io scheduler mq-deadline registered=0A=
[    5.818204] shpchp: Standard Hot Plug PCI Controller Driver version: =
0.4=0A=
[    5.824990] intel_idle: MWAIT substates: 0x1120=0A=
[    5.825076] Monitor-Mwait will be used to enter C-3 state=0A=
[    5.825085] Monitor-Mwait will be used to enter C-3 state=0A=
[    5.825091] ACPI: \_PR_.P001: Found 3 idle states=0A=
[    5.829953] ACPI: \_PR_.P002: Found 3 idle states=0A=
[    5.834812] ACPI: \_PR_.P003: Found 3 idle states=0A=
[    5.839663] ACPI: \_PR_.P004: Found 3 idle states=0A=
[    5.844516] ACPI: \_PR_.P005: Found 3 idle states=0A=
[    5.849362] ACPI: \_PR_.P006: Found 3 idle states=0A=
[    5.854230] ACPI: \_PR_.P007: Found 3 idle states=0A=
[    5.859097] ACPI: \_PR_.P008: Found 3 idle states=0A=
[    5.863964] ACPI: \_PR_.P009: Found 3 idle states=0A=
[    5.868840] ACPI: \_PR_.P010: Found 3 idle states=0A=
[    5.873710] ACPI: \_PR_.P011: Found 3 idle states=0A=
[    5.878579] ACPI: \_PR_.P012: Found 3 idle states=0A=
[    5.883346] intel_idle: ACPI _CST not found or not usable=0A=
[    5.883347] intel_idle: v0.5.1 model 0x2C=0A=
[    5.884159] intel_idle: Local APIC timer is reliable in all C-states=0A=
[    5.884811] ERST: Failed to get Error Log Address Range.=0A=
[    5.890210] [Firmware Warn]: GHES: Poll interval is 0 for generic =
hardware error source: 1, disabled.=0A=
[    5.899563] GHES: APEI firmware first mode is enabled by WHEA _OSC.=0A=
[    5.906033] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0A=
[    5.912499] 00:02: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D =
115200) is a 16550A=0A=
[    5.920342] 00:03: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D =
115200) is a 16550A=0A=
[    5.928148] 00:04: ttyS2 at I/O 0x3e8 (irq =3D 5, base_baud =3D =
115200) is a 16550A=0A=
[    5.936230] Linux agpgart interface v0.103=0A=
[    5.940476] AMD-Vi: AMD IOMMUv2 functionality not available on this =
system - This is not a bug.=0A=
[    5.950923] i8042: PNP: No PS/2 controller found.=0A=
[    5.955692] i8042: Probing ports directly.=0A=
[    5.962777] serio: i8042 KBD port at 0x60,0x64 irq 1=0A=
[    5.967809] serio: i8042 AUX port at 0x60,0x64 irq 12=0A=
[    5.973284] mousedev: PS/2 mouse device common for all mice=0A=
[    5.978968] rtc_cmos 00:01: RTC can wake from S4=0A=
[    5.983871] rtc_cmos 00:01: registered as rtc0=0A=
[    5.988475] rtc_cmos 00:01: setting system clock to =
2022-02-15T11:14:57 UTC (1644923697)=0A=
[    5.996664] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes =
nvram, hpet irqs=0A=
[    6.004403] intel_pstate: CPU model not supported=0A=
[    6.009837] ledtrig-cpu: registered to indicate activity on CPUs=0A=
[    6.016385] NET: Registered protocol family 10=0A=
[    6.030043] Segment Routing with IPv6=0A=
[    6.034235] mip6: Mobile IPv6=0A=
[    6.037264] NET: Registered protocol family 17=0A=
[    6.041935] mpls_gso: MPLS GSO support=0A=
[    6.047897] microcode: sig=3D0x206c2, pf=3D0x1, revision=3D0x10=0A=
[    6.053855] microcode: Microcode Update Driver: v2.2.=0A=
[    6.053860] IPI shorthand broadcast: enabled=0A=
[    6.063342] sched_clock: Marking stable (4982952996, =
1080381010)->(6243983674, -180649668)=0A=
[    6.073365] registered taskstats version 1=0A=
[    6.077551] Loading compiled-in X.509 certificates=0A=
[    6.127472] Loaded X.509 cert 'Debian Secure Boot CA: =
6ccece7e4c6c0d1f6149f3dd27dfcc5cbb419ea1'=0A=
[    6.136288] Loaded X.509 cert 'Debian Secure Boot Signer 2021 - =
linux: 4b6ef5abca669825178e052c84667ccbc0531f8c'=0A=
[    6.146645] zswap: loaded using pool lzo/zbud=0A=
[    6.152603] Key type ._fscrypt registered=0A=
[    6.156698] Key type .fscrypt registered=0A=
[    6.160697] Key type fscrypt-provisioning registered=0A=
[    6.165781] AppArmor: AppArmor sha1 policy hashing enabled=0A=
[    6.171895] APEI: Can not request [mem 0xbf77a9f0-0xbf77aa43] for =
APEI BERT registers=0A=
[    6.181553] Freeing unused kernel image (initmem) memory: 2412K=0A=
[    6.206492] Write protecting the kernel read-only data: 22528k=0A=
[    6.213379] Freeing unused kernel image (text/rodata gap) memory: =
2040K=0A=
[    6.220554] Freeing unused kernel image (rodata/data gap) memory: 624K=0A=
[    6.287491] x86/mm: Checked W+X mappings: passed, no W+X pages found.=0A=
[    6.294008] x86/mm: Checking user space page tables=0A=
[    6.352620] x86/mm: Checked W+X mappings: passed, no W+X pages found.=0A=
[    6.359144] Run /init as init process=0A=
[    6.362887]   with arguments:=0A=
[    6.362887]     /init=0A=
[    6.362888]   with environment:=0A=
[    6.362889]     HOME=3D/=0A=
[    6.362890]     TERM=3Dlinux=0A=
[    6.362890]     BOOT_IMAGE=3D/boot/vmlinuz-5.10.0-11-amd64=0A=
[    6.381672] udevd[171]: starting version 3.2.9=0A=
[    6.386425] random: udevd: uninitialized urandom read (16 bytes read)=0A=
[    6.392980] random: udevd: uninitialized urandom read (16 bytes read)=0A=
[    6.400234] udevd[172]: starting eudev-3.2.9=0A=
[    6.411826] random: udevd: uninitialized urandom read (16 bytes read)=0A=
[    6.427203] pps_core: LinuxPPS API ver. 1 registered=0A=
[    6.432250] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 =
Rodolfo Giometti <giometti@linux.it>=0A=
[    6.442051] ACPI Warning: SystemIO range =
0x0000000000000828-0x000000000000082F conflicts with OpRegion =
0x0000000000000800-0x000000000000084F (\PMRG) (20200925/utaddress-204)=0A=
[    6.457618] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver=0A=
[    6.467921] lpc_ich: Resource conflict(s) found affecting gpio_ich=0A=
[    6.474884] SCSI subsystem initialized=0A=
[    6.479470] PTP clock support registered=0A=
[    6.485016] dca service started, version 1.12.1=0A=
[    6.492023] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt=0A=
[    6.497973] i2c i2c-0: 1/19 memory slots populated (from DMI)=0A=
[    6.503786] i2c i2c-0: Systems with more than 4 memory slots not =
supported yet, not instantiating SPD=0A=
[    6.514560] mlx4_core: Mellanox ConnectX core driver v4.0-0=0A=
[    6.518372] libata version 3.00 loaded.=0A=
[    6.520250] mlx4_core: Initializing 0000:83:00.0=0A=
[    6.525212] Adaptec aacraid driver 1.2.1[50983]-custom=0A=
[    6.530560] aacraid 0000:84:00.0: can't disable ASPM; OS doesn't have =
ASPM control=0A=
[    6.538504] aacraid: Comm Interface enabled=0A=
[    6.539130] scsi host1: pata_jmicron=0A=
[    6.546932] scsi host2: pata_jmicron=0A=
[    6.550625] ata1: PATA max UDMA/100 cmd 0xd400 ctl 0xdc00 bmdma =
0xd480 irq 16=0A=
[    6.557823] ata2: PATA max UDMA/100 cmd 0xd880 ctl 0xd800 bmdma =
0xd488 irq 16=0A=
[    6.570653] ACPI: bus type USB registered=0A=
[    6.574751] usbcore: registered new interface driver usbfs=0A=
[    6.580308] usbcore: registered new interface driver hub=0A=
[    6.582390] firewire_ohci 0000:06:05.0: added OHCI v1.10 device as =
card 0, 4 IR + 8 IT contexts, quirks 0x2=0A=
[    6.585697] usbcore: registered new device driver usb=0A=
[    6.601874] igb: Intel(R) Gigabit Ethernet Network Driver=0A=
[    6.607335] igb: Copyright (c) 2007-2014 Intel Corporation.=0A=
[    6.613591] ahci 0000:00:1f.2: version 3.0=0A=
[    6.613784] ahci 0000:00:1f.2: SSS flag set, parallel bus scan =
disabled=0A=
[    6.620498] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps =
0x3f impl SATA mode=0A=
[    6.628753] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo =
pio slum part ccc ems sxs =0A=
[    6.637940] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0A=
[    6.646318] ehci-pci: EHCI PCI platform driver=0A=
[    6.651214] uhci_hcd: USB Universal Host Controller Interface driver=0A=
[    6.651337] ehci-pci 0000:00:1a.7: EHCI Host Controller=0A=
[    6.662963] ehci-pci 0000:00:1a.7: new USB bus registered, assigned =
bus number 1=0A=
[    6.671133] ehci-pci 0000:00:1a.7: debug port 1=0A=
[    6.679627] ehci-pci 0000:00:1a.7: cache line size of 256 is not =
supported=0A=
[    6.686617] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfbeda000=0A=
[    6.706443] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00=0A=
[    6.712748] usb usb1: New USB device found, idVendor=3D1d6b, =
idProduct=3D0002, bcdDevice=3D 5.10=0A=
[    6.721090] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    6.728390] usb usb1: Product: EHCI Host Controller=0A=
[    6.733329] usb usb1: Manufacturer: Linux 5.10.0-11-amd64 ehci_hcd=0A=
[    6.739569] usb usb1: SerialNumber: 0000:00:1a.7=0A=
[    6.744499] scsi host3: ahci=0A=
[    6.746885] AAC0: kernel 5.2-0[18252] Nov 22 2010=0A=
[    6.747600] hub 1-0:1.0: USB hub found=0A=
[    6.752260] AAC0: monitor 5.2-0[18252]=0A=
[    6.752263] AAC0: bios 5.2-0[18252]=0A=
[    6.756096] hub 1-0:1.0: 6 ports detected=0A=
[    6.759908] AAC0: serial 2D0611E69DA=0A=
[    6.763485] scsi host4: ahci=0A=
[    6.767539] AAC0: Non-DASD support enabled.=0A=
[    6.767542] AAC0: 64bit support enabled.=0A=
[    6.771408] uhci_hcd 0000:00:1a.0: UHCI Host Controller=0A=
[    6.774140] aacraid 0000:84:00.0: 64 Bit DAC enabled=0A=
[    6.778390] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned =
bus number 2=0A=
[    6.791513] scsi host0: aacraid=0A=
[    6.792731] uhci_hcd 0000:00:1a.0: detected 2 ports=0A=
[    6.800710] scsi 0:0:0:0: Direct-Access     Adaptec  ROOT             =
V1.0 PQ: 0 ANSI: 2=0A=
[    6.802365] tsc: Refined TSC clocksource calibration: 2666.761 MHz=0A=
[    6.802694] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: =
0x267097056f1, max_idle_ns: 440795291489 ns=0A=
[    6.832940] clocksource: Switched to clocksource tsc=0A=
[    6.832965] scsi host5: ahci=0A=
[    6.840919] random: fast init done=0A=
[    6.843472] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009c00=0A=
[    6.850691] scsi host6: ahci=0A=
[    6.853645] igb 0000:01:00.0: added PHC on eth0=0A=
[    6.858239] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network =
Connection=0A=
[    6.865219] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) =
00:25:90:6a:6c:5c=0A=
[    6.872712] igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF=0A=
[    6.877921] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), =
8 tx queue(s)=0A=
[    6.885809] usb usb2: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001, bcdDevice=3D 5.10=0A=
[    6.894169] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    6.901469] usb usb2: Product: UHCI Host Controller=0A=
[    6.906410] usb usb2: Manufacturer: Linux 5.10.0-11-amd64 uhci_hcd=0A=
[    6.912650] usb usb2: SerialNumber: 0000:00:1a.0=0A=
[    6.917353] scsi host7: ahci=0A=
[    6.921149] scsi host8: ahci=0A=
[    6.924239] ata3: SATA max UDMA/133 abar m2048@0xfbed2000 port =
0xfbed2100 irq 42=0A=
[    6.931829] ata4: SATA max UDMA/133 abar m2048@0xfbed2000 port =
0xfbed2180 irq 42=0A=
[    6.939300] ata5: SATA max UDMA/133 abar m2048@0xfbed2000 port =
0xfbed2200 irq 42=0A=
[    6.946770] ata6: SATA max UDMA/133 abar m2048@0xfbed2000 port =
0xfbed2280 irq 42=0A=
[    6.954241] ata7: SATA max UDMA/133 abar m2048@0xfbed2000 port =
0xfbed2300 irq 42=0A=
[    6.961710] ata8: SATA max UDMA/133 abar m2048@0xfbed2000 port =
0xfbed2380 irq 42=0A=
[    6.969242] hub 2-0:1.0: USB hub found=0A=
[    6.975745] hub 2-0:1.0: 2 ports detected=0A=
[    6.979934] ehci-pci 0000:00:1d.7: EHCI Host Controller=0A=
[    6.983183] scsi 0:3:0:0: Enclosure         ADAPTEC  Virtual SGPIO  0 =
0001 PQ: 0 ANSI: 5=0A=
[    6.985236] ehci-pci 0000:00:1d.7: new USB bus registered, assigned =
bus number 3=0A=
[    7.000934] ehci-pci 0000:00:1d.7: debug port 1=0A=
[    7.010098] ehci-pci 0000:00:1d.7: cache line size of 256 is not =
supported=0A=
[    7.017057] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfbed8000=0A=
[    7.042454] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00=0A=
[    7.048338] usb usb3: New USB device found, idVendor=3D1d6b, =
idProduct=3D0002, bcdDevice=3D 5.10=0A=
[    7.056680] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    7.063980] usb usb3: Product: EHCI Host Controller=0A=
[    7.068919] usb usb3: Manufacturer: Linux 5.10.0-11-amd64 ehci_hcd=0A=
[    7.075163] usb usb3: SerialNumber: 0000:00:1d.7=0A=
[    7.080074] hub 3-0:1.0: USB hub found=0A=
[    7.083900] hub 3-0:1.0: 6 ports detected=0A=
[    7.084120] Emulex LightPulse Fibre Channel SCSI driver 12.8.0.4=0A=
[    7.088157] uhci_hcd 0000:00:1a.1: UHCI Host Controller=0A=
[    7.094039] Copyright (C) 2017-2019 Broadcom. All Rights Reserved. =
The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.=0A=
[    7.111605] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned =
bus number 4=0A=
[    7.119383] uhci_hcd 0000:00:1a.1: detected 2 ports=0A=
[    7.122494] firewire_core 0000:06:05.0: created device fw0: GUID =
003048000020d1aa, S400=0A=
[    7.124386] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880=0A=
[    7.138240] usb usb4: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001, bcdDevice=3D 5.10=0A=
[    7.146579] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    7.153872] usb usb4: Product: UHCI Host Controller=0A=
[    7.158811] usb usb4: Manufacturer: Linux 5.10.0-11-amd64 uhci_hcd=0A=
[    7.165054] usb usb4: SerialNumber: 0000:00:1a.1=0A=
[    7.173048] hub 4-0:1.0: USB hub found=0A=
[    7.177322] hub 4-0:1.0: 2 ports detected=0A=
[    7.181408] igb 0000:01:00.1: added PHC on eth1=0A=
[    7.185998] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network =
Connection=0A=
[    7.192937] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) =
00:25:90:6a:6c:5d=0A=
[    7.200212] igb 0000:01:00.1: eth1: PBA No: FFFFFF-0FF=0A=
[    7.205412] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), =
8 tx queue(s)=0A=
[    7.214264] scsi host9: Emulex LPe12000 PCIe Fibre Channel Adapter on =
PCI bus 02 device 00 irq 16=0A=
[    7.281396] ata3: SATA link down (SStatus 0 SControl 300)=0A=
[    7.326152] uhci_hcd 0000:00:1a.2: UHCI Host Controller=0A=
[    7.331464] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned =
bus number 5=0A=
[    7.338942] uhci_hcd 0000:00:1a.2: detected 2 ports=0A=
[    7.343918] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009800=0A=
[    7.349778] usb usb5: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001, bcdDevice=3D 5.10=0A=
[    7.358117] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    7.365413] usb usb5: Product: UHCI Host Controller=0A=
[    7.370352] usb usb5: Manufacturer: Linux 5.10.0-11-amd64 uhci_hcd=0A=
[    7.376594] usb usb5: SerialNumber: 0000:00:1a.2=0A=
[    7.381520] hub 5-0:1.0: USB hub found=0A=
[    7.385348] hub 5-0:1.0: 2 ports detected=0A=
[    7.389737] uhci_hcd 0000:00:1d.0: UHCI Host Controller=0A=
[    7.395039] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned =
bus number 6=0A=
[    7.402553] uhci_hcd 0000:00:1d.0: detected 2 ports=0A=
[    7.407508] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009480=0A=
[    7.413366] usb usb6: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001, bcdDevice=3D 5.10=0A=
[    7.421707] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    7.429003] usb usb6: Product: UHCI Host Controller=0A=
[    7.433940] usb usb6: Manufacturer: Linux 5.10.0-11-amd64 uhci_hcd=0A=
[    7.440181] usb usb6: SerialNumber: 0000:00:1d.0=0A=
[    7.444979] hub 6-0:1.0: USB hub found=0A=
[    7.448794] hub 6-0:1.0: 2 ports detected=0A=
[    7.453288] uhci_hcd 0000:00:1d.1: UHCI Host Controller=0A=
[    7.458583] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned =
bus number 7=0A=
[    7.466063] uhci_hcd 0000:00:1d.1: detected 2 ports=0A=
[    7.471016] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400=0A=
[    7.476870] usb usb7: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001, bcdDevice=3D 5.10=0A=
[    7.485210] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    7.492504] usb usb7: Product: UHCI Host Controller=0A=
[    7.497441] usb usb7: Manufacturer: Linux 5.10.0-11-amd64 uhci_hcd=0A=
[    7.503683] usb usb7: SerialNumber: 0000:00:1d.1=0A=
[    7.508489] hub 7-0:1.0: USB hub found=0A=
[    7.512340] hub 7-0:1.0: 2 ports detected=0A=
[    7.516830] uhci_hcd 0000:00:1d.2: UHCI Host Controller=0A=
[    7.522128] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned =
bus number 8=0A=
[    7.529628] uhci_hcd 0000:00:1d.2: detected 2 ports=0A=
[    7.534613] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009080=0A=
[    7.540484] usb usb8: New USB device found, idVendor=3D1d6b, =
idProduct=3D0001, bcdDevice=3D 5.10=0A=
[    7.548824] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1=0A=
[    7.556116] usb usb8: Product: UHCI Host Controller=0A=
[    7.561058] usb usb8: Manufacturer: Linux 5.10.0-11-amd64 uhci_hcd=0A=
[    7.567300] usb usb8: SerialNumber: 0000:00:1d.2=0A=
[    7.572124] hub 8-0:1.0: USB hub found=0A=
[    7.575952] hub 8-0:1.0: 2 ports detected=0A=
[    7.698444] usb 5-2: new full-speed USB device number 2 using uhci_hcd=0A=
[    7.896851] usb 5-2: New USB device found, idVendor=3D046b, =
idProduct=3Dff10, bcdDevice=3D 1.00=0A=
[    7.905136] usb 5-2: New USB device strings: Mfr=3D1, Product=3D2, =
SerialNumber=3D3=0A=
[    7.912327] usb 5-2: Product: Virtual Keyboard and Mouse=0A=
[    7.917698] usb 5-2: Manufacturer: American Megatrends Inc.=0A=
[    7.923331] usb 5-2: SerialNumber: serial=0A=
[    7.975365] hid: raw HID events driver (C) Jiri Kosina=0A=
[    7.992982] usbcore: registered new interface driver usbhid=0A=
[    7.998649] usbhid: USB HID core driver=0A=
[    8.004805] input: American Megatrends Inc. Virtual Keyboard and =
Mouse as =
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/0003:046B:FF10.0001/inp=
ut/input3=0A=
[    8.019160] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID =
v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on =
usb-0000:00:1a.2-2/input0=0A=
[    8.034195] input: American Megatrends Inc. Virtual Keyboard and =
Mouse as =
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/0003:046B:FF10.0002/inp=
ut/input4=0A=
[    8.048543] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID =
v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on =
usb-0000:00:1a.2-2/input1=0A=
[    8.860899] mlx4_core 0000:83:00.0: 32.000 Gb/s available PCIe =
bandwidth (5.0 GT/s PCIe x8 link)=0A=
[    9.074085] <mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX =
InfiniBand driver v4.0-0=0A=
[    9.082758] <mlx4_ib> mlx4_ib_add: counter index 0 for port 1 =
allocated 0=0A=
[    9.568097] scsi host10: Emulex LPe12000 PCIe Fibre Channel Adapter =
on PCI bus 02 device 01 irq 17=0A=
[   11.836156] scsi host11: Emulex LPe12000 PCIe Fibre Channel Adapter =
on PCI bus 85 device 00 irq 16=0A=
[   14.104122] scsi host12: Emulex LPe12000 PCIe Fibre Channel Adapter =
on PCI bus 85 device 01 irq 17=0A=
[   36.107674] scsi 0:3:1:0: Enclosure         ADAPTEC  Virtual SGPIO  1 =
0001 PQ: 0 ANSI: 5=0A=
[   65.163347] ses 0:3:0:0: Attached Enclosure device=0A=
[   65.168240] ses 0:3:1:0: Attached Enclosure device=0A=
[   65.215668] scsi 0:0:0:0: Attached scsi generic sg0 type 0=0A=
[   65.221384] ses 0:3:0:0: Attached scsi generic sg1 type 13=0A=
[   65.227084] ses 0:3:1:0: Attached scsi generic sg2 type 13=0A=
[   65.227216] sd 0:0:0:0: [sda] 975153152 512-byte logical blocks: (499 =
GB/465 GiB)=0A=
[   65.240256] sd 0:0:0:0: [sda] Write Protect is off=0A=
[   65.245132] sd 0:0:0:0: [sda] Mode Sense: 12 00 10 08=0A=
[   65.245147] sd 0:0:0:0: [sda] Write cache: disabled, read cache: =
enabled, supports DPO and FUA=0A=
[   65.310353]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >=0A=
[   65.330542] sd 0:0:0:0: [sda] Attached SCSI removable disk=0A=
[   65.469563] ata4: SATA link down (SStatus 0 SControl 300)=0A=
[   65.789599] ata5: SATA link down (SStatus 0 SControl 300)=0A=
[   66.109825] ata6: SATA link down (SStatus 0 SControl 300)=0A=
[   66.429838] ata7: SATA link down (SStatus 0 SControl 300)=0A=
[   66.749821] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0A=
[   66.760943] ata8.00: ATAPI: TEAC    DV-W28S-V, 1.0A, max UDMA/100=0A=
[   66.772859] ata8.00: configured for UDMA/100=0A=
[   66.782398] scsi 8:0:0:0: CD-ROM            TEAC     DV-W28S-V        =
1.0A PQ: 0 ANSI: 5=0A=
[   66.820588] scsi 8:0:0:0: Attached scsi generic sg3 type 5=0A=
[   66.857354] sr 8:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram =
cd/rw xa/form2 cdda tray=0A=
[   66.866116] cdrom: Uniform CD-ROM driver Revision: 3.20=0A=
[   66.934505] sr 8:0:0:0: Attached scsi CD-ROM sr0=0A=
[  192.728216] EXT4-fs (sda1): mounted filesystem with ordered data =
mode. Opts: (null)=0A=
[  192.858983] Not activating Mandatory Access Control as =
/sbin/tomoyo-init does not exist.=0A=
[  193.090831] random: crng init done=0A=
[  193.094299] random: 2 urandom warning(s) missed due to ratelimiting=0A=
[  193.739513] udevd[722]: starting version 3.2.9=0A=
[  193.870933] udevd[723]: starting eudev-3.2.9=0A=
[  194.041886] ioatdma: Intel(R) QuickData Technology Driver 5.00=0A=
[  194.042237] EDAC MC1: Giving out device to module i7core_edac.c =
controller i7 core #1: DEV 0000:fe:03.0 (INTERRUPT)=0A=
[  194.058349] EDAC PCI0: Giving out device to module i7core_edac =
controller EDAC PCI controller: DEV 0000:fe:03.0 (POLLED)=0A=
[  194.069399] EDAC MC0: Giving out device to module i7core_edac.c =
controller i7 core #0: DEV 0000:ff:03.0 (INTERRUPT)=0A=
[  194.079925] EDAC PCI1: Giving out device to module i7core_edac =
controller EDAC PCI controller: DEV 0000:ff:03.0 (POLLED)=0A=
[  194.090912] EDAC i7core: Driver loaded, 2 memory controller(s) found.=0A=
[  194.111034] igb 0000:01:00.0: DCA enabled=0A=
[  194.115136] igb 0000:01:00.1: DCA enabled=0A=
[  194.228177] ioatdma 0000:80:16.0: APICID_TAG_MAP set incorrectly by =
BIOS, disabling DCA=0A=
[  194.346851] input: Power Button as =
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input5=0A=
[  194.370486] ACPI: Power Button [PWRB]=0A=
[  194.374306] input: Power Button as =
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input6=0A=
[  194.381896] ACPI: Power Button [PWRF]=0A=
[  194.476075] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC888: =
line_outs=3D4 (0x14/0x15/0x16/0x17/0x0) type:line=0A=
[  194.486764] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0 =
(0x0/0x0/0x0/0x0/0x0)=0A=
[  194.494753] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1 =
(0x1b/0x0/0x0/0x0/0x0)=0A=
[  194.502395] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0=0A=
[  194.508810] snd_hda_codec_realtek hdaudioC0D0:    inputs:=0A=
[  194.514346] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=3D0x19=0A=
[  194.520605] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=3D0x18=0A=
[  194.526759] snd_hda_codec_realtek hdaudioC0D0:      Line=3D0x1a=0A=
[  194.549170] input: HDA Digital PCBeep as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7=0A=
[  194.557757] input: HDA Intel Front Mic as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8=0A=
[  194.566555] input: HDA Intel Rear Mic as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9=0A=
[  194.575181] input: HDA Intel Line as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10=0A=
[  194.583564] input: HDA Intel Line Out Front as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11=0A=
[  194.592770] input: HDA Intel Line Out Surround as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12=0A=
[  194.602273] input: HDA Intel Line Out CLFE as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13=0A=
[  194.611404] input: HDA Intel Line Out Side as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14=0A=
[  194.620545] input: HDA Intel Front Headphone as =
/devices/pci0000:00/0000:00:1b.0/sound/card0/input15=0A=
[  194.695038] iTCO_vendor_support: vendor-support=3D0=0A=
[  194.787591] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11=0A=
[  194.793309] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled =
by hardware/BIOS=0A=
[  194.834961] input: PC Speaker as =
/devices/platform/pcspkr/input/input16=0A=
[  194.852054] mgag200 0000:06:04.0: vgaarb: deactivate vga console=0A=
[  194.860797] Console: switching to colour dummy device 80x25=0A=
[  194.866711] IPMI message handler: version 39.2=0A=
[  194.872887] [drm] Initialized mgag200 1.0.0 20110418 for 0000:06:04.0 =
on minor 0=0A=
[  194.882268] fbcon: mgag200drmfb (fb0) is primary device=0A=
[  195.233292] ipmi device interface=0A=
[  195.249088] ipmi_si: IPMI System Interface driver=0A=
[  195.249103] ipmi_si dmi-ipmi-si.0: ipmi_platform: probing via SMBIOS=0A=
[  195.249106] ipmi_platform: ipmi_si: SMBIOS: io 0xca2 regsize 1 =
spacing 1 irq 0=0A=
[  195.249107] ipmi_si: Adding SMBIOS-specified kcs state machine=0A=
[  195.249186] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o =
address 0xca2, slave address 0x20, irq 0=0A=
[  195.297988] Console: switching to colour frame buffer device 128x48=0A=
[  195.393684] mgag200 0000:06:04.0: [drm] fb0: mgag200drmfb frame =
buffer device=0A=
[  195.581017] ipmi_si dmi-ipmi-si.0: IPMI message handler: Found new =
BMC (man_id: 0x00b980, prod_id: 0xaabb, dev_id: 0x20)=0A=
[  195.714383] ipmi_si dmi-ipmi-si.0: IPMI kcs interface initialized=0A=
[  196.990459] Adding 999420k swap on /dev/sda6.  Priority:-2 extents:1 =
across:999420k FS=0A=
[  197.028353] EXT4-fs (sda1): re-mounted. Opts: errors=3Dremount-ro=0A=
[  197.458940] igb 0000:01:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps =
Full Duplex, Flow Control: RX=0A=
[  197.470008] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready=0A=
[  197.470579] EXT4-fs (sda8): mounted filesystem with ordered data =
mode. Opts: (null)=0A=
[  197.488242] EXT4-fs (sda7): mounted filesystem with ordered data =
mode. Opts: (null)=0A=
[  197.507940] EXT4-fs (sda5): mounted filesystem with ordered data =
mode. Opts: (null)=0A=
[  197.952446] audit: type=3D1400 audit(1644923889.920:2): =
apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined" =
name=3D"lsb_release" pid=3D1402 comm=3D"apparmor_parser"=0A=
[  197.970268] audit: type=3D1400 audit(1644923889.924:3): =
apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined" =
name=3D"nvidia_modprobe" pid=3D1401 comm=3D"apparmor_parser"=0A=
[  197.970271] audit: type=3D1400 audit(1644923889.924:4): =
apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined" =
name=3D"nvidia_modprobe//kmod" pid=3D1401 comm=3D"apparmor_parser"=0A=
=0A=

------=_NextPart_001_0007_01D82419.20CC1E60--

------=_NextPart_000_0006_01D82419.20CC1E60
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCDqEw
ggN3MIICX6ADAgECAghcM8tiLF+zMjANBgkqhkiG9w0BAQsFADA8MR4wHAYDVQQDDBVBdG9zIFRy
dXN0ZWRSb290IDIwMTExDTALBgNVBAoMBEF0b3MxCzAJBgNVBAYTAkRFMB4XDTExMDcwNzE0NTgz
MFoXDTMwMTIzMTIzNTk1OVowPDEeMBwGA1UEAwwVQXRvcyBUcnVzdGVkUm9vdCAyMDExMQ0wCwYD
VQQKDARBdG9zMQswCQYDVQQGEwJERTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJWF
O5dvKjsuO8+m8yk1vs8YrD6q2fhNoD4aR7m8mt/y/sw+R+h6lsIkjjX0qQz8gv1twXJiJ73qa+vn
isxUPpBQz4DUlfvotYLUFMW2qVUlV9uxUPawYGRZemnPA7dvDb7KPm90cuqqMCpzYr5JkWHIEf4O
Ayr3aiDcAhUNXhVq/OOCwbXFnWQJbKNZmAcnxxuWK2F0cWxD8fc1iRDgnuxVoTcioocEBSxHfbQc
uWIpZijKt+GT9aSUA5m5cIW15kjqjVD82d7MbwcO3QtynYAwFgeVPygO/cV1T1PWdJq0JC6OApHP
dsWbHlV0nHghsfAt8QufwtWWGB/wVCJ6jAcCAwEAAaN9MHswHQYDVR0OBBYEFKelBrEspglg7tGX
6XCuvDsZbNshMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUp6UGsSymCWDu0ZfpcK68Oxls
2yEwGAYDVR0gBBEwDzANBgsrBgEEAbAtAwQBATAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQEL
BQADggEBACZ3NNuUSIYqQZ0sPgaQYMSMrAtUuB+5e9MHOeT6PnuyPU7tnyO9l/NrXO/u/UCm36GT
oQqGrO8g0HkBvXj3GdgkMTQEAaa6FZrDJ9zYTw/MGGP/mQ8OkWt1FuEh/Ngmx0e3ps9YcnF+uuFN
lUc7ya9tobTB7In2tA84teJk3CXPptvrmlyZocUI3v3m2tXWWkUMxLfCtRTvtBH/DhW19fXbxr3r
WqfwViKpPGVUxhWovYaezYOWaHpxgYnhC+HqERtoCMxpnuyeQZ5EMiZ64ocKcT3r5Fqk0tvFzcbe
YH+5809Eku8qtxg+pxnZC32xN0FCsLpgHfL+CRGw8Id7p50wggWNMIIEdaADAgECAhBrhytugdj1
rTx9ZBbrdAaBMA0GCSqGSIb3DQEBCwUAMDwxHjAcBgNVBAMMFUF0b3MgVHJ1c3RlZFJvb3QgMjAx
MTENMAsGA1UECgwEQXRvczELMAkGA1UEBhMCREUwHhcNMjAwNzA3MDYxOTQxWhcNMzAwNzA1MDYx
OTQxWjBGMSgwJgYDVQQDDB9BdG9zIFRydXN0ZWRSb290IENsaWVudC1DQSAyMDIwMQ0wCwYDVQQK
DARBdG9zMQswCQYDVQQGEwJERTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ/hXVnK
eLT2R+nYje6VItqb526PEFVU97bi+VxfeZ2T6hJK6xLQpLOt5GZEMfRXNpL2GJzzkJ6ZVMf6N/I0
0UHGFdraQovJ23XLG0ndNEUAxFQRYrlpWQqRXuDXTWfo7zZtbkzs9rGeUvBvoLv5fCWkofMxpKaI
EU6IEwLEk/QAYHSGBT4XReG83BA/5bHiurq/ubkMmrHyqh7SfID504QMkmI4XujffSF7ZCRuQDOD
F3QyhD5P2KBotqNLDLDDEam4oT9W3/L9gLTbmFZhLqG3AV4mq1yNZK0qIg26o4sFB4j6isCDecbJ
Bo+GnqHmAiUo7ixoTJ7opoVgFhaK4scCAwEAAaOCAn8wggJ7MBIGA1UdEwEB/wQIMAYBAf8CAQAw
HwYDVR0jBBgwFoAUp6UGsSymCWDu0ZfpcK68Oxls2yEwdgYIKwYBBQUHAQEEajBoMEAGCCsGAQUF
BzAChjRodHRwOi8vcGtpLmF0b3MubmV0L0Rvd25sb2FkL0F0b3NUcnVzdGVkUm9vdDIwMTEuY2Vy
MCQGCCsGAQUFBzABhhhodHRwOi8vcGtpLW9jc3AuYXRvcy5uZXQwRQYDVR0gBD4wPDA6BgwrBgEE
AbAtBQEBAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5hdG9zLm5ldC9Eb3dubG9hZDBCBgNV
HSUEOzA5BggrBgEFBQcDAgYIKwYBBQUHAwQGCysGAQQBgjcKAwQBBgorBgEEAYI3CgMEBgorBgEE
AYI3FAICMIIBEAYDVR0fBIIBBzCCAQMwgcCgfKB6hnhsZGFwOi8vcGtpLWxkYXAuYXRvcy5uZXQv
Y249QXRvcyUyMFRydXN0ZWRSb290JTIwMjAxMSxvdT1DQSxvdT1BdG9zJTIwVEMsbz1BdG9zLGRj
PWF0b3MsZGM9bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3SiQKQ+MDwxHjAcBgNVBAMMFUF0
b3MgVHJ1c3RlZFJvb3QgMjAxMTENMAsGA1UECgwEQXRvczELMAkGA1UEBhMCREUwPqA8oDqGOGh0
dHA6Ly9wa2ktY3JsLmF0b3MubmV0L2NybC9BdG9zX1RydXN0ZWRSb290X0NBXzIwMTEuY3JsMB0G
A1UdDgQWBBSJz+t9je9IMUdG/kuzbXpUo+OtAzAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQEL
BQADggEBAEL1mCTb3XhnVb4pB1WPvPoxzdS1HmUN8nKwoqJdSQdRrS/fWFFzKt1eylfF10F1pEB1
AiXz9LoBH3InS8yzOqqkTsK/TF7CSXH+NpXpmmiV7NR7HR3HbFRbu4BwtJfeLFd+4gE7jPOEk9VH
NWIrgaZ66pWdy4NwYX748HXHWs/DNz3cGmRbnXHR7+DnNOs5HkEy384+/V2U4TEO6ehPVXsL4vH7
6p99+1WW7s2YbPuigzwKi9OZ0Gi7ycvUyaq3Wxtdu8oJaSDwpIqkYyQ4n5khqBjIUqNtxCtgHCZe
4YyRYd9LFS7dagaEiu0np9YzdnI3vxobTsXHuSIkPJXX3TYwggWRMIIEeaADAgECAgxr9J2FnUck
pzat9xEwDQYJKoZIhvcNAQELBQAwRjEoMCYGA1UEAwwfQXRvcyBUcnVzdGVkUm9vdCBDbGllbnQt
Q0EgMjAyMDENMAsGA1UECgwEQXRvczELMAkGA1UEBhMCREUwHhcNMjExMDA2MDcyMjA2WhcNMjMx
MTI1MDcyMjA1WjB+MQswCQYDVQQGEwJGUjENMAsGA1UECgwEQXRvczEaMBgGA1UEBAwRR0lSQVVE
RUFVLUJPQ1FVRVQxDzANBgNVBCoMBkxJT05FTDEQMA4GA1UEBRMHQTQ1Mjg5NjEhMB8GA1UEAwwY
TElPTkVMIEdJUkFVREVBVS1CT0NRVUVUMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
rSV2Cn/k3Qp8/mC6y6bPJPjyqPX9JsdE1FecgA7zXLEzhRxs45iuv3z/6XRE4sC/+VtTXl+qb8T8
KKPiRnFfy2Bo/fRd/h0/to1Mdyrah+RowIlcyd5KD7PHtnF5MlaAXIksB6rDjeShPGxzHSqLWxct
I8ohlCIJ5Uacm2mihoA0bnf5aFLOq9IfEynuS/OP7Gux5lSwOKPhUqyDoke+7wDb7LgosVBh3Sxr
7DLlbE1Nrbvxil3Px/LPt2KtTk4jZAljg9p2UwwDLmX1OcfosUJXKgU5KQE9nKCL4gEpSsfBn1VP
iA/bU4BXlIw9NK0/pWInw5dSA+rBoUDaw69B9QIDAQABo4ICRTCCAkEwDAYDVR0TAQH/BAIwADAf
BgNVHSMEGDAWgBSJz+t9je9IMUdG/kuzbXpUo+OtAzB+BggrBgEFBQcBAQRyMHAwSAYIKwYBBQUH
MAKGPGh0dHA6Ly9wa2kuYXRvcy5uZXQvRG93bmxvYWQvQXRvc1RydXN0ZWRSb290Q2xpZW50Q0Ey
MDIwLmNlcjAkBggrBgEFBQcwAYYYaHR0cDovL3BraS1vY3NwLmF0b3MubmV0MCQGA1UdEQQdMBuB
GWxpb25lbC5naXJhdWRlYXVAYXRvcy5uZXQwQQYDVR0gBDowODA2BgwrBgEEAbAtBQEBAQEwJjAk
BggrBgEFBQcCARYYaHR0cHM6Ly9wa2kuYXRvcy5uZXQvQ1BTMBMGA1UdJQQMMAoGCCsGAQUFBwME
MIHiBgNVHR8EgdowgdcwRaBDoEGGP2h0dHA6Ly9wa2ktY3JsLmF0b3MubmV0L2NybC9BdG9zX1Ry
dXN0ZWRSb290X0NsaWVudF9DQV8yMDIwLmNybDCBjaCBiqCBh4aBhGxkYXA6Ly9wa2ktbGRhcC5h
dG9zLm5ldC9jbj1BdG9zJTIwVHJ1c3RlZFJvb3QlMjBDbGllbnQtQ0ElMjAyMDIwLG91PUNBLG91
PUF0b3MlMjBUQyxvPUF0b3MsZGM9YXRvcyxkYz1uZXQ/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlz
dDAdBgNVHQ4EFgQUARbvoIJKObYfYsZrlZ/98W9aP/4wDgYDVR0PAQH/BAQDAgWgMA0GCSqGSIb3
DQEBCwUAA4IBAQAxM8SREmxEtXevAOPtlByfL++ozZe/ptbDPFNV+YOQIetbdOoGc0e0ruCpKvZC
TkvooDZp9flRJ/AiII/XbxFv9RsVDaMZr2jsjog8lRrBo1HPY73W/rTVZJOdFopSLx60apb2ToRS
JCcR9hlUw7d1y81af+xy3i3eB12iNTRuEbHa74tlFXGYrhUtLrHk5KXJ3DVrgHtE+K6H8GViEd7F
MgUsrv3Nnh8mZ3wIXhv2ZzakC8+9gT9EpHEu22sw+aQSohigJLWky7yVzLPDqVYGoCLqgR/CmdtK
lbhgJqs3pLQY73j/tlJs2Ez9ynVaeDYq+5VToi5T+TU1uprx13MLMYIDVDCCA1ACAQEwVjBGMSgw
JgYDVQQDDB9BdG9zIFRydXN0ZWRSb290IENsaWVudC1DQSAyMDIwMQ0wCwYDVQQKDARBdG9zMQsw
CQYDVQQGEwJERQIMa/SdhZ1HJKc2rfcRMA0GCWCGSAFlAwQCAQUAoIIBzzAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjAyMTcxNTEyMTVaMC8GCSqGSIb3DQEJBDEi
BCCiEyS4De+CE/SrAOBfgtlFx6U3h5ozD3Oq2GbjQud6ozBlBgkrBgEEAYI3EAQxWDBWMEYxKDAm
BgNVBAMMH0F0b3MgVHJ1c3RlZFJvb3QgQ2xpZW50LUNBIDIwMjAxDTALBgNVBAoMBEF0b3MxCzAJ
BgNVBAYTAkRFAgxr9J2FnUckpzat9xEwZwYLKoZIhvcNAQkQAgsxWKBWMEYxKDAmBgNVBAMMH0F0
b3MgVHJ1c3RlZFJvb3QgQ2xpZW50LUNBIDIwMjAxDTALBgNVBAoMBEF0b3MxCzAJBgNVBAYTAkRF
Agxr9J2FnUckpzat9xEwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwCwYJYIZIAWUDBAIBMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgIwBwYFKw4DAhowDQYJKoZI
hvcNAQEBBQAEggEAP8qnmVRPcNJZvCkSXbyEQM3rNMjNh8TTQD3en1GczbKfR/CYteO9f3LDvvTp
jy1zybqsq9k9sv0p9P2XOJh8+5xKkGtMo/RiMMTQ0agYe8OyEbcdFBeFmyPlYjIyzQctJB1StExG
WDhGMt4b1DQbPJj/dbTAx9i/yBQgj/83I5J8mnCYiYpYCPE7wC4aup5vcG5RvCIX3mkrcX03nYs/
BOG135sMVm8bOIBEVgL2tyb3NFaHqQOGVFnU4FJsWJVp5qaL96RZlSDhpTlXLO6VzEeT+bfpNo8b
hN4+cLewqS7W2dwDZfFFKM9f/1y/GsZ9K2OMd+54zDGNzLubqcLvLAAAAAAAAA==

------=_NextPart_000_0006_01D82419.20CC1E60--
