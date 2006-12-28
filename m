From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] ieee1394: sbp2: pass REQUEST_SENSE through to the target
Date: Thu, 28 Dec 2006 15:21:45 -0500
Message-ID: <45942759.8080804@torque.net>
References: <tkrat.9e24970727f8c664@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.9e24970727f8c664@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Delete some incorrect code, left over from the initial driver submission
> in March 2001.
> 
> SBP-2 targets should provide sense data via the SBP-2 status block
> (autosense).  We have to pass the REQUEST_SENSE command through to
> targets which don't implement autosense, if there are any.

Umm, REQUEST SENSE has several other useful capabilities.
It can convey information about low power conditions,
a progress indicator (e.g. during FORMAT with IMMED=1)
and informational exception warnings. It is also
defined to work any time INQUIRY works (e.g. on lun=0
when there is no lu there but there is a lun>0).

smartmontools sets MRIE to 6 in the control mode page so
it can periodically poll a disk with REQUEST SENSE to see
if it has tripped a threshold . It could use other techniques
but they would most likely interfere with normal error
processing on the host OS (and linux is one of about 8).

So, this patch is a step in the right direction.
Hopefully not too many other LLDs are playing
games with REQUEST SENSE.

Doug Gilbert

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
