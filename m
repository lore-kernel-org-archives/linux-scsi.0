From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: transport_class: BUG if we can't release the attribute
	container
Date: Wed, 02 Apr 2008 10:05:48 -0500
Message-ID: <1207148748.3082.25.camel@localhost.localdomain>
References: <1206203957.4393.16.camel@localhost.localdomain>
	 <20080402063232.GD8158@kroah.com>
	 <1207145753.3082.7.camel@localhost.localdomain>
	 <20080402143040.GU16451@parisc-linux.org>
	 <1207146776.3082.9.camel@localhost.localdomain>
	 <20080402145355.GB29318@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55453 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbYDBPFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 11:05:52 -0400
In-Reply-To: <20080402145355.GB29318@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-04-02 at 07:53 -0700, Greg KH wrote:
> On Wed, Apr 02, 2008 at 09:32:55AM -0500, James Bottomley wrote:
> > On Wed, 2008-04-02 at 08:30 -0600, Matthew Wilcox wrote:
> > > On Wed, Apr 02, 2008 at 09:15:53AM -0500, James Bottomley wrote:
> > > > On Tue, 2008-04-01 at 23:32 -0700, Greg KH wrote:
> > > > > BUG_ON() should not do anything in the macro except test for a value, no
> > > > > function calling.  I think checkpatch.pl checks for this...
> > > > 
> > > > Well, we can agree to differ on this.  The camp that wants no side
> > > > effects for BUG_ON() does so in case they want to define it to be a nop.
> > > 
> > > That's one argument, but to me, the most important thing is that reading
> > > the content of BUG_ON is unnecessary for understanding the function.
> > > 
> > > > OK ... your subsystem tree your call, I suppose.  How about the
> > > > attached.
> > > 
> > > > -static inline int transport_container_unregister(struct transport_container *tc)
> > > > +static inline void transport_container_unregister(struct transport_container *tc)
> > > >  {
> > > > -	return attribute_container_unregister(&tc->ac);
> > > > +	int err = attribute_container_unregister(&tc->ac);
> > > > +	BUG_ON(err);
> > > >  }
> > > 
> > > What's wrong with:
> > > 
> > > 	if (attribute_container_unregister(&tc->ac))
> > > 		BUG();
> > 
> > You've lost the unlikely designation which is one of the main reasons
> > for using BUG_ON().  Most people who write in this form also forget it
> > leading to a heap of suboptimal jump prediction code in the kernel and
> > another reason not to encourage it.
> 
> Most people who think that they need "unlikely" are also usually wrong
> :)

In this case, I hope not ... it better be incredibly unlikely to trigger
a BUG otherwise our users are going to be a bit unhappy ...

> This is on a register/unregister path, nothing "fast" about it at all,
> so please don't be worrying about "unlikely" for stuff like this.

It's irrelevant in this case because unregister isn't any form of
critical path.  However, people copy code so by not putting the unlikely
in here, you make it more possible to find this type of thing in the
critical path where it would be manifestly incorrect because they
noticed this form of it in a header file.

> I prefer the form mentioned by Matthew above please.

OK, try this.  I also fixed the BUG_ON in drivers/base

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 22 Mar 2008 11:39:17 -0500
Subject: [SCSI] transport_class: BUG if we can't release the attribute container

Every current transport class calls transport_container_release but
ignores the return value.  This is catastrophic if it returns an error
because the containers are part of a global list and the next action of
almost every transport class is to free the memory used by the
container.

Fix this by making transport_container_release a void, but making it BUG
if attribute_container_release returns an error ... this catches the
root cause of a system panic much earlier.  If we don't do this, we get
an eventual BUG when the attribute container list notices the corruption
caused by the freed memory it's still referencing.

Also made attribute_container_release __must_check as a reminder.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/base/transport_class.c      |    2 +-
 drivers/scsi/raid_class.c           |    2 +-
 include/linux/attribute_container.h |    2 +-
 include/linux/transport_class.h     |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/transport_class.c
===================================================================
--- linux-2.6.orig/drivers/base/transport_class.c	2008-04-02 09:14:18.000000000 -0500
+++ linux-2.6/drivers/base/transport_class.c	2008-04-02 10:01:45.000000000 -0500
@@ -108,7 +108,8 @@ EXPORT_SYMBOL_GPL(anon_transport_class_r
  */
 void anon_transport_class_unregister(struct anon_transport_class *atc)
 {
-	attribute_container_unregister(&atc->container);
+	if (unlikely(attribute_container_unregister(&atc->container)))
+		BUG();
 }
 EXPORT_SYMBOL_GPL(anon_transport_class_unregister);
 
Index: linux-2.6/drivers/scsi/raid_class.c
===================================================================
--- linux-2.6.orig/drivers/scsi/raid_class.c	2008-04-02 09:14:18.000000000 -0500
+++ linux-2.6/drivers/scsi/raid_class.c	2008-04-02 10:01:14.000000000 -0500
@@ -289,7 +289,7 @@ raid_class_release(struct raid_template 
 {
 	struct raid_internal *i = to_raid_internal(r);
 
-	attribute_container_unregister(&i->r.raid_attrs.ac);
+	BUG_ON(attribute_container_unregister(&i->r.raid_attrs.ac));
 
 	kfree(i);
 }
Index: linux-2.6/include/linux/attribute_container.h
===================================================================
--- linux-2.6.orig/include/linux/attribute_container.h	2008-04-02 09:14:18.000000000 -0500
+++ linux-2.6/include/linux/attribute_container.h	2008-04-02 10:01:14.000000000 -0500
@@ -37,7 +37,7 @@ attribute_container_set_no_classdevs(str
 }
 
 int attribute_container_register(struct attribute_container *cont);
-int attribute_container_unregister(struct attribute_container *cont);
+int __must_check attribute_container_unregister(struct attribute_container *cont);
 void attribute_container_create_device(struct device *dev,
 				       int (*fn)(struct attribute_container *,
 						 struct device *,
Index: linux-2.6/include/linux/transport_class.h
===================================================================
--- linux-2.6.orig/include/linux/transport_class.h	2008-04-02 09:14:18.000000000 -0500
+++ linux-2.6/include/linux/transport_class.h	2008-04-02 10:02:45.000000000 -0500
@@ -86,9 +86,10 @@ static inline int transport_container_re
 	return attribute_container_register(&tc->ac);
 }
 
-static inline int transport_container_unregister(struct transport_container *tc)
+static inline void transport_container_unregister(struct transport_container *tc)
 {
-	return attribute_container_unregister(&tc->ac);
+	if (unlikely(attribute_container_unregister(&tc->ac)))
+		BUG();
 }
 
 int transport_class_register(struct transport_class *);



