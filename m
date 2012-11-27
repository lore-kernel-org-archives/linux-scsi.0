From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/11] IB/srp: don't send anything on a bad QP
Date: Mon, 26 Nov 2012 22:31:24 -0500
Message-ID: <1353987084.28917.10.camel@obelisk.thedillows.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <90b21916a384281682d520302b594834e010671b.1353903448.git.dillowda@ornl.gov>
	 <50B333AF.6040509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B333AF.6040509-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-26 at 10:17 +0100, Bart Van Assche wrote:
> On 11/26/12 05:44, David Dillow wrote:
> > Once we know we have an issue with the QP, there is no point trying to
> > send anything else down the pipe. This also allows us to consolidate
> > code in the SCSI EH path.

> After I posted the patch on which the above patch has been based I 
> realized that testing the connection state at the start of 
> srp_send_tsk_mgmt() is not sufficient to avoid QPN use-after-free. If a 
> DREQ is received by the initiator after the above test has been 
> performed and before the task management function has been sent it is 
> still possible to send a task management function over a closed QP.

AFIACT, DREQ does not actually close the QP -- it only tells us that the
other side would like to. We don't actually close the connection until
we try to send on it again, I think -- not sure if we see recv failures
for the queued work items.

Regardless, the issue of resource lifetime is an issue that needs
solving.

>  I'd like to address this in a different way - see also the thread called 
> "SCSI LLDs, the SCSI error handler and host resource lifetime" on the 
> linux-scsi mailing list (November 20, 
> http://marc.info/?t=135342155500003&r=1).

I like the direction you propose there. It seems that scsi_remove_host()
at one point waited for the EH thread to exit -- or perhaps it was part
of scsi_host_put() chain -- as there's the longstanding deferral to the
work queue for the SRP target removal. Of course, that's been there for
~5 years now, and things have changed in the SCSI stack.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
