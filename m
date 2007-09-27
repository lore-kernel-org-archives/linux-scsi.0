From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning
 down disk
Date: Thu, 27 Sep 2007 17:16:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709271704290.7735-100000@iolanthe.rowland.org>
References: <BAY119-W38D77E53399EF6B34689B0B6B10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <BAY119-W38D77E53399EF6B34689B0B6B10@phx.gbl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Steve Calfee <stevecalfee@hotmail.com>
Cc: James Bottomley <james.bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 27 Sep 2007, Steve Calfee wrote:

> Isn't power saving a policy decision?

Whether or not power saving should be implemented and under what 
conditions it should occur are indeed policy decisions.  However the 
decision to actually power-down a device (because the specified 
conditions have occurred) is not a policy decision -- it is an action 
to carry out a policy.

>  Should it not be left to
> userspace to control?

No.  You shouldn't expect users to run a program that would notice a 
particular disk drive hasn't been used in X minutes and then power it 
down.  (Although they could if they wanted to... except that there's no 
way for userspace to know when the drive was most recently used.)

> Doesn't userspace decide to blank the video based on user
> preferences?

The X server runs in userspace, yes.  However VT console blanking is 
part of the kernel.  So it works both ways.

> Userspace could jump through all sorts of hoops to wait
> for disks to spin down, etc on the way to powersaving.

I'm not sure what you mean here.  What I have described is the way
Windows works, for example.  You tell the system how long you want it
to wait before spinning down an idle drive and it takes care of
everything else; you don't have to tell it each time you want the drive
spun down.

> If we really need the capability to suspend a mouse/keyboard etc
> after 2-n seconds of no use, shouldn't it be userspace that enables
> the "autosuspend"?

If by "enables" you mean that userspace tells the system the value of 
n, then yes.  If you mean that userspace waits until the mouse/keyboard 
has been inactive for n seconds and tells the system to suspend it, 
then no.  (That wouldn't be an autosuspend anyway -- it would be a 
manual suspend.)

> Has the battery life impact of the various device
> shutdowns been measured and found useful?

Yes.

> Just a bunch of questions, but it seems to me that what is really
> needed is a mechanism for userspace to do fine grained power control.

There is such a mechanism, for USB at least.  (Not well documented yet;  
I'm working on it.)  If userspace wants to, it can disable autosuspend
and do everything manually.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
