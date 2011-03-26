From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: fix/amend device gone notification in sas_deform_port()
Date: Sat, 26 Mar 2011 15:27:30 -0700
Message-ID: <AANLkTi=K82f70L8h+jbLsNBC9Q1Bb3UpJDtjOtaXAG=B@mail.gmail.com>
References: <20110217030659.4303.12762.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1CZW1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Mar 2011 18:27:31 -0400
Received: by wya21 with SMTP id 21so1957505wya.19
        for <linux-scsi@vger.kernel.org>; Sat, 26 Mar 2011 15:27:30 -0700 (PDT)
In-Reply-To: <20110217030659.4303.12762.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: Haipao Fan <haipao.fan@intel.com>, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, Maciej Trela <maciej.trela@intel.com>, jeffrey.d.skirvin@intel.com, David Milburn <dmilburn@redhat.com>, edmund.nadolski@intel.com, "Darrick J. Wong" <djwong@us.ibm.com>, Jack Wang <jack_wang@usish.com>

On Wed, Feb 16, 2011 at 7:11 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> Commit 56dd2c06 "libsas: Don't issue commands to devices that have be=
en
> hot-removed" edited Darrick's original patch to remove setting 'gone'=
 in
> the sas_deform_port() path because that prevented scsi sync cache
> commands from being issued when the driver was unloaded. =A0However, =
this
> allows true device gone notifications (as signaled port phy events) t=
o
> trigger sync cache commands to devices that are known to be unreachab=
le.
>
> Teach libsas which sas_deform_port() invocations are likely device go=
ne
> events.
>
> This patch also introduces sas_device_gone() which hopefully allows
> subtle/tricky locking to be dropped from lldd drivers, like the
> following in mvsas which is broken if the ata path is ever converted =
to
> call lldd_execute_task() with irqs enabled:
>
> =A0 =A0 =A0 =A0flags_libsas =3D 0;
> =A0 =A0 =A0 =A0[...]
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags_l=
ibsas);
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
> =A0 =A0 =A0 =A0t->task_done(t);
> =A0 =A0 =A0 =A0spin_lock_irqsave(&mvi->lock, flags);
> =A0 =A0 =A0 =A0spin_lock_irqsave(dev->sata_dev.ap->lock, flags_libsas=
);
>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: Haipao Fan <haipao.fan@intel.com>
> Cc: Maciej Trela <maciej.trela@intel.com>
> Cc: David Milburn <dmilburn@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

James,

This was acked-by Jack Wang, and has been under test in the isci tree
for quite a while with no ill effects.  Please consider it for a post
39-rc1 fix or otherwise disposition it.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
