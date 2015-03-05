From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for kernel 4.1] Split SCSI header files
Date: Thu, 5 Mar 2015 15:26:35 +0100
Message-ID: <20150305142635.GA17795@lst.de>
References: <54ED8A71.3050701@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52482 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbbCEO0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2015 09:26:39 -0500
Content-Disposition: inline
In-Reply-To: <54ED8A71.3050701@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@parallels.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

In general this looks fine, but:

 - why do you need a separate scsi_lun.h?
 - I'd really prefer to only have the protocol defintion here,
   not prototypes for helpers like scsi_device_type, int_to_scsilun
   and scsilun_to_int.  The target code should not depend on the
   initiator for helpers.  In the long run we should either duplicate
   them, or have a library used by the initiator and target.
