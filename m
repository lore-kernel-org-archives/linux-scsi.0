From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for
	sysfs	take 2
Date: 07 Sep 2004 18:05:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094594715.1716.169.camel@mulgrave>
References: <20040907210520.0251476C56@isis.visi.com>
		<413E2440.8080509@cs.wisc.edu> <1094592818.1716.159.camel@mulgrave>
	<413E2A17.80107@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56554 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268699AbUIGWJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 18:09:53 -0400
In-Reply-To: <413E2A17.80107@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 17:37, Mike Christie wrote:
> Ok. If the new magic iscsi transport specific target code handles target 
> data like the scsi_host does for hostdata then would it be better to put 
> our session struct in the target data? I think this also simplifies 
> refcounting. Most session stuff makes sense hanging off the target so 
> this might be easier, right?

Possibly, but only if the way its handled would be the same on all iscsi
initiator drivers.  Otherwise, if it's specific to the driver
implementation, it would be in hostdata.  Regardless, you'd still have
one host per one of these entities.

The transport class is to abstract out common code from multiple
drivers, so what goes in there must genuinely be common.  Even if you
put the common session data in the target, you probably still end up
having driver specific data in the host.

James


