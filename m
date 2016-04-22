From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PREEMPT-RT] [PATCH v2] scsi/fcoe: convert to kworker
Date: Fri, 22 Apr 2016 17:27:43 +0200
Message-ID: <571A42EF.7030900@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
 <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
 <20160311161704.GA5083@infradead.org> <56E2F30F.5030108@linutronix.de>
 <20160315081940.GB9136@infradead.org> <20160412151654.GB20685@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:54374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbcDVP1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2016 11:27:52 -0400
In-Reply-To: <20160412151654.GB20685@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Vasu Dev <vasu.dev@intel.com>, rt@linutronix.de, fcoe-devel@open-fcoe.org

On 04/12/2016 05:16 PM, Sebastian Andrzej Siewior wrote:
> The driver creates its own per-CPU threads which are updated based on
> CPU hotplug events. It is also possible to use kworkers and remove so=
me
> of the kthread infrastrucure.
>=20
> The code checked ->thread to decide if there is an active per-CPU
> thread. By using the kworker infrastructure this is no longer possibl=
e (or
> required). The thread pointer is saved in `kthread' instead of `threa=
d' so
> anything trying to use thread is caught by the compiler. Currently on=
ly the
> bnx2fc driver is using struct fcoe_percpu_s and the kthread member.
>=20
> After a CPU went offline, we may still enqueue items on the "offline"
> CPU. This isn't much of a problem. The work will be done on a random
> CPU. The allocated crc_eof_page page won't be cleaned up. It is proba=
bly
> expected that the CPU comes up at some point so it should not be a
> problem. The crc_eof_page memory is released of course once the modul=
e is
> removed.
>=20
> This patch was only compile-tested due to -ENODEV.
>=20
> Cc: Vasu Dev <vasu.dev@intel.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: fcoe-devel@open-fcoe.org
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1=E2=80=A6v2: use kworker instead of smbthread as per hch
>=20
> If you want this I would the same for the two bnx drivers.

*ping*

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
