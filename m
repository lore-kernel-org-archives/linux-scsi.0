From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: Fri, 20 Aug 2004 21:38:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040820213857.4014b981.rddunlap@osdl.org>
References: <1093053368.3318.569.camel@mulgrave>
	<4126BFCC.2000702@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:38361 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268844AbUHUEtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 00:49:16 -0400
In-Reply-To: <4126BFCC.2000702@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Fri, 20 Aug 2004 23:21:48 -0400 Jeff Garzik wrote:

| James Bottomley wrote:
| > +	if (sdev->inquiry_len > 56) {
| > +		if (inq_result[56] & 0x04)
| > +			sdev->ppr = 1;
| > +		if ((inq_result[56] & 0x0c) == 0x04)
| > +			sdev->dt_only = 1;
| > +		if (inq_result[56] & 0x01)
| > +			sdev->ius = 1;
| > +		if (inq_result[56] & 0x02)
| > +			sdev->qas = 1;
| > +	}
| 
| 
| Do you forsee ever adding more feature bits like this?
| 
| It seems to me that a more maintainable approach is to cache relevant 
| INQUIRY data in a buffer, and then create accessor macros for 
| programmers' use.
| 
| That way you don't have to keep adding members (really, mnemonics) to a 

Mnemonics would be names, not numbers.  (hint hint)

| data structure, and associated initialization code, each time the 
| mid-layer or some low-level drivers want to test a new feature bit. 
| Initialization via memcpy is easy and automatic.


--
~Randy
