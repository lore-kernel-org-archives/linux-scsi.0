From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Transport Attributes -- attempt#2
Date: 08 Jan 2004 09:11:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073571086.2741.5.camel@mulgrave>
References: <20040107185420.GA30627@localhost>
	<20040108131717.A9700@infradead.org>  <20040108140155.GD30627@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:28882 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264927AbUAHOLd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 09:11:33 -0500
In-Reply-To: <20040108140155.GD30627@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-08 at 09:01, Martin Hicks wrote:
> > >> Out of curiosity:  Why do we need _another_ classdev.  Can't you
> > >> reuse the current one?
> 
> It guess we could re-use the scsi_device classdev.  This would mean that
> all the attribute files would show up in /sys/class/scsi_device/w:x:y:z.
> We would have to export an attribute called "transport" to tell which
> transport the device is using.  I'm agreeable to this solution.  I don't
> much like having an fc_transport and pscsi_transport directory in
> /sys/class.

I disagree with this.  We put attributes that apply to all devices in
scsi_device classdev.  We're implementing a separate transport interface
here, so it really does need its own class_device, otherwise separating
it from scsi_sysfs and allowing arbitrary transport class creation will
become a real pain.

A class is supposed to represent a device interface, and the transport
class does just that for transport attributes.

James


