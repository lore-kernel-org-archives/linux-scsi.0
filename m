From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Thu, 4 Mar 2004 22:52:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305065221.GB123190@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org> <20040303101014.GA586666@sgi.com> <20040305055117.GA9315@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:50058 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S262223AbUCEGw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2004 01:52:29 -0500
Content-Disposition: inline
In-Reply-To: <20040305055117.GA9315@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, linux-scsi@vger.kernel.org

On Thu, Mar 04, 2004 at 09:51:17PM -0800, Andrew Vasquez wrote:
> 
> The intent of my original statement wasn't to imply that the
> readX_relaxed() routines wouldn't be applicable to PCI-[X|Express],
> but instead to note my own concerns with the differing semantics of
> readX_relaxed() and 'relaxed ordering' of PCI-[X|Express], which you
> mention below.

I understand.  I think if you have a bridge that allows you to set
the RO bit, then you need a way to control when it is set.  I think
the readX_relaxed works very well for that.

> > When set, it indicates that the posted write or the read completion
> > (reply from the device to the PIO read) may pass other posted writes,
> > read completions, or messages.
> > 
> 
> I've read through the original readX_relaxed() thread posted on LK and
> no-one else seemed to express similiar concerns.  My own personal
> slant leans towards the readX_nosyncdma() name, but again I seem to
> always be in the minority...

That was a confusing thread that wandered a bit.  In PCI-Express (the
PCI-X writeup is a little different, though I think it explains
similar semantics), because it is no longer a bus, read requests and
read completions are always separate events.  So . . .

My understanding is that the host bridge will set (or clear) the RO
bit on the read request.  Then the target device copies the setting
of the RO bit on its read completion.  If the RO bit is set on the
completion, it is allowed to pass posted writes, other read completions,
and messages.  In that respect, it no longer "pushes" DMA writes to
complete before it does.  I don't think you'd want a host bridge that
unconditionally sets the bit, so if you're going to support setting
the RO bit as a bridge (or Root Complex in PCI-Express parlance), it
has to be under software control.

> Finally, in looking through other locations where we could apply this
> technique (though i must admit your patch covers almost all fast-path
> uses), the old calls to qla2x00_debounce_register(ISP_REQ_Q_OUT())
> in qla2x00_req_pkt() and qla2x00_ms_req_pkt() should be replaced with
> the standard RD_REG_WORD().  Through not in the fast, the
> RD_REG_WORD() could then be extended to the *_relaxed() calls.

Right.  Just about all register reads can actually be changed to
relaxed reads, since there are very few that imply DMA write completions.
I was trying to keep the patch small  :-)

> Thanks again for the patches.

Not at all.  Thank you for taking the time to look at them and
comment.

> Regards,
> Andrew Vasquez

thanks

jeremy
