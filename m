From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 2/2 v2] scsi: ufs: use sysfs entry for health info
Date: Tue, 19 Dec 2017 14:45:31 -0800
Message-ID: <20171219224531.GA23445@jaegeuk-macbookpro.roam.corp.google.com>
References: <20171219200254.23120-1-jaegeuk@kernel.org>
 <20171219200254.23120-2-jaegeuk@kernel.org>
 <1513717650.2535.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513717650.2535.13.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jaegeuk@google.com" <jaegeuk@google.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On 12/19, Bart Van Assche wrote:
> On Tue, 2017-12-19 at 12:02 -0800, Jaegeuk Kim wrote:
> > This patch introduces sysfs entries to show the information.
> 
> What information does "the information" refer to?
> 
> Regarding the patch title: I think this patch introduces new sysfs attributes
> instead of using existing sysfs entries. If so, please reflect this in the patch
> title.
> 
> >  # cat /sys/devices/soc/1da4000.ufshc/health/eol
> >  # cat /sys/devices/soc/1da4000.ufshc/health/length
> >  # cat /sys/devices/soc/1da4000.ufshc/health/lifetimeA
> >  # cat /sys/devices/soc/1da4000.ufshc/health/lifetimeB
> >  # cat /sys/devices/soc/1da4000.ufshc/health/type
> 
> What is the meaning of the above shell commands in the context of the patch
> description?
> 
> > struct desc_field_offset health_desc_field_name[] = {
> > 	{"bLength",             0x00, BYTE},
> > 	{"bDescriptorType",     0x01, BYTE},
> > 	{"bPreEOLInfo",         0x02, BYTE},
> > 	{"bDeviceLifeTimeEstA", 0x03, BYTE},
> > 	{"bDeviceLifeTimeEstB", 0x04, BYTE}
> > };
> 
> Why has the above data been mentioned in the patch description?
> 
> > bPreEOLInfo
> >  - 00h: Not defined
> >  - 01h: Normal
> >  - 02h: Warning
> >  - 03h: Critical
> > 
> > bDeviceLifeTimeEstA
> >  - 00h: Not defined
> >  - 01h:  0% ~ 10% device life time used
> >  - 02h: 10% ~ 20% device life time used
> >  - 03h: 20% ~ 30% device life time used
> >  - 04h: 30% ~ 40% device life time used
> >  - 05h: 40% ~ 50% device life time used
> >  - 06h: 50% ~ 60% device life time used
> >  - 07h: 60% ~ 70% device life time used
> >  - 08h: 70% ~ 80% device life time used
> >  - 09h: 80% ~ 90% device life time used
> >  - 0Ah: 90% ~ 100% device life time used
> >  - 0Bh: Exceeded its maximum estimated device life time
> 
> Again, why has the above information been mentioned in the patch description?

Let me send v2.

>  
> > +static ssize_t health_attr_show(struct device *dev,
> > +				struct health_attr *attr, char *buf)
> > +{
> > +	struct ufs_hba *hba = dev_get_drvdata(dev);
> > +	int buff_len = hba->desc_size.health_desc;
> > +	u8 desc_buf[hba->desc_size.health_desc];
> 
> Is desc_buf[] a variable-length array? If so, how big can
> hba->desc_size.health_desc be? Can that number have a negative value?

IIUC, it is given by UFS which must be valid. Otherwise, it should be
QUERY_DESC_HEALTH_DEF_SIZE which is valid again. This is similarly being
done in other sysfs entries here.

> 
> > +	return scnprintf(buf, PAGE_SIZE, "0x%02x", desc_buf[attr->bytes]);
> 
> Please check whether attr->bytes falls inside the bounds of the desc_buf[] array
> before using that value as an index.

Okay.

> 
> > +#define HEALTH_ATTR_RO(_name, _bytes)					\
> > +static struct health_attr ufs_health_##_name = {			\
> > +	.attr = {.name = __stringify(_name), .mode = 0444},		\
> > +	.show = health_attr_show,					\
> > +	.bytes = _bytes,						\
> > +}
> > +
> > +HEALTH_ATTR_RO(length, 0);
> > +HEALTH_ATTR_RO(type, 1);
> > +HEALTH_ATTR_RO(eol, 2);
> > +HEALTH_ATTR_RO(lifetimeA, 3);
> > +HEALTH_ATTR_RO(lifetimeB, 4);
> 
> The above makes clear that the value stored in the structure member with the name
> "bytes" represents an array index. Please choose a better name for that structure
> member.

Changed to byte_offset.

> Additionally, since this patch introduces new sysfs attributes, why doesn't it
> add any documentation under Documentation/ABI/?

Added.

Thanks,

> 
> Thanks,
> 
> Bart.
