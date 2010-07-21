From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: CONFIG_SCSI_G_NCR5380_MEM dead?
Date: Wed, 21 Jul 2010 15:01:14 +0200
Message-ID: <86pqyhhtut.fsf@peer.zerties.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

Hi all!
      =20
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the drivers/scsi sourcetree for
config Items not defined in Kconfig and found such a case. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

I encountered, that the CONFIG_SCSI_G_NCR5380_MEM symbol in
drivers/scsi/g_NCR5380.c isn't defined anywhere. So this codeblocks
seems to be unreachable. But there is a define in g_NCR5380_mmio.c for
SCSI_G_NCR5380_MEM with an include of g_NCR5380.c. So i think this is a
typo-bug and it should be a CONFIG_ define. The code wasn't changed sin=
ce
linux is in git, so probably no one has used the mmio module, cause
there can't be a difference to the normal pio module. If you think this
ifdefs should be removed, i can send a patch.

Regards

        Christian Dietrich
--=20
(=CE=BB x . x x) (=CE=BB x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
