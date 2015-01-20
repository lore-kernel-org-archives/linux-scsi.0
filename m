From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/11] scsi: fix module reference mismatch for scsi host
Date: Tue, 20 Jan 2015 23:57:37 +0900
Message-ID: <CAC5umyh+x_B3GOc4q=Q+2NsAK8KmaHvpyW329iG-d1yAUwN02A@mail.gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
	<20150119142206.GE8140@htj.dyndns.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCPM5SUWUYIRBYWZ7GSQKGQE3UHXGZA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20150119142206.GE8140-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

2015-01-19 23:22 GMT+09:00 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Mon, Jan 19, 2015 at 12:05:58AM +0900, Akinobu Mita wrote:
>> While accessing a scsi_device, the use count of the underlying LLDD
>> module is incremented.  The module reference is retrieved through
>> .module field of struct scsi_host_template.
>>
>> This mapping between scsi_device and underlying LLDD module works well
>> except some drivers which consist with the core driver and the actual
>> LLDDs and scsi_host_template is defined in the core driver.  In these
>> cases, the actual LLDDs can be unloaded even if the scsi_device is
>> being accessed.
>>
>> This patch series fixes the module reference mismatch problem for
>> ufs, usb-storage, esp_scsi, ahci_platform, and pata_platform drivers
>> by moving owner module reference field from struct scsi_host_template
>> to struct Scsi_Host and allowing the LLDDs to set their correct module
>> reference.
>
> Hmmm, can't we just move sht definitions to actual LLDDs?  libata can
> do that easily.  sht, as its name implies, is the template for
> creating the scsi_hosts of a given type.  We're now just moving module
> ownership from sht definition site to whatever callsite the actual
> instance is being created which can also be wrapped in a separate
> layer requiring explicit propagation.  Why not just propagate sht's
> directly?  What's the difference?

The reason I didn't move sht from the core driver to the LLDDs for
fixing ufs and ums-* in the first place is to avoid exporting many
symbols for callbacks in sht.  But I realized that we can do it
without that many exported symbols by creating a single function that
returns a kmemdup()ed sht with a few change including ->module.

So there are three options we can take for fixing this problem.
I would like to know the opinions which one should be taken.

(1) Add owner module field to Scsi_Host for allowing LLDDs to adjust
it after scsi host allocation.  This approach is used by v1,2,3 of
this patch series and the scsi midlayer change is minimum.

(2) Move owner module field from scsi_host_template to Scsi_Host.
The owner module reference is retrieved from the callsite of
scsi_host_alloc() by passing THIS_MODULE to the extra argument.
The scsi midlayer change is small, but we need the same macro trick
for each scsi_host_alloc() wrapper and these changes are relatively
large (required by libata, libiscsi, libfc, cxgbi, 53c700, legacy).
This approach is used by v4 of this patch series.

(3) Allocate scsi host template for each module.  No scsi midlayer
change is required.  Instead of sharing a single scsi host template
defined in the core, create a single function that returns a
kmemdup()ed sht with a few change including ->module so that the sub
modules can use it as their sht.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
