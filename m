From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: 3w-sas: Fix unterminated strncpy
Date: Tue, 30 Jul 2019 07:56:37 -0700
Message-ID: <1564498597.4300.10.camel@linux.ibm.com>
References: <20190730084047.26482-1-hslester96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190730084047.26482-1-hslester96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chuhong Yuan <hslester96@gmail.com>
Cc: Adam Radford <aradford@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-07-30 at 16:40 +0800, Chuhong Yuan wrote:
> strncpy(dest, src, strlen(src)) leads to unterminated
> dest, which is dangerous.

I don't buy that.  The structure is only used for the
TW_IOCTL_GET_COMPATIBILITY_INFO ioctl and all the fields for that are
fixed width and are copied over as such.

> Here driver_version's len is 32 and TW_DRIVER_VERSION
> is shorter than 32.
> Therefore strcpy is OK.

The best practice for copying a string to a fixed width destination
that does get printed within the kernel would be what the 3w-9xxx.c
does

	strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
		sizeof(tw_dev->tw_compat_info.driver_version));

But as I said, it doesn't really matter for a fixed width field that's
never printed within the kernel.

James
