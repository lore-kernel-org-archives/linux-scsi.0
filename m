From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PREEMPT-RT] [PATCH v2] scsi/fcoe: convert to kworker
Date: Fri, 22 Apr 2016 12:39:39 -0400 (EDT)
Message-ID: <186981952.31194082.1461343179889.JavaMail.zimbra@redhat.com>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de> <1457710143-29182-2-git-send-email-bigeasy@linutronix.de> <20160311161704.GA5083@infradead.org> <56E2F30F.5030108@linutronix.de> <20160315081940.GB9136@infradead.org> <20160412151654.GB20685@linutronix.de> <571A42EF.7030900@linutronix.de> <1461340185.2415.28.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:34407 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbcDVQkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2016 12:40:22 -0400
In-Reply-To: <1461340185.2415.28.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Vasu Dev <vasu.dev@intel.com>, rt@linutronix.de, fcoe-devel@open-fcoe.org, Chad Dupuis <chad.dupuis@qlogic.com>

I have fcoe for testing.
I will pull this in next week and test it.

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "James Bottomley" <jejb@linux.vnet.ibm.com>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Christoph Hel=
lwig" <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@o=
racle.com>, "Vasu Dev" <vasu.dev@intel.com>, rt@linutronix.de, fcoe-dev=
el@open-fcoe.org, "Chad Dupuis" <chad.dupuis@qlogic.com>
Sent: Friday, April 22, 2016 11:49:45 AM
Subject: Re: [PREEMPT-RT] [PATCH v2] scsi/fcoe: convert to kworker

On Fri, 2016-04-22 at 17:27 +0200, Sebastian Andrzej Siewior wrote:
> On 04/12/2016 05:16 PM, Sebastian Andrzej Siewior wrote:
> > The driver creates its own per-CPU threads which are updated based
> > on
> > CPU hotplug events. It is also possible to use kworkers and remove
> > some
> > of the kthread infrastrucure.
> >=20
> > The code checked ->thread to decide if there is an active per-CPU
> > thread. By using the kworker infrastructure this is no longer
> > possible (or
> > required). The thread pointer is saved in `kthread' instead of
> > `thread' so
> > anything trying to use thread is caught by the compiler. Currently
> > only the
> > bnx2fc driver is using struct fcoe_percpu_s and the kthread member.
> >=20
> > After a CPU went offline, we may still enqueue items on the
> > "offline"
> > CPU. This isn't much of a problem. The work will be done on a
> > random
> > CPU. The allocated crc_eof_page page won't be cleaned up. It is
> > probably
> > expected that the CPU comes up at some point so it should not be a
> > problem. The crc_eof_page memory is released of course once the
> > module is
> > removed.
> >=20
> > This patch was only compile-tested due to -ENODEV.
> >=20
> > Cc: Vasu Dev <vasu.dev@intel.com>
> > Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: fcoe-devel@open-fcoe.org
> > Cc: linux-scsi@vger.kernel.org
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> > v1=E2=80=A6v2: use kworker instead of smbthread as per hch
> >=20
> > If you want this I would the same for the two bnx drivers.
>=20
> *ping*

Ping what?  You've sent in an untested patch that looks to be a big
change.  It's definitely not going in until it's tested.  Why don't you
see if you can recruit an FCoE person to your cause and get them to
test it.

It looks like you're looking for testing on bnx2fc, correct?  In which
case cc'ing a bnx2fc person might have been helpful (cc added).

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
