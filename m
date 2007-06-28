From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Wed, 27 Jun 2007 21:21:18 -0700 (PDT)
Message-ID: <419361.83440.qm@web31812.mail.mud.yahoo.com>
References: <200706271227.48725.swen@vnet.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:31496 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751949AbXF1EVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jun 2007 00:21:19 -0400
In-Reply-To: <200706271227.48725.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Swen Schillig <swen@vnet.ibm.com> wrote:
> I think Luben and Stefan suggested a good way to do that, ok apart from the be64 bits :-)

What is the objection to the use of be64_to_cpu()?

> So, just use the struct scsi_lun in its full extend, for the sysfs without a leading "0x",
> and forgetting about the scsilun_to_int conversion which isn't good for anything.

Yes, I agree with you.  This is simple, straightforward, intuitive and reasonable.

In fact, I'd do
  typedef __u8 lun_t[8];
and then define the macro
  #define LUN_TO_U64(_lun) ((unsigned long long) be64_to_cpu(*(__be64 *)(_lun)))
This way one could do stuff like:*
  printk(KERN_NOTICE "problem xyz with LUN:%016llx\n", LUN_TO_U64(sdev->LUN));
where
  struct scsi_dev {
      ...
      lun_t LUN;  /* Or if you prefer all lowercase. */
      ...
  };
And as can be seen in my SAS stack code:
  kobject_set_name(&lu->lu_obj, "%016llx", LUN_TO_U64(lu->LUN));

(I actually don't have LUN_TO_U64() but reuse the SAS_ADDR() macro
 which is identical.)

* It is in fact more correct to do, at the _transport_ layer:

  printk(... "problem xyz with %016llx:%016llx\n",
         sdev->target->tpid, sdev->LUN);

Here, it is explicitly shown that sdev (/dev/sdXYZ) is a child of
a target, having a tpid attribute, and the sdev has a property
of lun_t called LUN.

So, for example, for SAS, the message would print like this:

problem xyz with 5000a50000f13427:0000000000000000

which uniquely identifies the device and then the sysadmin
can go to the storage farm, find it and replace it if need be.

> Anyway, before anyone else is suggesting some other magic attribute extension to the LUN value, 
> why not leave it as it is and just have it serving this one purpose of being a unique number ?
> (yeah, yeah I know there's already some meaning behind the 4 levels)

Again, you're exactly right.  SCSI Core should NOT be interpreting the LUN.
It should just pass it around as an opaque token, as accomplished by the
lun_t type definition as shown above.

    Luben

