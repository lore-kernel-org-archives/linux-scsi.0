From: dougg@torque.net
Subject: Re: devices with more than one node
Date: Tue, 13 Jan 2004 20:12:56 -0500
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <1074042776.4004979822819@wwws.torque.net>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com> <20040113150147.A9902@beaverton.ibm.com> <20040113231813.GA7409@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <20040113231813.GA7409@kroah.com>
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Greg KH <greg@kroah.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Olaf Hering <olh@suse.de>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting Greg KH <greg@kroah.com>:

> On Tue, Jan 13, 2004 at 03:01:47PM -0800, Patrick Mansfield wrote:
> > Don't forget to let the scsi people know ;-) cc-ing linux-scsi
> 
> Ok, here goes:
> 
> linux-scsi, DO NOT USE THE cdev sysfs directory.  It will be going away
> as soon as I get around to writing the patch for it.  Putting the sg
> symlink in there is not the proper place.

Greg,
Is the register_chrdev_region() call which according to
J. Corbet's documentation allows support for more than 256 
devices, going away? Or is it simply going to lose its
sysfs visibility (in the /sys/cdev/major directory)?
 
> For scsi generic you should create a scsi generic class (scsi_generic?)
> and create the individual sg devices in that directory (feel free to use
> the simple_class.c code that is currently in the -mm tree if you want,
> it makes it much simpler)

Does any device use the simple_class.c code yet?
 
> > st also needs changes.

and osst.

Kai changed the st naming scheme in /sys/cdev/major/st*
in a way that seems to allow for more than 8 variants
of each device.
 
> I agree.
> 
> > Did anyone figure out how udev should handle the one tape device requiring
> > multiple minors (for open/close with/without rewind)? It really is a
> > single device requiring multiple dev entries.
> 
> Create multiple class_device items for every tape device and have the
> device symlink point to the same scsi device.  The simple_class code
> should make life a lot easier for you.
> 
> > For scsi_id support with udev, st needs to support SG_IO, AFAIUI it can
> > use similiar code as found in sd.c and sr.c.
> 
> That's a scsi core issue, not a udev issue :)

Well, before cdev gets ripped out, following two symlinks
(i.e. tape -> device -> generic) solves the long standing
ULD to sg (and vice versa) mapping problem.

It shouldn't be too hard putting (another) implementation
of the SG_IO in scsi/scsi_ioctl.c next to the
implementation of the SCSI_IOCTL_SEND_COMMAND ioctl.

Doug Gilbert






-------------------------------------------------------
This SF.net email is sponsored by: Perforce Software.
Perforce is the Fast Software Configuration Management System offering
advanced branching capabilities and atomic changes on 50+ platforms.
Free Eval! http://www.perforce.com/perforce/loadprog.html
