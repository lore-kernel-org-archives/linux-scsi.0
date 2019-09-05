Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A455C41514
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116C3208E4
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OG7TLAGp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Z0LCIScI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbfIEEaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:30:39 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49085 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfIEEaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657838; x=1599193838;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ym8mqyJA38G31WMTpJxRxGcOovRBhTSMWcqct5LY0pY=;
  b=OG7TLAGpt6hwMDcNZ2/HfZVlWV883oZbK+U+/MeN9ZNMpjsrDq3XNGK3
   ga7XV6jB7qkwTr6TbQU/VzqurdzHOwIS1R4Tu+WfZUdRXIzJp80ha+Kcs
   LZHnLofsVstyEMWlagdchZfvAMVq+uF4AedGVowpeUyrBj3326G2WfvW3
   D0Buu8rMBK0ymNLCo228rjj11oW+btwpgS5Znhj+oQ5V82S2+oymGdCHj
   2/FYNpZjWSCah7emKdkiUsqkXasZvbJGNPvRYHytq6IgqVLgAPHm/wOqY
   TIyn9cG5pdcYJ3C18pvDclIemgYnUxSPa0JFoN9iCcYL/sCDbf+NPdlNh
   Q==;
IronPort-SDR: /W6IYbHQXS38kX0SAuNYjWIRQs4IqRNvggpRmd4JOy6QqDuQTAdAbUXhTTHrgGxIOjYrhwqE8T
 UWHeRnJqmYAVA05+4Tu9GIM4qUMGgT5957IPe6yrlxjVsq89echqiS+TfL2wrZb9IMV7r6FbTi
 oTK2OmVLLyFfklYw53cBTLbzfSA5wWyyZ2axdZgioZ/G09Px7Q7azokEyI6cgkm6kzgTa+NtwS
 /1njGKl1d57P4e804Wl3Wbxb397drMV9K0kAzdlaxYKtJaL6HO8pVtXKE1mLbfRbn/RVsPJiGs
 5RI=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="117494111"
Received: from mail-by2nam03lp2056.outbound.protection.outlook.com (HELO NAM03-BY2-obe.outbound.protection.outlook.com) ([104.47.42.56])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:30:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5kTOkWW2MRzMMZ5F62a6lL7pbkOxR+2/lPKYtPr6I9q8uXeJmk8r2CoRI5wyo4ugvm+iFHP5zt8cEY4XMBBv/MtVJkZX0HIBPI9Jjinf4T0H3WFeSZDmKRm3RWwEowFLntZbyFEw6oTN0GbQjllmIAUi0SqQYOSgksN9HjcrtHiFBwf2PMDNcMmYyRcIqQkZ7qrq3pRYFyxPGINUD91CRq9pjFxpfrcxaQC4+SQD3ZZDJ0pMwGt7ybHUARvHBedrZ++btcRSnEarMwGQTXqn4rjtOZ14LvsttzMHsFfEsTuaHOdPUHgB5VTSNVCfM9AXC/1utzR05DoY0mcMYG0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9dn0blk9IAM1I4tctfERe6usAURzi97izBqf/OxVt0=;
 b=IUS3k3/8OQH4Bo7qguOHt0YGOL0oarBgMqPS12zHqFZ7h5j6PIrkmN7eqG4fTVdFGmuoMze0rKa/AXK/CHCoLrhpJB6ZVfqY4wd+q67jHAUM1gLqVsU9o1sqG5+V+igR6+S5HudXVMS4rX500x5cYZWfrCgK2oVxqSxLtXj5et0fLLb94qE+/ksUPTlx2rbVLlQJZBSQkcKG8Yv+ZFE4XVOOE3YKu3iXAdNZ7HCKqNO65GbRl2OZiI3cZjALB8iY7b2MVl9mkIs2d5KSS2B5cNRHzTGz66XxCqp+cqZhr6V2VIWv1L4V70xfpCcHVelbX/3Zu8TxGHEBn0OvxLzhQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9dn0blk9IAM1I4tctfERe6usAURzi97izBqf/OxVt0=;
 b=Z0LCIScIOf5yPTTLCFgYTnGq8EJEpwDbc1x/68KpKgIewRdCXGrmqs5zK9XrklRrbfxCLDlUiabItsqz4gIIt0tyAAgudxDhf4iVNbKrOrTSWIiao4Al7XZmISkIeaCXfijIx8RzICMm91GtDVPOlrLEi2RGj2AfBC6IhOMjRGg=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5174.namprd04.prod.outlook.com (20.178.49.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Thu, 5 Sep 2019 04:30:36 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10%5]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 04:30:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 5/7] block: Delay default elevator initialization
