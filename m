From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: adaptec 2120S software under RedHat 8.0 and FC2
Date: Thu, 17 Mar 2005 08:41:18 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BED25F7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:34961 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263054AbVCQNlY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 08:41:24 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Macintyre <raz@macs.hw.ac.uk>, linux-scsi <linux-scsi@vger.kernel.org>

MarkH, I had submitted the patch in such a manner that the /proc section
is small, easily cut out, utilizes shared code with the /sys interface
and is ifdef'd with CONFIG_PROC_FS. Should be a simple adjustment based
on the scsi list consensus. Keeping the /proc code in the Adaptec branch
for legacy management tool support and cut out completely in the
kernel.org branch is fine by me.

We are pressuring our management application folks to switch to /sys as
well, has not happened yet. In part because changes have to work for all
tested releases and operating systems, our testing department only test
distributions in the requirement documents, fixes are only approved if
they affect current testing, certification testing requires a driver
that can be fixed and not errata'd and thus typically can not be in-box,
CONFIG_PROC_FS being on in all distributions and the need to keep the
/proc interface alive to permit the current and legacy applications in
test the ability to continue to function.

This momentum is at cross purposes for any deprecation activities in the
kernel.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Mark Haverkamp [mailto:markh@osdl.org] 
Sent: Wednesday, March 16, 2005 4:53 PM
To: Salyzyn, Mark; Christoph Hellwig
Cc: Ross Macintyre; linux-scsi
Subject: RE: adaptec 2120S software under RedHat 8.0 and FC2

On Wed, 2005-03-16 at 08:02 -0500, Salyzyn, Mark wrote:
> The applications require the Adaptec Branch of the driver in order to
> function (mainly because the kernel.org branch drops the
> /proc/scsi/aacraid entry). I have submitted a patch to Mark Haverkamp
> for consideration where we add the information back to the /sys
> filesystem, and the /proc filesystem (with CONFIG_PROC_FS defined)
that
> will help re-enable the applications.

The proc info code was removed almost two years ago.  I assume that it
was removed because of the move away from using /proc and towards
using /sys.  Christoph, is that the reason for its removal?

Mark.

> 
> There is also a Public GPL daemon, aeventd, that provides event
services
> that you may consider.
> 
> I will provide the sources for both under separate cover.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ross Macintyre
> Sent: Wednesday, March 16, 2005 6:20 AM
> To: linux-scsi@vger.kernel.org
> Subject: adaptec 2120S software under RedHat 8.0 and FC2
> 
> Could someone possibly help?
> 
> I have upgraded a machine from RedHat 8.0 to FC2 and the
> adaptec-browser1 and adaptec-smbe software that I installed is not
> working
> properly. It looks ok at first glance but if I pull a disk out I only
> get
> informed of the 'informational' type messages.
> (Also the browser interface to the RAID doesn't notice that the disk
has
> been pulled)
> 
> These are the RPMs that I installed from adaptec:
>   adaptec-browser-1.2b-2
>   adaptec-smbe-1.01.005-0
> 
> and I am running this kernel: 2.6.8-1.521smp
> 
> Note the mail part works ok and I do get informational messages when I
> use
> the browser interface and I tell it to rescan, (the array is rebuilt
> ok),
> but after the disk is pulled, from the browser interface it still
shows
> the disk as being there, and it is only when I tell it to rescan that
it
> starts sending out the informational messages and rebuilds.
> The messages are logged to /var/log/messages but it seems that
anotifyd
> is
> not picking them up.
> 
> Maybe I just need to upgrade the firmware and put on the latest RPMs?
> I think I am at firmware revision 7244.
> 
> I have attached the anotify.conf file.
> 
> Thanks in advance,
> Ross
> 
-- 
Mark Haverkamp <markh@osdl.org>

