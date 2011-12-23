From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM TOPIC] linux servers as a storage server - what's
 missing?
Date: Thu, 22 Dec 2011 20:35:07 -0800
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D157077DD22DED@BLRX7MCDC203.AMER.DELL.COM>
References: <4EF2026F.2090506@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>
 <20111222155849.GD1388@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM>
 <20111223030632.GF12738@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111223030632.GF12738@redhat.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: rwheeler@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@redhat.com]
> Sent: Thursday, December 22, 2011 10:07 PM
> To: Iyer, Shyam
> Cc: rwheeler@redhat.com; linux-fsdevel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's
> missing?
> 
> On Fri, Dec 23, 2011 at 02:24:42AM +0530, Shyam_Iyer@Dell.com wrote:
> >
> >
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > owner@vger.kernel.org] On Behalf Of Vivek Goyal
> > > Sent: Thursday, December 22, 2011 10:59 AM
> > > To: Iyer, Shyam
> > > Cc: rwheeler@redhat.com; linux-fsdevel@vger.kernel.org; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [LSF/MM TOPIC] linux servers as a storage server -
> what's
> > > missing?
> > >
> > > On Thu, Dec 22, 2011 at 01:44:16PM +0530, Shyam_Iyer@Dell.com
> wrote:
> > >
> > > [..]
> > >
> > > > Simple asks -
> > > > 1) Provide a consistent storage and fs management library that
> > > discourages folks to write their own usespace storage library.
> Include
> > > things like fs formatting(fs profiles), transport configuration(eg:
> > > iscsiadm as a library), thin provisioning watermarks, cluster
> > > management, apis for cgroups etc.
> > >                                       ^^^^^^^^^^^^^^^^
> > > For cgroups, we have libcgroup library. Not many people like to use
> it
> > > though as cgroup is exported as a filesystem and they prefer to use
> > > normal
> > > libc api to traverse and configure cgroups (Instead of going
> through
> > > another library). Some examples include libvrit, systemd.
> > >
> > > Thanks
> > > Vivek
> >
> > Well honestly I think that is a libvirt/systemd issue and libvirt
> also invokes things like iscsiadm, dcb etc as a binary :-/
> >
> > Some one could always use qemu command lines to invoke KVM/XEN but
> libvirt has saved me one too many days in doing a quick operation
> without wondering about a qemu commandline.
> >
> > I am also asking for ideas on how to avoid this fragmentation because
> just like libvirt others are also encouraged to do their own libc thing
> in the absence of a common storage management framework..
> >
> > Does the standard interface for linux end at the user/kernel boundary
> or the user/libc boundary? If so I feel we would continue to lag behind
> other OSes in features because of the model.
> 
> This is true only for IO cgroup management. There is not much to be
> done. For
> basic management, an applicatoin can just write 500 lines of code and
> be
> done with it.
> 
> libcgroup does offer bunch of commnad lines operations too.
> 
> Do you have something in mind, what applications expect out of a IO
> cgroup
> library and what other OSes are supporting. Don't extend this libc
> thing
> to iscsi, and other storage management requirements.

Sorry Vivek but that is just one of the points in my original post..

I think I am providing points on how to improve linux as a storage server and therefore I don't want to restrict the discussion to io cgroup alone. 

The problem is a lack of framework that  looks somewhat like this.. (I hope the formatting is preserved )



	Fs management	IO cgroup management	Monitoring Apis	      HBA Management			Thin provisioning
	Fs_create()		bw				log_dump			HBA Apis					Watermark
	Snap_create						scsi_log				\					\
								fs_log				 hba_create				 High
	...							io_log				\					\
	...												 iscsi_session_create		 Alarms/Notifications
	|			|				|					\
	|			|				|					 fc_login

------------------------------------------------------------Storage API-----------------------------------------------------------




Double clicking on FS Management
VFS
\
 Fs_clone
\
 Copy Offload
-------------------------			
|		|		|
|		|		|
Ext 4		btrfs		nfs


For eg: If ext4 did not support discard it would return an error with one of the fs apis.

Unless you have a unified interface there won't be uniformity of features or coordination to make linux a complete storage server with apps that do things at the higher layer. 

Today if xfs supports copy offload it would be an intuitive guess on the part of the app running on top of it.
If you want to create thin provisioning water marks possibly  snapshot management is a different tool.


I think the reason libvirt has so many features built in quickly is because of the modular architecture and clear interface it provides for creating and managing virtual machines.

Today if I had to write a virtualization management tool with libvirt as the back end for VM management it is really a question of whether there is an API support or not..

So.. in that sense linux has matured as a virtualization server. I don't think I can do that for storage..

Now while we are talking about storage servers it is important to note if we are talking about servers with local storage or attached remote storage and so I added transport management apis to the framework along with the hba management apis..

Which is why I think storage management could get a better interface than just libc/ ioctl calls/sysfs operations


On your question on what applications would like out of io cgroups..

I think that is for a different discussion.. ;-) But nevertheless here is something I was thinking..

Apis around the following.. there can be more..
-io timeouts, driver/controller, scsi, blk, fs etc
-io scheduler tunings, io_delay, read_ahead,
-bw profile
-IOPs stats
-io resource monitoring - Eg:  spindle movement per application run. This will help in data placement.

For a storage server folks do a lot of tuning to qualify it. Having apis to manage these and auto calibrate them with application performance load would be awesome..


