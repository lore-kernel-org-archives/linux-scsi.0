From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: 11 Oct 2002 11:34:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1034332488.6462.55.camel@irongate.swansea.linux.org.uk>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

> and ordered tags allowed), and the queue depth.  Most disk devices will
> end up looking something like this:
> 
> scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, queue_depth);
>
> on all disks to 253 in order to get the best possible performance, but 
> when the driver found out that some disk had a hard limit of say 64, it 
> was too late to tell the mid layer to adjust things down to a reasonable 
> value.  This allows the low level driver to make changes to the queue 
> depth later and still have the mid layer honor them.

This seems a somewhat broken interface to me. Not in the facilities it
provides - which are fine, but because in the general case surely this
is entirely the business of the mid layer or mid layer provided library
code to get right.

Why should each driver now be required to know about queue depths and
snoop inquiry commands ? It seems analogous to each net driver knowing
about tcp windowing rather than the protocol doing it.

Or am I misunderstanding. If I blindly do

	scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, 64);

will the mid layer then figure out if it should trim the queue or turn
off ordered tags ? The interface most authors need is probably more like


	scsi_default_queue_depth(....)

	eh_tag_error: scsi_default_tag_eh

Alan

