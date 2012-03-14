From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: [PATCH 3/4] libfcoe: Add fcoe_sysfs
Date: Wed, 14 Mar 2012 01:19:44 +0000
Message-ID: <4F5FF22F.2030105@intel.com>
References: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
 <20120312230931.10580.58845.stgit@localhost6.localdomain6>
 <20120313050013.GB15426@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21617 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759896Ab2CNBTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 21:19:47 -0400
In-Reply-To: <20120313050013.GB15426@kroah.com>
Content-Language: en-US
Content-ID: <32C103113177644D822921ACD1DEB1CD@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.smart@emulex.com" <james.smart@emulex.com>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>

On 03/12/2012 10:00 PM, Greg KH wrote:
> On Mon, Mar 12, 2012 at 04:09:31PM -0700, Robert Love wrote:
>> +static void fcoe_ctlr_attrs_release(struct device *dev)
>> +{
>> +	struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);
>> +
>> +	put_device(ctlr->dev.parent);
>> +	ctlr->dev.parent = NULL;
> You should never have to put a reference count on your parent, nor worry
> about setting this value to NULL.  Just assign the parent when you
> register the device, no need to increment it.

Cool, I'll make these changes.

>> +#define fcoe_ctlr_id(x)				\
>> +	((x)->id)
>> +#define fcoe_ctlr_work_q_name(x)		\
>> +	((x)->work_q_name)
> <snip>
>
> Ick, what are all of these for, please don't do that.
>

These are only interesting when you look at the macros used to create 
the show/store handlers for the attributes.

#define fcoe_ctlr_show_function(field, format_string, sz, cast) \
static ssize_t show_fcoe_ctlr_attrs_##field(struct device *dev, \
                                             struct device_attribute 
*attr, \
                                             char *buf)                  \
{                                                                       \
         struct fcoe_ctlr_attrs *ctlr = dev_to_ctlr(dev);                \
         if (ctlr->f->get_fcoe_ctlr_##field)                             \
                 ctlr->f->get_fcoe_ctlr_##field(ctlr);                   \
         return snprintf(buf, sz, format_string,                         \
                         cast fcoe_ctlr_##field(ctlr));                  \
}

It's the last functional line that matters. I might be able to change 
that to something like:

cast ctlr->field

I'm pretty sure that won't compile, but if it did, it would only work 
for the simple members of fcoe_ctlr_attrs. It gets a bit more 
complicated because I have an embedded structure in fcoe_ctlr_attrs:

struct fcoe_ctlr_attrs {
         u32                             id;
...
         struct fcoe_fc_els_lesb         lesb;
};

So, when I want to use the fcoe_ctlr_show_function to build the 'show 
handler' for this sysfs attribute I rely on the following:

#define fcoe_ctlr_link_fail(x)                  \
         ((x)->lesb.lesb_link_fail)

This allows my fcoe_ctlr_show_function macro to be generic and the fact 
that the lesb members are within a sub-structure is contained within the 
attribute's accessor macro.
I'm sure I could come up with a workaround, it would likely require me 
to have a separate fcoe_ctlr_show_function for the lesb attributes. I 
like that my fcoe_ctlr_show_function works for the simple 
fcoe_ctlr_attrs members as well as for the embedded lesb members.

My feeling is that when you looked at the code you just saw unnecessary 
accessors routines as their usage is not so obvious. I do not intend to 
be using these accessors anywhere else other than the withing the 
show/store building routines.

Given my explanation, do you still dislike these?

I could move them to the fcoe_sysfs.c so they're not in a header and 
therefore would look less like accessors that developers should use...

Thanks, //Rob

PS: I'll also address your documentation concern before I repost.