From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.5.63-mm2
Date: Wed, 5 Mar 2003 10:52:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305185231.GE1090@beaverton.ibm.com>
References: <20030302180959.3c9c437a.akpm@digeo.com> <1046815078.12931.79.camel@ibm-b> <20030304234042.2553deed.akpm@digeo.com> <20030305173854.GA1090@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030305173854.GA1090@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, Mark Wong <markw@osdl.org>, linux-scsi@vger.kernel.org

The patch below fixed the problem on my system. I had my list empty
checks reversed if aborting and bus device reset failed. The condition
that causes the error handler to run is still unknown. I will look at it
when I get a chance.

Mike Anderson [andmike@us.ibm.com] wrote:
> I can also reproduce the problem on my system now that I switch from new
> AIC7xxx to old AIC7xxx. I am looking at the problem now.
> 
> Andrew Morton [akpm@digeo.com] wrote:
> > Mark Wong <markw@osdl.org> wrote:
> > >
> > > It appears something is conflicting with the old Adapatec AIC7xxx.  My
> > > system halts when it attempts to probe the devices (I think it's that.) 
> > > So I started using the new AIC7xxx driver and all is well.  I don't see
> > > any messages to the console that points to any causes.  Is there
> > > someplace I can look for a clue to the problem?
> > > 
> > > I actually didn't realize I was using the old driver and have no qualms
> > > about not using it, but if it'll help someone else, I can help gather
> > > information.
> > > 
> > 
-andmike
--
Michael Anderson
andmike@us.ibm.com


=====
name:		00_scsi_error_ready_devs-1.diff
version:	2003-03-05.10:39:28-0800
against:	2.5.63

 scsi_error.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

=====
===== drivers/scsi/scsi_error.c 1.38 vs edited =====
--- 1.38/drivers/scsi/scsi_error.c	Sat Feb 22 08:17:01 2003
+++ edited/drivers/scsi/scsi_error.c	Wed Mar  5 10:14:22 2003
@@ -1490,9 +1490,9 @@
 			       struct list_head *work_q,
 			       struct list_head *done_q)
 {
-	if (scsi_eh_bus_device_reset(shost, work_q, done_q))
-		if (scsi_eh_bus_reset(shost, work_q, done_q))
-			if (scsi_eh_host_reset(work_q, done_q))
+	if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
+		if (!scsi_eh_bus_reset(shost, work_q, done_q))
+			if (!scsi_eh_host_reset(work_q, done_q))
 				scsi_eh_offline_sdevs(work_q, done_q);
 }
 

