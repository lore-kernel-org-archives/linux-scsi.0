From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 15:47:58 +0200
Message-ID: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
References: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4689 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYGINue (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 09:50:34 -0400
In-Reply-To: <20080709044743.0dd15a3f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Howells <dhowells@redhat.com>

In article <xs4all.20080709044743.0dd15a3f.akpm@linux-foundation.org> you write:
>On Wed, 09 Jul 2008 12:35:47 +0100 David Howells <dhowells@redhat.com> wrote:
>
>> Mark i2o config broken on 64-bit platforms as it generates these:
>> 
>> In file included from drivers/message/i2o/config-osm.c:39:
>> drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
>> drivers/message/i2o/i2o_config.c:889: warning: cast to pointer from
>integer of different size
>> drivers/message/i2o/i2o_config.c:945: warning: cast to pointer from
>integer of different size
>> 
>> which are apparently non-trivial to fix (eg: inserting a cast through unsigned
>> long is not correct according to Linus).  This would be due to struct
>> sg_simple_element only having a 32-bit addr_bus value.
>> 
>Sigh.  I've been staring at that warning for so long.
>Is it actually known to be broken on 64-bit, or does it happen to work?

The i2o driver works on 64 bit, though my experiences are less
than stellar (which is why I submitted the dpt_i2o 64 bit update
for 2.6.26).

However this warning doesn't have much to do with the functioning
of the driver. It is the Adaptec DPT API for the management interface,
and that API is currently 32 bits. The i2o layer and the dpt_i2o driver
have have the same issues here.

The adaptec management application ("raidutils") is also not 64-bit clean
(read the code .. it puts pointers into ints etc etc), and fixing
that is not trivial, _but_ the 32 bit version works on a 64 bit kernel.

Marking the whole i2o layer broken because the adaptec management API
hasn't been updated to 64 bits (but does work in 32 bit compatibility
mode) is going a bit to far I think.

First, if you want to mark something broken, it would be
CONFIG_I2O_EXT_ADAPTEC .. second, compiling it gives warnings,
but it works, and I bet people are using it.

Mike.
