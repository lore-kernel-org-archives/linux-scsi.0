From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: smartpqi: mark PM functions as __maybe_unused
Date: Thu, 18 May 2017 11:09:16 +0200
Message-ID: <CAK8P3a2KD5aJanDcaRUHi2GeotJ_pfC_UY+KrWdYua1_k3GYow@mail.gmail.com>
References: <20170518083243.2927102-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35677 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbdERJJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 05:09:17 -0400
In-Reply-To: <20170518083243.2927102-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kevin Barnett <kevin.barnett@microsemi.com>

On Thu, May 18, 2017 at 10:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The newly added suspend/resume support causes harmless warnings
> when CONFIG_PM is disabled:
>
> smartpqi/smartpqi_init.c:5147:12: error: 'pqi_ctrl_wait_for_pending_io' defined but not used [-Werror=unused-function]
> smartpqi/smartpqi_init.c:2019:13: error: 'pqi_wait_until_lun_reset_finished' defined but not used [-Werror=unused-function]
> smartpqi/smartpqi_init.c:2013:13: error: 'pqi_wait_until_scan_finished' defined but not used [-Werror=unused-function]
>
> We can avoid the warnings by removing the #ifdef around the
> handlers and instead marking them as __maybe_unused, which will
> let gcc drop the unused code silently.
>
> Fixes: f44d210312a6 ("scsi: smartpqi: add suspend and resume support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I notice that today's linux-next no longer contains the patch that introduced
the warning.

     Arnd
