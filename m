From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add compat_ioctl to scsi host structure
Date: Wed, 19 Jan 2005 07:55:01 -0800
Message-ID: <1106150101.5150.1.camel@mulgrave>
References: <20050118110354.GB43344@muc.de>
	 <1106062536.5151.2.camel@mulgrave>  <20050118232745.GA66256@muc.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:942 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261764AbVASPzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 10:55:44 -0500
In-Reply-To: <20050118232745.GA66256@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-19 at 00:27 +0100, Andi Kleen wrote:
> On Tue, Jan 18, 2005 at 07:35:36AM -0800, James Bottomley wrote:
> > Shouldn't this also be surrounded by #ifdef CONFIG_COMPAT (on the
> > grounds that you never fill it in unless CONFIG_COMPAT is defined)?
> 
> At least the standard file_operations has it without ifdef. 
> I guess it doesn't hurt too much even on non compat systems.

Well, I wasn't really thinking of saving the four or eight bytes for the
pointer:  It looks, from all the other patches, that the policy is that
any compat ioctl code should be surrounded by #ifdef CONFIG_COMPAT.
Thus, an easy way to enforce this policy is to do the same to the
structure definition, so the compiler will error if the driver writer
doesn't do it and tries to compile on a non-CONFIG_COMPAT platform.

James


