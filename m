From: Hannes Reinecke <hare@suse.de>
Subject: Merging se_dev_entry and se_lun?
Date: Fri, 19 Jun 2015 08:40:23 +0200
Message-ID: <5583B957.20200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

having done the patch to export 'write_protect' for demo-mode LUNs
I've came across one puzzling item:

struct se_lun uses a list to refer to the underlying se_dev_entry
structures. Which I found rather curious, as from my understanding
'se_lun' is the structure for the mapped LUN (ie the LUN visible to
the initiator) and 'se_dev_entry' is the underlying physical device
as visible to the LUN.
As such I would have expected a 1:1 relationship between both, ie a
simple pointer from se_lun to se_dev_entry.

Having a list here implies that 'se_lun' can have _several_
se_dev_entry structure attached to it, which I found rather curious.

Can you give me an example where this might be the case?
Or can we replace the list with a simple pointer or even merge both?

Reason I'm asking is the lun_access / dev_flags field; it really
looks like it being a duplicate (I would judge 'write_protect' to be
a property of the mapped LUN, and not of the underlying device),
but in either case having it in both places requires a
synchronisation between both, as for demo-mode LUNs we can only
change it via se_lun, and for others we have to change it via the
se_dev_entry.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
