From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 12:27:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929192756.GA6179@us.ibm.com>
References: <415AF8A6.2080705@adaptec.com> <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:27807 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268884AbUI2T2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:28:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On 29 Sep 2004, James Bottomley wrote:
> 
> > On Wed, 2004-09-29 at 14:02, Luben Tuikov wrote:
> > > > According to Documentation/scsi/scsi_mid_low_api.txt, the only possible
> > > > error returns are SCSI_MLQUEUE_DEVICE_BUSY and SCSI_MLQUEUE_HOST_BUSY.
> > > > Neither is appropriate; should the second one be returned?
> > >
> > > I believe internally SCSI Core returns DID_ERROR.
> >
> > For a device that no-longer exists, DID_NO_CONNECT is probably the most
> > appropriately descriptive.
> 
> Regardless of how descriptive the value is, the code in
> scsi_dispatch_cmd treats anything other than SCSI_MLQUEUE_DEVICE_BUSY
> as SCSI_MLQUEUE_HOST_BUSY.  Will this matter?
> 

You would not want to return non zero status from your queucommand, but
set the result of the command to DID_NO_CONNECT and call done.

-andmike
--
Michael Anderson
andmike@us.ibm.com

