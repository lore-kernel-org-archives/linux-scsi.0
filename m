From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi device refcounting in sbp2 (was Re: [PATCH 3/8] aacraid:
	handle AIF hotplug events)
Date: Sat, 10 Sep 2005 17:49:45 -0500
Message-ID: <1126392585.4813.79.camel@mulgrave>
References: <200509102116.j8ALGqt8011874@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <200509102116.j8ALGqt8011874@einhorn.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, Ben Collins <bcollins@debian.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2005-09-10 at 23:16 +0200, Stefan Richter wrote:
> I was just trying to adapt that fix and stumbled upon potential problems
> of my code. Two questions:
> 
> 1. Is the following sequence safe?
> [connect to device]
> 	sdev = __scsi_add_device();
> 	scsi_device_put(sdev);
> 	store sdev in sbp2's private data for later use
> [sbp2 .remove hook]
> 	scsi_remove_device(sdev);

not really ... you have an undeclared reference to sdev.  If someone
removed it outside of the driver (using one of the remove APIs) then
you'd be left with a stale pointer.


> 2. Is this safe?
> [connect to device]
> 	sdev = __scsi_add_device();
> 	scsi_device_put(sdev);
> [sbp2 .remove hook]
> 	scsi_remove_host(shost);
> I ask because scsi_remove_host will implicitly remove the device too.
> 
> BTW, the following won't work:
> [connect to device]
> 	sdev = __scsi_add_device();
> 	store sdev for later use
> [sbp2 .remove hook]
> 	scsi_remove_device(sdev);
> 	scsi_device_put(sdev);
> That way, "modprobe -r sbp2" would fail because sbp2 is "in use" until
> scsi_device_put.

well, you could do this

[connect to device]
	sdev = __scsi_add_device();
	get_device(&sdev->sdev_gendev);
	scsi_device_put(sdev);
	store sdev for later use
[sbp2 .remove hook]
	scsi_remove_device(sdev);
	put_device(&sdev->sdev_gendev);

But that would hold the device for the entire lifetime of your module,
which I think, isn't really what you want.  Any user requested removal
would remove the visibility of the device but wouldn't actually destroy
it (so the next add would get into difficulty).  I suspect what you want
to do is something like this:

[connect to device]
	scsi_add_device();
	store sdev parameters (id and lun) for later use
[sbp2 .remove hook]
	spin_lock_irqsave(host_lock);
	sdev = __scsi_lookup_device(shost, c, id, lun);
	spin_unlock_irqsave(host_lock);
	if (sdev)
		scsi_remove_device(sdev);

which will behave correctly if the user removes the device;  It's a bit
inelegant, but it should be the minimum code change.

A better method would be to use the slave_alloc/slave_destroy hooks to
attach your data to that of the device.  You know that if slave_destroy
hasn't been called on the sdev, then it must be valid ... and you also
know that the user has requested an ejection if you get a slave_destroy
() call on it.

James









-------------------------------------------------------
SF.Net email is Sponsored by the Better Software Conference & EXPO
September 19-22, 2005 * San Francisco, CA * Development Lifecycle Practices
Agile & Plan-Driven Development * Managing Projects & Teams * Testing & QA
Security * Process Improvement & Measurement * http://www.sqe.com/bsce5sf
