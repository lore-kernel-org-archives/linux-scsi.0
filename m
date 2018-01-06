From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/18] prevent bounds-check bypass via speculative execution
Date: Fri, 05 Jan 2018 17:09:53 -0800
Message-ID: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, peterz@infradead.org, Alan Cox <alan.cox@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Zhang Rui <rui.zhang@intel.com>, linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>, Eduardo Valentin <edubezval@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Quoting Mark's original RFC:

"Recently, Google Project Zero discovered several classes of attack
against speculative execution. One of these, known as variant-1, allows
explicit bounds checks to be bypassed under speculation, providing an
arbitrary read gadget. Further details can be found on the GPZ blog [1]
and the Documentation patch in this series."

This series incorporates Mark Rutland's latest api and adds the x86
specific implementation of nospec_barrier. The
nospec_{array_ptr,ptr,barrier} helpers are then combined with a kernel
wide analysis performed by Elena Reshetova to address static analysis
reports where speculative execution on a userspace controlled value
could bypass a bounds check. The patches address a precondition for the
attack discussed in the Spectre paper [2].

A consideration worth noting for reviewing these patches is to weigh the
dramatic cost of being wrong about whether a given report is exploitable
vs the overhead nospec_{array_ptr,ptr} may introduce. In other words,
lets make the bar for applying these patches be "can you prove that the
bounds check bypass is *not* exploitable". Consider that the Spectre
paper reports one example of a speculation window being ~180 cycles.

Note that there is also a proposal from Linus, array_access [3], that
attempts to quash speculative execution past a bounds check without
introducing an lfence instruction. That may be a future optimization
possibility that is compatible with this api, but it would appear to
need guarantees from the compiler that it is not clear the kernel can
rely on at this point. It is also not clear that it would be a
significant performance win vs lfence.

These patches also will also be available via the 'nospec' git branch
here:

    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux nospec

[1]: https://googleprojectzero.blogspot.co.uk/2018/01/reading-privileged-memory-with-side.html
[2]: https://spectreattack.com/spectre.pdf
[3]: https://marc.info/?l=linux-kernel&m=151510446027625&w=2

---

Andi Kleen (1):
      x86, barrier: stop speculation for failed access_ok

Dan Williams (13):
      x86: implement nospec_barrier()
      [media] uvcvideo: prevent bounds-check bypass via speculative execution
      carl9170: prevent bounds-check bypass via speculative execution
      p54: prevent bounds-check bypass via speculative execution
      qla2xxx: prevent bounds-check bypass via speculative execution
      cw1200: prevent bounds-check bypass via speculative execution
      Thermal/int340x: prevent bounds-check bypass via speculative execution
      ipv6: prevent bounds-check bypass via speculative execution
      ipv4: prevent bounds-check bypass via speculative execution
      vfs, fdtable: prevent bounds-check bypass via speculative execution
      net: mpls: prevent bounds-check bypass via speculative execution
      udf: prevent bounds-check bypass via speculative execution
      userns: prevent bounds-check bypass via speculative execution

Mark Rutland (4):
      asm-generic/barrier: add generic nospec helpers
      Documentation: document nospec helpers
      arm64: implement nospec_ptr()
      arm: implement nospec_ptr()

 Documentation/speculation.txt                      |  166 ++++++++++++++++++++
 arch/arm/include/asm/barrier.h                     |   75 +++++++++
 arch/arm64/include/asm/barrier.h                   |   55 +++++++
 arch/x86/include/asm/barrier.h                     |    6 +
 arch/x86/include/asm/uaccess.h                     |   17 ++
 drivers/media/usb/uvc/uvc_v4l2.c                   |    7 +
 drivers/net/wireless/ath/carl9170/main.c           |    6 -
 drivers/net/wireless/intersil/p54/main.c           |    8 +
 drivers/net/wireless/st/cw1200/sta.c               |   10 +
 drivers/net/wireless/st/cw1200/wsm.h               |    4 
 drivers/scsi/qla2xxx/qla_mr.c                      |   15 +-
 .../thermal/int340x_thermal/int340x_thermal_zone.c |   14 +-
 fs/udf/misc.c                                      |   39 +++--
 include/asm-generic/barrier.h                      |   68 ++++++++
 include/linux/fdtable.h                            |    5 -
 kernel/user_namespace.c                            |   10 -
 net/ipv4/raw.c                                     |    9 +
 net/ipv6/raw.c                                     |    9 +
 net/mpls/af_mpls.c                                 |   12 +
 19 files changed, 466 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/speculation.txt
