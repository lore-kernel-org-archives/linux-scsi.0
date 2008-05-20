From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 03:02:32 -0700
Message-ID: <20080520030232.fc91b64e.akpm@linux-foundation.org>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765904AbYETKEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 06:04:10 -0400
In-Reply-To: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> Converting class semaphore to mutex cause lockdep warnings due to
> class_interface_register/unregister will possible call device_add/del

Shouldn't we just fix that?

> For the class_interface users here add a class_reclassify macro to
> reclassify the lock class of their struct class.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> include/linux/device.h |    7 +++++++
> 1 file changed, 7 insertions(+)
> 
> --- linux/include/linux/device.h	2008-05-19 12:29:54.000000000 +0800
> +++ linux.new/include/linux/device.h	2008-05-19 14:42:25.000000000 +0800
> @@ -529,4 +529,11 @@ extern const char *dev_driver_string(str
>  	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
>  #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
>  	MODULE_ALIAS("char-major-" __stringify(major) "-*")
> +
> +#define class_reclassify(class)						\
> +do {									\
> +	static struct lock_class_key	class_key;			\
> +	lockdep_set_class_and_name(&(class)->mutex, &class_key,		\
> +				 (class)->name);			\
> +} while (0)
>  #endif /* _DEVICE_H_ */

I think it would need a lavish comment explaining what it is for, and
the reasons for its existence.

Perhaps this should be a kernel-wide thing in lockdep.h.  But then that
would invite people to use it, and it looks like a bad thing.

device.h does not include lockdep.h, so putting this here assumes that
callees have already included lockdep.h.  This is the sort of
assumption which leads to compilation errors.

