From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.6.0-test4-mm5: SCSI imm driver doesn't compile
Date: Wed, 3 Sep 2003 19:02:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030903170256.GA18025@fs.tum.de>
References: <20030902231812.03fae13f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030902231812.03fae13f.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>, Arnaldo Carvalho de Melo <acme@conectiva.com.br>
Cc: linux-kernel@vger.kernel.org, campbell@torque.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following compile error (tested with gcc 2.95) seems to come from 
Linus' tree:

<--  snip  -->

...
  CC [M]  drivers/scsi/imm.o
In file included from drivers/scsi/imm.c:55:
drivers/scsi/imm.h:105: duplicate array index in initializer
drivers/scsi/imm.h:105: (near initialization for `IMM_MODE_STRING')
make[2]: *** [drivers/scsi/imm.o] Error 1

<--  snip  -->

The problem is the following code in imm.h (with 
CONFIG_SCSI_IZIP_EPP16 enabled):

<--  snip  -->

...
static char *IMM_MODE_STRING[] =
{
        [IMM_AUTODETECT] = "Autodetect",
        [IMM_NIBBLE]     = "SPP",
        [IMM_PS2]        = "PS/2",
        [IMM_EPP_8]      = "EPP 8 bit",
        [IMM_EPP_16]     = "EPP 16 bit",
#ifdef CONFIG_SCSI_IZIP_EPP16
        [IMM_EPP_16]     = "EPP 16 bit",
#else
        [IMM_EPP_32]     = "EPP 32 bit",
#endif
        [IMM_UNKNOWN]    = "Unknown",
};
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
