From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: transport_class: BUG if we can't release the attribute
	container
Date: Wed, 02 Apr 2008 09:15:53 -0500
Message-ID: <1207145753.3082.7.camel@localhost.localdomain>
References: <1206203957.4393.16.camel@localhost.localdomain>
	 <20080402063232.GD8158@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36688 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204AbYDBOP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 10:15:57 -0400
In-Reply-To: <20080402063232.GD8158@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-04-01 at 23:32 -0700, Greg KH wrote:
> On Sat, Mar 22, 2008 at 11:39:17AM -0500, James Bottomley wrote:
> > Every current transport class calls transport_container_release but
> > ignores the return value.  This is catastrophic if it returns an error
> > because the containers are part of a global list and the next action of
> > almost every transport class is to free the memory used by the
> > container.
> > 
> > Fix this by making transport_container_release a void, but making it BUG
> > if attribute_container_release returns an error ... this catches the
> > root cause of a system panic much earlier.  If we don't do this, we get
> > an eventual BUG when the attribute container list notices the corruption
> > caused by the freed memory it's still referencing.
> > 
> > Also made attribute_container_release __must_check as a reminder.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > ---
> > 
> > diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
> > index 40bca48..06861ae 100644
> > --- a/drivers/base/transport_class.c
> > +++ b/drivers/base/transport_class.c
> > @@ -108,7 +108,7 @@ EXPORT_SYMBOL_GPL(anon_transport_class_register);
> >   */
> >  void anon_transport_class_unregister(struct anon_transport_class *atc)
> >  {
> > -	attribute_container_unregister(&atc->container);
> > +	BUG_ON(attribute_container_unregister(&atc->container));
> 
> BUG_ON() should not do anything in the macro except test for a value, no
> function calling.  I think checkpatch.pl checks for this...

Well, we can agree to differ on this.  The camp that wants no side
effects for BUG_ON() does so in case they want to define it to be a nop.
I've always argued that having special rules for this that differ from
functions is asking for trouble.  It's also easy to preserve the side
effects by making the compile out do this:

#define BUG_ON(x) (void)(x)

That lets the compiler process the side effects and discard the result.
This basically means the rules for BUG_ON() arguments are identical to
the rules for function arguments ... I think that's consonant with the
principle of least surprise.

Checkpatch also can't pick this up because it doesn't know which
statements have side effects and which don't without adding a whole lot
more logic to it.

> If you change that, I have no problem with this.

OK ... your subsystem tree your call, I suppose.  How about the
attached.

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
--- linux-2.6.orig/drivers/base/transport_class.c	2008-03-03 16:50:00.000000000 -0600
+++ linux-2.6/drivers/base/transport_class.c	2008-04-02 09:13:01.000000000 -0500
@@ -108,7 +108,7 @@ EXPORT_SYMBOL_GPL(anon_transport_class_r
  */
 void anon_transport_class_unregister(struct anon_transport_class *atc)
 {
-	attribute_container_unregister(&atc->container);
+	BUG_ON(attribute_container_unregister(&atc->container));
 }
 EXPORT_SYMBOL_GPL(anon_transport_class_unregister);
 
Index: linux-2.6/drivers/scsi/raid_class.c
===================================================================
--- linux-2.6.orig/drivers/scsi/raid_class.c	2007-07-05 13:01:17.000000000 -0500
+++ linux-2.6/drivers/scsi/raid_class.c	2008-04-02 09:13:01.000000000 -0500
@@ -289,7 +289,7 @@ raid_class_release(struct raid_template 
 {
 	struct raid_internal *i = to_raid_internal(r);
 
-	attribute_container_unregister(&i->r.raid_attrs.ac);
+	BUG_ON(attribute_container_unregister(&i->r.raid_attrs.ac));
 
 	kfree(i);
 }
Index: linux-2.6/include/linux/attribute_container.h
===================================================================
--- linux-2.6.orig/include/linux/attribute_container.h	2008-01-25 19:44:09.000000000 -0600
+++ linux-2.6/include/linux/attribute_container.h	2008-04-02 09:13:01.000000000 -0500
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
--- linux-2.6.orig/include/linux/transport_class.h	2006-02-15 13:47:11.000000000 -0600
+++ linux-2.6/include/linux/transport_class.h	2008-04-02 09:13:58.000000000 -0500
@@ -86,9 +86,10 @@ static inline int transport_container_re
 	return attribute_container_register(&tc->ac);
 }
 
-static inline int transport_container_unregister(struct transport_container *tc)
+static inline void transport_container_unregister(struct transport_container *tc)
 {
-	return attribute_container_unregister(&tc->ac);
+	int err = attribute_container_unregister(&tc->ac);
+	BUG_ON(err);
 }
 
 int transport_class_register(struct transport_class *);


