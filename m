From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: failing on high load
Date: Mon, 14 Jan 2008 14:03:45 -0600
Message-ID: <1200341026.3159.62.camel@localhost.localdomain>
References: <20080114144916.GD23867@alaris.suse.cz>
	 <20080114194513.GC7118@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43909 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbYANUDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 15:03:50 -0500
In-Reply-To: <20080114194513.GC7118@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org, hare@suse.de, vojtech@suse.cz, Peter Bogdanovic <pbog@us.ibm.com>


On Mon, 2008-01-14 at 11:45 -0800, Darrick J. Wong wrote:
> On Mon, Jan 14, 2008 at 03:49:16PM +0100, Jan Sembera wrote:
> > Hi,
> > 
> > 	we have array of 16 SAS disks connected to Adaptec controllers
> > ...
> > this elsewhere and I was recommended to send it to linux-scsi.
> 
> Hmm... I think Peter Bogdanovic was hitting this error recently (cc'd).
> There are a lot of PRIMITIVE_RECVD messages in the log, which make me
> wonder if the expander is being flaky or something?  The commands that
> start timing out under heavy load followed by the repeated broadcasts
> might be indicative of that, since the sequencer firmware and the kernel
> driver are up to date.  Unfortunately, I don't have any LSI expanders...

I do, and actually, I've seen behaviour like this, except on a SATAPI
DVD not a disk.  What seems to happen is that the expander hangs up on
the device and I can't recover it except by power cycling the expander
(other devices on the expander continue to work normally).

The problem is (if it is the same problem) there isn't any defined error
recovery from this ... the standards don't contain an expander reset,
and the expander isn't responding to the phy reset (either hard or
soft). So I'm not sure what can be done at this point.

James


