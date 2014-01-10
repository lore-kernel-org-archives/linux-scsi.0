From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Fri, 10 Jan 2014 23:11:13 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A17073C362@FMSMSX103.amr.corp.intel.com>
References: <20140108005607.GB29556@linux.intel.com>,<52CED67E.7080706@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47233 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaAJXLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 18:11:14 -0500
In-Reply-To: <52CED67E.7080706@ubuntu.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "tj@kernel.org" <tj@kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thursday, January 09, 2014 9:04 AM, Phillip Susi wrote:
> I think my patch for this "libata: resume in the background" was a LOT
> simpler.  It just used the existing behavior of becoming async when
> the async argument was !NULL, and fixed the one caller that didn't
> actually care about the result to pass in a pointer anyhow.

Yes yours is simpler, but it also opens a potential memory issue by passing a static int as the return location for the error value. I think it's just safer to tell the callback to attempt no return value at all, and for that you need to expand it into two arguments, one for selection, the other for the output address.