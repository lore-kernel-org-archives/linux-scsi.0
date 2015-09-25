From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 25 Sep 2015 10:31:18 -0700
Message-ID: <1443202278.2188.13.camel@HansenPartnership.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
	 <20150925151802.GB20282@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58129 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932474AbbIYRbj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 13:31:39 -0400
In-Reply-To: <20150925151802.GB20282@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Fri, 2015-09-25 at 17:18 +0200, Christoph Hellwig wrote:
> Hi Paul,
> 
> can you send the request_module fix as a proper signed off and described
> patch?  I'll figure out what w can do about async scan vs request_module
> in the meantime.

So the warning seems to be because scsi_dh_find_driver() is not quite
consistent.  For everything except alua, it scans the dh driver list to
see what might attach to the device.  It returns "alua" if the TPGS
field is anything other than zero, regardless of whether the alua driver
is loaded.  We could fix the problem by returning NULL if the alua
driver isn't present ... would that have any other adverse consequences?

James


