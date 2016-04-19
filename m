From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 19 Apr 2016 08:56:00 -0500
Message-ID: <80200c53ae54f6cb34bd6fb51e9da65fdcc03004.1461073602.git.jpoimboe@redhat.com>
References: <20160419085221.GA29087@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160419085221.GA29087@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

objtool reports [1] the following warning:

  drivers/scsi/qla2xxx/qla_attr.o: warning: objtool: qla2x00_get_host_fabric_name() falls through to next function qla2x00_get_starget_port_name()

This warning is due to a gcc bug [2] which causes corrupt code:

  0000000000002f53 <qla2x00_get_host_fabric_name>:
      2f53:       55                      push   %rbp
      2f54:       48 89 e5                mov    %rsp,%rbp

  0000000000002f57 <qla2x00_get_fc_host_stats>:
      2f57:       55                      push   %rbp
      2f58:       b9 e8 00 00 00          mov    $0xe8,%ecx
      2f5d:       48 89 e5                mov    %rsp,%rbp
  ...

Note that qla2x00_get_host_fabric_name() is inexplicably truncated after
setting up the frame pointer.  It falls through to the next function,
which is very bad.

It occurs with the combination of the following two recent commits:

  bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
  ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")

The call chain which appears to trigger the problem is:

  qla2x00_get_host_fabric_name()
    wwn_to_u64()
      get_unaligned_be64()
        be64_to_cpup()
          __be64_to_cpup()

The bug requires very specific conditions to trigger.  According to Martin
Jambor (from the gcc bugzilla):

  "This bug can occur when an inlineable function containing a call to
  __builtin_constant_p, which checks a parameter or a value it
  references and a (possibly indirect) caller of the function actually
  passes a constant, but stores it using a type of a different size."

There's no reliable way to avoid (or even detect) the bug.  Until it
gets fixed in released versions of gcc, the least intrusive workaround
for this particular issue is to force the wwn conversion functions to be
inlined.

[1] https://lists.01.org/pipermail/kbuild-all/2016-April/019579.html
[2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 include/scsi/scsi_transport_fc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index bf66ea6..1919cd4 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -796,12 +796,12 @@ fc_remote_port_chkready(struct fc_rport *rport)
 	return result;
 }
 
-static inline u64 wwn_to_u64(u8 *wwn)
+static __always_inline u64 wwn_to_u64(u8 *wwn)
 {
 	return get_unaligned_be64(wwn);
 }
 
-static inline void u64_to_wwn(u64 inm, u8 *wwn)
+static __always_inline void u64_to_wwn(u64 inm, u8 *wwn)
 {
 	put_unaligned_be64(inm, wwn);
 }
-- 
2.4.11
