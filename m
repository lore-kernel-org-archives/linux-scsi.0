Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2699FC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 15:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D355964DDB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 15:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhBCP6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:58:34 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:59381 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbhBCP5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 10:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612367858; x=1643903858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W3uW5GipkO0KXWYarcYYxpjtsL0qyRScx4kYtrmb+TE=;
  b=gR+Euk9kveOAbFz7IamxlgbgDHgIbCuaw4dhlNmfU1X8d2LIJZNTkGGv
   LJzlSZmDK2DEpE9HCjWHa/SPiwnPVI/nZCEBGDOG+o8R2/PNInN1K/3mb
   YxPK8t9buYxEDqDK5uC2+qURdDxqIQL5Tk/tplvXxElv6GQdkdb/a+wqP
   OQoIyi+37FXCcXxVHv8TWIYK+VsYVEDD0oj42BrDju3l5o7DHeP0JDBP1
   rxJPlSK/jU0k9+gfRzaOYsZZEGeoyraTKhdVkq6h5xjvp/Ln869UKHz7k
   7CTOzLvR16Xmr8Tmuz3e+LkzcejzbEv6wO6ne+1AarULAcEEgFi0Qp4Os
   Q==;
IronPort-SDR: vD6pLESCYMmFIjJM+Gem2HH8gn+bZpHTSEZOoIYj3bfcRThUBfF7aeTuYECvaXspGvpxDIhb5S
 S1WDTF3CXutS90dy/pwwUMsCcsNGW2rmz0A43mZ7L5yDoq0xa3siTMZMRFT6dEjQwZ0Z69cw28
 t49JXu3E3Ko9ROSEHVwrRFD1Nbkjv5MXFB+1q1mJ6cRkSbE0Kykd19NHyXrO1l9s8d/7zuWIUh
 K7GHd7prqDpxVbw2jaI7Sy4qlNeONAhxlL+SBNMdBcdgD54MnjSlR0nXEpReaz/7bDYlX2GZ1J
 /Lo=
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="108373182"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2021 08:56:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 08:56:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 3 Feb 2021 08:56:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6hIeGnNkCAUmlBKDGPzBeMHB6WCDo6x2URg1Anf35sTL0JwobeRDVjpLOCyhlepN5KgXt7M+gauz2oMHFxBLXEjbwy9Nvlgsuuo0KR4HBJTKNF33wLSh/XV2hJ7X+kPtAmW1Pao5ldpNtTjPtSa82jrojAwoR/0EjVI1hNfI/1UrghDLMVjBHpQFZZyRHLB+bvzLTGKWp4VucTcuRyxsw6y/bsdiUNVN+OYEbhSk0c4qQxLucyA5mARrBL48wiSAkAiGWne8JhtQXWdY4HBK3ym2UgpJ3Zxxe0iCPVBfJIffgMXupOscOUZmPSbBOFSZNu+Xe6KQ5yFtAwwJXxeQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJdLToT9gVs/bL+NxagIy0oPMksiVMblkT9b4Y9XHBo=;
 b=gNnw5lV+euIhyiWKEQipP814yQaEAT39JTr9HR7a20Jc5k5LeiEvpY945PlNbcyGiMGUU2VPK0cMwKEOm7aC3ANXGyfKlp/qr4Oebf5Y5XfvuFB2Y9+nV/zr/D905jfpWVeevsKuPqYxM9iE/hwBmnLMjpsbpeArFZsIE1TSzmDjd8FsvQvVvcgTA8q8iZvvJxLM99kpd42lcU30l3cy8tmSnsOPqbyXNMX7qGAaX/t5FRUBU/mYXBQnXVZUTaKWPqACb60h5aANUv6a+6iWE4gu9r6IcAGd4YlXX7BI2kMzH+8le1Q1LyYxOF3UmH2NFAB3hmwFt1TPZq4NxKoTrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJdLToT9gVs/bL+NxagIy0oPMksiVMblkT9b4Y9XHBo=;
 b=e+JJfY8vZ9eLY3wqgaJPAOPuXQoSFg6J4C2YxwsVsahm3gJbFf7G6V3kKQuGuEKyV3wevjZ2jlDr4CYN1/vTR96HtRAyjpZFOPRB9Lh7gcPkgZEzYf/b4pGIbcNBRMUBQh4YyvP2O9tUSXY/wax5ws/RZb247BtLZZ+HZYzODf4=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2800.namprd11.prod.outlook.com (2603:10b6:805:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 15:56:20 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 15:56:20 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <john.garry@huawei.com>, <buczek@molgen.mpg.de>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>,
        <pmenzel@molgen.mpg.de>, <hare@suse.com>
Subject: RE: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Topic: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Index: AQHW71yKurA1STNSk0C6miEuXSSEDaow9juAgAEFWACAAAlxAIAAAq6AgAAFxoCAE1AKoIAADVGAgAE8SvA=
Date:   Wed, 3 Feb 2021 15:56:20 +0000
Message-ID: <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210120184548.20219-1-mwilck@suse.com>
         <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
         <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
         <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
         <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
         <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
         <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
In-Reply-To: <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 860f4e73-e613-4bdd-1ced-08d8c85c3f9a
x-ms-traffictypediagnostic: SN6PR11MB2800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2800299B496B4F4405F7989BE1B49@SN6PR11MB2800.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: He+t9Y/ymjM6ncRWL2Sf2zZ5+2UIuIMv4b2cNVpe4tb05YrlxcImCZohB3lRNsaQ4GCJcxzsV5fyQqpNOrJBGJJWJswyACnj/aybJY8kETgpc63HuY67ppCmRbwsDDUJjpibNKj4f0GrxRI5Fhom8tm0iVjxtc6GayD46gT2fJYbTi+BIgtL6caLL6Mjoff8XPt4VgySu1Whz6048uZpQ0F6JNtZs6JvEy8kAzrf/IXeYj5+LWpb+mjJVhoyiCTU+reF6uFYzWt+/UZ/gZGnU8E9vM2MTAfHLD8zaT0Mzb7N5eWVpy0zG+hfttM9JcuSnurY+tv84GpXywqBmBAZ6xwwUWCzLJ15OdkjeeUzOxLA8WCFn3/xZ5TA0HdZDdOBXn9vAJ8tIgXkpY6G6nEj6TXTA1wSEYMFSywIJ92S9ZiGI2SgnaJidX7BwcOgNmRrvdC87GV/yRSHCQB53FQLI5XfQk9q3+qF7i6FaA/JmMPTkGb7JCo3D4awz8Ep+ulWEnYDLV1WHzXtWs4LhqUK3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(366004)(376002)(64756008)(66476007)(66446008)(55016002)(66946007)(4326008)(33656002)(8936002)(316002)(6506007)(2906002)(66556008)(7696005)(54906003)(7416002)(110136005)(9686003)(86362001)(8676002)(5660300002)(52536014)(26005)(478600001)(186003)(71200400001)(83380400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EiTre/w0pXU1XsF+qq6/ssMTYlCl119auN4DsQPMkG4K9xgWHBoWfzixifQf?=
 =?us-ascii?Q?3kHAcO+sVulxowaErYMu8DWKU+I8Uqz3UtRGrp1stzzWfZ+umLmLg5xk24RO?=
 =?us-ascii?Q?wfbA8f6F8Nc8DamKxAR0UZqFFUHf7j7XDAvL6kDnzgBn1zZ5aS8f9DtLk3S9?=
 =?us-ascii?Q?lEVylefOc2pBUiJVUpHUrvv1T4j7vYO31iDqJPLLjLS1/7QuB03YFnvLLoDa?=
 =?us-ascii?Q?tak/VvDx0Tm6fZlUlVtyaonjqNxx8gcgPWfqsEpeil1X6sN6VNDqc8oihGq+?=
 =?us-ascii?Q?0rPjq3XcuuVSG5QqrNOf2JQieKRVfCo9qge/kIGdP4HDcTBb3LbsANZhERFJ?=
 =?us-ascii?Q?HiL9mzkyVQXYIDalRgNlbEmVlx0mT2KFai7Jc/unTBLDzVo+xX1IZCE14yxZ?=
 =?us-ascii?Q?8ZqjcxsdiH4ldmkba3FlzYb2GHnMq0O0epGnSSUsf064pi4ypm4wLsn0vbrd?=
 =?us-ascii?Q?CXPSvVPL4g0d2VyNo8Tck3nZctAiXWnUIV5hPorI2vm58wF8ly0FBZTIYPis?=
 =?us-ascii?Q?zP6dGd1du/TnMzEG+x33MfVG0yuM3Hm4IFMPgjyafrlMtPjcLVKc/YL6qcUY?=
 =?us-ascii?Q?BUTWmwchIj33K4JK5mhcWDQiD6GAv5E4mdi+vgPAoMDtunC0otRLc0tzYUDc?=
 =?us-ascii?Q?PO0m/iS5YZyi+4yPUhGZQT7f3zpj3c6IkmwHc28qj88VJtfVoSRa9hGMBVHw?=
 =?us-ascii?Q?87MheWVxR4IViRmtnMdXmyVfaAbQSC3kdxkCyCzvhlpOL4CN/HB6nu5QvZoE?=
 =?us-ascii?Q?wSk5cG2idmLqy7dlGZwfjn0J1tM1OU1qCOJ72O9hqF6jKKVXT8vZaIOvqIf9?=
 =?us-ascii?Q?TzSH5kFHSbW7fCXTw7vCAhKVxnJjZBcBIGRdS+3KUyvFJFwzbyXTh1hX3MvC?=
 =?us-ascii?Q?+in8RjVGXVKx6/2Se7C1tuVZ6vxtnJaGadAyjY0hckHW/MuKw+U4xr2vXJoa?=
 =?us-ascii?Q?SWTWhe7wG8nqjM2RD8MkL0bOOJQ7S9WfJZwIXofJHjJvSxSyOhNG0M6akN2n?=
 =?us-ascii?Q?q2lbIHMTdEap7r42egdrKdoIslNoXRFgRNywFpbULjcFp+oPS6khEQkvz4CV?=
 =?us-ascii?Q?4epF29hcdXaQM9OjsjJgEPcnZN25MeC83+lftJNgga6XDLkvE5ESEAV6MRhv?=
 =?us-ascii?Q?RbSWmXaxuJ++CG6+nuPWVR9nwm3/8rty2SeBRQ8XbAWlftTGnUCkSTQCVttk?=
 =?us-ascii?Q?3Y/SItlroB7rtKKIIRDLoWj4IBpiMRPJgivyKd+AYOVQYQOmPWgR8qzObo0l?=
 =?us-ascii?Q?l9uztgwMPVOTMSt6WZVPPhCr73i5BfsvcJrjKwsVnd69uV4CbydYnWmJKK1M?=
 =?us-ascii?Q?lm0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860f4e73-e613-4bdd-1ced-08d8c85c3f9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 15:56:20.1726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ctG90cFWbrQSKFNe9SmX51fww6VDtpahlwK02thz9lwRrtNLfbgXTRSqtHtRAq+ypgXB0foSMCVpZ3Kitg4N/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2800
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early

>
>
> Confirmed my suspicions - it looks like the host is sent more commands=20
> than it can handle. We would need many disks to see this issue though,=20
> which you have.
>
> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and=20
> I suppose it could be simply fixed by setting .host_tagset in scsi=20
> host template there.
>
> Thanks,
> John
> --
> Don: Even though this works for current kernels, what would chances of=20
> this getting back-ported to 5.9 or even further?
>
> Otherwise the original patch smartpqi_fix_host_qdepth_limit would=20
> correct this issue for older kernels.

True. However this is 5.12 material, so we shouldn't be bothered by that he=
re. For 5.5 up to 5.9, you need a workaround. But I'm unsure whether smartp=
qi_fix_host_qdepth_limit would be the solution.
You could simply divide can_queue by nr_hw_queues, as suggested before, or =
even simpler, set nr_hw_queues =3D 1.

How much performance would that cost you?

Don: For my HBA disk tests...

Dividing can_queue / nr_hw_queues is about a 40% drop.
~380K - 400K IOPS
Setting nr_hw_queues =3D 1 results in a 1.5 X gain in performance.
~980K IOPS
Setting host_tagset =3D 1
~640K IOPS

So, it seem that setting nr_hw_queues =3D 1 results in the best performance=
.

Is this expected? Would this also be true for the future?

Thanks,
Don Brace

Below is my setup.
---
[3:0:0:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdd=20
[3:0:1:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sde=20
[3:0:2:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdf=20
[3:0:3:0]    disk    HP       EH0300FBQDD      HPD5  /dev/sdg=20
[3:0:4:0]    disk    HP       EG0900FDJYR      HPD4  /dev/sdh=20
[3:0:5:0]    disk    HP       EG0300FCVBF      HPD9  /dev/sdi=20
[3:0:6:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdj=20
[3:0:7:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdk=20
[3:0:8:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdl=20
[3:0:9:0]    disk    HP       MO0200FBRWB      HPD9  /dev/sdm=20
[3:0:10:0]   disk    HP       MM0500FBFVQ      HPD8  /dev/sdn=20
[3:0:11:0]   disk    ATA      MM0500GBKAK      HPGC  /dev/sdo=20
[3:0:12:0]   disk    HP       EG0900FBVFQ      HPDC  /dev/sdp=20
[3:0:13:0]   disk    HP       VO006400JWZJT    HP00  /dev/sdq=20
[3:0:14:0]   disk    HP       VO015360JWZJN    HP00  /dev/sdr=20
[3:0:15:0]   enclosu HP       D3700            5.04  -       =20
[3:0:16:0]   enclosu HP       D3700            5.04  -       =20
[3:0:17:0]   enclosu HPE      Smart Adapter    3.00  -       =20
[3:1:0:0]    disk    HPE      LOGICAL VOLUME   3.00  /dev/sds=20
[3:2:0:0]    storage HPE      P408e-p SR Gen10 3.00  -       =20
-----
[global]
ioengine=3Dlibaio
; rw=3Drandwrite
; percentage_random=3D40
rw=3Dwrite
size=3D100g
bs=3D4k
direct=3D1
ramp_time=3D15
; filename=3D/mnt/fio_test
; cpus_allowed=3D0-27
iodepth=3D4096

[/dev/sdd]
[/dev/sde]
[/dev/sdf]
[/dev/sdg]
[/dev/sdh]
[/dev/sdi]
[/dev/sdj]
[/dev/sdk]
[/dev/sdl]
[/dev/sdm]
[/dev/sdn]
[/dev/sdo]
[/dev/sdp]
[/dev/sdq]
[/dev/sdr]


Distribution kernels would be yet another issue, distros can backport host_=
tagset and get rid of the issue.

Regards
Martin









