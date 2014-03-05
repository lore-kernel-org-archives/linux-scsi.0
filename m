From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Tue, 04 Mar 2014 16:06:47 -0800
Message-ID: <1393978007.30113.4.camel@haakon3.risingtidesystems.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
	 <5315EE7C.3030806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5315EE7C.3030806-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-03-04 at 17:17 +0200, Sagi Grimberg wrote:
> On 3/4/2014 2:00 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> >
> > Hi Or & Sagi,
> >
> > This series addresses a number of active I/O shutdown related issues
> > in iser-target code that have come up recently during stress testing.
> >
> > Note there is still a seperate iser-target network portal shutdown
> > bug being tracked down, but this series addresses all existing issues
> > related to active I/O session shutdown.
> >
> > The patch breakdown looks like:
> >
> > Patch #1 fixes a long-standing bug where TPGs in shutdown incorrectly
> > could be referenced by new login attempts.
> >
> > Patch #2 converts list_del -> list_del_init for iscsi_cmd->i_conn_node
> > so that list_empty works correctly.
> >
> > Patch #3 addresses isert_conn->state related bugs resulting in hung
> > shutdown, and splits isert_free_conn() into seperate code that is
> > called earlier during shutdown to ensure that all outstanding I/O
> > has completed.
> >
> > Patch #4 fixes incorrect accounting of ->post_send_buf_count during
> > active I/O shutdown with outstanding RDMA WRITE + RDMA READ work
> > requests.
> >
> > Patch #5 addresses a bug related to active I/O shutdown with
> > outstanding FRMR work requests.  Note this patch is specific to
> > v3.12+ code.
> >
> > Patch #6 addresses bugs related to active I/O shutdown with
> > outstanding completion interrupt coalescing batches. Note this patch
> > is specific to v3.13+ code.
> >
> > Please review.
> 
> Hey Nic,
> 
> So besides a minor comment, you have my Ack on this set.
> 

Thanks!

> More on cleanup flow. isert_cma_handler does not handle 
> RDMA_CM_EVENT_TIMEWAIT_EXIT.
> To be more specific, according to IB spec, when initiating disconnect 
> (rdma_disconnect/ib_send_cm_dreq),
> one should not destroy a used qp until getting TIMEWAIT_EXIT CM event. 
> We are working on this in iSER initiator.
> It might lead to "stale connection" CM rejects on future connections 
> (SRP also does not do that).
> 

<nod>, I noticed that as well during recent debugging.

However, AFAICT the RDMA_CM_EVENT_TIMEWAIT_EVENT doesn't (always) occur
on the target side after a RDMA_CM_EVENT_DISCONNECTED, and thus far I've
not been able to ascertain what's different about the shutdown sequence
that would make this happen, or not happen..

Any ideas..?

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
