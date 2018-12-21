From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Clang build error in drivers/scsi/smartpqi/smartpqi_init.c
Date: Fri, 21 Dec 2018 00:11:00 -0700
Message-ID: <20181221071100.GA20515@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

After commit 4fd22c13ad44 ("scsi: smartpqi: add ofa support"), an arm
allyesconfig build with Clang fails with the following warning/error:

drivers/scsi/smartpqi/smartpqi_init.c:7473:2: warning: comparison of distinct pointer types ('typeof ((sg_count)) *' (aka 'unsigned int *') and 'uint64_t *' (aka 'unsigned long long *')) [-Wcompare-distinct-pointer-types]
        do_div(sg_count, chunk_size);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/div64.h:222:28: note: expanded from macro 'do_div'
        (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
               ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
drivers/scsi/smartpqi/smartpqi_init.c:7473:2: error: incompatible pointer types passing 'u32 *' (aka 'unsigned int *') to parameter of type 'uint64_t *' (aka 'unsigned long long *') [-Werror,-Wincompatible-pointer-types]
        do_div(sg_count, chunk_size);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/div64.h:239:22: note: expanded from macro 'do_div'
                __rem = __div64_32(&(n), __base);       \
                                   ^~~~
./arch/arm/include/asm/div64.h:33:45: note: passing argument to parameter 'n' here
static inline uint32_t __div64_32(uint64_t *n, uint32_t base)
                                            ^
drivers/scsi/smartpqi/smartpqi_init.c:7473:2: warning: shift count >= width of type [-Wshift-count-overflow]
        do_div(sg_count, chunk_size);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/div64.h:235:25: note: expanded from macro 'do_div'
        } else if (likely(((n) >> 32) == 0)) {          \
                               ^  ~~
./include/linux/compiler.h:76:40: note: expanded from macro 'likely'
# define likely(x)      __builtin_expect(!!(x), 1)
                                            ^

According to include/asm-generic/div64.h, the first parameter of do_div
must be a 64-bit number, meaning the below diff would properly fix it.

However, I am not sure if there are any unintended consequences of this
change, hence reaching out before sending it in. If you have a more
preferred way of fixing it, please do so.

Thank you,
Nathan

==========================================================================================

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e57fbff08f03..6a185a6172c4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7460,7 +7460,7 @@ static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
 static int pqi_ofa_alloc_mem(struct pqi_ctrl_info *ctrl_info,
        u32 total_size, u32 chunk_size)
 {
-       u32 sg_count;
+       u64 sg_count;
        u32 size;
        int i;
        struct pqi_sg_descriptor *mem_descriptor = NULL;
