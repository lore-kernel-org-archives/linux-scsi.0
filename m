From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 6/6] statistics infrastructure - exploitation: zfcp
Date: Thu, 15 Dec 2005 12:46:14 +0100
Message-ID: <1134647174.16486.35.camel@laptopd505.fenrus.org>
References: <43A044E6.7060403@de.ibm.com>
	 <20051214165900.GA26580@infradead.org>  <43A0E8E7.1060706@de.ibm.com>
	 <1134632229.16486.3.camel@laptopd505.fenrus.org>
	 <43A1524E.70200@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39057 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422691AbVLOLqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 06:46:20 -0500
In-Reply-To: <43A1524E.70200@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, 2005-12-15 at 12:23 +0100, Martin Peschke wrote:

> Given the idea of struct statistic, the lower layer driver could use a 
> given pointer to an upper layer's struct statistic in order to call 
> statistic_inc(stat, x).
> 
> The lower layer driver could call an upper layer driver's function to 
> have the upper layer update a statistic. 

Why? it's an open source world, what you suggest is more something for a
"must hide behind interfaces" closed world ;)

if done right, the LLDD gets access to the transport class information,
including the array of stats, so the LLDD can update those just fine.
Just the API should be clear about who owns updating which field; a
comment will suffice for that ;)


> The lower layer driver could temporarily store some measurement data in 
> the data structure passed between those two; the upper layer driver 
> picks it up later and calls whatever statistic library routine is 
> appropriate. Requires additional bytes and one store/retrieve operation 
> more than the struct statistic idea.

way way too complex for no reason.

Remember the scsi layer is a layered concept, but also upside down: even
though the transport class layers on top of the LLDD, it's the LLDD that
drives that class, not the other way around. The same could be done with
selected statistics; have the transport layer do the exporting to sysfs
and all that stuff, but have the LLDD keep track of them. (of course
only for those that are relevant in this sense; if the transport class
is the natural place to update, then it should be done there)


