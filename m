From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptsas: eliminate ghost devices
Date: Fri, 30 Jun 2006 17:59:27 -0500
Message-ID: <1151708367.8921.60.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701BE45B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:175 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932188AbWF3W7l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 18:59:41 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701BE45B@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-06-30 at 16:38 -0600, Moore, Eric wrote:
> I believe my code is correct.  The scsi_is_host_device(parent) condition
> will only be entered from an expander one level down from the host hba,
> and this case
> will remove for all rphys that would of been reported pointing back to
> the 
> host hba.  So in the case you have two initiators connected to the same
> expander,
> I think it would be expected that all ghost rphys need not be reported
> for all host
> host hba's connected to the same expander, right?  

Yes, but we want an end device for a remote HBA, which your condition
would also eliminate.  It shows useful information (like sas address and
parameters).

> If the remote initiator is located beyond the 1st leve expander, or
> direct
> connected to each other, this condition will not entered.

Right ... here we'll see the end device, so if we go with your patch
we'd see an end device for a remote HBA connected to a second level
expander but not for a first level one.  Whatever happens, we need to be
consistent ...

James

