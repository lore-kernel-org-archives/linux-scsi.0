From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: devices with more than one node
Date: Tue, 13 Jan 2004 15:01:47 -0800
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <20040113150147.A9902@beaverton.ibm.com>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20040113212058.GA2595@kroah.com>; from greg@kroah.com on Tue, Jan 13, 2004 at 01:20:58PM -0800
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Greg KH <greg@kroah.com>
Cc: Olaf Hering <olh@suse.de>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 13, 2004 at 01:20:58PM -0800, Greg KH wrote:
> On Tue, Jan 13, 2004 at 10:11:22PM +0100, Olaf Hering wrote:
> >  On Tue, Jan 13, Greg KH wrote:
> > > On Tue, Jan 13, 2004 at 08:38:42PM +0100, Olaf Hering wrote:
> > > > inputdevices have also an event node attached.
> > > 
> > > Yes, and you get two different hotplug events, and udev just works,
> > > right?  (this is with the kernel patches I sent out last week...)
> > 
> > I tried the -mm tree, and /proc/bus/input/devices differs indeed. Havent
> > tried to feed udev with the data.
> 
> Look at /sys/class/input in the -mm kernel.  I didn't do anything with
> the /proc/bus/input stuff.
> 
> > > > Maybe I miss the obvious, but how do I match scsi as example? Not that
> > > > sg provides a sg 'dev' entry today, but an external PROGRAM could not
> > > > provide an relative symlink to sgN.
> > > 
> > > scsi needs to create a scsi_generic class (or some such name) and have
> > > it contain the sg information.  It should not be in the cdev directory
> > > like it currently is (that's badly broken and should have never made it
> > > in...)  That sg class can contain the symlink back to the device that it
> > > is associated with.
> > > 
> > > Does this help?
> > 
> > Yes. Do you have a patch for that? Or should the scsi people do it?
> 
> The scsi people should do it :)
> 
> But if pushed hard enough, I guess I could do it...
> I do need to make cdev disappear from the sysfs tree entirely anyway...
> 
> If only I had more time.  Anyone else want to do this?
> 
> thanks,
> 
> greg k-h

Don't forget to let the scsi people know ;-) cc-ing linux-scsi

st also needs changes.

Did anyone figure out how udev should handle the one tape device requiring
multiple minors (for open/close with/without rewind)? It really is a
single device requiring multiple dev entries.

For scsi_id support with udev, st needs to support SG_IO, AFAIUI it can
use similiar code as found in sd.c and sr.c.

-- Patrick Mansfield


-------------------------------------------------------
This SF.net email is sponsored by: Perforce Software.
Perforce is the Fast Software Configuration Management System offering
advanced branching capabilities and atomic changes on 50+ platforms.
Free Eval! http://www.perforce.com/perforce/loadprog.html
