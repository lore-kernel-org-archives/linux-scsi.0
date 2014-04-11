From: Filipe Brandenburger <filbranden@google.com>
Subject: aic94xx: maybe uninitialized variable in asd_process_ctrl_a_user
Date: Thu, 10 Apr 2014 22:13:11 -0700
Message-ID: <CADU+-uBr9UctHt1crnYAjYm5uNYmva2KDh5BZyZtkRG9_Xm-ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

While building a recent kernel with -Werror I found this warning:

drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
drivers/scsi/aic94xx/aic94xx_sds.c:597:21: error: 'offs' may be used
uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here

This looks like a valid complaint from the compiler, since in
asd_process_ctrl_a_user if the call to asd_find_flash_de fails (and
returns -ENOENT) then offs will not be set, but that will not prevent
the variable to be later passed to the call to asd_read_flash_seg
later in that same function.

Would you please have a look at it? Let me know if there's a more
appropriate way to report these issues (e.g. bug tracker.)

Thanks,
Filipe