Thread-Topic: [PATCH v3 5/7] block: Delay default elevator initialization
Thread-Index: AQHVYvzHEKIbafAg9UipJ8XeLfwVBA==
Date:   Thu, 5 Sep 2019 04:30:36 +0000
Message-ID: <BYAPR04MB58166AA744FE3A240050BAC1E7BB0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
 <20190904084247.23338-6-damien.lemoal@wdc.com>
 <22bc754b-541d-3c72-6bb0-68cd841faee5@suse.de>
 <BYAPR04MB5816ADDE69D61A3CB47DCC3FE7B80@BYAPR04MB5816.namprd04.prod.outlook.com>
 <68bd56dd-46cf-efa3-14f2-4f8e50ac15c0@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6689d2a-0883-40c5-ed52-08d731b9cc9c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5174;
x-ms-traffictypediagnostic: BYAPR04MB5174:
x-microsoft-antispam-prvs: <BYAPR04MB5174C258C6410A314CE72538E7BB0@BYAPR04MB5174.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(189003)(199004)(52536014)(71200400001)(71190400001)(476003)(6246003)(486006)(25786009)(14454004)(8676002)(14444005)(256004)(53936002)(7736002)(305945005)(9686003)(74316002)(99286004)(55016002)(229853002)(446003)(6436002)(66946007)(66476007)(66556008)(64756008)(66446008)(66066001)(33656002)(26005)(7696005)(186003)(76116006)(6506007)(2906002)(2201001)(5660300002)(2501003)(8936002)(86362001)(102836004)(110136005)(3846002)(76176011)(53546011)(478600001)(6116002)(81156014)(4744005)(81166006)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5174;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hjuj+jonTiulxGOosta0RSUe+CDmbwPr8gIWAGCI/LDH6Oc3CEnwzLzAjvG014q48Nqm11FCzi0Shu3zYCrIiiN3yxRnA+CQWqrdwoouRjtjCayBupjv3ESXzs74GVBVJJwX1YX+qRAvlNOx87kC1di2Sh8l3XFplT6idlP5IV+IyxL/Qjm6SamUf7jDmkiS7XWoC6ygtj9N2xkPDmAM73YE19ZQSuVaiUeXHvOvyw9NsiUDbD4HPFck9WXwjlsbcpZk59FIRZh5euD9EqkEuF9pbMDdtfZBGWQJZ0UB8Yw8RdnwvfS7SxiOZDOcKDPGjHj6sOwdReHKA3QGyXcVxIj1c3XgtZ1r2CtIOqDIJ9HNbE6hlDm/dfwAYa1Gt158LiH9h+RBdhSz+lKoXTOwgVIfiwVYxoVAXK/oYOtgU/4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6689d2a-0883-40c5-ed52-08d731b9cc9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 04:30:36.6542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zu1ll2i348XW71LMTRfqN7qbj9YEQL1jVnFjqTS0qWZ4vfB65B/vUHySxAHil3wFE1DXx07Cx61p/fyeT/hSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/04 21:57, Jens Axboe wrote:=0A=
> On 9/4/19 3:02 AM, Damien Le Moal wrote:=0A=
>> On 2019/09/04 17:56, Johannes Thumshirn wrote:=0A=
>>> On 04/09/2019 10:42, Damien Le Moal wrote:=0A=
>>>> @@ -734,6 +741,7 @@ static void __device_add_disk(struct device *paren=
t, struct gendisk *disk,=0A=
>>>>   				    exact_match, exact_lock, disk);=0A=
>>>>   	}=0A=
>>>>   	register_disk(parent, disk, groups);=0A=
>>>> +=0A=
>>>>   	if (register_queue)=0A=
>>>>   		blk_register_queue(disk);=0A=
>>>=0A=
>>> That hunk looks unrelated, but anyways:=0A=
>>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>=0A=
>>=0A=
>> Oops. Yes, did not delete the blank line when I moved elevator_init_mq()=
 call.=0A=
>> Jens, should I resend a v4 to fix this ?=0A=
> =0A=
> Series looks good to me, I'll just delete this one hunk, not a big deal.=
=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
Thanks. But Ming's comment needed to be addressed, which I did in the V4 I =
just=0A=
sent out. I removed the white line chunk too.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
