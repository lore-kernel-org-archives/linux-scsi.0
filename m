From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Sat, 10 Nov 2012 09:56:24 +0100
Message-ID: <509E16B8.4070506@acm.org>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <94D0CD8314A33A4D9D801C0FE68B40294C343A4A@G1W3652.americas.hpqcorp.net> <50996116.4080900@acm.org> <x49pq3my061.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:40462 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2KJI42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Nov 2012 03:56:28 -0500
In-Reply-To: <x49pq3my061.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Robert Elliott <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/09/12 21:46, Jeff Moyer wrote:
>> On 11/06/12 16:41, Elliott, Robert (Server Storage) wrote:
>>> It's certainly better to tie them all to one node then let them be
>>> randomly scattered across nodes; your 6% observation may simply be
>>> from that.
>>>
>>> How do you think these compare, though (for structures that are per-IO)?
>>> - tying the structures to the node hosting the storage device
>>> - tying the structures to the node running the application
>
> This is a great question, thanks for asking it!  I went ahead and
> modified the megaraid_sas driver to take a module parameter that
> specifies on which node to allocate the scsi_host data structure (and
> all other structures on top that are tied to that).  I then booted the
> system 4 times, specifying a different node each time.  Here are the
> results as compared to a vanilla kernel:
>
> data structures tied to node 0
>
> application tied to:
> node 0:  +6% +/-1%
> node 1:  +9% +/-2%
> node 2:  +10% +/-3%
> node 3:  +0% +/-4%
>
> The first number is the percent gain (or loss) w.r.t. the vanilla
> kernel.  The second number is the standard deviation as a percent of the
> bandwidth.  So, when data structures are tied to node 0, we see an
> increase in performance for nodes 0-3.  However, on node 3, which is the
> node the megaraid_sas controller is attached to, we see no gain in
> performance, and we see an increase in the run to run variation.  The
> standard deviation for the vanilla kernel was 1% across all nodes.
>
> Given that the results are mixed, depending on which node the workload
> is running, I can't really draw any conclusions from this.  The node 3
> number is really throwing me for a loop.  If it were positive, I'd do
> some handwaving about all data structures getting allocated one node 0
> at boot, and the addition of getting the scsi_cmnd structure on the same
> node is what resulted in the net gain.
>
> data structures tied to node 1
>
> application tied to:
> node 0:  +6% +/-1%
> node 1:  +0% +/-2%
> node 2:  +0% +/-6%
> node 3:  -7% +/-13%
>
> Now this is interesting!  Tying data structures to node 1 results in a
> performance boost for node 0?  That would seem to validate your question
> of whether it just helps out to have everything come from the same node,
> as opposed to allocated close to the storage controller.  However, node
> 3 sees a decrease in performance, and a huge standard devation.  Node 2
> also sees an increased standard deviation.  That leaves me wondering why
> node 0 didn't also experience an increase....
>
> data structures tied to node 2
>
> application tied to:
> node 0:  +5% +/-3%
> node 1:  +0% +/-5%
> node 2:  +0% +/-4%
> node 3:  +0% +/-5%
>
> Here, we *mostly* just see an increase in standard deviation, with no
> appreciable change in application performance.
>
> data structures tied to node 3
>
> application tied to:
> node 0:  +0% +/-6%
> node 1:  +6% +/-4%
> node 2:  +7% +/-4%
> node 3:  +0% +/-4%
>
> Now, this is the case where I'd expect to see the best performance,
> since the HBA is on node 3.  However, that's not what we get!  Instead,
> we get maybe a couple percent improvement on nodes 1 and 2, and an
> increased run-to-run variation for nodes 0 and 3.
>
> Overall, I'd say that my testing is inconclusive, and I may just pull
> the patch set until I can get some reasonable results.

Which NUMA node was processing the megaraid_sas interrupts in these 
tests ? Was irqbalance running during these tests or were interrupts 
manually pinned to a specific CPU core ?

Thanks,

Bart.
