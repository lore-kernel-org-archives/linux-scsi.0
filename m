From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Fri, 14 Feb 2003 08:58:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030214165827.GA1165@beaverton.ibm.com>
References: <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com> <20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com> <20030213192440.A6660@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030213192440.A6660@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Doug Ledford [dledford@redhat.com] wrote:
> On Thu, Feb 13, 2003 at 01:55:15PM -0500, Luben Tuikov wrote:
> > 	::same_target_siblings -- this shouldn't exist by design.
> 
> Yes!  That one most certainly should exist!  There are lots of operations 
> in the scsi protocol that are target specific instead of lun specific and 
> having a quick, cheap way of getting to all the luns on a single target is 
> important (for example, on SPI, all device transfer negotiations are 
> target specific, so when you negotiate a speed with target 0 lun 0, you 
> have also negotiated the speed of target 0 lun 1, and getting to and 
> setting the "I've already negotiated with this device" flag on all your 
> luns should be quick and easy).  Now, there are really only a few places 
> where this kind of target vs. lun view is important:
> 
> device_busy:  we need to know how many commands are active on a lun, and 
> in some cases also on a target.  So this should really be 
> "active_cmd_count_target" and "active_cmd_count_lun" to use Luben's 
> preferred names.  The active_cmd_count_target would actually have to be a 
> pointer to the single real counter while each scsi device would have an 
> independant lun counter.  This makes single_lun devices simpler because we 
> just check that active_cmd_count_target == 0 before queueing a command.
> 
> hostdata:  ideally this would be lldd_lun_data and lldd_target_data and 
> each would be a pointer that the lldd could init during slave_alloc() 
> time.  That way if a lldd cares about the difference between target and 
> lun data structs, then it can put them in different areas and treat them 
> appropriately.
> 
> Hmmm...those are the two most important items.  There may be others I'm 
> forgetting.  But, take care of those two and you should then be able to 
> eliminate the same_target_siblings without incurring a bad performance 
> penalty on single_lun devices.

The need is there for per target data, but if we talk about future
directions it would appear a cleaner interface would be to have luns as
children of the targets (? ports ?) vs having a list of luns and post linking
relationships.

In the past I had a similar relationship of targets to luns to SDTR /
WDTR values that have been negotiated in firmware of a SCSI HA.

-andmike
--
Michael Anderson
andmike@us.ibm.com

