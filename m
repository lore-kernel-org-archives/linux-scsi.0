Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA45C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 09:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8899861B70
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 09:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbhHPJog convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 05:44:36 -0400
Received: from de-smtp-delivery-105.mimecast.com ([194.104.109.105]:58129 "EHLO
        de-smtp-delivery-105.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhHPJog (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 05:44:36 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2021 05:44:35 EDT
Received: from GBR01-LO2-obe.outbound.protection.outlook.com
 (mail-lo2gbr01lp2052.outbound.protection.outlook.com [104.47.21.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-7-tAVT4TBrNxyCYsKs2sMypQ-1;
 Mon, 16 Aug 2021 11:37:52 +0200
X-MC-Unique: tAVT4TBrNxyCYsKs2sMypQ-1
Received: from CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:89::10)
 by CWXP265MB3221.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Mon, 16 Aug
 2021 09:37:51 +0000
Received: from CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM
 ([fe80::4971:9c81:8b96:f29f]) by CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM
 ([fe80::4971:9c81:8b96:f29f%2]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 09:37:51 +0000
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Do not exit sd_spinup_disk quietly
Thread-Topic: [PATCH] scsi: sd: Do not exit sd_spinup_disk quietly
Thread-Index: AQHXkoIH1dJPthk+/U+6Ae1Ef5Tiig==
Date:   Mon, 16 Aug 2021 09:37:51 +0000
Message-ID: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a9829e2-baf4-4d03-804a-08d96099845a
x-ms-traffictypediagnostic: CWXP265MB3221:
x-microsoft-antispam-prvs: <CWXP265MB322143F21778B7A3783C4A20C4FD9@CWXP265MB3221.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7JCC3AQahDKlsndyInvgUzhCHTWz65lg8zLa7eFv+yt/6LIPZmVuPt96x7uRkOTpSdhAm+nXJB/gZgAZTLGjtzdZVWvVB1T59Rg/xkqjpH/wuOu1UONYOuH4DRQm7fOCKpC2mYbdRxrlvqjDQAzUZtrmj3fVnr2Gefhal/A+p8v0al8xtRGK2DSjWYLKOVEtC1sUdJjsQ2TXdZwMZKUcISSMWsCcXc5XeF69NjNGldS18NAT3fvNsWGS9Zw5GUhdkZFgL8qQnEzPeerTkTaYknuD8Jo6TwIdMG4+fq7QJnyn3ixtj8XZTWDp1bJq8/g2XyICsQrns4u8RYNzCpW6eczn/TIntA7TBNMAWvgSccqW81pqMY76JrlhHB8t4UmBd8HI87AXFWOIEMBegw1oAcYfcIFYtyRDP88eoUbhp5mG5ulEHuQ1CrZpdA9T7tio6ctUNSCikBm+1EJ3wO11o9nz40ga37s3RYUiT7j+3dgIxVUXfrmJDpqe+Xc2xaNZQQpmq2tTUElzfKbcRQOronYJ9hqvsGUvj/wOzlkA8oZTljJehmvfMjIUfNgCqC+sDBJ2vA6VKtxFXr47zdY29CuKHAiQK/7uAG5ciE7dluOFdOVtpgAqUn2BxldYwsFjCnxXrTEgOdaWcFOZjkL0BU0ZNnH9oCcaDAIceKqYojoNh36HdfT3DI5N0n3xAr/Nbyz+wivws4szEBY2k17C7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(39830400003)(136003)(122000001)(71200400001)(64756008)(316002)(8936002)(66446008)(86362001)(2906002)(26005)(38100700002)(76116006)(91956017)(66476007)(66946007)(66556008)(5660300002)(55016002)(478600001)(4744005)(38070700005)(9686003)(110136005)(186003)(33656002)(8676002)(7696005)(6506007)(83380400001)(52536014);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?AqV3c9kjYQScEG09e+qNYzRSyrCDgG/K1mDHHdiMkoNolcIzraFbYY3tZ6?=
 =?iso-8859-1?Q?frSnLus7O3s0QCWQSeSY0zxYlZyDvZH4YenOaXRkTJnQOxE8RbjhBd9wW4?=
 =?iso-8859-1?Q?dhYFbOxHFWQ3g536ijnZs8lva7FwxT4mOeq7mq7U80ykXfvJSS1H2VIvwJ?=
 =?iso-8859-1?Q?c94EMV3SHW15FnuTQN/5fqmmILuO8DRBQjGUqqZAUaO48LbjuLclW8yZ7/?=
 =?iso-8859-1?Q?2vth24AMQGxV3UcG/Joxci0sQKGrmYTRld+uFiFkZUBcco4JRDJ0WabzOe?=
 =?iso-8859-1?Q?4MI2/f+l/ejvrV6Iyw7efy8E1PVkEXdpcD5ZfBrwFi5Vcbm7FiGMcqWtcu?=
 =?iso-8859-1?Q?WB7aXo5sLHij2qzWL6WkaxC8X6X4fdPtAJNPHPiw0yUohsCh53b2XzKeRB?=
 =?iso-8859-1?Q?L6bvAJGyuTxlZgUtQoxClpCfaWaELIr8YI7TQMxEn/WWF+UlM63QotbuG/?=
 =?iso-8859-1?Q?qbMVc34bbjBbU1ixsX4YUqEjNHSBa6gwf3fEOn9il8HdUhCBKEImWdQH9B?=
 =?iso-8859-1?Q?O2IIMGvMQPp7x1fmfWYE7fu+N1pqTK23d0MnjpBMUYbRP55rkZxOEHSG9U?=
 =?iso-8859-1?Q?Rpv8QqPqAkxEB07m9zvr1G2Vuhlq+KHoOvn2lWJXDHEjZEu3jQTZ+olvTX?=
 =?iso-8859-1?Q?Ulb2CvPeJq0bjJZrPvNzhW9QVSUu0dWKQC/00CuugybRDt4lj12VfC6fzu?=
 =?iso-8859-1?Q?ULIVKRGPdGIUrMQwz6f+IVXDfo30lrnuzLmT+H7z3ry2X3oB7wDvKdj9AD?=
 =?iso-8859-1?Q?PRg56Mh4YnE1w1ruoW7Mu0S8tGdX7QJpeUqztKqDi02zr7nI7pjSyR9TqN?=
 =?iso-8859-1?Q?ZOko9FHpXXKzf62UPbw6drQcgr99JG2SqDFe58lg5/vI3gxFsHt0Oqjzg/?=
 =?iso-8859-1?Q?fSog3GF9vAQkcKNIP9clQpG+Vq2cG2yZHCZpFPF/PqZdKD9Mdh0vxLQKxO?=
 =?iso-8859-1?Q?MFK6mIUZFB6IvhEOjkueihGAYlfHGW+WGXiZaTfWdiKw5L4VsASJDsSQM4?=
 =?iso-8859-1?Q?4Bw2jckwmy4UNZqqJNJBdIMeiTW+76HgSR5BLjIXVlvee0JbIJAmwO8Ody?=
 =?iso-8859-1?Q?hO6wGILytk0O7NJShdwcvv+xuARRHX5bNgqqriEnnuNNAHJ6iPWvXLM6GI?=
 =?iso-8859-1?Q?rfwyEDLpbvecytL8R+PHB/QJ5mdcghOv55wm0L0iYR3m0sRqWvqsEeIYH6?=
 =?iso-8859-1?Q?ZR//wvB8FAApOwixuzApmU7gMZL8xIdMrWhIZPpbqS/g95YpL7G3X5msB+?=
 =?iso-8859-1?Q?K+LB4XFRHlZQQ0bdBdlUif28vJGxqkBKCAKg9zWOIUYy6n1dONINuZ3aW9?=
 =?iso-8859-1?Q?1/ejlsKoFRi+XSf0/pa7pqSdtm1YhVeZO8vLLA5cBpm7QO8=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hyperstone.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9829e2-baf4-4d03-804a-08d96099845a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 09:37:51.5794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 86f203eb-e878-4188-b297-34c118c18b11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3iQ9Ie17MPngmfjeDHj9Et0irWp0j6VakUQaWFXXH97txYLh5KoYkXtUB5fs+8z8EJjTSVU6rIl2Pvnl6q1xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3221
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hyperstone.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sd_spinup_disk function logs what is happening nicely.
Unfortunately this output stops if the media was marked removed
in the meantime. To prevent a puzzling output, add a print
for this case, too.

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b8d55af763f9..7e556f5b57e0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2180,8 +2180,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * doesn't have any media in it, don't bother
 			 * with any more polling.
 			 */
-			if (media_not_present(sdkp, &sshdr))
+			if (media_not_present(sdkp, &sshdr)) {
+				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
 				return;
+			}
 
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
-- 
2.32.0

Hyperstone GmbH | Line-Eid-Strasse 3 | 78467 Konstanz
Managing Directors: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

