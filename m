From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: dpt_i2o driver
Date: Tue, 2 Sep 2003 15:00:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902150027.A7246@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA25690F@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:50953 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263714AbTIBOAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 10:00:46 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA25690F@OTCEXC01>; from mark_salyzyn@adaptec.com on Tue, Sep 02, 2003 at 09:51:01AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

> - Consider 2.2 history? We no longer build modules for these kernels,=
 but
>   I do get monthly requests for driver sources to work in such. Adapt=
ec's
>   policy is one version, plus one behind, so supporting these users i=
s a
>   violation of this policy. Pleasing everyone is so hard ... :-(

Ok.

> - I looked through the nits, looks ok except:
> 	- use_new_eh_code was initialized thus because some kernels would
> have
> 	  the (smp) lock, but not the (up) interrupts disabled; by
> initializing
> 	  after the fact one got consistent io_request_lock behavior. Will
> need
> 	  to instrument and test the current crop of kernels I build for to
> see
> 	  if this issue is no longer there.

-ENOCONTEXT.  Can you quote what this is the reply to?

> proc_dir is a 2.2 ism,
> will-be-gone.

yeah.  What I meant (IIRC) is that you should intialize it in the
struct defintion not at runtime.

> 	- Found some kernels that did not have CONFIG_HIGHIO, yet had
> highmem_io
> 	  functionality :-( Wanted 64 bit to function there ...

Hmm, what kernels?  Must be some vendor tree..

> 	- casting to u8 * follows rules of strict typechecking and
> documentation
> 	  of pointer's purpose. Will remove under this `protest' as the
> Linux
> 	  CodingStyle does frown upon excesses.

Not starting a flamewar here, but C explicitly allows to assign void *
to any pointer type.  By casting it you actually lose typechecking if
the return value changes and you don't catch it.

> 	- I remember the author of this code going through hoops to get
> 	  add_wait_queue to function in some of the kernels, she
> 	  got abused by a race condition that would only go away once it
> 	  was coded thus. I will need to revisit these bugs and make sure
> 	  they are no longer present in the current crop of kernels.

Sounds strange because that really is the opencoded variant of =FEhese.

> 	- pHba->host is not set during early stages of initialization,
> 	  had to place the if around the
> spin_unlock_irq(pHba->host->host_lock)
> 	  to allow the initialization check for the adapter. One could trust
> 	  the product Ids and move code around, I chose the easy way out.

eek, okay.

> 	- DPT_TARGET_BUSY is necessary to prevent the management
> applications
> 	  from modifying arrays that are in use. Without this, admittedly
> racy,
> 	  code, we are all doomed (!) Busy checking from the management
> 	  perspective shall always be racy, we count on the slowness of the
> 	  operations and the users and the fact that the person utilizing
> the
> 	  applications has some physical access knowledge of the system.
> 	  However, they make mistakes, and we would have far more serious
> 	  problems without this ioctl. OEM's would scream *murder* (as they
> 	  have in the past). I personally do not see an issue with this
> being
> 	  in the way of proper refcounting as it is passive. Looks like a
> case
> 	  of one release for kernels.org, and another for our customers :-(

Well, this simply won't work anymore soon in mainline and thus 2.6-base=
d
vendor trees.  What exactly are these apps checking for, please give
some more context on what it is used for.

> ?
>=20
> dpt_i2o predated the i2o_scsi driver, and as such contains some legac=
y.
> However, this driver is a pure scsi layer solution, no block device
> translation, utilizing a DPT special private scb command that can be =
issued
> to *any* target to simplify the driver (and the firmware) paths. In
> addition, the dpt card has the ability to assign SCSI Ids to logical
> devices, can only be extracted completely (bus, target and lun) from =
a DPT
> special private getparam page. 64 bit Scatter Gather is supported, by
> igniting an unused bit in the SCB command. Finally, need a management
> utility path to issue commands to the adapter.

Okay, sounds fair.

> I see no problem with incorporating these enhancements into i2o_scsi,=
 except
> for the resistance to management application ioctls though ...

Given that these extensions probably don't appear in other HBAs it's
probably not a that good idea.  Thanks for the explanation.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
