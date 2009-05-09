From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/4] mvsas: Fine-tuned tags array for alignment
Date: Sat, 09 May 2009 02:52:16 -0400
Message-ID: <4A052820.3080802@garzik.org>
References: <20090508061852.GA1893@jason.marvell.com> <1241795999.3327.38.camel@mulgrave.int.hansenpartnership.com> <4A045C62.50404@garzik.org> <B610F018B81B3143B10B3A7DC04C693E185056A0AA@SC-VEXCH2.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43389 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbZEIGwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 May 2009 02:52:20 -0400
In-Reply-To: <B610F018B81B3143B10B3A7DC04C693E185056A0AA@SC-VEXCH2.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>

Ying Chu wrote:
> Hi, James
> 
> DECLARE_BITMAP isn't a good option for mvsas, since the tags array couldn't be global(it's chip-related) and even if we define the static tag array both in mv64xx.c and mv94xx.c, it still couldn't honor 88SE9480 as there are 2 separate cores. So if we use DECLARE_BITMAP, it's hard to maintain the corresponding tag for different core.  
> 
> Can we use the following replacement:
>  -	u8 tags[MVS_SLOTS >> 3];
>  +	unsigned long tags[MVS_SLOTS / BITS_PER_LONG];

You are doing exactly the same thing as DECLARE_BITMAP here, so just use 
DECLARE_BITMAP :)

include/linux/types.h:
	#define DECLARE_BITMAP(name,bits) \
	        unsigned long name[BITS_TO_LONGS(bits)]

Regards,

	Jeff



