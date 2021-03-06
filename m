Return-Path: <SRS0=PYL1=IE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305FAC433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Mar 2021 15:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC86F6501D
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Mar 2021 15:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhCFPM2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Mar 2021 10:12:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58132 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhCFPL7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Mar 2021 10:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615043519; x=1646579519;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ux5sequo5kQxiHmMlOTMldFrMGtWRpiZS3BugBzjpVE=;
  b=OC3tlbJ7wV2WkAtTffWmVDYLOKh2kuSjb7emr71jbFyUy/AcZ8ZhPLn/
   UjAFi/gWfw8aiiFxjVy4xwyWV3Xg4D+Jv/HcV8oh5iAJhicthOA1W3r8a
   NXdaylxkKbHMX48EBR8b79o3A5Cxuz5ThFOwWY6qibO0HddJvi1MSHino
   DFgwXFmeTOAKHe9l4f+V+afEQr/Xh3wxjU5KHKUvAc6l4QGWSiRVreQuO
   njuMEupVhSXzBTQLXDVCGSQhNBVv7573wLrbC3lxhUaWMH3YW0hedTDVn
   +C4l7DX2e/Rr2Ydn/bRYz/S72WPlFNiyjed656BWi83QJis/x9PmzyU4E
   A==;
IronPort-SDR: artP/+AMpVDmBp+0JoNEDLvxokbIzVcaEwu9V53SIgr5WGoGalfJJtW95zBYFhqDYnujGURote
 CvPtxQSmlBiqcICwxQvGFuwt/GEViW1eFyAvYUgDmOBP5gsCZf+BzCYmPgu2AHAksCr9KUH3pA
 y3thFzNi79+bV5fjqOj90/AWD9yy7y0heaGmcwhsmKYv/Q9hYVrCpSu67upaZRe5bYWLvzWU3G
 FiLAX6GRGTyZ9DAs656BECUtfS5pQ94uz6eeNTTKxBKVFYQZNJLMpfngvUJZ7OB9mweWIOvWJS
 Ezw=
