From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Fri, 13 Dec 2013 15:58:48 -0800
Message-ID: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas,

This patchset uses krefs to refcount structures shared across threads.
LIO is full of these because configfs-based configuration actions can
be removing an object, even while that object is being used by a SCSI
command.

Using kref to free the struct on whichever thread drops the last
reference allows us to avoid busy-waiting in configfs removal functions.
Next, this set removes the statically-sized tpg lun and deve arrays in
favor of dynamically adding entries into rbtrees. This reduces memory
consumption and allows more than 255 luns per tpg and initiator mapping.

Except for some rbtree lookups, these changes are entirely in the
configuration paths of Lio. I have tested these as extensively as I can,
and it's ready for wider testing.

Note: patch 22 converts a percpu refcount to a normal kref. I'd argue
the benefit is really in the "refcount" part rather than the "percpu",
so a simpler kref does the job, but we might want to discuss this some
more.

Please review.

Thanks -- Regards -- Andy

p.s. https://github.com/agrover/linux.git for_nab
