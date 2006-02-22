From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fc transport: Add support for events
Date: Wed, 22 Feb 2006 17:21:27 +0000
Message-ID: <20060222172127.GA20137@infradead.org>
References: <43FC8CB4.2000507@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3762 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030313AbWBVRV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:21:28 -0500
Content-Disposition: inline
In-Reply-To: <43FC8CB4.2000507@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 22, 2006 at 11:09:24AM -0500, James Smart wrote:
> 
> The following patch adds support for hbaapi events within the FC transport.
> It adds the following attributes to the fc_host:
>   max_events  : sizes the internal array for the number of events that are
>                 buffered in the transport. This value can be tuned by a
>                 module parameter.
>   event_cnt   : number of events pending in the buffer
>   event       : reads an event from the buffer
> 
> It adds the following routine for LLDD's to post events:
>    void fc_host_event_post(struct Scsi_Host *shost,
> 		enum fc_host_event_code event_code, u32 event_data);
> 
> Not all hbaapi events are contained within the transport. Many events
> correspond to elements outside the fc_host, and can be serviced by normal
> hot-plug events, either on the fc_host, or rport. I believe I've included
> those events that could be posted. I've also punted on anything that has 
> more
> than 1 32-bit word of data - which should only affect RLIR payloads, and
> vendor-unique payloads. We will address these items once we figure out how
> to deal with large payloads in the transport.
> 
> In conjunction with the event infrastructure, the module uses hot plug 
> events
> to notify user entities about changes. For the fc_host, the only event 
> posted
> is a KOBJ_CHANGE event. For the rport, ONLINE/OFFLINE is posted whenever 
> the
> rport goes through a block, then unblock. To get to the class_device for 
> the
> rport, a new attribute_container function is added locate the class_device 
> for
> the device.
> 
> This implementation expects the user-space hbaapi provider to deal with
> multiple user-space readers.
> 
> I've coordinated with Andrew Vasquez, who has sent his approval.
> 
> The lpfc driver will be posted shortly to utilize this infrastructure.

I must admit I don't like this too much.  The natural way to send events
to userspace would be a netlink socket, but integrating this with the
transport class might be a bit hard.  Having named netlink sockets
similar to named unix sockets would be nice for this..

