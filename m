From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.4] sd terabyte disk fix
Date: 27 May 2004 22:26:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085714794.1811.919.camel@mulgrave>
References: <40B6ADA9.3010407@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54976 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263640AbUE1D0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 23:26:35 -0400
In-Reply-To: <40B6ADA9.3010407@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-05-27 at 22:10, Brian King wrote:
> The following bug was hit when creating a hardware RAID array > 1 TB.
> Please apply.

Well, this is a known failing of 2.4;  It's not safe to promote block to
unsigned since there are many places in the filesystem and block code
where it gets used as a signed quantity.

If you want to use arrays >1TB, either use vanilla 2.6 with LBD support
enabled, or one of the vendor kernels with it backported.

James


