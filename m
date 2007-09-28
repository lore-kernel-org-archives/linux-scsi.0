From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Fri, 28 Sep 2007 09:02:45 +0200
Message-ID: <200709280902.45557.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709251012210.3909-100000@iolanthe.rowland.org> <200709251711.01216.oliver@neukum.org> <20070928042710.GA24458@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:50506 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbXI1HBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 03:01:44 -0400
In-Reply-To: <20070928042710.GA24458@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Am Freitag 28 September 2007 schrieb Greg KH:
> On Tue, Sep 25, 2007 at 05:11:00PM +0200, Oliver Neukum wrote:
> >=20
> > PS: Whoever designed klists is suffering from a case of overenginee=
ringosis.
>=20
> No objection from me there. =A0If you can think of a way to do list
> traversal without taking locks, please, feel free to redo the whole
> klist stuff.

No, I just was happy to be able to avoid using them.

But it is not just overengineered, it is also underengineered:

int bus_for_each_dev(struct bus_type * bus, struct device * start,
		     void * data, int (*fn)(struct device *, void *))

An interface should be designed to note where it fails, thus:

int bus_for_each_dev(struct bus_type * bus, struct device ** current,
		     void * data, int (*fn)(struct device *, void *))

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
