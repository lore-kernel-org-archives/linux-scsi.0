From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Some interesting results in the aic7xxx slowdown problem
Date: Mon, 29 Aug 2005 10:21:15 -0500
Message-ID: <1125328875.5089.37.camel@mulgrave>
References: <1123119347.5019.78.camel@mulgrave>
	 <20050804061809.GA4158@in.ibm.com> <1123166928.5026.8.camel@mulgrave>
	 <20050819095428.GA9130@in.ibm.com> <1124457765.5130.13.camel@mulgrave>
	 <20050825103943.GA7421@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:49555 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S1750919AbVH2PVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 11:21:25 -0400
In-Reply-To: <20050825103943.GA7421@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: suparna@in.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-08-25 at 16:09 +0530, Suparna Bhattacharya wrote:
> On Fri, Aug 19, 2005 at 09:22:45AM -0400, James Bottomley wrote:
> > On Fri, 2005-08-19 at 15:24 +0530, Suparna Bhattacharya wrote:
> > >  sda:
> > 
> > Well, this line is identifying the root cause.  It says that the
> > partition code came up with no partitions for this device.  Do any of
> > your other devices come up with paritions? (as in could this be a simple
> > device node transposition issue?)
> 
> Yes, it looks like that. The ordering now seems to be id 9, 10, ... 14, 0,
> 1, 2, instead of the default of id 0, 1, 2 ...  Did you expect a change
> in probe ordering ? 
> 
> When I switch back to the old AIC driver the ordering goes back to
> default.

Er, boggle!

I know of no change to the new driver that could affect the target
scanning order (this is target, not lun, right?).  Target scan should be
handled sequentially in the mid-layer (scsi_scan.c) in a for loop that
runs from 0 to 15 (well shost->max_id).  There is a reverse_order flag,
could that be set somehow?

James


