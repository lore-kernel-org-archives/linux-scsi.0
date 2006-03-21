From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: properly count the number of pages in
	scsi_req_map_sg()
Date: Tue, 21 Mar 2006 09:54:54 -0600
Message-ID: <1142956494.4377.12.camel@mulgrave.il.steeleye.com>
References: <20060321083830.GA2364@localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56742 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751183AbWCUPy6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Mar 2006 10:54:58 -0500
In-Reply-To: <20060321083830.GA2364@localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel List <linux-kernel@vger.kernel.org>, brking@us.ibm.com, dror@xiv.co.il

This is a good email to discuss on the scsi list:
linux-scsi@vger.kernel.org; whom I've added to the cc list.

On Tue, 2006-03-21 at 10:38 +0200, Dan Aloni wrote:
> Improper calculation of the number of pages causes bio_alloc() to
> be called with nr_iovecs=0, and slab corruption later.
> 
> For example, a simple scatterlist that fails: {(3644,452), (0, 60)},
> (offset, size). bufflen=512 => nr_pages=1 => breakage. The proper
> page count for this example is 2.

Such a scatterlist would likely violate the device's underlying
boundaries and is not legal ... there's supposed to be special code
checking the queue alignment and copying the bio to an aligned buffer if
the limits are violated.  Where are you generating these scatterlists
from?

James




