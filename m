Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC3AC2BB40
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 23:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C87722510
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 23:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438568AbgLNXNY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 18:13:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:30583 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408945AbgLNXNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 18:13:18 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-212--YJV7hHZP5qYgI2RziD5Pg-1; Mon, 14 Dec 2020 23:11:39 +0000
X-MC-Unique: -YJV7hHZP5qYgI2RziD5Pg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 14 Dec 2020 23:11:40 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 14 Dec 2020 23:11:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bean Huo' <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "joe@perches.com" <joe@perches.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
Thread-Topic: [PATCH v3 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
Thread-Index: AQHW0lb4M+N3d8cRYUCXs7DyCMlcaqn3Nw+g
Date:   Mon, 14 Dec 2020 23:11:40 +0000
Message-ID: <977f3ea155644cd89bc83f2e9dcf281e@AcuMS.aculab.com>
References: <20201214202014.13835-1-huobean@gmail.com>
 <20201214202014.13835-2-huobean@gmail.com>
In-Reply-To: <20201214202014.13835-2-huobean@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <huobean@gmail.com>
> Sent: 14 December 2020 20:20
> 
> From: Bean Huo <beanhuo@micron.com>
> 
> Current EM macro definition, we use stringize operator '#', which turns
> the argument it precedes into a quoted string. Thus requires the symbol
> of __print_symbolic() should be the string corresponding to the name of
> the enum.
> 
> However, we have other cases, the symbol and enum name are not the same,
> we can redefine EM/EMe, but there will introduce some redundant codes.
> This patch is to remove this restriction, let others reuse the current
> EM/EMe definition.
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  include/trace/events/ufs.h | 40 +++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 0bd54a184391..fa755394bc0f 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -20,28 +20,28 @@
..
> +#define UFS_LINK_STATES						\
> +	EM(UIC_LINK_OFF_STATE,		"UIC_LINK_OFF_STATE")		\
> +	EM(UIC_LINK_ACTIVE_STATE,	"UIC_LINK_ACTIVE_STATE")	\
> +	EMe(UIC_LINK_HIBERN8_STATE,	"UIC_LINK_HIBERN8_STATE")

If you make EM a parameter to UFS_LINK_STATES then the caller
can pass in the name of a #define that does the required expansion.
The caller can also add in any required terminator after the last entry.
For an enum (which doesn't want a , at the end) just add a dummy entry.
You often want a constant for the number of items anyway.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

