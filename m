Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F60C433EC
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3CA20656
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n37XHtZP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IjHJiPSu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgF2SzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:55:06 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57273 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbgF2SzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593456906; x=1624992906;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ePFAFVLOzFSVrSavTTXb1e0G3zVyD5qJRsnoo6bUjCg=;
  b=n37XHtZPxeLE99686fEXrqXfcyQn+ULDcqGLrq+TCjs1fyRJsX2y2Tb3
   n29zLo8iwWR11rImuU7rO+QIqJZZLTNIgNCjtdcvCqlgXDyeSawPlo22+
   fCWQ3dG+t/fgJTtG1H04l7x6xanVEHGl4HhuPRhHsbrPcjWhk/iP5Ym9k
   CgFztW4L88MRH3O9H1XtU8kccZjn1KlMylrN1iBVrwYP3rFUGjYpBvJ2+
   hdMsV0mxQcTeXxGNSPvzEkDKq3/MxnyRi1gpufUIBl7ExlgM393AxrTuj
   38YHgbKucDvJVoNdFcu59o73Tsk+AG2cGHRVOAKf60z4nAfLfFcHtSP05
   g==;
IronPort-SDR: ZQ3ONEpYNv7HHwG3+IsEY3vYGbgwU2/YfRaD5xfdaJGVXhVloAFBypuZbkzbzmYcGsNEjDYGgx
 5lth9lSQaW6UTUhqr1CXdTYXqBd8v5NVpKE535M8LHoAAuYBYXHaNLLleePgL8RSm0L1P8AUTj
 1k4khsJDtqTtaBsaJyllhSXyQBEKpbOey9XsTxUX6lhTZLck7wMEdGOiQ6SlwOpbJ2iS32xL/x
 hlvQi/NaF9Y57thFPJvsBhmkOoBQjO2BEcdbwNIGx2aDQQ163BPsICYT8QmSc8TZvMcQcSCJtz
 evg=
X-IronPort-AV: E=Sophos;i="5.75,295,1589212800"; 
   d="scan'208";a="244213687"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 00:17:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4zEt7V1K+z7iRqC/KnOhObZaSZIkdMnfOocJx8b6diEmxpeJGv5SGAM4MRaoTRdYQQY1a/oZwnkAogY4y0TqhH7DY65caHB+ScOYg53grJZXsgsOryQhutNHxcUt8R3+jGypl5rtRM2JYDethIgjvu1sLgCIRSADHvZWx6ZfC2ups0vEIIfN3A/HJo+z4T+uJee1OPj2FnPPxw5C66QKOKW3GTwJALhFbboBP68GCZG7oSk/xxs8CbMNYngEtIIwAJRnPDvMV7mmoQbOMTeY5rSUYJ5gF08kjwePEcJ51tlasX8b/omAo/C/Ii9NMD1PcsRWF7IYNhEWZ2UORZtag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDmNtEYs6mwnVmGJXASRmSQGO7Qas5IA432EMhu6YQY=;
 b=SJ1SMhrXkdtD4NxjbyX9j0+x2ldPwwbT+N26gVy+PU4lWBlcYfhgAWNzxAp11qEN3Lp755HkiofBDVh5hF7Wfs64Hzc75YNQq7EtUf9HYtDipfHMDAcv03pjhZVqv0ppKNv+s1DitAjipL7OEcioC2MZYzBW3wD7O8Es99rvc0rGR6MDH2Kf7q9Z296fo0AvYMzAHLWLx2uvh0/NF1cpGWuYJTSSxxlVomRd5Z1ot8Joa4OG4h9J30sC9O+A6puXaE6E0yHuQNlz72d+TuFmkmZTy+ntqcTnmdQInEfMvOfTatcWx8gvAje8VWYnwXvMkkyoyP1fvAZ3z+yrJXxogg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDmNtEYs6mwnVmGJXASRmSQGO7Qas5IA432EMhu6YQY=;
 b=IjHJiPSu4wxmOsRD+m0Ejx933//L6lgX/gIeD5vRwQibfTeaSPdOaqKn7obs7Coq6pPoBo5zO7bBUC+y6cHvjMsCHtTu3ndm+gumNm/5vxWvLe7GJkBKyH5YrO5D79nrCpIlJmoRh8c7Gn7k1sb93Ts3XY8YTD9hqdtB4X2ncHg=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4237.namprd04.prod.outlook.com
 (2603:10b6:805:30::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 16:15:59 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 16:15:59 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] Make the scsi_init_io() documentation more accurate
