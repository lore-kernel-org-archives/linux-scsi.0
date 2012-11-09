From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Date: Thu, 8 Nov 2012 23:30:03 -0800
Message-ID: <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
  <1352145183-29355-3-git-send-email-xi.wang@gmail.com>
 <1352203618.2529.22.camel@dabdike> <50997955.10000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36223 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab2KIHaI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2012 02:30:08 -0500
In-Reply-To: <50997955.10000@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


> On 11/6/12 7:06 AM, James Bottomley wrote:
> >
> > Why is this necessary?  As I read the reg set assignment code, it finds
> > a free bit in the 64 bit register and uses that ... which can never be
> > greater than 64 so there's no need for the check.
> 
> This patch just tries to be more defensive for bit(reg_set) with a
> broken reg_set value.  I agree with you that it's not that necessary.

Agree with James, and just need to do NOT operation one time

> 
> > The other two look OK (probably redone as a single patch with a stable
> > tag), but I'd like the input of the mvs people since it seems with the
> > current code, we only use 32 bit regsets and probably hang if we go over
> > that.  The bug fix is either to enable the full 64 if it works, or
> > possibly cap at 32 ... what works with all released devices?
> 
> Thanks for reviewing.  Yeah we'd better to wait for the input from
> the mvs people.

About patch 3, I check the ffz code and found it will check ~0 conditions.


