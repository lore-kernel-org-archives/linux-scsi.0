From: Stephen Hemminger <shemminger@osdl.org>
Subject: Megaraid driver on 2.5.45 problem with large devices enabled.
Date: 31 Oct 2002 15:39:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1036107574.3365.36.camel@dell_ss3.pdx.osdl.net>
References: <20BF5713E14D5B48AA289F72BD372D68C1EAAC@AUSXMPC122.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20BF5713E14D5B48AA289F72BD372D68C1EAAC@AUSXMPC122.aus.amer.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt_Domsch@Dell.com
Cc: linux-megaraid-devel@Dell.com, linux-scsi@vger.kernel.org

When the config option CONFIG_LBD is enabled, sector_t becomes a 64 bit
type.  This breaks the megaraid driver because it does:

static int
mega_partsize(struct block_device *bdev, sector_t capacity, int *geom)
...

		cyls = capacity/(heads * sectors);

which causes gcc to call the helper function which the kernel doesn't
pull in.  Probably this can be fixed by casting (if device can't support
huge disks) or changing the math.

drivers/built-in.o: In function `mega_partsize':
drivers/built-in.o(.text+0x6cb22): undefined reference to `__udivdi3'