Thread-Topic: [PATCH] Make the scsi_init_io() documentation more accurate
Thread-Index: AQHWTi8AwwuTe16HCUqQonN/9mpGIA==
Date:   Mon, 29 Jun 2020 16:15:58 +0000
Message-ID: <SN4PR0401MB3598D3C803375B92AD433D679B6E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200629160433.14390-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:8525:1965:641f:1b27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b6baa53-0c54-42ab-3eab-08d81c47b5c7
x-ms-traffictypediagnostic: SN6PR04MB4237:
x-microsoft-antispam-prvs: <SN6PR04MB42379EF3788A8B65343CE4D79B6E0@SN6PR04MB4237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v0g0ZrB2fNz7IO6v7iG5fguhDadyFLQ+674EZZSR2NjpPe4hkeLVCPuFDdeNwIbRJS7ca41kyFSpcgzpEMNRvu2UoWT/fJRVI5lACWSj+l1trTDoQbtPi5nREMKFIEufGarbwRCJVKHM0MTMzyqSzvFK/xIONEy7klGYwaoNhykK7OXgJQ55lqju0mvEj+NicLUXBsRDQPeUK3bgxOHxWjpVGrXfUZfYcZy6ICosLf1n2FVJb1ZPU/PVIH73ed8IQZpIlSo0G6KHpAj8tV+oQCcn1JmwNM14kjEz68QUQMi03r5xUBkFhcQ2bsGJRqrl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(52536014)(7696005)(86362001)(2906002)(53546011)(6506007)(4326008)(478600001)(186003)(5660300002)(558084003)(71200400001)(55016002)(9686003)(54906003)(110136005)(64756008)(66556008)(66946007)(66476007)(8936002)(66446008)(8676002)(316002)(33656002)(76116006)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zjwrrbF3VrSxjbcAX9BFTPwCf6dikXQqTcdvVHJWTCQj5JkTZM8MIcXRfadUUoVvM+7JjJrmZx0CXCReUtmcYtopgY5+jRDRlH19fDLBSLhi8pLBldIplL8FDEIcYu0MNcx3NO11GEZbfMt218vOQYzTsjq6Pm4ItUOtOSrbP1oyN1COP7P/GFWxKBUOXNXa5Jcmr1XL9L0ytBe3ny0aXPjxL2MgNaHNL+0uJ+Xh+M8QVEhy+S1SWEZ2psoPhnFYrioSXrLKJu/Ii39XJJOeBB4i2/ez9oQw1b+UM/IcpBkgo7Ee1sdTxoC8sIbeRPw+t4lkwBJrAotMDHRpR5dn2Q9/IESlaQ/E3z1FoyK23HEasttYG0/WfRHWa5Rhk4zzNPs8ogfTDm+OVd3cDpxcdo5sjaKPZ/oX+UOvrLTVJWJ5mYHmcflD3rFhVZyHCex5eM6QA78hxJLSZXQ5uUBrwuLOFcSkoPIiP49+E+oYrCcoJ9kYy0aoHvWC0GpcpO2hQjuCrnnhOAnZzdBXMjwkm6L6zOJkCPUIfW3j8/ES9D7MiYjNFgnYQg1CxiKYNhsV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6baa53-0c54-42ab-3eab-08d81c47b5c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 16:15:58.8985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4zLPdlcMLy5IiRBx8dTuMPlxzH6aWREgrzFYAEOlVSybCSnOLiuEjIoyNKcKe3lq0VtYOJbCfGbbmz3ALZ9anzQb1QVq9z73ryXq6tJ0fkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4237
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/06/2020 18:04, Bart Van Assche wrote:=0A=
> + * for @cmd. Functions like scsi_sg_count(), scsi_sg_list() and scsi_buf=
flen()=0A=
                                  scsi_sglist() ~^ =0A=
=0A=
and I don't think that sentence should be included at all as these values a=
re =0A=
initialized in scsi_init_sgtable().=0A=
