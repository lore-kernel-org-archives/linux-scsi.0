From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Date: Mon, 24 Sep 2018 22:18:52 +0200
Message-ID: <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath> <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath> <20180918175952.GJ11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180918175952.GJ11367-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Platform Driver <platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qat-linux-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, "open list:HID CORE LAYER" <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, ceph-devel <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gregkh <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>Linux Kernel Mailing List <l>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>
> On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > >
> > > > Acked-by: Darren Hart (VMware) <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > > >
> > > > As for a longer term solution, would it be possible to init fops in such
> > > > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > > > so we don't have to duplicate this boilerplate for every ioctl fops
> > > > structure?
> > >
> > >     Bad idea, that...  Because several years down the road somebody will add
> > > an ioctl that takes an unsigned int for argument.  Without so much as looking
> > > at your magical mystery macro being used to initialize file_operations.
> >
> > Fair, being explicit in the declaration as it is currently may be
> > preferable then.
>
> It would be much cleaner and safer if you could arrange things to add
> something like this to struct file_operations:
>
>   long (*ptr_ioctl) (struct file *, unsigned int, void __user *);
>
> Where the core code automatically converts the unsigned long to the
> void __user * as appropriate.
>
> Then it just works right always and the compiler will help address
> Al's concern down the road.

I think if we wanted to do this with a new file operation, the best
way would be to do the copy_from_user()/copy_to_user() in the caller
as well.

We already do this inside of some subsystems, notably drivers/media/,
and it simplifies the implementation of the ioctl handler function
significantly. We obviously cannot do this in general, both because of
traditional drivers that have 16-bit command codes (drivers/tty and others)
and also because of drivers that by accident defined the commands
incorrectly and use the wrong type or the wrong direction in the
definition.

       Arnd
