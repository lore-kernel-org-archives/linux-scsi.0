From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] aic94xx: fix handling of default CTRL-A settings
Date: Mon, 29 Oct 2012 11:42:20 +0100
Message-ID: <1351507340.1339.12.camel@x61.thuisdomein>
References: <1348574859.1436.38.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348574859.1436.38.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-09-25 at 14:07 +0200, Paul Bolle wrote:
> Compiling aic94xx_sds.o (part of the aic94xx driver) triggers this GCC
> warning:
>     drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
>     drivers/scsi/aic94xx/aic94xx_sds.c:597:21: warning: 'offs' may be used uninitialized in this function [-Wmaybe-uninitialized]
>     drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here
> 
> This warning can be traced back to asd_find_flash_de(). If it fails to
> find a FLASH_DE_CTRL_A_USER entry it will return without setting 'offs'.
> And that will leave 'offs' uninitialized when asd_read_flash_seg() is
> called a little later.
> 
> But that call of asd_read_flash_seg() isn't needed in that case.
> Everything this code cares about can already be found in the "default
> CTRL-A user settings section" that was created in the error path. So
> let's just jump over that call (and all other unneeded code) after
> creating that section.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed this warning while building v3.6-rc7 on current Fedora
> 17, using Fedora's default config.

And, again, identical warnings can be seen while building v3.7-rc3.
What's the status of my patch? Did anyone found some time to have a look
at it?


Paul Bolle