X-IronPort-AV: E=Sophos;i="5.81,228,1610434800"; 
   d="scan'208";a="106214691"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Mar 2021 08:11:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 6 Mar 2021 08:11:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Sat, 6 Mar 2021 08:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVqktpDZni3Y8sLXAsF5UNNI296/QsYyPGQxoxq9I6ychB8nM8mkI2N35ZHJrE41+G8xU2EU7u0L9x0FqJhViGEQQroDWD0ylUAI4ltArsNHt0YuYzk2BavpGf3/c3VQ4QswqzPhKZIStMJmUc6c7C+riUtGKHnJWktyk2Z/EGZR2Pc9tR2Glk7Hrf8OBm7oz4MhP1FXyQmAkq6vC1RCXsS6D5JecwtIHaxBZoa8O5d2jbwcs7X938MaZj0O3NVDAnQU/fErrQxDiil/qvAQ0Nqj5RXgDhAyUmznZye5xh/ClljwaxFXo7lCrwf9WiUNEgmnJ/JzNDFpxMTg0sLcyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ux5sequo5kQxiHmMlOTMldFrMGtWRpiZS3BugBzjpVE=;
 b=Ire3K3KmXNL5PZM8GDGCVz8jxAHc6BQj4R9R+LYoaoq1usjDBioch/J1xoZef2NrUmJ84mV0nUOHp5GZxtVKbtSuLpAKZOdI0HE5cjtjWpCLQmn3VwowHQnUmLqn3CRXOqxN+JA7tza6YMXfQ7G7oNwMvgRPqIIeGz99I1FckRqkONePCIyggjnnBDPgah1diNmPUGQ/mL7JnPlWvzDLgsluAmY0QC9B63WEzcGbVuXOOmevsBEVrVkzQcYtVgw2SxcLtZDiJUi5l7A4yzlO4j0vkg5lFkPblnPDNViJ3oYLVh5zMPSSWZdFNrIaGKnZ4plhPcN1fca9Qf3SL4SgeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ux5sequo5kQxiHmMlOTMldFrMGtWRpiZS3BugBzjpVE=;
 b=AV+FosYf1XSjpcehK80SGZTHJf/729FqZhpZSOJzo+w6jZOWDul1/MbFRNhBcLLs01IORtIjv+6I+jzFmA1J3+poS0ww/y8uffcljH/AxjjoqXyZjdSbZanQShxQYqqlyOdPBdoTXy+UI2AA+JOjM8/8nQRCWDeGdE5e2YPwLFQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4843.namprd11.prod.outlook.com (2603:10b6:806:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Sat, 6 Mar
 2021 15:11:52 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3912.025; Sat, 6 Mar 2021
 15:11:52 +0000
From:   <Don.Brace@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <james.bottomley@hansenpartnership.com>, <hch@lst.de>,
        <john.garry@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Thread-Topic: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Thread-Index: AQHXCR61OvlQCM/6C0Sy4/3GbWz0Qqp3I2Ng
Date:   Sat, 6 Mar 2021 15:11:52 +0000
Message-ID: <SN6PR11MB28485909455144E17F9B46A3E1959@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210222132405.91369-1-hare@suse.de>
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d09bd48-b0a2-40e3-ba0c-08d8e0b22c80
x-ms-traffictypediagnostic: SA2PR11MB4843:
x-microsoft-antispam-prvs: <SA2PR11MB4843856F82955DA6559D1F4EE1959@SA2PR11MB4843.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s/jJ+V1fU8jp3JkF1dPs2pQBVkPTwGJnWEXOvswYzYc0DoaN1MKJE8Fr0PHH0C7qNq/bTUMM4ti1mnOws+FBtwzQaQ5xibmKWp55O1EoSpL5sBfyyqAyFSCxJpCd86NqRL+sYUSQct779t99SAR5gNCzSPc/XWwwU2Tnl0ZRAf7ldnLCw+cM09lJtcYebLlEWxe0tk1IJl6GNGubAPy9bHpf0SSXaliTAGD3Txd9jyvWvl2UZv4Bb9umAEf9HKDQ+vg5/i+5WRZJ+VHAvxsEq0YIidJcLkdMGW2ClpKYD3+ToRHjxrCMb/jRByyacNzC/eWVMT32bOpMmx9+zMXXa0Rlumf7BhA/lH2rrBxSHIMf4tdHk54hOTyPGFi93r+6VS9lN4O1nhUzC9raX7/qF318w4d0+Y9E2RUSN6Q5y35TdgnMM+9LC23Zcm9K4eQuCrCrPhmpS3JoFuDLDaFhLknhHoWb5WVUt/nFOFsWVQR3HorHeL/t2onjdv+q0PFBhOaVmj90Vb98h9bZAV/68w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(9686003)(5660300002)(55016002)(71200400001)(4326008)(76116006)(26005)(6506007)(316002)(2906002)(110136005)(8676002)(54906003)(66556008)(86362001)(66476007)(7696005)(83380400001)(186003)(8936002)(33656002)(64756008)(478600001)(66446008)(52536014)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UYAxT5GsgxRinCzpob+aKiCdJpYAO4NdsOadMwtF33aO9OZfO6NWiHcmf5dr?=
 =?us-ascii?Q?iAtJbM6/vLmIx+d1WYXqa0x6CTaYKsQej12ITwnAP/ksbpKPtrQ9VBytAoRu?=
 =?us-ascii?Q?OlEJdnpB1p1r9gSKrHK6ojXgHcZRyyKPKnqVYqOkX9bRfy0OBzNTf315PKho?=
 =?us-ascii?Q?nrmaNhFmqilQ3kjauEal6Rc1Mj7TTiaiKx+Ks5nDgHdEL7pOVeDiWDx7EZk2?=
 =?us-ascii?Q?Q4ocZEHSnZ/qQJWoYOK9MNC+LdJWPOSVO9fUCoP07iU2xTxirrJBqehywwqa?=
 =?us-ascii?Q?4wfxhJouylantdirXV2kBaVp+xn2QikBNTqpa9kPvZ9i8AhUrNjfsQp0MhyF?=
 =?us-ascii?Q?t5Izkibh2qlK/FczaykfTXHxofcPrBg2lxKSUYx2M+KOoPO+7j/6iYyLF6L7?=
 =?us-ascii?Q?UKuKqZNS/sCMJZZm4NEbMhcCUsZlIecLY/J1v6jyN0R9lBcGSWYzgs2u+DMp?=
 =?us-ascii?Q?JRdtbhjK0Rz0dDVJmI8U9KNSE9alw2GoWQXh0ZsslrFB/Kr+QtrzuXFFei6u?=
 =?us-ascii?Q?Fhwu57LlG0kT6hMya0RrFWpUqGmP2olXGNDQ8IDh0leqyyfFq/h5fsuKjxaF?=
 =?us-ascii?Q?PUBQD1hyZ8ePbm67bFOPzO9TexGvhXKlECsvnydvrsS+D7F+5OI6qZcb72ju?=
 =?us-ascii?Q?fXZ1wxovrKr0Lg964Ph826+AiD8qCk7AkAZ/HIW6+VyQa6axtbEfKvXYUUjd?=
 =?us-ascii?Q?2/n922AKanEI6fFclUfwN4DLcCVgyTVYeDT3il4GI0+Hc6UgP2ZNFrxQFDpI?=
 =?us-ascii?Q?ysfQqIRxOWT1iJAxzKvuA4AVz1c1Ms+DRpevOzujXd3M8Fh2SP7hlyQn8X1Q?=
 =?us-ascii?Q?ppdwa2KU9VPpKU8w99nerBH5E5nDrGYD5AxesltzEXx74XLCluJaHPWAM+a9?=
 =?us-ascii?Q?YqeOImeepgsmwx57Zk4XxKxQzLOSCqPwMtiAbhergMuIOOb6g8DBge+BPNuK?=
 =?us-ascii?Q?tuDSAGxTt5PAnKokUeGgDBuIL8K2ClKqx/ggqknah5L3g1Rgd0pwKT5Mdzal?=
 =?us-ascii?Q?niB4V5WL1trCATgw1mOgfWm5whJquXgyTsmApyuhrPapF+ypFfGobJW4rQ8t?=
 =?us-ascii?Q?8HKlB1CzpIQs1/wrMVwbRXNbxeynj8k/40PhPrNrksllW8MPrsvtz/Ayh1zj?=
 =?us-ascii?Q?L2HE1YzYo3iVLLblbXOdyGuQ4AHVkWAA7jh35v0d/hoKUCjkL4gp4nMC/+IG?=
 =?us-ascii?Q?2R+vwLQXNOjf6wuHH0B5jhcbHc2e9kY2a850q8MNs1pdRiS2iKRklxz3Po4x?=
 =?us-ascii?Q?bN5SeBQPEztYgismqWYDr2QNBkMZK86dBJX/1b47P7lPsFmloH9GzLaKPegg?=
 =?us-ascii?Q?kXc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d09bd48-b0a2-40e3-ba0c-08d8e0b22c80
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2021 15:11:52.7380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QbHVz3FC7qsmJiz1LRyESWXRSvez+FSESzlCKQ+W8ivrn5zpqJeXgDW7yMdPmXt+kLz3SqA79O6pM98HiJyNug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4843
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de]=20
Subject: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs


Hi all,

quite some drivers use internal commands for various purposes, most commonl=
y sending TMFs or querying the HBA status.
While these commands use the same submission mechanism than normal I/O comm=
ands, they will not be counted as outstanding commands, requiring those dri=
vers to implement their own mechanism to figure out outstanding commands.
The block layer already has the concept of 'reserved' tags for precisely th=
is purpose, namely non-I/O tags which live off a separate tag pool. That gu=
arantees that these commands can always be sent, and won't be influenced by=
 tag starvation from the I/O tag pool.
This patchset enables the use of reserved tags for the SCSI midlayer by all=
ocating a virtual LUN for the HBA itself which just serves as a resource to=
 allocate valid tags from.
This removes quite some hacks which were required for some drivers (eg. fni=
c or snic), and allows the use of tagset iterators within the drivers.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
reserved-tags.v7

Don: Cloned and kernel built. I'll have some test results by end of next we=
ek or so...
Thanks,
Don
--
2.29.2

