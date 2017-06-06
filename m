From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: next build: 113 warnings 0 failures (next/next-20170605)
Date: Tue, 6 Jun 2017 15:14:07 +0200
Message-ID: <CAK8P3a1D0r9XAfGN95EkiaXvCmkJq1Em=xggJw87yX7YH7o-vA@mail.gmail.com>
References: <59351e18.c490630a.4dca5.e785@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <59351e18.c490630a.4dca5.e785@mx.google.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Olof's autobuilder <build@lixom.net>
Cc: Olof Johansson <olof@lixom.net>, Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, Joe Carnuccio <joe.carnuccio@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Wolfram Sang <wsa+renesas@sang-engineering.com>, Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 5, 2017 at 11:02 AM, Olof's autobuilder <build@lixom.net> wrote:
> Here are the build results from automated periodic testing.
>
> The tree being built was next, found at:
>
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git (master branch)
>
> Topmost commit:
>
> f0090bf Add linux-next specific files for 20170605
>
> Build logs (stderr only) can be found at the following link (experimental):
>
> http://arm-soc.lixom.net/buildlogs/next/next-20170605/
> Warnings:
>
>       1 drivers/scsi/qla2xxx/qla_init.c:6407:50: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat=]
>       1 drivers/scsi/qla2xxx/qla_init.c:6709:50: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat=]

Caused by b95b9452aacf ("scsi: qla2xxx: Fix crash due to mismatch mumber
of Q-pair creation for Multi queue"): Need to use %zx instead of %lx for
printing a size_t

>       2 drivers/i2c/i2c-stub.c:18:0: warning: "DEBUG" redefined

Caused by 6c42778780c4 ("i2c: stub: use pr_fmt"): "#define DEBUG"
now conflicts with "ccflags-$(CONFIG_I2C_DEBUG_CORE) := -DDEBUG"
in the Makefile.

>     109 drivers/usb/dwc2/hw.h:230:0: warning: "GUID" redefined

This was introduced yesterday, but appears to be fixed again already.

       Arnd
