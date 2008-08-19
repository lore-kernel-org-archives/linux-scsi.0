From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Tue, 19 Aug 2008 15:16:32 +0200
Message-ID: <48AAC7B0.9060107@s5r6.in-berlin.de>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com> <48AAAFAC.9050502@s5r6.in-berlin.de> <20080819122738.GC21854@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60414 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYHSNRv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2008 09:17:51 -0400
In-Reply-To: <20080819122738.GC21854@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gwendal Grignou <gwendal@google.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> I think a more important question is ... this is coming from a Google
> address, but has a Copyright Dell on it.  Where's the sign-off chain for
> this?  Who's the author really?

Indeed, this needs to be clarified.

>> Gwendal Grignou wrote:
>>> +#define SETUP_TEMPLATE(attrb, field, perm, test)			\
>>> +	i->private_##attrb[count] = dev_attr_##field;		       	\
>>> +	i->private_##attrb[count].attr.mode = perm;			\
>>> +	i->attrb[count] = &i->private_##attrb[count];			\
>>> +	if (test)							\
>>> +		count++
...
>>> +#define SETUP_PORT_ATTRIBUTE(field)					\
>>> +	SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
...
>>> +	count = 0;
>>> +	SETUP_PORT_ATTRIBUTE(nr_pmp_links);
>>> +	SETUP_PORT_ATTRIBUTE(idle_irq);
>>> +	BUG_ON(count > ATA_PORT_ATTRS);
>>> +	i->port_attrs[count] = NULL;

I understand that such preprocessor games are hard to avoid in code like
sysfs attribute setup.  I have nothing better to suggest, but they are
ugly nevertheless, and may amount to bloat.

Anyway; the BUG_ON there should probably be a BUILD_BUG_ON.
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/
