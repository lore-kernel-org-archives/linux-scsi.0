From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 11:37:36 +0100
Message-ID: <47285AF0.1010900@s5r6.in-berlin.de>
References: <1193671019.3383.13.camel@localhost.localdomain>	<1193676852.2655.21.camel@lov.site>	<1193677071.3383.56.camel@localhost.localdomain>	<47261F50.3050901@s5r6.in-berlin.de>	<1193768743.3321.91.camel@localhost.localdomain>	<20071031035506.GH14910@kroah.com>	<20071031104103.13e07d8f@gondolin.boeblingen.de.ibm.com>	<47285063.1040508@s5r6.in-berlin.de> <20071031112039.0b067ce3@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54237 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXJaKhq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 06:37:46 -0400
In-Reply-To: <20071031112039.0b067ce3@gondolin.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Cornelia Huck wrote:
> On Wed, 31 Oct 2007 10:52:35 +0100,
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> 		if (!grp->is_visible ||
>> 		    grp->is_visible(kobj, *attr, i))
>> 			add or remove();
>>
> 
> Hm, I find that a bit harder to parse...

		if (grp->is_visible == NULL ||
		    grp->is_visible(kobj, *attr, i))
			add or remove();

However, how beautiful the implementation of static void remove_files()
and static int create_files() looks doesn't matter.  What's important is
that

 struct attribute_group {
 	const char		*name;
+	int			(*is_visible)(struct kobject *,
+					      struct attribute *, int);
 	struct attribute	**attrs;
 };

makes sense to users --- because this is the API.

[BTW, like most of the existing driver core APIs, there are kerneldoc
comments missing here.]

> mask_out() would also imply that the common use case is to have all
> attributes in the group created and that you need to take action to
> have an attribute not created.

Here you have a point.  But James has a point too when he says:
| We basically want to show capability by which file is present.

Anyway, /if/ the reverse logic is preferred, it shouldn't be called
"mask_out()" but rather "is_masked()" or "is_hidden()" or the like.
-- 
Stefan Richter
-=====-=-=== =-=- =====
http://arcgraph.de/sr/
