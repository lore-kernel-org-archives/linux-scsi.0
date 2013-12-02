From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] qla2xxx: Question about out-of-order SCSI command
 processing
Date: Mon, 02 Dec 2013 15:38:46 -0800
Message-ID: <1386027526.2014.2.camel@dabdike.int.hansenpartnership.com>
References: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49198 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160Ab3LBXit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 18:38:49 -0500
In-Reply-To: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>


On Mon, 2013-12-02 at 16:12 -0600, Alireza Haghdoost wrote:
> Hi,
> 
>    We are working on a very high I/O throughput application and facing
> with a challenge to send the I/O request to a SAN drive in-order. I
> would appreciate if you can help us with an explanation about this
> unexpected behavior of SCSI layer or qla2xxx driver.
> 
> The problem is that I/O requests arrive out-of-order to the SAN
> controller if we submit those request with about 1us gap. In other
> words, we observed if we issue I/O request very fast they arrive to
> the SAN controller out-of-order. For example we observe I/O requests
> dispatched from block layer request_queue with the ordering in the
> lefts column and then arrive to the SAN controller with right column
> order:

Well this would be because we don't guarantee order at any granularity
below barriers.  We won't reorder across barriers but below them we can
reorder the commands and, of course, we use simple tags for queuing
which entitles the underlying storage hardware to reorder within its
internal queue.  Previously, when everything was single threaded issue,
you mostly got FIFO behaviour because reorder really only occurred on
error or busy, but I would imagine that's changing now with multiqueue.

James



