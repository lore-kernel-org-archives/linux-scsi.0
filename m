From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v5 3/8] char: rpmb: add device attributes
Date: Thu, 1 Sep 2016 20:21:11 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542C5B85@hasmsx108.ger.corp.intel.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-4-git-send-email-tomas.winkler@intel.com>
 <20160831105634.GC10180@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160831105634.GC10180@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> 
> On Mon, Jul 18, 2016 at 11:27:48PM +0300, Tomas Winkler wrote:
> > Add attribute type that displays underlay storage type technology
> > EMMC, UFS, and attribute id, that displays underlay storage device id.
> > For EMMC this would be content of CID and for UFS serial number from
> > the device descriptor.
> >
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> > V2: resend
> > V3: set kernel version to 4.7
> > V4: update target date to Maj
> > V5: adjust date and kernel version
> >  Documentation/ABI/testing/sysfs-class-rpmb | 24 ++++++++++++
> >  drivers/char/rpmb/core.c                   | 63
> ++++++++++++++++++++++++++++++
> >  2 files changed, 87 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-class-rpmb
> > b/Documentation/ABI/testing/sysfs-class-rpmb
> > index 3ffcd2d1f683..7ca97d86bd97 100644
> > --- a/Documentation/ABI/testing/sysfs-class-rpmb
> > +++ b/Documentation/ABI/testing/sysfs-class-rpmb
> > @@ -18,3 +18,27 @@ Contact:	Tomas Winkler
> <tomas.winkler@intel.com>
> >  Description:
> >  		The /sys/class/rpmb/rpmbN directory is created for
> >  		each RPMB registered device
> > +
> > +What:		/sys/class/rpmb/rpmbN/id
> > +Date:		Aug 2016
> > +KernelVersion:	4.8
> > +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> > +Description:
> > +		The /sys/class/rpmb/rpmbN/id file contains device id
> > +		in a binary form
> 
> Oops, missed that you added these in a later patch, sorry about comment on
> patch 2.
> 
> binary attribute?  Why?

Each underlying storage device has different notion (UFS uses Unicode/emmc a whole structure),  all we care about here is that the other side (TEE) match the device.

> 
> > +
> > +What:		/sys/class/rpmb/rpmbN/type
> > +Date:		Aug 2016
> > +KernelVersion:	4.8
> > +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> > +Description:
> > +		The /sys/class/rpmb/rpmbN/type file contains device
> > +		underlay storage type technology: EMMC, UFS
> > +
> 
> What is this used for?

We try to provide  unified interface for all types storage devices but we cannot rule out that TEE won't need this more intimate information,
For example if it whish to parse the binary id info (introduced above) for any reason. 

> 
> > +What:		/sys/class/rpmb/rpmbN/reliable_wr_cnt
> > +Date:		Aug 2016
> > +KernelVersion:	4.8
> > +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> > +Description:
> > +		The /sys/class/rpmb/rpmbN/reliable_wr_cnt file contains
> > +		number of blocks that can be written in a single request
> 
> Why is this needed?  Shouldn't the normal block device export this type of
> information?
No, this is something specific for the RPMB partition. 
> 
> 
> > diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c index
> > ff10cbb7b644..63271c7ed072 100644
> > --- a/drivers/char/rpmb/core.c
> > +++ b/drivers/char/rpmb/core.c
> > @@ -308,6 +308,67 @@ struct rpmb_dev
> *rpmb_dev_find_by_device(struct
> > device *parent)  }  EXPORT_SYMBOL_GPL(rpmb_dev_find_by_device);
> >
> > +static ssize_t type_show(struct device *dev,
> > +			 struct device_attribute *attr, char *buf) {
> > +	struct rpmb_dev *rdev = to_rpmb_dev(dev);
> > +	ssize_t ret;
> > +
> > +	switch (rdev->ops->type) {
> > +	case RPMB_TYPE_EMMC:
> > +		ret = scnprintf(buf, PAGE_SIZE, "EMMC\n");
> 
> It's a sysfs file, no need for scnprintf() crap, just use sprintf() please.
> 
> > +		break;
> 
> And the code can be made smaller by just doing:
> 		return sprintf(buf, "EMMC\n");
> 
> :)

Okay

> 
> > +	case RPMB_TYPE_UFS:
> > +		ret = scnprintf(buf, PAGE_SIZE, "UFS\n");
> > +		break;
> > +	default:
> > +		ret = scnprintf(buf, PAGE_SIZE, "UNKNOWN\n");
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +static DEVICE_ATTR_RO(type);
> > +
> > +static ssize_t id_show(struct device *dev,
> > +		       struct device_attribute *attr, char *buf) {
> > +	struct rpmb_dev *rdev = to_rpmb_dev(dev);
> > +	size_t sz = min_t(size_t, rdev->ops->dev_id_len, PAGE_SIZE);
> > +
> > +	if (!rdev->ops->dev_id)
> > +		return 0;
> > +
> > +	memcpy(buf, rdev->ops->dev_id, sz);
> >
> 
> Hm, no.  That's not how a binary attribute works.  If you want a binary
> attribute, use that type, don't put binary data in a "normal" sysfs file.

Will fix. 


Thanks for review.
Tomas
