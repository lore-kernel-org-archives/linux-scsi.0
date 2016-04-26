From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 26 Apr 2016 12:05:01 +0200
Message-ID: <7383310.fFF78fn4MN@wuerfel>
References: <20160419085221.GA29087@gmail.com> <5249561.9VpAPLD61M@wuerfel> <20160426083516.GC364@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160426083516.GC364@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Tuesday 26 April 2016 01:35:16 Christoph Hellwig wrote:
> On Tue, Apr 26, 2016 at 09:22:46AM +0200, Arnd Bergmann wrote:
> > > Agree, plus, as I've said before, we have 3-4 weeks before we go final,
> > > so we still have some time before a decision has to be made.  It looks
> > > like the gcc people already have a patch for the compiler, so the
> > > distributions could just push that out through channels.
> > 
> > I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
> > gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to compilers
> > that have not been released yet in order to build a linux-4.6 kernel.
> 
> Agreed.  What about just removing the wrappers?  They seem fairly
> pointless to start with.

I think at this point it's mainly a question of whether we want such a
big (however trivial) patch in v4.6. We can certainly do that for 4.7,
but as a fixup for the existing problem, either the __always_inline
hack or using a macro should be sufficient:

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index bf66ea6bed2b..51a98b182a67 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -796,15 +796,8 @@ fc_remote_port_chkready(struct fc_rport *rport)
 	return result;
 }
 
-static inline u64 wwn_to_u64(u8 *wwn)
-{
-	return get_unaligned_be64(wwn);
-}
-
-static inline void u64_to_wwn(u64 inm, u8 *wwn)
-{
-	put_unaligned_be64(inm, wwn);
-}
+#define wwn_to_u64(wwn) get_unaligned_be64(wwn)
+#define u64_to_wwn(inm, wwn) put_unaligned_be64(inm, wwn)
 
 /**
  * fc_vport_set_state() - called to set a vport's state. Saves the old state,

	Arnd
