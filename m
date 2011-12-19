From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 10/14] srp_transport: Simplify attribute initialization
 code
Date: Sun, 18 Dec 2011 19:07:22 -0500
Message-ID: <1324253243.17849.45.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012008.00502.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012008.00502.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-01 at 20:08 +0100, Bart Van Assche wrote:
> Eliminate the private_rport_attrs[] array and the SETUP_*() macros
> used to set up that array since the information in that array
> duplicates the information in the static device attributes. Also,
> trigger a kernel warning if SRP_RPORT_ATTRS is not large enough
> since it is easy to forget to update that macro when adding new
> attributes.

Not sure I care one way or the other, but it looks to have been written
the way it was to share a common code structure with the FC, SAS, and
other SCSI transport code. They use a BUG_ON instead of WARN_ON, which
seems more appropriate, since we just overran a buffer...

The SCSI guys need to review this one, as it needs their ack.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
