From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] Copy offload
Date: Mon, 09 Jan 2012 11:27:30 +0100
Message-ID: <4F0AC112.2000709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quite a lot of discussion has come up recently on supporting Copy
Offload (aka SCSI XCOPY) with linux.

During the course of this several topics were found which need some
discussion:

- Interface: do we need a new syscall? Should we try to resurrect
  the original sys_copyfile() approach from Joel Becker?
  What are the areas and use-cases this syscall should cover?

- Scope: SCSI XCOPY is not the only possible user here, CIFS and
  NFSv4 have similar needs. We should aim for integrating all of
  these use-cases. However, we need to revisit them to figure out
  if and to what extend they are really compatible.

- Implementation: The new interface is likely to reside on the
  filesystem level. To quote Dave Chinner:
  > e.g. for an array offload, we have to flush the source file
  > page cache first so that the data being copied is known to
  > be on disk, then invalidate the destination page cache if
  > overwriting or extend and pre-allocate blocks if not. Then
  > we have to map both files and hand that off to the array.
  >
  > Then there's a whole bunch of tricky questions about what
  > the state of the destination file should look like while
  > the copy is in progress, whether the source file should be
  > allowed to change (e.g. it can't be truncated and have
  > blocks freed and then reused by other files half way through
  > the copy offload operation), and so on.

- Backends: Should we concentrate on the new 'XCOPY LITE' proposal
  or should we try to implement the original XCOPY command, too?

I guess this'll warrant a joint session, as at least filesystem and
storage people will be involved here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
