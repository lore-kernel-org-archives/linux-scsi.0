From: Jamie Lenehan <lenehan@twibble.org>
Subject: ANNOUNCE: dc395x update [2.04]
Date: Mon, 19 May 2003 19:31:23 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030519093123.GA22084@twibble.org>
References: <20030423072737.GA5529@twibble.org> <20030513090535.GA5528@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:983 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S261798AbTESJS3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 05:18:29 -0400
Content-Disposition: inline
In-Reply-To: <20030513090535.GA5528@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org

Hi, a new version against 2.5.69-bk13 is now up at:

   http://twibble.org/dist/dc395x/

Both as seperate patches and as one large patch.
Changes in this version since 2.03:

 - 07-remove-cmd-queue.patch

   Removes queueing of commands which cannot be processed immediately
   due to a lack of scsi request blocks. The mid layer will take care
   of this queuing.


 - 08-remove-unused-vars.patch

   Remove variables which are not used so that it's easier to see
   which variables are actually used.
   

 - 09-names-functions.patch

   Removes the dc395x_ prefix from functions, lower cases all the
   function names and renames a few function to make it a bit clearer
   what they actually do.


 - 10-names-variables.patch

   Removes the p prefix from pointer variables, lower cases the
   variable names and removes the dc395x prefix from variables.


 - 11-struct-vars.patch

   Removes the use of structure name within structures. ie in an srb
   the variables srb_x were changed to just be x (if x is in the srb
   then surely it refers to something to do with the srb!)


 - 12-null-use.patch

   Remove casts to NULL and use NULL instead of 0 in places where
   pointers were being assigned zero.


 - 13-irq-fix-01.patch

   The old code used to go to a lot of effort to only register a
   single interrupt handler if there were multiple cards in the system
   on the same IRQ. I changed this with the module changes to register
   one irq handler per device found. But it was only ever
   unregistering the first irq handler dev_id. This is fixed here.

   I ripped out the remaining code in init_adapter which tries to find
   other adapters with the same id.

   Previously the driver would request_regio and then request_irq. If
   the request_irq failed it would exit, but wouldn't release the
   resources. This is fixed here.

   It's not possible now to register a driver instance without an
   IRQ. So I removed the check in driver shutdown for this situation.


 - 14-irq-fix-02.patch

   The existing interupt handler walks the static list of installed
   adapters to find one with a matching IRQ and with interupts
   pending.

   I ripped that out and made it just use the dev_id (which is the acb
   pointer) to directly check that specified adapter. This does have
   the disadvantage that the irq handler will need to be recalled for
   the other device to process it's irq requests. But I think the
   simplification is worth it.


 - 15-inline.patch

   There's a mixture of __inline__ and inline used. I've replaced the
   __inline__'s with just inline.


 - 16-version-2.04.patch

   Update version number/date.

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
