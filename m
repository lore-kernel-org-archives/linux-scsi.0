From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: randconfig build error with next-20140110, in
 drivers/target/target_core_sbc.c
Date: Fri, 10 Jan 2014 11:37:45 -0800
Message-ID: <1389382665.5567.418.camel@haakon3.risingtidesystems.com>
References: <CA+r1ZhiKhGJrki8X_bcKC3LrALRHj61uFpAmiGRfePO0g9tU4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CA+r1ZhiKhGJrki8X_bcKC3LrALRHj61uFpAmiGRfePO0g9tU4w@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jim,

On Fri, 2014-01-10 at 06:57 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `sbc_dif_v1_verify':
> /home/jim/linux/drivers/target/target_core_sbc.c:1019: undefined
> reference to `crc_t10dif'
> make: *** [vmlinux] Error 1

Applying the following patch to address this build failure.

Thanks for the heads up!

--nab

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 1830368..50aad2e 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -3,6 +3,7 @@ menuconfig TARGET_CORE
        tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
        depends on SCSI && BLOCK
        select CONFIGFS_FS
+       select CRC_T10DIF
        default n
        help
        Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled
