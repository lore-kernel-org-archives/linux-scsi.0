From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg MiB writes scheduling while atomic
Date: Tue, 16 Sep 2003 16:35:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F66AF1B.5010402@torque.net>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>	 <1063217791.3669.43.camel@patehci2>  <1063219776.3669.72.camel@patehci2> <1063222216.3669.87.camel@patehci2>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:43486 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261297AbTIPGgN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 02:36:13 -0400
In-Reply-To: <1063222216.3669.87.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> By the way, I notice I can quickly repeat the first couple of lines of
> Call Trace if I interrupt the default 0.25 MiB writes of sg_dd with
> Ctrl+C:
> 
> 
>>http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO/sg3_utils.html
>>Appendix A. Sg3_utils package
>>variants of the Unix dd command:
>>sg_dd, sgp_dd, sgq_dd and sgm_dd, ...
>>...
>>http://www.torque.net/sg/
>>http://www.torque.net/sg/p/sg3_utils-1.05.tgz
>>$ tar -zx ...
>>$ cd sg3_utils-1.05
>>$ make
>>$ sudo ./sg_scan -i
>>$ sudo ./sg_dd of=/dev/sg1 if=/dev/zero bs=2k
>>^C
> 
> 
> Where I quote ^C I mean I use Ctrl+C to interrupt sg i/o.  I see I
> provoke such dmsg as:

Pat,
Thanks for bringing this up.

A user process is doing IO and the user decides to kill the
process while a command is "in flight". After the user hits
Ctrl+C, sg_close() is called and the sg driver lets it go
through (i.e. doesn't hold the user process in an unkillable
wait). Since the sg driver knows a command done notification
is coming (callback to sg_cmd_done()) then it keeps all its
related instances alive (including the scsi_device instance)
and notes this situation by setting its sfp->close flag.

When the callback arrives, the respone is discarded and if
this is the last outstanding command on this device then
scsi_device_put(sdp->device) is called. scsi_device_put()
isn't designed to be called from such a context. However sg
(and all other upper level drivers I suspect) have no suitable
context to call scsi_device_put() from in this situation.

Holding the sg_close() until the response arrives is an ugly
solution. Any better suggestions?

Doug Gilbert


