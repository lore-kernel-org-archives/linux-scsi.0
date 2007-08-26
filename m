From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 8940] New: BUG: unable to
 handle kernel NULL pointer dereference at virtual address 00000000
Date: Sun, 26 Aug 2007 16:56:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708261645170.10968-100000@netrider.rowland.org>
References: <20070826135745.GE14130@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070826135745.GE14130@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, dchris@gmail.com, bugme-daemon@bugzilla.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Sun, 26 Aug 2007, Matthew Wilcox wrote:

> On Sun, Aug 26, 2007 at 12:52:07AM -0700, Andrew Morton wrote:
> > On Sat, 25 Aug 2007 09:47:40 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > > Problem Description: I got this error message:
> > > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > > 00000000
> > > in dmesg output when connecting a USB device. Turning off
> > > CONFIG_SCSI_SCAN_ASYNC fixed the problem. Apparently there is a bug in SCSI
> > > core code.
> 
> I don't think SCSI_SCAN_ASYNC is the problem.  It's probably a
> coincidence.  SCSI_SCAN_ASYNC doesn't touch the call-path reported in
> the backtrace.

It's not a coincidence.  The oops occurred because of the way the async
scanning routine registers new devices.  See the explanation and
discussion in this thread:

	http://marc.info/?l=linux-scsi&m=118650567017151&w=2

> In any case, if it is SCSI_SCAN_ASYNC-related, there's an outstanding
> patch to fix the locking, which is slated for inclusion in 2.6.24.
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=a93a091df8232fad60867d41fbc3be855a0b78f2

I have seen exactly this same problem, and it also shows up in Bugzilla
entries #8840 and #8846.  The patch mentioned above did fix it.

I thought (and still do think!) that the patch should go into 2.6.23 
and 2.6.22-stable.  Why wait for 2.6.24 for a serious bugfix?

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
