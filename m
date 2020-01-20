Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E21BC33CAA
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 22:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0ECE24653
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 22:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgATWNT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:13:19 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:28534 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgATWNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 17:13:19 -0500
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00KM7pIM028999;
        Mon, 20 Jan 2020 22:13:06 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 2xndmd329r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jan 2020 22:13:05 +0000
Received: from G9W8455.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.216.161.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 5D73754;
        Mon, 20 Jan 2020 22:13:04 +0000 (UTC)
Received: from G9W8455.americas.hpqcorp.net (2002:10d8:a15e::10d8:a15e) by
 G9W8455.americas.hpqcorp.net (2002:10d8:a15e::10d8:a15e) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Mon, 20 Jan 2020 22:13:04 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (15.241.52.11) by
 G9W8455.americas.hpqcorp.net (16.216.161.94) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Mon, 20 Jan 2020 22:13:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2DyxRIRGuRKT0Zx47wASY1qkBkWTDvH6xy5mSdjQ/591z0w5ycpBbWZ+nLOPlFX08L2lXgioeD7imc2hHd0jdL0M3rUaHEdsrCBKXzsF3ZCKNwZyuWiH5aaMLXkXduBm+oA7tSRj/aUa8d1bjt1IcvsKQwDrQ0MpVSyAtEpwA7U5UF2mFXMc6yeW0dpnlU3LtcKWj8tFVlVulgKLl25MZBFENZSNiCR/u/UzVGTSGZzWzTI9uIkyMt1y6JbF/hyqO6BsOlrTfGSeNurv08yUKznChD/szhMmMt9QZEYXyBwlcV5BH18S7/TPPCumwa+niIT3AGMqR9DzNREw4tH1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5csart8qI88hfLmRlIfFsoy3iIU8llHGmWBlRxuL5FU=;
 b=NfOCiev1dBSrt+esER6GPu4GFFpjYd7Mw6NSggrX2rsFsouzhEKxWH4QgOgeIfXv+rAjAwRFHUYXLF1i/27Skkg6Zo5WePoOJFzXFHnf8Evx0DAhVECwUD14B9XPaHWEmZ3ZqKmYd5EbJCqexYyqKMd4Rrlb4As6WC4Q8Bz35/n1u6vTcmDZQ4o1fyrFUbRKEGWlV4W1z6N2CGVC2sH+PKxsX29Kuj+OmBVZsLz/TdD4ADGeLoG4f1sKUBFy9eIMb0Uo6QPFNo88up970fe71i7VjC6fz0ZRNvaW9+T/i3C6yXXoGEAGqGusL2VKkSA/+eru2wrEubbTytwBUAO6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM (10.169.97.143) by
 CS1PR8401MB0680.NAMPRD84.PROD.OUTLOOK.COM (10.169.16.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Mon, 20 Jan 2020 22:12:59 +0000
Received: from CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::ddb3:29be:f6c8:5c30]) by CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::ddb3:29be:f6c8:5c30%11]) with mapi id 15.20.2644.026; Mon, 20 Jan
 2020 22:12:59 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: RE: [PATCH 2/6] scsi: remove .for_blk_mq
Thread-Topic: [PATCH 2/6] scsi: remove .for_blk_mq
Thread-Index: AQHVzpg04a0ZYcLQKEOSm0bCR11ehKf0IBfQ
Date:   Mon, 20 Jan 2020 22:12:59 +0000
Message-ID: <CS1PR8401MB1237C74128D66E4D21167115AB320@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-3-ming.lei@redhat.com>
In-Reply-To: <20200119071432.18558-3-ming.lei@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.211.195.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e3a31791-e465-487c-24cc-08d79df5e8c0
x-ms-traffictypediagnostic: CS1PR8401MB0680:
x-microsoft-antispam-prvs: <CS1PR8401MB0680F4305E1E9CE32573FDDFAB320@CS1PR8401MB0680.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(39860400002)(396003)(189003)(199004)(33656002)(71200400001)(4326008)(55016002)(9686003)(26005)(7416002)(7696005)(186003)(558084003)(6506007)(316002)(54906003)(110136005)(86362001)(478600001)(66556008)(8936002)(81156014)(64756008)(76116006)(66446008)(5660300002)(8676002)(66946007)(52536014)(66476007)(2906002)(81166006)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:CS1PR8401MB0680;H:CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QCKXb8rHypqxF/olxZ+pN5FxkfoiAIuMxDkLY8pETAyPYKerV6Rwcn0eK6AAZfD6Ub2P2omFETJR0sQeFqG3DjBVbE2DIgycmorxYNxfukenSghZP/xJU3OgsCYYzq/rGNCnBOnRi9BalcWAo3h9ETQXUxe8y7Jc7+2c+9jyzwPkukebLoadzQj9xmCqGV06IpWMxJMQ4bB6/E2WXbwiZFS07ZjhIYOlB4HebQXRbAbV0WnWGR+vPA2oBZku3FLmM1H+NDGbMLVXqKolDrOXFn6BDxvioG67gyAi4u2UL0fYBHuF7itUsVvvo6lzdgJ899f5/lQScFBaSazdKXdCD0y4Ylnrp95bnKYJeno/MzAJhEVxrtIoP7Ec70SV9Ejsu821/jaXvrpx5ICkaxu0LY85KETDAchm1mkWbb5iWUZ5WJdcgdoRIwbLdniiRibeq0BabW5q4kwI7CWTBOH6AIXZTi2jbCUwI1wTGXQp1xj1SirrCBqe8dxj7otEJO4/
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a31791-e465-487c-24cc-08d79df5e8c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 22:12:59.2319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ce4oF863ctXisoIrC9KBThHP2BmVeOMHSSL/0aNsU+5BfiSkn8i/Db4So2it1wn0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CS1PR8401MB0680
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_10:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0
 mlxlogscore=787 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001200185
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -	/* True if the low-level driver supports blk-mq only */
> -	unsigned force_blk_mq:1;

Minor nit - in the patch Subject, for should be force



